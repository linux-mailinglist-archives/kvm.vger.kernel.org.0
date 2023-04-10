Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 823496DCAC6
	for <lists+kvm@lfdr.de>; Mon, 10 Apr 2023 20:32:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229761AbjDJScR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 10 Apr 2023 14:32:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41688 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229520AbjDJScQ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 10 Apr 2023 14:32:16 -0400
Received: from mail-pl1-x632.google.com (mail-pl1-x632.google.com [IPv6:2607:f8b0:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 424CD210D
        for <kvm@vger.kernel.org>; Mon, 10 Apr 2023 11:32:08 -0700 (PDT)
Received: by mail-pl1-x632.google.com with SMTP id d9443c01a7336-1a2104d8b00so342795ad.1
        for <kvm@vger.kernel.org>; Mon, 10 Apr 2023 11:32:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1681151528; x=1683743528;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=f7UdOzxKcMFxAXgwDr3c3mqIgBdlhSWNbMqCZ7jei+0=;
        b=pDQtT2UZ09FdShfA2bT4n/HOZl+apAj7xKkzscxqGApZN3E2Zl4WW95f9bCLYwftEy
         mzApo2cqPp1Wabmb+ThVPzBjsR6ihr7LypQA48YZmv2aQZfKsqu0/Wwlx1EonHnR+qYu
         2Pa55ESw5r76fUvPSjdlrOTXiBiAGw9qyBh1/SYm75tAceXe6gFPKE+W+Hq1ou98AwhE
         AbrHSKaRCGY92NHUw4P1hv1gj0d+yc7PsLHUu2ydSEWfKlkSkHe9Z8MM2bHuBOGTUbk4
         TaQ/GIyNkzYMNtR3hg9KFRcn7/AHcYGrgZh5R+y78jG+L7Sx5eKJUgJtc/tj3x/kradh
         17Pw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1681151528; x=1683743528;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=f7UdOzxKcMFxAXgwDr3c3mqIgBdlhSWNbMqCZ7jei+0=;
        b=xobQwV5gBDF+/gyvDoQaIYFhfvV8CN1jCpmg5ogvd00XrgOqTwfp9siUavlOPcnZ5l
         6nJNPotuOLEelzTxpdL3zLz/yqT5CCk9Ht4stM6MtV9Q6dc4FqPsTcM4dVTm++tR6sDj
         4vrhPAHFbGLT0tt4H4Ct1pFuEPfFnb0FkFiPnesewtrD+8mj4jmGP3ArlmNMdC4YMuI3
         RbwK2sTTvIlPhSHsVkp3ldfUUsxCbinlc7qfHw5jzpSJbpV+FlwSa1b2rg9QQMpwG510
         7J0dEznr7zjSFTbe/CgXQAYGKFZtWZ/mc1a4p6YIhXe41y0/6jBrClMF7vknBQrODmq5
         TV1A==
X-Gm-Message-State: AAQBX9ccUL6xqJCYxLl0IKMb3TGTG2VXbnyKQ3ye8au0GHQl0m2t6BRd
        UoWFh8BVUYc5N8oHn/CYZWrM7A==
X-Google-Smtp-Source: AKy350ZIVsWkTPhsMCwlZorTuVSEnV+XepciqH7EYKmTcTRAIqHfTjzFghnG0vhtPjL6jpN8g2KtTw==
X-Received: by 2002:a17:902:d88f:b0:1a1:af2b:ba47 with SMTP id b15-20020a170902d88f00b001a1af2bba47mr38892plz.2.1681151527611;
        Mon, 10 Apr 2023 11:32:07 -0700 (PDT)
Received: from google.com (220.181.82.34.bc.googleusercontent.com. [34.82.181.220])
        by smtp.gmail.com with ESMTPSA id n9-20020a62e509000000b00580e3917af7sm8158159pff.117.2023.04.10.11.32.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 10 Apr 2023 11:32:07 -0700 (PDT)
Date:   Mon, 10 Apr 2023 11:32:03 -0700
From:   Ricardo Koller <ricarkol@google.com>
To:     Marc Zyngier <maz@kernel.org>
Cc:     pbonzini@redhat.com, oupton@google.com, yuzenghui@huawei.com,
        dmatlack@google.com, kvm@vger.kernel.org, kvmarm@lists.linux.dev,
        qperret@google.com, catalin.marinas@arm.com,
        andrew.jones@linux.dev, seanjc@google.com,
        alexandru.elisei@arm.com, suzuki.poulose@arm.com,
        eric.auger@redhat.com, gshan@redhat.com, reijiw@google.com,
        rananta@google.com, bgardon@google.com, ricarkol@gmail.com,
        Shaoqin Huang <shahuang@redhat.com>
Subject: Re: [PATCH v6 09/12] KVM: arm64: Split huge pages when dirty logging
 is enabled
Message-ID: <ZDRWI74ERb1Cpgbe@google.com>
References: <20230307034555.39733-1-ricarkol@google.com>
 <20230307034555.39733-10-ricarkol@google.com>
 <875yb65dvq.wl-maz@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <875yb65dvq.wl-maz@kernel.org>
X-Spam-Status: No, score=-15.7 required=5.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,ENV_AND_HDR_SPF_MATCH,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL,
        USER_IN_DEF_SPF_WL autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sun, Mar 12, 2023 at 12:54:17PM +0000, Marc Zyngier wrote:
> On Tue, 07 Mar 2023 03:45:52 +0000,
> Ricardo Koller <ricarkol@google.com> wrote:
> > 
> > Split huge pages eagerly when enabling dirty logging. The goal is to
> > avoid doing it while faulting on write-protected pages, which
> > negatively impacts guest performance.
> > 
> > A memslot marked for dirty logging is split in 1GB pieces at a time.
> > This is in order to release the mmu_lock and give other kernel threads
> > the opportunity to run, and also in order to allocate enough pages to
> > split a 1GB range worth of huge pages (or a single 1GB huge page).
> > Note that these page allocations can fail, so eager page splitting is
> > best-effort.  This is not a correctness issue though, as huge pages
> > can still be split on write-faults.
> > 
> > The benefits of eager page splitting are the same as in x86, added
> > with commit a3fe5dbda0a4 ("KVM: x86/mmu: Split huge pages mapped by
> > the TDP MMU when dirty logging is enabled"). For example, when running
> > dirty_log_perf_test with 64 virtual CPUs (Ampere Altra), 1GB per vCPU,
> > 50% reads, and 2MB HugeTLB memory, the time it takes vCPUs to access
> > all of their memory after dirty logging is enabled decreased by 44%
> > from 2.58s to 1.42s.
> > 
> > Signed-off-by: Ricardo Koller <ricarkol@google.com>
> > Reviewed-by: Shaoqin Huang <shahuang@redhat.com>
> > ---
> >  arch/arm64/kvm/mmu.c | 118 ++++++++++++++++++++++++++++++++++++++++++-
> >  1 file changed, 116 insertions(+), 2 deletions(-)
> > 
> > diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
> > index 898985b09321..b1b8da5f8b6c 100644
> > --- a/arch/arm64/kvm/mmu.c
> > +++ b/arch/arm64/kvm/mmu.c
> > @@ -31,14 +31,21 @@ static phys_addr_t __ro_after_init hyp_idmap_vector;
> >  
> >  static unsigned long __ro_after_init io_map_base;
> >  
> > -static phys_addr_t stage2_range_addr_end(phys_addr_t addr, phys_addr_t end)
> > +static phys_addr_t __stage2_range_addr_end(phys_addr_t addr, phys_addr_t end,
> > +					   phys_addr_t size)
> >  {
> > -	phys_addr_t size = kvm_granule_size(KVM_PGTABLE_MIN_BLOCK_LEVEL);
> >  	phys_addr_t boundary = ALIGN_DOWN(addr + size, size);
> >  
> >  	return (boundary - 1 < end - 1) ? boundary : end;
> >  }
> >  
> > +static phys_addr_t stage2_range_addr_end(phys_addr_t addr, phys_addr_t end)
> > +{
> > +	phys_addr_t size = kvm_granule_size(KVM_PGTABLE_MIN_BLOCK_LEVEL);
> > +
> > +	return __stage2_range_addr_end(addr, end, size);
> > +}
> > +
> >  /*
> >   * Release kvm_mmu_lock periodically if the memory region is large. Otherwise,
> >   * we may see kernel panics with CONFIG_DETECT_HUNG_TASK,
> > @@ -75,6 +82,77 @@ static int stage2_apply_range(struct kvm_s2_mmu *mmu, phys_addr_t addr,
> >  #define stage2_apply_range_resched(mmu, addr, end, fn)			\
> >  	stage2_apply_range(mmu, addr, end, fn, true)
> >  
> > +static bool need_topup_split_page_cache_or_resched(struct kvm *kvm, uint64_t min)
> 
> Please don't use the words "page cache", it triggers a painful
> Pavlovian reflex. Something like "need_split_memcache_topup_or_reched"
> makes me feel less anxious.
>

fixed

> > +{
> > +	struct kvm_mmu_memory_cache *cache;
> > +
> > +	if (need_resched() || rwlock_needbreak(&kvm->mmu_lock))
> > +		return true;
> > +
> > +	cache = &kvm->arch.mmu.split_page_cache;
> > +	return kvm_mmu_memory_cache_nr_free_objects(cache) < min;
> > +}
> > +
> > +/*
> > + * Get the maximum number of page-tables needed to split a range of
> 
> nit: page-table pages.
>

fixed

> > + * blocks into PAGE_SIZE PTEs. It assumes the range is already mapped
> > + * at the PMD level, or at the PUD level if allowed.
> > + */
> > +static int kvm_mmu_split_nr_page_tables(u64 range)
> > +{
> > +	int n = 0;
> > +
> > +	if (KVM_PGTABLE_MIN_BLOCK_LEVEL < 2)
> > +		n += DIV_ROUND_UP_ULL(range, PUD_SIZE);
> > +	n += DIV_ROUND_UP_ULL(range, PMD_SIZE);
> > +	return n;
> > +}
> > +
> > +static int kvm_mmu_split_huge_pages(struct kvm *kvm, phys_addr_t addr,
> > +				    phys_addr_t end)
> > +{
> > +	struct kvm_mmu_memory_cache *cache;
> > +	struct kvm_pgtable *pgt;
> > +	int ret;
> > +	u64 next;
> > +	u64 chunk_size = kvm->arch.mmu.split_page_chunk_size;
> > +	int cache_capacity = kvm_mmu_split_nr_page_tables(chunk_size);
> > +
> > +	if (chunk_size == 0)
> > +		return 0;
> > +
> > +	lockdep_assert_held_write(&kvm->mmu_lock);
> 
> Please check for the lock being held early, even in the 0-sized chunk
> condition.
> 

fixed

> > +
> > +	cache = &kvm->arch.mmu.split_page_cache;
> > +
> > +	do {
> > +		if (need_topup_split_page_cache_or_resched(kvm,
> > +							   cache_capacity)) {
> 
> Since cache_capacity is stored in the kvm struct, why not just passing
> it to the helper function and let it deal with it?
>

removed the cache_capacity arg.

> > +			write_unlock(&kvm->mmu_lock);
> > +			cond_resched();
> > +			/* Eager page splitting is best-effort. */
> > +			ret = __kvm_mmu_topup_memory_cache(cache,
> > +							   cache_capacity,
> > +							   cache_capacity);
> > +			write_lock(&kvm->mmu_lock);
> > +			if (ret)
> > +				break;
> > +		}
> > +
> > +		pgt = kvm->arch.mmu.pgt;
> > +		if (!pgt)
> > +			return -EINVAL;
> > +
> > +		next = __stage2_range_addr_end(addr, end, chunk_size);
> > +		ret = kvm_pgtable_stage2_split(pgt, addr, next - addr,
> > +					       cache, cache_capacity);
> > +		if (ret)
> > +			break;
> > +	} while (addr = next, addr != end);
> > +
> > +	return ret;
> > +}
> > +
> >  static bool memslot_is_logging(struct kvm_memory_slot *memslot)
> >  {
> >  	return memslot->dirty_bitmap && !(memslot->flags & KVM_MEM_READONLY);
> > @@ -773,6 +851,7 @@ int kvm_init_stage2_mmu(struct kvm *kvm, struct kvm_s2_mmu *mmu, unsigned long t
> >  void kvm_uninit_stage2_mmu(struct kvm *kvm)
> >  {
> >  	kvm_free_stage2_pgd(&kvm->arch.mmu);
> > +	kvm_mmu_free_memory_cache(&kvm->arch.mmu.split_page_cache);
> >  }
> >  
> >  static void stage2_unmap_memslot(struct kvm *kvm,
> > @@ -999,6 +1078,31 @@ static void kvm_mmu_write_protect_pt_masked(struct kvm *kvm,
> >  	stage2_wp_range(&kvm->arch.mmu, start, end);
> >  }
> >  
> > +/**
> > + * kvm_mmu_split_memory_region() - split the stage 2 blocks into PAGE_SIZE
> > + *				   pages for memory slot
> > + * @kvm:	The KVM pointer
> > + * @slot:	The memory slot to split
> > + *
> > + * Acquires kvm->mmu_lock. Called with kvm->slots_lock mutex acquired,
> > + * serializing operations for VM memory regions.
> > + */
> > +static void kvm_mmu_split_memory_region(struct kvm *kvm, int slot)
> > +{
> > +	struct kvm_memslots *slots = kvm_memslots(kvm);
> > +	struct kvm_memory_slot *memslot = id_to_memslot(slots, slot);
> > +	phys_addr_t start, end;
> > +
> > +	lockdep_assert_held(&kvm->slots_lock);
> 
> You have already accessed the memslots by the time you check for the
> lock. Not great.
> 

fixed

> > +
> > +	start = memslot->base_gfn << PAGE_SHIFT;
> > +	end = (memslot->base_gfn + memslot->npages) << PAGE_SHIFT;
> > +
> > +	write_lock(&kvm->mmu_lock);
> > +	kvm_mmu_split_huge_pages(kvm, start, end);
> > +	write_unlock(&kvm->mmu_lock);
> > +}
> > +
> >  /*
> >   * kvm_arch_mmu_enable_log_dirty_pt_masked - enable dirty logging for selected
> >   * dirty pages.
> > @@ -1790,6 +1894,16 @@ void kvm_arch_commit_memory_region(struct kvm *kvm,
> >  			return;
> >  
> >  		kvm_mmu_wp_memory_region(kvm, new->id);
> > +		kvm_mmu_split_memory_region(kvm, new->id);
> 
> Would there be an advantage in merging these two operations somehow?
>

I guess we could. The only issue is that it could be useful to
write-protect a memslot without splitting huge pages.

> > +	} else {
> > +		/*
> > +		 * Free any leftovers from the eager page splitting cache. Do
> > +		 * this when deleting, moving, disabling dirty logging, or
> > +		 * creating the memslot (a nop). Doing it for deletes makes
> > +		 * sure we don't leak memory, and there's no need to keep the
> > +		 * cache around for any of the other cases.
> > +		 */
> > +		kvm_mmu_free_memory_cache(&kvm->arch.mmu.split_page_cache);
> >  	}
> >  }
> >  
> 
> Thanks,
> 
> 	M.
> 
> -- 
> Without deviation from the norm, progress is not possible.
