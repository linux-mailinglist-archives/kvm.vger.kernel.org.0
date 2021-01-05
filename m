Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7C4452EAB74
	for <lists+kvm@lfdr.de>; Tue,  5 Jan 2021 14:04:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730492AbhAENDj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 5 Jan 2021 08:03:39 -0500
Received: from szxga07-in.huawei.com ([45.249.212.35]:10389 "EHLO
        szxga07-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729689AbhAENDi (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 5 Jan 2021 08:03:38 -0500
Received: from DGGEMS403-HUB.china.huawei.com (unknown [172.30.72.59])
        by szxga07-in.huawei.com (SkyGuard) with ESMTP id 4D9CLp3N5yz7QY8;
        Tue,  5 Jan 2021 21:01:54 +0800 (CST)
Received: from [10.174.184.196] (10.174.184.196) by
 DGGEMS403-HUB.china.huawei.com (10.3.19.203) with Microsoft SMTP Server id
 14.3.498.0; Tue, 5 Jan 2021 21:02:38 +0800
Subject: Re: [RFC PATCH v2 2/4] KVM: arm64: GICv4.1: Try to save hw pending
 state in save_pending_tables
To:     Marc Zyngier <maz@kernel.org>
CC:     Eric Auger <eric.auger@redhat.com>, Will Deacon <will@kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        <kvmarm@lists.cs.columbia.edu>, <kvm@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>,
        Alex Williamson <alex.williamson@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        "Lorenzo Pieralisi" <lorenzo.pieralisi@arm.com>,
        <wanghaibin.wang@huawei.com>, <yuzenghui@huawei.com>
References: <20210104081613.100-1-lushenming@huawei.com>
 <20210104081613.100-3-lushenming@huawei.com>
 <b0f0b2544f8e231ebb5b5545be226164@kernel.org>
From:   Shenming Lu <lushenming@huawei.com>
Message-ID: <0fa19ab1-60ba-9067-e1aa-ee78191c52ed@huawei.com>
Date:   Tue, 5 Jan 2021 21:02:26 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.2.2
MIME-Version: 1.0
In-Reply-To: <b0f0b2544f8e231ebb5b5545be226164@kernel.org>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.174.184.196]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 2021/1/5 17:13, Marc Zyngier wrote:
> On 2021-01-04 08:16, Shenming Lu wrote:
>> After pausing all vCPUs and devices capable of interrupting, in order
>> to save the information of all interrupts, besides flushing the pending
>> states in kvm’s vgic, we also try to flush the states of VLPIs in the
>> virtual pending tables into guest RAM, but we need to have GICv4.1 and
>> safely unmap the vPEs first.
>>
>> Signed-off-by: Shenming Lu <lushenming@huawei.com>
>> ---
>>  arch/arm64/kvm/vgic/vgic-v3.c | 58 +++++++++++++++++++++++++++++++----
>>  1 file changed, 52 insertions(+), 6 deletions(-)
>>
>> diff --git a/arch/arm64/kvm/vgic/vgic-v3.c b/arch/arm64/kvm/vgic/vgic-v3.c
>> index 9cdf39a94a63..a58c94127cb0 100644
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
>> @@ -356,6 +358,38 @@ int vgic_v3_lpi_sync_pending_status(struct kvm
>> *kvm, struct vgic_irq *irq)
>>      return 0;
>>  }
>>
>> +/*
>> + * The deactivation of the doorbell interrupt will trigger the
>> + * unmapping of the associated vPE.
>> + */
>> +static void unmap_all_vpes(struct vgic_dist *dist)
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
>> +static void map_all_vpes(struct vgic_dist *dist)
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
>> @@ -365,14 +399,18 @@ int vgic_v3_save_pending_tables(struct kvm *kvm)
>>      struct vgic_dist *dist = &kvm->arch.vgic;
>>      struct vgic_irq *irq;
>>      gpa_t last_ptr = ~(gpa_t)0;
>> -    int ret;
>> +    int ret = 0;
>>      u8 val;
>>
>> +    /* As a preparation for getting any VLPI states. */
>> +    unmap_all_vpes(dist);
> 
> What if the VPEs are not mapped yet? Is it possible to snapshot a VM
> that has not run at all?

What I see in QEMU is that the saving of the pending tables would only be
called when stopping the VM and it needs the current VM state to be RUNNING.

> 
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
>> @@ -387,24 +425,32 @@ int vgic_v3_save_pending_tables(struct kvm *kvm)
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
>> +        if (irq->hw)
>> +            vgic_v4_get_vlpi_state(irq, &is_pending);
> 
> You don't check the return value here, so I wonder why the checks
> in vgic_v4_get_vlpi_state().

Since I have already checked the condition and reported in save_its_tables
(patch 4), I just check in get_vlpi_state and don't report again here.

> 
> Another thing that worries me is that vgic_v4_get_vlpi_state() doesn't
> have any cache invalidation, and can end-up hitting in the CPU cache
> (there is no guarantee of coherency between the GIC and the CPU, only
> that the GIC will have flushed its caches).
> 
> I'd expect this to happen at unmap time, though, in order to avoid
> repeated single byte invalidations.

Ok, I will add a cache invalidation at unmap time.

> 
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
>> +    map_all_vpes(dist);
>> +
>> +    return ret;
>>  }
>>
>>  /**
> 
> Thanks,
> 
>         M.
