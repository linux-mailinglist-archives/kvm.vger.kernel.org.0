Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9D97A70B667
	for <lists+kvm@lfdr.de>; Mon, 22 May 2023 09:24:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232343AbjEVHYO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 22 May 2023 03:24:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51046 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232525AbjEVHX6 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 22 May 2023 03:23:58 -0400
X-Greylist: delayed 458 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Mon, 22 May 2023 00:23:19 PDT
Received: from out-7.mta1.migadu.com (out-7.mta1.migadu.com [95.215.58.7])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 765E9E4B
        for <kvm@vger.kernel.org>; Mon, 22 May 2023 00:23:19 -0700 (PDT)
Message-ID: <620eef7f-ee01-673c-b097-243d6fe25b09@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1684739739;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=V+i7Y7TvU/1cB99/J0N35qsPA2c9+2WBSKn0CQ3JOro=;
        b=IH3GuWgDLXxllEjM0jBC3ZVrRYnz6r/7HNdiMe1tNMtSMaxE8fWmSEq0qoenUYbwHPgjbq
        v3ZWn+2izo4vWfULDRhj9PAYSOfIpJbAFECXK2U9W0noF9m1Fsb6PyGSWwOsdnlE9m6nun
        kM2dyfSwSfptKo3WVtSMS0AV9+9S9Hc=
Date:   Mon, 22 May 2023 15:15:32 +0800
MIME-Version: 1.0
Subject: Re: [PATCH] mmu_notifiers: Notify on pte permission upgrades
Content-Language: en-US
To:     Alistair Popple <apopple@nvidia.com>
Cc:     linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        robin.murphy@arm.com, will@kernel.org, nicolinc@nvidia.com,
        linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org,
        kvmarm@lists.cs.columbia.edu, jgg@nvidia.com,
        John Hubbard <jhubbard@nvidia.com>,
        Andrew Morton <akpm@linux-foundation.org>
References: <20230522063725.284686-1-apopple@nvidia.com>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From:   Qi Zheng <qi.zheng@linux.dev>
In-Reply-To: <20230522063725.284686-1-apopple@nvidia.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Migadu-Flow: FLOW_OUT
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Alistair,

On 2023/5/22 14:37, Alistair Popple wrote:
> Some architectures, specifically ARM and perhaps Sparc and IA64,
> require TLB invalidates when upgrading pte permission from read-only
> to read-write.
> 
> The current mmu_notifier implementation assumes that upgrades do not
> need notifications. Typically though mmu_notifiers are used to
> implement TLB invalidations for secondary MMUs that comply with the
> main CPU architecture.
> 
> Therefore if the main CPU architecture requires an invalidation for
> permission upgrade the secondary MMU will as well and an mmu_notifier
> should be sent for the upgrade.
> 
> Currently CPU invalidations for permission upgrade occur in
> ptep_set_access_flags(). Unfortunately MMU notifiers cannot be called
> directly from this architecture specific code as the notifier
> callbacks can sleep, and ptep_set_access_flags() is usually called
> whilst holding the PTL spinlock. Therefore add the notifier calls
> after the PTL is dropped and only if the PTE actually changed. This
> will allow secondary MMUs to obtain an updated PTE with appropriate
> permissions.
> 
> This problem was discovered during testing of an ARM SMMU
> implementation that does not support broadcast TLB maintenance
> (BTM). In this case the SMMU driver uses notifiers to issue TLB
> invalidates. For read-only to read-write pte upgrades the SMMU
> continually returned a read-only PTE to the device, even though the
> CPU had a read-write PTE installed.
> 
> Sending a mmu notifier event to the SMMU driver fixes the problem by
> flushing secondary TLB entries. A new notifier event type is added so
> drivers may filter out these invalidations if not required. Note a
> driver should never upgrade or install a PTE in response to this mmu
> notifier event as it is not synchronised against other PTE operations.
> 
> Signed-off-by: Alistair Popple <apopple@nvidia.com>
> ---
>   include/linux/mmu_notifier.h |  6 +++++
>   mm/hugetlb.c                 | 24 ++++++++++++++++++-
>   mm/memory.c                  | 45 ++++++++++++++++++++++++++++++++++--
>   3 files changed, 72 insertions(+), 3 deletions(-)
> 
> diff --git a/include/linux/mmu_notifier.h b/include/linux/mmu_notifier.h
> index d6c06e140277..f14d68f119d8 100644
> --- a/include/linux/mmu_notifier.h
> +++ b/include/linux/mmu_notifier.h
> @@ -31,6 +31,11 @@ struct mmu_interval_notifier;
>    * pages in the range so to mirror those changes the user must inspect the CPU
>    * page table (from the end callback).
>    *
> + * @MMU_NOTIFY_PROTECTION_UPGRAGE: update is due to a change from read-only to
> + * read-write for pages in the range. This must not be used to upgrade
> + * permissions on secondary PTEs, rather it should only be used to invalidate
> + * caches such as secondary TLBs that may cache old read-only entries.
> + *
>    * @MMU_NOTIFY_SOFT_DIRTY: soft dirty accounting (still same page and same
>    * access flags). User should soft dirty the page in the end callback to make
>    * sure that anyone relying on soft dirtiness catch pages that might be written
> @@ -53,6 +58,7 @@ enum mmu_notifier_event {
>   	MMU_NOTIFY_CLEAR,
>   	MMU_NOTIFY_PROTECTION_VMA,
>   	MMU_NOTIFY_PROTECTION_PAGE,
> +	MMU_NOTIFY_PROTECTION_UPGRADE,
>   	MMU_NOTIFY_SOFT_DIRTY,
>   	MMU_NOTIFY_RELEASE,
>   	MMU_NOTIFY_MIGRATE,
> diff --git a/mm/hugetlb.c b/mm/hugetlb.c
> index bdbfeb6fb393..e5d467c7bff7 100644
> --- a/mm/hugetlb.c
> +++ b/mm/hugetlb.c
> @@ -5987,6 +5987,7 @@ vm_fault_t hugetlb_fault(struct mm_struct *mm, struct vm_area_struct *vma,
>   	vm_fault_t ret;
>   	u32 hash;
>   	pgoff_t idx;
> +	bool changed = false;
>   	struct page *page = NULL;
>   	struct page *pagecache_page = NULL;
>   	struct hstate *h = hstate_vma(vma);
> @@ -6122,6 +6123,9 @@ vm_fault_t hugetlb_fault(struct mm_struct *mm, struct vm_area_struct *vma,
>   		if (!huge_pte_write(entry)) {
>   			ret = hugetlb_wp(mm, vma, address, ptep, flags,
>   					 pagecache_page, ptl);
> +			if (!ret)
> +				changed = true;
> +
>   			goto out_put_page;
>   		} else if (likely(flags & FAULT_FLAG_WRITE)) {
>   			entry = huge_pte_mkdirty(entry);
> @@ -6129,8 +6133,11 @@ vm_fault_t hugetlb_fault(struct mm_struct *mm, struct vm_area_struct *vma,
>   	}
>   	entry = pte_mkyoung(entry);
>   	if (huge_ptep_set_access_flags(vma, haddr, ptep, entry,
> -						flags & FAULT_FLAG_WRITE))
> +						flags & FAULT_FLAG_WRITE)) {
>   		update_mmu_cache(vma, haddr, ptep);
> +		changed = true;
> +	}
> +
>   out_put_page:
>   	if (page != pagecache_page)
>   		unlock_page(page);
> @@ -6138,6 +6145,21 @@ vm_fault_t hugetlb_fault(struct mm_struct *mm, struct vm_area_struct *vma,
>   out_ptl:
>   	spin_unlock(ptl);
>   
> +	if (changed) {
> +		struct mmu_notifier_range range;
> +		unsigned long hpage_mask = huge_page_mask(h);
> +		unsigned long hpage_size = huge_page_size(h);
> +
> +		update_mmu_cache(vma, haddr, ptep);
> +
> +		mmu_notifier_range_init(&range, MMU_NOTIFY_PROTECTION_UPGRADE,
> +					0, vma, mm, haddr & hpage_mask,
> +					(haddr & hpage_mask) + hpage_size);
> +		mmu_notifier_invalidate_range_start(&range);
> +		mmu_notifier_invalidate_range_end(&range);
> +	}
> +
> +
>   	if (pagecache_page) {
>   		unlock_page(pagecache_page);
>   		put_page(pagecache_page);
> diff --git a/mm/memory.c b/mm/memory.c
> index f526b9152bef..0ac78c6a232c 100644
> --- a/mm/memory.c
> +++ b/mm/memory.c
> @@ -2098,6 +2098,7 @@ static vm_fault_t insert_pfn(struct vm_area_struct *vma, unsigned long addr,
>   	struct mm_struct *mm = vma->vm_mm;
>   	pte_t *pte, entry;
>   	spinlock_t *ptl;
> +	bool changed = false;
>   
>   	pte = get_locked_pte(mm, addr, &ptl);
>   	if (!pte)
> @@ -2120,8 +2121,10 @@ static vm_fault_t insert_pfn(struct vm_area_struct *vma, unsigned long addr,
>   			}
>   			entry = pte_mkyoung(*pte);
>   			entry = maybe_mkwrite(pte_mkdirty(entry), vma);
> -			if (ptep_set_access_flags(vma, addr, pte, entry, 1))
> +			if (ptep_set_access_flags(vma, addr, pte, entry, 1)) {
>   				update_mmu_cache(vma, addr, pte);
> +				changed = true;
> +			}
>   		}
>   		goto out_unlock;
>   	}
> @@ -2142,6 +2145,17 @@ static vm_fault_t insert_pfn(struct vm_area_struct *vma, unsigned long addr,
>   
>   out_unlock:
>   	pte_unmap_unlock(pte, ptl);
> +
> +	if (changed) {
> +		struct mmu_notifier_range range;
> +
> +		mmu_notifier_range_init(&range, MMU_NOTIFY_PROTECTION_UPGRADE,
> +					0, vma, mm, addr & PAGE_MASK,
> +					(addr & PAGE_MASK) + PAGE_SIZE);
> +		mmu_notifier_invalidate_range_start(&range);
> +		mmu_notifier_invalidate_range_end(&range);
> +	}
> +
>   	return VM_FAULT_NOPAGE;
>   }
>   
> @@ -2820,6 +2834,7 @@ static inline int __wp_page_copy_user(struct page *dst, struct page *src,
>   	struct vm_area_struct *vma = vmf->vma;
>   	struct mm_struct *mm = vma->vm_mm;
>   	unsigned long addr = vmf->address;
> +	bool changed = false;
>   
>   	if (likely(src)) {
>   		if (copy_mc_user_highpage(dst, src, addr, vma)) {
> @@ -2858,8 +2873,10 @@ static inline int __wp_page_copy_user(struct page *dst, struct page *src,
>   		}
>   
>   		entry = pte_mkyoung(vmf->orig_pte);
> -		if (ptep_set_access_flags(vma, addr, vmf->pte, entry, 0))
> +		if (ptep_set_access_flags(vma, addr, vmf->pte, entry, 0)) {
>   			update_mmu_cache(vma, addr, vmf->pte);
> +			changed = true;
> +		}
>   	}
>   
>   	/*
> @@ -2897,6 +2914,16 @@ static inline int __wp_page_copy_user(struct page *dst, struct page *src,
>   		}
>   	}
>   
> +	if (changed) {
> +		struct mmu_notifier_range range;
> +
> +		mmu_notifier_range_init(&range, MMU_NOTIFY_PROTECTION_UPGRADE,
> +					0, vma, vma->vm_mm, addr & PAGE_MASK,
> +					(addr & PAGE_MASK) + PAGE_SIZE);
> +		mmu_notifier_invalidate_range_start(&range);
> +		mmu_notifier_invalidate_range_end(&range);
> +	}
> +
>   	ret = 0;
>   
>   pte_unlock:
> @@ -4877,6 +4904,7 @@ static vm_fault_t wp_huge_pud(struct vm_fault *vmf, pud_t orig_pud)
>   static vm_fault_t handle_pte_fault(struct vm_fault *vmf)
>   {
>   	pte_t entry;
> +	bool changed = false;
>   
>   	if (unlikely(pmd_none(*vmf->pmd))) {
>   		/*
> @@ -4957,6 +4985,7 @@ static vm_fault_t handle_pte_fault(struct vm_fault *vmf)
>   	if (ptep_set_access_flags(vmf->vma, vmf->address, vmf->pte, entry,
>   				vmf->flags & FAULT_FLAG_WRITE)) {
>   		update_mmu_cache(vmf->vma, vmf->address, vmf->pte);
> +		changed = true;
>   	} else {
>   		/* Skip spurious TLB flush for retried page fault */
>   		if (vmf->flags & FAULT_FLAG_TRIED)
> @@ -4972,6 +5001,18 @@ static vm_fault_t handle_pte_fault(struct vm_fault *vmf)
>   	}
>   unlock:
>   	pte_unmap_unlock(vmf->pte, vmf->ptl);
> +
> +	if (changed) {
> +		struct mmu_notifier_range range;
> +
> +		mmu_notifier_range_init(&range, MMU_NOTIFY_PROTECTION_UPGRADE,
> +					0, vmf->vma, vmf->vma->vm_mm,
> +					vmf->address & PAGE_MASK,
> +					(vmf->address & PAGE_MASK) + PAGE_SIZE);
> +		mmu_notifier_invalidate_range_start(&range);
> +		mmu_notifier_invalidate_range_end(&range);
> +	}

There are four similar patterns, can we introduce a helper function to
deduplicate them?

> +
>   	return 0;
>   }
>   

-- 
Thanks,
Qi
