Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AB0FD6FF651
	for <lists+kvm@lfdr.de>; Thu, 11 May 2023 17:46:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238812AbjEKPp0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 11 May 2023 11:45:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36360 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238816AbjEKPpE (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 11 May 2023 11:45:04 -0400
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9702B65A8;
        Thu, 11 May 2023 08:45:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1683819902; x=1715355902;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=+F4nj4ZYLrEfbJc9cJJHRTYr1d6jx6lUO68SKftJit4=;
  b=Zf2FXGsgRZWYNo6o6hqOxbQts1v1iUNwcwErrlmL9vBwnMDdrkh8lw3z
   yOcJ4cpzCTcvc6EjM5Dgh32sUQHnmYdNh1GMek90mblFwj2D0q67u2Pxe
   /+A2L+RCL7pvfuXzygl/dD0uBaeDlBtxBlW/IETea7y4Etgt4omqloHr+
   oxASFJa4zqs8l9EadpN9xxg0uwiDGJOpGI3Uu1sCaAO7ebM/m7PjAwy5U
   g4gtlxYogFap0Bf2+1fHbfkvwgv44Xry4m+oW05BPa+PE34HmmO669xKk
   EOpa4nkUw1bgH4zRpxXS5A5VM/0EMtebvhhFJLUt8j7Xgrn9uWc9NphYz
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10707"; a="335046692"
X-IronPort-AV: E=Sophos;i="5.99,266,1677571200"; 
   d="scan'208";a="335046692"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 May 2023 08:44:50 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10707"; a="699776245"
X-IronPort-AV: E=Sophos;i="5.99,266,1677571200"; 
   d="scan'208";a="699776245"
Received: from rchatre-ws.ostc.intel.com ([10.54.69.144])
  by orsmga002-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 May 2023 08:44:48 -0700
From:   Reinette Chatre <reinette.chatre@intel.com>
To:     jgg@nvidia.com, yishaih@nvidia.com,
        shameerali.kolothum.thodi@huawei.com, kevin.tian@intel.com,
        alex.williamson@redhat.com
Cc:     tglx@linutronix.de, darwi@linutronix.de, kvm@vger.kernel.org,
        dave.jiang@intel.com, jing2.liu@intel.com, ashok.raj@intel.com,
        fenghua.yu@intel.com, tom.zanussi@linux.intel.com,
        reinette.chatre@intel.com, linux-kernel@vger.kernel.org
Subject: [PATCH V5 09/11] vfio/pci: Probe and store ability to support dynamic MSI-X
Date:   Thu, 11 May 2023 08:44:36 -0700
Message-Id: <f1ae022c060ecb7e527f4f53c8ccafe80768da47.1683740667.git.reinette.chatre@intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <cover.1683740667.git.reinette.chatre@intel.com>
References: <cover.1683740667.git.reinette.chatre@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
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
Reviewed-by: Kevin Tian <kevin.tian@intel.com>
---
Changes since V4:
- Add Kevin's Reviewed-by tag. (Kevin)

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

