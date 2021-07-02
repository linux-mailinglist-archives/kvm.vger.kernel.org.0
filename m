Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 83E363BA58F
	for <lists+kvm@lfdr.de>; Sat,  3 Jul 2021 00:06:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233921AbhGBWIl (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 2 Jul 2021 18:08:41 -0400
Received: from mga17.intel.com ([192.55.52.151]:15277 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233372AbhGBWIJ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 2 Jul 2021 18:08:09 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10033"; a="189168388"
X-IronPort-AV: E=Sophos;i="5.83,320,1616482800"; 
   d="scan'208";a="189168388"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Jul 2021 15:05:30 -0700
X-IronPort-AV: E=Sophos;i="5.83,320,1616482800"; 
   d="scan'208";a="642814863"
Received: from ls.sc.intel.com (HELO localhost) ([143.183.96.54])
  by fmsmga006-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Jul 2021 15:05:30 -0700
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
        Sean Christopherson <seanjc@google.com>, x86@kernel.org,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     isaku.yamahata@intel.com, isaku.yamahata@gmail.com,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        kernel test robot <lkp@intel.com>,
        Xiaoyao Li <xiaoyao.li@intel.com>
Subject: [RFC PATCH v2 55/69] KVM: VMX: Add 'main.c' to wrap VMX and TDX
Date:   Fri,  2 Jul 2021 15:05:01 -0700
Message-Id: <52e7bb9f6bd27dc56880d81e232270679ffee601.1625186503.git.isaku.yamahata@intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1625186503.git.isaku.yamahata@intel.com>
References: <cover.1625186503.git.isaku.yamahata@intel.com>
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
 arch/x86/kvm/Makefile   |   2 +-
 arch/x86/kvm/vmx/main.c | 710 ++++++++++++++++++++++++++++++++++++++++
 arch/x86/kvm/vmx/vmx.c  | 283 ++++------------
 3 files changed, 768 insertions(+), 227 deletions(-)
 create mode 100644 arch/x86/kvm/vmx/main.c

diff --git a/arch/x86/kvm/Makefile b/arch/x86/kvm/Makefile
index 60f3e90fef8b..3c3815bd0f56 100644
--- a/arch/x86/kvm/Makefile
+++ b/arch/x86/kvm/Makefile
@@ -21,7 +21,7 @@ kvm-y			+= x86.o emulate.o i8259.o irq.o lapic.o \
 kvm-$(CONFIG_X86_64) += mmu/tdp_iter.o mmu/tdp_mmu.o
 kvm-$(CONFIG_KVM_XEN)	+= xen.o
 
-kvm-intel-y		+= vmx/vmx.o vmx/vmenter.o vmx/pmu_intel.o vmx/vmcs12.o \
+kvm-intel-y		+= vmx/main.o vmx/vmenter.o vmx/pmu_intel.o vmx/vmcs12.o \
 			   vmx/evmcs.o vmx/nested.o vmx/posted_intr.o
 kvm-intel-$(CONFIG_X86_SGX_KVM)	+= vmx/sgx.o
 kvm-intel-$(CONFIG_KVM_INTEL_TDX)	+= vmx/seamcall.o
diff --git a/arch/x86/kvm/vmx/main.c b/arch/x86/kvm/vmx/main.c
new file mode 100644
index 000000000000..c3fefa0e5a63
--- /dev/null
+++ b/arch/x86/kvm/vmx/main.c
@@ -0,0 +1,710 @@
+// SPDX-License-Identifier: GPL-2.0
+#include <linux/moduleparam.h>
+
+static struct kvm_x86_ops vt_x86_ops __initdata;
+
+#include "vmx.c"
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
+static void vt_vm_teardown(struct kvm *kvm)
+{
+
+}
+
+static void vt_vm_destroy(struct kvm *kvm)
+{
+
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
+static int vt_pre_enter_smm(struct kvm_vcpu *vcpu, char *smstate)
+{
+	return vmx_pre_enter_smm(vcpu, smstate);
+}
+
+static int vt_pre_leave_smm(struct kvm_vcpu *vcpu, const char *smstate)
+{
+	return vmx_pre_leave_smm(vcpu, smstate);
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
+static void vt_get_exit_info(struct kvm_vcpu *vcpu, u64 *info1, u64 *info2,
+			     u32 *intr_info, u32 *error_code)
+{
+
+	return vmx_get_exit_info(vcpu, info1, info2, intr_info, error_code);
+}
+
+static u64 vt_write_l1_tsc_offset(struct kvm_vcpu *vcpu, u64 offset)
+{
+	return vmx_write_l1_tsc_offset(vcpu, offset);
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
+static struct kvm_x86_ops vt_x86_ops __initdata = {
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
+	.vm_teardown = vt_vm_teardown,
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
+	.write_l1_tsc_offset = vt_write_l1_tsc_offset,
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
+	.pre_enter_smm = vt_pre_enter_smm,
+	.pre_leave_smm = vt_pre_leave_smm,
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
index 8a104a54121b..77b2b2cf76db 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -2366,11 +2366,6 @@ static void vmx_cache_reg(struct kvm_vcpu *vcpu, enum kvm_reg reg)
 	}
 }
 
-static __init int cpu_has_kvm_support(void)
-{
-	return cpu_has_vmx();
-}
-
 static __init int vmx_disabled_by_bios(void)
 {
 	return !boot_cpu_has(X86_FEATURE_MSR_IA32_FEAT_CTL) ||
@@ -6891,11 +6886,6 @@ static int vmx_create_vcpu(struct kvm_vcpu *vcpu)
 	return err;
 }
 
-static bool vmx_is_vm_type_supported(unsigned long type)
-{
-	return type == KVM_X86_LEGACY_VM;
-}
-
 #define L1TF_MSG_SMT "L1TF CPU bug present and SMT on, data leak possible. See CVE-2018-3646 and https://www.kernel.org/doc/html/latest/admin-guide/hw-vuln/l1tf.html for details.\n"
 #define L1TF_MSG_L1D "L1TF CPU bug present and virtualization mitigation disabled, data leak possible. See CVE-2018-3646 and https://www.kernel.org/doc/html/latest/admin-guide/hw-vuln/l1tf.html for details.\n"
 
@@ -6935,16 +6925,6 @@ static int vmx_vm_init(struct kvm *kvm)
 	return 0;
 }
 
-static void vmx_vm_teardown(struct kvm *kvm)
-{
-
-}
-
-static void vmx_vm_destroy(struct kvm *kvm)
-{
-
-}
-
 static int __init vmx_check_processor_compat(void)
 {
 	struct vmcs_config vmcs_conf;
@@ -7447,9 +7427,6 @@ void vmx_update_cpu_dirty_logging(struct kvm_vcpu *vcpu)
 
 static int vmx_pre_block(struct kvm_vcpu *vcpu)
 {
-	if (pi_pre_block(vcpu))
-		return 1;
-
 	if (kvm_lapic_hv_timer_in_use(vcpu))
 		kvm_lapic_switch_to_sw_timer(vcpu);
 
@@ -7460,8 +7437,6 @@ static void vmx_post_block(struct kvm_vcpu *vcpu)
 {
 	if (kvm_x86_ops.set_hv_timer)
 		kvm_lapic_switch_to_hv_timer(vcpu);
-
-	pi_post_block(vcpu);
 }
 
 static void vmx_setup_mce(struct kvm_vcpu *vcpu)
@@ -7552,142 +7527,6 @@ static bool vmx_check_apicv_inhibit_reasons(ulong bit)
 	return supported & BIT(bit);
 }
 
-static struct kvm_x86_ops vmx_x86_ops __initdata = {
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
-	.vm_teardown = vmx_vm_teardown,
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
-	.write_l1_tsc_offset = vmx_write_l1_tsc_offset,
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
-	.pre_enter_smm = vmx_pre_enter_smm,
-	.pre_leave_smm = vmx_pre_leave_smm,
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
 
@@ -7768,16 +7607,16 @@ static __init int hardware_setup(void)
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
@@ -7792,7 +7631,7 @@ static __init int hardware_setup(void)
 
 	if (!cpu_has_vmx_apicv()) {
 		enable_apicv = 0;
-		vmx_x86_ops.sync_pir_to_irr = NULL;
+		vt_x86_ops.sync_pir_to_irr = NULL;
 	}
 
 	if (cpu_has_vmx_tsc_scaling()) {
@@ -7827,7 +7666,7 @@ static __init int hardware_setup(void)
 		enable_pml = 0;
 
 	if (!enable_pml)
-		vmx_x86_ops.cpu_dirty_log_size = 0;
+		vt_x86_ops.cpu_dirty_log_size = 0;
 
 	if (!cpu_has_vmx_preemption_timer())
 		enable_preemption_timer = false;
@@ -7854,9 +7693,9 @@ static __init int hardware_setup(void)
 	}
 
 	if (!enable_preemption_timer) {
-		vmx_x86_ops.set_hv_timer = NULL;
-		vmx_x86_ops.cancel_hv_timer = NULL;
-		vmx_x86_ops.request_immediate_exit = __kvm_request_immediate_exit;
+		vt_x86_ops.set_hv_timer = NULL;
+		vt_x86_ops.cancel_hv_timer = NULL;
+		vt_x86_ops.request_immediate_exit = __kvm_request_immediate_exit;
 	}
 
 	kvm_set_posted_intr_wakeup_handler(pi_wakeup_handler);
@@ -7887,15 +7726,6 @@ static __init int hardware_setup(void)
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
@@ -7906,45 +7736,13 @@ static void vmx_cleanup_l1d_flush(void)
 	l1tf_vmx_mitigation = VMENTER_L1D_FLUSH_AUTO;
 }
 
-static void vmx_exit(void)
-{
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
-}
-module_exit(vmx_exit);
-
-static int __init vmx_init(void)
+static void __init vmx_pre_kvm_init(unsigned int *vcpu_size,
+				    unsigned int *vcpu_align)
 {
-	int r, cpu;
+	if (sizeof(struct vcpu_vmx) > *vcpu_size)
+		*vcpu_size = sizeof(struct vcpu_vmx);
+	if (__alignof__(struct vcpu_vmx) > *vcpu_align)
+		*vcpu_align = __alignof__(struct vcpu_vmx);
 
 #if IS_ENABLED(CONFIG_HYPERV)
 	/*
@@ -7972,18 +7770,45 @@ static int __init vmx_init(void)
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
+static void vmx_post_kvm_exit(void)
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
+static int __init vmx_init(void)
+{
+	int r, cpu;
 
 	/*
 	 * Must be called after kvm_init() so enable_ept is properly set
@@ -7993,10 +7818,8 @@ static int __init vmx_init(void)
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
@@ -8020,4 +7843,12 @@ static int __init vmx_init(void)
 
 	return 0;
 }
-module_init(vmx_init);
+
+static void vmx_exit(void)
+{
+#ifdef CONFIG_KEXEC_CORE
+	RCU_INIT_POINTER(crash_vmclear_loaded_vmcss, NULL);
+	synchronize_rcu();
+#endif
+	vmx_cleanup_l1d_flush();
+}
-- 
2.25.1

