Return-Path: <kvm+bounces-71300-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id 4FHYHZ1NlmmbdgIAu9opvQ
	(envelope-from <kvm+bounces-71300-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Thu, 19 Feb 2026 00:39:09 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 38D9C15AF6A
	for <lists+kvm@lfdr.de>; Thu, 19 Feb 2026 00:39:09 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 28401302D5B9
	for <lists+kvm@lfdr.de>; Wed, 18 Feb 2026 23:38:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 01BEB33B6E4;
	Wed, 18 Feb 2026 23:38:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="mYomzGD3"
X-Original-To: kvm@vger.kernel.org
Received: from out-188.mta1.migadu.com (out-188.mta1.migadu.com [95.215.58.188])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C996D274B46
	for <kvm@vger.kernel.org>; Wed, 18 Feb 2026 23:38:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.188
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771457931; cv=none; b=i47CMkepQfoaNZApU3Zl8qcvrIv5KSblIzjq0t40w2fG0aHAeCiCHiZD0fCiVcHI0WwmR0hUwCf+/OD9/fYdIJFXfUntYw07eFUICmn0uR+LvfuodWSTwuNNC04+ZQwitCafaxK/RWRyCIXJxEzQ1nVPpwtkWHnZ7k7gCY2+/Is=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771457931; c=relaxed/simple;
	bh=50SceVm2r/nfcZPtOR22YkTlSRdJH8JKgH5+ZzYLT+U=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=EZWNddjTOVumWPq9Wu0TBJRid8A3i+6049HdP79bELHJwxQhCi9Ti3aLn6IoplOxGMIdJM+eIvWPqlkuHnWKqeMFzbHYb7h0KnqesnbzjcWSj+AVNHqaAEb125XwWZLrIlkIiXnAOhTTpcF8myoLnfX/PfTNzZYM7YbUXYM+o9E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=mYomzGD3; arc=none smtp.client-ip=95.215.58.188
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Date: Wed, 18 Feb 2026 23:38:29 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1771457918;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=aB47qdJUfFz/bYwqiLHfc4rPx+GXTiXFB0r1/9GB7Sg=;
	b=mYomzGD3eHlZDeN5Di2dFnlW1WReHySungLIsE8r6RfeN9DmDvEV5DZqfGZEqRh8m0r68d
	Qj3qSHqy9DIZ5shxRxPD7OhIIUc8MvMD+78YqvCcyeH2/xeudfnKjWu6zNFWDekFYTs4C0
	WO8E4260H5o7wzqG4nUaWI2VknDH9Jo=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Yosry Ahmed <yosry.ahmed@linux.dev>
To: Sean Christopherson <seanjc@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org, 
	linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [RFC PATCH 1/5] KVM: nSVM: Do not use L2's RIP for vmcb02's
 NextRIP after first L2 VMRUN
Message-ID: <4dtoocl34c3fxpg6k2bouv7epj2pb6bbuhogyha6evbxgu3gpy@zhdyzj2ordj2>
References: <20260212230751.1871720-1-yosry.ahmed@linux.dev>
 <20260212230751.1871720-2-yosry.ahmed@linux.dev>
 <aZZJxDVK4ekHxaLb@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aZZJxDVK4ekHxaLb@google.com>
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-1.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MID_RHS_NOT_FQDN(0.50)[];
	DMARC_POLICY_ALLOW(-0.50)[linux.dev,none];
	R_DKIM_ALLOW(-0.20)[linux.dev:s=key1];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c04:e001:36c::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	RCVD_COUNT_THREE(0.00)[3];
	FORGED_SENDER_MAILLIST(0.00)[];
	TAGGED_FROM(0.00)[bounces-71300-lists,kvm=lfdr.de];
	MIME_TRACE(0.00)[0:+];
	FROM_HAS_DN(0.00)[];
	MISSING_XM_UA(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[yosry.ahmed@linux.dev,kvm@vger.kernel.org];
	DKIM_TRACE(0.00)[linux.dev:+];
	NEURAL_HAM(-0.00)[-0.999];
	ASN(0.00)[asn:63949, ipnet:2600:3c04::/32, country:SG];
	TAGGED_RCPT(0.00)[kvm];
	TO_DN_SOME(0.00)[];
	RCPT_COUNT_FIVE(0.00)[5]
X-Rspamd-Queue-Id: 38D9C15AF6A
X-Rspamd-Action: no action

On Wed, Feb 18, 2026 at 03:22:44PM -0800, Sean Christopherson wrote:
> On Thu, Feb 12, 2026, Yosry Ahmed wrote:
> > For guests with NRIPS disabled, L1 does not provide NextRIP when running
> > an L2 with an injected soft interrupt, instead it advances L2's RIP
> > before running it. KVM uses L2's RIP as the NextRIP in vmcb02 to emulate
> 
> Should "L2's RIP" be "vmcb12's RIP"?  The "L2's RIP" terminology gets really
> confusing in the next paragraph, as NextRIP _is_ L2's (Next)RIP.  Hmm, or maybe
> "current RIP"?  I.e. "current RIP" vs. "NextRIP"?

I intentionally avoided mentioning vmcb12, because after save/restore
the RIP value we pass into nested_vmcb02_prepare_control() is no longer
what's in vmcb12. I can go with "current RIP".

> 
> > a CPU without NRIPS.
> > 
> > However, after L2 runs the first time, NextRIP will be updated by the
> > CPU and/or KVM, and L2's RIP is no longer the correct value to use in
> > vmcb02. Hence, after save/restore, do not use L2's RIP if a nested run
> > is not pending (i.e. L2 has run at least once), use the NextRIP value.
> 
> Too many negatives in this last sentence, it can just be (I think):
> 
>   Hence, after save/restore, use the current RIP if and only if a nested
>   run is pending, otherwise use NextRIP.

Looks good.

> 
> > Fixes: cc440cdad5b7 ("KVM: nSVM: implement KVM_GET_NESTED_STATE and KVM_SET_NESTED_STATE")
> > CC: stable@vger.kernel.org
> > Signed-off-by: Yosry Ahmed <yosry.ahmed@linux.dev>
> > ---
> >  arch/x86/kvm/svm/nested.c | 16 ++++++++++------
> >  1 file changed, 10 insertions(+), 6 deletions(-)
> > 
> > diff --git a/arch/x86/kvm/svm/nested.c b/arch/x86/kvm/svm/nested.c
> > index de90b104a0dd..eebbe00714e3 100644
> > --- a/arch/x86/kvm/svm/nested.c
> > +++ b/arch/x86/kvm/svm/nested.c
> > @@ -844,14 +844,18 @@ static void nested_vmcb02_prepare_control(struct vcpu_svm *svm,
> >  	vmcb02->control.event_inj_err       = svm->nested.ctl.event_inj_err;
> >  
> >  	/*
> > -	 * next_rip is consumed on VMRUN as the return address pushed on the
> > +	 * NextRIP is consumed on VMRUN as the return address pushed on the
> >  	 * stack for injected soft exceptions/interrupts.  If nrips is exposed
> > -	 * to L1, take it verbatim from vmcb12.  If nrips is supported in
> > -	 * hardware but not exposed to L1, stuff the actual L2 RIP to emulate
> > -	 * what a nrips=0 CPU would do (L1 is responsible for advancing RIP
> > -	 * prior to injecting the event).
> > +	 * to L1, take it verbatim from vmcb12.
> > +	 *
> > +	 * If nrips is supported in hardware but not exposed to L1, stuff the
> > +	 * actual L2 RIP to emulate what a nrips=0 CPU would do (L1 is
> > +	 * responsible for advancing RIP prior to injecting the event). This is
> > +	 * only the case for the first L2 run after VMRUN. After that (e.g.
> > +	 * during save/restore), NextRIP is updated by the CPU and/or KVM, and
> > +	 * the value of the L2 RIP from vmcb12 should not be used.
> >  	 */
> > -	if (guest_cpu_cap_has(vcpu, X86_FEATURE_NRIPS))
> > +	if (guest_cpu_cap_has(vcpu, X86_FEATURE_NRIPS) || !svm->nested.nested_run_pending)
> 
> This is technically wrong since KVM doesn't require NRIPS.  Maybe this?

I hallucinated that making nested depend on nrips was merge, i.e. this
patch: https://lore.kernel.org/kvm/f0302382cf45d7a9527b4aebbfe694bbcfa7aff5.1651440202.git.maciej.szmigiero@oracle.com/.

> 
> 	if (boot_cpu_has(X86_FEATURE_NRIPS)) {

I wonder if that's necessary, but I cannot find anything in the APM
about whether the CPU ignores NextRIP if it's not supported. It doesn't
even mention how to use it when injecting soft IRQs, only that it is
needed to properly inject then. Sigh.

> 		if (guest_cpu_cap_has(vcpu, X86_FEATURE_NRIPS) ||
> 		    !svm->nested.nested_run_pending)
> 			vmcb02->control.next_rip    = svm->nested.ctl.next_rip;
> 		else
> 			vmcb02->control.next_rip    = vmcb12_rip;
> 	}
> 	
> 
> >  		vmcb02->control.next_rip    = svm->nested.ctl.next_rip;
> >  	else if (boot_cpu_has(X86_FEATURE_NRIPS))
> >  		vmcb02->control.next_rip    = vmcb12_rip;
> > -- 
> > 2.53.0.273.g2a3d683680-goog
> > 

