Return-Path: <kvm+bounces-10876-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 3DC82871618
	for <lists+kvm@lfdr.de>; Tue,  5 Mar 2024 07:56:10 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id EBA9B286CB4
	for <lists+kvm@lfdr.de>; Tue,  5 Mar 2024 06:56:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 318297BAFF;
	Tue,  5 Mar 2024 06:55:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="cvy3S4ln"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A4DFC43AC5;
	Tue,  5 Mar 2024 06:55:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.17
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709621753; cv=none; b=BL/yYZLwiMiOSpao8EUNvMbWCBL4TeAaGqLnw5zAGcOT0OJ5umjwjRRCrNxvcO4SYsNgI2bIMC4ts4C/dLnTRx22alCugIbsFVY0uV8bQME+vLvifEWHg9FvZ3T6s+NKkD0ne933S1WQ5OJwSdFzr+sLPBDnKdqoXfVCYMhjp8A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709621753; c=relaxed/simple;
	bh=l5gLoZUsr+5xcG/0VUQfe6qG8NXwhnl1SQb/YulRLgo=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=eANaRHcGYJulqphbwvC2v9GIUYoYFe8CvwZAsZKLj57XSan+7Kfmam11McIDgOeF7uap/tdwi0oh8N0bnWH9t9O9IxKGTkIqbjq7qzdr/ccyry+QogCEKl6Av/KEAP5Yaq4vdaVfjV9yAO3LYq89G4jEwsrwkC+DboDI2KvT3xw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=cvy3S4ln; arc=none smtp.client-ip=198.175.65.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1709621751; x=1741157751;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=l5gLoZUsr+5xcG/0VUQfe6qG8NXwhnl1SQb/YulRLgo=;
  b=cvy3S4lnvR1Gq7gDozw/DX+ml7GpU/tobGlFYVUMgS65TkCpaN3AkXrP
   CrT20ozBlR8Zd+dWA5t31fuxL39n5oN4smQDzztRmMf8/7GLqFPEVPIEZ
   CS6jzgSyEvpGpmetuwib/Gzmx9YuGMOBFp1YqSSPw13XaJtKolaicmiSX
   DGIdO/3b5LrTpsYoHGKqjyCESz39yW41zIKkRHuGY/FlDjHZ2QwzdXYN0
   VQadFyNu3lolx9vlXTfn9IQsb0eKuxuPr+2s19eS4SLrZauINqxclLdFQ
   nSlLXs7ADT1uYyUgSy/ydAfwAt6lqHNrdPPN4Gk0LyGDX7GaiBNuoHZDz
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,11003"; a="4313734"
X-IronPort-AV: E=Sophos;i="6.06,205,1705392000"; 
   d="scan'208";a="4313734"
Received: from orviesa006.jf.intel.com ([10.64.159.146])
  by orvoesa109.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Mar 2024 22:55:51 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.06,205,1705392000"; 
   d="scan'208";a="9684219"
Received: from binbinwu-mobl.ccr.corp.intel.com (HELO [10.238.8.218]) ([10.238.8.218])
  by orviesa006-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Mar 2024 22:55:50 -0800
Message-ID: <6bd61607-9491-4517-8fc8-8d61d9416cab@linux.intel.com>
Date: Tue, 5 Mar 2024 14:55:46 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 02/21] KVM: Allow page-sized MMU caches to be initialized
 with custom 64-bit values
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: linux-kernel@vger.kernel.org, kvm@vger.kernel.org, seanjc@google.com,
 michael.roth@amd.com, isaku.yamahata@intel.com, thomas.lendacky@amd.com
References: <20240227232100.478238-1-pbonzini@redhat.com>
 <20240227232100.478238-3-pbonzini@redhat.com>
From: Binbin Wu <binbin.wu@linux.intel.com>
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
> ---
>   include/linux/kvm_types.h |  1 +
>   virt/kvm/kvm_main.c       | 16 ++++++++++++++--
>   2 files changed, 15 insertions(+), 2 deletions(-)

Reviewed-by: Binbin Wu <binbin.wu@linux.intel.com>

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


