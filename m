Return-Path: <kvm+bounces-65686-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id CC071CB45FE
	for <lists+kvm@lfdr.de>; Thu, 11 Dec 2025 01:57:36 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id A5217303895A
	for <lists+kvm@lfdr.de>; Thu, 11 Dec 2025 00:55:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 674A6224AE0;
	Thu, 11 Dec 2025 00:55:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="vwhld+nh"
X-Original-To: kvm@vger.kernel.org
Received: from out-178.mta0.migadu.com (out-178.mta0.migadu.com [91.218.175.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A6DB72236E0
	for <kvm@vger.kernel.org>; Thu, 11 Dec 2025 00:55:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765414524; cv=none; b=sF0+Y1TIkBfGYz6e21w/+KYmTHMsJewR7YcT3Pa1KyOW/AKpcW+5AQvur7AGQqUCPBKolBfFRaBwdjTrzJde50ZBgFe15Hc8I1YG2OwTNG++LZkg+IZCzE0urz4q/Tqc1EtOLl9u6Pzmr5HTXVW0antfTHLt2IZKA1hYDT2lqKc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765414524; c=relaxed/simple;
	bh=9Z3CEcqk+qrkqMpbMnrBhFMwhucn6BaIO9ANZDZ9aBU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=YU99ukLTVJhZdFeovMA4DDGyDGbgIaHLZNZLJOrud32HPC1F34i8zQGg1SknGyD+oxzUAC8evNvvN4S51fX/fKaWieBn5DAS38aqVLdT/JZ+EJIfV4hgobGOw+odGeyiRq/ARQHvFqQTG0XQ5kxg/HWBylFSBNjC6nmZ+h7yv44=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=vwhld+nh; arc=none smtp.client-ip=91.218.175.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Date: Thu, 11 Dec 2025 00:55:05 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1765414509;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=m7vmPWIctkqpqYxvtIID/PmzNiRXoLACDDrq+7ryrRU=;
	b=vwhld+nhvZCnBv3yTTc8OIG50C+8xzSXSvauG9AgnsKlqOD/6CEZczEKoKCWz0+DTzK5XF
	mkft5VnlJpGwX7qRogyCOlV9fvEM5FpNestzU7pgCzRevajnR1S+g8hZMecdbzi4YQx2b5
	+340d52+uLMYHx1U9cwEpztlG1Inv1U=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Yosry Ahmed <yosry.ahmed@linux.dev>
To: Sean Christopherson <seanjc@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, Jim Mattson <jmattson@google.com>, 
	kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 10/13] KVM: nSVM: Restrict mapping VMCB12 on nested
 VMRUN
Message-ID: <zozt7pbeqn4ekiyrkwjbesqv6sxf6seyskfbnhzz5do2an4zbl@q6pdskoiawvc>
References: <20251110222922.613224-1-yosry.ahmed@linux.dev>
 <20251110222922.613224-11-yosry.ahmed@linux.dev>
 <aThIQzni6fC1qdgj@google.com>
 <2rmpnqjnyhew3tektl3ndmukbfgs4zrytsaxdgec2i3tggneuk@gphhqbrqevan>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2rmpnqjnyhew3tektl3ndmukbfgs4zrytsaxdgec2i3tggneuk@gphhqbrqevan>
X-Migadu-Flow: FLOW_OUT

On Wed, Dec 10, 2025 at 11:05:44PM +0000, Yosry Ahmed wrote:
> On Tue, Dec 09, 2025 at 08:03:15AM -0800, Sean Christopherson wrote:
> > On Mon, Nov 10, 2025, Yosry Ahmed wrote:
> > > All accesses to the VMCB12 in the guest memory are limited to
> > > nested_svm_vmrun(). However, the VMCB12 remains mapped until the end of
> > > the function execution. Unmapping right after the consistency checks is
> > > possible, but it becomes easy-ish to introduce bugs where 'vmcb12' is
> > > used after being unmapped.
> > > 
> > > Move all accesses to the VMCB12 into a new helper,
> > > nested_svm_vmrun_read_vmcb12(),  that maps the VMCB12,
> > > caches the needed fields, performs consistency checks, and unmaps it.
> > > This limits the scope of the VMCB12 mapping appropriately. It also
> > > slightly simplifies the cleanup path of nested_svm_vmrun().
> > > 
> > > nested_svm_vmrun_read_vmcb12() returns -1 if the consistency checks
> > > fail, maintaining the current behavior of skipping the instructions and
> > > unmapping the VMCB12 (although in the opposite order).
> > > 
> > > Signed-off-by: Yosry Ahmed <yosry.ahmed@linux.dev>
> > > ---
> > >  arch/x86/kvm/svm/nested.c | 59 ++++++++++++++++++++++-----------------
> > >  1 file changed, 34 insertions(+), 25 deletions(-)
> > > 
> > > diff --git a/arch/x86/kvm/svm/nested.c b/arch/x86/kvm/svm/nested.c
> > > index ddcd545ec1c3c..a48668c36a191 100644
> > > --- a/arch/x86/kvm/svm/nested.c
> > > +++ b/arch/x86/kvm/svm/nested.c
> > > @@ -1023,12 +1023,39 @@ int enter_svm_guest_mode(struct kvm_vcpu *vcpu, u64 vmcb12_gpa, bool from_vmrun)
> > >  	return 0;
> > >  }
> > >  
> > > +static int nested_svm_vmrun_read_vmcb12(struct kvm_vcpu *vcpu, u64 vmcb12_gpa)
> > 
> > "read_vmcb12"() sounds like a generic helper to read a specific field.  And if
> > the name is more specific, then I think we can drop the "vmrun" scoping.  To
> > aligh with similar functions in VMX and __nested_copy_vmcb_save_to_cache(), how
> > about nested_svm_copy_vmcb12_to_cache()?
> > 
> > > +{
> > > +	struct vcpu_svm *svm = to_svm(vcpu);
> > > +	struct kvm_host_map map;
> > > +	struct vmcb *vmcb12;
> > > +	int ret;
> > > +
> > > +	ret = kvm_vcpu_map(vcpu, gpa_to_gfn(vmcb12_gpa), &map);
> > > +	if (ret)
> > > +		return ret;
> > > +
> > > +	vmcb12 = map.hva;
> > > +
> > > +	nested_copy_vmcb_control_to_cache(svm, &vmcb12->control);
> > > +	nested_copy_vmcb_save_to_cache(svm, &vmcb12->save);
> > > +
> > > +	if (!nested_vmcb_check_save(vcpu) ||
> > > +	    !nested_vmcb_check_controls(vcpu)) {
> > > +		vmcb12->control.exit_code    = SVM_EXIT_ERR;
> > > +		vmcb12->control.exit_code_hi = 0;
> > > +		vmcb12->control.exit_info_1  = 0;
> > > +		vmcb12->control.exit_info_2  = 0;
> > > +		ret = -1;
> > 
> > I don't love shoving the consistency checks in here.  I get why you did it, but
> > it's very surprising to see (and/or easy to miss) these consistency checks.  The
> > caller also ends up quite wonky:
> > 
> > 	if (ret == -EINVAL) {
> > 		kvm_inject_gp(vcpu, 0);
> > 		return 1;
> > 	} else if (ret) {
> > 		return kvm_skip_emulated_instruction(vcpu);
> > 	}
> > 
> > 	ret = kvm_skip_emulated_instruction(vcpu);
> > 
> > Ha!  And it's buggy.  __kvm_vcpu_map() can return -EFAULT if creating a host
> > mapping fails.  Eww, and blindly using '-1' as the "failed a consistency check"
> > is equally cross, as it relies on kvm_vcpu_map() not returning -EPERM in a very
> > weird way.
> > 
> > Ugh, and there's also this nastiness in nested_vmcb_check_controls():
> > 
> > 	 * Make sure we did not enter guest mode yet, in which case
> > 	 * kvm_read_cr0() could return L2's CR0.
> > 	 */
> > 	WARN_ON_ONCE(is_guest_mode(vcpu));
> > 	return __nested_vmcb_check_controls(vcpu, ctl, kvm_read_cr0(vcpu));
> > 
> > nested_vmcb_check_save() and nested_vmcb_check_controls() really shouldn't exist.
> > They just make it harder to see what KVM is checking in the "normal" flow.
> > 
> > Aha!  And I'm fairly certain there are at least two pre-existing bugs due to KVM
> > doing "early" consistency checks in nested_svm_vmrun().
> > 
> >   1. KVM doesn't clear GIF on the early #VMEXIT.  In classic APM fashion, nothing
> >      _requires_ GIF=0 before VMRUN:
> > 
> >         It is assumed that VMM software cleared GIF some time before executing
> >         the VMRUN instruction, to ensure an atomic state switch.
> > 
> >      And so VMRUN with GIF=1 that hits an "early" consistency check #VMEXIT would
> >      incorrectly leave GIF=1.
> > 
> > 
> >   2. svm_leave_smm() is missing consistency checks on the newly loaded guest state,
> >      because the checks aren't performed by enter_svm_guest_mode().  I don't see
> >      anything that would prevent vmcb12 from being modified by the guest bewteen
> >      SMI and RSM.
> > 
> > Moving the consistency checks into enter_svm_guest_mode() would solve all three
> > (four?) problems.  And as a bonus, nested_svm_copy_vmcb12_to_cache() can use
> > kvm_vcpu_map_readonly().
> > 
> > Compile tested only, but I think we can end up with delta like so:
> > 
> > ---
> >  arch/x86/kvm/svm/nested.c | 67 ++++++++++++---------------------------
> >  1 file changed, 20 insertions(+), 47 deletions(-)
> > 
> > diff --git a/arch/x86/kvm/svm/nested.c b/arch/x86/kvm/svm/nested.c
> > index 7c86987fdaca..8a0df6c535b5 100644
> > --- a/arch/x86/kvm/svm/nested.c
> > +++ b/arch/x86/kvm/svm/nested.c
> > @@ -372,9 +372,9 @@ static bool nested_svm_check_event_inj(struct kvm_vcpu *vcpu, u32 event_inj)
> >  	return true;
> >  }
> >  
> > -static bool __nested_vmcb_check_controls(struct kvm_vcpu *vcpu,
> > -					 struct vmcb_ctrl_area_cached *control,
> > -					 unsigned long l1_cr0)
> > +static bool nested_vmcb_check_controls(struct kvm_vcpu *vcpu,
> > +				       struct vmcb_ctrl_area_cached *control,
> > +				       unsigned long l1_cr0)
> >  {
> >  	if (CC(!vmcb12_is_intercept(control, INTERCEPT_VMRUN)))
> >  		return false;
> > @@ -408,8 +408,8 @@ static bool __nested_vmcb_check_controls(struct kvm_vcpu *vcpu,
> >  }
> >  
> >  /* Common checks that apply to both L1 and L2 state.  */
> > -static bool __nested_vmcb_check_save(struct kvm_vcpu *vcpu,
> > -				     struct vmcb_save_area_cached *save)
> > +static bool nested_vmcb_check_save(struct kvm_vcpu *vcpu,
> > +				   struct vmcb_save_area_cached *save)
> >  {
> >  	if (CC(!(save->efer & EFER_SVME)))
> >  		return false;
> > @@ -448,27 +448,6 @@ static bool __nested_vmcb_check_save(struct kvm_vcpu *vcpu,
> >  	return true;
> >  }
> >  
> > -static bool nested_vmcb_check_save(struct kvm_vcpu *vcpu)
> > -{
> > -	struct vcpu_svm *svm = to_svm(vcpu);
> > -	struct vmcb_save_area_cached *save = &svm->nested.save;
> > -
> > -	return __nested_vmcb_check_save(vcpu, save);
> > -}
> > -
> > -static bool nested_vmcb_check_controls(struct kvm_vcpu *vcpu)
> > -{
> > -	struct vcpu_svm *svm = to_svm(vcpu);
> > -	struct vmcb_ctrl_area_cached *ctl = &svm->nested.ctl;
> > -
> > -	/*
> > -	 * Make sure we did not enter guest mode yet, in which case
> > -	 * kvm_read_cr0() could return L2's CR0.
> > -	 */
> > -	WARN_ON_ONCE(is_guest_mode(vcpu));
> > -	return __nested_vmcb_check_controls(vcpu, ctl, kvm_read_cr0(vcpu));
> > -}
> > -
> >  static
> >  void __nested_copy_vmcb_control_to_cache(struct kvm_vcpu *vcpu,
> >  					 struct vmcb_ctrl_area_cached *to,
> > @@ -1004,6 +983,12 @@ int enter_svm_guest_mode(struct kvm_vcpu *vcpu, u64 vmcb12_gpa, bool from_vmrun)
> >  	nested_svm_copy_common_state(svm->vmcb01.ptr, svm->nested.vmcb02.ptr);
> >  
> >  	svm_switch_vmcb(svm, &svm->nested.vmcb02);
> > +
> > +	if (!nested_vmcb_check_save(vcpu, &svm->nested.save) ||
> > +	    !nested_vmcb_check_controls(vcpu, &svm->nested.ctl,
> > +					svm->vmcb01.ptr->save.cr0))
> > +		return -EINVAL;
> > +
> >  	nested_vmcb02_prepare_control(svm, save->rip, save->cs.base);
> >  	nested_vmcb02_prepare_save(svm);
> >  
> 
> Unfortunately this doesn't work, it breaks the newly introduced
> nested_invalid_cr3_test. The problem is that we bail before we fully
> initialize VMCB02, then nested_svm_vmrun() calls nested_svm_vmexit(),
> which restores state from VMCB02 to VMCB12.
> 
> The test first tries to run L2 with a messed up CR3, which fails but
> corrupts VMCB12 due to the above, then the second nested entry is
> screwed.
> 
> There are two fixes, the easy one is just move the consistency checks
> after nested_vmcb02_prepare_control() and nested_vmcb02_prepare_save()
> (like the existing failure mode of nested_svm_load_cr3()). This works,
> but the code doesn't make a lot of sense because we use VMCB12 to create
> VMCB02 and THEN check that VMCB12 is valid.
> 
> The alternative is unfortunately a lot more involved. We only do a
> partial restore or a "fast #VMEXIT" for failed VMRUNs. We'd need to:
> 
> 1) Move nested_svm_load_cr3() above nested_vmcb02_prepare_control(),
>    which needs moving nested_svm_init_mmu_context() out of
>    nested_vmcb02_prepare_control() to remain before
>    nested_svm_load_cr3().
> 
>    This makes sure a failed nested VMRUN always needs a "fast #VMEXIT"
> 
> 2) Figure out which parts of nested_svm_vmexit() are needed in the
>    failed VMRUN case. We need to at least switch the VMCB, propagate the
>    error code, and do some cleanups. We can split this out into the
>    "fast #VMEXIT" path, and use it for failed VMRUNs.
> 
> Let me know which way you prefer.

I think I prefer (2), the code looks cleaner and I like having a
separate code path for VMRUN failures. Unless there are objections, I
will do that in the next version.

