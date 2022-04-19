Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 291575072CD
	for <lists+kvm@lfdr.de>; Tue, 19 Apr 2022 18:17:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354566AbiDSQTo (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 19 Apr 2022 12:19:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56838 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354555AbiDSQTl (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 19 Apr 2022 12:19:41 -0400
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 24C143B00F;
        Tue, 19 Apr 2022 09:16:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1650385014; x=1681921014;
  h=from:to:cc:subject:date:message-id;
  bh=tIqyV0asJPd6sykhy31pYC+wQ+o5y8aQ6OkkxUo7yI0=;
  b=AzOID+Rl4f5b3c/5WrLcKWWSES0jRgfX4dzISIX4cJPIyMlPDpsTECap
   ZsgQH0RS0cFK7J0mC1/Z/K8WFyhgjydJEhyUCsUp0YAJtI64faPInUgtu
   Tz0hRe3aMW3xsG5qNLAQZBtb2pOKt+14YeRp1LxxxGQWpg/VndHdgk9xI
   Va+pKiPGXuHIg6PWqbyhyhLJUUjDhP0Jd7jz1lAuo3CexoD1avvMukyMx
   JoYa9niKg/zNAzUTCYNUX3uM13cXSLMY2yzW5Ats2kLnzFQ84KwpSNV6t
   7bs+us8u39z5xJSknp8/J1TqrLFYmtMalOegJHULYQaLzaaQXqq0zXXRq
   A==;
X-IronPort-AV: E=McAfee;i="6400,9594,10322"; a="245697523"
X-IronPort-AV: E=Sophos;i="5.90,273,1643702400"; 
   d="scan'208";a="245697523"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Apr 2022 09:16:53 -0700
X-IronPort-AV: E=Sophos;i="5.90,273,1643702400"; 
   d="scan'208";a="529375203"
Received: from arthur-vostro-3668.sh.intel.com ([10.239.13.120])
  by orsmga006-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Apr 2022 09:16:48 -0700
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
        Zeng Guang <guang.zeng@intel.com>
Subject: [PATCH v9 9/9] KVM: VMX: enable IPI virtualization
Date:   Tue, 19 Apr 2022 23:45:10 +0800
Message-Id: <20220419154510.11938-1-guang.zeng@intel.com>
X-Mailer: git-send-email 2.17.1
X-Spam-Status: No, score=-2.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Chao Gao <chao.gao@intel.com>

With IPI virtualization enabled, the processor emulates writes to
APIC registers that would send IPIs. The processor sets the bit
corresponding to the vector in target vCPU's PIR and may send a
notification (IPI) specified by NDST and NV fields in target vCPU's
Posted-Interrupt Descriptor (PID). It is similar to what IOMMU
engine does when dealing with posted interrupt from devices.

A PID-pointer table is used by the processor to locate the PID of a
vCPU with the vCPU's APIC ID. The table size depends on maximum APIC
ID assigned for current VM session from userspace. Allocating memory
for PID-pointer table is deferred to vCPU creation, because irqchip
mode and VM-scope maximum APIC ID is settled at that point. KVM can
skip PID-pointer table allocation if !irqchip_in_kernel().

Like VT-d PI, if a vCPU goes to blocked state, VMM needs to switch its
notification vector to wakeup vector. This can ensure that when an IPI
for blocked vCPUs arrives, VMM can get control and wake up blocked
vCPUs. And if a VCPU is preempted, its posted interrupt notification
is suppressed.

Note that IPI virtualization can only virualize physical-addressing,
flat mode, unicast IPIs. Sending other IPIs would still cause a
trap-like APIC-write VM-exit and need to be handled by VMM.

Signed-off-by: Chao Gao <chao.gao@intel.com>
Signed-off-by: Zeng Guang <guang.zeng@intel.com>
---
 arch/x86/include/asm/kvm-x86-ops.h |  1 +
 arch/x86/include/asm/kvm_host.h    |  1 +
 arch/x86/include/asm/vmx.h         |  8 +++
 arch/x86/include/asm/vmxfeatures.h |  2 +
 arch/x86/kvm/vmx/capabilities.h    |  6 +++
 arch/x86/kvm/vmx/posted_intr.c     | 15 +++++-
 arch/x86/kvm/vmx/posted_intr.h     |  2 +
 arch/x86/kvm/vmx/vmx.c             | 82 ++++++++++++++++++++++++++++--
 arch/x86/kvm/vmx/vmx.h             |  7 +++
 arch/x86/kvm/x86.c                 |  2 +-
 10 files changed, 119 insertions(+), 7 deletions(-)

diff --git a/arch/x86/include/asm/kvm-x86-ops.h b/arch/x86/include/asm/kvm-x86-ops.h
index 3c368b639c04..fa27a61d9f8e 100644
--- a/arch/x86/include/asm/kvm-x86-ops.h
+++ b/arch/x86/include/asm/kvm-x86-ops.h
@@ -21,6 +21,7 @@ KVM_X86_OP(has_emulated_msr)
 KVM_X86_OP(vcpu_after_set_cpuid)
 KVM_X86_OP(vm_init)
 KVM_X86_OP_OPTIONAL(vm_destroy)
+KVM_X86_OP_OPTIONAL_RET0(vcpu_precreate)
 KVM_X86_OP(vcpu_create)
 KVM_X86_OP(vcpu_free)
 KVM_X86_OP(vcpu_reset)
diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index cdd14033988d..d123c2e43976 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1337,6 +1337,7 @@ struct kvm_x86_ops {
 	void (*vm_destroy)(struct kvm *kvm);
 
 	/* Create, but do not attach this VCPU */
+	int (*vcpu_precreate)(struct kvm *kvm);
 	int (*vcpu_create)(struct kvm_vcpu *vcpu);
 	void (*vcpu_free)(struct kvm_vcpu *vcpu);
 	void (*vcpu_reset)(struct kvm_vcpu *vcpu, bool init_event);
diff --git a/arch/x86/include/asm/vmx.h b/arch/x86/include/asm/vmx.h
index 8c929596a299..b79b6438acaa 100644
--- a/arch/x86/include/asm/vmx.h
+++ b/arch/x86/include/asm/vmx.h
@@ -76,6 +76,11 @@
 #define SECONDARY_EXEC_ENABLE_USR_WAIT_PAUSE	VMCS_CONTROL_BIT(USR_WAIT_PAUSE)
 #define SECONDARY_EXEC_BUS_LOCK_DETECTION	VMCS_CONTROL_BIT(BUS_LOCK_DETECTION)
 
+/*
+ * Definitions of Tertiary Processor-Based VM-Execution Controls.
+ */
+#define TERTIARY_EXEC_IPI_VIRT			VMCS_CONTROL_BIT(IPI_VIRT)
+
 #define PIN_BASED_EXT_INTR_MASK                 VMCS_CONTROL_BIT(INTR_EXITING)
 #define PIN_BASED_NMI_EXITING                   VMCS_CONTROL_BIT(NMI_EXITING)
 #define PIN_BASED_VIRTUAL_NMIS                  VMCS_CONTROL_BIT(VIRTUAL_NMIS)
@@ -159,6 +164,7 @@ static inline int vmx_misc_mseg_revid(u64 vmx_misc)
 enum vmcs_field {
 	VIRTUAL_PROCESSOR_ID            = 0x00000000,
 	POSTED_INTR_NV                  = 0x00000002,
+	LAST_PID_POINTER_INDEX		= 0x00000008,
 	GUEST_ES_SELECTOR               = 0x00000800,
 	GUEST_CS_SELECTOR               = 0x00000802,
 	GUEST_SS_SELECTOR               = 0x00000804,
@@ -224,6 +230,8 @@ enum vmcs_field {
 	TSC_MULTIPLIER_HIGH             = 0x00002033,
 	TERTIARY_VM_EXEC_CONTROL	= 0x00002034,
 	TERTIARY_VM_EXEC_CONTROL_HIGH	= 0x00002035,
+	PID_POINTER_TABLE		= 0x00002042,
+	PID_POINTER_TABLE_HIGH		= 0x00002043,
 	GUEST_PHYSICAL_ADDRESS          = 0x00002400,
 	GUEST_PHYSICAL_ADDRESS_HIGH     = 0x00002401,
 	VMCS_LINK_POINTER               = 0x00002800,
diff --git a/arch/x86/include/asm/vmxfeatures.h b/arch/x86/include/asm/vmxfeatures.h
index ff20776dc83b..589608c157bf 100644
--- a/arch/x86/include/asm/vmxfeatures.h
+++ b/arch/x86/include/asm/vmxfeatures.h
@@ -86,4 +86,6 @@
 #define VMX_FEATURE_ENCLV_EXITING	( 2*32+ 28) /* "" VM-Exit on ENCLV (leaf dependent) */
 #define VMX_FEATURE_BUS_LOCK_DETECTION	( 2*32+ 30) /* "" VM-Exit when bus lock caused */
 
+/* Tertiary Processor-Based VM-Execution Controls, word 3 */
+#define VMX_FEATURE_IPI_VIRT		( 3*32+  4) /* Enable IPI virtualization */
 #endif /* _ASM_X86_VMXFEATURES_H */
diff --git a/arch/x86/kvm/vmx/capabilities.h b/arch/x86/kvm/vmx/capabilities.h
index 31f3d88b3e4d..5f656c9e33be 100644
--- a/arch/x86/kvm/vmx/capabilities.h
+++ b/arch/x86/kvm/vmx/capabilities.h
@@ -13,6 +13,7 @@ extern bool __read_mostly enable_ept;
 extern bool __read_mostly enable_unrestricted_guest;
 extern bool __read_mostly enable_ept_ad_bits;
 extern bool __read_mostly enable_pml;
+extern bool __read_mostly enable_ipiv;
 extern int __read_mostly pt_mode;
 
 #define PT_MODE_SYSTEM		0
@@ -283,6 +284,11 @@ static inline bool cpu_has_vmx_apicv(void)
 		cpu_has_vmx_posted_intr();
 }
 
+static inline bool cpu_has_vmx_ipiv(void)
+{
+	return vmcs_config.cpu_based_3rd_exec_ctrl & TERTIARY_EXEC_IPI_VIRT;
+}
+
 static inline bool cpu_has_vmx_flexpriority(void)
 {
 	return cpu_has_vmx_tpr_shadow() &&
diff --git a/arch/x86/kvm/vmx/posted_intr.c b/arch/x86/kvm/vmx/posted_intr.c
index 3834bb30ce54..1b12f9cfa280 100644
--- a/arch/x86/kvm/vmx/posted_intr.c
+++ b/arch/x86/kvm/vmx/posted_intr.c
@@ -177,11 +177,24 @@ static void pi_enable_wakeup_handler(struct kvm_vcpu *vcpu)
 	local_irq_restore(flags);
 }
 
+static bool vmx_can_use_pi_wakeup(struct kvm_vcpu *vcpu)
+{
+	/*
+	 * If a blocked vCPU can be the target of posted interrupts,
+	 * switching notification vector is needed so that kernel can
+	 * be informed when an interrupt is posted and get the chance
+	 * to wake up the blocked vCPU. For now, using posted interrupt
+	 * for vCPU wakeup when IPI virtualization or VT-d PI can be
+	 * enabled.
+	 */
+	return vmx_can_use_ipiv(vcpu) || vmx_can_use_vtd_pi(vcpu->kvm);
+}
+
 void vmx_vcpu_pi_put(struct kvm_vcpu *vcpu)
 {
 	struct pi_desc *pi_desc = vcpu_to_pi_desc(vcpu);
 
-	if (!vmx_can_use_vtd_pi(vcpu->kvm))
+	if (!vmx_can_use_pi_wakeup(vcpu))
 		return;
 
 	if (kvm_vcpu_is_blocking(vcpu) && !vmx_interrupt_blocked(vcpu))
diff --git a/arch/x86/kvm/vmx/posted_intr.h b/arch/x86/kvm/vmx/posted_intr.h
index 9a45d5c9f116..26992076552e 100644
--- a/arch/x86/kvm/vmx/posted_intr.h
+++ b/arch/x86/kvm/vmx/posted_intr.h
@@ -5,6 +5,8 @@
 #define POSTED_INTR_ON  0
 #define POSTED_INTR_SN  1
 
+#define PID_TABLE_ENTRY_VALID 1
+
 /* Posted-Interrupt Descriptor */
 struct pi_desc {
 	u32 pir[8];     /* Posted interrupt requested */
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index c6ad82116804..cd248be2d64f 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -105,6 +105,9 @@ module_param(fasteoi, bool, S_IRUGO);
 
 module_param(enable_apicv, bool, S_IRUGO);
 
+bool __read_mostly enable_ipiv = true;
+module_param(enable_ipiv, bool, 0444);
+
 /*
  * If nested=1, nested virtualization is supported, i.e., guests may use
  * VMX and be a hypervisor for its own guests. If nested=0, guests may not
@@ -2525,7 +2528,7 @@ static __init int setup_vmcs_config(struct vmcs_config *vmcs_conf,
 	}
 
 	if (_cpu_based_exec_control & CPU_BASED_ACTIVATE_TERTIARY_CONTROLS) {
-		u64 opt3 = 0;
+		u64 opt3 = TERTIARY_EXEC_IPI_VIRT;
 
 		_cpu_based_3rd_exec_control = adjust_vmx_controls64(opt3,
 					      MSR_IA32_VMX_PROCBASED_CTLS3);
@@ -3872,6 +3875,8 @@ static void vmx_update_msr_bitmap_x2apic(struct kvm_vcpu *vcpu)
 		vmx_enable_intercept_for_msr(vcpu, X2APIC_MSR(APIC_TMCCT), MSR_TYPE_RW);
 		vmx_disable_intercept_for_msr(vcpu, X2APIC_MSR(APIC_EOI), MSR_TYPE_W);
 		vmx_disable_intercept_for_msr(vcpu, X2APIC_MSR(APIC_SELF_IPI), MSR_TYPE_W);
+		if (enable_ipiv)
+			vmx_disable_intercept_for_msr(vcpu, X2APIC_MSR(APIC_ICR), MSR_TYPE_RW);
 	}
 }
 
@@ -4195,14 +4200,19 @@ static void vmx_refresh_apicv_exec_ctrl(struct kvm_vcpu *vcpu)
 
 	pin_controls_set(vmx, vmx_pin_based_exec_ctrl(vmx));
 
-	if (kvm_vcpu_apicv_active(vcpu))
+	if (kvm_vcpu_apicv_active(vcpu)) {
 		secondary_exec_controls_setbit(vmx,
 					       SECONDARY_EXEC_APIC_REGISTER_VIRT |
 					       SECONDARY_EXEC_VIRTUAL_INTR_DELIVERY);
-	else
+		if (enable_ipiv)
+			tertiary_exec_controls_setbit(vmx, TERTIARY_EXEC_IPI_VIRT);
+	} else {
 		secondary_exec_controls_clearbit(vmx,
 						 SECONDARY_EXEC_APIC_REGISTER_VIRT |
 						 SECONDARY_EXEC_VIRTUAL_INTR_DELIVERY);
+		if (enable_ipiv)
+			tertiary_exec_controls_clearbit(vmx, TERTIARY_EXEC_IPI_VIRT);
+	}
 
 	vmx_update_msr_bitmap_x2apic(vcpu);
 }
@@ -4235,7 +4245,16 @@ static u32 vmx_exec_control(struct vcpu_vmx *vmx)
 
 static u64 vmx_tertiary_exec_control(struct vcpu_vmx *vmx)
 {
-	return vmcs_config.cpu_based_3rd_exec_ctrl;
+	u64 exec_control = vmcs_config.cpu_based_3rd_exec_ctrl;
+
+	/*
+	 * IPI virtualization relies on APICv. Disable IPI virtualization if
+	 * APICv is inhibited.
+	 */
+	if (!enable_ipiv || !kvm_vcpu_apicv_active(&vmx->vcpu))
+		exec_control &= ~TERTIARY_EXEC_IPI_VIRT;
+
+	return exec_control;
 }
 
 /*
@@ -4383,10 +4402,42 @@ static u32 vmx_secondary_exec_control(struct vcpu_vmx *vmx)
 	return exec_control;
 }
 
+int vmx_get_pid_table_order(struct kvm *kvm)
+{
+	return get_order(kvm->arch.max_vcpu_ids * sizeof(*to_kvm_vmx(kvm)->pid_table));
+}
+
+static int vmx_alloc_ipiv_pid_table(struct kvm *kvm)
+{
+	struct page *pages;
+	struct kvm_vmx *kvm_vmx = to_kvm_vmx(kvm);
+
+	if (!irqchip_in_kernel(kvm) || !enable_ipiv)
+		return 0;
+
+	if (kvm_vmx->pid_table)
+		return 0;
+
+	pages = alloc_pages(GFP_KERNEL | __GFP_ZERO, vmx_get_pid_table_order(kvm));
+	if (!pages)
+		return -ENOMEM;
+
+	kvm_vmx->pid_table = (void *)page_address(pages);
+	return 0;
+}
+
+static int vmx_vcpu_precreate(struct kvm *kvm)
+{
+	return vmx_alloc_ipiv_pid_table(kvm);
+}
+
 #define VMX_XSS_EXIT_BITMAP 0
 
 static void init_vmcs(struct vcpu_vmx *vmx)
 {
+	struct kvm *kvm = vmx->vcpu.kvm;
+	struct kvm_vmx *kvm_vmx = to_kvm_vmx(kvm);
+
 	if (nested)
 		nested_vmx_set_vmcs_shadowing_bitmap();
 
@@ -4418,7 +4469,12 @@ static void init_vmcs(struct vcpu_vmx *vmx)
 		vmcs_write64(POSTED_INTR_DESC_ADDR, __pa((&vmx->pi_desc)));
 	}
 
-	if (!kvm_pause_in_guest(vmx->vcpu.kvm)) {
+	if (vmx_can_use_ipiv(&vmx->vcpu)) {
+		vmcs_write64(PID_POINTER_TABLE, __pa(kvm_vmx->pid_table));
+		vmcs_write16(LAST_PID_POINTER_INDEX, kvm->arch.max_vcpu_ids - 1);
+	}
+
+	if (!kvm_pause_in_guest(kvm)) {
 		vmcs_write32(PLE_GAP, ple_gap);
 		vmx->ple_window = ple_window;
 		vmx->ple_window_dirty = true;
@@ -7111,6 +7167,10 @@ static int vmx_vcpu_create(struct kvm_vcpu *vcpu)
 			goto free_vmcs;
 	}
 
+	if (vmx_can_use_ipiv(vcpu))
+		WRITE_ONCE(to_kvm_vmx(vcpu->kvm)->pid_table[vcpu->vcpu_id],
+			   __pa(&vmx->pi_desc) | PID_TABLE_ENTRY_VALID);
+
 	return 0;
 
 free_vmcs:
@@ -7745,6 +7805,13 @@ static bool vmx_check_apicv_inhibit_reasons(enum kvm_apicv_inhibit reason)
 	return supported & BIT(reason);
 }
 
+static void vmx_vm_destroy(struct kvm *kvm)
+{
+	struct kvm_vmx *kvm_vmx = to_kvm_vmx(kvm);
+
+	free_pages((unsigned long)kvm_vmx->pid_table, vmx_get_pid_table_order(kvm));
+}
+
 static struct kvm_x86_ops vmx_x86_ops __initdata = {
 	.name = "kvm_intel",
 
@@ -7756,7 +7823,9 @@ static struct kvm_x86_ops vmx_x86_ops __initdata = {
 
 	.vm_size = sizeof(struct kvm_vmx),
 	.vm_init = vmx_vm_init,
+	.vm_destroy = vmx_vm_destroy,
 
+	.vcpu_precreate = vmx_vcpu_precreate,
 	.vcpu_create = vmx_vcpu_create,
 	.vcpu_free = vmx_vcpu_free,
 	.vcpu_reset = vmx_vcpu_reset,
@@ -8010,6 +8079,9 @@ static __init int hardware_setup(void)
 	if (!enable_apicv)
 		vmx_x86_ops.sync_pir_to_irr = NULL;
 
+	if (!enable_apicv || !cpu_has_vmx_ipiv())
+		enable_ipiv = false;
+
 	if (cpu_has_vmx_tsc_scaling())
 		kvm_has_tsc_control = true;
 
diff --git a/arch/x86/kvm/vmx/vmx.h b/arch/x86/kvm/vmx/vmx.h
index 85c067f2d7f2..4ab66b683624 100644
--- a/arch/x86/kvm/vmx/vmx.h
+++ b/arch/x86/kvm/vmx/vmx.h
@@ -365,6 +365,8 @@ struct kvm_vmx {
 	unsigned int tss_addr;
 	bool ept_identity_pagetable_done;
 	gpa_t ept_identity_map_addr;
+	/* Posted Interrupt Descriptor (PID) table for IPI virtualization */
+	u64 *pid_table;
 };
 
 bool nested_vmx_allowed(struct kvm_vcpu *vcpu);
@@ -580,4 +582,9 @@ static inline int vmx_get_instr_info_reg2(u32 vmx_instr_info)
 	return (vmx_instr_info >> 28) & 0xf;
 }
 
+static inline bool vmx_can_use_ipiv(struct kvm_vcpu *vcpu)
+{
+	return  lapic_in_kernel(vcpu) && enable_ipiv;
+}
+
 #endif /* __KVM_X86_VMX_H */
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 744e88a71b63..46457038c297 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -11195,7 +11195,7 @@ int kvm_arch_vcpu_precreate(struct kvm *kvm, unsigned int id)
 	if (id >= kvm->arch.max_vcpu_ids)
 		return -EINVAL;
 
-	return 0;
+	return static_call(kvm_x86_vcpu_precreate)(kvm);
 }
 
 int kvm_arch_vcpu_create(struct kvm_vcpu *vcpu)
-- 
2.27.0

