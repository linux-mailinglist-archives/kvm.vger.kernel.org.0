Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7DEE71D674B
	for <lists+kvm@lfdr.de>; Sun, 17 May 2020 12:11:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727869AbgEQKL1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 17 May 2020 06:11:27 -0400
Received: from szxga05-in.huawei.com ([45.249.212.191]:4803 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727832AbgEQKL1 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 17 May 2020 06:11:27 -0400
Received: from DGGEMS413-HUB.china.huawei.com (unknown [172.30.72.60])
        by Forcepoint Email with ESMTP id 12990D04573930373B12;
        Sun, 17 May 2020 18:11:24 +0800 (CST)
Received: from DESKTOP-FPN2511.china.huawei.com (10.173.222.58) by
 DGGEMS413-HUB.china.huawei.com (10.3.19.213) with Microsoft SMTP Server id
 14.3.487.0; Sun, 17 May 2020 18:11:17 +0800
From:   Jingyi Wang <wangjingyi11@huawei.com>
To:     <drjones@redhat.com>, <kvm@vger.kernel.org>,
        <kvmarm@lists.cs.columbia.edu>, <wangjingyi11@huawei.com>
CC:     <maz@kernel.org>, <wanghaibin.wang@huawei.com>,
        <yuzenghui@huawei.com>, <eric.auger@redhat.com>
Subject: [kvm-unit-tests PATCH 6/6] arm64: microbench: Add vtimer latency test
Date:   Sun, 17 May 2020 18:09:00 +0800
Message-ID: <20200517100900.30792-7-wangjingyi11@huawei.com>
X-Mailer: git-send-email 2.14.1.windows.1
In-Reply-To: <20200517100900.30792-1-wangjingyi11@huawei.com>
References: <20200517100900.30792-1-wangjingyi11@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.173.222.58]
X-CFilter-Loop: Reflected
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Triggers PPIs by setting up a 10msec timer and test the latency.
For this test can be time consuming, we add time limit for loop_test
to make sure each test should be done in a certain time(5 sec here).

Signed-off-by: Jingyi Wang <wangjingyi11@huawei.com>
---
 arm/micro-bench.c | 81 ++++++++++++++++++++++++++++++++++++++++-------
 1 file changed, 70 insertions(+), 11 deletions(-)

diff --git a/arm/micro-bench.c b/arm/micro-bench.c
index 91af1f7..dbe8e54 100644
--- a/arm/micro-bench.c
+++ b/arm/micro-bench.c
@@ -23,6 +23,11 @@
 #include <asm/gic-v3-its.h>
 
 #define NTIMES (1U << 16)
+#define MAX_NS (5 * 1000 * 1000 * 1000UL)
+
+#define IRQ_VTIMER		27
+#define ARCH_TIMER_CTL_ENABLE	(1 << 0)
+#define ARCH_TIMER_CTL_IMASK	(1 << 1)
 
 static u32 cntfrq;
 
@@ -33,9 +38,16 @@ static bool ipi_hw;
 
 static void gic_irq_handler(struct pt_regs *regs)
 {
+	u32 irqstat = gic_read_iar();
 	irq_ready = false;
 	irq_received = true;
-	gic_write_eoir(gic_read_iar());
+	gic_write_eoir(irqstat);
+
+	if (irqstat == IRQ_VTIMER) {
+		write_sysreg((ARCH_TIMER_CTL_IMASK | ARCH_TIMER_CTL_ENABLE),
+				cntv_ctl_el0);
+		isb();
+	}
 	irq_ready = true;
 }
 
@@ -195,6 +207,47 @@ static void lpi_exec(void)
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
+	writel(1 << IRQ_VTIMER, gic_isenabler);
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
@@ -241,6 +294,7 @@ static struct exit_test tests[] = {
 	{"ipi",			ipi_prep,	ipi_exec,		true},
 	{"ipi_hw",		ipi_hw_prep,	ipi_exec,		true},
 	{"lpi",			lpi_prep,	lpi_exec,		true},
+	{"timer_10ms",		timer_prep,	timer_exec,		true},
 };
 
 struct ns_time {
@@ -261,27 +315,32 @@ static void ticks_to_ns_time(uint64_t ticks, struct ns_time *ns_time)
 
 static void loop_test(struct exit_test *test)
 {
-	uint64_t start, end, total_ticks, ntimes = NTIMES;
+	uint64_t start, end, total_ticks, ntimes = 0;
 	struct ns_time total_ns, avg_ns;
 
+	total_ticks = 0;
 	if (test->prep) {
 		if(!test->prep()) {
-
 			printf("%s test skipped\n", test->name);
 			return;
 		}
 	}
-	isb();
-	start = read_sysreg(cntpct_el0);
-	while (ntimes--)
+
+	while (ntimes < NTIMES && total_ns.ns < MAX_NS) {
+		isb();
+		start = read_sysreg(cntpct_el0);
 		test->exec();
-	isb();
-	end = read_sysreg(cntpct_el0);
+		isb();
+		end = read_sysreg(cntpct_el0);
+
+		ntimes++;
+		total_ticks += (end - start);
+		ticks_to_ns_time(total_ticks, &total_ns);
+	}
 
-	total_ticks = end - start;
 	ticks_to_ns_time(total_ticks, &total_ns);
-	avg_ns.ns = total_ns.ns / NTIMES;
-	avg_ns.ns_frac = total_ns.ns_frac / NTIMES;
+	avg_ns.ns = total_ns.ns / ntimes;
+	avg_ns.ns_frac = total_ns.ns_frac / ntimes;
 
 	printf("%-30s%15" PRId64 ".%-15" PRId64 "%15" PRId64 ".%-15" PRId64 "\n",
 		test->name, total_ns.ns, total_ns.ns_frac, avg_ns.ns, avg_ns.ns_frac);
-- 
2.19.1


