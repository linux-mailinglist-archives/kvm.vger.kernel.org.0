Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A2C826F0AF0
	for <lists+kvm@lfdr.de>; Thu, 27 Apr 2023 19:36:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244446AbjD0Rgo (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 27 Apr 2023 13:36:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41102 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244439AbjD0Rg2 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 27 Apr 2023 13:36:28 -0400
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 773773AB1;
        Thu, 27 Apr 2023 10:36:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1682616987; x=1714152987;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=uWriv/HW8rBdAww/p0pd10UnWNQnafdmDWtqvgZfv90=;
  b=JD3Ff0xxIRtx/3+es2oE8szYBgehF9eGe44xPaAquzkrCxr2Rzc6UZb9
   IFNV9RfWgIUvHVA0SXYjJiqCfxPMv5NeFhKCkm4mNVvzrs8k0a55EAE59
   Iq80C4mCMOna2CokpWJ5r3NVvPs39NFQ3NyZ3qWI8MEda7Uma1wZpoN9x
   e+nXQGlUnlf3q6jM1qlImUNIQv8Z/bvDpGeUq4H0E2qC+Fz1RCw2fLTYj
   4gFsY3/pBsOZZ/nnHZ+WsNK0ZG4OX4vq/PHkoZJR4iM+qKkHj0GVv4SnL
   usoXJy7z6AsoE95pJD0hT4aE1396Yyoh+cT/MD9Weoi0aRRT8ZuUloen2
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10693"; a="349496947"
X-IronPort-AV: E=Sophos;i="5.99,232,1677571200"; 
   d="scan'208";a="349496947"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Apr 2023 10:36:22 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10693"; a="697173004"
X-IronPort-AV: E=Sophos;i="5.99,232,1677571200"; 
   d="scan'208";a="697173004"
Received: from rchatre-ws.ostc.intel.com ([10.54.69.144])
  by fmsmga007-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Apr 2023 10:36:22 -0700
From:   Reinette Chatre <reinette.chatre@intel.com>
To:     jgg@nvidia.com, yishaih@nvidia.com,
        shameerali.kolothum.thodi@huawei.com, kevin.tian@intel.com,
        alex.williamson@redhat.com
Cc:     tglx@linutronix.de, darwi@linutronix.de, kvm@vger.kernel.org,
        dave.jiang@intel.com, jing2.liu@intel.com, ashok.raj@intel.com,
        fenghua.yu@intel.com, tom.zanussi@linux.intel.com,
        reinette.chatre@intel.com, linux-kernel@vger.kernel.org
Subject: [PATCH V4 11/11] vfio/pci: Clear VFIO_IRQ_INFO_NORESIZE for MSI-X
Date:   Thu, 27 Apr 2023 10:36:08 -0700
Message-Id: <2370aaabd9c006747233df6678eed1b51ccca426.1682615447.git.reinette.chatre@intel.com>
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

Dynamic MSI-X is supported. Clear VFIO_IRQ_INFO_NORESIZE
to provide guidance to user space.

Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
---
Changes since V3:
- Remove unnecessary test from condition. (Alex)

Changes since V2:
- Use new vdev->has_dyn_msix property instead of calling
  pci_msix_can_alloc_dyn() directly. (Alex)

Changes since RFC V1:
- Only advertise VFIO_IRQ_INFO_NORESIZE for MSI-X devices that
  can actually support dynamic allocation. (Alex)

 drivers/vfio/pci/vfio_pci_core.c | 2 +-
 include/uapi/linux/vfio.h        | 3 +++
 2 files changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/vfio/pci/vfio_pci_core.c b/drivers/vfio/pci/vfio_pci_core.c
index a3635a8e54c8..ec7e662de033 100644
--- a/drivers/vfio/pci/vfio_pci_core.c
+++ b/drivers/vfio/pci/vfio_pci_core.c
@@ -1114,7 +1114,7 @@ static int vfio_pci_ioctl_get_irq_info(struct vfio_pci_core_device *vdev,
 	if (info.index == VFIO_PCI_INTX_IRQ_INDEX)
 		info.flags |=
 			(VFIO_IRQ_INFO_MASKABLE | VFIO_IRQ_INFO_AUTOMASKED);
-	else
+	else if (info.index != VFIO_PCI_MSIX_IRQ_INDEX || !vdev->has_dyn_msix)
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

