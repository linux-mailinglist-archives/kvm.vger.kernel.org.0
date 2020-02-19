Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D728716431B
	for <lists+kvm@lfdr.de>; Wed, 19 Feb 2020 12:14:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726558AbgBSLOn (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 19 Feb 2020 06:14:43 -0500
Received: from mail.kernel.org ([198.145.29.99]:60200 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726469AbgBSLOn (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 19 Feb 2020 06:14:43 -0500
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org [51.254.78.96])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6951D24658;
        Wed, 19 Feb 2020 11:14:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1582110882;
        bh=t4vzpweClqjBcv8dfE7UQXkgRAqeUVPdgkwMN4FVeg0=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=EK4/zBLpN2Xq0bcVNbO+o/rj59zbrufMthyreklPzIrj8cSI8s0564Ksfw2oidBY3
         KgznGxD07C86IQalFv6CpZhpI5y6vQmkbOnKMCwOictJJaUaDDNukIPALdp3hEbEeM
         YgiPWlcfva2qKdv6d8hjBH7dqi/QrIzd/2YsxfTk=
Received: from disco-boy.misterjones.org ([51.254.78.96] helo=www.loen.fr)
        by disco-boy.misterjones.org with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.92)
        (envelope-from <maz@kernel.org>)
        id 1j4NJQ-006UOX-Ds; Wed, 19 Feb 2020 11:14:40 +0000
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
 format=flowed
Content-Transfer-Encoding: 8bit
Date:   Wed, 19 Feb 2020 11:14:40 +0000
From:   Marc Zyngier <maz@kernel.org>
To:     James Morse <james.morse@arm.com>
Cc:     linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        kvm@vger.kernel.org, Peter Maydell <peter.maydell@linaro.org>,
        Julien Thierry <julien.thierry.kdev@gmail.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>
Subject: Re: [PATCH 3/5] kvm: arm64: Limit PMU version to ARMv8.1
In-Reply-To: <ed7f31d5-9a2b-6ea0-85f8-74fcd7d9ac61@arm.com>
References: <20200216185324.32596-1-maz@kernel.org>
 <20200216185324.32596-4-maz@kernel.org>
 <eb0294ef-5ad2-9940-2d59-b92220948ffc@arm.com>
 <c0a848e3ababff4ee9ecaa4b246d5875@kernel.org>
 <ed7f31d5-9a2b-6ea0-85f8-74fcd7d9ac61@arm.com>
Message-ID: <89155997285a33615093210d6c4de26d@kernel.org>
X-Sender: maz@kernel.org
User-Agent: Roundcube Webmail/1.3.10
X-SA-Exim-Connect-IP: 51.254.78.96
X-SA-Exim-Rcpt-To: james.morse@arm.com, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, peter.maydell@linaro.org, julien.thierry.kdev@gmail.com, suzuki.poulose@arm.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 2020-02-19 10:18, James Morse wrote:
> Hi Marc,
> 
> On 2/19/20 9:46 AM, Marc Zyngier wrote:
>> On 2020-02-18 17:43, James Morse wrote:
>>> Hi Marc,
>>> 
>>> On 16/02/2020 18:53, Marc Zyngier wrote:
>>>> Our PMU code is only implementing the ARMv8.1 features, so let's
>>>> stick to this when reporting the feature set to the guest.
>>> 
>>>> diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
>>>> index 682fedd7700f..06b2d0dc6c73 100644
>>>> --- a/arch/arm64/kvm/sys_regs.c
>>>> +++ b/arch/arm64/kvm/sys_regs.c
>>>> @@ -1093,6 +1093,11 @@ static u64 read_id_reg(const struct kvm_vcpu
>>>> *vcpu,
>>>>                   FEATURE(ID_AA64ISAR1_GPA) |
>>>>                   FEATURE(ID_AA64ISAR1_GPI));
>>>>          break;
>>>> +    case SYS_ID_AA64DFR0_EL1:
>>>> +        /* Limit PMU to ARMv8.1 */
>>> 
>>> Not just limit, but upgrade too! (force?)
>>> This looks safe because ARMV8_PMU_EVTYPE_EVENT always includes the
>>> extra bits this added, and the register is always trapped.
>> 
>> That's definitely not what I intended! Let me fix that one.
> 
> What goes wrong?
> 
> The register description says to support v8.1 you need:
> | Extended 16-bit PMEVTYPER<n>_EL0.evtCount field
> | If EL2 is implemented, the MDCR_EL2.HPMD control bit
> 
> It looks like the extended PMEVTYPER would work via the emulation, and
> EL2 guests are totally crazy.
> 
> Is the STALL_* bits in ARMv8.1-PMU the problem, ... or the extra work
> for NV?

What goes wrong is that on a v8.0 system, the guest could be tempted to
use events in the 0x0400-0xffff range. It wouldn't break anything, but
it wouldn't give the expected result.

I don't care much for PMU support in EL2 guests at this stage.

>>> The PMU version is also readable via ID_DFR0_EL1.PerfMon, should that
>>> be sanitised to be the same? (I don't think we've hidden an aarch64
>>> feature that also existed in aarch32 before).
>> 
>> Indeed, yet another oversight. I'll fix that too.
> 
> (Weird variation in the aarch32 and aarch64 ID registers isn't 
> something
> I care about ... who would ever look at both?)

A 64bit guest running a 32bit EL0?

         M.
-- 
Jazz is not dead. It just smells funny...
