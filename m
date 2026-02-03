Return-Path: <kvm+bounces-70026-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id uL3uBOEogmnPPgMAu9opvQ
	(envelope-from <kvm+bounces-70026-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Tue, 03 Feb 2026 17:57:05 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [IPv6:2600:3c15:e001:75::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 32577DC5EA
	for <lists+kvm@lfdr.de>; Tue, 03 Feb 2026 17:57:04 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id D726330327F2
	for <lists+kvm@lfdr.de>; Tue,  3 Feb 2026 16:52:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 85AF23D3329;
	Tue,  3 Feb 2026 16:52:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="dgyDwT3S"
X-Original-To: kvm@vger.kernel.org
Received: from out-173.mta1.migadu.com (out-173.mta1.migadu.com [95.215.58.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E8BF63AE6FE
	for <kvm@vger.kernel.org>; Tue,  3 Feb 2026 16:52:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770137528; cv=none; b=EtS3YBNT/qgsvA78Up0My+0IfoozziFpFmHTU7DfGDsCozV4bNjgGDeqfD2DI+3JGiBl4uY8/BFhCRnQb93QI0pOkaX5CUedtLJiHD682tYASTHrvf8KQSHzELZs6TUWQZol2fP7lRkUZCrVY7y4SbklsRZyVyKo+oCIV82TMhw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770137528; c=relaxed/simple;
	bh=Kir+RZwXYlukUwqcQ1MFAGvo9N0ZGz1Z0UrH984nPTA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=oysqmBLMM7PesTkI/oSZSDrCZNbH5s8tBvD6cGUPYzzt84O9k9i9Bvlqh+xF+cP+y7EEmruI7WNYe5wTTMorZtIE/a4Q4CjpsLC9vVbeTypTf8/YDu8GnkZQYCA2+AKyWf4YiWtpP8dq3UiwVejU6E0Fs6q29lW+7EBYPu+UlcA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=dgyDwT3S; arc=none smtp.client-ip=95.215.58.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Date: Tue, 3 Feb 2026 16:51:46 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1770137515;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=0ufO1d/0O1VANyhQxUyy20ZNYQMIjN+juU2tLb9Rry0=;
	b=dgyDwT3SK1ktva7vEaPp5uHBgC9u8VB8PTYOZ6V4XC1yIFUxezlNMIWvhKgy7AC2iJ0FRe
	kxKgDDQ0IIYj1L/M4wLO0JaCuQlo6Lo/nEE5xp5ZF6oax60L28oV59PBIIhqLxi2eGKf7J
	Kuez0CcspLj2O/RxpT9L811eJBgXD48=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Yosry Ahmed <yosry.ahmed@linux.dev>
To: Sean Christopherson <seanjc@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] KVM: nSVM: Use vcpu->arch.cr2 when updating vmcb12 on
 nested #VMEXIT
Message-ID: <i4xpbma5acebgissizta7abydnwdn2hbdhgqxnb5gyxsjnx6q7@5ayraj5trdtl>
References: <20260203011320.1314791-1-yosry.ahmed@linux.dev>
 <aYIebtv3nNnsqUiZ@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aYIebtv3nNnsqUiZ@google.com>
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-1.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[linux.dev,none];
	MID_RHS_NOT_FQDN(0.50)[];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c15:e001:75::/64:c];
	R_DKIM_ALLOW(-0.20)[linux.dev:s=key1];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-70026-lists,kvm=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	DKIM_TRACE(0.00)[linux.dev:+];
	RCVD_COUNT_THREE(0.00)[3];
	FROM_HAS_DN(0.00)[];
	MISSING_XM_UA(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[yosry.ahmed@linux.dev,kvm@vger.kernel.org];
	RCPT_COUNT_THREE(0.00)[4];
	NEURAL_HAM(-0.00)[-1.000];
	ASN(0.00)[asn:63949, ipnet:2600:3c15::/32, country:SG];
	TAGGED_RCPT(0.00)[kvm];
	MIME_TRACE(0.00)[0:+];
	TO_DN_SOME(0.00)[]
X-Rspamd-Queue-Id: 32577DC5EA
X-Rspamd-Action: no action

On Tue, Feb 03, 2026 at 08:12:30AM -0800, Sean Christopherson wrote:
> On Tue, Feb 03, 2026, Yosry Ahmed wrote:
> > KVM currently uses the value of CR2 from vmcb02 to update vmcb12 on
> > nested #VMEXIT. Use the value from vcpu->arch.cr2 instead.
> > 
> > The value in vcpu->arch.cr2 is sync'd to vmcb02 shortly before a VMRUN
> > of L2, and sync'd back to vcpu->arch.cr2 shortly after. The value are
> > only out-of-sync in two cases: after migration, and after a #PF is
> 
> Nit, instead of "migration", talk about state save/restore, and then list live
> migration as an example.  Most of the time it's fairly obvious that "migration"
> in KVM means "live migration", but not always.  E.g. task migration often comes
> into play, as does page migration.
> 
> And more importantly, the above statement is wrong when state is saved/restored
> for something other than migration.  E.g. if userspace is restoring a snapshot
> for reasons other than migrating a VM.

Makes sense, will fix.

> 
> > injected into L2.
> > 
> > After migration, the value of CR2 in vmcb02 is uninitialized (i.e.
> 
> save/restore
> 
> > zero),
> 
> This isn't guaranteed.  E.g. if state is restored into a vCPU that was already
> running, vmcb02.save.cr2 could hold any number of things.

Good point, I missed that case.

> 
> > as KVM_SET_SREGS restores CR2 value to vcpu->arch.cr2. Using
> > vcpu->arch.cr2 to update vmcb12 is the right thing to do.
> > 
> > The #PF injection case is more nuanced. It occurs if KVM injects a #PF
> > into L2, then exits to L1 before it actually runs L2. Although the APM
> > is a bit unclear about when CR2 is written during a #PF, the SDM is more
> > clear:
> > 
> > 	Processors update CR2 whenever a page fault is detected. If a
> > 	second page fault occurs while an earlier page fault is being
> > 	delivered, the faulting linear address of the second fault will
> > 	overwrite the contents of CR2 (replacing the previous address).
> > 	These updates to CR2 occur even if the page fault results in a
> > 	double fault or occurs during the delivery of a double fault.
> > 
> > KVM injecting the exception surely counts as the #PF being "detected".
> 
> Heh, "detected" is definitely poor wording in the SDM.
> 
> > More importantly, when an exception is injected into L2 at the time of a
> > synthesized #VMEXIT, KVM updates exit_int_info in vmcb12 accordingly,
> > such that an L1 hypervisor can re-inject the exception. If CR2 is not
> > written at that point, the L1 hypervisor have no way of correctly
> > re-injecting the #PF. Hence, using vcpu->arch.cr2 is also the right
> > thing to write in vmcb12 in this case.
> > 
> > Note that KVM does _not_ update vcpu->arch.cr2 when a #PF is pending for
> > L2, only when it is injected. The distinction is important, because only
> > injected exceptions are propagated to L1 through exit_int_info. It would
> > be incorrect to update CR2 in vmcb12 for a pending #PF, as L1 would
> > perceive an updated CR2 value with no #PF. Update the comment in
> > kvm_deliver_exception_payload() to clarify this.
> > 
> > Signed-off-by: Yosry Ahmed <yosry.ahmed@linux.dev>
> > ---
> >  arch/x86/kvm/svm/nested.c | 2 +-
> >  arch/x86/kvm/x86.c        | 7 +++++++
> >  2 files changed, 8 insertions(+), 1 deletion(-)
> > 
> > diff --git a/arch/x86/kvm/svm/nested.c b/arch/x86/kvm/svm/nested.c
> > index de90b104a0dd5..9031746ce2db1 100644
> > --- a/arch/x86/kvm/svm/nested.c
> > +++ b/arch/x86/kvm/svm/nested.c
> > @@ -1156,7 +1156,7 @@ int nested_svm_vmexit(struct vcpu_svm *svm)
> >  	vmcb12->save.efer   = svm->vcpu.arch.efer;
> >  	vmcb12->save.cr0    = kvm_read_cr0(vcpu);
> >  	vmcb12->save.cr3    = kvm_read_cr3(vcpu);
> > -	vmcb12->save.cr2    = vmcb02->save.cr2;
> > +	vmcb12->save.cr2    = vcpu->arch.cr2;
> >  	vmcb12->save.cr4    = svm->vcpu.arch.cr4;
> >  	vmcb12->save.rflags = kvm_get_rflags(vcpu);
> >  	vmcb12->save.rip    = kvm_rip_read(vcpu);
> > diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> > index db3f393192d94..1015522d0fbd7 100644
> > --- a/arch/x86/kvm/x86.c
> > +++ b/arch/x86/kvm/x86.c
> > @@ -864,6 +864,13 @@ static void kvm_multiple_exception(struct kvm_vcpu *vcpu, unsigned int nr,
> >  		vcpu->arch.exception.error_code = error_code;
> >  		vcpu->arch.exception.has_payload = has_payload;
> >  		vcpu->arch.exception.payload = payload;
> > +		/*
> > +		 * Only injected exceptions are propagated to L1 in
> > +		 * vmcb12/vmcs12 on nested #VMEXIT. Hence, do not deliver the
> 
> Nit, #VMEXIT is SVM specific terminology.  VM-Exit is more vendor agnostic.

Will do.

> 
> > +		 * exception payload for L2 until the exception is injected.
> > +		 * Otherwise, L1 would perceive the updated payload without a
> > +		 * corresponding exception.
> 
> Huh.  I'm fairly certain this code is now at best unnecessary, and at worst
> actively harmful.  Because the more architectural way to document this code is:
> 
> 		/*
> 		 * If L2 is active, defer delivery of the payload until the
> 		 * exception is actually injected to avoid clobbering state if
> 		 * L1 wants to intercept the exception (the architectural state
> 		 * is NOT updated if the exeption is morphed to a VM-Exit).
> 		 */

It's not only about exceptions being morphed to a VM-Exit though, is it?
KVM should not update the payload (e.g. CR2) if a #PF is pending but was
not injected, because from L1's perspective CR2 was updated but
exit_int_info won't reflect a #PF. Right?

> 
> But thanks to commit 7709aba8f716 ("KVM: x86: Morph pending exceptions to pending
> VM-Exits at queue time"), KVM already *knows* the exception won't be morphed to a
> VM-Exit.
> 
> Ugh, and I'm pretty sure I botched kvm_vcpu_ioctl_x86_get_vcpu_events() in that
> commit.  Because invoking kvm_deliver_exception_payload() when the exception was
> morphed to a VM-Exit is wrong.  Oh, wait, this is the !exception_payload_enabled
> case.  So never mind, that's simply an unfixable bug, as the second comment alludes
> to.

Hmm for the #PF case I think delivering the payload is always wrong if
it was morphed to a VM-Exit, regardless of exception_payload_enabled,
because the payload should never reach CR2, right?

Spoiler alert, there's another problem there. Even if the exception did
not morph to a VM-Exit, if userspace already did KVM_GET_SREGS then the
delivered payload is lost :/

> 
> 	/*
> 	 * KVM's ABI only allows for one exception to be migrated.  Luckily,
> 	 * the only time there can be two queued exceptions is if there's a
> 	 * non-exiting _injected_ exception, and a pending exiting exception.
> 	 * In that case, ignore the VM-Exiting exception as it's an extension
> 	 * of the injected exception.
> 	 */
> 	if (vcpu->arch.exception_vmexit.pending &&
> 	    !vcpu->arch.exception.pending &&
> 	    !vcpu->arch.exception.injected)
> 		ex = &vcpu->arch.exception_vmexit;
> 	else
> 		ex = &vcpu->arch.exception;
> 
> 	/*
> 	 * In guest mode, payload delivery should be deferred if the exception
> 	 * will be intercepted by L1, e.g. KVM should not modifying CR2 if L1
> 	 * intercepts #PF, ditto for DR6 and #DBs.  If the per-VM capability,
> 	 * KVM_CAP_EXCEPTION_PAYLOAD, is not set, userspace may or may not
> 	 * propagate the payload and so it cannot be safely deferred.  Deliver
> 	 * the payload if the capability hasn't been requested.
> 	 */
> 	if (!vcpu->kvm->arch.exception_payload_enabled &&
> 	    ex->pending && ex->has_payload)
> 		kvm_deliver_exception_payload(vcpu, ex);
> 
> So yeah, I _think_ we could drop the is_guest_mode() check.  However, even better
> would be to drop this call *entirely*, i.e.

Hmm I don't think so, because as I mentioned above, KVM shouldn't update
CR2 until the exception is actually injected, right?

It would actually be great to drop the is_guest_mode() check here but
leave the call, because the ordering problem between KVM_VCPU_SET_EVENTS
and KVM_SET_SREGS goes away, and I *think* we can drop the
kvm_deliver_exception_payload() call in
kvm_vcpu_ioctl_x86_get_vcpu_events().

The only problem would be CR2 getting updated without a fault being
reflected in the vmcb12's exit_int_info AFAICT.

> 
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index b0112c515584..00a39c95631d 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -864,9 +864,6 @@ static void kvm_multiple_exception(struct kvm_vcpu *vcpu, unsigned int nr,
>                 vcpu->arch.exception.error_code = error_code;
>                 vcpu->arch.exception.has_payload = has_payload;
>                 vcpu->arch.exception.payload = payload;
> -               if (!is_guest_mode(vcpu))
> -                       kvm_deliver_exception_payload(vcpu,
> -                                                     &vcpu->arch.exception);
>                 return;
>         }
>  
> Because KVM really shouldn't update CR2 until the excpetion is actually injected
> (or the state is at risk of being lost because exception_payload_enabled==false).
> E.g. in the (extremely) unlikely (and probably impossible to configure reliably)
> scenario that userspace deliberately drops a pending exception, arch state shouldn't
> be updated.

I think if we drop it there might be a problem. With
exception_payload_enabled==false, pending exceptions becomes injected
after save/restore. If the payload is not delivered here, then after
restore we have an injected event with no payload.

I guess the kvm_deliver_exception_payload() call in
kvm_vcpu_ioctl_x86_get_vcpu_events() is supposed to handle this, but it
only works if userspace does KVM_GET_SREGS *after* KVM_GET_VCPU_EVENTS.
Removing the call here will regress VMM's doing KVM_GET_SREGS AFAICT.

> 
> > +		 */
> >  		if (!is_guest_mode(vcpu))
> >  			kvm_deliver_exception_payload(vcpu,
> >  						      &vcpu->arch.exception);
> > -- 
> > 2.53.0.rc2.204.g2597b5adb4-goog
> > 

