Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2BF05561724
	for <lists+kvm@lfdr.de>; Thu, 30 Jun 2022 12:05:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234705AbiF3KD7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 30 Jun 2022 06:03:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38658 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234710AbiF3KD4 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 30 Jun 2022 06:03:56 -0400
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 9E3AA43EEF
        for <kvm@vger.kernel.org>; Thu, 30 Jun 2022 03:03:53 -0700 (PDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id A8F8F1C01;
        Thu, 30 Jun 2022 03:03:53 -0700 (PDT)
Received: from godel.lab.cambridge.arm.com (godel.lab.cambridge.arm.com [10.7.66.42])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 7A9BB3F5A1;
        Thu, 30 Jun 2022 03:03:52 -0700 (PDT)
From:   Nikos Nikoleris <nikos.nikoleris@arm.com>
To:     kvm@vger.kernel.org
Cc:     andrew.jones@linux.dev, drjones@redhat.com, pbonzini@redhat.com,
        jade.alglave@arm.com, alexandru.elisei@arm.com, ricarkol@google.com
Subject: [kvm-unit-tests PATCH v3 03/27] lib: Ensure all struct definition for ACPI tables are packed
Date:   Thu, 30 Jun 2022 11:03:00 +0100
Message-Id: <20220630100324.3153655-4-nikos.nikoleris@arm.com>
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

All ACPI table definitions are provided with precise definitions of
field sizes and offsets, make sure that no compiler optimization can
interfere with the memory layout of the corresponding structs.

Signed-off-by: Nikos Nikoleris <nikos.nikoleris@arm.com>
---
 lib/acpi.h | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/lib/acpi.h b/lib/acpi.h
index 456e62d..b853a55 100644
--- a/lib/acpi.h
+++ b/lib/acpi.h
@@ -3,6 +3,12 @@
 
 #include "libcflat.h"
 
+/*
+ * All tables and structures must be byte-packed to match the ACPI
+ * specification, since the tables are provided by the system BIOS
+ */
+#pragma pack(1)
+
 #define ACPI_SIGNATURE(c1, c2, c3, c4)				\
 	((c1) | ((c2) << 8) | ((c3) << 16) | ((c4) << 24))
 
@@ -106,6 +112,8 @@ struct facs_descriptor_rev1
 	u8  reserved3 [40];		/* Reserved - must be zero */
 };
 
+#pragma pack(0)
+
 void set_efi_rsdp(struct rsdp_descriptor *rsdp);
 void* find_acpi_table_addr(u32 sig);
 
-- 
2.25.1

