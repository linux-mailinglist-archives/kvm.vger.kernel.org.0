Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 99B92164152
	for <lists+kvm@lfdr.de>; Wed, 19 Feb 2020 11:18:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726548AbgBSKSx (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 19 Feb 2020 05:18:53 -0500
Received: from foss.arm.com ([217.140.110.172]:45468 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726210AbgBSKSx (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 19 Feb 2020 05:18:53 -0500
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id B2B341FB;
        Wed, 19 Feb 2020 02:18:52 -0800 (PST)
Received: from [172.16.1.159] (unknown [172.31.20.19])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 1E9F33F6CF;
        Wed, 19 Feb 2020 02:18:50 -0800 (PST)
Subject: Re: [PATCH 3/5] kvm: arm64: Limit PMU version to ARMv8.1
To:     Marc Zyngier <maz@kernel.org>
Cc:     linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        kvm@vger.kernel.org, Peter Maydell <peter.maydell@linaro.org>,
        Julien Thierry <julien.thierry.kdev@gmail.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>
References: <20200216185324.32596-1-maz@kernel.org>
 <20200216185324.32596-4-maz@kernel.org>
 <eb0294ef-5ad2-9940-2d59-b92220948ffc@arm.com>
 <c0a848e3ababff4ee9ecaa4b246d5875@kernel.org>
From:   James Morse <james.morse@arm.com>
Openpgp: preference=signencrypt
Message-ID: <ed7f31d5-9a2b-6ea0-85f8-74fcd7d9ac61@arm.com>
Date:   Wed, 19 Feb 2020 10:18:36 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <c0a848e3ababff4ee9ecaa4b246d5875@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Marc,

On 2/19/20 9:46 AM, Marc Zyngier wrote:
> On 2020-02-18 17:43, James Morse wrote:
>> Hi Marc,
>>
>> On 16/02/2020 18:53, Marc Zyngier wrote:
>>> Our PMU code is only implementing the ARMv8.1 features, so let's
>>> stick to this when reporting the feature set to the guest.
>>
>>> diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
>>> index 682fedd7700f..06b2d0dc6c73 100644
>>> --- a/arch/arm64/kvm/sys_regs.c
>>> +++ b/arch/arm64/kvm/sys_regs.c
>>> @@ -1093,6 +1093,11 @@ static u64 read_id_reg(const struct kvm_vcpu
>>> *vcpu,
>>>                   FEATURE(ID_AA64ISAR1_GPA) |
>>>                   FEATURE(ID_AA64ISAR1_GPI));
>>>          break;
>>> +    case SYS_ID_AA64DFR0_EL1:
>>> +        /* Limit PMU to ARMv8.1 */
>>
>> Not just limit, but upgrade too! (force?)
>> This looks safe because ARMV8_PMU_EVTYPE_EVENT always includes the
>> extra bits this added, and the register is always trapped.
> 
> That's definitely not what I intended! Let me fix that one.

What goes wrong?

The register description says to support v8.1 you need:
| Extended 16-bit PMEVTYPER<n>_EL0.evtCount field
| If EL2 is implemented, the MDCR_EL2.HPMD control bit

It looks like the extended PMEVTYPER would work via the emulation, and
EL2 guests are totally crazy.

Is the STALL_* bits in ARMv8.1-PMU the problem, ... or the extra work
for NV?


>> The PMU version is also readable via ID_DFR0_EL1.PerfMon, should that
>> be sanitised to be the same? (I don't think we've hidden an aarch64
>> feature that also existed in aarch32 before).
> 
> Indeed, yet another oversight. I'll fix that too.

(Weird variation in the aarch32 and aarch64 ID registers isn't something
I care about ... who would ever look at both?)



Thanks,

James
