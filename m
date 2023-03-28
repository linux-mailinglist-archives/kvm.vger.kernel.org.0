Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 362546CCC61
	for <lists+kvm@lfdr.de>; Tue, 28 Mar 2023 23:55:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230143AbjC1VzC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 28 Mar 2023 17:55:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48166 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230105AbjC1Vys (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 28 Mar 2023 17:54:48 -0400
Received: from mga06.intel.com (mga06b.intel.com [134.134.136.31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0417F101;
        Tue, 28 Mar 2023 14:54:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1680040468; x=1711576468;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=u1o6u8j9j0bXGW/uy+rny+Z/wq7R1dGmviE3Tye7HEw=;
  b=Y6JgtkG/v8RHyLygeBSAvLt5/tRo3uXCqIKdkqqnofxicQyR3R85edA1
   OMVWcWDxhZ0sgX4dEwR8MqKgsaJXlrbJhST6nJv7v835sw7+xEzrvN634
   Q9HbJlvBo47ZUH8FdiDvZsW/f5QMPysz3RZ1s++mjfAV+nhxouP3UJLGV
   FbzUr5x3SdGjdYLaqlmnachR6T56pvwoHK6019h9ULHbSg5QisPo3W8hl
   pVffdzF9neglgjnTELevoEzcT3focgG3mnM/81D7Crl53ctqvV/FpRXK8
   K5qexZNpgyioDae1cUnQdGn9IAujGODckFz2Ma4dsXqVi2I6pORsq+DMY
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10663"; a="403316954"
X-IronPort-AV: E=Sophos;i="5.98,297,1673942400"; 
   d="scan'208";a="403316954"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Mar 2023 14:53:54 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10663"; a="748543792"
X-IronPort-AV: E=Sophos;i="5.98,297,1673942400"; 
   d="scan'208";a="748543792"
Received: from rchatre-ws.ostc.intel.com ([10.54.69.144])
  by fmsmga008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Mar 2023 14:53:52 -0700
From:   Reinette Chatre <reinette.chatre@intel.com>
To:     jgg@nvidia.com, yishaih@nvidia.com,
        shameerali.kolothum.thodi@huawei.com, kevin.tian@intel.com,
        alex.williamson@redhat.com
Cc:     tglx@linutronix.de, darwi@linutronix.de, kvm@vger.kernel.org,
        dave.jiang@intel.com, jing2.liu@intel.com, ashok.raj@intel.com,
        fenghua.yu@intel.com, tom.zanussi@linux.intel.com,
        reinette.chatre@intel.com, linux-kernel@vger.kernel.org
Subject: [PATCH V2 8/8] vfio/pci: Clear VFIO_IRQ_INFO_NORESIZE for MSI-X
Date:   Tue, 28 Mar 2023 14:53:35 -0700
Message-Id: <81a6066c0f0d6dfa06f41c016abfb7152064e33e.1680038771.git.reinette.chatre@intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <cover.1680038771.git.reinette.chatre@intel.com>
References: <cover.1680038771.git.reinette.chatre@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Dynamic MSI-X is supported. Clear VFIO_IRQ_INFO_NORESIZE
to provide guidance to user space.

Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
---
Changes since RFC V1:
- Only advertise VFIO_IRQ_INFO_NORESIZE for MSI-X devices that
  can actually support dynamic allocation. (Alex)

 drivers/vfio/pci/vfio_pci_core.c | 4 +++-
 include/uapi/linux/vfio.h        | 3 +++
 2 files changed, 6 insertions(+), 1 deletion(-)

diff --git a/drivers/vfio/pci/vfio_pci_core.c b/drivers/vfio/pci/vfio_pci_core.c
index ae0e161c7fc9..c679d7b59f9b 100644
--- a/drivers/vfio/pci/vfio_pci_core.c
+++ b/drivers/vfio/pci/vfio_pci_core.c
@@ -1111,7 +1111,9 @@ static int vfio_pci_ioctl_get_irq_info(struct vfio_pci_core_device *vdev,
 	if (info.index == VFIO_PCI_INTX_IRQ_INDEX)
 		info.flags |=
 			(VFIO_IRQ_INFO_MASKABLE | VFIO_IRQ_INFO_AUTOMASKED);
-	else
+	else if ((info.index != VFIO_PCI_MSIX_IRQ_INDEX) ||
+		 (info.index == VFIO_PCI_MSIX_IRQ_INDEX &&
+		  !pci_msix_can_alloc_dyn(vdev->pdev)))
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

