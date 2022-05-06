Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6297B51E07C
	for <lists+kvm@lfdr.de>; Fri,  6 May 2022 22:57:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1444262AbiEFVAs (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 6 May 2022 17:00:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52884 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1444177AbiEFVAq (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 6 May 2022 17:00:46 -0400
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id CE40B6A064
        for <kvm@vger.kernel.org>; Fri,  6 May 2022 13:57:01 -0700 (PDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id A92C7152B;
        Fri,  6 May 2022 13:57:01 -0700 (PDT)
Received: from godel.lab.cambridge.arm.com (godel.lab.cambridge.arm.com [10.7.66.42])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id D39283F800;
        Fri,  6 May 2022 13:57:00 -0700 (PDT)
From:   Nikos Nikoleris <nikos.nikoleris@arm.com>
To:     kvm@vger.kernel.org
Cc:     drjones@redhat.com, pbonzini@redhat.com, jade.alglave@arm.com,
        alexandru.elisei@arm.com
Subject: [kvm-unit-tests PATCH v2 07/23] arm/arm64: Add support for timer initialization through ACPI
Date:   Fri,  6 May 2022 21:55:49 +0100
Message-Id: <20220506205605.359830-8-nikos.nikoleris@arm.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220506205605.359830-1-nikos.nikoleris@arm.com>
References: <20220506205605.359830-1-nikos.nikoleris@arm.com>
MIME-Version: 1.0
X-ARM-No-Footer: FoSSMail
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-6.9 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

For systems with ACPI support, we can discover timers through the ACPI
GTDT table. This change implements the code to discover timers through
the GTDT and adds ACPI support in timer_save_state. This change
retains the default behavior; we check if a valid DT is provided, if
not, we try to discover timers using ACPI.

Signed-off-by: Nikos Nikoleris <nikos.nikoleris@arm.com>
---
 arm/Makefile.common |  1 +
 lib/arm/asm/timer.h |  2 ++
 lib/acpi.h          | 18 +++++++++++
 lib/arm/setup.c     | 39 ------------------------
 lib/arm/timer.c     | 73 +++++++++++++++++++++++++++++++++++++++++++++
 5 files changed, 94 insertions(+), 39 deletions(-)
 create mode 100644 lib/arm/timer.c

diff --git a/arm/Makefile.common b/arm/Makefile.common
index 8e9b3bb..5be42c0 100644
--- a/arm/Makefile.common
+++ b/arm/Makefile.common
@@ -53,6 +53,7 @@ cflatobjs += lib/arm/psci.o
 cflatobjs += lib/arm/smp.o
 cflatobjs += lib/arm/delay.o
 cflatobjs += lib/arm/gic.o lib/arm/gic-v2.o lib/arm/gic-v3.o
+cflatobjs += lib/arm/timer.o
 
 OBJDIRS += lib/arm
 
diff --git a/lib/arm/asm/timer.h b/lib/arm/asm/timer.h
index f75cc67..aaf839f 100644
--- a/lib/arm/asm/timer.h
+++ b/lib/arm/asm/timer.h
@@ -27,5 +27,7 @@ extern struct timer_state __timer_state;
 #define TIMER_PTIMER_IRQ (__timer_state.ptimer.irq)
 #define TIMER_VTIMER_IRQ (__timer_state.vtimer.irq)
 
+void timer_save_state(void);
+
 #endif /* !__ASSEMBLY__ */
 #endif /* _ASMARM_TIMER_H_ */
diff --git a/lib/acpi.h b/lib/acpi.h
index 5213299..297ad87 100644
--- a/lib/acpi.h
+++ b/lib/acpi.h
@@ -17,6 +17,7 @@
 #define FACP_SIGNATURE ACPI_SIGNATURE('F','A','C','P')
 #define FACS_SIGNATURE ACPI_SIGNATURE('F','A','C','S')
 #define SPCR_SIGNATURE ACPI_SIGNATURE('S','P','C','R')
+#define GTDT_SIGNATURE ACPI_SIGNATURE('G','T','D','T')
 
 
 #define ACPI_SIGNATURE_8BYTE(c1, c2, c3, c4, c5, c6, c7, c8) \
@@ -172,6 +173,23 @@ struct spcr_descriptor {
     u32 reserved2;
 } __attribute__ ((packed));
 
+struct acpi_table_gtdt {
+    ACPI_TABLE_HEADER_DEF   /* ACPI common table header */
+    u64 counter_block_addresss;
+    u32 reserved;
+    u32 secure_el1_interrupt;
+    u32 secure_el1_flags;
+    u32 non_secure_el1_interrupt;
+    u32 non_secure_el1_flags;
+    u32 virtual_timer_interrupt;
+    u32 virtual_timer_flags;
+    u32 non_secure_el2_interrupt;
+    u32 non_secure_el2_flags;
+    u64 counter_read_block_address;
+    u32 platform_timer_count;
+    u32 platform_timer_offset;
+} __attribute__ ((packed));
+
 void set_efi_rsdp(struct rsdp_descriptor *rsdp);
 void* find_acpi_table_addr(u32 sig);
 
diff --git a/lib/arm/setup.c b/lib/arm/setup.c
index bcdf0d7..1572c64 100644
--- a/lib/arm/setup.c
+++ b/lib/arm/setup.c
@@ -35,8 +35,6 @@
 
 extern unsigned long etext;
 
-struct timer_state __timer_state;
-
 char *initrd;
 u32 initrd_size;
 
@@ -199,43 +197,6 @@ static void mem_init(phys_addr_t freemem_start)
 	page_alloc_ops_enable();
 }
 
-static void timer_save_state(void)
-{
-	const struct fdt_property *prop;
-	const void *fdt = dt_fdt();
-	int node, len;
-	u32 *data;
-
-	node = fdt_node_offset_by_compatible(fdt, -1, "arm,armv8-timer");
-	assert(node >= 0 || node == -FDT_ERR_NOTFOUND);
-
-	if (node == -FDT_ERR_NOTFOUND) {
-		__timer_state.ptimer.irq = -1;
-		__timer_state.vtimer.irq = -1;
-		return;
-	}
-
-	/*
-	 * From Linux devicetree timer binding documentation
-	 *
-	 * interrupts <type irq flags>:
-	 *	secure timer irq
-	 *	non-secure timer irq		(ptimer)
-	 *	virtual timer irq		(vtimer)
-	 *	hypervisor timer irq
-	 */
-	prop = fdt_get_property(fdt, node, "interrupts", &len);
-	assert(prop && len == (4 * 3 * sizeof(u32)));
-
-	data = (u32 *)prop->data;
-	assert(fdt32_to_cpu(data[3]) == 1 /* PPI */);
-	__timer_state.ptimer.irq = fdt32_to_cpu(data[4]);
-	__timer_state.ptimer.irq_flags = fdt32_to_cpu(data[5]);
-	assert(fdt32_to_cpu(data[6]) == 1 /* PPI */);
-	__timer_state.vtimer.irq = fdt32_to_cpu(data[7]);
-	__timer_state.vtimer.irq_flags = fdt32_to_cpu(data[8]);
-}
-
 void setup(const void *fdt, phys_addr_t freemem_start)
 {
 	void *freemem;
diff --git a/lib/arm/timer.c b/lib/arm/timer.c
new file mode 100644
index 0000000..eceabdf
--- /dev/null
+++ b/lib/arm/timer.c
@@ -0,0 +1,73 @@
+/*
+ * Initialize timers.
+ *
+ * Copyright (C) 2022, Arm Ltd., Nikos Nikoleris <nikos.nikoleris@arm.com>
+ * Copyright (C) 2014, Red Hat Inc, Andrew Jones <drjones@redhat.com>
+ *
+ * This work is licensed under the terms of the GNU LGPL, version 2.
+ */
+#include <libcflat.h>
+#include <asm/timer.h>
+
+#include <acpi.h>
+#include <devicetree.h>
+#include <libfdt/libfdt.h>
+
+struct timer_state __timer_state;
+
+static void timer_save_state_fdt(void)
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
+static void timer_save_state_acpi(void)
+{
+	struct acpi_table_gtdt *gtdt = find_acpi_table_addr(GTDT_SIGNATURE);
+
+	assert_msg(gtdt, "Unable to find ACPI GTDT");
+	__timer_state.ptimer.irq = gtdt->non_secure_el1_interrupt;
+	__timer_state.ptimer.irq_flags = gtdt->non_secure_el1_flags;
+
+	__timer_state.vtimer.irq = gtdt->virtual_timer_interrupt;
+	__timer_state.vtimer.irq_flags = gtdt->virtual_timer_flags;
+}
+
+void timer_save_state(void)
+{
+	if (dt_available())
+		timer_save_state_fdt();
+	else
+		timer_save_state_acpi();
+}
-- 
2.25.1

