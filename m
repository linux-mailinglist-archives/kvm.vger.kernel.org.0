Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E65CC1ADC16
	for <lists+kvm@lfdr.de>; Fri, 17 Apr 2020 13:24:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730185AbgDQLWN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 17 Apr 2020 07:22:13 -0400
Received: from foss.arm.com ([217.140.110.172]:50072 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729962AbgDQLWN (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 17 Apr 2020 07:22:13 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 2A059C14;
        Fri, 17 Apr 2020 04:22:13 -0700 (PDT)
Received: from [192.168.0.14] (unknown [172.31.20.19])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id CA5BB3F6C4;
        Fri, 17 Apr 2020 04:22:11 -0700 (PDT)
Subject: Re: [PATCH v2 4/6] KVM: arm: vgic-v2: Only use the virtual state when
 userspace accesses pending bits
To:     Marc Zyngier <maz@kernel.org>
Cc:     linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        kvm@vger.kernel.org, Zenghui Yu <yuzenghui@huawei.com>,
        Eric Auger <eric.auger@redhat.com>,
        Andre Przywara <Andre.Przywara@arm.com>,
        Julien Grall <julien@xen.org>,
        Julien Thierry <julien.thierry.kdev@gmail.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>
References: <20200417083319.3066217-1-maz@kernel.org>
 <20200417083319.3066217-5-maz@kernel.org>
From:   James Morse <james.morse@arm.com>
Message-ID: <4133d5f2-ed0e-9c4a-8a66-953fb6bf6e70@arm.com>
Date:   Fri, 17 Apr 2020 12:22:10 +0100
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <20200417083319.3066217-5-maz@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-GB
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Marc,

On 17/04/2020 09:33, Marc Zyngier wrote:
> There is no point in accessing the HW when writing to any of the
> ISPENDR/ICPENDR registers from userspace, as only the guest should
> be allowed to change the HW state.
> 
> Introduce new userspace-specific accessors that deal solely with
> the virtual state. Note that the API differs from that of GICv3,
> where userspace exclusively uses ISPENDR to set the state. Too
> bad we can't reuse it.

> diff --git a/virt/kvm/arm/vgic/vgic-mmio-v2.c b/virt/kvm/arm/vgic/vgic-mmio-v2.c
> index f51c6e939c76..a016f07adc28 100644
> --- a/virt/kvm/arm/vgic/vgic-mmio-v2.c
> +++ b/virt/kvm/arm/vgic/vgic-mmio-v2.c
> @@ -417,10 +417,12 @@ static const struct vgic_register_region vgic_v2_dist_registers[] = {
>  		NULL, vgic_uaccess_write_cenable, 1,
>  		VGIC_ACCESS_32bit),
>  	REGISTER_DESC_WITH_BITS_PER_IRQ(GIC_DIST_PENDING_SET,
> -		vgic_mmio_read_pending, vgic_mmio_write_spending, NULL, NULL, 1,
> +		vgic_mmio_read_pending, vgic_mmio_write_spending,
> +		NULL, vgic_uaccess_write_spending, 1,
>  		VGIC_ACCESS_32bit),

vgic_mmio_write_spending() has some homebrew detection for is_uaccess, which causes
vgic_hw_irq_spending() to do nothing. Isn't that now dead-code with this change?


> diff --git a/virt/kvm/arm/vgic/vgic-mmio.c b/virt/kvm/arm/vgic/vgic-mmio.c
> index 6e30034d1464..f1927ae02d2e 100644
> --- a/virt/kvm/arm/vgic/vgic-mmio.c
> +++ b/virt/kvm/arm/vgic/vgic-mmio.c
> @@ -321,6 +321,27 @@ void vgic_mmio_write_spending(struct kvm_vcpu *vcpu,

> +int vgic_uaccess_write_spending(struct kvm_vcpu *vcpu,
> +				gpa_t addr, unsigned int len,
> +				unsigned long val)
> +{
> +	u32 intid = VGIC_ADDR_TO_INTID(addr, 1);
> +	int i;
> +	unsigned long flags;
> +
> +	for_each_set_bit(i, &val, len * 8) {
> +		struct vgic_irq *irq = vgic_get_irq(vcpu->kvm, vcpu, intid + i);

vgic_mmio_write_spending() has:
|	/* GICD_ISPENDR0 SGI bits are WI *

and bales out early. Is GIC_DIST_PENDING_SET the same register?
(If so, shouldn't that be true for PPI too?)


> +		raw_spin_lock_irqsave(&irq->irq_lock, flags);
> +		irq->pending_latch = true;
> +		vgic_queue_irq_unlock(vcpu->kvm, irq, flags);
> +
> +		vgic_put_irq(vcpu->kvm, irq);
> +	}
> +
> +	return 0;
> +}

> @@ -390,6 +411,26 @@ void vgic_mmio_write_cpending(struct kvm_vcpu *vcpu,

> +int vgic_uaccess_write_cpending(struct kvm_vcpu *vcpu,
> +				gpa_t addr, unsigned int len,
> +				unsigned long val)
> +{
> +	u32 intid = VGIC_ADDR_TO_INTID(addr, 1);
> +	int i;
> +	unsigned long flags;
> +
> +	for_each_set_bit(i, &val, len * 8) {
> +		struct vgic_irq *irq = vgic_get_irq(vcpu->kvm, vcpu, intid + i);

Same dumb question about GICD_ICPENDR0!?

> +		raw_spin_lock_irqsave(&irq->irq_lock, flags);
> +		irq->pending_latch = false;
> +		raw_spin_unlock_irqrestore(&irq->irq_lock, flags);
> +
> +		vgic_put_irq(vcpu->kvm, irq);
> +	}
> +
> +	return 0;
> +}


Thanks,

James
