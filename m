Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4FDA3211A76
	for <lists+kvm@lfdr.de>; Thu,  2 Jul 2020 05:02:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728096AbgGBDCp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 1 Jul 2020 23:02:45 -0400
Received: from szxga07-in.huawei.com ([45.249.212.35]:47192 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725805AbgGBDCd (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 1 Jul 2020 23:02:33 -0400
Received: from DGGEMS405-HUB.china.huawei.com (unknown [172.30.72.60])
        by Forcepoint Email with ESMTP id 6708DC55B26981E027C7;
        Thu,  2 Jul 2020 11:02:30 +0800 (CST)
Received: from DESKTOP-FPN2511.china.huawei.com (10.174.187.42) by
 DGGEMS405-HUB.china.huawei.com (10.3.19.205) with Microsoft SMTP Server id
 14.3.487.0; Thu, 2 Jul 2020 11:02:23 +0800
From:   Jingyi Wang <wangjingyi11@huawei.com>
To:     <drjones@redhat.com>, <kvm@vger.kernel.org>,
        <kvmarm@lists.cs.columbia.edu>
CC:     <maz@kernel.org>, <wanghaibin.wang@huawei.com>,
        <yuzenghui@huawei.com>, <eric.auger@redhat.com>,
        <wangjingyi11@huawei.com>
Subject: [kvm-unit-tests PATCH v2 6/8] arm64: microbench: Allow each test to specify its running times
Date:   Thu, 2 Jul 2020 11:01:30 +0800
Message-ID: <20200702030132.20252-7-wangjingyi11@huawei.com>
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

For some test in micro-bench can be time consuming, we add a
micro-bench test parameter to allow each individual test to specify
its running times.

Signed-off-by: Jingyi Wang <wangjingyi11@huawei.com>
---
 arm/micro-bench.c | 25 ++++++++++++++-----------
 1 file changed, 14 insertions(+), 11 deletions(-)

diff --git a/arm/micro-bench.c b/arm/micro-bench.c
index aeb60a7..506d2f9 100644
--- a/arm/micro-bench.c
+++ b/arm/micro-bench.c
@@ -223,17 +223,18 @@ struct exit_test {
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
+	{"hvc",			NULL,		hvc_exec,		NTIMES,		true},
+	{"mmio_read_user",	NULL,		mmio_read_user_exec,	NTIMES,		true},
+	{"mmio_read_vgic",	NULL,		mmio_read_vgic_exec,	NTIMES,		true},
+	{"eoi",			NULL,		eoi_exec,		NTIMES,		true},
+	{"ipi",			ipi_prep,	ipi_exec,		NTIMES,		true},
+	{"ipi_hw",		ipi_hw_prep,	ipi_exec,		NTIMES,		true},
+	{"lpi",			lpi_prep,	lpi_exec,		NTIMES,		true},
 };
 
 struct ns_time {
@@ -254,7 +255,7 @@ static void ticks_to_ns_time(uint64_t ticks, struct ns_time *ns_time)
 
 static void loop_test(struct exit_test *test)
 {
-	uint64_t start, end, total_ticks, ntimes = NTIMES;
+	uint64_t start, end, total_ticks, ntimes = 0;
 	struct ns_time total_ns, avg_ns;
 
 	if (test->prep) {
@@ -265,15 +266,17 @@ static void loop_test(struct exit_test *test)
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


