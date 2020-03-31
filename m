Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BAF4A199FA7
	for <lists+kvm@lfdr.de>; Tue, 31 Mar 2020 22:00:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730413AbgCaUAx (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 31 Mar 2020 16:00:53 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:63784 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727837AbgCaUAv (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 31 Mar 2020 16:00:51 -0400
Received: from pps.filterd (m0187473.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 02VJXbeZ050877
        for <kvm@vger.kernel.org>; Tue, 31 Mar 2020 16:00:50 -0400
Received: from e06smtp05.uk.ibm.com (e06smtp05.uk.ibm.com [195.75.94.101])
        by mx0a-001b2d01.pphosted.com with ESMTP id 30227wc9qw-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Tue, 31 Mar 2020 16:00:50 -0400
Received: from localhost
        by e06smtp05.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <kvm@vger.kernel.org> from <raspl@linux.ibm.com>;
        Tue, 31 Mar 2020 21:00:32 +0100
Received: from b06avi18626390.portsmouth.uk.ibm.com (9.149.26.192)
        by e06smtp05.uk.ibm.com (192.168.101.135) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Tue, 31 Mar 2020 21:00:30 +0100
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (b06wcsmtp001.portsmouth.uk.ibm.com [9.149.105.160])
        by b06avi18626390.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 02VJxfvp35520908
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 31 Mar 2020 19:59:41 GMT
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id ECD06A405F;
        Tue, 31 Mar 2020 20:00:44 +0000 (GMT)
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id CB402A405B;
        Tue, 31 Mar 2020 20:00:44 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by b06wcsmtp001.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Tue, 31 Mar 2020 20:00:44 +0000 (GMT)
From:   Stefan Raspl <raspl@linux.ibm.com>
To:     kvm@vger.kernel.org
Cc:     pbonzini@redhat.com
Subject: [PATCH 2/3] tools/kvm_stat: Add command line switch '-L' to log to file
Date:   Tue, 31 Mar 2020 22:00:41 +0200
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200331200042.2026-1-raspl@linux.ibm.com>
References: <20200331200042.2026-1-raspl@linux.ibm.com>
X-TM-AS-GCONF: 00
x-cbid: 20033120-0020-0000-0000-000003BF20F1
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 20033120-0021-0000-0000-00002217C32A
Message-Id: <20200331200042.2026-3-raspl@linux.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.676
 definitions=2020-03-31_07:2020-03-31,2020-03-31 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 adultscore=0
 priorityscore=1501 phishscore=0 malwarescore=0 mlxscore=0 bulkscore=0
 impostorscore=0 spamscore=0 suspectscore=1 mlxlogscore=999
 lowpriorityscore=0 clxscore=1015 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2003020000 definitions=main-2003310164
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Stefan Raspl <raspl@de.ibm.com>

To integrate with logrotate, we have a signal handler that will re-open
the logfile.
Assuming we have a systemd unit file with
     ExecStart=kvm_stat -dtc -s 10 -L /var/log/kvm_stat.csv
     ExecReload=/bin/kill -HUP $MAINPID
and a logrotate config featuring
     postrotate
        /bin/systemctl restart kvm_stat.service
     endscript
Then the overall flow will look like this:
(1) systemd starts kvm_stat, logging to A.
(2) At some point, logrotate runs, moving A to B.
    kvm_stat continues to write to B at this point.
(3) After rotating, logrotate restarts the kvm_stat unit via systemctl.
(4) The kvm_stat unit sends a SIGHUP to kvm_stat, finally making it
    switch over to writing to A again.
Note that in order to keep the structure of the cvs output in tact, we
make sure to, in contrast to the standard log format, only write the
header once at the beginning of a file. This implies that the header is
suppressed when appending to an existing file. Unlike the standard
format, where we append to an existing file by starting out with a
header.

Signed-off-by: Stefan Raspl <raspl@linux.ibm.com>
---
 tools/kvm/kvm_stat/kvm_stat     | 75 +++++++++++++++++++++++++++++----
 tools/kvm/kvm_stat/kvm_stat.txt |  5 +++
 2 files changed, 71 insertions(+), 9 deletions(-)

diff --git a/tools/kvm/kvm_stat/kvm_stat b/tools/kvm/kvm_stat/kvm_stat
index 54000ac508f9..e4f67f0629ee 100755
--- a/tools/kvm/kvm_stat/kvm_stat
+++ b/tools/kvm/kvm_stat/kvm_stat
@@ -32,6 +32,7 @@ import resource
 import struct
 import re
 import subprocess
+import signal
 from collections import defaultdict, namedtuple
 from functools import reduce
 from datetime import datetime
@@ -228,6 +229,8 @@ IOCTL_NUMBERS = {
     'RESET':       0x00002403,
 }
 
+signal_received = False
+
 ENCODING = locale.getpreferredencoding(False)
 TRACE_FILTER = re.compile(r'^[^\(]*$')
 
@@ -1533,25 +1536,73 @@ class CSVFormat(object):
 
 def log(stats, opts, frmt, keys):
     """Prints statistics as reiterating key block, multiple value blocks."""
+    global signal_received
     line = 0
     banner_repeat = 20
-    banner_printed = False
+    f = None
+
+    def do_banner(opts):
+        nonlocal f
+        if opts.log_to_file:
+            if not f:
+                try:
+                     f = open(opts.log_to_file, 'a')
+                except (IOError, OSError):
+                    sys.exit("Error: Could not open file: %s" %
+                             opts.log_to_file)
+                if isinstance(frmt, CSVFormat) and f.tell() != 0:
+                    return
+            f.write(frmt.get_banner())
+            f.write('\n')
+        else:
+            print(frmt.get_banner())
+
+    def do_statline(opts):
+        statline = frmt.get_statline(keys, stats.get())
+        if len(statline) == 0:
+            return False
+        statline = datetime.now().strftime("%Y-%m-%d %H:%M:%S") + statline
+        if opts.log_to_file:
+            f.write(statline)
+            f.write('\n')
+        else:
+            print(statline)
 
+        return True
+
+    do_banner(opts)
+    banner_printed = True
     while True:
         try:
             time.sleep(opts.set_delay)
-            if line % banner_repeat == 0 and not banner_printed:
-                print(frmt.get_banner())
+            if signal_received:
+                banner_printed = True
+                line = 0
+                f.close()
+                do_banner(opts)
+                signal_received = False
+            if (line % banner_repeat == 0 and not banner_printed and
+                not (opts.log_to_file and isinstance(frmt, CSVFormat))):
+                do_banner(opts)
                 banner_printed = True
-            statline = frmt.get_statline(keys, stats.get())
-            if len(statline) == 0:
+            if not do_statline(opts):
                 continue
-            print(datetime.now().strftime("%Y-%m-%d %H:%M:%S") + statline)
             line += 1
             banner_printed = False
         except KeyboardInterrupt:
             break
 
+    if opts.log_to_file:
+        f.close()
+
+
+def handle_signal(sig, frame):
+    global signal_received
+
+    signal_received = True
+
+    return
+
 
 def is_delay_valid(delay):
     """Verify delay is in valid value range."""
@@ -1652,6 +1703,10 @@ Press any other key to refresh statistics immediately.
                            default=False,
                            help='run in logging mode (like vmstat)',
                            )
+    argparser.add_argument('-L', '--log-to-file',
+                           type=str,
+                           help="like '--log', but logging to a file"
+                           )
     argparser.add_argument('-p', '--pid',
                            type=int,
                            default=0,
@@ -1675,9 +1730,9 @@ Press any other key to refresh statistics immediately.
                            help='omit records with all zeros in logging mode',
                            )
     options = argparser.parse_args()
-    if options.csv and not options.log:
+    if options.csv and not (options.log or options.log_to_file):
         sys.exit('Error: Option -c/--csv requires -l/--log')
-    if options.skip_zero_records and not options.log:
+    if options.skip_zero_records and not (options.log or options.log_to_file):
         sys.exit('Error: Option -z/--skip-zero-records requires -l/--log')
     try:
         # verify that we were passed a valid regex up front
@@ -1758,7 +1813,9 @@ def main():
         sys.stdout.write('  ' + '\n  '.join(sorted(set(event_list))) + '\n')
         sys.exit(0)
 
-    if options.log:
+    if options.log or options.log_to_file:
+        if options.log_to_file:
+            signal.signal(signal.SIGHUP, handle_signal)
         keys = sorted(stats.get().keys())
         if options.csv:
             frmt = CSVFormat(keys, options.skip_zero_records)
diff --git a/tools/kvm/kvm_stat/kvm_stat.txt b/tools/kvm/kvm_stat/kvm_stat.txt
index 24296dccc00a..de7c4a2497f9 100644
--- a/tools/kvm/kvm_stat/kvm_stat.txt
+++ b/tools/kvm/kvm_stat/kvm_stat.txt
@@ -92,6 +92,11 @@ OPTIONS
 --log::
         run in logging mode (like vmstat)
 
+
+-L::
+--log-to-file::
+        like '--log', but logging to a file
+
 -p<pid>::
 --pid=<pid>::
 	limit statistics to one virtual machine (pid)
-- 
2.17.1

