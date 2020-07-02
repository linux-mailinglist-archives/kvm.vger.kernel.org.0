Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B5B80211A71
	for <lists+kvm@lfdr.de>; Thu,  2 Jul 2020 05:02:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727993AbgGBDCi (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 1 Jul 2020 23:02:38 -0400
Received: from szxga07-in.huawei.com ([45.249.212.35]:47366 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726744AbgGBDCf (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 1 Jul 2020 23:02:35 -0400
Received: from DGGEMS405-HUB.china.huawei.com (unknown [172.30.72.60])
        by Forcepoint Email with ESMTP id 83AE971E83E8796E51E4;
        Thu,  2 Jul 2020 11:02:30 +0800 (CST)
Received: from DESKTOP-FPN2511.china.huawei.com (10.174.187.42) by
 DGGEMS405-HUB.china.huawei.com (10.3.19.205) with Microsoft SMTP Server id
 14.3.487.0; Thu, 2 Jul 2020 11:02:24 +0800
From:   Jingyi Wang <wangjingyi11@huawei.com>
To:     <drjones@redhat.com>, <kvm@vger.kernel.org>,
        <kvmarm@lists.cs.columbia.edu>
CC:     <maz@kernel.org>, <wanghaibin.wang@huawei.com>,
        <yuzenghui@huawei.com>, <eric.auger@redhat.com>,
        <wangjingyi11@huawei.com>
Subject: [kvm-unit-tests PATCH v2 7/8] arm64: microbench: Add time limit for each individual test
Date:   Thu, 2 Jul 2020 11:01:31 +0800
Message-ID: <20200702030132.20252-8-wangjingyi11@huawei.com>
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

Besides using separate running times parameter, we add time limit
for loop_test to make sure each test should be done in a certain
time(5 sec here).

Signed-off-by: Jingyi Wang <wangjingyi11@huawei.com>
---
 arm/micro-bench.c | 17 +++++++++++------
 1 file changed, 11 insertions(+), 6 deletions(-)

diff --git a/arm/micro-bench.c b/arm/micro-bench.c
index 506d2f9..4c962b7 100644
--- a/arm/micro-bench.c
+++ b/arm/micro-bench.c
@@ -23,6 +23,7 @@
 #include <asm/gic-v3-its.h>
 
 #define NTIMES (1U << 16)
+#define MAX_NS (5 * 1000 * 1000 * 1000UL)
 
 static u32 cntfrq;
 
@@ -258,22 +259,26 @@ static void loop_test(struct exit_test *test)
 	uint64_t start, end, total_ticks, ntimes = 0;
 	struct ns_time total_ns, avg_ns;
 
+	total_ticks = 0;
 	if (test->prep) {
 		if(!test->prep()) {
 			printf("%s test skipped\n", test->name);
 			return;
 		}
 	}
-	isb();
-	start = read_sysreg(cntpct_el0);
-	while (ntimes < test->times) {
+
+	while (ntimes < test->times && total_ns.ns < MAX_NS) {
+		isb();
+		start = read_sysreg(cntpct_el0);
 		test->exec();
+		isb();
+		end = read_sysreg(cntpct_el0);
+
 		ntimes++;
+		total_ticks += (end - start);
+		ticks_to_ns_time(total_ticks, &total_ns);
 	}
-	isb();
-	end = read_sysreg(cntpct_el0);
 
-	total_ticks = end - start;
 	ticks_to_ns_time(total_ticks, &total_ns);
 	avg_ns.ns = total_ns.ns / ntimes;
 	avg_ns.ns_frac = total_ns.ns_frac / ntimes;
-- 
2.19.1


