Return-Path: <kvm+bounces-832-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 6F8E77E3551
	for <lists+kvm@lfdr.de>; Tue,  7 Nov 2023 07:40:45 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 9FC881C20A8D
	for <lists+kvm@lfdr.de>; Tue,  7 Nov 2023 06:40:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3C3CFBA3B;
	Tue,  7 Nov 2023 06:40:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dkim=none
X-Original-To: kvm@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B556317F0
	for <kvm@vger.kernel.org>; Tue,  7 Nov 2023 06:40:35 +0000 (UTC)
Received: from zg8tmja5ljk3lje4ms43mwaa.icoremail.net (zg8tmja5ljk3lje4ms43mwaa.icoremail.net [209.97.181.73])
	by lindbergh.monkeyblade.net (Postfix) with ESMTP id 3C06810D
	for <kvm@vger.kernel.org>; Mon,  6 Nov 2023 22:40:31 -0800 (PST)
Received: from prodtpl.icoremail.net (unknown [10.12.1.20])
	by hzbj-icmmx-6 (Coremail) with SMTP id AQAAfwCnIpXN20llS+5xBQ--.48515S2;
	Tue, 07 Nov 2023 14:40:13 +0800 (CST)
Received: from localhost.localdomain (unknown [218.76.62.144])
	by mail (Coremail) with SMTP id AQAAfwCXsN3L20llUlQAAA--.347S2;
	Tue, 07 Nov 2023 14:40:11 +0800 (CST)
From: heqiong <heqiong1557@phytium.com.cn>
To: kvm@vger.kernel.org
Cc: alexandru.elisei@arm.com,
	heqiong <heqiong1557@phytium.com.cn>
Subject: [kvm-unit-tests 1/1] arm64: microbench: Move the read of the count register and the ISB operation out of the while loop
Date: Tue,  7 Nov 2023 14:40:06 +0800
Message-Id: <20231107064007.958944-1-heqiong1557@phytium.com.cn>
X-Mailer: git-send-email 2.39.3
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:AQAAfwCXsN3L20llUlQAAA--.347S2
X-CM-SenderInfo: 5khtx01qjrkkux6sx5pwlxzhxfrphubq/1tbiAQALD2VCqasGpwABsA
Authentication-Results: hzbj-icmmx-6; spf=neutral smtp.mail=heqiong155
	7@phytium.com.cn;
X-Coremail-Antispam: 1Uk129KBjvdXoWrtrWUGrW5tr1fAFyxtw18Zrb_yoWDWFX_W3
	WSyasrKry8Zrs0vF1DA3ZxJr4Dta1UWF1fWryIgFZ3GrW2gryrXr1vgry5XF9aqa1DJFWS
	yrW7Jw1rG34SqjkaLaAFLSUrUUUUjb8apTn2vfkv8UJUUUU8wcxFpf9Il3svdxBIdaVrnU
	Uv73VFW2AGmfu7jjvjm3AaLaJ3UjIYCTnIWjDUYxBIdaVFxhVjvjDU0xZFpf9x0zRUUUUU
	UUUU=

Reducing the impact of the cntvct_el0 register and isb() operation
on microbenchmark test results to improve testing accuracy and reduce
latency in test results.
---
 arm/micro-bench.c | 16 ++++++++++------
 1 file changed, 10 insertions(+), 6 deletions(-)

diff --git a/arm/micro-bench.c b/arm/micro-bench.c
index fbe59d03..6b940d56 100644
--- a/arm/micro-bench.c
+++ b/arm/micro-bench.c
@@ -346,17 +346,21 @@ static void loop_test(struct exit_test *test)
 		}
 	}
 
+	dsb(ish);
+	isb();
+	start = read_sysreg(cntpct_el0);
+	isb();
 	while (ntimes < test->times && total_ns.ns < NS_5_SECONDS) {
-		isb();
-		start = read_sysreg(cntvct_el0);
 		test->exec();
-		isb();
-		end = read_sysreg(cntvct_el0);
 
 		ntimes++;
-		total_ticks += (end - start);
-		ticks_to_ns_time(total_ticks, &total_ns);
 	}
+	dsb(ish);
+	isb();
+	end = read_sysreg(cntpct_el0);
+
+	total_ticks = end - start;
+	ticks_to_ns_time(total_ticks, &total_ns);
 
 	if (test->post) {
 		test->post(ntimes, &total_ticks);
-- 
2.31.1


