Return-Path: <kvm+bounces-64452-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ams.mirrors.kernel.org (ams.mirrors.kernel.org [IPv6:2a01:60a::1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id 47CE4C830C7
	for <lists+kvm@lfdr.de>; Tue, 25 Nov 2025 02:50:44 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ams.mirrors.kernel.org (Postfix) with ESMTPS id 6389134A9F6
	for <lists+kvm@lfdr.de>; Tue, 25 Nov 2025 01:50:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3CAFD19F48D;
	Tue, 25 Nov 2025 01:50:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="K20rhK46"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.21])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 85EAB17A586;
	Tue, 25 Nov 2025 01:50:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.21
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764035424; cv=none; b=mOCJP1O7ZCY9iVnZuFNS+eNaPufAhKFrO8n96juEW/SIkSHfKlGGlVz7BrgYTaR0mq7jMTy5msVoOjcF5WGtaWm/99F6RukIUHmXo1DWT2x8CS1WNluBmfYnm62MwYKm7fllYQ/tjW+FdrN2tEKLcd6QIs/vkuJPTS9QeuXluwc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764035424; c=relaxed/simple;
	bh=UDRu0hzZEvxvPSW9YvleBJsVvQ54Ad1fInxtjRIFpM4=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=YEztAkrkHaCixTZDQhBzdEytb8EyrUC5ih3tc5K541noJdZbI7zrDUD/HzGzCavhxWM562y0YZ/vaewQr1Ij5BDbGD+PzLmVI40GIGQxOyv4sWiRp2r64yKCZ1f93QVjP0rhZf+9j+CNX0snj/2v4/DP8VND+kxgrx9kpKzblrQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=pass smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=K20rhK46; arc=none smtp.client-ip=198.175.65.21
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1764035422; x=1795571422;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=UDRu0hzZEvxvPSW9YvleBJsVvQ54Ad1fInxtjRIFpM4=;
  b=K20rhK46iKbiYI3Qhq+g1T2hapm3GT/PVFGXc/KNSooDnN9Pe3o4tAmV
   8iMDssTL6eoNFJcYEp0M7nZTOeqdcaDWD6Cncr5fgJTWJNl5oVRKWEGUB
   GV7L8htYR89LPjIapd8HYWBzYOHiohdTIz4tV6j0ji1SwMiBRc21EkVRH
   oFW9UCWji8Z7lJ4yz5cpIXqxk5KVhiLyg7f8E3gRBVDMehGarE15yc00U
   pUPL1YedRYGWtkJz+IkZJFIrchgs7SR3M8pJDlEvdGDHx65LnWzauWcwU
   P/GPQYW3lkMaMLoqz+tfsoVbiLw7d2xL0MWRscfXTP+ZaURMlI9Pp85EW
   w==;
X-CSE-ConnectionGUID: 6U/pbfZmTCSGh1XDipvDCQ==
X-CSE-MsgGUID: 5y5I9sUzQMOI1mrDzaiiDA==
X-IronPort-AV: E=McAfee;i="6800,10657,11623"; a="65992913"
X-IronPort-AV: E=Sophos;i="6.20,224,1758610800"; 
   d="scan'208";a="65992913"
Received: from orviesa009.jf.intel.com ([10.64.159.149])
  by orvoesa113.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Nov 2025 17:50:22 -0800
X-CSE-ConnectionGUID: 7wwxNJRZRXStGBx0pX5fqA==
X-CSE-MsgGUID: ERzQqdnoSBKbzPXqnxvzPQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.20,224,1758610800"; 
   d="scan'208";a="192306348"
Received: from yinghaoj-desk.ccr.corp.intel.com (HELO [10.238.1.225]) ([10.238.1.225])
  by orviesa009-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Nov 2025 17:50:18 -0800
Message-ID: <51dc2009-ff3e-4419-9dab-b46db7b2e15d@linux.intel.com>
Date: Tue, 25 Nov 2025 09:50:15 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 04/16] x86/virt/tdx: Allocate page bitmap for Dynamic
 PAMT
To: Rick Edgecombe <rick.p.edgecombe@intel.com>
Cc: bp@alien8.de, chao.gao@intel.com, dave.hansen@intel.com,
 isaku.yamahata@intel.com, kai.huang@intel.com, kas@kernel.org,
 kvm@vger.kernel.org, linux-coco@lists.linux.dev,
 linux-kernel@vger.kernel.org, mingo@redhat.com, pbonzini@redhat.com,
 seanjc@google.com, tglx@linutronix.de, vannapurve@google.com,
 x86@kernel.org, yan.y.zhao@intel.com, xiaoyao.li@intel.com,
 binbin.wu@intel.com
References: <20251121005125.417831-1-rick.p.edgecombe@intel.com>
 <20251121005125.417831-5-rick.p.edgecombe@intel.com>
Content-Language: en-US
From: Binbin Wu <binbin.wu@linux.intel.com>
In-Reply-To: <20251121005125.417831-5-rick.p.edgecombe@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 11/21/2025 8:51 AM, Rick Edgecombe wrote:
> From: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
>
> The Physical Address Metadata Table (PAMT) holds TDX metadata for physical
> memory and must be allocated by the kernel during TDX module
> initialization.
>
> The exact size of the required PAMT memory is determined by the TDX module
> and may vary between TDX module versions. Currently it is approximately
> 0.4% of the system memory. This is a significant commitment, especially if
> it is not known upfront whether the machine will run any TDX guests.
>
> For normal PAMT, each memory region that the TDX module might use (TDMR)
> needs three separate PAMT allocations. One for each supported page size
> (1GB, 2MB, 4KB).
>
> At a high level, Dynamic PAMT still has the 1GB and 2MB levels allocated
> on TDX module initialization, but the 4KB level allocated dynamically at
> TD runtime. However, in the details, the TDX module still needs some per
> 4KB page data. The TDX module exposed how many bits per page need to be
> allocated (currently it is 1). The bits-per-page value can then be used to
> calculate the size to pass in place of the 4KB allocations in the TDMR,
> which TDX specs call "PAMT_PAGE_BITMAP".
>
> So in effect, Dynamic PAMT just needs a different (smaller) size
> allocation for the 4KB level part of the allocation. Although it is
> functionally something different, it is passed in the same way the 4KB page
> size PAMT allocation is.
>
> Begin to implement Dynamic PAMT in the kernel by reading the bits-per-page
> needed for Dynamic PAMT. Calculate the size needed for the bitmap,
> and use it instead of the 4KB size determined for normal PAMT, in the case
> of Dynamic PAMT. In doing so, reduce the static allocations to
> approximately 0.004%, a 100x improvement.
>
> Signed-off-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
> [Enhanced log]
> Signed-off-by: Rick Edgecombe <rick.p.edgecombe@intel.com>

Reviewed-by: Binbin Wu <binbin.wu@linux.intel.com>

One nit below.

[...]
> diff --git a/arch/x86/virt/vmx/tdx/tdx_global_metadata.c b/arch/x86/virt/vmx/tdx/tdx_global_metadata.c
> index 13ad2663488b..00ab0e550636 100644
> --- a/arch/x86/virt/vmx/tdx/tdx_global_metadata.c
> +++ b/arch/x86/virt/vmx/tdx/tdx_global_metadata.c
> @@ -33,6 +33,13 @@ static int get_tdx_sys_info_tdmr(struct tdx_sys_info_tdmr *sysinfo_tdmr)
>   		sysinfo_tdmr->pamt_2m_entry_size = val;
>   	if (!ret && !(ret = read_sys_metadata_field(0x9100000100000012, &val)))
>   		sysinfo_tdmr->pamt_1g_entry_size = val;
> +	/*
> +	 * Don't fail here if tdx_supports_dynamic_pamt() isn't supported. The

A bit weird to say "if tdx_supports_dynamic_pamt() isn't supported", how about
using "if dynamic PAMT isn't supported"?

> +	 * TDX code can fallback to normal PAMT if it's not supported.
> +	 */
> +	if (!ret && tdx_supports_dynamic_pamt(&tdx_sysinfo) &&
> +	    !(ret = read_sys_metadata_field(0x9100000100000013, &val)))
> +		sysinfo_tdmr->pamt_page_bitmap_entry_bits = val;
>   
>   	return ret;
>   }


