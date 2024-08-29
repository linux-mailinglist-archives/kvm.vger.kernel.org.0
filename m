Return-Path: <kvm+bounces-25330-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 2761F963BBB
	for <lists+kvm@lfdr.de>; Thu, 29 Aug 2024 08:36:11 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 55CDCB210A7
	for <lists+kvm@lfdr.de>; Thu, 29 Aug 2024 06:36:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 562871598EC;
	Thu, 29 Aug 2024 06:35:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="FDTEIrDC"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BA8F2149C5B
	for <kvm@vger.kernel.org>; Thu, 29 Aug 2024 06:35:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724913358; cv=none; b=dXEykc5PK6dihBbVZcQtAnU4G2JlPFph13b1LSsoHoh8Tm/XWUlJ82Fiyz9tlLaNLlGWvvDTP2/9t9tljS9AFFHkFRRfErJe6loYjkXNtLBEtwCWeKacb7wdNe/H0PA6JAEktDrAlpkiaA9N5xlWFRaGh34UwKq9F0BkWqczHsA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724913358; c=relaxed/simple;
	bh=3C1Pn7P3u8kE5/Xh3nRhBnJPEczNDtMVCQsnQWU/0cs=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=SJgKhR7h+48vQNKXyF96PLXYckClVg/o58l/fcYK7adL4cvNiGuU4ijPEnDUJBBWTJPHT4o4miqfx5yO8vlAr4XexWnFnP1cHOgkH+YpC3klWXAtwZ4Na8Vtqojof1xaXtE5JZ/WUmCDPtFti+xb2xOwnbO3zlCs6vjp6r+B/zU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=FDTEIrDC; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1724913355;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=ARdYw+ULfprbR8rWo2jBMYSOxo9s06JO2wfsOxBjzAI=;
	b=FDTEIrDCBhF0Hfs+As0xgNZ7PiycpF1dOaLha9+aLdQ+gNlnvWdC/OFzpp9t7r2C7Y+7o1
	zqQMj6EGgwYJyBJ0Yn6p/JOzLDknotAu1WNCgCKxVbBV1pQ1PvsG0+h4ZxEhaB0JA66tsb
	hjrWZchKJA47OteBcVBm5fBks2aNPzA=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-444-iFAapVDGPhCA6cqENoRI-g-1; Thu, 29 Aug 2024 02:35:54 -0400
X-MC-Unique: iFAapVDGPhCA6cqENoRI-g-1
Received: by mail-wr1-f72.google.com with SMTP id ffacd0b85a97d-371a1391265so154033f8f.0
        for <kvm@vger.kernel.org>; Wed, 28 Aug 2024 23:35:53 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1724913353; x=1725518153;
        h=content-transfer-encoding:in-reply-to:organization:autocrypt
         :content-language:from:references:cc:to:subject:user-agent
         :mime-version:date:message-id:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=ARdYw+ULfprbR8rWo2jBMYSOxo9s06JO2wfsOxBjzAI=;
        b=WJVgDBLSacGGKTD3BOZKXKwDA/Wdcv1Pe3dCJtfwG6pAEdsD5zQN5rhVENtNn7aHGw
         BgzCTc404YJAc/EF2kbhIb8R2e7S5jCfdOHaaL9LA/nqSluSR8EsNLAjG5nQKA9ERMG3
         5gKbGmiWSenjFdPN2ND9JgYTKkGhwFHeu7+lKqQzRKZtHM0ZAWkljQnofJjW9R0twMJA
         0mL2OII/5H51Q/dNjXye6tkrROw2JOMSju+cQ4OXgatLR3kUyOfzIjTWtP91IhLzMmRN
         0TfhPFQRlJ9HL3SGJojNRhwGyaVFX2kPgA4SI+IAoxf55btnxfqOEyeb1ZEoPVN7R9v2
         Cu1Q==
X-Forwarded-Encrypted: i=1; AJvYcCUD2lI+MmSG+fWuntXO++BrRKRf2aOMklnU2Ojb+pb+2jItN1vFsFggL7uoQyp79l4xCF0=@vger.kernel.org
X-Gm-Message-State: AOJu0YwIaay8CeAONOw9v4Y6/cX6+PGEll6J08lwBukGH/+8ux9ymHMI
	wPy1YwEAKRT79rlvebHqXyiglqKradieyWZ+yHkiylrdx9p/ndy0PqD32Jc5Ns4YWkdR+AYGSua
	16l0BoRxRk8+s5bcqbgZx7HhbbypyaTfx2IhkZvnLLKgjCt5Egg==
X-Received: by 2002:a5d:6dc9:0:b0:36b:aa96:d1e5 with SMTP id ffacd0b85a97d-374a0228f7fmr388985f8f.18.1724913352812;
        Wed, 28 Aug 2024 23:35:52 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IE+BYnHXIYm3/KvEc5f71yqUBdVMg4j3LgSlWxLc6pR3RHwNPaLqwMOSo5yMutRBM4U2UC/rA==
X-Received: by 2002:a5d:6dc9:0:b0:36b:aa96:d1e5 with SMTP id ffacd0b85a97d-374a0228f7fmr388949f8f.18.1724913351919;
        Wed, 28 Aug 2024 23:35:51 -0700 (PDT)
Received: from ?IPV6:2003:cb:c711:c600:c1d6:7158:f946:f083? (p200300cbc711c600c1d67158f946f083.dip0.t-ipconnect.de. [2003:cb:c711:c600:c1d6:7158:f946:f083])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3749efafb30sm581789f8f.94.2024.08.28.23.35.50
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 28 Aug 2024 23:35:51 -0700 (PDT)
Message-ID: <2123f339-2487-4b1c-abb1-313e9a012242@redhat.com>
Date: Thu, 29 Aug 2024 08:35:49 +0200
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 06/19] mm/pagewalk: Check pfnmap for folio_walk_start()
To: Jason Gunthorpe <jgg@nvidia.com>, Peter Xu <peterx@redhat.com>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
 Gavin Shan <gshan@redhat.com>, Catalin Marinas <catalin.marinas@arm.com>,
 x86@kernel.org, Ingo Molnar <mingo@redhat.com>,
 Andrew Morton <akpm@linux-foundation.org>,
 Paolo Bonzini <pbonzini@redhat.com>,
 Dave Hansen <dave.hansen@linux.intel.com>,
 Thomas Gleixner <tglx@linutronix.de>, Alistair Popple <apopple@nvidia.com>,
 kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
 Sean Christopherson <seanjc@google.com>, Oscar Salvador <osalvador@suse.de>,
 Borislav Petkov <bp@alien8.de>, Zi Yan <ziy@nvidia.com>,
 Axel Rasmussen <axelrasmussen@google.com>, Yan Zhao <yan.y.zhao@intel.com>,
 Will Deacon <will@kernel.org>, Kefeng Wang <wangkefeng.wang@huawei.com>,
 Alex Williamson <alex.williamson@redhat.com>
References: <20240826204353.2228736-1-peterx@redhat.com>
 <20240826204353.2228736-7-peterx@redhat.com>
 <9f9d7e96-b135-4830-b528-37418ae7bbfd@redhat.com> <Zs8zBT1aDh1v9Eje@x1n>
 <c1d8220c-e292-48af-bbab-21f4bb9c7dc5@redhat.com> <Zs9-beA-eTuXTfN6@x1n>
 <20240828234652.GD3773488@nvidia.com>
From: David Hildenbrand <david@redhat.com>
Content-Language: en-US
Autocrypt: addr=david@redhat.com; keydata=
 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
 WNyWQQ==
Organization: Red Hat
In-Reply-To: <20240828234652.GD3773488@nvidia.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 29.08.24 01:46, Jason Gunthorpe wrote:
> On Wed, Aug 28, 2024 at 03:45:49PM -0400, Peter Xu wrote:
> 
>> Meanwhile I'm actually not 100% sure pte_special is only needed in
>> gup-fast.  See vm_normal_page() and for VM_PFNMAP when pte_special bit is
>> not defined:
>>
>> 		} else {
>> 			unsigned long off;
>> 			off = (addr - vma->vm_start) >> PAGE_SHIFT;
>> 			if (pfn == vma->vm_pgoff + off) <------------------ [1]
>> 				return NULL;
>> 			if (!is_cow_mapping(vma->vm_flags))
>> 				return NULL;
>> 		}
>>
>> I suspect things can go wrong when there's assumption on vm_pgoff [1].  At
>> least vfio-pci isn't storing vm_pgoff for the base PFN, so this check will
>> go wrong when pte_special is not supported on any arch but when vfio-pci is
>> present.  I suspect more drivers can break it.

Fortunately, we did an excellent job at documenting vm_normal_page():

  * There are 2 broad cases. Firstly, an architecture may define a pte_special()
  * pte bit, in which case this function is trivial. Secondly, an architecture
  * may not have a spare pte bit, which requires a more complicated scheme,
  * described below.
  *
  * A raw VM_PFNMAP mapping (ie. one that is not COWed) is always considered a
  * special mapping (even if there are underlying and valid "struct pages").
  * COWed pages of a VM_PFNMAP are always normal.
  *
  * The way we recognize COWed pages within VM_PFNMAP mappings is through the
  * rules set up by "remap_pfn_range()": the vma will have the VM_PFNMAP bit
  * set, and the vm_pgoff will point to the first PFN mapped: thus every special
  * mapping will always honor the rule
  *
  *	pfn_of_page == vma->vm_pgoff + ((addr - vma->vm_start) >> PAGE_SHIFT)
  *
  * And for normal mappings this is false.
  *

remap_pfn_range_notrack() will currently handle that for us:

if (is_cow_mapping(vma->vm_flags)) {
	if (addr != vma->vm_start || end != vma->vm_end)
		return -EINVAL;
}

Even if [1] would succeed, the is_cow_mapping() check will return NULL and it will
all work as expected, even without pte_special().

Because VM_PFNMAP is easy: in a !COW mapping, everything is special.

> 
> I think that is a very important point.
> 
> IIRC this was done magically in one of the ioremap pfns type calls,
> and if VFIO is using fault instead it won't do it.
> 
> This probably needs more hand holding for the driver somehow..

As long as these drivers don't support COW-mappings. It's all good.

And IIUC, we cannot support COW mappings if we don't use remap_pfn_range().

For this reason, remap_pfn_range() also bails out if not the whole VMA is covered
in a COW mapping.

It would be great if we could detect and fail that. Likely when trying to insert
PFNs (*not* using remap_pfn_range) manually we would have to WARN if we stumble over
a COW mapping.

In the meantime, we should really avoid any new VM_PFNMAP COW users ...

> 
>> So I wonder if it's really the case in real life that only gup-fast would
>> need the special bit.  It could be that we thought it like that, but nobody
>> really seriously tried run it without special bit yet to see things broke.
> 
> Indeed.

VM_PFNMAP for sure works.

VM_MIXEDMAP, I am not so sure. The s390x introduction of pte_special() [again,
I posted the commit] raised why they need it: because pfn_valid() could have
returned non-refcounted pages. One would have to dig if that is even still the
case as of today, and if other architectures have similar constraints.


> 
> What arches even use the whole 'special but not special' system?
> 
> Can we start banning some of this stuff on non-special arches?

Again, VM_PFNMAP is not a problem. Only VM_MIXEDMAP, and I would love to
see that go. There are some, but not that many users ... but I'm afraid it's
not that easy :)

-- 
Cheers,

David / dhildenb


