Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8A2C02C6E88
	for <lists+kvm@lfdr.de>; Sat, 28 Nov 2020 03:48:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729672AbgK1Clw (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 27 Nov 2020 21:41:52 -0500
Received: from szxga04-in.huawei.com ([45.249.212.190]:8191 "EHLO
        szxga04-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731071AbgK1Cj3 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 27 Nov 2020 21:39:29 -0500
Received: from DGGEMS406-HUB.china.huawei.com (unknown [172.30.72.60])
        by szxga04-in.huawei.com (SkyGuard) with ESMTP id 4CjbJ51R0yzkhWs;
        Sat, 28 Nov 2020 10:37:41 +0800 (CST)
Received: from [10.174.187.74] (10.174.187.74) by
 DGGEMS406-HUB.china.huawei.com (10.3.19.206) with Microsoft SMTP Server id
 14.3.487.0; Sat, 28 Nov 2020 10:38:01 +0800
Subject: Re: [PATCH] irqchip/gic-v4.1: Optimize the wait for the completion of
 the analysis of the VPT
To:     Marc Zyngier <maz@kernel.org>
CC:     Thomas Gleixner <tglx@linutronix.de>,
        <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        <kvmarm@lists.cs.columbia.edu>, <kvm@vger.kernel.org>,
        James Morse <james.morse@arm.com>,
        Julien Thierry <julien.thierry.kdev@gmail.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will@kernel.org>,
        Eric Auger <eric.auger@redhat.com>,
        Christoffer Dall <christoffer.dall@arm.com>,
        <wanghaibin.wang@huawei.com>, <yuzenghui@huawei.com>
References: <20200923063543.1920-1-lushenming@huawei.com>
 <7d0c6bfe7485094154a05bfb2de03640@kernel.org>
From:   Shenming Lu <lushenming@huawei.com>
Message-ID: <6713e563-f037-f512-a3ce-801599114776@huawei.com>
Date:   Sat, 28 Nov 2020 10:38:01 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.2.2
MIME-Version: 1.0
In-Reply-To: <7d0c6bfe7485094154a05bfb2de03640@kernel.org>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.174.187.74]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 2020/11/28 3:35, Marc Zyngier wrote:
> Shenming,
> 
> Somehow this patch ended up in the wrong folder.
> Apologies for the delay reviewing it.>
> On 2020-09-23 07:35, Shenming Lu wrote:
>> Right after a vPE is made resident, the code starts polling the
>> GICR_VPENDBASER.Dirty bit until it becomes 0, where the delay_us
>> is set to 10. But in our measurement, it takes only hundreds of
>> nanoseconds, or 1~2 microseconds, to finish parsing the VPT in most
>> cases. And we also measured the time from vcpu_load() (include it)
>> to __guest_enter() on Kunpeng 920. On average, it takes 2.55 microseconds
>> (not first run && the VPT is empty). So 10 microseconds delay might
>> really hurt performance.
>>
>> To avoid this, we can set the delay_us to 1, which is more appropriate
>> in this situation and universal. Besides, we can delay the execution
>> of its_wait_vpt_parse_complete() (call it from kvm_vgic_flush_hwstate()
>> corresponding to vPE resident), giving the GIC a chance to work in
>> parallel with the CPU on the entry path.
>>
>> Signed-off-by: Shenming Lu <lushenming@huawei.com>
>> ---
>>  arch/arm64/kvm/vgic/vgic-v4.c      | 18 ++++++++++++++++++
>>  arch/arm64/kvm/vgic/vgic.c         |  2 ++
>>  drivers/irqchip/irq-gic-v3-its.c   | 14 +++++++++++---
>>  drivers/irqchip/irq-gic-v4.c       | 11 +++++++++++
>>  include/kvm/arm_vgic.h             |  3 +++
>>  include/linux/irqchip/arm-gic-v4.h |  4 ++++
>>  6 files changed, 49 insertions(+), 3 deletions(-)
>>
>> diff --git a/arch/arm64/kvm/vgic/vgic-v4.c b/arch/arm64/kvm/vgic/vgic-v4.c
>> index b5fa73c9fd35..1d5d2d6894d3 100644
>> --- a/arch/arm64/kvm/vgic/vgic-v4.c
>> +++ b/arch/arm64/kvm/vgic/vgic-v4.c
>> @@ -353,6 +353,24 @@ int vgic_v4_load(struct kvm_vcpu *vcpu)
>>      return err;
>>  }
>>
>> +void vgic_v4_wait_vpt(struct kvm_vcpu *vcpu)
> 
> I'd like something a bit more abstract as a name.
> 
> vgic_v4_commit() seems more appropriate, and could be used for other
> purposes.

Yes, it looks more appropriate.

> 
>> +{
>> +    struct its_vpe *vpe;
>> +
>> +    if (kvm_vgic_global_state.type == VGIC_V2 ||
> 
> Why do you test for GICv2? Isn't the vgic_supports_direct_msis() test enough?
> And the test should be moved to kvm_vgic_flush_hwstate(), as we already have
> similar checks there.

Yes, the test for GICv2 is unnecessary.... I will correct it.

> 
>> !vgic_supports_direct_msis(vcpu->kvm))
>> +        return;
>> +
>> +    vpe = &vcpu->arch.vgic_cpu.vgic_v3.its_vpe;
>> +
>> +    if (vpe->vpt_ready)
>> +        return;
>> +
>> +    if (its_wait_vpt(vpe))
>> +        return;
> 
> How can that happen?

Yes, it seems that its_wait_vpt() would always return 0.

> 
>> +
>> +    vpe->vpt_ready = true;
> 
> This is nasty. You need to explain what happens with this state (you are
> trying not to access VPENDBASER across a shallow exit, as only a vcpu_put

Ok, I will add a comment here.

> will invalidate the GIC state). And something like vpe_ready is more
> generic (we try not to have too much of the GICv4 gunk in the KVM code).

Yes, that's better.

> 
>> +}
>> +
>>  static struct vgic_its *vgic_get_its(struct kvm *kvm,
>>                       struct kvm_kernel_irq_routing_entry *irq_entry)
>>  {
>> diff --git a/arch/arm64/kvm/vgic/vgic.c b/arch/arm64/kvm/vgic/vgic.c
>> index c3643b7f101b..ed810a80cda2 100644
>> --- a/arch/arm64/kvm/vgic/vgic.c
>> +++ b/arch/arm64/kvm/vgic/vgic.c
>> @@ -915,6 +915,8 @@ void kvm_vgic_flush_hwstate(struct kvm_vcpu *vcpu)
>>
>>      if (can_access_vgic_from_kernel())
>>          vgic_restore_state(vcpu);
>> +
>> +    vgic_v4_wait_vpt(vcpu);
>>  }
>>
>>  void kvm_vgic_load(struct kvm_vcpu *vcpu)
>> diff --git a/drivers/irqchip/irq-gic-v3-its.c b/drivers/irqchip/irq-gic-v3-its.c
>> index 548de7538632..b7cbc9bcab9d 100644
>> --- a/drivers/irqchip/irq-gic-v3-its.c
>> +++ b/drivers/irqchip/irq-gic-v3-its.c
>> @@ -3803,7 +3803,7 @@ static void its_wait_vpt_parse_complete(void)
>>      WARN_ON_ONCE(readq_relaxed_poll_timeout_atomic(vlpi_base + GICR_VPENDBASER,
>>                                 val,
>>                                 !(val & GICR_VPENDBASER_Dirty),
>> -                               10, 500));
>> +                               1, 500));
> 
> This really should be in a separate patch.

Ok, I will separate it.

> 
>>  }
>>
>>  static void its_vpe_schedule(struct its_vpe *vpe)
>> @@ -3837,7 +3837,7 @@ static void its_vpe_schedule(struct its_vpe *vpe)
>>      val |= GICR_VPENDBASER_Valid;
>>      gicr_write_vpendbaser(val, vlpi_base + GICR_VPENDBASER);
>>
>> -    its_wait_vpt_parse_complete();
>> +    vpe->vpt_ready = false;
> 
> This really belongs to the deschedule path, doesn't it? Given that
> it can only be set from vgic_flush_hwstate(), it should be fairly
> foolproof.

Yes, that's better.

> 
>>  }
>>
>>  static void its_vpe_deschedule(struct its_vpe *vpe)
>> @@ -3881,6 +3881,10 @@ static int its_vpe_set_vcpu_affinity(struct
>> irq_data *d, void *vcpu_info)
>>          its_vpe_schedule(vpe);
>>          return 0;
>>
>> +    case WAIT_VPT:
> 
> COMMIT_VPE seems a better name.

Yes, that's better.

> 
>> +        its_wait_vpt_parse_complete();
>> +        return 0;
>> +
>>      case DESCHEDULE_VPE:
>>          its_vpe_deschedule(vpe);
>>          return 0;
>> @@ -4047,7 +4051,7 @@ static void its_vpe_4_1_schedule(struct its_vpe *vpe,
>>
>>      gicr_write_vpendbaser(val, vlpi_base + GICR_VPENDBASER);
>>
>> -    its_wait_vpt_parse_complete();
>> +    vpe->vpt_ready = false;
>>  }
>>
>>  static void its_vpe_4_1_deschedule(struct its_vpe *vpe,
>> @@ -4118,6 +4122,10 @@ static int its_vpe_4_1_set_vcpu_affinity(struct
>> irq_data *d, void *vcpu_info)
>>          its_vpe_4_1_schedule(vpe, info);
>>          return 0;
>>
>> +    case WAIT_VPT:
>> +        its_wait_vpt_parse_complete();
>> +        return 0;
>> +
>>      case DESCHEDULE_VPE:
>>          its_vpe_4_1_deschedule(vpe, info);
>>          return 0;
>> diff --git a/drivers/irqchip/irq-gic-v4.c b/drivers/irqchip/irq-gic-v4.c
>> index 0c18714ae13e..36be42569872 100644
>> --- a/drivers/irqchip/irq-gic-v4.c
>> +++ b/drivers/irqchip/irq-gic-v4.c
>> @@ -258,6 +258,17 @@ int its_make_vpe_resident(struct its_vpe *vpe,
>> bool g0en, bool g1en)
>>      return ret;
>>  }
>>
>> +int its_wait_vpt(struct its_vpe *vpe)
> 
> its_commit_vpe()
> 
>> +{
>> +    struct its_cmd_info info = { };
>> +
>> +    WARN_ON(preemptible());
>> +
>> +    info.cmd_type = WAIT_VPT;
> 
> Please write it as:
> 
>         struct its_cmd_info = {
>                 .cmd_type = COMMIT_VPE,
>         };
> 
> as for most of the commands.

Ok, I will correct it.

> 
>> +
>> +    return its_send_vpe_cmd(vpe, &info);
>> +}
>> +
>>  int its_invall_vpe(struct its_vpe *vpe)
>>  {
>>      struct its_cmd_info info = {
>> diff --git a/include/kvm/arm_vgic.h b/include/kvm/arm_vgic.h
>> index a8d8fdcd3723..b55a835d28a8 100644
>> --- a/include/kvm/arm_vgic.h
>> +++ b/include/kvm/arm_vgic.h
>> @@ -402,6 +402,9 @@ int kvm_vgic_v4_unset_forwarding(struct kvm *kvm, int irq,
>>                   struct kvm_kernel_irq_routing_entry *irq_entry);
>>
>>  int vgic_v4_load(struct kvm_vcpu *vcpu);
>> +
>> +void vgic_v4_wait_vpt(struct kvm_vcpu *vcpu);
>> +
>>  int vgic_v4_put(struct kvm_vcpu *vcpu, bool need_db);
>>
>>  #endif /* __KVM_ARM_VGIC_H */
>> diff --git a/include/linux/irqchip/arm-gic-v4.h
>> b/include/linux/irqchip/arm-gic-v4.h
>> index 6976b8331b60..68ac2b7b9309 100644
>> --- a/include/linux/irqchip/arm-gic-v4.h
>> +++ b/include/linux/irqchip/arm-gic-v4.h
>> @@ -75,6 +75,8 @@ struct its_vpe {
>>      u16            vpe_id;
>>      /* Pending VLPIs on schedule out? */
>>      bool            pending_last;
>> +    /* VPT parse complete */
>> +    bool            vpt_ready;
>>  };
>>
>>  /*
>> @@ -103,6 +105,7 @@ enum its_vcpu_info_cmd_type {
>>      PROP_UPDATE_VLPI,
>>      PROP_UPDATE_AND_INV_VLPI,
>>      SCHEDULE_VPE,
>> +    WAIT_VPT,
>>      DESCHEDULE_VPE,
>>      INVALL_VPE,
>>      PROP_UPDATE_VSGI,
>> @@ -128,6 +131,7 @@ struct its_cmd_info {
>>  int its_alloc_vcpu_irqs(struct its_vm *vm);
>>  void its_free_vcpu_irqs(struct its_vm *vm);
>>  int its_make_vpe_resident(struct its_vpe *vpe, bool g0en, bool g1en);
>> +int its_wait_vpt(struct its_vpe *vpe);
>>  int its_make_vpe_non_resident(struct its_vpe *vpe, bool db);
>>  int its_invall_vpe(struct its_vpe *vpe);
>>  int its_map_vlpi(int irq, struct its_vlpi_map *map);
> 
> My comments are mostly cosmetic. If you can respin quickly, I'll
> pick it up for 5.11.

Ok, I will try to respin it quickly.

Thanks for reviewing, :)
Shenming

> 
> Thanks,
> 
>         M.
