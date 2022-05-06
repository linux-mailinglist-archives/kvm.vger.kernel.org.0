Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 678D851E077
	for <lists+kvm@lfdr.de>; Fri,  6 May 2022 22:57:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1444243AbiEFVAq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 6 May 2022 17:00:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52870 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1444177AbiEFVAp (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 6 May 2022 17:00:45 -0400
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id D90536EB07
        for <kvm@vger.kernel.org>; Fri,  6 May 2022 13:57:00 -0700 (PDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id AC15814BF;
        Fri,  6 May 2022 13:57:00 -0700 (PDT)
Received: from godel.lab.cambridge.arm.com (godel.lab.cambridge.arm.com [10.7.66.42])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id D68553F800;
        Fri,  6 May 2022 13:56:59 -0700 (PDT)
From:   Nikos Nikoleris <nikos.nikoleris@arm.com>
To:     kvm@vger.kernel.org
Cc:     drjones@redhat.com, pbonzini@redhat.com, jade.alglave@arm.com,
        alexandru.elisei@arm.com
Subject: [kvm-unit-tests PATCH v2 06/23] arm/arm64: Add support for discovering the UART through ACPI
Date:   Fri,  6 May 2022 21:55:48 +0100
Message-Id: <20220506205605.359830-7-nikos.nikoleris@arm.com>
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

In systems with ACPI support and when a DT is not provided, we can use
the SPCR to discover the serial port address range. This change
implements this but retains the default behavior; we check if a valid
DT is provided, if not, we try to discover the UART using ACPI.

Signed-off-by: Nikos Nikoleris <nikos.nikoleris@arm.com>
---
 lib/acpi.h     | 25 +++++++++++++++++++++++++
 lib/arm/io.c   | 21 +++++++++++++++++++--
 lib/arm/psci.c |  4 +++-
 3 files changed, 47 insertions(+), 3 deletions(-)

diff --git a/lib/acpi.h b/lib/acpi.h
index 139ccba..5213299 100644
--- a/lib/acpi.h
+++ b/lib/acpi.h
@@ -16,6 +16,7 @@
 #define XSDT_SIGNATURE ACPI_SIGNATURE('X','S','D','T')
 #define FACP_SIGNATURE ACPI_SIGNATURE('F','A','C','P')
 #define FACS_SIGNATURE ACPI_SIGNATURE('F','A','C','S')
+#define SPCR_SIGNATURE ACPI_SIGNATURE('S','P','C','R')
 
 
 #define ACPI_SIGNATURE_8BYTE(c1, c2, c3, c4, c5, c6, c7, c8) \
@@ -147,6 +148,30 @@ struct facs_descriptor_rev1
     u8  reserved3 [40];         /* Reserved - must be zero */
 } __attribute__ ((packed));
 
+struct spcr_descriptor {
+    ACPI_TABLE_HEADER_DEF   /* ACPI common table header */
+    u8 interface_type;      /* 0=full 16550, 1=subset of 16550 */
+    u8 reserved[3];
+    struct acpi_generic_address serial_port;
+    u8 interrupt_type;
+    u8 pc_interrupt;
+    u32 interrupt;
+    u8 baud_rate;
+    u8 parity;
+    u8 stop_bits;
+    u8 flow_control;
+    u8 terminal_type;
+    u8 reserved1;
+    u16 pci_device_id;
+    u16 pci_vendor_id;
+    u8 pci_bus;
+    u8 pci_device;
+    u8 pci_function;
+    u32 pci_flags;
+    u8 pci_segment;
+    u32 reserved2;
+} __attribute__ ((packed));
+
 void set_efi_rsdp(struct rsdp_descriptor *rsdp);
 void* find_acpi_table_addr(u32 sig);
 
diff --git a/lib/arm/io.c b/lib/arm/io.c
index 343e108..893bdfc 100644
--- a/lib/arm/io.c
+++ b/lib/arm/io.c
@@ -8,6 +8,7 @@
  *
  * This work is licensed under the terms of the GNU LGPL, version 2.
  */
+#include <acpi.h>
 #include <libcflat.h>
 #include <devicetree.h>
 #include <chr-testdev.h>
@@ -29,7 +30,7 @@ static struct spinlock uart_lock;
 #define UART_EARLY_BASE (u8 *)(unsigned long)CONFIG_UART_EARLY_BASE
 static volatile u8 *uart0_base = UART_EARLY_BASE;
 
-static void uart0_init(void)
+static void uart0_init_fdt(void)
 {
 	/*
 	 * kvm-unit-tests uses the uart only for output. Both uart models have
@@ -73,9 +74,25 @@ static void uart0_init(void)
 	}
 }
 
+static void uart0_init_acpi(void)
+{
+	struct spcr_descriptor *spcr = find_acpi_table_addr(SPCR_SIGNATURE);
+	assert_msg(spcr, "Unable to find ACPI SPCR");
+	uart0_base = ioremap(spcr->serial_port.address, spcr->serial_port.bit_width);
+
+	if (uart0_base != UART_EARLY_BASE) {
+		printf("WARNING: early print support may not work. "
+		       "Found uart at %p, but early base is %p.\n",
+			uart0_base, UART_EARLY_BASE);
+	}
+}
+
 void io_init(void)
 {
-	uart0_init();
+	if (dt_available())
+		uart0_init_fdt();
+	else
+		uart0_init_acpi();
 	chr_testdev_init();
 }
 
diff --git a/lib/arm/psci.c b/lib/arm/psci.c
index 0e96d19..afbc33d 100644
--- a/lib/arm/psci.c
+++ b/lib/arm/psci.c
@@ -80,9 +80,11 @@ static void psci_set_conduit_fdt(void)
 static void psci_set_conduit_acpi(void)
 {
 	struct acpi_table_fadt *fadt = find_acpi_table_addr(FACP_SIGNATURE);
+
 	assert_msg(fadt, "Unable to find ACPI FADT");
 	assert_msg(fadt->arm_boot_flags & ACPI_FADT_PSCI_COMPLIANT,
-		   "PSCI is not supported in this platfrom");
+		   "PSCI is not supported in this platform");
+
 	if (fadt->arm_boot_flags & ACPI_FADT_PSCI_USE_HVC)
 		psci_invoke = psci_invoke_hvc;
 	else
-- 
2.25.1

