Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6C78130D9EE
	for <lists+kvm@lfdr.de>; Wed,  3 Feb 2021 13:42:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229962AbhBCMl3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 3 Feb 2021 07:41:29 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:29880 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229484AbhBCMlZ (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 3 Feb 2021 07:41:25 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1612355996;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=7I0Ccsfbksiom0KDSfGuPHiDPSZnaJLN1wCUx9nAHbU=;
        b=fp8BzVsJVMWkQyrLR9gEKiZ2yWwibxxGXKYz5jv2lrcI2TeMV9YcmUNVBcynzT8MD4aVni
        qMZiGg5I8ExARBHQGLKEIWQiu4+vUaeOhPvbCcoS3NiAJtSp7tHLO0Tu8Cprqa460yDtDJ
        7sEApdxuZORCIHaWEz9TBxgTXtdEboQ=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-576-wXH1N1duOtGpGOtTPjY5cg-1; Wed, 03 Feb 2021 07:39:52 -0500
X-MC-Unique: wXH1N1duOtGpGOtTPjY5cg-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id E54B419611C2;
        Wed,  3 Feb 2021 12:39:50 +0000 (UTC)
Received: from [10.36.113.43] (ovpn-113-43.ams2.redhat.com [10.36.113.43])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id AF0427770F;
        Wed,  3 Feb 2021 12:39:48 +0000 (UTC)
Subject: Re: [PATCH v2 6/7] KVM: arm64: Upgrade PMU support to ARMv8.4
To:     Marc Zyngier <maz@kernel.org>
Cc:     linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        kvm@vger.kernel.org, James Morse <james.morse@arm.com>,
        Julien Thierry <julien.thierry.kdev@gmail.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        kernel-team@android.com
References: <20210125122638.2947058-1-maz@kernel.org>
 <20210125122638.2947058-7-maz@kernel.org>
 <56041147-0bd8-dbb2-d1ca-550f3db7f05d@redhat.com>
 <adbdbfbcecb65a1eca21afa622679836@kernel.org>
 <7808bec4-2ac5-a36d-2960-b4b90574e0d2@redhat.com>
 <f6875f72511a69f9ac9a18ebf7698466@kernel.org>
From:   Auger Eric <eric.auger@redhat.com>
Message-ID: <d9f8b79a-74de-0058-aa14-4ed5ec3b6aab@redhat.com>
Date:   Wed, 3 Feb 2021 13:39:47 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <f6875f72511a69f9ac9a18ebf7698466@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi,

On 2/3/21 12:20 PM, Marc Zyngier wrote:
> On 2021-02-03 11:07, Auger Eric wrote:
>> Hi Marc,
>> On 2/3/21 11:36 AM, Marc Zyngier wrote:
>>> Hi Eric,
>>>
>>> On 2021-01-27 17:53, Auger Eric wrote:
>>>> Hi Marc,
>>>>
>>>> On 1/25/21 1:26 PM, Marc Zyngier wrote:
>>>>> Upgrading the PMU code from ARMv8.1 to ARMv8.4 turns out to be
>>>>> pretty easy. All that is required is support for PMMIR_EL1, which
>>>>> is read-only, and for which returning 0 is a valid option as long
>>>>> as we don't advertise STALL_SLOT as an implemented event.
>>>>>
>>>>> Let's just do that and adjust what we return to the guest.
>>>>>
>>>>> Signed-off-by: Marc Zyngier <maz@kernel.org>
>>>>> ---
>>>>>  arch/arm64/include/asm/sysreg.h |  3 +++
>>>>>  arch/arm64/kvm/pmu-emul.c       |  6 ++++++
>>>>>  arch/arm64/kvm/sys_regs.c       | 11 +++++++----
>>>>>  3 files changed, 16 insertions(+), 4 deletions(-)
>>>>>
>>>>> diff --git a/arch/arm64/include/asm/sysreg.h
>>>>> b/arch/arm64/include/asm/sysreg.h
>>>>> index 8b5e7e5c3cc8..2fb3f386588c 100644
>>>>> --- a/arch/arm64/include/asm/sysreg.h
>>>>> +++ b/arch/arm64/include/asm/sysreg.h
>>>>> @@ -846,7 +846,10 @@
>>>>>
>>>>>  #define ID_DFR0_PERFMON_SHIFT        24
>>>>>
>>>>> +#define ID_DFR0_PERFMON_8_0        0x3
>>>>>  #define ID_DFR0_PERFMON_8_1        0x4
>>>>> +#define ID_DFR0_PERFMON_8_4        0x5
>>>>> +#define ID_DFR0_PERFMON_8_5        0x6
>>>>>
>>>>>  #define ID_ISAR4_SWP_FRAC_SHIFT        28
>>>>>  #define ID_ISAR4_PSR_M_SHIFT        24
>>>>> diff --git a/arch/arm64/kvm/pmu-emul.c b/arch/arm64/kvm/pmu-emul.c
>>>>> index 398f6df1bbe4..72cd704a8368 100644
>>>>> --- a/arch/arm64/kvm/pmu-emul.c
>>>>> +++ b/arch/arm64/kvm/pmu-emul.c
>>>>> @@ -795,6 +795,12 @@ u64 kvm_pmu_get_pmceid(struct kvm_vcpu *vcpu,
>>>>> bool pmceid1)
>>>>>          base = 0;
>>>>>      } else {
>>>>>          val = read_sysreg(pmceid1_el0);
>>>>> +        /*
>>>>> +         * Don't advertise STALL_SLOT, as PMMIR_EL0 is handled
>>>>> +         * as RAZ
>>>>> +         */
>>>>> +        if (vcpu->kvm->arch.pmuver >= ID_AA64DFR0_PMUVER_8_4)
>>>>> +            val &= ~BIT_ULL(ARMV8_PMUV3_PERFCTR_STALL_SLOT - 32);
>>>> what about the STALL_SLOT_BACKEND and FRONTEND events then?
>>>
>>> Aren't these a mandatory ARMv8.1 feature? I don't see a reason to
>>> drop them.
>>
>> I understand the 3 are linked together.
>>
>> In D7.11 it is said
>> "
>> When any of the following common events are implemented, all three of
>> them are implemented:
>> 0x003D , STALL_SLOT_BACKEND, No operation sent for execution on a Slot
>> due to the backend,
>> 0x003E , STALL_SLOT_FRONTEND, No operation sent for execution on a Slot
>> due to the frontend.
>> 0x003F , STALL_SLOT, No operation sent for execution on a Slot.
>> "
> 
> They are linked in the sense that they report related events, but they
> don't have to be implemented in the same level of the architecure, if only
> because BACKEND/FRONTEND were introducedway before ARMv8.4.
> 
> What the architecture says is:
> 
> - For FEAT_PMUv3p1 (ARMv8.1):
>   "The STALL_FRONTEND and STALL_BACKEND events are required to be
>    implemented." (A2.4.1, DDI0487G.a)
OK
> 
> - For FEAT_PMUv3p4 (ARMv8.4):
>   "If FEAT_PMUv3p4 is implemented:
>    - If STALL_SLOT is not implemented, it is IMPLEMENTATION DEFINED
> whether the PMMIR System registers are implemented.
>    - If STALL_SLOT is implemented, then the PMMIR System registers are
> implemented." (D7-2873, DDI0487G.a)
> 
> So while BACKEND/FRONTEND are required in an ARMv8.4 implementation
> by virtue of being mandatory in ARMv8.1, STALL_SLOT isn't at any point.
But then how do you understand "When any of the following common events
are implemented, all three of them are implemented"?

Eric
> 
> Thanks,
> 
>          M.

