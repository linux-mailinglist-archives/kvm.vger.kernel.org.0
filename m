Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2966818F4D4
	for <lists+kvm@lfdr.de>; Mon, 23 Mar 2020 13:41:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727628AbgCWMk4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 23 Mar 2020 08:40:56 -0400
Received: from szxga05-in.huawei.com ([45.249.212.191]:12178 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727130AbgCWMk4 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 23 Mar 2020 08:40:56 -0400
Received: from DGGEMS406-HUB.china.huawei.com (unknown [172.30.72.58])
        by Forcepoint Email with ESMTP id 63E252ECE21C08DF8A96;
        Mon, 23 Mar 2020 20:40:18 +0800 (CST)
Received: from [127.0.0.1] (10.173.222.27) by DGGEMS406-HUB.china.huawei.com
 (10.3.19.206) with Microsoft SMTP Server id 14.3.487.0; Mon, 23 Mar 2020
 20:40:11 +0800
Subject: Re: [PATCH v5 20/23] KVM: arm64: GICv4.1: Plumb SGI implementation
 selection in the distributor
To:     Marc Zyngier <maz@kernel.org>
CC:     <linux-arm-kernel@lists.infradead.org>,
        <kvmarm@lists.cs.columbia.edu>, <kvm@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>,
        Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>,
        Jason Cooper <jason@lakedaemon.net>,
        "Robert Richter" <rrichter@marvell.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        "Eric Auger" <eric.auger@redhat.com>,
        James Morse <james.morse@arm.com>,
        "Julien Thierry" <julien.thierry.kdev@gmail.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>
References: <20200304203330.4967-1-maz@kernel.org>
 <20200304203330.4967-21-maz@kernel.org>
 <72832f51-bbde-8502-3e03-189ac20a0143@huawei.com>
 <4a06fae9c93e10351276d173747d17f4@kernel.org>
 <1c9fdfc8-bdb2-88b6-4bdc-2b9254dfa55c@huawei.com>
 <256b58a9679412c96600217f316f424f@kernel.org>
 <cf5d7cf3-076f-47a7-83cf-717a619dc13e@huawei.com>
 <1c10593ac5b75f37c6853fbc74daa481@kernel.org>
From:   Zenghui Yu <yuzenghui@huawei.com>
Message-ID: <49fedfb3-ea4a-a18b-f453-86f43be7f18f@huawei.com>
Date:   Mon, 23 Mar 2020 20:40:10 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.0
MIME-Version: 1.0
In-Reply-To: <1c10593ac5b75f37c6853fbc74daa481@kernel.org>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.173.222.27]
X-CFilter-Loop: Reflected
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Marc,

On 2020/3/23 16:25, Marc Zyngier wrote:
> Hi Zenghui,
> 
> [...]
> 
>>> And actually, maybe we can handle that pretty cheaply. If userspace
>>> tries to restore GICD_TYPER2 to a value that isn't what KVM can
>>> offer, we just return an error. Exactly like we do for GICD_IIDR.
>>> Hence the following patch:
>>>
>>> diff --git a/virt/kvm/arm/vgic/vgic-mmio-v3.c 
>>> b/virt/kvm/arm/vgic/vgic-mmio-v3.c
>>> index 28b639fd1abc..e72dcc454247 100644
>>> --- a/virt/kvm/arm/vgic/vgic-mmio-v3.c
>>> +++ b/virt/kvm/arm/vgic/vgic-mmio-v3.c
>>> @@ -156,6 +156,7 @@ static int vgic_mmio_uaccess_write_v3_misc(struct 
>>> kvm_vcpu *vcpu,
>>>       struct vgic_dist *dist = &vcpu->kvm->arch.vgic;
>>>
>>>       switch (addr & 0x0c) {
>>> +    case GICD_TYPER2:
>>>       case GICD_IIDR:
>>>           if (val != vgic_mmio_read_v3_misc(vcpu, addr, len))
>>>               return -EINVAL;
>>>
>>> Being a RO register, writing something that isn't compatible with the
>>> possible behaviour of the hypervisor will just return an error.
>>
>> This is really a nice point to address my concern! I'm happy to see
>> this in v6 now.
>>
>>>
>>> What do you think?
>>
>> I agreed with you, with a bit nervous though. Some old guests (which
>> have no knowledge about GICv4.1 vSGIs and don't care about nASSGIcap
>> at all) will also fail to migrate from A to B, just because now we
>> present two different (unused) GICD_TYPER2 registers to them.
>>
>> Is it a little unfair to them :-) ?
> 
> I never pretended to be fair! ;-)
> 
> I'm happy to prevent migrating from a v4.1 system (A) to a v4.0
> system (B). As soon as the guest has run, it isn't safe to do so
> (it may have read TYPER2, and now knows about vSGIs). We *could*
> track this and find ways to migrate this state as well, but it
> feels fragile.
> 
> Migrating from B to A is more appealing. It should be possible to
> do so without much difficulty (just check that the nASSGIcap bit
> is either 0 or equal to KVM's view of the capability).
> 
> But overall I seriously doubt we can easily migrate guests across
> very different HW. We've been talking about this for years, and
> we still don't have a good solution for it given the diversity
> of the ecosystem... :-/

Fair enough. Thanks for your detailed explanation!


Zenghui

