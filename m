Return-Path: <kvm+bounces-31769-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 4CCFE9C7759
	for <lists+kvm@lfdr.de>; Wed, 13 Nov 2024 16:37:05 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id B90CDB25987
	for <lists+kvm@lfdr.de>; Wed, 13 Nov 2024 15:05:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B9EAE13A257;
	Wed, 13 Nov 2024 15:04:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="MRJc9Mr7"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 601957DA87
	for <kvm@vger.kernel.org>; Wed, 13 Nov 2024 15:04:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731510299; cv=none; b=rh+ck6+YnJlNq88cUrigzfhTqCBcWcq20kPHNQSD0lqy9akcR77pWADPeKWoOYJSC+tvT5TwjaN6MeXd9f9TMfdRw3gMfJMLxmnwS7SaSOd0627gD06e0qbV9BQ7uRVxjyeNkZL2nmKG+lceg0AfRvwb8QzHRHm0xE5JwGxVPyc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731510299; c=relaxed/simple;
	bh=UbbICofoKZxeLkACx6J5opPe3oyUw47YmLrnr5g7JaU=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=XBqmINunSBwtmZq408+Qo86020r653C2NmZJchoqw5fYAQ3p6ra4j9hgWEdiPXGTzy8JKDoVylA/EytZhno7EygGX58NMhl8dxPJg0RnMvxGDhOQmBrCAmtgXds2dQ4Q3BcpOWNT9ksd3r9gcXmd5gqp4fdjMcLhUcKnLyzzMt4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=MRJc9Mr7; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1731510296;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=O6DydnDTYCCmuX7cBoqwy7GbK0nUFRDMFdcolkDfy4k=;
	b=MRJc9Mr7lUMejXUfkJiG+mKzzXmN1uTULuBQ6Y7nVQl/lPye1iIJyfSOhthK+h37p281DP
	+kSoSpmiF+Oijcka7bV41dC9ZaGoFf584/F3YCX2iercGtNgqjk7G7zfqbkw/Yn7vhsYxQ
	UiuGc0wEUogZhCMcUGxbkwKYd0oCi8c=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-301-iccO1P4NPLGoawn41lS-SQ-1; Wed, 13 Nov 2024 10:04:55 -0500
X-MC-Unique: iccO1P4NPLGoawn41lS-SQ-1
X-Mimecast-MFC-AGG-ID: iccO1P4NPLGoawn41lS-SQ
Received: by mail-wm1-f70.google.com with SMTP id 5b1f17b1804b1-4327bd6bd60so51728885e9.1
        for <kvm@vger.kernel.org>; Wed, 13 Nov 2024 07:04:54 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1731510294; x=1732115094;
        h=content-transfer-encoding:in-reply-to:organization:autocrypt
         :content-language:from:references:cc:to:subject:user-agent
         :mime-version:date:message-id:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=O6DydnDTYCCmuX7cBoqwy7GbK0nUFRDMFdcolkDfy4k=;
        b=e/9V82IcItS0U4n+dAVgkvlFd5+pjZ2JitEe6xHMi83Nr4jOVzlqpUrkqyh+adMdzK
         s/S5BdZadlWyywnwviljxiaICmBePt7jp081II0KgNwixUZnQCVfh0O8WmkHCLMWQG9W
         o0qBmLraTDPwRe2K5kQZXN1F2k2mJh0VC9tB+tY22RYt1ameSxkzqfgrR/l7J2Zt6z29
         oCQCBwX+Y09TYFftEzoeTNeWunozgj27BS0X0o+26t4lrGiw0jNMD0Z+CuhP+P8/cyhA
         T/NdFJOmnndwKpWqvuu4ognsibz9/CWs40KrE2rktwZ6fGC5W6V3C+NGbPzREySsdW2n
         +qGQ==
X-Forwarded-Encrypted: i=1; AJvYcCUV3tIcCtTBK0fNTGZIVWmvMLDE+UNnxtttxybXQgchucuIyyb3OwRp/uNZbKi9fshF6no=@vger.kernel.org
X-Gm-Message-State: AOJu0YwtcAEEdOFWUUAU9TONLsLoBtP+5Hm7xKskkh0IXIqiopVhRSX9
	8hUasrCfuAc6mh/8Nq54JoSJs/Ki61mucGxYlU4fpCYPR/YGNHYTpmhvPTPTSqHiFvdkgDwq3Bk
	Xnr81aRbCGFrcJsti6rPORvKCoqFCKJyVUfpduf2jzTDOjdx/dOlHlWt7LA==
X-Received: by 2002:a05:600c:8715:b0:431:93d8:e1a1 with SMTP id 5b1f17b1804b1-432b751bcc2mr174244425e9.27.1731510293731;
        Wed, 13 Nov 2024 07:04:53 -0800 (PST)
X-Google-Smtp-Source: AGHT+IEfHHTm+7oQ/+i1vNYdIFk65/fAQuK7ZBw0Q0v9DyWapPg1cc7VTbkdsQhOMPZ0xcRlvvdSqw==
X-Received: by 2002:a05:600c:8715:b0:431:93d8:e1a1 with SMTP id 5b1f17b1804b1-432b751bcc2mr174243985e9.27.1731510293251;
        Wed, 13 Nov 2024 07:04:53 -0800 (PST)
Received: from ?IPV6:2003:cb:c708:1500:d584:7ad8:d3f7:5539? (p200300cbc7081500d5847ad8d3f75539.dip0.t-ipconnect.de. [2003:cb:c708:1500:d584:7ad8:d3f7:5539])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-432d55051easm28333095e9.24.2024.11.13.07.04.52
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 13 Nov 2024 07:04:52 -0800 (PST)
Message-ID: <08602ef7-6d28-471d-89c0-be3d29eb92a9@redhat.com>
Date: Wed, 13 Nov 2024 16:04:51 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [Invitation] bi-weekly guest_memfd upstream call on 2024-11-14
To: Chao Gao <chao.gao@intel.com>
Cc: linux-coco@lists.linux.dev, "linux-mm@kvack.org" <linux-mm@kvack.org>,
 KVM <kvm@vger.kernel.org>
References: <6f2bfac2-d9e7-4e4a-9298-7accded16b4f@redhat.com>
 <ZzRBzGJJJoezCge8@intel.com>
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
In-Reply-To: <ZzRBzGJJJoezCge8@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 13.11.24 07:06, Chao Gao wrote:
> On Tue, Nov 12, 2024 at 01:30:06PM +0100, David Hildenbrand wrote:
>> Hi,
>>
>> the next guest_memfd upstream call will happen this Thursday, 2024-11-14
>> at at 9:00 - 10:00am (GMT-08:00) Pacific Time - Vancouver.
>>
>> We'll be using the following Google meet:
>> http://meet.google.com/wxp-wtju-jzw
>>
>> The meeting notes are linked from the google calendar invitation. If you
>> want an invitation that also covers all future meetings, just write me a
>> mail.
>>
>> In this meeting we'll discuss:
>> * fbind() and NUMA mempolicy for guest_memfd
>> * Persisting guest_memfd across reboot / guest_memfs
>> * guest_memfd use cases for a PFN range allocator
>>
>> And we'll continue our discussion on:
>> * Challenges with supporting huge pages
>> * Challenges with shared vs. private conversion
>> * guest_memfd as a "library"
>>
>> To put something to discuss onto the agenda, reply to this mail or add
>> them to the "Topics/questions for next meeting(s)" section in the
>> meeting notes as a comment.
> 
> Hi David,

Hi!

> 
> We would like to discuss how to adapt the proposal for shared device assignment
> [1] to recent guest_memfd changes, such as the support of in-place conversion.

Makes sense.

> 
> With in-place conversion, QEMU can map shared memory and supply the virtual
> address to VFIO to set up DMA mappings. From this perspective, in-place
> conversion doesn't change or require any changes to the way QEMU interacts
> with VFIO. So, the key for device assignment remains updating DMA mappings
> accordingly during shared/private conversions. It seems that whether in-place
> conversion is in use (i.e., whether shared memory is managed by guest_memfd or
> not) doesn't require big changes to that proposal. Not sure if anyone thinks
> otherwise. We want to align with you on the direction for device assignment
> support for guest_memfd.
> (I set aside the idea of letting KVM manage the IOMMU page table in the above
>   analysis because we probably won't get that support in the near future)

Right. So devices would also only be to access "shared" memory.

> 
> Could you please add this topic to the agenda?

Will do. But I'm afraid the agenda for tomorrow is pretty packed, so we 
might not get to talk about it in more detail before the meeting in 2 weeks.

> 
> btw, the current time slot is not very convenient for us. If possible, could we
> schedule the meeting one hour earlier, if this works for others? Two hours
> earlier would be even better

Time zones and daylight saving are confusing, so I'm relying on Google 
calender; it says that the meeting is going to be at 9am pacific time, 
which ends up being 6pm German time. I suspect that's 1am in China? :( I 
know that Gavin from Australia is also not able to join unfortunately 
... something like 4am for him.

We can discuss tomorrow if we could move it to 8am pacific time (which I 
would welcome as well :) ) for the next meeting. 7am pacific time is 
likely a bit of a stretch though.

-- 
Cheers,

David / dhildenb


