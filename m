Return-Path: <kvm+bounces-67932-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 5D91DD18AA1
	for <lists+kvm@lfdr.de>; Tue, 13 Jan 2026 13:18:36 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 51329304F8AC
	for <lists+kvm@lfdr.de>; Tue, 13 Jan 2026 12:16:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6D4ED38F241;
	Tue, 13 Jan 2026 12:16:58 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 60DFC38F23E
	for <kvm@vger.kernel.org>; Tue, 13 Jan 2026 12:16:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768306617; cv=none; b=YfQcE7xapUJTf55CY6lJdFV1H4Lrr03yrrTDPLznflKrfzd9pNUqaFRMixFIWoIiGI7askk84/frNPTU5X83BvZpSUclB/ZPucRTD5OBxiayQQmMtmWHSvYgEzPY8Kr7YjpdEsvH3vPibL5lh+hn7EBim+NwDkJoIiHcsLIGUCs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768306617; c=relaxed/simple;
	bh=RmqklHpjm8P2OXRUbwUU2y1fJAyau/F4IXAn3dZWSV8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=QA9n1GZk3yL38Qxpak4drspSAWECMqQa4cbotes0G1Sv18/oXx3akIBvREiRGintUc9R959ZjY+nu8BnlEEXjyc5M4SqIC0m/hUSswn9wpYS4syoJWkNhvVbaO6ad/Z9o1659+QZo9N2ZlsGP1nng35gq5gBMqK5RaF2sYnfKoM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 06457497;
	Tue, 13 Jan 2026 04:16:47 -0800 (PST)
Received: from e124191.cambridge.arm.com (e124191.cambridge.arm.com [10.1.197.45])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id D9B093F59E;
	Tue, 13 Jan 2026 04:16:51 -0800 (PST)
Date: Tue, 13 Jan 2026 12:16:49 +0000
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
	Timothy Hayes <Timothy.Hayes@arm.com>,
	"jonathan.cameron@huawei.com" <jonathan.cameron@huawei.com>
Subject: Re: [PATCH v3 21/36] KVM: arm64: gic-v5: Check for pending PPIs
Message-ID: <20260113121649.GB801634@e124191.cambridge.arm.com>
References: <20260109170400.1585048-1-sascha.bischoff@arm.com>
 <20260109170400.1585048-22-sascha.bischoff@arm.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260109170400.1585048-22-sascha.bischoff@arm.com>

On Fri, Jan 09, 2026 at 05:04:46PM +0000, Sascha Bischoff wrote:
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

The PPI state is no longer synced to the KVM shadow state in
vgic_v5_has_pending_ppi(), only done on WFI.

Can you update the commit message / explain the rationale there.

Thanks,
Joey

> Signed-off-by: Sascha Bischoff <sascha.bischoff@arm.com>
> Reviewed-by: Joey Gouly <joey.gouly@arm.com>
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
> @@ -139,6 +139,29 @@ void vgic_v5_get_implemented_ppis(void)
>  		ppi_caps->impl_ppi_mask[0] |= BIT_ULL(GICV5_ARCH_PPI_PMUIRQ);
>  }
>  
> +static u32 vgic_v5_get_effective_priority_mask(struct kvm_vcpu *vcpu)
> +{
> +	struct vgic_v5_cpu_if *cpu_if = &vcpu->arch.vgic_cpu.vgic_v5;
> +	u32 highest_ap, priority_mask;
> +
> +	/*
> +	 * Counting the number of trailing zeros gives the current active
> +	 * priority. Explicitly use the 32-bit version here as we have 32
> +	 * priorities. 32 then means that there are no active priorities.
> +	 */
> +	highest_ap = cpu_if->vgic_apr ? __builtin_ctz(cpu_if->vgic_apr) : 32;
> +
> +	/*
> +	 * An interrupt is of sufficient priority if it is equal to or
> +	 * greater than the priority mask. Add 1 to the priority mask
> +	 * (i.e., lower priority) to match the APR logic before taking
> +	 * the min. This gives us the lowest priority that is masked.
> +	 */
> +	priority_mask = FIELD_GET(FEAT_GCIE_ICH_VMCR_EL2_VPMR, cpu_if->vgic_vmcr);
> +
> +	return min(highest_ap, priority_mask + 1);
> +}
> +
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
>  /*
>   * Detect any PPIs state changes, and propagate the state with KVM's
>   * shadow structures.
> @@ -348,6 +477,10 @@ void vgic_v5_put(struct kvm_vcpu *vcpu)
>  	kvm_call_hyp(__vgic_v5_save_apr, cpu_if);
>  
>  	WRITE_ONCE(cpu_if->gicv5_vpe.resident, false);
> +
> +	/* The shadow priority is only updated on entering WFI */
> +	if (vcpu_get_flag(vcpu, IN_WFI))
> +		vgic_v5_sync_ppi_priorities(vcpu);
>  }
>  
>  void vgic_v5_get_vmcr(struct kvm_vcpu *vcpu, struct vgic_vmcr *vmcrp)
> diff --git a/arch/arm64/kvm/vgic/vgic.c b/arch/arm64/kvm/vgic/vgic.c
> index 1cdfa5224ead5..8f2782ad31f74 100644
> --- a/arch/arm64/kvm/vgic/vgic.c
> +++ b/arch/arm64/kvm/vgic/vgic.c
> @@ -1174,6 +1174,9 @@ int kvm_vgic_vcpu_pending_irq(struct kvm_vcpu *vcpu)
>  	unsigned long flags;
>  	struct vgic_vmcr vmcr;
>  
> +	if (vgic_is_v5(vcpu->kvm))
> +		return vgic_v5_has_pending_ppi(vcpu);
> +
>  	if (!vcpu->kvm->arch.vgic.enabled)
>  		return false;
>  
> diff --git a/arch/arm64/kvm/vgic/vgic.h b/arch/arm64/kvm/vgic/vgic.h
> index c8f538e65303f..2c067b571d563 100644
> --- a/arch/arm64/kvm/vgic/vgic.h
> +++ b/arch/arm64/kvm/vgic/vgic.h
> @@ -366,6 +366,7 @@ int vgic_v5_probe(const struct gic_kvm_info *info);
>  void vgic_v5_get_implemented_ppis(void);
>  void vgic_v5_set_ppi_ops(struct vgic_irq *irq);
>  int vgic_v5_set_ppi_dvi(struct kvm_vcpu *vcpu, u32 irq, bool dvi);
> +bool vgic_v5_has_pending_ppi(struct kvm_vcpu *vcpu);
>  void vgic_v5_flush_ppi_state(struct kvm_vcpu *vcpu);
>  void vgic_v5_fold_ppi_state(struct kvm_vcpu *vcpu);
>  void vgic_v5_load(struct kvm_vcpu *vcpu);
> -- 
> 2.34.1

