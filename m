Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 15041A0367
	for <lists+kvm@lfdr.de>; Wed, 28 Aug 2019 15:39:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726669AbfH1Ni7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 28 Aug 2019 09:38:59 -0400
Received: from foss.arm.com ([217.140.110.172]:59568 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726454AbfH1Ni6 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 28 Aug 2019 09:38:58 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 2FC83360;
        Wed, 28 Aug 2019 06:38:58 -0700 (PDT)
Received: from e121566-lin.cambridge.arm.com (e121566-lin.cambridge.arm.com [10.1.196.217])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id 116673F246;
        Wed, 28 Aug 2019 06:38:56 -0700 (PDT)
From:   Alexandru Elisei <alexandru.elisei@arm.com>
To:     kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu
Cc:     drjones@redhat.com, pbonzini@redhat.com, rkrcmar@redhat.com,
        maz@kernel.org, vladimir.murzin@arm.com, andre.przywara@arm.com
Subject: [kvm-unit-tests RFC PATCH 06/16] arm64: timer: EOIR the interrupt after masking the timer
Date:   Wed, 28 Aug 2019 14:38:21 +0100
Message-Id: <1566999511-24916-7-git-send-email-alexandru.elisei@arm.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1566999511-24916-1-git-send-email-alexandru.elisei@arm.com>
References: <1566999511-24916-1-git-send-email-alexandru.elisei@arm.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Writing to the EOIR register before masking the HW mapped timer interrupt
can cause taking another timer interrupt immediatly after exception return.
This doesn't happen all the time, because KVM reevaluates the state of
pending HW mapped level sensitive interrupts on each guest exit. If a guest
exit occurs after masking the timer interrupt, but before the ERET, when
the extra interrupt is pending, then KVM will remove it.

Move the write after the IMASK bit has been set to prevent this from
happening.

Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>
---
 arm/timer.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/arm/timer.c b/arm/timer.c
index 78f0dd870993..7ae169bd687e 100644
--- a/arm/timer.c
+++ b/arm/timer.c
@@ -149,8 +149,8 @@ static void irq_handler(struct pt_regs *regs)
 	u32 irqstat = gic_read_iar();
 	u32 irqnr = gic_iar_irqnr(irqstat);
 
-	if (irqnr != GICC_INT_SPURIOUS)
-		gic_write_eoir(irqstat);
+	if (irqnr == GICC_INT_SPURIOUS)
+		return;
 
 	if (irqnr == PPI(vtimer_info.irq)) {
 		info = &vtimer_info;
@@ -162,7 +162,11 @@ static void irq_handler(struct pt_regs *regs)
 	}
 
 	info->write_ctl(ARCH_TIMER_CTL_IMASK | ARCH_TIMER_CTL_ENABLE);
+	isb();
+
 	info->irq_received = true;
+
+	gic_write_eoir(irqstat);
 }
 
 static bool gic_timer_pending(struct timer_info *info)
-- 
2.7.4

