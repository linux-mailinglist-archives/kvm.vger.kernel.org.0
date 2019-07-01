Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B193932B88
	for <lists+kvm@lfdr.de>; Mon,  3 Jun 2019 11:09:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726842AbfFCJJg (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 3 Jun 2019 05:09:36 -0400
Received: from mx1.redhat.com ([209.132.183.28]:50182 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726555AbfFCJJf (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 3 Jun 2019 05:09:35 -0400
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id E72765F79B
        for <kvm@vger.kernel.org>; Mon,  3 Jun 2019 09:09:35 +0000 (UTC)
Received: from kamzik.brq.redhat.com (unknown [10.43.2.160])
        by smtp.corp.redhat.com (Postfix) with ESMTP id EE72761981;
        Mon,  3 Jun 2019 09:09:34 +0000 (UTC)
From:   Andrew Jones <drjones@redhat.com>
To:     kvm@vger.kernel.org
Cc:     pbonzini@redhat.com, rkrcmar@redhat.com
Subject: [PATCH kvm-unit-tests] arm64: timer: a few test improvements
Date:   Mon,  3 Jun 2019 11:09:33 +0200
Message-Id: <20190603090933.20312-1-drjones@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.39]); Mon, 03 Jun 2019 09:09:35 +0000 (UTC)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

1) Ensure set_timer_irq_enabled() clears the pending interrupt
   from the gic before proceeding with the next test.
2) Inform user we're about to wait for an interrupt - just in
   case we never come back...
3) Allow the user to choose just vtimer or just ptimer tests,
   or to reverse their order with -append 'ptimer vtimer'.

Signed-off-by: Andrew Jones <drjones@redhat.com>
---
 arm/timer.c | 17 +++++++++++++++--
 1 file changed, 15 insertions(+), 2 deletions(-)

diff --git a/arm/timer.c b/arm/timer.c
index 275d0494083d..6f2ad1d76ab2 100644
--- a/arm/timer.c
+++ b/arm/timer.c
@@ -231,6 +231,7 @@ static void test_timer(struct timer_info *info)
 	/* Disable the timer again and prepare to take interrupts */
 	info->write_ctl(0);
 	set_timer_irq_enabled(info, true);
+	report("interrupt signal no longer pending", !gic_timer_pending(info));
 
 	report("latency within 10 ms", test_cval_10msec(info));
 	report("interrupt received", info->irq_received);
@@ -242,6 +243,7 @@ static void test_timer(struct timer_info *info)
 	info->irq_received = false;
 	info->write_tval(read_sysreg(cntfrq_el0) / 100);	/* 10 ms */
 	info->write_ctl(ARCH_TIMER_CTL_ENABLE);
+	report_info("waiting for interrupt...");
 	wfi();
 	left = info->read_tval();
 	report("interrupt received after TVAL/WFI", info->irq_received);
@@ -328,12 +330,23 @@ static void print_timer_info(void)
 
 int main(int argc, char **argv)
 {
+	int i;
+
 	test_init();
 
 	print_timer_info();
 
-	test_vtimer();
-	test_ptimer();
+	if (argc == 1) {
+		test_vtimer();
+		test_ptimer();
+	}
+
+	for (i = 1; i < argc; ++i) {
+		if (strcmp(argv[i], "vtimer") == 0)
+			test_vtimer();
+		if (strcmp(argv[i], "ptimer") == 0)
+			test_ptimer();
+	}
 
 	return report_summary();
 }
-- 
2.20.1

