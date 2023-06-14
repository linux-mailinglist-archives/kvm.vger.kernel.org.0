Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8211B7168D2
	for <lists+kvm@lfdr.de>; Tue, 30 May 2023 18:10:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233305AbjE3QKw (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 30 May 2023 12:10:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57058 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232714AbjE3QKs (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 30 May 2023 12:10:48 -0400
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 169F719D
        for <kvm@vger.kernel.org>; Tue, 30 May 2023 09:10:22 -0700 (PDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 64699176A;
        Tue, 30 May 2023 09:10:48 -0700 (PDT)
Received: from godel.lab.cambridge.arm.com (godel.lab.cambridge.arm.com [10.7.66.42])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 003783F663;
        Tue, 30 May 2023 09:10:01 -0700 (PDT)
From:   Nikos Nikoleris <nikos.nikoleris@arm.com>
To:     kvm@vger.kernel.org, kvmarm@lists.linux.dev, andrew.jones@linux.dev
Cc:     pbonzini@redhat.com, alexandru.elisei@arm.com, ricarkol@google.com,
        shahuang@redhat.com, Andrew Jones <drjones@redhat.com>
Subject: [kvm-unit-tests PATCH v6 09/32] lib/acpi: Extend the definition of the FADT table
Date:   Tue, 30 May 2023 17:09:01 +0100
Message-Id: <20230530160924.82158-10-nikos.nikoleris@arm.com>
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

This change add more fields in the APCI table FADT to allow for the
discovery of the PSCI conduit in arm64 systems. The definition for
FADT is similar to the one in include/acpi/actbl.h in Linux.

Signed-off-by: Nikos Nikoleris <nikos.nikoleris@arm.com>
Reviewed-by: Ricardo Koller <ricarkol@google.com>
Reviewed-by: Andrew Jones <drjones@redhat.com>
Reviewed-by: Shaoqin Huang <shahuang@redhat.com>
---
 lib/acpi.h   | 33 +++++++++++++++++++++++++++++----
 lib/acpi.c   |  2 +-
 x86/s3.c     |  2 +-
 x86/vmexit.c |  2 +-
 4 files changed, 32 insertions(+), 7 deletions(-)

diff --git a/lib/acpi.h b/lib/acpi.h
index acf807d7..0c205f5b 100644
--- a/lib/acpi.h
+++ b/lib/acpi.h
@@ -62,7 +62,15 @@ struct acpi_table_xsdt {
 	u64 table_offset_entry[];
 };
 
-struct acpi_table_fadt_rev1 {
+struct acpi_generic_address {
+	u8 space_id;		/* Address space where struct or register exists */
+	u8 bit_width;		/* Size in bits of given register */
+	u8 bit_offset;		/* Bit offset within the register */
+	u8 access_width;	/* Minimum Access size (ACPI 3.0) */
+	u64 address;		/* 64-bit address of struct or register */
+};
+
+struct acpi_table_fadt {
 	ACPI_TABLE_HEADER_DEF	/* ACPI common table header */
 	u32 firmware_ctrl;	/* Physical address of FACS */
 	u32 dsdt;		/* Physical address of DSDT */
@@ -99,9 +107,26 @@ struct acpi_table_fadt_rev1 {
 	u8 day_alrm;		/* Index to day-of-month alarm in RTC CMOS RAM */
 	u8 mon_alrm;		/* Index to month-of-year alarm in RTC CMOS RAM */
 	u8 century;		/* Index to century in RTC CMOS RAM */
-	u8 reserved4;		/* Reserved */
-	u8 reserved4a;		/* Reserved */
-	u8 reserved4b;		/* Reserved */
+	u16 boot_flags;		/* IA-PC Boot Architecture Flags (see below for individual flags) */
+	u8 reserved;		/* Reserved, must be zero */
+	u32 flags;		/* Miscellaneous flag bits (see below for individual flags) */
+	struct acpi_generic_address reset_register;	/* 64-bit address of the Reset register */
+	u8 reset_value;		/* Value to write to the reset_register port to reset the system */
+	u16 arm_boot_flags;	/* ARM-Specific Boot Flags (see below for individual flags) (ACPI 5.1) */
+	u8 minor_revision;	/* FADT Minor Revision (ACPI 5.1) */
+	u64 Xfacs;		/* 64-bit physical address of FACS */
+	u64 Xdsdt;		/* 64-bit physical address of DSDT */
+	struct acpi_generic_address xpm1a_event_block;	/* 64-bit Extended Power Mgt 1a Event Reg Blk address */
+	struct acpi_generic_address xpm1b_event_block;	/* 64-bit Extended Power Mgt 1b Event Reg Blk address */
+	struct acpi_generic_address xpm1a_control_block;	/* 64-bit Extended Power Mgt 1a Control Reg Blk address */
+	struct acpi_generic_address xpm1b_control_block;	/* 64-bit Extended Power Mgt 1b Control Reg Blk address */
+	struct acpi_generic_address xpm2_control_block;	/* 64-bit Extended Power Mgt 2 Control Reg Blk address */
+	struct acpi_generic_address xpm_timer_block;	/* 64-bit Extended Power Mgt Timer Ctrl Reg Blk address */
+	struct acpi_generic_address xgpe0_block;	/* 64-bit Extended General Purpose Event 0 Reg Blk address */
+	struct acpi_generic_address xgpe1_block;	/* 64-bit Extended General Purpose Event 1 Reg Blk address */
+	struct acpi_generic_address sleep_control;	/* 64-bit Sleep Control register (ACPI 5.0) */
+	struct acpi_generic_address sleep_status;	/* 64-bit Sleep Status register (ACPI 5.0) */
+	u64 hypervisor_id;	/* Hypervisor Vendor ID (ACPI 6.0) */
 };
 
 struct acpi_table_facs_rev1 {
diff --git a/lib/acpi.c b/lib/acpi.c
index 133dd5c0..f55d3e37 100644
--- a/lib/acpi.c
+++ b/lib/acpi.c
@@ -45,7 +45,7 @@ void *find_acpi_table_addr(u32 sig)
 
 	/* FACS is special... */
 	if (sig == FACS_SIGNATURE) {
-		struct acpi_table_fadt_rev1 *fadt;
+		struct acpi_table_fadt *fadt;
 
 		fadt = find_acpi_table_addr(FACP_SIGNATURE);
 		if (!fadt)
diff --git a/x86/s3.c b/x86/s3.c
index 910c57fb..6f2d6d10 100644
--- a/x86/s3.c
+++ b/x86/s3.c
@@ -30,8 +30,8 @@ extern char resume_start, resume_end;
 
 int main(int argc, char **argv)
 {
-	struct acpi_table_fadt_rev1 *fadt = find_acpi_table_addr(FACP_SIGNATURE);
 	struct acpi_table_facs_rev1 *facs = find_acpi_table_addr(FACS_SIGNATURE);
+	struct acpi_table_fadt *fadt = find_acpi_table_addr(FACP_SIGNATURE);
 	char *addr, *resume_vec = (void*)0x1000;
 
 	assert(facs);
diff --git a/x86/vmexit.c b/x86/vmexit.c
index 12234f9e..cc086b86 100644
--- a/x86/vmexit.c
+++ b/x86/vmexit.c
@@ -206,7 +206,7 @@ int pm_tmr_blk;
 static void inl_pmtimer(void)
 {
     if (!pm_tmr_blk) {
-	struct acpi_table_fadt_rev1 *fadt;
+	struct acpi_table_fadt *fadt;
 
 	fadt = find_acpi_table_addr(FACP_SIGNATURE);
 	pm_tmr_blk = fadt->pm_tmr_blk;
-- 
2.25.1

