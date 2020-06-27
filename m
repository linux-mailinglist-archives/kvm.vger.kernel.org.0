Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AB87D20BDE6
	for <lists+kvm@lfdr.de>; Sat, 27 Jun 2020 05:20:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725937AbgF0DTv (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 26 Jun 2020 23:19:51 -0400
Received: from mga01.intel.com ([192.55.52.88]:37086 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725824AbgF0DTu (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 26 Jun 2020 23:19:50 -0400
IronPort-SDR: THGawV2zADgaMlNF9UXuf8shcoXhNRhEzmQBB3Gfq3BlqBhj2mpj5C6ojJwx0YL+FN13Sl4G8s
 Z1AxYT7EJo0Q==
X-IronPort-AV: E=McAfee;i="6000,8403,9664"; a="163598215"
X-IronPort-AV: E=Sophos;i="5.75,286,1589266800"; 
   d="scan'208";a="163598215"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Jun 2020 20:19:50 -0700
IronPort-SDR: 0E5d9pkgpFPRPa4yVX8lXuv/vsuhWX6VqXWOQVY/cxH2FDKdDT6F/nBQVxfQY0fxYBz5zeYwGq
 splzo1hyqcMA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.75,286,1589266800"; 
   d="scan'208";a="302510433"
Received: from allen-box.sh.intel.com ([10.239.159.139])
  by fmsmga004.fm.intel.com with ESMTP; 26 Jun 2020 20:19:47 -0700
From:   Lu Baolu <baolu.lu@linux.intel.com>
To:     Joerg Roedel <joro@8bytes.org>,
        Alex Williamson <alex.williamson@redhat.com>
Cc:     Cornelia Huck <cohuck@redhat.com>,
        Kevin Tian <kevin.tian@intel.com>,
        Ashok Raj <ashok.raj@intel.com>,
        Dave Jiang <dave.jiang@intel.com>,
        Liu Yi L <yi.l.liu@intel.com>,
        iommu@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, Lu Baolu <baolu.lu@linux.intel.com>
Subject: [PATCH 2/2] vfio/type1: Update group->domain after aux attach and detach
Date:   Sat, 27 Jun 2020 11:15:32 +0800
Message-Id: <20200627031532.28046-2-baolu.lu@linux.intel.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200627031532.28046-1-baolu.lu@linux.intel.com>
References: <20200627031532.28046-1-baolu.lu@linux.intel.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Update group->domain whenever an aux-domain is attached to or detached
from a mediated device. Without this change, iommu_get_domain_for_dev()
will be broken for mdev devices.

Fixes: 7bd50f0cd2fd5 ("vfio/type1: Add domain at(de)taching group helpers")
Signed-off-by: Lu Baolu <baolu.lu@linux.intel.com>
---
 drivers/vfio/vfio_iommu_type1.c | 37 ++++++++++++++++++++++++++++-----
 1 file changed, 32 insertions(+), 5 deletions(-)

diff --git a/drivers/vfio/vfio_iommu_type1.c b/drivers/vfio/vfio_iommu_type1.c
index 5e556ac9102a..e0d8802ce0c9 100644
--- a/drivers/vfio/vfio_iommu_type1.c
+++ b/drivers/vfio/vfio_iommu_type1.c
@@ -1634,10 +1634,28 @@ static int vfio_mdev_attach_domain(struct device *dev, void *data)
 
 	iommu_device = vfio_mdev_get_iommu_device(dev);
 	if (iommu_device) {
-		if (iommu_dev_feature_enabled(iommu_device, IOMMU_DEV_FEAT_AUX))
-			return iommu_aux_attach_device(domain, iommu_device);
-		else
+		if (iommu_dev_feature_enabled(iommu_device,
+					      IOMMU_DEV_FEAT_AUX)) {
+			struct iommu_group *group = iommu_group_get(dev);
+			int ret;
+
+			if (!group)
+				return -EINVAL;
+
+			if (iommu_group_get_domain(group)) {
+				iommu_group_put(group);
+				return -EBUSY;
+			}
+
+			ret = iommu_aux_attach_device(domain, iommu_device);
+			if (!ret)
+				iommu_group_set_domain(group, domain);
+
+			iommu_group_put(group);
+			return ret;
+		} else {
 			return iommu_attach_device(domain, iommu_device);
+		}
 	}
 
 	return -EINVAL;
@@ -1650,10 +1668,19 @@ static int vfio_mdev_detach_domain(struct device *dev, void *data)
 
 	iommu_device = vfio_mdev_get_iommu_device(dev);
 	if (iommu_device) {
-		if (iommu_dev_feature_enabled(iommu_device, IOMMU_DEV_FEAT_AUX))
+		if (iommu_dev_feature_enabled(iommu_device,
+					      IOMMU_DEV_FEAT_AUX)) {
+			struct iommu_group *group;
+
 			iommu_aux_detach_device(domain, iommu_device);
-		else
+			group = iommu_group_get(dev);
+			if (group) {
+				iommu_group_set_domain(group, NULL);
+				iommu_group_put(group);
+			}
+		} else {
 			iommu_detach_device(domain, iommu_device);
+		}
 	}
 
 	return 0;
-- 
2.17.1

