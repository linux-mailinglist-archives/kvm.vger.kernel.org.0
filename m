Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 159223CE25E
	for <lists+kvm@lfdr.de>; Mon, 19 Jul 2021 18:14:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348226AbhGSPaJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 19 Jul 2021 11:30:09 -0400
Received: from foss.arm.com ([217.140.110.172]:34952 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1347740AbhGSPUS (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 19 Jul 2021 11:20:18 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 9F8E51FB;
        Mon, 19 Jul 2021 09:00:55 -0700 (PDT)
Received: from [192.168.0.110] (unknown [172.31.20.19])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id B39FE3F73D;
        Mon, 19 Jul 2021 09:00:53 -0700 (PDT)
Subject: Re: [PATCH v2 1/4] KVM: arm64: Narrow PMU sysreg reset values to
 architectural requirements
To:     Marc Zyngier <maz@kernel.org>
Cc:     linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org,
        kvmarm@lists.cs.columbia.edu, James Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Alexandre Chartre <alexandre.chartre@oracle.com>,
        Robin Murphy <robin.murphy@arm.com>,
        Andrew Jones <drjones@redhat.com>,
        Russell King <linux@arm.linux.org.uk>, kernel-team@android.com,
        Russell King <rmk+kernel@armlinux.org.uk>
References: <20210719123902.1493805-1-maz@kernel.org>
 <20210719123902.1493805-2-maz@kernel.org>
 <171cca9d-2a6e-248c-8502-feba8ebbe55e@arm.com>
 <171834f3198b898d5c2aefa0270b65f2@kernel.org>
From:   Alexandru Elisei <alexandru.elisei@arm.com>
Message-ID: <482a40a8-d190-99d3-ec17-59ee730be0fa@arm.com>
Date:   Mon, 19 Jul 2021 17:02:01 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.12.0
MIME-Version: 1.0
In-Reply-To: <171834f3198b898d5c2aefa0270b65f2@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Marc,

On 7/19/21 4:56 PM, Marc Zyngier wrote:
> On 2021-07-19 16:55, Alexandru Elisei wrote:
>> Hi Marc,
>>
>> On 7/19/21 1:38 PM, Marc Zyngier wrote:
>>> A number of the PMU sysregs expose reset values that are not
>>> compliant with the architecture (set bits in the RES0 ranges,
>>> for example).
>>>
>>> This in turn has the effect that we need to pointlessly mask
>>> some register fields when using them.
>>>
>>> Let's start by making sure we don't have illegal values in the
>>> shadow registers at reset time. This affects all the registers
>>> that dedicate one bit per counter, the counters themselves,
>>> PMEVTYPERn_EL0 and PMSELR_EL0.
>>>
>>> Reported-by: Alexandre Chartre <alexandre.chartre@oracle.com>
>>> Reviewed-by: Alexandre Chartre <alexandre.chartre@oracle.com>
>>> Acked-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
>>> Signed-off-by: Marc Zyngier <maz@kernel.org>
>>> ---
>>>  arch/arm64/kvm/sys_regs.c | 43 ++++++++++++++++++++++++++++++++++++---
>>>  1 file changed, 40 insertions(+), 3 deletions(-)
>>>
>>> diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
>>> index f6f126eb6ac1..96bdfa0e68b2 100644
>>> --- a/arch/arm64/kvm/sys_regs.c
>>> +++ b/arch/arm64/kvm/sys_regs.c
>>> @@ -603,6 +603,41 @@ static unsigned int pmu_visibility(const struct kvm_vcpu
>>> *vcpu,
>>>      return REG_HIDDEN;
>>>  }
>>>
>>> +static void reset_pmu_reg(struct kvm_vcpu *vcpu, const struct sys_reg_desc *r)
>>> +{
>>> +    u64 n, mask = BIT(ARMV8_PMU_CYCLE_IDX);
>>> +
>>> +    /* No PMU available, any PMU reg may UNDEF... */
>>> +    if (!kvm_arm_support_pmu_v3())
>>> +        return;
>>> +
>>> +    n = read_sysreg(pmcr_el0) >> ARMV8_PMU_PMCR_N_SHIFT;
>>> +    n &= ARMV8_PMU_PMCR_N_MASK;
>>> +    if (n)
>>> +        mask |= GENMASK(n - 1, 0);
>>
>> Hm... seems to be missing the cycle counter.
>
> Check the declaration for 'mask'... :-)

Yeah, sorry for that, I still had in my mind the original function body.

Everything looks alright to me, no changes from the previous version (PMSWINC_EL1
is handled in the last patch) where I had checked that the reset values match the
architecture:

Reviewed-by: Alexandru Elisei <alexandru.elisei@arm.com>

Thanks,

Alex

