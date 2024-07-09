Return-Path: <kvm+bounces-21171-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 4CCCF92B8B6
	for <lists+kvm@lfdr.de>; Tue,  9 Jul 2024 13:45:12 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 774811C211FF
	for <lists+kvm@lfdr.de>; Tue,  9 Jul 2024 11:45:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A2524158A08;
	Tue,  9 Jul 2024 11:43:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="pfiQXz0H"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BC0BF158202;
	Tue,  9 Jul 2024 11:43:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720525424; cv=none; b=c4u019JqlZEoxbNxaH/WGVMXWrFKQ++EojKUBkttzO2+MQ7kwQxK+K8bVrbkH5mYZZrkYQYLv2YaXhQmr05HpP+6fNPwM1XvL37+XXMas0O2sRS90hOERHoCo+QR7yfr0Pr7K+h+Dw0yihYhjY+aup9Y9bLrzqFVy0wmNbxejmQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720525424; c=relaxed/simple;
	bh=ZxDFrvOXfuTsNU7JuLaaGFFmPfePvQEPeXe9Hb2BLpw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=OmKXbRniSm2W6a62dh0NsHcKODA/ulv1gznrFtfEltCQfICkOYeZOaymHzFezPYORDWmRB/KjdJu95N4r64iFS2e/ucvNiUGUr+EoZN2cDnrWWGLt0I/2UsYOKEG1ONU8AOxdYC4UkGtmHEyE4ZW06hzV4zQwTXlrxQWlR2Vrx4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=pfiQXz0H; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 46B6AC3277B;
	Tue,  9 Jul 2024 11:43:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1720525424;
	bh=ZxDFrvOXfuTsNU7JuLaaGFFmPfePvQEPeXe9Hb2BLpw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=pfiQXz0HFMM9t00fsyyKZHGaMb0ABmeWo1Y+pnEGEWD6IPKk9GYURbBtRZHZ7iA5Y
	 TFb+w0EeWTqNUX/JtuOKew9N6CWub0ExXvj3k3kAvbgS5E+irplYxueRIjyzWjdX2Q
	 9NyVdbgodDmzh9uhuBNs7zLEQCZyXR7OXdNBKxtstQXjOMWpE//Zm0DTCQ4LQ21eEO
	 djApqAZFnVdxXz7gS5A4S/qokGiu8LGSiC9rnwIBqt6CWxlEDXu7tMVO2dQeDmFYP1
	 N9UjuFKHdl4vBUcOR0PdwwKGklSzQeGivvZLza1SesMljrzWi1rYZ5XqYkr7GqW5Q5
	 HygwMTdFZBGKA==
Date: Tue, 9 Jul 2024 12:43:37 +0100
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
Subject: Re: [PATCH v4 06/15] arm64: Make the PHYS_MASK_SHIFT dynamic
Message-ID: <20240709114337.GB13242@willie-the-truck>
References: <20240701095505.165383-1-steven.price@arm.com>
 <20240701095505.165383-7-steven.price@arm.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240701095505.165383-7-steven.price@arm.com>
User-Agent: Mutt/1.10.1 (2018-07-13)

On Mon, Jul 01, 2024 at 10:54:56AM +0100, Steven Price wrote:
> Make the PHYS_MASK_SHIFT dynamic for Realms. This is only is required
> for masking the PFN from a pte entry. For a realm phys_mask_shift is
> reduced if the RMM reports a smaller configured size for the guest.
> 
> The realm configuration splits the address space into two with the top
> half being memory shared with the host, and the bottom half being
> protected memory. We treat the bit which controls this split as an
> attribute bit and hence exclude it (and any higher bits) from the mask.
> 
> Co-developed-by: Suzuki K Poulose <suzuki.poulose@arm.com>
> Signed-off-by: Suzuki K Poulose <suzuki.poulose@arm.com>
> Signed-off-by: Steven Price <steven.price@arm.com>
> 
> ---
> v3: Drop the MAX_PHYS_MASK{,_SHIFT} definitions as they are no longer
> needed.
> ---
>  arch/arm64/include/asm/pgtable-hwdef.h | 6 ------
>  arch/arm64/include/asm/pgtable.h       | 5 +++++
>  arch/arm64/kernel/rsi.c                | 5 +++++
>  3 files changed, 10 insertions(+), 6 deletions(-)
> 
> diff --git a/arch/arm64/include/asm/pgtable-hwdef.h b/arch/arm64/include/asm/pgtable-hwdef.h
> index 9943ff0af4c9..2e3af0693bd8 100644
> --- a/arch/arm64/include/asm/pgtable-hwdef.h
> +++ b/arch/arm64/include/asm/pgtable-hwdef.h
> @@ -203,12 +203,6 @@
>   */
>  #define PTE_S2_MEMATTR(t)	(_AT(pteval_t, (t)) << 2)
>  
> -/*
> - * Highest possible physical address supported.
> - */
> -#define PHYS_MASK_SHIFT		(CONFIG_ARM64_PA_BITS)
> -#define PHYS_MASK		((UL(1) << PHYS_MASK_SHIFT) - 1)
> -
>  #define TTBR_CNP_BIT		(UL(1) << 0)
>  
>  /*
> diff --git a/arch/arm64/include/asm/pgtable.h b/arch/arm64/include/asm/pgtable.h
> index f8efbc128446..11d614d83317 100644
> --- a/arch/arm64/include/asm/pgtable.h
> +++ b/arch/arm64/include/asm/pgtable.h
> @@ -39,6 +39,11 @@
>  #include <linux/sched.h>
>  #include <linux/page_table_check.h>
>  
> +extern unsigned int phys_mask_shift;
> +
> +#define PHYS_MASK_SHIFT		(phys_mask_shift)
> +#define PHYS_MASK		((1UL << PHYS_MASK_SHIFT) - 1)

I tried to figure out where this is actually used so I could understand
your comment in the commit message:

 > This is only is required for masking the PFN from a pte entry

The closest thing I could find is in arch/arm64/mm/mmap.c, where the
mask is used as part of valid_mmap_phys_addr_range() which exists purely
to filter accesses to /dev/mem. That's pretty niche, so why not just
inline the RSI-specific stuff in there behind a static key instead of
changing these definitions?

Or did I miss a subtle user somewhere else?

Will

