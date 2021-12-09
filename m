Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8E39A46EACE
	for <lists+kvm@lfdr.de>; Thu,  9 Dec 2021 16:10:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239602AbhLIPN5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 9 Dec 2021 10:13:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43044 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239417AbhLIPNs (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 9 Dec 2021 10:13:48 -0500
Received: from desiato.infradead.org (desiato.infradead.org [IPv6:2001:8b0:10b:1:d65d:64ff:fe57:4e05])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A47CFC0617A2;
        Thu,  9 Dec 2021 07:10:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=desiato.20200630; h=Sender:Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:
        Reply-To:Content-Type:Content-ID:Content-Description;
        bh=cUgYM7VfxGKceIDaNbnjNWC9SSh647raTx6pVw9OelU=; b=H417JILAuwOlK1/lo3WIp9nNM5
        AQworMXowpy07p8tbuJQbjAAERySd9tfBGkIgLQdPl3KvU6Q2VWpW2/Cuk59aYjSZkNUu24LoEfwe
        A47Qgcr/lTiHpWHya9YpNN79loSVGH2wKvMc9Qnwt7lrj2zMd4diWXrm2re/cUsRU1diS1YqFV4tq
        FEMaxK4TNyhz85LO5f50Q7hIi59WZeF5WpFldk/Jnu8RoFaNiFaCDMmklINm+VxNTfCh3Z1my4Joe
        s59CAZUxgRgnHTGSyTTBpd9Fp18PTX+HDXpA7OrCRqMIAUy0XfGozoCOwjY7AP4iUmlE0y86p48rN
        7t2J7Mqg==;
Received: from i7.infradead.org ([2001:8b0:10b:1:21e:67ff:fecb:7a92])
        by desiato.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1mvL3K-000Np3-Ee; Thu, 09 Dec 2021 15:09:46 +0000
Received: from dwoodhou by i7.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1mvL3K-0000yc-3x; Thu, 09 Dec 2021 15:09:46 +0000
From:   David Woodhouse <dwmw2@infradead.org>
To:     Thomas Gleixner <tglx@linutronix.de>
Cc:     Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        "Paul E. McKenney" <paulmck@kernel.org>,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        rcu@vger.kernel.org, mimoja@mimoja.de, hewenliang4@huawei.com,
        hushiyuan@huawei.com, luolongjun@huawei.com, hejingxian@huawei.com
Subject: [PATCH 10/11] x86/smp: Bring up secondary CPUs in parallel
Date:   Thu,  9 Dec 2021 15:09:37 +0000
Message-Id: <20211209150938.3518-11-dwmw2@infradead.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211209150938.3518-1-dwmw2@infradead.org>
References: <20211209150938.3518-1-dwmw2@infradead.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: David Woodhouse <dwmw2@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by desiato.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: David Woodhouse <dwmw@amazon.co.uk>

Start by documenting the various synchronization points between the CPU
doing the bringup, and the target AP.

Then enable parallel bringup where we can manage it, which is in 64-bit
mode when the CPU provides its APIC ID in CPUID leaf 0x0b.

The main win here is by sending the INIT/SIPI to all CPUs first, then
coming back in a second round as do_wait_cpu_initialized() is called
from the x86/cpu:wait-init cpuhp stage to check that they have reached
cpu_init() and release them to proceed further.

This reduces the time taken for bringup on my 28-thread Haswell system
by about 60% on a boot from EFI (120ms to 49.5ms), and somewhat less
than that for kexec (100ms to 80ms). It isn't clear (yet) why kexec
is faster than boot for the serial bringup, while boot is faster then
kexec for the parallel bringup. Either way, the parallel bringup is
faster than serial; just by a smaller ratio in the kexec case.

Only using kexec on a 2-socket 96-way Skylake, it reduces the bringup
time from ~500ms to ~34ms.

Signed-off-by: David Woodhouse <dwmw@amazon.co.uk>
---
 arch/x86/kernel/smpboot.c | 77 +++++++++++++++++++++++++++++++++++----
 1 file changed, 70 insertions(+), 7 deletions(-)

diff --git a/arch/x86/kernel/smpboot.c b/arch/x86/kernel/smpboot.c
index 8fdf889acf5d..dc62e28ede48 100644
--- a/arch/x86/kernel/smpboot.c
+++ b/arch/x86/kernel/smpboot.c
@@ -57,6 +57,7 @@
 #include <linux/pgtable.h>
 #include <linux/overflow.h>
 #include <linux/syscore_ops.h>
+#include <linux/smpboot.h>
 
 #include <asm/acpi.h>
 #include <asm/desc.h>
@@ -241,17 +242,33 @@ static void notrace start_secondary(void *unused)
 	load_cr3(swapper_pg_dir);
 	__flush_tlb_all();
 #endif
+	/*
+	 * Sync point with do_wait_cpu_initialized(). On boot, all secondary
+	 * CPUs reach this stage after receiving INIT/SIPI from do_cpu_up()
+	 * in the x86/cpu:kick cpuhp stage. At the start of cpu_init() they
+	 * will wait for do_wait_cpu_initialized() in the x86/cpu:wait-init
+	 * cpuhp stage to set their bit in smp_callout_mask to release them.
+	 */
 	cpu_init_secondary();
 	rcu_cpu_starting(raw_smp_processor_id());
 	x86_cpuinit.early_percpu_clock_init();
+
+	/*
+	 * Sync point with do_wait_cpu_callin(). The AP doesn't wait here
+	 * but just sets the bit to let the existing CPU (BSP) know that
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
 
@@ -264,6 +281,7 @@ static void notrace start_secondary(void *unused)
 	 * half valid vector space.
 	 */
 	lock_vector_lock();
+	/* Sync point with do_wait_cpu_online() */
 	set_cpu_online(smp_processor_id(), true);
 	lapic_online();
 	unlock_vector_lock();
@@ -1168,6 +1186,13 @@ static int do_wait_cpu_cpumask(unsigned int cpu, const struct cpumask *mask)
 	return -1;
 }
 
+/*
+ * Bringup step two: Wait for the target AP to reach cpu_init_secondary()
+ * and thus wait_for_master_cpu(), then set cpu_callout_mask to allow it
+ * to proceed.  The AP will then proceed past setting its 'callin' bit
+ * and end up waiting in check_tsc_sync_target() until we reach
+ * do_wait_cpu_online() to tend to it.
+ */
 static int do_wait_cpu_initialized(unsigned int cpu)
 {
 	/*
@@ -1180,6 +1205,13 @@ static int do_wait_cpu_initialized(unsigned int cpu)
 	return 0;
 }
 
+/*
+ * Bringup step three: Wait for the target AP to reach smp_callin().
+ * The AP is not waiting for us here so we don't need to parallelise
+ * this step. Not entirely clear why we care about this, since we just
+ * proceed directly to TSC synchronization which is the next sync
+ * point with the AP anyway.
+ */
 static int do_wait_cpu_callin(unsigned int cpu)
 {
 	/*
@@ -1188,6 +1220,10 @@ static int do_wait_cpu_callin(unsigned int cpu)
 	return do_wait_cpu_cpumask(cpu, cpu_callin_mask);
 }
 
+/*
+ * Bringup step four: Synchronize the TSC and wait for the target AP
+ * to reach set_cpu_online() in start_secondary().
+ */
 static int do_wait_cpu_online(unsigned int cpu)
 {
 	unsigned long flags;
@@ -1200,6 +1236,12 @@ static int do_wait_cpu_online(unsigned int cpu)
 	check_tsc_sync_source(cpu);
 	local_irq_restore(flags);
 
+	/*
+	 * Wait for the AP to mark itself online. Not entirely
+	 * clear why we care, since the generic cpuhp code will
+	 * wait for it to each CPUHP_AP_ONLINE_IDLE before going
+	 * ahead with the rest of the bringup anyway.
+	 */
 	while (!cpu_online(cpu)) {
 		cpu_relax();
 		touch_nmi_watchdog();
@@ -1273,13 +1315,16 @@ int native_cpu_up(unsigned int cpu, struct task_struct *tidle)
 {
 	int ret;
 
-	ret = do_cpu_up(cpu, tidle);
-	if (ret)
-		return ret;
+	/* If parallel AP bringup isn't enabled, perform the first steps now. */
+	if (IS_ENABLED(CONFIG_X86_32) || boot_cpu_data.cpuid_level < 0x0B) {
+		ret = do_cpu_up(cpu, tidle);
+		if (ret)
+			return ret;
 
-	ret = do_wait_cpu_initialized(cpu);
-	if (ret)
-		return ret;
+		ret = do_wait_cpu_initialized(cpu);
+		if (ret)
+			return ret;
+	}
 
 	ret = do_wait_cpu_callin(cpu);
 	if (ret)
@@ -1297,6 +1342,12 @@ int native_cpu_up(unsigned int cpu, struct task_struct *tidle)
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
@@ -1475,6 +1526,18 @@ void __init native_smp_prepare_cpus(unsigned int max_cpus)
 	smp_quirk_init_udelay();
 
 	speculative_store_bypass_ht_init();
+
+	/*
+	 * We can do 64-bit AP bringup in parallel if the CPU reports its
+	 * APIC ID in CPUID leaf 0x0B. Otherwise it's too hard.
+	 */
+	if (IS_ENABLED(CONFIG_X86_64) && boot_cpu_data.cpuid_level >= 0x0B) {
+		cpuhp_setup_state_nocalls(CPUHP_BP_PARALLEL_DYN, "x86/cpu:kick",
+					  native_cpu_kick, NULL);
+
+		cpuhp_setup_state_nocalls(CPUHP_BP_PARALLEL_DYN, "x86/cpu:wait-init",
+					  do_wait_cpu_initialized, NULL);
+	}
 }
 
 void arch_thaw_secondary_cpus_begin(void)
-- 
2.31.1

