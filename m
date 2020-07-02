Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7FC4F211A75
	for <lists+kvm@lfdr.de>; Thu,  2 Jul 2020 05:02:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726514AbgGBDCd (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 1 Jul 2020 23:02:33 -0400
Received: from szxga07-in.huawei.com ([45.249.212.35]:47214 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726345AbgGBDCc (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 1 Jul 2020 23:02:32 -0400
Received: from DGGEMS405-HUB.china.huawei.com (unknown [172.30.72.60])
        by Forcepoint Email with ESMTP id 70D6486F3619031EC0BE;
        Thu,  2 Jul 2020 11:02:30 +0800 (CST)
Received: from DESKTOP-FPN2511.china.huawei.com (10.174.187.42) by
 DGGEMS405-HUB.china.huawei.com (10.3.19.205) with Microsoft SMTP Server id
 14.3.487.0; Thu, 2 Jul 2020 11:02:21 +0800
From:   Jingyi Wang <wangjingyi11@huawei.com>
To:     <drjones@redhat.com>, <kvm@vger.kernel.org>,
        <kvmarm@lists.cs.columbia.edu>
CC:     <maz@kernel.org>, <wanghaibin.wang@huawei.com>,
        <yuzenghui@huawei.com>, <eric.auger@redhat.com>,
        <wangjingyi11@huawei.com>
Subject: [kvm-unit-tests PATCH v2 2/8] arm64: microbench: Use the funcions for ipi test as the general functions for gic(ipi/lpi/timer) test
Date:   Thu, 2 Jul 2020 11:01:26 +0800
Message-ID: <20200702030132.20252-3-wangjingyi11@huawei.com>
X-Mailer: git-send-email 2.14.1.windows.1
In-Reply-To: <20200702030132.20252-1-wangjingyi11@huawei.com>
References: <20200702030132.20252-1-wangjingyi11@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.174.187.42]
X-CFilter-Loop: Reflected
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The following patches will use that.

Signed-off-by: Jingyi Wang <wangjingyi11@huawei.com>
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


