Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E1749686FF3
	for <lists+kvm@lfdr.de>; Wed,  1 Feb 2023 21:46:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229958AbjBAUpN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 1 Feb 2023 15:45:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53258 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229991AbjBAUpK (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 1 Feb 2023 15:45:10 -0500
Received: from mail-wm1-x332.google.com (mail-wm1-x332.google.com [IPv6:2a00:1450:4864:20::332])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 76AF578AE5
        for <kvm@vger.kernel.org>; Wed,  1 Feb 2023 12:44:48 -0800 (PST)
Received: by mail-wm1-x332.google.com with SMTP id j29-20020a05600c1c1d00b003dc52fed235so2428064wms.1
        for <kvm@vger.kernel.org>; Wed, 01 Feb 2023 12:44:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance-com.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=MBkUStfA+iDGjKKAM+4p8+0mIlG33iS9Y15joN7auaU=;
        b=p8tndsXy9zB48jq6U4H/0wBOP0dK7C9M6YI8SpeKZhYJkxaHanw6+Ix1tUU231B/5k
         QSuqVj3WcIbAArBi3dVGZOsJDyxJwzhPUUnIIjBaEJ8rMjetZrs8qfNnBx7OHdB6r3SI
         FC8ehdA/NTaFV4Jm/4yQb6tH65UEYu5nNm26PTL0b+TL0RT3h1fE0yH6V3XqRXrC9myu
         +m7w9k8yH36blhlSClNqJZq1G3TG2auYToYac5s3EuQfM5OhNVoc2bjZVshe9VwvoRuX
         WUvJq8W8Uw84kVvU0dwsJa3q23Zy8nNz5nXE7Go6KIbBHTg7DGYgUKvu0kOqXgS7uIos
         ziYw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=MBkUStfA+iDGjKKAM+4p8+0mIlG33iS9Y15joN7auaU=;
        b=nbUU37vysScwhnDNc+90+ouIBlH3gYDkPvLvGJ1BncTsRlKmBPk0+AYJ8X3eB/5vUR
         apfgX8Ny+55LncZMj/lRH9ZCzbdmamQONBNB/2EznHBI1NgFNDH9NMsimooaq7keKhcm
         i3JuhU0qk5S0YRJxqWP6mBrdOAIK8Aw3zHr+cQVzAX4Y3DR+/Q1VM7b9eHh8foR+xRGg
         1JxiW0nXYrBXB5zaOf8BihGIasjWNDNM0BRaATg/JmxFQ1Mf8o7ZD71V6k8Ra093/Zhh
         Ur/b9rqqHXS//zqImdnyxq4W1q2RHFyuzTp7UQKiSrKpCnFzy3fUadEq759FeIoYUeaW
         SdzQ==
X-Gm-Message-State: AO0yUKXpXf48yLkupcmBewae7KxqaZWHgBmlaXY128aGI+JV9hqKVFtA
        XLgwQT6kskkSJLiBiKPZZ0a2Hl9nO2D+q8x8zRw=
X-Google-Smtp-Source: AK7set/wpf35la+9i2edsJCL7KpWtiHynmdfZv2wHgxuiVprFgfzOXT73CCMouPrU1yUSANu63rOsQ==
X-Received: by 2002:a05:600c:16c4:b0:3dc:16d2:ae5e with SMTP id l4-20020a05600c16c400b003dc16d2ae5emr3423164wmn.32.1675284286944;
        Wed, 01 Feb 2023 12:44:46 -0800 (PST)
Received: from usaari01.cust.communityfibre.co.uk ([2a02:6b6a:b566:0:7611:c340:3d8d:d46c])
        by smtp.gmail.com with ESMTPSA id n15-20020a5d598f000000b002bdff778d87sm19993584wri.34.2023.02.01.12.44.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 01 Feb 2023 12:44:46 -0800 (PST)
From:   Usama Arif <usama.arif@bytedance.com>
To:     dwmw2@infradead.org, tglx@linutronix.de
Cc:     mingo@redhat.com, bp@alien8.de, dave.hansen@linux.intel.com,
        hpa@zytor.com, x86@kernel.org, pbonzini@redhat.com,
        paulmck@kernel.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, rcu@vger.kernel.org, mimoja@mimoja.de,
        hewenliang4@huawei.com, thomas.lendacky@amd.com, seanjc@google.com,
        pmenzel@molgen.mpg.de, fam.zheng@bytedance.com,
        punit.agrawal@bytedance.com, simon.evans@bytedance.com,
        liangma@liangbit.com, Usama Arif <usama.arif@bytedance.com>
Subject: [PATCH 0/9] Parallel CPU bringup for x86_64
Date:   Wed,  1 Feb 2023 20:43:29 +0000
Message-Id: <20230201204338.1337562-1-usama.arif@bytedance.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This patchseries is from the work done by David Woodhouse (v4: https://lore.kernel.org/all/20220201205328.123066-1-dwmw2@infradead.org/).
The parallel CPU bringup is disabled for all AMD CPUs in this version: (see discussions: https://lore.kernel.org/all/bc3f2b1332c4bb77558df8aa36493a55542fe5b9.camel@infradead.org/ and
https://lore.kernel.org/all/3b6ac86fdc800cac5806433daf14a9095be101e9.camel@infradead.org/).

Doing INIT/SIPI/SIPI in parallel brings down the time for smpboot from ~700ms
to 100ms (85% improvement) on a server with 128 CPUs split across 2 NUMA
nodes.

Adding another cpuhp state for do_wait_cpu_initialized to make sure cpu_init
is reached in parallel as proposed by David in v1 will bring it down further
to ~30ms. Making this change would be dependent on this patchseries, so they
could be explored if this gets merged.

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

David Woodhouse (8):
  x86/apic/x2apic: Fix parallel handling of cluster_mask
  cpu/hotplug: Move idle_thread_get() to <linux/smpboot.h>
  cpu/hotplug: Add dynamic parallel bringup states before
    CPUHP_BRINGUP_CPU
  x86/smpboot: Reference count on smpboot_setup_warm_reset_vector()
  x86/smpboot: Split up native_cpu_up into separate phases and document
    them
  x86/smpboot: Send INIT/SIPI/SIPI to secondary CPUs in parallel
  x86/mtrr: Avoid repeated save of MTRRs on boot-time CPU bringup
  x86/smpboot: Serialize topology updates for secondary bringup

Thomas Gleixner (1):
  x86/smpboot: Support parallel startup of secondary CPUs

 arch/x86/include/asm/realmode.h       |   3 +
 arch/x86/include/asm/smp.h            |  13 +-
 arch/x86/include/asm/topology.h       |   2 -
 arch/x86/kernel/acpi/sleep.c          |   1 +
 arch/x86/kernel/apic/apic.c           |   2 +-
 arch/x86/kernel/apic/x2apic_cluster.c | 108 +++++----
 arch/x86/kernel/cpu/common.c          |   6 +-
 arch/x86/kernel/cpu/mtrr/mtrr.c       |   9 +
 arch/x86/kernel/head_64.S             |  73 ++++++
 arch/x86/kernel/smpboot.c             | 324 ++++++++++++++++++--------
 arch/x86/realmode/init.c              |   3 +
 arch/x86/realmode/rm/trampoline_64.S  |  14 ++
 arch/x86/xen/smp_pv.c                 |   4 +-
 include/linux/cpuhotplug.h            |   2 +
 include/linux/smpboot.h               |   7 +
 kernel/cpu.c                          |  27 ++-
 kernel/smpboot.c                      |   2 +-
 kernel/smpboot.h                      |   2 -
 18 files changed, 443 insertions(+), 159 deletions(-)

-- 
2.25.1

