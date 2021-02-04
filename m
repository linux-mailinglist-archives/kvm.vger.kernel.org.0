Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7486730F335
	for <lists+kvm@lfdr.de>; Thu,  4 Feb 2021 13:33:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236036AbhBDMdN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 4 Feb 2021 07:33:13 -0500
Received: from foss.arm.com ([217.140.110.172]:57568 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236031AbhBDMdM (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 4 Feb 2021 07:33:12 -0500
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id D2CC4D6E;
        Thu,  4 Feb 2021 04:32:26 -0800 (PST)
Received: from [192.168.0.110] (unknown [172.31.20.19])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 9DB543F73B;
        Thu,  4 Feb 2021 04:32:25 -0800 (PST)
Subject: Re: [PATCH v2 6/7] KVM: arm64: Upgrade PMU support to ARMv8.4
To:     Marc Zyngier <maz@kernel.org>, Auger Eric <eric.auger@redhat.com>
Cc:     linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        kvm@vger.kernel.org, James Morse <james.morse@arm.com>,
        Julien Thierry <julien.thierry.kdev@gmail.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        kernel-team@android.com
References: <20210125122638.2947058-1-maz@kernel.org>
 <20210125122638.2947058-7-maz@kernel.org>
 <56041147-0bd8-dbb2-d1ca-550f3db7f05d@redhat.com>
 <adbdbfbcecb65a1eca21afa622679836@kernel.org>
 <7808bec4-2ac5-a36d-2960-b4b90574e0d2@redhat.com>
 <f6875f72511a69f9ac9a18ebf7698466@kernel.org>
 <d9f8b79a-74de-0058-aa14-4ed5ec3b6aab@redhat.com>
 <ac172223d388393004819e338728f45b@kernel.org>
From:   Alexandru Elisei <alexandru.elisei@arm.com>
Message-ID: <7134513d-bccf-923f-961a-08527cf77f8e@arm.com>
Date:   Thu, 4 Feb 2021 12:32:14 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.0
MIME-Version: 1.0
In-Reply-To: <ac172223d388393004819e338728f45b@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi,

On 2/3/21 1:28 PM, Marc Zyngier wrote:
> On 2021-02-03 12:39, Auger Eric wrote:
>> Hi,
>>
>> On 2/3/21 12:20 PM, Marc Zyngier wrote:
>>> On 2021-02-03 11:07, Auger Eric wrote:
>>>> Hi Marc,
>>>> On 2/3/21 11:36 AM, Marc Zyngier wrote:
>>>>> Hi Eric,
>>>>>
>>>>> On 2021-01-27 17:53, Auger Eric wrote:
>>>>>> Hi Marc,
>>>>>>
>>>>>> On 1/25/21 1:26 PM, Marc Zyngier wrote:
>>>>>>> Upgrading the PMU code from ARMv8.1 to ARMv8.4 turns out to be
>>>>>>> pretty easy. All that is required is support for PMMIR_EL1, which
>>>>>>> is read-only, and for which returning 0 is a valid option as long
>>>>>>> as we don't advertise STALL_SLOT as an implemented event.
>>>>>>>
>>>>>>> Let's just do that and adjust what we return to the guest.
>>>>>>>
>>>>>>> Signed-off-by: Marc Zyngier <maz@kernel.org>
>>>>>>> ---
>>>>>>>  arch/arm64/include/asm/sysreg.h |  3 +++
>>>>>>>  arch/arm64/kvm/pmu-emul.c       |  6 ++++++
>>>>>>>  arch/arm64/kvm/sys_regs.c       | 11 +++++++----
>>>>>>>  3 files changed, 16 insertions(+), 4 deletions(-)
>>>>>>>
>>>>>>> diff --git a/arch/arm64/include/asm/sysreg.h
>>>>>>> b/arch/arm64/include/asm/sysreg.h
>>>>>>> index 8b5e7e5c3cc8..2fb3f386588c 100644
>>>>>>> --- a/arch/arm64/include/asm/sysreg.h
>>>>>>> +++ b/arch/arm64/include/asm/sysreg.h
>>>>>>> @@ -846,7 +846,10 @@
>>>>>>>
>>>>>>>  #define ID_DFR0_PERFMON_SHIFT        24
>>>>>>>
>>>>>>> +#define ID_DFR0_PERFMON_8_0        0x3
>>>>>>>  #define ID_DFR0_PERFMON_8_1        0x4
>>>>>>> +#define ID_DFR0_PERFMON_8_4        0x5
>>>>>>> +#define ID_DFR0_PERFMON_8_5        0x6
>>>>>>>
>>>>>>>  #define ID_ISAR4_SWP_FRAC_SHIFT        28
>>>>>>>  #define ID_ISAR4_PSR_M_SHIFT        24
>>>>>>> diff --git a/arch/arm64/kvm/pmu-emul.c b/arch/arm64/kvm/pmu-emul.c
>>>>>>> index 398f6df1bbe4..72cd704a8368 100644
>>>>>>> --- a/arch/arm64/kvm/pmu-emul.c
>>>>>>> +++ b/arch/arm64/kvm/pmu-emul.c
>>>>>>> @@ -795,6 +795,12 @@ u64 kvm_pmu_get_pmceid(struct kvm_vcpu *vcpu,
>>>>>>> bool pmceid1)
>>>>>>>          base = 0;
>>>>>>>      } else {
>>>>>>>          val = read_sysreg(pmceid1_el0);
>>>>>>> +        /*
>>>>>>> +         * Don't advertise STALL_SLOT, as PMMIR_EL0 is handled
>>>>>>> +         * as RAZ
>>>>>>> +         */
>>>>>>> +        if (vcpu->kvm->arch.pmuver >= ID_AA64DFR0_PMUVER_8_4)
>>>>>>> +            val &= ~BIT_ULL(ARMV8_PMUV3_PERFCTR_STALL_SLOT - 32);
>>>>>> what about the STALL_SLOT_BACKEND and FRONTEND events then?
>>>>>
>>>>> Aren't these a mandatory ARMv8.1 feature? I don't see a reason to
>>>>> drop them.
>>>>
>>>> I understand the 3 are linked together.
>>>>
>>>> In D7.11 it is said
>>>> "
>>>> When any of the following common events are implemented, all three of
>>>> them are implemented:
>>>> 0x003D , STALL_SLOT_BACKEND, No operation sent for execution on a Slot
>>>> due to the backend,
>>>> 0x003E , STALL_SLOT_FRONTEND, No operation sent for execution on a Slot
>>>> due to the frontend.
>>>> 0x003F , STALL_SLOT, No operation sent for execution on a Slot.
>>>> "
>>>
>>> They are linked in the sense that they report related events, but they
>>> don't have to be implemented in the same level of the architecure, if only
>>> because BACKEND/FRONTEND were introducedway before ARMv8.4.
>>>
>>> What the architecture says is:
>>>
>>> - For FEAT_PMUv3p1 (ARMv8.1):
>>>   "The STALL_FRONTEND and STALL_BACKEND events are required to be
>>>    implemented." (A2.4.1, DDI0487G.a)
>> OK
>>>
>>> - For FEAT_PMUv3p4 (ARMv8.4):
>>>   "If FEAT_PMUv3p4 is implemented:
>>>    - If STALL_SLOT is not implemented, it is IMPLEMENTATION DEFINED
>>> whether the PMMIR System registers are implemented.
>>>    - If STALL_SLOT is implemented, then the PMMIR System registers are
>>> implemented." (D7-2873, DDI0487G.a)
>>>
>>> So while BACKEND/FRONTEND are required in an ARMv8.4 implementation
>>> by virtue of being mandatory in ARMv8.1, STALL_SLOT isn't at any point.
>> But then how do you understand "When any of the following common events
>> are implemented, all three of them are implemented"?
>
> I think that's wholly inconsistent, because it would mean that STALL_SLOT
> isn't optional on ARMv8.4, and would make PMMIR mandatory.

I think there's some confusion regarding the event names. From my reading of the
architecture, STALL != STALL_SLOT, STALL_BACKEND != STALL_SLOT_BACKEND,
STALL_FRONTEND != STALL_SLOT_FRONTEND.

STALL{, _BACKEND, _FRONTEND} count the number of CPU cycles where no instructions
are being executed on the PE (page D7-2872), STALL_SLOT{, _BACKEND, _FRONTEND}
count the number of slots where no instructions are being executed (page D7-2873).

STALL_{BACKEND, FRONTEND} are required by ARMv8.1-PMU (pages A2-76, D7-2913);
STALL is required by ARMv8.4-PMU (page D7-2914).

STALL_SLOT{, _BACKEND, _FRONTEND} are optional in ARMv8.4-PMU (pages D7-2913,
D7-2914), but if one of them is implemented, all of them must be implemented (page
D7-2914).

The problem I see with this patch is that it doesn't clear the
STALL_SLOT_{BACKEND, FRONTEND} event bits along with the STALL_SLOT bit from
PMCEID1_EL0.

Thanks

Alex

>
> I'm starting to think that dropping this patch may be the best thing to do...
>
> Thanks,
>
>         M.
