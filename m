Return-Path: <kvm+bounces-50749-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 78007AE8F16
	for <lists+kvm@lfdr.de>; Wed, 25 Jun 2025 22:02:56 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 09ABF1898309
	for <lists+kvm@lfdr.de>; Wed, 25 Jun 2025 20:03:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0EDD72DAFBC;
	Wed, 25 Jun 2025 20:02:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="gLrpY2m8"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA4D42066DE;
	Wed, 25 Jun 2025 20:02:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.10
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750881762; cv=none; b=cenGYl3pnUqkUnEHuRlDxk98Mu2+iUC9C1p5USXlZuQ7+ypJj9ia++51CWhQdsdPj663ivE56iIEYjB2A4Kgu52s3j1OFnb7z5MHhEvmYNsSY2/YLGyvXxFMbdIEsgHEhiwt6CDRTStlG0hu9jL1pKc188eQM2pqOOX/QVmnWvA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750881762; c=relaxed/simple;
	bh=43wNCcyAb8e54VAM2GwpB9zj2+lN8oliu10hUpHh+JU=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=a+lhtBbSyK+SxTxfzGqNnXN5cBdKRx7L5kvSnkg2NVXfqaYQjKeqjYje5wmN5edj4lV9SbgiIfY/4SBYRcbhtP0k3AH0aG9EeLR4v88I5FamkIT7bFofPks+HuvLXs45XGWI29tXRd/T9unSAOD2rI4yuxqr9US40BM3tbQcNNM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=gLrpY2m8; arc=none smtp.client-ip=192.198.163.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1750881761; x=1782417761;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=43wNCcyAb8e54VAM2GwpB9zj2+lN8oliu10hUpHh+JU=;
  b=gLrpY2m8YSYhuFf3PwM78v9fNVdRyKae67qKm6M2VBJW6WiTdqX5yUue
   Wn0yyYZycaIMgS8AxVo2urtLgUTZfF7Inc5oYYBQwve1mMTFu/G1Bjjio
   EqOB+Rupewps6Hqdbke3L7hTVVEXDNoqHeM02/RUvEZ1hPudp608FEwOP
   V1KfHNRaN003fwbt8B6JOwRreyn9QTT9jVwRmrx1JUUN0vOm6VNFtlWnA
   0IYDzp2ckZoPWkx7yIn/V/hXw94k0Vcr4/VyOLJGwu+heCNHD46tTIl+S
   AZKL2Xl9j6F4GPvLB5XDo8fL2rqJEFjX5r5eZFddAjIXAgQ4hFXaB9Ql/
   Q==;
X-CSE-ConnectionGUID: S2Urh4ipT+ygz6o0CZpFFw==
X-CSE-MsgGUID: D4ddN9p3QbK8z0nnX2+X/Q==
X-IronPort-AV: E=McAfee;i="6800,10657,11475"; a="64520423"
X-IronPort-AV: E=Sophos;i="6.16,265,1744095600"; 
   d="scan'208";a="64520423"
Received: from orviesa002.jf.intel.com ([10.64.159.142])
  by fmvoesa104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Jun 2025 13:02:40 -0700
X-CSE-ConnectionGUID: +bPP6+oXToWrLF/e5liXMA==
X-CSE-MsgGUID: Gve64YEVQ1mAoZ9IjDbYiQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,265,1744095600"; 
   d="scan'208";a="183340922"
Received: from dwoodwor-mobl2.amr.corp.intel.com (HELO [10.125.108.244]) ([10.125.108.244])
  by orviesa002-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Jun 2025 13:02:39 -0700
Message-ID: <fd9ebb1c-8a5a-44c5-869b-810bb5e7436c@intel.com>
Date: Wed, 25 Jun 2025 13:02:38 -0700
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCHv2 04/12] x86/virt/tdx: Add tdx_alloc/free_page() helpers
To: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
 pbonzini@redhat.com, seanjc@google.com, dave.hansen@linux.intel.com
Cc: rick.p.edgecombe@intel.com, isaku.yamahata@intel.com,
 kai.huang@intel.com, yan.y.zhao@intel.com, chao.gao@intel.com,
 tglx@linutronix.de, mingo@redhat.com, bp@alien8.de, kvm@vger.kernel.org,
 x86@kernel.org, linux-coco@lists.linux.dev, linux-kernel@vger.kernel.org
References: <20250609191340.2051741-1-kirill.shutemov@linux.intel.com>
 <20250609191340.2051741-5-kirill.shutemov@linux.intel.com>
From: Dave Hansen <dave.hansen@intel.com>
Content-Language: en-US
Autocrypt: addr=dave.hansen@intel.com; keydata=
 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
In-Reply-To: <20250609191340.2051741-5-kirill.shutemov@linux.intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 6/9/25 12:13, Kirill A. Shutemov wrote:
>  arch/x86/include/asm/tdx.h       |   3 +
>  arch/x86/include/asm/tdx_errno.h |   6 +
>  arch/x86/virt/vmx/tdx/tdx.c      | 205 +++++++++++++++++++++++++++++++
>  arch/x86/virt/vmx/tdx/tdx.h      |   2 +
>  4 files changed, 216 insertions(+)

Please go through this whole series and add appropriate comments and
explanations.

There are 4 lines of comments in the 216 lines of new code.

I'll give some examples:

> +static int tdx_nr_pamt_pages(void)

Despite the naming this function does not return the number of TDX
PAMT pages. It returns the number of pages needed for each *dynamic*
PAMT granule.

The naming is not consistent with something used only for dynamic PAMT
support. This kind of comment would help, but is not a replacement for
good naming:

/*
 * How many pages are needed for the TDX
 * dynamic page metadata for a 2M region?
 */

Oh, and what the heck is with the tdx_supports_dynamic_pamt() check?
Isn't it illegal to call these functions without dynamic PAMT in
place? Wouldn't the TDH_PHYMEM_PAMT_ADD blow up if you hand it 0's
in args.rdx?

> +static int tdx_nr_pamt_pages(void)
> +{
> +	if (!tdx_supports_dynamic_pamt(&tdx_sysinfo))
> +		return 0;
> +
> +	return tdx_sysinfo.tdmr.pamt_4k_entry_size * PTRS_PER_PTE / PAGE_SIZE;
> +}
> +
> +static u64 tdh_phymem_pamt_add(unsigned long hpa,
> +			       struct list_head *pamt_pages)
> +{
> +	struct tdx_module_args args = {
> +		.rcx = hpa,
> +	};
> +	struct page *page;
> +	u64 *p;
> +
> +	WARN_ON_ONCE(!IS_ALIGNED(hpa & PAGE_MASK, PMD_SIZE));
> +
> +	p = &args.rdx;
> +	list_for_each_entry(page, pamt_pages, lru) {
> +		*p = page_to_phys(page);
> +		p++;
> +	}

This is sheer voodoo. Voodoo on its own is OK. But uncommented voodoo
is not.

Imagine what would happen if, for instance, someone got confused and did:

	tdx_alloc_pamt_pages(&pamd_pages);
	tdx_alloc_pamt_pages(&pamd_pages);
	tdx_alloc_pamt_pages(&pamd_pages);

It would *work* because the allocation function would just merrily
shove lots of pages on the list. But when it's consumed you'd run off
the end of the data structure in this function far, far away from the
bug site.

The least you can do here is comment what's going on. Because treating
a structure like an array is obtuse at best.

Even better would be to have a check to ensure that the pointer magic
doesn't run off the end of the struct:

	if (p - &args.rcx >= sizeof(args)/sizeof(u64)) {
		WARN_ON_ONCE(1);
		break;
	}

or some other pointer voodoo.

> +
> +	return seamcall(TDH_PHYMEM_PAMT_ADD, &args);
> +}


