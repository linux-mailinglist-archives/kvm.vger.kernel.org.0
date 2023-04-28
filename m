Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 849E06F172A
	for <lists+kvm@lfdr.de>; Fri, 28 Apr 2023 14:05:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345996AbjD1MFP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 28 Apr 2023 08:05:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46834 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345968AbjD1MFC (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 28 Apr 2023 08:05:02 -0400
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 9B9AF524D
        for <kvm@vger.kernel.org>; Fri, 28 Apr 2023 05:05:01 -0700 (PDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 76CC0143D;
        Fri, 28 Apr 2023 05:05:45 -0700 (PDT)
Received: from godel.lab.cambridge.arm.com (godel.lab.cambridge.arm.com [10.7.66.42])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 6A6BB3F5A1;
        Fri, 28 Apr 2023 05:05:00 -0700 (PDT)
From:   Nikos Nikoleris <nikos.nikoleris@arm.com>
To:     kvm@vger.kernel.org, kvmarm@lists.linux.dev, andrew.jones@linux.dev
Cc:     pbonzini@redhat.com, alexandru.elisei@arm.com, ricarkol@google.com,
        Andrew Jones <drjones@redhat.com>
Subject: [kvm-unit-tests PATCH v5 11/29] arm64: Add support for setting up the PSCI conduit through ACPI
Date:   Fri, 28 Apr 2023 13:03:47 +0100
Message-Id: <20230428120405.3770496-12-nikos.nikoleris@arm.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20230428120405.3770496-1-nikos.nikoleris@arm.com>
References: <20230428120405.3770496-1-nikos.nikoleris@arm.com>
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
index b714677e..ef4a8e1d 100644
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

