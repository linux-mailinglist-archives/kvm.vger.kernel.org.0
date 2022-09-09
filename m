Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C59FA5B3AB0
	for <lists+kvm@lfdr.de>; Fri,  9 Sep 2022 16:28:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231252AbiIIO2l (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 9 Sep 2022 10:28:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36322 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231196AbiIIO2i (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 9 Sep 2022 10:28:38 -0400
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 436E4A030E
        for <kvm@vger.kernel.org>; Fri,  9 Sep 2022 07:28:37 -0700 (PDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 5458E165C;
        Fri,  9 Sep 2022 07:28:43 -0700 (PDT)
Received: from monolith.localdoman (unknown [172.31.20.19])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 2A91E3F93E;
        Fri,  9 Sep 2022 07:28:36 -0700 (PDT)
From:   Alexandru Elisei <alexandru.elisei@arm.com>
To:     andrew.jones@linux.dev, kvm@vger.kernel.org,
        kvmarm@lists.cs.columbia.edu, Nikita.Venkatesh@arm.com
Subject: [kvm-unit-tests PATCH] arm/psci: Test that CPU 1 has been successfully brought online
Date:   Fri,  9 Sep 2022 15:29:25 +0100
Message-Id: <20220909142925.52198-1-alexandru.elisei@arm.com>
X-Mailer: git-send-email 2.37.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-6.9 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

For the PSCI CPU_ON function test, all other CPUs perform a CPU_ON call
that target CPU 1. The test is considered a success if CPU_ON returns
SUCCESS exactly once, and for the rest of the calls ALREADY_ON.

Enhance the test by making sure that CPU 1 is actually online and able to
execute code. Since the CPU 1 thread is now being set up properly by
kvm-unit-tests when being brought online, it becomes possible to add other
tests in the future that require all CPUs.

Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>
---

I got the idea for this patch when reviewing the CPU_OFF test [1].
Nonetheless, I think this patch has merit on its own.

[1] https://lore.kernel.org/kvm/20220805132601.461751-1-Nikita.Venkatesh@arm.com/

 arm/psci.c        | 30 +++++++++++++++++++++---------
 lib/arm/asm/smp.h |  1 +
 lib/arm/smp.c     | 12 +++++++++---
 3 files changed, 31 insertions(+), 12 deletions(-)

diff --git a/arm/psci.c b/arm/psci.c
index efa0722c0566..0b9834c2faaf 100644
--- a/arm/psci.c
+++ b/arm/psci.c
@@ -72,14 +72,23 @@ static int cpu_on_ret[NR_CPUS];
 static cpumask_t cpu_on_ready, cpu_on_done;
 static volatile int cpu_on_start;
 
-static void cpu_on_secondary_entry(void)
+extern void secondary_entry(void);
+static void cpu_on_wake_target(void)
 {
 	int cpu = smp_processor_id();
 
 	cpumask_set_cpu(cpu, &cpu_on_ready);
 	while (!cpu_on_start)
 		cpu_relax();
-	cpu_on_ret[cpu] = psci_cpu_on(cpus[1], __pa(halt));
+	cpu_on_ret[cpu] = psci_cpu_on(cpus[1], __pa(secondary_entry));
+	cpumask_set_cpu(cpu, &cpu_on_done);
+}
+
+static void cpu_on_target(void)
+{
+	int cpu = smp_processor_id();
+
+	cpu_on_ret[cpu] = PSCI_RET_ALREADY_ON;
 	cpumask_set_cpu(cpu, &cpu_on_done);
 }
 
@@ -89,31 +98,34 @@ static bool psci_cpu_on_test(void)
 	int ret_success = 0;
 	int cpu;
 
-	cpumask_set_cpu(1, &cpu_on_ready);
-	cpumask_set_cpu(1, &cpu_on_done);
-
 	for_each_present_cpu(cpu) {
 		if (cpu < 2)
 			continue;
-		smp_boot_secondary(cpu, cpu_on_secondary_entry);
+		smp_boot_secondary(cpu, cpu_on_wake_target);
 	}
 
 	cpumask_set_cpu(0, &cpu_on_ready);
+	cpumask_set_cpu(1, &cpu_on_ready);
 	while (!cpumask_full(&cpu_on_ready))
 		cpu_relax();
 
+	/*
+	 * Wait for all other CPUs to be online before configuring the thread
+	 * for the target CPU, as all secondaries are set up using the same
+	 * global variable.
+	 */
+	smp_prepare_secondary(1, cpu_on_target);
+
 	cpu_on_start = 1;
 	smp_mb();
 
-	cpu_on_ret[0] = psci_cpu_on(cpus[1], __pa(halt));
+	cpu_on_ret[0] = psci_cpu_on(cpus[1], __pa(secondary_entry));
 	cpumask_set_cpu(0, &cpu_on_done);
 
 	while (!cpumask_full(&cpu_on_done))
 		cpu_relax();
 
 	for_each_present_cpu(cpu) {
-		if (cpu == 1)
-			continue;
 		if (cpu_on_ret[cpu] == PSCI_RET_SUCCESS) {
 			ret_success++;
 		} else if (cpu_on_ret[cpu] != PSCI_RET_ALREADY_ON) {
diff --git a/lib/arm/asm/smp.h b/lib/arm/asm/smp.h
index 077afde85520..ff2ef8f88247 100644
--- a/lib/arm/asm/smp.h
+++ b/lib/arm/asm/smp.h
@@ -49,6 +49,7 @@ static inline void set_cpu_idle(int cpu, bool idle)
 }
 
 typedef void (*secondary_entry_fn)(void);
+extern void smp_prepare_secondary(int cpu, secondary_entry_fn entry);
 extern void smp_boot_secondary(int cpu, secondary_entry_fn entry);
 extern void on_cpu_async(int cpu, void (*func)(void *data), void *data);
 extern void on_cpu(int cpu, void (*func)(void *data), void *data);
diff --git a/lib/arm/smp.c b/lib/arm/smp.c
index 98a5054e039b..947f417f4aea 100644
--- a/lib/arm/smp.c
+++ b/lib/arm/smp.c
@@ -58,13 +58,19 @@ secondary_entry_fn secondary_cinit(void)
 	return entry;
 }
 
-static void __smp_boot_secondary(int cpu, secondary_entry_fn entry)
+void smp_prepare_secondary(int cpu, secondary_entry_fn entry)
 {
-	int ret;
-
 	secondary_data.stack = thread_stack_alloc();
 	secondary_data.entry = entry;
 	mmu_mark_disabled(cpu);
+}
+
+static void __smp_boot_secondary(int cpu, secondary_entry_fn entry)
+{
+	int ret;
+
+	smp_prepare_secondary(cpu, entry);
+
 	ret = cpu_psci_cpu_boot(cpu);
 	assert(ret == 0);
 
-- 
2.37.0

