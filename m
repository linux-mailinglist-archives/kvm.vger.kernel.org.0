Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DA2FA561721
	for <lists+kvm@lfdr.de>; Thu, 30 Jun 2022 12:05:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234725AbiF3KEF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 30 Jun 2022 06:04:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39134 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234710AbiF3KEB (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 30 Jun 2022 06:04:01 -0400
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 45E942B278
        for <kvm@vger.kernel.org>; Thu, 30 Jun 2022 03:03:59 -0700 (PDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 69B661042;
        Thu, 30 Jun 2022 03:03:59 -0700 (PDT)
Received: from godel.lab.cambridge.arm.com (godel.lab.cambridge.arm.com [10.7.66.42])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 3B51C3F5A1;
        Thu, 30 Jun 2022 03:03:58 -0700 (PDT)
From:   Nikos Nikoleris <nikos.nikoleris@arm.com>
To:     kvm@vger.kernel.org
Cc:     andrew.jones@linux.dev, drjones@redhat.com, pbonzini@redhat.com,
        jade.alglave@arm.com, alexandru.elisei@arm.com, ricarkol@google.com
Subject: [kvm-unit-tests PATCH v3 08/27] arm/arm64: Add support for discovering the UART through ACPI
Date:   Thu, 30 Jun 2022 11:03:05 +0100
Message-Id: <20220630100324.3153655-9-nikos.nikoleris@arm.com>
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

In systems with ACPI support and when a DT is not provided, we can use
the SPCR to discover the serial port address range. This change
implements this but retains the default behavior; we check if a valid
DT is provided, if not, we try to discover the UART using ACPI.

Signed-off-by: Nikos Nikoleris <nikos.nikoleris@arm.com>
Reviewed-by: Andrew Jones <drjones@redhat.com>
Reviewed-by: Ricardo Koller <ricarkol@google.com>
---
 lib/acpi.h   | 25 +++++++++++++++++++++++++
 lib/arm/io.c | 23 ++++++++++++++++++-----
 2 files changed, 43 insertions(+), 5 deletions(-)

diff --git a/lib/acpi.h b/lib/acpi.h
index 6c18f73..1cd99c5 100644
--- a/lib/acpi.h
+++ b/lib/acpi.h
@@ -17,6 +17,7 @@
 #define XSDT_SIGNATURE ACPI_SIGNATURE('X','S','D','T')
 #define FACP_SIGNATURE ACPI_SIGNATURE('F','A','C','P')
 #define FACS_SIGNATURE ACPI_SIGNATURE('F','A','C','S')
+#define SPCR_SIGNATURE ACPI_SIGNATURE('S','P','C','R')
 
 
 #define ACPI_SIGNATURE_8BYTE(c1, c2, c3, c4, c5, c6, c7, c8)	\
@@ -148,6 +149,30 @@ struct facs_descriptor_rev1
 	u8  reserved3 [40];		/* Reserved - must be zero */
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
 #pragma pack(0)
 
 void set_efi_rsdp(struct rsdp_descriptor *rsdp);
diff --git a/lib/arm/io.c b/lib/arm/io.c
index 343e108..a91f116 100644
--- a/lib/arm/io.c
+++ b/lib/arm/io.c
@@ -9,6 +9,7 @@
  * This work is licensed under the terms of the GNU LGPL, version 2.
  */
 #include <libcflat.h>
+#include <acpi.h>
 #include <devicetree.h>
 #include <chr-testdev.h>
 #include <config.h>
@@ -29,7 +30,7 @@ static struct spinlock uart_lock;
 #define UART_EARLY_BASE (u8 *)(unsigned long)CONFIG_UART_EARLY_BASE
 static volatile u8 *uart0_base = UART_EARLY_BASE;
 
-static void uart0_init(void)
+static void uart0_init_fdt(void)
 {
 	/*
 	 * kvm-unit-tests uses the uart only for output. Both uart models have
@@ -65,17 +66,29 @@ static void uart0_init(void)
 	}
 
 	uart0_base = ioremap(base.addr, base.size);
+}
+
+static void uart0_init_acpi(void)
+{
+	struct spcr_descriptor *spcr = find_acpi_table_addr(SPCR_SIGNATURE);
+
+	assert_msg(spcr, "Unable to find ACPI SPCR");
+	uart0_base = ioremap(spcr->serial_port.address, spcr->serial_port.bit_width);
+}
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

