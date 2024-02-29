Return-Path: <kvm+bounces-10500-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id C792386CA93
	for <lists+kvm@lfdr.de>; Thu, 29 Feb 2024 14:47:06 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 80CA51F21E06
	for <lists+kvm@lfdr.de>; Thu, 29 Feb 2024 13:47:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B9CC912B17A;
	Thu, 29 Feb 2024 13:46:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="ihItAHfN"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9220386245;
	Thu, 29 Feb 2024 13:46:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709214417; cv=none; b=ufzD84xXDS6g0RMf6TC6hy1eS01aYPPEtrZDVtso6b9a0oM9mHSiy/EBwm1mjbv37J8JeqgUUZPLKLr/lf7UWBHAZG34QGdd5N1qBn0pLCCBkgoyFZR1C/NQEY6l2dhHqnaLUYvroFqoo8zGpJYU8Y/t/lg7/55JE84yCwD/4XA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709214417; c=relaxed/simple;
	bh=IZyPadrgibtW1v1yI21TN031/QLEFzd+im+daJB3PsI=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=WiUkaHh0AMgqpTQNtOTuFXeP2I4XGULyddTTqHtC7S9bHsGX3u48jzV9UsC4ilGq/qmEFmXck6R8uKfU0EAdpeP/6Y94n622/ktQfmSLotKyIePUYHkfvTnxqq94NUc9GrBP17ucTupDawDEJ+IzUCYEJjsGRAhoEDIncDQX2YE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=ihItAHfN; arc=none smtp.client-ip=198.175.65.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1709214414; x=1740750414;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=IZyPadrgibtW1v1yI21TN031/QLEFzd+im+daJB3PsI=;
  b=ihItAHfN5q5nhOXXW7h179LY1wcI1Fbu2oGMVz+wbFZd1UxmWUYVHfxb
   k446LwXC3NixSVVhFvqxsmn4TJcn5mCyyoDAA8EWAO2MOb9tK3pxEg8jr
   8fRo8sY9dgVxFKKjXTwqMF0JwvchgtHyUMxpdBCWlpTabLc4MdJCzZ3j2
   h+mS5rsGztPJ3AyWLBypTrt/aM0Hbg4Vd0INhsDbPBY8h/o27bruhSuDd
   1nGcycG17KAP5tJI8KxoN7YLZGXq/fLiruwuv2YHZfGZyyzCGhkGFv9BL
   Li9nottZAnvOpt/1uIL4bM9mRTcBe1N/tsDxhTKlK5hdQe5ui65Shg9kg
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10998"; a="15124338"
X-IronPort-AV: E=Sophos;i="6.06,194,1705392000"; 
   d="scan'208";a="15124338"
Received: from fmviesa004.fm.intel.com ([10.60.135.144])
  by orvoesa104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Feb 2024 05:46:54 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.06,194,1705392000"; 
   d="scan'208";a="12445275"
Received: from xiaoyaol-hp-g830.ccr.corp.intel.com (HELO [10.125.243.127]) ([10.125.243.127])
  by fmviesa004-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Feb 2024 05:46:52 -0800
Message-ID: <7c0b583b-5e54-4b49-8180-8bfa0f1c67e4@intel.com>
Date: Thu, 29 Feb 2024 21:46:49 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 02/21] KVM: Allow page-sized MMU caches to be initialized
 with custom 64-bit values
Content-Language: en-US
To: Paolo Bonzini <pbonzini@redhat.com>, linux-kernel@vger.kernel.org,
 kvm@vger.kernel.org
Cc: seanjc@google.com, michael.roth@amd.com, isaku.yamahata@intel.com,
 thomas.lendacky@amd.com
References: <20240227232100.478238-1-pbonzini@redhat.com>
 <20240227232100.478238-3-pbonzini@redhat.com>
From: Xiaoyao Li <xiaoyao.li@intel.com>
In-Reply-To: <20240227232100.478238-3-pbonzini@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 2/28/2024 7:20 AM, Paolo Bonzini wrote:
> From: Sean Christopherson <seanjc@google.com>
> 
> Add support to MMU caches for initializing a page with a custom 64-bit
> value, e.g. to pre-fill an entire page table with non-zero PTE values.
> The functionality will be used by x86 to support Intel's TDX, which needs
> to set bit 63 in all non-present PTEs in order to prevent !PRESENT page
> faults from getting reflected into the guest (Intel's EPT Violation #VE
> architecture made the less than brilliant decision of having the per-PTE
> behavior be opt-out instead of opt-in).
> 
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
> Message-Id: <5919f685f109a1b0ebc6bd8fc4536ee94bcc172d.1705965635.git.isaku.yamahata@intel.com>
> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>

Reviewed-by: Xiaoyao Li <xiaoyao.li@intel.com>

> ---
>   include/linux/kvm_types.h |  1 +
>   virt/kvm/kvm_main.c       | 16 ++++++++++++++--
>   2 files changed, 15 insertions(+), 2 deletions(-)
> 
> diff --git a/include/linux/kvm_types.h b/include/linux/kvm_types.h
> index d93f6522b2c3..827ecc0b7e10 100644
> --- a/include/linux/kvm_types.h
> +++ b/include/linux/kvm_types.h
> @@ -86,6 +86,7 @@ struct gfn_to_pfn_cache {
>   struct kvm_mmu_memory_cache {
>   	gfp_t gfp_zero;
>   	gfp_t gfp_custom;
> +	u64 init_value;
>   	struct kmem_cache *kmem_cache;
>   	int capacity;
>   	int nobjs;
> diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
> index 9c99c9373a3e..c9828feb7a1c 100644
> --- a/virt/kvm/kvm_main.c
> +++ b/virt/kvm/kvm_main.c
> @@ -401,12 +401,17 @@ static void kvm_flush_shadow_all(struct kvm *kvm)
>   static inline void *mmu_memory_cache_alloc_obj(struct kvm_mmu_memory_cache *mc,
>   					       gfp_t gfp_flags)
>   {
> +	void *page;
> +
>   	gfp_flags |= mc->gfp_zero;
>   
>   	if (mc->kmem_cache)
>   		return kmem_cache_alloc(mc->kmem_cache, gfp_flags);
> -	else
> -		return (void *)__get_free_page(gfp_flags);
> +
> +	page = (void *)__get_free_page(gfp_flags);
> +	if (page && mc->init_value)
> +		memset64(page, mc->init_value, PAGE_SIZE / sizeof(mc->init_value));
> +	return page;
>   }
>   
>   int __kvm_mmu_topup_memory_cache(struct kvm_mmu_memory_cache *mc, int capacity, int min)
> @@ -421,6 +426,13 @@ int __kvm_mmu_topup_memory_cache(struct kvm_mmu_memory_cache *mc, int capacity,
>   		if (WARN_ON_ONCE(!capacity))
>   			return -EIO;
>   
> +		/*
> +		 * Custom init values can be used only for page allocations,
> +		 * and obviously conflict with __GFP_ZERO.
> +		 */
> +		if (WARN_ON_ONCE(mc->init_value && (mc->kmem_cache || mc->gfp_zero)))
> +			return -EIO;
> +
>   		mc->objects = kvmalloc_array(capacity, sizeof(void *), gfp);
>   		if (!mc->objects)
>   			return -ENOMEM;


