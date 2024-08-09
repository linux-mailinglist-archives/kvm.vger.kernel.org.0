Return-Path: <kvm+bounces-23732-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id ECA2294D4C7
	for <lists+kvm@lfdr.de>; Fri,  9 Aug 2024 18:34:38 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 8A4F8B228E3
	for <lists+kvm@lfdr.de>; Fri,  9 Aug 2024 16:34:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 033041C6B8;
	Fri,  9 Aug 2024 16:34:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="FpvzqKNo"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B96081C6A5
	for <kvm@vger.kernel.org>; Fri,  9 Aug 2024 16:34:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723221264; cv=none; b=MYaZ4jnztlTO9JQM3Pu7bDfXMVGnkx2X+UBD/NeU2ZvsXkbbn12YWdiq/0icxdfOWHS4ob7DnXiPH9ks1rDOcGL1uuOdW1/3QmTJA6Swh7Ul+bg/L8RIZ2kZdEHrVRL9z2aiwDV2jQF3f0jbFCztJ+bkn/gsGu0hA/c+v/PRkeA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723221264; c=relaxed/simple;
	bh=dYg8NSOAf2WOa8cFWIO6zeGw1KS8XSyg7RFM36TQeA0=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=GWN2aiardmRPx7YYxHTGo72r4CbrJ+XN6nv/WupWmp81slZ3YfxkFntZLUYRbWH9EBGAMWhJkBtnmUGF9GIKkEY4PYtTivRxp6qa3Fo0SG2cRZx/wBSKW/NxkUJqoj6vgQ8wxJR+pu1ON2uRxR89K+amrihISqwOzii14fRfFPo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=FpvzqKNo; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1723221261;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=QoLkUdckrqDJnReUgsCkNDRsr8qBkab668j70DQFRt8=;
	b=FpvzqKNobxF5ArwW5dMK/Jo9xsX3OP5eBA5+mLhssgr8dI0oNs0vbeodS9jFOVm4ULXcQE
	aDhZqGX8d5fJ2gibQTmGKeo/ywLe2wwtkkwgvnEcfGaMGWsP8vOtiohNSahcDT+1TUGriY
	nmo/Ef/JrhFyFNZqhCSd+Ff28n0kxcA=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-38-Y6FeEssjMCSW9SfR3KAGBg-1; Fri, 09 Aug 2024 12:34:20 -0400
X-MC-Unique: Y6FeEssjMCSW9SfR3KAGBg-1
Received: by mail-wr1-f70.google.com with SMTP id ffacd0b85a97d-3687529b63fso1271195f8f.2
        for <kvm@vger.kernel.org>; Fri, 09 Aug 2024 09:34:20 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1723221259; x=1723826059;
        h=content-transfer-encoding:in-reply-to:organization:autocrypt
         :content-language:from:references:cc:to:subject:user-agent
         :mime-version:date:message-id:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=QoLkUdckrqDJnReUgsCkNDRsr8qBkab668j70DQFRt8=;
        b=ZkV1xLHFxEW4aJZyUCkU0wQSo8a2dHsMAmyu3vP53SfcGKGx/C/IQZE3fxxV9gQtAh
         38Hnm6iI3X+rkbLCSa8USrDsGhdHj9TwHXb2uAmMuS85xV5DvBurR0f1+aqWYsj114mq
         RZh1ABUJFPL6tgdOqasODZBUTSTyctrJ60KCl9DqUGZGiPsaWP0I/7WmOvkaOqLcygPb
         DCXriNq2Q3FvRzSPZHg+hyg2ouF3dwQHtpQn2/l+seCDwAXe8OY0a9MWJ9YbIzw3Xgjw
         j/tesxcKxDG5SCpoovEPH/6QgSPSwJKGQXylDN6C5v0pEn8Uv9yyfb/dgH0kNeGKVdJs
         gjxQ==
X-Forwarded-Encrypted: i=1; AJvYcCWSDEkWvgAhPtL/rj0pctmX/7JEcvg7Q/bJsIuB55xQud4PtvpqQcpbsubajvfTOKLF5dG4mE2X9CzpkWMM9VfAZrMG
X-Gm-Message-State: AOJu0Ywx8sSg2qR4xl2wndwrYYlrFcg6QUZCSvPja6wc3WKS0nmtKNRD
	juB4jAofbaWpsd0Mr9h6N/BWdj4i3U+vtcZFy483ZDn9QtTQWiCncUeG4UfwtYXzrvkVB/YpoVf
	rakmPFvCSpQQ9Gw7RZvHpdjQBiFCi0HZQXGdG5I9wtcUDWvgTCg==
X-Received: by 2002:a5d:4562:0:b0:368:6337:4226 with SMTP id ffacd0b85a97d-36d5f2d0fb8mr1301920f8f.12.1723221258921;
        Fri, 09 Aug 2024 09:34:18 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEKEHvLNa26hrAuQu6rK0KsK/wvnm2hOgARvrEzXVL69guW1PypXgOcEiRLWHXpxy4NovBYuQ==
X-Received: by 2002:a5d:4562:0:b0:368:6337:4226 with SMTP id ffacd0b85a97d-36d5f2d0fb8mr1301886f8f.12.1723221258392;
        Fri, 09 Aug 2024 09:34:18 -0700 (PDT)
Received: from ?IPV6:2003:d8:2f09:3f00:d228:bd67:7baa:d604? (p200300d82f093f00d228bd677baad604.dip0.t-ipconnect.de. [2003:d8:2f09:3f00:d228:bd67:7baa:d604])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-36d2718a4a6sm5756184f8f.58.2024.08.09.09.34.16
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 09 Aug 2024 09:34:17 -0700 (PDT)
Message-ID: <def1dda5-a2e8-4f6b-85f6-1d6981ab0140@redhat.com>
Date: Fri, 9 Aug 2024 18:34:15 +0200
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 01/19] mm: Introduce ARCH_SUPPORTS_HUGE_PFNMAP and special
 bits to pmd/pud
To: Peter Xu <peterx@redhat.com>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org
Cc: Sean Christopherson <seanjc@google.com>,
 Oscar Salvador <osalvador@suse.de>, Jason Gunthorpe <jgg@nvidia.com>,
 Axel Rasmussen <axelrasmussen@google.com>,
 linux-arm-kernel@lists.infradead.org, x86@kernel.org,
 Will Deacon <will@kernel.org>, Gavin Shan <gshan@redhat.com>,
 Paolo Bonzini <pbonzini@redhat.com>, Zi Yan <ziy@nvidia.com>,
 Andrew Morton <akpm@linux-foundation.org>,
 Catalin Marinas <catalin.marinas@arm.com>, Ingo Molnar <mingo@redhat.com>,
 Alistair Popple <apopple@nvidia.com>, Borislav Petkov <bp@alien8.de>,
 Thomas Gleixner <tglx@linutronix.de>, kvm@vger.kernel.org,
 Dave Hansen <dave.hansen@linux.intel.com>,
 Alex Williamson <alex.williamson@redhat.com>, Yan Zhao <yan.y.zhao@intel.com>
References: <20240809160909.1023470-1-peterx@redhat.com>
 <20240809160909.1023470-2-peterx@redhat.com>
From: David Hildenbrand <david@redhat.com>
Content-Language: en-US
Autocrypt: addr=david@redhat.com; keydata=
 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
 WNyWQQ==
Organization: Red Hat
In-Reply-To: <20240809160909.1023470-2-peterx@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 09.08.24 18:08, Peter Xu wrote:
> This patch introduces the option to introduce special pte bit into
> pmd/puds.  Archs can start to define pmd_special / pud_special when
> supported by selecting the new option.  Per-arch support will be added
> later.
> 
> Before that, create fallbacks for these helpers so that they are always
> available.
> 
> Signed-off-by: Peter Xu <peterx@redhat.com>
> ---
>   include/linux/mm.h | 24 ++++++++++++++++++++++++
>   mm/Kconfig         | 13 +++++++++++++
>   2 files changed, 37 insertions(+)
> 
> diff --git a/include/linux/mm.h b/include/linux/mm.h
> index 43b40334e9b2..90ca84200800 100644
> --- a/include/linux/mm.h
> +++ b/include/linux/mm.h
> @@ -2644,6 +2644,30 @@ static inline pte_t pte_mkspecial(pte_t pte)
>   }
>   #endif
>   
> +#ifndef CONFIG_ARCH_SUPPORTS_PMD_PFNMAP
> +static inline bool pmd_special(pmd_t pmd)
> +{
> +	return false;
> +}
> +
> +static inline pmd_t pmd_mkspecial(pmd_t pmd)
> +{
> +	return pmd;
> +}
> +#endif	/* CONFIG_ARCH_SUPPORTS_PMD_PFNMAP */
> +
> +#ifndef CONFIG_ARCH_SUPPORTS_PUD_PFNMAP
> +static inline bool pud_special(pud_t pud)
> +{
> +	return false;
> +}
> +
> +static inline pud_t pud_mkspecial(pud_t pud)
> +{
> +	return pud;
> +}
> +#endif	/* CONFIG_ARCH_SUPPORTS_PUD_PFNMAP */
> +
>   #ifndef CONFIG_ARCH_HAS_PTE_DEVMAP
>   static inline int pte_devmap(pte_t pte)
>   {
> diff --git a/mm/Kconfig b/mm/Kconfig
> index 3936fe4d26d9..3db0eebb53e2 100644
> --- a/mm/Kconfig
> +++ b/mm/Kconfig
> @@ -881,6 +881,19 @@ endif # TRANSPARENT_HUGEPAGE
>   config PGTABLE_HAS_HUGE_LEAVES
>   	def_bool TRANSPARENT_HUGEPAGE || HUGETLB_PAGE
>   
> +# TODO: Allow to be enabled without THP
> +config ARCH_SUPPORTS_HUGE_PFNMAP
> +	def_bool n
> +	depends on TRANSPARENT_HUGEPAGE
> +
> +config ARCH_SUPPORTS_PMD_PFNMAP
> +	def_bool y
> +	depends on ARCH_SUPPORTS_HUGE_PFNMAP && HAVE_ARCH_TRANSPARENT_HUGEPAGE
> +
> +config ARCH_SUPPORTS_PUD_PFNMAP
> +	def_bool y
> +	depends on ARCH_SUPPORTS_HUGE_PFNMAP && HAVE_ARCH_TRANSPARENT_HUGEPAGE_PUD
> +
>   #
>   # UP and nommu archs use km based percpu allocator
>   #

As noted in reply to other patches, I think you have to take care of 
vm_normal_page_pmd() [if not done in another patch I am missing] and 
likely you want to introduce vm_normal_page_pud().

-- 
Cheers,

David / dhildenb


