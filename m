Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 279AA6A2F2F
	for <lists+kvm@lfdr.de>; Sun, 26 Feb 2023 12:08:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229556AbjBZLIQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 26 Feb 2023 06:08:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36050 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229622AbjBZLIO (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 26 Feb 2023 06:08:14 -0500
Received: from mail-wm1-x331.google.com (mail-wm1-x331.google.com [IPv6:2a00:1450:4864:20::331])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9A8C6E3AE
        for <kvm@vger.kernel.org>; Sun, 26 Feb 2023 03:08:11 -0800 (PST)
Received: by mail-wm1-x331.google.com with SMTP id l7-20020a05600c4f0700b003e79fa98ce1so2192905wmq.2
        for <kvm@vger.kernel.org>; Sun, 26 Feb 2023 03:08:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=kmlw8LHyg0IiYBrAdMu6qbL5s9Zil0lzZnE7VOWUkds=;
        b=YEGYsFMsvxLJX/fdLNzxLhuHtxeMp64LLiiB2UXeKc5gJVwV+rLhpZJ6cMDln5oJg1
         /yCnEDf0Hvh/57lcw0wKiRvB74wLu0MjPZTMwbYKwnapuJhniXs5NiHw2byDkAP0rm8P
         nZ8ONT/oKVf932e1j/Qm7nWAjbbccV5P8TzJugmwMfBKDVeFMC5p7BJwKyR6RPgHsvhh
         +xS7F7fk5eVnNlOueqgXgg5fdrR8mLO0xEPN6Fj6qXjShXRrvyCXVOVDXRH3VLyi1sWa
         wWoSz+Pb3Tmi2YzR5AwNeaZ955C90N21ErbfOmB/IKPWAwsRlR5U/KSBVI7xZ/UjDlc+
         77fw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=kmlw8LHyg0IiYBrAdMu6qbL5s9Zil0lzZnE7VOWUkds=;
        b=6+FrzbdMQemLq2IR+u+emf1lFbfx7tH67shWnvDKiTNIIWSTnCATUc8eHc29Uf+F7c
         qu7Qs0P1PC2RWL/6x0yaMxzh8Wio1KrOVjCm0DmoU0nOC+J86c/7XFOfjVsu72QGw/4N
         4tC8fAxxUH2QuMLIdxhYx/CUACnp9f17rBRRcxXFiYt5XUuufeARFAz5HsECzg6bL8Cs
         ZKaj0n0qh14cnimz6F8ktQ92XDhsP/RQNEvrth9SxOlDLKwXwO8waPuccoBvNBSl3JKw
         0f57Xbkr/HdbKJwdLBo7QnDrlpbaPzw+wm1ChDRXSnvxGwJjAUBs8WhGR5tUwoNFUDdk
         1Vuw==
X-Gm-Message-State: AO0yUKUf1p4rm+sVV+tAHmJGb7q2uQ3Q0Sdr7HT3jw9WD1gA+9PVSinx
        dbbfDrlm+oZM+6cErQCBc3nWww==
X-Google-Smtp-Source: AK7set/kxO5N/OaFkkciaz/8Yuc3TgYfp3hUQj1bV6HS4gcEX7YglwcMCTT2vc5AQMxMjZefdS7pkQ==
X-Received: by 2002:a1c:ed1a:0:b0:3ea:f6c4:305e with SMTP id l26-20020a1ced1a000000b003eaf6c4305emr7289958wmh.38.1677409689563;
        Sun, 26 Feb 2023 03:08:09 -0800 (PST)
Received: from usaari01.cust.communityfibre.co.uk ([2a02:6b6a:b566:0:df7b:4668:3e23:d0c9])
        by smtp.gmail.com with ESMTPSA id v22-20020a1cf716000000b003e1fee8baacsm9157318wmh.25.2023.02.26.03.08.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 26 Feb 2023 03:08:09 -0800 (PST)
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
        David Woodhouse <dwmw@amazon.co.uk>,
        Usama Arif <usama.arif@bytedance.com>
Subject: [PATCH v12 05/11] x86/smpboot: Split up native_cpu_up into separate phases and document them
Date:   Sun, 26 Feb 2023 11:07:56 +0000
Message-Id: <20230226110802.103134-6-usama.arif@bytedance.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20230226110802.103134-1-usama.arif@bytedance.com>
References: <20230226110802.103134-1-usama.arif@bytedance.com>
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

From: David Woodhouse <dwmw@amazon.co.uk>

There are four logical parts to what native_cpu_up() does on the BSP (or
on the controlling CPU for a later hotplug):

 1) Wake the AP by sending the INIT/SIPI/SIPI sequence.

 2) Wait for the AP to make it as far as wait_for_master_cpu() which
    sets that CPU's bit in cpu_initialized_mask, then sets the bit in
    cpu_callout_mask to let the AP proceed through cpu_init().

 3) Wait for the AP to finish cpu_init() and get as far as the
    smp_callin() call, which sets that CPU's bit in cpu_callin_mask.

 4) Perform the TSC synchronization and wait for the AP to actually
    mark itself online in cpu_online_mask.

In preparation to allow these phases to operate in parallel on multiple
APs, split them out into separate functions and document the interactions
a little more clearly in both the BSP and AP code paths.

No functional change intended.

Signed-off-by: David Woodhouse <dwmw@amazon.co.uk>
Signed-off-by: Usama Arif <usama.arif@bytedance.com>
Tested-by: Paul E. McKenney <paulmck@kernel.org>
Tested-by: Kim Phillips <kim.phillips@amd.com>
Tested-by: Oleksandr Natalenko <oleksandr@natalenko.name>
---
 arch/x86/kernel/smpboot.c | 181 ++++++++++++++++++++++++++------------
 1 file changed, 127 insertions(+), 54 deletions(-)

diff --git a/arch/x86/kernel/smpboot.c b/arch/x86/kernel/smpboot.c
index 3a793772a2aa..b18c1385e181 100644
--- a/arch/x86/kernel/smpboot.c
+++ b/arch/x86/kernel/smpboot.c
@@ -204,6 +204,10 @@ static void smp_callin(void)
 
 	wmb();
 
+	/*
+	 * This runs the AP through all the cpuhp states to its target
+	 * state (CPUHP_ONLINE in the case of serial bringup).
+	 */
 	notify_cpu_starting(cpuid);
 
 	/*
@@ -231,17 +235,32 @@ static void notrace start_secondary(void *unused)
 	load_cr3(swapper_pg_dir);
 	__flush_tlb_all();
 #endif
+	/*
+	 * Sync point with do_wait_cpu_initialized(). Before proceeding through
+	 * cpu_init(), the AP will call wait_for_master_cpu() which sets its
+	 * own bit in cpu_initialized_mask and then waits for the BSP to set
+	 * its bit in cpu_callout_mask to release it.
+	 */
 	cpu_init_secondary();
 	rcu_cpu_starting(raw_smp_processor_id());
 	x86_cpuinit.early_percpu_clock_init();
+
+	/*
+	 * Sync point with do_wait_cpu_callin(). The AP doesn't wait here
+	 * but just sets the bit to let the controlling CPU (BSP) know that
+	 * it's got this far.
+	 */
 	smp_callin();
 
 	enable_start_cpu0 = 0;
 
 	/* otherwise gcc will move up smp_processor_id before the cpu_init */
 	barrier();
+
 	/*
-	 * Check TSC synchronization with the boot CPU:
+	 * Check TSC synchronization with the boot CPU (or whichever CPU
+	 * is controlling the bringup). It will do its part of this from
+	 * do_wait_cpu_online(), making it an implicit sync point.
 	 */
 	check_tsc_sync_target();
 
@@ -254,6 +273,7 @@ static void notrace start_secondary(void *unused)
 	 * half valid vector space.
 	 */
 	lock_vector_lock();
+	/* Sync point with do_wait_cpu_online() */
 	set_cpu_online(smp_processor_id(), true);
 	lapic_online();
 	unlock_vector_lock();
@@ -1083,7 +1103,6 @@ static int do_boot_cpu(int apicid, int cpu, struct task_struct *idle,
 	unsigned long start_ip = real_mode_header->trampoline_start;
 
 	unsigned long boot_error = 0;
-	unsigned long timeout;
 
 #ifdef CONFIG_X86_64
 	/* If 64-bit wakeup method exists, use the 64-bit mode trampoline IP */
@@ -1144,55 +1163,94 @@ static int do_boot_cpu(int apicid, int cpu, struct task_struct *idle,
 		boot_error = wakeup_cpu_via_init_nmi(cpu, start_ip, apicid,
 						     cpu0_nmi_registered);
 
-	if (!boot_error) {
-		/*
-		 * Wait 10s total for first sign of life from AP
-		 */
-		boot_error = -1;
-		timeout = jiffies + 10*HZ;
-		while (time_before(jiffies, timeout)) {
-			if (cpumask_test_cpu(cpu, cpu_initialized_mask)) {
-				/*
-				 * Tell AP to proceed with initialization
-				 */
-				cpumask_set_cpu(cpu, cpu_callout_mask);
-				boot_error = 0;
-				break;
-			}
-			schedule();
-		}
-	}
+	return boot_error;
+}
 
-	if (!boot_error) {
-		/*
-		 * Wait till AP completes initial initialization
-		 */
-		while (!cpumask_test_cpu(cpu, cpu_callin_mask)) {
-			/*
-			 * Allow other tasks to run while we wait for the
-			 * AP to come online. This also gives a chance
-			 * for the MTRR work(triggered by the AP coming online)
-			 * to be completed in the stop machine context.
-			 */
-			schedule();
-		}
+static int do_wait_cpu_cpumask(unsigned int cpu, const struct cpumask *mask)
+{
+	unsigned long timeout;
+
+	/*
+	 * Wait up to 10s for the CPU to report in.
+	 */
+	timeout = jiffies + 10*HZ;
+	while (time_before(jiffies, timeout)) {
+		if (cpumask_test_cpu(cpu, mask))
+			return 0;
+
+		schedule();
 	}
+	return -1;
+}
 
-	if (x86_platform.legacy.warm_reset) {
-		/*
-		 * Cleanup possible dangling ends...
-		 */
-		smpboot_restore_warm_reset_vector();
+/*
+ * Bringup step two: Wait for the target AP to reach cpu_init_secondary()
+ * and thus wait_for_master_cpu(), then set cpu_callout_mask to allow it
+ * to proceed.  The AP will then proceed past setting its 'callin' bit
+ * and end up waiting in check_tsc_sync_target() until we reach
+ * do_wait_cpu_online() to tend to it.
+ */
+static int do_wait_cpu_initialized(unsigned int cpu)
+{
+	/*
+	 * Wait for first sign of life from AP.
+	 */
+	if (do_wait_cpu_cpumask(cpu, cpu_initialized_mask))
+		return -1;
+
+	cpumask_set_cpu(cpu, cpu_callout_mask);
+	return 0;
+}
+
+/*
+ * Bringup step three: Wait for the target AP to reach smp_callin().
+ * The AP is not waiting for us here so we don't need to parallelise
+ * this step. Not entirely clear why we care about this, since we just
+ * proceed directly to TSC synchronization which is the next sync
+ * point with the AP anyway.
+ */
+static int do_wait_cpu_callin(unsigned int cpu)
+{
+	/*
+	 * Wait till AP completes initial initialization.
+	 */
+	return do_wait_cpu_cpumask(cpu, cpu_callin_mask);
+}
+
+/*
+ * Bringup step four: Synchronize the TSC and wait for the target AP
+ * to reach set_cpu_online() in start_secondary().
+ */
+static int do_wait_cpu_online(unsigned int cpu)
+{
+	unsigned long flags;
+
+	/*
+	 * Check TSC synchronization with the AP (keep irqs disabled
+	 * while doing so):
+	 */
+	local_irq_save(flags);
+	check_tsc_sync_source(cpu);
+	local_irq_restore(flags);
+
+	/*
+	 * Wait for the AP to mark itself online. Not entirely
+	 * clear why we care, since the generic cpuhp code will
+	 * wait for it to each CPUHP_AP_ONLINE_IDLE before going
+	 * ahead with the rest of the bringup anyway.
+	 */
+	while (!cpu_online(cpu)) {
+		cpu_relax();
+		touch_nmi_watchdog();
 	}
 
-	return boot_error;
+	return 0;
 }
 
-int native_cpu_up(unsigned int cpu, struct task_struct *tidle)
+static int do_cpu_up(unsigned int cpu, struct task_struct *tidle)
 {
 	int apicid = apic->cpu_present_to_apicid(cpu);
 	int cpu0_nmi_registered = 0;
-	unsigned long flags;
 	int err, ret = 0;
 
 	lockdep_assert_irqs_enabled();
@@ -1239,19 +1297,6 @@ int native_cpu_up(unsigned int cpu, struct task_struct *tidle)
 		goto unreg_nmi;
 	}
 
-	/*
-	 * Check TSC synchronization with the AP (keep irqs disabled
-	 * while doing so):
-	 */
-	local_irq_save(flags);
-	check_tsc_sync_source(cpu);
-	local_irq_restore(flags);
-
-	while (!cpu_online(cpu)) {
-		cpu_relax();
-		touch_nmi_watchdog();
-	}
-
 unreg_nmi:
 	/*
 	 * Clean up the nmi handler. Do this after the callin and callout sync
@@ -1263,6 +1308,34 @@ int native_cpu_up(unsigned int cpu, struct task_struct *tidle)
 	return ret;
 }
 
+int native_cpu_up(unsigned int cpu, struct task_struct *tidle)
+{
+	int ret;
+
+	ret = do_cpu_up(cpu, tidle);
+	if (ret)
+		return ret;
+
+	ret = do_wait_cpu_initialized(cpu);
+	if (ret)
+		return ret;
+
+	ret = do_wait_cpu_callin(cpu);
+	if (ret)
+		return ret;
+
+	ret = do_wait_cpu_online(cpu);
+
+	if (x86_platform.legacy.warm_reset) {
+		/*
+		 * Cleanup possible dangling ends...
+		 */
+		smpboot_restore_warm_reset_vector();
+	}
+
+	return ret;
+}
+
 /**
  * arch_disable_smp_support() - disables SMP support for x86 at runtime
  */
-- 
2.25.1

