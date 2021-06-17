Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 587433AB6AE
	for <lists+kvm@lfdr.de>; Thu, 17 Jun 2021 16:57:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233058AbhFQO75 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 17 Jun 2021 10:59:57 -0400
Received: from foss.arm.com ([217.140.110.172]:54884 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233086AbhFQO7r (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 17 Jun 2021 10:59:47 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 2702613D5;
        Thu, 17 Jun 2021 07:57:39 -0700 (PDT)
Received: from [192.168.0.110] (unknown [172.31.20.19])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id B0B403F719;
        Thu, 17 Jun 2021 07:57:37 -0700 (PDT)
Subject: Re: [PATCH v4 6/9] KVM: arm64: vgic: Implement SW-driven deactivation
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
 <20210601104005.81332-7-maz@kernel.org>
From:   Alexandru Elisei <alexandru.elisei@arm.com>
Message-ID: <b87fb2e9-a3f9-accc-86d9-64dc2ee90dea@arm.com>
Date:   Thu, 17 Jun 2021 15:58:31 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <20210601104005.81332-7-maz@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Marc,

On 6/1/21 11:40 AM, Marc Zyngier wrote:
> In order to deal with these systems that do not offer HW-based
> deactivation of interrupts, let implement a SW-based approach:

Nitpick, but shouldn't that be "let's"?

>
> - When the irq is queued into a LR, treat it as a pure virtual
>   interrupt and set the EOI flag in the LR.
>
> - When the interrupt state is read back from the LR, force a
>   deactivation when the state is invalid (neither active nor
>   pending)
>
> Interrupts requiring such treatment get the VGIC_SW_RESAMPLE flag.
>
> Signed-off-by: Marc Zyngier <maz@kernel.org>
> ---
>  arch/arm64/kvm/vgic/vgic-v2.c | 19 +++++++++++++++----
>  arch/arm64/kvm/vgic/vgic-v3.c | 19 +++++++++++++++----
>  include/kvm/arm_vgic.h        | 10 ++++++++++
>  3 files changed, 40 insertions(+), 8 deletions(-)
>
> diff --git a/arch/arm64/kvm/vgic/vgic-v2.c b/arch/arm64/kvm/vgic/vgic-v2.c
> index 11934c2af2f4..2c580204f1dc 100644
> --- a/arch/arm64/kvm/vgic/vgic-v2.c
> +++ b/arch/arm64/kvm/vgic/vgic-v2.c
> @@ -108,11 +108,22 @@ void vgic_v2_fold_lr_state(struct kvm_vcpu *vcpu)
>  		 * If this causes us to lower the level, we have to also clear
>  		 * the physical active state, since we will otherwise never be
>  		 * told when the interrupt becomes asserted again.
> +		 *
> +		 * Another case is when the interrupt requires a helping hand
> +		 * on deactivation (no HW deactivation, for example).
>  		 */
> -		if (vgic_irq_is_mapped_level(irq) && (val & GICH_LR_PENDING_BIT)) {
> -			irq->line_level = vgic_get_phys_line_level(irq);
> +		if (vgic_irq_is_mapped_level(irq)) {
> +			bool resample = false;
> +
> +			if (val & GICH_LR_PENDING_BIT) {
> +				irq->line_level = vgic_get_phys_line_level(irq);
> +				resample = !irq->line_level;
> +			} else if (vgic_irq_needs_resampling(irq) &&
> +				   !(irq->active || irq->pending_latch)) {

I'm having a hard time figuring out when and why a level sensitive can have
pending_latch = true.

I looked kvm_vgic_inject_irq(), and that function sets pending_latch only for edge
triggered interrupts (it sets line_level for level sensitive ones). But
irq_is_pending() looks at **both** pending_latch and line_level for level
sensitive interrupts.

The only place that I've found that sets pending_latch regardless of the interrupt
type is in vgic_mmio_write_spending() (called on a trapped write to
GICD_ISENABLER). vgic_v2_populate_lr() clears pending_latch only for edge
triggered interrupts, so that leaves vgic_v2_fold_lr_state() as the only function
pending_latch is cleared for level sensitive interrupts, when the interrupt has
been handled by the guest. Are we doing all of this to emulate the fact that level
sensitive interrupts (either purely virtual or hw mapped) made pending by a write
to GICD_ISENABLER remain pending until they are handled by the guest?

If that is the case, then I think this is what the code is doing:

- There's no functional change when the irqchip has HW deactivation

- For level sensitive, hw mapped interrupts made pending by a write to
GICD_ISENABLER and not yet handled by the guest (pending_latch == true) we don't
clear the pending state of the interrupt.

- For level sensitive, hw mapped interrupts we clear the pending state in the GIC
and the device will assert the interrupt again if it's still pending at the device
level. I have a question about this. Why don't we sample the interrupt state by
calling vgic_get_phys_line_level()? Because that would be slower than the
alternative that you are proposing here?

> +				resample = true;
> +			}
>  
> -			if (!irq->line_level)
> +			if (resample)
>  				vgic_irq_set_phys_active(irq, false);
>  		}
>  
> @@ -152,7 +163,7 @@ void vgic_v2_populate_lr(struct kvm_vcpu *vcpu, struct vgic_irq *irq, int lr)
>  	if (irq->group)
>  		val |= GICH_LR_GROUP1;
>  
> -	if (irq->hw) {
> +	if (irq->hw && !vgic_irq_needs_resampling(irq)) {

This looks good, we set the EOI bit in the LR register in the case of purely
virtual level sensitive interrupts or for HW mapped level sensitive on systems
where the GIC doesn't have the mandatory HW deactivation architectural feature.

>  		val |= GICH_LR_HW;
>  		val |= irq->hwintid << GICH_LR_PHYSID_CPUID_SHIFT;
>  		/*
> diff --git a/arch/arm64/kvm/vgic/vgic-v3.c b/arch/arm64/kvm/vgic/vgic-v3.c
> index 41ecf219c333..66004f61cd83 100644
> --- a/arch/arm64/kvm/vgic/vgic-v3.c
> +++ b/arch/arm64/kvm/vgic/vgic-v3.c
> @@ -101,11 +101,22 @@ void vgic_v3_fold_lr_state(struct kvm_vcpu *vcpu)
>  		 * If this causes us to lower the level, we have to also clear
>  		 * the physical active state, since we will otherwise never be
>  		 * told when the interrupt becomes asserted again.
> +		 *
> +		 * Another case is when the interrupt requires a helping hand
> +		 * on deactivation (no HW deactivation, for example).
>  		 */
> -		if (vgic_irq_is_mapped_level(irq) && (val & ICH_LR_PENDING_BIT)) {
> -			irq->line_level = vgic_get_phys_line_level(irq);
> +		if (vgic_irq_is_mapped_level(irq)) {
> +			bool resample = false;
> +
> +			if (val & ICH_LR_PENDING_BIT) {
> +				irq->line_level = vgic_get_phys_line_level(irq);
> +				resample = !irq->line_level;
> +			} else if (vgic_irq_needs_resampling(irq) &&
> +				   !(irq->active || irq->pending_latch)) {
> +				resample = true;
> +			}
>  
> -			if (!irq->line_level)
> +			if (resample)
>  				vgic_irq_set_phys_active(irq, false);
>  		}
>  
> @@ -136,7 +147,7 @@ void vgic_v3_populate_lr(struct kvm_vcpu *vcpu, struct vgic_irq *irq, int lr)
>  		}
>  	}
>  
> -	if (irq->hw) {
> +	if (irq->hw && !vgic_irq_needs_resampling(irq)) {

Both changes to the vGICv3 code look identical to the vGICv2 changes.

Thanks,

Alex

>  		val |= ICH_LR_HW;
>  		val |= ((u64)irq->hwintid) << ICH_LR_PHYS_ID_SHIFT;
>  		/*
> diff --git a/include/kvm/arm_vgic.h b/include/kvm/arm_vgic.h
> index e5f06df000f2..e602d848fc1a 100644
> --- a/include/kvm/arm_vgic.h
> +++ b/include/kvm/arm_vgic.h
> @@ -99,6 +99,11 @@ enum vgic_irq_config {
>   * kvm_arm_get_running_vcpu() to get the vcpu pointer for private IRQs.
>   */
>  struct irq_ops {
> +	/* Per interrupt flags for special-cased interrupts */
> +	unsigned long flags;
> +
> +#define VGIC_IRQ_SW_RESAMPLE	BIT(0)	/* Clear the active state for resampling */
> +
>  	/*
>  	 * Callback function pointer to in-kernel devices that can tell us the
>  	 * state of the input level of mapped level-triggered IRQ faster than
> @@ -150,6 +155,11 @@ struct vgic_irq {
>  					   for in-kernel devices. */
>  };
>  
> +static inline bool vgic_irq_needs_resampling(struct vgic_irq *irq)
> +{
> +	return irq->ops && (irq->ops->flags & VGIC_IRQ_SW_RESAMPLE);
> +}
> +
>  struct vgic_register_region;
>  struct vgic_its;
>  
