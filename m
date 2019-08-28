Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F2223A036A
	for <lists+kvm@lfdr.de>; Wed, 28 Aug 2019 15:39:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726623AbfH1NjB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 28 Aug 2019 09:39:01 -0400
Received: from foss.arm.com ([217.140.110.172]:59582 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726743AbfH1NjA (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 28 Aug 2019 09:39:00 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 82A1528;
        Wed, 28 Aug 2019 06:38:59 -0700 (PDT)
Received: from e121566-lin.cambridge.arm.com (e121566-lin.cambridge.arm.com [10.1.196.217])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id 652D73F246;
        Wed, 28 Aug 2019 06:38:58 -0700 (PDT)
From:   Alexandru Elisei <alexandru.elisei@arm.com>
To:     kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu
Cc:     drjones@redhat.com, pbonzini@redhat.com, rkrcmar@redhat.com,
        maz@kernel.org, vladimir.murzin@arm.com, andre.przywara@arm.com
Subject: [kvm-unit-tests RFC PATCH 07/16] arm64: timer: Test behavior when timer disabled or masked
Date:   Wed, 28 Aug 2019 14:38:22 +0100
Message-Id: <1566999511-24916-8-git-send-email-alexandru.elisei@arm.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1566999511-24916-1-git-send-email-alexandru.elisei@arm.com>
References: <1566999511-24916-1-git-send-email-alexandru.elisei@arm.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

When the timer is disabled (the ENABLE bit is clear) or the timer interrupt
is masked at the timer level (the IMASK bit is set), timer interrupts must
not be pending or asserted by the VGIC. However, when the timer interrupt
is masked, we can still check that the timer condition is met by reading
the ISTATUS bit.

Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>
---
This test was used to discover the issue fixed by the upstream patch
16e604a437c8 ("KVM: arm/arm64: vgic: Reevaluate level sensitive interrupts
on enable").

 arm/timer.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/arm/timer.c b/arm/timer.c
index 7ae169bd687e..125b9f30ad3c 100644
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
2.7.4

