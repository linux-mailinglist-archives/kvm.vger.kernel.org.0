Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 95C2F56D69C
	for <lists+kvm@lfdr.de>; Mon, 11 Jul 2022 09:21:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229893AbiGKHVN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 11 Jul 2022 03:21:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41160 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229885AbiGKHVJ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 11 Jul 2022 03:21:09 -0400
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BFEFBDFE1
        for <kvm@vger.kernel.org>; Mon, 11 Jul 2022 00:21:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1657524063; x=1689060063;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=Mxy62Mx4C4wSRCwu3hBXBXen8BaY7TrpjxxuWYcGZZA=;
  b=IwxBCN2ezogJ3Ypy3JSZrmC5DJPYI4gx2Haq1SClqk6tmDHkBFveEAcn
   GfGU+U9KQbHYT8HIEOqrfQFCPuZHTvox5HJTNnRs1ENi5Xi51AUh8lQlw
   j5nenhPz8SRWTDLTP8NzDHe1Ohikgc/8gse3BtHgdARMnxJXf+unSM08U
   XXi2Qr0lobdy5H/4nK9yFveeW1xIp1EHvmLhJy9v+avF3JrnLXXoFSwHu
   6hqDD/9GW7zXP/1Ry0VulOgJGp/ZUv9Vug6TGhpPAVq/FAdLOqAOPXkqa
   lcRDYakyaEU944HOxwBWmGbZJmBjjIQeFA5Otj9zKkw4KT2aKflFX1Zhu
   Q==;
X-IronPort-AV: E=McAfee;i="6400,9594,10404"; a="267636828"
X-IronPort-AV: E=Sophos;i="5.92,262,1650956400"; 
   d="scan'208";a="267636828"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Jul 2022 00:20:57 -0700
X-IronPort-AV: E=Sophos;i="5.92,262,1650956400"; 
   d="scan'208";a="627392549"
Received: from embargo.jf.intel.com ([10.165.9.183])
  by orsmga001-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Jul 2022 00:20:57 -0700
From:   Yang Weijiang <weijiang.yang@intel.com>
To:     seanjc@google.com, pbonzini@redhat.com, kvm@vger.kernel.org
Cc:     Yang Weijiang <weijiang.yang@intel.com>
Subject: [kvm-unit-tests PATCH 1/4] x86: Use report_skip to print messages when tests are skipped
Date:   Mon, 11 Jul 2022 00:18:38 -0400
Message-Id: <20220711041841.126648-2-weijiang.yang@intel.com>
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

report_skip() prints message with "SKIP:" prefix to explictly
tell which test is skipped, use it to make test report clean.

Opportunistically unify the message format for report_skip().

Signed-off-by: Yang Weijiang <weijiang.yang@intel.com>
---
 x86/vmx_tests.c | 88 ++++++++++++++++++++++++-------------------------
 1 file changed, 44 insertions(+), 44 deletions(-)

diff --git a/x86/vmx_tests.c b/x86/vmx_tests.c
index 4d581e7..d5868a3 100644
--- a/x86/vmx_tests.c
+++ b/x86/vmx_tests.c
@@ -1766,7 +1766,7 @@ static void nmi_hlt_main(void)
     long long start;
 
     if (cpu_count() < 2) {
-        report_skip(__func__);
+        report_skip("%s :CPU count < 2", __func__);
         vmx_set_test_stage(-1);
         return;
     }
@@ -4107,7 +4107,7 @@ static void test_vpid(void)
 	int i;
 
 	if (!is_vpid_supported()) {
-		printf("Secondary controls and/or VPID not supported\n");
+		report_skip("%s :Secondary controls and/or VPID not supported", __func__);
 		return;
 	}
 
@@ -4614,7 +4614,7 @@ static void test_nmi_ctrls(void)
 
 	if ((ctrl_pin_rev.clr & (PIN_NMI | PIN_VIRT_NMI)) !=
 	    (PIN_NMI | PIN_VIRT_NMI)) {
-		printf("NMI exiting and Virtual NMIs are not supported !\n");
+		report_skip("%s :NMI exiting and/or Virtual NMIs not supported", __func__);
 		return;
 	}
 
@@ -4724,7 +4724,7 @@ static void test_ept_eptp(void)
 
 	if (!((ctrl_cpu_rev[0].clr & CPU_SECONDARY) &&
 	    (ctrl_cpu_rev[1].clr & CPU_EPT))) {
-		printf("\"CPU secondary\" and/or \"enable EPT\" execution controls are not supported !\n");
+		report_skip("%s :\"CPU secondary\" and/or \"enable EPT\" exec control not supported", __func__);
 		return;
 	}
 
@@ -4884,7 +4884,7 @@ static void test_pml(void)
 
 	if (!((ctrl_cpu_rev[0].clr & CPU_SECONDARY) &&
 	    (ctrl_cpu_rev[1].clr & CPU_EPT) && (ctrl_cpu_rev[1].clr & CPU_PML))) {
-		printf("\"Secondary execution\" control or \"enable EPT\" control or \"enable PML\" control is not supported !\n");
+		report_skip("%s :\"Secondary execution\" or \"enable EPT\" or \"enable PML\" control not supported", __func__);
 		return;
 	}
 
@@ -4936,7 +4936,7 @@ static void test_vmx_preemption_timer(void)
 
 	if (!((ctrl_exit_rev.clr & EXI_SAVE_PREEMPT) ||
 	    (ctrl_pin_rev.clr & PIN_PREEMPT))) {
-		printf("\"Save-VMX-preemption-timer\" control and/or \"Enable-VMX-preemption-timer\" control is not supported\n");
+		report_skip("%s :\"Save-VMX-preemption-timer\" and/or \"Enable-VMX-preemption-timer\" control not supported", __func__);
 		return;
 	}
 
@@ -5060,7 +5060,7 @@ static void vmx_mtf_test(void)
 	handler old_gp, old_db;
 
 	if (!(ctrl_cpu_rev[0].clr & CPU_MTF)) {
-		printf("CPU does not support the 'monitor trap flag' processor-based VM-execution control.\n");
+		report_skip("%s :\"Monitor trap flag\" exec control not supported", __func__);
 		return;
 	}
 
@@ -5163,12 +5163,12 @@ static void vmx_mtf_pdpte_test(void)
 		return;
 
 	if (!(ctrl_cpu_rev[0].clr & CPU_MTF)) {
-		printf("CPU does not support 'monitor trap flag.'\n");
+		report_skip("%s :\"Monitor trap flag\" exec control not supported", __func__);
 		return;
 	}
 
 	if (!(ctrl_cpu_rev[1].clr & CPU_URG)) {
-		printf("CPU does not support 'unrestricted guest.'\n");
+		report_skip("%s :\"Unrestricted guest\" exec control not supported", __func__);
 		return;
 	}
 
@@ -6142,7 +6142,7 @@ static void apic_reg_virt_test(void)
 	struct apic_reg_virt_guest_args *args = &apic_reg_virt_guest_args;
 
 	if (!cpu_has_apicv()) {
-		report_skip(__func__);
+		report_skip("%s :Not all required APICv bits supported", __func__);
 		return;
 	}
 
@@ -6879,7 +6879,7 @@ static enum Config_type configure_virt_x2apic_mode_test(
 
 	if (virt_x2apic_mode_config->virtual_interrupt_delivery) {
 		if (!(ctrl_cpu_rev[1].clr & CPU_VINTD)) {
-			report_skip("VM-execution control \"virtual-interrupt delivery\" NOT supported.\n");
+			report_skip("%s :\"virtual-interrupt delivery\" exec control not supported", __func__);
 			return CONFIG_TYPE_UNSUPPORTED;
 		}
 		cpu_exec_ctrl1 |= CPU_VINTD;
@@ -6920,7 +6920,7 @@ static void virt_x2apic_mode_test(void)
 	struct virt_x2apic_mode_guest_args *args = &virt_x2apic_mode_guest_args;
 
 	if (!cpu_has_apicv()) {
-		report_skip(__func__);
+		report_skip("%s :Not all required APICv bits supported", __func__);
 		return;
 	}
 
@@ -6940,10 +6940,10 @@ static void virt_x2apic_mode_test(void)
 	 *   - "MSR-bitmap address", indicated by "use MSR bitmaps"
 	 */
 	if (!(ctrl_cpu_rev[0].clr & CPU_TPR_SHADOW)) {
-		report_skip("VM-execution control \"use TPR shadow\" NOT supported.\n");
+		report_skip("%s :\"Use TPR shadow\" exec control not supported", __func__);
 		return;
 	} else if (!(ctrl_cpu_rev[0].clr & CPU_MSR_BITMAP)) {
-		report_skip("VM-execution control \"use MSR bitmaps\" NOT supported.\n");
+		report_skip("%s :\"Use MSR bitmaps\" exec control not supported", __func__);
 		return;
 	}
 
@@ -6969,7 +6969,7 @@ static void virt_x2apic_mode_test(void)
 			configure_virt_x2apic_mode_test(virt_x2apic_mode_config,
 							msr_bitmap_page);
 		if (config_type == CONFIG_TYPE_UNSUPPORTED) {
-			report_skip("Skip because of missing features.\n");
+			report_skip("Skip because of missing features.");
 			continue;
 		} else if (config_type == CONFIG_TYPE_VMENTRY_FAILS_EARLY) {
 			enter_guest_with_bad_controls();
@@ -7175,7 +7175,7 @@ static void test_efer(u32 fld, const char * fld_name, u32 ctrl_fld,
 		efer_reserved_bits &= ~EFER_NX;
 
 	if (!ctrl_bit1) {
-		printf("\"Load-IA32-EFER\" exit control not supported\n");
+		report_skip("%s :\"Load-IA32-EFER\" exit control not supported", __func__);
 		goto test_entry_exit_mode;
 	}
 
@@ -7258,7 +7258,7 @@ static void test_host_efer(void)
 static void test_guest_efer(void)
 {
 	if (!(ctrl_enter_rev.clr & ENT_LOAD_EFER)) {
-		printf("\"Load-IA32-EFER\" entry control not supported\n");
+		report_skip("%s :\"Load-IA32-EFER\" entry control not supported", __func__);
 		return;
 	}
 
@@ -7349,7 +7349,7 @@ static void test_load_host_pat(void)
 	 * "load IA32_PAT" VM-exit control
 	 */
 	if (!(ctrl_exit_rev.clr & EXI_LOAD_PAT)) {
-		printf("\"Load-IA32-PAT\" exit control not supported\n");
+		report_skip("%s :\"Load-IA32-PAT\" exit control not supported", __func__);
 		return;
 	}
 
@@ -7491,7 +7491,7 @@ static void test_perf_global_ctrl(u32 nr, const char *name, u32 ctrl_nr,
 static void test_load_host_perf_global_ctrl(void)
 {
 	if (!(ctrl_exit_rev.clr & EXI_LOAD_PERF)) {
-		printf("\"load IA32_PERF_GLOBAL_CTRL\" exit control not supported\n");
+		report_skip("%s :\"Load IA32_PERF_GLOBAL_CTRL\" exit control not supported", __func__);
 		return;
 	}
 
@@ -7503,7 +7503,7 @@ static void test_load_host_perf_global_ctrl(void)
 static void test_load_guest_perf_global_ctrl(void)
 {
 	if (!(ctrl_enter_rev.clr & ENT_LOAD_PERF)) {
-		printf("\"load IA32_PERF_GLOBAL_CTRL\" entry control not supported\n");
+		report_skip("%s :\"Load IA32_PERF_GLOBAL_CTRL\" entry control not supported", __func__);
 		return;
 	}
 
@@ -7809,7 +7809,7 @@ static void test_load_guest_pat(void)
 	 * "load IA32_PAT" VM-entry control
 	 */
 	if (!(ctrl_enter_rev.clr & ENT_LOAD_PAT)) {
-		printf("\"Load-IA32-PAT\" entry control not supported\n");
+		report_skip("%s :\"Load-IA32-PAT\" entry control not supported", __func__);
 		return;
 	}
 
@@ -7833,7 +7833,7 @@ static void test_load_guest_bndcfgs(void)
 	u64 bndcfgs;
 
 	if (!(ctrl_enter_rev.clr & ENT_LOAD_BNDCFGS)) {
-		printf("\"Load-IA32-BNDCFGS\" entry control not supported\n");
+		report_skip("%s :\"Load-IA32-BNDCFGS\" entry control not supported", __func__);
 		return;
 	}
 
@@ -8134,7 +8134,7 @@ static void unsetup_unrestricted_guest(void)
 static void vmentry_unrestricted_guest_test(void)
 {
 	if (enable_unrestricted_guest(true)) {
-		report_skip("Unrestricted guest not supported");
+		report_skip("%s: \"Unrestricted guest\" exec control not supported", __func__);
 		return;
 	}
 
@@ -8298,11 +8298,11 @@ static void vmx_cr_load_test(void)
 	orig_cr3 = read_cr3();
 
 	if (!this_cpu_has(X86_FEATURE_PCID)) {
-		report_skip("PCID not detected");
+		report_skip("%s :PCID not detected", __func__);
 		return;
 	}
 	if (!this_cpu_has(X86_FEATURE_MCE)) {
-		report_skip("MCE not detected");
+		report_skip("%s :MCE not detected", __func__);
 		return;
 	}
 
@@ -8407,7 +8407,7 @@ static void vmx_cr4_osxsave_test_guest(void)
 static void vmx_cr4_osxsave_test(void)
 {
 	if (!this_cpu_has(X86_FEATURE_XSAVE)) {
-		report_skip("XSAVE not detected");
+		report_skip("%s :XSAVE not detected", __func__);
 		return;
 	}
 
@@ -8592,12 +8592,12 @@ static void vmx_nmi_window_test(void)
 	void *db_fault_addr = get_idt_addr(&boot_idt[DB_VECTOR]);
 
 	if (!(ctrl_pin_rev.clr & PIN_VIRT_NMI)) {
-		report_skip("CPU does not support the \"Virtual NMIs\" VM-execution control.");
+		report_skip("%s :\"Virtual NMIs\" exec control not supported", __func__);
 		return;
 	}
 
 	if (!(ctrl_cpu_rev[0].clr & CPU_NMI_WINDOW)) {
-		report_skip("CPU does not support the \"NMI-window exiting\" VM-execution control.");
+		report_skip("%s :\"NMI-window exiting\" exec control not supported", __func__);
 		return;
 	}
 
@@ -8728,7 +8728,7 @@ static void vmx_intr_window_test(void)
 	void *db_fault_addr = get_idt_addr(&boot_idt[DB_VECTOR]);
 
 	if (!(ctrl_cpu_rev[0].clr & CPU_INTR_WINDOW)) {
-		report_skip("CPU does not support the \"interrupt-window exiting\" VM-execution control.");
+		report_skip("%s :\"Interrupt-window exiting\" exec control not supported", __func__);
 		return;
 	}
 
@@ -8880,7 +8880,7 @@ static void vmx_store_tsc_test(void)
 	u64 low, high;
 
 	if (!(ctrl_cpu_rev[0].clr & CPU_USE_TSC_OFFSET)) {
-		report_skip("'Use TSC offsetting' not supported");
+		report_skip("%s :\"Use TSC offsetting\" exec control not supported", __func__);
 		return;
 	}
 
@@ -8967,7 +8967,7 @@ static void vmx_preemption_timer_zero_test(void)
 	u32 reason;
 
 	if (!(ctrl_pin_rev.clr & PIN_PREEMPT)) {
-		report_skip("'Activate VMX-preemption timer' not supported");
+		report_skip("%s :\"Activate VMX-preemption timer\" pin control not supported", __func__);
 		return;
 	}
 
@@ -9082,7 +9082,7 @@ static void vmx_preemption_timer_tf_test(void)
 	int i;
 
 	if (!(ctrl_pin_rev.clr & PIN_PREEMPT)) {
-		report_skip("'Activate VMX-preemption timer' not supported");
+		report_skip("%s :\"Activate VMX-preemption timer\" pin control not supported", __func__);
 		return;
 	}
 
@@ -9173,7 +9173,7 @@ static void vmx_preemption_timer_expiry_test(void)
 	u32 reason;
 
 	if (!(ctrl_pin_rev.clr & PIN_PREEMPT)) {
-		report_skip("'Activate VMX-preemption timer' not supported");
+		report_skip("%s :\"Activate VMX-preemption timer\" pin control not supported", __func__);
 		return;
 	}
 
@@ -9481,7 +9481,7 @@ static void vmx_eoi_bitmap_ioapic_scan_test_guest(void)
 static void vmx_eoi_bitmap_ioapic_scan_test(void)
 {
 	if (!cpu_has_apicv() || (cpu_count() < 2)) {
-		report_skip(__func__);
+		report_skip("%s :Not all required APICv bits supported or CPU count < 2", __func__);
 		return;
 	}
 
@@ -9526,7 +9526,7 @@ static void vmx_hlt_with_rvi_guest(void)
 static void vmx_hlt_with_rvi_test(void)
 {
 	if (!cpu_has_apicv()) {
-		report_skip(__func__);
+		report_skip("%s :Not all required APICv bits supported", __func__);
 		return;
 	}
 
@@ -9584,13 +9584,13 @@ static void vmx_apic_passthrough_guest(void)
 static void vmx_apic_passthrough(bool set_irq_line_from_thread)
 {
 	if (set_irq_line_from_thread && (cpu_count() < 2)) {
-		report_skip(__func__);
+		report_skip("%s :CPU count < 2", __func__);
 		return;
 	}
 
 	/* Test device is required for generating IRQs */
 	if (!test_device_enabled()) {
-		report_skip(__func__);
+		report_skip("%s :No test device enabled", __func__);
 		return;
 	}
 	u64 cpu_ctrl_0 = CPU_SECONDARY;
@@ -9771,7 +9771,7 @@ static void vmx_init_signal_test(void)
 	struct vmcs *test_vmcs;
 
 	if (cpu_count() < 2) {
-		report_skip(__func__);
+		report_skip("%s :CPU count < 2", __func__);
 		return;
 	}
 
@@ -9970,12 +9970,12 @@ static void sipi_test_ap_thread(void *data)
 static void vmx_sipi_signal_test(void)
 {
 	if (!(rdmsr(MSR_IA32_VMX_MISC) & MSR_IA32_VMX_MISC_ACTIVITY_WAIT_SIPI)) {
-		printf("\tACTIVITY_WAIT_SIPI state is not supported.\n");
+		report_skip("\t\"ACTIVITY_WAIT_SIPI state\" not supported");
 		return;
 	}
 
 	if (cpu_count() < 2) {
-		report_skip(__func__);
+		report_skip("%s :CPU count < 2", __func__);
 		return;
 	}
 
@@ -10271,18 +10271,18 @@ static void vmx_vmcs_shadow_test(void)
 	struct vmcs *shadow;
 
 	if (!(ctrl_cpu_rev[0].clr & CPU_SECONDARY)) {
-		printf("\t'Activate secondary controls' not supported.\n");
+		report_skip("\t\"Activate secondary controls\" not supported");
 		return;
 	}
 
 	if (!(ctrl_cpu_rev[1].clr & CPU_SHADOW_VMCS)) {
-		printf("\t'VMCS shadowing' not supported.\n");
+		report_skip("\t\"VMCS shadowing\" not supported");
 		return;
 	}
 
 	if (!(rdmsr(MSR_IA32_VMX_MISC) &
 	      MSR_IA32_VMX_MISC_VMWRITE_SHADOW_RO_FIELDS)) {
-		printf("\tVMWRITE can't modify VM-exit information fields.\n");
+		report_skip("\tVMWRITE can't modify VM-exit information fields.");
 		return;
 	}
 
@@ -10509,7 +10509,7 @@ static void atomic_switch_msrs_test(int count)
 	 * available with the "TSC flag" and used to populate the MSR lists.
 	 */
 	if (!(cpuid(1).d & (1 << 4))) {
-		report_skip(__func__);
+		report_skip("%s :\"Time Stamp Counter\" not supported", __func__);
 		return;
 	}
 
-- 
2.31.1

