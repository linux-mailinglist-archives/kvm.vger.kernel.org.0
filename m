Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5F59A2C1FA1
	for <lists+kvm@lfdr.de>; Tue, 24 Nov 2020 09:13:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730350AbgKXIKo (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 24 Nov 2020 03:10:44 -0500
Received: from szxga06-in.huawei.com ([45.249.212.32]:7974 "EHLO
        szxga06-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730299AbgKXIKo (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 24 Nov 2020 03:10:44 -0500
Received: from DGGEMS410-HUB.china.huawei.com (unknown [172.30.72.58])
        by szxga06-in.huawei.com (SkyGuard) with ESMTP id 4CgGsp5vdGzhg5l;
        Tue, 24 Nov 2020 16:10:22 +0800 (CST)
Received: from [10.174.187.74] (10.174.187.74) by
 DGGEMS410-HUB.china.huawei.com (10.3.19.210) with Microsoft SMTP Server id
 14.3.487.0; Tue, 24 Nov 2020 16:10:27 +0800
Subject: Re: [RFC PATCH v1 3/4] KVM: arm64: GICv4.1: Restore VLPI's pending
 state to physical side
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
 <20201123065410.1915-4-lushenming@huawei.com>
 <5c724bb83730cdd5dcf7add9a812fa92@kernel.org>
From:   Shenming Lu <lushenming@huawei.com>
Message-ID: <b03edcf2-2950-572f-fd31-601d8d766c80@huawei.com>
Date:   Tue, 24 Nov 2020 16:10:26 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.2.2
MIME-Version: 1.0
In-Reply-To: <5c724bb83730cdd5dcf7add9a812fa92@kernel.org>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.174.187.74]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 2020/11/23 17:27, Marc Zyngier wrote:
> On 2020-11-23 06:54, Shenming Lu wrote:
>> From: Zenghui Yu <yuzenghui@huawei.com>
>>
>> When setting the forwarding path of a VLPI, it is more consistent to
> 
> I'm not sure it is more consistent. It is a *new* behaviour, because it only
> matters for migration, which has been so far unsupported.

Alright, consistent may not be accurate...
But I have doubt that whether there is really no need to transfer the pending states
from kvm'vgic to VPT in set_forwarding regardless of migration, and the similar
for unset_forwarding.

> 
>> also transfer the pending state from irq->pending_latch to VPT (especially
>> in migration, the pending states of VLPIs are restored into kvm’s vgic
>> first). And we currently send "INT+VSYNC" to trigger a VLPI to pending.
>>
>> Signed-off-by: Zenghui Yu <yuzenghui@huawei.com>
>> Signed-off-by: Shenming Lu <lushenming@huawei.com>
>> ---
>>  arch/arm64/kvm/vgic/vgic-v4.c | 12 ++++++++++++
>>  1 file changed, 12 insertions(+)
>>
>> diff --git a/arch/arm64/kvm/vgic/vgic-v4.c b/arch/arm64/kvm/vgic/vgic-v4.c
>> index b5fa73c9fd35..cc3ab9cea182 100644
>> --- a/arch/arm64/kvm/vgic/vgic-v4.c
>> +++ b/arch/arm64/kvm/vgic/vgic-v4.c
>> @@ -418,6 +418,18 @@ int kvm_vgic_v4_set_forwarding(struct kvm *kvm, int virq,
>>      irq->host_irq    = virq;
>>      atomic_inc(&map.vpe->vlpi_count);
>>
>> +    /* Transfer pending state */
>> +    ret = irq_set_irqchip_state(irq->host_irq,
>> +                    IRQCHIP_STATE_PENDING,
>> +                    irq->pending_latch);
>> +    WARN_RATELIMIT(ret, "IRQ %d", irq->host_irq);
>> +
>> +    /*
>> +     * Let it be pruned from ap_list later and don't bother
>> +     * the List Register.
>> +     */
>> +    irq->pending_latch = false;
> 
> It occurs to me that calling into irq_set_irqchip_state() for a large
> number of interrupts can take a significant amount of time. It is also
> odd that you dump the VPT with the VPE unmapped, but rely on the VPE
> being mapped for the opposite operation.
> 
> Shouldn't these be symmetric, all performed while the VPE is unmapped?
> It would also save a lot of ITS traffic.
> 

My thought was to use the existing interface directly without unmapping...

If you want to unmap the vPE and poke the VPT here, as I said in the cover
letter, set/unset_forwarding might also be called when all devices are running
at normal run time, in which case the unmapping of the vPE is not allowed...

Another possible solution is to add a new dedicated interface to QEMU to transfer
these pending states to HW in GIC VM state change handler corresponding to
save_pending_tables?

>> +
>>  out:
>>      mutex_unlock(&its->its_lock);
>>      return ret;
> 
> Thanks,
> 
>         M.
