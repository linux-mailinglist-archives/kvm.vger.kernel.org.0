Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B57BD3CB310
	for <lists+kvm@lfdr.de>; Fri, 16 Jul 2021 09:13:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235826AbhGPHQd (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 16 Jul 2021 03:16:33 -0400
Received: from mga02.intel.com ([134.134.136.20]:23842 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235743AbhGPHQb (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 16 Jul 2021 03:16:31 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10046"; a="197873269"
X-IronPort-AV: E=Sophos;i="5.84,244,1620716400"; 
   d="scan'208";a="197873269"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Jul 2021 00:13:36 -0700
X-IronPort-AV: E=Sophos;i="5.84,244,1620716400"; 
   d="scan'208";a="506374997"
Received: from arthur-vostro-3668.sh.intel.com ([10.239.13.1])
  by fmsmga002-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Jul 2021 00:13:31 -0700
From:   Zeng Guang <guang.zeng@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Tony Luck <tony.luck@intel.com>,
        Kan Liang <kan.liang@linux.intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Kim Phillips <kim.phillips@amd.com>,
        Jarkko Sakkinen <jarkko@kernel.org>,
        Jethro Beekman <jethro@fortanix.com>,
        Kai Huang <kai.huang@intel.com>
Cc:     x86@kernel.org, linux-kernel@vger.kernel.org,
        Robert Hu <robert.hu@intel.com>, Gao Chao <chao.gao@intel.com>,
        Zeng Guang <guang.zeng@intel.com>,
        Robert Hoo <robert.hu@linux.intel.com>
Subject: [PATCH 3/6] KVM: VMX: Detect Tertiary VM-Execution control when setup VMCS config
Date:   Fri, 16 Jul 2021 14:48:05 +0800
Message-Id: <20210716064808.14757-4-guang.zeng@intel.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210716064808.14757-1-guang.zeng@intel.com>
References: <20210716064808.14757-1-guang.zeng@intel.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Robert Hoo <robert.hu@linux.intel.com>

Check VMX feature on tertiary execution control in VMCS config setup.
Currently it's not supported for hyper-v and disabled for now.

Signed-off-by: Robert Hoo <robert.hu@linux.intel.com>
Signed-off-by: Zeng Guang <guang.zeng@intel.com>
---
 arch/x86/include/asm/vmx.h      |  3 +++
 arch/x86/kvm/vmx/capabilities.h |  7 ++++++
 arch/x86/kvm/vmx/evmcs.c        |  2 ++
 arch/x86/kvm/vmx/evmcs.h        |  1 +
 arch/x86/kvm/vmx/vmcs.h         |  1 +
 arch/x86/kvm/vmx/vmx.c          | 44 ++++++++++++++++++++++++++++++++-
 arch/x86/kvm/vmx/vmx.h          |  1 +
 7 files changed, 58 insertions(+), 1 deletion(-)

diff --git a/arch/x86/include/asm/vmx.h b/arch/x86/include/asm/vmx.h
index 0ffaa3156a4e..15652047f2db 100644
--- a/arch/x86/include/asm/vmx.h
+++ b/arch/x86/include/asm/vmx.h
@@ -31,6 +31,7 @@
 #define CPU_BASED_RDTSC_EXITING                 VMCS_CONTROL_BIT(RDTSC_EXITING)
 #define CPU_BASED_CR3_LOAD_EXITING		VMCS_CONTROL_BIT(CR3_LOAD_EXITING)
 #define CPU_BASED_CR3_STORE_EXITING		VMCS_CONTROL_BIT(CR3_STORE_EXITING)
+#define CPU_BASED_ACTIVATE_TERTIARY_CONTROLS	VMCS_CONTROL_BIT(TER_CONTROLS)
 #define CPU_BASED_CR8_LOAD_EXITING              VMCS_CONTROL_BIT(CR8_LOAD_EXITING)
 #define CPU_BASED_CR8_STORE_EXITING             VMCS_CONTROL_BIT(CR8_STORE_EXITING)
 #define CPU_BASED_TPR_SHADOW                    VMCS_CONTROL_BIT(VIRTUAL_TPR)
@@ -221,6 +222,8 @@ enum vmcs_field {
 	ENCLS_EXITING_BITMAP_HIGH	= 0x0000202F,
 	TSC_MULTIPLIER                  = 0x00002032,
 	TSC_MULTIPLIER_HIGH             = 0x00002033,
+	TERTIARY_VM_EXEC_CONTROL	= 0x00002034,
+	TERTIARY_VM_EXEC_CONTROL_HIGH	= 0x00002035,
 	GUEST_PHYSICAL_ADDRESS          = 0x00002400,
 	GUEST_PHYSICAL_ADDRESS_HIGH     = 0x00002401,
 	VMCS_LINK_POINTER               = 0x00002800,
diff --git a/arch/x86/kvm/vmx/capabilities.h b/arch/x86/kvm/vmx/capabilities.h
index 4705ad55abb5..38d414f64e61 100644
--- a/arch/x86/kvm/vmx/capabilities.h
+++ b/arch/x86/kvm/vmx/capabilities.h
@@ -59,6 +59,7 @@ struct vmcs_config {
 	u32 pin_based_exec_ctrl;
 	u32 cpu_based_exec_ctrl;
 	u32 cpu_based_2nd_exec_ctrl;
+	u64 cpu_based_3rd_exec_ctrl;
 	u32 vmexit_ctrl;
 	u32 vmentry_ctrl;
 	struct nested_vmx_msrs nested;
@@ -131,6 +132,12 @@ static inline bool cpu_has_secondary_exec_ctrls(void)
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
diff --git a/arch/x86/kvm/vmx/evmcs.c b/arch/x86/kvm/vmx/evmcs.c
index 896b2a50b4aa..03c15e1e5807 100644
--- a/arch/x86/kvm/vmx/evmcs.c
+++ b/arch/x86/kvm/vmx/evmcs.c
@@ -299,8 +299,10 @@ const unsigned int nr_evmcs_1_fields = ARRAY_SIZE(vmcs_field_to_evmcs_1);
 
 __init void evmcs_sanitize_exec_ctrls(struct vmcs_config *vmcs_conf)
 {
+	vmcs_conf->cpu_based_exec_ctrl &= ~EVMCS1_UNSUPPORTED_EXEC_CTRL;
 	vmcs_conf->pin_based_exec_ctrl &= ~EVMCS1_UNSUPPORTED_PINCTRL;
 	vmcs_conf->cpu_based_2nd_exec_ctrl &= ~EVMCS1_UNSUPPORTED_2NDEXEC;
+	vmcs_conf->cpu_based_3rd_exec_ctrl = 0;
 
 	vmcs_conf->vmexit_ctrl &= ~EVMCS1_UNSUPPORTED_VMEXIT_CTRL;
 	vmcs_conf->vmentry_ctrl &= ~EVMCS1_UNSUPPORTED_VMENTRY_CTRL;
diff --git a/arch/x86/kvm/vmx/evmcs.h b/arch/x86/kvm/vmx/evmcs.h
index 2ec9b46f0d0c..8a20295f4f0f 100644
--- a/arch/x86/kvm/vmx/evmcs.h
+++ b/arch/x86/kvm/vmx/evmcs.h
@@ -50,6 +50,7 @@ DECLARE_STATIC_KEY_FALSE(enable_evmcs);
  */
 #define EVMCS1_UNSUPPORTED_PINCTRL (PIN_BASED_POSTED_INTR | \
 				    PIN_BASED_VMX_PREEMPTION_TIMER)
+#define EVMCS1_UNSUPPORTED_EXEC_CTRL (CPU_BASED_ACTIVATE_TERTIARY_CONTROLS)
 #define EVMCS1_UNSUPPORTED_2NDEXEC					\
 	(SECONDARY_EXEC_VIRTUAL_INTR_DELIVERY |				\
 	 SECONDARY_EXEC_VIRTUALIZE_APIC_ACCESSES |			\
diff --git a/arch/x86/kvm/vmx/vmcs.h b/arch/x86/kvm/vmx/vmcs.h
index 4b9957e2bf5b..83e2065a955d 100644
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
index 927a552393b9..728873971913 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -2391,6 +2391,23 @@ static __init int adjust_vmx_controls(u32 ctl_min, u32 ctl_opt,
 	return 0;
 }
 
+static __init int adjust_vmx_controls_64(u64 ctl_min, u64 ctl_opt,
+					 u32 msr, u64 *result)
+{
+	u64 vmx_msr;
+	u64 ctl = ctl_min | ctl_opt;
+
+	rdmsrl(msr, vmx_msr);
+	ctl &= vmx_msr; /* bit == 1 means it can be set */
+
+	/* Ensure minimum (required) set of control bits are supported. */
+	if (ctl_min & ~ctl)
+		return -EIO;
+
+	*result = ctl;
+	return 0;
+}
+
 static __init int setup_vmcs_config(struct vmcs_config *vmcs_conf,
 				    struct vmx_capability *vmx_cap)
 {
@@ -2399,6 +2416,7 @@ static __init int setup_vmcs_config(struct vmcs_config *vmcs_conf,
 	u32 _pin_based_exec_control = 0;
 	u32 _cpu_based_exec_control = 0;
 	u32 _cpu_based_2nd_exec_control = 0;
+	u64 _cpu_based_3rd_exec_control = 0;
 	u32 _vmexit_control = 0;
 	u32 _vmentry_control = 0;
 
@@ -2420,7 +2438,8 @@ static __init int setup_vmcs_config(struct vmcs_config *vmcs_conf,
 
 	opt = CPU_BASED_TPR_SHADOW |
 	      CPU_BASED_USE_MSR_BITMAPS |
-	      CPU_BASED_ACTIVATE_SECONDARY_CONTROLS;
+	      CPU_BASED_ACTIVATE_SECONDARY_CONTROLS |
+	      CPU_BASED_ACTIVATE_TERTIARY_CONTROLS;
 	if (adjust_vmx_controls(min, opt, MSR_IA32_VMX_PROCBASED_CTLS,
 				&_cpu_based_exec_control) < 0)
 		return -EIO;
@@ -2494,6 +2513,16 @@ static __init int setup_vmcs_config(struct vmcs_config *vmcs_conf,
 				"1-setting enable VPID VM-execution control\n");
 	}
 
+	if (_cpu_based_exec_control & CPU_BASED_ACTIVATE_TERTIARY_CONTROLS) {
+		u64 opt3 = 0;
+		u64 min3 = 0;
+
+		if (adjust_vmx_controls_64(min3, opt3,
+					   MSR_IA32_VMX_PROCBASED_CTLS3,
+					   &_cpu_based_3rd_exec_control))
+			return -EIO;
+	}
+
 	min = VM_EXIT_SAVE_DEBUG_CONTROLS | VM_EXIT_ACK_INTR_ON_EXIT;
 #ifdef CONFIG_X86_64
 	min |= VM_EXIT_HOST_ADDR_SPACE_SIZE;
@@ -2581,6 +2610,7 @@ static __init int setup_vmcs_config(struct vmcs_config *vmcs_conf,
 	vmcs_conf->pin_based_exec_ctrl = _pin_based_exec_control;
 	vmcs_conf->cpu_based_exec_ctrl = _cpu_based_exec_control;
 	vmcs_conf->cpu_based_2nd_exec_ctrl = _cpu_based_2nd_exec_control;
+	vmcs_conf->cpu_based_3rd_exec_ctrl = _cpu_based_3rd_exec_control;
 	vmcs_conf->vmexit_ctrl         = _vmexit_control;
 	vmcs_conf->vmentry_ctrl        = _vmentry_control;
 
@@ -4204,6 +4234,13 @@ vmx_adjust_secondary_exec_control(struct vcpu_vmx *vmx, u32 *exec_control,
 #define vmx_adjust_sec_exec_exiting(vmx, exec_control, lname, uname) \
 	vmx_adjust_sec_exec_control(vmx, exec_control, lname, uname, uname##_EXITING, true)
 
+static void vmx_compute_tertiary_exec_control(struct vcpu_vmx *vmx)
+{
+	u32 exec_control = vmcs_config.cpu_based_3rd_exec_ctrl;
+
+	vmx->tertiary_exec_control = exec_control;
+}
+
 static void vmx_compute_secondary_exec_control(struct vcpu_vmx *vmx)
 {
 	struct kvm_vcpu *vcpu = &vmx->vcpu;
@@ -4319,6 +4356,11 @@ static void init_vmcs(struct vcpu_vmx *vmx)
 		secondary_exec_controls_set(vmx, vmx->secondary_exec_control);
 	}
 
+	if (cpu_has_tertiary_exec_ctrls()) {
+		vmx_compute_tertiary_exec_control(vmx);
+		tertiary_exec_controls_set(vmx, vmx->tertiary_exec_control);
+	}
+
 	if (kvm_vcpu_apicv_active(&vmx->vcpu)) {
 		vmcs_write64(EOI_EXIT_BITMAP0, 0);
 		vmcs_write64(EOI_EXIT_BITMAP1, 0);
diff --git a/arch/x86/kvm/vmx/vmx.h b/arch/x86/kvm/vmx/vmx.h
index 945c6639ce24..c356ceebe84c 100644
--- a/arch/x86/kvm/vmx/vmx.h
+++ b/arch/x86/kvm/vmx/vmx.h
@@ -266,6 +266,7 @@ struct vcpu_vmx {
 	u32		      msr_ia32_umwait_control;
 
 	u32 secondary_exec_control;
+	u64 tertiary_exec_control;
 
 	/*
 	 * loaded_vmcs points to the VMCS currently used in this vcpu. For a
-- 
2.25.1

