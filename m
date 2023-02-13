Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 438CA694295
	for <lists+kvm@lfdr.de>; Mon, 13 Feb 2023 11:18:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230248AbjBMKSY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 13 Feb 2023 05:18:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53338 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230295AbjBMKSS (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 13 Feb 2023 05:18:18 -0500
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 17FD0E387
        for <kvm@vger.kernel.org>; Mon, 13 Feb 2023 02:18:14 -0800 (PST)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 9080C1CE2;
        Mon, 13 Feb 2023 02:18:56 -0800 (PST)
Received: from godel.lab.cambridge.arm.com (godel.lab.cambridge.arm.com [10.7.66.42])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 1CBF43F703;
        Mon, 13 Feb 2023 02:18:13 -0800 (PST)
From:   Nikos Nikoleris <nikos.nikoleris@arm.com>
To:     kvm@vger.kernel.org, kvmarm@lists.linux.dev, andrew.jones@linux.dev
Cc:     pbonzini@redhat.com, alexandru.elisei@arm.com, ricarkol@google.com
Subject: [PATCH v4 08/30] lib/acpi: Ensure all struct definition for ACPI tables are packed
Date:   Mon, 13 Feb 2023 10:17:37 +0000
Message-Id: <20230213101759.2577077-9-nikos.nikoleris@arm.com>
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

All ACPI table definitions are provided with precise definitions of
field sizes and offsets, make sure that no compiler optimization can
interfere with the memory layout of the corresponding structs.

Signed-off-by: Nikos Nikoleris <nikos.nikoleris@arm.com>
Reviewed-by: Andrew Jones <andrew.jones@linux.dev>
---
 lib/acpi.h | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/lib/acpi.h b/lib/acpi.h
index 229a6391..67d12942 100644
--- a/lib/acpi.h
+++ b/lib/acpi.h
@@ -3,6 +3,12 @@
 
 #include "libcflat.h"
 
+/*
+ * All tables and structures must be byte-packed to match the ACPI
+ * specification, since the tables are provided by the system firmware.
+ */
+#pragma pack(1)
+
 #define ACPI_SIGNATURE(c1, c2, c3, c4) \
 	((c1) | ((c2) << 8) | ((c3) << 16) | ((c4) << 24))
 
@@ -103,6 +109,8 @@ struct acpi_table_facs_rev1 {
 	u8 reserved3[40];	/* Reserved - must be zero */
 };
 
+#pragma pack(0)
+
 void set_efi_rsdp(struct acpi_table_rsdp *rsdp);
 void *find_acpi_table_addr(u32 sig);
 
-- 
2.25.1

