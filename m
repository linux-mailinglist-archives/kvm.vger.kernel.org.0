Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D58051643B1
	for <lists+kvm@lfdr.de>; Wed, 19 Feb 2020 12:51:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727069AbgBSLvA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 19 Feb 2020 06:51:00 -0500
Received: from szxga07-in.huawei.com ([45.249.212.35]:34714 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726495AbgBSLu7 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 19 Feb 2020 06:50:59 -0500
Received: from DGGEMS402-HUB.china.huawei.com (unknown [172.30.72.58])
        by Forcepoint Email with ESMTP id 79B762677E22060FC49B;
        Wed, 19 Feb 2020 19:50:54 +0800 (CST)
Received: from [127.0.0.1] (10.173.222.27) by DGGEMS402-HUB.china.huawei.com
 (10.3.19.202) with Microsoft SMTP Server id 14.3.439.0; Wed, 19 Feb 2020
 19:50:47 +0800
Subject: Re: [PATCH v4 08/20] irqchip/gic-v4.1: Plumb get/set_irqchip_state
 SGI callbacks
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
References: <20200214145736.18550-1-maz@kernel.org>
 <20200214145736.18550-9-maz@kernel.org>
 <4b7f71f1-5e7f-e6af-f47d-7ed0d3a8739f@huawei.com>
 <75597af0d2373ac4d92d8162a1338cbb@kernel.org>
 <19a7c193f0e4b97343e822a35f0911ed@kernel.org>
From:   Zenghui Yu <yuzenghui@huawei.com>
Message-ID: <8db95a86-0981-710b-6c82-be7f7f844151@huawei.com>
Date:   Wed, 19 Feb 2020 19:50:45 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.0
MIME-Version: 1.0
In-Reply-To: <19a7c193f0e4b97343e822a35f0911ed@kernel.org>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.173.222.27]
X-CFilter-Loop: Reflected
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Marc,

On 2020/2/18 23:31, Marc Zyngier wrote:
> Hi Zenghui,
> 
> On 2020-02-18 09:27, Marc Zyngier wrote:
>> Hi Zenghui,
>>
>> On 2020-02-18 07:00, Zenghui Yu wrote:
>>> Hi Marc,
> 
> [...]
> 
>>> There might be a race on reading the 'vpe->col_idx' against a concurrent
>>> vPE schedule (col_idx will be modified in its_vpe_set_affinity)? Will we
>>> end up accessing the GICR_VSGI* registers of the old redistributor,
>>> while the vPE is now resident on the new one? Or is it harmful?
>>
>> Very well spotted. There is a potential problem if old and new RDs are 
>> not part
>> of the same CommonLPIAff group.
>>
>>> The same question for direct_lpi_inv(), where 'vpe->col_idx' will be
>>> used in irq_to_cpuid().
>>
>> Same problem indeed. We need to ensure that no VMOVP operation can 
>> occur whilst
>> we use col_idx to access a redistributor. This means a vPE lock of 
>> some sort
>> that will protect the affinity.

Yeah, I had the same view here, a vPE level lock might help.

>> But I think there is a slightly more general problem here, which we 
>> failed to
>> see initially: the same issue exists for physical LPIs, as col_map[] 
>> can be
>> updated (its_set_affinity()) in parallel with a direct invalidate.
>>
>> The good old invalidation through the ITS does guarantee that the two 
>> operation
>> don't overlap, but direct invalidation breaks it.

Agreed!

>> Let me have a think about it.
> 
> So I've thought about it, wrote a patch, and I don't really like the 
> look of it.
> This is pretty invasive, and we end-up serializing a lot more than we 
> used to
> (the repurposing of vlpi_lock to a general "lpi mapping lock" is 
> probably too
> coarse).
> 
> It of course needs splitting over at least three patches, but it'd be 
> good if
> you could have a look (applies on top of the whole series).

So the first thing is that

1. there're races on choosing the RD against a concurrent LPI/vPE
affinity changing.

And sure, I will have a look on the following patch! But I'd first
talk about some other issues I've seen today...

2. Another potential race is on accessing the same RD by different
CPUs, which gets more obvious after introducing the GICv4.1.
We can as least take two registers for example:

  - GICR_VSGIR:
    Let's assume that vPE0 is just descheduled from CPU0 and then vPE1
    is scheduled on. CPU0 is writing its GICR_VSGIR with vpeid1 to serve
    vPE1's GICR_ISPENDR0 read trap, whilst userspace is getting vSGI's
    pending state of vPE0 (i.e., by a debugfs read) thus another CPU
    will try to write the same GICR_VSGIR with vpeid0... without waiting
    GICR_VSGIPENDR.Busy reads as 0.
    This is a CONSTRAINED UNPREDICTABLE behavior from the spec and at
    least one of the queries will fail.
  - GICR_INV{LPI,ALL}R:
    Multiple LPIs can be targeted to the same RD, thus multiple writes to
    the same GICR_INVLPIR (with different INITID, even with different V)
    can happen concurrently...

Above comes from the fact that the same redistributor can be accessed
(concurrently) by multiple CPUs but we don't have a mechanism to ensure
some extent of serialization. I also had a look at how KVM will handle
this kind of access, but

3. it looks like KVM makes the assumption that the per-RD MMIO region
will only be accessed by the associated VCPU?  But I think this's not
restricted by the architecture, we can do it better.  Or I've just
missed some important points here.


I will look at the following patch asap but may need some time to
think about all above, and do some fix if possible :-)

> diff --git a/drivers/irqchip/irq-gic-v3-its.c 
> b/drivers/irqchip/irq-gic-v3-its.c
> index 7656b353a95f..0ed286dba827 100644
> --- a/drivers/irqchip/irq-gic-v3-its.c
> +++ b/drivers/irqchip/irq-gic-v3-its.c

[...]


Thanks,
Zenghui

