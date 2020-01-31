Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2AB5A14EA45
	for <lists+kvm@lfdr.de>; Fri, 31 Jan 2020 10:52:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728285AbgAaJwn (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 31 Jan 2020 04:52:43 -0500
Received: from foss.arm.com ([217.140.110.172]:33574 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728160AbgAaJwm (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 31 Jan 2020 04:52:42 -0500
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 250B81063;
        Fri, 31 Jan 2020 01:52:42 -0800 (PST)
Received: from [10.1.196.63] (e123195-lin.cambridge.arm.com [10.1.196.63])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 6C8023F68E;
        Fri, 31 Jan 2020 01:52:41 -0800 (PST)
Subject: Re: [kvm-unit-tests RFC PATCH v3 5/7] lib: arm64: Add support for
 disabling and re-enabling VHE
To:     Marc Zyngier <maz@kernel.org>
Cc:     kvm@vger.kernel.org, pbonzini@redhat.com, drjones@redhat.com,
        andre.przywara@arm.com
References: <1577972806-16184-1-git-send-email-alexandru.elisei@arm.com>
 <1577972806-16184-6-git-send-email-alexandru.elisei@arm.com>
 <ad46bedcc585d03399576ecfce4c17c0@kernel.org>
From:   Alexandru Elisei <alexandru.elisei@arm.com>
Message-ID: <aa243b68-8fb5-d002-2d89-5865fe4dfd3f@arm.com>
Date:   Fri, 31 Jan 2020 09:52:36 +0000
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <ad46bedcc585d03399576ecfce4c17c0@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi,

Thank you for testing the patches!

On 1/30/20 5:40 PM, Marc Zyngier wrote:
> Hi Alexandru,
>
> On 2020-01-02 13:46, Alexandru Elisei wrote:
>> Add a function to disable VHE and another one to re-enable VHE. Both
>> functions work under the assumption that the CPU had VHE mode enabled at
>> boot.
>>
>> Minimal support to run with VHE has been added to the TLB invalidate
>> functions and to the exception handling code.
>>
>> Since we're touch the assembly enable/disable MMU code, let's take this
>> opportunity to replace a magic number with the proper define.
>
> I've been using this test case to debug my NV code... only to realize
> after a few hours of banging my head on the wall that it is the test
> that needed debugging, see below... ;-)
>
>>
>> Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>
>> ---
>>  lib/arm64/asm/mmu.h           |  11 ++-
>>  lib/arm64/asm/pgtable-hwdef.h |  53 ++++++++---
>>  lib/arm64/asm/processor.h     |  19 +++-
>>  lib/arm64/processor.c         |  37 +++++++-
>>  arm/cstart64.S                | 204 ++++++++++++++++++++++++++++++++++++++++--
>>  5 files changed, 300 insertions(+), 24 deletions(-)
>
> [...]
>
>> --- a/arm/cstart64.S
>> +++ b/arm/cstart64.S
>> @@ -104,6 +104,13 @@ exceptions_init:
>>
>>  .text
>>
>> +exceptions_init_nvhe:
>> +    adrp    x0, vector_table_nvhe
>> +    add    x0, x0, :lo12:vector_table_nvhe
>> +    msr    vbar_el2, x0
>> +    isb
>> +    ret
>> +
>>  .globl get_mmu_off
>>  get_mmu_off:
>>      adrp    x0, auxinfo
>> @@ -203,7 +210,7 @@ asm_mmu_enable:
>>               TCR_IRGN_WBWA | TCR_ORGN_WBWA |    \
>>               TCR_SHARED
>>      mrs    x2, id_aa64mmfr0_el1
>> -    bfi    x1, x2, #32, #3
>> +    bfi    x1, x2, #TCR_EL1_IPS_SHIFT, #3
>>      msr    tcr_el1, x1
>>
>>      /* MAIR */
>> @@ -228,6 +235,41 @@ asm_mmu_enable:
>>
>>      ret
>>
>> +asm_mmu_enable_nvhe:
>
> Note the "_nvhe" suffix, which implies that...
>
>> +    tlbi    alle2
>> +    dsb     nsh
>> +
>> +        /* TCR */
>> +    ldr    x1, =TCR_EL2_RES1 |             \
>> +             TCR_T0SZ(VA_BITS) |        \
>> +             TCR_TG0_64K |                      \
>> +             TCR_IRGN0_WBWA | TCR_ORGN0_WBWA |    \
>> +             TCR_SH0_IS
>> +    mrs    x2, id_aa64mmfr0_el1
>> +    bfi    x1, x2, #TCR_EL2_PS_SHIFT, #3
>> +    msr    tcr_el2, x1
>> +
>> +    /* Same MAIR and TTBR0 as in VHE mode */
>> +    ldr    x1, =MAIR(0x00, MT_DEVICE_nGnRnE) |    \
>> +             MAIR(0x04, MT_DEVICE_nGnRE) |    \
>> +             MAIR(0x0c, MT_DEVICE_GRE) |    \
>> +             MAIR(0x44, MT_NORMAL_NC) |        \
>> +             MAIR(0xff, MT_NORMAL)
>> +    msr    mair_el1, x1
>
> ... this should be mair_el2...
>
>> +
>> +    msr    ttbr0_el1, x0
>
> ... and this should be ttbr0_el2.

The code is definitely confusing, but not because it's wrong, but because it's
doing something useless. From DDI 04876E.a, page D13-3374, the pseudocode for
writing to ttbr0_el1:

[..] elsif PSTATE.EL == EL2 then     if HCR_EL2.E2H == '1' then         TTBR0_EL2
= X[t];

    else         TTBR0_EL1 = X[t]; [..]

We want to use the same ttbr0_el2 and mair_el2 values that we were using when VHE
was on. We programmed those values when VHE was on, so we actually wrote them to
ttbr0_el2 and mair_el2. We don't need to write them again now, in fact, all the
previous versions of the series didn't even have the above useless writes (I
assume it was a copy-and-paste mistake when I split the fixes from the el2 patches).

>
>> +    isb
>> +
>> +    /* SCTLR */
>> +    ldr    x1, =SCTLR_EL2_RES1 |            \
>> +             SCTLR_EL2_C |             \
>> +             SCTLR_EL2_I |             \
>> +             SCTLR_EL2_M
>> +    msr    sctlr_el2, x1
>> +    isb
>> +
>> +    ret
>> +
>>  /* Taken with small changes from arch/arm64/incluse/asm/assembler.h */
>>  .macro dcache_by_line_op op, domain, start, end, tmp1, tmp2
>>      adrp    \tmp1, dcache_line_size
>> @@ -242,21 +284,61 @@ asm_mmu_enable:
>>      dsb    \domain
>>  .endm
>>
>> +clean_inval_cache:
>> +    adrp    x0, __phys_offset
>> +    ldr    x0, [x0, :lo12:__phys_offset]
>> +    adrp    x1, __phys_end
>> +    ldr    x1, [x1, :lo12:__phys_end]
>> +    dcache_by_line_op civac, sy, x0, x1, x2, x3
>> +    isb
>> +    ret
>> +
>>  .globl asm_mmu_disable
>>  asm_mmu_disable:
>>      mrs    x0, sctlr_el1
>>      bic    x0, x0, SCTLR_EL1_M
>>      msr    sctlr_el1, x0
>>      isb
>> +    b    clean_inval_cache
>>
>> -    /* Clean + invalidate the entire memory */
>> -    adrp    x0, __phys_offset
>> -    ldr    x0, [x0, :lo12:__phys_offset]
>> -    adrp    x1, __phys_end
>> -    ldr    x1, [x1, :lo12:__phys_end]
>> -    dcache_by_line_op civac, sy, x0, x1, x2, x3
>> +asm_mmu_disable_nvhe:
>> +    mrs    x0, sctlr_el2
>> +    bic    x0, x0, SCTLR_EL2_M
>> +    msr    sctlr_el2, x0
>> +    isb
>> +    b    clean_inval_cache
>> +
>> +.globl asm_disable_vhe
>> +asm_disable_vhe:
>> +    str    x30, [sp, #-16]!
>> +
>> +    bl    asm_mmu_disable
>> +    msr    hcr_el2, xzr
>> +    isb
>
> At this stage, VHE is off...
>
>> +    bl    exceptions_init_nvhe
>> +    /* Make asm_mmu_enable_nvhe happy by having TTBR0 value in x0. */
>> +    mrs    x0, ttbr0_el1
>
> ... so this is going to sample the wrong TTBR. It really should be
> TTBR0_EL2!

Not really, asm_mmu_enable has one parameter, the PA for the translation tables in
register x0, and we are going to use the same translation tables with VHE off that
we were using with VHE on. Hence the read.//It could have easily been mrs
x0,ttbr0_el2, since they have the same value, which we want to reuse.

I think this confusion stems from the fact that I'm trying to write the registers
again in asm_mmu_enable_nvhe, when we don't have to. And writing to the wrong
registers makes the confusion even worse.

>
>> +    isb
>
> nit: this ISB is useless, as you will have a dependency on x0 anyway.

True, I'll remove it.

Thanks,
Alex
>
> With these fixes (and a few more terrible hacks to synchronize HCR_EL2
> on ARMv8.4-NV), I can run this test reliably.
>
> Thanks,
>
>         M.
