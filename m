Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1CEF24C40B2
	for <lists+kvm@lfdr.de>; Fri, 25 Feb 2022 09:54:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238768AbiBYIy3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 25 Feb 2022 03:54:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55352 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238782AbiBYIy0 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 25 Feb 2022 03:54:26 -0500
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D937322B94A;
        Fri, 25 Feb 2022 00:53:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1645779228; x=1677315228;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references;
  bh=dvbJIK0QMNlrOEILYNkrNk+qxgBojkw4JwEFJuXi5gc=;
  b=PeJ7T45d8VQj+3CttbTn2BZLYvBTmfK7ij+OHJC7rk1NcvDHVxmjUfRa
   i46Mc2e6UX+KpjxVIo/Zm3GGleBuF/W7c7WmPd9JUR0x+X3sRf7qT9YOS
   YMDT+G6r61iy0+twsxK235Cd375FUdVztWQem5LUsA2/3s560MEv35QJY
   +rgsZAIQIP9k+v/g/pPKk/awKVTbTJddUbaU4FSClzRaqc4QUjhj8tbo/
   YykzwnwQLyZJCDrCRE6rTlAObhKdleuDTpOprIzUx4SA7EFe5zmHdHNzr
   rDzsSlpGnnRPo3N8w3bI7iIqAXWY6A5Okf29N/vFxr2pWHz4EvPkERFh7
   g==;
X-IronPort-AV: E=McAfee;i="6200,9189,10268"; a="252186106"
X-IronPort-AV: E=Sophos;i="5.90,136,1643702400"; 
   d="scan'208";a="252186106"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Feb 2022 00:53:48 -0800
X-IronPort-AV: E=Sophos;i="5.90,136,1643702400"; 
   d="scan'208";a="549186584"
Received: from arthur-vostro-3668.sh.intel.com ([10.239.13.120])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Feb 2022 00:53:42 -0800
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
Subject: [PATCH v6 7/9] KVM: VMX: enable IPI virtualization
Date:   Fri, 25 Feb 2022 16:22:21 +0800
Message-Id: <20220225082223.18288-8-guang.zeng@intel.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20220225082223.18288-1-guang.zeng@intel.com>
References: <20220225082223.18288-1-guang.zeng@intel.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Gao Chao <chao.gao@intel.com>

With IPI virtualization enabled, the processor emulates writes to
APIC registers that would send IPIs. The processor sets the bit
corresponding to the vector in target vCPU's PIR and may send a
notification (IPI) specified by NDST and NV fields in target vCPU's
Posted-Interrupt Descriptor (PID). It is similar to what IOMMU
engine does when dealing with posted interrupt from devices.

A PID-pointer table is used by the processor to locate the PID of a
vCPU with the vCPU's APIC ID.

Like VT-d PI, if a vCPU goes to blocked state, VMM needs to switch its
notification vector to wakeup vector. This can ensure that when an IPI
for blocked vCPUs arrives, VMM can get control and wake up blocked
vCPUs. And if a VCPU is preempted, its posted interrupt notification
is suppressed.

Note that IPI virtualization can only virualize physical-addressing,
flat mode, unicast IPIs. Sending other IPIs would still cause a
trap-like APIC-write VM-exit and need to be handled by VMM.

Signed-off-by: Gao Chao <chao.gao@intel.com>
Signed-off-by: Zeng Guang <guang.zeng@intel.com>
---
 arch/x86/include/asm/vmx.h         |  8 ++++
 arch/x86/include/asm/vmxfeatures.h |  2 +
 arch/x86/kvm/vmx/capabilities.h    |  6 +++
 arch/x86/kvm/vmx/posted_intr.c     | 12 ++++-
 arch/x86/kvm/vmx/vmx.c             | 74 +++++++++++++++++++++++++++---
 arch/x86/kvm/vmx/vmx.h             |  3 ++
 6 files changed, 97 insertions(+), 8 deletions(-)

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
index aa1fe9085d77..90124a30c074 100644
--- a/arch/x86/kvm/vmx/posted_intr.c
+++ b/arch/x86/kvm/vmx/posted_intr.c
@@ -177,11 +177,21 @@ static void pi_enable_wakeup_handler(struct kvm_vcpu *vcpu)
 	local_irq_restore(flags);
 }
 
+static bool vmx_can_use_ipiv_pi(struct kvm *kvm)
+{
+	return irqchip_in_kernel(kvm) && enable_ipiv;
+}
+
+static bool vmx_can_use_posted_interrupts(struct kvm *kvm)
+{
+	return vmx_can_use_ipiv_pi(kvm) || vmx_can_use_vtd_pi(kvm);
+}
+
 void vmx_vcpu_pi_put(struct kvm_vcpu *vcpu)
 {
 	struct pi_desc *pi_desc = vcpu_to_pi_desc(vcpu);
 
-	if (!vmx_can_use_vtd_pi(vcpu->kvm))
+	if (!vmx_can_use_posted_interrupts(vcpu->kvm))
 		return;
 
 	if (kvm_vcpu_is_blocking(vcpu) && !vmx_interrupt_blocked(vcpu))
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 7beba7a9f247..0cb141c277ef 100644
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
@@ -227,6 +230,11 @@ static const struct {
 };
 
 #define L1D_CACHE_ORDER 4
+
+/* PID(Posted-Interrupt Descriptor)-pointer table entry is 64-bit long */
+#define MAX_PID_TABLE_ORDER get_order(KVM_MAX_VCPU_IDS * sizeof(u64))
+#define PID_TABLE_ENTRY_VALID 1
+
 static void *vmx_l1d_flush_pages;
 
 static int vmx_setup_l1d_flush(enum vmx_l1d_flush_state l1tf)
@@ -2543,7 +2551,7 @@ static __init int setup_vmcs_config(struct vmcs_config *vmcs_conf,
 	}
 
 	if (_cpu_based_exec_control & CPU_BASED_ACTIVATE_TERTIARY_CONTROLS) {
-		u64 opt3 = 0;
+		u64 opt3 = TERTIARY_EXEC_IPI_VIRT;
 		u64 min3 = 0;
 
 		if (adjust_vmx_controls_64(min3, opt3,
@@ -3898,6 +3906,8 @@ static void vmx_update_msr_bitmap_x2apic(struct kvm_vcpu *vcpu)
 		vmx_enable_intercept_for_msr(vcpu, X2APIC_MSR(APIC_TMCCT), MSR_TYPE_RW);
 		vmx_disable_intercept_for_msr(vcpu, X2APIC_MSR(APIC_EOI), MSR_TYPE_W);
 		vmx_disable_intercept_for_msr(vcpu, X2APIC_MSR(APIC_SELF_IPI), MSR_TYPE_W);
+		if (enable_ipiv)
+			vmx_disable_intercept_for_msr(vcpu, X2APIC_MSR(APIC_ICR),MSR_TYPE_RW);
 	}
 }
 
@@ -4219,14 +4229,21 @@ static void vmx_refresh_apicv_exec_ctrl(struct kvm_vcpu *vcpu)
 
 	pin_controls_set(vmx, vmx_pin_based_exec_ctrl(vmx));
 	if (cpu_has_secondary_exec_ctrls()) {
-		if (kvm_vcpu_apicv_active(vcpu))
+		if (kvm_vcpu_apicv_active(vcpu)) {
 			secondary_exec_controls_setbit(vmx,
 				      SECONDARY_EXEC_APIC_REGISTER_VIRT |
 				      SECONDARY_EXEC_VIRTUAL_INTR_DELIVERY);
-		else
+			if (cpu_has_tertiary_exec_ctrls() && enable_ipiv)
+				tertiary_exec_controls_setbit(vmx,
+						TERTIARY_EXEC_IPI_VIRT);
+		} else {
 			secondary_exec_controls_clearbit(vmx,
 					SECONDARY_EXEC_APIC_REGISTER_VIRT |
 					SECONDARY_EXEC_VIRTUAL_INTR_DELIVERY);
+			if (cpu_has_tertiary_exec_ctrls())
+				tertiary_exec_controls_clearbit(vmx,
+						TERTIARY_EXEC_IPI_VIRT);
+		}
 	}
 
 	vmx_update_msr_bitmap_x2apic(vcpu);
@@ -4260,7 +4277,16 @@ static u32 vmx_exec_control(struct vcpu_vmx *vmx)
 
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
@@ -4412,6 +4438,9 @@ static u32 vmx_secondary_exec_control(struct vcpu_vmx *vmx)
 
 static void init_vmcs(struct vcpu_vmx *vmx)
 {
+	struct kvm_vcpu *vcpu = &vmx->vcpu;
+	struct kvm_vmx *kvm_vmx = to_kvm_vmx(vcpu->kvm);
+
 	if (nested)
 		nested_vmx_set_vmcs_shadowing_bitmap();
 
@@ -4431,7 +4460,7 @@ static void init_vmcs(struct vcpu_vmx *vmx)
 	if (cpu_has_tertiary_exec_ctrls())
 		tertiary_exec_controls_set(vmx, vmx_tertiary_exec_control(vmx));
 
-	if (kvm_vcpu_apicv_active(&vmx->vcpu)) {
+	if (kvm_vcpu_apicv_active(vcpu)) {
 		vmcs_write64(EOI_EXIT_BITMAP0, 0);
 		vmcs_write64(EOI_EXIT_BITMAP1, 0);
 		vmcs_write64(EOI_EXIT_BITMAP2, 0);
@@ -4441,6 +4470,13 @@ static void init_vmcs(struct vcpu_vmx *vmx)
 
 		vmcs_write16(POSTED_INTR_NV, POSTED_INTR_VECTOR);
 		vmcs_write64(POSTED_INTR_DESC_ADDR, __pa((&vmx->pi_desc)));
+
+		if (enable_ipiv) {
+			WRITE_ONCE(kvm_vmx->pid_table[vcpu->vcpu_id],
+				__pa(&vmx->pi_desc) | PID_TABLE_ENTRY_VALID);
+			vmcs_write64(PID_POINTER_TABLE, __pa(kvm_vmx->pid_table));
+			vmcs_write16(LAST_PID_POINTER_INDEX, kvm_vmx->pid_last_index);
+		}
 	}
 
 	if (!kvm_pause_in_guest(vmx->vcpu.kvm)) {
@@ -4492,7 +4528,7 @@ static void init_vmcs(struct vcpu_vmx *vmx)
 		vmcs_write16(GUEST_PML_INDEX, PML_ENTITY_NUM - 1);
 	}
 
-	vmx_write_encls_bitmap(&vmx->vcpu, NULL);
+	vmx_write_encls_bitmap(vcpu, NULL);
 
 	if (vmx_pt_mode_is_host_guest()) {
 		memset(&vmx->pt_desc, 0, sizeof(vmx->pt_desc));
@@ -4508,7 +4544,7 @@ static void init_vmcs(struct vcpu_vmx *vmx)
 
 	if (cpu_has_vmx_tpr_shadow()) {
 		vmcs_write64(VIRTUAL_APIC_PAGE_ADDR, 0);
-		if (cpu_need_tpr_shadow(&vmx->vcpu))
+		if (cpu_need_tpr_shadow(vcpu))
 			vmcs_write64(VIRTUAL_APIC_PAGE_ADDR,
 				     __pa(vmx->vcpu.arch.apic->regs));
 		vmcs_write32(TPR_THRESHOLD, 0);
@@ -7165,6 +7201,18 @@ static int vmx_vm_init(struct kvm *kvm)
 			break;
 		}
 	}
+
+	if (enable_ipiv) {
+		struct page *pages;
+
+		pages = alloc_pages(GFP_KERNEL | __GFP_ZERO, MAX_PID_TABLE_ORDER);
+		if (!pages)
+			return -ENOMEM;
+
+		to_kvm_vmx(kvm)->pid_table = (void *)page_address(pages);
+		to_kvm_vmx(kvm)->pid_last_index = KVM_MAX_VCPU_IDS - 1;
+	}
+
 	return 0;
 }
 
@@ -7756,6 +7804,14 @@ static bool vmx_check_apicv_inhibit_reasons(ulong bit)
 	return supported & BIT(bit);
 }
 
+static void vmx_vm_destroy(struct kvm *kvm)
+{
+	struct kvm_vmx *kvm_vmx = to_kvm_vmx(kvm);
+
+	if (kvm_vmx->pid_table)
+		free_pages((unsigned long)kvm_vmx->pid_table, MAX_PID_TABLE_ORDER);
+}
+
 static struct kvm_x86_ops vmx_x86_ops __initdata = {
 	.name = "kvm_intel",
 
@@ -7768,6 +7824,7 @@ static struct kvm_x86_ops vmx_x86_ops __initdata = {
 
 	.vm_size = sizeof(struct kvm_vmx),
 	.vm_init = vmx_vm_init,
+	.vm_destroy = vmx_vm_destroy,
 
 	.vcpu_create = vmx_create_vcpu,
 	.vcpu_free = vmx_free_vcpu,
@@ -8022,6 +8079,9 @@ static __init int hardware_setup(void)
 	if (!enable_apicv)
 		vmx_x86_ops.sync_pir_to_irr = NULL;
 
+	if (!enable_apicv || !cpu_has_vmx_ipiv())
+		enable_ipiv = false;
+
 	if (cpu_has_vmx_tsc_scaling()) {
 		kvm_has_tsc_control = true;
 		kvm_max_tsc_scaling_ratio = KVM_VMX_TSC_MULTIPLIER_MAX;
diff --git a/arch/x86/kvm/vmx/vmx.h b/arch/x86/kvm/vmx/vmx.h
index d4a647d3ed4a..e7b0c00c9d43 100644
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
-- 
2.27.0

