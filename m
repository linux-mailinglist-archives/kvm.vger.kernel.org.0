Return-Path: <kvm+bounces-13637-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id A83528995EA
	for <lists+kvm@lfdr.de>; Fri,  5 Apr 2024 08:54:05 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 1E3081F2262D
	for <lists+kvm@lfdr.de>; Fri,  5 Apr 2024 06:54:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C8B6F25779;
	Fri,  5 Apr 2024 06:53:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="NjFqhPXC"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4CB3E2421D
	for <kvm@vger.kernel.org>; Fri,  5 Apr 2024 06:53:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712300037; cv=none; b=W0zH3irZOMACd4ruW2NsMCUBW+qNEYSSHTwcb8gbgtLiwrJp+p/RDwT2r2u6DeGvfm8pGrenAAeK12ALDXC+c70qmHDCLBSstmKkAI7f97J5kRQPtgoaa+ZX3SGjeklUCJa4SmAtWQ/ibRQ2gWQE+Ae9NY4UJ4sUUR78VvGkv94=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712300037; c=relaxed/simple;
	bh=a1uI/EpIR4gkdjWK0FYsnrP/u3Er++3KeiVO8G0aeGo=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=AlL9EZo7JBysCQEDPg0yAki3EqE5c9e8PP1AxOd4sh3r1Ynx443qZGhhk1zVoUbE23tb0mOm09vGcMhdrgEbTVSwXw8TzlaQWExDiG355NxRwUUX1fDZmmSPVYQoVmQ6eVsNZ3zTAuB1lgUUvSjVt2LjhmtnpqhhU2xfoEoDcss=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=NjFqhPXC; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1712300034;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=NFXw0uXPa1e5iAn6t3w1lZoilH1G/Z4MsITH9Yy0Mbs=;
	b=NjFqhPXCNCte3FbaP1ql2Ioo5OSloEW1LiLzckfAPcUKQ/7W6Bg/Nz8KjbCjgp4QgTic2d
	4XTDkwtlNb5E9/T4G/3xwZvfY7GDVoyZJTfY54Vob3prwuuhAh85BjMnYqc43vtocjn7Zj
	RfgefEHgLbfkA+0Bxyx3YWC+II08ujk=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-237-DzxMkNRCNSS3MABu7Juvaw-1; Fri, 05 Apr 2024 02:53:52 -0400
X-MC-Unique: DzxMkNRCNSS3MABu7Juvaw-1
Received: by mail-wr1-f71.google.com with SMTP id ffacd0b85a97d-343678d2d26so945419f8f.0
        for <kvm@vger.kernel.org>; Thu, 04 Apr 2024 23:53:52 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1712300031; x=1712904831;
        h=content-transfer-encoding:in-reply-to:organization:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=NFXw0uXPa1e5iAn6t3w1lZoilH1G/Z4MsITH9Yy0Mbs=;
        b=JGKJDvDzyflnkPsfP1rElE38A7YLmOGyq1Zxku6KWchv/qc43FzZyQOHCOijYRwDe2
         8pg5L9tJW66gbSuAbcIFJ55EZ7b6BsPkNQdhqlnUghMq/ltc8GVdfljYqAUUOJTeMd1R
         XTFXqKdgVqFhaNISV62nuTXIuFbtXtv7rbx2IrOg1BPG9aevU8f/dHyJGnPRMite4L6I
         326wXfHwxDPqwY2zz7W3onfSEN5u41ycqJJStY2g7WytA8gbcgfkzS49QKV8ekh+GFO0
         dkJ2kTcQAP/1ybUHn7T3DC9l6/+6I9zke30DiD3tLwkUd0dqMuk4iYB/nMVI17wXX/+K
         HUjg==
X-Forwarded-Encrypted: i=1; AJvYcCUoDx+NybBSIalqqlY73tuwlIG8ESMpDQ1bMXf7Xf32xy/M4KQxHtvavRDviYXz4V2QefISKbFJvK8vU03TV8y0hRtF
X-Gm-Message-State: AOJu0YyfdgGD7Tw/wQxt8PR+sWRjpjszAELa+VBjLVp0teNeUCezPCmF
	klk2WYkuFCnsD1nw8MLcLsHzpN1+467UGWRTuFBf88GzhF6Aw6M7zmiDPzsF9N7bS5BxFVLKWbO
	fCZygFCeWu/EJ8vciN38Gq1REsN5BZe/Km+/VL38XYe1zr5UdRw==
X-Received: by 2002:a5d:4705:0:b0:343:7f4b:6da5 with SMTP id y5-20020a5d4705000000b003437f4b6da5mr1302726wrq.17.1712300031648;
        Thu, 04 Apr 2024 23:53:51 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHKA+Wzecee7dgWIaQilvp9ilBEZVQXBRQGT7EZQL0A6xBeyG1vnI96dUaEWy0OTCLrdlHV2g==
X-Received: by 2002:a5d:4705:0:b0:343:7f4b:6da5 with SMTP id y5-20020a5d4705000000b003437f4b6da5mr1302708wrq.17.1712300031263;
        Thu, 04 Apr 2024 23:53:51 -0700 (PDT)
Received: from ?IPV6:2003:cb:c74b:5500:e1f8:a310:8fa3:4ec1? (p200300cbc74b5500e1f8a3108fa34ec1.dip0.t-ipconnect.de. [2003:cb:c74b:5500:e1f8:a310:8fa3:4ec1])
        by smtp.gmail.com with ESMTPSA id a17-20020a5d5091000000b00341ba91c1f5sm1220508wrt.102.2024.04.04.23.53.50
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 04 Apr 2024 23:53:50 -0700 (PDT)
Message-ID: <36e1592a-e590-48a0-9a79-eeac6b41314b@redhat.com>
Date: Fri, 5 Apr 2024 08:53:49 +0200
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH 0/4] KVM: x86/mmu: Rework marking folios
 dirty/accessed
To: Sean Christopherson <seanjc@google.com>
Cc: David Matlack <dmatlack@google.com>, Paolo Bonzini <pbonzini@redhat.com>,
 kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
 David Stevens <stevensd@chromium.org>, Matthew Wilcox <willy@infradead.org>
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
Content-Language: en-US
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 WNyWQQ==
Organization: Red Hat
In-Reply-To: <Zg8jip0QIBbOCgpz@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 05.04.24 00:02, Sean Christopherson wrote:
> On Thu, Apr 04, 2024, David Hildenbrand wrote:
>> On 04.04.24 19:31, Sean Christopherson wrote:
>>> On Thu, Apr 04, 2024, David Hildenbrand wrote:
>>>> On 04.04.24 00:19, Sean Christopherson wrote:
>>>>> Hmm, we essentially already have an mmu_notifier today, since secondary MMUs need
>>>>> to be invalidated before consuming dirty status.  Isn't the end result essentially
>>>>> a sane FOLL_TOUCH?
>>>>
>>>> Likely. As stated in my first mail, FOLL_TOUCH is a bit of a mess right now.
>>>>
>>>> Having something that makes sure the writable PTE/PMD is dirty (or
>>>> alternatively sets it dirty), paired with MMU notifiers notifying on any
>>>> mkclean would be one option that would leave handling how to handle dirtying
>>>> of folios completely to the core. It would behave just like a CPU writing to
>>>> the page table, which would set the pte dirty.
>>>>
>>>> Of course, if frequent clearing of the dirty PTE/PMD bit would be a problem
>>>> (like we discussed for the accessed bit), that would not be an option. But
>>>> from what I recall, only clearing the PTE/PMD dirty bit is rather rare.
>>>
>>> And AFAICT, all cases already invalidate secondary MMUs anyways, so if anything
>>> it would probably be a net positive, e.g. the notification could more precisely
>>> say that SPTEs need to be read-only, not blasted away completely.
>>
>> As discussed, I think at least madvise_free_pte_range() wouldn't do that.
> 
> I'm getting a bit turned around.  Are you talking about what madvise_free_pte_range()
> would do in this future world, or what madvise_free_pte_range() does today?  Because
> today, unless I'm really misreading the code, secondary MMUs are invalidated before
> the dirty bit is cleared.

Likely I missed it, sorry! I was talking about the possible future. :)

> 
> 	mmu_notifier_range_init(&range, MMU_NOTIFY_CLEAR, 0, mm,
> 				range.start, range.end);
> 
> 	lru_add_drain();
> 	tlb_gather_mmu(&tlb, mm);
> 	update_hiwater_rss(mm);
> 
> 	mmu_notifier_invalidate_range_start(&range);
> 	tlb_start_vma(&tlb, vma);
> 	walk_page_range(vma->vm_mm, range.start, range.end,
> 			&madvise_free_walk_ops, &tlb);
> 	tlb_end_vma(&tlb, vma);
> 	mmu_notifier_invalidate_range_end(&range);
> 

Indeed, we do setup the MMU notifier invalidation. We do the start/end 
... I was looking for PTE notifications.

I spotted the set_pte_at(), not a set_pte_at_notify() like we do in 
other code. Maybe that's not required here (digging through 
documentation I'm still left clueless).

"
set_pte_at_notify() sets the pte _after_ running the notifier. This is 
safe to start by updating the secondary MMUs, because the primary MMU 
pte invalidate must have already happened with a ptep_clear_flush() 
before set_pte_at_notify() has been invoked. ...
"

Absolutely unclear to me when we *must* to use it, or if it is. Likely 
its a pure optimization when we're *changing* a PTE.

KSM and wp_page_copy() uses it with MMU_NOTIFY_CLEAR, when replacing the 
mapped page by another page (or write-protecting an existing one). 
__replace_page() uses it with __replace_page() when replacing the mapped 
page. And migrate_vma_insert_page() uses it with MMU_NOTIFY_MIGRATE.

Other code (e.g., khugepaged) doesn't seem to use it as well.

... so I guess it's fine? Confusing.

-- 
Cheers,

David / dhildenb


