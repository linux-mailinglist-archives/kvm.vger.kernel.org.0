Return-Path: <kvm+bounces-38177-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 8CBCDA361A7
	for <lists+kvm@lfdr.de>; Fri, 14 Feb 2025 16:27:17 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 5340F16C9D2
	for <lists+kvm@lfdr.de>; Fri, 14 Feb 2025 15:27:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 75D0D266F05;
	Fri, 14 Feb 2025 15:27:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Zt1CDVFg"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 274D81F92A
	for <kvm@vger.kernel.org>; Fri, 14 Feb 2025 15:26:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739546821; cv=none; b=TWkXRIzMiGd2BjCNMcRsRzuImPHX5VUiScLdLVghwYEywWibYqbfCgDnhaQnAtqNhgNXzBNvPqeoDjcRHW/WYNKG50qsbuNH77QbJzn6grPLkwb0EM6L4chi/7kM4otyyFCrZBKBsMSY8z7aH6FQEm2bgDRuwG3sO3PIBwwc4VM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739546821; c=relaxed/simple;
	bh=4YjQ+mVg6V227x71VJf2S+wTAFuySquGpvAuFTgbffM=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=SJ8GisT8BHYDVAAWbCkgxhpMbpypGdjCeLlsAOeu2McRu/eV3LwTsy+mCiHxzUwU9hd4JC/fZRN/XT9cpD5LKdNY9gChTCYF0JDDKteQMKTN7agg2XhYGZm0V/zUnu3KEgQctVRRbgV8Oc39b5vhaI+Im/1c/G6S6Fj4MWGOe9s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=Zt1CDVFg; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-2fc1eabf4f7so3255121a91.1
        for <kvm@vger.kernel.org>; Fri, 14 Feb 2025 07:26:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1739546819; x=1740151619; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=ieo8bF68ul8NY3XsoXjeCza+BbG3/+5Q5pjbotrXjzo=;
        b=Zt1CDVFgX9j3RZk1KnN63nlmDbfWbDgZ6q5Ffs7kCSLQh9LWd/PBAlOTiJ/S0r7YCr
         NOtBvDzBqSqrX1T0JzBO0gMTjYlcaMJllXf35fYagrDpdyJL+05LZBdpXsH9k930hlVP
         44I2KitLMFl/NmKLUsODE7JW6ga9owLLWBKH526aDgc/dvwQdYIsxrzAENlLWY7wq4Ua
         Sd2siB5eECxHKlYCfKUgnCemS181j42/PZUInhz14myDFKMsoMKoWqBpsQbVulfm+zEu
         uj/KwSiCdd4FoKq9p3tPHClFLiff4u3zY8tmkwnbzdl+b5PzqMKcihu5nPgOJyIQScnD
         L8ww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1739546819; x=1740151619;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ieo8bF68ul8NY3XsoXjeCza+BbG3/+5Q5pjbotrXjzo=;
        b=DuQxPsEoRpmqGju9rE5snP0iv8a57ZuSF0J8UGLc+KOsuUj/Yn/xilldqmuySitjTo
         ruWCWc9tnRAladrL+X77qEk/IxVovtMow7uMF4TqbXjjx4RyZR3s142f0L/qQc6H58M0
         R7bsEmWsceNiLyhtZRKZ0S8V2gcTKRXR4Jv/5g1342oroh9GIxUyoCo+a7LJV2zN7hMj
         7wY0C0watWgq+nomDdwUI2DzULHQ7Afa2AquzAvy4n6MNCMTT0DRFe4upJcbZQ9vD3to
         r6mSjibhMFEiUprB1lL85lddaJcCCFxxtPJ0O9HMcg2x5Dwb0IOG9kWLQ0O8XvUGjgDS
         9bcQ==
X-Forwarded-Encrypted: i=1; AJvYcCU8Pxo/GrihntK7KSgWFWFoqgMWm6J/E+K8aMCgVC2Me2J4r2SUpWNSwVINnZMJNtVe1PY=@vger.kernel.org
X-Gm-Message-State: AOJu0YzeEZzl4nZaSm+jvuRVxPKfFJ3UyY4p5mRZYY1BdAVr9GMtYMar
	Fwwx7HoWz3DGzfCGqdtavd20m8okNdJD3eucVsZyzOBqq26PXV/dnkFLvhiRk5ooLjvUpxk/t+b
	/kg==
X-Google-Smtp-Source: AGHT+IHWbVB4kTHf+DIwJbZNqYRlgO/ExJdlMCgjxVC7ddzx+IsADDqc7aCG4RrvAEEQDguHxQ9DO4uDWcE=
X-Received: from pjbnd14.prod.google.com ([2002:a17:90b:4cce:b0:2fb:fa62:d40])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:4a42:b0:2ee:964e:67ce
 with SMTP id 98e67ed59e1d1-2fc0ddd1ff1mr11086665a91.3.1739546819402; Fri, 14
 Feb 2025 07:26:59 -0800 (PST)
Date: Fri, 14 Feb 2025 07:26:57 -0800
In-Reply-To: <20250204004038.1680123-3-jthoughton@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250204004038.1680123-1-jthoughton@google.com> <20250204004038.1680123-3-jthoughton@google.com>
Message-ID: <Z69gwTQjaeMLY7rM@google.com>
Subject: Re: [PATCH v9 02/11] KVM: Add lockless memslot walk to KVM
From: Sean Christopherson <seanjc@google.com>
To: James Houghton <jthoughton@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, David Matlack <dmatlack@google.com>, 
	David Rientjes <rientjes@google.com>, Marc Zyngier <maz@kernel.org>, 
	Oliver Upton <oliver.upton@linux.dev>, Wei Xu <weixugc@google.com>, Yu Zhao <yuzhao@google.com>, 
	Axel Rasmussen <axelrasmussen@google.com>, kvm@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="us-ascii"

It's not a lockless walk of the memslots.  The walk of memslots is already
"lockless" in that the memslots are protected by SRCU, not by mmu_lock.

On Tue, Feb 04, 2025, James Houghton wrote:
> It is possible to correctly do aging without taking the KVM MMU lock;
> this option allows such architectures to do so. Architectures that
> select CONFIG_KVM_MMU_NOTIFIER_AGING_LOCKLESS are responsible for
> correctness.
> 
> Suggested-by: Yu Zhao <yuzhao@google.com>
> Signed-off-by: James Houghton <jthoughton@google.com>
> Reviewed-by: David Matlack <dmatlack@google.com>
> ---
>  include/linux/kvm_host.h |  1 +
>  virt/kvm/Kconfig         |  2 ++
>  virt/kvm/kvm_main.c      | 24 +++++++++++++++++-------
>  3 files changed, 20 insertions(+), 7 deletions(-)
> 
> diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
> index f34f4cfaa513..c28a6aa1f2ed 100644
> --- a/include/linux/kvm_host.h
> +++ b/include/linux/kvm_host.h
> @@ -267,6 +267,7 @@ struct kvm_gfn_range {
>  	union kvm_mmu_notifier_arg arg;
>  	enum kvm_gfn_range_filter attr_filter;
>  	bool may_block;
> +	bool lockless;
>  };
>  bool kvm_unmap_gfn_range(struct kvm *kvm, struct kvm_gfn_range *range);
>  bool kvm_age_gfn(struct kvm *kvm, struct kvm_gfn_range *range);
> diff --git a/virt/kvm/Kconfig b/virt/kvm/Kconfig
> index 54e959e7d68f..9356f4e4e255 100644
> --- a/virt/kvm/Kconfig
> +++ b/virt/kvm/Kconfig
> @@ -102,6 +102,8 @@ config KVM_GENERIC_MMU_NOTIFIER
>  
>  config KVM_ELIDE_TLB_FLUSH_IF_YOUNG
>         depends on KVM_GENERIC_MMU_NOTIFIER
> +
> +config KVM_MMU_NOTIFIER_AGING_LOCKLESS
>         bool

As noted by Stephen[*], this steals the "bool" from KVM_ELIDE_TLB_FLUSH_IF_YOUNG.

Looking at it with fresh eyes, it also fails to take a depenency on
KVM_GENERIC_MMU_NOTIFIER.

Lastly, the name is unnecessarily long.  The "NOTIFIER" part is superfluous and
can be dropped, as it's a property of the architecture's MMU, not of KVM's
mmu_notifier implementation. E.g. if KVM ever did aging outside of the notifier,
then this Kconfig would be relevant for that flow as well.  The dependency on
KVM_GENERIC_MMU_NOTIFIER is what communicates that its currently used only by
mmu_notifier aging.

Actually, I take "Lastly" back.  IMO, it reads much better as LOCKLESS_AGING,
because LOCKLESS is an adverb that describes the AGING process.

[*] https://lore.kernel.org/all/20250214181401.4e7dd91d@canb.auug.org.au

TL;DR: I'm squashing this:

diff --git a/arch/x86/kvm/Kconfig b/arch/x86/kvm/Kconfig
index f0a60e59c884..fe8ea8c097de 100644
--- a/arch/x86/kvm/Kconfig
+++ b/arch/x86/kvm/Kconfig
@@ -22,7 +22,7 @@ config KVM_X86
        select KVM_COMMON
        select KVM_GENERIC_MMU_NOTIFIER
        select KVM_ELIDE_TLB_FLUSH_IF_YOUNG
-       select KVM_MMU_NOTIFIER_AGING_LOCKLESS
+       select KVM_MMU_LOCKLESS_AGING
        select HAVE_KVM_IRQCHIP
        select HAVE_KVM_PFNCACHE
        select HAVE_KVM_DIRTY_RING_TSO
diff --git a/virt/kvm/Kconfig b/virt/kvm/Kconfig
index 9356f4e4e255..746e1f466aa6 100644
--- a/virt/kvm/Kconfig
+++ b/virt/kvm/Kconfig
@@ -102,8 +102,10 @@ config KVM_GENERIC_MMU_NOTIFIER
 
 config KVM_ELIDE_TLB_FLUSH_IF_YOUNG
        depends on KVM_GENERIC_MMU_NOTIFIER
+       bool
 
-config KVM_MMU_NOTIFIER_AGING_LOCKLESS
+config KVM_MMU_LOCKLESS_AGING
+       depends on KVM_GENERIC_MMU_NOTIFIER
        bool
 
 config KVM_GENERIC_MEMORY_ATTRIBUTES
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index e514e3db1b31..201c14ff476f 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -655,8 +655,7 @@ static __always_inline int kvm_age_hva_range(struct mmu_notifier *mn,
                .on_lock        = (void *)kvm_null_fn,
                .flush_on_ret   = flush_on_ret,
                .may_block      = false,
-               .lockless       =
-                       IS_ENABLED(CONFIG_KVM_MMU_NOTIFIER_AGING_LOCKLESS),
+               .lockless       = IS_ENABLED(CONFIG_KVM_MMU_LOCKLESS_AGING),
        };
 
        return kvm_handle_hva_range(kvm, &range).ret;

