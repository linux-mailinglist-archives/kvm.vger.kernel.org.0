Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C102311D417
	for <lists+kvm@lfdr.de>; Thu, 12 Dec 2019 18:34:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730175AbfLLReO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 12 Dec 2019 12:34:14 -0500
Received: from mga09.intel.com ([134.134.136.24]:46445 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730104AbfLLReO (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 12 Dec 2019 12:34:14 -0500
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by orsmga102.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 12 Dec 2019 09:34:13 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.69,306,1571727600"; 
   d="scan'208";a="364042068"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.202])
  by orsmga004.jf.intel.com with ESMTP; 12 Dec 2019 09:34:13 -0800
Date:   Thu, 12 Dec 2019 09:34:13 -0800
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Barret Rhoden <brho@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Dan Williams <dan.j.williams@intel.com>,
        David Hildenbrand <david@redhat.com>,
        Dave Jiang <dave.jiang@intel.com>,
        Alexander Duyck <alexander.h.duyck@linux.intel.com>,
        linux-nvdimm@lists.01.org, x86@kernel.org, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, jason.zeng@intel.com
Subject: Re: [PATCH v4 2/2] kvm: Use huge pages for DAX-backed files
Message-ID: <20191212173413.GC3163@linux.intel.com>
References: <20191211213207.215936-1-brho@google.com>
 <20191211213207.215936-3-brho@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191211213207.215936-3-brho@google.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Dec 11, 2019 at 04:32:07PM -0500, Barret Rhoden wrote:
> This change allows KVM to map DAX-backed files made of huge pages with
> huge mappings in the EPT/TDP.
> 
> DAX pages are not PageTransCompound.  The existing check is trying to
> determine if the mapping for the pfn is a huge mapping or not.  For
> non-DAX maps, e.g. hugetlbfs, that means checking PageTransCompound.
> For DAX, we can check the page table itself.
> 
> Note that KVM already faulted in the page (or huge page) in the host's
> page table, and we hold the KVM mmu spinlock.  We grabbed that lock in
> kvm_mmu_notifier_invalidate_range_end, before checking the mmu seq.
> 
> Signed-off-by: Barret Rhoden <brho@google.com>
> ---
>  arch/x86/kvm/mmu/mmu.c | 36 ++++++++++++++++++++++++++++++++----
>  1 file changed, 32 insertions(+), 4 deletions(-)
> 
> diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> index 6f92b40d798c..cd07bc4e595f 100644
> --- a/arch/x86/kvm/mmu/mmu.c
> +++ b/arch/x86/kvm/mmu/mmu.c
> @@ -3384,6 +3384,35 @@ static int kvm_handle_bad_page(struct kvm_vcpu *vcpu, gfn_t gfn, kvm_pfn_t pfn)
>  	return -EFAULT;
>  }
>  
> +static bool pfn_is_huge_mapped(struct kvm *kvm, gfn_t gfn, kvm_pfn_t pfn)
> +{
> +	struct page *page = pfn_to_page(pfn);
> +	unsigned long hva;
> +
> +	if (!is_zone_device_page(page))
> +		return PageTransCompoundMap(page);
> +
> +	/*
> +	 * DAX pages do not use compound pages.  The page should have already
> +	 * been mapped into the host-side page table during try_async_pf(), so
> +	 * we can check the page tables directly.
> +	 */
> +	hva = gfn_to_hva(kvm, gfn);
> +	if (kvm_is_error_hva(hva))
> +		return false;
> +
> +	/*
> +	 * Our caller grabbed the KVM mmu_lock with a successful
> +	 * mmu_notifier_retry, so we're safe to walk the page table.
> +	 */
> +	switch (dev_pagemap_mapping_shift(hva, current->mm)) {
> +	case PMD_SHIFT:
> +	case PUD_SIZE:

I assume this means DAX can have 1GB pages?  I ask because KVM's THP logic
has historically relied on THP only supporting 2MB.  I cleaned this up in
a recent series[*], which is in kvm/queue, but I obviously didn't actually
test whether or not KVM would correctly handle 1GB non-hugetlbfs pages.

The easiest thing is probably to rebase on kvm/queue.  You'll need to do
that anyways, and I suspect doing so will help shake out any hiccups.

[*] https://lkml.kernel.org/r/20191206235729.29263-1-sean.j.christopherson@intel.com

> +		return true;
> +	}
> +	return false;
> +}
> +
>  static void transparent_hugepage_adjust(struct kvm_vcpu *vcpu,
>  					gfn_t gfn, kvm_pfn_t *pfnp,
>  					int *levelp)
> @@ -3398,8 +3427,8 @@ static void transparent_hugepage_adjust(struct kvm_vcpu *vcpu,
>  	 * here.
>  	 */
>  	if (!is_error_noslot_pfn(pfn) && !kvm_is_reserved_pfn(pfn) &&
> -	    !kvm_is_zone_device_pfn(pfn) && level == PT_PAGE_TABLE_LEVEL &&
> -	    PageTransCompoundMap(pfn_to_page(pfn)) &&
> +	    level == PT_PAGE_TABLE_LEVEL &&
> +	    pfn_is_huge_mapped(vcpu->kvm, gfn, pfn) &&
>  	    !mmu_gfn_lpage_is_disallowed(vcpu, gfn, PT_DIRECTORY_LEVEL)) {
>  		unsigned long mask;
>  		/*
> @@ -6015,8 +6044,7 @@ static bool kvm_mmu_zap_collapsible_spte(struct kvm *kvm,
>  		 * mapping if the indirect sp has level = 1.
>  		 */
>  		if (sp->role.direct && !kvm_is_reserved_pfn(pfn) &&
> -		    !kvm_is_zone_device_pfn(pfn) &&
> -		    PageTransCompoundMap(pfn_to_page(pfn))) {
> +		    pfn_is_huge_mapped(kvm, sp->gfn, pfn)) {
>  			pte_list_remove(rmap_head, sptep);
>  
>  			if (kvm_available_flush_tlb_with_range())
> -- 
> 2.24.0.525.g8f36a354ae-goog
> 
