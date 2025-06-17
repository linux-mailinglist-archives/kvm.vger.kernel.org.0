Return-Path: <kvm+bounces-49710-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id B2814ADCE76
	for <lists+kvm@lfdr.de>; Tue, 17 Jun 2025 15:58:49 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 1A39F1798B3
	for <lists+kvm@lfdr.de>; Tue, 17 Jun 2025 13:58:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 46FFA2E717D;
	Tue, 17 Jun 2025 13:58:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="ToA7Kr93"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9E3A22E7173
	for <kvm@vger.kernel.org>; Tue, 17 Jun 2025 13:58:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750168715; cv=none; b=rbjHMcGIFqVnBqF79VBAHAZx4eoEq8TeExDKlf02VBU0wLhVx0jSabrQjGA7LfWcnCMSYe/k8CT+sqCu6HXU8UYUQBT8+w4q2Pe5+Iaw8CRYava/UKiiaaUCTRwA5fv1h3HzqMqCi4NkSzlR4q7nXVK4fTSL++Uw3aV9dFF3oa4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750168715; c=relaxed/simple;
	bh=R4KbgbS6vcOHANI6iSDtaBzCMkeqXetSKt1/ZhGPQBQ=;
	h=Message-ID:Date:MIME-Version:Subject:From:To:Cc:References:
	 In-Reply-To:Content-Type; b=QdhXw5yo9ZFLpBy8KIpbPJ+yVxdQLSkvGRkjlEX6FP0biAMUDuyjmNgsDSAB72QSu2mFngp4S3MvFCmRGCZu/81JjJxNPgLlXhiR6veso9vwDDoB5XGPzTfN5pkfdBcOHoDqljSukGT6BADoHxGGSTAl7n1rOyoVTujDC405JdY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=ToA7Kr93; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1750168712;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=UCoWasVGpebT4pYyaDzSoFsRBl+kSgrz9fApdkK/1Sk=;
	b=ToA7Kr93KR4zh9bzaSJRipSfWyzo5mCIJk7lBOu/ywqUC+bYj3j51SAPD7p4auDI+8dHct
	+B6pvI04BCLrppyIdZ2gWEqQ7jQON7ZaaxMpouuoDG/fAWgpB0FghJyUY5iX7dIViE/fVp
	3BBlzqhK+djpVNdIgYJ6odyidSc00jc=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-128-IfQ1_ZXuOTevlmo0FW5JxA-1; Tue, 17 Jun 2025 09:58:31 -0400
X-MC-Unique: IfQ1_ZXuOTevlmo0FW5JxA-1
X-Mimecast-MFC-AGG-ID: IfQ1_ZXuOTevlmo0FW5JxA_1750168710
Received: by mail-wr1-f70.google.com with SMTP id ffacd0b85a97d-3a4f6ba526eso3415181f8f.1
        for <kvm@vger.kernel.org>; Tue, 17 Jun 2025 06:58:31 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1750168710; x=1750773510;
        h=content-transfer-encoding:in-reply-to:organization:autocrypt
         :content-language:references:cc:to:from:subject:user-agent
         :mime-version:date:message-id:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=UCoWasVGpebT4pYyaDzSoFsRBl+kSgrz9fApdkK/1Sk=;
        b=QnAqvKGm9FIbCXFajuxLwNTttqrQcasiIrdmseLdvIGqpCRNV7dXXPkAW85q/z1QmQ
         HEyZ+z/ZDnsprJcb5SX+VHAeRZ9yih/aiJxKZ2ucgdydUPPrvayNjsNXwl7ZMeB4SBjE
         5Om0/YkuRqWCjB04d5aa/Qk1brvh77CUsOcQaaX3A7Qu1MA3DYNqTRW/1kY5twVWDr1S
         qZKDZFlurOrQrrefHy+Ljmht17FTYpUeYZkLAoWZald5nHFbJOkZCiY1iwQtZTBDpLlJ
         rFUU+Jfcg2K0Bsv+NTx6QOYxhIPbWIxWNLpd9cgR7HjWcCo8QhCpUYxPbdocidewOrZd
         L7Ww==
X-Forwarded-Encrypted: i=1; AJvYcCUJ78rtn7vZ+n2f85sISK1IcshKLDRVXnmAxj9Rhn07PvlUF34F7urtKzv4FwiqHwnKZPI=@vger.kernel.org
X-Gm-Message-State: AOJu0Yy0wDFHjIgkBh1OvsjVR+KsAcK6NRcwCt7oJiBqQBTWC0mba9vC
	uSf/B1+gZLYZvNLn+sa6lfdMI1B9aMOtrmjxsHSklh4NRtlxuXUy590UQUlZNPLfajeHmoG4BOi
	YafUEax+aip/Ypb2rTpr3X4exy7CCNZ18AzfOfsgFs66+dkh9mDox/g==
X-Gm-Gg: ASbGncsolZHySP+POzWxEuZQ7d9zOruB+acpLV5EBAMoNZCxhENN0y9TX4Ng8GK62ia
	apP6augIzZAX/IBm8qw6mTgLAY5ykRSFyOm4lcobINNQvkmvkPYKlqOi8bXaCopdDXGKYw3hNyv
	+6QKMbHOD0JYXUDXZAuWsbmgyEb2j7eu9phOWYliUpOX1gmzfIgjLbxAc5BeeTQ2nOemXSw72fI
	syfvhMvqqzESHOq/u14WxJqRLg0uDDFOJmGJEmvmBM85mNnrC75lb4LDbj40W0KWvy2UtqIwvZX
	YWqLiPDocTRAqN/Uc7CZGRoeZS/DNbuTHZ0ruQpUWRhMFXU7/DUgBMrt83/3Pbjqplve7lsrSsz
	jkEsZyqwPYw/sk7yvZrA54aNrujAT+AosxnagrfcUhccz3o8=
X-Received: by 2002:a05:6000:1449:b0:3a4:ed62:c7e1 with SMTP id ffacd0b85a97d-3a572367734mr9722386f8f.12.1750168710052;
        Tue, 17 Jun 2025 06:58:30 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IF9tCgVXCdg2h3H99E2uuyROs/cSpd9476VBWtxM8o5GIJvE74IbqrY9BHmfyX4S8yOl5tz4g==
X-Received: by 2002:a05:6000:1449:b0:3a4:ed62:c7e1 with SMTP id ffacd0b85a97d-3a572367734mr9722365f8f.12.1750168709634;
        Tue, 17 Jun 2025 06:58:29 -0700 (PDT)
Received: from ?IPV6:2003:d8:2f31:700:3851:c66a:b6b9:3490? (p200300d82f3107003851c66ab6b93490.dip0.t-ipconnect.de. [2003:d8:2f31:700:3851:c66a:b6b9:3490])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3a568a734b5sm14399629f8f.33.2025.06.17.06.58.28
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 17 Jun 2025 06:58:29 -0700 (PDT)
Message-ID: <21958961-259f-4520-ae60-e234383945d7@redhat.com>
Date: Tue, 17 Jun 2025 15:58:28 +0200
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 2/3] gup: introduce unpin_user_folio_dirty_locked()
From: David Hildenbrand <david@redhat.com>
To: Jason Gunthorpe <jgg@ziepe.ca>, lizhe.67@bytedance.com
Cc: alex.williamson@redhat.com, akpm@linux-foundation.org, peterx@redhat.com,
 kvm@vger.kernel.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org
References: <20250617041821.85555-1-lizhe.67@bytedance.com>
 <20250617041821.85555-3-lizhe.67@bytedance.com>
 <20250617134251.GA1376515@ziepe.ca>
 <460e16a0-c8d9-493a-b54f-2c793c969eb1@redhat.com>
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
In-Reply-To: <460e16a0-c8d9-493a-b54f-2c793c969eb1@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 17.06.25 15:45, David Hildenbrand wrote:
> On 17.06.25 15:42, Jason Gunthorpe wrote:
>> On Tue, Jun 17, 2025 at 12:18:20PM +0800, lizhe.67@bytedance.com wrote:
>>
>>> @@ -360,12 +360,7 @@ void unpin_user_page_range_dirty_lock(struct page *page, unsigned long npages,
>>>    
>>>    	for (i = 0; i < npages; i += nr) {
>>>    		folio = gup_folio_range_next(page, npages, i, &nr);
>>> -		if (make_dirty && !folio_test_dirty(folio)) {
>>> -			folio_lock(folio);
>>> -			folio_mark_dirty(folio);
>>> -			folio_unlock(folio);
>>> -		}
>>> -		gup_put_folio(folio, nr, FOLL_PIN);
>>> +		unpin_user_folio_dirty_locked(folio, nr, make_dirty);
>>>    	}
>>
>> I don't think we should call an exported function here - this is a
>> fast path for rdma and iommfd, I don't want to see it degrade to save
>> three duplicated lines :\
> 
> Any way to quantify? In theory, the compiler could still optimize this
> within the same file, no?

Looking at the compiler output, I think the compile is doing exactly that.

Unless my obdjump -D -S analysis skills are seriously degraded :)

-- 
Cheers,

David / dhildenb


