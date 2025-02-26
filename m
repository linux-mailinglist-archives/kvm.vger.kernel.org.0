Return-Path: <kvm+bounces-39304-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id F41FFA4673D
	for <lists+kvm@lfdr.de>; Wed, 26 Feb 2025 18:01:42 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 54FE13AC140
	for <lists+kvm@lfdr.de>; Wed, 26 Feb 2025 17:01:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E0E0D224AFA;
	Wed, 26 Feb 2025 17:01:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="bZsrg/Iv"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3808B223333
	for <kvm@vger.kernel.org>; Wed, 26 Feb 2025 17:01:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740589273; cv=none; b=T8NF3SGtRsqFjCJQiksINctLMXiNw+g9wXkFCYvZdMZdQ2EHlQGOcz5G9tUKTbbwuVwKnXiZmc0vD7s6ceiHXL7ZTzBiFvhjmZxcStVhDeJ6e1AW8+ZIOXQfj2Oe2c7/OyLDjts25fod34TgT6/dT/PjSHOtxYnEvBtFCOu2NYs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740589273; c=relaxed/simple;
	bh=ymp2sTDtOywRud1r42LEpIz5/xVLZbwnL8m4bwvq204=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=pZ73DiCxx+ztS2CFdB26GNgRl4MoqMN3vOHU5jQWhqov1+CKUnDIq/Zzf271tEvoYkIGODDSYLSfS4Vf5ExGE9MQYsO1BAxDqRwr9lMLYZRtOlTdqbKh9EuPsJyt6J3rcvFsmdAHaIDn3oBhcy+Ks3XK/9HFzdzv5DxHDrzgjUs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=bZsrg/Iv; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1740589269;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=OAYKjSFBIO1FDoSMDm73LcP7EYOw8j6BdDDF1ZgHN6I=;
	b=bZsrg/IvPjCGNioToKYjO34LPDpkzTP26EG5Zz188CqGW6F1DPlDXGWqBELO6IMUAs4Pck
	6sOg7q58pl6zTGdkW+7lVcbnx6wr63JtssRiJSQBAFq9vtxhbNGYWlq7SiMScuGx9gPwph
	tv2v3vNF22WKbaSA9o2vmWIyT5j3JVs=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-32-ZfMdQWt6P0yktaHSE15K_Q-1; Wed, 26 Feb 2025 12:01:08 -0500
X-MC-Unique: ZfMdQWt6P0yktaHSE15K_Q-1
X-Mimecast-MFC-AGG-ID: ZfMdQWt6P0yktaHSE15K_Q_1740589267
Received: by mail-wm1-f72.google.com with SMTP id 5b1f17b1804b1-4393e89e910so275155e9.0
        for <kvm@vger.kernel.org>; Wed, 26 Feb 2025 09:01:08 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1740589267; x=1741194067;
        h=content-transfer-encoding:in-reply-to:organization:autocrypt
         :content-language:from:references:cc:to:subject:user-agent
         :mime-version:date:message-id:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=OAYKjSFBIO1FDoSMDm73LcP7EYOw8j6BdDDF1ZgHN6I=;
        b=Lxza8OuiwEXSoktAj/tMiGHjBsLZkzEH8vn5k8uIT7gwmpgeUVJx4hGv88B910728h
         QWzgF2HsLCeiGH0VJ/hDOIQ+ggooyDD3XiS8bVD4wwoVWL+DLSo+bm6xb1+FUJcgJedE
         71/TyT4iD9cJg5BFCWwrf7z5C+NF03BVOebHdMfZSp10+ZhhA1sIPRv2Aaak9vFaY3jg
         ZA3va+0+lTYH46QpLiBZ2XzobR45eoRlhuj8ZQKUFnPk3+sa90CR65pGLZL4QuP2TSHF
         sfWKvS/Vp4JGcxPfQIWRqLjrGayL+13bZiiRPLZ9yduYuU9K9DbmD0H/dmaS9uVS99Fd
         tM+g==
X-Gm-Message-State: AOJu0YzV4PdqUK38/ezpUrnoGnljviM0oiuSDjlAgm/09aMdh0Lcxi9M
	O1YkCX0TjYPzYtJyMTWUDif9ZncPStkM5vt9pP/OKMS2r7ppClSgZRjjZKVOw5wnnGFy87EeqZo
	cYbdjiJHW/fxfhGr5oR2mafKQuVzTb4TskfYPPFy9L1txoiomXcPp2FOawwDQ
X-Gm-Gg: ASbGncvu4D6/DkZEe7A/GuR+iWPwZbDKwtpQ3zImPzw9GCoZCO+kaf6yd/T1jsnw6LP
	kZj8NTF1BtWqVbpyUFLCnDAjrZ4YCBaITHlBBopcWsEfR5T+if9GeTeYeju43vi3xJGSqOmbsFy
	HHncWiwU7IZGiIJd1oRAbQ0WuhYti37EsHh4jem3PPVjveYQtU2OsjACC7lsL4tYErKEFfHtJ9g
	ZXT88WtIpno3AgNnLlEugQMe4NME+am9NPXy0ZvG2vSvPJd2EPMaOiNYan0gqKqIjHsksCdjAzL
	N5t0rJbDw9a5i04+1QacxZJFhlL+FlN/3OhCMFnl9c/jtmDv2keSGwQnWfkN/uj25H//xMegNUi
	+T1F/IXX5JjUoR+26Y86JpoKjoqcsjpSlQ3+pZ3gRUCc=
X-Received: by 2002:a05:600c:35cb:b0:439:942c:c1cd with SMTP id 5b1f17b1804b1-43ab0f41698mr76827475e9.15.1740589266819;
        Wed, 26 Feb 2025 09:01:06 -0800 (PST)
X-Google-Smtp-Source: AGHT+IFiO2q8A3dUQEgmlrjeCPMR8emhxvzHqcb9TXxKF1sqeUAwSJJ5Q0qd3IdPW2c/7LYLlKc+nQ==
X-Received: by 2002:a05:600c:35cb:b0:439:942c:c1cd with SMTP id 5b1f17b1804b1-43ab0f41698mr76826655e9.15.1740589266235;
        Wed, 26 Feb 2025 09:01:06 -0800 (PST)
Received: from ?IPV6:2003:cb:c747:ff00:9d85:4afb:a7df:6c45? (p200300cbc747ff009d854afba7df6c45.dip0.t-ipconnect.de. [2003:cb:c747:ff00:9d85:4afb:a7df:6c45])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-43aba549da9sm27914395e9.38.2025.02.26.09.01.05
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 26 Feb 2025 09:01:05 -0800 (PST)
Message-ID: <bab79dbd-64cc-4a58-aba9-bc5fd4d6beca@redhat.com>
Date: Wed, 26 Feb 2025 18:01:04 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 1/1] KVM: s390: pv: fix race when making a page secure
To: Claudio Imbrenda <imbrenda@linux.ibm.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-s390@vger.kernel.org, frankja@linux.ibm.com, borntraeger@de.ibm.com,
 nrb@linux.ibm.com, seiden@linux.ibm.com, nsg@linux.ibm.com,
 schlameuss@linux.ibm.com, hca@linux.ibm.com
References: <20250226123725.247578-1-imbrenda@linux.ibm.com>
 <20250226123725.247578-2-imbrenda@linux.ibm.com>
 <0dfeabca-5c41-4555-a43b-341a54096036@redhat.com>
 <20250226175833.16a7a970@p-imbrenda>
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
In-Reply-To: <20250226175833.16a7a970@p-imbrenda>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 26.02.25 17:58, Claudio Imbrenda wrote:
> On Wed, 26 Feb 2025 16:05:11 +0100
> David Hildenbrand <david@redhat.com> wrote:
> 
>>> +int make_hva_secure(struct mm_struct *mm, unsigned long hva, struct uv_cb_header *uvcb)
>>> +{
>>> +	struct folio *folio;
>>> +	spinlock_t *ptelock;
>>> +	pte_t *ptep;
>>> +	int rc;
>>> +
>>> +	ptep = get_locked_valid_pte(mm, hva, &ptelock);
>>> +	if (!ptep)
>>> +		return -ENXIO;
>>
>> You very likely need a pte_write() check we had there before, as you
>> might effectively modify page content by clearing the page.
> 
> it's not really needed, but it doesn't hurt either, I'll add a check

Can you elaborate why it is not needed? Would the HW enforce that 
writability check already?

-- 
Cheers,

David / dhildenb


