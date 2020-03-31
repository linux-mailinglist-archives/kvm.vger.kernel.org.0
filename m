Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D1C19199FA5
	for <lists+kvm@lfdr.de>; Tue, 31 Mar 2020 22:00:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730095AbgCaUAv (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 31 Mar 2020 16:00:51 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:64712 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729210AbgCaUAv (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 31 Mar 2020 16:00:51 -0400
Received: from pps.filterd (m0098409.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 02VJWgxC116103
        for <kvm@vger.kernel.org>; Tue, 31 Mar 2020 16:00:50 -0400
Received: from e06smtp04.uk.ibm.com (e06smtp04.uk.ibm.com [195.75.94.100])
        by mx0a-001b2d01.pphosted.com with ESMTP id 303wrwjmyy-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Tue, 31 Mar 2020 16:00:50 -0400
Received: from localhost
        by e06smtp04.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <kvm@vger.kernel.org> from <raspl@linux.ibm.com>;
        Tue, 31 Mar 2020 21:00:34 +0100
Received: from b06cxnps4074.portsmouth.uk.ibm.com (9.149.109.196)
        by e06smtp04.uk.ibm.com (192.168.101.134) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Tue, 31 Mar 2020 21:00:32 +0100
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (b06wcsmtp001.portsmouth.uk.ibm.com [9.149.105.160])
        by b06cxnps4074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 02VK0i9K35061792
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 31 Mar 2020 20:00:44 GMT
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id BFFFEA405C;
        Tue, 31 Mar 2020 20:00:44 +0000 (GMT)
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 9ED22A4054;
        Tue, 31 Mar 2020 20:00:44 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by b06wcsmtp001.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Tue, 31 Mar 2020 20:00:44 +0000 (GMT)
From:   Stefan Raspl <raspl@linux.ibm.com>
To:     kvm@vger.kernel.org
Cc:     pbonzini@redhat.com
Subject: [PATCH 1/3] tools/kvm_stat: add command line switch '-z' to skip zero records
Date:   Tue, 31 Mar 2020 22:00:40 +0200
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200331200042.2026-1-raspl@linux.ibm.com>
References: <20200331200042.2026-1-raspl@linux.ibm.com>
X-TM-AS-GCONF: 00
x-cbid: 20033120-0016-0000-0000-000002FBD95B
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 20033120-0017-0000-0000-0000335F9A3A
Message-Id: <20200331200042.2026-2-raspl@linux.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.676
 definitions=2020-03-31_07:2020-03-31,2020-03-31 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 lowpriorityscore=0
 mlxlogscore=999 clxscore=1015 bulkscore=0 malwarescore=0 suspectscore=1
 phishscore=0 priorityscore=1501 spamscore=0 adultscore=0 impostorscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2003020000
 definitions=main-2003310160
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Stefan Raspl <raspl@de.ibm.com>

When running in logging mode, skip records with all zeros (=empty records)
to preserve space when logging to files.

Signed-off-by: Stefan Raspl <raspl@linux.ibm.com>
---
 tools/kvm/kvm_stat/kvm_stat     | 47 +++++++++++++++++++++++++--------
 tools/kvm/kvm_stat/kvm_stat.txt |  4 +++
 2 files changed, 40 insertions(+), 11 deletions(-)

diff --git a/tools/kvm/kvm_stat/kvm_stat b/tools/kvm/kvm_stat/kvm_stat
index 7fe767bd2625..54000ac508f9 100755
--- a/tools/kvm/kvm_stat/kvm_stat
+++ b/tools/kvm/kvm_stat/kvm_stat
@@ -1488,7 +1488,8 @@ def batch(stats):
 
 
 class StdFormat(object):
-    def __init__(self, keys):
+    def __init__(self, keys, skip_zero_records):
+        self._skip_zero_records = skip_zero_records
         self._banner = ''
         for key in keys:
             self._banner += key.split(' ')[0] + ' '
@@ -1496,16 +1497,21 @@ class StdFormat(object):
     def get_banner(self):
         return self._banner
 
-    @staticmethod
-    def get_statline(keys, s):
+    def get_statline(self, keys, s):
         res = ''
+        non_zero = False
         for key in keys:
+            if s[key].delta != 0:
+                non_zero = True
             res += ' %9d' % s[key].delta
+        if self._skip_zero_records and not non_zero:
+            return ''
         return res
 
 
 class CSVFormat(object):
-    def __init__(self, keys):
+    def __init__(self, keys, skip_zero_records):
+        self._skip_zero_records = skip_zero_records
         self._banner = 'timestamp'
         self._banner += reduce(lambda res, key: "{},{!s}".format(res,
                                key.split(' ')[0]), keys, '')
@@ -1513,8 +1519,14 @@ class CSVFormat(object):
     def get_banner(self):
         return self._banner
 
-    @staticmethod
-    def get_statline(keys, s):
+    def get_statline(self, keys, s):
+        if self._skip_zero_records:
+            non_zero = False
+            for key in keys:
+                if s[key].delta != 0:
+                    non_zero = True
+            if self._skip_zero_records and not non_zero:
+                return ''
         return reduce(lambda res, key: "{},{!s}".format(res, s[key].delta),
                       keys, '')
 
@@ -1523,14 +1535,20 @@ def log(stats, opts, frmt, keys):
     """Prints statistics as reiterating key block, multiple value blocks."""
     line = 0
     banner_repeat = 20
+    banner_printed = False
+
     while True:
         try:
             time.sleep(opts.set_delay)
-            if line % banner_repeat == 0:
+            if line % banner_repeat == 0 and not banner_printed:
                 print(frmt.get_banner())
-            print(datetime.now().strftime("%Y-%m-%d %H:%M:%S") +
-                  frmt.get_statline(keys, stats.get()))
+                banner_printed = True
+            statline = frmt.get_statline(keys, stats.get())
+            if len(statline) == 0:
+                continue
+            print(datetime.now().strftime("%Y-%m-%d %H:%M:%S") + statline)
             line += 1
+            banner_printed = False
         except KeyboardInterrupt:
             break
 
@@ -1651,9 +1669,16 @@ Press any other key to refresh statistics immediately.
                            default=False,
                            help='retrieve statistics from tracepoints',
                            )
+    argparser.add_argument('-z', '--skip-zero-records',
+                           action='store_true',
+                           default=False,
+                           help='omit records with all zeros in logging mode',
+                           )
     options = argparser.parse_args()
     if options.csv and not options.log:
         sys.exit('Error: Option -c/--csv requires -l/--log')
+    if options.skip_zero_records and not options.log:
+        sys.exit('Error: Option -z/--skip-zero-records requires -l/--log')
     try:
         # verify that we were passed a valid regex up front
         re.compile(options.fields)
@@ -1736,9 +1761,9 @@ def main():
     if options.log:
         keys = sorted(stats.get().keys())
         if options.csv:
-            frmt = CSVFormat(keys)
+            frmt = CSVFormat(keys, options.skip_zero_records)
         else:
-            frmt = StdFormat(keys)
+            frmt = StdFormat(keys, options.skip_zero_records)
         log(stats, options, frmt, keys)
     elif not options.once:
         with Tui(stats, options) as tui:
diff --git a/tools/kvm/kvm_stat/kvm_stat.txt b/tools/kvm/kvm_stat/kvm_stat.txt
index a97ded2aedad..24296dccc00a 100644
--- a/tools/kvm/kvm_stat/kvm_stat.txt
+++ b/tools/kvm/kvm_stat/kvm_stat.txt
@@ -104,6 +104,10 @@ OPTIONS
 --tracepoints::
         retrieve statistics from tracepoints
 
+*z*::
+--skip-zero-records::
+        omit records with all zeros in logging mode
+
 SEE ALSO
 --------
 'perf'(1), 'trace-cmd'(1)
-- 
2.17.1

