Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D8B1F234051
	for <lists+kvm@lfdr.de>; Fri, 31 Jul 2020 09:43:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731763AbgGaHno (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 31 Jul 2020 03:43:44 -0400
Received: from szxga06-in.huawei.com ([45.249.212.32]:34392 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1731776AbgGaHnm (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 31 Jul 2020 03:43:42 -0400
Received: from DGGEMS414-HUB.china.huawei.com (unknown [172.30.72.60])
        by Forcepoint Email with ESMTP id BFA2E2378A2746313A8B;
        Fri, 31 Jul 2020 15:43:36 +0800 (CST)
Received: from DESKTOP-FPN2511.china.huawei.com (10.174.187.42) by
 DGGEMS414-HUB.china.huawei.com (10.3.19.214) with Microsoft SMTP Server id
 14.3.487.0; Fri, 31 Jul 2020 15:43:26 +0800
From:   Jingyi Wang <wangjingyi11@huawei.com>
To:     <drjones@redhat.com>, <kvm@vger.kernel.org>,
        <kvmarm@lists.cs.columbia.edu>
CC:     <maz@kernel.org>, <wanghaibin.wang@huawei.com>,
        <yuzenghui@huawei.com>, <eric.auger@redhat.com>,
        <wangjingyi11@huawei.com>, <prime.zeng@hisilicon.com>
Subject: [kvm-unit-tests PATCH v3 06/10] arm64: microbench: Allow each test to specify its running times
Date:   Fri, 31 Jul 2020 15:42:40 +0800
Message-ID: <20200731074244.20432-7-wangjingyi11@huawei.com>
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

For some test in micro-bench can be time consuming, we add a
micro-bench test parameter to allow each individual test to specify
its running times.

Signed-off-by: Jingyi Wang <wangjingyi11@huawei.com>
Reviewed-by: Eric Auger <eric.auger@redhat.com>
---
 arm/micro-bench.c | 27 ++++++++++++++-------------
 1 file changed, 14 insertions(+), 13 deletions(-)

diff --git a/arm/micro-bench.c b/arm/micro-bench.c
index 82f3c07..93bd855 100644
--- a/arm/micro-bench.c
+++ b/arm/micro-bench.c
@@ -22,8 +22,6 @@
 #include <asm/gic.h>
 #include <asm/gic-v3-its.h>
 
-#define NTIMES (1U << 16)
-
 static u32 cntfrq;
 
 static volatile bool irq_ready, irq_received;
@@ -234,17 +232,18 @@ struct exit_test {
 	const char *name;
 	bool (*prep)(void);
 	void (*exec)(void);
+	u32 times;
 	bool run;
 };
 
 static struct exit_test tests[] = {
-	{"hvc",			NULL,		hvc_exec,		true},
-	{"mmio_read_user",	NULL,		mmio_read_user_exec,	true},
-	{"mmio_read_vgic",	NULL,		mmio_read_vgic_exec,	true},
-	{"eoi",			NULL,		eoi_exec,		true},
-	{"ipi",			ipi_prep,	ipi_exec,		true},
-	{"ipi_hw",		ipi_hw_prep,	ipi_exec,		true},
-	{"lpi",			lpi_prep,	lpi_exec,		true},
+	{"hvc",			NULL,		hvc_exec,		65536,		true},
+	{"mmio_read_user",	NULL,		mmio_read_user_exec,	65536,		true},
+	{"mmio_read_vgic",	NULL,		mmio_read_vgic_exec,	65536,		true},
+	{"eoi",			NULL,		eoi_exec,		65536,		true},
+	{"ipi",			ipi_prep,	ipi_exec,		65536,		true},
+	{"ipi_hw",		ipi_hw_prep,	ipi_exec,		65536,		true},
+	{"lpi",			lpi_prep,	lpi_exec,		65536,		true},
 };
 
 struct ns_time {
@@ -265,7 +264,7 @@ static void ticks_to_ns_time(uint64_t ticks, struct ns_time *ns_time)
 
 static void loop_test(struct exit_test *test)
 {
-	uint64_t start, end, total_ticks, ntimes = NTIMES;
+	uint64_t start, end, total_ticks, ntimes = 0;
 	struct ns_time total_ns, avg_ns;
 
 	if (test->prep) {
@@ -276,15 +275,17 @@ static void loop_test(struct exit_test *test)
 	}
 	isb();
 	start = read_sysreg(cntpct_el0);
-	while (ntimes--)
+	while (ntimes < test->times) {
 		test->exec();
+		ntimes++;
+	}
 	isb();
 	end = read_sysreg(cntpct_el0);
 
 	total_ticks = end - start;
 	ticks_to_ns_time(total_ticks, &total_ns);
-	avg_ns.ns = total_ns.ns / NTIMES;
-	avg_ns.ns_frac = total_ns.ns_frac / NTIMES;
+	avg_ns.ns = total_ns.ns / ntimes;
+	avg_ns.ns_frac = total_ns.ns_frac / ntimes;
 
 	printf("%-30s%15" PRId64 ".%-15" PRId64 "%15" PRId64 ".%-15" PRId64 "\n",
 		test->name, total_ns.ns, total_ns.ns_frac, avg_ns.ns, avg_ns.ns_frac);
-- 
2.19.1


