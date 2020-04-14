Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 677031A7940
	for <lists+kvm@lfdr.de>; Tue, 14 Apr 2020 13:17:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2438987AbgDNLRP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 14 Apr 2020 07:17:15 -0400
Received: from foss.arm.com ([217.140.110.172]:53278 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2438982AbgDNLRE (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 14 Apr 2020 07:17:04 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 9B9021FB;
        Tue, 14 Apr 2020 04:17:03 -0700 (PDT)
Received: from [192.168.2.22] (unknown [172.31.20.19])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 4CEC23F6C4;
        Tue, 14 Apr 2020 04:17:02 -0700 (PDT)
Subject: Re: [PATCH 1/3] KVM: arm: vgic: Synchronize the whole guest on
 GIC{D,R}_I{S,C}ACTIVER read
To:     Marc Zyngier <maz@kernel.org>,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        kvm@vger.kernel.org
Cc:     Zenghui Yu <yuzenghui@huawei.com>,
        Eric Auger <eric.auger@redhat.com>,
        Julien Grall <julien@xen.org>,
        James Morse <james.morse@arm.com>,
        Julien Thierry <julien.thierry.kdev@gmail.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>
References: <20200414103517.2824071-1-maz@kernel.org>
 <20200414103517.2824071-2-maz@kernel.org>
From:   =?UTF-8?Q?Andr=c3=a9_Przywara?= <andre.przywara@arm.com>
Autocrypt: addr=andre.przywara@arm.com; prefer-encrypt=mutual; keydata=
 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
 i4aIXCH3Wv6K
Organization: ARM Ltd.
Message-ID: <fddef0b7-3db7-89aa-5aac-4f08380ed00d@arm.com>
Date:   Tue, 14 Apr 2020 12:16:27 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.6.0
MIME-Version: 1.0
In-Reply-To: <20200414103517.2824071-2-maz@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 14/04/2020 11:35, Marc Zyngier wrote:
> When a guest tries to read the active state of its interrupts,
> we currently just return whatever state we have in memory. This
> means that if such an interrupt lives in a List Register on another
> CPU, we fail to obsertve the latest active state for this interrupt.

                  ^^^^^^^^

> In order to remedy this, stop all the other vcpus so that they exit
> and we can observe the most recent value for the state.

Maybe worth mentioning that this copies the approach we already deal
with write accesses (split userland and guess accessors). This is in the
cover letter, but until I found it there it took me a while to grasp
what this patch really does.

> 
> Reported-by: Julien Grall <julien@xen.org>
> Signed-off-by: Marc Zyngier <maz@kernel.org>
> ---
>  virt/kvm/arm/vgic/vgic-mmio-v2.c |   4 +-
>  virt/kvm/arm/vgic/vgic-mmio-v3.c |   4 +-
>  virt/kvm/arm/vgic/vgic-mmio.c    | 100 ++++++++++++++++++++-----------
>  virt/kvm/arm/vgic/vgic-mmio.h    |   3 +
>  4 files changed, 71 insertions(+), 40 deletions(-)
> 
> diff --git a/virt/kvm/arm/vgic/vgic-mmio-v2.c b/virt/kvm/arm/vgic/vgic-mmio-v2.c
> index 5945f062d749..d63881f60e1a 100644
> --- a/virt/kvm/arm/vgic/vgic-mmio-v2.c
> +++ b/virt/kvm/arm/vgic/vgic-mmio-v2.c
> @@ -422,11 +422,11 @@ static const struct vgic_register_region vgic_v2_dist_registers[] = {
>  		VGIC_ACCESS_32bit),
>  	REGISTER_DESC_WITH_BITS_PER_IRQ(GIC_DIST_ACTIVE_SET,
>  		vgic_mmio_read_active, vgic_mmio_write_sactive,
> -		NULL, vgic_mmio_uaccess_write_sactive, 1,
> +		vgic_uaccess_read_active, vgic_mmio_uaccess_write_sactive, 1,
>  		VGIC_ACCESS_32bit),
>  	REGISTER_DESC_WITH_BITS_PER_IRQ(GIC_DIST_ACTIVE_CLEAR,
>  		vgic_mmio_read_active, vgic_mmio_write_cactive,
> -		NULL, vgic_mmio_uaccess_write_cactive, 1,
> +		vgic_uaccess_read_active, vgic_mmio_uaccess_write_cactive, 1,
>  		VGIC_ACCESS_32bit),
>  	REGISTER_DESC_WITH_BITS_PER_IRQ(GIC_DIST_PRI,
>  		vgic_mmio_read_priority, vgic_mmio_write_priority, NULL, NULL,
> diff --git a/virt/kvm/arm/vgic/vgic-mmio-v3.c b/virt/kvm/arm/vgic/vgic-mmio-v3.c
> index e72dcc454247..77c8ba1a2535 100644
> --- a/virt/kvm/arm/vgic/vgic-mmio-v3.c
> +++ b/virt/kvm/arm/vgic/vgic-mmio-v3.c
> @@ -553,11 +553,11 @@ static const struct vgic_register_region vgic_v3_dist_registers[] = {
>  		VGIC_ACCESS_32bit),
>  	REGISTER_DESC_WITH_BITS_PER_IRQ_SHARED(GICD_ISACTIVER,
>  		vgic_mmio_read_active, vgic_mmio_write_sactive,
> -		NULL, vgic_mmio_uaccess_write_sactive, 1,
> +		vgic_uaccess_read_active, vgic_mmio_uaccess_write_sactive, 1,
>  		VGIC_ACCESS_32bit),
>  	REGISTER_DESC_WITH_BITS_PER_IRQ_SHARED(GICD_ICACTIVER,
>  		vgic_mmio_read_active, vgic_mmio_write_cactive,
> -		NULL, vgic_mmio_uaccess_write_cactive,
> +		vgic_uaccess_read_active, vgic_mmio_uaccess_write_cactive,
>  		1, VGIC_ACCESS_32bit),
>  	REGISTER_DESC_WITH_BITS_PER_IRQ_SHARED(GICD_IPRIORITYR,
>  		vgic_mmio_read_priority, vgic_mmio_write_priority, NULL, NULL,
> diff --git a/virt/kvm/arm/vgic/vgic-mmio.c b/virt/kvm/arm/vgic/vgic-mmio.c
> index 2199302597fa..4012cd68ac93 100644
> --- a/virt/kvm/arm/vgic/vgic-mmio.c
> +++ b/virt/kvm/arm/vgic/vgic-mmio.c
> @@ -348,8 +348,39 @@ void vgic_mmio_write_cpending(struct kvm_vcpu *vcpu,
>  	}
>  }
>  
> -unsigned long vgic_mmio_read_active(struct kvm_vcpu *vcpu,
> -				    gpa_t addr, unsigned int len)
> +
> +/*
> + * If we are fiddling with an IRQ's active state, we have to make sure the IRQ
> + * is not queued on some running VCPU's LRs, because then the change to the
> + * active state can be overwritten when the VCPU's state is synced coming back
> + * from the guest.
> + *
> + * For shared interrupts as well as GICv3 private interrupts, we have to
> + * stop all the VCPUs because interrupts can be migrated while we don't hold
> + * the IRQ locks and we don't want to be chasing moving targets.
> + *
> + * For GICv2 private interrupts we don't have to do anything because
> + * userspace accesses to the VGIC state already require all VCPUs to be
> + * stopped, and only the VCPU itself can modify its private interrupts
> + * active state, which guarantees that the VCPU is not running.
> + */
> +static void vgic_access_active_prepare(struct kvm_vcpu *vcpu, u32 intid)
> +{
> +	if (vcpu->kvm->arch.vgic.vgic_model == KVM_DEV_TYPE_ARM_VGIC_V3 ||
> +	    intid > VGIC_NR_PRIVATE_IRQS)

I understand that this is just moved from existing code below, but
shouldn't that either read "intid >= VGIC_NR_PRIVATE_IRQS" or
"intid > VGIC_MAX_PRIVATE"?

Rest looks alright.

Cheers,
Andre


> +		kvm_arm_halt_guest(vcpu->kvm);
> +}
> +
> +/* See vgic_access_active_prepare */
> +static void vgic_access_active_finish(struct kvm_vcpu *vcpu, u32 intid)
> +{
> +	if (vcpu->kvm->arch.vgic.vgic_model == KVM_DEV_TYPE_ARM_VGIC_V3 ||
> +	    intid > VGIC_NR_PRIVATE_IRQS)
> +		kvm_arm_resume_guest(vcpu->kvm);
> +}
> +
> +static unsigned long __vgic_mmio_read_active(struct kvm_vcpu *vcpu,
> +					     gpa_t addr, unsigned int len)
>  {
>  	u32 intid = VGIC_ADDR_TO_INTID(addr, 1);
>  	u32 value = 0;
> @@ -359,6 +390,10 @@ unsigned long vgic_mmio_read_active(struct kvm_vcpu *vcpu,
>  	for (i = 0; i < len * 8; i++) {
>  		struct vgic_irq *irq = vgic_get_irq(vcpu->kvm, vcpu, intid + i);
>  
> +		/*
> +		 * Even for HW interrupts, don't evaluate the HW state as
> +		 * all the guest is interested in is the virtual state.
> +		 */
>  		if (irq->active)
>  			value |= (1U << i);
>  
> @@ -368,6 +403,29 @@ unsigned long vgic_mmio_read_active(struct kvm_vcpu *vcpu,
>  	return value;
>  }
>  
> +unsigned long vgic_mmio_read_active(struct kvm_vcpu *vcpu,
> +				    gpa_t addr, unsigned int len)
> +{
> +	u32 intid = VGIC_ADDR_TO_INTID(addr, 1);
> +	u32 val;
> +
> +	mutex_lock(&vcpu->kvm->lock);
> +	vgic_access_active_prepare(vcpu, intid);
> +
> +	val = __vgic_mmio_read_active(vcpu, addr, len);
> +
> +	vgic_access_active_finish(vcpu, intid);
> +	mutex_unlock(&vcpu->kvm->lock);
> +
> +	return val;
> +}
> +
> +unsigned long vgic_uaccess_read_active(struct kvm_vcpu *vcpu,
> +				    gpa_t addr, unsigned int len)
> +{
> +	return __vgic_mmio_read_active(vcpu, addr, len);
> +}
> +
>  /* Must be called with irq->irq_lock held */
>  static void vgic_hw_irq_change_active(struct kvm_vcpu *vcpu, struct vgic_irq *irq,
>  				      bool active, bool is_uaccess)
> @@ -426,36 +484,6 @@ static void vgic_mmio_change_active(struct kvm_vcpu *vcpu, struct vgic_irq *irq,
>  		raw_spin_unlock_irqrestore(&irq->irq_lock, flags);
>  }
>  
> -/*
> - * If we are fiddling with an IRQ's active state, we have to make sure the IRQ
> - * is not queued on some running VCPU's LRs, because then the change to the
> - * active state can be overwritten when the VCPU's state is synced coming back
> - * from the guest.
> - *
> - * For shared interrupts, we have to stop all the VCPUs because interrupts can
> - * be migrated while we don't hold the IRQ locks and we don't want to be
> - * chasing moving targets.
> - *
> - * For private interrupts we don't have to do anything because userspace
> - * accesses to the VGIC state already require all VCPUs to be stopped, and
> - * only the VCPU itself can modify its private interrupts active state, which
> - * guarantees that the VCPU is not running.
> - */
> -static void vgic_change_active_prepare(struct kvm_vcpu *vcpu, u32 intid)
> -{
> -	if (vcpu->kvm->arch.vgic.vgic_model == KVM_DEV_TYPE_ARM_VGIC_V3 ||
> -	    intid > VGIC_NR_PRIVATE_IRQS)
> -		kvm_arm_halt_guest(vcpu->kvm);
> -}
> -
> -/* See vgic_change_active_prepare */
> -static void vgic_change_active_finish(struct kvm_vcpu *vcpu, u32 intid)
> -{
> -	if (vcpu->kvm->arch.vgic.vgic_model == KVM_DEV_TYPE_ARM_VGIC_V3 ||
> -	    intid > VGIC_NR_PRIVATE_IRQS)
> -		kvm_arm_resume_guest(vcpu->kvm);
> -}
> -
>  static void __vgic_mmio_write_cactive(struct kvm_vcpu *vcpu,
>  				      gpa_t addr, unsigned int len,
>  				      unsigned long val)
> @@ -477,11 +505,11 @@ void vgic_mmio_write_cactive(struct kvm_vcpu *vcpu,
>  	u32 intid = VGIC_ADDR_TO_INTID(addr, 1);
>  
>  	mutex_lock(&vcpu->kvm->lock);
> -	vgic_change_active_prepare(vcpu, intid);
> +	vgic_access_active_prepare(vcpu, intid);
>  
>  	__vgic_mmio_write_cactive(vcpu, addr, len, val);
>  
> -	vgic_change_active_finish(vcpu, intid);
> +	vgic_access_active_finish(vcpu, intid);
>  	mutex_unlock(&vcpu->kvm->lock);
>  }
>  
> @@ -514,11 +542,11 @@ void vgic_mmio_write_sactive(struct kvm_vcpu *vcpu,
>  	u32 intid = VGIC_ADDR_TO_INTID(addr, 1);
>  
>  	mutex_lock(&vcpu->kvm->lock);
> -	vgic_change_active_prepare(vcpu, intid);
> +	vgic_access_active_prepare(vcpu, intid);
>  
>  	__vgic_mmio_write_sactive(vcpu, addr, len, val);
>  
> -	vgic_change_active_finish(vcpu, intid);
> +	vgic_access_active_finish(vcpu, intid);
>  	mutex_unlock(&vcpu->kvm->lock);
>  }
>  
> diff --git a/virt/kvm/arm/vgic/vgic-mmio.h b/virt/kvm/arm/vgic/vgic-mmio.h
> index 5af2aefad435..30713a44e3fa 100644
> --- a/virt/kvm/arm/vgic/vgic-mmio.h
> +++ b/virt/kvm/arm/vgic/vgic-mmio.h
> @@ -152,6 +152,9 @@ void vgic_mmio_write_cpending(struct kvm_vcpu *vcpu,
>  unsigned long vgic_mmio_read_active(struct kvm_vcpu *vcpu,
>  				    gpa_t addr, unsigned int len);
>  
> +unsigned long vgic_uaccess_read_active(struct kvm_vcpu *vcpu,
> +				    gpa_t addr, unsigned int len);
> +
>  void vgic_mmio_write_cactive(struct kvm_vcpu *vcpu,
>  			     gpa_t addr, unsigned int len,
>  			     unsigned long val);
> 

