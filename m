Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7A24E70BCAA
	for <lists+kvm@lfdr.de>; Mon, 22 May 2023 13:58:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233585AbjEVL6R (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 22 May 2023 07:58:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36034 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230360AbjEVL6N (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 22 May 2023 07:58:13 -0400
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 18CF2BB;
        Mon, 22 May 2023 04:58:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1684756685; x=1716292685;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=tq1GOmJD6WuTKme98Xeh7Q69MdFtHwg29DpraLcbJMg=;
  b=i+XQLAfHKd0G5JzrJB4RWYKvFDCyqtVix1ctyQ156aXp4K3CEdvmtU/x
   +4uFopB3D/oy80Mk25NJUdiaGvoH33bPz0lCkWV0TlX834J1D9+l1nZEC
   KP2i7DLKHBQm0CR67qASQ4/5CsjF/sMV1AbX26Hk1dZme6hsmxo788UXP
   1n2AQEtRCKdeEXjGtDjrgykqMIkLIvwPjfBLxjtSw4sju1eqqsj0cSKXK
   vGmrwIkaEOTsQ3PYmaZu9ITeN2UdXTbw6JHYIQr5MiCNpP9e1Eo8Aydua
   izoPZmlpa2ae903ddi0SOIEF8P/HOih8NkkZJxUjFMpw5H84NUIM2kLR3
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10717"; a="356128187"
X-IronPort-AV: E=Sophos;i="6.00,184,1681196400"; 
   d="scan'208";a="356128187"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 May 2023 04:57:58 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10717"; a="815660189"
X-IronPort-AV: E=Sophos;i="6.00,184,1681196400"; 
   d="scan'208";a="815660189"
Received: from 984fee00a4c6.jf.intel.com ([10.165.58.231])
  by fmsmga002.fm.intel.com with ESMTP; 22 May 2023 04:57:57 -0700
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
Subject: [PATCH v6 05/10] iommufd: Add iommufd_ctx_has_group()
Date:   Mon, 22 May 2023 04:57:46 -0700
Message-Id: <20230522115751.326947-6-yi.l.liu@intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230522115751.326947-1-yi.l.liu@intel.com>
References: <20230522115751.326947-1-yi.l.liu@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This adds the helper to check if any device within the given iommu_group
has been bound with the iommufd_ctx. This is helpful for the checking on
device ownership for the devices which have not been bound but cannot be
bound to any other iommufd_ctx as the iommu_group has been bound.

Tested-by: Terrence Xu <terrence.xu@intel.com>
Signed-off-by: Yi Liu <yi.l.liu@intel.com>
---
 drivers/iommu/iommufd/device.c | 30 ++++++++++++++++++++++++++++++
 include/linux/iommufd.h        |  8 ++++++++
 2 files changed, 38 insertions(+)

diff --git a/drivers/iommu/iommufd/device.c b/drivers/iommu/iommufd/device.c
index 4f9b2142274c..4571344c8508 100644
--- a/drivers/iommu/iommufd/device.c
+++ b/drivers/iommu/iommufd/device.c
@@ -98,6 +98,36 @@ struct iommufd_device *iommufd_device_bind(struct iommufd_ctx *ictx,
 }
 EXPORT_SYMBOL_NS_GPL(iommufd_device_bind, IOMMUFD);
 
+/**
+ * iommufd_ctx_has_group - True if any device within the group is bound
+ *                         to the ictx
+ * @ictx: iommufd file descriptor
+ * @group: Pointer to a physical iommu_group struct
+ *
+ * True if any device within the group has been bound to this ictx, ex. via
+ * iommufd_device_bind(), therefore implying ictx ownership of the group.
+ */
+bool iommufd_ctx_has_group(struct iommufd_ctx *ictx, struct iommu_group *group)
+{
+	struct iommufd_object *obj;
+	unsigned long index;
+
+	if (!ictx || !group)
+		return false;
+
+	xa_lock(&ictx->objects);
+	xa_for_each(&ictx->objects, index, obj) {
+		if (obj->type == IOMMUFD_OBJ_DEVICE &&
+		    container_of(obj, struct iommufd_device, obj)->group == group) {
+			xa_unlock(&ictx->objects);
+			return true;
+		}
+	}
+	xa_unlock(&ictx->objects);
+	return false;
+}
+EXPORT_SYMBOL_NS_GPL(iommufd_ctx_has_group, IOMMUFD);
+
 /**
  * iommufd_device_unbind - Undo iommufd_device_bind()
  * @idev: Device returned by iommufd_device_bind()
diff --git a/include/linux/iommufd.h b/include/linux/iommufd.h
index 1129a36a74c4..33fe57e95e42 100644
--- a/include/linux/iommufd.h
+++ b/include/linux/iommufd.h
@@ -16,6 +16,7 @@ struct page;
 struct iommufd_ctx;
 struct iommufd_access;
 struct file;
+struct iommu_group;
 
 struct iommufd_device *iommufd_device_bind(struct iommufd_ctx *ictx,
 					   struct device *dev, u32 *id);
@@ -50,6 +51,7 @@ void iommufd_ctx_get(struct iommufd_ctx *ictx);
 #if IS_ENABLED(CONFIG_IOMMUFD)
 struct iommufd_ctx *iommufd_ctx_from_file(struct file *file);
 void iommufd_ctx_put(struct iommufd_ctx *ictx);
+bool iommufd_ctx_has_group(struct iommufd_ctx *ictx, struct iommu_group *group);
 
 int iommufd_access_pin_pages(struct iommufd_access *access, unsigned long iova,
 			     unsigned long length, struct page **out_pages,
@@ -71,6 +73,12 @@ static inline void iommufd_ctx_put(struct iommufd_ctx *ictx)
 {
 }
 
+static inline bool iommufd_ctx_has_group(struct iommufd_ctx *ictx,
+					 struct iommu_group *group)
+{
+	return false;
+}
+
 static inline int iommufd_access_pin_pages(struct iommufd_access *access,
 					   unsigned long iova,
 					   unsigned long length,
-- 
2.34.1

