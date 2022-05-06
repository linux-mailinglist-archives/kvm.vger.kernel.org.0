Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4949251DA02
	for <lists+kvm@lfdr.de>; Fri,  6 May 2022 16:09:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1442019AbiEFONE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 6 May 2022 10:13:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34558 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1442012AbiEFOMy (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 6 May 2022 10:12:54 -0400
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id E0CE9674F0
        for <kvm@vger.kernel.org>; Fri,  6 May 2022 07:09:07 -0700 (PDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id B17A41576;
        Fri,  6 May 2022 07:09:07 -0700 (PDT)
Received: from godel.lab.cambridge.arm.com (godel.lab.cambridge.arm.com [10.7.66.42])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id DCE8D3F885;
        Fri,  6 May 2022 07:09:06 -0700 (PDT)
From:   Nikos Nikoleris <nikos.nikoleris@arm.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     jade.alglave@arm.com, alexandru.elisei@arm.com,
        Nikos Nikoleris <nikos.nikoleris@arm.com>, kvm@vger.kernel.org
Subject: [kvm-unit-tests PATCH 04/23] lib: Extend the definition of the ACPI table FADT
Date:   Fri,  6 May 2022 15:08:36 +0100
Message-Id: <20220506140855.353337-5-nikos.nikoleris@arm.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220506140855.353337-1-nikos.nikoleris@arm.com>
References: <20220506140855.353337-1-nikos.nikoleris@arm.com>
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

This change add more fields in the APCI table FADT to allow for the
discovery of the PSCI conduit in arm64 systems. The definition for
FADT is similar to the one in include/acpi/actbl.h in Linux.

Signed-off-by: Nikos Nikoleris <nikos.nikoleris@arm.com>
---
 lib/acpi.h   | 35 ++++++++++++++++++++++++++++++-----
 lib/acpi.c   |  2 +-
 x86/s3.c     |  2 +-
 x86/vmexit.c |  2 +-
 4 files changed, 33 insertions(+), 8 deletions(-)

diff --git a/lib/acpi.h b/lib/acpi.h
index b4ba587..657e868 100644
--- a/lib/acpi.h
+++ b/lib/acpi.h
@@ -62,7 +62,15 @@ struct acpi_table_xsdt {
     u64 table_offset_entry[1];
 } __attribute__ ((packed));
 
-struct fadt_descriptor_rev1
+struct acpi_generic_address {
+    u8 space_id;            /* Address space where struct or register exists */
+    u8 bit_width;           /* Size in bits of given register */
+    u8 bit_offset;          /* Bit offset within the register */
+    u8 access_width;        /* Minimum Access size (ACPI 3.0) */
+    u64 address;            /* 64-bit address of struct or register */
+} __attribute__ ((packed));
+
+struct acpi_table_fadt
 {
     ACPI_TABLE_HEADER_DEF     /* ACPI common table header */
     u32 firmware_ctrl;          /* Physical address of FACS */
@@ -100,10 +108,27 @@ struct fadt_descriptor_rev1
     u8  day_alrm;               /* Index to day-of-month alarm in RTC CMOS RAM */
     u8  mon_alrm;               /* Index to month-of-year alarm in RTC CMOS RAM */
     u8  century;                /* Index to century in RTC CMOS RAM */
-    u8  reserved4;              /* Reserved */
-    u8  reserved4a;             /* Reserved */
-    u8  reserved4b;             /* Reserved */
-};
+    u16 boot_flags;             /* IA-PC Boot Architecture Flags (see below for individual flags) */
+    u8 reserved;                /* Reserved, must be zero */
+    u32 flags;                  /* Miscellaneous flag bits (see below for individual flags) */
+    struct acpi_generic_address reset_register;     /* 64-bit address of the Reset register */
+    u8 reset_value;             /* Value to write to the reset_register port to reset the system */
+    u16 arm_boot_flags;         /* ARM-Specific Boot Flags (see below for individual flags) (ACPI 5.1) */
+    u8 minor_revision;          /* FADT Minor Revision (ACPI 5.1) */
+    u64 Xfacs;                  /* 64-bit physical address of FACS */
+    u64 Xdsdt;                  /* 64-bit physical address of DSDT */
+    struct acpi_generic_address xpm1a_event_block;  /* 64-bit Extended Power Mgt 1a Event Reg Blk address */
+    struct acpi_generic_address xpm1b_event_block;  /* 64-bit Extended Power Mgt 1b Event Reg Blk address */
+    struct acpi_generic_address xpm1a_control_block;        /* 64-bit Extended Power Mgt 1a Control Reg Blk address */
+    struct acpi_generic_address xpm1b_control_block;        /* 64-bit Extended Power Mgt 1b Control Reg Blk address */
+    struct acpi_generic_address xpm2_control_block; /* 64-bit Extended Power Mgt 2 Control Reg Blk address */
+    struct acpi_generic_address xpm_timer_block;    /* 64-bit Extended Power Mgt Timer Ctrl Reg Blk address */
+    struct acpi_generic_address xgpe0_block;        /* 64-bit Extended General Purpose Event 0 Reg Blk address */
+    struct acpi_generic_address xgpe1_block;        /* 64-bit Extended General Purpose Event 1 Reg Blk address */
+    struct acpi_generic_address sleep_control;      /* 64-bit Sleep Control register (ACPI 5.0) */
+    struct acpi_generic_address sleep_status;       /* 64-bit Sleep Status register (ACPI 5.0) */
+    u64 hypervisor_id;      /* Hypervisor Vendor ID (ACPI 6.0) */
+}  __attribute__ ((packed));
 
 struct facs_descriptor_rev1
 {
diff --git a/lib/acpi.c b/lib/acpi.c
index 63451b8..5e56dff 100644
--- a/lib/acpi.c
+++ b/lib/acpi.c
@@ -46,7 +46,7 @@ void* find_acpi_table_addr(u32 sig)
 
 	/* FACS is special... */
 	if (sig == FACS_SIGNATURE) {
-		struct fadt_descriptor_rev1 *fadt;
+		struct acpi_table_fadt *fadt;
 		fadt = find_acpi_table_addr(FACP_SIGNATURE);
 		if (!fadt) {
 			return NULL;
diff --git a/x86/s3.c b/x86/s3.c
index 89d69fc..16e79f8 100644
--- a/x86/s3.c
+++ b/x86/s3.c
@@ -30,7 +30,7 @@ extern char resume_start, resume_end;
 
 int main(int argc, char **argv)
 {
-	struct fadt_descriptor_rev1 *fadt = find_acpi_table_addr(FACP_SIGNATURE);
+	struct acpi_table_fadt *fadt = find_acpi_table_addr(FACP_SIGNATURE);
 	struct facs_descriptor_rev1 *facs = find_acpi_table_addr(FACS_SIGNATURE);
 	char *addr, *resume_vec = (void*)0x1000;
 
diff --git a/x86/vmexit.c b/x86/vmexit.c
index 2bac049..fcc0760 100644
--- a/x86/vmexit.c
+++ b/x86/vmexit.c
@@ -206,7 +206,7 @@ int pm_tmr_blk;
 static void inl_pmtimer(void)
 {
     if (!pm_tmr_blk) {
-	struct fadt_descriptor_rev1 *fadt;
+	struct acpi_table_fadt *fadt;
 
 	fadt = find_acpi_table_addr(FACP_SIGNATURE);
 	pm_tmr_blk = fadt->pm_tmr_blk;
-- 
2.25.1

