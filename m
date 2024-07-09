Return-Path: <kvm+bounces-21179-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id B160E92BA07
	for <lists+kvm@lfdr.de>; Tue,  9 Jul 2024 14:55:56 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id E2E9C1C2212E
	for <lists+kvm@lfdr.de>; Tue,  9 Jul 2024 12:55:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F296815B55D;
	Tue,  9 Jul 2024 12:55:45 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9A34815A853;
	Tue,  9 Jul 2024 12:55:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720529745; cv=none; b=F9cDi3PpHgJfZMQ3IDR36tBuyiYov3JG3kFM6iyw/co2suf0ZAKzxsIDEmxxW+yPXZf6eiXIZoEnlp9YKoG/6l2KOLr40qa2Qp188HghlavWYPvl8tnHlgBUM+ZxYBMZ8BfArc2tQPdX3J9o8xqsp1dQB2QorZuKddp/gnwuX/0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720529745; c=relaxed/simple;
	bh=1ib2rI8TcyevmjxG6XPjGlEk7kHNo3stbGZC8yibLFw=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=scWsyEcdxjOkvo0rWMSdBKZQly5UmfMilsJJuVh+3H3MzcdARh4qpamDR/o6DmJMmN1wt5WOHOjk+J51hgnuRhBSkgQMbhgBn/Arb3AxKcVbj+KPUxk0nyisxys3QgGxTR2oJK1cTnslLPOHpzLNFBdHBzKQcxp8TEmp3KXfi54=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 4B1E6153B;
	Tue,  9 Jul 2024 05:56:08 -0700 (PDT)
Received: from [10.57.74.191] (unknown [10.57.74.191])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 30AFF3F766;
	Tue,  9 Jul 2024 05:55:40 -0700 (PDT)
Message-ID: <1ce456b5-0652-4522-98ea-b32d96c1adf4@arm.com>
Date: Tue, 9 Jul 2024 13:55:38 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 06/15] arm64: Make the PHYS_MASK_SHIFT dynamic
Content-Language: en-GB
To: Will Deacon <will@kernel.org>, Steven Price <steven.price@arm.com>
Cc: kvm@vger.kernel.org, kvmarm@lists.linux.dev,
 Catalin Marinas <catalin.marinas@arm.com>, Marc Zyngier <maz@kernel.org>,
 James Morse <james.morse@arm.com>, Oliver Upton <oliver.upton@linux.dev>,
 Zenghui Yu <yuzenghui@huawei.com>, linux-arm-kernel@lists.infradead.org,
 linux-kernel@vger.kernel.org, Joey Gouly <joey.gouly@arm.com>,
 Alexandru Elisei <alexandru.elisei@arm.com>,
 Christoffer Dall <christoffer.dall@arm.com>, Fuad Tabba <tabba@google.com>,
 linux-coco@lists.linux.dev,
 Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>
References: <20240701095505.165383-1-steven.price@arm.com>
 <20240701095505.165383-7-steven.price@arm.com>
 <20240709114337.GB13242@willie-the-truck>
From: Suzuki K Poulose <suzuki.poulose@arm.com>
In-Reply-To: <20240709114337.GB13242@willie-the-truck>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 09/07/2024 12:43, Will Deacon wrote:
> On Mon, Jul 01, 2024 at 10:54:56AM +0100, Steven Price wrote:
>> Make the PHYS_MASK_SHIFT dynamic for Realms. This is only is required
>> for masking the PFN from a pte entry. For a realm phys_mask_shift is
>> reduced if the RMM reports a smaller configured size for the guest.
>>
>> The realm configuration splits the address space into two with the top
>> half being memory shared with the host, and the bottom half being
>> protected memory. We treat the bit which controls this split as an
>> attribute bit and hence exclude it (and any higher bits) from the mask.
>>
>> Co-developed-by: Suzuki K Poulose <suzuki.poulose@arm.com>
>> Signed-off-by: Suzuki K Poulose <suzuki.poulose@arm.com>
>> Signed-off-by: Steven Price <steven.price@arm.com>
>>
>> ---
>> v3: Drop the MAX_PHYS_MASK{,_SHIFT} definitions as they are no longer
>> needed.
>> ---
>>   arch/arm64/include/asm/pgtable-hwdef.h | 6 ------
>>   arch/arm64/include/asm/pgtable.h       | 5 +++++
>>   arch/arm64/kernel/rsi.c                | 5 +++++
>>   3 files changed, 10 insertions(+), 6 deletions(-)
>>
>> diff --git a/arch/arm64/include/asm/pgtable-hwdef.h b/arch/arm64/include/asm/pgtable-hwdef.h
>> index 9943ff0af4c9..2e3af0693bd8 100644
>> --- a/arch/arm64/include/asm/pgtable-hwdef.h
>> +++ b/arch/arm64/include/asm/pgtable-hwdef.h
>> @@ -203,12 +203,6 @@
>>    */
>>   #define PTE_S2_MEMATTR(t)	(_AT(pteval_t, (t)) << 2)
>>   
>> -/*
>> - * Highest possible physical address supported.
>> - */
>> -#define PHYS_MASK_SHIFT		(CONFIG_ARM64_PA_BITS)
>> -#define PHYS_MASK		((UL(1) << PHYS_MASK_SHIFT) - 1)
>> -
>>   #define TTBR_CNP_BIT		(UL(1) << 0)
>>   
>>   /*
>> diff --git a/arch/arm64/include/asm/pgtable.h b/arch/arm64/include/asm/pgtable.h
>> index f8efbc128446..11d614d83317 100644
>> --- a/arch/arm64/include/asm/pgtable.h
>> +++ b/arch/arm64/include/asm/pgtable.h
>> @@ -39,6 +39,11 @@
>>   #include <linux/sched.h>
>>   #include <linux/page_table_check.h>
>>   
>> +extern unsigned int phys_mask_shift;
>> +
>> +#define PHYS_MASK_SHIFT		(phys_mask_shift)
>> +#define PHYS_MASK		((1UL << PHYS_MASK_SHIFT) - 1)
> 
> I tried to figure out where this is actually used so I could understand
> your comment in the commit message:
> 
>   > This is only is required for masking the PFN from a pte entry
> 
> The closest thing I could find is in arch/arm64/mm/mmap.c, where the
> mask is used as part of valid_mmap_phys_addr_range() which exists purely
> to filter accesses to /dev/mem. That's pretty niche, so why not just
> inline the RSI-specific stuff in there behind a static key instead of
> changing these definitions?
> 
> Or did I miss a subtle user somewhere else?

We need to prevent ioremap() of addresses beyond that limit too.

Suzuki

> 
> Will


