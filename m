Return-Path: <kvm+bounces-35128-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id D1DCFA09E52
	for <lists+kvm@lfdr.de>; Fri, 10 Jan 2025 23:47:22 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id D8F1A3A28D7
	for <lists+kvm@lfdr.de>; Fri, 10 Jan 2025 22:47:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E722721C183;
	Fri, 10 Jan 2025 22:47:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="AzRdOhqe"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 696F521505A
	for <kvm@vger.kernel.org>; Fri, 10 Jan 2025 22:47:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736549232; cv=none; b=KrBepGCplpRGFM07F83Zrx65+E/mzv0LPZV3Y/zdycjrwWjHznHzaGL959pVyU4xqbY6GBmK4sV5yAEDeH3h93LvfcvGiG5wd/msJUHTJ3A8Pi5D2rNDQW7Ooww5RvF79Ft0XnhwkIcL4UhMQlEw2oD9ex/4M1TajfocKOdb//k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736549232; c=relaxed/simple;
	bh=gBGyXI608yRBgSW4JSARFI9S8eEZSizuYVREKJq3xvc=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=bJ2dQ8D0UddpHklibsEPoLYqRpdwuehN6LZsSJVUTzBB8JfEEywHk7NQ41AG/C9YIcTGody4VA9kEX76gtMqtGAtTTITZMC8UTEkzwc7AxGtQuCFnQiibXOU/NOMOo1P3Kp+E8fsq0xL3UOC0MG2vst6I0aw/PvPrX8AbAGsfAM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=AzRdOhqe; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-2ef6ef86607so6189591a91.0
        for <kvm@vger.kernel.org>; Fri, 10 Jan 2025 14:47:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1736549230; x=1737154030; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=TPpxNrV6BsHc37yD1ep1eKd05UzXKjg8/YN/tXFY4bc=;
        b=AzRdOhqekjyQZKnxoUyf92iBVew+qBxsmo2iSKmO0lrGbu4nLG7zCWTm9JgYgNXA80
         lqbJ75Cbgp3osJHpsoEvzYnTVnDaSWk6vgoG9DFZcATiYIb0G1pJYpnc3iEzY1ZmhPzo
         BVvthadkokGa9KyHWFcOvuitrVMmO4mpDg/ZUbWSuPkj8mw/opFY6ThFaVON3Rq+ud0G
         btEfgxDUqZpvlhaJIS1tngKXsFIm2zGZ63EMpdWgniLAiFFXf6GqF8+vIB4/1isHO6Xr
         irXsW85nav13EoiN5Tt6bUOJEnoPu1jyU3oPruZEQ0ujoGtdW12eVkl5S4qICmV5b4rw
         cbPA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1736549230; x=1737154030;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=TPpxNrV6BsHc37yD1ep1eKd05UzXKjg8/YN/tXFY4bc=;
        b=mM3Sc8zytDFGPkhVOEmF3+uwvTvYOAu3OI90H80avF6N07q/R+hN0GA33rHRzxzSQP
         hHXEwqx82GSUKF8qg4YAeb3021WKz7XUiD/vlGZP8FlwRsgV7jdvk37YRAQBbhaeOC6Y
         V2y6UBNaRHVHFSx2CJHo1oklYoDJ4UFCx+boU40//ffyy43T+kYNzqPu/xI6PgComVAm
         JRR1QnzmTsPtzVsH6B5E1I7p5F7ViXFLjQKbrJ4AOFgT1jLPO4v0Kc9VlzTNqrpezhAR
         Db5o9R0eYIc45Gqw0brUGcd0sYX4WRp7OCEGfRVzYhJbFHEvF0zRnmEayZooCm0Rhoel
         UOEQ==
X-Forwarded-Encrypted: i=1; AJvYcCXI596iPL0akZnbAf0tlasq0kmLDUCX5rt6OqK8u5NPc6fw4hVNbc0+XDkSV8UYd+B7HOI=@vger.kernel.org
X-Gm-Message-State: AOJu0YwDF72p+IrnSdGjTT4Z2GYwhLn2rWCzfCo3/ek2b+6EuuaM9OOy
	YRodfpuaEDgWgpZrsd0++FH0IN8GSSAgUklq7cluQb7onXwKWWcngDpXZQDhUI8aVwbap4ZiFWi
	EQw==
X-Google-Smtp-Source: AGHT+IEjAzGZKOKBjNQ//t1p3nnpvidx5hXZsZ/pbUos8Qwkif23Ufw2zH1uJY3/BxK+5/FnkpzIkO+0RJ0=
X-Received: from pjx13.prod.google.com ([2002:a17:90b:568d:b0:2ee:4a90:3d06])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:4d10:b0:2ef:2980:4411
 with SMTP id 98e67ed59e1d1-2f55443a040mr12242563a91.9.1736549229771; Fri, 10
 Jan 2025 14:47:09 -0800 (PST)
Date: Fri, 10 Jan 2025 14:47:08 -0800
In-Reply-To: <20241105184333.2305744-5-jthoughton@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20241105184333.2305744-1-jthoughton@google.com> <20241105184333.2305744-5-jthoughton@google.com>
Message-ID: <Z4GjbCRgyBe7k9gw@google.com>
Subject: Re: [PATCH v8 04/11] KVM: x86/mmu: Relax locking for kvm_test_age_gfn
 and kvm_age_gfn
From: Sean Christopherson <seanjc@google.com>
To: James Houghton <jthoughton@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, David Matlack <dmatlack@google.com>, 
	David Rientjes <rientjes@google.com>, Marc Zyngier <maz@kernel.org>, 
	Oliver Upton <oliver.upton@linux.dev>, Wei Xu <weixugc@google.com>, Yu Zhao <yuzhao@google.com>, 
	Axel Rasmussen <axelrasmussen@google.com>, kvm@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="us-ascii"

On Tue, Nov 05, 2024, James Houghton wrote:
> diff --git a/arch/x86/kvm/mmu/tdp_iter.h b/arch/x86/kvm/mmu/tdp_iter.h
> index a24fca3f9e7f..f26d0b60d2dd 100644
> --- a/arch/x86/kvm/mmu/tdp_iter.h
> +++ b/arch/x86/kvm/mmu/tdp_iter.h
> @@ -39,10 +39,11 @@ static inline void __kvm_tdp_mmu_write_spte(tdp_ptep_t sptep, u64 new_spte)
>  }
>  
>  /*
> - * SPTEs must be modified atomically if they are shadow-present, leaf
> - * SPTEs, and have volatile bits, i.e. has bits that can be set outside
> - * of mmu_lock.  The Writable bit can be set by KVM's fast page fault
> - * handler, and Accessed and Dirty bits can be set by the CPU.
> + * SPTEs must be modified atomically if they have bits that can be set outside
> + * of the mmu_lock. This can happen for any shadow-present leaf SPTEs, as the
> + * Writable bit can be set by KVM's fast page fault handler, the Accessed and
> + * Dirty bits can be set by the CPU, and the Accessed and W/R/X bits can be
> + * cleared by age_gfn_range().
>   *
>   * Note, non-leaf SPTEs do have Accessed bits and those bits are
>   * technically volatile, but KVM doesn't consume the Accessed bit of
> @@ -53,8 +54,7 @@ static inline void __kvm_tdp_mmu_write_spte(tdp_ptep_t sptep, u64 new_spte)
>  static inline bool kvm_tdp_mmu_spte_need_atomic_write(u64 old_spte, int level)
>  {
>  	return is_shadow_present_pte(old_spte) &&
> -	       is_last_spte(old_spte, level) &&
> -	       spte_has_volatile_bits(old_spte);
> +	       is_last_spte(old_spte, level);

I don't like this change on multiple fronts.  First and foremost, it results in
spte_has_volatile_bits() being wrong for the TDP MMU.  Second, the same logic
applies to the shadow MMU; the rmap lock prevents a use-after-free of the page
that owns the SPTE, but the zapping of the SPTE happens before the writer grabs
the rmap lock.

Lastly, I'm very, very tempted to say we should omit Accessed state from
spte_has_volatile_bits() and rename it to something like spte_needs_atomic_write().
KVM x86 no longer flushes TLBs on aging, so we're already committed to incorrectly
thinking a page is old in rare cases, for the sake of performance.  The odds of
KVM clobbering the Accessed bit are probably smaller than the odds of missing an
Accessed update due to a stale TLB entry.

Note, only the shadow_accessed_mask check can be removed.  KVM needs to ensure
access-tracked SPTEs are zapped properly, and dirty logging can't have false
negatives.

>  }
>  
>  static inline u64 kvm_tdp_mmu_write_spte(tdp_ptep_t sptep, u64 old_spte,
> diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
> index 4508d868f1cd..f5b4f1060fff 100644
> --- a/arch/x86/kvm/mmu/tdp_mmu.c
> +++ b/arch/x86/kvm/mmu/tdp_mmu.c
> @@ -178,6 +178,15 @@ static struct kvm_mmu_page *tdp_mmu_next_root(struct kvm *kvm,
>  		     ((_only_valid) && (_root)->role.invalid))) {		\
>  		} else
>  
> +/*
> + * Iterate over all TDP MMU roots in an RCU read-side critical section.

Heh, that's pretty darn obvious.  It would be far more helpful if the comment
explained the usage rules, e.g. what is safe (at a high level).

> + */
> +#define for_each_valid_tdp_mmu_root_rcu(_kvm, _root, _as_id)			\
> +	list_for_each_entry_rcu(_root, &_kvm->arch.tdp_mmu_roots, link)		\
> +		if ((_as_id >= 0 && kvm_mmu_page_as_id(_root) != _as_id) ||	\
> +		    (_root)->role.invalid) {					\
> +		} else
> +
>  #define for_each_tdp_mmu_root(_kvm, _root, _as_id)			\
>  	__for_each_tdp_mmu_root(_kvm, _root, _as_id, false)
>  
> @@ -1168,16 +1177,16 @@ static void kvm_tdp_mmu_age_spte(struct tdp_iter *iter)
>  	u64 new_spte;
>  
>  	if (spte_ad_enabled(iter->old_spte)) {
> -		iter->old_spte = tdp_mmu_clear_spte_bits(iter->sptep,
> -							 iter->old_spte,
> -							 shadow_accessed_mask,
> -							 iter->level);
> +		iter->old_spte = tdp_mmu_clear_spte_bits_atomic(iter->sptep,
> +						shadow_accessed_mask);

Align, and let this poke past 80:

		iter->old_spte = tdp_mmu_clear_spte_bits_atomic(iter->sptep,
								shadow_accessed_mask);

>  		new_spte = iter->old_spte & ~shadow_accessed_mask;
>  	} else {
>  		new_spte = mark_spte_for_access_track(iter->old_spte);
> -		iter->old_spte = kvm_tdp_mmu_write_spte(iter->sptep,
> -							iter->old_spte, new_spte,
> -							iter->level);
> +		/*
> +		 * It is safe for the following cmpxchg to fail. Leave the
> +		 * Accessed bit set, as the spte is most likely young anyway.
> +		 */
> +		(void)__tdp_mmu_set_spte_atomic(iter, new_spte);

Just a reminder that this needs to be:

		if (__tdp_mmu_set_spte_atomic(iter, new_spte))
			return;

>  	}
>  
>  	trace_kvm_tdp_mmu_spte_changed(iter->as_id, iter->gfn, iter->level,
> -- 
> 2.47.0.199.ga7371fff76-goog
> 

