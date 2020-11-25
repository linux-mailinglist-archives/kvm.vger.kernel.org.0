Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 42FB62C4470
	for <lists+kvm@lfdr.de>; Wed, 25 Nov 2020 16:50:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731668AbgKYPuJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 25 Nov 2020 10:50:09 -0500
Received: from foss.arm.com ([217.140.110.172]:55824 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731645AbgKYPuI (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 25 Nov 2020 10:50:08 -0500
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id EDF12152F;
        Wed, 25 Nov 2020 07:50:07 -0800 (PST)
Received: from monolith.localdoman (unknown [172.31.20.19])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 299A43F7BB;
        Wed, 25 Nov 2020 07:50:07 -0800 (PST)
From:   Alexandru Elisei <alexandru.elisei@arm.com>
To:     kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu,
        drjones@redhat.com
Cc:     eric.auger@redhat.com, andre.przywara@arm.com
Subject: [kvm-unit-tests PATCH 05/10] arm/arm64: gic: Use correct memory ordering for the IPI test
Date:   Wed, 25 Nov 2020 15:51:08 +0000
Message-Id: <20201125155113.192079-6-alexandru.elisei@arm.com>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201125155113.192079-1-alexandru.elisei@arm.com>
References: <20201125155113.192079-1-alexandru.elisei@arm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The IPI test works by sending IPIs to even numbered CPUs from the
IPI_SENDER CPU (CPU1), and then checking that the other CPUs received the
interrupts as expected. The check is done in check_acked() by the
IPI_SENDER CPU with the help of three arrays:

- acked, where acked[i] == 1 means that CPU i received the interrupt.
- bad_irq, where bad_irq[i] == -1 means that the interrupt received by CPU
  i had the expected interrupt number (IPI_IRQ).
- bad_sender, where bad_sender[i] == -1 means that the interrupt received
  by CPU i was from the expected sender (IPI_SENDER, GICv2 only).

The assumption made by check_acked() is that if a CPU acked an interrupt,
then bad_sender and bad_irq have also been updated. This is a common
inter-thread communication pattern called message passing.  For message
passing to work correctly on weakly consistent memory model architectures,
like arm and arm64, barriers or address dependencies are required. This is
described in ARM DDI 0487F.b, in "Armv7 compatible approaches for ordering,
using DMB and DSB barriers" (page K11-7993), in the section with a single
observer, which is in our case the IPI_SENDER CPU.

The IPI test attempts to enforce the correct ordering using memory
barriers, but it's not enough. For example, the program execution below is
valid from an architectural point of view:

3 online CPUs, initial state (from stats_reset()):

acked[2] = 0;
bad_sender[2] = -1;
bad_irq[2] = -1;

CPU1 (in check_acked())		| CPU2 (in ipi_handler())
				|
smp_rmb() // DMB ISHLD		| acked[2]++;
read 1 from acked[2]		|
nr_pass++ // nr_pass = 3	|
read -1 from bad_sender[2]	|
read -1 from bad_irq[2]		|
				| // in check_ipi_sender()
				| bad_sender[2] = <bad ipi sender>
				| // in check_irqnr()
				| bad_irq[2] = <bad irq number>
				| smp_wmb() // DMB ISHST
nr_pass == nr_cpus, return	|

In this scenario, CPU1 will read the updated acked value, but it will read
the initial bad_sender and bad_irq values. This is permitted because the
memory barriers do not create a data dependency between the value read from
acked and the values read from bad_rq and bad_sender on CPU1, respectively
between the values written to acked, bad_sender and bad_irq on CPU2.

To avoid this situation, let's reorder the barriers and accesses to the
arrays to create the needed dependencies that ensure that message passing
behaves as expected.

In the interrupt handler, the writes to bad_sender and bad_irq are
reordered before the write to acked and a smp_wmb() barrier is added. This
ensures that if other PEs observe the write to acked, then they will also
observe the writes to the other two arrays.

In check_acked(), put the smp_rmb() barrier after the read from acked to
ensure that the subsequent reads from bad_sender, respectively bad_irq,
aren't reordered locally by the PE.

With these changes, the expected ordering of accesses is respected and we
end up with the pattern described in the Arm ARM and also in the Linux
litmus test MP+fencewmbonceonce+fencermbonceonce.litmus from
tools/memory-model/litmus-tests. More examples and explanations can be
found in the Linux source tree, in Documentation/memory-barriers.txt, in
the sections "SMP BARRIER PAIRING" and "READ MEMORY BARRIERS VS LOAD
SPECULATION".

For consistency with ipi_handler(), the array accesses in
ipi_clear_active_handler() have also been reordered. This shouldn't affect
the functionality of that test.

Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>
---
 arm/gic.c | 9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

diff --git a/arm/gic.c b/arm/gic.c
index 7befda2a8673..bcb834406d23 100644
--- a/arm/gic.c
+++ b/arm/gic.c
@@ -73,9 +73,9 @@ static void check_acked(const char *testname, cpumask_t *mask)
 		mdelay(100);
 		nr_pass = 0;
 		for_each_present_cpu(cpu) {
-			smp_rmb();
 			nr_pass += cpumask_test_cpu(cpu, mask) ?
 				acked[cpu] == 1 : acked[cpu] == 0;
+			smp_rmb(); /* pairs with smp_wmb in ipi_handler */
 
 			if (bad_sender[cpu] != -1) {
 				printf("cpu%d received IPI from wrong sender %d\n",
@@ -118,7 +118,6 @@ static void check_spurious(void)
 {
 	int cpu;
 
-	smp_rmb();
 	for_each_present_cpu(cpu) {
 		if (spurious[cpu])
 			report_info("WARN: cpu%d got %d spurious interrupts",
@@ -156,10 +155,10 @@ static void ipi_handler(struct pt_regs *regs __unused)
 		 */
 		if (gic_version() == 2)
 			smp_rmb();
-		++acked[smp_processor_id()];
 		check_ipi_sender(irqstat);
 		check_irqnr(irqnr);
-		smp_wmb(); /* pairs with rmb in check_acked */
+		smp_wmb(); /* pairs with smp_rmb in check_acked */
+		++acked[smp_processor_id()];
 	} else {
 		++spurious[smp_processor_id()];
 		smp_wmb();
@@ -383,8 +382,8 @@ static void ipi_clear_active_handler(struct pt_regs *regs __unused)
 
 		writel(val, base + GICD_ICACTIVER);
 
-		++acked[smp_processor_id()];
 		check_irqnr(irqnr);
+		++acked[smp_processor_id()];
 	} else {
 		++spurious[smp_processor_id()];
 	}
-- 
2.29.2

