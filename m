Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 908A96C488D
	for <lists+kvm@lfdr.de>; Wed, 22 Mar 2023 12:06:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230313AbjCVLGb (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 22 Mar 2023 07:06:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45772 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230343AbjCVLG2 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 22 Mar 2023 07:06:28 -0400
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 7E1FF61504;
        Wed, 22 Mar 2023 04:06:26 -0700 (PDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id B4A8A4B3;
        Wed, 22 Mar 2023 04:07:09 -0700 (PDT)
Received: from FVFF77S0Q05N (unknown [10.57.53.3])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 98B983F67D;
        Wed, 22 Mar 2023 04:06:21 -0700 (PDT)
Date:   Wed, 22 Mar 2023 11:06:16 +0000
From:   Mark Rutland <mark.rutland@arm.com>
To:     Usama Arif <usama.arif@bytedance.com>
Cc:     dwmw2@infradead.org, tglx@linutronix.de, kim.phillips@amd.com,
        brgerst@gmail.com, piotrgorski@cachyos.org,
        oleksandr@natalenko.name, arjan@linux.intel.com, mingo@redhat.com,
        bp@alien8.de, dave.hansen@linux.intel.com, hpa@zytor.com,
        x86@kernel.org, pbonzini@redhat.com, paulmck@kernel.org,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        rcu@vger.kernel.org, mimoja@mimoja.de, hewenliang4@huawei.com,
        thomas.lendacky@amd.com, seanjc@google.com, pmenzel@molgen.mpg.de,
        fam.zheng@bytedance.com, punit.agrawal@bytedance.com,
        simon.evans@bytedance.com, liangma@liangbit.com,
        gpiccoli@igalia.com, David Woodhouse <dwmw@amazon.co.uk>
Subject: Re: [PATCH v16 2/8] cpu/hotplug: Reset task stack state in _cpu_up()
Message-ID: <ZBrhKERLxvklAhiP@FVFF77S0Q05N>
References: <20230321194008.785922-1-usama.arif@bytedance.com>
 <20230321194008.785922-3-usama.arif@bytedance.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230321194008.785922-3-usama.arif@bytedance.com>
X-Spam-Status: No, score=-2.3 required=5.0 tests=RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Mar 21, 2023 at 07:40:02PM +0000, Usama Arif wrote:
> From: David Woodhouse <dwmw@amazon.co.uk>
> 
> Commit dce1ca0525bf ("sched/scs: Reset task stack state in bringup_cpu()")
> ensured that the shadow call stack and KASAN poisoning were removed from
> a CPU's stack each time that CPU is brought up, not just once.
> 
> This is not incorrect. However, with parallel bringup, an architecture
> may obtain the idle thread for a new CPU from a pre-bringup stage, by
> calling idle_thread_get() for itself. This would mean that the cleanup
> in bringup_cpu() would be too late.
> 
> Move the SCS/KASAN cleanup to the generic _cpu_up() function instead,
> which already ensures that the new CPU's stack is available, purely to
> allow for early failure. This occurs when the CPU to be brought up is
> in the CPUHP_OFFLINE state, which should correctly do the cleanup any
> time the CPU has been taken down to the point where such is needed.
> 
> Signed-off-by: David Woodhouse <dwmw@amazon.co.uk>

This all sounds fine to me, and the patch itself looks good.

I built an arm64 kernel with the first three patches from this series applied
atop v6.3-rc3, with defconfig + CONFIG_SHADOW_CALL_STACK=y +
CONFIG_KASAN_INLINE=y + CONFIG_KASAN_STACK=y. I then hotplugged a cpu with:

  while true; do
    echo 0 > /sys/devices/system/cpu/cpu1/online;
    echo 1 > /sys/devices/system/cpu/cpu1/online;
  done

... and that was perfectly happy to run for minutes with no unexpected failures.

To make sure I wasn't avoiding issues by chance, I also tried with each of
scs_task_reset() and kasan_unpoison_task_stack() commented out. With
scs_task_reset() commented out, cpu re-onlining fails after a few iterations,
and with kasan_unpoison_task_stack() commented out I get a KASAN splat upon the
first re-onlining. So that all looks good.

FWIW, for the first three patches:

Reviewed-by: Mark Rutland <mark.rutland@arm.com>
Tested-by: Mark Rutland <mark.rutland@arm.com> [arm64]

Mark.

> ---
>  kernel/cpu.c | 12 ++++++------
>  1 file changed, 6 insertions(+), 6 deletions(-)
> 
> diff --git a/kernel/cpu.c b/kernel/cpu.c
> index 6c0a92ca6bb5..43e0a77f21e8 100644
> --- a/kernel/cpu.c
> +++ b/kernel/cpu.c
> @@ -591,12 +591,6 @@ static int bringup_cpu(unsigned int cpu)
>  	struct task_struct *idle = idle_thread_get(cpu);
>  	int ret;
>  
> -	/*
> -	 * Reset stale stack state from the last time this CPU was online.
> -	 */
> -	scs_task_reset(idle);
> -	kasan_unpoison_task_stack(idle);
> -
>  	/*
>  	 * Some architectures have to walk the irq descriptors to
>  	 * setup the vector space for the cpu which comes online.
> @@ -1383,6 +1377,12 @@ static int _cpu_up(unsigned int cpu, int tasks_frozen, enum cpuhp_state target)
>  			ret = PTR_ERR(idle);
>  			goto out;
>  		}
> +
> +		/*
> +		 * Reset stale stack state from the last time this CPU was online.
> +		 */
> +		scs_task_reset(idle);
> +		kasan_unpoison_task_stack(idle);
>  	}
>  
>  	cpuhp_tasks_frozen = tasks_frozen;
> -- 
> 2.25.1
> 
