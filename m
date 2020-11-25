Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A9E2D2C4473
	for <lists+kvm@lfdr.de>; Wed, 25 Nov 2020 16:50:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731653AbgKYPuI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 25 Nov 2020 10:50:08 -0500
Received: from foss.arm.com ([217.140.110.172]:55806 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730318AbgKYPuG (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 25 Nov 2020 10:50:06 -0500
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id E482A11D4;
        Wed, 25 Nov 2020 07:50:05 -0800 (PST)
Received: from monolith.localdoman (unknown [172.31.20.19])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 1F7E63F7BB;
        Wed, 25 Nov 2020 07:50:05 -0800 (PST)
From:   Alexandru Elisei <alexandru.elisei@arm.com>
To:     kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu,
        drjones@redhat.com
Cc:     eric.auger@redhat.com, andre.przywara@arm.com
Subject: [kvm-unit-tests PATCH 03/10] arm/arm64: gic: Remove memory synchronization from ipi_clear_active_handler()
Date:   Wed, 25 Nov 2020 15:51:06 +0000
Message-Id: <20201125155113.192079-4-alexandru.elisei@arm.com>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201125155113.192079-1-alexandru.elisei@arm.com>
References: <20201125155113.192079-1-alexandru.elisei@arm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The gicv{2,3}-active test sends an IPI from the boot CPU to itself, then
checks that the interrupt has been received as expected. There is no need
to use inter-processor memory synchronization primitives on code that runs
on the same CPU, so remove the unneeded memory barriers.

The arrays are modified asynchronously (in the interrupt handler) and it is
possible for the compiler to infer that they won't be changed during normal
program flow and try to perform harmful optimizations (like stashing a
previous read in a register and reusing it). To prevent this, for GICv2,
the smp_wmb() in gicv2_ipi_send_self() is replaced with a compiler barrier.
For GICv3, the wmb() barrier in gic_ipi_send_single() already implies a
compiler barrier.

Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>
---
 arm/gic.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/arm/gic.c b/arm/gic.c
index 401ffafe4299..4e947e8516a2 100644
--- a/arm/gic.c
+++ b/arm/gic.c
@@ -12,6 +12,7 @@
  * This work is licensed under the terms of the GNU LGPL, version 2.
  */
 #include <libcflat.h>
+#include <linux/compiler.h>
 #include <errata.h>
 #include <asm/setup.h>
 #include <asm/processor.h>
@@ -260,7 +261,8 @@ static void check_lpi_hits(int *expected, const char *msg)
 
 static void gicv2_ipi_send_self(void)
 {
-	smp_wmb();
+	/* Prevent the compiler from optimizing memory accesses */
+	barrier();
 	writel(2 << 24 | IPI_IRQ, gicv2_dist_base() + GICD_SGIR);
 }
 
@@ -359,6 +361,7 @@ static struct gic gicv3 = {
 	},
 };
 
+/* Runs on the same CPU as the sender, no need for memory synchronization */
 static void ipi_clear_active_handler(struct pt_regs *regs __unused)
 {
 	u32 irqstat = gic_read_iar();
@@ -375,13 +378,10 @@ static void ipi_clear_active_handler(struct pt_regs *regs __unused)
 
 		writel(val, base + GICD_ICACTIVER);
 
-		smp_rmb(); /* pairs with wmb in stats_reset */
 		++acked[smp_processor_id()];
 		check_irqnr(irqnr);
-		smp_wmb(); /* pairs with rmb in check_acked */
 	} else {
 		++spurious[smp_processor_id()];
-		smp_wmb();
 	}
 }
 
-- 
2.29.2

