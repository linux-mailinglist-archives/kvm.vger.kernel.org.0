Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 311F91E1B1C
	for <lists+kvm@lfdr.de>; Tue, 26 May 2020 08:16:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729594AbgEZGQt (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 26 May 2020 02:16:49 -0400
Received: from mail.kernel.org ([198.145.29.99]:60912 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726746AbgEZGQs (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 26 May 2020 02:16:48 -0400
Received: from kernel.org (unknown [87.70.212.59])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 84700207CB;
        Tue, 26 May 2020 06:16:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1590473807;
        bh=3GUMZUH4Icm1n+AZ9CiCLH0XOGDqQdoAia4oZBsAyd0=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=c1s52RzhYeDcJFDH48bICGP/84etBekZEjvF7MGeFc9wY+nZWOXKNjdnHjpTEB57+
         kl/xeB/z8K/FewxW76tW8IXK/NuUYINAjLpg5Sj08DYIu2M/26Mr8Q4HOwjD0xy3Cc
         kDBZ7u+8lJVMMUwFO6JTr1h/7e0YdQdAsWTCP3xc=
Date:   Tue, 26 May 2020 09:16:38 +0300
From:   Mike Rapoport <rppt@kernel.org>
To:     "Kirill A. Shutemov" <kirill@shutemov.name>
Cc:     Dave Hansen <dave.hansen@linux.intel.com>,
        Andy Lutomirski <luto@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        David Rientjes <rientjes@google.com>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Kees Cook <keescook@chromium.org>,
        Will Drewry <wad@chromium.org>,
        "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>,
        "Kleen, Andi" <andi.kleen@intel.com>, x86@kernel.org,
        kvm@vger.kernel.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Subject: Re: [RFC 16/16] KVM: Unmap protected pages from direct mapping
Message-ID: <20200526061638.GA48741@kernel.org>
References: <20200522125214.31348-1-kirill.shutemov@linux.intel.com>
 <20200522125214.31348-17-kirill.shutemov@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200522125214.31348-17-kirill.shutemov@linux.intel.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, May 22, 2020 at 03:52:14PM +0300, Kirill A. Shutemov wrote:
> If the protected memory feature enabled, unmap guest memory from
> kernel's direct mappings.
> 
> Migration and KSM is disabled for protected memory as it would require a
> special treatment.
> 
> Signed-off-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
> ---
>  arch/x86/mm/pat/set_memory.c |  1 +
>  include/linux/kvm_host.h     |  3 ++
>  mm/huge_memory.c             |  9 +++++
>  mm/ksm.c                     |  3 ++
>  mm/memory.c                  | 13 +++++++
>  mm/rmap.c                    |  4 ++
>  virt/kvm/kvm_main.c          | 74 ++++++++++++++++++++++++++++++++++++
>  7 files changed, 107 insertions(+)
> 
> diff --git a/arch/x86/mm/pat/set_memory.c b/arch/x86/mm/pat/set_memory.c
> index 6f075766bb94..13988413af40 100644
> --- a/arch/x86/mm/pat/set_memory.c
> +++ b/arch/x86/mm/pat/set_memory.c
> @@ -2227,6 +2227,7 @@ void __kernel_map_pages(struct page *page, int numpages, int enable)
>  
>  	arch_flush_lazy_mmu_mode();
>  }
> +EXPORT_SYMBOL_GPL(__kernel_map_pages);
>  
>  #ifdef CONFIG_HIBERNATION
>  bool kernel_page_present(struct page *page)
> diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
> index b6944f88033d..e1d7762b615c 100644
> --- a/include/linux/kvm_host.h
> +++ b/include/linux/kvm_host.h
> @@ -705,6 +705,9 @@ int kvm_protect_all_memory(struct kvm *kvm);
>  int kvm_protect_memory(struct kvm *kvm,
>  		       unsigned long gfn, unsigned long npages, bool protect);
>  
> +void kvm_map_page(struct page *page, int nr_pages);
> +void kvm_unmap_page(struct page *page, int nr_pages);
> +
>  int gfn_to_page_many_atomic(struct kvm_memory_slot *slot, gfn_t gfn,
>  			    struct page **pages, int nr_pages);
>  
> diff --git a/mm/huge_memory.c b/mm/huge_memory.c
> index c3562648a4ef..d8a444a401cc 100644
> --- a/mm/huge_memory.c
> +++ b/mm/huge_memory.c
> @@ -33,6 +33,7 @@
>  #include <linux/oom.h>
>  #include <linux/numa.h>
>  #include <linux/page_owner.h>
> +#include <linux/kvm_host.h>

This does not seem right... 

>  #include <asm/tlb.h>
>  #include <asm/pgalloc.h>
> @@ -650,6 +651,10 @@ static vm_fault_t __do_huge_pmd_anonymous_page(struct vm_fault *vmf,
>  		spin_unlock(vmf->ptl);
>  		count_vm_event(THP_FAULT_ALLOC);
>  		count_memcg_events(memcg, THP_FAULT_ALLOC, 1);
> +
> +		/* Unmap page from direct mapping */
> +		if (vma_is_kvm_protected(vma))
> +			kvm_unmap_page(page, HPAGE_PMD_NR);

... and neither does this.

I think the map/unmap primitives shoud be a part of the generic mm and
not burried inside KVM.

>  	}
>  
>  	return 0;
> @@ -1886,6 +1891,10 @@ int zap_huge_pmd(struct mmu_gather *tlb, struct vm_area_struct *vma,
>  			page_remove_rmap(page, true);
>  			VM_BUG_ON_PAGE(page_mapcount(page) < 0, page);
>  			VM_BUG_ON_PAGE(!PageHead(page), page);
> +
> +			/* Map the page back to the direct mapping */
> +			if (vma_is_kvm_protected(vma))
> +				kvm_map_page(page, HPAGE_PMD_NR);
>  		} else if (thp_migration_supported()) {
>  			swp_entry_t entry;
>  
> diff --git a/mm/ksm.c b/mm/ksm.c
> index 281c00129a2e..942b88782ac2 100644
> --- a/mm/ksm.c
> +++ b/mm/ksm.c
> @@ -527,6 +527,9 @@ static struct vm_area_struct *find_mergeable_vma(struct mm_struct *mm,
>  		return NULL;
>  	if (!(vma->vm_flags & VM_MERGEABLE) || !vma->anon_vma)
>  		return NULL;
> +	/* TODO */

Probably this is not something that should be done. For a security
sensitive environment that wants protected memory, KSM woudn't be
relevant anyway...

> +	if (vma_is_kvm_protected(vma))
> +		return NULL;
>  	return vma;
>  }
>  
> diff --git a/mm/memory.c b/mm/memory.c
> index d7228db6e4bf..74773229b854 100644
> --- a/mm/memory.c
> +++ b/mm/memory.c
> @@ -71,6 +71,7 @@
>  #include <linux/dax.h>
>  #include <linux/oom.h>
>  #include <linux/numa.h>
> +#include <linux/kvm_host.h>

The same comment as in mm/huge_memory.c. I don't think that generic mm
should depend on KVM.

>  #include <trace/events/kmem.h>
>  
> @@ -1088,6 +1089,11 @@ static unsigned long zap_pte_range(struct mmu_gather *tlb,
>  				    likely(!(vma->vm_flags & VM_SEQ_READ)))
>  					mark_page_accessed(page);
>  			}
> +
> +			/* Map the page back to the direct mapping */
> +			if (vma_is_anonymous(vma) && vma_is_kvm_protected(vma))
> +				kvm_map_page(page, 1);
> +
>  			rss[mm_counter(page)]--;
>  			page_remove_rmap(page, false);
>  			if (unlikely(page_mapcount(page) < 0))
> @@ -3312,6 +3318,7 @@ static vm_fault_t do_anonymous_page(struct vm_fault *vmf)
>  	struct page *page;
>  	vm_fault_t ret = 0;
>  	pte_t entry;
> +	bool set = false;
>  
>  	/* File mapping without ->vm_ops ? */
>  	if (vma->vm_flags & VM_SHARED)
> @@ -3397,6 +3404,7 @@ static vm_fault_t do_anonymous_page(struct vm_fault *vmf)
>  	page_add_new_anon_rmap(page, vma, vmf->address, false);
>  	mem_cgroup_commit_charge(page, memcg, false, false);
>  	lru_cache_add_active_or_unevictable(page, vma);
> +	set = true;
>  setpte:
>  	set_pte_at(vma->vm_mm, vmf->address, vmf->pte, entry);
>  
> @@ -3404,6 +3412,11 @@ static vm_fault_t do_anonymous_page(struct vm_fault *vmf)
>  	update_mmu_cache(vma, vmf->address, vmf->pte);
>  unlock:
>  	pte_unmap_unlock(vmf->pte, vmf->ptl);
> +
> +	/* Unmap page from direct mapping */
> +	if (vma_is_kvm_protected(vma) && set)
> +		kvm_unmap_page(page, 1);
> +
>  	return ret;
>  release:
>  	mem_cgroup_cancel_charge(page, memcg, false);
> diff --git a/mm/rmap.c b/mm/rmap.c
> index f79a206b271a..a9b2e347d1ab 100644
> --- a/mm/rmap.c
> +++ b/mm/rmap.c
> @@ -1709,6 +1709,10 @@ static bool try_to_unmap_one(struct page *page, struct vm_area_struct *vma,
>  
>  static bool invalid_migration_vma(struct vm_area_struct *vma, void *arg)
>  {
> +	/* TODO */
> +	if (vma_is_kvm_protected(vma))
> +		return true;
> +
>  	return vma_is_temporary_stack(vma);
>  }
>  
> diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
> index 71aac117357f..defc33d3a124 100644
> --- a/virt/kvm/kvm_main.c
> +++ b/virt/kvm/kvm_main.c
> @@ -51,6 +51,7 @@
>  #include <linux/io.h>
>  #include <linux/lockdep.h>
>  #include <linux/kthread.h>
> +#include <linux/pagewalk.h>
>  
>  #include <asm/processor.h>
>  #include <asm/ioctl.h>
> @@ -2718,6 +2719,72 @@ void kvm_vcpu_mark_page_dirty(struct kvm_vcpu *vcpu, gfn_t gfn)
>  }
>  EXPORT_SYMBOL_GPL(kvm_vcpu_mark_page_dirty);
>  
> +void kvm_map_page(struct page *page, int nr_pages)
> +{
> +	int i;
> +
> +	/* Clear page before returning it to the direct mapping */
> +	for (i = 0; i < nr_pages; i++) {
> +		void *p = map_page_atomic(page + i);
> +		memset(p, 0, PAGE_SIZE);
> +		unmap_page_atomic(p);
> +	}
> +
> +	kernel_map_pages(page, nr_pages, 1);
> +}
> +EXPORT_SYMBOL_GPL(kvm_map_page);
> +
> +void kvm_unmap_page(struct page *page, int nr_pages)
> +{
> +	kernel_map_pages(page, nr_pages, 0);
> +}
> +EXPORT_SYMBOL_GPL(kvm_unmap_page);
> +
> +static int adjust_direct_mapping_pte_range(pmd_t *pmd, unsigned long addr,
> +					   unsigned long end,
> +					   struct mm_walk *walk)
> +{
> +	bool protect = (bool)walk->private;
> +	pte_t *pte;
> +	struct page *page;
> +
> +	if (pmd_trans_huge(*pmd)) {
> +		page = pmd_page(*pmd);
> +		if (is_huge_zero_page(page))
> +			return 0;
> +		VM_BUG_ON_PAGE(total_mapcount(page) != 1, page);
> +		/* XXX: Would it fail with direct device assignment? */
> +		VM_BUG_ON_PAGE(page_count(page) != 1, page);
> +		kernel_map_pages(page, HPAGE_PMD_NR, !protect);
> +		return 0;
> +	}
> +
> +	pte = pte_offset_map(pmd, addr);
> +	for (; addr != end; pte++, addr += PAGE_SIZE) {
> +		pte_t entry = *pte;
> +
> +		if (!pte_present(entry))
> +			continue;
> +
> +		if (is_zero_pfn(pte_pfn(entry)))
> +			continue;
> +
> +		page = pte_page(entry);
> +
> +		VM_BUG_ON_PAGE(page_mapcount(page) != 1, page);
> +		/* XXX: Would it fail with direct device assignment? */
> +		VM_BUG_ON_PAGE(page_count(page) !=
> +			       total_mapcount(compound_head(page)), page);
> +		kernel_map_pages(page, 1, !protect);
> +	}
> +
> +	return 0;
> +}
> +
> +static const struct mm_walk_ops adjust_direct_mapping_ops = {
> +	.pmd_entry	= adjust_direct_mapping_pte_range,
> +};
> +

All this seem to me an addition to set_memory APIs rather then KVM.

>  static int protect_memory(unsigned long start, unsigned long end, bool protect)
>  {
>  	struct mm_struct *mm = current->mm;
> @@ -2763,6 +2830,13 @@ static int protect_memory(unsigned long start, unsigned long end, bool protect)
>  		if (ret)
>  			goto out;
>  
> +		if (vma_is_anonymous(vma)) {
> +			ret = walk_page_range_novma(mm, start, tmp,
> +					    &adjust_direct_mapping_ops, NULL,
> +					    (void *) protect);
> +			if (ret)
> +				goto out;
> +		}
>  next:
>  		start = tmp;
>  		if (start < prev->vm_end)
> -- 
> 2.26.2
> 
> 

-- 
Sincerely yours,
Mike.
