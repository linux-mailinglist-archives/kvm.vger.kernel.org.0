Return-Path: <kvm+bounces-64457-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ams.mirrors.kernel.org (ams.mirrors.kernel.org [213.196.21.55])
	by mail.lfdr.de (Postfix) with ESMTPS id 7474AC83334
	for <lists+kvm@lfdr.de>; Tue, 25 Nov 2025 04:16:21 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ams.mirrors.kernel.org (Postfix) with ESMTPS id A737434A865
	for <lists+kvm@lfdr.de>; Tue, 25 Nov 2025 03:16:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5916E21146C;
	Tue, 25 Nov 2025 03:15:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="FePvlHRy"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.20])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 65C961F2BAD;
	Tue, 25 Nov 2025 03:15:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.20
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764040531; cv=none; b=PIlg83ZfPExqn6iJd61JWv8VkTuT5HCioqaT0hEwPglCXNkpf3pkTzw9ibx6gX0irqWJzgXT7uesPs4OHW6rlU3koFErHp2b4jqcFytqqujoq1m7ZEwagXuTMdF8eyn5agEZ/5kAXF72GrjmZ0CMvfzPfvCTAHJo0eG6jMw1Xo4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764040531; c=relaxed/simple;
	bh=DTUimPmdhhmxVdAjWQGOKOU+xBdpFumluibCB6RZp+s=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=hmzkL+lfDUfvaHbbTdznruHy2z11v6X9svGkDkv5bzco2N7+jX/yuL7bK35hbqBoiKdYdZGQJ/3bTgX3Ykf39UBi7u4Y7Bo/I4mKJWEnM4nXfwTTanpufPJgdGzNWb/Fj1j4inrIknMiRSWheYIUaqliGzjKk/f/Po97mRFPEKY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=pass smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=FePvlHRy; arc=none smtp.client-ip=198.175.65.20
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1764040529; x=1795576529;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=DTUimPmdhhmxVdAjWQGOKOU+xBdpFumluibCB6RZp+s=;
  b=FePvlHRyCiEGhD5SZdfszuOZk1z1lVZYB7dD1TABeH/JtaaZQ4hxyMRN
   zDz+Thsj+iHSlCkrZuiP5PtiANYljr8Gn8c8PUxs3QZZKfHBGqqggJIC3
   8vjtjpr3ozxWPRNdqdjrNc+PXmzcHBTrB7GXrtLskwLlAZE7oUGM1Lbr+
   rHuH4sO/0ueBMQf8GzR756qWwDVkQPGvU+FEbeFvlamtuV3hBGHZSJOLl
   L+Ik91HZcCJ3qVDqysHPRMursTADHLNFO+QZixJJQCzfkOw7RyvExTpWw
   5w8MuuiQT+sdRFwxm0u61GYIe30lrZcmvooShFTklv3mkCFdVpP2qbR0w
   A==;
X-CSE-ConnectionGUID: 40d3GwvqTfC94e7BbkK27A==
X-CSE-MsgGUID: eNhCC0HaStOx5Ol4IyIxuA==
X-IronPort-AV: E=McAfee;i="6800,10657,11623"; a="65757646"
X-IronPort-AV: E=Sophos;i="6.20,224,1758610800"; 
   d="scan'208";a="65757646"
Received: from fmviesa008.fm.intel.com ([10.60.135.148])
  by orvoesa112.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Nov 2025 19:15:28 -0800
X-CSE-ConnectionGUID: 5h1yorYtSVi+QRHdFjEdSQ==
X-CSE-MsgGUID: FHROwhlfSC+YT76mIm9Z4w==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.20,224,1758610800"; 
   d="scan'208";a="192748261"
Received: from yinghaoj-desk.ccr.corp.intel.com (HELO [10.238.1.225]) ([10.238.1.225])
  by fmviesa008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Nov 2025 19:15:24 -0800
Message-ID: <468165b7-46aa-4321-a47f-a97befaa993f@linux.intel.com>
Date: Tue, 25 Nov 2025 11:15:22 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 06/16] x86/virt/tdx: Improve PAMT refcounts allocation
 for sparse memory
To: Rick Edgecombe <rick.p.edgecombe@intel.com>
Cc: bp@alien8.de, chao.gao@intel.com, dave.hansen@intel.com,
 isaku.yamahata@intel.com, kai.huang@intel.com, kas@kernel.org,
 kvm@vger.kernel.org, linux-coco@lists.linux.dev,
 linux-kernel@vger.kernel.org, mingo@redhat.com, pbonzini@redhat.com,
 seanjc@google.com, tglx@linutronix.de, vannapurve@google.com,
 x86@kernel.org, yan.y.zhao@intel.com, xiaoyao.li@intel.com,
 binbin.wu@intel.com
References: <20251121005125.417831-1-rick.p.edgecombe@intel.com>
 <20251121005125.417831-7-rick.p.edgecombe@intel.com>
Content-Language: en-US
From: Binbin Wu <binbin.wu@linux.intel.com>
In-Reply-To: <20251121005125.417831-7-rick.p.edgecombe@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 11/21/2025 8:51 AM, Rick Edgecombe wrote:
[...]
> +
> +/* Unmap a page from the PAMT refcount vmalloc region */
> +static int pamt_refcount_depopulate(pte_t *pte, unsigned long addr, void *data)
> +{
> +	struct page *page;
> +	pte_t entry;
> +
> +	spin_lock(&init_mm.page_table_lock);
> +
> +	entry = ptep_get(pte);
> +	/* refcount allocation is sparse, may not be populated */

Not sure this comment about "sparse" is accurate since this function is called via
apply_to_existing_page_range().

And the check for not present just for sanity check?
> +	if (!pte_none(entry)) {
> +		pte_clear(&init_mm, addr, pte);
> +		page = pte_page(entry);
> +		__free_page(page);
> +	}
> +
> +	spin_unlock(&init_mm.page_table_lock);
> +
> +	return 0;
> +}
> +
> +/* Unmap all PAMT refcount pages and free vmalloc range */
>   static void free_pamt_metadata(void)
>   {
> +	size_t size;
> +
>   	if (!tdx_supports_dynamic_pamt(&tdx_sysinfo))
>   		return;
>   
> +	size = max_pfn / PTRS_PER_PTE * sizeof(*pamt_refcounts);
> +	size = round_up(size, PAGE_SIZE);
> +
> +	apply_to_existing_page_range(&init_mm,
> +				     (unsigned long)pamt_refcounts,
> +				     size, pamt_refcount_depopulate,
> +				     NULL);
>   	vfree(pamt_refcounts);
>   	pamt_refcounts = NULL;
>   }
> @@ -288,10 +393,19 @@ static int build_tdx_memlist(struct list_head *tmb_list)
>   		ret = add_tdx_memblock(tmb_list, start_pfn, end_pfn, nid);
>   		if (ret)
>   			goto err;
> +
> +		/* Allocated PAMT refcountes for the memblock */
> +		ret = alloc_pamt_refcount(start_pfn, end_pfn);
> +		if (ret)
> +			goto err;
>   	}
>   
>   	return 0;
>   err:
> +	/*
> +	 * Only free TDX memory blocks here, PAMT refcount pages
> +	 * will be freed in the init_tdx_module() error path.
> +	 */
>   	free_tdx_memlist(tmb_list);
>   	return ret;
>   }


