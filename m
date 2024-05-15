Return-Path: <kvm+bounces-17420-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 679428C6353
	for <lists+kvm@lfdr.de>; Wed, 15 May 2024 11:01:39 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id F1A9BB21EA5
	for <lists+kvm@lfdr.de>; Wed, 15 May 2024 09:01:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 271BC57C8D;
	Wed, 15 May 2024 09:01:26 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 98E7E2AF0E;
	Wed, 15 May 2024 09:01:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715763685; cv=none; b=byp15qARUjrw1GdOs9gnM1VVnJQCe4hZjvjeBXSIhn9PwCChJahuqC9wPBeJV7MVJ0GTIeCHQSc5JK6vDXM5jXVGpRnvu+dW/YQvzftnFrcUmx7PwSQ8OzEKfcw0i7Dffbs9XzC8ThYmpryQEWSBHxybzag/dQyTrR0D2d0m7f0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715763685; c=relaxed/simple;
	bh=VYvg12eai6+57lr4OCKIvPizXBy8aVBEYV3yUW48rY8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=pKWObDykzL13/nVJpq+RaTYU0IC+hz6cLsm6d1zOkE5+8BhgmJYHhFSCTzIFLFYjoqR6wsYRkfFa0KnitBtFC6k3UbDMZbQS2eIkUG/Sp3Ijpm3uwzWIt/pANecKVGOXpn92pGnavT0Am8aDT+w/KZ0G5qJuduNkJXXyZnP+Two=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 26F46C32781;
	Wed, 15 May 2024 09:01:21 +0000 (UTC)
Date: Wed, 15 May 2024 10:01:19 +0100
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
Subject: Re: [PATCH v2 10/14] arm64: Force device mappings to be non-secure
 shared
Message-ID: <ZkR535Hmh3WkMYai@arm.com>
References: <20240412084213.1733764-1-steven.price@arm.com>
 <20240412084213.1733764-11-steven.price@arm.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240412084213.1733764-11-steven.price@arm.com>

On Fri, Apr 12, 2024 at 09:42:09AM +0100, Steven Price wrote:
> From: Suzuki K Poulose <suzuki.poulose@arm.com>
> 
> Device mappings (currently) need to be emulated by the VMM so must be
> mapped shared with the host.

You say "currently". What's the plan when the device is not emulated?
How would the guest distinguish what's emulated and what's not to avoid
setting the PROT_NS_SHARED bit?

> Signed-off-by: Suzuki K Poulose <suzuki.poulose@arm.com>
> Signed-off-by: Steven Price <steven.price@arm.com>
> ---
>  arch/arm64/include/asm/pgtable.h | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/arch/arm64/include/asm/pgtable.h b/arch/arm64/include/asm/pgtable.h
> index f5376bd567a1..db71c564ec21 100644
> --- a/arch/arm64/include/asm/pgtable.h
> +++ b/arch/arm64/include/asm/pgtable.h
> @@ -598,7 +598,7 @@ static inline void set_pud_at(struct mm_struct *mm, unsigned long addr,
>  #define pgprot_writecombine(prot) \
>  	__pgprot_modify(prot, PTE_ATTRINDX_MASK, PTE_ATTRINDX(MT_NORMAL_NC) | PTE_PXN | PTE_UXN)
>  #define pgprot_device(prot) \
> -	__pgprot_modify(prot, PTE_ATTRINDX_MASK, PTE_ATTRINDX(MT_DEVICE_nGnRE) | PTE_PXN | PTE_UXN)
> +	__pgprot_modify(prot, PTE_ATTRINDX_MASK, PTE_ATTRINDX(MT_DEVICE_nGnRE) | PTE_PXN | PTE_UXN | PROT_NS_SHARED)

This pgprot_device() is not the only one used to map device resources.
pgprot_writecombine() is another commonly macro. It feels like a hack to
plug one but not the other and without any way for the guest to figure
out what's emulated.

Can the DT actually place those emulated ranges in the higher IPA space
so that we avoid randomly adding this attribute for devices?

-- 
Catalin

