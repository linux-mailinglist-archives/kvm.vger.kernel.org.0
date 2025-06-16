Return-Path: <kvm+bounces-49624-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 343F1ADB3BA
	for <lists+kvm@lfdr.de>; Mon, 16 Jun 2025 16:27:28 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 9A0A03AA0AE
	for <lists+kvm@lfdr.de>; Mon, 16 Jun 2025 14:22:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E84B21B6D08;
	Mon, 16 Jun 2025 14:20:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="F5+6APed"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8AD1F26529A
	for <kvm@vger.kernel.org>; Mon, 16 Jun 2025 14:20:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750083610; cv=none; b=sRuKYlXm/NcveVkO813kDAtMHqP3ZXNIeKPC+VYXJCFRb5HlvlCiLWkUc5GUv0goKvlmPe/l7WXsCiIpcxv1uEqv81ewFP2ZnWZfvadmZlfYaD4LW6ly7W9kxNvPRVA5Q63R3TcbLkipi9fErlP2Tr1Z7nySr4AoWZIqvYrKBek=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750083610; c=relaxed/simple;
	bh=9LCvD/Ybo04nJpjZnfhMa4oJJsQuLeEGhzkb3RybMis=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=KbeFBU/0YJV/EiT5rzKc7LHjTSALX3APc4URvXAOYzG3cFhxUU+MNJ8brq6TPmjiOgmfespUmdaDXVtJ0mk53iPObmQ7JZnE3dHDsPo3Ogb8zs7qPRFKmiWbh5Vr/cf/0Q8EzIx3bFaNU7HZVc2TEANSwYaQGIruEkmDEAQopoU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=F5+6APed; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1750083607;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=56Tpqkk75kYKzuIVAtIE+REJgb5AnQU2Z8HbyKbkuTk=;
	b=F5+6APedx0RBtpOQzWG/rOjVUkNSHgRxQ1M/TT2C+32qa6laoFfXxB+WA/15xlUgrJqiMs
	9zbQ+TAW1JMEVvK6pKPAqqoRH/J3QmFI7PiD+UimFMsxUjhUpHpuADw/LCnEhhh3lP8WRn
	KCdz9dsTNl8acNFirGUl4niwJ1bYJcU=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-600-VLQSxS3SOb61needB8Ec7g-1; Mon, 16 Jun 2025 10:20:06 -0400
X-MC-Unique: VLQSxS3SOb61needB8Ec7g-1
X-Mimecast-MFC-AGG-ID: VLQSxS3SOb61needB8Ec7g_1750083605
Received: by mail-wr1-f72.google.com with SMTP id ffacd0b85a97d-3a578958000so587191f8f.3
        for <kvm@vger.kernel.org>; Mon, 16 Jun 2025 07:20:05 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1750083605; x=1750688405;
        h=content-transfer-encoding:in-reply-to:organization:autocrypt
         :content-language:from:references:cc:to:subject:user-agent
         :mime-version:date:message-id:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=56Tpqkk75kYKzuIVAtIE+REJgb5AnQU2Z8HbyKbkuTk=;
        b=eNWRdQBZmcfs1r5KAalpkhHMYhuZRxZDWhizIyNs6A+QyIiQWWY6/erK9bghdbQXhF
         7JHZkf4jRfmBaBqogwgIb/0e1dqS2Tw2b28fH7JCp5Vt7eU2qmhD/+34pFETFLF3yqKo
         yi/u5aR/9bCHJFxZehMCZOT/1ZU9rWiJXhH+loQddGsrki1hX5AQ2XMgpSJKD5rcJ7WA
         LrkuUvDN+/kV9/YzifYy8cd0cYZ1mT/NGWPpWGITSn/QiKmFzO+JbhMztQ2gnMDpCfB6
         /4an5zUsTqo2Q1mSl8NyC8l4X8kBpRvDKxXWCK+AiEGcrGy/Fy97RUOFotdIFVx6K/l6
         YHFw==
X-Gm-Message-State: AOJu0YxpJhdlQLqw1OK2Aa4achWVQDGjU5x5lvcCWuoRMiqHuqUHUZT7
	LhYFjcNttyLyxL3KwUUneWuME+lE5R0ltQwon0b6sB6xHs2DPHQmpazu6gCraSnHHNlTYj9gCR9
	QIsj8IeJaexz2jXoq3AOvgU/32SBIw0+nk3vKxbv0HraskwdO460Blg==
X-Gm-Gg: ASbGncuUMVVOLM9bmAixmlcq+H7I8dEiTRL0C1aKNckciXy/mhn8syN6qgJll8zEu87
	mMWg/eEGBFBYuLG0x+aTa+sOcLVMLTgct6WmVlF1/WMcDeHZqcORpdIMX/aZ3TiPhdZ8+acNTC7
	/CsCm0X8+bgqT/PH2cXa0oY8Gym4edlM1ILtvkR9yDGYGAdQcFuL2FTpEl6g9opMJKaECrkhkfm
	OojcYTInJjkZHkE/Yuynl591DQ+xni+w7oBdXWQTvfk+qcj2OmdSxV7/WhRvGEVFF+Ty7rjDpj8
	nbnSVIoWWx5V1zy/5pig2J9Sqo+PuM4R48DUgKmsVfFMllLOCuEVmVK91PjpSEkNwi8GWLYJK4W
	qVQ2u60vtizrGdggv7u1rTcBaTJJdF53uiXLYox80CwDx+CE=
X-Received: by 2002:a05:6000:18ad:b0:3a4:ee3f:8e1e with SMTP id ffacd0b85a97d-3a572e8c038mr7550657f8f.39.1750083604802;
        Mon, 16 Jun 2025 07:20:04 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGYosUfYZVFXTDxpCSyfqn16IAAlEa9Q8vWVbziIfVjbez9nDFIFDVNp+8lB3mlMWXzagX2LQ==
X-Received: by 2002:a05:6000:18ad:b0:3a4:ee3f:8e1e with SMTP id ffacd0b85a97d-3a572e8c038mr7550597f8f.39.1750083604274;
        Mon, 16 Jun 2025 07:20:04 -0700 (PDT)
Received: from ?IPV6:2003:d8:2f25:bd00:949:b5a9:e02a:f265? (p200300d82f25bd000949b5a9e02af265.dip0.t-ipconnect.de. [2003:d8:2f25:bd00:949:b5a9:e02a:f265])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3a568a54d2asm11139179f8f.9.2025.06.16.07.20.01
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 16 Jun 2025 07:20:03 -0700 (PDT)
Message-ID: <a70e971e-046e-4766-ad52-483c533e4de6@redhat.com>
Date: Mon, 16 Jun 2025 16:20:01 +0200
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v12 04/18] KVM: x86: Rename kvm->arch.has_private_mem to
 kvm->arch.supports_gmem
To: Fuad Tabba <tabba@google.com>, Sean Christopherson <seanjc@google.com>
Cc: kvm@vger.kernel.org, linux-arm-msm@vger.kernel.org, linux-mm@kvack.org,
 kvmarm@lists.linux.dev, pbonzini@redhat.com, chenhuacai@kernel.org,
 mpe@ellerman.id.au, anup@brainfault.org, paul.walmsley@sifive.com,
 palmer@dabbelt.com, aou@eecs.berkeley.edu, viro@zeniv.linux.org.uk,
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
References: <20250611133330.1514028-1-tabba@google.com>
 <20250611133330.1514028-5-tabba@google.com> <aEyLlbyMmNEBCAVj@google.com>
 <CA+EHjTz=j==9evN7n1sGfTwxi5DKSr5k0yzXhDGzvwk7UawSGA@mail.gmail.com>
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
In-Reply-To: <CA+EHjTz=j==9evN7n1sGfTwxi5DKSr5k0yzXhDGzvwk7UawSGA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

>>> Rename it to supports_gmem to make its meaning clearer and to decouple memory
>>> being private from guest_memfd.
>>>
>>> Reviewed-by: Ira Weiny <ira.weiny@intel.com>
>>> Reviewed-by: Gavin Shan <gshan@redhat.com>
>>> Reviewed-by: Shivank Garg <shivankg@amd.com>
>>> Reviewed-by: Vlastimil Babka <vbabka@suse.cz>
>>> Co-developed-by: David Hildenbrand <david@redhat.com>
>>> Signed-off-by: David Hildenbrand <david@redhat.com>
>>> Signed-off-by: Fuad Tabba <tabba@google.com>
>>> ---
>>>   arch/x86/include/asm/kvm_host.h | 4 ++--
>>>   arch/x86/kvm/mmu/mmu.c          | 2 +-
>>>   arch/x86/kvm/svm/svm.c          | 4 ++--
>>>   arch/x86/kvm/x86.c              | 3 +--
>>>   4 files changed, 6 insertions(+), 7 deletions(-)
>>
>> This missed the usage in TDX (it's not a staleness problem, because this series
>> was based on 6.16-rc1, which has the relevant code).
>>
>> arch/x86/kvm/vmx/tdx.c: In function ‘tdx_vm_init’:
>> arch/x86/kvm/vmx/tdx.c:627:18: error: ‘struct kvm_arch’ has no member named ‘has_private_mem’
>>    627 |         kvm->arch.has_private_mem = true;
>>        |                  ^
>> make[5]: *** [scripts/Makefile.build:287: arch/x86/kvm/vmx/tdx.o] Error 1
> 
> I did test and run this before submitting the series. Building it on
> x86 with x86_64_defconfig and with allmodconfig pass (I obviously
> missed TDX though, apologies for that). I should have grepped for
> has_private_mem. That said, if I understood your suggestion correctly,
> this problem wouldn't happen again.

It's interesting that the build bots didn't catch that earlier.

-- 
Cheers,

David / dhildenb


