Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8DA9F2781F6
	for <lists+kvm@lfdr.de>; Fri, 25 Sep 2020 09:49:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727201AbgIYHtn (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 25 Sep 2020 03:49:43 -0400
Received: from mga01.intel.com ([192.55.52.88]:1027 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726990AbgIYHtn (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 25 Sep 2020 03:49:43 -0400
IronPort-SDR: VWVG6dYUdkDj8A+M49SoVMTc5cfJtHOnPspx5c0fupaNo9ifpbsbGDCKn0MfAQuglp7i9s9JrP
 LzSx60AEq8Tg==
X-IronPort-AV: E=McAfee;i="6000,8403,9754"; a="179549932"
X-IronPort-AV: E=Sophos;i="5.77,301,1596524400"; 
   d="scan'208";a="179549932"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Sep 2020 00:36:40 -0700
IronPort-SDR: v0JNZ2kPgKyEGuUFxrezrdcDS9weHkNrQ48xyt9gP3NehIRlSTyFodjRVAzdsFsTJn2UwtxN74
 R5T+EBlMxKDw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.77,301,1596524400"; 
   d="scan'208";a="306187525"
Received: from yadong-antec.sh.intel.com ([10.239.158.61])
  by orsmga003.jf.intel.com with ESMTP; 25 Sep 2020 00:36:38 -0700
From:   yadong.qi@intel.com
To:     kvm@vger.kernel.org
Cc:     pbonzini@redhat.com, Yadong Qi <yadong.qi@intel.com>
Subject: [kvm-unit-tests PATCH] x86: vmx: Add test for SIPI signal processing
Date:   Fri, 25 Sep 2020 15:36:24 +0800
Message-Id: <20200925073624.245578-1-yadong.qi@intel.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Yadong Qi <yadong.qi@intel.com>

The test verifies the following functionality:
A SIPI signal received when CPU is in VMX non-root mode:
    if ACTIVITY_STATE == WAIT_SIPI
        VMExit with (reason == 4)
    else
        SIPI signal is ignored

The test cases depends on IA32_VMX_MISC:bit(8), if this bit is 1
then the test cases would be executed, otherwise the test cases
would be skiped.

Signed-off-by: Yadong Qi <yadong.qi@intel.com>
---
 lib/x86/msr.h     |   1 +
 x86/unittests.cfg |   8 +++
 x86/vmx.c         |   2 +-
 x86/vmx.h         |   3 ++
 x86/vmx_tests.c   | 134 ++++++++++++++++++++++++++++++++++++++++++++++
 5 files changed, 147 insertions(+), 1 deletion(-)

diff --git a/lib/x86/msr.h b/lib/x86/msr.h
index 6ef5502..29e3947 100644
--- a/lib/x86/msr.h
+++ b/lib/x86/msr.h
@@ -421,6 +421,7 @@
 #define MSR_IA32_VMX_TRUE_ENTRY		0x00000490
 
 /* MSR_IA32_VMX_MISC bits */
+#define MSR_IA32_VMX_MISC_ACTIVITY_WAIT_SIPI		(1ULL << 8)
 #define MSR_IA32_VMX_MISC_VMWRITE_SHADOW_RO_FIELDS	(1ULL << 29)
 
 #define MSR_IA32_TSCDEADLINE		0x000006e0
diff --git a/x86/unittests.cfg b/x86/unittests.cfg
index 3a79151..3e14a65 100644
--- a/x86/unittests.cfg
+++ b/x86/unittests.cfg
@@ -293,6 +293,14 @@ arch = x86_64
 groups = vmx
 timeout = 10
 
+[vmx_sipi_signal_test]
+file = vmx.flat
+smp = 2
+extra_params = -cpu host,+vmx -m 2048 -append vmx_sipi_signal_test
+arch = x86_64
+groups = vmx
+timeout = 10
+
 [vmx_apic_passthrough_tpr_threshold_test]
 file = vmx.flat
 extra_params = -cpu host,+vmx -m 2048 -append vmx_apic_passthrough_tpr_threshold_test
diff --git a/x86/vmx.c b/x86/vmx.c
index 07415b4..e3a3fbf 100644
--- a/x86/vmx.c
+++ b/x86/vmx.c
@@ -1369,7 +1369,7 @@ static void init_vmcs_guest(void)
 	vmcs_write(GUEST_INTR_STATE, 0);
 }
 
-static int init_vmcs(struct vmcs **vmcs)
+int init_vmcs(struct vmcs **vmcs)
 {
 	*vmcs = alloc_page();
 	(*vmcs)->hdr.revision_id = basic.revision;
diff --git a/x86/vmx.h b/x86/vmx.h
index d1c2436..9b17074 100644
--- a/x86/vmx.h
+++ b/x86/vmx.h
@@ -697,6 +697,8 @@ enum vm_entry_failure_code {
 
 #define ACTV_ACTIVE		0
 #define ACTV_HLT		1
+#define ACTV_SHUTDOWN		2
+#define ACTV_WAIT_SIPI		3
 
 /*
  * VMCS field encoding:
@@ -856,6 +858,7 @@ static inline bool invvpid(unsigned long type, u64 vpid, u64 gla)
 
 void enable_vmx(void);
 void init_vmx(u64 *vmxon_region);
+int init_vmcs(struct vmcs **vmcs);
 
 const char *exit_reason_description(u64 reason);
 void print_vmexit_info(union exit_reason exit_reason);
diff --git a/x86/vmx_tests.c b/x86/vmx_tests.c
index 22f0c7b..45b0f80 100644
--- a/x86/vmx_tests.c
+++ b/x86/vmx_tests.c
@@ -9608,6 +9608,139 @@ static void vmx_init_signal_test(void)
 	 */
 }
 
+#define SIPI_SIGNAL_TEST_DELAY	100000000ULL
+
+static void vmx_sipi_test_guest(void)
+{
+	if (apic_id() == 0) {
+		/* wait AP enter guest with activity=WAIT_SIPI */
+		while (vmx_get_test_stage() != 1)
+			;
+		delay(SIPI_SIGNAL_TEST_DELAY);
+
+		/* First SIPI signal */
+		apic_icr_write(APIC_DEST_PHYSICAL | APIC_DM_STARTUP | APIC_INT_ASSERT, id_map[1]);
+		report(1, "BSP(L2): Send first SIPI to cpu[%d]", id_map[1]);
+
+		/* wait AP enter guest */
+		while (vmx_get_test_stage() != 2)
+			;
+		delay(SIPI_SIGNAL_TEST_DELAY);
+
+		/* Second SIPI signal should be ignored since AP is not in WAIT_SIPI state */
+		apic_icr_write(APIC_DEST_PHYSICAL | APIC_DM_STARTUP | APIC_INT_ASSERT, id_map[1]);
+		report(1, "BSP(L2): Send second SIPI to cpu[%d]", id_map[1]);
+
+		/* Delay a while to check whether second SIPI would cause VMExit */
+		delay(SIPI_SIGNAL_TEST_DELAY);
+
+		/* Test is done, notify AP to exit test */
+		vmx_set_test_stage(3);
+
+		/* wait AP exit non-root mode */
+		while (vmx_get_test_stage() != 5)
+			;
+	} else {
+		/* wait BSP notify test is done */
+		while (vmx_get_test_stage() != 3)
+			;
+
+		/* AP exit guest */
+		vmx_set_test_stage(4);
+	}
+}
+
+static void sipi_test_ap_thread(void *data)
+{
+	struct vmcs *ap_vmcs;
+	u64 *ap_vmxon_region;
+	void *ap_stack, *ap_syscall_stack;
+	u64 cpu_ctrl_0 = CPU_SECONDARY;
+	u64 cpu_ctrl_1 = 0;
+
+	/* Enter VMX operation (i.e. exec VMXON) */
+	ap_vmxon_region = alloc_page();
+	enable_vmx();
+	init_vmx(ap_vmxon_region);
+	_vmx_on(ap_vmxon_region);
+	init_vmcs(&ap_vmcs);
+	make_vmcs_current(ap_vmcs);
+
+	/* Set stack for AP */
+	ap_stack = alloc_page();
+	ap_syscall_stack = alloc_page();
+	vmcs_write(GUEST_RSP, (u64)(ap_stack + PAGE_SIZE - 1));
+	vmcs_write(GUEST_SYSENTER_ESP, (u64)(ap_syscall_stack + PAGE_SIZE - 1));
+
+	/* passthrough lapic to L2 */
+	disable_intercept_for_x2apic_msrs();
+	vmcs_write(CPU_EXEC_CTRL0, vmcs_read(CPU_EXEC_CTRL0) | cpu_ctrl_0);
+	vmcs_write(CPU_EXEC_CTRL1, vmcs_read(CPU_EXEC_CTRL1) | cpu_ctrl_1);
+
+	/* Set guest activity state to wait-for-SIPI state */
+	vmcs_write(GUEST_ACTV_STATE, ACTV_WAIT_SIPI);
+
+	vmx_set_test_stage(1);
+
+	/* AP enter guest */
+	enter_guest();
+
+	if (vmcs_read(EXI_REASON) == VMX_SIPI) {
+		report(1, "AP: Handle SIPI VMExit");
+		vmcs_write(GUEST_ACTV_STATE, ACTV_ACTIVE);
+		vmx_set_test_stage(2);
+	} else {
+		report(0, "AP: Unexpected VMExit, reason=%ld", vmcs_read(EXI_REASON));
+		vmx_off();
+		return;
+	}
+
+	/* AP enter guest */
+	enter_guest();
+
+	report(vmcs_read(EXI_REASON) != VMX_SIPI,
+		"AP: should no SIPI VMExit since activity is not in WAIT_SIPI state");
+
+	/* notify BSP that AP is already exit from non-root mode */
+	vmx_set_test_stage(5);
+
+	/* Leave VMX operation */
+	vmx_off();
+}
+
+static void vmx_sipi_signal_test(void)
+{
+	if (!(rdmsr(MSR_IA32_VMX_MISC) & MSR_IA32_VMX_MISC_ACTIVITY_WAIT_SIPI)) {
+		printf("\tACTIVITY_WAIT_SIPI state is not supported.\n");
+		return;
+	}
+
+	if (cpu_count() < 2) {
+		report_skip(__func__);
+		return;
+	}
+
+	u64 cpu_ctrl_0 = CPU_SECONDARY;
+	u64 cpu_ctrl_1 = 0;
+
+	/* passthrough lapic */
+	disable_intercept_for_x2apic_msrs();
+	vmcs_write(PIN_CONTROLS, vmcs_read(PIN_CONTROLS) & ~PIN_EXTINT);
+	vmcs_write(CPU_EXEC_CTRL0, vmcs_read(CPU_EXEC_CTRL0) | cpu_ctrl_0);
+	vmcs_write(CPU_EXEC_CTRL1, vmcs_read(CPU_EXEC_CTRL1) | cpu_ctrl_1);
+
+	test_set_guest(vmx_sipi_test_guest);
+
+	/* start AP */
+	on_cpu_async(1, sipi_test_ap_thread, NULL);
+
+	vmx_set_test_stage(0);
+
+	/* BSP enter guest */
+	enter_guest();
+}
+
+
 enum vmcs_access {
 	ACCESS_VMREAD,
 	ACCESS_VMWRITE,
@@ -10244,6 +10377,7 @@ struct vmx_test vmx_tests[] = {
 	TEST(vmx_apic_passthrough_thread_test),
 	TEST(vmx_apic_passthrough_tpr_threshold_test),
 	TEST(vmx_init_signal_test),
+	TEST(vmx_sipi_signal_test),
 	/* VMCS Shadowing tests */
 	TEST(vmx_vmcs_shadow_test),
 	/* Regression tests */
-- 
2.25.1

