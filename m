Return-Path: <kvm+bounces-67755-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [104.64.211.4])
	by mail.lfdr.de (Postfix) with ESMTPS id 5E297D12F84
	for <lists+kvm@lfdr.de>; Mon, 12 Jan 2026 15:00:30 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id DADEA3002511
	for <lists+kvm@lfdr.de>; Mon, 12 Jan 2026 14:00:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2D01735C1AE;
	Mon, 12 Jan 2026 14:00:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.b="dsO1e1XR"
X-Original-To: kvm@vger.kernel.org
Received: from sinmsgout03.his.huawei.com (sinmsgout03.his.huawei.com [119.8.177.38])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 26A3F35C18D
	for <kvm@vger.kernel.org>; Mon, 12 Jan 2026 14:00:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=119.8.177.38
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768226425; cv=none; b=vBxRlTq+IB4sfu2+IZzf+PjXL8fCjOUmLbFALdG8PjDAFbD3FTUV5gHi2fUhpWvCHYyQhng/OZmUTjnOsXF6GAzWxuZDbNxRhcqHow8lnIfqhL/XY3b3+9KdZXLm0Y9uIyZqsgI8+hdnouadcRvFpgKlkpSv4Z6/xVKK3zrbhb4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768226425; c=relaxed/simple;
	bh=3MT4Xsc9hZxg9Bfzk6ao/9mOa/O7jVs+XEctOSCEZWc=;
	h=Date:From:To:CC:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=LtHPwCqmBaNiGGyo/bol3/aDHBIBTPD0dcgFrJGBR4dFWfRkNIe/A9o/L2GtrIaOFZxX26Dq34Vd1jva2F8pnPxr2p5YQNZZInI1sT+/R6dq8Lg8UWZEW9QOqTi9SFe17ovL9bVb9UR4tbrwalX2raD+AP+RYLKxU/YdBOghjhs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.b=dsO1e1XR; arc=none smtp.client-ip=119.8.177.38
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=1QDz37KWIrGKJmQRekuQKacEiOZ1Lh9GBBMBkejVJro=;
	b=dsO1e1XRukv1/4C1Ssa5Dt7L+oNZgx+wsDpv1BD/+3tYI7wsWgnkFE9a8ZWtf22ug5Y6wYg16
	CWKdyMt8QDhg8efVl8MXtHdrlKm5DoIUwXNqtvoB8NSzZ8XpEzqkyO7eBAToCFNFu3oEUV4+AYZ
	k1g2pbfBy2MCLh+tJlMVbxc=
Received: from frasgout.his.huawei.com (unknown [172.18.146.33])
	by sinmsgout03.his.huawei.com (SkyGuard) with ESMTPS id 4dqYqT5k00zMyRj;
	Mon, 12 Jan 2026 21:57:57 +0800 (CST)
Received: from mail.maildlp.com (unknown [172.18.224.107])
	by frasgout.his.huawei.com (SkyGuard) with ESMTPS id 4dqYsp4tH5zJ46F2;
	Mon, 12 Jan 2026 21:59:58 +0800 (CST)
Received: from dubpeml100005.china.huawei.com (unknown [7.214.146.113])
	by mail.maildlp.com (Postfix) with ESMTPS id 2673C40585;
	Mon, 12 Jan 2026 22:00:10 +0800 (CST)
Received: from localhost (10.203.177.15) by dubpeml100005.china.huawei.com
 (7.214.146.113) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.36; Mon, 12 Jan
 2026 14:00:09 +0000
Date: Mon, 12 Jan 2026 14:00:07 +0000
From: Jonathan Cameron <jonathan.cameron@huawei.com>
To: Sascha Bischoff <Sascha.Bischoff@arm.com>
CC: "linux-arm-kernel@lists.infradead.org"
	<linux-arm-kernel@lists.infradead.org>, "kvmarm@lists.linux.dev"
	<kvmarm@lists.linux.dev>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>, nd
	<nd@arm.com>, "maz@kernel.org" <maz@kernel.org>, "oliver.upton@linux.dev"
	<oliver.upton@linux.dev>, Joey Gouly <Joey.Gouly@arm.com>, Suzuki Poulose
	<Suzuki.Poulose@arm.com>, "yuzenghui@huawei.com" <yuzenghui@huawei.com>,
	"peter.maydell@linaro.org" <peter.maydell@linaro.org>,
	"lpieralisi@kernel.org" <lpieralisi@kernel.org>, Timothy Hayes
	<Timothy.Hayes@arm.com>
Subject: Re: [PATCH v3 02/36] KVM: arm64: gic-v3: Switch vGIC-v3 to use
 generated ICH_VMCR_EL2
Message-ID: <20260112140007.00002391@huawei.com>
In-Reply-To: <20260109170400.1585048-3-sascha.bischoff@arm.com>
References: <20260109170400.1585048-1-sascha.bischoff@arm.com>
	<20260109170400.1585048-3-sascha.bischoff@arm.com>
X-Mailer: Claws Mail 4.3.0 (GTK 3.24.42; x86_64-w64-mingw32)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: lhrpeml100009.china.huawei.com (7.191.174.83) To
 dubpeml100005.china.huawei.com (7.214.146.113)

On Fri, 9 Jan 2026 17:04:39 +0000
Sascha Bischoff <Sascha.Bischoff@arm.com> wrote:

> From: Sascha Bischoff <Sascha.Bischoff@arm.com>
> 
> The VGIC-v3 code relied on hand-written definitions for the
> ICH_VMCR_EL2 register. This register, and the associated fields, is
> now generated as part of the sysreg framework. Move to using the
> generated definitions instead of the hand-written ones.
> 
> There are no functional changes as part of this change.
> 
> Signed-off-by: Sascha Bischoff <sascha.bischoff@arm.com>

Hi Sascha,

A couple of trivial things inline that you can feel free to ignore.
Reviewed-by: Jonathan Cameron <jonathan.cameron@huawei.com>

> ---
>  arch/arm64/include/asm/sysreg.h      | 21 ---------
>  arch/arm64/kvm/hyp/vgic-v3-sr.c      | 68 ++++++++++------------------
>  arch/arm64/kvm/vgic/vgic-v3-nested.c |  8 ++--
>  arch/arm64/kvm/vgic/vgic-v3.c        | 48 +++++++++-----------
>  4 files changed, 50 insertions(+), 95 deletions(-)

> diff --git a/arch/arm64/kvm/hyp/vgic-v3-sr.c b/arch/arm64/kvm/hyp/vgic-v3-sr.c
> index 0b670a033fd87..ff10fc71fcd5d 100644
> --- a/arch/arm64/kvm/hyp/vgic-v3-sr.c
> +++ b/arch/arm64/kvm/hyp/vgic-v3-sr.c


> @@ -1064,9 +1047,10 @@ static void __vgic_v3_read_ctlr(struct kvm_vcpu *vcpu, u32 vmcr, int rt)
>  	/* A3V */
>  	val |= ((vtr >> 21) & 1) << ICC_CTLR_EL1_A3V_SHIFT;
>  	/* EOImode */
> -	val |= ((vmcr & ICH_VMCR_EOIM_MASK) >> ICH_VMCR_EOIM_SHIFT) << ICC_CTLR_EL1_EOImode_SHIFT;
> +	val |= FIELD_PREP(ICC_CTLR_EL1_EOImode_MASK,
> +			  FIELD_GET(ICH_VMCR_EL2_VEOIM, vmcr));
>  	/* CBPR */
> -	val |= (vmcr & ICH_VMCR_CBPR_MASK) >> ICH_VMCR_CBPR_SHIFT;
> +	val |= FIELD_GET(ICH_VMCR_EL2_VCBPR, vmcr);

This one makes me a tiny bit nervous because it's not obvious that this
is kind of FIELD_PREP(FIELD_GET()) like the EOIMode above.

Only a tiny bit though, so it's fine as is.


>  
>  	vcpu_set_reg(vcpu, rt, val);
>  }
> @@ -1075,15 +1059,11 @@ static void __vgic_v3_write_ctlr(struct kvm_vcpu *vcpu, u32 vmcr, int rt)
>  {
>  	u32 val = vcpu_get_reg(vcpu, rt);
>  
> -	if (val & ICC_CTLR_EL1_CBPR_MASK)
> -		vmcr |= ICH_VMCR_CBPR_MASK;
> -	else
> -		vmcr &= ~ICH_VMCR_CBPR_MASK;
> +	FIELD_MODIFY(ICH_VMCR_EL2_VCBPR, &vmcr,
> +		     FIELD_GET(ICC_CTLR_EL1_CBPR_MASK, val));

I'm not laughing at all and the _MASK here because that header
only defines the MASK form, even for single bits :)


>  
> -	if (val & ICC_CTLR_EL1_EOImode_MASK)
> -		vmcr |= ICH_VMCR_EOIM_MASK;
> -	else
> -		vmcr &= ~ICH_VMCR_EOIM_MASK;
> +	FIELD_MODIFY(ICH_VMCR_EL2_VEOIM, &vmcr,
> +		     FIELD_GET(ICC_CTLR_EL1_EOImode_MASK, val));
>  
>  	write_gicreg(vmcr, ICH_VMCR_EL2);
>  }

