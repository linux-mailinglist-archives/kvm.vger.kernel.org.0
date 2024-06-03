Return-Path: <kvm+bounces-18687-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id EA0B48D8865
	for <lists+kvm@lfdr.de>; Mon,  3 Jun 2024 20:05:43 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 93189286A8D
	for <lists+kvm@lfdr.de>; Mon,  3 Jun 2024 18:05:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EB4E9137C36;
	Mon,  3 Jun 2024 18:05:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="OuMZ2KIM"
X-Original-To: kvm@vger.kernel.org
Received: from out-179.mta1.migadu.com (out-179.mta1.migadu.com [95.215.58.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 106E9135A46
	for <kvm@vger.kernel.org>; Mon,  3 Jun 2024 18:05:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717437936; cv=none; b=aEbByDr6dxD/bTfrN1LR1WZCS3nTf+uqkeNbe4xW7exVbhZElnHPGr0DCBymfeOElPiVENF7LaBiLVr5KMebebr2oUknSGxMpzFPQjyrihkcHU8yI7Ai62mlyXxn3lF3ladTem5CNvIGAlyohQu9mmqbguA/aitnLnbLRJ1da1s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717437936; c=relaxed/simple;
	bh=/u6hRm0ypqgZNP68qXtp0fFN8RaXuFVZaRFEGPbF9y4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=VP1JN5ODthTsBXwhK7I6yUez0j7imhCjRYlxjJzZWw23lgkJUGi3JgH4NZeUGYoAXc3XxKY7/Sdz7aREGj90937sUjMnP1VJkg+xh58aACGdYNcwT+L5l/zoSdG1J27udolgnjpzodP4hpsOJ/IbkS17XR0yG/e91toc7P1yK2A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=OuMZ2KIM; arc=none smtp.client-ip=95.215.58.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
X-Envelope-To: maz@kernel.org
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1717437930;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=v8c1jmco2IK+JdoaMwMA27Do8TVfUJeGMj6T9ZSs0To=;
	b=OuMZ2KIMa3bNCwB6yjNMGJ8lhcLV4DZDNpss0MFB5B2M1SLFglh0cBqtBFgAP9R5OEFGG+
	rkbNpuKMRWR2k5w2b268ZdlpBYesyvY30/Gf8dmfxmHb+GVi+T32KrlqXFzyLkg3Tb5heB
	lpumwqe0k1+tlfxHHrf7hI/+JxFZ8u0=
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
Date: Mon, 3 Jun 2024 18:05:23 +0000
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
Subject: Re: [PATCH v2 12/16] KVM: arm64: nv: Tag shadow S2 entries with
 guest's leaf S2 level
Message-ID: <Zl4F45W_FoVr89zl@linux.dev>
References: <20240529145628.3272630-1-maz@kernel.org>
 <20240529145628.3272630-13-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240529145628.3272630-13-maz@kernel.org>
X-Migadu-Flow: FLOW_OUT

On Wed, May 29, 2024 at 03:56:24PM +0100, Marc Zyngier wrote:
> Populate bits [56:55] of the leaf entry with the level provided
> by the guest's S2 translation. This will allow us to better scope
> the invalidation by remembering the mapping size.
> 
> Of course, this assume that the guest will issue an invalidation
> with an address that falls into the same leaf. If the guest doesn't,
> we'll over-invalidate.
> 
> Signed-off-by: Marc Zyngier <maz@kernel.org>
> ---
>  arch/arm64/include/asm/kvm_nested.h |  8 ++++++++
>  arch/arm64/kvm/mmu.c                | 17 +++++++++++++++--
>  2 files changed, 23 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/arm64/include/asm/kvm_nested.h b/arch/arm64/include/asm/kvm_nested.h
> index fcb0de3a93fe..971dbe533730 100644
> --- a/arch/arm64/include/asm/kvm_nested.h
> +++ b/arch/arm64/include/asm/kvm_nested.h
> @@ -5,6 +5,7 @@
>  #include <linux/bitfield.h>
>  #include <linux/kvm_host.h>
>  #include <asm/kvm_emulate.h>
> +#include <asm/kvm_pgtable.h>
>  
>  static inline bool vcpu_has_nv(const struct kvm_vcpu *vcpu)
>  {
> @@ -195,4 +196,11 @@ static inline bool kvm_auth_eretax(struct kvm_vcpu *vcpu, u64 *elr)
>  }
>  #endif
>  
> +#define KVM_NV_GUEST_MAP_SZ	(KVM_PGTABLE_PROT_SW1 | KVM_PGTABLE_PROT_SW0)
> +
> +static inline u64 kvm_encode_nested_level(struct kvm_s2_trans *trans)
> +{
> +	return FIELD_PREP(KVM_NV_GUEST_MAP_SZ, trans->level);
> +}
> +

It might be nice to keep all of the software fields for (in)valid in
a central place so we can add some documentation. I fear this is going
to get rather complicated as more pieces of pKVM land upstream and we
find new and fun ways to cram data into stage-2.

>  #endif /* __ARM64_KVM_NESTED_H */
> diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
> index 4ed93a384255..f3a8ec70bd29 100644
> --- a/arch/arm64/kvm/mmu.c
> +++ b/arch/arm64/kvm/mmu.c
> @@ -1598,11 +1598,17 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
>  	 * Potentially reduce shadow S2 permissions to match the guest's own
>  	 * S2. For exec faults, we'd only reach this point if the guest
>  	 * actually allowed it (see kvm_s2_handle_perm_fault).
> +	 *
> +	 * Also encode the level of the nested translation in the SW bits of
> +	 * the PTE/PMD/PUD. This will be retrived on TLB invalidation from
> +	 * the guest.

typo: retrieved

Also, it might be helpful to add some color here to indicate the encoded
TTL is used to represent the span of a single virtual TLB entry,
providing scope to the TLBI by address.

Before I actually read what was going on, I thought the TTL in the PTE
was used for matching invalidation scopes that have a valid TTL.

-- 
Thanks,
Oliver

