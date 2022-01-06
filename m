Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 26167485E90
	for <lists+kvm@lfdr.de>; Thu,  6 Jan 2022 03:22:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344693AbiAFCV6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 5 Jan 2022 21:21:58 -0500
Received: from mga06.intel.com ([134.134.136.31]:40628 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231945AbiAFCV4 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 5 Jan 2022 21:21:56 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1641435716; x=1672971716;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=xKGR4J0OSP6uicbqMFdEjKsyZ291es72vzJYC31FqCM=;
  b=UkzgLYhy0TijKNKyTDtiI2dE0qGRgt5YTi76pCMYmUqIzW+qDjzRpAUV
   hCNCSs6aL/rBBQsP/saXwlPy5qunFDVGNGQ6apI3nlXifovcqBi2PqlGg
   a2kuXWp7lMjo78gn9VeURfIFNIwHIlQnpb+vMaS5Z7VPPVE97LBp4XxRV
   xEGNTZklolXVEnlzn7M0z4qZXTavfycOu0pI0rX/QgNSW6IXdhhDWEOjN
   z8E4w7qAnJxYyzouByw8FXuNvMbWfwh4TqVNX8O8uLCBj+Hc7CsIkl+7i
   37aIQtT7YeB99vG7ZRMnlmKRuhzTNFOvuHGt9xC6yISXLTHHytWhMwqpI
   w==;
X-IronPort-AV: E=McAfee;i="6200,9189,10217"; a="303325586"
X-IronPort-AV: E=Sophos;i="5.88,265,1635231600"; 
   d="scan'208";a="303325586"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Jan 2022 18:21:56 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.88,265,1635231600"; 
   d="scan'208";a="526794284"
Received: from allen-box.sh.intel.com ([10.239.159.118])
  by orsmga008.jf.intel.com with ESMTP; 05 Jan 2022 18:21:49 -0800
From:   Lu Baolu <baolu.lu@linux.intel.com>
To:     Joerg Roedel <joro@8bytes.org>,
        Alex Williamson <alex.williamson@redhat.com>,
        Robin Murphy <robin.murphy@arm.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Christoph Hellwig <hch@infradead.org>,
        Kevin Tian <kevin.tian@intel.com>,
        Ashok Raj <ashok.raj@intel.com>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Will Deacon <will@kernel.org>,
        Dan Williams <dan.j.williams@intel.com>, rafael@kernel.org,
        Diana Craciun <diana.craciun@oss.nxp.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Eric Auger <eric.auger@redhat.com>,
        Liu Yi L <yi.l.liu@intel.com>,
        Jacob jun Pan <jacob.jun.pan@intel.com>,
        Chaitanya Kulkarni <kch@nvidia.com>,
        Stuart Yoder <stuyoder@gmail.com>,
        Laurentiu Tudor <laurentiu.tudor@nxp.com>,
        Thierry Reding <thierry.reding@gmail.com>,
        David Airlie <airlied@linux.ie>,
        Daniel Vetter <daniel@ffwll.ch>,
        Jonathan Hunter <jonathanh@nvidia.com>,
        Li Yang <leoyang.li@nxp.com>,
        Dmitry Osipenko <digetx@gmail.com>,
        iommu@lists.linux-foundation.org, linux-pci@vger.kernel.org,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Lu Baolu <baolu.lu@linux.intel.com>
Subject: [PATCH v1 1/8] iommu: Add iommu_group_replace_domain()
Date:   Thu,  6 Jan 2022 10:20:46 +0800
Message-Id: <20220106022053.2406748-2-baolu.lu@linux.intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220106022053.2406748-1-baolu.lu@linux.intel.com>
References: <20220106022053.2406748-1-baolu.lu@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Expose an interface to replace the domain of an iommu group for frameworks
like vfio which claims the ownership of the whole iommu group.

Signed-off-by: Lu Baolu <baolu.lu@linux.intel.com>
---
 include/linux/iommu.h | 10 ++++++++++
 drivers/iommu/iommu.c | 37 +++++++++++++++++++++++++++++++++++++
 2 files changed, 47 insertions(+)

diff --git a/include/linux/iommu.h b/include/linux/iommu.h
index 408a6d2b3034..66ebce3d1e11 100644
--- a/include/linux/iommu.h
+++ b/include/linux/iommu.h
@@ -677,6 +677,9 @@ void iommu_device_unuse_dma_api(struct device *dev);
 int iommu_group_set_dma_owner(struct iommu_group *group, void *owner);
 void iommu_group_release_dma_owner(struct iommu_group *group);
 bool iommu_group_dma_owner_claimed(struct iommu_group *group);
+int iommu_group_replace_domain(struct iommu_group *group,
+			       struct iommu_domain *old,
+			       struct iommu_domain *new);
 
 #else /* CONFIG_IOMMU_API */
 
@@ -1090,6 +1093,13 @@ static inline bool iommu_group_dma_owner_claimed(struct iommu_group *group)
 {
 	return false;
 }
+
+static inline int
+iommu_group_replace_domain(struct iommu_group *group, struct iommu_domain *old,
+			   struct iommu_domain *new)
+{
+	return -ENODEV;
+}
 #endif /* CONFIG_IOMMU_API */
 
 /**
diff --git a/drivers/iommu/iommu.c b/drivers/iommu/iommu.c
index 72a95dea688e..ab8ab95969f5 100644
--- a/drivers/iommu/iommu.c
+++ b/drivers/iommu/iommu.c
@@ -3431,3 +3431,40 @@ bool iommu_group_dma_owner_claimed(struct iommu_group *group)
 	return user;
 }
 EXPORT_SYMBOL_GPL(iommu_group_dma_owner_claimed);
+
+/**
+ * iommu_group_replace_domain() - Replace group's domain
+ * @group: The group.
+ * @old: The previous attached domain. NULL for none.
+ * @new: The new domain about to be attached.
+ *
+ * This is to support backward compatibility for vfio which manages the dma
+ * ownership in iommu_group level.
+ */
+int iommu_group_replace_domain(struct iommu_group *group,
+			       struct iommu_domain *old,
+			       struct iommu_domain *new)
+{
+	int ret = 0;
+
+	mutex_lock(&group->mutex);
+	if (!group->owner || group->domain != old) {
+		ret = -EPERM;
+		goto unlock_out;
+	}
+
+	if (old)
+		__iommu_detach_group(old, group);
+
+	if (new) {
+		ret = __iommu_attach_group(new, group);
+		if (ret && old)
+			__iommu_attach_group(old, group);
+	}
+
+unlock_out:
+	mutex_unlock(&group->mutex);
+
+	return ret;
+}
+EXPORT_SYMBOL_GPL(iommu_group_replace_domain);
-- 
2.25.1

