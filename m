Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EAC031D674D
	for <lists+kvm@lfdr.de>; Sun, 17 May 2020 12:11:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727856AbgEQKL1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 17 May 2020 06:11:27 -0400
Received: from szxga05-in.huawei.com ([45.249.212.191]:4804 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727829AbgEQKL0 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 17 May 2020 06:11:26 -0400
Received: from DGGEMS413-HUB.china.huawei.com (unknown [172.30.72.60])
        by Forcepoint Email with ESMTP id 17CFCE35482A0151C02B;
        Sun, 17 May 2020 18:11:24 +0800 (CST)
Received: from DESKTOP-FPN2511.china.huawei.com (10.173.222.58) by
 DGGEMS413-HUB.china.huawei.com (10.3.19.213) with Microsoft SMTP Server id
 14.3.487.0; Sun, 17 May 2020 18:11:15 +0800
From:   Jingyi Wang <wangjingyi11@huawei.com>
To:     <drjones@redhat.com>, <kvm@vger.kernel.org>,
        <kvmarm@lists.cs.columbia.edu>, <wangjingyi11@huawei.com>
CC:     <maz@kernel.org>, <wanghaibin.wang@huawei.com>,
        <yuzenghui@huawei.com>, <eric.auger@redhat.com>
Subject: [kvm-unit-tests PATCH 3/6] arm64: microbench: gic: Add gicv4.1 support for ipi latency test.
Date:   Sun, 17 May 2020 18:08:57 +0800
Message-ID: <20200517100900.30792-4-wangjingyi11@huawei.com>
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

If gicv4.1(sgi hardware injection) supported, we test ipi injection
via hw/sw way separately.

Signed-off-by: Jingyi Wang <wangjingyi11@huawei.com>
---
 arm/micro-bench.c    | 53 +++++++++++++++++++++++++++++++++++++++-----
 lib/arm/asm/gic-v3.h |  5 +++++
 lib/arm/asm/gic.h    |  1 +
 3 files changed, 54 insertions(+), 5 deletions(-)

diff --git a/arm/micro-bench.c b/arm/micro-bench.c
index fc4d356..0c7869b 100644
--- a/arm/micro-bench.c
+++ b/arm/micro-bench.c
@@ -28,6 +28,7 @@ static u32 cntfrq;
 static volatile bool irq_ready, irq_received;
 static void *vgic_dist_base;
 static void (*write_eoir)(u32 irqstat);
+static bool ipi_hw;
 
 static void gic_irq_handler(struct pt_regs *regs)
 {
@@ -91,9 +92,42 @@ static void gic_prep_common(void)
 	assert(irq_ready);
 }
 
-static void ipi_prep(void)
+static bool ipi_prep(void)
 {
+	u32 val;
+
+	val = readl(vgic_dist_base + GICD_CTLR);
+	if (readl(vgic_dist_base + GICD_TYPER2) & GICD_TYPER2_nASSGIcap) {
+		val &= ~GICD_CTLR_ENABLE_G1A;
+		val &= ~GICD_CTLR_nASSGIreq;
+		writel(val, vgic_dist_base + GICD_CTLR);
+		val |= GICD_CTLR_ENABLE_G1A;
+		writel(val, vgic_dist_base + GICD_CTLR);
+	}
+
+	ipi_hw = false;
 	gic_prep_common();
+	return true;
+}
+
+static bool ipi_hw_prep(void)
+{
+	u32 val;
+
+	val = readl(vgic_dist_base + GICD_CTLR);
+	if (readl(vgic_dist_base + GICD_TYPER2) & GICD_TYPER2_nASSGIcap) {
+		val &= ~GICD_CTLR_ENABLE_G1A;
+		val |= GICD_CTLR_nASSGIreq;
+		writel(val, vgic_dist_base + GICD_CTLR);
+		val |= GICD_CTLR_ENABLE_G1A;
+		writel(val, vgic_dist_base + GICD_CTLR);
+	} else {
+		return false;
+	}
+
+	ipi_hw = true;
+	gic_prep_common();
+	return true;
 }
 
 static void ipi_exec(void)
@@ -103,7 +137,11 @@ static void ipi_exec(void)
 
 	irq_received = false;
 
-	gic_ipi_send_single(1, 1);
+	if (ipi_hw) {
+		writel(1 << 1, gicv3_sgi_base_percpu(1) + GICR_ISPENDR0);
+	} else {
+		gic_ipi_send_single(1, 1);
+	}
 
 	while (!irq_received && tries--)
 		cpu_relax();
@@ -147,7 +185,7 @@ static void eoi_exec(void)
 
 struct exit_test {
 	const char *name;
-	void (*prep)(void);
+	bool (*prep)(void);
 	void (*exec)(void);
 	bool run;
 };
@@ -158,6 +196,7 @@ static struct exit_test tests[] = {
 	{"mmio_read_vgic",	NULL,		mmio_read_vgic_exec,	true},
 	{"eoi",			NULL,		eoi_exec,		true},
 	{"ipi",			ipi_prep,	ipi_exec,		true},
+	{"ipi_hw",		ipi_hw_prep,	ipi_exec,		true},
 };
 
 struct ns_time {
@@ -181,9 +220,13 @@ static void loop_test(struct exit_test *test)
 	uint64_t start, end, total_ticks, ntimes = NTIMES;
 	struct ns_time total_ns, avg_ns;
 
-	if (test->prep)
-		test->prep();
+	if (test->prep) {
+		if(!test->prep()) {
 
+			printf("%s test skipped\n", test->name);
+			return;
+		}
+	}
 	isb();
 	start = read_sysreg(cntpct_el0);
 	while (ntimes--)
diff --git a/lib/arm/asm/gic-v3.h b/lib/arm/asm/gic-v3.h
index cb72922..cbf51ba 100644
--- a/lib/arm/asm/gic-v3.h
+++ b/lib/arm/asm/gic-v3.h
@@ -20,10 +20,13 @@
  */
 #define GICD_CTLR			0x0000
 #define GICD_CTLR_RWP			(1U << 31)
+#define GICD_CTLR_nASSGIreq		(1U << 8)
 #define GICD_CTLR_ARE_NS		(1U << 4)
 #define GICD_CTLR_ENABLE_G1A		(1U << 1)
 #define GICD_CTLR_ENABLE_G1		(1U << 0)
 
+#define GICD_TYPER2_nASSGIcap		(1U << 8)
+
 /* Re-Distributor registers, offsets from RD_base */
 #define GICR_TYPER			0x0008
 
@@ -87,6 +90,8 @@ extern struct gicv3_data gicv3_data;
 #define gicv3_redist_base()		(gicv3_data.redist_base[smp_processor_id()])
 #define gicv3_sgi_base()		(gicv3_data.redist_base[smp_processor_id()] + SZ_64K)
 
+#define gicv3_sgi_base_percpu(cpu)	(gicv3_data.redist_base[cpu] + SZ_64K)
+
 extern int gicv3_init(void);
 extern void gicv3_enable_defaults(void);
 extern u32 gicv3_read_iar(void);
diff --git a/lib/arm/asm/gic.h b/lib/arm/asm/gic.h
index 38e79b2..1898400 100644
--- a/lib/arm/asm/gic.h
+++ b/lib/arm/asm/gic.h
@@ -13,6 +13,7 @@
 #define GICD_CTLR			0x0000
 #define GICD_TYPER			0x0004
 #define GICD_IIDR			0x0008
+#define GICD_TYPER2			0x000C
 #define GICD_IGROUPR			0x0080
 #define GICD_ISENABLER			0x0100
 #define GICD_ICENABLER			0x0180
-- 
2.19.1


