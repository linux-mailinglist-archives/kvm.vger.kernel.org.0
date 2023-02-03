Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 063FB689F17
	for <lists+kvm@lfdr.de>; Fri,  3 Feb 2023 17:24:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231855AbjBCQYO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 3 Feb 2023 11:24:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47026 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231593AbjBCQYN (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 3 Feb 2023 11:24:13 -0500
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 78465A6B98
        for <kvm@vger.kernel.org>; Fri,  3 Feb 2023 08:24:10 -0800 (PST)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 762D21474;
        Fri,  3 Feb 2023 08:24:52 -0800 (PST)
Received: from monolith.localdoman (unknown [172.31.20.19])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 67AC13F71E;
        Fri,  3 Feb 2023 08:24:09 -0800 (PST)
From:   Alexandru Elisei <alexandru.elisei@arm.com>
To:     andrew.jones@linux.dev, kvm@vger.kernel.org, kvmarm@lists.linux.dev
Subject: [kvm-unit-tests PATCH v6 1/2] arm/psci: Test that CPU 1 has been successfully brought online
Date:   Fri,  3 Feb 2023 16:23:52 +0000
Message-Id: <20230203162353.34876-2-alexandru.elisei@arm.com>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230203162353.34876-1-alexandru.elisei@arm.com>
References: <20230203162353.34876-1-alexandru.elisei@arm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

For the PSCI CPU_ON function test, all other CPUs perform a CPU_ON call
that target CPU 1. The test is considered a success if CPU_ON returns PSCI
SUCCESS exactly once, and for the rest of the calls PSCI ALREADY_ON.

Enhance the test by checking that CPU 1 is actually online and able to
execute code. Also make the test more robust by checking that the CPU_ON
call returns, instead of assuming that it will always succeed and
hanging indefinitely if it doesn't.

Since the CPU 1 thread is now being set up properly by kvm-unit-tests
when being brought online, it becomes possible to add other tests in the
future that require all CPUs.

The include header order in arm/psci.c has been changed to be in
alphabetic order. This means moving the errata.h include before
libcflat.h, which causes compilation to fail because of missing includes
in errata.h. Fix that also by including the needed header in errata.h.

Reviewed-by: Andrew Jones <andrew.jones@linux.dev>
Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>
---
 arm/psci.c        | 67 ++++++++++++++++++++++++++++++++++++++---------
 lib/arm/asm/smp.h |  9 ++++++-
 lib/arm/smp.c     |  4 ---
 lib/errata.h      |  2 ++
 4 files changed, 64 insertions(+), 18 deletions(-)

diff --git a/arm/psci.c b/arm/psci.c
index efa0722c0566..f7238f8e0bbd 100644
--- a/arm/psci.c
+++ b/arm/psci.c
@@ -7,11 +7,14 @@
  *
  * This work is licensed under the terms of the GNU LGPL, version 2.
  */
-#include <libcflat.h>
 #include <errata.h>
+#include <libcflat.h>
+
+#include <asm/delay.h>
+#include <asm/mmu.h>
 #include <asm/processor.h>
-#include <asm/smp.h>
 #include <asm/psci.h>
+#include <asm/smp.h>
 
 static bool invalid_function_exception;
 
@@ -72,46 +75,84 @@ static int cpu_on_ret[NR_CPUS];
 static cpumask_t cpu_on_ready, cpu_on_done;
 static volatile int cpu_on_start;
 
-static void cpu_on_secondary_entry(void)
+extern void secondary_entry(void);
+static void cpu_on_do_wake_target(void)
 {
 	int cpu = smp_processor_id();
 
 	cpumask_set_cpu(cpu, &cpu_on_ready);
 	while (!cpu_on_start)
 		cpu_relax();
-	cpu_on_ret[cpu] = psci_cpu_on(cpus[1], __pa(halt));
+	cpu_on_ret[cpu] = psci_cpu_on(cpus[1], __pa(secondary_entry));
 	cpumask_set_cpu(cpu, &cpu_on_done);
 }
 
+static void cpu_on_target(void)
+{
+	int cpu = smp_processor_id();
+
+	cpumask_set_cpu(cpu, &cpu_on_done);
+}
+
+extern struct secondary_data secondary_data;
+
+/* Open code the setup part from smp_boot_secondary(). */
+static void psci_cpu_on_prepare_secondary(int cpu, secondary_entry_fn entry)
+{
+	secondary_data.stack = thread_stack_alloc();
+	secondary_data.entry = entry;
+	mmu_mark_disabled(cpu);
+}
+
 static bool psci_cpu_on_test(void)
 {
 	bool failed = false;
 	int ret_success = 0;
-	int cpu;
-
-	cpumask_set_cpu(1, &cpu_on_ready);
-	cpumask_set_cpu(1, &cpu_on_done);
+	int i, cpu;
 
 	for_each_present_cpu(cpu) {
 		if (cpu < 2)
 			continue;
-		smp_boot_secondary(cpu, cpu_on_secondary_entry);
+		smp_boot_secondary(cpu, cpu_on_do_wake_target);
 	}
 
 	cpumask_set_cpu(0, &cpu_on_ready);
+	cpumask_set_cpu(1, &cpu_on_ready);
 	while (!cpumask_full(&cpu_on_ready))
 		cpu_relax();
 
+	/*
+	 * Configure CPU 1 after all secondaries are online to avoid
+	 * secondary_data being overwritten.
+	 */
+	psci_cpu_on_prepare_secondary(1, cpu_on_target);
+
 	cpu_on_start = 1;
 	smp_mb();
 
-	cpu_on_ret[0] = psci_cpu_on(cpus[1], __pa(halt));
+	cpu_on_ret[0] = psci_cpu_on(cpus[1], __pa(secondary_entry));
 	cpumask_set_cpu(0, &cpu_on_done);
 
-	while (!cpumask_full(&cpu_on_done))
-		cpu_relax();
+	report_info("waiting for CPU1 to come online...");
+	for (i = 0; i < 100; i++) {
+		mdelay(10);
+		if (cpumask_full(&cpu_on_done))
+			break;
+	}
 
-	for_each_present_cpu(cpu) {
+	if (!cpumask_full(&cpu_on_done)) {
+		for_each_present_cpu(cpu) {
+			if (!cpumask_test_cpu(cpu, &cpu_on_done)) {
+				if (cpu == 1)
+					report_info("CPU1 failed to come online");
+				else
+					report_info("CPU%d failed to online CPU1", cpu);
+			}
+		}
+		failed = true;
+	}
+
+	for_each_cpu(cpu, &cpu_on_done) {
 		if (cpu == 1)
 			continue;
 		if (cpu_on_ret[cpu] == PSCI_RET_SUCCESS) {
diff --git a/lib/arm/asm/smp.h b/lib/arm/asm/smp.h
index 077afde85520..dee4c1a883e7 100644
--- a/lib/arm/asm/smp.h
+++ b/lib/arm/asm/smp.h
@@ -10,6 +10,14 @@
 
 #define smp_processor_id()		(current_thread_info()->cpu)
 
+typedef void (*secondary_entry_fn)(void);
+
+struct secondary_data {
+	void *stack;            /* must be first member of struct */
+	secondary_entry_fn entry;
+};
+extern struct secondary_data secondary_data;
+
 extern bool cpu0_calls_idle;
 
 extern void halt(void);
@@ -48,7 +56,6 @@ static inline void set_cpu_idle(int cpu, bool idle)
 		cpumask_clear_cpu(cpu, &cpu_idle_mask);
 }
 
-typedef void (*secondary_entry_fn)(void);
 extern void smp_boot_secondary(int cpu, secondary_entry_fn entry);
 extern void on_cpu_async(int cpu, void (*func)(void *data), void *data);
 extern void on_cpu(int cpu, void (*func)(void *data), void *data);
diff --git a/lib/arm/smp.c b/lib/arm/smp.c
index 98a5054e039b..1d470d1aab45 100644
--- a/lib/arm/smp.c
+++ b/lib/arm/smp.c
@@ -21,10 +21,6 @@ cpumask_t cpu_present_mask;
 cpumask_t cpu_online_mask;
 cpumask_t cpu_idle_mask;
 
-struct secondary_data {
-	void *stack;            /* must be first member of struct */
-	secondary_entry_fn entry;
-};
 struct secondary_data secondary_data;
 static struct spinlock lock;
 
diff --git a/lib/errata.h b/lib/errata.h
index 5af0eb3bf8e2..de8205d8b370 100644
--- a/lib/errata.h
+++ b/lib/errata.h
@@ -6,6 +6,8 @@
  */
 #ifndef _ERRATA_H_
 #define _ERRATA_H_
+#include <libcflat.h>
+
 #include "config.h"
 
 #ifndef CONFIG_ERRATA_FORCE
-- 
2.39.1

