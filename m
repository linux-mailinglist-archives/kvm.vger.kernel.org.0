Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 43B761755AE
	for <lists+kvm@lfdr.de>; Mon,  2 Mar 2020 09:18:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727833AbgCBISZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 2 Mar 2020 03:18:25 -0500
Received: from szxga07-in.huawei.com ([45.249.212.35]:56506 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727806AbgCBISY (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 2 Mar 2020 03:18:24 -0500
Received: from DGGEMS405-HUB.china.huawei.com (unknown [172.30.72.59])
        by Forcepoint Email with ESMTP id BEDB48D133E4FD5F10B3;
        Mon,  2 Mar 2020 16:18:17 +0800 (CST)
Received: from [127.0.0.1] (10.173.222.27) by DGGEMS405-HUB.china.huawei.com
 (10.3.19.205) with Microsoft SMTP Server id 14.3.439.0; Mon, 2 Mar 2020
 16:18:09 +0800
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
 <3d725ede-6631-59fb-1a10-9fb9890f3df6@huawei.com>
 <dd9f1224b3b21ad793862406bd8855ba@kernel.org>
 <54c52057161f925c818446953050c951@kernel.org>
From:   Zenghui Yu <yuzenghui@huawei.com>
Message-ID: <4f8f3958-2976-b0a7-8d17-440ecaba0fc8@huawei.com>
Date:   Mon, 2 Mar 2020 16:18:07 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.0
MIME-Version: 1.0
In-Reply-To: <54c52057161f925c818446953050c951@kernel.org>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.173.222.27]
X-CFilter-Loop: Reflected
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 2020/3/2 3:00, Marc Zyngier wrote:
> On 2020-02-28 19:37, Marc Zyngier wrote:
>> On 2020-02-20 03:11, Zenghui Yu wrote:
> 
>>> Do we really need to grab the vpe_lock for those which are belong to
>>> the same irqchip with its_vpe_set_affinity()? The IRQ core code should
>>> already ensure the mutual exclusion among them, wrong?
>>
>> I've been trying to think about that, but jet-lag keeps getting in the 
>> way.
>> I empirically think that you are right, but I need to go and check the 
>> various
>> code paths to be sure. Hopefully I'll have a bit more brain space next 
>> week.
> 
> So I slept on it and came back to my senses. The only case we actually need
> to deal with is when an affinity change impacts *another* interrupt.
> 
> There is only two instances of this issue:
> 
> - vLPIs have their *physical* affinity impacted by the affinity of the
>    vPE. Their virtual affinity is of course unchanged, but the physical
>    one becomes important with direct invalidation. Taking a per-VPE lock
>    in such context should address the issue.
> 
> - vSGIs have the exact same issue, plus the matter of requiring some
>    *extra* one when reading the pending state, which requires a RMW
>    on two different registers. This requires an extra per-RD lock.

Agreed with both!

> 
> My original patch was stupidly complex, and the irq_desc lock is
> perfectly enough to deal with anything that only affects the interrupt
> state itself.
> 
> GICv4 + direct invalidation for vLPIs breaks this by bypassing the
> serialization initially provided by the ITS, as the RD is completely
> out of band. The per-vPE lock brings back this serialization.
> 
> I've updated the branch, which seems to run OK on D05. I still need
> to run the usual tests on the FVP model though.

I have pulled the latest branch and it looks good to me, except for
one remaining concern:

GICR_INV{LPI, ALL}R + GICR_SYNCR can also be accessed concurrently
by multiple direct invalidation, should we also use the per-RD lock
to ensure mutual exclusion?  It looks not so harmful though, as this
will only increase one's polling time against the Busy bit (in my view).

But I point it out again for confirmation.


Thanks,
Zenghui

