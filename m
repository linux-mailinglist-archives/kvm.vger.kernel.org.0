Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F3B002D25CC
	for <lists+kvm@lfdr.de>; Tue,  8 Dec 2020 09:26:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728089AbgLHI0C (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 8 Dec 2020 03:26:02 -0500
Received: from szxga05-in.huawei.com ([45.249.212.191]:9033 "EHLO
        szxga05-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727983AbgLHI0C (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 8 Dec 2020 03:26:02 -0500
Received: from DGGEMS402-HUB.china.huawei.com (unknown [172.30.72.59])
        by szxga05-in.huawei.com (SkyGuard) with ESMTP id 4CqtX05LC1zhpDC;
        Tue,  8 Dec 2020 16:24:48 +0800 (CST)
Received: from [10.174.187.47] (10.174.187.47) by
 DGGEMS402-HUB.china.huawei.com (10.3.19.202) with Microsoft SMTP Server id
 14.3.487.0; Tue, 8 Dec 2020 16:25:13 +0800
Subject: Re: [RFC PATCH v1 3/4] KVM: arm64: GICv4.1: Restore VLPI's pending
 state to physical side
From:   Shenming Lu <lushenming@huawei.com>
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
        <wanghaibin.wang@huawei.com>, <yuzenghui@huawei.com>,
        Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>
References: <20201123065410.1915-1-lushenming@huawei.com>
 <20201123065410.1915-4-lushenming@huawei.com>
 <5c724bb83730cdd5dcf7add9a812fa92@kernel.org>
 <b03edcf2-2950-572f-fd31-601d8d766c80@huawei.com>
 <2d2bcae4f871d239a1af50362f5c11a4@kernel.org>
 <49610291-cf57-ff78-d0ac-063af24efbb4@huawei.com>
 <48c10467-30f3-9b5c-bbcb-533a51516dc5@huawei.com>
 <2ad38077300bdcaedd2e3b073cd36743@kernel.org>
 <9b80d460-e149-20c8-e9b3-e695310b4ed1@huawei.com>
 <274dafb2e21f49326a64bb575e668793@kernel.org>
 <59ec07e5-c017-8644-b96f-e87fe600c490@huawei.com>
Message-ID: <77f60f4e-a832-97aa-7ec6-da9d596438b2@huawei.com>
Date:   Tue, 8 Dec 2020 16:25:12 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.2.2
MIME-Version: 1.0
In-Reply-To: <59ec07e5-c017-8644-b96f-e87fe600c490@huawei.com>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.174.187.47]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 2020/12/1 20:15, Shenming Lu wrote:
> On 2020/12/1 19:50, Marc Zyngier wrote:
>> On 2020-12-01 11:40, Shenming Lu wrote:
>>> On 2020/12/1 18:55, Marc Zyngier wrote:
>>>> On 2020-11-30 07:23, Shenming Lu wrote:
>>>>
>>>> Hi Shenming,
>>>>
>>>>> We are pondering over this problem these days, but still don't get a
>>>>> good solution...
>>>>> Could you give us some advice on this?
>>>>>
>>>>> Or could we move the restoring of the pending states (include the sync
>>>>> from guest RAM and the transfer to HW) to the GIC VM state change handler,
>>>>> which is completely corresponding to save_pending_tables (more symmetric?)
>>>>> and don't expose GICv4...
>>>>
>>>> What is "the GIC VM state change handler"? Is that a QEMU thing?
>>>
>>> Yeah, it is a a QEMU thing...
>>>
>>>> We don't really have that concept in KVM, so I'd appreciate if you could
>>>> be a bit more explicit on this.
>>>
>>> My thought is to add a new interface (to QEMU) for the restoring of
>>> the pending states, which is completely corresponding to
>>> KVM_DEV_ARM_VGIC_SAVE_PENDING_TABLES...
>>> And it is called from the GIC VM state change handler in QEMU, which
>>> is happening after the restoring (call kvm_vgic_v4_set_forwarding())
>>> but before the starting (running) of the VFIO device.
>>
>> Right, that makes sense. I still wonder how much the GIC save/restore
>> stuff differs from other architectures that implement similar features,
>> such as x86 with VT-D.
> 
> I am not familiar with it...
> 
>>
>> It is obviously too late to change the userspace interface, but I wonder
>> whether we missed something at the time.
> 
> The interface seems to be really asymmetrical?...
> 
> Or is there a possibility that we could know which irq is hw before the VFIO
> device calls kvm_vgic_v4_set_forwarding()?
> 
> Thanks,
> Shenming
> 
>>
>> Thanks,
>>
>>         M.
> .
> 

Hi Marc,

I am learning VT-d Posted Interrupt (PI) these days.

As far as I can tell, the posted interrupts are firstly recorded in the Posted
Interrupt Request (*PIR*) field of the Posted Interrupt Descriptor (a temporary
storage area (data structure in memory) which is specific to PI), and when the
vCPU is running, a notification event (host vector) will be generated and sent
to the CPU (the target vCPU is currently scheduled on it), which will cause the
CPU to transfer the posted interrupt in the PIR field to the *Virtual-APIC page*
(a data structure in kvm, the virtual interrupts delivered through kvm are put
here, and it is also accessed by the VMX microcode (the layout matches the register
layout seen by the guest)) of the vCPU and directly deliver it to the vCPU.

So they only have to sync the PIR field to the Virtual-APIC page for the migration
saving, and do nothing for the resuming...

Besides, on x86 the setting of the IRQ bypass is independent of the VM interrupt
setup...

Not sure if I have missed something.

In addition, I found that the enabling of the vAPIC is at the end of the migration
(just before the VM start) on x86. So I am wondering if we could move the calling
of *vgic_enable_lpis()* back, and transfer the pending state to the VPT there if the
irq is hw (and I think the semantics of this function should include the transfer).
In fact, this function is dependent on the restoring of the vgic(lpi_list)...

After exploration, there seems to be no perfect place to transfer the pending states
to HW in order to be compatible with the existing interface and under the current
architecture, but we have to choose one solution?

Thanks,
Shenming
