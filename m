Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9173A34492E
	for <lists+kvm@lfdr.de>; Mon, 22 Mar 2021 16:26:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230133AbhCVPZa (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 22 Mar 2021 11:25:30 -0400
Received: from foss.arm.com ([217.140.110.172]:33778 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229900AbhCVPZF (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 22 Mar 2021 11:25:05 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id F3EFB1042;
        Mon, 22 Mar 2021 08:25:03 -0700 (PDT)
Received: from [192.168.0.110] (unknown [172.31.20.19])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 5D9253F719;
        Mon, 22 Mar 2021 08:25:03 -0700 (PDT)
Subject: Re: [kvm-unit-tests PATCH 2/4] arm/arm64: Read system registers to
 get the state of the MMU
To:     Nikos Nikoleris <nikos.nikoleris@arm.com>, kvm@vger.kernel.org
Cc:     drjones@redhat.com
References: <20210319122414.129364-1-nikos.nikoleris@arm.com>
 <20210319122414.129364-3-nikos.nikoleris@arm.com>
 <b951ed2e-cd3b-3b87-7fee-b7ac8518121e@arm.com>
 <805f5a6a-4392-1e94-0f39-a99de9d7fd4e@arm.com>
From:   Alexandru Elisei <alexandru.elisei@arm.com>
Message-ID: <8f517b39-b489-571d-cc97-cd0b34ded1b1@arm.com>
Date:   Mon, 22 Mar 2021 15:25:29 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <805f5a6a-4392-1e94-0f39-a99de9d7fd4e@arm.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Nikos,

On 3/22/21 11:14 AM, Nikos Nikoleris wrote:
> Hi Alex,
>
> On 22/03/2021 10:30, Alexandru Elisei wrote:
>> Hi Nikos,
>>
>> On 3/19/21 12:24 PM, Nikos Nikoleris wrote:
>>> When we are in EL1 we can directly tell if the local cpu's MMU is on
>>> by reading a system register (SCTRL/SCTRL_EL1). In EL0, we use the
>>> relevant cpumask. This way we don't have to rely on the cpu id in
>>> thread_info when we are in setup executing in EL1. In subsequent
>>> patches we resolve the problem of identifying safely whether we are
>>> executing in EL1 or EL0.
>>
>
> Thanks for the review!
>
>> The commit message doesn't explain why mmu_disabled_cpu_count has been removed. It
>> also doesn't explain why the disabled cpumask has been replaced with an enabled
>> cpumask.
>>
>
> Would this make more sense then?
>
> When we are in EL1 we can directly tell if the local cpu's MMU is ON
> by reading a system register (SCTRL/SCTRL_EL1). In EL0, we use the relevant
> cpumask. This way we don't have to rely on the cpu id in
> thread_info when we are in setup executing in EL1. In subsequent
> patches we resolve the problem of identifying safely whether we are
> executing in EL1 or EL0.

I think the last sentence should be removed. If this patch relies on is_user()
working correctly and is_user() is not, then is_user() should be fixed before this
patch. If is_user() is working correctly and another patch modifies it for reasons
other than correctness, then it shouldn't be mentioned here.

>
> In addition, this change:
> * Removes mmu_disabled_cpu_count as it is no
> longer necessary and assumed that calls to
> mmu_mark_enabled()/mmu_mark_disabled() were serialized. This is currently true
> but a future change could easily break that assumption.
> * Changes mmu_disabled_mask to mmu_enabled_mask and inverts the logic to track
> in a more intuitive way that all CPUs start with the MMU OFF and at some point,
> we turn them ON.

Much better, thanks.

Nitpicks below.

>
>> Other than that, it is a good idea to stop mmu_enabled() from checking the cpumask
>> because marking the MMU as enabled/disabled requires modifying the cpumask, which
>> calls mmu_enabled(). That's not a problem at EL0 because EL0 cannot turn on or off
>> the MMU.
>
> Indeed, I didn't catch that initially but I think you're right.
>
> Thanks,
>
> Nikos
>
>>
>> Thanks,
>>
>> Alex
>>
>>>
>>> Signed-off-by: Nikos Nikoleris <nikos.nikoleris@arm.com>
>>> ---
>>>   lib/arm/asm/mmu-api.h     |  7 +------
>>>   lib/arm/asm/processor.h   |  7 +++++++
>>>   lib/arm64/asm/processor.h |  1 +
>>>   lib/arm/mmu.c             | 16 ++++++++--------
>>>   lib/arm/processor.c       |  5 +++++
>>>   lib/arm64/processor.c     |  5 +++++
>>>   6 files changed, 27 insertions(+), 14 deletions(-)
>>>
>>> diff --git a/lib/arm/asm/mmu-api.h b/lib/arm/asm/mmu-api.h
>>> index 3d04d03..05fc12b 100644
>>> --- a/lib/arm/asm/mmu-api.h
>>> +++ b/lib/arm/asm/mmu-api.h
>>> @@ -5,12 +5,7 @@
>>>   #include <stdbool.h>
>>>     extern pgd_t *mmu_idmap;
>>> -extern unsigned int mmu_disabled_cpu_count;
>>> -extern bool __mmu_enabled(void);
>>> -static inline bool mmu_enabled(void)
>>> -{
>>> -    return mmu_disabled_cpu_count == 0 || __mmu_enabled();
>>> -}
>>> +extern bool mmu_enabled(void);
>>>   extern void mmu_mark_enabled(int cpu);
>>>   extern void mmu_mark_disabled(int cpu);
>>>   extern void mmu_enable(pgd_t *pgtable);
>>> diff --git a/lib/arm/asm/processor.h b/lib/arm/asm/processor.h
>>> index 273366d..af54c09 100644
>>> --- a/lib/arm/asm/processor.h
>>> +++ b/lib/arm/asm/processor.h
>>> @@ -67,11 +67,13 @@ extern int mpidr_to_cpu(uint64_t mpidr);
>>>       ((mpidr >> MPIDR_LEVEL_SHIFT(level)) & 0xff)
>>>     extern void start_usr(void (*func)(void *arg), void *arg, unsigned long
>>> sp_usr);
>>> +extern bool __mmu_enabled(void);
>>>   extern bool is_user(void);
>>>     #define CNTVCT        __ACCESS_CP15_64(1, c14)
>>>   #define CNTFRQ        __ACCESS_CP15(c14, 0, c0, 0)
>>>   #define CTR        __ACCESS_CP15(c0, 0, c0, 1)
>>> +#define SCTRL        __ACCESS_CP15(c1, 0, c0, 0)
>>>     static inline u64 get_cntvct(void)
>>>   {
>>> @@ -89,6 +91,11 @@ static inline u32 get_ctr(void)
>>>       return read_sysreg(CTR);
>>>   }
>>>   +static inline u32 get_sctrl(void)
>>> +{
>>> +    return read_sysreg(SCTRL);
>>> +}

I don't think this is needed. The get_<sysreg>() functions above are here because
they are used from arch independent code, and a function with an identical
declaration is also present in lib/arm64/asm/processor.h.

I think the function can be folded into lib/arm/processor.c::__mmu_enabled(),
similar to __mmu_enabled() for arm64.

>>> +
>>>   extern unsigned long dcache_line_size;
>>>     #endif /* _ASMARM_PROCESSOR_H_ */
>>> diff --git a/lib/arm64/asm/processor.h b/lib/arm64/asm/processor.h
>>> index 771b2d1..8e2037e 100644
>>> --- a/lib/arm64/asm/processor.h
>>> +++ b/lib/arm64/asm/processor.h
>>> @@ -98,6 +98,7 @@ extern int mpidr_to_cpu(uint64_t mpidr);
>>>     extern void start_usr(void (*func)(void *arg), void *arg, unsigned long
>>> sp_usr);
>>>   extern bool is_user(void);
>>> +extern bool __mmu_enabled(void);
>>>     static inline u64 get_cntvct(void)
>>>   {
>>> diff --git a/lib/arm/mmu.c b/lib/arm/mmu.c
>>> index a1862a5..d806c63 100644
>>> --- a/lib/arm/mmu.c
>>> +++ b/lib/arm/mmu.c
>>> @@ -24,10 +24,9 @@ extern unsigned long etext;
>>>   pgd_t *mmu_idmap;
>>>     /* CPU 0 starts with disabled MMU */
>>> -static cpumask_t mmu_disabled_cpumask = { {1} };
>>> -unsigned int mmu_disabled_cpu_count = 1;
>>> +static cpumask_t mmu_enabled_cpumask = { {0} };
>>>   -bool __mmu_enabled(void)
>>> +bool mmu_enabled(void)
>>>   {
>>>       int cpu = current_thread_info()->cpu;
>>>   @@ -38,19 +37,20 @@ bool __mmu_enabled(void)
>>>        * spinlock, atomic bitop, etc., otherwise we'll recurse.
>>>        * [cpumask_]test_bit is safe though.
>>>        */
>>> -    return !cpumask_test_cpu(cpu, &mmu_disabled_cpumask);
>>> +    if (is_user())
>>> +        return cpumask_test_cpu(cpu, &mmu_enabled_cpumask);
>>> +    else
>>> +        return __mmu_enabled();
>>>   }

This is how mmu_enabled() looks like with this patch:

bool mmu_enabled(void)
{
    int cpu = current_thread_info()->cpu;

    /*
     * mmu_enabled is called from places that are guarding the
     * use of exclusive ops (which require the mmu to be enabled).
     * That means we CANNOT call anything from here that may use a
     * spinlock, atomic bitop, etc., otherwise we'll recurse.
     * [cpumask_]test_bit is safe though.
     */
    if (is_user())
        return cpumask_test_cpu(cpu, &mmu_enabled_cpumask);
    else
        return __mmu_enabled();
}

The commit message says that "[..] we don't have to rely on the cpu id in
thread_info when we are in setup executing in EL1", but still we read it here
unconditionally. Maybe the assignment could be moved to the is_user() branch, to
make it absolutely clear current_thread_info() is not always correct when calling
mmu_enabled()?

Thanks,

Alex

>>>     void mmu_mark_enabled(int cpu)
>>>   {
>>> -    if (cpumask_test_and_clear_cpu(cpu, &mmu_disabled_cpumask))
>>> -        --mmu_disabled_cpu_count;
>>> +    cpumask_set_cpu(cpu, &mmu_enabled_cpumask);
>>>   }
>>>     void mmu_mark_disabled(int cpu)
>>>   {
>>> -    if (!cpumask_test_and_set_cpu(cpu, &mmu_disabled_cpumask))
>>> -        ++mmu_disabled_cpu_count;
>>> +    cpumask_clear_cpu(cpu, &mmu_enabled_cpumask);
>>>   }
>>>     extern void asm_mmu_enable(phys_addr_t pgtable);
>>> diff --git a/lib/arm/processor.c b/lib/arm/processor.c
>>> index 773337e..a2d39a4 100644
>>> --- a/lib/arm/processor.c
>>> +++ b/lib/arm/processor.c
>>> @@ -145,3 +145,8 @@ bool is_user(void)
>>>   {
>>>       return current_thread_info()->flags & TIF_USER_MODE;
>>>   }
>>> +
>>> +bool __mmu_enabled(void)
>>> +{
>>> +    return get_sctrl() & CR_M;
>>> +}
>>> diff --git a/lib/arm64/processor.c b/lib/arm64/processor.c
>>> index 2a024e3..ef55862 100644
>>> --- a/lib/arm64/processor.c
>>> +++ b/lib/arm64/processor.c
>>> @@ -257,3 +257,8 @@ bool is_user(void)
>>>   {
>>>       return current_thread_info()->flags & TIF_USER_MODE;
>>>   }
>>> +
>>> +bool __mmu_enabled(void)
>>> +{
>>> +    return read_sysreg(sctlr_el1) & SCTLR_EL1_M;
>>> +}
