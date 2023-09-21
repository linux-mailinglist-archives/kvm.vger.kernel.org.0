Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2B9677A9EC3
	for <lists+kvm@lfdr.de>; Thu, 21 Sep 2023 22:12:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231339AbjIUUMF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 21 Sep 2023 16:12:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52694 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230445AbjIUULh (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 21 Sep 2023 16:11:37 -0400
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 66FC258C16
        for <kvm@vger.kernel.org>; Thu, 21 Sep 2023 10:28:27 -0700 (PDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id B9733152B;
        Thu, 21 Sep 2023 02:43:09 -0700 (PDT)
Received: from e124191.cambridge.arm.com (e124191.cambridge.arm.com [10.1.197.45])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 2F2133F59C;
        Thu, 21 Sep 2023 02:42:31 -0700 (PDT)
Date:   Thu, 21 Sep 2023 10:42:25 +0100
From:   Joey Gouly <joey.gouly@arm.com>
To:     Marc Zyngier <maz@kernel.org>
Cc:     kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org,
        kvm@vger.kernel.org, James Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Oliver Upton <oliver.upton@linux.dev>,
        Zenghui Yu <yuzenghui@huawei.com>,
        Shameerali Kolothum Thodi 
        <shameerali.kolothum.thodi@huawei.com>,
        Xu Zhao <zhaoxu.35@bytedance.com>,
        Eric Auger <eric.auger@redhat.com>
Subject: Re: [PATCH v2 03/11] KVM: arm64: vgic-v3: Refactor GICv3 SGI
 generation
Message-ID: <20230921094225.GA2926762@e124191.cambridge.arm.com>
References: <20230920181731.2232453-1-maz@kernel.org>
 <20230920181731.2232453-4-maz@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230920181731.2232453-4-maz@kernel.org>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_NONE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Marc, Oliver,

On Wed, Sep 20, 2023 at 07:17:23PM +0100, Marc Zyngier wrote:
> As we're about to change the way SGIs are sent, start by splitting
> out some of the basic functionnality: instead of intermingling
> the broadcast and non-broadcast cases with the actual SGI generation,
> perform the following cleanups:
> 
> - move the SGI queuing into its own helper
> - split the broadcast code from the affinity-driven code
> - replace the mask/shift combinations with FIELD_GET()
> 
> The result is much more readable, and paves the way for further
> optimisations.
> 
> Reviewed-by: Joey Gouly <joey.gouly@arm.com>

Want to point out that I didn't review this code, I only reviewed patches 1-3
from the original series.
https://lore.kernel.org/linux-arm-kernel/20230907100931.1186690-1-maz@kernel.org/

Since it seems Oliver is picking it up, can you remove my r-b tag from this patch.

Thanks,
Joey

> Tested-by: Joey Gouly <joey.gouly@arm.com>
> Tested-by: Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>
> Signed-off-by: Marc Zyngier <maz@kernel.org>
> ---
>  arch/arm64/kvm/vgic/vgic-mmio-v3.c | 110 ++++++++++++++++-------------
>  1 file changed, 59 insertions(+), 51 deletions(-)
> 
> diff --git a/arch/arm64/kvm/vgic/vgic-mmio-v3.c b/arch/arm64/kvm/vgic/vgic-mmio-v3.c
> index 188d2187eede..88b8d4524854 100644
> --- a/arch/arm64/kvm/vgic/vgic-mmio-v3.c
> +++ b/arch/arm64/kvm/vgic/vgic-mmio-v3.c
> @@ -1052,6 +1052,38 @@ static int match_mpidr(u64 sgi_aff, u16 sgi_cpu_mask, struct kvm_vcpu *vcpu)
>  	((((reg) & ICC_SGI1R_AFFINITY_## level ##_MASK) \
>  	>> ICC_SGI1R_AFFINITY_## level ##_SHIFT) << MPIDR_LEVEL_SHIFT(level))
>  
> +static void vgic_v3_queue_sgi(struct kvm_vcpu *vcpu, u32 sgi, bool allow_group1)
> +{
> +	struct vgic_irq *irq = vgic_get_irq(vcpu->kvm, vcpu, sgi);
> +	unsigned long flags;
> +
> +	raw_spin_lock_irqsave(&irq->irq_lock, flags);
> +
> +	/*
> +	 * An access targeting Group0 SGIs can only generate
> +	 * those, while an access targeting Group1 SGIs can
> +	 * generate interrupts of either group.
> +	 */
> +	if (!irq->group || allow_group1) {
> +		if (!irq->hw) {
> +			irq->pending_latch = true;
> +			vgic_queue_irq_unlock(vcpu->kvm, irq, flags);
> +		} else {
> +			/* HW SGI? Ask the GIC to inject it */
> +			int err;
> +			err = irq_set_irqchip_state(irq->host_irq,
> +						    IRQCHIP_STATE_PENDING,
> +						    true);
> +			WARN_RATELIMIT(err, "IRQ %d", irq->host_irq);
> +			raw_spin_unlock_irqrestore(&irq->irq_lock, flags);
> +		}
> +	} else {
> +		raw_spin_unlock_irqrestore(&irq->irq_lock, flags);
> +	}
> +
> +	vgic_put_irq(vcpu->kvm, irq);
> +}
> +
>  /**
>   * vgic_v3_dispatch_sgi - handle SGI requests from VCPUs
>   * @vcpu: The VCPU requesting a SGI
> @@ -1070,19 +1102,30 @@ void vgic_v3_dispatch_sgi(struct kvm_vcpu *vcpu, u64 reg, bool allow_group1)
>  {
>  	struct kvm *kvm = vcpu->kvm;
>  	struct kvm_vcpu *c_vcpu;
> -	u16 target_cpus;
> +	unsigned long target_cpus;
>  	u64 mpidr;
> -	int sgi;
> -	int vcpu_id = vcpu->vcpu_id;
> -	bool broadcast;
> -	unsigned long c, flags;
> -
> -	sgi = (reg & ICC_SGI1R_SGI_ID_MASK) >> ICC_SGI1R_SGI_ID_SHIFT;
> -	broadcast = reg & BIT_ULL(ICC_SGI1R_IRQ_ROUTING_MODE_BIT);
> -	target_cpus = (reg & ICC_SGI1R_TARGET_LIST_MASK) >> ICC_SGI1R_TARGET_LIST_SHIFT;
> +	u32 sgi;
> +	unsigned long c;
> +
> +	sgi = FIELD_GET(ICC_SGI1R_SGI_ID_MASK, reg);
> +
> +	/* Broadcast */
> +	if (unlikely(reg & BIT_ULL(ICC_SGI1R_IRQ_ROUTING_MODE_BIT))) {
> +		kvm_for_each_vcpu(c, c_vcpu, kvm) {
> +			/* Don't signal the calling VCPU */
> +			if (c_vcpu == vcpu)
> +				continue;
> +
> +			vgic_v3_queue_sgi(c_vcpu, sgi, allow_group1);
> +		}
> +
> +		return;
> +	}
> +
>  	mpidr = SGI_AFFINITY_LEVEL(reg, 3);
>  	mpidr |= SGI_AFFINITY_LEVEL(reg, 2);
>  	mpidr |= SGI_AFFINITY_LEVEL(reg, 1);
> +	target_cpus = FIELD_GET(ICC_SGI1R_TARGET_LIST_MASK, reg);
>  
>  	/*
>  	 * We iterate over all VCPUs to find the MPIDRs matching the request.
> @@ -1091,54 +1134,19 @@ void vgic_v3_dispatch_sgi(struct kvm_vcpu *vcpu, u64 reg, bool allow_group1)
>  	 * VCPUs when most of the times we just signal a single VCPU.
>  	 */
>  	kvm_for_each_vcpu(c, c_vcpu, kvm) {
> -		struct vgic_irq *irq;
> +		int level0;
>  
>  		/* Exit early if we have dealt with all requested CPUs */
> -		if (!broadcast && target_cpus == 0)
> +		if (target_cpus == 0)
>  			break;
> -
> -		/* Don't signal the calling VCPU */
> -		if (broadcast && c == vcpu_id)
> +		level0 = match_mpidr(mpidr, target_cpus, c_vcpu);
> +		if (level0 == -1)
>  			continue;
>  
> -		if (!broadcast) {
> -			int level0;
> -
> -			level0 = match_mpidr(mpidr, target_cpus, c_vcpu);
> -			if (level0 == -1)
> -				continue;
> -
> -			/* remove this matching VCPU from the mask */
> -			target_cpus &= ~BIT(level0);
> -		}
> +		/* remove this matching VCPU from the mask */
> +		target_cpus &= ~BIT(level0);
>  
> -		irq = vgic_get_irq(vcpu->kvm, c_vcpu, sgi);
> -
> -		raw_spin_lock_irqsave(&irq->irq_lock, flags);
> -
> -		/*
> -		 * An access targeting Group0 SGIs can only generate
> -		 * those, while an access targeting Group1 SGIs can
> -		 * generate interrupts of either group.
> -		 */
> -		if (!irq->group || allow_group1) {
> -			if (!irq->hw) {
> -				irq->pending_latch = true;
> -				vgic_queue_irq_unlock(vcpu->kvm, irq, flags);
> -			} else {
> -				/* HW SGI? Ask the GIC to inject it */
> -				int err;
> -				err = irq_set_irqchip_state(irq->host_irq,
> -							    IRQCHIP_STATE_PENDING,
> -							    true);
> -				WARN_RATELIMIT(err, "IRQ %d", irq->host_irq);
> -				raw_spin_unlock_irqrestore(&irq->irq_lock, flags);
> -			}
> -		} else {
> -			raw_spin_unlock_irqrestore(&irq->irq_lock, flags);
> -		}
> -
> -		vgic_put_irq(vcpu->kvm, irq);
> +		vgic_v3_queue_sgi(c_vcpu, sgi, allow_group1);
>  	}
>  }
>  
> -- 
> 2.34.1
> 
> 
> _______________________________________________
> linux-arm-kernel mailing list
> linux-arm-kernel@lists.infradead.org
> http://lists.infradead.org/mailman/listinfo/linux-arm-kernel
