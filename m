Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E9011245B2D
	for <lists+kvm@lfdr.de>; Mon, 17 Aug 2020 05:48:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727043AbgHQDr7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 16 Aug 2020 23:47:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38106 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726977AbgHQDr5 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 16 Aug 2020 23:47:57 -0400
Received: from vultr.net.flygoat.com (vultr.net.flygoat.com [IPv6:2001:19f0:6001:3633:5400:2ff:fe8c:553])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AC65CC061388
        for <kvm@vger.kernel.org>; Sun, 16 Aug 2020 20:47:57 -0700 (PDT)
Received: from localhost.localdomain (unknown [IPv6:2001:da8:20f:4430:250:56ff:fe9a:7470])
        by vultr.net.flygoat.com (Postfix) with ESMTPSA id 25FAA1FEF5;
        Mon, 17 Aug 2020 03:47:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=flygoat.com; s=vultr;
        t=1597636076; bh=akb+og0HnO3wboY8Fq8f9zbqdX3Uoz+REcSJDdeCfZI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ZozkZjopFHz84hwKNShWN4hgcNl9ecwl+KkYe0OnQNX1Kf0Q+K2KcFp7BOk+T8yvQ
         K9fg8Sxnc6uhT4IedQyJc+DKDODsvAQA5C2/K/gMKXz0aYfQ7I82+nWl7VED/EFfE1
         EhDoldaLtmmcOd87ZTxyWWRvGvVT0B7rfFv9pDs8wFIKNRWN60d6+owsr3HkYdO0jC
         akEG5f/6xyvBCX3d+j+VO+qWTLqGIoUg0Ko2xMminrNt4rE4hPvgMz4ic7QDSQDSb8
         tF9dd1Qy0C/LrAiIG2EiALP1/QlK7Dvr56E27V1bNfeMJK/gYIWAE5JmT4lfzZZ2aF
         rT9UJ7CU9rWOw==
From:   Jiaxun Yang <jiaxun.yang@flygoat.com>
To:     linux-mips@vger.kernel.org
Cc:     Jiaxun Yang <jiaxun.yang@flygoat.com>,
        Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
        Huacai Chen <chenhc@lemote.com>,
        Aleksandar Markovic <aleksandar.qemu.devel@gmail.com>,
        Paul Burton <paulburton@kernel.org>,
        Serge Semin <Sergey.Semin@baikalelectronics.ru>,
        WANG Xuerui <git@xen0n.name>,
        =?UTF-8?q?=E5=91=A8=E7=90=B0=E6=9D=B0=20=28Zhou=20Yanjie=29?= 
        <zhouyanjie@wanyeetech.com>,
        Liangliang Huang <huanglllzu@gmail.com>,
        afzal mohammed <afzal.mohd.ma@gmail.com>,
        Ingo Molnar <mingo@kernel.org>, Peter Xu <peterx@redhat.com>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        Sergey Korolev <s.korolev@ndmsystems.com>,
        Alexey Malahov <Alexey.Malahov@baikalelectronics.ru>,
        Marc Zyngier <maz@kernel.org>, Anup Patel <anup.patel@wdc.com>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Atish Patra <atish.patra@wdc.com>,
        Michael Kelley <mikelley@microsoft.com>,
        Steven Price <steven.price@arm.com>,
        Daniel Jordan <daniel.m.jordan@oracle.com>,
        Ming Lei <ming.lei@redhat.com>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        Mike Leach <mike.leach@linaro.org>,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Subject: [PATCH 1/7] MIPS: sync-r4k: Rework to be many cores firendly
Date:   Mon, 17 Aug 2020 11:46:40 +0800
Message-Id: <20200817034701.3515721-2-jiaxun.yang@flygoat.com>
X-Mailer: git-send-email 2.28.0.rc1
In-Reply-To: <20200817034701.3515721-1-jiaxun.yang@flygoat.com>
References: <20200817034701.3515721-1-jiaxun.yang@flygoat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The original sync-r4k did a good job on reducing jitter by determine
the "next time value", but it has a limitation that when we have lots
of cores, the timewrap on CPU0 will become unaccpetable. That will also
happen when CPU Hotplug is enabled and the counter needs to be synchronised
at every plug event.

Here we reworked the whole procdure. Now the synchronise event on CPU0
is triggered by smp call function, and we won't touch the count on CPU0
at all.

Signed-off-by: Jiaxun Yang <jiaxun.yang@flygoat.com>
---
 arch/mips/include/asm/r4k-timer.h |   5 --
 arch/mips/kernel/smp.c            |   2 -
 arch/mips/kernel/sync-r4k.c       | 143 +++++++++++++-----------------
 3 files changed, 61 insertions(+), 89 deletions(-)

diff --git a/arch/mips/include/asm/r4k-timer.h b/arch/mips/include/asm/r4k-timer.h
index afe9e0e03fe9..2789d2fc5e23 100644
--- a/arch/mips/include/asm/r4k-timer.h
+++ b/arch/mips/include/asm/r4k-timer.h
@@ -12,15 +12,10 @@
 
 #ifdef CONFIG_SYNC_R4K
 
-extern void synchronise_count_master(int cpu);
 extern void synchronise_count_slave(int cpu);
 
 #else
 
-static inline void synchronise_count_master(int cpu)
-{
-}
-
 static inline void synchronise_count_slave(int cpu)
 {
 }
diff --git a/arch/mips/kernel/smp.c b/arch/mips/kernel/smp.c
index 48d84d5fcc36..ead9ac883241 100644
--- a/arch/mips/kernel/smp.c
+++ b/arch/mips/kernel/smp.c
@@ -444,8 +444,6 @@ int __cpu_up(unsigned int cpu, struct task_struct *tidle)
 		return -EIO;
 	}
 
-	synchronise_count_master(cpu);
-
 	/* Wait for CPU to finish startup & mark itself online before return */
 	wait_for_completion(&cpu_running);
 	return 0;
diff --git a/arch/mips/kernel/sync-r4k.c b/arch/mips/kernel/sync-r4k.c
index abdd7aaa3311..c3e36d6d57fa 100644
--- a/arch/mips/kernel/sync-r4k.c
+++ b/arch/mips/kernel/sync-r4k.c
@@ -1,122 +1,101 @@
 // SPDX-License-Identifier: GPL-2.0
 /*
  * Count register synchronisation.
- *
- * All CPUs will have their count registers synchronised to the CPU0 next time
- * value. This can cause a small timewarp for CPU0. All other CPU's should
- * not have done anything significant (but they may have had interrupts
- * enabled briefly - prom_smp_finish() should not be responsible for enabling
- * interrupts...)
  */
 
 #include <linux/kernel.h>
 #include <linux/irqflags.h>
 #include <linux/cpumask.h>
+#include <linux/spinlock.h>
+#include <linux/smp.h>
 
 #include <asm/r4k-timer.h>
 #include <linux/atomic.h>
 #include <asm/barrier.h>
 #include <asm/mipsregs.h>
 
-static unsigned int initcount = 0;
-static atomic_t count_count_start = ATOMIC_INIT(0);
-static atomic_t count_count_stop = ATOMIC_INIT(0);
+#define STAGE_START		0
+#define STAGE_MASTER_READY	1
+#define STAGE_SLAVE_SYNCED	2
 
-#define COUNTON 100
-#define NR_LOOPS 3
+static unsigned int cur_count;
+static unsigned int fini_count;
+static atomic_t sync_stage = ATOMIC_INIT(0);
+static DEFINE_RAW_SPINLOCK(sync_r4k_lock);
 
-void synchronise_count_master(int cpu)
+#define MAX_LOOPS	1000
+
+void synchronise_count_master(void *unused)
 {
-	int i;
 	unsigned long flags;
+	long delta;
+	int i;
 
-	pr_info("Synchronize counters for CPU %u: ", cpu);
+	if (atomic_read(&sync_stage) != STAGE_START)
+		BUG();
 
 	local_irq_save(flags);
 
-	/*
-	 * We loop a few times to get a primed instruction cache,
-	 * then the last pass is more or less synchronised and
-	 * the master and slaves each set their cycle counters to a known
-	 * value all at once. This reduces the chance of having random offsets
-	 * between the processors, and guarantees that the maximum
-	 * delay between the cycle counters is never bigger than
-	 * the latency of information-passing (cachelines) between
-	 * two CPUs.
-	 */
-
-	for (i = 0; i < NR_LOOPS; i++) {
-		/* slaves loop on '!= 2' */
-		while (atomic_read(&count_count_start) != 1)
-			mb();
-		atomic_set(&count_count_stop, 0);
-		smp_wmb();
+	cur_count = read_c0_count();
+	smp_wmb();
+	atomic_inc(&sync_stage); /* inc to STAGE_MASTER_READY */
 
-		/* Let the slave writes its count register */
-		atomic_inc(&count_count_start);
-
-		/* Count will be initialised to current timer */
-		if (i == 1)
-			initcount = read_c0_count();
-
-		/*
-		 * Everyone initialises count in the last loop:
-		 */
-		if (i == NR_LOOPS-1)
-			write_c0_count(initcount);
-
-		/*
-		 * Wait for slave to leave the synchronization point:
-		 */
-		while (atomic_read(&count_count_stop) != 1)
-			mb();
-		atomic_set(&count_count_start, 0);
+	for (i = 0; i < MAX_LOOPS; i++) {
+		cur_count = read_c0_count();
 		smp_wmb();
-		atomic_inc(&count_count_stop);
+		if (atomic_read(&sync_stage) == STAGE_SLAVE_SYNCED)
+			break;
 	}
-	/* Arrange for an interrupt in a short while */
-	write_c0_compare(read_c0_count() + COUNTON);
+
+	delta = read_c0_count() - fini_count;
 
 	local_irq_restore(flags);
 
-	/*
-	 * i386 code reported the skew here, but the
-	 * count registers were almost certainly out of sync
-	 * so no point in alarming people
-	 */
-	pr_cont("done.\n");
+	if (i == MAX_LOOPS)
+		pr_err("sync-r4k: Master: synchronise timeout\n");
+	else
+		pr_info("sync-r4k: Master: synchronise succeed, maximum delta: %ld\n", delta);
+
+	return;
 }
 
 void synchronise_count_slave(int cpu)
 {
 	int i;
 	unsigned long flags;
+	call_single_data_t csd;
 
-	local_irq_save(flags);
+	raw_spin_lock(&sync_r4k_lock);
 
-	/*
-	 * Not every cpu is online at the time this gets called,
-	 * so we first wait for the master to say everyone is ready
-	 */
-
-	for (i = 0; i < NR_LOOPS; i++) {
-		atomic_inc(&count_count_start);
-		while (atomic_read(&count_count_start) != 2)
-			mb();
-
-		/*
-		 * Everyone initialises count in the last loop:
-		 */
-		if (i == NR_LOOPS-1)
-			write_c0_count(initcount);
-
-		atomic_inc(&count_count_stop);
-		while (atomic_read(&count_count_stop) != 2)
-			mb();
+	/* Let variables get attention from cache */
+	for (i = 0; i < MAX_LOOPS; i++) {
+		cur_count++;
+		fini_count += cur_count;
+		cur_count += fini_count;
 	}
-	/* Arrange for an interrupt in a short while */
-	write_c0_compare(read_c0_count() + COUNTON);
+
+	atomic_set(&sync_stage, STAGE_START);
+	csd.func = synchronise_count_master;
+
+	/* Master count is always CPU0 */
+	if (smp_call_function_single_async(0, &csd)) {
+		pr_err("sync-r4k: Salve: Failed to call master\n");
+		raw_spin_unlock(&sync_r4k_lock);
+		return;
+	}
+
+	local_irq_save(flags);
+
+	/* Wait until master ready */
+	while (atomic_read(&sync_stage) != STAGE_MASTER_READY)
+		cpu_relax();
+
+	write_c0_count(cur_count);
+	fini_count = read_c0_count();
+	smp_wmb();
+	atomic_inc(&sync_stage); /* inc to STAGE_SLAVE_SYNCED */
 
 	local_irq_restore(flags);
+
+	raw_spin_unlock(&sync_r4k_lock);
 }
-#undef NR_LOOPS
-- 
2.28.0.rc1

