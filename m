Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2F3FF25F1C4
	for <lists+kvm@lfdr.de>; Mon,  7 Sep 2020 04:48:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726318AbgIGCsj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 6 Sep 2020 22:48:39 -0400
Received: from szxga06-in.huawei.com ([45.249.212.32]:60770 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726213AbgIGCsh (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 6 Sep 2020 22:48:37 -0400
Received: from DGGEMS408-HUB.china.huawei.com (unknown [172.30.72.60])
        by Forcepoint Email with ESMTP id 58D119CDACDCB4858C94;
        Mon,  7 Sep 2020 10:48:35 +0800 (CST)
Received: from [10.174.187.22] (10.174.187.22) by
 DGGEMS408-HUB.china.huawei.com (10.3.19.208) with Microsoft SMTP Server id
 14.3.487.0; Mon, 7 Sep 2020 10:48:29 +0800
Subject: Re: [RFC PATCH 0/5] KVM: arm64: Add pvtime LPT support
To:     Steven Price <steven.price@arm.com>, Marc Zyngier <maz@kernel.org>
References: <20200817084110.2672-1-zhukeqian1@huawei.com>
 <8308f52e4c906cad710575724f9e3855@kernel.org>
 <f14cfd5b-c103-5d56-82fb-59d0371c6f21@arm.com> <87h7svm0o5.wl-maz@kernel.org>
 <75ce4c12-f0e3-32c4-604f-9745980022e0@arm.com>
CC:     <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        <kvmarm@lists.cs.columbia.edu>, <kvm@vger.kernel.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will@kernel.org>,
        James Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        <wanghaibin.wang@huawei.com>, <mark.rutland@arm.com>
From:   zhukeqian <zhukeqian1@huawei.com>
Message-ID: <fcebf287-d920-b917-a90b-a970893b050b@huawei.com>
Date:   Mon, 7 Sep 2020 10:48:28 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:45.0) Gecko/20100101
 Thunderbird/45.7.1
MIME-Version: 1.0
In-Reply-To: <75ce4c12-f0e3-32c4-604f-9745980022e0@arm.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.174.187.22]
X-CFilter-Loop: Reflected
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Marc and Steven,

On 2020/9/2 18:09, Steven Price wrote:
> Hi Marc,
> 
> Sorry for the slow response, I've been on holiday.
> 
> On 22/08/2020 11:31, Marc Zyngier wrote:
>> Hi Steven,
>>
>> On Wed, 19 Aug 2020 09:54:40 +0100,
>> Steven Price <steven.price@arm.com> wrote:
>>>
>>> On 18/08/2020 15:41, Marc Zyngier wrote:
>>>> On 2020-08-17 09:41, Keqian Zhu wrote:
> [...]
>>>>>
>>>>> Things need concern:
>>>>> 1. https://developer.arm.com/docs/den0057/a needs update.
>>>>
>>>> LPT was explicitly removed from the spec because it doesn't really
>>>> solve the problem, specially for the firmware: EFI knows
>>>> nothing about this, for example. How is it going to work?
>>>> Also, nobody was ever able to explain how this would work for
>>>> nested virt.
>>>>
>>>> ARMv8.4 and ARMv8.6 have the feature set that is required to solve
>>>> this problem without adding more PV to the kernel.
>>>
>>> Hi Marc,
>>>
>>> These are good points, however we do still have the situation that
>>> CPUs that don't have ARMv8.4/8.6 clearly cannot implement this. I
>>> presume the use-case Keqian is looking at predates the necessary
>>> support in the CPU - Keqian if you can provide more details on the
>>> architecture(s) involved that would be helpful.
>>
>> My take on this is that it is a fictional use case. In my experience,
>> migration happens across *identical* systems, and *any* difference
>> visible to guests will cause things to go wrong. Errata management
>> gets in the way, as usual (name *one* integration that isn't broken
>> one way or another!).
> 
> Keqian appears to have a use case - but obviously I don't know the details. I guess Keqian needs to convince you of that.
Sure, there is use case, but I'm very sorry that it's inconvenient to show the detail. Maybe cross-chip migration
will be supported by arm64 eventually, so I think use case is not a key problem.

> 
>> Allowing migration across heterogeneous hosts requires a solution to
>> the errata management problem, which everyone (including me) has
>> decided to ignore so far (and I claim that not having a constant timer
>> frequency exposed to guests is an architecture bug).
> 
> I agree - errata management needs to be solved before LPT. Between restricted subsets of hosts this doesn't seem impossible, but I guess we should stall LPT until a credible solution is proposed. I'm certainly not proposing one at the moment.
> 
>>> Nested virt is indeed more of an issue - we did have some ideas around
>>> using SDEI that never made it to the spec.
>>
>> SDEI? Sigh... Why would SDEI be useful for NV and not for !NV?
> 
> SDEI provides a way of injecting a synchronous exception on migration - although that certainly isn't the only possible mechanism. For NV we have the problem that a guest-guest may be running at the point of migration. However it's not practical for the host hypervisor to provide the necessary table directly to the guest-guest which means the guest-hypervisor must update the tables before the guest-guest is allowed to run on the new host. The only plausible route I could see for this is injecting a synchronous exception into the guest (per VCPU) to ensure any guest-guests running are exited at migration time.
> 
> !NV is easier because we don't have to worry about multiple levels of para-virtualisation.
> 
>>> However I would argue that the most pragmatic approach would be to
>>> not support the combination of nested virt and LPT. Hopefully that
>>> can wait until the counter scaling support is available and not
>>> require PV.
>>
>> And have yet another set of band aids that paper over the fact that we
>> can't get a consistent story on virtualization? No, thank you.
>>
>> NV is (IMHO) much more important than LPT as it has a chance of
>> getting used. LPT is just another tick box, and the fact that ARM is
>> ready to ignore sideline a decent portion of the architecture is a
>> clear sign that it hasn't been thought out.
> 
> Different people have different priorities. NV is definitely important for many people. LPT may also be important if you've already got a bunch of VMs running on machines and you want to be able to (gradually) replace them with newer hosts which happen to have a different clock frequency. Those VMs running now clearly aren't using NV.
> 
> However, I have to admit it's not me that has the use-case, so I'll leave it for others who might actually know the specifics to explain the details.
> 
>>> We are discussing (re-)releasing the spec with the LPT parts added. If
>>> you have fundamental objections then please me know.
>>
>> I do, see above. I'm stating that the use case doesn't really exist
>> given the state of the available HW and the fragmentation of the
>> architecture, and that ignoring the most important innovation in the
>> virtualization architecture since ARMv7 is at best short-sighted.
>>
>> Time scaling is just an instance of the errata management problem, and
>> that is the issue that needs solving. Papering over part of the
>> problem is not helping.
> 
> I fully agree - errata management is definitely the first step that needs solving. This is why I abandoned LPT originally because I don't have a generic solution and the testing I did involved really ugly hacks just to make the migration possible.
> 
> For now I propose we (again) park LPT until some progress has been made on errata management.
> 
> Thanks,
> 
> Steve
> .
As we have discussed, to support the vtimer part of cross-chip migration, we still face many problems.
Firstly, we have no complete solution to realize the basic functionality. For PV solution, LPT just handles
Linux kernel, other SW agents are not involved. For non-PV solution, ARMv8.4 ext and ARMv8.6 ext is not enough.
Besides the basic functionality, we should concern errata management and NV (I think this is not urgent).

Giving above, I agree with Steven that re-park LPT.

Thanks,
Keqian
