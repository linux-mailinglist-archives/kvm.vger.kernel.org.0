Return-Path: <kvm+bounces-21170-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 3B68992B876
	for <lists+kvm@lfdr.de>; Tue,  9 Jul 2024 13:39:41 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 650D61C227B8
	for <lists+kvm@lfdr.de>; Tue,  9 Jul 2024 11:39:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CA585158851;
	Tue,  9 Jul 2024 11:39:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="kWTgVx3s"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E367C149C79;
	Tue,  9 Jul 2024 11:39:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720525172; cv=none; b=WzNZXCuBbVxjlW+Shy1I5PN0MNseO+w6WviVcSdgjvFASqYCiCDivKgYce8yY8e3bkl61atQP/uU8qVCYak40tTuMNts+A20MSCcCo0CjeLqTdxrxYpRkxsMjdfPDPEU2V40dtfIr/q/+zVV7V+wZUZSWi+1h0jDQpY5S2Fc4sY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720525172; c=relaxed/simple;
	bh=/gbNQhUzu5NCtcl067Z+7CcqqB4xMXkO1NA71N39dMw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=T1Wm5J1uKRR4K5t0H4GO93pJzqZgD0BbqZE7hiU6jhiwS4+4VpGdubEISBupNas/s30keOVOIFqhxZ9yji2I6rPI79nQ4oKPFxSOmjbtojZQTQDhSqwxqbugX456KYmrheqqKBmd8PfyTiKKXZt6Yw8oiUfhCgVoPtZ57QbUTGc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=kWTgVx3s; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 77EFFC3277B;
	Tue,  9 Jul 2024 11:39:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1720525171;
	bh=/gbNQhUzu5NCtcl067Z+7CcqqB4xMXkO1NA71N39dMw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=kWTgVx3svUaQuIYLcUm2926OaFhtxUS/LuZ8p8OO0fR5TB06GkTblfwngWYAFHuo4
	 /QExltCfzLf6Z9T9rrlvXq5QmMI1YWK+b/5sndtrEbnW8pyuH1ln/56/99Zsj7ZcsF
	 WVxeeT01940fssv5ebJSukJqg2HVjsMQ4qSJTh2GueuZyu4A5Qx+nRQUF20NmGfkwx
	 +wBYZuPqlfb0f1lfvz+ejGM+uZJEQnYh8T51ep9iQTxO/0cDK+0EwhA3Qw3IGlHfZy
	 1xuqhQgg01sdOMTulvsa6hwnC8BpGNwruPPIlVolyHS61XVn/G2pCZVqTZi+HnDp+W
	 YYfi5FeCJi+rA==
Date: Tue, 9 Jul 2024 12:39:25 +0100
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
Subject: Re: [PATCH v4 05/15] arm64: Mark all I/O as non-secure shared
Message-ID: <20240709113925.GA13242@willie-the-truck>
References: <20240701095505.165383-1-steven.price@arm.com>
 <20240701095505.165383-6-steven.price@arm.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240701095505.165383-6-steven.price@arm.com>
User-Agent: Mutt/1.10.1 (2018-07-13)

On Mon, Jul 01, 2024 at 10:54:55AM +0100, Steven Price wrote:
> All I/O is by default considered non-secure for realms. As such
> mark them as shared with the host.
> 
> Co-developed-by: Suzuki K Poulose <suzuki.poulose@arm.com>
> Signed-off-by: Suzuki K Poulose <suzuki.poulose@arm.com>
> Signed-off-by: Steven Price <steven.price@arm.com>
> ---
> Changes since v3:
>  * Add PROT_NS_SHARED to FIXMAP_PAGE_IO rather than overriding
>    set_fixmap_io() with a custom function.
>  * Modify ioreamp_cache() to specify PROT_NS_SHARED too.
> ---
>  arch/arm64/include/asm/fixmap.h | 2 +-
>  arch/arm64/include/asm/io.h     | 8 ++++----
>  2 files changed, 5 insertions(+), 5 deletions(-)
> 
> diff --git a/arch/arm64/include/asm/fixmap.h b/arch/arm64/include/asm/fixmap.h
> index 87e307804b99..f2c5e653562e 100644
> --- a/arch/arm64/include/asm/fixmap.h
> +++ b/arch/arm64/include/asm/fixmap.h
> @@ -98,7 +98,7 @@ enum fixed_addresses {
>  #define FIXADDR_TOT_SIZE	(__end_of_fixed_addresses << PAGE_SHIFT)
>  #define FIXADDR_TOT_START	(FIXADDR_TOP - FIXADDR_TOT_SIZE)
>  
> -#define FIXMAP_PAGE_IO     __pgprot(PROT_DEVICE_nGnRE)
> +#define FIXMAP_PAGE_IO     __pgprot(PROT_DEVICE_nGnRE | PROT_NS_SHARED)
>  
>  void __init early_fixmap_init(void);
>  
> diff --git a/arch/arm64/include/asm/io.h b/arch/arm64/include/asm/io.h
> index 4ff0ae3f6d66..07fc1801c6ad 100644
> --- a/arch/arm64/include/asm/io.h
> +++ b/arch/arm64/include/asm/io.h
> @@ -277,12 +277,12 @@ static inline void __const_iowrite64_copy(void __iomem *to, const void *from,
>  
>  #define ioremap_prot ioremap_prot
>  
> -#define _PAGE_IOREMAP PROT_DEVICE_nGnRE
> +#define _PAGE_IOREMAP (PROT_DEVICE_nGnRE | PROT_NS_SHARED)
>  
>  #define ioremap_wc(addr, size)	\
> -	ioremap_prot((addr), (size), PROT_NORMAL_NC)
> +	ioremap_prot((addr), (size), (PROT_NORMAL_NC | PROT_NS_SHARED))
>  #define ioremap_np(addr, size)	\
> -	ioremap_prot((addr), (size), PROT_DEVICE_nGnRnE)
> +	ioremap_prot((addr), (size), (PROT_DEVICE_nGnRnE | PROT_NS_SHARED))

Hmm. I do wonder whether you've pushed the PROT_NS_SHARED too far here.

There's nothing _architecturally_ special about the top address bit.
Even if the RSI divides the IPA space in half, the CPU doesn't give two
hoots about it in the hardware. In which case, it feels wrong to bake
PROT_NS_SHARED into ioremap_prot -- it feels much better to me if the
ioremap() code OR'd that into the physical address when passing it down

There's a selfish side of that argument, in that we need to hook
ioremap() for pKVM protected guests, but I do genuinely feel that
treating address bits as protection bits is arbitrary and doesn't belong
in these low-level definitions. In a similar vein, AMD has its
sme_{set,clr}() macros that operate on the PA (e.g. via dma_to_phys()),
which feels like a more accurate abstraction to me.

Will

