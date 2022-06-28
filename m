Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4B84755CA5B
	for <lists+kvm@lfdr.de>; Tue, 28 Jun 2022 14:58:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242051AbiF1Jd5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 28 Jun 2022 05:33:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56054 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344423AbiF1Jcq (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 28 Jun 2022 05:32:46 -0400
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F39B81CFD5
        for <kvm@vger.kernel.org>; Tue, 28 Jun 2022 02:32:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1656408765; x=1687944765;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=86UfktLqGMZ3oFF9g+gnNfYjn3O5+PeuqO1cYa73eP8=;
  b=in9/G1fnOY0z8FQzYK5UezuWdwQArwV5UaQnJzlqCo5sGFBxwm4e7dJy
   lnyCSxNXRQCTBKccPe3LjgaFet+Ikuf5KB84yNrWHZSI46u9fc7mh1/0E
   UxipEhavxqGG9zdZczmkx/UonaAA9aBkSdyTRx3A/kj87TYmKIZOT+fqo
   Noh+Az9YyqSimLqBfUElxYWyiJhozyDjmQ8dX+OclsTuoDIhtOTl9cPLj
   NFp7M83VlRECwHGAhifXIh3RburwQZX1hFffc0ZHWOMzv965bCzFu5zFn
   eVpaTBqyUIfTQ90RNP+/GXI2as0nxxgE+n81I5pUYBEb8Is7nbxvenIhx
   w==;
X-IronPort-AV: E=McAfee;i="6400,9594,10391"; a="307171613"
X-IronPort-AV: E=Sophos;i="5.92,227,1650956400"; 
   d="scan'208";a="307171613"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Jun 2022 02:32:45 -0700
X-IronPort-AV: E=Sophos;i="5.92,227,1650956400"; 
   d="scan'208";a="565015286"
Received: from embargo.jf.intel.com ([10.165.9.183])
  by orsmga006-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Jun 2022 02:32:45 -0700
From:   Yang Weijiang <weijiang.yang@intel.com>
To:     pbonzini@redhat.com, seanjc@google.com
Cc:     kvm@vger.kernel.org, Yang Weijiang <weijiang.yang@intel.com>
Subject: [kvm-unit-tests PATCH v4 1/2] x86: Skip perf related tests when platform cannot support
Date:   Tue, 28 Jun 2022 05:32:02 -0400
Message-Id: <20220628093203.73160-1-weijiang.yang@intel.com>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Add helpers to check whether MSR_CORE_PERF_GLOBAL_CTRL and rdpmc
are supported in KVM. When pmu is disabled with enable_pmu=0,
reading MSR_CORE_PERF_GLOBAL_CTRL or executing rdpmc leads to #GP,
so skip related tests in this case to avoid test failure.

Opportunistically replace some "printf" with "report_skip" to make
the output log clean.

Suggested-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Yang Weijiang <weijiang.yang@intel.com>

v4:
- Use supported_fn() to make the code nicer. [Sean]
- Replace some of the printf with report_skip to make the results clean. [Sean]
---
 lib/x86/processor.h | 10 ++++++++++
 x86/vmx_tests.c     | 40 +++++++++++++++++++++++++++-------------
 2 files changed, 37 insertions(+), 13 deletions(-)

diff --git a/lib/x86/processor.h b/lib/x86/processor.h
index 9a0dad6..7b6ee92 100644
--- a/lib/x86/processor.h
+++ b/lib/x86/processor.h
@@ -690,4 +690,14 @@ static inline bool cpuid_osxsave(void)
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
 #endif
diff --git a/x86/vmx_tests.c b/x86/vmx_tests.c
index 4d581e7..3a14cb2 100644
--- a/x86/vmx_tests.c
+++ b/x86/vmx_tests.c
@@ -852,6 +852,10 @@ static bool monitor_supported(void)
 	return this_cpu_has(X86_FEATURE_MWAIT);
 }
 
+static inline bool pmu_supported(void) {
+	return !!pmu_version();
+}
+
 struct insn_table {
 	const char *name;
 	u32 flag;
@@ -881,7 +885,7 @@ static struct insn_table insn_table[] = {
 	{"INVLPG", CPU_INVLPG, insn_invlpg, INSN_CPU0, 14,
 		0x12345678, 0, FIELD_EXIT_QUAL},
 	{"MWAIT", CPU_MWAIT, insn_mwait, INSN_CPU0, 36, 0, 0, 0, &monitor_supported},
-	{"RDPMC", CPU_RDPMC, insn_rdpmc, INSN_CPU0, 15, 0, 0, 0},
+	{"RDPMC", CPU_RDPMC, insn_rdpmc, INSN_CPU0, 15, 0, 0, 0, &pmu_supported},
 	{"RDTSC", CPU_RDTSC, insn_rdtsc, INSN_CPU0, 16, 0, 0, 0},
 	{"CR3 load", CPU_CR3_LOAD, insn_cr3_load, INSN_CPU0, 28, 0x3, 0,
 		FIELD_EXIT_QUAL},
@@ -4107,7 +4111,7 @@ static void test_vpid(void)
 	int i;
 
 	if (!is_vpid_supported()) {
-		printf("Secondary controls and/or VPID not supported\n");
+		report_skip("Secondary controls and/or VPID not supported\n");
 		return;
 	}
 
@@ -4614,7 +4618,7 @@ static void test_nmi_ctrls(void)
 
 	if ((ctrl_pin_rev.clr & (PIN_NMI | PIN_VIRT_NMI)) !=
 	    (PIN_NMI | PIN_VIRT_NMI)) {
-		printf("NMI exiting and Virtual NMIs are not supported !\n");
+		report_skip("NMI exiting and Virtual NMIs are not supported !\n");
 		return;
 	}
 
@@ -4724,7 +4728,7 @@ static void test_ept_eptp(void)
 
 	if (!((ctrl_cpu_rev[0].clr & CPU_SECONDARY) &&
 	    (ctrl_cpu_rev[1].clr & CPU_EPT))) {
-		printf("\"CPU secondary\" and/or \"enable EPT\" execution controls are not supported !\n");
+		report_skip("\"CPU secondary\" and/or \"enable EPT\" execution controls are not supported !\n");
 		return;
 	}
 
@@ -4884,7 +4888,7 @@ static void test_pml(void)
 
 	if (!((ctrl_cpu_rev[0].clr & CPU_SECONDARY) &&
 	    (ctrl_cpu_rev[1].clr & CPU_EPT) && (ctrl_cpu_rev[1].clr & CPU_PML))) {
-		printf("\"Secondary execution\" control or \"enable EPT\" control or \"enable PML\" control is not supported !\n");
+		report_skip("\"Secondary execution\" control or \"enable EPT\" control or \"enable PML\" control is not supported !\n");
 		return;
 	}
 
@@ -4936,7 +4940,7 @@ static void test_vmx_preemption_timer(void)
 
 	if (!((ctrl_exit_rev.clr & EXI_SAVE_PREEMPT) ||
 	    (ctrl_pin_rev.clr & PIN_PREEMPT))) {
-		printf("\"Save-VMX-preemption-timer\" control and/or \"Enable-VMX-preemption-timer\" control is not supported\n");
+		report_skip("\"Save-VMX-preemption-timer\" control and/or \"Enable-VMX-preemption-timer\" control is not supported\n");
 		return;
 	}
 
@@ -7175,7 +7179,7 @@ static void test_efer(u32 fld, const char * fld_name, u32 ctrl_fld,
 		efer_reserved_bits &= ~EFER_NX;
 
 	if (!ctrl_bit1) {
-		printf("\"Load-IA32-EFER\" exit control not supported\n");
+		report_skip("\"Load-IA32-EFER\" exit control not supported\n");
 		goto test_entry_exit_mode;
 	}
 
@@ -7258,7 +7262,7 @@ static void test_host_efer(void)
 static void test_guest_efer(void)
 {
 	if (!(ctrl_enter_rev.clr & ENT_LOAD_EFER)) {
-		printf("\"Load-IA32-EFER\" entry control not supported\n");
+		report_skip("\"Load-IA32-EFER\" entry control not supported\n");
 		return;
 	}
 
@@ -7349,7 +7353,7 @@ static void test_load_host_pat(void)
 	 * "load IA32_PAT" VM-exit control
 	 */
 	if (!(ctrl_exit_rev.clr & EXI_LOAD_PAT)) {
-		printf("\"Load-IA32-PAT\" exit control not supported\n");
+		report_skip("\"Load-IA32-PAT\" exit control not supported\n");
 		return;
 	}
 
@@ -7490,8 +7494,13 @@ static void test_perf_global_ctrl(u32 nr, const char *name, u32 ctrl_nr,
 
 static void test_load_host_perf_global_ctrl(void)
 {
+	if (!cpu_has_perf_global_ctrl()) {
+		report_skip("IA32_PERF_GLOBAL_CTRL not supported\n");
+		return;
+	}
+
 	if (!(ctrl_exit_rev.clr & EXI_LOAD_PERF)) {
-		printf("\"load IA32_PERF_GLOBAL_CTRL\" exit control not supported\n");
+		report_skip("\"load IA32_PERF_GLOBAL_CTRL\" exit control not supported\n");
 		return;
 	}
 
@@ -7502,8 +7511,13 @@ static void test_load_host_perf_global_ctrl(void)
 
 static void test_load_guest_perf_global_ctrl(void)
 {
+	if (!cpu_has_perf_global_ctrl()) {
+		report_skip("IA32_PERF_GLOBAL_CTRL not supported\n");
+		return;
+	}
+
 	if (!(ctrl_enter_rev.clr & ENT_LOAD_PERF)) {
-		printf("\"load IA32_PERF_GLOBAL_CTRL\" entry control not supported\n");
+		report_skip("\"load IA32_PERF_GLOBAL_CTRL\" entry control not supported\n");
 		return;
 	}
 
@@ -7809,7 +7823,7 @@ static void test_load_guest_pat(void)
 	 * "load IA32_PAT" VM-entry control
 	 */
 	if (!(ctrl_enter_rev.clr & ENT_LOAD_PAT)) {
-		printf("\"Load-IA32-PAT\" entry control not supported\n");
+		report_skip("\"Load-IA32-PAT\" entry control not supported\n");
 		return;
 	}
 
@@ -7833,7 +7847,7 @@ static void test_load_guest_bndcfgs(void)
 	u64 bndcfgs;
 
 	if (!(ctrl_enter_rev.clr & ENT_LOAD_BNDCFGS)) {
-		printf("\"Load-IA32-BNDCFGS\" entry control not supported\n");
+		report_skip("\"Load-IA32-BNDCFGS\" entry control not supported\n");
 		return;
 	}
 

base-commit: ca85dda2671e88d34acfbca6de48a9ab32b1810d
-- 
2.27.0

