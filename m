Return-Path: <kvm+bounces-49588-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 23A8EADAAD3
	for <lists+kvm@lfdr.de>; Mon, 16 Jun 2025 10:32:41 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 9EAA2171291
	for <lists+kvm@lfdr.de>; Mon, 16 Jun 2025 08:30:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5019826F467;
	Mon, 16 Jun 2025 08:28:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="QGKUpNAz"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B164926E15F
	for <kvm@vger.kernel.org>; Mon, 16 Jun 2025 08:28:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750062535; cv=none; b=EZrpLhXbFcocwJgKqYs9gJwVZkSivyRgu8UCEfcvM1nIsMjT8HTrnenIjKxRZpk/C8yMPZ1RoC/6doCyar9SoD7AU9hH+kQuB5cUQ1Ma8/DBlYzYnZgIyqHkuFUUXK1LxGkdx8zf6gkbMyp698RmtZqUc+rOthkfy9wIr2h50FU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750062535; c=relaxed/simple;
	bh=Z9Xk0+sgJp5b//4dWb8HYzF7ZLLm/87HloowNvXqUxo=;
	h=Message-ID:Date:MIME-Version:Subject:From:To:Cc:References:
	 In-Reply-To:Content-Type; b=XdmMvwTmNqS1PXfaXdpcm+qh9njTwNd7V9RkoROBXgk2b5KG3AXS2p2mY1Y+J3SsG7x71HWVXSzpPW9qXSizu702H+R/MO4IdYqjM7FDzH48ucHuoIdrzyWymJqBw2wq89RPP3lbMBWfsBAQQsFo/9dFDOSK2WqHamRT17WAV3g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=QGKUpNAz; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1750062532;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=6ICj3ZOh5lwUVmdN6EinWCKBV+Dr0vF3Zz5Nwa5tVlI=;
	b=QGKUpNAzbn0aw0vzXG20tJqio4nB4k6lussuo3oITbuwbSRDS00X9N4sAEnZkKHKqTPvls
	JvDTwtOwUbuacRASnSOeOBEIX3n9JqI3itStgJMqI5NrjnCNvifsWtgwC2h51hM1zEJhxp
	2D2UU2IzpAonq3BGfJgXn8YCpVeY2HI=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-160-SJsOVN6yOr6xM1wRu7kt0A-1; Mon, 16 Jun 2025 04:28:51 -0400
X-MC-Unique: SJsOVN6yOr6xM1wRu7kt0A-1
X-Mimecast-MFC-AGG-ID: SJsOVN6yOr6xM1wRu7kt0A_1750062530
Received: by mail-wr1-f71.google.com with SMTP id ffacd0b85a97d-3a503f28b09so2386016f8f.0
        for <kvm@vger.kernel.org>; Mon, 16 Jun 2025 01:28:50 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1750062530; x=1750667330;
        h=content-transfer-encoding:in-reply-to:organization:autocrypt
         :content-language:references:cc:to:from:subject:user-agent
         :mime-version:date:message-id:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=6ICj3ZOh5lwUVmdN6EinWCKBV+Dr0vF3Zz5Nwa5tVlI=;
        b=cJReUb9c1yHJtFgeWbxd7Am1Zs3ElkfJfKWmHdU+5yDqZTLgO13xENB6ScFla3Ey7e
         nFqisGsAb0SpP7JIM2MvySZuLPGgdP7ByvsP90mwlklD66aNQsg8yWSV9cks8LNVTDtN
         nWJY5Ngi0gzDpcqc1FtIirQO33QywQWVGRVXJ9K87huhhjT4Ki98TCOd8+GCK3EJW8Nx
         wBbmrdnHF/k7fKI9sY6yP8BYukf2ZTYanpt1zLVpZ6ClsDe5WiIg3RnXMxZUPZnlYlbH
         3tEIDnOiKpn5nA7OwSvliCmUqdtFfpO5bOpfqb2NNnZBuPcoa+4Eyer1YodqaeGpf3e5
         6hOQ==
X-Gm-Message-State: AOJu0YywOguwONjLw5EJ8mcg9WZ2fLuBGw0uNGhvc6/Jv87IxR6AMj09
	z3i+5Arpg7FDWQOnv5UlXNIRmxRjsjVegBKHYctA6brDhhRxXZEPyQMLppL5s3x+WAmyY131/TL
	fTLLveWyaemS+8IJ/7fGKDoVHlOpeO6EFCsRZsCUNzSxsKuPxEO+RQQ==
X-Gm-Gg: ASbGncso+GTn9xxFwBLOOkzHnNTdZPfWbenvx3+FD47E4cXTllZSW7tC299rcmqMVf5
	fDfW4DvmFyUSyXUAZZNsFF8W1F96bjuabROFvN4UJHcDdFJv8MqmQkZJ9QFTifzP1hxGbW8epzQ
	3Ud94kNEnEse1uGvTuz+mIlWtVXVIm5n+jBCs5wGJonaOr8kzhphL1/3AS2bVT8kWTnblEu5RQy
	lmiNQPivzdXyyVC3wkE1VjLXEZgBwH3NVSXezCbHZzMmJbw2VdD7snXegGA/UtR7n995A4m8Nug
	RwDFA6pqALmaVzanrMdpTTJfx6kAgzatZxELBJn+O4lN/4iozLROsybFvLQlwMgh55GvZctfEuN
	q6VDuIVznIWlJIqvOVbs5ookROI7nHW3emol9sRgC913vJUU=
X-Received: by 2002:a05:6000:1884:b0:3a4:eb7a:2ccb with SMTP id ffacd0b85a97d-3a56d821e4dmr8241020f8f.16.1750062529719;
        Mon, 16 Jun 2025 01:28:49 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEmoMoO7TSZpHVhILD4jUdyIO6oJVX5cGvAdugYQ/eqpNweTEdTyxXrEdGDJtRN5duTNkbmdA==
X-Received: by 2002:a05:6000:1884:b0:3a4:eb7a:2ccb with SMTP id ffacd0b85a97d-3a56d821e4dmr8241013f8f.16.1750062529315;
        Mon, 16 Jun 2025 01:28:49 -0700 (PDT)
Received: from ?IPV6:2003:d8:2f25:bd00:949:b5a9:e02a:f265? (p200300d82f25bd000949b5a9e02af265.dip0.t-ipconnect.de. [2003:d8:2f25:bd00:949:b5a9:e02a:f265])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4532e13c192sm137920885e9.26.2025.06.16.01.28.47
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 16 Jun 2025 01:28:48 -0700 (PDT)
Message-ID: <28f82bf0-da91-4330-869e-f41e1559482b@redhat.com>
Date: Mon, 16 Jun 2025 10:28:47 +0200
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 2/2] vfio/type1: optimize vfio_unpin_pages_remote() for
 large folio
From: David Hildenbrand <david@redhat.com>
To: lizhe.67@bytedance.com, alex.williamson@redhat.com
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, peterx@redhat.com
References: <20250616075251.89067-1-lizhe.67@bytedance.com>
 <20250616075251.89067-3-lizhe.67@bytedance.com>
 <753caff4-58d6-4d23-ae69-4b909a99aa16@redhat.com>
 <2933056a-1f4d-49bd-ae62-5571a222c223@redhat.com>
Content-Language: en-US
Autocrypt: addr=david@redhat.com; keydata=
 xsFNBFXLn5EBEAC+zYvAFJxCBY9Tr1xZgcESmxVNI/0ffzE/ZQOiHJl6mGkmA1R7/uUpiCjJ
 dBrn+lhhOYjjNefFQou6478faXE6o2AhmebqT4KiQoUQFV4R7y1KMEKoSyy8hQaK1umALTdL
 QZLQMzNE74ap+GDK0wnacPQFpcG1AE9RMq3aeErY5tujekBS32jfC/7AnH7I0v1v1TbbK3Gp
 XNeiN4QroO+5qaSr0ID2sz5jtBLRb15RMre27E1ImpaIv2Jw8NJgW0k/D1RyKCwaTsgRdwuK
 Kx/Y91XuSBdz0uOyU/S8kM1+ag0wvsGlpBVxRR/xw/E8M7TEwuCZQArqqTCmkG6HGcXFT0V9
 PXFNNgV5jXMQRwU0O/ztJIQqsE5LsUomE//bLwzj9IVsaQpKDqW6TAPjcdBDPLHvriq7kGjt
 WhVhdl0qEYB8lkBEU7V2Yb+SYhmhpDrti9Fq1EsmhiHSkxJcGREoMK/63r9WLZYI3+4W2rAc
 UucZa4OT27U5ZISjNg3Ev0rxU5UH2/pT4wJCfxwocmqaRr6UYmrtZmND89X0KigoFD/XSeVv
 jwBRNjPAubK9/k5NoRrYqztM9W6sJqrH8+UWZ1Idd/DdmogJh0gNC0+N42Za9yBRURfIdKSb
 B3JfpUqcWwE7vUaYrHG1nw54pLUoPG6sAA7Mehl3nd4pZUALHwARAQABzSREYXZpZCBIaWxk
 ZW5icmFuZCA8ZGF2aWRAcmVkaGF0LmNvbT7CwZgEEwEIAEICGwMGCwkIBwMCBhUIAgkKCwQW
 AgMBAh4BAheAAhkBFiEEG9nKrXNcTDpGDfzKTd4Q9wD/g1oFAl8Ox4kFCRKpKXgACgkQTd4Q
 9wD/g1oHcA//a6Tj7SBNjFNM1iNhWUo1lxAja0lpSodSnB2g4FCZ4R61SBR4l/psBL73xktp
 rDHrx4aSpwkRP6Epu6mLvhlfjmkRG4OynJ5HG1gfv7RJJfnUdUM1z5kdS8JBrOhMJS2c/gPf
 wv1TGRq2XdMPnfY2o0CxRqpcLkx4vBODvJGl2mQyJF/gPepdDfcT8/PY9BJ7FL6Hrq1gnAo4
 3Iv9qV0JiT2wmZciNyYQhmA1V6dyTRiQ4YAc31zOo2IM+xisPzeSHgw3ONY/XhYvfZ9r7W1l
 pNQdc2G+o4Di9NPFHQQhDw3YTRR1opJaTlRDzxYxzU6ZnUUBghxt9cwUWTpfCktkMZiPSDGd
 KgQBjnweV2jw9UOTxjb4LXqDjmSNkjDdQUOU69jGMUXgihvo4zhYcMX8F5gWdRtMR7DzW/YE
 BgVcyxNkMIXoY1aYj6npHYiNQesQlqjU6azjbH70/SXKM5tNRplgW8TNprMDuntdvV9wNkFs
 9TyM02V5aWxFfI42+aivc4KEw69SE9KXwC7FSf5wXzuTot97N9Phj/Z3+jx443jo2NR34XgF
 89cct7wJMjOF7bBefo0fPPZQuIma0Zym71cP61OP/i11ahNye6HGKfxGCOcs5wW9kRQEk8P9
 M/k2wt3mt/fCQnuP/mWutNPt95w9wSsUyATLmtNrwccz63XOwU0EVcufkQEQAOfX3n0g0fZz
 Bgm/S2zF/kxQKCEKP8ID+Vz8sy2GpDvveBq4H2Y34XWsT1zLJdvqPI4af4ZSMxuerWjXbVWb
 T6d4odQIG0fKx4F8NccDqbgHeZRNajXeeJ3R7gAzvWvQNLz4piHrO/B4tf8svmRBL0ZB5P5A
 2uhdwLU3NZuK22zpNn4is87BPWF8HhY0L5fafgDMOqnf4guJVJPYNPhUFzXUbPqOKOkL8ojk
 CXxkOFHAbjstSK5Ca3fKquY3rdX3DNo+EL7FvAiw1mUtS+5GeYE+RMnDCsVFm/C7kY8c2d0G
 NWkB9pJM5+mnIoFNxy7YBcldYATVeOHoY4LyaUWNnAvFYWp08dHWfZo9WCiJMuTfgtH9tc75
 7QanMVdPt6fDK8UUXIBLQ2TWr/sQKE9xtFuEmoQGlE1l6bGaDnnMLcYu+Asp3kDT0w4zYGsx
 5r6XQVRH4+5N6eHZiaeYtFOujp5n+pjBaQK7wUUjDilPQ5QMzIuCL4YjVoylWiBNknvQWBXS
 lQCWmavOT9sttGQXdPCC5ynI+1ymZC1ORZKANLnRAb0NH/UCzcsstw2TAkFnMEbo9Zu9w7Kv
 AxBQXWeXhJI9XQssfrf4Gusdqx8nPEpfOqCtbbwJMATbHyqLt7/oz/5deGuwxgb65pWIzufa
 N7eop7uh+6bezi+rugUI+w6DABEBAAHCwXwEGAEIACYCGwwWIQQb2cqtc1xMOkYN/MpN3hD3
 AP+DWgUCXw7HsgUJEqkpoQAKCRBN3hD3AP+DWrrpD/4qS3dyVRxDcDHIlmguXjC1Q5tZTwNB
 boaBTPHSy/Nksu0eY7x6HfQJ3xajVH32Ms6t1trDQmPx2iP5+7iDsb7OKAb5eOS8h+BEBDeq
 3ecsQDv0fFJOA9ag5O3LLNk+3x3q7e0uo06XMaY7UHS341ozXUUI7wC7iKfoUTv03iO9El5f
 XpNMx/YrIMduZ2+nd9Di7o5+KIwlb2mAB9sTNHdMrXesX8eBL6T9b+MZJk+mZuPxKNVfEQMQ
 a5SxUEADIPQTPNvBewdeI80yeOCrN+Zzwy/Mrx9EPeu59Y5vSJOx/z6OUImD/GhX7Xvkt3kq
 Er5KTrJz3++B6SH9pum9PuoE/k+nntJkNMmQpR4MCBaV/J9gIOPGodDKnjdng+mXliF3Ptu6
 3oxc2RCyGzTlxyMwuc2U5Q7KtUNTdDe8T0uE+9b8BLMVQDDfJjqY0VVqSUwImzTDLX9S4g/8
 kC4HRcclk8hpyhY2jKGluZO0awwTIMgVEzmTyBphDg/Gx7dZU1Xf8HFuE+UZ5UDHDTnwgv7E
 th6RC9+WrhDNspZ9fJjKWRbveQgUFCpe1sa77LAw+XFrKmBHXp9ZVIe90RMe2tRL06BGiRZr
 jPrnvUsUUsjRoRNJjKKA/REq+sAnhkNPPZ/NNMjaZ5b8Tovi8C0tmxiCHaQYqj7G2rgnT0kt
 WNyWQQ==
Organization: Red Hat
In-Reply-To: <2933056a-1f4d-49bd-ae62-5571a222c223@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 16.06.25 10:27, David Hildenbrand wrote:
> On 16.06.25 10:14, David Hildenbrand wrote:
>> On 16.06.25 09:52, lizhe.67@bytedance.com wrote:
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
>>> VFIO MAP DMA in 0.027 s (598.2 GB/s)
>>> VFIO UNMAP DMA in 0.049 s (328.7 GB/s)
>>> ------- AVERAGE (MAP_POPULATE) --------
>>> VFIO MAP DMA in 0.289 s (55.3 GB/s)
>>> VFIO UNMAP DMA in 0.303 s (52.9 GB/s)
>>> ------- AVERAGE (HUGETLBFS) --------
>>> VFIO MAP DMA in 0.032 s (506.8 GB/s)
>>> VFIO UNMAP DMA in 0.049 s (326.7 GB/s)
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
>>>     drivers/vfio/vfio_iommu_type1.c | 55 +++++++++++++++++++++++++++------
>>>     1 file changed, 46 insertions(+), 9 deletions(-)
>>>
>>> diff --git a/drivers/vfio/vfio_iommu_type1.c b/drivers/vfio/vfio_iommu_type1.c
>>> index e952bf8bdfab..09ecc546ece8 100644
>>> --- a/drivers/vfio/vfio_iommu_type1.c
>>> +++ b/drivers/vfio/vfio_iommu_type1.c
>>> @@ -469,17 +469,28 @@ static bool is_invalid_reserved_pfn(unsigned long pfn)
>>>     	return true;
>>>     }
>>>     
>>> -static int put_pfn(unsigned long pfn, int prot)
>>> +static inline void _put_pfns(struct page *page, int npages, int prot)
>>>     {
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
>>>     	}
>>>     	return 0;
>>>     }
>>>     
>>> +static inline int put_pfn(unsigned long pfn, int prot)
>>> +{
>>> +	return put_pfns(pfn, 1, prot);
>>> +}
>>> +
>>>     #define VFIO_BATCH_MAX_CAPACITY (PAGE_SIZE / sizeof(struct page *))
>>>     
>>>     static void __vfio_batch_init(struct vfio_batch *batch, bool single)
>>> @@ -806,11 +817,37 @@ static long vfio_unpin_pages_remote(struct vfio_dma *dma, dma_addr_t iova,
>>>     				    bool do_accounting)
>>>     {
>>>     	long unlocked = 0, locked = vpfn_pages(dma, iova, npage);
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
> 
> Just to add to this: unpin_user_page_range_dirty_lock() is not
> universally save in the hugetlb scenario I described.

Correction: it is, because gup_folio_range_next() uses "nth_page".

So this should work.

-- 
Cheers,

David / dhildenb


