Return-Path: <kvm+bounces-49453-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 270E4AD9293
	for <lists+kvm@lfdr.de>; Fri, 13 Jun 2025 18:08:40 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 24642168E8B
	for <lists+kvm@lfdr.de>; Fri, 13 Jun 2025 16:08:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 62EE4200132;
	Fri, 13 Jun 2025 16:08:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="GrjbUg0C"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A0A9E78F5E
	for <kvm@vger.kernel.org>; Fri, 13 Jun 2025 16:08:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749830891; cv=none; b=CQa9bFR64H1mkpABgpl0VoPhVs3mQMsuthHSOB81yw9gd0C/w4ebwtXL8/267qDbxR+C0ElNLa9jelCBXnOAs9XLBYy0zyxTgG6Eplt8s6XifiFl+gIChf23lI5TcIdoaOOZil6UhYhUJilBV14ELucKmyYkEJZVTVpJQDHP5aw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749830891; c=relaxed/simple;
	bh=x30XsZgVhqGh393f28acfz7oIjhoI59FGnO0b/9CDso=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=WVA2QQoQiHwIuuKxBxSdU3jr3Z2FNrLaqkyO1ZLYArh+jmmGeOzHW51biq43EWiF9RWbXl3urGeueAl2GJllrpa5fjPfOd2kfaQqNWze7LezZTPcUrbp/2TBvtmVpYbAbvDfmv5lpIjp8k0D0CpKWCToiKaMGJeov0iLptyh2sg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=GrjbUg0C; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1749830888;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=ax77oJ+E/aulKQB5uQZk5hKF4VMT8e4yycq8wOdN8Ls=;
	b=GrjbUg0CUk4tNBeMat2HJ/VHuVceRBj+QXbveG1SStAR6rOqCNAWacB5mODzUuxRVzplwq
	zEaV/wqbUQQMN0zPqwvYRlD7wKQgqy1eYgF+JY5m1ejACbxBl7xXHJp8rXDsoBuC9U+OuF
	RWLGlDUTlzhmc+A7oV/pAvRwr06pS3g=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-509-Gs_riXSpMNagGRYgVW0g5Q-1; Fri, 13 Jun 2025 12:08:06 -0400
X-MC-Unique: Gs_riXSpMNagGRYgVW0g5Q-1
X-Mimecast-MFC-AGG-ID: Gs_riXSpMNagGRYgVW0g5Q_1749830885
Received: by mail-wr1-f70.google.com with SMTP id ffacd0b85a97d-3a4f8fd1856so1301307f8f.2
        for <kvm@vger.kernel.org>; Fri, 13 Jun 2025 09:08:06 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1749830885; x=1750435685;
        h=content-transfer-encoding:in-reply-to:organization:autocrypt
         :content-language:from:references:cc:to:subject:user-agent
         :mime-version:date:message-id:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=ax77oJ+E/aulKQB5uQZk5hKF4VMT8e4yycq8wOdN8Ls=;
        b=iMh5yxqaDU4rYNscd4d+4V4cmXJZry6htrWZjXHIRk19Yp32js/LlRjItqEOHCLzMP
         gdF7pvPIwe8PmcSEl1Q8DRj8XxgsiobsLxvyn7D79Yndn2kQIx2e1zhZ6ymbmFZKebbz
         0W5zmjLjTgUKYWgOeuu6a+TIkl7OIEdg3hJ1oHS5QOBIbjPHA/STKck4wjY2qKFZxUII
         SknH3iTHAhXdgWVYEfbPXL50g9bOinpwhv3Em0LF32wYX8Cj5zm4IWhmErui7ad0+v7+
         9qrl7X9535p6DdViUbB4ZS6g1e7pBYqgMarOFSeR7q3cx+HUKVpWvFs/gZ2PubgyOBVd
         Sevw==
X-Forwarded-Encrypted: i=1; AJvYcCWToL7vsSN0k23X3g0mn5f9+/1Ld7cAdsRhJIkBMEiIpfETM1LVJODzkt1pMROKN3/alj8=@vger.kernel.org
X-Gm-Message-State: AOJu0YxU1Ti6TjgLsxFKTYsaD9DUgh++AfYgHZ6ER88tLd6PBvk9I1FI
	rHkMe4+RV5DD/q+ZUUu5bN8kErAo7LZzk9iR/mv2EGdbZTTR8FJU2nA5apq2yGq4YZY5qOjE6lz
	jz3PZL6+aN+3Rd0Im0FblDnr+laD3aUPvNDUx1SBe+SC2CiesVKH3NkWsGXsXo4M2
X-Gm-Gg: ASbGncuhPsxZPED00VQi5ucF95QrM2MfoLmtCXo72b9dUzQD1Tjk9PVOJuh5Hroh0yB
	ZoXcshnBmvLbx6e8bRyo+aLsa1wyGY8MYDj++B8EvRwbVdRcT3TIyNA/iE7h6jGx7RkmN4tESmG
	L216NTlw3MvmxbPMgUlP2kRdQ7wxJA+IqZ2VixdCKdPXZggoCiRbrfJ92wQCYVGjgTLUCxC2ctH
	nOYBqhbt+/yo/Mc7aMA5oU9fOyEUTbX3cKdTfiSZs8Q7EVKhcTtFFw9E7onsNjfcFI2IcDvKRV+
	A2JMjud1gZs9n00EqXn2s3z3BR0QW4kMvhy75qTtPMBdDGXJ2nLT
X-Received: by 2002:a05:6000:2289:b0:3a4:ec23:dba7 with SMTP id ffacd0b85a97d-3a5723a367fmr377020f8f.31.1749830885140;
        Fri, 13 Jun 2025 09:08:05 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IG8rLnQcTNbInMjrW135cZxpcMD+cq0YVV8KICczTkEVZJqU7u1bHdtpORMrGCA2DxGph/39A==
X-Received: by 2002:a05:6000:2289:b0:3a4:ec23:dba7 with SMTP id ffacd0b85a97d-3a5723a367fmr376933f8f.31.1749830884331;
        Fri, 13 Jun 2025 09:08:04 -0700 (PDT)
Received: from [192.168.3.141] (p57a1a50c.dip0.t-ipconnect.de. [87.161.165.12])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3a568b18f96sm2815377f8f.66.2025.06.13.09.08.03
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 13 Jun 2025 09:08:03 -0700 (PDT)
Message-ID: <70a2a878-a9d7-4257-b100-f125a9ee0e71@redhat.com>
Date: Fri, 13 Jun 2025 18:08:02 +0200
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC v2] vfio/type1: optimize vfio_unpin_pages_remote() for large
 folio
To: Alex Williamson <alex.williamson@redhat.com>
Cc: lizhe.67@bytedance.com, kvm@vger.kernel.org,
 linux-kernel@vger.kernel.org, peterx@redhat.com
References: <20250612163239.5e45afc6.alex.williamson@redhat.com>
 <20250613062920.68801-1-lizhe.67@bytedance.com>
 <69f5e1f5-5910-4c45-9106-b362e300da8e@redhat.com>
 <20250613081613.0bef3d39.alex.williamson@redhat.com>
From: David Hildenbrand <david@redhat.com>
Content-Language: en-US
Autocrypt: addr=david@redhat.com; keydata=
 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
 WNyWQQ==
Organization: Red Hat
In-Reply-To: <20250613081613.0bef3d39.alex.williamson@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 13.06.25 16:16, Alex Williamson wrote:
> On Fri, 13 Jun 2025 15:37:40 +0200
> David Hildenbrand <david@redhat.com> wrote:
> 
>> On 13.06.25 08:29, lizhe.67@bytedance.com wrote:
>>> On Thu, 12 Jun 2025 16:32:39 -0600, alex.williamson@redhat.com wrote:
>>>    
>>>>>    drivers/vfio/vfio_iommu_type1.c | 53 +++++++++++++++++++++++++--------
>>>>>    1 file changed, 41 insertions(+), 12 deletions(-)
>>>>>
>>>>> diff --git a/drivers/vfio/vfio_iommu_type1.c b/drivers/vfio/vfio_iommu_type1.c
>>>>> index 28ee4b8d39ae..2f6c0074d7b3 100644
>>>>> --- a/drivers/vfio/vfio_iommu_type1.c
>>>>> +++ b/drivers/vfio/vfio_iommu_type1.c
>>>>> @@ -469,17 +469,28 @@ static bool is_invalid_reserved_pfn(unsigned long pfn)
>>>>>    	return true;
>>>>>    }
>>>>>    
>>>>> -static int put_pfn(unsigned long pfn, int prot)
>>>>> +static inline void _put_pfns(struct page *page, int npages, int prot)
>>>>>    {
>>>>> -	if (!is_invalid_reserved_pfn(pfn)) {
>>>>> -		struct page *page = pfn_to_page(pfn);
>>>>> +	unpin_user_page_range_dirty_lock(page, npages, prot & IOMMU_WRITE);
>>>>> +}
>>>>>    
>>>>> -		unpin_user_pages_dirty_lock(&page, 1, prot & IOMMU_WRITE);
>>>>> -		return 1;
>>>>> +/*
>>>>> + * The caller must ensure that these npages PFNs belong to the same folio.
>>>>> + */
>>>>> +static inline int put_pfns(unsigned long pfn, int npages, int prot)
>>>>> +{
>>>>> +	if (!is_invalid_reserved_pfn(pfn)) {
>>>>> +		_put_pfns(pfn_to_page(pfn), npages, prot);
>>>>> +		return npages;
>>>>>    	}
>>>>>    	return 0;
>>>>>    }
>>>>>    
>>>>> +static inline int put_pfn(unsigned long pfn, int prot)
>>>>> +{
>>>>> +	return put_pfns(pfn, 1, prot);
>>>>> +}
>>>>> +
>>>>>    #define VFIO_BATCH_MAX_CAPACITY (PAGE_SIZE / sizeof(struct page *))
>>>>>    
>>>>>    static void __vfio_batch_init(struct vfio_batch *batch, bool single)
>>>>> @@ -805,15 +816,33 @@ static long vfio_unpin_pages_remote(struct vfio_dma *dma, dma_addr_t iova,
>>>>>    				    unsigned long pfn, unsigned long npage,
>>>>>    				    bool do_accounting)
>>>>>    {
>>>>> -	long unlocked = 0, locked = 0;
>>>>> -	long i;
>>>>> +	long unlocked = 0, locked = vpfn_pages(dma, iova, npage);
>>>>>    
>>>>> -	for (i = 0; i < npage; i++, iova += PAGE_SIZE) {
>>>>> -		if (put_pfn(pfn++, dma->prot)) {
>>>>> -			unlocked++;
>>>>> -			if (vfio_find_vpfn(dma, iova))
>>>>> -				locked++;
>>>>> +	while (npage) {
>>>>> +		struct folio *folio;
>>>>> +		struct page *page;
>>>>> +		long step = 1;
>>>>> +
>>>>> +		if (is_invalid_reserved_pfn(pfn))
>>>>> +			goto next;
>>>>> +
>>>>> +		page = pfn_to_page(pfn);
>>>>> +		folio = page_folio(page);
>>>>> +
>>>>> +		if (!folio_test_large(folio)) {
>>>>> +			_put_pfns(page, 1, dma->prot);
>>>>> +		} else {
>>>>> +			step = min_t(long, npage,
>>>>> +				folio_nr_pages(folio) -
>>>>> +				folio_page_idx(folio, page));
>>>>> +			_put_pfns(page, step, dma->prot);
>>>>>    		}
>>>>> +
>>>>> +		unlocked += step;
>>>>> +next:
>>>>
>>>> Usage of @step is inconsistent, goto isn't really necessary either, how
>>>> about:
>>>>
>>>> 	while (npage) {
>>>> 		unsigned long step = 1;
>>>>
>>>> 		if (!is_invalid_reserved_pfn(pfn)) {
>>>> 			struct page *page = pfn_to_page(pfn);
>>>> 			struct folio *folio = page_folio(page);
>>>> 			long nr_pages = folio_nr_pages(folio);
>>>>
>>>> 			if (nr_pages > 1)
>>>> 				step = min_t(long, npage,
>>>> 					nr_pages -
>>>> 					folio_page_idx(folio, page));
>>>>
>>>> 			_put_pfns(page, step, dma->prot);
>>>> 			unlocked += step;
>>>> 		}
>>>>   
>>>
>>> That's great. This implementation is much better.
>>>
>>> I'm a bit uncertain about the best type to use for the 'step'
>>> variable here. I've been trying to keep things consistent with the
>>> put_pfn() function, so I set the type of the second parameter in
>>> _put_pfns() to 'int'(we pass 'step' as the second argument to
>>> _put_pfns()).
>>>
>>> Using unsigned long for 'step' should definitely work here, as the
>>> number of pages in a large folio currently falls within the range
>>> that can be represented by an int. However, there is still a
>>> potential risk of truncation that we need to be mindful of.
>>>    
>>>>> +		pfn += step;
>>>>> +		iova += PAGE_SIZE * step;
>>>>> +		npage -= step;
>>>>>    	}
>>>>>    
>>>>>    	if (do_accounting)
>>>>
>>>> AIUI, the idea is that we know we have npage contiguous pfns and we
>>>> currently test invalid/reserved, call pfn_to_page(), call
>>>> unpin_user_pages_dirty_lock(), and test vpfn for each individually.
>>>>
>>>> This instead wants to batch the vpfn accounted pfns using the range
>>>> helper added for the mapping patch,
>>>
>>> Yes. We use vpfn_pages() just to track the locked pages.
>>>    
>>>> infer that continuous pfns have the
>>>> same invalid/reserved state, the pages are sequential, and that we can
>>>> use the end of the folio to mark any inflections in those assumptions
>>>> otherwise.  Do I have that correct?
>>>
>>> Yes. I think we're definitely on the same page here.
>>>    
>>>> I think this could be split into two patches, one simply batching the
>>>> vpfn accounting and the next introducing the folio dependency.  The
>>>> contributions of each to the overall performance improvement would be
>>>> interesting.
>>>
>>> I've made an initial attempt, and here are the two patches after
>>> splitting them up.
>>>
>>> 1. batch-vpfn-accounting-patch:
>>>
>>> diff --git a/drivers/vfio/vfio_iommu_type1.c b/drivers/vfio/vfio_iommu_type1.c
>>> index 28ee4b8d39ae..c8ddcee5aa68 100644
>>> --- a/drivers/vfio/vfio_iommu_type1.c
>>> +++ b/drivers/vfio/vfio_iommu_type1.c
>>> @@ -805,16 +805,12 @@ static long vfio_unpin_pages_remote(struct vfio_dma *dma, dma_addr_t iova,
>>>    				    unsigned long pfn, unsigned long npage,
>>>    				    bool do_accounting)
>>>    {
>>> -	long unlocked = 0, locked = 0;
>>> +	long unlocked = 0, locked = vpfn_pages(dma, iova, npage);
>>>    	long i;
>>>    
>>> -	for (i = 0; i < npage; i++, iova += PAGE_SIZE) {
>>> -		if (put_pfn(pfn++, dma->prot)) {
>>> +	for (i = 0; i < npage; i++, iova += PAGE_SIZE)
>>> +		if (put_pfn(pfn++, dma->prot))
>>>    			unlocked++;
>>> -			if (vfio_find_vpfn(dma, iova))
>>> -				locked++;
>>> -		}
>>> -	}
>>>    
>>>    	if (do_accounting)
>>>    		vfio_lock_acct(dma, locked - unlocked, true);
>>> -----------------
>>>
>>> 2. large-folio-optimization-patch:
>>>
>>> diff --git a/drivers/vfio/vfio_iommu_type1.c b/drivers/vfio/vfio_iommu_type1.c
>>> index c8ddcee5aa68..48c2ba4ba4eb 100644
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
>>> @@ -806,11 +817,28 @@ static long vfio_unpin_pages_remote(struct vfio_dma *dma, dma_addr_t iova,
>>>    				    bool do_accounting)
>>>    {
>>>    	long unlocked = 0, locked = vpfn_pages(dma, iova, npage);
>>> -	long i;
>>>    
>>> -	for (i = 0; i < npage; i++, iova += PAGE_SIZE)
>>> -		if (put_pfn(pfn++, dma->prot))
>>> -			unlocked++;
>>> +	while (npage) {
>>> +		long step = 1;
>>> +
>>> +		if (!is_invalid_reserved_pfn(pfn)) {
>>> +			struct page *page = pfn_to_page(pfn);
>>> +			struct folio *folio = page_folio(page);
>>> +			long nr_pages = folio_nr_pages(folio);
>>> +
>>> +			if (nr_pages > 1)
>>> +				step = min_t(long, npage,
>>> +					nr_pages -
>>> +					folio_page_idx(folio, page));
>>> +
>>> +			_put_pfns(page, step, dma->prot);
>>
>> I'm confused, why do we batch pages by looking at the folio, to then
>> pass the pages into unpin_user_page_range_dirty_lock?
>>
>> Why does the folio relationship matter at all here?
>>
>> Aren't we making the same mistake that we are jumping over pages we
>> shouldn't be jumping over, because we assume they belong to that folio?
> 
> That's my concern as well.  On the mapping side we had an array of
> pages from gup and we tested each page in the gup array relative to the
> folio pages.  I think that's because the gup array could have
> non-sequential pages, but aiui the folio should have sequential
> pages(?).  Here I think we're trying to assume that sequential pfns
> results in sequential pages and folios should have sequential pages, so
> the folio just gives us a point to look for changes in invalid/reserved.
> 
> Is that valid?  Thanks,

Oh, it is!

I thought we would be iterating pages, but if we are iterating PFNs it 
should be fine.

-- 
Cheers,

David / dhildenb


