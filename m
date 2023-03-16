Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B3C686BDB83
	for <lists+kvm@lfdr.de>; Thu, 16 Mar 2023 23:22:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230046AbjCPWV4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 16 Mar 2023 18:21:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60664 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230236AbjCPWVq (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 16 Mar 2023 18:21:46 -0400
Received: from mail-wr1-x42d.google.com (mail-wr1-x42d.google.com [IPv6:2a00:1450:4864:20::42d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C6A06B6D11
        for <kvm@vger.kernel.org>; Thu, 16 Mar 2023 15:21:23 -0700 (PDT)
Received: by mail-wr1-x42d.google.com with SMTP id o2so1467244wro.12
        for <kvm@vger.kernel.org>; Thu, 16 Mar 2023 15:21:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1679005281;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=RcZv3zbGH7k+CBej9wIKrUlEuzG8XkHUgLqLEwBzkYQ=;
        b=a80sFCpTfQlIpXTjBsvv7ruVIpaS8bqFb+SlrcuHl5I392mri/jymyx8NdqbaTK26C
         YdzkusJuVGbbG+cerQZAoFtmPsAeG83fpCop2fSPB4j7+NfDKhqyk+UUL/xyRPXD59UL
         m/JTjGaANhJbkCdXrbqxuO3fcULccPrNcnEkGek1+2CXQxorClocGjcOGE8ByYYHCa97
         HhZ2n2NqlKTG8F0FYunRXsj664X3UxvK7D/9mG68dxr1byoc1gYLOUFmoGFsb5FN/GWi
         +7lWXAqIY8D2vGoHqH8nVgsDFU32g88zJiNgPfmFXQFV2W5wivqgZrlZpo6nQhbIfU+e
         HfvQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679005281;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=RcZv3zbGH7k+CBej9wIKrUlEuzG8XkHUgLqLEwBzkYQ=;
        b=dTlNf59dWVMcXiHTp2Z8PrUGtyQMfTKhVzmKrXzyG7oncIYkwHctkZ/HT+UbFTytW+
         E9sK/xEkzP4+pN8oTRZGKCsNY+g5grOm61n+yXUJk1sYB9DFvp9tKpPJK0ih2nG7Ouse
         Ama80rqllsI7lDxjOc3/dMEBtiGciCM16UJ6WZdl7+0b3tBxWd4W6pZd6W5KI5xkmwZk
         d5XC9w8aqx+RNBr93Li77qef2p8VbXlTdMIJ/Kcbd+2wZKHGyVipm/JANjty2AkRQRcj
         /RoY2pkhrh1X3s9L3wffl43T4W0le4hXrZ6PKX+JA7cIThQTLaUld56i9QaqaK06YJMJ
         J+sg==
X-Gm-Message-State: AO0yUKW3nQ8Vo9lgzG5RGr7Kloswy9PKdTVWkLGQiPWS0Q41rXYDx60S
        EhuzvvLbvXpQbA2BWkqdNstpLA==
X-Google-Smtp-Source: AK7set+JpXWF25NwAX+ht8V3iJLxlUUHq0mfKzDa7qpQYKi8WWk8BzvgTlvojvDIhVIQLvbFznBLFw==
X-Received: by 2002:a5d:63c3:0:b0:2cf:e868:f789 with SMTP id c3-20020a5d63c3000000b002cfe868f789mr5360294wrw.48.1679005281208;
        Thu, 16 Mar 2023 15:21:21 -0700 (PDT)
Received: from usaari01.cust.communityfibre.co.uk ([2a02:6b6a:b566:0:4b87:78c3:3abe:7b0d])
        by smtp.gmail.com with ESMTPSA id f9-20020adff989000000b002cea392f000sm439256wrr.69.2023.03.16.15.21.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 16 Mar 2023 15:21:20 -0700 (PDT)
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
        gpiccoli@igalia.com, David Woodhouse <dwmw@amazon.co.uk>,
        Usama Arif <usama.arif@bytedance.com>
Subject: [PATCH v15 10/12] x86/smpboot: Send INIT/SIPI/SIPI to secondary CPUs in parallel
Date:   Thu, 16 Mar 2023 22:21:07 +0000
Message-Id: <20230316222109.1940300-11-usama.arif@bytedance.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20230316222109.1940300-1-usama.arif@bytedance.com>
References: <20230316222109.1940300-1-usama.arif@bytedance.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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

Signed-off-by: David Woodhouse <dwmw@amazon.co.uk>
Signed-off-by: Usama Arif <usama.arif@bytedance.com>
Tested-by: Paul E. McKenney <paulmck@kernel.org>
Tested-by: Kim Phillips <kim.phillips@amd.com>
Tested-by: Oleksandr Natalenko <oleksandr@natalenko.name>
Tested-by: Guilherme G. Piccoli <gpiccoli@igalia.com>
---
 arch/x86/kernel/smpboot.c | 21 +++++++++++++++++----
 1 file changed, 17 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kernel/smpboot.c b/arch/x86/kernel/smpboot.c
index a9e48946fc89..69b56c597949 100644
--- a/arch/x86/kernel/smpboot.c
+++ b/arch/x86/kernel/smpboot.c
@@ -57,6 +57,7 @@
 #include <linux/pgtable.h>
 #include <linux/overflow.h>
 #include <linux/stackprotector.h>
+#include <linux/smpboot.h>
 
 #include <asm/acpi.h>
 #include <asm/cacheinfo.h>
@@ -992,7 +993,8 @@ static void announce_cpu(int cpu, int apicid)
 		node_width = num_digits(num_possible_nodes()) + 1; /* + '#' */
 
 	if (cpu == 1)
-		printk(KERN_INFO "x86: Booting SMP configuration:\n");
+		printk(KERN_INFO "x86: Booting SMP configuration in %s:\n",
+		       do_parallel_bringup ? "parallel" : "series");
 
 	if (system_state < SYSTEM_RUNNING) {
 		if (node != current_node) {
@@ -1325,9 +1327,12 @@ int native_cpu_up(unsigned int cpu, struct task_struct *tidle)
 {
 	int ret;
 
-	ret = do_cpu_up(cpu, tidle);
-	if (ret)
-		goto out;
+	/* If parallel AP bringup isn't enabled, perform the first steps now. */
+	if (!do_parallel_bringup) {
+		ret = do_cpu_up(cpu, tidle);
+		if (ret)
+			goto out;
+	}
 
 	ret = do_wait_cpu_initialized(cpu);
 	if (ret)
@@ -1347,6 +1352,12 @@ int native_cpu_up(unsigned int cpu, struct task_struct *tidle)
 	return ret;
 }
 
+/* Bringup step one: Send INIT/SIPI to the target AP */
+static int native_cpu_kick(unsigned int cpu)
+{
+	return do_cpu_up(cpu, idle_thread_get(cpu, true));
+}
+
 /**
  * arch_disable_smp_support() - disables SMP support for x86 at runtime
  */
@@ -1515,6 +1526,8 @@ static bool prepare_parallel_bringup(void)
 		smpboot_control = STARTUP_APICID_CPUID_01;
 	}
 
+	cpuhp_setup_state_nocalls(CPUHP_BP_PARALLEL_DYN, "x86/cpu:kick",
+				  native_cpu_kick, NULL);
 	return true;
 }
 
-- 
2.25.1

