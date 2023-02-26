Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4DFCA6A3373
	for <lists+kvm@lfdr.de>; Sun, 26 Feb 2023 19:31:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229709AbjBZSbK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 26 Feb 2023 13:31:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34006 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229527AbjBZSbJ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 26 Feb 2023 13:31:09 -0500
Received: from vulcan.natalenko.name (vulcan.natalenko.name [104.207.131.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 53C2412F27;
        Sun, 26 Feb 2023 10:31:06 -0800 (PST)
Received: from spock.localnet (unknown [83.148.33.151])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by vulcan.natalenko.name (Postfix) with ESMTPSA id 3C72C124587F;
        Sun, 26 Feb 2023 19:31:02 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=natalenko.name;
        s=dkim-20170712; t=1677436262;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=4zMKzdv+H1/om27+Ol+jZwDzK7IdqC+zbT4tEg6lz2w=;
        b=wEEFmnlOyeAjPqTmHAUavneZVihn9R+KhiDoFEwCnvXViMQFMweTHUaZb6X0NwuMjdRMyD
        7fzym001Q1H+Hvqx86lMJzs3eo3yMUhZwJ6S1EOUZyQET8zQY3dpWyfZGVmsy4ULKVek7y
        /PflMiO9SJLHhhhri2WLQGoXqC1E0h0=
From:   Oleksandr Natalenko <oleksandr@natalenko.name>
To:     dwmw2@infradead.org, tglx@linutronix.de, kim.phillips@amd.com,
        brgerst@gmail.com, Usama Arif <usama.arif@bytedance.com>
Cc:     piotrgorski@cachyos.org, arjan@linux.intel.com, mingo@redhat.com,
        bp@alien8.de, dave.hansen@linux.intel.com, hpa@zytor.com,
        x86@kernel.org, pbonzini@redhat.com, paulmck@kernel.org,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        rcu@vger.kernel.org, mimoja@mimoja.de, hewenliang4@huawei.com,
        thomas.lendacky@amd.com, seanjc@google.com, pmenzel@molgen.mpg.de,
        fam.zheng@bytedance.com, punit.agrawal@bytedance.com,
        simon.evans@bytedance.com, liangma@liangbit.com,
        Usama Arif <usama.arif@bytedance.com>
Subject: Re: [PATCH v12 00/11] Parallel CPU bringup for x86_64
Date:   Sun, 26 Feb 2023 19:31:00 +0100
Message-ID: <5650744.DvuYhMxLoT@natalenko.name>
In-Reply-To: <20230226110802.103134-1-usama.arif@bytedance.com>
References: <20230226110802.103134-1-usama.arif@bytedance.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hello.

On ned=C4=9Ble 26. =C3=BAnora 2023 12:07:51 CET Usama Arif wrote:
> The main code change over v11 is the build error fix by Brian Gerst and
> acquiring tr_lock in trampoline_64.S whenever the stack is setup.
>=20
> The git history is also rewritten to move the commits that removed
> initial_stack, early_gdt_descr and initial_gs earlier in the patchset.
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
> v10: Fixed suspend/resume not working with parallel smpboot.
>      rebased and retested to 6.2.
>      fixed checkpatch errors.
> v11: Added patches from Brian Gerst to remove the global variables initia=
l_gs,
>      initial_stack, and early_gdt_descr from the 64-bit boot code
>      (https://lore.kernel.org/all/20230222221301.245890-1-brgerst@gmail.c=
om/).
> v12: Fixed compilation errors, acquire tr_lock for every stack setup in
>      trampoline_64.S.
>      Rearranged commits for a cleaner git history.
>=20
> Brian Gerst (3):
>   x86/smpboot: Remove initial_stack on 64-bit
>   x86/smpboot: Remove early_gdt_descr on 64-bit
>   x86/smpboot: Remove initial_gs
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
>  arch/x86/include/asm/processor.h              |   6 +-
>  arch/x86/include/asm/realmode.h               |   4 +-
>  arch/x86/include/asm/smp.h                    |  15 +-
>  arch/x86/include/asm/topology.h               |   2 -
>  arch/x86/kernel/acpi/sleep.c                  |  15 +-
>  arch/x86/kernel/apic/apic.c                   |   2 +-
>  arch/x86/kernel/apic/x2apic_cluster.c         | 126 ++++---
>  arch/x86/kernel/asm-offsets.c                 |   1 +
>  arch/x86/kernel/cpu/common.c                  |   6 +-
>  arch/x86/kernel/head_64.S                     | 129 +++++--
>  arch/x86/kernel/smpboot.c                     | 350 +++++++++++++-----
>  arch/x86/realmode/init.c                      |   3 +
>  arch/x86/realmode/rm/trampoline_64.S          |  27 +-
>  arch/x86/xen/smp_pv.c                         |   4 +-
>  arch/x86/xen/xen-head.S                       |   2 +-
>  include/linux/cpuhotplug.h                    |   2 +
>  include/linux/smpboot.h                       |   7 +
>  kernel/cpu.c                                  |  31 +-
>  kernel/smpboot.h                              |   2 -
>  20 files changed, 537 insertions(+), 200 deletions(-)

With `CONFIG_FORCE_NR_CPUS=3Dy` this results in:

```
ld: vmlinux.o: in function `secondary_startup_64_no_verify':
(.head.text+0x10c): undefined reference to `nr_cpu_ids'
```

That's because in `arch/x86/kernel/head_64.S` `secondary_startup_64_no_veri=
fy()` refers to `nr_cpu_ids` under `#ifdef CONFIG_SMP`, but this symbol is =
available under the following conditions:

```
38 #if (NR_CPUS =3D=3D 1) || defined(CONFIG_FORCE_NR_CPUS)
39 #define nr_cpu_ids ((unsigned int)NR_CPUS)
40 #else
41 extern unsigned int nr_cpu_ids;
42 #endif

1090 #if (NR_CPUS > 1) && !defined(CONFIG_FORCE_NR_CPUS)
1091 /* Setup number of possible processor ids */
1092 unsigned int nr_cpu_ids __read_mostly =3D NR_CPUS;
1093 EXPORT_SYMBOL(nr_cpu_ids);
1094 #endif
```

So having `CONFIG_SMP=3Dy` and, for instance, `CONFIG_NR_CPUS=3D320`, it is=
 possible to compile out `EXPORT_SYMBOL(nr_cpu_ids);` if `CONFIG_FORCE_NR_C=
PUS=3Dy` is set.

=2D-=20
Oleksandr Natalenko (post-factum)


