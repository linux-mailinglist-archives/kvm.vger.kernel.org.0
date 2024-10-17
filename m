Return-Path: <kvm+bounces-29082-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 90C359A2537
	for <lists+kvm@lfdr.de>; Thu, 17 Oct 2024 16:37:17 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 159611F22E1A
	for <lists+kvm@lfdr.de>; Thu, 17 Oct 2024 14:37:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EAB9A1DE898;
	Thu, 17 Oct 2024 14:36:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="YYO0ZkzM"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8315D1DE3BB
	for <kvm@vger.kernel.org>; Thu, 17 Oct 2024 14:36:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729175819; cv=none; b=IBs9ObKCsdFXJItrMk1U6gfzpjuRM/kCy/flgpFNDWVk0BxPaPqiz6bhR6iRZAvm3QgwT9a9ss49U5vM5UuZ1xrhq4nADIpkrbx/cqtRBTIsjqDELfXniY7JCynAoXmNa8B+6z6BiFGxOqpmSjsYFSi4oX4pZEDzSiFPanV0bWQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729175819; c=relaxed/simple;
	bh=QXtnX+sdvYBkyWY1Bntt5HQGfkMEAVqFb1Kg5Izp/Oo=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=igTOXBWeKdmWsHsI/ge5ePt93cUc48R27q8wBBx09yElrmPHI+KXvHISZ4Ev7Tf7cZPbSAFDE/IpqJEbF6HoXFhhoSd1rY4DcE9GUd99oqI+W49zbSsqaeL0gx7nOH4ROV40ATcukQMsJPyzJxe3H64pD1G/JN00DKg0+sZ3Gho=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=YYO0ZkzM; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1729175816;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=UzfXLoTrDUyX1VJYFE3FTnLV0X70G74YSwU8euehzao=;
	b=YYO0ZkzMlbGZhSuJ1Ojp1KELzju8ZA7i+NcCsjf/YxHiSvYQH6vh1WqvfcCaXoqYsl6sOz
	zAOKKlOLCC3sZiVlJqigXqh58Rvpk8cG+K1tTZxJWLxvbAhxvX06szDZGbyXgzDdQi9Ste
	Bm7pH7bFHk2UAMwqhhOlM4ZWDvx/IrE=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-650-dovTHVfjP5Gqwp3_O074PA-1; Thu, 17 Oct 2024 10:36:55 -0400
X-MC-Unique: dovTHVfjP5Gqwp3_O074PA-1
Received: by mail-wm1-f69.google.com with SMTP id 5b1f17b1804b1-42ac185e26cso8216755e9.3
        for <kvm@vger.kernel.org>; Thu, 17 Oct 2024 07:36:55 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1729175814; x=1729780614;
        h=content-transfer-encoding:in-reply-to:organization:autocrypt
         :content-language:from:references:cc:to:subject:user-agent
         :mime-version:date:message-id:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=UzfXLoTrDUyX1VJYFE3FTnLV0X70G74YSwU8euehzao=;
        b=WIInDAmvvm0XXAxR0vdrs6ABY1OzXt9ALKt1FBQZCTommitrRlaODUiLSgjsUb1iFw
         TUT9Xu96PvIcsJqpDgtcbdxERuV1KBenQ1kZzf1+YPuJWWLE//QLnyuD0ImK5xOL230G
         8+cbBHMoQLuscE2DyHiO8/VozqLlqUXzdvS99Emb7FouNr3M9wfX+/4/OjcYMPbloc+H
         HnImhPnZQz7EjjPBak1u8Nu+PxRjbqraQF2k3enNORp6ZnGV4LLR5nE1mJvhasvnH/9h
         U9PUXKwPnxOdv5PiUXhTrSyz4S7QojsXEIMBhRhHsIuEZiBSugWAp7JVDdKDpKxJmTia
         yIaw==
X-Forwarded-Encrypted: i=1; AJvYcCUQWottgNKPWtXaxQeUxkVirp9jqh7d8uahhdGek5y9WnJomLEiP2lvv7kKi3pu2M3viLk=@vger.kernel.org
X-Gm-Message-State: AOJu0YzBJNAesHuU6jHwys8er8M3MP+pp8H5jqqr6DTMTNC1A4o1aYSA
	ijfOmYh01OlvkNQfKSuRouHJEV5t1HpfnecUe9aOMSqs3EEJdOsySOv9HoUMFnoJc/GAJBVjfyF
	p30tKvDMxvR5VNiHHNTfhaKZ2TFEcPl2Grj2ATORep+6NxoEWlw==
X-Received: by 2002:a05:600c:3b99:b0:426:647b:1bfc with SMTP id 5b1f17b1804b1-4314a3abe93mr69661425e9.30.1729175814115;
        Thu, 17 Oct 2024 07:36:54 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFHpU9cpWS3yeJ12WQ1qdRFSatXmwxIJA5brFMmY8AiQ4Fgny5eENTh1y2xj5WODUe0A3g91w==
X-Received: by 2002:a05:600c:3b99:b0:426:647b:1bfc with SMTP id 5b1f17b1804b1-4314a3abe93mr69661145e9.30.1729175813692;
        Thu, 17 Oct 2024 07:36:53 -0700 (PDT)
Received: from ?IPV6:2003:cb:c705:7600:62cc:24c1:9dbe:a2f5? (p200300cbc705760062cc24c19dbea2f5.dip0.t-ipconnect.de. [2003:cb:c705:7600:62cc:24c1:9dbe:a2f5])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4314f1c3197sm42435665e9.0.2024.10.17.07.36.52
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 17 Oct 2024 07:36:53 -0700 (PDT)
Message-ID: <0224bd06-3a77-474e-917d-814d2082186e@redhat.com>
Date: Thu, 17 Oct 2024 16:36:51 +0200
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 4/7] s390/physmem_info: query diag500(STORAGE LIMIT) to
 support QEMU/KVM memory devices
To: Alexander Gordeev <agordeev@linux.ibm.com>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
 linux-s390@vger.kernel.org, virtualization@lists.linux.dev,
 linux-doc@vger.kernel.org, kvm@vger.kernel.org,
 Heiko Carstens <hca@linux.ibm.com>, Vasily Gorbik <gor@linux.ibm.com>,
 Christian Borntraeger <borntraeger@linux.ibm.com>,
 Sven Schnelle <svens@linux.ibm.com>, Thomas Huth <thuth@redhat.com>,
 Cornelia Huck <cohuck@redhat.com>, Janosch Frank <frankja@linux.ibm.com>,
 Claudio Imbrenda <imbrenda@linux.ibm.com>,
 "Michael S. Tsirkin" <mst@redhat.com>, Jason Wang <jasowang@redhat.com>,
 Xuan Zhuo <xuanzhuo@linux.alibaba.com>, =?UTF-8?Q?Eugenio_P=C3=A9rez?=
 <eperezma@redhat.com>, Andrew Morton <akpm@linux-foundation.org>,
 Jonathan Corbet <corbet@lwn.net>, Mario Casquero <mcasquer@redhat.com>
References: <20241014144622.876731-1-david@redhat.com>
 <20241014144622.876731-5-david@redhat.com>
 <ZxC+mr5PcGv4fBcY@li-008a6a4c-3549-11b2-a85c-c5cc2836eea2.ibm.com>
 <04d5169f-3289-4aac-abca-90b20ad4e9c9@redhat.com>
 <ZxDetq73hETPMjln@li-008a6a4c-3549-11b2-a85c-c5cc2836eea2.ibm.com>
 <1c7ef09e-9ba2-488e-a249-4db3f65e077d@redhat.com>
 <45de474c-9af3-4d71-959f-6dbc223b432b@redhat.com>
 <ZxEf6NOs1hDFZd1E@tuxmaker.boeblingen.de.ibm.com>
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
In-Reply-To: <ZxEf6NOs1hDFZd1E@tuxmaker.boeblingen.de.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 17.10.24 16:32, Alexander Gordeev wrote:
> On Thu, Oct 17, 2024 at 02:07:12PM +0200, David Hildenbrand wrote:
>> On 17.10.24 12:00, David Hildenbrand wrote:
>>> Well, DIAGNOSE 260 is z/VM only and DIAG 500 is KVM only. So there are
>>> currently not really any other reasonable ways besides SCLP.
>>
>> Correction: Staring at the code again, in detect_physmem_online_ranges()
>> we will indeed try:
>>
>> a) sclp_early_read_storage_info()
>> b) diag260()
> 
> So why care to call diag260() in case of DIAGNOSE 500? What about the below?
> 
> void detect_physmem_online_ranges(unsigned long max_physmem_end)
> {
> 	if (!sclp_early_read_storage_info()) {
> 		physmem_info.info_source = MEM_DETECT_SCLP_STOR_INFO;
> 	} else if (physmem_info.info_source == MEM_DETECT_DIAG500_STOR_LIMIT) {
> 		unsigned long online_end;
> 
> 		if (!sclp_early_get_memsize(&online_end)) {
> 			physmem_info.info_source = MEM_DETECT_SCLP_READ_INFO;
> 			add_physmem_online_range(0, online_end);
> 		}
> 	} else if (!diag260()) {
> 		physmem_info.info_source = MEM_DETECT_DIAG260;
> 	} else if (max_physmem_end) {
> 		add_physmem_online_range(0, max_physmem_end);
> 	}
> }

Works for me, thanks!

-- 
Cheers,

David / dhildenb


