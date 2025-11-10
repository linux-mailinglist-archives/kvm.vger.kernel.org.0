Return-Path: <kvm+bounces-62493-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 325E8C457D8
	for <lists+kvm@lfdr.de>; Mon, 10 Nov 2025 10:02:15 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 16B15188FFBF
	for <lists+kvm@lfdr.de>; Mon, 10 Nov 2025 09:02:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B789A2FE58C;
	Mon, 10 Nov 2025 09:01:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="FlwOGefe"
X-Original-To: kvm@vger.kernel.org
Received: from out30-111.freemail.mail.aliyun.com (out30-111.freemail.mail.aliyun.com [115.124.30.111])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5333F2FE566
	for <kvm@vger.kernel.org>; Mon, 10 Nov 2025 09:01:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.111
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762765293; cv=none; b=dg+H0GK1BW8uZ7S7Qrp8rgs9nLXpr8VTpo5OkZ5OzNRdKup0uNhv9eAKMA3nH0GBeedzzINvGkPJP7+J0bXcSzckrI2SLiwvENktG19rHxrpVuUEUQnWYvzDWlhFegIOhZLC2o3KtcxxOx2+HRiyERAECeoKdg3Vc27AI8fUvpQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762765293; c=relaxed/simple;
	bh=gPcDGKwEsVJRvSCUHSJdrdgSd4eu3X4NeLWy+T2fUg4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=iC4xNjTN2lHqpE6zCohpgfvAwdOS/Vb0I26J+dmOzhmVXyrxNI7V1C8Gg7/X6FDEiMz7Bw5r00Lc7iRtf7PxpdwAuUgB7X8RtHTyN59toYUtyUnLYFM3rnvURiG0BUrU080nT4MTkDs9jTcSypPMQguzPVMrhnMWIsCZO83pFD4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=FlwOGefe; arc=none smtp.client-ip=115.124.30.111
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1762765282; h=Date:From:To:Subject:Message-ID:MIME-Version:Content-Type;
	bh=vxV0Bv9e0M/3aXxevVPMy47RYEU13Dm8RyI5inKduGU=;
	b=FlwOGefehqKjuHLk1uf5ix47zgs9Kx27lBfuqtg8dowAUVr4AjS72pW2GE2CP5qTkiykLTs4mBOb4sGFWWSl4Ay7W1Z1didHMLCqsurZ+yv0D5QekeRUAsztVhmZBTe8+KJx0Wq0hYULL4wLe0/w8TsAferRCZWNBOqzRAxQKVw=
Received: from localhost(mailfrom:yaoyuan@linux.alibaba.com fp:SMTPD_---0Ws1SfV-_1762765281 cluster:ay36)
          by smtp.aliyun-inc.com;
          Mon, 10 Nov 2025 17:01:21 +0800
Date: Mon, 10 Nov 2025 17:01:21 +0800
From: Yao Yuan <yaoyuan@linux.alibaba.com>
To: Marc Zyngier <maz@kernel.org>
Cc: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, 
	kvm@vger.kernel.org, Joey Gouly <joey.gouly@arm.com>, 
	Suzuki K Poulose <suzuki.poulose@arm.com>, Oliver Upton <oupton@kernel.org>, 
	Zenghui Yu <yuzenghui@huawei.com>, Christoffer Dall <christoffer.dall@arm.com>, 
	Volodymyr Babchuk <Volodymyr_Babchuk@epam.com>
Subject: Re: [PATCH v2 12/45] KVM: arm64: GICv3: Extract LR folding primitive
Message-ID: <3tb7ekdzl5f4rs24bla63vw22awejhbn7ngvttid7v7bzaer2m@62bxshf7uj34>
References: <20251109171619.1507205-1-maz@kernel.org>
 <20251109171619.1507205-13-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251109171619.1507205-13-maz@kernel.org>

On Sun, Nov 09, 2025 at 05:15:46PM +0800, Marc Zyngier wrote:
> As we are going to need to handle deactivation for interrupts that
> are not in the LRs, split vgic_v3_fold_lr_state() into a helper
> that deals with a single interrupt, and the function that loops
> over the used LRs.
>
> Signed-off-by: Marc Zyngier <maz@kernel.org>
> ---
>  arch/arm64/kvm/vgic/vgic-v3.c | 88 +++++++++++++++++------------------
>  1 file changed, 43 insertions(+), 45 deletions(-)
>
> diff --git a/arch/arm64/kvm/vgic/vgic-v3.c b/arch/arm64/kvm/vgic/vgic-v3.c
> index 3ede79e381513..0fccfe9e3e8dd 100644
> --- a/arch/arm64/kvm/vgic/vgic-v3.c
> +++ b/arch/arm64/kvm/vgic/vgic-v3.c
> @@ -33,78 +33,76 @@ static bool lr_signals_eoi_mi(u64 lr_val)
>  	       !(lr_val & ICH_LR_HW);
>  }
>
> -void vgic_v3_fold_lr_state(struct kvm_vcpu *vcpu)
> +static void vgic_v3_fold_lr(struct kvm_vcpu *vcpu, u64 val)
>  {
> -	struct vgic_cpu *vgic_cpu = &vcpu->arch.vgic_cpu;
> -	struct vgic_v3_cpu_if *cpuif = &vgic_cpu->vgic_v3;
> -	u32 model = vcpu->kvm->arch.vgic.vgic_model;
> -	int lr;
> -
> -	DEBUG_SPINLOCK_BUG_ON(!irqs_disabled());
> -
> -	cpuif->vgic_hcr &= ~ICH_HCR_EL2_UIE;
> -
> -	for (lr = 0; lr < cpuif->used_lrs; lr++) {
> -		u64 val = cpuif->vgic_lr[lr];
> -		u32 intid, cpuid;
> -		struct vgic_irq *irq;
> -		bool is_v2_sgi = false;
> -		bool deactivated;
> -
> -		cpuid = val & GICH_LR_PHYSID_CPUID;
> -		cpuid >>= GICH_LR_PHYSID_CPUID_SHIFT;
> -
> -		if (model == KVM_DEV_TYPE_ARM_VGIC_V3) {
> -			intid = val & ICH_LR_VIRTUAL_ID_MASK;
> -		} else {
> -			intid = val & GICH_LR_VIRTUALID;
> -			is_v2_sgi = vgic_irq_is_sgi(intid);
> -		}
> +	struct vgic_irq *irq;
> +	bool is_v2_sgi = false;
> +	bool deactivated;
> +	u32 intid;
>
> -		/* Notify fds when the guest EOI'ed a level-triggered IRQ */
> -		if (lr_signals_eoi_mi(val) && vgic_valid_spi(vcpu->kvm, intid))
> -			kvm_notify_acked_irq(vcpu->kvm, 0,
> -					     intid - VGIC_NR_PRIVATE_IRQS);
> +	if (vcpu->kvm->arch.vgic.vgic_model == KVM_DEV_TYPE_ARM_VGIC_V3) {
> +		intid = val & ICH_LR_VIRTUAL_ID_MASK;
> +	} else {
> +		intid = val & GICH_LR_VIRTUALID;
> +		is_v2_sgi = vgic_irq_is_sgi(intid);
> +	}
>
> -		irq = vgic_get_vcpu_irq(vcpu, intid);
> -		if (!irq)	/* An LPI could have been unmapped. */
> -			continue;
> +	irq = vgic_get_vcpu_irq(vcpu, intid);
> +	if (!irq)	/* An LPI could have been unmapped. */
> +		return;
>
> -		raw_spin_lock(&irq->irq_lock);
> +	/* Notify fds when the guest EOI'ed a level-triggered IRQ */
> +	if (lr_signals_eoi_mi(val) && vgic_valid_spi(vcpu->kvm, intid))
> +		kvm_notify_acked_irq(vcpu->kvm, 0,
> +				     intid - VGIC_NR_PRIVATE_IRQS);

The fds notifiy happens before checking irq's mapping before
this patch, and now in reversal order w/ above change. It's
fine for vLPI, and for vSPI no necessary call
kvm_notify_acked_irq() if the it has been remapped, no
gsi<->pin mapping there. Is above understanding correct ?

>
> +	scoped_guard(raw_spinlock, &irq->irq_lock) {
>  		/* Always preserve the active bit for !LPIs, note deactivation */
>  		if (irq->intid >= VGIC_MIN_LPI)
>  			val &= ~ICH_LR_ACTIVE_BIT;
>  		deactivated = irq->active && !(val & ICH_LR_ACTIVE_BIT);
>  		irq->active = !!(val & ICH_LR_ACTIVE_BIT);
>
> -		if (irq->active && is_v2_sgi)
> -			irq->active_source = cpuid;
> -
>  		/* Edge is the only case where we preserve the pending bit */
>  		if (irq->config == VGIC_CONFIG_EDGE &&
> -		    (val & ICH_LR_PENDING_BIT)) {
> +		    (val & ICH_LR_PENDING_BIT))
>  			irq->pending_latch = true;
>
> -			if (is_v2_sgi)
> -				irq->source |= (1 << cpuid);
> -		}
> -
>  		/*
>  		 * Clear soft pending state when level irqs have been acked.
>  		 */
>  		if (irq->config == VGIC_CONFIG_LEVEL && !(val & ICH_LR_STATE))
>  			irq->pending_latch = false;
>
> +		if (is_v2_sgi) {
> +			u8 cpuid = FIELD_GET(GICH_LR_PHYSID_CPUID, val);
> +
> +			if (irq->active)
> +				irq->active_source = cpuid;
> +
> +			if (val & ICH_LR_PENDING_BIT)
> +				irq->source |= BIT(cpuid);
> +		}
> +
>  		/* Handle resampling for mapped interrupts if required */
>  		vgic_irq_handle_resampling(irq, deactivated, val & ICH_LR_PENDING_BIT);
>
>  		irq->on_lr = false;
> -
> -		raw_spin_unlock(&irq->irq_lock);
> -		vgic_put_irq(vcpu->kvm, irq);
>  	}
>
> +	vgic_put_irq(vcpu->kvm, irq);
> +}
> +
> +void vgic_v3_fold_lr_state(struct kvm_vcpu *vcpu)
> +{
> +	struct vgic_cpu *vgic_cpu = &vcpu->arch.vgic_cpu;
> +	struct vgic_v3_cpu_if *cpuif = &vgic_cpu->vgic_v3;
> +
> +	DEBUG_SPINLOCK_BUG_ON(!irqs_disabled());
> +
> +	for (int lr = 0; lr < cpuif->used_lrs; lr++)
> +		vgic_v3_fold_lr(vcpu, cpuif->vgic_lr[lr]);
> +
>  	cpuif->used_lrs = 0;
>  }
>
> --
> 2.47.3

