Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3801110B142
	for <lists+kvm@lfdr.de>; Wed, 27 Nov 2019 15:25:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727333AbfK0OZY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 27 Nov 2019 09:25:24 -0500
Received: from foss.arm.com ([217.140.110.172]:48290 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727275AbfK0OZX (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 27 Nov 2019 09:25:23 -0500
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id D8B5D1045;
        Wed, 27 Nov 2019 06:25:22 -0800 (PST)
Received: from e123195-lin.cambridge.arm.com (e123195-lin.cambridge.arm.com [10.1.196.63])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id BB4163F68E;
        Wed, 27 Nov 2019 06:25:21 -0800 (PST)
From:   Alexandru Elisei <alexandru.elisei@arm.com>
To:     kvm@vger.kernel.org
Cc:     pbonzini@redhat.com, rkrcmar@redhat.com, drjones@redhat.com,
        maz@kernel.org, andre.przywara@arm.com, vladimir.murzin@arm.com,
        mark.rutland@arm.com
Subject: [kvm-unit-tests PATCH 13/18] arm64: timer: Test behavior when timer disabled or masked
Date:   Wed, 27 Nov 2019 14:24:05 +0000
Message-Id: <20191127142410.1994-14-alexandru.elisei@arm.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191127142410.1994-1-alexandru.elisei@arm.com>
References: <20191127142410.1994-1-alexandru.elisei@arm.com>
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

Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>
---

This test was used to discover a bug and test the fix introduced by KVM
commit 16e604a437c8 ("KVM: arm/arm64: vgic: Reevaluate level sensitive
interrupts on enable").

 arm/timer.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/arm/timer.c b/arm/timer.c
index d2cd5dc7a58b..09d527bb09a8 100644
--- a/arm/timer.c
+++ b/arm/timer.c
@@ -230,9 +230,17 @@ static void test_timer(struct timer_info *info)
 
 	/* Disable the timer again and prepare to take interrupts */
 	info->write_ctl(0);
+	isb();
+	info->irq_received = false;
 	set_timer_irq_enabled(info, true);
+	report("no interrupt when timer is disabled", !info->irq_received);
 	report("interrupt signal no longer pending", !gic_timer_pending(info));
 
+	info->write_ctl(ARCH_TIMER_CTL_ENABLE | ARCH_TIMER_CTL_IMASK);
+	isb();
+	report("interrupt signal not pending", !gic_timer_pending(info));
+	report("timer condition met", info->read_ctl() & ARCH_TIMER_CTL_ISTATUS);
+
 	report("latency within 10 ms", test_cval_10msec(info));
 	report("interrupt received", info->irq_received);
 
-- 
2.20.1

