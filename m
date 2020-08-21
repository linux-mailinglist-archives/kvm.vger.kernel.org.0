Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A02D524CBB9
	for <lists+kvm@lfdr.de>; Fri, 21 Aug 2020 05:54:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727793AbgHUDyd (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 20 Aug 2020 23:54:33 -0400
Received: from szxga04-in.huawei.com ([45.249.212.190]:10296 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727066AbgHUDyc (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 20 Aug 2020 23:54:32 -0400
Received: from DGGEMS404-HUB.china.huawei.com (unknown [172.30.72.59])
        by Forcepoint Email with ESMTP id 4D20C79887F5437BBDF7;
        Fri, 21 Aug 2020 11:54:29 +0800 (CST)
Received: from [10.174.187.22] (10.174.187.22) by
 DGGEMS404-HUB.china.huawei.com (10.3.19.204) with Microsoft SMTP Server id
 14.3.487.0; Fri, 21 Aug 2020 11:54:23 +0800
Subject: Re: [RFC PATCH 0/5] KVM: arm64: Add pvtime LPT support
To:     Steven Price <steven.price@arm.com>, Marc Zyngier <maz@kernel.org>
References: <20200817084110.2672-1-zhukeqian1@huawei.com>
 <8308f52e4c906cad710575724f9e3855@kernel.org>
 <f14cfd5b-c103-5d56-82fb-59d0371c6f21@arm.com>
CC:     <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        <kvmarm@lists.cs.columbia.edu>, <kvm@vger.kernel.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will@kernel.org>,
        James Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        <wanghaibin.wang@huawei.com>, <xiexiangyou@huawei.com>,
        <yebiaoxiang@huawei.com>
From:   zhukeqian <zhukeqian1@huawei.com>
Message-ID: <177a273d-3312-ec33-de0c-fd38b49f153b@huawei.com>
Date:   Fri, 21 Aug 2020 11:54:22 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:45.0) Gecko/20100101
 Thunderbird/45.7.1
MIME-Version: 1.0
In-Reply-To: <f14cfd5b-c103-5d56-82fb-59d0371c6f21@arm.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.174.187.22]
X-CFilter-Loop: Reflected
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 2020/8/19 16:54, Steven Price wrote:
> On 18/08/2020 15:41, Marc Zyngier wrote:
>> On 2020-08-17 09:41, Keqian Zhu wrote:
>>> Hi all,
>>>
>>> This patch series picks up the LPT pvtime feature originally developed
>>> by Steven Price: https://patchwork.kernel.org/cover/10726499/
>>>
>>> Backgroud:
>>>
>>> There is demand for cross-platform migration, which means we have to
>>> solve different CPU features and arch counter frequency between hosts.
>>> This patch series can solve the latter problem.
>>>
>>> About LPT:
>>>
>>> This implements support for Live Physical Time (LPT) which provides the
>>> guest with a method to derive a stable counter of time during which the
>>> guest is executing even when the guest is being migrated between hosts
>>> with different physical counter frequencies.
>>>
>>> Changes on Steven Price's work:
>>> 1. LPT structure: use symmatical semantics of scale multiplier, and use
>>>    fraction bits instead of "shift" to make everything clear.
>>> 2. Structure allocation: host kernel does not allocates the LPT structure,
>>>    instead it is allocated by userspace through VM attributes. The save/restore
>>>    functionality can be removed.
>>> 3. Since LPT structure just need update once for each guest run, add a flag to
>>>    indicate the update status. This has two benifits: 1) avoid multiple update
>>>    by each vCPUs. 2) If the update flag is not set, then return NOT SUPPORT for
>>>    coressponding guest HVC call.
>>> 4. Add VM device attributes interface for userspace configuration.
>>> 5. Add a base LPT read/write layer to reduce code.
>>> 6. Support ptimer scaling.
>>> 7. Support timer event stream translation.
>>>
>>> Things need concern:
>>> 1. https://developer.arm.com/docs/den0057/a needs update.
>>
>> LPT was explicitly removed from the spec because it doesn't really
>> solve the problem, specially for the firmware: EFI knows
>> nothing about this, for example. How is it going to work?
>> Also, nobody was ever able to explain how this would work for
>> nested virt.
>>
>> ARMv8.4 and ARMv8.6 have the feature set that is required to solve
>> this problem without adding more PV to the kernel.
> 
> Hi Marc,
> 
> These are good points, however we do still have the situation that CPUs that don't have ARMv8.4/8.6 clearly cannot implement this. I presume the use-case Keqian is looking at predates the necessary support in the CPU - Keqian if you can provide more details on the architecture(s) involved that would be helpful.
> 
> Nested virt is indeed more of an issue - we did have some ideas around using SDEI that never made it to the spec. However I would argue that the most pragmatic approach would be to not support the combination of nested virt and LPT. Hopefully that can wait until the counter scaling support is available and not require PV.
> 
> We are discussing (re-)releasing the spec with the LPT parts added. If you have fundamental objections then please me know.
> 
> Thanks,
> 
> Steve
> .
> 
Hi Marc and Steven,

In fact, I have realize a demo which utilize v8.6-ECV to present a constant timer freq to guest. It seems
work well, but this approach has some shortcoming:

1. Guest access to cntvct cntv_ctl cntv_tval cntv_cval must trap to EL2. Every trap will take about
   hundreds of nano-seconds. For every timer interrupt, there is about 5~6 traps, so it will spend
   several us (this seems not a serious problem :-) ). But trap will cause big deviation for nano-sleep.
2. We have to make cntfrq be a context of guest. However, only the highest exception level has right to
   modify cntfrq. It means we have to add a new SMC call.
3. cntkctl controls event stream freq, so KVM should also translate the guest access of cntkctl. However
   we cannot trap guest access of that. Any solution for this problem?

I think LPT as a software solution can solve these problems. However, as Marc said, UEFI knows nothing about
LPT, and it will access vtimer/counter directly. The key point is how serious the impact is on UEFI.

I can see that some UEFI runtime services and drivers/applications will access timer/counter.
For runtime services, it is OK. Because we can translate the result which return from UEFI for Linux.
For drivers/applications, they will feel time goes faster or slower after migration. This is a problem indeed :-)

Thanks,
Keqian
