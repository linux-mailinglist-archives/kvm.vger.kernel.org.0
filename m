Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CF3E514F0AA
	for <lists+kvm@lfdr.de>; Fri, 31 Jan 2020 17:38:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726743AbgAaQiM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 31 Jan 2020 11:38:12 -0500
Received: from foss.arm.com ([217.140.110.172]:37336 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726139AbgAaQiM (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 31 Jan 2020 11:38:12 -0500
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id D80A211D4;
        Fri, 31 Jan 2020 08:38:11 -0800 (PST)
Received: from e123195-lin.cambridge.arm.com (e123195-lin.cambridge.arm.com [10.1.196.63])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id D6BF73F68E;
        Fri, 31 Jan 2020 08:38:10 -0800 (PST)
From:   Alexandru Elisei <alexandru.elisei@arm.com>
To:     kvm@vger.kernel.org
Cc:     pbonzini@redhat.com, drjones@redhat.com, maz@kernel.org,
        andre.przywara@arm.com, vladimir.murzin@arm.com,
        mark.rutland@arm.com
Subject: [kvm-unit-tests PATCH v4 03/10] arm64: timer: Add ISB after register writes
Date:   Fri, 31 Jan 2020 16:37:21 +0000
Message-Id: <20200131163728.5228-4-alexandru.elisei@arm.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200131163728.5228-1-alexandru.elisei@arm.com>
References: <20200131163728.5228-1-alexandru.elisei@arm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From ARM DDI 0487E.a glossary, the section "Context synchronization
event":

"All direct and indirect writes to System registers that are made before
the Context synchronization event affect any instruction, including a
direct read, that appears in program order after the instruction causing
the Context synchronization event."

The ISB instruction is a context synchronization event [1]. Add an ISB
after all register writes, to make sure that the writes have been
completed when we try to test their effects.

[1] ARM DDI 0487E.a, section C6.2.96

Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>
---
 arm/timer.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/arm/timer.c b/arm/timer.c
index f390e8e65d31..c6ea108cfa4b 100644
--- a/arm/timer.c
+++ b/arm/timer.c
@@ -41,6 +41,7 @@ static u64 read_vtimer_cval(void)
 static void write_vtimer_cval(u64 val)
 {
 	write_sysreg(val, cntv_cval_el0);
+	isb();
 }
 
 static s32 read_vtimer_tval(void)
@@ -51,6 +52,7 @@ static s32 read_vtimer_tval(void)
 static void write_vtimer_tval(s32 val)
 {
 	write_sysreg(val, cntv_tval_el0);
+	isb();
 }
 
 static u64 read_vtimer_ctl(void)
@@ -61,6 +63,7 @@ static u64 read_vtimer_ctl(void)
 static void write_vtimer_ctl(u64 val)
 {
 	write_sysreg(val, cntv_ctl_el0);
+	isb();
 }
 
 static u64 read_ptimer_counter(void)
@@ -76,6 +79,7 @@ static u64 read_ptimer_cval(void)
 static void write_ptimer_cval(u64 val)
 {
 	write_sysreg(val, cntp_cval_el0);
+	isb();
 }
 
 static s32 read_ptimer_tval(void)
@@ -86,6 +90,7 @@ static s32 read_ptimer_tval(void)
 static void write_ptimer_tval(s32 val)
 {
 	write_sysreg(val, cntp_tval_el0);
+	isb();
 }
 
 static u64 read_ptimer_ctl(void)
@@ -96,6 +101,7 @@ static u64 read_ptimer_ctl(void)
 static void write_ptimer_ctl(u64 val)
 {
 	write_sysreg(val, cntp_ctl_el0);
+	isb();
 }
 
 struct timer_info {
@@ -181,7 +187,6 @@ static bool test_cval_10msec(struct timer_info *info)
 	before_timer = info->read_counter();
 	info->write_cval(before_timer + time_10ms);
 	info->write_ctl(ARCH_TIMER_CTL_ENABLE);
-	isb();
 
 	/* Wait for the timer to fire */
 	while (!(info->read_ctl() & ARCH_TIMER_CTL_ISTATUS))
@@ -217,11 +222,9 @@ static void test_timer(struct timer_info *info)
 	/* Enable the timer, but schedule it for much later */
 	info->write_cval(later);
 	info->write_ctl(ARCH_TIMER_CTL_ENABLE);
-	isb();
 	report(!gic_timer_pending(info), "not pending before");
 
 	info->write_cval(now - 1);
-	isb();
 	report(gic_timer_pending(info), "interrupt signal pending");
 
 	/* Disable the timer again and prepare to take interrupts */
-- 
2.20.1

