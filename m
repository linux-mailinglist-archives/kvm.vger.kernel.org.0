Return-Path: <kvm+bounces-44999-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 8D6EFAA577F
	for <lists+kvm@lfdr.de>; Wed, 30 Apr 2025 23:35:33 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id C72399E670E
	for <lists+kvm@lfdr.de>; Wed, 30 Apr 2025 21:35:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2B16A21D3DD;
	Wed, 30 Apr 2025 21:35:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="VVAQycOJ"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DE4961A38E1
	for <kvm@vger.kernel.org>; Wed, 30 Apr 2025 21:35:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746048912; cv=none; b=rD6cg59+Vjm99ztMtF9QVbbpJD7uKbXscJVEgMP28JQJxRo8up+6GUiJEChJm6/np07CuyCFkGjs1hyCzYOiD+p2iOd8lOXZeF5Mle5YzoBHHwkqDpFongnMX3OMSw0x+4Rj57kjAZm9G+1YX/yxKD5Cen/MKLwMNAG1PH77x+A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746048912; c=relaxed/simple;
	bh=yy0E+SoIiXnehp4eylEGNHHbJRxulBS4jxG/q0p5JJM=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Gxx1802pngVAVJMdty/aRfoXHcgY7qlKdsJ2wVmEplOYH619eIuWBbV/jU5Z0dQWHPTnXPI/Swk7gS+Lfm7tXc1ybPHnsrJIqbqzdgMWbaqpEI9jEILQcSMPpk+2DinB0rnnYsEatCMH7v1yiyFIN57nESAwivFtIkWl11FnWlU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=VVAQycOJ; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1746048908;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=ZEvd/2WbHpfpk4D+SrPk6a3wGOjXXdb1q/zENL2a9PM=;
	b=VVAQycOJhEzZwRli6nIdXS/oo3Qa9FNZFDmjDCQmheV8ySUYsNX+I7uXaefiTepOABqKI1
	r7DalwKhPfn1usp7miV7mMQhp9bq8qo3hgM/USGqPBj0Goh0iuuS3y5xuErdo6T+tycLEm
	LTwbWRTNSrljq/M+tJAMvyEHNBZkdj0=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-66-08CnPMknPbq0O8gXG12hPg-1; Wed, 30 Apr 2025 17:35:07 -0400
X-MC-Unique: 08CnPMknPbq0O8gXG12hPg-1
X-Mimecast-MFC-AGG-ID: 08CnPMknPbq0O8gXG12hPg_1746048906
Received: by mail-wm1-f71.google.com with SMTP id 5b1f17b1804b1-43cf172ffe1so1485955e9.3
        for <kvm@vger.kernel.org>; Wed, 30 Apr 2025 14:35:07 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1746048906; x=1746653706;
        h=content-transfer-encoding:in-reply-to:organization:autocrypt
         :content-language:from:references:cc:to:subject:user-agent
         :mime-version:date:message-id:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=ZEvd/2WbHpfpk4D+SrPk6a3wGOjXXdb1q/zENL2a9PM=;
        b=IBRI03y2UUdgnH5zh22IDtFmRBY5yC4jPXxn/gyjT5WgR4wnQTAebxYS/2C9ZiGums
         nsIe4s7cUUuGnhy/Sw81LsSRgAviD/489Vr9AUFt+wF65tJdl/or26lntxhSIrF/UWY0
         mix2WGwIOhkpLObB3xmVUF0A89OXpfgQc5Ww4i+Y49E9aR/qIs9IflZgEY503cQwbaa+
         euaC+NUGKJFYdNvCDsvWrvSdqs2W1Z5cP0S1yQHIRSd3ToKALkw+hR+zigctyfP/GNgp
         G5cti64St7WwwpOPLuTDxLl2sJoSfaqEOepuwCUo2Y8Od+w7Zs5iH/E1J+pnbYGHzpLT
         g8gA==
X-Forwarded-Encrypted: i=1; AJvYcCV99FPP1sqDyoptNOxPHIgZKN2Tqi+qjrIiKGjPRKE5smL2HLUq/LkmfQldmibi+RXc2Go=@vger.kernel.org
X-Gm-Message-State: AOJu0YxjK0j6NpQeifGeZ4RcFCoAJey6/0xAAQGDC1UZJDz9/EYIdLdz
	3Q0BbI21dwSKa2rKNvRRgPrkIwPLsNI3PU3yGsT3KPeQj2Ie1/TuvTDf0iHir2rHSkBs49mi2tl
	CYD+bM5PLkU9v5DL3urXm+z4X30xIlpNU00SOvlPt78Yb/HINCg==
X-Gm-Gg: ASbGncstfmcohnYuWLamOv7D1n9x/geTjJzDhQ5SRjDKbMsgpPnf65x0fgXRbk9F99m
	L2JOJUtLc/bLrCWLAVn3RW0JowFvJaJZq//tvyWFJtQUOyQJD6q19fb9yBKlBqMGrtJUihqy64B
	u9fjeCCjrpEXjAs9/aSgs94ueCxIa/yYDuAIvVy+Z9LRfLgaJ8C3D4UR3rY326wmKaugdNvtfsx
	wD0isezr7ygPz7bO1PWNBWasWGTDHOB9aaKmlkY4JlawZPxiCKpnfY4/C4gD6qYwk3nswXWhEz6
	mJjzQ37vl6pArewCL0DfH3gL7Qt2tr09gIL/pwvOfQ4bAFUy+5pO6HYfqr4vdF14XcPrABHMY3G
	NIt//wHNgCvHfHBtaJJWVj5G3vCzrxMrYibukI0g=
X-Received: by 2002:a5d:59a8:0:b0:391:3915:cffb with SMTP id ffacd0b85a97d-3a08ff465b4mr4159495f8f.43.1746048906023;
        Wed, 30 Apr 2025 14:35:06 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFDsnJ7UsOJ4zyi2oQX3stOqawfO+nPr01iLeKcMN7k8b72nohGXmMc+/D7Bfp0WGCM46RMBA==
X-Received: by 2002:a5d:59a8:0:b0:391:3915:cffb with SMTP id ffacd0b85a97d-3a08ff465b4mr4159469f8f.43.1746048905648;
        Wed, 30 Apr 2025 14:35:05 -0700 (PDT)
Received: from ?IPV6:2003:cb:c745:a500:7f54:d66b:cf40:8ee9? (p200300cbc745a5007f54d66bcf408ee9.dip0.t-ipconnect.de. [2003:cb:c745:a500:7f54:d66b:cf40:8ee9])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3a073cc4025sm18265545f8f.56.2025.04.30.14.35.02
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 30 Apr 2025 14:35:04 -0700 (PDT)
Message-ID: <e8cd5f4e-d803-4d8c-b7b1-648e25138dbf@redhat.com>
Date: Wed, 30 Apr 2025 23:35:01 +0200
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v8 09/13] KVM: arm64: Refactor user_mem_abort()
 calculation of force_pte
To: Fuad Tabba <tabba@google.com>, kvm@vger.kernel.org,
 linux-arm-msm@vger.kernel.org, linux-mm@kvack.org
Cc: pbonzini@redhat.com, chenhuacai@kernel.org, mpe@ellerman.id.au,
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
 jthoughton@google.com, peterx@redhat.com, pankaj.gupta@amd.com
References: <20250430165655.605595-1-tabba@google.com>
 <20250430165655.605595-10-tabba@google.com>
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
In-Reply-To: <20250430165655.605595-10-tabba@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 30.04.25 18:56, Fuad Tabba wrote:
> To simplify the code and to make the assumptions clearer,
> refactor user_mem_abort() by immediately setting force_pte to
> true if the conditions are met. Also, remove the comment about
> logging_active being guaranteed to never be true for VM_PFNMAP
> memslots, since it's not actually correct.
> 
> No functional change intended.
> 
> Signed-off-by: Fuad Tabba <tabba@google.com>
> ---

Reviewed-by: David Hildenbrand <david@redhat.com>

-- 
Cheers,

David / dhildenb


