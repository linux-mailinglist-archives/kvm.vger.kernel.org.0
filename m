Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 673796F0AFA
	for <lists+kvm@lfdr.de>; Thu, 27 Apr 2023 19:37:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244530AbjD0Rgz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 27 Apr 2023 13:36:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41096 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244438AbjD0Rg2 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 27 Apr 2023 13:36:28 -0400
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4BA033584;
        Thu, 27 Apr 2023 10:36:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1682616987; x=1714152987;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=XwAG5SNcH6mS98HHUVIWrH5rxfGqTd4FpZ6wJI2ZqM0=;
  b=SGlm86QLZl96RbZukkNnEm2Z+qAXh0v/Pgo6/lYpG1d+qvJAvZfVKsVi
   h7+nXt6IxFWaz0h0sw90BrZrihcwDFOCSVm/jmFlV8A4hdVivMjG2dLn4
   mvxT8aW5wbGzhYYfwJR2yyGX2qSKAQOlJeFeOM7smFat2dq1hGuRYo1xL
   fAUdeejxw81+4pes9YIT4/xIR3SkEWyuJ8kqKJXwBRfEidWhuZ1raPy+y
   gkP/tUX2V5NbMGZfGtAO1BBFYRpG+34MZqEV8NorLtFN75fw7ys/jYmbt
   zXmOE1d0Gzc6k8lCvrUmdqHB1uB0HDZv6ZvkDFs8IfTnhZ3kM/wuqShBW
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10693"; a="349496928"
X-IronPort-AV: E=Sophos;i="5.99,232,1677571200"; 
   d="scan'208";a="349496928"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Apr 2023 10:36:22 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10693"; a="697172994"
X-IronPort-AV: E=Sophos;i="5.99,232,1677571200"; 
   d="scan'208";a="697172994"
Received: from rchatre-ws.ostc.intel.com ([10.54.69.144])
  by fmsmga007-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Apr 2023 10:36:21 -0700
From:   Reinette Chatre <reinette.chatre@intel.com>
To:     jgg@nvidia.com, yishaih@nvidia.com,
        shameerali.kolothum.thodi@huawei.com, kevin.tian@intel.com,
        alex.williamson@redhat.com
Cc:     tglx@linutronix.de, darwi@linutronix.de, kvm@vger.kernel.org,
        dave.jiang@intel.com, jing2.liu@intel.com, ashok.raj@intel.com,
        fenghua.yu@intel.com, tom.zanussi@linux.intel.com,
        reinette.chatre@intel.com, linux-kernel@vger.kernel.org
Subject: [PATCH V4 09/11] vfio/pci: Probe and store ability to support dynamic MSI-X
Date:   Thu, 27 Apr 2023 10:36:06 -0700
Message-Id: <db312ebdcf31d61b8d443d8894f1add443399072.1682615447.git.reinette.chatre@intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <cover.1682615447.git.reinette.chatre@intel.com>
References: <cover.1682615447.git.reinette.chatre@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Not all MSI-X devices support dynamic MSI-X allocation. Whether
a device supports dynamic MSI-X should be queried using
pci_msix_can_alloc_dyn().

Instead of scattering code with pci_msix_can_alloc_dyn(),
probe this ability once and store it as a property of the
virtual device.

Suggested-by: Alex Williamson <alex.williamson@redhat.com>
Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
---
Changes since V3:
- Move field to improve structure layout. (Alex)
- Use bitfield. (Jason)

Changes since V2:
- New patch. (Alex)

 drivers/vfio/pci/vfio_pci_core.c | 5 ++++-
 include/linux/vfio_pci_core.h    | 1 +
 2 files changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/vfio/pci/vfio_pci_core.c b/drivers/vfio/pci/vfio_pci_core.c
index ae0e161c7fc9..a3635a8e54c8 100644
--- a/drivers/vfio/pci/vfio_pci_core.c
+++ b/drivers/vfio/pci/vfio_pci_core.c
@@ -530,8 +530,11 @@ int vfio_pci_core_enable(struct vfio_pci_core_device *vdev)
 		vdev->msix_bar = table & PCI_MSIX_TABLE_BIR;
 		vdev->msix_offset = table & PCI_MSIX_TABLE_OFFSET;
 		vdev->msix_size = ((flags & PCI_MSIX_FLAGS_QSIZE) + 1) * 16;
-	} else
+		vdev->has_dyn_msix = pci_msix_can_alloc_dyn(pdev);
+	} else {
 		vdev->msix_bar = 0xFF;
+		vdev->has_dyn_msix = false;
+	}
 
 	if (!vfio_vga_disabled() && vfio_pci_is_vga(pdev))
 		vdev->has_vga = true;
diff --git a/include/linux/vfio_pci_core.h b/include/linux/vfio_pci_core.h
index adb47e2914d7..562e8754869d 100644
--- a/include/linux/vfio_pci_core.h
+++ b/include/linux/vfio_pci_core.h
@@ -68,6 +68,7 @@ struct vfio_pci_core_device {
 	u16			msix_size;
 	u32			msix_offset;
 	u32			rbar[7];
+	bool			has_dyn_msix:1;
 	bool			pci_2_3:1;
 	bool			virq_disabled:1;
 	bool			reset_works:1;
-- 
2.34.1

