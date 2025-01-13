Return-Path: <kvm+bounces-35288-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 2515BA0B6A9
	for <lists+kvm@lfdr.de>; Mon, 13 Jan 2025 13:20:56 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 53F8A188287D
	for <lists+kvm@lfdr.de>; Mon, 13 Jan 2025 12:20:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B6B8A22F15B;
	Mon, 13 Jan 2025 12:20:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="LWT+zAiM"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 341E222AE41
	for <kvm@vger.kernel.org>; Mon, 13 Jan 2025 12:20:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736770830; cv=none; b=jhbKmgpEyOn8CvrQ/ahXRsa0LbViUVbWC22j0a3vmg7D1ATp/ujVv/UF7wbruEiKlzXHbFotZ0VA5mlPtCe73nEjuuMkGI5OnwFGG83Ae5RwOXpA1BQS7/8VVpZ/2kePdu7RDsOF3P0aYG2b/vtDi+GxEEqo95IpDhFEyRObwWw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736770830; c=relaxed/simple;
	bh=2wXBdPJx10Ho6Cyh27aRqP8SmnR3x0NtDC56WuarXmI=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=e1FM4ETkkxfGD3A4RdDUsYUcTH6KI3VHQxYylkx3d4/YgLj510iGEC8BTS5qTWOSYGrqBQ6vnVwFehJIcYOstO0T+llGFQ6Icg2TZkuhYY0oyTPs9f/msqkkl9wPV97/MxBFLiNaxhhUcf88uuFLlBtL2GKsz7npNeknYS05Vpc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=LWT+zAiM; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1736770828;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=WPJqxM66D8ozqOoghVHqVRiFeMIiJzZpCDbe9WUxI2Q=;
	b=LWT+zAiMuPpkDBM1S73IF9CEO+/nGcii43+6QhnS6x0XhUnHwJn+HptyTCLAQLCw6kMtll
	e/cZJ9+QpjsksNAPfET/Afw36obOBjVJ6cXKEcF7PHvQzptB+L44g8Kyzy/9oLsXdS6KfI
	VBdh3HOKLX7kobm03jKOGDEfl9A0jSc=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-529-xrDTqpGdNpyde7lGEjBomw-1; Mon, 13 Jan 2025 07:20:26 -0500
X-MC-Unique: xrDTqpGdNpyde7lGEjBomw-1
X-Mimecast-MFC-AGG-ID: xrDTqpGdNpyde7lGEjBomw
Received: by mail-wm1-f72.google.com with SMTP id 5b1f17b1804b1-4362f893bfaso23647935e9.1
        for <kvm@vger.kernel.org>; Mon, 13 Jan 2025 04:20:26 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1736770825; x=1737375625;
        h=content-transfer-encoding:in-reply-to:organization:autocrypt
         :content-language:from:references:cc:to:subject:user-agent
         :mime-version:date:message-id:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=WPJqxM66D8ozqOoghVHqVRiFeMIiJzZpCDbe9WUxI2Q=;
        b=k8kgxDhkpjfhKjNntixF1Vsg0xB7MGuWNC2sd9CIFnh9lXqu9fk2SpLir8MyjxDTpv
         qJrQx0JeHsQBMa7EDPNZix8IWS6Vu/QpBFGE0snjgs9WkSXCbR1ERQyn21RPrHETFMDg
         4F/OydnDrWMIatrjD0XNAOQG+bXJMI/NT/TE7cL2XgzzadfrQH8izZwg3JgSALLFzDLR
         HXkyHbD//6/uCUkkCjG70gpFMHxmrIPG3teFiwhEQStJRDF+xJ1554PFirH6ERKzR524
         9jD9UUFXXiBOg4SmWbo1p0G0VAXImZyGpn6iTqk76lr9IrIWKZqmmf0VZRsmlL2cLmE7
         cX9w==
X-Forwarded-Encrypted: i=1; AJvYcCUhpAedu84qrTQeIUMtnOjhdLYTeD+CqLNxemg6e+Fo21AlCQgSSK3zx6P6+ffOOgrkK+s=@vger.kernel.org
X-Gm-Message-State: AOJu0YyD22q4DwDqVGZrboOhCjbHj6rhvCD4xI1wgQ1YBGpN0HHz2sFs
	/DprYrswMyJ+TcXJzZeRY/+4jeTf1Rn0D29DftTCxULYKlomirt5REyA3qzWOqskt5kBRHeI3yM
	X7qoTWdGdipI8PgoD+Tfh/bFuiw6E+2y4fPO/YAy5Se4kqXeg1g==
X-Gm-Gg: ASbGncs796Tp4bfJ7Mal9a2oRGmv522IZ/uZVTRMbNEpmup8Ptep/WTbWUvJ4AL3DiG
	zslUCDlYCyM6L6/itavUnwQpOgI9Rq9vgxgtbKCLioYD1zt1FAGOMP+aW8b3cLV2z3XlDh5FLxU
	6Ocay4BEsiHp27bjSkx4MoBPbAzdkP4TUo7JO9N5iQrgdZVPesijuoceqjcnPJIfBwv2twh3W3X
	jnd+yN4X5gc8s35jIijt0jPCOiRnmQA204xBregveCqT/ajdSCx40Zamw2IuM/ah5BJ7fTS3EOK
	NT2oZrLFIEKcGn8=
X-Received: by 2002:a05:600c:25a:b0:431:547e:81d0 with SMTP id 5b1f17b1804b1-436ee0a061emr144523885e9.11.1736770825436;
        Mon, 13 Jan 2025 04:20:25 -0800 (PST)
X-Google-Smtp-Source: AGHT+IEa8AOSFBcB7FA9MLPiL0HZeyAHnNbYGvFjiSbreWPTjxxj4GEepp0hOQTpXBOihjlHDLdbZQ==
X-Received: by 2002:a05:600c:25a:b0:431:547e:81d0 with SMTP id 5b1f17b1804b1-436ee0a061emr144523465e9.11.1736770824989;
        Mon, 13 Jan 2025 04:20:24 -0800 (PST)
Received: from ?IPV6:2a09:80c0:192:0:5dac:bf3d:c41:c3e7? ([2a09:80c0:192:0:5dac:bf3d:c41:c3e7])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-436dcc8f8dfsm146389445e9.0.2025.01.13.04.20.23
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 13 Jan 2025 04:20:24 -0800 (PST)
Message-ID: <5c62bdbb-7a4e-4178-8c03-e84491d8d150@redhat.com>
Date: Mon, 13 Jan 2025 13:20:23 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH 0/2] mm: filemap: add filemap_grab_folios
To: kalyazin@amazon.com, willy@infradead.org, pbonzini@redhat.com,
 linux-fsdevel@vger.kernel.org, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc: michael.day@amd.com, jthoughton@google.com, michael.roth@amd.com,
 ackerleytng@google.com, graf@amazon.de, jgowans@amazon.com,
 roypat@amazon.co.uk, derekmn@amazon.com, nsaenz@amazon.es,
 xmarcalx@amazon.com
References: <20250110154659.95464-1-kalyazin@amazon.com>
 <5608af05-0b7a-4e11-b381-8b57b701e316@redhat.com>
 <bda9f9a8-1e5a-454e-8506-4e31e6b4c152@amazon.com>
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
In-Reply-To: <bda9f9a8-1e5a-454e-8506-4e31e6b4c152@amazon.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 10.01.25 19:54, Nikita Kalyazin wrote:
> On 10/01/2025 17:01, David Hildenbrand wrote:
>> On 10.01.25 16:46, Nikita Kalyazin wrote:
>>> Based on David's suggestion for speeding up guest_memfd memory
>>> population [1] made at the guest_memfd upstream call on 5 Dec 2024 [2],
>>> this adds `filemap_grab_folios` that grabs multiple folios at a time.
>>>
>>
>> Hi,
> 
> Hi :)
> 
>>
>>> Motivation
>>>
>>> When profiling guest_memfd population and comparing the results with
>>> population of anonymous memory via UFFDIO_COPY, I observed that the
>>> former was up to 20% slower, mainly due to adding newly allocated pages
>>> to the pagecache.  As far as I can see, the two main contributors to it
>>> are pagecache locking and tree traversals needed for every folio.  The
>>> RFC attempts to partially mitigate those by adding multiple folios at a
>>> time to the pagecache.
>>>
>>> Testing
>>>
>>> With the change applied, I was able to observe a 10.3% (708 to 635 ms)
>>> speedup in a selftest that populated 3GiB guest_memfd and a 9.5% (990 to
>>> 904 ms) speedup when restoring a 3GiB guest_memfd VM snapshot using a
>>> custom Firecracker version, both on Intel Ice Lake.
>>
>> Does that mean that it's still 10% slower (based on the 20% above), or
>> were the 20% from a different micro-benchmark?
> 
> Yes, it is still slower:
>    - isolated/selftest: 2.3%
>    - Firecracker setup: 8.9%
> 
> Not sure why the values are so different though.  I'll try to find an
> explanation.

The 2.3% looks very promising.

> 
>>>
>>> Limitations
>>>
>>> While `filemap_grab_folios` handles THP/large folios internally and
>>> deals with reclaim artifacts in the pagecache (shadows), for simplicity
>>> reasons, the RFC does not support those as it demonstrates the
>>> optimisation applied to guest_memfd, which only uses small folios and
>>> does not support reclaim at the moment.
>>
>> It might be worth pointing out that, while support for larger folios is
>> in the works, there will be scenarios where small folios are unavoidable
>> in the future (mixture of shared and private memory).
>>
>> How hard would it be to just naturally support large folios as well?
> 
> I don't think it's going to be impossible.  It's just one more dimension
> that needs to be handled.  `__filemap_add_folio` logic is already rather
> complex, and processing multiple folios while also splitting when
> necessary correctly looks substantially convoluted to me.  So my idea
> was to discuss/validate the multi-folio approach first before rolling
> the sleeves up.

We should likely try making this as generic as possible, meaning we'll
support roughly what filemap_grab_folio() would have supported (e.g., also large folios).

Now I find filemap_get_folios_contig() [thas is already used in memfd code],
and wonder if that could be reused/extended fairly easily.

-- 
Cheers,

David / dhildenb


