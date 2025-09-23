Return-Path: <kvm+bounces-58521-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id B91DFB95487
	for <lists+kvm@lfdr.de>; Tue, 23 Sep 2025 11:39:06 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 4B6EE190659E
	for <lists+kvm@lfdr.de>; Tue, 23 Sep 2025 09:39:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A3098320CAC;
	Tue, 23 Sep 2025 09:38:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="hd6DZ0T2"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B54FD3191C4;
	Tue, 23 Sep 2025 09:38:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.10
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758620317; cv=none; b=aH54L/wAUo7MDUGqSdGfApP+gTQPeH6B3LXI/A7qvM+Zlu1wfZYSt6VcUy1xgGnsypm86lVNnRxzSf/DpMCehF6hkpa8jAfq/bn7VSd8Iz+mgioLlmkWSNaEUVE5S7oWJyG3HuhxqMMX5RIkX8Y2dV9GzrdDpwZxI5T7Ej0ZlrQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758620317; c=relaxed/simple;
	bh=j3qAWA5jjbOKf155SEPAuTyQlJzoX1Hlz3SFDGDmXH8=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=omzYnQhuGPiOAhw61+jEiZUJk0xQjDSqyoJILftxV655MQkA+IaFAvjd/bChq6FWDOoFLYlce5ztNcVIZjxta/V7FgyhvHm6s6/n4U9K7mdrkjdeqJTOY8olG7TDu9UNxkKtLceqVeFm1/BupabAUTa0gy6ERDdoY/giZ+Je/6A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=pass smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=hd6DZ0T2; arc=none smtp.client-ip=192.198.163.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1758620314; x=1790156314;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=j3qAWA5jjbOKf155SEPAuTyQlJzoX1Hlz3SFDGDmXH8=;
  b=hd6DZ0T24IzGISmPAEiwJ4c1mKVvmLaXWJIV+ikCPgHXi9W7U+0jVtin
   lj1L1SRvKCVB2IUMg+HWdjQkA5nlteXkJwcv3Msk5OoKWSLjyFhr0VemL
   9jrdLryxPmoAuohhtCbHhtkpBPIUfsrI848845BNdXMHUYRvjjO8zWOIw
   In0o2uPpL1kgrr/MTcDrC37grJqJn2mlesi9DewjV7O7lfFat9IarlOJu
   PcOa/kmTxAsv3UmnDlw+63nW51ifYm0v9SaLW2XrCxd5CQVDt+tp4ElYk
   4RH6ZG78Txy4K20tXGD908CYyGsYitBiWGZRdBylTqcd26/qdcEUm1RDz
   g==;
X-CSE-ConnectionGUID: nnnDY2+nQimDmA38s1qwKQ==
X-CSE-MsgGUID: d9fhMdnvQfSvfbSyNcVCaA==
X-IronPort-AV: E=McAfee;i="6800,10657,11561"; a="72255178"
X-IronPort-AV: E=Sophos;i="6.18,287,1751266800"; 
   d="scan'208";a="72255178"
Received: from orviesa001.jf.intel.com ([10.64.159.141])
  by fmvoesa104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Sep 2025 02:38:33 -0700
X-CSE-ConnectionGUID: O3nI5KnYR3S8SN5k19aP6g==
X-CSE-MsgGUID: 5+YhFLPcTVaDbIJy3Ikwhg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.18,287,1751266800"; 
   d="scan'208";a="213866279"
Received: from unknown (HELO [10.238.0.107]) ([10.238.0.107])
  by smtpauth.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Sep 2025 02:38:29 -0700
Message-ID: <e455cb2c-a51c-494e-acc1-12743c4f4d3f@linux.intel.com>
Date: Tue, 23 Sep 2025 17:38:26 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 06/16] x86/virt/tdx: Improve PAMT refcounters
 allocation for sparse memory
To: "Huang, Kai" <kai.huang@intel.com>,
 "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
Cc: "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
 "linux-coco@lists.linux.dev" <linux-coco@lists.linux.dev>,
 "Zhao, Yan Y" <yan.y.zhao@intel.com>,
 "dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>,
 "kas@kernel.org" <kas@kernel.org>, "seanjc@google.com" <seanjc@google.com>,
 "mingo@redhat.com" <mingo@redhat.com>,
 "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
 "pbonzini@redhat.com" <pbonzini@redhat.com>,
 "Yamahata, Isaku" <isaku.yamahata@intel.com>,
 "tglx@linutronix.de" <tglx@linutronix.de>,
 "Annapurve, Vishal" <vannapurve@google.com>, "Gao, Chao"
 <chao.gao@intel.com>, "bp@alien8.de" <bp@alien8.de>,
 "x86@kernel.org" <x86@kernel.org>,
 "kirill.shutemov@linux.intel.com" <kirill.shutemov@linux.intel.com>
References: <20250918232224.2202592-1-rick.p.edgecombe@intel.com>
 <20250918232224.2202592-7-rick.p.edgecombe@intel.com>
 <f1018ab125eb18f431ddb3dd50501914b396ee2b.camel@intel.com>
Content-Language: en-US
From: Binbin Wu <binbin.wu@linux.intel.com>
In-Reply-To: <f1018ab125eb18f431ddb3dd50501914b396ee2b.camel@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 9/19/2025 3:25 PM, Huang, Kai wrote:
>> +/* Map a page into the PAMT refcount vmalloc region */
>> +static int pamt_refcount_populate(pte_t *pte, unsigned long addr, void *data)
>> +{
>> +	struct page *page;
>> +	pte_t entry;
>>   
>> -	pamt_refcounts = vmalloc(size);
>> -	if (!pamt_refcounts)
>> +	page = alloc_page(GFP_KERNEL | __GFP_ZERO);
>> +	if (!page)
>>   		return -ENOMEM;
>>   
>> +	entry = mk_pte(page, PAGE_KERNEL);
>> +
>> +	spin_lock(&init_mm.page_table_lock);
>> +	/*
>> +	 * PAMT refcount populations can overlap due to rounding of the
>> +	 * start/end pfn.
>>
> [...]
>
>> Make sure another PAMT range didn't already
>> +	 * populate it.
>> +	 */
> Make sure the same range only gets populated once ?
>
>> +	if (pte_none(ptep_get(pte)))
>> +		set_pte_at(&init_mm, addr, pte, entry);
>> +	else
>> +		__free_page(page);
>> +	spin_unlock(&init_mm.page_table_lock);
>> +
>>   	return 0;
>>   }
>>   
>> +/*
>> + * Allocate PAMT reference counters for the given PFN range.
>> + *
>> + * It consumes 2MiB for every 1TiB of physical memory.
>> + */
>> +static int alloc_pamt_refcount(unsigned long start_pfn, unsigned long end_pfn)
>> +{
>> +	unsigned long start, end;
>> +
>> +	start = (unsigned long)tdx_find_pamt_refcount(PFN_PHYS(start_pfn));
>> +	end   = (unsigned long)tdx_find_pamt_refcount(PFN_PHYS(end_pfn + 1));
> (sorry didn't notice this in last version)
>
> I don't quite follow why we need "end_pfn + 1" instead of just "end_pfn"?
>
> IIUC this could result in an additional 2M range being populated
> unnecessarily when the end_pfn is 2M aligned.

IIUC, this will not happen.
The +1 page will be converted to 4KB, and will be ignored since in
tdx_find_pamt_refcount() the address is divided by 2M.

To handle the address unaligned to 2M, +511 should be used instead of +1?

>
> And ...
>
>> +	start = round_down(start, PAGE_SIZE);
>> +	end   = round_up(end, PAGE_SIZE);
>> +
>> +	return apply_to_page_range(&init_mm, start, end - start,
>> +				   pamt_refcount_populate, NULL);
>> +}
>> +
>> +/*
>> + * Reserve vmalloc range for PAMT reference counters. It covers all physical
>> + * address space up to max_pfn. It is going to be populated from
>> + * build_tdx_memlist() only for present memory that available for TDX use.
>> + *
>> + * It reserves 2MiB of virtual address space for every 1TiB of physical memory.
>> + */
>> +static int init_pamt_metadata(void)
>> +{
>> +	struct vm_struct *area;
>> +	size_t size;
>> +
>> +	if (!tdx_supports_dynamic_pamt(&tdx_sysinfo))
>> +		return 0;
>> +
>> +	size = max_pfn / PTRS_PER_PTE * sizeof(*pamt_refcounts);
>> +	size = round_up(size, PAGE_SIZE);
>> +
>> +	area = get_vm_area(size, VM_SPARSE);
>> +	if (!area)
>> +		return -ENOMEM;
>> +
>> +	pamt_refcounts = area->addr;
>> +	return 0;
>> +}
>> +
>> +/* Unmap a page from the PAMT refcount vmalloc region */
>> +static int pamt_refcount_depopulate(pte_t *pte, unsigned long addr, void *data)
>> +{
>> +	struct page *page;
>> +	pte_t entry;
>> +
>> +	spin_lock(&init_mm.page_table_lock);
>> +
>> +	entry = ptep_get(pte);
>> +	/* refount allocation is sparse, may not be populated */

refount -> refcount


>> +	if (!pte_none(entry)) {
>> +		pte_clear(&init_mm, addr, pte);
>> +		page = pte_page(entry);
>> +		__free_page(page);
>> +	}
>> +
>> +	spin_unlock(&init_mm.page_table_lock);
>> +
>> +	return 0;
>> +}
>> +
>> +/* Unmap all PAMT refcount pages and free vmalloc range */
>>   static void free_pamt_metadata(void)
>>   {
>> +	size_t size;
>> +
>>   	if (!tdx_supports_dynamic_pamt(&tdx_sysinfo))
>>   		return;
>>   
>> +	size = max_pfn / PTRS_PER_PTE * sizeof(*pamt_refcounts);
>> +	size = round_up(size, PAGE_SIZE);
>> +
>> +	apply_to_existing_page_range(&init_mm,
>> +				     (unsigned long)pamt_refcounts,
>> +				     size, pamt_refcount_depopulate,
>> +				     NULL);
>>   	vfree(pamt_refcounts);
>>   	pamt_refcounts = NULL;
>>   }
>> @@ -288,10 +377,19 @@ static int build_tdx_memlist(struct list_head *tmb_list)
>>   		ret = add_tdx_memblock(tmb_list, start_pfn, end_pfn, nid);
>>   		if (ret)
>>   			goto err;
>> +
>> +		/* Allocated PAMT refcountes for the memblock */
>> +		ret = alloc_pamt_refcount(start_pfn, end_pfn);
>> +		if (ret)
>> +			goto err;
>>   	}
> ... when max_pfn == end_pfn of the last TDX memory block, this could
> result in an additional page of @pamt_refcounts being allocated, but it
> will never be freed since free_pamt_metadata() will only free mapping up
> to max_pfn.
>
> Am I missing anything?


