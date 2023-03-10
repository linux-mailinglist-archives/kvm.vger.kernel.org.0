Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E1A126B50E2
	for <lists+kvm@lfdr.de>; Fri, 10 Mar 2023 20:21:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231363AbjCJTVa (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 10 Mar 2023 14:21:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35242 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229580AbjCJTVY (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 10 Mar 2023 14:21:24 -0500
Received: from mout-p-101.mailbox.org (mout-p-101.mailbox.org [IPv6:2001:67c:2050:0:465::101])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 73D9A132BFA;
        Fri, 10 Mar 2023 11:21:14 -0800 (PST)
Received: from smtp202.mailbox.org (smtp202.mailbox.org [IPv6:2001:67c:2050:b231:465::202])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mout-p-101.mailbox.org (Postfix) with ESMTPS id 4PYG9w5CGVz9sSg;
        Fri, 10 Mar 2023 20:21:08 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mailbox.org; s=mail20150812;
        t=1678476068;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=LcYGd1/e2TxnVo/Nykvxyvg5HOuPY1jiueiJQW2bu0k=;
        b=ktub/gRxYcjJP5DYSbaReocn+QKlGpv01U8pCyc0S9Bd9xnT3kl7ZgzZ8I8REYnv791ovZ
        neKwv9t3wIDgk1L9WLg9Z0frKB2ThewjRKBqd1My+hhrl4CoTmgKJTNhD87hxf6lMbGAPX
        FmrUporAv2qTdTtHwTozv5978gQD2XfLDB6ffG6XE/vgci84CgY/ZJWC3r4pafa/Zk6oqL
        to/epgatbTsxOIKZRnRU4/cJvXYBIDaPE0pXtKc/wpD3MmolJxpq+RqPaYE5d3SmxmBxG2
        GbDqemNvrBmn4MUw2Qs8lWW74yaHsU/K4PnIDdqunY1B3IyVSqCinAJVhZuR9A==
Message-ID: <16d9f738-18fd-a929-e711-f2a1e757e33f@mailbox.org>
Date:   Fri, 10 Mar 2023 19:20:56 +0000
MIME-Version: 1.0
Subject: Re: [PATCH v14 00/12] Parallel CPU bringup for x86_64
To:     Usama Arif <usama.arif@bytedance.com>, dwmw2@infradead.org,
        tglx@linutronix.de, kim.phillips@amd.com, brgerst@gmail.com
Cc:     piotrgorski@cachyos.org, oleksandr@natalenko.name,
        arjan@linux.intel.com, mingo@redhat.com, bp@alien8.de,
        dave.hansen@linux.intel.com, hpa@zytor.com, x86@kernel.org,
        pbonzini@redhat.com, paulmck@kernel.org,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        rcu@vger.kernel.org, mimoja@mimoja.de, hewenliang4@huawei.com,
        thomas.lendacky@amd.com, seanjc@google.com, pmenzel@molgen.mpg.de,
        fam.zheng@bytedance.com, punit.agrawal@bytedance.com,
        simon.evans@bytedance.com, liangma@liangbit.com
References: <20230308171328.1562857-1-usama.arif@bytedance.com>
Content-Language: en-US
From:   Tor Vic <torvic9@mailbox.org>
In-Reply-To: <20230308171328.1562857-1-usama.arif@bytedance.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-MBO-RS-ID: 0b61b0862a564b2e27f
X-MBO-RS-META: wrc5czsm3dap5qh9hq756znyyj3bc7qi
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,
        SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 08.03.23 17:13, Usama Arif wrote:
> The main code change over v13 is to enable parallel bringup for SEV-ES guests.
> 
> Thanks,
> Usama
> 
> Changes across versions:
> v2: Cut it back to just INIT/SIPI/SIPI in parallel for now, nothing more
> v3: Clean up x2apic patch, add MTRR optimisation, lock topology update
>      in preparation for more parallelisation.
> v4: Fixes to the real mode parallelisation patch spotted by SeanC, to
>      avoid scribbling on initial_gs in common_cpu_up(), and to allow all
>      24 bits of the physical X2APIC ID to be used. That patch still needs
>      a Signed-off-by from its original author, who once claimed not to
>      remember writing it at all. But now we've fixed it, hopefully he'll
>      admit it now :)
> v5: rebase to v6.1 and remeasure performance, disable parallel bringup
>      for AMD CPUs.
> v6: rebase to v6.2-rc6, disabled parallel boot on amd as a cpu bug and
>      reused timer calibration for secondary CPUs.
> v7: [David Woodhouse] iterate over all possible CPUs to find any existing
>      cluster mask in alloc_clustermask. (patch 1/9)
>      Keep parallel AMD support enabled in AMD, using APIC ID in CPUID leaf
>      0x0B (for x2APIC mode) or CPUID leaf 0x01 where 8 bits are sufficient.
>      Included sanity checks for APIC id from 0x0B. (patch 6/9)
>      Removed patch for reusing timer calibration for secondary CPUs.
>      commit message and code improvements.
> v8: Fix CPU0 hotplug by setting up the initial_gs, initial_stack and
>      early_gdt_descr.
>      Drop trampoline lock and bail if APIC ID not found in find_cpunr.
>      Code comments improved and debug prints added.
> v9: Drop patch to avoid repeated saves of MTRR at boot time.
>      rebased and retested at v6.2-rc8.
>      added kernel doc for no_parallel_bringup and made do_parallel_bringup
>      __ro_after_init.
> v10: Fixed suspend/resume not working with parallel smpboot.
>       rebased and retested to 6.2.
>       fixed checkpatch errors.
> v11: Added patches from Brian Gerst to remove the global variables initial_gs,
>       initial_stack, and early_gdt_descr from the 64-bit boot code
>       (https://lore.kernel.org/all/20230222221301.245890-1-brgerst@gmail.com/).
> v12: Fixed compilation errors, acquire tr_lock for every stack setup in
>       trampoline_64.S.
>       Rearranged commits for a cleaner git history.
> v13: Fix build error with CONFIG_FORCE_NR_CPUS.
>       Commit message improved, typos fixed and extra comments added.
> v14: Enable parallel bringup for SEV-ES guests
>   
> Brian Gerst (3):
>    x86/smpboot: Remove initial_stack on 64-bit
>    x86/smpboot: Remove early_gdt_descr on 64-bit
>    x86/smpboot: Remove initial_gs
> 
> David Woodhouse (9):
>    x86/apic/x2apic: Allow CPU cluster_mask to be populated in parallel
>    cpu/hotplug: Move idle_thread_get() to <linux/smpboot.h>
>    cpu/hotplug: Add dynamic parallel bringup states before
>      CPUHP_BRINGUP_CPU
>    x86/smpboot: Reference count on smpboot_setup_warm_reset_vector()
>    x86/smpboot: Split up native_cpu_up into separate phases and document
>      them
>    x86/smpboot: Support parallel startup of secondary CPUs
>    x86/smpboot: Send INIT/SIPI/SIPI to secondary CPUs in parallel
>    x86/smpboot: Serialize topology updates for secondary bringup
>    x86/smpboot: Allow parallel bringup for SEV-ES
> 
>   .../admin-guide/kernel-parameters.txt         |   3 +
>   arch/x86/include/asm/cpu.h                    |   1 +
>   arch/x86/include/asm/processor.h              |   6 +-
>   arch/x86/include/asm/realmode.h               |   4 +-
>   arch/x86/include/asm/sev-common.h             |   3 +
>   arch/x86/include/asm/sev.h                    |   5 +
>   arch/x86/include/asm/smp.h                    |  18 +-
>   arch/x86/include/asm/topology.h               |   2 -
>   arch/x86/kernel/acpi/sleep.c                  |  30 +-
>   arch/x86/kernel/apic/apic.c                   |   2 +-
>   arch/x86/kernel/apic/x2apic_cluster.c         | 126 +++---
>   arch/x86/kernel/asm-offsets.c                 |   1 +
>   arch/x86/kernel/cpu/common.c                  |   6 +-
>   arch/x86/kernel/cpu/topology.c                |   2 +-
>   arch/x86/kernel/head_64.S                     | 162 ++++++--
>   arch/x86/kernel/smpboot.c                     | 366 +++++++++++++-----
>   arch/x86/realmode/init.c                      |   3 +
>   arch/x86/realmode/rm/trampoline_64.S          |  27 +-
>   arch/x86/xen/smp_pv.c                         |   4 +-
>   arch/x86/xen/xen-head.S                       |   2 +-
>   include/linux/cpuhotplug.h                    |   2 +
>   include/linux/smpboot.h                       |   7 +
>   kernel/cpu.c                                  |  31 +-
>   kernel/smpboot.h                              |   2 -
>   24 files changed, 614 insertions(+), 201 deletions(-)
> 

On Linux 6.2, Zen2 and Skylake, no issues or boot problems:

Tested-by: Tor Vic <torvic9@mailbox.org>
