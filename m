Return-Path: <kvm+bounces-17374-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 6D8178C4F53
	for <lists+kvm@lfdr.de>; Tue, 14 May 2024 12:46:53 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 2D84B281162
	for <lists+kvm@lfdr.de>; Tue, 14 May 2024 10:46:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 763E774E25;
	Tue, 14 May 2024 10:18:24 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8F12C1D54D;
	Tue, 14 May 2024 10:18:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715681904; cv=none; b=ptVhWB/GjZK0LbMUH8BvkdBHsIK8WP51BucQpSeb1T9zQnSkVa78jDBdxvs6MQ69MqugM8zA2kLOzSbc4NWjeaTZOL5cSk9TnifTtyNys7cCGvZ5TuFLzrOHE4REW7lvX5KBr6A6AsOjGOLIVrzzw8VO6Sg9G3P94xOo0c19IZs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715681904; c=relaxed/simple;
	bh=8cLYLRkVui78rprHoFdK5+dfyAF0AN5nRmajaSSinPY=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=KebqqeT7fBAAN2SZwctQatGoZuTwfSMRirU7w3dn/7fJjF+zIzX6mWSNeJOqhjIVSfdNYpoQlEOSyXYP15B7yg0/uBCvcNtpeqLMtfuFfxz9bfIvc++RHS8UloHat+AnS3pOrBaO+nm+CuXb+mJtmZ5vpPNHRbCaSXpExENfRe8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id E51B61007;
	Tue, 14 May 2024 03:18:45 -0700 (PDT)
Received: from [10.57.81.220] (unknown [10.57.81.220])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 27A3D3F762;
	Tue, 14 May 2024 03:18:15 -0700 (PDT)
Message-ID: <a5dbe87b-dcb0-4467-9002-775fbdfb239d@arm.com>
Date: Tue, 14 May 2024 11:18:13 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 02/14] arm64: Detect if in a realm and set RIPAS RAM
Content-Language: en-GB
To: Catalin Marinas <catalin.marinas@arm.com>,
 Steven Price <steven.price@arm.com>
Cc: kvm@vger.kernel.org, kvmarm@lists.linux.dev, Marc Zyngier
 <maz@kernel.org>, Will Deacon <will@kernel.org>,
 James Morse <james.morse@arm.com>, Oliver Upton <oliver.upton@linux.dev>,
 Zenghui Yu <yuzenghui@huawei.com>, linux-arm-kernel@lists.infradead.org,
 linux-kernel@vger.kernel.org, Joey Gouly <joey.gouly@arm.com>,
 Alexandru Elisei <alexandru.elisei@arm.com>,
 Christoffer Dall <christoffer.dall@arm.com>, Fuad Tabba <tabba@google.com>,
 linux-coco@lists.linux.dev,
 Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>
References: <20240412084213.1733764-1-steven.price@arm.com>
 <20240412084213.1733764-3-steven.price@arm.com> <Zj5a9Kt6r7U9WN5E@arm.com>
From: Suzuki K Poulose <suzuki.poulose@arm.com>
In-Reply-To: <Zj5a9Kt6r7U9WN5E@arm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

Hi Catalin,

On 10/05/2024 18:35, Catalin Marinas wrote:
> On Fri, Apr 12, 2024 at 09:42:01AM +0100, Steven Price wrote:
>> diff --git a/arch/arm64/include/asm/rsi.h b/arch/arm64/include/asm/rsi.h
>> new file mode 100644
>> index 000000000000..3b56aac5dc43
>> --- /dev/null
>> +++ b/arch/arm64/include/asm/rsi.h
>> @@ -0,0 +1,46 @@
>> +/* SPDX-License-Identifier: GPL-2.0-only */
>> +/*
>> + * Copyright (C) 2023 ARM Ltd.
> 
> You may want to update the year ;).

This was written in 2023 ;-), hasn't changed much since, hence the year.

> 
>> + */
>> +
>> +#ifndef __ASM_RSI_H_
>> +#define __ASM_RSI_H_
>> +
>> +#include <linux/jump_label.h>
>> +#include <asm/rsi_cmds.h>
>> +
>> +extern struct static_key_false rsi_present;
> 
> Nitpick: we tend to use DECLARE_STATIC_KEY_FALSE(), it pairs with
> DEFINE_STATIC_KEY_FALSE().

Agree

> 
>> +void arm64_setup_memory(void);
>> +
>> +void __init arm64_rsi_init(void);
>> +static inline bool is_realm_world(void)
>> +{
>> +	return static_branch_unlikely(&rsi_present);
>> +}
>> +
>> +static inline void set_memory_range(phys_addr_t start, phys_addr_t end,
>> +				    enum ripas state)
>> +{
>> +	unsigned long ret;
>> +	phys_addr_t top;
>> +
>> +	while (start != end) {
>> +		ret = rsi_set_addr_range_state(start, end, state, &top);
>> +		BUG_ON(ret);
>> +		BUG_ON(top < start);
>> +		BUG_ON(top > end);
> 
> Are these always fatal? BUG_ON() is frowned upon in general. The
> alternative would be returning an error code from the function and maybe
> printing a warning here (it seems that some people don't like WARN_ON
> either but it's better than BUG_ON; could use a pr_err() instead). Also
> if something's wrong with the RSI interface to mess up the return
> values, it will be hard to debug just from those BUG_ON().

The BUG_ON was put in to stop the guest from running, when it detects
that it cannot transition a given IPA to a desired state. This could
happen manily if the Host described some address to the Guest and has
backed out from the promise.

However, thinking about this a little deeper, we could relax this a bit
and leave it to the "caller" to take an action. e.g.

1. If this fails for "Main memory" -> RIPAS_RAM transition, it is fatal.

2. If we are transitioning some random IPA to RIPAS_EMPTY (for setting 
up in-realm MMIO, which we do not support yet), it may be dealt with.

We could have other cases in the future where we support trusted I/O,
and a failure to transition is not end of the world, but simply refusing
to use a device for e.g.

That said, the current uses in the kernel are always fatal. So, the 
BUG_ON is justified as it stands. Happy to change either ways.

> 
> If there's no chance of continuing beyond the point, add a comment on
> why we have a BUG_ON().
> 
>> diff --git a/arch/arm64/kernel/rsi.c b/arch/arm64/kernel/rsi.c
>> new file mode 100644
>> index 000000000000..1076649ac082
>> --- /dev/null
>> +++ b/arch/arm64/kernel/rsi.c
>> @@ -0,0 +1,58 @@
>> +// SPDX-License-Identifier: GPL-2.0-only
>> +/*
>> + * Copyright (C) 2023 ARM Ltd.
>> + */
>> +
>> +#include <linux/jump_label.h>
>> +#include <linux/memblock.h>
>> +#include <asm/rsi.h>
>> +
>> +DEFINE_STATIC_KEY_FALSE_RO(rsi_present);
>> +EXPORT_SYMBOL(rsi_present);
> 
> Does this need to be made available to loadable modules?

Yes, for e.g., TSM_CONFIG report for attestation framework.
Patch 14 in the list.

> 
>> +
>> +static bool rsi_version_matches(void)
>> +{
>> +	unsigned long ver;
>> +	unsigned long ret = rsi_get_version(RSI_ABI_VERSION, &ver, NULL);
> 
> I wonder whether rsi_get_version() is the right name (I know it was
> introduced in the previous patch but the usage is here, hence my
> comment). From the RMM spec, this looks more like an
> rsi_request_version() to me.

Agree.

> 
> TBH, the RMM spec around versioning doesn't fully make sense to me ;). I
> assume people working on it had some good reasons around the lower
> revision reporting in case of an error.

;-)

> 
>> +
>> +	if (ret == SMCCC_RET_NOT_SUPPORTED)
>> +		return false;
>> +
>> +	if (ver != RSI_ABI_VERSION) {
>> +		pr_err("RME: RSI version %lu.%lu not supported\n",
>> +		       RSI_ABI_VERSION_GET_MAJOR(ver),
>> +		       RSI_ABI_VERSION_GET_MINOR(ver));
>> +		return false;
>> +	}
> 
> The above check matches what the spec says but wouldn't it be clearer to
> just check for ret == RSI_SUCCESS? It saves one having to read the spec

Ack. I guess this was never changed since the spec update. I have 
requested a similar change for RMI_ABI_VERSION checks.

> to figure out what lower revision actually means in the spec (not the
> actual lowest supported but the highest while still lower than the
> requested one _or_ equal to the higher revision if the lower is higher
> than the requested one - if any of this makes sense to people ;), I'm
> sure I missed some other combinations).
> 
>> +
>> +	pr_info("RME: Using RSI version %lu.%lu\n",
>> +		RSI_ABI_VERSION_GET_MAJOR(ver),
>> +		RSI_ABI_VERSION_GET_MINOR(ver));
>> +
>> +	return true;
>> +}
>> +
>> +void arm64_setup_memory(void)
> 
> I would give this function a better name, something to resemble the RSI
> setup. Similarly for others like set_memory_range_protected/shared().
> Some of the functions have 'rsi' in the name like arm64_rsi_init() but
> others don't and at a first look they'd seem like some generic memory
> setup on arm64, not RSI-specific.

Ack. arm64_rsi_setup_memory() ? I agree, we should "rsi" fy the names.

> 
>> +{
>> +	u64 i;
>> +	phys_addr_t start, end;
>> +
>> +	if (!static_branch_unlikely(&rsi_present))
>> +		return;
> 
> We have an accessor for rsi_present - is_realm_world(). Why not use
> that?
> 
>> +
>> +	/*
>> +	 * Iterate over the available memory ranges
>> +	 * and convert the state to protected memory.
>> +	 */
>> +	for_each_mem_range(i, &start, &end) {
>> +		set_memory_range_protected(start, end);
>> +	}
>> +}
>> +
>> +void __init arm64_rsi_init(void)
>> +{
>> +	if (!rsi_version_matches())
>> +		return;
>> +
>> +	static_branch_enable(&rsi_present);
>> +}
>> diff --git a/arch/arm64/kernel/setup.c b/arch/arm64/kernel/setup.c
>> index 65a052bf741f..a4bd97e74704 100644
>> --- a/arch/arm64/kernel/setup.c
>> +++ b/arch/arm64/kernel/setup.c
>> @@ -43,6 +43,7 @@
>>   #include <asm/cpu_ops.h>
>>   #include <asm/kasan.h>
>>   #include <asm/numa.h>
>> +#include <asm/rsi.h>
>>   #include <asm/scs.h>
>>   #include <asm/sections.h>
>>   #include <asm/setup.h>
>> @@ -293,6 +294,8 @@ void __init __no_sanitize_address setup_arch(char **cmdline_p)
>>   	 * cpufeature code and early parameters.
>>   	 */
>>   	jump_label_init();
>> +	/* Init RSI after jump_labels are active */
>> +	arm64_rsi_init();
>>   	parse_early_param();
> 
> Does it need to be this early? It's fine for now but I wonder whether we
> may have some early parameter at some point that could influence what we
> do in the arm64_rsi_init(). I'd move it after or maybe even as part of
> the arm64_setup_memory(), though I haven't read the following patches if
> they update this function.

We must do this before we setup the "earlycon", so that the console
is accessed using shared alias and that happens via parse_early_param() :-(.


> 
>>   
>>   	dynamic_scs_init();
>> diff --git a/arch/arm64/mm/init.c b/arch/arm64/mm/init.c
>> index 03efd86dce0a..786fd6ce5f17 100644
>> --- a/arch/arm64/mm/init.c
>> +++ b/arch/arm64/mm/init.c
>> @@ -40,6 +40,7 @@
>>   #include <asm/kvm_host.h>
>>   #include <asm/memory.h>
>>   #include <asm/numa.h>
>> +#include <asm/rsi.h>
>>   #include <asm/sections.h>
>>   #include <asm/setup.h>
>>   #include <linux/sizes.h>
>> @@ -313,6 +314,7 @@ void __init arm64_memblock_init(void)
>>   	early_init_fdt_scan_reserved_mem();
>>   
>>   	high_memory = __va(memblock_end_of_DRAM() - 1) + 1;
>> +	arm64_setup_memory();
>>   }
> 
> This feels like a random placement. This function is about memblock
> initialisation. You might as well put it in paging_init(), it could make
> more sense there. But I'd rather keep it in setup_arch() immediately
> after arm64_memblock_init().

Makes sense. This was done to make sure we process all the memory
regions, as soon as they are identified.

Suzuki


> 


