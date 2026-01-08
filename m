Return-Path: <kvm+bounces-67408-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [IPv6:2600:3c09:e001:a7::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id E6534D04414
	for <lists+kvm@lfdr.de>; Thu, 08 Jan 2026 17:16:27 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id 0C5193025C66
	for <lists+kvm@lfdr.de>; Thu,  8 Jan 2026 16:10:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BC35221CC55;
	Thu,  8 Jan 2026 16:10:43 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 702351A3179
	for <kvm@vger.kernel.org>; Thu,  8 Jan 2026 16:10:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767888643; cv=none; b=YTHWVPg1jcunTz1lSDQZ4SyBHct0up6jMEi6mq1J9fDG3fm2w/158tjpYrC3u1fkD7giAYd2GoucebXdycELHvhkseAAUXZLvGKgt1HJEvgzxk/rviYejNEqFesWsP8VzPhPy8jppBc4sX7hzYSMT7bl5WN7MKynw9V5/zzHjMY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767888643; c=relaxed/simple;
	bh=Tej4awhuCuuXOnYNKdex5U5yvlB1jVTrTzmYMPKg94g=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=PFL65HFA7qUSufMEhRRBLILlKwoKdKYPV0n53jmcJAWu+DfoW+w4JysrIDJoZP3lD3hUioLed8jsNs4jJlwOQJtXbWcdcXNEI/HQgfQeIFwfD3CiKM22x+XM983PMy/lIl57eIv9BFKe7NKW3Z0CxEvrb8a09/vzBY1/n3DOcGg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 27899497;
	Thu,  8 Jan 2026 08:10:34 -0800 (PST)
Received: from e124191.cambridge.arm.com (e124191.cambridge.arm.com [10.1.197.45])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 491613F5A1;
	Thu,  8 Jan 2026 08:10:38 -0800 (PST)
Date: Thu, 8 Jan 2026 16:10:31 +0000
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
Subject: Re: [PATCH v2 19/36] KVM: arm64: gic-v5: Check for pending PPIs
Message-ID: <20260108161031.GA223579@e124191.cambridge.arm.com>
References: <20251219155222.1383109-1-sascha.bischoff@arm.com>
 <20251219155222.1383109-20-sascha.bischoff@arm.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251219155222.1383109-20-sascha.bischoff@arm.com>

Small nit,

On Fri, Dec 19, 2025 at 03:52:42PM +0000, Sascha Bischoff wrote:
> This change allows KVM to check for pending PPI interrupts. This has
> two main components:
> 
> First of all, the effective priority mask is calculated.  This is a
> combination of the priority mask in the VPEs ICC_PCR_EL1.PRIORITY and
> the currently running priority as determined from the VPE's
> ICH_APR_EL1. If an interrupt's prioirity is greater than or equal to
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
> ---
>  arch/arm64/kvm/vgic/vgic-v5.c | 121 ++++++++++++++++++++++++++++++++++
>  arch/arm64/kvm/vgic/vgic.c    |   5 +-
>  arch/arm64/kvm/vgic/vgic.h    |   1 +
>  3 files changed, 126 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/arm64/kvm/vgic/vgic-v5.c b/arch/arm64/kvm/vgic/vgic-v5.c
> index cb3dd872d16a6..c7ecc4f40b1e5 100644
> --- a/arch/arm64/kvm/vgic/vgic-v5.c
> +++ b/arch/arm64/kvm/vgic/vgic-v5.c
> @@ -56,6 +56,31 @@ int vgic_v5_probe(const struct gic_kvm_info *info)
>  	return 0;
>  }
>  
> +static u32 vgic_v5_get_effective_priority_mask(struct kvm_vcpu *vcpu)
> +{
> +	struct vgic_v5_cpu_if *cpu_if = &vcpu->arch.vgic_cpu.vgic_v5;
> +	u32 highest_ap, priority_mask;
> +
> +	/*
> +	 * Counting the number of trailing zeros gives the current
> +	 * active priority. Explicitly use the 32-bit version here as
> +	 * we have 32 priorities. 0x20 then means that there are no
> +	 * active priorities.
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
> +	priority_mask = min(highest_ap, priority_mask + 1);
> +
> +	return priority_mask;
> +}
> +
>  static bool vgic_v5_ppi_set_pending_state(struct kvm_vcpu *vcpu,
>  					  struct vgic_irq *irq)
>  {
> @@ -131,6 +156,102 @@ void vgic_v5_set_ppi_ops(struct vgic_irq *irq)
>  	}
>  }
>  
> +
> +/*
> + * Sync back the PPI priorities to the vgic_irq shadow state
> + */
> +static void vgic_v5_sync_ppi_priorities(struct kvm_vcpu *vcpu)
> +{
> +	struct vgic_v5_cpu_if *cpu_if = &vcpu->arch.vgic_cpu.vgic_v5;
> +	int i, reg;
> +
> +	/* We have 16 PPI Priority regs */
> +	for (reg = 0; reg < 16; reg++) {
> +		const unsigned long priorityr = cpu_if->vgic_ppi_priorityr[reg];
> +
> +		for (i = 0; i < 8; ++i) {
> +			struct vgic_irq *irq;
> +			u32 intid;
> +			u8 priority;
> +
> +			priority = (priorityr >> (i * 8)) & 0x1f;
> +
> +			intid = FIELD_PREP(GICV5_HWIRQ_TYPE, GICV5_HWIRQ_TYPE_PPI);
> +			intid |= FIELD_PREP(GICV5_HWIRQ_ID, reg * 8 + i);
> +
> +			irq = vgic_get_vcpu_irq(vcpu, intid);
> +
> +			scoped_guard(raw_spinlock, &irq->irq_lock)
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
> +	int i, reg;
> +	unsigned int priority_mask;
> +
> +	/* If no pending bits are set, exit early */
> +	if (likely(!cpu_if->vgic_ppi_pendr[0] && !cpu_if->vgic_ppi_pendr[1]))
> +		return false;
> +
> +	priority_mask = vgic_v5_get_effective_priority_mask(vcpu);
> +
> +	/* If the combined priority mask is 0, nothing can be signalled! */
> +	if (!priority_mask)
> +		return false;
> +
> +	/* The shadow priority is only updated on demand, sync it across first */
> +	vgic_v5_sync_ppi_priorities(vcpu);
> +
> +	for (reg = 0; reg < 2; reg++) {
> +		unsigned long possible_bits;
> +		const unsigned long enabler = cpu_if->vgic_ich_ppi_enabler_exit[reg];
> +		const unsigned long pendr = cpu_if->vgic_ppi_pendr_exit[reg];
> +		bool has_pending = false;
> +
> +		/* Check all interrupts that are enabled and pending */
> +		possible_bits = enabler & pendr;
> +
> +		/*
> +		 * Optimisation: pending and enabled with no active priorities
> +		 */
> +		if (possible_bits && priority_mask > 0x1f)
> +			return true;
> +
> +		for_each_set_bit(i, &possible_bits, 64) {
> +			struct vgic_irq *irq;
> +			u32 intid;
> +
> +			intid = FIELD_PREP(GICV5_HWIRQ_TYPE, GICV5_HWIRQ_TYPE_PPI);
> +			intid |= FIELD_PREP(GICV5_HWIRQ_ID, reg * 64 + i);
> +
> +			irq = vgic_get_vcpu_irq(vcpu, intid);
> +
> +			scoped_guard(raw_spinlock, &irq->irq_lock) {
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
> diff --git a/arch/arm64/kvm/vgic/vgic.c b/arch/arm64/kvm/vgic/vgic.c
> index cb5d43b34462b..dfec6ed7936ed 100644
> --- a/arch/arm64/kvm/vgic/vgic.c
> +++ b/arch/arm64/kvm/vgic/vgic.c
> @@ -1180,9 +1180,12 @@ int kvm_vgic_vcpu_pending_irq(struct kvm_vcpu *vcpu)
>  	unsigned long flags;
>  	struct vgic_vmcr vmcr;
>  
> -	if (!vcpu->kvm->arch.vgic.enabled)
> +	if (!vcpu->kvm->arch.vgic.enabled && !vgic_is_v5(vcpu->kvm))
>  		return false;
>  
> +	if (vcpu->kvm->arch.vgic.vgic_model == KVM_DEV_TYPE_ARM_VGIC_V5)

        if (vgic_is_v5(vcpu->kvm))

Otherwise:

Reviewed-by: Joey Gouly <joey.gouly@arm.com>

> +		return vgic_v5_has_pending_ppi(vcpu);
> +
>  	if (vcpu->arch.vgic_cpu.vgic_v3.its_vpe.pending_last)
>  		return true;
>  
> diff --git a/arch/arm64/kvm/vgic/vgic.h b/arch/arm64/kvm/vgic/vgic.h
> index 978d7f8426361..65c031da83e78 100644
> --- a/arch/arm64/kvm/vgic/vgic.h
> +++ b/arch/arm64/kvm/vgic/vgic.h
> @@ -388,6 +388,7 @@ int vgic_v5_probe(const struct gic_kvm_info *info);
>  void vgic_v5_get_implemented_ppis(void);
>  void vgic_v5_set_ppi_ops(struct vgic_irq *irq);
>  int vgic_v5_set_ppi_dvi(struct kvm_vcpu *vcpu, u32 irq, bool dvi);
> +bool vgic_v5_has_pending_ppi(struct kvm_vcpu *vcpu);
>  void vgic_v5_flush_ppi_state(struct kvm_vcpu *vcpu);
>  void vgic_v5_fold_ppi_state(struct kvm_vcpu *vcpu);
>  void vgic_v5_load(struct kvm_vcpu *vcpu);
> -- 
> 2.34.1

