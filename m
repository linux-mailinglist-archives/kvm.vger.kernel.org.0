Return-Path: <kvm+bounces-28861-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 0C59F99E188
	for <lists+kvm@lfdr.de>; Tue, 15 Oct 2024 10:49:10 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id B7902282BBB
	for <lists+kvm@lfdr.de>; Tue, 15 Oct 2024 08:49:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 725661D014E;
	Tue, 15 Oct 2024 08:48:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="N+o2hEaM"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B224E18BBA2
	for <kvm@vger.kernel.org>; Tue, 15 Oct 2024 08:48:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728982110; cv=none; b=dLfYdzdTbsu0Tlu/GatuULw3urpwGUp7wyP+6DOlHqjfkH4fi4lqBSWK7ZcXRqc2Og9CPbnzVp37a07Jsjj3GhSMtJYFIxdwCqUdGu2QLXK69zLfsfOAyasZ67EwnsBSTWGxE96IUMHBAQlD0fZEwmYlrGAXDwWcdYYQGaKdLrk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728982110; c=relaxed/simple;
	bh=p/MIGSRtGZoGVvz7Yr/8nDGL8TNsnqXsAbNUPPNhkrY=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=buXAXIiIIcUBoIDBeaI4lUlg0t9dSC9QWute3jZGLec4lXjB3cKqOG0mWwjs+NkTWgWFJmuXZQh9KXzZzvi2KKPfJyTnXOEfniIzj/970tOrb95bJHb0NefvJ37ZjYq3hQTu32XOeb6ABOctlMAsNRMFctrNG2+k52XBEPjjFhE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=N+o2hEaM; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1728982106;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=50wFFqNXFpjaX6P/Mlz7i8+V12CHV816FHHaZjiGzpk=;
	b=N+o2hEaM4PXW0RILAAPK7R14ztrwLEn42Zv88neNRO7kTBrI0GX0EFJVE2uyOwJSO1gb1w
	ba+inOfv9LWDhcHnXto4D91zwLLhsyeMg/JEWuYagKHG0FWj0AiavIW4bAPrZxiGFUveIz
	IWhvaN87xfyB7hsgVxODqsCypyGfy2Y=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-39-ZzOYbr9aOEahkasEXeXCaw-1; Tue, 15 Oct 2024 04:48:23 -0400
X-MC-Unique: ZzOYbr9aOEahkasEXeXCaw-1
Received: by mail-wm1-f71.google.com with SMTP id 5b1f17b1804b1-431159f2864so26708215e9.0
        for <kvm@vger.kernel.org>; Tue, 15 Oct 2024 01:48:23 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1728982102; x=1729586902;
        h=content-transfer-encoding:in-reply-to:organization:autocrypt
         :content-language:from:references:cc:to:subject:user-agent
         :mime-version:date:message-id:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=50wFFqNXFpjaX6P/Mlz7i8+V12CHV816FHHaZjiGzpk=;
        b=XbTPZjVRDokaqA9VsAV/q70TXNCp7mRtBf/ekusOiJ8RwzPsW5IsfP02tmbOtz3pgh
         b9p71RqCQi+O5Pa2zqTqkhyB1FkFDFQMqDDHT/CLjxOYgDhTp5l8uc3MQw8IjdhvNHC1
         S9GE0gmUng1SJnM5qatFGck/ZYFglSlsgD7Z2GyJe81/7xyuJq7VfKLK3/ltQSR9pvkM
         jpzCmUDoOMrc1LAkoYBE2FcA3Y95PPI27QvStcTtW4HrWlvOde01VqMrbimEHBbeu6+r
         Dh/F70JBPWNxLqKZYEFfejicSH8DBL6XiCvvCxYmLkKFdogq91VrZWZuMavW3Bpn3z9G
         e4mg==
X-Forwarded-Encrypted: i=1; AJvYcCUQAYJJUhMWV7gx9AZ0NfXsL93maf77+lbFAP6+UMygh2OsjYZGCbzPV6aIhEUIcItGzuU=@vger.kernel.org
X-Gm-Message-State: AOJu0YxCyQD0dYxKxisNPXMv/pQpEyZgXdYQFEk28l47iQmsQoaQMXTD
	lVpmksqEV0W99YQlO0Nl2b4IgaUhqkWPtJC+T9+TSmN5AT8BNWjSApTjj58BqT/eG6GUN+6T4E2
	6rBEZkHz0XoSWTC9XWI1V3enf40GDi1F3O221d5Lh0Z7qVXPZbQ==
X-Received: by 2002:a05:600c:c0d:b0:42f:7e87:3438 with SMTP id 5b1f17b1804b1-4311de0041fmr117015445e9.0.1728982102433;
        Tue, 15 Oct 2024 01:48:22 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHBTHE1MOfpAobdlWqdrQtQCCiBsBcqnh8ka2vWhYs6jn4f2rukhBZXH4tRhj08nCUPlOwNyw==
X-Received: by 2002:a05:600c:c0d:b0:42f:7e87:3438 with SMTP id 5b1f17b1804b1-4311de0041fmr117015145e9.0.1728982102032;
        Tue, 15 Oct 2024 01:48:22 -0700 (PDT)
Received: from ?IPV6:2003:cb:c730:9700:d653:fb19:75e5:ab5c? (p200300cbc7309700d653fb1975e5ab5c.dip0.t-ipconnect.de. [2003:cb:c730:9700:d653:fb19:75e5:ab5c])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4313f6b323asm10945305e9.36.2024.10.15.01.48.20
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 15 Oct 2024 01:48:21 -0700 (PDT)
Message-ID: <2050b790-4d88-4e16-8af8-3bde759d5430@redhat.com>
Date: Tue, 15 Oct 2024 10:48:20 +0200
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 2/7] Documentation: s390-diag.rst: make diag500 a
 generic KVM hypercall
To: Heiko Carstens <hca@linux.ibm.com>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
 linux-s390@vger.kernel.org, virtualization@lists.linux.dev,
 linux-doc@vger.kernel.org, kvm@vger.kernel.org,
 Vasily Gorbik <gor@linux.ibm.com>, Alexander Gordeev
 <agordeev@linux.ibm.com>, Christian Borntraeger <borntraeger@linux.ibm.com>,
 Sven Schnelle <svens@linux.ibm.com>, Thomas Huth <thuth@redhat.com>,
 Cornelia Huck <cohuck@redhat.com>, Janosch Frank <frankja@linux.ibm.com>,
 Claudio Imbrenda <imbrenda@linux.ibm.com>,
 "Michael S. Tsirkin" <mst@redhat.com>, Jason Wang <jasowang@redhat.com>,
 Xuan Zhuo <xuanzhuo@linux.alibaba.com>, =?UTF-8?Q?Eugenio_P=C3=A9rez?=
 <eperezma@redhat.com>, Andrew Morton <akpm@linux-foundation.org>,
 Jonathan Corbet <corbet@lwn.net>
References: <20241014144622.876731-1-david@redhat.com>
 <20241014144622.876731-3-david@redhat.com>
 <20241014180410.10447-C-hca@linux.ibm.com>
 <78e8794a-d89f-4ded-b102-afc7cea20d1d@redhat.com>
 <20241015081212.7641-A-hca@linux.ibm.com>
 <8e39522c-2853-4d1f-b5ec-64fabcca968b@redhat.com>
 <20241015082148.7641-B-hca@linux.ibm.com>
 <d90566ac-dbe3-486b-bdc7-ece6c2ec6928@redhat.com>
 <20241015084634.7641-E-hca@linux.ibm.com>
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
In-Reply-To: <20241015084634.7641-E-hca@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 15.10.24 10:46, Heiko Carstens wrote:
> On Tue, Oct 15, 2024 at 10:32:43AM +0200, David Hildenbrand wrote:
>> On 15.10.24 10:21, Heiko Carstens wrote:
>>> On Tue, Oct 15, 2024 at 10:16:20AM +0200, David Hildenbrand wrote:
>>>> On 15.10.24 10:12, Heiko Carstens wrote:
>>>>> On Mon, Oct 14, 2024 at 09:35:27PM +0200, David Hildenbrand wrote:
>>>>>> On 14.10.24 20:04, Heiko Carstens wrote:
>>>>> "If only there would be a query subcode available, so that the program
>>>>> check handling would not be necessary; but in particular my new subcode
>>>>> is not worth adding it" :)
>>>>>
>>>>> Anyway, I do not care too much.
>>>>>
>>>>
>>>> Okay, I see your point: it would allow for removing the program check
>>>> handling from the STORAGE LIMIT invocation.
>>>>
>>>> ... if only we wouldn't need the exact same program check handling for the
>>>> new query subfunction :P
>>>
>>> Yeah yeah, but I think you got that this might help in the future.
>>
>> Right. Adding it later also doesn't quite help to get rid of the checks
>> here, because some user space might implement STORAGE LIMIT without QUERY.
> 
> This would only help if the diag500 documentation would state that
> implementation of the QUERY subcode is mandatory. That is: for every
> new subcode larger than the QUERY subcode QUERY must also exist.
> 
> That way we only would have to implement program check handling once,
> if a program check happens on QUERY none of the newer subcodes is
> available, otherwise the return value would indicate that.
> 
> Otherwise this whole excercise would be pointless.

Yes, that would be the idea.

-- 
Cheers,

David / dhildenb


