Return-Path: <kvm+bounces-59162-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 5FA66BAD232
	for <lists+kvm@lfdr.de>; Tue, 30 Sep 2025 16:04:16 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id A72D116D2C7
	for <lists+kvm@lfdr.de>; Tue, 30 Sep 2025 14:04:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 911B0303C93;
	Tue, 30 Sep 2025 14:04:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Ulv/y20t"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D2E162F5301;
	Tue, 30 Sep 2025 14:04:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.15
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759241043; cv=none; b=Wj9szcV9cBLk3pLrB1llBCoOAsJYPTi/zOWAuQUvqMHJr5PO2nDS4kwpQTyXOvmAwVj7nsO1T1XWvWaRaNx0PcKP0uufQNpyE3IlOoVZCMl7t/IzjCBNY3548YgRFeWbCA2mRkM53NA+uVYL3eHvRFxpZbAd9ffUw/grT2RQknE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759241043; c=relaxed/simple;
	bh=2CzGTsrLQ+Bd44NMFXEjynn3XOAYcHLG7pZ/b1BpRVo=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=o1nGD9ZTANbSUUy14TfZbOEUhcZVKorOSAVCAbXwjEiK90Yb5ol574pc3+EoJfxGG1GdSYGyYTVgLvhb2oSyPMQoTDPr7PlQbP+kkqtjzTwmhaoMv5PcocfMhaarWPix/e7huoEbwnHC4Zl1P3kAjGT7vk7++UWHRhfwFoOSitQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Ulv/y20t; arc=none smtp.client-ip=198.175.65.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1759241042; x=1790777042;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=2CzGTsrLQ+Bd44NMFXEjynn3XOAYcHLG7pZ/b1BpRVo=;
  b=Ulv/y20tizYqFacCy8w6irNlPqRAfiIq6WyYnh/9GLY3Szd2Z27xNIXt
   1wrNOyeqzwy85/2s70bNDvJo4zRe3wcUT01E5aQNMo9iPzQeM15tGcMeb
   vvj4Exxn/nIGZ9lMSTH0IKrXClUDhvOt+lN0Frv4FAse061W1vrxQJFQC
   JhM8uRFH59bzhLSsrIwblDhY8vkrEJXwOw0jyCCth7K0BJNMdUQptGNYI
   /aLflXwBFJs1Xn3269PNphiyjoL/41ckV+oSY4JpaNs66HvdMqmL9/qzB
   e0K7FPKK56qExaCfTAgGuwY4X46TDrX8DEJcGPHa5F90owwh7T8OM3KBY
   Q==;
X-CSE-ConnectionGUID: D8I2ItRnSZ2wltfeEUypfA==
X-CSE-MsgGUID: U/dNYQpJRqyT1eFOOPxJFw==
X-IronPort-AV: E=McAfee;i="6800,10657,11568"; a="65134703"
X-IronPort-AV: E=Sophos;i="6.18,304,1751266800"; 
   d="scan'208";a="65134703"
Received: from orviesa004.jf.intel.com ([10.64.159.144])
  by orvoesa107.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Sep 2025 07:04:01 -0700
X-CSE-ConnectionGUID: kKzy1ggiRP6ZX67yLsAanw==
X-CSE-MsgGUID: 6RDKmMd+RW2q9xL4e8vYeg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.18,304,1751266800"; 
   d="scan'208";a="182823883"
Received: from xiaoyaol-hp-g830.ccr.corp.intel.com (HELO [10.124.238.14]) ([10.124.238.14])
  by orviesa004-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Sep 2025 07:03:56 -0700
Message-ID: <1f25ef49-fb7f-449c-be1d-71c19465219f@intel.com>
Date: Tue, 30 Sep 2025 22:03:53 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 07/16] x86/virt/tdx: Add tdx_alloc/free_page() helpers
To: Rick Edgecombe <rick.p.edgecombe@intel.com>, kas@kernel.org,
 bp@alien8.de, chao.gao@intel.com, dave.hansen@linux.intel.com,
 isaku.yamahata@intel.com, kai.huang@intel.com, kvm@vger.kernel.org,
 linux-coco@lists.linux.dev, linux-kernel@vger.kernel.org, mingo@redhat.com,
 pbonzini@redhat.com, seanjc@google.com, tglx@linutronix.de, x86@kernel.org,
 yan.y.zhao@intel.com, vannapurve@google.com
Cc: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
References: <20250918232224.2202592-1-rick.p.edgecombe@intel.com>
 <20250918232224.2202592-8-rick.p.edgecombe@intel.com>
Content-Language: en-US
From: Xiaoyao Li <xiaoyao.li@intel.com>
In-Reply-To: <20250918232224.2202592-8-rick.p.edgecombe@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 9/19/2025 7:22 AM, Rick Edgecombe wrote:

...

> +/* Bump PAMT refcount for the given page and allocate PAMT memory if needed */
> +int tdx_pamt_get(struct page *page)
> +{
> +	unsigned long hpa = ALIGN_DOWN(page_to_phys(page), PMD_SIZE);
> +	u64 pamt_pa_array[MAX_DPAMT_ARG_SIZE];
> +	atomic_t *pamt_refcount;
> +	u64 tdx_status;
> +	int ret;
> +
> +	if (!tdx_supports_dynamic_pamt(&tdx_sysinfo))
> +		return 0;
> +
> +	ret = alloc_pamt_array(pamt_pa_array);
> +	if (ret)
> +		return ret;
> +
> +	pamt_refcount = tdx_find_pamt_refcount(hpa);
> +
> +	scoped_guard(spinlock, &pamt_lock) {
> +		if (atomic_read(pamt_refcount))

It's not what I expect the refcount to work (maybe I miss something 
seriously?)

My understanding/expectation is that, when refcount is not zero it needs 
to increment the refcount instead of simply return. And ...

> +			goto out_free;
> +
> +		tdx_status = tdh_phymem_pamt_add(hpa | TDX_PS_2M, pamt_pa_array);
> +
> +		if (IS_TDX_SUCCESS(tdx_status)) {
> +			atomic_inc(pamt_refcount);
> +		} else {
> +			pr_err("TDH_PHYMEM_PAMT_ADD failed: %#llx\n", tdx_status);
> +			goto out_free;
> +		}
> +	}
> +
> +	return ret;
> +out_free:
> +	free_pamt_array(pamt_pa_array);
> +	return ret;
> +}
> +EXPORT_SYMBOL_GPL(tdx_pamt_get);
> +
> +/*
> + * Drop PAMT refcount for the given page and free PAMT memory if it is no
> + * longer needed.
> + */
> +void tdx_pamt_put(struct page *page)
> +{
> +	unsigned long hpa = ALIGN_DOWN(page_to_phys(page), PMD_SIZE);
> +	u64 pamt_pa_array[MAX_DPAMT_ARG_SIZE];
> +	atomic_t *pamt_refcount;
> +	u64 tdx_status;
> +
> +	if (!tdx_supports_dynamic_pamt(&tdx_sysinfo))
> +		return;
> +
> +	hpa = ALIGN_DOWN(hpa, PMD_SIZE);
> +
> +	pamt_refcount = tdx_find_pamt_refcount(hpa);
> +
> +	scoped_guard(spinlock, &pamt_lock) {
> +		if (!atomic_read(pamt_refcount))

...

when refcount > 1, decrease it.
when refcount is 1, decrease it and remove the PAMT page pair.

> +			return;
> +
> +		tdx_status = tdh_phymem_pamt_remove(hpa | TDX_PS_2M, pamt_pa_array);
> +
> +		if (IS_TDX_SUCCESS(tdx_status)) {
> +			atomic_dec(pamt_refcount);
> +		} else {
> +			pr_err("TDH_PHYMEM_PAMT_REMOVE failed: %#llx\n", tdx_status);
> +			return;
> +		}
> +	}
> +
> +	free_pamt_array(pamt_pa_array);
> +}
> +EXPORT_SYMBOL_GPL(tdx_pamt_put);


