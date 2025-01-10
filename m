Return-Path: <kvm+bounces-35125-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id BB5B0A09E27
	for <lists+kvm@lfdr.de>; Fri, 10 Jan 2025 23:37:22 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id CC0EF7A3181
	for <lists+kvm@lfdr.de>; Fri, 10 Jan 2025 22:36:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 11671224AE3;
	Fri, 10 Jan 2025 22:34:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="RU4uyQVp"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AB8262248AD
	for <kvm@vger.kernel.org>; Fri, 10 Jan 2025 22:34:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736548448; cv=none; b=GKjbkExxTZEYYRTTaOSVmREHVhJ7ngTzrg5W+y3+tesX/VmEGAru2sx4Mh2hh3dsLoScfutjpZeSVgvb3KwdlyZNl80sgx5o/eV/x00ifxwlOsQOcahwQlKHnfJNIVFKH4gYggohbnAJF021x7qN0/d+t+vX0+qn1gTQv1uJPqs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736548448; c=relaxed/simple;
	bh=QhXWiFicIHGyIb+atPjAutlwdLtBYGpec+stYRCczYY=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=JLFb17AMnwfK1/4/Bxzaloe6UK7hduYTJnqjwX77MuOyiexz/A2d1tsStx9bqUOGagomqtve8R5BqimVt69Ee0WGEalACQwxm+mmHr9alOfoWHBBhuXl6ECMBSrCauPKm+2Q4VA1Avgk53pTLAv53OY3bTP9FqP5tdPnjhSnle0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=RU4uyQVp; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-2ef775ec883so4513787a91.1
        for <kvm@vger.kernel.org>; Fri, 10 Jan 2025 14:34:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1736548446; x=1737153246; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=toPMy/p1FGPMloT0sAIUsexrUKcnNTRt9KQgn0hs/FI=;
        b=RU4uyQVpKyXRuQeCkEkvEeF3ILJE/Jm7gD/o2HmCTQBJ3ZTvHEZK4AF8UHZS1VMtdE
         wbeBPq6JfPqrXrcBU9YzuRReJO7EImkeO5f87QGN2e4O2yXYa7L/Cu1AzyQW0Zz2dwz6
         OkSJGDaBQiqSrQio3/vGs1vtw4YfIekLkBeS+3KZkr3NRGH3leghzbS+r3MIfCiI3H+H
         uIR/LKSNgvC1tKGcBvmAX314w2D3muYwwbBawnh8hxEKpjIOnZEIp8QmdpykQ6kgiMiC
         NGYvR5IC/PBUkm2IBbqcA/BkJUoFSgGLif0moxUUgqoAbvSSkHheMlqfsDgIyARJf7N8
         rzDA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1736548446; x=1737153246;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=toPMy/p1FGPMloT0sAIUsexrUKcnNTRt9KQgn0hs/FI=;
        b=GSaK8SuTswFGShkvZFncEc4Qn8eEALRRf98FZ4wVG3n5mPuFXl8pWCUE14JcGqfOJX
         ZFKWcHfcmxvJnrFx9Ddf2o2s4OzzjB3GnsfXMe3o5rlkfMJmPWumhzXHgPnJAac3eSLE
         QbuS1zKoAaFGw4CCh9v+15cV5nGJuqRuv4aC6SXSysZVQCpdKrtwFlw7zIm1l3RRuSrN
         oaX6DWLMvmulGk3b6J1YATnSNJTSyuwmxKI1IEVm34hqv5fwwR2nwzQOk7An7Qd24+8r
         ZoLGhuwi/BEeOStZgZL98c5IwWZjERQ4F/TdbAhyWsTV4xkeEpvh74hE3TqvTeApQkin
         5VUw==
X-Forwarded-Encrypted: i=1; AJvYcCWmEWVGKqe2gj10TgjWI+VHLje5Cf/keLBqQxOqN5mJ4HclgeS6j+H4V0yYngcVWypwUEI=@vger.kernel.org
X-Gm-Message-State: AOJu0YzqnkB29XR02QJctZ4LxrG00+X7VNrzqVXrlxN46dh8JJwbbDzb
	KzlAjqfgv2+eUZzhWaK/ZkWv0bj5DgdUmPtEXx3KfS0JHwZlKUSmNGrnTTVAPLJn4TBgQZs7z3+
	ZnA==
X-Google-Smtp-Source: AGHT+IEk2Z2gcbkycWhUhHC/lVeYrgSkArCCD2IOK/WGv6zeS0D9LDXtvPqkULftwsZBr7LJiZeXo3F7qnw=
X-Received: from pfbcm15.prod.google.com ([2002:a05:6a00:338f:b0:728:e508:8a3e])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a00:a8f:b0:72a:ae66:3050
 with SMTP id d2e1a72fcca58-72d21f31510mr14154004b3a.1.1736548446042; Fri, 10
 Jan 2025 14:34:06 -0800 (PST)
Date: Fri, 10 Jan 2025 14:34:04 -0800
In-Reply-To: <20241105184333.2305744-4-jthoughton@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20241105184333.2305744-1-jthoughton@google.com> <20241105184333.2305744-4-jthoughton@google.com>
Message-ID: <Z4GgXNRUi3Hxv0mq@google.com>
Subject: Re: [PATCH v8 03/11] KVM: x86/mmu: Factor out spte atomic bit
 clearing routine
From: Sean Christopherson <seanjc@google.com>
To: James Houghton <jthoughton@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, David Matlack <dmatlack@google.com>, 
	David Rientjes <rientjes@google.com>, Marc Zyngier <maz@kernel.org>, 
	Oliver Upton <oliver.upton@linux.dev>, Wei Xu <weixugc@google.com>, Yu Zhao <yuzhao@google.com>, 
	Axel Rasmussen <axelrasmussen@google.com>, kvm@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="us-ascii"

On Tue, Nov 05, 2024, James Houghton wrote:
> This new function, tdp_mmu_clear_spte_bits_atomic(), will be used in a
> follow-up patch to enable lockless Accessed and R/W/X bit clearing.

This is a lie.  tdp_mmu_clear_spte_bits_atomic() can only be used to clear the
Accessed bit, clearing RWX bits for access-tracked SPTEs *must* be done with a
CMPXCHG so that the original RWX protections are preserved.

> Signed-off-by: James Houghton <jthoughton@google.com>
> ---
>  arch/x86/kvm/mmu/tdp_iter.h | 15 +++++++++------
>  1 file changed, 9 insertions(+), 6 deletions(-)
> 
> diff --git a/arch/x86/kvm/mmu/tdp_iter.h b/arch/x86/kvm/mmu/tdp_iter.h
> index 2880fd392e0c..a24fca3f9e7f 100644
> --- a/arch/x86/kvm/mmu/tdp_iter.h
> +++ b/arch/x86/kvm/mmu/tdp_iter.h
> @@ -25,6 +25,13 @@ static inline u64 kvm_tdp_mmu_write_spte_atomic(tdp_ptep_t sptep, u64 new_spte)
>  	return xchg(rcu_dereference(sptep), new_spte);
>  }
>  
> +static inline u64 tdp_mmu_clear_spte_bits_atomic(tdp_ptep_t sptep, u64 mask)
> +{
> +	atomic64_t *sptep_atomic = (atomic64_t *)rcu_dereference(sptep);
> +
> +	return (u64)atomic64_fetch_and(~mask, sptep_atomic);
> +}
> +
>  static inline void __kvm_tdp_mmu_write_spte(tdp_ptep_t sptep, u64 new_spte)
>  {
>  	KVM_MMU_WARN_ON(is_ept_ve_possible(new_spte));
> @@ -63,12 +70,8 @@ static inline u64 kvm_tdp_mmu_write_spte(tdp_ptep_t sptep, u64 old_spte,
>  static inline u64 tdp_mmu_clear_spte_bits(tdp_ptep_t sptep, u64 old_spte,
>  					  u64 mask, int level)
>  {
> -	atomic64_t *sptep_atomic;
> -
> -	if (kvm_tdp_mmu_spte_need_atomic_write(old_spte, level)) {
> -		sptep_atomic = (atomic64_t *)rcu_dereference(sptep);
> -		return (u64)atomic64_fetch_and(~mask, sptep_atomic);
> -	}
> +	if (kvm_tdp_mmu_spte_need_atomic_write(old_spte, level))
> +		return tdp_mmu_clear_spte_bits_atomic(sptep, mask);
>  
>  	__kvm_tdp_mmu_write_spte(sptep, old_spte & ~mask);
>  	return old_spte;
> -- 
> 2.47.0.199.ga7371fff76-goog
> 

