Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E8C9A345D27
	for <lists+kvm@lfdr.de>; Tue, 23 Mar 2021 12:41:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229900AbhCWLk3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 23 Mar 2021 07:40:29 -0400
Received: from foss.arm.com ([217.140.110.172]:44456 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230114AbhCWLkI (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 23 Mar 2021 07:40:08 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 963B01042;
        Tue, 23 Mar 2021 04:40:07 -0700 (PDT)
Received: from [192.168.0.110] (unknown [172.31.20.19])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 1BC843F719;
        Tue, 23 Mar 2021 04:40:06 -0700 (PDT)
Subject: Re: [kvm-unit-tests PATCH 0/4] RFC: Minor arm/arm64 MMU fixes and
 checks
To:     Andrew Jones <drjones@redhat.com>,
        Nikos Nikoleris <nikos.nikoleris@arm.com>
Cc:     kvm@vger.kernel.org
References: <20210319122414.129364-1-nikos.nikoleris@arm.com>
 <20210323112411.6uwqex6x2py4va6d@kamzik.brq.redhat.com>
From:   Alexandru Elisei <alexandru.elisei@arm.com>
Message-ID: <0f27d865-e16d-e933-4dfa-a3661437c5d2@arm.com>
Date:   Tue, 23 Mar 2021 11:40:37 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <20210323112411.6uwqex6x2py4va6d@kamzik.brq.redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Drew,

On 3/23/21 11:24 AM, Andrew Jones wrote:
> On Fri, Mar 19, 2021 at 12:24:10PM +0000, Nikos Nikoleris wrote:
>> Prior to this set of fixes, the code in setup() which we call to
>> initialize the system has a circular dependency. cpu_init()
>> (eventually) calls spin_lock() and __mmu_enabled(). However, at this
>> point, __mmu_enabled() may have undefined behavior as we haven't
>> initialized the current thread_info (cpu field). Moving
>> thread_info_init() above cpu_init() is not possible as it relies on
>> mpidr_to_cpu() which won't return the right results before cpu_init().
>> In addition, mem_init() also calls __mmu_enabled() and therefore
>> suffers from the same problem. Right now, everything works as
>> thread_info maps to memory which is implicitly initialized to 0 (cpu =
>> 0) and makes the assumption that the cpu that runs setup() will be the
>> first cpu in the DT.
>>
>> This set of patches changes the code slightly and avoids this
>> assumptions. In addition, it adds assertions to catch problems like
>> the above. The current solution relies on the thread_info() of the cpu
>> that setup() run to be initialized to zero (should we make it
>> explicit?).
>>
>> There are a couple of options I considered in addressing this issue
>> which didn't seem satisfactory:
>>
>> - Change the mmu_disabled_count global variable to mmu_enabled_count
>>   to count the number of active mmu's and bypass __mmu_enabled() when
>>   it's 0. This is a global variable and at the momement all write to
>>   it are protected by a lock but it's rather fragile and could easily
>>   cause issues in the future.
>> - Explicitly initialize current_thread_info()->cpu = 0 in setup()
>>   before anything else or make the first call of thread_info_init() a
>>   special case and avoid looking up mpidr_to_cpu(). This way we can
>>   move thread_info_init() to the top of setup(). If the CPU setup is
>>   running on is not the first that appears in the DT then this
>>   solution won't work.
>>
>> Thanks,
>>
>> Nikos
>>
>> Nikos Nikoleris (4):
>>   arm/arm64: Avoid calling cpumask_test_cpu for CPUs above nr_cpu
>>   arm/arm64: Read system registers to get the state of the MMU
>>   arm/arm64: Track whether thread_info has been initialized
>>   arm/arm64: Add sanity checks to the cpumask API
>>
>>  lib/arm/asm/cpumask.h     |  7 ++++++-
>>  lib/arm/asm/mmu-api.h     |  7 +------
>>  lib/arm/asm/processor.h   |  7 +++++++
>>  lib/arm/asm/thread_info.h |  1 +
>>  lib/arm64/asm/processor.h |  1 +
>>  lib/arm/mmu.c             | 16 ++++++++--------
>>  lib/arm/processor.c       | 10 ++++++++--
>>  lib/arm64/processor.c     | 10 ++++++++--
>>  8 files changed, 40 insertions(+), 19 deletions(-)
>>
>> -- 
>> 2.25.1
>>
> Hi Nikos,
>
> So, I like patches 1, 2, and 4. I think 3 can be dropped with the
> addition of "arm/arm64: Zero BSS and stack at startup". Would you
> agree? I've applied all the updated commit messages and all of
> Alexandru's suggestions to 2. Patch 2 now looks like the diff below.
>
> Alexandru, are you satisfied with 1, 2, and 4? If so, please let me
> know and I'll add r-b's for you before queuing.

The diff looks good, and I agree that we can come back to #3 once we have a better
understanding of what needs to be done. Patch #1 is a nice fix for what I imagine
was a hard to find bug. Patch #4 also looks correct to me. Yes, please add my
Reviewed-by for the series.

Thanks,

Alex

>
> Thanks,
> drew
>
>
> diff --git a/lib/arm/asm/mmu-api.h b/lib/arm/asm/mmu-api.h
> index 3d04d0312622..05fc12b5afb8 100644
> --- a/lib/arm/asm/mmu-api.h
> +++ b/lib/arm/asm/mmu-api.h
> @@ -5,12 +5,7 @@
>  #include <stdbool.h>
>  
>  extern pgd_t *mmu_idmap;
> -extern unsigned int mmu_disabled_cpu_count;
> -extern bool __mmu_enabled(void);
> -static inline bool mmu_enabled(void)
> -{
> -	return mmu_disabled_cpu_count == 0 || __mmu_enabled();
> -}
> +extern bool mmu_enabled(void);
>  extern void mmu_mark_enabled(int cpu);
>  extern void mmu_mark_disabled(int cpu);
>  extern void mmu_enable(pgd_t *pgtable);
> diff --git a/lib/arm/asm/processor.h b/lib/arm/asm/processor.h
> index 273366d1fe1c..6b762ad060eb 100644
> --- a/lib/arm/asm/processor.h
> +++ b/lib/arm/asm/processor.h
> @@ -67,11 +67,13 @@ extern int mpidr_to_cpu(uint64_t mpidr);
>  	((mpidr >> MPIDR_LEVEL_SHIFT(level)) & 0xff)
>  
>  extern void start_usr(void (*func)(void *arg), void *arg, unsigned long sp_usr);
> +extern bool __mmu_enabled(void);
>  extern bool is_user(void);
>  
>  #define CNTVCT		__ACCESS_CP15_64(1, c14)
>  #define CNTFRQ		__ACCESS_CP15(c14, 0, c0, 0)
>  #define CTR		__ACCESS_CP15(c0, 0, c0, 1)
> +#define SCTRL		__ACCESS_CP15(c1, 0, c0, 0)
>  
>  static inline u64 get_cntvct(void)
>  {
> diff --git a/lib/arm/mmu.c b/lib/arm/mmu.c
> index a1862a55db8b..15eef007f256 100644
> --- a/lib/arm/mmu.c
> +++ b/lib/arm/mmu.c
> @@ -24,13 +24,10 @@ extern unsigned long etext;
>  pgd_t *mmu_idmap;
>  
>  /* CPU 0 starts with disabled MMU */
> -static cpumask_t mmu_disabled_cpumask = { {1} };
> -unsigned int mmu_disabled_cpu_count = 1;
> +static cpumask_t mmu_enabled_cpumask;
>  
> -bool __mmu_enabled(void)
> +bool mmu_enabled(void)
>  {
> -	int cpu = current_thread_info()->cpu;
> -
>  	/*
>  	 * mmu_enabled is called from places that are guarding the
>  	 * use of exclusive ops (which require the mmu to be enabled).
> @@ -38,19 +35,22 @@ bool __mmu_enabled(void)
>  	 * spinlock, atomic bitop, etc., otherwise we'll recurse.
>  	 * [cpumask_]test_bit is safe though.
>  	 */
> -	return !cpumask_test_cpu(cpu, &mmu_disabled_cpumask);
> +	if (is_user()) {
> +		int cpu = current_thread_info()->cpu;
> +		return cpumask_test_cpu(cpu, &mmu_enabled_cpumask);
> +	}
> +
> +	return __mmu_enabled();
>  }
>  
>  void mmu_mark_enabled(int cpu)
>  {
> -	if (cpumask_test_and_clear_cpu(cpu, &mmu_disabled_cpumask))
> -		--mmu_disabled_cpu_count;
> +	cpumask_set_cpu(cpu, &mmu_enabled_cpumask);
>  }
>  
>  void mmu_mark_disabled(int cpu)
>  {
> -	if (!cpumask_test_and_set_cpu(cpu, &mmu_disabled_cpumask))
> -		++mmu_disabled_cpu_count;
> +	cpumask_clear_cpu(cpu, &mmu_enabled_cpumask);
>  }
>  
>  extern void asm_mmu_enable(phys_addr_t pgtable);
> diff --git a/lib/arm/processor.c b/lib/arm/processor.c
> index 773337e6d3b7..9d5759686b73 100644
> --- a/lib/arm/processor.c
> +++ b/lib/arm/processor.c
> @@ -145,3 +145,8 @@ bool is_user(void)
>  {
>  	return current_thread_info()->flags & TIF_USER_MODE;
>  }
> +
> +bool __mmu_enabled(void)
> +{
> +	return read_sysreg(SCTRL) & CR_M;
> +}
> diff --git a/lib/arm64/asm/processor.h b/lib/arm64/asm/processor.h
> index 771b2d1e0c94..8e2037e1a43e 100644
> --- a/lib/arm64/asm/processor.h
> +++ b/lib/arm64/asm/processor.h
> @@ -98,6 +98,7 @@ extern int mpidr_to_cpu(uint64_t mpidr);
>  
>  extern void start_usr(void (*func)(void *arg), void *arg, unsigned long sp_usr);
>  extern bool is_user(void);
> +extern bool __mmu_enabled(void);
>  
>  static inline u64 get_cntvct(void)
>  {
> diff --git a/lib/arm64/processor.c b/lib/arm64/processor.c
> index 2a024e3f4e9d..ef558625e284 100644
> --- a/lib/arm64/processor.c
> +++ b/lib/arm64/processor.c
> @@ -257,3 +257,8 @@ bool is_user(void)
>  {
>  	return current_thread_info()->flags & TIF_USER_MODE;
>  }
> +
> +bool __mmu_enabled(void)
> +{
> +	return read_sysreg(sctlr_el1) & SCTLR_EL1_M;
> +}
>
