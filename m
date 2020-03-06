Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 69A8917BBE4
	for <lists+kvm@lfdr.de>; Fri,  6 Mar 2020 12:43:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726915AbgCFLnB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 6 Mar 2020 06:43:01 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:53306 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726702AbgCFLnA (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 6 Mar 2020 06:43:00 -0500
Received: from pps.filterd (m0098420.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 026BdOkj039644
        for <kvm@vger.kernel.org>; Fri, 6 Mar 2020 06:42:59 -0500
Received: from e06smtp04.uk.ibm.com (e06smtp04.uk.ibm.com [195.75.94.100])
        by mx0b-001b2d01.pphosted.com with ESMTP id 2ykatam6wp-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Fri, 06 Mar 2020 06:42:58 -0500
Received: from localhost
        by e06smtp04.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <kvm@vger.kernel.org> from <raspl@linux.ibm.com>;
        Fri, 6 Mar 2020 11:42:57 -0000
Received: from b06cxnps4075.portsmouth.uk.ibm.com (9.149.109.197)
        by e06smtp04.uk.ibm.com (192.168.101.134) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Fri, 6 Mar 2020 11:42:53 -0000
Received: from d06av24.portsmouth.uk.ibm.com (d06av24.portsmouth.uk.ibm.com [9.149.105.60])
        by b06cxnps4075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 026Bgqt548824374
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 6 Mar 2020 11:42:52 GMT
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id B0DB342049;
        Fri,  6 Mar 2020 11:42:52 +0000 (GMT)
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 803B442047;
        Fri,  6 Mar 2020 11:42:52 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by d06av24.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Fri,  6 Mar 2020 11:42:52 +0000 (GMT)
From:   Stefan Raspl <raspl@linux.ibm.com>
To:     kvm@vger.kernel.org
Cc:     rkrcmar@redhat.com, pbonzini@redhat.com
Subject: [PATCH 2/7] tools/kvm_stat: switch to argparse
Date:   Fri,  6 Mar 2020 12:42:45 +0100
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200306114250.57585-1-raspl@linux.ibm.com>
References: <20200306114250.57585-1-raspl@linux.ibm.com>
X-TM-AS-GCONF: 00
x-cbid: 20030611-0016-0000-0000-000002EDC084
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 20030611-0017-0000-0000-000033511848
Message-Id: <20200306114250.57585-3-raspl@linux.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.572
 definitions=2020-03-06_03:2020-03-06,2020-03-06 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 bulkscore=0 spamscore=0
 suspectscore=1 clxscore=1015 lowpriorityscore=0 priorityscore=1501
 mlxlogscore=999 malwarescore=0 phishscore=0 mlxscore=0 impostorscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2001150001 definitions=main-2003060084
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Stefan Raspl <raspl@de.ibm.com>

optparse is deprecated for a while, hence switching over to argparse
(which also works with python2).
As a consequence, help output has some subtle changes, the most
significant one being that the options are all listed explicitly
instead of a universal '[options]' indicator. Also, some of the error
messages are phrased slightly different.
While at it, squashed a number of minor PEP8 issues.

Signed-off-by: Stefan Raspl <raspl@linux.ibm.com>
---
 tools/kvm/kvm_stat/kvm_stat | 142 ++++++++++++++++--------------------
 1 file changed, 62 insertions(+), 80 deletions(-)

diff --git a/tools/kvm/kvm_stat/kvm_stat b/tools/kvm/kvm_stat/kvm_stat
index 8fa39eb43f64..2d9947f596fc 100755
--- a/tools/kvm/kvm_stat/kvm_stat
+++ b/tools/kvm/kvm_stat/kvm_stat
@@ -25,7 +25,7 @@ import sys
 import locale
 import os
 import time
-import optparse
+import argparse
 import ctypes
 import fcntl
 import resource
@@ -869,7 +869,7 @@ class Stats(object):
 
         if options.debugfs:
             providers.append(DebugfsProvider(options.pid, options.fields,
-                                             options.dbgfs_include_past))
+                                             options.debugfs_include_past))
         if options.tracepoints or not providers:
             providers.append(TracepointProvider(options.pid, options.fields))
 
@@ -1546,84 +1546,66 @@ Interactive Commands:
 Press any other key to refresh statistics immediately.
 """ % (PATH_DEBUGFS_KVM, PATH_DEBUGFS_TRACING)
 
-    class PlainHelpFormatter(optparse.IndentedHelpFormatter):
-        def format_description(self, description):
-            if description:
-                return description + "\n"
-            else:
-                return ""
-
-    def cb_guest_to_pid(option, opt, val, parser):
-        try:
-            pids = Tui.get_pid_from_gname(val)
-        except:
-            sys.exit('Error while searching for guest "{}". Use "-p" to '
-                     'specify a pid instead?'.format(val))
-        if len(pids) == 0:
-            sys.exit('Error: No guest by the name "{}" found'.format(val))
-        if len(pids) > 1:
-            sys.exit('Error: Multiple processes found (pids: {}). Use "-p" '
-                     'to specify the desired pid'.format(" ".join(pids)))
-        parser.values.pid = pids[0]
-
-    optparser = optparse.OptionParser(description=description_text,
-                                      formatter=PlainHelpFormatter())
-    optparser.add_option('-1', '--once', '--batch',
-                         action='store_true',
-                         default=False,
-                         dest='once',
-                         help='run in batch mode for one second',
-                         )
-    optparser.add_option('-i', '--debugfs-include-past',
-                         action='store_true',
-                         default=False,
-                         dest='dbgfs_include_past',
-                         help='include all available data on past events for '
-                              'debugfs',
-                         )
-    optparser.add_option('-l', '--log',
-                         action='store_true',
-                         default=False,
-                         dest='log',
-                         help='run in logging mode (like vmstat)',
-                         )
-    optparser.add_option('-t', '--tracepoints',
-                         action='store_true',
-                         default=False,
-                         dest='tracepoints',
-                         help='retrieve statistics from tracepoints',
-                         )
-    optparser.add_option('-d', '--debugfs',
-                         action='store_true',
-                         default=False,
-                         dest='debugfs',
-                         help='retrieve statistics from debugfs',
-                         )
-    optparser.add_option('-f', '--fields',
-                         action='store',
-                         default='',
-                         dest='fields',
-                         help='''fields to display (regex)
-                                 "-f help" for a list of available events''',
-                         )
-    optparser.add_option('-p', '--pid',
-                         action='store',
-                         default=0,
-                         type='int',
-                         dest='pid',
-                         help='restrict statistics to pid',
-                         )
-    optparser.add_option('-g', '--guest',
-                         action='callback',
-                         type='string',
-                         dest='pid',
-                         metavar='GUEST',
-                         help='restrict statistics to guest by name',
-                         callback=cb_guest_to_pid,
-                         )
-    options, unkn = optparser.parse_args(sys.argv)
-    if len(unkn) != 1:
-        sys.exit('Error: Extra argument(s): ' + ' '.join(unkn[1:]))
+    class Guest_to_pid(argparse.Action):
+        def __call__(self, parser, namespace, values, option_string=None):
+            try:
+                pids = Tui.get_pid_from_gname(values)
+            except:
+                sys.exit('Error while searching for guest "{}". Use "-p" to '
+                         'specify a pid instead?'.format(values))
+            if len(pids) == 0:
+                sys.exit('Error: No guest by the name "{}" found'
+                         .format(values))
+            if len(pids) > 1:
+                sys.exit('Error: Multiple processes found (pids: {}). Use "-p"'
+                         ' to specify the desired pid'.format(" ".join(pids)))
+            namespace.pid = pids[0]
+
+    argparser = argparse.ArgumentParser(description=description_text,
+                                        formatter_class=argparse
+                                        .RawTextHelpFormatter)
+    argparser.add_argument('-1', '--once', '--batch',
+                           action='store_true',
+                           default=False,
+                           help='run in batch mode for one second',
+                           )
+    argparser.add_argument('-d', '--debugfs',
+                           action='store_true',
+                           default=False,
+                           help='retrieve statistics from debugfs',
+                           )
+    argparser.add_argument('-f', '--fields',
+                           default='',
+                           help='''fields to display (regex)
+"-f help" for a list of available events''',
+                           )
+    argparser.add_argument('-g', '--guest',
+                           type=str,
+                           help='restrict statistics to guest by name',
+                           action=Guest_to_pid,
+                           )
+    argparser.add_argument('-i', '--debugfs-include-past',
+                           action='store_true',
+                           default=False,
+                           help='include all available data on past events for'
+                                ' debugfs',
+                           )
+    argparser.add_argument('-l', '--log',
+                           action='store_true',
+                           default=False,
+                           help='run in logging mode (like vmstat)',
+                           )
+    argparser.add_argument('-p', '--pid',
+                           type=int,
+                           default=0,
+                           help='restrict statistics to pid',
+                           )
+    argparser.add_argument('-t', '--tracepoints',
+                           action='store_true',
+                           default=False,
+                           help='retrieve statistics from tracepoints',
+                           )
+    options = argparser.parse_args()
     try:
         # verify that we were passed a valid regex up front
         re.compile(options.fields)
-- 
2.17.1

