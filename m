Return-Path: <kvm+bounces-15481-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id E76B58ACB82
	for <lists+kvm@lfdr.de>; Mon, 22 Apr 2024 12:58:47 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 4D97DB23D1C
	for <lists+kvm@lfdr.de>; Mon, 22 Apr 2024 10:58:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9207B145FF0;
	Mon, 22 Apr 2024 10:58:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="ASXSqTH4"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9061D482C1;
	Mon, 22 Apr 2024 10:58:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.13
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713783506; cv=none; b=iGqdEPG8U0HLXvtI3JtnO7a38WAzrIsgDGsZbYolCm1BEXjiDO3L4Q4M6wJM6zdofFTxxJsM7WiEvVcOtwwegSdJusN1trWtoYCqjTFjWbvufDU3cxf6vK50MzcVLAj38ntlV7yjkW8VJjxnEqab0SPHnZ6WaMcV3ipQi8ZITyk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713783506; c=relaxed/simple;
	bh=lPATZdfC4lvu1dgYEE2BFqtfBxeTwRg2JFrdpCPXZMs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=rUlS8RkBBRU762cIpp/jTxH6heOUB/X5oimK381yBnjEWYaFKV0kCXS4+OZ7E92r4VzGHUaTDlnQmMJkp14a4of4t0yvJ65D1zavWTo3crutxDIgThygRMxpC+Y51mq16CLZYmIi6sIxoxJLABntjJ8mwj5RSbxO5x+18hR/VFI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=ASXSqTH4; arc=none smtp.client-ip=198.175.65.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1713783504; x=1745319504;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=lPATZdfC4lvu1dgYEE2BFqtfBxeTwRg2JFrdpCPXZMs=;
  b=ASXSqTH4jAXmykN3u03L8Arf+wT62uGC5n7SxrAZ6RMttYFzoHSDgqEF
   LQvr/xnYurI7T1q8gdThfTD8jXZjOu/Nqr5zitV5i1T0PAYCN7t6+2qQt
   7UC3EvNUsysGClSrbDLoa5SnhOQEgG521vnOoE/fiKUFCMkFICs5jdAo2
   qgV1DGhWMQQtjir3jWVg772xY/19rCxWZmLShUUJRbsD3dY7DWBlNxRR/
   xbeLYrJrY4Ts7PvjP4uKLJBXKx84EFJCKqJvvUFIe8xYj6sYB91NDq3pi
   VS+d+AwmgKPTjNDf/5UZVb7PNASSTdWk5BftrBgqUUaxQDYoY7ZRNnqcK
   A==;
X-CSE-ConnectionGUID: Wm5bgdjzQVy1kUrOsJMJMg==
X-CSE-MsgGUID: jnRm82qnSFC8qkjf7BYPaQ==
X-IronPort-AV: E=McAfee;i="6600,9927,11051"; a="20453682"
X-IronPort-AV: E=Sophos;i="6.07,220,1708416000"; 
   d="scan'208";a="20453682"
Received: from fmviesa010.fm.intel.com ([10.60.135.150])
  by orvoesa105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Apr 2024 03:58:23 -0700
X-CSE-ConnectionGUID: yrgtAYVYS1SH1HzMkvUDxQ==
X-CSE-MsgGUID: fQWUNgQ4SXmCgHFcx2AAxw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,220,1708416000"; 
   d="scan'208";a="24017009"
Received: from yilunxu-optiplex-7050.sh.intel.com (HELO localhost) ([10.239.159.165])
  by fmviesa010.fm.intel.com with ESMTP; 22 Apr 2024 03:58:21 -0700
Date: Mon, 22 Apr 2024 18:53:02 +0800
From: Xu Yilun <yilun.xu@linux.intel.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: linux-kernel@vger.kernel.org, kvm@vger.kernel.org, seanjc@google.com,
	michael.roth@amd.com, isaku.yamahata@intel.com
Subject: Re: [PATCH 06/11] KVM: guest_memfd: Add hook for initializing memory
Message-ID: <ZiZBjtQvUuuqqKNF@yilunxu-OptiPlex-7050>
References: <20240404185034.3184582-1-pbonzini@redhat.com>
 <20240404185034.3184582-7-pbonzini@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240404185034.3184582-7-pbonzini@redhat.com>

On Thu, Apr 04, 2024 at 02:50:28PM -0400, Paolo Bonzini wrote:
> guest_memfd pages are generally expected to be in some arch-defined
> initial state prior to using them for guest memory. For SEV-SNP this
> initial state is 'private', or 'guest-owned', and requires additional
> operations to move these pages into a 'private' state by updating the
> corresponding entries the RMP table.
> 
> Allow for an arch-defined hook to handle updates of this sort, and go
> ahead and implement one for x86 so KVM implementations like AMD SVM can
> register a kvm_x86_ops callback to handle these updates for SEV-SNP
> guests.
> 
> The preparation callback is always called when allocating/grabbing
> folios via gmem, and it is up to the architecture to keep track of
> whether or not the pages are already in the expected state (e.g. the RMP
> table in the case of SEV-SNP).
> 
> In some cases, it is necessary to defer the preparation of the pages to
> handle things like in-place encryption of initial guest memory payloads
> before marking these pages as 'private'/'guest-owned'.  Add an argument
> (always true for now) to kvm_gmem_get_folio() that allows for the
> preparation callback to be bypassed.  To detect possible issues in

IIUC, we have 2 dedicated flows.
1 kvm_gmem_get_pfn() or kvm_gmem_allocate()
  a. kvm_gmem_get_folio()
  b. gmem_prepare() for RMP

2 in-place encryption or whatever
  a. kvm_gmem_get_folio(FGP_CREAT_ONLY)
  b. in-place encryption
  c. gmem_prepare() for RMP

Could we move gmem_prepare() out of kvm_gmem_get_folio(), then we could
have straightforward flow for each case, and don't have to have an
argument to pospone gmem_prepare().

> the way userspace initializes memory, it is only possible to add an
> unprepared page if it is not already included in the filemap.
> 
> Link: https://lore.kernel.org/lkml/ZLqVdvsF11Ddo7Dq@google.com/
> Co-developed-by: Michael Roth <michael.roth@amd.com>
> Signed-off-by: Michael Roth <michael.roth@amd.com>
> Message-Id: <20231230172351.574091-5-michael.roth@amd.com>
> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
> ---
>  arch/x86/include/asm/kvm-x86-ops.h |  1 +
>  arch/x86/include/asm/kvm_host.h    |  1 +
>  arch/x86/kvm/x86.c                 |  6 +++
>  include/linux/kvm_host.h           |  5 +++
>  virt/kvm/Kconfig                   |  4 ++
>  virt/kvm/guest_memfd.c             | 65 ++++++++++++++++++++++++++++--
>  6 files changed, 78 insertions(+), 4 deletions(-)
> 
> diff --git a/arch/x86/include/asm/kvm-x86-ops.h b/arch/x86/include/asm/kvm-x86-ops.h
> index 5187fcf4b610..d26fcad13e36 100644
> --- a/arch/x86/include/asm/kvm-x86-ops.h
> +++ b/arch/x86/include/asm/kvm-x86-ops.h
> @@ -139,6 +139,7 @@ KVM_X86_OP(vcpu_deliver_sipi_vector)
>  KVM_X86_OP_OPTIONAL_RET0(vcpu_get_apicv_inhibit_reasons);
>  KVM_X86_OP_OPTIONAL(get_untagged_addr)
>  KVM_X86_OP_OPTIONAL(alloc_apic_backing_page)
> +KVM_X86_OP_OPTIONAL_RET0(gmem_prepare)
>  
>  #undef KVM_X86_OP
>  #undef KVM_X86_OP_OPTIONAL
> diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
> index 01c69840647e..f101fab0040e 100644
> --- a/arch/x86/include/asm/kvm_host.h
> +++ b/arch/x86/include/asm/kvm_host.h
> @@ -1809,6 +1809,7 @@ struct kvm_x86_ops {
>  
>  	gva_t (*get_untagged_addr)(struct kvm_vcpu *vcpu, gva_t gva, unsigned int flags);
>  	void *(*alloc_apic_backing_page)(struct kvm_vcpu *vcpu);
> +	int (*gmem_prepare)(struct kvm *kvm, kvm_pfn_t pfn, gfn_t gfn, int max_order);
>  };
>  
>  struct kvm_x86_nested_ops {
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index 2d2619d3eee4..972524ddcfdb 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -13598,6 +13598,12 @@ bool kvm_arch_no_poll(struct kvm_vcpu *vcpu)
>  }
>  EXPORT_SYMBOL_GPL(kvm_arch_no_poll);
>  
> +#ifdef CONFIG_HAVE_KVM_GMEM_PREPARE
> +int kvm_arch_gmem_prepare(struct kvm *kvm, gfn_t gfn, kvm_pfn_t pfn, int max_order)
> +{
> +	return static_call(kvm_x86_gmem_prepare)(kvm, pfn, gfn, max_order);
> +}
> +#endif
>  
>  int kvm_spec_ctrl_test_value(u64 value)
>  {
> diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
> index 48f31dcd318a..33ed3b884a6b 100644
> --- a/include/linux/kvm_host.h
> +++ b/include/linux/kvm_host.h
> @@ -2445,4 +2445,9 @@ static inline int kvm_gmem_get_pfn(struct kvm *kvm,
>  }
>  #endif /* CONFIG_KVM_PRIVATE_MEM */
>  
> +#ifdef CONFIG_HAVE_KVM_GMEM_PREPARE
> +int kvm_arch_gmem_prepare(struct kvm *kvm, gfn_t gfn, kvm_pfn_t pfn, int max_order);
> +bool kvm_arch_gmem_prepare_needed(struct kvm *kvm);
> +#endif
> +
>  #endif
> diff --git a/virt/kvm/Kconfig b/virt/kvm/Kconfig
> index 29b73eedfe74..ca870157b2ed 100644
> --- a/virt/kvm/Kconfig
> +++ b/virt/kvm/Kconfig
> @@ -109,3 +109,7 @@ config KVM_GENERIC_PRIVATE_MEM
>         select KVM_GENERIC_MEMORY_ATTRIBUTES
>         select KVM_PRIVATE_MEM
>         bool
> +
> +config HAVE_KVM_GMEM_PREPARE
> +       bool
> +       depends on KVM_PRIVATE_MEM
> diff --git a/virt/kvm/guest_memfd.c b/virt/kvm/guest_memfd.c
> index e5b3cd02b651..486748e65f36 100644
> --- a/virt/kvm/guest_memfd.c
> +++ b/virt/kvm/guest_memfd.c
> @@ -13,12 +13,60 @@ struct kvm_gmem {
>  	struct list_head entry;
>  };
>  
> -static struct folio *kvm_gmem_get_folio(struct inode *inode, pgoff_t index)
> +#ifdef CONFIG_HAVE_KVM_GMEM_PREPARE
> +bool __weak kvm_arch_gmem_prepare_needed(struct kvm *kvm)
> +{
> +	return false;
> +}
> +#endif

In which case HAVE_KVM_GMEM_PREPARE is selected but
gmem_prepare_needed() is never implemented?  Then all gmem_prepare stuff
are actually dead code.  Maybe we don't need this weak stub?

> +
> +static int kvm_gmem_prepare_folio(struct inode *inode, pgoff_t index, struct folio *folio)
> +{
> +#ifdef CONFIG_HAVE_KVM_GMEM_PREPARE
> +	struct list_head *gmem_list = &inode->i_mapping->i_private_list;
> +	struct kvm_gmem *gmem;
> +
> +	list_for_each_entry(gmem, gmem_list, entry) {
> +		struct kvm_memory_slot *slot;
> +		struct kvm *kvm = gmem->kvm;
> +		struct page *page;
> +		kvm_pfn_t pfn;
> +		gfn_t gfn;
> +		int rc;
> +
> +		if (!kvm_arch_gmem_prepare_needed(kvm))
> +			continue;
> +
> +		slot = xa_load(&gmem->bindings, index);
> +		if (!slot)
> +			continue;
> +
> +		page = folio_file_page(folio, index);
> +		pfn = page_to_pfn(page);
> +		gfn = slot->base_gfn + index - slot->gmem.pgoff;
> +		rc = kvm_arch_gmem_prepare(kvm, gfn, pfn, compound_order(compound_head(page)));
> +		if (rc) {
> +			pr_warn_ratelimited("gmem: Failed to prepare folio for index %lx, error %d.\n",
> +					    index, rc);
> +			return rc;
> +		}
> +	}
> +
> +#endif
> +	return 0;
> +}
> +
> +static struct folio *kvm_gmem_get_folio(struct inode *inode, pgoff_t index, bool prepare)
>  {
>  	struct folio *folio;
> +	fgf_t fgp_flags = FGP_LOCK | FGP_ACCESSED | FGP_CREAT;
> +
> +	if (!prepare)
> +		fgp_flags |= FGP_CREAT_ONLY;
>  
>  	/* TODO: Support huge pages. */
> -	folio = filemap_grab_folio(inode->i_mapping, index);
> +	folio = __filemap_get_folio(inode->i_mapping, index, fgp_flags,
> +				    mapping_gfp_mask(inode->i_mapping));
>  	if (IS_ERR_OR_NULL(folio))
>  		return folio;
>  
> @@ -41,6 +89,15 @@ static struct folio *kvm_gmem_get_folio(struct inode *inode, pgoff_t index)
>  		folio_mark_uptodate(folio);
>  	}
>  
> +	if (prepare) {
> +		int r =	kvm_gmem_prepare_folio(inode, index, folio);
> +		if (r < 0) {
> +			folio_unlock(folio);
> +			folio_put(folio);
> +			return ERR_PTR(r);
> +		}
> +	}
> +

Do we still need to prepare the page if it is hwpoisoned? I see the
hwpoisoned check is outside, in kvm_gmem_get_pfn().

Thanks,
Yilun

>  	/*
>  	 * Ignore accessed, referenced, and dirty flags.  The memory is
>  	 * unevictable and there is no storage to write back to.
> @@ -145,7 +202,7 @@ static long kvm_gmem_allocate(struct inode *inode, loff_t offset, loff_t len)
>  			break;
>  		}
>  
> -		folio = kvm_gmem_get_folio(inode, index);
> +		folio = kvm_gmem_get_folio(inode, index, true);
>  		if (IS_ERR_OR_NULL(folio)) {
>  			r = folio ? PTR_ERR(folio) : -ENOMEM;
>  			break;
> @@ -505,7 +562,7 @@ int kvm_gmem_get_pfn(struct kvm *kvm, struct kvm_memory_slot *slot,
>  		goto out_fput;
>  	}
>  
> -	folio = kvm_gmem_get_folio(file_inode(file), index);
> +	folio = kvm_gmem_get_folio(file_inode(file), index, true);
>  	if (!folio) {
>  		r = -ENOMEM;
>  		goto out_fput;
> -- 
> 2.43.0
> 
> 
> 

