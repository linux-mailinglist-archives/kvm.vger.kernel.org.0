Return-Path: <kvm+bounces-48729-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 4E9F5AD1A3D
	for <lists+kvm@lfdr.de>; Mon,  9 Jun 2025 11:03:59 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id A707E166560
	for <lists+kvm@lfdr.de>; Mon,  9 Jun 2025 09:03:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 28F3A250C07;
	Mon,  9 Jun 2025 09:02:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="VG+yfeS8"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 78B6F38385
	for <kvm@vger.kernel.org>; Mon,  9 Jun 2025 09:02:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749459778; cv=none; b=jnxuq0cJvTrbC9zqgUTfBBBuRi1MgCzdHqU0BX554e9DvIGnhGxeKbJwuEEqPgdajSGy29CBlcmqUy0XQnXn/yLTvcZbW6uDfMhnKnwi6cy+6YEGjwJBn3akPpk2svAyBp8T3wKlE0YlhdtwxqH24qRwawnlOufChBsHhtNEi6c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749459778; c=relaxed/simple;
	bh=hsya1/d6SbXJC5AtuOIjeqVmM1Y8wtOESbAKulWKQS0=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=GMWGXXFEKFJvTIekB9IuQ0uvkpMR+kfkxs1dKs4ISJH1cLcfi5GNUVb0LptLoOaXydfSncGB0IcwgzDkY5QoO3EvzqZyU0kcRVei2i2feWBIQUBlOg53v0KTUpUNEpu6jxkDFbfO1vF0JDRkHL266mG1K0JZE9iCdgRDw4r78n8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=VG+yfeS8; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1749459774;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Q2MrIEEzGhePPG36r/yxjnoCorBMafO55RLCX7Uoxso=;
	b=VG+yfeS8n0sR1w3PaG+xJnznzdCQrtKEpZtBcj/iXCScBvO5wlPVkqqesBjx8TAreBpjH6
	yi/B4A+8s0WMKeZ1JJYmYw7julvW5QPsFC20aOpPB1AJGod4xwq2NffaGadPcLKOLiYARB
	Sz1vdvZNcZt79wFnu8XfkZedgEspuSg=
Received: from mail-pf1-f197.google.com (mail-pf1-f197.google.com
 [209.85.210.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-684-oHrqFMi4PbOxqdzxdd2LIg-1; Mon, 09 Jun 2025 05:02:53 -0400
X-MC-Unique: oHrqFMi4PbOxqdzxdd2LIg-1
X-Mimecast-MFC-AGG-ID: oHrqFMi4PbOxqdzxdd2LIg_1749459772
Received: by mail-pf1-f197.google.com with SMTP id d2e1a72fcca58-742a091d290so2801986b3a.3
        for <kvm@vger.kernel.org>; Mon, 09 Jun 2025 02:02:53 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1749459772; x=1750064572;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Q2MrIEEzGhePPG36r/yxjnoCorBMafO55RLCX7Uoxso=;
        b=wnd4tQS1utabNa4CZNLkxDH148u5YNb9vIuvuc+G1TS1wyvUIvntADF1LWXvu+jG6p
         YDSahcx4W38oUsz+Q7rV/qeK1OdGLrej1xUqVi5Cu5MlmYr5IpQlSprx3SuLR16gnqDt
         CmXvhJYQwAD4jzifkZlWEH9BtHZ6dlVUb+5W9F/p89v1ZnJmLHIi/GVCohvpGK+NNnmZ
         0BRYYupkRebHVIemuX0fsZjDzo8FWB5/uQp4xg1vTroL2avpuNVoGh0PBS0x/tq3XBYF
         HQHhIeNA9NnzyGVFp6DOvvF5oP04Q5hwBm3cCxYFYux1a8Xy8DgWq/V85oTEPnyNI/0c
         ho+A==
X-Gm-Message-State: AOJu0Yx3slLpuhbMc5n2sd//u9QYIwaR9rdsWj4w6zvQ6ikAuIjT/Des
	UzxS7j74WY96iT7efbuUViIbOl73t2jPZhXym4qihPxQIsGKqViRgXbjvUULcUP5N0hfkmXXatW
	HCjtugtFcgnJ/3NaKNUsa5VO3B+alSjBjkbfqQ6u6EkdXDk2LOEPLHA==
X-Gm-Gg: ASbGncvK6lv2x357oJY7IM+MoDq4zBoXy1uXV/178W5ramgdzw++SrH3FL8eqGdJkyb
	5c9XpNJdG57K1o+EjO7kFyNLy2PWj3+K9nJhP69vtE+94usoJX7f4KT3wdYc5r0gq3zRUNxO3nn
	6yTWNO79WAhfBOdvQGsIuuwlzcbELZqByuG/PEorWxWjANGuvq/C9fHpiOxpaYr+2l+8zT0X5C6
	0fubMojYfrAYGBnPu+qh4Fs4WmV+swyd4UE9YDHUW55mQl1lqkqE6jxvKujYu4g1n8qyO2EpyKe
	2XM6MKmIEQrLROASCKWzYsSz+X/8G25Yumvf5GFdrWmk5Ek8hpPmNRDtWjXoHw==
X-Received: by 2002:aa7:88cb:0:b0:73d:fefb:325 with SMTP id d2e1a72fcca58-74827e52272mr13840335b3a.5.1749459771962;
        Mon, 09 Jun 2025 02:02:51 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IE9BfcZFPNQiK0Afi71TcjjNFbyWZ9HvqO0HtNN4+uHwiapdplxXW56T5eZnVVOh7eYx2uDcQ==
X-Received: by 2002:aa7:88cb:0:b0:73d:fefb:325 with SMTP id d2e1a72fcca58-74827e52272mr13840291b3a.5.1749459771414;
        Mon, 09 Jun 2025 02:02:51 -0700 (PDT)
Received: from [192.168.68.51] (n175-34-62-5.mrk21.qld.optusnet.com.au. [175.34.62.5])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-7482b0ea94csm5282712b3a.165.2025.06.09.02.02.31
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 09 Jun 2025 02:02:50 -0700 (PDT)
Message-ID: <7c2bea4b-7a89-4875-ac83-50960f90da8c@redhat.com>
Date: Mon, 9 Jun 2025 19:02:29 +1000
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v11 13/18] KVM: arm64: Refactor user_mem_abort()
To: Fuad Tabba <tabba@google.com>
Cc: kvm@vger.kernel.org, linux-arm-msm@vger.kernel.org, linux-mm@kvack.org,
 kvmarm@lists.linux.dev, pbonzini@redhat.com, chenhuacai@kernel.org,
 mpe@ellerman.id.au, anup@brainfault.org, paul.walmsley@sifive.com,
 palmer@dabbelt.com, aou@eecs.berkeley.edu, seanjc@google.com,
 viro@zeniv.linux.org.uk, brauner@kernel.org, willy@infradead.org,
 akpm@linux-foundation.org, xiaoyao.li@intel.com, yilun.xu@intel.com,
 chao.p.peng@linux.intel.com, jarkko@kernel.org, amoorthy@google.com,
 dmatlack@google.com, isaku.yamahata@intel.com, mic@digikod.net,
 vbabka@suse.cz, vannapurve@google.com, ackerleytng@google.com,
 mail@maciej.szmigiero.name, david@redhat.com, michael.roth@amd.com,
 wei.w.wang@intel.com, liam.merwick@oracle.com, isaku.yamahata@gmail.com,
 kirill.shutemov@linux.intel.com, suzuki.poulose@arm.com,
 steven.price@arm.com, quic_eberman@quicinc.com, quic_mnalajal@quicinc.com,
 quic_tsoni@quicinc.com, quic_svaddagi@quicinc.com,
 quic_cvanscha@quicinc.com, quic_pderrin@quicinc.com,
 quic_pheragu@quicinc.com, catalin.marinas@arm.com, james.morse@arm.com,
 yuzenghui@huawei.com, oliver.upton@linux.dev, maz@kernel.org,
 will@kernel.org, qperret@google.com, keirf@google.com, roypat@amazon.co.uk,
 shuah@kernel.org, hch@infradead.org, jgg@nvidia.com, rientjes@google.com,
 jhubbard@nvidia.com, fvdl@google.com, hughd@google.com,
 jthoughton@google.com, peterx@redhat.com, pankaj.gupta@amd.com,
 ira.weiny@intel.com
References: <20250605153800.557144-1-tabba@google.com>
 <20250605153800.557144-14-tabba@google.com>
 <a4e63374-8b4f-4800-a638-35ff343f78d2@redhat.com>
 <CA+EHjTzYSZSQxh+97SSU7kg+S59CFMisF437wfAxnFRkfgUeFg@mail.gmail.com>
Content-Language: en-US
From: Gavin Shan <gshan@redhat.com>
In-Reply-To: <CA+EHjTzYSZSQxh+97SSU7kg+S59CFMisF437wfAxnFRkfgUeFg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

Hi Fuad,

On 6/9/25 5:01 PM, Fuad Tabba wrote:
> On Mon, 9 Jun 2025 at 01:27, Gavin Shan <gshan@redhat.com> wrote:
>>
>> On 6/6/25 1:37 AM, Fuad Tabba wrote:
>>> To simplify the code and to make the assumptions clearer,
>>> refactor user_mem_abort() by immediately setting force_pte to
>>> true if the conditions are met.
>>>
>>> Remove the comment about logging_active being guaranteed to never be
>>> true for VM_PFNMAP memslots, since it's not actually correct.
>>>
>>> Move code that will be reused in the following patch into separate
>>> functions.
>>>
>>> Other small instances of tidying up.
>>>
>>> No functional change intended.
>>>
>>> Signed-off-by: Fuad Tabba <tabba@google.com>
>>> ---
>>>    arch/arm64/kvm/mmu.c | 100 ++++++++++++++++++++++++-------------------
>>>    1 file changed, 55 insertions(+), 45 deletions(-)
>>>
>>
>> One nitpick below in case v12 is needed. In either way, it looks good to me:
>>
>> Reviewed-by: Gavin Shan <gshan@redhat.com>
>>
>>> diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
>>> index eeda92330ade..ce80be116a30 100644
>>> --- a/arch/arm64/kvm/mmu.c
>>> +++ b/arch/arm64/kvm/mmu.c
>>> @@ -1466,13 +1466,56 @@ static bool kvm_vma_mte_allowed(struct vm_area_struct *vma)
>>>        return vma->vm_flags & VM_MTE_ALLOWED;
>>>    }
>>>
>>> +static int prepare_mmu_memcache(struct kvm_vcpu *vcpu, bool topup_memcache,
>>> +                             void **memcache)
>>> +{
>>> +     int min_pages;
>>> +
>>> +     if (!is_protected_kvm_enabled())
>>> +             *memcache = &vcpu->arch.mmu_page_cache;
>>> +     else
>>> +             *memcache = &vcpu->arch.pkvm_memcache;
>>> +
>>> +     if (!topup_memcache)
>>> +             return 0;
>>> +
>>
>> It's unnecessary to initialize 'memcache' when topup_memcache is false.
> 
> I thought about this before, and I _think_ you're right. However, I
> couldn't completely convince myself that that's always the case for
> the code to be functionally equivalent (looking at the condition for
> kvm_pgtable_stage2_relax_perms() at the end of the function). Which is
> why, if I were to do that, I'd do it as a separate patch.
> 

Thanks for the pointer, which I didn't notice. Yeah, it's something out
of scope and can be fixed up in another separate patch after this series
gets merged. Please leave it as of being and sorry for the noise.

To follow up the discussion, I think it's safe to skip initializing 'memcache'
when 'topup_memcache' is false. The current conditions to turn 'memcache' to
true would have guranteed that kvm_pgtable_stage2_map() will be executed.
It means kvm_pgtable_stage2_relax_perms() will be executed when 'topup_memcache'
is false. Besides, it sounds meaningless to dereference 'vcpu->arch.mmu_page_cache'
or 'vcpu->arch.pkvm_page_cache' without toping up it.

There are comments explaining why 'topup_memcache' is set to true for
permission faults.

         /*
          * Permission faults just need to update the existing leaf entry,
          * and so normally don't require allocations from the memcache. The
          * only exception to this is when dirty logging is enabled at runtime
          * and a write fault needs to collapse a block entry into a table.
          */
         topup_memcache = !fault_is_perm || (logging_active && write_fault);

	if (fault_is_perm && vma_pagesize == fault_granule)
		kvm_pgtable_stage2_relax_perms(...);

> Thanks,
> /fuad
> 

Thanks,
Gavin

>>          if (!topup_memcache)
>>                  return 0;
>>
>>          min_pages = kvm_mmu_cache_min_pages(vcpu->arch.hw_mmu);
>>          if (!is_protected_kvm_enabled())
>>                  *memcache = &vcpu->arch.mmu_page_cache;
>>          else
>>                  *memcache = &vcpu->arch.pkvm_memcache;
>>
>> Thanks,
>> Gavin
>>
>>> +     min_pages = kvm_mmu_cache_min_pages(vcpu->arch.hw_mmu);
>>> +
>>> +     if (!is_protected_kvm_enabled())
>>> +             return kvm_mmu_topup_memory_cache(*memcache, min_pages);
>>> +
>>> +     return topup_hyp_memcache(*memcache, min_pages);
>>> +}
>>> +
>>> +/*
>>> + * Potentially reduce shadow S2 permissions to match the guest's own S2. For
>>> + * exec faults, we'd only reach this point if the guest actually allowed it (see
>>> + * kvm_s2_handle_perm_fault).
>>> + *
>>> + * Also encode the level of the original translation in the SW bits of the leaf
>>> + * entry as a proxy for the span of that translation. This will be retrieved on
>>> + * TLB invalidation from the guest and used to limit the invalidation scope if a
>>> + * TTL hint or a range isn't provided.
>>> + */
>>> +static void adjust_nested_fault_perms(struct kvm_s2_trans *nested,
>>> +                                   enum kvm_pgtable_prot *prot,
>>> +                                   bool *writable)
>>> +{
>>> +     *writable &= kvm_s2_trans_writable(nested);
>>> +     if (!kvm_s2_trans_readable(nested))
>>> +             *prot &= ~KVM_PGTABLE_PROT_R;
>>> +
>>> +     *prot |= kvm_encode_nested_level(nested);
>>> +}
>>> +
>>>    static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
>>>                          struct kvm_s2_trans *nested,
>>>                          struct kvm_memory_slot *memslot, unsigned long hva,
>>>                          bool fault_is_perm)
>>>    {
>>>        int ret = 0;
>>> -     bool write_fault, writable, force_pte = false;
>>> +     bool topup_memcache;
>>> +     bool write_fault, writable;
>>>        bool exec_fault, mte_allowed;
>>>        bool device = false, vfio_allow_any_uc = false;
>>>        unsigned long mmu_seq;
>>> @@ -1484,6 +1527,7 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
>>>        gfn_t gfn;
>>>        kvm_pfn_t pfn;
>>>        bool logging_active = memslot_is_logging(memslot);
>>> +     bool force_pte = logging_active || is_protected_kvm_enabled();
>>>        long vma_pagesize, fault_granule;
>>>        enum kvm_pgtable_prot prot = KVM_PGTABLE_PROT_R;
>>>        struct kvm_pgtable *pgt;
>>> @@ -1501,28 +1545,16 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
>>>                return -EFAULT;
>>>        }
>>>
>>> -     if (!is_protected_kvm_enabled())
>>> -             memcache = &vcpu->arch.mmu_page_cache;
>>> -     else
>>> -             memcache = &vcpu->arch.pkvm_memcache;
>>> -
>>>        /*
>>>         * Permission faults just need to update the existing leaf entry,
>>>         * and so normally don't require allocations from the memcache. The
>>>         * only exception to this is when dirty logging is enabled at runtime
>>>         * and a write fault needs to collapse a block entry into a table.
>>>         */
>>> -     if (!fault_is_perm || (logging_active && write_fault)) {
>>> -             int min_pages = kvm_mmu_cache_min_pages(vcpu->arch.hw_mmu);
>>> -
>>> -             if (!is_protected_kvm_enabled())
>>> -                     ret = kvm_mmu_topup_memory_cache(memcache, min_pages);
>>> -             else
>>> -                     ret = topup_hyp_memcache(memcache, min_pages);
>>> -
>>> -             if (ret)
>>> -                     return ret;
>>> -     }
>>> +     topup_memcache = !fault_is_perm || (logging_active && write_fault);
>>> +     ret = prepare_mmu_memcache(vcpu, topup_memcache, &memcache);
>>> +     if (ret)
>>> +             return ret;
>>>
>>>        /*
>>>         * Let's check if we will get back a huge page backed by hugetlbfs, or
>>> @@ -1536,16 +1568,10 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
>>>                return -EFAULT;
>>>        }
>>>
>>> -     /*
>>> -      * logging_active is guaranteed to never be true for VM_PFNMAP
>>> -      * memslots.
>>> -      */
>>> -     if (logging_active || is_protected_kvm_enabled()) {
>>> -             force_pte = true;
>>> +     if (force_pte)
>>>                vma_shift = PAGE_SHIFT;
>>> -     } else {
>>> +     else
>>>                vma_shift = get_vma_page_shift(vma, hva);
>>> -     }
>>>
>>>        switch (vma_shift) {
>>>    #ifndef __PAGETABLE_PMD_FOLDED
>>> @@ -1597,7 +1623,7 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
>>>                        max_map_size = PAGE_SIZE;
>>>
>>>                force_pte = (max_map_size == PAGE_SIZE);
>>> -             vma_pagesize = min(vma_pagesize, (long)max_map_size);
>>> +             vma_pagesize = min_t(long, vma_pagesize, max_map_size);
>>>        }
>>>
>>>        /*
>>> @@ -1626,7 +1652,7 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
>>>         * Rely on mmap_read_unlock() for an implicit smp_rmb(), which pairs
>>>         * with the smp_wmb() in kvm_mmu_invalidate_end().
>>>         */
>>> -     mmu_seq = vcpu->kvm->mmu_invalidate_seq;
>>> +     mmu_seq = kvm->mmu_invalidate_seq;
>>>        mmap_read_unlock(current->mm);
>>>
>>>        pfn = __kvm_faultin_pfn(memslot, gfn, write_fault ? FOLL_WRITE : 0,
>>> @@ -1661,24 +1687,8 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
>>>        if (exec_fault && device)
>>>                return -ENOEXEC;
>>>
>>> -     /*
>>> -      * Potentially reduce shadow S2 permissions to match the guest's own
>>> -      * S2. For exec faults, we'd only reach this point if the guest
>>> -      * actually allowed it (see kvm_s2_handle_perm_fault).
>>> -      *
>>> -      * Also encode the level of the original translation in the SW bits
>>> -      * of the leaf entry as a proxy for the span of that translation.
>>> -      * This will be retrieved on TLB invalidation from the guest and
>>> -      * used to limit the invalidation scope if a TTL hint or a range
>>> -      * isn't provided.
>>> -      */
>>> -     if (nested) {
>>> -             writable &= kvm_s2_trans_writable(nested);
>>> -             if (!kvm_s2_trans_readable(nested))
>>> -                     prot &= ~KVM_PGTABLE_PROT_R;
>>> -
>>> -             prot |= kvm_encode_nested_level(nested);
>>> -     }
>>> +     if (nested)
>>> +             adjust_nested_fault_perms(nested, &prot, &writable);
>>>
>>>        kvm_fault_lock(kvm);
>>>        pgt = vcpu->arch.hw_mmu->pgt;
>>
> 


