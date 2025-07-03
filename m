Return-Path: <kvm+bounces-51476-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 996CFAF71BE
	for <lists+kvm@lfdr.de>; Thu,  3 Jul 2025 13:10:06 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 830831687A4
	for <lists+kvm@lfdr.de>; Thu,  3 Jul 2025 11:07:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5CDD82D0C70;
	Thu,  3 Jul 2025 11:07:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="W3MY5Lzw"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DC5B123BF8F
	for <kvm@vger.kernel.org>; Thu,  3 Jul 2025 11:07:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751540840; cv=none; b=E0kZ27mbpe0ClLwM93yFz5GeVi76r9yfXwtgGIaLSjEn+KDN+SRlUaeaLP+bTh/lg6CbPZCyLZyYC6nU5Kg5iuWtMMAzPCXoC9iQLqkZYXw7F/ucsfb/A4YCYmoSXFKoPDTWtaaIRa4HNSVfi6XEa+ga/TwkWoK+Lb/zthYMuGk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751540840; c=relaxed/simple;
	bh=r+oqXIqw8qmyS+u2KpND911TTLofAjnGxEz1wNX+R5I=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=XvcHCIesHv4FDI7bb7wOaZl+orDRnna/IhqXeRUN2sbpRlOWJ7/QYi85uNoFH6UevPwMvMq/NuDTAO0RSnyxxdyZUsv1TzJyOuASztZKpqDFWFlF5F/YGizK+QMwoOrIhSSiRSqK13WRMmzkkKSYS5GJO2DwewNeKYXm1/o03m0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=W3MY5Lzw; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1751540837;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=HsHhtfxwP4AkJ0C4R+XbbC4W0huoGibBzxG5SHnup00=;
	b=W3MY5LzwbRsmo5QlMp2duj0IS7rEvzlHK6jYJ1IWHrZ3xeUaNIsRQ868QsBJdg80j9hPql
	PDGNUTb6cyr2FR3UHar0e6e/fFAruOBemm0NCRrD4qmu9fwULJ72swLlyllnqnUJPE5Gpz
	4O2F+8WE/psXFZ42vfK98zY/4L/KEQw=
Received: from mail-ej1-f72.google.com (mail-ej1-f72.google.com
 [209.85.218.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-490-tp8wmeTeNd2ve5wl2GlAKA-1; Thu, 03 Jul 2025 07:06:29 -0400
X-MC-Unique: tp8wmeTeNd2ve5wl2GlAKA-1
X-Mimecast-MFC-AGG-ID: tp8wmeTeNd2ve5wl2GlAKA_1751540788
Received: by mail-ej1-f72.google.com with SMTP id a640c23a62f3a-acb94dbd01fso433767366b.1
        for <kvm@vger.kernel.org>; Thu, 03 Jul 2025 04:06:29 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1751540788; x=1752145588;
        h=content-transfer-encoding:in-reply-to:organization:autocrypt
         :content-language:from:references:cc:to:subject:user-agent
         :mime-version:date:message-id:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=HsHhtfxwP4AkJ0C4R+XbbC4W0huoGibBzxG5SHnup00=;
        b=J9XIWniIRT4yI4j1baCA0x2vkKZFlPnL8HbPLecSmFFNCMouWD2zAY/t9ja79vknrf
         FOxqOprbj9n4cZhx1IpUD+ZT4Zg6tYIOfsuz5O674sgJaUF5mm0n4VC9cnc76Qa7RfUz
         W8EZcm4YEQzkifErc8Vc/tXZ8JJwUlF0CN1xHUyb6FGZRTlT/ODdsBe6TPBZNn2UsIgh
         bu7jBRXQL99p/jmieBTdkWNlbuuLOwzl2fEokinGmX3pLUvV5f7co0U/nTmNDRpxUY7m
         EM4dD1zvqyiQFPiApYcRWRAh6nzw27yAtkG/3xYxu/c5sz1YvhfI/8wUm5vJEUkxgHxg
         3mIw==
X-Forwarded-Encrypted: i=1; AJvYcCXardxg7BLAjDX1T/GVKLs/u5d6VafyVALQNTznK9jYiLF8IoCL7sU6Z9vu4wAvp36N6KQ=@vger.kernel.org
X-Gm-Message-State: AOJu0Yx4TDKikNHHc+ktsgHnlD0xZ4FB0nmLWW5DrenD5WzurpVaEYJr
	G7nQ6p5U1qIEogYpNi/GP6sZupO1TAdlV1T2r1FOr/508/Ync7UIcaAbbaOLllaj2jObedaZiEF
	VVMVszVoiKEg8FNznlAVETaPUSyyr6+9as1INA6wk1swk0wTUWPsnhQ==
X-Gm-Gg: ASbGncvpXvLs3H4WH2Zxw/dNalNsRUurnEDG1MR8qVs0fsOrDTlkdIhXxRD96TdLaCk
	hWcka/iYmE0qPq7O+1kbSZ6WlCmfkaD4pi+XSuyYh0pjmFNg/2Rr4LsyspzN9GlLKxbiXfeyy87
	BYVrc4t4mhvNRyneGaUTdzdfyEaSJtcR3G4M5UmFFVBc1bvYb1u80y9qm0sg+TmoQy9GX4OAV5e
	I03NXPKrfHtfTn+flEYoFRNwxcKTpdEoPsYmBsHhkXDvQfbKnHJKke8GKR8UCG5R/Gt2eeZ12nx
	HHQ0aBctCyZIaePBq+LXKJ93+wR6/+yN41wcrlmZwYge
X-Received: by 2002:a17:907:a088:b0:ad8:9c97:c2da with SMTP id a640c23a62f3a-ae3d8573490mr273226466b.40.1751540788048;
        Thu, 03 Jul 2025 04:06:28 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEVvp9Sw667LoyN8pe3RF8JIiHhiLdr0Wi9Bk4IMrJCFkoPHPGrLe5Nzh71vgQ6iT9qRpi8Qg==
X-Received: by 2002:a17:907:a088:b0:ad8:9c97:c2da with SMTP id a640c23a62f3a-ae3d8573490mr273224366b.40.1751540787592;
        Thu, 03 Jul 2025 04:06:27 -0700 (PDT)
Received: from [10.32.64.156] (nat-pool-muc-t.redhat.com. [149.14.88.26])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-ae35365a923sm1264922066b.68.2025.07.03.04.06.26
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 03 Jul 2025 04:06:26 -0700 (PDT)
Message-ID: <664e5604-fe7c-449f-bb2a-48c9543fecf4@redhat.com>
Date: Thu, 3 Jul 2025 13:06:26 +0200
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 0/4] vfio/type1: optimize vfio_pin_pages_remote() and
 vfio_unpin_pages_remote() for large folio
To: lizhe.67@bytedance.com
Cc: alex.williamson@redhat.com, jgg@nvidia.com, jgg@ziepe.ca,
 kvm@vger.kernel.org, linux-kernel@vger.kernel.org, peterx@redhat.com
References: <c1144447-6b67-48d3-b37c-5f1ca6a9b4a7@redhat.com>
 <20250703035425.36124-1-lizhe.67@bytedance.com>
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
In-Reply-To: <20250703035425.36124-1-lizhe.67@bytedance.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 03.07.25 05:54, lizhe.67@bytedance.com wrote:
> On Wed, 2 Jul 2025 11:57:08 +0200, david@redhat.com wrote:
> 
>> On 02.07.25 11:38, lizhe.67@bytedance.com wrote:
>>> On Wed, 2 Jul 2025 10:15:29 +0200, david@redhat.com wrote:
>>>
>>>> Jason mentioned in reply to the other series that, ideally, vfio
>>>> shouldn't be messing with folios at all.
>>>>
>>>> While we now do that on the unpin side, we still do it at the pin side.
>>>
>>> Yes.
>>>
>>>> Which makes me wonder if we can avoid folios in patch #1 in
>>>> contig_pages(), and simply collect pages that correspond to consecutive
>>>> PFNs.
>>>
>>> In my opinion, comparing whether the pfns of two pages are contiguous
>>> is relatively inefficient. Using folios might be a more efficient
>>> solution.
>>
>> 	buffer[i + 1] == nth_page(buffer[i], 1)
>>
>> Is extremely efficient, except on
>>
>> 	#if defined(CONFIG_SPARSEMEM) && !defined(CONFIG_SPARSEMEM_VMEMMAP)
>>
>> Because it's essentially
>>
>> 	buffer[i + 1] == buffer[i] + 1
>>
>> But with that config it's less efficient
>>
>> 	buffer[i + 1] == pfn_to_page(page_to_pfn(buffer[i]) + 1)
>>
>> That could be optimized (if we care about the config), assuming that we don't cross
>> memory sections (e.g., 128 MiB on x86).
>>
>> See page_ext_iter_next_fast_possible(), that optimized for something similar.
>>
>> So based on the first page, one could easily determine how far to batch
>> using the simple
>>
>> 	buffer[i + 1] == buffer[i] + 1
>>
>> comparison.
>>
>> That would mean that one could exceed a folio, in theory.
> 
> Thank you very much for your suggestion. I think we can focus on
> optimizing the case where
> 
> !(defined(CONFIG_SPARSEMEM) && !defined(CONFIG_SPARSEMEM_VMEMMAP))
> 
> I believe that in most scenarios where vfio is used,
> CONFIG_SPARSEMEM_VMEMMAP is enabled. Excessive CONFIG
> may make the patch appear overly complicated.
> 
>>> Given that 'page' is already in use within vfio, it seems that adopting
>>> 'folio' wouldn't be particularly troublesome? If you have any better
>>> suggestions, I sincerely hope you would share them with me.
>>
>> One challenge in the future will likely be that not all pages that we can
>> GUP will belong to folios. We would possibly be able to handle that by
>> checking if the page actually belongs to a folio.
>>
>> Not dealing with folios where avoidable would be easier.
>>
>>>
>>>> What was the reason again, that contig_pages() would not exceed a single
>>>> folio?
>>>
>>> Regarding this issue, I think Alex and I are on the same page[1]. For a
>>> folio, all of its pages have the same invalid or reserved state. In
>>> the function vfio_pin_pages_remote(), we need to ensure that the state
>>> is the same as the previous pfn (through variable 'rsvd' and function
>>> is_invalid_reserved_pfn()). Therefore, we do not want the return value
>>> of contig_pages() to exceed a single folio.
>>
>> If we obtained a page from GUP, is_invalid_reserved_pfn() would only trigger
>> for the shared zeropage. but that one can no longer be returned from FOLL_LONGTERM.
>>
>> So if you know the pages came from GUP, I would assume they are never invalid_reserved?
> 
> Yes, we use function vaddr_get_pfns(), which ultimately invokes GUP
> with the FOLL_LONGTERM flag.
> 
>> Again, just a thought on how to apply something similar as done for the unpin case, avoiding
>> messing with folios.
> 
> Taking into account the previous discussion, it seems that we might
> simply replace the contig_pages() in patch #1 with the following one.
> Also, function contig_pages() could also be extracted into mm.h as a
> helper function. It seems that Jason would like to utilize it in other
> contexts. Moreover, the subject of this patchset should be changed to
> "Optimize vfio_pin_pages_remote() and vfio_unpin_pages_remote()". Do
> you think this would work?
> 
> +static inline unsigned long contig_pages(struct page **pages,
> +					 unsigned long size)

size -> nr_pages

> +{
> +	struct page *first_page = pages[0];
> +	unsigned long i;
> +
> +	for (i = 1; i < size; i++)
> +		if (pages[i] != nth_page(first_page, i))
> +			break;
> +	return i;
> +}

LGTM.

I wonder if we can find a better function name, especially when moving 
this to some header where it can be reused.

Something that expresses that we will return the next batch that starts 
at the first page.

-- 
Cheers,

David / dhildenb


