Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BD5002C1F00
	for <lists+kvm@lfdr.de>; Tue, 24 Nov 2020 08:41:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730139AbgKXHk3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 24 Nov 2020 02:40:29 -0500
Received: from szxga07-in.huawei.com ([45.249.212.35]:8395 "EHLO
        szxga07-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730006AbgKXHk2 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 24 Nov 2020 02:40:28 -0500
Received: from DGGEMS410-HUB.china.huawei.com (unknown [172.30.72.60])
        by szxga07-in.huawei.com (SkyGuard) with ESMTP id 4CgGBp5scLz71kd;
        Tue, 24 Nov 2020 15:40:02 +0800 (CST)
Received: from [10.174.187.74] (10.174.187.74) by
 DGGEMS410-HUB.china.huawei.com (10.3.19.210) with Microsoft SMTP Server id
 14.3.487.0; Tue, 24 Nov 2020 15:40:14 +0800
Subject: Re: [RFC PATCH v1 2/4] KVM: arm64: GICv4.1: Try to save hw pending
 state in save_pending_tables
To:     Marc Zyngier <maz@kernel.org>
CC:     James Morse <james.morse@arm.com>,
        Julien Thierry <julien.thierry.kdev@gmail.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Eric Auger <eric.auger@redhat.com>,
        <linux-arm-kernel@lists.infradead.org>,
        <kvmarm@lists.cs.columbia.edu>, <kvm@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>,
        Christoffer Dall <christoffer.dall@arm.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Kirti Wankhede <kwankhede@nvidia.com>,
        Cornelia Huck <cohuck@redhat.com>, Neo Jia <cjia@nvidia.com>,
        <wanghaibin.wang@huawei.com>, <yuzenghui@huawei.com>
References: <20201123065410.1915-1-lushenming@huawei.com>
 <20201123065410.1915-3-lushenming@huawei.com>
 <f3ea1b24436bb86b5a5633f8ccc9b3d1@kernel.org>
From:   Shenming Lu <lushenming@huawei.com>
Message-ID: <90f04f50-c1ba-55b2-0f93-1e755b40b487@huawei.com>
Date:   Tue, 24 Nov 2020 15:40:13 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.2.2
MIME-Version: 1.0
In-Reply-To: <f3ea1b24436bb86b5a5633f8ccc9b3d1@kernel.org>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.174.187.74]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 2020/11/23 17:18, Marc Zyngier wrote:
> On 2020-11-23 06:54, Shenming Lu wrote:
>> After pausing all vCPUs and devices capable of interrupting, in order
>         ^^^^^^^^^^^^^^^^^
> See my comment below about this.
> 
>> to save the information of all interrupts, besides flushing the pending
>> states in kvm’s vgic, we also try to flush the states of VLPIs in the
>> virtual pending tables into guest RAM, but we need to have GICv4.1 and
>> safely unmap the vPEs first.
>>
>> Signed-off-by: Shenming Lu <lushenming@huawei.com>
>> ---
>>  arch/arm64/kvm/vgic/vgic-v3.c | 62 +++++++++++++++++++++++++++++++----
>>  1 file changed, 56 insertions(+), 6 deletions(-)
>>
>> diff --git a/arch/arm64/kvm/vgic/vgic-v3.c b/arch/arm64/kvm/vgic/vgic-v3.c
>> index 9cdf39a94a63..e1b3aa4b2b12 100644
>> --- a/arch/arm64/kvm/vgic/vgic-v3.c
>> +++ b/arch/arm64/kvm/vgic/vgic-v3.c
>> @@ -1,6 +1,8 @@
>>  // SPDX-License-Identifier: GPL-2.0-only
>>
>>  #include <linux/irqchip/arm-gic-v3.h>
>> +#include <linux/irq.h>
>> +#include <linux/irqdomain.h>
>>  #include <linux/kvm.h>
>>  #include <linux/kvm_host.h>
>>  #include <kvm/arm_vgic.h>
>> @@ -356,6 +358,39 @@ int vgic_v3_lpi_sync_pending_status(struct kvm
>> *kvm, struct vgic_irq *irq)
>>      return 0;
>>  }
>>
>> +/*
>> + * With GICv4.1, we can get the VLPI's pending state after unmapping
>> + * the vPE. The deactivation of the doorbell interrupt will trigger
>> + * the unmapping of the associated vPE.
>> + */
>> +static void get_vlpi_state_pre(struct vgic_dist *dist)
>> +{
>> +    struct irq_desc *desc;
>> +    int i;
>> +
>> +    if (!kvm_vgic_global_state.has_gicv4_1)
>> +        return;
>> +
>> +    for (i = 0; i < dist->its_vm.nr_vpes; i++) {
>> +        desc = irq_to_desc(dist->its_vm.vpes[i]->irq);
>> +        irq_domain_deactivate_irq(irq_desc_get_irq_data(desc));
>> +    }
>> +}
>> +
>> +static void get_vlpi_state_post(struct vgic_dist *dist)
> 
> nit: the naming feels a bit... odd. Pre/post what?

My understanding is that the unmapping is a preparation for get_vlpi_state...
Maybe just call it unmap/map_all_vpes?

> 
>> +{
>> +    struct irq_desc *desc;
>> +    int i;
>> +
>> +    if (!kvm_vgic_global_state.has_gicv4_1)
>> +        return;
>> +
>> +    for (i = 0; i < dist->its_vm.nr_vpes; i++) {
>> +        desc = irq_to_desc(dist->its_vm.vpes[i]->irq);
>> +        irq_domain_activate_irq(irq_desc_get_irq_data(desc), false);
>> +    }
>> +}
>> +
>>  /**
>>   * vgic_v3_save_pending_tables - Save the pending tables into guest RAM
>>   * kvm lock and all vcpu lock must be held
>> @@ -365,14 +400,17 @@ int vgic_v3_save_pending_tables(struct kvm *kvm)
>>      struct vgic_dist *dist = &kvm->arch.vgic;
>>      struct vgic_irq *irq;
>>      gpa_t last_ptr = ~(gpa_t)0;
>> -    int ret;
>> +    int ret = 0;
>>      u8 val;
>>
>> +    get_vlpi_state_pre(dist);
>> +
>>      list_for_each_entry(irq, &dist->lpi_list_head, lpi_list) {
>>          int byte_offset, bit_nr;
>>          struct kvm_vcpu *vcpu;
>>          gpa_t pendbase, ptr;
>>          bool stored;
>> +        bool is_pending = irq->pending_latch;
>>
>>          vcpu = irq->target_vcpu;
>>          if (!vcpu)
>> @@ -387,24 +425,36 @@ int vgic_v3_save_pending_tables(struct kvm *kvm)
>>          if (ptr != last_ptr) {
>>              ret = kvm_read_guest_lock(kvm, ptr, &val, 1);
>>              if (ret)
>> -                return ret;
>> +                goto out;
>>              last_ptr = ptr;
>>          }
>>
>>          stored = val & (1U << bit_nr);
>> -        if (stored == irq->pending_latch)
>> +
>> +        /* also flush hw pending state */
> 
> This comment looks out of place, as we aren't flushing anything.

Ok, I will correct it.

> 
>> +        if (irq->hw) {
>> +            WARN_RATELIMIT(irq_get_irqchip_state(irq->host_irq,
>> +                        IRQCHIP_STATE_PENDING, &is_pending),
>> +                       "IRQ %d", irq->host_irq);
> 
> Isn't this going to warn like mad on a GICv4.0 system where this, by definition,
> will generate an error?

As we have returned an error in save_its_tables if hw && !has_gicv4_1, we don't
have to warn this here?

> 
>> +        }
>> +
>> +        if (stored == is_pending)
>>              continue;
>>
>> -        if (irq->pending_latch)
>> +        if (is_pending)
>>              val |= 1 << bit_nr;
>>          else
>>              val &= ~(1 << bit_nr);
>>
>>          ret = kvm_write_guest_lock(kvm, ptr, &val, 1);
>>          if (ret)
>> -            return ret;
>> +            goto out;
>>      }
>> -    return 0;
>> +
>> +out:
>> +    get_vlpi_state_post(dist);
> 
> This bit worries me: you have unmapped the VPEs, so any interrupt that has been
> generated during that phase is now forever lost (the GIC doesn't have ownership
> of the pending tables).

In my opinion, during this phase, the devices capable of interrupting should have
already been paused (prevent from sending interrupts), such as VFIO migration protocol
has already realized it.

> 
> Do you really expect the VM to be restartable from that point? I don't see how
> this is possible.
> 

If the migration has encountered an error, the src VM might be restarted, so we have to
map the vPEs back.

>> +
>> +    return ret;
>>  }
>>
>>  /**
> 
> Thanks,
> 
>         M.

Thanks,
Shenming
