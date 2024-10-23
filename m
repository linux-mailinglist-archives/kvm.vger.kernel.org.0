Return-Path: <kvm+bounces-29520-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 521039ACD74
	for <lists+kvm@lfdr.de>; Wed, 23 Oct 2024 16:53:49 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id F0F301F248DA
	for <lists+kvm@lfdr.de>; Wed, 23 Oct 2024 14:53:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A1C861D015E;
	Wed, 23 Oct 2024 14:35:45 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 01DC01CFEB7;
	Wed, 23 Oct 2024 14:35:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729694145; cv=none; b=Tkr1nEm2QM4Do9jPv93ntXPKJaC2UGYSPsoC9wPOqz4RGhBUJxHtFWAkxb/zPA8KxRCMkQc7+Qv84jFl9epN/2pUfq01U5cCoWkuh8A5d0uZBB9X8FJ6k/Xq3o4ehQca0EihcenxXczpOCDsrkWgSq/5rCpyaDzNf6tlN4Gbm6A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729694145; c=relaxed/simple;
	bh=l68G4xs/wglFkcKCnUp2kdZ0MOFIFNVe7VqWRN/gcjE=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=ZFTStzpOEpBDOPc3PCHkOBQyyz3HhzqjfWnZNBWhlvnYdDQu3t1C6v5FEUdrxsbeZe87SE3BV4iWzVu/ubggOluhGj7pd3oONfcl57kEVoptrrKa0dkt2TzGVUSwBRw3KIX9xOrqpUtAAG220ulvfgnV6lvt/rIEtpHpk0mYIN8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id E145E339;
	Wed, 23 Oct 2024 07:36:11 -0700 (PDT)
Received: from [10.57.23.17] (unknown [10.57.23.17])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 045763F71E;
	Wed, 23 Oct 2024 07:35:37 -0700 (PDT)
Message-ID: <7d02ed25-7618-4920-8f35-9e480cdf709f@arm.com>
Date: Wed, 23 Oct 2024 15:35:35 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 02/43] kvm: arm64: pgtable: Track the number of pages
 in the entry level
To: Gavin Shan <gshan@redhat.com>, kvm@vger.kernel.org, kvmarm@lists.linux.dev
Cc: Suzuki K Poulose <suzuki.poulose@arm.com>,
 Catalin Marinas <catalin.marinas@arm.com>, Marc Zyngier <maz@kernel.org>,
 Will Deacon <will@kernel.org>, James Morse <james.morse@arm.com>,
 Oliver Upton <oliver.upton@linux.dev>, Zenghui Yu <yuzenghui@huawei.com>,
 linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
 Joey Gouly <joey.gouly@arm.com>, Alexandru Elisei
 <alexandru.elisei@arm.com>, Christoffer Dall <christoffer.dall@arm.com>,
 Fuad Tabba <tabba@google.com>, linux-coco@lists.linux.dev,
 Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>,
 Shanker Donthineni <sdonthineni@nvidia.com>, Alper Gun
 <alpergun@google.com>, "Aneesh Kumar K . V" <aneesh.kumar@kernel.org>
References: <20241004152804.72508-1-steven.price@arm.com>
 <20241004152804.72508-3-steven.price@arm.com>
 <032d29e7-b6a3-4493-833b-a9b6d9496a75@redhat.com>
From: Steven Price <steven.price@arm.com>
Content-Language: en-GB
In-Reply-To: <032d29e7-b6a3-4493-833b-a9b6d9496a75@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

On 23/10/2024 05:03, Gavin Shan wrote:
> On 10/5/24 1:27 AM, Steven Price wrote:
>> From: Suzuki K Poulose <suzuki.poulose@arm.com>
>>
>> Keep track of the number of pages allocated for the top level PGD,
>> rather than computing it every time (though we need it only twice now).
>> This will be used later by Arm CCA KVM changes.
>>
>> Signed-off-by: Suzuki K Poulose <suzuki.poulose@arm.com>
>> Signed-off-by: Steven Price <steven.price@arm.com>
>> ---
>>   arch/arm64/include/asm/kvm_pgtable.h | 2 ++
>>   arch/arm64/kvm/hyp/pgtable.c         | 5 +++--
>>   2 files changed, 5 insertions(+), 2 deletions(-)
>>
> 
> If we really want to have the number of pages for the top level PGDs,
> the existing helpers kvm_pgtable_stage2_pgd_size() for the same purpose
> needs to replaced by (struct kvm_pgtable::pgd_pages << PAGE_SHIFT) and
> then removed.
> 
> The alternative would be just to use kvm_pgtable_stage2_pgd_size()
> instead of
> introducing struct kvm_pgtable::pgd_pages, which will be used in the slow
> paths where realm is created or destroyed.

I think just dropping this patch and using kvm_pgtable_stage2_pgd_size()
in the slow paths makes sense. I think originally there had been some
issue with the value being hard to obtain in the relevant path, but I
can't see any problem now.

Thanks,
Steve

>> diff --git a/arch/arm64/include/asm/kvm_pgtable.h
>> b/arch/arm64/include/asm/kvm_pgtable.h
>> index 03f4c3d7839c..25b512756200 100644
>> --- a/arch/arm64/include/asm/kvm_pgtable.h
>> +++ b/arch/arm64/include/asm/kvm_pgtable.h
>> @@ -404,6 +404,7 @@ static inline bool kvm_pgtable_walk_lock_held(void)
>>    * struct kvm_pgtable - KVM page-table.
>>    * @ia_bits:        Maximum input address size, in bits.
>>    * @start_level:    Level at which the page-table walk starts.
>> + * @pgd_pages:        Number of pages in the entry level of the
>> page-table.
>>    * @pgd:        Pointer to the first top-level entry of the page-table.
>>    * @mm_ops:        Memory management callbacks.
>>    * @mmu:        Stage-2 KVM MMU struct. Unused for stage-1 page-tables.
>> @@ -414,6 +415,7 @@ static inline bool kvm_pgtable_walk_lock_held(void)
>>   struct kvm_pgtable {
>>       u32                    ia_bits;
>>       s8                    start_level;
>> +    u8                    pgd_pages;
>>       kvm_pteref_t                pgd;
>>       struct kvm_pgtable_mm_ops        *mm_ops;
>>   diff --git a/arch/arm64/kvm/hyp/pgtable.c
>> b/arch/arm64/kvm/hyp/pgtable.c
>> index b11bcebac908..9e1be28c3dc9 100644
>> --- a/arch/arm64/kvm/hyp/pgtable.c
>> +++ b/arch/arm64/kvm/hyp/pgtable.c
>> @@ -1534,7 +1534,8 @@ int __kvm_pgtable_stage2_init(struct kvm_pgtable
>> *pgt, struct kvm_s2_mmu *mmu,
>>       u32 sl0 = FIELD_GET(VTCR_EL2_SL0_MASK, vtcr);
>>       s8 start_level = VTCR_EL2_TGRAN_SL0_BASE - sl0;
>>   -    pgd_sz = kvm_pgd_pages(ia_bits, start_level) * PAGE_SIZE;
>> +    pgt->pgd_pages = kvm_pgd_pages(ia_bits, start_level);
>> +    pgd_sz = pgt->pgd_pages * PAGE_SIZE;
>>       pgt->pgd = (kvm_pteref_t)mm_ops->zalloc_pages_exact(pgd_sz);
>>       if (!pgt->pgd)
>>           return -ENOMEM;
>> @@ -1586,7 +1587,7 @@ void kvm_pgtable_stage2_destroy(struct
>> kvm_pgtable *pgt)
>>       };
>>         WARN_ON(kvm_pgtable_walk(pgt, 0, BIT(pgt->ia_bits), &walker));
>> -    pgd_sz = kvm_pgd_pages(pgt->ia_bits, pgt->start_level) * PAGE_SIZE;
>> +    pgd_sz = pgt->pgd_pages * PAGE_SIZE;
>>       pgt->mm_ops->free_pages_exact(kvm_dereference_pteref(&walker,
>> pgt->pgd), pgd_sz);
>>       pgt->pgd = NULL;
>>   }
> 
> Thanks,
> Gavin
> 


