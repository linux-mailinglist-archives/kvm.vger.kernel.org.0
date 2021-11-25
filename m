Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 07B4845D1BF
	for <lists+kvm@lfdr.de>; Thu, 25 Nov 2021 01:24:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353699AbhKYAZR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 24 Nov 2021 19:25:17 -0500
Received: from mga12.intel.com ([192.55.52.136]:16262 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1353032AbhKYAYd (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 24 Nov 2021 19:24:33 -0500
X-IronPort-AV: E=McAfee;i="6200,9189,10178"; a="215432238"
X-IronPort-AV: E=Sophos;i="5.87,261,1631602800"; 
   d="scan'208";a="215432238"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Nov 2021 16:21:22 -0800
X-IronPort-AV: E=Sophos;i="5.87,261,1631602800"; 
   d="scan'208";a="675042350"
Received: from ls.sc.intel.com (HELO localhost) ([143.183.96.54])
  by orsmga005-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Nov 2021 16:21:21 -0800
From:   isaku.yamahata@intel.com
To:     Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "H . Peter Anvin" <hpa@zytor.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, erdemaktas@google.com,
        Connor Kuehl <ckuehl@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     isaku.yamahata@intel.com, isaku.yamahata@gmail.com,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        kernel test robot <lkp@intel.com>,
        Xiaoyao Li <xiaoyao.li@intel.com>
Subject: [RFC PATCH v3 44/59] KVM: VMX: Add 'main.c' to wrap VMX and TDX
Date:   Wed, 24 Nov 2021 16:20:27 -0800
Message-Id: <a8179e98ccaf3c99e785492ba8097c9cb5d393d0.1637799475.git.isaku.yamahata@intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1637799475.git.isaku.yamahata@intel.com>
References: <cover.1637799475.git.isaku.yamahata@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Sean Christopherson <sean.j.christopherson@intel.com>

Wrap the VMX kvm_x86_ops hooks in preparation of adding TDX, which can
coexist with VMX, i.e. KVM can run both VMs and TDs.  Use 'vt' for the
naming scheme as a nod to VT-x and as a concatenation of VmxTdx.

Reported-by: kernel test robot <lkp@intel.com>
Co-developed-by: Xiaoyao Li <xiaoyao.li@intel.com>
Signed-off-by: Xiaoyao Li <xiaoyao.li@intel.com>
Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
---
 arch/x86/kvm/Makefile      |   2 +-
 arch/x86/kvm/vmx/main.c    | 729 +++++++++++++++++++++++++++++++++++++
 arch/x86/kvm/vmx/vmx.c     | 463 ++++++++---------------
 arch/x86/kvm/vmx/x86_ops.h | 124 +++++++
 4 files changed, 1000 insertions(+), 318 deletions(-)
 create mode 100644 arch/x86/kvm/vmx/main.c
 create mode 100644 arch/x86/kvm/vmx/x86_ops.h

diff --git a/arch/x86/kvm/Makefile b/arch/x86/kvm/Makefile
index c7eceff49e67..d28f990bd81d 100644
--- a/arch/x86/kvm/Makefile
+++ b/arch/x86/kvm/Makefile
@@ -27,7 +27,7 @@ kvm-$(CONFIG_X86_64) += mmu/tdp_iter.o mmu/tdp_mmu.o
 kvm-$(CONFIG_KVM_XEN)	+= xen.o
 
 kvm-intel-y		+= vmx/vmx.o vmx/vmenter.o vmx/pmu_intel.o vmx/vmcs12.o \
-			   vmx/evmcs.o vmx/nested.o vmx/posted_intr.o
+			   vmx/evmcs.o vmx/nested.o vmx/posted_intr.o vmx/main.o
 kvm-intel-$(CONFIG_X86_SGX_KVM)	+= vmx/sgx.o
 kvm-intel-$(CONFIG_INTEL_TDX_HOST)	+= vmx/tdx_error.o
 
diff --git a/arch/x86/kvm/vmx/main.c b/arch/x86/kvm/vmx/main.c
new file mode 100644
index 000000000000..146dd6a317e5
--- /dev/null
+++ b/arch/x86/kvm/vmx/main.c
@@ -0,0 +1,729 @@
+// SPDX-License-Identifier: GPL-2.0
+#include <linux/moduleparam.h>
+
+#include "x86_ops.h"
+#include "vmx.h"
+#include "nested.h"
+#include "pmu.h"
+
+static int __init vt_cpu_has_kvm_support(void)
+{
+	return cpu_has_vmx();
+}
+
+static int __init vt_disabled_by_bios(void)
+{
+	return vmx_disabled_by_bios();
+}
+
+static int __init vt_check_processor_compatibility(void)
+{
+	int ret;
+
+	ret = vmx_check_processor_compat();
+	if (ret)
+		return ret;
+
+	return 0;
+}
+
+static __init int vt_hardware_setup(void)
+{
+	int ret;
+
+	ret = hardware_setup();
+	if (ret)
+		return ret;
+
+	return 0;
+}
+
+static int vt_hardware_enable(void)
+{
+	return hardware_enable();
+}
+
+static void vt_hardware_disable(void)
+{
+	hardware_disable();
+}
+
+static bool vt_cpu_has_accelerated_tpr(void)
+{
+	return report_flexpriority();
+}
+
+static bool vt_is_vm_type_supported(unsigned long type)
+{
+	return type == KVM_X86_LEGACY_VM;
+}
+
+static int vt_vm_init(struct kvm *kvm)
+{
+	return vmx_vm_init(kvm);
+}
+
+static void vt_mmu_prezap(struct kvm *kvm)
+{
+}
+
+static void vt_vm_destroy(struct kvm *kvm)
+{
+}
+
+static int vt_vcpu_create(struct kvm_vcpu *vcpu)
+{
+	return vmx_create_vcpu(vcpu);
+}
+
+static fastpath_t vt_vcpu_run(struct kvm_vcpu *vcpu)
+{
+	return vmx_vcpu_run(vcpu);
+}
+
+static void vt_vcpu_free(struct kvm_vcpu *vcpu)
+{
+	return vmx_free_vcpu(vcpu);
+}
+
+static void vt_vcpu_reset(struct kvm_vcpu *vcpu, bool init_event)
+{
+	return vmx_vcpu_reset(vcpu, init_event);
+}
+
+static void vt_vcpu_load(struct kvm_vcpu *vcpu, int cpu)
+{
+	return vmx_vcpu_load(vcpu, cpu);
+}
+
+static void vt_vcpu_put(struct kvm_vcpu *vcpu)
+{
+	return vmx_vcpu_put(vcpu);
+}
+
+static int vt_handle_exit(struct kvm_vcpu *vcpu,
+			     enum exit_fastpath_completion fastpath)
+{
+	return vmx_handle_exit(vcpu, fastpath);
+}
+
+static void vt_handle_exit_irqoff(struct kvm_vcpu *vcpu)
+{
+	vmx_handle_exit_irqoff(vcpu);
+}
+
+static int vt_skip_emulated_instruction(struct kvm_vcpu *vcpu)
+{
+	return vmx_skip_emulated_instruction(vcpu);
+}
+
+static void vt_update_emulated_instruction(struct kvm_vcpu *vcpu)
+{
+	vmx_update_emulated_instruction(vcpu);
+}
+
+static int vt_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
+{
+	return vmx_set_msr(vcpu, msr_info);
+}
+
+static int vt_smi_allowed(struct kvm_vcpu *vcpu, bool for_injection)
+{
+	return vmx_smi_allowed(vcpu, for_injection);
+}
+
+static int vt_enter_smm(struct kvm_vcpu *vcpu, char *smstate)
+{
+	return vmx_enter_smm(vcpu, smstate);
+}
+
+static int vt_leave_smm(struct kvm_vcpu *vcpu, const char *smstate)
+{
+	return vmx_leave_smm(vcpu, smstate);
+}
+
+static void vt_enable_smi_window(struct kvm_vcpu *vcpu)
+{
+	/* RSM will cause a vmexit anyway.  */
+	vmx_enable_smi_window(vcpu);
+}
+
+static bool vt_can_emulate_instruction(struct kvm_vcpu *vcpu, void *insn,
+				       int insn_len)
+{
+	return vmx_can_emulate_instruction(vcpu, insn, insn_len);
+}
+
+static int vt_check_intercept(struct kvm_vcpu *vcpu,
+				 struct x86_instruction_info *info,
+				 enum x86_intercept_stage stage,
+				 struct x86_exception *exception)
+{
+	return vmx_check_intercept(vcpu, info, stage, exception);
+}
+
+static bool vt_apic_init_signal_blocked(struct kvm_vcpu *vcpu)
+{
+	return vmx_apic_init_signal_blocked(vcpu);
+}
+
+static void vt_migrate_timers(struct kvm_vcpu *vcpu)
+{
+	vmx_migrate_timers(vcpu);
+}
+
+static void vt_set_virtual_apic_mode(struct kvm_vcpu *vcpu)
+{
+	return vmx_set_virtual_apic_mode(vcpu);
+}
+
+static void vt_apicv_post_state_restore(struct kvm_vcpu *vcpu)
+{
+	return vmx_apicv_post_state_restore(vcpu);
+}
+
+static bool vt_check_apicv_inhibit_reasons(ulong bit)
+{
+	return vmx_check_apicv_inhibit_reasons(bit);
+}
+
+static void vt_hwapic_irr_update(struct kvm_vcpu *vcpu, int max_irr)
+{
+	return vmx_hwapic_irr_update(vcpu, max_irr);
+}
+
+static void vt_hwapic_isr_update(struct kvm_vcpu *vcpu, int max_isr)
+{
+	return vmx_hwapic_isr_update(vcpu, max_isr);
+}
+
+static bool vt_guest_apic_has_interrupt(struct kvm_vcpu *vcpu)
+{
+	return vmx_guest_apic_has_interrupt(vcpu);
+}
+
+static int vt_sync_pir_to_irr(struct kvm_vcpu *vcpu)
+{
+	return vmx_sync_pir_to_irr(vcpu);
+}
+
+static int vt_deliver_posted_interrupt(struct kvm_vcpu *vcpu, int vector)
+{
+	return vmx_deliver_posted_interrupt(vcpu, vector);
+}
+
+static void vt_vcpu_after_set_cpuid(struct kvm_vcpu *vcpu)
+{
+	return vmx_vcpu_after_set_cpuid(vcpu);
+}
+
+/*
+ * The kvm parameter can be NULL (module initialization, or invocation before
+ * VM creation). Be sure to check the kvm parameter before using it.
+ */
+static bool vt_has_emulated_msr(struct kvm *kvm, u32 index)
+{
+	return vmx_has_emulated_msr(kvm, index);
+}
+
+static void vt_msr_filter_changed(struct kvm_vcpu *vcpu)
+{
+	vmx_msr_filter_changed(vcpu);
+}
+
+static void vt_prepare_switch_to_guest(struct kvm_vcpu *vcpu)
+{
+	vmx_prepare_switch_to_guest(vcpu);
+}
+
+static void vt_update_exception_bitmap(struct kvm_vcpu *vcpu)
+{
+	vmx_update_exception_bitmap(vcpu);
+}
+
+static int vt_get_msr_feature(struct kvm_msr_entry *msr)
+{
+	return vmx_get_msr_feature(msr);
+}
+
+static int vt_get_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
+{
+	return vmx_get_msr(vcpu, msr_info);
+}
+
+static u64 vt_get_segment_base(struct kvm_vcpu *vcpu, int seg)
+{
+	return vmx_get_segment_base(vcpu, seg);
+}
+
+static void vt_get_segment(struct kvm_vcpu *vcpu, struct kvm_segment *var,
+			      int seg)
+{
+	vmx_get_segment(vcpu, var, seg);
+}
+
+static void vt_set_segment(struct kvm_vcpu *vcpu, struct kvm_segment *var,
+			      int seg)
+{
+	vmx_set_segment(vcpu, var, seg);
+}
+
+static int vt_get_cpl(struct kvm_vcpu *vcpu)
+{
+	return vmx_get_cpl(vcpu);
+}
+
+static void vt_get_cs_db_l_bits(struct kvm_vcpu *vcpu, int *db, int *l)
+{
+	vmx_get_cs_db_l_bits(vcpu, db, l);
+}
+
+static void vt_set_cr0(struct kvm_vcpu *vcpu, unsigned long cr0)
+{
+	vmx_set_cr0(vcpu, cr0);
+}
+
+static void vt_load_mmu_pgd(struct kvm_vcpu *vcpu, hpa_t root_hpa,
+			    int pgd_level)
+{
+	vmx_load_mmu_pgd(vcpu, root_hpa, pgd_level);
+}
+
+static void vt_set_cr4(struct kvm_vcpu *vcpu, unsigned long cr4)
+{
+	vmx_set_cr4(vcpu, cr4);
+}
+
+static bool vt_is_valid_cr4(struct kvm_vcpu *vcpu, unsigned long cr4)
+{
+	return vmx_is_valid_cr4(vcpu, cr4);
+}
+
+static int vt_set_efer(struct kvm_vcpu *vcpu, u64 efer)
+{
+	return vmx_set_efer(vcpu, efer);
+}
+
+static void vt_get_idt(struct kvm_vcpu *vcpu, struct desc_ptr *dt)
+{
+	vmx_get_idt(vcpu, dt);
+}
+
+static void vt_set_idt(struct kvm_vcpu *vcpu, struct desc_ptr *dt)
+{
+	vmx_set_idt(vcpu, dt);
+}
+
+static void vt_get_gdt(struct kvm_vcpu *vcpu, struct desc_ptr *dt)
+{
+	vmx_get_gdt(vcpu, dt);
+}
+
+static void vt_set_gdt(struct kvm_vcpu *vcpu, struct desc_ptr *dt)
+{
+	vmx_set_gdt(vcpu, dt);
+}
+
+static void vt_set_dr7(struct kvm_vcpu *vcpu, unsigned long val)
+{
+	vmx_set_dr7(vcpu, val);
+}
+
+static void vt_sync_dirty_debug_regs(struct kvm_vcpu *vcpu)
+{
+	vmx_sync_dirty_debug_regs(vcpu);
+}
+
+static void vt_cache_reg(struct kvm_vcpu *vcpu, enum kvm_reg reg)
+{
+	vmx_cache_reg(vcpu, reg);
+}
+
+static unsigned long vt_get_rflags(struct kvm_vcpu *vcpu)
+{
+	return vmx_get_rflags(vcpu);
+}
+
+static void vt_set_rflags(struct kvm_vcpu *vcpu, unsigned long rflags)
+{
+	vmx_set_rflags(vcpu, rflags);
+}
+
+static void vt_flush_tlb_all(struct kvm_vcpu *vcpu)
+{
+	vmx_flush_tlb_all(vcpu);
+}
+
+static void vt_flush_tlb_current(struct kvm_vcpu *vcpu)
+{
+	vmx_flush_tlb_current(vcpu);
+}
+
+static void vt_flush_tlb_gva(struct kvm_vcpu *vcpu, gva_t addr)
+{
+	vmx_flush_tlb_gva(vcpu, addr);
+}
+
+static void vt_flush_tlb_guest(struct kvm_vcpu *vcpu)
+{
+	vmx_flush_tlb_guest(vcpu);
+}
+
+static void vt_set_interrupt_shadow(struct kvm_vcpu *vcpu, int mask)
+{
+	vmx_set_interrupt_shadow(vcpu, mask);
+}
+
+static u32 vt_get_interrupt_shadow(struct kvm_vcpu *vcpu)
+{
+	return vmx_get_interrupt_shadow(vcpu);
+}
+
+static void vt_patch_hypercall(struct kvm_vcpu *vcpu,
+				  unsigned char *hypercall)
+{
+	vmx_patch_hypercall(vcpu, hypercall);
+}
+
+static void vt_inject_irq(struct kvm_vcpu *vcpu)
+{
+	vmx_inject_irq(vcpu);
+}
+
+static void vt_inject_nmi(struct kvm_vcpu *vcpu)
+{
+	vmx_inject_nmi(vcpu);
+}
+
+static void vt_queue_exception(struct kvm_vcpu *vcpu)
+{
+	vmx_queue_exception(vcpu);
+}
+
+static void vt_cancel_injection(struct kvm_vcpu *vcpu)
+{
+	vmx_cancel_injection(vcpu);
+}
+
+static int vt_interrupt_allowed(struct kvm_vcpu *vcpu, bool for_injection)
+{
+	return vmx_interrupt_allowed(vcpu, for_injection);
+}
+
+static int vt_nmi_allowed(struct kvm_vcpu *vcpu, bool for_injection)
+{
+	return vmx_nmi_allowed(vcpu, for_injection);
+}
+
+static bool vt_get_nmi_mask(struct kvm_vcpu *vcpu)
+{
+	return vmx_get_nmi_mask(vcpu);
+}
+
+static void vt_set_nmi_mask(struct kvm_vcpu *vcpu, bool masked)
+{
+	vmx_set_nmi_mask(vcpu, masked);
+}
+
+static void vt_enable_nmi_window(struct kvm_vcpu *vcpu)
+{
+	vmx_enable_nmi_window(vcpu);
+}
+
+static void vt_enable_irq_window(struct kvm_vcpu *vcpu)
+{
+	vmx_enable_irq_window(vcpu);
+}
+
+static void vt_update_cr8_intercept(struct kvm_vcpu *vcpu, int tpr, int irr)
+{
+	vmx_update_cr8_intercept(vcpu, tpr, irr);
+}
+
+static void vt_set_apic_access_page_addr(struct kvm_vcpu *vcpu)
+{
+	vmx_set_apic_access_page_addr(vcpu);
+}
+
+static void vt_refresh_apicv_exec_ctrl(struct kvm_vcpu *vcpu)
+{
+	vmx_refresh_apicv_exec_ctrl(vcpu);
+}
+
+static void vt_load_eoi_exitmap(struct kvm_vcpu *vcpu, u64 *eoi_exit_bitmap)
+{
+	vmx_load_eoi_exitmap(vcpu, eoi_exit_bitmap);
+}
+
+static int vt_set_tss_addr(struct kvm *kvm, unsigned int addr)
+{
+	return vmx_set_tss_addr(kvm, addr);
+}
+
+static int vt_set_identity_map_addr(struct kvm *kvm, u64 ident_addr)
+{
+	return vmx_set_identity_map_addr(kvm, ident_addr);
+}
+
+static u64 vt_get_mt_mask(struct kvm_vcpu *vcpu, gfn_t gfn, bool is_mmio)
+{
+	return vmx_get_mt_mask(vcpu, gfn, is_mmio);
+}
+
+static void vt_get_exit_info(struct kvm_vcpu *vcpu, u32 *reason,
+			u64 *info1, u64 *info2, u32 *intr_info, u32 *error_code)
+{
+	vmx_get_exit_info(vcpu, reason, info1, info2, intr_info, error_code);
+}
+
+static u64 vt_get_l2_tsc_offset(struct kvm_vcpu *vcpu)
+{
+	return vmx_get_l2_tsc_offset(vcpu);
+}
+
+static u64 vt_get_l2_tsc_multiplier(struct kvm_vcpu *vcpu)
+{
+	return vmx_get_l2_tsc_multiplier(vcpu);
+}
+
+static void vt_write_tsc_offset(struct kvm_vcpu *vcpu, u64 offset)
+{
+	vmx_write_tsc_offset(vcpu, offset);
+}
+
+static void vt_write_tsc_multiplier(struct kvm_vcpu *vcpu, u64 multiplier)
+{
+	vmx_write_tsc_multiplier(vcpu, multiplier);
+}
+
+static void vt_request_immediate_exit(struct kvm_vcpu *vcpu)
+{
+	vmx_request_immediate_exit(vcpu);
+}
+
+static void vt_sched_in(struct kvm_vcpu *vcpu, int cpu)
+{
+	vmx_sched_in(vcpu, cpu);
+}
+
+static void vt_update_cpu_dirty_logging(struct kvm_vcpu *vcpu)
+{
+	vmx_update_cpu_dirty_logging(vcpu);
+}
+
+static int vt_pre_block(struct kvm_vcpu *vcpu)
+{
+	if (pi_pre_block(vcpu))
+		return 1;
+
+	return vmx_pre_block(vcpu);
+}
+
+static void vt_post_block(struct kvm_vcpu *vcpu)
+{
+	vmx_post_block(vcpu);
+
+	pi_post_block(vcpu);
+}
+
+
+#ifdef CONFIG_X86_64
+static int vt_set_hv_timer(struct kvm_vcpu *vcpu, u64 guest_deadline_tsc,
+			      bool *expired)
+{
+	return vmx_set_hv_timer(vcpu, guest_deadline_tsc, expired);
+}
+
+static void vt_cancel_hv_timer(struct kvm_vcpu *vcpu)
+{
+	vmx_cancel_hv_timer(vcpu);
+}
+#endif
+
+static void vt_setup_mce(struct kvm_vcpu *vcpu)
+{
+	vmx_setup_mce(vcpu);
+}
+
+struct kvm_x86_ops vt_x86_ops __initdata = {
+	.name = "kvm_intel",
+
+	.hardware_unsetup = hardware_unsetup,
+
+	.hardware_enable = vt_hardware_enable,
+	.hardware_disable = vt_hardware_disable,
+	.cpu_has_accelerated_tpr = vt_cpu_has_accelerated_tpr,
+	.has_emulated_msr = vt_has_emulated_msr,
+
+	.is_vm_type_supported = vt_is_vm_type_supported,
+	.vm_size = sizeof(struct kvm_vmx),
+	.vm_init = vt_vm_init,
+	.mmu_prezap = vt_mmu_prezap,
+	.vm_teardown = NULL,
+	.vm_destroy = vt_vm_destroy,
+
+	.vcpu_create = vt_vcpu_create,
+	.vcpu_free = vt_vcpu_free,
+	.vcpu_reset = vt_vcpu_reset,
+
+	.prepare_guest_switch = vt_prepare_switch_to_guest,
+	.vcpu_load = vt_vcpu_load,
+	.vcpu_put = vt_vcpu_put,
+
+	.update_exception_bitmap = vt_update_exception_bitmap,
+	.get_msr_feature = vt_get_msr_feature,
+	.get_msr = vt_get_msr,
+	.set_msr = vt_set_msr,
+	.get_segment_base = vt_get_segment_base,
+	.get_segment = vt_get_segment,
+	.set_segment = vt_set_segment,
+	.get_cpl = vt_get_cpl,
+	.get_cs_db_l_bits = vt_get_cs_db_l_bits,
+	.set_cr0 = vt_set_cr0,
+	.is_valid_cr4 = vt_is_valid_cr4,
+	.set_cr4 = vt_set_cr4,
+	.set_efer = vt_set_efer,
+	.get_idt = vt_get_idt,
+	.set_idt = vt_set_idt,
+	.get_gdt = vt_get_gdt,
+	.set_gdt = vt_set_gdt,
+	.set_dr7 = vt_set_dr7,
+	.sync_dirty_debug_regs = vt_sync_dirty_debug_regs,
+	.cache_reg = vt_cache_reg,
+	.get_rflags = vt_get_rflags,
+	.set_rflags = vt_set_rflags,
+
+	.tlb_flush_all = vt_flush_tlb_all,
+	.tlb_flush_current = vt_flush_tlb_current,
+	.tlb_flush_gva = vt_flush_tlb_gva,
+	.tlb_flush_guest = vt_flush_tlb_guest,
+
+	.run = vt_vcpu_run,
+	.handle_exit = vt_handle_exit,
+	.skip_emulated_instruction = vt_skip_emulated_instruction,
+	.update_emulated_instruction = vt_update_emulated_instruction,
+	.set_interrupt_shadow = vt_set_interrupt_shadow,
+	.get_interrupt_shadow = vt_get_interrupt_shadow,
+	.patch_hypercall = vt_patch_hypercall,
+	.set_irq = vt_inject_irq,
+	.set_nmi = vt_inject_nmi,
+	.queue_exception = vt_queue_exception,
+	.cancel_injection = vt_cancel_injection,
+	.interrupt_allowed = vt_interrupt_allowed,
+	.nmi_allowed = vt_nmi_allowed,
+	.get_nmi_mask = vt_get_nmi_mask,
+	.set_nmi_mask = vt_set_nmi_mask,
+	.enable_nmi_window = vt_enable_nmi_window,
+	.enable_irq_window = vt_enable_irq_window,
+	.update_cr8_intercept = vt_update_cr8_intercept,
+	.set_virtual_apic_mode = vt_set_virtual_apic_mode,
+	.set_apic_access_page_addr = vt_set_apic_access_page_addr,
+	.refresh_apicv_exec_ctrl = vt_refresh_apicv_exec_ctrl,
+	.load_eoi_exitmap = vt_load_eoi_exitmap,
+	.apicv_post_state_restore = vt_apicv_post_state_restore,
+	.check_apicv_inhibit_reasons = vt_check_apicv_inhibit_reasons,
+	.hwapic_irr_update = vt_hwapic_irr_update,
+	.hwapic_isr_update = vt_hwapic_isr_update,
+	.guest_apic_has_interrupt = vt_guest_apic_has_interrupt,
+	.sync_pir_to_irr = vt_sync_pir_to_irr,
+	.deliver_posted_interrupt = vt_deliver_posted_interrupt,
+	.dy_apicv_has_pending_interrupt = pi_has_pending_interrupt,
+
+	.set_tss_addr = vt_set_tss_addr,
+	.set_identity_map_addr = vt_set_identity_map_addr,
+	.get_mt_mask = vt_get_mt_mask,
+
+	.get_exit_info = vt_get_exit_info,
+
+	.vcpu_after_set_cpuid = vt_vcpu_after_set_cpuid,
+
+	.has_wbinvd_exit = cpu_has_vmx_wbinvd_exit,
+
+	.get_l2_tsc_offset = vt_get_l2_tsc_offset,
+	.get_l2_tsc_multiplier = vt_get_l2_tsc_multiplier,
+	.write_tsc_offset = vt_write_tsc_offset,
+	.write_tsc_multiplier = vt_write_tsc_multiplier,
+
+	.load_mmu_pgd = vt_load_mmu_pgd,
+
+	.check_intercept = vt_check_intercept,
+	.handle_exit_irqoff = vt_handle_exit_irqoff,
+
+	.request_immediate_exit = vt_request_immediate_exit,
+
+	.sched_in = vt_sched_in,
+
+	.cpu_dirty_log_size = PML_ENTITY_NUM,
+	.update_cpu_dirty_logging = vt_update_cpu_dirty_logging,
+
+	.pre_block = vt_pre_block,
+	.post_block = vt_post_block,
+
+	.pmu_ops = &intel_pmu_ops,
+	.nested_ops = &vmx_nested_ops,
+
+	.update_pi_irte = pi_update_irte,
+
+#ifdef CONFIG_X86_64
+	.set_hv_timer = vt_set_hv_timer,
+	.cancel_hv_timer = vt_cancel_hv_timer,
+#endif
+
+	.setup_mce = vt_setup_mce,
+
+	.smi_allowed = vt_smi_allowed,
+	.enter_smm = vt_enter_smm,
+	.leave_smm = vt_leave_smm,
+	.enable_smi_window = vt_enable_smi_window,
+
+	.can_emulate_instruction = vt_can_emulate_instruction,
+	.apic_init_signal_blocked = vt_apic_init_signal_blocked,
+	.migrate_timers = vt_migrate_timers,
+
+	.msr_filter_changed = vt_msr_filter_changed,
+	.complete_emulated_msr = kvm_complete_insn_gp,
+
+	.vcpu_deliver_sipi_vector = kvm_vcpu_deliver_sipi_vector,
+};
+
+static struct kvm_x86_init_ops vt_init_ops __initdata = {
+	.cpu_has_kvm_support = vt_cpu_has_kvm_support,
+	.disabled_by_bios = vt_disabled_by_bios,
+	.check_processor_compatibility = vt_check_processor_compatibility,
+	.hardware_setup = vt_hardware_setup,
+
+	.runtime_ops = &vt_x86_ops,
+};
+
+static int __init vt_init(void)
+{
+	unsigned int vcpu_size = 0, vcpu_align = 0;
+	int r;
+
+	vmx_pre_kvm_init(&vcpu_size, &vcpu_align);
+
+	r = kvm_init(&vt_init_ops, vcpu_size, vcpu_align, THIS_MODULE);
+	if (r)
+		goto err_vmx_post_exit;
+
+	r = vmx_init();
+	if (r)
+		goto err_kvm_exit;
+
+	return 0;
+
+err_kvm_exit:
+	kvm_exit();
+err_vmx_post_exit:
+	vmx_post_kvm_exit();
+	return r;
+}
+module_init(vt_init);
+
+static void vt_exit(void)
+{
+	vmx_exit();
+	kvm_exit();
+	vmx_post_kvm_exit();
+}
+module_exit(vt_exit);
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 92b2c4ac627c..404afac897bc 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -66,6 +66,7 @@
 #include "vmcs12.h"
 #include "vmx.h"
 #include "x86.h"
+#include "x86_ops.h"
 
 MODULE_AUTHOR("Qumranet");
 MODULE_LICENSE("GPL");
@@ -539,7 +540,7 @@ static inline bool cpu_need_virtualize_apic_accesses(struct kvm_vcpu *vcpu)
 	return flexpriority_enabled && lapic_in_kernel(vcpu);
 }
 
-static inline bool report_flexpriority(void)
+bool report_flexpriority(void)
 {
 	return flexpriority_enabled;
 }
@@ -1299,7 +1300,7 @@ void vmx_vcpu_load_vmcs(struct kvm_vcpu *vcpu, int cpu,
  * Switches to specified vcpu, until a matching vcpu_put(), but assumes
  * vcpu mutex is already taken.
  */
-static void vmx_vcpu_load(struct kvm_vcpu *vcpu, int cpu)
+void vmx_vcpu_load(struct kvm_vcpu *vcpu, int cpu)
 {
 	struct vcpu_vmx *vmx = to_vmx(vcpu);
 
@@ -1310,7 +1311,7 @@ static void vmx_vcpu_load(struct kvm_vcpu *vcpu, int cpu)
 	vmx->host_debugctlmsr = get_debugctlmsr();
 }
 
-static void vmx_vcpu_put(struct kvm_vcpu *vcpu)
+void vmx_vcpu_put(struct kvm_vcpu *vcpu)
 {
 	vmx_vcpu_pi_put(vcpu);
 
@@ -1465,7 +1466,7 @@ static int vmx_rtit_ctl_check(struct kvm_vcpu *vcpu, u64 data)
 	return 0;
 }
 
-static bool vmx_can_emulate_instruction(struct kvm_vcpu *vcpu, void *insn, int insn_len)
+bool vmx_can_emulate_instruction(struct kvm_vcpu *vcpu, void *insn, int insn_len)
 {
 	/*
 	 * Emulation of instructions in SGX enclaves is impossible as RIP does
@@ -1549,7 +1550,7 @@ static int skip_emulated_instruction(struct kvm_vcpu *vcpu)
  * Recognizes a pending MTF VM-exit and records the nested state for later
  * delivery.
  */
-static void vmx_update_emulated_instruction(struct kvm_vcpu *vcpu)
+void vmx_update_emulated_instruction(struct kvm_vcpu *vcpu)
 {
 	struct vmcs12 *vmcs12 = get_vmcs12(vcpu);
 	struct vcpu_vmx *vmx = to_vmx(vcpu);
@@ -1572,7 +1573,7 @@ static void vmx_update_emulated_instruction(struct kvm_vcpu *vcpu)
 		vmx->nested.mtf_pending = false;
 }
 
-static int vmx_skip_emulated_instruction(struct kvm_vcpu *vcpu)
+int vmx_skip_emulated_instruction(struct kvm_vcpu *vcpu)
 {
 	vmx_update_emulated_instruction(vcpu);
 	return skip_emulated_instruction(vcpu);
@@ -1591,7 +1592,7 @@ static void vmx_clear_hlt(struct kvm_vcpu *vcpu)
 		vmcs_write32(GUEST_ACTIVITY_STATE, GUEST_ACTIVITY_ACTIVE);
 }
 
-static void vmx_queue_exception(struct kvm_vcpu *vcpu)
+void vmx_queue_exception(struct kvm_vcpu *vcpu)
 {
 	struct vcpu_vmx *vmx = to_vmx(vcpu);
 	unsigned nr = vcpu->arch.exception.nr;
@@ -1704,12 +1705,12 @@ u64 vmx_get_l2_tsc_multiplier(struct kvm_vcpu *vcpu)
 	return kvm_default_tsc_scaling_ratio;
 }
 
-static void vmx_write_tsc_offset(struct kvm_vcpu *vcpu, u64 offset)
+void vmx_write_tsc_offset(struct kvm_vcpu *vcpu, u64 offset)
 {
 	vmcs_write64(TSC_OFFSET, offset);
 }
 
-static void vmx_write_tsc_multiplier(struct kvm_vcpu *vcpu, u64 multiplier)
+void vmx_write_tsc_multiplier(struct kvm_vcpu *vcpu, u64 multiplier)
 {
 	vmcs_write64(TSC_MULTIPLIER, multiplier);
 }
@@ -1733,7 +1734,7 @@ static inline bool vmx_feature_control_msr_valid(struct kvm_vcpu *vcpu,
 	return !(val & ~valid_bits);
 }
 
-static int vmx_get_msr_feature(struct kvm_msr_entry *msr)
+int vmx_get_msr_feature(struct kvm_msr_entry *msr)
 {
 	switch (msr->index) {
 	case MSR_IA32_VMX_BASIC ... MSR_IA32_VMX_VMFUNC:
@@ -1753,7 +1754,7 @@ static int vmx_get_msr_feature(struct kvm_msr_entry *msr)
  * Returns 0 on success, non-0 otherwise.
  * Assumes vcpu_load() was already called.
  */
-static int vmx_get_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
+int vmx_get_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 {
 	struct vcpu_vmx *vmx = to_vmx(vcpu);
 	struct vmx_uret_msr *msr;
@@ -1931,7 +1932,7 @@ static u64 vcpu_supported_debugctl(struct kvm_vcpu *vcpu)
  * Returns 0 on success, non-0 otherwise.
  * Assumes vcpu_load() was already called.
  */
-static int vmx_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
+int vmx_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 {
 	struct vcpu_vmx *vmx = to_vmx(vcpu);
 	struct vmx_uret_msr *msr;
@@ -2229,7 +2230,7 @@ static int vmx_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 	return ret;
 }
 
-static void vmx_cache_reg(struct kvm_vcpu *vcpu, enum kvm_reg reg)
+void vmx_cache_reg(struct kvm_vcpu *vcpu, enum kvm_reg reg)
 {
 	unsigned long guest_owned_bits;
 
@@ -2272,18 +2273,13 @@ static void vmx_cache_reg(struct kvm_vcpu *vcpu, enum kvm_reg reg)
 	}
 }
 
-static __init int cpu_has_kvm_support(void)
-{
-	return cpu_has_vmx();
-}
-
-static __init int vmx_disabled_by_bios(void)
+__init int vmx_disabled_by_bios(void)
 {
 	return !boot_cpu_has(X86_FEATURE_MSR_IA32_FEAT_CTL) ||
 	       !boot_cpu_has(X86_FEATURE_VMX);
 }
 
-static int hardware_enable(void)
+int hardware_enable(void)
 {
 	int cpu = raw_smp_processor_id();
 	u64 phys_addr = __pa(per_cpu(vmxarea, cpu));
@@ -2324,7 +2320,7 @@ static void vmclear_local_loaded_vmcss(void)
 		__loaded_vmcs_clear(v);
 }
 
-static void hardware_disable(void)
+void hardware_disable(void)
 {
 	vmclear_local_loaded_vmcss();
 
@@ -2876,7 +2872,7 @@ static void exit_lmode(struct kvm_vcpu *vcpu)
 
 #endif
 
-static void vmx_flush_tlb_all(struct kvm_vcpu *vcpu)
+void vmx_flush_tlb_all(struct kvm_vcpu *vcpu)
 {
 	struct vcpu_vmx *vmx = to_vmx(vcpu);
 
@@ -2899,7 +2895,7 @@ static void vmx_flush_tlb_all(struct kvm_vcpu *vcpu)
 	}
 }
 
-static void vmx_flush_tlb_current(struct kvm_vcpu *vcpu)
+void vmx_flush_tlb_current(struct kvm_vcpu *vcpu)
 {
 	struct kvm_mmu *mmu = vcpu->arch.mmu;
 	u64 root_hpa = mmu->root_hpa;
@@ -2917,7 +2913,7 @@ static void vmx_flush_tlb_current(struct kvm_vcpu *vcpu)
 		vpid_sync_context(nested_get_vpid02(vcpu));
 }
 
-static void vmx_flush_tlb_gva(struct kvm_vcpu *vcpu, gva_t addr)
+void vmx_flush_tlb_gva(struct kvm_vcpu *vcpu, gva_t addr)
 {
 	/*
 	 * vpid_sync_vcpu_addr() is a nop if vmx->vpid==0, see the comment in
@@ -2926,7 +2922,7 @@ static void vmx_flush_tlb_gva(struct kvm_vcpu *vcpu, gva_t addr)
 	vpid_sync_vcpu_addr(to_vmx(vcpu)->vpid, addr);
 }
 
-static void vmx_flush_tlb_guest(struct kvm_vcpu *vcpu)
+void vmx_flush_tlb_guest(struct kvm_vcpu *vcpu)
 {
 	/*
 	 * vpid_sync_context() is a nop if vmx->vpid==0, e.g. if enable_vpid==0
@@ -3074,8 +3070,7 @@ u64 construct_eptp(struct kvm_vcpu *vcpu, hpa_t root_hpa, int root_level)
 	return eptp;
 }
 
-static void vmx_load_mmu_pgd(struct kvm_vcpu *vcpu, hpa_t root_hpa,
-			     int root_level)
+void vmx_load_mmu_pgd(struct kvm_vcpu *vcpu, hpa_t root_hpa, int root_level)
 {
 	struct kvm *kvm = vcpu->kvm;
 	bool update_guest_cr3 = true;
@@ -3103,7 +3098,7 @@ static void vmx_load_mmu_pgd(struct kvm_vcpu *vcpu, hpa_t root_hpa,
 		vmcs_writel(GUEST_CR3, guest_cr3);
 }
 
-static bool vmx_is_valid_cr4(struct kvm_vcpu *vcpu, unsigned long cr4)
+bool vmx_is_valid_cr4(struct kvm_vcpu *vcpu, unsigned long cr4)
 {
 	/*
 	 * We operate under the default treatment of SMM, so VMX cannot be
@@ -3219,7 +3214,7 @@ void vmx_get_segment(struct kvm_vcpu *vcpu, struct kvm_segment *var, int seg)
 	var->g = (ar >> 15) & 1;
 }
 
-static u64 vmx_get_segment_base(struct kvm_vcpu *vcpu, int seg)
+u64 vmx_get_segment_base(struct kvm_vcpu *vcpu, int seg)
 {
 	struct kvm_segment s;
 
@@ -3299,14 +3294,14 @@ void __vmx_set_segment(struct kvm_vcpu *vcpu, struct kvm_segment *var, int seg)
 	vmcs_write32(sf->ar_bytes, vmx_segment_access_rights(var));
 }
 
-static void vmx_set_segment(struct kvm_vcpu *vcpu, struct kvm_segment *var, int seg)
+void vmx_set_segment(struct kvm_vcpu *vcpu, struct kvm_segment *var, int seg)
 {
 	__vmx_set_segment(vcpu, var, seg);
 
 	to_vmx(vcpu)->emulation_required = vmx_emulation_required(vcpu);
 }
 
-static void vmx_get_cs_db_l_bits(struct kvm_vcpu *vcpu, int *db, int *l)
+void vmx_get_cs_db_l_bits(struct kvm_vcpu *vcpu, int *db, int *l)
 {
 	u32 ar = vmx_read_guest_seg_ar(to_vmx(vcpu), VCPU_SREG_CS);
 
@@ -3314,25 +3309,25 @@ static void vmx_get_cs_db_l_bits(struct kvm_vcpu *vcpu, int *db, int *l)
 	*l = (ar >> 13) & 1;
 }
 
-static void vmx_get_idt(struct kvm_vcpu *vcpu, struct desc_ptr *dt)
+void vmx_get_idt(struct kvm_vcpu *vcpu, struct desc_ptr *dt)
 {
 	dt->size = vmcs_read32(GUEST_IDTR_LIMIT);
 	dt->address = vmcs_readl(GUEST_IDTR_BASE);
 }
 
-static void vmx_set_idt(struct kvm_vcpu *vcpu, struct desc_ptr *dt)
+void vmx_set_idt(struct kvm_vcpu *vcpu, struct desc_ptr *dt)
 {
 	vmcs_write32(GUEST_IDTR_LIMIT, dt->size);
 	vmcs_writel(GUEST_IDTR_BASE, dt->address);
 }
 
-static void vmx_get_gdt(struct kvm_vcpu *vcpu, struct desc_ptr *dt)
+void vmx_get_gdt(struct kvm_vcpu *vcpu, struct desc_ptr *dt)
 {
 	dt->size = vmcs_read32(GUEST_GDTR_LIMIT);
 	dt->address = vmcs_readl(GUEST_GDTR_BASE);
 }
 
-static void vmx_set_gdt(struct kvm_vcpu *vcpu, struct desc_ptr *dt)
+void vmx_set_gdt(struct kvm_vcpu *vcpu, struct desc_ptr *dt)
 {
 	vmcs_write32(GUEST_GDTR_LIMIT, dt->size);
 	vmcs_writel(GUEST_GDTR_BASE, dt->address);
@@ -3817,7 +3812,7 @@ void pt_update_intercept_for_msr(struct kvm_vcpu *vcpu)
 	}
 }
 
-static bool vmx_guest_apic_has_interrupt(struct kvm_vcpu *vcpu)
+bool vmx_guest_apic_has_interrupt(struct kvm_vcpu *vcpu)
 {
 	struct vcpu_vmx *vmx = to_vmx(vcpu);
 	void *vapic_page;
@@ -3837,7 +3832,7 @@ static bool vmx_guest_apic_has_interrupt(struct kvm_vcpu *vcpu)
 	return ((rvi & 0xf0) > (vppr & 0xf0));
 }
 
-static void vmx_msr_filter_changed(struct kvm_vcpu *vcpu)
+void vmx_msr_filter_changed(struct kvm_vcpu *vcpu)
 {
 	struct vcpu_vmx *vmx = to_vmx(vcpu);
 	u32 i;
@@ -3925,7 +3920,7 @@ static int vmx_deliver_nested_posted_interrupt(struct kvm_vcpu *vcpu,
  * 2. If target vcpu isn't running(root mode), kick it to pick up the
  * interrupt from PIR in next vmentry.
  */
-static int vmx_deliver_posted_interrupt(struct kvm_vcpu *vcpu, int vector)
+int vmx_deliver_posted_interrupt(struct kvm_vcpu *vcpu, int vector)
 {
 	struct vcpu_vmx *vmx = to_vmx(vcpu);
 	int r;
@@ -4068,7 +4063,7 @@ static u32 vmx_vmexit_ctrl(void)
 		~(VM_EXIT_LOAD_IA32_PERF_GLOBAL_CTRL | VM_EXIT_LOAD_IA32_EFER);
 }
 
-static void vmx_refresh_apicv_exec_ctrl(struct kvm_vcpu *vcpu)
+void vmx_refresh_apicv_exec_ctrl(struct kvm_vcpu *vcpu)
 {
 	struct vcpu_vmx *vmx = to_vmx(vcpu);
 
@@ -4391,7 +4386,7 @@ static void __vmx_vcpu_reset(struct kvm_vcpu *vcpu)
 	vmx->pi_desc.sn = 1;
 }
 
-static void vmx_vcpu_reset(struct kvm_vcpu *vcpu, bool init_event)
+void vmx_vcpu_reset(struct kvm_vcpu *vcpu, bool init_event)
 {
 	struct vcpu_vmx *vmx = to_vmx(vcpu);
 
@@ -4448,12 +4443,12 @@ static void vmx_vcpu_reset(struct kvm_vcpu *vcpu, bool init_event)
 	vpid_sync_context(vmx->vpid);
 }
 
-static void vmx_enable_irq_window(struct kvm_vcpu *vcpu)
+void vmx_enable_irq_window(struct kvm_vcpu *vcpu)
 {
 	exec_controls_setbit(to_vmx(vcpu), CPU_BASED_INTR_WINDOW_EXITING);
 }
 
-static void vmx_enable_nmi_window(struct kvm_vcpu *vcpu)
+void vmx_enable_nmi_window(struct kvm_vcpu *vcpu)
 {
 	if (!enable_vnmi ||
 	    vmcs_read32(GUEST_INTERRUPTIBILITY_INFO) & GUEST_INTR_STATE_STI) {
@@ -4464,7 +4459,7 @@ static void vmx_enable_nmi_window(struct kvm_vcpu *vcpu)
 	exec_controls_setbit(to_vmx(vcpu), CPU_BASED_NMI_WINDOW_EXITING);
 }
 
-static void vmx_inject_irq(struct kvm_vcpu *vcpu)
+void vmx_inject_irq(struct kvm_vcpu *vcpu)
 {
 	struct vcpu_vmx *vmx = to_vmx(vcpu);
 	uint32_t intr;
@@ -4492,7 +4487,7 @@ static void vmx_inject_irq(struct kvm_vcpu *vcpu)
 	vmx_clear_hlt(vcpu);
 }
 
-static void vmx_inject_nmi(struct kvm_vcpu *vcpu)
+void vmx_inject_nmi(struct kvm_vcpu *vcpu)
 {
 	struct vcpu_vmx *vmx = to_vmx(vcpu);
 
@@ -4570,7 +4565,7 @@ bool vmx_nmi_blocked(struct kvm_vcpu *vcpu)
 		 GUEST_INTR_STATE_NMI));
 }
 
-static int vmx_nmi_allowed(struct kvm_vcpu *vcpu, bool for_injection)
+int vmx_nmi_allowed(struct kvm_vcpu *vcpu, bool for_injection)
 {
 	if (to_vmx(vcpu)->nested.nested_run_pending)
 		return -EBUSY;
@@ -4592,7 +4587,7 @@ bool vmx_interrupt_blocked(struct kvm_vcpu *vcpu)
 		(GUEST_INTR_STATE_STI | GUEST_INTR_STATE_MOV_SS));
 }
 
-static int vmx_interrupt_allowed(struct kvm_vcpu *vcpu, bool for_injection)
+int vmx_interrupt_allowed(struct kvm_vcpu *vcpu, bool for_injection)
 {
 	if (to_vmx(vcpu)->nested.nested_run_pending)
 		return -EBUSY;
@@ -4607,7 +4602,7 @@ static int vmx_interrupt_allowed(struct kvm_vcpu *vcpu, bool for_injection)
 	return !vmx_interrupt_blocked(vcpu);
 }
 
-static int vmx_set_tss_addr(struct kvm *kvm, unsigned int addr)
+int vmx_set_tss_addr(struct kvm *kvm, unsigned int addr)
 {
 	void __user *ret;
 
@@ -4627,7 +4622,7 @@ static int vmx_set_tss_addr(struct kvm *kvm, unsigned int addr)
 	return init_rmode_tss(kvm, ret);
 }
 
-static int vmx_set_identity_map_addr(struct kvm *kvm, u64 ident_addr)
+int vmx_set_identity_map_addr(struct kvm *kvm, u64 ident_addr)
 {
 	to_kvm_vmx(kvm)->ept_identity_map_addr = ident_addr;
 	return 0;
@@ -4870,8 +4865,7 @@ static int handle_io(struct kvm_vcpu *vcpu)
 	return kvm_fast_pio(vcpu, size, port, in);
 }
 
-static void
-vmx_patch_hypercall(struct kvm_vcpu *vcpu, unsigned char *hypercall)
+void vmx_patch_hypercall(struct kvm_vcpu *vcpu, unsigned char *hypercall)
 {
 	/*
 	 * Patch in the VMCALL instruction:
@@ -5081,7 +5075,7 @@ static int handle_dr(struct kvm_vcpu *vcpu)
 	return kvm_complete_insn_gp(vcpu, err);
 }
 
-static void vmx_sync_dirty_debug_regs(struct kvm_vcpu *vcpu)
+void vmx_sync_dirty_debug_regs(struct kvm_vcpu *vcpu)
 {
 	get_debugreg(vcpu->arch.db[0], 0);
 	get_debugreg(vcpu->arch.db[1], 1);
@@ -5100,7 +5094,7 @@ static void vmx_sync_dirty_debug_regs(struct kvm_vcpu *vcpu)
 	set_debugreg(DR6_RESERVED, 6);
 }
 
-static void vmx_set_dr7(struct kvm_vcpu *vcpu, unsigned long val)
+void vmx_set_dr7(struct kvm_vcpu *vcpu, unsigned long val)
 {
 	vmcs_writel(GUEST_DR7, val);
 }
@@ -5563,9 +5557,8 @@ static int (*kvm_vmx_exit_handlers[])(struct kvm_vcpu *vcpu) = {
 static const int kvm_vmx_max_exit_handlers =
 	ARRAY_SIZE(kvm_vmx_exit_handlers);
 
-static void vmx_get_exit_info(struct kvm_vcpu *vcpu, u32 *reason,
-			      u64 *info1, u64 *info2,
-			      u32 *intr_info, u32 *error_code)
+void vmx_get_exit_info(struct kvm_vcpu *vcpu, u32 *reason,
+		u64 *info1, u64 *info2, u32 *intr_info, u32 *error_code)
 {
 	struct vcpu_vmx *vmx = to_vmx(vcpu);
 
@@ -5982,7 +5975,7 @@ static int __vmx_handle_exit(struct kvm_vcpu *vcpu, fastpath_t exit_fastpath)
 	return 0;
 }
 
-static int vmx_handle_exit(struct kvm_vcpu *vcpu, fastpath_t exit_fastpath)
+int vmx_handle_exit(struct kvm_vcpu *vcpu, fastpath_t exit_fastpath)
 {
 	int ret = __vmx_handle_exit(vcpu, exit_fastpath);
 
@@ -6070,7 +6063,7 @@ static noinstr void vmx_l1d_flush(struct kvm_vcpu *vcpu)
 		: "eax", "ebx", "ecx", "edx");
 }
 
-static void vmx_update_cr8_intercept(struct kvm_vcpu *vcpu, int tpr, int irr)
+void vmx_update_cr8_intercept(struct kvm_vcpu *vcpu, int tpr, int irr)
 {
 	struct vmcs12 *vmcs12 = get_vmcs12(vcpu);
 	int tpr_threshold;
@@ -6140,7 +6133,7 @@ void vmx_set_virtual_apic_mode(struct kvm_vcpu *vcpu)
 	vmx_update_msr_bitmap_x2apic(vcpu);
 }
 
-static void vmx_set_apic_access_page_addr(struct kvm_vcpu *vcpu)
+void vmx_set_apic_access_page_addr(struct kvm_vcpu *vcpu)
 {
 	struct page *page;
 
@@ -6168,7 +6161,7 @@ static void vmx_set_apic_access_page_addr(struct kvm_vcpu *vcpu)
 	put_page(page);
 }
 
-static void vmx_hwapic_isr_update(struct kvm_vcpu *vcpu, int max_isr)
+void vmx_hwapic_isr_update(struct kvm_vcpu *vcpu, int max_isr)
 {
 	u16 status;
 	u8 old;
@@ -6202,7 +6195,7 @@ static void vmx_set_rvi(int vector)
 	}
 }
 
-static void vmx_hwapic_irr_update(struct kvm_vcpu *vcpu, int max_irr)
+void vmx_hwapic_irr_update(struct kvm_vcpu *vcpu, int max_irr)
 {
 	/*
 	 * When running L2, updating RVI is only relevant when
@@ -6216,7 +6209,7 @@ static void vmx_hwapic_irr_update(struct kvm_vcpu *vcpu, int max_irr)
 		vmx_set_rvi(max_irr);
 }
 
-static int vmx_sync_pir_to_irr(struct kvm_vcpu *vcpu)
+int vmx_sync_pir_to_irr(struct kvm_vcpu *vcpu)
 {
 	struct vcpu_vmx *vmx = to_vmx(vcpu);
 	int max_irr;
@@ -6251,7 +6244,7 @@ static int vmx_sync_pir_to_irr(struct kvm_vcpu *vcpu)
 	return max_irr;
 }
 
-static void vmx_load_eoi_exitmap(struct kvm_vcpu *vcpu, u64 *eoi_exit_bitmap)
+void vmx_load_eoi_exitmap(struct kvm_vcpu *vcpu, u64 *eoi_exit_bitmap)
 {
 	if (!kvm_vcpu_apicv_active(vcpu))
 		return;
@@ -6262,7 +6255,7 @@ static void vmx_load_eoi_exitmap(struct kvm_vcpu *vcpu, u64 *eoi_exit_bitmap)
 	vmcs_write64(EOI_EXIT_BITMAP3, eoi_exit_bitmap[3]);
 }
 
-static void vmx_apicv_post_state_restore(struct kvm_vcpu *vcpu)
+void vmx_apicv_post_state_restore(struct kvm_vcpu *vcpu)
 {
 	struct vcpu_vmx *vmx = to_vmx(vcpu);
 
@@ -6270,7 +6263,7 @@ static void vmx_apicv_post_state_restore(struct kvm_vcpu *vcpu)
 	memset(vmx->pi_desc.pir, 0, sizeof(vmx->pi_desc.pir));
 }
 
-static void vmx_handle_exit_irqoff(struct kvm_vcpu *vcpu)
+void vmx_handle_exit_irqoff(struct kvm_vcpu *vcpu)
 {
 	struct vcpu_vmx *vmx = to_vmx(vcpu);
 
@@ -6288,7 +6281,7 @@ static void vmx_handle_exit_irqoff(struct kvm_vcpu *vcpu)
  * The kvm parameter can be NULL (module initialization, or invocation before
  * VM creation). Be sure to check the kvm parameter before using it.
  */
-static bool vmx_has_emulated_msr(struct kvm *kvm, u32 index)
+bool vmx_has_emulated_msr(struct kvm *kvm, u32 index)
 {
 	switch (index) {
 	case MSR_IA32_SMBASE:
@@ -6409,7 +6402,7 @@ static void vmx_complete_interrupts(struct vcpu_vmx *vmx)
 				  IDT_VECTORING_ERROR_CODE);
 }
 
-static void vmx_cancel_injection(struct kvm_vcpu *vcpu)
+void vmx_cancel_injection(struct kvm_vcpu *vcpu)
 {
 	__vmx_complete_interrupts(vcpu,
 				  vmcs_read32(VM_ENTRY_INTR_INFO_FIELD),
@@ -6505,7 +6498,7 @@ static noinstr void vmx_vcpu_enter_exit(struct kvm_vcpu *vcpu,
 	kvm_guest_exit_irqoff();
 }
 
-static fastpath_t vmx_vcpu_run(struct kvm_vcpu *vcpu)
+fastpath_t vmx_vcpu_run(struct kvm_vcpu *vcpu)
 {
 	struct vcpu_vmx *vmx = to_vmx(vcpu);
 	unsigned long cr3, cr4;
@@ -6693,7 +6686,7 @@ static fastpath_t vmx_vcpu_run(struct kvm_vcpu *vcpu)
 	return vmx_exit_handlers_fastpath(vcpu);
 }
 
-static void vmx_free_vcpu(struct kvm_vcpu *vcpu)
+void vmx_free_vcpu(struct kvm_vcpu *vcpu)
 {
 	struct vcpu_vmx *vmx = to_vmx(vcpu);
 
@@ -6704,7 +6697,7 @@ static void vmx_free_vcpu(struct kvm_vcpu *vcpu)
 	free_loaded_vmcs(vmx->loaded_vmcs);
 }
 
-static int vmx_create_vcpu(struct kvm_vcpu *vcpu)
+int vmx_create_vcpu(struct kvm_vcpu *vcpu)
 {
 	struct vmx_uret_msr *tsx_ctrl;
 	struct vcpu_vmx *vmx;
@@ -6791,15 +6784,10 @@ static int vmx_create_vcpu(struct kvm_vcpu *vcpu)
 	return err;
 }
 
-static bool vmx_is_vm_type_supported(unsigned long type)
-{
-	return type == KVM_X86_LEGACY_VM;
-}
-
 #define L1TF_MSG_SMT "L1TF CPU bug present and SMT on, data leak possible. See CVE-2018-3646 and https://www.kernel.org/doc/html/latest/admin-guide/hw-vuln/l1tf.html for details.\n"
 #define L1TF_MSG_L1D "L1TF CPU bug present and virtualization mitigation disabled, data leak possible. See CVE-2018-3646 and https://www.kernel.org/doc/html/latest/admin-guide/hw-vuln/l1tf.html for details.\n"
 
-static int vmx_vm_init(struct kvm *kvm)
+int vmx_vm_init(struct kvm *kvm)
 {
 	if (!ple_gap)
 		kvm->arch.pause_in_guest = true;
@@ -6830,12 +6818,7 @@ static int vmx_vm_init(struct kvm *kvm)
 	return 0;
 }
 
-static void vmx_vm_destroy(struct kvm *kvm)
-{
-
-}
-
-static int __init vmx_check_processor_compat(void)
+int __init vmx_check_processor_compat(void)
 {
 	struct vmcs_config vmcs_conf;
 	struct vmx_capability vmx_cap;
@@ -6858,7 +6841,7 @@ static int __init vmx_check_processor_compat(void)
 	return 0;
 }
 
-static u64 vmx_get_mt_mask(struct kvm_vcpu *vcpu, gfn_t gfn, bool is_mmio)
+u64 vmx_get_mt_mask(struct kvm_vcpu *vcpu, gfn_t gfn, bool is_mmio)
 {
 	u8 cache;
 	u64 ipat = 0;
@@ -7056,7 +7039,7 @@ static void update_intel_pt_cfg(struct kvm_vcpu *vcpu)
 		vmx->pt_desc.ctl_bitmask &= ~(0xfULL << (32 + i * 4));
 }
 
-static void vmx_vcpu_after_set_cpuid(struct kvm_vcpu *vcpu)
+void vmx_vcpu_after_set_cpuid(struct kvm_vcpu *vcpu)
 {
 	struct vcpu_vmx *vmx = to_vmx(vcpu);
 
@@ -7156,7 +7139,7 @@ static __init void vmx_set_cpu_caps(void)
 		kvm_cpu_cap_check_and_set(X86_FEATURE_WAITPKG);
 }
 
-static void vmx_request_immediate_exit(struct kvm_vcpu *vcpu)
+void vmx_request_immediate_exit(struct kvm_vcpu *vcpu)
 {
 	to_vmx(vcpu)->req_immediate_exit = true;
 }
@@ -7195,10 +7178,10 @@ static int vmx_check_intercept_io(struct kvm_vcpu *vcpu,
 	return intercept ? X86EMUL_UNHANDLEABLE : X86EMUL_CONTINUE;
 }
 
-static int vmx_check_intercept(struct kvm_vcpu *vcpu,
-			       struct x86_instruction_info *info,
-			       enum x86_intercept_stage stage,
-			       struct x86_exception *exception)
+int vmx_check_intercept(struct kvm_vcpu *vcpu,
+		       struct x86_instruction_info *info,
+		       enum x86_intercept_stage stage,
+		       struct x86_exception *exception)
 {
 	struct vmcs12 *vmcs12 = get_vmcs12(vcpu);
 
@@ -7263,8 +7246,8 @@ static inline int u64_shl_div_u64(u64 a, unsigned int shift,
 	return 0;
 }
 
-static int vmx_set_hv_timer(struct kvm_vcpu *vcpu, u64 guest_deadline_tsc,
-			    bool *expired)
+int vmx_set_hv_timer(struct kvm_vcpu *vcpu, u64 guest_deadline_tsc,
+		bool *expired)
 {
 	struct vcpu_vmx *vmx;
 	u64 tscl, guest_tscl, delta_tsc, lapic_timer_advance_cycles;
@@ -7303,13 +7286,13 @@ static int vmx_set_hv_timer(struct kvm_vcpu *vcpu, u64 guest_deadline_tsc,
 	return 0;
 }
 
-static void vmx_cancel_hv_timer(struct kvm_vcpu *vcpu)
+void vmx_cancel_hv_timer(struct kvm_vcpu *vcpu)
 {
 	to_vmx(vcpu)->hv_deadline_tsc = -1;
 }
 #endif
 
-static void vmx_sched_in(struct kvm_vcpu *vcpu, int cpu)
+void vmx_sched_in(struct kvm_vcpu *vcpu, int cpu)
 {
 	if (!kvm_pause_in_guest(vcpu->kvm))
 		shrink_ple_window(vcpu);
@@ -7335,26 +7318,21 @@ void vmx_update_cpu_dirty_logging(struct kvm_vcpu *vcpu)
 		secondary_exec_controls_clearbit(vmx, SECONDARY_EXEC_ENABLE_PML);
 }
 
-static int vmx_pre_block(struct kvm_vcpu *vcpu)
+int vmx_pre_block(struct kvm_vcpu *vcpu)
 {
-	if (pi_pre_block(vcpu))
-		return 1;
-
 	if (kvm_lapic_hv_timer_in_use(vcpu))
 		kvm_lapic_switch_to_sw_timer(vcpu);
 
 	return 0;
 }
 
-static void vmx_post_block(struct kvm_vcpu *vcpu)
+void vmx_post_block(struct kvm_vcpu *vcpu)
 {
 	if (kvm_x86_ops.set_hv_timer)
 		kvm_lapic_switch_to_hv_timer(vcpu);
-
-	pi_post_block(vcpu);
 }
 
-static void vmx_setup_mce(struct kvm_vcpu *vcpu)
+void vmx_setup_mce(struct kvm_vcpu *vcpu)
 {
 	if (vcpu->arch.mcg_cap & MCG_LMCE_P)
 		to_vmx(vcpu)->msr_ia32_feature_control_valid_bits |=
@@ -7364,7 +7342,7 @@ static void vmx_setup_mce(struct kvm_vcpu *vcpu)
 			~FEAT_CTL_LMCE_ENABLED;
 }
 
-static int vmx_smi_allowed(struct kvm_vcpu *vcpu, bool for_injection)
+int vmx_smi_allowed(struct kvm_vcpu *vcpu, bool for_injection)
 {
 	/* we need a nested vmexit to enter SMM, postpone if run is pending */
 	if (to_vmx(vcpu)->nested.nested_run_pending)
@@ -7372,7 +7350,7 @@ static int vmx_smi_allowed(struct kvm_vcpu *vcpu, bool for_injection)
 	return !is_smm(vcpu);
 }
 
-static int vmx_enter_smm(struct kvm_vcpu *vcpu, char *smstate)
+int vmx_enter_smm(struct kvm_vcpu *vcpu, char *smstate)
 {
 	struct vcpu_vmx *vmx = to_vmx(vcpu);
 
@@ -7386,7 +7364,7 @@ static int vmx_enter_smm(struct kvm_vcpu *vcpu, char *smstate)
 	return 0;
 }
 
-static int vmx_leave_smm(struct kvm_vcpu *vcpu, const char *smstate)
+int vmx_leave_smm(struct kvm_vcpu *vcpu, const char *smstate)
 {
 	struct vcpu_vmx *vmx = to_vmx(vcpu);
 	int ret;
@@ -7406,17 +7384,17 @@ static int vmx_leave_smm(struct kvm_vcpu *vcpu, const char *smstate)
 	return 0;
 }
 
-static void vmx_enable_smi_window(struct kvm_vcpu *vcpu)
+void vmx_enable_smi_window(struct kvm_vcpu *vcpu)
 {
 	/* RSM will cause a vmexit anyway.  */
 }
 
-static bool vmx_apic_init_signal_blocked(struct kvm_vcpu *vcpu)
+bool vmx_apic_init_signal_blocked(struct kvm_vcpu *vcpu)
 {
 	return to_vmx(vcpu)->nested.vmxon && !is_guest_mode(vcpu);
 }
 
-static void vmx_migrate_timers(struct kvm_vcpu *vcpu)
+void vmx_migrate_timers(struct kvm_vcpu *vcpu)
 {
 	if (is_guest_mode(vcpu)) {
 		struct hrtimer *timer = &to_vmx(vcpu)->nested.preemption_timer;
@@ -7426,7 +7404,7 @@ static void vmx_migrate_timers(struct kvm_vcpu *vcpu)
 	}
 }
 
-static void hardware_unsetup(void)
+void hardware_unsetup(void)
 {
 	kvm_set_posted_intr_wakeup_handler(NULL);
 
@@ -7436,7 +7414,7 @@ static void hardware_unsetup(void)
 	free_kvm_area();
 }
 
-static bool vmx_check_apicv_inhibit_reasons(ulong bit)
+bool vmx_check_apicv_inhibit_reasons(ulong bit)
 {
 	ulong supported = BIT(APICV_INHIBIT_REASON_DISABLE) |
 			  BIT(APICV_INHIBIT_REASON_HYPERV) |
@@ -7445,147 +7423,6 @@ static bool vmx_check_apicv_inhibit_reasons(ulong bit)
 	return supported & BIT(bit);
 }
 
-static struct kvm_x86_ops vmx_x86_ops __initdata = {
-	.name = "kvm_intel",
-
-	.hardware_unsetup = hardware_unsetup,
-
-	.hardware_enable = hardware_enable,
-	.hardware_disable = hardware_disable,
-	.cpu_has_accelerated_tpr = report_flexpriority,
-	.has_emulated_msr = vmx_has_emulated_msr,
-
-	.is_vm_type_supported = vmx_is_vm_type_supported,
-	.vm_size = sizeof(struct kvm_vmx),
-	.vm_init = vmx_vm_init,
-	.vm_teardown = NULL,
-	.vm_destroy = vmx_vm_destroy,
-
-	.vcpu_create = vmx_create_vcpu,
-	.vcpu_free = vmx_free_vcpu,
-	.vcpu_reset = vmx_vcpu_reset,
-
-	.prepare_guest_switch = vmx_prepare_switch_to_guest,
-	.vcpu_load = vmx_vcpu_load,
-	.vcpu_put = vmx_vcpu_put,
-
-	.update_exception_bitmap = vmx_update_exception_bitmap,
-	.get_msr_feature = vmx_get_msr_feature,
-	.get_msr = vmx_get_msr,
-	.set_msr = vmx_set_msr,
-	.get_segment_base = vmx_get_segment_base,
-	.get_segment = vmx_get_segment,
-	.set_segment = vmx_set_segment,
-	.get_cpl = vmx_get_cpl,
-	.get_cs_db_l_bits = vmx_get_cs_db_l_bits,
-	.set_cr0 = vmx_set_cr0,
-	.is_valid_cr4 = vmx_is_valid_cr4,
-	.set_cr4 = vmx_set_cr4,
-	.set_efer = vmx_set_efer,
-	.get_idt = vmx_get_idt,
-	.set_idt = vmx_set_idt,
-	.get_gdt = vmx_get_gdt,
-	.set_gdt = vmx_set_gdt,
-	.set_dr7 = vmx_set_dr7,
-	.sync_dirty_debug_regs = vmx_sync_dirty_debug_regs,
-	.cache_reg = vmx_cache_reg,
-	.get_rflags = vmx_get_rflags,
-	.set_rflags = vmx_set_rflags,
-
-	.tlb_flush_all = vmx_flush_tlb_all,
-	.tlb_flush_current = vmx_flush_tlb_current,
-	.tlb_flush_gva = vmx_flush_tlb_gva,
-	.tlb_flush_guest = vmx_flush_tlb_guest,
-
-	.run = vmx_vcpu_run,
-	.handle_exit = vmx_handle_exit,
-	.skip_emulated_instruction = vmx_skip_emulated_instruction,
-	.update_emulated_instruction = vmx_update_emulated_instruction,
-	.set_interrupt_shadow = vmx_set_interrupt_shadow,
-	.get_interrupt_shadow = vmx_get_interrupt_shadow,
-	.patch_hypercall = vmx_patch_hypercall,
-	.set_irq = vmx_inject_irq,
-	.set_nmi = vmx_inject_nmi,
-	.queue_exception = vmx_queue_exception,
-	.cancel_injection = vmx_cancel_injection,
-	.interrupt_allowed = vmx_interrupt_allowed,
-	.nmi_allowed = vmx_nmi_allowed,
-	.get_nmi_mask = vmx_get_nmi_mask,
-	.set_nmi_mask = vmx_set_nmi_mask,
-	.enable_nmi_window = vmx_enable_nmi_window,
-	.enable_irq_window = vmx_enable_irq_window,
-	.update_cr8_intercept = vmx_update_cr8_intercept,
-	.set_virtual_apic_mode = vmx_set_virtual_apic_mode,
-	.set_apic_access_page_addr = vmx_set_apic_access_page_addr,
-	.refresh_apicv_exec_ctrl = vmx_refresh_apicv_exec_ctrl,
-	.load_eoi_exitmap = vmx_load_eoi_exitmap,
-	.apicv_post_state_restore = vmx_apicv_post_state_restore,
-	.check_apicv_inhibit_reasons = vmx_check_apicv_inhibit_reasons,
-	.hwapic_irr_update = vmx_hwapic_irr_update,
-	.hwapic_isr_update = vmx_hwapic_isr_update,
-	.guest_apic_has_interrupt = vmx_guest_apic_has_interrupt,
-	.sync_pir_to_irr = vmx_sync_pir_to_irr,
-	.deliver_posted_interrupt = vmx_deliver_posted_interrupt,
-	.dy_apicv_has_pending_interrupt = pi_has_pending_interrupt,
-
-	.set_tss_addr = vmx_set_tss_addr,
-	.set_identity_map_addr = vmx_set_identity_map_addr,
-	.get_mt_mask = vmx_get_mt_mask,
-
-	.get_exit_info = vmx_get_exit_info,
-
-	.vcpu_after_set_cpuid = vmx_vcpu_after_set_cpuid,
-
-	.has_wbinvd_exit = cpu_has_vmx_wbinvd_exit,
-
-	.get_l2_tsc_offset = vmx_get_l2_tsc_offset,
-	.get_l2_tsc_multiplier = vmx_get_l2_tsc_multiplier,
-	.write_tsc_offset = vmx_write_tsc_offset,
-	.write_tsc_multiplier = vmx_write_tsc_multiplier,
-
-	.load_mmu_pgd = vmx_load_mmu_pgd,
-
-	.check_intercept = vmx_check_intercept,
-	.handle_exit_irqoff = vmx_handle_exit_irqoff,
-
-	.request_immediate_exit = vmx_request_immediate_exit,
-
-	.sched_in = vmx_sched_in,
-
-	.cpu_dirty_log_size = PML_ENTITY_NUM,
-	.update_cpu_dirty_logging = vmx_update_cpu_dirty_logging,
-
-	.pre_block = vmx_pre_block,
-	.post_block = vmx_post_block,
-
-	.pmu_ops = &intel_pmu_ops,
-	.nested_ops = &vmx_nested_ops,
-
-	.update_pi_irte = pi_update_irte,
-	.start_assignment = vmx_pi_start_assignment,
-
-#ifdef CONFIG_X86_64
-	.set_hv_timer = vmx_set_hv_timer,
-	.cancel_hv_timer = vmx_cancel_hv_timer,
-#endif
-
-	.setup_mce = vmx_setup_mce,
-
-	.smi_allowed = vmx_smi_allowed,
-	.enter_smm = vmx_enter_smm,
-	.leave_smm = vmx_leave_smm,
-	.enable_smi_window = vmx_enable_smi_window,
-
-	.can_emulate_instruction = vmx_can_emulate_instruction,
-	.apic_init_signal_blocked = vmx_apic_init_signal_blocked,
-	.migrate_timers = vmx_migrate_timers,
-
-	.msr_filter_changed = vmx_msr_filter_changed,
-	.complete_emulated_msr = kvm_complete_insn_gp,
-
-	.vcpu_deliver_sipi_vector = kvm_vcpu_deliver_sipi_vector,
-};
-
 static __init void vmx_setup_user_return_msrs(void)
 {
 
@@ -7612,7 +7449,7 @@ static __init void vmx_setup_user_return_msrs(void)
 		kvm_add_user_return_msr(vmx_uret_msrs_list[i]);
 }
 
-static __init int hardware_setup(void)
+__init int hardware_setup(void)
 {
 	unsigned long host_bndcfgs;
 	struct desc_ptr dt;
@@ -7672,16 +7509,16 @@ static __init int hardware_setup(void)
 	 * using the APIC_ACCESS_ADDR VMCS field.
 	 */
 	if (!flexpriority_enabled)
-		vmx_x86_ops.set_apic_access_page_addr = NULL;
+		vt_x86_ops.set_apic_access_page_addr = NULL;
 
 	if (!cpu_has_vmx_tpr_shadow())
-		vmx_x86_ops.update_cr8_intercept = NULL;
+		vt_x86_ops.update_cr8_intercept = NULL;
 
 #if IS_ENABLED(CONFIG_HYPERV)
 	if (ms_hyperv.nested_features & HV_X64_NESTED_GUEST_MAPPING_FLUSH
 	    && enable_ept) {
-		vmx_x86_ops.tlb_remote_flush = hv_remote_flush_tlb;
-		vmx_x86_ops.tlb_remote_flush_with_range =
+		vt_x86_ops.tlb_remote_flush = hv_remote_flush_tlb;
+		vt_x86_ops.tlb_remote_flush_with_range =
 				hv_remote_flush_tlb_with_range;
 	}
 #endif
@@ -7696,7 +7533,7 @@ static __init int hardware_setup(void)
 
 	if (!cpu_has_vmx_apicv()) {
 		enable_apicv = 0;
-		vmx_x86_ops.sync_pir_to_irr = NULL;
+		vt_x86_ops.sync_pir_to_irr = NULL;
 	}
 
 	if (cpu_has_vmx_tsc_scaling()) {
@@ -7732,7 +7569,7 @@ static __init int hardware_setup(void)
 		enable_pml = 0;
 
 	if (!enable_pml)
-		vmx_x86_ops.cpu_dirty_log_size = 0;
+		vt_x86_ops.cpu_dirty_log_size = 0;
 
 	if (!cpu_has_vmx_preemption_timer())
 		enable_preemption_timer = false;
@@ -7759,9 +7596,9 @@ static __init int hardware_setup(void)
 	}
 
 	if (!enable_preemption_timer) {
-		vmx_x86_ops.set_hv_timer = NULL;
-		vmx_x86_ops.cancel_hv_timer = NULL;
-		vmx_x86_ops.request_immediate_exit = __kvm_request_immediate_exit;
+		vt_x86_ops.set_hv_timer = NULL;
+		vt_x86_ops.cancel_hv_timer = NULL;
+		vt_x86_ops.request_immediate_exit = __kvm_request_immediate_exit;
 	}
 
 	kvm_mce_cap_supported |= MCG_LMCE_P;
@@ -7793,15 +7630,6 @@ static __init int hardware_setup(void)
 	return r;
 }
 
-static struct kvm_x86_init_ops vmx_init_ops __initdata = {
-	.cpu_has_kvm_support = cpu_has_kvm_support,
-	.disabled_by_bios = vmx_disabled_by_bios,
-	.check_processor_compatibility = vmx_check_processor_compat,
-	.hardware_setup = hardware_setup,
-
-	.runtime_ops = &vmx_x86_ops,
-};
-
 static void vmx_cleanup_l1d_flush(void)
 {
 	if (vmx_l1d_flush_pages) {
@@ -7812,47 +7640,12 @@ static void vmx_cleanup_l1d_flush(void)
 	l1tf_vmx_mitigation = VMENTER_L1D_FLUSH_AUTO;
 }
 
-static void vmx_exit(void)
+void __init vmx_pre_kvm_init(unsigned int *vcpu_size, unsigned int *vcpu_align)
 {
-#ifdef CONFIG_KEXEC_CORE
-	RCU_INIT_POINTER(crash_vmclear_loaded_vmcss, NULL);
-	synchronize_rcu();
-#endif
-
-	kvm_exit();
-
-#if IS_ENABLED(CONFIG_HYPERV)
-	if (static_branch_unlikely(&enable_evmcs)) {
-		int cpu;
-		struct hv_vp_assist_page *vp_ap;
-		/*
-		 * Reset everything to support using non-enlightened VMCS
-		 * access later (e.g. when we reload the module with
-		 * enlightened_vmcs=0)
-		 */
-		for_each_online_cpu(cpu) {
-			vp_ap =	hv_get_vp_assist_page(cpu);
-
-			if (!vp_ap)
-				continue;
-
-			vp_ap->nested_control.features.directhypercall = 0;
-			vp_ap->current_nested_vmcs = 0;
-			vp_ap->enlighten_vmentry = 0;
-		}
-
-		static_branch_disable(&enable_evmcs);
-	}
-#endif
-	vmx_cleanup_l1d_flush();
-
-	allow_smaller_maxphyaddr = false;
-}
-module_exit(vmx_exit);
-
-static int __init vmx_init(void)
-{
-	int r, cpu;
+	if (sizeof(struct vcpu_vmx) > *vcpu_size)
+		*vcpu_size = sizeof(struct vcpu_vmx);
+	if (__alignof__(struct vcpu_vmx) > *vcpu_align)
+		*vcpu_align = __alignof__(struct vcpu_vmx);
 
 #if IS_ENABLED(CONFIG_HYPERV)
 	/*
@@ -7880,18 +7673,45 @@ static int __init vmx_init(void)
 		}
 
 		if (ms_hyperv.nested_features & HV_X64_NESTED_DIRECT_FLUSH)
-			vmx_x86_ops.enable_direct_tlbflush
+			vt_x86_ops.enable_direct_tlbflush
 				= hv_enable_direct_tlbflush;
 
 	} else {
 		enlightened_vmcs = false;
 	}
 #endif
+}
 
-	r = kvm_init(&vmx_init_ops, sizeof(struct vcpu_vmx),
-		     __alignof__(struct vcpu_vmx), THIS_MODULE);
-	if (r)
-		return r;
+void vmx_post_kvm_exit(void)
+{
+#if IS_ENABLED(CONFIG_HYPERV)
+	if (static_branch_unlikely(&enable_evmcs)) {
+		int cpu;
+		struct hv_vp_assist_page *vp_ap;
+		/*
+		 * Reset everything to support using non-enlightened VMCS
+		 * access later (e.g. when we reload the module with
+		 * enlightened_vmcs=0)
+		 */
+		for_each_online_cpu(cpu) {
+			vp_ap =	hv_get_vp_assist_page(cpu);
+
+			if (!vp_ap)
+				continue;
+
+			vp_ap->nested_control.features.directhypercall = 0;
+			vp_ap->current_nested_vmcs = 0;
+			vp_ap->enlighten_vmentry = 0;
+		}
+
+		static_branch_disable(&enable_evmcs);
+	}
+#endif
+}
+
+int __init vmx_init(void)
+{
+	int r, cpu;
 
 	/*
 	 * Must be called after kvm_init() so enable_ept is properly set
@@ -7901,10 +7721,8 @@ static int __init vmx_init(void)
 	 * mitigation mode.
 	 */
 	r = vmx_setup_l1d_flush(vmentry_l1d_flush_param);
-	if (r) {
-		vmx_exit();
+	if (r)
 		return r;
-	}
 
 	for_each_possible_cpu(cpu) {
 		INIT_LIST_HEAD(&per_cpu(loaded_vmcss_on_cpu, cpu));
@@ -7928,4 +7746,15 @@ static int __init vmx_init(void)
 
 	return 0;
 }
-module_init(vmx_init);
+
+void vmx_exit(void)
+{
+#ifdef CONFIG_KEXEC_CORE
+	RCU_INIT_POINTER(crash_vmclear_loaded_vmcss, NULL);
+	synchronize_rcu();
+#endif
+
+	vmx_cleanup_l1d_flush();
+
+	allow_smaller_maxphyaddr = false;
+}
diff --git a/arch/x86/kvm/vmx/x86_ops.h b/arch/x86/kvm/vmx/x86_ops.h
new file mode 100644
index 000000000000..f04b30f1b72d
--- /dev/null
+++ b/arch/x86/kvm/vmx/x86_ops.h
@@ -0,0 +1,124 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+#ifndef __KVM_X86_VMX_X86_OPS_H
+#define __KVM_X86_VMX_X86_OPS_H
+
+#include <linux/kvm_host.h>
+
+#include <asm/virtext.h>
+
+#include "x86.h"
+
+extern struct kvm_x86_ops vt_x86_ops __initdata;
+
+__init int vmx_disabled_by_bios(void);
+int __init vmx_check_processor_compat(void);
+__init int hardware_setup(void);
+void hardware_unsetup(void);
+int hardware_enable(void);
+void hardware_disable(void);
+bool report_flexpriority(void);
+int vmx_vm_init(struct kvm *kvm);
+int vmx_create_vcpu(struct kvm_vcpu *vcpu);
+fastpath_t vmx_vcpu_run(struct kvm_vcpu *vcpu);
+void vmx_free_vcpu(struct kvm_vcpu *vcpu);
+void vmx_vcpu_reset(struct kvm_vcpu *vcpu, bool init_event);
+void vmx_vcpu_load(struct kvm_vcpu *vcpu, int cpu);
+void vmx_vcpu_put(struct kvm_vcpu *vcpu);
+int vmx_handle_exit(struct kvm_vcpu *vcpu, fastpath_t exit_fastpath);
+void vmx_handle_exit_irqoff(struct kvm_vcpu *vcpu);
+int vmx_skip_emulated_instruction(struct kvm_vcpu *vcpu);
+void vmx_update_emulated_instruction(struct kvm_vcpu *vcpu);
+int vmx_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info);
+int vmx_smi_allowed(struct kvm_vcpu *vcpu, bool for_injection);
+int vmx_enter_smm(struct kvm_vcpu *vcpu, char *smstate);
+int vmx_leave_smm(struct kvm_vcpu *vcpu, const char *smstate);
+void vmx_enable_smi_window(struct kvm_vcpu *vcpu);
+bool vmx_can_emulate_instruction(struct kvm_vcpu *vcpu, void *insn, int insn_len);
+int vmx_check_intercept(struct kvm_vcpu *vcpu,
+			struct x86_instruction_info *info,
+			enum x86_intercept_stage stage,
+			struct x86_exception *exception);
+bool vmx_apic_init_signal_blocked(struct kvm_vcpu *vcpu);
+void vmx_migrate_timers(struct kvm_vcpu *vcpu);
+void vmx_set_virtual_apic_mode(struct kvm_vcpu *vcpu);
+void vmx_apicv_post_state_restore(struct kvm_vcpu *vcpu);
+bool vmx_check_apicv_inhibit_reasons(ulong bit);
+void vmx_hwapic_irr_update(struct kvm_vcpu *vcpu, int max_irr);
+void vmx_hwapic_isr_update(struct kvm_vcpu *vcpu, int max_isr);
+bool vmx_guest_apic_has_interrupt(struct kvm_vcpu *vcpu);
+int vmx_sync_pir_to_irr(struct kvm_vcpu *vcpu);
+int vmx_deliver_posted_interrupt(struct kvm_vcpu *vcpu, int vector);
+void vmx_vcpu_after_set_cpuid(struct kvm_vcpu *vcpu);
+bool vmx_has_emulated_msr(struct kvm *kvm, u32 index);
+void vmx_msr_filter_changed(struct kvm_vcpu *vcpu);
+void vmx_prepare_switch_to_guest(struct kvm_vcpu *vcpu);
+void vmx_update_exception_bitmap(struct kvm_vcpu *vcpu);
+int vmx_get_msr_feature(struct kvm_msr_entry *msr);
+int vmx_get_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info);
+u64 vmx_get_segment_base(struct kvm_vcpu *vcpu, int seg);
+void vmx_get_segment(struct kvm_vcpu *vcpu, struct kvm_segment *var, int seg);
+void vmx_set_segment(struct kvm_vcpu *vcpu, struct kvm_segment *var, int seg);
+int vmx_get_cpl(struct kvm_vcpu *vcpu);
+void vmx_get_cs_db_l_bits(struct kvm_vcpu *vcpu, int *db, int *l);
+void vmx_set_cr0(struct kvm_vcpu *vcpu, unsigned long cr0);
+void vmx_load_mmu_pgd(struct kvm_vcpu *vcpu, hpa_t root_hpa, int root_level);
+void vmx_set_cr4(struct kvm_vcpu *vcpu, unsigned long cr4);
+bool vmx_is_valid_cr4(struct kvm_vcpu *vcpu, unsigned long cr4);
+int vmx_set_efer(struct kvm_vcpu *vcpu, u64 efer);
+void vmx_get_idt(struct kvm_vcpu *vcpu, struct desc_ptr *dt);
+void vmx_set_idt(struct kvm_vcpu *vcpu, struct desc_ptr *dt);
+void vmx_get_gdt(struct kvm_vcpu *vcpu, struct desc_ptr *dt);
+void vmx_set_gdt(struct kvm_vcpu *vcpu, struct desc_ptr *dt);
+void vmx_set_dr7(struct kvm_vcpu *vcpu, unsigned long val);
+void vmx_sync_dirty_debug_regs(struct kvm_vcpu *vcpu);
+void vmx_cache_reg(struct kvm_vcpu *vcpu, enum kvm_reg reg);
+unsigned long vmx_get_rflags(struct kvm_vcpu *vcpu);
+void vmx_set_rflags(struct kvm_vcpu *vcpu, unsigned long rflags);
+void vmx_flush_tlb_all(struct kvm_vcpu *vcpu);
+void vmx_flush_tlb_current(struct kvm_vcpu *vcpu);
+void vmx_flush_tlb_gva(struct kvm_vcpu *vcpu, gva_t addr);
+void vmx_flush_tlb_guest(struct kvm_vcpu *vcpu);
+void vmx_set_interrupt_shadow(struct kvm_vcpu *vcpu, int mask);
+u32 vmx_get_interrupt_shadow(struct kvm_vcpu *vcpu);
+void vmx_patch_hypercall(struct kvm_vcpu *vcpu, unsigned char *hypercall);
+void vmx_inject_irq(struct kvm_vcpu *vcpu);
+void vmx_inject_nmi(struct kvm_vcpu *vcpu);
+void vmx_queue_exception(struct kvm_vcpu *vcpu);
+void vmx_cancel_injection(struct kvm_vcpu *vcpu);
+int vmx_interrupt_allowed(struct kvm_vcpu *vcpu, bool for_injection);
+int vmx_nmi_allowed(struct kvm_vcpu *vcpu, bool for_injection);
+bool vmx_get_nmi_mask(struct kvm_vcpu *vcpu);
+void vmx_set_nmi_mask(struct kvm_vcpu *vcpu, bool masked);
+void vmx_enable_nmi_window(struct kvm_vcpu *vcpu);
+void vmx_enable_irq_window(struct kvm_vcpu *vcpu);
+void vmx_update_cr8_intercept(struct kvm_vcpu *vcpu, int tpr, int irr);
+void vmx_set_apic_access_page_addr(struct kvm_vcpu *vcpu);
+void vmx_refresh_apicv_exec_ctrl(struct kvm_vcpu *vcpu);
+void vmx_load_eoi_exitmap(struct kvm_vcpu *vcpu, u64 *eoi_exit_bitmap);
+int vmx_set_tss_addr(struct kvm *kvm, unsigned int addr);
+int vmx_set_identity_map_addr(struct kvm *kvm, u64 ident_addr);
+u64 vmx_get_mt_mask(struct kvm_vcpu *vcpu, gfn_t gfn, bool is_mmio);
+void vmx_get_exit_info(struct kvm_vcpu *vcpu, u32 *reason,
+		u64 *info1, u64 *info2, u32 *intr_info, u32 *error_code);
+u64 vmx_get_l2_tsc_offset(struct kvm_vcpu *vcpu);
+u64 vmx_get_l2_tsc_multiplier(struct kvm_vcpu *vcpu);
+void vmx_write_tsc_offset(struct kvm_vcpu *vcpu, u64 offset);
+void vmx_write_tsc_multiplier(struct kvm_vcpu *vcpu, u64 multiplier);
+void vmx_request_immediate_exit(struct kvm_vcpu *vcpu);
+void vmx_sched_in(struct kvm_vcpu *vcpu, int cpu);
+void vmx_update_cpu_dirty_logging(struct kvm_vcpu *vcpu);
+int vmx_pre_block(struct kvm_vcpu *vcpu);
+void vmx_post_block(struct kvm_vcpu *vcpu);
+#ifdef CONFIG_X86_64
+int vmx_set_hv_timer(struct kvm_vcpu *vcpu, u64 guest_deadline_tsc,
+		bool *expired);
+void vmx_cancel_hv_timer(struct kvm_vcpu *vcpu);
+#endif
+void vmx_setup_mce(struct kvm_vcpu *vcpu);
+
+void __init vmx_pre_kvm_init(unsigned int *vcpu_size, unsigned int *vcpu_align);
+int __init vmx_init(void);
+void vmx_exit(void);
+void vmx_post_kvm_exit(void);
+
+#endif /* __KVM_X86_VMX_X86_OPS_H */
-- 
2.25.1

