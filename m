Return-Path: <kvm+bounces-65583-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id B168ECB0D59
	for <lists+kvm@lfdr.de>; Tue, 09 Dec 2025 19:25:37 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 6731530EFC3A
	for <lists+kvm@lfdr.de>; Tue,  9 Dec 2025 18:25:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E31C9301470;
	Tue,  9 Dec 2025 18:24:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="hryABOxV"
X-Original-To: kvm@vger.kernel.org
Received: from out-178.mta0.migadu.com (out-178.mta0.migadu.com [91.218.175.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B7B092FD69E;
	Tue,  9 Dec 2025 18:24:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765304696; cv=none; b=RYzDjdfGMzwx7yCyv0MgI46eTmm5nMeQ6TyWTYA7W29rCuFShFRwgbdvrAcOlSs6T8GRbQ94sFR1ud4z252GilMTbLtrxDU3tix/hucVyLte0klpr5kS0q8j7afdfnjJMJrdKNPcxWr686/bBxiqU43jHHvkk/G1q/GgsVcQYMg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765304696; c=relaxed/simple;
	bh=kxyP/5K6EE5+hIORZwwziU87W+b0WRWKrXMYnF+jQHM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=GyHzdmZXALieKpwNQCRuqcp0JjPW0W2l2e2S9IGYsZl9rT+NSqWLuElAZ/H9DOI8MVTEoaBObt6Jl9BkuEet5RVwMHSM7bYHGFreTkm8tymvvYrnfxNT3euewwpwswH+Pz2+cPKc83xDTDnWQSim7mWvti9pU676KltXbCURPvM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=hryABOxV; arc=none smtp.client-ip=91.218.175.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Date: Tue, 9 Dec 2025 18:24:46 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1765304690;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=5c0KLucL3ySQJV1keYIWwUE8OjaNqzlSZDYq/xIVWEw=;
	b=hryABOxVrLtqVTnspLocP31GdkmfAC0OZ43x03iLzmvu/WHPac3Db/I+tXYX8D3OgOgbh+
	RIDkjxZtkTTMOwZIhaIh5XrWZibq44QHc3MxnNcvg/fGuSCd3a3yJ4zLfxET3daWc61Q6S
	UBEgNYjx8uWeVXnNyO3b3dUmAarXUNI=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Yosry Ahmed <yosry.ahmed@linux.dev>
To: Sean Christopherson <seanjc@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, Jim Mattson <jmattson@google.com>, 
	kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 10/13] KVM: nSVM: Restrict mapping VMCB12 on nested
 VMRUN
Message-ID: <nbkpibgkill4hyuphsju7id5v73lufmas5sammpj6umvhzd25t@y6dkgguq2cuy>
References: <20251110222922.613224-1-yosry.ahmed@linux.dev>
 <20251110222922.613224-11-yosry.ahmed@linux.dev>
 <aThIQzni6fC1qdgj@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aThIQzni6fC1qdgj@google.com>
X-Migadu-Flow: FLOW_OUT

On Tue, Dec 09, 2025 at 08:03:15AM -0800, Sean Christopherson wrote:
> On Mon, Nov 10, 2025, Yosry Ahmed wrote:
> > All accesses to the VMCB12 in the guest memory are limited to
> > nested_svm_vmrun(). However, the VMCB12 remains mapped until the end of
> > the function execution. Unmapping right after the consistency checks is
> > possible, but it becomes easy-ish to introduce bugs where 'vmcb12' is
> > used after being unmapped.
> > 
> > Move all accesses to the VMCB12 into a new helper,
> > nested_svm_vmrun_read_vmcb12(),  that maps the VMCB12,
> > caches the needed fields, performs consistency checks, and unmaps it.
> > This limits the scope of the VMCB12 mapping appropriately. It also
> > slightly simplifies the cleanup path of nested_svm_vmrun().
> > 
> > nested_svm_vmrun_read_vmcb12() returns -1 if the consistency checks
> > fail, maintaining the current behavior of skipping the instructions and
> > unmapping the VMCB12 (although in the opposite order).
> > 
> > Signed-off-by: Yosry Ahmed <yosry.ahmed@linux.dev>
> > ---
> >  arch/x86/kvm/svm/nested.c | 59 ++++++++++++++++++++++-----------------
> >  1 file changed, 34 insertions(+), 25 deletions(-)
> > 
> > diff --git a/arch/x86/kvm/svm/nested.c b/arch/x86/kvm/svm/nested.c
> > index ddcd545ec1c3c..a48668c36a191 100644
> > --- a/arch/x86/kvm/svm/nested.c
> > +++ b/arch/x86/kvm/svm/nested.c
> > @@ -1023,12 +1023,39 @@ int enter_svm_guest_mode(struct kvm_vcpu *vcpu, u64 vmcb12_gpa, bool from_vmrun)
> >  	return 0;
> >  }
> >  
> > +static int nested_svm_vmrun_read_vmcb12(struct kvm_vcpu *vcpu, u64 vmcb12_gpa)
> 
> "read_vmcb12"() sounds like a generic helper to read a specific field.  And if
> the name is more specific, then I think we can drop the "vmrun" scoping.  To
> aligh with similar functions in VMX and __nested_copy_vmcb_save_to_cache(), how
> about nested_svm_copy_vmcb12_to_cache()?

nested_svm_copy_vmcb12_to_cache() sounds good.

> 
> > +{
> > +	struct vcpu_svm *svm = to_svm(vcpu);
> > +	struct kvm_host_map map;
> > +	struct vmcb *vmcb12;
> > +	int ret;
> > +
> > +	ret = kvm_vcpu_map(vcpu, gpa_to_gfn(vmcb12_gpa), &map);
> > +	if (ret)
> > +		return ret;
> > +
> > +	vmcb12 = map.hva;
> > +
> > +	nested_copy_vmcb_control_to_cache(svm, &vmcb12->control);
> > +	nested_copy_vmcb_save_to_cache(svm, &vmcb12->save);
> > +
> > +	if (!nested_vmcb_check_save(vcpu) ||
> > +	    !nested_vmcb_check_controls(vcpu)) {
> > +		vmcb12->control.exit_code    = SVM_EXIT_ERR;
> > +		vmcb12->control.exit_code_hi = 0;
> > +		vmcb12->control.exit_info_1  = 0;
> > +		vmcb12->control.exit_info_2  = 0;
> > +		ret = -1;
> 
> I don't love shoving the consistency checks in here.  I get why you did it, but
> it's very surprising to see (and/or easy to miss) these consistency checks.  The
> caller also ends up quite wonky:
> 
> 	if (ret == -EINVAL) {
> 		kvm_inject_gp(vcpu, 0);
> 		return 1;
> 	} else if (ret) {
> 		return kvm_skip_emulated_instruction(vcpu);
> 	}
> 
> 	ret = kvm_skip_emulated_instruction(vcpu);
> 
> Ha!  And it's buggy.  __kvm_vcpu_map() can return -EFAULT if creating a host
> mapping fails.  Eww, and blindly using '-1' as the "failed a consistency check"
> is equally cross, as it relies on kvm_vcpu_map() not returning -EPERM in a very
> weird way.

I was trying to maintain the pre-existing behavior as much as possible,
and I think the existing code will handle -EFAULT from kvm_vcpu_map() in
the same way (skip the instruction and return).

I guess I shouldn't have assumed maintaining the existing behavior is
the right thing to do.

It's honestly really hard to detangle the return values of different KVM
functions and what they mean. "return 1" here is not very meaningful,
and the return code from kvm_skip_emulated_instruction() is not
documented, so I don't really know what we're supposed to return here in
what cases. The error code are usually not interpreted until a few
layers higher up the callstack.

I agree that returning -1 is not great, but in this case the caller (and
the existing code) only cared about differentiating -EINVAL from others,
and I found other KVM functions returning -1 so I thought I shouldn't
overthink the return value. But yeah, you're right, no more -1's :)

Hence, I preferred to leave things as-is as much as possible.

> 
> Ugh, and there's also this nastiness in nested_vmcb_check_controls():
> 
> 	 * Make sure we did not enter guest mode yet, in which case
> 	 * kvm_read_cr0() could return L2's CR0.
> 	 */
> 	WARN_ON_ONCE(is_guest_mode(vcpu));
> 	return __nested_vmcb_check_controls(vcpu, ctl, kvm_read_cr0(vcpu));
> 
> nested_vmcb_check_save() and nested_vmcb_check_controls() really shouldn't exist.
> They just make it harder to see what KVM is checking in the "normal" flow.
> 
> Aha!  And I'm fairly certain there are at least two pre-existing bugs due to KVM
> doing "early" consistency checks in nested_svm_vmrun().
> 
>   1. KVM doesn't clear GIF on the early #VMEXIT.  In classic APM fashion, nothing
>      _requires_ GIF=0 before VMRUN:
> 
>         It is assumed that VMM software cleared GIF some time before executing
>         the VMRUN instruction, to ensure an atomic state switch.
> 
>      And so VMRUN with GIF=1 that hits an "early" consistency check #VMEXIT would
>      incorrectly leave GIF=1.
> 
> 
>   2. svm_leave_smm() is missing consistency checks on the newly loaded guest state,
>      because the checks aren't performed by enter_svm_guest_mode().  I don't see
>      anything that would prevent vmcb12 from being modified by the guest bewteen
>      SMI and RSM.
> 
> Moving the consistency checks into enter_svm_guest_mode() would solve all three
> (four?) problems.  And as a bonus, nested_svm_copy_vmcb12_to_cache() can use
> kvm_vcpu_map_readonly().

Anyway, I will move the consistency checks as you suggested, I agree
that is much better. Thanks!

> 
> Compile tested only, but I think we can end up with delta like so:
> 
> ---
>  arch/x86/kvm/svm/nested.c | 67 ++++++++++++---------------------------
>  1 file changed, 20 insertions(+), 47 deletions(-)
> 
> diff --git a/arch/x86/kvm/svm/nested.c b/arch/x86/kvm/svm/nested.c
> index 7c86987fdaca..8a0df6c535b5 100644
> --- a/arch/x86/kvm/svm/nested.c
> +++ b/arch/x86/kvm/svm/nested.c
> @@ -372,9 +372,9 @@ static bool nested_svm_check_event_inj(struct kvm_vcpu *vcpu, u32 event_inj)
>  	return true;
>  }
>  
> -static bool __nested_vmcb_check_controls(struct kvm_vcpu *vcpu,
> -					 struct vmcb_ctrl_area_cached *control,
> -					 unsigned long l1_cr0)
> +static bool nested_vmcb_check_controls(struct kvm_vcpu *vcpu,
> +				       struct vmcb_ctrl_area_cached *control,
> +				       unsigned long l1_cr0)
>  {
>  	if (CC(!vmcb12_is_intercept(control, INTERCEPT_VMRUN)))
>  		return false;
> @@ -408,8 +408,8 @@ static bool __nested_vmcb_check_controls(struct kvm_vcpu *vcpu,
>  }
>  
>  /* Common checks that apply to both L1 and L2 state.  */
> -static bool __nested_vmcb_check_save(struct kvm_vcpu *vcpu,
> -				     struct vmcb_save_area_cached *save)
> +static bool nested_vmcb_check_save(struct kvm_vcpu *vcpu,
> +				   struct vmcb_save_area_cached *save)
>  {
>  	if (CC(!(save->efer & EFER_SVME)))
>  		return false;
> @@ -448,27 +448,6 @@ static bool __nested_vmcb_check_save(struct kvm_vcpu *vcpu,
>  	return true;
>  }
>  
> -static bool nested_vmcb_check_save(struct kvm_vcpu *vcpu)
> -{
> -	struct vcpu_svm *svm = to_svm(vcpu);
> -	struct vmcb_save_area_cached *save = &svm->nested.save;
> -
> -	return __nested_vmcb_check_save(vcpu, save);
> -}
> -
> -static bool nested_vmcb_check_controls(struct kvm_vcpu *vcpu)
> -{
> -	struct vcpu_svm *svm = to_svm(vcpu);
> -	struct vmcb_ctrl_area_cached *ctl = &svm->nested.ctl;
> -
> -	/*
> -	 * Make sure we did not enter guest mode yet, in which case
> -	 * kvm_read_cr0() could return L2's CR0.
> -	 */
> -	WARN_ON_ONCE(is_guest_mode(vcpu));
> -	return __nested_vmcb_check_controls(vcpu, ctl, kvm_read_cr0(vcpu));
> -}
> -
>  static
>  void __nested_copy_vmcb_control_to_cache(struct kvm_vcpu *vcpu,
>  					 struct vmcb_ctrl_area_cached *to,
> @@ -1004,6 +983,12 @@ int enter_svm_guest_mode(struct kvm_vcpu *vcpu, u64 vmcb12_gpa, bool from_vmrun)
>  	nested_svm_copy_common_state(svm->vmcb01.ptr, svm->nested.vmcb02.ptr);
>  
>  	svm_switch_vmcb(svm, &svm->nested.vmcb02);
> +
> +	if (!nested_vmcb_check_save(vcpu, &svm->nested.save) ||
> +	    !nested_vmcb_check_controls(vcpu, &svm->nested.ctl,
> +					svm->vmcb01.ptr->save.cr0))
> +		return -EINVAL;
> +
>  	nested_vmcb02_prepare_control(svm, save->rip, save->cs.base);
>  	nested_vmcb02_prepare_save(svm);
>  
> @@ -1025,33 +1010,24 @@ int enter_svm_guest_mode(struct kvm_vcpu *vcpu, u64 vmcb12_gpa, bool from_vmrun)
>  	return 0;
>  }
>  
> -static int nested_svm_vmrun_read_vmcb12(struct kvm_vcpu *vcpu, u64 vmcb12_gpa)
> +static int nested_svm_copy_vmcb12_to_cache(struct kvm_vcpu *vcpu, u64 vmcb12_gpa)
>  {
>  	struct vcpu_svm *svm = to_svm(vcpu);
>  	struct kvm_host_map map;
>  	struct vmcb *vmcb12;
> -	int ret;
> +	int r;
>  
> -	ret = kvm_vcpu_map(vcpu, gpa_to_gfn(vmcb12_gpa), &map);
> -	if (ret)
> -		return ret;
> +	r = kvm_vcpu_map_readonly(vcpu, gpa_to_gfn(vmcb12_gpa), &map);
> +	if (r)
> +		return r;
>  
>  	vmcb12 = map.hva;
>  
>  	nested_copy_vmcb_control_to_cache(svm, &vmcb12->control);
>  	nested_copy_vmcb_save_to_cache(svm, &vmcb12->save);
>  
> -	if (!nested_vmcb_check_save(vcpu) ||
> -	    !nested_vmcb_check_controls(vcpu)) {
> -		vmcb12->control.exit_code    = SVM_EXIT_ERR;
> -		vmcb12->control.exit_code_hi = -1u;
> -		vmcb12->control.exit_info_1  = 0;
> -		vmcb12->control.exit_info_2  = 0;
> -		ret = -1;
> -	}
> -
>  	kvm_vcpu_unmap(vcpu, &map);
> -	return ret;
> +	return 0;
>  }
>  
>  int nested_svm_vmrun(struct kvm_vcpu *vcpu)
> @@ -1082,12 +1058,9 @@ int nested_svm_vmrun(struct kvm_vcpu *vcpu)
>  		return -EINVAL;
>  
>  	vmcb12_gpa = svm->vmcb->save.rax;
> -	ret = nested_svm_vmrun_read_vmcb12(vcpu, vmcb12_gpa);
> -	if (ret == -EINVAL) {
> +	if (nested_svm_copy_vmcb12_to_cache(vcpu, vmcb12_gpa)) {
>  		kvm_inject_gp(vcpu, 0);
>  		return 1;
> -	} else if (ret) {
> -		return kvm_skip_emulated_instruction(vcpu);
>  	}
>  
>  	ret = kvm_skip_emulated_instruction(vcpu);
> @@ -1919,7 +1892,7 @@ static int svm_set_nested_state(struct kvm_vcpu *vcpu,
>  	ret = -EINVAL;
>  	__nested_copy_vmcb_control_to_cache(vcpu, &ctl_cached, ctl);
>  	/* 'save' contains L1 state saved from before VMRUN */
> -	if (!__nested_vmcb_check_controls(vcpu, &ctl_cached, save->cr0))
> +	if (!nested_vmcb_check_controls(vcpu, &ctl_cached, save->cr0))
>  		goto out_free;
>  
>  	/*
> @@ -1938,7 +1911,7 @@ static int svm_set_nested_state(struct kvm_vcpu *vcpu,
>  	if (!(save->cr0 & X86_CR0_PG) ||
>  	    !(save->cr0 & X86_CR0_PE) ||
>  	    (save->rflags & X86_EFLAGS_VM) ||
> -	    !__nested_vmcb_check_save(vcpu, &save_cached))
> +	    !nested_vmcb_check_save(vcpu, &save_cached))
>  		goto out_free;
>  
>  
> 
> base-commit: 01597a665f5dcf8d7cfbedf36f4e6d46d045eb4f
> --
> 

