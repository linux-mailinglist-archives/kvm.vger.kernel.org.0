Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 41DF32EB800
	for <lists+kvm@lfdr.de>; Wed,  6 Jan 2021 03:15:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726202AbhAFCNj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 5 Jan 2021 21:13:39 -0500
Received: from szxga05-in.huawei.com ([45.249.212.191]:10024 "EHLO
        szxga05-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725948AbhAFCNi (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 5 Jan 2021 21:13:38 -0500
Received: from DGGEMS408-HUB.china.huawei.com (unknown [172.30.72.59])
        by szxga05-in.huawei.com (SkyGuard) with ESMTP id 4D9XtT5Hf1zj3Vx;
        Wed,  6 Jan 2021 10:12:01 +0800 (CST)
Received: from [10.174.184.196] (10.174.184.196) by
 DGGEMS408-HUB.china.huawei.com (10.3.19.208) with Microsoft SMTP Server id
 14.3.498.0; Wed, 6 Jan 2021 10:12:50 +0800
Subject: Re: [RFC PATCH v2 3/4] KVM: arm64: GICv4.1: Restore VLPI's pending
 state to physical side
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
 <20210104081613.100-4-lushenming@huawei.com>
 <76a7b9cca485dc8157d3be53189eac69@kernel.org>
From:   Shenming Lu <lushenming@huawei.com>
Message-ID: <6b815f0e-d042-2ec6-369a-41a19cd1b9f9@huawei.com>
Date:   Wed, 6 Jan 2021 10:12:50 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.2.2
MIME-Version: 1.0
In-Reply-To: <76a7b9cca485dc8157d3be53189eac69@kernel.org>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.174.184.196]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 2021/1/5 17:25, Marc Zyngier wrote:
> On 2021-01-04 08:16, Shenming Lu wrote:
>> From: Zenghui Yu <yuzenghui@huawei.com>
>>
>> When setting the forwarding path of a VLPI (switch to the HW mode),
>> we could also transfer the pending state from irq->pending_latch to
>> VPT (especially in migration, the pending states of VLPIs are restored
>> into kvm’s vgic first). And we currently send "INT+VSYNC" to trigger
>> a VLPI to pending.
>>
>> Signed-off-by: Zenghui Yu <yuzenghui@huawei.com>
>> Signed-off-by: Shenming Lu <lushenming@huawei.com>
>> ---
>>  arch/arm64/kvm/vgic/vgic-v4.c | 12 ++++++++++++
>>  1 file changed, 12 insertions(+)
>>
>> diff --git a/arch/arm64/kvm/vgic/vgic-v4.c b/arch/arm64/kvm/vgic/vgic-v4.c
>> index f211a7c32704..7945d6d09cdd 100644
>> --- a/arch/arm64/kvm/vgic/vgic-v4.c
>> +++ b/arch/arm64/kvm/vgic/vgic-v4.c
>> @@ -454,6 +454,18 @@ int kvm_vgic_v4_set_forwarding(struct kvm *kvm, int virq,
>>      irq->host_irq    = virq;
>>      atomic_inc(&map.vpe->vlpi_count);
>>
>> +    /* Transfer pending state */
>> +    ret = irq_set_irqchip_state(irq->host_irq,
>> +                    IRQCHIP_STATE_PENDING,
>> +                    irq->pending_latch);
>> +    WARN_RATELIMIT(ret, "IRQ %d", irq->host_irq);
> 
> Why do this if pending_latch is 0, which is likely to be
> the overwhelming case?

Yes, there is no need to do this if pending_latch is 0.

> 
>> +
>> +    /*
>> +     * Let it be pruned from ap_list later and don't bother
>> +     * the List Register.
>> +     */
>> +    irq->pending_latch = false;
> 
> What guarantees the pruning? Pruning only happens on vcpu exit,
> which means we may have the same interrupt via both the LR and
> the stream interface, which I don't believe is legal (it is
> like having two LRs holding the same interrupt).

Since the irq's pending_latch is set to false here, it will not be
populated to the LR in vgic_flush_lr_state() (vgic_target_oracle()
will return NULL).

> 
>> +
>>  out:
>>      mutex_unlock(&its->its_lock);
>>      return ret;
> 
> Thanks,
> 
>         M.
