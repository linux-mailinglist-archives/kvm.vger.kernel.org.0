Return-Path: <kvm+bounces-56530-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 5165AB3F288
	for <lists+kvm@lfdr.de>; Tue,  2 Sep 2025 04:56:46 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 0CDF34837B9
	for <lists+kvm@lfdr.de>; Tue,  2 Sep 2025 02:56:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 890612E040E;
	Tue,  2 Sep 2025 02:56:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="AiBmQhjV"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8974B22688C;
	Tue,  2 Sep 2025 02:56:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.9
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756781796; cv=none; b=iOOHejmbqOm3CnRoz4dikgyKVE9Y9Gn9PQ2H/w2WD+GbcQRPaoWIacv18k4PNedE4x+NQce5yPYpSay5BglOSUptIIRiu5zTR3KeMg3EX8Ngesy52abjcWX/VZpgs4PGRV9m9E05aOmJun3RURjT2g8r463FVcC2wFPjVGfZ0j4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756781796; c=relaxed/simple;
	bh=nwlBC3m1EAeEwogxv/iS1BYOFM0m1DR1LuuecJJPrGc=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=faBvXYxqNrw9gw10m59ZVztEq+HsrOBoyiej1o7Fwsdei0zMQFKqkr0AnLYFg3zIbhvJvIy0vuADtg7yTH94xLTjlOilVLu2d0+W0SdGp2Um3XzED6l1UJNfywGwlG8Oq/4h0SKtoHXWWPti2CM2OdufXsGCPHHBm3Y5+0zyDKg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=AiBmQhjV; arc=none smtp.client-ip=198.175.65.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1756781795; x=1788317795;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=nwlBC3m1EAeEwogxv/iS1BYOFM0m1DR1LuuecJJPrGc=;
  b=AiBmQhjVfxXc014wIZI+2JT0O3s9nFBq0nJJoU5Sc13kO9vH2CEtGZH0
   4YZfWRC7Y3lUTC2edWlX6bEnlQBLYF5MQK1PaYnifxcpxRXYI/XvkpMNh
   cd6Z0JH6UhJdVS0T0mSrrzKLCYXJy7LEyKqcXudRdOJkMalFm2XS8D2st
   pA62rwszZ0TW58qEpnaLv1x3FnqnHps/VgY8ekbjD4XO6pMInZmHN3Uxo
   1VEeyFtkLzRAPOELRY+x56LbfIz1Rldh93IQka+XWj5On5aBr7QnDuiqj
   Z5wvLgSU1KpWZON1KfFa409PLg7LbScTSy1y15omWVlPYlL8PK37dkNRt
   A==;
X-CSE-ConnectionGUID: xmyysTn1Rn6oyPbHMDRCtg==
X-CSE-MsgGUID: xbRTPlgtR0O5NnTakAEXcg==
X-IronPort-AV: E=McAfee;i="6800,10657,11531"; a="81620347"
X-IronPort-AV: E=Sophos;i="6.17,312,1747724400"; 
   d="scan'208";a="81620347"
Received: from fmviesa002.fm.intel.com ([10.60.135.142])
  by orvoesa101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Sep 2025 19:56:34 -0700
X-CSE-ConnectionGUID: RKL+S6FMSU+vxaERIBsJng==
X-CSE-MsgGUID: 1TN2TF0gSkiYbPObtqUUUQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.18,230,1751266800"; 
   d="scan'208";a="194797416"
Received: from binbinwu-mobl.ccr.corp.intel.com (HELO [10.124.233.111]) ([10.124.233.111])
  by fmviesa002-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Sep 2025 19:56:27 -0700
Message-ID: <04d6d306-b495-428f-ac3a-44057fd6ccfc@linux.intel.com>
Date: Tue, 2 Sep 2025 10:56:25 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH v2 04/23] KVM: TDX: Introduce tdx_clear_folio() to
 clear huge pages
To: Yan Zhao <yan.y.zhao@intel.com>
Cc: pbonzini@redhat.com, seanjc@google.com, linux-kernel@vger.kernel.org,
 kvm@vger.kernel.org, x86@kernel.org, rick.p.edgecombe@intel.com,
 dave.hansen@intel.com, kas@kernel.org, tabba@google.com,
 ackerleytng@google.com, quic_eberman@quicinc.com, michael.roth@amd.com,
 david@redhat.com, vannapurve@google.com, vbabka@suse.cz,
 thomas.lendacky@amd.com, pgonda@google.com, zhiquan1.li@intel.com,
 fan.du@intel.com, jun.miao@intel.com, ira.weiny@intel.com,
 isaku.yamahata@intel.com, xiaoyao.li@intel.com, chao.p.peng@intel.com
References: <20250807093950.4395-1-yan.y.zhao@intel.com>
 <20250807094214.4495-1-yan.y.zhao@intel.com>
Content-Language: en-US
From: Binbin Wu <binbin.wu@linux.intel.com>
In-Reply-To: <20250807094214.4495-1-yan.y.zhao@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 8/7/2025 5:42 PM, Yan Zhao wrote:
> After removing or reclaiming a guest private page or a control page from a
> TD, zero the physical page using movdir64b(), enabling the kernel to reuse
> the pages.
>
> Introduce the function tdx_clear_folio() to zero out physical memory using
> movdir64b(), starting from the page at "start_idx" within a "folio" and
> spanning "npages" contiguous PFNs.
>
> Convert tdx_clear_page() to be a helper function to facilitate the
> zeroing of 4KB pages.

I think this sentence is outdated?

>
> Signed-off-by: Xiaoyao Li <xiaoyao.li@intel.com>
> Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
> Signed-off-by: Yan Zhao <yan.y.zhao@intel.com>
> ---
> RFC v2:
> - Add tdx_clear_folio().
> - Drop inner loop _tdx_clear_page() and move __mb() outside of the loop.
>    (Rick)
> - Use C99-style definition of variables inside a for loop.
> - Note: [1] also changes tdx_clear_page(). RFC v2 is not based on [1] now.
>
> [1] https://lore.kernel.org/all/20250724130354.79392-2-adrian.hunter@intel.com
>
> RFC v1:
> - split out, let tdx_clear_page() accept level.
> ---
>   arch/x86/kvm/vmx/tdx.c | 22 ++++++++++++++++------
>   1 file changed, 16 insertions(+), 6 deletions(-)
>
> diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
> index 8eaf8431c5f1..4fabefb27135 100644
> --- a/arch/x86/kvm/vmx/tdx.c
> +++ b/arch/x86/kvm/vmx/tdx.c
> @@ -277,18 +277,21 @@ static inline void tdx_disassociate_vp(struct kvm_vcpu *vcpu)
>   	vcpu->cpu = -1;
>   }
>   
> -static void tdx_clear_page(struct page *page)
> +static void tdx_clear_folio(struct folio *folio, unsigned long start_idx,
> +			    unsigned long npages)
>   {
>   	const void *zero_page = (const void *) page_to_virt(ZERO_PAGE(0));
> -	void *dest = page_to_virt(page);
> -	unsigned long i;
>   
>   	/*
>   	 * The page could have been poisoned.  MOVDIR64B also clears
>   	 * the poison bit so the kernel can safely use the page again.
>   	 */
> -	for (i = 0; i < PAGE_SIZE; i += 64)
> -		movdir64b(dest + i, zero_page);
> +	for (unsigned long j = 0; j < npages; j++) {
> +		void *dest = page_to_virt(folio_page(folio, start_idx + j));
> +
> +		for (unsigned long i = 0; i < PAGE_SIZE; i += 64)
> +			movdir64b(dest + i, zero_page);
> +	}
>   	/*
>   	 * MOVDIR64B store uses WC buffer.  Prevent following memory reads
>   	 * from seeing potentially poisoned cache.
> @@ -296,6 +299,13 @@ static void tdx_clear_page(struct page *page)
>   	__mb();
>   }
>   
> +static inline void tdx_clear_page(struct page *page)
No need to tag a local static function with "inline".

> +{
> +	struct folio *folio = page_folio(page);
> +
> +	tdx_clear_folio(folio, folio_page_idx(folio, page), 1);

This is strange at my first thought.
And then I realized that it is to avoid unnecessary memory barrier.

No better idea so far.
> +}
> +
>   static void tdx_no_vcpus_enter_start(struct kvm *kvm)
>   {
>   	struct kvm_tdx *kvm_tdx = to_kvm_tdx(kvm);
> @@ -1736,7 +1746,7 @@ static int tdx_sept_drop_private_spte(struct kvm *kvm, gfn_t gfn,
>   		pr_tdx_error(TDH_PHYMEM_PAGE_WBINVD, err);
>   		return -EIO;
>   	}
> -	tdx_clear_page(page);
> +	tdx_clear_folio(folio, folio_page_idx(folio, page), KVM_PAGES_PER_HPAGE(level));
>   	tdx_pamt_put(page, level);
>   	tdx_unpin(kvm, page);
>   	return 0;


