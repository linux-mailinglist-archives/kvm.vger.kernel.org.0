Return-Path: <kvm+bounces-68202-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id EC534D261BD
	for <lists+kvm@lfdr.de>; Thu, 15 Jan 2026 18:08:46 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 8835E3060595
	for <lists+kvm@lfdr.de>; Thu, 15 Jan 2026 17:05:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E5D963BC4FE;
	Thu, 15 Jan 2026 17:05:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="sOsMiCLA"
X-Original-To: kvm@vger.kernel.org
Received: from out-185.mta0.migadu.com (out-185.mta0.migadu.com [91.218.175.185])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9AE043BB9F4
	for <kvm@vger.kernel.org>; Thu, 15 Jan 2026 17:05:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.185
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768496727; cv=none; b=G6KFLFlD1atoVmiXtKCviFXSPprXW3xnVOHiEV9Y5WiBqtXFJNSlzk5srXc1pvaQI/kBe/1MGe4e9h9yG+ny1rRPXQ6r78AbDtJ8kBSGLkomfPh5Utv2WTM3kCIvfjlck+THneisLdI51R+12tzg3P+9lF/w9dNlVIWd3b/D2IY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768496727; c=relaxed/simple;
	bh=iB/9/GplClxv4ijAsUEFUypu3K8CFlUIld1aVeVAZCU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=c8Sb8yJ9NzMm+XnuWi6I3LKxvQgL6W8DfBG62frmTqFSvJIFWm/1sjQDvL0qfVteThF06Wq+4fwF/JosbK7O0RB4DVQrRthfVTecH78rTyEO+SIw2KAbtBA75rgUxYHH3a3Q0zujboyl+jOYp/H+l/cXrVFtBjgfCNEQjetmZfg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=sOsMiCLA; arc=none smtp.client-ip=91.218.175.185
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Date: Thu, 15 Jan 2026 17:05:10 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1768496714;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=0lHAx5OLzKvG6pBf3LcwPb1ssCPSqGTs0gh6FOWtc5A=;
	b=sOsMiCLAoehAm5UZjK5VjMijgoPp9qQjgCm+Dv2rlOVoFEpL3c16mHdXJXE2sxvVnTyHeo
	d1t5dY9cS5CDmh8j4LurOAM84HSX7XNJ4wEwNKqFtxEcet3Ik9KLi6pGrAsgzd/6ZEqTBU
	viChRPz5jVEONGmovfynRu0SifCBxTU=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Yosry Ahmed <yosry.ahmed@linux.dev>
To: Sean Christopherson <seanjc@google.com>
Cc: Kevin Cheng <chengkev@google.com>, pbonzini@redhat.com, 
	kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH V2 1/5] KVM: SVM: Move STGI and CLGI intercept handling
Message-ID: <ugrjf3qqpeqafg6tnavw6p4l5seapl6mfx6ypypka25shvu6by@pq4qpwn24dyi>
References: <20260112174535.3132800-1-chengkev@google.com>
 <20260112174535.3132800-2-chengkev@google.com>
 <jmacawbcdorwi2y5ulh2l2mdpeulx5sj7qvjehvnhaa5cgdcs3@2tljlprwtl27>
 <aWhFQcNa8SKd679a@google.com>
 <xndoethnkd2djh5zkemvgmuj6gc4hsnxur2uo5frl57ugxa2ql@c3k7cadxmr4u>
 <aWkdF8gz1IDssQOd@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aWkdF8gz1IDssQOd@google.com>
X-Migadu-Flow: FLOW_OUT

On Thu, Jan 15, 2026 at 09:00:07AM -0800, Sean Christopherson wrote:
> On Thu, Jan 15, 2026, Yosry Ahmed wrote:
> > On Wed, Jan 14, 2026 at 05:39:13PM -0800, Sean Christopherson wrote:
> > > On Mon, Jan 12, 2026, Yosry Ahmed wrote:
> > > As for how to fix this, a few ideas:
> > > 
> > >  1. Set KVM_REQ_EVENT to force KVM to re-evulate all events.  kvm_check_and_inject_events()
> > >     will see the pending NMI and/or SMI, that the NMI/SMI is not allowed, and
> > >     re-call enable_{nmi,smi}_window().
> > > 
> > >  2. Manually check for pending+blocked NMI/SMIs.
> > > 
> > >  3. Combine parts of #1 and #2.  Set KVM_REQ_EVENT, but only if there's a pending
> > >     NMI or SMI.
> > > 
> > >  4. Add flags to vcpu_svm to explicitly track if a vCPU has an NMI/SMI window,
> > >     similar to what we're planning on doing for IRQs[*], and use that to more
> > >     confidently do the right thing when recomputing intercepts.
> > > 
> > > I don't love any of those ideas.  Ah, at least not until I poke around KVM.  In
> > > svm_set_gif() there's already this:
> > > 
> > > 		if (svm->vcpu.arch.smi_pending ||
> > > 		    svm->vcpu.arch.nmi_pending ||
> > > 		    kvm_cpu_has_injectable_intr(&svm->vcpu) ||
> > > 		    kvm_apic_has_pending_init_or_sipi(&svm->vcpu))
> > > 			kvm_make_request(KVM_REQ_EVENT, &svm->vcpu);
> > > 
> > > So I think it makes sense to bundle that into a helper, e.g. (no idea what to
> > > call it)
> > > 
> > > static bool svm_think_of_a_good_name(struct kvm_vcpu *vcpu)
> > > {
> > > 	if (svm->vcpu.arch.smi_pending ||
> > > 	    svm->vcpu.arch.nmi_pending ||
> > > 	    kvm_cpu_has_injectable_intr(&svm->vcpu) ||
> > > 	    kvm_apic_has_pending_init_or_sipi(&svm->vcpu))
> > > 		kvm_make_request(KVM_REQ_EVENT, &svm->vcpu);
> > > }
> > 
> > Maybe svm_check_gif_events() or svm_check_gif_interrupts()?
> > 
> > Or maybe it's clearer if we just put the checks in a helper like
> > svm_waiting_for_gif() or svm_pending_gif_interrupt().
> 
> This was my first idea as well, though I would name it svm_has_pending_gif_event()
> to better align with kvm_vcpu_has_events().

svm_has_pending_gif_event() sounds good.

> 
> I suggested a single helper because I don't love that how to react to the pending
> event is duplicated.  But I definitely don't object to open coding the request if
> the consensus is that it's more readable overall.

A single helper is nice, but I can't think of a name that would read
well. My first instinct is svm_check_pending_gif_event(), but we are not
really checking the event as much as requesting for it to be checked.

We can do svm_request_gif_event(), perhaps? Not sure if that's better or
worse than svm_has_pending_gif_event().

> 
> > Then in svm_recalc_instruction_intercepts() we do:
> > 
> > 	/*
> > 	 * If there is a pending interrupt controlled by GIF, set
> > 	 * KVM_REQ_EVENT to re-evaluate if the intercept needs to be set
> > 	 * again to track when GIF is re-enabled (e.g. for NMI
> > 	 * injection).
> > 	 */
> > 	svm_clr_intercept(svm, INTERCEPT_STGI);	
> > 	if (svm_pending_gif_interrupt())
> > 		kvm_make_request(KVM_REQ_EVENT, &svm->vcpu);
> > 
> > and in svm_set_gif() it reads well semantically:
> > 	
> > 	enable_gif(svm);
> > 	if (svm_pending_gif_interrupt())
> > 		kvm_make_request(KVM_REQ_EVENT, &svm->vcpu);

