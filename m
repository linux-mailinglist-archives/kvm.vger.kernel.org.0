Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7D99D3E3E81
	for <lists+kvm@lfdr.de>; Mon,  9 Aug 2021 05:55:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232987AbhHIDzV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 8 Aug 2021 23:55:21 -0400
Received: from mga05.intel.com ([192.55.52.43]:23274 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232958AbhHIDzT (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 8 Aug 2021 23:55:19 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10070"; a="300206611"
X-IronPort-AV: E=Sophos;i="5.84,305,1620716400"; 
   d="scan'208";a="300206611"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Aug 2021 20:54:59 -0700
X-IronPort-AV: E=Sophos;i="5.84,305,1620716400"; 
   d="scan'208";a="483125419"
Received: from arthur-vostro-3668.sh.intel.com ([10.239.13.1])
  by fmsmga008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Aug 2021 20:54:54 -0700
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
Subject: [PATCH v4 6/6] KVM: VMX: enable IPI virtualization
Date:   Mon,  9 Aug 2021 11:29:25 +0800
Message-Id: <20210809032925.3548-7-guang.zeng@intel.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210809032925.3548-1-guang.zeng@intel.com>
References: <20210809032925.3548-1-guang.zeng@intel.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Gao Chao <chao.gao@intel.com>

With IPI virtualization enabled, the processor emulates writes
to APIC registers that would send IPIs. The processor sets the
bit corresponding to the vector in target vCPU's PIR and may send
a notification (IPI) specified by NDST and NV fields in target vCPU's
PID. It is similar to what IOMMU engine does when dealing with posted
interrupt from devices.

A PID-pointer table is used by the processor to locate the PID of a
vCPU with the vCPU's APIC ID.

Like VT-d PI, if a vCPU goes to blocked state, VMM needs to switch its
notification vector to wakeup vector. This can ensure that when an IPI
for blocked vCPUs arrives, VMM can get control and wake up blocked
vCPUs. And if a VCPU is preempted, its posted interrupt notification
is suppressed.

Note that IPI virtualization can only virualize physical-addressing,
flat mode, unicast IPIs. Sending other IPIs would still cause a
VM exit and need to be handled by VMM.

Signed-off-by: Gao Chao <chao.gao@intel.com>
Signed-off-by: Zeng Guang <guang.zeng@intel.com>
---
 arch/x86/include/asm/vmx.h         |  8 ++++
 arch/x86/include/asm/vmxfeatures.h |  2 +
 arch/x86/kvm/vmx/capabilities.h    |  7 +++
 arch/x86/kvm/vmx/posted_intr.c     | 22 +++++++---
 arch/x86/kvm/vmx/vmx.c             | 69 ++++++++++++++++++++++++++++--
 arch/x86/kvm/vmx/vmx.h             |  3 ++
 6 files changed, 101 insertions(+), 10 deletions(-)

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
index b264f5c43b5f..e7b368a68c7c 100644
--- a/arch/x86/include/asm/vmxfeatures.h
+++ b/arch/x86/include/asm/vmxfeatures.h
@@ -86,4 +86,6 @@
 #define VMX_FEATURE_ENCLV_EXITING	( 2*32+ 28) /* "" VM-Exit on ENCLV (leaf dependent) */
 #define VMX_FEATURE_BUS_LOCK_DETECTION	( 2*32+ 30) /* "" VM-Exit when bus lock caused */
 
+/* Tertiary Processor-Based VM-Execution Controls, word 3 */
+#define VMX_FEATURE_IPI_VIRT		( 3*32 + 4) /* "" Enable IPI virtualization */
 #endif /* _ASM_X86_VMXFEATURES_H */
diff --git a/arch/x86/kvm/vmx/capabilities.h b/arch/x86/kvm/vmx/capabilities.h
index 38d414f64e61..78b0525dd991 100644
--- a/arch/x86/kvm/vmx/capabilities.h
+++ b/arch/x86/kvm/vmx/capabilities.h
@@ -12,6 +12,7 @@ extern bool __read_mostly enable_ept;
 extern bool __read_mostly enable_unrestricted_guest;
 extern bool __read_mostly enable_ept_ad_bits;
 extern bool __read_mostly enable_pml;
+extern bool __read_mostly enable_ipiv;
 extern int __read_mostly pt_mode;
 
 #define PT_MODE_SYSTEM		0
@@ -283,6 +284,12 @@ static inline bool cpu_has_vmx_apicv(void)
 		cpu_has_vmx_posted_intr();
 }
 
+static inline bool cpu_has_vmx_ipiv(void)
+{
+	return vmcs_config.cpu_based_3rd_exec_ctrl &
+		TERTIARY_EXEC_IPI_VIRT;
+}
+
 static inline bool cpu_has_vmx_flexpriority(void)
 {
 	return cpu_has_vmx_tpr_shadow() &&
diff --git a/arch/x86/kvm/vmx/posted_intr.c b/arch/x86/kvm/vmx/posted_intr.c
index 5f81ef092bd4..8c1400aaa1e7 100644
--- a/arch/x86/kvm/vmx/posted_intr.c
+++ b/arch/x86/kvm/vmx/posted_intr.c
@@ -81,9 +81,12 @@ void vmx_vcpu_pi_put(struct kvm_vcpu *vcpu)
 {
 	struct pi_desc *pi_desc = vcpu_to_pi_desc(vcpu);
 
-	if (!kvm_arch_has_assigned_device(vcpu->kvm) ||
-		!irq_remapping_cap(IRQ_POSTING_CAP)  ||
-		!kvm_vcpu_apicv_active(vcpu))
+	if (!kvm_vcpu_apicv_active(vcpu))
+		return;
+
+	if ((!kvm_arch_has_assigned_device(vcpu->kvm) ||
+		!irq_remapping_cap(IRQ_POSTING_CAP)) &&
+		!enable_ipiv)
 		return;
 
 	/* Set SN when the vCPU is preempted */
@@ -141,9 +144,16 @@ int pi_pre_block(struct kvm_vcpu *vcpu)
 	struct pi_desc old, new;
 	struct pi_desc *pi_desc = vcpu_to_pi_desc(vcpu);
 
-	if (!kvm_arch_has_assigned_device(vcpu->kvm) ||
-		!irq_remapping_cap(IRQ_POSTING_CAP)  ||
-		!kvm_vcpu_apicv_active(vcpu))
+	if (!kvm_vcpu_apicv_active(vcpu))
+		return 0;
+
+	/* Put vCPU into a list and set NV to wakeup vector if it is
+	 * one of the following cases:
+	 * 1. any assigned device is in use.
+	 * 2. IPI virtualization is enabled.
+	 */
+	if ((!kvm_arch_has_assigned_device(vcpu->kvm) ||
+		!irq_remapping_cap(IRQ_POSTING_CAP)) && !enable_ipiv)
 		return 0;
 
 	WARN_ON(irqs_disabled());
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 9eb351c351ce..684c556395bf 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -104,6 +104,9 @@ module_param(fasteoi, bool, S_IRUGO);
 
 module_param(enable_apicv, bool, S_IRUGO);
 
+bool __read_mostly enable_ipiv = 1;
+module_param(enable_ipiv, bool, S_IRUGO);
+
 /*
  * If nested=1, nested virtualization is supported, i.e., guests may use
  * VMX and be a hypervisor for its own guests. If nested=0, guests may not
@@ -225,6 +228,7 @@ static const struct {
 };
 
 #define L1D_CACHE_ORDER 4
+#define PID_TABLE_ORDER get_order(KVM_MAX_VCPU_ID << 3)
 static void *vmx_l1d_flush_pages;
 
 static int vmx_setup_l1d_flush(enum vmx_l1d_flush_state l1tf)
@@ -2514,7 +2518,7 @@ static __init int setup_vmcs_config(struct vmcs_config *vmcs_conf,
 	}
 
 	if (_cpu_based_exec_control & CPU_BASED_ACTIVATE_TERTIARY_CONTROLS) {
-		u64 opt3 = 0;
+		u64 opt3 = enable_ipiv ? TERTIARY_EXEC_IPI_VIRT : 0;
 		u64 min3 = 0;
 
 		if (adjust_vmx_controls_64(min3, opt3,
@@ -3870,6 +3874,8 @@ static void vmx_update_msr_bitmap_x2apic(struct kvm_vcpu *vcpu, u8 mode)
 		vmx_enable_intercept_for_msr(vcpu, X2APIC_MSR(APIC_TMCCT), MSR_TYPE_RW);
 		vmx_disable_intercept_for_msr(vcpu, X2APIC_MSR(APIC_EOI), MSR_TYPE_W);
 		vmx_disable_intercept_for_msr(vcpu, X2APIC_MSR(APIC_SELF_IPI), MSR_TYPE_W);
+		vmx_set_intercept_for_msr(vcpu, X2APIC_MSR(APIC_ICR),
+				MSR_TYPE_RW, !enable_ipiv);
 	}
 }
 
@@ -4138,14 +4144,21 @@ static void vmx_refresh_apicv_exec_ctrl(struct kvm_vcpu *vcpu)
 
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
+					TERTIARY_EXEC_IPI_VIRT);
+		} else {
 			secondary_exec_controls_clearbit(vmx,
 					SECONDARY_EXEC_APIC_REGISTER_VIRT |
 					SECONDARY_EXEC_VIRTUAL_INTR_DELIVERY);
+			if (cpu_has_tertiary_exec_ctrls())
+				tertiary_exec_controls_clearbit(vmx,
+					TERTIARY_EXEC_IPI_VIRT);
+		}
 	}
 
 	if (cpu_has_vmx_msr_bitmap())
@@ -4180,7 +4193,13 @@ u32 vmx_exec_control(struct vcpu_vmx *vmx)
 
 static u64 vmx_tertiary_exec_control(struct vcpu_vmx *vmx)
 {
-	return vmcs_config.cpu_based_3rd_exec_ctrl;
+	struct kvm_vcpu *vcpu = &vmx->vcpu;
+	u64 exec_control = vmcs_config.cpu_based_3rd_exec_ctrl;
+
+	if (!kvm_vcpu_apicv_active(vcpu))
+		exec_control &= ~TERTIARY_EXEC_IPI_VIRT;
+
+	return exec_control;
 }
 
 /*
@@ -4330,6 +4349,17 @@ static void vmx_compute_secondary_exec_control(struct vcpu_vmx *vmx)
 
 #define VMX_XSS_EXIT_BITMAP 0
 
+static void install_pid(struct vcpu_vmx *vmx)
+{
+	struct kvm_vmx *kvm_vmx = to_kvm_vmx(vmx->vcpu.kvm);
+
+	BUG_ON(vmx->vcpu.vcpu_id > kvm_vmx->pid_last_index);
+	/* Bit 0 is the valid bit */
+	kvm_vmx->pid_table[vmx->vcpu.vcpu_id] = __pa(&vmx->pi_desc) | 1;
+	vmcs_write64(PID_POINTER_TABLE, __pa(kvm_vmx->pid_table));
+	vmcs_write16(LAST_PID_POINTER_INDEX, kvm_vmx->pid_last_index);
+}
+
 /*
  * Noting that the initialization of Guest-state Area of VMCS is in
  * vmx_vcpu_reset().
@@ -4367,6 +4397,9 @@ static void init_vmcs(struct vcpu_vmx *vmx)
 
 		vmcs_write16(POSTED_INTR_NV, POSTED_INTR_VECTOR);
 		vmcs_write64(POSTED_INTR_DESC_ADDR, __pa((&vmx->pi_desc)));
+
+		if (enable_ipiv)
+			install_pid(vmx);
 	}
 
 	if (!kvm_pause_in_guest(vmx->vcpu.kvm)) {
@@ -6965,6 +6998,22 @@ static int vmx_vm_init(struct kvm *kvm)
 			break;
 		}
 	}
+
+	if (enable_ipiv) {
+		struct page *pages;
+
+		/* Allocate pages for PID table in order of PID_TABLE_ORDER
+		 * depending on KVM_MAX_VCPU_ID. Each PID entry is 8 bytes.
+		 */
+		pages = alloc_pages(GFP_KERNEL | __GFP_ZERO, PID_TABLE_ORDER);
+
+		if (!pages)
+			return -ENOMEM;
+
+		to_kvm_vmx(kvm)->pid_table = (void *)page_address(pages);
+		to_kvm_vmx(kvm)->pid_last_index = KVM_MAX_VCPU_ID;
+	}
+
 	return 0;
 }
 
@@ -7575,6 +7624,14 @@ static bool vmx_check_apicv_inhibit_reasons(ulong bit)
 	return supported & BIT(bit);
 }
 
+static void vmx_vm_destroy(struct kvm *kvm)
+{
+	struct kvm_vmx *kvm_vmx = to_kvm_vmx(kvm);
+
+	if (kvm_vmx->pid_table)
+		free_pages((unsigned long)kvm_vmx->pid_table, PID_TABLE_ORDER);
+}
+
 static struct kvm_x86_ops vmx_x86_ops __initdata = {
 	.hardware_unsetup = hardware_unsetup,
 
@@ -7585,6 +7642,7 @@ static struct kvm_x86_ops vmx_x86_ops __initdata = {
 
 	.vm_size = sizeof(struct kvm_vmx),
 	.vm_init = vmx_vm_init,
+	.vm_destroy = vmx_vm_destroy,
 
 	.vcpu_create = vmx_create_vcpu,
 	.vcpu_free = vmx_free_vcpu,
@@ -7824,6 +7882,9 @@ static __init int hardware_setup(void)
 		vmx_x86_ops.sync_pir_to_irr = NULL;
 	}
 
+	if (!enable_apicv || !cpu_has_vmx_ipiv())
+		enable_ipiv = 0;
+
 	if (cpu_has_vmx_tsc_scaling()) {
 		kvm_has_tsc_control = true;
 		kvm_max_tsc_scaling_ratio = KVM_VMX_TSC_MULTIPLIER_MAX;
diff --git a/arch/x86/kvm/vmx/vmx.h b/arch/x86/kvm/vmx/vmx.h
index f19ef1e14d08..41262a4ff87a 100644
--- a/arch/x86/kvm/vmx/vmx.h
+++ b/arch/x86/kvm/vmx/vmx.h
@@ -351,6 +351,9 @@ struct kvm_vmx {
 	unsigned int tss_addr;
 	bool ept_identity_pagetable_done;
 	gpa_t ept_identity_map_addr;
+	/* PID table for IPI virtualization */
+	u64 *pid_table;
+	u16 pid_last_index;
 };
 
 bool nested_vmx_allowed(struct kvm_vcpu *vcpu);
-- 
2.25.1

