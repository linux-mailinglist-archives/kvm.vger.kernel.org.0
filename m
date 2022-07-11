Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9576056FE7C
	for <lists+kvm@lfdr.de>; Mon, 11 Jul 2022 12:12:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231703AbiGKKMs (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 11 Jul 2022 06:12:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49492 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234681AbiGKKLg (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 11 Jul 2022 06:11:36 -0400
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3D11BDF9A;
        Mon, 11 Jul 2022 02:33:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1657532021; x=1689068021;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=8rGCD6GA8/kbp19c1VCS4tx/aWpDWn0cNjJ7aA2rrME=;
  b=V+TFjPMw5ulBfZkvOqULXSGWTZ3J2Qyc2E5pPft+tAdr7JHBR6PcMN8o
   ikOSCBhVJ6gjlSh9DfhI34OgqfL77vZ9PM09wQLijT6HFZ2sz4kDFAvbi
   WJTO2kciz+8AedtTj+gFeB1pXaKg24I5BAJd3LpOQzcVASokz0WSh3Gpw
   rz63YDrDvNv2L5cw7o1Sfenqd/8pPgIs45RVneG+D9dMPI7A6L3KCY5EX
   TbqMPCNzIQ1flZ9td2dXndUN45jbdfEVlMih/5e9m7D0COfCFDTQX55/w
   3m3QxfsP2Z2gxijo2/dxJObLbZNL5nii87BT2mqrYqy3aquMcGJOvN6O8
   g==;
X-IronPort-AV: E=McAfee;i="6400,9594,10404"; a="283371609"
X-IronPort-AV: E=Sophos;i="5.92,262,1650956400"; 
   d="scan'208";a="283371609"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Jul 2022 02:33:26 -0700
X-IronPort-AV: E=Sophos;i="5.92,262,1650956400"; 
   d="scan'208";a="652387158"
Received: from ahunter6-mobl1.ger.corp.intel.com (HELO ahunter-VirtualBox.home\044ger.corp.intel.com) ([10.252.51.111])
  by fmsmga008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Jul 2022 02:33:24 -0700
From:   Adrian Hunter <adrian.hunter@intel.com>
To:     Arnaldo Carvalho de Melo <acme@kernel.org>
Cc:     Jiri Olsa <jolsa@redhat.com>, Namhyung Kim <namhyung@kernel.org>,
        Ian Rogers <irogers@google.com>,
        Andi Kleen <ak@linux.intel.com>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Subject: [PATCH 19/35] perf script python: intel-pt-events: Add machine_pid and vcpu
Date:   Mon, 11 Jul 2022 12:32:02 +0300
Message-Id: <20220711093218.10967-20-adrian.hunter@intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220711093218.10967-1-adrian.hunter@intel.com>
References: <20220711093218.10967-1-adrian.hunter@intel.com>
MIME-Version: 1.0
Organization: Intel Finland Oy, Registered Address: PL 281, 00181 Helsinki, Business Identity Code: 0357606 - 4, Domiciled in Helsinki
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-5.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Add machine_pid and vcpu to the intel-pt-events.py script.

Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
---
 tools/perf/scripts/python/intel-pt-events.py | 32 +++++++++++++++++---
 1 file changed, 27 insertions(+), 5 deletions(-)

diff --git a/tools/perf/scripts/python/intel-pt-events.py b/tools/perf/scripts/python/intel-pt-events.py
index 9b7746b89381..6be7fd8fd615 100644
--- a/tools/perf/scripts/python/intel-pt-events.py
+++ b/tools/perf/scripts/python/intel-pt-events.py
@@ -197,7 +197,12 @@ def common_start_str(comm, sample):
 	cpu = sample["cpu"]
 	pid = sample["pid"]
 	tid = sample["tid"]
-	return "%16s %5u/%-5u [%03u] %9u.%09u  " % (comm, pid, tid, cpu, ts / 1000000000, ts %1000000000)
+	if "machine_pid" in sample:
+		machine_pid = sample["machine_pid"]
+		vcpu = sample["vcpu"]
+		return "VM:%5d VCPU:%03d %16s %5u/%-5u [%03u] %9u.%09u  " % (machine_pid, vcpu, comm, pid, tid, cpu, ts / 1000000000, ts %1000000000)
+	else:
+		return "%16s %5u/%-5u [%03u] %9u.%09u  " % (comm, pid, tid, cpu, ts / 1000000000, ts %1000000000)
 
 def print_common_start(comm, sample, name):
 	flags_disp = get_optional_null(sample, "flags_disp")
@@ -379,9 +384,19 @@ def process_event(param_dict):
 		sys.exit(1)
 
 def auxtrace_error(typ, code, cpu, pid, tid, ip, ts, msg, cpumode, *x):
+	if len(x) >= 2 and x[0]:
+		machine_pid = x[0]
+		vcpu = x[1]
+	else:
+		machine_pid = 0
+		vcpu = -1
 	try:
-		print("%16s %5u/%-5u [%03u] %9u.%09u  error type %u code %u: %s ip 0x%16x" %
-			("Trace error", pid, tid, cpu, ts / 1000000000, ts %1000000000, typ, code, msg, ip))
+		if machine_pid:
+			print("VM:%5d VCPU:%03d %16s %5u/%-5u [%03u] %9u.%09u  error type %u code %u: %s ip 0x%16x" %
+				(machine_pid, vcpu, "Trace error", pid, tid, cpu, ts / 1000000000, ts %1000000000, typ, code, msg, ip))
+		else:
+			print("%16s %5u/%-5u [%03u] %9u.%09u  error type %u code %u: %s ip 0x%16x" %
+				("Trace error", pid, tid, cpu, ts / 1000000000, ts %1000000000, typ, code, msg, ip))
 	except broken_pipe_exception:
 		# Stop python printing broken pipe errors and traceback
 		sys.stdout = open(os.devnull, 'w')
@@ -396,14 +411,21 @@ def context_switch(ts, cpu, pid, tid, np_pid, np_tid, machine_pid, out, out_pree
 		preempt_str = "preempt"
 	else:
 		preempt_str = ""
+	if len(x) >= 2 and x[0]:
+		machine_pid = x[0]
+		vcpu = x[1]
+	else:
+		vcpu = None;
 	if machine_pid == -1:
 		machine_str = ""
-	else:
+	elif vcpu is None:
 		machine_str = "machine PID %d" % machine_pid
+	else:
+		machine_str = "machine PID %d VCPU %d" % (machine_pid, vcpu)
 	switch_str = "%16s %5d/%-5d [%03u] %9u.%09u %5d/%-5d %s %s" % \
 		(out_str, pid, tid, cpu, ts / 1000000000, ts %1000000000, np_pid, np_tid, machine_str, preempt_str)
 	if glb_args.all_switch_events:
-		print(switch_str);
+		print(switch_str)
 	else:
 		global glb_switch_str
 		glb_switch_str[cpu] = switch_str
-- 
2.25.1

