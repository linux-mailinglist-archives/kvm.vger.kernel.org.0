Return-Path: <kvm+bounces-64331-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [IPv6:2605:f480:58:1:0:1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id C62B7C7FA1C
	for <lists+kvm@lfdr.de>; Mon, 24 Nov 2025 10:29:29 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 5DE894E4E15
	for <lists+kvm@lfdr.de>; Mon, 24 Nov 2025 09:28:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F2AFB2F6199;
	Mon, 24 Nov 2025 09:26:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="BdsojQxA"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5CE332F5A0C;
	Mon, 24 Nov 2025 09:26:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763976416; cv=none; b=HXkllp7tHUAbGBsqKTH9cDz3xsfNlq8EObkPtPDQj5HAabfxp9LhQzIxG8p77J+O/wd/js3JkmVpIIfkZpNCf/Unnq20EWCJnzGdfAfnyQDb5a8K66n8/MA0Gkk/wKkqfDFTZApUp84NJ1RHMUduyJfzol2QbvErFzQuSJ44G4c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763976416; c=relaxed/simple;
	bh=9SztITqQ4D3qybTDRMRxELb+sO2S4C65ekZnrR7/ltU=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:Cc:From:
	 In-Reply-To:Content-Type; b=rZ8EHFVSWPn9S04w7mPR6komJY03US6SXfbost3nFgfNywrQ9eNTyd2nOT7hp+Yt1f0ShK7KiDQzFXQp/7djxIll5tyIWQiXfN5uNhFIhy76YZSwsa8Hs4Gw7XAD6fJ6ytWIEFs2BHVMlF/N4kWMv/3CIK4URCMFSfb3pi6MBHs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=pass smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=BdsojQxA; arc=none smtp.client-ip=192.198.163.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1763976414; x=1795512414;
  h=message-id:date:mime-version:subject:to:references:cc:
   from:in-reply-to:content-transfer-encoding;
  bh=9SztITqQ4D3qybTDRMRxELb+sO2S4C65ekZnrR7/ltU=;
  b=BdsojQxAGHMNY1XIAQAMT15NtO9qgYK+FfriTERHgfK0gfKM+WHgxQCA
   GtdD+kLvTGl7G69xMD65SzsRdzbJa1WLqR8Y8zUWUvSHsGvrIOnar2YOs
   aAbFISMhEDiA9tL8xyCXkecF9lfPDiqazTaq0Gd5tAufVDgUiQL/QoZie
   9uKypjdfrmsl4hwpvOCNQzHCCYSyQhxL4qfudJ9NhMfRl0HIlCTJNeMV7
   IKRYA7j/vaw/Bb7KTFXJKTFQsG1O8dmKmXqHAjViMscQUHtOJQjOVHhtr
   L6fy/38M4a5LfoLE7bCR2214PcLArPim2bHtzWt+qdSB/6w3rDlfF9Zxi
   g==;
X-CSE-ConnectionGUID: 01ka626SQmOOfupOz5HZNw==
X-CSE-MsgGUID: 7s7RIF9nSsq68JUYg8wDdg==
X-IronPort-AV: E=McAfee;i="6800,10657,11622"; a="66012221"
X-IronPort-AV: E=Sophos;i="6.20,222,1758610800"; 
   d="scan'208";a="66012221"
Received: from fmviesa001.fm.intel.com ([10.60.135.141])
  by fmvoesa108.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Nov 2025 01:26:53 -0800
X-CSE-ConnectionGUID: V3jA9flGQ/mn3WvLx5K9Ag==
X-CSE-MsgGUID: X54GqQKRTIqJ3wxYtORRuQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.20,222,1758610800"; 
   d="scan'208";a="223251405"
Received: from yinghaoj-desk.ccr.corp.intel.com (HELO [10.238.1.225]) ([10.238.1.225])
  by smtpauth.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Nov 2025 01:26:48 -0800
Message-ID: <8eba534b-7fcf-43b2-a304-091993faef1c@linux.intel.com>
Date: Mon, 24 Nov 2025 17:26:46 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 03/16] x86/virt/tdx: Simplify tdmr_get_pamt_sz()
To: Rick Edgecombe <rick.p.edgecombe@intel.com>
References: <20251121005125.417831-1-rick.p.edgecombe@intel.com>
 <20251121005125.417831-4-rick.p.edgecombe@intel.com>
Content-Language: en-US
Cc: bp@alien8.de, chao.gao@intel.com, dave.hansen@intel.com,
 isaku.yamahata@intel.com, kai.huang@intel.com, kas@kernel.org,
 kvm@vger.kernel.org, linux-coco@lists.linux.dev,
 linux-kernel@vger.kernel.org, mingo@redhat.com, pbonzini@redhat.com,
 seanjc@google.com, tglx@linutronix.de, vannapurve@google.com,
 x86@kernel.org, yan.y.zhao@intel.com, xiaoyao.li@intel.com,
 binbin.wu@intel.com
From: Binbin Wu <binbin.wu@linux.intel.com>
In-Reply-To: <20251121005125.417831-4-rick.p.edgecombe@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit



On 11/21/2025 8:51 AM, Rick Edgecombe wrote:
> For each memory region that the TDX module might use (TDMR), the three
> separate PAMT allocations are needed. One for each supported page size
> (1GB, 2MB, 4KB). These store information on each page in the TDMR. In
> Linux, they are allocated out of one physically contiguous block, in order
> to more efficiently use some internal TDX module book keeping resources.
> So some simple math is needed to break the single large allocation into
> three smaller allocations for each page size.
>
> There are some commonalities in the math needed to calculate the base and
> size for each smaller allocation, and so an effort was made to share logic
> across the three. Unfortunately doing this turned out naturally tortured,
> with a loop iterating over the three page sizes, only to call into a
> function with a case statement for each page size. In the future Dynamic
> PAMT will add more logic that is special to the 4KB page size, making the
> benefit of the math sharing even more questionable.
>
> Three is not a very high number, so get rid of the loop and just duplicate
> the small calculation three times. In doing so, setup for future Dynamic
> PAMT changes and drop a net 33 lines of code.
>
> Since the loop that iterates over it is gone, further simplify the code by
> dropping the array of intermediate size and base storage. Just store the
> values to their final locations. Accept the small complication of having
> to clear tdmr->pamt_4k_base in the error path, so that tdmr_do_pamt_func()
> will not try to operate on the TDMR struct when attempting to free it.
>
> Signed-off-by: Rick Edgecombe <rick.p.edgecombe@intel.com>

Reviewed-by: Binbin Wu <binbin.wu@linux.intel.com>

One nit below.

[...]
> @@ -535,26 +518,18 @@ static int tdmr_set_up_pamt(struct tdmr_info *tdmr,
>   	 * in overlapped TDMRs.
>   	 */
>   	pamt = alloc_contig_pages(tdmr_pamt_size >> PAGE_SHIFT, GFP_KERNEL,
> -			nid, &node_online_map);
> -	if (!pamt)
> +				  nid, &node_online_map);
> +	if (!pamt) {
> +		/*
> +		 * tdmr->pamt_4k_base is zero so the
> +		 * error path will skip freeing.
> +		 */
>   		return -ENOMEM;
Nit:
Do you think it's OK to move the comment up so to avoid multiple lines of
comments as well as the curly braces?

         /* tdmr->pamt_4k_base is zero so the error path will skip freeing. */
         if (!pamt)
             return -ENOMEM;

> -
> -	/*
> -	 * Break the contiguous allocation back up into the
> -	 * individual PAMTs for each page size.
> -	 */
> -	tdmr_pamt_base = page_to_pfn(pamt) << PAGE_SHIFT;
> -	for (pgsz = TDX_PS_4K; pgsz < TDX_PS_NR; pgsz++) {
> -		pamt_base[pgsz] = tdmr_pamt_base;
> -		tdmr_pamt_base += pamt_size[pgsz];
>   	}
>   
> -	tdmr->pamt_4k_base = pamt_base[TDX_PS_4K];
> -	tdmr->pamt_4k_size = pamt_size[TDX_PS_4K];
> -	tdmr->pamt_2m_base = pamt_base[TDX_PS_2M];
> -	tdmr->pamt_2m_size = pamt_size[TDX_PS_2M];
> -	tdmr->pamt_1g_base = pamt_base[TDX_PS_1G];
> -	tdmr->pamt_1g_size = pamt_size[TDX_PS_1G];
> +	tdmr->pamt_4k_base = page_to_phys(pamt);
> +	tdmr->pamt_2m_base = tdmr->pamt_4k_base + tdmr->pamt_4k_size;
> +	tdmr->pamt_1g_base = tdmr->pamt_2m_base + tdmr->pamt_2m_size;
>   
>   	return 0;
>   }
>
[...]

