Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F292851E073
	for <lists+kvm@lfdr.de>; Fri,  6 May 2022 22:56:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1444137AbiEFVAg (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 6 May 2022 17:00:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52772 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1444048AbiEFVAf (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 6 May 2022 17:00:35 -0400
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 71DDF6A068
        for <kvm@vger.kernel.org>; Fri,  6 May 2022 13:56:51 -0700 (PDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 4DF1F14BF;
        Fri,  6 May 2022 13:56:51 -0700 (PDT)
Received: from godel.lab.cambridge.arm.com (godel.lab.cambridge.arm.com [10.7.66.42])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 788043F800;
        Fri,  6 May 2022 13:56:50 -0700 (PDT)
From:   Nikos Nikoleris <nikos.nikoleris@arm.com>
To:     kvm@vger.kernel.org
Cc:     drjones@redhat.com, pbonzini@redhat.com, jade.alglave@arm.com,
        alexandru.elisei@arm.com
Subject: [kvm-unit-tests PATCH v2 02/23] lib: Ensure all struct definition for ACPI tables are packed
Date:   Fri,  6 May 2022 21:55:44 +0100
Message-Id: <20220506205605.359830-3-nikos.nikoleris@arm.com>
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

All ACPI table definitions are provided with precise definitions of
field sizes and offsets, make sure that no compiler optimization can
interfere with the memory layout of the corresponding structs.

Signed-off-by: Nikos Nikoleris <nikos.nikoleris@arm.com>
---
 lib/acpi.h | 11 ++++++++---
 x86/s3.c   | 16 ++++------------
 2 files changed, 12 insertions(+), 15 deletions(-)

diff --git a/lib/acpi.h b/lib/acpi.h
index 1e89840..42a2c16 100644
--- a/lib/acpi.h
+++ b/lib/acpi.h
@@ -3,6 +3,11 @@
 
 #include "libcflat.h"
 
+/*
+ * All tables and structures must be byte-packed to match the ACPI
+ * specification, since the tables are provided by the system BIOS
+ */
+
 #define ACPI_SIGNATURE(c1, c2, c3, c4) \
 	((c1) | ((c2) << 8) | ((c3) << 16) | ((c4) << 24))
 
@@ -44,12 +49,12 @@ struct rsdp_descriptor {        /* Root System Descriptor Pointer */
 struct acpi_table {
     ACPI_TABLE_HEADER_DEF
     char data[0];
-};
+} __attribute__ ((packed));
 
 struct rsdt_descriptor_rev1 {
     ACPI_TABLE_HEADER_DEF
     u32 table_offset_entry[0];
-};
+} __attribute__ ((packed));
 
 struct fadt_descriptor_rev1
 {
@@ -104,7 +109,7 @@ struct facs_descriptor_rev1
     u32 S4bios_f        : 1;    /* Indicates if S4BIOS support is present */
     u32 reserved1       : 31;   /* Must be 0 */
     u8  reserved3 [40];         /* Reserved - must be zero */
-};
+} __attribute__ ((packed));
 
 void set_efi_rsdp(struct rsdp_descriptor *rsdp);
 void* find_acpi_table_addr(u32 sig);
diff --git a/x86/s3.c b/x86/s3.c
index 378d37a..89d69fc 100644
--- a/x86/s3.c
+++ b/x86/s3.c
@@ -2,15 +2,6 @@
 #include "acpi.h"
 #include "asm/io.h"
 
-static u32* find_resume_vector_addr(void)
-{
-    struct facs_descriptor_rev1 *facs = find_acpi_table_addr(FACS_SIGNATURE);
-    if (!facs)
-        return 0;
-    printf("FACS is at %p\n", facs);
-    return &facs->firmware_waking_vector;
-}
-
 #define RTC_SECONDS_ALARM       1
 #define RTC_MINUTES_ALARM       3
 #define RTC_HOURS_ALARM         5
@@ -40,12 +31,13 @@ extern char resume_start, resume_end;
 int main(int argc, char **argv)
 {
 	struct fadt_descriptor_rev1 *fadt = find_acpi_table_addr(FACP_SIGNATURE);
-	volatile u32 *resume_vector_ptr = find_resume_vector_addr();
+	struct facs_descriptor_rev1 *facs = find_acpi_table_addr(FACS_SIGNATURE);
 	char *addr, *resume_vec = (void*)0x1000;
 
-	*resume_vector_ptr = (u32)(ulong)resume_vec;
+	facs->firmware_waking_vector = (u32)(ulong)resume_vec;
 
-	printf("resume vector addr is %p\n", resume_vector_ptr);
+	printf("FACS is at %p\n", facs);
+	printf("resume vector addr is %p\n", &facs->firmware_waking_vector);
 	for (addr = &resume_start; addr < &resume_end; addr++)
 		*resume_vec++ = *addr;
 	printf("copy resume code from %p\n", &resume_start);
-- 
2.25.1

