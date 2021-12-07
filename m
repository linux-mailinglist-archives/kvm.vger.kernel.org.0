Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5CCA746BFBB
	for <lists+kvm@lfdr.de>; Tue,  7 Dec 2021 16:46:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239045AbhLGPu1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 7 Dec 2021 10:50:27 -0500
Received: from foss.arm.com ([217.140.110.172]:35222 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238505AbhLGPu0 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 7 Dec 2021 10:50:26 -0500
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 3DA6211D4;
        Tue,  7 Dec 2021 07:46:56 -0800 (PST)
Received: from monolith.localdoman (unknown [172.31.20.19])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 7B5FA3F5A1;
        Tue,  7 Dec 2021 07:46:55 -0800 (PST)
From:   Alexandru Elisei <alexandru.elisei@arm.com>
To:     drjones@redhat.com, kvm@vger.kernel.org,
        kvmarm@lists.cs.columbia.edu
Subject: [kvm-unit-tests PATCH 2/4] arm: timer: Move the different tests into their own functions
Date:   Tue,  7 Dec 2021 15:46:39 +0000
Message-Id: <20211207154641.87740-3-alexandru.elisei@arm.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211207154641.87740-1-alexandru.elisei@arm.com>
References: <20211207154641.87740-1-alexandru.elisei@arm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

At the moment, the timer test is one big function that checks different
aspects of the timer implementation, and it's not immediately obvious if a
check depends on a state from a previous test, making understanding the
code more difficult than necessary.

Move the checks into logically distinct functions and leave the timer in a
known state before proceeding to the next test to make the code easier to
understand, maintain and extend.

The timer interrupt is now enabled at the GIC level in test_init() to break
the dependency that the tests have on the timer pending test running first.

There should be no functional change as a result of this patch.

Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>
---
 arm/timer.c | 46 +++++++++++++++++++++++++++++++++++-----------
 1 file changed, 35 insertions(+), 11 deletions(-)

diff --git a/arm/timer.c b/arm/timer.c
index 2a6687f22874..617845c6525d 100644
--- a/arm/timer.c
+++ b/arm/timer.c
@@ -226,16 +226,23 @@ static bool test_cval_10msec(struct timer_info *info)
 	return difference < time_10ms;
 }
 
-static void test_timer(struct timer_info *info)
+static void disable_timer(struct timer_info *info)
+{
+	info->write_ctl(0);
+	info->irq_received = false;
+}
+
+static void test_timer_pending(struct timer_info *info)
 {
 	u64 now = info->read_counter();
 	u64 time_10s = read_sysreg(cntfrq_el0) * 10;
 	u64 later = now + time_10s;
-	s32 left;
 
-	/* We don't want the irq handler to fire because that will change the
+	/*
+	 * We don't want the irq handler to fire because that will change the
 	 * timer state and we want to test the timer output signal.  We can
-	 * still read the pending state even if it's disabled. */
+	 * still read the pending state even if it's disabled.
+	 */
 	set_timer_irq_enabled(info, false);
 
 	/* Enable the timer, but schedule it for much later */
@@ -248,10 +255,9 @@ static void test_timer(struct timer_info *info)
 	report(timer_pending(info) && gic_timer_check_state(info, GIC_IRQ_STATE_PENDING),
 			"interrupt signal pending");
 
-	/* Disable the timer again and prepare to take interrupts */
-	info->write_ctl(0);
-	info->irq_received = false;
+	disable_timer(info);
 	set_timer_irq_enabled(info, true);
+
 	report(!info->irq_received, "no interrupt when timer is disabled");
 	report(!timer_pending(info) && gic_timer_check_state(info, GIC_IRQ_STATE_INACTIVE),
 			"interrupt signal no longer pending");
@@ -261,14 +267,21 @@ static void test_timer(struct timer_info *info)
 	report(timer_pending(info) && gic_timer_check_state(info, GIC_IRQ_STATE_INACTIVE),
 			"interrupt signal not pending");
 
+	disable_timer(info);
+}
+
+static void test_timer_cval(struct timer_info *info)
+{
 	report(test_cval_10msec(info), "latency within 10 ms");
 	report(info->irq_received, "interrupt received");
 
-	/* Disable the timer again */
-	info->write_ctl(0);
+	disable_timer(info);
+}
+
+static void test_timer_tval(struct timer_info *info)
+{
+	s32 left;
 
-	/* Test TVAL and IRQ trigger */
-	info->irq_received = false;
 	info->write_tval(read_sysreg(cntfrq_el0) / 100);	/* 10 ms */
 	local_irq_disable();
 	info->write_ctl(ARCH_TIMER_CTL_ENABLE);
@@ -279,6 +292,15 @@ static void test_timer(struct timer_info *info)
 	report(info->irq_received, "interrupt received after TVAL/WFI");
 	report(left <= 0, "timer has expired");
 	report_info("TVAL is %d ticks", left);
+
+	disable_timer(info);
+}
+
+static void test_timer(struct timer_info *info)
+{
+	test_timer_pending(info);
+	test_timer_cval(info);
+	test_timer_tval(info);
 }
 
 static void test_vtimer(void)
@@ -329,6 +351,8 @@ static void test_init(void)
 	}
 
 	install_irq_handler(EL1H_IRQ, irq_handler);
+	set_timer_irq_enabled(&ptimer_info, true);
+	set_timer_irq_enabled(&vtimer_info, true);
 	local_irq_enable();
 }
 
-- 
2.34.1

