Return-Path: <kvm+bounces-22926-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id A843294488A
	for <lists+kvm@lfdr.de>; Thu,  1 Aug 2024 11:34:57 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 5E0CA2858B2
	for <lists+kvm@lfdr.de>; Thu,  1 Aug 2024 09:34:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 86921183CA7;
	Thu,  1 Aug 2024 09:34:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Vek5F/6M"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C3B4016F909
	for <kvm@vger.kernel.org>; Thu,  1 Aug 2024 09:34:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722504856; cv=none; b=T2WqoMQtAqo2wuXAz1cN6P3DrBPXt61d+o6uskQmO3uDWC7QefJvMi6P7f3MxNui0c5h23KvS5i8RxI4M0QADUW5IRljuuQ/SHWN0Pkecx0c93zrvakOuVsw1w/deAGSIXfwOmUOxzzxf8JSn9Hnsulu7bm5GGnl/50nSB8qbKs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722504856; c=relaxed/simple;
	bh=OtlDzdM4oe21GfBWlTz0hmen8eQS7uEIYayF2mQiqdM=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=ERrNqQ5PLpqO+hCzaqbNRthOA7EPgg1spuiRTAfl9yB6PS0a0Fx32NNfX1SZ3EQZf0F6D9BQkJ8oXIT1K5SUuxOkr4iVMvLXYv2jsTsqzR2mBWXtihwzh3T7LzpeRWjJBwYOrelHW/c5Qr9lUXUKEvFk8u4Og/NHvy227qMqWJo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Vek5F/6M; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1722504852;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=4zaTn/YFgotAIGylW43Vgzq+0aYbo1DIlhcwsiRMBu0=;
	b=Vek5F/6MMQOoOvVqL16YmpJ9PbtHMVnzrmuNKPGFRp3F69mz+w8yy8OO++cI/B3S1mr9I/
	wmS+mNbtwBkxBhezYQFHBU3QOqPLuVJnr1DsbOPMtlqL6I8iDfmECVsONVKT4m6TFU3+xJ
	+ULBd5Q3+t3mEDlBOkho60Rp04Lbss8=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-655-nRJY2JeENaSMban8-8bEyQ-1; Thu, 01 Aug 2024 05:34:11 -0400
X-MC-Unique: nRJY2JeENaSMban8-8bEyQ-1
Received: by mail-wm1-f72.google.com with SMTP id 5b1f17b1804b1-426624f4ce3so39873925e9.1
        for <kvm@vger.kernel.org>; Thu, 01 Aug 2024 02:34:11 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1722504850; x=1723109650;
        h=content-transfer-encoding:in-reply-to:organization:autocrypt
         :content-language:from:references:cc:to:subject:user-agent
         :mime-version:date:message-id:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=4zaTn/YFgotAIGylW43Vgzq+0aYbo1DIlhcwsiRMBu0=;
        b=QcYNsZeIOCB2zY95eJLtI4r6F1vCIPIS6fMx+ZoC1OP4kl2F3tW2qtTIRzKAlCF0KV
         tp3tyvHImlZWpq/Mu25vTu7EIYInqLnqR/uVGA9f8S2Lkf5+kY1VVdr+vWcr17FuGm6g
         jd+oASjWH1dO/Fm9m6JzpfFbmZOGHH6Mf1xGqj0kcwcpfrVocIXwp2X5W+/78ztB01OU
         axdjDIMBGAQ3AtxtMYpmZpxHQmHWdbHFQxv1LIj7uC3VG4vTnFZ1rEhkdSPE715V9/BM
         N5SZMKyFyvRyvNSL/Eq2xKCSHSCGhLrnU86aBST+5E7HM1/unJA6D6A+3geM13oEZBZm
         f/vw==
X-Forwarded-Encrypted: i=1; AJvYcCUGprTe/IjjBzUuE0HSGhFlxp4T3Q32BGRP2NM6qMWWuqw93GMLOgGrPehD0Nv8KWiWuxAiqiYE/BioXEoMhtPZpp6m
X-Gm-Message-State: AOJu0YxxLJ47ZFbTYAZFLTnKeEzkPUBqWOaJ1BT2FwqdOPhMKj17CW9H
	q7xGy89rrU0PQwH8ZhdaqstQb4PkW779TYd6aYjbgFNGRpyUI1nM7RBgscO8lPYRwJzogKhDb/m
	8ST0ryhw3pE2Ic9tiPuNli8cFcYejE2nKRRYnhRFWo9hY9G8Kfw==
X-Received: by 2002:a05:600c:46d2:b0:427:abf6:f0e6 with SMTP id 5b1f17b1804b1-428a9bdba6dmr16727015e9.9.1722504850113;
        Thu, 01 Aug 2024 02:34:10 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGsdIi9cbdhCyGOUOk209ImdY8rj8k70L4gcpiRY4RmZ4B6fxJ3acejCtVHfR5vm+WNgcQG9g==
X-Received: by 2002:a05:600c:46d2:b0:427:abf6:f0e6 with SMTP id 5b1f17b1804b1-428a9bdba6dmr16726645e9.9.1722504849565;
        Thu, 01 Aug 2024 02:34:09 -0700 (PDT)
Received: from ?IPV6:2003:cb:c707:5c00:e650:bcd7:e2a0:54fe? (p200300cbc7075c00e650bcd7e2a054fe.dip0.t-ipconnect.de. [2003:cb:c707:5c00:e650:bcd7:e2a0:54fe])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4282dae2f73sm43560015e9.21.2024.08.01.02.34.07
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 01 Aug 2024 02:34:09 -0700 (PDT)
Message-ID: <6ddd626e-23c3-48aa-9753-ab8d73a5f798@redhat.com>
Date: Thu, 1 Aug 2024 11:34:07 +0200
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v6 04/11] mm: Add missing mmu_notifier_clear_young for
 !MMU_NOTIFIER
To: James Houghton <jthoughton@google.com>,
 Andrew Morton <akpm@linux-foundation.org>,
 Paolo Bonzini <pbonzini@redhat.com>
Cc: Ankit Agrawal <ankita@nvidia.com>,
 Axel Rasmussen <axelrasmussen@google.com>,
 Catalin Marinas <catalin.marinas@arm.com>,
 David Matlack <dmatlack@google.com>, David Rientjes <rientjes@google.com>,
 James Morse <james.morse@arm.com>, Jason Gunthorpe <jgg@ziepe.ca>,
 Jonathan Corbet <corbet@lwn.net>, Marc Zyngier <maz@kernel.org>,
 Oliver Upton <oliver.upton@linux.dev>,
 Raghavendra Rao Ananta <rananta@google.com>,
 Ryan Roberts <ryan.roberts@arm.com>, Sean Christopherson
 <seanjc@google.com>, Shaoqin Huang <shahuang@redhat.com>,
 Suzuki K Poulose <suzuki.poulose@arm.com>, Wei Xu <weixugc@google.com>,
 Will Deacon <will@kernel.org>, Yu Zhao <yuzhao@google.com>,
 Zenghui Yu <yuzenghui@huawei.com>, kvmarm@lists.linux.dev,
 kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
 linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org
References: <20240724011037.3671523-1-jthoughton@google.com>
 <20240724011037.3671523-5-jthoughton@google.com>
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
In-Reply-To: <20240724011037.3671523-5-jthoughton@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 24.07.24 03:10, James Houghton wrote:
> Remove the now unnecessary ifdef in mm/damon/vaddr.c as well.
> 
> Signed-off-by: James Houghton <jthoughton@google.com>
> ---
>   include/linux/mmu_notifier.h | 7 +++++++
>   mm/damon/vaddr.c             | 2 --
>   2 files changed, 7 insertions(+), 2 deletions(-)
> 
> diff --git a/include/linux/mmu_notifier.h b/include/linux/mmu_notifier.h
> index d39ebb10caeb..e2dd57ca368b 100644
> --- a/include/linux/mmu_notifier.h
> +++ b/include/linux/mmu_notifier.h
> @@ -606,6 +606,13 @@ static inline int mmu_notifier_clear_flush_young(struct mm_struct *mm,
>   	return 0;
>   }
>   
> +static inline int mmu_notifier_clear_young(struct mm_struct *mm,
> +					   unsigned long start,
> +					   unsigned long end)
> +{
> +	return 0;
> +}
> +
>   static inline int mmu_notifier_test_young(struct mm_struct *mm,
>   					  unsigned long address)
>   {
> diff --git a/mm/damon/vaddr.c b/mm/damon/vaddr.c
> index 381559e4a1fa..a453d77565e6 100644
> --- a/mm/damon/vaddr.c
> +++ b/mm/damon/vaddr.c
> @@ -351,11 +351,9 @@ static void damon_hugetlb_mkold(pte_t *pte, struct mm_struct *mm,
>   		set_huge_pte_at(mm, addr, pte, entry, psize);
>   	}
>   
> -#ifdef CONFIG_MMU_NOTIFIER
>   	if (mmu_notifier_clear_young(mm, addr,
>   				     addr + huge_page_size(hstate_vma(vma))))
>   		referenced = true;
> -#endif /* CONFIG_MMU_NOTIFIER */
>   
>   	if (referenced)
>   		folio_set_young(folio);

Acked-by: David Hildenbrand <david@redhat.com>

-- 
Cheers,

David / dhildenb


