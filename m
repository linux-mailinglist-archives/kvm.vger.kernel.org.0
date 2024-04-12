Return-Path: <kvm+bounces-14396-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 77D938A28FA
	for <lists+kvm@lfdr.de>; Fri, 12 Apr 2024 10:15:41 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id D01A7B246E0
	for <lists+kvm@lfdr.de>; Fri, 12 Apr 2024 08:15:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0575150296;
	Fri, 12 Apr 2024 08:15:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="lMsoQirQ"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A6DFC4F5E6
	for <kvm@vger.kernel.org>; Fri, 12 Apr 2024 08:15:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.17
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712909723; cv=none; b=aBoz4kEOtGyfNXg0BE8O61Pg1noEil+xgHCin18WVOOnxM9ZvPKiL35/sVWMhd9o5kKP9WkEZg4vtcHIDdpQT01XaxfEnYzC6xE1Lwyo/OTGWe9eg3lZW1huSkjqEVNw9rh2PZGJ0MP4i8RxQx1Mhpni+k9bhkGj4BZoRBEYRT4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712909723; c=relaxed/simple;
	bh=xpJTU4SSgasIaJhc5aDJUwZTh4v5WWDaG0wBjeN9SjE=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=U34uI/9epdCzh582gFPVN/qLLtkBiloR32QDTaoIepnDLDGySqbwlZJw6PG/DKJGvyquXtbevGQbohj0FE+0NqBS5IdGe4uNTCt0EfAPgGqcsDSGAihnPDZcQKMxXrqUKzSYzmXlHTiXs/2jsM5kDREJ5wjlJeVCIlUFgnjGLdA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=lMsoQirQ; arc=none smtp.client-ip=198.175.65.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1712909722; x=1744445722;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=xpJTU4SSgasIaJhc5aDJUwZTh4v5WWDaG0wBjeN9SjE=;
  b=lMsoQirQs894hWVNVqz6x1vwlD/QcwOVQnuuA0SXnigQp7re65Uwb9oJ
   qmSBL7ALWjqaB2tDjkZcKvxSVgdGxhdDgYYitIdWW2hBWmvlHnDFQ5U9o
   Utq3GSJEQLBqt3SGCUrLW3CLTEOwh4OPIQoI8L49wrd27f9XQb0JVb/s7
   vVt06BANnOKX81UQWd63U6O/1KLb0zEP+GRUMmuXmVASFK7Q82A0/SNff
   QTnfxhddNOUn1nqw1fzweOKwLAgQTxGPdy5d2SerDuzx9fpy1aFODS88T
   XaZEwohRKJ610us0f6jIRWrYrv0LccY6UT6w2oTCPvld4XDgGg+/rFC0F
   g==;
X-CSE-ConnectionGUID: oRgKmCGWTw25kF75qtggTA==
X-CSE-MsgGUID: lelaDpE+Sy2T/JSIP7Gleg==
X-IronPort-AV: E=McAfee;i="6600,9927,11041"; a="8465041"
X-IronPort-AV: E=Sophos;i="6.07,195,1708416000"; 
   d="scan'208";a="8465041"
Received: from orviesa002.jf.intel.com ([10.64.159.142])
  by orvoesa109.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Apr 2024 01:15:22 -0700
X-CSE-ConnectionGUID: iQPzKXeCT4KHx9SBoPNXGg==
X-CSE-MsgGUID: bsPC0mo8THmJW0OswyvKQg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,195,1708416000"; 
   d="scan'208";a="52137780"
Received: from 984fee00a4c6.jf.intel.com ([10.165.58.231])
  by orviesa002.jf.intel.com with ESMTP; 12 Apr 2024 01:15:21 -0700
From: Yi Liu <yi.l.liu@intel.com>
To: joro@8bytes.org,
	jgg@nvidia.com,
	kevin.tian@intel.com,
	baolu.lu@linux.intel.com
Cc: alex.williamson@redhat.com,
	robin.murphy@arm.com,
	eric.auger@redhat.com,
	nicolinc@nvidia.com,
	kvm@vger.kernel.org,
	chao.p.peng@linux.intel.com,
	yi.l.liu@intel.com,
	iommu@lists.linux.dev,
	zhenzhong.duan@intel.com,
	jacob.jun.pan@intel.com
Subject: [PATCH v2 02/12] iommu: Introduce a replace API for device pasid
Date: Fri, 12 Apr 2024 01:15:06 -0700
Message-Id: <20240412081516.31168-3-yi.l.liu@intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20240412081516.31168-1-yi.l.liu@intel.com>
References: <20240412081516.31168-1-yi.l.liu@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Provide a high-level API to allow replacements of one domain with
another for specific pasid of a device. This is similar to
iommu_group_replace_domain() and it is expected to be used only by
IOMMUFD.

Signed-off-by: Lu Baolu <baolu.lu@linux.intel.com>
Signed-off-by: Yi Liu <yi.l.liu@intel.com>
---
 drivers/iommu/iommu-priv.h |  3 ++
 drivers/iommu/iommu.c      | 92 +++++++++++++++++++++++++++++++++++---
 2 files changed, 89 insertions(+), 6 deletions(-)

diff --git a/drivers/iommu/iommu-priv.h b/drivers/iommu/iommu-priv.h
index 5f731d994803..0949c02cee93 100644
--- a/drivers/iommu/iommu-priv.h
+++ b/drivers/iommu/iommu-priv.h
@@ -20,6 +20,9 @@ static inline const struct iommu_ops *dev_iommu_ops(struct device *dev)
 int iommu_group_replace_domain(struct iommu_group *group,
 			       struct iommu_domain *new_domain);
 
+int iommu_replace_device_pasid(struct iommu_domain *domain,
+			       struct device *dev, ioasid_t pasid);
+
 int iommu_device_register_bus(struct iommu_device *iommu,
 			      const struct iommu_ops *ops,
 			      const struct bus_type *bus,
diff --git a/drivers/iommu/iommu.c b/drivers/iommu/iommu.c
index 701b02a118db..343683e646e0 100644
--- a/drivers/iommu/iommu.c
+++ b/drivers/iommu/iommu.c
@@ -3315,14 +3315,15 @@ bool iommu_group_dma_owner_claimed(struct iommu_group *group)
 EXPORT_SYMBOL_GPL(iommu_group_dma_owner_claimed);
 
 static int __iommu_set_group_pasid(struct iommu_domain *domain,
-				   struct iommu_group *group, ioasid_t pasid)
+				   struct iommu_group *group, ioasid_t pasid,
+				   struct iommu_domain *old)
 {
 	struct group_device *device, *last_gdev;
 	int ret;
 
 	for_each_group_device(group, device) {
 		ret = domain->ops->set_dev_pasid(domain, device->dev,
-						 pasid, NULL);
+						 pasid, old);
 		if (ret)
 			goto err_revert;
 	}
@@ -3332,11 +3333,34 @@ static int __iommu_set_group_pasid(struct iommu_domain *domain,
 err_revert:
 	last_gdev = device;
 	for_each_group_device(group, device) {
-		const struct iommu_ops *ops = dev_iommu_ops(device->dev);
+		/*
+		 * If no old domain, just undo all the devices/pasid that
+		 * have attached to the new domain.
+		 */
+		if (!old) {
+			const struct iommu_ops *ops =
+						dev_iommu_ops(device->dev);
+
+			if (device == last_gdev)
+				break;
+			ops = dev_iommu_ops(device->dev);
+			ops->remove_dev_pasid(device->dev, pasid, domain);
+			continue;
+		}
 
-		if (device == last_gdev)
+		/*
+		 * Rollback the devices/pasid that have attached to the new
+		 * domain. And it is a driver bug to fail attaching with a
+		 * previously good domain.
+		 */
+		if (device == last_gdev) {
+			WARN_ON(old->ops->set_dev_pasid(old, device->dev,
+							pasid, NULL));
 			break;
-		ops->remove_dev_pasid(device->dev, pasid, domain);
+		}
+
+		WARN_ON(old->ops->set_dev_pasid(old, device->dev,
+						pasid, domain));
 	}
 	return ret;
 }
@@ -3395,7 +3419,7 @@ int iommu_attach_device_pasid(struct iommu_domain *domain,
 		goto out_unlock;
 	}
 
-	ret = __iommu_set_group_pasid(domain, group, pasid);
+	ret = __iommu_set_group_pasid(domain, group, pasid, NULL);
 	if (ret)
 		xa_erase(&group->pasid_array, pasid);
 out_unlock:
@@ -3404,6 +3428,62 @@ int iommu_attach_device_pasid(struct iommu_domain *domain,
 }
 EXPORT_SYMBOL_GPL(iommu_attach_device_pasid);
 
+/**
+ * iommu_replace_device_pasid - replace the domain that a pasid is attached to
+ * @domain: new IOMMU domain to replace with
+ * @dev: the physical device
+ * @pasid: pasid that will be attached to the new domain
+ *
+ * This API allows the pasid to switch domains. Return 0 on success, or an
+ * error. The pasid will roll back to use the old domain if failure. The
+ * caller could call iommu_detach_device_pasid() before free the old domain
+ * in order to avoid use-after-free case.
+ */
+int iommu_replace_device_pasid(struct iommu_domain *domain,
+			       struct device *dev, ioasid_t pasid)
+{
+	/* Caller must be a probed driver on dev */
+	struct iommu_group *group = dev->iommu_group;
+	void *curr;
+	int ret;
+
+	if (!domain)
+		return -EINVAL;
+
+	if (!domain->ops->set_dev_pasid)
+		return -EOPNOTSUPP;
+
+	if (!group)
+		return -ENODEV;
+
+	if (!dev_has_iommu(dev) || dev_iommu_ops(dev) != domain->owner)
+		return -EINVAL;
+
+	mutex_lock(&group->mutex);
+	curr = xa_store(&group->pasid_array, pasid, domain, GFP_KERNEL);
+	if (!curr) {
+		xa_erase(&group->pasid_array, pasid);
+		ret = -EINVAL;
+		goto out_unlock;
+	}
+
+	ret = xa_err(curr);
+	if (ret)
+		goto out_unlock;
+
+	if (curr == domain)
+		goto out_unlock;
+
+	ret = __iommu_set_group_pasid(domain, group, pasid, curr);
+	if (ret)
+		WARN_ON(xa_err(xa_store(&group->pasid_array, pasid,
+					curr, GFP_KERNEL)));
+out_unlock:
+	mutex_unlock(&group->mutex);
+	return ret;
+}
+EXPORT_SYMBOL_NS_GPL(iommu_replace_device_pasid, IOMMUFD_INTERNAL);
+
 /*
  * iommu_detach_device_pasid() - Detach the domain from pasid of device
  * @domain: the iommu domain.
-- 
2.34.1


