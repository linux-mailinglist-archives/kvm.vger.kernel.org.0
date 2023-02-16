Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A101F698D18
	for <lists+kvm@lfdr.de>; Thu, 16 Feb 2023 07:34:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229632AbjBPGe4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 16 Feb 2023 01:34:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39876 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229485AbjBPGez (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 16 Feb 2023 01:34:55 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E8DBA43443;
        Wed, 15 Feb 2023 22:34:34 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6753B61DEE;
        Thu, 16 Feb 2023 06:34:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9B344C433D2;
        Thu, 16 Feb 2023 06:34:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1676529264;
        bh=TaJX0rn163ChcOickz0gpBby+9FDsJsRnGlfNP2/n08=;
        h=Date:From:To:Cc:Subject:Reply-To:References:In-Reply-To:From;
        b=CTRLfWbK9nXPSg32reC9xxHlkN2P2F9h2C4janWP1+afFUG2TXxtEwttiE63dTkrc
         FDAWQnqysZt4nwUe0N+5L8IXRbKcIVIax6cRorCDA3BAp4o+XPYAWmzM2tMK4PPouF
         tD++An5l193VmfJY/BPOEKMH+tAg5pwC4qPD0VXu/0tqpAGRbmv0k3MiDhIDfquThb
         d5bqFNsC4GPlyIeVZLETJxuKr0tOpBTcUCOvHc5GWC7YHwL7d5nlZkKdhsu/uUW2Lc
         Y0MRfr8uDWMY21D3e0TSltimT3W0+I0QTDVvXXqk4TQ8h7WR1pXvSCcHZ7zXAwkKd5
         NL2RMXKzosWjg==
Received: by paulmck-ThinkPad-P17-Gen-1.home (Postfix, from userid 1000)
        id 0BD465C164C; Wed, 15 Feb 2023 22:34:22 -0800 (PST)
Date:   Wed, 15 Feb 2023 22:34:22 -0800
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
Subject: Re: [PATCH v9 0/8] Parallel CPU bringup for x86_64
Message-ID: <20230216063422.GQ2948950@paulmck-ThinkPad-P17-Gen-1>
Reply-To: paulmck@kernel.org
References: <20230215145425.420125-1-usama.arif@bytedance.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230215145425.420125-1-usama.arif@bytedance.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Feb 15, 2023 at 02:54:17PM +0000, Usama Arif wrote:
> The main change over v8 is dropping the patch to avoid repeated saves of MTRR
> at boot time. It didn't make a difference to smpboot time and is independent
> of parallel CPU bringup, so if needed can be explored in a separate patchset.
> 
> The patches have also been rebased to v6.2-rc8 and retested and the
> improvement in boot time is the same as v8.

This version passes moderate torture testing.

Tested-by: Paul E. McKenney <paulmck@kernel.org>

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
> v9: Drop patch to avoid repeated saves of MTRR at boot time.
>     rebased and retested at v6.2-rc8.
>     added kernel doc for no_parallel_bringup and made do_parallel_bringup
>     __ro_after_init.
> 
> David Woodhouse (8):
>   x86/apic/x2apic: Allow CPU cluster_mask to be populated in parallel
>   cpu/hotplug: Move idle_thread_get() to <linux/smpboot.h>
>   cpu/hotplug: Add dynamic parallel bringup states before
>     CPUHP_BRINGUP_CPU
>   x86/smpboot: Reference count on smpboot_setup_warm_reset_vector()
>   x86/smpboot: Split up native_cpu_up into separate phases and document
>     them
>   x86/smpboot: Support parallel startup of secondary CPUs
>   x86/smpboot: Send INIT/SIPI/SIPI to secondary CPUs in parallel
>   x86/smpboot: Serialize topology updates for secondary bringup
> 
>  .../admin-guide/kernel-parameters.txt         |   3 +
>  arch/x86/include/asm/realmode.h               |   3 +
>  arch/x86/include/asm/smp.h                    |  14 +-
>  arch/x86/include/asm/topology.h               |   2 -
>  arch/x86/kernel/acpi/sleep.c                  |   1 +
>  arch/x86/kernel/apic/apic.c                   |   2 +-
>  arch/x86/kernel/apic/x2apic_cluster.c         | 130 ++++---
>  arch/x86/kernel/cpu/common.c                  |   6 +-
>  arch/x86/kernel/head_64.S                     |  99 ++++-
>  arch/x86/kernel/smpboot.c                     | 350 +++++++++++++-----
>  arch/x86/realmode/init.c                      |   3 +
>  arch/x86/realmode/rm/trampoline_64.S          |  14 +
>  arch/x86/xen/smp_pv.c                         |   4 +-
>  include/linux/cpuhotplug.h                    |   2 +
>  include/linux/smpboot.h                       |   7 +
>  kernel/cpu.c                                  |  31 +-
>  kernel/smpboot.c                              |   2 +-
>  kernel/smpboot.h                              |   2 -
>  18 files changed, 515 insertions(+), 160 deletions(-)
> 
> -- 
> 2.25.1
> 
