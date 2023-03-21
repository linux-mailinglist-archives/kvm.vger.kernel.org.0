Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0C98A6C3ADC
	for <lists+kvm@lfdr.de>; Tue, 21 Mar 2023 20:41:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230176AbjCUTlg (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 21 Mar 2023 15:41:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33872 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230288AbjCUTlc (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 21 Mar 2023 15:41:32 -0400
Received: from mail-wr1-x429.google.com (mail-wr1-x429.google.com [IPv6:2a00:1450:4864:20::429])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EB5B04344A
        for <kvm@vger.kernel.org>; Tue, 21 Mar 2023 12:40:58 -0700 (PDT)
Received: by mail-wr1-x429.google.com with SMTP id o7so14888221wrg.5
        for <kvm@vger.kernel.org>; Tue, 21 Mar 2023 12:40:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1679427638;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=InZdH9g7WgaH3myKo4e9txmH25mdwzb46V9DlSyz+Qw=;
        b=iHntaj0fw4OiyphpXTxsruryaSfzgK6xqb6AxgCx5a8pL34IS2YoH93cKuIlYNJeuA
         8HLvn+q7/8NGsLDnQpeWnSoSOPO76m+5Eer1LHHJovenoqwse8L8OYvFy1CQzh3gPlwl
         8TEeMmQ4XpC7IOtTuIMwwF61G3L6+fgWC9tSSZVp5mExbIyub6dv4807UiqXg74huSOO
         j3s8jLwO4fMzALWTAUWtxsKFYw/HD2MljdWf6IolqUoqCggt2WePksUSbzBpeBGGp5Iz
         v/R6K8TfRbrROnG4RDN5LRLruc8+fF3EzAendFiL6tKvRyiDEinNGyzLQfSf78A8QGc/
         PpKA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679427638;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=InZdH9g7WgaH3myKo4e9txmH25mdwzb46V9DlSyz+Qw=;
        b=EOuWl0wTTa3w8x0f5i/sr/BYuKOI2rs2nmqSQseQuc74U8BtyWmmvy9e3IHa9VQCYF
         UCWu7RITq/hPrzLAXVUuViS36V4V19f3rUr5TvmZDLNMWVIqpcKg9o9MEaRe15nyyG5E
         oNdTHL1RRY8RSDBlL8WImXdzFXq120MIDjrn1XVKdYmQMX/gMl45GXDM0PJvHVidqtV+
         GQQ5u1oQhsBGv3d5fN7KKtb29K2BEu0GG9kdvtErGe5fAvBQjxYAJ5UpU9SNvt/ekNer
         WNe5m0yWBHIOrWkJlhA4EIn5iC3I4XL4YHg4QenbgK/M7a95PbXBtYx5Igu6rOf0dBfI
         Oo8A==
X-Gm-Message-State: AO0yUKUm0Sx7XibalMYdDSDiecb1i1r88eb9Y97iKjLW0ZNSmSKUh3a8
        n3NSFkfAHU2n/acZU5FUcRU9lA==
X-Google-Smtp-Source: AK7set9X2C2JmLh/gdXRsU9GIYOIkpY19EDMDBwGPJr0pgDOipyAgUoArsjoSf3GlaBQi5dZ2pbPlw==
X-Received: by 2002:a5d:58d4:0:b0:2ce:a85b:174 with SMTP id o20-20020a5d58d4000000b002cea85b0174mr3302705wrf.44.1679427638062;
        Tue, 21 Mar 2023 12:40:38 -0700 (PDT)
Received: from usaari01.cust.communityfibre.co.uk ([2a02:6b6a:b566:0:7a8a:d679:ba4e:61cf])
        by smtp.gmail.com with ESMTPSA id a3-20020adffb83000000b002c561805a4csm12005026wrr.45.2023.03.21.12.40.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 21 Mar 2023 12:40:37 -0700 (PDT)
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
Subject: [PATCH v16 4/8] x86/smpboot: Split up native_cpu_up into separate phases and document them
Date:   Tue, 21 Mar 2023 19:40:04 +0000
Message-Id: <20230321194008.785922-5-usama.arif@bytedance.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20230321194008.785922-1-usama.arif@bytedance.com>
References: <20230321194008.785922-1-usama.arif@bytedance.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=unavailable
        autolearn_force=no version=3.4.6
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
Tested-by: Guilherme G. Piccoli <gpiccoli@igalia.com>
---
 arch/x86/kernel/smpboot.c | 179 ++++++++++++++++++++++++++------------
 1 file changed, 125 insertions(+), 54 deletions(-)

diff --git a/arch/x86/kernel/smpboot.c b/arch/x86/kernel/smpboot.c
index 851477f7d728..2a8a18e23cc6 100644
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
@@ -1081,7 +1101,6 @@ static int do_boot_cpu(int apicid, int cpu, struct task_struct *idle,
 	unsigned long start_ip = real_mode_header->trampoline_start;
 
 	unsigned long boot_error = 0;
-	unsigned long timeout;
 
 #ifdef CONFIG_X86_64
 	/* If 64-bit wakeup method exists, use the 64-bit mode trampoline IP */
@@ -1147,55 +1166,94 @@ static int do_boot_cpu(int apicid, int cpu, struct task_struct *idle,
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
@@ -1242,19 +1300,6 @@ int native_cpu_up(unsigned int cpu, struct task_struct *tidle)
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
@@ -1266,6 +1311,32 @@ int native_cpu_up(unsigned int cpu, struct task_struct *tidle)
 	return ret;
 }
 
+int native_cpu_up(unsigned int cpu, struct task_struct *tidle)
+{
+	int ret;
+
+	ret = do_cpu_up(cpu, tidle);
+	if (ret)
+		goto out;
+
+	ret = do_wait_cpu_initialized(cpu);
+	if (ret)
+		goto out;
+
+	ret = do_wait_cpu_callin(cpu);
+	if (ret)
+		goto out;
+
+	ret = do_wait_cpu_online(cpu);
+
+ out:
+	/* Cleanup possible dangling ends... */
+	if (x86_platform.legacy.warm_reset)
+		smpboot_restore_warm_reset_vector();
+
+	return ret;
+}
+
 /**
  * arch_disable_smp_support() - disables SMP support for x86 at runtime
  */
-- 
2.25.1

