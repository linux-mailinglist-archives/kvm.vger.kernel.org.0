Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 31DC8162395
	for <lists+kvm@lfdr.de>; Tue, 18 Feb 2020 10:41:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726384AbgBRJlZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 18 Feb 2020 04:41:25 -0500
Received: from mail.kernel.org ([198.145.29.99]:44726 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726347AbgBRJlY (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 18 Feb 2020 04:41:24 -0500
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org [51.254.78.96])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8DD0B206E2;
        Tue, 18 Feb 2020 09:41:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1582018883;
        bh=pw2K2224fxAUUaU2pI7bCCAGARvYwAr/+j4AL8lzv6w=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=GmI7V+jCtJhHkYvf4HXGGzSEsYsfOzgmCu765k6xM+smhJ7mh6vMw8EYwP4Hsufgn
         655ZVvHXc6u771KnpaXry8XvfnzEtLmSzU58yi1yCeoAYwpwYC9/PSiGwOH3fhf/bx
         6NW2F6jvTfBa9qzn2iHs0zd9iTrSYQijRxt5MUPw=
Received: from disco-boy.misterjones.org ([51.254.78.96] helo=www.loen.fr)
        by disco-boy.misterjones.org with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.92)
        (envelope-from <maz@kernel.org>)
        id 1j3zNZ-006BTx-Rj; Tue, 18 Feb 2020 09:41:21 +0000
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Tue, 18 Feb 2020 09:41:21 +0000
From:   Marc Zyngier <maz@kernel.org>
To:     Zenghui Yu <yuzenghui@huawei.com>
Cc:     linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>,
        Jason Cooper <jason@lakedaemon.net>,
        Robert Richter <rrichter@marvell.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Eric Auger <eric.auger@redhat.com>,
        James Morse <james.morse@arm.com>,
        Julien Thierry <julien.thierry.kdev@gmail.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>
Subject: Re: [PATCH v4 15/20] KVM: arm64: GICv4.1: Add direct injection
 capability to SGI registers
In-Reply-To: <5e744173-5d7a-98b7-e44d-d1f8c47b3e3c@huawei.com>
References: <20200214145736.18550-1-maz@kernel.org>
 <20200214145736.18550-16-maz@kernel.org>
 <5e744173-5d7a-98b7-e44d-d1f8c47b3e3c@huawei.com>
Message-ID: <fb5cd47ffec8db887d442e1e23ffc0db@kernel.org>
X-Sender: maz@kernel.org
User-Agent: Roundcube Webmail/1.3.10
X-SA-Exim-Connect-IP: 51.254.78.96
X-SA-Exim-Rcpt-To: yuzenghui@huawei.com, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, linux-kernel@vger.kernel.org, lorenzo.pieralisi@arm.com, jason@lakedaemon.net, rrichter@marvell.com, tglx@linutronix.de, eric.auger@redhat.com, james.morse@arm.com, julien.thierry.kdev@gmail.com, suzuki.poulose@arm.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 2020-02-18 08:46, Zenghui Yu wrote:
> Hi Marc,
> 
> On 2020/2/14 22:57, Marc Zyngier wrote:
>> Most of the GICv3 emulation code that deals with SGIs now has to be
>> aware of the v4.1 capabilities in order to benefit from it.
>> 
>> Add such support, keyed on the interrupt having the hw flag set and
>> being a SGI.
>> 
>> Signed-off-by: Marc Zyngier <maz@kernel.org>
>> ---
>>   virt/kvm/arm/vgic/vgic-mmio-v3.c | 15 +++++-
>>   virt/kvm/arm/vgic/vgic-mmio.c    | 88 
>> ++++++++++++++++++++++++++++++--
>>   2 files changed, 96 insertions(+), 7 deletions(-)
>> 
>> diff --git a/virt/kvm/arm/vgic/vgic-mmio-v3.c 
>> b/virt/kvm/arm/vgic/vgic-mmio-v3.c
>> index ebc218840fc2..de89da76a379 100644
>> --- a/virt/kvm/arm/vgic/vgic-mmio-v3.c
>> +++ b/virt/kvm/arm/vgic/vgic-mmio-v3.c
>> @@ -6,6 +6,7 @@
>>   #include <linux/irqchip/arm-gic-v3.h>
>>   #include <linux/kvm.h>
>>   #include <linux/kvm_host.h>
>> +#include <linux/interrupt.h>
>>   #include <kvm/iodev.h>
>>   #include <kvm/arm_vgic.h>
>>   @@ -942,8 +943,18 @@ void vgic_v3_dispatch_sgi(struct kvm_vcpu 
>> *vcpu, u64 reg, bool allow_group1)
>>   		 * generate interrupts of either group.
>>   		 */
>>   		if (!irq->group || allow_group1) {
>> -			irq->pending_latch = true;
>> -			vgic_queue_irq_unlock(vcpu->kvm, irq, flags);
>> +			if (!irq->hw) {
>> +				irq->pending_latch = true;
>> +				vgic_queue_irq_unlock(vcpu->kvm, irq, flags);
>> +			} else {
>> +				/* HW SGI? Ask the GIC to inject it */
>> +				int err;
>> +				err = irq_set_irqchip_state(irq->host_irq,
>> +							    IRQCHIP_STATE_PENDING,
>> +							    true);
>> +				WARN_RATELIMIT(err, "IRQ %d", irq->host_irq);
>> +				raw_spin_unlock_irqrestore(&irq->irq_lock, flags);
>> +			}
>>   		} else {
>>   			raw_spin_unlock_irqrestore(&irq->irq_lock, flags);
>>   		}
>> diff --git a/virt/kvm/arm/vgic/vgic-mmio.c 
>> b/virt/kvm/arm/vgic/vgic-mmio.c
>> index d656ebd5f9d4..0a1fb61e5b89 100644
>> --- a/virt/kvm/arm/vgic/vgic-mmio.c
>> +++ b/virt/kvm/arm/vgic/vgic-mmio.c
>> @@ -5,6 +5,8 @@
>>     #include <linux/bitops.h>
>>   #include <linux/bsearch.h>
>> +#include <linux/interrupt.h>
>> +#include <linux/irq.h>
>>   #include <linux/kvm.h>
>>   #include <linux/kvm_host.h>
>>   #include <kvm/iodev.h>
>> @@ -59,6 +61,11 @@ unsigned long vgic_mmio_read_group(struct kvm_vcpu 
>> *vcpu,
>>   	return value;
>>   }
>>   +static void vgic_update_vsgi(struct vgic_irq *irq)
>> +{
>> +	WARN_ON(its_prop_update_vsgi(irq->host_irq, irq->priority, 
>> irq->group));
>> +}
>> +
>>   void vgic_mmio_write_group(struct kvm_vcpu *vcpu, gpa_t addr,
>>   			   unsigned int len, unsigned long val)
>>   {
>> @@ -71,7 +78,12 @@ void vgic_mmio_write_group(struct kvm_vcpu *vcpu, 
>> gpa_t addr,
>>     		raw_spin_lock_irqsave(&irq->irq_lock, flags);
>>   		irq->group = !!(val & BIT(i));
>> -		vgic_queue_irq_unlock(vcpu->kvm, irq, flags);
>> +		if (irq->hw && vgic_irq_is_sgi(irq->intid)) {
>> +			vgic_update_vsgi(irq);
>> +			raw_spin_unlock_irqrestore(&irq->irq_lock, flags);
>> +		} else {
>> +			vgic_queue_irq_unlock(vcpu->kvm, irq, flags);
>> +		}
>>     		vgic_put_irq(vcpu->kvm, irq);
>>   	}
>> @@ -113,7 +125,21 @@ void vgic_mmio_write_senable(struct kvm_vcpu 
>> *vcpu,
>>   		struct vgic_irq *irq = vgic_get_irq(vcpu->kvm, vcpu, intid + i);
>>     		raw_spin_lock_irqsave(&irq->irq_lock, flags);
>> -		if (vgic_irq_is_mapped_level(irq)) {
>> +		if (irq->hw && vgic_irq_is_sgi(irq->intid)) {
>> +			if (!irq->enabled) {
>> +				struct irq_data *data;
>> +
>> +				irq->enabled = true;
>> +				data = &irq_to_desc(irq->host_irq)->irq_data;
>> +				while (irqd_irq_disabled(data))
>> +					enable_irq(irq->host_irq);
>> +			}
>> +
>> +			raw_spin_unlock_irqrestore(&irq->irq_lock, flags);
>> +			vgic_put_irq(vcpu->kvm, irq);
>> +
>> +			continue;
>> +		} else if (vgic_irq_is_mapped_level(irq)) {
>>   			bool was_high = irq->line_level;
>>     			/*
>> @@ -148,6 +174,8 @@ void vgic_mmio_write_cenable(struct kvm_vcpu 
>> *vcpu,
>>   		struct vgic_irq *irq = vgic_get_irq(vcpu->kvm, vcpu, intid + i);
>>     		raw_spin_lock_irqsave(&irq->irq_lock, flags);
>> +		if (irq->hw && vgic_irq_is_sgi(irq->intid) && irq->enabled)
>> +			disable_irq_nosync(irq->host_irq);
>>     		irq->enabled = false;
>>   @@ -167,10 +195,22 @@ unsigned long vgic_mmio_read_pending(struct 
>> kvm_vcpu *vcpu,
>>   	for (i = 0; i < len * 8; i++) {
>>   		struct vgic_irq *irq = vgic_get_irq(vcpu->kvm, vcpu, intid + i);
>>   		unsigned long flags;
>> +		bool val;
>>     		raw_spin_lock_irqsave(&irq->irq_lock, flags);
>> -		if (irq_is_pending(irq))
>> -			value |= (1U << i);
>> +		if (irq->hw && vgic_irq_is_sgi(irq->intid)) {
>> +			int err;
>> +
>> +			val = false;
>> +			err = irq_get_irqchip_state(irq->host_irq,
>> +						    IRQCHIP_STATE_PENDING,
>> +						    &val);
>> +			WARN_RATELIMIT(err, "IRQ %d", irq->host_irq);
>> +		} else {
>> +			val = irq_is_pending(irq);
>> +		}
>> +
>> +		value |= ((u32)val << i);
>>   		raw_spin_unlock_irqrestore(&irq->irq_lock, flags);
>>     		vgic_put_irq(vcpu->kvm, irq);
>> @@ -227,6 +267,21 @@ void vgic_mmio_write_spending(struct kvm_vcpu 
>> *vcpu,
>>   		}
>>     		raw_spin_lock_irqsave(&irq->irq_lock, flags);
>> +
>> +		if (irq->hw && vgic_irq_is_sgi(irq->intid)) {
>> +			/* HW SGI? Ask the GIC to inject it */
>> +			int err;
>> +			err = irq_set_irqchip_state(irq->host_irq,
>> +						    IRQCHIP_STATE_PENDING,
>> +						    true);
>> +			WARN_RATELIMIT(err, "IRQ %d", irq->host_irq);
>> +
>> +			raw_spin_unlock_irqrestore(&irq->irq_lock, flags);
>> +			vgic_put_irq(vcpu->kvm, irq);
>> +
>> +			continue;
>> +		}
>> +
>>   		if (irq->hw)
>>   			vgic_hw_irq_spending(vcpu, irq, is_uaccess);
>>   		else
> 
> Should we consider taking the GICv4.1 support into uaccess_{read/write}
> callbacks for GICR_ISPENDR0 so that userspace can properly save/restore
> the pending state of GICv4.1 vSGIs?
> 
> I *think* we can do it because on restoration, GICD_CTLR(.nASSGIreq) is
> restored before GICR_ISPENDR0.  So we know whether we're restoring
> pending for vSGIs, and we can restore it to the HW level if v4.1 is
> supported by GIC. Otherwise restore it by the normal way.
> 
> And saving is easy with the get_irqchip_state callback, right?

Yes, this should be pretty easy to do, but I haven't completely worked 
out
the ordering dependencies (you're way ahead of me here!).

There is still a chance that userspace will play with us trying to set 
and
reset nASSGIreq, so we need to define what is acceptable...

> 
>> @@ -281,6 +336,20 @@ void vgic_mmio_write_cpending(struct kvm_vcpu 
>> *vcpu,
>>     		raw_spin_lock_irqsave(&irq->irq_lock, flags);
>>   +		if (irq->hw && vgic_irq_is_sgi(irq->intid)) {
>> +			/* HW SGI? Ask the GIC to inject it */
> 
> "Ask the GIC to clear its pending state" :-)

One day, I'll ban copy/paste from my editor... ;-)

         M.
-- 
Jazz is not dead. It just smells funny...
