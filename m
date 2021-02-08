Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 394B5313073
	for <lists+kvm@lfdr.de>; Mon,  8 Feb 2021 12:16:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232959AbhBHLOn (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 8 Feb 2021 06:14:43 -0500
Received: from mga07.intel.com ([134.134.136.100]:57964 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232912AbhBHLM1 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 8 Feb 2021 06:12:27 -0500
IronPort-SDR: o//x8aAfwseqkEBU/cujdxezD1boxb/5aOtOpt+3YnKf15+7iE6HEal00lsOlV+miOFmkrZiyd
 VKsl9K/2WfVA==
X-IronPort-AV: E=McAfee;i="6000,8403,9888"; a="245765270"
X-IronPort-AV: E=Sophos;i="5.81,161,1610438400"; 
   d="scan'208";a="245765270"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Feb 2021 03:11:39 -0800
IronPort-SDR: A4DbqZDXwKiS9eso/diXcBl2Z1++6PMjWqZeilLGg6JlLlJhV6UUjw2CFdZnn8p1s8syay0JbE
 kuo+yN6QLcQg==
X-IronPort-AV: E=Sophos;i="5.81,161,1610438400"; 
   d="scan'208";a="585634105"
Received: from jaeminha-mobl.amr.corp.intel.com (HELO khuang2-desk.gar.corp.intel.com) ([10.251.11.62])
  by fmsmga005-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Feb 2021 03:11:34 -0800
Date:   Tue, 9 Feb 2021 00:11:32 +1300
From:   Kai Huang <kai.huang@intel.com>
To:     Kai Huang <kai.huang@intel.com>
Cc:     <linux-sgx@vger.kernel.org>, <kvm@vger.kernel.org>,
        <x86@kernel.org>, <seanjc@google.com>, <jarkko@kernel.org>,
        <luto@kernel.org>, <dave.hansen@intel.com>,
        <rick.p.edgecombe@intel.com>, <haitao.huang@intel.com>,
        <pbonzini@redhat.com>, <bp@alien8.de>, <tglx@linutronix.de>,
        <mingo@redhat.com>, <hpa@zytor.com>, <jmattson@google.com>,
        <joro@8bytes.org>, <vkuznets@redhat.com>, <wanpengli@tencent.com>,
        isaku.yamahata@intel.com
Subject: Re: [RFC PATCH v4 15/26] KVM: VMX: Convert vcpu_vmx.exit_reason to
 a union
Message-Id: <20210209001132.426f38085622c7e3684dbb8d@intel.com>
In-Reply-To: <0daea2891388cd30097cc62a7a5644b321ae80a5.1612777752.git.kai.huang@intel.com>
References: <cover.1612777752.git.kai.huang@intel.com>
        <0daea2891388cd30097cc62a7a5644b321ae80a5.1612777752.git.kai.huang@intel.com>
X-Mailer: Sylpheed 3.7.0 (GTK+ 2.24.33; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Paolo,

Although this series was sent as RFC, would you consider reviewing and merging
this patch from Sean? Intel TDX support (already sent by Isaku as RFC) has
conflict with this one, and I am expecting other features might also conflict
with it too.

Thanks!

On Mon, 8 Feb 2021 23:55:25 +1300 Kai Huang wrote:
> From: Sean Christopherson <sean.j.christopherson@intel.com>
> 
> Convert vcpu_vmx.exit_reason from a u32 to a union (of size u32).  The
> full VM_EXIT_REASON field is comprised of a 16-bit basic exit reason in
> bits 15:0, and single-bit modifiers in bits 31:16.
> 
> Historically, KVM has only had to worry about handling the "failed
> VM-Entry" modifier, which could only be set in very specific flows and
> required dedicated handling.  I.e. manually stripping the FAILED_VMENTRY
> bit was a somewhat viable approach.  But even with only a single bit to
> worry about, KVM has had several bugs related to comparing a basic exit
> reason against the full exit reason store in vcpu_vmx.
> 
> Upcoming Intel features, e.g. SGX, will add new modifier bits that can
> be set on more or less any VM-Exit, as opposed to the significantly more
> restricted FAILED_VMENTRY, i.e. correctly handling everything in one-off
> flows isn't scalable.  Tracking exit reason in a union forces code to
> explicitly choose between consuming the full exit reason and the basic
> exit, and is a convenient way to document and access the modifiers.
> 
> No functional change intended.
> 
> Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
> Signed-off-by: Kai Huang <kai.huang@intel.com>
> ---
>  arch/x86/kvm/vmx/nested.c | 42 +++++++++++++++---------
>  arch/x86/kvm/vmx/vmx.c    | 68 ++++++++++++++++++++-------------------
>  arch/x86/kvm/vmx/vmx.h    | 25 +++++++++++++-
>  3 files changed, 86 insertions(+), 49 deletions(-)
> 
> diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
> index 0fbb46990dfc..f112c2482887 100644
> --- a/arch/x86/kvm/vmx/nested.c
> +++ b/arch/x86/kvm/vmx/nested.c
> @@ -3311,7 +3311,11 @@ enum nvmx_vmentry_status nested_vmx_enter_non_root_mode(struct kvm_vcpu *vcpu,
>  	struct vmcs12 *vmcs12 = get_vmcs12(vcpu);
>  	enum vm_entry_failure_code entry_failure_code;
>  	bool evaluate_pending_interrupts;
> -	u32 exit_reason, failed_index;
> +	u32 failed_index;
> +	union vmx_exit_reason exit_reason = {
> +		.basic = -1,
> +		.failed_vmentry = 1,
> +	};
>  
>  	if (kvm_check_request(KVM_REQ_TLB_FLUSH_CURRENT, vcpu))
>  		kvm_vcpu_flush_tlb_current(vcpu);
> @@ -3363,7 +3367,7 @@ enum nvmx_vmentry_status nested_vmx_enter_non_root_mode(struct kvm_vcpu *vcpu,
>  
>  		if (nested_vmx_check_guest_state(vcpu, vmcs12,
>  						 &entry_failure_code)) {
> -			exit_reason = EXIT_REASON_INVALID_STATE;
> +			exit_reason.basic = EXIT_REASON_INVALID_STATE;
>  			vmcs12->exit_qualification = entry_failure_code;
>  			goto vmentry_fail_vmexit;
>  		}
> @@ -3374,7 +3378,7 @@ enum nvmx_vmentry_status nested_vmx_enter_non_root_mode(struct kvm_vcpu *vcpu,
>  		vcpu->arch.tsc_offset += vmcs12->tsc_offset;
>  
>  	if (prepare_vmcs02(vcpu, vmcs12, &entry_failure_code)) {
> -		exit_reason = EXIT_REASON_INVALID_STATE;
> +		exit_reason.basic = EXIT_REASON_INVALID_STATE;
>  		vmcs12->exit_qualification = entry_failure_code;
>  		goto vmentry_fail_vmexit_guest_mode;
>  	}
> @@ -3384,7 +3388,7 @@ enum nvmx_vmentry_status nested_vmx_enter_non_root_mode(struct kvm_vcpu *vcpu,
>  						   vmcs12->vm_entry_msr_load_addr,
>  						   vmcs12->vm_entry_msr_load_count);
>  		if (failed_index) {
> -			exit_reason = EXIT_REASON_MSR_LOAD_FAIL;
> +			exit_reason.basic = EXIT_REASON_MSR_LOAD_FAIL;
>  			vmcs12->exit_qualification = failed_index;
>  			goto vmentry_fail_vmexit_guest_mode;
>  		}
> @@ -3452,7 +3456,7 @@ enum nvmx_vmentry_status nested_vmx_enter_non_root_mode(struct kvm_vcpu *vcpu,
>  		return NVMX_VMENTRY_VMEXIT;
>  
>  	load_vmcs12_host_state(vcpu, vmcs12);
> -	vmcs12->vm_exit_reason = exit_reason | VMX_EXIT_REASONS_FAILED_VMENTRY;
> +	vmcs12->vm_exit_reason = exit_reason.full;
>  	if (enable_shadow_vmcs || vmx->nested.hv_evmcs)
>  		vmx->nested.need_vmcs12_to_shadow_sync = true;
>  	return NVMX_VMENTRY_VMEXIT;
> @@ -5540,7 +5544,12 @@ static int handle_vmfunc(struct kvm_vcpu *vcpu)
>  	return kvm_skip_emulated_instruction(vcpu);
>  
>  fail:
> -	nested_vmx_vmexit(vcpu, vmx->exit_reason,
> +	/*
> +	 * This is effectively a reflected VM-Exit, as opposed to a synthesized
> +	 * nested VM-Exit.  Pass the original exit reason, i.e. don't hardcode
> +	 * EXIT_REASON_VMFUNC as the exit reason.
> +	 */
> +	nested_vmx_vmexit(vcpu, vmx->exit_reason.full,
>  			  vmx_get_intr_info(vcpu),
>  			  vmx_get_exit_qual(vcpu));
>  	return 1;
> @@ -5608,7 +5617,8 @@ static bool nested_vmx_exit_handled_io(struct kvm_vcpu *vcpu,
>   * MSR bitmap. This may be the case even when L0 doesn't use MSR bitmaps.
>   */
>  static bool nested_vmx_exit_handled_msr(struct kvm_vcpu *vcpu,
> -	struct vmcs12 *vmcs12, u32 exit_reason)
> +					struct vmcs12 *vmcs12,
> +					union vmx_exit_reason exit_reason)
>  {
>  	u32 msr_index = kvm_rcx_read(vcpu);
>  	gpa_t bitmap;
> @@ -5622,7 +5632,7 @@ static bool nested_vmx_exit_handled_msr(struct kvm_vcpu *vcpu,
>  	 * First we need to figure out which of the four to use:
>  	 */
>  	bitmap = vmcs12->msr_bitmap;
> -	if (exit_reason == EXIT_REASON_MSR_WRITE)
> +	if (exit_reason.basic == EXIT_REASON_MSR_WRITE)
>  		bitmap += 2048;
>  	if (msr_index >= 0xc0000000) {
>  		msr_index -= 0xc0000000;
> @@ -5759,11 +5769,12 @@ static bool nested_vmx_exit_handled_mtf(struct vmcs12 *vmcs12)
>   * Return true if L0 wants to handle an exit from L2 regardless of whether or not
>   * L1 wants the exit.  Only call this when in is_guest_mode (L2).
>   */
> -static bool nested_vmx_l0_wants_exit(struct kvm_vcpu *vcpu, u32 exit_reason)
> +static bool nested_vmx_l0_wants_exit(struct kvm_vcpu *vcpu,
> +				     union vmx_exit_reason exit_reason)
>  {
>  	u32 intr_info;
>  
> -	switch ((u16)exit_reason) {
> +	switch (exit_reason.basic) {
>  	case EXIT_REASON_EXCEPTION_NMI:
>  		intr_info = vmx_get_intr_info(vcpu);
>  		if (is_nmi(intr_info))
> @@ -5819,12 +5830,13 @@ static bool nested_vmx_l0_wants_exit(struct kvm_vcpu *vcpu, u32 exit_reason)
>   * Return 1 if L1 wants to intercept an exit from L2.  Only call this when in
>   * is_guest_mode (L2).
>   */
> -static bool nested_vmx_l1_wants_exit(struct kvm_vcpu *vcpu, u32 exit_reason)
> +static bool nested_vmx_l1_wants_exit(struct kvm_vcpu *vcpu,
> +				     union vmx_exit_reason exit_reason)
>  {
>  	struct vmcs12 *vmcs12 = get_vmcs12(vcpu);
>  	u32 intr_info;
>  
> -	switch ((u16)exit_reason) {
> +	switch (exit_reason.basic) {
>  	case EXIT_REASON_EXCEPTION_NMI:
>  		intr_info = vmx_get_intr_info(vcpu);
>  		if (is_nmi(intr_info))
> @@ -5943,7 +5955,7 @@ static bool nested_vmx_l1_wants_exit(struct kvm_vcpu *vcpu, u32 exit_reason)
>  bool nested_vmx_reflect_vmexit(struct kvm_vcpu *vcpu)
>  {
>  	struct vcpu_vmx *vmx = to_vmx(vcpu);
> -	u32 exit_reason = vmx->exit_reason;
> +	union vmx_exit_reason exit_reason = vmx->exit_reason;
>  	unsigned long exit_qual;
>  	u32 exit_intr_info;
>  
> @@ -5962,7 +5974,7 @@ bool nested_vmx_reflect_vmexit(struct kvm_vcpu *vcpu)
>  		goto reflect_vmexit;
>  	}
>  
> -	trace_kvm_nested_vmexit(exit_reason, vcpu, KVM_ISA_VMX);
> +	trace_kvm_nested_vmexit(exit_reason.full, vcpu, KVM_ISA_VMX);
>  
>  	/* If L0 (KVM) wants the exit, it trumps L1's desires. */
>  	if (nested_vmx_l0_wants_exit(vcpu, exit_reason))
> @@ -5988,7 +6000,7 @@ bool nested_vmx_reflect_vmexit(struct kvm_vcpu *vcpu)
>  	exit_qual = vmx_get_exit_qual(vcpu);
>  
>  reflect_vmexit:
> -	nested_vmx_vmexit(vcpu, exit_reason, exit_intr_info, exit_qual);
> +	nested_vmx_vmexit(vcpu, exit_reason.full, exit_intr_info, exit_qual);
>  	return true;
>  }
>  
> diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> index 2af05d3b0590..746b87375aff 100644
> --- a/arch/x86/kvm/vmx/vmx.c
> +++ b/arch/x86/kvm/vmx/vmx.c
> @@ -1577,7 +1577,7 @@ static int skip_emulated_instruction(struct kvm_vcpu *vcpu)
>  	 * i.e. we end up advancing IP with some random value.
>  	 */
>  	if (!static_cpu_has(X86_FEATURE_HYPERVISOR) ||
> -	    to_vmx(vcpu)->exit_reason != EXIT_REASON_EPT_MISCONFIG) {
> +	    to_vmx(vcpu)->exit_reason.basic != EXIT_REASON_EPT_MISCONFIG) {
>  		orig_rip = kvm_rip_read(vcpu);
>  		rip = orig_rip + vmcs_read32(VM_EXIT_INSTRUCTION_LEN);
>  #ifdef CONFIG_X86_64
> @@ -5667,7 +5667,7 @@ static void vmx_get_exit_info(struct kvm_vcpu *vcpu, u64 *info1, u64 *info2,
>  	struct vcpu_vmx *vmx = to_vmx(vcpu);
>  
>  	*info1 = vmx_get_exit_qual(vcpu);
> -	if (!(vmx->exit_reason & VMX_EXIT_REASONS_FAILED_VMENTRY)) {
> +	if (!vmx->exit_reason.failed_vmentry) {
>  		*info2 = vmx->idt_vectoring_info;
>  		*intr_info = vmx_get_intr_info(vcpu);
>  		if (is_exception_with_error_code(*intr_info))
> @@ -5911,8 +5911,9 @@ void dump_vmcs(void)
>  static int vmx_handle_exit(struct kvm_vcpu *vcpu, fastpath_t exit_fastpath)
>  {
>  	struct vcpu_vmx *vmx = to_vmx(vcpu);
> -	u32 exit_reason = vmx->exit_reason;
> +	union vmx_exit_reason exit_reason = vmx->exit_reason;
>  	u32 vectoring_info = vmx->idt_vectoring_info;
> +	u16 exit_handler_index;
>  
>  	/*
>  	 * Flush logged GPAs PML buffer, this will make dirty_bitmap more
> @@ -5954,11 +5955,11 @@ static int vmx_handle_exit(struct kvm_vcpu *vcpu, fastpath_t exit_fastpath)
>  			return 1;
>  	}
>  
> -	if (exit_reason & VMX_EXIT_REASONS_FAILED_VMENTRY) {
> +	if (exit_reason.failed_vmentry) {
>  		dump_vmcs();
>  		vcpu->run->exit_reason = KVM_EXIT_FAIL_ENTRY;
>  		vcpu->run->fail_entry.hardware_entry_failure_reason
> -			= exit_reason;
> +			= exit_reason.full;
>  		vcpu->run->fail_entry.cpu = vcpu->arch.last_vmentry_cpu;
>  		return 0;
>  	}
> @@ -5980,18 +5981,18 @@ static int vmx_handle_exit(struct kvm_vcpu *vcpu, fastpath_t exit_fastpath)
>  	 * will cause infinite loop.
>  	 */
>  	if ((vectoring_info & VECTORING_INFO_VALID_MASK) &&
> -			(exit_reason != EXIT_REASON_EXCEPTION_NMI &&
> -			exit_reason != EXIT_REASON_EPT_VIOLATION &&
> -			exit_reason != EXIT_REASON_PML_FULL &&
> -			exit_reason != EXIT_REASON_APIC_ACCESS &&
> -			exit_reason != EXIT_REASON_TASK_SWITCH)) {
> +	    (exit_reason.basic != EXIT_REASON_EXCEPTION_NMI &&
> +	     exit_reason.basic != EXIT_REASON_EPT_VIOLATION &&
> +	     exit_reason.basic != EXIT_REASON_PML_FULL &&
> +	     exit_reason.basic != EXIT_REASON_APIC_ACCESS &&
> +	     exit_reason.basic != EXIT_REASON_TASK_SWITCH)) {
>  		vcpu->run->exit_reason = KVM_EXIT_INTERNAL_ERROR;
>  		vcpu->run->internal.suberror = KVM_INTERNAL_ERROR_DELIVERY_EV;
>  		vcpu->run->internal.ndata = 3;
>  		vcpu->run->internal.data[0] = vectoring_info;
> -		vcpu->run->internal.data[1] = exit_reason;
> +		vcpu->run->internal.data[1] = exit_reason.full;
>  		vcpu->run->internal.data[2] = vcpu->arch.exit_qualification;
> -		if (exit_reason == EXIT_REASON_EPT_MISCONFIG) {
> +		if (exit_reason.basic == EXIT_REASON_EPT_MISCONFIG) {
>  			vcpu->run->internal.ndata++;
>  			vcpu->run->internal.data[3] =
>  				vmcs_read64(GUEST_PHYSICAL_ADDRESS);
> @@ -6023,38 +6024,39 @@ static int vmx_handle_exit(struct kvm_vcpu *vcpu, fastpath_t exit_fastpath)
>  	if (exit_fastpath != EXIT_FASTPATH_NONE)
>  		return 1;
>  
> -	if (exit_reason >= kvm_vmx_max_exit_handlers)
> +	if (exit_reason.basic >= kvm_vmx_max_exit_handlers)
>  		goto unexpected_vmexit;
>  #ifdef CONFIG_RETPOLINE
> -	if (exit_reason == EXIT_REASON_MSR_WRITE)
> +	if (exit_reason.basic == EXIT_REASON_MSR_WRITE)
>  		return kvm_emulate_wrmsr(vcpu);
> -	else if (exit_reason == EXIT_REASON_PREEMPTION_TIMER)
> +	else if (exit_reason.basic == EXIT_REASON_PREEMPTION_TIMER)
>  		return handle_preemption_timer(vcpu);
> -	else if (exit_reason == EXIT_REASON_INTERRUPT_WINDOW)
> +	else if (exit_reason.basic == EXIT_REASON_INTERRUPT_WINDOW)
>  		return handle_interrupt_window(vcpu);
> -	else if (exit_reason == EXIT_REASON_EXTERNAL_INTERRUPT)
> +	else if (exit_reason.basic == EXIT_REASON_EXTERNAL_INTERRUPT)
>  		return handle_external_interrupt(vcpu);
> -	else if (exit_reason == EXIT_REASON_HLT)
> +	else if (exit_reason.basic == EXIT_REASON_HLT)
>  		return kvm_emulate_halt(vcpu);
> -	else if (exit_reason == EXIT_REASON_EPT_MISCONFIG)
> +	else if (exit_reason.basic == EXIT_REASON_EPT_MISCONFIG)
>  		return handle_ept_misconfig(vcpu);
>  #endif
>  
> -	exit_reason = array_index_nospec(exit_reason,
> -					 kvm_vmx_max_exit_handlers);
> -	if (!kvm_vmx_exit_handlers[exit_reason])
> +	exit_handler_index = array_index_nospec((u16)exit_reason.basic,
> +						kvm_vmx_max_exit_handlers);
> +	if (!kvm_vmx_exit_handlers[exit_handler_index])
>  		goto unexpected_vmexit;
>  
> -	return kvm_vmx_exit_handlers[exit_reason](vcpu);
> +	return kvm_vmx_exit_handlers[exit_handler_index](vcpu);
>  
>  unexpected_vmexit:
> -	vcpu_unimpl(vcpu, "vmx: unexpected exit reason 0x%x\n", exit_reason);
> +	vcpu_unimpl(vcpu, "vmx: unexpected exit reason 0x%x\n",
> +		    exit_reason.full);
>  	dump_vmcs();
>  	vcpu->run->exit_reason = KVM_EXIT_INTERNAL_ERROR;
>  	vcpu->run->internal.suberror =
>  			KVM_INTERNAL_ERROR_UNEXPECTED_EXIT_REASON;
>  	vcpu->run->internal.ndata = 2;
> -	vcpu->run->internal.data[0] = exit_reason;
> +	vcpu->run->internal.data[0] = exit_reason.full;
>  	vcpu->run->internal.data[1] = vcpu->arch.last_vmentry_cpu;
>  	return 0;
>  }
> @@ -6373,9 +6375,9 @@ static void vmx_handle_exit_irqoff(struct kvm_vcpu *vcpu)
>  {
>  	struct vcpu_vmx *vmx = to_vmx(vcpu);
>  
> -	if (vmx->exit_reason == EXIT_REASON_EXTERNAL_INTERRUPT)
> +	if (vmx->exit_reason.basic == EXIT_REASON_EXTERNAL_INTERRUPT)
>  		handle_external_interrupt_irqoff(vcpu);
> -	else if (vmx->exit_reason == EXIT_REASON_EXCEPTION_NMI)
> +	else if (vmx->exit_reason.basic == EXIT_REASON_EXCEPTION_NMI)
>  		handle_exception_nmi_irqoff(vmx);
>  }
>  
> @@ -6567,7 +6569,7 @@ void noinstr vmx_update_host_rsp(struct vcpu_vmx *vmx, unsigned long host_rsp)
>  
>  static fastpath_t vmx_exit_handlers_fastpath(struct kvm_vcpu *vcpu)
>  {
> -	switch (to_vmx(vcpu)->exit_reason) {
> +	switch (to_vmx(vcpu)->exit_reason.basic) {
>  	case EXIT_REASON_MSR_WRITE:
>  		return handle_fastpath_set_msr_irqoff(vcpu);
>  	case EXIT_REASON_PREEMPTION_TIMER:
> @@ -6766,17 +6768,17 @@ static fastpath_t vmx_vcpu_run(struct kvm_vcpu *vcpu)
>  	vmx->idt_vectoring_info = 0;
>  
>  	if (unlikely(vmx->fail)) {
> -		vmx->exit_reason = 0xdead;
> +		vmx->exit_reason.full = 0xdead;
>  		return EXIT_FASTPATH_NONE;
>  	}
>  
> -	vmx->exit_reason = vmcs_read32(VM_EXIT_REASON);
> -	if (unlikely((u16)vmx->exit_reason == EXIT_REASON_MCE_DURING_VMENTRY))
> +	vmx->exit_reason.full = vmcs_read32(VM_EXIT_REASON);
> +	if (unlikely(vmx->exit_reason.basic == EXIT_REASON_MCE_DURING_VMENTRY))
>  		kvm_machine_check();
>  
> -	trace_kvm_exit(vmx->exit_reason, vcpu, KVM_ISA_VMX);
> +	trace_kvm_exit(vmx->exit_reason.full, vcpu, KVM_ISA_VMX);
>  
> -	if (unlikely(vmx->exit_reason & VMX_EXIT_REASONS_FAILED_VMENTRY))
> +	if (unlikely(vmx->exit_reason.failed_vmentry))
>  		return EXIT_FASTPATH_NONE;
>  
>  	vmx->loaded_vmcs->launched = 1;
> diff --git a/arch/x86/kvm/vmx/vmx.h b/arch/x86/kvm/vmx/vmx.h
> index 9d3a557949ac..903f246b5abd 100644
> --- a/arch/x86/kvm/vmx/vmx.h
> +++ b/arch/x86/kvm/vmx/vmx.h
> @@ -70,6 +70,29 @@ struct pt_desc {
>  	struct pt_ctx guest;
>  };
>  
> +union vmx_exit_reason {
> +	struct {
> +		u32	basic			: 16;
> +		u32	reserved16		: 1;
> +		u32	reserved17		: 1;
> +		u32	reserved18		: 1;
> +		u32	reserved19		: 1;
> +		u32	reserved20		: 1;
> +		u32	reserved21		: 1;
> +		u32	reserved22		: 1;
> +		u32	reserved23		: 1;
> +		u32	reserved24		: 1;
> +		u32	reserved25		: 1;
> +		u32	reserved26		: 1;
> +		u32	sgx_enclave_mode	: 1;
> +		u32	smi_pending_mtf		: 1;
> +		u32	smi_from_vmx_root	: 1;
> +		u32	reserved30		: 1;
> +		u32	failed_vmentry		: 1;
> +	};
> +	u32 full;
> +};
> +
>  /*
>   * The nested_vmx structure is part of vcpu_vmx, and holds information we need
>   * for correct emulation of VMX (i.e., nested VMX) on this vcpu.
> @@ -244,7 +267,7 @@ struct vcpu_vmx {
>  	int vpid;
>  	bool emulation_required;
>  
> -	u32 exit_reason;
> +	union vmx_exit_reason exit_reason;
>  
>  	/* Posted interrupt descriptor */
>  	struct pi_desc pi_desc;
> -- 
> 2.29.2
> 
