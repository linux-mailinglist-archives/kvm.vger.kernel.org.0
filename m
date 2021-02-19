Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EEA6231F93A
	for <lists+kvm@lfdr.de>; Fri, 19 Feb 2021 13:15:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230407AbhBSMPL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 19 Feb 2021 07:15:11 -0500
Received: from foss.arm.com ([217.140.110.172]:35110 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230195AbhBSMPH (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 19 Feb 2021 07:15:07 -0500
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 1D19813D5;
        Fri, 19 Feb 2021 04:13:40 -0800 (PST)
Received: from monolith.localdoman (unknown [172.31.20.19])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 3F9C93F73B;
        Fri, 19 Feb 2021 04:13:39 -0800 (PST)
From:   Alexandru Elisei <alexandru.elisei@arm.com>
To:     drjones@redhat.com, kvm@vger.kernel.org,
        kvmarm@lists.cs.columbia.edu
Cc:     andre.przywara@arm.com, eric.auger@redhat.com
Subject: [kvm-unit-tests PATCH v4 06/11] arm/arm64: gic: Check spurious and bad_sender in the active test
Date:   Fri, 19 Feb 2021 12:13:32 +0000
Message-Id: <20210219121337.76533-7-alexandru.elisei@arm.com>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210219121337.76533-1-alexandru.elisei@arm.com>
References: <20210219121337.76533-1-alexandru.elisei@arm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The gicv{2,3}-active test sends an IPI from the boot CPU to itself, then
checks that the interrupt has been received as expected. The
ipi_clear_active_handler() clears the active state of the interrupt with a
write to the GICD_ICACTIVER register instead of writing the to EOI
register.

When acknowledging the interrupt it is possible to get back an spurious
interrupt ID (ID 1023), and the interrupt handler increments the number of
spurious interrupts received on the current processor. However, this is not
checked at the end of the test. Let's also check for spurious interrupts,
like the IPI test does.

For IPIs on GICv2, the value returned by a read of the GICC_IAR register
performed when acknowledging the interrupt also contains the sender CPU
ID. Add a check for that too.

Reviewed-by: Eric Auger <eric.auger@redhat.com>
Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>
---
 arm/gic.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/arm/gic.c b/arm/gic.c
index c1b6c94a5f5e..982c96681cf9 100644
--- a/arm/gic.c
+++ b/arm/gic.c
@@ -125,12 +125,12 @@ static void check_spurious(void)
 	}
 }
 
-static void check_ipi_sender(u32 irqstat)
+static void check_ipi_sender(u32 irqstat, int sender)
 {
 	if (gic_version() == 2) {
 		int src = (irqstat >> 10) & 7;
 
-		if (src != IPI_SENDER)
+		if (src != sender)
 			bad_sender[smp_processor_id()] = src;
 	}
 }
@@ -148,7 +148,7 @@ static void ipi_handler(struct pt_regs *regs __unused)
 
 	if (irqnr != GICC_INT_SPURIOUS) {
 		gic_write_eoir(irqstat);
-		check_ipi_sender(irqstat);
+		check_ipi_sender(irqstat, IPI_SENDER);
 		check_irqnr(irqnr);
 		smp_wmb(); /* pairs with smp_rmb in check_acked */
 		++acked[smp_processor_id()];
@@ -382,6 +382,7 @@ static void ipi_clear_active_handler(struct pt_regs *regs __unused)
 
 		writel(val, base + GICD_ICACTIVER);
 
+		check_ipi_sender(irqstat, smp_processor_id());
 		check_irqnr(irqnr);
 		++acked[smp_processor_id()];
 	} else {
@@ -394,6 +395,7 @@ static void run_active_clear_test(void)
 	report_prefix_push("active");
 	setup_irq(ipi_clear_active_handler);
 	ipi_test_self();
+	check_spurious();
 	report_prefix_pop();
 }
 
-- 
2.30.1

