Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C8F974BCA4A
	for <lists+kvm@lfdr.de>; Sat, 19 Feb 2022 19:52:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242977AbiBSSuy (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 19 Feb 2022 13:50:54 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:45494 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243001AbiBSSuS (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 19 Feb 2022 13:50:18 -0500
Received: from mga06.intel.com (mga06.intel.com [134.134.136.31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9D3B070043;
        Sat, 19 Feb 2022 10:49:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1645296596; x=1676832596;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=oFf+X/erSNcVTNiegG4nLpE0tBBHfWJ1c3O1NvBLU94=;
  b=f7B8pwmiSP/qdMg+bolifMgdgqhVDluATTfPHlgyQXapPmMRQa42JMvy
   abr8C4GiwxTZMt8/t9xUCLf4r/KNhzZlVH+h1BaeYcD6XVLfUpyRuNVtV
   M8gLzE0UmmdjengPa9Q2oYiG1nPtg9rUc/IGZYsZPlpf3IRg6qprCkt3G
   APn8o2CH3dCfcHOgtPxHCZnjzcesGd9+t402MaJxQiJumgJcVFiS/6blS
   MM0KhFua1JhuK+gAY8neKwdqRxXG4ATQWGFsDfzsKzHTVJmmLLltHM5JX
   x13vi8N9h3KlLYrzfuOaTJi1JSo8AQpTdV3V/aehu8iqlHE24GQOTgGCm
   g==;
X-IronPort-AV: E=McAfee;i="6200,9189,10263"; a="312058993"
X-IronPort-AV: E=Sophos;i="5.88,381,1635231600"; 
   d="scan'208";a="312058993"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Feb 2022 10:49:54 -0800
X-IronPort-AV: E=Sophos;i="5.88,381,1635231600"; 
   d="scan'208";a="507137023"
Received: from ls.sc.intel.com (HELO localhost) ([143.183.96.54])
  by orsmga006-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Feb 2022 10:49:54 -0800
From:   isaku.yamahata@intel.com
To:     Thomas Gleixner <tglx@linutronix.de>,
        Borislav Petkov <bp@alien8.de>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Jim Mattson <jmattson@google.com>, erdemaktas@google.com,
        Connor Kuehl <ckuehl@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     isaku.yamahata@intel.com, isaku.yamahata@gmail.com
Subject: [PATCH v4 1/8] KVM: VMX: Move out vmx_x86_ops to 'main.c' to wrap VMX and TDX
Date:   Sat, 19 Feb 2022 10:49:46 -0800
Message-Id: <a2b9ed19d9f7bda70050ebbeb0a57bd4dbd6865a.1645266955.git.isaku.yamahata@intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1645266955.git.isaku.yamahata@intel.com>
References: <cover.1645266955.git.isaku.yamahata@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Sean Christopherson <sean.j.christopherson@intel.com>

KVM accesses Virtual Machine Control Structure (VMCS) with VMX instructions
to operate on VM.  TDX defines its data structure and TDX SEAMCALL APIs for
VMM to operate on Trust Domain (TD) instead.

Trust Domain Virtual Processor State (TDVPS) is the root control structure
of a TD VCPU.  It helps the TDX module control the operation of the VCPU,
and holds the VCPU state while the VCPU is not running. TDVPS is opaque to
software and DMA access, accessible only by using the TDX module interface
functions (such as TDH.VP.RD, TDH.VP.WR ,..).  TDVPS includes TD VMCS, and
TD VMCS auxiliary structures, such as virtual APIC page, virtualization
exception information, etc.  TDVPS is composed of Trust Domain Virtual
Processor Root (TDVPR) which is the root page of TDVPS and Trust Domain
Virtual Processor eXtension (TDVPX) pages which extend TDVPR to help
provide enough physical space for the logical TDVPS structure.

Also, we have a new structure, Trust Domain Control Structure (TDCS) is the
main control structure of a guest TD, and encrypted (using the guest TD's
ephemeral private key).  At a high level, TDCS holds information for
controlling TD operation as a whole, execution, EPTP, MSR bitmaps, etc. KVM
needs to set it up.  Note that MSR bitmaps are held as part of TDCS (unlike
VMX) because they are meant to have the same value for all VCPUs of the
same TD.  TDCS is a multi-page logical structure composed of multiple Trust
Domain Control Extension (TDCX) physical pages.  Trust Domain Root (TDR) is
the root control structure of a guest TD and is encrypted using the TDX
global private key. It holds a minimal set of state variables that enable
guest TD control even during times when the TD's private key is not known,
or when the TD's key management state does not permit access to memory
encrypted using the TD's private key.

The following shows the relationship between those structures.

        TDR--> TDCS                     per-TD
         |       \--> TDCX
         \
          \--> TDVPS                    per-TD VCPU
                 \--> TDVPR and TDVPX

The existing global struct kvm_x86_ops already defines an interface which
fits with TDX.  But kvm_x86_ops is system-wide, not per-VM structure.  To
allow VMX to coexist with TDs, the kvm_x86_ops callbacks will have wrappers
"if (tdx) tdx_op() else vmx_op()" to switch VMX or TDX at run time.

To split the runtime switch, the VMX implementation, and the TDX
implementation, add main.c, and move out the vmx_x86_ops hooks in
preparation for adding TDX, which can coexist with VMX, i.e. KVM can run
both VMs and TDs.  Use 'vt' for the naming scheme as a nod to VT-x and as a
concatenation of VmxTdx.

The current code looks as follows.
In vmx.c
  static vmx_op() { ... }
  static struct kvm_x86_ops vmx_x86_ops = {
        .op = vmx_op,
  initialization code

The eventually converted code will look like
In vmx.c, keep the VMX operations.
  vmx_op() { ... }
  VMX initialization
In tdx.c, define the TDX operations.
  tdx_op() { ... }
  TDX initialization
In x86_ops.h, declare the VMX and TDX operations.
  vmx_op();
  tdx_op();
In main.c, define common wrappers for VMX and VMX.
  static vt_ops() { if (tdx) tdx_ops() else vmx_ops() }
  static struct kvm_x86_ops vt_x86_ops = {
        .op = vt_op,
  initialization to call VMX and TDX initialization

Opportunistically, fix the name inconsistency from vmx_create_vcpu() and
vmx_free_vcpu() to vmx_vcpu_create() and vxm_vcpu_free().

Co-developed-by: Xiaoyao Li <xiaoyao.li@intel.com>
Signed-off-by: Xiaoyao Li <xiaoyao.li@intel.com>
Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
---
 arch/x86/kvm/Makefile      |   2 +-
 arch/x86/kvm/vmx/main.c    | 154 ++++++++++++++++
 arch/x86/kvm/vmx/vmx.c     | 360 +++++++++++--------------------------
 arch/x86/kvm/vmx/x86_ops.h | 126 +++++++++++++
 4 files changed, 385 insertions(+), 257 deletions(-)
 create mode 100644 arch/x86/kvm/vmx/main.c
 create mode 100644 arch/x86/kvm/vmx/x86_ops.h

diff --git a/arch/x86/kvm/Makefile b/arch/x86/kvm/Makefile
index 30f244b64523..ee4d0999f20f 100644
--- a/arch/x86/kvm/Makefile
+++ b/arch/x86/kvm/Makefile
@@ -22,7 +22,7 @@ kvm-$(CONFIG_X86_64) += mmu/tdp_iter.o mmu/tdp_mmu.o
 kvm-$(CONFIG_KVM_XEN)	+= xen.o
 
 kvm-intel-y		+= vmx/vmx.o vmx/vmenter.o vmx/pmu_intel.o vmx/vmcs12.o \
-			   vmx/evmcs.o vmx/nested.o vmx/posted_intr.o
+			   vmx/evmcs.o vmx/nested.o vmx/posted_intr.o vmx/main.o
 kvm-intel-$(CONFIG_X86_SGX_KVM)	+= vmx/sgx.o
 
 kvm-amd-y		+= svm/svm.o svm/vmenter.o svm/pmu.o svm/nested.o svm/avic.o svm/sev.o
diff --git a/arch/x86/kvm/vmx/main.c b/arch/x86/kvm/vmx/main.c
new file mode 100644
index 000000000000..b08ea9c42a11
--- /dev/null
+++ b/arch/x86/kvm/vmx/main.c
@@ -0,0 +1,154 @@
+// SPDX-License-Identifier: GPL-2.0
+#include <linux/moduleparam.h>
+
+#include "x86_ops.h"
+#include "vmx.h"
+#include "nested.h"
+#include "pmu.h"
+
+struct kvm_x86_ops vt_x86_ops __initdata = {
+	.name = "kvm_intel",
+
+	.hardware_unsetup = vmx_hardware_unsetup,
+
+	.hardware_enable = vmx_hardware_enable,
+	.hardware_disable = vmx_hardware_disable,
+	.cpu_has_accelerated_tpr = report_flexpriority,
+	.has_emulated_msr = vmx_has_emulated_msr,
+
+	.vm_size = sizeof(struct kvm_vmx),
+	.vm_init = vmx_vm_init,
+
+	.vcpu_create = vmx_vcpu_create,
+	.vcpu_free = vmx_vcpu_free,
+	.vcpu_reset = vmx_vcpu_reset,
+
+	.prepare_guest_switch = vmx_prepare_switch_to_guest,
+	.vcpu_load = vmx_vcpu_load,
+	.vcpu_put = vmx_vcpu_put,
+
+	.update_exception_bitmap = vmx_update_exception_bitmap,
+	.get_msr_feature = vmx_get_msr_feature,
+	.get_msr = vmx_get_msr,
+	.set_msr = vmx_set_msr,
+	.get_segment_base = vmx_get_segment_base,
+	.get_segment = vmx_get_segment,
+	.set_segment = vmx_set_segment,
+	.get_cpl = vmx_get_cpl,
+	.get_cs_db_l_bits = vmx_get_cs_db_l_bits,
+	.set_cr0 = vmx_set_cr0,
+	.is_valid_cr4 = vmx_is_valid_cr4,
+	.set_cr4 = vmx_set_cr4,
+	.set_efer = vmx_set_efer,
+	.get_idt = vmx_get_idt,
+	.set_idt = vmx_set_idt,
+	.get_gdt = vmx_get_gdt,
+	.set_gdt = vmx_set_gdt,
+	.set_dr7 = vmx_set_dr7,
+	.sync_dirty_debug_regs = vmx_sync_dirty_debug_regs,
+	.cache_reg = vmx_cache_reg,
+	.get_rflags = vmx_get_rflags,
+	.set_rflags = vmx_set_rflags,
+	.get_if_flag = vmx_get_if_flag,
+
+	.tlb_flush_all = vmx_flush_tlb_all,
+	.tlb_flush_current = vmx_flush_tlb_current,
+	.tlb_flush_gva = vmx_flush_tlb_gva,
+	.tlb_flush_guest = vmx_flush_tlb_guest,
+
+	.vcpu_pre_run = vmx_vcpu_pre_run,
+	.run = vmx_vcpu_run,
+	.handle_exit = vmx_handle_exit,
+	.skip_emulated_instruction = vmx_skip_emulated_instruction,
+	.update_emulated_instruction = vmx_update_emulated_instruction,
+	.set_interrupt_shadow = vmx_set_interrupt_shadow,
+	.get_interrupt_shadow = vmx_get_interrupt_shadow,
+	.patch_hypercall = vmx_patch_hypercall,
+	.set_irq = vmx_inject_irq,
+	.set_nmi = vmx_inject_nmi,
+	.queue_exception = vmx_queue_exception,
+	.cancel_injection = vmx_cancel_injection,
+	.interrupt_allowed = vmx_interrupt_allowed,
+	.nmi_allowed = vmx_nmi_allowed,
+	.get_nmi_mask = vmx_get_nmi_mask,
+	.set_nmi_mask = vmx_set_nmi_mask,
+	.enable_nmi_window = vmx_enable_nmi_window,
+	.enable_irq_window = vmx_enable_irq_window,
+	.update_cr8_intercept = vmx_update_cr8_intercept,
+	.set_virtual_apic_mode = vmx_set_virtual_apic_mode,
+	.set_apic_access_page_addr = vmx_set_apic_access_page_addr,
+	.refresh_apicv_exec_ctrl = vmx_refresh_apicv_exec_ctrl,
+	.load_eoi_exitmap = vmx_load_eoi_exitmap,
+	.apicv_post_state_restore = vmx_apicv_post_state_restore,
+	.check_apicv_inhibit_reasons = vmx_check_apicv_inhibit_reasons,
+	.hwapic_irr_update = vmx_hwapic_irr_update,
+	.hwapic_isr_update = vmx_hwapic_isr_update,
+	.guest_apic_has_interrupt = vmx_guest_apic_has_interrupt,
+	.sync_pir_to_irr = vmx_sync_pir_to_irr,
+	.deliver_interrupt = vmx_deliver_interrupt,
+	.dy_apicv_has_pending_interrupt = pi_has_pending_interrupt,
+
+	.set_tss_addr = vmx_set_tss_addr,
+	.set_identity_map_addr = vmx_set_identity_map_addr,
+	.get_mt_mask = vmx_get_mt_mask,
+
+	.get_exit_info = vmx_get_exit_info,
+
+	.vcpu_after_set_cpuid = vmx_vcpu_after_set_cpuid,
+
+	.has_wbinvd_exit = cpu_has_vmx_wbinvd_exit,
+
+	.get_l2_tsc_offset = vmx_get_l2_tsc_offset,
+	.get_l2_tsc_multiplier = vmx_get_l2_tsc_multiplier,
+	.write_tsc_offset = vmx_write_tsc_offset,
+	.write_tsc_multiplier = vmx_write_tsc_multiplier,
+
+	.load_mmu_pgd = vmx_load_mmu_pgd,
+
+	.check_intercept = vmx_check_intercept,
+	.handle_exit_irqoff = vmx_handle_exit_irqoff,
+
+	.request_immediate_exit = vmx_request_immediate_exit,
+
+	.sched_in = vmx_sched_in,
+
+	.cpu_dirty_log_size = PML_ENTITY_NUM,
+	.update_cpu_dirty_logging = vmx_update_cpu_dirty_logging,
+
+	.pmu_ops = &intel_pmu_ops,
+	.nested_ops = &vmx_nested_ops,
+
+	.update_pi_irte = pi_update_irte,
+	.start_assignment = vmx_pi_start_assignment,
+
+#ifdef CONFIG_X86_64
+	.set_hv_timer = vmx_set_hv_timer,
+	.cancel_hv_timer = vmx_cancel_hv_timer,
+#endif
+
+	.setup_mce = vmx_setup_mce,
+
+	.smi_allowed = vmx_smi_allowed,
+	.enter_smm = vmx_enter_smm,
+	.leave_smm = vmx_leave_smm,
+	.enable_smi_window = vmx_enable_smi_window,
+
+	.can_emulate_instruction = vmx_can_emulate_instruction,
+	.apic_init_signal_blocked = vmx_apic_init_signal_blocked,
+	.migrate_timers = vmx_migrate_timers,
+
+	.msr_filter_changed = vmx_msr_filter_changed,
+	.complete_emulated_msr = kvm_complete_insn_gp,
+
+	.vcpu_deliver_sipi_vector = kvm_vcpu_deliver_sipi_vector,
+};
+
+struct kvm_x86_init_ops vt_init_ops __initdata = {
+	.cpu_has_kvm_support = vmx_cpu_has_kvm_support,
+	.disabled_by_bios = vmx_disabled_by_bios,
+	.check_processor_compatibility = vmx_check_processor_compat,
+	.hardware_setup = vmx_hardware_setup,
+	.handle_intel_pt_intr = NULL,
+
+	.runtime_ops = &vt_x86_ops,
+};
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 6c27bd0c89e1..cbbb398231c1 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -66,6 +66,7 @@
 #include "vmcs12.h"
 #include "vmx.h"
 #include "x86.h"
+#include "x86_ops.h"
 
 MODULE_AUTHOR("Qumranet");
 MODULE_LICENSE("GPL");
@@ -541,7 +542,7 @@ static inline bool cpu_need_virtualize_apic_accesses(struct kvm_vcpu *vcpu)
 	return flexpriority_enabled && lapic_in_kernel(vcpu);
 }
 
-static inline bool report_flexpriority(void)
+bool report_flexpriority(void)
 {
 	return flexpriority_enabled;
 }
@@ -1316,7 +1317,7 @@ void vmx_vcpu_load_vmcs(struct kvm_vcpu *vcpu, int cpu,
  * Switches to specified vcpu, until a matching vcpu_put(), but assumes
  * vcpu mutex is already taken.
  */
-static void vmx_vcpu_load(struct kvm_vcpu *vcpu, int cpu)
+void vmx_vcpu_load(struct kvm_vcpu *vcpu, int cpu)
 {
 	struct vcpu_vmx *vmx = to_vmx(vcpu);
 
@@ -1327,7 +1328,7 @@ static void vmx_vcpu_load(struct kvm_vcpu *vcpu, int cpu)
 	vmx->host_debugctlmsr = get_debugctlmsr();
 }
 
-static void vmx_vcpu_put(struct kvm_vcpu *vcpu)
+void vmx_vcpu_put(struct kvm_vcpu *vcpu)
 {
 	vmx_vcpu_pi_put(vcpu);
 
@@ -1381,7 +1382,7 @@ void vmx_set_rflags(struct kvm_vcpu *vcpu, unsigned long rflags)
 		vmx->emulation_required = vmx_emulation_required(vcpu);
 }
 
-static bool vmx_get_if_flag(struct kvm_vcpu *vcpu)
+bool vmx_get_if_flag(struct kvm_vcpu *vcpu)
 {
 	return vmx_get_rflags(vcpu) & X86_EFLAGS_IF;
 }
@@ -1487,8 +1488,8 @@ static int vmx_rtit_ctl_check(struct kvm_vcpu *vcpu, u64 data)
 	return 0;
 }
 
-static bool vmx_can_emulate_instruction(struct kvm_vcpu *vcpu, int emul_type,
-					void *insn, int insn_len)
+bool vmx_can_emulate_instruction(struct kvm_vcpu *vcpu, int emul_type,
+				void *insn, int insn_len)
 {
 	/*
 	 * Emulation of instructions in SGX enclaves is impossible as RIP does
@@ -1572,7 +1573,7 @@ static int skip_emulated_instruction(struct kvm_vcpu *vcpu)
  * Recognizes a pending MTF VM-exit and records the nested state for later
  * delivery.
  */
-static void vmx_update_emulated_instruction(struct kvm_vcpu *vcpu)
+void vmx_update_emulated_instruction(struct kvm_vcpu *vcpu)
 {
 	struct vmcs12 *vmcs12 = get_vmcs12(vcpu);
 	struct vcpu_vmx *vmx = to_vmx(vcpu);
@@ -1595,7 +1596,7 @@ static void vmx_update_emulated_instruction(struct kvm_vcpu *vcpu)
 		vmx->nested.mtf_pending = false;
 }
 
-static int vmx_skip_emulated_instruction(struct kvm_vcpu *vcpu)
+int vmx_skip_emulated_instruction(struct kvm_vcpu *vcpu)
 {
 	vmx_update_emulated_instruction(vcpu);
 	return skip_emulated_instruction(vcpu);
@@ -1614,7 +1615,7 @@ static void vmx_clear_hlt(struct kvm_vcpu *vcpu)
 		vmcs_write32(GUEST_ACTIVITY_STATE, GUEST_ACTIVITY_ACTIVE);
 }
 
-static void vmx_queue_exception(struct kvm_vcpu *vcpu)
+void vmx_queue_exception(struct kvm_vcpu *vcpu)
 {
 	struct vcpu_vmx *vmx = to_vmx(vcpu);
 	unsigned nr = vcpu->arch.exception.nr;
@@ -1727,12 +1728,12 @@ u64 vmx_get_l2_tsc_multiplier(struct kvm_vcpu *vcpu)
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
@@ -1756,7 +1757,7 @@ static inline bool vmx_feature_control_msr_valid(struct kvm_vcpu *vcpu,
 	return !(val & ~valid_bits);
 }
 
-static int vmx_get_msr_feature(struct kvm_msr_entry *msr)
+int vmx_get_msr_feature(struct kvm_msr_entry *msr)
 {
 	switch (msr->index) {
 	case MSR_IA32_VMX_BASIC ... MSR_IA32_VMX_VMFUNC:
@@ -1776,7 +1777,7 @@ static int vmx_get_msr_feature(struct kvm_msr_entry *msr)
  * Returns 0 on success, non-0 otherwise.
  * Assumes vcpu_load() was already called.
  */
-static int vmx_get_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
+int vmx_get_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 {
 	struct vcpu_vmx *vmx = to_vmx(vcpu);
 	struct vmx_uret_msr *msr;
@@ -1954,7 +1955,7 @@ static u64 vcpu_supported_debugctl(struct kvm_vcpu *vcpu)
  * Returns 0 on success, non-0 otherwise.
  * Assumes vcpu_load() was already called.
  */
-static int vmx_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
+int vmx_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 {
 	struct vcpu_vmx *vmx = to_vmx(vcpu);
 	struct vmx_uret_msr *msr;
@@ -2267,7 +2268,7 @@ static int vmx_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 	return ret;
 }
 
-static void vmx_cache_reg(struct kvm_vcpu *vcpu, enum kvm_reg reg)
+void vmx_cache_reg(struct kvm_vcpu *vcpu, enum kvm_reg reg)
 {
 	unsigned long guest_owned_bits;
 
@@ -2310,12 +2311,12 @@ static void vmx_cache_reg(struct kvm_vcpu *vcpu, enum kvm_reg reg)
 	}
 }
 
-static __init int cpu_has_kvm_support(void)
+__init int vmx_cpu_has_kvm_support(void)
 {
 	return cpu_has_vmx();
 }
 
-static __init int vmx_disabled_by_bios(void)
+__init int vmx_disabled_by_bios(void)
 {
 	return !boot_cpu_has(X86_FEATURE_MSR_IA32_FEAT_CTL) ||
 	       !boot_cpu_has(X86_FEATURE_VMX);
@@ -2341,7 +2342,7 @@ static int kvm_cpu_vmxon(u64 vmxon_pointer)
 	return -EFAULT;
 }
 
-static int hardware_enable(void)
+int vmx_hardware_enable(void)
 {
 	int cpu = raw_smp_processor_id();
 	u64 phys_addr = __pa(per_cpu(vmxarea, cpu));
@@ -2382,7 +2383,7 @@ static void vmclear_local_loaded_vmcss(void)
 		__loaded_vmcs_clear(v);
 }
 
-static void hardware_disable(void)
+void vmx_hardware_disable(void)
 {
 	vmclear_local_loaded_vmcss();
 
@@ -2924,7 +2925,7 @@ static void exit_lmode(struct kvm_vcpu *vcpu)
 
 #endif
 
-static void vmx_flush_tlb_all(struct kvm_vcpu *vcpu)
+void vmx_flush_tlb_all(struct kvm_vcpu *vcpu)
 {
 	struct vcpu_vmx *vmx = to_vmx(vcpu);
 
@@ -2954,7 +2955,7 @@ static inline int vmx_get_current_vpid(struct kvm_vcpu *vcpu)
 	return to_vmx(vcpu)->vpid;
 }
 
-static void vmx_flush_tlb_current(struct kvm_vcpu *vcpu)
+void vmx_flush_tlb_current(struct kvm_vcpu *vcpu)
 {
 	struct kvm_mmu *mmu = vcpu->arch.mmu;
 	u64 root_hpa = mmu->root_hpa;
@@ -2970,7 +2971,7 @@ static void vmx_flush_tlb_current(struct kvm_vcpu *vcpu)
 		vpid_sync_context(vmx_get_current_vpid(vcpu));
 }
 
-static void vmx_flush_tlb_gva(struct kvm_vcpu *vcpu, gva_t addr)
+void vmx_flush_tlb_gva(struct kvm_vcpu *vcpu, gva_t addr)
 {
 	/*
 	 * vpid_sync_vcpu_addr() is a nop if vpid==0, see the comment in
@@ -2979,7 +2980,7 @@ static void vmx_flush_tlb_gva(struct kvm_vcpu *vcpu, gva_t addr)
 	vpid_sync_vcpu_addr(vmx_get_current_vpid(vcpu), addr);
 }
 
-static void vmx_flush_tlb_guest(struct kvm_vcpu *vcpu)
+void vmx_flush_tlb_guest(struct kvm_vcpu *vcpu)
 {
 	/*
 	 * vpid_sync_context() is a nop if vpid==0, e.g. if enable_vpid==0 or a
@@ -3134,8 +3135,7 @@ u64 construct_eptp(struct kvm_vcpu *vcpu, hpa_t root_hpa, int root_level)
 	return eptp;
 }
 
-static void vmx_load_mmu_pgd(struct kvm_vcpu *vcpu, hpa_t root_hpa,
-			     int root_level)
+void vmx_load_mmu_pgd(struct kvm_vcpu *vcpu, hpa_t root_hpa, int root_level)
 {
 	struct kvm *kvm = vcpu->kvm;
 	bool update_guest_cr3 = true;
@@ -3163,8 +3163,7 @@ static void vmx_load_mmu_pgd(struct kvm_vcpu *vcpu, hpa_t root_hpa,
 		vmcs_writel(GUEST_CR3, guest_cr3);
 }
 
-
-static bool vmx_is_valid_cr4(struct kvm_vcpu *vcpu, unsigned long cr4)
+bool vmx_is_valid_cr4(struct kvm_vcpu *vcpu, unsigned long cr4)
 {
 	/*
 	 * We operate under the default treatment of SMM, so VMX cannot be
@@ -3280,7 +3279,7 @@ void vmx_get_segment(struct kvm_vcpu *vcpu, struct kvm_segment *var, int seg)
 	var->g = (ar >> 15) & 1;
 }
 
-static u64 vmx_get_segment_base(struct kvm_vcpu *vcpu, int seg)
+u64 vmx_get_segment_base(struct kvm_vcpu *vcpu, int seg)
 {
 	struct kvm_segment s;
 
@@ -3360,14 +3359,14 @@ void __vmx_set_segment(struct kvm_vcpu *vcpu, struct kvm_segment *var, int seg)
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
 
@@ -3375,25 +3374,25 @@ static void vmx_get_cs_db_l_bits(struct kvm_vcpu *vcpu, int *db, int *l)
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
@@ -3889,7 +3888,7 @@ void pt_update_intercept_for_msr(struct kvm_vcpu *vcpu)
 	}
 }
 
-static bool vmx_guest_apic_has_interrupt(struct kvm_vcpu *vcpu)
+bool vmx_guest_apic_has_interrupt(struct kvm_vcpu *vcpu)
 {
 	struct vcpu_vmx *vmx = to_vmx(vcpu);
 	void *vapic_page;
@@ -3909,7 +3908,7 @@ static bool vmx_guest_apic_has_interrupt(struct kvm_vcpu *vcpu)
 	return ((rvi & 0xf0) > (vppr & 0xf0));
 }
 
-static void vmx_msr_filter_changed(struct kvm_vcpu *vcpu)
+void vmx_msr_filter_changed(struct kvm_vcpu *vcpu)
 {
 	struct vcpu_vmx *vmx = to_vmx(vcpu);
 	u32 i;
@@ -4041,8 +4040,8 @@ static int vmx_deliver_posted_interrupt(struct kvm_vcpu *vcpu, int vector)
 	return 0;
 }
 
-static void vmx_deliver_interrupt(struct kvm_lapic *apic, int delivery_mode,
-				  int trig_mode, int vector)
+void vmx_deliver_interrupt(struct kvm_lapic *apic, int delivery_mode,
+			   int trig_mode, int vector)
 {
 	struct kvm_vcpu *vcpu = apic->vcpu;
 
@@ -4185,7 +4184,7 @@ static u32 vmx_vmexit_ctrl(void)
 		~(VM_EXIT_LOAD_IA32_PERF_GLOBAL_CTRL | VM_EXIT_LOAD_IA32_EFER);
 }
 
-static void vmx_refresh_apicv_exec_ctrl(struct kvm_vcpu *vcpu)
+void vmx_refresh_apicv_exec_ctrl(struct kvm_vcpu *vcpu)
 {
 	struct vcpu_vmx *vmx = to_vmx(vcpu);
 
@@ -4508,7 +4507,7 @@ static void __vmx_vcpu_reset(struct kvm_vcpu *vcpu)
 	vmx->pi_desc.sn = 1;
 }
 
-static void vmx_vcpu_reset(struct kvm_vcpu *vcpu, bool init_event)
+void vmx_vcpu_reset(struct kvm_vcpu *vcpu, bool init_event)
 {
 	struct vcpu_vmx *vmx = to_vmx(vcpu);
 
@@ -4565,12 +4564,12 @@ static void vmx_vcpu_reset(struct kvm_vcpu *vcpu, bool init_event)
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
@@ -4581,7 +4580,7 @@ static void vmx_enable_nmi_window(struct kvm_vcpu *vcpu)
 	exec_controls_setbit(to_vmx(vcpu), CPU_BASED_NMI_WINDOW_EXITING);
 }
 
-static void vmx_inject_irq(struct kvm_vcpu *vcpu)
+void vmx_inject_irq(struct kvm_vcpu *vcpu)
 {
 	struct vcpu_vmx *vmx = to_vmx(vcpu);
 	uint32_t intr;
@@ -4609,7 +4608,7 @@ static void vmx_inject_irq(struct kvm_vcpu *vcpu)
 	vmx_clear_hlt(vcpu);
 }
 
-static void vmx_inject_nmi(struct kvm_vcpu *vcpu)
+void vmx_inject_nmi(struct kvm_vcpu *vcpu)
 {
 	struct vcpu_vmx *vmx = to_vmx(vcpu);
 
@@ -4687,7 +4686,7 @@ bool vmx_nmi_blocked(struct kvm_vcpu *vcpu)
 		 GUEST_INTR_STATE_NMI));
 }
 
-static int vmx_nmi_allowed(struct kvm_vcpu *vcpu, bool for_injection)
+int vmx_nmi_allowed(struct kvm_vcpu *vcpu, bool for_injection)
 {
 	if (to_vmx(vcpu)->nested.nested_run_pending)
 		return -EBUSY;
@@ -4709,7 +4708,7 @@ bool vmx_interrupt_blocked(struct kvm_vcpu *vcpu)
 		(GUEST_INTR_STATE_STI | GUEST_INTR_STATE_MOV_SS));
 }
 
-static int vmx_interrupt_allowed(struct kvm_vcpu *vcpu, bool for_injection)
+int vmx_interrupt_allowed(struct kvm_vcpu *vcpu, bool for_injection)
 {
 	if (to_vmx(vcpu)->nested.nested_run_pending)
 		return -EBUSY;
@@ -4724,7 +4723,7 @@ static int vmx_interrupt_allowed(struct kvm_vcpu *vcpu, bool for_injection)
 	return !vmx_interrupt_blocked(vcpu);
 }
 
-static int vmx_set_tss_addr(struct kvm *kvm, unsigned int addr)
+int vmx_set_tss_addr(struct kvm *kvm, unsigned int addr)
 {
 	void __user *ret;
 
@@ -4744,7 +4743,7 @@ static int vmx_set_tss_addr(struct kvm *kvm, unsigned int addr)
 	return init_rmode_tss(kvm, ret);
 }
 
-static int vmx_set_identity_map_addr(struct kvm *kvm, u64 ident_addr)
+int vmx_set_identity_map_addr(struct kvm *kvm, u64 ident_addr)
 {
 	to_kvm_vmx(kvm)->ept_identity_map_addr = ident_addr;
 	return 0;
@@ -5023,8 +5022,7 @@ static int handle_io(struct kvm_vcpu *vcpu)
 	return kvm_fast_pio(vcpu, size, port, in);
 }
 
-static void
-vmx_patch_hypercall(struct kvm_vcpu *vcpu, unsigned char *hypercall)
+void vmx_patch_hypercall(struct kvm_vcpu *vcpu, unsigned char *hypercall)
 {
 	/*
 	 * Patch in the VMCALL instruction:
@@ -5234,7 +5232,7 @@ static int handle_dr(struct kvm_vcpu *vcpu)
 	return kvm_complete_insn_gp(vcpu, err);
 }
 
-static void vmx_sync_dirty_debug_regs(struct kvm_vcpu *vcpu)
+void vmx_sync_dirty_debug_regs(struct kvm_vcpu *vcpu)
 {
 	get_debugreg(vcpu->arch.db[0], 0);
 	get_debugreg(vcpu->arch.db[1], 1);
@@ -5253,7 +5251,7 @@ static void vmx_sync_dirty_debug_regs(struct kvm_vcpu *vcpu)
 	set_debugreg(DR6_RESERVED, 6);
 }
 
-static void vmx_set_dr7(struct kvm_vcpu *vcpu, unsigned long val)
+void vmx_set_dr7(struct kvm_vcpu *vcpu, unsigned long val)
 {
 	vmcs_writel(GUEST_DR7, val);
 }
@@ -5519,7 +5517,7 @@ static int handle_invalid_guest_state(struct kvm_vcpu *vcpu)
 	return 1;
 }
 
-static int vmx_vcpu_pre_run(struct kvm_vcpu *vcpu)
+int vmx_vcpu_pre_run(struct kvm_vcpu *vcpu)
 {
 	if (vmx_emulation_required_with_pending_exception(vcpu)) {
 		kvm_prepare_emulation_failure_exit(vcpu);
@@ -5756,9 +5754,8 @@ static int (*kvm_vmx_exit_handlers[])(struct kvm_vcpu *vcpu) = {
 static const int kvm_vmx_max_exit_handlers =
 	ARRAY_SIZE(kvm_vmx_exit_handlers);
 
-static void vmx_get_exit_info(struct kvm_vcpu *vcpu, u32 *reason,
-			      u64 *info1, u64 *info2,
-			      u32 *intr_info, u32 *error_code)
+void vmx_get_exit_info(struct kvm_vcpu *vcpu, u32 *reason,
+		u64 *info1, u64 *info2, u32 *intr_info, u32 *error_code)
 {
 	struct vcpu_vmx *vmx = to_vmx(vcpu);
 
@@ -6191,7 +6188,7 @@ static int __vmx_handle_exit(struct kvm_vcpu *vcpu, fastpath_t exit_fastpath)
 	return 0;
 }
 
-static int vmx_handle_exit(struct kvm_vcpu *vcpu, fastpath_t exit_fastpath)
+int vmx_handle_exit(struct kvm_vcpu *vcpu, fastpath_t exit_fastpath)
 {
 	int ret = __vmx_handle_exit(vcpu, exit_fastpath);
 
@@ -6279,7 +6276,7 @@ static noinstr void vmx_l1d_flush(struct kvm_vcpu *vcpu)
 		: "eax", "ebx", "ecx", "edx");
 }
 
-static void vmx_update_cr8_intercept(struct kvm_vcpu *vcpu, int tpr, int irr)
+void vmx_update_cr8_intercept(struct kvm_vcpu *vcpu, int tpr, int irr)
 {
 	struct vmcs12 *vmcs12 = get_vmcs12(vcpu);
 	int tpr_threshold;
@@ -6349,7 +6346,7 @@ void vmx_set_virtual_apic_mode(struct kvm_vcpu *vcpu)
 	vmx_update_msr_bitmap_x2apic(vcpu);
 }
 
-static void vmx_set_apic_access_page_addr(struct kvm_vcpu *vcpu)
+void vmx_set_apic_access_page_addr(struct kvm_vcpu *vcpu)
 {
 	struct page *page;
 
@@ -6377,7 +6374,7 @@ static void vmx_set_apic_access_page_addr(struct kvm_vcpu *vcpu)
 	put_page(page);
 }
 
-static void vmx_hwapic_isr_update(struct kvm_vcpu *vcpu, int max_isr)
+void vmx_hwapic_isr_update(struct kvm_vcpu *vcpu, int max_isr)
 {
 	u16 status;
 	u8 old;
@@ -6411,7 +6408,7 @@ static void vmx_set_rvi(int vector)
 	}
 }
 
-static void vmx_hwapic_irr_update(struct kvm_vcpu *vcpu, int max_irr)
+void vmx_hwapic_irr_update(struct kvm_vcpu *vcpu, int max_irr)
 {
 	/*
 	 * When running L2, updating RVI is only relevant when
@@ -6425,7 +6422,7 @@ static void vmx_hwapic_irr_update(struct kvm_vcpu *vcpu, int max_irr)
 		vmx_set_rvi(max_irr);
 }
 
-static int vmx_sync_pir_to_irr(struct kvm_vcpu *vcpu)
+int vmx_sync_pir_to_irr(struct kvm_vcpu *vcpu)
 {
 	struct vcpu_vmx *vmx = to_vmx(vcpu);
 	int max_irr;
@@ -6471,7 +6468,7 @@ static int vmx_sync_pir_to_irr(struct kvm_vcpu *vcpu)
 	return max_irr;
 }
 
-static void vmx_load_eoi_exitmap(struct kvm_vcpu *vcpu, u64 *eoi_exit_bitmap)
+void vmx_load_eoi_exitmap(struct kvm_vcpu *vcpu, u64 *eoi_exit_bitmap)
 {
 	if (!kvm_vcpu_apicv_active(vcpu))
 		return;
@@ -6482,7 +6479,7 @@ static void vmx_load_eoi_exitmap(struct kvm_vcpu *vcpu, u64 *eoi_exit_bitmap)
 	vmcs_write64(EOI_EXIT_BITMAP3, eoi_exit_bitmap[3]);
 }
 
-static void vmx_apicv_post_state_restore(struct kvm_vcpu *vcpu)
+void vmx_apicv_post_state_restore(struct kvm_vcpu *vcpu)
 {
 	struct vcpu_vmx *vmx = to_vmx(vcpu);
 
@@ -6554,7 +6551,7 @@ static void handle_external_interrupt_irqoff(struct kvm_vcpu *vcpu)
 	handle_interrupt_nmi_irqoff(vcpu, gate_offset(desc));
 }
 
-static void vmx_handle_exit_irqoff(struct kvm_vcpu *vcpu)
+void vmx_handle_exit_irqoff(struct kvm_vcpu *vcpu)
 {
 	struct vcpu_vmx *vmx = to_vmx(vcpu);
 
@@ -6571,7 +6568,7 @@ static void vmx_handle_exit_irqoff(struct kvm_vcpu *vcpu)
  * The kvm parameter can be NULL (module initialization, or invocation before
  * VM creation). Be sure to check the kvm parameter before using it.
  */
-static bool vmx_has_emulated_msr(struct kvm *kvm, u32 index)
+bool vmx_has_emulated_msr(struct kvm *kvm, u32 index)
 {
 	switch (index) {
 	case MSR_IA32_SMBASE:
@@ -6692,7 +6689,7 @@ static void vmx_complete_interrupts(struct vcpu_vmx *vmx)
 				  IDT_VECTORING_ERROR_CODE);
 }
 
-static void vmx_cancel_injection(struct kvm_vcpu *vcpu)
+void vmx_cancel_injection(struct kvm_vcpu *vcpu)
 {
 	__vmx_complete_interrupts(vcpu,
 				  vmcs_read32(VM_ENTRY_INTR_INFO_FIELD),
@@ -6788,7 +6785,7 @@ static noinstr void vmx_vcpu_enter_exit(struct kvm_vcpu *vcpu,
 	guest_state_exit_irqoff();
 }
 
-static fastpath_t vmx_vcpu_run(struct kvm_vcpu *vcpu)
+fastpath_t vmx_vcpu_run(struct kvm_vcpu *vcpu)
 {
 	struct vcpu_vmx *vmx = to_vmx(vcpu);
 	unsigned long cr4;
@@ -6969,7 +6966,7 @@ static fastpath_t vmx_vcpu_run(struct kvm_vcpu *vcpu)
 	return vmx_exit_handlers_fastpath(vcpu);
 }
 
-static void vmx_free_vcpu(struct kvm_vcpu *vcpu)
+void vmx_vcpu_free(struct kvm_vcpu *vcpu)
 {
 	struct vcpu_vmx *vmx = to_vmx(vcpu);
 
@@ -6980,7 +6977,7 @@ static void vmx_free_vcpu(struct kvm_vcpu *vcpu)
 	free_loaded_vmcs(vmx->loaded_vmcs);
 }
 
-static int vmx_create_vcpu(struct kvm_vcpu *vcpu)
+int vmx_vcpu_create(struct kvm_vcpu *vcpu)
 {
 	struct vmx_uret_msr *tsx_ctrl;
 	struct vcpu_vmx *vmx;
@@ -7085,7 +7082,7 @@ static int vmx_create_vcpu(struct kvm_vcpu *vcpu)
 #define L1TF_MSG_SMT "L1TF CPU bug present and SMT on, data leak possible. See CVE-2018-3646 and https://www.kernel.org/doc/html/latest/admin-guide/hw-vuln/l1tf.html for details.\n"
 #define L1TF_MSG_L1D "L1TF CPU bug present and virtualization mitigation disabled, data leak possible. See CVE-2018-3646 and https://www.kernel.org/doc/html/latest/admin-guide/hw-vuln/l1tf.html for details.\n"
 
-static int vmx_vm_init(struct kvm *kvm)
+int vmx_vm_init(struct kvm *kvm)
 {
 	if (!ple_gap)
 		kvm->arch.pause_in_guest = true;
@@ -7116,7 +7113,7 @@ static int vmx_vm_init(struct kvm *kvm)
 	return 0;
 }
 
-static int __init vmx_check_processor_compat(void)
+int __init vmx_check_processor_compat(void)
 {
 	struct vmcs_config vmcs_conf;
 	struct vmx_capability vmx_cap;
@@ -7139,7 +7136,7 @@ static int __init vmx_check_processor_compat(void)
 	return 0;
 }
 
-static u64 vmx_get_mt_mask(struct kvm_vcpu *vcpu, gfn_t gfn, bool is_mmio)
+u64 vmx_get_mt_mask(struct kvm_vcpu *vcpu, gfn_t gfn, bool is_mmio)
 {
 	u8 cache;
 
@@ -7328,7 +7325,7 @@ static void update_intel_pt_cfg(struct kvm_vcpu *vcpu)
 		vmx->pt_desc.ctl_bitmask &= ~(0xfULL << (32 + i * 4));
 }
 
-static void vmx_vcpu_after_set_cpuid(struct kvm_vcpu *vcpu)
+void vmx_vcpu_after_set_cpuid(struct kvm_vcpu *vcpu)
 {
 	struct vcpu_vmx *vmx = to_vmx(vcpu);
 
@@ -7433,7 +7430,7 @@ static __init void vmx_set_cpu_caps(void)
 		kvm_cpu_cap_check_and_set(X86_FEATURE_WAITPKG);
 }
 
-static void vmx_request_immediate_exit(struct kvm_vcpu *vcpu)
+void vmx_request_immediate_exit(struct kvm_vcpu *vcpu)
 {
 	to_vmx(vcpu)->req_immediate_exit = true;
 }
@@ -7472,10 +7469,10 @@ static int vmx_check_intercept_io(struct kvm_vcpu *vcpu,
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
 
@@ -7540,8 +7537,8 @@ static inline int u64_shl_div_u64(u64 a, unsigned int shift,
 	return 0;
 }
 
-static int vmx_set_hv_timer(struct kvm_vcpu *vcpu, u64 guest_deadline_tsc,
-			    bool *expired)
+int vmx_set_hv_timer(struct kvm_vcpu *vcpu, u64 guest_deadline_tsc,
+		bool *expired)
 {
 	struct vcpu_vmx *vmx;
 	u64 tscl, guest_tscl, delta_tsc, lapic_timer_advance_cycles;
@@ -7580,13 +7577,13 @@ static int vmx_set_hv_timer(struct kvm_vcpu *vcpu, u64 guest_deadline_tsc,
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
@@ -7612,7 +7609,7 @@ void vmx_update_cpu_dirty_logging(struct kvm_vcpu *vcpu)
 		secondary_exec_controls_clearbit(vmx, SECONDARY_EXEC_ENABLE_PML);
 }
 
-static void vmx_setup_mce(struct kvm_vcpu *vcpu)
+void vmx_setup_mce(struct kvm_vcpu *vcpu)
 {
 	if (vcpu->arch.mcg_cap & MCG_LMCE_P)
 		to_vmx(vcpu)->msr_ia32_feature_control_valid_bits |=
@@ -7622,7 +7619,7 @@ static void vmx_setup_mce(struct kvm_vcpu *vcpu)
 			~FEAT_CTL_LMCE_ENABLED;
 }
 
-static int vmx_smi_allowed(struct kvm_vcpu *vcpu, bool for_injection)
+int vmx_smi_allowed(struct kvm_vcpu *vcpu, bool for_injection)
 {
 	/* we need a nested vmexit to enter SMM, postpone if run is pending */
 	if (to_vmx(vcpu)->nested.nested_run_pending)
@@ -7630,7 +7627,7 @@ static int vmx_smi_allowed(struct kvm_vcpu *vcpu, bool for_injection)
 	return !is_smm(vcpu);
 }
 
-static int vmx_enter_smm(struct kvm_vcpu *vcpu, char *smstate)
+int vmx_enter_smm(struct kvm_vcpu *vcpu, char *smstate)
 {
 	struct vcpu_vmx *vmx = to_vmx(vcpu);
 
@@ -7644,7 +7641,7 @@ static int vmx_enter_smm(struct kvm_vcpu *vcpu, char *smstate)
 	return 0;
 }
 
-static int vmx_leave_smm(struct kvm_vcpu *vcpu, const char *smstate)
+int vmx_leave_smm(struct kvm_vcpu *vcpu, const char *smstate)
 {
 	struct vcpu_vmx *vmx = to_vmx(vcpu);
 	int ret;
@@ -7664,17 +7661,17 @@ static int vmx_leave_smm(struct kvm_vcpu *vcpu, const char *smstate)
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
@@ -7684,7 +7681,7 @@ static void vmx_migrate_timers(struct kvm_vcpu *vcpu)
 	}
 }
 
-static void hardware_unsetup(void)
+void vmx_hardware_unsetup(void)
 {
 	kvm_set_posted_intr_wakeup_handler(NULL);
 
@@ -7694,7 +7691,7 @@ static void hardware_unsetup(void)
 	free_kvm_area();
 }
 
-static bool vmx_check_apicv_inhibit_reasons(ulong bit)
+bool vmx_check_apicv_inhibit_reasons(ulong bit)
 {
 	ulong supported = BIT(APICV_INHIBIT_REASON_DISABLE) |
 			  BIT(APICV_INHIBIT_REASON_ABSENT) |
@@ -7704,143 +7701,6 @@ static bool vmx_check_apicv_inhibit_reasons(ulong bit)
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
-	.vm_size = sizeof(struct kvm_vmx),
-	.vm_init = vmx_vm_init,
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
-	.get_if_flag = vmx_get_if_flag,
-
-	.tlb_flush_all = vmx_flush_tlb_all,
-	.tlb_flush_current = vmx_flush_tlb_current,
-	.tlb_flush_gva = vmx_flush_tlb_gva,
-	.tlb_flush_guest = vmx_flush_tlb_guest,
-
-	.vcpu_pre_run = vmx_vcpu_pre_run,
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
-	.deliver_interrupt = vmx_deliver_interrupt,
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
 static unsigned int vmx_handle_intel_pt_intr(void)
 {
 	struct kvm_vcpu *vcpu = kvm_get_running_vcpu();
@@ -7881,9 +7741,7 @@ static __init void vmx_setup_user_return_msrs(void)
 		kvm_add_user_return_msr(vmx_uret_msrs_list[i]);
 }
 
-static struct kvm_x86_init_ops vmx_init_ops __initdata;
-
-static __init int hardware_setup(void)
+__init int vmx_hardware_setup(void)
 {
 	unsigned long host_bndcfgs;
 	struct desc_ptr dt;
@@ -7943,16 +7801,16 @@ static __init int hardware_setup(void)
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
@@ -7968,7 +7826,7 @@ static __init int hardware_setup(void)
 	if (!cpu_has_vmx_apicv())
 		enable_apicv = 0;
 	if (!enable_apicv)
-		vmx_x86_ops.sync_pir_to_irr = NULL;
+		vt_x86_ops.sync_pir_to_irr = NULL;
 
 	if (cpu_has_vmx_tsc_scaling()) {
 		kvm_has_tsc_control = true;
@@ -7995,7 +7853,7 @@ static __init int hardware_setup(void)
 		enable_pml = 0;
 
 	if (!enable_pml)
-		vmx_x86_ops.cpu_dirty_log_size = 0;
+		vt_x86_ops.cpu_dirty_log_size = 0;
 
 	if (!cpu_has_vmx_preemption_timer())
 		enable_preemption_timer = false;
@@ -8022,9 +7880,9 @@ static __init int hardware_setup(void)
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
@@ -8034,9 +7892,9 @@ static __init int hardware_setup(void)
 	if (!enable_ept || !cpu_has_vmx_intel_pt())
 		pt_mode = PT_MODE_SYSTEM;
 	if (pt_mode == PT_MODE_HOST_GUEST)
-		vmx_init_ops.handle_intel_pt_intr = vmx_handle_intel_pt_intr;
+		vt_init_ops.handle_intel_pt_intr = vmx_handle_intel_pt_intr;
 	else
-		vmx_init_ops.handle_intel_pt_intr = NULL;
+		vt_init_ops.handle_intel_pt_intr = NULL;
 
 	setup_default_sgx_lepubkeyhash();
 
@@ -8060,16 +7918,6 @@ static __init int hardware_setup(void)
 	return r;
 }
 
-static struct kvm_x86_init_ops vmx_init_ops __initdata = {
-	.cpu_has_kvm_support = cpu_has_kvm_support,
-	.disabled_by_bios = vmx_disabled_by_bios,
-	.check_processor_compatibility = vmx_check_processor_compat,
-	.hardware_setup = hardware_setup,
-	.handle_intel_pt_intr = NULL,
-
-	.runtime_ops = &vmx_x86_ops,
-};
-
 static void vmx_cleanup_l1d_flush(void)
 {
 	if (vmx_l1d_flush_pages) {
@@ -8148,7 +7996,7 @@ static int __init vmx_init(void)
 		}
 
 		if (ms_hyperv.nested_features & HV_X64_NESTED_DIRECT_FLUSH)
-			vmx_x86_ops.enable_direct_tlbflush
+			vt_x86_ops.enable_direct_tlbflush
 				= hv_enable_direct_tlbflush;
 
 	} else {
@@ -8156,8 +8004,8 @@ static int __init vmx_init(void)
 	}
 #endif
 
-	r = kvm_init(&vmx_init_ops, sizeof(struct vcpu_vmx),
-		     __alignof__(struct vcpu_vmx), THIS_MODULE);
+	r = kvm_init(&vt_init_ops, sizeof(struct vcpu_vmx),
+		__alignof__(struct vcpu_vmx), THIS_MODULE);
 	if (r)
 		return r;
 
diff --git a/arch/x86/kvm/vmx/x86_ops.h b/arch/x86/kvm/vmx/x86_ops.h
new file mode 100644
index 000000000000..40c64fb1f505
--- /dev/null
+++ b/arch/x86/kvm/vmx/x86_ops.h
@@ -0,0 +1,126 @@
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
+extern struct kvm_x86_init_ops vt_init_ops __initdata;
+
+__init int vmx_cpu_has_kvm_support(void);
+__init int vmx_disabled_by_bios(void);
+int __init vmx_check_processor_compat(void);
+__init int vmx_hardware_setup(void);
+
+extern struct kvm_x86_ops vt_x86_ops __initdata;
+extern struct kvm_x86_init_ops vt_init_ops __initdata;
+
+void vmx_hardware_unsetup(void);
+int vmx_hardware_enable(void);
+void vmx_hardware_disable(void);
+bool report_flexpriority(void);
+int vmx_vm_init(struct kvm *kvm);
+int vmx_vcpu_create(struct kvm_vcpu *vcpu);
+int vmx_vcpu_pre_run(struct kvm_vcpu *vcpu);
+fastpath_t vmx_vcpu_run(struct kvm_vcpu *vcpu);
+void vmx_vcpu_free(struct kvm_vcpu *vcpu);
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
+bool vmx_can_emulate_instruction(struct kvm_vcpu *vcpu, int emul_type,
+				void *insn, int insn_len);
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
+void vmx_deliver_interrupt(struct kvm_lapic *apic, int delivery_mode,
+			   int trig_mode, int vector);
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
+bool vmx_get_if_flag(struct kvm_vcpu *vcpu);
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
+#ifdef CONFIG_X86_64
+int vmx_set_hv_timer(struct kvm_vcpu *vcpu, u64 guest_deadline_tsc,
+		bool *expired);
+void vmx_cancel_hv_timer(struct kvm_vcpu *vcpu);
+#endif
+void vmx_setup_mce(struct kvm_vcpu *vcpu);
+
+#endif /* __KVM_X86_VMX_X86_OPS_H */
-- 
2.25.1

