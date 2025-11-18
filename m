Return-Path: <kvm+bounces-63501-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [IPv6:2605:f480:58:1:0:1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id 711EBC67E1E
	for <lists+kvm@lfdr.de>; Tue, 18 Nov 2025 08:20:02 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 526A84EF878
	for <lists+kvm@lfdr.de>; Tue, 18 Nov 2025 07:17:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 432092FD69B;
	Tue, 18 Nov 2025 07:16:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="UvQmVK3n"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4A68B2FB967;
	Tue, 18 Nov 2025 07:16:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763450211; cv=none; b=PaQWhSOOS78Fz0K/XRAiC7yKqaRUZ0f9qdXHfXrzDbtThmJkNUtla/1EhMCWrSHp8njeVxANd8ANp1ZPYXN9Pn5AG50xkGtGVuqA69u6UnAn481EiHsLLGlKzcqoUp7PcBhQRbNuhzyIFOC4tSMf8vSZkvejzZBnrxqk43ogRrw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763450211; c=relaxed/simple;
	bh=o/KD4CFjTa5b+jI1V4WECs+Cr2gk3wDlEmLAaFnD4Ao=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=au4Idh8Vfdq4pCBbBeTTV24uxMi+NQOcwIp6lGugQzmGxbyKV9lBJrCEY6/b2JjKppbVhabWmRweW6mEfd75Ee80jrGahhJmtmEpsK4WYyZ2gg4CGDE7IyIYCxnZqTvtJAqDvBX6NCIrAWvnqZS6013pFejwi/sz1rIpUC5e1g0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=UvQmVK3n; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8E3A8C4CEFB;
	Tue, 18 Nov 2025 07:16:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1763450210;
	bh=o/KD4CFjTa5b+jI1V4WECs+Cr2gk3wDlEmLAaFnD4Ao=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=UvQmVK3nMgoYR91ZphsqYWV0kU9oHzB14ClmsFfmVBjTSOEJMREcoW+bExW/4lYNB
	 qsBVlJgxcMYg3Q6lk3XVcGP7KbJvkswko9cpTr4M2DV1loH/L1yfLhyFkvL2CpQP0H
	 O8RO5eTZwqtyQ6b/SzifEjPeADuyZ/9PEIbXs7zU1910PfRnM55l2wRPm0S6yZiPAY
	 PRO4ACHkktfiw9ALsPokgf4lZBKVNJw8FGgiMWfIwG/nbEWC/kSOeIQisvvG2YXel/
	 CZP8j6YcWyD+pZC2j/JJwGyMBGJnaSr4vWwGfRl8Re9dqRN0zqOpLc85WI0GEDsYBe
	 nFQI6w5AU2jcg==
Date: Mon, 17 Nov 2025 23:16:49 -0800
From: Oliver Upton <oupton@kernel.org>
To: Marc Zyngier <maz@kernel.org>
Cc: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org,
	kvm@vger.kernel.org, Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Christoffer Dall <christoffer.dall@arm.com>,
	Fuad Tabba <tabba@google.com>, Mark Brown <broonie@kernel.org>
Subject: Re: [PATCH v3 5/5] KVM: arm64: GICv3: Force exit to sync
 ICH_HCR_EL2.En
Message-ID: <aRwdYZ98cwIeg-P3@kernel.org>
References: <20251117091527.1119213-1-maz@kernel.org>
 <20251117091527.1119213-6-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251117091527.1119213-6-maz@kernel.org>

Hey Marc,

On Mon, Nov 17, 2025 at 09:15:27AM +0000, Marc Zyngier wrote:
> FEAT_NV2 is pretty terrible for anything that tries to enforce immediate
> effects, and writing to ICH_HCR_EL2 in the hope to disable a maintenance
> interrupt is vain. This only hits memory, and the guest hasn't cleared
> anything -- the MI will fire.
> 
> For example, running the vgic_irq test under NV results in about 800
> maintenance interrupts being actually handled by the L1 guest,
> when none were expected.
> 
> As a cheap workaround, read back ICH_MISR_EL2 after writing 0 to
> ICH_HCR_EL2. This is very cheap on real HW, and causes a trap to
> the host in NV, giving it the opportunity to retire the pending
> MI. With this, the above test tuns to completion without any MI
> being actually handled.

Just to make sure I'm following, the scenario you're talking about is
we've already put the vgic into a non-nested state, populated an LR with
the pending MI at the time of that switch and L0 has no signal for when
it can drop the LR / pending state.

> Yes, this is really poor...

+1 :-/

> Signed-off-by: Marc Zyngier <maz@kernel.org>
> ---
>  arch/arm64/kvm/hyp/vgic-v3-sr.c      | 7 +++++++
>  arch/arm64/kvm/vgic/vgic-v3-nested.c | 6 ++++--
>  2 files changed, 11 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/arm64/kvm/hyp/vgic-v3-sr.c b/arch/arm64/kvm/hyp/vgic-v3-sr.c
> index 99342c13e1794..f503cf01ac82c 100644
> --- a/arch/arm64/kvm/hyp/vgic-v3-sr.c
> +++ b/arch/arm64/kvm/hyp/vgic-v3-sr.c
> @@ -244,6 +244,13 @@ void __vgic_v3_save_state(struct vgic_v3_cpu_if *cpu_if)
>  	}
>  
>  	write_gicreg(0, ICH_HCR_EL2);
> +
> +	/*
> +	 * Hack alert: On NV, this results in a trap so that the above
> +	 * write actually takes effect...
> +	 */
> +	isb();
> +	read_gicreg(ICH_MISR_EL2);

I'm all for writing correct code but since we don't actually care about
the value of MISR_EL2 do we need the ISB? There's no need for a CSE for
non-NV and you'd get it 'for free' by way of exception entry in the NV
case.

Thanks,
Oliver

