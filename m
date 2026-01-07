Return-Path: <kvm+bounces-67239-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 9E099CFF1E6
	for <lists+kvm@lfdr.de>; Wed, 07 Jan 2026 18:32:53 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 679F631E2933
	for <lists+kvm@lfdr.de>; Wed,  7 Jan 2026 16:18:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C47DF355047;
	Wed,  7 Jan 2026 16:09:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.b="cCvUJgDO"
X-Original-To: kvm@vger.kernel.org
Received: from sinmsgout01.his.huawei.com (sinmsgout01.his.huawei.com [119.8.177.36])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B431838BF95
	for <kvm@vger.kernel.org>; Wed,  7 Jan 2026 16:08:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=119.8.177.36
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767802139; cv=none; b=rpXXZCQAAUmInnymHi4B1KUb4i7gz4vjC5T5KopDAQftAsZe1zV6WmHoixRE8nQCCsEiiFVpvpuTl7JtMgoHu/eSWD0gA9KkUYNEewaukwDmCyNbQfSQIYf7Es0yzYWcvxrsziwfttH4xf6lkKat3GJtyw0vTWY5U9rWaOPeacs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767802139; c=relaxed/simple;
	bh=9t0BYeSb14nKm4LFO11dg4sM7qCWC+SYrXv63cs9irc=;
	h=Date:From:To:CC:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=b8YIBeeBikJ+RGmx7BMowYW7SBcuNObs5DsyW1Ua+BqVqMJTW2rZJ9GGyr3YJBBbacG9uXSMzJEOjwFIh9DvE5U9mIIMxZlmDTeb0v5D6ifB4wWl7xKWFhAgSQFq0vVS3kkay3YM2oRDtzny62MrKN8SdZR07pnOAHF9Tpa6dWE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.b=cCvUJgDO; arc=none smtp.client-ip=119.8.177.36
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=e5IbqEz5mr4wxl5S1XL1pTXse7zZi1lcxr+VuF8a5xA=;
	b=cCvUJgDOC6LAP9IqYwxSvtr+AjbiGNJkRw9VOuAF4Hr6D+kJwG68NMWAIE0iG4S7EBEo1p4ny
	3x0AjIKalpRk+g6lIp37cLvRTtvqmSQ/sJFraf/URr1SnqBHnet9QgRZkL3JcmgagP5z5e4GZR7
	HwQR/VVsubyEtAXTDG50oGw=
Received: from frasgout.his.huawei.com (unknown [172.18.146.32])
	by sinmsgout01.his.huawei.com (SkyGuard) with ESMTPS id 4dmXvx4YJXz1P7H7;
	Thu,  8 Jan 2026 00:06:21 +0800 (CST)
Received: from mail.maildlp.com (unknown [172.18.224.83])
	by frasgout.his.huawei.com (SkyGuard) with ESMTPS id 4dmXyZ27CDzHnGdT;
	Thu,  8 Jan 2026 00:08:38 +0800 (CST)
Received: from dubpeml100005.china.huawei.com (unknown [7.214.146.113])
	by mail.maildlp.com (Postfix) with ESMTPS id B46A940086;
	Thu,  8 Jan 2026 00:08:44 +0800 (CST)
Received: from localhost (10.203.177.15) by dubpeml100005.china.huawei.com
 (7.214.146.113) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.36; Wed, 7 Jan
 2026 16:08:43 +0000
Date: Wed, 7 Jan 2026 16:08:42 +0000
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
Subject: Re: [PATCH v2 26/36] KVM: arm64: gic-v5: Bump arch timer for GICv5
Message-ID: <20260107160842.00003c8e@huawei.com>
In-Reply-To: <20251219155222.1383109-27-sascha.bischoff@arm.com>
References: <20251219155222.1383109-1-sascha.bischoff@arm.com>
	<20251219155222.1383109-27-sascha.bischoff@arm.com>
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

On Fri, 19 Dec 2025 15:52:45 +0000
Sascha Bischoff <Sascha.Bischoff@arm.com> wrote:

> Now that GICv5 has arrived, the arch timer requires some TLC to
> address some of the key differences introduced with GICv5.
> 
> For PPIs on GICv5, the set_pending_state and queue_irq_unlock irq_ops
> are used as AP lists are not required at all for GICv5. The arch timer
> also introduces an irq_op - get_input_level. Extend the
> arch-timer-provided irq_ops to include the two PPI ops for vgic_v5
> guests.
> 
> When possible, DVI (Direct Virtual Interrupt) is set for PPIs when
> using a vgic_v5, which directly inject the pending state in to the

into ?

> guest. This means that the host never sees the interrupt for the guest
> for these interrupts. This has two impacts.
> 
> * First of all, the kvm_cpu_has_pending_timer check is updated to
>   explicitly check if the timers are expected to fire.
> 
> * Secondly, for mapped timers (which use DVI) they must be masked on
>   the host prior to entering a GICv5 guest, and unmasked on the return
>   path. This is handled in set_timer_irq_phys_masked.
> 
> The final, but rather important, change is that the architected PPIs
> for the timers are made mandatory for a GICv5 guest. Attempts to set
> them to anything else are actively rejected. Once a vgic_v5 is
> initialised, the arch timer PPIs are also explicitly reinitialised to
> ensure the correct GICv5-compatible PPIs are used - this also adds in
> the GICv5 PPI type to the intid.
> 
> Signed-off-by: Sascha Bischoff <sascha.bischoff@arm.com>
Various comments inline. 

J
> ---
>  arch/arm64/kvm/arch_timer.c     | 110 ++++++++++++++++++++++++++------
>  arch/arm64/kvm/vgic/vgic-init.c |   9 +++
>  arch/arm64/kvm/vgic/vgic-v5.c   |   8 +--
>  include/kvm/arm_arch_timer.h    |   7 +-
>  include/kvm/arm_vgic.h          |   4 ++
>  5 files changed, 115 insertions(+), 23 deletions(-)
> 
> diff --git a/arch/arm64/kvm/arch_timer.c b/arch/arm64/kvm/arch_timer.c
> index 6f033f6644219..78d66a67b34ac 100644
> --- a/arch/arm64/kvm/arch_timer.c
> +++ b/arch/arm64/kvm/arch_timer.c


>  void kvm_timer_sync_nested(struct kvm_vcpu *vcpu)
> @@ -1034,12 +1079,15 @@ void kvm_timer_vcpu_reset(struct kvm_vcpu *vcpu)
>  	if (timer->enabled) {
>  		for (int i = 0; i < nr_timers(vcpu); i++)
>  			kvm_timer_update_irq(vcpu, false,
> -					     vcpu_get_timer(vcpu, i));
> +					vcpu_get_timer(vcpu, i));

Unrelated change, and a bad one at that!


>  
>  		if (irqchip_in_kernel(vcpu->kvm)) {
> -			kvm_vgic_reset_mapped_irq(vcpu, timer_irq(map.direct_vtimer));
> +			kvm_vgic_reset_mapped_irq(
> +				vcpu, timer_irq(map.direct_vtimer));

Also unrelated and not a good change.

>  			if (map.direct_ptimer)
> -				kvm_vgic_reset_mapped_irq(vcpu, timer_irq(map.direct_ptimer));
> +				kvm_vgic_reset_mapped_irq(
> +					vcpu,
> +					timer_irq(map.direct_ptimer));

Leave all these alone.

>  		}
>  	}
>  
> @@ -1092,10 +1140,19 @@ void kvm_timer_vcpu_init(struct kvm_vcpu *vcpu)
>  		      HRTIMER_MODE_ABS_HARD);
>  }
>  
> +/*
> + * This is always called during kvm_arch_init_vm, but will also be
> + * called from kvm_vgic_create if we have a vGICv5.
> + */
>  void kvm_timer_init_vm(struct kvm *kvm)
>  {
> +	/*
> +	 * Set up the default PPIs - note that we adjust them based on
> +	 * the model of the GIC as GICv5 uses a different way to
> +	 * describing interrupts.
> +	 */
>  	for (int i = 0; i < NR_KVM_TIMERS; i++)
> -		kvm->arch.timer_data.ppi[i] = default_ppi[i];
> +		kvm->arch.timer_data.ppi[i] = get_vgic_ppi(kvm, default_ppi[i]);
>  }
>  
>  void kvm_timer_cpu_up(void)
> @@ -1347,6 +1404,7 @@ static int kvm_irq_init(struct arch_timer_kvm_info *info)
>  		}
>  
>  		arch_timer_irq_ops.flags |= VGIC_IRQ_SW_RESAMPLE;
> +		arch_timer_irq_ops_vgic_v5.flags |= VGIC_IRQ_SW_RESAMPLE;
>  		WARN_ON(irq_domain_push_irq(domain, host_vtimer_irq,
>  					    (void *)TIMER_VTIMER));
>  	}
> @@ -1497,10 +1555,13 @@ static bool timer_irqs_are_valid(struct kvm_vcpu *vcpu)
>  			break;
>  
>  		/*
> -		 * We know by construction that we only have PPIs, so
> -		 * all values are less than 32.
> +		 * We know by construction that we only have PPIs, so all values
> +		 * are less than 32 for non-GICv5 vgics. On GICv5, they are

VGICs maybe?  It's not consistent in existing comments in this file though.

> +		 * architecturally defined to be under 32 too. However, we mask
> +		 * off most of the bits as we might be presented with a GICv5
> +		 * style PPI where the type is encoded in the top-bits.
>  		 */
> -		ppis |= BIT(irq);
> +		ppis |= BIT(irq & 0x1f);
>  	}
>  
>  	valid = hweight32(ppis) == nr_timers(vcpu);
> @@ -1538,7 +1599,9 @@ int kvm_timer_enable(struct kvm_vcpu *vcpu)
>  {
>  	struct arch_timer_cpu *timer = vcpu_timer(vcpu);
>  	struct timer_map map;
> +	struct irq_ops *ops;
>  	int ret;
> +	int irq;
Might as well put irq on same line as ret

>  
>  	if (timer->enabled)
>  		return 0;
> @@ -1556,20 +1619,22 @@ int kvm_timer_enable(struct kvm_vcpu *vcpu)
>  		return -EINVAL;
>  	}
>  
> +	ops = vgic_is_v5(vcpu->kvm) ? &arch_timer_irq_ops_vgic_v5 :
> +				      &arch_timer_irq_ops;
> +
>  	get_timer_map(vcpu, &map);
>  
> -	ret = kvm_vgic_map_phys_irq(vcpu,
> -				    map.direct_vtimer->host_timer_irq,
> -				    timer_irq(map.direct_vtimer),
> -				    &arch_timer_irq_ops);
> +	irq = timer_irq(map.direct_vtimer);
> +	ret = kvm_vgic_map_phys_irq(vcpu, map.direct_vtimer->host_timer_irq,
> +				    irq, ops);

As irq is only used with this value in here, I'd avoid having the local variable
that changes meaning.

	ret = kvm_vgic_map_phys_irq(vcpu, map.direct_vtimer->host_timer_irq,
				    timer_irq(map.direct_vtimer), ops);
>  	if (ret)
>  		return ret;
>  
>  	if (map.direct_ptimer) {
> +		irq = timer_irq(map.direct_ptimer);
>  		ret = kvm_vgic_map_phys_irq(vcpu,
>  					    map.direct_ptimer->host_timer_irq,
> -					    timer_irq(map.direct_ptimer),
> -					    &arch_timer_irq_ops);
> +					    irq, ops);
As above
					    timer_irq(map.direct_ptimer), ops);

Doesn't make it much harder to read and avoids the local variable
being needed.
>  	}
>  
>  	if (ret)
> @@ -1627,6 +1692,15 @@ int kvm_arm_timer_set_attr(struct kvm_vcpu *vcpu, struct kvm_device_attr *attr)
>  		goto out;
>  	}
>  
> +	/*
> +	 * The PPIs for the Arch Timers arch architecturally defined for
> +	 * GICv5. Reject anything that changes them from the specified value.
> +	 */
> +	if (vgic_is_v5(vcpu->kvm) && vcpu->kvm->arch.timer_data.ppi[idx] != irq) {
> +		ret = -EINVAL;
> +		goto out;

Whilst you are here, maybe throw some guard() magic dust at this and do a direct return?
Or leave it for someone else who has more spare time ;)

> +	}
> +
>  	/*
>  	 * We cannot validate the IRQ unicity before we run, so take it at
>  	 * face value. The verdict will be given on first vcpu run, for each

> diff --git a/include/kvm/arm_arch_timer.h b/include/kvm/arm_arch_timer.h
> index 7310841f45121..6cb9c20f9db65 100644
> --- a/include/kvm/arm_arch_timer.h
> +++ b/include/kvm/arm_arch_timer.h

>  
>  struct arch_timer_context {
> @@ -130,6 +132,9 @@ void kvm_timer_init_vhe(void);
>  #define timer_vm_data(ctx)		(&(timer_context_to_vcpu(ctx)->kvm->arch.timer_data))
>  #define timer_irq(ctx)			(timer_vm_data(ctx)->ppi[arch_timer_ctx_index(ctx)])
>  
> +#define get_vgic_ppi(k, i) (((k)->arch.vgic.vgic_model != KVM_DEV_TYPE_ARM_VGIC_V5) ? \
> +				(i) : ((i) | FIELD_PREP(GICV5_HWIRQ_TYPE, GICV5_HWIRQ_TYPE_PPI)))

Similar to earlier comment I'd use FIELD_PREP() for i as well but not that important
I'm just lazy about remembering where the numbers go.



>  


