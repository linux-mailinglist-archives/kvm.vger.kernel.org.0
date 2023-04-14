Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 773616E1C95
	for <lists+kvm@lfdr.de>; Fri, 14 Apr 2023 08:26:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230111AbjDNG0h (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 14 Apr 2023 02:26:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54712 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230131AbjDNG03 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 14 Apr 2023 02:26:29 -0400
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 161D96EA1;
        Thu, 13 Apr 2023 23:26:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1681453582; x=1712989582;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=xRzDBzoEyYo9iIVRTeKt+yPTk028TscrKmG0falY8hY=;
  b=IFJXOo5AKS5bLNgbkTCQhHB5LIbhfxn2vLcdGuCbbtRHOJ75QCcSNtrk
   YuKFcrJgv5dVKQlT2s0H1Yc7r558GPGu990QhjrAzJbc7XNGlrrG9TeRI
   pgo84iQYWp58L2glwcy7zaddJGIIxuiYtZSABkjTfG4e88AN3DereUi32
   ehZf/crwmIhn351ic5WM9J6L1LQc7KORoDFKmwV4J14DaLt2SmqPOGWcR
   DXbGhvEMZ/5Lda1C1NKkoN8UISzWxmCGmQcRbPcFUW/SFw7lIVAE8aEHF
   H3fpafoj/eqDy8e847tJv/phQuEXRz76njVntU+pdCBaN1EHkyp5FrsRm
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10679"; a="341892744"
X-IronPort-AV: E=Sophos;i="5.99,195,1677571200"; 
   d="scan'208";a="341892744"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Apr 2023 23:26:21 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10679"; a="935885866"
X-IronPort-AV: E=Sophos;i="5.99,195,1677571200"; 
   d="scan'208";a="935885866"
Received: from spr.sh.intel.com ([10.239.53.106])
  by fmsmga006-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Apr 2023 23:26:17 -0700
From:   Chao Gao <chao.gao@intel.com>
To:     kvm@vger.kernel.org
Cc:     Jiaan Lu <jiaan.lu@intel.com>, Zhang Chen <chen.zhang@intel.com>,
        Chao Gao <chao.gao@intel.com>,
        Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org
Subject: [RFC PATCH v2 04/11] KVM: VMX: Add IA32_SPEC_CTRL virtualization support
Date:   Fri, 14 Apr 2023 14:25:25 +0800
Message-Id: <20230414062545.270178-5-chao.gao@intel.com>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230414062545.270178-1-chao.gao@intel.com>
References: <20230414062545.270178-1-chao.gao@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Zhang Chen <chen.zhang@intel.com>

Currently KVM disables interception of IA32_SPEC_CTRL after a non-0 is
written to IA32_SPEC_CTRL by guest. Then, guest is allowed to write any
value to hardware.

"virtualize IA32_SPEC_CTRL" is a new tertiary vm-exec control. This
feature allows KVM to specify that certain bits of the IA32_SPEC_CTRL
MSR cannot be modified by guest software.

Two VMCS fields are added:

  IA32_SPEC_CTRL_MASK:   bits that guest software cannot modify
  IA32_SPEC_CTRL_SHADOW: value that guest software expects to be in the
			 IA32_SPEC_CTRL MSR

On rdmsr, the shadow value is returned. on wrmsr, EDX:EAX is written
to the IA32_SPEC_CTRL_SHADOW and (cur_val & mask) | (EDX:EAX & ~mask)
is written to the IA32_SPEC_CTRL MSR, where
  * cur_val is the original value of IA32_SPEC_CTRL MSR
  * mask is the value of IA32_SPEC_CTRL_MASK

Add a mask e.g., loaded_vmcs->spec_ctrl_mask to represent the bits guest
shouldn't change. It is 0 for now and some bits will be added by
following patches. Use per-vmcs cache to avoid unnecessary vmcs_write()
on nested transition because the mask is expected to be rarely changed
and the same for vmcs01 and vmcs02.

To prevent guest from changing the bits in the mask, enable "virtualize
IA32_SPEC_CTRL" if supported or emulate its behavior by intercepting
the IA32_SPEC_CTRL msr. Emulating "virtualize IA32_SPEC_CTRL" behavior
is mainly to give the same capability to KVM running on potential broken
hardware or L1 guests.

To avoid L2 evading the enforcement, enable "virtualize IA32_SPEC_CTRL"
in vmcs02. Always update the guest (shadow) value of IA32_SPEC_CTRL MSR
and the mask to preserve them across nested transitions. Note that the
shadow value may be changed because L2 may access the IA32_SPEC_CTRL
directly and the mask may be changed due to migration when L2 vCPUs are
running.

Co-developed-by: Chao Gao <chao.gao@intel.com>
Signed-off-by: Chao Gao <chao.gao@intel.com>
Signed-off-by: Zhang Chen <chen.zhang@intel.com>
Signed-off-by: Chao Gao <chao.gao@intel.com>
Tested-by: Jiaan Lu <jiaan.lu@intel.com>
---
 arch/x86/include/asm/vmx.h         |  5 ++++
 arch/x86/include/asm/vmxfeatures.h |  2 ++
 arch/x86/kvm/vmx/capabilities.h    |  5 ++++
 arch/x86/kvm/vmx/nested.c          | 13 ++++++++++
 arch/x86/kvm/vmx/vmcs.h            |  2 ++
 arch/x86/kvm/vmx/vmx.c             | 34 ++++++++++++++++++++-----
 arch/x86/kvm/vmx/vmx.h             | 40 +++++++++++++++++++++++++++++-
 7 files changed, 94 insertions(+), 7 deletions(-)

diff --git a/arch/x86/include/asm/vmx.h b/arch/x86/include/asm/vmx.h
index 498dc600bd5c..b9f88ecf20c3 100644
--- a/arch/x86/include/asm/vmx.h
+++ b/arch/x86/include/asm/vmx.h
@@ -81,6 +81,7 @@
  * Definitions of Tertiary Processor-Based VM-Execution Controls.
  */
 #define TERTIARY_EXEC_IPI_VIRT			VMCS_CONTROL_BIT(IPI_VIRT)
+#define TERTIARY_EXEC_SPEC_CTRL_VIRT		VMCS_CONTROL_BIT(SPEC_CTRL_VIRT)
 
 #define PIN_BASED_EXT_INTR_MASK                 VMCS_CONTROL_BIT(INTR_EXITING)
 #define PIN_BASED_NMI_EXITING                   VMCS_CONTROL_BIT(NMI_EXITING)
@@ -233,6 +234,10 @@ enum vmcs_field {
 	TERTIARY_VM_EXEC_CONTROL_HIGH	= 0x00002035,
 	PID_POINTER_TABLE		= 0x00002042,
 	PID_POINTER_TABLE_HIGH		= 0x00002043,
+	IA32_SPEC_CTRL_MASK             = 0x0000204A,
+	IA32_SPEC_CTRL_MASK_HIGH        = 0x0000204B,
+	IA32_SPEC_CTRL_SHADOW           = 0x0000204C,
+	IA32_SPEC_CTRL_SHADOW_HIGH      = 0x0000204D,
 	GUEST_PHYSICAL_ADDRESS          = 0x00002400,
 	GUEST_PHYSICAL_ADDRESS_HIGH     = 0x00002401,
 	VMCS_LINK_POINTER               = 0x00002800,
diff --git a/arch/x86/include/asm/vmxfeatures.h b/arch/x86/include/asm/vmxfeatures.h
index c6a7eed03914..c70d0769b7d0 100644
--- a/arch/x86/include/asm/vmxfeatures.h
+++ b/arch/x86/include/asm/vmxfeatures.h
@@ -89,4 +89,6 @@
 
 /* Tertiary Processor-Based VM-Execution Controls, word 3 */
 #define VMX_FEATURE_IPI_VIRT		( 3*32+  4) /* Enable IPI virtualization */
+#define VMX_FEATURE_SPEC_CTRL_VIRT	( 3*32+  7) /* Enable IA32_SPEC_CTRL virtualization */
+
 #endif /* _ASM_X86_VMXFEATURES_H */
diff --git a/arch/x86/kvm/vmx/capabilities.h b/arch/x86/kvm/vmx/capabilities.h
index 45162c1bcd8f..a7ab70b55acf 100644
--- a/arch/x86/kvm/vmx/capabilities.h
+++ b/arch/x86/kvm/vmx/capabilities.h
@@ -138,6 +138,11 @@ static inline bool cpu_has_tertiary_exec_ctrls(void)
 		CPU_BASED_ACTIVATE_TERTIARY_CONTROLS;
 }
 
+static __always_inline bool cpu_has_spec_ctrl_virt(void)
+{
+	return vmcs_config.cpu_based_3rd_exec_ctrl & TERTIARY_EXEC_SPEC_CTRL_VIRT;
+}
+
 static inline bool cpu_has_vmx_virtualize_apic_accesses(void)
 {
 	return vmcs_config.cpu_based_2nd_exec_ctrl &
diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
index f63b28f46a71..96861a42316d 100644
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -276,6 +276,8 @@ static void vmx_switch_vmcs(struct kvm_vcpu *vcpu, struct loaded_vmcs *vmcs)
 	vmx->loaded_vmcs = vmcs;
 	vmx_vcpu_load_vmcs(vcpu, cpu, prev);
 	vmx_sync_vmcs_host_state(vmx, prev);
+	vmx_set_spec_ctrl_mask(vmx, prev->spec_ctrl_mask);
+	vmx_set_guest_spec_ctrl(vmx, vmx_get_guest_spec_ctrl(vmx));
 	put_cpu();
 
 	vcpu->arch.regs_avail = ~VMX_REGS_LAZY_LOAD_SET;
@@ -2342,6 +2344,17 @@ static void prepare_vmcs02_early(struct vcpu_vmx *vmx, struct loaded_vmcs *vmcs0
 		secondary_exec_controls_set(vmx, exec_control);
 	}
 
+	/*
+	 * TERTIARY EXEC CONTROLS
+	 */
+	if (cpu_has_tertiary_exec_ctrls()) {
+		exec_control = __tertiary_exec_controls_get(vmcs01);
+
+		/* IPI virtualization for L2 isn't supported */
+		exec_control &= ~TERTIARY_EXEC_IPI_VIRT;
+		tertiary_exec_controls_set(vmx, exec_control);
+	}
+
 	/*
 	 * ENTRY CONTROLS
 	 *
diff --git a/arch/x86/kvm/vmx/vmcs.h b/arch/x86/kvm/vmx/vmcs.h
index 7c1996b433e2..5f1fc43c8be0 100644
--- a/arch/x86/kvm/vmx/vmcs.h
+++ b/arch/x86/kvm/vmx/vmcs.h
@@ -73,6 +73,8 @@ struct loaded_vmcs {
 	struct list_head loaded_vmcss_on_cpu_link;
 	struct vmcs_host_state host_state;
 	struct vmcs_controls_shadow controls_shadow;
+	/* write-through cache of the SPEC_CTRL_MASK field in VMCS */
+	u64 spec_ctrl_mask;
 };
 
 static __always_inline bool is_intr_type(u32 intr_info, u32 type)
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 56e0c7ae961d..9f6919bec2b3 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -1996,7 +1996,7 @@ static int vmx_get_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 		    !guest_has_spec_ctrl_msr(vcpu))
 			return 1;
 
-		msr_info->data = to_vmx(vcpu)->spec_ctrl;
+		msr_info->data = vmx->guest_spec_ctrl;
 		break;
 	case MSR_IA32_SYSENTER_CS:
 		msr_info->data = vmcs_read32(GUEST_SYSENTER_CS);
@@ -2145,7 +2145,7 @@ static int vmx_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 	struct vmx_uret_msr *msr;
 	int ret = 0;
 	u32 msr_index = msr_info->index;
-	u64 data = msr_info->data;
+	u64 data = msr_info->data, spec_ctrl_mask;
 	u32 index;
 
 	switch (msr_index) {
@@ -2256,13 +2256,22 @@ static int vmx_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 		    !guest_has_spec_ctrl_msr(vcpu))
 			return 1;
 
-		if (kvm_spec_ctrl_test_value(data))
+		spec_ctrl_mask = vmx_get_spec_ctrl_mask(vmx);
+		if (kvm_spec_ctrl_test_value(data | spec_ctrl_mask))
 			return 1;
 
-		vmx->spec_ctrl = data;
+		vmx_set_guest_spec_ctrl(vmx, data);
+
 		if (!data)
 			break;
 
+		/*
+		 * Don't disable intercept to prevent guest from changing some
+		 * bits if "virtualize IA32_SPEC_CTRL" isn't supported.
+		 */
+		if (spec_ctrl_mask && !cpu_has_spec_ctrl_virt())
+			break;
+
 		/*
 		 * For non-nested:
 		 * When it's written (to non-zero) for the first time, pass
@@ -4822,7 +4831,8 @@ static void vmx_vcpu_reset(struct kvm_vcpu *vcpu, bool init_event)
 		__vmx_vcpu_reset(vcpu);
 
 	vmx->rmode.vm86_active = 0;
-	vmx->spec_ctrl = 0;
+	vmx_set_spec_ctrl_mask(vmx, 0);
+	vmx_set_guest_spec_ctrl(vmx, 0);
 
 	vmx->msr_ia32_umwait_control = 0;
 
@@ -7117,8 +7127,20 @@ void noinstr vmx_spec_ctrl_restore_host(struct vcpu_vmx *vmx,
 	if (!cpu_feature_enabled(X86_FEATURE_MSR_SPEC_CTRL))
 		return;
 
-	if (flags & VMX_RUN_SAVE_SPEC_CTRL)
+	if (flags & VMX_RUN_SAVE_SPEC_CTRL) {
 		vmx->spec_ctrl = __rdmsr(MSR_IA32_SPEC_CTRL);
+		/*
+		 * For simplicity, always keep vmx->guest_spec_ctrl
+		 * up-to-date. The guest value is needed for userspace read
+		 * e.g. live migration, and nested transitions. At later
+		 * point, it is uneasy to tell which one is the latest
+		 * guest value since the intercept state may change.
+		 */
+		if (cpu_has_spec_ctrl_virt())
+			vmx->guest_spec_ctrl = vmcs_read64(IA32_SPEC_CTRL_SHADOW);
+		else
+			vmx->guest_spec_ctrl = vmx->spec_ctrl;
+	}
 
 	/*
 	 * If the guest/host SPEC_CTRL values differ, restore the host value.
diff --git a/arch/x86/kvm/vmx/vmx.h b/arch/x86/kvm/vmx/vmx.h
index cb766f65a3eb..021d86b52e18 100644
--- a/arch/x86/kvm/vmx/vmx.h
+++ b/arch/x86/kvm/vmx/vmx.h
@@ -291,6 +291,7 @@ struct vcpu_vmx {
 #endif
 
 	u64		      spec_ctrl;
+	u64		      guest_spec_ctrl;
 	u32		      msr_ia32_umwait_control;
 
 	/*
@@ -589,7 +590,8 @@ static inline u8 vmx_get_rvi(void)
 
 #define KVM_REQUIRED_VMX_TERTIARY_VM_EXEC_CONTROL 0
 #define KVM_OPTIONAL_VMX_TERTIARY_VM_EXEC_CONTROL			\
-	(TERTIARY_EXEC_IPI_VIRT)
+	(TERTIARY_EXEC_IPI_VIRT |					\
+	 TERTIARY_EXEC_SPEC_CTRL_VIRT)
 
 #define BUILD_CONTROLS_SHADOW(lname, uname, bits)						\
 static inline void lname##_controls_set(struct vcpu_vmx *vmx, u##bits val)			\
@@ -624,6 +626,20 @@ BUILD_CONTROLS_SHADOW(exec, CPU_BASED_VM_EXEC_CONTROL, 32)
 BUILD_CONTROLS_SHADOW(secondary_exec, SECONDARY_VM_EXEC_CONTROL, 32)
 BUILD_CONTROLS_SHADOW(tertiary_exec, TERTIARY_VM_EXEC_CONTROL, 64)
 
+static inline void vmx_set_spec_ctrl_mask(struct vcpu_vmx *vmx, u64 mask)
+{
+	if (vmx->loaded_vmcs->spec_ctrl_mask != mask) {
+		if (cpu_has_spec_ctrl_virt())
+			vmcs_write64(IA32_SPEC_CTRL_MASK, mask);
+		vmx->loaded_vmcs->spec_ctrl_mask = mask;
+	}
+}
+
+static inline u64 vmx_get_spec_ctrl_mask(struct vcpu_vmx *vmx)
+{
+	return vmx->loaded_vmcs->spec_ctrl_mask;
+}
+
 /*
  * VMX_REGS_LAZY_LOAD_SET - The set of registers that will be updated in the
  * cache on demand.  Other registers not listed here are synced to
@@ -750,4 +766,26 @@ static inline bool guest_cpuid_has_evmcs(struct kvm_vcpu *vcpu)
 	       to_vmx(vcpu)->nested.enlightened_vmcs_enabled;
 }
 
+static inline u64 vmx_get_guest_spec_ctrl(struct vcpu_vmx *vmx)
+{
+	return vmx->guest_spec_ctrl;
+}
+
+static inline void vmx_set_guest_spec_ctrl(struct vcpu_vmx *vmx, u64 val)
+{
+	vmx->guest_spec_ctrl = val;
+
+	/*
+	 * For simplicity, always keep IA32_SPEC_CTRL_SHADOW up-to-date,
+	 * regardless of the MSR intercept state.
+	 */
+	if (cpu_has_spec_ctrl_virt())
+		vmcs_write64(IA32_SPEC_CTRL_SHADOW, val);
+
+	/*
+	 * Update the effective value of IA32_SPEC_CTRL to reflect changes to
+	 * guest's IA32_SPEC_CTRL. Bits in the mask should always be set.
+	 */
+	vmx->spec_ctrl = val | vmx_get_spec_ctrl_mask(vmx);
+}
 #endif /* __KVM_X86_VMX_H */
-- 
2.40.0

