Return-Path: <kvm+bounces-70274-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id wPVoIiPXg2lbuwMAu9opvQ
	(envelope-from <kvm+bounces-70274-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Thu, 05 Feb 2026 00:32:51 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 31390ED4AD
	for <lists+kvm@lfdr.de>; Thu, 05 Feb 2026 00:32:51 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 6646F301AA63
	for <lists+kvm@lfdr.de>; Wed,  4 Feb 2026 23:30:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C42363A0B27;
	Wed,  4 Feb 2026 23:30:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="QnIo9Req"
X-Original-To: kvm@vger.kernel.org
Received: from out-178.mta0.migadu.com (out-178.mta0.migadu.com [91.218.175.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B430F352FAC;
	Wed,  4 Feb 2026 23:30:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770247812; cv=none; b=aBQ5nilffKgdEkCYHzouYhzXnvsb9jKLsLhUdYXP/tege/H9vmyFiLsJS2Qf75yXElVEBCCs8VIieJqg0Ridbyq6Kc/iLuuYGooU0mMUWlhDbVLn5sGWdcOZvqqHkPAeM+34FSXYBtAGIHr7ma/4HGbbjvq93AH81AFB/9cJ2Bs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770247812; c=relaxed/simple;
	bh=ncV/+XlXcahUV86B/Ie8Gza9lJtP62dfWEk1fRwygVU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=CQS1/ivzwoMHGMr6y3mAGihyvNS7uymHCaNIcmfufdPAKrNki3LlBkJhFF/rtIiPraSJWc6PrnkeVoJrVO8W/+epWuy4jBfOTdzgKidAFae6d7g+jWVO82dF+mXUdThs5/D1KyP7pgiMxFGdqmTiVcTIekE6w6DB12pjtKO4F0M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=QnIo9Req; arc=none smtp.client-ip=91.218.175.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Date: Wed, 4 Feb 2026 23:30:04 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1770247808;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=f8QD6Tg6WJg3hAyaG5M3CFWRhGITIEhI/q0e4gkzH4I=;
	b=QnIo9ReqNwSq8PLQd3YoPA7sFS09RZ51vHuamzubBdLJ7SSf9SSFzdpeivTATf3ZgrY/RV
	5n7a0LJKdZCo4ZTV8Aib3y55ObPtV59ga2GdnaMphL0RyU3emVzdcaASh1n0pParQtQ5X1
	C9aTGWb//cAILLvXjfcBm/ttW/AfvH8=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Yosry Ahmed <yosry.ahmed@linux.dev>
To: Sean Christopherson <seanjc@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/3] KVM: nSVM: Do not track EFER.SVME toggling in guest
 mode
Message-ID: <byogsjz2vljtzvr7ar4wefm3mrzqxboujz2yugsszgrtkluyks@phifb333vw45>
References: <20260130020735.2517101-1-yosry.ahmed@linux.dev>
 <20260130020735.2517101-3-yosry.ahmed@linux.dev>
 <aYO3AaBqbPy_9XdD@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aYO3AaBqbPy_9XdD@google.com>
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-1.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[linux.dev,none];
	MID_RHS_NOT_FQDN(0.50)[];
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10:c];
	R_DKIM_ALLOW(-0.20)[linux.dev:s=key1];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-70274-lists,kvm=lfdr.de];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCVD_COUNT_THREE(0.00)[3];
	DKIM_TRACE(0.00)[linux.dev:+];
	FROM_HAS_DN(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	TO_DN_SOME(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[yosry.ahmed@linux.dev,kvm@vger.kernel.org];
	RCPT_COUNT_THREE(0.00)[4];
	NEURAL_HAM(-0.00)[-0.999];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	TAGGED_RCPT(0.00)[kvm];
	MISSING_XM_UA(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: 31390ED4AD
X-Rspamd-Action: no action

On Wed, Feb 04, 2026 at 01:15:45PM -0800, Sean Christopherson wrote:
> The shortlog is *very* misleading.  The changelog isn't much better.  This isn't
> just removing "tracking", it's redefining guest visible behavior and effectively
> changing the KVM virtual CPU microarchitecture.
> 
> On Fri, Jan 30, 2026, Yosry Ahmed wrote:
> > KVM tracks when EFER.SVME is set and cleared to initialize and tear down
> > nested state. However, it doesn't differentiate if EFER.SVME is getting
> > toggled in L1 or L2+. Toggling EFER.SVME in L2+ is inconsequential from
> > KVM's perspective, as the vCPU is still obviously using nested.
> > 
> > This causes a problem if L2 sets then clears EFER.SVME without L1
> > interception, as KVM exits guest mode and tears down nested state while
> > L2 is running, executing L1 without injecting a proper #VMEXIT.
> > 
> > Technically, it's not a bug as the APM states that an L1 hypervisor
> > should intercept EFER writes:
> > 
> > 	The effect of turning off EFER.SVME while a guest is running is
> > 	undefined; therefore, the VMM should always prevent guests from
> > 	writing EFER.
> > 
> > However, it would be nice if KVM handled it more gracefully.
> 
> That's not sufficient justification for this change.  Nothing will ever trip this
> code unless it's _trying_ to trip this code.  I.e.  Outside of a bespoke selftest
> that is little more than "make sure the kernel doesn't explode", and future
> malicious actors, KVM's behavior is largely irrelevant.
> 
> > Signed-off-by: Yosry Ahmed <yosry.ahmed@linux.dev>
> > ---
> >  arch/x86/kvm/svm/svm.c | 7 +++++++
> >  1 file changed, 7 insertions(+)
> > 
> > diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
> > index 4575a6a7d6c4e..eaf0f8053fbfb 100644
> > --- a/arch/x86/kvm/svm/svm.c
> > +++ b/arch/x86/kvm/svm/svm.c
> > @@ -208,6 +208,13 @@ static int svm_set_efer_svme(struct kvm_vcpu *vcpu, u64 old_efer, u64 new_efer)
> >  	if ((old_efer & EFER_SVME) == (new_efer & EFER_SVME))
> >  		return 0;
> >  
> > +	/*
> > +	 * An L2 guest setting or clearing EFER_SVME does not change whether or
> > +	 * not the vCPU can use nested from KVM's perspective.
> 
> This should call out that the architectural behavior is undefined.  "from KVM's
> perspective" is an obtuse way of saying "KVM is making up behavior because it
> can".  E.g. something like
> 
> 	/*
> 	 * Architecturally, clearing EFER.SVME while a guest is running yields
> 	 * undefined behavior, i.e. KVM has carte blance to do anything if L1
> 	 * doesn't intercept writes to EFER.  Simply do nothing, because XYZ.
> 	 */
> 
> > +	 */
> > +	if (is_guest_mode(vcpu))
> 
> This is fine, because svm_allocate_nested() plays nice with redundant calls, but
> this is a rather scary change for something that straight up doesn't happen in
> practice.  Any hypervisor that doesn't intercept EFER is broken, period.
> 
> E.g. if a future change adds novel code that's guarded by the
> 
> 	if ((old_efer & EFER_SVME) == (new_efer & EFER_SVME)) 
> 		return 0;
> 
> check, then doing nothing here could result in a guest-exploitable bug.  In other
> words, from a kernel safety perspective, "doing nothing" is more dangerous than
> forcibly leaving nested mode, because doing nothing deliberately puts KVM in an
> inconsistent state.  Given that there's basically zero benefit in practice, I'm
> strongly inclined to keep the call svm_leave_nested().
> 
> All that said, I agree that pulling the rug out from under the VM is a terrible
> experience.  What if we throw a triple fault at the vCPU so that L1 gets an
> immediate SHUTDOWN (not a VM-Exit, a SHUTDOWN of the L1 vCPU), instead of running
> random garbage from L2?

I am fine with this too, anything is better than pulling the rug. I will
send a v2 and probably drop patch 1 (unless you prefer that we keep it).

> 
> diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
> index 5f0136dbdde6..ccd73a3be3f9 100644
> --- a/arch/x86/kvm/svm/svm.c
> +++ b/arch/x86/kvm/svm/svm.c
> @@ -216,6 +216,17 @@ int svm_set_efer(struct kvm_vcpu *vcpu, u64 efer)
>  
>         if ((old_efer & EFER_SVME) != (efer & EFER_SVME)) {
>                 if (!(efer & EFER_SVME)) {
> +                       /*
> +                        * Architecturally, clearing EFER.SVME while a guest is
> +                        * running yields undefined behavior, i.e. KVM can do
> +                        * literally anything.  Force the vCPU back into L1 as
> +                        * that is the safest option for KVM, but synthesize a
> +                        * triple fault (for L1!) so that KVM at least doesn't
> +                        * run random L2 code in the context of L1.
> +                        */
> +                       if (is_guest_mode(vcpu))
> +                               kvm_make_request(KVM_REQ_TRIPLE_FAULT, vcpu);
> +
>                         svm_leave_nested(vcpu);
>                         /* #GP intercept is still needed for vmware backdoor */
>                         if (!enable_vmware_backdoor)
> 
> 
> > +		return 0;
> > +
> >  	if (new_efer & EFER_SVME) {
> >  		r = svm_allocate_nested(svm);
> >  		if (r)
> > -- 
> > 2.53.0.rc1.225.gd81095ad13-goog
> > 

