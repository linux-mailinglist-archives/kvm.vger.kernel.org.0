Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 860416CCB0F
	for <lists+kvm@lfdr.de>; Tue, 28 Mar 2023 21:58:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229756AbjC1T6k (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 28 Mar 2023 15:58:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42654 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229749AbjC1T6g (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 28 Mar 2023 15:58:36 -0400
Received: from mail-wr1-x436.google.com (mail-wr1-x436.google.com [IPv6:2a00:1450:4864:20::436])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D27073C0F
        for <kvm@vger.kernel.org>; Tue, 28 Mar 2023 12:58:01 -0700 (PDT)
Received: by mail-wr1-x436.google.com with SMTP id j24so13447175wrd.0
        for <kvm@vger.kernel.org>; Tue, 28 Mar 2023 12:58:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1680033480;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=idaRv/1WNtgD31Z/L8uF4ozvP49BG2CNqJUpm5ENzNo=;
        b=h0HwqvAwn7NMrvh8dGUsAvz1Ej/b4pwBLxpXDXHR5qNmeVNgbBKWlDIxB0Fqdn4+Iw
         7OuB6jiqgPMXPUfCO27xpwIiRRn15SMLlwDdDhkEEJN99zIp09WUYtk3T03EVhhXamHz
         DKpfWOJA0ZiEby8Kwe/C9jK3NFYVeCRVnocCGhc5P6u1qrE4AZqbvWWt9xylcp3wt0Ip
         vP540dw8F3G8deLwf7FxfrnTl9FuKC6U2j/uVe3lSTtdTrCK/pJ84p2Y+f0ZELkMuHYs
         KaO0zz39EI5QCTfuAtOf3xdY1zxbJSslkt17ueuB9WwW/ujq8v+HKFRClT5mULHTi94c
         aoqQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680033480;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=idaRv/1WNtgD31Z/L8uF4ozvP49BG2CNqJUpm5ENzNo=;
        b=Ujv176CGEdtQzQ+IxrfRZuIzty0ptPddnxjUVxbFOYJ6s8Lb5SNs8ClTuHIYM5ETLa
         8uUj2ybJT4Wfcqc2hkhROQH3PUKdO960ziN6WzjKNK0GbdvtgKgKQKjSCAhmN2UIlUzA
         mCz7ZGE85hd6hUDauFSzcmRhg66LWTFjuKxvbjjX5Ni+N1zbNJsi1w4C9lVO204R6pGC
         /3fTJ3pOrPazRSO0wofxiOr988HJK5fjVeG5aVR2TjJwwbjRNCT6tvgcQ1w2HSKIPAF+
         kCOa23gdKmGrXwqBesWFfEFHfzMzvFGwxXEETgGTMqVrIXdTymBP98qkcQwhw+GeFAlX
         qF3Q==
X-Gm-Message-State: AAQBX9czD1SpFG+8nH7ZfSjeqapXbp+GdRFK+e0SuqXzeuVIRryIwsQC
        75hWtYjiAWz+NFZPuSofj3jGCw==
X-Google-Smtp-Source: AKy350Z5+R5FQg0B9g0Y0cMHXVv2gCrgJTtFbuQ/pJw3xdq+3Ijd4RltJXROCRkpSQr8rVIx5vc6FA==
X-Received: by 2002:a5d:452e:0:b0:2cf:ef01:1def with SMTP id j14-20020a5d452e000000b002cfef011defmr12842417wra.30.1680033480304;
        Tue, 28 Mar 2023 12:58:00 -0700 (PDT)
Received: from usaari01.cust.communityfibre.co.uk ([2a02:6b6a:b566:0:8445:3123:91d7:959d])
        by smtp.gmail.com with ESMTPSA id z6-20020a056000110600b002c557f82e27sm28248386wrw.99.2023.03.28.12.57.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 28 Mar 2023 12:57:59 -0700 (PDT)
From:   Usama Arif <usama.arif@bytedance.com>
To:     dwmw2@infradead.org, tglx@linutronix.de, kim.phillips@amd.com,
        brgerst@gmail.com
Cc:     piotrgorski@cachyos.org, oleksandr@natalenko.name,
        arjan@linux.intel.com, mingo@redhat.com, bp@alien8.de,
        dave.hansen@linux.intel.com, hpa@zytor.com, x86@kernel.org,
        pbonzini@redhat.com, paulmck@kernel.org,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        rcu@vger.kernel.org, mimoja@mimoja.de, hewenliang4@huawei.com,
        thomas.lendacky@amd.com, seanjc@google.com, pmenzel@molgen.mpg.de,
        fam.zheng@bytedance.com, punit.agrawal@bytedance.com,
        simon.evans@bytedance.com, liangma@liangbit.com,
        gpiccoli@igalia.com, Usama Arif <usama.arif@bytedance.com>
Subject: [PATCH v17 0/8] Parallel CPU bringup for x86_64
Date:   Tue, 28 Mar 2023 20:57:50 +0100
Message-Id: <20230328195758.1049469-1-usama.arif@bytedance.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This version changes the number of cpuhp_states reserved for parallel bringup
from 4 (CPUHP_BP_PARALLEL_DYN to CPUHP_BP_PARALLEL_DYN_END) to 1
CPUHP_BP_PARALLEL_STARTUP.

Thanks,
Usama

Changes across versions:
v2: Cut it back to just INIT/SIPI/SIPI in parallel for now, nothing more
v3: Clean up x2apic patch, add MTRR optimisation, lock topology update
    in preparation for more parallelisation.
v4: Fixes to the real mode parallelisation patch spotted by SeanC, to
    avoid scribbling on initial_gs in common_cpu_up(), and to allow all
    24 bits of the physical X2APIC ID to be used. That patch still needs
    a Signed-off-by from its original author, who once claimed not to
    remember writing it at all. But now we've fixed it, hopefully he'll
    admit it now :)
v5: rebase to v6.1 and remeasure performance, disable parallel bringup
    for AMD CPUs.
v6: rebase to v6.2-rc6, disabled parallel boot on amd as a cpu bug and
    reused timer calibration for secondary CPUs.
v7: [David Woodhouse] iterate over all possible CPUs to find any existing
    cluster mask in alloc_clustermask. (patch 1/9)
    Keep parallel AMD support enabled in AMD, using APIC ID in CPUID leaf
    0x0B (for x2APIC mode) or CPUID leaf 0x01 where 8 bits are sufficient.
    Included sanity checks for APIC id from 0x0B. (patch 6/9)
    Removed patch for reusing timer calibration for secondary CPUs.
    commit message and code improvements.
v8: Fix CPU0 hotplug by setting up the initial_gs, initial_stack and
    early_gdt_descr.
    Drop trampoline lock and bail if APIC ID not found in find_cpunr.
    Code comments improved and debug prints added.
v9: Drop patch to avoid repeated saves of MTRR at boot time.
    rebased and retested at v6.2-rc8.
    added kernel doc for no_parallel_bringup and made do_parallel_bringup
    __ro_after_init.
v10: Fixed suspend/resume not working with parallel smpboot.
     rebased and retested to 6.2.
     fixed checkpatch errors.
v11: Added patches from Brian Gerst to remove the global variables initial_gs,
     initial_stack, and early_gdt_descr from the 64-bit boot code
     (https://lore.kernel.org/all/20230222221301.245890-1-brgerst@gmail.com/).
v12: Fixed compilation errors, acquire tr_lock for every stack setup in
     trampoline_64.S.
     Rearranged commits for a cleaner git history.
v13: Fix build error with CONFIG_FORCE_NR_CPUS.
     Commit message improved, typos fixed and extra comments added.
v14: Enable parallel bringup for SEV-ES guests.
v15: use vendor parallel_smp when platform has CC_ATTR_GUEST_STATE_ENCRYPT.
     Call smpboot_restore_warm_reset_vector incase any of the steps in
     native_cpu_up fail.
     Reset stale stack and kasan unpoison in bringup_cpu
     Release trampoline_lock a bit earlier.
v16: Roll back to CPUHP_OFFLINE on failure in parallel bringup case.
     Release trampoline_lock earlier, just before setup_gdt.
     Rebase to x86/apic (Linux 6.3-rc3).
v17: Change number of states for parallel bringup to one.

David Woodhouse (8):
  cpu/hotplug: Move idle_thread_get() to <linux/smpboot.h>
  cpu/hotplug: Reset task stack state in _cpu_up()
  cpu/hotplug: Add CPUHP_BP_PARALLEL_STARTUP state before
    CPUHP_BRINGUP_CPU
  x86/smpboot: Split up native_cpu_up into separate phases and document
    them
  x86/smpboot: Support parallel startup of secondary CPUs
  x86/smpboot: Send INIT/SIPI/SIPI to secondary CPUs in parallel
  x86/smpboot: Serialize topology updates for secondary bringup
  x86/smpboot: Allow parallel bringup for SEV-ES

 .../admin-guide/kernel-parameters.txt         |   3 +
 arch/x86/coco/core.c                          |   5 +
 arch/x86/include/asm/coco.h                   |   1 +
 arch/x86/include/asm/cpu.h                    |   1 +
 arch/x86/include/asm/realmode.h               |   3 +
 arch/x86/include/asm/sev-common.h             |   3 +
 arch/x86/include/asm/smp.h                    |  13 +-
 arch/x86/include/asm/topology.h               |   2 -
 arch/x86/kernel/acpi/sleep.c                  |   9 +-
 arch/x86/kernel/apic/apic.c                   |   2 +-
 arch/x86/kernel/cpu/common.c                  |   6 +-
 arch/x86/kernel/cpu/topology.c                |   3 +-
 arch/x86/kernel/head_64.S                     |  97 +++++
 arch/x86/kernel/smpboot.c                     | 345 +++++++++++++-----
 arch/x86/realmode/init.c                      |   3 +
 arch/x86/realmode/rm/trampoline_64.S          |  27 +-
 arch/x86/xen/smp_pv.c                         |   4 +-
 include/linux/cpuhotplug.h                    |  22 ++
 include/linux/smpboot.h                       |   7 +
 kernel/cpu.c                                  |  50 ++-
 kernel/smpboot.h                              |   2 -
 21 files changed, 492 insertions(+), 116 deletions(-)

-- 
2.25.1

