Return-Path: <kvm+bounces-70253-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id CI6DJzyFg2llowMAu9opvQ
	(envelope-from <kvm+bounces-70253-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Wed, 04 Feb 2026 18:43:24 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [IPv6:2600:3c09:e001:a7::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 37D7CEB11D
	for <lists+kvm@lfdr.de>; Wed, 04 Feb 2026 18:43:24 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id B2C563006696
	for <lists+kvm@lfdr.de>; Wed,  4 Feb 2026 17:43:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C87F834B691;
	Wed,  4 Feb 2026 17:43:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="aBdku6nk"
X-Original-To: kvm@vger.kernel.org
Received: from out-177.mta1.migadu.com (out-177.mta1.migadu.com [95.215.58.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AD076348865
	for <kvm@vger.kernel.org>; Wed,  4 Feb 2026 17:43:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770226997; cv=none; b=VsxCwGUA7nXV+WTMDQXoDI7iUGkPZKusi16g4mp7ZAiMYLePRUqQWdek0KhH4JuEeGlTEFXwaUZLotQMrT52fQngHumvAvWyogDzFcfRYNn66MnTEcf3xixeFQu+QOGczqBYgFE8AZZCwmr0wzAiCGJSRzP3NIOy/uZZqz8K/CI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770226997; c=relaxed/simple;
	bh=9QeESlkiR0kKLeJJEurX3oQWM+VbaJYyJYHoywNLHaA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=e31ZYXDX7r1nU7fRZ0IuAYKtUDbJQhOGEtpfephg7zwQMW8xpTLEGhAU3CIf85NLWkve7xkN95Hp8fn0bjlbr7oPGDdMhZnpWZg58GvJyHHUciseolMeb7S/LQetQYivu+TzLTsgYP4TShQtVvWQee4jMRVgiHypUWJ9v9l4i3Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=aBdku6nk; arc=none smtp.client-ip=95.215.58.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Date: Wed, 4 Feb 2026 17:43:00 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1770226994;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=mDPOk9WuTW6rVquPxZZ1ahv03uHyiJLZcftv4VaieyY=;
	b=aBdku6nkg1/FcZNabmCCO+9i9YysJPzZYKrXsytT3tbAUqHYOj/MmvJkUcwovxC4LLrmY4
	Zh5zi477wzDm6M+4gSXzex4W2vjhafKsEXP/cT3mcUq08ykf86vtgqhyj8/voXGBwObac5
	ZmULEzuY+zYFx+b4XeI3Vjgo/0FbQ24=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Yosry Ahmed <yosry.ahmed@linux.dev>
To: Sean Christopherson <seanjc@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, Kevin Cheng <chengkev@google.com>, 
	kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/3] KVM: nSVM: Use intuitive local variables in
 recalc_intercepts()
Message-ID: <gmdou4cp47vpx72tw3mwklwixpd3ujcdcomoplosv2u2tzfub2@wtqgzkhguoap>
References: <20260112182022.771276-1-yosry.ahmed@linux.dev>
 <20260112182022.771276-2-yosry.ahmed@linux.dev>
 <aYOCAH8zLLXllou7@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aYOCAH8zLLXllou7@google.com>
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-1.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MID_RHS_NOT_FQDN(0.50)[];
	DMARC_POLICY_ALLOW(-0.50)[linux.dev,none];
	R_DKIM_ALLOW(-0.20)[linux.dev:s=key1];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c09:e001:a7::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	RCVD_COUNT_THREE(0.00)[3];
	FORGED_SENDER_MAILLIST(0.00)[];
	TAGGED_FROM(0.00)[bounces-70253-lists,kvm=lfdr.de];
	MIME_TRACE(0.00)[0:+];
	FROM_HAS_DN(0.00)[];
	MISSING_XM_UA(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[yosry.ahmed@linux.dev,kvm@vger.kernel.org];
	DKIM_TRACE(0.00)[linux.dev:+];
	NEURAL_HAM(-0.00)[-0.999];
	ASN(0.00)[asn:63949, ipnet:2600:3c09::/32, country:SG];
	TAGGED_RCPT(0.00)[kvm];
	TO_DN_SOME(0.00)[];
	RCPT_COUNT_FIVE(0.00)[5]
X-Rspamd-Queue-Id: 37D7CEB11D
X-Rspamd-Action: no action

On Wed, Feb 04, 2026 at 09:29:36AM -0800, Sean Christopherson wrote:
> On Mon, Jan 12, 2026, Yosry Ahmed wrote:
> > recalc_intercepts() currently uses c, h, g as local variables for the
> > control area of the current VMCB, vmcb01, and (cached) vmcb12.
> > 
> > The current VMCB should always be vmcb02 when recalc_intercepts() is
> > executed in guest mode. Use vmcb01/vmcb02 local variables instead to
> > make it clear the function is updating intercepts in vmcb02 based on the
> > intercepts in vmcb01 and (cached) vmcb12.
> > 
> > Add a WARNING() if the current VMCB is not in fact vmcb02.
> 
> This belongs in a separate patch.
> 
> > No functional change intended.
> > 
> > Signed-off-by: Yosry Ahmed <yosry.ahmed@linux.dev>
> > ---
> >  arch/x86/kvm/svm/nested.c | 31 +++++++++++++++----------------
> >  1 file changed, 15 insertions(+), 16 deletions(-)
> > 
> > diff --git a/arch/x86/kvm/svm/nested.c b/arch/x86/kvm/svm/nested.c
> > index f295a41ec659..2dda52221fd8 100644
> > --- a/arch/x86/kvm/svm/nested.c
> > +++ b/arch/x86/kvm/svm/nested.c
> > @@ -125,8 +125,7 @@ static bool nested_vmcb_needs_vls_intercept(struct vcpu_svm *svm)
> >  
> >  void recalc_intercepts(struct vcpu_svm *svm)
> >  {
> > -	struct vmcb_control_area *c, *h;
> > -	struct vmcb_ctrl_area_cached *g;
> > +	struct vmcb *vmcb01, *vmcb02;
> >  	unsigned int i;
> >  
> >  	vmcb_mark_dirty(svm->vmcb, VMCB_INTERCEPTS);
> > @@ -134,14 +133,14 @@ void recalc_intercepts(struct vcpu_svm *svm)
> >  	if (!is_guest_mode(&svm->vcpu))
> >  		return;
> >  
> > -	c = &svm->vmcb->control;
> > -	h = &svm->vmcb01.ptr->control;
> > -	g = &svm->nested.ctl;
> > +	vmcb01 = svm->vmcb01.ptr;
> > +	vmcb02 = svm->nested.vmcb02.ptr;
> > +	WARN_ON_ONCE(svm->vmcb != vmcb02);
> 
> If we're going to bother with a WARN, then this code should definitely bail,
> because configuring vmcb01 using the nested logic is all but guaranteed to break
> L1 in weird ways.

I can put the WARN + bail in a separate patch.

> 
> >  	for (i = 0; i < MAX_INTERCEPT; i++)
> > -		c->intercepts[i] = h->intercepts[i];
> > +		vmcb02->control.intercepts[i] = vmcb01->control.intercepts[i];
> >  
> > -	if (g->int_ctl & V_INTR_MASKING_MASK) {
> > +	if (svm->nested.ctl.int_ctl & V_INTR_MASKING_MASK) {
> 
> I vote to keep a pointer to the cached control as vmcb12_ctrl.  Coming from a
> nVMX-focused background, I can never remember what svm->nested.ctl holds.  For
> me, this is waaaay more intuivite:

I agree it reads better, but honestly all of nSVM code uses
svm->nested.ctl, and changing its name here just makes things
inconsistent imo.

> 
> 	if (vmcb12_ctrl->int_ctl & V_INTR_MASKING_MASK) {
> 
> >  	for (i = 0; i < MAX_INTERCEPT; i++)
> > -		c->intercepts[i] |= g->intercepts[i];
> > +		vmcb02->control.intercepts[i] |= svm->nested.ctl.intercepts[i];
> 
> And even more so here:
> 
> 	for (i = 0; i < MAX_INTERCEPT; i++)
> 		vmcb02->control.intercepts[i] |= vmcb12_ctrl->intercepts[i];
> 
> >  
> >  	/* If SMI is not intercepted, ignore guest SMI intercept as well  */
> >  	if (!intercept_smi)
> > -		vmcb_clr_intercept(c, INTERCEPT_SMI);
> > +		vmcb_clr_intercept(&vmcb02->control, INTERCEPT_SMI);
> >  
> >  	if (nested_vmcb_needs_vls_intercept(svm)) {
> >  		/*
> > @@ -177,10 +176,10 @@ void recalc_intercepts(struct vcpu_svm *svm)
> >  		 * we must intercept these instructions to correctly
> >  		 * emulate them in case L1 doesn't intercept them.
> >  		 */
> > -		vmcb_set_intercept(c, INTERCEPT_VMLOAD);
> > -		vmcb_set_intercept(c, INTERCEPT_VMSAVE);
> > +		vmcb_set_intercept(&vmcb02->control, INTERCEPT_VMLOAD);
> > +		vmcb_set_intercept(&vmcb02->control, INTERCEPT_VMSAVE);
> >  	} else {
> > -		WARN_ON(!(c->virt_ext & VIRTUAL_VMLOAD_VMSAVE_ENABLE_MASK));
> > +		WARN_ON(!(vmcb02->control.virt_ext & VIRTUAL_VMLOAD_VMSAVE_ENABLE_MASK));
> 
> Opportunistically switch this to WARN_ON_ONCE.  Any "unguarded" WARN in KVM
> (outside of e.g. __init code) is just asking for a self-DoS.

Will do.

> 
> >  	}
> >  }
> >  
> > -- 
> > 2.52.0.457.g6b5491de43-goog
> > 

