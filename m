Return-Path: <kvm+bounces-25636-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 75E869676C0
	for <lists+kvm@lfdr.de>; Sun,  1 Sep 2024 15:39:47 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 2E9A528076A
	for <lists+kvm@lfdr.de>; Sun,  1 Sep 2024 13:39:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1D1F417D374;
	Sun,  1 Sep 2024 13:39:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="bCCFAGgJ"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D29B1748A
	for <kvm@vger.kernel.org>; Sun,  1 Sep 2024 13:39:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725197977; cv=none; b=VUJCdsDzggzhGRpqEiW+QtzTZKxKAmbIDe3rmS429XhaegHSGoEJq7dQylJzZLtQvCMUWG0D7Qq+wb0JzfYeurArbXF0Dutg74yeyLS7x/5baeizZaY82ci12AmP9I7BQgmh+/HfAbkunQjqXQqD/Xfn0wrchBWLhG9mkmRShos=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725197977; c=relaxed/simple;
	bh=1IlmAJYxN2gOVSyA2laMPlpZM2nE8GFxfbSDPUCpxAg=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=WuWSviEHH5hqOH/is7hKnizc/w3VFG89PfhedSApb+F2GNnk4G+U+QBgg3yLxtoFlp0GYNnnLoxrz/DJ2mjvIU7MUHiJHF4Y5s1418W452ekoZ/iWHoxqlcF98CJR7qmD4RWWxsBvhMRRtPXFVKVJAj0GCLg4Q+fl4R9Q69Bc1M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=bCCFAGgJ; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1725197973;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=vyGDIwF2j/q+RxX/6PvhOnfgGDLJV1PumKrXufZMqJk=;
	b=bCCFAGgJEonHNydSWRaQ5ta6GfzE0gTgSc3+sjdoN6GssWFgIO9iDYuWM/EbNmla79l4qx
	RlXW/mwAhruWM97KmFQlM+p8uG14iSVmikroKNYEVMd7D4oIJAISUdIsYYoRcDjD7sKSbN
	bh1aXyiILNPbQPFnq9RwdMZXVJeU78M=
Received: from mail-oo1-f72.google.com (mail-oo1-f72.google.com
 [209.85.161.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-591-Sry2kAmDP16CdL-VYFePsA-1; Sun, 01 Sep 2024 09:39:32 -0400
X-MC-Unique: Sry2kAmDP16CdL-VYFePsA-1
Received: by mail-oo1-f72.google.com with SMTP id 006d021491bc7-5dfbaf0bdc2so1721490eaf.3
        for <kvm@vger.kernel.org>; Sun, 01 Sep 2024 06:39:32 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1725197972; x=1725802772;
        h=content-transfer-encoding:in-reply-to:content-language:from
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=vyGDIwF2j/q+RxX/6PvhOnfgGDLJV1PumKrXufZMqJk=;
        b=XKvaw0312O2NqA+8vcwgpFeZ2Vd5pPMirkd8R+FNOZAg7zRJUl4HXVr0y/0ScxASnr
         u8bzcaAEq5hQr4kzq+Hl9oh+vuDTgpDTJSlLVm7gVdTKzKDnPB4yH1bCSCpFXCNqNYO+
         quIAuxAWiDR5igIUMmjCuJ9goKmZ0CutZ60eOvqEHjhiLrTfXSfsEqHgqN3jR+IL2imw
         xCcDqyqsAPz2onnF5MePL/cIYoUP5gDRtTe4bbsL6eJIaIpuypK9wyxP23PdiEeUn6ku
         PkdrQjmHK7r6G4y1eR5VSeSQzabuk7Z3SJ076IMiw+QOTJ7mtAiklcvJOzKQ/tdFUdxI
         XVmA==
X-Forwarded-Encrypted: i=1; AJvYcCVgY4FTiNwktvVEr/+tKRurR+jYiwOSg16S8IavZrTYDoimw/y6s12p5a/OnO+iI4F9iAE=@vger.kernel.org
X-Gm-Message-State: AOJu0YxBfhoonUQquPsafssPNEQ6SWUsmsFBnfJYhJmvtfFLtu2xZfrL
	d5UrxZ7gGu9tI91O3sOgSgIk4N7a/IBdW1CJlCymsHsUhI3iQUPG2L43koAkbKG+svRd1DhmuOE
	sl45YaK99UIoULWikfdu4i6V6hyTnM46ataNC1bRJH0Wp2JHPsQ==
X-Received: by 2002:a05:6358:9385:b0:1b5:a043:8f43 with SMTP id e5c5f4694b2df-1b603a26699mr1468280055d.0.1725197971951;
        Sun, 01 Sep 2024 06:39:31 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEDmQzg0ZPiJwjrC5T+Ay+drE71+FKdZDRY3ijuZM6RzcnlHFemGD4aRZKF9+h5bY5YpETJsQ==
X-Received: by 2002:a05:6358:9385:b0:1b5:a043:8f43 with SMTP id e5c5f4694b2df-1b603a26699mr1468276255d.0.1725197971407;
        Sun, 01 Sep 2024 06:39:31 -0700 (PDT)
Received: from ?IPV6:2003:cb:c720:6600:be4f:7c7a:2bbd:4720? (p200300cbc7206600be4f7c7a2bbd4720.dip0.t-ipconnect.de. [2003:cb:c720:6600:be4f:7c7a:2bbd:4720])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-6c353173c45sm20426886d6.92.2024.09.01.06.39.27
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 01 Sep 2024 06:39:31 -0700 (PDT)
Message-ID: <8c70fc0d-901c-4a57-8bbd-0a7f8d895f7e@redhat.com>
Date: Sun, 1 Sep 2024 15:39:21 +0200
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 16/19] mm: Remove follow_pte()
To: Yu Zhao <yuzhao@google.com>, Peter Xu <peterx@redhat.com>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
 Gavin Shan <gshan@redhat.com>, Catalin Marinas <catalin.marinas@arm.com>,
 x86@kernel.org, Ingo Molnar <mingo@redhat.com>,
 Andrew Morton <akpm@linux-foundation.org>,
 Paolo Bonzini <pbonzini@redhat.com>,
 Dave Hansen <dave.hansen@linux.intel.com>,
 Thomas Gleixner <tglx@linutronix.de>, Alistair Popple <apopple@nvidia.com>,
 kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
 Sean Christopherson <seanjc@google.com>, Oscar Salvador <osalvador@suse.de>,
 Jason Gunthorpe <jgg@nvidia.com>, Borislav Petkov <bp@alien8.de>,
 Zi Yan <ziy@nvidia.com>, Axel Rasmussen <axelrasmussen@google.com>,
 Yan Zhao <yan.y.zhao@intel.com>, Will Deacon <will@kernel.org>,
 Kefeng Wang <wangkefeng.wang@huawei.com>,
 Alex Williamson <alex.williamson@redhat.com>
References: <20240826204353.2228736-1-peterx@redhat.com>
 <20240826204353.2228736-17-peterx@redhat.com>
 <CAOUHufYfF3BmTZ1r8cdLSU7ddYO20B8M-gFRAn=Hkd=jtQbcng@mail.gmail.com>
From: David Hildenbrand <david@redhat.com>
Content-Language: en-US
In-Reply-To: <CAOUHufYfF3BmTZ1r8cdLSU7ddYO20B8M-gFRAn=Hkd=jtQbcng@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

Am 01.09.24 um 06:33 schrieb Yu Zhao:
> On Mon, Aug 26, 2024 at 2:44 PM Peter Xu <peterx@redhat.com> wrote:
>>
>> follow_pte() users have been converted to follow_pfnmap*().  Remove the
>> API.
>>
>> Signed-off-by: Peter Xu <peterx@redhat.com>
>> ---
>>   include/linux/mm.h |  2 --
>>   mm/memory.c        | 73 ----------------------------------------------
>>   2 files changed, 75 deletions(-)
>>
>> diff --git a/include/linux/mm.h b/include/linux/mm.h
>> index 161d496bfd18..b31d4bdd65ad 100644
>> --- a/include/linux/mm.h
>> +++ b/include/linux/mm.h
>> @@ -2368,8 +2368,6 @@ void free_pgd_range(struct mmu_gather *tlb, unsigned long addr,
>>                  unsigned long end, unsigned long floor, unsigned long ceiling);
>>   int
>>   copy_page_range(struct vm_area_struct *dst_vma, struct vm_area_struct *src_vma);
>> -int follow_pte(struct vm_area_struct *vma, unsigned long address,
>> -              pte_t **ptepp, spinlock_t **ptlp);
>>   int generic_access_phys(struct vm_area_struct *vma, unsigned long addr,
>>                          void *buf, int len, int write);
>>
>> diff --git a/mm/memory.c b/mm/memory.c
>> index b5d07f493d5d..288f81a8698e 100644
>> --- a/mm/memory.c
>> +++ b/mm/memory.c
>> @@ -6100,79 +6100,6 @@ int __pmd_alloc(struct mm_struct *mm, pud_t *pud, unsigned long address)
>>   }
>>   #endif /* __PAGETABLE_PMD_FOLDED */
>>
>> -/**
>> - * follow_pte - look up PTE at a user virtual address
>> - * @vma: the memory mapping
>> - * @address: user virtual address
>> - * @ptepp: location to store found PTE
>> - * @ptlp: location to store the lock for the PTE
>> - *
>> - * On a successful return, the pointer to the PTE is stored in @ptepp;
>> - * the corresponding lock is taken and its location is stored in @ptlp.
>> - *
>> - * The contents of the PTE are only stable until @ptlp is released using
>> - * pte_unmap_unlock(). This function will fail if the PTE is non-present.
>> - * Present PTEs may include PTEs that map refcounted pages, such as
>> - * anonymous folios in COW mappings.
>> - *
>> - * Callers must be careful when relying on PTE content after
>> - * pte_unmap_unlock(). Especially if the PTE maps a refcounted page,
>> - * callers must protect against invalidation with MMU notifiers; otherwise
>> - * access to the PFN at a later point in time can trigger use-after-free.
>> - *
>> - * Only IO mappings and raw PFN mappings are allowed.  The mmap semaphore
>> - * should be taken for read.
>> - *
>> - * This function must not be used to modify PTE content.
>> - *
>> - * Return: zero on success, -ve otherwise.
>> - */
>> -int follow_pte(struct vm_area_struct *vma, unsigned long address,
>> -              pte_t **ptepp, spinlock_t **ptlp)
>> -{
>> -       struct mm_struct *mm = vma->vm_mm;
>> -       pgd_t *pgd;
>> -       p4d_t *p4d;
>> -       pud_t *pud;
>> -       pmd_t *pmd;
>> -       pte_t *ptep;
>> -
>> -       mmap_assert_locked(mm);
>> -       if (unlikely(address < vma->vm_start || address >= vma->vm_end))
>> -               goto out;
>> -
>> -       if (!(vma->vm_flags & (VM_IO | VM_PFNMAP)))
>> -               goto out;
>> -
>> -       pgd = pgd_offset(mm, address);
>> -       if (pgd_none(*pgd) || unlikely(pgd_bad(*pgd)))
>> -               goto out;
>> -
>> -       p4d = p4d_offset(pgd, address);
>> -       if (p4d_none(*p4d) || unlikely(p4d_bad(*p4d)))
>> -               goto out;
>> -
>> -       pud = pud_offset(p4d, address);
>> -       if (pud_none(*pud) || unlikely(pud_bad(*pud)))
>> -               goto out;
>> -
>> -       pmd = pmd_offset(pud, address);
>> -       VM_BUG_ON(pmd_trans_huge(*pmd));
>> -
>> -       ptep = pte_offset_map_lock(mm, pmd, address, ptlp);
>> -       if (!ptep)
>> -               goto out;
>> -       if (!pte_present(ptep_get(ptep)))
>> -               goto unlock;
>> -       *ptepp = ptep;
>> -       return 0;
>> -unlock:
>> -       pte_unmap_unlock(ptep, *ptlp);
>> -out:
>> -       return -EINVAL;
>> -}
>> -EXPORT_SYMBOL_GPL(follow_pte);
> 
> I ran into build errors with this -- removing exported symbols breaks
> ABI, so I think we should make follow_pte() as a wrapper of its new
> equivalent, if that's possible?

Build error with OOT modules or in-tree modules?

If you are talking about OOT modules, it is their responsibility to fix this up 
in their implementation. There are no real kabi stability guarantees provided by 
the kernel.

If you are talking about in-tree modules, did Peter miss some (probably in -next?)?

-- 
Thanks,

David / dhildenb


