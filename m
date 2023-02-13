Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CB46B694293
	for <lists+kvm@lfdr.de>; Mon, 13 Feb 2023 11:18:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230309AbjBMKSW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 13 Feb 2023 05:18:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53190 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230130AbjBMKSN (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 13 Feb 2023 05:18:13 -0500
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 019B3DBF3
        for <kvm@vger.kernel.org>; Mon, 13 Feb 2023 02:18:12 -0800 (PST)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 61A551A25;
        Mon, 13 Feb 2023 02:18:54 -0800 (PST)
Received: from godel.lab.cambridge.arm.com (godel.lab.cambridge.arm.com [10.7.66.42])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id E22BA3F703;
        Mon, 13 Feb 2023 02:18:10 -0800 (PST)
From:   Nikos Nikoleris <nikos.nikoleris@arm.com>
To:     kvm@vger.kernel.org, kvmarm@lists.linux.dev, andrew.jones@linux.dev
Cc:     Alexandru Elisei <alexandru.elisei@arm.com>, pbonzini@redhat.com,
        ricarkol@google.com
Subject: [PATCH v4 06/30] lib/acpi: Convert table names to Linux style
Date:   Mon, 13 Feb 2023 10:17:35 +0000
Message-Id: <20230213101759.2577077-7-nikos.nikoleris@arm.com>
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

From: Alexandru Elisei <alexandru.elisei@arm.com>

kvm-unit-tests is about to import several table struct definitions from
Linux, convert the names of the existing tables to follow the Linux style.

This is purely a cosmetic change and no functional change is intended.

Signed-off-by: Nikos Nikoleris <nikos.nikoleris@arm.com>
---
 lib/acpi.c      | 16 ++++++++--------
 lib/acpi.h      | 10 +++++-----
 lib/x86/setup.c |  2 +-
 x86/s3.c        |  4 ++--
 x86/vmexit.c    |  2 +-
 5 files changed, 17 insertions(+), 17 deletions(-)

diff --git a/lib/acpi.c b/lib/acpi.c
index 3f87711a..166ffd14 100644
--- a/lib/acpi.c
+++ b/lib/acpi.c
@@ -2,14 +2,14 @@
 #include "acpi.h"
 
 #ifdef CONFIG_EFI
-struct rsdp_descriptor *efi_rsdp = NULL;
+struct acpi_table_rsdp *efi_rsdp = NULL;
 
-void set_efi_rsdp(struct rsdp_descriptor *rsdp)
+void set_efi_rsdp(struct acpi_table_rsdp *rsdp)
 {
 	efi_rsdp = rsdp;
 }
 
-static struct rsdp_descriptor *get_rsdp(void)
+static struct acpi_table_rsdp *get_rsdp(void)
 {
 	if (efi_rsdp == NULL)
 		printf("Can't find RSDP from UEFI, maybe set_efi_rsdp() was not called\n");
@@ -17,9 +17,9 @@ static struct rsdp_descriptor *get_rsdp(void)
 	return efi_rsdp;
 }
 #else
-static struct rsdp_descriptor *get_rsdp(void)
+static struct acpi_table_rsdp *get_rsdp(void)
 {
-	struct rsdp_descriptor *rsdp;
+	struct acpi_table_rsdp *rsdp;
 	unsigned long addr;
 
 	for (addr = 0xe0000; addr < 0x100000; addr += 16) {
@@ -37,14 +37,14 @@ static struct rsdp_descriptor *get_rsdp(void)
 
 void *find_acpi_table_addr(u32 sig)
 {
-	struct rsdt_descriptor_rev1 *rsdt;
-	struct rsdp_descriptor *rsdp;
+	struct acpi_table_rsdt_rev1 *rsdt;
+	struct acpi_table_rsdp *rsdp;
 	void *end;
 	int i;
 
 	/* FACS is special... */
 	if (sig == FACS_SIGNATURE) {
-		struct fadt_descriptor_rev1 *fadt;
+		struct acpi_table_fadt_rev1 *fadt;
 
 		fadt = find_acpi_table_addr(FACP_SIGNATURE);
 		if (!fadt)
diff --git a/lib/acpi.h b/lib/acpi.h
index fad28792..229a6391 100644
--- a/lib/acpi.h
+++ b/lib/acpi.h
@@ -17,7 +17,7 @@
 
 #define RSDP_SIGNATURE_8BYTE (ACPI_SIGNATURE_8BYTE('R', 'S', 'D', ' ', 'P', 'T', 'R', ' '))
 
-struct rsdp_descriptor {	/* Root System Descriptor Pointer */
+struct acpi_table_rsdp {	/* Root System Descriptor Pointer */
 	u64 signature;		/* ACPI signature, contains "RSD PTR " */
 	u8 checksum;		/* To make sum of struct == 0 */
 	u8 oem_id[6];		/* OEM identification */
@@ -45,12 +45,12 @@ struct acpi_table {
 	char data[];
 };
 
-struct rsdt_descriptor_rev1 {
+struct acpi_table_rsdt_rev1 {
 	ACPI_TABLE_HEADER_DEF
 	u32 table_offset_entry[];
 };
 
-struct fadt_descriptor_rev1 {
+struct acpi_table_fadt_rev1 {
 	ACPI_TABLE_HEADER_DEF	/* ACPI common table header */
 	u32 firmware_ctrl;	/* Physical address of FACS */
 	u32 dsdt;		/* Physical address of DSDT */
@@ -92,7 +92,7 @@ struct fadt_descriptor_rev1 {
 	u8 reserved4b;		/* Reserved */
 };
 
-struct facs_descriptor_rev1 {
+struct acpi_table_facs_rev1 {
 	u32 signature;		/* ACPI Signature */
 	u32 length;		/* Length of structure, in bytes */
 	u32 hardware_signature;	/* Hardware configuration signature */
@@ -103,7 +103,7 @@ struct facs_descriptor_rev1 {
 	u8 reserved3[40];	/* Reserved - must be zero */
 };
 
-void set_efi_rsdp(struct rsdp_descriptor *rsdp);
+void set_efi_rsdp(struct acpi_table_rsdp *rsdp);
 void *find_acpi_table_addr(u32 sig);
 
 #endif
diff --git a/lib/x86/setup.c b/lib/x86/setup.c
index dd150300..d509a248 100644
--- a/lib/x86/setup.c
+++ b/lib/x86/setup.c
@@ -245,7 +245,7 @@ static efi_status_t setup_memory_allocator(efi_bootinfo_t *efi_bootinfo)
 static efi_status_t setup_rsdp(efi_bootinfo_t *efi_bootinfo)
 {
 	efi_status_t status;
-	struct rsdp_descriptor *rsdp;
+	struct acpi_table_rsdp *rsdp;
 
 	/*
 	 * RSDP resides in an EFI_ACPI_RECLAIM_MEMORY region, which is not used
diff --git a/x86/s3.c b/x86/s3.c
index 378d37ae..96db728c 100644
--- a/x86/s3.c
+++ b/x86/s3.c
@@ -4,7 +4,7 @@
 
 static u32* find_resume_vector_addr(void)
 {
-    struct facs_descriptor_rev1 *facs = find_acpi_table_addr(FACS_SIGNATURE);
+    struct acpi_table_facs_rev1 *facs = find_acpi_table_addr(FACS_SIGNATURE);
     if (!facs)
         return 0;
     printf("FACS is at %p\n", facs);
@@ -39,7 +39,7 @@ extern char resume_start, resume_end;
 
 int main(int argc, char **argv)
 {
-	struct fadt_descriptor_rev1 *fadt = find_acpi_table_addr(FACP_SIGNATURE);
+	struct acpi_table_fadt_rev1 *fadt = find_acpi_table_addr(FACP_SIGNATURE);
 	volatile u32 *resume_vector_ptr = find_resume_vector_addr();
 	char *addr, *resume_vec = (void*)0x1000;
 
diff --git a/x86/vmexit.c b/x86/vmexit.c
index 865ccf6b..6987aca0 100644
--- a/x86/vmexit.c
+++ b/x86/vmexit.c
@@ -206,7 +206,7 @@ int pm_tmr_blk;
 static void inl_pmtimer(void)
 {
     if (!pm_tmr_blk) {
-	struct fadt_descriptor_rev1 *fadt;
+	struct acpi_table_fadt_rev1 *fadt;
 
 	fadt = find_acpi_table_addr(FACP_SIGNATURE);
 	pm_tmr_blk = fadt->pm_tmr_blk;
-- 
2.25.1

