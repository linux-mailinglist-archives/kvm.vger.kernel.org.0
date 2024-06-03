Return-Path: <kvm+bounces-18688-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 3F3EC8D887D
	for <lists+kvm@lfdr.de>; Mon,  3 Jun 2024 20:13:50 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 5C7161C21AAA
	for <lists+kvm@lfdr.de>; Mon,  3 Jun 2024 18:13:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3B6D6137C48;
	Mon,  3 Jun 2024 18:13:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="WLjG6Rh0"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yw1-f201.google.com (mail-yw1-f201.google.com [209.85.128.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CA379131182
	for <kvm@vger.kernel.org>; Mon,  3 Jun 2024 18:13:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717438423; cv=none; b=UMFwLW0Gid+qd+grnCeLy0euU/M03oudPfaPGhSe4ZBBBNQ6c99BDYDb/w9nqZFZbO+HqrygMkJTrLoKUg5s8xZjamFEvgMBglY0GYeUV7OFcjiHzcsoE4IhukOs401KAhpyttOuNBPBrRPIL2jVh6txAT+yxpTwbrJ7vVzghJ4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717438423; c=relaxed/simple;
	bh=u+Dy4tgn6EC/08s6mF50xhFYJJFzYpL9OoBceQqwBZo=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=YNoBeqHm1bN/DJ2ytFQlUirJxrk6DpVHN37dfJBpi7eY/PmCsqO/YVXwDcuoSewXHaucLdNf5YrVzNt1DZXrpkebLrT1GMHGSXoGhh8mTlxU//Dje/P9KJsma4rnT0wUmxP9MjR6we+2XCnVjpggnOIlHd49v0+ClYTvWvLtsWA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=WLjG6Rh0; arc=none smtp.client-ip=209.85.128.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-yw1-f201.google.com with SMTP id 00721157ae682-62a3dec382eso50437087b3.1
        for <kvm@vger.kernel.org>; Mon, 03 Jun 2024 11:13:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1717438421; x=1718043221; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=PiO6gRYOm2EaDI3qDA2MhDGUS16VaQoK2zDm3Ffl+L8=;
        b=WLjG6Rh09QrDm6Rrak1L/OjcPI1ZnlYs+1jaKaeX+jkKL415NOPrHi2ykQhXAk5Atu
         vvazkme2jG7Hvtq0IPFRUilNC8KNOLWK+AGJdMItaFykAEO6FLShOSe7m+kot3WWFHCR
         7BWVV+bBk5rVCf3hlj28IF7A3/8/y2V6DKE8AF23EDZsSkJpr7VwK2OEg6lcZlgYlqiu
         Ai7HeJcek0v4Qwlc/4y0ij1BWfAII6tDlAGicjPIwPJrY2OqDErWmkRQ/CoTZwo8tc8T
         lsVsOBsdJmKQG+dIRWdaYAjXfNDZdD1ohQjzCBnOw1dE+ud535ys1X5v9v8TFXt9EmFV
         i2KA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1717438421; x=1718043221;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=PiO6gRYOm2EaDI3qDA2MhDGUS16VaQoK2zDm3Ffl+L8=;
        b=nUSq11VGIH8TYOIAZEpZJKnXWvEExfpiGD2MNP3StlNtVlwhLUOliIMWGZbkqBn/Re
         uE/PdevJvDYLkxvciLrT/UvJy3HLVZb4BGUnGKiMNjfymAcDK9jNlmD8DP+BM4e+IkCl
         qmoPffUtz+q03I3q5NLfPWatx1+ZAA0wP59aEGsezrsgT9yvwcaTLKWzODrYLB8LbVv+
         Gag65TpFAoLRMEpUO3E80V6BIr/O8AbGIwgG+dJVonby7ozUEWjGZ8+FrFtVKVHqNVw/
         2OWuu7ULleV0+xKPZRiDaAx7OHE+8HloeqxNtav4g0E4x14aLQH9JC6sxzWGujta2AW8
         wOGA==
X-Forwarded-Encrypted: i=1; AJvYcCXVZduFvGfW3h3y4if/IVPoAyRsttjzhyv55XaPaaZaZxwVHwf8BAJj5TMD3aRDgOdeDOZHxpccuLxZHqy1MIWlsUJr
X-Gm-Message-State: AOJu0YwUHFig0yzSQQyI5qdlOTozeyY17fIZ6EQLK1dxGqwnejC3nk2H
	uMGPZp9KLVHloJ+nk80fdiT3PV/dWVa9eSS4wOzfsRMd26x/Dfqj+r0UXH2aWUT+bdb43RqfgAl
	RMw==
X-Google-Smtp-Source: AGHT+IF97lsFw4NY1+PbzW96rn0MqO65KzSaeCBcaTbDmVoqTz3Qzfx7hEV6Dc0xdIe25eZKF8VTS+4ki1U=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:690c:250d:b0:623:be6:d5e4 with SMTP id
 00721157ae682-62cabdcb0cbmr579677b3.4.1717438420770; Mon, 03 Jun 2024
 11:13:40 -0700 (PDT)
Date: Mon, 3 Jun 2024 11:13:39 -0700
In-Reply-To: <20240509181133.837001-1-dmatlack@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240509181133.837001-1-dmatlack@google.com>
Message-ID: <Zl4H0xVkkq5p507k@google.com>
Subject: Re: [PATCH v3] KVM: x86/mmu: Always drop mmu_lock to allocate TDP MMU
 SPs for eager splitting
From: Sean Christopherson <seanjc@google.com>
To: David Matlack <dmatlack@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org, 
	Bibo Mao <maobibo@loongson.cn>
Content-Type: text/plain; charset="us-ascii"

On Thu, May 09, 2024, David Matlack wrote:
> Always drop mmu_lock to allocate shadow pages in the TDP MMU when doing
> eager page splitting. Dropping mmu_lock during eager page splitting is
> cheap since KVM does not have to flush remote TLBs, and avoids stalling
> vCPU threads that are taking page faults in parallel.
> 
> This change reduces 20%+ dips in MySQL throughput during live migration
> in a 160 vCPU VM while userspace is issuing CLEAR_DIRTY_LOG ioctls
> (tested with 1GiB and 8GiB CLEARs). Userspace could issue finer-grained
> CLEARs, which would also reduce contention on mmu_lock, but doing so
> will increase the rate of remote TLB flushing (KVM must flush TLBs
> before returning from CLEAR_DITY_LOG).
> 
> When there isn't contention on mmu_lock[1], this change does not regress
> the time it takes to perform eager page splitting.
> 
> [1] Tested with dirty_log_perf_test, which does not run vCPUs during
> eager page splitting, and with a 16 vCPU VM Live Migration with
> manual-protect disabled (where mmu_lock is held in read-mode).
> 
> Cc: Bibo Mao <maobibo@loongson.cn>
> Cc: Sean Christopherson <seanjc@google.com>
> Signed-off-by: David Matlack <dmatlack@google.com>
> ---
> v3:
>  - Only drop mmu_lock during TDP MMU eager page splitting. This fixes
>    the perfomance regression without regressing CLEAR_DIRTY_LOG
>    performance on other architectures from frequent lock dropping.
> 
> v2: https://lore.kernel.org/kvm/20240402213656.3068504-1-dmatlack@google.com/
>  - Rebase onto kvm/queue [Marc]
> 
> v1: https://lore.kernel.org/kvm/20231205181645.482037-1-dmatlack@google.com/
> 
>  arch/x86/kvm/mmu/tdp_mmu.c | 22 ++++------------------
>  1 file changed, 4 insertions(+), 18 deletions(-)
> 
> diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
> index aaa2369a9479..2089d696e3c6 100644
> --- a/arch/x86/kvm/mmu/tdp_mmu.c
> +++ b/arch/x86/kvm/mmu/tdp_mmu.c
> @@ -1385,11 +1385,11 @@ bool kvm_tdp_mmu_wrprot_slot(struct kvm *kvm,
>  	return spte_set;
>  }
>  
> -static struct kvm_mmu_page *__tdp_mmu_alloc_sp_for_split(gfp_t gfp)
> +static struct kvm_mmu_page *__tdp_mmu_alloc_sp_for_split(void)
>  {
> +	gfp_t gfp = GFP_KERNEL_ACCOUNT | __GFP_ZERO;
>  	struct kvm_mmu_page *sp;
>  
> -	gfp |= __GFP_ZERO;
>  
>  	sp = kmem_cache_alloc(mmu_page_header_cache, gfp);

This can more simply and cleary be:

	sp = kmem_cache_zalloc(mmu_page_header_cache, GFP_KERNEL_ACCOUNT);

>  	if (!sp)
> @@ -1412,19 +1412,6 @@ static struct kvm_mmu_page *tdp_mmu_alloc_sp_for_split(struct kvm *kvm,
>  
>  	kvm_lockdep_assert_mmu_lock_held(kvm, shared);
>  
> -	/*
> -	 * Since we are allocating while under the MMU lock we have to be
> -	 * careful about GFP flags. Use GFP_NOWAIT to avoid blocking on direct
> -	 * reclaim and to avoid making any filesystem callbacks (which can end
> -	 * up invoking KVM MMU notifiers, resulting in a deadlock).
> -	 *
> -	 * If this allocation fails we drop the lock and retry with reclaim
> -	 * allowed.
> -	 */
> -	sp = __tdp_mmu_alloc_sp_for_split(GFP_NOWAIT | __GFP_ACCOUNT);
> -	if (sp)
> -		return sp;
> -
>  	rcu_read_unlock();
>  
>  	if (shared)
> @@ -1433,7 +1420,7 @@ static struct kvm_mmu_page *tdp_mmu_alloc_sp_for_split(struct kvm *kvm,
>  		write_unlock(&kvm->mmu_lock);
>  
>  	iter->yielded = true;

Now that yielding is unconditional, this really should be in the loop itself.
The bare continue looks weird, and it's unnecessarily hard to see that "yielded"
is being set.

And there's definitely no reason to have two helpers.

Not sure how many patches it'll take, but I think we should end up with:

static struct kvm_mmu_page *tdp_mmu_alloc_sp_for_split(void)
{
	struct kvm_mmu_page *sp;

	sp = kmem_cache_zalloc(mmu_page_header_cache, GFP_KERNEL_ACCOUNT);
	if (!sp)
		return NULL;

	sp->spt = (void *)__get_free_page(gfp);
	if (!sp->spt) {
		kmem_cache_free(mmu_page_header_cache, sp);
		return NULL;
	}

	return sp;
}

static int tdp_mmu_split_huge_pages_root(struct kvm *kvm,
					 struct kvm_mmu_page *root,
					 gfn_t start, gfn_t end,
					 int target_level, bool shared)
{
	struct kvm_mmu_page *sp = NULL;
	struct tdp_iter iter;

	rcu_read_lock();

	/*
	 * Traverse the page table splitting all huge pages above the target
	 * level into one lower level. For example, if we encounter a 1GB page
	 * we split it into 512 2MB pages.
	 *
	 * Since the TDP iterator uses a pre-order traversal, we are guaranteed
	 * to visit an SPTE before ever visiting its children, which means we
	 * will correctly recursively split huge pages that are more than one
	 * level above the target level (e.g. splitting a 1GB to 512 2MB pages,
	 * and then splitting each of those to 512 4KB pages).
	 */
	for_each_tdp_pte_min_level(iter, root, target_level + 1, start, end) {
retry:
		if (tdp_mmu_iter_cond_resched(kvm, &iter, false, shared))
			continue;

		if (!is_shadow_present_pte(iter.old_spte) || !is_large_pte(iter.old_spte))
			continue;

		if (!sp) {
			rcu_read_unlock();

			if (shared)
				read_unlock(&kvm->mmu_lock);
			else
				write_unlock(&kvm->mmu_lock);

			sp = tdp_mmu_alloc_sp_for_split(kvm, &iter, shared);

			if (shared)
				read_lock(&kvm->mmu_lock);
			else
				write_lock(&kvm->mmu_lock);

			if (!sp) {
				trace_kvm_mmu_split_huge_page(iter.gfn,
							      iter.old_spte,
							      iter.level, -ENOMEM);
				return -ENOMEM;
			}

			rcu_read_lock();

			iter->yielded = true;
			continue;
		}

		tdp_mmu_init_child_sp(sp, &iter);

		if (tdp_mmu_split_huge_page(kvm, &iter, sp, shared))
			goto retry;

		sp = NULL;
	}

	rcu_read_unlock();

	/*
	 * It's possible to exit the loop having never used the last sp if, for
	 * example, a vCPU doing HugePage NX splitting wins the race and
	 * installs its own sp in place of the last sp we tried to split.
	 */
	if (sp)
		tdp_mmu_free_sp(sp);

	return 0;
}

