Return-Path: <kvm+bounces-35124-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id C3C3CA09E14
	for <lists+kvm@lfdr.de>; Fri, 10 Jan 2025 23:35:47 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id EF126188F0E0
	for <lists+kvm@lfdr.de>; Fri, 10 Jan 2025 22:34:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 461CA22A7F4;
	Fri, 10 Jan 2025 22:27:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="hscUQxBm"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f202.google.com (mail-pl1-f202.google.com [209.85.214.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E694C2206AC
	for <kvm@vger.kernel.org>; Fri, 10 Jan 2025 22:26:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736548020; cv=none; b=e2SC1dWkupzuYrbSVy9S2/mXDjHGidMN13QD/36QjZEOoWbU1CEV56ppxbSPJPIVjots+kuQP8tCs4Vbfv0AQNJYhpQxjBhXk+uqIOB8uVlSj3gSwQqQX5wklo6w9KjrXUXOEubEtV8frJ7bTV2jOGO4EkV3pMaSO9eAfIfPGsQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736548020; c=relaxed/simple;
	bh=Pcx+R3fadqR8i+pEPA2IHKuFIO3ZaiOLpTp2J3FQjz4=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=XXYHj3KLnvEz0incCfKDQO9If4QCINRWbP110wX4C7T64T6E1AcqrmMLZ/1HPb3R8mr6Xo07/ijdc+Q2L4hXhnZceIliGrCk7H3LdPkK+vEvM48yCRNELsVIKm+KwwMwXk2op7VgTaFjANliD3G+m8iLxjyFGoOH1F2x7/rHzvg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=hscUQxBm; arc=none smtp.client-ip=209.85.214.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pl1-f202.google.com with SMTP id d9443c01a7336-2162f80040aso41740025ad.1
        for <kvm@vger.kernel.org>; Fri, 10 Jan 2025 14:26:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1736548018; x=1737152818; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=fEsU6RMH1W46X1SLBMbYA3uv4BeTBfcbXbSDcpsXPug=;
        b=hscUQxBmb3ZPsvKYk6ftF+qp2R7tWzqYTLmu+PyQIBZw9rOGW48vUuENaFQLrSduBP
         RpYYE7munkUcElDl/D63B3elSU8bgOtKqFR5d6KbhSsZ/TKgvuvik+uujuJaLjNeWOP+
         C3ahryL2vGTcjyw5l8lhVOhZpR6FmJFDOrKdG0T/4zf6txGDWcNm8W3lZlBiZen7O0hG
         n1LmA6v4DBRCEhDGTGAkL1srxZPTVehWDCwfPvhrj5tFN727vZ1T60ciubL8mbhmG9LE
         b/yH8amylxvnQyx3CGXT1BeLDGPm4r9YUoGb/K/dMJGlEwS3oXFEBRPe5srE0wz/vURN
         vtLQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1736548018; x=1737152818;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=fEsU6RMH1W46X1SLBMbYA3uv4BeTBfcbXbSDcpsXPug=;
        b=KUPlZF59tVqCRR6EOazdYBlvY2uiJspUwCPAUzBLjaYsed+pcmA6XlDnTAMBcWwvhW
         6KjrPnCIILMP08y06+1XqofTeX2hpk0XihoN1krOmlLmYFTiOGokqM4cbZbuy1dA3x6p
         +MikjmFW36ZqPNQRV3Ak8Vr6tHJbEZ/C32++YxHe7mG6y3nRhIT8oa0kdO8TYtqpmII8
         RYgmgUaQGRSAPmwWXgOPKLyHzxupjkdQzmjXnQ3cS2Jj6rc9SRp8OWOx7X5z7rVRwmQD
         i370N9ip/67NzDssFVXXN5pGTUsjZw1CePvJ8afa7qDxUJdpOnSvoqUismEhtrD76b8k
         cGEg==
X-Forwarded-Encrypted: i=1; AJvYcCX3YkHapJ3dy0vihsTe1h7GzvUjyi4+8Jv4/kSh7Rjk2mdRlyIVQKtr/Zxdm4qNfHXsKio=@vger.kernel.org
X-Gm-Message-State: AOJu0YyHDmmt33mOm5sI3nOCTGS2ae159bHKiy/Nmje0ZdzK8HaOSWjq
	nTIEJR6dfrrOekMXpP5jypumTDfPnP9xNaQYrQU4r90+1r6QBIJGmeIcTNxboX1daaMk9lxvdwP
	XQA==
X-Google-Smtp-Source: AGHT+IEggY/mLMoIDtmJXeaMESW9B/tj8INlEz2E3t6TfwwBpsSiojT6gOZ6wAdF12kfvT4YWbDBTxJuHGo=
X-Received: from pfbgc3.prod.google.com ([2002:a05:6a00:62c3:b0:725:3321:1f0c])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a20:7fa5:b0:1dc:bdb1:349e
 with SMTP id adf61e73a8af0-1e88d0ff203mr17998470637.17.1736548018309; Fri, 10
 Jan 2025 14:26:58 -0800 (PST)
Date: Fri, 10 Jan 2025 14:26:57 -0800
In-Reply-To: <20241105184333.2305744-3-jthoughton@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20241105184333.2305744-1-jthoughton@google.com> <20241105184333.2305744-3-jthoughton@google.com>
Message-ID: <Z4GesYBOCNhoUKJx@google.com>
Subject: Re: [PATCH v8 02/11] KVM: Add lockless memslot walk to KVM
From: Sean Christopherson <seanjc@google.com>
To: James Houghton <jthoughton@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, David Matlack <dmatlack@google.com>, 
	David Rientjes <rientjes@google.com>, Marc Zyngier <maz@kernel.org>, 
	Oliver Upton <oliver.upton@linux.dev>, Wei Xu <weixugc@google.com>, Yu Zhao <yuzhao@google.com>, 
	Axel Rasmussen <axelrasmussen@google.com>, kvm@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="us-ascii"

On Tue, Nov 05, 2024, James Houghton wrote:
> Provide flexibility to the architecture to synchronize as optimally as

Similar to my nit on "locking" below, "synchronize" is somewhat misleading.  There's
no requirement for architectures to synchronize during aging.  There is all but
guaranteed to be some form of "synchronization", e.g. to prevent walking freed
page tables, but the aging itself never synchronizes, and protecting a walk by
disabling IRQs (as x86's shadow MMU does in some flows) only "synchronizes" in a
loose sense of the word.

> they can instead of always taking the MMU lock for writing.
> 
> Architectures that do their own locking must select
> CONFIG_KVM_MMU_NOTIFIER_YOUNG_LOCKLESS.

This is backwards and could be misleading, and for the TDP MMU outright wrong.
If some hypothetical architecture took _additional_ locks, then it can do so
without needing to select CONFIG_KVM_MMU_NOTIFIER_YOUNG_LOCKLESS.

What you want to say is that architectures that select
CONFIG_KVM_MMU_NOTIFIER_YOUNG_LOCKLESS are responsible for ensuring correctness.
And it's specifically all about correctness.  Common KVM doesn't care if the
arch does it's own locking, e.g. taking mmu_lock for read, or has some completely
lock-free scheme for aging.

> The immediate application is to allow architectures to implement the

"immediate application" is pretty redundant.  There's really only one reason to
not take mmu_lock in this path.

> test/clear_young MMU notifiers more cheaply.

IMO, "more cheaply" is vague, and doesn't add much beyond the opening sentence
about "synchronize as optimally as they can".  I would just delete this last
sentence.

> Suggested-by: Yu Zhao <yuzhao@google.com>
> Signed-off-by: James Houghton <jthoughton@google.com>
> Reviewed-by: David Matlack <dmatlack@google.com>
> ---
> @@ -797,6 +805,8 @@ static int kvm_mmu_notifier_clear_flush_young(struct mmu_notifier *mn,
>  		.flush_on_ret	=
>  			!IS_ENABLED(CONFIG_KVM_ELIDE_TLB_FLUSH_IF_YOUNG),
>  		.may_block	= false,
> +		.lockless	=
> +			IS_ENABLED(CONFIG_KVM_MMU_NOTIFIER_YOUNG_LOCKLESS),

		.lockess	= IS_ENABLED(CONFIG_KVM_MMU_NOTIFIER_YOUNG_LOCKLESS),

Random thought, maybe CONFIG_KVM_MMU_NOTIFIER_AGING_LOCKLESS or
CONFIG_KVM_MMU_NOTIFIER_AGE_LOCKLESS instead of "YOUNG"?

>  	};
>  
>  	trace_kvm_age_hva(start, end);
> @@ -817,6 +827,8 @@ static int kvm_mmu_notifier_clear_young(struct mmu_notifier *mn,
>  		.on_lock	= (void *)kvm_null_fn,
>  		.flush_on_ret	= false,
>  		.may_block	= false,
> +		.lockless	=
> +			IS_ENABLED(CONFIG_KVM_MMU_NOTIFIER_YOUNG_LOCKLESS),
>  	};
>  
>  	trace_kvm_age_hva(start, end);
> @@ -849,6 +861,8 @@ static int kvm_mmu_notifier_test_young(struct mmu_notifier *mn,
>  		.on_lock	= (void *)kvm_null_fn,
>  		.flush_on_ret	= false,
>  		.may_block	= false,
> +		.lockless	=
> +			IS_ENABLED(CONFIG_KVM_MMU_NOTIFIER_YOUNG_LOCKLESS),
>  	};
>  
>  	trace_kvm_test_age_hva(address);
> -- 
> 2.47.0.199.ga7371fff76-goog
> 

