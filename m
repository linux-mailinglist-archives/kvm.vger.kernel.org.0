Return-Path: <kvm+bounces-66184-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 8182ECC8AE2
	for <lists+kvm@lfdr.de>; Wed, 17 Dec 2025 17:08:53 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id C93473061A87
	for <lists+kvm@lfdr.de>; Wed, 17 Dec 2025 15:55:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6C44C33C190;
	Wed, 17 Dec 2025 15:54:46 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3C31333BBA9
	for <kvm@vger.kernel.org>; Wed, 17 Dec 2025 15:54:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765986883; cv=none; b=N4JnFwQ1cOIeZ4nYSXE+d1sySvJNoZzg7V+RHkFklRkm5Jz7CcV00E8MZ9itun82PPh+0SpN/pZDM3uaf6f1yv80jvwzz7Ktuin0Q+TbPlVTj/3skBY+lwB49Ragh8FhcY8aGrWPUkpR7K/xf0Cg40zjCqgko20e1kVq6h6RCvQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765986883; c=relaxed/simple;
	bh=CaXldbmYtHvWm/L8NUKZ8s5YHHV2PFrlDXAxwHCPvZU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=R1NxycaZBJ1mLvvipeqKKSgHRs2jR8QmBT+q3gGUAgqLO/dvF4JudnuPnFgK1bWAvb1yLFxNcj78N5CilU2RRyTi88arlz22zYWxnPBVo7C/zEj+EaLh7fsLdfEY8r6XbQmV3s8jB2pp4DKXHO1/wqKlq+RVzT6Qnn1FiS3ufKo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 50A9EFEC;
	Wed, 17 Dec 2025 07:54:29 -0800 (PST)
Received: from e124191.cambridge.arm.com (e124191.cambridge.arm.com [10.1.197.45])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 69F183F5CA;
	Wed, 17 Dec 2025 07:54:34 -0800 (PST)
Date: Wed, 17 Dec 2025 15:54:29 +0000
From: Joey Gouly <joey.gouly@arm.com>
To: Sascha Bischoff <Sascha.Bischoff@arm.com>
Cc: "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>,
	"kvmarm@lists.linux.dev" <kvmarm@lists.linux.dev>,
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>, nd <nd@arm.com>,
	"maz@kernel.org" <maz@kernel.org>,
	"oliver.upton@linux.dev" <oliver.upton@linux.dev>,
	Suzuki Poulose <Suzuki.Poulose@arm.com>,
	"yuzenghui@huawei.com" <yuzenghui@huawei.com>,
	"peter.maydell@linaro.org" <peter.maydell@linaro.org>,
	"lpieralisi@kernel.org" <lpieralisi@kernel.org>,
	Timothy Hayes <Timothy.Hayes@arm.com>
Subject: Re: [PATCH 17/32] KVM: arm64: gic-v5: Implement PPI interrupt
 injection
Message-ID: <20251217155429.GA1649600@e124191.cambridge.arm.com>
References: <20251212152215.675767-1-sascha.bischoff@arm.com>
 <20251212152215.675767-18-sascha.bischoff@arm.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251212152215.675767-18-sascha.bischoff@arm.com>

Hi Sascha,

small comment,

On Fri, Dec 12, 2025 at 03:22:41PM +0000, Sascha Bischoff wrote:
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
> ---
>  arch/arm64/kvm/vgic/vgic-v5.c | 157 ++++++++++++++++++++++++++++++++++
>  arch/arm64/kvm/vgic/vgic.c    |  35 ++++++--
>  arch/arm64/kvm/vgic/vgic.h    |  49 ++++++++---
>  include/kvm/arm_vgic.h        |   3 +
>  4 files changed, 226 insertions(+), 18 deletions(-)
> 
> diff --git a/arch/arm64/kvm/vgic/vgic-v5.c b/arch/arm64/kvm/vgic/vgic-v5.c
> index 22558080711eb..d54595fbf4586 100644
> --- a/arch/arm64/kvm/vgic/vgic-v5.c
> +++ b/arch/arm64/kvm/vgic/vgic-v5.c
> @@ -54,6 +54,163 @@ int vgic_v5_probe(const struct gic_kvm_info *info)
>  	return 0;
>  }
>  
> +static bool vgic_v5_ppi_set_pending_state(struct kvm_vcpu *vcpu,
> +					  struct vgic_irq *irq)
> +{
> +	struct vgic_v5_cpu_if *cpu_if;
> +	const u32 id_bit = BIT_ULL(irq->intid % 64);
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
> +
> +/*
> + * For GICv5, the PPIs are mostly directly managed by the hardware. We
> + * (the hypervisor) handle the pending, active, enable state
> + * save/restore, but don't need the PPIs to be queued on a per-VCPU AP
> + * list. Therefore, sanity check the state, unlock, and return.
> + */
> +static bool vgic_v5_ppi_queue_irq_unlock(struct kvm *kvm, struct vgic_irq *irq,
> +					 unsigned long flags)
> +	__releases(&irq->irq_lock)
> +{
> +	struct kvm_vcpu *vcpu;
> +
> +	lockdep_assert_held(&irq->irq_lock);
> +
> +	if (WARN_ON_ONCE(!irq_is_ppi_v5(irq->intid)))
> +		return false;
> +
> +	vcpu = irq->target_vcpu;
> +	if (WARN_ON_ONCE(!vcpu))
> +		return false;
> +
> +	raw_spin_unlock_irqrestore(&irq->irq_lock, flags);
> +
> +	/* Directly kick the target VCPU to make sure it sees the IRQ */
> +	kvm_make_request(KVM_REQ_IRQ_PENDING, vcpu);
> +	kvm_vcpu_kick(vcpu);
> +
> +	return true;
> +}
> +
> +static struct irq_ops vgic_v5_ppi_irq_ops = {
> +	.set_pending_state = vgic_v5_ppi_set_pending_state,
> +	.queue_irq_unlock = vgic_v5_ppi_queue_irq_unlock,
> +};
> +
> +void vgic_v5_set_ppi_ops(struct vgic_irq *irq)
> +{
> +	if (WARN_ON(!irq) || WARN_ON(irq->ops))
> +		return;
> +
> +	irq->ops = &vgic_v5_ppi_irq_ops;
> +}
> +
> +/*
> + * Detect any PPIs state changes, and propagate the state with KVM's
> + * shadow structures.
> + */
> +static void vgic_v5_merge_ppi_state(struct kvm_vcpu *vcpu)
> +{
> +	struct vgic_v5_cpu_if *cpu_if = &vcpu->arch.vgic_cpu.vgic_v5;
> +	unsigned long flags;
> +	int i, reg;
> +
> +	for (reg = 0; reg < 2; reg++) {
> +		unsigned long changed_bits;
> +		const unsigned long enabler = cpu_if->vgic_ich_ppi_enabler_exit[reg];
> +		const unsigned long activer = cpu_if->vgic_ppi_activer_exit[reg];
> +		const unsigned long pendr = cpu_if->vgic_ppi_pendr_exit[reg];
> +
> +		/*
> +		 * Track what changed across enabler, activer, pendr, but mask
> +		 * with ~DVI.
> +		 */
> +		changed_bits = cpu_if->vgic_ich_ppi_enabler_entry[reg] ^ enabler;
> +		changed_bits |= cpu_if->vgic_ppi_activer_entry[reg] ^ activer;
> +		changed_bits |= cpu_if->vgic_ppi_pendr_entry[reg] ^ pendr;
> +		changed_bits &= ~cpu_if->vgic_ppi_dvir[reg];
> +
> +		for_each_set_bit(i, &changed_bits, 64) {
> +			struct vgic_irq *irq;
> +			u32 intid;
> +
> +			intid = FIELD_PREP(GICV5_HWIRQ_TYPE, GICV5_HWIRQ_TYPE_PPI);
> +			intid |= FIELD_PREP(GICV5_HWIRQ_ID, reg * 64 + i);
> +
> +			irq = vgic_get_vcpu_irq(vcpu, intid);
> +
> +			raw_spin_lock_irqsave(&irq->irq_lock, flags);
> +			irq->enabled = !!(enabler & BIT(i));
> +			irq->active = !!(activer & BIT(i));
> +			/* This is an OR to avoid losing incoming edges! */
> +			if (irq->config == VGIC_CONFIG_EDGE)
> +				irq->pending_latch |= !!(pendr & BIT(i));
> +			raw_spin_unlock_irqrestore(&irq->irq_lock, flags);
> +
> +			vgic_put_irq(vcpu->kvm, irq);
> +		}
> +
> +		/* Re-inject the exit state as entry state next time! */
> +		cpu_if->vgic_ich_ppi_enabler_entry[reg] = enabler;
> +		cpu_if->vgic_ppi_activer_entry[reg] = activer;
> +
> +		/*
> +		 * Pending state is a bit different. We only propagate back
> +		 * pending state for Edge interrupts. Moreover, this is OR'd
> +		 * with the incoming state to make sure we don't lose incoming
> +		 * edges. Use the (inverse) HMR to mask off all Level bits, and
> +		 * OR.
> +		 */
> +		cpu_if->vgic_ppi_pendr[reg] |= pendr & ~cpu_if->vgic_ppi_hmr[reg];
> +	}
> +}
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
> +}
> +
> +void vgic_v5_fold_irq_state(struct kvm_vcpu *vcpu)
> +{
> +	/* Sync back the guest PPI state to the KVM shadow state */
> +	vgic_v5_merge_ppi_state(vcpu);
> +}
> +
>  /*
>   * Sets/clears the corresponding bit in the ICH_PPI_DVIR register.
>   */
> diff --git a/arch/arm64/kvm/vgic/vgic.c b/arch/arm64/kvm/vgic/vgic.c
> index fc01c6d07fe62..e534876656ca7 100644
> --- a/arch/arm64/kvm/vgic/vgic.c
> +++ b/arch/arm64/kvm/vgic/vgic.c
> @@ -105,6 +105,15 @@ struct vgic_irq *vgic_get_vcpu_irq(struct kvm_vcpu *vcpu, u32 intid)
>  	if (WARN_ON(!vcpu))
>  		return NULL;
>  
> +	if (vcpu->kvm->arch.vgic.vgic_model == KVM_DEV_TYPE_ARM_VGIC_V5) {
> +		u32 int_num = FIELD_GET(GICV5_HWIRQ_ID, intid);
> +
> +		if (irq_is_ppi_v5(intid)) {
> +			int_num = array_index_nospec(int_num, VGIC_V5_NR_PRIVATE_IRQS);
> +			return &vcpu->arch.vgic_cpu.private_irqs[int_num];
> +		}
> +	}
> +

Should the code below this be in an else {}? I don't think it will ever be true
for gic v5 since 0 is invalid for GICV5_HWIRQ_TYPE (so some high bit 29:31 will
be set), but it might be clearer?

Thanks,
Joey

>  	/* SGIs and PPIs */
>  	if (intid < VGIC_NR_PRIVATE_IRQS) {
>  		intid = array_index_nospec(intid, VGIC_NR_PRIVATE_IRQS);
> @@ -258,10 +267,12 @@ struct kvm_vcpu *vgic_target_oracle(struct vgic_irq *irq)
>  	 * If the distributor is disabled, pending interrupts shouldn't be
>  	 * forwarded.
>  	 */
> -	if (irq->enabled && irq_is_pending(irq)) {
> -		if (unlikely(irq->target_vcpu &&
> -			     !irq->target_vcpu->kvm->arch.vgic.enabled))
> -			return NULL;
> +	if (irq_is_enabled(irq) && irq_is_pending(irq)) {
> +		if (irq->target_vcpu) {
> +			if (!vgic_is_v5(irq->target_vcpu->kvm) &&
> +			    unlikely(!irq->target_vcpu->kvm->arch.vgic.enabled))
> +				return NULL;
> +		}
>  
>  		return irq->target_vcpu;
>  	}
> @@ -1044,7 +1055,11 @@ void kvm_vgic_sync_hwstate(struct kvm_vcpu *vcpu)
>  	if (can_access_vgic_from_kernel())
>  		vgic_save_state(vcpu);
>  
> -	vgic_fold_lr_state(vcpu);
> +	if (!vgic_is_v5(vcpu->kvm))
> +		vgic_fold_lr_state(vcpu);
> +	else
> +		vgic_v5_fold_irq_state(vcpu);
> +
>  	vgic_prune_ap_list(vcpu);
>  }
>  
> @@ -1105,13 +1120,17 @@ void kvm_vgic_flush_hwstate(struct kvm_vcpu *vcpu)
>  
>  	DEBUG_SPINLOCK_BUG_ON(!irqs_disabled());
>  
> -	scoped_guard(raw_spinlock, &vcpu->arch.vgic_cpu.ap_list_lock)
> -		vgic_flush_lr_state(vcpu);
> +	if (!vgic_is_v5(vcpu->kvm)) {
> +		scoped_guard(raw_spinlock, &vcpu->arch.vgic_cpu.ap_list_lock)
> +			vgic_flush_lr_state(vcpu);
> +	} else {
> +		vgic_v5_flush_ppi_state(vcpu);
> +	}
>  
>  	if (can_access_vgic_from_kernel())
>  		vgic_restore_state(vcpu);
>  
> -	if (vgic_supports_direct_irqs(vcpu->kvm))
> +	if (vgic_supports_direct_irqs(vcpu->kvm) && !vgic_is_v5(vcpu->kvm))
>  		vgic_v4_commit(vcpu);
>  }
>  
> diff --git a/arch/arm64/kvm/vgic/vgic.h b/arch/arm64/kvm/vgic/vgic.h
> index b6e3f5e3aba18..5a77318ddb87a 100644
> --- a/arch/arm64/kvm/vgic/vgic.h
> +++ b/arch/arm64/kvm/vgic/vgic.h
> @@ -132,6 +132,28 @@ static inline bool irq_is_pending(struct vgic_irq *irq)
>  		return irq->pending_latch || irq->line_level;
>  }
>  
> +/* Requires the irq_lock to be held by the caller. */
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
> +
>  static inline bool vgic_irq_is_mapped_level(struct vgic_irq *irq)
>  {
>  	return irq->config == VGIC_CONFIG_LEVEL && irq->hw;
> @@ -306,7 +328,7 @@ static inline bool vgic_try_get_irq_ref(struct vgic_irq *irq)
>  	if (!irq)
>  		return false;
>  
> -	if (irq->intid < VGIC_MIN_LPI)
> +	if (irq->target_vcpu && !irq_is_lpi(irq->target_vcpu->kvm, irq->intid))
>  		return true;
>  
>  	return refcount_inc_not_zero(&irq->refcount);
> @@ -363,7 +385,10 @@ void vgic_debug_init(struct kvm *kvm);
>  void vgic_debug_destroy(struct kvm *kvm);
>  
>  int vgic_v5_probe(const struct gic_kvm_info *info);
> +void vgic_v5_set_ppi_ops(struct vgic_irq *irq);
>  int vgic_v5_set_ppi_dvi(struct kvm_vcpu *vcpu, u32 irq, bool dvi);
> +void vgic_v5_flush_ppi_state(struct kvm_vcpu *vcpu);
> +void vgic_v5_fold_irq_state(struct kvm_vcpu *vcpu);
>  void vgic_v5_load(struct kvm_vcpu *vcpu);
>  void vgic_v5_put(struct kvm_vcpu *vcpu);
>  void vgic_v5_set_vmcr(struct kvm_vcpu *vcpu, struct vgic_vmcr *vmcr);
> @@ -432,15 +457,6 @@ void vgic_its_invalidate_all_caches(struct kvm *kvm);
>  int vgic_its_inv_lpi(struct kvm *kvm, struct vgic_irq *irq);
>  int vgic_its_invall(struct kvm_vcpu *vcpu);
>  
> -bool system_supports_direct_sgis(void);
> -bool vgic_supports_direct_msis(struct kvm *kvm);
> -bool vgic_supports_direct_sgis(struct kvm *kvm);
> -
> -static inline bool vgic_supports_direct_irqs(struct kvm *kvm)
> -{
> -	return vgic_supports_direct_msis(kvm) || vgic_supports_direct_sgis(kvm);
> -}
> -
>  int vgic_v4_init(struct kvm *kvm);
>  void vgic_v4_teardown(struct kvm *kvm);
>  void vgic_v4_configure_vsgis(struct kvm *kvm);
> @@ -485,6 +501,19 @@ static inline bool vgic_is_v5(struct kvm *kvm)
>  	return kvm_vgic_global_state.type == VGIC_V5 && !vgic_is_v3_compat(kvm);
>  }
>  
> +bool system_supports_direct_sgis(void);
> +bool vgic_supports_direct_msis(struct kvm *kvm);
> +bool vgic_supports_direct_sgis(struct kvm *kvm);
> +
> +static inline bool vgic_supports_direct_irqs(struct kvm *kvm)
> +{
> +	/* GICv5 always supports direct IRQs */
> +	if (vgic_is_v5(kvm))
> +		return true;
> +
> +	return vgic_supports_direct_msis(kvm) || vgic_supports_direct_sgis(kvm);
> +}
> +
>  int vgic_its_debug_init(struct kvm_device *dev);
>  void vgic_its_debug_destroy(struct kvm_device *dev);
>  
> diff --git a/include/kvm/arm_vgic.h b/include/kvm/arm_vgic.h
> index 20c908730fa00..5a46fe3c35b5c 100644
> --- a/include/kvm/arm_vgic.h
> +++ b/include/kvm/arm_vgic.h
> @@ -32,6 +32,9 @@
>  #define VGIC_MIN_LPI		8192
>  #define KVM_IRQCHIP_NUM_PINS	(1020 - 32)
>  
> +/* GICv5 constants */
> +#define VGIC_V5_NR_PRIVATE_IRQS	128
> +
>  #define irq_is_ppi_legacy(irq) ((irq) >= VGIC_NR_SGIS && (irq) < VGIC_NR_PRIVATE_IRQS)
>  #define irq_is_spi_legacy(irq) ((irq) >= VGIC_NR_PRIVATE_IRQS && \
>  					(irq) <= VGIC_MAX_SPI)
> -- 
> 2.34.1

