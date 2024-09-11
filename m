Return-Path: <kvm+bounces-26591-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 536B9975CE7
	for <lists+kvm@lfdr.de>; Thu, 12 Sep 2024 00:08:06 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 77D8E1C225AF
	for <lists+kvm@lfdr.de>; Wed, 11 Sep 2024 22:08:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 08AC8158DB1;
	Wed, 11 Sep 2024 22:08:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="fEeQ1U7G"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 87E94273FC
	for <kvm@vger.kernel.org>; Wed, 11 Sep 2024 22:07:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726092479; cv=none; b=kxMO3s3NNlMo/qltyyNC3qcMWzaeHZQt+zzDj5hLhCiAg8fHFzzjh/BjUIl7gHhQZXbYKJbVPC4VxTeeKVKw1/cbbFX0lu02KBdp9iD4aesyT6+vdw7aklWn4wg/fKaHyU9J21Eiz8B2p/KXqvzuDguA187MaXJ1wiprTVquN9U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726092479; c=relaxed/simple;
	bh=WQ5xUdoURdT7+vK5J20UZjKk+FmJEb9HDmLlurDQLig=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=hY4QjyowCPqduRhscz8OTqVBFDD+YLdsgnww9/C7HURdudFNS+wcQ39qPYvCbm0388svMSDBlubK3SMsLAPCrdXAV8NUrpm+q6c2kiDp+jnF7VjAdd80n8SNkxrXjXzzNJ+DjnychWDLT44U2izGqJFSbQz4GH2etENXE/GA+zk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=fEeQ1U7G; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1726092476;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=qPv18UJlJ1AtcMakcGZBSmFd7ZNQdnu0Fu6/erRRIEI=;
	b=fEeQ1U7G/ikqVk4rPfAV/ruOGA+4ElgeaWZ1kcPHDbjtfTqOEVs/JQhB9baRSFJhcVTczS
	7bgWChOU/u2j+YnbzSVAt6b7hIBXk/op7b55qP3aKNUevb5wtqYjdFxECV5KAuHJySV6mx
	9eQsxp5p32V7HiUzbUqmA+Cx8N4/B9g=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-634-GrgkS-IOM3iGlwJQKWzpxA-1; Wed, 11 Sep 2024 18:07:55 -0400
X-MC-Unique: GrgkS-IOM3iGlwJQKWzpxA-1
Received: by mail-wm1-f71.google.com with SMTP id 5b1f17b1804b1-42cb89fbb8cso1368285e9.0
        for <kvm@vger.kernel.org>; Wed, 11 Sep 2024 15:07:55 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1726092474; x=1726697274;
        h=content-transfer-encoding:in-reply-to:organization:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=qPv18UJlJ1AtcMakcGZBSmFd7ZNQdnu0Fu6/erRRIEI=;
        b=XMFsLQmxqnecpKvvpTfDEEyAieNT9OY5ks8awPKIu54uyd6qjJinRlgNi0AhdQBW0y
         Vd8f+t3NyMSDyPMhwByhkCdPl7BmTsnYtRhQ6CkMoYjKd7K26+8BtrUzoocMeg20A+u+
         lomd1ZUDl6o8JK4JlL7uEotRiwY7MrZ1r1+i68kPw+UqMxnyFxVbKuQN8fTnXGj/4brW
         EIOGmyOJo3vZF7iJQulPuvMcyOgJcIIb9D26kZLHuG+vNlu9M5jjov7d09DRBMfQAyGk
         OV9eXqANR4xUcJLv35EI0dFbCU4eeDXt1vm0mkuhT9Mskoy2Cr74zwm9PdvX4SlM7BQ4
         YRxQ==
X-Gm-Message-State: AOJu0YzK8nXbkZH/LVo5/vowaq5EzdodJoqNGUHxBLfmC+fZgbm10TWN
	6znktiaqnonq9zfOVgEUgmWg1KO1Kss/F7cu3Jh2FLC6hc/k3xpR3nD6vL7K9J/cQ7I22bNiHgw
	QFm+UNtfD4axu2RuDNm+RoIt7GPlOJggCl9etSFiAgnWphbd0vw==
X-Received: by 2002:adf:9b92:0:b0:371:87af:c88a with SMTP id ffacd0b85a97d-378c2d4d7e5mr369985f8f.45.1726092473853;
        Wed, 11 Sep 2024 15:07:53 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEaYRRHD1jY22/i7oTAzVTJ734TcisQhWrmAF4DsRLiAb3ee+Ki3SXogOD8Ci/m6qeMHIP46A==
X-Received: by 2002:adf:9b92:0:b0:371:87af:c88a with SMTP id ffacd0b85a97d-378c2d4d7e5mr369955f8f.45.1726092472849;
        Wed, 11 Sep 2024 15:07:52 -0700 (PDT)
Received: from ?IPV6:2003:cb:c700:7e00:c672:608:5b3e:df8c? (p200300cbc7007e00c67206085b3edf8c.dip0.t-ipconnect.de. [2003:cb:c700:7e00:c672:608:5b3e:df8c])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-42caeb4444asm152958595e9.22.2024.09.11.15.07.51
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 11 Sep 2024 15:07:52 -0700 (PDT)
Message-ID: <cf587c8b-3894-4589-bfea-be5db70e81f3@redhat.com>
Date: Thu, 12 Sep 2024 00:07:51 +0200
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC RESEND 0/6] hugetlbfs largepage RAS project
To: William Roche <william.roche@oracle.com>, pbonzini@redhat.com,
 peterx@redhat.com, philmd@linaro.org, marcandre.lureau@redhat.com,
 berrange@redhat.com, thuth@redhat.com, richard.henderson@linaro.org,
 peter.maydell@linaro.org, mtosatti@redhat.com, qemu-devel@nongnu.org
Cc: kvm@vger.kernel.org, qemu-arm@nongnu.org, joao.m.martins@oracle.com
References: <20240910090747.2741475-1-william.roche@oracle.com>
 <20240910100216.2744078-1-william.roche@oracle.com>
 <ec3337f7-3906-4a1b-b153-e3d5b16685b6@redhat.com>
 <9f9a975e-3a04-4923-b8a5-f1edbed945e6@oracle.com>
Content-Language: en-US
From: David Hildenbrand <david@redhat.com>
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
In-Reply-To: <9f9a975e-3a04-4923-b8a5-f1edbed945e6@oracle.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

Hi again,

>>> This is a Qemu RFC to introduce the possibility to deal with hardware
>>> memory errors impacting hugetlbfs memory backed VMs. When using
>>> hugetlbfs large pages, any large page location being impacted by an
>>> HW memory error results in poisoning the entire page, suddenly making
>>> a large chunk of the VM memory unusable.
>>>
>>> The implemented proposal is simply a memory mapping change when an HW
>>> error
>>> is reported to Qemu, to transform a hugetlbfs large page into a set of
>>> standard sized pages. The failed large page is unmapped and a set of
>>> standard sized pages are mapped in place.
>>> This mechanism is triggered when a SIGBUS/MCE_MCEERR_Ax signal is
>>> received
>>> by qemu and the reported location corresponds to a large page.

One clarifying question: you simply replace the hugetlb page by multiple 
small pages using mmap(MAP_FIXED). So you

(a) are not able to recover any memory of the original page (as of now)
(b) no longer have a hugetlb page and, therefore, possibly a performance
     degradation, relevant in low-latency applications that really care
     about the usage of hugetlb pages.
(c) run into the described inconsistency issues

Why is what you propose beneficial over just fallocate(PUNCH_HOLE) the 
full page and get a fresh, non-poisoned page instead?

Sure, you have to reserve some pages if that ever happens, but what is 
the big selling point over PUNCH_HOLE + realloc? (sorry if I missed it 
and it was spelled out)

>>>
>>> This gives the possibility to:
>>> - Take advantage of newer hypervisor kernel providing a way to retrieve
>>> still valid data on the impacted hugetlbfs poisoned large page.

Reading that again, that shouldn't have to be hypervisor-specific. 
Really, if someone were to extract data from a poisoned hugetlb folio, 
it shouldn't be hypervisor-specific. The kernel should be able to know 
which regions are accessible and could allow ways for reading these, one 
way or the other.

It could just be a fairly hugetlb-special feature that would replace the 
poisoned page by a fresh hugetlb page where as much page content as 
possible has been recoverd from the old one.

>>> If the backend file is MAP_SHARED, we can copy the valid data into the
> 
> 
> Thank you David for this first reaction on this proposal.
> 
> 
>> How are you dealing with other consumers of the shared memory,
>> such as vhost-user processes,
> 
> 
> In the current proposal, I don't deal with this aspect.
> In fact, any other process sharing the changed memory will
> continue to map the poisoned large page. So any access to
> this page will generate a SIGBUS to this other process.
> 
> In this situation vhost-user processes should continue to receive
> SIGBUS signals (and probably continue to die because of that).

That's ... suboptimal. :)

Assume you have a 1 GiB page. The guest OS can happily allocate buffers 
in there so they can end up in vhost-user and crash that process. 
Without any warning.

> 
> So I do see a real problem if 2 qemu processes are sharing the
> same hugetlbfs segment -- in this case, error recovery should not
> occur on this piece of the memory. Maybe dealing with this situation
> with "ivshmem" options is doable (marking the shared segment
> "not eligible" to hugetlbfs recovery, just like not "share=on"
> hugetlbfs entries are not eligible)
> -- I need to think about this specific case.
> 
> Please let me know if there is a better way to deal with this
> shared memory aspect and have a better system reaction.

Not creating the inconsistency in the first place :)

>> vm migration whereby RAM is migrated using file content,
> 
> 
> Migration doesn't currently work with memory poisoning.
> You can give a look at the already integrated following commit:
> 
> 06152b89db64 migration: prevent migration when VM has poisoned memory
> 
> This proposal doesn't change anything on this side.

That commit is fairly fresh and likely missed the option to *not* 
migrate RAM by reading it, but instead by migrating it through a shared 
file. For example, VM life-upgrade (CPR) wants to use that (or is 
already using that), to avoid RAM migration completely.

> 
>> vfio that might have these pages pinned?
> 
> AFAIK even pinned memory can be impacted by memory error and poisoned
> by the kernel. Now as I said in the cover letter, I'd like to know if
> we should take extra care for IO memory, vfio configured memory buffers...

Assume your GPU has a hugetlb folio pinned via vfio. As soon as you make 
the guest RAM point at anything else as VFIO is aware of, we end up in 
the same problem we had when we learned about having to disable balloon 
inflation (MADVISE_DONTNEED) as soon as VFIO pinned pages.

We'd have to inform VFIO that the mapping is now different. Otherwise 
it's really better to crash the VM than having your GPU read/write 
different data than your CPU reads/writes,

> 
> 
>> In general, you cannot simply replace pages by private copies
>> when somebody else might be relying on these pages to go to
>> actual guest RAM.
> 
> This is correct, but the current proposal is dealing with a specific
> shared memory type: poisoned large pages. So any other process mapping
> this type of page can't access it without generating a SIGBUS.

Right, and that's the issue. Because, for example, how should the VM be 
aware that this memory is now special and must not be used for some 
purposes without leading to problems elsewhere?

> 
> 
>> It sounds very hacky and incomplete at first.
> 
> As you can see, RAS features need to be completed.
> And if this proposal is incomplete, what other changes should be
> done to complete it ?
> 
> I do hope we can discuss this RFC to adapt what is incorrect, or
> find a better way to address this situation.

One long-term goal people are working on is to allow remapping the 
hugetlb folios in smaller granularity, such that only a single affected 
PTE can be marked as poisoned. (used to be called high-granularity-mapping)

However, at the same time, the focus hseems to shift towards using 
guest_memfd instead of hugetlb, once it supports 1 GiB pages and shared 
memory. It will likely be easier to support mapping 1 GiB pages using 
PTEs that way, and there are ongoing discussions how that can be 
achieved more easily.

There are also discussions [1] about not poisoning the mappings at all 
and handling it differently. But I haven't yet digested how exactly that 
could look like in reality.


[1] https://lkml.kernel.org/r/20240828234958.GE3773488@nvidia.com

-- 
Cheers,

David / dhildenb


