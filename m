Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3215614F0B0
	for <lists+kvm@lfdr.de>; Fri, 31 Jan 2020 17:38:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726909AbgAaQiT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 31 Jan 2020 11:38:19 -0500
Received: from foss.arm.com ([217.140.110.172]:37378 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726813AbgAaQiS (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 31 Jan 2020 11:38:18 -0500
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 08E23FEC;
        Fri, 31 Jan 2020 08:38:18 -0800 (PST)
Received: from e123195-lin.cambridge.arm.com (e123195-lin.cambridge.arm.com [10.1.196.63])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id 08ED03F68E;
        Fri, 31 Jan 2020 08:38:16 -0800 (PST)
From:   Alexandru Elisei <alexandru.elisei@arm.com>
To:     kvm@vger.kernel.org
Cc:     pbonzini@redhat.com, drjones@redhat.com, maz@kernel.org,
        andre.przywara@arm.com, vladimir.murzin@arm.com,
        mark.rutland@arm.com
Subject: [kvm-unit-tests PATCH v4 08/10] arm64: timer: Check the timer interrupt state
Date:   Fri, 31 Jan 2020 16:37:26 +0000
Message-Id: <20200131163728.5228-9-alexandru.elisei@arm.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200131163728.5228-1-alexandru.elisei@arm.com>
References: <20200131163728.5228-1-alexandru.elisei@arm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

We check that the interrupt is pending (or not) at the GIC level, but we
don't check if the timer is asserting it (or not). Let's make sure we don't
run into a strange situation where the two devices' states aren't
synchronized.

Coincidently, the "interrupt signal no longer pending" test fails for
non-emulated timers (i.e, the virtual timer on a non-vhe host) if the
host kernel doesn't have patch 16e604a437c89 ("KVM: arm/arm64: vgic:
Reevaluate level sensitive interrupts on enable").

Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>
---
 arm/timer.c | 15 +++++++++++----
 1 file changed, 11 insertions(+), 4 deletions(-)

diff --git a/arm/timer.c b/arm/timer.c
index ba7e8c6a90ed..35038f2bae57 100644
--- a/arm/timer.c
+++ b/arm/timer.c
@@ -183,6 +183,13 @@ static void irq_handler(struct pt_regs *regs)
 	info->irq_received = true;
 }
 
+/* Check that the timer condition is met. */
+static bool timer_pending(struct timer_info *info)
+{
+	return (info->read_ctl() & ARCH_TIMER_CTL_ENABLE) &&
+		(info->read_ctl() & ARCH_TIMER_CTL_ISTATUS);
+}
+
 static enum gic_state gic_timer_state(struct timer_info *info)
 {
 	enum gic_state state = GIC_STATE_INACTIVE;
@@ -220,7 +227,7 @@ static bool test_cval_10msec(struct timer_info *info)
 	info->write_ctl(ARCH_TIMER_CTL_ENABLE);
 
 	/* Wait for the timer to fire */
-	while (!(info->read_ctl() & ARCH_TIMER_CTL_ISTATUS))
+	while (!timer_pending(info))
 		;
 
 	/* It fired, check how long it took */
@@ -253,17 +260,17 @@ static void test_timer(struct timer_info *info)
 	/* Enable the timer, but schedule it for much later */
 	info->write_cval(later);
 	info->write_ctl(ARCH_TIMER_CTL_ENABLE);
-	report(gic_timer_state(info) == GIC_STATE_INACTIVE,
+	report(!timer_pending(info) && gic_timer_state(info) == GIC_STATE_INACTIVE,
 			"not pending before");
 
 	info->write_cval(now - 1);
-	report(gic_timer_state(info) == GIC_STATE_PENDING,
+	report(timer_pending(info) && gic_timer_state(info) == GIC_STATE_PENDING,
 			"interrupt signal pending");
 
 	/* Disable the timer again and prepare to take interrupts */
 	info->write_ctl(0);
 	set_timer_irq_enabled(info, true);
-	report(gic_timer_state(info) == GIC_STATE_INACTIVE,
+	report(!timer_pending(info) && gic_timer_state(info) == GIC_STATE_INACTIVE,
 			"interrupt signal no longer pending");
 
 	report(test_cval_10msec(info), "latency within 10 ms");
-- 
2.20.1

