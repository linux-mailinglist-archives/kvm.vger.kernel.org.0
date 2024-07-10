Return-Path: <kvm+bounces-21320-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 7B20692D541
	for <lists+kvm@lfdr.de>; Wed, 10 Jul 2024 17:44:26 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id EFE3C1F21D17
	for <lists+kvm@lfdr.de>; Wed, 10 Jul 2024 15:44:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2226E194AF0;
	Wed, 10 Jul 2024 15:44:00 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D612C189F26;
	Wed, 10 Jul 2024 15:43:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720626239; cv=none; b=Ts+UBnwZxpNqjbCtVltSP3IzMBEizwBDl7PtrCyvckv9aaCF0LUkUwGqBXjS+cdaE2RSujizk+6y17Z5MZ6niXbJ19q5GHM0AkbkwdV1X+Qgw8TJJQXe8o50zAVIQBG6yfq3ELiwQRkV2+nfvKJVc+I9wJRdYti/2RwOXKdr23k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720626239; c=relaxed/simple;
	bh=X1cJ+eZmDv+Rl3CvevwZlNKQLOFIR9YDfRr56MK5cfU=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Wv/fo+r0V2idSE5uxbxaF8w1ztyoDkqC6yG4BdsZXseM21VUXPO/JOgKZ7/Q+40Yu/xxSRRmwi0XZpU2dhOE1rE6Hghw4R6BXA55m+Yrk4rTZD9ZvNCGGBHR6gafaiS/0OKZfF+uUoJKe8iG8a3DW3Rz13yCO4FOaZXz5fWxYC0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 6EDAD106F;
	Wed, 10 Jul 2024 08:44:22 -0700 (PDT)
Received: from [10.57.8.115] (unknown [10.57.8.115])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id DECA63F766;
	Wed, 10 Jul 2024 08:43:53 -0700 (PDT)
Message-ID: <46d29283-af38-4eed-a69f-f7e4555f1a39@arm.com>
Date: Wed, 10 Jul 2024 16:43:52 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 07/15] arm64: Enforce bounce buffers for realm DMA
To: Will Deacon <will@kernel.org>
Cc: kvm@vger.kernel.org, kvmarm@lists.linux.dev,
 Catalin Marinas <catalin.marinas@arm.com>, Marc Zyngier <maz@kernel.org>,
 James Morse <james.morse@arm.com>, Oliver Upton <oliver.upton@linux.dev>,
 Suzuki K Poulose <suzuki.poulose@arm.com>, Zenghui Yu
 <yuzenghui@huawei.com>, linux-arm-kernel@lists.infradead.org,
 linux-kernel@vger.kernel.org, Joey Gouly <joey.gouly@arm.com>,
 Alexandru Elisei <alexandru.elisei@arm.com>,
 Christoffer Dall <christoffer.dall@arm.com>, Fuad Tabba <tabba@google.com>,
 linux-coco@lists.linux.dev,
 Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>
References: <20240701095505.165383-1-steven.price@arm.com>
 <20240701095505.165383-8-steven.price@arm.com>
 <20240709115649.GC13242@willie-the-truck>
From: Steven Price <steven.price@arm.com>
Content-Language: en-GB
In-Reply-To: <20240709115649.GC13242@willie-the-truck>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 09/07/2024 12:56, Will Deacon wrote:
> On Mon, Jul 01, 2024 at 10:54:57AM +0100, Steven Price wrote:
>> Within a realm guest it's not possible for a device emulated by the VMM
>> to access arbitrary guest memory. So force the use of bounce buffers to
>> ensure that the memory the emulated devices are accessing is in memory
>> which is explicitly shared with the host.
>>
>> This adds a call to swiotlb_update_mem_attributes() which calls
>> set_memory_decrypted() to ensure the bounce buffer memory is shared with
>> the host. For non-realm guests or hosts this is a no-op.
>>
>> Co-developed-by: Suzuki K Poulose <suzuki.poulose@arm.com>
>> Signed-off-by: Suzuki K Poulose <suzuki.poulose@arm.com>
>> Signed-off-by: Steven Price <steven.price@arm.com>
>> ---
>> v3: Simplify mem_init() by using a 'flags' variable.
>> ---
>>  arch/arm64/kernel/rsi.c |  2 ++
>>  arch/arm64/mm/init.c    | 10 +++++++++-
>>  2 files changed, 11 insertions(+), 1 deletion(-)
>>
>> diff --git a/arch/arm64/kernel/rsi.c b/arch/arm64/kernel/rsi.c
>> index 7ac5fc4a27d0..918db258cd4a 100644
>> --- a/arch/arm64/kernel/rsi.c
>> +++ b/arch/arm64/kernel/rsi.c
>> @@ -6,6 +6,8 @@
>>  #include <linux/jump_label.h>
>>  #include <linux/memblock.h>
>>  #include <linux/psci.h>
>> +#include <linux/swiotlb.h>
>> +
>>  #include <asm/rsi.h>
>>  
>>  struct realm_config config;
>> diff --git a/arch/arm64/mm/init.c b/arch/arm64/mm/init.c
>> index 9b5ab6818f7f..1d595b63da71 100644
>> --- a/arch/arm64/mm/init.c
>> +++ b/arch/arm64/mm/init.c
>> @@ -41,6 +41,7 @@
>>  #include <asm/kvm_host.h>
>>  #include <asm/memory.h>
>>  #include <asm/numa.h>
>> +#include <asm/rsi.h>
>>  #include <asm/sections.h>
>>  #include <asm/setup.h>
>>  #include <linux/sizes.h>
>> @@ -369,8 +370,14 @@ void __init bootmem_init(void)
>>   */
>>  void __init mem_init(void)
>>  {
>> +	unsigned int flags = SWIOTLB_VERBOSE;
>>  	bool swiotlb = max_pfn > PFN_DOWN(arm64_dma_phys_limit);
>>  
>> +	if (is_realm_world()) {
>> +		swiotlb = true;
>> +		flags |= SWIOTLB_FORCE;
>> +	}
>> +
>>  	if (IS_ENABLED(CONFIG_DMA_BOUNCE_UNALIGNED_KMALLOC) && !swiotlb) {
>>  		/*
>>  		 * If no bouncing needed for ZONE_DMA, reduce the swiotlb
>> @@ -382,7 +389,8 @@ void __init mem_init(void)
>>  		swiotlb = true;
>>  	}
>>  
>> -	swiotlb_init(swiotlb, SWIOTLB_VERBOSE);
>> +	swiotlb_init(swiotlb, flags);
>> +	swiotlb_update_mem_attributes();
> 
> Why do we have to call this so early? Certainly, we won't have probed
> the hypercalls under pKVM yet and I think it would be a lot cleaner if
> you could defer your RSI discovery too.

I don't think we *need* the swiotlb up so early, it was more of a case
of this seemed a convenient place. We can probably move this later if
pKVM has a requirement for this.

In terms of RSI discovery then see my reply on patch 2.

> Looking forward to the possibility of device assignment in future, how
> do you see DMA_BOUNCE_UNALIGNED_KMALLOC interacting with a decrypted
> SWIOTLB buffer? I'm struggling to wrap my head around how to fix that
> properly.

Device assignment generally causes problems with bounce buffers. The
assumption has mostly been that any device which is clever enough to
deal with device assignment (which in our case means enlightened enough
to understand the extra bit on the bus) wouldn't need bounce buffers.

Suzuki: Do you know if DMA_BOUNCE_UNALIGNED_KMALLOC has been thought
about? Can we make the assumption that an assigned device will be coherent?

I have to admit to being a bit worried about current assumption that we
don't need two sets of bounce buffers - one decrypted for talking to the
host, and one encrypted for "old fashioned" talking to hardware which
has hardware limitations.

Steve


