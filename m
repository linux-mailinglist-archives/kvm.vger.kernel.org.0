Return-Path: <kvm+bounces-53019-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id AE797B0C9EE
	for <lists+kvm@lfdr.de>; Mon, 21 Jul 2025 19:46:02 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id F25563BA261
	for <lists+kvm@lfdr.de>; Mon, 21 Jul 2025 17:45:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5018B2E2651;
	Mon, 21 Jul 2025 17:45:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="pRpduH6a"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f202.google.com (mail-pl1-f202.google.com [209.85.214.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6684A19F49E
	for <kvm@vger.kernel.org>; Mon, 21 Jul 2025 17:45:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753119943; cv=none; b=ecsjZSjP6PleFGAN+NRdvzP4FSG2C+7H1lSiXHPDNtANIyeGa62XyKUJ+xgCAYHcgqhNuoXwyrJKYKfHHR6/CCrXyj617uxZDqmIYHDdiohHDSVkV7VPj4pIr85rm2EBMzg0mlM1Tka4vWUspYnwfpYI7i5L3C6h2hqea1PQ/fM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753119943; c=relaxed/simple;
	bh=GB4zskA2ZYlvODr9l5/H+sJppM55rCMxnwfZA4FdtwM=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=DaWC0Jv8sck70X9i13EOGmyGsOCv+eOQbNEsD45fuMjNxHgUtFMFxOos6oA1JOoglU8b093aY/a+VgUg0K84bqUvH/OVR2EXTf4agWBQmrCOJtJKRiJ0L6oitJApPsKJdNkN14hQ29E7ec1ZlN3p0FJ6QtWm0vCi00qbTEC6i5g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=pRpduH6a; arc=none smtp.client-ip=209.85.214.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pl1-f202.google.com with SMTP id d9443c01a7336-235e7550f7bso45485325ad.3
        for <kvm@vger.kernel.org>; Mon, 21 Jul 2025 10:45:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1753119940; x=1753724740; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=di7TexfbhffoSOH6ZsYX7OktFXPZVnJiau3m+090UpA=;
        b=pRpduH6ao4dbfwVSKtvTtxZplskwlT0wq06rWUI9+NpkdBqPiu80EmY9wdDCJRrNBi
         982YJn0FNVkWYkVUEx3QBMFWa7CPtIxojTjRRJh0ZFd8dOuSs6UapPCErxuums+iI/97
         q7Pw2B/eqWgaEoXWtpErJktaPbA0xWHF0E/d3gbdOQNUslbA0MbebsRIjhl6aG3iSqLW
         tET4efRqSqTy1XjrMxzDDperOWPflkw+Qp6sjuyy0Dfy9JlkP4ZKgOTyjXwryqNgcOWk
         KSlt1ZVHrOK624YJksa1feQAx0oN0XpCMp6nXmgB1ETi+7S04WKqfAVjFmnQcpy0Ly89
         Kafw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753119940; x=1753724740;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=di7TexfbhffoSOH6ZsYX7OktFXPZVnJiau3m+090UpA=;
        b=jO3Mltx27lJDgnnJcP9CnkTGUGaF39ERZTqP+TDnuE9RDiKtp+bp96cZico7JHyojN
         TdCTFWPaVMDERF1wpADNfVp5sOD9HJIQZvJEljuKSQ8MDqjU/n3vuKMrSrpA8s565nze
         B5bP5rHD+IfHRD53MuyDEfBDygLA715XrMWntPQA3r9UndPQQNtYXEryZCZP5504v1JF
         7J9cWaWVN3nP9yvi+oFfPHu+G3Y06U8jWcgLp6b5OnpnABS04JuJ2S+SKsCskHK+SuyW
         Fo1g6xz2aN5qImulgFh/feyEPH1Gsj/u2UKay75I5c2XGcNn9uH2ghiXB+xCwv4IAZCE
         K6RA==
X-Forwarded-Encrypted: i=1; AJvYcCXMdc4+2Hr5qw7uhK3tgoSoISnKXCrszhulCBXJ3jA9Q6XS/TrXwkarrswdN3+hrFXsVL4=@vger.kernel.org
X-Gm-Message-State: AOJu0Yz1TX1V4rfIa8f+dRARdRA2ADSAtEWfBUgFBrmm6b040qyeH0uM
	AwVxy5s17QadxCgeKbTROYG7gniHiHqTAPPWlbLTsZilnoOgepVlXdAhQTYrFtPpER6Mi+jQGeM
	mns2mdQ==
X-Google-Smtp-Source: AGHT+IHiKAzk+Gj92dMWbjReV05ys85siAtjhNZ+WoJphGuFPtx3rF6tRTIcG/LNVyw1tkXMwMoYptXCIv0=
X-Received: from pgbdw5.prod.google.com ([2002:a05:6a02:4485:b0:b3f:3145:8216])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:902:d54f:b0:234:c65f:6c0c
 with SMTP id d9443c01a7336-23e3b78d523mr188481485ad.15.1753119940553; Mon, 21
 Jul 2025 10:45:40 -0700 (PDT)
Date: Mon, 21 Jul 2025 10:45:39 -0700
In-Reply-To: <4114d399-8649-41de-97bf-3b63f29ec7e8@grsecurity.net>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250704085027.182163-1-chao.gao@intel.com> <20250704085027.182163-20-chao.gao@intel.com>
 <4114d399-8649-41de-97bf-3b63f29ec7e8@grsecurity.net>
Message-ID: <aH58w_wHx3Crklp4@google.com>
Subject: Re: [PATCH v11 19/23] KVM: x86: Enable CET virtualization for VMX and
 advertise to userspace
From: Sean Christopherson <seanjc@google.com>
To: Mathias Krause <minipli@grsecurity.net>
Cc: Chao Gao <chao.gao@intel.com>, kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	x86@kernel.org, pbonzini@redhat.com, dave.hansen@intel.com, 
	rick.p.edgecombe@intel.com, mlevitsk@redhat.com, john.allen@amd.com, 
	weijiang.yang@intel.com, xin@zytor.com, Thomas Gleixner <tglx@linutronix.de>, 
	Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
	Dave Hansen <dave.hansen@linux.intel.com>, "H. Peter Anvin" <hpa@zytor.com>
Content-Type: text/plain; charset="us-ascii"

On Mon, Jul 21, 2025, Mathias Krause wrote:
> On 04.07.25 10:49, Chao Gao wrote:
> > From: Yang Weijiang <weijiang.yang@intel.com>
> > 
> > Expose CET features to guest if KVM/host can support them, clear CPUID
> > feature bits if KVM/host cannot support.
> > [...]
> 
> Can we please make CR4.CET a guest-owned bit as well (sending a patch in
> a second)? It's a logical continuation to making CR0.WP a guest-owned
> bit just that it's even easier this time, as no MMU role bits are
> involved and it still makes a big difference, at least for grsecurity
> guest kernels.

Out of curiosity, what's the use case for toggling CR4.CET at runtime?

> Using the old test from [1] gives the following numbers (perf stat -r 5
> ssdd 10 50000):
> 
> * grsec guest on linux-6.16-rc5 + cet patches:
>   2.4647 +- 0.0706 seconds time elapsed  ( +-  2.86% )
> 
> * grsec guest on linux-6.16-rc5 + cet patches + CR4.CET guest-owned:
>   1.5648 +- 0.0240 seconds time elapsed  ( +-  1.53% )
> 
> Not only is it ~35% faster, it's also more stable, less fluctuation due
> to less VMEXITs, I believe.
> 
> Thanks,
> Mathias
> 
> [1]
> https://lore.kernel.org/kvm/20230322013731.102955-1-minipli@grsecurity.net/

> From 14ef5d8b952744c46c32f16fea3b29184cde3e65 Mon Sep 17 00:00:00 2001
> From: Mathias Krause <minipli@grsecurity.net>
> Date: Mon, 21 Jul 2025 13:45:55 +0200
> Subject: [PATCH] KVM: VMX: Make CR4.CET a guest owned bit
> 
> There's no need to intercept changes of CR4.CET, make it a guest-owned
> bit where possible.

In the changelog, please elaborate on the assertion that CR4.CET doesn't need to
be intercepted, and include the motiviation and perf numbers.  KVM's "rule" is
to disable interception of something if and only if there is a good reason for
doing so, because generally speaking intercepting is safer.  E.g. KVM bugs are
less likely to put the host at risk.  "Because we can" isn't not a good reason :-)

E.g. at one point CR4.LA57 was a guest-owned bit, and the code was buggy.  Fixing
things took far more effort than it should have there was no justification for
the logic (IIRC, it was done purely on the whims of the original developer).

KVM has had many such cases, where some weird behavior was never documented/justified,
and I really, really want to avoid committing the same sins that have caused me
so much pain :-)

> This change is VMX-specific, as SVM has no such fine-grained control
> register intercept control.
> 
> Signed-off-by: Mathias Krause <minipli@grsecurity.net>
> ---
>  arch/x86/kvm/kvm_cache_regs.h | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/x86/kvm/kvm_cache_regs.h b/arch/x86/kvm/kvm_cache_regs.h
> index 36a8786db291..8ddb01191d6f 100644
> --- a/arch/x86/kvm/kvm_cache_regs.h
> +++ b/arch/x86/kvm/kvm_cache_regs.h
> @@ -7,7 +7,8 @@
>  #define KVM_POSSIBLE_CR0_GUEST_BITS	(X86_CR0_TS | X86_CR0_WP)
>  #define KVM_POSSIBLE_CR4_GUEST_BITS				  \
>  	(X86_CR4_PVI | X86_CR4_DE | X86_CR4_PCE | X86_CR4_OSFXSR  \
> -	 | X86_CR4_OSXMMEXCPT | X86_CR4_PGE | X86_CR4_TSD | X86_CR4_FSGSBASE)
> +	 | X86_CR4_OSXMMEXCPT | X86_CR4_PGE | X86_CR4_TSD | X86_CR4_FSGSBASE \
> +	 | X86_CR4_CET)
>  
>  #define X86_CR0_PDPTR_BITS    (X86_CR0_CD | X86_CR0_NW | X86_CR0_PG)
>  #define X86_CR4_TLBFLUSH_BITS (X86_CR4_PGE | X86_CR4_PCIDE | X86_CR4_PAE | X86_CR4_SMEP)
> -- 
> 2.47.2
> 


