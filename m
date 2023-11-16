Return-Path: <kvm+bounces-1870-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 685A17EDAFB
	for <lists+kvm@lfdr.de>; Thu, 16 Nov 2023 05:56:24 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 596891C209CD
	for <lists+kvm@lfdr.de>; Thu, 16 Nov 2023 04:56:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BB376C146;
	Thu, 16 Nov 2023 04:56:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dkim=none
X-Original-To: kvm@vger.kernel.org
Received: from zg8tmtyylji0my4xnjqumte4.icoremail.net (zg8tmtyylji0my4xnjqumte4.icoremail.net [162.243.164.118])
	by lindbergh.monkeyblade.net (Postfix) with ESMTP id A30B0DA
	for <kvm@vger.kernel.org>; Wed, 15 Nov 2023 20:56:08 -0800 (PST)
Received: from prodtpl.icoremail.net (unknown [10.12.1.20])
	by hzbj-icmmx-6 (Coremail) with SMTP id AQAAfwDnmAnmoFVlNqkKAA--.3389S2;
	Thu, 16 Nov 2023 12:56:06 +0800 (CST)
Received: from localhost.localdomain (unknown [218.76.62.144])
	by mail (Coremail) with SMTP id AQAAfwD3OMfkoFVlXiQAAA--.133S2;
	Thu, 16 Nov 2023 12:56:04 +0800 (CST)
From: heqiong <heqiong1557@phytium.com.cn>
To: andrew.jones@linux.dev
Cc: alexandru.elisei@arm.com,
	heqiong1557@phytium.com.cn,
	kvm@vger.kernel.org
Subject: [kvm-unit-tests PATCH 1/1] arm64: microbench: Improve measurement accuracy of tests
Date: Thu, 16 Nov 2023 12:53:55 +0800
Message-Id: <20231116045355.2045483-1-heqiong1557@phytium.com.cn>
X-Mailer: git-send-email 2.39.3
In-Reply-To: <20231107-9b361591b5d43284d4394f8a@orel>
References: <20231107-9b361591b5d43284d4394f8a@orel>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:AQAAfwD3OMfkoFVlXiQAAA--.133S2
X-CM-SenderInfo: 5khtx01qjrkkux6sx5pwlxzhxfrphubq/1tbiAQAFD2VVGsIBpQABsG
Authentication-Results: hzbj-icmmx-6; spf=neutral smtp.mail=heqiong155
	7@phytium.com.cn;
X-Coremail-Antispam: 1Uk129KBjvJXoW7uw4fGr1fuFWxWr13uF13twb_yoW8JFyxpr
	Zru3ZIya15Ja4vya4ftFsFyr18tws7Ar4UurWUCayS9r43JayrXr1xK3y5try293s2qr1f
	u3Z5A3WDWrs8u3DanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUj1kv1TuYvTs0mT0YCTnIWj
	DUYxn0WfASr-VFAU7a7-sFnT9fnUUIcSsGvfJ3UbIYCTnIWIevJa73UjIFyTuYvj4RJUUU
	UUUUU

Reducing the impact of the cntvct_el0 register and isb() operation
on microbenchmark test results to improve testing accuracy and reduce
latency in test results.

Signed-off-by: heqiong <heqiong1557@phytium.com.cn>
---
 arm/micro-bench.c | 19 +++++++++++--------
 1 file changed, 11 insertions(+), 8 deletions(-)

diff --git a/arm/micro-bench.c b/arm/micro-bench.c
index fbe59d03..22408955 100644
--- a/arm/micro-bench.c
+++ b/arm/micro-bench.c
@@ -24,7 +24,6 @@
 #include <asm/gic-v3-its.h>
 #include <asm/timer.h>
 
-#define NS_5_SECONDS		(5 * 1000 * 1000 * 1000UL)
 #define QEMU_MMIO_ADDR		0x0a000008
 
 static u32 cntfrq;
@@ -346,17 +345,21 @@ static void loop_test(struct exit_test *test)
 		}
 	}
 
-	while (ntimes < test->times && total_ns.ns < NS_5_SECONDS) {
-		isb();
-		start = read_sysreg(cntvct_el0);
+	dsb(ish);
+	isb();
+	start = read_sysreg(cntvct_el0);
+	isb();
+	while (ntimes < test->times) {
 		test->exec();
-		isb();
-		end = read_sysreg(cntvct_el0);
 
 		ntimes++;
-		total_ticks += (end - start);
-		ticks_to_ns_time(total_ticks, &total_ns);
 	}
+	dsb(ish);
+	isb();
+	end = read_sysreg(cntvct_el0);
+
+	total_ticks = end - start;
+	ticks_to_ns_time(total_ticks, &total_ns);
 
 	if (test->post) {
 		test->post(ntimes, &total_ticks);
-- 
2.39.3


