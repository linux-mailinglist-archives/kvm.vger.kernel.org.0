Return-Path: <kvm+bounces-67225-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 4BE84CFDC7D
	for <lists+kvm@lfdr.de>; Wed, 07 Jan 2026 13:56:35 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 1F6383024E48
	for <lists+kvm@lfdr.de>; Wed,  7 Jan 2026 12:50:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 420C931A55F;
	Wed,  7 Jan 2026 12:50:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.b="EM0bNlUo"
X-Original-To: kvm@vger.kernel.org
Received: from sinmsgout02.his.huawei.com (sinmsgout02.his.huawei.com [119.8.177.37])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2C2D51EB1AA
	for <kvm@vger.kernel.org>; Wed,  7 Jan 2026 12:50:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=119.8.177.37
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767790218; cv=none; b=jrxHTDRFE3C4GxzGrPPq+Cj/ZX1MhXgtCZpYQ1p5qEUneWCDzSYIk38g/Vf9lRuSoMgRIvDKAD1DuTgHLXoKifgiOW714R5YLGXNc2I7nxYitQbHrKSKbKi3C5mRbpShATMuiIPEtiLbxPNt6uEKQRhcjQR846Uwkoew4nVx4zY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767790218; c=relaxed/simple;
	bh=h4SDbZXi20v+1B+H4vjYJEdLHCytOLnr5R+tik99ZG8=;
	h=Date:From:To:CC:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Glwj9YF11s5EOAH8aWVwYqY3qgrvtvsKitmf1L9JVka1s5z4S9qGR9ExYjS72hlozcAS0lQYrUWv+xoCo6i/3zkuuGr6qGzTog9yKOQHx6NZKlamzm/v6eQXAEeA2ZqXD5GmVzS5RpeTCrTt6zUyIV/swBShbjHSNx7BxYNMLdg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.b=EM0bNlUo; arc=none smtp.client-ip=119.8.177.37
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=tHSrZXqTclvnCa4GZfb7eNQ5vNhESQnZrK3L8ntXphs=;
	b=EM0bNlUocvKvjhjCoZ2Gad/Wz8EGPsQ1QLv4h5+wFvfSfD6QgqKa4xib9r1fY/1Do3jaEtG+S
	j89Mrsf1gXnR9jsLR5GXXrLWerCG+wpoGFfVPXIRUJACvqAIX31auLhdcItgSuisQAUddfGLJS4
	Tfa0GrYANFzTxwEDP6IKRus=
Received: from frasgout.his.huawei.com (unknown [172.18.146.32])
	by sinmsgout02.his.huawei.com (SkyGuard) with ESMTPS id 4dmSW44YNbz1vp50;
	Wed,  7 Jan 2026 20:48:00 +0800 (CST)
Received: from mail.maildlp.com (unknown [172.18.224.107])
	by frasgout.his.huawei.com (SkyGuard) with ESMTPS id 4dmSYP3JcKzHnGk2;
	Wed,  7 Jan 2026 20:50:01 +0800 (CST)
Received: from dubpeml100005.china.huawei.com (unknown [7.214.146.113])
	by mail.maildlp.com (Postfix) with ESMTPS id 9777F40571;
	Wed,  7 Jan 2026 20:50:07 +0800 (CST)
Received: from localhost (10.203.177.15) by dubpeml100005.china.huawei.com
 (7.214.146.113) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.36; Wed, 7 Jan
 2026 12:50:06 +0000
Date: Wed, 7 Jan 2026 12:50:05 +0000
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
Subject: Re: [PATCH v2 18/36] KVM: arm64: gic-v5: Implement PPI interrupt
 injection
Message-ID: <20260107125005.000056dc@huawei.com>
In-Reply-To: <20251219155222.1383109-19-sascha.bischoff@arm.com>
References: <20251219155222.1383109-1-sascha.bischoff@arm.com>
	<20251219155222.1383109-19-sascha.bischoff@arm.com>
X-Mailer: Claws Mail 4.3.0 (GTK 3.24.42; x86_64-w64-mingw32)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: lhrpeml100011.china.huawei.com (7.191.174.247) To
 dubpeml100005.china.huawei.com (7.214.146.113)

On Fri, 19 Dec 2025 15:52:42 +0000
Sascha Bischoff <Sascha.Bischoff@arm.com> wrote:

> This change introduces interrupt injection for PPIs for GICv5-based
> guests.
> 
> The lifecycle of PPIs is largely managed by the hardware for a GICv5
> system. The hypervisor injects pending state into the guest by using
> the ICH_PPI_PENDRx_EL2 registers. These are used by the hardware to
> pick a Highest Priority Pending Interrupt (HPPI) for the guest based
> on the enable state of each individual interrupt. The enable state and
> priority for each interrupt are provided by the guest itself (through
> writes to the PPI registers).
> 
> When Direct Virtual Interrupt (DVI) is set for a particular PPI, the
> hypervisor is even able to skip the injection of the pending state
> altogether - it all happens in hardware.
> 
> The result of the above is that no AP lists are required for GICv5,
> unlike for older GICs. Instead, for PPIs the ICH_PPI_* registers
> fulfil the same purpose for all 128 PPIs. Hence, as long as the
> ICH_PPI_* registers are populated prior to guest entry, and merged
> back into the KVM shadow state on exit, the PPI state is preserved,
> and interrupts can be injected.
> 
> When injecting the state of a PPI the state is merged into the KVM's
> shadow state using the set_pending_state irq_op. The directly sets the
> relevant bit in the shadow ICH_PPI_PENDRx_EL2, which is presented to
> the guest (and GICv5 hardware) on next guest entry. The
> queue_irq_unlock irq_op is required to kick the vCPU to ensure that it
> seems the new state. The result is that no AP lists are used for
> private interrupts on GICv5.
> 
> Prior to entering the guest, vgic_v5_flush_ppi_state is called from
> kvm_vgic_flush_hwstate. The effectively snapshots the shadow PPI
> pending state (twice - an entry and an exit copy) in order to track
> any changes. These changes can come from a guest consuming an
> interrupt or from a guest making an Edge-triggered interrupt pending.
> 
> When returning from running a guest, the guest's PPI state is merged
> back into KVM's shadow state in vgic_v5_merge_ppi_state from
> kvm_vgic_sync_hwstate. The Enable and Active state is synced back for
> all PPIs, and the pending state is synced back for Edge PPIs (Level is
> driven directly by the devices generating said levels). The incoming
> pending state from the guest is merged with KVM's shadow state to
> avoid losing any incoming interrupts.
> 
> Signed-off-by: Sascha Bischoff <sascha.bischoff@arm.com>
Minor things inline

> ---
>  arch/arm64/kvm/vgic/vgic-v5.c | 159 ++++++++++++++++++++++++++++++++++
>  arch/arm64/kvm/vgic/vgic.c    |  46 +++++++---
>  arch/arm64/kvm/vgic/vgic.h    |  47 ++++++++--
>  include/kvm/arm_vgic.h        |   3 +
>  4 files changed, 235 insertions(+), 20 deletions(-)
> 
> diff --git a/arch/arm64/kvm/vgic/vgic-v5.c b/arch/arm64/kvm/vgic/vgic-v5.c
> index 46c70dfc7bb08..cb3dd872d16a6 100644
> --- a/arch/arm64/kvm/vgic/vgic-v5.c
> +++ b/arch/arm64/kvm/vgic/vgic-v5.c
> @@ -56,6 +56,165 @@ int vgic_v5_probe(const struct gic_kvm_info *info)
>  	return 0;
>  }
>  
> +static bool vgic_v5_ppi_set_pending_state(struct kvm_vcpu *vcpu,
> +					  struct vgic_irq *irq)
> +{
> +	struct vgic_v5_cpu_if *cpu_if;
> +	const u64 id_bit = BIT_ULL(irq->intid % 64);

Obviously the % 64 means other bits of irq->intid above the HWIRQ_ID
field don't matter, but this still seems a little odd.  I'd extract
the field first, then use that for the reg and id_bit or just
do those inline where they are used.

	const u32 hwirq_id = FIELD_GET(GICV5_HWIRQ_ID, irq->intid);

	if (irq_is_pending(irq))
		cpu_if->vgic_ppi_pendr[hwirq_id / 64] |= hwirq_id % 64;
..

Which matches style you used for similar cases in earlier patches.

> +	const u32 reg = FIELD_GET(GICV5_HWIRQ_ID, irq->intid) / 64;
> +
> +	if (!vcpu || !irq)
> +		return false;
> +
> +	/* Skip injecting the state altogether */
> +	if (irq->directly_injected)
> +		return true;
> +
> +	cpu_if = &vcpu->arch.vgic_cpu.vgic_v5;
> +
> +	if (irq_is_pending(irq))
> +		cpu_if->vgic_ppi_pendr[reg] |= id_bit;
> +	else
> +		cpu_if->vgic_ppi_pendr[reg] &= ~id_bit;
> +
> +	return true;
> +}


> +void vgic_v5_set_ppi_ops(struct vgic_irq *irq)
> +{
> +	if (WARN_ON(!irq))
> +		return;
> +
> +	scoped_guard(raw_spinlock, &irq->irq_lock) {
Not checked on for whether code ends up outside this lock. If not
use a guard(raw_spinlock)(&irq->irq_lock);

> +		if (!WARN_ON(irq->ops))
> +			irq->ops = &vgic_v5_ppi_irq_ops;
> +	}
> +}
> +
> +/*
> + * Detect any PPIs state changes, and propagate the state with KVM's
> + * shadow structures.
> + */
> +void vgic_v5_fold_ppi_state(struct kvm_vcpu *vcpu)
> +{
> +	struct vgic_v5_cpu_if *cpu_if = &vcpu->arch.vgic_cpu.vgic_v5;
> +	int i, reg;
> +
> +	for (reg = 0; reg < 2; reg++) {
It's now considered fine to declare loop variables in the loop and always
nice to limit their scope.

	for (int reg = 0; reg < 2...

> +		unsigned long changed_bits;
> +		const unsigned long enabler = cpu_if->vgic_ich_ppi_enabler_exit[reg];
> +		const unsigned long activer = cpu_if->vgic_ppi_activer_exit[reg];
> +		const unsigned long pendr = cpu_if->vgic_ppi_pendr_exit[reg];

...

> +
> +void vgic_v5_flush_ppi_state(struct kvm_vcpu *vcpu)
> +{
> +	struct vgic_v5_cpu_if *cpu_if = &vcpu->arch.vgic_cpu.vgic_v5;
> +
> +	/*
> +	 * We're about to enter the guest. Copy the shadow state to the pending
> +	 * reg that will be written to the ICH_PPI_PENDRx_EL2 regs. While the
> +	 * guest is running we track any incoming changes to the pending state in
> +	 * vgic_ppi_pendr. The incoming changes are merged with the outgoing
> +	 * changes on the return path.
> +	 */
> +	cpu_if->vgic_ppi_pendr_entry[0] = cpu_if->vgic_ppi_pendr[0];
> +	cpu_if->vgic_ppi_pendr_entry[1] = cpu_if->vgic_ppi_pendr[1];
> +
> +	/*
> +	 * Make sure that we can correctly detect "edges" in the PPI
> +	 * state. There's a path where we never actually enter the guest, and
> +	 * failure to do this risks losing pending state
> +	 */
> +	cpu_if->vgic_ppi_pendr_exit[0] = cpu_if->vgic_ppi_pendr[0];
> +	cpu_if->vgic_ppi_pendr_exit[1] = cpu_if->vgic_ppi_pendr[1];
> +
Drop this blank line.

> +}

> diff --git a/arch/arm64/kvm/vgic/vgic.c b/arch/arm64/kvm/vgic/vgic.c
> index ac8cb0270e1e4..cb5d43b34462b 100644
> --- a/arch/arm64/kvm/vgic/vgic.c
> +++ b/arch/arm64/kvm/vgic/vgic.c

> @@ -258,10 +266,12 @@ struct kvm_vcpu *vgic_target_oracle(struct vgic_irq *irq)
>  	 * If the distributor is disabled, pending interrupts shouldn't be
>  	 * forwarded.
>  	 */
> -	if (irq->enabled && irq_is_pending(irq)) {
> -		if (unlikely(irq->target_vcpu &&
> -			     !irq->target_vcpu->kvm->arch.vgic.enabled))
> -			return NULL;
> +	if (irq_is_enabled(irq) && irq_is_pending(irq)) {
> +		if (irq->target_vcpu) {

Just from a readability point of view, maybe clearer to get rid of
the 'else# path for this one first.

		if (!irq->target_vcpu)
			return NULL;

		if (!vgic_is_v5(irq->target_vcpu->kvm) &&
		    unlikely(!irq->target_vcpu->kvm->arch.vgic.enabled))
			return NULL;

		return irq->target_vcpu;

Though I see this code might go away anyway...

> +			if (!vgic_is_v5(irq->target_vcpu->kvm) &&
> +			    unlikely(!irq->target_vcpu->kvm->arch.vgic.enabled))
> +				return NULL;
> +		}
>  
>  		return irq->target_vcpu;
>  	}



>  /* Flush our emulation state into the GIC hardware before entering the guest. */
>  void kvm_vgic_flush_hwstate(struct kvm_vcpu *vcpu)
>  {
> @@ -1106,13 +1131,12 @@ void kvm_vgic_flush_hwstate(struct kvm_vcpu *vcpu)
>  
>  	DEBUG_SPINLOCK_BUG_ON(!irqs_disabled());
>  
> -	scoped_guard(raw_spinlock, &vcpu->arch.vgic_cpu.ap_list_lock)
> -		vgic_flush_lr_state(vcpu);
> +	vgic_flush_state(vcpu);
>  
>  	if (can_access_vgic_from_kernel())
>  		vgic_restore_state(vcpu);
>  
> -	if (vgic_supports_direct_irqs(vcpu->kvm))
> +	if (vgic_supports_direct_irqs(vcpu->kvm) && !vgic_is_v5(vcpu->kvm))

This feels like a somewhat backwards check.
No function to check it vgic_is_v4? Similar cases elsewhere.

>  		vgic_v4_commit(vcpu);
>  }
>  
> diff --git a/arch/arm64/kvm/vgic/vgic.h b/arch/arm64/kvm/vgic/vgic.h
> index d5d9264f0a1e9..978d7f8426361 100644
> --- a/arch/arm64/kvm/vgic/vgic.h
> +++ b/arch/arm64/kvm/vgic/vgic.h
> @@ -132,6 +132,28 @@ static inline bool irq_is_pending(struct vgic_irq *irq)
>  		return irq->pending_latch || irq->line_level;
>  }
>  
> +/* Requires the irq_lock to be held by the caller. */

Can you use a lockdep notation to make that explicit?

> +static inline bool irq_is_enabled(struct vgic_irq *irq)
> +{
> +	if (irq->enabled)
> +		return true;
> +
> +	/*
> +	 * We always consider GICv5 interrupts as enabled as we can
> +	 * always inject them. The state is handled by the hardware,
> +	 * and the hardware will only signal the interrupt to the
> +	 * guest once the guest enables it.

With my fussy reviewer hat on, that's wrapped a bit early.  Go up
to 80 chars for comments.

> +	 */
> +	if (irq->target_vcpu) {
> +		u32 vgic_model = irq->target_vcpu->kvm->arch.vgic.vgic_model;
> +
> +		if (vgic_model == KVM_DEV_TYPE_ARM_VGIC_V5)
> +			return true;
> +	}
> +
> +	return false;
> +}

> diff --git a/include/kvm/arm_vgic.h b/include/kvm/arm_vgic.h
> index 500709bd62c8d..b5180edbd1165 100644
> --- a/include/kvm/arm_vgic.h
> +++ b/include/kvm/arm_vgic.h
> @@ -32,6 +32,9 @@
>  #define VGIC_MIN_LPI		8192
>  #define KVM_IRQCHIP_NUM_PINS	(1020 - 32)
>  
> +/* GICv5 constants */
> +#define VGIC_V5_NR_PRIVATE_IRQS	128

You have earlier checks against this value (there was one around PPI DVI setup 
a few patches back).  So probably better to pull the define earlier and
use it there as well?

> +
>  #define is_v5_type(t, i)	(FIELD_GET(GICV5_HWIRQ_TYPE, (i)) == (t))
>  
>  #define __irq_is_sgi(t, i)						\


