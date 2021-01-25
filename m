Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0540F303417
	for <lists+kvm@lfdr.de>; Tue, 26 Jan 2021 06:16:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730204AbhAZFO7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 26 Jan 2021 00:14:59 -0500
Received: from mga14.intel.com ([192.55.52.115]:22894 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726569AbhAYJ0V (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 25 Jan 2021 04:26:21 -0500
IronPort-SDR: wOx4Aky5mXPxW/i/3P4ehYOqL0kY/T43CuIxwo6eG1CaKP8clk4eY2CC44+OZzqFkUukDpEBEs
 HX/TCPjlNrAw==
X-IronPort-AV: E=McAfee;i="6000,8403,9874"; a="178915778"
X-IronPort-AV: E=Sophos;i="5.79,373,1602572400"; 
   d="scan'208";a="178915778"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Jan 2021 01:07:07 -0800
IronPort-SDR: ocCu9Z0B5ky92hVKS7AyowiyK2Dqw2QK/mB2e1D0SrKDdU2JNP8BPRJPONjd4BA4rpVppe0PTn
 3MJV4rpElHTg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.79,373,1602572400"; 
   d="scan'208";a="402223840"
Received: from sqa-gate.sh.intel.com (HELO robert-ivt.tsp.org) ([10.239.48.212])
  by fmsmga004.fm.intel.com with ESMTP; 25 Jan 2021 01:07:04 -0800
From:   Robert Hoo <robert.hu@linux.intel.com>
To:     pbonzini@redhat.com, seanjc@google.com, vkuznets@redhat.com,
        wanpengli@tencent.com, jmattson@google.com, joro@8bytes.org
Cc:     chang.seok.bae@intel.com, kvm@vger.kernel.org, robert.hu@intel.com,
        Robert Hoo <robert.hu@linux.intel.com>
Subject: [RFC PATCH 03/12] kvm/vmx: Introduce the new tertiary processor-based VM-execution controls
Date:   Mon, 25 Jan 2021 17:06:11 +0800
Message-Id: <1611565580-47718-4-git-send-email-robert.hu@linux.intel.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1611565580-47718-1-git-send-email-robert.hu@linux.intel.com>
References: <1611565580-47718-1-git-send-email-robert.hu@linux.intel.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The Tertiary Exec Control field is enabled by Primary Exec Control field's
bit 17. And the Tertiary-Exec-Control-Field.bit[0] in turn controls the
'LOADIWKEY' VM-exit. Its companion VMX CTRL MSR is IA32_VMX_PROCBASED_CTLS3
(0x492). Please be noted that they're 64 bit, different from previous
control fields.

Signed-off-by: Robert Hoo <robert.hu@linux.intel.com>
---
 arch/x86/include/asm/msr-index.h   |  1 +
 arch/x86/include/asm/vmx.h         |  3 +++
 arch/x86/include/asm/vmxfeatures.h |  3 ++-
 arch/x86/kernel/cpu/feat_ctl.c     |  9 +++++++++
 arch/x86/kvm/vmx/capabilities.h    |  7 +++++++
 arch/x86/kvm/vmx/vmcs.h            |  1 +
 arch/x86/kvm/vmx/vmx.c             | 23 ++++++++++++++++++++---
 arch/x86/kvm/vmx/vmx.h             |  8 ++++++++
 8 files changed, 51 insertions(+), 4 deletions(-)

diff --git a/arch/x86/include/asm/msr-index.h b/arch/x86/include/asm/msr-index.h
index c0b9157..3bca658 100644
--- a/arch/x86/include/asm/msr-index.h
+++ b/arch/x86/include/asm/msr-index.h
@@ -902,6 +902,7 @@
 #define MSR_IA32_VMX_TRUE_EXIT_CTLS      0x0000048f
 #define MSR_IA32_VMX_TRUE_ENTRY_CTLS     0x00000490
 #define MSR_IA32_VMX_VMFUNC             0x00000491
+#define MSR_IA32_VMX_PROCBASED_CTLS3    0x00000492
 
 /* VMX_BASIC bits and bitmasks */
 #define VMX_BASIC_VMCS_SIZE_SHIFT	32
diff --git a/arch/x86/include/asm/vmx.h b/arch/x86/include/asm/vmx.h
index f8ba528..1517692 100644
--- a/arch/x86/include/asm/vmx.h
+++ b/arch/x86/include/asm/vmx.h
@@ -31,6 +31,7 @@
 #define CPU_BASED_RDTSC_EXITING                 VMCS_CONTROL_BIT(RDTSC_EXITING)
 #define CPU_BASED_CR3_LOAD_EXITING		VMCS_CONTROL_BIT(CR3_LOAD_EXITING)
 #define CPU_BASED_CR3_STORE_EXITING		VMCS_CONTROL_BIT(CR3_STORE_EXITING)
+#define CPU_BASED_ACTIVATE_TERTIARY_CONTROLS    VMCS_CONTROL_BIT(TER_CONTROLS)
 #define CPU_BASED_CR8_LOAD_EXITING              VMCS_CONTROL_BIT(CR8_LOAD_EXITING)
 #define CPU_BASED_CR8_STORE_EXITING             VMCS_CONTROL_BIT(CR8_STORE_EXITING)
 #define CPU_BASED_TPR_SHADOW                    VMCS_CONTROL_BIT(VIRTUAL_TPR)
@@ -219,6 +220,8 @@ enum vmcs_field {
 	ENCLS_EXITING_BITMAP_HIGH	= 0x0000202F,
 	TSC_MULTIPLIER                  = 0x00002032,
 	TSC_MULTIPLIER_HIGH             = 0x00002033,
+	TERTIARY_VM_EXEC_CONTROL        = 0x00002034,
+	TERTIARY_VM_EXEC_CONTROL_HIGH   = 0x00002035,
 	GUEST_PHYSICAL_ADDRESS          = 0x00002400,
 	GUEST_PHYSICAL_ADDRESS_HIGH     = 0x00002401,
 	VMCS_LINK_POINTER               = 0x00002800,
diff --git a/arch/x86/include/asm/vmxfeatures.h b/arch/x86/include/asm/vmxfeatures.h
index 9915990..75a15c2 100644
--- a/arch/x86/include/asm/vmxfeatures.h
+++ b/arch/x86/include/asm/vmxfeatures.h
@@ -5,7 +5,7 @@
 /*
  * Defines VMX CPU feature bits
  */
-#define NVMXINTS			3 /* N 32-bit words worth of info */
+#define NVMXINTS			5 /* N 32-bit words worth of info */
 
 /*
  * Note: If the comment begins with a quoted string, that string is used
@@ -43,6 +43,7 @@
 #define VMX_FEATURE_RDTSC_EXITING	( 1*32+ 12) /* "" VM-Exit on RDTSC */
 #define VMX_FEATURE_CR3_LOAD_EXITING	( 1*32+ 15) /* "" VM-Exit on writes to CR3 */
 #define VMX_FEATURE_CR3_STORE_EXITING	( 1*32+ 16) /* "" VM-Exit on reads from CR3 */
+#define VMX_FEATURE_TER_CONTROLS        (1*32 + 17) /* "" Enable Tertiary VM-Execution Controls */
 #define VMX_FEATURE_CR8_LOAD_EXITING	( 1*32+ 19) /* "" VM-Exit on writes to CR8 */
 #define VMX_FEATURE_CR8_STORE_EXITING	( 1*32+ 20) /* "" VM-Exit on reads from CR8 */
 #define VMX_FEATURE_VIRTUAL_TPR		( 1*32+ 21) /* "vtpr" TPR virtualization, a.k.a. TPR shadow */
diff --git a/arch/x86/kernel/cpu/feat_ctl.c b/arch/x86/kernel/cpu/feat_ctl.c
index 29a3bed..e7bf637 100644
--- a/arch/x86/kernel/cpu/feat_ctl.c
+++ b/arch/x86/kernel/cpu/feat_ctl.c
@@ -15,6 +15,8 @@ enum vmx_feature_leafs {
 	MISC_FEATURES = 0,
 	PRIMARY_CTLS,
 	SECONDARY_CTLS,
+	TERTIARY_CTLS_LOW,
+	TERTIARY_CTLS_HIGH,
 	NR_VMX_FEATURE_WORDS,
 };
 
@@ -42,6 +44,13 @@ static void init_vmx_capabilities(struct cpuinfo_x86 *c)
 	rdmsr_safe(MSR_IA32_VMX_PROCBASED_CTLS2, &ign, &supported);
 	c->vmx_capability[SECONDARY_CTLS] = supported;
 
+	/*
+	 * For tertiary execution controls MSR, it's actually a 64bit allowed-1.
+	 */
+	rdmsr_safe(MSR_IA32_VMX_PROCBASED_CTLS3, &ign, &supported);
+	c->vmx_capability[TERTIARY_CTLS_LOW] = ign;
+	c->vmx_capability[TERTIARY_CTLS_HIGH] = supported;
+
 	rdmsr(MSR_IA32_VMX_PINBASED_CTLS, ign, supported);
 	rdmsr_safe(MSR_IA32_VMX_VMFUNC, &ign, &funcs);
 
diff --git a/arch/x86/kvm/vmx/capabilities.h b/arch/x86/kvm/vmx/capabilities.h
index 3a18614..d8bbde4 100644
--- a/arch/x86/kvm/vmx/capabilities.h
+++ b/arch/x86/kvm/vmx/capabilities.h
@@ -57,6 +57,7 @@ struct vmcs_config {
 	u32 pin_based_exec_ctrl;
 	u32 cpu_based_exec_ctrl;
 	u32 cpu_based_2nd_exec_ctrl;
+	u64 cpu_based_3rd_exec_ctrl;
 	u32 vmexit_ctrl;
 	u32 vmentry_ctrl;
 	struct nested_vmx_msrs nested;
@@ -130,6 +131,12 @@ static inline bool cpu_has_secondary_exec_ctrls(void)
 		CPU_BASED_ACTIVATE_SECONDARY_CONTROLS;
 }
 
+static inline bool cpu_has_tertiary_exec_ctrls(void)
+{
+	return vmcs_config.cpu_based_exec_ctrl &
+		CPU_BASED_ACTIVATE_TERTIARY_CONTROLS;
+}
+
 static inline bool cpu_has_vmx_virtualize_apic_accesses(void)
 {
 	return vmcs_config.cpu_based_2nd_exec_ctrl &
diff --git a/arch/x86/kvm/vmx/vmcs.h b/arch/x86/kvm/vmx/vmcs.h
index 1472c6c..343c329 100644
--- a/arch/x86/kvm/vmx/vmcs.h
+++ b/arch/x86/kvm/vmx/vmcs.h
@@ -48,6 +48,7 @@ struct vmcs_controls_shadow {
 	u32 pin;
 	u32 exec;
 	u32 secondary_exec;
+	u64 tertiary_exec;
 };
 
 /*
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 47b8357..12a926e 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -2376,6 +2376,7 @@ static __init int setup_vmcs_config(struct vmcs_config *vmcs_conf,
 	u32 _pin_based_exec_control = 0;
 	u32 _cpu_based_exec_control = 0;
 	u32 _cpu_based_2nd_exec_control = 0;
+	u64 _cpu_based_3rd_exec_control = 0;
 	u32 _vmexit_control = 0;
 	u32 _vmentry_control = 0;
 
@@ -2397,7 +2398,8 @@ static __init int setup_vmcs_config(struct vmcs_config *vmcs_conf,
 
 	opt = CPU_BASED_TPR_SHADOW |
 	      CPU_BASED_USE_MSR_BITMAPS |
-	      CPU_BASED_ACTIVATE_SECONDARY_CONTROLS;
+	      CPU_BASED_ACTIVATE_SECONDARY_CONTROLS |
+	      CPU_BASED_ACTIVATE_TERTIARY_CONTROLS;
 	if (adjust_vmx_controls(min, opt, MSR_IA32_VMX_PROCBASED_CTLS,
 				&_cpu_based_exec_control) < 0)
 		return -EIO;
@@ -2557,6 +2559,7 @@ static __init int setup_vmcs_config(struct vmcs_config *vmcs_conf,
 	vmcs_conf->pin_based_exec_ctrl = _pin_based_exec_control;
 	vmcs_conf->cpu_based_exec_ctrl = _cpu_based_exec_control;
 	vmcs_conf->cpu_based_2nd_exec_ctrl = _cpu_based_2nd_exec_control;
+	vmcs_conf->cpu_based_3rd_exec_ctrl = _cpu_based_3rd_exec_control;
 	vmcs_conf->vmexit_ctrl         = _vmexit_control;
 	vmcs_conf->vmentry_ctrl        = _vmentry_control;
 
@@ -4200,6 +4203,12 @@ u32 vmx_exec_control(struct vcpu_vmx *vmx)
 #define vmx_adjust_sec_exec_exiting(vmx, exec_control, lname, uname) \
 	vmx_adjust_sec_exec_control(vmx, exec_control, lname, uname, uname##_EXITING, true)
 
+static u64 vmx_tertiary_exec_control(struct vcpu_vmx *vmx)
+{
+	/* Though currently, no special adjustment. There might be in the future*/
+	return vmcs_config.cpu_based_3rd_exec_ctrl;
+}
+
 static void vmx_compute_secondary_exec_control(struct vcpu_vmx *vmx)
 {
 	struct kvm_vcpu *vcpu = &vmx->vcpu;
@@ -4310,6 +4319,9 @@ static void init_vmcs(struct vcpu_vmx *vmx)
 		secondary_exec_controls_set(vmx, vmx->secondary_exec_control);
 	}
 
+	if (cpu_has_tertiary_exec_ctrls())
+		tertiary_exec_controls_set(vmx, vmx_tertiary_exec_control(vmx));
+
 	if (kvm_vcpu_apicv_active(&vmx->vcpu)) {
 		vmcs_write64(EOI_EXIT_BITMAP0, 0);
 		vmcs_write64(EOI_EXIT_BITMAP1, 0);
@@ -5778,6 +5790,7 @@ void dump_vmcs(void)
 {
 	u32 vmentry_ctl, vmexit_ctl;
 	u32 cpu_based_exec_ctrl, pin_based_exec_ctrl, secondary_exec_control;
+	u64 tertiary_exec_control = 0;
 	unsigned long cr4;
 	u64 efer;
 
@@ -5796,6 +5809,9 @@ void dump_vmcs(void)
 	if (cpu_has_secondary_exec_ctrls())
 		secondary_exec_control = vmcs_read32(SECONDARY_VM_EXEC_CONTROL);
 
+	if (cpu_has_tertiary_exec_ctrls())
+		tertiary_exec_control = vmcs_read64(TERTIARY_VM_EXEC_CONTROL);
+
 	pr_err("*** Guest State ***\n");
 	pr_err("CR0: actual=0x%016lx, shadow=0x%016lx, gh_mask=%016lx\n",
 	       vmcs_readl(GUEST_CR0), vmcs_readl(CR0_READ_SHADOW),
@@ -5878,8 +5894,9 @@ void dump_vmcs(void)
 		       vmcs_read64(HOST_IA32_PERF_GLOBAL_CTRL));
 
 	pr_err("*** Control State ***\n");
-	pr_err("PinBased=%08x CPUBased=%08x SecondaryExec=%08x\n",
-	       pin_based_exec_ctrl, cpu_based_exec_ctrl, secondary_exec_control);
+	pr_err("PinBased=0x%08x CPUBased=0x%08x SecondaryExec=0x%08x TertiaryExec=0x%016llx\n",
+	       pin_based_exec_ctrl, cpu_based_exec_ctrl, secondary_exec_control,
+	       tertiary_exec_control);
 	pr_err("EntryControls=%08x ExitControls=%08x\n", vmentry_ctl, vmexit_ctl);
 	pr_err("ExceptionBitmap=%08x PFECmask=%08x PFECmatch=%08x\n",
 	       vmcs_read32(EXCEPTION_BITMAP),
diff --git a/arch/x86/kvm/vmx/vmx.h b/arch/x86/kvm/vmx/vmx.h
index f6f66e5..94f1c27 100644
--- a/arch/x86/kvm/vmx/vmx.h
+++ b/arch/x86/kvm/vmx/vmx.h
@@ -373,6 +373,14 @@ static inline u8 vmx_get_rvi(void)
 BUILD_CONTROLS_SHADOW(exec, CPU_BASED_VM_EXEC_CONTROL)
 BUILD_CONTROLS_SHADOW(secondary_exec, SECONDARY_VM_EXEC_CONTROL)
 
+static inline void tertiary_exec_controls_set(struct vcpu_vmx *vmx, u64 val)
+{
+	if (vmx->loaded_vmcs->controls_shadow.tertiary_exec != val) {
+		vmcs_write64(TERTIARY_VM_EXEC_CONTROL, val);
+		vmx->loaded_vmcs->controls_shadow.tertiary_exec = val;
+	}
+}
+
 static inline void vmx_register_cache_reset(struct kvm_vcpu *vcpu)
 {
 	vcpu->arch.regs_avail = ~((1 << VCPU_REGS_RIP) | (1 << VCPU_REGS_RSP)
-- 
1.8.3.1

