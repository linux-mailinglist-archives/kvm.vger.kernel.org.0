Return-Path: <kvm+bounces-56868-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id BBC3DB45290
	for <lists+kvm@lfdr.de>; Fri,  5 Sep 2025 11:09:25 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id B22C617F116
	for <lists+kvm@lfdr.de>; Fri,  5 Sep 2025 09:09:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 321502D1913;
	Fri,  5 Sep 2025 09:06:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="JR3ahxD6"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BA9992701CF;
	Fri,  5 Sep 2025 09:06:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757063166; cv=none; b=G1HPQnOXfxp8Jt8YZVPnbtbDuPBxQQHUC9NhTH3SHd2Obxiw5McgyrCj32UGPL6yrMoVS6kYi84Q31NuXGivPRroRiJlqn/gDEL5fjg/ycoYLhykNtPmjI+5tqxnhFc406t0jN6Scw6VLvooQXtH0K4OC6FMwN54uir5y6HRBVE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757063166; c=relaxed/simple;
	bh=7YFrlKd+MAc6wbx42R8Oz9rMGWrVDoq7jvwizjelbP0=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=rSrnRNfoQO3RW2SOrG8TPD8UcCJEHmfQRxKQqlPdktEePdi3vNIBvbLZ9jNepDKkmOLZmxD73u/uLRaCXIOc0aMqTLmpqTthDorquk5/50BrHwpkYOW0OOxyR0K7dIQYX3oCY+GNtOZ8GJyeqPhMKSqZc7ueuXbcUWD7W0c6kxc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=JR3ahxD6; arc=none smtp.client-ip=192.198.163.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1757063165; x=1788599165;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=7YFrlKd+MAc6wbx42R8Oz9rMGWrVDoq7jvwizjelbP0=;
  b=JR3ahxD6/m+fPxQqr5rgLoIHKDMWHyKGE+U4netft3JjJgxMScFkP158
   xZHbNXPJbUH1OgSULR/6q4N3o9lunsfi27m+Vcvgq25/lOF3K4twP/3Fl
   o7ihf5nioAdVPuv7lU610kqSjSAdRFmJxkhNzik4u0KpY2TmnU0tCjnSN
   bs7iOkHhv4cfY4zCY8bwjifBaVRxRJVtayZKzOK6VnX1cYIJuxHwXMfrM
   U3MECTopHzEIsOxMYy0Jeo7JWRJtY3tnL2f3zkanUJ42r/JM47hs7k7tM
   u5hcQmiugFA7gItRXXoeV5vMtbfcOyWJf3Xe1uF0MpDGsWGM7dpPw6MhA
   Q==;
X-CSE-ConnectionGUID: ZFV/aHwmT+67zCbq00G99A==
X-CSE-MsgGUID: HbHJEsNgSZWeNYHRIexhTw==
X-IronPort-AV: E=McAfee;i="6800,10657,11543"; a="59485427"
X-IronPort-AV: E=Sophos;i="6.18,240,1751266800"; 
   d="scan'208";a="59485427"
Received: from orviesa002.jf.intel.com ([10.64.159.142])
  by fmvoesa108.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Sep 2025 02:06:04 -0700
X-CSE-ConnectionGUID: R6mvviZ9SkqHzzQK606tWw==
X-CSE-MsgGUID: 1FTd/cCAS6OMipqT3EkNQg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.18,240,1751266800"; 
   d="scan'208";a="202941463"
Received: from unknown (HELO [10.238.0.107]) ([10.238.0.107])
  by orviesa002-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Sep 2025 02:05:58 -0700
Message-ID: <73c7eee9-e84d-454e-8cc8-173b42c1dba5@linux.intel.com>
Date: Fri, 5 Sep 2025 17:05:55 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH v2 18/23] x86/virt/tdx: Do not perform cache flushes
 unless CLFLUSH_BEFORE_ALLOC is set
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
 <20250807094516.4705-1-yan.y.zhao@intel.com>
 <0d3229ff-2359-4ade-a715-c8af56c2916c@linux.intel.com>
 <aLlg+VavGQlnQqFY@yzhao56-desk.sh.intel.com>
Content-Language: en-US
From: Binbin Wu <binbin.wu@linux.intel.com>
In-Reply-To: <aLlg+VavGQlnQqFY@yzhao56-desk.sh.intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 9/4/2025 5:50 PM, Yan Zhao wrote:
> On Thu, Sep 04, 2025 at 04:16:27PM +0800, Binbin Wu wrote:
>>
>> On 8/7/2025 5:45 PM, Yan Zhao wrote:
>>> From: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
>>>
>>> The TDX module enumerates with a TDX_FEATURES0 bit if an explicit cache
>>> flush is necessary when switching KeyID for a page, like before
>>> handing the page over to a TD.
>>>
>>> Currently, none of the TDX-capable platforms have this bit enabled.
>>>
>>> Moreover, cache flushing with TDH.PHYMEM.PAGE.WBINVD fails if
>>> Dynamic PAMT is active and the target page is not 4k. The SEAMCALL only
>>> supports 4k pages and will fail if there is no PAMT_4K for the HPA.
>>>
>>> Avoid performing these cache flushes unless the CLFLUSH_BEFORE_ALLOC bit
>>> of TDX_FEATURES0 is set.
>>>
>>> Signed-off-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
>>> Signed-off-by: Yan Zhao <yan.y.zhao@intel.com>
>>> ---
>>> RFC v2:
>>> - Pulled from
>>>     git://git.kernel.org/pub/scm/linux/kernel/git/kas/linux.git tdx/dpamt-huge.
>>> - Rebased on top of TDX huge page RFC v2 (Yan)
>>> ---
>>>    arch/x86/include/asm/tdx.h  |  1 +
>>>    arch/x86/virt/vmx/tdx/tdx.c | 19 +++++++++++++------
>>>    2 files changed, 14 insertions(+), 6 deletions(-)
>>>
>>> diff --git a/arch/x86/include/asm/tdx.h b/arch/x86/include/asm/tdx.h
>>> index f1bd74348b34..c058a82d4a97 100644
>>> --- a/arch/x86/include/asm/tdx.h
>>> +++ b/arch/x86/include/asm/tdx.h
>>> @@ -15,6 +15,7 @@
>>>    /* Bit definitions of TDX_FEATURES0 metadata field */
>>>    #define TDX_FEATURES0_NO_RBP_MOD		BIT_ULL(18)
>>> +#define TDX_FEATURES0_CLFLUSH_BEFORE_ALLOC	BIT_ULL(23)
>>>    #define TDX_FEATURES0_DYNAMIC_PAMT		BIT_ULL(36)
>>>    #ifndef __ASSEMBLER__
>>> diff --git a/arch/x86/virt/vmx/tdx/tdx.c b/arch/x86/virt/vmx/tdx/tdx.c
>>> index 9ed585bde062..b7a0ee0f4a50 100644
>>> --- a/arch/x86/virt/vmx/tdx/tdx.c
>>> +++ b/arch/x86/virt/vmx/tdx/tdx.c
>>> @@ -1648,14 +1648,13 @@ static inline u64 tdx_tdvpr_pa(struct tdx_vp *td)
>>>    	return page_to_phys(td->tdvpr_page);
>>>    }
>>> -/*
>>> - * The TDX module exposes a CLFLUSH_BEFORE_ALLOC bit to specify whether
>>> - * a CLFLUSH of pages is required before handing them to the TDX module.
>>> - * Be conservative and make the code simpler by doing the CLFLUSH
>>> - * unconditionally.
>>> - */
>>>    static void tdx_clflush_page(struct page *page)
>>>    {
>>> +	u64 tdx_features0 = tdx_sysinfo.features.tdx_features0;
>>> +
>>> +	if (tdx_features0 & TDX_FEATURES0_CLFLUSH_BEFORE_ALLOC)
>> According to the cover letter, if TDX_FEATURES0_CLFLUSH_BEFORE_ALLOC is enabled,
>> an explicit cache flush is necessary.
>> Shouldn't this and below be:
>> if (!(tdx_features0 & TDX_FEATURES0_CLFLUSH_BEFORE_ALLOC))
> Right, Sagi also reported it.
> https://lore.kernel.org/kvm/CAAhR5DEZZfX0=9QwBrXhC+1fp1Z0w4Xbb3mXcn0OuW+45tsLwA@mail.gmail.com/
>
>>> +		return;
>>> +
>>>    	clflush_cache_range(page_to_virt(page), PAGE_SIZE);
>>>    }
>>> @@ -2030,8 +2029,12 @@ EXPORT_SYMBOL_GPL(tdh_phymem_cache_wb);
>>>    u64 tdh_phymem_page_wbinvd_tdr(struct tdx_td *td)
>>>    {
>>> +	u64 tdx_features0 = tdx_sysinfo.features.tdx_features0;
>>>    	struct tdx_module_args args = {};
>>> +	if (tdx_features0 & TDX_FEATURES0_CLFLUSH_BEFORE_ALLOC)
>>> +		return 0;
>>> +

According to the description of TDX module base spec (348549006),
CLFLUSH_BEFORE_ALLOC is related to clfush requirement before adding a page to
TDX module.

If it also applies to the pages returned back from TDX module, I think it needs
to be called out somewhere.


>>>    	args.rcx = mk_keyed_paddr(tdx_global_keyid, td->tdr_page);
>>>    	return seamcall(TDH_PHYMEM_PAGE_WBINVD, &args);
>>> @@ -2041,10 +2044,14 @@ EXPORT_SYMBOL_GPL(tdh_phymem_page_wbinvd_tdr);
>>>    u64 tdh_phymem_page_wbinvd_hkid(u64 hkid, struct folio *folio,
>>>    				unsigned long start_idx, unsigned long npages)
>>>    {
>>> +	u64 tdx_features0 = tdx_sysinfo.features.tdx_features0;
>>>    	struct page *start = folio_page(folio, start_idx);
>>>    	struct tdx_module_args args = {};
>>>    	u64 err;
>>> +	if (tdx_features0 & TDX_FEATURES0_CLFLUSH_BEFORE_ALLOC)
>>> +		return 0;
>>> +
>>>    	if (start_idx + npages > folio_nr_pages(folio))
>>>    		return TDX_OPERAND_INVALID;


