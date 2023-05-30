Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E26987168D0
	for <lists+kvm@lfdr.de>; Tue, 30 May 2023 18:10:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233299AbjE3QKu (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 30 May 2023 12:10:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57060 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233290AbjE3QKr (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 30 May 2023 12:10:47 -0400
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id ADA1B19A
        for <kvm@vger.kernel.org>; Tue, 30 May 2023 09:10:21 -0700 (PDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 192761764;
        Tue, 30 May 2023 09:10:47 -0700 (PDT)
Received: from godel.lab.cambridge.arm.com (godel.lab.cambridge.arm.com [10.7.66.42])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id C35A63F663;
        Tue, 30 May 2023 09:10:00 -0700 (PDT)
From:   Nikos Nikoleris <nikos.nikoleris@arm.com>
To:     kvm@vger.kernel.org, kvmarm@lists.linux.dev, andrew.jones@linux.dev
Cc:     pbonzini@redhat.com, alexandru.elisei@arm.com, ricarkol@google.com,
        shahuang@redhat.com
Subject: [kvm-unit-tests PATCH v6 08/32] lib/acpi: Add support for the XSDT table
Date:   Tue, 30 May 2023 17:09:00 +0100
Message-Id: <20230530160924.82158-9-nikos.nikoleris@arm.com>
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

XSDT provides pointers to other ACPI tables much like RSDT. However,
contrary to RSDT that provides 32-bit addresses, XSDT provides 64-bit
pointers. ACPI requires that if XSDT is valid then it takes precedence
over RSDT.

Signed-off-by: Nikos Nikoleris <nikos.nikoleris@arm.com>
Reviewed-by: Andrew Jones <andrew.jones@linux.dev>
[ Alex E: Use flexible array member for XSDT struct ]
Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>
Reviewed-by: Shaoqin Huang <shahuang@redhat.com>
---
 lib/acpi.h |  6 ++++++
 lib/acpi.c | 40 ++++++++++++++++++++++++++++++++--------
 2 files changed, 38 insertions(+), 8 deletions(-)

diff --git a/lib/acpi.h b/lib/acpi.h
index 7eb18cf3..acf807d7 100644
--- a/lib/acpi.h
+++ b/lib/acpi.h
@@ -14,6 +14,7 @@
 
 #define RSDP_SIGNATURE ACPI_SIGNATURE('R','S','D','P')
 #define RSDT_SIGNATURE ACPI_SIGNATURE('R','S','D','T')
+#define XSDT_SIGNATURE ACPI_SIGNATURE('X','S','D','T')
 #define FACP_SIGNATURE ACPI_SIGNATURE('F','A','C','P')
 #define FACS_SIGNATURE ACPI_SIGNATURE('F','A','C','S')
 
@@ -56,6 +57,11 @@ struct acpi_table_rsdt_rev1 {
 	u32 table_offset_entry[];
 };
 
+struct acpi_table_xsdt {
+	ACPI_TABLE_HEADER_DEF
+	u64 table_offset_entry[];
+};
+
 struct acpi_table_fadt_rev1 {
 	ACPI_TABLE_HEADER_DEF	/* ACPI common table header */
 	u32 firmware_ctrl;	/* Physical address of FACS */
diff --git a/lib/acpi.c b/lib/acpi.c
index 166ffd14..133dd5c0 100644
--- a/lib/acpi.c
+++ b/lib/acpi.c
@@ -37,7 +37,8 @@ static struct acpi_table_rsdp *get_rsdp(void)
 
 void *find_acpi_table_addr(u32 sig)
 {
-	struct acpi_table_rsdt_rev1 *rsdt;
+	struct acpi_table_rsdt_rev1 *rsdt = NULL;
+	struct acpi_table_xsdt *xsdt = NULL;
 	struct acpi_table_rsdp *rsdp;
 	void *end;
 	int i;
@@ -62,18 +63,41 @@ void *find_acpi_table_addr(u32 sig)
 		return rsdp;
 
 	rsdt = (void *)(ulong) rsdp->rsdt_physical_address;
-	if (!rsdt || rsdt->signature != RSDT_SIGNATURE)
-		return NULL;
+	if (rsdt && rsdt->signature != RSDT_SIGNATURE)
+		rsdt = NULL;
 
 	if (sig == RSDT_SIGNATURE)
 		return rsdt;
 
-	end = (void *)rsdt + rsdt->length;
-	for (i = 0; (void *)&rsdt->table_offset_entry[i] < end; i++) {
-		struct acpi_table *t = (void *)(ulong) rsdt->table_offset_entry[i];
+	if (rsdp->revision >= 2) {
+		xsdt = (void *)(ulong) rsdp->xsdt_physical_address;
+		if (xsdt && xsdt->signature != XSDT_SIGNATURE)
+			xsdt = NULL;
+	}
 
-		if (t && t->signature == sig)
-			return t;
+	if (sig == XSDT_SIGNATURE)
+		return xsdt;
+
+	/*
+	 * When the system implements APCI 2.0 and above and XSDT is valid we
+	 * have use XSDT to find other ACPI tables, otherwise, we use RSDT.
+	 */
+	if (xsdt) {
+		end = (void *)xsdt + xsdt->length;
+		for (i = 0; (void *)&xsdt->table_offset_entry[i] < end; i++) {
+			struct acpi_table *t = (void *)(ulong) xsdt->table_offset_entry[i];
+
+			if (t && t->signature == sig)
+				return t;
+		}
+	} else if (rsdt) {
+		end = (void *)rsdt + rsdt->length;
+		for (i = 0; (void *)&rsdt->table_offset_entry[i] < end; i++) {
+			struct acpi_table *t = (void *)(ulong) rsdt->table_offset_entry[i];
+
+			if (t && t->signature == sig)
+				return t;
+		}
 	}
 
 	return NULL;
-- 
2.25.1

