Return-Path: <kvm+bounces-47328-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 0E6D6AC017C
	for <lists+kvm@lfdr.de>; Thu, 22 May 2025 02:45:20 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id B56574A5A43
	for <lists+kvm@lfdr.de>; Thu, 22 May 2025 00:45:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A05D33FB0E;
	Thu, 22 May 2025 00:45:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="ecD+KmKa"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f202.google.com (mail-pf1-f202.google.com [209.85.210.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3B65D2EB1D
	for <kvm@vger.kernel.org>; Thu, 22 May 2025 00:45:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747874710; cv=none; b=q73vHIQBGN76d1xWPNrTxuolqbA9CigwBNq64i+9sr9Yu6vBe9pvHdeojCavDpmg+tRP6bSZQwy8WRnueUJkyf2z8qZILwbtmpCF/rv5WQSGDb3ihfOEEsREljM9g1cHqDieIwHzgV5Dr1KXh47RxyYn/xMBAxRfL+Wk5fHKifA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747874710; c=relaxed/simple;
	bh=xTdQvmLF9BUR0Av5RPJhplPxUoThUwV0hUhOOBEs99M=;
	h=Date:In-Reply-To:Mime-Version:Message-ID:Subject:From:To:Cc:
	 Content-Type; b=G8g+pNKu0la99tFJDJI/0yu/iyut7ksbpJbvoTcgRIk/2Av4jfB+R6g1D+e+zdpBdXRk7GT648AIVB6JbefWYu65+mWVmchgPsQ3vgbz1ylgzm5J5n4EPGyFV5xjGhLP0exBAUNyhNXMI8ZBdQKo0CN7vGT5TjYm4Me+5m0GIHU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--ackerleytng.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=ecD+KmKa; arc=none smtp.client-ip=209.85.210.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--ackerleytng.bounces.google.com
Received: by mail-pf1-f202.google.com with SMTP id d2e1a72fcca58-742aa6581caso5177228b3a.3
        for <kvm@vger.kernel.org>; Wed, 21 May 2025 17:45:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1747874708; x=1748479508; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:mime-version:in-reply-to:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=e2QytSkDCPpwg2J+zLPrFtZyUnh4IEgPdGfia6szSgs=;
        b=ecD+KmKa4R13iS/JD6TIXj8E91djQS860NBTQXfoFomkEORNXI2/LFTrdSUBNSFLZN
         FQOlK2KXh3a5reo7ypEnUbOtwKbsEiTIzrPr5y470KEWCvOZhn0jZK9o4Lc+K0qE7Xpa
         3KcxO12ca5dw9LjguoXGMzBxDBTAzjMwzYk44PbsqVWg3hQ1Siy1lIPNBuSToSXJory+
         h7FN4aD7eYx75tZNNf4lTCTprXf0UqjVCopoq1R+oOE/gU976TF/g9erTJWtWEyDV1uP
         isC/zkR3lRpPc6h5kM8xmpTnf+OQBgzJ8XXxn6eI4F+It8dYCOIPsWi10uSNoSfOeztv
         t9Fw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1747874708; x=1748479508;
        h=cc:to:from:subject:message-id:mime-version:in-reply-to:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=e2QytSkDCPpwg2J+zLPrFtZyUnh4IEgPdGfia6szSgs=;
        b=mZZianoVPGZFu04xMSq8W4njNM1ka7Iswgv2idE5GL3q+XANdInri20NUt1/HoxUkm
         NKNpDm8er3B+Ih5sjGp+qszFFKXT1Mskox1LpHHDxQWIX8RvWiTbUOPIGwi+G4A+6akf
         3rDv1YVJANHxK15whniSlHu1oI3ZKD3ovq066wddf5Dlt+4kXZGXNp82lOoN5v0g+XX1
         NeIJvobwy/dwAcbW6AKrM8CFoEEEDr4oOr9I9KZb18ru3tQaCtCLjXNu5ly9EIHYKhSJ
         Zs9wuYHF238KGk7yvuW/t0A7HLMMDFQFUeiR+cXJeF5RU4Tah8NXA/Cio5jur8fT1NHC
         pJcA==
X-Forwarded-Encrypted: i=1; AJvYcCUxvdoQgb/iVumxXULHKoyFrJyI8WcUYMM4Zva1HWZmjgt45UG8Jejeunpk64C/4EvkMBg=@vger.kernel.org
X-Gm-Message-State: AOJu0Ywgr1aWcyV5/5i+AZ3mQZK17kHBVqZyGM/ySMmZfL69/rK8zXTF
	ghfhYWEePogNI4yKDYi1ltkLt0pxxCI2fh6eyJkN1ZsDRjcFXO/JA8N29vnsod8Cq2NDi9vBqPZ
	zLugCkgxJfttfiX53iUcIbKjVlA==
X-Google-Smtp-Source: AGHT+IFvzBeWTUh5GdXBXsBbI9+7zYzvwQbzW93s3iEbnqTFtxwRlhZyi4QfzqwI3OvWFCYUhFWP3qiOfZ1sKTzNtQ==
X-Received: from pfht7.prod.google.com ([2002:a62:ea07:0:b0:740:a530:a2d0])
 (user=ackerleytng job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6a00:278f:b0:742:acb6:b7c3 with SMTP id d2e1a72fcca58-742acce03bfmr28445186b3a.12.1747874708464;
 Wed, 21 May 2025 17:45:08 -0700 (PDT)
Date: Wed, 21 May 2025 17:45:07 -0700
In-Reply-To: <5ace54d1-800b-4122-8c05-041aa0ee12a1@redhat.com> (message from
 David Hildenbrand on Wed, 21 May 2025 10:01:24 +0200)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Message-ID: <diqzcyc18odo.fsf@ackerleytng-ctop.c.googlers.com>
Subject: Re: [PATCH v9 10/17] KVM: x86: Compute max_mapping_level with input
 from guest_memfd
From: Ackerley Tng <ackerleytng@google.com>
To: David Hildenbrand <david@redhat.com>
Cc: tabba@google.com, kvm@vger.kernel.org, linux-arm-msm@vger.kernel.org, 
	linux-mm@kvack.org, pbonzini@redhat.com, chenhuacai@kernel.org, 
	mpe@ellerman.id.au, anup@brainfault.org, paul.walmsley@sifive.com, 
	palmer@dabbelt.com, aou@eecs.berkeley.edu, seanjc@google.com, 
	viro@zeniv.linux.org.uk, brauner@kernel.org, willy@infradead.org, 
	akpm@linux-foundation.org, xiaoyao.li@intel.com, yilun.xu@intel.com, 
	chao.p.peng@linux.intel.com, jarkko@kernel.org, amoorthy@google.com, 
	dmatlack@google.com, isaku.yamahata@intel.com, mic@digikod.net, 
	vbabka@suse.cz, vannapurve@google.com, mail@maciej.szmigiero.name, 
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

David Hildenbrand <david@redhat.com> writes:

> On 13.05.25 18:34, Fuad Tabba wrote:
>> From: Ackerley Tng <ackerleytng@google.com>
>> 
>> This patch adds kvm_gmem_max_mapping_level(), which always returns
>> PG_LEVEL_4K since guest_memfd only supports 4K pages for now.
>> 
>> When guest_memfd supports shared memory, max_mapping_level (especially
>> when recovering huge pages - see call to __kvm_mmu_max_mapping_level()
>> from recover_huge_pages_range()) should take input from
>> guest_memfd.
>> 
>> Input from guest_memfd should be taken in these cases:
>> 
>> + if the memslot supports shared memory (guest_memfd is used for
>>    shared memory, or in future both shared and private memory) or
>> + if the memslot is only used for private memory and that gfn is
>>    private.
>> 
>> If the memslot doesn't use guest_memfd, figure out the
>> max_mapping_level using the host page tables like before.
>> 
>> This patch also refactors and inlines the other call to
>> __kvm_mmu_max_mapping_level().
>> 
>> In kvm_mmu_hugepage_adjust(), guest_memfd's input is already
>> provided (if applicable) in fault->max_level. Hence, there is no need
>> to query guest_memfd.
>> 
>> lpage_info is queried like before, and then if the fault is not from
>> guest_memfd, adjust fault->req_level based on input from host page
>> tables.
>> 
>> Signed-off-by: Ackerley Tng <ackerleytng@google.com>
>> Signed-off-by: Fuad Tabba <tabba@google.com>
>> ---
>>   arch/x86/kvm/mmu/mmu.c   | 92 ++++++++++++++++++++++++++--------------
>>   include/linux/kvm_host.h |  7 +++
>>   virt/kvm/guest_memfd.c   | 12 ++++++
>>   3 files changed, 79 insertions(+), 32 deletions(-)
>> 
>> diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
>> index cfbb471f7c70..9e0bc8114859 100644
>> --- a/arch/x86/kvm/mmu/mmu.c
>> +++ b/arch/x86/kvm/mmu/mmu.c
>> @@ -3256,12 +3256,11 @@ static int host_pfn_mapping_level(struct kvm *kvm, gfn_t gfn,
>>   	return level;
>>   }
> [...]
>
>>   static u8 kvm_max_level_for_fault_and_order(struct kvm *kvm,
>>   					    struct kvm_page_fault *fault,
>>   					    int order)
>> @@ -4523,7 +4551,7 @@ static int __kvm_mmu_faultin_pfn(struct kvm_vcpu *vcpu,
>>   {
>>   	unsigned int foll = fault->write ? FOLL_WRITE : 0;
>>   
>> -	if (fault->is_private || kvm_gmem_memslot_supports_shared(fault->slot))
>> +	if (fault_from_gmem(fault))
>
> Should this change rather have been done in the previous patch?
>
> (then only adjust fault_from_gmem() in this function as required)
>

Yes, that is a good idea, thanks!

>>   		return kvm_mmu_faultin_pfn_gmem(vcpu, fault);
>>   
>>   	foll |= FOLL_NOWAIT;
>> diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
>> index de7b46ee1762..f9bb025327c3 100644
>> --- a/include/linux/kvm_host.h
>> +++ b/include/linux/kvm_host.h
>> @@ -2560,6 +2560,7 @@ static inline bool kvm_mem_is_private(struct kvm *kvm, gfn_t gfn)
>>   int kvm_gmem_get_pfn(struct kvm *kvm, struct kvm_memory_slot *slot,
>>   		     gfn_t gfn, kvm_pfn_t *pfn, struct page **page,
>>   		     int *max_order);
>> +int kvm_gmem_mapping_order(const struct kvm_memory_slot *slot, gfn_t gfn);
>>   #else
>>   static inline int kvm_gmem_get_pfn(struct kvm *kvm,
>>   				   struct kvm_memory_slot *slot, gfn_t gfn,
>> @@ -2569,6 +2570,12 @@ static inline int kvm_gmem_get_pfn(struct kvm *kvm,
>>   	KVM_BUG_ON(1, kvm);
>>   	return -EIO;
>>   }
>> +static inline int kvm_gmem_mapping_order(const struct kvm_memory_slot *slot,
>> +					 gfn_t gfn)
>
> Probably should indent with two tabs here.

Yup!

