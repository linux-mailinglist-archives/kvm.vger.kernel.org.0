Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5BF4E234052
	for <lists+kvm@lfdr.de>; Fri, 31 Jul 2020 09:43:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731769AbgGaHnr (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 31 Jul 2020 03:43:47 -0400
Received: from szxga06-in.huawei.com ([45.249.212.32]:34422 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1731774AbgGaHnl (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 31 Jul 2020 03:43:41 -0400
Received: from DGGEMS414-HUB.china.huawei.com (unknown [172.30.72.60])
        by Forcepoint Email with ESMTP id C5525B7A01AD3F83687B;
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
Subject: [kvm-unit-tests PATCH v3 05/10] arm64: microbench: its: Add LPI latency test
Date:   Fri, 31 Jul 2020 15:42:39 +0800
Message-ID: <20200731074244.20432-6-wangjingyi11@huawei.com>
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

Triggers LPIs through the INT command and test the latency.
Mostly inherited form commit 0ef02cd6cbaa(arm/arm64: ITS: INT
functional tests).

Signed-off-by: Jingyi Wang <wangjingyi11@huawei.com>
Reviewed-by: Eric Auger <eric.auger@redhat.com>
---
 arm/micro-bench.c | 44 ++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 44 insertions(+)

diff --git a/arm/micro-bench.c b/arm/micro-bench.c
index f8314db..82f3c07 100644
--- a/arm/micro-bench.c
+++ b/arm/micro-bench.c
@@ -20,6 +20,7 @@
  */
 #include <libcflat.h>
 #include <asm/gic.h>
+#include <asm/gic-v3-its.h>
 
 #define NTIMES (1U << 16)
 
@@ -156,6 +157,48 @@ static void ipi_exec(void)
 	assert_msg(irq_received, "failed to receive IPI in time, but received %d successfully\n", nr_ipi_received);
 }
 
+static bool lpi_prep(void)
+{
+	struct its_collection *col1;
+	struct its_device *dev2;
+
+	if (!gicv3_its_base())
+		return false;
+
+	its_enable_defaults();
+	dev2 = its_create_device(2 /* dev id */, 8 /* nb_ites */);
+	col1 = its_create_collection(1 /* col id */, 1 /* target PE */);
+	gicv3_lpi_set_config(8199, LPI_PROP_DEFAULT);
+
+	its_send_mapd_nv(dev2, true);
+	its_send_mapc_nv(col1, true);
+	its_send_invall_nv(col1);
+	its_send_mapti_nv(dev2, 8199 /* lpi id */, 20 /* event id */, col1);
+
+	gic_prep_common();
+	return true;
+}
+
+static void lpi_exec(void)
+{
+	struct its_device *dev2;
+	unsigned tries = 1 << 28;
+	static int received = 0;
+
+	irq_received = false;
+
+	dev2 = its_get_device(2);
+	its_send_int_nv(dev2, 20);
+
+	while (!irq_received && tries--)
+		cpu_relax();
+
+	if (irq_received)
+		++received;
+
+	assert_msg(irq_received, "failed to receive LPI in time, but received %d successfully\n", received);
+}
+
 static void hvc_exec(void)
 {
 	asm volatile("mov w0, #0x4b000000; hvc #0" ::: "w0");
@@ -201,6 +244,7 @@ static struct exit_test tests[] = {
 	{"eoi",			NULL,		eoi_exec,		true},
 	{"ipi",			ipi_prep,	ipi_exec,		true},
 	{"ipi_hw",		ipi_hw_prep,	ipi_exec,		true},
+	{"lpi",			lpi_prep,	lpi_exec,		true},
 };
 
 struct ns_time {
-- 
2.19.1


