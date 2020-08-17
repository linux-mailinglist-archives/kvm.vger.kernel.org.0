Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 266AE245A84
	for <lists+kvm@lfdr.de>; Mon, 17 Aug 2020 03:43:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726728AbgHQBnV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 16 Aug 2020 21:43:21 -0400
Received: from mga11.intel.com ([192.55.52.93]:61654 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726371AbgHQBnG (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 16 Aug 2020 21:43:06 -0400
IronPort-SDR: Du6QqfsqWKRLP4bpGx4xyZPLjKQde65rsMGa9gXOPOSic//wgkdL35jjg+pXM22XSLbxSbMxOr
 lfGoJWtHmzBg==
X-IronPort-AV: E=McAfee;i="6000,8403,9715"; a="152267102"
X-IronPort-AV: E=Sophos;i="5.76,322,1592895600"; 
   d="scan'208";a="152267102"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Aug 2020 18:43:02 -0700
IronPort-SDR: 3uU5G+dZfvwT27kB3xNn2RmfasC5J8dMThnKx9av1xpoiYihCj2M4JpAWHLruQCQzPCURcndG1
 XoZCPRULshtw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.76,322,1592895600"; 
   d="scan'208";a="471258542"
Received: from chenyi-pc.sh.intel.com ([10.239.159.72])
  by orsmga005.jf.intel.com with ESMTP; 16 Aug 2020 18:42:58 -0700
From:   Chenyi Qiang <chenyi.qiang@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Xiaoyao Li <xiaoyao.li@intel.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [RFC v2 1/2] KVM: VMX: Convert vcpu_vmx.exit_reason to a union
Date:   Mon, 17 Aug 2020 09:44:58 +0800
Message-Id: <20200817014459.28782-2-chenyi.qiang@intel.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200817014459.28782-1-chenyi.qiang@intel.com>
References: <20200817014459.28782-1-chenyi.qiang@intel.com>
Sender: kvm-owner@vger.kernel.org
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
 arch/x86/kvm/vmx/vmx.c    | 64 ++++++++++++++++++++-------------------
 arch/x86/kvm/vmx/vmx.h    | 25 ++++++++++++++-
 3 files changed, 84 insertions(+), 47 deletions(-)

diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
index 11e4df560018..ba6d5eb6a4fe 100644
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -3255,7 +3255,11 @@ enum nvmx_vmentry_status nested_vmx_enter_non_root_mode(struct kvm_vcpu *vcpu,
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
@@ -3305,7 +3309,7 @@ enum nvmx_vmentry_status nested_vmx_enter_non_root_mode(struct kvm_vcpu *vcpu,
 
 		if (nested_vmx_check_guest_state(vcpu, vmcs12,
 						 &entry_failure_code)) {
-			exit_reason = EXIT_REASON_INVALID_STATE;
+			exit_reason.basic = EXIT_REASON_INVALID_STATE;
 			vmcs12->exit_qualification = entry_failure_code;
 			goto vmentry_fail_vmexit;
 		}
@@ -3316,7 +3320,7 @@ enum nvmx_vmentry_status nested_vmx_enter_non_root_mode(struct kvm_vcpu *vcpu,
 		vcpu->arch.tsc_offset += vmcs12->tsc_offset;
 
 	if (prepare_vmcs02(vcpu, vmcs12, &entry_failure_code)) {
-		exit_reason = EXIT_REASON_INVALID_STATE;
+		exit_reason.basic = EXIT_REASON_INVALID_STATE;
 		vmcs12->exit_qualification = entry_failure_code;
 		goto vmentry_fail_vmexit_guest_mode;
 	}
@@ -3326,7 +3330,7 @@ enum nvmx_vmentry_status nested_vmx_enter_non_root_mode(struct kvm_vcpu *vcpu,
 						   vmcs12->vm_entry_msr_load_addr,
 						   vmcs12->vm_entry_msr_load_count);
 		if (failed_index) {
-			exit_reason = EXIT_REASON_MSR_LOAD_FAIL;
+			exit_reason.basic = EXIT_REASON_MSR_LOAD_FAIL;
 			vmcs12->exit_qualification = failed_index;
 			goto vmentry_fail_vmexit_guest_mode;
 		}
@@ -3394,7 +3398,7 @@ enum nvmx_vmentry_status nested_vmx_enter_non_root_mode(struct kvm_vcpu *vcpu,
 		return NVMX_VMENTRY_VMEXIT;
 
 	load_vmcs12_host_state(vcpu, vmcs12);
-	vmcs12->vm_exit_reason = exit_reason | VMX_EXIT_REASONS_FAILED_VMENTRY;
+	vmcs12->vm_exit_reason = exit_reason.full;
 	if (enable_shadow_vmcs || vmx->nested.hv_evmcs)
 		vmx->nested.need_vmcs12_to_shadow_sync = true;
 	return NVMX_VMENTRY_VMEXIT;
@@ -5449,7 +5453,12 @@ static int handle_vmfunc(struct kvm_vcpu *vcpu)
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
@@ -5517,7 +5526,8 @@ static bool nested_vmx_exit_handled_io(struct kvm_vcpu *vcpu,
  * MSR bitmap. This may be the case even when L0 doesn't use MSR bitmaps.
  */
 static bool nested_vmx_exit_handled_msr(struct kvm_vcpu *vcpu,
-	struct vmcs12 *vmcs12, u32 exit_reason)
+					struct vmcs12 *vmcs12,
+					union vmx_exit_reason exit_reason)
 {
 	u32 msr_index = kvm_rcx_read(vcpu);
 	gpa_t bitmap;
@@ -5531,7 +5541,7 @@ static bool nested_vmx_exit_handled_msr(struct kvm_vcpu *vcpu,
 	 * First we need to figure out which of the four to use:
 	 */
 	bitmap = vmcs12->msr_bitmap;
-	if (exit_reason == EXIT_REASON_MSR_WRITE)
+	if (exit_reason.basic == EXIT_REASON_MSR_WRITE)
 		bitmap += 2048;
 	if (msr_index >= 0xc0000000) {
 		msr_index -= 0xc0000000;
@@ -5668,11 +5678,12 @@ static bool nested_vmx_exit_handled_mtf(struct vmcs12 *vmcs12)
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
@@ -5728,12 +5739,13 @@ static bool nested_vmx_l0_wants_exit(struct kvm_vcpu *vcpu, u32 exit_reason)
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
@@ -5852,7 +5864,7 @@ static bool nested_vmx_l1_wants_exit(struct kvm_vcpu *vcpu, u32 exit_reason)
 bool nested_vmx_reflect_vmexit(struct kvm_vcpu *vcpu)
 {
 	struct vcpu_vmx *vmx = to_vmx(vcpu);
-	u32 exit_reason = vmx->exit_reason;
+	union vmx_exit_reason exit_reason = vmx->exit_reason;
 	unsigned long exit_qual;
 	u32 exit_intr_info;
 
@@ -5874,7 +5886,7 @@ bool nested_vmx_reflect_vmexit(struct kvm_vcpu *vcpu)
 	exit_intr_info = vmx_get_intr_info(vcpu);
 	exit_qual = vmx_get_exit_qual(vcpu);
 
-	trace_kvm_nested_vmexit(kvm_rip_read(vcpu), exit_reason, exit_qual,
+	trace_kvm_nested_vmexit(kvm_rip_read(vcpu), exit_reason.full, exit_qual,
 				vmx->idt_vectoring_info, exit_intr_info,
 				vmcs_read32(VM_EXIT_INTR_ERROR_CODE),
 				KVM_ISA_VMX);
@@ -5903,7 +5915,7 @@ bool nested_vmx_reflect_vmexit(struct kvm_vcpu *vcpu)
 	}
 
 reflect_vmexit:
-	nested_vmx_vmexit(vcpu, exit_reason, exit_intr_info, exit_qual);
+	nested_vmx_vmexit(vcpu, exit_reason.full, exit_intr_info, exit_qual);
 	return true;
 }
 
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 13745f2a5ecd..89c131eaedf2 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -1573,7 +1573,7 @@ static int skip_emulated_instruction(struct kvm_vcpu *vcpu)
 	 * i.e. we end up advancing IP with some random value.
 	 */
 	if (!static_cpu_has(X86_FEATURE_HYPERVISOR) ||
-	    to_vmx(vcpu)->exit_reason != EXIT_REASON_EPT_MISCONFIG) {
+	    to_vmx(vcpu)->exit_reason.basic != EXIT_REASON_EPT_MISCONFIG) {
 		orig_rip = kvm_rip_read(vcpu);
 		rip = orig_rip + vmcs_read32(VM_EXIT_INSTRUCTION_LEN);
 #ifdef CONFIG_X86_64
@@ -5958,8 +5958,9 @@ void dump_vmcs(void)
 static int vmx_handle_exit(struct kvm_vcpu *vcpu, fastpath_t exit_fastpath)
 {
 	struct vcpu_vmx *vmx = to_vmx(vcpu);
-	u32 exit_reason = vmx->exit_reason;
+	union vmx_exit_reason exit_reason = vmx->exit_reason;
 	u32 vectoring_info = vmx->idt_vectoring_info;
+	u16 exit_handler_index;
 
 	/*
 	 * Flush logged GPAs PML buffer, this will make dirty_bitmap more
@@ -6001,11 +6002,11 @@ static int vmx_handle_exit(struct kvm_vcpu *vcpu, fastpath_t exit_fastpath)
 			return 1;
 	}
 
-	if (exit_reason & VMX_EXIT_REASONS_FAILED_VMENTRY) {
+	if (exit_reason.failed_vmentry) {
 		dump_vmcs();
 		vcpu->run->exit_reason = KVM_EXIT_FAIL_ENTRY;
 		vcpu->run->fail_entry.hardware_entry_failure_reason
-			= exit_reason;
+			= exit_reason.full;
 		return 0;
 	}
 
@@ -6025,17 +6026,17 @@ static int vmx_handle_exit(struct kvm_vcpu *vcpu, fastpath_t exit_fastpath)
 	 * will cause infinite loop.
 	 */
 	if ((vectoring_info & VECTORING_INFO_VALID_MASK) &&
-			(exit_reason != EXIT_REASON_EXCEPTION_NMI &&
-			exit_reason != EXIT_REASON_EPT_VIOLATION &&
-			exit_reason != EXIT_REASON_PML_FULL &&
-			exit_reason != EXIT_REASON_TASK_SWITCH)) {
+	    (exit_reason.basic != EXIT_REASON_EXCEPTION_NMI &&
+	     exit_reason.basic != EXIT_REASON_EPT_VIOLATION &&
+	     exit_reason.basic != EXIT_REASON_PML_FULL &&
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
@@ -6065,38 +6066,39 @@ static int vmx_handle_exit(struct kvm_vcpu *vcpu, fastpath_t exit_fastpath)
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
 	vcpu->run->internal.ndata = 1;
-	vcpu->run->internal.data[0] = exit_reason;
+	vcpu->run->internal.data[0] = exit_reason.full;
 	return 0;
 }
 
@@ -6449,9 +6451,9 @@ static void vmx_handle_exit_irqoff(struct kvm_vcpu *vcpu)
 {
 	struct vcpu_vmx *vmx = to_vmx(vcpu);
 
-	if (vmx->exit_reason == EXIT_REASON_EXTERNAL_INTERRUPT)
+	if (vmx->exit_reason.basic == EXIT_REASON_EXTERNAL_INTERRUPT)
 		handle_external_interrupt_irqoff(vcpu);
-	else if (vmx->exit_reason == EXIT_REASON_EXCEPTION_NMI)
+	else if (vmx->exit_reason.basic == EXIT_REASON_EXCEPTION_NMI)
 		handle_exception_nmi_irqoff(vmx);
 }
 
@@ -6639,7 +6641,7 @@ void vmx_update_host_rsp(struct vcpu_vmx *vmx, unsigned long host_rsp)
 
 static fastpath_t vmx_exit_handlers_fastpath(struct kvm_vcpu *vcpu)
 {
-	switch (to_vmx(vcpu)->exit_reason) {
+	switch (to_vmx(vcpu)->exit_reason.basic) {
 	case EXIT_REASON_MSR_WRITE:
 		return handle_fastpath_set_msr_irqoff(vcpu);
 	case EXIT_REASON_PREEMPTION_TIMER:
@@ -6794,17 +6796,17 @@ static fastpath_t vmx_vcpu_run(struct kvm_vcpu *vcpu)
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
index 639798e4a6ca..06a91b224ef3 100644
--- a/arch/x86/kvm/vmx/vmx.h
+++ b/arch/x86/kvm/vmx/vmx.h
@@ -91,6 +91,29 @@ struct pt_desc {
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
@@ -265,7 +288,7 @@ struct vcpu_vmx {
 	int vpid;
 	bool emulation_required;
 
-	u32 exit_reason;
+	union vmx_exit_reason exit_reason;
 
 	/* Posted interrupt descriptor */
 	struct pi_desc pi_desc;
-- 
2.17.1

