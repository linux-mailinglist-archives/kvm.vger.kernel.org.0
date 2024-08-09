Return-Path: <kvm+bounces-23745-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 25A0294D600
	for <lists+kvm@lfdr.de>; Fri,  9 Aug 2024 20:07:18 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 86C80B21AF0
	for <lists+kvm@lfdr.de>; Fri,  9 Aug 2024 18:07:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A5F98155CB3;
	Fri,  9 Aug 2024 18:06:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="UYeXRdrH"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 30E8B13D512
	for <kvm@vger.kernel.org>; Fri,  9 Aug 2024 18:06:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723226811; cv=none; b=YXJGW1Nkza+PX3AG710v89cU21Dg+nNFWUuT8l0A4Wunx7LGN237/N/Gj0/8QGpDK1lEDSkg3iD4TP18oOqXwbjeXG1oL1+hp6j9Qi7xOR/k9ok0EpwNJ2Gaw7fNQZcba/bnhbYQUxHDNA4dKY5l2pmTft3kCxsiJnedOI/x37g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723226811; c=relaxed/simple;
	bh=2aIGGKzwksT3XWFDji/oQUNMW5NkFEeXTEyhx7VTGLs=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=AbIhIYdFVpgov/7f7VmCfSSr8xP/cplF8k0h+HnVQ7EgWKWkzW6CSVeqCxKOM92PMafvEQnGHds98ODLW+XuiqjtZVphPrgeP/hDQG3BoIurdkFJC1ZEcAkDygsSbMTgXIZ66IWw1Zo9FhGz9LnuuPBiE4oiHw7Ijz8+lXETe2M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=UYeXRdrH; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1723226809;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=Ottb3/5hhoIcIh9XsbIo3cxS6G9yhKNk+IY5Yk/Wzbk=;
	b=UYeXRdrHOS/ZfKKOeoREbT68Bb+BUBU8s7rX6drNbsD6hWGah/3TJBrzyckdxGLkGjo+Yv
	WKBK8GZFVLrpOY5EElCdIqxJeMRw7H79XAGV7oLD7fLPoC2DeDt35hh+OAgzpT38Mabc+G
	xMJdIaB+G2lW2TMPYey31zJxT/JDWAc=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-164-yswBBSPoNAGlI8dcYAH7ww-1; Fri, 09 Aug 2024 14:06:45 -0400
X-MC-Unique: yswBBSPoNAGlI8dcYAH7ww-1
Received: by mail-wm1-f69.google.com with SMTP id 5b1f17b1804b1-428fb72245bso12281235e9.1
        for <kvm@vger.kernel.org>; Fri, 09 Aug 2024 11:06:45 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1723226804; x=1723831604;
        h=content-transfer-encoding:in-reply-to:organization:autocrypt
         :content-language:from:references:cc:to:subject:user-agent
         :mime-version:date:message-id:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=Ottb3/5hhoIcIh9XsbIo3cxS6G9yhKNk+IY5Yk/Wzbk=;
        b=VJfhGq8xeHZw5GbXlHum4JN90gkfhCYX68bqjggoBo/U9wDCYyqxCqpoyyhDPR5bPg
         CXVkZbdESA57vfZdrfkZzP7ddotJXZ4aPMEO9rpqk2RwadiPktjY6PJDfb0jHNseVwZ5
         BvHZCU98xYGQ7hEfO3Be2rnuwHXbTmvJPRYD3PCd/VKdT53y+Xs5DEnYlHg7amftA7sp
         fe6CNNqtiGoyB+ep5/YNX4pqnJ/uT5MGMcVrtH7cgs+mCJHB87rPmblQVDChAqOxLCOP
         WlxgC1wJQLHE2UDIueEQpNvG9mz5HOaRoiCiIFrrfGblodub46CJQQB9KElmypvDu33H
         n/XQ==
X-Forwarded-Encrypted: i=1; AJvYcCXt2VOgnb3zdLDpRbB27hBAnSPqcpOhcw1RNPKY953WyHfnxnS+kA1edVaZ7aJU77I/SPMCQprHxr1MdAIhk7fzbAaN
X-Gm-Message-State: AOJu0Yz5iKd5G2O8aAeX71+g1qyBGAwxah1jk/afe3U1mDoWCaipe38R
	SdaBNvy6q4sbgPXj52OyTcUsVfwQajAsQihJDrDyrqKO5slER14GFRNV6wpwLq8n1b4Nnay2myH
	Bfzj7lNzWofnoAe/qwxxPor92eM3SeN+VAb+FKM+vqOcNb9F49Q==
X-Received: by 2002:a05:600c:1907:b0:426:6eb6:1374 with SMTP id 5b1f17b1804b1-4290b7c5662mr53809255e9.0.1723226804568;
        Fri, 09 Aug 2024 11:06:44 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFlQKx6L1EQCWOB7RzBZmYVRt0F9P+j2Ro1H/EXqC88yiCad1Newf5OObVYXOxLEX+lEpoTrw==
X-Received: by 2002:a05:600c:1907:b0:426:6eb6:1374 with SMTP id 5b1f17b1804b1-4290b7c5662mr53808975e9.0.1723226803982;
        Fri, 09 Aug 2024 11:06:43 -0700 (PDT)
Received: from ?IPV6:2003:d8:2f09:3f00:d228:bd67:7baa:d604? (p200300d82f093f00d228bd677baad604.dip0.t-ipconnect.de. [2003:d8:2f09:3f00:d228:bd67:7baa:d604])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4290c738e01sm85236555e9.11.2024.08.09.11.06.42
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 09 Aug 2024 11:06:43 -0700 (PDT)
Message-ID: <04d06717-4d44-4e09-a3cb-d8350e3466ad@redhat.com>
Date: Fri, 9 Aug 2024 20:06:42 +0200
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 01/19] mm: Introduce ARCH_SUPPORTS_HUGE_PFNMAP and special
 bits to pmd/pud
To: Peter Xu <peterx@redhat.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 Sean Christopherson <seanjc@google.com>, Oscar Salvador <osalvador@suse.de>,
 Jason Gunthorpe <jgg@nvidia.com>, Axel Rasmussen <axelrasmussen@google.com>,
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
 <def1dda5-a2e8-4f6b-85f6-1d6981ab0140@redhat.com> <ZrZPA_Enghb42xMq@x1n>
From: David Hildenbrand <david@redhat.com>
Content-Language: en-US
Autocrypt: addr=david@redhat.com; keydata=
 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
 WNyWQQ==
Organization: Red Hat
In-Reply-To: <ZrZPA_Enghb42xMq@x1n>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 09.08.24 19:16, Peter Xu wrote:
> On Fri, Aug 09, 2024 at 06:34:15PM +0200, David Hildenbrand wrote:
>> On 09.08.24 18:08, Peter Xu wrote:
>>> This patch introduces the option to introduce special pte bit into
>>> pmd/puds.  Archs can start to define pmd_special / pud_special when
>>> supported by selecting the new option.  Per-arch support will be added
>>> later.
>>>
>>> Before that, create fallbacks for these helpers so that they are always
>>> available.
>>>
>>> Signed-off-by: Peter Xu <peterx@redhat.com>
>>> ---
>>>    include/linux/mm.h | 24 ++++++++++++++++++++++++
>>>    mm/Kconfig         | 13 +++++++++++++
>>>    2 files changed, 37 insertions(+)
>>>
>>> diff --git a/include/linux/mm.h b/include/linux/mm.h
>>> index 43b40334e9b2..90ca84200800 100644
>>> --- a/include/linux/mm.h
>>> +++ b/include/linux/mm.h
>>> @@ -2644,6 +2644,30 @@ static inline pte_t pte_mkspecial(pte_t pte)
>>>    }
>>>    #endif
>>> +#ifndef CONFIG_ARCH_SUPPORTS_PMD_PFNMAP
>>> +static inline bool pmd_special(pmd_t pmd)
>>> +{
>>> +	return false;
>>> +}
>>> +
>>> +static inline pmd_t pmd_mkspecial(pmd_t pmd)
>>> +{
>>> +	return pmd;
>>> +}
>>> +#endif	/* CONFIG_ARCH_SUPPORTS_PMD_PFNMAP */
>>> +
>>> +#ifndef CONFIG_ARCH_SUPPORTS_PUD_PFNMAP
>>> +static inline bool pud_special(pud_t pud)
>>> +{
>>> +	return false;
>>> +}
>>> +
>>> +static inline pud_t pud_mkspecial(pud_t pud)
>>> +{
>>> +	return pud;
>>> +}
>>> +#endif	/* CONFIG_ARCH_SUPPORTS_PUD_PFNMAP */
>>> +
>>>    #ifndef CONFIG_ARCH_HAS_PTE_DEVMAP
>>>    static inline int pte_devmap(pte_t pte)
>>>    {
>>> diff --git a/mm/Kconfig b/mm/Kconfig
>>> index 3936fe4d26d9..3db0eebb53e2 100644
>>> --- a/mm/Kconfig
>>> +++ b/mm/Kconfig
>>> @@ -881,6 +881,19 @@ endif # TRANSPARENT_HUGEPAGE
>>>    config PGTABLE_HAS_HUGE_LEAVES
>>>    	def_bool TRANSPARENT_HUGEPAGE || HUGETLB_PAGE
>>> +# TODO: Allow to be enabled without THP
>>> +config ARCH_SUPPORTS_HUGE_PFNMAP
>>> +	def_bool n
>>> +	depends on TRANSPARENT_HUGEPAGE
>>> +
>>> +config ARCH_SUPPORTS_PMD_PFNMAP
>>> +	def_bool y
>>> +	depends on ARCH_SUPPORTS_HUGE_PFNMAP && HAVE_ARCH_TRANSPARENT_HUGEPAGE
>>> +
>>> +config ARCH_SUPPORTS_PUD_PFNMAP
>>> +	def_bool y
>>> +	depends on ARCH_SUPPORTS_HUGE_PFNMAP && HAVE_ARCH_TRANSPARENT_HUGEPAGE_PUD
>>> +
>>>    #
>>>    # UP and nommu archs use km based percpu allocator
>>>    #
>>
>> As noted in reply to other patches, I think you have to take care of
>> vm_normal_page_pmd() [if not done in another patch I am missing] and likely
>> you want to introduce vm_normal_page_pud().
> 
> So far this patch may not have direct involvement with vm_normal_page_pud()
> yet?  Anyway, let's keep the discussion there, then we'll know how to move
> on.

vm_normal_page_pud() might make sense as of today already, primarily to 
wrap the pud_devmap() stuff (maybe that is gone soon, who knows). 
Anyhow, I can send a patch to add that as well.

-- 
Cheers,

David / dhildenb


