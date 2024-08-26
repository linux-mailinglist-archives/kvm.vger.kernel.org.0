Return-Path: <kvm+bounces-25036-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id BF8EF95EDF4
	for <lists+kvm@lfdr.de>; Mon, 26 Aug 2024 12:01:36 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 6A8BB1F22AB3
	for <lists+kvm@lfdr.de>; Mon, 26 Aug 2024 10:01:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 001F4146A73;
	Mon, 26 Aug 2024 10:01:26 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6BAB412C544;
	Mon, 26 Aug 2024 10:01:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724666485; cv=none; b=Quc0YwhnIRvaV1n/KZQbSatS4YKw8copXy9YJx69X96wzZQ52xQr+FbBM17mCF4koNXMH1y7cKlWHAPM4so/8VpweYpl0hG3JGAkXeJgMfwggCnfUQLWbOScPRJnDDn/NAkzJDgKZEzlzcG8dQ7kVZfmsQ5QzsZV4zYAqHGxF9g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724666485; c=relaxed/simple;
	bh=2ajl1sU0FPDPFT8FLCx62T0JXtwPLg9Y0e+KwZ3N2O4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=XFxb4C1cIRigXn+wwtqhBDR989Q11hmH97xONV0OQFrVEU/eLDiIa1t1MRwCXqw+UK3l0SH32dlx+Al1iHYLN9MOOQNGQGU7/20uaXEZKR5dnQ4ylNlv9f7x0IcMjm7Wj/qOmOcgVuKs7aCWggLQgLaevSaAQA22KLVM/NKnldY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B9CCEC51407;
	Mon, 26 Aug 2024 10:01:20 +0000 (UTC)
Date: Mon, 26 Aug 2024 13:01:29 +0300
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
Subject: Re: [PATCH v5 02/19] arm64: mm: Add confidential computing hook to
 ioremap_prot()
Message-ID: <ZsxSeQZbMMdtsabP@arm.com>
References: <20240819131924.372366-1-steven.price@arm.com>
 <20240819131924.372366-3-steven.price@arm.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240819131924.372366-3-steven.price@arm.com>

On Mon, Aug 19, 2024 at 02:19:07PM +0100, Steven Price wrote:
> From: Will Deacon <will@kernel.org>
> 
> Confidential Computing environments such as pKVM and Arm's CCA
> distinguish between shared (i.e. emulated) and private (i.e. assigned)
> MMIO regions.
> 
> Introduce a hook into our implementation of ioremap_prot() so that MMIO
> regions can be shared if necessary.
> 
> Signed-off-by: Will Deacon <will@kernel.org>
> Signed-off-by: Steven Price <steven.price@arm.com>
> ---
> Patch 'borrowed' from Will's series for pKVM:
> https://lore.kernel.org/r/20240730151113.1497-6-will%40kernel.org
> ---
>  arch/arm64/include/asm/io.h |  4 ++++
>  arch/arm64/mm/ioremap.c     | 23 ++++++++++++++++++++++-
>  2 files changed, 26 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/arm64/include/asm/io.h b/arch/arm64/include/asm/io.h
> index 41fd90895dfc..1ada23a6ec19 100644
> --- a/arch/arm64/include/asm/io.h
> +++ b/arch/arm64/include/asm/io.h
> @@ -271,6 +271,10 @@ __iowrite64_copy(void __iomem *to, const void *from, size_t count)
>   * I/O memory mapping functions.
>   */
>  
> +typedef int (*ioremap_prot_hook_t)(phys_addr_t phys_addr, size_t size,
> +				   pgprot_t *prot);
> +int arm64_ioremap_prot_hook_register(const ioremap_prot_hook_t hook);
> +
>  #define ioremap_prot ioremap_prot
>  
>  #define _PAGE_IOREMAP PROT_DEVICE_nGnRE
> diff --git a/arch/arm64/mm/ioremap.c b/arch/arm64/mm/ioremap.c
> index 269f2f63ab7d..6cc0b7e7eb03 100644
> --- a/arch/arm64/mm/ioremap.c
> +++ b/arch/arm64/mm/ioremap.c
> @@ -3,10 +3,22 @@
>  #include <linux/mm.h>
>  #include <linux/io.h>
>  
> +static ioremap_prot_hook_t ioremap_prot_hook;
> +
> +int arm64_ioremap_prot_hook_register(ioremap_prot_hook_t hook)
> +{
> +	if (WARN_ON(ioremap_prot_hook))
> +		return -EBUSY;
> +
> +	ioremap_prot_hook = hook;
> +	return 0;
> +}
> +
>  void __iomem *ioremap_prot(phys_addr_t phys_addr, size_t size,
>  			   unsigned long prot)
>  {
>  	unsigned long last_addr = phys_addr + size - 1;
> +	pgprot_t pgprot = __pgprot(prot);
>  
>  	/* Don't allow outside PHYS_MASK */
>  	if (last_addr & ~PHYS_MASK)
> @@ -16,7 +28,16 @@ void __iomem *ioremap_prot(phys_addr_t phys_addr, size_t size,
>  	if (WARN_ON(pfn_is_map_memory(__phys_to_pfn(phys_addr))))
>  		return NULL;
>  
> -	return generic_ioremap_prot(phys_addr, size, __pgprot(prot));
> +	/*
> +	 * If a hook is registered (e.g. for confidential computing
> +	 * purposes), call that now and barf if it fails.
> +	 */
> +	if (unlikely(ioremap_prot_hook) &&
> +	    WARN_ON(ioremap_prot_hook(phys_addr, size, &pgprot))) {
> +		return NULL;
> +	}
> +
> +	return generic_ioremap_prot(phys_addr, size, pgprot);
>  }
>  EXPORT_SYMBOL(ioremap_prot);

I should have commented on Will's original series since it's more likely
to affect pKVM than CCA. Anyway, this is all good with the hook,
especially if the guest needs to do some paravirtual call. However, we
have other instances of mapping I/O memory without going through
ioremap() - io_remap_pfn_range() which uses pgprot_decrypted(). We'll
need some hooks there as well. And I think there are a few other cases
of pgprot_decrypted() but we can fix them on a case by case bases (e.g.
routing them through io_remap_pfn_range()).

For this patch:

Reviewed-by: Catalin Marinas <catalin.marinas@arm.com>

