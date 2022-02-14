Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E15C24B4F9F
	for <lists+kvm@lfdr.de>; Mon, 14 Feb 2022 13:08:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231400AbiBNMFt (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 14 Feb 2022 07:05:49 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:34444 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352544AbiBNMFP (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 14 Feb 2022 07:05:15 -0500
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id A93C22ACD
        for <kvm@vger.kernel.org>; Mon, 14 Feb 2022 04:05:04 -0800 (PST)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 77A791396;
        Mon, 14 Feb 2022 04:05:04 -0800 (PST)
Received: from monolith.localdoman (unknown [172.31.20.19])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 6BB353F718;
        Mon, 14 Feb 2022 04:05:03 -0800 (PST)
From:   Alexandru Elisei <alexandru.elisei@arm.com>
To:     pbonzini@redhat.com, thuth@redhat.com, drjones@redhat.com,
        kvm@vger.kernel.org
Subject: [kvm-unit-tests PATCH] lib/devicetree: Support 64 bit addresses for the initrd
Date:   Mon, 14 Feb 2022 12:05:06 +0000
Message-Id: <20220214120506.30617-1-alexandru.elisei@arm.com>
X-Mailer: git-send-email 2.35.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-6.9 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The "linux,initrd-start" and "linux,initrd-end" properties encode the start
and end address of the initrd. The size of the address is encoded in the
root node #address-cells property and can be 1 cell (32 bits) or 2 cells
(64 bits). Add support for parsing a 64 bit address.

Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>
---
 lib/devicetree.c | 18 +++++++++++++-----
 1 file changed, 13 insertions(+), 5 deletions(-)

diff --git a/lib/devicetree.c b/lib/devicetree.c
index 409d18bedbba..7cf64309a912 100644
--- a/lib/devicetree.c
+++ b/lib/devicetree.c
@@ -288,7 +288,7 @@ int dt_get_default_console_node(void)
 int dt_get_initrd(const char **initrd, u32 *size)
 {
 	const struct fdt_property *prop;
-	const char *start, *end;
+	u64 start, end;
 	int node, len;
 	u32 *data;
 
@@ -303,7 +303,11 @@ int dt_get_initrd(const char **initrd, u32 *size)
 	if (!prop)
 		return len;
 	data = (u32 *)prop->data;
-	start = (const char *)(unsigned long)fdt32_to_cpu(*data);
+	start = fdt32_to_cpu(*data);
+	if (len == 8) {
+		data++;
+		start = (start << 32) | fdt32_to_cpu(*data);
+	}
 
 	prop = fdt_get_property(fdt, node, "linux,initrd-end", &len);
 	if (!prop) {
@@ -311,10 +315,14 @@ int dt_get_initrd(const char **initrd, u32 *size)
 		return len;
 	}
 	data = (u32 *)prop->data;
-	end = (const char *)(unsigned long)fdt32_to_cpu(*data);
+	end = fdt32_to_cpu(*data);
+	if (len == 8) {
+		data++;
+		end = (end << 32) | fdt32_to_cpu(*data);
+	}
 
-	*initrd = start;
-	*size = (unsigned long)end - (unsigned long)start;
+	*initrd = (char *)start;
+	*size = end - start;
 
 	return 0;
 }
-- 
2.35.1

