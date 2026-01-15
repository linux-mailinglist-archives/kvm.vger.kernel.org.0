Return-Path: <kvm+bounces-68198-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id C2832D25CEC
	for <lists+kvm@lfdr.de>; Thu, 15 Jan 2026 17:43:26 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 43E2730B557D
	for <lists+kvm@lfdr.de>; Thu, 15 Jan 2026 16:41:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E21213BB9FE;
	Thu, 15 Jan 2026 16:41:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="IQzHoeCN"
X-Original-To: kvm@vger.kernel.org
Received: from out-188.mta0.migadu.com (out-188.mta0.migadu.com [91.218.175.188])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B83F03B8D70
	for <kvm@vger.kernel.org>; Thu, 15 Jan 2026 16:41:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.188
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768495281; cv=none; b=LA5HvMTMBxU82CVHm7iahVg/NA33QpjhBnrZNDhmwWVieBvf+UYc/d+A3xn2kM/ecOaeQZTQKL4C5dMLs7Rc+/1ICHEm5LaBp+vIVsmIRP6wN7omzVm7qB0+iTJmUaRChlINosaNGha1WVaUV/uavWTp1FAwmRaAm3c5yzIO4rc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768495281; c=relaxed/simple;
	bh=EtqGFA2TgkqT7zMrghlWo8Lttz+ZV93Wp2MKPAFzHfY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ETVZEaeRS9n0C+BvTM+WqNot/pmWpIvnMbB6tw7UPCUVzRpl+o+ES0uaBF8cApvB8CZ29yuSyFp0FxJ5S7npH1C54wzMh/t0lqr2QViAD1AtTtZH8yyW3nNdsv8Xav62P7P+jCBC/F2Qv6Ar4EQdf0F5g1cmXM7WeRQZWlzVkqQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=IQzHoeCN; arc=none smtp.client-ip=91.218.175.188
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Date: Thu, 15 Jan 2026 16:41:09 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1768495277;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=5Lt87JnvFdmh1Bqw9ySHApB4AuurghTdhAelm3BbQnI=;
	b=IQzHoeCNonMUpXqLeXuJwm8TrtSy6QQ+Ld7bUdAOfoUdqfc5Ke0vY1SlBWy/rWUOEyCNGd
	KKaUI7BczRtqKkULnA0JEtdxPE7DVOLwoh6Ftgbvb5+l+atQdtcR7VYQSSnuZyfnq4DBrn
	6+3w9PwLaynWvuP+ARQNqAYbNUoZtzI=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Yosry Ahmed <yosry.ahmed@linux.dev>
To: Sean Christopherson <seanjc@google.com>
Cc: Kevin Cheng <chengkev@google.com>, pbonzini@redhat.com, 
	kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH V2 1/5] KVM: SVM: Move STGI and CLGI intercept handling
Message-ID: <xndoethnkd2djh5zkemvgmuj6gc4hsnxur2uo5frl57ugxa2ql@c3k7cadxmr4u>
References: <20260112174535.3132800-1-chengkev@google.com>
 <20260112174535.3132800-2-chengkev@google.com>
 <jmacawbcdorwi2y5ulh2l2mdpeulx5sj7qvjehvnhaa5cgdcs3@2tljlprwtl27>
 <aWhFQcNa8SKd679a@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aWhFQcNa8SKd679a@google.com>
X-Migadu-Flow: FLOW_OUT

On Wed, Jan 14, 2026 at 05:39:13PM -0800, Sean Christopherson wrote:
> On Mon, Jan 12, 2026, Yosry Ahmed wrote:
> > On Mon, Jan 12, 2026 at 05:45:31PM +0000, Kevin Cheng wrote:
> > > Similar to VMLOAD/VMSAVE intercept handling, move the STGI/CLGI
> > > intercept handling to svm_recalc_instruction_intercepts().
> > > ---
> > >  arch/x86/kvm/svm/svm.c | 10 ++++++----
> > >  1 file changed, 6 insertions(+), 4 deletions(-)
> > > 
> > > diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
> > > index 24d59ccfa40d9..6373a25d85479 100644
> > > --- a/arch/x86/kvm/svm/svm.c
> > > +++ b/arch/x86/kvm/svm/svm.c
> > > @@ -1010,6 +1010,11 @@ static void svm_recalc_instruction_intercepts(struct kvm_vcpu *vcpu)
> > >  			svm_clr_intercept(svm, INTERCEPT_VMSAVE);
> > >  			svm->vmcb->control.virt_ext |= VIRTUAL_VMLOAD_VMSAVE_ENABLE_MASK;
> > >  		}
> > > +
> > > +		if (vgif) {
> > > +			svm_clr_intercept(svm, INTERCEPT_STGI);
> > 
> > Could this cause a problem with NMI window tracking?
> 
> Yes.
> 
> > svm_enable_nmi_window() sets INTERCEPT_STGI to detect when NMIs are
> > enabled, and it's later cleared by svm_set_gif(). If we recalc
> > intercepts in between we will clear the intercept here and miss NMI
> > enablement.
> > 
> > We could move the logic to set/clear INTERCEPT_STGI for NMI window
> > tracking here as well, but then we'll need to recalc intercepts in
> > svm_enable_nmi_window() and svm_set_gif(), which could be expensive.
> > 
> > The alternative is perhaps setting a flag when INTERCEPT_STGI is set in
> > svm_enable_nmi_window() and avoid clearing the intercept here if the
> > flag is set.
> > 
> > Not sure what's the best way forward here.
> 
> First things first, the changelog needs to state _why_ the code is being moved.
> "To be like VMLOAD/VMSAVE" doesn't suffice, because my initial answer was going
> to be "well just don't move the code" (I already forgot the context of v1).
> 
> But moving the code is needed to fix the missing #UD in "Recalc instructions
> intercepts when EFER.SVME is toggled".
> 
> As for how to fix this, a few ideas:
> 
>  1. Set KVM_REQ_EVENT to force KVM to re-evulate all events.  kvm_check_and_inject_events()
>     will see the pending NMI and/or SMI, that the NMI/SMI is not allowed, and
>     re-call enable_{nmi,smi}_window().
> 
>  2. Manually check for pending+blocked NMI/SMIs.
> 
>  3. Combine parts of #1 and #2.  Set KVM_REQ_EVENT, but only if there's a pending
>     NMI or SMI.
> 
>  4. Add flags to vcpu_svm to explicitly track if a vCPU has an NMI/SMI window,
>     similar to what we're planning on doing for IRQs[*], and use that to more
>     confidently do the right thing when recomputing intercepts.
> 
> I don't love any of those ideas.  Ah, at least not until I poke around KVM.  In
> svm_set_gif() there's already this:
> 
> 		if (svm->vcpu.arch.smi_pending ||
> 		    svm->vcpu.arch.nmi_pending ||
> 		    kvm_cpu_has_injectable_intr(&svm->vcpu) ||
> 		    kvm_apic_has_pending_init_or_sipi(&svm->vcpu))
> 			kvm_make_request(KVM_REQ_EVENT, &svm->vcpu);
> 
> So I think it makes sense to bundle that into a helper, e.g. (no idea what to
> call it)
> 
> static bool svm_think_of_a_good_name(struct kvm_vcpu *vcpu)
> {
> 	if (svm->vcpu.arch.smi_pending ||
> 	    svm->vcpu.arch.nmi_pending ||
> 	    kvm_cpu_has_injectable_intr(&svm->vcpu) ||
> 	    kvm_apic_has_pending_init_or_sipi(&svm->vcpu))
> 		kvm_make_request(KVM_REQ_EVENT, &svm->vcpu);
> }

Maybe svm_check_gif_events() or svm_check_gif_interrupts()?

Or maybe it's clearer if we just put the checks in a helper like
svm_waiting_for_gif() or svm_pending_gif_interrupt().


Then in svm_recalc_instruction_intercepts() we do:

	/*
	 * If there is a pending interrupt controlled by GIF, set
	 * KVM_REQ_EVENT to re-evaluate if the intercept needs to be set
	 * again to track when GIF is re-enabled (e.g. for NMI
	 * injection).
	 */
	svm_clr_intercept(svm, INTERCEPT_STGI);	
	if (svm_pending_gif_interrupt())
		kvm_make_request(KVM_REQ_EVENT, &svm->vcpu);

and in svm_set_gif() it reads well semantically:
	
	enable_gif(svm);
	if (svm_pending_gif_interrupt())
		kvm_make_request(KVM_REQ_EVENT, &svm->vcpu);

> 
> And then call that from svm_recalc_instruction_intercepts().  That implements #3
> in a fairly maintainable way (we'll hopefully notice sooner than later if we break
> svm_set_gif()).
> 
> https://lore.kernel.org/all/26732815475bf1c5ba672bc3b1785265f1a994e6.1752819570.git.naveen@kernel.org
> 

