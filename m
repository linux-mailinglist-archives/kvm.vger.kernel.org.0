Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0EFCC308A6E
	for <lists+kvm@lfdr.de>; Fri, 29 Jan 2021 17:45:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231396AbhA2QiS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 29 Jan 2021 11:38:18 -0500
Received: from foss.arm.com ([217.140.110.172]:51076 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230525AbhA2Qh6 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 29 Jan 2021 11:37:58 -0500
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id BA7351515;
        Fri, 29 Jan 2021 08:37:12 -0800 (PST)
Received: from monolith.localdoman (unknown [172.31.20.19])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 81BA63F71B;
        Fri, 29 Jan 2021 08:37:11 -0800 (PST)
From:   Alexandru Elisei <alexandru.elisei@arm.com>
To:     drjones@redhat.com, kvm@vger.kernel.org,
        kvmarm@lists.cs.columbia.edu
Cc:     andre.przywara@arm.com, Eric Auger <eric.auger@redhat.com>
Subject: [kvm-unit-tests PATCH v3 03/11] arm/arm64: gic: Remove SMP synchronization from ipi_clear_active_handler()
Date:   Fri, 29 Jan 2021 16:36:39 +0000
Message-Id: <20210129163647.91564-4-alexandru.elisei@arm.com>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210129163647.91564-1-alexandru.elisei@arm.com>
References: <20210129163647.91564-1-alexandru.elisei@arm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The gicv{2,3}-active test sends an IPI from the boot CPU to itself, then
checks that the interrupt has been received as expected. There is no need
to use inter-processor memory synchronization primitives on code that runs
on the same CPU, so remove the unneeded memory barriers.

Reviewed-by: Eric Auger <eric.auger@redhat.com>
Reviewed-by: Andre Przywara <andre.przywara@arm.com>
Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>
---
 arm/gic.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/arm/gic.c b/arm/gic.c
index e2e053aeb823..8bb804abf34d 100644
--- a/arm/gic.c
+++ b/arm/gic.c
@@ -367,6 +367,7 @@ static struct gic gicv3 = {
 	},
 };
 
+/* Runs on the same CPU as the sender, no need for memory synchronization */
 static void ipi_clear_active_handler(struct pt_regs *regs __unused)
 {
 	u32 irqstat = gic_read_iar();
@@ -383,13 +384,10 @@ static void ipi_clear_active_handler(struct pt_regs *regs __unused)
 
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
2.30.0

