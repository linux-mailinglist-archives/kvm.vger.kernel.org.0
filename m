Return-Path: <kvm+bounces-24526-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 047F3956CC7
	for <lists+kvm@lfdr.de>; Mon, 19 Aug 2024 16:11:40 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id ADA8E1F22475
	for <lists+kvm@lfdr.de>; Mon, 19 Aug 2024 14:11:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 07FCB16CD36;
	Mon, 19 Aug 2024 14:11:28 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 20AC2166F21;
	Mon, 19 Aug 2024 14:11:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724076687; cv=none; b=Vypypxcaq9VA+av/5qGW5qK+WbazsqVQkUtxcCLJkhxclCv4JBko7Vn6j4brQi9kgiFlr6J5RJXtDowYHtO8Sr/Wfmh5Mf2ncjG+/pm1X9i84ag9EIk41CbQ1QEDK9zBhH37ea/yIUCTiRqvuTh17yz0/RX7gax9DV9jdDC5CJo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724076687; c=relaxed/simple;
	bh=WWRmgBQpAQRSNy2MU7jnt60YmqPSKIzbj6xWUa+uFe4=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=K+YdgHv4rh6CGjlRGLWxNCOWI/ffomlBe/Fiw3AqJqC8pt0Cu7lCrCei+sIT2xY60FBmMdaJzLRMrkTIZgwZk5trEHa76JryJFIMQTCjrDhzvmohXI96iBsuz9h7qQTfNXkVRa32QIaBZjVYBhypJ69xJnZ4snj3YR4PqbB31NM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 8A42E339;
	Mon, 19 Aug 2024 07:11:51 -0700 (PDT)
Received: from [10.1.36.36] (FVFF763DQ05P.cambridge.arm.com [10.1.36.36])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 397773F73B;
	Mon, 19 Aug 2024 07:11:23 -0700 (PDT)
Message-ID: <15213e51-e028-445e-a22f-f06fefd15fc8@arm.com>
Date: Mon, 19 Aug 2024 15:11:22 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 11/19] arm64: rsi: Map unprotected MMIO as decrypted
Content-Language: en-GB
To: Steven Price <steven.price@arm.com>, kvm@vger.kernel.org,
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
From: Suzuki K Poulose <suzuki.poulose@arm.com>
In-Reply-To: <20240819131924.372366-12-steven.price@arm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

Hi Steven

On 19/08/2024 14:19, Steven Price wrote:
> From: Suzuki K Poulose <suzuki.poulose@arm.com>
> 
> Instead of marking every MMIO as shared, check if the given region is
> "Protected" and apply the permissions accordingly.
> 
> Signed-off-by: Suzuki K Poulose <suzuki.poulose@arm.com>
> Signed-off-by: Steven Price <steven.price@arm.com>
> ---
> New patch for v5
> ---
>   arch/arm64/kernel/rsi.c | 15 +++++++++++++++
>   arch/arm64/mm/mmu.c     |  2 +-
>   2 files changed, 16 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/arm64/kernel/rsi.c b/arch/arm64/kernel/rsi.c
> index 381a5b9a5333..672dd6862298 100644
> --- a/arch/arm64/kernel/rsi.c
> +++ b/arch/arm64/kernel/rsi.c
> @@ -6,6 +6,8 @@
>   #include <linux/jump_label.h>
>   #include <linux/memblock.h>
>   #include <linux/psci.h>
> +
> +#include <asm/io.h>
>   #include <asm/rsi.h>
>   
>   struct realm_config config;
> @@ -93,6 +95,16 @@ bool arm64_rsi_is_protected_mmio(phys_addr_t base, size_t size)
>   }
>   EXPORT_SYMBOL(arm64_rsi_is_protected_mmio);
>   
> +static int realm_ioremap_hook(phys_addr_t phys, size_t size, pgprot_t *prot)
> +{
> +	if (arm64_rsi_is_protected_mmio(phys, size))
> +		*prot = pgprot_encrypted(*prot);
> +	else
> +		*prot = pgprot_decrypted(*prot);
> +
> +	return 0;
> +}
> +
>   void __init arm64_rsi_init(void)
>   {
>   	/*
> @@ -107,6 +119,9 @@ void __init arm64_rsi_init(void)
>   		return;
>   	prot_ns_shared = BIT(config.ipa_bits - 1);
>   
> +	if (arm64_ioremap_prot_hook_register(realm_ioremap_hook))
> +		return;
> +
>   	static_branch_enable(&rsi_present);
>   }
>   
> diff --git a/arch/arm64/mm/mmu.c b/arch/arm64/mm/mmu.c
> index 06b66c23c124..0c2fa35beca0 100644
> --- a/arch/arm64/mm/mmu.c
> +++ b/arch/arm64/mm/mmu.c
> @@ -1207,7 +1207,7 @@ void set_fixmap_io(enum fixed_addresses idx, phys_addr_t phys)
>   	else
>   		prot = pgprot_encrypted(prot);
>   
> -	__set_fixmap(idx, phys, prot);
> +	__set_fixmap(idx, phys & PAGE_MASK, prot);

This looks like it should be part of the previous patch ? Otherwise 
looks good to me.

Suzuki



