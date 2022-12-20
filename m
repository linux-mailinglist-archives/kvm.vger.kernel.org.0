Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9168D652288
	for <lists+kvm@lfdr.de>; Tue, 20 Dec 2022 15:27:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234010AbiLTO1c (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 20 Dec 2022 09:27:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53936 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234050AbiLTO07 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 20 Dec 2022 09:26:59 -0500
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id A82621C425
        for <kvm@vger.kernel.org>; Tue, 20 Dec 2022 06:26:52 -0800 (PST)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 5354C2F4;
        Tue, 20 Dec 2022 06:27:33 -0800 (PST)
Received: from e126514.cambridge.arm.com (e126514.arm.com [10.1.36.32])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id 82D9D3F703;
        Tue, 20 Dec 2022 06:26:50 -0800 (PST)
From:   Nikita Venkatesh <Nikita.Venkatesh@arm.com>
To:     pbonzini@redhat.com, thuth@redhat.com, andrew.jones@linux.dev
Cc:     kvm@vger.kernel.org, suzuki.poulose@arm.com,
        alexandru.elisei@arm.com, nd@arm.com,
        Nikita Venkatesh <Nikita.Venkatesh@arm.com>
Subject: [kvm-unit-tests PATCH v3 1/2] arm/psci: Test that CPU 1 has been successfully brought online
Date:   Tue, 20 Dec 2022 14:31:55 +0000
Message-Id: <20221220143156.208143-2-Nikita.Venkatesh@arm.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20221220143156.208143-1-Nikita.Venkatesh@arm.com>
References: <20221220143156.208143-1-Nikita.Venkatesh@arm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Alexandru Elisei <alexandru.elisei@arm.com>

For the PSCI CPU_ON function test, all other CPUs perform a CPU_ON call
that target CPU 1. The test is considered a success if CPU_ON returns
SUCCESS exactly once, and for the rest of the calls ALREADY_ON.

Enhance the test by making sure that CPU 1 is actually online and able to
execute code. Since the CPU 1 thread is now being set up properly by
kvm-unit-tests when being brought online, it becomes possible to add other
tests in the future that require all CPUs.

Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>
Signed-off-by: Nikita Venkatesh <Nikita.Venkatesh@arm.com>
---
 arm/psci.c        | 30 +++++++++++++++++++++---------
 lib/arm/asm/smp.h |  1 +
 lib/arm/smp.c     | 12 +++++++++---
 3 files changed, 31 insertions(+), 12 deletions(-)

diff --git a/arm/psci.c b/arm/psci.c
index efa0722..0b9834c 100644
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
index 077afde..ff2ef8f 100644
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
index 98a5054..947f417 100644
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
2.25.1

