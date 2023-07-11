Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6C67774E303
	for <lists+kvm@lfdr.de>; Tue, 11 Jul 2023 03:09:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231219AbjGKBJg (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 10 Jul 2023 21:09:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51384 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231137AbjGKBJe (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 10 Jul 2023 21:09:34 -0400
Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E7BC01708;
        Mon, 10 Jul 2023 18:09:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1689037746; x=1720573746;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=kDNvl2xq4daGW1gpeGo7tFuYd3E44JZ84AN2RiOMGAA=;
  b=H7jZgCo83x820b1WDmJwyrdQArT6k6hB5aKvVm/ln1+ZFfQbWrXKVIg6
   pD3Z06j7zPgxKtTDFLLR4Tr+9TA5xS/rQkHBWwBCNxI11ZMgXYiR3PKN2
   6YuGonTOdR3hJQbjyfLPmbx4zNio8TqlM6gkyH93PBMH8BE2wzYFrKMK6
   x1OxF9ltQNifACxKe90x1xnLvTlAKwKlozdBLvI/LxbucQ8sFxCGlbDH4
   h/yf3QXxRhyHrXq2MShijIkCrQFmZ2N0mfj4KhhS29zhGhIQD7wSoDTI2
   iL+1ShhHLS0XXf7ISM5OGvFkbtDvqOYecDIJlAk5WLU/rSXv1Ac8qdbHA
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10767"; a="344816151"
X-IronPort-AV: E=Sophos;i="6.01,195,1684825200"; 
   d="scan'208";a="344816151"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Jul 2023 18:09:06 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10767"; a="810999949"
X-IronPort-AV: E=Sophos;i="6.01,195,1684825200"; 
   d="scan'208";a="810999949"
Received: from allen-box.sh.intel.com ([10.239.159.127])
  by FMSMGA003.fm.intel.com with ESMTP; 10 Jul 2023 18:09:02 -0700
From:   Lu Baolu <baolu.lu@linux.intel.com>
To:     Joerg Roedel <joro@8bytes.org>, Will Deacon <will@kernel.org>,
        Robin Murphy <robin.murphy@arm.com>,
        Jason Gunthorpe <jgg@ziepe.ca>,
        Kevin Tian <kevin.tian@intel.com>,
        Jean-Philippe Brucker <jean-philippe@linaro.org>,
        Nicolin Chen <nicolinc@nvidia.com>
Cc:     Yi Liu <yi.l.liu@intel.com>,
        Jacob Pan <jacob.jun.pan@linux.intel.com>,
        iommu@lists.linux.dev, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Lu Baolu <baolu.lu@linux.intel.com>
Subject: [PATCH 8/9] iommu: Add iommu page fault cookie helpers
Date:   Tue, 11 Jul 2023 09:06:41 +0800
Message-Id: <20230711010642.19707-9-baolu.lu@linux.intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230711010642.19707-1-baolu.lu@linux.intel.com>
References: <20230711010642.19707-1-baolu.lu@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Add an xarray in iommu_fault_param as place holder for per-{device, pasid}
fault cookie. They could be used in varous cases. For example, SVA needs
to handle IO page faults through work queues to batch process all faults
in a fault group. It needs a fault cookie as a temporary storage of partial
faults, together with other meta data.

The iommufd will also use the fault cookie to store the mapping of device
object ID and a pasid of a device. This allows the iommufd to quickly
retrieve the device object ID for a given {device, pasid} pair in the hot
path of IO page fault delivery.

Signed-off-by: Lu Baolu <baolu.lu@linux.intel.com>
---
 include/linux/iommu.h | 16 ++++++++++++++++
 drivers/iommu/iommu.c | 44 +++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 60 insertions(+)

diff --git a/include/linux/iommu.h b/include/linux/iommu.h
index c86ff10b40f3..ffd6fe1317f4 100644
--- a/include/linux/iommu.h
+++ b/include/linux/iommu.h
@@ -539,10 +539,12 @@ struct iommu_fault_event {
  * struct iommu_fault_param - per-device IOMMU fault data
  * @faults: holds the pending faults which needs response
  * @lock: protect pending faults list
+ * @pasid_cookie: per-pasid fault cookie
  */
 struct iommu_fault_param {
 	struct list_head faults;
 	struct mutex lock;
+	struct xarray pasid_cookie;
 };
 
 /**
@@ -636,6 +638,8 @@ extern void iommu_set_fault_handler(struct iommu_domain *domain,
 			iommu_fault_handler_t handler, void *token);
 void iommu_domain_set_iopf_handler(struct iommu_domain *domain,
 				   iommu_iopf_handler_t handler, void *data);
+void *iommu_set_device_fault_cookie(struct device *dev, ioasid_t pasid, void *cookie);
+void *iommu_get_device_fault_cookie(struct device *dev, ioasid_t pasid);
 
 extern void iommu_get_resv_regions(struct device *dev, struct list_head *list);
 extern void iommu_put_resv_regions(struct device *dev, struct list_head *list);
@@ -965,6 +969,18 @@ static inline void iommu_domain_set_iopf_handler(struct iommu_domain *domain,
 {
 }
 
+static inline void *iommu_set_device_fault_cookie(struct device *dev,
+						  ioasid_t pasid, void *cookie)
+{
+	return ERR_PTR(-ENODEV);
+}
+
+static inline void *iommu_get_device_fault_cookie(struct device *dev,
+						  ioasid_t pasid)
+{
+	return ERR_PTR(-ENODEV);
+}
+
 static inline void iommu_get_resv_regions(struct device *dev,
 					struct list_head *list)
 {
diff --git a/drivers/iommu/iommu.c b/drivers/iommu/iommu.c
index 3dc59af24208..d52b827982a4 100644
--- a/drivers/iommu/iommu.c
+++ b/drivers/iommu/iommu.c
@@ -1336,6 +1336,50 @@ int iommu_page_response(struct device *dev,
 }
 EXPORT_SYMBOL_GPL(iommu_page_response);
 
+/**
+ * iommu_set_device_fault_cookie - Set a fault cookie for per-{device, pasid}
+ * @dev: the device to set the cookie
+ * @pasid: the pasid on this device
+ * @cookie: the opaque data
+ *
+ * Return the old cookie on success, or ERR_PTR(err#) on failure.
+ */
+void *iommu_set_device_fault_cookie(struct device *dev, ioasid_t pasid,
+				    void *cookie)
+{
+	struct iommu_fault_param *fault_param;
+	void *curr;
+
+	if (!dev->iommu || !dev->iommu->fault_param)
+		return ERR_PTR(-ENODEV);
+
+	fault_param = dev->iommu->fault_param;
+	curr = xa_store(&fault_param->pasid_cookie, pasid, cookie, GFP_KERNEL);
+
+	return xa_is_err(curr) ? ERR_PTR(xa_err(curr)) : curr;
+}
+EXPORT_SYMBOL_GPL(iommu_set_device_fault_cookie);
+
+/**
+ * iommu_get_device_fault_cookie - Get the fault cookie for {device, pasid}
+ * @dev: the device to set the cookie
+ * @pasid: the pasid on this device
+ *
+ * Return the cookie on success, or ERR_PTR(err#) on failure.
+ */
+void *iommu_get_device_fault_cookie(struct device *dev, ioasid_t pasid)
+{
+	struct iommu_fault_param *fault_param;
+
+	if (!dev->iommu || !dev->iommu->fault_param)
+		return ERR_PTR(-ENODEV);
+
+	fault_param = dev->iommu->fault_param;
+
+	return xa_load(&fault_param->pasid_cookie, pasid);
+}
+EXPORT_SYMBOL_GPL(iommu_get_device_fault_cookie);
+
 /**
  * iommu_group_id - Return ID for a group
  * @group: the group to ID
-- 
2.34.1

