Return-Path: <kvm+bounces-20052-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id A1D3690FFC9
	for <lists+kvm@lfdr.de>; Thu, 20 Jun 2024 11:01:23 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 16CD51F219E7
	for <lists+kvm@lfdr.de>; Thu, 20 Jun 2024 09:01:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 897B119ADB8;
	Thu, 20 Jun 2024 09:00:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="EqYzJlIR"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DAF757C6C9
	for <kvm@vger.kernel.org>; Thu, 20 Jun 2024 09:00:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718874053; cv=none; b=PpckEaZsxRLnD1w6NRSbpFvSpIvISjmGVZSo5cV2jTamM5LsefxI8FlNgexRmmJcphQzzp41Hw/Ovh6q/Y6UlC0y8aW3vJIrLrpDRB8DDk082LfwG58WdIObtYSm6OWeygaMPnucRGfGbNMTl4fyaZ+RZarYEMzyN7M4N6ngmZk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718874053; c=relaxed/simple;
	bh=goWA/GhwWrrFrWZffN97ckNSsmx1+Ao/Qkn5wo9lWEA=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=aXib7NvqsDAnuDzkb0P02MRP1jOmQAytLAZmfksCsePAHOr6Mi/l2jc8GzC/KxHYPjkTpNmucd05HK/S0ILYMqof0c1gAcyY+KJRv+fhAhYwrWK/RmbD8GplJtA+n4GYbJ6SYXSFvAwe0VfWpRx3snr8KH1c79nj1YVxhzxP5mw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=EqYzJlIR; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1718874050;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=9X/I36k5SWaheNfC/42dOzlw6jEc4rfuDMkNMoqwybI=;
	b=EqYzJlIRMNY5cwFVsVXQy9a0CQl/hI3vv3zfU8tuqW85npylL67ksKk+JOqyZfnkfJyPlb
	l55sjI1BBu1DJZQjk3Vi+cbAZBi1s/0T0IKW0Kkc/uUMHQQuI0pAS44ch3bHZihB+KzgK0
	B4wHnyEs+f48KlxDZ1xEXNofccQewcw=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-586-nA0gGWbzOdyYz3tKGJhFVQ-1; Thu, 20 Jun 2024 05:00:48 -0400
X-MC-Unique: nA0gGWbzOdyYz3tKGJhFVQ-1
Received: by mail-wm1-f70.google.com with SMTP id 5b1f17b1804b1-423034c6119so4738535e9.2
        for <kvm@vger.kernel.org>; Thu, 20 Jun 2024 02:00:48 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1718874047; x=1719478847;
        h=content-transfer-encoding:in-reply-to:organization:autocrypt
         :content-language:from:references:cc:to:subject:user-agent
         :mime-version:date:message-id:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=9X/I36k5SWaheNfC/42dOzlw6jEc4rfuDMkNMoqwybI=;
        b=KUATO58JAVuXa0eu/OIypAj7B/lJL/fMTFsV6jNJjJsz3S56kI6H/Jgq49EN63ggZD
         ZWmCtBkrJxFMeLreu+x52SQfonvx61ZI0au9QVWRkv1cQexx2e2kG4KCBCC643gq2b6P
         E/FylSIsqcODCK02U6hnDosRKUAlKBNuDkOTl+yAdWTn5FlWZp204Q4U9O4JLm1rN627
         E56TpZlty7oj2C/70JmbPSpAYGPagAmxMvjAFG1fT5jJ3WFhJiEe7qqjLHQPsi1o9vo5
         Obcu2fTysjlpFYL/NWwR78K2E9Bf7F7BoIdiPwXFtBAYqpq8g3rMvjGBX8wF5F87ROEy
         L4nw==
X-Forwarded-Encrypted: i=1; AJvYcCXS9J7Q51oeL2YcsosG+ooMaoYZsaFwyW3aR6ba2gWhgi828PZDB/NxvNmkY847emLvVkdkbS20JDuX7gQMgkvJYUU9
X-Gm-Message-State: AOJu0YyWsYQ5vrIn++F7SRbvLT9H02LI3rRmU1wQSJCNhTRa6SQjJRGc
	tS3TOXC6T6IJPqZAY8TjZRc7Vw/AOH634UYyp1oIuVdKndtB2QHBhfkjIHPYJKjUMooLgxXdmyO
	0wddZ0KoVHxHUhAhkzDZast+hH+6w4ek/TfGYav7DBydw4J/Z/Q==
X-Received: by 2002:a05:600c:2252:b0:424:798a:f7f2 with SMTP id 5b1f17b1804b1-424798afd71mr26045185e9.3.1718874047394;
        Thu, 20 Jun 2024 02:00:47 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHG3895woTA6InJys+Ae/6783ZPh2VzIdoDlDRU2iq840wYkAZ9w8f8sci8YmejvT5y7gagHA==
X-Received: by 2002:a05:600c:2252:b0:424:798a:f7f2 with SMTP id 5b1f17b1804b1-424798afd71mr26044825e9.3.1718874046959;
        Thu, 20 Jun 2024 02:00:46 -0700 (PDT)
Received: from ?IPV6:2003:cb:c719:5b00:61af:900f:3aef:3af3? (p200300cbc7195b0061af900f3aef3af3.dip0.t-ipconnect.de. [2003:cb:c719:5b00:61af:900f:3aef:3af3])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4247d208e08sm17944335e9.35.2024.06.20.02.00.45
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 20 Jun 2024 02:00:46 -0700 (PDT)
Message-ID: <26aa1ad6-fcdd-4fe2-b763-6938555f93db@redhat.com>
Date: Thu, 20 Jun 2024 11:00:45 +0200
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH RFC 0/5] mm/gup: Introduce exclusive GUP pinning
To: Fuad Tabba <tabba@google.com>
Cc: John Hubbard <jhubbard@nvidia.com>,
 Elliot Berman <quic_eberman@quicinc.com>,
 Andrew Morton <akpm@linux-foundation.org>, Shuah Khan <shuah@kernel.org>,
 Matthew Wilcox <willy@infradead.org>, maz@kernel.org, kvm@vger.kernel.org,
 linux-arm-msm@vger.kernel.org, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org,
 pbonzini@redhat.com, Jason Gunthorpe <jgg@nvidia.com>
References: <20240618-exclusive-gup-v1-0-30472a19c5d1@quicinc.com>
 <7fb8cc2c-916a-43e1-9edf-23ed35e42f51@nvidia.com>
 <14bd145a-039f-4fb9-8598-384d6a051737@redhat.com>
 <CA+EHjTxWWEHfjZ9LJqZy+VCk43qd3SMKiPF7uvAwmDdPeVhrvQ@mail.gmail.com>
 <489d1494-626c-40d9-89ec-4afc4cd0624b@redhat.com>
 <CA+EHjTzuqd5PYdZzAGWTjH+EyhomCeGSaFvDjgZfU7GUAWqu9A@mail.gmail.com>
From: David Hildenbrand <david@redhat.com>
Content-Language: en-US
Autocrypt: addr=david@redhat.com; keydata=
 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
 WNyWQQ==
Organization: Red Hat
In-Reply-To: <CA+EHjTzuqd5PYdZzAGWTjH+EyhomCeGSaFvDjgZfU7GUAWqu9A@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

>> Yes, and I think we might have to revive that discussion, unfortunately.
>> I started thinking about this, but did not reach a conclusion. Sharing
>> my thoughts.
>>
>> The minimum we might need to make use of guest_memfd (v1 or v2 ;) ) not
>> just for private memory should be:
>>
>> (1) Have private + shared parts backed by guest_memfd. Either the same,
>>       or a fd pair.
>> (2) Allow to mmap only the "shared" parts.
>> (3) Allow in-place conversion between "shared" and "private" parts.
> 
> These three were covered (modulo bugs) in the guest_memfd() RFC I'd
> sent a while back:
> 
> https://lore.kernel.org/all/20240222161047.402609-1-tabba@google.com/

I remember there was a catch to it (either around mmap or pinning 
detection -- or around support for huge pages in the future; maybe these 
count as BUGs :) ).

I should probably go back and revisit the whole thing, I was only CCed 
on some part of it back then.

> 
>> (4) Allow migration of the "shared" parts.
> 
> We would really like that too, if they allow us :)
> 
>> A) Convert shared -> private?
>> * Must not be GUP-pinned
>> * Must not be mapped
>> * Must not reside on ZONE_MOVABLE/MIGRATE_CMA
>> * (must rule out any other problematic folio references that could
>>      read/write memory, might be feasible for guest_memfd)
>>
>> B) Convert private -> shared?
>> * Nothing to consider
>>
>> C) Map something?
>> * Must not be private
> 
> A,B and C were covered (again, modulo bugs) in the RFC.
> 
>> For ordinary (small) pages, that might be feasible.
>> (ZONE_MOVABLE/MIGRATE_CMA might be feasible, but maybe we could just not
>> support them initially)
>>
>> The real fun begins once we want to support huge pages/large folios and
>> can end up having a mixture of "private" and "shared" per huge page. But
>> really, that's what we want in the end I think.
> 
> I agree.
> 
>> Unless we can teach the VM to not convert arbitrary physical memory
>> ranges on a 4k basis to a mixture of private/shared ... but I've been
>> told we don't want that. Hm.
>>
>>
>> There are two big problems with that that I can see:
>>
>> 1) References/GUP-pins are per folio
>>
>> What if some shared part of the folio is pinned but another shared part
>> that we want to convert to private is not? Core-mm will not provide the
>> answer to that: the folio maybe pinned, that's it. *Disallowing* at
>> least long-term GUP-pins might be an option.
> 
> Right.
> 
>> To get stuff into an IOMMU, maybe a per-fd interface could work, and
>> guest_memfd would track itself which parts are currently "handed out",
>> and with which "semantics" (shared vs. private).
>>
>> [IOMMU + private parts might require that either way? Because, if we
>> dissallow mmap, how should that ever work with an IOMMU otherwise].
> 
> Not sure if IOMMU + private makes that much sense really, but I think
> I might not really understand what you mean by this.

A device might be able to access private memory. In the TDX world, this 
would mean that a device "speaks" encrypted memory.

At the same time, a device might be able to access shared memory. Maybe 
devices can do both?

What do do when converting between private and shared? I think it 
depends on various factors (e.g., device capabilities).

[...]

>> I recall quite some details with memory renting or so on pKVM ... and I
>> have to refresh my memory on that.
> 
> I really would like to get to a place where we could investigate and
> sort out all of these issues. It would be good to know though, what,
> in principle (and not due to any technical limitations), we might be
> allowed to do and expand guest_memfd() to do, and what out of
> principle is off the table.

As Jason said, maybe we need a revised model that can handle
[...] private+shared properly.

-- 
Cheers,

David / dhildenb


