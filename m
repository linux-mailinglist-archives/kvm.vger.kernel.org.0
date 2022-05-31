Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4A02A53971A
	for <lists+kvm@lfdr.de>; Tue, 31 May 2022 21:41:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347377AbiEaTki (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 31 May 2022 15:40:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37542 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347352AbiEaTk3 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 31 May 2022 15:40:29 -0400
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 417A99AE54;
        Tue, 31 May 2022 12:40:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1654026022; x=1685562022;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=GV+VRKK1DlzSlCK/pPtCVw3nJIfF3KpkCG45l4fGnLE=;
  b=WWCoWUdifdla7r88m4FQAHSHryaB9lcKW2ZCVFGHcFrrDsdXDKp5GV/k
   J1tQKhdMKXGSgM4JdOp2wCSeTl/GGMnI5qrDfgyuoDTYWPqoX1RYhXfsG
   K3QImyxd6RcVnGg0uSdpza56ULwkPQ3jQtn8sFRVPnBDItKeFKU3hB6jL
   RjcHuSkKY067G+DWPGG3g6gjBL7D6TkcVOOIKJAq/bbiMoMbIFh67eVXr
   /HYN/GCWX/gsm5g7lQR/ijdHuXaX882Cs6UbV0klchsLZ1ZqUfjTk62Kh
   re9VcLatc50FOIpM57l+ql0thWcAugE50wS3QSP3Of/EJGG6c/DD4VpfR
   g==;
X-IronPort-AV: E=McAfee;i="6400,9594,10364"; a="272935022"
X-IronPort-AV: E=Sophos;i="5.91,266,1647327600"; 
   d="scan'208";a="272935022"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 May 2022 12:40:07 -0700
X-IronPort-AV: E=Sophos;i="5.91,266,1647327600"; 
   d="scan'208";a="645164199"
Received: from maciejwo-mobl1.ger.corp.intel.com (HELO khuang2-desk.gar.corp.intel.com) ([10.254.36.207])
  by fmsmga004-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 May 2022 12:40:03 -0700
From:   Kai Huang <kai.huang@intel.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     seanjc@google.com, pbonzini@redhat.com, dave.hansen@intel.com,
        len.brown@intel.com, tony.luck@intel.com,
        rafael.j.wysocki@intel.com, reinette.chatre@intel.com,
        dan.j.williams@intel.com, peterz@infradead.org, ak@linux.intel.com,
        kirill.shutemov@linux.intel.com,
        sathyanarayanan.kuppuswamy@linux.intel.com,
        isaku.yamahata@intel.com, kai.huang@intel.com
Subject: [PATCH v4 03/22] cc_platform: Add new attribute to prevent ACPI memory hotplug
Date:   Wed,  1 Jun 2022 07:39:26 +1200
Message-Id: <f2bdb5ad3b0076bf93289aa1a8d254decb8e3026.1654025431.git.kai.huang@intel.com>
X-Mailer: git-send-email 2.35.3
In-Reply-To: <cover.1654025430.git.kai.huang@intel.com>
References: <cover.1654025430.git.kai.huang@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Platforms with confidential computing technology may not support ACPI
memory hotplug when such technology is enabled by the BIOS.  Examples
include Intel platforms which support Intel Trust Domain Extensions
(TDX).

If the kernel ever receives ACPI memory hotplug event, it is likely a
BIOS bug.  For ACPI memory hot-add, the kernel should speak out this is
a BIOS bug and reject the new memory.  For hot-removal, for simplicity
just assume the kernel cannot continue to work normally, and just BUG().

Add a new attribute CC_ATTR_ACPI_MEMORY_HOTPLUG_DISABLED to indicate the
platform doesn't support ACPI memory hotplug, so that kernel can handle
ACPI memory hotplug events for such platform.

In acpi_memory_device_{add|remove}(), add early check against this
attribute and handle accordingly if it is set.

Signed-off-by: Kai Huang <kai.huang@intel.com>
---
 drivers/acpi/acpi_memhotplug.c | 23 +++++++++++++++++++++++
 include/linux/cc_platform.h    | 11 +++++++++++
 2 files changed, 34 insertions(+)

diff --git a/drivers/acpi/acpi_memhotplug.c b/drivers/acpi/acpi_memhotplug.c
index 24f662d8bd39..94d6354ea453 100644
--- a/drivers/acpi/acpi_memhotplug.c
+++ b/drivers/acpi/acpi_memhotplug.c
@@ -15,6 +15,7 @@
 #include <linux/acpi.h>
 #include <linux/memory.h>
 #include <linux/memory_hotplug.h>
+#include <linux/cc_platform.h>
 
 #include "internal.h"
 
@@ -291,6 +292,17 @@ static int acpi_memory_device_add(struct acpi_device *device,
 	if (!device)
 		return -EINVAL;
 
+	/*
+	 * If the confidential computing platform doesn't support ACPI
+	 * memory hotplug, the BIOS should never deliver such event to
+	 * the kernel.  Report ACPI CPU hot-add as a BIOS bug and ignore
+	 * the memory device.
+	 */
+	if (cc_platform_has(CC_ATTR_ACPI_MEMORY_HOTPLUG_DISABLED)) {
+		dev_err(&device->dev, "[BIOS bug]: Platform doesn't support ACPI memory hotplug. New memory device ignored.\n");
+		return -EINVAL;
+	}
+
 	mem_device = kzalloc(sizeof(struct acpi_memory_device), GFP_KERNEL);
 	if (!mem_device)
 		return -ENOMEM;
@@ -334,6 +346,17 @@ static void acpi_memory_device_remove(struct acpi_device *device)
 	if (!device || !acpi_driver_data(device))
 		return;
 
+	/*
+	 * The confidential computing platform is broken if ACPI memory
+	 * hot-removal isn't supported but it happened anyway.  Assume
+	 * it is not guaranteed that the kernel can continue to work
+	 * normally.  Just BUG().
+	 */
+	if (cc_platform_has(CC_ATTR_ACPI_CPU_HOTPLUG_DISABLED)) {
+		dev_err(&device->dev, "Platform doesn't support ACPI memory hotplug. BUG().\n");
+		BUG();
+	}
+
 	mem_device = acpi_driver_data(device);
 	acpi_memory_remove_memory(mem_device);
 	acpi_memory_device_free(mem_device);
diff --git a/include/linux/cc_platform.h b/include/linux/cc_platform.h
index d07cba2a722c..0ee261db1104 100644
--- a/include/linux/cc_platform.h
+++ b/include/linux/cc_platform.h
@@ -93,6 +93,17 @@ enum cc_attr {
 	 * Examples include TDX platform.
 	 */
 	CC_ATTR_ACPI_CPU_HOTPLUG_DISABLED,
+
+	/**
+	 * @CC_ATTR_ACPI_MEMORY_HOTPLUG_DISABLED: ACPI memory hotplug is
+	 *					  not supported.
+	 *
+	 * The platform/os is running does not support ACPI memory
+	 * hotplug.
+	 *
+	 * Examples include TDX platform.
+	 */
+	CC_ATTR_ACPI_MEMORY_HOTPLUG_DISABLED,
 };
 
 #ifdef CONFIG_ARCH_HAS_CC_PLATFORM
-- 
2.35.3

