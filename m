Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A778D561731
	for <lists+kvm@lfdr.de>; Thu, 30 Jun 2022 12:05:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234730AbiF3KEF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 30 Jun 2022 06:04:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39184 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234720AbiF3KEC (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 30 Jun 2022 06:04:02 -0400
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 79D494338E
        for <kvm@vger.kernel.org>; Thu, 30 Jun 2022 03:04:00 -0700 (PDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 8C8EB1BF7;
        Thu, 30 Jun 2022 03:04:00 -0700 (PDT)
Received: from godel.lab.cambridge.arm.com (godel.lab.cambridge.arm.com [10.7.66.42])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 5EC723F5A1;
        Thu, 30 Jun 2022 03:03:59 -0700 (PDT)
From:   Nikos Nikoleris <nikos.nikoleris@arm.com>
To:     kvm@vger.kernel.org
Cc:     andrew.jones@linux.dev, drjones@redhat.com, pbonzini@redhat.com,
        jade.alglave@arm.com, alexandru.elisei@arm.com, ricarkol@google.com
Subject: [kvm-unit-tests PATCH v3 09/27] arm/arm64: Add support for timer initialization through ACPI
Date:   Thu, 30 Jun 2022 11:03:06 +0100
Message-Id: <20220630100324.3153655-10-nikos.nikoleris@arm.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220630100324.3153655-1-nikos.nikoleris@arm.com>
References: <20220630100324.3153655-1-nikos.nikoleris@arm.com>
MIME-Version: 1.0
X-ARM-No-Footer: FoSSMail
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-6.9 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
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
Reviewed-by: Andrew Jones <drjones@redhat.com>
---
 arm/Makefile.common |  1 +
 lib/arm/asm/timer.h |  2 ++
 lib/acpi.h          | 18 +++++++++++
 lib/arm/setup.c     | 39 ----------------------
 lib/arm/timer.c     | 79 +++++++++++++++++++++++++++++++++++++++++++++
 arm/micro-bench.c   |  4 +--
 arm/timer.c         | 10 +++---
 7 files changed, 107 insertions(+), 46 deletions(-)
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
index 1cd99c5..9910c39 100644
--- a/lib/acpi.h
+++ b/lib/acpi.h
@@ -18,6 +18,7 @@
 #define FACP_SIGNATURE ACPI_SIGNATURE('F','A','C','P')
 #define FACS_SIGNATURE ACPI_SIGNATURE('F','A','C','S')
 #define SPCR_SIGNATURE ACPI_SIGNATURE('S','P','C','R')
+#define GTDT_SIGNATURE ACPI_SIGNATURE('G','T','D','T')
 
 
 #define ACPI_SIGNATURE_8BYTE(c1, c2, c3, c4, c5, c6, c7, c8)	\
@@ -173,6 +174,23 @@ struct spcr_descriptor {
 	u32 reserved2;
 };
 
+struct acpi_table_gtdt {
+	ACPI_TABLE_HEADER_DEF	/* ACPI common table header */
+	u64 counter_block_addresss;
+	u32 reserved;
+	u32 secure_el1_interrupt;
+	u32 secure_el1_flags;
+	u32 non_secure_el1_interrupt;
+	u32 non_secure_el1_flags;
+	u32 virtual_timer_interrupt;
+	u32 virtual_timer_flags;
+	u32 non_secure_el2_interrupt;
+	u32 non_secure_el2_flags;
+	u64 counter_read_block_address;
+	u32 platform_timer_count;
+	u32 platform_timer_offset;
+};
+
 #pragma pack(0)
 
 void set_efi_rsdp(struct rsdp_descriptor *rsdp);
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
index 0000000..507d9c8
--- /dev/null
+++ b/lib/arm/timer.c
@@ -0,0 +1,79 @@
+/*
+ * Initialize timers.
+ *
+ * Copyright (C) 2022, Arm Ltd., Nikos Nikoleris <nikos.nikoleris@arm.com>
+ * Copyright (C) 2014, Red Hat Inc, Andrew Jones <drjones@redhat.com>
+ *
+ * This work is licensed under the terms of the GNU LGPL, version 2.
+ */
+#include <libcflat.h>
+#include <acpi.h>
+#include <devicetree.h>
+#include <libfdt/libfdt.h>
+#include <asm/gic.h>
+#include <asm/timer.h>
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
+	__timer_state.ptimer.irq = PPI(fdt32_to_cpu(data[4]));
+	__timer_state.ptimer.irq_flags = fdt32_to_cpu(data[5]);
+	assert(fdt32_to_cpu(data[6]) == 1 /* PPI */);
+	__timer_state.vtimer.irq = PPI(fdt32_to_cpu(data[7]));
+	__timer_state.vtimer.irq_flags = fdt32_to_cpu(data[8]);
+}
+
+static void timer_save_state_acpi(void)
+{
+	struct acpi_table_gtdt *gtdt = find_acpi_table_addr(GTDT_SIGNATURE);
+
+	if (!gtdt) {
+		printf("Cannot find ACPI GTDT");
+		__timer_state.ptimer.irq = -1;
+		__timer_state.vtimer.irq = -1;
+		return;
+	}
+
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
diff --git a/arm/micro-bench.c b/arm/micro-bench.c
index 8436612..5be9b18 100644
--- a/arm/micro-bench.c
+++ b/arm/micro-bench.c
@@ -43,7 +43,7 @@ static void gic_irq_handler(struct pt_regs *regs)
 	irq_received = true;
 	gic_write_eoir(irqstat);
 
-	if (irqstat == PPI(TIMER_VTIMER_IRQ)) {
+	if (irqstat == TIMER_VTIMER_IRQ) {
 		write_sysreg((ARCH_TIMER_CTL_IMASK | ARCH_TIMER_CTL_ENABLE),
 			     cntv_ctl_el0);
 		isb();
@@ -229,7 +229,7 @@ static bool timer_prep(void)
 		assert_msg(0, "Unreachable");
 	}
 
-	writel(1 << PPI(TIMER_VTIMER_IRQ), gic_isenabler);
+	writel(1 << TIMER_VTIMER_IRQ, gic_isenabler);
 	write_sysreg(ARCH_TIMER_CTL_IMASK | ARCH_TIMER_CTL_ENABLE, cntv_ctl_el0);
 	isb();
 
diff --git a/arm/timer.c b/arm/timer.c
index c4e7b10..a4a8281 100644
--- a/arm/timer.c
+++ b/arm/timer.c
@@ -139,7 +139,7 @@ static struct timer_info ptimer_info = {
 
 static void set_timer_irq_enabled(struct timer_info *info, bool enabled)
 {
-	u32 val = 1 << PPI(info->irq);
+	u32 val = 1 << info->irq;
 
 	if (enabled)
 		writel(val, gic_isenabler);
@@ -153,9 +153,9 @@ static void irq_handler(struct pt_regs *regs)
 	u32 irqstat = gic_read_iar();
 	u32 irqnr = gic_iar_irqnr(irqstat);
 
-	if (irqnr == PPI(vtimer_info.irq)) {
+	if (irqnr == vtimer_info.irq) {
 		info = &vtimer_info;
-	} else if (irqnr == PPI(ptimer_info.irq)) {
+	} else if (irqnr == ptimer_info.irq) {
 		info = &ptimer_info;
 	} else {
 		if (irqnr != GICC_INT_SPURIOUS)
@@ -185,9 +185,9 @@ static bool gic_timer_check_state(struct timer_info *info,
 	/* Wait for up to 1s for the GIC to sample the interrupt. */
 	for (i = 0; i < 10; i++) {
 		mdelay(100);
-		if (gic_irq_state(PPI(info->irq)) == expected_state) {
+		if (gic_irq_state(info->irq) == expected_state) {
 			mdelay(100);
-			if (gic_irq_state(PPI(info->irq)) == expected_state)
+			if (gic_irq_state(info->irq) == expected_state)
 				return true;
 		}
 	}
-- 
2.25.1

