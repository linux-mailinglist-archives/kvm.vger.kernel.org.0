Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0798D19A92B
	for <lists+kvm@lfdr.de>; Wed,  1 Apr 2020 12:08:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731343AbgDAKIk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 1 Apr 2020 06:08:40 -0400
Received: from szxga06-in.huawei.com ([45.249.212.32]:36292 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725860AbgDAKIk (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 1 Apr 2020 06:08:40 -0400
Received: from DGGEMS408-HUB.china.huawei.com (unknown [172.30.72.58])
        by Forcepoint Email with ESMTP id 81EBF35FAB3AE066FAFF;
        Wed,  1 Apr 2020 18:08:35 +0800 (CST)
Received: from DESKTOP-FPN2511.china.huawei.com (10.173.222.58) by
 DGGEMS408-HUB.china.huawei.com (10.3.19.208) with Microsoft SMTP Server id
 14.3.487.0; Wed, 1 Apr 2020 18:08:29 +0800
From:   Jingyi Wang <wangjingyi11@huawei.com>
To:     <drjones@redhat.com>, <kvm@vger.kernel.org>,
        <kvmarm@lists.cs.columbia.edu>
CC:     <wanghaibin.wang@huawei.com>, <yuzenghui@huawei.com>,
        Jingyi Wang <wangjingyi11@huawei.com>
Subject: [kvm-unit-tests PATCH 2/2] arm/arm64: Add vtimer latency test
Date:   Wed, 1 Apr 2020 18:08:12 +0800
Message-ID: <20200401100812.27616-3-wangjingyi11@huawei.com>
X-Mailer: git-send-email 2.14.1.windows.1
In-Reply-To: <20200401100812.27616-1-wangjingyi11@huawei.com>
References: <20200401100812.27616-1-wangjingyi11@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.173.222.58]
X-CFilter-Loop: Reflected
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This patch add a test to measure the precise vtimer firing time.

Signed-off-by: Jingyi Wang <wangjingyi11@huawei.com>
---
 arm/timer.c | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/arm/timer.c b/arm/timer.c
index f390e8e..1d5b3dc 100644
--- a/arm/timer.c
+++ b/arm/timer.c
@@ -16,6 +16,9 @@
 #define ARCH_TIMER_CTL_IMASK   (1 << 1)
 #define ARCH_TIMER_CTL_ISTATUS (1 << 2)
 
+static u64 inject_time;
+static u64 receive_time;
+
 static void *gic_ispendr;
 static void *gic_isenabler;
 static void *gic_icenabler;
@@ -149,6 +152,8 @@ static void irq_handler(struct pt_regs *regs)
 	u32 irqstat = gic_read_iar();
 	u32 irqnr = gic_iar_irqnr(irqstat);
 
+	receive_time = get_cntvct();
+
 	if (irqnr != GICC_INT_SPURIOUS)
 		gic_write_eoir(irqstat);
 
@@ -163,6 +168,11 @@ static void irq_handler(struct pt_regs *regs)
 
 	info->write_ctl(ARCH_TIMER_CTL_IMASK | ARCH_TIMER_CTL_ENABLE);
 	info->irq_received = true;
+
+	if (inject_time != 0)
+		report_info("vtimer latency: %ld cycles/10ms\n",
+			receive_time - inject_time);
+	inject_time = 0;
 }
 
 static bool gic_timer_pending(struct timer_info *info)
@@ -179,6 +189,7 @@ static bool test_cval_10msec(struct timer_info *info)
 
 	/* Program timer to fire in 10 ms */
 	before_timer = info->read_counter();
+	inject_time = get_cntvct();
 	info->write_cval(before_timer + time_10ms);
 	info->write_ctl(ARCH_TIMER_CTL_ENABLE);
 	isb();
-- 
2.19.1


