Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6701E3776BA
	for <lists+kvm@lfdr.de>; Sun,  9 May 2021 15:08:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229618AbhEINJC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 9 May 2021 09:09:02 -0400
Received: from szxga04-in.huawei.com ([45.249.212.190]:2730 "EHLO
        szxga04-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229590AbhEINJC (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 9 May 2021 09:09:02 -0400
Received: from DGGEMS402-HUB.china.huawei.com (unknown [172.30.72.58])
        by szxga04-in.huawei.com (SkyGuard) with ESMTP id 4FdPXh2SY9zmg9Q;
        Sun,  9 May 2021 21:04:36 +0800 (CST)
Received: from [10.174.185.179] (10.174.185.179) by
 DGGEMS402-HUB.china.huawei.com (10.3.19.202) with Microsoft SMTP Server id
 14.3.498.0; Sun, 9 May 2021 21:07:45 +0800
Subject: Re: [PATCH v2 03/11] KVM: arm64: Make kvm_skip_instr() and co private
 to HYP
To:     Marc Zyngier <maz@kernel.org>
CC:     <linux-arm-kernel@lists.infradead.org>,
        <kvmarm@lists.cs.columbia.edu>, <kvm@vger.kernel.org>,
        <kernel-team@android.com>, Will Deacon <will@kernel.org>,
        James Morse <james.morse@arm.com>,
        Julien Thierry <julien.thierry.kdev@gmail.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Andrew Scull <ascull@google.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Quentin Perret <qperret@google.com>,
        David Brazdil <dbrazdil@google.com>
References: <20201102164045.264512-1-maz@kernel.org>
 <20201102164045.264512-4-maz@kernel.org>
 <cef3517b-e66d-4d26-68a9-2d5fb433377c@huawei.com>
 <875yzxnn5w.wl-maz@kernel.org> <87zgx8mkwd.wl-maz@kernel.org>
 <db784fc8-3a52-49ff-0b75-83a1bbc81d98@huawei.com>
 <87o8doq6jy.wl-maz@kernel.org>
From:   Zenghui Yu <yuzenghui@huawei.com>
Message-ID: <78e0bc84-4b38-9d93-39a1-473ed8c7265b@huawei.com>
Date:   Sun, 9 May 2021 21:07:45 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.9.0
MIME-Version: 1.0
In-Reply-To: <87o8doq6jy.wl-maz@kernel.org>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.174.185.179]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 2021/5/6 22:29, Marc Zyngier wrote:
> On Thu, 06 May 2021 12:43:26 +0100,
> Zenghui Yu <yuzenghui@huawei.com> wrote:
>>
>> On 2021/5/6 14:33, Marc Zyngier wrote:
>>> On Wed, 05 May 2021 17:46:51 +0100,
>>> Marc Zyngier <maz@kernel.org> wrote:
>>>>
>>>> Hi Zenghui,
>>>>
>>>> On Wed, 05 May 2021 15:23:02 +0100,
>>>> Zenghui Yu <yuzenghui@huawei.com> wrote:
>>>>>
>>>>> Hi Marc,
>>>>>
>>>>> On 2020/11/3 0:40, Marc Zyngier wrote:
>>>>>> In an effort to remove the vcpu PC manipulations from EL1 on nVHE
>>>>>> systems, move kvm_skip_instr() to be HYP-specific. EL1's intent
>>>>>> to increment PC post emulation is now signalled via a flag in the
>>>>>> vcpu structure.
>>>>>>
>>>>>> Signed-off-by: Marc Zyngier <maz@kernel.org>
>>>>>
>>>>> [...]
>>>>>
>>>>>> @@ -133,6 +134,8 @@ static int __kvm_vcpu_run_vhe(struct kvm_vcpu *vcpu)
>>>>>>  	__load_guest_stage2(vcpu->arch.hw_mmu);
>>>>>>  	__activate_traps(vcpu);
>>>>>> +	__adjust_pc(vcpu);
>>>>>
>>>>> If the INCREMENT_PC flag was set (e.g., for WFx emulation) while we're
>>>>> handling PSCI CPU_ON call targetting this VCPU, the *target_pc* (aka
>>>>> entry point address, normally provided by the primary VCPU) will be
>>>>> unexpectedly incremented here. That's pretty bad, I think.
>>>>
>>>> How can you online a CPU using PSCI if that CPU is currently spinning
>>>> on a WFI? Or is that we have transitioned via userspace to perform the
>>>> vcpu reset? I can imagine it happening in that case.
>>
>> I hadn't tried to reset VCPU from userspace. That would be a much easier
>> way to reproduce this problem.
> 
> Then I don't understand how you end-up there. If the vcpu was in WFI,
> it wasn't off and PSCI_CPU_ON doesn't have any effect.

I'm sorry for the misleading words.

The reported problem (secondary vcpu entry point corruption) was noticed
after a guest reboot. On rebooting, all vcpus will go back to userspace,
either because of a vcpu PSCI_SYSTEM_RESET call (with a
KVM_SYSTEM_EVENT_RESET system event in result), or because of a pending
signal targetting the vcpu thread. Userspace (I used QEMU) will then
perform the vcpu reset using the KVM_ARM_VCPU_INIT ioctl, of course!

WFI is the last instruction executed by the secondary vcpu before
rebooting. Emulating it results in a PC-altering flag.

What I was going to say is that maybe we can reproduce this problem with
a much simpler userspace program (not QEMU, no reboot) -- perform vcpu
reset while the vcpu is concurrently executing WFI, and see if the
result PC is set to 0 (per the KVM_ARM_VCPU_INIT doc). Maybe we can
achieve it with a kvm selftest case but "I hadn't tried", which turned
out to be misleading.

I'll have a look at your branch.


Thanks,
Zenghui
