Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D5B8F23404E
	for <lists+kvm@lfdr.de>; Fri, 31 Jul 2020 09:43:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731790AbgGaHnl (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 31 Jul 2020 03:43:41 -0400
Received: from szxga06-in.huawei.com ([45.249.212.32]:34368 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1731749AbgGaHnk (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 31 Jul 2020 03:43:40 -0400
Received: from DGGEMS414-HUB.china.huawei.com (unknown [172.30.72.60])
        by Forcepoint Email with ESMTP id BA0EE64F97D95F17C648;
        Fri, 31 Jul 2020 15:43:36 +0800 (CST)
Received: from DESKTOP-FPN2511.china.huawei.com (10.174.187.42) by
 DGGEMS414-HUB.china.huawei.com (10.3.19.214) with Microsoft SMTP Server id
 14.3.487.0; Fri, 31 Jul 2020 15:43:28 +0800
From:   Jingyi Wang <wangjingyi11@huawei.com>
To:     <drjones@redhat.com>, <kvm@vger.kernel.org>,
        <kvmarm@lists.cs.columbia.edu>
CC:     <maz@kernel.org>, <wanghaibin.wang@huawei.com>,
        <yuzenghui@huawei.com>, <eric.auger@redhat.com>,
        <wangjingyi11@huawei.com>, <prime.zeng@hisilicon.com>
Subject: [kvm-unit-tests PATCH v3 08/10] arm64: microbench: Add vtimer latency test
Date:   Fri, 31 Jul 2020 15:42:42 +0800
Message-ID: <20200731074244.20432-9-wangjingyi11@huawei.com>
X-Mailer: git-send-email 2.14.1.windows.1
In-Reply-To: <20200731074244.20432-1-wangjingyi11@huawei.com>
References: <20200731074244.20432-1-wangjingyi11@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.174.187.42]
X-CFilter-Loop: Reflected
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Trigger PPIs by setting up a 10msec timer and test the latency.

Signed-off-by: Jingyi Wang <wangjingyi11@huawei.com>
---
 arm/micro-bench.c | 53 ++++++++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 52 insertions(+), 1 deletion(-)

diff --git a/arm/micro-bench.c b/arm/micro-bench.c
index 09d9d53..1e1bde5 100644
--- a/arm/micro-bench.c
+++ b/arm/micro-bench.c
@@ -21,8 +21,10 @@
 #include <libcflat.h>
 #include <asm/gic.h>
 #include <asm/gic-v3-its.h>
+#include <asm/timer.h>
 
 #define NS_5_SECONDS (5 * 1000 * 1000 * 1000UL)
+
 static u32 cntfrq;
 
 static volatile bool irq_ready, irq_received;
@@ -33,9 +35,16 @@ static void (*write_eoir)(u32 irqstat);
 
 static void gic_irq_handler(struct pt_regs *regs)
 {
+	u32 irqstat = gic_read_iar();
 	irq_ready = false;
 	irq_received = true;
-	gic_write_eoir(gic_read_iar());
+	gic_write_eoir(irqstat);
+
+	if (irqstat == PPI(TIMER_VTIMER_IRQ)) {
+		write_sysreg((ARCH_TIMER_CTL_IMASK | ARCH_TIMER_CTL_ENABLE),
+			     cntv_ctl_el0);
+		isb();
+	}
 	irq_ready = true;
 }
 
@@ -198,6 +207,47 @@ static void lpi_exec(void)
 	assert_msg(irq_received, "failed to receive LPI in time, but received %d successfully\n", received);
 }
 
+static bool timer_prep(void)
+{
+	static void *gic_isenabler;
+
+	gic_enable_defaults();
+	install_irq_handler(EL1H_IRQ, gic_irq_handler);
+	local_irq_enable();
+
+	gic_isenabler = gicv3_sgi_base() + GICR_ISENABLER0;
+	writel(1 << PPI(TIMER_VTIMER_IRQ), gic_isenabler);
+	write_sysreg(ARCH_TIMER_CTL_ENABLE, cntv_ctl_el0);
+	isb();
+
+	gic_prep_common();
+	return true;
+}
+
+static void timer_exec(void)
+{
+	u64 before_timer;
+	u64 timer_10ms;
+	unsigned tries = 1 << 28;
+	static int received = 0;
+
+	irq_received = false;
+
+	before_timer = read_sysreg(cntvct_el0);
+	timer_10ms = cntfrq / 100;
+	write_sysreg(before_timer + timer_10ms, cntv_cval_el0);
+	write_sysreg(ARCH_TIMER_CTL_ENABLE, cntv_ctl_el0);
+	isb();
+
+	while (!irq_received && tries--)
+		cpu_relax();
+
+	if (irq_received)
+		++received;
+
+	assert_msg(irq_received, "failed to receive PPI in time, but received %d successfully\n", received);
+}
+
 static void hvc_exec(void)
 {
 	asm volatile("mov w0, #0x4b000000; hvc #0" ::: "w0");
@@ -245,6 +295,7 @@ static struct exit_test tests[] = {
 	{"ipi",			ipi_prep,	ipi_exec,		65536,		true},
 	{"ipi_hw",		ipi_hw_prep,	ipi_exec,		65536,		true},
 	{"lpi",			lpi_prep,	lpi_exec,		65536,		true},
+	{"timer_10ms",		timer_prep,	timer_exec,		256,		true},
 };
 
 struct ns_time {
-- 
2.19.1


