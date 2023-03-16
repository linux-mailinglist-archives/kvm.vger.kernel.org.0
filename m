Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AED936BDB79
	for <lists+kvm@lfdr.de>; Thu, 16 Mar 2023 23:21:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230221AbjCPWVp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 16 Mar 2023 18:21:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60616 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229955AbjCPWVm (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 16 Mar 2023 18:21:42 -0400
Received: from mail-wm1-x334.google.com (mail-wm1-x334.google.com [IPv6:2a00:1450:4864:20::334])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B1FCBB06EE
        for <kvm@vger.kernel.org>; Thu, 16 Mar 2023 15:21:13 -0700 (PDT)
Received: by mail-wm1-x334.google.com with SMTP id w11so1189213wmo.2
        for <kvm@vger.kernel.org>; Thu, 16 Mar 2023 15:21:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1679005272;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=1y2Lqj93bBefH84AiipmoBHTVl61wcm3FFg4LLyQYT0=;
        b=IF+Pa+L/g7OzVFhd+q08SCNHv6yogi8O+SFhA9rUSf9rZO5EEGif9z9cJzr/TMyA3n
         HOprNIHEF8v+PT9HR9z4pY/qmuK9CY4m75+z32O76d3jdNKMKUaR5cXmqHN7alz1z5Vu
         MOiNmrptLJucGHTj/Z89vmG6n/W/89/3Fnh8icL5tKpxD9ofRlK0tRI3+G+oD02JyobB
         +bUiXqwEpoeE1nYcfacRkgHU8067uM0C3b5KPm8kx2ca3QYfF2SBMXOF7BRtIf5nbSbG
         R9k4/8HQBEEYhOdPCVlty4SshvJ5vpGfyIpDlii65qUZWHcTBsONis8uDicr/mqO9Wmz
         foiw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679005272;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=1y2Lqj93bBefH84AiipmoBHTVl61wcm3FFg4LLyQYT0=;
        b=raumyPF7ZI06CDhS3yv14j2rFZ4UGqQokgeqLywUx26U39NJh8FPLq34FBJj9/cdQ8
         Gvu44uRq2KuLbufz32l5MDNvhLFWa3qudSWK9vWBjwQMQ+yzTPWy3pPRgCRjgy3i/vsB
         2NdHVlKCuF0gHSMacO+SurqwoK4HU8714zaaA7kgfFjYGCs5jEzuEFhOcUTDmCV3AS3P
         wfXojoK4rrtc38GUpCrx47DRpdSj6+/KkU2PsRsOMqtjEjzQpVkbSzhq5iIN8WYf4m8o
         RbPltN2iHMxNPR7Sk6ztqV0wxOYsaR71ilXNyPTfnxrr6GJHDwuhvLGHzkXO9n4SCz0G
         +HJA==
X-Gm-Message-State: AO0yUKWax5llRtpst95bdEnUZSFjNnit2DOukN00jiyqTOoeZm1XOh1B
        v4dEzML83NzryfxFU5SWWhDaZQ==
X-Google-Smtp-Source: AK7set8veksH0zQ26bm13wG6BWeIPHNXe5Bn3bgvqG2TyTh2MNfpeGworOx7WUxwXmy/qGD3X7iNiw==
X-Received: by 2002:a05:600c:4453:b0:3eb:1432:a78c with SMTP id v19-20020a05600c445300b003eb1432a78cmr23822327wmn.37.1679005272193;
        Thu, 16 Mar 2023 15:21:12 -0700 (PDT)
Received: from usaari01.cust.communityfibre.co.uk ([2a02:6b6a:b566:0:4b87:78c3:3abe:7b0d])
        by smtp.gmail.com with ESMTPSA id f9-20020adff989000000b002cea392f000sm439256wrr.69.2023.03.16.15.21.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 16 Mar 2023 15:21:11 -0700 (PDT)
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
Subject: [PATCH v15 00/12] Parallel CPU bringup for x86_64
Date:   Thu, 16 Mar 2023 22:20:57 +0000
Message-Id: <20230316222109.1940300-1-usama.arif@bytedance.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This version includes the following changes over v14:
- use vendor instead of sev_es_active function to check if parallel_smp is to
  be done when platform has CC_ATTR_GUEST_STATE_ENCRYPT.
- Call smpboot_restore_warm_reset_vector incase any of the steps in
  native_cpu_up fail.
- Reset stale stack and kasan unpoison in bringup_cpu (Pulled into
  idle_thread_get function)
- Release the trampoline_lock a bit earlier.

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
 
Brian Gerst (3):
  x86/smpboot: Remove initial_stack on 64-bit
  x86/smpboot: Remove early_gdt_descr on 64-bit
  x86/smpboot: Remove initial_gs

David Woodhouse (9):
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
  x86/smpboot: Allow parallel bringup for SEV-ES

 .../admin-guide/kernel-parameters.txt         |   3 +
 arch/x86/coco/core.c                          |   5 +
 arch/x86/include/asm/coco.h                   |   1 +
 arch/x86/include/asm/cpu.h                    |   1 +
 arch/x86/include/asm/processor.h              |   6 +-
 arch/x86/include/asm/realmode.h               |   4 +-
 arch/x86/include/asm/sev-common.h             |   3 +
 arch/x86/include/asm/smp.h                    |  18 +-
 arch/x86/include/asm/topology.h               |   2 -
 arch/x86/kernel/acpi/sleep.c                  |  30 +-
 arch/x86/kernel/apic/apic.c                   |   2 +-
 arch/x86/kernel/apic/x2apic_cluster.c         | 126 +++---
 arch/x86/kernel/asm-offsets.c                 |   1 +
 arch/x86/kernel/cpu/common.c                  |   6 +-
 arch/x86/kernel/cpu/topology.c                |   3 +-
 arch/x86/kernel/head_64.S                     | 167 ++++++--
 arch/x86/kernel/smpboot.c                     | 372 +++++++++++++-----
 arch/x86/realmode/init.c                      |   3 +
 arch/x86/realmode/rm/trampoline_64.S          |  27 +-
 arch/x86/xen/smp_pv.c                         |   4 +-
 arch/x86/xen/xen-head.S                       |   2 +-
 include/linux/cpuhotplug.h                    |   2 +
 include/linux/smpboot.h                       |  10 +
 kernel/cpu.c                                  |  44 ++-
 kernel/smpboot.c                              |  11 +-
 kernel/smpboot.h                              |   2 -
 26 files changed, 641 insertions(+), 214 deletions(-)

-- 
2.25.1

