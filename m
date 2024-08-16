Return-Path: <kvm+bounces-24410-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 64691955068
	for <lists+kvm@lfdr.de>; Fri, 16 Aug 2024 19:58:38 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 1C0D9288021
	for <lists+kvm@lfdr.de>; Fri, 16 Aug 2024 17:58:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0E9951C6884;
	Fri, 16 Aug 2024 17:56:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="YBLehahX"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7AA5B1C3789
	for <kvm@vger.kernel.org>; Fri, 16 Aug 2024 17:56:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723831000; cv=none; b=jOlx5gFjEGjnRBFQqr7x/2EMJJW17+G561PVHF3DpzR0hQzDQe606Ew9tG4MxieIy1mjBb7UmPM2JD/4/T6wPw5uOvSDIW5GXbxafYZLfRJiLfbM7lWUSISmNa1HYN2HptC+4Pu7hH6JVOXAGmarETdC9Hd1KBeSnJEKX/toeLc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723831000; c=relaxed/simple;
	bh=HMkVi6pKT+kvi17SssfJO4YaenwoNOGDi2dbv+ikolY=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=msrC+CT4Fc02Yp0/OA9pGowWhxQ8LbxfiRESJPkEYiwQWEr+ofe9HfEzpCuv/3KTnjAXh2/9tIgaP/yV6B2WWFO6FOu2D5HGqHBqaFLWc+R3N7y8xrDRtnYUCpQoMrA4hijO2NtfbLt9Lle7NvJVwNJKzz9/r1T/wYyblx0mZQI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=YBLehahX; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1723830997;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=N887NcL0MqOj2hQysbs1Gth/iAPZml/fUaJ1WOFD+aw=;
	b=YBLehahXcVHgDRmX7EK0RB1iTHGFOkdxLAQmCvP97uOIYYvK3I02sHBoNJlUeltpTGm7Ee
	25TK6u9wsot1te49yKbAsVXWJUvzH23aPUC5v3UU0O0YvxH+B3GbwSzU0bRax3b+qD4Nc6
	Z4fVfUAmQOKqPyXYUCRoReoKS+OoeXs=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-439-fEaMhFcBPDKc7f3TnbajSw-1; Fri, 16 Aug 2024 13:56:34 -0400
X-MC-Unique: fEaMhFcBPDKc7f3TnbajSw-1
Received: by mail-wm1-f71.google.com with SMTP id 5b1f17b1804b1-42820af1106so16111755e9.2
        for <kvm@vger.kernel.org>; Fri, 16 Aug 2024 10:56:34 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1723830993; x=1724435793;
        h=content-transfer-encoding:in-reply-to:organization:autocrypt
         :content-language:from:references:cc:to:subject:user-agent
         :mime-version:date:message-id:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=N887NcL0MqOj2hQysbs1Gth/iAPZml/fUaJ1WOFD+aw=;
        b=BI6H0WzIHmCSKHi8g/KQHv5pdGE1ZDPjgobIlCmVIyNJXPqnltYZL0LwlN8iRP0n54
         CwLLH0WkYbNrst1V6KoIiujTmVdg6t+bl96I2KOfQ3Mxt8AOyjMslISHbauTtQxlLGaF
         QXeCz5wLVM9E80sbbapz7ZO4twKRsQXJd2/AAcwIkAxVTw3pBX7Obi4tQ1n5gQSpJHLI
         FmkwcfNR3BNQ3m6fKzZqQkSQBYbzKOAtpdIIbCl2wMbQxQrKdoum0d7zwFXJ2HUe2NLz
         OS5rSeYPb6CYEScIJtz+Edlol0rEJVg8+zO+myIGRxkXca4h9FVK5bMHnSJrgwOWOf7R
         8HsA==
X-Forwarded-Encrypted: i=1; AJvYcCVzTwjcssSKYhLIIQHgJ5NdbYZBc/dR8jykGNcHUyjqGa+5jQKNAxRzBx7kljx4PXibsCjPnh04wAcgwq/iyAvS2ySi
X-Gm-Message-State: AOJu0YxAmHwp6uLQNlmLwZjBiQjj8eOM5ECkVHqKy7vV0N4U6e1zBQqP
	I3YKO0GpGz4KVeN2cFoAicHLsNFTpCKoUsGnodMR/9A5hgbPUQHD57xIKhjET4PQRKCY3CX5Ysl
	6jCNWOLWooDI1pYohrlcYFS3wol+7hAJVdcCDB80RDtffEp8z+g==
X-Received: by 2002:a05:600c:3b04:b0:429:994:41a2 with SMTP id 5b1f17b1804b1-429ed785b80mr21319015e9.7.1723830993405;
        Fri, 16 Aug 2024 10:56:33 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHD7YlRhLCoJ0q/8oapuwa6a/Pxhf3h8xRE1yVEHeD5piFXRKbP506fq8bpnjsX6vqve4Bqdg==
X-Received: by 2002:a05:600c:3b04:b0:429:994:41a2 with SMTP id 5b1f17b1804b1-429ed785b80mr21318815e9.7.1723830992802;
        Fri, 16 Aug 2024 10:56:32 -0700 (PDT)
Received: from ?IPV6:2003:cb:c721:b900:4f34:b2b7:739d:a650? (p200300cbc721b9004f34b2b7739da650.dip0.t-ipconnect.de. [2003:cb:c721:b900:4f34:b2b7:739d:a650])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-429eea70115sm24015035e9.36.2024.08.16.10.56.31
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 16 Aug 2024 10:56:32 -0700 (PDT)
Message-ID: <d311645d-9677-44ca-9d86-6d37f971082c@redhat.com>
Date: Fri, 16 Aug 2024 19:56:30 +0200
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 06/19] mm/pagewalk: Check pfnmap early for
 folio_walk_start()
To: Peter Xu <peterx@redhat.com>
Cc: Jason Gunthorpe <jgg@nvidia.com>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, Sean Christopherson <seanjc@google.com>,
 Oscar Salvador <osalvador@suse.de>, Axel Rasmussen
 <axelrasmussen@google.com>, linux-arm-kernel@lists.infradead.org,
 x86@kernel.org, Will Deacon <will@kernel.org>, Gavin Shan
 <gshan@redhat.com>, Paolo Bonzini <pbonzini@redhat.com>,
 Zi Yan <ziy@nvidia.com>, Andrew Morton <akpm@linux-foundation.org>,
 Catalin Marinas <catalin.marinas@arm.com>, Ingo Molnar <mingo@redhat.com>,
 Alistair Popple <apopple@nvidia.com>, Borislav Petkov <bp@alien8.de>,
 Thomas Gleixner <tglx@linutronix.de>, kvm@vger.kernel.org,
 Dave Hansen <dave.hansen@linux.intel.com>,
 Alex Williamson <alex.williamson@redhat.com>, Yan Zhao <yan.y.zhao@intel.com>
References: <20240809160909.1023470-1-peterx@redhat.com>
 <20240809160909.1023470-7-peterx@redhat.com>
 <b103edb7-c41b-4a5b-9d9f-9690c5b25eb7@redhat.com> <ZrZJqd8FBLU_GqFH@x1n>
 <d9d1b682-cf3c-4808-ba50-56c75a406dae@redhat.com>
 <20240814130525.GH2032816@nvidia.com>
 <81080764-7c94-463f-80d3-e3b2968ddf5f@redhat.com> <Zr9gXek8ScalQs33@x1n>
From: David Hildenbrand <david@redhat.com>
Content-Language: en-US
Autocrypt: addr=david@redhat.com; keydata=
 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
 WNyWQQ==
Organization: Red Hat
In-Reply-To: <Zr9gXek8ScalQs33@x1n>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 16.08.24 16:21, Peter Xu wrote:
> On Fri, Aug 16, 2024 at 11:30:31AM +0200, David Hildenbrand wrote:
>> On 14.08.24 15:05, Jason Gunthorpe wrote:
>>> On Fri, Aug 09, 2024 at 07:25:36PM +0200, David Hildenbrand wrote:
>>>
>>>>>> That is in general not what we want, and we still have some places that
>>>>>> wrongly hard-code that behavior.
>>>>>>
>>>>>> In a MAP_PRIVATE mapping you might have anon pages that we can happily walk.
>>>>>>
>>>>>> vm_normal_page() / vm_normal_page_pmd() [and as commented as a TODO,
>>>>>> vm_normal_page_pud()] should be able to identify PFN maps and reject them,
>>>>>> no?
>>>>>
>>>>> Yep, I think we can also rely on special bit.
>>>
>>> It is more than just relying on the special bit..
>>>
>>> VM_PFNMAP/VM_MIXEDMAP should really only be used inside
>>> vm_normal_page() because thay are, effectively, support for a limited
>>> emulation of the special bit on arches that don't have them. There are
>>> a bunch of weird rules that are used to try and make that work
>>> properly that have to be followed.
>>>
>>> On arches with the sepcial bit they should possibly never be checked
>>> since the special bit does everything you need.
>>>
>>> Arguably any place reading those flags out side of vm_normal_page/etc
>>> is suspect.
>>
>> IIUC, your opinion matches mine: VM_PFNMAP/VM_MIXEDMAP and pte_special()/...
>> usage should be limited to vm_normal_page/vm_normal_page_pmd/ ... of course,
>> GUP-fast is special (one of the reason for "pte_special()" and friends after
>> all).
> 
> The issue is at least GUP currently doesn't work with pfnmaps, while
> there're potentially users who wants to be able to work on both page +
> !page use cases.  Besides access_process_vm(), KVM also uses similar thing,
> and maybe more; these all seem to be valid use case of reference the vma
> flags for PFNMAP and such, so they can identify "it's pfnmap" or more
> generic issues like "permission check error on pgtable".

What at least VFIO does is first try GUP, and if that fails, try 
follow_fault_pfn()->follow_pte(). There is a VM_PFNMAP check in there, yes.

Ideally, follow_pte() would never return refcounted/normal pages, then 
the PFNMAP check might only be a performance improvement (maybe).

> 
> The whole private mapping thing definitely made it complicated.

Yes, and follow_pte() for now could even return ordinary anon pages. I 
spotted that when I was working on that VM_PAT stuff, but I was to 
unsure what to do (see below that KVM with MAP_PRIVATE /dev/mem might 
just work, no idea if there are use cases?).

Fortunately, vfio calls is_invalid_reserved_pfn() and refuses anything 
that has a struct page.

I think KVM does something nasty: if it something with a "struct page", 
and it's not PageReserved, it would take a reference (if I get 
kvm_pfn_to_refcounted_page()) independent if it's a "normal" or "not 
normal" page -- it essentially ignores the vm_normal_page() information 
in the page tables ...

So anon pages in pivate mappings from follow_pte() might currently work 
with KVM ... because of the way KVM uses follow_pte().

I did not play with it, so I'm not sure if I am missing some detail.

-- 
Cheers,

David / dhildenb


