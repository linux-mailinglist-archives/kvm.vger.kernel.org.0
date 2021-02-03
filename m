Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4DBC530DB4F
	for <lists+kvm@lfdr.de>; Wed,  3 Feb 2021 14:30:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231567AbhBCN3q (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 3 Feb 2021 08:29:46 -0500
Received: from mail.kernel.org ([198.145.29.99]:37524 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230380AbhBCN3k (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 3 Feb 2021 08:29:40 -0500
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org [51.254.78.96])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 930A860295;
        Wed,  3 Feb 2021 13:28:58 +0000 (UTC)
Received: from disco-boy.misterjones.org ([51.254.78.96] helo=www.loen.fr)
        by disco-boy.misterjones.org with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
        (Exim 4.94)
        (envelope-from <maz@kernel.org>)
        id 1l7IDI-00BlHH-BW; Wed, 03 Feb 2021 13:28:56 +0000
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
 format=flowed
Content-Transfer-Encoding: 8bit
Date:   Wed, 03 Feb 2021 13:28:56 +0000
From:   Marc Zyngier <maz@kernel.org>
To:     Auger Eric <eric.auger@redhat.com>
Cc:     linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        kvm@vger.kernel.org, James Morse <james.morse@arm.com>,
        Julien Thierry <julien.thierry.kdev@gmail.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        kernel-team@android.com
Subject: Re: [PATCH v2 6/7] KVM: arm64: Upgrade PMU support to ARMv8.4
In-Reply-To: <d9f8b79a-74de-0058-aa14-4ed5ec3b6aab@redhat.com>
References: <20210125122638.2947058-1-maz@kernel.org>
 <20210125122638.2947058-7-maz@kernel.org>
 <56041147-0bd8-dbb2-d1ca-550f3db7f05d@redhat.com>
 <adbdbfbcecb65a1eca21afa622679836@kernel.org>
 <7808bec4-2ac5-a36d-2960-b4b90574e0d2@redhat.com>
 <f6875f72511a69f9ac9a18ebf7698466@kernel.org>
 <d9f8b79a-74de-0058-aa14-4ed5ec3b6aab@redhat.com>
User-Agent: Roundcube Webmail/1.4.10
Message-ID: <ac172223d388393004819e338728f45b@kernel.org>
X-Sender: maz@kernel.org
X-SA-Exim-Connect-IP: 51.254.78.96
X-SA-Exim-Rcpt-To: eric.auger@redhat.com, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, james.morse@arm.com, julien.thierry.kdev@gmail.com, suzuki.poulose@arm.com, alexandru.elisei@arm.com, kernel-team@android.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 2021-02-03 12:39, Auger Eric wrote:
> Hi,
> 
> On 2/3/21 12:20 PM, Marc Zyngier wrote:
>> On 2021-02-03 11:07, Auger Eric wrote:
>>> Hi Marc,
>>> On 2/3/21 11:36 AM, Marc Zyngier wrote:
>>>> Hi Eric,
>>>> 
>>>> On 2021-01-27 17:53, Auger Eric wrote:
>>>>> Hi Marc,
>>>>> 
>>>>> On 1/25/21 1:26 PM, Marc Zyngier wrote:
>>>>>> Upgrading the PMU code from ARMv8.1 to ARMv8.4 turns out to be
>>>>>> pretty easy. All that is required is support for PMMIR_EL1, which
>>>>>> is read-only, and for which returning 0 is a valid option as long
>>>>>> as we don't advertise STALL_SLOT as an implemented event.
>>>>>> 
>>>>>> Let's just do that and adjust what we return to the guest.
>>>>>> 
>>>>>> Signed-off-by: Marc Zyngier <maz@kernel.org>
>>>>>> ---
>>>>>>  arch/arm64/include/asm/sysreg.h |  3 +++
>>>>>>  arch/arm64/kvm/pmu-emul.c       |  6 ++++++
>>>>>>  arch/arm64/kvm/sys_regs.c       | 11 +++++++----
>>>>>>  3 files changed, 16 insertions(+), 4 deletions(-)
>>>>>> 
>>>>>> diff --git a/arch/arm64/include/asm/sysreg.h
>>>>>> b/arch/arm64/include/asm/sysreg.h
>>>>>> index 8b5e7e5c3cc8..2fb3f386588c 100644
>>>>>> --- a/arch/arm64/include/asm/sysreg.h
>>>>>> +++ b/arch/arm64/include/asm/sysreg.h
>>>>>> @@ -846,7 +846,10 @@
>>>>>> 
>>>>>>  #define ID_DFR0_PERFMON_SHIFT        24
>>>>>> 
>>>>>> +#define ID_DFR0_PERFMON_8_0        0x3
>>>>>>  #define ID_DFR0_PERFMON_8_1        0x4
>>>>>> +#define ID_DFR0_PERFMON_8_4        0x5
>>>>>> +#define ID_DFR0_PERFMON_8_5        0x6
>>>>>> 
>>>>>>  #define ID_ISAR4_SWP_FRAC_SHIFT        28
>>>>>>  #define ID_ISAR4_PSR_M_SHIFT        24
>>>>>> diff --git a/arch/arm64/kvm/pmu-emul.c b/arch/arm64/kvm/pmu-emul.c
>>>>>> index 398f6df1bbe4..72cd704a8368 100644
>>>>>> --- a/arch/arm64/kvm/pmu-emul.c
>>>>>> +++ b/arch/arm64/kvm/pmu-emul.c
>>>>>> @@ -795,6 +795,12 @@ u64 kvm_pmu_get_pmceid(struct kvm_vcpu *vcpu,
>>>>>> bool pmceid1)
>>>>>>          base = 0;
>>>>>>      } else {
>>>>>>          val = read_sysreg(pmceid1_el0);
>>>>>> +        /*
>>>>>> +         * Don't advertise STALL_SLOT, as PMMIR_EL0 is handled
>>>>>> +         * as RAZ
>>>>>> +         */
>>>>>> +        if (vcpu->kvm->arch.pmuver >= ID_AA64DFR0_PMUVER_8_4)
>>>>>> +            val &= ~BIT_ULL(ARMV8_PMUV3_PERFCTR_STALL_SLOT - 32);
>>>>> what about the STALL_SLOT_BACKEND and FRONTEND events then?
>>>> 
>>>> Aren't these a mandatory ARMv8.1 feature? I don't see a reason to
>>>> drop them.
>>> 
>>> I understand the 3 are linked together.
>>> 
>>> In D7.11 it is said
>>> "
>>> When any of the following common events are implemented, all three of
>>> them are implemented:
>>> 0x003D , STALL_SLOT_BACKEND, No operation sent for execution on a 
>>> Slot
>>> due to the backend,
>>> 0x003E , STALL_SLOT_FRONTEND, No operation sent for execution on a 
>>> Slot
>>> due to the frontend.
>>> 0x003F , STALL_SLOT, No operation sent for execution on a Slot.
>>> "
>> 
>> They are linked in the sense that they report related events, but they
>> don't have to be implemented in the same level of the architecure, if 
>> only
>> because BACKEND/FRONTEND were introducedway before ARMv8.4.
>> 
>> What the architecture says is:
>> 
>> - For FEAT_PMUv3p1 (ARMv8.1):
>>   "The STALL_FRONTEND and STALL_BACKEND events are required to be
>>    implemented." (A2.4.1, DDI0487G.a)
> OK
>> 
>> - For FEAT_PMUv3p4 (ARMv8.4):
>>   "If FEAT_PMUv3p4 is implemented:
>>    - If STALL_SLOT is not implemented, it is IMPLEMENTATION DEFINED
>> whether the PMMIR System registers are implemented.
>>    - If STALL_SLOT is implemented, then the PMMIR System registers are
>> implemented." (D7-2873, DDI0487G.a)
>> 
>> So while BACKEND/FRONTEND are required in an ARMv8.4 implementation
>> by virtue of being mandatory in ARMv8.1, STALL_SLOT isn't at any 
>> point.
> But then how do you understand "When any of the following common events
> are implemented, all three of them are implemented"?

I think that's wholly inconsistent, because it would mean that 
STALL_SLOT
isn't optional on ARMv8.4, and would make PMMIR mandatory.

I'm starting to think that dropping this patch may be the best thing to 
do...

Thanks,

         M.
-- 
Jazz is not dead. It just smells funny...
