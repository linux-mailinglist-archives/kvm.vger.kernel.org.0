Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EC8A16CCB18
	for <lists+kvm@lfdr.de>; Tue, 28 Mar 2023 21:58:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229844AbjC1T6v (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 28 Mar 2023 15:58:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42944 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229749AbjC1T6o (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 28 Mar 2023 15:58:44 -0400
Received: from mail-wr1-x430.google.com (mail-wr1-x430.google.com [IPv6:2a00:1450:4864:20::430])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B4C0340C7
        for <kvm@vger.kernel.org>; Tue, 28 Mar 2023 12:58:07 -0700 (PDT)
Received: by mail-wr1-x430.google.com with SMTP id d17so13391345wrb.11
        for <kvm@vger.kernel.org>; Tue, 28 Mar 2023 12:58:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1680033486;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=bAkcK9PzxRDXKfC6w4H8Cy8JdU/8fLLXDQn0J84D/Q4=;
        b=brv1zXiAmPh91aE9DjrwGIwaZCqLhuvVSUYlRm0V3wR7uEEO1zHVL025Y1YIIYZiat
         pUB8v5LNzBgwFFuuF3/fAKGDzC+mIbKI6KjByKrIwOimDShFX33xBmwE5/8LUVsNBNoX
         AZ7eDARNreOKVYr0zxRJIZgTARIchcvEoVso2Q5dAEWC7mp/nM8yObn0/3t0xPpFubhc
         OSHWuRVlzVQB9Ix8KSIr0ej4xjcbc6IsctflpnmbFM2HAyxH5SG3R0KkvUKj8AtCzBUt
         64OGHO/C/OkRi7qKR0lWy3qMQZgKqIqijf4J+6VfGUZ88OZZPWC3VspC+F5K7RUr5RwA
         jd8Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680033486;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=bAkcK9PzxRDXKfC6w4H8Cy8JdU/8fLLXDQn0J84D/Q4=;
        b=jR3Iy+1ZK/NqyxdQpr0GrKzp0UEWRizbThGiX9XYtINP2whSL6QAMSfx/egdnjGWmQ
         CZeZW30GXNJuzTjngZ9NJkMITAmi0pZY0GG5cX4U9kEB4rp8szf4V+SEtkOQhR18YAkF
         112Tngs6NgT/+WJ1nnAAAjZZzCDb/um33+EcoSNkXcvLIPROGrGXELKBFN3BSiTmAZsQ
         cXhY1Y3kY4kl5twb/lZoVqunJij9xdRGkjZHxJQSk/dTLShKJpqUPI1MA+CG/ODKhjFr
         oM1LgfKGcL4No+P56TbwLyaL5HLTjnyLaXM2vPMdo3JkDkqcHmrmTBYli+trGlStLLkZ
         K1/A==
X-Gm-Message-State: AAQBX9d0bDdt3fBsNWFJa2EroI8imO5H98uQQI1N0sd02Ef2UH5RUbE5
        +WabqmvTkX4ZQx6i1Ew5OJuBTA==
X-Google-Smtp-Source: AKy350b0sqZML6UggFbY6k1sToHWoQVpdKzomiPn9RGxAnCWYkTkvqqG8QpnuZfgKmjwoe0QILN/hA==
X-Received: by 2002:adf:e405:0:b0:2cc:1935:1ae8 with SMTP id g5-20020adfe405000000b002cc19351ae8mr12975394wrm.47.1680033486292;
        Tue, 28 Mar 2023 12:58:06 -0700 (PDT)
Received: from usaari01.cust.communityfibre.co.uk ([2a02:6b6a:b566:0:8445:3123:91d7:959d])
        by smtp.gmail.com with ESMTPSA id z6-20020a056000110600b002c557f82e27sm28248386wrw.99.2023.03.28.12.58.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 28 Mar 2023 12:58:05 -0700 (PDT)
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
Subject: [PATCH v17 6/8] x86/smpboot: Send INIT/SIPI/SIPI to secondary CPUs in parallel
Date:   Tue, 28 Mar 2023 20:57:56 +0100
Message-Id: <20230328195758.1049469-7-usama.arif@bytedance.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20230328195758.1049469-1-usama.arif@bytedance.com>
References: <20230328195758.1049469-1-usama.arif@bytedance.com>
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

From: David Woodhouse <dwmw@amazon.co.uk>

When the APs can find their own APIC ID without assistance, perform the
AP bringup in parallel.

Register a CPUHP_BP_PARALLEL_STARTUP stage "x86/cpu:kick" which just
calls do_boot_cpu() to deliver INIT/SIPI/SIPI to each AP in turn before
the normal native_cpu_up() does the rest of the hand-holding.

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
index 45f3d08321fe..0003f5e1740c 100644
--- a/arch/x86/kernel/smpboot.c
+++ b/arch/x86/kernel/smpboot.c
@@ -57,6 +57,7 @@
 #include <linux/pgtable.h>
 #include <linux/overflow.h>
 #include <linux/stackprotector.h>
+#include <linux/smpboot.h>
 
 #include <asm/acpi.h>
 #include <asm/cacheinfo.h>
@@ -993,7 +994,8 @@ static void announce_cpu(int cpu, int apicid)
 		node_width = num_digits(num_possible_nodes()) + 1; /* + '#' */
 
 	if (cpu == 1)
-		printk(KERN_INFO "x86: Booting SMP configuration:\n");
+		printk(KERN_INFO "x86: Booting SMP configuration in %s:\n",
+		       do_parallel_bringup ? "parallel" : "series");
 
 	if (system_state < SYSTEM_RUNNING) {
 		if (node != current_node) {
@@ -1326,9 +1328,12 @@ int native_cpu_up(unsigned int cpu, struct task_struct *tidle)
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
@@ -1348,6 +1353,12 @@ int native_cpu_up(unsigned int cpu, struct task_struct *tidle)
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
@@ -1516,6 +1527,8 @@ static bool prepare_parallel_bringup(void)
 		smpboot_control = STARTUP_APICID_CPUID_01;
 	}
 
+	cpuhp_setup_state_nocalls(CPUHP_BP_PARALLEL_STARTUP, "x86/cpu:kick",
+				  native_cpu_kick, NULL);
 	return true;
 }
 
-- 
2.25.1

