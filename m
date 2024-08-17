Return-Path: <kvm+bounces-24471-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 876FF95547B
	for <lists+kvm@lfdr.de>; Sat, 17 Aug 2024 03:05:41 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id DD806B22126
	for <lists+kvm@lfdr.de>; Sat, 17 Aug 2024 01:05:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EF34D3D66;
	Sat, 17 Aug 2024 01:05:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="VNXQRC/f"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8A3A53FE4
	for <kvm@vger.kernel.org>; Sat, 17 Aug 2024 01:05:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723856730; cv=none; b=gr2vDJDr4QTMaeRlUmhzOtDmoLcMXKhG1rqs3jL3Ub25axbUeonBQryUBnZpvV11rWTDPuuKGFqUDxrc14pxCFrBvstZUDBlDbzVFlqhoeZqamINs2fveCBwkUI1iSnfVUqwdL1XZgdAXYjZsWs+EfOyWGfYx7Ggl83lgeTEkl8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723856730; c=relaxed/simple;
	bh=0dOcXqSyekOwkzzsmrHdpqTdMzvbrJ4ze01HnoKUsJw=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=alD7RHAZnphzoefUEjmHYk/uUofOg8LU68A5w0bXZNUYeZ8xdAGivim2alhRGrGNOlz0V1Jn3tH2oTEnDd8cNjVBX8xQ8C0XdnxIoav5gRE4Ln5/1DTU913zj7nen65uxLkUW8CAVtK10Z3yi0Lu3FFL9BQT2vPiSAynEARQ+G8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=VNXQRC/f; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-2cb81c562edso2327571a91.2
        for <kvm@vger.kernel.org>; Fri, 16 Aug 2024 18:05:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1723856728; x=1724461528; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=yZ3NIWTD82ZZqG4QrxvtzlxbU1NhadZyZ5e9GyWWoHs=;
        b=VNXQRC/fA9DTsq2dEP9RJQeGWbxKioigQGwbiwg6lX7f3nFx1NflLBDoEUKCoqt/bG
         SOJiJbeK2/EjkMVcVut8jPjb4Pj3WBbLH5bezIZcizEn3BB+sPwL8YsDUzam2IyMJtHR
         KUTc/SXX7fUDd01g/C9Kss2ZPC1O4KUhax2OTNuEJ3fUVX9bLrRAmSZlMAXn9E71GniR
         rs3gEDrORI4XO4rUW3lcyDDqWj3e2/ZKRqRTctIPm7M/ZgeCdAQtUIdIPSWej3t3e2AL
         USFi46urtTTNILpd5/TDwwOiXwrN6wLzy3Qyp6vVapfez3ZnBLJt+sSavShNO2xR9FDK
         RdnQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1723856728; x=1724461528;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=yZ3NIWTD82ZZqG4QrxvtzlxbU1NhadZyZ5e9GyWWoHs=;
        b=hTSakJIair2/vmjcGEox21K9eJxkgLRHfuHBy1BNTsRij3zPQYFj4bkXftmTM+AXxH
         7QSN3ii4eSGGH9GmW2YjUjEffoz/GRrQRJJDsyXRB0zbUfpLLcqSMtsb06GGjnvKe7mr
         UyCuDDktQUmBkVK2NPV6dp1a5Kumd1YJf4frzhA3a6siHWeBHs+j1chMc9a8//5VFixq
         A5EQKGQKs3jMkWbDG1iOjHHxxkTkyKKVVYSQCpV5Ko34zMPHGqOCQQRxBHcsRkArOGxa
         3YRtvpnYdcS9rLAvbRYhWxd1gBL2nBqR85r6MuWrQSCHmI4/iXlB9vgG4wUfqXN3Oku2
         i64w==
X-Forwarded-Encrypted: i=1; AJvYcCXXlKvtbUnQ3YviIM8HhsBmDlNeSCNDTjT5zzx05xEcfgAGiupwsg72yD0y48z+2Q/ir77tiJkoiCod8nHOoDLzpJ9v
X-Gm-Message-State: AOJu0Yw+OEF8sqgeN1OKsqv55ywEhRmmO5lXw75OOKB4ygZDIuGN+0Cv
	7+NUl5XiwMVfeAC+ysPf1eBEtHWvrbIb8FwTFh0MVFZhRuRVbm4pefPiPUjw/p+2anSXuSSyoAd
	0kA==
X-Google-Smtp-Source: AGHT+IGV4YzgxmwuCW8TgHBWt0j766Jl0TrT07V8PzpayCNsn2Lgz80apJLxO0myiLlSCmy6amt7b3XqQ7I=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:90a:c292:b0:2c9:a168:9719 with SMTP id
 98e67ed59e1d1-2d3e00f2177mr20697a91.6.1723856727684; Fri, 16 Aug 2024
 18:05:27 -0700 (PDT)
Date: Fri, 16 Aug 2024 18:05:26 -0700
In-Reply-To: <20240724011037.3671523-3-jthoughton@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240724011037.3671523-1-jthoughton@google.com> <20240724011037.3671523-3-jthoughton@google.com>
Message-ID: <Zr_3Vohvzt0KmFiN@google.com>
Subject: Re: [PATCH v6 02/11] KVM: x86: Relax locking for kvm_test_age_gfn and kvm_age_gfn
From: Sean Christopherson <seanjc@google.com>
To: James Houghton <jthoughton@google.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Paolo Bonzini <pbonzini@redhat.com>, 
	Ankit Agrawal <ankita@nvidia.com>, Axel Rasmussen <axelrasmussen@google.com>, 
	Catalin Marinas <catalin.marinas@arm.com>, David Matlack <dmatlack@google.com>, 
	David Rientjes <rientjes@google.com>, James Morse <james.morse@arm.com>, 
	Jason Gunthorpe <jgg@ziepe.ca>, Jonathan Corbet <corbet@lwn.net>, Marc Zyngier <maz@kernel.org>, 
	Oliver Upton <oliver.upton@linux.dev>, Raghavendra Rao Ananta <rananta@google.com>, 
	Ryan Roberts <ryan.roberts@arm.com>, Shaoqin Huang <shahuang@redhat.com>, 
	Suzuki K Poulose <suzuki.poulose@arm.com>, Wei Xu <weixugc@google.com>, 
	Will Deacon <will@kernel.org>, Yu Zhao <yuzhao@google.com>, Zenghui Yu <yuzenghui@huawei.com>, 
	kvmarm@lists.linux.dev, kvm@vger.kernel.org, 
	linux-arm-kernel@lists.infradead.org, linux-doc@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org
Content-Type: text/plain; charset="us-ascii"

On Wed, Jul 24, 2024, James Houghton wrote:
> Walk the TDP MMU in an RCU read-side critical section. 

...without holding mmu_lock, while doing xxx.  There are a lot of TDP MMU walks,
pand they all need RCU protection.

> This requires a way to do RCU-safe walking of the tdp_mmu_roots; do this with
> a new macro. The PTE modifications are now done atomically, and
> kvm_tdp_mmu_spte_need_atomic_write() has been updated to account for the fact
> that kvm_age_gfn can now lockless update the accessed bit and the R/X bits).
> 
> If the cmpxchg for marking the spte for access tracking fails, we simply
> retry if the spte is still a leaf PTE. If it isn't, we return false
> to continue the walk.

Please avoid pronouns.  E.g. s/we/KVM (and adjust grammar as needed), so that
it's clear what actor in particular is doing the retry.

> Harvesting age information from the shadow MMU is still done while
> holding the MMU write lock.
> 
> Suggested-by: Yu Zhao <yuzhao@google.com>
> Signed-off-by: James Houghton <jthoughton@google.com>
> ---
>  arch/x86/include/asm/kvm_host.h |  1 +
>  arch/x86/kvm/Kconfig            |  1 +
>  arch/x86/kvm/mmu/mmu.c          | 10 ++++-
>  arch/x86/kvm/mmu/tdp_iter.h     | 27 +++++++------
>  arch/x86/kvm/mmu/tdp_mmu.c      | 67 +++++++++++++++++++++++++--------
>  5 files changed, 77 insertions(+), 29 deletions(-)
> 
> diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
> index 950a03e0181e..096988262005 100644
> --- a/arch/x86/include/asm/kvm_host.h
> +++ b/arch/x86/include/asm/kvm_host.h
> @@ -1456,6 +1456,7 @@ struct kvm_arch {
>  	 * tdp_mmu_page set.
>  	 *
>  	 * For reads, this list is protected by:
> +	 *	RCU alone or
>  	 *	the MMU lock in read mode + RCU or
>  	 *	the MMU lock in write mode
>  	 *
> diff --git a/arch/x86/kvm/Kconfig b/arch/x86/kvm/Kconfig
> index 4287a8071a3a..6ac43074c5e9 100644
> --- a/arch/x86/kvm/Kconfig
> +++ b/arch/x86/kvm/Kconfig
> @@ -23,6 +23,7 @@ config KVM
>  	depends on X86_LOCAL_APIC
>  	select KVM_COMMON
>  	select KVM_GENERIC_MMU_NOTIFIER
> +	select KVM_MMU_NOTIFIER_YOUNG_LOCKLESS
>  	select HAVE_KVM_IRQCHIP
>  	select HAVE_KVM_PFNCACHE
>  	select HAVE_KVM_DIRTY_RING_TSO
> diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> index 901be9e420a4..7b93ce8f0680 100644
> --- a/arch/x86/kvm/mmu/mmu.c
> +++ b/arch/x86/kvm/mmu/mmu.c
> @@ -1633,8 +1633,11 @@ bool kvm_age_gfn(struct kvm *kvm, struct kvm_gfn_range *range)
>  {
>  	bool young = false;
>  
> -	if (kvm_memslots_have_rmaps(kvm))
> +	if (kvm_memslots_have_rmaps(kvm)) {
> +		write_lock(&kvm->mmu_lock);
>  		young = kvm_handle_gfn_range(kvm, range, kvm_age_rmap);
> +		write_unlock(&kvm->mmu_lock);
> +	}
>  
>  	if (tdp_mmu_enabled)
>  		young |= kvm_tdp_mmu_age_gfn_range(kvm, range);
> @@ -1646,8 +1649,11 @@ bool kvm_test_age_gfn(struct kvm *kvm, struct kvm_gfn_range *range)
>  {
>  	bool young = false;
>  
> -	if (kvm_memslots_have_rmaps(kvm))
> +	if (kvm_memslots_have_rmaps(kvm)) {
> +		write_lock(&kvm->mmu_lock);
>  		young = kvm_handle_gfn_range(kvm, range, kvm_test_age_rmap);
> +		write_unlock(&kvm->mmu_lock);
> +	}
>  
>  	if (tdp_mmu_enabled)
>  		young |= kvm_tdp_mmu_test_age_gfn(kvm, range);
> diff --git a/arch/x86/kvm/mmu/tdp_iter.h b/arch/x86/kvm/mmu/tdp_iter.h
> index 2880fd392e0c..510936a8455a 100644
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
> @@ -32,10 +39,11 @@ static inline void __kvm_tdp_mmu_write_spte(tdp_ptep_t sptep, u64 new_spte)
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
> + * Dirty bits can be set by the CPU, and the Accessed and R/X bits can be
> + * cleared by age_gfn_range.
>   *
>   * Note, non-leaf SPTEs do have Accessed bits and those bits are
>   * technically volatile, but KVM doesn't consume the Accessed bit of
> @@ -46,8 +54,7 @@ static inline void __kvm_tdp_mmu_write_spte(tdp_ptep_t sptep, u64 new_spte)
>  static inline bool kvm_tdp_mmu_spte_need_atomic_write(u64 old_spte, int level)
>  {
>  	return is_shadow_present_pte(old_spte) &&
> -	       is_last_spte(old_spte, level) &&
> -	       spte_has_volatile_bits(old_spte);
> +	       is_last_spte(old_spte, level);
>  }
>  
>  static inline u64 kvm_tdp_mmu_write_spte(tdp_ptep_t sptep, u64 old_spte,
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
> diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
> index c7dc49ee7388..3f13b2db53de 100644
> --- a/arch/x86/kvm/mmu/tdp_mmu.c
> +++ b/arch/x86/kvm/mmu/tdp_mmu.c
> @@ -29,6 +29,11 @@ static __always_inline bool kvm_lockdep_assert_mmu_lock_held(struct kvm *kvm,
>  
>  	return true;
>  }
> +static __always_inline bool kvm_lockdep_assert_rcu_read_lock_held(void)
> +{
> +	WARN_ON_ONCE(!rcu_read_lock_held());
> +	return true;
> +}

I doubt KVM needs a manual WARN, the RCU deference stuff should yell loudly if
something is missing an rcu_read_lock().

>  void kvm_mmu_uninit_tdp_mmu(struct kvm *kvm)
>  {
> @@ -178,6 +183,15 @@ static struct kvm_mmu_page *tdp_mmu_next_root(struct kvm *kvm,
>  		     ((_only_valid) && (_root)->role.invalid))) {		\
>  		} else
>  
> +/*
> + * Iterate over all TDP MMU roots in an RCU read-side critical section.
> + */
> +#define for_each_tdp_mmu_root_rcu(_kvm, _root, _as_id)				\
> +	list_for_each_entry_rcu(_root, &_kvm->arch.tdp_mmu_roots, link)		\

This should just process valid roots:

https://lore.kernel.org/all/20240801183453.57199-7-seanjc@google.com

> +		if (kvm_lockdep_assert_rcu_read_lock_held() &&			\
> +		    (_as_id >= 0 && kvm_mmu_page_as_id(_root) != _as_id)) {	\
> +		} else
> +
>  #define for_each_tdp_mmu_root(_kvm, _root, _as_id)			\
>  	__for_each_tdp_mmu_root(_kvm, _root, _as_id, false)
>  
> @@ -1224,6 +1238,27 @@ static __always_inline bool kvm_tdp_mmu_handle_gfn(struct kvm *kvm,
>  	return ret;
>  }
>  
> +static __always_inline bool kvm_tdp_mmu_handle_gfn_lockless(
> +		struct kvm *kvm,
> +		struct kvm_gfn_range *range,
> +		tdp_handler_t handler)

Please burn all the Google3 from your brain, and code ;-)

> +	struct kvm_mmu_page *root;
> +	struct tdp_iter iter;
> +	bool ret = false;
> +
> +	rcu_read_lock();
> +
> +	for_each_tdp_mmu_root_rcu(kvm, root, range->slot->as_id) {
> +		tdp_root_for_each_leaf_pte(iter, root, range->start, range->end)
> +			ret |= handler(kvm, &iter, range);
> +	}
> +
> +	rcu_read_unlock();
> +
> +	return ret;
> +}
> +
>  /*
>   * Mark the SPTEs range of GFNs [start, end) unaccessed and return non-zero
>   * if any of the GFNs in the range have been accessed.
> @@ -1237,28 +1272,30 @@ static bool age_gfn_range(struct kvm *kvm, struct tdp_iter *iter,
>  {
>  	u64 new_spte;
>  
> +retry:
>  	/* If we have a non-accessed entry we don't need to change the pte. */
>  	if (!is_accessed_spte(iter->old_spte))
>  		return false;
>  
>  	if (spte_ad_enabled(iter->old_spte)) {
> -		iter->old_spte = tdp_mmu_clear_spte_bits(iter->sptep,
> -							 iter->old_spte,
> -							 shadow_accessed_mask,
> -							 iter->level);
> +		iter->old_spte = tdp_mmu_clear_spte_bits_atomic(iter->sptep,
> +						shadow_accessed_mask);
>  		new_spte = iter->old_spte & ~shadow_accessed_mask;
>  	} else {
> -		/*
> -		 * Capture the dirty status of the page, so that it doesn't get
> -		 * lost when the SPTE is marked for access tracking.
> -		 */
> +		new_spte = mark_spte_for_access_track(iter->old_spte);
> +		if (__tdp_mmu_set_spte_atomic(iter, new_spte)) {
> +			/*
> +			 * The cmpxchg failed. If the spte is still a
> +			 * last-level spte, we can safely retry.
> +			 */
> +			if (is_shadow_present_pte(iter->old_spte) &&
> +			    is_last_spte(iter->old_spte, iter->level))
> +				goto retry;

Do we have a feel for how often conflicts actually happen?  I.e. is it worth
retrying and having to worry about infinite loops, however improbable they may
be?

