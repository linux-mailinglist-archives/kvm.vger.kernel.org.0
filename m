Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B195AAA463
	for <lists+kvm@lfdr.de>; Thu,  5 Sep 2019 15:26:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728377AbfIEN03 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 5 Sep 2019 09:26:29 -0400
Received: from foss.arm.com ([217.140.110.172]:45132 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728184AbfIEN03 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 5 Sep 2019 09:26:29 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id A069028;
        Thu,  5 Sep 2019 06:26:28 -0700 (PDT)
Received: from [10.1.197.61] (usa-sjc-imap-foss1.foss.arm.com [10.121.207.14])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 7F54B3F67D;
        Thu,  5 Sep 2019 06:26:27 -0700 (PDT)
Subject: Re: [PATCH] KVM: arm64: vgic-v4: Move the GICv4 residency flow to be
 driven by vcpu_load/put
To:     Andrew Murray <andrew.murray@arm.com>
Cc:     linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        kvm@vger.kernel.org, Suzuki K Poulose <suzuki.poulose@arm.com>,
        Julien Thierry <julien.thierry.kdev@gmail.com>,
        James Morse <james.morse@arm.com>,
        Eric Auger <eric.auger@redhat.com>,
        Andre Przywara <Andre.Przywara@arm.com>
References: <20190903155747.219802-1-maz@kernel.org>
 <20190905130410.GA9720@e119886-lin.cambridge.arm.com>
From:   Marc Zyngier <maz@kernel.org>
Organization: Approximate
Message-ID: <28777048-c34c-b2b3-468f-233b068e057a@kernel.org>
Date:   Thu, 5 Sep 2019 14:26:26 +0100
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20190905130410.GA9720@e119886-lin.cambridge.arm.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 05/09/2019 14:04, Andrew Murray wrote:
> Hi Marc,
> 
> Some feedback below, but mostly questions to aid my understanding...
> 
> On Tue, Sep 03, 2019 at 04:57:47PM +0100, Marc Zyngier wrote:
>> When the VHE code was reworked, a lot of the vgic stuff was moved around,
>> but the GICv4 residency code did stay untouched, meaning that we come
>> in and out of residency on each flush/sync, which is obviously suboptimal.
>>
>> To address this, let's move things around a bit:
>>
>> - Residency entry (flush) moves to vcpu_load
>> - Residency exit (sync) moves to vcpu_put
>> - On blocking (entry to WFI), we "put"
>> - On unblocking (exit from WFI, we "load"
>>
>> Because these can nest (load/block/put/load/unblock/put, for example),
>> we now have per-VPE tracking of the residency state.
>>
>> Additionally, vgic_v4_put gains a "need doorbell" parameter, which only
>> gets set to true when blocking because of a WFI. This allows a finer
>> control of the doorbell, which now also gets disabled as soon as
>> it gets signaled.
>>
>> Signed-off-by: Marc Zyngier <maz@kernel.org>
>> ---
>>  drivers/irqchip/irq-gic-v4.c       |  7 +++-
>>  include/kvm/arm_vgic.h             |  4 +--
>>  include/linux/irqchip/arm-gic-v4.h |  2 ++
>>  virt/kvm/arm/arm.c                 | 12 ++++---
>>  virt/kvm/arm/vgic/vgic-v3.c        |  4 +++
>>  virt/kvm/arm/vgic/vgic-v4.c        | 55 ++++++++++++++----------------
>>  virt/kvm/arm/vgic/vgic.c           |  4 ---
>>  virt/kvm/arm/vgic/vgic.h           |  2 --
>>  8 files changed, 48 insertions(+), 42 deletions(-)
>>
>> diff --git a/drivers/irqchip/irq-gic-v4.c b/drivers/irqchip/irq-gic-v4.c
>> index 563e87ed0766..45969927cc81 100644
>> --- a/drivers/irqchip/irq-gic-v4.c
>> +++ b/drivers/irqchip/irq-gic-v4.c
>> @@ -141,12 +141,17 @@ static int its_send_vpe_cmd(struct its_vpe *vpe, struct its_cmd_info *info)
>>  int its_schedule_vpe(struct its_vpe *vpe, bool on)
>>  {
>>  	struct its_cmd_info info;
>> +	int ret;
>>  
>>  	WARN_ON(preemptible());
>>  
>>  	info.cmd_type = on ? SCHEDULE_VPE : DESCHEDULE_VPE;
>>  
>> -	return its_send_vpe_cmd(vpe, &info);
>> +	ret = its_send_vpe_cmd(vpe, &info);
>> +	if (!ret)
>> +		vpe->resident = on;
>> +
> 
> We make an assumption here that its_schedule_vpe is the only caller of
> its_send_vpe_cmd where we may pass SCHEDULE_VPE. I guess this is currently
> the case.

It is, and it is intended to stay that way.

> Why do we also set the residency flag for DESCHEDULE_VPE?

We don't.

> And by residency we mean that interrupts are delivered to VM, instead of
> doorbell?

Interrupts are always delivered to the VPE, whether it is resident or
not. Residency is defined as the VPE that is currently programmed in the
redistributor (by virtue of programming the VPROPBASER and VPENDBASER
registers).

> 
>> +	return ret;
>>  }
>>  
>>  int its_invall_vpe(struct its_vpe *vpe)
>> diff --git a/include/kvm/arm_vgic.h b/include/kvm/arm_vgic.h
>> index af4f09c02bf1..4dc58d7a0010 100644
>> --- a/include/kvm/arm_vgic.h
>> +++ b/include/kvm/arm_vgic.h
>> @@ -396,7 +396,7 @@ int kvm_vgic_v4_set_forwarding(struct kvm *kvm, int irq,
>>  int kvm_vgic_v4_unset_forwarding(struct kvm *kvm, int irq,
>>  				 struct kvm_kernel_irq_routing_entry *irq_entry);
>>  
>> -void kvm_vgic_v4_enable_doorbell(struct kvm_vcpu *vcpu);
>> -void kvm_vgic_v4_disable_doorbell(struct kvm_vcpu *vcpu);
>> +int vgic_v4_load(struct kvm_vcpu *vcpu);
>> +int vgic_v4_put(struct kvm_vcpu *vcpu, bool need_db);
>>  
>>  #endif /* __KVM_ARM_VGIC_H */
>> diff --git a/include/linux/irqchip/arm-gic-v4.h b/include/linux/irqchip/arm-gic-v4.h
>> index e6b155713b47..ab1396afe08a 100644
>> --- a/include/linux/irqchip/arm-gic-v4.h
>> +++ b/include/linux/irqchip/arm-gic-v4.h
>> @@ -35,6 +35,8 @@ struct its_vpe {
>>  	/* Doorbell interrupt */
>>  	int			irq;
>>  	irq_hw_number_t		vpe_db_lpi;
>> +	/* VPE resident */
>> +	bool			resident;
>>  	/* VPE proxy mapping */
>>  	int			vpe_proxy_event;
>>  	/*
>> diff --git a/virt/kvm/arm/arm.c b/virt/kvm/arm/arm.c
>> index 35a069815baf..4e69268621b6 100644
>> --- a/virt/kvm/arm/arm.c
>> +++ b/virt/kvm/arm/arm.c
>> @@ -321,20 +321,24 @@ void kvm_arch_vcpu_blocking(struct kvm_vcpu *vcpu)
>>  	/*
>>  	 * If we're about to block (most likely because we've just hit a
>>  	 * WFI), we need to sync back the state of the GIC CPU interface
>> -	 * so that we have the lastest PMR and group enables. This ensures
>> +	 * so that we have the latest PMR and group enables. This ensures
>>  	 * that kvm_arch_vcpu_runnable has up-to-date data to decide
>>  	 * whether we have pending interrupts.
>> +	 *
>> +	 * For the same reason, we want to tell GICv4 that we need
>> +	 * doorbells to be signalled, should an interrupt become pending.
> 
> As I understand, and as indicated by removal of kvm_vgic_v4_enable_doorbell
> below, we've now abstracted enabling the doorbell behind the concept of a
> v4_put.
> 
> Why then, do we break that abstraction by adding this comment? Surely we just
> want to indicate that we're done with ITS for now - do whatever you need to do.

Well, I don't think you can realistically pretend that KVM doesn't know
about the intricacies of GICv4. They are intimately linked.

> This would have made more sense to me if the comment above was removed in this
> patch rather than added.

I disagree. The very reason we to a put on GICv4 is to get a doorbell.
If we didn't need one, we'd just let schedule() do a non
doorbell-generating vcpu_put.

>>  	 */
>>  	preempt_disable();
>>  	kvm_vgic_vmcr_sync(vcpu);
>> +	vgic_v4_put(vcpu, true);
>>  	preempt_enable();
>> -
>> -	kvm_vgic_v4_enable_doorbell(vcpu);
>>  }
>>  
>>  void kvm_arch_vcpu_unblocking(struct kvm_vcpu *vcpu)
>>  {
>> -	kvm_vgic_v4_disable_doorbell(vcpu);
>> +	preempt_disable();
>> +	vgic_v4_load(vcpu);
>> +	preempt_enable();
>>  }
>>  
>>  int kvm_arch_vcpu_init(struct kvm_vcpu *vcpu)
>> diff --git a/virt/kvm/arm/vgic/vgic-v3.c b/virt/kvm/arm/vgic/vgic-v3.c
>> index 8d69f007dd0c..48307a9eb1d8 100644
>> --- a/virt/kvm/arm/vgic/vgic-v3.c
>> +++ b/virt/kvm/arm/vgic/vgic-v3.c
>> @@ -664,6 +664,8 @@ void vgic_v3_load(struct kvm_vcpu *vcpu)
>>  
>>  	if (has_vhe())
>>  		__vgic_v3_activate_traps(vcpu);
>> +
>> +	WARN_ON(vgic_v4_load(vcpu));
>>  }
>>  
>>  void vgic_v3_vmcr_sync(struct kvm_vcpu *vcpu)
>> @@ -676,6 +678,8 @@ void vgic_v3_vmcr_sync(struct kvm_vcpu *vcpu)
>>  
>>  void vgic_v3_put(struct kvm_vcpu *vcpu)
>>  {
>> +	WARN_ON(vgic_v4_put(vcpu, false));
>> +
>>  	vgic_v3_vmcr_sync(vcpu);
>>  
>>  	kvm_call_hyp(__vgic_v3_save_aprs, vcpu);
>> diff --git a/virt/kvm/arm/vgic/vgic-v4.c b/virt/kvm/arm/vgic/vgic-v4.c
>> index 477af6aebb97..3a8a28854b13 100644
>> --- a/virt/kvm/arm/vgic/vgic-v4.c
>> +++ b/virt/kvm/arm/vgic/vgic-v4.c
>> @@ -85,6 +85,10 @@ static irqreturn_t vgic_v4_doorbell_handler(int irq, void *info)
>>  {
>>  	struct kvm_vcpu *vcpu = info;
>>  
>> +	/* We got the message, no need to fire again */
>> +	if (!irqd_irq_disabled(&irq_to_desc(irq)->irq_data))
>> +		disable_irq_nosync(irq);
>> +
>>  	vcpu->arch.vgic_cpu.vgic_v3.its_vpe.pending_last = true;
>>  	kvm_make_request(KVM_REQ_IRQ_PENDING, vcpu);
>>  	kvm_vcpu_kick(vcpu);
> 
> This is because the doorbell will fire each time any guest device interrupts,
> however we only need to tell the guest just once that something has happened
> right?

Not for any guest interrupt. Only for VLPIs. And yes, there is no need
to get multiple doorbells. Once you got one, you know you're runnable
and don't need to be told another 50k times...

> 
>> @@ -192,20 +196,30 @@ void vgic_v4_teardown(struct kvm *kvm)
>>  	its_vm->vpes = NULL;
>>  }
>>  
>> -int vgic_v4_sync_hwstate(struct kvm_vcpu *vcpu)
>> +int vgic_v4_put(struct kvm_vcpu *vcpu, bool need_db)
>>  {
>> -	if (!vgic_supports_direct_msis(vcpu->kvm))
>> +	struct its_vpe *vpe = &vcpu->arch.vgic_cpu.vgic_v3.its_vpe;
>> +	struct irq_desc *desc = irq_to_desc(vpe->irq);
>> +
>> +	if (!vgic_supports_direct_msis(vcpu->kvm) || !vpe->resident)
>>  		return 0;
> 
> Are we using !vpe->resident to avoid pointlessly doing work we've
> already done?

And also to avoid corrupting the state that we've saved by re-reading
what could potentially be an invalid state.

> 
>>  
>> -	return its_schedule_vpe(&vcpu->arch.vgic_cpu.vgic_v3.its_vpe, false);
>> +	/*
>> +	 * If blocking, a doorbell is required. Undo the nested
>> +	 * disable_irq() calls...
>> +	 */
>> +	while (need_db && irqd_irq_disabled(&desc->irq_data))
>> +		enable_irq(vpe->irq);
>> +
>> +	return its_schedule_vpe(vpe, false);
>>  }
>>  
>> -int vgic_v4_flush_hwstate(struct kvm_vcpu *vcpu)
>> +int vgic_v4_load(struct kvm_vcpu *vcpu)
>>  {
>> -	int irq = vcpu->arch.vgic_cpu.vgic_v3.its_vpe.irq;
>> +	struct its_vpe *vpe = &vcpu->arch.vgic_cpu.vgic_v3.its_vpe;
>>  	int err;
>>  
>> -	if (!vgic_supports_direct_msis(vcpu->kvm))
>> +	if (!vgic_supports_direct_msis(vcpu->kvm) || vpe->resident)
>>  		return 0;
>>  
>>  	/*
>> @@ -214,11 +228,14 @@ int vgic_v4_flush_hwstate(struct kvm_vcpu *vcpu)
>>  	 * doc in drivers/irqchip/irq-gic-v4.c to understand how this
>>  	 * turns into a VMOVP command at the ITS level.
>>  	 */
>> -	err = irq_set_affinity(irq, cpumask_of(smp_processor_id()));
>> +	err = irq_set_affinity(vpe->irq, cpumask_of(smp_processor_id()));
>>  	if (err)
>>  		return err;
>>  
>> -	err = its_schedule_vpe(&vcpu->arch.vgic_cpu.vgic_v3.its_vpe, true);
>> +	/* Disabled the doorbell, as we're about to enter the guest */
>> +	disable_irq(vpe->irq);
>> +
>> +	err = its_schedule_vpe(vpe, true);
>>  	if (err)
>>  		return err;
> 
> Given that the doorbell corresponds with vpe residency, it could make sense
> to add a helper here that calls its_schedule_vpe and [disable,enable]_irq.
> Though I see that vgic_v3_put calls vgic_v4_put with need_db=false. I wonder
> what effect setting that to true would be for vgic_v3_put? Could it be known
> that v3 won't set need_db to true?

There is no doorbells for GICv3.

	M.
-- 
Jazz is not dead, it just smells funny...
