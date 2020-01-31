Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CD0A714F0AF
	for <lists+kvm@lfdr.de>; Fri, 31 Jan 2020 17:38:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726814AbgAaQiS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 31 Jan 2020 11:38:18 -0500
Received: from foss.arm.com ([217.140.110.172]:37364 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726794AbgAaQiR (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 31 Jan 2020 11:38:17 -0500
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id C5C3F12FC;
        Fri, 31 Jan 2020 08:38:16 -0800 (PST)
Received: from e123195-lin.cambridge.arm.com (e123195-lin.cambridge.arm.com [10.1.196.63])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id C400C3F68E;
        Fri, 31 Jan 2020 08:38:15 -0800 (PST)
From:   Alexandru Elisei <alexandru.elisei@arm.com>
To:     kvm@vger.kernel.org
Cc:     pbonzini@redhat.com, drjones@redhat.com, maz@kernel.org,
        andre.przywara@arm.com, vladimir.murzin@arm.com,
        mark.rutland@arm.com
Subject: [kvm-unit-tests PATCH v4 07/10] arm64: timer: Wait for the GIC to sample timer interrupt state
Date:   Fri, 31 Jan 2020 16:37:25 +0000
Message-Id: <20200131163728.5228-8-alexandru.elisei@arm.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200131163728.5228-1-alexandru.elisei@arm.com>
References: <20200131163728.5228-1-alexandru.elisei@arm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

There is a delay between the timer asserting the interrupt and the GIC
sampling the interrupt state. Let's take that into account when we are
checking if the timer interrupt is pending (or not) at the GIC level.

An interrupt can be pending or active and pending [1,2]. Let's be precise
and check that the interrupt is actually pending, not active and pending.

[1] ARM IHI 0048B.b, section 1.4.1
[2] ARM IHI 0069E, section 1.2.2

Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>
---
 arm/timer.c       | 43 ++++++++++++++++++++++++++++++++++++++-----
 arm/unittests.cfg |  2 +-
 2 files changed, 39 insertions(+), 6 deletions(-)

diff --git a/arm/timer.c b/arm/timer.c
index b6f9dd10162d..ba7e8c6a90ed 100644
--- a/arm/timer.c
+++ b/arm/timer.c
@@ -8,6 +8,7 @@
 #include <libcflat.h>
 #include <devicetree.h>
 #include <errata.h>
+#include <asm/delay.h>
 #include <asm/processor.h>
 #include <asm/gic.h>
 #include <asm/io.h>
@@ -16,6 +17,14 @@
 #define ARCH_TIMER_CTL_IMASK   (1 << 1)
 #define ARCH_TIMER_CTL_ISTATUS (1 << 2)
 
+enum gic_state {
+	GIC_STATE_INACTIVE,
+	GIC_STATE_PENDING,
+	GIC_STATE_ACTIVE,
+	GIC_STATE_ACTIVE_PENDING,
+};
+
+static void *gic_isactiver;
 static void *gic_ispendr;
 static void *gic_isenabler;
 static void *gic_icenabler;
@@ -174,9 +183,28 @@ static void irq_handler(struct pt_regs *regs)
 	info->irq_received = true;
 }
 
-static bool gic_timer_pending(struct timer_info *info)
+static enum gic_state gic_timer_state(struct timer_info *info)
 {
-	return readl(gic_ispendr) & (1 << PPI(info->irq));
+	enum gic_state state = GIC_STATE_INACTIVE;
+	int i;
+	bool pending, active;
+
+	/* Wait for up to 1s for the GIC to sample the interrupt. */
+	for (i = 0; i < 10; i++) {
+		pending = readl(gic_ispendr) & (1 << PPI(info->irq));
+		active = readl(gic_isactiver) & (1 << PPI(info->irq));
+		if (!active && !pending)
+			state = GIC_STATE_INACTIVE;
+		if (pending)
+			state = GIC_STATE_PENDING;
+		if (active)
+			state = GIC_STATE_ACTIVE;
+		if (active && pending)
+			state = GIC_STATE_ACTIVE_PENDING;
+		mdelay(100);
+	}
+
+	return state;
 }
 
 static bool test_cval_10msec(struct timer_info *info)
@@ -225,15 +253,18 @@ static void test_timer(struct timer_info *info)
 	/* Enable the timer, but schedule it for much later */
 	info->write_cval(later);
 	info->write_ctl(ARCH_TIMER_CTL_ENABLE);
-	report(!gic_timer_pending(info), "not pending before");
+	report(gic_timer_state(info) == GIC_STATE_INACTIVE,
+			"not pending before");
 
 	info->write_cval(now - 1);
-	report(gic_timer_pending(info), "interrupt signal pending");
+	report(gic_timer_state(info) == GIC_STATE_PENDING,
+			"interrupt signal pending");
 
 	/* Disable the timer again and prepare to take interrupts */
 	info->write_ctl(0);
 	set_timer_irq_enabled(info, true);
-	report(!gic_timer_pending(info), "interrupt signal no longer pending");
+	report(gic_timer_state(info) == GIC_STATE_INACTIVE,
+			"interrupt signal no longer pending");
 
 	report(test_cval_10msec(info), "latency within 10 ms");
 	report(info->irq_received, "interrupt received");
@@ -307,11 +338,13 @@ static void test_init(void)
 
 	switch (gic_version()) {
 	case 2:
+		gic_isactiver = gicv2_dist_base() + GICD_ISACTIVER;
 		gic_ispendr = gicv2_dist_base() + GICD_ISPENDR;
 		gic_isenabler = gicv2_dist_base() + GICD_ISENABLER;
 		gic_icenabler = gicv2_dist_base() + GICD_ICENABLER;
 		break;
 	case 3:
+		gic_isactiver = gicv3_sgi_base() + GICD_ISACTIVER;
 		gic_ispendr = gicv3_sgi_base() + GICD_ISPENDR;
 		gic_isenabler = gicv3_sgi_base() + GICR_ISENABLER0;
 		gic_icenabler = gicv3_sgi_base() + GICR_ICENABLER0;
diff --git a/arm/unittests.cfg b/arm/unittests.cfg
index daeb5a09ad39..1f1bb24d9d13 100644
--- a/arm/unittests.cfg
+++ b/arm/unittests.cfg
@@ -132,7 +132,7 @@ groups = psci
 [timer]
 file = timer.flat
 groups = timer
-timeout = 2s
+timeout = 8s
 arch = arm64
 
 # Exit tests
-- 
2.20.1

