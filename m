Return-Path: <kvm+bounces-25544-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 42FA8966630
	for <lists+kvm@lfdr.de>; Fri, 30 Aug 2024 17:55:45 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 007A328225C
	for <lists+kvm@lfdr.de>; Fri, 30 Aug 2024 15:55:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9DF1F1B8EBD;
	Fri, 30 Aug 2024 15:54:58 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AEC9B1B8EA1;
	Fri, 30 Aug 2024 15:54:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725033298; cv=none; b=KG85jHMLm/EfLM377u04kJCTptEPfCwCN483lIwHIrFoKpe7aJzagHl0jX1tJgTLbhBuBAqV/l09Ugz1gDHsnsmi3oBdcFNyMeVQCjhKTR9C2FYj5GS13g8PH313Mj/PJS8QcfRd0kN7FXMUG94vkmuGEp6yrogWU8NTEiGaOxI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725033298; c=relaxed/simple;
	bh=OfBsrE3iZBkIkwjjy0b6HfGaTqdquI0VMMamxxmokUE=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=u9U/2Xod+6qyoCRmpdR6xVxo6FeuRil9iFWphII0DgbC51+E+ei/0FO6GPhKo/jkBnrKanDR+kS0wMeOHupJ05CWDq85bUIYoiwJTnjX7P3WfNrEsqUgZToVmmSaZ2O4tNlUr/wNsF0g65KzvQ1I9ig6kqf4uOd/h11Epy0Oo6g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 63747153B;
	Fri, 30 Aug 2024 08:55:22 -0700 (PDT)
Received: from [10.1.30.22] (e122027.cambridge.arm.com [10.1.30.22])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 1BE573F762;
	Fri, 30 Aug 2024 08:54:52 -0700 (PDT)
Message-ID: <32159e6c-ad6a-4beb-b854-fbef9bdc9862@arm.com>
Date: Fri, 30 Aug 2024 16:54:47 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 11/19] arm64: rsi: Map unprotected MMIO as decrypted
To: Suzuki K Poulose <suzuki.poulose@arm.com>, kvm@vger.kernel.org,
 kvmarm@lists.linux.dev
Cc: Catalin Marinas <catalin.marinas@arm.com>, Marc Zyngier <maz@kernel.org>,
 Will Deacon <will@kernel.org>, James Morse <james.morse@arm.com>,
 Oliver Upton <oliver.upton@linux.dev>, Zenghui Yu <yuzenghui@huawei.com>,
 linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
 Joey Gouly <joey.gouly@arm.com>, Alexandru Elisei
 <alexandru.elisei@arm.com>, Christoffer Dall <christoffer.dall@arm.com>,
 Fuad Tabba <tabba@google.com>, linux-coco@lists.linux.dev,
 Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>,
 Gavin Shan <gshan@redhat.com>, Shanker Donthineni <sdonthineni@nvidia.com>,
 Alper Gun <alpergun@google.com>
References: <20240819131924.372366-1-steven.price@arm.com>
 <20240819131924.372366-12-steven.price@arm.com>
 <15213e51-e028-445e-a22f-f06fefd15fc8@arm.com>
From: Steven Price <steven.price@arm.com>
Content-Language: en-GB
In-Reply-To: <15213e51-e028-445e-a22f-f06fefd15fc8@arm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

On 19/08/2024 15:11, Suzuki K Poulose wrote:
> Hi Steven
> 
> On 19/08/2024 14:19, Steven Price wrote:
>> From: Suzuki K Poulose <suzuki.poulose@arm.com>
>>
>> Instead of marking every MMIO as shared, check if the given region is
>> "Protected" and apply the permissions accordingly.
>>
>> Signed-off-by: Suzuki K Poulose <suzuki.poulose@arm.com>
>> Signed-off-by: Steven Price <steven.price@arm.com>
>> ---
>> New patch for v5
>> ---
>>   arch/arm64/kernel/rsi.c | 15 +++++++++++++++
>>   arch/arm64/mm/mmu.c     |  2 +-
>>   2 files changed, 16 insertions(+), 1 deletion(-)
>>
>> diff --git a/arch/arm64/kernel/rsi.c b/arch/arm64/kernel/rsi.c
>> index 381a5b9a5333..672dd6862298 100644
>> --- a/arch/arm64/kernel/rsi.c
>> +++ b/arch/arm64/kernel/rsi.c
>> @@ -6,6 +6,8 @@
>>   #include <linux/jump_label.h>
>>   #include <linux/memblock.h>
>>   #include <linux/psci.h>
>> +
>> +#include <asm/io.h>
>>   #include <asm/rsi.h>
>>     struct realm_config config;
>> @@ -93,6 +95,16 @@ bool arm64_rsi_is_protected_mmio(phys_addr_t base,
>> size_t size)
>>   }
>>   EXPORT_SYMBOL(arm64_rsi_is_protected_mmio);
>>   +static int realm_ioremap_hook(phys_addr_t phys, size_t size,
>> pgprot_t *prot)
>> +{
>> +    if (arm64_rsi_is_protected_mmio(phys, size))
>> +        *prot = pgprot_encrypted(*prot);
>> +    else
>> +        *prot = pgprot_decrypted(*prot);
>> +
>> +    return 0;
>> +}
>> +
>>   void __init arm64_rsi_init(void)
>>   {
>>       /*
>> @@ -107,6 +119,9 @@ void __init arm64_rsi_init(void)
>>           return;
>>       prot_ns_shared = BIT(config.ipa_bits - 1);
>>   +    if (arm64_ioremap_prot_hook_register(realm_ioremap_hook))
>> +        return;
>> +
>>       static_branch_enable(&rsi_present);
>>   }
>>   diff --git a/arch/arm64/mm/mmu.c b/arch/arm64/mm/mmu.c
>> index 06b66c23c124..0c2fa35beca0 100644
>> --- a/arch/arm64/mm/mmu.c
>> +++ b/arch/arm64/mm/mmu.c
>> @@ -1207,7 +1207,7 @@ void set_fixmap_io(enum fixed_addresses idx,
>> phys_addr_t phys)
>>       else
>>           prot = pgprot_encrypted(prot);
>>   -    __set_fixmap(idx, phys, prot);
>> +    __set_fixmap(idx, phys & PAGE_MASK, prot);
> 
> This looks like it should be part of the previous patch ? Otherwise
> looks good to me.

Good spot - yes it should!

Thanks,
Steve


