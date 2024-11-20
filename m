Return-Path: <kvm+bounces-32171-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 8BE779D3ED2
	for <lists+kvm@lfdr.de>; Wed, 20 Nov 2024 16:17:40 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 2131E1F2496D
	for <lists+kvm@lfdr.de>; Wed, 20 Nov 2024 15:17:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A1BD91BD4EB;
	Wed, 20 Nov 2024 15:13:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="CFM8EaRL"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3303B1BC9F5
	for <kvm@vger.kernel.org>; Wed, 20 Nov 2024 15:13:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732115595; cv=none; b=XfpygC2H4hmujwSjCbN+6Ed1p++Vb1V64RaYtjRxzSipvI1F63ilgwxR5DeHSeyoLP/I1Pt0OcDcmfuKV/2uz10y82eagONmS7A3XsqxD+vMtFUQYWqDpPEykzEH6+cySrAtMEQcBWGRmVrCSfF6qT1ZeJMeLFNGo5mWYDq3gXY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732115595; c=relaxed/simple;
	bh=ClGZtqSPs3+uQI2TR7gW/1y2Ka1toa1bZuLQaorcyMo=;
	h=Message-ID:Date:MIME-Version:Subject:From:To:Cc:References:
	 In-Reply-To:Content-Type; b=houOmgcPgHHgexDiU4230RfXmVUN/U+LbuDw3RsPK4M/xgDO465eKLgZ30pqHvxMmF/Z79zhGRkiG1ASMkuEsCsvvvE+1qmUj8WolB20Y3rgJqXSv8YulEEjn0OBldQg1olgPusqAGMPyk1SQad0dai0EsASlmKfGqel+KQ2V2k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=CFM8EaRL; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1732115593;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=TPYrfftIwoQ8H8X6QHS3hAM6H0Gfg6swVNdqJN56f0o=;
	b=CFM8EaRL3Bc5d3eZbewDJxrSV1yaZxuNxDphkF9MLPLcJBAtnGX8aG8PQjTOs5F3wBLw6g
	ssnEIJDWj0nFHMoqXNd0ST7hKxDpPEhdga+YwbOBUP5TKQlszuFxGpYd2cymzDA8z79BLc
	GLzkc1uakK/G5PqzGMfuft3oXA2ByC4=
Received: from mail-lf1-f69.google.com (mail-lf1-f69.google.com
 [209.85.167.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-150-kbM4zAbRPSOlTpPF_tFhPw-1; Wed, 20 Nov 2024 10:13:11 -0500
X-MC-Unique: kbM4zAbRPSOlTpPF_tFhPw-1
X-Mimecast-MFC-AGG-ID: kbM4zAbRPSOlTpPF_tFhPw
Received: by mail-lf1-f69.google.com with SMTP id 2adb3069b0e04-53dac48127cso3161466e87.1
        for <kvm@vger.kernel.org>; Wed, 20 Nov 2024 07:13:11 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1732115590; x=1732720390;
        h=content-transfer-encoding:in-reply-to:organization:autocrypt
         :content-language:references:cc:to:from:subject:user-agent
         :mime-version:date:message-id:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=TPYrfftIwoQ8H8X6QHS3hAM6H0Gfg6swVNdqJN56f0o=;
        b=Skc8Ezkz+I2trH5QZw+6trVyKo/a/FzMj8MloQLY4AfUZ9sL3afmn+m0u3Xnf0Li3d
         AQE3FO5n0/el6ghNVwpOuU7JVB6/sRUStiovlZZTR/XKvWOoNN9/tGGnZ7Bz4ye/ISI7
         qy17CWaKGA/2/Bcpfr3cLOEsjxBMGvtyzBdTta4ZbRVV9y+IWy5aPYYnrGmvKkiky5Pc
         KNv3s62S6HZEI4CbA97JFbt7gC7CfEssm0PA9dtZsbhibkg4qasAd+HMZemUnDNEC/om
         bEK/cdsvv8/wm2+fTE62G5/pMrigPgVB/I13rMdPIClGq1Fq+S1ivKlE01An5kiBAbL3
         X1KA==
X-Forwarded-Encrypted: i=1; AJvYcCVGijTbEYsRPG025GE/hWVQ8a9r5JFHKEYZaiwALDGx4fg00tAao1BcQhkVRte3LeorXkc=@vger.kernel.org
X-Gm-Message-State: AOJu0Yx9f6eSwHXFHj98BJHEW/LZISTC31KSJFe/UgfCW5C64kDb1G6v
	bmNXnSsdtJzzKWZImjjK5xhwlDFrNhJI3Evl8ozOQZr4UKLRS+4jR6xI42cHDdCWPNk1BM2MLKj
	a9JJiEoYiJ5eebTD8gQjp41Fvx6SbToS0IveRsSCh1C1XzgnzRQ==
X-Received: by 2002:a05:6512:2244:b0:53d:a86e:4f19 with SMTP id 2adb3069b0e04-53dc13417bbmr1200539e87.25.1732115590326;
        Wed, 20 Nov 2024 07:13:10 -0800 (PST)
X-Google-Smtp-Source: AGHT+IFQi9U+IJ9Xa3Fu0yzIecUKArcOQFe0NIXm85HXGUxeF00Jm6d+8bZgnYEHGG6VlLsECJcxzg==
X-Received: by 2002:a05:6512:2244:b0:53d:a86e:4f19 with SMTP id 2adb3069b0e04-53dc13417bbmr1200516e87.25.1732115589936;
        Wed, 20 Nov 2024 07:13:09 -0800 (PST)
Received: from ?IPV6:2003:cb:c705:4200:ce79:acf6:d832:60df? (p200300cbc7054200ce79acf6d83260df.dip0.t-ipconnect.de. [2003:cb:c705:4200:ce79:acf6:d832:60df])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-43366cbee1csm21375755e9.1.2024.11.20.07.13.07
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 20 Nov 2024 07:13:09 -0800 (PST)
Message-ID: <efe6acf5-8e08-46cd-88e4-ad85d3af2688@redhat.com>
Date: Wed, 20 Nov 2024 16:13:07 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH 0/4] KVM: ioctl for populating guest_memfd
From: David Hildenbrand <david@redhat.com>
To: kalyazin@amazon.com, pbonzini@redhat.com, corbet@lwn.net,
 kvm@vger.kernel.org, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: jthoughton@google.com, brijesh.singh@amd.com, michael.roth@amd.com,
 graf@amazon.de, jgowans@amazon.com, roypat@amazon.co.uk, derekmn@amazon.com,
 nsaenz@amazon.es, xmarcalx@amazon.com,
 Sean Christopherson <seanjc@google.com>, linux-mm@kvack.org
References: <20241024095429.54052-1-kalyazin@amazon.com>
 <08aeaf6e-dc89-413a-86a6-b9772c9b2faf@amazon.com>
 <01b0a528-bec0-41d7-80f6-8afe213bd56b@redhat.com>
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
In-Reply-To: <01b0a528-bec0-41d7-80f6-8afe213bd56b@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

>>
>> The questions are:
>>     - Is this a well-known behaviour?
>>     - Is there a way to mitigate that, ie make shared memory (including
>> guest_memfd) population faster/comparable to private memory?
> 
> Likely. But your experiment measures above something different than what
> guest_memfd vs. anon does: guest_memfd doesn't update page tables, so I
> would assume guest_memfd will be faster than MAP_POPULATE.
> 
> How do you end up allocating memory for guest_memfd? Using simple
> fallocate()?

Heh, now I spot that your comment was as reply to a series.

If your ioctl is supposed to to more than "allocating memory" like 
MAP_POPULATE/MADV_POPULATE+* ... then POPULATE is a suboptimal choice. 
Because for allocating memory, we would want to use fallocate() instead. 
I assume you want to "allocate+copy"?

I'll note that, as we're moving into the direction of moving 
guest_memfd.c into mm/guestmem.c, we'll likely want to avoid "KVM_*" 
ioctls, and think about something generic.

Any clue how your new ioctl will interact with the WIP to have shared 
memory as part of guest_memfd? For example, could it be reasonable to 
"populate" the shared memory first (via VMA) and then convert that 
"allocated+filled" memory to private?

-- 
Cheers,

David / dhildenb


