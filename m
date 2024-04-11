Return-Path: <kvm+bounces-14239-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id D07C28A10E5
	for <lists+kvm@lfdr.de>; Thu, 11 Apr 2024 12:39:21 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 86268282D2B
	for <lists+kvm@lfdr.de>; Thu, 11 Apr 2024 10:39:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E8FB41494AF;
	Thu, 11 Apr 2024 10:38:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="UBBlDhoy"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 80068146A72
	for <kvm@vger.kernel.org>; Thu, 11 Apr 2024 10:38:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712831910; cv=none; b=Kq2y7zf8KArL9R1AU82emQq6ThOr7JBBn2k/o2YAKR6Ix1RgUdfa4jXc3N1Gl0le1tjuY4BLjdpy6MxEIpmRLg9QC/+oLOcMBJOwkeTj94oXPFrjJHIn74OdDROYU0gxK6eFCwoipxbyIGdDHBqVBkzrfsUtsuexmEdr6uiopvg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712831910; c=relaxed/simple;
	bh=A36ZAloLwaYSGQai3GcnLMWmp+ye1CTGensaBkn7/es=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=U0IuVRQ2kafo+x/NgKVCXZjQTRpo/it4QwmsPFDxkhnTJozXrP4eQ29lAJgDIhhGkPOZIIow1gHglxV3RIQwxoNQLNhcNTxQV8FMH7PXuMQ/eVIF2+3krRzdDPlLKfLmJR6pzJgZ3B87M/JjkwnPaqxQ3HvVc9qk22E3NNG7Zuk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=UBBlDhoy; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1712831905;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=7JcOYshX9ei46X4mRDWaaw3M19ekCpvyRkfUCo7ditw=;
	b=UBBlDhoyaXFyhGzDUXTwxg/m2+ew78Kg2mtcCgWFJlTDlP1RcSaZ2i4A8K/FWQyJDRxbPA
	wkH9JX8c/kvScOXaUHorPzzgd5A9MyjfAQC60BvBrG/uDrSQoyXTJGP24wFQRFRtmtgkcX
	+puFvmzZUlLuWq2bam5yWiurDYJVaT4=
Received: from mail-ej1-f70.google.com (mail-ej1-f70.google.com
 [209.85.218.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-643-KLB4-pv2OwWAOdVfncNDxg-1; Thu, 11 Apr 2024 06:38:21 -0400
X-MC-Unique: KLB4-pv2OwWAOdVfncNDxg-1
Received: by mail-ej1-f70.google.com with SMTP id a640c23a62f3a-a5190b1453fso475508866b.2
        for <kvm@vger.kernel.org>; Thu, 11 Apr 2024 03:38:20 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1712831899; x=1713436699;
        h=content-transfer-encoding:in-reply-to:organization:autocrypt
         :content-language:from:references:cc:to:subject:user-agent
         :mime-version:date:message-id:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=7JcOYshX9ei46X4mRDWaaw3M19ekCpvyRkfUCo7ditw=;
        b=BWOK/rmb/5YrkH6j+/9Cf01c+wPWOOWf57frPdAVLLz3P+mvax/JN4PPBO3k4ApVFh
         /kPRq0Smy/sAq3mMRVUe1jdGNfb0uhCPpnR06NOG3HiH+qkvNwkpWTw8yOhQlFp54sJU
         ZbdiMny1l2lJUkYN2cHbr8EL5ECQvFwbbrOd6DjWlcduXCZBIKgA8wwHQhvTj+alGOsx
         XsbOTG05Qs8jIHMNgxtRisPl+yqxP5Dspvx66Q13MeI0BaWnyUY1+zVRvvEY04sbp0+F
         roxsMMZvTAMumbxriwPqPQx0fXlGBZ6lv8R9vH3VAYkR6mMy3Y3hI0cNRSaJSM1E8G85
         WrPA==
X-Forwarded-Encrypted: i=1; AJvYcCVZY5BDKhrR/UnKCOETv27U18ulIEi/BCcjzv8EyGXMyu6M2PbhMUPDF3rOvl97AluWagxj9PVRwdCr7vc1OPxgbu1I
X-Gm-Message-State: AOJu0YxrPbx2am+KaZHRD/AieSLODxSoEl0tJfqoTovqmkOpGGLrHosM
	0weNgt1+VcR7ScZ63qP3+ad+0KkQJoZluyzBvhWVMUEvYoXsLXfk/rUelaL6bZU34MNd9OkjC5K
	9mVRIfh1lLZ4JGRZegaenw9/VmzlpzC2bBXvxmPcwBpDd4cyvgQ==
X-Received: by 2002:a17:906:e294:b0:a51:cdfd:8ef7 with SMTP id gg20-20020a170906e29400b00a51cdfd8ef7mr3022203ejb.39.1712831898974;
        Thu, 11 Apr 2024 03:38:18 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGH485Wl09TCGoI26RjLOHyTRD9RSVVHCBLzAhCODunIyB30xmD8xJHN/RRwNBFo35wXu/Pcg==
X-Received: by 2002:a17:906:e294:b0:a51:cdfd:8ef7 with SMTP id gg20-20020a170906e29400b00a51cdfd8ef7mr3022178ejb.39.1712831898539;
        Thu, 11 Apr 2024 03:38:18 -0700 (PDT)
Received: from ?IPV6:2003:cb:c724:4300:430f:1c83:1abc:1d66? (p200300cbc7244300430f1c831abc1d66.dip0.t-ipconnect.de. [2003:cb:c724:4300:430f:1c83:1abc:1d66])
        by smtp.gmail.com with ESMTPSA id iv18-20020a05600c549200b004174ff337f4sm1937619wmb.7.2024.04.11.03.38.17
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 11 Apr 2024 03:38:18 -0700 (PDT)
Message-ID: <c9bfaf90-d744-4371-8f6f-5739f3373072@redhat.com>
Date: Thu, 11 Apr 2024 12:38:17 +0200
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v1 3/5] s390/uv: convert PG_arch_1 users to only work on
 small folios
To: Claudio Imbrenda <imbrenda@linux.ibm.com>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
 linux-s390@vger.kernel.org, kvm@vger.kernel.org,
 Matthew Wilcox <willy@infradead.org>, Heiko Carstens <hca@linux.ibm.com>,
 Vasily Gorbik <gor@linux.ibm.com>, Alexander Gordeev
 <agordeev@linux.ibm.com>, Christian Borntraeger <borntraeger@linux.ibm.com>,
 Sven Schnelle <svens@linux.ibm.com>, Janosch Frank <frankja@linux.ibm.com>,
 Gerald Schaefer <gerald.schaefer@linux.ibm.com>,
 Thomas Huth <thuth@redhat.com>
References: <20240404163642.1125529-1-david@redhat.com>
 <20240404163642.1125529-4-david@redhat.com>
 <20240410194236.1c89eb7d@p-imbrenda>
From: David Hildenbrand <david@redhat.com>
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
In-Reply-To: <20240410194236.1c89eb7d@p-imbrenda>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 10.04.24 19:42, Claudio Imbrenda wrote:
> On Thu,  4 Apr 2024 18:36:40 +0200
> David Hildenbrand <david@redhat.com> wrote:
> 
>> Now that make_folio_secure() may only set PG_arch_1 for small folios,
>> let's convert relevant remaining UV code to only work on (small) folios
>> and simply reject large folios early. This way, we'll never end up
>> touching PG_arch_1 on tail pages of a large folio in UV code.
>>
>> The folio_get()/folio_put() for functions that are documented to already
>> hold a folio reference look weird and it should probably be removed.
>> Similarly, uv_destroy_owned_page() and uv_convert_owned_from_secure()
>> should really consume a folio reference instead. But these are cleanups for
>> another day.
>>
>> Signed-off-by: David Hildenbrand <david@redhat.com>
>> ---
>>   arch/s390/include/asm/page.h |  1 +
>>   arch/s390/kernel/uv.c        | 39 +++++++++++++++++++++---------------
>>   2 files changed, 24 insertions(+), 16 deletions(-)
>>
>> diff --git a/arch/s390/include/asm/page.h b/arch/s390/include/asm/page.h
>> index 54d015bcd8e3..b64384872c0f 100644
>> --- a/arch/s390/include/asm/page.h
>> +++ b/arch/s390/include/asm/page.h
>> @@ -214,6 +214,7 @@ static inline unsigned long __phys_addr(unsigned long x, bool is_31bit)
>>   #define pfn_to_phys(pfn)	((pfn) << PAGE_SHIFT)
>>   
>>   #define phys_to_page(phys)	pfn_to_page(phys_to_pfn(phys))
>> +#define phys_to_folio(phys)	page_folio(phys_to_page(phys))
>>   #define page_to_phys(page)	pfn_to_phys(page_to_pfn(page))
>>   #define folio_to_phys(page)	pfn_to_phys(folio_pfn(folio))
>>   
>> diff --git a/arch/s390/kernel/uv.c b/arch/s390/kernel/uv.c
>> index adcbd4b13035..9c0113b26735 100644
>> --- a/arch/s390/kernel/uv.c
>> +++ b/arch/s390/kernel/uv.c
>> @@ -134,14 +134,17 @@ static int uv_destroy_page(unsigned long paddr)
>>    */
>>   int uv_destroy_owned_page(unsigned long paddr)
>>   {
>> -	struct page *page = phys_to_page(paddr);
>> +	struct folio *folio = phys_to_folio(paddr);
>>   	int rc;
>>   
>> -	get_page(page);
>> +	if (unlikely(folio_test_large(folio)))
>> +		return 0;
> 
> please add a comment here to explain why it's ok to just return 0
> here...


Will use

"/* See gmap_make_secure(): large folios cannot be protected */"

> 
>> +
>> +	folio_get(folio);
>>   	rc = uv_destroy_page(paddr);
>>   	if (!rc)
>> -		clear_bit(PG_arch_1, &page->flags);
>> -	put_page(page);
>> +		clear_bit(PG_arch_1, &folio->flags);
>> +	folio_put(folio);
>>   	return rc;
>>   }
>>   
>> @@ -169,14 +172,17 @@ int uv_convert_from_secure(unsigned long paddr)
>>    */
>>   int uv_convert_owned_from_secure(unsigned long paddr)
>>   {
>> -	struct page *page = phys_to_page(paddr);
>> +	struct folio *folio = phys_to_folio(paddr);
>>   	int rc;
>>   
>> -	get_page(page);
>> +	if (unlikely(folio_test_large(folio)))
>> +		return 0;
> 
> ... and here

here as well and ...

> 
>> +
>> +	folio_get(folio);
>>   	rc = uv_convert_from_secure(paddr);
>>   	if (!rc)
>> -		clear_bit(PG_arch_1, &page->flags);
>> -	put_page(page);
>> +		clear_bit(PG_arch_1, &folio->flags);
>> +	folio_put(folio);
>>   	return rc;
>>   }
>>   
>> @@ -457,33 +463,34 @@ EXPORT_SYMBOL_GPL(gmap_destroy_page);
>>    */
>>   int arch_make_page_accessible(struct page *page)
>>   {
>> +	struct folio *folio = page_folio(page);
>>   	int rc = 0;
>>   
>> -	/* Hugepage cannot be protected, so nothing to do */
>> -	if (PageHuge(page))
>> +	/* Large folios cannot be protected, so nothing to do */

^ here as well.

>> +	if (unlikely(folio_test_large(folio)))
>>   		return 0;
>>   

-- 
Cheers,

David / dhildenb


