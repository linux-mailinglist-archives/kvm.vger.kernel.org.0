Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3251656D69E
	for <lists+kvm@lfdr.de>; Mon, 11 Jul 2022 09:21:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230043AbiGKHVP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 11 Jul 2022 03:21:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41198 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230041AbiGKHVJ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 11 Jul 2022 03:21:09 -0400
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E4174DF4E
        for <kvm@vger.kernel.org>; Mon, 11 Jul 2022 00:21:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1657524068; x=1689060068;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=EIC2KV0AiwiGJaXomlpFs1zzrbKCUD0cKcUNJsyn9oo=;
  b=NPKXokcKTZMZOkjIWFcIdBc5HuWPGefs16eTaLVwY5uJkeTyYIvgIYZ7
   ZRtDH0xJ092pFe4yS9bVKosXTwRcQs62NOSvhfx/SBkEE2a12FWiN/+/e
   GkbhXhqxwp9//O1FLDnbG/d+zfeChSGL5qRhPQTehoxE23lLYe5QhH366
   IYrcnG4zAuTF7Nd82hh90J/m3pmrRcbJ3MH1GTaBfhkV5uYTumAydfsxN
   XuAMr72OZmLCJuUxPJ/S56x5e1tEVZLnpcJ889sHp95eDp80Q8S0rmahD
   tjTLjaa5D8QRM3Gf5XPZAMD33pmIkYn8ELja4fJ6PPW4K9VSyqvtMn4B8
   Q==;
X-IronPort-AV: E=McAfee;i="6400,9594,10404"; a="267636832"
X-IronPort-AV: E=Sophos;i="5.92,262,1650956400"; 
   d="scan'208";a="267636832"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Jul 2022 00:20:57 -0700
X-IronPort-AV: E=Sophos;i="5.92,262,1650956400"; 
   d="scan'208";a="627392555"
Received: from embargo.jf.intel.com ([10.165.9.183])
  by orsmga001-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Jul 2022 00:20:57 -0700
From:   Yang Weijiang <weijiang.yang@intel.com>
To:     seanjc@google.com, pbonzini@redhat.com, kvm@vger.kernel.org
Cc:     Yang Weijiang <weijiang.yang@intel.com>
Subject: [kvm-unit-tests PATCH 3/4] x86: Skip perf related tests when platform cannot support
Date:   Mon, 11 Jul 2022 00:18:40 -0400
Message-Id: <20220711041841.126648-4-weijiang.yang@intel.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20220711041841.126648-1-weijiang.yang@intel.com>
References: <20220711041841.126648-1-weijiang.yang@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DATE_IN_PAST_03_06,
        DKIMWL_WL_HIGH,DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Add helpers to check whether MSR_CORE_PERF_GLOBAL_CTRL and rdpmc are
supported in KVM. When pmu is disabled with enable_pmu=0, reading
MSR_CORE_PERF_GLOBAL_CTRL or executing rdpmc leads to #GP, so skip
related tests in this case to avoid test failure.

Opportunistically hoist mwait support check function as helper and
change related code.

Suggested-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Yang Weijiang <weijiang.yang@intel.com>
---
 lib/x86/processor.h | 15 +++++++++++++++
 x86/vmx_tests.c     | 21 +++++++++++++--------
 2 files changed, 28 insertions(+), 8 deletions(-)

diff --git a/lib/x86/processor.h b/lib/x86/processor.h
index d071aba..b772cf3 100644
--- a/lib/x86/processor.h
+++ b/lib/x86/processor.h
@@ -744,4 +744,19 @@ static inline u8 pmu_fixed_counter_width(void)
 	else
 		return 0;
 }
+
+static inline bool cpu_has_perf_global_ctrl(void)
+{
+	return pmu_version() > 1;
+}
+
+static inline bool cpu_has_pmu(void)
+{
+	return !!pmu_version();
+}
+
+static inline bool cpu_has_mwait(void)
+{
+	return this_cpu_has(X86_FEATURE_MWAIT);
+}
 #endif
diff --git a/x86/vmx_tests.c b/x86/vmx_tests.c
index d5868a3..3afc8b8 100644
--- a/x86/vmx_tests.c
+++ b/x86/vmx_tests.c
@@ -847,11 +847,6 @@ u64 cr3;
 
 typedef bool (*supported_fn)(void);
 
-static bool monitor_supported(void)
-{
-	return this_cpu_has(X86_FEATURE_MWAIT);
-}
-
 struct insn_table {
 	const char *name;
 	u32 flag;
@@ -880,8 +875,8 @@ static struct insn_table insn_table[] = {
 	{"HLT",  CPU_HLT, insn_hlt, INSN_CPU0, 12, 0, 0, 0},
 	{"INVLPG", CPU_INVLPG, insn_invlpg, INSN_CPU0, 14,
 		0x12345678, 0, FIELD_EXIT_QUAL},
-	{"MWAIT", CPU_MWAIT, insn_mwait, INSN_CPU0, 36, 0, 0, 0, &monitor_supported},
-	{"RDPMC", CPU_RDPMC, insn_rdpmc, INSN_CPU0, 15, 0, 0, 0},
+	{"MWAIT", CPU_MWAIT, insn_mwait, INSN_CPU0, 36, 0, 0, 0, &cpu_has_mwait},
+	{"RDPMC", CPU_RDPMC, insn_rdpmc, INSN_CPU0, 15, 0, 0, 0, &cpu_has_pmu},
 	{"RDTSC", CPU_RDTSC, insn_rdtsc, INSN_CPU0, 16, 0, 0, 0},
 	{"CR3 load", CPU_CR3_LOAD, insn_cr3_load, INSN_CPU0, 28, 0x3, 0,
 		FIELD_EXIT_QUAL},
@@ -891,7 +886,7 @@ static struct insn_table insn_table[] = {
 		FIELD_EXIT_QUAL},
 	{"CR8 store", CPU_CR8_STORE, insn_cr8_store, INSN_CPU0, 28, 0x18, 0,
 		FIELD_EXIT_QUAL},
-	{"MONITOR", CPU_MONITOR, insn_monitor, INSN_CPU0, 39, 0, 0, 0, &monitor_supported},
+	{"MONITOR", CPU_MONITOR, insn_monitor, INSN_CPU0, 39, 0, 0, 0, &cpu_has_mwait},
 	{"PAUSE", CPU_PAUSE, insn_pause, INSN_CPU0, 40, 0, 0, 0},
 	// Flags for Secondary Processor-Based VM-Execution Controls
 	{"WBINVD", CPU_WBINVD, insn_wbinvd, INSN_CPU1, 54, 0, 0, 0},
@@ -7490,6 +7485,11 @@ static void test_perf_global_ctrl(u32 nr, const char *name, u32 ctrl_nr,
 
 static void test_load_host_perf_global_ctrl(void)
 {
+	if (!cpu_has_perf_global_ctrl()) {
+		report_skip("%s :IA32_PERF_GLOBAL_CTRL MSR not supported", __func__);
+		return;
+	}
+
 	if (!(ctrl_exit_rev.clr & EXI_LOAD_PERF)) {
 		report_skip("%s :\"Load IA32_PERF_GLOBAL_CTRL\" exit control not supported", __func__);
 		return;
@@ -7502,6 +7502,11 @@ static void test_load_host_perf_global_ctrl(void)
 
 static void test_load_guest_perf_global_ctrl(void)
 {
+	if (!cpu_has_perf_global_ctrl()) {
+		report_skip("%s :IA32_PERF_GLOBAL_CTRL MSR not supported", __func__);
+		return;
+	}
+
 	if (!(ctrl_enter_rev.clr & ENT_LOAD_PERF)) {
 		report_skip("%s :\"Load IA32_PERF_GLOBAL_CTRL\" entry control not supported", __func__);
 		return;
-- 
2.31.1

