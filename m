Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 43D3956B440
	for <lists+kvm@lfdr.de>; Fri,  8 Jul 2022 10:16:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237579AbiGHINR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 8 Jul 2022 04:13:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46818 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237632AbiGHINQ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 8 Jul 2022 04:13:16 -0400
Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 81DAB804B2
        for <kvm@vger.kernel.org>; Fri,  8 Jul 2022 01:13:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1657267995; x=1688803995;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=6XY268HOZx4z/YdVGsZcIKcdFbkNBmt+6HBd0yXNB4g=;
  b=a+c3aFuURXV3RtC/cuMcXL4aaWI3j2jV1FeaOKMw3HMBuCgjmp3sCyoe
   HA7AQwLhTfSuYSBCBG1pQj8kafr2Gcn97GpwD7XfzRE/aKy6qj2pZjZJv
   paC+dpAKdz+350cAT9HD4dYwcBWh5fICSSC3p/o4M0T82KUXzYyCk+UeG
   ytybHt/EbH8qJwODaHntRbNlfPRvvprqR2OXupaMueD7+uKkIfz6/5h+6
   uB6oVSBeHPQVa4vzESFpVYgA5fGIrrAlllEBy5nfrPhvJ2a2gNErAGaVC
   J9cC6Za1RhX/slIMq/UpjODyudDNiN/U/VKTM0d1SSyCQr93kUElLAycf
   Q==;
X-IronPort-AV: E=McAfee;i="6400,9594,10401"; a="264640243"
X-IronPort-AV: E=Sophos;i="5.92,254,1650956400"; 
   d="scan'208";a="264640243"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Jul 2022 01:13:14 -0700
X-IronPort-AV: E=Sophos;i="5.92,254,1650956400"; 
   d="scan'208";a="651478979"
Received: from embargo.jf.intel.com ([10.165.9.183])
  by fmsmga008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Jul 2022 01:13:14 -0700
From:   Yang Weijiang <weijiang.yang@intel.com>
To:     seanjc@google.com, pbonzini@redhat.com, kvm@vger.kernel.org
Cc:     Yang Weijiang <weijiang.yang@intel.com>
Subject: [kvm-unit-tests PATCH v5 2/3] x86: Skip perf related tests when platform cannot support
Date:   Fri,  8 Jul 2022 01:11:18 -0400
Message-Id: <20220708051119.124100-2-weijiang.yang@intel.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20220708051119.124100-1-weijiang.yang@intel.com>
References: <20220708051119.124100-1-weijiang.yang@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-3.5 required=5.0 tests=BAYES_00,DATE_IN_PAST_03_06,
        DKIMWL_WL_HIGH,DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Add helpers to check whether MSR_CORE_PERF_GLOBAL_CTRL and rdpmc are
supported in KVM. When pmu is disabled with enable_pmu=0, reading
MSR_CORE_PERF_GLOBAL_CTRL or executing rdpmc leads to #GP, so skip
related tests in this case to avoid test failure.

Opportunistically hoist mwait check function as helper and change
related code.

Suggested-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Yang Weijiang <weijiang.yang@intel.com>

---

v5:
 1. Move cleanup changes to another separated pre-patch.[Sean]
 2. Hoist pmu and mwait capability checks as helpers.

 lib/x86/processor.h | 20 ++++++++++++++++++++
 x86/vmx_tests.c     | 21 +++++++++++++--------
 2 files changed, 33 insertions(+), 8 deletions(-)

diff --git a/lib/x86/processor.h b/lib/x86/processor.h
index 9a0dad6..59cedc9 100644
--- a/lib/x86/processor.h
+++ b/lib/x86/processor.h
@@ -690,4 +690,24 @@ static inline bool cpuid_osxsave(void)
 	return cpuid(1).c & (1 << (X86_FEATURE_OSXSAVE % 32));
 }
 
+static inline u8 pmu_version(void)
+{
+	return cpuid(10).a & 0xff;
+}
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
+
 #endif
diff --git a/x86/vmx_tests.c b/x86/vmx_tests.c
index 27ab5ed..cddee1e 100644
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
+		report_skip("IA32_PERF_GLOBAL_CTRL not supported\n");
+		return;
+	}
+
 	if (!(ctrl_exit_rev.clr & EXI_LOAD_PERF)) {
 		report_skip("\"load IA32_PERF_GLOBAL_CTRL\" exit control not supported\n");
 		return;
@@ -7502,6 +7502,11 @@ static void test_load_host_perf_global_ctrl(void)
 
 static void test_load_guest_perf_global_ctrl(void)
 {
+	if (!cpu_has_perf_global_ctrl()) {
+		report_skip("IA32_PERF_GLOBAL_CTRL not supported\n");
+		return;
+	}
+
 	if (!(ctrl_enter_rev.clr & ENT_LOAD_PERF)) {
 		report_skip("\"load IA32_PERF_GLOBAL_CTRL\" entry control not supported\n");
 		return;
-- 
2.31.1

