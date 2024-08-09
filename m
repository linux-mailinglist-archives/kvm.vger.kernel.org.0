Return-Path: <kvm+bounces-23742-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 408DB94D5EF
	for <lists+kvm@lfdr.de>; Fri,  9 Aug 2024 20:00:19 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id ACF291F225FD
	for <lists+kvm@lfdr.de>; Fri,  9 Aug 2024 18:00:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 816DF7E76D;
	Fri,  9 Aug 2024 18:00:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="ch4+HOjI"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E1CB774413
	for <kvm@vger.kernel.org>; Fri,  9 Aug 2024 18:00:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723226406; cv=none; b=g0136QzEP5hc1DAbgF+c/H8gG0dDTfsYyLrQxP8tGGnqB0svcmA7Urxcf76KtXS6CcSXWzBcXuEGnRhzfzYMWGa3GX8puSOMVmK1CAFPeYiGEwnZy2W3M6tRbh7MehmqFxIoM1JjLstwo+DW0UVF08ajbArxlgbfFSS0h1/GjQY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723226406; c=relaxed/simple;
	bh=oCvuE7ykKSdNrjtp0MSGG2YO7SOy0k+4f6Y0lgKnYqc=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=J5N/Q9RrHGJw/5322+oXqnm4mRxq8Tm6gfvqrdC/mD26jKQbnTVi4V5nw0qwR0zXPkS8kQDfwzC/wPXBTVk/h/WxQ9W/+23MnOvYmWnlMQWTMZFuo3IaXiTif9MN7L5fDiL2UmAcGxU3XilXgNXbLCVqyZdDKXJkRFKE582TKAg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=ch4+HOjI; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1723226403;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=DX4RN1Et8eu8M9wJHr8iJWlu/fe0EnkKpPUfaVGTg7I=;
	b=ch4+HOjIa8/2VprH4wnL51Hu7E4oVy9vP36HCQbE14AFPdSrjcOP33ZfCoGs78pzZKpf/B
	3Gh8RSTwtUiCufiiiAkCOBR0xSxt/b4+S3qdzi23HkkwXcQ5xDxUUCu1txRz1nF5ZG7dHF
	oDl/sBrRxhT5LFJhCgJxVCp/6eieqf4=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-246-apeDtj5uPVa7ZNODsxvEYA-1; Fri, 09 Aug 2024 14:00:02 -0400
X-MC-Unique: apeDtj5uPVa7ZNODsxvEYA-1
Received: by mail-wm1-f71.google.com with SMTP id 5b1f17b1804b1-4280a39ecebso16320065e9.0
        for <kvm@vger.kernel.org>; Fri, 09 Aug 2024 11:00:02 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1723226401; x=1723831201;
        h=content-transfer-encoding:in-reply-to:organization:autocrypt
         :content-language:from:references:cc:to:subject:user-agent
         :mime-version:date:message-id:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=DX4RN1Et8eu8M9wJHr8iJWlu/fe0EnkKpPUfaVGTg7I=;
        b=gm1DuIlUl3kAZ22wzfS2OEc5UQwAVSpDJBTA7zo1zGxOjfHzc3W9Tux1D9rCx1Cr0x
         ha59gojA2Nan2zG0ZEtvFj1Zm+4Jo7RpjlWq/NJOxq11w08tQ09g8ZQhBKpTFfYz1s82
         vgbwG5ztxwfhASlXXQwq4lrHB0sFnr4AgWYyyimj9xqCWTwqmc6bqODAU0y6VzuBjiuP
         t5euLHomSLhrQ2GSlGC8EOIr7bMK8aJuuM6mWBj7CZSj2gsdr2VRJAH988ftkl7G8pEQ
         25Qsei1Dv6ITJwM0PStZt7XW5MNH3prA1rMIcoFocnqj6guY7HBbqXiezNF63+ftxcPs
         vRsA==
X-Forwarded-Encrypted: i=1; AJvYcCUNXE81mP4yXyXsJ5J09wGEHsnNwVd9maMAGO4RzgHM+ngbpQBaoo/PJAgf7ZQZO7lb3Do=@vger.kernel.org
X-Gm-Message-State: AOJu0YyvNBmXAXmNJdsuD3OaufUfkMZgEX9uxLCXuatbXaI2jPSjzoFl
	ShUQpQBIA4r0+rlQAR7Y/8OImLAlAXwsrlrfiEpvKDUj7kg8gBbjRmn3v0vyW++/CV+M2XKSgV8
	pTvJWw7Y5HgOIJkmgPyizAkJdyIgc60NKeSKshh2fQXcpwdc45fiJ780VxscM
X-Received: by 2002:a05:600c:1d92:b0:426:5e32:4857 with SMTP id 5b1f17b1804b1-429c3a56054mr21757185e9.0.1723226401450;
        Fri, 09 Aug 2024 11:00:01 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IECbfH0ejIYTjOVYWYYJA8AiDUjGL07T0f+A833d33g0qdGRZHggLq4pZxtx0Xz/M05a/t+Ow==
X-Received: by 2002:a05:600c:1d92:b0:426:5e32:4857 with SMTP id 5b1f17b1804b1-429c3a56054mr21756905e9.0.1723226400905;
        Fri, 09 Aug 2024 11:00:00 -0700 (PDT)
Received: from ?IPV6:2003:d8:2f09:3f00:d228:bd67:7baa:d604? (p200300d82f093f00d228bd677baad604.dip0.t-ipconnect.de. [2003:d8:2f09:3f00:d228:bd67:7baa:d604])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-429c74ffb1esm1582035e9.5.2024.08.09.10.59.59
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 09 Aug 2024 11:00:00 -0700 (PDT)
Message-ID: <8ef394e6-a964-41c4-b33c-0e940b6b9bd8@redhat.com>
Date: Fri, 9 Aug 2024 19:59:58 +0200
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 07/19] mm/fork: Accept huge pfnmap entries
To: Peter Xu <peterx@redhat.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 Sean Christopherson <seanjc@google.com>, Oscar Salvador <osalvador@suse.de>,
 Jason Gunthorpe <jgg@nvidia.com>, Axel Rasmussen <axelrasmussen@google.com>,
 linux-arm-kernel@lists.infradead.org, x86@kernel.org,
 Will Deacon <will@kernel.org>, Gavin Shan <gshan@redhat.com>,
 Paolo Bonzini <pbonzini@redhat.com>, Zi Yan <ziy@nvidia.com>,
 Andrew Morton <akpm@linux-foundation.org>,
 Catalin Marinas <catalin.marinas@arm.com>, Ingo Molnar <mingo@redhat.com>,
 Alistair Popple <apopple@nvidia.com>, Borislav Petkov <bp@alien8.de>,
 Thomas Gleixner <tglx@linutronix.de>, kvm@vger.kernel.org,
 Dave Hansen <dave.hansen@linux.intel.com>,
 Alex Williamson <alex.williamson@redhat.com>, Yan Zhao <yan.y.zhao@intel.com>
References: <20240809160909.1023470-1-peterx@redhat.com>
 <20240809160909.1023470-8-peterx@redhat.com>
 <d7fcec73-16f6-4d54-b334-6450a29e0a1d@redhat.com> <ZrZOqbS3bcj52JZP@x1n>
From: David Hildenbrand <david@redhat.com>
Content-Language: en-US
Autocrypt: addr=david@redhat.com; keydata=
 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
 WNyWQQ==
Organization: Red Hat
In-Reply-To: <ZrZOqbS3bcj52JZP@x1n>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 09.08.24 19:15, Peter Xu wrote:
> On Fri, Aug 09, 2024 at 06:32:44PM +0200, David Hildenbrand wrote:
>> On 09.08.24 18:08, Peter Xu wrote:
>>> Teach the fork code to properly copy pfnmaps for pmd/pud levels.  Pud is
>>> much easier, the write bit needs to be persisted though for writable and
>>> shared pud mappings like PFNMAP ones, otherwise a follow up write in either
>>> parent or child process will trigger a write fault.
>>>
>>> Do the same for pmd level.
>>>
>>> Signed-off-by: Peter Xu <peterx@redhat.com>
>>> ---
>>>    mm/huge_memory.c | 27 ++++++++++++++++++++++++---
>>>    1 file changed, 24 insertions(+), 3 deletions(-)
>>>
>>> diff --git a/mm/huge_memory.c b/mm/huge_memory.c
>>> index 6568586b21ab..015c9468eed5 100644
>>> --- a/mm/huge_memory.c
>>> +++ b/mm/huge_memory.c
>>> @@ -1375,6 +1375,22 @@ int copy_huge_pmd(struct mm_struct *dst_mm, struct mm_struct *src_mm,
>>>    	pgtable_t pgtable = NULL;
>>>    	int ret = -ENOMEM;
>>> +	pmd = pmdp_get_lockless(src_pmd);
>>> +	if (unlikely(pmd_special(pmd))) {
>>> +		dst_ptl = pmd_lock(dst_mm, dst_pmd);
>>> +		src_ptl = pmd_lockptr(src_mm, src_pmd);
>>> +		spin_lock_nested(src_ptl, SINGLE_DEPTH_NESTING);
>>> +		/*
>>> +		 * No need to recheck the pmd, it can't change with write
>>> +		 * mmap lock held here.
>>> +		 */
>>> +		if (is_cow_mapping(src_vma->vm_flags) && pmd_write(pmd)) {
>>> +			pmdp_set_wrprotect(src_mm, addr, src_pmd);
>>> +			pmd = pmd_wrprotect(pmd);
>>> +		}
>>> +		goto set_pmd;
>>> +	}
>>> +
>>
>> I strongly assume we should be using using vm_normal_page_pmd() instead of
>> pmd_page() further below. pmd_special() should be mostly limited to GUP-fast
>> and vm_normal_page_pmd().
> 
> One thing to mention that it has this:
> 
> 	if (!vma_is_anonymous(dst_vma))
> 		return 0;

Another obscure thing in this function. It's not the job of 
copy_huge_pmd() to make the decision whether to copy, it's the job of 
vma_needs_copy() in copy_page_range().

And now I have to suspect that uffd-wp is broken with this function, 
because as vma_needs_copy() clearly states, we must copy, and we don't 
do that for PMDs. Ugh.

What a mess, we should just do what we do for PTEs and we will be fine ;)

Also, we call copy_huge_pmd() only if "is_swap_pmd(*src_pmd) || 
pmd_trans_huge(*src_pmd) || pmd_devmap(*src_pmd)"

Would that even be the case with PFNMAP? I suspect that pmd_trans_huge() 
would return "true" for special pfnmap, which is rather "surprising", 
but fortunate for us.

Likely we should be calling copy_huge_pmd() if pmd_leaf() ... cleanup 
for another day.

> 
> So it's only about anonymous below that.  In that case I feel like the
> pmd_page() is benign, and actually good.

Yes, it would likely currently work.

> 
> Though what you're saying here made me notice my above check doesn't seem
> to be necessary, I mean, "(is_cow_mapping(src_vma->vm_flags) &&
> pmd_write(pmd))" can't be true when special bit is set, aka, pfnmaps.. and
> if it's writable for CoW it means it's already an anon.
> 
> I think I can probably drop that line there, perhaps with a
> VM_WARN_ON_ONCE() making sure it won't happen.
> 
>>
>> Again, we should be doing this similar to how we handle PTEs.
>>
>> I'm a bit confused about the "unlikely(!pmd_trans_huge(pmd)" check, below:
>> what else should we have here if it's not a migration entry but a present
>> entry?
> 
> I had a feeling that it was just a safety belt since the 1st day of thp
> when Andrea worked that out, so that it'll work with e.g. file truncation
> races.
> 
> But with current code it looks like it's only anonymous indeed, so looks
> not possible at least from that pov.

Yes, as stated above, likely broken with UFFD-WP ...

I really think we should make this code just behave like it would with 
PTEs, instead of throwing in more "different" handling.

-- 
Cheers,

David / dhildenb


