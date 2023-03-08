Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5FBE66B0FF2
	for <lists+kvm@lfdr.de>; Wed,  8 Mar 2023 18:13:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229786AbjCHRNu (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 8 Mar 2023 12:13:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56982 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229760AbjCHRNr (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 8 Mar 2023 12:13:47 -0500
Received: from mail-wm1-x332.google.com (mail-wm1-x332.google.com [IPv6:2a00:1450:4864:20::332])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DDE6C3B67B
        for <kvm@vger.kernel.org>; Wed,  8 Mar 2023 09:13:32 -0800 (PST)
Received: by mail-wm1-x332.google.com with SMTP id t25-20020a1c7719000000b003eb052cc5ccso1807233wmi.4
        for <kvm@vger.kernel.org>; Wed, 08 Mar 2023 09:13:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1678295611;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=5Hbd9XxfEHV1OJLQFkD6huyFI87+kHUzsYgNvadq9ro=;
        b=VbM39aUkBb6MZLrUtznBsn7M6L1Jpk274NlRplE7z13AYroWy2VxSrZPFffDMdI7cQ
         dmp9r9zVIP8nQiXgRoNCUeNgZd7y0TApSThRSn3CxvArGSk9zviFpJURRrk46yYe6cGe
         Vdu17uscUhhmxZKdgZ1PD5g3ni2HxvsoGOi2IqEWPoaYmxo8cOlbP20fre1/ucsz4LJq
         YN2OzURIxGrYLL56rPNP6ghvpSWjN++ESzUVBh08EX9KUQ0Mg0baOHe2xmrBaXwYTR+d
         UrfHWtGiQdmVj/ignDNSAqXQonpeuTj9mqmEzDQR7ij378Mn24u6daBnhg/i4ncGXFq4
         JcPw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678295611;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=5Hbd9XxfEHV1OJLQFkD6huyFI87+kHUzsYgNvadq9ro=;
        b=SrIQTM8J3BFZeI/1oibUwC2q9u3NnBU87BfLTyT9QiTiT1FGyzd13BKy3Tnmi3zacX
         r5hmA57KC1ll0yGhxa8/gRY2uZ1S1w9fse5bOQx6IeTvU9Un7JIAJdMMetEgId/3poK0
         vJT3TXMOFKp2hLF++WWRLS+W09/vB+8GMbkcgJ8hpCjObTRCVcnJNwPDdRRIIRMyExQI
         Vpf+7xVZePlDhHUZe2TkjCBM0nTA0LGwdao8f1kjlnmq/cgrsoBu4HgPUVeiLF7VXzTC
         FQ5bVxNwXWg7kVEbS8ge/C6I2tTG2seX9FYz/Yz2TzSNZEo3jMuFCaUXrpjSiFY+vqlK
         U4eg==
X-Gm-Message-State: AO0yUKVeGQcCKZBjLOs6axKMJLC+uyFgS7AlJewnTGYGYe5EFhvWSGwV
        UF63HyAtuY5oIMGEUlkKmnPRMg==
X-Google-Smtp-Source: AK7set/2pclT+0jyD/CpDkqDgtgAsIgDoMOFzt/fZtH/PIq3cke44cz4F9GV5i7sumV/4Q4hpcgohw==
X-Received: by 2002:a05:600c:4f11:b0:3df:ef18:b0a1 with SMTP id l17-20020a05600c4f1100b003dfef18b0a1mr16958315wmq.12.1678295611256;
        Wed, 08 Mar 2023 09:13:31 -0800 (PST)
Received: from usaari01.cust.communityfibre.co.uk ([2a02:6b6a:b566:0:fe40:3ba4:afe4:4609])
        by smtp.gmail.com with ESMTPSA id l15-20020a1c790f000000b003e0238d9101sm11668wme.31.2023.03.08.09.13.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 08 Mar 2023 09:13:30 -0800 (PST)
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
Subject: [PATCH v14 00/12] Parallel CPU bringup for x86_64
Date:   Wed,  8 Mar 2023 17:13:16 +0000
Message-Id: <20230308171328.1562857-1-usama.arif@bytedance.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The main code change over v13 is to enable parallel bringup for SEV-ES guests.

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
v14: Enable parallel bringup for SEV-ES guests
 
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
 arch/x86/include/asm/cpu.h                    |   1 +
 arch/x86/include/asm/processor.h              |   6 +-
 arch/x86/include/asm/realmode.h               |   4 +-
 arch/x86/include/asm/sev-common.h             |   3 +
 arch/x86/include/asm/sev.h                    |   5 +
 arch/x86/include/asm/smp.h                    |  18 +-
 arch/x86/include/asm/topology.h               |   2 -
 arch/x86/kernel/acpi/sleep.c                  |  30 +-
 arch/x86/kernel/apic/apic.c                   |   2 +-
 arch/x86/kernel/apic/x2apic_cluster.c         | 126 +++---
 arch/x86/kernel/asm-offsets.c                 |   1 +
 arch/x86/kernel/cpu/common.c                  |   6 +-
 arch/x86/kernel/cpu/topology.c                |   2 +-
 arch/x86/kernel/head_64.S                     | 162 ++++++--
 arch/x86/kernel/smpboot.c                     | 366 +++++++++++++-----
 arch/x86/realmode/init.c                      |   3 +
 arch/x86/realmode/rm/trampoline_64.S          |  27 +-
 arch/x86/xen/smp_pv.c                         |   4 +-
 arch/x86/xen/xen-head.S                       |   2 +-
 include/linux/cpuhotplug.h                    |   2 +
 include/linux/smpboot.h                       |   7 +
 kernel/cpu.c                                  |  31 +-
 kernel/smpboot.h                              |   2 -
 24 files changed, 614 insertions(+), 201 deletions(-)

-- 
2.25.1

