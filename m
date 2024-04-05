Return-Path: <kvm+bounces-13697-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 9CFF7899A6E
	for <lists+kvm@lfdr.de>; Fri,  5 Apr 2024 12:14:17 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 51C0B284F5F
	for <lists+kvm@lfdr.de>; Fri,  5 Apr 2024 10:14:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0AE2E161919;
	Fri,  5 Apr 2024 10:14:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="KrYVkjJR"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B05E916133E
	for <kvm@vger.kernel.org>; Fri,  5 Apr 2024 10:14:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712312048; cv=none; b=pMzGc3b10g91J1RpflC4YvjQZU4ETEbPkzw6pyt+ZcD93PzYUFv3VOr0eurtV5r2t3SQ/L4KEU+rcAsYfeBDd2U5xD/q2tfhVDnsn7CgjGbC2z4SYTxuL3KyE5MuYzLS7fAJXleYbaG5By1lrlpM2H2guEsQvQuRHPqjDw/rpzk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712312048; c=relaxed/simple;
	bh=9SBJNoNO1FLBc/aU9xElMoCvlBmk+cSrNhdbzpGmaX8=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=dUZjROwhIJKGGXp6U/dGgoa2uoOmq6zBrkffoNjMEy6MK9/+GM90OVhvkmyGVdMAuB/FUs7vkT+Is041D+wpNosQNpmLHxivpIiPl35Lixr1gag5P0RyM8iszEb9SGUSsrrPuQfmKI8nJkLoNIID+e7HgqCzsPF6CUzNJGNAO3Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=KrYVkjJR; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1712312045;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=Q2LsbCNDZ9kZ8fz4UXiWjfH8HnRNSDuHZENAwBXreIo=;
	b=KrYVkjJRVi6Cjook1USToiHES6mgIMWtJD1nUyfDYSr8/FwwTBGhGMtb3lhbRDrECDMqVH
	DEC0UXLs7dRpEou6tVWV2vyITXGxnUXsyeqTV5L/ezfXxlU/fJM7FZgH+IzuWvLZe4bROa
	txbic6X3MxhqAeU8tOXMV4Mg+/hdPuw=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-617-NRbEtnEfPFuD6ksWp9-0wg-1; Fri, 05 Apr 2024 06:14:03 -0400
X-MC-Unique: NRbEtnEfPFuD6ksWp9-0wg-1
Received: by mail-wm1-f72.google.com with SMTP id 5b1f17b1804b1-41489c04f8cso9920355e9.3
        for <kvm@vger.kernel.org>; Fri, 05 Apr 2024 03:14:03 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1712312042; x=1712916842;
        h=content-transfer-encoding:in-reply-to:organization:autocrypt
         :content-language:from:references:cc:to:subject:user-agent
         :mime-version:date:message-id:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=Q2LsbCNDZ9kZ8fz4UXiWjfH8HnRNSDuHZENAwBXreIo=;
        b=aFJ88C/zXd4beZ9LOuHw6e8olYVY4Z+XuP4nmZad59c72pDLDAfo5oTY/T17cr/5Ol
         HxN3EOXmUv7Wfml3wcqx/2b8uIqjLsChZUrc571N2szBnNOcROhh7c7jr8Ifvi7cn4d8
         BrsudE23Yf/FqNc2vRzSe5gFcCcSoSkUPJ7/iInS6an5Mz3JPLADTogDHl0eKehx0L1v
         Glqpo3SXK3ZNlmXLiSCXTFvDJboT9hynoHeXginLAv3uMjtY6SwF1O5ZKDoegggvMXay
         lrv5LD2QImFBjYmRl4uSEWk3cUU/bUcgbkwZkcQF/tha25cJPqsR4NSSyM6jrKCuQwPM
         WpqQ==
X-Forwarded-Encrypted: i=1; AJvYcCXgDb3ZhsnXJHb0mw7b7vC6JczS5pJcYVy9vWrk1mVQQKJQtkCpSOZnoQKC01HfiuTXOolasIG1ZJ1fiS5rSDUBakdu
X-Gm-Message-State: AOJu0Ywj5IFx4N2EZDfcS51wN6QzrKbqR+fLaxfzczgLFO4PjqhHSnI2
	oiWCXqRtBevkpuH1rdH2w1mYaUyu5vcbIfYXW0uuuuO36vFEqOb6QYHCb603Zx0HEJqnb1Wy/kr
	WMUdYK37Ath5k/U5J/71XCQbd9EfkBP4QyFj9XSOLPAoBR+OmX8umWzmChw==
X-Received: by 2002:a05:600c:3594:b0:413:f3f0:c591 with SMTP id p20-20020a05600c359400b00413f3f0c591mr785382wmq.41.1712312042126;
        Fri, 05 Apr 2024 03:14:02 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEMzMYKxfyvSr6YxQeBStz2WDjrVzPSM6kxu1H/M1eplI/e8pfwS/xR0E2e7lDCYHcQh3E1gw==
X-Received: by 2002:a05:600c:3594:b0:413:f3f0:c591 with SMTP id p20-20020a05600c359400b00413f3f0c591mr785367wmq.41.1712312041714;
        Fri, 05 Apr 2024 03:14:01 -0700 (PDT)
Received: from ?IPV6:2003:cb:c74b:5500:e1f8:a310:8fa3:4ec1? (p200300cbc74b5500e1f8a3108fa34ec1.dip0.t-ipconnect.de. [2003:cb:c74b:5500:e1f8:a310:8fa3:4ec1])
        by smtp.gmail.com with ESMTPSA id o34-20020a05600c512200b0041627ab1554sm5847474wms.22.2024.04.05.03.14.00
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 05 Apr 2024 03:14:01 -0700 (PDT)
Message-ID: <7a1c58d7-ddd9-40fc-a4ef-81c548de2b07@redhat.com>
Date: Fri, 5 Apr 2024 12:14:00 +0200
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH 0/4] KVM: x86/mmu: Rework marking folios
 dirty/accessed
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: Sean Christopherson <seanjc@google.com>,
 David Matlack <dmatlack@google.com>, kvm@vger.kernel.org,
 linux-kernel@vger.kernel.org, David Stevens <stevensd@chromium.org>,
 Matthew Wilcox <willy@infradead.org>
References: <20240320005024.3216282-1-seanjc@google.com>
 <4d04b010-98f3-4eae-b320-a7dd6104b0bf@redhat.com>
 <CALzav=eLH+V_5Y6ZWsRkmnbEb6fxPa55B7xyWxP3o6qsrs_nHA@mail.gmail.com>
 <a2fff462-dfe6-4979-a7b2-131c6e0b5017@redhat.com>
 <ZgygGmaEuddZGKyX@google.com>
 <ca1f320b-dc06-48e0-b4f5-ce860a72f0e2@redhat.com>
 <Zg3V-M3iospVUEDU@google.com>
 <42dbf562-5eab-4f82-ad77-5ee5b8c79285@redhat.com>
 <Zg7j2D6WFqcPaXFB@google.com>
 <b3ea925f-bd47-4f54-bede-3f0d7471e3d7@redhat.com>
 <Zg8jip0QIBbOCgpz@google.com>
 <36e1592a-e590-48a0-9a79-eeac6b41314b@redhat.com>
 <CABgObfbykeRXv2r2tULe6_SwD7DkWPaMTdc6PkAUb3JmTodf4w@mail.gmail.com>
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
In-Reply-To: <CABgObfbykeRXv2r2tULe6_SwD7DkWPaMTdc6PkAUb3JmTodf4w@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 05.04.24 11:37, Paolo Bonzini wrote:
> On Fri, Apr 5, 2024 at 8:53 AM David Hildenbrand <david@redhat.com> wrote:
>>>        mmu_notifier_invalidate_range_start(&range);
>>>        tlb_start_vma(&tlb, vma);
>>>        walk_page_range(vma->vm_mm, range.start, range.end,
>>>                        &madvise_free_walk_ops, &tlb);
>>>        tlb_end_vma(&tlb, vma);
>>>        mmu_notifier_invalidate_range_end(&range);
>>>
>>
>> Indeed, we do setup the MMU notifier invalidation. We do the start/end
>> ... I was looking for PTE notifications.
>>
>> I spotted the set_pte_at(), not a set_pte_at_notify() like we do in
>> other code. Maybe that's not required here (digging through
>> documentation I'm still left clueless). [...]
>> Absolutely unclear to me when we *must* to use it, or if it is. Likely
>> its a pure optimization when we're *changing* a PTE.
> 
> Yes, .change_pte() is just an optimization. The original point of it
> was for KSM, so that KVM could flip the sPTE to a new location without
> first zapping it. At the time there was also an .invalidate_page()
> callback, and both of them were *not* bracketed by calls to
> mmu_notifier_invalidate_range_{start,end}()
> 
> Later on, both callbacks were changed to occur within an
> invalidate_range_start/end() block.
> 
> Commit 6bdb913f0a70 ("mm: wrap calls to set_pte_at_notify with
> invalidate_range_start and invalidate_range_end", 2012-10-09) did so
> for .change_pte(). The reason to do so was a bit roundabout, namely to
> allow sleepable .invalidate_page() hooks (because .change_pte() is not
> sleepable and at the time .invalidate_page() was used as a fallback
> for .change_pte()).
> 
> This however made KVM's usage of the .change_pte() callback completely
> moot, because KVM unmaps the sPTEs during .invalidate_range_start()
> and therefore .change_pte() has no hope of succeeding.
> 
> (Commit 369ea8242c0f ("mm/rmap: update to new mmu_notifier semantic
> v2", 2017-08-31) is where the other set of non-bracketed calls to MMU
> notifier callbacks was changed; calls to
> mmu_notifier_invalidate_page() were replaced by calls to
> mmu_notifier_invalidate_range(), bracketed by calls to
> mmu_notifier_invalidate_range_{start,end}()).
> 
> Since KVM is the only user of .change_pte(), we can remove
> .change_pte() and set_pte_at_notify() completely.

Nice, thanks for all that information!

-- 
Cheers,

David / dhildenb


