Return-Path: <kvm+bounces-49690-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 481B6ADC660
	for <lists+kvm@lfdr.de>; Tue, 17 Jun 2025 11:30:14 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id B2A273BCBB7
	for <lists+kvm@lfdr.de>; Tue, 17 Jun 2025 09:28:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1C303295D96;
	Tue, 17 Jun 2025 09:27:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="WCJhaZoP"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 900021FC0F0
	for <kvm@vger.kernel.org>; Tue, 17 Jun 2025 09:27:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750152478; cv=none; b=lK7Tq5Y0r6f9xJFBqD84DEgsQ1CrEecQ2N2wkwMiNKsyrhDansTILBg2t13BmIJKKgkBL+R4Ndw09Q6x1h1LRaXR9/thmXYgK4Jhz4WQtTzl60kBmgYUDMfCKuGGvorxQA8lIfUHhlSYKZnn1cObZ4I3cddL+jTX40Pv4JRSaSA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750152478; c=relaxed/simple;
	bh=tSOCRe1qXuZiP+HcsTx6Mu0WjCDYKnyV2T5KA0n/8H4=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=KaRnwCRJBA8zPK6LsjvIriieFQdSc4F5B87MYCucZcb9ognse1vWrh1PKkQZnoYsT/teUc8AWVImwMJdOfwE+Pv6Rizdzd8LtXagCb4TVAF2FwjFQPo0InyLkxXrwFY7p3ubpwBSBo090h4obYv/Rdw/CuaxDw/9AbJxcvwuUtM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=WCJhaZoP; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1750152475;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=4dqrXFsdEZJmhlepEMWXpnIER3w37/a4Vct0FTgsbGo=;
	b=WCJhaZoPJZWeQAdvGY8evEGtIeAdVC4lhtW9hB1AAkOHPCgYsWpk4LT66Sy7IcK9nTD7sK
	xHy/3mM881LyTWpy2fYknL9h3zVDwrxh2YlpGwxumTu3trOfCuieVzAxH/pOeERMehftxY
	18/bo+mviiioiavm3HRybLU7PbYpVFk=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-381-0bBHgshLPHecXNCwY3Wbng-1; Tue, 17 Jun 2025 05:27:53 -0400
X-MC-Unique: 0bBHgshLPHecXNCwY3Wbng-1
X-Mimecast-MFC-AGG-ID: 0bBHgshLPHecXNCwY3Wbng_1750152472
Received: by mail-wm1-f71.google.com with SMTP id 5b1f17b1804b1-4530623eb8fso39076185e9.0
        for <kvm@vger.kernel.org>; Tue, 17 Jun 2025 02:27:52 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1750152472; x=1750757272;
        h=content-transfer-encoding:in-reply-to:organization:autocrypt
         :content-language:from:references:cc:to:subject:user-agent
         :mime-version:date:message-id:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=4dqrXFsdEZJmhlepEMWXpnIER3w37/a4Vct0FTgsbGo=;
        b=Z8tItXKn7oZVOr7OXIaCSbBvyePl3NjD9SQToPCUbr4jf4fgPiM0Yshl+q76sxlaNn
         mRLTInM5qnnDpuDfxxIL2XUNpxKWqyH1wgJcFuSRq2VjMgBOPzQ5XZoQ7NWP9IcyfVhb
         XkV58MKK78/VGYoat1qWFjp+pU+9pSPIKj46fpPjrucIna3phOygtJCn0cEjTwPW8dkj
         xmXPh+LCf7+O1RGY04H0ko0VLc0XBjkjlAJenFWidIEd1lcT/I41mN9lv6JRAd2B92/H
         NAmKQD99koRlkt2m5Vm3A2VU3Nb7rzzX6Aor/PW7EVqXX4lCY+AF5hm2DUAAAtnU6Sv9
         /Ilw==
X-Forwarded-Encrypted: i=1; AJvYcCWQcmbNUpmUR4tiWZ55+anAPdqsRk4AvO4OSONLNx6qKR2P/b4GHvMP+k/Y8FCEwLtiTSE=@vger.kernel.org
X-Gm-Message-State: AOJu0YyEY+ad7cmEtQYA5pmrl4nnz4bt9NQql5yeWxDe9pAN4/4XSUdr
	P2PYaMDEGR8ilxzDYpgKw6PE1mTo5MMOT5/uFZqzTZTG6bQT1i/SeXLsr9aNuoN++ij5urWufQN
	fbQ8eHyOYULwc0xpcvAApdiqNyiT92oEm2yAHg6kbc/CkLj1l3xX9+g==
X-Gm-Gg: ASbGnctlFxLFzPtDZVrseOGQSaahR5qdlUuvUK9fHMb9/njSWPXvJIJ0CCk6ixD5O/7
	d09ON7Vf9RbFFLLsrGX6oj7rig4pXOq4emeB7OuX74udjRJTXj9aeWvwWfUXgeRrA6XiLDjJumM
	gsUoWL36OsriK2UKn7CJJQMoUDesbV9vQFbXdMIKqhHvjE2kfcTg4MT/12rZ9Lh3yZVXYiOSCW3
	uxVj30UQ6o/SCXxf46FXjAva7enrjpjuz65RGQ5hex2Z5zNw3Gc9VwhlSsmDBF702oSBmA6ha0i
	CMOivuGAfKAp+Yl8WQP+53i+RgFPGyv/1xKyU7TUJYQnYYxYbGeYATrN9AhVyu6n2RlukuuI6F0
	jTRTzMExnSfEABXoygT5mWXo1355dNFE7ReT7Mhc0egX3MJw=
X-Received: by 2002:a05:600c:350c:b0:43d:24d:bbe2 with SMTP id 5b1f17b1804b1-4533cabe314mr91306125e9.28.1750152471889;
        Tue, 17 Jun 2025 02:27:51 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IERF6PDjTpiYLNyZ293klVXrcUmv1H35b5KCmj2zdZoET1urMttbqluXFus7g8qKYz3SajZaw==
X-Received: by 2002:a05:600c:350c:b0:43d:24d:bbe2 with SMTP id 5b1f17b1804b1-4533cabe314mr91305955e9.28.1750152471468;
        Tue, 17 Jun 2025 02:27:51 -0700 (PDT)
Received: from ?IPV6:2003:d8:2f31:700:3851:c66a:b6b9:3490? (p200300d82f3107003851c66ab6b93490.dip0.t-ipconnect.de. [2003:d8:2f31:700:3851:c66a:b6b9:3490])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4532e2324c6sm167302745e9.12.2025.06.17.02.27.50
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 17 Jun 2025 02:27:51 -0700 (PDT)
Message-ID: <e0c741a0-450a-4512-8796-bd83a5618409@redhat.com>
Date: Tue, 17 Jun 2025 11:27:50 +0200
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 2/3] gup: introduce unpin_user_folio_dirty_locked()
To: lizhe.67@bytedance.com
Cc: akpm@linux-foundation.org, alex.williamson@redhat.com,
 kvm@vger.kernel.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org,
 peterx@redhat.com
References: <34560ae6-c598-4474-a094-a657c973156b@redhat.com>
 <20250617092117.10772-1-lizhe.67@bytedance.com>
From: David Hildenbrand <david@redhat.com>
Content-Language: en-US
Autocrypt: addr=david@redhat.com; keydata=
 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
 WNyWQQ==
Organization: Red Hat
In-Reply-To: <20250617092117.10772-1-lizhe.67@bytedance.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 17.06.25 11:21, lizhe.67@bytedance.com wrote:
> On Tue, 17 Jun 2025 09:43:56 +0200, david@redhat.com wrote:
>   
>> On 17.06.25 06:18, lizhe.67@bytedance.com wrote:
>>> From: Li Zhe <lizhe.67@bytedance.com>
>>>
>>> When vfio_unpin_pages_remote() is called with a range of addresses that
>>> includes large folios, the function currently performs individual
>>> put_pfn() operations for each page. This can lead to significant
>>> performance overheads, especially when dealing with large ranges of pages.
>>>
>>> This patch optimize this process by batching the put_pfn() operations.
>>>
>>> The performance test results, based on v6.15, for completing the 16G VFIO
>>> IOMMU DMA unmapping, obtained through unit test[1] with slight
>>> modifications[2], are as follows.
>>>
>>> Base(v6.15):
>>> ./vfio-pci-mem-dma-map 0000:03:00.0 16
>>> ------- AVERAGE (MADV_HUGEPAGE) --------
>>> VFIO MAP DMA in 0.047 s (338.6 GB/s)
>>> VFIO UNMAP DMA in 0.138 s (116.2 GB/s)
>>> ------- AVERAGE (MAP_POPULATE) --------
>>> VFIO MAP DMA in 0.280 s (57.2 GB/s)
>>> VFIO UNMAP DMA in 0.312 s (51.3 GB/s)
>>> ------- AVERAGE (HUGETLBFS) --------
>>> VFIO MAP DMA in 0.052 s (308.3 GB/s)
>>> VFIO UNMAP DMA in 0.139 s (115.1 GB/s)
>>>
>>> Map[3] + This patchset:
>>> ------- AVERAGE (MADV_HUGEPAGE) --------
>>> VFIO MAP DMA in 0.028 s (563.9 GB/s)
>>> VFIO UNMAP DMA in 0.049 s (325.1 GB/s)
>>> ------- AVERAGE (MAP_POPULATE) --------
>>> VFIO MAP DMA in 0.294 s (54.4 GB/s)
>>> VFIO UNMAP DMA in 0.296 s (54.1 GB/s)
>>> ------- AVERAGE (HUGETLBFS) --------
>>> VFIO MAP DMA in 0.033 s (485.1 GB/s)
>>> VFIO UNMAP DMA in 0.049 s (324.4 GB/s)
>>>
>>> For large folio, we achieve an approximate 64% performance improvement
>>> in the VFIO UNMAP DMA item. For small folios, the performance test
>>> results appear to show no significant changes.
>>>
>>> [1]: https://github.com/awilliam/tests/blob/vfio-pci-mem-dma-map/vfio-pci-mem-dma-map.c
>>> [2]: https://lore.kernel.org/all/20250610031013.98556-1-lizhe.67@bytedance.com/
>>> [3]: https://lore.kernel.org/all/20250529064947.38433-1-lizhe.67@bytedance.com/
>>>
>>> Signed-off-by: Li Zhe <lizhe.67@bytedance.com>
>>> ---
>>>    drivers/vfio/vfio_iommu_type1.c | 35 +++++++++++++++++++++++++++++----
>>>    1 file changed, 31 insertions(+), 4 deletions(-)
>>>
>>> diff --git a/drivers/vfio/vfio_iommu_type1.c b/drivers/vfio/vfio_iommu_type1.c
>>> index e952bf8bdfab..159ba80082a8 100644
>>> --- a/drivers/vfio/vfio_iommu_type1.c
>>> +++ b/drivers/vfio/vfio_iommu_type1.c
>>> @@ -806,11 +806,38 @@ static long vfio_unpin_pages_remote(struct vfio_dma *dma, dma_addr_t iova,
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
>>
>> (I know I can be a pain :) )
> 
> No, not at all! I really appreciate you taking the time to review my
> patch.
> 
>> But the long comment indicates that this is confusing.
>>
>>
>> That is essentially the logic in gup_folio_range_next().
>>
>> What about factoring that out into a helper like
>>
>> /*
>>    * TODO, returned number includes the provided current page.
>>    */
>> unsigned long folio_remaining_pages(struct folio *folio,
>> 	struct pages *pages, unsigned long max_pages)
>> {
>> 	if (!folio_test_large(folio))
>> 		return 1;
>> 	return min_t(unsigned long, max_pages,
>> 		     folio_nr_pages(folio) - folio_page_idx(folio, page));
>> }
>>
>>
>> Then here you would do
>>
>> if (!is_invalid_reserved_pfn(pfn)) {
>> 	struct page *page = pfn_to_page(pfn);
>> 	struct folio *folio = page_folio(page);
>>
>> 	/* We can batch-process pages belonging to the same folio. */
>> 	nr_pages = folio_remaining_pages(folio, page, npage);
>>
>> 	unpin_user_folio_dirty_locked(folio, nr_pages,
>> 				      dma->prot & IOMMU_WRITE);
>> 	unlocked += nr_pages;
>> }
> 
> Yes, this indeed makes the code much more comprehensible. Do you think
> the implementation of the patch as follows look viable to you? I have
> added some brief comments on top of your work to explain why we can
> batch-process pages belonging to the same folio. This was suggested by
> Alex[1].
> 
> diff --git a/drivers/vfio/vfio_iommu_type1.c b/drivers/vfio/vfio_iommu_type1.c
> index e952bf8bdfab..d7653f4c10d5 100644
> --- a/drivers/vfio/vfio_iommu_type1.c
> +++ b/drivers/vfio/vfio_iommu_type1.c
> @@ -801,16 +801,43 @@ static long vfio_pin_pages_remote(struct vfio_dma *dma, unsigned long vaddr,
>          return pinned;
>   }
>   
> +/* Returned number includes the provided current page. */
> +static inline unsigned long folio_remaining_pages(struct folio *folio,
> +               struct page *page, unsigned long max_pages)
> +{
> +       if (!folio_test_large(folio))
> +               return 1;
> +       return min_t(unsigned long, max_pages,
> +                    folio_nr_pages(folio) - folio_page_idx(folio, page));
> +}

Note that I think that should go somewhere into mm.h, and also get used 
by GUP. So factoring it out from GUP and then using it here.

-- 
Cheers,

David / dhildenb


