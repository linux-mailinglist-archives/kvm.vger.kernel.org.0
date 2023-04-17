Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C76526E4065
	for <lists+kvm@lfdr.de>; Mon, 17 Apr 2023 09:12:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229500AbjDQHMR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 17 Apr 2023 03:12:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56668 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229461AbjDQHMP (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 17 Apr 2023 03:12:15 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 226723C39
        for <kvm@vger.kernel.org>; Mon, 17 Apr 2023 00:11:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1681715488;
        h=from:from:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=k1xF+nFS0MK/zVfUrj7g2p01lUZASPTG7lUOEBEW+M4=;
        b=Wmxmxgvp6G3p/OemDFGkKBOqJYFNxyrYuuAkKS4pD5K+PEyO/FUMmN+fI1pcisq8eZ5RdJ
        w8R5CkgsBfBHQapxMQcOHmTo9Xfy5ecg41LKpOPFSXeAE42MYON1Uqsg3bThcJzNzjtFkv
        Rotxlkn7y3X3fqSyCydMuZb78MSSx4Q=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-347-TLXtJD1NP46fpw7MSmQh7Q-1; Mon, 17 Apr 2023 03:11:26 -0400
X-MC-Unique: TLXtJD1NP46fpw7MSmQh7Q-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com [10.11.54.6])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id C1D9285A5A3;
        Mon, 17 Apr 2023 07:11:25 +0000 (UTC)
Received: from [10.72.13.187] (ovpn-13-187.pek2.redhat.com [10.72.13.187])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id ABB352166B26;
        Mon, 17 Apr 2023 07:11:14 +0000 (UTC)
Reply-To: Gavin Shan <gshan@redhat.com>
Subject: Re: [PATCH v7 09/12] KVM: arm64: Split huge pages when dirty logging
 is enabled
To:     Ricardo Koller <ricarkol@google.com>, pbonzini@redhat.com,
        maz@kernel.org, oupton@google.com, yuzenghui@huawei.com,
        dmatlack@google.com
Cc:     kvm@vger.kernel.org, kvmarm@lists.linux.dev, qperret@google.com,
        catalin.marinas@arm.com, andrew.jones@linux.dev, seanjc@google.com,
        alexandru.elisei@arm.com, suzuki.poulose@arm.com,
        eric.auger@redhat.com, reijiw@google.com, rananta@google.com,
        bgardon@google.com, ricarkol@gmail.com,
        Shaoqin Huang <shahuang@redhat.com>
References: <20230409063000.3559991-1-ricarkol@google.com>
 <20230409063000.3559991-11-ricarkol@google.com>
From:   Gavin Shan <gshan@redhat.com>
Message-ID: <e9e6a7dd-d861-0e32-28cc-9c7614204a12@redhat.com>
Date:   Mon, 17 Apr 2023 15:11:09 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.0
MIME-Version: 1.0
In-Reply-To: <20230409063000.3559991-11-ricarkol@google.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.6
X-Spam-Status: No, score=-3.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 4/9/23 2:29 PM, Ricardo Koller wrote:
> Split huge pages eagerly when enabling dirty logging. The goal is to
> avoid doing it while faulting on write-protected pages, which
> negatively impacts guest performance.
> 
> A memslot marked for dirty logging is split in 1GB pieces at a time.
> This is in order to release the mmu_lock and give other kernel threads
> the opportunity to run, and also in order to allocate enough pages to
> split a 1GB range worth of huge pages (or a single 1GB huge page).
> Note that these page allocations can fail, so eager page splitting is
> best-effort.  This is not a correctness issue though, as huge pages
> can still be split on write-faults.
> 
> The benefits of eager page splitting are the same as in x86, added
> with commit a3fe5dbda0a4 ("KVM: x86/mmu: Split huge pages mapped by
> the TDP MMU when dirty logging is enabled"). For example, when running
> dirty_log_perf_test with 64 virtual CPUs (Ampere Altra), 1GB per vCPU,
> 50% reads, and 2MB HugeTLB memory, the time it takes vCPUs to access
> all of their memory after dirty logging is enabled decreased by 44%
> from 2.58s to 1.42s.
> 
> Signed-off-by: Ricardo Koller <ricarkol@google.com>
> Reviewed-by: Shaoqin Huang <shahuang@redhat.com>
> ---
>   arch/arm64/kvm/mmu.c | 123 ++++++++++++++++++++++++++++++++++++++++++-
>   1 file changed, 121 insertions(+), 2 deletions(-)
> 

In the changelog, it may be worthy to be mentioned:

The eager page splitting only takes effect when the huge page mapping has
been existing in the stage-2 page table. Otherwise, the huge page will be
mapped to multiple base pages on handling page fault.

The code changes look good to me:

Reviewed-by: Gavin Shan <gshan@redhat.com>

> diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
> index 898985b09321a..aaefabd8de89d 100644
> --- a/arch/arm64/kvm/mmu.c
> +++ b/arch/arm64/kvm/mmu.c
> @@ -31,14 +31,21 @@ static phys_addr_t __ro_after_init hyp_idmap_vector;
>   
>   static unsigned long __ro_after_init io_map_base;
>   
> -static phys_addr_t stage2_range_addr_end(phys_addr_t addr, phys_addr_t end)
> +static phys_addr_t __stage2_range_addr_end(phys_addr_t addr, phys_addr_t end,
> +					   phys_addr_t size)
>   {
> -	phys_addr_t size = kvm_granule_size(KVM_PGTABLE_MIN_BLOCK_LEVEL);
>   	phys_addr_t boundary = ALIGN_DOWN(addr + size, size);
>   
>   	return (boundary - 1 < end - 1) ? boundary : end;
>   }
>   
> +static phys_addr_t stage2_range_addr_end(phys_addr_t addr, phys_addr_t end)
> +{
> +	phys_addr_t size = kvm_granule_size(KVM_PGTABLE_MIN_BLOCK_LEVEL);
> +
> +	return __stage2_range_addr_end(addr, end, size);
> +}
> +
>   /*
>    * Release kvm_mmu_lock periodically if the memory region is large. Otherwise,
>    * we may see kernel panics with CONFIG_DETECT_HUNG_TASK,
> @@ -75,6 +82,79 @@ static int stage2_apply_range(struct kvm_s2_mmu *mmu, phys_addr_t addr,
>   #define stage2_apply_range_resched(mmu, addr, end, fn)			\
>   	stage2_apply_range(mmu, addr, end, fn, true)
>   
> +/*
> + * Get the maximum number of page-tables pages needed to split a range
> + * of blocks into PAGE_SIZE PTEs. It assumes the range is already
> + * mapped at level 2, or at level 1 if allowed.
> + */
> +static int kvm_mmu_split_nr_page_tables(u64 range)
> +{
> +	int n = 0;
> +
> +	if (KVM_PGTABLE_MIN_BLOCK_LEVEL < 2)
> +		n += DIV_ROUND_UP_ULL(range, PUD_SIZE);
> +	n += DIV_ROUND_UP_ULL(range, PMD_SIZE);
> +	return n;
> +}
> +
> +static bool need_split_memcache_topup_or_resched(struct kvm *kvm)
> +{
> +	struct kvm_mmu_memory_cache *cache;
> +	u64 chunk_size, min;
> +
> +	if (need_resched() || rwlock_needbreak(&kvm->mmu_lock))
> +		return true;
> +
> +	chunk_size = kvm->arch.mmu.split_page_chunk_size;
> +	min = kvm_mmu_split_nr_page_tables(chunk_size);
> +	cache = &kvm->arch.mmu.split_page_cache;
> +	return kvm_mmu_memory_cache_nr_free_objects(cache) < min;
> +}
> +
> +static int kvm_mmu_split_huge_pages(struct kvm *kvm, phys_addr_t addr,
> +				    phys_addr_t end)
> +{
> +	struct kvm_mmu_memory_cache *cache;
> +	struct kvm_pgtable *pgt;
> +	int ret, cache_capacity;
> +	u64 next, chunk_size;
> +
> +	lockdep_assert_held_write(&kvm->mmu_lock);
> +
> +	chunk_size = kvm->arch.mmu.split_page_chunk_size;
> +	cache_capacity = kvm_mmu_split_nr_page_tables(chunk_size);
> +
> +	if (chunk_size == 0)
> +		return 0;
> +
> +	cache = &kvm->arch.mmu.split_page_cache;
> +
> +	do {
> +		if (need_split_memcache_topup_or_resched(kvm)) {
> +			write_unlock(&kvm->mmu_lock);
> +			cond_resched();
> +			/* Eager page splitting is best-effort. */
> +			ret = __kvm_mmu_topup_memory_cache(cache,
> +							   cache_capacity,
> +							   cache_capacity);
> +			write_lock(&kvm->mmu_lock);
> +			if (ret)
> +				break;
> +		}
> +
> +		pgt = kvm->arch.mmu.pgt;
> +		if (!pgt)
> +			return -EINVAL;
> +
> +		next = __stage2_range_addr_end(addr, end, chunk_size);
> +		ret = kvm_pgtable_stage2_split(pgt, addr, next - addr, cache);
> +		if (ret)
> +			break;
> +	} while (addr = next, addr != end);
> +
> +	return ret;
> +}
> +
>   static bool memslot_is_logging(struct kvm_memory_slot *memslot)
>   {
>   	return memslot->dirty_bitmap && !(memslot->flags & KVM_MEM_READONLY);
> @@ -773,6 +853,7 @@ int kvm_init_stage2_mmu(struct kvm *kvm, struct kvm_s2_mmu *mmu, unsigned long t
>   void kvm_uninit_stage2_mmu(struct kvm *kvm)
>   {
>   	kvm_free_stage2_pgd(&kvm->arch.mmu);
> +	kvm_mmu_free_memory_cache(&kvm->arch.mmu.split_page_cache);
>   }
>   
>   static void stage2_unmap_memslot(struct kvm *kvm,
> @@ -999,6 +1080,34 @@ static void kvm_mmu_write_protect_pt_masked(struct kvm *kvm,
>   	stage2_wp_range(&kvm->arch.mmu, start, end);
>   }
>   
> +/**
> + * kvm_mmu_split_memory_region() - split the stage 2 blocks into PAGE_SIZE
> + *				   pages for memory slot
> + * @kvm:	The KVM pointer
> + * @slot:	The memory slot to split
> + *
> + * Acquires kvm->mmu_lock. Called with kvm->slots_lock mutex acquired,
> + * serializing operations for VM memory regions.
> + */
> +static void kvm_mmu_split_memory_region(struct kvm *kvm, int slot)
> +{
> +	struct kvm_memslots *slots;
> +	struct kvm_memory_slot *memslot;
> +	phys_addr_t start, end;
> +
> +	lockdep_assert_held(&kvm->slots_lock);
> +
> +	slots = kvm_memslots(kvm);
> +	memslot = id_to_memslot(slots, slot);
> +
> +	start = memslot->base_gfn << PAGE_SHIFT;
> +	end = (memslot->base_gfn + memslot->npages) << PAGE_SHIFT;
> +
> +	write_lock(&kvm->mmu_lock);
> +	kvm_mmu_split_huge_pages(kvm, start, end);
> +	write_unlock(&kvm->mmu_lock);
> +}
> +
>   /*
>    * kvm_arch_mmu_enable_log_dirty_pt_masked - enable dirty logging for selected
>    * dirty pages.
> @@ -1790,6 +1899,16 @@ void kvm_arch_commit_memory_region(struct kvm *kvm,
>   			return;
>   
>   		kvm_mmu_wp_memory_region(kvm, new->id);
> +		kvm_mmu_split_memory_region(kvm, new->id);
> +	} else {
> +		/*
> +		 * Free any leftovers from the eager page splitting cache. Do
> +		 * this when deleting, moving, disabling dirty logging, or
> +		 * creating the memslot (a nop). Doing it for deletes makes
> +		 * sure we don't leak memory, and there's no need to keep the
> +		 * cache around for any of the other cases.
> +		 */
> +		kvm_mmu_free_memory_cache(&kvm->arch.mmu.split_page_cache);
>   	}
>   }
>   
> 

Thanks,
Gavin

