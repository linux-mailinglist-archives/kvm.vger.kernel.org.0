Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A51B814F0B1
	for <lists+kvm@lfdr.de>; Fri, 31 Jan 2020 17:38:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726794AbgAaQiU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 31 Jan 2020 11:38:20 -0500
Received: from foss.arm.com ([217.140.110.172]:37380 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726900AbgAaQiT (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 31 Jan 2020 11:38:19 -0500
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 3E2F111FB;
        Fri, 31 Jan 2020 08:38:19 -0800 (PST)
Received: from e123195-lin.cambridge.arm.com (e123195-lin.cambridge.arm.com [10.1.196.63])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id 3D4063F68E;
        Fri, 31 Jan 2020 08:38:18 -0800 (PST)
From:   Alexandru Elisei <alexandru.elisei@arm.com>
To:     kvm@vger.kernel.org
Cc:     pbonzini@redhat.com, drjones@redhat.com, maz@kernel.org,
        andre.przywara@arm.com, vladimir.murzin@arm.com,
        mark.rutland@arm.com
Subject: [kvm-unit-tests PATCH v4 09/10] arm64: timer: Test behavior when timer disabled or masked
Date:   Fri, 31 Jan 2020 16:37:27 +0000
Message-Id: <20200131163728.5228-10-alexandru.elisei@arm.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200131163728.5228-1-alexandru.elisei@arm.com>
References: <20200131163728.5228-1-alexandru.elisei@arm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

When the timer is disabled (the *_CTL_EL0.ENABLE bit is clear) or the
timer interrupt is masked at the timer level (the *_CTL_EL0.IMASK bit is
set), timer interrupts must not be pending or asserted by the VGIC.
However, only when the timer interrupt is masked, we can still check
that the timer condition is met by reading the *_CTL_EL0.ISTATUS bit.

This test was used to discover a bug and test the fix introduced by KVM
commit 16e604a437c8 ("KVM: arm/arm64: vgic: Reevaluate level sensitive
interrupts on enable").

Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>
---
 arm/timer.c       | 7 +++++++
 arm/unittests.cfg | 2 +-
 2 files changed, 8 insertions(+), 1 deletion(-)

diff --git a/arm/timer.c b/arm/timer.c
index 35038f2bae57..dea364f5355d 100644
--- a/arm/timer.c
+++ b/arm/timer.c
@@ -269,10 +269,17 @@ static void test_timer(struct timer_info *info)
 
 	/* Disable the timer again and prepare to take interrupts */
 	info->write_ctl(0);
+	info->irq_received = false;
 	set_timer_irq_enabled(info, true);
+	report(!info->irq_received, "no interrupt when timer is disabled");
 	report(!timer_pending(info) && gic_timer_state(info) == GIC_STATE_INACTIVE,
 			"interrupt signal no longer pending");
 
+	info->write_cval(now - 1);
+	info->write_ctl(ARCH_TIMER_CTL_ENABLE | ARCH_TIMER_CTL_IMASK);
+	report(timer_pending(info) && gic_timer_state(info) == GIC_STATE_INACTIVE,
+			"interrupt signal not pending");
+
 	report(test_cval_10msec(info), "latency within 10 ms");
 	report(info->irq_received, "interrupt received");
 
diff --git a/arm/unittests.cfg b/arm/unittests.cfg
index 1f1bb24d9d13..017958d28ffd 100644
--- a/arm/unittests.cfg
+++ b/arm/unittests.cfg
@@ -132,7 +132,7 @@ groups = psci
 [timer]
 file = timer.flat
 groups = timer
-timeout = 8s
+timeout = 10s
 arch = arm64
 
 # Exit tests
-- 
2.20.1

