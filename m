Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 657C02C83EC
	for <lists+kvm@lfdr.de>; Mon, 30 Nov 2020 13:13:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727768AbgK3MN0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 30 Nov 2020 07:13:26 -0500
Received: from szxga05-in.huawei.com ([45.249.212.191]:8532 "EHLO
        szxga05-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726137AbgK3MNZ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 30 Nov 2020 07:13:25 -0500
Received: from DGGEMS414-HUB.china.huawei.com (unknown [172.30.72.58])
        by szxga05-in.huawei.com (SkyGuard) with ESMTP id 4Cl3y94gdGzhklw;
        Mon, 30 Nov 2020 20:12:17 +0800 (CST)
Received: from [10.174.184.228] (10.174.184.228) by
 DGGEMS414-HUB.china.huawei.com (10.3.19.214) with Microsoft SMTP Server id
 14.3.487.0; Mon, 30 Nov 2020 20:12:35 +0800
Subject: Re: [PATCH v2 2/2] KVM: arm64: Delay the execution of the polling on
 the GICR_VPENDBASER.Dirty bit
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
References: <20201128141857.983-1-lushenming@huawei.com>
 <20201128141857.983-3-lushenming@huawei.com>
 <b2387410a28f9c5d9ece45e12feead94@kernel.org>
From:   Shenming Lu <lushenming@huawei.com>
Message-ID: <a65a79af-dc3e-bbac-c65e-c95b772135bd@huawei.com>
Date:   Mon, 30 Nov 2020 20:12:35 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.2.2
MIME-Version: 1.0
In-Reply-To: <b2387410a28f9c5d9ece45e12feead94@kernel.org>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.174.184.228]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 2020/11/30 19:22, Marc Zyngier wrote:
> On 2020-11-28 14:18, Shenming Lu wrote:
>> In order to further reduce the impact of the wait delay of the
>> VPT analysis, we can delay the execution of the polling on the
>> GICR_VPENDBASER.Dirty bit (call it from kvm_vgic_flush_hwstate()
>> corresponding to vPE resident), let the GIC and the CPU work in
>> parallel on the entry path.
>>
>> Signed-off-by: Shenming Lu <lushenming@huawei.com>
>> ---
>>  arch/arm64/kvm/vgic/vgic-v4.c      | 16 ++++++++++++++++
>>  arch/arm64/kvm/vgic/vgic.c         |  3 +++
>>  drivers/irqchip/irq-gic-v3-its.c   | 16 ++++++++++++----
>>  drivers/irqchip/irq-gic-v4.c       | 11 +++++++++++
>>  include/kvm/arm_vgic.h             |  3 +++
>>  include/linux/irqchip/arm-gic-v4.h |  4 ++++
>>  6 files changed, 49 insertions(+), 4 deletions(-)
>>
>> diff --git a/arch/arm64/kvm/vgic/vgic-v4.c b/arch/arm64/kvm/vgic/vgic-v4.c
>> index b5fa73c9fd35..b0da74809187 100644
>> --- a/arch/arm64/kvm/vgic/vgic-v4.c
>> +++ b/arch/arm64/kvm/vgic/vgic-v4.c
>> @@ -353,6 +353,22 @@ int vgic_v4_load(struct kvm_vcpu *vcpu)
>>      return err;
>>  }
>>
>> +void vgic_v4_commit(struct kvm_vcpu *vcpu)
>> +{
>> +    struct its_vpe *vpe = &vcpu->arch.vgic_cpu.vgic_v3.its_vpe;
>> +
>> +    /*
>> +     * No need to wait for the vPE to be ready across a shallow guest
>> +     * exit, as only a vcpu_put will invalidate it.
>> +     */
>> +    if (vpe->vpe_ready)
>> +        return;
>> +
>> +    its_commit_vpe(vpe);
>> +
>> +    vpe->vpe_ready = true;
> 
> This should be written as:
> 
> if (!ready)
>      commit();
> 
> and ready being driven by the commit() call itself.
> 
>> +}
>> +
>>  static struct vgic_its *vgic_get_its(struct kvm *kvm,
>>                       struct kvm_kernel_irq_routing_entry *irq_entry)
>>  {
>> diff --git a/arch/arm64/kvm/vgic/vgic.c b/arch/arm64/kvm/vgic/vgic.c
>> index c3643b7f101b..1c597c9885fa 100644
>> --- a/arch/arm64/kvm/vgic/vgic.c
>> +++ b/arch/arm64/kvm/vgic/vgic.c
>> @@ -915,6 +915,9 @@ void kvm_vgic_flush_hwstate(struct kvm_vcpu *vcpu)
>>
>>      if (can_access_vgic_from_kernel())
>>          vgic_restore_state(vcpu);
>> +
>> +    if (vgic_supports_direct_msis(vcpu->kvm))
>> +        vgic_v4_commit(vcpu);
>>  }
>>
>>  void kvm_vgic_load(struct kvm_vcpu *vcpu)
>> diff --git a/drivers/irqchip/irq-gic-v3-its.c b/drivers/irqchip/irq-gic-v3-its.c
>> index 22f427135c6b..f30aba14933e 100644
>> --- a/drivers/irqchip/irq-gic-v3-its.c
>> +++ b/drivers/irqchip/irq-gic-v3-its.c
>> @@ -3842,8 +3842,6 @@ static void its_vpe_schedule(struct its_vpe *vpe)
>>      val |= vpe->idai ? GICR_VPENDBASER_IDAI : 0;
>>      val |= GICR_VPENDBASER_Valid;
>>      gicr_write_vpendbaser(val, vlpi_base + GICR_VPENDBASER);
>> -
>> -    its_wait_vpt_parse_complete();
>>  }
>>
>>  static void its_vpe_deschedule(struct its_vpe *vpe)
>> @@ -3855,6 +3853,8 @@ static void its_vpe_deschedule(struct its_vpe *vpe)
>>
>>      vpe->idai = !!(val & GICR_VPENDBASER_IDAI);
>>      vpe->pending_last = !!(val & GICR_VPENDBASER_PendingLast);
>> +
>> +    vpe->vpe_ready = false;
> 
> This should be set from the its_make_vpe_non_resident() call.
> 
>>  }
>>
>>  static void its_vpe_invall(struct its_vpe *vpe)
>> @@ -3891,6 +3891,10 @@ static int its_vpe_set_vcpu_affinity(struct
>> irq_data *d, void *vcpu_info)
>>          its_vpe_deschedule(vpe);
>>          return 0;
>>
>> +    case COMMIT_VPE:
>> +        its_wait_vpt_parse_complete();
>> +        return 0;
>> +
>>      case INVALL_VPE:
>>          its_vpe_invall(vpe);
>>          return 0;
>> @@ -4052,8 +4056,6 @@ static void its_vpe_4_1_schedule(struct its_vpe *vpe,
>>      val |= FIELD_PREP(GICR_VPENDBASER_4_1_VPEID, vpe->vpe_id);
>>
>>      gicr_write_vpendbaser(val, vlpi_base + GICR_VPENDBASER);
>> -
>> -    its_wait_vpt_parse_complete();
>>  }
>>
>>  static void its_vpe_4_1_deschedule(struct its_vpe *vpe,
>> @@ -4091,6 +4093,8 @@ static void its_vpe_4_1_deschedule(struct its_vpe *vpe,
>>                          GICR_VPENDBASER_PendingLast);
>>          vpe->pending_last = true;
>>      }
>> +
>> +    vpe->vpe_ready = false;
>>  }
>>
>>  static void its_vpe_4_1_invall(struct its_vpe *vpe)
>> @@ -4128,6 +4132,10 @@ static int its_vpe_4_1_set_vcpu_affinity(struct
>> irq_data *d, void *vcpu_info)
>>          its_vpe_4_1_deschedule(vpe, info);
>>          return 0;
>>
>> +    case COMMIT_VPE:
>> +        its_wait_vpt_parse_complete();
>> +        return 0;
>> +
>>      case INVALL_VPE:
>>          its_vpe_4_1_invall(vpe);
>>          return 0;
>> diff --git a/drivers/irqchip/irq-gic-v4.c b/drivers/irqchip/irq-gic-v4.c
>> index 0c18714ae13e..6cea71a4e68b 100644
>> --- a/drivers/irqchip/irq-gic-v4.c
>> +++ b/drivers/irqchip/irq-gic-v4.c
>> @@ -258,6 +258,17 @@ int its_make_vpe_resident(struct its_vpe *vpe,
>> bool g0en, bool g1en)
>>      return ret;
>>  }
>>
>> +int its_commit_vpe(struct its_vpe *vpe)
>> +{
>> +    struct its_cmd_info info = {
>> +        .cmd_type = COMMIT_VPE,
>> +    };
>> +
>> +    WARN_ON(preemptible());
>> +
>> +    return its_send_vpe_cmd(vpe, &info);
>> +}
>> +
>>  int its_invall_vpe(struct its_vpe *vpe)
>>  {
>>      struct its_cmd_info info = {
>> diff --git a/include/kvm/arm_vgic.h b/include/kvm/arm_vgic.h
>> index a8d8fdcd3723..f2170df6cf7c 100644
>> --- a/include/kvm/arm_vgic.h
>> +++ b/include/kvm/arm_vgic.h
>> @@ -401,7 +401,10 @@ int kvm_vgic_v4_set_forwarding(struct kvm *kvm, int irq,
>>  int kvm_vgic_v4_unset_forwarding(struct kvm *kvm, int irq,
>>                   struct kvm_kernel_irq_routing_entry *irq_entry);
>>
>> +void vgic_v4_commit(struct kvm_vcpu *vcpu);
>> +
>>  int vgic_v4_load(struct kvm_vcpu *vcpu);
>> +
> 
> Spurious new lines.
> 
>>  int vgic_v4_put(struct kvm_vcpu *vcpu, bool need_db);
>>
>>  #endif /* __KVM_ARM_VGIC_H */
>> diff --git a/include/linux/irqchip/arm-gic-v4.h
>> b/include/linux/irqchip/arm-gic-v4.h
>> index 6976b8331b60..936d88e482a9 100644
>> --- a/include/linux/irqchip/arm-gic-v4.h
>> +++ b/include/linux/irqchip/arm-gic-v4.h
>> @@ -75,6 +75,8 @@ struct its_vpe {
>>      u16            vpe_id;
>>      /* Pending VLPIs on schedule out? */
>>      bool            pending_last;
>> +    /* VPT parse complete */
>> +    bool            vpe_ready;
>>  };
>>
>>  /*
>> @@ -104,6 +106,7 @@ enum its_vcpu_info_cmd_type {
>>      PROP_UPDATE_AND_INV_VLPI,
>>      SCHEDULE_VPE,
>>      DESCHEDULE_VPE,
>> +    COMMIT_VPE,
>>      INVALL_VPE,
>>      PROP_UPDATE_VSGI,
>>  };
>> @@ -129,6 +132,7 @@ int its_alloc_vcpu_irqs(struct its_vm *vm);
>>  void its_free_vcpu_irqs(struct its_vm *vm);
>>  int its_make_vpe_resident(struct its_vpe *vpe, bool g0en, bool g1en);
>>  int its_make_vpe_non_resident(struct its_vpe *vpe, bool db);
>> +int its_commit_vpe(struct its_vpe *vpe);
>>  int its_invall_vpe(struct its_vpe *vpe);
>>  int its_map_vlpi(int irq, struct its_vlpi_map *map);
>>  int its_get_vlpi(int irq, struct its_vlpi_map *map);
> 
> In order to speed up the respin round-trip, I've taken the liberty
> to refactor this patch myself. Please have a look at [1] and let
> me know if you're OK with it.

I have looked at it and am OK.

By the way, will the first patch (set the delay_us to 1) be picked up
together?

Thanks,
Shenming

> 
> Thanks,
> 
>         M.
> 
> [1] https://git.kernel.org/pub/scm/linux/kernel/git/maz/arm-platforms.git/commit/?h=kvm-arm64/misc-5.11&id=57e3cebd022fbc035dcf190ac789fd2ffc747f5b
