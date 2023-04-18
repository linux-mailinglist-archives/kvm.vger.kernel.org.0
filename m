Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C835E6E6B0D
	for <lists+kvm@lfdr.de>; Tue, 18 Apr 2023 19:30:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232674AbjDRRaG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 18 Apr 2023 13:30:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39106 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232573AbjDRR3u (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 18 Apr 2023 13:29:50 -0400
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 82AC172B8;
        Tue, 18 Apr 2023 10:29:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1681838989; x=1713374989;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=86AA1WYOs53EOz4wfSGK1F5XZP9WYHmLDplH3O/7veQ=;
  b=IKzcWnEexqI5sRUEV9cwZVLpIQ1JPpRXUG6wbCUQ80JBwz9JJDX5B3yg
   QnCCrD9Vjfg53d4C1NELrJaJOGsXh847Q3Ofe0//UVYl1lh54gPKwnOGf
   Eojfo/zU2s5CGd7omlu30Fas9jb5xFaKFT+JC7rlmZohVl5dVayfxCTs7
   gF7a03r0X1yfYPmhXD6i/LYxiq/n/BdqVNKWVbBB5wdNDw92wMb1HsKLM
   7iz7uYCGgDtahvMplt889SflaXPFZVmR+T5regAnwZ6sQ1tWsLALbP7ex
   Nec+R+/lnCGQZNxGZTkdYl+7EoNRzPZhmqavWgxNGPgQGAeNkFen4SZln
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10684"; a="410466486"
X-IronPort-AV: E=Sophos;i="5.99,207,1677571200"; 
   d="scan'208";a="410466486"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Apr 2023 10:29:43 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10684"; a="865503490"
X-IronPort-AV: E=Sophos;i="5.99,207,1677571200"; 
   d="scan'208";a="865503490"
Received: from rchatre-ws.ostc.intel.com ([10.54.69.144])
  by orsmga005-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Apr 2023 10:29:42 -0700
From:   Reinette Chatre <reinette.chatre@intel.com>
To:     jgg@nvidia.com, yishaih@nvidia.com,
        shameerali.kolothum.thodi@huawei.com, kevin.tian@intel.com,
        alex.williamson@redhat.com
Cc:     tglx@linutronix.de, darwi@linutronix.de, kvm@vger.kernel.org,
        dave.jiang@intel.com, jing2.liu@intel.com, ashok.raj@intel.com,
        fenghua.yu@intel.com, tom.zanussi@linux.intel.com,
        reinette.chatre@intel.com, linux-kernel@vger.kernel.org
Subject: [PATCH V3 08/10] vfio/pci: Probe and store ability to support dynamic MSI-X
Date:   Tue, 18 Apr 2023 10:29:19 -0700
Message-Id: <0da4830176e9c4a7877aac0611869f341dda831c.1681837892.git.reinette.chatre@intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <cover.1681837892.git.reinette.chatre@intel.com>
References: <cover.1681837892.git.reinette.chatre@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
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
index 148fd1ae6c1c..4f070f2d6fde 100644
--- a/include/linux/vfio_pci_core.h
+++ b/include/linux/vfio_pci_core.h
@@ -67,6 +67,7 @@ struct vfio_pci_core_device {
 	u8			msix_bar;
 	u16			msix_size;
 	u32			msix_offset;
+	bool			has_dyn_msix;
 	u32			rbar[7];
 	bool			pci_2_3;
 	bool			virq_disabled;
-- 
2.34.1

