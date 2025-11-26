Return-Path: <kvm+bounces-64664-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id DC697C8A6E2
	for <lists+kvm@lfdr.de>; Wed, 26 Nov 2025 15:48:31 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id CDC2D3A1C21
	for <lists+kvm@lfdr.de>; Wed, 26 Nov 2025 14:46:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B17C430497C;
	Wed, 26 Nov 2025 14:45:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="HNZEJdvP"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wr1-f50.google.com (mail-wr1-f50.google.com [209.85.221.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B421D3043B8
	for <kvm@vger.kernel.org>; Wed, 26 Nov 2025 14:45:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764168356; cv=none; b=P01u7XDZiWqGuMHYpDwtZSiEo4Y8q3MMyGX2Lmt0lUqkGE23mWbczviElinhjLtlNvw1pN0nY9v38GQ7VOzYFNg7BDhRM762irmbXbvvJfP+HRrey9xKI8Rm4kiqMNFeqnkh9SlZvrYC2tuKGK2NBfrHTImoOAmX/dCy4bUuoac=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764168356; c=relaxed/simple;
	bh=bAwZ/h3G+Zjo9ptE3c/wRgetC5mvgj2Vpa06A/+N83Y=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=hAn5ghrqhFWc8q83y55ShozzqugGbEA5PPwMX9rUG/ZPKRVT3YySN8rz3F2h34V7/42G6me+FadteHvPFIyNzg1a06L9gu/JHX9mA+dfwp6vSqMHaF+63/2TK4vKzEoj6WYcJ4PNKGgBptMnbSmTBcy8LlQwPiuZdCQkauPNMPA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=HNZEJdvP; arc=none smtp.client-ip=209.85.221.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Received: by mail-wr1-f50.google.com with SMTP id ffacd0b85a97d-42b3b29153fso3727835f8f.3
        for <kvm@vger.kernel.org>; Wed, 26 Nov 2025 06:45:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1764168353; x=1764773153; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=HYMfm5Up5H/6PEZCi1erkPAG8KCR2IZVJjL++PJAHPA=;
        b=HNZEJdvP6ZDyf54HLokIXvyZHpph8p32RG6AOxPSntKwhLnNwZr9EuD72zDQkpO83M
         c8mdSq8E65cE0G7hAgWmzyBmRM0yKLAYN/G5NS2M+COHLrMyBlzO4Kg/n4Li8Hrd4Zcw
         EEj6JMXAEaM4e2A0bRvb0QTKwanw0kO5HXfK/LyXnnYi4N7JMDKJ+OMoqSvxfhGxpDyF
         koWQ7ZD1cYf0HK5e8NOZ/4RlsGWa/5nKumkg2TUNhAyODbr/5nzmDE5Ijsl6WlbPMJb1
         bDZcDjQt8BCUQF80ElC/NdoD6ERjv4b9SdXnDBMTKz5NsZJwH0dVitwNIbYt/8f/Q4rt
         q33w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764168353; x=1764773153;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=HYMfm5Up5H/6PEZCi1erkPAG8KCR2IZVJjL++PJAHPA=;
        b=VhhDlRq7ROQ30mluAXD64I7w3ZF7ee/6PMcrpjga6Ydl4gAof+Ebd5JfdxS2WZ+W1A
         v6DkwXiNwUC/8oUZnsAwTI3zK4hQ67CL99EOO3KOdPBmjJCTQp/k4ErRn1NY+008HF2w
         xmzBqit03W59wgtQ40xwTwPob5xsLwC1v4/Vd2QORZx5e3NhGqjS601UWg/AM9EDDOie
         RyBB+mDbdPS9nM+0wrhLmf7MwRyaQdiZf33RcAQaYRqMf5iHE7E7wt5pe60DW2pK4jnJ
         0oaw1N7QFlvE7Fa6Lj/KCmn9vKW6E5E5Y3N/84Azgv4Olwyz9BJvcH/x/6h/k4JxWeYr
         TdOw==
X-Forwarded-Encrypted: i=1; AJvYcCXVqkIuNdFYynpAOi//phiiW52nvwK/qMte9bmwoBKCDOmSxxR7sOTb4NpIOqjobHz/lJ8=@vger.kernel.org
X-Gm-Message-State: AOJu0YzT6iRAzbqVYSTzZcMqDC0ryLGLeQn4fDXrmed6/6hKAy/LVfWR
	6JzvQ8bpAcqwLpB1JYSLEvNNVwlnAM7kishH/iLZo91JxxbPnbIFPFzXsIYDc9K2Odo=
X-Gm-Gg: ASbGnctDyu4sIevLDyIbdaaf0+MFyFBkUPBachrnkUZiAY1M6DVe2jDfZ3tf3xKSL05
	/gJM12w1T7Lpvh7yUrwbLgR2pLrJy4Gmjqyb8US6/OsrYHNdxgy1EjAMMIm3Xd0vOGT3XC1f07L
	rHRH2NFROfJXVlb51ICo+5Lu7AzZNtDCsr5DcFmJjwvjjx0h8gbZk8bIp04gtoLwo5bTeDhqcm7
	k7cr7ebA64N/hfSYMyka/xLgmjIU4PC+hbpwqOj1ynS/84rdDikuysQ9S/8v+2nP473hVFAjJ75
	v24+1EOhWp8aA1tjrS5Qo9q9dqWZWbpgVbCsu3bOkWYflK5EO6TruKM7CsGYSmEmre0WWNu1lHF
	YVVuLCBKzYfHyeiifVTVJMh4fO0WIYVIwUMQlseEuXmKI+5c4xBSM4q69qCOC89QJBonKGo9mVr
	naSkYL65lZCnngEXvkg/wLSOj6Xonwgcz5k68WC8vogNS4mq4=
X-Google-Smtp-Source: AGHT+IHehaPc5bSUI7JQZn2ffEgvKhw++fnE5++PXHZr7UoCpIiEnabgyx6hzpj0sccGvSeii/e1JQ==
X-Received: by 2002:a05:6000:40cc:b0:42b:3cd2:e9b3 with SMTP id ffacd0b85a97d-42cc1d2eee5mr22013812f8f.33.1764168352919;
        Wed, 26 Nov 2025 06:45:52 -0800 (PST)
Received: from [192.168.0.20] (nborisov.ddns.nbis.net. [85.187.216.236])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-42cb7f2e432sm40151444f8f.9.2025.11.26.06.45.50
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 26 Nov 2025 06:45:51 -0800 (PST)
Message-ID: <b3b465e6-cfa0-44d0-bdef-6d37bb26e6e0@suse.com>
Date: Wed, 26 Nov 2025 16:45:49 +0200
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 06/16] x86/virt/tdx: Improve PAMT refcounts allocation
 for sparse memory
To: Rick Edgecombe <rick.p.edgecombe@intel.com>, bp@alien8.de,
 chao.gao@intel.com, dave.hansen@intel.com, isaku.yamahata@intel.com,
 kai.huang@intel.com, kas@kernel.org, kvm@vger.kernel.org,
 linux-coco@lists.linux.dev, linux-kernel@vger.kernel.org, mingo@redhat.com,
 pbonzini@redhat.com, seanjc@google.com, tglx@linutronix.de,
 vannapurve@google.com, x86@kernel.org, yan.y.zhao@intel.com,
 xiaoyao.li@intel.com, binbin.wu@intel.com
Cc: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
References: <20251121005125.417831-1-rick.p.edgecombe@intel.com>
 <20251121005125.417831-7-rick.p.edgecombe@intel.com>
From: Nikolay Borisov <nik.borisov@suse.com>
Content-Language: en-US
Autocrypt: addr=nik.borisov@suse.com; keydata=
 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
In-Reply-To: <20251121005125.417831-7-rick.p.edgecombe@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit



On 21.11.25 г. 2:51 ч., Rick Edgecombe wrote:
> From: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
> 
> init_pamt_metadata() allocates PAMT refcounts for all physical memory up
> to max_pfn. It might be suboptimal if the physical memory layout is
> discontinuous and has large holes.
> 
> The refcount allocation vmalloc allocation. This is necessary to support a

nit: Something's odd with the first sentence, perhaps an "is a" before 
is missing before "vmalloc"?

> large allocation size. The virtually contiguous property also makes it
> easy to find a specific 2MB range’s refcount since it can simply be
> indexed.
> 
> Since vmalloc mappings support remapping during normal kernel runtime,
> switch to an approach that only populates refcount pages for the vmalloc
> mapping when there is actually memory for that range. This means any holes
> in the physical address space won’t use actual physical memory.
> 
> The validity of this memory optimization is based on a couple assumptions:
> 1. Physical holes in the ram layout are commonly large enough for it to be
>     worth it.
> 2. An alternative approach that looks the refcounts via some more layered
>     data structure wouldn’t overly complicate the lookups. Or at least
>     more than the complexity of managing the vmalloc mapping.
> 
> Signed-off-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
> [Add feedback, update log]
> Signed-off-by: Rick Edgecombe <rick.p.edgecombe@intel.com>

<snip>

> ---
>   arch/x86/virt/vmx/tdx/tdx.c | 136 +++++++++++++++++++++++++++++++++---
>   1 file changed, 125 insertions(+), 11 deletions(-)
> 
> diff --git a/arch/x86/virt/vmx/tdx/tdx.c b/arch/x86/virt/vmx/tdx/tdx.c
> index c28d4d11736c..edf9182ed86d 100644
> --- a/arch/x86/virt/vmx/tdx/tdx.c
> +++ b/arch/x86/virt/vmx/tdx/tdx.c
> @@ -194,30 +194,135 @@ int tdx_cpu_enable(void)
>   }
>   EXPORT_SYMBOL_GPL(tdx_cpu_enable);
>   
> -/*
> - * Allocate PAMT reference counters for all physical memory.
> - *
> - * It consumes 2MiB for every 1TiB of physical memory.
> - */
> -static int init_pamt_metadata(void)
> +/* Find PAMT refcount for a given physical address */
> +static atomic_t *tdx_find_pamt_refcount(unsigned long pfn)
>   {
> -	size_t size = DIV_ROUND_UP(max_pfn, PTRS_PER_PTE) * sizeof(*pamt_refcounts);
> +	/* Find which PMD a PFN is in. */
> +	unsigned long index = pfn >> (PMD_SHIFT - PAGE_SHIFT);
>   
> -	if (!tdx_supports_dynamic_pamt(&tdx_sysinfo))
> -		return 0;
> +	return &pamt_refcounts[index];
> +}
>   
> -	pamt_refcounts = __vmalloc(size, GFP_KERNEL | __GFP_ZERO);
> -	if (!pamt_refcounts)
> +/* Map a page into the PAMT refcount vmalloc region */
> +static int pamt_refcount_populate(pte_t *pte, unsigned long addr, void *data)
> +{
> +	struct page *page;
> +	pte_t entry;
> +
> +	page = alloc_page(GFP_KERNEL | __GFP_ZERO);
> +	if (!page)
>   		return -ENOMEM;
>   
> +	entry = mk_pte(page, PAGE_KERNEL);
> +
> +	spin_lock(&init_mm.page_table_lock);
> +	/*
> +	 * PAMT refcount populations can overlap due to rounding of the
> +	 * start/end pfn. Make sure the PAMT range is only populated once.
> +	 */
> +	if (pte_none(ptep_get(pte)))
> +		set_pte_at(&init_mm, addr, pte, entry);
> +	else
> +		__free_page(page);
> +	spin_unlock(&init_mm.page_table_lock);

nit: Wouldn't it be better to perform the pte_none() check before doing 
the allocation thus avoiding needless allocations? I.e do the 
alloc/mk_pte only after we are 100% sure we are going to use this entry.

> +
>   	return 0;
>   }

    <snip>

