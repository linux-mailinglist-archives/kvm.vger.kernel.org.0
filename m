Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A64BD308A6F
	for <lists+kvm@lfdr.de>; Fri, 29 Jan 2021 17:45:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231408AbhA2Qi1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 29 Jan 2021 11:38:27 -0500
Received: from foss.arm.com ([217.140.110.172]:51082 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231124AbhA2Qh7 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 29 Jan 2021 11:37:59 -0500
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id AFE12152B;
        Fri, 29 Jan 2021 08:37:13 -0800 (PST)
Received: from monolith.localdoman (unknown [172.31.20.19])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id F07F03F71B;
        Fri, 29 Jan 2021 08:37:12 -0800 (PST)
From:   Alexandru Elisei <alexandru.elisei@arm.com>
To:     drjones@redhat.com, kvm@vger.kernel.org,
        kvmarm@lists.cs.columbia.edu
Cc:     andre.przywara@arm.com
Subject: [kvm-unit-tests PATCH v3 04/11] arm/arm64: gic: Remove unnecessary synchronization with stats_reset()
Date:   Fri, 29 Jan 2021 16:36:40 +0000
Message-Id: <20210129163647.91564-5-alexandru.elisei@arm.com>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210129163647.91564-1-alexandru.elisei@arm.com>
References: <20210129163647.91564-1-alexandru.elisei@arm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The GICv3 driver executes a DSB barrier before sending an IPI, which
ensures that memory accesses have completed. This removes the need to
enforce ordering with respect to stats_reset() in the IPI handler.

For GICv2, the same barrier is executed by readl() after the MMIO read.
Together with the wmb() barrier from writel() when triggering the IPI,
this ensures that the expected memory ordering is respected.

Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>
---
 arm/gic.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/arm/gic.c b/arm/gic.c
index 8bb804abf34d..db1417ae1ca1 100644
--- a/arm/gic.c
+++ b/arm/gic.c
@@ -59,7 +59,6 @@ static void stats_reset(void)
 		bad_sender[i] = -1;
 		bad_irq[i] = -1;
 	}
-	smp_wmb();
 }
 
 static void check_acked(const char *testname, cpumask_t *mask)
@@ -149,7 +148,6 @@ static void ipi_handler(struct pt_regs *regs __unused)
 
 	if (irqnr != GICC_INT_SPURIOUS) {
 		gic_write_eoir(irqstat);
-		smp_rmb(); /* pairs with wmb in stats_reset */
 		++acked[smp_processor_id()];
 		check_ipi_sender(irqstat);
 		check_irqnr(irqnr);
-- 
2.30.0

