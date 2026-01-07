Return-Path: <kvm+bounces-67228-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 3439ECFE78D
	for <lists+kvm@lfdr.de>; Wed, 07 Jan 2026 16:06:34 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 3F4D530EA2ED
	for <lists+kvm@lfdr.de>; Wed,  7 Jan 2026 15:00:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 35C7F35E53C;
	Wed,  7 Jan 2026 15:00:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.b="VQEKUrIv"
X-Original-To: kvm@vger.kernel.org
Received: from sinmsgout01.his.huawei.com (sinmsgout01.his.huawei.com [119.8.177.36])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B8FDB3770B
	for <kvm@vger.kernel.org>; Wed,  7 Jan 2026 15:00:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=119.8.177.36
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767798025; cv=none; b=Ji6fS3mP6EZmE9gB6pQ9jWiQ9K9kZEN8jJ5CYTNJrDjp0X/g4RtLj+AGBFyFGIfcm/Wk8wnvcaeAKTLO+1cSJRfZcJmIsg4ruRClhVJwT5yEJh5kBWmxU0OvFA85F6IoSei25P5Mdlv4Gvj5HHZ/HxhvFfgUd03TH/honYnNR/w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767798025; c=relaxed/simple;
	bh=cYv/3e61IVbbLX0u2BvbgEMTFVDqs5CuOoqiRrnCtog=;
	h=Date:From:To:CC:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=HcWmP3hsAhOLIUwqs1hQjYB5nWPx4ZpN+Mgi4ttfVuji7K7B2p9kldOM+fTkg8LC2Aq0rIpbjps5klbHKXgXmZ6SuqrKqsYeW/pMh0HbXjZvaLYs1OT0iAOudyxeM3IzLBxKbHA4LeBxicZ7lpzAJyQh0GQ0u1XNVNuGdYXE72E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.b=VQEKUrIv; arc=none smtp.client-ip=119.8.177.36
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=eMyNdfVfNINeb/k/mJYeahN2ew1GTGCuUl4Lpg/7vMY=;
	b=VQEKUrIvKtTqdwC9hacz1qHHFobxO1TBNa8lTuYBJR9v+37c+LmWmfoB1p+LdWHLA02vVWlBd
	AOdQdTiRjHr6Onnr1QSDLJ2tnalTFasQj3uqn7pkYHewDYw3X5sz5o/0sg+nTDELFdqOV5ZplM5
	96aLlnYJ76ZCdv2Dedk/WhQ=
Received: from frasgout.his.huawei.com (unknown [172.18.146.33])
	by sinmsgout01.his.huawei.com (SkyGuard) with ESMTPS id 4dmWNw0tSTz1P7Hn;
	Wed,  7 Jan 2026 22:57:51 +0800 (CST)
Received: from mail.maildlp.com (unknown [172.18.224.83])
	by frasgout.his.huawei.com (SkyGuard) with ESMTPS id 4dmWRb65X2zJ46CW;
	Wed,  7 Jan 2026 23:00:11 +0800 (CST)
Received: from dubpeml100005.china.huawei.com (unknown [7.214.146.113])
	by mail.maildlp.com (Postfix) with ESMTPS id 34DAE40569;
	Wed,  7 Jan 2026 23:00:15 +0800 (CST)
Received: from localhost (10.203.177.15) by dubpeml100005.china.huawei.com
 (7.214.146.113) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.36; Wed, 7 Jan
 2026 15:00:14 +0000
Date: Wed, 7 Jan 2026 15:00:12 +0000
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
Subject: Re: [PATCH v2 19/36] KVM: arm64: gic-v5: Check for pending PPIs
Message-ID: <20260107150012.0000336b@huawei.com>
In-Reply-To: <20251219155222.1383109-20-sascha.bischoff@arm.com>
References: <20251219155222.1383109-1-sascha.bischoff@arm.com>
	<20251219155222.1383109-20-sascha.bischoff@arm.com>
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

> This change allows KVM to check for pending PPI interrupts. This has
> two main components:
> 
> First of all, the effective priority mask is calculated.  This is a
> combination of the priority mask in the VPEs ICC_PCR_EL1.PRIORITY and
> the currently running priority as determined from the VPE's
> ICH_APR_EL1. If an interrupt's prioirity is greater than or equal to

priority

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
Hi Sascha,

One thing I notice in here is the use of unsigned long vs u64 is a bit
inconsistent.  When it's a register or something we just read from a register
I'd always use u64.

A few other things inline.
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

Short wrap.  I'll stop commenting on these and assume you'll check throughout
(or ignore throughout if you disagree ;) Everyone should use an email
client with rulers!

> +	 * we have 32 priorities. 0x20 then means that there are no
> +	 * active priorities.
> +	 */
> +	highest_ap = cpu_if->vgic_apr ? __builtin_ctz(cpu_if->vgic_apr) : 32;

If the comment is going to say 0x20 means no active, then use hex in the code
as well. Or just use 32 in the comment.

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

Unless you are going to do more with that in later patches
	return min(highest_ap, priority_mask + 1);
Doesn't lose any significant readability to my eyes.

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

I'd drag the declaration in as
	for (int ret = 0;

> +		const unsigned long priorityr = cpu_if->vgic_ppi_priorityr[reg];
> +
> +		for (i = 0; i < 8; ++i) {
similar for int i = 0 here

Kernel style is getting more accepting of these 'modern' style things ;)
Up to you though if you prefer old school.

> +			struct vgic_irq *irq;
> +			u32 intid;
> +			u8 priority;
> +
> +			priority = (priorityr >> (i * 8)) & 0x1f;

GENMASK(4, 0); maybe.  It's short enough (I can count to 1 f easily enough!)
that I don't really mind which style you use for this.

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

That likely seems a little bit dubious. I'd be tempted to not mark this
unless you have stats on running systems where the predictors get it wrong
enough that the mark is useful.

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
Given storage of vgic_ich_ppi_enabler_exit[reg] is a u64 and you are going to
use that length explicitly (the 64 in the bitmap walk below) I'd make these
u64s.  I've not really been keeping an eye open for this in other patches, so
maybe look for other cases where an explicit length is clearer.
u64 shorter as well!

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

I 'think' priority_mask > 0x1f is always 0x20?  I'd match that explicitly so the
relationship to the magic value comment above is obvious

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


