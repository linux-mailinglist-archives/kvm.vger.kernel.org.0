Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C8D9F69177F
	for <lists+kvm@lfdr.de>; Fri, 10 Feb 2023 05:11:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230315AbjBJELM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 9 Feb 2023 23:11:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52110 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229917AbjBJELK (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 9 Feb 2023 23:11:10 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 945D03C24;
        Thu,  9 Feb 2023 20:11:07 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 28004B823B8;
        Fri, 10 Feb 2023 04:11:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B4C72C433EF;
        Fri, 10 Feb 2023 04:11:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1676002264;
        bh=mw5QlU1yAxoxctzjzn6SCdph/DJlBUZBAIVrLjlGQ0A=;
        h=Date:From:To:Cc:Subject:Reply-To:References:In-Reply-To:From;
        b=EGrgk3+QVI4VAEoGbjsX4msiFiyVw1MpLxiudf+dbJ5a7a0VFyv6qXfWX/QwN5DXQ
         Zd0y3m4ZT8iFzyDamqNqwkZorj3XGRlXDga+L/zVlursvv6QTwpVvyfC47Ib1dc55Y
         vA1TURyOQLmdaRBUsoP8vYyQv061+iRl17SM/50UHOEdzTnXGxLP3ozWwzVKgFwMmB
         v8MRRTb13vrfGFGVl3mkKgqDeWKFew4vp3qRyUSGD4nK9qHhC/8MgE4HZICz4HZ5lm
         DeRX/3wdtxvaebIv2jrmcNs5AzB4tVb5vJP/h6TV+QESfDGHc+q5pk1OlspsWXepxJ
         3Fi89k1eYROjA==
Received: by paulmck-ThinkPad-P17-Gen-1.home (Postfix, from userid 1000)
        id CBB3A5C1B2A; Thu,  9 Feb 2023 20:11:03 -0800 (PST)
Date:   Thu, 9 Feb 2023 20:11:03 -0800
From:   "Paul E. McKenney" <paulmck@kernel.org>
To:     Usama Arif <usama.arif@bytedance.com>
Cc:     dwmw2@infradead.org, tglx@linutronix.de, kim.phillips@amd.com,
        arjan@linux.intel.com, mingo@redhat.com, bp@alien8.de,
        dave.hansen@linux.intel.com, hpa@zytor.com, x86@kernel.org,
        pbonzini@redhat.com, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, rcu@vger.kernel.org, mimoja@mimoja.de,
        hewenliang4@huawei.com, thomas.lendacky@amd.com, seanjc@google.com,
        pmenzel@molgen.mpg.de, fam.zheng@bytedance.com,
        punit.agrawal@bytedance.com, simon.evans@bytedance.com,
        liangma@liangbit.com
Subject: Re: [PATCH v8 0/9] Parallel CPU bringup for x86_64
Message-ID: <20230210041103.GO2948950@paulmck-ThinkPad-P17-Gen-1>
Reply-To: paulmck@kernel.org
References: <20230209154156.266385-1-usama.arif@bytedance.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230209154156.266385-1-usama.arif@bytedance.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Feb 09, 2023 at 03:41:47PM +0000, Usama Arif wrote:
> The major change over v7 is fixing CPU0 hotplug not working as reported by
> Paul E. McKenney using rcu torture tests. This is fixed by setting up the
> initial_gs, initial_stack and early_gdt_descr properly for this case.
> 
> The improvement in boot time is the same as v7.

This one passes moderate rcutorture testing.

							Thanx, Paul

> Thanks,
> Usama
> 
> Changes across versions:
> v2: Cut it back to just INIT/SIPI/SIPI in parallel for now, nothing more
> v3: Clean up x2apic patch, add MTRR optimisation, lock topology update
>     in preparation for more parallelisation.
> v4: Fixes to the real mode parallelisation patch spotted by SeanC, to
>     avoid scribbling on initial_gs in common_cpu_up(), and to allow all
>     24 bits of the physical X2APIC ID to be used. That patch still needs
>     a Signed-off-by from its original author, who once claimed not to
>     remember writing it at all. But now we've fixed it, hopefully he'll
>     admit it now :)
> v5: rebase to v6.1 and remeasure performance, disable parallel bringup
>     for AMD CPUs.
> v6: rebase to v6.2-rc6, disabled parallel boot on amd as a cpu bug and
>     reused timer calibration for secondary CPUs.
> v7: [David Woodhouse] iterate over all possible CPUs to find any existing
>     cluster mask in alloc_clustermask. (patch 1/9)
>     Keep parallel AMD support enabled in AMD, using APIC ID in CPUID leaf
>     0x0B (for x2APIC mode) or CPUID leaf 0x01 where 8 bits are sufficient.
>     Included sanity checks for APIC id from 0x0B. (patch 6/9)
>     Removed patch for reusing timer calibration for secondary CPUs.
>     commit message and code improvements.
> v8: Fix CPU0 hotplug by setting up the initial_gs, initial_stack and
>     early_gdt_descr.
>     Drop trampoline lock and bail if APIC ID not found in find_cpunr.
>     Code comments improved and debug prints added.
> 
> David Woodhouse (9):
>   x86/apic/x2apic: Allow CPU cluster_mask to be populated in parallel
>   cpu/hotplug: Move idle_thread_get() to <linux/smpboot.h>
>   cpu/hotplug: Add dynamic parallel bringup states before
>     CPUHP_BRINGUP_CPU
>   x86/smpboot: Reference count on smpboot_setup_warm_reset_vector()
>   x86/smpboot: Split up native_cpu_up into separate phases and document
>     them
>   x86/smpboot: Support parallel startup of secondary CPUs
>   x86/smpboot: Send INIT/SIPI/SIPI to secondary CPUs in parallel
>   x86/mtrr: Avoid repeated save of MTRRs on boot-time CPU bringup
>   x86/smpboot: Serialize topology updates for secondary bringup
> 
>  arch/x86/include/asm/realmode.h       |   3 +
>  arch/x86/include/asm/smp.h            |  14 +-
>  arch/x86/include/asm/topology.h       |   2 -
>  arch/x86/kernel/acpi/sleep.c          |   1 +
>  arch/x86/kernel/apic/apic.c           |   2 +-
>  arch/x86/kernel/apic/x2apic_cluster.c | 130 ++++++----
>  arch/x86/kernel/cpu/common.c          |   6 +-
>  arch/x86/kernel/cpu/mtrr/mtrr.c       |   9 +
>  arch/x86/kernel/head_64.S             |  99 +++++++-
>  arch/x86/kernel/smpboot.c             | 350 +++++++++++++++++++-------
>  arch/x86/realmode/init.c              |   3 +
>  arch/x86/realmode/rm/trampoline_64.S  |  14 ++
>  arch/x86/xen/smp_pv.c                 |   4 +-
>  include/linux/cpuhotplug.h            |   2 +
>  include/linux/smpboot.h               |   7 +
>  kernel/cpu.c                          |  31 ++-
>  kernel/smpboot.c                      |   2 +-
>  kernel/smpboot.h                      |   2 -
>  18 files changed, 521 insertions(+), 160 deletions(-)
> 
> -- 
> 2.25.1
> 
