Return-Path: <kvm+bounces-17437-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 6E80F8C692A
	for <lists+kvm@lfdr.de>; Wed, 15 May 2024 17:03:40 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id D3A9DB21379
	for <lists+kvm@lfdr.de>; Wed, 15 May 2024 15:03:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C9F5F15574C;
	Wed, 15 May 2024 15:03:28 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A0ED01553BF;
	Wed, 15 May 2024 15:03:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715785408; cv=none; b=FafCGtp4EO10rI+DUL17hEL/sVZPfa4+4FgDPWcXtgmNXl3jP+kyFeBbQYgsnWFmzfhglRUtkYfCFSRtSRGWfeBCZzZ0Yd5Bh6UdW8brbkoP29O8kwjj0ApZrn5jGYZ80DEYp/NRpUHTwEOhW2qIqGE6alzQWWgN/lgm5ffo+Hs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715785408; c=relaxed/simple;
	bh=bylLm4vBR7uF8DJjgfEFk5Uyg7AOg+1HrxqT9xiN++I=;
	h=Message-ID:Date:MIME-Version:From:Subject:To:Cc:References:
	 In-Reply-To:Content-Type; b=HQIjzpypbHt/dWRTDP9xz++soGI9t6wruDUP+afgVe3oNgGdVIHh3Mi7D/87SA/75PzdnVbZHyx91ASzUmQf3EFpoV+rXsufm0Z0QO5odvWx06lmLzszDxEGKiZXfGkNF/G8FOQ1+OzUEUde0GopuBo8D9C9Rn4WWngRjtWJFmU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 9A2311007;
	Wed, 15 May 2024 08:03:50 -0700 (PDT)
Received: from [10.57.35.28] (unknown [10.57.35.28])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id D06513F7A6;
	Wed, 15 May 2024 08:03:22 -0700 (PDT)
Message-ID: <6fef6e77-a173-4c66-bf6c-574c19820dfa@arm.com>
Date: Wed, 15 May 2024 16:03:25 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
From: Steven Price <steven.price@arm.com>
Subject: Re: [PATCH v2 02/14] arm64: Detect if in a realm and set RIPAS RAM
To: Catalin Marinas <catalin.marinas@arm.com>
Cc: kvm@vger.kernel.org, kvmarm@lists.linux.dev,
 Suzuki K Poulose <suzuki.poulose@arm.com>, Marc Zyngier <maz@kernel.org>,
 Will Deacon <will@kernel.org>, James Morse <james.morse@arm.com>,
 Oliver Upton <oliver.upton@linux.dev>, Zenghui Yu <yuzenghui@huawei.com>,
 linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
 Joey Gouly <joey.gouly@arm.com>, Alexandru Elisei
 <alexandru.elisei@arm.com>, Christoffer Dall <christoffer.dall@arm.com>,
 Fuad Tabba <tabba@google.com>, linux-coco@lists.linux.dev,
 Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>
References: <20240412084213.1733764-1-steven.price@arm.com>
 <20240412084213.1733764-3-steven.price@arm.com> <Zj5a9Kt6r7U9WN5E@arm.com>
Content-Language: en-GB
In-Reply-To: <Zj5a9Kt6r7U9WN5E@arm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

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

Noted! ;)

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

Makes sense.

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
> 
> If there's no chance of continuing beyond the point, add a comment on
> why we have a BUG_ON().

I think you're right, these shouldn't be (immediately) fatal - if this
is a change happening at runtime it might be possible to handle it.
However, at boot time it makes no sense to try to continue (which is
what I was originally looking at when this was written) as the
environment isn't what the guest is expecting, and continuing will
either lead to a later crash, attestation failure, or potential exploit
if the guest can be somehow be tricked to use the shared mapping rather
than the protected one.

I'll update the set_memory_range...() functions to return an error code
and push the boot BUG_ON up the chain (with a comment). But this is
still in the "should never happen" situation so I'll leave a WARN_ON here.

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

It's used by drivers/virt/coco/arm-cca-guest/arm-cca-guest.c (through
is_realm_world()) which can be built as a module - see patch 14.

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
> 
> TBH, the RMM spec around versioning doesn't fully make sense to me ;). I
> assume people working on it had some good reasons around the lower
> revision reporting in case of an error.

There's been a fair bit of discussion around versioning. Currently the
RMM implementation is very much a "get version" function. The issue was
what happens if in the future there is an incompatible RMM spec (i.e.
v2.0). The intention is that old OSes will provide the older version
number and give the RMM the opportunity to 'emulate' it. Equally where
the OS supports multiple versions then there's a need to negotiate a
commonly accepted version.

In terms of naming - mostly I've tried to just follow the spec, but the
naming in the spec isn't great. Calling the function rsi_version() would
be confusing so a verb is needed, but I'm not hung up on the verb. I'll
change it to rsi_request_version().

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
> to figure out what lower revision actually means in the spec (not the
> actual lowest supported but the highest while still lower than the
> requested one _or_ equal to the higher revision if the lower is higher
> than the requested one - if any of this makes sense to people ;), I'm
> sure I missed some other combinations).

Indeed - I got similar feedback on the RMI side. The spec evolved and I
forgot to update it. It should be sufficient (for now) to just look for
RSI_SUCCESS. Only when we start supporting multiple versions (on the
Linux side) do we need to look at the returned version numbers.

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

Ack.

>> +{
>> +	u64 i;
>> +	phys_addr_t start, end;
>> +
>> +	if (!static_branch_unlikely(&rsi_present))
>> +		return;
> 
> We have an accessor for rsi_present - is_realm_world(). Why not use
> that?

Will change.

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
>>  #include <asm/cpu_ops.h>
>>  #include <asm/kasan.h>
>>  #include <asm/numa.h>
>> +#include <asm/rsi.h>
>>  #include <asm/scs.h>
>>  #include <asm/sections.h>
>>  #include <asm/setup.h>
>> @@ -293,6 +294,8 @@ void __init __no_sanitize_address setup_arch(char **cmdline_p)
>>  	 * cpufeature code and early parameters.
>>  	 */
>>  	jump_label_init();
>> +	/* Init RSI after jump_labels are active */
>> +	arm64_rsi_init();
>>  	parse_early_param();
> 
> Does it need to be this early? It's fine for now but I wonder whether we
> may have some early parameter at some point that could influence what we
> do in the arm64_rsi_init(). I'd move it after or maybe even as part of
> the arm64_setup_memory(), though I haven't read the following patches if
> they update this function.

As Suzuki said - it's needed for "earlycon" to work - I'll put a comment
in explaining.

>>  
>>  	dynamic_scs_init();
>> diff --git a/arch/arm64/mm/init.c b/arch/arm64/mm/init.c
>> index 03efd86dce0a..786fd6ce5f17 100644
>> --- a/arch/arm64/mm/init.c
>> +++ b/arch/arm64/mm/init.c
>> @@ -40,6 +40,7 @@
>>  #include <asm/kvm_host.h>
>>  #include <asm/memory.h>
>>  #include <asm/numa.h>
>> +#include <asm/rsi.h>
>>  #include <asm/sections.h>
>>  #include <asm/setup.h>
>>  #include <linux/sizes.h>
>> @@ -313,6 +314,7 @@ void __init arm64_memblock_init(void)
>>  	early_init_fdt_scan_reserved_mem();
>>  
>>  	high_memory = __va(memblock_end_of_DRAM() - 1) + 1;
>> +	arm64_setup_memory();
>>  }
> 
> This feels like a random placement. This function is about memblock
> initialisation. You might as well put it in paging_init(), it could make
> more sense there. But I'd rather keep it in setup_arch() immediately
> after arm64_memblock_init().
> 

Will move.

Thanks,

Steve

