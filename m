Return-Path: <kvm+bounces-41444-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 330EDA67CDD
	for <lists+kvm@lfdr.de>; Tue, 18 Mar 2025 20:13:32 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id D4ECF18878E6
	for <lists+kvm@lfdr.de>; Tue, 18 Mar 2025 19:13:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F205E2135DE;
	Tue, 18 Mar 2025 19:13:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Jtn9atfJ"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 93D25207E0B
	for <kvm@vger.kernel.org>; Tue, 18 Mar 2025 19:13:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742325197; cv=none; b=F0jPOdpVyqQ9TOQL1KH0ZjXGMQjfHy9Hre1w8yK9zjWfpZm7pjxAS5MCRKJiH3Bps5AhYoJzAFMhaZkUsmIz6qTBXSoYB1d6y+Q9l4wOMXVtYZECZZHG2QpRjYNQm3bVgxefZsCfnE6RE1gp/lDfIFqOsDiT6p/k0rzJjHD0RdQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742325197; c=relaxed/simple;
	bh=thrryMsLqSS7zZhwBdvgT+0kV1p24lz57kcb8KWPuOw=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=cOnwAwdtxVYvcWD0oegiDGxy1NBG2dJKqa8ajWZfIr64laRFgbruCN2zSNSVg3L6dB5TSW3jgce0W+OjViYuQeMKMR/pAUvHdsCOFedv5Ir4y4zrFrXLefJ9fREUXUk/hM9AxVGaCHahrm54z9M8WLrPUZFnQxnUsmuqf9M7nJw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Jtn9atfJ; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1742325190;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=4U0PC1ZqWLnd1as/CRjWt1nsYHzHAjrFR54RXgAiwy4=;
	b=Jtn9atfJzate9izF+MYmSldYf5cUxo8bBAbSv9vxxC1ysp/YxtZkrpmQmvGieD0GekBidw
	JG5HwcNqtdQ0kvMpDJ8qWfkeponoM3V1obyO3X7zD01O+3N+tQtonI0bt+dzmsYIL+btR4
	BScXZUP7T8WOgmy/HDjZ+QFcpqXvIUQ=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-206-MKMa1YsON4aZwudjUZtHvw-1; Tue, 18 Mar 2025 15:13:09 -0400
X-MC-Unique: MKMa1YsON4aZwudjUZtHvw-1
X-Mimecast-MFC-AGG-ID: MKMa1YsON4aZwudjUZtHvw_1742325188
Received: by mail-wm1-f71.google.com with SMTP id 5b1f17b1804b1-43947979ce8so18624835e9.0
        for <kvm@vger.kernel.org>; Tue, 18 Mar 2025 12:13:09 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1742325188; x=1742929988;
        h=content-transfer-encoding:in-reply-to:organization:autocrypt
         :content-language:from:references:to:subject:user-agent:mime-version
         :date:message-id:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=4U0PC1ZqWLnd1as/CRjWt1nsYHzHAjrFR54RXgAiwy4=;
        b=VsxJtLrwQZXqpuGoclC6cwVRYDn/T0l1vsCv2nydzMdckmPldJTUZWPI5EAw90p4oB
         RiDsJYtplVDyMWAxauv7yroKAWwnb3KutbY0tPP45RyGaAZumTNMRsAJlYHXeFibDD3b
         G4eMmd8ECin22NDsxFpeo760c5G8mJ6QNOuQcQwpThg/Sb01xWR+hBqlDEr9G4XVl7vj
         LIaOqBCxvKT5iQlk8Z7aRkCJ2V5dNZ8LoJzeCLIeZx83rqzJ/cT8tNy0RvkCeuYpmwOJ
         hkE5ZuH/7biVuEhXJNI/hDUx3PgctECly+P7m7KyKXjJqwfTHBFt1IeW9SelIDRaXT2O
         utOw==
X-Forwarded-Encrypted: i=1; AJvYcCUMJVGWHo0weSvKvdTso9gekhHKTKL32elVJMNTccEp22R7KOcdAQ2pOyGuVeouvHOPQXo=@vger.kernel.org
X-Gm-Message-State: AOJu0Yy9ZYUuFtXvo9m0I6DEi5okKW2kwggrQbgfqNg8Xa/H2S6iQuwQ
	uvk4R8H4kFJtW+0NP/BiKOhP/SDDRThlkoyJ8/bNx3IovyKp+VeTMQOGg6nUXy9Fz+JqBFQfjAh
	4Eqa7pktbFwYPZhGXwWovRql1UgsfD/wYe/VZMEnl4Ojjgdr9Hg==
X-Gm-Gg: ASbGncvZNpXUybE9EmqEhhPA27GPm9lfpyJIVHEEie0Bn0aqrTzJMJ6kY4t/yfk4LOb
	oUtggW9nf2tFoADgZb21uM8sQF/VIrSeWFbtRBpiZ7YGX+RiyfF7Ao4IFBtEZe/Z31l3DNcLSez
	YygIhu2C/Lakq9HLHiAb6GNUqy8VZSdiWHWnDY56VduxR4tha8G9cu8IPT7YqPkb+h7HbVENCv1
	i5BImp1w2e5VglZyiNNr1BmQ20cz0dOKqlU5AYldt8OYzlwDNKkicj5SbDYTaTIcrUPPLCkDE+E
	hVKxR828+8cJbWn7Tank3eHZVYHnk8sr9FQyN/WGtb+CR5KDVYYvsTEawi4ZleM22arREEmlMcC
	MLzumpwuqKtoas5k8TOlhsgTGasZUf9FlngQ2BhNfH7c=
X-Received: by 2002:a05:600c:4687:b0:43b:cc42:c54f with SMTP id 5b1f17b1804b1-43d3b98e60dmr37177955e9.14.1742325187763;
        Tue, 18 Mar 2025 12:13:07 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IE4Gap2yhS3UBNY8mODOlsiGBVyg/wtOuAtDubOQetvtdbroh57+tstnim13R32dNyYOUaPdg==
X-Received: by 2002:a05:600c:4687:b0:43b:cc42:c54f with SMTP id 5b1f17b1804b1-43d3b98e60dmr37177585e9.14.1742325187278;
        Tue, 18 Mar 2025 12:13:07 -0700 (PDT)
Received: from ?IPV6:2003:cb:c72d:2500:94b5:4b7d:ad4a:fd0b? (p200300cbc72d250094b54b7dad4afd0b.dip0.t-ipconnect.de. [2003:cb:c72d:2500:94b5:4b7d:ad4a:fd0b])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-43d1ffb62c1sm142728765e9.4.2025.03.18.12.13.06
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 18 Mar 2025 12:13:06 -0700 (PDT)
Message-ID: <7c86c45c-17e4-4e9b-8d80-44fdfd37f38b@redhat.com>
Date: Tue, 18 Mar 2025 20:13:05 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH RFC v1 0/5] KVM: gmem: 2MB THP support and preparedness
 tracking changes
To: Yan Zhao <yan.y.zhao@intel.com>, "Shah, Amit" <Amit.Shah@amd.com>,
 "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
 "Roth, Michael" <Michael.Roth@amd.com>,
 "liam.merwick@oracle.com" <liam.merwick@oracle.com>,
 "seanjc@google.com" <seanjc@google.com>, "jroedel@suse.de"
 <jroedel@suse.de>, "linux-mm@kvack.org" <linux-mm@kvack.org>,
 "Sampat, Pratik Rajesh" <PratikRajesh.Sampat@amd.com>,
 "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
 "Lendacky, Thomas" <Thomas.Lendacky@amd.com>, "vbabka@suse.cz"
 <vbabka@suse.cz>, "pbonzini@redhat.com" <pbonzini@redhat.com>,
 "linux-coco@lists.linux.dev" <linux-coco@lists.linux.dev>,
 "quic_eberman@quicinc.com" <quic_eberman@quicinc.com>,
 "Kalra, Ashish" <Ashish.Kalra@amd.com>,
 "ackerleytng@google.com" <ackerleytng@google.com>,
 "vannapurve@google.com" <vannapurve@google.com>
References: <20241212063635.712877-1-michael.roth@amd.com>
 <11280705-bcb1-4a5e-a689-b8a5f8a0a9a6@redhat.com>
 <3bd7936624b11f755608b1c51cc1376ebf2c3a4f.camel@amd.com>
 <6e55db63-debf-41e6-941e-04690024d591@redhat.com>
 <Z9PyLE/LCrSr2jCM@yzhao56-desk.sh.intel.com>
 <18db10a0-bd40-4c6a-b099-236f4dcaf0cf@redhat.com>
 <Z9QQxd2TfpupOzAk@yzhao56-desk.sh.intel.com>
 <Z9jZRdFyyr1DFkvV@yzhao56-desk.sh.intel.com>
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
In-Reply-To: <Z9jZRdFyyr1DFkvV@yzhao56-desk.sh.intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 18.03.25 03:24, Yan Zhao wrote:
> On Fri, Mar 14, 2025 at 07:19:33PM +0800, Yan Zhao wrote:
>> On Fri, Mar 14, 2025 at 10:33:07AM +0100, David Hildenbrand wrote:
>>> On 14.03.25 10:09, Yan Zhao wrote:
>>>> On Wed, Jan 22, 2025 at 03:25:29PM +0100, David Hildenbrand wrote:
>>>>> (split is possible if there are no unexpected folio references; private
>>>>> pages cannot be GUP'ed, so it is feasible)
>>>> ...
>>>>>>> Note that I'm not quite sure about the "2MB" interface, should it be
>>>>>>> a
>>>>>>> "PMD-size" interface?
>>>>>>
>>>>>> I think Mike and I touched upon this aspect too - and I may be
>>>>>> misremembering - Mike suggested getting 1M, 2M, and bigger page sizes
>>>>>> in increments -- and then fitting in PMD sizes when we've had enough of
>>>>>> those.  That is to say he didn't want to preclude it, or gate the PMD
>>>>>> work on enabling all sizes first.
>>>>>
>>>>> Starting with 2M is reasonable for now. The real question is how we want to
>>>>> deal with
>>>> Hi David,
>>>>
>>>
>>> Hi!
>>>
>>>> I'm just trying to understand the background of in-place conversion.
>>>>
>>>> Regarding to the two issues you mentioned with THP and non-in-place-conversion,
>>>> I have some questions (still based on starting with 2M):
>>>>
>>>>> (a) Not being able to allocate a 2M folio reliably
>>>> If we start with fault in private pages from guest_memfd (not in page pool way)
>>>> and shared pages anonymously, is it correct to say that this is only a concern
>>>> when memory is under pressure?
>>>
>>> Usually, fragmentation starts being a problem under memory pressure, and
>>> memory pressure can show up simply because the page cache makes us of as
>>> much memory as it wants.
>>>
>>> As soon as we start allocating a 2 MB page for guest_memfd, to then split it
>>> up + free only some parts back to the buddy (on private->shared conversion),
>>> we create fragmentation that cannot get resolved as long as the remaining
>>> private pages are not freed. A new conversion from shared->private on the
>>> previously freed parts will allocate other unmovable pages (not the freed
>>> ones) and make fragmentation worse.
>> Ah, I see. The problem of fragmentation is because memory allocated by
>> guest_memfd is unmovable. So after freeing part of a 2MB folio, the whole 2MB is
>> still unmovable.
>>
>> I previously thought fragmentation would only impact the guest by providing no
>> new huge pages. So if a confidential VM does not support merging small PTEs into
>> a huge PMD entry in its private page table, even if the new huge memory range is
>> physically contiguous after a private->shared->private conversion, the guest
>> still cannot bring back huge pages.
>>
>>> In-place conversion improves that quite a lot, because guest_memfd tself
>>> will not cause unmovable fragmentation. Of course, under memory pressure,
>>> when and cannot allocate a 2M page for guest_memfd, it's unavoidable. But
>>> then, we already had fragmentation (and did not really cause any new one).
>>>
>>> We discussed in the upstream call, that if guest_memfd (primarily) only
>>> allocates 2M pages and frees 2M pages, it will not cause fragmentation
>>> itself, which is pretty nice.
>> Makes sense.
>>
>>>>
>>>>> (b) Partial discarding
>>>> For shared pages, page migration and folio split are possible for shared THP?
>>>
>>> I assume by "shared" you mean "not guest_memfd, but some other memory we use
>> Yes, not guest_memfd, in the case of non-in-place conversion.
>>
>>> as an overlay" -- so no in-place conversion.
>>>
>>> Yes, that should be possible as long as nothing else prevents
>>> migration/split (e.g., longterm pinning)
>>>
>>>>
>>>> For private pages, as you pointed out earlier, if we can ensure there are no
>>>> unexpected folio references for private memory, splitting a private huge folio
>>>> should succeed.
>>>
>>> Yes, and maybe (hopefully) we'll reach a point where private parts will not
>>> have a refcount at all (initially, frozen refcount, discussed during the
>>> last upstream call).
>> Yes, I also tested in TDX by not acquiring folio ref count in TDX specific code
>> and found that partial splitting could work.
>>
>>> Are you concerned about the memory fragmentation after repeated
>>>> partial conversions of private pages to and from shared?
>>>
>>> Not only repeated, even just a single partial conversion. But of course,
>>> repeated partial conversions will make it worse (e.g., never getting a
>>> private huge page back when there was a partial conversion).
>> Thanks for the explanation!
>>
>> Do you think there's any chance for guest_memfd to support non-in-place
>> conversion first?
> e.g. we can have private pages allocated from guest_memfd and allows the
> private pages to be THP.
> 
> Meanwhile, shared pages are not allocated from guest_memfd, and let it only
> fault in 4K granularity. (specify it by a flag?)
> 
> When we want to convert a 4K from a 2M private folio to shared, we can just
> split the 2M private folio as there's no extra ref count of private pages;

Yes, IIRC that's precisely what this series is doing, because the 
ftruncate() will try splitting the folio (which might still fail on 
speculative references, see my comment as rely to this series)

In essence: yes, splitting to 4k should work (although speculative 
reference might require us to retry). But the "4k hole punch" is the 
ugly it.

So you really want in-place conversion where the private->shared will 
split (but not punch) and the shared->private will collapse again if 
possible.

> 
> when we do shared to private conversion, no split is required as shared pages
> are in 4K granularity. And even if user fails to specify the shared pages as
> small pages only, the worst thing is that a 2M shared folio cannot be split, and
> more memory is consumed.
> 
> Of couse, memory fragmentation is still an issue as the private pages are
> allocated unmovable.

Yes, and that you will never ever get a "THP" back when there was a 
conversion from private->shared of a single page that split the THP and 
discarded that page.

  But do you think it's a good simpler start before in-place
> conversion is ready?

There was a discussion on that on the bi-weekly upstream meeting on 
February the 6. The recording has more details, I summarized it as

"David: Probably a good idea to focus on the long-term use case where we 
have in-place conversion support, and only allow truncation in hugepage 
(e.g., 2 MiB) size; conversion shared<->private could still be done on 4 
KiB granularity as for hugetlb."

In general, I think our time is better spent working on the real deal 
than on interim solutions that should not be called "THP support".

-- 
Cheers,

David / dhildenb


