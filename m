Return-Path: <kvm+bounces-40009-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 0F766A4D94D
	for <lists+kvm@lfdr.de>; Tue,  4 Mar 2025 10:53:07 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id BEF943B6777
	for <lists+kvm@lfdr.de>; Tue,  4 Mar 2025 09:46:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F34C11FE469;
	Tue,  4 Mar 2025 09:45:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="eIvmx9ey"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8D71E1FDE23
	for <kvm@vger.kernel.org>; Tue,  4 Mar 2025 09:45:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741081552; cv=none; b=srn5FJPxZXLS0FNgxA/RvcJqWnN7emujlGVAiG7t9bXes1joZIq66UhEIcgCkkmJTxoE+8yH+FTESX3H4Eoyby7oQFrbJC1+YKZFBML9Dvxw9cCKr1wWPaHofWq8e1qnfsO0Jyi+xz1i4jUQuRGN1vE2/8DYK6jpIsPQaVLTBGA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741081552; c=relaxed/simple;
	bh=Etkj35xIueEkQfdpwUgzeTPo6BKw/yt1Zm7DCwtGZeM=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=VbczO99GigBN7BoDdQrYChJmywcnQtLRMUDTY/5B669a3sVDolhClSVBfdOrwSD6aqmj25wVJ1+JTxTQgisXc7wPMA2ZE0ez1R+NLCrOBs3iH9FhG1Qy7YQou8JIXuWqF+Ym67tQP3FynJGj0N7mpp+ejuatez+nMbty5q2VdL0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=eIvmx9ey; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1741081549;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=JNqQ/GVbK9ChYvYEjjBGhded/nOdEDHBc8/9cnh/oz8=;
	b=eIvmx9eyd8QABJ/uNDuLDs7iyjJ9QSkvmSa2UEaL/YP27HESS+sQQ3j/We4cmbRY20Va3s
	dTNCSf70QSd8WSZolgnU8i+PSa6R84Bj06Mi2UNMPXpGFG8YWwXVKmZubIif7ys7J4LgyN
	lMKxNXlt+z8ga7m60kMlHlqFPy6Vpq0=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-439-7kCA7S1NO5OSrw4qV79nDg-1; Tue, 04 Mar 2025 04:45:43 -0500
X-MC-Unique: 7kCA7S1NO5OSrw4qV79nDg-1
X-Mimecast-MFC-AGG-ID: 7kCA7S1NO5OSrw4qV79nDg_1741081542
Received: by mail-wm1-f69.google.com with SMTP id 5b1f17b1804b1-43ab5baf62cso39680945e9.0
        for <kvm@vger.kernel.org>; Tue, 04 Mar 2025 01:45:42 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1741081542; x=1741686342;
        h=content-transfer-encoding:in-reply-to:organization:autocrypt
         :content-language:from:references:cc:to:subject:user-agent
         :mime-version:date:message-id:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=JNqQ/GVbK9ChYvYEjjBGhded/nOdEDHBc8/9cnh/oz8=;
        b=dAZogF//9QWi02u5dN+OHBSDtkCk07e579blZi8JwqJFsF1V3K5ZQISxXkyniKPA64
         mY5yqrMRpjCYKG6Uq5bxQ1qugmO9ncRfW1WS+MrvEp6chtiDXvRXOvvG/dD28aTGghip
         CBaLpz50NpLIkKgADdxUoX5dH+t41wm03IEWitZiNJGoqA4Y7GhlpMcdV5sfB1Txdt9R
         QdVk2C0CVwgDEE2+gSY6Trl/nZJlsDn1UiU2rwl5Xrlur8BknIXBzW6oQodLQCReu7bk
         xrSeKK7fw607b/2B72i6Z3IWZCYmtr7Ci1ROpzGqWK+AcxwTtT0mjwnZtzWPeh8Ion8Q
         6AmA==
X-Gm-Message-State: AOJu0Yx6LiCUUaguM2/lCx0WYyvR1VgSUUfAq29Ew1KzEKtXuHAccc2m
	/gnDDiF96HA+2uGlxSCkwElVne784arqGc23DK9LBgVYJubY4K52bC5fk9GBaKL1ZLlgnbWuIrL
	21d6wR6Ug0OlMs67gQ+QrcJ5M9huBGHJcUeIu6g1arFSemZ0A3dQ9tqUAjtWn
X-Gm-Gg: ASbGncsCnMX5eLxZQ7jT68St6D3zUEuYa+unCFfUQ8pQ2dgZPTdVDW4oAcPBtkIIv7w
	yaj1F2rZ4CUiuayW57/VdaNLFV6oCGkK2j0awohYysjcFtpMr83eu2lmATphIo+Z9qeKAorHC3Q
	o6TaQGL0J5rY/Kv5GWM31per942C0KdbAeebwWDdIa+C2xyjcVfjldLmQEMifzERUVba7dbsNZt
	mr0cQzQkFxfqfv+ruibZ7zwPuMF3UtJqbvfUyW77sUZ0cwHb8an+9ln35GPoHe4aiOSwdiO/5a+
	Q7OIusnpwpky5n5MR2eqnMK61xnG22BWDYP8ZrqDvHkWpkEPWah86MgMhsijhs1vg0F9Phug9YY
	d4GgCrJ6SPjmAKWUg9/SVy8C5qobfnynhQmW5rG7nGdo=
X-Received: by 2002:a05:600c:4693:b0:439:689b:99eb with SMTP id 5b1f17b1804b1-43ba66df708mr148045395e9.7.1741081541897;
        Tue, 04 Mar 2025 01:45:41 -0800 (PST)
X-Google-Smtp-Source: AGHT+IGKJwjoUFLPXCntqIDW10h1P/Ep/zotOnQeG0kCFvUHD2y4qyhFTvR4YUwvcXMJ286ln/9clA==
X-Received: by 2002:a05:600c:4693:b0:439:689b:99eb with SMTP id 5b1f17b1804b1-43ba66df708mr148045195e9.7.1741081541573;
        Tue, 04 Mar 2025 01:45:41 -0800 (PST)
Received: from ?IPV6:2003:cb:c736:1000:9e30:2a8a:cd3d:419c? (p200300cbc73610009e302a8acd3d419c.dip0.t-ipconnect.de. [2003:cb:c736:1000:9e30:2a8a:cd3d:419c])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-43bcbcbe64fsm10866595e9.0.2025.03.04.01.45.40
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 04 Mar 2025 01:45:41 -0800 (PST)
Message-ID: <9f4d8c72-7bd9-4388-9442-3c84cd0a4558@redhat.com>
Date: Tue, 4 Mar 2025 10:45:40 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 1/1] KVM: s390: pv: fix race when making a page secure
To: Claudio Imbrenda <imbrenda@linux.ibm.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-s390@vger.kernel.org, frankja@linux.ibm.com, borntraeger@de.ibm.com,
 nrb@linux.ibm.com, seiden@linux.ibm.com, nsg@linux.ibm.com,
 schlameuss@linux.ibm.com, hca@linux.ibm.com
References: <20250227130954.440821-1-imbrenda@linux.ibm.com>
 <20250227130954.440821-2-imbrenda@linux.ibm.com>
 <370231a1-af36-46ca-a87c-ce1929473c1d@redhat.com>
 <20250304102134.1bd9fb03@p-imbrenda>
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
In-Reply-To: <20250304102134.1bd9fb03@p-imbrenda>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 04.03.25 10:21, Claudio Imbrenda wrote:
> On Fri, 28 Feb 2025 22:15:04 +0100
> David Hildenbrand <david@redhat.com> wrote:
> 
>> On 27.02.25 14:09, Claudio Imbrenda wrote:
>>> Holding the pte lock for the page that is being converted to secure is
>>> needed to avoid races. A previous commit removed the locking, which
>>> caused issues. Fix by locking the pte again.
>>>
>>> Fixes: 5cbe24350b7d ("KVM: s390: move pv gmap functions into kvm")
>>> Reported-by: David Hildenbrand <david@redhat.com>
>>> Signed-off-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
>>
>> Tested with shmem / memory-backend-memfd that ends up using large folios
>> / THPs.
>>
>> Tested-by: David Hildenbrand <david@redhat.com>
>> Reviewed-by: David Hildenbrand <david@redhat.com>
>>
>> Two comments below.
> 
> I will need to send a v4, unfortunately there are other issues with this
> patch (as you have probably noticed by now as well)

I ran into some weird KVM_PV_VERIFY issues a couple of times, but did 
not find the root cause so far.

Is that what you are seeing? (and what is the root cause? :) )

-- 
Cheers,

David / dhildenb


