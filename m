Return-Path: <kvm+bounces-53422-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 75735B11497
	for <lists+kvm@lfdr.de>; Fri, 25 Jul 2025 01:34:47 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id AAAEEAC04A9
	for <lists+kvm@lfdr.de>; Thu, 24 Jul 2025 23:34:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8FB6B242D7F;
	Thu, 24 Jul 2025 23:34:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="2pV4kli5"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f201.google.com (mail-pf1-f201.google.com [209.85.210.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F380D2417C3
	for <kvm@vger.kernel.org>; Thu, 24 Jul 2025 23:34:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753400061; cv=none; b=DLyu4AS6zZFgxwbuY3ImiL27nKkTZyPc/U90/5go8q8Pq+fgFTAuIIX3E5a2kgvmFicR3KDgMdOpRI5yrzZtoP8f0J47Vpgz0OJlq9n2hZULVV5//669JRxkHBQHie85AEqHlV3DmhRgZQFvZFzmZzkGQIyTechofEef3K2KJTU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753400061; c=relaxed/simple;
	bh=kd7X7fNbzPYgVA1QUSzA0M2G2ims+Zo46B8ddemqK4c=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=dHD3jhXvEXHVNJ+LmxqlZuYG7WgdPK7q5jzqqcwBVs3eT3lUpxXfSBL4Bg1S3dJdkDgbh8pa1MKpOV8PojcY5/56iOJLzf2L2DcosjkZ2mqlBMKxKrUr1fmo4M2lDaE1zyJYiDyUDDeUzYk8LRU8QNObamBR/j7Nzxhx0mH3Aqg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--ackerleytng.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=2pV4kli5; arc=none smtp.client-ip=209.85.210.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--ackerleytng.bounces.google.com
Received: by mail-pf1-f201.google.com with SMTP id d2e1a72fcca58-74ad608d60aso1411378b3a.1
        for <kvm@vger.kernel.org>; Thu, 24 Jul 2025 16:34:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1753400058; x=1754004858; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=AOC/P/oGXAoRRZqdH8GHzQvdWeyyCWYievctnkwxwC4=;
        b=2pV4kli5A2+WFwh8ImSJvKDV2kC2bYrSXj+q0TEb2e2RZ5SszjWlmlEO+u6nw89rZ6
         V568Cg4zOUP/Ia35P60XK08W8At8dYakhJ72d7cwzSn5B5LDz9OIOZabY5r3eYticUe9
         wz682h3KZCXoQeIPTniysqoMc87pmMh/aBOxBW+0cpwWfS6fS7YuJoZHP4ZS5F4HTMZJ
         l3HMq9e9LApUEflS9NZobVzNrJS9fpuQ2bPZ0gjglot4L4gvAIvUMsndlHli0yMvRxtC
         CPp/XQuF7iGSy6eciHi3ztwbbAKA+WCShaSzCkXliPtmohElkIAsvB5hJssuSwJr45E9
         zHTg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753400058; x=1754004858;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=AOC/P/oGXAoRRZqdH8GHzQvdWeyyCWYievctnkwxwC4=;
        b=hAEgKz20UbPRkJJed66xESh/TXVl3tTkmM05Ru7l35whcJvmK/VkQsNsCbJJR3ve+3
         RnBgiwFmj5HJhCDii5Lkk60N0FfLVNUt/Zdd/xbQ3u1DRlQBxzLFuAkLcTX7sO5N4WV+
         ZhWUVPcZfKrGGPkh5c2vikF68VIrYffaf/M/JI+UErXSOKc9JVOWcqXMQavMJJPLetX6
         deGlUTr7cR1fa0bZMVhy0JBW5VwGup/zjNSHr1o7JfZ/YEvnDb3pJm7EkoWDiK9/WMMe
         VkDN1QCySc8ssYBFLkpcXkLLI8r2bFA0tcZ4sjm2Dsx+c1V6RyL6B/OSebKzGzYPq6L9
         JwHA==
X-Forwarded-Encrypted: i=1; AJvYcCUyfsOTRzuAV9dop1/kUeNJAg4YTWD2ClGg4Fy89HzkRW2DaeJVkGjs3uMP1hUOIah+p3E=@vger.kernel.org
X-Gm-Message-State: AOJu0Yy5j7RI/MUm0dNHAlr1sH48KdNtKKMMlKBM4p44dplaRS6XOMr8
	/AA/9OpTSm6BJTL5U0BwUQIcXqk64EH5a8OJGRBDvrpVYAL2n8k2cuF1sKlxSN8+jo+Tul4oWd1
	0hBQOvKfufLQnlEsayqDftU/EBg==
X-Google-Smtp-Source: AGHT+IHY5fZQ+2KvhBreA+9T2uYUREVCLpgYaImwQk0f+GpHuDd/3+UjiagOjIEkhCM9MDPNsi5LdrO2naMGArQC7A==
X-Received: from pfbfj9.prod.google.com ([2002:a05:6a00:3a09:b0:748:e8fc:e9f0])
 (user=ackerleytng job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6a00:c85:b0:736:51ab:7aed with SMTP id d2e1a72fcca58-760353d0942mr12321101b3a.16.1753400058101;
 Thu, 24 Jul 2025 16:34:18 -0700 (PDT)
Date: Thu, 24 Jul 2025 16:34:16 -0700
In-Reply-To: <diqzcy9pdvkk.fsf@ackerleytng-ctop.c.googlers.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250723104714.1674617-1-tabba@google.com> <20250723104714.1674617-15-tabba@google.com>
 <1ff6a90a-3e03-4104-9833-4b07bb84831f@intel.com> <aIK0ZcTJC96XNPvj@google.com>
 <diqzcy9pdvkk.fsf@ackerleytng-ctop.c.googlers.com>
Message-ID: <diqz7bzxduyv.fsf@ackerleytng-ctop.c.googlers.com>
Subject: Re: [PATCH v16 14/22] KVM: x86/mmu: Enforce guest_memfd's max order
 when recovering hugepages
From: Ackerley Tng <ackerleytng@google.com>
To: Sean Christopherson <seanjc@google.com>, Xiaoyao Li <xiaoyao.li@intel.com>
Cc: Fuad Tabba <tabba@google.com>, kvm@vger.kernel.org, linux-arm-msm@vger.kernel.org, 
	linux-mm@kvack.org, kvmarm@lists.linux.dev, pbonzini@redhat.com, 
	chenhuacai@kernel.org, mpe@ellerman.id.au, anup@brainfault.org, 
	paul.walmsley@sifive.com, palmer@dabbelt.com, aou@eecs.berkeley.edu, 
	viro@zeniv.linux.org.uk, brauner@kernel.org, willy@infradead.org, 
	akpm@linux-foundation.org, yilun.xu@intel.com, chao.p.peng@linux.intel.com, 
	jarkko@kernel.org, amoorthy@google.com, dmatlack@google.com, 
	isaku.yamahata@intel.com, mic@digikod.net, vbabka@suse.cz, 
	vannapurve@google.com, mail@maciej.szmigiero.name, david@redhat.com, 
	michael.roth@amd.com, wei.w.wang@intel.com, liam.merwick@oracle.com, 
	isaku.yamahata@gmail.com, kirill.shutemov@linux.intel.com, 
	suzuki.poulose@arm.com, steven.price@arm.com, quic_eberman@quicinc.com, 
	quic_mnalajal@quicinc.com, quic_tsoni@quicinc.com, quic_svaddagi@quicinc.com, 
	quic_cvanscha@quicinc.com, quic_pderrin@quicinc.com, quic_pheragu@quicinc.com, 
	catalin.marinas@arm.com, james.morse@arm.com, yuzenghui@huawei.com, 
	oliver.upton@linux.dev, maz@kernel.org, will@kernel.org, qperret@google.com, 
	keirf@google.com, roypat@amazon.co.uk, shuah@kernel.org, hch@infradead.org, 
	jgg@nvidia.com, rientjes@google.com, jhubbard@nvidia.com, fvdl@google.com, 
	hughd@google.com, jthoughton@google.com, peterx@redhat.com, 
	pankaj.gupta@amd.com, ira.weiny@intel.com
Content-Type: text/plain; charset="UTF-8"

Ackerley Tng <ackerleytng@google.com> writes:

> Sean Christopherson <seanjc@google.com> writes:
>
>> On Wed, Jul 23, 2025, Xiaoyao Li wrote:
>>> On 7/23/2025 6:47 PM, Fuad Tabba wrote:
>>
>> ...
>>
>>> > +	if (max_level == PG_LEVEL_4K)
>>> > +		return max_level;
>>> > +
>>> > +	return min(max_level,
>>> > +		   kvm_x86_call(gmem_max_mapping_level)(kvm, pfn));
>>> >   }
>>> 
>>> I don't mean to want a next version.
>>> 
>>> But I have to point it out that, the coco_level stuff in the next patch
>>> should be put in this patch actually. Because this patch does the wrong
>>> thing to change from
>>> 
>>> 	req_max_level = kvm_x86_call(gmem_max_mapping_level)(kvm, pfn);
>>> 	if (req_max_level)
>>> 		max_level = min(max_level, req_max_level);
>>> 
>>> to
>>> 
>>> 	return min(max_level,
>>> 		   kvm_x86_call(gmem_max_mapping_level)(kvm, pfn));
>>
>> Gah, nice catch.  Let's do one more version (knock wood).  I have no objection
>> to fixing up my own goof, but the selftest needs to be reworked too, and I think
>> it makes sense for Paolo to grab this directly.  The fewer "things" we need to
>> handoff to Paolo, the better.
>>
>> The fixup will generate a minor conflict, but it's trivial to resolve, and the
>> resting state should end up identical.
>>
>> As fixup:
>>
>> ---
>>  arch/x86/kvm/mmu/mmu.c | 14 +++++++++++---
>>  1 file changed, 11 insertions(+), 3 deletions(-)
>>
>> diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
>> index 6148cc96f7d4..c4ff8b4028df 100644
>> --- a/arch/x86/kvm/mmu/mmu.c
>> +++ b/arch/x86/kvm/mmu/mmu.c
>> @@ -3305,9 +3305,9 @@ static u8 kvm_max_level_for_order(int order)
>>  static u8 kvm_max_private_mapping_level(struct kvm *kvm, struct kvm_page_fault *fault,
>>  					const struct kvm_memory_slot *slot, gfn_t gfn)
>>  {
>> +	u8 max_level, coco_level;
>>  	struct page *page;
>>  	kvm_pfn_t pfn;
>> -	u8 max_level;
>>  
>>  	/* For faults, use the gmem information that was resolved earlier. */
>>  	if (fault) {
>> @@ -3331,8 +3331,16 @@ static u8 kvm_max_private_mapping_level(struct kvm *kvm, struct kvm_page_fault *
>>  	if (max_level == PG_LEVEL_4K)
>>  		return max_level;
>>  
>> -	return min(max_level,
>> -		   kvm_x86_call(gmem_max_mapping_level)(kvm, pfn));
>> +	/*
>> +	 * CoCo may influence the max mapping level, e.g. due to RMP or S-EPT
>> +	 * restrictions.  A return of '0' means "no additional restrictions", to
>> +	 * allow for using an optional "ret0" static call.
>> +	 */
>> +	coco_level = kvm_x86_call(gmem_max_mapping_level)(kvm, pfn);
>> +	if (coco_level)
>> +		max_level = min(max_level, coco_level);
>> +
>> +	return max_level;
>>  }
>>  
>>  int kvm_mmu_max_mapping_level(struct kvm *kvm, struct kvm_page_fault *fault,
>>
>> base-commit: f937c99dad18339773f18411f2a0193b5db8b581
>> -- 
>>
>> Or a full patch:
>>
>> From: Sean Christopherson <seanjc@google.com>
>> Date: Wed, 23 Jul 2025 11:47:06 +0100
>> Subject: [PATCH] KVM: x86/mmu: Enforce guest_memfd's max order when recovering
>>  hugepages
>>
>> Rework kvm_mmu_max_mapping_level() to consult guest_memfd (and relevant)
>> vendor code when recovering hugepages, e.g. after disabling live migration.
>> The flaw has existed since guest_memfd was originally added, but has gone
>> unnoticed due to lack of guest_memfd hugepage support.
>>
>> Get all information on-demand from the memslot and guest_memfd instance,
>> even though KVM could pull the pfn from the SPTE.  However, the max
>> order/level needs to come from guest_memfd, and using kvm_gmem_get_pfn()
>> avoids adding a new gmem API, and avoids having to retrieve the pfn and
>> plumb it into kvm_mmu_max_mapping_level() (the pfn is needed for SNP to
>> consult the RMP).
>>
>> Note, calling kvm_mem_is_private() in the non-fault path is safe, so long
>> as mmu_lock is held, as hugepage recovery operates on shadow-present SPTEs,
>> i.e. calling kvm_mmu_max_mapping_level() with @fault=NULL is mutually
>> exclusive with kvm_vm_set_mem_attributes() changing the PRIVATE attribute
>> of the gfn.
>>
>> Signed-off-by: Sean Christopherson <seanjc@google.com>
>> ---
>>  arch/x86/kvm/mmu/mmu.c          | 91 ++++++++++++++++++++-------------
>>  arch/x86/kvm/mmu/mmu_internal.h |  2 +-
>>  arch/x86/kvm/mmu/tdp_mmu.c      |  2 +-
>>  3 files changed, 58 insertions(+), 37 deletions(-)
>>
>> diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
>> index 20dd9f64156e..c4ff8b4028df 100644
>> --- a/arch/x86/kvm/mmu/mmu.c
>> +++ b/arch/x86/kvm/mmu/mmu.c
>> @@ -3302,31 +3302,63 @@ static u8 kvm_max_level_for_order(int order)
>>  	return PG_LEVEL_4K;
>>  }
>>  
>> -static u8 kvm_max_private_mapping_level(struct kvm *kvm, kvm_pfn_t pfn,
>> -					u8 max_level, int gmem_order)
>> +static u8 kvm_max_private_mapping_level(struct kvm *kvm, struct kvm_page_fault *fault,
>> +					const struct kvm_memory_slot *slot, gfn_t gfn)
>
> Would you consider renaming this kvm_max_gmem_mapping_level()? Or
> something that doesn't limit the use of this function to private memory?
>
>>  {
>> -	u8 req_max_level;
>> +	u8 max_level, coco_level;
>> +	struct page *page;
>> +	kvm_pfn_t pfn;
>>  
>> -	if (max_level == PG_LEVEL_4K)
>> -		return PG_LEVEL_4K;
>> +	/* For faults, use the gmem information that was resolved earlier. */
>> +	if (fault) {
>> +		pfn = fault->pfn;
>> +		max_level = fault->max_level;
>> +	} else {
>> +		/* TODO: Constify the guest_memfd chain. */
>> +		struct kvm_memory_slot *__slot = (struct kvm_memory_slot *)slot;
>> +		int max_order, r;
>> +
>> +		r = kvm_gmem_get_pfn(kvm, __slot, gfn, &pfn, &page, &max_order);
>> +		if (r)
>> +			return PG_LEVEL_4K;
>> +
>> +		if (page)
>> +			put_page(page);
>
> When I was working on this, I added a kvm_gmem_mapping_order() [1] where
> guest_memfd could return the order that this gfn would be allocated at
> without actually doing the allocation. Is it okay that an
> allocation may be performed here?
>
> [1] https://lore.kernel.org/all/20250717162731.446579-13-tabba@google.com/
>
>> +
>> +		max_level = kvm_max_level_for_order(max_order);
>> +	}
>>  
>> -	max_level = min(kvm_max_level_for_order(gmem_order), max_level);
>>  	if (max_level == PG_LEVEL_4K)
>> -		return PG_LEVEL_4K;
>> +		return max_level;
>
> I think the above line is a git-introduced issue, there probably
> shouldn't be a return here.
>

My bad, this is a correct short-circuiting of the rest of the function
since there's no smaller PG_LEVEL than PG_LEVEL_4K.

>>  
>> -	req_max_level = kvm_x86_call(gmem_max_mapping_level)(kvm, pfn);
>> -	if (req_max_level)
>> -		max_level = min(max_level, req_max_level);
>> +	/*
>> +	 * CoCo may influence the max mapping level, e.g. due to RMP or S-EPT
>> +	 * restrictions.  A return of '0' means "no additional restrictions", to
>> +	 * allow for using an optional "ret0" static call.
>> +	 */
>> +	coco_level = kvm_x86_call(gmem_max_mapping_level)(kvm, pfn);
>> +	if (coco_level)
>> +		max_level = min(max_level, coco_level);
>>  
>
> This part makes sense :)
>
>>  	return max_level;
>>  }
>>  
>> -static int __kvm_mmu_max_mapping_level(struct kvm *kvm,
>> -				       const struct kvm_memory_slot *slot,
>> -				       gfn_t gfn, int max_level, bool is_private)
>> +int kvm_mmu_max_mapping_level(struct kvm *kvm, struct kvm_page_fault *fault,
>> +			      const struct kvm_memory_slot *slot, gfn_t gfn)
>>  {
>>  	struct kvm_lpage_info *linfo;
>> -	int host_level;
>> +	int host_level, max_level;
>> +	bool is_private;
>> +
>> +	lockdep_assert_held(&kvm->mmu_lock);
>> +
>> +	if (fault) {
>> +		max_level = fault->max_level;
>> +		is_private = fault->is_private;
>> +	} else {
>> +		max_level = PG_LEVEL_NUM;
>> +		is_private = kvm_mem_is_private(kvm, gfn);
>> +	}
>>  
>>  	max_level = min(max_level, max_huge_page_level);
>>  	for ( ; max_level > PG_LEVEL_4K; max_level--) {
>> @@ -3335,25 +3367,16 @@ static int __kvm_mmu_max_mapping_level(struct kvm *kvm,
>>  			break;
>>  	}
>>  
>> +	if (max_level == PG_LEVEL_4K)
>> +		return PG_LEVEL_4K;
>> +
>>  	if (is_private)
>> -		return max_level;
>> -
>> -	if (max_level == PG_LEVEL_4K)
>> -		return PG_LEVEL_4K;
>> -
>> -	host_level = host_pfn_mapping_level(kvm, gfn, slot);
>> +		host_level = kvm_max_private_mapping_level(kvm, fault, slot, gfn);
>> +	else
>> +		host_level = host_pfn_mapping_level(kvm, gfn, slot);
>>  	return min(host_level, max_level);
>>  }
>>  
>> -int kvm_mmu_max_mapping_level(struct kvm *kvm,
>> -			      const struct kvm_memory_slot *slot, gfn_t gfn)
>> -{
>> -	bool is_private = kvm_slot_has_gmem(slot) &&
>> -			  kvm_mem_is_private(kvm, gfn);
>> -
>> -	return __kvm_mmu_max_mapping_level(kvm, slot, gfn, PG_LEVEL_NUM, is_private);
>> -}
>> -
>>  void kvm_mmu_hugepage_adjust(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault)
>>  {
>>  	struct kvm_memory_slot *slot = fault->slot;
>> @@ -3374,9 +3397,8 @@ void kvm_mmu_hugepage_adjust(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault
>>  	 * Enforce the iTLB multihit workaround after capturing the requested
>>  	 * level, which will be used to do precise, accurate accounting.
>>  	 */
>> -	fault->req_level = __kvm_mmu_max_mapping_level(vcpu->kvm, slot,
>> -						       fault->gfn, fault->max_level,
>> -						       fault->is_private);
>> +	fault->req_level = kvm_mmu_max_mapping_level(vcpu->kvm, fault,
>> +						     fault->slot, fault->gfn);
>>  	if (fault->req_level == PG_LEVEL_4K || fault->huge_page_disallowed)
>>  		return;
>>  
>> @@ -4564,8 +4586,7 @@ static int kvm_mmu_faultin_pfn_private(struct kvm_vcpu *vcpu,
>>  	}
>>  
>>  	fault->map_writable = !(fault->slot->flags & KVM_MEM_READONLY);
>> -	fault->max_level = kvm_max_private_mapping_level(vcpu->kvm, fault->pfn,
>> -							 fault->max_level, max_order);
>> +	fault->max_level = kvm_max_level_for_order(max_order);
>>  
>>  	return RET_PF_CONTINUE;
>>  }
>> @@ -7165,7 +7186,7 @@ static bool kvm_mmu_zap_collapsible_spte(struct kvm *kvm,
>>  		 * mapping if the indirect sp has level = 1.
>>  		 */
>>  		if (sp->role.direct &&
>> -		    sp->role.level < kvm_mmu_max_mapping_level(kvm, slot, sp->gfn)) {
>> +		    sp->role.level < kvm_mmu_max_mapping_level(kvm, NULL, slot, sp->gfn)) {
>>  			kvm_zap_one_rmap_spte(kvm, rmap_head, sptep);
>>  
>>  			if (kvm_available_flush_remote_tlbs_range())
>> diff --git a/arch/x86/kvm/mmu/mmu_internal.h b/arch/x86/kvm/mmu/mmu_internal.h
>> index 65f3c89d7c5d..b776be783a2f 100644
>> --- a/arch/x86/kvm/mmu/mmu_internal.h
>> +++ b/arch/x86/kvm/mmu/mmu_internal.h
>> @@ -411,7 +411,7 @@ static inline int kvm_mmu_do_page_fault(struct kvm_vcpu *vcpu, gpa_t cr2_or_gpa,
>>  	return r;
>>  }
>>  
>> -int kvm_mmu_max_mapping_level(struct kvm *kvm,
>> +int kvm_mmu_max_mapping_level(struct kvm *kvm, struct kvm_page_fault *fault,
>>  			      const struct kvm_memory_slot *slot, gfn_t gfn);
>>  void kvm_mmu_hugepage_adjust(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault);
>>  void disallowed_hugepage_adjust(struct kvm_page_fault *fault, u64 spte, int cur_level);
>> diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
>> index 7f3d7229b2c1..740cb06accdb 100644
>> --- a/arch/x86/kvm/mmu/tdp_mmu.c
>> +++ b/arch/x86/kvm/mmu/tdp_mmu.c
>> @@ -1813,7 +1813,7 @@ static void recover_huge_pages_range(struct kvm *kvm,
>>  		if (iter.gfn < start || iter.gfn >= end)
>>  			continue;
>>  
>> -		max_mapping_level = kvm_mmu_max_mapping_level(kvm, slot, iter.gfn);
>> +		max_mapping_level = kvm_mmu_max_mapping_level(kvm, NULL, slot, iter.gfn);
>>  		if (max_mapping_level < iter.level)
>>  			continue;
>>  
>>
>> base-commit: 84ca709e4f4d54aae3b8d4df74490d8d3d2b1272
>> --

