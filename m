Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C91786BBE56
	for <lists+kvm@lfdr.de>; Wed, 15 Mar 2023 22:00:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232791AbjCOVAI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 15 Mar 2023 17:00:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59140 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232648AbjCOU7s (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 15 Mar 2023 16:59:48 -0400
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EAA5E8C97A;
        Wed, 15 Mar 2023 13:59:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1678913985; x=1710449985;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=7B1A/cTDYcTxTgWo5idyY91azCfGJIiJsYGrC8xzLuY=;
  b=B2Mj7uSSnLuerG/uJoRvgVyLqqQr8Nn27VGpFolzk18MaboTDG16YFDa
   dYvgIh/OUHfe66UJigazxjPumsipXCihsJVW8d5GJEMqK/M30i/LsEsjh
   aNZrWAx/z4KJuWH6qdycTf8juXCD+YJFB6g3OUba7F/BHu6vTzsJkqy8f
   euWWu8Izuo8FT2onugR5oyWQJuWkoPKAuF1a+T9UTCwhplDrICwD2XFmg
   41oZp+mfSQNpMVhzoWntQpBHBh0CudsEjLh0eEK2ytT3SiLPpWayivrZy
   hnpSR7rwyXoOxMeTOwsP4SbPRnI11vRpvlPT20v/6Cv8xeck7egomVhzW
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10650"; a="326176540"
X-IronPort-AV: E=Sophos;i="5.98,262,1673942400"; 
   d="scan'208";a="326176540"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Mar 2023 13:59:39 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10650"; a="853747235"
X-IronPort-AV: E=Sophos;i="5.98,262,1673942400"; 
   d="scan'208";a="853747235"
Received: from rchatre-ws.ostc.intel.com ([10.54.69.144])
  by orsmga005-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Mar 2023 13:59:39 -0700
From:   Reinette Chatre <reinette.chatre@intel.com>
To:     jgg@nvidia.com, yishaih@nvidia.com,
        shameerali.kolothum.thodi@huawei.com, kevin.tian@intel.com,
        alex.williamson@redhat.com
Cc:     tglx@linutronix.de, darwi@linutronix.de, kvm@vger.kernel.org,
        dave.jiang@intel.com, jing2.liu@intel.com, ashok.raj@intel.com,
        fenghua.yu@intel.com, tom.zanussi@linux.intel.com,
        reinette.chatre@intel.com, linux-kernel@vger.kernel.org
Subject: [RFC PATCH 8/8] vfio/pci: Clear VFIO_IRQ_INFO_NORESIZE for MSI-X
Date:   Wed, 15 Mar 2023 13:59:28 -0700
Message-Id: <549e6300c0ea011cdce9a2712d49de4efd3a06b7.1678911529.git.reinette.chatre@intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <cover.1678911529.git.reinette.chatre@intel.com>
References: <cover.1678911529.git.reinette.chatre@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
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
 drivers/vfio/pci/vfio_pci_core.c | 2 +-
 include/uapi/linux/vfio.h        | 3 +++
 2 files changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/vfio/pci/vfio_pci_core.c b/drivers/vfio/pci/vfio_pci_core.c
index ae0e161c7fc9..1d071ee212a7 100644
--- a/drivers/vfio/pci/vfio_pci_core.c
+++ b/drivers/vfio/pci/vfio_pci_core.c
@@ -1111,7 +1111,7 @@ static int vfio_pci_ioctl_get_irq_info(struct vfio_pci_core_device *vdev,
 	if (info.index == VFIO_PCI_INTX_IRQ_INDEX)
 		info.flags |=
 			(VFIO_IRQ_INFO_MASKABLE | VFIO_IRQ_INFO_AUTOMASKED);
-	else
+	else if (info.index != VFIO_PCI_MSIX_IRQ_INDEX)
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

