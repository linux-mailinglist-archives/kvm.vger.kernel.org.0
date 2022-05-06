Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AD59F51E074
	for <lists+kvm@lfdr.de>; Fri,  6 May 2022 22:56:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1444166AbiEFVAl (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 6 May 2022 17:00:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52804 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1444048AbiEFVAj (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 6 May 2022 17:00:39 -0400
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id E58386A064
        for <kvm@vger.kernel.org>; Fri,  6 May 2022 13:56:54 -0700 (PDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 7050214BF;
        Fri,  6 May 2022 13:56:54 -0700 (PDT)
Received: from godel.lab.cambridge.arm.com (godel.lab.cambridge.arm.com [10.7.66.42])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 9AEE93F800;
        Fri,  6 May 2022 13:56:53 -0700 (PDT)
From:   Nikos Nikoleris <nikos.nikoleris@arm.com>
To:     kvm@vger.kernel.org
Cc:     drjones@redhat.com, pbonzini@redhat.com, jade.alglave@arm.com,
        alexandru.elisei@arm.com
Subject: [kvm-unit-tests PATCH v2 03/23] lib: Add support for the XSDT ACPI table
Date:   Fri,  6 May 2022 21:55:45 +0100
Message-Id: <20220506205605.359830-4-nikos.nikoleris@arm.com>
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

XSDT provides pointers to other ACPI tables much like RSDT. However,
contrary to RSDT that provides 32-bit addresses, XSDT provides 64-bit
pointers. ACPI requires that if XSDT is valid then it takes precedence
over RSDT.

Signed-off-by: Nikos Nikoleris <nikos.nikoleris@arm.com>
---
 lib/acpi.h |   6 ++++
 lib/acpi.c | 103 ++++++++++++++++++++++++++++++++---------------------
 2 files changed, 68 insertions(+), 41 deletions(-)

diff --git a/lib/acpi.h b/lib/acpi.h
index 42a2c16..d80b983 100644
--- a/lib/acpi.h
+++ b/lib/acpi.h
@@ -13,6 +13,7 @@
 
 #define RSDP_SIGNATURE ACPI_SIGNATURE('R','S','D','P')
 #define RSDT_SIGNATURE ACPI_SIGNATURE('R','S','D','T')
+#define XSDT_SIGNATURE ACPI_SIGNATURE('X','S','D','T')
 #define FACP_SIGNATURE ACPI_SIGNATURE('F','A','C','P')
 #define FACS_SIGNATURE ACPI_SIGNATURE('F','A','C','S')
 
@@ -56,6 +57,11 @@ struct rsdt_descriptor_rev1 {
     u32 table_offset_entry[0];
 } __attribute__ ((packed));
 
+struct acpi_table_xsdt {
+    ACPI_TABLE_HEADER_DEF
+    u64 table_offset_entry[1];
+} __attribute__ ((packed));
+
 struct fadt_descriptor_rev1
 {
     ACPI_TABLE_HEADER_DEF     /* ACPI common table header */
diff --git a/lib/acpi.c b/lib/acpi.c
index de275ca..9b8700c 100644
--- a/lib/acpi.c
+++ b/lib/acpi.c
@@ -38,45 +38,66 @@ static struct rsdp_descriptor *get_rsdp(void)
 
 void* find_acpi_table_addr(u32 sig)
 {
-    struct rsdp_descriptor *rsdp;
-    struct rsdt_descriptor_rev1 *rsdt;
-    void *end;
-    int i;
-
-    /* FACS is special... */
-    if (sig == FACS_SIGNATURE) {
-        struct fadt_descriptor_rev1 *fadt;
-        fadt = find_acpi_table_addr(FACP_SIGNATURE);
-        if (!fadt) {
-            return NULL;
-        }
-        return (void*)(ulong)fadt->firmware_ctrl;
-    }
-
-    rsdp = get_rsdp();
-    if (rsdp == NULL) {
-        printf("Can't find RSDP\n");
-        return 0;
-    }
-
-    if (sig == RSDP_SIGNATURE) {
-        return rsdp;
-    }
-
-    rsdt = (void*)(ulong)rsdp->rsdt_physical_address;
-    if (!rsdt || rsdt->signature != RSDT_SIGNATURE)
-        return 0;
-
-    if (sig == RSDT_SIGNATURE) {
-        return rsdt;
-    }
-
-    end = (void*)rsdt + rsdt->length;
-    for (i=0; (void*)&rsdt->table_offset_entry[i] < end; i++) {
-        struct acpi_table *t = (void*)(ulong)rsdt->table_offset_entry[i];
-        if (t && t->signature == sig) {
-            return t;
-        }
-    }
-   return NULL;
+	struct rsdp_descriptor *rsdp;
+	struct rsdt_descriptor_rev1 *rsdt;
+	struct acpi_table_xsdt *xsdt = NULL;
+	void *end;
+	int i;
+
+	/* FACS is special... */
+	if (sig == FACS_SIGNATURE) {
+		struct fadt_descriptor_rev1 *fadt;
+
+		fadt = find_acpi_table_addr(FACP_SIGNATURE);
+		if (!fadt)
+			return NULL;
+
+		return (void*)(ulong)fadt->firmware_ctrl;
+	}
+
+	rsdp = get_rsdp();
+	if (rsdp == NULL) {
+		printf("Can't find RSDP\n");
+		return 0;
+	}
+
+	if (sig == RSDP_SIGNATURE)
+		return rsdp;
+
+	rsdt = (void *)(ulong)rsdp->rsdt_physical_address;
+	if (!rsdt || rsdt->signature != RSDT_SIGNATURE)
+		rsdt = NULL;
+
+	if (sig == RSDT_SIGNATURE)
+		return rsdt;
+
+	if (rsdp->revision > 1)
+		xsdt = (void *)(ulong)rsdp->xsdt_physical_address;
+	if (!xsdt || xsdt->signature != XSDT_SIGNATURE)
+		xsdt = NULL;
+
+	if (sig == XSDT_SIGNATURE)
+		return xsdt;
+
+	// APCI requires that we first try to use XSDT if it's valid,
+	//  we use to find other tables, otherwise we use RSDT.
+	if (xsdt) {
+		end = (void *)(ulong)xsdt + xsdt->length;
+		for (i = 0; (void *)&xsdt->table_offset_entry[i] < end; i++) {
+			struct acpi_table *t =
+				(void *)xsdt->table_offset_entry[i];
+			if (t && t->signature == sig)
+				return t;
+		}
+	} else if (rsdt) {
+		end = (void *)rsdt + rsdt->length;
+		for (i = 0; (void *)&rsdt->table_offset_entry[i] < end; i++) {
+			struct acpi_table *t =
+				(void *)(ulong)rsdt->table_offset_entry[i];
+			if (t && t->signature == sig)
+				return t;
+		}
+	}
+
+	return NULL;
 }
-- 
2.25.1

