Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B79E617BBE1
	for <lists+kvm@lfdr.de>; Fri,  6 Mar 2020 12:43:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726891AbgCFLm7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 6 Mar 2020 06:42:59 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:8358 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726054AbgCFLm7 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 6 Mar 2020 06:42:59 -0500
Received: from pps.filterd (m0098409.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 026Bd4cq160114
        for <kvm@vger.kernel.org>; Fri, 6 Mar 2020 06:42:58 -0500
Received: from e06smtp01.uk.ibm.com (e06smtp01.uk.ibm.com [195.75.94.97])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2yk33mwx3m-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Fri, 06 Mar 2020 06:42:58 -0500
Received: from localhost
        by e06smtp01.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <kvm@vger.kernel.org> from <raspl@linux.ibm.com>;
        Fri, 6 Mar 2020 11:42:56 -0000
Received: from b06cxnps4076.portsmouth.uk.ibm.com (9.149.109.198)
        by e06smtp01.uk.ibm.com (192.168.101.131) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Fri, 6 Mar 2020 11:42:54 -0000
Received: from d06av24.portsmouth.uk.ibm.com (mk.ibm.com [9.149.105.60])
        by b06cxnps4076.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 026Bgr3454132978
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 6 Mar 2020 11:42:53 GMT
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 58E4442041;
        Fri,  6 Mar 2020 11:42:53 +0000 (GMT)
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 2CA9F4204B;
        Fri,  6 Mar 2020 11:42:53 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by d06av24.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Fri,  6 Mar 2020 11:42:53 +0000 (GMT)
From:   Stefan Raspl <raspl@linux.ibm.com>
To:     kvm@vger.kernel.org
Cc:     rkrcmar@redhat.com, pbonzini@redhat.com
Subject: [PATCH 5/7] tools/kvm_stat: add rotating log support
Date:   Fri,  6 Mar 2020 12:42:48 +0100
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200306114250.57585-1-raspl@linux.ibm.com>
References: <20200306114250.57585-1-raspl@linux.ibm.com>
X-TM-AS-GCONF: 00
x-cbid: 20030611-4275-0000-0000-000003A8F1F1
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 20030611-4276-0000-0000-000038BE045D
Message-Id: <20200306114250.57585-6-raspl@linux.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.572
 definitions=2020-03-06_03:2020-03-06,2020-03-06 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 spamscore=0 bulkscore=0
 mlxscore=0 priorityscore=1501 suspectscore=6 lowpriorityscore=0
 clxscore=1015 malwarescore=0 impostorscore=0 phishscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2001150001 definitions=main-2003060084
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Stefan Raspl <raspl@de.ibm.com>

Add new command line switches -r to log output to a rotating set of
files. Number of files fixed to a total of 6 for now. Set maximum total

size via -S <size>, i.e. no file will exceed <size> / 6.
Note that each file has a header, so you can easily load each file
individually in an editor. On the downside, the first line of successive
files needs to be stripped in case somebody wants to concatenate them.

Signed-off-by: Stefan Raspl <raspl@linux.ibm.com>
---
 tools/kvm/kvm_stat/kvm_stat     | 119 ++++++++++++++++++++++++++++++--
 tools/kvm/kvm_stat/kvm_stat.txt |  13 +++-
 2 files changed, 126 insertions(+), 6 deletions(-)

diff --git a/tools/kvm/kvm_stat/kvm_stat b/tools/kvm/kvm_stat/kvm_stat
index 7fe767bd2625..2275ab1b070b 100755
--- a/tools/kvm/kvm_stat/kvm_stat
+++ b/tools/kvm/kvm_stat/kvm_stat
@@ -35,6 +35,10 @@ import subprocess
 from collections import defaultdict, namedtuple
 from functools import reduce
 from datetime import datetime
+import glob
+import string
+import logging
+from logging.handlers import RotatingFileHandler
 
 VMX_EXIT_REASONS = {
     'EXCEPTION_NMI':        0,
@@ -974,6 +978,8 @@ MAX_REGEX_LEN = 44
 SORT_DEFAULT = 0
 MIN_DELAY = 0.1
 MAX_DELAY = 25.5
+SIZE_DEFAULT = '10M'
+LOGCOUNT_DEFAULT = 6
 
 
 class Tui(object):
@@ -1535,6 +1541,64 @@ def log(stats, opts, frmt, keys):
             break
 
 
+def rotating_log(stats, opts, frmt, keys):
+    """Prints statistics to file in csv format."""
+    def init(opts, frmt):
+        # Regular RotatingFileHandler doesn't add a header to each file,
+        # so we create our own version
+        class MyRotatingFileHandler(RotatingFileHandler):
+            def __init__(self, logfile):
+                super(MyRotatingFileHandler,
+                      self).__init__(logfile, mode='w', maxBytes=opts.size_num,
+                                     backupCount=LOGCOUNT_DEFAULT-1)
+                self._header = ""
+                self._log = None
+
+            def doRollover(self):
+                super(MyRotatingFileHandler, self).doRollover()
+                if self._log is not None and self._header != "":
+                    self._log.debug(self._header)
+
+            def setHeader(self, header, log):
+                self._header = header
+                self._log = log
+                if not self.stream or self.stream.tell() == 0:
+                    self._log.debug(self._header)
+
+        # Regular Formatter would prepend a timestamp to the header,
+        # so we create our own version again
+        class MyFormatter(logging.Formatter):
+            def __init__(self, fmt, datefmt):
+                logging.Formatter.__init__(self, fmt=fmt, datefmt=datefmt)
+
+            def format(self, record):
+                if record.levelno == logging.DEBUG:
+                    return record.getMessage()
+                return logging.Formatter.format(self, record)
+        try:
+            hdl = MyRotatingFileHandler(opts.rotating_log)
+        except:
+            sys.exit("Error setting up csv log with file '%s'"
+                     % opts.rotating_log)
+        formatter = MyFormatter('%(asctime)s%(message)s', '%Y-%m-%d %H:%M:%S')
+        hdl.setFormatter(formatter)
+
+        logger = logging.getLogger('MyLogger')
+        logger.setLevel(logging.DEBUG)
+        logger.addHandler(hdl)
+        hdl.setHeader(frmt.get_banner(), logger)
+
+        return logger
+
+    log = init(opts, frmt)
+    while True:
+        try:
+            time.sleep(opts.set_delay)
+            log.info(frmt.get_statline(keys, stats.get()))
+        except KeyboardInterrupt:
+            break
+
+
 def is_delay_valid(delay):
     """Verify delay is in valid value range."""
     msg = None
@@ -1580,6 +1644,26 @@ Interactive Commands:
 Press any other key to refresh statistics immediately.
 """ % (PATH_DEBUGFS_KVM, PATH_DEBUGFS_TRACING)
 
+    def convert_from_si(opts):
+        try:
+            factor = 1000000
+            num = int(opts.size.rstrip(string.ascii_letters))
+            unit = opts.size.lstrip(string.digits)
+        except ValueError:
+            sys.exit("Error: Invalid argument to -S/--size: '%s'" % opts.size)
+        if num <= 0:
+            sys.exit("Error: Argument to -S/--size must be >0")
+        if unit != '':
+            if unit in ['m', 'M']:
+                factor = 1000000
+            elif unit in ['g', 'G']:
+                factor = 1000000000
+            elif unit in ['t', 'T']:
+                factor = 1000000000000
+            else:
+                sys.exit("Error: Unsupported unit suffix '%s'" % unit)
+        opts.size_num = int(num * factor / LOGCOUNT_DEFAULT)
+
     class Guest_to_pid(argparse.Action):
         def __call__(self, parser, namespace, values, option_string=None):
             try:
@@ -1606,7 +1690,8 @@ Press any other key to refresh statistics immediately.
     argparser.add_argument('-c', '--csv',
                            action='store_true',
                            default=False,
-                           help='log in csv format - requires option -l/--log',
+                           help='log in csv format - requires option -l/--log '
+                                'or -r/--rotating-log'
                            )
     argparser.add_argument('-d', '--debugfs',
                            action='store_true',
@@ -1639,6 +1724,12 @@ Press any other key to refresh statistics immediately.
                            default=0,
                            help='restrict statistics to pid',
                            )
+    argparser.add_argument('-r', '--rotating-log',
+                           type=str,
+                           default='',
+                           metavar='FILE',
+                           help='write a rotating log to FILE'
+                           )
     argparser.add_argument('-s', '--set-delay',
                            type=float,
                            default=DELAY_DEFAULT,
@@ -1646,14 +1737,28 @@ Press any other key to refresh statistics immediately.
                            help='set delay between refreshs (value range: '
                                 '%s-%s secs)' % (MIN_DELAY, MAX_DELAY),
                            )
+    argparser.add_argument('-S', '--size',
+                           type=str,
+                           default='',
+                           help='''maximum total file size
+supported suffixes: MGT (Megabytes (default), Gigabytes, Terabytes)
+default: %s''' % SIZE_DEFAULT,
+                           )
     argparser.add_argument('-t', '--tracepoints',
                            action='store_true',
                            default=False,
                            help='retrieve statistics from tracepoints',
                            )
     options = argparser.parse_args()
-    if options.csv and not options.log:
-        sys.exit('Error: Option -c/--csv requires -l/--log')
+    if options.csv and not options.log and not options.rotating_log:
+        sys.exit('Error: Option -c/--csv requires one of -l/--log or '
+                 '-r/--rotating-log')
+    if options.rotating_log:
+        if options.log:
+            sys.exit('Error: Cannot mix -l/--log and -r/--rotating-log')
+        if not options.size:
+            options.size = SIZE_DEFAULT
+        convert_from_si(options)
     try:
         # verify that we were passed a valid regex up front
         re.compile(options.fields)
@@ -1733,13 +1838,17 @@ def main():
         sys.stdout.write('  ' + '\n  '.join(sorted(set(event_list))) + '\n')
         sys.exit(0)
 
-    if options.log:
+    if options.log or options.rotating_log:
         keys = sorted(stats.get().keys())
         if options.csv:
             frmt = CSVFormat(keys)
         else:
             frmt = StdFormat(keys)
-        log(stats, options, frmt, keys)
+
+        if options.log:
+            log(stats, options, frmt, keys)
+        else:
+            rotating_log(stats, options, frmt, keys)
     elif not options.once:
         with Tui(stats, options) as tui:
             tui.show_stats()
diff --git a/tools/kvm/kvm_stat/kvm_stat.txt b/tools/kvm/kvm_stat/kvm_stat.txt
index a97ded2aedad..35df0b1261a2 100644
--- a/tools/kvm/kvm_stat/kvm_stat.txt
+++ b/tools/kvm/kvm_stat/kvm_stat.txt
@@ -66,7 +66,7 @@ OPTIONS
 
 -c::
 --csv=<file>::
-        log in csv format - requires option -l/--log
+        log in csv format - requires option -l/--log or -r/--rotating-log
 
 -d::
 --debugfs::
@@ -96,10 +96,21 @@ OPTIONS
 --pid=<pid>::
 	limit statistics to one virtual machine (pid)
 
+-r<file>::
+--rotating-log=<file>::
+	log output to rotating logfiles prefixed <file> - also
+            see option -S/--size
+
 -s::
 --set-delay::
         set delay between refreshs (value range: 0.1-25.5 secs)
 
+-S<size>::
+--size=<size>::
+	maximum total file size for option -r/--rotating-log.
+            Supported suffixes: MGT (Megabytes (default), Gigabytes, Terabytes).
+            Default: 10M
+
 -t::
 --tracepoints::
         retrieve statistics from tracepoints
-- 
2.17.1

