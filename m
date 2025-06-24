Return-Path: <kvm+bounces-50484-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 724E9AE63C6
	for <lists+kvm@lfdr.de>; Tue, 24 Jun 2025 13:44:17 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id EC1584A62B7
	for <lists+kvm@lfdr.de>; Tue, 24 Jun 2025 11:44:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2E23C28D8D4;
	Tue, 24 Jun 2025 11:44:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="gp+nVjod"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C61B028136F
	for <kvm@vger.kernel.org>; Tue, 24 Jun 2025 11:44:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750765450; cv=none; b=k3e5ygHkUYNeq0m/6e8h9BlRyMV3iQVmC0uOqN+I50JYIy7GL/z0d9yex9Hm6WYwy9Pr5ar6iudvAzSp3k22PvtbnaUBd7IB4OCZa/gkblwCGoblRPBqd9X04T660SjPgTWa5VifongkZeF1pOxlEm4TveLbHZNpvi71+j6wskI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750765450; c=relaxed/simple;
	bh=vN5RGYb8CnjbO9hLOaUxCn0B0QjHDC22ZiJq3J3vgG4=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=u3f/aVTjtnvt15Mkj2hcs8NLklj2ZB3KdWYRYiDB/C0KRnYMHQVCsNE22w6iero8qKTVWyoZQSlRm6QoapRlGM+CvQJaIMH2kddU2o0KHI11b5NR8zq7xTT+UkL9U9+vQUJHnnbfzAS3s5n2ELCXtRkgVLG/q2QvxrvxZGy91AY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=gp+nVjod; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1750765447;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=mWIxS9YRc3nZx7A+TXGsN2wq57/2Fy5jMiTU7iuOoO4=;
	b=gp+nVjodh1wQw52PaXN/EDkgJK7ibcvHfNbxg7KhH3SjygmIoUnxp1kRKrygSz7/hAbPTq
	JJpNbax6Okkx8EgI4LS8W89ly8WiH2S3uIcTNk+QnVvJHAzOxodMKIIXVxYz/duvKE+fY3
	JxX3iGIzMsvke+n7tDeow9cwc4opdeA=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-682-NPf55HRzO9qKiBFUWUhb3Q-1; Tue, 24 Jun 2025 07:44:06 -0400
X-MC-Unique: NPf55HRzO9qKiBFUWUhb3Q-1
X-Mimecast-MFC-AGG-ID: NPf55HRzO9qKiBFUWUhb3Q_1750765445
Received: by mail-wm1-f72.google.com with SMTP id 5b1f17b1804b1-450d6768d4dso34826885e9.2
        for <kvm@vger.kernel.org>; Tue, 24 Jun 2025 04:44:06 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1750765445; x=1751370245;
        h=content-transfer-encoding:in-reply-to:organization:autocrypt
         :content-language:from:references:cc:to:subject:user-agent
         :mime-version:date:message-id:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=mWIxS9YRc3nZx7A+TXGsN2wq57/2Fy5jMiTU7iuOoO4=;
        b=jfKJNWgFikNDHxwECqgQrICNOgdQ7vTvadKJytncfehf95iaxgUXZpMjBUvNMs5eoF
         M0j+mpgH4c/dzuj7RTAvCNoivjoya+wnPTd+EmBF/k2MeCbg9LuVNmEm6WTa+vqTZ4gE
         IPbEEUXgO3hILwCLm2Hyxw6qp/30elSbKNU0Llt14AzUrDcCOvtaBRzaB6rsdiAZQ7Gm
         Y1dDXFjVgZNcXlPIgqS/Y7l1XdnBBEtYxQbfDrnUf53bIZwGVjosA7IyR7Bxd/H/gIb6
         Zl3c9ATWEzU8WucdIQdwco62gLtYX+Z/OaAnQnWKisJI5dgg9PkLfbxS4J2TL5CM9RAv
         3+3w==
X-Forwarded-Encrypted: i=1; AJvYcCUm+AqFGhdJhZ5xJSr/QCGHMwHvANU88wcmTGhQp3m6IwC5npfj0x9Zmo2zwewgGF7M+L8=@vger.kernel.org
X-Gm-Message-State: AOJu0YzigSVl9lIbEPKDkBx3k0InZ8+w/7TK1lY43kFEIfh7aKtfkN4D
	U+0QHzkRqLU6QtjqzXR/QBlNvzfrlQWUpuXPUDI0ExXDaNPXS3FUxOmpDpB7J3LMfMQaQXAT7nm
	cUe+Yx5XshF4L3dL5QgmT1OmPNvy/dTmN0ubxhf4BWvH1igSnDwW5ug==
X-Gm-Gg: ASbGncvjtY2TyFDoPrjF93WSNlfh7LO5lCVdZimSQl3bvMkVPjt1uCVaP1ZfKG60joq
	YFuYxyLWinU4xd/9cWHqqIHg0HtImRAa9SjGpn87Cg5H8Du0Vo9rUapQ1LlPioVPZl7QqjlLy8L
	CKAv0DBECBXzbmaogEYX2ADrTvzPaVDTr81dpP+BzPRj023KLIJI4c93P0+sB5Oy88tYHmFUMYT
	oLef8n0Q9Aii692LG7/ECuAJamCQm2U9qUn28hQCq7kMOkjq4m1IhzmnUtrv93QGM0Uo3b8Fbmr
	8qAIJTQNraOqT2eCZ/phVG/n7I1328/8l9iLXzaIi63TPqI2OaQyp+0=
X-Received: by 2002:a05:600c:a016:b0:450:ceb2:67dd with SMTP id 5b1f17b1804b1-45365a0026dmr138203825e9.33.1750765445099;
        Tue, 24 Jun 2025 04:44:05 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGu2tGkM7OI2Bjjt9QwycoZQ3Rtbqmwt/+aXANf/vpkZTdvOWQBqbd7keMeDPMxBFE50VeBMw==
X-Received: by 2002:a05:600c:a016:b0:450:ceb2:67dd with SMTP id 5b1f17b1804b1-45365a0026dmr138203425e9.33.1750765444628;
        Tue, 24 Jun 2025 04:44:04 -0700 (PDT)
Received: from ?IPV6:2a09:80c0:192:0:5dac:bf3d:c41:c3e7? ([2a09:80c0:192:0:5dac:bf3d:c41:c3e7])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3a6e805e828sm1794502f8f.32.2025.06.24.04.44.01
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 24 Jun 2025 04:44:03 -0700 (PDT)
Message-ID: <11b23ea3-cadd-442b-88d7-491bba99dabe@redhat.com>
Date: Tue, 24 Jun 2025 13:44:00 +0200
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v12 00/18] KVM: Mapping guest_memfd backed memory at the
 host for software protected VMs
To: Fuad Tabba <tabba@google.com>
Cc: Sean Christopherson <seanjc@google.com>, kvm@vger.kernel.org,
 linux-arm-msm@vger.kernel.org, linux-mm@kvack.org, kvmarm@lists.linux.dev,
 pbonzini@redhat.com, chenhuacai@kernel.org, mpe@ellerman.id.au,
 anup@brainfault.org, paul.walmsley@sifive.com, palmer@dabbelt.com,
 aou@eecs.berkeley.edu, viro@zeniv.linux.org.uk, brauner@kernel.org,
 willy@infradead.org, akpm@linux-foundation.org, xiaoyao.li@intel.com,
 yilun.xu@intel.com, chao.p.peng@linux.intel.com, jarkko@kernel.org,
 amoorthy@google.com, dmatlack@google.com, isaku.yamahata@intel.com,
 mic@digikod.net, vbabka@suse.cz, vannapurve@google.com,
 ackerleytng@google.com, mail@maciej.szmigiero.name, michael.roth@amd.com,
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
References: <20250611133330.1514028-1-tabba@google.com>
 <80e062dd-2445-45a6-ba4a-8f5fe3286909@redhat.com>
 <CA+EHjTx2MUq98=j=5J+GwSJ1gd7ax-RrpS8WhEJg4Lk9_USUmA@mail.gmail.com>
 <372bbfa5-1869-4bf2-9c16-0b828cdb86f5@redhat.com>
 <CA+EHjTyxwdu5YhtZRcwb-iR7aaEq1beV+4VWSsv7-X2tDVBkrA@mail.gmail.com>
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
In-Reply-To: <CA+EHjTyxwdu5YhtZRcwb-iR7aaEq1beV+4VWSsv7-X2tDVBkrA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 24.06.25 12:25, Fuad Tabba wrote:
> Hi David,
> 
> On Tue, 24 Jun 2025 at 11:16, David Hildenbrand <david@redhat.com> wrote:
>>
>> On 24.06.25 12:02, Fuad Tabba wrote:
>>> Hi,
>>>
>>> Before I respin this, I thought I'd outline the planned changes for
>>> V13, especially since it involves a lot of repainting. I hope that
>>> by presenting this first, we could reduce the number of times I'll
>>> need to respin it.
>>>
>>> In struct kvm_arch: add bool supports_gmem instead of renaming
>>> has_private_mem
>>>
>>> The guest_memfd flag GUEST_MEMFD_FLAG_SUPPORT_SHARED should be
>>> called GUEST_MEMFD_FLAG_MMAP
>>>
>>> The memslot internal flag KVM_MEMSLOT_SUPPORTS_GMEM_SHARED should be
>>> called KVM_MEMSLOT_SUPPORTS_GMEM_MMAP
>>>
>>> kvm_arch_supports_gmem_shared_mem() should be called
>>> kvm_arch_supports_gmem_mmap()
>>>
>>> kvm_gmem_memslot_supports_shared() should be called
>>> kvm_gmem_memslot_supports_mmap()
>>>
>>> kvm_gmem_fault_shared(struct vm_fault *vmf) should be called
>>> kvm_gmem_fault_user_mapping(struct vm_fault *vmf)
>>>
>>> The capability KVM_CAP_GMEM_SHARED_MEM should be called
>>> KVM_CAP_GMEM_MMAP
>>>
>>> The Kconfig CONFIG_KVM_GMEM_SHARED_MEM should be called
>>> CONFIG_KVM_GMEM_SUPPORTS_MMAP
>>
>> Works for me.
>>
>>>
>>> Also, what (unless you disagree) will stay the same as V12:
>>>
>>> Rename CONFIG_KVM_PRIVATE_MEM to CONFIG_KVM_GMEM: Since private
>>> implies gmem, and we will have additional flags for MMAP support
>>
>> Agreed.
>>
>>>
>>> Rename CONFIG_KVM_GENERIC_PRIVATE_MEM to
>>> CONFIG_KVM_GENERIC_GMEM_POPULATE
>>
>> Agreed.
>>
>>>
>>> Rename  kvm_slot_can_be_private() to kvm_slot_has_gmem(): since
>>> private does imply that it has gmem
>>
>> Right. It's a little more tricky in reality at least with this series:
>> without in-place conversion, not all gmem can have private memory. But
>> the places that check kvm_slot_can_be_private() likely only care about
>> if this memslot is backed by gmem.
> 
> Exactly. Reading the code, all the places that check
> kvm_slot_can_be_private() are really checking whether the slot has
> gmem. After this series, if a caller is interested in finding out
> whether a slot can be private could achieve the same effect by
> checking that a gmem slot doesn't support mmap (i.e.,
> kvm_slot_has_gmem() && kvm_arch_supports_gmem_mmap() ). If that
> happens, we can reintroduce kvm_slot_can_be_private() as such.
> 
> Otherwise, I could keep it and already define it as so. What do you think?
> 
>> Sean also raised a "kvm_is_memslot_gmem_only()", how did you end up
>> calling that?
> 
> Good point, I'd missed that. Isn't it true that
> kvm_is_memslot_gmem_only() is synonymous (at least for now) with
> kvm_gmem_memslot_supports_mmap()?

Yes. I think having a simple kvm_is_memslot_gmem_only() helper might 
make fault handling code easier to read, though.

-- 
Cheers,

David / dhildenb


