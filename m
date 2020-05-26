Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E2B211E3215
	for <lists+kvm@lfdr.de>; Wed, 27 May 2020 00:10:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391916AbgEZWKf (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 26 May 2020 18:10:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34266 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2391892AbgEZWK3 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 26 May 2020 18:10:29 -0400
Received: from mail-lf1-x141.google.com (mail-lf1-x141.google.com [IPv6:2a00:1450:4864:20::141])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 531D8C061A0F
        for <kvm@vger.kernel.org>; Tue, 26 May 2020 15:10:29 -0700 (PDT)
Received: by mail-lf1-x141.google.com with SMTP id w15so13217777lfe.11
        for <kvm@vger.kernel.org>; Tue, 26 May 2020 15:10:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=shutemov-name.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=S8Sh+DjtPEAcfjFCLlA/An7vGsa0j6xUtlJx+u0SHCo=;
        b=iaJc4Q0dVmQB2Nw7TDPjM5G/drSQCJ1I0yTkAzs35+wOBGWa8Y7ejBHHXXwVKMTMQ+
         NkNdap9tqvkiIP9m0q7O1axUE2lvJgI92jZ0IOXLF2XRcaUzTSo/ftuzFdVXnVzObmWy
         0CMdIgFTfIsBa7I+hhkQf7Fal4GZRNCYXpv14mQOa8XieWI923D6i4MsqVe56fxN2ZF6
         rHv8DGtKKWb9J8y+3Z1O0+vbmnh2k4VRBjNiHod5ZDOy54y/27IGfws3tAvpafBWD1L+
         Yi4zJuYg5k5tLPgIEIsylRkz7gp6zK4NNvnxczcZ7BEQ7VnR3CUUIWchfSRdBsju+uqK
         jSdA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=S8Sh+DjtPEAcfjFCLlA/An7vGsa0j6xUtlJx+u0SHCo=;
        b=TvxrqXABGJxaHb+BN4MDxn6G4xDH55XITeKF7EkAA5Xc8zsAgFI3yOeY5Jozjn500k
         ZUuxAT1Y99GmEILn7J36TEvsONxxDJj9HAf+hjknxyh50tU4SjA1WKmA9VYC5TjkrvBG
         YV1Rf6WA0BaNxiEJ5F4fMib1BTWoYt8cEAxqKp1/cx3xeqg6fjlY+viubxEoGVdYM6KN
         9TXkQkrN41pUe2E04PV+3BYtaep7m4FaeA6PvI3Z1HdhgzQVRYwo4I6Zgcq+UGijEHI0
         Pa8SUlTIdfanqQqy3WZ2AJxtxfZioplpzdo9T3fsgklTCa7YAdgqHXh9/8qD5/mlAZ9K
         ihnQ==
X-Gm-Message-State: AOAM533hkERs9GMUt+TGbMh6t3bnOSjlSNg+kM8ag2jHnBIe8QfxHONa
        UlTXMoJa5JGDvJ9ZK6rgYlM9xA==
X-Google-Smtp-Source: ABdhPJwnVJa8vgBbkVQ2tVPyuo9o5O4stVIJ3HJJkVTe15rtWt8oFnTtiz5Ih+h4GOvl+rvxKsG0aQ==
X-Received: by 2002:a19:5f4e:: with SMTP id a14mr1482768lfj.57.1590531027702;
        Tue, 26 May 2020 15:10:27 -0700 (PDT)
Received: from box.localdomain ([86.57.175.117])
        by smtp.gmail.com with ESMTPSA id n2sm278570lfl.53.2020.05.26.15.10.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 26 May 2020 15:10:27 -0700 (PDT)
Received: by box.localdomain (Postfix, from userid 1000)
        id D850A10230F; Wed, 27 May 2020 01:10:27 +0300 (+03)
Date:   Wed, 27 May 2020 01:10:27 +0300
From:   "Kirill A. Shutemov" <kirill@shutemov.name>
To:     Mike Rapoport <rppt@kernel.org>
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
Message-ID: <20200526221027.ixxahg6ya2z5fppy@box>
References: <20200522125214.31348-1-kirill.shutemov@linux.intel.com>
 <20200522125214.31348-17-kirill.shutemov@linux.intel.com>
 <20200526061638.GA48741@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200526061638.GA48741@kernel.org>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, May 26, 2020 at 09:16:38AM +0300, Mike Rapoport wrote:
> On Fri, May 22, 2020 at 03:52:14PM +0300, Kirill A. Shutemov wrote:
> > If the protected memory feature enabled, unmap guest memory from
> > kernel's direct mappings.
> > 
> > Migration and KSM is disabled for protected memory as it would require a
> > special treatment.
> > 
> > Signed-off-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
> > ---
> >  arch/x86/mm/pat/set_memory.c |  1 +
> >  include/linux/kvm_host.h     |  3 ++
> >  mm/huge_memory.c             |  9 +++++
> >  mm/ksm.c                     |  3 ++
> >  mm/memory.c                  | 13 +++++++
> >  mm/rmap.c                    |  4 ++
> >  virt/kvm/kvm_main.c          | 74 ++++++++++++++++++++++++++++++++++++
> >  7 files changed, 107 insertions(+)
> > 
> > diff --git a/arch/x86/mm/pat/set_memory.c b/arch/x86/mm/pat/set_memory.c
> > index 6f075766bb94..13988413af40 100644
> > --- a/arch/x86/mm/pat/set_memory.c
> > +++ b/arch/x86/mm/pat/set_memory.c
> > @@ -2227,6 +2227,7 @@ void __kernel_map_pages(struct page *page, int numpages, int enable)
> >  
> >  	arch_flush_lazy_mmu_mode();
> >  }
> > +EXPORT_SYMBOL_GPL(__kernel_map_pages);
> >  
> >  #ifdef CONFIG_HIBERNATION
> >  bool kernel_page_present(struct page *page)
> > diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
> > index b6944f88033d..e1d7762b615c 100644
> > --- a/include/linux/kvm_host.h
> > +++ b/include/linux/kvm_host.h
> > @@ -705,6 +705,9 @@ int kvm_protect_all_memory(struct kvm *kvm);
> >  int kvm_protect_memory(struct kvm *kvm,
> >  		       unsigned long gfn, unsigned long npages, bool protect);
> >  
> > +void kvm_map_page(struct page *page, int nr_pages);
> > +void kvm_unmap_page(struct page *page, int nr_pages);
> > +
> >  int gfn_to_page_many_atomic(struct kvm_memory_slot *slot, gfn_t gfn,
> >  			    struct page **pages, int nr_pages);
> >  
> > diff --git a/mm/huge_memory.c b/mm/huge_memory.c
> > index c3562648a4ef..d8a444a401cc 100644
> > --- a/mm/huge_memory.c
> > +++ b/mm/huge_memory.c
> > @@ -33,6 +33,7 @@
> >  #include <linux/oom.h>
> >  #include <linux/numa.h>
> >  #include <linux/page_owner.h>
> > +#include <linux/kvm_host.h>
> 
> This does not seem right... 

I agree. I try to find a more clean way to deal with it.

> >  #include <asm/tlb.h>
> >  #include <asm/pgalloc.h>
> > @@ -650,6 +651,10 @@ static vm_fault_t __do_huge_pmd_anonymous_page(struct vm_fault *vmf,
> >  		spin_unlock(vmf->ptl);
> >  		count_vm_event(THP_FAULT_ALLOC);
> >  		count_memcg_events(memcg, THP_FAULT_ALLOC, 1);
> > +
> > +		/* Unmap page from direct mapping */
> > +		if (vma_is_kvm_protected(vma))
> > +			kvm_unmap_page(page, HPAGE_PMD_NR);
> 
> ... and neither does this.
> 
> I think the map/unmap primitives shoud be a part of the generic mm and
> not burried inside KVM.

Well, yes. Except, kvm_map_page() also clears the page before bringing it
back to direct mappings. Not sure yet how to deal with it.

> >  	return 0;
> > @@ -1886,6 +1891,10 @@ int zap_huge_pmd(struct mmu_gather *tlb, struct vm_area_struct *vma,
> >  			page_remove_rmap(page, true);
> >  			VM_BUG_ON_PAGE(page_mapcount(page) < 0, page);
> >  			VM_BUG_ON_PAGE(!PageHead(page), page);
> > +
> > +			/* Map the page back to the direct mapping */
> > +			if (vma_is_kvm_protected(vma))
> > +				kvm_map_page(page, HPAGE_PMD_NR);
> >  		} else if (thp_migration_supported()) {
> >  			swp_entry_t entry;
> >  
> > diff --git a/mm/ksm.c b/mm/ksm.c
> > index 281c00129a2e..942b88782ac2 100644
> > --- a/mm/ksm.c
> > +++ b/mm/ksm.c
> > @@ -527,6 +527,9 @@ static struct vm_area_struct *find_mergeable_vma(struct mm_struct *mm,
> >  		return NULL;
> >  	if (!(vma->vm_flags & VM_MERGEABLE) || !vma->anon_vma)
> >  		return NULL;
> > +	/* TODO */
> 
> Probably this is not something that should be done. For a security
> sensitive environment that wants protected memory, KSM woudn't be
> relevant anyway...

Hm. True.

> > diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
> > index 71aac117357f..defc33d3a124 100644
> > --- a/virt/kvm/kvm_main.c
> > +++ b/virt/kvm/kvm_main.c
> > @@ -51,6 +51,7 @@
> >  #include <linux/io.h>
> >  #include <linux/lockdep.h>
> >  #include <linux/kthread.h>
> > +#include <linux/pagewalk.h>
> >  
> >  #include <asm/processor.h>
> >  #include <asm/ioctl.h>
> > @@ -2718,6 +2719,72 @@ void kvm_vcpu_mark_page_dirty(struct kvm_vcpu *vcpu, gfn_t gfn)
> >  }
> >  EXPORT_SYMBOL_GPL(kvm_vcpu_mark_page_dirty);
> >  
> > +void kvm_map_page(struct page *page, int nr_pages)
> > +{
> > +	int i;
> > +
> > +	/* Clear page before returning it to the direct mapping */
> > +	for (i = 0; i < nr_pages; i++) {
> > +		void *p = map_page_atomic(page + i);
> > +		memset(p, 0, PAGE_SIZE);
> > +		unmap_page_atomic(p);
> > +	}
> > +
> > +	kernel_map_pages(page, nr_pages, 1);
> > +}
> > +EXPORT_SYMBOL_GPL(kvm_map_page);
> > +
> > +void kvm_unmap_page(struct page *page, int nr_pages)
> > +{
> > +	kernel_map_pages(page, nr_pages, 0);
> > +}
> > +EXPORT_SYMBOL_GPL(kvm_unmap_page);
> > +
> > +static int adjust_direct_mapping_pte_range(pmd_t *pmd, unsigned long addr,
> > +					   unsigned long end,
> > +					   struct mm_walk *walk)
> > +{
> > +	bool protect = (bool)walk->private;
> > +	pte_t *pte;
> > +	struct page *page;
> > +
> > +	if (pmd_trans_huge(*pmd)) {
> > +		page = pmd_page(*pmd);
> > +		if (is_huge_zero_page(page))
> > +			return 0;
> > +		VM_BUG_ON_PAGE(total_mapcount(page) != 1, page);
> > +		/* XXX: Would it fail with direct device assignment? */
> > +		VM_BUG_ON_PAGE(page_count(page) != 1, page);
> > +		kernel_map_pages(page, HPAGE_PMD_NR, !protect);
> > +		return 0;
> > +	}
> > +
> > +	pte = pte_offset_map(pmd, addr);
> > +	for (; addr != end; pte++, addr += PAGE_SIZE) {
> > +		pte_t entry = *pte;
> > +
> > +		if (!pte_present(entry))
> > +			continue;
> > +
> > +		if (is_zero_pfn(pte_pfn(entry)))
> > +			continue;
> > +
> > +		page = pte_page(entry);
> > +
> > +		VM_BUG_ON_PAGE(page_mapcount(page) != 1, page);
> > +		/* XXX: Would it fail with direct device assignment? */
> > +		VM_BUG_ON_PAGE(page_count(page) !=
> > +			       total_mapcount(compound_head(page)), page);
> > +		kernel_map_pages(page, 1, !protect);
> > +	}
> > +
> > +	return 0;
> > +}
> > +
> > +static const struct mm_walk_ops adjust_direct_mapping_ops = {
> > +	.pmd_entry	= adjust_direct_mapping_pte_range,
> > +};
> > +
> 
> All this seem to me an addition to set_memory APIs rather then KVM.

Emm?.. I don't think walking userspace mapping is set_memory thing.
And kernel_map_pages() is VMM interface already.

-- 
 Kirill A. Shutemov
