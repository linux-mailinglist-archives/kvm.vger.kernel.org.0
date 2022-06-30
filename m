Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A7B65561717
	for <lists+kvm@lfdr.de>; Thu, 30 Jun 2022 12:05:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234714AbiF3KEA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 30 Jun 2022 06:04:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38584 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234307AbiF3KD5 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 30 Jun 2022 06:03:57 -0400
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id D2E532A27E
        for <kvm@vger.kernel.org>; Thu, 30 Jun 2022 03:03:54 -0700 (PDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id CAF3E1042;
        Thu, 30 Jun 2022 03:03:54 -0700 (PDT)
Received: from godel.lab.cambridge.arm.com (godel.lab.cambridge.arm.com [10.7.66.42])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 9D6AA3F5A1;
        Thu, 30 Jun 2022 03:03:53 -0700 (PDT)
From:   Nikos Nikoleris <nikos.nikoleris@arm.com>
To:     kvm@vger.kernel.org
Cc:     andrew.jones@linux.dev, drjones@redhat.com, pbonzini@redhat.com,
        jade.alglave@arm.com, alexandru.elisei@arm.com, ricarkol@google.com
Subject: [kvm-unit-tests PATCH v3 04/27] lib: Add support for the XSDT ACPI table
Date:   Thu, 30 Jun 2022 11:03:01 +0100
Message-Id: <20220630100324.3153655-5-nikos.nikoleris@arm.com>
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

XSDT provides pointers to other ACPI tables much like RSDT. However,
contrary to RSDT that provides 32-bit addresses, XSDT provides 64-bit
pointers. ACPI requires that if XSDT is valid then it takes precedence
over RSDT.

Signed-off-by: Nikos Nikoleris <nikos.nikoleris@arm.com>
---
 lib/acpi.h |  6 ++++++
 lib/acpi.c | 37 +++++++++++++++++++++++++++++++------
 2 files changed, 37 insertions(+), 6 deletions(-)

diff --git a/lib/acpi.h b/lib/acpi.h
index b853a55..c5f0aa5 100644
--- a/lib/acpi.h
+++ b/lib/acpi.h
@@ -14,6 +14,7 @@
 
 #define RSDP_SIGNATURE ACPI_SIGNATURE('R','S','D','P')
 #define RSDT_SIGNATURE ACPI_SIGNATURE('R','S','D','T')
+#define XSDT_SIGNATURE ACPI_SIGNATURE('X','S','D','T')
 #define FACP_SIGNATURE ACPI_SIGNATURE('F','A','C','P')
 #define FACS_SIGNATURE ACPI_SIGNATURE('F','A','C','S')
 
@@ -57,6 +58,11 @@ struct rsdt_descriptor_rev1 {
 	u32 table_offset_entry[1];
 };
 
+struct acpi_table_xsdt {
+	ACPI_TABLE_HEADER_DEF
+	u64 table_offset_entry[1];
+};
+
 struct fadt_descriptor_rev1
 {
 	ACPI_TABLE_HEADER_DEF	/* ACPI common table header */
diff --git a/lib/acpi.c b/lib/acpi.c
index b7fd923..240a922 100644
--- a/lib/acpi.c
+++ b/lib/acpi.c
@@ -40,6 +40,7 @@ void *find_acpi_table_addr(u32 sig)
 {
 	struct rsdp_descriptor *rsdp;
 	struct rsdt_descriptor_rev1 *rsdt;
+	struct acpi_table_xsdt *xsdt = NULL;
 	void *end;
 	int i;
 
@@ -64,17 +65,41 @@ void *find_acpi_table_addr(u32 sig)
 
 	rsdt = (void *)(ulong)rsdp->rsdt_physical_address;
 	if (!rsdt || rsdt->signature != RSDT_SIGNATURE)
-		return NULL;
+		rsdt = NULL;
 
 	if (sig == RSDT_SIGNATURE)
 		return rsdt;
 
-	end = (void *)rsdt + rsdt->length;
-	for (i = 0; (void *)&rsdt->table_offset_entry[i] < end; i++) {
-		struct acpi_table *t = (void *)(ulong)rsdt->table_offset_entry[i];
-		if (t && t->signature == sig) {
-			return t;
+	/*
+	 * When the system implements APCI 2.0 and above and XSDT is
+	 * valid we have use XSDT to find other ACPI tables,
+	 * otherwise, we use RSDT.
+	 */
+	if (rsdp->revision == 2)
+		xsdt = (void *)(ulong)rsdp->xsdt_physical_address;
+	if (!xsdt || xsdt->signature != XSDT_SIGNATURE)
+		xsdt = NULL;
+
+	if (sig == XSDT_SIGNATURE)
+		return xsdt;
+
+	if (xsdt) {
+		end = (void *)(ulong)xsdt + xsdt->length;
+		for (i = 0; (void *)&xsdt->table_offset_entry[i] < end; i++) {
+			struct acpi_table *t = (void *)xsdt->table_offset_entry[i];
+
+			if (t && t->signature == sig)
+				return t;
+		}
+	} else if (rsdt) {
+		end = (void *)rsdt + rsdt->length;
+		for (i = 0; (void *)&rsdt->table_offset_entry[i] < end; i++) {
+			struct acpi_table *t = (void *)(ulong)rsdt->table_offset_entry[i];
+
+			if (t && t->signature == sig)
+				return t;
 		}
 	}
+
 	return NULL;
 }
-- 
2.25.1

