Return-Path: <kvm+bounces-25046-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id CE29F95EE9B
	for <lists+kvm@lfdr.de>; Mon, 26 Aug 2024 12:39:39 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 6DA7F1F22B79
	for <lists+kvm@lfdr.de>; Mon, 26 Aug 2024 10:39:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D4C1814B06E;
	Mon, 26 Aug 2024 10:39:29 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4F09B1482F5;
	Mon, 26 Aug 2024 10:39:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724668769; cv=none; b=lj4H1hLpMeF6qg+haDvAR0ACx5eBada/p1MALoTrMZSuM33ECkoLVo/8vS6f0jVN4jrrdZka4xhQnE0T1KeouT50GSFXtII86hRx1gR41pi/SB2hNKTr5CSIFYZUluDVe1K+hRJ60XtmuyuEJfgd+RAy+QzLEIepspcEAI0Znro=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724668769; c=relaxed/simple;
	bh=U9bvkumoTyJR0RM6t0kMNduBceu+3QaVBv+RAnpVeY4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=XNOyXqrOWkpiFB7lU7RiUnNM+K9WMybVMRD04REpUtPU2RX6t7jStd0FTWo0sq1PKwYL8s8PCpy5JwbAxPJ1QQOcauzIKLfhOfptjl19hz6m6ALw1v3P3fqv4xXYhOKA5DyUsWJ36e9nBkEw7Dc1UTa9XXnL8ypVAnDjJKnuY0M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 744F9C51401;
	Mon, 26 Aug 2024 10:39:24 +0000 (UTC)
Date: Mon, 26 Aug 2024 13:39:32 +0300
From: Catalin Marinas <catalin.marinas@arm.com>
To: Steven Price <steven.price@arm.com>
Cc: kvm@vger.kernel.org, kvmarm@lists.linux.dev,
	Marc Zyngier <maz@kernel.org>, Will Deacon <will@kernel.org>,
	James Morse <james.morse@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
	Joey Gouly <joey.gouly@arm.com>,
	Alexandru Elisei <alexandru.elisei@arm.com>,
	Christoffer Dall <christoffer.dall@arm.com>,
	Fuad Tabba <tabba@google.com>, linux-coco@lists.linux.dev,
	Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>,
	Gavin Shan <gshan@redhat.com>,
	Shanker Donthineni <sdonthineni@nvidia.com>,
	Alper Gun <alpergun@google.com>
Subject: Re: [PATCH v5 14/19] arm64: Enforce bounce buffers for realm DMA
Message-ID: <ZsxbZMxOIP795qPM@arm.com>
References: <20240819131924.372366-1-steven.price@arm.com>
 <20240819131924.372366-15-steven.price@arm.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240819131924.372366-15-steven.price@arm.com>

On Mon, Aug 19, 2024 at 02:19:19PM +0100, Steven Price wrote:
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
>  arch/arm64/kernel/rsi.c |  1 +
>  arch/arm64/mm/init.c    | 10 +++++++++-
>  2 files changed, 10 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/arm64/kernel/rsi.c b/arch/arm64/kernel/rsi.c
> index 5c2c977a50fb..69d8d9791c65 100644
> --- a/arch/arm64/kernel/rsi.c
> +++ b/arch/arm64/kernel/rsi.c
> @@ -6,6 +6,7 @@
>  #include <linux/jump_label.h>
>  #include <linux/memblock.h>
>  #include <linux/psci.h>
> +#include <linux/swiotlb.h>
>  
>  #include <asm/io.h>
>  #include <asm/rsi.h>
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

IIRC Will mentioned on a previous version of this series: what do we do
with the kmalloc() minalign bouncing (or other bouncing)? I think this
would only work if the device is shared.

I'm more and more inclined to only support shared devices with this
series (no dev assignment) and make it a strict dependence on RMM 1.0.
Running it in a different configuration with private devices will fall
apart. With this condition, the patch looks fine:

Reviewed-by: Catalin Marinas <catalin.marinas@arm.com>

