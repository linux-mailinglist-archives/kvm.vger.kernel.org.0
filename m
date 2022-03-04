Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E0F574CD044
	for <lists+kvm@lfdr.de>; Fri,  4 Mar 2022 09:41:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234766AbiCDIl0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 4 Mar 2022 03:41:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48404 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235110AbiCDIkt (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 4 Mar 2022 03:40:49 -0500
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6101319E09E;
        Fri,  4 Mar 2022 00:39:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1646383154; x=1677919154;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references;
  bh=tL1g08rAdmdu8wmXIwaG5eBe66L4V7C1JZYQt5Qs8nA=;
  b=YdPONvKLnA9WtHf3e3N519F1t7yc6VXxTfRDhdCLrIXbZzeLgnD2b0xH
   rlR+/ki/C+vt7TRdSRb/GXauYb8SiRhrnVmWJuIWnLuG7cUeYaOPqcU2G
   BmEdKzfd2NH/yFnsvAHotkb/uFh75POZuCTVyryYOh8jE4mpYjmzmlvYQ
   9cnSGqkXgTEO9cR+8WPNQT0Nig8Cd10DzTx9vugs25/aB6qeUMB/ewrFA
   gMSJPYuu1Qo79P8yLY+kev3K38RY5bEnjos+PY9VmKQm4h0SSHw6nhjmY
   29hTSMrKB0sdY9gkrM1fY8tX/a4irE2HiAZoP3FUTzY9dJsMB8aXeQBMb
   A==;
X-IronPort-AV: E=McAfee;i="6200,9189,10275"; a="254122245"
X-IronPort-AV: E=Sophos;i="5.90,154,1643702400"; 
   d="scan'208";a="254122245"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Mar 2022 00:38:50 -0800
X-IronPort-AV: E=Sophos;i="5.90,154,1643702400"; 
   d="scan'208";a="552141531"
Received: from arthur-vostro-3668.sh.intel.com ([10.239.13.120])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Mar 2022 00:38:45 -0800
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
Subject: [PATCH v7 8/8] KVM: VMX: enable IPI virtualization
Date:   Fri,  4 Mar 2022 16:07:25 +0800
Message-Id: <20220304080725.18135-9-guang.zeng@intel.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20220304080725.18135-1-guang.zeng@intel.com>
References: <20220304080725.18135-1-guang.zeng@intel.com>
X-Spam-Status: No, score=-7.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
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
 arch/x86/include/asm/vmx.h         |  8 +++
 arch/x86/include/asm/vmxfeatures.h |  2 +
 arch/x86/kvm/vmx/capabilities.h    |  6 ++
 arch/x86/kvm/vmx/posted_intr.c     | 15 ++++-
 arch/x86/kvm/vmx/vmx.c             | 90 ++++++++++++++++++++++++++++--
 arch/x86/kvm/vmx/vmx.h             |  5 ++
 6 files changed, 121 insertions(+), 5 deletions(-)

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
index ff20776dc83b..7ce616af2db2 100644
--- a/arch/x86/include/asm/vmxfeatures.h
+++ b/arch/x86/include/asm/vmxfeatures.h
@@ -86,4 +86,6 @@
 #define VMX_FEATURE_ENCLV_EXITING	( 2*32+ 28) /* "" VM-Exit on ENCLV (leaf dependent) */
 #define VMX_FEATURE_BUS_LOCK_DETECTION	( 2*32+ 30) /* "" VM-Exit when bus lock caused */
 
+/* Tertiary Processor-Based VM-Execution Controls, word 3 */
+#define VMX_FEATURE_IPI_VIRT		(3*32 +  4) /* "" Enable IPI virtualization */
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
index aa1fe9085d77..0882115a9b7a 100644
--- a/arch/x86/kvm/vmx/posted_intr.c
+++ b/arch/x86/kvm/vmx/posted_intr.c
@@ -177,11 +177,24 @@ static void pi_enable_wakeup_handler(struct kvm_vcpu *vcpu)
 	local_irq_restore(flags);
 }
 
+static bool vmx_can_use_pi_wakeup(struct kvm *kvm)
+{
+	/*
+	 * If a blocked vCPU can be the target of posted interrupts,
+	 * switching notification vector is needed so that kernel can
+	 * be informed when an interrupt is posted and get the chance
+	 * to wake up the blocked vCPU. For now, using posted interrupt
+	 * for vCPU wakeup when IPI virtualization or VT-d PI can be
+	 * enabled.
+	 */
+	return vmx_can_use_ipiv(kvm) || vmx_can_use_vtd_pi(kvm);
+}
+
 void vmx_vcpu_pi_put(struct kvm_vcpu *vcpu)
 {
 	struct pi_desc *pi_desc = vcpu_to_pi_desc(vcpu);
 
-	if (!vmx_can_use_vtd_pi(vcpu->kvm))
+	if (!vmx_can_use_pi_wakeup(vcpu->kvm))
 		return;
 
 	if (kvm_vcpu_is_blocking(vcpu) && !vmx_interrupt_blocked(vcpu))
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 7beba7a9f247..121d4f0b35b9 100644
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
@@ -227,6 +230,8 @@ static const struct {
 };
 
 #define L1D_CACHE_ORDER 4
+#define PID_TABLE_ENTRY_VALID 1
+
 static void *vmx_l1d_flush_pages;
 
 static int vmx_setup_l1d_flush(enum vmx_l1d_flush_state l1tf)
@@ -2543,7 +2548,7 @@ static __init int setup_vmcs_config(struct vmcs_config *vmcs_conf,
 	}
 
 	if (_cpu_based_exec_control & CPU_BASED_ACTIVATE_TERTIARY_CONTROLS) {
-		u64 opt3 = 0;
+		u64 opt3 = TERTIARY_EXEC_IPI_VIRT;
 		u64 min3 = 0;
 
 		if (adjust_vmx_controls_64(min3, opt3,
@@ -3898,6 +3903,8 @@ static void vmx_update_msr_bitmap_x2apic(struct kvm_vcpu *vcpu)
 		vmx_enable_intercept_for_msr(vcpu, X2APIC_MSR(APIC_TMCCT), MSR_TYPE_RW);
 		vmx_disable_intercept_for_msr(vcpu, X2APIC_MSR(APIC_EOI), MSR_TYPE_W);
 		vmx_disable_intercept_for_msr(vcpu, X2APIC_MSR(APIC_SELF_IPI), MSR_TYPE_W);
+		if (enable_ipiv)
+			vmx_disable_intercept_for_msr(vcpu, X2APIC_MSR(APIC_ICR),MSR_TYPE_RW);
 	}
 }
 
@@ -4219,14 +4226,21 @@ static void vmx_refresh_apicv_exec_ctrl(struct kvm_vcpu *vcpu)
 
 	pin_controls_set(vmx, vmx_pin_based_exec_ctrl(vmx));
 	if (cpu_has_secondary_exec_ctrls()) {
-		if (kvm_vcpu_apicv_active(vcpu))
+		if (kvm_vcpu_apicv_active(vcpu)) {
 			secondary_exec_controls_setbit(vmx,
 				      SECONDARY_EXEC_APIC_REGISTER_VIRT |
 				      SECONDARY_EXEC_VIRTUAL_INTR_DELIVERY);
-		else
+			if (enable_ipiv)
+				tertiary_exec_controls_setbit(vmx,
+						TERTIARY_EXEC_IPI_VIRT);
+		} else {
 			secondary_exec_controls_clearbit(vmx,
 					SECONDARY_EXEC_APIC_REGISTER_VIRT |
 					SECONDARY_EXEC_VIRTUAL_INTR_DELIVERY);
+			if (enable_ipiv)
+				tertiary_exec_controls_clearbit(vmx,
+						TERTIARY_EXEC_IPI_VIRT);
+		}
 	}
 
 	vmx_update_msr_bitmap_x2apic(vcpu);
@@ -4260,7 +4274,16 @@ static u32 vmx_exec_control(struct vcpu_vmx *vmx)
 
 static u64 vmx_tertiary_exec_control(struct vcpu_vmx *vmx)
 {
-	return vmcs_config.cpu_based_3rd_exec_ctrl;
+	u64 exec_control = vmcs_config.cpu_based_3rd_exec_ctrl;
+
+	/*
+	 * IPI virtualization relies on APICv. Disable IPI
+	 * virtualization if APICv is inhibited.
+	 */
+	if (!enable_ipiv || !kvm_vcpu_apicv_active(&vmx->vcpu))
+		exec_control &= ~TERTIARY_EXEC_IPI_VIRT;
+
+	return exec_control;
 }
 
 /*
@@ -4408,6 +4431,29 @@ static u32 vmx_secondary_exec_control(struct vcpu_vmx *vmx)
 	return exec_control;
 }
 
+static int vmx_alloc_pid_table(struct kvm_vmx *kvm_vmx)
+{
+	struct page *pages;
+
+	if(kvm_vmx->pid_table)
+		return 0;
+
+	pages = alloc_pages(GFP_KERNEL | __GFP_ZERO,
+			get_order(kvm_vmx->kvm.arch.max_vcpu_id * sizeof(u64)));
+
+	if (!pages)
+		return -ENOMEM;
+
+	kvm_vmx->pid_table = (void *)page_address(pages);
+	kvm_vmx->pid_last_index = kvm_vmx->kvm.arch.max_vcpu_id - 1;
+	return 0;
+}
+
+bool vmx_can_use_ipiv(struct kvm *kvm)
+{
+	return irqchip_in_kernel(kvm) && enable_ipiv;
+}
+
 #define VMX_XSS_EXIT_BITMAP 0
 
 static void init_vmcs(struct vcpu_vmx *vmx)
@@ -4443,6 +4489,13 @@ static void init_vmcs(struct vcpu_vmx *vmx)
 		vmcs_write64(POSTED_INTR_DESC_ADDR, __pa((&vmx->pi_desc)));
 	}
 
+	if (vmx_can_use_ipiv(vmx->vcpu.kvm)) {
+		struct kvm_vmx *kvm_vmx = to_kvm_vmx(vmx->vcpu.kvm);
+
+		vmcs_write64(PID_POINTER_TABLE, __pa(kvm_vmx->pid_table));
+		vmcs_write16(LAST_PID_POINTER_INDEX, kvm_vmx->pid_last_index);
+	}
+
 	if (!kvm_pause_in_guest(vmx->vcpu.kvm)) {
 		vmcs_write32(PLE_GAP, ple_gap);
 		vmx->ple_window = ple_window;
@@ -7123,6 +7176,22 @@ static int vmx_create_vcpu(struct kvm_vcpu *vcpu)
 			goto free_vmcs;
 	}
 
+	/*
+	 * Allocate PID-table and program this vCPU's PID-table
+	 * entry if IPI virtualization can be enabled.
+	 */
+	if (vmx_can_use_ipiv(vcpu->kvm)) {
+		struct kvm_vmx *kvm_vmx = to_kvm_vmx(vcpu->kvm);
+
+		mutex_lock(&vcpu->kvm->lock);
+		err = vmx_alloc_pid_table(kvm_vmx);
+		mutex_unlock(&vcpu->kvm->lock);
+		if (err)
+			goto free_vmcs;
+		WRITE_ONCE(kvm_vmx->pid_table[vcpu->vcpu_id],
+			__pa(&vmx->pi_desc) | PID_TABLE_ENTRY_VALID);
+	}
+
 	return 0;
 
 free_vmcs:
@@ -7756,6 +7825,15 @@ static bool vmx_check_apicv_inhibit_reasons(ulong bit)
 	return supported & BIT(bit);
 }
 
+static void vmx_vm_destroy(struct kvm *kvm)
+{
+	struct kvm_vmx *kvm_vmx = to_kvm_vmx(kvm);
+
+	if (kvm_vmx->pid_table)
+		free_pages((unsigned long)kvm_vmx->pid_table,
+			get_order((kvm_vmx->pid_last_index + 1) * sizeof(u64)));
+}
+
 static struct kvm_x86_ops vmx_x86_ops __initdata = {
 	.name = "kvm_intel",
 
@@ -7768,6 +7846,7 @@ static struct kvm_x86_ops vmx_x86_ops __initdata = {
 
 	.vm_size = sizeof(struct kvm_vmx),
 	.vm_init = vmx_vm_init,
+	.vm_destroy = vmx_vm_destroy,
 
 	.vcpu_create = vmx_create_vcpu,
 	.vcpu_free = vmx_free_vcpu,
@@ -8022,6 +8101,9 @@ static __init int hardware_setup(void)
 	if (!enable_apicv)
 		vmx_x86_ops.sync_pir_to_irr = NULL;
 
+	if (!enable_apicv || !cpu_has_vmx_ipiv())
+		enable_ipiv = false;
+
 	if (cpu_has_vmx_tsc_scaling()) {
 		kvm_has_tsc_control = true;
 		kvm_max_tsc_scaling_ratio = KVM_VMX_TSC_MULTIPLIER_MAX;
diff --git a/arch/x86/kvm/vmx/vmx.h b/arch/x86/kvm/vmx/vmx.h
index d4a647d3ed4a..5b65930a750e 100644
--- a/arch/x86/kvm/vmx/vmx.h
+++ b/arch/x86/kvm/vmx/vmx.h
@@ -365,6 +365,9 @@ struct kvm_vmx {
 	unsigned int tss_addr;
 	bool ept_identity_pagetable_done;
 	gpa_t ept_identity_map_addr;
+	/* PID table for IPI virtualization */
+	u64 *pid_table;
+	u16 pid_last_index;
 };
 
 bool nested_vmx_allowed(struct kvm_vcpu *vcpu);
@@ -584,4 +587,6 @@ static inline int vmx_get_instr_info_reg2(u32 vmx_instr_info)
 	return (vmx_instr_info >> 28) & 0xf;
 }
 
+bool vmx_can_use_ipiv(struct kvm *kvm);
+
 #endif /* __KVM_X86_VMX_H */
-- 
2.27.0

