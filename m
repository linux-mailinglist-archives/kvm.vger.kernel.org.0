Return-Path: <kvm+bounces-47373-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id D8F39AC0D4A
	for <lists+kvm@lfdr.de>; Thu, 22 May 2025 15:51:22 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 50BF27B690D
	for <lists+kvm@lfdr.de>; Thu, 22 May 2025 13:48:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 22F1C28C2A5;
	Thu, 22 May 2025 13:49:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="akWnWdb5"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8746528B7FB
	for <kvm@vger.kernel.org>; Thu, 22 May 2025 13:49:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747921795; cv=none; b=jyGvX4+M8MLT7V3qTNVmklTUdV0VCZ6DZlXIN7J7NpaN9wj+uhLrRL2cz27vXswalYpotP5jNISESlgnqFbH3GcHpueu/UidKbwxt+/Lb2Pt4Xaw9hY41F63zgfeSZFWqlVwucH9p3TYOlc0629EtJ4pUK49JwTxtYemsxiWzC4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747921795; c=relaxed/simple;
	bh=leZavQ5av0yU4ztaqrk91pv3D6r37eWmGgWEV80j9rA=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=pirpr300x8/fVCPiPXvp0CKfwDomBEB1y/9HcAIw4aLg12wiqQ7aPNPk+zhQw+CoN6ynLQCKxRay4ugDNoHmlq1zowG/YPt10Jc+F3Z9166TKNA2erum+RBq0gJxvaZQiZjC8gaurd25jBbyWVR1J94MSf+J0sFGZha3OdPCtfU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=akWnWdb5; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1747921792;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=L7ICUgElTJOvmuW/fRUrN0uPtBQoWoTMXBi3f1fVLcg=;
	b=akWnWdb5RMaQIjzhuRYHGja1TyFKfpOyJfUbqvQi9HE5YJtCHhap/ifB/DdZQhijSCmAET
	02EqjaHHqGluXdD+6hzOXfgjoPqGH27msmp9x/kwyabFzunIlIbW0DcYALd41n5rmN4PVZ
	9TSaR/6HKymqTizb6ge/6mg7zOPcHfQ=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-127-GNSK-P5yO82qB0cna9dM8w-1; Thu, 22 May 2025 09:49:51 -0400
X-MC-Unique: GNSK-P5yO82qB0cna9dM8w-1
X-Mimecast-MFC-AGG-ID: GNSK-P5yO82qB0cna9dM8w_1747921790
Received: by mail-wr1-f69.google.com with SMTP id ffacd0b85a97d-3a364d2d0efso3008460f8f.3
        for <kvm@vger.kernel.org>; Thu, 22 May 2025 06:49:51 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1747921790; x=1748526590;
        h=content-transfer-encoding:in-reply-to:organization:autocrypt
         :content-language:from:references:cc:to:subject:user-agent
         :mime-version:date:message-id:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=L7ICUgElTJOvmuW/fRUrN0uPtBQoWoTMXBi3f1fVLcg=;
        b=Qg3pD644Px1uidMgRe5oLTVPH2mccjoUWHQICYEMETqbzWXGtksoXr3UBiTzj+fh+0
         K2fjErvQNKjUF/FUb/8Q04ENbI1GXAqtDocsMwQNaMQMyHOmEk2/eeB0fBnS4BwHLOtD
         VxCXy17+aYxfi7IjcH9rX9tD37t1zPO7c803HGn9PHrsejrcGsfhuE3UAl/OwWtTHOCQ
         3GMk/XV6N4jhhwvR+BnWS3acq+Du7BVQd2W+2Crb7OfoQUQHMbe41BeO2HlghHS2cZSi
         7vNdizNJUmH2SQ13t9epqvFPGNdNFPjVAcnQifcaa++/95jiKi0bTGUhIMMXFXG82Y1o
         H6gw==
X-Forwarded-Encrypted: i=1; AJvYcCU+2i3+hPDSmpxCVCvXXV4jCvVtwNwA5ayTi7bQzhWD3AshAbtXef4YcSm9tsZG2yY8NL0=@vger.kernel.org
X-Gm-Message-State: AOJu0Yy25As/kz+6T7b8lwwLxcgstsKd3DZtZ5QoARxLnRuzGC3XBHlB
	ejAtk8iZlA7//aRAVnMQWEBpxcklInKxAQGqyjjDX0uZ2EZHP/AS3WkXqd1gXDZZgznZbojOtvg
	rJ84eZuzEDPNJHuiPlaIHZmHOJ+kZTCt1fU3sNtx+K7QcBEaU8hEGrg==
X-Gm-Gg: ASbGncsU++m9qMrzBe8vWKTp2PHQ8by+ZHf23C4sTtVcryg4L9wCYBAAsstXCiWA+JO
	PmXI4mSUwq1nK2emndgfQy8d3J5CPXPDPoVxZR7BJRS1abvVGSjx+0Ri5F+KAfTy6AUmbfkKHnU
	JoGth9J6plnj0Mb8p4Ta1Jy3Ohc7N5bqQ4d4FoFFaZIBqbEznPkDjuveH5Xa4htnqFfoivRoA5t
	w0X8L2VqMvPcBLG3rqHiPVAz1B3+zFpHTKp4IsUG3e0/y8J0okfPp3Q9Obp2FJyva6UL4Wxs2F1
	ew2s4vvHn1Gyk6+RFq4seAzFdkP3G/z00+V4xVQ/QOkjuERBWXfRv+9GpOoCp8Um2P59G6EfNo8
	TtlFFg623/tbmZ4NdoBUNQuwPlncxiylZkrkGSv8=
X-Received: by 2002:a5d:5f91:0:b0:3a4:bafb:adca with SMTP id ffacd0b85a97d-3a4bafbb475mr2578827f8f.0.1747921790044;
        Thu, 22 May 2025 06:49:50 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEvJZUocjHElLOP1bw5y0rdD1xEFO66HMenoF7MDlcuX++b3x46AoXstbEElsVoZWIJv7r2/A==
X-Received: by 2002:a5d:5f91:0:b0:3a4:bafb:adca with SMTP id ffacd0b85a97d-3a4bafbb475mr2578805f8f.0.1747921789601;
        Thu, 22 May 2025 06:49:49 -0700 (PDT)
Received: from ?IPV6:2003:d8:2f22:2e00:6e71:238a:de9f:e396? (p200300d82f222e006e71238ade9fe396.dip0.t-ipconnect.de. [2003:d8:2f22:2e00:6e71:238a:de9f:e396])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3a35ca888fcsm24405847f8f.78.2025.05.22.06.49.46
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 22 May 2025 06:49:49 -0700 (PDT)
Message-ID: <37346f0f-8f99-4979-9a0b-7276be6f34b1@redhat.com>
Date: Thu, 22 May 2025 15:49:46 +0200
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v9 10/17] KVM: x86: Compute max_mapping_level with input
 from guest_memfd
To: Sean Christopherson <seanjc@google.com>,
 Ackerley Tng <ackerleytng@google.com>
Cc: tabba@google.com, kvm@vger.kernel.org, linux-arm-msm@vger.kernel.org,
 linux-mm@kvack.org, pbonzini@redhat.com, chenhuacai@kernel.org,
 mpe@ellerman.id.au, anup@brainfault.org, paul.walmsley@sifive.com,
 palmer@dabbelt.com, aou@eecs.berkeley.edu, viro@zeniv.linux.org.uk,
 brauner@kernel.org, willy@infradead.org, akpm@linux-foundation.org,
 xiaoyao.li@intel.com, yilun.xu@intel.com, chao.p.peng@linux.intel.com,
 jarkko@kernel.org, amoorthy@google.com, dmatlack@google.com,
 isaku.yamahata@intel.com, mic@digikod.net, vbabka@suse.cz,
 vannapurve@google.com, mail@maciej.szmigiero.name, michael.roth@amd.com,
 wei.w.wang@intel.com, liam.merwick@oracle.com, isaku.yamahata@gmail.com,
 kirill.shutemov@linux.intel.com, suzuki.poulose@arm.com,
 steven.price@arm.com, quic_eberman@quicinc.com, quic_mnalajal@quicinc.com,
 quic_tsoni@quicinc.com, quic_svaddagi@quicinc.com,
 quic_cvanscha@quicinc.com, quic_pderrin@quicinc.com,
 quic_pheragu@quicinc.com, catalin.marinas@arm.com, james.morse@arm.com,
 yuzenghui@huawei.com, oliver.upton@linux.dev, maz@kernel.org,
 will@kernel.org, qperret@google.com, keirf@google.com, roypat@amazon.co.uk,
 shuah@kernel.org, hch@infradead.org, jgg@nvidia.com, rientjes@google.com,
 jhubbard@nvidia.com, fvdl@google.com, hughd@google.com,
 jthoughton@google.com, peterx@redhat.com, pankaj.gupta@amd.com,
 ira.weiny@intel.com
References: <5ace54d1-800b-4122-8c05-041aa0ee12a1@redhat.com>
 <diqzcyc18odo.fsf@ackerleytng-ctop.c.googlers.com>
 <aC8k-uJ1JV1wh8fZ@google.com>
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
In-Reply-To: <aC8k-uJ1JV1wh8fZ@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 22.05.25 15:22, Sean Christopherson wrote:
> On Wed, May 21, 2025, Ackerley Tng wrote:
>>>> diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
>>>> index de7b46ee1762..f9bb025327c3 100644
>>>> --- a/include/linux/kvm_host.h
>>>> +++ b/include/linux/kvm_host.h
>>>> @@ -2560,6 +2560,7 @@ static inline bool kvm_mem_is_private(struct kvm *kvm, gfn_t gfn)
>>>>    int kvm_gmem_get_pfn(struct kvm *kvm, struct kvm_memory_slot *slot,
>>>>    		     gfn_t gfn, kvm_pfn_t *pfn, struct page **page,
>>>>    		     int *max_order);
>>>> +int kvm_gmem_mapping_order(const struct kvm_memory_slot *slot, gfn_t gfn);
>>>>    #else
>>>>    static inline int kvm_gmem_get_pfn(struct kvm *kvm,
>>>>    				   struct kvm_memory_slot *slot, gfn_t gfn,
>>>> @@ -2569,6 +2570,12 @@ static inline int kvm_gmem_get_pfn(struct kvm *kvm,
>>>>    	KVM_BUG_ON(1, kvm);
>>>>    	return -EIO;
>>>>    }
>>>> +static inline int kvm_gmem_mapping_order(const struct kvm_memory_slot *slot,
>>>> +					 gfn_t gfn)
>>>
>>> Probably should indent with two tabs here.
>>
>> Yup!
> 
> Nope!  :-)
> 
> In KVM, please align the indentation as you did.
> 
>   : Yeah, that way of indenting is rather bad practice. Especially for new
>   : code we're adding or when we touch existing code, we should just use two
>   : tabs.
> 
>   : That way, we can fit more stuff into a single line, and when doing
>   : simple changes, such as renaming the function or changing the return
>   : type, we won't have to touch all the parameters.
> 
> At the cost of readability, IMO.  The number of eyeballs that read the code is
> orders of magnitude greater than the number of times a function's parameters end
> up being shuffled around.  Sacrificing readability and consistenty to avoid a
> small amount of rare churn isn't a good tradeoff.

I new KVM wanted to be weird! :P

-- 
Cheers,

David / dhildenb


