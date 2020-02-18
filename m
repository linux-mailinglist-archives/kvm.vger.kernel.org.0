Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 10D72162E11
	for <lists+kvm@lfdr.de>; Tue, 18 Feb 2020 19:15:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726510AbgBRSPQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 18 Feb 2020 13:15:16 -0500
Received: from foss.arm.com ([217.140.110.172]:58252 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726467AbgBRSPQ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 18 Feb 2020 13:15:16 -0500
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id D8CE831B;
        Tue, 18 Feb 2020 10:15:15 -0800 (PST)
Received: from [10.1.196.105] (eglon.cambridge.arm.com [10.1.196.105])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 9C3603F68F;
        Tue, 18 Feb 2020 10:15:14 -0800 (PST)
Subject: Re: [PATCH 1/5] KVM: arm64: Fix missing RES1 in emulation of DBGBIDR
To:     Robin Murphy <robin.murphy@arm.com>, Marc Zyngier <maz@kernel.org>
Cc:     Peter Maydell <peter.maydell@linaro.org>, kvm@vger.kernel.org,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        Julien Thierry <julien.thierry.kdev@gmail.com>
References: <20200216185324.32596-1-maz@kernel.org>
 <20200216185324.32596-2-maz@kernel.org>
 <c1bd5c57-666e-0d54-1e7c-e45d0535ffe3@arm.com>
 <a02252f6-1e9a-2a35-9944-f23e161583ab@arm.com>
From:   James Morse <james.morse@arm.com>
Message-ID: <bf599b74-6ead-8722-d4d4-870a0cabc213@arm.com>
Date:   Tue, 18 Feb 2020 18:15:13 +0000
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <a02252f6-1e9a-2a35-9944-f23e161583ab@arm.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-GB
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Robin,

On 18/02/2020 18:01, Robin Murphy wrote:
> On 18/02/2020 5:43 pm, James Morse wrote:
>> On 16/02/2020 18:53, Marc Zyngier wrote:
>>> The AArch32 CP14 DBGDIDR has bit 15 set to RES1, which our current
>>> emulation doesn't set. Just add the missing bit.

>>> diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
>>> index 3e909b117f0c..da82c4b03aab 100644
>>> --- a/arch/arm64/kvm/sys_regs.c
>>> +++ b/arch/arm64/kvm/sys_regs.c
>>> @@ -1658,7 +1658,7 @@ static bool trap_dbgidr(struct kvm_vcpu *vcpu,
>>>           p->regval = ((((dfr >> ID_AA64DFR0_WRPS_SHIFT) & 0xf) << 28) |
>>>                    (((dfr >> ID_AA64DFR0_BRPS_SHIFT) & 0xf) << 24) |
>>>                    (((dfr >> ID_AA64DFR0_CTX_CMPS_SHIFT) & 0xf) << 20)
>>> -                 | (6 << 16) | (el3 << 14) | (el3 << 12));
>>> +                 | (6 << 16) | (1 << 15) | (el3 << 14) | (el3 << 12));
>>
>> Hmmm, where el3 is:
>> | u32 el3 = !!cpuid_feature_extract_unsigned_field(pfr, ID_AA64PFR0_EL3_SHIFT);
>>
>> Aren't we depending on the compilers 'true' being 1 here?
> 
> Pretty much, but thankfully the only compilers we support are C compilers:
> 
> "The result of the logical negation operator ! is 0 if the value of its operand compares
> unequal to 0, 1 if the value of its operand compares equal to 0. The result has type int."

Excellent. I thought this was the sort of thing that couldn't be depended on!


> And now I have you to thank for flashbacks to bitwise logical operators in Visual Basic... :P

... sorry?



Thanks,

James
