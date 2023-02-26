Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BF3D46A2F2B
	for <lists+kvm@lfdr.de>; Sun, 26 Feb 2023 12:08:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229379AbjBZLIM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 26 Feb 2023 06:08:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35938 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229524AbjBZLIL (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 26 Feb 2023 06:08:11 -0500
Received: from mail-wm1-x334.google.com (mail-wm1-x334.google.com [IPv6:2a00:1450:4864:20::334])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BF299D329
        for <kvm@vger.kernel.org>; Sun, 26 Feb 2023 03:08:06 -0800 (PST)
Received: by mail-wm1-x334.google.com with SMTP id o11-20020a05600c4fcb00b003eb33ea29a8so1679756wmq.1
        for <kvm@vger.kernel.org>; Sun, 26 Feb 2023 03:08:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=GawLq6sXWJN/1WHYnp+2zBrOk2xJHj1hXqH/NT0T7I4=;
        b=kXoRFYCLpYTp8qz4tdCgAhDJxtdtb/mx2vFCSCb6mD15c0dL1yFHj/MgB2OeSjHIuJ
         3fCaBZyU7UuXGjUCCceMezapSEwXlsjgLe3obXIsrRRZailA/bnj6R1SrpJuDFN/zDJ4
         PKqSpfmHsilEohAIfWRfe9WZHMC0BD5MgmTJ0QgXAuaq4BFCe7rUwUjE0aNzF5qRLzPs
         /IdB/GSPN/FYZM/vu1BNqyMY/jNEx5mW526knJYwTP6/hp5SjelN/MpsTzMBypXfnevT
         +U37KK40YuEuZsRnR0aA/U0gG9zKNuK5/roUOxyeqRttD/KUJdhVOE2funTo3+TogDsp
         ZIWA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=GawLq6sXWJN/1WHYnp+2zBrOk2xJHj1hXqH/NT0T7I4=;
        b=JffvQ26O3aZQ7k1gh2M51KdkdBqZNk/6msItyjuU/JKC2T4BtZ7dOHpG2SmAjin102
         JQ4MwXhLnCbSaLwVbcDk1X71vqZNBBsn+SwHW/ZQIa/9DIyQFJvNvumq5YWGUvPHDrri
         YsOajJEDhqBx5oCKWcODeVF3TfebLvNmyWaZLCeDazlFwhBlREO48DqxEZwIYxNRtlBn
         9e6oWgR+lSvDOXANqy93NpDzIEdmLjt7FLNgvPUdBp+eEFff5kbUK3toUGgygl2JXwGM
         yKx/4khq93f55goDNKbYIrjo8UEPF7WgjbaRMQwjV0iU5mJXwJPpudVWkAKuXfCmLE+A
         wsQw==
X-Gm-Message-State: AO0yUKWkyeQsHjOdCd4xylEMO5Yq/f3A/ShFpFDgkHQZPbd5Odhug2n9
        IHNyJ+wjyBoL+i5R0eA4WBex4w==
X-Google-Smtp-Source: AK7set/GmrgwOClHRkXMb1tgaxs+/NnvWqhl4MK75goxCw5ZPdVY/jRyD+aKUZ2KpFIo7jO1SQrLPA==
X-Received: by 2002:a05:600c:329d:b0:3eb:39c3:8844 with SMTP id t29-20020a05600c329d00b003eb39c38844mr1655392wmp.12.1677409685144;
        Sun, 26 Feb 2023 03:08:05 -0800 (PST)
Received: from usaari01.cust.communityfibre.co.uk ([2a02:6b6a:b566:0:df7b:4668:3e23:d0c9])
        by smtp.gmail.com with ESMTPSA id v22-20020a1cf716000000b003e1fee8baacsm9157318wmh.25.2023.02.26.03.08.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 26 Feb 2023 03:08:04 -0800 (PST)
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
        Usama Arif <usama.arif@bytedance.com>
Subject: [PATCH v12 00/11] Parallel CPU bringup for x86_64
Date:   Sun, 26 Feb 2023 11:07:51 +0000
Message-Id: <20230226110802.103134-1-usama.arif@bytedance.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The main code change over v11 is the build error fix by Brian Gerst and
acquiring tr_lock in trampoline_64.S whenever the stack is setup.

The git history is also rewritten to move the commits that removed
initial_stack, early_gdt_descr and initial_gs earlier in the patchset.

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

Brian Gerst (3):
  x86/smpboot: Remove initial_stack on 64-bit
  x86/smpboot: Remove early_gdt_descr on 64-bit
  x86/smpboot: Remove initial_gs

David Woodhouse (8):
  x86/apic/x2apic: Allow CPU cluster_mask to be populated in parallel
  cpu/hotplug: Move idle_thread_get() to <linux/smpboot.h>
  cpu/hotplug: Add dynamic parallel bringup states before
    CPUHP_BRINGUP_CPU
  x86/smpboot: Reference count on smpboot_setup_warm_reset_vector()
  x86/smpboot: Split up native_cpu_up into separate phases and document
    them
  x86/smpboot: Support parallel startup of secondary CPUs
  x86/smpboot: Send INIT/SIPI/SIPI to secondary CPUs in parallel
  x86/smpboot: Serialize topology updates for secondary bringup

 .../admin-guide/kernel-parameters.txt         |   3 +
 arch/x86/include/asm/processor.h              |   6 +-
 arch/x86/include/asm/realmode.h               |   4 +-
 arch/x86/include/asm/smp.h                    |  15 +-
 arch/x86/include/asm/topology.h               |   2 -
 arch/x86/kernel/acpi/sleep.c                  |  15 +-
 arch/x86/kernel/apic/apic.c                   |   2 +-
 arch/x86/kernel/apic/x2apic_cluster.c         | 126 ++++---
 arch/x86/kernel/asm-offsets.c                 |   1 +
 arch/x86/kernel/cpu/common.c                  |   6 +-
 arch/x86/kernel/head_64.S                     | 129 +++++--
 arch/x86/kernel/smpboot.c                     | 350 +++++++++++++-----
 arch/x86/realmode/init.c                      |   3 +
 arch/x86/realmode/rm/trampoline_64.S          |  27 +-
 arch/x86/xen/smp_pv.c                         |   4 +-
 arch/x86/xen/xen-head.S                       |   2 +-
 include/linux/cpuhotplug.h                    |   2 +
 include/linux/smpboot.h                       |   7 +
 kernel/cpu.c                                  |  31 +-
 kernel/smpboot.h                              |   2 -
 20 files changed, 537 insertions(+), 200 deletions(-)

-- 
2.25.1

