Return-Path: <kvm+bounces-66166-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 17F6ECC7765
	for <lists+kvm@lfdr.de>; Wed, 17 Dec 2025 13:01:05 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id E140F3011A54
	for <lists+kvm@lfdr.de>; Wed, 17 Dec 2025 12:01:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8756E33985C;
	Wed, 17 Dec 2025 12:01:00 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 10DB833A6F1
	for <kvm@vger.kernel.org>; Wed, 17 Dec 2025 12:00:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765972858; cv=none; b=Y4ZzQSTuROfizQOrXg6O9php5m2SNAd353U7H3TttNWzD8oihg5Pc8bzfCE66MHIo1J+plLv6VB2LwifnmwWWTpc8ssfml6D4h1HA/mAE30v3VBDL7qN8Bqm0gUZ9Z4rwp9y1QO0bEGWVPaA7pnOE79ypj4f5Vak5+WEYo7AuaY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765972858; c=relaxed/simple;
	bh=O0OyVs17Xoq1JjrxxDglhcEL9LOahDgNssR+3laeYss=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Ossz43FflAAUs90AuT8MgyU/FqxFolgSfJJLNF2gPsK+6Rzf8ErSms+dcqz8KCihoOGpv6qJ1lE+0ATz455iAx0GHYOsTOsGyTOHK7ffikDUHeJJBD4KFusecmp0ZhzQa3tV097arukXq2tITf0eukGYSshfYewDQR3L9DrANrI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id BEA7914BF;
	Wed, 17 Dec 2025 04:00:45 -0800 (PST)
Received: from e124191.cambridge.arm.com (e124191.cambridge.arm.com [10.1.197.45])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id D906C3F73F;
	Wed, 17 Dec 2025 04:00:50 -0800 (PST)
Date: Wed, 17 Dec 2025 12:00:35 +0000
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
Subject: Re: [PATCH 18/32] KVM: arm64: gic-v5: Check for pending PPIs
Message-ID: <20251217120035.GA1628893@e124191.cambridge.arm.com>
References: <20251212152215.675767-1-sascha.bischoff@arm.com>
 <20251212152215.675767-19-sascha.bischoff@arm.com>
 <20251217114932.GA1626516@e124191.cambridge.arm.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251217114932.GA1626516@e124191.cambridge.arm.com>

On Wed, Dec 17, 2025 at 11:49:32AM +0000, Joey Gouly wrote:
> Hi Sascha,
> 
> On Fri, Dec 12, 2025 at 03:22:41PM +0000, Sascha Bischoff wrote:
> > This change allows KVM to check for pending PPI interrupts. This has
> > two main components:
> > 
> > First of all, the effective priority mask is calculated.  This is a
> > combination of the priority mask in the VPEs ICC_PCR_EL1.PRIORITY and
> > the currently running priority as determined from the VPE's
> > ICH_APR_EL1. If an interrupt's prioirity is greater than or equal to
> > the effective priority mask, it can be signalled. Otherwise, it
> > cannot.
> > 
> > Secondly, any Enabled and Pending PPIs must be checked against this
> > compound priority mask. The reqires the PPI priorities to by synced
> > back to the KVM shadow state - this is skipped in general operation as
> > it isn't required and is rather expensive. If any Enabled and Pending
> > PPIs are of sufficient priority to be signalled, then there are
> > pending PPIs. Else, there are not.  This ensures that a VPE is not
> > woken when it cannot actually process the pending interrupts.
> > 
> > Signed-off-by: Sascha Bischoff <sascha.bischoff@arm.com>
> > ---
> >  arch/arm64/kvm/vgic/vgic-v5.c | 123 ++++++++++++++++++++++++++++++++++
> >  arch/arm64/kvm/vgic/vgic.c    |  10 ++-
> >  arch/arm64/kvm/vgic/vgic.h    |   1 +
> >  3 files changed, 131 insertions(+), 3 deletions(-)
> > 
> > diff --git a/arch/arm64/kvm/vgic/vgic-v5.c b/arch/arm64/kvm/vgic/vgic-v5.c
> > index d54595fbf4586..35740e88b3591 100644
> > --- a/arch/arm64/kvm/vgic/vgic-v5.c
> > +++ b/arch/arm64/kvm/vgic/vgic-v5.c
> > @@ -54,6 +54,31 @@ int vgic_v5_probe(const struct gic_kvm_info *info)
> >  	return 0;
> >  }
> >  
> > +static u32 vgic_v5_get_effective_priority_mask(struct kvm_vcpu *vcpu)
> > +{
> > +	struct vgic_v5_cpu_if *cpu_if = &vcpu->arch.vgic_cpu.vgic_v5;
> > +	unsigned highest_ap, priority_mask;
> > +
> > +	/*
> > +	 * Counting the number of trailing zeros gives the current
> > +	 * active priority. Explicitly use the 32-bit version here as
> > +	 * we have 32 priorities. 0x20 then means that there are no
> > +	 * active priorities.
> > +	 */
> > +	highest_ap = __builtin_ctz(cpu_if->vgic_apr);
> 
> __builtin_ctz(0) is undefined (https://gcc.gnu.org/onlinedocs/gcc/Bit-Operation-Builtins.html)
> 
> Looking at __vgic_v3_clear_highest_active_priority(), it handles that like this:
> 
> 	c0 = ap0 ? __ffs(ap0) : 32;

Sorry forgot ffs() was 1-based, so:

	highest_ap = cpu_if->vgic_apr ? __builtin_ctz(cpu_if->vgic_apr) : 32;

Thanks,
Joey

> 
> Thanks,
> Joey
> 
> > +
> > +	/*
> > +	 * An interrupt is of sufficient priority if it is equal to or
> > +	 * greater than the priority mask. Add 1 to the priority mask
> > +	 * (i.e., lower priority) to match the APR logic before taking
> > +	 * the min. This gives us the lowest priority that is masked.
> > +	 */
> > +	priority_mask = FIELD_GET(FEAT_GCIE_ICH_VMCR_EL2_VPMR, cpu_if->vgic_vmcr);
> > +	priority_mask = min(highest_ap, priority_mask + 1);
> > +
> > +	return priority_mask;
> > +}
> > +
> >  static bool vgic_v5_ppi_set_pending_state(struct kvm_vcpu *vcpu,
> >  					  struct vgic_irq *irq)
> >  {
> > @@ -121,6 +146,104 @@ void vgic_v5_set_ppi_ops(struct vgic_irq *irq)
> >  	irq->ops = &vgic_v5_ppi_irq_ops;
> >  }
> >  
> > +
> > +/*
> > + * Sync back the PPI priorities to the vgic_irq shadow state
> > + */
> > +static void vgic_v5_sync_ppi_priorities(struct kvm_vcpu *vcpu)
> > +{
> > +	struct vgic_v5_cpu_if *cpu_if = &vcpu->arch.vgic_cpu.vgic_v5;
> > +	unsigned long flags;
> > +	int i, reg;
> > +
> > +	/* We have 16 PPI Priority regs */
> > +	for (reg = 0; reg < 16; reg++) {
> > +		const unsigned long priorityr = cpu_if->vgic_ppi_priorityr[reg];
> > +
> > +		for (i = 0; i < 8; ++i) {
> > +			struct vgic_irq *irq;
> > +			u32 intid;
> > +			u8 priority;
> > +
> > +			priority = (priorityr >> (i * 8)) & 0x1f;
> > +
> > +			intid = FIELD_PREP(GICV5_HWIRQ_TYPE, GICV5_HWIRQ_TYPE_PPI);
> > +			intid |= FIELD_PREP(GICV5_HWIRQ_ID, reg * 8 + i);
> > +
> > +			irq = vgic_get_vcpu_irq(vcpu, intid);
> > +			raw_spin_lock_irqsave(&irq->irq_lock, flags);
> > +
> > +			irq->priority = priority;
> > +
> > +			raw_spin_unlock_irqrestore(&irq->irq_lock, flags);
> > +			vgic_put_irq(vcpu->kvm, irq);
> > +		}
> > +	}
> > +}
> > +
> > +bool vgic_v5_has_pending_ppi(struct kvm_vcpu *vcpu)
> > +{
> > +	struct vgic_v5_cpu_if *cpu_if = &vcpu->arch.vgic_cpu.vgic_v5;
> > +	unsigned long flags;
> > +	int i, reg;
> > +	unsigned int priority_mask;
> > +
> > +	/* If no pending bits are set, exit early */
> > +	if (likely(!cpu_if->vgic_ppi_pendr[0] && !cpu_if->vgic_ppi_pendr[1]))
> > +		return false;
> > +
> > +	priority_mask = vgic_v5_get_effective_priority_mask(vcpu);
> > +
> > +	/* If the combined priority mask is 0, nothing can be signalled! */
> > +	if (!priority_mask)
> > +		return false;
> > +
> > +	/* The shadow priority is only updated on demand, sync it across first */
> > +	vgic_v5_sync_ppi_priorities(vcpu);
> > +
> > +	for (reg = 0; reg < 2; reg++) {
> > +		unsigned long possible_bits;
> > +		const unsigned long enabler = cpu_if->vgic_ich_ppi_enabler_exit[reg];
> > +		const unsigned long pendr = cpu_if->vgic_ppi_pendr_exit[reg];
> > +		bool has_pending = false;
> > +
> > +		/* Check all interrupts that are enabled and pending */
> > +		possible_bits = enabler & pendr;
> > +
> > +		/*
> > +		 * Optimisation: pending and enabled with no active priorities
> > +		 */
> > +		if (possible_bits && priority_mask > 0x1f)
> > +			return true;
> > +
> > +		for_each_set_bit(i, &possible_bits, 64) {
> > +			struct vgic_irq *irq;
> > +			u32 intid;
> > +
> > +			intid = FIELD_PREP(GICV5_HWIRQ_TYPE, GICV5_HWIRQ_TYPE_PPI);
> > +			intid |= FIELD_PREP(GICV5_HWIRQ_ID, reg * 64 + i);
> > +
> > +			irq = vgic_get_vcpu_irq(vcpu, intid);
> > +			raw_spin_lock_irqsave(&irq->irq_lock, flags);
> > +
> > +			/*
> > +			 * We know that the interrupt is enabled and pending, so
> > +			 * only check the priority.
> > +			 */
> > +			if (irq->priority <= priority_mask)
> > +				has_pending = true;
> > +
> > +			raw_spin_unlock_irqrestore(&irq->irq_lock, flags);
> > +			vgic_put_irq(vcpu->kvm, irq);
> > +
> > +			if (has_pending)
> > +				return true;
> > +		}
> > +	}
> > +
> > +	return false;
> > +}
> > +
> >  /*
> >   * Detect any PPIs state changes, and propagate the state with KVM's
> >   * shadow structures.
> > diff --git a/arch/arm64/kvm/vgic/vgic.c b/arch/arm64/kvm/vgic/vgic.c
> > index e534876656ca7..5d18a03cc11d5 100644
> > --- a/arch/arm64/kvm/vgic/vgic.c
> > +++ b/arch/arm64/kvm/vgic/vgic.c
> > @@ -1174,11 +1174,15 @@ int kvm_vgic_vcpu_pending_irq(struct kvm_vcpu *vcpu)
> >  	unsigned long flags;
> >  	struct vgic_vmcr vmcr;
> >  
> > -	if (!vcpu->kvm->arch.vgic.enabled)
> > +	if (!vcpu->kvm->arch.vgic.enabled && !vgic_is_v5(vcpu->kvm))
> >  		return false;
> >  
> > -	if (vcpu->arch.vgic_cpu.vgic_v3.its_vpe.pending_last)
> > -		return true;
> > +	if (vcpu->kvm->arch.vgic.vgic_model == KVM_DEV_TYPE_ARM_VGIC_V5) {
> > +		return vgic_v5_has_pending_ppi(vcpu);
> > +	} else {
> > +		if (vcpu->arch.vgic_cpu.vgic_v3.its_vpe.pending_last)
> > +			return true;
> > +	}
> >  
> >  	vgic_get_vmcr(vcpu, &vmcr);
> >  
> > diff --git a/arch/arm64/kvm/vgic/vgic.h b/arch/arm64/kvm/vgic/vgic.h
> > index 5a77318ddb87a..4b3a1e7ca3fb4 100644
> > --- a/arch/arm64/kvm/vgic/vgic.h
> > +++ b/arch/arm64/kvm/vgic/vgic.h
> > @@ -387,6 +387,7 @@ void vgic_debug_destroy(struct kvm *kvm);
> >  int vgic_v5_probe(const struct gic_kvm_info *info);
> >  void vgic_v5_set_ppi_ops(struct vgic_irq *irq);
> >  int vgic_v5_set_ppi_dvi(struct kvm_vcpu *vcpu, u32 irq, bool dvi);
> > +bool vgic_v5_has_pending_ppi(struct kvm_vcpu *vcpu);
> >  void vgic_v5_flush_ppi_state(struct kvm_vcpu *vcpu);
> >  void vgic_v5_fold_irq_state(struct kvm_vcpu *vcpu);
> >  void vgic_v5_load(struct kvm_vcpu *vcpu);
> > -- 
> > 2.34.1

