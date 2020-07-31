Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5D0FF23404D
	for <lists+kvm@lfdr.de>; Fri, 31 Jul 2020 09:43:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731761AbgGaHnk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 31 Jul 2020 03:43:40 -0400
Received: from szxga06-in.huawei.com ([45.249.212.32]:34340 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1731747AbgGaHni (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 31 Jul 2020 03:43:38 -0400
Received: from DGGEMS414-HUB.china.huawei.com (unknown [172.30.72.60])
        by Forcepoint Email with ESMTP id B4BA015B9C2EA815E558;
        Fri, 31 Jul 2020 15:43:36 +0800 (CST)
Received: from DESKTOP-FPN2511.china.huawei.com (10.174.187.42) by
 DGGEMS414-HUB.china.huawei.com (10.3.19.214) with Microsoft SMTP Server id
 14.3.487.0; Fri, 31 Jul 2020 15:43:29 +0800
From:   Jingyi Wang <wangjingyi11@huawei.com>
To:     <drjones@redhat.com>, <kvm@vger.kernel.org>,
        <kvmarm@lists.cs.columbia.edu>
CC:     <maz@kernel.org>, <wanghaibin.wang@huawei.com>,
        <yuzenghui@huawei.com>, <eric.auger@redhat.com>,
        <wangjingyi11@huawei.com>, <prime.zeng@hisilicon.com>
Subject: [kvm-unit-tests PATCH v3 10/10] arm64: microbench: Add timer_post() to get actual PPI latency
Date:   Fri, 31 Jul 2020 15:42:44 +0800
Message-ID: <20200731074244.20432-11-wangjingyi11@huawei.com>
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

For we get the time duration of (10msec timer + injection latency)
in timer_exec(), we substract the value of 10msec in timer_post()
to get the actual latency.

Signed-off-by: Jingyi Wang <wangjingyi11@huawei.com>
---
 arm/micro-bench.c | 14 +++++++++++++-
 1 file changed, 13 insertions(+), 1 deletion(-)

diff --git a/arm/micro-bench.c b/arm/micro-bench.c
index 4680ba4..315fc7c 100644
--- a/arm/micro-bench.c
+++ b/arm/micro-bench.c
@@ -254,6 +254,18 @@ static void timer_exec(void)
 	assert_msg(irq_received, "failed to receive PPI in time, but received %d successfully\n", received);
 }
 
+static void timer_post(uint64_t total_ticks, uint64_t ntimes, struct ns_time *total_ns)
+{
+	/*
+	 * We use a 10msec timer to test the latency of PPI,
+	 * so we substract the ticks of 10msec to get the
+	 * actual latency
+	 */
+
+	total_ticks -= ntimes * (cntfrq / 100);
+	ticks_to_ns_time(total_ticks, total_ns);
+}
+
 static void hvc_exec(void)
 {
 	asm volatile("mov w0, #0x4b000000; hvc #0" ::: "w0");
@@ -302,7 +314,7 @@ static struct exit_test tests[] = {
 	{"ipi",			ipi_prep,	ipi_exec,		NULL,		65536,		true},
 	{"ipi_hw",		ipi_hw_prep,	ipi_exec,		NULL,		65536,		true},
 	{"lpi",			lpi_prep,	lpi_exec,		NULL,		65536,		true},
-	{"timer_10ms",		timer_prep,	timer_exec,		NULL,		256,		true},
+	{"timer_10ms",		timer_prep,	timer_exec,		timer_post,	256,		true},
 };
 
 #define PS_PER_SEC (1000 * 1000 * 1000 * 1000UL)
-- 
2.19.1


