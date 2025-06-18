Return-Path: <kvm+bounces-49827-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id E13A8ADE61C
	for <lists+kvm@lfdr.de>; Wed, 18 Jun 2025 10:55:02 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id C9380188ED2D
	for <lists+kvm@lfdr.de>; Wed, 18 Jun 2025 08:55:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AA16427FB38;
	Wed, 18 Jun 2025 08:54:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="JKjy/g+F"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E5E2727F00B
	for <kvm@vger.kernel.org>; Wed, 18 Jun 2025 08:54:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750236888; cv=none; b=gNKOfPver9BXe2NSHLLGiwPQZvUYQujnaho856wGHxDRrECKWtMN0r7Us+8lVjKmmaOXmfPPoGQe9kSQu9aFkMEy/GRg4/Ays1BesYjEBde4WXEhV38uFZCjwQEaWftvNrYgVArUuPbZc3RjvoWw2OTt8Xa/RKaOcwJwmg1lt5M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750236888; c=relaxed/simple;
	bh=VQGX59JbhGX6UWZ9ws6mzn2PEWEVhZGZh0oSJnxPfMg=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=OQezXVEBg2bA8L1J39aigZW4nKBktcfabAs/cfBZM0zz86aODKdWa+bg88Z4M4d5hXbqxbmxRjXJRiIRvoSyj7SW9HaFg1cbfRQi5qfVgtuuSxM61Tz16sJLUhe8uq/GyMmkUc+uUveuHQUARDlQ6BXs7HNjlUVjaUgDDGckss0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=JKjy/g+F; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1750236884;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=d/nghTGDTYOnDsynCfFezJUuOXV1tIgNlMUFaPY/hgs=;
	b=JKjy/g+FwpxOCWWqjW6o1bb1vLseZG5HmTd4ZP5D4+KKxLnHwPEqNcsvpLlgshdh+CzVkA
	sYtTkaxZH3zpCyxfdHw4BRm/Gqs3HY8PG5dnW47K79/e9zWwcSkL+ldCM9fc+vECcqhwlz
	o/yjxnI5OeN5EFy2jXjH4h1dOASV/H8=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-102-DZBTSUwbO3qqBDL-dgJ4Ig-1; Wed, 18 Jun 2025 04:54:43 -0400
X-MC-Unique: DZBTSUwbO3qqBDL-dgJ4Ig-1
X-Mimecast-MFC-AGG-ID: DZBTSUwbO3qqBDL-dgJ4Ig_1750236880
Received: by mail-wr1-f70.google.com with SMTP id ffacd0b85a97d-3a4f8fd1856so3240903f8f.2
        for <kvm@vger.kernel.org>; Wed, 18 Jun 2025 01:54:41 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1750236880; x=1750841680;
        h=content-transfer-encoding:in-reply-to:organization:autocrypt
         :content-language:from:references:cc:to:subject:user-agent
         :mime-version:date:message-id:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=d/nghTGDTYOnDsynCfFezJUuOXV1tIgNlMUFaPY/hgs=;
        b=lk9daGPsQxcjEVevZz/M9TA6CkVOOpqJkooI/JkW8UfBiUFKBmkneWmgf0yvZ3gpUY
         1KvcY4lrQ9dSbiLBZU8C15j+vlUiM23dmkifL+EHRQMpDRwZCnmRG7RsvyGb1vn36ChV
         5HvcgPryMafuIF0tH2lDb/zjwGzhz3i/JwF4lUTsMnucLY/O3GLaTsgOyotF3eCEjeF6
         WWyxwAisktOZxrqOcFgbatuptlbX5VezBycAbrN4ZlRTbIUPL3o6CGE3lSg3mFFHqXxY
         WG/cOqI8VN5eXxdON+0hzVKWjvXLTq+6OqHtTd9jGYtyoUPK+2GgXx0q8nAllRCJj3Ox
         7iBw==
X-Forwarded-Encrypted: i=1; AJvYcCXTLCpXSMzl1B/RHbfSdOmZ9J6H1Eic3/bpYdpu7dAvyUHmuhNvZjKx8vu0wFlXNVB2Xk8=@vger.kernel.org
X-Gm-Message-State: AOJu0YzvjuE6bt09jThByuKxS9AhjnTKdZlKkweORgD6qHLntXXaRnmG
	f4TssghV944jqiMFpJ54SJwCHXyFW8eb18SBh2egSQXNLLBCao9HwZG7rW+07MgQ7Wnguoh7LnZ
	N2EMKowuqN5lsRfJf1uRWa5qHLsVa0N6nudq27vWIsEcuJiS0+f0+uA==
X-Gm-Gg: ASbGnctyE+zcD018cwJm/bqjXDfWdSweQjkDfY/Z9yiPfVrv22ECzj8FIRr9KLuVf2+
	XWb4mbDkpDE2MU9FezaufiKtQJ8tqK3p4D81z1aC+pZW/Mpqj6tkmPYmoXhgtKOgIHlrLshSB6q
	xc9msxVxybqnrGHvnacm98Wq+Ha21z/xOKz2XqKiNzC29B3fVViTUAfopVmC4iXCYnjgc+72c+V
	nZ+zvkRq4CsIBGav0ZSHqeFK1p0cGa+QpBv8v+Rd9o2OaQAaBKMWuPkAeFB5nfBoAmi37mTuO49
	3E+w1nSnKJeofoB048NzDVF2u8JN3GDuQsrKFz2h7GGiVIZGEeUs8bs6QaoxDsjpplqbo+GXXag
	WJy3Wdy92fCD6gA7mZKDku8/BdtxT3717wf1N9tep7EnE2Gs=
X-Received: by 2002:a05:6000:2504:b0:3a4:f435:5801 with SMTP id ffacd0b85a97d-3a572371781mr13218832f8f.17.1750236879966;
        Wed, 18 Jun 2025 01:54:39 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IECGT6yHM/551JPnGWgCimCdk1Q7WAgaERtkxVM1QlBZ7xwWWlzCpkF3RK3HUAnQpq+qIMu5w==
X-Received: by 2002:a05:6000:2504:b0:3a4:f435:5801 with SMTP id ffacd0b85a97d-3a572371781mr13218811f8f.17.1750236879514;
        Wed, 18 Jun 2025 01:54:39 -0700 (PDT)
Received: from ?IPV6:2003:d8:2f2d:2400:4052:3b5:fff9:4ed0? (p200300d82f2d2400405203b5fff94ed0.dip0.t-ipconnect.de. [2003:d8:2f2d:2400:4052:3b5:fff9:4ed0])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3a568a547d2sm16662553f8f.19.2025.06.18.01.54.38
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 18 Jun 2025 01:54:39 -0700 (PDT)
Message-ID: <58f9d004-918d-4f66-85e7-d090db0af5de@redhat.com>
Date: Wed, 18 Jun 2025 10:54:38 +0200
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 3/3] vfio/type1: optimize vfio_unpin_pages_remote() for
 large folio
To: lizhe.67@bytedance.com
Cc: akpm@linux-foundation.org, alex.williamson@redhat.com,
 kvm@vger.kernel.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org,
 peterx@redhat.com
References: <ce2af146-499b-4fce-8095-6c5471fdf288@redhat.com>
 <20250618061143.6470-1-lizhe.67@bytedance.com>
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
In-Reply-To: <20250618061143.6470-1-lizhe.67@bytedance.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 18.06.25 08:11, lizhe.67@bytedance.com wrote:
> On Tue, 17 Jun 2025 15:47:09 +0200, david@redhat.com wrote:
>   
>>> How do you think of this implementation?
>>>
>>> diff --git a/include/linux/mm.h b/include/linux/mm.h
>>> index 242b05671502..eb91f99ea973 100644
>>> --- a/include/linux/mm.h
>>> +++ b/include/linux/mm.h
>>> @@ -2165,6 +2165,23 @@ static inline long folio_nr_pages(const struct folio *folio)
>>>           return folio_large_nr_pages(folio);
>>>    }
>>>    
>>> +/*
>>> + * folio_remaining_pages - Counts the number of pages from a given
>>> + * start page to the end of the folio.
>>> + *
>>> + * @folio: Pointer to folio
>>> + * @start_page: The starting page from which to begin counting.
>>> + *
>>> + * Returned number includes the provided start page.
>>> + *
>>> + * The caller must ensure that @start_page belongs to @folio.
>>> + */
>>> +static inline unsigned long folio_remaining_pages(struct folio *folio,
>>> +               struct page *start_page)
>>> +{
>>> +       return folio_nr_pages(folio) - folio_page_idx(folio, start_page);
>>> +}
>>> +
>>>    /* Only hugetlbfs can allocate folios larger than MAX_ORDER */
>>>    #ifdef CONFIG_ARCH_HAS_GIGANTIC_PAGE
>>>    #define MAX_FOLIO_NR_PAGES     (1UL << PUD_ORDER)
>>> diff --git a/mm/gup.c b/mm/gup.c
>>> index 15debead5f5b..14ae2e3088b4 100644
>>> --- a/mm/gup.c
>>> +++ b/mm/gup.c
>>> @@ -242,7 +242,7 @@ static inline struct folio *gup_folio_range_next(struct page *start,
>>>    
>>>           if (folio_test_large(folio))
>>>                   nr = min_t(unsigned int, npages - i,
>>> -                          folio_nr_pages(folio) - folio_page_idx(folio, next));
>>> +                          folio_remaining_pages(folio, next));
>>>    
>>>           *ntails = nr;
>>>           return folio;
>>> diff --git a/mm/page_isolation.c b/mm/page_isolation.c
>>> index b2fc5266e3d2..34e85258060c 100644
>>> --- a/mm/page_isolation.c
>>> +++ b/mm/page_isolation.c
>>> @@ -96,7 +96,7 @@ static struct page *has_unmovable_pages(unsigned long start_pfn, unsigned long e
>>>                                   return page;
>>>                           }
>>>    
>>> -                       skip_pages = folio_nr_pages(folio) - folio_page_idx(folio, page);
>>> +                       skip_pages = folio_remaining_pages(folio, page);
>>>                           pfn += skip_pages - 1;
>>>                           continue;
>>>                   }
>>> ---
>>
>> Guess I would have pulled the "min" in there, but passing something like
>> ULONG_MAX for the page_isolation case also looks rather ugly.
> 
> Yes, the page_isolation case does not require the 'min' logic. Since
> there are already places in the current kernel code where
> folio_remaining_pages() is used without needing min, we could simply
> create a custom wrapper function based on folio_remaining_pages() only
> in those specific scenarios where min is necessary.

I would just do something like that, removing gup_folio_range_next() completely.

diff --git a/include/linux/mm.h b/include/linux/mm.h
index 98a606908307b..6c224b1c6c169 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -1995,6 +1995,32 @@ static inline long folio_nr_pages(const struct folio *folio)
  	return folio_large_nr_pages(folio);
  }
  
+/**
+ * folio_remaining_pages - The remaining number of pages in the folio.
+ * @folio: The folio.
+ * @page: The folio page to start the counting.
+ * @max_npages: Limit how far to count.
+ *
+ * The returned number will include the provided page.
+ *
+ * The caller must ensure that @page belongs to @folio. When setting
+ * @max_npages to ULONG_MAX, the parameter is effectively ignored.
+ *
+ * Return: The remaining number of pages, limited by @max_npages.
+ */
+static inline unsigned long folio_remaining_pages(struct folio *folio,
+		struct page *page, unsigned long max_npages)
+{
+	unsigned long nr;
+
+	if (!folio_test_large(folio))
+		return 1;
+	nr = folio_large_nr_pages(folio) - folio_page_idx(folio, page);
+	if (__builtin_constant_p(max_npages) && max_npages == ULONG_MAX)
+		return nr;
+	return min_t(unsigned long, nr, max_npages);
+}
+
  /* Only hugetlbfs can allocate folios larger than MAX_ORDER */
  #ifdef CONFIG_ARCH_HAS_GIGANTIC_PAGE
  #define MAX_FOLIO_NR_PAGES	(1UL << PUD_ORDER)
diff --git a/mm/gup.c b/mm/gup.c
index 6888e871a74a9..3385428d028f6 100644
--- a/mm/gup.c
+++ b/mm/gup.c
@@ -234,21 +234,6 @@ void folio_add_pin(struct folio *folio)
  	}
  }
  
-static inline struct folio *gup_folio_range_next(struct page *start,
-		unsigned long npages, unsigned long i, unsigned int *ntails)
-{
-	struct page *next = nth_page(start, i);
-	struct folio *folio = page_folio(next);
-	unsigned int nr = 1;
-
-	if (folio_test_large(folio))
-		nr = min_t(unsigned int, npages - i,
-			   folio_nr_pages(folio) - folio_page_idx(folio, next));
-
-	*ntails = nr;
-	return folio;
-}
-
  static inline struct folio *gup_folio_next(struct page **list,
  		unsigned long npages, unsigned long i, unsigned int *ntails)
  {
@@ -356,11 +341,13 @@ void unpin_user_page_range_dirty_lock(struct page *page, unsigned long npages,
  				      bool make_dirty)
  {
  	unsigned long i;
-	struct folio *folio;
  	unsigned int nr;
  
  	for (i = 0; i < npages; i += nr) {
-		folio = gup_folio_range_next(page, npages, i, &nr);
+		struct page *next = nth_page(page, i);
+		struct folio *folio = page_folio(next);
+
+		nr = folio_remaining_pages(folio, next, npages - i);
  		if (make_dirty && !folio_test_dirty(folio)) {
  			folio_lock(folio);
  			folio_mark_dirty(folio);
diff --git a/mm/page_isolation.c b/mm/page_isolation.c
index ece3bfc56bcd5..6f75defb38d73 100644
--- a/mm/page_isolation.c
+++ b/mm/page_isolation.c
@@ -96,7 +96,7 @@ static struct page *has_unmovable_pages(unsigned long start_pfn, unsigned long e
  				return page;
  			}
  
-			skip_pages = folio_nr_pages(folio) - folio_page_idx(folio, page);
+			skip_pages = folio_remaining_pages(folio, page, ULONG_MAX);
  			pfn += skip_pages - 1;
  			continue;
  		}
-- 


But up to you, anything with such a helper function makes the code easier to digest.

-- 
Cheers,

David / dhildenb


