Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ACA9C6E6B0C
	for <lists+kvm@lfdr.de>; Tue, 18 Apr 2023 19:30:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232656AbjDRRaC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 18 Apr 2023 13:30:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39184 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232590AbjDRR3v (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 18 Apr 2023 13:29:51 -0400
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 18AA2A5D3;
        Tue, 18 Apr 2023 10:29:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1681838990; x=1713374990;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=TKr20cbHjaq+vXR0di2P0v1WIRXrN40KCy9UBNZV2/c=;
  b=OZ84VT2lUOR+LTM85xRWR5y+fIllEWPZHPI/1qEOWRxYONn/ZpSB0uG3
   XnN7t6AyvDlfu8IYCylEKk01aCf8bhdTRNh6stOwfFJk1YptoSTFONHdJ
   nQPHuGLHouD4TavghUeEsfwzfkyN8WlGGiB3uum4mwPVflPQqqZ3PBz9W
   k4bxXS1K/M983RfNOo0QQdxKdy9EHxTIzwLxOx0PoVdgRn4izAmzhVF6O
   LHZi3X7oGWS7QC2CfU7vZDBFlwZu0vM1YyB7c7e5P2NUtcfEqGArCHVrk
   WHpt1LQu65rhLWBNlwp32WVNNsm2ukmIbx5mtf0zXAS8MYdNA3HmUDxZQ
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10684"; a="410466496"
X-IronPort-AV: E=Sophos;i="5.99,207,1677571200"; 
   d="scan'208";a="410466496"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Apr 2023 10:29:43 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10684"; a="865503497"
X-IronPort-AV: E=Sophos;i="5.99,207,1677571200"; 
   d="scan'208";a="865503497"
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
Subject: [PATCH V3 10/10] vfio/pci: Clear VFIO_IRQ_INFO_NORESIZE for MSI-X
Date:   Tue, 18 Apr 2023 10:29:21 -0700
Message-Id: <6c057618833a180da2147bffadb98e07cb73e045.1681837892.git.reinette.chatre@intel.com>
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

Dynamic MSI-X is supported. Clear VFIO_IRQ_INFO_NORESIZE
to provide guidance to user space.

Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
---
Changes since V2:
- Use new vdev->has_dyn_msix property instead of calling
  pci_msix_can_alloc_dyn() directly. (Alex)

Changes since RFC V1:
- Only advertise VFIO_IRQ_INFO_NORESIZE for MSI-X devices that
  can actually support dynamic allocation. (Alex)

 drivers/vfio/pci/vfio_pci_core.c | 4 +++-
 include/uapi/linux/vfio.h        | 3 +++
 2 files changed, 6 insertions(+), 1 deletion(-)

diff --git a/drivers/vfio/pci/vfio_pci_core.c b/drivers/vfio/pci/vfio_pci_core.c
index a3635a8e54c8..4050ad3388c2 100644
--- a/drivers/vfio/pci/vfio_pci_core.c
+++ b/drivers/vfio/pci/vfio_pci_core.c
@@ -1114,7 +1114,9 @@ static int vfio_pci_ioctl_get_irq_info(struct vfio_pci_core_device *vdev,
 	if (info.index == VFIO_PCI_INTX_IRQ_INDEX)
 		info.flags |=
 			(VFIO_IRQ_INFO_MASKABLE | VFIO_IRQ_INFO_AUTOMASKED);
-	else
+	else if ((info.index != VFIO_PCI_MSIX_IRQ_INDEX) ||
+		 (info.index == VFIO_PCI_MSIX_IRQ_INDEX &&
+		  !vdev->has_dyn_msix))
 		info.flags |= VFIO_IRQ_INFO_NORESIZE;
 
 	return copy_to_user(arg, &info, minsz) ? -EFAULT : 0;
diff --git a/include/uapi/linux/vfio.h b/include/uapi/linux/vfio.h
index 0552e8dcf0cb..1a36134cae5c 100644
--- a/include/uapi/linux/vfio.h
+++ b/include/uapi/linux/vfio.h
@@ -511,6 +511,9 @@ struct vfio_region_info_cap_nvlink2_lnkspd {
  * then add and unmask vectors, it's up to userspace to make the decision
  * whether to allocate the maximum supported number of vectors or tear
  * down setup and incrementally increase the vectors as each is enabled.
+ * Absence of the NORESIZE flag indicates that vectors can be enabled
+ * and disabled dynamically without impacting other vectors within the
+ * index.
  */
 struct vfio_irq_info {
 	__u32	argsz;
-- 
2.34.1

