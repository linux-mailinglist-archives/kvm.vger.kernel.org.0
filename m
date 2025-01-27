Return-Path: <kvm+bounces-36663-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 37684A1D972
	for <lists+kvm@lfdr.de>; Mon, 27 Jan 2025 16:25:11 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id AC2BE7A293C
	for <lists+kvm@lfdr.de>; Mon, 27 Jan 2025 15:24:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C353613B797;
	Mon, 27 Jan 2025 15:24:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="KzQhmbMo"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f201.google.com (mail-pl1-f201.google.com [209.85.214.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 67ECF13D24D
	for <kvm@vger.kernel.org>; Mon, 27 Jan 2025 15:24:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737991490; cv=none; b=TWn/ZDhJVvlt9DxxTxt9jb9qSm4zoLMBV8URoZuQq/7SNLb27oj4XJfqjJD3b4X2pU1eDxn51RIiLKlGjCvU1ozQ0gTxKzWcaRp1RkEA3xJ7prdtRfWA4Njq7JDrsYJRQhbUQnSWhEcs7vgd2bQXTHsdcAXpi5GBrkkv84X2hTQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737991490; c=relaxed/simple;
	bh=MEueiGx/CLwPsfh2pRO44ZyYAyS3IlpdV7imm8VQ6Mo=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=ZKFzLAw0h7HhPeYf+Y0GOkYaOGInh3XSrGCA50JCuNzFZhjnE1l/U3ZW2V1ks0/h5HXEe328sW6k0/x0SGlaTuZPG8SDDwToN4MN4kTMpm3XG9q+J1TswHrHoJOqEqWi/PvnS7ywDaWpZSG+6joDYTFxLU9c9Ero58TwutA65RY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=KzQhmbMo; arc=none smtp.client-ip=209.85.214.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pl1-f201.google.com with SMTP id d9443c01a7336-2161d5b3eb5so85973825ad.3
        for <kvm@vger.kernel.org>; Mon, 27 Jan 2025 07:24:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1737991488; x=1738596288; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=ZoeCnFd5J5xnYNqBdU/ogFWqB8J8v68mjfzwpWs3ZH8=;
        b=KzQhmbMo/mDMJCETzdx3R4liMfMNBr7z4vR08sWBbM7v2yAPToM/lVfCfkGlnsnGFQ
         WhI3fU8Bulrf8qiWe8QNgfYps+u1KLhsjDq+FwHwtrYQSnS0SlHHJPoD+/3AW+PJAgYi
         ++12sjhT38K+z9pc2CrJG6kx2UJgRad82qgKfME3ecXjoFWu4PferYe8FhWP0K0QI6xg
         mec4htibiXj97HRRPh/AOf1c13a6CL3xfcuRFPUS4KlQn14g/yiVPBzxS6jpqRazFrYK
         4YSWDfoq/LnwRNQnR4YQgaOoBqAciBaOfLZigfBxTNQjRmFR/aVpjiFxl6tDJR9eG+MS
         +kIA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1737991488; x=1738596288;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ZoeCnFd5J5xnYNqBdU/ogFWqB8J8v68mjfzwpWs3ZH8=;
        b=EGnep5Xcgqdqip+y8sjfvXya0KeeD7Y7+KjLWMkUAmPId3yRMYsl8DERuG47MTe1DI
         579nF92jWzTYGJMrOsIclpn9eYxRtdUv/STgtJsBV3QnJpoD786WGD2iWYBqdclswg2y
         WZzk0coqPy8oKBV/+X3oZG+o4PclHw8ifOQko5QF3C/fvTxlEkXQpWmNpNDcyWKyq93h
         zItXAyTvCMDZTckSt/jjF6bWjflBPwEwXx0VGS3J5IyonlSU2bYVLHkJp2Do0J+/Tnmt
         4XRdautu1YTFVDL4MBvVEHUYFEkOB04vIPvD9YtigNG6pa5dJ+OISrRb1E+xMJjRNJw+
         XTiw==
X-Forwarded-Encrypted: i=1; AJvYcCUyiPbiMUxfdUwLBNC2GFXnsSgEgHYxAn0wQw5p2UDMIFDg4dBMVG4BrEveY9hvUo4FtiI=@vger.kernel.org
X-Gm-Message-State: AOJu0YxFZ10TyVWwC5KPTPw/V7N6l6y4DKk7dnDViucV7FbynlEW98KX
	mN3g/gl+hxA0nJcHMaYXz62v9yRu5mwe2hfTLQww/ii4R082F0gohP54sCD2SlQrMWmmc/7pH+x
	FBA==
X-Google-Smtp-Source: AGHT+IHYoJa0BkqdkhXtUYNXMnIfXT2Kp07cJDVu8LU5YEcGtlhbUTPDhn5/CB6e3hG2xZH+iB3g+iJMLng=
X-Received: from pgbcl22.prod.google.com ([2002:a05:6a02:996:b0:7fd:5461:1ff6])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a20:3d86:b0:1e0:9cc2:84b1
 with SMTP id adf61e73a8af0-1eb2158d07amr68681560637.30.1737991488591; Mon, 27
 Jan 2025 07:24:48 -0800 (PST)
Date: Mon, 27 Jan 2025 07:24:42 -0800
In-Reply-To: <CAHk-=wghGxSMv3K0BEB8N3N3vwk-3v=T1FhBVJyf2u_xYYJOCA@mail.gmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250124163741.101568-1-pbonzini@redhat.com> <CAHk-=wghGxSMv3K0BEB8N3N3vwk-3v=T1FhBVJyf2u_xYYJOCA@mail.gmail.com>
Message-ID: <Z5elOuz1IjFXAtGx@google.com>
Subject: Re: [GIT PULL] KVM changes for Linux 6.14
From: Sean Christopherson <seanjc@google.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Paolo Bonzini <pbonzini@redhat.com>, linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Content-Type: text/plain; charset="us-ascii"

On Sat, Jan 25, 2025, Linus Torvalds wrote:
> On Fri, 24 Jan 2025 at 08:38, Paolo Bonzini <pbonzini@redhat.com> wrote:
> >
> > but you can throw away the <<<< ... ==== part completely, and apply the
> > same change on top of the new implementation:
> >
> > diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
> > index edef30359c19..9f9a29be3beb 100644
> > --- a/arch/x86/kvm/cpuid.c
> > +++ b/arch/x86/kvm/cpuid.c
> > @@ -1177,6 +1177,7 @@ void kvm_set_cpu_caps(void)
> >                 EMULATED_F(NO_SMM_CTL_MSR),
> >                 /* PrefetchCtlMsr */
> >                 F(WRMSR_XX_BASE_NS),
> > +               F(SRSO_USER_KERNEL_NO),
> >                 SYNTHESIZED_F(SBPB),
> >                 SYNTHESIZED_F(IBPB_BRTYPE),
> >                 SYNTHESIZED_F(SRSO_NO),
> 
> Ehh. My resolution ended up being different.
> 
> I did this instead:
> 
>                F(WRMSR_XX_BASE_NS),
>                SYNTHESIZED_F(SBPB),
>                SYNTHESIZED_F(IBPB_BRTYPE),
>                SYNTHESIZED_F(SRSO_NO),
> +              SYNTHESIZED_F(SRSO_USER_KERNEL_NO),
> 
> which (apart from the line ordering) differs from your suggestion in
> F() vs SYNTHESIZED_F().
> 
> That really seemed to be the RightThing(tm) to do from the context of
> the two conflicting commits, but maybe there was some reason that I
> didn't catch that you kept it as a plain "F()".

Heh, I waffled on whether SRSO_USER_KERNEL_NO should be F() or SYNTHESIZED_F()
when the initial commit went in.  I would prefer to keep it F(), though it doesn't
matter terribly at the moment.

The "synthesized" features are for cases where the kernel stuffs X86_FEATURE_xxx
via set_cpu_cap() even when the feature isn't present in CPUID, and it's correct
for KVM to relay the synthesized feature to the guest.

E.g. SRSO_NO is synthesized into cpu_caps for Zen1/2, and in that case the
absense of the SRSO flaw extends to the guest as well.

		if (boot_cpu_data.x86 < 0x19 && !cpu_smt_possible()) {
			setup_force_cpu_cap(X86_FEATURE_SRSO_NO);
			return;
		}

For SRSO_USER_KERNEL_NO, it's currently not force set, i.e. it's a pure reflection
of hardware capabilities.  Treating it as synthesized is effectively a nop with
the current code, but that would change if the kernel were to force set the flag.

If a future commit force set SRSO_USER_KERNEL_NO because of a ucode update that
didn't also modify CPUID behavior, then treating the flag as synthesized would
be desirabled, e.g. so that the guest could also avoid the overhead of mitigating
SRSO.

But if a future commit set the flag for some other reason, e.g. if the kernel
somehow isn't vulnerable even when running on buggy hardware, then enumerating
SRSO_USER_KERNEL_NO to the guest could cause the guest kernel to incorrectly
skips its mitigation.

My vote is to err on the side of caution and go with F().

