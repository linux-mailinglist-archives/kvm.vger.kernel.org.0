Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0F6707579DE
	for <lists+kvm@lfdr.de>; Tue, 18 Jul 2023 12:56:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231837AbjGRK4K (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 18 Jul 2023 06:56:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53694 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231698AbjGRKzv (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 18 Jul 2023 06:55:51 -0400
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7EC4010E4;
        Tue, 18 Jul 2023 03:55:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1689677749; x=1721213749;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=EWiBEHRsg5mOdeIGrk7v2bxlQYc8MQMuKZq0KXdeifc=;
  b=QVk/Xuo576z4Ie1WywkSMsT/x8Pt1KpkOXKyGaMt7SDXHSOnnAnpXmrN
   nJtLmRcGC5A8phamtM81CckjN2YlZuB0kuZQcetUFRrdYRNTiWfyZ2T+D
   r8M9e6i5NVdU2NG2TI6WmCrfhT+Xi0JWlYqlba1rmsGZ0qftEJl94ezrh
   RcwtqbLkptO7gtxu3F5tEsi+7JMJZwBLKFDVWPahIbaMdQY5dQ/MijTR7
   BcBT+8gN87c1w55pog5mYhs+TunbGwMNn1OnTMY7cNxRrdVwLnhDQ1ZNo
   HhLQ0Ox81y2S1+OiL8axRbGmE4pA9I0xzac8l0HS/soaOc3GIkiR1PLip
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10774"; a="452553582"
X-IronPort-AV: E=Sophos;i="6.01,214,1684825200"; 
   d="scan'208";a="452553582"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Jul 2023 03:55:47 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10774"; a="673863814"
X-IronPort-AV: E=Sophos;i="6.01,214,1684825200"; 
   d="scan'208";a="673863814"
Received: from 984fee00a4c6.jf.intel.com ([10.165.58.231])
  by orsmga003.jf.intel.com with ESMTP; 18 Jul 2023 03:55:47 -0700
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
        xudong.hao@intel.com, yan.y.zhao@intel.com, terrence.xu@intel.com,
        yanting.jiang@intel.com, zhenzhong.duan@intel.com,
        clegoate@redhat.com
Subject: [PATCH v10 07/10] vfio: Add helper to search vfio_device in a dev_set
Date:   Tue, 18 Jul 2023 03:55:39 -0700
Message-Id: <20230718105542.4138-8-yi.l.liu@intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230718105542.4138-1-yi.l.liu@intel.com>
References: <20230718105542.4138-1-yi.l.liu@intel.com>
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

There are drivers that need to search vfio_device within a given dev_set.
e.g. vfio-pci. So add a helper.

vfio_pci_is_device_in_set() now returns -EBUSY in commit a882c16a2b7e
("vfio/pci: Change vfio_pci_try_bus_reset() to use the dev_set") where
it was trying to preserve the return of vfio_pci_try_zap_and_vma_lock_cb().
However, it makes more sense to return -ENODEV.

Suggested-by: Alex Williamson <alex.williamson@redhat.com>
Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>
Tested-by: Yanting Jiang <yanting.jiang@intel.com>
Tested-by: Terrence Xu <terrence.xu@intel.com>
Tested-by: Zhenzhong Duan <zhenzhong.duan@intel.com>
Signed-off-by: Yi Liu <yi.l.liu@intel.com>
---
 drivers/vfio/pci/vfio_pci_core.c |  6 +-----
 drivers/vfio/vfio_main.c         | 15 +++++++++++++++
 include/linux/vfio.h             |  3 +++
 3 files changed, 19 insertions(+), 5 deletions(-)

diff --git a/drivers/vfio/pci/vfio_pci_core.c b/drivers/vfio/pci/vfio_pci_core.c
index 3d595ad2ed0a..5b5316a5484a 100644
--- a/drivers/vfio/pci/vfio_pci_core.c
+++ b/drivers/vfio/pci/vfio_pci_core.c
@@ -2377,12 +2377,8 @@ static bool vfio_dev_in_groups(struct vfio_pci_core_device *vdev,
 static int vfio_pci_is_device_in_set(struct pci_dev *pdev, void *data)
 {
 	struct vfio_device_set *dev_set = data;
-	struct vfio_device *cur;
 
-	list_for_each_entry(cur, &dev_set->device_list, dev_set_list)
-		if (cur->dev == &pdev->dev)
-			return 0;
-	return -EBUSY;
+	return vfio_find_device_in_devset(dev_set, &pdev->dev) ? 0 : -ENODEV;
 }
 
 /*
diff --git a/drivers/vfio/vfio_main.c b/drivers/vfio/vfio_main.c
index f0ca33b2e1df..ab4f3a794f78 100644
--- a/drivers/vfio/vfio_main.c
+++ b/drivers/vfio/vfio_main.c
@@ -141,6 +141,21 @@ unsigned int vfio_device_set_open_count(struct vfio_device_set *dev_set)
 }
 EXPORT_SYMBOL_GPL(vfio_device_set_open_count);
 
+struct vfio_device *
+vfio_find_device_in_devset(struct vfio_device_set *dev_set,
+			   struct device *dev)
+{
+	struct vfio_device *cur;
+
+	lockdep_assert_held(&dev_set->lock);
+
+	list_for_each_entry(cur, &dev_set->device_list, dev_set_list)
+		if (cur->dev == dev)
+			return cur;
+	return NULL;
+}
+EXPORT_SYMBOL_GPL(vfio_find_device_in_devset);
+
 /*
  * Device objects - create, release, get, put, search
  */
diff --git a/include/linux/vfio.h b/include/linux/vfio.h
index 2a45853773a6..ee120d2d530b 100644
--- a/include/linux/vfio.h
+++ b/include/linux/vfio.h
@@ -244,6 +244,9 @@ void vfio_unregister_group_dev(struct vfio_device *device);
 
 int vfio_assign_device_set(struct vfio_device *device, void *set_id);
 unsigned int vfio_device_set_open_count(struct vfio_device_set *dev_set);
+struct vfio_device *
+vfio_find_device_in_devset(struct vfio_device_set *dev_set,
+			   struct device *dev);
 
 int vfio_mig_get_next_state(struct vfio_device *device,
 			    enum vfio_device_mig_state cur_fsm,
-- 
2.34.1

