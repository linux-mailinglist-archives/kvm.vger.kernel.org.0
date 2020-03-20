Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6633C18C8B9
	for <lists+kvm@lfdr.de>; Fri, 20 Mar 2020 09:11:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727092AbgCTILt (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 20 Mar 2020 04:11:49 -0400
Received: from us-smtp-delivery-74.mimecast.com ([63.128.21.74]:52821 "EHLO
        us-smtp-delivery-74.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726814AbgCTILs (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 20 Mar 2020 04:11:48 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1584691906;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=6VHdEsmEEgE8SwVWsTdpGDee8R02Hql0h9BY1woGGU8=;
        b=df2WVGvxQCBXbVWwJb5C90QC/hmyL1otAWlBnQoQwAr+nwjgI7L/z4TOGiV2YRCdyYwQB3
        WMdp0pjXJNGKc3VU94G6x7Itz11vn7DxHtSsJ01rXswDhkdCbAiJbAxl22PMABqMWnkptV
        Lh5zvaiC+drhep5M7ADtrw8Na8eN4v8=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-258-FIDUR_0cOtqXMMLlfsS8ig-1; Fri, 20 Mar 2020 04:11:45 -0400
X-MC-Unique: FIDUR_0cOtqXMMLlfsS8ig-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id F0D0D13EA;
        Fri, 20 Mar 2020 08:11:42 +0000 (UTC)
Received: from [10.36.113.142] (ovpn-113-142.ams2.redhat.com [10.36.113.142])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id A5F299472;
        Fri, 20 Mar 2020 08:11:39 +0000 (UTC)
Subject: Re: [PATCH v5 18/23] KVM: arm64: GICv4.1: Add direct injection
 capability to SGI registers
To:     Marc Zyngier <maz@kernel.org>,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>,
        Jason Cooper <jason@lakedaemon.net>,
        Robert Richter <rrichter@marvell.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Zenghui Yu <yuzenghui@huawei.com>,
        James Morse <james.morse@arm.com>,
        Julien Thierry <julien.thierry.kdev@gmail.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>
References: <20200304203330.4967-1-maz@kernel.org>
 <20200304203330.4967-19-maz@kernel.org>
From:   Auger Eric <eric.auger@redhat.com>
Message-ID: <06705d70-0f99-e719-af52-1a5f778562d8@redhat.com>
Date:   Fri, 20 Mar 2020 09:11:38 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.4.0
MIME-Version: 1.0
In-Reply-To: <20200304203330.4967-19-maz@kernel.org>
Content-Type: text/plain; charset=windows-1252
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Marc,
On 3/4/20 9:33 PM, Marc Zyngier wrote:
> Most of the GICv3 emulation code that deals with SGIs now has to be
> aware of the v4.1 capabilities in order to benefit from it.
> 
> Add such support, keyed on the interrupt having the hw flag set and
> being a SGI.
> 
> Signed-off-by: Marc Zyngier <maz@kernel.org>
> ---
>  virt/kvm/arm/vgic/vgic-mmio-v3.c | 15 +++++-
>  virt/kvm/arm/vgic/vgic-mmio.c    | 88 ++++++++++++++++++++++++++++++--
>  2 files changed, 96 insertions(+), 7 deletions(-)
> 
> diff --git a/virt/kvm/arm/vgic/vgic-mmio-v3.c b/virt/kvm/arm/vgic/vgic-mmio-v3.c
> index ebc218840fc2..de89da76a379 100644
> --- a/virt/kvm/arm/vgic/vgic-mmio-v3.c
> +++ b/virt/kvm/arm/vgic/vgic-mmio-v3.c
> @@ -6,6 +6,7 @@
>  #include <linux/irqchip/arm-gic-v3.h>
>  #include <linux/kvm.h>
>  #include <linux/kvm_host.h>
> +#include <linux/interrupt.h>
>  #include <kvm/iodev.h>
>  #include <kvm/arm_vgic.h>
>  
> @@ -942,8 +943,18 @@ void vgic_v3_dispatch_sgi(struct kvm_vcpu *vcpu, u64 reg, bool allow_group1)
>  		 * generate interrupts of either group.
>  		 */
>  		if (!irq->group || allow_group1) {
> -			irq->pending_latch = true;
> -			vgic_queue_irq_unlock(vcpu->kvm, irq, flags);
> +			if (!irq->hw) {
> +				irq->pending_latch = true;
> +				vgic_queue_irq_unlock(vcpu->kvm, irq, flags);
> +			} else {
> +				/* HW SGI? Ask the GIC to inject it */
> +				int err;
nit: add line
> +				err = irq_set_irqchip_state(irq->host_irq,
> +							    IRQCHIP_STATE_PENDING,
> +							    true);
> +				WARN_RATELIMIT(err, "IRQ %d", irq->host_irq);
> +				raw_spin_unlock_irqrestore(&irq->irq_lock, flags);
> +			}
>  		} else {
>  			raw_spin_unlock_irqrestore(&irq->irq_lock, flags);
>  		}
> diff --git a/virt/kvm/arm/vgic/vgic-mmio.c b/virt/kvm/arm/vgic/vgic-mmio.c
> index 97fb2a40e6ba..2199302597fa 100644
> --- a/virt/kvm/arm/vgic/vgic-mmio.c
> +++ b/virt/kvm/arm/vgic/vgic-mmio.c
> @@ -5,6 +5,8 @@
>  
>  #include <linux/bitops.h>
>  #include <linux/bsearch.h>
> +#include <linux/interrupt.h>
> +#include <linux/irq.h>
>  #include <linux/kvm.h>
>  #include <linux/kvm_host.h>
>  #include <kvm/iodev.h>
> @@ -59,6 +61,11 @@ unsigned long vgic_mmio_read_group(struct kvm_vcpu *vcpu,
>  	return value;
>  }
>  
> +static void vgic_update_vsgi(struct vgic_irq *irq)
> +{
> +	WARN_ON(its_prop_update_vsgi(irq->host_irq, irq->priority, irq->group));
> +}
> +
>  void vgic_mmio_write_group(struct kvm_vcpu *vcpu, gpa_t addr,
>  			   unsigned int len, unsigned long val)
>  {
> @@ -71,7 +78,12 @@ void vgic_mmio_write_group(struct kvm_vcpu *vcpu, gpa_t addr,
>  
>  		raw_spin_lock_irqsave(&irq->irq_lock, flags);
>  		irq->group = !!(val & BIT(i));
> -		vgic_queue_irq_unlock(vcpu->kvm, irq, flags);
> +		if (irq->hw && vgic_irq_is_sgi(irq->intid)) {
> +			vgic_update_vsgi(irq);
> +			raw_spin_unlock_irqrestore(&irq->irq_lock, flags);
> +		} else {
> +			vgic_queue_irq_unlock(vcpu->kvm, irq, flags);
> +		}
>  
>  		vgic_put_irq(vcpu->kvm, irq);
>  	}
> @@ -113,7 +125,21 @@ void vgic_mmio_write_senable(struct kvm_vcpu *vcpu,
>  		struct vgic_irq *irq = vgic_get_irq(vcpu->kvm, vcpu, intid + i);
>  
>  		raw_spin_lock_irqsave(&irq->irq_lock, flags);
> -		if (vgic_irq_is_mapped_level(irq)) {
> +		if (irq->hw && vgic_irq_is_sgi(irq->intid)) {
> +			if (!irq->enabled) {
> +				struct irq_data *data;
> +
> +				irq->enabled = true;
> +				data = &irq_to_desc(irq->host_irq)->irq_data;
> +				while (irqd_irq_disabled(data))
> +					enable_irq(irq->host_irq);
could you explain me why the while() is requested?
> +			}
> +
> +			raw_spin_unlock_irqrestore(&irq->irq_lock, flags);
> +			vgic_put_irq(vcpu->kvm, irq);
> +
> +			continue;
> +		} else if (vgic_irq_is_mapped_level(irq)) {
>  			bool was_high = irq->line_level;
>  
>  			/*
> @@ -148,6 +174,8 @@ void vgic_mmio_write_cenable(struct kvm_vcpu *vcpu,
>  		struct vgic_irq *irq = vgic_get_irq(vcpu->kvm, vcpu, intid + i);
>  
>  		raw_spin_lock_irqsave(&irq->irq_lock, flags);
> +		if (irq->hw && vgic_irq_is_sgi(irq->intid) && irq->enabled)
> +			disable_irq_nosync(irq->host_irq);
>  
>  		irq->enabled = false;
>  
> @@ -167,10 +195,22 @@ unsigned long vgic_mmio_read_pending(struct kvm_vcpu *vcpu,
>  	for (i = 0; i < len * 8; i++) {
>  		struct vgic_irq *irq = vgic_get_irq(vcpu->kvm, vcpu, intid + i);
>  		unsigned long flags;
> +		bool val;
>  
>  		raw_spin_lock_irqsave(&irq->irq_lock, flags);
> -		if (irq_is_pending(irq))
> -			value |= (1U << i);
> +		if (irq->hw && vgic_irq_is_sgi(irq->intid)) {
> +			int err;
> +
> +			val = false;
> +			err = irq_get_irqchip_state(irq->host_irq,
> +						    IRQCHIP_STATE_PENDING,
> +						    &val);
> +			WARN_RATELIMIT(err, "IRQ %d", irq->host_irq);
> +		} else {
> +			val = irq_is_pending(irq);
> +		}
> +
> +		value |= ((u32)val << i);
>  		raw_spin_unlock_irqrestore(&irq->irq_lock, flags);
>  
>  		vgic_put_irq(vcpu->kvm, irq);
> @@ -215,6 +255,21 @@ void vgic_mmio_write_spending(struct kvm_vcpu *vcpu,
>  		}
>  
>  		raw_spin_lock_irqsave(&irq->irq_lock, flags);
> +
> +		if (irq->hw && vgic_irq_is_sgi(irq->intid)) {
> +			/* HW SGI? Ask the GIC to inject it */
> +			int err;
nit: extra line
> +			err = irq_set_irqchip_state(irq->host_irq,
> +						    IRQCHIP_STATE_PENDING,
> +						    true);
> +			WARN_RATELIMIT(err, "IRQ %d", irq->host_irq);
> +
> +			raw_spin_unlock_irqrestore(&irq->irq_lock, flags);
> +			vgic_put_irq(vcpu->kvm, irq);
> +
> +			continue;
> +		}
> +
>  		if (irq->hw)
>  			vgic_hw_irq_spending(vcpu, irq, is_uaccess);
>  		else
> @@ -269,6 +324,20 @@ void vgic_mmio_write_cpending(struct kvm_vcpu *vcpu,
>  
>  		raw_spin_lock_irqsave(&irq->irq_lock, flags);
>  
> +		if (irq->hw && vgic_irq_is_sgi(irq->intid)) {
> +			/* HW SGI? Ask the GIC to clear its pending bit */
> +			int err;
> +			err = irq_set_irqchip_state(irq->host_irq,
> +						    IRQCHIP_STATE_PENDING,
> +						    false);
> +			WARN_RATELIMIT(err, "IRQ %d", irq->host_irq);
> +
> +			raw_spin_unlock_irqrestore(&irq->irq_lock, flags);
> +			vgic_put_irq(vcpu->kvm, irq);
> +
> +			continue;
> +		}
> +
>  		if (irq->hw)
>  			vgic_hw_irq_cpending(vcpu, irq, is_uaccess);
>  		else
> @@ -318,8 +387,15 @@ static void vgic_mmio_change_active(struct kvm_vcpu *vcpu, struct vgic_irq *irq,
>  
>  	raw_spin_lock_irqsave(&irq->irq_lock, flags);
>  
> -	if (irq->hw) {
> +	if (irq->hw && !vgic_irq_is_sgi(irq->intid)) {
>  		vgic_hw_irq_change_active(vcpu, irq, active, !requester_vcpu);
> +	} else if (irq->hw && vgic_irq_is_sgi(irq->intid)) {
> +		/*
> +		 * GICv4.1 VSGI feature doesn't track an active state,
> +		 * so let's not kid ourselves, there is nothing we can
> +		 * do here.
> +		 */
> +		irq->active = false;
>  	} else {
>  		u32 model = vcpu->kvm->arch.vgic.vgic_model;
>  		u8 active_source;
> @@ -493,6 +569,8 @@ void vgic_mmio_write_priority(struct kvm_vcpu *vcpu,
>  		raw_spin_lock_irqsave(&irq->irq_lock, flags);
>  		/* Narrow the priority range to what we actually support */
>  		irq->priority = (val >> (i * 8)) & GENMASK(7, 8 - VGIC_PRI_BITS);
> +		if (irq->hw && vgic_irq_is_sgi(irq->intid))
> +			vgic_update_vsgi(irq);
>  		raw_spin_unlock_irqrestore(&irq->irq_lock, flags);
>  
>  		vgic_put_irq(vcpu->kvm, irq);
> 
Reviewed-by: Eric Auger <eric.auger@redhat.com>

Thanks

Eric

