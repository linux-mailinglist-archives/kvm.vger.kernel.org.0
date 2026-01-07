Return-Path: <kvm+bounces-67221-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id E1CD2CFDA6D
	for <lists+kvm@lfdr.de>; Wed, 07 Jan 2026 13:26:54 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id EC3AF3043231
	for <lists+kvm@lfdr.de>; Wed,  7 Jan 2026 12:22:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7FF2C315D2A;
	Wed,  7 Jan 2026 12:22:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.b="1VRyJ+0B"
X-Original-To: kvm@vger.kernel.org
Received: from sinmsgout01.his.huawei.com (sinmsgout01.his.huawei.com [119.8.177.36])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A1561315D24
	for <kvm@vger.kernel.org>; Wed,  7 Jan 2026 12:22:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=119.8.177.36
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767788532; cv=none; b=X2TEjqRcKlIV/iO0yHg++IFK7StPt1Fl7uoQuo3jHyuguSwjX2cMoy4iu8nhep9FuNgDENXJP/b2HHWoaTwp4ICTnjn9udSOxv/P9VMZLeqBPRHVbrNqGK88/ZZcECLNVohTvZTx9herW0vhZ7Ymq72bR41+SfxayWVhIVKTYDw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767788532; c=relaxed/simple;
	bh=p7UYyZxC4uKCcyOUBAcr3iUz7F5ptluIAzWnVKY9IAE=;
	h=Date:From:To:CC:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ZHrhd+So7kNn2aPMagUMK5m1ExHwO4IjEirTPJDPyUqcHhdKitWQPXmGxoYCdVJr6SYe+1wGCRuhnkfp4NVvcI128KI1svxHFBsh0qFN5FdYmLe/QVfeBYtuyePxF6DWUoQhS/VIMqUJjn0g/m5pZaUMNQzsQj4TI3krXQsWtBY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.b=1VRyJ+0B; arc=none smtp.client-ip=119.8.177.36
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=3qyYX76QlWUIX26TwaxqltqE5qHT9hotMM6BfsYSweg=;
	b=1VRyJ+0B4zb5a96x3vwFxKCbJI3YjjVOn3TaHvt4BuD6wdqmEzpeFGcGWQj1f/eNak6eTFwG/
	mM2uVMv2ZcL/TkAS1Fx479HMdy7LHOgv702e6IKcg7OLwdmLE+15WFd0BY/uJZl1UxvKmzJXMPm
	vZ60TdQ5GD/L8a2aZWgMzWY=
Received: from frasgout.his.huawei.com (unknown [172.18.146.32])
	by sinmsgout01.his.huawei.com (SkyGuard) with ESMTPS id 4dmRtN1S47z1P7PT;
	Wed,  7 Jan 2026 20:19:40 +0800 (CST)
Received: from mail.maildlp.com (unknown [172.18.224.83])
	by frasgout.his.huawei.com (SkyGuard) with ESMTPS id 4dmRx11LFYzHnH4x;
	Wed,  7 Jan 2026 20:21:57 +0800 (CST)
Received: from dubpeml100005.china.huawei.com (unknown [7.214.146.113])
	by mail.maildlp.com (Postfix) with ESMTPS id 4BBD240086;
	Wed,  7 Jan 2026 20:22:03 +0800 (CST)
Received: from localhost (10.203.177.15) by dubpeml100005.china.huawei.com
 (7.214.146.113) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.36; Wed, 7 Jan
 2026 12:22:02 +0000
Date: Wed, 7 Jan 2026 12:22:00 +0000
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
Subject: Re: [PATCH v2 17/36] KVM: arm64: gic: Introduce irq_queue and
 set_pending_state to irq_ops
Message-ID: <20260107122200.00004455@huawei.com>
In-Reply-To: <20251219155222.1383109-18-sascha.bischoff@arm.com>
References: <20251219155222.1383109-1-sascha.bischoff@arm.com>
	<20251219155222.1383109-18-sascha.bischoff@arm.com>
X-Mailer: Claws Mail 4.3.0 (GTK 3.24.42; x86_64-w64-mingw32)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: lhrpeml500011.china.huawei.com (7.191.174.215) To
 dubpeml100005.china.huawei.com (7.214.146.113)

On Fri, 19 Dec 2025 15:52:41 +0000
Sascha Bischoff <Sascha.Bischoff@arm.com> wrote:

> There are times when the default behaviour of vgic_queue_irq_unlock is

Nice to make function names explicit in a patch description by using
vgic_queue_irq_unlock() style. Some subsystems insist we do that in commit
descriptions. No idea if kvm does though.

> undesirable. This is because some GICs, such a GICv5 which is the main
> driver for this change, handle the majority of the interrupt lifecycle
> in hardware. In this case, there is no need for a per-VCPU AP list as
> the interrupt can be made pending directly. This is done either via
> the ICH_PPI_x_EL2 registers for PPIs, or with the VDPEND system
> instruction for SPIs and LPIs.
> 
> The queue_irq_unlock function is made overridable using a new function
> pointer in struct irq_ops. In kvm_vgic_inject_irq,
> vgic_queue_irq_unlock is overridden if the function pointer is
> non-null.
> 
> Additionally, a new function is added via a function pointer -
> set_pending_state. The intent is for this to be used to directly set
> the pending state in hardware.
> 
> Both of these new irq_ops are unused in this change - it is purely
> providing the infrastructure itself. The subsequent PPI injection
> changes provide a demonstration of their usage.
> 
> Signed-off-by: Sascha Bischoff <sascha.bischoff@arm.com>

Trivial stuff only.

Reviewed-by: Jonathan Cameron <jonathan.cameron@huawei.com>

> ---
>  arch/arm64/kvm/vgic/vgic.c | 11 +++++++++++
>  include/kvm/arm_vgic.h     | 15 +++++++++++++++
>  2 files changed, 26 insertions(+)
> 
> diff --git a/arch/arm64/kvm/vgic/vgic.c b/arch/arm64/kvm/vgic/vgic.c
> index d88570bb2f9f0..ac8cb0270e1e4 100644
> --- a/arch/arm64/kvm/vgic/vgic.c
> +++ b/arch/arm64/kvm/vgic/vgic.c
> @@ -404,6 +404,13 @@ bool vgic_queue_irq_unlock(struct kvm *kvm, struct vgic_irq *irq,
>  
>  	lockdep_assert_held(&irq->irq_lock);
>  
> +	/*
> +	 * If we have the queue_irq_unlock irq_op, we want to override
> +	 * the default behaviour. Call that, and return early.

I'd say this comment is really just saying what the code clearly does
so provides not benefit. So drop it.

> +	 */
> +	if (irq->ops && irq->ops->queue_irq_unlock)
> +		return irq->ops->queue_irq_unlock(kvm, irq, flags);
> +
>  retry:
>  	vcpu = vgic_target_oracle(irq);
>  	if (irq->vcpu || !vcpu) {
> @@ -547,7 +554,11 @@ int kvm_vgic_inject_irq(struct kvm *kvm, struct kvm_vcpu *vcpu,
>  	else
>  		irq->pending_latch = true;
>  
> +	if (irq->ops && irq->ops->set_pending_state)
> +		WARN_ON_ONCE(!irq->ops->set_pending_state(vcpu, irq));
> +
>  	vgic_queue_irq_unlock(kvm, irq, flags);
> +
Reasonable change, for readability but not relevant to this patch, so don't
do it here.

>  	vgic_put_irq(kvm, irq);
>  
>  	return 0;
> diff --git a/include/kvm/arm_vgic.h b/include/kvm/arm_vgic.h



