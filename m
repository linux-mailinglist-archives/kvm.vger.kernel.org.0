Return-Path: <kvm+bounces-43271-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id F3912A88C61
	for <lists+kvm@lfdr.de>; Mon, 14 Apr 2025 21:43:07 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 098237A8EBB
	for <lists+kvm@lfdr.de>; Mon, 14 Apr 2025 19:41:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A56421C3C14;
	Mon, 14 Apr 2025 19:42:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="L7CULoH7"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DD1844C74
	for <kvm@vger.kernel.org>; Mon, 14 Apr 2025 19:42:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744659777; cv=none; b=tdcuoWqvP+1j6+ip2mLr4e94qyl9l7Jp2hZ/G5QNElPnM8a00VhamdT8xnpdtn4h+r8oPv6Gf/y/zNt2UapHha83BF456C2JZpZps8XodSKSg6GwyuHh6HY5l2IjG2uoztzqpeklxJ6zsHIJF0c5kBRggBgc0rSVrKuwFxdCItw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744659777; c=relaxed/simple;
	bh=o4fgBswOSkBHLviYU+653N02TTLhxlY+0/hgjdYZiy0=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=jE8ivVLWjbJlUj3kNa1YjJ4mYcRAHykt5KSoqd4NNMwSF4nmodYK2iu7JaEoJRAltnckezrXlnvavVn94u1GXbxb1XcLC2NHqf3cgf3Tc/bljNN1eZfx+xC2Ym/QpvXWjdQZ2cDTLj3BpftxMCqyCrYMC1330+E8oMt1uPyApqw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=L7CULoH7; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1744659774;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=pT5r9iBLZj4GusFqEfMScidmqAeBKtc+LdH5uu6fGeA=;
	b=L7CULoH7ajoXQNiZ9JYj5mgYuklyNPWe6b3kPnaFnQbcMA2larJ3PCl0LdH2qGJey07SD0
	ai3T08U0IWPsXVAA3a9HezvJRInjvVHRKX5PJ+IW82nQH0XIsnKZfvOs9L6D92t7Z0dTJK
	8UfW+D3xVfyXsTwjn3pNoPu0Pf16CcI=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-610-9Sax2eGLPYGW4phm3mRrCw-1; Mon, 14 Apr 2025 15:42:53 -0400
X-MC-Unique: 9Sax2eGLPYGW4phm3mRrCw-1
X-Mimecast-MFC-AGG-ID: 9Sax2eGLPYGW4phm3mRrCw_1744659772
Received: by mail-wm1-f70.google.com with SMTP id 5b1f17b1804b1-43e9b0fd00cso23709875e9.0
        for <kvm@vger.kernel.org>; Mon, 14 Apr 2025 12:42:53 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1744659772; x=1745264572;
        h=content-transfer-encoding:in-reply-to:organization:autocrypt
         :content-language:from:references:cc:to:subject:user-agent
         :mime-version:date:message-id:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=pT5r9iBLZj4GusFqEfMScidmqAeBKtc+LdH5uu6fGeA=;
        b=WZxubyUAxvxxFlwij5feo4PsZ5Dm4bTL9iDiGV0aIXABfbp3Rd+2i7/Bv+FHbE4ttB
         +WmoAvWh2Yoou+ppmn8Zih/+w4RGHUQkzBlN6PnuE1/YIBkf3d2O157S0x35LTf/WgBf
         AHdkd0nIC2QwB6d5rhbaH6QTgwdM96IyeRaUDmsu9F9/pCVsBX2poLMfO7k9F7itl+oD
         gOchihJi9IxNsVM5r3svhhDtJIW+7bY0ztAAacjl8QjTvburwzv/im66maqxhQB7O1cT
         PX+BP1c1PZD7VJF6VL/gzgDO9eez8xLra/g5t0hB7s10hZae0XkZjvZubYOkvjvKl3VS
         2cfQ==
X-Gm-Message-State: AOJu0Yxcu1lvVC+FdSgEaxkYW0BAniZxJBg4j8G9Dnsvwx+KnRstMhH3
	ov3bb0nE6ZVRvvNI3O+ucCdYfMhlXF2LgrSqr8ZkdxVFrD5bTIqhwCbCrxbl3RPCGRBASN8083U
	4DChmlv+jKGhJCjqASB3H4uk74NhoYVGhdkI5JewA8tyLL25W1A==
X-Gm-Gg: ASbGncvWgT6AGeQ+RvS2D0wa6Kte3EMBvUYbY8HEEEefKunVIHknj8zIRE9amFAAJnD
	TEVfTLZWvBQRjcnZN9owA6xKnSiUn49E6ViR47Hox8tTMdmEHGhCST7oWdP0wt2g3F0rvF6iJli
	lAni/V8C1DABzIrYWAGeMmIlt4z+wM51RjGlchyiLwfC48EKCpstJPAhJLkT0LmyqprruVZhTGb
	QZ7GKTQVxWwh0OBztPAz6PIdS4NtfhynEdcWB14htrVx1TrvFRcDxArI2D2V/OoFLHn+oMZdYMF
	5ZzThnpZEYNeT5ngxCIXR7LJBnBvV7X6UbhhbzqiZydkxYB3jAgqyOOvE1AxHqIyuUa3fuAosOO
	Kj83R7L7avWL6zjIdbnJ3KSGVEMJKIJFyOM6meA==
X-Received: by 2002:a05:600c:35c5:b0:439:4b23:9e8e with SMTP id 5b1f17b1804b1-43f99889ad0mr5120545e9.3.1744659772196;
        Mon, 14 Apr 2025 12:42:52 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHLSLcGUzHCiCgpLJHBLnwWCeZhh7zTLZd+w+RUgzE+h97venDG0rJVKuVFsw3uE6fcozV9/A==
X-Received: by 2002:a05:600c:35c5:b0:439:4b23:9e8e with SMTP id 5b1f17b1804b1-43f99889ad0mr5120255e9.3.1744659771679;
        Mon, 14 Apr 2025 12:42:51 -0700 (PDT)
Received: from ?IPV6:2003:d8:2f02:2900:f54f:bad7:c5f4:9404? (p200300d82f022900f54fbad7c5f49404.dip0.t-ipconnect.de. [2003:d8:2f02:2900:f54f:bad7:c5f4:9404])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-43f20626c19sm192945175e9.15.2025.04.14.12.42.49
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 14 Apr 2025 12:42:51 -0700 (PDT)
Message-ID: <103b8afc-96e3-4a04-b36c-9a8154296426@redhat.com>
Date: Mon, 14 Apr 2025 21:42:48 +0200
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v7 4/9] KVM: guest_memfd: Handle in-place shared memory as
 guest_memfd backed memory
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
 jthoughton@google.com, peterx@redhat.com
References: <20250318161823.4005529-1-tabba@google.com>
 <20250318161823.4005529-5-tabba@google.com>
 <8ebc66ae-5f37-44c0-884b-564a65467fe4@redhat.com>
 <CA+EHjTwjShH8vw-YsSmPk0yNY3akLFT3R9COtWLVgLozT_G7nA@mail.gmail.com>
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
In-Reply-To: <CA+EHjTwjShH8vw-YsSmPk0yNY3akLFT3R9COtWLVgLozT_G7nA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 14.04.25 18:03, Fuad Tabba wrote:
> Hi David,
> 
> On Mon, 14 Apr 2025 at 12:51, David Hildenbrand <david@redhat.com> wrote:
>>
>> On 18.03.25 17:18, Fuad Tabba wrote:
>>> For VMs that allow sharing guest_memfd backed memory in-place,
>>> handle that memory the same as "private" guest_memfd memory. This
>>> means that faulting that memory in the host or in the guest will
>>> go through the guest_memfd subsystem.
>>>
>>> Note that the word "private" in the name of the function
>>> kvm_mem_is_private() doesn't necessarily indicate that the memory
>>> isn't shared, but is due to the history and evolution of
>>> guest_memfd and the various names it has received. In effect,
>>> this function is used to multiplex between the path of a normal
>>> page fault and the path of a guest_memfd backed page fault.
>>>
>>> Signed-off-by: Fuad Tabba <tabba@google.com>
>>> ---
>>>    include/linux/kvm_host.h | 3 ++-
>>>    1 file changed, 2 insertions(+), 1 deletion(-)
>>>
>>> diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
>>> index 601bbcaa5e41..3d5595a71a2a 100644
>>> --- a/include/linux/kvm_host.h
>>> +++ b/include/linux/kvm_host.h
>>> @@ -2521,7 +2521,8 @@ static inline bool kvm_mem_is_private(struct kvm *kvm, gfn_t gfn)
>>>    #else
>>>    static inline bool kvm_mem_is_private(struct kvm *kvm, gfn_t gfn)
>>>    {
>>> -     return false;
>>> +     return kvm_arch_gmem_supports_shared_mem(kvm) &&
>>> +            kvm_slot_can_be_private(gfn_to_memslot(kvm, gfn));
>>>    }
>>>    #endif /* CONFIG_KVM_GENERIC_MEMORY_ATTRIBUTES */
>>>
>>
>> I've been thinking long about this, and was wondering if we should instead
>> clean up the code to decouple the "private" from gmem handling first.
>>
>> I know, this was already discussed a couple of times, but faking that
>> shared memory is private looks odd.
> 
> I agree. I've been wanting to do that as part of a separate series,
> since renaming discussions sometimes tend to take a disproportionate
> amount of time.But the confusion the current naming (and overloading
> of terms) is causing is probably worse.

Exactly my thoughts. The cleanup diff I was able to come up with is not 
too crazy, so it feels feasible to just include the cleanups as a 
preparation for mmap() where we introduce the concept of shared memory 
in guest_memfd.

> 
>>
>> I played with the code to star cleaning this up. I ended up with the following
>> gmem-terminology  cleanup patches (not even compile tested)
>>
>> KVM: rename CONFIG_KVM_GENERIC_PRIVATE_MEM to CONFIG_KVM_GENERIC_GMEM_POPULATE
>> KVM: rename CONFIG_KVM_PRIVATE_MEM to CONFIG_KVM_GMEM
>> KVM: rename kvm_arch_has_private_mem() to kvm_arch_supports_gmem()
>> KVM: x86: rename kvm->arch.has_private_mem to kvm->arch.supports_gmem
>> KVM: rename kvm_slot_can_be_private() to kvm_slot_has_gmem()
>> KVM: x86: generalize private fault lookups to "gmem" fault lookups
>>
>> https://github.com/davidhildenbrand/linux/tree/gmem_shared_prep
>>
>> On top of that, I was wondering if we could look into doing something like
>> the following. It would also allow for pulling pages out of gmem for
>> existing SW-protected VMs once they enable shared memory for GMEM IIUC.
>>
>>
>> diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
>> index 08eebd24a0e18..6f878cab0f466 100644
>> --- a/arch/x86/kvm/mmu/mmu.c
>> +++ b/arch/x86/kvm/mmu/mmu.c
>> @@ -4495,11 +4495,6 @@ static int kvm_mmu_faultin_pfn_gmem(struct kvm_vcpu *vcpu,
>>    {
>>           int max_order, r;
>>
>> -       if (!kvm_slot_has_gmem(fault->slot)) {
>> -               kvm_mmu_prepare_memory_fault_exit(vcpu, fault);
>> -               return -EFAULT;
>> -       }
>> -
>>           r = kvm_gmem_get_pfn(vcpu->kvm, fault->slot, fault->gfn, &fault->pfn,
>>                                &fault->refcounted_page, &max_order);
>>           if (r) {
>> @@ -4518,8 +4513,19 @@ static int __kvm_mmu_faultin_pfn(struct kvm_vcpu *vcpu,
>>                                    struct kvm_page_fault *fault)
>>    {
>>           unsigned int foll = fault->write ? FOLL_WRITE : 0;
>> +       bool use_gmem = false;
>> +
>> +       if (fault->is_private) {
>> +               if (!kvm_slot_has_gmem(fault->slot)) {
>> +                       kvm_mmu_prepare_memory_fault_exit(vcpu, fault);
>> +                       return -EFAULT;
>> +               }
>> +               use_gmem = true;
>> +       } else if (kvm_slot_has_gmem_with_shared(fault->slot)) {
>> +               use_gmem = true;
>> +       }
>>
>> -       if (fault->is_private)
>> +       if (use_gmem)
>>                   return kvm_mmu_faultin_pfn_gmem(vcpu, fault);
>>
>>           foll |= FOLL_NOWAIT;
>>
>>
>> That is, we'd not claim that things are private when they are not, but instead
>> teach the code about shared memory coming from gmem.
>>
>> There might be some more missing, just throwing it out there if I am completely off.
> 
> For me these changes seem to be reasonable all in all. I might want to
> suggest a couple of modifications, but I guess the bigger question is
> what the KVM maintainers and guest_memfd's main contributors think.

I'm afraid we won't get a reply before we officially send it ...

> 
> Also, how do you suggest we go about this? Send out a separate series
> first, before continuing with the mapping series? Or have it all as
> one big series? It could be something to add to the agenda for
> Thursday.

... and ideally it would be part of this series. After all, this series 
shrunk a bit :)

Feel free to use my commits when helpful: they are still missing 
descriptions and probably have other issues. Feel free to turn my SOB 
into a Co-developed-by+SOB and make yourself the author.

Alternatively, let me know and I can polish them up and we can discuss 
what you have in mind (either here or elsewhere).

I'd suggest we go full-steam on this series to finally get it over the 
finish line :)

-- 
Cheers,

David / dhildenb


