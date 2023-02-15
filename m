Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6C323697ED6
	for <lists+kvm@lfdr.de>; Wed, 15 Feb 2023 15:55:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229966AbjBOOzC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 15 Feb 2023 09:55:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50576 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230007AbjBOOy4 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 15 Feb 2023 09:54:56 -0500
Received: from mail-wr1-x42f.google.com (mail-wr1-x42f.google.com [IPv6:2a00:1450:4864:20::42f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7BCA939BA3
        for <kvm@vger.kernel.org>; Wed, 15 Feb 2023 06:54:30 -0800 (PST)
Received: by mail-wr1-x42f.google.com with SMTP id m10so10510488wrn.4
        for <kvm@vger.kernel.org>; Wed, 15 Feb 2023 06:54:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance-com.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=9w2EKztZ7EuQXoJVAfQNdvdvrxRKqCTapg/SniP1n60=;
        b=XK4oypLAtLCIO2Q13uJFbxhj/KuyPdeL1OJbQjdHmPmesWFUduwTAPoWC9KEtRXK4Q
         dYURbYp9cKQknFOjc6I62tThI1AddbZu82N76JgsTb4vKg9ofUn6ZeGwl4EnIRhruYP5
         S8wboKpGF1SG0RsFjQGE71WEr7KgyfRpI+fADxrP+lqzXAKKbbOaiKm6Q3F4ybM27FYa
         0J3tNDfqXKOaOfFnBg5ZYdIBckJrGoKhsRlXNRS8M0H/xQL5F5lvhMHCSD9k+89ENqBT
         0Tn362WYYCX4fKAX5wB2yMhUdtilOa5XpI2BU8jlE5lpQF8StBVgtgTOmYIIqNG7kS/P
         ZXUA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=9w2EKztZ7EuQXoJVAfQNdvdvrxRKqCTapg/SniP1n60=;
        b=RJLl6wuarLrAA9d6GonALmVdnx960qeYf0iP78NtcaILfrDpc/geEpH0nnGmpwJD53
         pIYjkG87q5ZYA8a1NrOid9yHpEIEJEVb4AWq2AdcuMRRZxqom4fFRkUsXrKYW/A1rt7Z
         tzPBhCWUezIffpBf5iRQkBhf/XEOGUofSmUhWrIx02tZixaKcg3EfSji9U9VoB9yOA5l
         qvKH1pfpHkrDYpV3OgXHJXxztEhnZGoWByzwxmK7gmMcwAWKoOkSzR3EDga3UoYzlHHP
         w/q5KODKKvbeREpl4fEm3KWmzeu1h9v1tpTgeh23jSrgx+xKjy5+9VV7AZPBm3jadCMF
         r+Gw==
X-Gm-Message-State: AO0yUKWXCkwMdoGRMNt4SHTMwNuTEBMxg8j62E3axCXH1h8tvJtrb5nz
        NjURt1ATjKblJhQgO6q1J5uSsw==
X-Google-Smtp-Source: AK7set9wBXsPzL5CwlORBM39Lj9g4NAGNwMINN8yS2hwbKsZzd+fXHgSwaAWXsYNuMM3G+iRq3T/Bg==
X-Received: by 2002:a05:6000:120e:b0:2c5:63df:1171 with SMTP id e14-20020a056000120e00b002c563df1171mr1906107wrx.19.1676472868970;
        Wed, 15 Feb 2023 06:54:28 -0800 (PST)
Received: from usaari01.cust.communityfibre.co.uk ([2a02:6b6a:b566:0:8487:6a9a:3a67:11aa])
        by smtp.gmail.com with ESMTPSA id t13-20020adfe44d000000b002c557f82e27sm8495508wrm.99.2023.02.15.06.54.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 15 Feb 2023 06:54:28 -0800 (PST)
From:   Usama Arif <usama.arif@bytedance.com>
To:     dwmw2@infradead.org, tglx@linutronix.de, kim.phillips@amd.com
Cc:     arjan@linux.intel.com, mingo@redhat.com, bp@alien8.de,
        dave.hansen@linux.intel.com, hpa@zytor.com, x86@kernel.org,
        pbonzini@redhat.com, paulmck@kernel.org,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        rcu@vger.kernel.org, mimoja@mimoja.de, hewenliang4@huawei.com,
        thomas.lendacky@amd.com, seanjc@google.com, pmenzel@molgen.mpg.de,
        fam.zheng@bytedance.com, punit.agrawal@bytedance.com,
        simon.evans@bytedance.com, liangma@liangbit.com,
        Usama Arif <usama.arif@bytedance.com>
Subject: [PATCH v9 0/8] Parallel CPU bringup for x86_64
Date:   Wed, 15 Feb 2023 14:54:17 +0000
Message-Id: <20230215145425.420125-1-usama.arif@bytedance.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The main change over v8 is dropping the patch to avoid repeated saves of MTRR
at boot time. It didn't make a difference to smpboot time and is independent
of parallel CPU bringup, so if needed can be explored in a separate patchset.

The patches have also been rebased to v6.2-rc8 and retested and the
improvement in boot time is the same as v8.

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
 arch/x86/include/asm/realmode.h               |   3 +
 arch/x86/include/asm/smp.h                    |  14 +-
 arch/x86/include/asm/topology.h               |   2 -
 arch/x86/kernel/acpi/sleep.c                  |   1 +
 arch/x86/kernel/apic/apic.c                   |   2 +-
 arch/x86/kernel/apic/x2apic_cluster.c         | 130 ++++---
 arch/x86/kernel/cpu/common.c                  |   6 +-
 arch/x86/kernel/head_64.S                     |  99 ++++-
 arch/x86/kernel/smpboot.c                     | 350 +++++++++++++-----
 arch/x86/realmode/init.c                      |   3 +
 arch/x86/realmode/rm/trampoline_64.S          |  14 +
 arch/x86/xen/smp_pv.c                         |   4 +-
 include/linux/cpuhotplug.h                    |   2 +
 include/linux/smpboot.h                       |   7 +
 kernel/cpu.c                                  |  31 +-
 kernel/smpboot.c                              |   2 +-
 kernel/smpboot.h                              |   2 -
 18 files changed, 515 insertions(+), 160 deletions(-)

-- 
2.25.1

