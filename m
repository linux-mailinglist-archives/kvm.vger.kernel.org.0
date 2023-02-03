Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0D73E689F18
	for <lists+kvm@lfdr.de>; Fri,  3 Feb 2023 17:24:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232166AbjBCQYQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 3 Feb 2023 11:24:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47044 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231526AbjBCQYN (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 3 Feb 2023 11:24:13 -0500
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id D53519E9C5
        for <kvm@vger.kernel.org>; Fri,  3 Feb 2023 08:24:11 -0800 (PST)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id CA93E1596;
        Fri,  3 Feb 2023 08:24:53 -0800 (PST)
Received: from monolith.localdoman (unknown [172.31.20.19])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 939073F71E;
        Fri,  3 Feb 2023 08:24:10 -0800 (PST)
From:   Alexandru Elisei <alexandru.elisei@arm.com>
To:     andrew.jones@linux.dev, kvm@vger.kernel.org, kvmarm@lists.linux.dev
Cc:     Nikita Venkatesh <Nikita.Venkatesh@arm.com>
Subject: [kvm-unit-tests PATCH v6 2/2] arm/psci: Add PSCI CPU_OFF test case
Date:   Fri,  3 Feb 2023 16:23:53 +0000
Message-Id: <20230203162353.34876-3-alexandru.elisei@arm.com>
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

From: Nikita Venkatesh <Nikita.Venkatesh@arm.com>

The test uses the following method.

The primary CPU brings up all the secondary CPUs, which are held in a wait
loop. Once the primary releases the CPUs, each of the secondary CPUs
proceed to issue CPU_OFF.

The primary CPU then checks for the status of the individual CPU_OFF
request. There is a chance that some CPUs might return from the CPU_OFF
function call after the primary CPU has finished the scan. There is no
foolproof method to handle this, but the test tries its best to
eliminate these false positives by introducing an extra delay if all the
CPUs are reported offline after the initial scan.

Signed-off-by: Nikita Venkatesh <Nikita.Venkatesh@arm.com>
[ Alex E: Skip CPU_OFF test if cpu onlining failed, drop cpu_off_success in
          favour of checking AFFINITY_INFO, commit message tweaking ]
Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>
---
 arm/psci.c | 71 +++++++++++++++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 70 insertions(+), 1 deletion(-)

diff --git a/arm/psci.c b/arm/psci.c
index f7238f8e0bbd..55308c8f4766 100644
--- a/arm/psci.c
+++ b/arm/psci.c
@@ -72,8 +72,9 @@ static bool psci_affinity_info_off(void)
 }
 
 static int cpu_on_ret[NR_CPUS];
-static cpumask_t cpu_on_ready, cpu_on_done;
+static cpumask_t cpu_on_ready, cpu_on_done, cpu_off_done;
 static volatile int cpu_on_start;
+static volatile int cpu_off_start;
 
 extern void secondary_entry(void);
 static void cpu_on_do_wake_target(void)
@@ -171,6 +172,67 @@ static bool psci_cpu_on_test(void)
 	return !failed;
 }
 
+static void cpu_off_secondary_entry(void *data)
+{
+	int cpu = smp_processor_id();
+
+	while (!cpu_off_start)
+		cpu_relax();
+	cpumask_set_cpu(cpu, &cpu_off_done);
+	cpu_psci_cpu_die();
+}
+
+static bool psci_cpu_off_test(void)
+{
+	bool failed = false;
+	int i, count, cpu;
+
+	for_each_present_cpu(cpu) {
+		if (cpu == 0)
+			continue;
+		on_cpu_async(cpu, cpu_off_secondary_entry, NULL);
+	}
+
+	cpumask_set_cpu(0, &cpu_off_done);
+
+	cpu_off_start = 1;
+	report_info("waiting for the CPUs to be offlined...");
+	while (!cpumask_full(&cpu_off_done))
+		cpu_relax();
+
+	/* Allow all the other CPUs to complete the operation */
+	for (i = 0; i < 100; i++) {
+		mdelay(10);
+
+		count = 0;
+		for_each_present_cpu(cpu) {
+			if (cpu == 0)
+				continue;
+			if (psci_affinity_info(cpus[cpu], 0) != PSCI_0_2_AFFINITY_LEVEL_OFF)
+				count++;
+		}
+		if (count == 0)
+			break;
+	}
+
+	/* Try to catch CPUs that return from CPU_OFF. */
+	if (count == 0)
+		mdelay(100);
+
+	for_each_present_cpu(cpu) {
+		if (cpu == 0)
+			continue;
+		if (cpu_idle(cpu)) {
+			report_info("CPU%d failed to be offlined", cpu);
+			if (psci_affinity_info(cpus[cpu], 0) == PSCI_0_2_AFFINITY_LEVEL_OFF)
+				report_info("AFFINITY_INFO incorrectly reports CPU%d as offline", cpu);
+			failed = true;
+		}
+	}
+
+	return !failed;
+}
+
 int main(void)
 {
 	int ver = psci_invoke(PSCI_0_2_FN_PSCI_VERSION, 0, 0, 0);
@@ -193,6 +255,13 @@ int main(void)
 	else
 		report_skip("Skipping unsafe cpu-on test. Set ERRATA_6c7a5dce22b3=y to enable.");
 
+	assert(!cpu_idle(0));
+
+	if (!ERRATA(6c7a5dce22b3) || cpumask_weight(&cpu_idle_mask) == nr_cpus - 1)
+		report(psci_cpu_off_test(), "cpu-off");
+	else
+		report_skip("Skipping cpu-off test because the cpu-on test failed");
+
 done:
 #if 0
 	report_summary();
-- 
2.39.1

