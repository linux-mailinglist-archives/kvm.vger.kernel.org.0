Return-Path: <kvm+bounces-70270-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id EHBxOwq3g2kdtQMAu9opvQ
	(envelope-from <kvm+bounces-70270-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Wed, 04 Feb 2026 22:15:54 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [104.64.211.4])
	by mail.lfdr.de (Postfix) with ESMTPS id 19B11ECB03
	for <lists+kvm@lfdr.de>; Wed, 04 Feb 2026 22:15:53 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id 0735D300371A
	for <lists+kvm@lfdr.de>; Wed,  4 Feb 2026 21:15:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1EA2334A3DA;
	Wed,  4 Feb 2026 21:15:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="C1FDzwbm"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 40214238C03
	for <kvm@vger.kernel.org>; Wed,  4 Feb 2026 21:15:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770239748; cv=none; b=TMDOu2XN9T+xQQyzRwcpFBF6TXj16N5E4ZB6Lxtcvvo38yA5n7HadXULdHzRlPPzx3YDm6YJyOat75GMYHqTXQdK9x4af30j2sBdei4fXvqz19rl3UShUpTyJ/Lx3lcdNC/RB+lmE3MWH13Dm7/IrGeG+F/LGFj3TfVrcmT8Cww=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770239748; c=relaxed/simple;
	bh=5HGCvd0YTYj63DiT21w1KxAoI95WeQigPCtNabTjHrA=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=Wnf4LNomZvAxZzGBGRyfXg/+/F8OQx5fUuhzW8XSHkPByXbRMNNiSzE/lmbZpTgXXhAAIF0WRWc0vpcdYTPyW3/lWEf7NC/SYV7k1MYUtZNKEtNTDKSAZavhC9IrQHgINgvQw8A8UAM9vNhqNe1Vm0guNatU1TgfBxeYNRLXp9c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=C1FDzwbm; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-34e5a9f0d6aso222902a91.0
        for <kvm@vger.kernel.org>; Wed, 04 Feb 2026 13:15:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1770239747; x=1770844547; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=7vlmT4gpsTTf3ltXzVnOCpP6DegRtfzETfYO37RNk+E=;
        b=C1FDzwbmhUTADKlPN5bh1Z8MX+kunZEoI8Rka4gKo2LAeB9cYAXCtjRA9+PFk2WcEw
         KZMxuBM1HU9WxfGzEhaskPR+OUnum8qrU5+SrNNXuvefRq7GA4xijbGg3YE659TcauBV
         c6VpRnViL6r1VHJlSQL68ENqGV4A0q0LfsjzwUBxbu846CUTY5Uug7mDI00qmvq5kguz
         XOoQQWuW1+WxcCeIXcZWIz7Dpj3V6nA+VzsSp1P7+Tw2+dG69lY/BQRpFwuuJfcpE0ua
         NRaKSIVYs5U4VGX/s+etE2VYjer+E5eTjQKPt9aQUJz3q0tfYxkZj64YsodRDlrNOCdA
         iFAQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770239747; x=1770844547;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=7vlmT4gpsTTf3ltXzVnOCpP6DegRtfzETfYO37RNk+E=;
        b=VrDsYY7ney7vIpCiGsW8ThNt1ZTm1lWXMGREhYe5Ue8tkhEpyI7zRf90Uhlk/gual7
         0s9kxqe90xEz2riUrSwtD17UhyUS4Qr2sjj2XzlzYUajIlDt/wRDJtJVpT7GAiBt1sJF
         ldbCqR4Kuzg000y9YkscxTSHJeGmXWVeIef07A27dmpr2WNXQCuF7x1jdyrzo7TCWrM3
         edtREt+PhLXuctix5KYxrnpP+dkOZc4bXpYZRXvBs9A8cV2tte2gaDwsBGQv59JW9UvC
         hhGkTQs5kYdmcwC82XFm+EsT14JjKvMm8qpTphW8lsOoTqBklAIZJKSu+Ix7wcFF9IQA
         FXDA==
X-Forwarded-Encrypted: i=1; AJvYcCVx0Sipgxn5S72LYpc5+JxgD/wCTQLq1dyBdaHCuTD2zlqp6ynYB6oahiZ3pthopGEgE1E=@vger.kernel.org
X-Gm-Message-State: AOJu0YzU4kb+sAXnuUPJuTuvFSzLxqTdGl4cQT8L7mYRWnTm3pVrWknT
	ByeNuJtJPxcUHeL6m0GKrT3SN/PkIBhfZNEVnGGihBug8uYLX/up30X3Bbk6siXS4bV8nT9BFtt
	Y3klpAQ==
X-Received: from pjro9.prod.google.com ([2002:a17:90a:b889:b0:34c:567d:ede4])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:268b:b0:340:bfcd:6af9
 with SMTP id 98e67ed59e1d1-3549be1a251mr468175a91.3.1770239747537; Wed, 04
 Feb 2026 13:15:47 -0800 (PST)
Date: Wed, 4 Feb 2026 13:15:45 -0800
In-Reply-To: <20260130020735.2517101-3-yosry.ahmed@linux.dev>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20260130020735.2517101-1-yosry.ahmed@linux.dev> <20260130020735.2517101-3-yosry.ahmed@linux.dev>
Message-ID: <aYO3AaBqbPy_9XdD@google.com>
Subject: Re: [PATCH 2/3] KVM: nSVM: Do not track EFER.SVME toggling in guest mode
From: Sean Christopherson <seanjc@google.com>
To: Yosry Ahmed <yosry.ahmed@linux.dev>
Cc: Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="us-ascii"
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-1.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MV_CASE(0.50)[];
	DMARC_POLICY_ALLOW(-0.50)[google.com,reject];
	R_DKIM_ALLOW(-0.20)[google.com:s=20230601];
	R_SPF_ALLOW(-0.20)[+ip4:104.64.211.4:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	TAGGED_FROM(0.00)[bounces-70270-lists,kvm=lfdr.de];
	FROM_HAS_DN(0.00)[];
	RCVD_COUNT_THREE(0.00)[4];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	DKIM_TRACE(0.00)[google.com:+];
	ASN(0.00)[asn:63949, ipnet:104.64.192.0/19, country:SG];
	MISSING_XM_UA(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[seanjc@google.com,kvm@vger.kernel.org];
	RCPT_COUNT_THREE(0.00)[4];
	MID_RHS_MATCH_FROM(0.00)[];
	TAGGED_RCPT(0.00)[kvm];
	NEURAL_HAM(-0.00)[-1.000];
	TO_DN_SOME(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sin.lore.kernel.org:helo,sin.lore.kernel.org:rdns,linux.dev:email]
X-Rspamd-Queue-Id: 19B11ECB03
X-Rspamd-Action: no action

The shortlog is *very* misleading.  The changelog isn't much better.  This isn't
just removing "tracking", it's redefining guest visible behavior and effectively
changing the KVM virtual CPU microarchitecture.

On Fri, Jan 30, 2026, Yosry Ahmed wrote:
> KVM tracks when EFER.SVME is set and cleared to initialize and tear down
> nested state. However, it doesn't differentiate if EFER.SVME is getting
> toggled in L1 or L2+. Toggling EFER.SVME in L2+ is inconsequential from
> KVM's perspective, as the vCPU is still obviously using nested.
> 
> This causes a problem if L2 sets then clears EFER.SVME without L1
> interception, as KVM exits guest mode and tears down nested state while
> L2 is running, executing L1 without injecting a proper #VMEXIT.
> 
> Technically, it's not a bug as the APM states that an L1 hypervisor
> should intercept EFER writes:
> 
> 	The effect of turning off EFER.SVME while a guest is running is
> 	undefined; therefore, the VMM should always prevent guests from
> 	writing EFER.
> 
> However, it would be nice if KVM handled it more gracefully.

That's not sufficient justification for this change.  Nothing will ever trip this
code unless it's _trying_ to trip this code.  I.e.  Outside of a bespoke selftest
that is little more than "make sure the kernel doesn't explode", and future
malicious actors, KVM's behavior is largely irrelevant.

> Signed-off-by: Yosry Ahmed <yosry.ahmed@linux.dev>
> ---
>  arch/x86/kvm/svm/svm.c | 7 +++++++
>  1 file changed, 7 insertions(+)
> 
> diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
> index 4575a6a7d6c4e..eaf0f8053fbfb 100644
> --- a/arch/x86/kvm/svm/svm.c
> +++ b/arch/x86/kvm/svm/svm.c
> @@ -208,6 +208,13 @@ static int svm_set_efer_svme(struct kvm_vcpu *vcpu, u64 old_efer, u64 new_efer)
>  	if ((old_efer & EFER_SVME) == (new_efer & EFER_SVME))
>  		return 0;
>  
> +	/*
> +	 * An L2 guest setting or clearing EFER_SVME does not change whether or
> +	 * not the vCPU can use nested from KVM's perspective.

This should call out that the architectural behavior is undefined.  "from KVM's
perspective" is an obtuse way of saying "KVM is making up behavior because it
can".  E.g. something like

	/*
	 * Architecturally, clearing EFER.SVME while a guest is running yields
	 * undefined behavior, i.e. KVM has carte blance to do anything if L1
	 * doesn't intercept writes to EFER.  Simply do nothing, because XYZ.
	 */

> +	 */
> +	if (is_guest_mode(vcpu))

This is fine, because svm_allocate_nested() plays nice with redundant calls, but
this is a rather scary change for something that straight up doesn't happen in
practice.  Any hypervisor that doesn't intercept EFER is broken, period.

E.g. if a future change adds novel code that's guarded by the

	if ((old_efer & EFER_SVME) == (new_efer & EFER_SVME)) 
		return 0;

check, then doing nothing here could result in a guest-exploitable bug.  In other
words, from a kernel safety perspective, "doing nothing" is more dangerous than
forcibly leaving nested mode, because doing nothing deliberately puts KVM in an
inconsistent state.  Given that there's basically zero benefit in practice, I'm
strongly inclined to keep the call svm_leave_nested().

All that said, I agree that pulling the rug out from under the VM is a terrible
experience.  What if we throw a triple fault at the vCPU so that L1 gets an
immediate SHUTDOWN (not a VM-Exit, a SHUTDOWN of the L1 vCPU), instead of running
random garbage from L2?

diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index 5f0136dbdde6..ccd73a3be3f9 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -216,6 +216,17 @@ int svm_set_efer(struct kvm_vcpu *vcpu, u64 efer)
 
        if ((old_efer & EFER_SVME) != (efer & EFER_SVME)) {
                if (!(efer & EFER_SVME)) {
+                       /*
+                        * Architecturally, clearing EFER.SVME while a guest is
+                        * running yields undefined behavior, i.e. KVM can do
+                        * literally anything.  Force the vCPU back into L1 as
+                        * that is the safest option for KVM, but synthesize a
+                        * triple fault (for L1!) so that KVM at least doesn't
+                        * run random L2 code in the context of L1.
+                        */
+                       if (is_guest_mode(vcpu))
+                               kvm_make_request(KVM_REQ_TRIPLE_FAULT, vcpu);
+
                        svm_leave_nested(vcpu);
                        /* #GP intercept is still needed for vmware backdoor */
                        if (!enable_vmware_backdoor)


> +		return 0;
> +
>  	if (new_efer & EFER_SVME) {
>  		r = svm_allocate_nested(svm);
>  		if (r)
> -- 
> 2.53.0.rc1.225.gd81095ad13-goog
> 

