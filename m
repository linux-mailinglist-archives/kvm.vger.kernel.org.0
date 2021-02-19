Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AA46D31F935
	for <lists+kvm@lfdr.de>; Fri, 19 Feb 2021 13:14:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229636AbhBSMOb (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 19 Feb 2021 07:14:31 -0500
Received: from foss.arm.com ([217.140.110.172]:35042 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230223AbhBSMOX (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 19 Feb 2021 07:14:23 -0500
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id E9F7513A1;
        Fri, 19 Feb 2021 04:13:37 -0800 (PST)
Received: from monolith.localdoman (unknown [172.31.20.19])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 1843C3F73B;
        Fri, 19 Feb 2021 04:13:36 -0800 (PST)
From:   Alexandru Elisei <alexandru.elisei@arm.com>
To:     drjones@redhat.com, kvm@vger.kernel.org,
        kvmarm@lists.cs.columbia.edu
Cc:     andre.przywara@arm.com, eric.auger@redhat.com
Subject: [kvm-unit-tests PATCH v4 04/11] arm/arm64: gic: Remove unnecessary synchronization with stats_reset()
Date:   Fri, 19 Feb 2021 12:13:30 +0000
Message-Id: <20210219121337.76533-5-alexandru.elisei@arm.com>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210219121337.76533-1-alexandru.elisei@arm.com>
References: <20210219121337.76533-1-alexandru.elisei@arm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The GICv3 driver executes a DSB barrier before sending an IPI, which
ensures that memory accesses have completed. This removes the need to
enforce ordering with respect to stats_reset() in the IPI handler.

For GICv2, the wmb() from writel(), executed when triggering an IPI,
coupled with the rmb() from readl() when handling the IPI will enforce the
desired memory ordering.

Reviewed-by: Eric Auger <eric.auger@redhat.com>
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
2.30.1

