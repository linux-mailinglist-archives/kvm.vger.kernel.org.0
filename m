Return-Path: <kvm+bounces-24670-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id B7A1C959109
	for <lists+kvm@lfdr.de>; Wed, 21 Aug 2024 01:19:53 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 20E8F1F24204
	for <lists+kvm@lfdr.de>; Tue, 20 Aug 2024 23:19:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5C36F1C824A;
	Tue, 20 Aug 2024 23:19:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="A9MbO1In"
X-Original-To: kvm@vger.kernel.org
Received: from out-181.mta0.migadu.com (out-181.mta0.migadu.com [91.218.175.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8E5052C18C
	for <kvm@vger.kernel.org>; Tue, 20 Aug 2024 23:19:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724195984; cv=none; b=fOXbL8naDnNyaU/sZcQqMi408mxTBzLUVrAgG6aa4WDPxBfwztG4LpnfZA9eQltKMsNA9yXg5Ju5NbzcJAZMqS6kHGGYBzDvINRR5iuwsRseI9GkZrtURQ2S4gaTGaIgR7fqr3PEsnCGDOYHX/KVc9cGMTlOWQ+LjGgGE1jbUzU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724195984; c=relaxed/simple;
	bh=1qvHHLtRGS6pkngD0s/rJa5xqiQ83JZJeHiclJgfn50=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=cby/xDP0WPcm+3FDDdjoT2PDq7FDrOy2KCFs1t/y2j1wanvjPKewnOBuuK3I6BVZl8MTwedGJXzSps5sIMXkLggsKVSBDN0L8yoybagUE7V5SvCwayEWGvqWLK/bl+SBaO4UKZqSmsR7Fs0Bd7UxPBG7biOeCTv8Ug3qunfedKs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=A9MbO1In; arc=none smtp.client-ip=91.218.175.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Date: Tue, 20 Aug 2024 16:19:32 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1724195978;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=ZFv4/lTB7hWWUR8qTRgRDRlnxz+9mDXBuPG74UtV2c0=;
	b=A9MbO1InIwMxbHX/UFUHhwlJcNymIYOopTnsIdSepqXa4GhFYrpsaWTu75wyT7ZkwdQi8T
	vS1stf9+XzmrBxWq4IJG/EjyR34XnqERvv/l/vy4Klba/Nqtmwru3/bvWvW8SpH1QP34tY
	8KCrDL5gZlWVz/rKaEyM6FKs1lJUg+8=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Oliver Upton <oliver.upton@linux.dev>
To: Marc Zyngier <maz@kernel.org>
Cc: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org,
	kvm@vger.kernel.org, James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Alexander Potapenko <glider@google.com>
Subject: Re: [PATCH 03/12] KVM: arm64: Force SRE traps when SRE access is not
 enabled
Message-ID: <ZsUkhIuA5T4BfeJ6@linux.dev>
References: <20240820100349.3544850-1-maz@kernel.org>
 <20240820100349.3544850-4-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240820100349.3544850-4-maz@kernel.org>
X-Migadu-Flow: FLOW_OUT

Hey,

On Tue, Aug 20, 2024 at 11:03:40AM +0100, Marc Zyngier wrote:
> We so far only write the ICH_HCR_EL2 config in two situations:
> 
> - when we need to emulate the GICv3 CPU interface due to HW bugs
> 
> - when we do direct injection, as the virtual CPU interface needs
>   to be enabled
> 
> This is all good. But it also means that we don't do anything special
> when we emulate a GICv2, or that there is no GIC at all.
> 
> What happens in this case when the guest uses the GICv3 system
> registers? The *guest* gets a trap for a sysreg access (EC=0x18)
> while we'd really like it to get an UNDEF.
> 
> Fixing this is a bit involved:
> 
> - we need to set all the required trap bits (TC, TALL0, TALL1, TDIR)
> 
> - for these traps to take effect, we need to (counter-intuitively)
>   set ICC_SRE_EL1.SRE to 1 so that the above traps take priority.
> 
> Note that doesn't fully work when GICv2 emulation is enabled, as
> we cannot set ICC_SRE_EL1.SRE to 1 (it breaks Group0 delivery as
> IRQ).

Just to make sure I'm following completely, GICv2-on-GICv3 guest sees
the (barf) architected behavior of sysreg traps going to EL1.

> Signed-off-by: Marc Zyngier <maz@kernel.org>
> ---
>  arch/arm64/kvm/hyp/vgic-v3-sr.c | 22 ++++++++++++++++------
>  arch/arm64/kvm/vgic/vgic-v3.c   |  5 ++++-
>  2 files changed, 20 insertions(+), 7 deletions(-)
> 
> diff --git a/arch/arm64/kvm/hyp/vgic-v3-sr.c b/arch/arm64/kvm/hyp/vgic-v3-sr.c
> index 7b397fad26f2..a184def8f5ad 100644
> --- a/arch/arm64/kvm/hyp/vgic-v3-sr.c
> +++ b/arch/arm64/kvm/hyp/vgic-v3-sr.c
> @@ -268,8 +268,16 @@ void __vgic_v3_activate_traps(struct vgic_v3_cpu_if *cpu_if)
>  	 * starting to mess with the rest of the GIC, and VMCR_EL2 in
>  	 * particular.  This logic must be called before
>  	 * __vgic_v3_restore_state().
> +	 *
> +	 * However, if the vgic is disabled (ICH_HCR_EL2.EN==0), no GIC is
> +	 * provisionned at all. In order to prevent illegal accesses to the

typo: provisioned

> +	 * system registers to trap to EL1 (duh), force ICC_SRE_EL1.SRE to 1
> +	 * so that the trap bits can take effect. Yes, we *loves* the GIC.
>  	 */
> -	if (!cpu_if->vgic_sre) {
> +	if (!(cpu_if->vgic_hcr & ICH_HCR_EN)) {
> +		write_gicreg(ICC_SRE_EL1_SRE, ICC_SRE_EL1);
> +		isb();
> +	} else if (!cpu_if->vgic_sre) {
>  		write_gicreg(0, ICC_SRE_EL1);
>  		isb();
>  		write_gicreg(cpu_if->vgic_vmcr, ICH_VMCR_EL2);
> @@ -288,8 +296,9 @@ void __vgic_v3_activate_traps(struct vgic_v3_cpu_if *cpu_if)
>  	}
>  
>  	/*
> -	 * Prevent the guest from touching the GIC system registers if
> -	 * SRE isn't enabled for GICv3 emulation.
> +	 * Prevent the guest from touching the ICC_SRE_EL1 system
> +	 * register. Note that this may not have any effect, as
> +	 * ICC_SRE_EL2.Enable being RAO/WI is a valid implementation.

So this behavior is weird but still 'safe' as, ICC_SRE_EL1.SRE is also RAO/WI
and the HCR traps are still effective. Right?

>  	 */
>  	write_gicreg(read_gicreg(ICC_SRE_EL2) & ~ICC_SRE_EL2_ENABLE,
>  		     ICC_SRE_EL2);
> @@ -297,10 +306,11 @@ void __vgic_v3_activate_traps(struct vgic_v3_cpu_if *cpu_if)
>  	/*
>  	 * If we need to trap system registers, we must write
>  	 * ICH_HCR_EL2 anyway, even if no interrupts are being
> -	 * injected,
> +	 * injected. Note that this also applies if we don't expect
> +	 * any system register access (GICv2 or no vgic at all).

We don't expect the traps to come in the GICv2 case, though, right?

Looks alright to me otherwise, but blech!

-- 
Thanks,
Oliver

