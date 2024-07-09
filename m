Return-Path: <kvm+bounces-21172-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id E2EE992B8E4
	for <lists+kvm@lfdr.de>; Tue,  9 Jul 2024 13:57:07 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 9DB0F284EC8
	for <lists+kvm@lfdr.de>; Tue,  9 Jul 2024 11:57:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 65A2B1581F3;
	Tue,  9 Jul 2024 11:56:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="tIuUXdIE"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 82C041EA74;
	Tue,  9 Jul 2024 11:56:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720526216; cv=none; b=BB0cKEBCdxrfMYYyRpYSLHSS244GPLjxrZSJ3KKCewk0T0ujrEZS8ZlFp4e3RAIuXxnZLr019Xa0PaJI4hW4Mg89eUiLyiH7qdAqJi+EBpLK5P5z9qsVbom07agKBHFBQTzJggJpiue/0Wor6GTv+HgzCj4+di9QasW8WFLrOyk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720526216; c=relaxed/simple;
	bh=5OKUcERZ+OB7w2fsg5OZfeoNeBp6M5cEsUpFjM1iasI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=MKTcZ6RWR27bUQH6wACZcp5OljvE0YAZnJUVIaQVM/Lx1yJsURrEDnsr92/xXNx1hFuQdRuaRoiK72S0Bz1aUEHiXqVfL29hgWmGJGV+hHvbL0/QI8RWJVTuJmqOPVfsisHNxjZHkI5WgBsd/kFpDvIFvdHwG7wT2wpydX7JkLw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=tIuUXdIE; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 17BE5C3277B;
	Tue,  9 Jul 2024 11:56:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1720526216;
	bh=5OKUcERZ+OB7w2fsg5OZfeoNeBp6M5cEsUpFjM1iasI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=tIuUXdIENMxaroq3m2mVDb7neMRWANWVEV0bFst05qT4IhLcy4CTageQJ45gpvtkO
	 tP1ojeUACfySZrJvOEiSItR40CHekwZc0QLkM3bkGBM2hP6BjGFidEoT/16HhuKxAi
	 Tr7NuVsDA4FwpHRq85M3AbA8cIFKOJw5oR3jVsxyUeAlEZBPhjCTnt8nwbFJ1srT1D
	 IWBWywSnuoFPco6Men0OXv/5t8nHTW6khJV7nr6zz0B1VMG8O9LSsnmiqFy8TF6qhG
	 lt6G1RdsI0iCvyAFNHr+cHbT30FUG6MdHtw2+nkE9HnOAYdMojX2I+Y3bSZthHLn27
	 iT4nipBF+7Nvw==
Date: Tue, 9 Jul 2024 12:56:49 +0100
From: Will Deacon <will@kernel.org>
To: Steven Price <steven.price@arm.com>
Cc: kvm@vger.kernel.org, kvmarm@lists.linux.dev,
	Catalin Marinas <catalin.marinas@arm.com>,
	Marc Zyngier <maz@kernel.org>, James Morse <james.morse@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
	Joey Gouly <joey.gouly@arm.com>,
	Alexandru Elisei <alexandru.elisei@arm.com>,
	Christoffer Dall <christoffer.dall@arm.com>,
	Fuad Tabba <tabba@google.com>, linux-coco@lists.linux.dev,
	Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>
Subject: Re: [PATCH v4 07/15] arm64: Enforce bounce buffers for realm DMA
Message-ID: <20240709115649.GC13242@willie-the-truck>
References: <20240701095505.165383-1-steven.price@arm.com>
 <20240701095505.165383-8-steven.price@arm.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240701095505.165383-8-steven.price@arm.com>
User-Agent: Mutt/1.10.1 (2018-07-13)

On Mon, Jul 01, 2024 at 10:54:57AM +0100, Steven Price wrote:
> Within a realm guest it's not possible for a device emulated by the VMM
> to access arbitrary guest memory. So force the use of bounce buffers to
> ensure that the memory the emulated devices are accessing is in memory
> which is explicitly shared with the host.
> 
> This adds a call to swiotlb_update_mem_attributes() which calls
> set_memory_decrypted() to ensure the bounce buffer memory is shared with
> the host. For non-realm guests or hosts this is a no-op.
> 
> Co-developed-by: Suzuki K Poulose <suzuki.poulose@arm.com>
> Signed-off-by: Suzuki K Poulose <suzuki.poulose@arm.com>
> Signed-off-by: Steven Price <steven.price@arm.com>
> ---
> v3: Simplify mem_init() by using a 'flags' variable.
> ---
>  arch/arm64/kernel/rsi.c |  2 ++
>  arch/arm64/mm/init.c    | 10 +++++++++-
>  2 files changed, 11 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/arm64/kernel/rsi.c b/arch/arm64/kernel/rsi.c
> index 7ac5fc4a27d0..918db258cd4a 100644
> --- a/arch/arm64/kernel/rsi.c
> +++ b/arch/arm64/kernel/rsi.c
> @@ -6,6 +6,8 @@
>  #include <linux/jump_label.h>
>  #include <linux/memblock.h>
>  #include <linux/psci.h>
> +#include <linux/swiotlb.h>
> +
>  #include <asm/rsi.h>
>  
>  struct realm_config config;
> diff --git a/arch/arm64/mm/init.c b/arch/arm64/mm/init.c
> index 9b5ab6818f7f..1d595b63da71 100644
> --- a/arch/arm64/mm/init.c
> +++ b/arch/arm64/mm/init.c
> @@ -41,6 +41,7 @@
>  #include <asm/kvm_host.h>
>  #include <asm/memory.h>
>  #include <asm/numa.h>
> +#include <asm/rsi.h>
>  #include <asm/sections.h>
>  #include <asm/setup.h>
>  #include <linux/sizes.h>
> @@ -369,8 +370,14 @@ void __init bootmem_init(void)
>   */
>  void __init mem_init(void)
>  {
> +	unsigned int flags = SWIOTLB_VERBOSE;
>  	bool swiotlb = max_pfn > PFN_DOWN(arm64_dma_phys_limit);
>  
> +	if (is_realm_world()) {
> +		swiotlb = true;
> +		flags |= SWIOTLB_FORCE;
> +	}
> +
>  	if (IS_ENABLED(CONFIG_DMA_BOUNCE_UNALIGNED_KMALLOC) && !swiotlb) {
>  		/*
>  		 * If no bouncing needed for ZONE_DMA, reduce the swiotlb
> @@ -382,7 +389,8 @@ void __init mem_init(void)
>  		swiotlb = true;
>  	}
>  
> -	swiotlb_init(swiotlb, SWIOTLB_VERBOSE);
> +	swiotlb_init(swiotlb, flags);
> +	swiotlb_update_mem_attributes();

Why do we have to call this so early? Certainly, we won't have probed
the hypercalls under pKVM yet and I think it would be a lot cleaner if
you could defer your RSI discovery too.

Looking forward to the possibility of device assignment in future, how
do you see DMA_BOUNCE_UNALIGNED_KMALLOC interacting with a decrypted
SWIOTLB buffer? I'm struggling to wrap my head around how to fix that
properly.

Will

