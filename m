Return-Path: <kvm+bounces-49599-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 55B90ADAE28
	for <lists+kvm@lfdr.de>; Mon, 16 Jun 2025 13:19:27 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id EBC1A16B934
	for <lists+kvm@lfdr.de>; Mon, 16 Jun 2025 11:19:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 18A172BDC37;
	Mon, 16 Jun 2025 11:19:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="H/T0kQLY"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6662627FB10
	for <kvm@vger.kernel.org>; Mon, 16 Jun 2025 11:19:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750072747; cv=none; b=El9JR0Bcbok83i+TUfgucGlD46O3d0sls+/DG03D9calDiB2VzsQoWyDyivxfACaZPG2OOimL6o7ECxQFjFiv9gHLjfM+tHNRIOs4eaIHaejRykkmpJZa3C19WMF8kBwxQ10AZ/wj2x1f6dCGFdVHUmSZXE5dszcPTnHTqtBhOg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750072747; c=relaxed/simple;
	bh=lO+oSdtzjJoXT/Hiv71KLVRuw1AoWu2xGuyDXukpwoY=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=EkCKxStxFKyp40tHXWbob7NymHsl45yfWd/vJpAALQgUhM4+ymCN/4l4OjbpBdAOcR1FkDfYoDqWcvGpKgzNRRrf0gGP2VN72Tssr3S71DkZOeATaVSTUVbFIE3XtkLd1nD2ycp+IIP1tKv2ivePztmlhG6AhYPFQ73EsjrKfrQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=H/T0kQLY; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1750072744;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=NoVmmxCcA77lmhKdryfGIR+1/dQgmY7Gw3ATY3zbYNo=;
	b=H/T0kQLYxWY0+b+ZOd4K7bzor/r7zittqbdEVJFZCO4TOBsOusY3QlY+qCPGyaUc9YN4MR
	Ug9H4PdXWchMnDBo9qA+uzB9ijRql7Zpdlnw508Z/1nAzoPc46TYs2U4d9otvGgOEMFjwl
	tUf0jSDkXewLiDA+T3RExXeAooZjwTI=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-142-563Ij9NdNoGup1pDVrTpTQ-1; Mon, 16 Jun 2025 07:19:02 -0400
X-MC-Unique: 563Ij9NdNoGup1pDVrTpTQ-1
X-Mimecast-MFC-AGG-ID: 563Ij9NdNoGup1pDVrTpTQ_1750072742
Received: by mail-wr1-f71.google.com with SMTP id ffacd0b85a97d-3a54a8a0122so1686505f8f.2
        for <kvm@vger.kernel.org>; Mon, 16 Jun 2025 04:19:02 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1750072741; x=1750677541;
        h=content-transfer-encoding:in-reply-to:organization:autocrypt
         :content-language:from:references:cc:to:subject:user-agent
         :mime-version:date:message-id:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=NoVmmxCcA77lmhKdryfGIR+1/dQgmY7Gw3ATY3zbYNo=;
        b=nGCPzG72/fKbCTmk3aDhyn8+KmGmQnMbmQ3kn0GgF+oNrU5AO+zsfDo/1/x+gY25Lk
         7xbIxwI2X6umzTPiBgSOVaHQKD9v1FrvvUo0gebMZ+8UFBcoqv/RM+CijCRnHMWglheN
         pJ/SPioheU7MPny1f5vajPK84M39YveTXTOaq8HbsDmVyg4OSc7ejW+cnzZ3Dh74kHFj
         bagx/8V0y73llJVQFNdzoCmvCULg2foPeDNgNCNL0jGbk1ESL1aiYcs9YlfzfbKywHVf
         B6FJqi3xNXwdwyUTqNsa8fS7BGDwSqw9He8w7ePVuf9lGRPsDeX6H4USrtC4XhGZZZhL
         dfOg==
X-Forwarded-Encrypted: i=1; AJvYcCUwHDlaXEEkv5kOapW3CZ+Jj+GXbLTl9SRnR3zbAMWa+MIHdtib4Sjgntj6Z09pExhv+PA=@vger.kernel.org
X-Gm-Message-State: AOJu0YziI7pl9XzOOXwbd1lniT8L8USEHmkRfU5KOFwM189As1SAM9Hy
	ogjjMYYl0PwRInnFp4pLRug+J8AO7ZxhVP0Ndo2SjxYuZOnSyeiW3aivC0kWn5rxFXrsOaxP/xT
	ZHlZgt34wgfp6/upcb0J6is8I+nEFHfWzTH9lbQpuyIZrMqCE4w9rkA==
X-Gm-Gg: ASbGncuFNTH9aG6gxCiBw+RjR3R56tJ8z7UXTeCDOyxsJTES8wVVScvOiEkgrFPF8CO
	vvq42FeOU6p9/cv/mNi7ZZiD5EDLgsl6dzq2V5cm9rbp6t6cWbB40TTzOXbU3XCutjdKtfIQJJi
	6D5Fd0OggEr/ir0ix3g2opf+Aw6eFe7R6JFR7gUvQfwU1mX1XrhNgn0uY+hqb7fRlgQY20R3Ixo
	G23+Jzl6to/ajN5BBpwsNvHaLGe7FOB1xqiyzDIZA5Wh/Z5slwZ8q1h/AlaNdFgNNwKXt5VWzqy
	zlGBRlObYoow0VCIjQb0LLYLudFYm83R2l/jJOHt2kmEnceBUh6kKPtAajmHYMtG4a907jCkuHl
	tZq5eg5aEjpPj5eo++2OIWNJnCRpB6ZgWS1oZEJjv1KrbW74=
X-Received: by 2002:a05:6000:1acf:b0:3a5:39d7:3f17 with SMTP id ffacd0b85a97d-3a572e92329mr7492270f8f.47.1750072741462;
        Mon, 16 Jun 2025 04:19:01 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFGDoesy1VAfhtKWcYhHC2stapPOyVLHQXCHGCMu9iwSLcFu1cYern443u4X7AyjoYNzTnLLw==
X-Received: by 2002:a05:6000:1acf:b0:3a5:39d7:3f17 with SMTP id ffacd0b85a97d-3a572e92329mr7492243f8f.47.1750072741064;
        Mon, 16 Jun 2025 04:19:01 -0700 (PDT)
Received: from ?IPV6:2003:d8:2f25:bd00:949:b5a9:e02a:f265? (p200300d82f25bd000949b5a9e02af265.dip0.t-ipconnect.de. [2003:d8:2f25:bd00:949:b5a9:e02a:f265])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4532e2384cesm139576665e9.16.2025.06.16.04.18.59
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 16 Jun 2025 04:18:59 -0700 (PDT)
Message-ID: <8483b457-6044-4174-9190-161f29f2cda5@redhat.com>
Date: Mon, 16 Jun 2025 13:18:58 +0200
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 2/2] vfio/type1: optimize vfio_unpin_pages_remote() for
 large folio
To: lizhe.67@bytedance.com
Cc: alex.williamson@redhat.com, kvm@vger.kernel.org,
 linux-kernel@vger.kernel.org, peterx@redhat.com
References: <753caff4-58d6-4d23-ae69-4b909a99aa16@redhat.com>
 <20250616111353.7964-1-lizhe.67@bytedance.com>
From: David Hildenbrand <david@redhat.com>
Content-Language: en-US
Autocrypt: addr=david@redhat.com; keydata=
 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
 WNyWQQ==
Organization: Red Hat
In-Reply-To: <20250616111353.7964-1-lizhe.67@bytedance.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 16.06.25 13:13, lizhe.67@bytedance.com wrote:
> On Mon, 16 Jun 2025 10:14:23 +0200, david@redhat.com wrote:
> 
>>>    drivers/vfio/vfio_iommu_type1.c | 55 +++++++++++++++++++++++++++------
>>>    1 file changed, 46 insertions(+), 9 deletions(-)
>>>
>>> diff --git a/drivers/vfio/vfio_iommu_type1.c b/drivers/vfio/vfio_iommu_type1.c
>>> index e952bf8bdfab..09ecc546ece8 100644
>>> --- a/drivers/vfio/vfio_iommu_type1.c
>>> +++ b/drivers/vfio/vfio_iommu_type1.c
>>> @@ -469,17 +469,28 @@ static bool is_invalid_reserved_pfn(unsigned long pfn)
>>>    	return true;
>>>    }
>>>    
>>> -static int put_pfn(unsigned long pfn, int prot)
>>> +static inline void _put_pfns(struct page *page, int npages, int prot)
>>>    {
>>> -	if (!is_invalid_reserved_pfn(pfn)) {
>>> -		struct page *page = pfn_to_page(pfn);
>>> +	unpin_user_page_range_dirty_lock(page, npages, prot & IOMMU_WRITE);
>>> +}
>>>    
>>> -		unpin_user_pages_dirty_lock(&page, 1, prot & IOMMU_WRITE);
>>> -		return 1;
>>> +/*
>>> + * The caller must ensure that these npages PFNs belong to the same folio.
>>> + */
>>> +static inline int put_pfns(unsigned long pfn, int npages, int prot)
>>> +{
>>> +	if (!is_invalid_reserved_pfn(pfn)) {
>>> +		_put_pfns(pfn_to_page(pfn), npages, prot);
>>> +		return npages;
>>>    	}
>>>    	return 0;
>>>    }
>>>    
>>> +static inline int put_pfn(unsigned long pfn, int prot)
>>> +{
>>> +	return put_pfns(pfn, 1, prot);
>>> +}
>>> +
>>>    #define VFIO_BATCH_MAX_CAPACITY (PAGE_SIZE / sizeof(struct page *))
>>>    
>>>    static void __vfio_batch_init(struct vfio_batch *batch, bool single)
>>> @@ -806,11 +817,37 @@ static long vfio_unpin_pages_remote(struct vfio_dma *dma, dma_addr_t iova,
>>>    				    bool do_accounting)
>>>    {
>>>    	long unlocked = 0, locked = vpfn_pages(dma, iova, npage);
>>> -	long i;
>>>    
>>> -	for (i = 0; i < npage; i++)
>>> -		if (put_pfn(pfn++, dma->prot))
>>> -			unlocked++;
>>> +	while (npage) {
>>> +		long nr_pages = 1;
>>> +
>>> +		if (!is_invalid_reserved_pfn(pfn)) {
>>> +			struct page *page = pfn_to_page(pfn);
>>> +			struct folio *folio = page_folio(page);
>>> +			long folio_pages_num = folio_nr_pages(folio);
>>> +
>>> +			/*
>>> +			 * For a folio, it represents a physically
>>> +			 * contiguous set of bytes, and all of its pages
>>> +			 * share the same invalid/reserved state.
>>> +			 *
>>> +			 * Here, our PFNs are contiguous. Therefore, if we
>>> +			 * detect that the current PFN belongs to a large
>>> +			 * folio, we can batch the operations for the next
>>> +			 * nr_pages PFNs.
>>> +			 */
>>> +			if (folio_pages_num > 1)
>>> +				nr_pages = min_t(long, npage,
>>> +					folio_pages_num -
>>> +					folio_page_idx(folio, page));
>>> +
>>> +			_put_pfns(page, nr_pages, dma->prot);
>>
>>
>> This is sneaky. You interpret the page pointer a an actual page array,
>> assuming that it would give you the right values when advancing nr_pages
>> in that array.
>>
>> This is mostly true, but with !CONFIG_SPARSEMEM_VMEMMAP it is not
>> universally true for very large folios (e.g., in a 1 GiB hugetlb folio
>> when we cross the 128 MiB mark on x86).
>>
>> Not sure if that could already trigger here, but it is subtle.
> 
> As previously mentioned in the email, the code here functions
> correctly.
> 
>>> +			unlocked += nr_pages;
>>
>> We could do slightly better here, as we already have the folio. We would
>> add a unpin_user_folio_dirty_locked() similar to unpin_user_folio().
>>
>> Instead of _put_pfns, we would be calling
>>
>> unpin_user_folio_dirty_locked(folio, nr_pages, dma->prot & IOMMU_WRITE);
> 
> Thank you so much for your suggestion. Does this implementation of
> unpin_user_folio_dirty_locked() look viable to you?
> 
> diff --git a/include/linux/mm.h b/include/linux/mm.h
> index fdda6b16263b..567c9dae9088 100644
> --- a/include/linux/mm.h
> +++ b/include/linux/mm.h
> @@ -1689,6 +1689,8 @@ void unpin_user_page_range_dirty_lock(struct page *page, unsigned long npages,
>   				      bool make_dirty);
>   void unpin_user_pages(struct page **pages, unsigned long npages);
>   void unpin_user_folio(struct folio *folio, unsigned long npages);
> +void unpin_user_folio_dirty_locked(struct folio *folio,
> +		unsigned long npages, bool make_dirty);
>   void unpin_folios(struct folio **folios, unsigned long nfolios);
>   
>   static inline bool is_cow_mapping(vm_flags_t flags)
> diff --git a/mm/gup.c b/mm/gup.c
> index 84461d384ae2..2f1e14a79463 100644
> --- a/mm/gup.c
> +++ b/mm/gup.c
> @@ -360,11 +360,8 @@ void unpin_user_page_range_dirty_lock(struct page *page, unsigned long npages,
>   
>   	for (i = 0; i < npages; i += nr) {
>   		folio = gup_folio_range_next(page, npages, i, &nr);
> -		if (make_dirty && !folio_test_dirty(folio)) {
> -			folio_lock(folio);
> -			folio_mark_dirty(folio);
> -			folio_unlock(folio);
> -		}
> +		if (make_dirty && !folio_test_dirty(folio))
> +			folio_mark_dirty_lock(folio);
>   		gup_put_folio(folio, nr, FOLL_PIN);

We can call unpin_user_folio_dirty_locked(). :)

>   	}
>   }
> @@ -435,6 +432,26 @@ void unpin_user_folio(struct folio *folio, unsigned long npages)
>   }
>   EXPORT_SYMBOL(unpin_user_folio);
>   
> +/**
> + * unpin_user_folio_dirty_locked() - release pages of a folio and
> + * optionally dirty

"conditionally mark a folio dirty and unpin it"

Because that's the sequence in which it is done.

> + *
> + * @folio:  pointer to folio to be released
> + * @npages: number of pages of same folio

Can we change that to "nrefs" or rather "npins"?

> + * @make_dirty: whether to mark the folio dirty
> + *
> + * Mark the folio as being modified if @make_dirty is true. Then
> + * release npages of the folio.

Similarly, adjust the doc here.

> + */
> +void unpin_user_folio_dirty_locked(struct folio *folio,
> +		unsigned long npages, bool make_dirty)
> +{
> +	if (make_dirty && !folio_test_dirty(folio))
> +		folio_mark_dirty_lock(folio);
> +	gup_put_folio(folio, npages, FOLL_PIN);
> +}
> +EXPORT_SYMBOL(unpin_user_folio_dirty_locked);

Yes, should probably go into a separate cleanup patch.

-- 
Cheers,

David / dhildenb


