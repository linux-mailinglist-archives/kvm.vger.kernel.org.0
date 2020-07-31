Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 83BD6234044
	for <lists+kvm@lfdr.de>; Fri, 31 Jul 2020 09:43:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731732AbgGaHnd (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 31 Jul 2020 03:43:33 -0400
Received: from szxga06-in.huawei.com ([45.249.212.32]:34228 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1731723AbgGaHnd (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 31 Jul 2020 03:43:33 -0400
Received: from DGGEMS414-HUB.china.huawei.com (unknown [172.30.72.59])
        by Forcepoint Email with ESMTP id D6EE2BF785157088A94E;
        Fri, 31 Jul 2020 15:43:31 +0800 (CST)
Received: from DESKTOP-FPN2511.china.huawei.com (10.174.187.42) by
 DGGEMS414-HUB.china.huawei.com (10.3.19.214) with Microsoft SMTP Server id
 14.3.487.0; Fri, 31 Jul 2020 15:43:24 +0800
From:   Jingyi Wang <wangjingyi11@huawei.com>
To:     <drjones@redhat.com>, <kvm@vger.kernel.org>,
        <kvmarm@lists.cs.columbia.edu>
CC:     <maz@kernel.org>, <wanghaibin.wang@huawei.com>,
        <yuzenghui@huawei.com>, <eric.auger@redhat.com>,
        <wangjingyi11@huawei.com>, <prime.zeng@hisilicon.com>
Subject: [kvm-unit-tests PATCH v3 02/10] arm64: microbench: Generalize ipi test names
Date:   Fri, 31 Jul 2020 15:42:36 +0800
Message-ID: <20200731074244.20432-3-wangjingyi11@huawei.com>
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

Later patches will use these functions for gic(ipi/lpi/timer) tests.

Signed-off-by: Jingyi Wang <wangjingyi11@huawei.com>
Reviewed-by: Eric Auger <eric.auger@redhat.com>
---
 arm/micro-bench.c | 39 ++++++++++++++++++++++-----------------
 1 file changed, 22 insertions(+), 17 deletions(-)

diff --git a/arm/micro-bench.c b/arm/micro-bench.c
index 794dfac..fc4d356 100644
--- a/arm/micro-bench.c
+++ b/arm/micro-bench.c
@@ -25,24 +25,24 @@
 
 static u32 cntfrq;
 
-static volatile bool ipi_ready, ipi_received;
+static volatile bool irq_ready, irq_received;
 static void *vgic_dist_base;
 static void (*write_eoir)(u32 irqstat);
 
-static void ipi_irq_handler(struct pt_regs *regs)
+static void gic_irq_handler(struct pt_regs *regs)
 {
-	ipi_ready = false;
-	ipi_received = true;
+	irq_ready = false;
+	irq_received = true;
 	gic_write_eoir(gic_read_iar());
-	ipi_ready = true;
+	irq_ready = true;
 }
 
-static void ipi_secondary_entry(void *data)
+static void gic_secondary_entry(void *data)
 {
-	install_irq_handler(EL1H_IRQ, ipi_irq_handler);
+	install_irq_handler(EL1H_IRQ, gic_irq_handler);
 	gic_enable_defaults();
 	local_irq_enable();
-	ipi_ready = true;
+	irq_ready = true;
 	while (true)
 		cpu_relax();
 }
@@ -72,9 +72,9 @@ static bool test_init(void)
 		break;
 	}
 
-	ipi_ready = false;
+	irq_ready = false;
 	gic_enable_defaults();
-	on_cpu_async(1, ipi_secondary_entry, NULL);
+	on_cpu_async(1, gic_secondary_entry, NULL);
 
 	cntfrq = get_cntfrq();
 	printf("Timer Frequency %d Hz (Output in microseconds)\n", cntfrq);
@@ -82,13 +82,18 @@ static bool test_init(void)
 	return true;
 }
 
-static void ipi_prep(void)
+static void gic_prep_common(void)
 {
 	unsigned tries = 1 << 28;
 
-	while (!ipi_ready && tries--)
+	while (!irq_ready && tries--)
 		cpu_relax();
-	assert(ipi_ready);
+	assert(irq_ready);
+}
+
+static void ipi_prep(void)
+{
+	gic_prep_common();
 }
 
 static void ipi_exec(void)
@@ -96,17 +101,17 @@ static void ipi_exec(void)
 	unsigned tries = 1 << 28;
 	static int received = 0;
 
-	ipi_received = false;
+	irq_received = false;
 
 	gic_ipi_send_single(1, 1);
 
-	while (!ipi_received && tries--)
+	while (!irq_received && tries--)
 		cpu_relax();
 
-	if (ipi_received)
+	if (irq_received)
 		++received;
 
-	assert_msg(ipi_received, "failed to receive IPI in time, but received %d successfully\n", received);
+	assert_msg(irq_received, "failed to receive IPI in time, but received %d successfully\n", received);
 }
 
 static void hvc_exec(void)
-- 
2.19.1


