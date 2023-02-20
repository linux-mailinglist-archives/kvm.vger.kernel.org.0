Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5A7CC69D132
	for <lists+kvm@lfdr.de>; Mon, 20 Feb 2023 17:17:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232178AbjBTQRk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 20 Feb 2023 11:17:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33256 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231346AbjBTQRj (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 20 Feb 2023 11:17:39 -0500
X-Greylist: delayed 538 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Mon, 20 Feb 2023 08:17:37 PST
Received: from vulcan.natalenko.name (vulcan.natalenko.name [IPv6:2001:19f0:6c00:8846:5400:ff:fe0c:dfa0])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 94C6D6193;
        Mon, 20 Feb 2023 08:17:37 -0800 (PST)
Received: from spock.localnet (unknown [83.148.33.151])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by vulcan.natalenko.name (Postfix) with ESMTPSA id 02623123964E;
        Mon, 20 Feb 2023 17:08:34 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=natalenko.name;
        s=dkim-20170712; t=1676909315;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=e6XF2Mly5uci1etXydiI+TP9d1uuQZIXE3ICU4vlUTw=;
        b=VMENmGm5tydIgyf48jG/O8TYEBhpM5St8bruDWHTLiyXc3ag6Sinv9jRREfJ8KVedhOER3
        Z5/RkRNcXSpmDn1BBtxBjnXe5VVguia30JnT2hRLYy8AA5ZCJL8DsRMAyiqLgnH6KIMQKf
        WUCKzD1suspBieYrxR0plX52TbkJt94=
From:   Oleksandr Natalenko <oleksandr@natalenko.name>
To:     dwmw2@infradead.org, tglx@linutronix.de, kim.phillips@amd.com,
        Usama Arif <usama.arif@bytedance.com>
Cc:     arjan@linux.intel.com, mingo@redhat.com, bp@alien8.de,
        dave.hansen@linux.intel.com, hpa@zytor.com, x86@kernel.org,
        pbonzini@redhat.com, paulmck@kernel.org,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        rcu@vger.kernel.org, mimoja@mimoja.de, hewenliang4@huawei.com,
        thomas.lendacky@amd.com, seanjc@google.com, pmenzel@molgen.mpg.de,
        fam.zheng@bytedance.com, punit.agrawal@bytedance.com,
        simon.evans@bytedance.com, liangma@liangbit.com,
        Usama Arif <usama.arif@bytedance.com>
Subject: Re: [PATCH v9 0/8] Parallel CPU bringup for x86_64
Date:   Mon, 20 Feb 2023 17:08:32 +0100
Message-ID: <2668799.mvXUDI8C0e@natalenko.name>
In-Reply-To: <20230215145425.420125-1-usama.arif@bytedance.com>
References: <20230215145425.420125-1-usama.arif@bytedance.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hello.

On st=C5=99eda 15. =C3=BAnora 2023 15:54:17 CET Usama Arif wrote:
> The main change over v8 is dropping the patch to avoid repeated saves of =
MTRR
> at boot time. It didn't make a difference to smpboot time and is independ=
ent
> of parallel CPU bringup, so if needed can be explored in a separate patch=
set.
>=20
> The patches have also been rebased to v6.2-rc8 and retested and the
> improvement in boot time is the same as v8.
>=20
> Thanks,
> Usama
>=20
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
>=20
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
>=20
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

I've applied this to the v6.2 kernel, and suspend/resume broke on my Ryzen =
5950X desktop. The machine suspends just fine, but on resume the screen sta=
ys blank, and there's no visible disk I/O.

Reverting the series brings suspend/resume back to working state.

=2D-=20
Oleksandr Natalenko (post-factum)


