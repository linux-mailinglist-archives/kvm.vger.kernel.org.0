Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DD7D917BBE3
	for <lists+kvm@lfdr.de>; Fri,  6 Mar 2020 12:43:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726905AbgCFLnA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 6 Mar 2020 06:43:00 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:12478 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726769AbgCFLnA (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 6 Mar 2020 06:43:00 -0500
Received: from pps.filterd (m0098410.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 026BcsYH002535
        for <kvm@vger.kernel.org>; Fri, 6 Mar 2020 06:42:59 -0500
Received: from e06smtp01.uk.ibm.com (e06smtp01.uk.ibm.com [195.75.94.97])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2yj4q3ndkq-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Fri, 06 Mar 2020 06:42:58 -0500
Received: from localhost
        by e06smtp01.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <kvm@vger.kernel.org> from <raspl@linux.ibm.com>;
        Fri, 6 Mar 2020 11:42:56 -0000
Received: from b06cxnps4075.portsmouth.uk.ibm.com (9.149.109.197)
        by e06smtp01.uk.ibm.com (192.168.101.131) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Fri, 6 Mar 2020 11:42:53 -0000
Received: from d06av24.portsmouth.uk.ibm.com (d06av24.portsmouth.uk.ibm.com [9.149.105.60])
        by b06cxnps4075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 026BgqwL51445780
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 6 Mar 2020 11:42:53 GMT
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id E338D42047;
        Fri,  6 Mar 2020 11:42:52 +0000 (GMT)
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id BC1FB42045;
        Fri,  6 Mar 2020 11:42:52 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by d06av24.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Fri,  6 Mar 2020 11:42:52 +0000 (GMT)
From:   Stefan Raspl <raspl@linux.ibm.com>
To:     kvm@vger.kernel.org
Cc:     rkrcmar@redhat.com, pbonzini@redhat.com
Subject: [PATCH 3/7] tools/kvm_stat: add command line switch '-s' to set update interval
Date:   Fri,  6 Mar 2020 12:42:46 +0100
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200306114250.57585-1-raspl@linux.ibm.com>
References: <20200306114250.57585-1-raspl@linux.ibm.com>
X-TM-AS-GCONF: 00
x-cbid: 20030611-4275-0000-0000-000003A8F1F0
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 20030611-4276-0000-0000-000038BE045C
Message-Id: <20200306114250.57585-4-raspl@linux.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.572
 definitions=2020-03-06_03:2020-03-06,2020-03-06 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0
 suspectscore=1 adultscore=0 bulkscore=0 mlxscore=0 lowpriorityscore=0
 phishscore=0 malwarescore=0 priorityscore=1501 spamscore=0 mlxlogscore=999
 clxscore=1015 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2001150001 definitions=main-2003060084
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Stefan Raspl <raspl@de.ibm.com>

This now controls both, the refresh rate of the interactive mode as well
as the logging mode. Which, as a consequence, means that the default of
logging mode is now 3s, too (use command line switch '-s' to adjust to
your liking).

Signed-off-by: Stefan Raspl <raspl@linux.ibm.com>
---
 tools/kvm/kvm_stat/kvm_stat     | 46 ++++++++++++++++++++++++---------
 tools/kvm/kvm_stat/kvm_stat.txt |  4 +++
 2 files changed, 38 insertions(+), 12 deletions(-)

diff --git a/tools/kvm/kvm_stat/kvm_stat b/tools/kvm/kvm_stat/kvm_stat
index 2d9947f596fc..8ed25bf1d048 100755
--- a/tools/kvm/kvm_stat/kvm_stat
+++ b/tools/kvm/kvm_stat/kvm_stat
@@ -970,15 +970,17 @@ DELAY_DEFAULT = 3.0
 MAX_GUEST_NAME_LEN = 48
 MAX_REGEX_LEN = 44
 SORT_DEFAULT = 0
+MIN_DELAY = 0.1
+MAX_DELAY = 25.5
 
 
 class Tui(object):
     """Instruments curses to draw a nice text ui."""
-    def __init__(self, stats):
+    def __init__(self, stats, opts):
         self.stats = stats
         self.screen = None
         self._delay_initial = 0.25
-        self._delay_regular = DELAY_DEFAULT
+        self._delay_regular = opts.set_delay
         self._sorting = SORT_DEFAULT
         self._display_guests = 0
 
@@ -1278,7 +1280,8 @@ class Tui(object):
                '   p     filter by guest name/PID',
                '   q     quit',
                '   r     reset stats',
-               '   s     set update interval',
+               '   s     set delay between refreshs (value range: '
+               '%s-%s secs)' % (MIN_DELAY, MAX_DELAY),
                '   x     toggle reporting of stats for individual child trace'
                ' events',
                'Any other key refreshes statistics immediately')
@@ -1344,11 +1347,9 @@ class Tui(object):
             try:
                 if len(val) > 0:
                     delay = float(val)
-                    if delay < 0.1:
-                        msg = '"' + str(val) + '": Value must be >=0.1'
-                        continue
-                    if delay > 25.5:
-                        msg = '"' + str(val) + '": Value must be <=25.5'
+                    err = is_delay_valid(delay)
+                    if err is not None:
+                        msg = err
                         continue
                 else:
                     delay = DELAY_DEFAULT
@@ -1484,7 +1485,7 @@ def batch(stats):
         pass
 
 
-def log(stats):
+def log(stats, opts):
     """Prints statistics as reiterating key block, multiple value blocks."""
     keys = sorted(stats.get().keys())
 
@@ -1502,7 +1503,7 @@ def log(stats):
     banner_repeat = 20
     while True:
         try:
-            time.sleep(1)
+            time.sleep(opts.set_delay)
             if line % banner_repeat == 0:
                 banner()
             statline()
@@ -1511,6 +1512,16 @@ def log(stats):
             break
 
 
+def is_delay_valid(delay):
+    """Verify delay is in valid value range."""
+    msg = None
+    if delay < MIN_DELAY:
+        msg = '"' + str(delay) + '": Delay must be >=%s' % MIN_DELAY
+    if delay > MAX_DELAY:
+        msg = '"' + str(delay) + '": Delay must be <=%s' % MAX_DELAY
+    return msg
+
+
 def get_options():
     """Returns processed program arguments."""
     description_text = """
@@ -1600,6 +1611,13 @@ Press any other key to refresh statistics immediately.
                            default=0,
                            help='restrict statistics to pid',
                            )
+    argparser.add_argument('-s', '--set-delay',
+                           type=float,
+                           default=DELAY_DEFAULT,
+                           metavar='DELAY',
+                           help='set delay between refreshs (value range: '
+                                '%s-%s secs)' % (MIN_DELAY, MAX_DELAY),
+                           )
     argparser.add_argument('-t', '--tracepoints',
                            action='store_true',
                            default=False,
@@ -1671,6 +1689,10 @@ def main():
         sys.stderr.write('Did you use a (unsupported) tid instead of a pid?\n')
         sys.exit('Specified pid does not exist.')
 
+    err = is_delay_valid(options.set_delay)
+    if err is not None:
+        sys.exit('Error: ' + err)
+
     stats = Stats(options)
 
     if options.fields == 'help':
@@ -1682,9 +1704,9 @@ def main():
         sys.exit(0)
 
     if options.log:
-        log(stats)
+        log(stats, options)
     elif not options.once:
-        with Tui(stats) as tui:
+        with Tui(stats, options) as tui:
             tui.show_stats()
     else:
         batch(stats)
diff --git a/tools/kvm/kvm_stat/kvm_stat.txt b/tools/kvm/kvm_stat/kvm_stat.txt
index 8e0658e79eb7..20928057cc9e 100644
--- a/tools/kvm/kvm_stat/kvm_stat.txt
+++ b/tools/kvm/kvm_stat/kvm_stat.txt
@@ -92,6 +92,10 @@ OPTIONS
 --pid=<pid>::
 	limit statistics to one virtual machine (pid)
 
+-s::
+--set-delay::
+        set delay between refreshs (value range: 0.1-25.5 secs)
+
 -t::
 --tracepoints::
         retrieve statistics from tracepoints
-- 
2.17.1

