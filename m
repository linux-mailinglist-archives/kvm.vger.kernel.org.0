Return-Path: <kvm+bounces-47853-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 387B9AC639F
	for <lists+kvm@lfdr.de>; Wed, 28 May 2025 10:05:08 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id A81581712D5
	for <lists+kvm@lfdr.de>; Wed, 28 May 2025 08:05:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7675724676B;
	Wed, 28 May 2025 08:05:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="WpRqsxLE"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 18D36217679;
	Wed, 28 May 2025 08:04:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.17
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748419499; cv=none; b=ra1/guNrpt3gUYcVxn3Pm7+NkwuiOI9do3faYXhGpc3ExGIw+TfZh2PKtj2GBhdrSgrCjOM/p59/xH7VcIDY1ZfQe5hfl36kxaNv8B5NpguTX2pfwVzaPd8d5Az8rvqG5eIEMTMA21WzgjZYlLd4LczKGidgVfODBrS8+GYWKUM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748419499; c=relaxed/simple;
	bh=zvk+/0pOBB6n96MopJf2kYiRrFww4RvKm0+5MlficmA=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=hWupNrP4RtYbm3CjEU4tfmtOZDo8+KAiJfsGOiPGdM3rq5kpBYz0QwZnimTLLU0bB7YiP7uhSJc3v1QoYLVqcgP3yabPg45S1MuGceIvbosWO8wWMIJyughk6tOv/nthSwo/FiuwCHyngkW3ifSzm3fseBDg6lBY7+6e4Mmhtnc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=WpRqsxLE; arc=none smtp.client-ip=198.175.65.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1748419498; x=1779955498;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=zvk+/0pOBB6n96MopJf2kYiRrFww4RvKm0+5MlficmA=;
  b=WpRqsxLE0fqpqsst422z/Tq2rzisuo9Bkb/HudTVO5w2BThmaFtIA7b7
   VH4gxyehConApYL8jcLvQtONp+LJz22YzS/edeoQBcTKSJ63ssElkY9Jw
   WisD3rK51n4FpNbTWbTMOjOd/TYNFa06wIHGI5zk6nRDc6ljpV19TVdEy
   nzVeZODzVQitPC3WT/RScz18I8z0T/dX6sK8mrY40M1iUoIwRNHsdvcRD
   /Q4pPzfO3Sow9oqZJ10iJ24CM9WOHaCTbenX5d5e9Gsk3C3KbyTI/aICa
   RWrN2ZQSc+LDYXXKw+NtG/6Kn0hePbNlln1Fpah3OH9yijjgLRSJABXqe
   w==;
X-CSE-ConnectionGUID: f1b05I5ZT/64CMmDa7z1RQ==
X-CSE-MsgGUID: rMUIiL02TCOzQ1M87RoHKw==
X-IronPort-AV: E=McAfee;i="6700,10204,11446"; a="50428456"
X-IronPort-AV: E=Sophos;i="6.15,320,1739865600"; 
   d="scan'208";a="50428456"
Received: from fmviesa001.fm.intel.com ([10.60.135.141])
  by orvoesa109.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 May 2025 01:04:56 -0700
X-CSE-ConnectionGUID: 2JaN/U7vSq2pjZYvQ5ifTg==
X-CSE-MsgGUID: 0swEWbnRSVKrGb0smiqn7Q==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.15,320,1739865600"; 
   d="scan'208";a="174057105"
Received: from xiaoyaol-hp-g830.ccr.corp.intel.com (HELO [10.124.247.1]) ([10.124.247.1])
  by smtpauth.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 May 2025 01:04:54 -0700
Message-ID: <7cc5cd92-1854-4e0e-93b7-e4eee5991334@intel.com>
Date: Wed, 28 May 2025 16:04:51 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 2/4] KVM: x86/mmu: Dynamically allocate shadow MMU's
 hashed page list
To: Sean Christopherson <seanjc@google.com>,
 Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
 Vipin Sharma <vipinsh@google.com>, James Houghton <jthoughton@google.com>
References: <20250523001138.3182794-1-seanjc@google.com>
 <20250523001138.3182794-3-seanjc@google.com>
Content-Language: en-US
From: Xiaoyao Li <xiaoyao.li@intel.com>
In-Reply-To: <20250523001138.3182794-3-seanjc@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 5/23/2025 8:11 AM, Sean Christopherson wrote:
> Dynamically allocate the (massive) array of hashed lists used to track
> shadow pages, as the array itself is 32KiB, i.e. is an order-3 allocation
> all on its own, and is *exactly* an order-3 allocation.  Dynamically
> allocating the array will allow allocating "struct kvm" using kvmalloc(),
> and will also allow deferring allocation of the array until it's actually
> needed, i.e. until the first shadow root is allocated.
> 
> Opportunistically use kvmalloc() for the hashed lists, as an order-3
> allocation is (stating the obvious) less likely to fail than an order-4
> allocation, and the overhead of vmalloc() is undesirable given that the
> size of the allocation is fixed.
> 
> Cc: Vipin Sharma <vipinsh@google.com>
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>   arch/x86/include/asm/kvm_host.h |  4 ++--
>   arch/x86/kvm/mmu/mmu.c          | 23 ++++++++++++++++++++++-
>   arch/x86/kvm/x86.c              |  5 ++++-
>   3 files changed, 28 insertions(+), 4 deletions(-)
> 
> diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
> index 330cdcbed1a6..9667d6b929ee 100644
> --- a/arch/x86/include/asm/kvm_host.h
> +++ b/arch/x86/include/asm/kvm_host.h
> @@ -1343,7 +1343,7 @@ struct kvm_arch {
>   	bool has_private_mem;
>   	bool has_protected_state;
>   	bool pre_fault_allowed;
> -	struct hlist_head mmu_page_hash[KVM_NUM_MMU_PAGES];
> +	struct hlist_head *mmu_page_hash;
>   	struct list_head active_mmu_pages;
>   	/*
>   	 * A list of kvm_mmu_page structs that, if zapped, could possibly be
> @@ -2006,7 +2006,7 @@ void kvm_mmu_vendor_module_exit(void);
>   
>   void kvm_mmu_destroy(struct kvm_vcpu *vcpu);
>   int kvm_mmu_create(struct kvm_vcpu *vcpu);
> -void kvm_mmu_init_vm(struct kvm *kvm);
> +int kvm_mmu_init_vm(struct kvm *kvm);
>   void kvm_mmu_uninit_vm(struct kvm *kvm);
>   
>   void kvm_mmu_init_memslot_memory_attributes(struct kvm *kvm,
> diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> index cbc84c6abc2e..41da2cb1e3f1 100644
> --- a/arch/x86/kvm/mmu/mmu.c
> +++ b/arch/x86/kvm/mmu/mmu.c
> @@ -3882,6 +3882,18 @@ static int mmu_alloc_direct_roots(struct kvm_vcpu *vcpu)
>   	return r;
>   }
>   
> +static int kvm_mmu_alloc_page_hash(struct kvm *kvm)
> +{
> +	typeof(kvm->arch.mmu_page_hash) h;

Out of curiousity, it is uncommon in KVM to use typeof() given that we 
know what the type actually is. Is there some specific reason?

anyway, it works.

Reviewed-by: Xiaoyao Li <xiaoyao.li@intel.com>

> +
> +	h = kvcalloc(KVM_NUM_MMU_PAGES, sizeof(*h), GFP_KERNEL_ACCOUNT);
> +	if (!h)
> +		return -ENOMEM;
> +
> +	kvm->arch.mmu_page_hash = h;
> +	return 0;
> +}
> +
>   static int mmu_first_shadow_root_alloc(struct kvm *kvm)
>   {
>   	struct kvm_memslots *slots;
> @@ -6675,13 +6687,19 @@ static void kvm_mmu_zap_all_fast(struct kvm *kvm)
>   		kvm_tdp_mmu_zap_invalidated_roots(kvm, true);
>   }
>   
> -void kvm_mmu_init_vm(struct kvm *kvm)
> +int kvm_mmu_init_vm(struct kvm *kvm)
>   {
> +	int r;
> +
>   	kvm->arch.shadow_mmio_value = shadow_mmio_value;
>   	INIT_LIST_HEAD(&kvm->arch.active_mmu_pages);
>   	INIT_LIST_HEAD(&kvm->arch.possible_nx_huge_pages);
>   	spin_lock_init(&kvm->arch.mmu_unsync_pages_lock);
>   
> +	r = kvm_mmu_alloc_page_hash(kvm);
> +	if (r)
> +		return r;
> +
>   	if (tdp_mmu_enabled)
>   		kvm_mmu_init_tdp_mmu(kvm);
>   
> @@ -6692,6 +6710,7 @@ void kvm_mmu_init_vm(struct kvm *kvm)
>   
>   	kvm->arch.split_desc_cache.kmem_cache = pte_list_desc_cache;
>   	kvm->arch.split_desc_cache.gfp_zero = __GFP_ZERO;
> +	return 0;
>   }
>   
>   static void mmu_free_vm_memory_caches(struct kvm *kvm)
> @@ -6703,6 +6722,8 @@ static void mmu_free_vm_memory_caches(struct kvm *kvm)
>   
>   void kvm_mmu_uninit_vm(struct kvm *kvm)
>   {
> +	kvfree(kvm->arch.mmu_page_hash);
> +
>   	if (tdp_mmu_enabled)
>   		kvm_mmu_uninit_tdp_mmu(kvm);
>   
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index f9f798f286ce..d204ba9368f8 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -12787,7 +12787,9 @@ int kvm_arch_init_vm(struct kvm *kvm, unsigned long type)
>   	if (ret)
>   		goto out;
>   
> -	kvm_mmu_init_vm(kvm);
> +	ret = kvm_mmu_init_vm(kvm);
> +	if (ret)
> +		goto out_cleanup_page_track;
>   
>   	ret = kvm_x86_call(vm_init)(kvm);
>   	if (ret)
> @@ -12840,6 +12842,7 @@ int kvm_arch_init_vm(struct kvm *kvm, unsigned long type)
>   
>   out_uninit_mmu:
>   	kvm_mmu_uninit_vm(kvm);
> +out_cleanup_page_track:
>   	kvm_page_track_cleanup(kvm);
>   out:
>   	return ret;


