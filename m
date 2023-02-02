Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 37FEA688963
	for <lists+kvm@lfdr.de>; Thu,  2 Feb 2023 22:57:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233235AbjBBV5j (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 2 Feb 2023 16:57:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54824 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233238AbjBBV5S (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 2 Feb 2023 16:57:18 -0500
Received: from mail-wr1-x42b.google.com (mail-wr1-x42b.google.com [IPv6:2a00:1450:4864:20::42b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6FB5B71982
        for <kvm@vger.kernel.org>; Thu,  2 Feb 2023 13:56:36 -0800 (PST)
Received: by mail-wr1-x42b.google.com with SMTP id m7so2986790wru.8
        for <kvm@vger.kernel.org>; Thu, 02 Feb 2023 13:56:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance-com.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=P3b1xgggD+wYGituLwlxcxnoFl/cpgpPrv2JCvE2DdQ=;
        b=abVhKq6QTjCUReQpSDjXu9VjJNCsdd8u4ifNmoxDhEWw386xoJPB2ENR9yJxaSImIe
         De2DRhHr7GcoZ78XSnn+hMZqJuVXYTlY2sN3ahWFQNbC2oCGZN9/HknCOCJfvs86FIVu
         qP9Zjt0igGTfUQenfalfuDj2uTqoKVCCgK17WLmVnA36vFeuj6kF0QuIS0d+XbRv+O+z
         UfYzZ5dEuLGo1frWazP0PdLffbfIVWH4azBnxYGtWelXIVU6ub5i+EPLFcP62s5HgjJ4
         ZyWBTNJYFiZMXAZR4vqoV5vP1r3Vtb5YKBsMuTfHL+ljOeOe9iKNIaPBF9jx5PSrsmoi
         YF0A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=P3b1xgggD+wYGituLwlxcxnoFl/cpgpPrv2JCvE2DdQ=;
        b=iwxpn5C6NMqW3hNmTwf30JRzxBHjauaMcSQ/rkwB/lxK0WwTruAf46CP+B6tmuns9W
         DvyFK8p+ovOPO38UiUcetbE/fndzr8KlTVeMEsEF9QqL//G1dEEh5bvydC8HpralHcsP
         qJIocraJsDKsK0WoP0Nrru3CF5HdWUOpSRwa24tnfRD3sNj0G9xTTAsLdZ27k9i3XR9l
         APoMn4oJQSxJjX1Czm0LslJ76pE2st/OrgsSjtEL4o9YpgAPEOFvZyYfNh70nvCblekw
         crlwQlZrobmVlIEqBY28sAn43tJgQ1C2Xq2HmjDJjv287s6tb5N2uN7ZwDApGMNLxrjs
         rqOg==
X-Gm-Message-State: AO0yUKUnGauU2mCFG36fOjVoEBgBEluTnmW1YfPWLbEtKGe5aMpOXpKJ
        lkxiNbYFxd+9J6eBbnq0pGpXsw==
X-Google-Smtp-Source: AK7set8JVkwF6DYXaTtX2HZh2iARPJWPceZFSv0o6Gv9Z5wHzmLjpA4pOPILCZhP9RdL9kNFKOioYg==
X-Received: by 2002:a05:6000:186a:b0:257:15b9:8b66 with SMTP id d10-20020a056000186a00b0025715b98b66mr8762992wri.62.1675374994908;
        Thu, 02 Feb 2023 13:56:34 -0800 (PST)
Received: from usaari01.cust.communityfibre.co.uk ([2a02:6b6a:b566:0:98fe:e4ee:fc7e:cd71])
        by smtp.gmail.com with ESMTPSA id e8-20020a5d6d08000000b00297dcfdc90fsm506078wrq.24.2023.02.02.13.56.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 02 Feb 2023 13:56:34 -0800 (PST)
From:   Usama Arif <usama.arif@bytedance.com>
To:     dwmw2@infradead.org, tglx@linutronix.de, arjan@linux.intel.com
Cc:     mingo@redhat.com, bp@alien8.de, dave.hansen@linux.intel.com,
        hpa@zytor.com, x86@kernel.org, pbonzini@redhat.com,
        paulmck@kernel.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, rcu@vger.kernel.org, mimoja@mimoja.de,
        hewenliang4@huawei.com, thomas.lendacky@amd.com, seanjc@google.com,
        pmenzel@molgen.mpg.de, fam.zheng@bytedance.com,
        punit.agrawal@bytedance.com, simon.evans@bytedance.com,
        liangma@liangbit.com, David Woodhouse <dwmw@amazon.co.uk>,
        Usama Arif <usama.arif@bytedance.com>
Subject: [PATCH v6 05/11] x86/smpboot: Split up native_cpu_up into separate phases and document them
Date:   Thu,  2 Feb 2023 21:56:19 +0000
Message-Id: <20230202215625.3248306-6-usama.arif@bytedance.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20230202215625.3248306-1-usama.arif@bytedance.com>
References: <20230202215625.3248306-1-usama.arif@bytedance.com>
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

From: David Woodhouse <dwmw@amazon.co.uk>

There are four logical parts to what native_cpu_up() does on the BSP (or
on the controlling CPU for a later hotplug).

First it actually wakes the AP by sending the INIT/SIPI/SIPI sequence.

Second, it waits for the AP to make it as far as wait_for_master_cpu()
which sets that CPU's bit in cpu_initialized_mask, then sets the bit in
cpu_callout_mask to let the AP proceed through cpu_init().

Then, it waits for the AP to finish cpu_init() and get as far as the
smp_callin() call, which sets that CPU's bit in cpu_callin_mask.

Finally, it does the TSC synchronization and waits for the AP to actually
mark itself online in cpu_online_mask.

This commit should have no behavioural change, but merely splits those
phases out into separate functions so that future commits can make them
happen in parallel for all APs. And adds some comments around them on
both the BSP and AP code paths.

[Usama Arif: fixed rebase conflict]
Signed-off-by: David Woodhouse <dwmw@amazon.co.uk>
Signed-off-by: Usama Arif <usama.arif@bytedance.com>
Signed-off-by: Paul E. McKenney <paulmck@kernel.org>
---
 arch/x86/kernel/smpboot.c | 182 +++++++++++++++++++++++++++-----------
 1 file changed, 128 insertions(+), 54 deletions(-)

diff --git a/arch/x86/kernel/smpboot.c b/arch/x86/kernel/smpboot.c
index a19eddcdccc2..fdcf7c08945f 100644
--- a/arch/x86/kernel/smpboot.c
+++ b/arch/x86/kernel/smpboot.c
@@ -206,6 +206,10 @@ static void smp_callin(void)
 
 	wmb();
 
+	/*
+	 * This runs the AP through all the cpuhp states to its target
+	 * state (CPUHP_ONLINE in the case of serial bringup).
+	 */
 	notify_cpu_starting(cpuid);
 
 	/*
@@ -233,17 +237,33 @@ static void notrace start_secondary(void *unused)
 	load_cr3(swapper_pg_dir);
 	__flush_tlb_all();
 #endif
+	/*
+	 * Sync point with do_wait_cpu_initialized(). On boot, all secondary
+	 * CPUs reach this stage after receiving INIT/SIPI from do_cpu_up()
+	 * in the x86/cpu:kick cpuhp stage. At the start of cpu_init() they
+	 * will wait for do_wait_cpu_initialized() to set their bit in
+	 * smp_callout_mask to release them.
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
 
@@ -256,6 +276,7 @@ static void notrace start_secondary(void *unused)
 	 * half valid vector space.
 	 */
 	lock_vector_lock();
+	/* Sync point with do_wait_cpu_online() */
 	set_cpu_online(smp_processor_id(), true);
 	lapic_online();
 	unlock_vector_lock();
@@ -1085,7 +1106,6 @@ static int do_boot_cpu(int apicid, int cpu, struct task_struct *idle,
 	unsigned long start_ip = real_mode_header->trampoline_start;
 
 	unsigned long boot_error = 0;
-	unsigned long timeout;
 
 #ifdef CONFIG_X86_64
 	/* If 64-bit wakeup method exists, use the 64-bit mode trampoline IP */
@@ -1146,55 +1166,94 @@ static int do_boot_cpu(int apicid, int cpu, struct task_struct *idle,
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
@@ -1241,19 +1300,6 @@ int native_cpu_up(unsigned int cpu, struct task_struct *tidle)
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
@@ -1265,6 +1311,34 @@ int native_cpu_up(unsigned int cpu, struct task_struct *tidle)
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

