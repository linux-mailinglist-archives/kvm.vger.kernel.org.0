Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EE0DB694299
	for <lists+kvm@lfdr.de>; Mon, 13 Feb 2023 11:18:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230336AbjBMKS3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 13 Feb 2023 05:18:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53386 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230354AbjBMKSW (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 13 Feb 2023 05:18:22 -0500
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id E8232166FD
        for <kvm@vger.kernel.org>; Mon, 13 Feb 2023 02:18:18 -0800 (PST)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 2B01D1D31;
        Mon, 13 Feb 2023 02:19:01 -0800 (PST)
Received: from godel.lab.cambridge.arm.com (godel.lab.cambridge.arm.com [10.7.66.42])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 90EBB3F703;
        Mon, 13 Feb 2023 02:18:17 -0800 (PST)
From:   Nikos Nikoleris <nikos.nikoleris@arm.com>
To:     kvm@vger.kernel.org, kvmarm@lists.linux.dev, andrew.jones@linux.dev
Cc:     pbonzini@redhat.com, alexandru.elisei@arm.com, ricarkol@google.com,
        Andrew Jones <drjones@redhat.com>
Subject: [PATCH v4 12/30] arm64: Add support for setting up the PSCI conduit through ACPI
Date:   Mon, 13 Feb 2023 10:17:41 +0000
Message-Id: <20230213101759.2577077-13-nikos.nikoleris@arm.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20230213101759.2577077-1-nikos.nikoleris@arm.com>
References: <20230213101759.2577077-1-nikos.nikoleris@arm.com>
MIME-Version: 1.0
X-ARM-No-Footer: FoSSMail
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
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
 arm/Makefile.arm64 |  4 ++++
 lib/acpi.h         |  5 +++++
 lib/arm/psci.c     | 37 ++++++++++++++++++++++++++++++++++++-
 3 files changed, 45 insertions(+), 1 deletion(-)

diff --git a/arm/Makefile.arm64 b/arm/Makefile.arm64
index 42e18e77..6dff6cad 100644
--- a/arm/Makefile.arm64
+++ b/arm/Makefile.arm64
@@ -25,6 +25,10 @@ cflatobjs += lib/arm64/processor.o
 cflatobjs += lib/arm64/spinlock.o
 cflatobjs += lib/arm64/gic-v3-its.o lib/arm64/gic-v3-its-cmd.o
 
+ifeq ($(CONFIG_EFI),y)
+cflatobjs += lib/acpi.o
+endif
+
 OBJDIRS += lib/arm64
 
 # arm64 specific tests
diff --git a/lib/acpi.h b/lib/acpi.h
index 38b6d5c9..5ba6e29d 100644
--- a/lib/acpi.h
+++ b/lib/acpi.h
@@ -129,6 +129,11 @@ struct acpi_table_fadt {
 	u64 hypervisor_id;	/* Hypervisor Vendor ID (ACPI 6.0) */
 };
 
+/* Masks for FADT ARM Boot Architecture Flags (arm_boot_flags) ACPI 5.1 */
+
+#define ACPI_FADT_PSCI_COMPLIANT    (1)	/* 00: [V5+] PSCI 0.2+ is implemented */
+#define ACPI_FADT_PSCI_USE_HVC      (1<<1)	/* 01: [V5+] HVC must be used instead of SMC as the PSCI conduit */
+
 struct acpi_table_facs_rev1 {
 	u32 signature;		/* ACPI Signature */
 	u32 length;		/* Length of structure, in bytes */
diff --git a/lib/arm/psci.c b/lib/arm/psci.c
index 9c031a12..bddb0787 100644
--- a/lib/arm/psci.c
+++ b/lib/arm/psci.c
@@ -56,7 +56,7 @@ void psci_system_off(void)
 	printf("CPU%d unable to do system off (error = %d)\n", smp_processor_id(), err);
 }
 
-void psci_set_conduit(void)
+static void psci_set_conduit_fdt(void)
 {
 	const void *fdt = dt_fdt();
 	const struct fdt_property *method;
@@ -75,3 +75,38 @@ void psci_set_conduit(void)
 	else
 		assert_msg(false, "Unknown PSCI conduit: %s", method->data);
 }
+
+#ifdef CONFIG_EFI
+
+#include <acpi.h>
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
+#else
+
+static void psci_set_conduit_acpi(void)
+{
+	assert_msg(false, "ACPI not available");
+}
+
+#endif
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

