Return-Path: <kvm+bounces-17204-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id BD2F98C295F
	for <lists+kvm@lfdr.de>; Fri, 10 May 2024 19:36:04 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id E0F5E1C22448
	for <lists+kvm@lfdr.de>; Fri, 10 May 2024 17:36:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 197B31BDE6;
	Fri, 10 May 2024 17:35:55 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8714E17C68;
	Fri, 10 May 2024 17:35:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715362554; cv=none; b=YpgQHAHmAWQ/fI/7QZ1P+j+Pym7AgGXxvGaA9YbfhhHL8uOrJiWP5qrPsFXNZsHrbYJRqOAfTSVzfjDLAXQoEMCCUmUrYz9YGGod9wAc0zkYY8qLmaZCvwIP21bdSg3Q+3ln9BDPNYXsoAwg6utGR26esbVIOYaAyoU1ZQuk3ts=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715362554; c=relaxed/simple;
	bh=/beIqi8bAOLCu4vO/A4YsPuXEwyf7rU71KbEp3qpLE0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=EbbDQkfpLra8qBLQjF8HZYbqqXOKVP5XjgWnJpabdEuZ2rXKohgmqj7trQCAgyeaft0kW8AGI8pWdZu/YzEA1B4eqQRNDVMer6dZVj2/VfkoNABCwQKfiyGETwQ5Ifg49s4aC48CrzV4LYznvRhbN/4MAEZpSrfWaYtxvYEmEkY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3BEA9C113CC;
	Fri, 10 May 2024 17:35:51 +0000 (UTC)
Date: Fri, 10 May 2024 18:35:48 +0100
From: Catalin Marinas <catalin.marinas@arm.com>
To: Steven Price <steven.price@arm.com>
Cc: kvm@vger.kernel.org, kvmarm@lists.linux.dev,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Marc Zyngier <maz@kernel.org>, Will Deacon <will@kernel.org>,
	James Morse <james.morse@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Zenghui Yu <yuzenghui@huawei.com>,
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
	Joey Gouly <joey.gouly@arm.com>,
	Alexandru Elisei <alexandru.elisei@arm.com>,
	Christoffer Dall <christoffer.dall@arm.com>,
	Fuad Tabba <tabba@google.com>, linux-coco@lists.linux.dev,
	Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>
Subject: Re: [PATCH v2 02/14] arm64: Detect if in a realm and set RIPAS RAM
Message-ID: <Zj5a9Kt6r7U9WN5E@arm.com>
References: <20240412084213.1733764-1-steven.price@arm.com>
 <20240412084213.1733764-3-steven.price@arm.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240412084213.1733764-3-steven.price@arm.com>

On Fri, Apr 12, 2024 at 09:42:01AM +0100, Steven Price wrote:
> diff --git a/arch/arm64/include/asm/rsi.h b/arch/arm64/include/asm/rsi.h
> new file mode 100644
> index 000000000000..3b56aac5dc43
> --- /dev/null
> +++ b/arch/arm64/include/asm/rsi.h
> @@ -0,0 +1,46 @@
> +/* SPDX-License-Identifier: GPL-2.0-only */
> +/*
> + * Copyright (C) 2023 ARM Ltd.

You may want to update the year ;).

> + */
> +
> +#ifndef __ASM_RSI_H_
> +#define __ASM_RSI_H_
> +
> +#include <linux/jump_label.h>
> +#include <asm/rsi_cmds.h>
> +
> +extern struct static_key_false rsi_present;

Nitpick: we tend to use DECLARE_STATIC_KEY_FALSE(), it pairs with
DEFINE_STATIC_KEY_FALSE().

> +void arm64_setup_memory(void);
> +
> +void __init arm64_rsi_init(void);
> +static inline bool is_realm_world(void)
> +{
> +	return static_branch_unlikely(&rsi_present);
> +}
> +
> +static inline void set_memory_range(phys_addr_t start, phys_addr_t end,
> +				    enum ripas state)
> +{
> +	unsigned long ret;
> +	phys_addr_t top;
> +
> +	while (start != end) {
> +		ret = rsi_set_addr_range_state(start, end, state, &top);
> +		BUG_ON(ret);
> +		BUG_ON(top < start);
> +		BUG_ON(top > end);

Are these always fatal? BUG_ON() is frowned upon in general. The
alternative would be returning an error code from the function and maybe
printing a warning here (it seems that some people don't like WARN_ON
either but it's better than BUG_ON; could use a pr_err() instead). Also
if something's wrong with the RSI interface to mess up the return
values, it will be hard to debug just from those BUG_ON().

If there's no chance of continuing beyond the point, add a comment on
why we have a BUG_ON().

> diff --git a/arch/arm64/kernel/rsi.c b/arch/arm64/kernel/rsi.c
> new file mode 100644
> index 000000000000..1076649ac082
> --- /dev/null
> +++ b/arch/arm64/kernel/rsi.c
> @@ -0,0 +1,58 @@
> +// SPDX-License-Identifier: GPL-2.0-only
> +/*
> + * Copyright (C) 2023 ARM Ltd.
> + */
> +
> +#include <linux/jump_label.h>
> +#include <linux/memblock.h>
> +#include <asm/rsi.h>
> +
> +DEFINE_STATIC_KEY_FALSE_RO(rsi_present);
> +EXPORT_SYMBOL(rsi_present);

Does this need to be made available to loadable modules?

> +
> +static bool rsi_version_matches(void)
> +{
> +	unsigned long ver;
> +	unsigned long ret = rsi_get_version(RSI_ABI_VERSION, &ver, NULL);

I wonder whether rsi_get_version() is the right name (I know it was
introduced in the previous patch but the usage is here, hence my
comment). From the RMM spec, this looks more like an
rsi_request_version() to me.

TBH, the RMM spec around versioning doesn't fully make sense to me ;). I
assume people working on it had some good reasons around the lower
revision reporting in case of an error.

> +
> +	if (ret == SMCCC_RET_NOT_SUPPORTED)
> +		return false;
> +
> +	if (ver != RSI_ABI_VERSION) {
> +		pr_err("RME: RSI version %lu.%lu not supported\n",
> +		       RSI_ABI_VERSION_GET_MAJOR(ver),
> +		       RSI_ABI_VERSION_GET_MINOR(ver));
> +		return false;
> +	}

The above check matches what the spec says but wouldn't it be clearer to
just check for ret == RSI_SUCCESS? It saves one having to read the spec
to figure out what lower revision actually means in the spec (not the
actual lowest supported but the highest while still lower than the
requested one _or_ equal to the higher revision if the lower is higher
than the requested one - if any of this makes sense to people ;), I'm
sure I missed some other combinations).

> +
> +	pr_info("RME: Using RSI version %lu.%lu\n",
> +		RSI_ABI_VERSION_GET_MAJOR(ver),
> +		RSI_ABI_VERSION_GET_MINOR(ver));
> +
> +	return true;
> +}
> +
> +void arm64_setup_memory(void)

I would give this function a better name, something to resemble the RSI
setup. Similarly for others like set_memory_range_protected/shared().
Some of the functions have 'rsi' in the name like arm64_rsi_init() but
others don't and at a first look they'd seem like some generic memory
setup on arm64, not RSI-specific.

> +{
> +	u64 i;
> +	phys_addr_t start, end;
> +
> +	if (!static_branch_unlikely(&rsi_present))
> +		return;

We have an accessor for rsi_present - is_realm_world(). Why not use
that?

> +
> +	/*
> +	 * Iterate over the available memory ranges
> +	 * and convert the state to protected memory.
> +	 */
> +	for_each_mem_range(i, &start, &end) {
> +		set_memory_range_protected(start, end);
> +	}
> +}
> +
> +void __init arm64_rsi_init(void)
> +{
> +	if (!rsi_version_matches())
> +		return;
> +
> +	static_branch_enable(&rsi_present);
> +}
> diff --git a/arch/arm64/kernel/setup.c b/arch/arm64/kernel/setup.c
> index 65a052bf741f..a4bd97e74704 100644
> --- a/arch/arm64/kernel/setup.c
> +++ b/arch/arm64/kernel/setup.c
> @@ -43,6 +43,7 @@
>  #include <asm/cpu_ops.h>
>  #include <asm/kasan.h>
>  #include <asm/numa.h>
> +#include <asm/rsi.h>
>  #include <asm/scs.h>
>  #include <asm/sections.h>
>  #include <asm/setup.h>
> @@ -293,6 +294,8 @@ void __init __no_sanitize_address setup_arch(char **cmdline_p)
>  	 * cpufeature code and early parameters.
>  	 */
>  	jump_label_init();
> +	/* Init RSI after jump_labels are active */
> +	arm64_rsi_init();
>  	parse_early_param();

Does it need to be this early? It's fine for now but I wonder whether we
may have some early parameter at some point that could influence what we
do in the arm64_rsi_init(). I'd move it after or maybe even as part of
the arm64_setup_memory(), though I haven't read the following patches if
they update this function.

>  
>  	dynamic_scs_init();
> diff --git a/arch/arm64/mm/init.c b/arch/arm64/mm/init.c
> index 03efd86dce0a..786fd6ce5f17 100644
> --- a/arch/arm64/mm/init.c
> +++ b/arch/arm64/mm/init.c
> @@ -40,6 +40,7 @@
>  #include <asm/kvm_host.h>
>  #include <asm/memory.h>
>  #include <asm/numa.h>
> +#include <asm/rsi.h>
>  #include <asm/sections.h>
>  #include <asm/setup.h>
>  #include <linux/sizes.h>
> @@ -313,6 +314,7 @@ void __init arm64_memblock_init(void)
>  	early_init_fdt_scan_reserved_mem();
>  
>  	high_memory = __va(memblock_end_of_DRAM() - 1) + 1;
> +	arm64_setup_memory();
>  }

This feels like a random placement. This function is about memblock
initialisation. You might as well put it in paging_init(), it could make
more sense there. But I'd rather keep it in setup_arch() immediately
after arm64_memblock_init().

-- 
Catalin

