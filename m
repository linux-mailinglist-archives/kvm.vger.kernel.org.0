Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 357B5211DD6
	for <lists+kvm@lfdr.de>; Thu,  2 Jul 2020 10:13:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728192AbgGBINx (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 2 Jul 2020 04:13:53 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:51728 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1725379AbgGBINx (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 2 Jul 2020 04:13:53 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1593677631;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=gbJA/RmWRo4DsQRLNHyZabYf9h247N0ChofgtBrHV28=;
        b=ARTn6apRcseLHyGFappwKqsn/aMEnYR5aFZoAHyUNOAM8EqHrRNHEBeyaU6k7anzJqokNM
        OzDWUG1RtTBzOnB+J3sZVvD0NXs+llJqLgL7AYDkomIjNuuPAUeFlsdiCQvaoTpV2N3+vQ
        NV+1te96w4elwtv57pOLbw+dDwp7OYA=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-186-3c3HQYISMbCahuG9rQWcKw-1; Thu, 02 Jul 2020 04:13:48 -0400
X-MC-Unique: 3c3HQYISMbCahuG9rQWcKw-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 6EF1F185B3B3;
        Thu,  2 Jul 2020 08:12:26 +0000 (UTC)
Received: from kamzik.brq.redhat.com (unknown [10.40.192.87])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 004EB610F2;
        Thu,  2 Jul 2020 08:12:20 +0000 (UTC)
From:   Andrew Jones <drjones@redhat.com>
To:     kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu
Cc:     wangjingyi11@huawei.com, maz@kernel.org,
        wanghaibin.wang@huawei.com, yuzenghui@huawei.com,
        eric.auger@redhat.com
Subject: [PATCH kvm-unit-tests] arm/arm64: timer: Extract irqs at setup time
Date:   Thu,  2 Jul 2020 10:12:19 +0200
Message-Id: <20200702081219.27176-1-drjones@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The timer can be useful for other tests besides the timer test.
Extract the DT parsing of the irqs out of the timer test into
setup and provide them along with some defines in a new timer.h
file.

Signed-off-by: Andrew Jones <drjones@redhat.com>
---
 arm/timer.c           | 26 ++++----------------------
 lib/arm/asm/timer.h   | 31 +++++++++++++++++++++++++++++++
 lib/arm/setup.c       | 42 ++++++++++++++++++++++++++++++++++++++++++
 lib/arm64/asm/timer.h |  1 +
 4 files changed, 78 insertions(+), 22 deletions(-)
 create mode 100644 lib/arm/asm/timer.h
 create mode 100644 lib/arm64/asm/timer.h

diff --git a/arm/timer.c b/arm/timer.c
index 44621b4f2967..09e3f8f6bd7d 100644
--- a/arm/timer.c
+++ b/arm/timer.c
@@ -8,15 +8,12 @@
 #include <libcflat.h>
 #include <devicetree.h>
 #include <errata.h>
+#include <asm/timer.h>
 #include <asm/delay.h>
 #include <asm/processor.h>
 #include <asm/gic.h>
 #include <asm/io.h>
 
-#define ARCH_TIMER_CTL_ENABLE  (1 << 0)
-#define ARCH_TIMER_CTL_IMASK   (1 << 1)
-#define ARCH_TIMER_CTL_ISTATUS (1 << 2)
-
 static void *gic_isenabler;
 static void *gic_icenabler;
 
@@ -108,7 +105,6 @@ static void write_ptimer_ctl(u64 val)
 
 struct timer_info {
 	u32 irq;
-	u32 irq_flags;
 	volatile bool irq_received;
 	u64 (*read_counter)(void);
 	u64 (*read_cval)(void);
@@ -304,23 +300,9 @@ static void test_ptimer(void)
 
 static void test_init(void)
 {
-	const struct fdt_property *prop;
-	const void *fdt = dt_fdt();
-	int node, len;
-	u32 *data;
-
-	node = fdt_node_offset_by_compatible(fdt, -1, "arm,armv8-timer");
-	assert(node >= 0);
-	prop = fdt_get_property(fdt, node, "interrupts", &len);
-	assert(prop && len == (4 * 3 * sizeof(u32)));
-
-	data = (u32 *)prop->data;
-	assert(fdt32_to_cpu(data[3]) == 1);
-	ptimer_info.irq = fdt32_to_cpu(data[4]);
-	ptimer_info.irq_flags = fdt32_to_cpu(data[5]);
-	assert(fdt32_to_cpu(data[6]) == 1);
-	vtimer_info.irq = fdt32_to_cpu(data[7]);
-	vtimer_info.irq_flags = fdt32_to_cpu(data[8]);
+	assert(TIMER_PTIMER_IRQ != -1 && TIMER_VTIMER_IRQ != -1);
+	ptimer_info.irq = TIMER_PTIMER_IRQ;
+	vtimer_info.irq = TIMER_VTIMER_IRQ;
 
 	install_exception_handler(EL1H_SYNC, ESR_EL1_EC_UNKNOWN, ptimer_unsupported_handler);
 	ptimer_info.read_ctl();
diff --git a/lib/arm/asm/timer.h b/lib/arm/asm/timer.h
new file mode 100644
index 000000000000..f75cc67f3ac4
--- /dev/null
+++ b/lib/arm/asm/timer.h
@@ -0,0 +1,31 @@
+/*
+ * Copyright (C) 2020, Red Hat Inc, Andrew Jones <drjones@redhat.com>
+ *
+ * This work is licensed under the terms of the GNU LGPL, version 2.
+ */
+#ifndef _ASMARM_TIMER_H_
+#define _ASMARM_TIMER_H_
+
+#define ARCH_TIMER_CTL_ENABLE  (1 << 0)
+#define ARCH_TIMER_CTL_IMASK   (1 << 1)
+#define ARCH_TIMER_CTL_ISTATUS (1 << 2)
+
+#ifndef __ASSEMBLY__
+
+struct timer_state {
+	struct {
+		u32 irq;
+		u32 irq_flags;
+	} ptimer;
+	struct {
+		u32 irq;
+		u32 irq_flags;
+	} vtimer;
+};
+extern struct timer_state __timer_state;
+
+#define TIMER_PTIMER_IRQ (__timer_state.ptimer.irq)
+#define TIMER_VTIMER_IRQ (__timer_state.vtimer.irq)
+
+#endif /* !__ASSEMBLY__ */
+#endif /* _ASMARM_TIMER_H_ */
diff --git a/lib/arm/setup.c b/lib/arm/setup.c
index 418b4e58a5f8..78562e47c01c 100644
--- a/lib/arm/setup.c
+++ b/lib/arm/setup.c
@@ -22,6 +22,7 @@
 #include <asm/page.h>
 #include <asm/processor.h>
 #include <asm/smp.h>
+#include <asm/timer.h>
 
 #include "io.h"
 
@@ -29,6 +30,8 @@
 
 extern unsigned long stacktop;
 
+struct timer_state __timer_state;
+
 char *initrd;
 u32 initrd_size;
 
@@ -156,6 +159,43 @@ static void mem_init(phys_addr_t freemem_start)
 	page_alloc_ops_enable();
 }
 
+static void timer_save_state(void)
+{
+	const struct fdt_property *prop;
+	const void *fdt = dt_fdt();
+	int node, len;
+	u32 *data;
+
+	node = fdt_node_offset_by_compatible(fdt, -1, "arm,armv8-timer");
+	assert(node >= 0 || node == -FDT_ERR_NOTFOUND);
+
+	if (node == -FDT_ERR_NOTFOUND) {
+		__timer_state.ptimer.irq = -1;
+		__timer_state.vtimer.irq = -1;
+		return;
+	}
+
+	/*
+	 * From Linux devicetree timer binding documentation
+	 *
+	 * interrupts <type irq flags>:
+	 *	secure timer irq
+	 *	non-secure timer irq		(ptimer)
+	 *	virtual timer irq		(vtimer)
+	 *	hypervisor timer irq
+	 */
+	prop = fdt_get_property(fdt, node, "interrupts", &len);
+	assert(prop && len == (4 * 3 * sizeof(u32)));
+
+	data = (u32 *)prop->data;
+	assert(fdt32_to_cpu(data[3]) == 1 /* PPI */);
+	__timer_state.ptimer.irq = fdt32_to_cpu(data[4]);
+	__timer_state.ptimer.irq_flags = fdt32_to_cpu(data[5]);
+	assert(fdt32_to_cpu(data[6]) == 1 /* PPI */);
+	__timer_state.vtimer.irq = fdt32_to_cpu(data[7]);
+	__timer_state.vtimer.irq_flags = fdt32_to_cpu(data[8]);
+}
+
 void setup(const void *fdt)
 {
 	void *freemem = &stacktop;
@@ -211,6 +251,8 @@ void setup(const void *fdt)
 	io_init();
 
 	/* finish setup */
+	timer_save_state();
+
 	ret = dt_get_bootargs(&bootargs);
 	assert(ret == 0 || ret == -FDT_ERR_NOTFOUND);
 	setup_args_progname(bootargs);
diff --git a/lib/arm64/asm/timer.h b/lib/arm64/asm/timer.h
new file mode 100644
index 000000000000..c0f5f88287de
--- /dev/null
+++ b/lib/arm64/asm/timer.h
@@ -0,0 +1 @@
+#include "../../arm/asm/timer.h"
-- 
2.25.4

