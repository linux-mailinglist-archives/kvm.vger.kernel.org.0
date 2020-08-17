Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 486E3245B31
	for <lists+kvm@lfdr.de>; Mon, 17 Aug 2020 05:48:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727079AbgHQDsV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 16 Aug 2020 23:48:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38158 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726985AbgHQDsR (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 16 Aug 2020 23:48:17 -0400
Received: from vultr.net.flygoat.com (vultr.net.flygoat.com [IPv6:2001:19f0:6001:3633:5400:2ff:fe8c:553])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 86386C061388;
        Sun, 16 Aug 2020 20:48:17 -0700 (PDT)
Received: from localhost.localdomain (unknown [IPv6:2001:da8:20f:4430:250:56ff:fe9a:7470])
        by vultr.net.flygoat.com (Postfix) with ESMTPSA id CB6E61FEF9;
        Mon, 17 Aug 2020 03:48:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=flygoat.com; s=vultr;
        t=1597636097; bh=yi1R8x6RvUJ7bAaN1Z7AIjYeqPaOFINIjV7gUgOK68Q=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=GbCs5Tlb08GvjOFM543qU04ygjuZ0+K1IyKewuWhseB8YmJE6zqpl91ti35v4H4ag
         imh19YYj4zOK1W1VLcFQuvr4shSHzw43CrlsCjNQ/wqP8NDSeavtu8GvRHXM299cfK
         JrzWm3J09JaOP6ZxKFjEragV7fNkGQCcB412HNYyPlqT+dOUMf82HVhTEnOtAxIxGm
         +I5zhrRvfvwkpIlN+zBvg34Ru3cTauT3igDB0rS+Rq7NReqShBg3pLDae6jX1HS2Ms
         Bt33FJcKNwo6GtRRJcYkqTtHvoINzIgGKBxQVeSE0TpXQ97Ok1tMZ+krV/5LTx7Ndy
         1ggGCemaKTdsQ==
From:   Jiaxun Yang <jiaxun.yang@flygoat.com>
To:     linux-mips@vger.kernel.org
Cc:     Jiaxun Yang <jiaxun.yang@flygoat.com>,
        Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
        Huacai Chen <chenhc@lemote.com>,
        Aleksandar Markovic <aleksandar.qemu.devel@gmail.com>,
        Serge Semin <Sergey.Semin@baikalelectronics.ru>,
        Paul Burton <paulburton@kernel.org>,
        WANG Xuerui <git@xen0n.name>,
        =?UTF-8?q?=E5=91=A8=E7=90=B0=E6=9D=B0=20=28Zhou=20Yanjie=29?= 
        <zhouyanjie@wanyeetech.com>,
        Liangliang Huang <huanglllzu@gmail.com>,
        afzal mohammed <afzal.mohd.ma@gmail.com>,
        Peter Xu <peterx@redhat.com>, Ingo Molnar <mingo@kernel.org>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        Sergey Korolev <s.korolev@ndmsystems.com>,
        Alexey Malahov <Alexey.Malahov@baikalelectronics.ru>,
        Anup Patel <anup.patel@wdc.com>, Marc Zyngier <maz@kernel.org>,
        Michael Kelley <mikelley@microsoft.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Daniel Wagner <dwagner@suse.de>,
        Mike Leach <mike.leach@linaro.org>,
        Atish Patra <atish.patra@wdc.com>,
        Ming Lei <ming.lei@redhat.com>,
        Steven Price <steven.price@arm.com>,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Subject: [PATCH 2/7] MIPS: time: Use CPUHUP to handle r4k timer
Date:   Mon, 17 Aug 2020 11:46:41 +0800
Message-Id: <20200817034701.3515721-3-jiaxun.yang@flygoat.com>
X-Mailer: git-send-email 2.28.0.rc1
In-Reply-To: <20200817034701.3515721-1-jiaxun.yang@flygoat.com>
References: <20200817034701.3515721-1-jiaxun.yang@flygoat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

There is no need to hijack initialization procudre to take care of
r4k timer we have CPUHP framework to deal with the CPU plug sequence.

Signed-off-by: Jiaxun Yang <jiaxun.yang@flygoat.com>
---
 arch/mips/include/asm/time.h | 28 +++++++++++++++-------------
 arch/mips/kernel/cevt-r4k.c  | 30 ++++++++++++++++++++++--------
 arch/mips/kernel/smp.c       |  3 ---
 arch/mips/kernel/time.c      | 22 ++++++++++++++++++++--
 include/linux/cpuhotplug.h   |  1 +
 5 files changed, 58 insertions(+), 26 deletions(-)

diff --git a/arch/mips/include/asm/time.h b/arch/mips/include/asm/time.h
index e855a3611d92..d00a5b05a420 100644
--- a/arch/mips/include/asm/time.h
+++ b/arch/mips/include/asm/time.h
@@ -39,30 +39,32 @@ extern int __weak get_c0_perfcount_int(void);
  * Initialize the calling CPU's compare interrupt as clockevent device
  */
 extern unsigned int get_c0_compare_int(void);
-extern int r4k_clockevent_init(void);
 
-static inline int mips_clockevent_init(void)
-{
 #ifdef CONFIG_CEVT_R4K
-	return r4k_clockevent_init();
+extern int r4k_clockevent_init(void);
+extern int r4k_clockevent_percpu_init(int cpu);
 #else
-	return -ENXIO;
-#endif
+static inline int r4k_clockevent_init(void)
+{
+	return -ENODEV;
+}
+static inline int r4k_clockevent_percpu_init(int cpu)
+{
+	return -ENODEV;
 }
+#endif
 
 /*
  * Initialize the count register as a clocksource
  */
-extern int init_r4k_clocksource(void);
-
-static inline int init_mips_clocksource(void)
-{
 #ifdef CONFIG_CSRC_R4K
-	return init_r4k_clocksource();
+extern int init_r4k_clocksource(void);
 #else
-	return 0;
-#endif
+static inline int init_r4k_clocksource(void)
+{
+	return -ENODEV;
 }
+#endif
 
 static inline void clockevent_set_clock(struct clock_event_device *cd,
 					unsigned int clock)
diff --git a/arch/mips/kernel/cevt-r4k.c b/arch/mips/kernel/cevt-r4k.c
index 995ad9e69ded..f0c52d751d0a 100644
--- a/arch/mips/kernel/cevt-r4k.c
+++ b/arch/mips/kernel/cevt-r4k.c
@@ -294,10 +294,8 @@ core_initcall(r4k_register_cpufreq_notifier);
 
 #endif /* !CONFIG_CPU_FREQ */
 
-int r4k_clockevent_init(void)
+int r4k_clockevent_percpu_init(int cpu)
 {
-	unsigned long flags = IRQF_PERCPU | IRQF_TIMER | IRQF_SHARED;
-	unsigned int cpu = smp_processor_id();
 	struct clock_event_device *cd;
 	unsigned int irq, min_delta;
 
@@ -307,11 +305,6 @@ int r4k_clockevent_init(void)
 	if (!c0_compare_int_usable())
 		return -ENXIO;
 
-	/*
-	 * With vectored interrupts things are getting platform specific.
-	 * get_c0_compare_int is a hook to allow a platform to return the
-	 * interrupt number of its liking.
-	 */
 	irq = get_c0_compare_int();
 
 	cd = &per_cpu(mips_clockevent_device, cpu);
@@ -331,9 +324,30 @@ int r4k_clockevent_init(void)
 
 	clockevents_config_and_register(cd, mips_hpt_frequency, min_delta, 0x7fffffff);
 
+	return 0;
+}
+
+int r4k_clockevent_init(void)
+{
+	int ret;
+	unsigned int irq;
+	unsigned long flags = IRQF_PERCPU | IRQF_TIMER | IRQF_SHARED;
+
+	ret = r4k_clockevent_percpu_init(0);
+	if (ret)
+		return ret;
+
+
 	if (cp0_timer_irq_installed)
 		return 0;
 
+	/*
+	 * With vectored interrupts things are getting platform specific.
+	 * get_c0_compare_int is a hook to allow a platform to return the
+	 * interrupt number of its liking.
+	 */
+	irq = get_c0_compare_int();
+
 	cp0_timer_irq_installed = 1;
 
 	if (request_irq(irq, c0_compare_interrupt, flags, "timer",
diff --git a/arch/mips/kernel/smp.c b/arch/mips/kernel/smp.c
index ead9ac883241..0ca4f7cf6402 100644
--- a/arch/mips/kernel/smp.c
+++ b/arch/mips/kernel/smp.c
@@ -337,7 +337,6 @@ asmlinkage void start_secondary(void)
 
 	cpu_probe();
 	per_cpu_trap_init(false);
-	mips_clockevent_init();
 	mp_ops->init_secondary();
 	cpu_report();
 	maar_init();
@@ -358,8 +357,6 @@ asmlinkage void start_secondary(void)
 	/* Notify boot CPU that we're starting & ready to sync counters */
 	complete(&cpu_starting);
 
-	synchronise_count_slave(cpu);
-
 	/* The CPU is running and counters synchronised, now mark it online */
 	set_cpu_online(cpu, true);
 
diff --git a/arch/mips/kernel/time.c b/arch/mips/kernel/time.c
index caa01457dce6..9b16e60aaa30 100644
--- a/arch/mips/kernel/time.c
+++ b/arch/mips/kernel/time.c
@@ -8,6 +8,7 @@
  */
 #include <linux/bug.h>
 #include <linux/clockchips.h>
+#include <linux/cpuhotplug.h>
 #include <linux/types.h>
 #include <linux/kernel.h>
 #include <linux/init.h>
@@ -24,6 +25,7 @@
 #include <asm/cpu-features.h>
 #include <asm/cpu-type.h>
 #include <asm/div64.h>
+#include <asm/r4k-timer.h>
 #include <asm/time.h>
 
 #ifdef CONFIG_CPU_FREQ
@@ -155,6 +157,16 @@ static __init int cpu_has_mfc0_count_bug(void)
 	return 0;
 }
 
+#if defined(CONFIG_CEVT_R4K) || defined(CONFIG_CSRC_R4K)
+static int mips_r4k_timer_starting_cpu(unsigned int cpu)
+{
+	synchronise_count_slave(cpu);
+	r4k_clockevent_percpu_init(cpu);
+
+	return 0;
+}
+#endif
+
 void __init time_init(void)
 {
 	plat_time_init();
@@ -167,6 +179,12 @@ void __init time_init(void)
 	 * timer interrupt isn't reliable; the interference doesn't
 	 * matter then, because we don't use the interrupt.
 	 */
-	if (mips_clockevent_init() != 0 || !cpu_has_mfc0_count_bug())
-		init_mips_clocksource();
+	if (r4k_clockevent_init() != 0 || !cpu_has_mfc0_count_bug())
+		init_r4k_clocksource();
+
+#if defined(CONFIG_CEVT_R4K) || defined(CONFIG_CSRC_R4K)
+	cpuhp_setup_state_nocalls(CPUHP_AP_MIPS_R4K_TIMER_STARTING,
+			  "clockevents/mips/r4k/timer:starting",
+			  mips_r4k_timer_starting_cpu, NULL);
+#endif
 }
diff --git a/include/linux/cpuhotplug.h b/include/linux/cpuhotplug.h
index 191772d4a4d7..163288803cd4 100644
--- a/include/linux/cpuhotplug.h
+++ b/include/linux/cpuhotplug.h
@@ -129,6 +129,7 @@ enum cpuhp_state {
 	CPUHP_AP_TEGRA_TIMER_STARTING,
 	CPUHP_AP_ARMADA_TIMER_STARTING,
 	CPUHP_AP_MARCO_TIMER_STARTING,
+	CPUHP_AP_MIPS_R4K_TIMER_STARTING,
 	CPUHP_AP_MIPS_GIC_TIMER_STARTING,
 	CPUHP_AP_ARC_TIMER_STARTING,
 	CPUHP_AP_RISCV_TIMER_STARTING,
-- 
2.28.0.rc1

