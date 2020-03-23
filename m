Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8728118F0AB
	for <lists+kvm@lfdr.de>; Mon, 23 Mar 2020 09:11:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727513AbgCWILT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 23 Mar 2020 04:11:19 -0400
Received: from szxga07-in.huawei.com ([45.249.212.35]:35004 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727422AbgCWILT (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 23 Mar 2020 04:11:19 -0400
Received: from DGGEMS403-HUB.china.huawei.com (unknown [172.30.72.60])
        by Forcepoint Email with ESMTP id CDDB242FB3B17C38F76B;
        Mon, 23 Mar 2020 16:11:09 +0800 (CST)
Received: from [127.0.0.1] (10.173.222.27) by DGGEMS403-HUB.china.huawei.com
 (10.3.19.203) with Microsoft SMTP Server id 14.3.487.0; Mon, 23 Mar 2020
 16:11:02 +0800
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
From:   Zenghui Yu <yuzenghui@huawei.com>
Message-ID: <cf5d7cf3-076f-47a7-83cf-717a619dc13e@huawei.com>
Date:   Mon, 23 Mar 2020 16:11:00 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.0
MIME-Version: 1.0
In-Reply-To: <256b58a9679412c96600217f316f424f@kernel.org>
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

On 2020/3/20 17:01, Marc Zyngier wrote:
> Hi Zenghui,
> 
> On 2020-03-20 03:53, Zenghui Yu wrote:
>> Hi Marc,
>>
>> On 2020/3/19 20:10, Marc Zyngier wrote:
>>>> But I wonder that should we use nassgireq to *only* keep track what
>>>> the guest had written into the GICD_CTLR.nASSGIreq.  If not, we may
>>>> lose the guest-request bit after migration among hosts with different
>>>> has_gicv4_1 settings.
>>>
>>> I'm unsure of what you're suggesting here. If userspace tries to set
>>> GICD_CTLR.nASSGIreq on a non-4.1 host, this bit will not latch.
>>
>> This is exactly what I *was* concerning about.
>>
>>> Userspace can check that at restore time. Or we could fail the
>>> userspace write, which is a bit odd (the bit is otherwise RES0).
>>>
>>> Could you clarify your proposal?
>>
>> Let's assume two hosts below. 'has_gicv4_1' is true on host-A while
>> it is false on host-B because of lack of HW support or the kernel
>> parameter "kvm-arm.vgic_v4_enable=0".
>>
>> If we migrate guest through A->B->A, we may end-up lose the initial
>> guest-request "nASSGIreq=1" and don't use direct vSGI delivery for
>> this guest when it's migrated back to host-A.
> 
> My point above is that we shouldn't allow the A->B migration the first
> place, and fail it as quickly as possible. We don't know what the guest
> has observed in terms of GIC capability, and it may not have enabled the
> new flavour of SGIs just yet.

Indeed. I didn't realize it.

> 
>> This can be "fixed" by keep track of what guest had written into
>> nASSGIreq. And we need to evaluate the need for using direct vSGI
>> for a specified guest by 'has_gicv4_1 && nassgireq'.
> 
> It feels odd. It means we have more state than the HW normally has.
> I have an alternative proposal, see below.
> 
>> But if it's expected that "if userspace tries to set nASSGIreq on
>> a non-4.1 host, this bit will not latch", then this shouldn't be
>> a problem at all.
> 
> Well, that is the semantics of the RES0 bit. It applies from both
> guest and userspace.
> 
> And actually, maybe we can handle that pretty cheaply. If userspace
> tries to restore GICD_TYPER2 to a value that isn't what KVM can
> offer, we just return an error. Exactly like we do for GICD_IIDR.
> Hence the following patch:
> 
> diff --git a/virt/kvm/arm/vgic/vgic-mmio-v3.c 
> b/virt/kvm/arm/vgic/vgic-mmio-v3.c
> index 28b639fd1abc..e72dcc454247 100644
> --- a/virt/kvm/arm/vgic/vgic-mmio-v3.c
> +++ b/virt/kvm/arm/vgic/vgic-mmio-v3.c
> @@ -156,6 +156,7 @@ static int vgic_mmio_uaccess_write_v3_misc(struct 
> kvm_vcpu *vcpu,
>       struct vgic_dist *dist = &vcpu->kvm->arch.vgic;
> 
>       switch (addr & 0x0c) {
> +    case GICD_TYPER2:
>       case GICD_IIDR:
>           if (val != vgic_mmio_read_v3_misc(vcpu, addr, len))
>               return -EINVAL;
> 
> Being a RO register, writing something that isn't compatible with the
> possible behaviour of the hypervisor will just return an error.

This is really a nice point to address my concern! I'm happy to see
this in v6 now.

> 
> What do you think?

I agreed with you, with a bit nervous though. Some old guests (which
have no knowledge about GICv4.1 vSGIs and don't care about nASSGIcap
at all) will also fail to migrate from A to B, just because now we
present two different (unused) GICD_TYPER2 registers to them.

Is it a little unfair to them :-) ?


Thanks,
Zenghui

