Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F3F9B642808
	for <lists+kvm@lfdr.de>; Mon,  5 Dec 2022 13:07:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231475AbiLEMHN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 5 Dec 2022 07:07:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44282 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230332AbiLEMHJ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 5 Dec 2022 07:07:09 -0500
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id CCA7AC76A
        for <kvm@vger.kernel.org>; Mon,  5 Dec 2022 04:07:08 -0800 (PST)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 486AC106F;
        Mon,  5 Dec 2022 04:07:15 -0800 (PST)
Received: from e126514.cambridge.arm.com (unknown [172.31.20.19])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id 8039C3F73D;
        Mon,  5 Dec 2022 04:07:06 -0800 (PST)
From:   Nikita Venkatesh <Nikita.Venkatesh@arm.com>
To:     pbonzini@redhat.com, thuth@redhat.com, andrew.jones@linux.dev
Cc:     kvm@vger.kernel.org, Suzuki.Poulose@arm.com,
        Alexandru.Elisei@arm.com, nd@arm.com,
        Nikita Venkatesh <Nikita.Venkatesh@arm.com>
Subject: [PATCH 2/2] arm/psci: Add PSCI_CPU_OFF testscase to arm/psci testsuite
Date:   Mon,  5 Dec 2022 12:10:53 +0000
Message-Id: <20221205121053.125964-3-Nikita.Venkatesh@arm.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20221205121053.125964-1-Nikita.Venkatesh@arm.com>
References: <20221205121053.125964-1-Nikita.Venkatesh@arm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The test uses the following method.

The primary CPU brings up all the secondary CPUs, which are held in a wait
loop. Once the primary releases the CPUs, each of the secondary CPUs
proceed to issue PSCI_CPU_OFF. This is indicated by a cpumask and also
the status of the call is updated by the secondary CPU in cpu_off_done[].

The primary CPU waits for all the secondary CPUs to update the cpumask
and then proceeds to check for the status of the individual CPU CPU_OFF
request. There is a chance that some CPUs might fail at the CPU_OFF
request and come back and update the status once the primary CPU has
finished the scan. There is no fool proof method to handle this. As of
now, we add a 1sec delay between the cpumask check and the scan for the
status.

Signed-off-by: Nikita Venkatesh <Nikita.Venkatesh@arm.com>
---
 arm/psci.c | 76 +++++++++++++++++++++++++++++++++++++++++++++++++-----
 1 file changed, 70 insertions(+), 6 deletions(-)

diff --git a/arm/psci.c b/arm/psci.c
index 0b9834c..9a49347 100644
--- a/arm/psci.c
+++ b/arm/psci.c
@@ -12,6 +12,9 @@
 #include <asm/processor.h>
 #include <asm/smp.h>
 #include <asm/psci.h>
+#include <asm/delay.h>
+
+#define CPU_OFF_TEST_WAIT_TIME 1000
 
 static bool invalid_function_exception;
 
@@ -69,8 +72,10 @@ static bool psci_affinity_info_off(void)
 }
 
 static int cpu_on_ret[NR_CPUS];
-static cpumask_t cpu_on_ready, cpu_on_done;
+static bool cpu_off_success[NR_CPUS];
+static cpumask_t cpu_on_ready, cpu_on_done, cpu_off_done;
 static volatile int cpu_on_start;
+static volatile int cpu_off_start;
 
 extern void secondary_entry(void);
 static void cpu_on_wake_target(void)
@@ -92,6 +97,20 @@ static void cpu_on_target(void)
 	cpumask_set_cpu(cpu, &cpu_on_done);
 }
 
+static void cpu_off_secondary_entry(void *data)
+{
+       int cpu = smp_processor_id();
+
+       while (!cpu_off_start)
+               cpu_relax();
+       /* On to the CPU off test */
+       cpu_off_success[cpu] = true;
+       cpumask_set_cpu(cpu, &cpu_off_done);
+       cpu_psci_cpu_die();
+       /* The CPU shouldn't execute the next steps. */
+       cpu_off_success[cpu] = false;
+}
+
 static bool psci_cpu_on_test(void)
 {
 	bool failed = false;
@@ -142,7 +161,48 @@ static bool psci_cpu_on_test(void)
 	return !failed;
 }
 
-int main(void)
+static void secondary_entry_stub (void *unused)
+{
+}
+
+static bool psci_cpu_off_test(void)
+{
+       bool failed = false;
+       int cpu;
+
+       for_each_present_cpu(cpu) {
+               if (cpu == 0)
+                       continue;
+               on_cpu_async(cpu, cpu_off_secondary_entry, NULL);
+       }
+
+       cpumask_set_cpu(0, &cpu_off_done);
+
+       report_info("starting CPU_OFF test...");
+
+       /* Release the CPUs */
+       cpu_off_start = 1;
+
+       /* Wait until all are done */
+       while (!cpumask_full(&cpu_off_done))
+               cpu_relax();
+
+       /* Allow all the other CPUs to complete the operation */
+       mdelay(CPU_OFF_TEST_WAIT_TIME);
+
+       for_each_present_cpu(cpu) {
+               if (cpu == 0)
+                       continue;
+
+               if (!cpu_off_success[cpu]) {
+                       report_info("CPU%d could not be turned off", cpu);
+                       failed = true;
+               }
+       }
+       return !failed;
+}
+
+int main(int argc, char **argv)
 {
 	int ver = psci_invoke(PSCI_0_2_FN_PSCI_VERSION, 0, 0, 0);
 
@@ -155,14 +215,18 @@ int main(void)
 
 	report_info("PSCI version %d.%d", PSCI_VERSION_MAJOR(ver),
 					  PSCI_VERSION_MINOR(ver));
+
 	report(psci_invalid_function(), "invalid-function");
-	report(psci_affinity_info_on(), "affinity-info-on");
-	report(psci_affinity_info_off(), "affinity-info-off");
+        report(psci_affinity_info_on(), "affinity-info-on");
+        report(psci_affinity_info_off(), "affinity-info-off");
 
-	if (ERRATA(6c7a5dce22b3))
+        if (ERRATA(6c7a5dce22b3)){
 		report(psci_cpu_on_test(), "cpu-on");
-	else
+	} else {
 		report_skip("Skipping unsafe cpu-on test. Set ERRATA_6c7a5dce22b3=y to enable.");
+		on_cpus(secondary_entry_stub, NULL);
+	}
+	report(psci_cpu_off_test(), "cpu-off");
 
 done:
 #if 0
-- 
2.25.1

