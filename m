Return-Path: <kvm+bounces-12704-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id DEB3488C821
	for <lists+kvm@lfdr.de>; Tue, 26 Mar 2024 16:55:13 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 9422929BF72
	for <lists+kvm@lfdr.de>; Tue, 26 Mar 2024 15:55:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6D71213CFB2;
	Tue, 26 Mar 2024 15:53:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="hvbgC5iM"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A13313C91E;
	Tue, 26 Mar 2024 15:53:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711468392; cv=none; b=Tvx0wAIGHfmZD7TXnCatazMdTccxha4F5Gnht8aHx4dkJrZ5eFq+RbhmxqpV9VcWWNjkvlFRmQ4nxU30U+HhG57G7OSBhQTtG6tX4XP1QJA77vT6jy1ozs0ljbiuhoq1WFkv2XBkmtz24zzyooeV7WDG8a+STYPXU6opwQIPCPc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711468392; c=relaxed/simple;
	bh=/gHfZMctaIYX4V94WcIHgaQofiZzTIaxO8oKJc3Nfv8=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=nDVVMuYrxGA5d9G4dEZWTfGYZD8Hi18dCFPqsCD/niNpJekybdVJhPK1H9oaWX70+9RZ4vSk34QQMSfmAX2sbqy8wqiBYmvRVlw0p1iQvnDEfulmCkLvB37yG3TOjb19n1DUfYXnHVHlPT9MbhaEhaUqbT0Jb+ZR25msW4j0G7E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=hvbgC5iM; arc=none smtp.client-ip=192.198.163.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1711468391; x=1743004391;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=/gHfZMctaIYX4V94WcIHgaQofiZzTIaxO8oKJc3Nfv8=;
  b=hvbgC5iMw0/OTope6ZCnlkxoid74pBIhjxKr8aPaTCbYHhAAFVjYPcFg
   F1UqlZ0sklVMkQw55ey/ql03xrNrWtgBZLBBa8N+aZteX40cKAPC+fNlS
   7KOCiHifMMYdgBq5RHzNnf3ANPl8Q0uHrvmtr9DWeM6W6toSw/VGM6kGs
   WIpk3kTgk7g9fcK1W/EqlFPMq7NGRjwX5bVxAoQEFYYWiJc1ey8+v2u58
   u3KaEjuJp4/o5Rbl+rzRxGeCY/pVM69jGA0YSO9sslJbuMUQlf4FJZmxI
   tMNKJk6Kh/gpOjnLrsGbgZ+btGG96vqAPDttS7T4BCJ430kpt27y6WDZH
   Q==;
X-CSE-ConnectionGUID: MGLy92hDTJCqRGG2HDxrXQ==
X-CSE-MsgGUID: LB6wy9JLSSWI5vMD4JXQAA==
X-IronPort-AV: E=McAfee;i="6600,9927,11025"; a="6357973"
X-IronPort-AV: E=Sophos;i="6.07,156,1708416000"; 
   d="scan'208";a="6357973"
Received: from orviesa002.jf.intel.com ([10.64.159.142])
  by fmvoesa112.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Mar 2024 08:53:09 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,156,1708416000"; 
   d="scan'208";a="47013173"
Received: from binbinwu-mobl.ccr.corp.intel.com (HELO [10.124.242.47]) ([10.124.242.47])
  by orviesa002-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Mar 2024 08:53:06 -0700
Message-ID: <d2ea2f8e-80b1-4dda-bf47-2145859e7463@linux.intel.com>
Date: Tue, 26 Mar 2024 23:53:02 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v19 048/130] KVM: Allow page-sized MMU caches to be
 initialized with custom 64-bit values
To: isaku.yamahata@intel.com
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
 isaku.yamahata@gmail.com, Paolo Bonzini <pbonzini@redhat.com>,
 erdemaktas@google.com, Sean Christopherson <seanjc@google.com>,
 Sagi Shahar <sagis@google.com>, Kai Huang <kai.huang@intel.com>,
 chen.bo@intel.com, hang.yuan@intel.com, tina.zhang@intel.com
References: <cover.1708933498.git.isaku.yamahata@intel.com>
 <9c392612eac4f3c489ad12dd4a4d505cf10d36dc.1708933498.git.isaku.yamahata@intel.com>
From: Binbin Wu <binbin.wu@linux.intel.com>
In-Reply-To: <9c392612eac4f3c489ad12dd4a4d505cf10d36dc.1708933498.git.isaku.yamahata@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 2/26/2024 4:25 PM, isaku.yamahata@intel.com wrote:
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
> ---
>   include/linux/kvm_types.h |  1 +
>   virt/kvm/kvm_main.c       | 16 ++++++++++++++--
>   2 files changed, 15 insertions(+), 2 deletions(-)
>
> diff --git a/include/linux/kvm_types.h b/include/linux/kvm_types.h
> index 9d1f7835d8c1..60c8d5c9eab9 100644
> --- a/include/linux/kvm_types.h
> +++ b/include/linux/kvm_types.h
> @@ -94,6 +94,7 @@ struct gfn_to_pfn_cache {
>   struct kvm_mmu_memory_cache {
>   	gfp_t gfp_zero;
>   	gfp_t gfp_custom;
> +	u64 init_value;
>   	struct kmem_cache *kmem_cache;
>   	int capacity;
>   	int nobjs;
> diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
> index de38f308738e..d399009ef1d7 100644
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

Do we need a static_assert() to make sure mc->init_value is 64bit?

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
>   		mc->objects = kvmalloc_array(sizeof(void *), capacity, gfp);
>   		if (!mc->objects)
>   			return -ENOMEM;


