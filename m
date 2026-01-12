Return-Path: <kvm+bounces-67775-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 071CFD13EAB
	for <lists+kvm@lfdr.de>; Mon, 12 Jan 2026 17:13:51 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 5A9D7302D2B8
	for <lists+kvm@lfdr.de>; Mon, 12 Jan 2026 16:13:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AB8773644BB;
	Mon, 12 Jan 2026 16:13:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.b="OSvlSmdV"
X-Original-To: kvm@vger.kernel.org
Received: from sinmsgout01.his.huawei.com (sinmsgout01.his.huawei.com [119.8.177.36])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D577F34888D
	for <kvm@vger.kernel.org>; Mon, 12 Jan 2026 16:13:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=119.8.177.36
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768234421; cv=none; b=qVowuSrTsEbQ1At30WQhRcSBmUNxw6nQcLI10Azzox2kkp8MmXUegMVADBAkzY23sYQoEJlnE166L3N7FrRlx5R64C6u7wy4IKx1s26Wn7doGdefYUP/dnfQ40dZng3rPzO8hsxJlnTl3TAuP47eH/teZKpjREwPsPlwUcJ2xVo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768234421; c=relaxed/simple;
	bh=vetJfgc0HSSF3t92PiEch3PcDDZVgeuQiLBue8sq5AY=;
	h=Date:From:To:CC:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=oIdxrbbcHuzyQxzWmq00GqA8HHqnUi4ApThRErGflcUVZfoZO2lbaWEqZLH1FHOt4p8TGcssrcLalPBelBYInTEDVwFzZBnJtF6HpYIOqOjtjjIsNtcpeVmMvnDPVy2R4spAPSZEBmYELh8PIvON03Gcyxz0rLLSTMjuV0dG7NU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.b=OSvlSmdV; arc=none smtp.client-ip=119.8.177.36
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=ZvOCJQuMSs88CStKELkh22tgTIoolw6z0EpAPZ1ydeM=;
	b=OSvlSmdVfGdSJK1efTbkNH+Y1MOw4bLUhDs/wxp11Qzlw7s+7S7lxUXoqyeJ95oKd5WX7aZxI
	tQolX3lDQcvE32s+1FJHcxWNm6lqw9daG3SndIUt/FsXZ8wxLOTZjyBuEYvL9d6AQTYHBtytUM0
	d4N8F0Gsi3Q9abfTIA8xF+A=
Received: from frasgout.his.huawei.com (unknown [172.18.146.32])
	by sinmsgout01.his.huawei.com (SkyGuard) with ESMTPS id 4dqcn73WGpz1P7kf;
	Tue, 13 Jan 2026 00:11:07 +0800 (CST)
Received: from mail.maildlp.com (unknown [172.18.224.150])
	by frasgout.his.huawei.com (SkyGuard) with ESMTPS id 4dqcqb2P6NzHnGgr;
	Tue, 13 Jan 2026 00:13:15 +0800 (CST)
Received: from dubpeml100005.china.huawei.com (unknown [7.214.146.113])
	by mail.maildlp.com (Postfix) with ESMTPS id 98B704056B;
	Tue, 13 Jan 2026 00:13:31 +0800 (CST)
Received: from localhost (10.203.177.15) by dubpeml100005.china.huawei.com
 (7.214.146.113) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.36; Mon, 12 Jan
 2026 16:13:30 +0000
Date: Mon, 12 Jan 2026 16:13:29 +0000
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
Subject: Re: [PATCH v3 21/36] KVM: arm64: gic-v5: Check for pending PPIs
Message-ID: <20260112161329.000063dc@huawei.com>
In-Reply-To: <20260109170400.1585048-22-sascha.bischoff@arm.com>
References: <20260109170400.1585048-1-sascha.bischoff@arm.com>
	<20260109170400.1585048-22-sascha.bischoff@arm.com>
X-Mailer: Claws Mail 4.3.0 (GTK 3.24.42; x86_64-w64-mingw32)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: lhrpeml500009.china.huawei.com (7.191.174.84) To
 dubpeml100005.china.huawei.com (7.214.146.113)

On Fri, 9 Jan 2026 17:04:46 +0000
Sascha Bischoff <Sascha.Bischoff@arm.com> wrote:

> This change allows KVM to check for pending PPI interrupts. This has
> two main components:
> 
> First of all, the effective priority mask is calculated.  This is a
> combination of the priority mask in the VPEs ICC_PCR_EL1.PRIORITY and
> the currently running priority as determined from the VPE's
> ICH_APR_EL1. If an interrupt's priority is greater than or equal to
> the effective priority mask, it can be signalled. Otherwise, it
> cannot.
> 
> Secondly, any Enabled and Pending PPIs must be checked against this
> compound priority mask. The reqires the PPI priorities to by synced
> back to the KVM shadow state - this is skipped in general operation as
> it isn't required and is rather expensive. If any Enabled and Pending
> PPIs are of sufficient priority to be signalled, then there are
> pending PPIs. Else, there are not.  This ensures that a VPE is not
> woken when it cannot actually process the pending interrupts.
> 
> Signed-off-by: Sascha Bischoff <sascha.bischoff@arm.com>
> Reviewed-by: Joey Gouly <joey.gouly@arm.com>
Trivial suggestions below.  Assuming you'll tidy up the wrap, the other one
is more of an observation than something I particularly care about.

Reviewed-by: Jonathan Cameron <jonathan.cameron@huawei.com>


> ---
>  arch/arm64/kvm/vgic/vgic-v5.c | 133 ++++++++++++++++++++++++++++++++++
>  arch/arm64/kvm/vgic/vgic.c    |   3 +
>  arch/arm64/kvm/vgic/vgic.h    |   1 +
>  3 files changed, 137 insertions(+)
> 
> diff --git a/arch/arm64/kvm/vgic/vgic-v5.c b/arch/arm64/kvm/vgic/vgic-v5.c
> index c1899add8f5c3..3e2a01e3008c4 100644
> --- a/arch/arm64/kvm/vgic/vgic-v5.c
> +++ b/arch/arm64/kvm/vgic/vgic-v5.c


>  static bool vgic_v5_ppi_set_pending_state(struct kvm_vcpu *vcpu,
>  					  struct vgic_irq *irq)
>  {
> @@ -216,6 +239,112 @@ void vgic_v5_set_ppi_ops(struct vgic_irq *irq)
>  		irq->ops = &vgic_v5_ppi_irq_ops;
>  }
>  
> +/*
> + * Sync back the PPI priorities to the vgic_irq shadow state for any interrupts
> + * exposed to the guest (skipping all others).
> + */
> +static void vgic_v5_sync_ppi_priorities(struct kvm_vcpu *vcpu)
> +{
> +	struct vgic_v5_cpu_if *cpu_if = &vcpu->arch.vgic_cpu.vgic_v5;
> +	u64 priorityr;
> +
> +	/*
> +	 * We have 16 PPI Priority regs, but only have a few interrupts that the
> +	 * guest is allowed to use. Limit our sync of PPI priorities to those
> +	 * actually exposed to the guest by first iterating over the mask of
> +	 * exposed PPIs.
> +	 */
> +	for (int mask_reg = 0; mask_reg < 2; mask_reg++) {
> +		unsigned long *p;
> +		int i;
> +
> +		p = (unsigned long *)&vcpu->kvm->arch.vgic.gicv5_vm.vgic_ppi_mask[mask_reg];

Following is minor, but maybe worth some more thought:

Even though it's silly I'd be tempted to avoid that cast via

		unsigned long bm_p = 0;

		bitmap_from_arr64(&bm_p,
				  &vcpu->kvm->arch.vgic.gicv5_vm.vgic_ppi_mask[mask_reg],
//consider a local variable for this!
				  64);
		for_each_set_bit(i, bm_p, 64) {
		}

which compiler should be able to collapse to a simple u64 assignment.

> +
> +		for_each_set_bit(i, p, 64) {
> +			struct vgic_irq *irq;
> +			int pri_idx, pri_reg;
> +			u32 intid;
> +			u8 priority;
> +
> +			pri_reg = (mask_reg * 64 + i) / 8;
> +			pri_idx = (mask_reg * 64 + i) % 8;
> +
> +			priorityr = cpu_if->vgic_ppi_priorityr[pri_reg];
> +			priority = (priorityr >> (pri_idx * 8)) & GENMASK(4, 0);
> +
> +			intid = FIELD_PREP(GICV5_HWIRQ_TYPE, GICV5_HWIRQ_TYPE_PPI);
> +			intid |= FIELD_PREP(GICV5_HWIRQ_ID, mask_reg * 64 + i);
> +
> +			irq = vgic_get_vcpu_irq(vcpu, intid);
> +
> +			scoped_guard(raw_spinlock_irqsave, &irq->irq_lock)
> +				irq->priority = priority;
> +
> +			vgic_put_irq(vcpu->kvm, irq);
> +		}
> +	}
> +}
> +
> +bool vgic_v5_has_pending_ppi(struct kvm_vcpu *vcpu)
> +{
> +	struct vgic_v5_cpu_if *cpu_if = &vcpu->arch.vgic_cpu.vgic_v5;
> +	unsigned int priority_mask;
> +
> +	/* If no pending bits are set, exit early */
> +	if (!cpu_if->vgic_ppi_pendr[0] && !cpu_if->vgic_ppi_pendr[1])
> +		return false;
> +
> +	priority_mask = vgic_v5_get_effective_priority_mask(vcpu);
> +
> +	/* If the combined priority mask is 0, nothing can be signalled! */
> +	if (!priority_mask)
> +		return false;
> +
> +	for (int reg = 0; reg < 2; reg++) {
> +		const u64 enabler = cpu_if->vgic_ppi_enabler[reg];
> +		const u64 pendr = cpu_if->vgic_ppi_pendr[reg];
> +		unsigned long possible_bits;
> +		int i;
> +
> +		/* Check all interrupts that are enabled and pending */
> +		possible_bits = enabler & pendr;
> +
> +		/*
> +		 * Optimisation: pending and enabled with no active priorities
> +		 */
> +		if (possible_bits && priority_mask == 32)
> +			return true;
> +
> +		for_each_set_bit(i, &possible_bits, 64) {
> +			bool has_pending = false;
> +			struct vgic_irq *irq;
> +			u32 intid;
> +
> +			intid = FIELD_PREP(GICV5_HWIRQ_TYPE, GICV5_HWIRQ_TYPE_PPI);
> +			intid |= FIELD_PREP(GICV5_HWIRQ_ID, reg * 64 + i);
> +
> +			irq = vgic_get_vcpu_irq(vcpu, intid);
> +
> +			scoped_guard(raw_spinlock_irqsave, &irq->irq_lock) {
> +				/*
> +				 * We know that the interrupt is
short wrap. This could be

				/*
				 * We know that the interrupt is enabled and
				 * pending, so only check the priority.
> +				 */

> +				 * enabled and pending, so only check
> +				 * the priority.
> +				 */
> +				if (irq->priority <= priority_mask)
> +					has_pending = true;
> +			}
> +
> +			vgic_put_irq(vcpu->kvm, irq);
> +
> +			if (has_pending)
> +				return true;
> +		}
> +	}
> +
> +	return false;
> +}
> +

