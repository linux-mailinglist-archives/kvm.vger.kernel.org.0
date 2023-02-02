Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D907068895B
	for <lists+kvm@lfdr.de>; Thu,  2 Feb 2023 22:57:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233233AbjBBV5R (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 2 Feb 2023 16:57:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54904 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233112AbjBBV5E (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 2 Feb 2023 16:57:04 -0500
Received: from mail-wr1-x430.google.com (mail-wr1-x430.google.com [IPv6:2a00:1450:4864:20::430])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E37355D905
        for <kvm@vger.kernel.org>; Thu,  2 Feb 2023 13:56:31 -0800 (PST)
Received: by mail-wr1-x430.google.com with SMTP id d14so2981518wrr.9
        for <kvm@vger.kernel.org>; Thu, 02 Feb 2023 13:56:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance-com.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=nflrbvUgv2oevNGFK8fKYdaOnsJQhpHjx4vgWukFzaw=;
        b=Sa/5uWxp0EGHnk2ouNlrcuW+xmdnnOOmo959km5JrXCv4AO8epKqQnW7S+MSBRPljY
         HagfH8ZV6YjboeGM+uSniy2prbQbPkLg/u70SRUyCP7PDdxG/htl8pyu/wX9GLn4xWZY
         Uz99ExtSpBdxWk1Su6uu35hdI0Q67Tva2lJKlqNIsM5BmypVFG7VBatco2+tEsRZg3cU
         qq75MZqcUHEnQdrk6y2Muqf1TTBlex9evMlqsdeVlnOXzOa1IDMf/Oo8eLBJGHHf7DNg
         xfw+YnohBTY4wPmgyKJYqs4U9S1DFr731+QV64Vw15bo0jrBZ0rYScSyDnO0wwmoF37c
         nPAQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=nflrbvUgv2oevNGFK8fKYdaOnsJQhpHjx4vgWukFzaw=;
        b=ULrt7Hl1hhYJ5ADrb0S46x8XsU4QajFnqNqoXDqAO1kRmViXy/2/btIvb4CY9cRdNL
         6YFGrEIwC8ionk3dwrrWSHIIK4HTKTHXcVBTclP7Cp1/Ssywf9yd5uqbPJAZaDbe0Ujd
         bHq4EtQ6ZvUZq09PM2u2JkS5tJKMmCaX6x1CZoTyzmVTgUIdPeQHBSzVQIhhGfIEJuwf
         4BAq0HSZj8Qe2jTcvx8SoHEXZ2OmZGg2AijF+feC44hmMRE2LVWx8E69lk4IF0reab5w
         ORhsQ9LeWW6ZhbcFht07Jfh+8SR4EieXeONwldllrMrmRUys5lnLD/79gks3Gh/5Ids/
         ptzQ==
X-Gm-Message-State: AO0yUKUisdhEyBirT5uFRkqk5Mp3oGJSP/1kYcWQikVFkzKRn0G6A5iQ
        aSHsduty8yaY7+jEbTU4JIKz3w==
X-Google-Smtp-Source: AK7set+aAM3fDyBlAfrGxQ7DeT0Tj3pP34v7H0RlsQSmiCWF7nHHXf3OwcGoRt6pcFW0OR/AjfrEfA==
X-Received: by 2002:adf:e9ca:0:b0:2c3:c4cd:2e28 with SMTP id l10-20020adfe9ca000000b002c3c4cd2e28mr3013325wrn.26.1675374990384;
        Thu, 02 Feb 2023 13:56:30 -0800 (PST)
Received: from usaari01.cust.communityfibre.co.uk ([2a02:6b6a:b566:0:98fe:e4ee:fc7e:cd71])
        by smtp.gmail.com with ESMTPSA id e8-20020a5d6d08000000b00297dcfdc90fsm506078wrq.24.2023.02.02.13.56.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 02 Feb 2023 13:56:29 -0800 (PST)
From:   Usama Arif <usama.arif@bytedance.com>
To:     dwmw2@infradead.org, tglx@linutronix.de, arjan@linux.intel.com
Cc:     mingo@redhat.com, bp@alien8.de, dave.hansen@linux.intel.com,
        hpa@zytor.com, x86@kernel.org, pbonzini@redhat.com,
        paulmck@kernel.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, rcu@vger.kernel.org, mimoja@mimoja.de,
        hewenliang4@huawei.com, thomas.lendacky@amd.com, seanjc@google.com,
        pmenzel@molgen.mpg.de, fam.zheng@bytedance.com,
        punit.agrawal@bytedance.com, simon.evans@bytedance.com,
        liangma@liangbit.com, Usama Arif <usama.arif@bytedance.com>
Subject: [PATCH v6 00/11] Parallel CPU bringup for x86_64
Date:   Thu,  2 Feb 2023 21:56:14 +0000
Message-Id: <20230202215625.3248306-1-usama.arif@bytedance.com>
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

Doing INIT/SIPI/SIPI in parallel brings down the time for smpboot from ~700ms
to 100ms (85% improvement) on a server with 128 CPUs split across 2 NUMA nodes.
The parallel CPU bringup is disabled for all AMD CPUs in this version: 
(see discussions: https://lore.kernel.org/all/bc3f2b1332c4bb77558df8aa36493a55542fe5b9.camel@infradead.org/ and
https://lore.kernel.org/all/3b6ac86fdc800cac5806433daf14a9095be101e9.camel@infradead.org/).

The last patch reuses the timer calibration from CPU 0 for secondary CPUs
which brings down the time for parallel smpboot from 100ms to 30ms. It is
missing a sign-off from the author, which hopefully Arjan will add.

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

Arjan van de Ven (1):
  x86/smpboot: reuse timer calibration

David Woodhouse (9):
  x86/apic/x2apic: Fix parallel handling of cluster_mask
  cpu/hotplug: Move idle_thread_get() to <linux/smpboot.h>
  cpu/hotplug: Add dynamic parallel bringup states before
    CPUHP_BRINGUP_CPU
  x86/smpboot: Reference count on smpboot_setup_warm_reset_vector()
  x86/smpboot: Split up native_cpu_up into separate phases and document
    them
  x86/smpboot: Disable parallel boot for AMD CPUs
  x86/smpboot: Send INIT/SIPI/SIPI to secondary CPUs in parallel
  x86/mtrr: Avoid repeated save of MTRRs on boot-time CPU bringup
  x86/smpboot: Serialize topology updates for secondary bringup

Thomas Gleixner (1):
  x86/smpboot: Support parallel startup of secondary CPUs

 arch/x86/include/asm/cpufeatures.h    |   1 +
 arch/x86/include/asm/realmode.h       |   3 +
 arch/x86/include/asm/smp.h            |  13 +-
 arch/x86/include/asm/topology.h       |   2 -
 arch/x86/kernel/acpi/sleep.c          |   1 +
 arch/x86/kernel/apic/apic.c           |   2 +-
 arch/x86/kernel/apic/x2apic_cluster.c | 108 +++++----
 arch/x86/kernel/cpu/amd.c             |  11 +
 arch/x86/kernel/cpu/common.c          |   6 +-
 arch/x86/kernel/cpu/mtrr/mtrr.c       |   9 +
 arch/x86/kernel/head_64.S             |  75 ++++++
 arch/x86/kernel/smpboot.c             | 333 ++++++++++++++++++--------
 arch/x86/kernel/tsc.c                 |   3 +
 arch/x86/realmode/init.c              |   3 +
 arch/x86/realmode/rm/trampoline_64.S  |  14 ++
 arch/x86/xen/smp_pv.c                 |   4 +-
 include/linux/cpuhotplug.h            |   2 +
 include/linux/smpboot.h               |   7 +
 kernel/cpu.c                          |  27 ++-
 kernel/smpboot.c                      |   2 +-
 kernel/smpboot.h                      |   2 -
 21 files changed, 469 insertions(+), 159 deletions(-)

-- 
2.25.1

