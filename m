Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9412018C595
	for <lists+kvm@lfdr.de>; Fri, 20 Mar 2020 04:09:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726666AbgCTDI5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 19 Mar 2020 23:08:57 -0400
Received: from szxga05-in.huawei.com ([45.249.212.191]:12167 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726596AbgCTDI5 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 19 Mar 2020 23:08:57 -0400
Received: from DGGEMS403-HUB.china.huawei.com (unknown [172.30.72.59])
        by Forcepoint Email with ESMTP id 7D6D63D2899F173E72D0;
        Fri, 20 Mar 2020 11:08:52 +0800 (CST)
Received: from [127.0.0.1] (10.173.222.27) by DGGEMS403-HUB.china.huawei.com
 (10.3.19.203) with Microsoft SMTP Server id 14.3.487.0; Fri, 20 Mar 2020
 11:08:42 +0800
Subject: Re: [PATCH v5 20/23] KVM: arm64: GICv4.1: Plumb SGI implementation
 selection in the distributor
To:     Auger Eric <eric.auger@redhat.com>, Marc Zyngier <maz@kernel.org>
CC:     <linux-arm-kernel@lists.infradead.org>,
        <kvmarm@lists.cs.columbia.edu>, <kvm@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>,
        Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>,
        Jason Cooper <jason@lakedaemon.net>,
        "Robert Richter" <rrichter@marvell.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        "James Morse" <james.morse@arm.com>,
        Julien Thierry <julien.thierry.kdev@gmail.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>
References: <20200304203330.4967-1-maz@kernel.org>
 <20200304203330.4967-21-maz@kernel.org>
 <72832f51-bbde-8502-3e03-189ac20a0143@huawei.com>
 <4a06fae9c93e10351276d173747d17f4@kernel.org>
 <49995ec9-3970-1f62-5dfc-118563ca00fc@redhat.com>
From:   Zenghui Yu <yuzenghui@huawei.com>
Message-ID: <b98855a1-6300-d323-80f6-82d3b9854290@huawei.com>
Date:   Fri, 20 Mar 2020 11:08:39 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.0
MIME-Version: 1.0
In-Reply-To: <49995ec9-3970-1f62-5dfc-118563ca00fc@redhat.com>
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.173.222.27]
X-CFilter-Loop: Reflected
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 2020/3/20 4:38, Auger Eric wrote:
> Hi Marc,
> On 3/19/20 1:10 PM, Marc Zyngier wrote:
>> Hi Zenghui,
>>
>> On 2020-03-18 06:34, Zenghui Yu wrote:
>>> Hi Marc,
>>>
>>> On 2020/3/5 4:33, Marc Zyngier wrote:
>>>> The GICv4.1 architecture gives the hypervisor the option to let
>>>> the guest choose whether it wants the good old SGIs with an
>>>> active state, or the new, HW-based ones that do not have one.
>>>>
>>>> For this, plumb the configuration of SGIs into the GICv3 MMIO
>>>> handling, present the GICD_TYPER2.nASSGIcap to the guest,
>>>> and handle the GICD_CTLR.nASSGIreq setting.
>>>>
>>>> In order to be able to deal with the restore of a guest, also
>>>> apply the GICD_CTLR.nASSGIreq setting at first run so that we
>>>> can move the restored SGIs to the HW if that's what the guest
>>>> had selected in a previous life.
>>>
>>> I'm okay with the restore path.  But it seems that we still fail to
>>> save the pending state of vSGI - software pending_latch of HW-based
>>> vSGIs will not be updated (and always be false) because we directly
>>> inject them through ITS, so vgic_v3_uaccess_read_pending() can't
>>> tell the correct pending state to user-space (the correct one should
>>> be latched in HW).
>>>
>>> It would be good if we can sync the hardware state into pending_latch
>>> at an appropriate time (just before save), but not sure if we can...
>>
>> The problem is to find the "appropriate time". It would require to define
>> a point in the save sequence where we transition the state from HW to
>> SW. I'm not keen on adding more state than we already have.
> 
> may be we could use a dedicated device group/attr as we have for the ITS
> save tables? the user space would choose.

It means that userspace will be aware of some form of GICv4.1 details
(e.g., get/set vSGI state at HW level) that KVM has implemented.
Is it something that userspace required to know? I'm open to this ;-)

> 
> Thanks
> 
> Eric
>>
>> But what we can do is to just ask the HW to give us the right state
>> on userspace access, at all times. How about this:
>>
>> diff --git a/virt/kvm/arm/vgic/vgic-mmio-v3.c
>> b/virt/kvm/arm/vgic/vgic-mmio-v3.c
>> index 48fd9fc229a2..281fe7216c59 100644
>> --- a/virt/kvm/arm/vgic/vgic-mmio-v3.c
>> +++ b/virt/kvm/arm/vgic/vgic-mmio-v3.c
>> @@ -305,8 +305,18 @@ static unsigned long
>> vgic_v3_uaccess_read_pending(struct kvm_vcpu *vcpu,
>>        */
>>       for (i = 0; i < len * 8; i++) {
>>           struct vgic_irq *irq = vgic_get_irq(vcpu->kvm, vcpu, intid + i);
>> +        bool state = irq->pending_latch;
>>
>> -        if (irq->pending_latch)
>> +        if (irq->hw && vgic_irq_is_sgi(irq->intid)) {
>> +            int err;
>> +
>> +            err = irq_get_irqchip_state(irq->host_irq,
>> +                            IRQCHIP_STATE_PENDING,
>> +                            &state);
>> +            WARN_ON(err);
>> +        }
>> +
>> +        if (state)
>>               value |= (1U << i);
>>
>>           vgic_put_irq(vcpu->kvm, irq);

Anyway this looks good to me and will do the right thing on a userspace
save.

>>
>> I can add this to "KVM: arm64: GICv4.1: Add direct injection capability
>> to SGI registers".

Thanks,
Zenghui

