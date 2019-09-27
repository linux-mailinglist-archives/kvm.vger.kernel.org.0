Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6712CC0399
	for <lists+kvm@lfdr.de>; Fri, 27 Sep 2019 12:42:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727128AbfI0Kmk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 27 Sep 2019 06:42:40 -0400
Received: from foss.arm.com ([217.140.110.172]:48764 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726809AbfI0Kmj (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 27 Sep 2019 06:42:39 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id F3E8328;
        Fri, 27 Sep 2019 03:42:38 -0700 (PDT)
Received: from donnerap.arm.com (donnerap.cambridge.arm.com [10.1.197.44])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 330543F534;
        Fri, 27 Sep 2019 03:42:38 -0700 (PDT)
From:   Andre Przywara <andre.przywara@arm.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Andrew Jones <drjones@redhat.com>
Cc:     kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org
Subject: [kvm-unit-tests PATCH 5/6] arm: selftest: Make MPIDR output stable
Date:   Fri, 27 Sep 2019 11:42:26 +0100
Message-Id: <20190927104227.253466-6-andre.przywara@arm.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190927104227.253466-1-andre.przywara@arm.com>
References: <20190927104227.253466-1-andre.przywara@arm.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

At the moment the smp selftest outputs one line for each vCPU, with the
CPU number and its MPIDR printed in the same test result line.
For automated test frameworks this has the problem of including variable
output in the test name, also the number of tests varies, depending on the
number of vCPUs.

Fix this by only generating a single line of output for the SMP test,
which summarises the result. We use two cpumasks, to let each vCPU report
its result and completion of the test (code stolen from the GIC test).

For informational purposes we keep the one line per CPU, but prefix it
with an INFO: tag, so that frameworks can ignore it.

Signed-off-by: Andre Przywara <andre.przywara@arm.com>
---
 arm/selftest.c | 14 ++++++++++++--
 1 file changed, 12 insertions(+), 2 deletions(-)

diff --git a/arm/selftest.c b/arm/selftest.c
index a0c1ab8..e9dc5c0 100644
--- a/arm/selftest.c
+++ b/arm/selftest.c
@@ -17,6 +17,8 @@
 #include <asm/smp.h>
 #include <asm/barrier.h>
 
+static cpumask_t ready, valid;
+
 static void __user_psci_system_off(void)
 {
 	psci_system_off();
@@ -341,8 +343,11 @@ static void cpu_report(void *data __unused)
 	uint64_t mpidr = get_mpidr();
 	int cpu = smp_processor_id();
 
-	report("CPU(%3d) mpidr=%010" PRIx64,
-		mpidr_to_cpu(mpidr) == cpu, cpu, mpidr);
+	if (mpidr_to_cpu(mpidr) == cpu)
+		cpumask_set_cpu(smp_processor_id(), &valid);
+	smp_wmb();		/* Paired with rmb in main(). */
+	cpumask_set_cpu(smp_processor_id(), &ready);
+	report_info("CPU%3d: MPIDR=%010" PRIx64, cpu, mpidr);
 }
 
 int main(int argc, char **argv)
@@ -371,6 +376,11 @@ int main(int argc, char **argv)
 
 		report("PSCI version", psci_check());
 		on_cpus(cpu_report, NULL);
+		while (!cpumask_full(&ready))
+			cpu_relax();
+		smp_rmb();		/* Paired with wmb in cpu_report(). */
+		report("MPIDR test on all CPUs", cpumask_full(&valid));
+		report_info("%d CPUs reported back", nr_cpus);
 
 	} else {
 		printf("Unknown subtest\n");
-- 
2.17.1

