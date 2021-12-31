Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9AA80482478
	for <lists+kvm@lfdr.de>; Fri, 31 Dec 2021 15:59:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230499AbhLaO7N (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 31 Dec 2021 09:59:13 -0500
Received: from mga18.intel.com ([134.134.136.126]:29033 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230516AbhLaO7J (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 31 Dec 2021 09:59:09 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1640962749; x=1672498749;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references;
  bh=kV6uZpZsPoQezpqTs1llnARoklxbYvyakusC1X0vRSg=;
  b=W2HSXv+lNUc/yDXTfyHiuy0LkabVOyz95cvp/wYTSVjwRfFAnnnym4oO
   xuxMf46y4YCse20p4hwlrTo8OpP4DyOPQoh88TdXsyhDnHvfVXmk2Cbxo
   IH434SUCLoELeqA6hm3y6w98Fg/fEvdIGReybbp3CY3My3RIS4gC6IbnQ
   AOAmZzgy6SxAXLSSTPO5KucysF7dWldr3vZzFNSX/wtgkv8+qqccTzBob
   XdUxW5Nn64DJit8ztv2OxmxeXuQJEoqFsJSwjwlR5t4vRVWjtw7DnDhi2
   +XyI0aS1kx+VQ4gtEnxLPYdNo+9Gu6AL2am3rm6k3Df3IehRK+Tj4Qg8R
   Q==;
X-IronPort-AV: E=McAfee;i="6200,9189,10213"; a="228641856"
X-IronPort-AV: E=Sophos;i="5.88,251,1635231600"; 
   d="scan'208";a="228641856"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 Dec 2021 06:59:09 -0800
X-IronPort-AV: E=Sophos;i="5.88,251,1635231600"; 
   d="scan'208";a="524758439"
Received: from arthur-vostro-3668.sh.intel.com ([10.239.13.120])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 Dec 2021 06:59:03 -0800
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
Subject: [PATCH v5 3/8] KVM: VMX: Detect Tertiary VM-Execution control when setup VMCS config
Date:   Fri, 31 Dec 2021 22:28:44 +0800
Message-Id: <20211231142849.611-4-guang.zeng@intel.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20211231142849.611-1-guang.zeng@intel.com>
References: <20211231142849.611-1-guang.zeng@intel.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Robert Hoo <robert.hu@linux.intel.com>

Check VMX features on tertiary execution control in VMCS config setup.
Sub-features in tertiary execution control to be enabled are adjusted
according to hardware capabilities although no sub-feature is enabled
in this patch.

EVMCSv1 doesn't support tertiary VM-execution control, so disable it
when EVMCSv1 is in use. And define the auxiliary functions for Tertiary
control field here, using the new BUILD_CONTROLS_SHADOW().

Signed-off-by: Robert Hoo <robert.hu@linux.intel.com>
Signed-off-by: Zeng Guang <guang.zeng@intel.com>
---
 arch/x86/include/asm/vmx.h      |  3 +++
 arch/x86/kvm/vmx/capabilities.h |  7 ++++++
 arch/x86/kvm/vmx/evmcs.c        |  2 ++
 arch/x86/kvm/vmx/evmcs.h        |  1 +
 arch/x86/kvm/vmx/vmcs.h         |  1 +
 arch/x86/kvm/vmx/vmx.c          | 38 ++++++++++++++++++++++++++++++++-
 arch/x86/kvm/vmx/vmx.h          |  1 +
 7 files changed, 52 insertions(+), 1 deletion(-)

diff --git a/arch/x86/include/asm/vmx.h b/arch/x86/include/asm/vmx.h
index 0ffaa3156a4e..8c929596a299 100644
--- a/arch/x86/include/asm/vmx.h
+++ b/arch/x86/include/asm/vmx.h
@@ -31,6 +31,7 @@
 #define CPU_BASED_RDTSC_EXITING                 VMCS_CONTROL_BIT(RDTSC_EXITING)
 #define CPU_BASED_CR3_LOAD_EXITING		VMCS_CONTROL_BIT(CR3_LOAD_EXITING)
 #define CPU_BASED_CR3_STORE_EXITING		VMCS_CONTROL_BIT(CR3_STORE_EXITING)
+#define CPU_BASED_ACTIVATE_TERTIARY_CONTROLS	VMCS_CONTROL_BIT(TERTIARY_CONTROLS)
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
index ba6f99f584ac..03e7c80186fb 100644
--- a/arch/x86/kvm/vmx/evmcs.c
+++ b/arch/x86/kvm/vmx/evmcs.c
@@ -298,8 +298,10 @@ const unsigned int nr_evmcs_1_fields = ARRAY_SIZE(vmcs_field_to_evmcs_1);
 
 __init void evmcs_sanitize_exec_ctrls(struct vmcs_config *vmcs_conf)
 {
+	vmcs_conf->cpu_based_exec_ctrl &= ~EVMCS1_UNSUPPORTED_EXEC_CTRL;
 	vmcs_conf->pin_based_exec_ctrl &= ~EVMCS1_UNSUPPORTED_PINCTRL;
 	vmcs_conf->cpu_based_2nd_exec_ctrl &= ~EVMCS1_UNSUPPORTED_2NDEXEC;
+	vmcs_conf->cpu_based_3rd_exec_ctrl = 0;
 
 	vmcs_conf->vmexit_ctrl &= ~EVMCS1_UNSUPPORTED_VMEXIT_CTRL;
 	vmcs_conf->vmentry_ctrl &= ~EVMCS1_UNSUPPORTED_VMENTRY_CTRL;
diff --git a/arch/x86/kvm/vmx/evmcs.h b/arch/x86/kvm/vmx/evmcs.h
index 16731d2cf231..65fd2b9f893c 100644
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
index 6e5de2e2b0da..b9d18cfcf837 100644
--- a/arch/x86/kvm/vmx/vmcs.h
+++ b/arch/x86/kvm/vmx/vmcs.h
@@ -50,6 +50,7 @@ struct vmcs_controls_shadow {
 	u32 pin;
 	u32 exec;
 	u32 secondary_exec;
+	u64 tertiary_exec;
 };
 
 /*
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 5aadad3e7367..fb0f600368c6 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -2383,6 +2383,21 @@ static __init int adjust_vmx_controls(u32 ctl_min, u32 ctl_opt,
 	return 0;
 }
 
+static __init int adjust_vmx_controls_64(u64 ctl_min, u64 ctl_opt,
+					 u32 msr, u64 *result)
+{
+	u64 allowed1;
+
+	rdmsrl(msr, allowed1);
+
+	/* Ensure minimum (required) set of control bits are supported. */
+	if (ctl_min & ~allowed1)
+		return -EIO;
+
+	*result = (ctl_min | ctl_opt) & allowed1;
+	return 0;
+}
+
 static __init int setup_vmcs_config(struct vmcs_config *vmcs_conf,
 				    struct vmx_capability *vmx_cap)
 {
@@ -2391,6 +2406,7 @@ static __init int setup_vmcs_config(struct vmcs_config *vmcs_conf,
 	u32 _pin_based_exec_control = 0;
 	u32 _cpu_based_exec_control = 0;
 	u32 _cpu_based_2nd_exec_control = 0;
+	u64 _cpu_based_3rd_exec_control = 0;
 	u32 _vmexit_control = 0;
 	u32 _vmentry_control = 0;
 
@@ -2412,7 +2428,8 @@ static __init int setup_vmcs_config(struct vmcs_config *vmcs_conf,
 
 	opt = CPU_BASED_TPR_SHADOW |
 	      CPU_BASED_USE_MSR_BITMAPS |
-	      CPU_BASED_ACTIVATE_SECONDARY_CONTROLS;
+	      CPU_BASED_ACTIVATE_SECONDARY_CONTROLS |
+	      CPU_BASED_ACTIVATE_TERTIARY_CONTROLS;
 	if (adjust_vmx_controls(min, opt, MSR_IA32_VMX_PROCBASED_CTLS,
 				&_cpu_based_exec_control) < 0)
 		return -EIO;
@@ -2486,6 +2503,16 @@ static __init int setup_vmcs_config(struct vmcs_config *vmcs_conf,
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
@@ -2573,6 +2600,7 @@ static __init int setup_vmcs_config(struct vmcs_config *vmcs_conf,
 	vmcs_conf->pin_based_exec_ctrl = _pin_based_exec_control;
 	vmcs_conf->cpu_based_exec_ctrl = _cpu_based_exec_control;
 	vmcs_conf->cpu_based_2nd_exec_ctrl = _cpu_based_2nd_exec_control;
+	vmcs_conf->cpu_based_3rd_exec_ctrl = _cpu_based_3rd_exec_control;
 	vmcs_conf->vmexit_ctrl         = _vmexit_control;
 	vmcs_conf->vmentry_ctrl        = _vmentry_control;
 
@@ -4128,6 +4156,11 @@ static u32 vmx_exec_control(struct vcpu_vmx *vmx)
 	return exec_control;
 }
 
+static u64 vmx_tertiary_exec_control(struct vcpu_vmx *vmx)
+{
+	return vmcs_config.cpu_based_3rd_exec_ctrl;
+}
+
 /*
  * Adjust a single secondary execution control bit to intercept/allow an
  * instruction in the guest.  This is usually done based on whether or not a
@@ -4293,6 +4326,9 @@ static void init_vmcs(struct vcpu_vmx *vmx)
 	if (cpu_has_secondary_exec_ctrls())
 		secondary_exec_controls_set(vmx, vmx_secondary_exec_control(vmx));
 
+	if (cpu_has_tertiary_exec_ctrls())
+		tertiary_exec_controls_set(vmx, vmx_tertiary_exec_control(vmx));
+
 	if (kvm_vcpu_apicv_active(&vmx->vcpu)) {
 		vmcs_write64(EOI_EXIT_BITMAP0, 0);
 		vmcs_write64(EOI_EXIT_BITMAP1, 0);
diff --git a/arch/x86/kvm/vmx/vmx.h b/arch/x86/kvm/vmx/vmx.h
index 07e1753225bf..ee94068ca8fb 100644
--- a/arch/x86/kvm/vmx/vmx.h
+++ b/arch/x86/kvm/vmx/vmx.h
@@ -475,6 +475,7 @@ BUILD_CONTROLS_SHADOW(vm_exit, VM_EXIT_CONTROLS, 32)
 BUILD_CONTROLS_SHADOW(pin, PIN_BASED_VM_EXEC_CONTROL, 32)
 BUILD_CONTROLS_SHADOW(exec, CPU_BASED_VM_EXEC_CONTROL, 32)
 BUILD_CONTROLS_SHADOW(secondary_exec, SECONDARY_VM_EXEC_CONTROL, 32)
+BUILD_CONTROLS_SHADOW(tertiary_exec, TERTIARY_VM_EXEC_CONTROL, 64)
 
 static inline void vmx_register_cache_reset(struct kvm_vcpu *vcpu)
 {
-- 
2.27.0

