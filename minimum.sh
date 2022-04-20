#!/usr/bin/env bash

# Cristian Stroparo's Minimalist Shell Script Library
# See the projects's website for more details at
# https://github.com/stroparo/minimum-shell

# ##############################################################################
# Globals

export PROGNAME="$(basename ${0})"

# ##############################################################################
# Functions

# Requirements: PROGNAME global exported and setup to the program's name.
_set_log () {
    export LOGDIR="${1:-.}"
    export LOGFILE="${LOGDIR}/${PROGNAME%.*}_$(date '+%Y%m%d_%OH%OM%OS').log"

    # Truncate:
    > "${LOGFILE}" || exit 1

    echo "Logging to file: '${LOGFILE}'"

    _exec test -d "${LOGDIR}"
    _exec test -f "${LOGFILE}"
}

_log () {
    typeset oldind="${OPTIND}"
    typeset thislog="${LOGFILE}"

    OPTIND=1
    while getopts ':l:' opt ; do
      case "${opt}" in
        l) thislog="${OPTARG}" ;;
      esac
    done
    shift $((OPTIND - 1)) ; OPTIND="${oldind}"

    echo "$@" | tee -a "${thislog}"
}

_verify () {
    typeset result="$?"

    if [ "${result}" -ne 0 ] ; then
        _log "Failed (${result}) for:" "$@"
        _log "This program's logs: ${LOGFILE}"
        _log "Check the logs or call the relevant area/team."
        exit 1
    else
        _log "Success (0) for:" "$@"
        _log ''
    fi
}

# Remarks: When using -o option ALWAYS place it after -l because logging also redirects.
_exec () {
    typeset oldind="${OPTIND}"
    typeset message
    typeset thislog="${LOGFILE}"
    typeset outfile="${LOGFILE}"

    OPTIND=1
    while getopts ':l:m:o:' opt ; do
      case "${opt}" in
        l)
            thislog="${OPTARG}"
            outfile="${OPTARG}"
            ;;
        m)  message="${OPTARG}" ;;
        o)
            # IMPORTANT: use -o after -l, because -l also sets up this output.
            outfile="${OPTARG}"
            > "${outfile}"
            _verify "Truncating output file '${outfile}'."
            ;;
      esac
    done
    shift $((OPTIND - 1)) ; OPTIND="${oldind}"

    : "${message:=$@}"

    if [ "${thislog}" != "${LOGFILE}" ] ; then
        _log "Next task: ${message}"
        _log ".. will be logged to '${thislog}'."
    fi

    _log -l "${thislog}" "Task: ${message}"
    "$@" >>"${outfile}" 2>>"${thislog}"
    _verify "$@"
}

# ##############################################################################
# Prep

_set_log 'YOUR-LOG-DIR-HERE'

# Put your code here.

# ##############################################################################
# Main

# Put your code here.

# ##############################################################################
# Cleanup

# Put your code here.

