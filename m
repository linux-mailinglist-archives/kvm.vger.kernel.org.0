Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CADE32C446E
	for <lists+kvm@lfdr.de>; Wed, 25 Nov 2020 16:50:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731662AbgKYPuI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 25 Nov 2020 10:50:08 -0500
Received: from foss.arm.com ([217.140.110.172]:55816 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731643AbgKYPuH (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 25 Nov 2020 10:50:07 -0500
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id E96B5106F;
        Wed, 25 Nov 2020 07:50:06 -0800 (PST)
Received: from monolith.localdoman (unknown [172.31.20.19])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 24B483F7BB;
        Wed, 25 Nov 2020 07:50:06 -0800 (PST)
From:   Alexandru Elisei <alexandru.elisei@arm.com>
To:     kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu,
        drjones@redhat.com
Cc:     eric.auger@redhat.com, andre.przywara@arm.com
Subject: [kvm-unit-tests PATCH 04/10] arm/arm64: gic: Remove unnecessary synchronization with stats_reset()
Date:   Wed, 25 Nov 2020 15:51:07 +0000
Message-Id: <20201125155113.192079-5-alexandru.elisei@arm.com>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201125155113.192079-1-alexandru.elisei@arm.com>
References: <20201125155113.192079-1-alexandru.elisei@arm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The GICv3 driver executes a DSB barrier before sending an IPI, which
ensures that memory accesses have completed. This removes the need to
enforce ordering with respect to stats_reset() in the IPI handler.

For GICv2, we still need the DMB to ensure ordering between the read of the
GICC_IAR MMIO register and the read from the acked array. It also matches
what the Linux GICv2 driver does in gic_handle_irq().

Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>
---
 arm/gic.c | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/arm/gic.c b/arm/gic.c
index 4e947e8516a2..7befda2a8673 100644
--- a/arm/gic.c
+++ b/arm/gic.c
@@ -60,7 +60,6 @@ static void stats_reset(void)
 		bad_sender[i] = -1;
 		bad_irq[i] = -1;
 	}
-	smp_wmb();
 }
 
 static void check_acked(const char *testname, cpumask_t *mask)
@@ -150,7 +149,13 @@ static void ipi_handler(struct pt_regs *regs __unused)
 
 	if (irqnr != GICC_INT_SPURIOUS) {
 		gic_write_eoir(irqstat);
-		smp_rmb(); /* pairs with wmb in stats_reset */
+		/*
+		 * Make sure data written before the IPI was triggered is
+		 * observed after the IAR is read. Pairs with the smp_wmb
+		 * when sending the IPI.
+		 */
+		if (gic_version() == 2)
+			smp_rmb();
 		++acked[smp_processor_id()];
 		check_ipi_sender(irqstat);
 		check_irqnr(irqnr);
-- 
2.29.2

