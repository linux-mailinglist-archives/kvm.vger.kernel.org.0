Return-Path: <kvm+bounces-10168-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 881A186A38B
	for <lists+kvm@lfdr.de>; Wed, 28 Feb 2024 00:25:45 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id E0C4D1F2309D
	for <lists+kvm@lfdr.de>; Tue, 27 Feb 2024 23:25:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 707845D730;
	Tue, 27 Feb 2024 23:21:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="C8ajYfqY"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A089A57335
	for <kvm@vger.kernel.org>; Tue, 27 Feb 2024 23:21:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709076074; cv=none; b=XCfVEbBD8ZtsuYsnvXV7r9yuXl06tqry6azSV/XPyk0/rJ0ALBKHL8auPTKlxdlGM976n2eW5MldFGYGrDSR0+wH+5HR+SUuTBh/WHFfY4vwj0T4nsx0mIh1l5KJXYEZTjd93Rzb30R+aTHG0XpgDDweEYO9xOnyFtfVgeyEQZ8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709076074; c=relaxed/simple;
	bh=aaEnFkLQinUtCRY1WGE7mKtoNrRc+95EehpWyzGN7UI=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=XHGFosxtKlJs+SS2w827YQ0f5Nkcgd86pfSd75wJHveeOdgHet9HokXeDbDg2EivwxjVqAJCVigUIm+EKAL7e5f1ZcDDcwn6m4LCssPZInFl4csQxj/loPsRFVaofKuBl0bDxKbz2YDFPFIqXf5BHYzR+mYxnMgK/cUi8gqqUCA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=C8ajYfqY; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1709076067;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=83MISKg1C2BlWDbPqACk58IbpkzcpeStUq9IdpmW0So=;
	b=C8ajYfqYiCNqNXrDSF22HLE0tbRG6ds1qjBnF/f+sNOvl8Dl51sgrKQ4ERWvoGPjR13smv
	I5AFD4xp5cD+Kk7hBJZ2LqlbuJ7c2qgZ/XOaN21IvMBXmTXU15FAGK/dvbThO8tZW0h3Rm
	HVcLeswpzmLYnL55qExWqrVjQd/Ol4c=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-65-O8d86IxrMOavMlDPeqLjGg-1; Tue, 27 Feb 2024 18:21:03 -0500
X-MC-Unique: O8d86IxrMOavMlDPeqLjGg-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com [10.11.54.5])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id BEC2285A58E;
	Tue, 27 Feb 2024 23:21:02 +0000 (UTC)
Received: from virtlab511.virt.lab.eng.bos.redhat.com (virtlab511.virt.lab.eng.bos.redhat.com [10.19.152.198])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 809E263A6D;
	Tue, 27 Feb 2024 23:21:02 +0000 (UTC)
From: Paolo Bonzini <pbonzini@redhat.com>
To: linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org
Cc: seanjc@google.com,
	michael.roth@amd.com,
	isaku.yamahata@intel.com,
	thomas.lendacky@amd.com,
	Xiaoyao Li <xiaoyao.li@intel.com>,
	Binbin Wu <binbin.wu@linux.intel.com>,
	Yuan Yao <yuan.yao@intel.com>
Subject: [PATCH 08/21] KVM: VMX: Move out vmx_x86_ops to 'main.c' to dispatch VMX and TDX
Date: Tue, 27 Feb 2024 18:20:47 -0500
Message-Id: <20240227232100.478238-9-pbonzini@redhat.com>
In-Reply-To: <20240227232100.478238-1-pbonzini@redhat.com>
References: <20240227232100.478238-1-pbonzini@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.5

From: Sean Christopherson <seanjc@google.com>

KVM accesses Virtual Machine Control Structure (VMCS) with VMX instructions
to operate on VM.  TDX doesn't allow VMM to operate VMCS directly.
Instead, TDX has its own data structures, and TDX SEAMCALL APIs for VMM to
indirectly operate those data structures.  This means we must have a TDX
version of kvm_x86_ops.

The existing global struct kvm_x86_ops already defines an interface which
can be adapted to TDX, but kvm_x86_ops is a system-wide, not per-VM
structure.  To allow VMX to coexist with TDs, the kvm_x86_ops callbacks
will have wrappers "if (tdx) tdx_op() else vmx_op()" to pick VMX or
TDX at run time.

To split the runtime switch, the VMX implementation, and the TDX
implementation, add main.c, and move out the vmx_x86_ops hooks in
preparation for adding TDX.  Use 'vt' for the naming scheme as a nod to
VT-x and as a concatenation of VmxTdx.

The eventually converted code will look like this:

vmx.c:
  vmx_op() { ... }
  VMX initialization
tdx.c:
  tdx_op() { ... }
  TDX initialization
x86_ops.h:
  vmx_op();
  tdx_op();
main.c:
  static vt_op() { if (tdx) tdx_op() else vmx_op() }
  static struct kvm_x86_ops vt_x86_ops = {
        .op = vt_op,
  initialization functions call both VMX and TDX initialization

Opportunistically, fix the name inconsistency from vmx_create_vcpu() and
vmx_free_vcpu() to vmx_vcpu_create() and vmx_vcpu_free().

Co-developed-by: Xiaoyao Li <xiaoyao.li@intel.com>
Signed-off-by: Xiaoyao Li <xiaoyao.li@intel.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
Reviewed-by: Binbin Wu <binbin.wu@linux.intel.com>
Reviewed-by: Xiaoyao Li <xiaoyao.li@intel.com>
Reviewed-by: Yuan Yao <yuan.yao@intel.com>
Message-Id: <e603c317587f933a9d1bee8728c84e4935849c16.1705965634.git.isaku.yamahata@intel.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 arch/x86/kvm/Makefile      |   2 +-
 arch/x86/kvm/vmx/main.c    | 168 +++++++++++++++++
 arch/x86/kvm/vmx/vmx.c     | 375 ++++++++++---------------------------
 arch/x86/kvm/vmx/x86_ops.h | 124 ++++++++++++
 4 files changed, 395 insertions(+), 274 deletions(-)
 create mode 100644 arch/x86/kvm/vmx/main.c
 create mode 100644 arch/x86/kvm/vmx/x86_ops.h

diff --git a/arch/x86/kvm/Makefile b/arch/x86/kvm/Makefile
index 744a1ea3ee5c..8cee22145b1e 100644
--- a/arch/x86/kvm/Makefile
+++ b/arch/x86/kvm/Makefile
@@ -20,7 +20,7 @@ kvm-$(CONFIG_KVM_XEN)	+= xen.o
 kvm-$(CONFIG_KVM_SMM)	+= smm.o
 
 kvm-intel-y		+= vmx/vmx.o vmx/vmenter.o vmx/pmu_intel.o vmx/vmcs12.o \
-			   vmx/nested.o vmx/posted_intr.o
+			   vmx/nested.o vmx/posted_intr.o vmx/main.o
 
 kvm-intel-$(CONFIG_X86_SGX_KVM)	+= vmx/sgx.o
 kvm-intel-$(CONFIG_KVM_HYPERV)	+= vmx/hyperv.o vmx/hyperv_evmcs.o
diff --git a/arch/x86/kvm/vmx/main.c b/arch/x86/kvm/vmx/main.c
new file mode 100644
index 000000000000..63d32867065e
--- /dev/null
+++ b/arch/x86/kvm/vmx/main.c
@@ -0,0 +1,168 @@
+// SPDX-License-Identifier: GPL-2.0
+#include <linux/moduleparam.h>
+
+#include "x86_ops.h"
+#include "vmx.h"
+#include "nested.h"
+#include "pmu.h"
+
+#define VMX_REQUIRED_APICV_INHIBITS				\
+	(BIT(APICV_INHIBIT_REASON_DISABLE)|			\
+	 BIT(APICV_INHIBIT_REASON_ABSENT) |			\
+	 BIT(APICV_INHIBIT_REASON_HYPERV) |			\
+	 BIT(APICV_INHIBIT_REASON_BLOCKIRQ) |			\
+	 BIT(APICV_INHIBIT_REASON_PHYSICAL_ID_ALIASED) |	\
+	 BIT(APICV_INHIBIT_REASON_APIC_ID_MODIFIED) |		\
+	 BIT(APICV_INHIBIT_REASON_APIC_BASE_MODIFIED))
+
+struct kvm_x86_ops vt_x86_ops __initdata = {
+	.name = KBUILD_MODNAME,
+
+	.check_processor_compatibility = vmx_check_processor_compat,
+
+	.hardware_unsetup = vmx_hardware_unsetup,
+
+	.hardware_enable = vmx_hardware_enable,
+	.hardware_disable = vmx_hardware_disable,
+	.has_emulated_msr = vmx_has_emulated_msr,
+
+	.vm_size = sizeof(struct kvm_vmx),
+	.vm_init = vmx_vm_init,
+	.vm_destroy = vmx_vm_destroy,
+
+	.vcpu_precreate = vmx_vcpu_precreate,
+	.vcpu_create = vmx_vcpu_create,
+	.vcpu_free = vmx_vcpu_free,
+	.vcpu_reset = vmx_vcpu_reset,
+
+	.prepare_switch_to_guest = vmx_prepare_switch_to_guest,
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
+	.is_valid_cr0 = vmx_is_valid_cr0,
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
+	.flush_tlb_all = vmx_flush_tlb_all,
+	.flush_tlb_current = vmx_flush_tlb_current,
+	.flush_tlb_gva = vmx_flush_tlb_gva,
+	.flush_tlb_guest = vmx_flush_tlb_guest,
+
+	.vcpu_pre_run = vmx_vcpu_pre_run,
+	.vcpu_run = vmx_vcpu_run,
+	.handle_exit = vmx_handle_exit,
+	.skip_emulated_instruction = vmx_skip_emulated_instruction,
+	.update_emulated_instruction = vmx_update_emulated_instruction,
+	.set_interrupt_shadow = vmx_set_interrupt_shadow,
+	.get_interrupt_shadow = vmx_get_interrupt_shadow,
+	.patch_hypercall = vmx_patch_hypercall,
+	.inject_irq = vmx_inject_irq,
+	.inject_nmi = vmx_inject_nmi,
+	.inject_exception = vmx_inject_exception,
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
+	.apicv_pre_state_restore = vmx_apicv_pre_state_restore,
+	.required_apicv_inhibits = VMX_REQUIRED_APICV_INHIBITS,
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
+	.nested_ops = &vmx_nested_ops,
+
+	.pi_update_irte = vmx_pi_update_irte,
+	.pi_start_assignment = vmx_pi_start_assignment,
+
+#ifdef CONFIG_X86_64
+	.set_hv_timer = vmx_set_hv_timer,
+	.cancel_hv_timer = vmx_cancel_hv_timer,
+#endif
+
+	.setup_mce = vmx_setup_mce,
+
+#ifdef CONFIG_KVM_SMM
+	.smi_allowed = vmx_smi_allowed,
+	.enter_smm = vmx_enter_smm,
+	.leave_smm = vmx_leave_smm,
+	.enable_smi_window = vmx_enable_smi_window,
+#endif
+
+	.check_emulate_instruction = vmx_check_emulate_instruction,
+	.apic_init_signal_blocked = vmx_apic_init_signal_blocked,
+	.migrate_timers = vmx_migrate_timers,
+
+	.msr_filter_changed = vmx_msr_filter_changed,
+	.complete_emulated_msr = kvm_complete_insn_gp,
+
+	.vcpu_deliver_sipi_vector = kvm_vcpu_deliver_sipi_vector,
+
+	.get_untagged_addr = vmx_get_untagged_addr,
+};
+
+struct kvm_x86_init_ops vt_init_ops __initdata = {
+	.hardware_setup = vmx_hardware_setup,
+	.handle_intel_pt_intr = NULL,
+
+	.runtime_ops = &vt_x86_ops,
+	.pmu_ops = &intel_pmu_ops,
+};
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 6468f421ba9e..3d8a7e4c8e37 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -65,6 +65,7 @@
 #include "vmcs12.h"
 #include "vmx.h"
 #include "x86.h"
+#include "x86_ops.h"
 #include "smm.h"
 #include "vmx_onhyperv.h"
 
@@ -519,8 +520,6 @@ static inline void vmx_segment_cache_clear(struct vcpu_vmx *vmx)
 static unsigned long host_idt_base;
 
 #if IS_ENABLED(CONFIG_HYPERV)
-static struct kvm_x86_ops vmx_x86_ops __initdata;
-
 static bool __read_mostly enlightened_vmcs = true;
 module_param(enlightened_vmcs, bool, 0444);
 
@@ -570,9 +569,8 @@ static __init void hv_init_evmcs(void)
 		}
 
 		if (ms_hyperv.nested_features & HV_X64_NESTED_DIRECT_FLUSH)
-			vmx_x86_ops.enable_l2_tlb_flush
+			vt_x86_ops.enable_l2_tlb_flush
 				= hv_enable_l2_tlb_flush;
-
 	} else {
 		enlightened_vmcs = false;
 	}
@@ -1484,7 +1482,7 @@ void vmx_vcpu_load_vmcs(struct kvm_vcpu *vcpu, int cpu,
  * Switches to specified vcpu, until a matching vcpu_put(), but assumes
  * vcpu mutex is already taken.
  */
-static void vmx_vcpu_load(struct kvm_vcpu *vcpu, int cpu)
+void vmx_vcpu_load(struct kvm_vcpu *vcpu, int cpu)
 {
 	struct vcpu_vmx *vmx = to_vmx(vcpu);
 
@@ -1495,7 +1493,7 @@ static void vmx_vcpu_load(struct kvm_vcpu *vcpu, int cpu)
 	vmx->host_debugctlmsr = get_debugctlmsr();
 }
 
-static void vmx_vcpu_put(struct kvm_vcpu *vcpu)
+void vmx_vcpu_put(struct kvm_vcpu *vcpu)
 {
 	vmx_vcpu_pi_put(vcpu);
 
@@ -1554,7 +1552,7 @@ void vmx_set_rflags(struct kvm_vcpu *vcpu, unsigned long rflags)
 		vmx->emulation_required = vmx_emulation_required(vcpu);
 }
 
-static bool vmx_get_if_flag(struct kvm_vcpu *vcpu)
+bool vmx_get_if_flag(struct kvm_vcpu *vcpu)
 {
 	return vmx_get_rflags(vcpu) & X86_EFLAGS_IF;
 }
@@ -1660,8 +1658,8 @@ static int vmx_rtit_ctl_check(struct kvm_vcpu *vcpu, u64 data)
 	return 0;
 }
 
-static int vmx_check_emulate_instruction(struct kvm_vcpu *vcpu, int emul_type,
-					 void *insn, int insn_len)
+int vmx_check_emulate_instruction(struct kvm_vcpu *vcpu, int emul_type,
+				  void *insn, int insn_len)
 {
 	/*
 	 * Emulation of instructions in SGX enclaves is impossible as RIP does
@@ -1745,7 +1743,7 @@ static int skip_emulated_instruction(struct kvm_vcpu *vcpu)
  * Recognizes a pending MTF VM-exit and records the nested state for later
  * delivery.
  */
-static void vmx_update_emulated_instruction(struct kvm_vcpu *vcpu)
+void vmx_update_emulated_instruction(struct kvm_vcpu *vcpu)
 {
 	struct vmcs12 *vmcs12 = get_vmcs12(vcpu);
 	struct vcpu_vmx *vmx = to_vmx(vcpu);
@@ -1776,7 +1774,7 @@ static void vmx_update_emulated_instruction(struct kvm_vcpu *vcpu)
 	}
 }
 
-static int vmx_skip_emulated_instruction(struct kvm_vcpu *vcpu)
+int vmx_skip_emulated_instruction(struct kvm_vcpu *vcpu)
 {
 	vmx_update_emulated_instruction(vcpu);
 	return skip_emulated_instruction(vcpu);
@@ -1795,7 +1793,7 @@ static void vmx_clear_hlt(struct kvm_vcpu *vcpu)
 		vmcs_write32(GUEST_ACTIVITY_STATE, GUEST_ACTIVITY_ACTIVE);
 }
 
-static void vmx_inject_exception(struct kvm_vcpu *vcpu)
+void vmx_inject_exception(struct kvm_vcpu *vcpu)
 {
 	struct kvm_queued_exception *ex = &vcpu->arch.exception;
 	u32 intr_info = ex->vector | INTR_INFO_VALID_MASK;
@@ -1916,12 +1914,12 @@ u64 vmx_get_l2_tsc_multiplier(struct kvm_vcpu *vcpu)
 	return kvm_caps.default_tsc_scaling_ratio;
 }
 
-static void vmx_write_tsc_offset(struct kvm_vcpu *vcpu)
+void vmx_write_tsc_offset(struct kvm_vcpu *vcpu)
 {
 	vmcs_write64(TSC_OFFSET, vcpu->arch.tsc_offset);
 }
 
-static void vmx_write_tsc_multiplier(struct kvm_vcpu *vcpu)
+void vmx_write_tsc_multiplier(struct kvm_vcpu *vcpu)
 {
 	vmcs_write64(TSC_MULTIPLIER, vcpu->arch.tsc_scaling_ratio);
 }
@@ -1964,7 +1962,7 @@ static inline bool is_vmx_feature_control_msr_valid(struct vcpu_vmx *vmx,
 	return !(msr->data & ~valid_bits);
 }
 
-static int vmx_get_msr_feature(struct kvm_msr_entry *msr)
+int vmx_get_msr_feature(struct kvm_msr_entry *msr)
 {
 	switch (msr->index) {
 	case KVM_FIRST_EMULATED_VMX_MSR ... KVM_LAST_EMULATED_VMX_MSR:
@@ -1981,7 +1979,7 @@ static int vmx_get_msr_feature(struct kvm_msr_entry *msr)
  * Returns 0 on success, non-0 otherwise.
  * Assumes vcpu_load() was already called.
  */
-static int vmx_get_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
+int vmx_get_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 {
 	struct vcpu_vmx *vmx = to_vmx(vcpu);
 	struct vmx_uret_msr *msr;
@@ -2162,7 +2160,7 @@ static u64 vmx_get_supported_debugctl(struct kvm_vcpu *vcpu, bool host_initiated
  * Returns 0 on success, non-0 otherwise.
  * Assumes vcpu_load() was already called.
  */
-static int vmx_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
+int vmx_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 {
 	struct vcpu_vmx *vmx = to_vmx(vcpu);
 	struct vmx_uret_msr *msr;
@@ -2465,7 +2463,7 @@ static int vmx_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 	return ret;
 }
 
-static void vmx_cache_reg(struct kvm_vcpu *vcpu, enum kvm_reg reg)
+void vmx_cache_reg(struct kvm_vcpu *vcpu, enum kvm_reg reg)
 {
 	unsigned long guest_owned_bits;
 
@@ -2770,7 +2768,7 @@ static bool kvm_is_vmx_supported(void)
 	return supported;
 }
 
-static int vmx_check_processor_compat(void)
+int vmx_check_processor_compat(void)
 {
 	int cpu = raw_smp_processor_id();
 	struct vmcs_config vmcs_conf;
@@ -2812,7 +2810,7 @@ static int kvm_cpu_vmxon(u64 vmxon_pointer)
 	return -EFAULT;
 }
 
-static int vmx_hardware_enable(void)
+int vmx_hardware_enable(void)
 {
 	int cpu = raw_smp_processor_id();
 	u64 phys_addr = __pa(per_cpu(vmxarea, cpu));
@@ -2852,7 +2850,7 @@ static void vmclear_local_loaded_vmcss(void)
 		__loaded_vmcs_clear(v);
 }
 
-static void vmx_hardware_disable(void)
+void vmx_hardware_disable(void)
 {
 	vmclear_local_loaded_vmcss();
 
@@ -3166,7 +3164,7 @@ static void exit_lmode(struct kvm_vcpu *vcpu)
 
 #endif
 
-static void vmx_flush_tlb_all(struct kvm_vcpu *vcpu)
+void vmx_flush_tlb_all(struct kvm_vcpu *vcpu)
 {
 	struct vcpu_vmx *vmx = to_vmx(vcpu);
 
@@ -3196,7 +3194,7 @@ static inline int vmx_get_current_vpid(struct kvm_vcpu *vcpu)
 	return to_vmx(vcpu)->vpid;
 }
 
-static void vmx_flush_tlb_current(struct kvm_vcpu *vcpu)
+void vmx_flush_tlb_current(struct kvm_vcpu *vcpu)
 {
 	struct kvm_mmu *mmu = vcpu->arch.mmu;
 	u64 root_hpa = mmu->root.hpa;
@@ -3212,7 +3210,7 @@ static void vmx_flush_tlb_current(struct kvm_vcpu *vcpu)
 		vpid_sync_context(vmx_get_current_vpid(vcpu));
 }
 
-static void vmx_flush_tlb_gva(struct kvm_vcpu *vcpu, gva_t addr)
+void vmx_flush_tlb_gva(struct kvm_vcpu *vcpu, gva_t addr)
 {
 	/*
 	 * vpid_sync_vcpu_addr() is a nop if vpid==0, see the comment in
@@ -3221,7 +3219,7 @@ static void vmx_flush_tlb_gva(struct kvm_vcpu *vcpu, gva_t addr)
 	vpid_sync_vcpu_addr(vmx_get_current_vpid(vcpu), addr);
 }
 
-static void vmx_flush_tlb_guest(struct kvm_vcpu *vcpu)
+void vmx_flush_tlb_guest(struct kvm_vcpu *vcpu)
 {
 	/*
 	 * vpid_sync_context() is a nop if vpid==0, e.g. if enable_vpid==0 or a
@@ -3266,7 +3264,7 @@ void ept_save_pdptrs(struct kvm_vcpu *vcpu)
 #define CR3_EXITING_BITS (CPU_BASED_CR3_LOAD_EXITING | \
 			  CPU_BASED_CR3_STORE_EXITING)
 
-static bool vmx_is_valid_cr0(struct kvm_vcpu *vcpu, unsigned long cr0)
+bool vmx_is_valid_cr0(struct kvm_vcpu *vcpu, unsigned long cr0)
 {
 	if (is_guest_mode(vcpu))
 		return nested_guest_cr0_valid(vcpu, cr0);
@@ -3387,8 +3385,7 @@ u64 construct_eptp(struct kvm_vcpu *vcpu, hpa_t root_hpa, int root_level)
 	return eptp;
 }
 
-static void vmx_load_mmu_pgd(struct kvm_vcpu *vcpu, hpa_t root_hpa,
-			     int root_level)
+void vmx_load_mmu_pgd(struct kvm_vcpu *vcpu, hpa_t root_hpa, int root_level)
 {
 	struct kvm *kvm = vcpu->kvm;
 	bool update_guest_cr3 = true;
@@ -3417,8 +3414,7 @@ static void vmx_load_mmu_pgd(struct kvm_vcpu *vcpu, hpa_t root_hpa,
 		vmcs_writel(GUEST_CR3, guest_cr3);
 }
 
-
-static bool vmx_is_valid_cr4(struct kvm_vcpu *vcpu, unsigned long cr4)
+bool vmx_is_valid_cr4(struct kvm_vcpu *vcpu, unsigned long cr4)
 {
 	/*
 	 * We operate under the default treatment of SMM, so VMX cannot be
@@ -3534,7 +3530,7 @@ void vmx_get_segment(struct kvm_vcpu *vcpu, struct kvm_segment *var, int seg)
 	var->g = (ar >> 15) & 1;
 }
 
-static u64 vmx_get_segment_base(struct kvm_vcpu *vcpu, int seg)
+u64 vmx_get_segment_base(struct kvm_vcpu *vcpu, int seg)
 {
 	struct kvm_segment s;
 
@@ -3611,14 +3607,14 @@ void __vmx_set_segment(struct kvm_vcpu *vcpu, struct kvm_segment *var, int seg)
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
 
@@ -3626,25 +3622,25 @@ static void vmx_get_cs_db_l_bits(struct kvm_vcpu *vcpu, int *db, int *l)
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
@@ -4116,7 +4112,7 @@ void pt_update_intercept_for_msr(struct kvm_vcpu *vcpu)
 	}
 }
 
-static bool vmx_guest_apic_has_interrupt(struct kvm_vcpu *vcpu)
+bool vmx_guest_apic_has_interrupt(struct kvm_vcpu *vcpu)
 {
 	struct vcpu_vmx *vmx = to_vmx(vcpu);
 	void *vapic_page;
@@ -4136,7 +4132,7 @@ static bool vmx_guest_apic_has_interrupt(struct kvm_vcpu *vcpu)
 	return ((rvi & 0xf0) > (vppr & 0xf0));
 }
 
-static void vmx_msr_filter_changed(struct kvm_vcpu *vcpu)
+void vmx_msr_filter_changed(struct kvm_vcpu *vcpu)
 {
 	struct vcpu_vmx *vmx = to_vmx(vcpu);
 	u32 i;
@@ -4277,8 +4273,8 @@ static int vmx_deliver_posted_interrupt(struct kvm_vcpu *vcpu, int vector)
 	return 0;
 }
 
-static void vmx_deliver_interrupt(struct kvm_lapic *apic, int delivery_mode,
-				  int trig_mode, int vector)
+void vmx_deliver_interrupt(struct kvm_lapic *apic, int delivery_mode,
+			   int trig_mode, int vector)
 {
 	struct kvm_vcpu *vcpu = apic->vcpu;
 
@@ -4440,7 +4436,7 @@ static u32 vmx_vmexit_ctrl(void)
 		~(VM_EXIT_LOAD_IA32_PERF_GLOBAL_CTRL | VM_EXIT_LOAD_IA32_EFER);
 }
 
-static void vmx_refresh_apicv_exec_ctrl(struct kvm_vcpu *vcpu)
+void vmx_refresh_apicv_exec_ctrl(struct kvm_vcpu *vcpu)
 {
 	struct vcpu_vmx *vmx = to_vmx(vcpu);
 
@@ -4705,7 +4701,7 @@ static int vmx_alloc_ipiv_pid_table(struct kvm *kvm)
 	return 0;
 }
 
-static int vmx_vcpu_precreate(struct kvm *kvm)
+int vmx_vcpu_precreate(struct kvm *kvm)
 {
 	return vmx_alloc_ipiv_pid_table(kvm);
 }
@@ -4892,7 +4888,7 @@ static void __vmx_vcpu_reset(struct kvm_vcpu *vcpu)
 	vmx->pi_desc.sn = 1;
 }
 
-static void vmx_vcpu_reset(struct kvm_vcpu *vcpu, bool init_event)
+void vmx_vcpu_reset(struct kvm_vcpu *vcpu, bool init_event)
 {
 	struct vcpu_vmx *vmx = to_vmx(vcpu);
 
@@ -4951,12 +4947,12 @@ static void vmx_vcpu_reset(struct kvm_vcpu *vcpu, bool init_event)
 	vmx_update_fb_clear_dis(vcpu, vmx);
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
@@ -4967,7 +4963,7 @@ static void vmx_enable_nmi_window(struct kvm_vcpu *vcpu)
 	exec_controls_setbit(to_vmx(vcpu), CPU_BASED_NMI_WINDOW_EXITING);
 }
 
-static void vmx_inject_irq(struct kvm_vcpu *vcpu, bool reinjected)
+void vmx_inject_irq(struct kvm_vcpu *vcpu, bool reinjected)
 {
 	struct vcpu_vmx *vmx = to_vmx(vcpu);
 	uint32_t intr;
@@ -4995,7 +4991,7 @@ static void vmx_inject_irq(struct kvm_vcpu *vcpu, bool reinjected)
 	vmx_clear_hlt(vcpu);
 }
 
-static void vmx_inject_nmi(struct kvm_vcpu *vcpu)
+void vmx_inject_nmi(struct kvm_vcpu *vcpu)
 {
 	struct vcpu_vmx *vmx = to_vmx(vcpu);
 
@@ -5073,7 +5069,7 @@ bool vmx_nmi_blocked(struct kvm_vcpu *vcpu)
 		 GUEST_INTR_STATE_NMI));
 }
 
-static int vmx_nmi_allowed(struct kvm_vcpu *vcpu, bool for_injection)
+int vmx_nmi_allowed(struct kvm_vcpu *vcpu, bool for_injection)
 {
 	if (to_vmx(vcpu)->nested.nested_run_pending)
 		return -EBUSY;
@@ -5095,7 +5091,7 @@ bool vmx_interrupt_blocked(struct kvm_vcpu *vcpu)
 		(GUEST_INTR_STATE_STI | GUEST_INTR_STATE_MOV_SS));
 }
 
-static int vmx_interrupt_allowed(struct kvm_vcpu *vcpu, bool for_injection)
+int vmx_interrupt_allowed(struct kvm_vcpu *vcpu, bool for_injection)
 {
 	if (to_vmx(vcpu)->nested.nested_run_pending)
 		return -EBUSY;
@@ -5110,7 +5106,7 @@ static int vmx_interrupt_allowed(struct kvm_vcpu *vcpu, bool for_injection)
 	return !vmx_interrupt_blocked(vcpu);
 }
 
-static int vmx_set_tss_addr(struct kvm *kvm, unsigned int addr)
+int vmx_set_tss_addr(struct kvm *kvm, unsigned int addr)
 {
 	void __user *ret;
 
@@ -5130,7 +5126,7 @@ static int vmx_set_tss_addr(struct kvm *kvm, unsigned int addr)
 	return init_rmode_tss(kvm, ret);
 }
 
-static int vmx_set_identity_map_addr(struct kvm *kvm, u64 ident_addr)
+int vmx_set_identity_map_addr(struct kvm *kvm, u64 ident_addr)
 {
 	to_kvm_vmx(kvm)->ept_identity_map_addr = ident_addr;
 	return 0;
@@ -5422,8 +5418,7 @@ static int handle_io(struct kvm_vcpu *vcpu)
 	return kvm_fast_pio(vcpu, size, port, in);
 }
 
-static void
-vmx_patch_hypercall(struct kvm_vcpu *vcpu, unsigned char *hypercall)
+void vmx_patch_hypercall(struct kvm_vcpu *vcpu, unsigned char *hypercall)
 {
 	/*
 	 * Patch in the VMCALL instruction:
@@ -5632,7 +5627,7 @@ static int handle_dr(struct kvm_vcpu *vcpu)
 	return kvm_complete_insn_gp(vcpu, err);
 }
 
-static void vmx_sync_dirty_debug_regs(struct kvm_vcpu *vcpu)
+void vmx_sync_dirty_debug_regs(struct kvm_vcpu *vcpu)
 {
 	get_debugreg(vcpu->arch.db[0], 0);
 	get_debugreg(vcpu->arch.db[1], 1);
@@ -5651,7 +5646,7 @@ static void vmx_sync_dirty_debug_regs(struct kvm_vcpu *vcpu)
 	set_debugreg(DR6_RESERVED, 6);
 }
 
-static void vmx_set_dr7(struct kvm_vcpu *vcpu, unsigned long val)
+void vmx_set_dr7(struct kvm_vcpu *vcpu, unsigned long val)
 {
 	vmcs_writel(GUEST_DR7, val);
 }
@@ -5922,7 +5917,7 @@ static int handle_invalid_guest_state(struct kvm_vcpu *vcpu)
 	return 1;
 }
 
-static int vmx_vcpu_pre_run(struct kvm_vcpu *vcpu)
+int vmx_vcpu_pre_run(struct kvm_vcpu *vcpu)
 {
 	if (vmx_emulation_required_with_pending_exception(vcpu)) {
 		kvm_prepare_emulation_failure_exit(vcpu);
@@ -6186,9 +6181,8 @@ static int (*kvm_vmx_exit_handlers[])(struct kvm_vcpu *vcpu) = {
 static const int kvm_vmx_max_exit_handlers =
 	ARRAY_SIZE(kvm_vmx_exit_handlers);
 
-static void vmx_get_exit_info(struct kvm_vcpu *vcpu, u32 *reason,
-			      u64 *info1, u64 *info2,
-			      u32 *intr_info, u32 *error_code)
+void vmx_get_exit_info(struct kvm_vcpu *vcpu, u32 *reason,
+		       u64 *info1, u64 *info2, u32 *intr_info, u32 *error_code)
 {
 	struct vcpu_vmx *vmx = to_vmx(vcpu);
 
@@ -6643,7 +6637,7 @@ static int __vmx_handle_exit(struct kvm_vcpu *vcpu, fastpath_t exit_fastpath)
 	return 0;
 }
 
-static int vmx_handle_exit(struct kvm_vcpu *vcpu, fastpath_t exit_fastpath)
+int vmx_handle_exit(struct kvm_vcpu *vcpu, fastpath_t exit_fastpath)
 {
 	int ret = __vmx_handle_exit(vcpu, exit_fastpath);
 
@@ -6731,7 +6725,7 @@ static noinstr void vmx_l1d_flush(struct kvm_vcpu *vcpu)
 		: "eax", "ebx", "ecx", "edx");
 }
 
-static void vmx_update_cr8_intercept(struct kvm_vcpu *vcpu, int tpr, int irr)
+void vmx_update_cr8_intercept(struct kvm_vcpu *vcpu, int tpr, int irr)
 {
 	struct vmcs12 *vmcs12 = get_vmcs12(vcpu);
 	int tpr_threshold;
@@ -6801,7 +6795,7 @@ void vmx_set_virtual_apic_mode(struct kvm_vcpu *vcpu)
 	vmx_update_msr_bitmap_x2apic(vcpu);
 }
 
-static void vmx_set_apic_access_page_addr(struct kvm_vcpu *vcpu)
+void vmx_set_apic_access_page_addr(struct kvm_vcpu *vcpu)
 {
 	const gfn_t gfn = APIC_DEFAULT_PHYS_BASE >> PAGE_SHIFT;
 	struct kvm *kvm = vcpu->kvm;
@@ -6870,7 +6864,7 @@ static void vmx_set_apic_access_page_addr(struct kvm_vcpu *vcpu)
 	kvm_release_pfn_clean(pfn);
 }
 
-static void vmx_hwapic_isr_update(int max_isr)
+void vmx_hwapic_isr_update(int max_isr)
 {
 	u16 status;
 	u8 old;
@@ -6904,7 +6898,7 @@ static void vmx_set_rvi(int vector)
 	}
 }
 
-static void vmx_hwapic_irr_update(struct kvm_vcpu *vcpu, int max_irr)
+void vmx_hwapic_irr_update(struct kvm_vcpu *vcpu, int max_irr)
 {
 	/*
 	 * When running L2, updating RVI is only relevant when
@@ -6918,7 +6912,7 @@ static void vmx_hwapic_irr_update(struct kvm_vcpu *vcpu, int max_irr)
 		vmx_set_rvi(max_irr);
 }
 
-static int vmx_sync_pir_to_irr(struct kvm_vcpu *vcpu)
+int vmx_sync_pir_to_irr(struct kvm_vcpu *vcpu)
 {
 	struct vcpu_vmx *vmx = to_vmx(vcpu);
 	int max_irr;
@@ -6964,7 +6958,7 @@ static int vmx_sync_pir_to_irr(struct kvm_vcpu *vcpu)
 	return max_irr;
 }
 
-static void vmx_load_eoi_exitmap(struct kvm_vcpu *vcpu, u64 *eoi_exit_bitmap)
+void vmx_load_eoi_exitmap(struct kvm_vcpu *vcpu, u64 *eoi_exit_bitmap)
 {
 	if (!kvm_vcpu_apicv_active(vcpu))
 		return;
@@ -6975,7 +6969,7 @@ static void vmx_load_eoi_exitmap(struct kvm_vcpu *vcpu, u64 *eoi_exit_bitmap)
 	vmcs_write64(EOI_EXIT_BITMAP3, eoi_exit_bitmap[3]);
 }
 
-static void vmx_apicv_pre_state_restore(struct kvm_vcpu *vcpu)
+void vmx_apicv_pre_state_restore(struct kvm_vcpu *vcpu)
 {
 	struct vcpu_vmx *vmx = to_vmx(vcpu);
 
@@ -7038,7 +7032,7 @@ static void handle_external_interrupt_irqoff(struct kvm_vcpu *vcpu)
 	vcpu->arch.at_instruction_boundary = true;
 }
 
-static void vmx_handle_exit_irqoff(struct kvm_vcpu *vcpu)
+void vmx_handle_exit_irqoff(struct kvm_vcpu *vcpu)
 {
 	struct vcpu_vmx *vmx = to_vmx(vcpu);
 
@@ -7055,7 +7049,7 @@ static void vmx_handle_exit_irqoff(struct kvm_vcpu *vcpu)
  * The kvm parameter can be NULL (module initialization, or invocation before
  * VM creation). Be sure to check the kvm parameter before using it.
  */
-static bool vmx_has_emulated_msr(struct kvm *kvm, u32 index)
+bool vmx_has_emulated_msr(struct kvm *kvm, u32 index)
 {
 	switch (index) {
 	case MSR_IA32_SMBASE:
@@ -7178,7 +7172,7 @@ static void vmx_complete_interrupts(struct vcpu_vmx *vmx)
 				  IDT_VECTORING_ERROR_CODE);
 }
 
-static void vmx_cancel_injection(struct kvm_vcpu *vcpu)
+void vmx_cancel_injection(struct kvm_vcpu *vcpu)
 {
 	__vmx_complete_interrupts(vcpu,
 				  vmcs_read32(VM_ENTRY_INTR_INFO_FIELD),
@@ -7333,7 +7327,7 @@ static noinstr void vmx_vcpu_enter_exit(struct kvm_vcpu *vcpu,
 	guest_state_exit_irqoff();
 }
 
-static fastpath_t vmx_vcpu_run(struct kvm_vcpu *vcpu)
+fastpath_t vmx_vcpu_run(struct kvm_vcpu *vcpu)
 {
 	struct vcpu_vmx *vmx = to_vmx(vcpu);
 	unsigned long cr3, cr4;
@@ -7489,7 +7483,7 @@ static fastpath_t vmx_vcpu_run(struct kvm_vcpu *vcpu)
 	return vmx_exit_handlers_fastpath(vcpu);
 }
 
-static void vmx_vcpu_free(struct kvm_vcpu *vcpu)
+void vmx_vcpu_free(struct kvm_vcpu *vcpu)
 {
 	struct vcpu_vmx *vmx = to_vmx(vcpu);
 
@@ -7502,7 +7496,7 @@ static void vmx_vcpu_free(struct kvm_vcpu *vcpu)
 		free_page((unsigned long)vmx->ve_info);
 }
 
-static int vmx_vcpu_create(struct kvm_vcpu *vcpu)
+int vmx_vcpu_create(struct kvm_vcpu *vcpu)
 {
 	struct vmx_uret_msr *tsx_ctrl;
 	struct vcpu_vmx *vmx;
@@ -7611,7 +7605,7 @@ static int vmx_vcpu_create(struct kvm_vcpu *vcpu)
 #define L1TF_MSG_SMT "L1TF CPU bug present and SMT on, data leak possible. See CVE-2018-3646 and https://www.kernel.org/doc/html/latest/admin-guide/hw-vuln/l1tf.html for details.\n"
 #define L1TF_MSG_L1D "L1TF CPU bug present and virtualization mitigation disabled, data leak possible. See CVE-2018-3646 and https://www.kernel.org/doc/html/latest/admin-guide/hw-vuln/l1tf.html for details.\n"
 
-static int vmx_vm_init(struct kvm *kvm)
+int vmx_vm_init(struct kvm *kvm)
 {
 	if (!ple_gap)
 		kvm->arch.pause_in_guest = true;
@@ -7642,7 +7636,7 @@ static int vmx_vm_init(struct kvm *kvm)
 	return 0;
 }
 
-static u8 vmx_get_mt_mask(struct kvm_vcpu *vcpu, gfn_t gfn, bool is_mmio)
+u8 vmx_get_mt_mask(struct kvm_vcpu *vcpu, gfn_t gfn, bool is_mmio)
 {
 	/* We wanted to honor guest CD/MTRR/PAT, but doing so could result in
 	 * memory aliases with conflicting memory types and sometimes MCEs.
@@ -7814,7 +7808,7 @@ static void update_intel_pt_cfg(struct kvm_vcpu *vcpu)
 		vmx->pt_desc.ctl_bitmask &= ~(0xfULL << (32 + i * 4));
 }
 
-static void vmx_vcpu_after_set_cpuid(struct kvm_vcpu *vcpu)
+void vmx_vcpu_after_set_cpuid(struct kvm_vcpu *vcpu)
 {
 	struct vcpu_vmx *vmx = to_vmx(vcpu);
 
@@ -7968,7 +7962,7 @@ static __init void vmx_set_cpu_caps(void)
 		kvm_cpu_cap_check_and_set(X86_FEATURE_WAITPKG);
 }
 
-static void vmx_request_immediate_exit(struct kvm_vcpu *vcpu)
+void vmx_request_immediate_exit(struct kvm_vcpu *vcpu)
 {
 	to_vmx(vcpu)->req_immediate_exit = true;
 }
@@ -8007,10 +8001,10 @@ static int vmx_check_intercept_io(struct kvm_vcpu *vcpu,
 	return intercept ? X86EMUL_UNHANDLEABLE : X86EMUL_CONTINUE;
 }
 
-static int vmx_check_intercept(struct kvm_vcpu *vcpu,
-			       struct x86_instruction_info *info,
-			       enum x86_intercept_stage stage,
-			       struct x86_exception *exception)
+int vmx_check_intercept(struct kvm_vcpu *vcpu,
+			struct x86_instruction_info *info,
+			enum x86_intercept_stage stage,
+			struct x86_exception *exception)
 {
 	struct vmcs12 *vmcs12 = get_vmcs12(vcpu);
 
@@ -8090,8 +8084,8 @@ static inline int u64_shl_div_u64(u64 a, unsigned int shift,
 	return 0;
 }
 
-static int vmx_set_hv_timer(struct kvm_vcpu *vcpu, u64 guest_deadline_tsc,
-			    bool *expired)
+int vmx_set_hv_timer(struct kvm_vcpu *vcpu, u64 guest_deadline_tsc,
+		     bool *expired)
 {
 	struct vcpu_vmx *vmx;
 	u64 tscl, guest_tscl, delta_tsc, lapic_timer_advance_cycles;
@@ -8130,13 +8124,13 @@ static int vmx_set_hv_timer(struct kvm_vcpu *vcpu, u64 guest_deadline_tsc,
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
@@ -8165,7 +8159,7 @@ void vmx_update_cpu_dirty_logging(struct kvm_vcpu *vcpu)
 		secondary_exec_controls_clearbit(vmx, SECONDARY_EXEC_ENABLE_PML);
 }
 
-static void vmx_setup_mce(struct kvm_vcpu *vcpu)
+void vmx_setup_mce(struct kvm_vcpu *vcpu)
 {
 	if (vcpu->arch.mcg_cap & MCG_LMCE_P)
 		to_vmx(vcpu)->msr_ia32_feature_control_valid_bits |=
@@ -8176,7 +8170,7 @@ static void vmx_setup_mce(struct kvm_vcpu *vcpu)
 }
 
 #ifdef CONFIG_KVM_SMM
-static int vmx_smi_allowed(struct kvm_vcpu *vcpu, bool for_injection)
+int vmx_smi_allowed(struct kvm_vcpu *vcpu, bool for_injection)
 {
 	/* we need a nested vmexit to enter SMM, postpone if run is pending */
 	if (to_vmx(vcpu)->nested.nested_run_pending)
@@ -8184,7 +8178,7 @@ static int vmx_smi_allowed(struct kvm_vcpu *vcpu, bool for_injection)
 	return !is_smm(vcpu);
 }
 
-static int vmx_enter_smm(struct kvm_vcpu *vcpu, union kvm_smram *smram)
+int vmx_enter_smm(struct kvm_vcpu *vcpu, union kvm_smram *smram)
 {
 	struct vcpu_vmx *vmx = to_vmx(vcpu);
 
@@ -8205,7 +8199,7 @@ static int vmx_enter_smm(struct kvm_vcpu *vcpu, union kvm_smram *smram)
 	return 0;
 }
 
-static int vmx_leave_smm(struct kvm_vcpu *vcpu, const union kvm_smram *smram)
+int vmx_leave_smm(struct kvm_vcpu *vcpu, const union kvm_smram *smram)
 {
 	struct vcpu_vmx *vmx = to_vmx(vcpu);
 	int ret;
@@ -8226,18 +8220,18 @@ static int vmx_leave_smm(struct kvm_vcpu *vcpu, const union kvm_smram *smram)
 	return 0;
 }
 
-static void vmx_enable_smi_window(struct kvm_vcpu *vcpu)
+void vmx_enable_smi_window(struct kvm_vcpu *vcpu)
 {
 	/* RSM will cause a vmexit anyway.  */
 }
 #endif
 
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
@@ -8247,7 +8241,7 @@ static void vmx_migrate_timers(struct kvm_vcpu *vcpu)
 	}
 }
 
-static void vmx_hardware_unsetup(void)
+void vmx_hardware_unsetup(void)
 {
 	kvm_set_posted_intr_wakeup_handler(NULL);
 
@@ -8257,18 +8251,7 @@ static void vmx_hardware_unsetup(void)
 	free_kvm_area();
 }
 
-#define VMX_REQUIRED_APICV_INHIBITS			\
-(							\
-	BIT(APICV_INHIBIT_REASON_DISABLE)|		\
-	BIT(APICV_INHIBIT_REASON_ABSENT) |		\
-	BIT(APICV_INHIBIT_REASON_HYPERV) |		\
-	BIT(APICV_INHIBIT_REASON_BLOCKIRQ) |		\
-	BIT(APICV_INHIBIT_REASON_PHYSICAL_ID_ALIASED) |	\
-	BIT(APICV_INHIBIT_REASON_APIC_ID_MODIFIED) |	\
-	BIT(APICV_INHIBIT_REASON_APIC_BASE_MODIFIED)	\
-)
-
-static void vmx_vm_destroy(struct kvm *kvm)
+void vmx_vm_destroy(struct kvm *kvm)
 {
 	struct kvm_vmx *kvm_vmx = to_kvm_vmx(kvm);
 
@@ -8319,150 +8302,6 @@ gva_t vmx_get_untagged_addr(struct kvm_vcpu *vcpu, gva_t gva, unsigned int flags
 	return (sign_extend64(gva, lam_bit) & ~BIT_ULL(63)) | (gva & BIT_ULL(63));
 }
 
-static struct kvm_x86_ops vmx_x86_ops __initdata = {
-	.name = KBUILD_MODNAME,
-
-	.check_processor_compatibility = vmx_check_processor_compat,
-
-	.hardware_unsetup = vmx_hardware_unsetup,
-
-	.hardware_enable = vmx_hardware_enable,
-	.hardware_disable = vmx_hardware_disable,
-	.has_emulated_msr = vmx_has_emulated_msr,
-
-	.vm_size = sizeof(struct kvm_vmx),
-	.vm_init = vmx_vm_init,
-	.vm_destroy = vmx_vm_destroy,
-
-	.vcpu_precreate = vmx_vcpu_precreate,
-	.vcpu_create = vmx_vcpu_create,
-	.vcpu_free = vmx_vcpu_free,
-	.vcpu_reset = vmx_vcpu_reset,
-
-	.prepare_switch_to_guest = vmx_prepare_switch_to_guest,
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
-	.is_valid_cr0 = vmx_is_valid_cr0,
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
-	.flush_tlb_all = vmx_flush_tlb_all,
-	.flush_tlb_current = vmx_flush_tlb_current,
-	.flush_tlb_gva = vmx_flush_tlb_gva,
-	.flush_tlb_guest = vmx_flush_tlb_guest,
-
-	.vcpu_pre_run = vmx_vcpu_pre_run,
-	.vcpu_run = vmx_vcpu_run,
-	.handle_exit = vmx_handle_exit,
-	.skip_emulated_instruction = vmx_skip_emulated_instruction,
-	.update_emulated_instruction = vmx_update_emulated_instruction,
-	.set_interrupt_shadow = vmx_set_interrupt_shadow,
-	.get_interrupt_shadow = vmx_get_interrupt_shadow,
-	.patch_hypercall = vmx_patch_hypercall,
-	.inject_irq = vmx_inject_irq,
-	.inject_nmi = vmx_inject_nmi,
-	.inject_exception = vmx_inject_exception,
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
-	.apicv_pre_state_restore = vmx_apicv_pre_state_restore,
-	.required_apicv_inhibits = VMX_REQUIRED_APICV_INHIBITS,
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
-	.nested_ops = &vmx_nested_ops,
-
-	.pi_update_irte = vmx_pi_update_irte,
-	.pi_start_assignment = vmx_pi_start_assignment,
-
-#ifdef CONFIG_X86_64
-	.set_hv_timer = vmx_set_hv_timer,
-	.cancel_hv_timer = vmx_cancel_hv_timer,
-#endif
-
-	.setup_mce = vmx_setup_mce,
-
-#ifdef CONFIG_KVM_SMM
-	.smi_allowed = vmx_smi_allowed,
-	.enter_smm = vmx_enter_smm,
-	.leave_smm = vmx_leave_smm,
-	.enable_smi_window = vmx_enable_smi_window,
-#endif
-
-	.check_emulate_instruction = vmx_check_emulate_instruction,
-	.apic_init_signal_blocked = vmx_apic_init_signal_blocked,
-	.migrate_timers = vmx_migrate_timers,
-
-	.msr_filter_changed = vmx_msr_filter_changed,
-	.complete_emulated_msr = kvm_complete_insn_gp,
-
-	.vcpu_deliver_sipi_vector = kvm_vcpu_deliver_sipi_vector,
-
-	.get_untagged_addr = vmx_get_untagged_addr,
-};
-
 static unsigned int vmx_handle_intel_pt_intr(void)
 {
 	struct kvm_vcpu *vcpu = kvm_get_running_vcpu();
@@ -8528,9 +8367,7 @@ static void __init vmx_setup_me_spte_mask(void)
 	kvm_mmu_set_me_spte_mask(0, me_mask);
 }
 
-static struct kvm_x86_init_ops vmx_init_ops __initdata;
-
-static __init int hardware_setup(void)
+__init int vmx_hardware_setup(void)
 {
 	unsigned long host_bndcfgs;
 	struct desc_ptr dt;
@@ -8599,16 +8436,16 @@ static __init int hardware_setup(void)
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
-		vmx_x86_ops.flush_remote_tlbs = hv_flush_remote_tlbs;
-		vmx_x86_ops.flush_remote_tlbs_range = hv_flush_remote_tlbs_range;
+		vt_x86_ops.flush_remote_tlbs = hv_flush_remote_tlbs;
+		vt_x86_ops.flush_remote_tlbs_range = hv_flush_remote_tlbs_range;
 	}
 #endif
 
@@ -8623,7 +8460,7 @@ static __init int hardware_setup(void)
 	if (!cpu_has_vmx_apicv())
 		enable_apicv = 0;
 	if (!enable_apicv)
-		vmx_x86_ops.sync_pir_to_irr = NULL;
+		vt_x86_ops.sync_pir_to_irr = NULL;
 
 	if (!enable_apicv || !cpu_has_vmx_ipiv())
 		enable_ipiv = false;
@@ -8659,7 +8496,7 @@ static __init int hardware_setup(void)
 		enable_pml = 0;
 
 	if (!enable_pml)
-		vmx_x86_ops.cpu_dirty_log_size = 0;
+		vt_x86_ops.cpu_dirty_log_size = 0;
 
 	if (!cpu_has_vmx_preemption_timer())
 		enable_preemption_timer = false;
@@ -8684,9 +8521,9 @@ static __init int hardware_setup(void)
 	}
 
 	if (!enable_preemption_timer) {
-		vmx_x86_ops.set_hv_timer = NULL;
-		vmx_x86_ops.cancel_hv_timer = NULL;
-		vmx_x86_ops.request_immediate_exit = __kvm_request_immediate_exit;
+		vt_x86_ops.set_hv_timer = NULL;
+		vt_x86_ops.cancel_hv_timer = NULL;
+		vt_x86_ops.request_immediate_exit = __kvm_request_immediate_exit;
 	}
 
 	kvm_caps.supported_mce_cap |= MCG_LMCE_P;
@@ -8697,9 +8534,9 @@ static __init int hardware_setup(void)
 	if (!enable_ept || !enable_pmu || !cpu_has_vmx_intel_pt())
 		pt_mode = PT_MODE_SYSTEM;
 	if (pt_mode == PT_MODE_HOST_GUEST)
-		vmx_init_ops.handle_intel_pt_intr = vmx_handle_intel_pt_intr;
+		vt_init_ops.handle_intel_pt_intr = vmx_handle_intel_pt_intr;
 	else
-		vmx_init_ops.handle_intel_pt_intr = NULL;
+		vt_init_ops.handle_intel_pt_intr = NULL;
 
 	setup_default_sgx_lepubkeyhash();
 
@@ -8722,14 +8559,6 @@ static __init int hardware_setup(void)
 	return r;
 }
 
-static struct kvm_x86_init_ops vmx_init_ops __initdata = {
-	.hardware_setup = hardware_setup,
-	.handle_intel_pt_intr = NULL,
-
-	.runtime_ops = &vmx_x86_ops,
-	.pmu_ops = &intel_pmu_ops,
-};
-
 static void vmx_cleanup_l1d_flush(void)
 {
 	if (vmx_l1d_flush_pages) {
@@ -8771,7 +8600,7 @@ static int __init vmx_init(void)
 	 */
 	hv_init_evmcs();
 
-	r = kvm_x86_vendor_init(&vmx_init_ops);
+	r = kvm_x86_vendor_init(&vt_init_ops);
 	if (r)
 		return r;
 
diff --git a/arch/x86/kvm/vmx/x86_ops.h b/arch/x86/kvm/vmx/x86_ops.h
new file mode 100644
index 000000000000..4bdb8f33b258
--- /dev/null
+++ b/arch/x86/kvm/vmx/x86_ops.h
@@ -0,0 +1,124 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+#ifndef __KVM_X86_VMX_X86_OPS_H
+#define __KVM_X86_VMX_X86_OPS_H
+
+#include <linux/kvm_host.h>
+
+#include "x86.h"
+
+__init int vmx_hardware_setup(void);
+
+extern struct kvm_x86_ops vt_x86_ops __initdata;
+extern struct kvm_x86_init_ops vt_init_ops __initdata;
+
+void vmx_hardware_unsetup(void);
+int vmx_check_processor_compat(void);
+int vmx_hardware_enable(void);
+void vmx_hardware_disable(void);
+int vmx_vm_init(struct kvm *kvm);
+void vmx_vm_destroy(struct kvm *kvm);
+int vmx_vcpu_precreate(struct kvm *kvm);
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
+#ifdef CONFIG_KVM_SMM
+int vmx_smi_allowed(struct kvm_vcpu *vcpu, bool for_injection);
+int vmx_enter_smm(struct kvm_vcpu *vcpu, union kvm_smram *smram);
+int vmx_leave_smm(struct kvm_vcpu *vcpu, const union kvm_smram *smram);
+void vmx_enable_smi_window(struct kvm_vcpu *vcpu);
+#endif
+int vmx_check_emulate_instruction(struct kvm_vcpu *vcpu, int emul_type,
+				  void *insn, int insn_len);
+int vmx_check_intercept(struct kvm_vcpu *vcpu,
+			struct x86_instruction_info *info,
+			enum x86_intercept_stage stage,
+			struct x86_exception *exception);
+bool vmx_apic_init_signal_blocked(struct kvm_vcpu *vcpu);
+void vmx_migrate_timers(struct kvm_vcpu *vcpu);
+void vmx_set_virtual_apic_mode(struct kvm_vcpu *vcpu);
+void vmx_apicv_pre_state_restore(struct kvm_vcpu *vcpu);
+bool vmx_check_apicv_inhibit_reasons(enum kvm_apicv_inhibit reason);
+void vmx_hwapic_irr_update(struct kvm_vcpu *vcpu, int max_irr);
+void vmx_hwapic_isr_update(int max_isr);
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
+bool vmx_is_valid_cr0(struct kvm_vcpu *vcpu, unsigned long cr0);
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
+void vmx_inject_irq(struct kvm_vcpu *vcpu, bool reinjected);
+void vmx_inject_nmi(struct kvm_vcpu *vcpu);
+void vmx_inject_exception(struct kvm_vcpu *vcpu);
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
+u8 vmx_get_mt_mask(struct kvm_vcpu *vcpu, gfn_t gfn, bool is_mmio);
+void vmx_get_exit_info(struct kvm_vcpu *vcpu, u32 *reason,
+		       u64 *info1, u64 *info2, u32 *intr_info, u32 *error_code);
+u64 vmx_get_l2_tsc_offset(struct kvm_vcpu *vcpu);
+u64 vmx_get_l2_tsc_multiplier(struct kvm_vcpu *vcpu);
+void vmx_write_tsc_offset(struct kvm_vcpu *vcpu);
+void vmx_write_tsc_multiplier(struct kvm_vcpu *vcpu);
+void vmx_request_immediate_exit(struct kvm_vcpu *vcpu);
+void vmx_sched_in(struct kvm_vcpu *vcpu, int cpu);
+void vmx_update_cpu_dirty_logging(struct kvm_vcpu *vcpu);
+#ifdef CONFIG_X86_64
+int vmx_set_hv_timer(struct kvm_vcpu *vcpu, u64 guest_deadline_tsc,
+		     bool *expired);
+void vmx_cancel_hv_timer(struct kvm_vcpu *vcpu);
+#endif
+void vmx_setup_mce(struct kvm_vcpu *vcpu);
+
+#endif /* __KVM_X86_VMX_X86_OPS_H */
-- 
2.39.0



