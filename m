Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F0C1F561718
	for <lists+kvm@lfdr.de>; Thu, 30 Jun 2022 12:05:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234719AbiF3KEC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 30 Jun 2022 06:04:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38658 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234711AbiF3KEA (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 30 Jun 2022 06:04:00 -0400
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 1CD6D43ADF
        for <kvm@vger.kernel.org>; Thu, 30 Jun 2022 03:03:58 -0700 (PDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 40D2A1063;
        Thu, 30 Jun 2022 03:03:58 -0700 (PDT)
Received: from godel.lab.cambridge.arm.com (godel.lab.cambridge.arm.com [10.7.66.42])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 1211C3F5A1;
        Thu, 30 Jun 2022 03:03:56 -0700 (PDT)
From:   Nikos Nikoleris <nikos.nikoleris@arm.com>
To:     kvm@vger.kernel.org
Cc:     andrew.jones@linux.dev, drjones@redhat.com, pbonzini@redhat.com,
        jade.alglave@arm.com, alexandru.elisei@arm.com, ricarkol@google.com
Subject: [kvm-unit-tests PATCH v3 07/27] arm/arm64: Add support for setting up the PSCI conduit through ACPI
Date:   Thu, 30 Jun 2022 11:03:04 +0100
Message-Id: <20220630100324.3153655-8-nikos.nikoleris@arm.com>
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
the FADT to discover whether PSCI calls need to use smc or hvc
calls. This change implements this but retains the default behavior;
we check if a valid DT is provided, if not, we try to setup the PSCI
conduit using ACPI.

Signed-off-by: Nikos Nikoleris <nikos.nikoleris@arm.com>
Reviewed-by: Andrew Jones <drjones@redhat.com>
Reviewed-by: Ricardo Koller <ricarkol@google.com>
---
 arm/Makefile.common |  1 +
 lib/acpi.h          |  5 +++++
 lib/arm/psci.c      | 25 ++++++++++++++++++++++++-
 3 files changed, 30 insertions(+), 1 deletion(-)

diff --git a/arm/Makefile.common b/arm/Makefile.common
index 38385e0..8e9b3bb 100644
--- a/arm/Makefile.common
+++ b/arm/Makefile.common
@@ -38,6 +38,7 @@ cflatobjs += lib/alloc_page.o
 cflatobjs += lib/vmalloc.o
 cflatobjs += lib/alloc.o
 cflatobjs += lib/devicetree.o
+cflatobjs += lib/acpi.o
 cflatobjs += lib/pci.o
 cflatobjs += lib/pci-host-generic.o
 cflatobjs += lib/pci-testdev.o
diff --git a/lib/acpi.h b/lib/acpi.h
index e49647b..6c18f73 100644
--- a/lib/acpi.h
+++ b/lib/acpi.h
@@ -131,6 +131,11 @@ struct acpi_table_fadt
 	u64 hypervisor_id;	/* Hypervisor Vendor ID (ACPI 6.0) */
 };
 
+/* Masks for FADT ARM Boot Architecture Flags (arm_boot_flags) ACPI 5.1 */
+
+#define ACPI_FADT_PSCI_COMPLIANT    (1)         /* 00: [V5+] PSCI 0.2+ is implemented */
+#define ACPI_FADT_PSCI_USE_HVC      (1<<1)      /* 01: [V5+] HVC must be used instead of SMC as the PSCI conduit */
+
 struct facs_descriptor_rev1
 {
 	u32 signature;			/* ACPI Signature */
diff --git a/lib/arm/psci.c b/lib/arm/psci.c
index 9c031a1..afbc33d 100644
--- a/lib/arm/psci.c
+++ b/lib/arm/psci.c
@@ -6,6 +6,7 @@
  *
  * This work is licensed under the terms of the GNU LGPL, version 2.
  */
+#include <acpi.h>
 #include <devicetree.h>
 #include <asm/psci.h>
 #include <asm/setup.h>
@@ -56,7 +57,7 @@ void psci_system_off(void)
 	printf("CPU%d unable to do system off (error = %d)\n", smp_processor_id(), err);
 }
 
-void psci_set_conduit(void)
+static void psci_set_conduit_fdt(void)
 {
 	const void *fdt = dt_fdt();
 	const struct fdt_property *method;
@@ -75,3 +76,25 @@ void psci_set_conduit(void)
 	else
 		assert_msg(false, "Unknown PSCI conduit: %s", method->data);
 }
+
+static void psci_set_conduit_acpi(void)
+{
+	struct acpi_table_fadt *fadt = find_acpi_table_addr(FACP_SIGNATURE);
+
+	assert_msg(fadt, "Unable to find ACPI FADT");
+	assert_msg(fadt->arm_boot_flags & ACPI_FADT_PSCI_COMPLIANT,
+		   "PSCI is not supported in this platform");
+
+	if (fadt->arm_boot_flags & ACPI_FADT_PSCI_USE_HVC)
+		psci_invoke = psci_invoke_hvc;
+	else
+		psci_invoke = psci_invoke_smc;
+}
+
+void psci_set_conduit(void)
+{
+	if (dt_available())
+		psci_set_conduit_fdt();
+	else
+		psci_set_conduit_acpi();
+}
-- 
2.25.1

