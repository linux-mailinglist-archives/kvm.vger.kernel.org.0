Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CFF602DD2BF
	for <lists+kvm@lfdr.de>; Thu, 17 Dec 2020 15:16:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728375AbgLQOPp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 17 Dec 2020 09:15:45 -0500
Received: from foss.arm.com ([217.140.110.172]:38560 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728331AbgLQOPo (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 17 Dec 2020 09:15:44 -0500
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 09F7A143D;
        Thu, 17 Dec 2020 06:14:23 -0800 (PST)
Received: from monolith.localdoman (unknown [172.31.20.19])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 1BA193F85F;
        Thu, 17 Dec 2020 06:14:21 -0800 (PST)
From:   Alexandru Elisei <alexandru.elisei@arm.com>
To:     drjones@redhat.com, kvm@vger.kernel.org,
        kvmarm@lists.cs.columbia.edu
Cc:     andre.przywara@arm.com, eric.auger@redhat.com, yuzenghui@huawei.com
Subject: [kvm-unit-tests PATCH v2 12/12] arm64: gic: Use IPI test checking for the LPI tests
Date:   Thu, 17 Dec 2020 14:14:00 +0000
Message-Id: <20201217141400.106137-13-alexandru.elisei@arm.com>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201217141400.106137-1-alexandru.elisei@arm.com>
References: <20201217141400.106137-1-alexandru.elisei@arm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The LPI code validates a result similarly to the IPI tests, by checking if
the target CPU received the interrupt with the expected interrupt number.
However, the LPI tests invent their own way of checking the test results by
creating a global struct (lpi_stats), using a separate interrupt handler
(lpi_handler) and test function (check_lpi_stats).

There are several areas that can be improved in the LPI code, which are
already covered by the IPI tests:

- check_lpi_stats() doesn't take into account that the target CPU can
  receive the correct interrupt multiple times.
- check_lpi_stats() doesn't take into the account the scenarios where all
  online CPUs can receive the interrupt, but the target CPU is the last CPU
  that touches lpi_stats.observed.
- Insufficient or missing memory synchronization.

Instead of duplicating code, let's convert the LPI tests to use
check_acked() and the same interrupt handler as the IPI tests, which has
been renamed to irq_handler() to avoid any confusion.

check_lpi_stats() has been replaced with check_acked() which, together with
using irq_handler(), instantly gives us more correctness checks and proper
memory synchronization between threads. lpi_stats.expected has been
replaced by the CPU mask and the expected interrupt number arguments to
check_acked(), with no change in semantics.

lpi_handler() aborted the test if the interrupt number was not an LPI. This
was changed in favor of allowing the test to continue, as it will fail in
check_acked(), but possibly print information useful for debugging. If the
test receives spurious interrupts, those are reported via report_info() at
the end of the test for consistency with the IPI tests, which don't treat
spurious interrupts as critical errors.

In the spirit of code reuse, secondary_lpi_tests() has been replaced with
ipi_recv() because the two are now identical; ipi_recv() has been renamed
to irq_recv(), similarly to irq_handler(), to avoid confusion.

CC: Eric Auger <eric.auger@redhat.com>
Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>
---
 arm/gic.c | 190 +++++++++++++++++++++++++-----------------------------
 1 file changed, 87 insertions(+), 103 deletions(-)

diff --git a/arm/gic.c b/arm/gic.c
index aa3aa1763984..53944753db63 100644
--- a/arm/gic.c
+++ b/arm/gic.c
@@ -105,13 +105,12 @@ static bool check_acked(cpumask_t *mask, int sender, int irqnum)
 				++missing;
 			else if (acked[cpu] > 1)
 				++extra;
-		} else {
-			if (acked[cpu])
+		} else if (acked[cpu]) {
 				++unexpected;
 		}
 		if (!acked[cpu])
 			continue;
-		smp_rmb(); /* pairs with smp_wmb in ipi_handler */
+		smp_rmb(); /* pairs with smp_wmb in irq_handler */
 
 		if (has_gicv2 && irq_sender[cpu] != sender) {
 			report_info("cpu%d received IPI from wrong sender %d",
@@ -149,11 +148,12 @@ static void check_spurious(void)
 static int gic_get_sender(int irqstat)
 {
 	if (gic_version() == 2)
+		/* GICC_IAR.CPUID is RAZ for non-SGIs */
 		return (irqstat >> 10) & 7;
 	return -1;
 }
 
-static void ipi_handler(struct pt_regs *regs __unused)
+static void irq_handler(struct pt_regs *regs __unused)
 {
 	u32 irqstat = gic_read_iar();
 	u32 irqnr = gic_iar_irqnr(irqstat);
@@ -192,75 +192,6 @@ static void setup_irq(irq_handler_fn handler)
 }
 
 #if defined(__aarch64__)
-struct its_event {
-	int cpu_id;
-	int lpi_id;
-};
-
-struct its_stats {
-	struct its_event expected;
-	struct its_event observed;
-};
-
-static struct its_stats lpi_stats;
-
-static void lpi_handler(struct pt_regs *regs __unused)
-{
-	u32 irqstat = gic_read_iar();
-	int irqnr = gic_iar_irqnr(irqstat);
-
-	gic_write_eoir(irqstat);
-	assert(irqnr >= 8192);
-	smp_rmb(); /* pairs with wmb in lpi_stats_expect */
-	lpi_stats.observed.cpu_id = smp_processor_id();
-	lpi_stats.observed.lpi_id = irqnr;
-	acked[lpi_stats.observed.cpu_id]++;
-	smp_wmb(); /* pairs with rmb in check_lpi_stats */
-}
-
-static void lpi_stats_expect(int exp_cpu_id, int exp_lpi_id)
-{
-	lpi_stats.expected.cpu_id = exp_cpu_id;
-	lpi_stats.expected.lpi_id = exp_lpi_id;
-	lpi_stats.observed.cpu_id = -1;
-	lpi_stats.observed.lpi_id = -1;
-	smp_wmb(); /* pairs with rmb in handler */
-}
-
-static void check_lpi_stats(const char *msg)
-{
-	int i;
-
-	for (i = 0; i < 50; i++) {
-		mdelay(100);
-		smp_rmb(); /* pairs with wmb in lpi_handler */
-		if (lpi_stats.observed.cpu_id == lpi_stats.expected.cpu_id &&
-		    lpi_stats.observed.lpi_id == lpi_stats.expected.lpi_id) {
-			report(true, "%s", msg);
-			return;
-		}
-	}
-
-	if (lpi_stats.observed.cpu_id == -1 && lpi_stats.observed.lpi_id == -1) {
-		report_info("No LPI received whereas (cpuid=%d, intid=%d) "
-			    "was expected", lpi_stats.expected.cpu_id,
-			    lpi_stats.expected.lpi_id);
-	} else {
-		report_info("Unexpected LPI (cpuid=%d, intid=%d)",
-			    lpi_stats.observed.cpu_id,
-			    lpi_stats.observed.lpi_id);
-	}
-	report(false, "%s", msg);
-}
-
-static void secondary_lpi_test(void)
-{
-	setup_irq(lpi_handler);
-	cpumask_set_cpu(smp_processor_id(), &ready);
-	while (1)
-		wfi();
-}
-
 static void check_lpi_hits(int *expected, const char *msg)
 {
 	bool pass = true;
@@ -350,7 +281,7 @@ static void ipi_test_smp(void)
 
 static void ipi_send(void)
 {
-	setup_irq(ipi_handler);
+	setup_irq(irq_handler);
 	wait_on_ready();
 	ipi_test_self();
 	ipi_test_smp();
@@ -358,9 +289,9 @@ static void ipi_send(void)
 	exit(report_summary());
 }
 
-static void ipi_recv(void)
+static void irq_recv(void)
 {
-	setup_irq(ipi_handler);
+	setup_irq(irq_handler);
 	cpumask_set_cpu(smp_processor_id(), &ready);
 	while (1)
 		wfi();
@@ -371,7 +302,7 @@ static void ipi_test(void *data __unused)
 	if (smp_processor_id() == IPI_SENDER)
 		ipi_send();
 	else
-		ipi_recv();
+		irq_recv();
 }
 
 static struct gic gicv2 = {
@@ -699,14 +630,12 @@ static int its_prerequisites(int nb_cpus)
 		return -1;
 	}
 
-	stats_reset();
-
-	setup_irq(lpi_handler);
+	setup_irq(irq_handler);
 
 	for_each_present_cpu(cpu) {
 		if (cpu == 0)
 			continue;
-		smp_boot_secondary(cpu, secondary_lpi_test);
+		smp_boot_secondary(cpu, irq_recv);
 	}
 	wait_on_ready();
 
@@ -760,6 +689,7 @@ static void test_its_trigger(void)
 {
 	struct its_collection *col3;
 	struct its_device *dev2, *dev7;
+	cpumask_t mask;
 
 	if (its_setup1())
 		return;
@@ -770,13 +700,21 @@ static void test_its_trigger(void)
 
 	report_prefix_push("int");
 
-	lpi_stats_expect(3, 8195);
+	stats_reset();
+	cpumask_clear(&mask);
+	cpumask_set_cpu(3, &mask);
 	its_send_int(dev2, 20);
-	check_lpi_stats("dev=2, eventid=20  -> lpi= 8195, col=3");
+	wait_for_interrupts(&mask);
+	report(check_acked(&mask, 0, 8195),
+			"dev=2, eventid=20  -> lpi= 8195, col=3");
 
-	lpi_stats_expect(2, 8196);
+	stats_reset();
+	cpumask_clear(&mask);
+	cpumask_set_cpu(2, &mask);
 	its_send_int(dev7, 255);
-	check_lpi_stats("dev=7, eventid=255 -> lpi= 8196, col=2");
+	wait_for_interrupts(&mask);
+	report(check_acked(&mask, 0, 8196),
+			"dev=7, eventid=255 -> lpi= 8196, col=2");
 
 	report_prefix_pop();
 
@@ -789,9 +727,12 @@ static void test_its_trigger(void)
 	gicv3_lpi_set_config(8195, LPI_PROP_DEFAULT & ~LPI_PROP_ENABLED);
 	its_send_inv(dev2, 20);
 
-	lpi_stats_expect(-1, -1);
+	stats_reset();
+	cpumask_clear(&mask);
 	its_send_int(dev2, 20);
-	check_lpi_stats("dev2/eventid=20 does not trigger any LPI");
+	wait_for_interrupts(&mask);
+	report(check_acked(&mask, -1, -1),
+			"dev2/eventid=20 does not trigger any LPI");
 
 	/*
 	 * re-enable the LPI but willingly do not call invall
@@ -799,18 +740,31 @@ static void test_its_trigger(void)
 	 * The LPI should not hit
 	 */
 	gicv3_lpi_set_config(8195, LPI_PROP_DEFAULT);
-	lpi_stats_expect(-1, -1);
+	stats_reset();
+	cpumask_clear(&mask);
 	its_send_int(dev2, 20);
-	check_lpi_stats("dev2/eventid=20 still does not trigger any LPI");
+	wait_for_interrupts(&mask);
+	report(check_acked(&mask, -1, -1),
+			"dev2/eventid=20 still does not trigger any LPI");
 
 	/* Now call the invall and check the LPI hits */
+	stats_reset();
+	/* The barrier is from its_send_int() */
+	wmb();
+	cpumask_clear(&mask);
+	cpumask_set_cpu(3, &mask);
 	its_send_invall(col3);
-	lpi_stats_expect(3, 8195);
-	check_lpi_stats("dev2/eventid=20 pending LPI is received");
+	wait_for_interrupts(&mask);
+	report(check_acked(&mask, 0, 8195),
+			"dev2/eventid=20 pending LPI is received");
 
-	lpi_stats_expect(3, 8195);
+	stats_reset();
+	cpumask_clear(&mask);
+	cpumask_set_cpu(3, &mask);
 	its_send_int(dev2, 20);
-	check_lpi_stats("dev2/eventid=20 now triggers an LPI");
+	wait_for_interrupts(&mask);
+	report(check_acked(&mask, 0, 8195),
+			"dev2/eventid=20 now triggers an LPI");
 
 	report_prefix_pop();
 
@@ -821,9 +775,13 @@ static void test_its_trigger(void)
 	 */
 
 	its_send_mapd(dev2, false);
-	lpi_stats_expect(-1, -1);
+	stats_reset();
+	cpumask_clear(&mask);
 	its_send_int(dev2, 20);
-	check_lpi_stats("no LPI after device unmap");
+	wait_for_interrupts(&mask);
+	report(check_acked(&mask, -1, -1), "no LPI after device unmap");
+
+	check_spurious();
 	report_prefix_pop();
 }
 
@@ -831,6 +789,7 @@ static void test_its_migration(void)
 {
 	struct its_device *dev2, *dev7;
 	bool test_skipped = false;
+	cpumask_t mask;
 
 	if (its_setup1()) {
 		test_skipped = true;
@@ -847,13 +806,23 @@ do_migrate:
 	if (test_skipped)
 		return;
 
-	lpi_stats_expect(3, 8195);
+	stats_reset();
+	cpumask_clear(&mask);
+	cpumask_set_cpu(3, &mask);
 	its_send_int(dev2, 20);
-	check_lpi_stats("dev2/eventid=20 triggers LPI 8195 on PE #3 after migration");
+	wait_for_interrupts(&mask);
+	report(check_acked(&mask, 0, 8195),
+			"dev2/eventid=20 triggers LPI 8195 on PE #3 after migration");
 
-	lpi_stats_expect(2, 8196);
+	stats_reset();
+	cpumask_clear(&mask);
+	cpumask_set_cpu(2, &mask);
 	its_send_int(dev7, 255);
-	check_lpi_stats("dev7/eventid=255 triggers LPI 8196 on PE #2 after migration");
+	wait_for_interrupts(&mask);
+	report(check_acked(&mask, 0, 8196),
+			"dev7/eventid=255 triggers LPI 8196 on PE #2 after migration");
+
+	check_spurious();
 }
 
 #define ERRATA_UNMAPPED_COLLECTIONS "ERRATA_8c58be34494b"
@@ -863,6 +832,7 @@ static void test_migrate_unmapped_collection(void)
 	struct its_collection *col = NULL;
 	struct its_device *dev2 = NULL, *dev7 = NULL;
 	bool test_skipped = false;
+	cpumask_t mask;
 	int pe0 = 0;
 	u8 config;
 
@@ -897,17 +867,27 @@ do_migrate:
 	its_send_mapc(col, true);
 	its_send_invall(col);
 
-	lpi_stats_expect(2, 8196);
+	stats_reset();
+	cpumask_clear(&mask);
+	cpumask_set_cpu(2, &mask);
 	its_send_int(dev7, 255);
-	check_lpi_stats("dev7/eventid= 255 triggered LPI 8196 on PE #2");
+	wait_for_interrupts(&mask);
+	report(check_acked(&mask, 0, 8196),
+			"dev7/eventid= 255 triggered LPI 8196 on PE #2");
 
 	config = gicv3_lpi_get_config(8192);
 	report(config == LPI_PROP_DEFAULT,
 	       "Config of LPI 8192 was properly migrated");
 
-	lpi_stats_expect(pe0, 8192);
+	stats_reset();
+	cpumask_clear(&mask);
+	cpumask_set_cpu(pe0, &mask);
 	its_send_int(dev2, 0);
-	check_lpi_stats("dev2/eventid = 0 triggered LPI 8192 on PE0");
+	wait_for_interrupts(&mask);
+	report(check_acked(&mask, 0, 8192),
+			"dev2/eventid = 0 triggered LPI 8192 on PE0");
+
+	check_spurious();
 }
 
 static void test_its_pending_migration(void)
@@ -964,6 +944,10 @@ static void test_its_pending_migration(void)
 	pendbaser = readq(ptr);
 	writeq(pendbaser & ~GICR_PENDBASER_PTZ, ptr);
 
+	/*
+	 * Reset and initialization values for acked are the same, so we don't
+	 * need to explicitely call stats_reset().
+	 */
 	gicv3_lpi_rdist_enable(pe0);
 	gicv3_lpi_rdist_enable(pe1);
 
-- 
2.29.2

