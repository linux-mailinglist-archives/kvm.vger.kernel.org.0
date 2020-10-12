Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E5CD928AC8D
	for <lists+kvm@lfdr.de>; Mon, 12 Oct 2020 05:33:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727425AbgJLDdg (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 11 Oct 2020 23:33:36 -0400
Received: from mga04.intel.com ([192.55.52.120]:62772 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727389AbgJLDdf (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 11 Oct 2020 23:33:35 -0400
IronPort-SDR: v9BuqfNdPFahqocL+rGbptVzmvmlEb6bxHGQocDQMRtx1arQo50UNDHbvLuueTeGEoKhN8D/qX
 WX+9cYWlLblQ==
X-IronPort-AV: E=McAfee;i="6000,8403,9771"; a="163046220"
X-IronPort-AV: E=Sophos;i="5.77,365,1596524400"; 
   d="scan'208";a="163046220"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Oct 2020 20:33:33 -0700
IronPort-SDR: 7B/9Mh9zjeMcimBH/zjg0HGAG6y6/WoGUxBEazgAjGguP5SDE98IdDvdmPfGZ0hcbBsuSzf3zZ
 TL02JvEJZ3YA==
X-IronPort-AV: E=Sophos;i="5.77,365,1596524400"; 
   d="scan'208";a="529780086"
Received: from chenyi-pc.sh.intel.com ([10.239.159.72])
  by orsmga005-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Oct 2020 20:33:30 -0700
From:   Chenyi Qiang <chenyi.qiang@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Xiaoyao Li <xiaoyao.li@intel.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [RESEND v4 1/2] KVM: VMX: Convert vcpu_vmx.exit_reason to a union
Date:   Mon, 12 Oct 2020 11:35:41 +0800
Message-Id: <20201012033542.4696-2-chenyi.qiang@intel.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20201012033542.4696-1-chenyi.qiang@intel.com>
References: <20201012033542.4696-1-chenyi.qiang@intel.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Sean Christopherson <sean.j.christopherson@intel.com>

Convert vcpu_vmx.exit_reason from a u32 to a union (of size u32).  The
full VM_EXIT_REASON field is comprised of a 16-bit basic exit reason in
bits 15:0, and single-bit modifiers in bits 31:16.

Historically, KVM has only had to worry about handling the "failed
VM-Entry" modifier, which could only be set in very specific flows and
required dedicated handling.  I.e. manually stripping the FAILED_VMENTRY
bit was a somewhat viable approach.  But even with only a single bit to
worry about, KVM has had several bugs related to comparing a basic exit
reason against the full exit reason store in vcpu_vmx.

Upcoming Intel features, e.g. SGX, will add new modifier bits that can
be set on more or less any VM-Exit, as opposed to the significantly more
restricted FAILED_VMENTRY, i.e. correctly handling everything in one-off
flows isn't scalable.  Tracking exit reason in a union forces code to
explicitly choose between consuming the full exit reason and the basic
exit, and is a convenient way to document and access the modifiers.

No functional change intended.

Cc: Xiaoyao Li <xiaoyao.li@intel.com>
Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
---
 arch/x86/kvm/vmx/nested.c | 42 ++++++++++++++++---------
 arch/x86/kvm/vmx/vmx.c    | 66 ++++++++++++++++++++-------------------
 arch/x86/kvm/vmx/vmx.h    | 25 ++++++++++++++-
 3 files changed, 85 insertions(+), 48 deletions(-)

diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
index 1bb6b31eb646..370c414e333c 100644
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -3304,7 +3304,11 @@ enum nvmx_vmentry_status nested_vmx_enter_non_root_mode(struct kvm_vcpu *vcpu,
 	struct vmcs12 *vmcs12 = get_vmcs12(vcpu);
 	enum vm_entry_failure_code entry_failure_code;
 	bool evaluate_pending_interrupts;
-	u32 exit_reason, failed_index;
+	union vmx_exit_reason exit_reason = {
+		.basic = EXIT_REASON_INVALID_STATE,
+		.failed_vmentry = 1,
+	};
+	u32 failed_index;
 
 	if (kvm_check_request(KVM_REQ_TLB_FLUSH_CURRENT, vcpu))
 		kvm_vcpu_flush_tlb_current(vcpu);
@@ -3354,7 +3358,7 @@ enum nvmx_vmentry_status nested_vmx_enter_non_root_mode(struct kvm_vcpu *vcpu,
 
 		if (nested_vmx_check_guest_state(vcpu, vmcs12,
 						 &entry_failure_code)) {
-			exit_reason = EXIT_REASON_INVALID_STATE;
+			exit_reason.basic = EXIT_REASON_INVALID_STATE;
 			vmcs12->exit_qualification = entry_failure_code;
 			goto vmentry_fail_vmexit;
 		}
@@ -3365,7 +3369,7 @@ enum nvmx_vmentry_status nested_vmx_enter_non_root_mode(struct kvm_vcpu *vcpu,
 		vcpu->arch.tsc_offset += vmcs12->tsc_offset;
 
 	if (prepare_vmcs02(vcpu, vmcs12, &entry_failure_code)) {
-		exit_reason = EXIT_REASON_INVALID_STATE;
+		exit_reason.basic = EXIT_REASON_INVALID_STATE;
 		vmcs12->exit_qualification = entry_failure_code;
 		goto vmentry_fail_vmexit_guest_mode;
 	}
@@ -3375,7 +3379,7 @@ enum nvmx_vmentry_status nested_vmx_enter_non_root_mode(struct kvm_vcpu *vcpu,
 						   vmcs12->vm_entry_msr_load_addr,
 						   vmcs12->vm_entry_msr_load_count);
 		if (failed_index) {
-			exit_reason = EXIT_REASON_MSR_LOAD_FAIL;
+			exit_reason.basic = EXIT_REASON_MSR_LOAD_FAIL;
 			vmcs12->exit_qualification = failed_index;
 			goto vmentry_fail_vmexit_guest_mode;
 		}
@@ -3443,7 +3447,7 @@ enum nvmx_vmentry_status nested_vmx_enter_non_root_mode(struct kvm_vcpu *vcpu,
 		return NVMX_VMENTRY_VMEXIT;
 
 	load_vmcs12_host_state(vcpu, vmcs12);
-	vmcs12->vm_exit_reason = exit_reason | VMX_EXIT_REASONS_FAILED_VMENTRY;
+	vmcs12->vm_exit_reason = exit_reason.full;
 	if (enable_shadow_vmcs || vmx->nested.hv_evmcs)
 		vmx->nested.need_vmcs12_to_shadow_sync = true;
 	return NVMX_VMENTRY_VMEXIT;
@@ -5496,7 +5500,12 @@ static int handle_vmfunc(struct kvm_vcpu *vcpu)
 	return kvm_skip_emulated_instruction(vcpu);
 
 fail:
-	nested_vmx_vmexit(vcpu, vmx->exit_reason,
+	/*
+	 * This is effectively a reflected VM-Exit, as opposed to a synthesized
+	 * nested VM-Exit.  Pass the original exit reason, i.e. don't hardcode
+	 * EXIT_REASON_VMFUNC as the exit reason.
+	 */
+	nested_vmx_vmexit(vcpu, vmx->exit_reason.full,
 			  vmx_get_intr_info(vcpu),
 			  vmx_get_exit_qual(vcpu));
 	return 1;
@@ -5564,7 +5573,8 @@ static bool nested_vmx_exit_handled_io(struct kvm_vcpu *vcpu,
  * MSR bitmap. This may be the case even when L0 doesn't use MSR bitmaps.
  */
 static bool nested_vmx_exit_handled_msr(struct kvm_vcpu *vcpu,
-	struct vmcs12 *vmcs12, u32 exit_reason)
+					struct vmcs12 *vmcs12,
+					union vmx_exit_reason exit_reason)
 {
 	u32 msr_index = kvm_rcx_read(vcpu);
 	gpa_t bitmap;
@@ -5578,7 +5588,7 @@ static bool nested_vmx_exit_handled_msr(struct kvm_vcpu *vcpu,
 	 * First we need to figure out which of the four to use:
 	 */
 	bitmap = vmcs12->msr_bitmap;
-	if (exit_reason == EXIT_REASON_MSR_WRITE)
+	if (exit_reason.basic == EXIT_REASON_MSR_WRITE)
 		bitmap += 2048;
 	if (msr_index >= 0xc0000000) {
 		msr_index -= 0xc0000000;
@@ -5715,11 +5725,12 @@ static bool nested_vmx_exit_handled_mtf(struct vmcs12 *vmcs12)
  * Return true if L0 wants to handle an exit from L2 regardless of whether or not
  * L1 wants the exit.  Only call this when in is_guest_mode (L2).
  */
-static bool nested_vmx_l0_wants_exit(struct kvm_vcpu *vcpu, u32 exit_reason)
+static bool nested_vmx_l0_wants_exit(struct kvm_vcpu *vcpu,
+				     union vmx_exit_reason exit_reason)
 {
 	u32 intr_info;
 
-	switch ((u16)exit_reason) {
+	switch ((u16)exit_reason.basic) {
 	case EXIT_REASON_EXCEPTION_NMI:
 		intr_info = vmx_get_intr_info(vcpu);
 		if (is_nmi(intr_info))
@@ -5775,12 +5786,13 @@ static bool nested_vmx_l0_wants_exit(struct kvm_vcpu *vcpu, u32 exit_reason)
  * Return 1 if L1 wants to intercept an exit from L2.  Only call this when in
  * is_guest_mode (L2).
  */
-static bool nested_vmx_l1_wants_exit(struct kvm_vcpu *vcpu, u32 exit_reason)
+static bool nested_vmx_l1_wants_exit(struct kvm_vcpu *vcpu,
+				     union vmx_exit_reason exit_reason)
 {
 	struct vmcs12 *vmcs12 = get_vmcs12(vcpu);
 	u32 intr_info;
 
-	switch ((u16)exit_reason) {
+	switch ((u16)exit_reason.basic) {
 	case EXIT_REASON_EXCEPTION_NMI:
 		intr_info = vmx_get_intr_info(vcpu);
 		if (is_nmi(intr_info))
@@ -5899,7 +5911,7 @@ static bool nested_vmx_l1_wants_exit(struct kvm_vcpu *vcpu, u32 exit_reason)
 bool nested_vmx_reflect_vmexit(struct kvm_vcpu *vcpu)
 {
 	struct vcpu_vmx *vmx = to_vmx(vcpu);
-	u32 exit_reason = vmx->exit_reason;
+	union vmx_exit_reason exit_reason = vmx->exit_reason;
 	unsigned long exit_qual;
 	u32 exit_intr_info;
 
@@ -5921,7 +5933,7 @@ bool nested_vmx_reflect_vmexit(struct kvm_vcpu *vcpu)
 	exit_intr_info = vmx_get_intr_info(vcpu);
 	exit_qual = vmx_get_exit_qual(vcpu);
 
-	trace_kvm_nested_vmexit(kvm_rip_read(vcpu), exit_reason, exit_qual,
+	trace_kvm_nested_vmexit(kvm_rip_read(vcpu), exit_reason.full, exit_qual,
 				vmx->idt_vectoring_info, exit_intr_info,
 				vmcs_read32(VM_EXIT_INTR_ERROR_CODE),
 				KVM_ISA_VMX);
@@ -5950,7 +5962,7 @@ bool nested_vmx_reflect_vmexit(struct kvm_vcpu *vcpu)
 	}
 
 reflect_vmexit:
-	nested_vmx_vmexit(vcpu, exit_reason, exit_intr_info, exit_qual);
+	nested_vmx_vmexit(vcpu, exit_reason.full, exit_intr_info, exit_qual);
 	return true;
 }
 
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 96979c09ebd1..01dedcedd2a9 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -1589,7 +1589,7 @@ static int skip_emulated_instruction(struct kvm_vcpu *vcpu)
 	 * i.e. we end up advancing IP with some random value.
 	 */
 	if (!static_cpu_has(X86_FEATURE_HYPERVISOR) ||
-	    to_vmx(vcpu)->exit_reason != EXIT_REASON_EPT_MISCONFIG) {
+	    to_vmx(vcpu)->exit_reason.basic != EXIT_REASON_EPT_MISCONFIG) {
 		orig_rip = kvm_rip_read(vcpu);
 		rip = orig_rip + vmcs_read32(VM_EXIT_INSTRUCTION_LEN);
 #ifdef CONFIG_X86_64
@@ -5988,8 +5988,9 @@ void dump_vmcs(void)
 static int vmx_handle_exit(struct kvm_vcpu *vcpu, fastpath_t exit_fastpath)
 {
 	struct vcpu_vmx *vmx = to_vmx(vcpu);
-	u32 exit_reason = vmx->exit_reason;
+	union vmx_exit_reason exit_reason = vmx->exit_reason;
 	u32 vectoring_info = vmx->idt_vectoring_info;
+	u16 exit_handler_index;
 
 	/*
 	 * Flush logged GPAs PML buffer, this will make dirty_bitmap more
@@ -6031,11 +6032,11 @@ static int vmx_handle_exit(struct kvm_vcpu *vcpu, fastpath_t exit_fastpath)
 			return 1;
 	}
 
-	if (exit_reason & VMX_EXIT_REASONS_FAILED_VMENTRY) {
+	if (exit_reason.failed_vmentry) {
 		dump_vmcs();
 		vcpu->run->exit_reason = KVM_EXIT_FAIL_ENTRY;
 		vcpu->run->fail_entry.hardware_entry_failure_reason
-			= exit_reason;
+			= exit_reason.full;
 		vcpu->run->fail_entry.cpu = vcpu->arch.last_vmentry_cpu;
 		return 0;
 	}
@@ -6057,18 +6058,18 @@ static int vmx_handle_exit(struct kvm_vcpu *vcpu, fastpath_t exit_fastpath)
 	 * will cause infinite loop.
 	 */
 	if ((vectoring_info & VECTORING_INFO_VALID_MASK) &&
-			(exit_reason != EXIT_REASON_EXCEPTION_NMI &&
-			exit_reason != EXIT_REASON_EPT_VIOLATION &&
-			exit_reason != EXIT_REASON_PML_FULL &&
-			exit_reason != EXIT_REASON_APIC_ACCESS &&
-			exit_reason != EXIT_REASON_TASK_SWITCH)) {
+	    (exit_reason.basic != EXIT_REASON_EXCEPTION_NMI &&
+	     exit_reason.basic != EXIT_REASON_EPT_VIOLATION &&
+	     exit_reason.basic != EXIT_REASON_PML_FULL &&
+	     exit_reason.basic != EXIT_REASON_APIC_ACCESS &&
+	     exit_reason.basic != EXIT_REASON_TASK_SWITCH)) {
 		vcpu->run->exit_reason = KVM_EXIT_INTERNAL_ERROR;
 		vcpu->run->internal.suberror = KVM_INTERNAL_ERROR_DELIVERY_EV;
 		vcpu->run->internal.ndata = 3;
 		vcpu->run->internal.data[0] = vectoring_info;
-		vcpu->run->internal.data[1] = exit_reason;
+		vcpu->run->internal.data[1] = exit_reason.full;
 		vcpu->run->internal.data[2] = vcpu->arch.exit_qualification;
-		if (exit_reason == EXIT_REASON_EPT_MISCONFIG) {
+		if (exit_reason.basic == EXIT_REASON_EPT_MISCONFIG) {
 			vcpu->run->internal.ndata++;
 			vcpu->run->internal.data[3] =
 				vmcs_read64(GUEST_PHYSICAL_ADDRESS);
@@ -6100,38 +6101,39 @@ static int vmx_handle_exit(struct kvm_vcpu *vcpu, fastpath_t exit_fastpath)
 	if (exit_fastpath != EXIT_FASTPATH_NONE)
 		return 1;
 
-	if (exit_reason >= kvm_vmx_max_exit_handlers)
+	if (exit_reason.basic >= kvm_vmx_max_exit_handlers)
 		goto unexpected_vmexit;
 #ifdef CONFIG_RETPOLINE
-	if (exit_reason == EXIT_REASON_MSR_WRITE)
+	if (exit_reason.basic == EXIT_REASON_MSR_WRITE)
 		return kvm_emulate_wrmsr(vcpu);
-	else if (exit_reason == EXIT_REASON_PREEMPTION_TIMER)
+	else if (exit_reason.basic == EXIT_REASON_PREEMPTION_TIMER)
 		return handle_preemption_timer(vcpu);
-	else if (exit_reason == EXIT_REASON_INTERRUPT_WINDOW)
+	else if (exit_reason.basic == EXIT_REASON_INTERRUPT_WINDOW)
 		return handle_interrupt_window(vcpu);
-	else if (exit_reason == EXIT_REASON_EXTERNAL_INTERRUPT)
+	else if (exit_reason.basic == EXIT_REASON_EXTERNAL_INTERRUPT)
 		return handle_external_interrupt(vcpu);
-	else if (exit_reason == EXIT_REASON_HLT)
+	else if (exit_reason.basic == EXIT_REASON_HLT)
 		return kvm_emulate_halt(vcpu);
-	else if (exit_reason == EXIT_REASON_EPT_MISCONFIG)
+	else if (exit_reason.basic == EXIT_REASON_EPT_MISCONFIG)
 		return handle_ept_misconfig(vcpu);
 #endif
 
-	exit_reason = array_index_nospec(exit_reason,
-					 kvm_vmx_max_exit_handlers);
-	if (!kvm_vmx_exit_handlers[exit_reason])
+	exit_handler_index = array_index_nospec((u16)exit_reason.basic,
+						kvm_vmx_max_exit_handlers);
+	if (!kvm_vmx_exit_handlers[exit_handler_index])
 		goto unexpected_vmexit;
 
-	return kvm_vmx_exit_handlers[exit_reason](vcpu);
+	return kvm_vmx_exit_handlers[exit_handler_index](vcpu);
 
 unexpected_vmexit:
-	vcpu_unimpl(vcpu, "vmx: unexpected exit reason 0x%x\n", exit_reason);
+	vcpu_unimpl(vcpu, "vmx: unexpected exit reason 0x%x\n",
+		    exit_reason.full);
 	dump_vmcs();
 	vcpu->run->exit_reason = KVM_EXIT_INTERNAL_ERROR;
 	vcpu->run->internal.suberror =
 			KVM_INTERNAL_ERROR_UNEXPECTED_EXIT_REASON;
 	vcpu->run->internal.ndata = 2;
-	vcpu->run->internal.data[0] = exit_reason;
+	vcpu->run->internal.data[0] = exit_reason.full;
 	vcpu->run->internal.data[1] = vcpu->arch.last_vmentry_cpu;
 	return 0;
 }
@@ -6485,9 +6487,9 @@ static void vmx_handle_exit_irqoff(struct kvm_vcpu *vcpu)
 {
 	struct vcpu_vmx *vmx = to_vmx(vcpu);
 
-	if (vmx->exit_reason == EXIT_REASON_EXTERNAL_INTERRUPT)
+	if (vmx->exit_reason.basic == EXIT_REASON_EXTERNAL_INTERRUPT)
 		handle_external_interrupt_irqoff(vcpu);
-	else if (vmx->exit_reason == EXIT_REASON_EXCEPTION_NMI)
+	else if (vmx->exit_reason.basic == EXIT_REASON_EXCEPTION_NMI)
 		handle_exception_nmi_irqoff(vmx);
 }
 
@@ -6675,7 +6677,7 @@ void noinstr vmx_update_host_rsp(struct vcpu_vmx *vmx, unsigned long host_rsp)
 
 static fastpath_t vmx_exit_handlers_fastpath(struct kvm_vcpu *vcpu)
 {
-	switch (to_vmx(vcpu)->exit_reason) {
+	switch (to_vmx(vcpu)->exit_reason.basic) {
 	case EXIT_REASON_MSR_WRITE:
 		return handle_fastpath_set_msr_irqoff(vcpu);
 	case EXIT_REASON_PREEMPTION_TIMER:
@@ -6876,17 +6878,17 @@ static fastpath_t vmx_vcpu_run(struct kvm_vcpu *vcpu)
 	vmx->idt_vectoring_info = 0;
 
 	if (unlikely(vmx->fail)) {
-		vmx->exit_reason = 0xdead;
+		vmx->exit_reason.full = 0xdead;
 		return EXIT_FASTPATH_NONE;
 	}
 
-	vmx->exit_reason = vmcs_read32(VM_EXIT_REASON);
-	if (unlikely((u16)vmx->exit_reason == EXIT_REASON_MCE_DURING_VMENTRY))
+	vmx->exit_reason.full = vmcs_read32(VM_EXIT_REASON);
+	if (unlikely((u16)vmx->exit_reason.basic == EXIT_REASON_MCE_DURING_VMENTRY))
 		kvm_machine_check();
 
-	trace_kvm_exit(vmx->exit_reason, vcpu, KVM_ISA_VMX);
+	trace_kvm_exit(vmx->exit_reason.full, vcpu, KVM_ISA_VMX);
 
-	if (unlikely(vmx->exit_reason & VMX_EXIT_REASONS_FAILED_VMENTRY))
+	if (unlikely(vmx->exit_reason.failed_vmentry))
 		return EXIT_FASTPATH_NONE;
 
 	vmx->loaded_vmcs->launched = 1;
diff --git a/arch/x86/kvm/vmx/vmx.h b/arch/x86/kvm/vmx/vmx.h
index a0e47720f60c..ca250622b123 100644
--- a/arch/x86/kvm/vmx/vmx.h
+++ b/arch/x86/kvm/vmx/vmx.h
@@ -92,6 +92,29 @@ struct pt_desc {
 	struct pt_ctx guest;
 };
 
+union vmx_exit_reason {
+	struct {
+		u32	basic			: 16;
+		u32	reserved16		: 1;
+		u32	reserved17		: 1;
+		u32	reserved18		: 1;
+		u32	reserved19		: 1;
+		u32	reserved20		: 1;
+		u32	reserved21		: 1;
+		u32	reserved22		: 1;
+		u32	reserved23		: 1;
+		u32	reserved24		: 1;
+		u32	reserved25		: 1;
+		u32	reserved26		: 1;
+		u32	enclave_mode		: 1;
+		u32	smi_pending_mtf		: 1;
+		u32	smi_from_vmx_root	: 1;
+		u32	reserved30		: 1;
+		u32	failed_vmentry		: 1;
+	};
+	u32 full;
+};
+
 /*
  * The nested_vmx structure is part of vcpu_vmx, and holds information we need
  * for correct emulation of VMX (i.e., nested VMX) on this vcpu.
@@ -266,7 +289,7 @@ struct vcpu_vmx {
 	int vpid;
 	bool emulation_required;
 
-	u32 exit_reason;
+	union vmx_exit_reason exit_reason;
 
 	/* Posted interrupt descriptor */
 	struct pi_desc pi_desc;
-- 
2.17.1

