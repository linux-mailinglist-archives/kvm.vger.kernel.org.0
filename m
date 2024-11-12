Return-Path: <kvm+bounces-31673-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 6ADA99C642A
	for <lists+kvm@lfdr.de>; Tue, 12 Nov 2024 23:19:36 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 74766B39D4F
	for <lists+kvm@lfdr.de>; Tue, 12 Nov 2024 21:36:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3857921A4C7;
	Tue, 12 Nov 2024 21:35:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="jDZXjxEU"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4096820BB59
	for <kvm@vger.kernel.org>; Tue, 12 Nov 2024 21:35:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731447357; cv=none; b=aqznFrJwbrDsBvgCvPruTNrNxOKbiJ3Mepw4KAIa9wMB84K4P3o2KKNaX4/4Wbi18W5WgJ8iIQZtMtLLb9KZSr008ZVAe/GvS08TbPnipACByNWTL9br0bDcxQ+ZE66a+z1+dj/gFTEjMhWnL6F/yVaAuy1C0i4XbULhXf5Xgkg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731447357; c=relaxed/simple;
	bh=iRbdus27C1atdh2KUhvt5j+UW6cRX6720QGQaeUJNEc=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=aWXvfgcxqj40Da1w+WpFzlpTfpuTGih9Azreb60W155jLleBKoFJvy3ecKsWNOdLw2GAo14Ueto5FLKiZxpchkmg/JXPnEZOKe6OWBVrIB/RvmkWiuVYDOVbaNf/IYJxvz45rUEicic6jAGhSV78pVs0jniu3CVFzFa1rM5jtio=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=jDZXjxEU; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1731447349;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=SPiNJ0SoOt9iVr4TWUziZnZxljkozoCCf4QRcxxju5g=;
	b=jDZXjxEUV5GQ5XhsS6W5N0rlvwZUqG2dRqD5xq6DE4R+Gp0wzZdRERuX/QC86spd9v0Q/x
	I9aLC4pRW69vO5JZl4qWl2WDAAdPFkD3zUwt/gciuzP3oxiYLJ0ghgUrZGTGhIaHONbcZ+
	v7ujW6pkbFAZjabtnQOOvcNYi+aViGw=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-591-fA8GjwDyMnuqutlkDm2mOQ-1; Tue, 12 Nov 2024 16:35:47 -0500
X-MC-Unique: fA8GjwDyMnuqutlkDm2mOQ-1
X-Mimecast-MFC-AGG-ID: fA8GjwDyMnuqutlkDm2mOQ
Received: by mail-wm1-f72.google.com with SMTP id 5b1f17b1804b1-4314c6ca114so47129395e9.1
        for <kvm@vger.kernel.org>; Tue, 12 Nov 2024 13:35:47 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1731447346; x=1732052146;
        h=content-transfer-encoding:in-reply-to:organization:autocrypt
         :content-language:from:references:cc:to:subject:user-agent
         :mime-version:date:message-id:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=SPiNJ0SoOt9iVr4TWUziZnZxljkozoCCf4QRcxxju5g=;
        b=F2wA2mJbzYGL22EKVPO8cVxyrokPsltkJpzCSrovb2NUDizUFBzlMVk27S0EQU5VyN
         fGDc6oqr8+SdH6JYon2By+/+jWxbk9zTe+6klDuiDY/gNb3sH3zfS1ul70ctjyZ8IaiS
         q7RWb6EAQajeP88Y5UTFjMOmGroClYgAFsK1WB+e4ilPXhguUTtB5pDQcQect61PJrPP
         e+DjZJu2N+NmfnxNzAa8Je433zRFvdMyssFjK8/6j+JEDdm58+t8zFqmKY/reBNs6ZBz
         dEYLYg3vV/AtZt0XZcL7rooWoU2Mcmte03HEiYi6zHlohuXVR7i+xOd3w817FsXPeNq8
         eGvQ==
X-Forwarded-Encrypted: i=1; AJvYcCV90cJ1WK0I0+zoRs1/NZ+YL0WGOPgQVMavyTpiKDyTfBqfYG66uiaWsAY1Nm0bckOkWSk=@vger.kernel.org
X-Gm-Message-State: AOJu0Yxoh0LnMGBGmzAvypwvhVULAenubOl1kXgEt0TvmZC4aH+Q+fPu
	8ydbky150+TBAvBJV7v5R04abDn+IvDzz0GFuRAbbprTKNoCrobWP+rzqCkZ0NizvmcgUQF62LI
	Cw98LXh0f/y0ZouNHsPSJugjvhvtsfYnFX4IBnGS5evLYA0NfjQ==
X-Received: by 2002:a05:600c:1da7:b0:42c:a574:6360 with SMTP id 5b1f17b1804b1-432d4ad6625mr4966085e9.29.1731447346588;
        Tue, 12 Nov 2024 13:35:46 -0800 (PST)
X-Google-Smtp-Source: AGHT+IHtQmNdU/v2xtYebg9Nf7PwgehvzJKLH7nBNz5a7U1h59GJIC2gGs3YtnxnG0EQMpmFkzgzzg==
X-Received: by 2002:a05:600c:1da7:b0:42c:a574:6360 with SMTP id 5b1f17b1804b1-432d4ad6625mr4965885e9.29.1731447346109;
        Tue, 12 Nov 2024 13:35:46 -0800 (PST)
Received: from ?IPV6:2003:cb:c739:8e00:7a46:1b8c:8b13:d3d? (p200300cbc7398e007a461b8c8b130d3d.dip0.t-ipconnect.de. [2003:cb:c739:8e00:7a46:1b8c:8b13:d3d])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-432d550c072sm189445e9.29.2024.11.12.13.35.43
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 12 Nov 2024 13:35:44 -0800 (PST)
Message-ID: <f78bf083-e499-4509-b673-91b2d78e0322@redhat.com>
Date: Tue, 12 Nov 2024 22:35:42 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 1/7] accel/kvm: Keep track of the HWPoisonPage
 page_size
To: William Roche <william.roche@oracle.com>, kvm@vger.kernel.org,
 qemu-devel@nongnu.org, qemu-arm@nongnu.org
Cc: peterx@redhat.com, pbonzini@redhat.com, richard.henderson@linaro.org,
 philmd@linaro.org, peter.maydell@linaro.org, mtosatti@redhat.com,
 imammedo@redhat.com, eduardo@habkost.net, marcel.apfelbaum@gmail.com,
 wangyanan55@huawei.com, zhao1.liu@intel.com, joao.m.martins@oracle.com
References: <e2ac7ad0-aa26-4af2-8bb3-825cba4ffca0@redhat.com>
 <20241107102126.2183152-1-william.roche@oracle.com>
 <20241107102126.2183152-2-william.roche@oracle.com>
 <b4f07c74-4240-4b07-a8ce-7cd765d954e9@redhat.com>
 <1f59ca33-4861-406e-9490-af3e4df08efc@oracle.com>
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
In-Reply-To: <1f59ca33-4861-406e-9490-af3e4df08efc@oracle.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 12.11.24 19:17, William Roche wrote:
> On 11/12/24 11:30, David Hildenbrand wrote:
>> On 07.11.24 11:21, “William Roche wrote:
>>> From: William Roche <william.roche@oracle.com>
>>>
>>> When a memory page is added to the hwpoison_page_list, include
>>> the page size information.  This size is the backend real page
>>> size. To better deal with hugepages, we create a single entry
>>> for the entire page.
>>>
>>> Signed-off-by: William Roche <william.roche@oracle.com>
>>> ---
>>>    accel/kvm/kvm-all.c       |  8 +++++++-
>>>    include/exec/cpu-common.h |  1 +
>>>    system/physmem.c          | 13 +++++++++++++
>>>    3 files changed, 21 insertions(+), 1 deletion(-)
>>>
>>> diff --git a/accel/kvm/kvm-all.c b/accel/kvm/kvm-all.c
>>> index 801cff16a5..6dd06f5edf 100644
>>> --- a/accel/kvm/kvm-all.c
>>> +++ b/accel/kvm/kvm-all.c
>>> @@ -1266,6 +1266,7 @@ int kvm_vm_check_extension(KVMState *s, unsigned
>>> int extension)
>>>     */
>>>    typedef struct HWPoisonPage {
>>>        ram_addr_t ram_addr;
>>> +    size_t     page_size;
>>>        QLIST_ENTRY(HWPoisonPage) list;
>>>    } HWPoisonPage;
>>> @@ -1278,7 +1279,7 @@ static void kvm_unpoison_all(void *param)
>>>        QLIST_FOREACH_SAFE(page, &hwpoison_page_list, list, next_page) {
>>>            QLIST_REMOVE(page, list);
>>> -        qemu_ram_remap(page->ram_addr, TARGET_PAGE_SIZE);
>>> +        qemu_ram_remap(page->ram_addr, page->page_size);
>>>            g_free(page);
>>
>> I'm curious, can't we simply drop the size parameter from qemu_ram_remap()
>> completely and determine the page size internally from the RAMBlock that
>> we are looking up already?
>>
>> This way, we avoid yet another lookup in qemu_ram_pagesize_from_addr(),
>> and can just handle it completely in qemu_ram_remap().
>>
>> In particular, to be future proof, we should also align the offset down to
>> the pagesize.
>>
>> I'm thinking about something like this:
>>
>> diff --git a/accel/kvm/kvm-all.c b/accel/kvm/kvm-all.c
>> index 801cff16a5..8a47aa7258 100644
>> --- a/accel/kvm/kvm-all.c
>> +++ b/accel/kvm/kvm-all.c
>> @@ -1278,7 +1278,7 @@ static void kvm_unpoison_all(void *param)
>>
>>        QLIST_FOREACH_SAFE(page, &hwpoison_page_list, list, next_page) {
>>            QLIST_REMOVE(page, list);
>> -        qemu_ram_remap(page->ram_addr, TARGET_PAGE_SIZE);
>> +        qemu_ram_remap(page->ram_addr);
>>            g_free(page);
>>        }
>>    }
>> diff --git a/include/exec/cpu-common.h b/include/exec/cpu-common.h
>> index 638dc806a5..50a829d31f 100644
>> --- a/include/exec/cpu-common.h
>> +++ b/include/exec/cpu-common.h
>> @@ -67,7 +67,7 @@ typedef uintptr_t ram_addr_t;
>>
>>    /* memory API */
>>
>> -void qemu_ram_remap(ram_addr_t addr, ram_addr_t length);
>> +void qemu_ram_remap(ram_addr_t addr);
>>    /* This should not be used by devices.  */
>>    ram_addr_t qemu_ram_addr_from_host(void *ptr);
>>    ram_addr_t qemu_ram_addr_from_host_nofail(void *ptr);
>> diff --git a/system/physmem.c b/system/physmem.c
>> index dc1db3a384..5f19bec089 100644
>> --- a/system/physmem.c
>> +++ b/system/physmem.c
>> @@ -2167,10 +2167,10 @@ void qemu_ram_free(RAMBlock *block)
>>    }
>>
>>    #ifndef _WIN32
>> -void qemu_ram_remap(ram_addr_t addr, ram_addr_t length)
>> +void qemu_ram_remap(ram_addr_t addr)
>>    {
>>        RAMBlock *block;
>> -    ram_addr_t offset;
>> +    ram_addr_t offset, length;
>>        int flags;
>>        void *area, *vaddr;
>>        int prot;
>> @@ -2178,6 +2178,10 @@ void qemu_ram_remap(ram_addr_t addr, ram_addr_t
>> length)
>>        RAMBLOCK_FOREACH(block) {
>>            offset = addr - block->offset;
>>            if (offset < block->max_length) {
>> +            /* Respect the pagesize of our RAMBlock. */
>> +            offset = QEMU_ALIGN_DOWN(offset, qemu_ram_pagesize(block));
>> +            length = qemu_ram_pagesize(block);
>> +
>>                vaddr = ramblock_ptr(block, offset);
>>                if (block->flags & RAM_PREALLOC) {
>>                    ;
>> @@ -2206,6 +2210,8 @@ void qemu_ram_remap(ram_addr_t addr, ram_addr_t
>> length)
>>                    memory_try_enable_merging(vaddr, length);
>>                    qemu_ram_setup_dump(vaddr, length);
>>                }
>> +
>> +            break;
>>            }
>>        }
>>    }
>>
>>
> 
> 
> Yes this is a working possibility, and as you say it would provide the
> advantage to avoid a size lookup (needed because the kernel siginfo can
> be incorrect) and avoid tracking the poisoned pages size, with the
> addresses.
 > > But if we want to keep the information about the loss of a large page
> (which I think is useful) we would have to introduce the page size
> lookup when adding the page to the poison list. So according to me,

Right, that would be independent of the remap logic.

What I dislike about qemu_ram_remap() is that it looks like we could be 
remapping a range that's possibly larger than a single page.

But it really only works on a single address, expanding that to the 
page. Passing in a length that crosses RAMBlocks would not work as 
expected ...

So I'd prefer if we let qemu_ram_remap() do exactly that ... remap a 
single page ...

> keeping track of the page size and reusing it on remap isn't so bad. But
> if you prefer that we don't track the page size and do a lookup on page
> insert into the poison list and another in qemu_ram_remap(), of course
> we can do that.

... and lookup the page size manually here if we really have to, for 
example to warn/trace errors.

 > > There is also something to consider about the future: we'll also 
have to
> deal with migration of VM that have been impacted by a memory error. And
> knowing about the poisoned pages size could be useful too. But this is
> another topic...

Yes, although the destination should be able to derive the same thing 
from the address I guess. We expect src and dst QEMU to use the same 
memory backing.

-- 
Cheers,

David / dhildenb


