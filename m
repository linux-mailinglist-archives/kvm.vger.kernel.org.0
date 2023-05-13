Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 858707016FC
	for <lists+kvm@lfdr.de>; Sat, 13 May 2023 15:21:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238612AbjEMNV4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 13 May 2023 09:21:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54300 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238316AbjEMNVv (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 13 May 2023 09:21:51 -0400
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 41D251FED;
        Sat, 13 May 2023 06:21:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1683984110; x=1715520110;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=JPKn3Comiif0UnOhEse9L3Rl82bLgc6qyUnZga0nLkQ=;
  b=AV6IdomyiFr60Hr4OW9BxXUccV3qquY4ciLWVGHpGElb6DZhbI4WeuOP
   wNbRYJeHKPJSfyKr6AqDsZYJgkXjGC/plhjwgjH4Y3njoeI8dl9ffpsty
   vZIuSeaIMB2/Ol3Mz+0rw0dVd4mi+BRkBfSLvfhJT4NQn5J26SKR0XOTf
   f8zSykzMHnbHYE2YLP2imJzSwt3DE24Fg31iUNe4vMTt5SNOi6nzmcGdp
   jsmhWrrCYDBryMFskGbmMiYSgmzG7wiHmLKrwDE7LTrwCFDVNOnldu9kU
   05Gp/rJEu+RkyANjkRpqIsIHSppHm5Z4n6rEB5G0WegAO7LuLlUme8tVD
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10708"; a="416599028"
X-IronPort-AV: E=Sophos;i="5.99,272,1677571200"; 
   d="scan'208";a="416599028"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 May 2023 06:21:49 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10708"; a="790126468"
X-IronPort-AV: E=Sophos;i="5.99,272,1677571200"; 
   d="scan'208";a="790126468"
Received: from 984fee00a4c6.jf.intel.com ([10.165.58.231])
  by FMSMGA003.fm.intel.com with ESMTP; 13 May 2023 06:21:48 -0700
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
Subject: [PATCH v5 08/10] iommufd: Add iommufd_ctx_has_group()
Date:   Sat, 13 May 2023 06:21:34 -0700
Message-Id: <20230513132136.15021-9-yi.l.liu@intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230513132136.15021-1-yi.l.liu@intel.com>
References: <20230513132136.15021-1-yi.l.liu@intel.com>
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

to check if any device within the given iommu_group has been bound with
the iommufd_ctx. This helpful for the checking on device ownership for
the devices which have been bound but cannot be bound to any other iommufd
as the iommu_group has been bound.

Signed-off-by: Yi Liu <yi.l.liu@intel.com>
---
 drivers/iommu/iommufd/device.c | 29 +++++++++++++++++++++++++++++
 include/linux/iommufd.h        |  8 ++++++++
 2 files changed, 37 insertions(+)

diff --git a/drivers/iommu/iommufd/device.c b/drivers/iommu/iommufd/device.c
index 81466b97023f..5e5f7912807b 100644
--- a/drivers/iommu/iommufd/device.c
+++ b/drivers/iommu/iommufd/device.c
@@ -98,6 +98,35 @@ struct iommufd_device *iommufd_device_bind(struct iommufd_ctx *ictx,
 }
 EXPORT_SYMBOL_NS_GPL(iommufd_device_bind, IOMMUFD);
 
+/**
+ * iommufd_ctx_has_group - True if the struct device is bound to this ictx
+ * @ictx: iommufd file descriptor
+ * @group: Pointer to a physical iommu_group struct
+ *
+ * True if a iommufd_device_bind() is present for any device within the
+ * group.
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
index 68cd65274e28..e49c16cd6831 100644
--- a/include/linux/iommufd.h
+++ b/include/linux/iommufd.h
@@ -16,6 +16,7 @@ struct page;
 struct iommufd_ctx;
 struct iommufd_access;
 struct file;
+struct iommu_group;
 
 struct iommufd_device *iommufd_device_bind(struct iommufd_ctx *ictx,
 					   struct device *dev, u32 *id);
@@ -56,6 +57,7 @@ void iommufd_ctx_get(struct iommufd_ctx *ictx);
 #if IS_ENABLED(CONFIG_IOMMUFD)
 struct iommufd_ctx *iommufd_ctx_from_file(struct file *file);
 void iommufd_ctx_put(struct iommufd_ctx *ictx);
+bool iommufd_ctx_has_group(struct iommufd_ctx *ictx, struct iommu_group *group);
 
 int iommufd_access_pin_pages(struct iommufd_access *access, unsigned long iova,
 			     unsigned long length, struct page **out_pages,
@@ -77,6 +79,12 @@ static inline void iommufd_ctx_put(struct iommufd_ctx *ictx)
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

