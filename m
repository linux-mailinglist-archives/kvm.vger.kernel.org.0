Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DAEB633AE3F
	for <lists+kvm@lfdr.de>; Mon, 15 Mar 2021 10:12:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229591AbhCOJMW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 15 Mar 2021 05:12:22 -0400
Received: from szxga04-in.huawei.com ([45.249.212.190]:13169 "EHLO
        szxga04-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229512AbhCOJL4 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 15 Mar 2021 05:11:56 -0400
Received: from DGGEMS407-HUB.china.huawei.com (unknown [172.30.72.58])
        by szxga04-in.huawei.com (SkyGuard) with ESMTP id 4DzVwq3CxHzmXXD;
        Mon, 15 Mar 2021 17:09:31 +0800 (CST)
Received: from [10.174.184.135] (10.174.184.135) by
 DGGEMS407-HUB.china.huawei.com (10.3.19.207) with Microsoft SMTP Server id
 14.3.498.0; Mon, 15 Mar 2021 17:11:45 +0800
Subject: Re: [PATCH v4 5/6] KVM: arm64: GICv4.1: Restore VLPI pending state to
 physical side
To:     Marc Zyngier <maz@kernel.org>
CC:     Eric Auger <eric.auger@redhat.com>, Will Deacon <will@kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        <kvmarm@lists.cs.columbia.edu>, <kvm@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>,
        Alex Williamson <alex.williamson@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        "Lorenzo Pieralisi" <lorenzo.pieralisi@arm.com>,
        <wanghaibin.wang@huawei.com>, <yuzenghui@huawei.com>
References: <20210313083900.234-1-lushenming@huawei.com>
 <20210313083900.234-6-lushenming@huawei.com>
 <d9047922808df340feca2f257cfb8a3d@kernel.org>
From:   Shenming Lu <lushenming@huawei.com>
Message-ID: <81fbadda-0489-ffc3-cb38-08e89871ec95@huawei.com>
Date:   Mon, 15 Mar 2021 17:11:34 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.2.2
MIME-Version: 1.0
In-Reply-To: <d9047922808df340feca2f257cfb8a3d@kernel.org>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.174.184.135]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 2021/3/15 16:30, Marc Zyngier wrote:
> On 2021-03-13 08:38, Shenming Lu wrote:
>> From: Zenghui Yu <yuzenghui@huawei.com>
>>
>> When setting the forwarding path of a VLPI (switch to the HW mode),
>> we can also transfer the pending state from irq->pending_latch to
>> VPT (especially in migration, the pending states of VLPIs are restored
>> into kvm’s vgic first). And we currently send "INT+VSYNC" to trigger
>> a VLPI to pending.
>>
>> Signed-off-by: Zenghui Yu <yuzenghui@huawei.com>
>> Signed-off-by: Shenming Lu <lushenming@huawei.com>
>> ---
>>  arch/arm64/kvm/vgic/vgic-v4.c | 18 ++++++++++++++++++
>>  1 file changed, 18 insertions(+)
>>
>> diff --git a/arch/arm64/kvm/vgic/vgic-v4.c b/arch/arm64/kvm/vgic/vgic-v4.c
>> index ac029ba3d337..3b82ab80c2f3 100644
>> --- a/arch/arm64/kvm/vgic/vgic-v4.c
>> +++ b/arch/arm64/kvm/vgic/vgic-v4.c
>> @@ -449,6 +449,24 @@ int kvm_vgic_v4_set_forwarding(struct kvm *kvm, int virq,
>>      irq->host_irq    = virq;
>>      atomic_inc(&map.vpe->vlpi_count);
>>
>> +    /* Transfer pending state */
>> +    if (irq->pending_latch) {
>> +        unsigned long flags;
>> +
>> +        ret = irq_set_irqchip_state(irq->host_irq,
>> +                        IRQCHIP_STATE_PENDING,
>> +                        irq->pending_latch);
>> +        WARN_RATELIMIT(ret, "IRQ %d", irq->host_irq);
>> +
>> +        /*
>> +         * Clear pending_latch and communicate this state
>> +         * change via vgic_queue_irq_unlock.
>> +         */
>> +        raw_spin_lock_irqsave(&irq->irq_lock, flags);
>> +        irq->pending_latch = false;
>> +        vgic_queue_irq_unlock(kvm, irq, flags);
>> +    }
>> +
>>  out:
>>      mutex_unlock(&its->its_lock);
>>      return ret;
> 
> The read side of the pending state isn't locked, but the write side is.
> I'd rather you lock the whole sequence for peace of mind.

Did you mean to lock before emitting the mapping request, Or just before reading
the pending state?

Thanks,
Shenming

> 
> Thanks,
> 
>         M.
