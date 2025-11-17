Return-Path: <kvm+bounces-63299-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [IPv6:2605:f480:58:1:0:1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id 2ED9AC62100
	for <lists+kvm@lfdr.de>; Mon, 17 Nov 2025 03:10:03 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 743B84E50F4
	for <lists+kvm@lfdr.de>; Mon, 17 Nov 2025 02:10:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 10D57240611;
	Mon, 17 Nov 2025 02:09:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="a4sDHotu"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 01263748F;
	Mon, 17 Nov 2025 02:09:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763345393; cv=none; b=HDKRRCTfQBQ+EQnGsWqu03sEe06ccFcB6XGOEDsYO1dMW4pWJQingSvT7jm0k9dc5kuZRnDepnrGkoCpNlFmTaU6LfdWWHBsRqFwtnMoG31/HbfKwwmPJIEqtTl096QL9OaHWTBZz6O1zleCzzpy3cRQ7zbkF7SKpg7FFtVNxg4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763345393; c=relaxed/simple;
	bh=01EJtHBvN5NOGbytBZDVb6hqdz2+Ua20B4q9By1pALQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=DliYkR7w9IMFCo/bDisit9x7ZAB5iD+EmIxeDPnIcAseqw65LGtvP3v1kafT6Pn2lu2GschKZ59VsStwBgDcBkh4hL07Ut1mtHi+heZ/qhd1TsAQ9KU04ga5Fyzs/2peWky6iYqypr6jFtYcW0NkF05MlqDITnLPFbF8LPa4XfY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=pass smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=a4sDHotu; arc=none smtp.client-ip=192.198.163.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1763345391; x=1794881391;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=01EJtHBvN5NOGbytBZDVb6hqdz2+Ua20B4q9By1pALQ=;
  b=a4sDHotuzhWnihXfEoG3+N/HY10YtjmKmIa4yE+bQmYnuaoUnYNPxTOw
   rEH5OnVScY+ZKTwDdiCUfHgm5v9DTiDacoJoBvRBseF14aFAPAGlhORvl
   rBSYcS4kOiQ4fcouVbaBMQdnhw4CNl96vfaYD7Uxs5pcgB9K8YWfGghHy
   OU+J37X8U/NcZeB5k+nYh3DyazWjAZ+JII7zpFIZRzs6675xGqggB2lOy
   h/ZE7ok/jaKElLPQkUi9vuYF6UoCFivP597sdFi4qWbVVUhSra0bu/CYz
   jTv5R3Q6Xhn1eTX1BOXSCuW2oHa1aNIEDaGk1G2tArudCMwengGyTabpD
   A==;
X-CSE-ConnectionGUID: 6yFsmIiSQO+ziLfZDCt0bQ==
X-CSE-MsgGUID: t12wkgFaS4+dKs89S1MqrQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11615"; a="75942729"
X-IronPort-AV: E=Sophos;i="6.19,310,1754982000"; 
   d="scan'208";a="75942729"
Received: from fmviesa005.fm.intel.com ([10.60.135.145])
  by fmvoesa105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Nov 2025 18:09:50 -0800
X-CSE-ConnectionGUID: sQXUL/OkSbeEzO7bjoa/0Q==
X-CSE-MsgGUID: SiJVdf0DQq6nsUKyWoV0Cg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.19,310,1754982000"; 
   d="scan'208";a="194643946"
Received: from fhe5-mobl.ccr.corp.intel.com (HELO [10.124.241.55]) ([10.124.241.55])
  by fmviesa005-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Nov 2025 18:09:44 -0800
Message-ID: <b4cc4097-67fd-4d31-bf91-ef80e4fc7f61@linux.intel.com>
Date: Mon, 17 Nov 2025 10:09:42 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH v2 05/23] x86/tdx: Enhance tdh_phymem_page_reclaim()
 to support huge pages
To: Yan Zhao <yan.y.zhao@intel.com>
Cc: seanjc@google.com, pbonzini@redhat.com, linux-kernel@vger.kernel.org,
 kvm@vger.kernel.org, x86@kernel.org, rick.p.edgecombe@intel.com,
 dave.hansen@intel.com, kas@kernel.org, tabba@google.com,
 ackerleytng@google.com, quic_eberman@quicinc.com, michael.roth@amd.com,
 david@redhat.com, vannapurve@google.com, vbabka@suse.cz,
 thomas.lendacky@amd.com, pgonda@google.com, zhiquan1.li@intel.com,
 fan.du@intel.com, jun.miao@intel.com, ira.weiny@intel.com,
 isaku.yamahata@intel.com, xiaoyao.li@intel.com, chao.p.peng@intel.com
References: <20250807093950.4395-1-yan.y.zhao@intel.com>
 <20250807094228.4509-1-yan.y.zhao@intel.com>
Content-Language: en-US
From: Binbin Wu <binbin.wu@linux.intel.com>
In-Reply-To: <20250807094228.4509-1-yan.y.zhao@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit



On 8/7/2025 5:42 PM, Yan Zhao wrote:
[...]
> diff --git a/arch/x86/virt/vmx/tdx/tdx.c b/arch/x86/virt/vmx/tdx/tdx.c
> index 64219c659844..9ed585bde062 100644
> --- a/arch/x86/virt/vmx/tdx/tdx.c
> +++ b/arch/x86/virt/vmx/tdx/tdx.c
> @@ -1966,19 +1966,27 @@ EXPORT_SYMBOL_GPL(tdh_vp_init);
>    * So despite the names, they must be interpted specially as described by the spec. Return
>    * them only for error reporting purposes.
>    */
> -u64 tdh_phymem_page_reclaim(struct page *page, u64 *tdx_pt, u64 *tdx_owner, u64 *tdx_size)
> +u64 tdh_phymem_page_reclaim(struct folio *folio, unsigned long start_idx, unsigned long npages,
> +			    u64 *tdx_pt, u64 *tdx_owner, u64 *tdx_size)
>   {
> +	struct page *start = folio_page(folio, start_idx);
>   	struct tdx_module_args args = {
> -		.rcx = page_to_phys(page),
> +		.rcx = page_to_phys(start),
>   	};
>   	u64 ret;
>   
> +	if (start_idx + npages > folio_nr_pages(folio))
> +		return TDX_OPERAND_INVALID;
> +
>   	ret = seamcall_ret(TDH_PHYMEM_PAGE_RECLAIM, &args);
>   
>   	*tdx_pt = args.rcx;
>   	*tdx_owner = args.rdx;
>   	*tdx_size = args.r8;
>   
> +	if (npages != (1 << (*tdx_size) * PTE_SHIFT))
> +		return TDX_SW_ERROR;

Nit:

The size check here is to  make sure the reclamation on the correct level,
however, tdx_size may not be updated if some other error occurs first.
Do you think it's better to check 'ret' first before returning TDX_SW_ERROR?
Otherwise, the error code provided by the TDX module, which may be helpful for
debugging,  will be buried under TDX_SW_ERROR.


> +
>   	return ret;
>   }
>   EXPORT_SYMBOL_GPL(tdh_phymem_page_reclaim);


