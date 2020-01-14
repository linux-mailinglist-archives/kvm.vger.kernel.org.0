Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1BA71139DC4
	for <lists+kvm@lfdr.de>; Tue, 14 Jan 2020 01:05:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729121AbgANAFT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 13 Jan 2020 19:05:19 -0500
Received: from mga01.intel.com ([192.55.52.88]:41480 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728810AbgANAFT (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 13 Jan 2020 19:05:19 -0500
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by fmsmga101.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 13 Jan 2020 16:05:18 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.69,430,1571727600"; 
   d="scan'208";a="424476905"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.202])
  by fmsmga006.fm.intel.com with ESMTP; 13 Jan 2020 16:05:18 -0800
Date:   Mon, 13 Jan 2020 16:05:18 -0800
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Oliver Upton <oupton@google.com>
Cc:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        Peter Shier <pshier@google.com>,
        Jim Mattson <jmattson@google.com>
Subject: Re: [PATCH 2/3] KVM: x86: Emulate MTF when performing instruction
 emulation
Message-ID: <20200114000517.GC14928@linux.intel.com>
References: <20200113221053.22053-1-oupton@google.com>
 <20200113221053.22053-3-oupton@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200113221053.22053-3-oupton@google.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Jan 13, 2020 at 02:10:52PM -0800, Oliver Upton wrote:
> Since commit 5f3d45e7f282 ("kvm/x86: add support for
> MONITOR_TRAP_FLAG"), KVM has allowed an L1 guest to use the monitor trap
> flag processor-based execution control for its L2 guest. KVM simply
> forwards any MTF VM-exits to the L1 guest, which works for normal
> instruction execution.
> 
> However, when KVM needs to emulate an instruction on the behalf of an L2
> guest, the monitor trap flag is not emulated. Add the necessary logic to
> kvm_skip_emulated_instruction() to synthesize an MTF VM-exit to L1 upon
> instruction emulation for L2.

This only fixes the flows where KVM is doing "fast" emulation, or whatever
you want to call it.  The full emulation paths are still missing proper MTF
support.  Dunno if it makes sense to fix it all at once, e.g. if the full
emulation is stupid complex, but at a minimum the gaps should be called out
with a brief explanation of why they're not being addressed.

> Fixes: 5f3d45e7f282 ("kvm/x86: add support for MONITOR_TRAP_FLAG")
> 
> Signed-off-by: Oliver Upton <oupton@google.com>
> Reviewed-by: Peter Shier <pshier@google.com>
> Reviewed-by: Jim Mattson <jmattson@google.com>
> ---
>  arch/x86/include/asm/kvm_host.h |  1 +
>  arch/x86/kvm/svm.c              |  5 +++++
>  arch/x86/kvm/vmx/nested.c       |  2 +-
>  arch/x86/kvm/vmx/nested.h       |  5 +++++
>  arch/x86/kvm/vmx/vmx.c          | 19 +++++++++++++++++++
>  arch/x86/kvm/x86.c              |  6 ++++++
>  6 files changed, 37 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
> index 4739ca11885d..89dcdc7201ae 100644
> --- a/arch/x86/include/asm/kvm_host.h
> +++ b/arch/x86/include/asm/kvm_host.h
> @@ -1092,6 +1092,7 @@ struct kvm_x86_ops {
>  	void (*run)(struct kvm_vcpu *vcpu);
>  	int (*handle_exit)(struct kvm_vcpu *vcpu);
>  	int (*skip_emulated_instruction)(struct kvm_vcpu *vcpu);
> +	void (*emulation_complete)(struct kvm_vcpu *vcpu);
>  	void (*set_interrupt_shadow)(struct kvm_vcpu *vcpu, int mask);
>  	u32 (*get_interrupt_shadow)(struct kvm_vcpu *vcpu);
>  	void (*patch_hypercall)(struct kvm_vcpu *vcpu,
> diff --git a/arch/x86/kvm/svm.c b/arch/x86/kvm/svm.c
> index 16ded16af997..f21eec4443d5 100644
> --- a/arch/x86/kvm/svm.c
> +++ b/arch/x86/kvm/svm.c
> @@ -802,6 +802,10 @@ static int skip_emulated_instruction(struct kvm_vcpu *vcpu)
>  	return 1;
>  }
>  
> +static void svm_emulation_complete(struct kvm_vcpu *vcpu)
> +{
> +}
> +
>  static void svm_queue_exception(struct kvm_vcpu *vcpu)
>  {
>  	struct vcpu_svm *svm = to_svm(vcpu);
> @@ -7320,6 +7324,7 @@ static struct kvm_x86_ops svm_x86_ops __ro_after_init = {
>  	.run = svm_vcpu_run,
>  	.handle_exit = handle_exit,
>  	.skip_emulated_instruction = skip_emulated_instruction,
> +	.emulation_complete = svm_emulation_complete,
>  	.set_interrupt_shadow = svm_set_interrupt_shadow,
>  	.get_interrupt_shadow = svm_get_interrupt_shadow,
>  	.patch_hypercall = svm_patch_hypercall,
> diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
> index 4aea7d304beb..ee26f2d10a09 100644
> --- a/arch/x86/kvm/vmx/nested.c
> +++ b/arch/x86/kvm/vmx/nested.c
> @@ -5578,7 +5578,7 @@ bool nested_vmx_exit_reflected(struct kvm_vcpu *vcpu, u32 exit_reason)
>  	case EXIT_REASON_MWAIT_INSTRUCTION:
>  		return nested_cpu_has(vmcs12, CPU_BASED_MWAIT_EXITING);
>  	case EXIT_REASON_MONITOR_TRAP_FLAG:
> -		return nested_cpu_has(vmcs12, CPU_BASED_MONITOR_TRAP_FLAG);
> +		return nested_cpu_has_mtf(vmcs12);
>  	case EXIT_REASON_MONITOR_INSTRUCTION:
>  		return nested_cpu_has(vmcs12, CPU_BASED_MONITOR_EXITING);
>  	case EXIT_REASON_PAUSE_INSTRUCTION:
> diff --git a/arch/x86/kvm/vmx/nested.h b/arch/x86/kvm/vmx/nested.h
> index fc874d4ead0f..901d2745bc93 100644
> --- a/arch/x86/kvm/vmx/nested.h
> +++ b/arch/x86/kvm/vmx/nested.h
> @@ -238,6 +238,11 @@ static inline bool nested_cpu_has_save_preemption_timer(struct vmcs12 *vmcs12)
>  	    VM_EXIT_SAVE_VMX_PREEMPTION_TIMER;
>  }
>  
> +static inline bool nested_cpu_has_mtf(struct vmcs12 *vmcs12)
> +{
> +	return nested_cpu_has(vmcs12, CPU_BASED_MONITOR_TRAP_FLAG);
> +}
> +
>  /*
>   * In nested virtualization, check if L1 asked to exit on external interrupts.
>   * For most existing hypervisors, this will always return true.
> diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> index 148696199c88..8d3b693c3d3a 100644
> --- a/arch/x86/kvm/vmx/vmx.c
> +++ b/arch/x86/kvm/vmx/vmx.c
> @@ -1595,6 +1595,24 @@ static int skip_emulated_instruction(struct kvm_vcpu *vcpu)
>  	return 1;
>  }
>  
> +static void vmx_emulation_complete(struct kvm_vcpu *vcpu)
> +{
> +	if (!(is_guest_mode(vcpu) &&
> +	      nested_cpu_has_mtf(get_vmcs12(vcpu))))
> +		return;
> +
> +	/*
> +	 * Per the SDM, MTF takes priority over debug-trap instructions. As

Except for T-bit #DBs.  Thankfully KVM doesn't emulate them.  :-D

> +	 * instruction emulation is completed (i.e. at the instruction
> +	 * boundary), any #DB exception must be a trap. Emulate an MTF VM-exit
> +	 * into L1 should there be a debug-trap exception pending or no
> +	 * exception pending.
> +	 */
> +	if (!vcpu->arch.exception.pending ||
> +	    vcpu->arch.exception.nr == DB_VECTOR)
> +		nested_vmx_vmexit(vcpu, EXIT_REASON_MONITOR_TRAP_FLAG, 0, 0);

Doing a direct nested_vmx_vmexit() in kvm_skip_emulated_instruction() feels
like a hack.  It might work for now, i.e. while only the "fast" emulation
paths deal with MTF, but I have a feeling that we'll want MTF handling to
live in vmx_check_nested_events(), or possibly in a custom callback that is
invoked from similar call sites.

Actually, I thought of a case it breaks.  If HLT is passed through from
L1->L2, this approach will process the VM-Exit prior to handling the HLT
in L0.  KVM will record the wrong activity state in vmcs12 ("active"
instead of "halted") and then incorrectly put L1 into KVM_MP_STATE_HALTED.

Another case, which may or may not be possible, is if INIT is recognized
on the same instruction, in which case it takes priority over MTF.  SMI
might also be an issue.

> +}
> +
>  static void vmx_clear_hlt(struct kvm_vcpu *vcpu)
>  {
>  	/*
> @@ -7831,6 +7849,7 @@ static struct kvm_x86_ops vmx_x86_ops __ro_after_init = {
>  	.run = vmx_vcpu_run,
>  	.handle_exit = vmx_handle_exit,
>  	.skip_emulated_instruction = skip_emulated_instruction,
> +	.emulation_complete = vmx_emulation_complete,
>  	.set_interrupt_shadow = vmx_set_interrupt_shadow,
>  	.get_interrupt_shadow = vmx_get_interrupt_shadow,
>  	.patch_hypercall = vmx_patch_hypercall,
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index c14174c033e4..d3af7a8a3c4b 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -6546,6 +6546,12 @@ int kvm_skip_emulated_instruction(struct kvm_vcpu *vcpu)
>  	 */
>  	if (unlikely(rflags & X86_EFLAGS_TF))
>  		r = kvm_vcpu_do_singlestep(vcpu);
> +	/*
> +	 * Allow for vendor-specific handling of completed emulation before
> +	 * returning.
> +	 */
> +	if (r)
> +		kvm_x86_ops->emulation_complete(vcpu);
>  	return r;
>  }
>  EXPORT_SYMBOL_GPL(kvm_skip_emulated_instruction);
> -- 
> 2.25.0.rc1.283.g88dfdc4193-goog
> 
