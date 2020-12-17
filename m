Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 417572DCBAB
	for <lists+kvm@lfdr.de>; Thu, 17 Dec 2020 05:22:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726199AbgLQEUb (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 16 Dec 2020 23:20:31 -0500
Received: from szxga04-in.huawei.com ([45.249.212.190]:9221 "EHLO
        szxga04-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726074AbgLQEUb (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 16 Dec 2020 23:20:31 -0500
Received: from DGGEMS409-HUB.china.huawei.com (unknown [172.30.72.59])
        by szxga04-in.huawei.com (SkyGuard) with ESMTP id 4CxJf46wsZzkr0L;
        Thu, 17 Dec 2020 12:18:52 +0800 (CST)
Received: from [10.174.187.231] (10.174.187.231) by
 DGGEMS409-HUB.china.huawei.com (10.3.19.209) with Microsoft SMTP Server id
 14.3.498.0; Thu, 17 Dec 2020 12:19:35 +0800
Subject: Re: [RFC PATCH v1 3/4] KVM: arm64: GICv4.1: Restore VLPI's pending
 state to physical side
To:     Auger Eric <eric.auger@redhat.com>, Marc Zyngier <maz@kernel.org>
CC:     James Morse <james.morse@arm.com>,
        Julien Thierry <julien.thierry.kdev@gmail.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        <linux-arm-kernel@lists.infradead.org>,
        <kvmarm@lists.cs.columbia.edu>, <kvm@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>,
        Christoffer Dall <christoffer.dall@arm.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Kirti Wankhede <kwankhede@nvidia.com>,
        Cornelia Huck <cohuck@redhat.com>, "Neo Jia" <cjia@nvidia.com>,
        <wanghaibin.wang@huawei.com>, <yuzenghui@huawei.com>
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
 <f8b398df-9945-9ce6-18e6-970637a1bb51@redhat.com>
From:   Shenming Lu <lushenming@huawei.com>
Message-ID: <5732e2a2-7b78-dcbe-bd7d-77541c7bcf16@huawei.com>
Date:   Thu, 17 Dec 2020 12:19:35 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.2.2
MIME-Version: 1.0
In-Reply-To: <f8b398df-9945-9ce6-18e6-970637a1bb51@redhat.com>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.174.187.231]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 2020/12/16 18:35, Auger Eric wrote:
> Hi Shenming,
> 
> On 12/1/20 1:15 PM, Shenming Lu wrote:
>> On 2020/12/1 19:50, Marc Zyngier wrote:
>>> On 2020-12-01 11:40, Shenming Lu wrote:
>>>> On 2020/12/1 18:55, Marc Zyngier wrote:
>>>>> On 2020-11-30 07:23, Shenming Lu wrote:
>>>>>
>>>>> Hi Shenming,
>>>>>
>>>>>> We are pondering over this problem these days, but still don't get a
>>>>>> good solution...
>>>>>> Could you give us some advice on this?
>>>>>>
>>>>>> Or could we move the restoring of the pending states (include the sync
>>>>>> from guest RAM and the transfer to HW) to the GIC VM state change handler,
>>>>>> which is completely corresponding to save_pending_tables (more symmetric?)
>>>>>> and don't expose GICv4...
>>>>>
>>>>> What is "the GIC VM state change handler"? Is that a QEMU thing?
>>>>
>>>> Yeah, it is a a QEMU thing...
>>>>
>>>>> We don't really have that concept in KVM, so I'd appreciate if you could
>>>>> be a bit more explicit on this.
>>>>
>>>> My thought is to add a new interface (to QEMU) for the restoring of
>>>> the pending states, which is completely corresponding to
>>>> KVM_DEV_ARM_VGIC_SAVE_PENDING_TABLES...
>>>> And it is called from the GIC VM state change handler in QEMU, which
>>>> is happening after the restoring (call kvm_vgic_v4_set_forwarding())
>>>> but before the starting (running) of the VFIO device.
>>>
>>> Right, that makes sense. I still wonder how much the GIC save/restore
>>> stuff differs from other architectures that implement similar features,
>>> such as x86 with VT-D.
>>
>> I am not familiar with it...
>>
>>>
>>> It is obviously too late to change the userspace interface, but I wonder
>>> whether we missed something at the time.
>>
>> The interface seems to be really asymmetrical?...
> 
> in qemu d5aa0c229a ("hw/intc/arm_gicv3_kvm: Implement pending table
> save") commit message, it is traced:
> 
> "There is no explicit restore as the tables are implicitly sync'ed
> on ITS table restore and on LPI enable at redistributor level."
> 
> At that time there was no real justification behind adding the RESTORE
> fellow attr.
> 
> Maybe a stupid question but isn't it possible to unset the forwarding
> when saving and rely on VFIO to automatically restore it when resuming
> on destination?

It seems that the unset_forwarding would not be called when saving, it would
be called after migration completion...
As for the resuming/set_forwarding, I still wonder: is it really improper to
transfer the pending states from vgic to VPT in set_forwarding (not only in
migration)?...  -_-

Thanks,
Shenming

> 
> Thanks
> 
> Eric
> 
> 
>>
>> Or is there a possibility that we could know which irq is hw before the VFIO
>> device calls kvm_vgic_v4_set_forwarding()?
>>
>> Thanks,
>> Shenming
>>
>>>
>>> Thanks,
>>>
>>>         M.
>>
> 
> .
> 
