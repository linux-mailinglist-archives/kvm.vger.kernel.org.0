Return-Path: <kvm+bounces-48405-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 569B0ACDF2E
	for <lists+kvm@lfdr.de>; Wed,  4 Jun 2025 15:34:09 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id CA76E188E6AD
	for <lists+kvm@lfdr.de>; Wed,  4 Jun 2025 13:34:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BCFAA28FAAC;
	Wed,  4 Jun 2025 13:34:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="EAtXbRy/"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 515A628D828
	for <kvm@vger.kernel.org>; Wed,  4 Jun 2025 13:33:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749044042; cv=none; b=LcZJFHQ6djRKc9cU9yt8Dhppjh94mIxL0NYlvFEjUZjLsXGy+mDvAhHuGVr2MnYdQq3Tm7QWpiAB6NdHdpdrKiIzk2TYW1w3KpekhtLamRfHNSU5BMhax3HM14cSeLL6dyklItV5puD9Pii6aeYxaOwSqhzC4q6QJ8a93/O4y7I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749044042; c=relaxed/simple;
	bh=OhmOoetKVZIUsUz1F/XVRUPA2bBQBpqIc6z0+iQGLE8=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Gejx7LX9BJ5t2IfIsZPMxQILV3RbLPRMCjmJtSLy9/cQp446ZSiNOtvZIotoK7Dd0MDM+6ZtvyrmRGX4EAbf0e4bfMHgBDW05F0eoE8Nb8JwwReQydJ0JMHr5pmpR2vKNRgtIGMskfdsqCkaEbaWG7sz51tVpL/8IpbaHYUrHnc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=EAtXbRy/; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1749044039;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=400pLR7sGtY1MX0d40R9pVg91ODX78Y5o3a7UpInxi8=;
	b=EAtXbRy/3XrqCxKVwbmz/dk2ZA9XDDrPrfCUKKgG+zYXrm7LJ6ux7/U4nLtl6blS5jI04I
	THoareJAbxWJzbRUWTAXxQjCjjHOcqO3DlhNvZMef+DQvMrjoJbxcLvPbcy/oNP9XroP5E
	gl7JXCqXsxlucQqCyTF2vCZk6Z8KH5s=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-622-k4tgvmFhOImtMpQU0IQ2OQ-1; Wed, 04 Jun 2025 09:33:58 -0400
X-MC-Unique: k4tgvmFhOImtMpQU0IQ2OQ-1
X-Mimecast-MFC-AGG-ID: k4tgvmFhOImtMpQU0IQ2OQ_1749044037
Received: by mail-wr1-f72.google.com with SMTP id ffacd0b85a97d-3a4f7ebfd00so2689818f8f.2
        for <kvm@vger.kernel.org>; Wed, 04 Jun 2025 06:33:57 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1749044037; x=1749648837;
        h=content-transfer-encoding:in-reply-to:organization:autocrypt
         :content-language:from:references:cc:to:subject:user-agent
         :mime-version:date:message-id:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=400pLR7sGtY1MX0d40R9pVg91ODX78Y5o3a7UpInxi8=;
        b=oLP9MHKl/nbt1SXhXS+txauaXCKFATQDb2c+r1h/OoDs68l3+Nx9m8UKOC3bUo0PVP
         0VJDT4NylZ41D0GgpRXKX4yayFDCs4khj8kwAeh+WBQsmA4a1ekBOfIdbRlhydEbR2gw
         pYY27IbRpeaDEgNPVOkYQUSHrYKnytwS1AO561LwEMS6CKBYKeB8bYf6RolG1xAAHnWf
         s9/6FTH0fq+U2cAvMm2XuDF/qjxuAUh8hmkQGUnIEwn8eh1GQPe0FDWZJmS1Px66IyEj
         2ITW+COy9mBOdGAInjQO0mXdZH0v7Cn5JAwEaEcbA4PFYglVZtuoM65EGL1XD7i/QiKg
         /PXw==
X-Gm-Message-State: AOJu0YzhV4NhQKGwIvk3IreVLGF3Xm7YSUHK030RQ6JrsYaGH0zHmt48
	qJTknvlwuddqbEPVUHg7kGHFYbnumKr2mkW47hbu+BgH5yh17OIUCo0SOCKQ/97UZJG+BKWYfHp
	Vm9v8S8S+/st/b7jL/w+Q4nIRJWtYKP6Al+iUQOvUvtezXOLsfyeXeA==
X-Gm-Gg: ASbGncu2ce6YE2wijqnAfvjAYYZORuvDt5dVeTokV4u6buGXhxJ/BohiAzi9hlTkNPX
	DuJzmYhlzVaTzCPcEu6Na1vqkhMw3IOKZ7Y2JVrrP5wHuNPNMiOYmHFAV5qBalYeBu3YFwBXfI3
	0PlHa7S9nli9+sO9T7q0Pyg9igu7Xw3GircmYkhsLKdfHwErp5qLTNV9KitU04lCmgFHjijlTOe
	zOIyRchj16Lk69MNvk/M9UuFaakCH5lSFQf4Cv6Q9ME7VibqdYxX+k3TclmP07rCQnQcQE5NLpq
	8PkRIWofFmJ4X7A/ZdajZt+n4//Auksrq6n9+BGzUn7VarHJnZ5qvWouLC1BYyIeGXLeQLQyz/y
	j0W8rR8rIqePhzx68kwdhh1/owwPTMQH2c7FChEA=
X-Received: by 2002:a05:6000:2903:b0:3a5:42:b17b with SMTP id ffacd0b85a97d-3a51d9581d4mr2363021f8f.29.1749044036700;
        Wed, 04 Jun 2025 06:33:56 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFINzTGjEn+KLVLmOlHfn5DZd0VArTwO1Fk+EQL/M6YEeApuu3Yl+w27J2Vk3WzoGqQXJWtxQ==
X-Received: by 2002:a05:6000:2903:b0:3a5:42:b17b with SMTP id ffacd0b85a97d-3a51d9581d4mr2362954f8f.29.1749044036127;
        Wed, 04 Jun 2025 06:33:56 -0700 (PDT)
Received: from ?IPV6:2003:d8:2f1b:b800:6fdb:1af2:4fbd:1fdf? (p200300d82f1bb8006fdb1af24fbd1fdf.dip0.t-ipconnect.de. [2003:d8:2f1b:b800:6fdb:1af2:4fbd:1fdf])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3a4efe6cd15sm22130665f8f.39.2025.06.04.06.33.53
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 04 Jun 2025 06:33:55 -0700 (PDT)
Message-ID: <61511663-ec0f-4f08-b918-9676661a8c4f@redhat.com>
Date: Wed, 4 Jun 2025 15:33:53 +0200
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v10 13/16] KVM: arm64: Handle guest_memfd-backed guest
 page faults
To: Fuad Tabba <tabba@google.com>
Cc: kvm@vger.kernel.org, linux-arm-msm@vger.kernel.org, linux-mm@kvack.org,
 pbonzini@redhat.com, chenhuacai@kernel.org, mpe@ellerman.id.au,
 anup@brainfault.org, paul.walmsley@sifive.com, palmer@dabbelt.com,
 aou@eecs.berkeley.edu, seanjc@google.com, viro@zeniv.linux.org.uk,
 brauner@kernel.org, willy@infradead.org, akpm@linux-foundation.org,
 xiaoyao.li@intel.com, yilun.xu@intel.com, chao.p.peng@linux.intel.com,
 jarkko@kernel.org, amoorthy@google.com, dmatlack@google.com,
 isaku.yamahata@intel.com, mic@digikod.net, vbabka@suse.cz,
 vannapurve@google.com, ackerleytng@google.com, mail@maciej.szmigiero.name,
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
 jthoughton@google.com, peterx@redhat.com, pankaj.gupta@amd.com,
 ira.weiny@intel.com
References: <20250527180245.1413463-1-tabba@google.com>
 <20250527180245.1413463-14-tabba@google.com>
 <ed1928ce-fc6f-4aaa-9f54-126a8af12240@redhat.com>
 <CA+EHjTz9TSYmssizwtvb6Nixshh1u7n1oj0GpKPQb-rDPs2c1g@mail.gmail.com>
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
In-Reply-To: <CA+EHjTz9TSYmssizwtvb6Nixshh1u7n1oj0GpKPQb-rDPs2c1g@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 04.06.25 15:30, Fuad Tabba wrote:
> Hi David
> 
> On Wed, 4 Jun 2025 at 14:17, David Hildenbrand <david@redhat.com> wrote:
>>
>> On 27.05.25 20:02, Fuad Tabba wrote:
>>> Add arm64 support for handling guest page faults on guest_memfd backed
>>> memslots. Until guest_memfd supports huge pages, the fault granule is
>>> restricted to PAGE_SIZE.
>>>
>>> Signed-off-by: Fuad Tabba <tabba@google.com>
>>>
>>> ---
>>>
>>> Note: This patch introduces a new function, gmem_abort() rather than
>>> previous attempts at trying to expand user_mem_abort(). This is because
>>> there are many differences in how faults are handled when backed by
>>> guest_memfd vs regular memslots with anonymous memory, e.g., lack of
>>> VMA, and for now, lack of huge page support for guest_memfd. The
>>> function user_mem_abort() is already big and unwieldly, adding more
>>> complexity to it made things more difficult to understand.
>>>
>>> Once larger page size support is added to guest_memfd, we could factor
>>> out the common code between these two functions.
>>>
>>> ---
>>>    arch/arm64/kvm/mmu.c | 89 +++++++++++++++++++++++++++++++++++++++++++-
>>>    1 file changed, 87 insertions(+), 2 deletions(-)
>>>
>>> diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
>>> index 9865ada04a81..896c56683d88 100644
>>> --- a/arch/arm64/kvm/mmu.c
>>> +++ b/arch/arm64/kvm/mmu.c
>>> @@ -1466,6 +1466,87 @@ static bool kvm_vma_mte_allowed(struct vm_area_struct *vma)
>>>        return vma->vm_flags & VM_MTE_ALLOWED;
>>>    }
>>>
>>> +static int gmem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
>>> +                       struct kvm_memory_slot *memslot, bool is_perm)
>>
>> TBH, I have no idea why the existing function is called "_abort". I am
>> sure there is a good reason :)
>>
> 
> The reason is ARM. They're called "memory aborts", see D8.15 Memory
> aborts in the ARM ARM:
> 
> https://developer.arm.com/documentation/ddi0487/latest/
> 
> Warning: PDF is 100mb+ with almost 15k pages :)
> 
>>> +{
>>> +     enum kvm_pgtable_walk_flags flags = KVM_PGTABLE_WALK_HANDLE_FAULT | KVM_PGTABLE_WALK_SHARED;
>>> +     enum kvm_pgtable_prot prot = KVM_PGTABLE_PROT_R;
>>> +     bool logging, write_fault, exec_fault, writable;
>>> +     struct kvm_pgtable *pgt;
>>> +     struct page *page;
>>> +     struct kvm *kvm;
>>> +     void *memcache;
>>> +     kvm_pfn_t pfn;
>>> +     gfn_t gfn;
>>> +     int ret;
>>> +
>>> +     if (!is_perm) {
>>> +             int min_pages = kvm_mmu_cache_min_pages(vcpu->arch.hw_mmu);
>>> +
>>> +             if (!is_protected_kvm_enabled()) {
>>> +                     memcache = &vcpu->arch.mmu_page_cache;
>>> +                     ret = kvm_mmu_topup_memory_cache(memcache, min_pages);
>>> +             } else {
>>> +                     memcache = &vcpu->arch.pkvm_memcache;
>>> +                     ret = topup_hyp_memcache(memcache, min_pages);
>>> +             }
>>> +             if (ret)
>>> +                     return ret;
>>> +     }
>>> +
>>> +     kvm = vcpu->kvm;
>>> +     gfn = fault_ipa >> PAGE_SHIFT;
>>
>> These two can be initialized directly above.
>>
> 
> I was trying to go with reverse christmas tree order of declarations,
> but I'll do that.

Can still do that, no? vcpu and fault_ipa are input parameters, so no 
dependency between them.

> 
>>> +
>>> +     logging = memslot_is_logging(memslot);
>>> +     write_fault = kvm_is_write_fault(vcpu);
>>> +     exec_fault = kvm_vcpu_trap_is_exec_fault(vcpu);
>>   > +    VM_BUG_ON(write_fault && exec_fault);
>>
>> No VM_BUG_ON please.
>>
>> VM_WARN_ON_ONCE() maybe. Or just handle it along the "Unexpected L2 read
>> permission error" below cleanly.
> 
> I'm following the same pattern as the existing user_mem_abort(), but
> I'll change it.

Yeah, there are a lot of BUG_ON thingies that should be reworked.

-- 
Cheers,

David / dhildenb


