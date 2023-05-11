Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 464B16FF656
	for <lists+kvm@lfdr.de>; Thu, 11 May 2023 17:46:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238872AbjEKPpf (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 11 May 2023 11:45:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36376 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237526AbjEKPpF (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 11 May 2023 11:45:05 -0400
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C06FA59CD;
        Thu, 11 May 2023 08:45:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1683819903; x=1715355903;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=1OCB2Pnk9ac/skfbPGWj0mlIkor+JuqIsSYNnVVKu/A=;
  b=ggm7XSvaGSGj32Wkj22ABcH/UUH8If4mQi9VOHSxIAAWyaZ6tfbP5oSb
   BAC8rD/8rauN19KawY4zf+fy3kDhxjT3iRiBaWIYkco0lNY974kCqvU0V
   3h+gyT66wgmNpYV4mmUFkRorK1UpK5I9RDtyqsBZiO4dI4H+u/pnTxg+D
   xMDfebyd/0AjwICzxV5PxUFVoT+20cjNiSHOgTXiIDWW9TPUUAqmUGzUU
   BPYaA3ZvZz+0AnSqz78i0XK1aeP0tRDOzcG7w39KzBPN1KjiQY1ZvQmoo
   S/DdsGqVbAye1Q1mKux+jPVvB0UIoVC2C3A98OynSx8JXaKfLje602TMY
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10707"; a="335046701"
X-IronPort-AV: E=Sophos;i="5.99,266,1677571200"; 
   d="scan'208";a="335046701"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 May 2023 08:44:50 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10707"; a="699776251"
X-IronPort-AV: E=Sophos;i="5.99,266,1677571200"; 
   d="scan'208";a="699776251"
Received: from rchatre-ws.ostc.intel.com ([10.54.69.144])
  by orsmga002-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 May 2023 08:44:49 -0700
From:   Reinette Chatre <reinette.chatre@intel.com>
To:     jgg@nvidia.com, yishaih@nvidia.com,
        shameerali.kolothum.thodi@huawei.com, kevin.tian@intel.com,
        alex.williamson@redhat.com
Cc:     tglx@linutronix.de, darwi@linutronix.de, kvm@vger.kernel.org,
        dave.jiang@intel.com, jing2.liu@intel.com, ashok.raj@intel.com,
        fenghua.yu@intel.com, tom.zanussi@linux.intel.com,
        reinette.chatre@intel.com, linux-kernel@vger.kernel.org
Subject: [PATCH V5 11/11] vfio/pci: Clear VFIO_IRQ_INFO_NORESIZE for MSI-X
Date:   Thu, 11 May 2023 08:44:38 -0700
Message-Id: <fd1ef2bf6ae972da8e2805bc95d5155af5a8fb0a.1683740667.git.reinette.chatre@intel.com>
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

Dynamic MSI-X is supported. Clear VFIO_IRQ_INFO_NORESIZE
to provide guidance to user space.

Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
Reviewed-by: Kevin Tian <kevin.tian@intel.com>
---
Changes since V4:
- Add Kevin's Reviewed-by tag. (Kevin)

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

