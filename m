Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CDAE8697EDC
	for <lists+kvm@lfdr.de>; Wed, 15 Feb 2023 15:55:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230040AbjBOOzU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 15 Feb 2023 09:55:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50974 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229963AbjBOOzH (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 15 Feb 2023 09:55:07 -0500
Received: from mail-wr1-x42e.google.com (mail-wr1-x42e.google.com [IPv6:2a00:1450:4864:20::42e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C688939BBE
        for <kvm@vger.kernel.org>; Wed, 15 Feb 2023 06:54:36 -0800 (PST)
Received: by mail-wr1-x42e.google.com with SMTP id by3so18116395wrb.10
        for <kvm@vger.kernel.org>; Wed, 15 Feb 2023 06:54:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance-com.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=JJkpGg1hd8P6OX4RPHIkrzOMjPz7lmvjqBeU21FPpuA=;
        b=tcdHg6gL/+kmrDf6TMBwvnFfIcz101nGGz3Inam8TJELR9NPia/44bKe58cCe0wion
         KHhYTtM5JQHVGWkPIJQvS0Pg801b07Sz0tqEwOWT7VkqDg7FrNYl1ho3vnyTmQJyfBwd
         AKNb4Qbx/3QPWVMJ+ealo/onIWpVGrNLelRhBmyq9YVt99ApYhJ+jmpXsMkCMwQCvTUR
         XcHyB3YqBuIx5oALw8ygnOcM4MeZHUhQmNkAysqnAOo8sCMHwQeVvHZR0R+bpWuLe5sq
         Cr7eqqqA6NjXSDEX5DbcmXdJ5jFBjeC7+t5h+aIFic37yrx73YXF1y5DxCQ8rVp7qUF7
         4Pcw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=JJkpGg1hd8P6OX4RPHIkrzOMjPz7lmvjqBeU21FPpuA=;
        b=Ru9zB6sIaEseUnmRavDMfT8g3KKj+GTqkDGrvWEwwwmf2NW6zOkERzPapXyAUphVr9
         8ry+1YRNK9T7MsgRUViSTmi22OLnJX+n2ClsgLGv8r9K8PWu4vvNUjAtGeQ0ZmbSOjA6
         aJQqzUWSGMyZDoztvj3daPBSwO75qGoLjhANJbHvYsAlg69aJNHPqeIxG1DaDBMJgUSr
         rZT3KcyGBqPFWkE+3AsH5jxNwekU/iyBUgLV1HmUdzPt44PhBynOHUnaptyTVnPk6JVH
         eZJrty6voIjaVsmWxfZicJN5AJszUM4wDUxmH2UFNJJC+CgMrTBrQfuilQt/8yTKXLj/
         nE8w==
X-Gm-Message-State: AO0yUKVdPzd+FsDDepEDzGUSn9vW7Ok9HkcYgixKfhCdMMZJe42Thfda
        4PfJchWBsVQ3VqVSjCogJ7Bkkg==
X-Google-Smtp-Source: AK7set/T0pWPr2ac0iFIDBkuMj5fFQH6npYOyPRhDiy7cZKHer4TH0/f/yhlUIQu8bqE+A2MmHWpbg==
X-Received: by 2002:a5d:68c1:0:b0:2c5:58f5:3c40 with SMTP id p1-20020a5d68c1000000b002c558f53c40mr1698253wrw.47.1676472875295;
        Wed, 15 Feb 2023 06:54:35 -0800 (PST)
Received: from usaari01.cust.communityfibre.co.uk ([2a02:6b6a:b566:0:8487:6a9a:3a67:11aa])
        by smtp.gmail.com with ESMTPSA id t13-20020adfe44d000000b002c557f82e27sm8495508wrm.99.2023.02.15.06.54.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 15 Feb 2023 06:54:34 -0800 (PST)
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
        David Woodhouse <dwmw@amazon.co.uk>,
        Usama Arif <usama.arif@bytedance.com>
Subject: [PATCH v9 7/8] x86/smpboot: Send INIT/SIPI/SIPI to secondary CPUs in parallel
Date:   Wed, 15 Feb 2023 14:54:24 +0000
Message-Id: <20230215145425.420125-8-usama.arif@bytedance.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20230215145425.420125-1-usama.arif@bytedance.com>
References: <20230215145425.420125-1-usama.arif@bytedance.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: David Woodhouse <dwmw@amazon.co.uk>

When the APs can find their own APIC ID without assistance, perform the
AP bringup in parallel.

Register a CPUHP_BP_PARALLEL_DYN stage "x86/cpu:kick" which just calls
do_boot_cpu() to deliver INIT/SIPI/SIPI to each AP in turn before the
normal native_cpu_up() does the rest of the hand-holding.

The APs will then take turns through the real mode code (which has its
own bitlock for exclusion) until they make it to their own stack, then
proceed through the first few lines of start_secondary() and execute
these parts in parallel:

 start_secondary()
    -> cr4_init()
    -> (some 32-bit only stuff so not in the parallel cases)
    -> cpu_init_secondary()
       -> cpu_init_exception_handling()
       -> cpu_init()
          -> wait_for_master_cpu()

At this point they wait for the BSP to set their bit in cpu_callout_mask
(from do_wait_cpu_initialized()), and release them to continue through
the rest of cpu_init() and beyond.

This reduces the time taken for bringup on my 28-thread Haswell system
from about 120ms to 80ms. On a socket 96-thread Skylake it takes the
bringup time from 500ms to 100ms.

There is more speedup to be had by doing the remaining parts in parallel
too — especially notify_cpu_starting() in which the AP takes itself
through all the stages from CPUHP_BRINGUP_CPU to CPUHP_ONLINE. But those
require careful auditing to ensure they are reentrant, before we can go
that far.

[Usama Arif: fixed rebase conflict]
Signed-off-by: David Woodhouse <dwmw@amazon.co.uk>
Signed-off-by: Usama Arif <usama.arif@bytedance.com>
---
 arch/x86/kernel/smpboot.c | 21 ++++++++++++++++++---
 1 file changed, 18 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kernel/smpboot.c b/arch/x86/kernel/smpboot.c
index 49d6563e4c23..4cea3a0ff503 100644
--- a/arch/x86/kernel/smpboot.c
+++ b/arch/x86/kernel/smpboot.c
@@ -57,6 +57,7 @@
 #include <linux/pgtable.h>
 #include <linux/overflow.h>
 #include <linux/stackprotector.h>
+#include <linux/smpboot.h>
 
 #include <asm/acpi.h>
 #include <asm/cacheinfo.h>
@@ -1325,9 +1326,12 @@ int native_cpu_up(unsigned int cpu, struct task_struct *tidle)
 {
 	int ret;
 
-	ret = do_cpu_up(cpu, tidle);
-	if (ret)
-		return ret;
+	/* If parallel AP bringup isn't enabled, perform the first steps now. */
+	if (!do_parallel_bringup) {
+		ret = do_cpu_up(cpu, tidle);
+		if (ret)
+			return ret;
+	}
 
 	ret = do_wait_cpu_initialized(cpu);
 	if (ret)
@@ -1349,6 +1353,12 @@ int native_cpu_up(unsigned int cpu, struct task_struct *tidle)
 	return ret;
 }
 
+/* Bringup step one: Send INIT/SIPI to the target AP */
+static int native_cpu_kick(unsigned int cpu)
+{
+	return do_cpu_up(cpu, idle_thread_get(cpu));
+}
+
 /**
  * arch_disable_smp_support() - disables SMP support for x86 at runtime
  */
@@ -1566,6 +1576,11 @@ void __init native_smp_prepare_cpus(unsigned int max_cpus)
 		smpboot_control = STARTUP_SECONDARY | STARTUP_APICID_CPUID_01;
 	}
 
+	if (do_parallel_bringup) {
+		cpuhp_setup_state_nocalls(CPUHP_BP_PARALLEL_DYN, "x86/cpu:kick",
+					  native_cpu_kick, NULL);
+	}
+
 	snp_set_wakeup_secondary_cpu();
 }
 
-- 
2.25.1

