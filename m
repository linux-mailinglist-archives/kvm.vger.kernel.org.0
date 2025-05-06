Return-Path: <kvm+bounces-45563-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 0D25FAABD71
	for <lists+kvm@lfdr.de>; Tue,  6 May 2025 10:37:45 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 62E7B4E7D60
	for <lists+kvm@lfdr.de>; Tue,  6 May 2025 08:37:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D718124A076;
	Tue,  6 May 2025 08:37:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="asLGSDaY"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 45476230D2B;
	Tue,  6 May 2025 08:37:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.13
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746520654; cv=none; b=Ih6BBx2h7z3m2iYEBn7F+YzYHY+15PIkQiFSya6jS/gRHgsYh4Iuuh5m9oMjBp9O6ZDq3/PJtYnpiwnyNA1Q0PxFaqN1fwV8oZEtkZ9Ewd08bu11YYgFrmeQpT0f/lotIjP03qWxdZ3WgivuVZTgWcSqC6I+f5pAQYt26Zz7Hjo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746520654; c=relaxed/simple;
	bh=zSJqGXHq0RQCjz4Rg6EG9hUt7MJczyIpvCaunrl+K8Y=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=aThaBmBnYnzRvwiRtQBFEAg0STgtrYtdQ3uruvSgQ0lEoVNzvLbGTnl6FyikGi8ilVac7Lc2pmQZITg3XvNrZexk3AA/o3oevUCeIDaMGoolQWHpuMhinzIB04NChLLDJ3C/2kmURJe4N7EZY+8sNW/sjeBPx9dyRz+w04LkUJc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=asLGSDaY; arc=none smtp.client-ip=192.198.163.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1746520652; x=1778056652;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=zSJqGXHq0RQCjz4Rg6EG9hUt7MJczyIpvCaunrl+K8Y=;
  b=asLGSDaYxJApFL6+rpYu8L5GlAzNTsqPxs0KbYCv84aknSRggbMjaFF1
   1urPt+mpY4N4FbJkyoZ7vrNQ0dg8vS+j58nPmPQSSO9VrYmMGSbauRmcO
   p1MLsGNgdiadMcgn3v9pMa4poL7Ast+PVfGwDkYgOYdghErsd1Dd5wo6s
   tj3FQPphBz5zOrl3+NiO4wkdkLs7vQvp3ykKEf6w/73UfpV0aTEUFLAs9
   uGjf29tFt46fhUG2ObQ+zY9LWIFt5yj0XgiPgEOLvHviIfg9BBbBwYfBJ
   /WyfKjyHbt6PIWTsWkAVsYSqWzNpidHhG1+9HttFz7BFkx2/rYST3PnCV
   A==;
X-CSE-ConnectionGUID: qBHQk0C5RkOImSVawALjIA==
X-CSE-MsgGUID: sh4kdTjNTQOI/3nluIdhDg==
X-IronPort-AV: E=McAfee;i="6700,10204,11424"; a="50824746"
X-IronPort-AV: E=Sophos;i="6.15,265,1739865600"; 
   d="scan'208";a="50824746"
Received: from fmviesa007.fm.intel.com ([10.60.135.147])
  by fmvoesa107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 May 2025 01:37:31 -0700
X-CSE-ConnectionGUID: LLSeDVYTQfSVQFUsKN57MQ==
X-CSE-MsgGUID: 4BAyx0CTQHyr7upWTQCYKg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.15,265,1739865600"; 
   d="scan'208";a="135546274"
Received: from unknown (HELO [10.238.1.183]) ([10.238.1.183])
  by fmviesa007-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 May 2025 01:37:25 -0700
Message-ID: <a3858c57-5de0-45ae-ab33-30e4c233337d@linux.intel.com>
Date: Tue, 6 May 2025 16:37:22 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH 07/21] KVM: TDX: Add a helper for WBINVD on huge pages
 with TD's keyID
To: Yan Zhao <yan.y.zhao@intel.com>
Cc: pbonzini@redhat.com, seanjc@google.com, linux-kernel@vger.kernel.org,
 kvm@vger.kernel.org, x86@kernel.org, rick.p.edgecombe@intel.com,
 dave.hansen@intel.com, kirill.shutemov@intel.com, tabba@google.com,
 ackerleytng@google.com, quic_eberman@quicinc.com, michael.roth@amd.com,
 david@redhat.com, vannapurve@google.com, vbabka@suse.cz, jroedel@suse.de,
 thomas.lendacky@amd.com, pgonda@google.com, zhiquan1.li@intel.com,
 fan.du@intel.com, jun.miao@intel.com, ira.weiny@intel.com,
 isaku.yamahata@intel.com, xiaoyao.li@intel.com, chao.p.peng@intel.com
References: <20250424030033.32635-1-yan.y.zhao@intel.com>
 <20250424030549.305-1-yan.y.zhao@intel.com>
Content-Language: en-US
From: Binbin Wu <binbin.wu@linux.intel.com>
In-Reply-To: <20250424030549.305-1-yan.y.zhao@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit



On 4/24/2025 11:05 AM, Yan Zhao wrote:
> From: Xiaoyao Li <xiaoyao.li@intel.com>
>
> After a guest page is removed from the S-EPT, KVM calls
> tdh_phymem_page_wbinvd_hkid() to execute WBINVD on the page using the TD's
> keyID.
>
> Add a helper function that takes level information to perform WBINVD on a
> huge page.
>
> [Yan: split patch, added a helper, rebased to use struct page]
> Signed-off-by: Xiaoyao Li <xiaoyao.li@intel.com>
> Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
> Signed-off-by: Yan Zhao <yan.y.zhao@intel.com>
> ---
>   arch/x86/kvm/vmx/tdx.c | 24 +++++++++++++++++++-----
>   1 file changed, 19 insertions(+), 5 deletions(-)
>
> diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
> index 69f3140928b5..355b21fc169f 100644
> --- a/arch/x86/kvm/vmx/tdx.c
> +++ b/arch/x86/kvm/vmx/tdx.c
> @@ -1586,6 +1586,23 @@ int tdx_sept_set_private_spte(struct kvm *kvm, gfn_t gfn,
>   	return tdx_mem_page_record_premap_cnt(kvm, level);
>   }
>   
> +static inline u64 tdx_wbinvd_page(struct kvm *kvm, u64 hkid, struct page *page, int level)
> +{
> +	unsigned long nr = KVM_PAGES_PER_HPAGE(level);
> +	unsigned long idx = 0;
> +	u64 err;
> +
> +	while (nr--) {
> +		err = tdh_phymem_page_wbinvd_hkid(hkid, nth_page(page, idx++));
> +
> +		if (KVM_BUG_ON(err, kvm)) {
> +			pr_tdx_error(TDH_PHYMEM_PAGE_WBINVD, err);
> +			return err;
> +		}
> +	}
> +	return err;
> +}
> +
>   static int tdx_sept_drop_private_spte(struct kvm *kvm, gfn_t gfn,
>   				      enum pg_level level, struct page *page)
>   {
> @@ -1625,12 +1642,9 @@ static int tdx_sept_drop_private_spte(struct kvm *kvm, gfn_t gfn,
>   		return -EIO;
>   	}
>   
> -	err = tdh_phymem_page_wbinvd_hkid((u16)kvm_tdx->hkid, page);
> -
> -	if (KVM_BUG_ON(err, kvm)) {
> -		pr_tdx_error(TDH_PHYMEM_PAGE_WBINVD, err);
> +	err = tdx_wbinvd_page(kvm, kvm_tdx->hkid, page, level);
> +	if (err)

It can add unlikely() here.
Also the err is not used after check, maybe it can be combined as:

if (unlikely(tdx_wbinvd_page(kvm, kvm_tdx->hkid, page, level)))
         return -EIO;


>   		return -EIO;
> -	}
>   
>   	tdx_clear_page(page, level);
>   	tdx_unpin(kvm, page);


