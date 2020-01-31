Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4DA9814F0AE
	for <lists+kvm@lfdr.de>; Fri, 31 Jan 2020 17:38:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726793AbgAaQiQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 31 Jan 2020 11:38:16 -0500
Received: from foss.arm.com ([217.140.110.172]:37360 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726157AbgAaQiQ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 31 Jan 2020 11:38:16 -0500
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 903ECFEC;
        Fri, 31 Jan 2020 08:38:15 -0800 (PST)
Received: from e123195-lin.cambridge.arm.com (e123195-lin.cambridge.arm.com [10.1.196.63])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id 8FDE13F68E;
        Fri, 31 Jan 2020 08:38:14 -0800 (PST)
From:   Alexandru Elisei <alexandru.elisei@arm.com>
To:     kvm@vger.kernel.org
Cc:     pbonzini@redhat.com, drjones@redhat.com, maz@kernel.org,
        andre.przywara@arm.com, vladimir.murzin@arm.com,
        mark.rutland@arm.com
Subject: [kvm-unit-tests PATCH v4 06/10] arm64: timer: EOIR the interrupt after masking the timer
Date:   Fri, 31 Jan 2020 16:37:24 +0000
Message-Id: <20200131163728.5228-7-alexandru.elisei@arm.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200131163728.5228-1-alexandru.elisei@arm.com>
References: <20200131163728.5228-1-alexandru.elisei@arm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Writing to the EOIR register before masking the HW mapped timer
interrupt can cause taking another timer interrupt immediately after
exception return. This doesn't happen all the time, because KVM
reevaluates the state of pending HW mapped level sensitive interrupts on
each guest exit. If the second interrupt is pending and a guest exit
occurs after masking the timer interrupt and before the ERET (which
restores PSTATE.I), then KVM removes it.

Move the write after the IMASK bit has been set to prevent this from
happening.

Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>
---
 arm/timer.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/arm/timer.c b/arm/timer.c
index 82f891147b35..b6f9dd10162d 100644
--- a/arm/timer.c
+++ b/arm/timer.c
@@ -157,19 +157,20 @@ static void irq_handler(struct pt_regs *regs)
 	u32 irqstat = gic_read_iar();
 	u32 irqnr = gic_iar_irqnr(irqstat);
 
-	if (irqnr != GICC_INT_SPURIOUS)
-		gic_write_eoir(irqstat);
-
 	if (irqnr == PPI(vtimer_info.irq)) {
 		info = &vtimer_info;
 	} else if (irqnr == PPI(ptimer_info.irq)) {
 		info = &ptimer_info;
 	} else {
+		if (irqnr != GICC_INT_SPURIOUS)
+			gic_write_eoir(irqstat);
 		report_info("Unexpected interrupt: %d\n", irqnr);
 		return;
 	}
 
 	info->write_ctl(ARCH_TIMER_CTL_IMASK | ARCH_TIMER_CTL_ENABLE);
+	gic_write_eoir(irqstat);
+
 	info->irq_received = true;
 }
 
-- 
2.20.1

