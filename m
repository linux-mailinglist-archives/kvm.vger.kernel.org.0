Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C1D94338B90
	for <lists+kvm@lfdr.de>; Fri, 12 Mar 2021 12:35:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232178AbhCLLex (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 12 Mar 2021 06:34:53 -0500
Received: from szxga05-in.huawei.com ([45.249.212.191]:13525 "EHLO
        szxga05-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230062AbhCLLe2 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 12 Mar 2021 06:34:28 -0500
Received: from DGGEMS409-HUB.china.huawei.com (unknown [172.30.72.59])
        by szxga05-in.huawei.com (SkyGuard) with ESMTP id 4DxkDk5yxmzNlm9;
        Fri, 12 Mar 2021 19:32:06 +0800 (CST)
Received: from [10.174.184.135] (10.174.184.135) by
 DGGEMS409-HUB.china.huawei.com (10.3.19.209) with Microsoft SMTP Server id
 14.3.498.0; Fri, 12 Mar 2021 19:34:18 +0800
Subject: Re: [PATCH v3 3/4] KVM: arm64: GICv4.1: Restore VLPI's pending state
 to physical side
To:     Marc Zyngier <maz@kernel.org>
CC:     Eric Auger <eric.auger@redhat.com>, Will Deacon <will@kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        <kvmarm@lists.cs.columbia.edu>, <kvm@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>,
        Alex Williamson <alex.williamson@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        "Lorenzo Pieralisi" <lorenzo.pieralisi@arm.com>,
        <wanghaibin.wang@huawei.com>, <yuzenghui@huawei.com>
References: <20210127121337.1092-1-lushenming@huawei.com>
 <20210127121337.1092-4-lushenming@huawei.com> <87tupif3x3.wl-maz@kernel.org>
 <0820f429-4c29-acd6-d9e0-af9f6deb68e4@huawei.com>
 <87k0qcg2s6.wl-maz@kernel.org>
 <aecfbf72-c653-e967-b539-89f629b52cde@huawei.com>
 <87h7lgfwzu.wl-maz@kernel.org>
From:   Shenming Lu <lushenming@huawei.com>
Message-ID: <df4b939d-27c1-be84-ea7e-327251958cde@huawei.com>
Date:   Fri, 12 Mar 2021 19:34:07 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.2.2
MIME-Version: 1.0
In-Reply-To: <87h7lgfwzu.wl-maz@kernel.org>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.174.184.135]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 2021/3/12 19:10, Marc Zyngier wrote:
> On Fri, 12 Mar 2021 10:48:29 +0000,
> Shenming Lu <lushenming@huawei.com> wrote:
>>
>> On 2021/3/12 17:05, Marc Zyngier wrote:
>>> On Thu, 11 Mar 2021 12:32:07 +0000,
>>> Shenming Lu <lushenming@huawei.com> wrote:
>>>>
>>>> On 2021/3/11 17:14, Marc Zyngier wrote:
>>>>> On Wed, 27 Jan 2021 12:13:36 +0000,
>>>>> Shenming Lu <lushenming@huawei.com> wrote:
>>>>>>
>>>>>> From: Zenghui Yu <yuzenghui@huawei.com>
>>>>>>
>>>>>> When setting the forwarding path of a VLPI (switch to the HW mode),
>>>>>> we could also transfer the pending state from irq->pending_latch to
>>>>>> VPT (especially in migration, the pending states of VLPIs are restored
>>>>>> into kvm’s vgic first). And we currently send "INT+VSYNC" to trigger
>>>>>> a VLPI to pending.
>>>>>>
>>>>>> Signed-off-by: Zenghui Yu <yuzenghui@huawei.com>
>>>>>> Signed-off-by: Shenming Lu <lushenming@huawei.com>
>>>>>> ---
>>>>>>  arch/arm64/kvm/vgic/vgic-v4.c | 14 ++++++++++++++
>>>>>>  1 file changed, 14 insertions(+)
>>>>>>
>>>>>> diff --git a/arch/arm64/kvm/vgic/vgic-v4.c b/arch/arm64/kvm/vgic/vgic-v4.c
>>>>>> index ac029ba3d337..a3542af6f04a 100644
>>>>>> --- a/arch/arm64/kvm/vgic/vgic-v4.c
>>>>>> +++ b/arch/arm64/kvm/vgic/vgic-v4.c
>>>>>> @@ -449,6 +449,20 @@ int kvm_vgic_v4_set_forwarding(struct kvm *kvm, int virq,
>>>>>>  	irq->host_irq	= virq;
>>>>>>  	atomic_inc(&map.vpe->vlpi_count);
>>>>>>  
>>>>>> +	/* Transfer pending state */
>>>>>> +	if (irq->pending_latch) {
>>>>>> +		ret = irq_set_irqchip_state(irq->host_irq,
>>>>>> +					    IRQCHIP_STATE_PENDING,
>>>>>> +					    irq->pending_latch);
>>>>>> +		WARN_RATELIMIT(ret, "IRQ %d", irq->host_irq);
>>>>>> +
>>>>>> +		/*
>>>>>> +		 * Let it be pruned from ap_list later and don't bother
>>>>>> +		 * the List Register.
>>>>>> +		 */
>>>>>> +		irq->pending_latch = false;
>>>>>
>>>>> NAK. If the interrupt is on the AP list, it must be pruned from it
>>>>> *immediately*. The only case where it can be !pending and still on the
>>>>> AP list is in interval between sync and prune. If we start messing
>>>>> with this, we can't reason about the state of this list anymore.
>>>>>
>>>>> Consider calling vgic_queue_irq_unlock() here.
>>>>
>>>> Thanks for giving a hint, but it seems that vgic_queue_irq_unlock() only
>>>> queues an IRQ after checking, did you mean vgic_prune_ap_list() instead?
>>>
>>> No, I really mean vgic_queue_irq_unlock(). It can be used to remove
>>> the pending state from an interrupt, and drop it from the AP
>>> list. This is exactly what happens when clearing the pending state of
>>> a level interrupt, for example.
>>
>> Hi, I have gone through vgic_queue_irq_unlock more than once, but
>> still can't find the place in it to drop an IRQ from the AP
>> list... Did I miss something ?...  Or could you help to point it
>> out? Thanks very much for this!
> 
> NO, you are right. I think this is a missing optimisation. Please call
> the function anyway, as that's what is required to communicate a
> change of state in general.>
> I'll have a think about it.

Maybe we could call vgic_prune_ap_list() if (irq->vcpu && !vgic_target_oracle(irq)) in vgic_queue_irq_unlock()...

OK, I will retest this series and send a v4 soon. :-)

Thanks,
Shenming

> 
> Thanks,
> 
> 	M.
> 
