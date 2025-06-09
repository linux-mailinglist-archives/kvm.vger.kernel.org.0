Return-Path: <kvm+bounces-48730-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id B1721AD1A46
	for <lists+kvm@lfdr.de>; Mon,  9 Jun 2025 11:07:00 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 9AB713A78AD
	for <lists+kvm@lfdr.de>; Mon,  9 Jun 2025 09:06:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5199124DD09;
	Mon,  9 Jun 2025 09:06:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="X1V5WHWA"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 124261EF092
	for <kvm@vger.kernel.org>; Mon,  9 Jun 2025 09:06:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749460012; cv=none; b=inudExoPpwIDnSb9XUaqhBlVl2zl4B2a2/1scWlCi6EUUJhwaUn6UxnMzZciNZSO9y0QVVsU3KzRkbamqmMPgg6ZlMC1RfiIUMeesBnW/Kadtby8L9BJhHG4ByGLwTLJn3/i3nR1XfZFq1x0YbndXzqnowaqVc3Iw0YRle1QPYs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749460012; c=relaxed/simple;
	bh=M4cXpZ2Wr6E3SWaPSRYtog3F0WkfKTFjCP1vUA3TrVw=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=VhiV4Vxr2C6fhu7b3laWNyx/N8tor8MrERUghJTQUzVn/KGAoAWbZPDv0FeokPQwDu8pFPKSzNoP283L0U/l0vaN4Nla83oGk3a0V6hP8gVzmc+KAKWZzhvqIGLQQsMIuHMHw/agZoNX0DDr7tLNLwyveQ7wcXTut4+ZUJniqtk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=X1V5WHWA; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1749460004;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=MEEHwqpkGXwZV2216XAk2Y9KxNh7e2DRzC+1fZlQs/w=;
	b=X1V5WHWAHQgyu6pHmwIe+7kdIqEtJnLWPmDF/l7jeyhmmrCJjCrxVoPvC0lWpJBwI3sr4h
	6H8pT8IGFXzpkE+uJ2EgM4WK4T2NUOhp1l1RjVxwUaPbgAYQddijCwwgOjlWbFLbY3+NZw
	g0YdaDqqgxDjgIWxh+W1IPfflSPaBHA=
Received: from mail-pf1-f197.google.com (mail-pf1-f197.google.com
 [209.85.210.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-589-ZSkRxmVzMSiX_Uzrot4txw-1; Mon, 09 Jun 2025 05:06:37 -0400
X-MC-Unique: ZSkRxmVzMSiX_Uzrot4txw-1
X-Mimecast-MFC-AGG-ID: ZSkRxmVzMSiX_Uzrot4txw_1749459997
Received: by mail-pf1-f197.google.com with SMTP id d2e1a72fcca58-747d29e90b4so3104077b3a.0
        for <kvm@vger.kernel.org>; Mon, 09 Jun 2025 02:06:37 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1749459995; x=1750064795;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=MEEHwqpkGXwZV2216XAk2Y9KxNh7e2DRzC+1fZlQs/w=;
        b=dhpQET+9+PPazNuBV0e/wjMEbZaJ2dnvAc+3wpxlp4B7HG2h8OKxnKPB6+dUq8Q/mt
         zjqwWLD6Up9oRQD1X1a4Df+BXNQis2Sn1IyNWAzdTs3fB75yc6i9qcWmCfgytf8KRmQY
         eUFL/FRHtLJVqaZFO9BpOiZwONPmtvb7/2lYPTeRru9kjFDXAPCdEdzHayajFoTITfHp
         R3DGsCcTmPVdrbX4IGC7OdzEneUl/SzBsyolZ36gCMCIANeb+v8/3Pxq/CDNue4pWQ9d
         tq4SKVkeOMMkMplpW3SC5Fm5QBvOIzptltuK/4xw6fUp9RzDD97VruoUOYiCKTiBaQCB
         LbhQ==
X-Gm-Message-State: AOJu0Yz/5XsQtsblM/O/+Qo3zmYMY/odJMC8XCmyxFs9bblAmXZKUUIu
	Lhb8Xf9Gif76OmK4/uyCuTQE6Si6mBvA3IHtVmhN3AppIpNh0Bwy2C5DXmCbFB85PRSqagX36hQ
	cgCDVmLPVEZKTWNID8NpE/tpRyuYiC/JoVuceYRme+iMGL9OElux5nA==
X-Gm-Gg: ASbGncsHst1XX/MVqq2M1rjK2f+bGCIGSzKU+Qlc1SElnBAUhtQBbu93xYx6ssPoch9
	zW2tKccPKDW/yOWOZ8pngVAWOMaeD9hxoLxytucudlq7z9phceL+C9846jf7fjNvN0pw28mjezM
	Q1AcCvcgZ+wC7rpAFZJRugkr7UlNUJEmSWdkPU8tpHoV30S7ls5Q4nl5xXWj1FsRG/05cFDOrS0
	VUQO9JALqLAWJ3eequ1MX9EK2hOOtxBvm1yPH6M+Y4QoY3qTzBtdZfi7QOXhF8UPxOJBLwk7AHL
	EyI3xnl82snYEAJJYARfKZOWsnTVhH/aPH47Uu45LB4Ho9OAC+dHYwCeWDatwA==
X-Received: by 2002:a05:6a00:855:b0:736:5c8e:baaa with SMTP id d2e1a72fcca58-74827e52592mr16210619b3a.2.1749459994975;
        Mon, 09 Jun 2025 02:06:34 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFKGPBkTgOwJbD6LOShmxspDJzxpRw6rpArgiEpKcpdDBfYG0pvKVKOm0Fv+3YXAjw3oq1wkw==
X-Received: by 2002:a05:6a00:855:b0:736:5c8e:baaa with SMTP id d2e1a72fcca58-74827e52592mr16210573b3a.2.1749459994498;
        Mon, 09 Jun 2025 02:06:34 -0700 (PDT)
Received: from [192.168.68.51] (n175-34-62-5.mrk21.qld.optusnet.com.au. [175.34.62.5])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-7482af7b606sm5481711b3a.67.2025.06.09.02.06.15
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 09 Jun 2025 02:06:33 -0700 (PDT)
Message-ID: <b3607092-df66-471b-b736-142ab65d35b2@redhat.com>
Date: Mon, 9 Jun 2025 19:06:13 +1000
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v11 14/18] KVM: arm64: Handle guest_memfd-backed guest
 page faults
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
 <20250605153800.557144-15-tabba@google.com>
 <3d9a15ff-fbb2-4e9a-b97b-c0e40eb23043@redhat.com>
 <CA+EHjTzSWbw=Vrc+_4rEs_QsQ=6w44H4pGrJPtZeY8n=s4qZRw@mail.gmail.com>
Content-Language: en-US
From: Gavin Shan <gshan@redhat.com>
In-Reply-To: <CA+EHjTzSWbw=Vrc+_4rEs_QsQ=6w44H4pGrJPtZeY8n=s4qZRw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

Hi Fuad,

On 6/9/25 5:04 PM, Fuad Tabba wrote: 
> On Mon, 9 Jun 2025 at 05:08, Gavin Shan <gshan@redhat.com> wrote:
>>
>> On 6/6/25 1:37 AM, Fuad Tabba wrote:
>>> Add arm64 support for handling guest page faults on guest_memfd backed
>>> memslots. Until guest_memfd supports huge pages, the fault granule is
>>> restricted to PAGE_SIZE.
>>>
>>> Signed-off-by: Fuad Tabba <tabba@google.com>
>>> ---
>>>    arch/arm64/kvm/mmu.c | 93 ++++++++++++++++++++++++++++++++++++++++++--
>>>    1 file changed, 90 insertions(+), 3 deletions(-)
>>>
>>
>> One comment below. Otherwise, it looks good to me.
>>
>> Reviewed-by: Gavin Shan <gshan@redhat.com>
>>
>>> diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
>>> index ce80be116a30..f14925fe6144 100644
>>> --- a/arch/arm64/kvm/mmu.c
>>> +++ b/arch/arm64/kvm/mmu.c
>>> @@ -1508,6 +1508,89 @@ static void adjust_nested_fault_perms(struct kvm_s2_trans *nested,
>>>        *prot |= kvm_encode_nested_level(nested);
>>>    }
>>>
>>> +#define KVM_PGTABLE_WALK_MEMABORT_FLAGS (KVM_PGTABLE_WALK_HANDLE_FAULT | KVM_PGTABLE_WALK_SHARED)
>>> +
>>> +static int gmem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
>>> +                   struct kvm_s2_trans *nested,
>>> +                   struct kvm_memory_slot *memslot, bool is_perm)
>>> +{
>>> +     bool logging, write_fault, exec_fault, writable;
>>> +     enum kvm_pgtable_walk_flags flags = KVM_PGTABLE_WALK_MEMABORT_FLAGS;
>>> +     enum kvm_pgtable_prot prot = KVM_PGTABLE_PROT_R;
>>> +     struct kvm_pgtable *pgt = vcpu->arch.hw_mmu->pgt;
>>> +     struct page *page;
>>> +     struct kvm *kvm = vcpu->kvm;
>>> +     void *memcache;
>>> +     kvm_pfn_t pfn;
>>> +     gfn_t gfn;
>>> +     int ret;
>>> +
>>> +     ret = prepare_mmu_memcache(vcpu, !is_perm, &memcache);
>>> +     if (ret)
>>> +             return ret;
>>> +
>>> +     if (nested)
>>> +             gfn = kvm_s2_trans_output(nested) >> PAGE_SHIFT;
>>> +     else
>>> +             gfn = fault_ipa >> PAGE_SHIFT;
>>> +
>>> +     logging = memslot_is_logging(memslot);
>>> +     write_fault = kvm_is_write_fault(vcpu);
>>> +     exec_fault = kvm_vcpu_trap_is_exec_fault(vcpu);
>>> +
>>> +     if (write_fault && exec_fault) {
>>> +             kvm_err("Simultaneous write and execution fault\n");
>>> +             return -EFAULT;
>>> +     }
>>> +
>>> +     if (is_perm && !write_fault && !exec_fault) {
>>> +             kvm_err("Unexpected L2 read permission error\n");
>>> +             return -EFAULT;
>>> +     }
>>> +
>>> +     ret = kvm_gmem_get_pfn(kvm, memslot, gfn, &pfn, &page, NULL);
>>> +     if (ret) {
>>> +             kvm_prepare_memory_fault_exit(vcpu, fault_ipa, PAGE_SIZE,
>>> +                                           write_fault, exec_fault, false);
>>> +             return ret;
>>> +     }
>>> +
>>
>> -EFAULT or -EHWPOISON shall be returned, as documented in virt/kvm/api.rst. Besides,
>> kvm_send_hwpoison_signal() should be executed when -EHWPOISON is returned from
>> kvm_gmem_get_pfn()? :-)
> 
> This is a bit different since we don't have a VMA. Refer to the discussion here:
> 
> https://lore.kernel.org/all/20250514212653.1011484-1-jthoughton@google.com/
> 

Thanks for the pointer. You're right that we don't have VMA here. To return the
'ret' to userspace seems the practical way to have here.

Thanks,
Gavin

>>
>>> +     writable = !(memslot->flags & KVM_MEM_READONLY) &&
>>> +                (!logging || write_fault);
>>> +
>>> +     if (nested)
>>> +             adjust_nested_fault_perms(nested, &prot, &writable);
>>> +
>>> +     if (writable)
>>> +             prot |= KVM_PGTABLE_PROT_W;
>>> +
>>> +     if (exec_fault ||
>>> +         (cpus_have_final_cap(ARM64_HAS_CACHE_DIC) &&
>>> +          (!nested || kvm_s2_trans_executable(nested))))
>>> +             prot |= KVM_PGTABLE_PROT_X;
>>> +
>>> +     kvm_fault_lock(kvm);
>>> +     if (is_perm) {
>>> +             /*
>>> +              * Drop the SW bits in favour of those stored in the
>>> +              * PTE, which will be preserved.
>>> +              */
>>> +             prot &= ~KVM_NV_GUEST_MAP_SZ;
>>> +             ret = KVM_PGT_FN(kvm_pgtable_stage2_relax_perms)(pgt, fault_ipa, prot, flags);
>>> +     } else {
>>> +             ret = KVM_PGT_FN(kvm_pgtable_stage2_map)(pgt, fault_ipa, PAGE_SIZE,
>>> +                                          __pfn_to_phys(pfn), prot,
>>> +                                          memcache, flags);
>>> +     }
>>> +     kvm_release_faultin_page(kvm, page, !!ret, writable);
>>> +     kvm_fault_unlock(kvm);
>>> +
>>> +     if (writable && !ret)
>>> +             mark_page_dirty_in_slot(kvm, memslot, gfn);
>>> +
>>> +     return ret != -EAGAIN ? ret : 0;
>>> +}
>>> +
>>>    static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
>>>                          struct kvm_s2_trans *nested,
>>>                          struct kvm_memory_slot *memslot, unsigned long hva,
>>> @@ -1532,7 +1615,7 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
>>>        enum kvm_pgtable_prot prot = KVM_PGTABLE_PROT_R;
>>>        struct kvm_pgtable *pgt;
>>>        struct page *page;
>>> -     enum kvm_pgtable_walk_flags flags = KVM_PGTABLE_WALK_HANDLE_FAULT | KVM_PGTABLE_WALK_SHARED;
>>> +     enum kvm_pgtable_walk_flags flags = KVM_PGTABLE_WALK_MEMABORT_FLAGS;
>>>
>>>        if (fault_is_perm)
>>>                fault_granule = kvm_vcpu_trap_get_perm_fault_granule(vcpu);
>>> @@ -1959,8 +2042,12 @@ int kvm_handle_guest_abort(struct kvm_vcpu *vcpu)
>>>                goto out_unlock;
>>>        }
>>>
>>> -     ret = user_mem_abort(vcpu, fault_ipa, nested, memslot, hva,
>>> -                          esr_fsc_is_permission_fault(esr));
>>> +     if (kvm_slot_has_gmem(memslot))
>>> +             ret = gmem_abort(vcpu, fault_ipa, nested, memslot,
>>> +                              esr_fsc_is_permission_fault(esr));
>>> +     else
>>> +             ret = user_mem_abort(vcpu, fault_ipa, nested, memslot, hva,
>>> +                                  esr_fsc_is_permission_fault(esr));
>>>        if (ret == 0)
>>>                ret = 1;
>>>    out:
>>
> 


