Return-Path: <kvm+bounces-14351-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id AC43C8A212F
	for <lists+kvm@lfdr.de>; Thu, 11 Apr 2024 23:56:37 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id E2980B2229A
	for <lists+kvm@lfdr.de>; Thu, 11 Apr 2024 21:56:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 421853C464;
	Thu, 11 Apr 2024 21:56:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="DIdWAUPv"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D81303AC08
	for <kvm@vger.kernel.org>; Thu, 11 Apr 2024 21:56:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712872585; cv=none; b=f9VuI5AcG7MYauUeqD/riV39zo2W/fHqNOfvYfYKcTNGwITUIdIUO7myVXa4vy2XhWkrVnRhVD40cd8Me/LinMCIrI+Jd9pcxkNagULGH5onlUd2jbaeAwmv4A5UEr4P6i41cb+XzzOyHFBDotItryiAXpvXgWL2WR7F/+/B4hs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712872585; c=relaxed/simple;
	bh=YtUXUfwt59oxs0K0DSScCe6Vrtt6dJnBuXwvnWkDtQA=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=HBrWY65j5ULrF76aRMozqpG5vC7V499fisZMdqq/KxeR9lFHpAQRFBfxEmFy90aW83JZ+fnnEPYtBWSFSIrc+YhBUE868yGuxAcWH08hczIYvDpaXZoSiKRCamlB9I0kSXJIYq9CJHGhMtZPuYUmq87766F01kDJzhxerWUq7wM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=DIdWAUPv; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1712872582;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=17cEp70emcR4rsskSoF5355Y01DTz+evFBkVVlPWVYM=;
	b=DIdWAUPv/7kB91U2SgnzUah0Av5mxUtGGlgRvUJVEMvOhel1LBedwMDeeHDnz8VqWTqTmb
	v3HxLpT0M2upbsibKVahQhyDiHJwI7xSTxDqc3xavh9V+Xv0j3X9d+vh9AqERFqJpq1PIV
	B9cPGsu5UwTnDGHnE0buCk+Y6oaCaZY=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-275-pnZpIMm7OSKRUoPZZQY3dw-1; Thu, 11 Apr 2024 17:56:21 -0400
X-MC-Unique: pnZpIMm7OSKRUoPZZQY3dw-1
Received: by mail-wr1-f70.google.com with SMTP id ffacd0b85a97d-343d7cd8f46so152171f8f.2
        for <kvm@vger.kernel.org>; Thu, 11 Apr 2024 14:56:21 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1712872580; x=1713477380;
        h=content-transfer-encoding:in-reply-to:organization:autocrypt
         :content-language:from:references:cc:to:subject:user-agent
         :mime-version:date:message-id:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=17cEp70emcR4rsskSoF5355Y01DTz+evFBkVVlPWVYM=;
        b=H2Yg+KtgDVFV8FDJGd+RNQ3LPvhfApwlOnCwGNEjaoNGcOqu1/Fqg3g/DqxBnf2YLS
         7CSn9w1jXfab6+era4GfYRXSq/nl8ZEJy5eFOPahGfxXCyW7Caq3/Cel+/eTEUmHWFUR
         1rVD1M1XfwlgKDdpbKJoGYx+ODeXQ8/UZzp60DwOKpQqIPpw1Seu0gspabrpncVpZMnc
         SjRyzIMGbDpQoOGmNXDdEwiDCUZnFRFui1xG9j7UnYLNnLaNxY5Ts6fn89vw9cNtN2hx
         FTX/ZpgP6LgDY/h0WtwLTGvOshJn5Bj+8cqJ2C5BsTseviKqQ9Yyw4ns/AMTSbmPXvyv
         U0dg==
X-Forwarded-Encrypted: i=1; AJvYcCU5y0d5MbDhHrLv/FMcYxI0sQOngCA/m3Ng+EUcLaA/u45huVdz5HLPM3HC8cLYDaNVLrraABoBIDdg64d7GcdUBm0s
X-Gm-Message-State: AOJu0YzzVgMZvramrPWWwT9ENGvBNrxOKSUe6Rhh0jR7SuUYhN969H95
	zwgvptTFrZvkcWr21Y3wyaJKEZ5KvO95j3fH7QJmWmnvaA8fK+4qTbUXkfsPYxiZv1bVBS8kPns
	cc/VeerixFwPjYP4e/mCFXhTh6MxjYaCrguZUfXKbhXyhz4tvRw==
X-Received: by 2002:a05:6000:248:b0:343:ab0f:4dd6 with SMTP id m8-20020a056000024800b00343ab0f4dd6mr441083wrz.33.1712872580217;
        Thu, 11 Apr 2024 14:56:20 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IE34LlEuVwbvadgrGp2mi+0TS7wZVRw5F6QsbtcjKdjQpF1Cui9XQ830qfmq7WFeDeu85jrJA==
X-Received: by 2002:a05:6000:248:b0:343:ab0f:4dd6 with SMTP id m8-20020a056000024800b00343ab0f4dd6mr441078wrz.33.1712872579849;
        Thu, 11 Apr 2024 14:56:19 -0700 (PDT)
Received: from ?IPV6:2003:cb:c724:4300:430f:1c83:1abc:1d66? (p200300cbc7244300430f1c831abc1d66.dip0.t-ipconnect.de. [2003:cb:c724:4300:430f:1c83:1abc:1d66])
        by smtp.gmail.com with ESMTPSA id i4-20020a5d6304000000b003437ad152f9sm2703535wru.105.2024.04.11.14.56.18
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 11 Apr 2024 14:56:19 -0700 (PDT)
Message-ID: <3dbf706f-b6ca-45d7-a293-12aa5807fcdf@redhat.com>
Date: Thu, 11 Apr 2024 23:56:18 +0200
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 0/2] s390/mm: shared zeropage + KVM fixes
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
 Christian Borntraeger <borntraeger@linux.ibm.com>,
 Janosch Frank <frankja@linux.ibm.com>,
 Claudio Imbrenda <imbrenda@linux.ibm.com>, Heiko Carstens
 <hca@linux.ibm.com>, Vasily Gorbik <gor@linux.ibm.com>,
 Peter Xu <peterx@redhat.com>, Alexander Gordeev <agordeev@linux.ibm.com>,
 Sven Schnelle <svens@linux.ibm.com>,
 Gerald Schaefer <gerald.schaefer@linux.ibm.com>,
 Andrea Arcangeli <aarcange@redhat.com>, kvm@vger.kernel.org,
 linux-s390@vger.kernel.org
References: <20240411161441.910170-1-david@redhat.com>
 <20240411142827.d5c3bc401c6536bb1315049a@linux-foundation.org>
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
In-Reply-To: <20240411142827.d5c3bc401c6536bb1315049a@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 11.04.24 23:28, Andrew Morton wrote:
> On Thu, 11 Apr 2024 18:14:39 +0200 David Hildenbrand <david@redhat.com> wrote:
> 
>> This series fixes one issue with uffd + shared zeropages on s390x and
>> fixes that "ordinary" KVM guests can make use of shared zeropages again.
>>
>> ...
>>
>> Without the shared zeropage, during (2), the VM would suddenly consume
>> 100 GiB on the migration source and destination. On the migration source,
>> where we don't excpect memory overcommit, we could easilt end up crashing
>> the VM during migration.
>>
>> Independent of that, memory handed back to the hypervisor using "free page
>> reporting" would end up consuming actual memory after the migration on the
>> destination, not getting freed up until reused+freed again.
>>
> 
> Is a backport desirable?
> 
> If so, the [1/2] Fixes dates back to 2015 and the [2/2] Fixes is from
> 2017.  Is it appropriate that the patches be backported so far back,
> and into different kernel versions?
> 

[2/2] won't be easy to backport to kernels without FAULT_FLAG_UNSHARE, 
so I wouldn't really suggest backports to kernels before that. [1/2] 
might be reasonable to backport, but might require some tweaking (page 
vs. folio).

-- 
Cheers,

David / dhildenb


