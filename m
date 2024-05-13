Return-Path: <kvm+bounces-17335-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 571F98C4531
	for <lists+kvm@lfdr.de>; Mon, 13 May 2024 18:39:10 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 0D4031F22BE5
	for <lists+kvm@lfdr.de>; Mon, 13 May 2024 16:39:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2FD5D18E2A;
	Mon, 13 May 2024 16:39:00 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9BA2C208A1;
	Mon, 13 May 2024 16:38:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715618339; cv=none; b=R0H7c09MH9nzalO4YXvQdpsnk0YwSJJ05zZxK3sWanS82DMNNnpdyzFvbLfZJRZGkYL7WCYzzjWFe3RAoCGujq/Y3t5Dd+o84CNVoH32CzF+3zJnGr/zJF/4SOp9hvwi/7ZGxmUDkg0L1sYKkXCP/GwFGE7BgXJV0WtWNfx1Zao=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715618339; c=relaxed/simple;
	bh=fhiBDdzgfG8w+pcwYov50xsdrVpjMez9OR8PkWTcBTM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=LuoaaTXMH+synXiWwM+oPiOq4coGdBvbAsk3sQA/XothX+1Sf2hqde7ez5Sr2/NZLdDLs8kZhE1X0sWMOXYZ13fzSQnye8V/ZAdD25TaOuI9SDQLQ+YHWNQAqGkHOZaFu7AaHZiCnuOxwoXvlIJoWckNFWfosk89oWLxaBpYvGc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2E331C113CC;
	Mon, 13 May 2024 16:38:56 +0000 (UTC)
Date: Mon, 13 May 2024 17:38:53 +0100
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
	Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>
Subject: Re: [PATCH v2 07/14] arm64: Make the PHYS_MASK_SHIFT dynamic
Message-ID: <ZkJCHcqfXxV1wlB0@arm.com>
References: <20240412084213.1733764-1-steven.price@arm.com>
 <20240412084213.1733764-8-steven.price@arm.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240412084213.1733764-8-steven.price@arm.com>

On Fri, Apr 12, 2024 at 09:42:06AM +0100, Steven Price wrote:
> diff --git a/arch/arm64/include/asm/kvm_arm.h b/arch/arm64/include/asm/kvm_arm.h
> index e01bb5ca13b7..9944aca348bd 100644
> --- a/arch/arm64/include/asm/kvm_arm.h
> +++ b/arch/arm64/include/asm/kvm_arm.h
> @@ -398,7 +398,7 @@
>   * bits in PAR are res0.
>   */
>  #define PAR_TO_HPFAR(par)		\
> -	(((par) & GENMASK_ULL(52 - 1, 12)) >> 8)
> +	(((par) & GENMASK_ULL(MAX_PHYS_MASK_SHIFT - 1, 12)) >> 8)

Why does this need to be changed? It's still a constant not dependent on
the new dynamic IPA size.

> diff --git a/arch/arm64/include/asm/pgtable-hwdef.h b/arch/arm64/include/asm/pgtable-hwdef.h
> index ef207a0d4f0d..90dc292bed5f 100644
> --- a/arch/arm64/include/asm/pgtable-hwdef.h
> +++ b/arch/arm64/include/asm/pgtable-hwdef.h
> @@ -206,8 +206,8 @@
>  /*
>   * Highest possible physical address supported.
>   */
> -#define PHYS_MASK_SHIFT		(CONFIG_ARM64_PA_BITS)
> -#define PHYS_MASK		((UL(1) << PHYS_MASK_SHIFT) - 1)
> +#define MAX_PHYS_MASK_SHIFT	(CONFIG_ARM64_PA_BITS)
> +#define MAX_PHYS_MASK		((UL(1) << PHYS_MASK_SHIFT) - 1)

I prefer to have MAX as suffix in those definitions, it matches other
places like TASK_SIZE_MAX, PHYS_ADDR_MAX (I know PHYS_MASK_MAX doesn't
roll off the tongue easily but very few people tend to read the kernel
aloud ;)).

-- 
Catalin

