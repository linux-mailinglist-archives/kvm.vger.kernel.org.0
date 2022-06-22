Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ADCB555484A
	for <lists+kvm@lfdr.de>; Wed, 22 Jun 2022 14:13:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1357028AbiFVLQB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 22 Jun 2022 07:16:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55316 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1356938AbiFVLP6 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 22 Jun 2022 07:15:58 -0400
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DBEA93A71C;
        Wed, 22 Jun 2022 04:15:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1655896557; x=1687432557;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=c2cDWRUotXGzh7Jz0IL/B+4+Jjak9b59vmSYGksHapI=;
  b=I6VfN0N67nn8vryf7sJcbql5OiZJGVINae4aGN+TQlMP8B9kQyX6sWIx
   ba65nKc/DPSwytvX52L1rhYnAnaEfPfiO2l17lhrbxMfXeTzS6nwW08DN
   Vnh8DhjnXMGag7cJEmsc6PMU94LDRW2CJDzgGBLTCGTcxdkCtM4frr7eD
   Oop7GmQSqcpZDV5E55l5C6RKDKUgj7PxMsnVUadznvTaVRsY9MIWUt7Ho
   QGAM7SA21HAfHAG5tvO3zYSE19ciNRH4Otv2BhB7QSTzQtq49UrmfttJ9
   xfXNTt4uC7YVJEs78aWSFUCvnUUu5czTS1Nb5YJNFbLrywAd5zbMDd+mf
   Q==;
X-IronPort-AV: E=McAfee;i="6400,9594,10385"; a="305840749"
X-IronPort-AV: E=Sophos;i="5.92,212,1650956400"; 
   d="scan'208";a="305840749"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Jun 2022 04:15:57 -0700
X-IronPort-AV: E=Sophos;i="5.92,212,1650956400"; 
   d="scan'208";a="730301933"
Received: from jmatsis-mobl.amr.corp.intel.com (HELO khuang2-desk.gar.corp.intel.com) ([10.209.178.197])
  by fmsmga001-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Jun 2022 04:15:52 -0700
From:   Kai Huang <kai.huang@intel.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     linux-acpi@vger.kernel.org, seanjc@google.com, pbonzini@redhat.com,
        dave.hansen@intel.com, len.brown@intel.com, tony.luck@intel.com,
        rafael.j.wysocki@intel.com, reinette.chatre@intel.com,
        dan.j.williams@intel.com, peterz@infradead.org, ak@linux.intel.com,
        kirill.shutemov@linux.intel.com,
        sathyanarayanan.kuppuswamy@linux.intel.com,
        isaku.yamahata@intel.com, thomas.lendacky@amd.com,
        Tianyu.Lan@microsoft.com, rdunlap@infradead.org, Jason@zx2c4.com,
        juri.lelli@redhat.com, mark.rutland@arm.com, frederic@kernel.org,
        yuehaibing@huawei.com, dongli.zhang@oracle.com, kai.huang@intel.com
Subject: [PATCH v5 02/22] cc_platform: Add new attribute to prevent ACPI CPU hotplug
Date:   Wed, 22 Jun 2022 23:15:43 +1200
Message-Id: <f4bff93d83814ea1f54494f51ce3e5d954cf0f5b.1655894131.git.kai.huang@intel.com>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <cover.1655894131.git.kai.huang@intel.com>
References: <cover.1655894131.git.kai.huang@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Platforms with confidential computing technology may not support ACPI
CPU hotplug when such technology is enabled by the BIOS.  Examples
include Intel platforms which support Intel Trust Domain Extensions
(TDX).

If the kernel ever receives ACPI CPU hotplug event, it is likely a BIOS
bug.  For ACPI CPU hot-add, the kernel should speak out this is a BIOS
bug and reject the new CPU.  For hot-removal, for simplicity just assume
the kernel cannot continue to work normally, and BUG().

Add a new attribute CC_ATTR_ACPI_CPU_HOTPLUG_DISABLED to indicate the
platform doesn't support ACPI CPU hotplug, so that kernel can handle
ACPI CPU hotplug events for such platform.  The existing attribute
CC_ATTR_HOTPLUG_DISABLED is for software CPU hotplug thus doesn't fit.

In acpi_processor_{add|remove}(), add early check against this attribute
and handle accordingly if it is set.

Also take this chance to rename existing CC_ATTR_HOTPLUG_DISABLED to
CC_ATTR_CPU_HOTPLUG_DISABLED as it is for software CPU hotplug.

Signed-off-by: Kai Huang <kai.huang@intel.com>
---
 arch/x86/coco/core.c          |  2 +-
 drivers/acpi/acpi_processor.c | 23 +++++++++++++++++++++++
 include/linux/cc_platform.h   | 15 +++++++++++++--
 kernel/cpu.c                  |  2 +-
 4 files changed, 38 insertions(+), 4 deletions(-)

diff --git a/arch/x86/coco/core.c b/arch/x86/coco/core.c
index 4320fadae716..1bde1af75296 100644
--- a/arch/x86/coco/core.c
+++ b/arch/x86/coco/core.c
@@ -20,7 +20,7 @@ static bool intel_cc_platform_has(enum cc_attr attr)
 {
 	switch (attr) {
 	case CC_ATTR_GUEST_UNROLL_STRING_IO:
-	case CC_ATTR_HOTPLUG_DISABLED:
+	case CC_ATTR_CPU_HOTPLUG_DISABLED:
 	case CC_ATTR_GUEST_MEM_ENCRYPT:
 	case CC_ATTR_MEM_ENCRYPT:
 		return true;
diff --git a/drivers/acpi/acpi_processor.c b/drivers/acpi/acpi_processor.c
index 6737b1cbf6d6..b960db864cd4 100644
--- a/drivers/acpi/acpi_processor.c
+++ b/drivers/acpi/acpi_processor.c
@@ -15,6 +15,7 @@
 #include <linux/kernel.h>
 #include <linux/module.h>
 #include <linux/pci.h>
+#include <linux/cc_platform.h>
 
 #include <acpi/processor.h>
 
@@ -357,6 +358,17 @@ static int acpi_processor_add(struct acpi_device *device,
 	struct device *dev;
 	int result = 0;
 
+	/*
+	 * If the confidential computing platform doesn't support ACPI
+	 * memory hotplug, the BIOS should never deliver such event to
+	 * the kernel.  Report ACPI CPU hot-add as a BIOS bug and ignore
+	 * the new CPU.
+	 */
+	if (cc_platform_has(CC_ATTR_ACPI_CPU_HOTPLUG_DISABLED)) {
+		dev_err(&device->dev, "[BIOS bug]: Platform doesn't support ACPI CPU hotplug.  New CPU ignored.\n");
+		return -EINVAL;
+	}
+
 	pr = kzalloc(sizeof(struct acpi_processor), GFP_KERNEL);
 	if (!pr)
 		return -ENOMEM;
@@ -434,6 +446,17 @@ static void acpi_processor_remove(struct acpi_device *device)
 	if (!device || !acpi_driver_data(device))
 		return;
 
+	/*
+	 * The confidential computing platform is broken if ACPI memory
+	 * hot-removal isn't supported but it happened anyway.  Assume
+	 * it's not guaranteed that the kernel can continue to work
+	 * normally.  Just BUG().
+	 */
+	if (cc_platform_has(CC_ATTR_ACPI_CPU_HOTPLUG_DISABLED)) {
+		dev_err(&device->dev, "Platform doesn't support ACPI CPU hotplug. BUG().\n");
+		BUG();
+	}
+
 	pr = acpi_driver_data(device);
 	if (pr->id >= nr_cpu_ids)
 		goto out;
diff --git a/include/linux/cc_platform.h b/include/linux/cc_platform.h
index 691494bbaf5a..9ce9256facc8 100644
--- a/include/linux/cc_platform.h
+++ b/include/linux/cc_platform.h
@@ -74,14 +74,25 @@ enum cc_attr {
 	CC_ATTR_GUEST_UNROLL_STRING_IO,
 
 	/**
-	 * @CC_ATTR_HOTPLUG_DISABLED: Hotplug is not supported or disabled.
+	 * @CC_ATTR_CPU_HOTPLUG_DISABLED: CPU hotplug is not supported or
+	 *				  disabled.
 	 *
 	 * The platform/OS is running as a guest/virtual machine does not
 	 * support CPU hotplug feature.
 	 *
 	 * Examples include TDX Guest.
 	 */
-	CC_ATTR_HOTPLUG_DISABLED,
+	CC_ATTR_CPU_HOTPLUG_DISABLED,
+
+	/**
+	 * @CC_ATTR_ACPI_CPU_HOTPLUG_DISABLED: ACPI CPU hotplug is not
+	 *				       supported.
+	 *
+	 * The platform/OS does not support ACPI CPU hotplug.
+	 *
+	 * Examples include TDX platform.
+	 */
+	CC_ATTR_ACPI_CPU_HOTPLUG_DISABLED,
 };
 
 #ifdef CONFIG_ARCH_HAS_CC_PLATFORM
diff --git a/kernel/cpu.c b/kernel/cpu.c
index edb8c199f6a3..966772cce063 100644
--- a/kernel/cpu.c
+++ b/kernel/cpu.c
@@ -1191,7 +1191,7 @@ static int cpu_down_maps_locked(unsigned int cpu, enum cpuhp_state target)
 	 * If the platform does not support hotplug, report it explicitly to
 	 * differentiate it from a transient offlining failure.
 	 */
-	if (cc_platform_has(CC_ATTR_HOTPLUG_DISABLED))
+	if (cc_platform_has(CC_ATTR_CPU_HOTPLUG_DISABLED))
 		return -EOPNOTSUPP;
 	if (cpu_hotplug_disabled)
 		return -EBUSY;
-- 
2.36.1

