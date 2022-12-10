Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 88B75648FB7
	for <lists+kvm@lfdr.de>; Sat, 10 Dec 2022 17:19:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229963AbiLJQTP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 10 Dec 2022 11:19:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45660 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229900AbiLJQTG (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 10 Dec 2022 11:19:06 -0500
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DC9D819C37;
        Sat, 10 Dec 2022 08:19:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1670689141; x=1702225141;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=rGTFfxeYu4LvCk1ggEo/vPBN6U6DPzIZBZwFkOw9ZXY=;
  b=LH712DdFgBk2lIe3WAggHPgsf+Nu61aTyXzkfdIcmEy2cizfOr8Rd652
   m5xETSaGn9rcn4mDwNnVf5zqlsX6f24X+mUaD8/ea8bOm/QrWw98vT0GP
   VKDn6XRXdyTJ9MAMJdoLl//AAaWiD1naOgE7HYCFudxoUpeqXWtrVShOB
   +4WugC9NBNVupN7nzRlh6oZgvz/H5Zbc+dJYDP+hzvvVbohEZVlz9zJVi
   wJOY93hoA56SkT1v8ogeBBurpi+YyCG5pAuwgEgOsmfMECzXSACkEQiNp
   dRDZtJu8Hv34j1qbMEl812xMtC09unpVW6QqIAdOExZSF2lJOBLa1qvm7
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10557"; a="318780456"
X-IronPort-AV: E=Sophos;i="5.96,234,1665471600"; 
   d="scan'208";a="318780456"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Dec 2022 08:19:01 -0800
X-IronPort-AV: E=McAfee;i="6500,9779,10557"; a="711208652"
X-IronPort-AV: E=Sophos;i="5.96,234,1665471600"; 
   d="scan'208";a="711208652"
Received: from unknown (HELO localhost.localdomain) ([10.239.161.133])
  by fmsmga008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Dec 2022 08:18:58 -0800
From:   Zhang Chen <chen.zhang@intel.com>
To:     x86@kernel.org, linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     Zhang Chen <chen.zhang@intel.com>, Chao Gao <chao.gao@intel.com>,
        Pawan Gupta <pawan.kumar.gupta@linux.intel.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Borislav Petkov <bp@alien8.de>, Ingo Molnar <mingo@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: [RFC PATCH 4/9] x86/kvm/vmx: Virtualize Intel IA32_SPEC_CTRL
Date:   Sun, 11 Dec 2022 00:00:41 +0800
Message-Id: <20221210160046.2608762-5-chen.zhang@intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20221210160046.2608762-1-chen.zhang@intel.com>
References: <20221210160046.2608762-1-chen.zhang@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Currently KVM disables interception of IA32_SPEC_CTRL after a non-0 is
written to IA32_SPEC_CTRL by guest. Then, guest is allowed to write any
value to hardware.

"virtualize IA32_SPEC_CTRL" is a new tertiary vm-exec control.
It provides VMM the capability to restrict the value of IA32_SPEC_CTRL in
hardware even if the MSR isn't intercepted (e.g., prevent VMs from changing
some bits in IA32_SPEC_CTRL) in an efficient way.

Two new fields are added to VMCS,
IA32_SPEC_CTRL_MASK: Setting a bit in this field prevents guest software
from modifying the corresponding bit in the IA32_SPEC_CTRL MSR
IA32_SPEC_CTRL_SHADOW: This field contains the value that guest software
expects to be in the IA32_SPEC_CTRL MSR

In VMX non-root mode, when IA32_SPEC_CTRL isn't intercepted by VMM,
guest's accesses to IA32_SPEC_CTRL is virtualized by the processor
according to the two new fields:
RDMSR IA32_SPEC_CTRL returns the shadow value.
WRMSR IA32_SPEC_CTRL writes EDX:EAX to the shadow field and calculate
a new value according to the guest value (EDX:EAX), current value of
IA32_SPEC_CTRL MSR and the IA32_SPEC_CTRL_MASK field (specifically,
(cur_val & mask) | (guest_val & ~mask)) and write it to IA32_SPEC_CTRL MSR.

Enable "virtual IA32_SPEC_CTRL" if it is supported. With
"virtual IA32_SPEC_CTRL" enabled, IA32_SPEC_CTRL MSR value seen from
guest p.o.v is different from the value in hardware when guest is running.
We refer to the two values as below:

1. effective value of IA32_SPEC_CTRL. This value is the one programmed in
   hardware when the vCPU is running.
2. shadow value of IA32_SPEC_CTRL. This value is returned when rdmsr is
   used inside a guest to read IA32_SPEC_CTRL. This value doesn't affect
   CPU's enablement of indirect predictor controls.

In KVM, vmx->spec_ctrl always stores the effective value of IA32_SPEC_CTRL
when guest is running (even when "virtual IA32_SPEC_CTRL" is disabled.
In this case, the shadow value is equal to the effective one).
When "virtual IA32_SPEC_CTRL" is enabled, the shadow value of
IA32_SPEC_CTRL is stored in IA32_SPEC_CTRL_SHADOW field in VMCS.

IA32_SPEC_CTRL_MASK is always 0 for now. It means all supported bits
in hardware is allowed to be toggled by guest's wrmsr. The mask will
be changed by following patches.

Note "virtual IA32_SPEC_CTRL" is now used by VMM to enforce some bits
of IA32_SPEC_CTRL to 1 (i.e., enabled some HW mitigations transparently
for guests). In theory, VMM can disable some HW mitigations behind guests.
But to keep this series simple, we leave that for future work.

Co-developed-by: Chao Gao <chao.gao@intel.com>
Signed-off-by: Chao Gao <chao.gao@intel.com>
Signed-off-by: Zhang Chen <chen.zhang@intel.com>
---
 arch/x86/include/asm/vmx.h         |  5 +++++
 arch/x86/include/asm/vmxfeatures.h |  2 ++
 arch/x86/kvm/vmx/capabilities.h    |  5 +++++
 arch/x86/kvm/vmx/vmx.c             | 30 ++++++++++++++++++++++++++++--
 arch/x86/kvm/vmx/vmx.h             | 10 +++++++++-
 5 files changed, 49 insertions(+), 3 deletions(-)

diff --git a/arch/x86/include/asm/vmx.h b/arch/x86/include/asm/vmx.h
index 498dc600bd5c..c2efdad491c1 100644
--- a/arch/x86/include/asm/vmx.h
+++ b/arch/x86/include/asm/vmx.h
@@ -81,6 +81,7 @@
  * Definitions of Tertiary Processor-Based VM-Execution Controls.
  */
 #define TERTIARY_EXEC_IPI_VIRT			VMCS_CONTROL_BIT(IPI_VIRT)
+#define TERTIARY_EXEC_VIRT_SPEC_CTRL		VMCS_CONTROL_BIT(VIRT_SPEC_CTRL)
 
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
index c6a7eed03914..d3b7237d9c42 100644
--- a/arch/x86/include/asm/vmxfeatures.h
+++ b/arch/x86/include/asm/vmxfeatures.h
@@ -89,4 +89,6 @@
 
 /* Tertiary Processor-Based VM-Execution Controls, word 3 */
 #define VMX_FEATURE_IPI_VIRT		( 3*32+  4) /* Enable IPI virtualization */
+#define VMX_FEATURE_VIRT_SPEC_CTRL	( 3*32+  7) /* Virtualize IA32_SPEC_CTRL */
+
 #endif /* _ASM_X86_VMXFEATURES_H */
diff --git a/arch/x86/kvm/vmx/capabilities.h b/arch/x86/kvm/vmx/capabilities.h
index 07254314f3dd..a9a0adcd403b 100644
--- a/arch/x86/kvm/vmx/capabilities.h
+++ b/arch/x86/kvm/vmx/capabilities.h
@@ -138,6 +138,11 @@ static inline bool cpu_has_tertiary_exec_ctrls(void)
 		CPU_BASED_ACTIVATE_TERTIARY_CONTROLS;
 }
 
+static inline bool cpu_has_virt_spec_ctrl(void)
+{
+	return vmcs_config.cpu_based_3rd_exec_ctrl & TERTIARY_EXEC_VIRT_SPEC_CTRL;
+}
+
 static inline bool cpu_has_vmx_virtualize_apic_accesses(void)
 {
 	return vmcs_config.cpu_based_2nd_exec_ctrl &
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 63247c57c72c..407061b369b4 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -1898,7 +1898,10 @@ static int vmx_get_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 		    !guest_has_spec_ctrl_msr(vcpu))
 			return 1;
 
-		msr_info->data = to_vmx(vcpu)->spec_ctrl;
+		if (cpu_has_virt_spec_ctrl())
+			msr_info->data = vmcs_read64(IA32_SPEC_CTRL_SHADOW);
+		else
+			msr_info->data = to_vmx(vcpu)->spec_ctrl;
 		break;
 	case MSR_IA32_SYSENTER_CS:
 		msr_info->data = vmcs_read32(GUEST_SYSENTER_CS);
@@ -2160,10 +2163,22 @@ static int vmx_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 		    !guest_has_spec_ctrl_msr(vcpu))
 			return 1;
 
-		if (kvm_spec_ctrl_test_value(data))
+		if (kvm_spec_ctrl_test_value(data | vmx->spec_ctrl_mask))
 			return 1;
 
 		vmx->spec_ctrl = data;
+
+		if (cpu_has_virt_spec_ctrl()) {
+			vmcs_write64(IA32_SPEC_CTRL_SHADOW, data);
+			/*
+			 * Some bits are allowed to be toggled by guest.
+			 * Update the effective value of IA32_SPEC_CTRL
+			 * MSR according to the value written by guest
+			 * but keep bits in the mask set.
+			 */
+			vmx->spec_ctrl = data | vmx->spec_ctrl_mask;
+		}
+
 		if (!data)
 			break;
 
@@ -4673,6 +4688,11 @@ static void init_vmcs(struct vcpu_vmx *vmx)
 	if (cpu_has_vmx_xsaves())
 		vmcs_write64(XSS_EXIT_BITMAP, VMX_XSS_EXIT_BITMAP);
 
+	if (cpu_has_virt_spec_ctrl()) {
+		vmcs_write64(IA32_SPEC_CTRL_SHADOW, 0);
+		vmcs_write64(IA32_SPEC_CTRL_MASK, vmx->spec_ctrl_mask);
+	}
+
 	if (enable_pml) {
 		vmcs_write64(PML_ADDRESS, page_to_phys(vmx->pml_pg));
 		vmcs_write16(GUEST_PML_INDEX, PML_ENTITY_NUM - 1);
@@ -4738,6 +4758,12 @@ static void vmx_vcpu_reset(struct kvm_vcpu *vcpu, bool init_event)
 		__vmx_vcpu_reset(vcpu);
 
 	vmx->rmode.vm86_active = 0;
+
+	if (cpu_has_virt_spec_ctrl()) {
+		vmx->spec_ctrl_mask = 0;
+		vmcs_write64(IA32_SPEC_CTRL_MASK, vmx->spec_ctrl_mask);
+		vmcs_write64(IA32_SPEC_CTRL_SHADOW, 0);
+	}
 	vmx->spec_ctrl = 0;
 
 	vmx->msr_ia32_umwait_control = 0;
diff --git a/arch/x86/kvm/vmx/vmx.h b/arch/x86/kvm/vmx/vmx.h
index a3da84f4ea45..c5a41ae14237 100644
--- a/arch/x86/kvm/vmx/vmx.h
+++ b/arch/x86/kvm/vmx/vmx.h
@@ -290,7 +290,14 @@ struct vcpu_vmx {
 	u64		      msr_guest_kernel_gs_base;
 #endif
 
+	/* The value of hardware IA32_SPEC_CTRL MSR when guest is running */
 	u64		      spec_ctrl;
+	/*
+	 * The bits KVM doesn't allow guest to toggle.
+	 * A bit set in the mask should always be set in guest
+	 * IA32_SPEC_CTRL_MSR.
+	 */
+	u64		      spec_ctrl_mask;
 	u32		      msr_ia32_umwait_control;
 
 	/*
@@ -589,7 +596,8 @@ static inline u8 vmx_get_rvi(void)
 
 #define KVM_REQUIRED_VMX_TERTIARY_VM_EXEC_CONTROL 0
 #define KVM_OPTIONAL_VMX_TERTIARY_VM_EXEC_CONTROL			\
-	(TERTIARY_EXEC_IPI_VIRT)
+	(TERTIARY_EXEC_IPI_VIRT |					\
+	TERTIARY_EXEC_VIRT_SPEC_CTRL)
 
 #define BUILD_CONTROLS_SHADOW(lname, uname, bits)						\
 static inline void lname##_controls_set(struct vcpu_vmx *vmx, u##bits val)			\
-- 
2.25.1

