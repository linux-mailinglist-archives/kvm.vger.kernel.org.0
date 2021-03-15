Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BCB7333AED8
	for <lists+kvm@lfdr.de>; Mon, 15 Mar 2021 10:31:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229664AbhCOJan (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 15 Mar 2021 05:30:43 -0400
Received: from mail.kernel.org ([198.145.29.99]:53698 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229490AbhCOJaM (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 15 Mar 2021 05:30:12 -0400
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org [51.254.78.96])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 98C0D64E74;
        Mon, 15 Mar 2021 09:30:08 +0000 (UTC)
Received: from disco-boy.misterjones.org ([51.254.78.96] helo=www.loen.fr)
        by disco-boy.misterjones.org with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
        (Exim 4.94)
        (envelope-from <maz@kernel.org>)
        id 1lLjY6-001cQC-Iq; Mon, 15 Mar 2021 09:30:06 +0000
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
 format=flowed
Content-Transfer-Encoding: 8bit
Date:   Mon, 15 Mar 2021 09:30:06 +0000
From:   Marc Zyngier <maz@kernel.org>
To:     Shenming Lu <lushenming@huawei.com>
Cc:     Eric Auger <eric.auger@redhat.com>, Will Deacon <will@kernel.org>,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Alex Williamson <alex.williamson@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>,
        wanghaibin.wang@huawei.com, yuzenghui@huawei.com
Subject: Re: [PATCH v4 5/6] KVM: arm64: GICv4.1: Restore VLPI pending state to
 physical side
In-Reply-To: <cd821431-52a7-d9a6-1468-8ce0c9446d85@huawei.com>
References: <20210313083900.234-1-lushenming@huawei.com>
 <20210313083900.234-6-lushenming@huawei.com>
 <d9047922808df340feca2f257cfb8a3d@kernel.org>
 <81fbadda-0489-ffc3-cb38-08e89871ec95@huawei.com>
 <b03ec1e5447024f9f990377e2c28e84f@kernel.org>
 <cd821431-52a7-d9a6-1468-8ce0c9446d85@huawei.com>
User-Agent: Roundcube Webmail/1.4.11
Message-ID: <4f37549dcc5d3dd59a92bc94f2f0b59b@kernel.org>
X-Sender: maz@kernel.org
X-SA-Exim-Connect-IP: 51.254.78.96
X-SA-Exim-Rcpt-To: lushenming@huawei.com, eric.auger@redhat.com, will@kernel.org, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, linux-kernel@vger.kernel.org, alex.williamson@redhat.com, cohuck@redhat.com, lorenzo.pieralisi@arm.com, wanghaibin.wang@huawei.com, yuzenghui@huawei.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 2021-03-15 09:25, Shenming Lu wrote:
> On 2021/3/15 17:20, Marc Zyngier wrote:
>> On 2021-03-15 09:11, Shenming Lu wrote:
>>> On 2021/3/15 16:30, Marc Zyngier wrote:
>>>> On 2021-03-13 08:38, Shenming Lu wrote:
>>>>> From: Zenghui Yu <yuzenghui@huawei.com>
>>>>> 
>>>>> When setting the forwarding path of a VLPI (switch to the HW mode),
>>>>> we can also transfer the pending state from irq->pending_latch to
>>>>> VPT (especially in migration, the pending states of VLPIs are 
>>>>> restored
>>>>> into kvm’s vgic first). And we currently send "INT+VSYNC" to 
>>>>> trigger
>>>>> a VLPI to pending.
>>>>> 
>>>>> Signed-off-by: Zenghui Yu <yuzenghui@huawei.com>
>>>>> Signed-off-by: Shenming Lu <lushenming@huawei.com>
>>>>> ---
>>>>>  arch/arm64/kvm/vgic/vgic-v4.c | 18 ++++++++++++++++++
>>>>>  1 file changed, 18 insertions(+)
>>>>> 
>>>>> diff --git a/arch/arm64/kvm/vgic/vgic-v4.c 
>>>>> b/arch/arm64/kvm/vgic/vgic-v4.c
>>>>> index ac029ba3d337..3b82ab80c2f3 100644
>>>>> --- a/arch/arm64/kvm/vgic/vgic-v4.c
>>>>> +++ b/arch/arm64/kvm/vgic/vgic-v4.c
>>>>> @@ -449,6 +449,24 @@ int kvm_vgic_v4_set_forwarding(struct kvm 
>>>>> *kvm, int virq,
>>>>>      irq->host_irq    = virq;
>>>>>      atomic_inc(&map.vpe->vlpi_count);
>>>>> 
>>>>> +    /* Transfer pending state */
>>>>> +    if (irq->pending_latch) {
>>>>> +        unsigned long flags;
>>>>> +
>>>>> +        ret = irq_set_irqchip_state(irq->host_irq,
>>>>> +                        IRQCHIP_STATE_PENDING,
>>>>> +                        irq->pending_latch);
>>>>> +        WARN_RATELIMIT(ret, "IRQ %d", irq->host_irq);
>>>>> +
>>>>> +        /*
>>>>> +         * Clear pending_latch and communicate this state
>>>>> +         * change via vgic_queue_irq_unlock.
>>>>> +         */
>>>>> +        raw_spin_lock_irqsave(&irq->irq_lock, flags);
>>>>> +        irq->pending_latch = false;
>>>>> +        vgic_queue_irq_unlock(kvm, irq, flags);
>>>>> +    }
>>>>> +
>>>>>  out:
>>>>>      mutex_unlock(&its->its_lock);
>>>>>      return ret;
>>>> 
>>>> The read side of the pending state isn't locked, but the write side 
>>>> is.
>>>> I'd rather you lock the whole sequence for peace of mind.
>>> 
>>> Did you mean to lock before emitting the mapping request, Or just 
>>> before reading
>>> the pending state?
>> 
>> Just before reading the pending state, so that we can't get a 
>> concurrent
>> modification of that state while we make the interrupt pending in the 
>> VPT
>> and clearing it in the emulation.
> 
> Get it. I will correct it right now.

Please hold off sending a new version for a few days. My inbox is 
exploding...

Thanks,

         M.
-- 
Jazz is not dead. It just smells funny...
