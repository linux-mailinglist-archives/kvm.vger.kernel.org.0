Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 81CF115420C
	for <lists+kvm@lfdr.de>; Thu,  6 Feb 2020 11:42:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728477AbgBFKmS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 6 Feb 2020 05:42:18 -0500
Received: from mail-pg1-f195.google.com ([209.85.215.195]:33400 "EHLO
        mail-pg1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726538AbgBFKmR (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 6 Feb 2020 05:42:17 -0500
Received: by mail-pg1-f195.google.com with SMTP id 6so2557042pgk.0
        for <kvm@vger.kernel.org>; Thu, 06 Feb 2020 02:42:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=XDbnSYzs9t3amqIAX7ARf7xfzmG+YST7LFjp2/yWWb8=;
        b=Y7WqV82mxBeTNaXrXttMRB+BWN/VYBsdZlegxXROAhvWrF+KVlkF5iGZC9RsOVkvJX
         I1WgSYxPV71oDqrAGTmmzLFDeCAgO97iN0730XT2Fy/XtO1xDnIOPrHdNaD1nXwincLN
         WpJ/boSDy6V408sHLNbDYuGvZsrgbsOWmfwlZ4wsiIA6aiKIuXeQC5dLDF5Ld6w1JyHw
         LbK1DaCh9LHmZ+Tn1pU9u28ugZnPRJTHu4hjN/oeXUGwhi7khTQ1tX7ADg8CU4F8NSUP
         CuG0U0mFc7m52k42qzo/ncYof6KapPVAqy3ubrjmKAw0jnKbnFaCuR2ssyXIs00CiiG8
         t/Iw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=XDbnSYzs9t3amqIAX7ARf7xfzmG+YST7LFjp2/yWWb8=;
        b=UJDGS8PFOhfk8NGcWF7dk42y2zN0v4FMbzxRVVQgfPxXUA4ExwUpdbylqdFpl0xZTO
         47pYRfRcWjumNiToiD49mhfvhybJDyE8j2RWMtFgcL+WTkwjQ/gQJ7AEkeGzRmcwA8Cl
         TbITR3OgJ4ZMu0gw1S4tCP8dRlEE1swPKOaYYdvPMC2J2dIdfHBS3uX48vXTO5ww+7wn
         cp5ktBsfakGnzZwunclZkP+L5vqHaEPp54jegvpD4Zd4GF2jsH+wJWn6f7ykd/SNnp1C
         5KLX0sy5XrOp+ZJ+q79V1pYhwuOJydLeV2/DrTSwIYVDbg/LMW06Abl9B3CrH7wulVhc
         RK0A==
X-Gm-Message-State: APjAAAXtMABqkRNAfePKjI5aYTmbf4uEvnnPIYIzaZW0CozNvMqFAcbB
        uZ8ke7bbJF1r8WbZOFAvhWXQd5Qxk0M=
X-Google-Smtp-Source: APXvYqxjsTiEV3knkDhZVCLmW/WkVkbwqgYd+8G8Sn+gntWeETGbXSfncTcY+K7q42wJlbMn1xZNNw==
X-Received: by 2002:a63:f5c:: with SMTP id 28mr2946792pgp.348.1580985735492;
        Thu, 06 Feb 2020 02:42:15 -0800 (PST)
Received: from google.com ([2620:15c:100:202:d78:d09d:ec00:5fa7])
        by smtp.gmail.com with ESMTPSA id s23sm3031669pjq.17.2020.02.06.02.42.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 06 Feb 2020 02:42:14 -0800 (PST)
Date:   Thu, 6 Feb 2020 02:42:10 -0800
From:   Oliver Upton <oupton@google.com>
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        Jim Mattson <jmattson@google.com>,
        Peter Shier <pshier@google.com>
Subject: Re: [PATCH v2 4/5] KVM: nVMX: Emulate MTF when performing
 instruction emulation
Message-ID: <20200206104210.GC89451@google.com>
References: <20200128092715.69429-1-oupton@google.com>
 <20200128092715.69429-5-oupton@google.com>
 <20200203225814.GK19638@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200203225814.GK19638@linux.intel.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Feb 03, 2020 at 02:58:14PM -0800, Sean Christopherson wrote:
> On Tue, Jan 28, 2020 at 01:27:14AM -0800, Oliver Upton wrote:
> > Since commit 5f3d45e7f282 ("kvm/x86: add support for
> > MONITOR_TRAP_FLAG"), KVM has allowed an L1 guest to use the monitor trap
> > flag processor-based execution control for its L2 guest. KVM simply
> > forwards any MTF VM-exits to the L1 guest, which works for normal
> > instruction execution.
> > 
> > However, when KVM needs to emulate an instruction on the behalf of an L2
> > guest, the monitor trap flag is not emulated. Add the necessary logic to
> > kvm_skip_emulated_instruction() to synthesize an MTF VM-exit to L1 upon
> > instruction emulation for L2.
> > 
> > Fixes: 5f3d45e7f282 ("kvm/x86: add support for MONITOR_TRAP_FLAG")
> > Signed-off-by: Oliver Upton <oupton@google.com>
> > ---
> >  arch/x86/include/asm/kvm_host.h |  1 +
> >  arch/x86/include/uapi/asm/kvm.h |  1 +
> >  arch/x86/kvm/svm.c              |  1 +
> >  arch/x86/kvm/vmx/nested.c       | 37 ++++++++++++++++++++++++++++++++-
> >  arch/x86/kvm/vmx/nested.h       |  5 +++++
> >  arch/x86/kvm/vmx/vmx.c          | 22 ++++++++++++++++++++
> >  arch/x86/kvm/vmx/vmx.h          |  3 +++
> >  arch/x86/kvm/x86.c              | 15 +++++++------
> >  8 files changed, 78 insertions(+), 7 deletions(-)
> > 
> > diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
> > index 69e31dbdfdc2..e1061ebc1b4b 100644
> > --- a/arch/x86/include/asm/kvm_host.h
> > +++ b/arch/x86/include/asm/kvm_host.h
> > @@ -1103,6 +1103,7 @@ struct kvm_x86_ops {
> >  	int (*handle_exit)(struct kvm_vcpu *vcpu,
> >  		enum exit_fastpath_completion exit_fastpath);
> >  	int (*skip_emulated_instruction)(struct kvm_vcpu *vcpu);
> > +	void (*do_singlestep)(struct kvm_vcpu *vcpu);
> >  	void (*set_interrupt_shadow)(struct kvm_vcpu *vcpu, int mask);
> >  	u32 (*get_interrupt_shadow)(struct kvm_vcpu *vcpu);
> >  	void (*patch_hypercall)(struct kvm_vcpu *vcpu,
> > diff --git a/arch/x86/include/uapi/asm/kvm.h b/arch/x86/include/uapi/asm/kvm.h
> > index 503d3f42da16..3f3f780c8c65 100644
> > --- a/arch/x86/include/uapi/asm/kvm.h
> > +++ b/arch/x86/include/uapi/asm/kvm.h
> > @@ -390,6 +390,7 @@ struct kvm_sync_regs {
> >  #define KVM_STATE_NESTED_GUEST_MODE	0x00000001
> >  #define KVM_STATE_NESTED_RUN_PENDING	0x00000002
> >  #define KVM_STATE_NESTED_EVMCS		0x00000004
> > +#define KVM_STATE_NESTED_MTF_PENDING	0x00000008
> >  
> >  #define KVM_STATE_NESTED_SMM_GUEST_MODE	0x00000001
> >  #define KVM_STATE_NESTED_SMM_VMXON	0x00000002
> > diff --git a/arch/x86/kvm/svm.c b/arch/x86/kvm/svm.c
> > index 9dbb990c319a..3653e230d3d5 100644
> > --- a/arch/x86/kvm/svm.c
> > +++ b/arch/x86/kvm/svm.c
> > @@ -7316,6 +7316,7 @@ static struct kvm_x86_ops svm_x86_ops __ro_after_init = {
> >  	.run = svm_vcpu_run,
> >  	.handle_exit = handle_exit,
> >  	.skip_emulated_instruction = skip_emulated_instruction,
> > +	.do_singlestep = NULL,
> >  	.set_interrupt_shadow = svm_set_interrupt_shadow,
> >  	.get_interrupt_shadow = svm_get_interrupt_shadow,
> >  	.patch_hypercall = svm_patch_hypercall,
> > diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
> > index aba16599ca69..0de71b207b2a 100644
> > --- a/arch/x86/kvm/vmx/nested.c
> > +++ b/arch/x86/kvm/vmx/nested.c
> > @@ -3599,8 +3599,15 @@ static int vmx_check_nested_events(struct kvm_vcpu *vcpu, bool external_intr)
> >  	unsigned long exit_qual;
> >  	bool block_nested_events =
> >  	    vmx->nested.nested_run_pending || kvm_event_needs_reinjection(vcpu);
> > +	bool mtf_pending = vmx->nested.mtf_pending;
> >  	struct kvm_lapic *apic = vcpu->arch.apic;
> >  
> > +	/*
> > +	 * Clear the MTF state. If a higher priority VM-exit is delivered first,
> > +	 * this state is discarded.
> > +	 */
> > +	vmx->nested.mtf_pending = false;
> > +
> >  	if (lapic_in_kernel(vcpu) &&
> >  		test_bit(KVM_APIC_INIT, &apic->pending_events)) {
> >  		if (block_nested_events)
> > @@ -3612,8 +3619,30 @@ static int vmx_check_nested_events(struct kvm_vcpu *vcpu, bool external_intr)
> >  		return 0;
> >  	}
> >  
> > +	/*
> > +	 * Process non-debug exceptions first before MTF.
> > +	 */
> >  	if (vcpu->arch.exception.pending &&
> > -		nested_vmx_check_exception(vcpu, &exit_qual)) {
> > +	    !nested_vmx_check_pending_dbg(vcpu) &&
> 
> Oof.  So @has_payload is set %true only by single-step #DB and #PF, and by
> #DBs injected from userspace.  Now I understand where the "pending_dbg()
> comes from.
> 
> The part that gets really confusing is that there's "pending" from KVM's
> perspective, which can be any kind of #DB, e.g. DR7.GD and icebrk, and
> pending from an architectural perspective, which is single-step #DB and
> data #DBs, the latter of which isn't manually emulated by KVM (I think?).
> 
> Not sure if there's a better name than check_pending_dbg(), but either way
> I think a function comment is in order.
>

Completely agree. To somewhat disambiguate the overload of "pending",
I'll add a descriptive comment.

> > +	    nested_vmx_check_exception(vcpu, &exit_qual)) {
> > +		if (block_nested_events)
> > +			return -EBUSY;
> > +		nested_vmx_inject_exception_vmexit(vcpu, exit_qual);
> > +		return 0;
> > +	}
> > +
> > +	if (mtf_pending) {
> > +		if (block_nested_events)
> > +			return -EBUSY;
> > +		if (nested_vmx_check_pending_dbg(vcpu))
> > +			nested_vmx_set_pending_dbg(vcpu);
> > +		nested_vmx_vmexit(vcpu, EXIT_REASON_MONITOR_TRAP_FLAG, 0, 0);
> > +		return 0;
> > +	}
> > +
> > +	if (vcpu->arch.exception.pending &&
> > +	    nested_vmx_check_pending_dbg(vcpu) &&
> > +	    nested_vmx_check_exception(vcpu, &exit_qual)) {
> >  		if (block_nested_events)
> >  			return -EBUSY;
> >  		nested_vmx_inject_exception_vmexit(vcpu, exit_qual);
> > @@ -5705,6 +5734,9 @@ static int vmx_get_nested_state(struct kvm_vcpu *vcpu,
> >  
> >  			if (vmx->nested.nested_run_pending)
> >  				kvm_state.flags |= KVM_STATE_NESTED_RUN_PENDING;
> > +
> > +			if (vmx->nested.mtf_pending)
> > +				kvm_state.flags |= KVM_STATE_NESTED_MTF_PENDING;
> >  		}
> >  	}
> >  
> > @@ -5885,6 +5917,9 @@ static int vmx_set_nested_state(struct kvm_vcpu *vcpu,
> >  	vmx->nested.nested_run_pending =
> >  		!!(kvm_state->flags & KVM_STATE_NESTED_RUN_PENDING);
> >  
> > +	vmx->nested.mtf_pending =
> > +		!!(kvm_state->flags & KVM_STATE_NESTED_MTF_PENDING);
> > +
> >  	ret = -EINVAL;
> >  	if (nested_cpu_has_shadow_vmcs(vmcs12) &&
> >  	    vmcs12->vmcs_link_pointer != -1ull) {
> > diff --git a/arch/x86/kvm/vmx/nested.h b/arch/x86/kvm/vmx/nested.h
> > index fc874d4ead0f..e12461776151 100644
> > --- a/arch/x86/kvm/vmx/nested.h
> > +++ b/arch/x86/kvm/vmx/nested.h
> > @@ -175,6 +175,11 @@ static inline bool nested_cpu_has_virtual_nmis(struct vmcs12 *vmcs12)
> >  	return vmcs12->pin_based_vm_exec_control & PIN_BASED_VIRTUAL_NMIS;
> >  }
> >  
> > +static inline int nested_cpu_has_mtf(struct vmcs12 *vmcs12)
> > +{
> > +	return nested_cpu_has(vmcs12, CPU_BASED_MONITOR_TRAP_FLAG);
> > +}
> > +
> >  static inline int nested_cpu_has_ept(struct vmcs12 *vmcs12)
> >  {
> >  	return nested_cpu_has2(vmcs12, SECONDARY_EXEC_ENABLE_EPT);
> > diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> > index 802ba97ac7f2..5735d1a1af05 100644
> > --- a/arch/x86/kvm/vmx/vmx.c
> > +++ b/arch/x86/kvm/vmx/vmx.c
> > @@ -1601,6 +1601,27 @@ static int skip_emulated_instruction(struct kvm_vcpu *vcpu)
> >  	return 1;
> >  }
> >  
> > +static void vmx_do_singlestep(struct kvm_vcpu *vcpu)
> > +{
> > +	struct vcpu_vmx *vmx;
> > +
> > +	if (!(is_guest_mode(vcpu) &&
> > +	      nested_cpu_has_mtf(get_vmcs12(vcpu))))
> 
> Haven't followed all the paths, but does nested.mtf_pending need to be
> cleared here in case L1 disabled MTF?1

Hmm. I'm unsure of a path that would allow the mtf_pending flag to be
raised but not lowered in vmx_check_nested_events(). Regardless, I can
lower it here should L1 change its MTF control.

> > +		return;
> > +
> > +	vmx = to_vmx(vcpu);
> > +
> > +	/*
> > +	 * Per the SDM, MTF takes priority over debug-trap exception besides
> > +	 * T-bit traps. As instruction emulation is completed (i.e. at the end
> > +	 * of an instruction boundary), any #DB exception pending delivery must
> > +	 * be a debug-trap. Record the pending MTF state to be delivered in
> > +	 * vmx_check_nested_events().
> > +	 */
> > +	vmx->nested.mtf_pending = (!vcpu->arch.exception.pending ||
> > +				   vcpu->arch.exception.nr == DB_VECTOR);
> > +}
> > +
> >  static void vmx_clear_hlt(struct kvm_vcpu *vcpu)
> >  {
> >  	/*
> > @@ -7797,6 +7818,7 @@ static struct kvm_x86_ops vmx_x86_ops __ro_after_init = {
> >  	.run = vmx_vcpu_run,
> >  	.handle_exit = vmx_handle_exit,
> >  	.skip_emulated_instruction = skip_emulated_instruction,
> > +	.do_singlestep = vmx_do_singlestep,
> >  	.set_interrupt_shadow = vmx_set_interrupt_shadow,
> >  	.get_interrupt_shadow = vmx_get_interrupt_shadow,
> >  	.patch_hypercall = vmx_patch_hypercall,
> > diff --git a/arch/x86/kvm/vmx/vmx.h b/arch/x86/kvm/vmx/vmx.h
> > index a4f7f737c5d4..401e9ca23779 100644
> > --- a/arch/x86/kvm/vmx/vmx.h
> > +++ b/arch/x86/kvm/vmx/vmx.h
> > @@ -150,6 +150,9 @@ struct nested_vmx {
> >  	/* L2 must run next, and mustn't decide to exit to L1. */
> >  	bool nested_run_pending;
> >  
> > +	/* Pending MTF VM-exit into L1.  */
> > +	bool mtf_pending;
> > +
> >  	struct loaded_vmcs vmcs02;
> >  
> >  	/*
> > diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> > index 9f080101618c..e5c859f9b3bf 100644
> > --- a/arch/x86/kvm/x86.c
> > +++ b/arch/x86/kvm/x86.c
> > @@ -6626,10 +6626,15 @@ static int kvm_vcpu_check_hw_bp(unsigned long addr, u32 type, u32 dr7,
> >  	return dr6;
> >  }
> >  
> > -static int kvm_vcpu_do_singlestep(struct kvm_vcpu *vcpu)
> > +static int kvm_vcpu_do_singlestep(struct kvm_vcpu *vcpu, bool tf)
> >  {
> >  	struct kvm_run *kvm_run = vcpu->run;
> >  
> > +	if (kvm_x86_ops->do_singlestep)
> > +		kvm_x86_ops->do_singlestep(vcpu);
> > +	if (!tf)
> > +		return 1;
> > +
> >  	if (vcpu->guest_debug & KVM_GUESTDBG_SINGLESTEP) {
> >  		kvm_run->debug.arch.dr6 = DR6_BS | DR6_FIXED_1 | DR6_RTM;
> >  		kvm_run->debug.arch.pc = vcpu->arch.singlestep_rip;
> > @@ -6658,9 +6663,7 @@ int kvm_skip_emulated_instruction(struct kvm_vcpu *vcpu)
> >  	 * processor will not generate this exception after the instruction
> >  	 * that sets the TF flag".
> >  	 */
> > -	if (unlikely(rflags & X86_EFLAGS_TF))
> > -		r = kvm_vcpu_do_singlestep(vcpu);
> > -	return r;
> > +	return kvm_vcpu_do_singlestep(vcpu, rflags & X86_EFLAGS_TF);
> 
> The extra retpoline, i.e. ->do_singlestep(), can be avoided by handling
> the kvm_skip_emulated_instruction() purely in VMX:
> 
> diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> index 802ba97ac7f2..4e6373caea53 100644
> --- a/arch/x86/kvm/vmx/vmx.c
> +++ b/arch/x86/kvm/vmx/vmx.c
> @@ -1601,6 +1601,20 @@ static int skip_emulated_instruction(struct kvm_vcpu *vcpu)
>         return 1;
>  }
> 
> +static int vmx_skip_emulated_instruction(struct kvm_vcpu *vcpu)
> +{
> +       if (is_guest_mode(vcpu)) {
> +               if (nested_cpu_has_mtf(get_vmcs12(vcpu) &&
> +                   (!vcpu->arch.exception.pending ||
> +                    vcpu->arch.exception.nr == DB_VECTOR)))
> +                       to_vmx(vcpu)->nested.mtf_pending = true;
> +               else
> +                       to_vmx(vcpu)->nested.mtf_pending = false;
> +       }
> +
> +       return skip_emulated_instruction(vcpu);
> +}
> +
>  static void vmx_clear_hlt(struct kvm_vcpu *vcpu)
>  {
>         /*
> @@ -7796,7 +7810,7 @@ static struct kvm_x86_ops vmx_x86_ops __ro_after_init = {
> 
>         .run = vmx_vcpu_run,
>         .handle_exit = vmx_handle_exit,
> -       .skip_emulated_instruction = skip_emulated_instruction,
> +       .skip_emulated_instruction = vmx_skip_emulated_instruction,
>         .set_interrupt_shadow = vmx_set_interrupt_shadow,
>         .get_interrupt_shadow = vmx_get_interrupt_shadow,
>         .patch_hypercall = vmx_patch_hypercall,
> 
> >  }

Awesome, thank you for the suggestion. I'll work this in :)

> >  EXPORT_SYMBOL_GPL(kvm_skip_emulated_instruction);
> >  
> > @@ -6876,8 +6879,8 @@ int x86_emulate_instruction(struct kvm_vcpu *vcpu, gpa_t cr2_or_gpa,
> >  		if (!ctxt->have_exception ||
> >  		    exception_type(ctxt->exception.vector) == EXCPT_TRAP) {
> >  			kvm_rip_write(vcpu, ctxt->eip);
> > -			if (r && ctxt->tf)
> > -				r = kvm_vcpu_do_singlestep(vcpu);
> > +			if (r)
> > +				r = kvm_vcpu_do_singlestep(vcpu, ctxt->tf);
> 
> Hrm.  I like the current code of calling do_singlestep() iff EFLAGS.TF=1.
> The non-emulator case can be handled purely in VMX, per above.  Maybe do
> something similar for the emulator with a generic "emulated instruction"
> hook?  Not sure what to call it...
> 
> 			kvm_x86_ops->update_emulated_instruction(vcpu);

Yeah, agreed. I'll add in a hook for the emulator to do this rather than
reworking do_singlestep().

> >  			__kvm_set_rflags(vcpu, ctxt->eflags);
> >  		}
> >  
> > -- 
> > 2.25.0.341.g760bfbb309-goog

Thanks Sean!
