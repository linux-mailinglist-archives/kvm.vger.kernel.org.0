Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D492C17BBE7
	for <lists+kvm@lfdr.de>; Fri,  6 Mar 2020 12:43:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726973AbgCFLnE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 6 Mar 2020 06:43:04 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:14538 "EHLO
        mx0b-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726894AbgCFLnE (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 6 Mar 2020 06:43:04 -0500
Received: from pps.filterd (m0127361.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 026Bgx4e084579
        for <kvm@vger.kernel.org>; Fri, 6 Mar 2020 06:43:03 -0500
Received: from e06smtp03.uk.ibm.com (e06smtp03.uk.ibm.com [195.75.94.99])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2yfkne7eg0-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Fri, 06 Mar 2020 06:43:02 -0500
Received: from localhost
        by e06smtp03.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <kvm@vger.kernel.org> from <raspl@linux.ibm.com>;
        Fri, 6 Mar 2020 11:42:56 -0000
Received: from b06cxnps4076.portsmouth.uk.ibm.com (9.149.109.198)
        by e06smtp03.uk.ibm.com (192.168.101.133) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Fri, 6 Mar 2020 11:42:54 -0000
Received: from d06av24.portsmouth.uk.ibm.com (mk.ibm.com [9.149.105.60])
        by b06cxnps4076.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 026BgrfT54132976
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 6 Mar 2020 11:42:53 GMT
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 21C3342047;
        Fri,  6 Mar 2020 11:42:53 +0000 (GMT)
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id EE45C42049;
        Fri,  6 Mar 2020 11:42:52 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by d06av24.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Fri,  6 Mar 2020 11:42:52 +0000 (GMT)
From:   Stefan Raspl <raspl@linux.ibm.com>
To:     kvm@vger.kernel.org
Cc:     rkrcmar@redhat.com, pbonzini@redhat.com
Subject: [PATCH 4/7] tools/kvm_stat: add command line switch '-c' to log in csv format
Date:   Fri,  6 Mar 2020 12:42:47 +0100
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200306114250.57585-1-raspl@linux.ibm.com>
References: <20200306114250.57585-1-raspl@linux.ibm.com>
X-TM-AS-GCONF: 00
x-cbid: 20030611-0012-0000-0000-0000038DBE9E
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 20030611-0013-0000-0000-000021CA80C0
Message-Id: <20200306114250.57585-5-raspl@linux.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.572
 definitions=2020-03-06_03:2020-03-06,2020-03-06 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 malwarescore=0 spamscore=0
 mlxlogscore=999 lowpriorityscore=0 priorityscore=1501 bulkscore=0
 adultscore=0 suspectscore=1 clxscore=1015 mlxscore=0 phishscore=0
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2001150001 definitions=main-2003060084
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Stefan Raspl <raspl@de.ibm.com>

Add an alternative format that can be more easily used for further
processing later on.
Note that we add a timestamp in the first column for both, the regular
and the new csv format.

Signed-off-by: Stefan Raspl <raspl@linux.ibm.com>
---
 tools/kvm/kvm_stat/kvm_stat     | 63 +++++++++++++++++++++++++--------
 tools/kvm/kvm_stat/kvm_stat.txt |  4 +++
 2 files changed, 53 insertions(+), 14 deletions(-)

diff --git a/tools/kvm/kvm_stat/kvm_stat b/tools/kvm/kvm_stat/kvm_stat
index 8ed25bf1d048..7fe767bd2625 100755
--- a/tools/kvm/kvm_stat/kvm_stat
+++ b/tools/kvm/kvm_stat/kvm_stat
@@ -33,6 +33,8 @@ import struct
 import re
 import subprocess
 from collections import defaultdict, namedtuple
+from functools import reduce
+from datetime import datetime
 
 VMX_EXIT_REASONS = {
     'EXCEPTION_NMI':        0,
@@ -1485,28 +1487,49 @@ def batch(stats):
         pass
 
 
-def log(stats, opts):
-    """Prints statistics as reiterating key block, multiple value blocks."""
-    keys = sorted(stats.get().keys())
-
-    def banner():
+class StdFormat(object):
+    def __init__(self, keys):
+        self._banner = ''
         for key in keys:
-            print(key.split(' ')[0], end=' ')
-        print()
+            self._banner += key.split(' ')[0] + ' '
 
-    def statline():
-        s = stats.get()
+    def get_banner(self):
+        return self._banner
+
+    @staticmethod
+    def get_statline(keys, s):
+        res = ''
         for key in keys:
-            print(' %9d' % s[key].delta, end=' ')
-        print()
+            res += ' %9d' % s[key].delta
+        return res
+
+
+class CSVFormat(object):
+    def __init__(self, keys):
+        self._banner = 'timestamp'
+        self._banner += reduce(lambda res, key: "{},{!s}".format(res,
+                               key.split(' ')[0]), keys, '')
+
+    def get_banner(self):
+        return self._banner
+
+    @staticmethod
+    def get_statline(keys, s):
+        return reduce(lambda res, key: "{},{!s}".format(res, s[key].delta),
+                      keys, '')
+
+
+def log(stats, opts, frmt, keys):
+    """Prints statistics as reiterating key block, multiple value blocks."""
     line = 0
     banner_repeat = 20
     while True:
         try:
             time.sleep(opts.set_delay)
             if line % banner_repeat == 0:
-                banner()
-            statline()
+                print(frmt.get_banner())
+            print(datetime.now().strftime("%Y-%m-%d %H:%M:%S") +
+                  frmt.get_statline(keys, stats.get()))
             line += 1
         except KeyboardInterrupt:
             break
@@ -1580,6 +1603,11 @@ Press any other key to refresh statistics immediately.
                            default=False,
                            help='run in batch mode for one second',
                            )
+    argparser.add_argument('-c', '--csv',
+                           action='store_true',
+                           default=False,
+                           help='log in csv format - requires option -l/--log',
+                           )
     argparser.add_argument('-d', '--debugfs',
                            action='store_true',
                            default=False,
@@ -1624,6 +1652,8 @@ Press any other key to refresh statistics immediately.
                            help='retrieve statistics from tracepoints',
                            )
     options = argparser.parse_args()
+    if options.csv and not options.log:
+        sys.exit('Error: Option -c/--csv requires -l/--log')
     try:
         # verify that we were passed a valid regex up front
         re.compile(options.fields)
@@ -1704,7 +1734,12 @@ def main():
         sys.exit(0)
 
     if options.log:
-        log(stats, options)
+        keys = sorted(stats.get().keys())
+        if options.csv:
+            frmt = CSVFormat(keys)
+        else:
+            frmt = StdFormat(keys)
+        log(stats, options, frmt, keys)
     elif not options.once:
         with Tui(stats, options) as tui:
             tui.show_stats()
diff --git a/tools/kvm/kvm_stat/kvm_stat.txt b/tools/kvm/kvm_stat/kvm_stat.txt
index 20928057cc9e..a97ded2aedad 100644
--- a/tools/kvm/kvm_stat/kvm_stat.txt
+++ b/tools/kvm/kvm_stat/kvm_stat.txt
@@ -64,6 +64,10 @@ OPTIONS
 --batch::
 	run in batch mode for one second
 
+-c::
+--csv=<file>::
+        log in csv format - requires option -l/--log
+
 -d::
 --debugfs::
 	retrieve statistics from debugfs
-- 
2.17.1

