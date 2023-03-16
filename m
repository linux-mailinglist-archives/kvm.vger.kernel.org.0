Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 66DB56BCFB7
	for <lists+kvm@lfdr.de>; Thu, 16 Mar 2023 13:42:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230132AbjCPMmY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 16 Mar 2023 08:42:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38158 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230078AbjCPMmX (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 16 Mar 2023 08:42:23 -0400
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3877DB0BB5;
        Thu, 16 Mar 2023 05:42:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1678970542; x=1710506542;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=AEvwWlClzX1rnKaz+xfqG9UfvXCn9+h9Ct8yRH9iLyU=;
  b=akyDYj/TrtfTsI6aGEhwaW5/Zc5HK1CSUpKocK7/JrHkaR3YRTpQqxmm
   OzcuPjAQt5yGtLyFXJaY8cGowDT+vaOf12c339uVKe2fmeUf+E1gZRW44
   OUW6bOGOzDSEuBicRsiZlv8/OrZQnM2xcRo9O1EEP+cbxjxSRkgk/ICtG
   vYEAESCr9SHwd21FTybtdt5RZNygsngc00rl9rfUCneoaagH4TaGAW0tK
   zXIPvqRJTFe53nhNHi2Qjx2YGiOuVyrazxbP3GZFP9II33W9BFwSdxhev
   w438wx/nhrB7a/mN5OO/4L3yXE19dFHWqWG16RVrJFOqL9l4CSDpGwfyH
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10650"; a="321812050"
X-IronPort-AV: E=Sophos;i="5.98,265,1673942400"; 
   d="scan'208";a="321812050"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Mar 2023 05:42:09 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10650"; a="1009207887"
X-IronPort-AV: E=Sophos;i="5.98,265,1673942400"; 
   d="scan'208";a="1009207887"
Received: from 984fee00a4c6.jf.intel.com ([10.165.58.231])
  by fmsmga005.fm.intel.com with ESMTP; 16 Mar 2023 05:42:08 -0700
From:   Yi Liu <yi.l.liu@intel.com>
To:     alex.williamson@redhat.com, jgg@nvidia.com, kevin.tian@intel.com
Cc:     joro@8bytes.org, robin.murphy@arm.com, cohuck@redhat.com,
        eric.auger@redhat.com, nicolinc@nvidia.com, kvm@vger.kernel.org,
        mjrosato@linux.ibm.com, chao.p.peng@linux.intel.com,
        yi.l.liu@intel.com, yi.y.sun@linux.intel.com, peterx@redhat.com,
        jasowang@redhat.com, shameerali.kolothum.thodi@huawei.com,
        lulu@redhat.com, suravee.suthikulpanit@amd.com,
        intel-gvt-dev@lists.freedesktop.org,
        intel-gfx@lists.freedesktop.org, linux-s390@vger.kernel.org,
        xudong.hao@intel.com, yan.y.zhao@intel.com, terrence.xu@intel.com
Subject: [PATCH 2/7] vfio/pci: Only check ownership of opened devices in hot reset
Date:   Thu, 16 Mar 2023 05:41:51 -0700
Message-Id: <20230316124156.12064-3-yi.l.liu@intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230316124156.12064-1-yi.l.liu@intel.com>
References: <20230316124156.12064-1-yi.l.liu@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

If the affected device is not opened by any user, it's safe to reset it
given it's not in use.

Reviewed-by: Kevin Tian <kevin.tian@intel.com>
Signed-off-by: Yi Liu <yi.l.liu@intel.com>
---
 drivers/vfio/pci/vfio_pci_core.c | 14 +++++++++++---
 include/uapi/linux/vfio.h        |  8 ++++++++
 2 files changed, 19 insertions(+), 3 deletions(-)

diff --git a/drivers/vfio/pci/vfio_pci_core.c b/drivers/vfio/pci/vfio_pci_core.c
index 65bbef562268..5d745c9abf05 100644
--- a/drivers/vfio/pci/vfio_pci_core.c
+++ b/drivers/vfio/pci/vfio_pci_core.c
@@ -2429,10 +2429,18 @@ static int vfio_pci_dev_set_hot_reset(struct vfio_device_set *dev_set,
 
 	list_for_each_entry(cur_vma, &dev_set->device_list, vdev.dev_set_list) {
 		/*
-		 * Test whether all the affected devices are contained by the
-		 * set of groups provided by the user.
+		 * Test whether all the affected devices can be reset by the
+		 * user.
+		 *
+		 * Resetting an unused device (not opened) is safe, because
+		 * dev_set->lock is held in hot reset path so this device
+		 * cannot race being opened by another user simultaneously.
+		 *
+		 * Otherwise all opened devices in the dev_set must be
+		 * contained by the set of groups provided by the user.
 		 */
-		if (!vfio_dev_in_groups(cur_vma, groups)) {
+		if (cur_vma->vdev.open_count &&
+		    !vfio_dev_in_groups(cur_vma, groups)) {
 			ret = -EINVAL;
 			goto err_undo;
 		}
diff --git a/include/uapi/linux/vfio.h b/include/uapi/linux/vfio.h
index 0552e8dcf0cb..f96e5689cffc 100644
--- a/include/uapi/linux/vfio.h
+++ b/include/uapi/linux/vfio.h
@@ -673,6 +673,14 @@ struct vfio_pci_hot_reset_info {
  * VFIO_DEVICE_PCI_HOT_RESET - _IOW(VFIO_TYPE, VFIO_BASE + 13,
  *				    struct vfio_pci_hot_reset)
  *
+ * Userspace requests hot reset for the devices it uses.  Due to the
+ * underlying topology, multiple devices can be affected in the reset
+ * while some might be opened by another user.  To avoid interference
+ * the calling user must ensure all affected devices, if opened, are
+ * owned by itself.
+ *
+ * The ownership is proved by an array of group fds.
+ *
  * Return: 0 on success, -errno on failure.
  */
 struct vfio_pci_hot_reset {
-- 
2.34.1

