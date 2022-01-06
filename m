Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DBE2A485E9C
	for <lists+kvm@lfdr.de>; Thu,  6 Jan 2022 03:22:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344739AbiAFCW2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 5 Jan 2022 21:22:28 -0500
Received: from mga06.intel.com ([134.134.136.31]:40662 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231945AbiAFCWU (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 5 Jan 2022 21:22:20 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1641435740; x=1672971740;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=clG1gjGvOL9BSMyPbqgYNxozZZwO9e7BVS3UogrjHAs=;
  b=Jl0YoOAKf3sWnyc7zprPr4I4kHkE3GmrJBwxEa/36P/JBFpSzXChAQb5
   J5sS4WGGyfgbAkpVG+KXkBPD4UCqfkbjTw2ogvxOObPZi9jYLwwt9kncI
   ieCYQH7V9ExNqlS6S8CP2jhz0oDZGEZcTtQmgUF+SqAn472NBa9iwVlF5
   Em7JWOmiXhMfgDFM3HHN/e6VFywaDhJGMABLEAKu1/DVUOKMqLC37o4rh
   UUF+oXVud4J2joYN95NKr2qPHHPWZYlAuD7wJ3DGLKZbyFjnqQdUSeh+v
   GJ1iUhFpI6zWs8ekSsHDU7YXguV4JmyfPb1hsB5IDEsD9P/PWxeBGxH/F
   g==;
X-IronPort-AV: E=McAfee;i="6200,9189,10217"; a="303325620"
X-IronPort-AV: E=Sophos;i="5.88,265,1635231600"; 
   d="scan'208";a="303325620"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Jan 2022 18:22:10 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.88,265,1635231600"; 
   d="scan'208";a="526794333"
Received: from allen-box.sh.intel.com ([10.239.159.118])
  by orsmga008.jf.intel.com with ESMTP; 05 Jan 2022 18:22:03 -0800
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
Subject: [PATCH v1 3/8] iommu: Extend iommu_at[de]tach_device() for multi-device groups
Date:   Thu,  6 Jan 2022 10:20:48 +0800
Message-Id: <20220106022053.2406748-4-baolu.lu@linux.intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220106022053.2406748-1-baolu.lu@linux.intel.com>
References: <20220106022053.2406748-1-baolu.lu@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The iommu_attach/detach_device() interfaces were exposed for the device
drivers to attach/detach their own domains. The commit <426a273834eae>
("iommu: Limit iommu_attach/detach_device to device with their own group")
restricted them to singleton groups to avoid different device in a group
attaching different domain.

As we've introduced device DMA ownership into the iommu core. We can now
extend these interfaces for muliple-device groups, and "all devices are in
the same address space" is still guaranteed.

For multiple devices belonging to a same group, iommu_device_use_dma_api()
and iommu_attach_device() are exclusive. Therefore, when drivers decide to
use iommu_attach_domain(), they cannot call iommu_device_use_dma_api() at
the same time.

Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Lu Baolu <baolu.lu@linux.intel.com>
---
 drivers/iommu/iommu.c | 79 +++++++++++++++++++++++++++++++++----------
 1 file changed, 62 insertions(+), 17 deletions(-)

diff --git a/drivers/iommu/iommu.c b/drivers/iommu/iommu.c
index ab8ab95969f5..2c9efd85e447 100644
--- a/drivers/iommu/iommu.c
+++ b/drivers/iommu/iommu.c
@@ -47,6 +47,7 @@ struct iommu_group {
 	struct iommu_domain *domain;
 	struct list_head entry;
 	unsigned int owner_cnt;
+	unsigned int attach_cnt;
 	void *owner;
 };
 
@@ -1921,27 +1922,59 @@ static int __iommu_attach_device(struct iommu_domain *domain,
 	return ret;
 }
 
+/**
+ * iommu_attach_device() - attach external or UNMANAGED domain to device
+ * @domain: the domain about to attach
+ * @dev: the device about to be attached
+ *
+ * For devices belonging to the same group, iommu_device_use_dma_api() and
+ * iommu_attach_device() are exclusive. Therefore, when drivers decide to
+ * use iommu_attach_domain(), they cannot call iommu_device_use_dma_api()
+ * at the same time.
+ */
 int iommu_attach_device(struct iommu_domain *domain, struct device *dev)
 {
 	struct iommu_group *group;
-	int ret;
+	int ret = 0;
+
+	if (domain->type != IOMMU_DOMAIN_UNMANAGED)
+		return -EINVAL;
 
 	group = iommu_group_get(dev);
 	if (!group)
 		return -ENODEV;
 
-	/*
-	 * Lock the group to make sure the device-count doesn't
-	 * change while we are attaching
-	 */
 	mutex_lock(&group->mutex);
-	ret = -EINVAL;
-	if (iommu_group_device_count(group) != 1)
-		goto out_unlock;
+	if (group->owner_cnt) {
+		/*
+		 * Group has been used for kernel-api dma or claimed explicitly
+		 * for exclusive occupation. For backward compatibility, device
+		 * in a singleton group is allowed to ignore setting the
+		 * drv.no_kernel_api_dma field.
+		 */
+		if ((group->domain == group->default_domain &&
+		     iommu_group_device_count(group) != 1) ||
+		    group->owner) {
+			ret = -EBUSY;
+			goto unlock_out;
+		}
+	}
 
-	ret = __iommu_attach_group(domain, group);
+	if (!group->attach_cnt) {
+		ret = __iommu_attach_group(domain, group);
+		if (ret)
+			goto unlock_out;
+	} else {
+		if (group->domain != domain) {
+			ret = -EPERM;
+			goto unlock_out;
+		}
+	}
 
-out_unlock:
+	group->owner_cnt++;
+	group->attach_cnt++;
+
+unlock_out:
 	mutex_unlock(&group->mutex);
 	iommu_group_put(group);
 
@@ -2182,23 +2215,35 @@ static void __iommu_detach_device(struct iommu_domain *domain,
 	trace_detach_device_from_domain(dev);
 }
 
+/**
+ * iommu_detach_device() - detach external or UNMANAGED domain from device
+ * @domain: the domain about to detach
+ * @dev: the device about to be detached
+ *
+ * Paired with iommu_attach_device(), it detaches the domain from the device.
+ */
 void iommu_detach_device(struct iommu_domain *domain, struct device *dev)
 {
 	struct iommu_group *group;
 
+	if (WARN_ON(domain->type != IOMMU_DOMAIN_UNMANAGED))
+		return;
+
 	group = iommu_group_get(dev);
-	if (!group)
+	if (WARN_ON(!group))
 		return;
 
 	mutex_lock(&group->mutex);
-	if (iommu_group_device_count(group) != 1) {
-		WARN_ON(1);
-		goto out_unlock;
-	}
+	if (WARN_ON(!group->attach_cnt || !group->owner_cnt ||
+		    group->domain != domain))
+		goto unlock_out;
 
-	__iommu_detach_group(domain, group);
+	group->attach_cnt--;
+	group->owner_cnt--;
+	if (!group->attach_cnt)
+		__iommu_detach_group(domain, group);
 
-out_unlock:
+unlock_out:
 	mutex_unlock(&group->mutex);
 	iommu_group_put(group);
 }
-- 
2.25.1

