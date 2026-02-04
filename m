Return-Path: <kvm+bounces-70251-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id MP0MFiSCg2llowMAu9opvQ
	(envelope-from <kvm+bounces-70251-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Wed, 04 Feb 2026 18:30:12 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id ABF38EAFCE
	for <lists+kvm@lfdr.de>; Wed, 04 Feb 2026 18:30:11 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 768AF302AC27
	for <lists+kvm@lfdr.de>; Wed,  4 Feb 2026 17:29:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 87A3734A796;
	Wed,  4 Feb 2026 17:29:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="EeidUBGz"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f202.google.com (mail-pl1-f202.google.com [209.85.214.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B09E134A3DA
	for <kvm@vger.kernel.org>; Wed,  4 Feb 2026 17:29:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770226178; cv=none; b=LrzMLWfEqlu++89wDmuIJZkqmnGOY1N5/8Xn2xFzs6fPSwK7cYfIWC6gfPs0CZItguRJhDtxPkMHHuA6HDDBeoFCfpLuxh8HPSqD7hQ35JCTb03y/In1B3laszP1hVui829FVWESccZsgSkQFZs3caTgkX5k2pnSDkdkgFaXLrc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770226178; c=relaxed/simple;
	bh=rwsHwVJiIFkUeP0DJGScgEvUx6R4nMQ15hWDNS//fC0=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=ZU6Zvg5FYxelN8SqrKKynAY/RDHIuqJZJCf8SKgM8grrp36ePysMEX+D+LFT3ZAUJMR3jrIeq2VmSl6csSq7OWc8YcqC/CVL0UJnuRIEFh/uVIkhyqygdBijI/JKJF9r4RFanhUKY0qe5JzPeOwq0I6Qlh3wwmAHl1YTFgt/qlc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=EeidUBGz; arc=none smtp.client-ip=209.85.214.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pl1-f202.google.com with SMTP id d9443c01a7336-29f1f69eec6so783765ad.1
        for <kvm@vger.kernel.org>; Wed, 04 Feb 2026 09:29:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1770226178; x=1770830978; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=j45uI0vV+THDY5Cnyxb9k9hfOJfjaw+RnlYXcIzaBoY=;
        b=EeidUBGz37wI/1Vkow0qCy0wmcW1goYGezAXUgpOOs1w+yJiebdiPvknlArQFvuhVC
         KbsxlZ7SCSnKpM6oRYoa6fO6tv/5oR1Xu29bYfOKZOXcpwHGKfvIFFNeKZ8sa5A23pkF
         ArG2/BrtYTHmNJ0AZq2ak70XbnYqZx9Y7y/g5rzXPPhrbDnW7ZMi4hPg3p+kCRtlxtGD
         QKMvgQ/wrRm9+SWTgFWpdIb1DHDK4cqJPxYtkS1i3qGS2TFliQaeaIcjpNlfAElnB045
         u74/J0KHhaW4CSpbHH3P7FmbWiwNgkXw3Vk+LEjqppFwkvJ9ozvJr0HdFYoM+nNvLui6
         6Y0g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770226178; x=1770830978;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=j45uI0vV+THDY5Cnyxb9k9hfOJfjaw+RnlYXcIzaBoY=;
        b=lN+yqcOQ46IZjFW3d/P4RNpk03vttvs1oJRL+iH6Icf7ft8O9O95YAtbwVypg1LHYz
         vpW+m3+3bIw6vfb4BYaqRGXoxDZyQr9cQVoj9jPjJ7ZFPKxRS7kSw7Ja0LmUMk4jI2NB
         D+SIN1dXCnnCSm1IeKYXmNgJM/fNCQ8dDZJ49iTHufqKJANe7xZKGCsVWdi+EP6I3Vcb
         bYWaJLHYbUMrqheLwDPlEx+caYCydbTsN5wmF9YjRloUMAH3KCELdB2FdQjpu+a1NaZr
         WRwI+wFuyiolKIJyuNsT+I+p/W4rm8PH7FP0gcA2hXqfpIEIJvKAERVUqIqW4isv08yI
         0Tqw==
X-Forwarded-Encrypted: i=1; AJvYcCUSfG/ZhQoNQApdu8YqMccZPQefkAx9BXTWTCr3n7bikEOc+HpSOY998opi8rZpl5lc94c=@vger.kernel.org
X-Gm-Message-State: AOJu0YziOLH8nSqNp8tanJjpodPqZPoGRnBgU2scziZfOHPoe9T/VFsF
	hS9O03s09jlK2/9S/gd/8lsAOfglRvXdIqI6/7VMM+Z9nzot9eaqgdnJPb6oTjBaTR2tumpg5ns
	ekPrpuQ==
X-Received: from plbbd12.prod.google.com ([2002:a17:902:830c:b0:2a0:b327:1816])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:902:d588:b0:2a2:d2e8:9f25
 with SMTP id d9443c01a7336-2a933e5175dmr35240915ad.33.1770226177838; Wed, 04
 Feb 2026 09:29:37 -0800 (PST)
Date: Wed, 4 Feb 2026 09:29:36 -0800
In-Reply-To: <20260112182022.771276-2-yosry.ahmed@linux.dev>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20260112182022.771276-1-yosry.ahmed@linux.dev> <20260112182022.771276-2-yosry.ahmed@linux.dev>
Message-ID: <aYOCAH8zLLXllou7@google.com>
Subject: Re: [PATCH 1/3] KVM: nSVM: Use intuitive local variables in recalc_intercepts()
From: Sean Christopherson <seanjc@google.com>
To: Yosry Ahmed <yosry.ahmed@linux.dev>
Cc: Paolo Bonzini <pbonzini@redhat.com>, Kevin Cheng <chengkev@google.com>, kvm@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="us-ascii"
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-1.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[google.com,reject];
	MV_CASE(0.50)[];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	R_DKIM_ALLOW(-0.20)[google.com:s=20230601];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-70251-lists,kvm=lfdr.de];
	FROM_HAS_DN(0.00)[];
	RCVD_COUNT_THREE(0.00)[4];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	DKIM_TRACE(0.00)[google.com:+];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	MISSING_XM_UA(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[seanjc@google.com,kvm@vger.kernel.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	MID_RHS_MATCH_FROM(0.00)[];
	TAGGED_RCPT(0.00)[kvm];
	NEURAL_HAM(-0.00)[-1.000];
	TO_DN_SOME(0.00)[];
	RCPT_COUNT_FIVE(0.00)[5]
X-Rspamd-Queue-Id: ABF38EAFCE
X-Rspamd-Action: no action

On Mon, Jan 12, 2026, Yosry Ahmed wrote:
> recalc_intercepts() currently uses c, h, g as local variables for the
> control area of the current VMCB, vmcb01, and (cached) vmcb12.
> 
> The current VMCB should always be vmcb02 when recalc_intercepts() is
> executed in guest mode. Use vmcb01/vmcb02 local variables instead to
> make it clear the function is updating intercepts in vmcb02 based on the
> intercepts in vmcb01 and (cached) vmcb12.
> 
> Add a WARNING() if the current VMCB is not in fact vmcb02.

This belongs in a separate patch.

> No functional change intended.
> 
> Signed-off-by: Yosry Ahmed <yosry.ahmed@linux.dev>
> ---
>  arch/x86/kvm/svm/nested.c | 31 +++++++++++++++----------------
>  1 file changed, 15 insertions(+), 16 deletions(-)
> 
> diff --git a/arch/x86/kvm/svm/nested.c b/arch/x86/kvm/svm/nested.c
> index f295a41ec659..2dda52221fd8 100644
> --- a/arch/x86/kvm/svm/nested.c
> +++ b/arch/x86/kvm/svm/nested.c
> @@ -125,8 +125,7 @@ static bool nested_vmcb_needs_vls_intercept(struct vcpu_svm *svm)
>  
>  void recalc_intercepts(struct vcpu_svm *svm)
>  {
> -	struct vmcb_control_area *c, *h;
> -	struct vmcb_ctrl_area_cached *g;
> +	struct vmcb *vmcb01, *vmcb02;
>  	unsigned int i;
>  
>  	vmcb_mark_dirty(svm->vmcb, VMCB_INTERCEPTS);
> @@ -134,14 +133,14 @@ void recalc_intercepts(struct vcpu_svm *svm)
>  	if (!is_guest_mode(&svm->vcpu))
>  		return;
>  
> -	c = &svm->vmcb->control;
> -	h = &svm->vmcb01.ptr->control;
> -	g = &svm->nested.ctl;
> +	vmcb01 = svm->vmcb01.ptr;
> +	vmcb02 = svm->nested.vmcb02.ptr;
> +	WARN_ON_ONCE(svm->vmcb != vmcb02);

If we're going to bother with a WARN, then this code should definitely bail,
because configuring vmcb01 using the nested logic is all but guaranteed to break
L1 in weird ways.

>  	for (i = 0; i < MAX_INTERCEPT; i++)
> -		c->intercepts[i] = h->intercepts[i];
> +		vmcb02->control.intercepts[i] = vmcb01->control.intercepts[i];
>  
> -	if (g->int_ctl & V_INTR_MASKING_MASK) {
> +	if (svm->nested.ctl.int_ctl & V_INTR_MASKING_MASK) {

I vote to keep a pointer to the cached control as vmcb12_ctrl.  Coming from a
nVMX-focused background, I can never remember what svm->nested.ctl holds.  For
me, this is waaaay more intuivite:

	if (vmcb12_ctrl->int_ctl & V_INTR_MASKING_MASK) {

>  	for (i = 0; i < MAX_INTERCEPT; i++)
> -		c->intercepts[i] |= g->intercepts[i];
> +		vmcb02->control.intercepts[i] |= svm->nested.ctl.intercepts[i];

And even more so here:

	for (i = 0; i < MAX_INTERCEPT; i++)
		vmcb02->control.intercepts[i] |= vmcb12_ctrl->intercepts[i];

>  
>  	/* If SMI is not intercepted, ignore guest SMI intercept as well  */
>  	if (!intercept_smi)
> -		vmcb_clr_intercept(c, INTERCEPT_SMI);
> +		vmcb_clr_intercept(&vmcb02->control, INTERCEPT_SMI);
>  
>  	if (nested_vmcb_needs_vls_intercept(svm)) {
>  		/*
> @@ -177,10 +176,10 @@ void recalc_intercepts(struct vcpu_svm *svm)
>  		 * we must intercept these instructions to correctly
>  		 * emulate them in case L1 doesn't intercept them.
>  		 */
> -		vmcb_set_intercept(c, INTERCEPT_VMLOAD);
> -		vmcb_set_intercept(c, INTERCEPT_VMSAVE);
> +		vmcb_set_intercept(&vmcb02->control, INTERCEPT_VMLOAD);
> +		vmcb_set_intercept(&vmcb02->control, INTERCEPT_VMSAVE);
>  	} else {
> -		WARN_ON(!(c->virt_ext & VIRTUAL_VMLOAD_VMSAVE_ENABLE_MASK));
> +		WARN_ON(!(vmcb02->control.virt_ext & VIRTUAL_VMLOAD_VMSAVE_ENABLE_MASK));

Opportunistically switch this to WARN_ON_ONCE.  Any "unguarded" WARN in KVM
(outside of e.g. __init code) is just asking for a self-DoS.

>  	}
>  }
>  
> -- 
> 2.52.0.457.g6b5491de43-goog
> 

