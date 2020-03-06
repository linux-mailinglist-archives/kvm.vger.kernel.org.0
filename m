Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DE76E17BBE5
	for <lists+kvm@lfdr.de>; Fri,  6 Mar 2020 12:43:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726928AbgCFLnC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 6 Mar 2020 06:43:02 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:52010 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726674AbgCFLm7 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 6 Mar 2020 06:42:59 -0500
Received: from pps.filterd (m0098420.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 026BdOgj039667
        for <kvm@vger.kernel.org>; Fri, 6 Mar 2020 06:42:59 -0500
Received: from e06smtp05.uk.ibm.com (e06smtp05.uk.ibm.com [195.75.94.101])
        by mx0b-001b2d01.pphosted.com with ESMTP id 2ykatam6wd-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Fri, 06 Mar 2020 06:42:58 -0500
Received: from localhost
        by e06smtp05.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <kvm@vger.kernel.org> from <raspl@linux.ibm.com>;
        Fri, 6 Mar 2020 11:42:57 -0000
Received: from b06cxnps4076.portsmouth.uk.ibm.com (9.149.109.198)
        by e06smtp05.uk.ibm.com (192.168.101.135) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Fri, 6 Mar 2020 11:42:54 -0000
Received: from d06av24.portsmouth.uk.ibm.com (mk.ibm.com [9.149.105.60])
        by b06cxnps4076.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 026BgrvG54132980
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 6 Mar 2020 11:42:53 GMT
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 8B6CF42041;
        Fri,  6 Mar 2020 11:42:53 +0000 (GMT)
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 63FF342045;
        Fri,  6 Mar 2020 11:42:53 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by d06av24.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Fri,  6 Mar 2020 11:42:53 +0000 (GMT)
From:   Stefan Raspl <raspl@linux.ibm.com>
To:     kvm@vger.kernel.org
Cc:     rkrcmar@redhat.com, pbonzini@redhat.com
Subject: [PATCH 6/7] tools/kvm_stat: add command line switch '-T'
Date:   Fri,  6 Mar 2020 12:42:49 +0100
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200306114250.57585-1-raspl@linux.ibm.com>
References: <20200306114250.57585-1-raspl@linux.ibm.com>
X-TM-AS-GCONF: 00
x-cbid: 20030611-0020-0000-0000-000003B10F0D
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 20030611-0021-0000-0000-000022094F1D
Message-Id: <20200306114250.57585-7-raspl@linux.ibm.com>
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

Allow to specify logfile size using a timeframe as specified by option
'-T'. Since .csv files have varying record lengths, the estimate might be
off, especially in case only a subset of (pathological) fields is chosen
via '-f'. But we try to over- rather than understimate the required space
to make up for it.

Signed-off-by: Stefan Raspl <raspl@linux.ibm.com>
---
 tools/kvm/kvm_stat/kvm_stat     | 73 ++++++++++++++++++++++++++++++++-
 tools/kvm/kvm_stat/kvm_stat.txt |  6 +++
 2 files changed, 78 insertions(+), 1 deletion(-)

diff --git a/tools/kvm/kvm_stat/kvm_stat b/tools/kvm/kvm_stat/kvm_stat
index 2275ab1b070b..d402ef97bf10 100755
--- a/tools/kvm/kvm_stat/kvm_stat
+++ b/tools/kvm/kvm_stat/kvm_stat
@@ -1509,6 +1509,10 @@ class StdFormat(object):
             res += ' %9d' % s[key].delta
         return res
 
+    def get_statline_len(self, keys, stats):
+        # Note: 19 chars for timestamp plus one for linefeed
+        return 20 + len(self.get_statline(keys, stats.get()))
+
 
 class CSVFormat(object):
     def __init__(self, keys):
@@ -1524,6 +1528,12 @@ class CSVFormat(object):
         return reduce(lambda res, key: "{},{!s}".format(res, s[key].delta),
                       keys, '')
 
+    def get_statline_len(self, keys, stats):
+        # csv statlines are of variable length - need to
+        # apply horrible heuristics to get a projection
+        # Note: 19 chars for timestamp plus one for linefeed
+        return 20 + len(keys) * 5
+
 
 def log(stats, opts, frmt, keys):
     """Prints statistics as reiterating key block, multiple value blocks."""
@@ -1543,6 +1553,14 @@ def log(stats, opts, frmt, keys):
 
 def rotating_log(stats, opts, frmt, keys):
     """Prints statistics to file in csv format."""
+    def convert_to_si(val):
+        if val / 1000000000000. > 1:
+            return "%.2fTB" % (val / 1000000000000.)
+        elif val / 1000000000. > 1:
+            return "%.2fGB" % (val / 1000000000.)
+        else:
+            return "%.2fMB" % (val / 1000000.)
+
     def init(opts, frmt):
         # Regular RotatingFileHandler doesn't add a header to each file,
         # so we create our own version
@@ -1580,6 +1598,18 @@ def rotating_log(stats, opts, frmt, keys):
         except:
             sys.exit("Error setting up csv log with file '%s'"
                      % opts.rotating_log)
+
+        def determine_logsize(opts, keys, stats):
+            if opts.time_frame != '':
+                opts.size = LOGCOUNT_DEFAULT * (len(frmt.get_banner()) + 1) + \
+                            opts.time_frame / opts.set_delay * \
+                            frmt.get_statline_len(keys, stats)
+                # Account for the current file being reset when we roll over
+                opts.size = opts.size / (LOGCOUNT_DEFAULT-1) * LOGCOUNT_DEFAULT
+                print("Estimated required total logfile size: %s" %
+                      convert_to_si(opts.size))
+
+        determine_logsize(opts, keys, stats)
         formatter = MyFormatter('%(asctime)s%(message)s', '%Y-%m-%d %H:%M:%S')
         hdl.setFormatter(formatter)
 
@@ -1645,6 +1675,32 @@ Press any other key to refresh statistics immediately.
 """ % (PATH_DEBUGFS_KVM, PATH_DEBUGFS_TRACING)
 
     def convert_from_si(opts):
+        if opts.time_frame != '':
+            try:
+                    num = int(opts.time_frame.rstrip(string.ascii_letters))
+                    unit = opts.time_frame.lstrip(string.digits)
+            except ValueError:
+                sys.exit("Error: Invalid argument to -T/--time-frame: '%s'"
+                         % opts.size)
+            if num <= 0:
+                sys.exit("Error: Argument to -S/--size must be >0")
+            factor = 3600
+            if unit != '':
+                if unit in ['h', 'H']:
+                    factor = 3600
+                elif unit in ['d', 'D']:
+                    factor = 24*3600
+                elif unit in ['w', 'W']:
+                    factor = 7*24*3600
+                elif unit in ['m', 'M']:
+                    factor = 30*24*3600
+                elif unit in ['y', 'Y']:
+                    factor = 365*24*3600
+                else:
+                    sys.exit("Error: Unsupported unit suffix '%s' for "
+                             "-T/--time-frame" % unit)
+            opts.time_frame = int(num * factor)
+
         try:
             factor = 1000000
             num = int(opts.size.rstrip(string.ascii_letters))
@@ -1749,6 +1805,13 @@ default: %s''' % SIZE_DEFAULT,
                            default=False,
                            help='retrieve statistics from tracepoints',
                            )
+    argparser.add_argument('-T', '--time-frame',
+                           type=str,
+                           default='',
+                           help='''determine total logfile size by minimum \
+time it should hold
+supported suffixes: hdwmy (hours (default), days, weeks, months, years)''',
+                           )
     options = argparser.parse_args()
     if options.csv and not options.log and not options.rotating_log:
         sys.exit('Error: Option -c/--csv requires one of -l/--log or '
@@ -1756,9 +1819,17 @@ default: %s''' % SIZE_DEFAULT,
     if options.rotating_log:
         if options.log:
             sys.exit('Error: Cannot mix -l/--log and -r/--rotating-log')
-        if not options.size:
+        if options.size:
+            if options.time_frame:
+                sys.exit('Error: Cannot specify -S/--size and -T/--time-frame '
+                         'together')
+        else:
             options.size = SIZE_DEFAULT
         convert_from_si(options)
+    else:
+        if options.size or options.time_frame:
+            sys.exit('Error: Options -S/--size and -T/--time-frame only valid '
+                     'with -r/--rotating-log')
     try:
         # verify that we were passed a valid regex up front
         re.compile(options.fields)
diff --git a/tools/kvm/kvm_stat/kvm_stat.txt b/tools/kvm/kvm_stat/kvm_stat.txt
index 35df0b1261a2..2531c3bf56eb 100644
--- a/tools/kvm/kvm_stat/kvm_stat.txt
+++ b/tools/kvm/kvm_stat/kvm_stat.txt
@@ -115,6 +115,12 @@ OPTIONS
 --tracepoints::
         retrieve statistics from tracepoints
 
+-T::
+--time-frame::
+        determine total logfile size by minimum time it should hold.
+            Supported suffixes: hd (hours (default), days, weeks, months,
+            years). Might be inaccurate for .csv format.
+
 SEE ALSO
 --------
 'perf'(1), 'trace-cmd'(1)
-- 
2.17.1

