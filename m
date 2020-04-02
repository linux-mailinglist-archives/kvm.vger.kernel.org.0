Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7176519BE3E
	for <lists+kvm@lfdr.de>; Thu,  2 Apr 2020 10:57:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387864AbgDBI5N (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 2 Apr 2020 04:57:13 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:52088 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S2387526AbgDBI5N (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 2 Apr 2020 04:57:13 -0400
Received: from pps.filterd (m0098417.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0328Y1K6097709
        for <kvm@vger.kernel.org>; Thu, 2 Apr 2020 04:57:11 -0400
Received: from e06smtp03.uk.ibm.com (e06smtp03.uk.ibm.com [195.75.94.99])
        by mx0a-001b2d01.pphosted.com with ESMTP id 304g8776up-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Thu, 02 Apr 2020 04:57:11 -0400
Received: from localhost
        by e06smtp03.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <kvm@vger.kernel.org> from <raspl@linux.ibm.com>;
        Thu, 2 Apr 2020 09:57:01 +0100
Received: from b06cxnps3075.portsmouth.uk.ibm.com (9.149.109.195)
        by e06smtp03.uk.ibm.com (192.168.101.133) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Thu, 2 Apr 2020 09:56:59 +0100
Received: from d06av23.portsmouth.uk.ibm.com (d06av23.portsmouth.uk.ibm.com [9.149.105.59])
        by b06cxnps3075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 0328v6uS30867578
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 2 Apr 2020 08:57:06 GMT
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id A21B0A4057;
        Thu,  2 Apr 2020 08:57:06 +0000 (GMT)
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 81729A4055;
        Thu,  2 Apr 2020 08:57:06 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by d06av23.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Thu,  2 Apr 2020 08:57:06 +0000 (GMT)
From:   Stefan Raspl <raspl@linux.ibm.com>
To:     kvm@vger.kernel.org
Cc:     pbonzini@redhat.com
Subject: [PATCH v2 1/3] tools/kvm_stat: add command line switch '-z' to skip zero records
Date:   Thu,  2 Apr 2020 10:57:03 +0200
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200402085705.61155-1-raspl@linux.ibm.com>
References: <20200402085705.61155-1-raspl@linux.ibm.com>
X-TM-AS-GCONF: 00
x-cbid: 20040208-0012-0000-0000-0000039CC7C3
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 20040208-0013-0000-0000-000021D9DAA1
Message-Id: <20200402085705.61155-2-raspl@linux.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.676
 definitions=2020-04-02_01:2020-03-31,2020-04-02 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 malwarescore=0 spamscore=0
 impostorscore=0 phishscore=0 priorityscore=1501 lowpriorityscore=0
 mlxlogscore=999 bulkscore=0 suspectscore=1 adultscore=0 mlxscore=0
 clxscore=1015 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2004020073
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Stefan Raspl <raspl@de.ibm.com>

When running in logging mode, skip records with all zeros (=empty records)
to preserve space when logging to files.

Signed-off-by: Stefan Raspl <raspl@linux.ibm.com>
---
 tools/kvm/kvm_stat/kvm_stat     | 28 ++++++++++++++++++++--------
 tools/kvm/kvm_stat/kvm_stat.txt |  4 ++++
 2 files changed, 24 insertions(+), 8 deletions(-)

diff --git a/tools/kvm/kvm_stat/kvm_stat b/tools/kvm/kvm_stat/kvm_stat
index e83fc8e868f4..d6cced4e1ef4 100755
--- a/tools/kvm/kvm_stat/kvm_stat
+++ b/tools/kvm/kvm_stat/kvm_stat
@@ -1500,8 +1500,7 @@ class StdFormat(object):
     def get_banner(self):
         return self._banner
 
-    @staticmethod
-    def get_statline(keys, s):
+    def get_statline(self, keys, s):
         res = ''
         for key in keys:
             res += ' %9d' % s[key].delta
@@ -1517,8 +1516,7 @@ class CSVFormat(object):
     def get_banner(self):
         return self._banner
 
-    @staticmethod
-    def get_statline(keys, s):
+    def get_statline(self, keys, s):
         return reduce(lambda res, key: "{},{!s}".format(res, s[key].delta),
                       keys, '')
 
@@ -1527,14 +1525,21 @@ def log(stats, opts, frmt, keys):
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
-            line += 1
+                banner_printed = True
+            values = stats.get()
+            if (not opts.skip_zero_records or
+                any(values[k].delta != 0 for k in keys)):
+                print(datetime.now().strftime("%Y-%m-%d %H:%M:%S") +
+                      frmt.get_statline(keys, values))
+                line += 1
+                banner_printed = False
         except KeyboardInterrupt:
             break
 
@@ -1655,9 +1660,16 @@ Press any other key to refresh statistics immediately.
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

