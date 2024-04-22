Return-Path: <kvm+bounces-15532-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id E193A8AD183
	for <lists+kvm@lfdr.de>; Mon, 22 Apr 2024 18:06:06 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 9E40E281653
	for <lists+kvm@lfdr.de>; Mon, 22 Apr 2024 16:06:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 77F8E15358F;
	Mon, 22 Apr 2024 16:06:01 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A2E671534F7
	for <kvm@vger.kernel.org>; Mon, 22 Apr 2024 16:05:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713801961; cv=none; b=vARKFn6MyFDfCEuccDoKZSHWlfG9ECfqhEfxWbOz71f+/4owDSjIiuXX/i++R3MVxN/7Z4v5sTCtWzlPVoOC0rczv3gtGGzC6WpNkOzM2Rz5OMrjDZE9M8hx/71J5nw/Sbg/rJ+2Am7Cu2ugNKUGAGbLlzXr16xZR3Jdp5YvyvE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713801961; c=relaxed/simple;
	bh=GqE8gj9JHuJF+7GM0vDx+u+0dQrsmhHhTks1QZZR3ds=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=oFqlPcb0Ob6rl0gBujYVIv0bJD/89k91Q9LwlNhpxRQ62lG0QXedSK7S/tR3jLp3RD9GO2mr1OYhvnfxnugcm3jYKZN7xd7bd8i6YYWahaz/uAOG92CE3ALF7Ph2OqP8WBzxLEcY4A/gdPxoQknTJMChqcv2ogUPt1Ifw1nobrs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 42D0D339;
	Mon, 22 Apr 2024 09:06:26 -0700 (PDT)
Received: from [10.57.84.177] (unknown [10.57.84.177])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 5534A3F7BD;
	Mon, 22 Apr 2024 09:05:56 -0700 (PDT)
Message-ID: <c485b0b9-b467-469d-a6ef-4df0c52d0987@arm.com>
Date: Mon, 22 Apr 2024 17:05:54 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [kvm-unit-tests PATCH 08/33] arm: realm: Make uart available
 before MMU is enabled
Content-Language: en-GB
To: Alexandru Elisei <alexandru.elisei@arm.com>
Cc: kvmarm@lists.linux.dev, kvm@vger.kernel.org, linux-coco@lists.linux.dev,
 linux-arm-kernel@lists.infradead.org, maz@kernel.org, joey.gouly@arm.com,
 steven.price@arm.com, james.morse@arm.com, oliver.upton@linux.dev,
 yuzenghui@huawei.com, andrew.jones@linux.dev, eric.auger@redhat.com
References: <20240412103408.2706058-1-suzuki.poulose@arm.com>
 <20240412103408.2706058-9-suzuki.poulose@arm.com> <ZiaEkwQmPf2dKGwC@arm.com>
From: Suzuki K Poulose <suzuki.poulose@arm.com>
In-Reply-To: <ZiaEkwQmPf2dKGwC@arm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 22/04/2024 16:38, Alexandru Elisei wrote:
> Hi,
> 
> On Fri, Apr 12, 2024 at 11:33:43AM +0100, Suzuki K Poulose wrote:
>> From: Joey Gouly <joey.gouly@arm.com>
>>
>> A Realm must access any emulated I/O mappings with the PTE_NS_SHARED bit set.
> 
> What entity requires that a realm must access I/O mappings with the
> PTE_NS_SHARED bit set? Is that an architectural requirement? Or is it an
> implementation choice made by the VMM and/or KVM?

RMM spec. An MMIO access in the Protected IPA must be emulated by Realm
world. If an MMIO access must be emulated by NS Host, it must be in the 
Unprotected IPA.

Technically, a VMM could create a memory map, where the NS emulated I/O
are kept in the unprotected (upper) half.

Or the VMM retains the current model and expects the Realm to use the 
"Unprotected" alias.


Either way, applying the PTE_NS_SHARED attribute doesn't change anything 
and works for both the models, as far as the Realm is concerned.


Suzuki




> 
> Thanks,
> Alex
> 
>> This is modelled as a PTE attribute, but is actually part of the address.
>>
>> So, when MMU is disabled, the "physical address" must reflect this bit set. We
>> access the UART early before the MMU is enabled. So, make sure the UART is
>> accessed always with the bit set.
>>
>> Signed-off-by: Joey Gouly <joey.gouly@arm.com>
>> Signed-off-by: Suzuki K Poulose <suzuki.poulose@arm.com>
>> ---
>>   lib/arm/asm/pgtable.h   |  5 +++++
>>   lib/arm/io.c            | 24 +++++++++++++++++++++++-
>>   lib/arm64/asm/pgtable.h |  5 +++++
>>   3 files changed, 33 insertions(+), 1 deletion(-)
>>
>> diff --git a/lib/arm/asm/pgtable.h b/lib/arm/asm/pgtable.h
>> index 350039ff..7e85e7c6 100644
>> --- a/lib/arm/asm/pgtable.h
>> +++ b/lib/arm/asm/pgtable.h
>> @@ -112,4 +112,9 @@ static inline pte_t *pte_alloc(pmd_t *pmd, unsigned long addr)
>>   	return pte_offset(pmd, addr);
>>   }
>>   
>> +static inline unsigned long arm_shared_phys_alias(void *x)
>> +{
>> +	return ((unsigned long)(x) | PTE_NS_SHARED);
>> +}
>> +
>>   #endif /* _ASMARM_PGTABLE_H_ */
>> diff --git a/lib/arm/io.c b/lib/arm/io.c
>> index 836fa854..127727e4 100644
>> --- a/lib/arm/io.c
>> +++ b/lib/arm/io.c
>> @@ -15,6 +15,8 @@
>>   #include <asm/psci.h>
>>   #include <asm/spinlock.h>
>>   #include <asm/io.h>
>> +#include <asm/mmu-api.h>
>> +#include <asm/pgtable.h>
>>   
>>   #include "io.h"
>>   
>> @@ -30,6 +32,24 @@ static struct spinlock uart_lock;
>>   static volatile u8 *uart0_base = UART_EARLY_BASE;
>>   bool is_pl011_uart;
>>   
>> +static inline volatile u8 *get_uart_base(void)
>> +{
>> +	/*
>> +	 * The address of the UART base may be different
>> +	 * based on whether we are running with/without
>> +	 * MMU enabled.
>> +	 *
>> +	 * For realms, we must force to use the shared physical
>> +	 * alias with MMU disabled, to make sure the I/O can
>> +	 * be emulated.
>> +	 * When the MMU is turned ON, the mappings are created
>> +	 * appropriately.
>> +	 */
>> +	if (mmu_enabled())
>> +		return uart0_base;
>> +	return (u8 *)arm_shared_phys_alias((void *)uart0_base);
>> +}
>> +
>>   static void uart0_init_fdt(void)
>>   {
>>   	/*
>> @@ -109,9 +129,11 @@ void io_init(void)
>>   
>>   void puts(const char *s)
>>   {
>> +	volatile u8 *uart_base = get_uart_base();
>> +
>>   	spin_lock(&uart_lock);
>>   	while (*s)
>> -		writeb(*s++, uart0_base);
>> +		writeb(*s++, uart_base);
>>   	spin_unlock(&uart_lock);
>>   }
>>   
>> diff --git a/lib/arm64/asm/pgtable.h b/lib/arm64/asm/pgtable.h
>> index 5b9f40b0..871c03e9 100644
>> --- a/lib/arm64/asm/pgtable.h
>> +++ b/lib/arm64/asm/pgtable.h
>> @@ -28,6 +28,11 @@ extern unsigned long prot_ns_shared;
>>   */
>>   #define PTE_NS_SHARED		(prot_ns_shared)
>>   
>> +static inline unsigned long arm_shared_phys_alias(void *addr)
>> +{
>> +	return ((unsigned long)addr | PTE_NS_SHARED);
>> +}
>> +
>>   /*
>>    * Highest possible physical address supported.
>>    */
>> -- 
>> 2.34.1
>>


