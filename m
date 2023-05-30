Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 807797168D4
	for <lists+kvm@lfdr.de>; Tue, 30 May 2023 18:10:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233302AbjE3QKz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 30 May 2023 12:10:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57054 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233298AbjE3QKw (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 30 May 2023 12:10:52 -0400
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 77F8C1BB
        for <kvm@vger.kernel.org>; Tue, 30 May 2023 09:10:24 -0700 (PDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 379E819F0;
        Tue, 30 May 2023 09:10:52 -0700 (PDT)
Received: from godel.lab.cambridge.arm.com (godel.lab.cambridge.arm.com [10.7.66.42])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id C75303F663;
        Tue, 30 May 2023 09:10:05 -0700 (PDT)
From:   Nikos Nikoleris <nikos.nikoleris@arm.com>
To:     kvm@vger.kernel.org, kvmarm@lists.linux.dev, andrew.jones@linux.dev
Cc:     pbonzini@redhat.com, alexandru.elisei@arm.com, ricarkol@google.com,
        shahuang@redhat.com, Andrew Jones <drjones@redhat.com>
Subject: [kvm-unit-tests PATCH v6 12/32] arm64: Add support for discovering the UART through ACPI
Date:   Tue, 30 May 2023 17:09:04 +0100
Message-Id: <20230530160924.82158-13-nikos.nikoleris@arm.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20230530160924.82158-1-nikos.nikoleris@arm.com>
References: <20230530160924.82158-1-nikos.nikoleris@arm.com>
MIME-Version: 1.0
X-ARM-No-Footer: FoSSMail
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

In systems with ACPI support and when a DT is not provided, we can use
the SPCR to discover the serial port address range. This change
implements this but retains the default behavior; we check if a valid
DT is provided, if not, we try to discover the UART using ACPI.

Signed-off-by: Nikos Nikoleris <nikos.nikoleris@arm.com>
Reviewed-by: Andrew Jones <drjones@redhat.com>
Reviewed-by: Ricardo Koller <ricarkol@google.com>
Reviewed-by: Shaoqin Huang <shahuang@redhat.com>
---
 lib/acpi.h   | 25 +++++++++++++++++++++++++
 lib/arm/io.c | 34 +++++++++++++++++++++++++++++-----
 2 files changed, 54 insertions(+), 5 deletions(-)

diff --git a/lib/acpi.h b/lib/acpi.h
index 1ba4999e..8c4598e8 100644
--- a/lib/acpi.h
+++ b/lib/acpi.h
@@ -17,6 +17,7 @@
 #define XSDT_SIGNATURE ACPI_SIGNATURE('X','S','D','T')
 #define FACP_SIGNATURE ACPI_SIGNATURE('F','A','C','P')
 #define FACS_SIGNATURE ACPI_SIGNATURE('F','A','C','S')
+#define SPCR_SIGNATURE ACPI_SIGNATURE('S','P','C','R')
 
 #define ACPI_SIGNATURE_8BYTE(c1, c2, c3, c4, c5, c6, c7, c8) \
 	(((uint64_t)(ACPI_SIGNATURE(c1, c2, c3, c4))) |	     \
@@ -145,6 +146,30 @@ struct acpi_table_facs_rev1 {
 	u8 reserved3[40];	/* Reserved - must be zero */
 };
 
+struct spcr_descriptor {
+	ACPI_TABLE_HEADER_DEF	/* ACPI common table header */
+	u8 interface_type;	/* 0=full 16550, 1=subset of 16550 */
+	u8 reserved[3];
+	struct acpi_generic_address serial_port;
+	u8 interrupt_type;
+	u8 pc_interrupt;
+	u32 interrupt;
+	u8 baud_rate;
+	u8 parity;
+	u8 stop_bits;
+	u8 flow_control;
+	u8 terminal_type;
+	u8 reserved1;
+	u16 pci_device_id;
+	u16 pci_vendor_id;
+	u8 pci_bus;
+	u8 pci_device;
+	u8 pci_function;
+	u32 pci_flags;
+	u8 pci_segment;
+	u32 reserved2;
+};
+
 /* Reset to default packing */
 #pragma pack()
 
diff --git a/lib/arm/io.c b/lib/arm/io.c
index 343e1082..19f93490 100644
--- a/lib/arm/io.c
+++ b/lib/arm/io.c
@@ -29,7 +29,7 @@ static struct spinlock uart_lock;
 #define UART_EARLY_BASE (u8 *)(unsigned long)CONFIG_UART_EARLY_BASE
 static volatile u8 *uart0_base = UART_EARLY_BASE;
 
-static void uart0_init(void)
+static void uart0_init_fdt(void)
 {
 	/*
 	 * kvm-unit-tests uses the uart only for output. Both uart models have
@@ -65,17 +65,41 @@ static void uart0_init(void)
 	}
 
 	uart0_base = ioremap(base.addr, base.size);
+}
+
+#ifdef CONFIG_EFI
+
+#include <acpi.h>
+
+static void uart0_init_acpi(void)
+{
+	struct spcr_descriptor *spcr = find_acpi_table_addr(SPCR_SIGNATURE);
+
+	assert_msg(spcr, "Unable to find ACPI SPCR");
+	uart0_base = ioremap(spcr->serial_port.address, spcr->serial_port.bit_width);
+}
+#else
+
+static void uart0_init_acpi(void)
+{
+	assert_msg(false, "ACPI not available");
+}
+
+#endif
+
+void io_init(void)
+{
+	if (dt_available())
+		uart0_init_fdt();
+	else
+		uart0_init_acpi();
 
 	if (uart0_base != UART_EARLY_BASE) {
 		printf("WARNING: early print support may not work. "
 		       "Found uart at %p, but early base is %p.\n",
 			uart0_base, UART_EARLY_BASE);
 	}
-}
 
-void io_init(void)
-{
-	uart0_init();
 	chr_testdev_init();
 }
 
-- 
2.25.1

