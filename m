Return-Path: <kvm+bounces-24414-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 8C568955088
	for <lists+kvm@lfdr.de>; Fri, 16 Aug 2024 20:09:00 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 487BD283A7D
	for <lists+kvm@lfdr.de>; Fri, 16 Aug 2024 18:08:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 651A61C37B5;
	Fri, 16 Aug 2024 18:08:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="GwkhC7Ud"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A0CC91C378F
	for <kvm@vger.kernel.org>; Fri, 16 Aug 2024 18:08:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723831727; cv=none; b=HmwyqhP6GM7VtvlsJTJN9MFn5jVbI9wXKHeEBC7c5aScx1HrNazY5XYSm4/Qi+TJqpq47ZkilPh6Cmj4UgztnOUpQp9ZDKNomxZlWzHlqdGJpg1+azkfK1oazwlos2cTJfmF8IxRbKVkvmvXFRfcd1XkX2kLPKYpKwi10ohXonI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723831727; c=relaxed/simple;
	bh=pAGWq6N60Tml4Ne9hgnN3aaua/i7PK/bq3RmX5CZ7O0=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=frNxTZmeABQSGJFDEh+4C72+q2/kLH610e4gGk2+ln2p6pi9997h5FnUa2fxAjB/hhCZT72UP/ZxXfywo3nAz6SsZfiwpGq8c8SQvZNMw6cGCGjr/xzErug7tb8VV33JUp1R1fO/9YXnf5RtTA51g4RW+iH8eD/Y4sEJOz36X6w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=GwkhC7Ud; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1723831723;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=7LvZHajAoereLQ/n3rjWTKD/n9Ae1jh7vyVQTrCVhi0=;
	b=GwkhC7UdqnfwZzIO6Cd+nfl1CNGT+wZjxlAzjn+oJr0qA9cM2Xem5bsPtBV3IQLjDXLUsf
	xXVPpN0VX4lCXCJWhNK6kEJd5JpvWN8w0lOEx3zyulxYmZBbCf1f7nOnUlBYrpFZgYFy3H
	8zx4uKJC7k2PfFbnHP0uLlLKIs6LvGQ=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-44-Gft3deKuPjOYS2B2ODWuUg-1; Fri, 16 Aug 2024 14:08:42 -0400
X-MC-Unique: Gft3deKuPjOYS2B2ODWuUg-1
Received: by mail-wm1-f69.google.com with SMTP id 5b1f17b1804b1-42809eb7b99so12511795e9.0
        for <kvm@vger.kernel.org>; Fri, 16 Aug 2024 11:08:42 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1723831721; x=1724436521;
        h=content-transfer-encoding:in-reply-to:organization:autocrypt
         :content-language:from:references:cc:to:subject:user-agent
         :mime-version:date:message-id:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=7LvZHajAoereLQ/n3rjWTKD/n9Ae1jh7vyVQTrCVhi0=;
        b=I+SZ4JB3o9LtyNo5u1o5hHvvkKq8kdytaAv4+z73MHBVIqVKCL4Kc/7+0aZILHDvPi
         jpk9pPPDVIoZh6/wljSNqZ9818+kob1GpX4mtOMdu3vwR7B4vnJxVjmKp1xETMcGI7KY
         RGi8pf6vsevw+bHHmdoi7mDFeq6TcvqNE5F9wE+hRBVp9d+PI8fGzJqrum59Yn4BS7Vr
         PgZ19dfYNqCbuWq50bLaYxVaLEsxEJEmGB47k/imJuQkwCGI545Cs0frgjESGA6Mb2j4
         En+QCOZF5lv1WWTRKUQyI97glFaayPYfbHgWWxx+JGMCk15QI4K4ZMz3jRSSmeuunoMF
         +IAg==
X-Forwarded-Encrypted: i=1; AJvYcCXITju8d9l2RiSgC3p/xtVXSmFvDwo7XuG8nA4rqXhpuIzzUwh3jsmA0NO6VEOHSITlhvZa/sSptxTiAb6L6E7MAulR
X-Gm-Message-State: AOJu0Yx0EEFhx4ZQFZTRcDK09Zox8HJXs1E2Yz3+WvdBFi0ZPaNmmdCM
	J4y4PKoieaFhoHCHOfs6HpvMISEGeXwPbAjO/WRuaYEknqVuP5fSWJXiA5Mk0iD6psW99izzzvc
	9pLOBd8fAdTDGyJX3cZWtJnKES1zHGanqFy2ggJMQXhyBmC9hjw==
X-Received: by 2002:a05:600c:45c3:b0:426:6eb6:1374 with SMTP id 5b1f17b1804b1-429e223b9d3mr60729935e9.0.1723831721047;
        Fri, 16 Aug 2024 11:08:41 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGaR7laP3i8PcoK1VQRgylTTtn4SNtF7osOBDTb0u6r4W+A4x3wD2fW6732plT6G8pqs5qaHA==
X-Received: by 2002:a05:600c:45c3:b0:426:6eb6:1374 with SMTP id 5b1f17b1804b1-429e223b9d3mr60729615e9.0.1723831720535;
        Fri, 16 Aug 2024 11:08:40 -0700 (PDT)
Received: from ?IPV6:2003:cb:c721:b900:4f34:b2b7:739d:a650? (p200300cbc721b9004f34b2b7739da650.dip0.t-ipconnect.de. [2003:cb:c721:b900:4f34:b2b7:739d:a650])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-429ded299a9sm81171405e9.18.2024.08.16.11.08.39
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 16 Aug 2024 11:08:40 -0700 (PDT)
Message-ID: <94c5d735-821c-40ba-ae85-1881c6f4445d@redhat.com>
Date: Fri, 16 Aug 2024 20:08:38 +0200
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH RFC 4/4] mm: guest_memfd: Add ability for mmap'ing pages
To: Ackerley Tng <ackerleytng@google.com>, Fuad Tabba <tabba@google.com>
Cc: Elliot Berman <quic_eberman@quicinc.com>,
 Andrew Morton <akpm@linux-foundation.org>,
 Paolo Bonzini <pbonzini@redhat.com>, Sean Christopherson
 <seanjc@google.com>, Patrick Roy <roypat@amazon.co.uk>, qperret@google.com,
 linux-coco@lists.linux.dev, linux-arm-msm@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-mm@kvack.org, kvm@vger.kernel.org
References: <20240805-guest-memfd-lib-v1-0-e5a29a4ff5d7@quicinc.com>
 <20240805-guest-memfd-lib-v1-4-e5a29a4ff5d7@quicinc.com>
 <4cdd93ba-9019-4c12-a0e6-07b430980278@redhat.com>
 <CA+EHjTxNNinn7EzV_o1X1d0kwhEwrbj_O7H8WgDtEy2CwURZFQ@mail.gmail.com>
 <aa3b5be8-2c8a-4fe8-8676-a40a9886c715@redhat.com>
 <diqzjzggmkf7.fsf@ackerleytng-ctop.c.googlers.com>
From: David Hildenbrand <david@redhat.com>
Content-Language: en-US
Autocrypt: addr=david@redhat.com; keydata=
 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
 WNyWQQ==
Organization: Red Hat
In-Reply-To: <diqzjzggmkf7.fsf@ackerleytng-ctop.c.googlers.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 16.08.24 19:45, Ackerley Tng wrote:
> 
> David Hildenbrand <david@redhat.com> writes:
> 
>> On 15.08.24 09:24, Fuad Tabba wrote:
>>> Hi David,
>>
>> Hi!
>>
>>>
>>> On Tue, 6 Aug 2024 at 14:51, David Hildenbrand <david@redhat.com> wrote:
>>>>
>>>>>
>>>>> -     if (gmem_flags & GUEST_MEMFD_FLAG_NO_DIRECT_MAP) {
>>>>> +     if (!ops->accessible && (gmem_flags & GUEST_MEMFD_FLAG_NO_DIRECT_MAP)) {
>>>>>                 r = guest_memfd_folio_private(folio);
>>>>>                 if (r)
>>>>>                         goto out_err;
>>>>> @@ -107,6 +109,82 @@ struct folio *guest_memfd_grab_folio(struct file *file, pgoff_t index, u32 flags
>>>>>     }
>>>>>     EXPORT_SYMBOL_GPL(guest_memfd_grab_folio);
>>>>>
>>>>> +int guest_memfd_make_inaccessible(struct file *file, struct folio *folio)
>>>>> +{
>>>>> +     unsigned long gmem_flags = (unsigned long)file->private_data;
>>>>> +     unsigned long i;
>>>>> +     int r;
>>>>> +
>>>>> +     unmap_mapping_folio(folio);
>>>>> +
>>>>> +     /**
>>>>> +      * We can't use the refcount. It might be elevated due to
>>>>> +      * guest/vcpu trying to access same folio as another vcpu
>>>>> +      * or because userspace is trying to access folio for same reason
>>>>
>>>> As discussed, that's insufficient. We really have to drive the refcount
>>>> to 1 -- the single reference we expect.
>>>>
>>>> What is the exact problem you are running into here? Who can just grab a
>>>> reference and maybe do nasty things with it?
>>>
>>> I was wondering, why do we need to check the refcount? Isn't it enough
>>> to check for page_mapped() || page_maybe_dma_pinned(), while holding
>>> the folio lock?
> 
> Thank you Fuad for asking!
> 
>>
>> (folio_mapped() + folio_maybe_dma_pinned())
>>
>> Not everything goes trough FOLL_PIN. vmsplice() is an example, or just
>> some very simple read/write through /proc/pid/mem. Further, some
>> O_DIRECT implementations still don't use FOLL_PIN.
>>
>> So if you see an additional folio reference, as soon as you mapped that
>> thing to user space, you have to assume that it could be someone
>> reading/writing that memory in possibly sane context. (vmsplice() should
>> be using FOLL_PIN|FOLL_LONGTERM, but that's a longer discussion)
>>
> 
> Thanks David for the clarification, this example is very helpful!
> 
> IIUC folio_lock() isn't a prerequisite for taking a refcount on the
> folio.

Right, to do folio_lock() you only have to guarantee that the folio 
cannot get freed concurrently. So you piggyback on another reference 
(you hold indirectly).

> 
> Even if we are able to figure out a "safe" refcount, and check that the
> current refcount == "safe" refcount before removing from direct map,
> what's stopping some other part of the kernel from taking a refcount
> just after the check happens and causing trouble with the folio's
> removal from direct map?

Once the page was unmapped from user space, and there were no additional 
references (e.g., GUP, whatever), any new references can only be 
(should, unless BUG :) ) temporary speculative references that should 
not try accessing page content, and that should back off if the folio is 
not deemed interesting or cannot be locked. (e.g., page 
migration/compaction/offlining).

Of course, there are some corner cases (kgdb, hibernation, /proc/kcore), 
but most of these can be dealt with in one way or the other (make these 
back off and not read/write page content, similar to how we handled it 
for secretmem).

These (kgdb, /proc/kcore) might not even take a folio reference, they 
just "access stuff" and we only have to teach them to "not access that".

> 
>> (noting that also folio_maybe_dma_pinned() can have false positives in
>> some cases due to speculative references or *many* references).
> 
> Are false positives (speculative references) okay since it's better to
> be safe than remove from direct map prematurely?

folio_maybe_dma_pinned() is primarily used in fork context. Copying more 
(if the folio maybe pinned and, therefore, must not get COW-shared with 
other processes and must instead create a private page copy) is the 
"better safe than sorry". So false positives (that happen rarely) are 
tolerable.

Regading the directmap, it would -- just like with additional references 
-- detect that the page cannot currently be removed from the direct map. 
It's similarly "better safe than sorry", but here means that we likely 
must retry if we cannot easily fallback to something else like for the 
fork+COW case.

-- 
Cheers,

David / dhildenb


