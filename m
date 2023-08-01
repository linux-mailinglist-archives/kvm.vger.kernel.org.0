Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BC47776A93D
	for <lists+kvm@lfdr.de>; Tue,  1 Aug 2023 08:34:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231846AbjHAGec (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 1 Aug 2023 02:34:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45632 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231742AbjHAGeY (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 1 Aug 2023 02:34:24 -0400
Received: from mgamail.intel.com (unknown [134.134.136.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4D70F1FFE;
        Mon, 31 Jul 2023 23:34:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1690871644; x=1722407644;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=TmQOj4iLTqJpFp8MSsuwD21k8KlbkD0tFWAuvpU6ezU=;
  b=MINW39LukKejgk4a9kCEMAezpmgKX2EPibfXVa2Psl3M1MWWgOtVXFou
   0k27dfycHAlnUwJTIVXEtMwKyhK+L5h7w3RAn387Wo9q4aFCMBklW26s/
   igPKg9cWnmdIryCxuP5XeKcZ1go6cOyz5bUYCyjvbRX/xEm/xQBlg/zaE
   asZjJg4FWBgpQ31/nh5pKSW8+98wwU3kdRLuQBvUe9rUwYReNYo2ls4ML
   hAHyDZvCI1tCtT1VS377UxFEitOBFWLG5AGW1PmRFJ7xqCW5o4c5+8JC7
   fFsqC98OrDXPw4xL7hGfMoPdz480ugojKGVlZkly1EXholudsaF6Mfw6c
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10788"; a="372839988"
X-IronPort-AV: E=Sophos;i="6.01,246,1684825200"; 
   d="scan'208";a="372839988"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 Jul 2023 23:33:43 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10788"; a="798537925"
X-IronPort-AV: E=Sophos;i="6.01,246,1684825200"; 
   d="scan'208";a="798537925"
Received: from allen-box.sh.intel.com ([10.239.159.127])
  by fmsmga004.fm.intel.com with ESMTP; 31 Jul 2023 23:33:40 -0700
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
Subject: [PATCH 2/2] iommu: Move pasid array from group to device
Date:   Tue,  1 Aug 2023 14:31:25 +0800
Message-Id: <20230801063125.34995-3-baolu.lu@linux.intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230801063125.34995-1-baolu.lu@linux.intel.com>
References: <20230801063125.34995-1-baolu.lu@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_BLOCKED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The PASID (Process Address Space ID) feature is a device feature that
allows a device driver to manage the PASID value and attach or detach
its domain to the pasid. The pasid array, which is used to store the
domain of each pasid, is currently stored in iommu group struct, but
it would be more natural to move it to the device so that the device
drivers don't need to understand the internal iommu group concept.

Signed-off-by: Lu Baolu <baolu.lu@linux.intel.com>
---
 include/linux/iommu.h |  2 ++
 drivers/iommu/iommu.c | 80 ++++++++++++-------------------------------
 2 files changed, 24 insertions(+), 58 deletions(-)

diff --git a/include/linux/iommu.h b/include/linux/iommu.h
index b1dcb1b9b170..90be3efd0e91 100644
--- a/include/linux/iommu.h
+++ b/include/linux/iommu.h
@@ -406,6 +406,7 @@ struct iommu_fault_param {
  * @iopf_param:	 I/O Page Fault queue and data
  * @fwspec:	 IOMMU fwspec data
  * @iommu_dev:	 IOMMU device this device is linked to
+ * @pasid_array: pasid-indexed array of domains attached to pasid
  * @priv:	 IOMMU Driver private data
  * @max_pasids:  number of PASIDs this device can consume
  * @attach_deferred: the dma domain attachment is deferred
@@ -420,6 +421,7 @@ struct dev_iommu {
 	struct iopf_device_param	*iopf_param;
 	struct iommu_fwspec		*fwspec;
 	struct iommu_device		*iommu_dev;
+	struct xarray			pasid_array;
 	void				*priv;
 	u32				max_pasids;
 	u32				attach_deferred:1;
diff --git a/drivers/iommu/iommu.c b/drivers/iommu/iommu.c
index 1a8fb30341e6..7fd53b9e9754 100644
--- a/drivers/iommu/iommu.c
+++ b/drivers/iommu/iommu.c
@@ -48,7 +48,6 @@ struct iommu_group {
 	struct kobject kobj;
 	struct kobject *devices_kobj;
 	struct list_head devices;
-	struct xarray pasid_array;
 	struct mutex mutex;
 	void *iommu_data;
 	void (*iommu_data_release)(void *iommu_data);
@@ -302,6 +301,7 @@ static struct dev_iommu *dev_iommu_get(struct device *dev)
 		return NULL;
 
 	mutex_init(&param->lock);
+	xa_init(&param->pasid_array);
 	dev->iommu = param;
 	return param;
 }
@@ -891,7 +891,6 @@ struct iommu_group *iommu_group_alloc(void)
 	mutex_init(&group->mutex);
 	INIT_LIST_HEAD(&group->devices);
 	INIT_LIST_HEAD(&group->entry);
-	xa_init(&group->pasid_array);
 
 	ret = ida_alloc(&iommu_group_ida, GFP_KERNEL);
 	if (ret < 0) {
@@ -3041,8 +3040,11 @@ static bool iommu_is_default_domain(struct iommu_group *group)
  */
 static void assert_pasid_dma_ownership(struct iommu_group *group)
 {
+	struct group_device *device;
+
 	lockdep_assert_held(&group->mutex);
-	WARN_ON(!xa_empty(&group->pasid_array));
+	for_each_group_device(group, device)
+		WARN_ON(!xa_empty(&device->dev->iommu->pasid_array));
 }
 
 /**
@@ -3281,33 +3283,6 @@ bool iommu_group_dma_owner_claimed(struct iommu_group *group)
 }
 EXPORT_SYMBOL_GPL(iommu_group_dma_owner_claimed);
 
-static int __iommu_set_group_pasid(struct iommu_domain *domain,
-				   struct iommu_group *group, ioasid_t pasid)
-{
-	struct group_device *device;
-	int ret = 0;
-
-	for_each_group_device(group, device) {
-		ret = domain->ops->set_dev_pasid(domain, device->dev, pasid);
-		if (ret)
-			break;
-	}
-
-	return ret;
-}
-
-static void __iommu_remove_group_pasid(struct iommu_group *group,
-				       ioasid_t pasid)
-{
-	struct group_device *device;
-	const struct iommu_ops *ops;
-
-	for_each_group_device(group, device) {
-		ops = dev_iommu_ops(device->dev);
-		ops->remove_dev_pasid(device->dev, pasid);
-	}
-}
-
 /*
  * iommu_attach_device_pasid() - Attach a domain to pasid of device
  * @domain: the iommu domain.
@@ -3319,32 +3294,28 @@ static void __iommu_remove_group_pasid(struct iommu_group *group,
 int iommu_attach_device_pasid(struct iommu_domain *domain,
 			      struct device *dev, ioasid_t pasid)
 {
-	struct iommu_group *group;
+	struct dev_iommu *param = dev->iommu;
 	void *curr;
 	int ret;
 
 	if (!domain->ops->set_dev_pasid)
 		return -EOPNOTSUPP;
 
-	group = iommu_group_get(dev);
-	if (!group)
+	if (!param)
 		return -ENODEV;
 
-	mutex_lock(&group->mutex);
-	curr = xa_cmpxchg(&group->pasid_array, pasid, NULL, domain, GFP_KERNEL);
+	mutex_lock(&param->lock);
+	curr = xa_cmpxchg(&param->pasid_array, pasid, NULL, domain, GFP_KERNEL);
 	if (curr) {
 		ret = xa_err(curr) ? : -EBUSY;
 		goto out_unlock;
 	}
 
-	ret = __iommu_set_group_pasid(domain, group, pasid);
-	if (ret) {
-		__iommu_remove_group_pasid(group, pasid);
-		xa_erase(&group->pasid_array, pasid);
-	}
+	ret = domain->ops->set_dev_pasid(domain, dev, pasid);
+	if (ret)
+		xa_erase(&param->pasid_array, pasid);
 out_unlock:
-	mutex_unlock(&group->mutex);
-	iommu_group_put(group);
+	mutex_unlock(&param->lock);
 
 	return ret;
 }
@@ -3362,14 +3333,13 @@ EXPORT_SYMBOL_GPL(iommu_attach_device_pasid);
 void iommu_detach_device_pasid(struct iommu_domain *domain, struct device *dev,
 			       ioasid_t pasid)
 {
-	struct iommu_group *group = iommu_group_get(dev);
+	const struct iommu_ops *ops = dev_iommu_ops(dev);
+	struct dev_iommu *param = dev->iommu;
 
-	mutex_lock(&group->mutex);
-	__iommu_remove_group_pasid(group, pasid);
-	WARN_ON(xa_erase(&group->pasid_array, pasid) != domain);
-	mutex_unlock(&group->mutex);
-
-	iommu_group_put(group);
+	mutex_lock(&param->lock);
+	ops->remove_dev_pasid(dev, pasid);
+	WARN_ON(xa_erase(&param->pasid_array, pasid) != domain);
+	mutex_unlock(&param->lock);
 }
 EXPORT_SYMBOL_GPL(iommu_detach_device_pasid);
 
@@ -3392,18 +3362,12 @@ struct iommu_domain *iommu_get_domain_for_dev_pasid(struct device *dev,
 						    unsigned int type)
 {
 	struct iommu_domain *domain;
-	struct iommu_group *group;
 
-	group = iommu_group_get(dev);
-	if (!group)
-		return NULL;
-
-	xa_lock(&group->pasid_array);
-	domain = xa_load(&group->pasid_array, pasid);
+	xa_lock(&dev->iommu->pasid_array);
+	domain = xa_load(&dev->iommu->pasid_array, pasid);
 	if (type && domain && domain->type != type)
 		domain = ERR_PTR(-EBUSY);
-	xa_unlock(&group->pasid_array);
-	iommu_group_put(group);
+	xa_unlock(&dev->iommu->pasid_array);
 
 	return domain;
 }
-- 
2.34.1

