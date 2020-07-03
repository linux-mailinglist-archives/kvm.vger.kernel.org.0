Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D61D1213240
	for <lists+kvm@lfdr.de>; Fri,  3 Jul 2020 05:39:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726151AbgGCDj2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 2 Jul 2020 23:39:28 -0400
Received: from szxga06-in.huawei.com ([45.249.212.32]:47692 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725937AbgGCDj2 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 2 Jul 2020 23:39:28 -0400
Received: from DGGEMS414-HUB.china.huawei.com (unknown [172.30.72.60])
        by Forcepoint Email with ESMTP id E3CDB7BB1C4195A30671;
        Fri,  3 Jul 2020 11:39:21 +0800 (CST)
Received: from [127.0.0.1] (10.174.187.42) by DGGEMS414-HUB.china.huawei.com
 (10.3.19.214) with Microsoft SMTP Server id 14.3.487.0; Fri, 3 Jul 2020
 11:39:11 +0800
Subject: Re: [kvm-unit-tests PATCH v2 3/8] arm64: microbench: gic: Add gicv4.1
 support for ipi latency test.
To:     Auger Eric <eric.auger@redhat.com>, Marc Zyngier <maz@kernel.org>
CC:     <drjones@redhat.com>, <kvm@vger.kernel.org>,
        <kvmarm@lists.cs.columbia.edu>, <wanghaibin.wang@huawei.com>,
        <yuzenghui@huawei.com>
References: <20200702030132.20252-1-wangjingyi11@huawei.com>
 <20200702030132.20252-4-wangjingyi11@huawei.com>
 <087ef371-5e7b-e0b2-900f-67b2eacb4e0f@redhat.com>
 <05a3da5fa35568606e55eb6428ce91d8@kernel.org>
 <69a37427-7e93-3411-f61c-50525a0ca3e1@redhat.com>
From:   Jingyi Wang <wangjingyi11@huawei.com>
Message-ID: <2a50fc3a-c3d1-0fc9-dccc-d878ce0a7bb5@huawei.com>
Date:   Fri, 3 Jul 2020 11:39:10 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:68.0) Gecko/20100101
 Thunderbird/68.6.0
MIME-Version: 1.0
In-Reply-To: <69a37427-7e93-3411-f61c-50525a0ca3e1@redhat.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.174.187.42]
X-CFilter-Loop: Reflected
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 7/2/2020 9:42 PM, Auger Eric wrote:
> Hi Marc,
> 
> On 7/2/20 3:08 PM, Marc Zyngier wrote:
>> Hi Eric,
>>
>> On 2020-07-02 13:57, Auger Eric wrote:
>>> Hi Jingyi,
>>>
>>> On 7/2/20 5:01 AM, Jingyi Wang wrote:
>>>> If gicv4.1(sgi hardware injection) supported, we test ipi injection
>>>> via hw/sw way separately.
>>>>
>>>> Signed-off-by: Jingyi Wang <wangjingyi11@huawei.com>
>>>> ---
>>>>   arm/micro-bench.c    | 45 +++++++++++++++++++++++++++++++++++++++-----
>>>>   lib/arm/asm/gic-v3.h |  3 +++
>>>>   lib/arm/asm/gic.h    |  1 +
>>>>   3 files changed, 44 insertions(+), 5 deletions(-)
>>>>
>>>> diff --git a/arm/micro-bench.c b/arm/micro-bench.c
>>>> index fc4d356..80d8db3 100644
>>>> --- a/arm/micro-bench.c
>>>> +++ b/arm/micro-bench.c
>>>> @@ -91,9 +91,40 @@ static void gic_prep_common(void)
>>>>       assert(irq_ready);
>>>>   }
>>>>
>>>> -static void ipi_prep(void)
>>>> +static bool ipi_prep(void)
>>> Any reason why the bool returned value is preferred over the standard
>>> int?
>>>>   {
>>>> +    u32 val;
>>>> +
>>>> +    val = readl(vgic_dist_base + GICD_CTLR);
>>>> +    if (readl(vgic_dist_base + GICD_TYPER2) & GICD_TYPER2_nASSGIcap) {
>>>> +        val &= ~GICD_CTLR_ENABLE_G1A;
>>>> +        val &= ~GICD_CTLR_nASSGIreq;
>>>> +        writel(val, vgic_dist_base + GICD_CTLR);
>>>> +        val |= GICD_CTLR_ENABLE_G1A;
>>>> +        writel(val, vgic_dist_base + GICD_CTLR);
>>> Why do we need this G1A dance?
>>
>> Because it isn't legal to change the SGI behaviour when groups are enabled.
>> Yes, it is described in this bit of documentation nobody has access to.
> 
> OK thank you for the explanation. Jingyi, maybe add a comment to avoid
> the question again ;-)
> 
> Thanks
> 
> Eric

Okay, I will add a comment here in the next version.

Thanks,
Jingyi

>>
>> And this code needs to track RWP on disabling Group-1.
>>
>>          M.
> 
> 
> .
> 

