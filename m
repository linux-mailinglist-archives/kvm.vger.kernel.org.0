Return-Path: <kvm+bounces-45409-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 52E12AA8DC3
	for <lists+kvm@lfdr.de>; Mon,  5 May 2025 10:01:57 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id ACCE33AC776
	for <lists+kvm@lfdr.de>; Mon,  5 May 2025 08:01:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DA6181E5219;
	Mon,  5 May 2025 08:01:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Tdy4F1fm"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 60BDA1E1A2D
	for <kvm@vger.kernel.org>; Mon,  5 May 2025 08:01:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746432098; cv=none; b=adP3MqGp8n5VhayYPuJ82UT6d8+mPXJlr4FCVO8sf/vqzu0Qm6E4EArAfCdyS+Fx9QY1N05QXqyT8eXrYUiZWfUO3RRYnWOsfzC3EzbzAnZfh50LG0Y9z5ah5Z130TrqWS2k7EZ7xfd7QVCW0Z38URegxR12bV1pbEPfi/Azras=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746432098; c=relaxed/simple;
	bh=DpgvxxYgMkvXP6/s07LegsAZJwnvoBbUL3jpj6aucNQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=A4oiiietK2IkNfPsmkeHaTi8mwhZeWrYOSZ6RJeTucAC/bHkXUMVdu0PCO913Q3OlHPQbxJVLCSkb9qP2S1Ao0yA6dJpeSaeBgKkjUraojhV0qbATHJYH5cphp4p6fHhaZ7e/G7w5QOEhYhEvnBdLc0FBvavYugaOqhqFh872DM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Tdy4F1fm; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1746432093;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=CWbnoIe+tgcFaU70z1xwtQPYOMdu/wZEtJxbhfme9Uc=;
	b=Tdy4F1fmAPiuSVOEu982tMQ5RqMTh1mj6K60m+wDuRuwNvFep13xhOC5okR7YLeXccjL9Y
	Bq1Ip9Ty+uTavbKfrfO5ux5MRki0HOEO+VAUSpjNbN1xb2WMwfOg8IdyYKYWhNgerZpmF+
	Ie3TKMVbKYqfKPkjQf5hVCGFs4zr420=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-688-LGhRaxYXNo61kkiZ_A04SQ-1; Mon, 05 May 2025 04:01:31 -0400
X-MC-Unique: LGhRaxYXNo61kkiZ_A04SQ-1
X-Mimecast-MFC-AGG-ID: LGhRaxYXNo61kkiZ_A04SQ_1746432091
Received: by mail-wr1-f69.google.com with SMTP id ffacd0b85a97d-39c1b1c0969so2403935f8f.1
        for <kvm@vger.kernel.org>; Mon, 05 May 2025 01:01:31 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1746432090; x=1747036890;
        h=content-transfer-encoding:in-reply-to:organization:autocrypt
         :content-language:from:references:cc:to:subject:user-agent
         :mime-version:date:message-id:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=CWbnoIe+tgcFaU70z1xwtQPYOMdu/wZEtJxbhfme9Uc=;
        b=hUEDYBfqcmvPdn4YtYZKue3bpZwzucdohwQvefHMGMh2y9KYCf4VkLNN+gL7C8wYCK
         BHspE4aaqu9HSGSYfRI2OBW1zIGP8w2OwYbsGwDbey1+qhU3fuY3IJSVQUj0/YqYC9/K
         QlLF9Z03IjcxPA54DiQ8PbJwXpHkHl6ZUlGhyQ95gm0eL3FZPvGgWPjlEvGyehRYKS3V
         bOeilar8PKcNJ4GU8xWsQm4g0W4vItiHmyTioi24khLS6wCbRPgPfvX7Y4FJxOlmyqLj
         nJdft871QFUMswzErUiIircYlxxueM/Vw/8/cVhj/w2uAii7IPFkFvl52Ahwa+247lOr
         GHrQ==
X-Forwarded-Encrypted: i=1; AJvYcCVLAdIOcn2TaOmV8hwjdQvQepqufRTV9RhEOgm7SNUcbNYmz0h+yh1OicsuDpzvIVbV7Co=@vger.kernel.org
X-Gm-Message-State: AOJu0Yyzn2oO9UjPgzPOmhl2rcJvd8d1iK8Ja7L3ots13tZ32QlgUnGH
	3BsmFkmQDQrw2we3ABJxA0h1ug+6mfM0J+3tJQTWFEsMtVtYaSFST9AledaXBwSgyn+6UPr9ghP
	KV/N/h9CiC5DZfGuMPWdI+10VwRbLOBoeWM92F3+HZ1sSvis+WA==
X-Gm-Gg: ASbGnctIoBNzqsBjO1EbE4MYBWkQzBPO+FZMvby3TIFICZwkB4HAvvPRjUZ72Cq9sDE
	Y91NFhKiYVLeD2FjiOXQO6GTsZZVzg1jVAD1Zqx5+S++CbbBiEqcJmYgsDW9v91V4Di6krdfaIU
	NuyYydbA/x8RH+6Iflbf7JZWyG70bQWt3MHUz4tPULj2cyPVh1FD1aVv+oNTfrgjF7WQQ56OgWQ
	2rqe1tQw7Yv7YAEz7X+p6nAa6y7th+DzZgzTHmA/R5LrebtR04UvEWv0cuoiftB9WnjlQdmvsJt
	CbwGVwAJrKtyW2HgDuqaA/g3XYWPiRrKw6VgSGJgRI5WV8BqH4ri9pdsLwQZ0A7+zMAukq2JC6+
	Yq4jZS767hJx5cp6vM8hL8ThwvcbBz2JDDx1r82I=
X-Received: by 2002:a05:6000:2284:b0:3a0:80b2:eedc with SMTP id ffacd0b85a97d-3a09fddfc9dmr4934311f8f.52.1746432090497;
        Mon, 05 May 2025 01:01:30 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHDLtmJBm9CJ+hx878zFH0HBBrOoSc1/yq87wVhx1fLkCpsqKzv9yZNreiwdVe8o/Q5a7CMrQ==
X-Received: by 2002:a05:6000:2284:b0:3a0:80b2:eedc with SMTP id ffacd0b85a97d-3a09fddfc9dmr4934259f8f.52.1746432089919;
        Mon, 05 May 2025 01:01:29 -0700 (PDT)
Received: from ?IPV6:2003:cb:c73d:2400:3be1:a856:724c:fd29? (p200300cbc73d24003be1a856724cfd29.dip0.t-ipconnect.de. [2003:cb:c73d:2400:3be1:a856:724c:fd29])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3a099ae7a46sm9423271f8f.44.2025.05.05.01.01.27
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 05 May 2025 01:01:29 -0700 (PDT)
Message-ID: <7e32aabe-c170-4cfc-99aa-f257d2a69364@redhat.com>
Date: Mon, 5 May 2025 10:01:26 +0200
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v8 06/13] KVM: x86: Generalize private fault lookups to
 guest_memfd fault lookups
To: Ackerley Tng <ackerleytng@google.com>,
 Sean Christopherson <seanjc@google.com>
Cc: Fuad Tabba <tabba@google.com>, kvm@vger.kernel.org,
 linux-arm-msm@vger.kernel.org, linux-mm@kvack.org, pbonzini@redhat.com,
 chenhuacai@kernel.org, mpe@ellerman.id.au, anup@brainfault.org,
 paul.walmsley@sifive.com, palmer@dabbelt.com, aou@eecs.berkeley.edu,
 viro@zeniv.linux.org.uk, brauner@kernel.org, willy@infradead.org,
 akpm@linux-foundation.org, xiaoyao.li@intel.com, yilun.xu@intel.com,
 chao.p.peng@linux.intel.com, jarkko@kernel.org, amoorthy@google.com,
 dmatlack@google.com, isaku.yamahata@intel.com, mic@digikod.net,
 vbabka@suse.cz, vannapurve@google.com, mail@maciej.szmigiero.name,
 michael.roth@amd.com, wei.w.wang@intel.com, liam.merwick@oracle.com,
 isaku.yamahata@gmail.com, kirill.shutemov@linux.intel.com,
 suzuki.poulose@arm.com, steven.price@arm.com, quic_eberman@quicinc.com,
 quic_mnalajal@quicinc.com, quic_tsoni@quicinc.com,
 quic_svaddagi@quicinc.com, quic_cvanscha@quicinc.com,
 quic_pderrin@quicinc.com, quic_pheragu@quicinc.com, catalin.marinas@arm.com,
 james.morse@arm.com, yuzenghui@huawei.com, oliver.upton@linux.dev,
 maz@kernel.org, will@kernel.org, qperret@google.com, keirf@google.com,
 roypat@amazon.co.uk, shuah@kernel.org, hch@infradead.org, jgg@nvidia.com,
 rientjes@google.com, jhubbard@nvidia.com, fvdl@google.com, hughd@google.com,
 jthoughton@google.com, peterx@redhat.com, pankaj.gupta@amd.com
References: <diqz7c31xyqs.fsf@ackerleytng-ctop.c.googlers.com>
 <386c1169-8292-43d1-846b-c50cbdc1bc65@redhat.com>
 <aBTxJvew1GvSczKY@google.com>
 <diqzjz6ypt9y.fsf@ackerleytng-ctop.c.googlers.com>
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
In-Reply-To: <diqzjz6ypt9y.fsf@ackerleytng-ctop.c.googlers.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 03.05.25 00:00, Ackerley Tng wrote:
> Sean Christopherson <seanjc@google.com> writes:
> 
>> On Fri, May 02, 2025, David Hildenbrand wrote:
>>> On 30.04.25 20:58, Ackerley Tng wrote:
>>>>> -	if (is_private)
>>>>> +	if (is_gmem)
>>>>>    		return max_level;
>>>>
>>>> I think this renaming isn't quite accurate.
>>>
>>> After our discussion yesterday, does that still hold true?
>>
>> No.
>>
>>>> IIUC in __kvm_mmu_max_mapping_level(), we skip considering
>>>> host_pfn_mapping_level() if the gfn is private because private memory
>>>> will not be mapped to userspace, so there's no need to query userspace
>>>> page tables in host_pfn_mapping_level().
>>>
>>> I think the reason was that: for private we won't be walking the user space
>>> pages tables.
>>>
>>> Once guest_memfd is also responsible for the shared part, why should this
>>> here still be private-only, and why should we consider querying a user space
>>> mapping that might not even exist?
>>
>> +1, one of the big selling points for guest_memfd beyond CoCo is that it provides
>> guest-first memory.  It is very explicitly an intended feature that the guest
>> mappings KVM creates can be a superset of the host userspace mappings.  E.g. the
>> guest can use larger page sizes, have RW while the host has RO, etc.
> 
> Do you mean that __kvm_mmu_max_mapping_level() should, in addition to
> the parameter renaming from is_private to is_gmem, do something like
> 
> if (is_gmem)
> 	return kvm_gmem_get_max_mapping_level(slot, gfn);

I assume you mean, not looking at lpage_info at all?

I have limited understanding what lpage_info is or what it does. I 
believe all it adds is a mechanism to *disable* large page mappings.

We want to disable large pages if (using 2M region as example)

(a) Mixed memory attributes. If a PFN falls into a 2M region, and parts
     of that region are shared vs. private (mixed memory attributes ->
     KVM_LPAGE_MIXED_FLAG)

  -> With gmem-shared we could have mixed memory attributes, not a PFN
     fracturing. (PFNs don't depend on memory attributes)

(b) page track: intercepting (mostly write) access to GFNs


So, I wonder if we still have to take care of lpage_info, at least for
handling (b) correctly [I assume so]. Regarding (a) I am not sure: once 
memory attributes are handled by gmem in the gmem-shared case. IIRC, 
with AMD SEV we might still have to honor it? But gmem itself could 
handle that.


What we could definitely do here for now is:

if (is_gmem)
	/* gmem only supports 4k pages for now. */
	return PG_LEVEL_4K;

And not worry about lpage_infor for the time being, until we actually do 
support larger pages.


> 
> and basically defer to gmem as long as gmem should be used for this gfn?
> 
> There is another call to __kvm_mmu_max_mapping_level() via
> kvm_mmu_max_mapping_level() beginning from recover_huge_pages_range(),
> and IIUC that doesn't go through guest_memfd.
> 
> Hence, unlike the call to __kvm_mmu_max_mapping_level() from the KVM x86
> MMU fault path, guest_memfd didn't get a chance to provide its input in
> the form of returning max_order from kvm_gmem_get_pfn().

Right, we essentially say that "this is a private fault", likely 
assuming that we already verified earlier that the memory is also private.

[I can see that happening when the function is called through 
direct_page_fault()]

We could simply call kvm_mmu_max_mapping_level() from 
kvm_mmu_hugepage_adjust() I guess. (could possibly be optimized later)

-- 
Cheers,

David / dhildenb


