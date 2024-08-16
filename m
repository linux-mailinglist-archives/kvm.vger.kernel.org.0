Return-Path: <kvm+bounces-24376-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id EF943954617
	for <lists+kvm@lfdr.de>; Fri, 16 Aug 2024 11:48:28 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 69D781F23356
	for <lists+kvm@lfdr.de>; Fri, 16 Aug 2024 09:48:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8A78316F8EF;
	Fri, 16 Aug 2024 09:48:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Av0MA51+"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 442AE12D773
	for <kvm@vger.kernel.org>; Fri, 16 Aug 2024 09:48:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723801688; cv=none; b=TnIWW/Xl8e/PrFN3yUbXACE8yyO0B6f9sKxJDvjGhCMlLrnfHttoihnGzZa3nDAprG8Z+GYqG3cCICSz3kq4t0z9Ai/49HpfzkIf/etKpsT6/QzANkfalfBQ0q6rpdE+Ajo1ayufemMOpUgYvyQ3VHbaK4LRSRmTPXJOhvwgaZY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723801688; c=relaxed/simple;
	bh=PHgSv5/zg5E2QYWLyGGxNtJvJljjruwzsWzGFsvHl5w=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=hU99Azy/ITjFj4xMwod+swRXWHL9EviMBIa0yROf3jcktwupFW78wZrkvkJzgr6FQATe0ljpTYoacQYxMF0IqmjNomgOwMxDvX9hDmj6JlXtw0Kx3FtbG4CjIc6ZRjE3O6ZLw3NS07ynftiRUhgGv2Bopbhn905oH0vBaxeswwU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Av0MA51+; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1723801685;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=cItGQgldy/tTddRx+wC0nDZv5QfvZntHGpl6Xel0Reg=;
	b=Av0MA51+zFFZZNaRR90VUS3H/uxtbfMB8gOrIqEAfpiXZM65LzpGvq4jh1mP0ma+tRLJHQ
	+jLRrc5vJy8u6pAc/f5MN3qy3xjNihROiUcvUzPIr0J4LktrH3pG35A/Hq+x/Hos/8JS3B
	QyahOK1ogn8xGCkEzbXUDGO954XlJKg=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-679-_CCoxlY1PiyTOCQQktPHVg-1; Fri, 16 Aug 2024 05:48:03 -0400
X-MC-Unique: _CCoxlY1PiyTOCQQktPHVg-1
Received: by mail-wm1-f70.google.com with SMTP id 5b1f17b1804b1-4280f233115so12303985e9.2
        for <kvm@vger.kernel.org>; Fri, 16 Aug 2024 02:48:03 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1723801682; x=1724406482;
        h=content-transfer-encoding:in-reply-to:organization:autocrypt
         :content-language:from:references:cc:to:subject:user-agent
         :mime-version:date:message-id:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=cItGQgldy/tTddRx+wC0nDZv5QfvZntHGpl6Xel0Reg=;
        b=fdaFFUbyY6fcbrBr88dfKR0MmkxI0qBSu1bArpHcXxVEG0l7fWTlK5+egSkfF/UgvC
         4E1kQ/nWVl4LfLGJ1gZgH24hJavoFHIdLw3Vsr5l9UN0j8lJYBvjX0Ys+SNgNKjnNttH
         9YUCTgRUwWpvY8OKKCHBR8pPTnXIYLSAt/S/VGyN3msKokHyN8DiXmjuDj+5F6x8+fVC
         ebFxEZe0EE5Hv87hhDETeBWdvznCN7CnQL27lHV5nS7I23RZrHoO0W3o0RLSIXS0QYzf
         1n6LlNfRluwnJ/3QDuXJDXa5w0y0pZ7TsPbzT6tCStTVA33JdEq/VqR9ue/pelJnXfSO
         C9nA==
X-Forwarded-Encrypted: i=1; AJvYcCWYlqpUCwWtHXWg1tv0MGq6XJRgg8Cu45o3C9YoiohVfirsz4RFW5yXrVDSqZKv/O9cdYW0CyyAcg6EEqT0kPBIpf1G
X-Gm-Message-State: AOJu0Yz/W//2GY0osijdkJ4nojXQVXwuoS9u5RZ4oUBh/NjP7iwk3cyx
	8wOLDqzQBZbnWjiDV45BJlG+VOizsBMZBrWhANH6GbrtaMJAq6WUgjMR9XqZrg1y21UJlBuF52Y
	a/M7nC7iR2EnrS5R7y2tSz5RKZQNjqjo64g4k3/mFog85tPTrHw==
X-Received: by 2002:a05:600c:3b83:b0:426:6688:2421 with SMTP id 5b1f17b1804b1-429ed7ba99dmr14049225e9.11.1723801682216;
        Fri, 16 Aug 2024 02:48:02 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFpQLSDYM16Ri7D7oosItz25ievmmmK0kmDYRTh0OWVOGaMQHp0evjwLT/hi7XGFl5zrP7MkA==
X-Received: by 2002:a05:600c:3b83:b0:426:6688:2421 with SMTP id 5b1f17b1804b1-429ed7ba99dmr14049015e9.11.1723801681661;
        Fri, 16 Aug 2024 02:48:01 -0700 (PDT)
Received: from ?IPV6:2003:cb:c721:b900:4f34:b2b7:739d:a650? (p200300cbc721b9004f34b2b7739da650.dip0.t-ipconnect.de. [2003:cb:c721:b900:4f34:b2b7:739d:a650])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-429ed648ef5sm18253965e9.10.2024.08.16.02.48.00
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 16 Aug 2024 02:48:01 -0700 (PDT)
Message-ID: <aa3b5be8-2c8a-4fe8-8676-a40a9886c715@redhat.com>
Date: Fri, 16 Aug 2024 11:48:00 +0200
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH RFC 4/4] mm: guest_memfd: Add ability for mmap'ing pages
To: Fuad Tabba <tabba@google.com>
Cc: Elliot Berman <quic_eberman@quicinc.com>,
 Andrew Morton <akpm@linux-foundation.org>,
 Paolo Bonzini <pbonzini@redhat.com>, Sean Christopherson
 <seanjc@google.com>, Patrick Roy <roypat@amazon.co.uk>, qperret@google.com,
 Ackerley Tng <ackerleytng@google.com>, linux-coco@lists.linux.dev,
 linux-arm-msm@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-mm@kvack.org, kvm@vger.kernel.org
References: <20240805-guest-memfd-lib-v1-0-e5a29a4ff5d7@quicinc.com>
 <20240805-guest-memfd-lib-v1-4-e5a29a4ff5d7@quicinc.com>
 <4cdd93ba-9019-4c12-a0e6-07b430980278@redhat.com>
 <CA+EHjTxNNinn7EzV_o1X1d0kwhEwrbj_O7H8WgDtEy2CwURZFQ@mail.gmail.com>
From: David Hildenbrand <david@redhat.com>
Content-Language: en-US
Autocrypt: addr=david@redhat.com; keydata=
 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
 WNyWQQ==
Organization: Red Hat
In-Reply-To: <CA+EHjTxNNinn7EzV_o1X1d0kwhEwrbj_O7H8WgDtEy2CwURZFQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 15.08.24 09:24, Fuad Tabba wrote:
> Hi David,

Hi!

> 
> On Tue, 6 Aug 2024 at 14:51, David Hildenbrand <david@redhat.com> wrote:
>>
>>>
>>> -     if (gmem_flags & GUEST_MEMFD_FLAG_NO_DIRECT_MAP) {
>>> +     if (!ops->accessible && (gmem_flags & GUEST_MEMFD_FLAG_NO_DIRECT_MAP)) {
>>>                r = guest_memfd_folio_private(folio);
>>>                if (r)
>>>                        goto out_err;
>>> @@ -107,6 +109,82 @@ struct folio *guest_memfd_grab_folio(struct file *file, pgoff_t index, u32 flags
>>>    }
>>>    EXPORT_SYMBOL_GPL(guest_memfd_grab_folio);
>>>
>>> +int guest_memfd_make_inaccessible(struct file *file, struct folio *folio)
>>> +{
>>> +     unsigned long gmem_flags = (unsigned long)file->private_data;
>>> +     unsigned long i;
>>> +     int r;
>>> +
>>> +     unmap_mapping_folio(folio);
>>> +
>>> +     /**
>>> +      * We can't use the refcount. It might be elevated due to
>>> +      * guest/vcpu trying to access same folio as another vcpu
>>> +      * or because userspace is trying to access folio for same reason
>>
>> As discussed, that's insufficient. We really have to drive the refcount
>> to 1 -- the single reference we expect.
>>
>> What is the exact problem you are running into here? Who can just grab a
>> reference and maybe do nasty things with it?
> 
> I was wondering, why do we need to check the refcount? Isn't it enough
> to check for page_mapped() || page_maybe_dma_pinned(), while holding
> the folio lock?

(folio_mapped() + folio_maybe_dma_pinned())

Not everything goes trough FOLL_PIN. vmsplice() is an example, or just 
some very simple read/write through /proc/pid/mem. Further, some 
O_DIRECT implementations still don't use FOLL_PIN.

So if you see an additional folio reference, as soon as you mapped that 
thing to user space, you have to assume that it could be someone 
reading/writing that memory in possibly sane context. (vmsplice() should 
be using FOLL_PIN|FOLL_LONGTERM, but that's a longer discussion)

(noting that also folio_maybe_dma_pinned() can have false positives in 
some cases due to speculative references or *many* references).

-- 
Cheers,

David / dhildenb


