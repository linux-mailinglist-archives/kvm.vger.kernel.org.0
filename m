Return-Path: <kvm+bounces-25043-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 9083C95EE32
	for <lists+kvm@lfdr.de>; Mon, 26 Aug 2024 12:13:21 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 4D309282499
	for <lists+kvm@lfdr.de>; Mon, 26 Aug 2024 10:13:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E339514830D;
	Mon, 26 Aug 2024 10:13:03 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 497C91465A5;
	Mon, 26 Aug 2024 10:13:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724667183; cv=none; b=iP8axmpdMvOxG3dopLijW7oAsmHqpAlTc+6JIc7bq3Be6A5yJFYcchBmMiXqE1nDEDGiFc9SLX3jqMI7dTC6wfXzpTghBygD6shTCPZnomNGPu248IVkEOkgwat/T6OG1IO34Gs+5XSlXMgYjAZwPc/S89nbP8Y8uo+pJw6mMGU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724667183; c=relaxed/simple;
	bh=0VFJjTZUkoAmfzcu4gQMaBLbHuaJDE7k+e7lEchBslQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=RHE5zJgg5vL9haGrEqWIjNiLJVMd5PmhCDtFfBEkyJPY2NZ5EmNUEDeSZVADOWpRpXMPJDRdpszqRl8hjMhiwvfia131dIFM7umDF8hNXEdL/XWTwPtIyQo28M+I2g/hgq5x8AINmZq552+MSaa9Tfn/aeYxggfGEoZnCRHiea0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 83A11C51409;
	Mon, 26 Aug 2024 10:12:58 +0000 (UTC)
Date: Mon, 26 Aug 2024 13:13:06 +0300
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
Subject: Re: [PATCH v5 12/19] efi: arm64: Map Device with Prot Shared
Message-ID: <ZsxVMv2pA0bQzm3L@arm.com>
References: <20240819131924.372366-1-steven.price@arm.com>
 <20240819131924.372366-13-steven.price@arm.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240819131924.372366-13-steven.price@arm.com>

On Mon, Aug 19, 2024 at 02:19:17PM +0100, Steven Price wrote:
> From: Suzuki K Poulose <suzuki.poulose@arm.com>
> 
> Device mappings need to be emualted by the VMM so must be mapped shared
> with the host.
> 
> Signed-off-by: Suzuki K Poulose <suzuki.poulose@arm.com>
> Signed-off-by: Steven Price <steven.price@arm.com>
> ---
> Changes since v4:
>  * Reworked to use arm64_is_iomem_private() to decide whether the memory
>    needs to be decrypted or not.
> ---
>  arch/arm64/kernel/efi.c | 12 ++++++++++--
>  1 file changed, 10 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/arm64/kernel/efi.c b/arch/arm64/kernel/efi.c
> index 712718aed5dd..95f8e8bf07f8 100644
> --- a/arch/arm64/kernel/efi.c
> +++ b/arch/arm64/kernel/efi.c
> @@ -34,8 +34,16 @@ static __init pteval_t create_mapping_protection(efi_memory_desc_t *md)
>  	u64 attr = md->attribute;
>  	u32 type = md->type;
>  
> -	if (type == EFI_MEMORY_MAPPED_IO)
> -		return PROT_DEVICE_nGnRE;
> +	if (type == EFI_MEMORY_MAPPED_IO) {
> +		pgprot_t prot = __pgprot(PROT_DEVICE_nGnRE);
> +
> +		if (arm64_is_iomem_private(md->phys_addr,
> +					   md->num_pages << EFI_PAGE_SHIFT))
> +			prot = pgprot_encrypted(prot);
> +		else
> +			prot = pgprot_decrypted(prot);
> +		return pgprot_val(prot);

Nit: This pattern appears in the previous patch as well. Maybe add a
pgprot_maybe_decrypted().

The patch looks fine other than the need for an early initialisation if
we find any workaround. In the pKVM case, IIUC this would need to call
into the hypervisor as well but that can be handled by the bootloader.
For CCA, our problem is setting the top bit of the IPA.

What's the x86 approach here? The EFI is a bigger problem than the
earlycon.

-- 
Catalin

