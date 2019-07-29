Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7B2E978861
	for <lists+kvm@lfdr.de>; Mon, 29 Jul 2019 11:29:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727830AbfG2J3J (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 29 Jul 2019 05:29:09 -0400
Received: from foss.arm.com ([217.140.110.172]:40630 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726496AbfG2J3I (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 29 Jul 2019 05:29:08 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 580A9344;
        Mon, 29 Jul 2019 02:29:08 -0700 (PDT)
Received: from e121566-lin.cambridge.arm.com (e121566-lin.cambridge.arm.com [10.1.196.217])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id 805E63F694;
        Mon, 29 Jul 2019 02:29:07 -0700 (PDT)
From:   Alexandru Elisei <alexandru.elisei@arm.com>
To:     kvm@vger.kernel.org
Cc:     drjones@redhat.com, pbonzini@redhat.com,
        kvmarm@lists.cs.columbia.edu, marc.zyngier@arm.com
Subject: [kvm-unit-tests PATCH] arm: timer: Fix potential deadlock when waiting for interrupt
Date:   Mon, 29 Jul 2019 10:28:52 +0100
Message-Id: <1564392532-7692-1-git-send-email-alexandru.elisei@arm.com>
X-Mailer: git-send-email 2.7.4
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Commit 204e85aa9352 ("arm64: timer: a few test improvements") added a call
to report_info after enabling the timer and before the wfi instruction. The
uart that printf uses is emulated by userspace and is slow, which makes it
more likely that the timer interrupt will fire before executing the wfi
instruction, which leads to a deadlock.

An interrupt can wake up a CPU out of wfi, regardless of the
PSTATE.{A, I, F} bits. Fix the deadlock by masking interrupts on the CPU
before enabling the timer and unmasking them after the wfi returns so the
CPU can execute the timer interrupt handler.

Suggested-by: Marc Zyngier <marc.zyngier@arm.com>
Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>
---
 arm/timer.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/arm/timer.c b/arm/timer.c
index 6f2ad1d76ab2..f2f60192ba62 100644
--- a/arm/timer.c
+++ b/arm/timer.c
@@ -242,9 +242,11 @@ static void test_timer(struct timer_info *info)
 	/* Test TVAL and IRQ trigger */
 	info->irq_received = false;
 	info->write_tval(read_sysreg(cntfrq_el0) / 100);	/* 10 ms */
+	local_irq_disable();
 	info->write_ctl(ARCH_TIMER_CTL_ENABLE);
 	report_info("waiting for interrupt...");
 	wfi();
+	local_irq_enable();
 	left = info->read_tval();
 	report("interrupt received after TVAL/WFI", info->irq_received);
 	report("timer has expired (%d)", left < 0, left);
-- 
2.7.4

