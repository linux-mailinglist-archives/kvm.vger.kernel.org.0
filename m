Return-Path: <kvm+bounces-23878-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 87E9294F6EA
	for <lists+kvm@lfdr.de>; Mon, 12 Aug 2024 20:50:31 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id CA3D7B2116A
	for <lists+kvm@lfdr.de>; Mon, 12 Aug 2024 18:50:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 01F3618C920;
	Mon, 12 Aug 2024 18:50:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="W4ySE9W1"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8B6FE18953F
	for <kvm@vger.kernel.org>; Mon, 12 Aug 2024 18:50:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723488622; cv=none; b=OUxG1Oq2d3CRjgnS1xj90ijbN1bwd/OQFPy1QkaA9twMjqg3dukdRAxPkeS/d7GMlMz8F+TlSMqD4tD1nVzE0cR77jUsFGi84e8d8h5/0AnBom07wZAvAnBd/90EqbJYwUM1v2wOjMz6tgh91G10DO4RccohBsbfvpKnSkRA8ME=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723488622; c=relaxed/simple;
	bh=UYSKnVroMQDSeji32ngcd/HXvmqbOvFvARM9dsfpxzQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=hMnKgekhIVmSDDbL5XRao2DOU3FUTKg5KoWzF8PZKCb1eVYhu0+BR7sHmtY5b1En3uGMbcHA3JwJfHf3bnzYLJYv0u5d6nlg1bsh7coT/LCtSmijQmcvw/5F97HsNkX7wzufQuse46tnbTYUuLCf74HRvgtzVFnOC5ZOZtimqXQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=W4ySE9W1; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1723488619;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=6EIf98lzYG18+ctG/Z74nuFH8A6VL3NsK2bWXMoSA50=;
	b=W4ySE9W1pbip8UYdOibU0LRdhXyK4J3LHaxb3W3EqhxbXrpNOZsG0irmCic2e04jk0BMFS
	nmn11F5FVCbjzwdCXCUmvS41uE5TikYnSg2knIN4Hedl9JXa2qUYpkfobv4VY50d/IuSlq
	8jk1JBz5XUY46hAaPQTIr4fKrkbC2JU=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-614-ZLW9ltGTO6K52WM5zrBWYg-1; Mon, 12 Aug 2024 14:50:18 -0400
X-MC-Unique: ZLW9ltGTO6K52WM5zrBWYg-1
Received: by mail-wr1-f71.google.com with SMTP id ffacd0b85a97d-367990b4beeso2338984f8f.2
        for <kvm@vger.kernel.org>; Mon, 12 Aug 2024 11:50:17 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1723488617; x=1724093417;
        h=content-transfer-encoding:in-reply-to:organization:autocrypt
         :content-language:from:references:cc:to:subject:user-agent
         :mime-version:date:message-id:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=6EIf98lzYG18+ctG/Z74nuFH8A6VL3NsK2bWXMoSA50=;
        b=nnKelZdiIaN87xlk+ZojEyWPWXNtKtGI6z+zr9V5V3MAsjt+eFpb0/DpWaYDNMbxMR
         xEZFYLPpCfwtaUQfgEYvNufc4cSD/qRC7ct5Xvz/IqPnWaau67Ny4en583XMCucsICyH
         4ky0IcBO+L3Dr1F5i4tbEVITt6M+Vq8YvqpS/cwXmXzaAahbxXxiO7PNzJHtkgeeLWhZ
         K7WmFzwXNFItkQ9EDnyiIana3XtO20mpw2vPaQvlbv4nuHPZ4YJOBc3b+6vmPSoNhvmT
         Iknu58lV2z6r+BnRfaZUIOcClHP4V2IvGv2cDPS45L1TUeK5GWbv3Ww1r2YJI1KxvEql
         8dIQ==
X-Forwarded-Encrypted: i=1; AJvYcCUR0A4fk1jYujvh5y/t4ruqVaB4BPGgzv+A3g0T3M41YmGkVPg+Gyoy9tL8RQYCPZ1zXgTEJreLlsZzqLGV9H1oCO4V
X-Gm-Message-State: AOJu0Yy4AV0pFdx4jbhpBarEPqUuHqYE37Sqydb2vWUk6p80v7w2Hv8k
	SZq5/vZeCrpwrCyoGJU4XWMt8vNkXWNySn4eIY37DNZpqELyo3gDzBzNNr/9ZRLqLQfarddRJyq
	yTOcTZZo3jpvvHjYS9RGZRJj1AZMB0D1WhDVrMCUsk/+RjjRQCA==
X-Received: by 2002:a5d:6e90:0:b0:368:48b1:803 with SMTP id ffacd0b85a97d-3716ccd8db3mr783607f8f.12.1723488616708;
        Mon, 12 Aug 2024 11:50:16 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IF/hZJ+B62cFikFh5hEkl96yNDFQNXVuYBcCbRMsgs1RGeMrxoiw/fNrbEx2z0Cj6z0X13zqg==
X-Received: by 2002:a5d:6e90:0:b0:368:48b1:803 with SMTP id ffacd0b85a97d-3716ccd8db3mr783577f8f.12.1723488616097;
        Mon, 12 Aug 2024 11:50:16 -0700 (PDT)
Received: from ?IPV6:2003:d8:2f09:3f00:d228:bd67:7baa:d604? (p200300d82f093f00d228bd677baad604.dip0.t-ipconnect.de. [2003:d8:2f09:3f00:d228:bd67:7baa:d604])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-36e4e51ec46sm8246641f8f.81.2024.08.12.11.50.13
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 12 Aug 2024 11:50:15 -0700 (PDT)
Message-ID: <9155deaa-b6c5-4e6c-95a7-9a5311b7085a@redhat.com>
Date: Mon, 12 Aug 2024 20:50:12 +0200
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
 <8ef394e6-a964-41c4-b33c-0e940b6b9bd8@redhat.com> <ZrpUm-Lz-plw_fZy@x1n>
From: David Hildenbrand <david@redhat.com>
Content-Language: en-US
Autocrypt: addr=david@redhat.com; keydata=
 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
 WNyWQQ==
Organization: Red Hat
In-Reply-To: <ZrpUm-Lz-plw_fZy@x1n>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 12.08.24 20:29, Peter Xu wrote:
> On Fri, Aug 09, 2024 at 07:59:58PM +0200, David Hildenbrand wrote:
>> On 09.08.24 19:15, Peter Xu wrote:
>>> On Fri, Aug 09, 2024 at 06:32:44PM +0200, David Hildenbrand wrote:
>>>> On 09.08.24 18:08, Peter Xu wrote:
>>>>> Teach the fork code to properly copy pfnmaps for pmd/pud levels.  Pud is
>>>>> much easier, the write bit needs to be persisted though for writable and
>>>>> shared pud mappings like PFNMAP ones, otherwise a follow up write in either
>>>>> parent or child process will trigger a write fault.
>>>>>
>>>>> Do the same for pmd level.
>>>>>
>>>>> Signed-off-by: Peter Xu <peterx@redhat.com>
>>>>> ---
>>>>>     mm/huge_memory.c | 27 ++++++++++++++++++++++++---
>>>>>     1 file changed, 24 insertions(+), 3 deletions(-)
>>>>>
>>>>> diff --git a/mm/huge_memory.c b/mm/huge_memory.c
>>>>> index 6568586b21ab..015c9468eed5 100644
>>>>> --- a/mm/huge_memory.c
>>>>> +++ b/mm/huge_memory.c
>>>>> @@ -1375,6 +1375,22 @@ int copy_huge_pmd(struct mm_struct *dst_mm, struct mm_struct *src_mm,
>>>>>     	pgtable_t pgtable = NULL;
>>>>>     	int ret = -ENOMEM;
>>>>> +	pmd = pmdp_get_lockless(src_pmd);
>>>>> +	if (unlikely(pmd_special(pmd))) {
>>>>> +		dst_ptl = pmd_lock(dst_mm, dst_pmd);
>>>>> +		src_ptl = pmd_lockptr(src_mm, src_pmd);
>>>>> +		spin_lock_nested(src_ptl, SINGLE_DEPTH_NESTING);
>>>>> +		/*
>>>>> +		 * No need to recheck the pmd, it can't change with write
>>>>> +		 * mmap lock held here.
>>>>> +		 */
>>>>> +		if (is_cow_mapping(src_vma->vm_flags) && pmd_write(pmd)) {
>>>>> +			pmdp_set_wrprotect(src_mm, addr, src_pmd);
>>>>> +			pmd = pmd_wrprotect(pmd);
>>>>> +		}
>>>>> +		goto set_pmd;
>>>>> +	}
>>>>> +
>>>>
>>>> I strongly assume we should be using using vm_normal_page_pmd() instead of
>>>> pmd_page() further below. pmd_special() should be mostly limited to GUP-fast
>>>> and vm_normal_page_pmd().
>>>
>>> One thing to mention that it has this:
>>>
>>> 	if (!vma_is_anonymous(dst_vma))
>>> 		return 0;
>>
>> Another obscure thing in this function. It's not the job of copy_huge_pmd()
>> to make the decision whether to copy, it's the job of vma_needs_copy() in
>> copy_page_range().
>>
>> And now I have to suspect that uffd-wp is broken with this function, because
>> as vma_needs_copy() clearly states, we must copy, and we don't do that for
>> PMDs. Ugh.
>>
>> What a mess, we should just do what we do for PTEs and we will be fine ;)
> 
> IIUC it's not a problem: file uffd-wp is different from anonymous, in that
> it pushes everything down to ptes.
> 
> It means if we skipped one huge pmd here for file, then it's destined to
> have nothing to do with uffd-wp, otherwise it should have already been
> split at the first attempt to wr-protect.

Is that also true for UFFD_FEATURE_WP_ASYNC, when we call 
pagemap_scan_thp_entry()->make_uffd_wp_pmd() ?

I'm not immediately finding the code that does the "pushes everything 
down to ptes", so I might miss that part.

> 
>>
>> Also, we call copy_huge_pmd() only if "is_swap_pmd(*src_pmd) ||
>> pmd_trans_huge(*src_pmd) || pmd_devmap(*src_pmd)"
>>
>> Would that even be the case with PFNMAP? I suspect that pmd_trans_huge()
>> would return "true" for special pfnmap, which is rather "surprising", but
>> fortunate for us.
> 
> It's definitely not surprising to me as that's the plan.. and I thought it
> shoulidn't be surprising to you - if you remember before I sent this one, I
> tried to decouple that here with the "thp agnostic" series:
> 
>    https://lore.kernel.org/r/20240717220219.3743374-1-peterx@redhat.com
> 
> in which you reviewed it (which I appreciated).
> 
> So yes, pfnmap on pmd so far will report pmd_trans_huge==true.

I review way to much stuff to remember everything :) That certainly 
screams for a cleanup ...

> 
>>
>> Likely we should be calling copy_huge_pmd() if pmd_leaf() ... cleanup for
>> another day.
> 
> Yes, ultimately it should really be a pmd_leaf(), but since I didn't get
> much feedback there, and that can further postpone this series from being
> posted I'm afraid, then I decided to just move on with "taking pfnmap as
> THPs".  The corresponding change on this path is here in that series:
> 
> https://lore.kernel.org/all/20240717220219.3743374-7-peterx@redhat.com/
> 
> @@ -1235,8 +1235,7 @@ copy_pmd_range(struct vm_area_struct *dst_vma, struct vm_area_struct *src_vma,
>   	src_pmd = pmd_offset(src_pud, addr);
>   	do {
>   		next = pmd_addr_end(addr, end);
> -		if (is_swap_pmd(*src_pmd) || pmd_trans_huge(*src_pmd)
> -			|| pmd_devmap(*src_pmd)) {
> +		if (is_swap_pmd(*src_pmd) || pmd_is_leaf(*src_pmd)) {
>   			int err;
>   			VM_BUG_ON_VMA(next-addr != HPAGE_PMD_SIZE, src_vma);
>   			err = copy_huge_pmd(dst_mm, src_mm, dst_pmd, src_pmd,
> 

Ah, good.

[...]

>> Yes, as stated above, likely broken with UFFD-WP ...
>>
>> I really think we should make this code just behave like it would with PTEs,
>> instead of throwing in more "different" handling.
> 
> So it could simply because file / anon uffd-wp work very differently.

Or because nobody wants to clean up that code ;)

-- 
Cheers,

David / dhildenb


