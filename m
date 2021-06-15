Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A878E3A831E
	for <lists+kvm@lfdr.de>; Tue, 15 Jun 2021 16:44:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230380AbhFOOqN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 15 Jun 2021 10:46:13 -0400
Received: from foss.arm.com ([217.140.110.172]:37532 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230076AbhFOOqM (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 15 Jun 2021 10:46:12 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id B01BC12FC;
        Tue, 15 Jun 2021 07:44:07 -0700 (PDT)
Received: from [192.168.0.110] (unknown [172.31.20.19])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 3F25F3F70D;
        Tue, 15 Jun 2021 07:44:06 -0700 (PDT)
Subject: Re: [PATCH v4 5/9] KVM: arm64: vgic: move irq->get_input_level into
 an ops structure
To:     Marc Zyngier <maz@kernel.org>,
        linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org,
        kvmarm@lists.cs.columbia.edu
Cc:     James Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Eric Auger <eric.auger@redhat.com>,
        Hector Martin <marcan@marcan.st>,
        Mark Rutland <mark.rutland@arm.com>,
        Zenghui Yu <yuzenghui@huawei.com>, kernel-team@android.com
References: <20210601104005.81332-1-maz@kernel.org>
 <20210601104005.81332-6-maz@kernel.org>
From:   Alexandru Elisei <alexandru.elisei@arm.com>
Message-ID: <da762d7c-9eec-4fb8-ab6f-10bde6d777b3@arm.com>
Date:   Tue, 15 Jun 2021 15:45:03 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <20210601104005.81332-6-maz@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Marc,

On 6/1/21 11:40 AM, Marc Zyngier wrote:
> We already have the option to attach a callback to an interrupt
> to retrieve its pending state. As we are planning to expand this
> facility, move this callback into its own data structure.
>
> This will limit the size of individual interrupts as the ops
> structures can be shared across multiple interrupts.

I can't figure out what you mean by that. If you are referring to struct vgic_irq,
the change I am seeing is a pointer being replaced by another pointer, which
shouldn't affect its size. Are you referring to something else?

>
> Signed-off-by: Marc Zyngier <maz@kernel.org>
> ---
>  arch/arm64/kvm/arch_timer.c |  8 ++++++--
>  arch/arm64/kvm/vgic/vgic.c  | 14 +++++++-------
>  include/kvm/arm_vgic.h      | 28 +++++++++++++++++-----------
>  3 files changed, 30 insertions(+), 20 deletions(-)
>
> diff --git a/arch/arm64/kvm/arch_timer.c b/arch/arm64/kvm/arch_timer.c
> index 74e0699661e9..e2288b6bf435 100644
> --- a/arch/arm64/kvm/arch_timer.c
> +++ b/arch/arm64/kvm/arch_timer.c
> @@ -1116,6 +1116,10 @@ bool kvm_arch_timer_get_input_level(int vintid)
>  	return kvm_timer_should_fire(timer);
>  }
>  
> +static struct irq_ops arch_timer_irq_ops = {
> +	.get_input_level = kvm_arch_timer_get_input_level,

Since kvm_arch_timer_get_input_level() is used only indirectly, through the
get_input_level field of the static struct, I think we can make
kvm_arch_timer_get_input_level() static and remove the declaration from
include/kvm/arm_arch_timer.h.

Other than that, everything else looks correct.

Thanks,

Alex

> +};
> +
>  int kvm_timer_enable(struct kvm_vcpu *vcpu)
>  {
>  	struct arch_timer_cpu *timer = vcpu_timer(vcpu);
> @@ -1143,7 +1147,7 @@ int kvm_timer_enable(struct kvm_vcpu *vcpu)
>  	ret = kvm_vgic_map_phys_irq(vcpu,
>  				    map.direct_vtimer->host_timer_irq,
>  				    map.direct_vtimer->irq.irq,
> -				    kvm_arch_timer_get_input_level);
> +				    &arch_timer_irq_ops);
>  	if (ret)
>  		return ret;
>  
> @@ -1151,7 +1155,7 @@ int kvm_timer_enable(struct kvm_vcpu *vcpu)
>  		ret = kvm_vgic_map_phys_irq(vcpu,
>  					    map.direct_ptimer->host_timer_irq,
>  					    map.direct_ptimer->irq.irq,
> -					    kvm_arch_timer_get_input_level);
> +					    &arch_timer_irq_ops);
>  	}
>  
>  	if (ret)
> diff --git a/arch/arm64/kvm/vgic/vgic.c b/arch/arm64/kvm/vgic/vgic.c
> index 15b666200f0b..111bff47e471 100644
> --- a/arch/arm64/kvm/vgic/vgic.c
> +++ b/arch/arm64/kvm/vgic/vgic.c
> @@ -182,8 +182,8 @@ bool vgic_get_phys_line_level(struct vgic_irq *irq)
>  
>  	BUG_ON(!irq->hw);
>  
> -	if (irq->get_input_level)
> -		return irq->get_input_level(irq->intid);
> +	if (irq->ops && irq->ops->get_input_level)
> +		return irq->ops->get_input_level(irq->intid);
>  
>  	WARN_ON(irq_get_irqchip_state(irq->host_irq,
>  				      IRQCHIP_STATE_PENDING,
> @@ -480,7 +480,7 @@ int kvm_vgic_inject_irq(struct kvm *kvm, int cpuid, unsigned int intid,
>  /* @irq->irq_lock must be held */
>  static int kvm_vgic_map_irq(struct kvm_vcpu *vcpu, struct vgic_irq *irq,
>  			    unsigned int host_irq,
> -			    bool (*get_input_level)(int vindid))
> +			    struct irq_ops *ops)
>  {
>  	struct irq_desc *desc;
>  	struct irq_data *data;
> @@ -500,7 +500,7 @@ static int kvm_vgic_map_irq(struct kvm_vcpu *vcpu, struct vgic_irq *irq,
>  	irq->hw = true;
>  	irq->host_irq = host_irq;
>  	irq->hwintid = data->hwirq;
> -	irq->get_input_level = get_input_level;
> +	irq->ops = ops;
>  	return 0;
>  }
>  
> @@ -509,11 +509,11 @@ static inline void kvm_vgic_unmap_irq(struct vgic_irq *irq)
>  {
>  	irq->hw = false;
>  	irq->hwintid = 0;
> -	irq->get_input_level = NULL;
> +	irq->ops = NULL;
>  }
>  
>  int kvm_vgic_map_phys_irq(struct kvm_vcpu *vcpu, unsigned int host_irq,
> -			  u32 vintid, bool (*get_input_level)(int vindid))
> +			  u32 vintid, struct irq_ops *ops)
>  {
>  	struct vgic_irq *irq = vgic_get_irq(vcpu->kvm, vcpu, vintid);
>  	unsigned long flags;
> @@ -522,7 +522,7 @@ int kvm_vgic_map_phys_irq(struct kvm_vcpu *vcpu, unsigned int host_irq,
>  	BUG_ON(!irq);
>  
>  	raw_spin_lock_irqsave(&irq->irq_lock, flags);
> -	ret = kvm_vgic_map_irq(vcpu, irq, host_irq, get_input_level);
> +	ret = kvm_vgic_map_irq(vcpu, irq, host_irq, ops);
>  	raw_spin_unlock_irqrestore(&irq->irq_lock, flags);
>  	vgic_put_irq(vcpu->kvm, irq);
>  
> diff --git a/include/kvm/arm_vgic.h b/include/kvm/arm_vgic.h
> index e45b26e8d479..e5f06df000f2 100644
> --- a/include/kvm/arm_vgic.h
> +++ b/include/kvm/arm_vgic.h
> @@ -92,6 +92,21 @@ enum vgic_irq_config {
>  	VGIC_CONFIG_LEVEL
>  };
>  
> +/*
> + * Per-irq ops overriding some common behavious.
> + *
> + * Always called in non-preemptible section and the functions can use
> + * kvm_arm_get_running_vcpu() to get the vcpu pointer for private IRQs.
> + */
> +struct irq_ops {
> +	/*
> +	 * Callback function pointer to in-kernel devices that can tell us the
> +	 * state of the input level of mapped level-triggered IRQ faster than
> +	 * peaking into the physical GIC.
> +	 */
> +	bool (*get_input_level)(int vintid);
> +};
> +
>  struct vgic_irq {
>  	raw_spinlock_t irq_lock;	/* Protects the content of the struct */
>  	struct list_head lpi_list;	/* Used to link all LPIs together */
> @@ -129,16 +144,7 @@ struct vgic_irq {
>  	u8 group;			/* 0 == group 0, 1 == group 1 */
>  	enum vgic_irq_config config;	/* Level or edge */
>  
> -	/*
> -	 * Callback function pointer to in-kernel devices that can tell us the
> -	 * state of the input level of mapped level-triggered IRQ faster than
> -	 * peaking into the physical GIC.
> -	 *
> -	 * Always called in non-preemptible section and the functions can use
> -	 * kvm_arm_get_running_vcpu() to get the vcpu pointer for private
> -	 * IRQs.
> -	 */
> -	bool (*get_input_level)(int vintid);
> +	struct irq_ops *ops;
>  
>  	void *owner;			/* Opaque pointer to reserve an interrupt
>  					   for in-kernel devices. */
> @@ -355,7 +361,7 @@ void kvm_vgic_init_cpu_hardware(void);
>  int kvm_vgic_inject_irq(struct kvm *kvm, int cpuid, unsigned int intid,
>  			bool level, void *owner);
>  int kvm_vgic_map_phys_irq(struct kvm_vcpu *vcpu, unsigned int host_irq,
> -			  u32 vintid, bool (*get_input_level)(int vindid));
> +			  u32 vintid, struct irq_ops *ops);
>  int kvm_vgic_unmap_phys_irq(struct kvm_vcpu *vcpu, unsigned int vintid);
>  bool kvm_vgic_map_is_active(struct kvm_vcpu *vcpu, unsigned int vintid);
>  
