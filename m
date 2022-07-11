Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2EC2A56FE70
	for <lists+kvm@lfdr.de>; Mon, 11 Jul 2022 12:11:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231594AbiGKKLq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 11 Jul 2022 06:11:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45572 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234590AbiGKKKg (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 11 Jul 2022 06:10:36 -0400
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3EA9A6415;
        Mon, 11 Jul 2022 02:33:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1657531997; x=1689067997;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=oEbAfK9ZI0wBxkxPminDpw20jY+9VgtTDp4oTNs6CU8=;
  b=J9sU8E3YGxzFJpn63VocNdubhlsFxfrmIwo/7uajd9ZRldljzx03GkRE
   rlcx6iiME6OT0ob8q2cEl7JSEKhwy0rFrlI6VQUTAP3hq8jST04Xumr/5
   2vKEtVCIJ4CXOHzT3WEJsyxiZub/+4GrmA/kuKn+DdXvmhevdIn6Xr2dJ
   2h05MYG8a4ga6OfJ696xdl0paOwwATqfZdaV4Y6ZC4cbD7FaaHqPSyAZL
   F+Jei4watxKDcN0YInCTkjkbze/aK00NOvI5ElaZSbQKPtbmCYQ/516g/
   XoW4Il0JMGRP7ghsfBOk5aSqkE6QBAwfwXiG13b8lBB+s5ilzm0CombWl
   g==;
X-IronPort-AV: E=McAfee;i="6400,9594,10404"; a="283371584"
X-IronPort-AV: E=Sophos;i="5.92,262,1650956400"; 
   d="scan'208";a="283371584"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Jul 2022 02:33:17 -0700
X-IronPort-AV: E=Sophos;i="5.92,262,1650956400"; 
   d="scan'208";a="652387108"
Received: from ahunter6-mobl1.ger.corp.intel.com (HELO ahunter-VirtualBox.home\044ger.corp.intel.com) ([10.252.51.111])
  by fmsmga008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Jul 2022 02:33:15 -0700
From:   Adrian Hunter <adrian.hunter@intel.com>
To:     Arnaldo Carvalho de Melo <acme@kernel.org>
Cc:     Jiri Olsa <jolsa@redhat.com>, Namhyung Kim <namhyung@kernel.org>,
        Ian Rogers <irogers@google.com>,
        Andi Kleen <ak@linux.intel.com>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Subject: [PATCH 15/35] perf script: Add machine_pid and vcpu
Date:   Mon, 11 Jul 2022 12:31:58 +0300
Message-Id: <20220711093218.10967-16-adrian.hunter@intel.com>
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

Add fields machine_pid and vcpu. These are displayed only if machine_pid is
non-zero.

Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
---
 tools/perf/Documentation/perf-script.txt |  7 ++++++-
 tools/perf/builtin-script.c              | 11 +++++++++++
 2 files changed, 17 insertions(+), 1 deletion(-)

diff --git a/tools/perf/Documentation/perf-script.txt b/tools/perf/Documentation/perf-script.txt
index e250ff5566cf..c09cc44e50ee 100644
--- a/tools/perf/Documentation/perf-script.txt
+++ b/tools/perf/Documentation/perf-script.txt
@@ -133,7 +133,8 @@ OPTIONS
         comm, tid, pid, time, cpu, event, trace, ip, sym, dso, addr, symoff,
         srcline, period, iregs, uregs, brstack, brstacksym, flags, bpf-output,
         brstackinsn, brstackinsnlen, brstackoff, callindent, insn, insnlen, synth,
-        phys_addr, metric, misc, srccode, ipc, data_page_size, code_page_size, ins_lat.
+        phys_addr, metric, misc, srccode, ipc, data_page_size, code_page_size, ins_lat,
+        machine_pid, vcpu.
         Field list can be prepended with the type, trace, sw or hw,
         to indicate to which event type the field list applies.
         e.g., -F sw:comm,tid,time,ip,sym  and -F trace:time,cpu,trace
@@ -226,6 +227,10 @@ OPTIONS
 	The ipc (instructions per cycle) field is synthesized and may have a value when
 	Instruction Trace decoding.
 
+	The machine_pid and vcpu fields are derived from data resulting from using
+	perf insert to insert a perf.data file recorded inside a virtual machine into
+	a perf.data file recorded on the host at the same time.
+
 	Finally, a user may not set fields to none for all event types.
 	i.e., -F "" is not allowed.
 
diff --git a/tools/perf/builtin-script.c b/tools/perf/builtin-script.c
index 4b00a50faf00..ac19fee62d8e 100644
--- a/tools/perf/builtin-script.c
+++ b/tools/perf/builtin-script.c
@@ -125,6 +125,8 @@ enum perf_output_field {
 	PERF_OUTPUT_CODE_PAGE_SIZE  = 1ULL << 34,
 	PERF_OUTPUT_INS_LAT         = 1ULL << 35,
 	PERF_OUTPUT_BRSTACKINSNLEN  = 1ULL << 36,
+	PERF_OUTPUT_MACHINE_PID     = 1ULL << 37,
+	PERF_OUTPUT_VCPU            = 1ULL << 38,
 };
 
 struct perf_script {
@@ -193,6 +195,8 @@ struct output_option {
 	{.str = "code_page_size", .field = PERF_OUTPUT_CODE_PAGE_SIZE},
 	{.str = "ins_lat", .field = PERF_OUTPUT_INS_LAT},
 	{.str = "brstackinsnlen", .field = PERF_OUTPUT_BRSTACKINSNLEN},
+	{.str = "machine_pid", .field = PERF_OUTPUT_MACHINE_PID},
+	{.str = "vcpu", .field = PERF_OUTPUT_VCPU},
 };
 
 enum {
@@ -746,6 +750,13 @@ static int perf_sample__fprintf_start(struct perf_script *script,
 	int printed = 0;
 	char tstr[128];
 
+	if (PRINT_FIELD(MACHINE_PID) && sample->machine_pid)
+		printed += fprintf(fp, "VM:%5d ", sample->machine_pid);
+
+	/* Print VCPU only for guest events i.e. with machine_pid */
+	if (PRINT_FIELD(VCPU) && sample->machine_pid)
+		printed += fprintf(fp, "VCPU:%03d ", sample->vcpu);
+
 	if (PRINT_FIELD(COMM)) {
 		const char *comm = thread ? thread__comm_str(thread) : ":-1";
 
-- 
2.25.1

