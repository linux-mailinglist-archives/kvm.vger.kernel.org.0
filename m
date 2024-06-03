Return-Path: <kvm+bounces-18689-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 1ABB38D88AA
	for <lists+kvm@lfdr.de>; Mon,  3 Jun 2024 20:37:16 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id AAB88285B53
	for <lists+kvm@lfdr.de>; Mon,  3 Jun 2024 18:37:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E0CEC1386D8;
	Mon,  3 Jun 2024 18:37:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="OW9nFfK5"
X-Original-To: kvm@vger.kernel.org
Received: from out-174.mta0.migadu.com (out-174.mta0.migadu.com [91.218.175.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A20911CD38
	for <kvm@vger.kernel.org>; Mon,  3 Jun 2024 18:37:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717439828; cv=none; b=ApTzA7vILyqDCM+5NUSM4TCSoxvImvcACYWLxvs4bMw2HdW0yiYz11KHoaxNf+56c90wXglzDXIWIzi/D9vz5OFUKDLT+6hfzhRUCM0UGcmKLqSk9lw2lVxhI39JlncXzmZBmedZzMmVby1NWyGCds6Bvq12YPqGTqgj5OM0HOU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717439828; c=relaxed/simple;
	bh=XZPd0drG7usBUs9fkr8i02c4nUIl4GmoQ6x2gXAT8dY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ZvC5DMdMxe1kjnuOtBRIIIRKQTeRoROVbv+a8oH2dWrjpkpGbofqsofE5VP2H7mrPVeNzllP702dvmXxTHXULBbxHxOoL0RG9TxA0jTMT1py0x5jLuqh7MOgxDxr2V3N1xJiBl4Z5OVtKeVTVQoU+9/LjpGdTbugZPKKHJkVtRc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=OW9nFfK5; arc=none smtp.client-ip=91.218.175.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
X-Envelope-To: maz@kernel.org
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1717439823;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=G9VrFl3J5+mmiYdOP+FesSy3Zzkq9VACbddKbqR04aE=;
	b=OW9nFfK5n0rco+CSsgAJrL2khaze6NTGVgpt8U+rxDCzq6sMzlWmSDoqoIORUct3e7qF3l
	nPxaAWpPaS5PZpuMoKuf7KuD9zTVU9OABd8jZ6ClcrmKz7UuWCpt+WxXWaCF7/gYogET8Z
	K35FnRYjL0ZSc4kGkiuDGelwB2hJCUQ=
X-Envelope-To: kvmarm@lists.linux.dev
X-Envelope-To: kvm@vger.kernel.org
X-Envelope-To: linux-arm-kernel@lists.infradead.org
X-Envelope-To: james.morse@arm.com
X-Envelope-To: suzuki.poulose@arm.com
X-Envelope-To: yuzenghui@huawei.com
X-Envelope-To: joey.gouly@arm.com
X-Envelope-To: alexandru.elisei@arm.com
X-Envelope-To: christoffer.dall@arm.com
X-Envelope-To: gankulkarni@os.amperecomputing.com
Date: Mon, 3 Jun 2024 18:36:57 +0000
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Oliver Upton <oliver.upton@linux.dev>
To: Marc Zyngier <maz@kernel.org>
Cc: kvmarm@lists.linux.dev, kvm@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>, Joey Gouly <joey.gouly@arm.com>,
	Alexandru Elisei <alexandru.elisei@arm.com>,
	Christoffer Dall <christoffer.dall@arm.com>,
	Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>
Subject: Re: [PATCH v2 13/16] KVM: arm64: nv: Invalidate TLBs based on shadow
 S2 TTL-like information
Message-ID: <Zl4NScV0E_YV7GR2@linux.dev>
References: <20240529145628.3272630-1-maz@kernel.org>
 <20240529145628.3272630-14-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240529145628.3272630-14-maz@kernel.org>
X-Migadu-Flow: FLOW_OUT

On Wed, May 29, 2024 at 03:56:25PM +0100, Marc Zyngier wrote:
> In order to be able to make S2 TLB invalidations more performant on NV,
> let's use a scheme derived from the FEAT_TTL extension.
> 
> If bits [56:55] in the leaf descriptor translating the address in the
> corresponding shadow S2 are non-zero, they indicate a level which can
> be used as an invalidation range. This allows further reduction of the
> systematic over-invalidation that takes place otherwise.
> 
> Signed-off-by: Marc Zyngier <maz@kernel.org>
> ---
>  arch/arm64/kvm/nested.c | 83 ++++++++++++++++++++++++++++++++++++++++-
>  1 file changed, 82 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/arm64/kvm/nested.c b/arch/arm64/kvm/nested.c
> index 8570b5bd0289..5ab5c43c571b 100644
> --- a/arch/arm64/kvm/nested.c
> +++ b/arch/arm64/kvm/nested.c
> @@ -4,6 +4,7 @@
>   * Author: Jintack Lim <jintack.lim@linaro.org>
>   */
>  
> +#include <linux/bitfield.h>
>  #include <linux/kvm.h>
>  #include <linux/kvm_host.h>
>  
> @@ -421,12 +422,92 @@ static unsigned int ttl_to_size(u8 ttl)
>  	return max_size;
>  }
>  
> +/*
> + * Compute the equivalent of the TTL field by parsing the shadow PT.  The
> + * granule size is extracted from the cached VTCR_EL2.TG0 while the level is
> + * retrieved from first entry carrying the level as a tag.
> + */
> +static u8 get_guest_mapping_ttl(struct kvm_s2_mmu *mmu, u64 addr)
> +{

Can you add a lockdep assertion that the MMU lock is held for write
here? At least for me this is far enough away from the 'real' page table
walk that it wasn't clear what locks were held at this point.

> +	u64 tmp, sz = 0, vtcr = mmu->tlb_vtcr;
> +	kvm_pte_t pte;
> +	u8 ttl, level;
> +
> +	switch (vtcr & VTCR_EL2_TG0_MASK) {
> +	case VTCR_EL2_TG0_4K:
> +		ttl = (TLBI_TTL_TG_4K << 2);
> +		break;
> +	case VTCR_EL2_TG0_16K:
> +		ttl = (TLBI_TTL_TG_16K << 2);
> +		break;
> +	case VTCR_EL2_TG0_64K:
> +	default:	    /* IMPDEF: treat any other value as 64k */
> +		ttl = (TLBI_TTL_TG_64K << 2);
> +		break;
> +	}
> +
> +	tmp = addr;
> +
> +again:
> +	/* Iteratively compute the block sizes for a particular granule size */
> +	switch (vtcr & VTCR_EL2_TG0_MASK) {
> +	case VTCR_EL2_TG0_4K:
> +		if	(sz < SZ_4K)	sz = SZ_4K;
> +		else if (sz < SZ_2M)	sz = SZ_2M;
> +		else if (sz < SZ_1G)	sz = SZ_1G;
> +		else			sz = 0;
> +		break;
> +	case VTCR_EL2_TG0_16K:
> +		if	(sz < SZ_16K)	sz = SZ_16K;
> +		else if (sz < SZ_32M)	sz = SZ_32M;
> +		else			sz = 0;
> +		break;
> +	case VTCR_EL2_TG0_64K:
> +	default:	    /* IMPDEF: treat any other value as 64k */
> +		if	(sz < SZ_64K)	sz = SZ_64K;
> +		else if (sz < SZ_512M)	sz = SZ_512M;
> +		else			sz = 0;
> +		break;
> +	}
> +
> +	if (sz == 0)
> +		return 0;
> +
> +	tmp &= ~(sz - 1);
> +	if (kvm_pgtable_get_leaf(mmu->pgt, tmp, &pte, NULL))
> +		goto again;

Assuming we're virtualizing a larger TG than what's in use at L0 this
may not actually find a valid leaf that exists within the span of a
single virtual TLB entry.

For example, if we're using 4K at L0 and 16K at L1, we could have:

	[ ----- valid 16K entry ------- ]

mapped as:

	[ ----- | ----- | valid | ----- ]

in the shadow S2. kvm_pgtable_get_leaf() will always return the first
splintered page, which could be invalid.

What I'm getting at is: should this use a bespoke table walker that
scans for a valid TTL in the range of [addr, addr + sz)? It may make
sense to back off a bit more aggressively and switch to a conservative,
unscoped TLBI to avoid visiting too many PTEs.

-- 
Thanks,
Oliver

