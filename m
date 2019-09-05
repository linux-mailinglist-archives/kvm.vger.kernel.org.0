Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 38090AB3E9
	for <lists+kvm@lfdr.de>; Fri,  6 Sep 2019 10:18:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392650AbfIFIRy (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 6 Sep 2019 04:17:54 -0400
Received: from mga11.intel.com ([192.55.52.93]:23720 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2392615AbfIFIRx (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 6 Sep 2019 04:17:53 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by fmsmga102.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 06 Sep 2019 01:17:53 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,472,1559545200"; 
   d="scan'208";a="383186216"
Received: from yiliu-dev.bj.intel.com ([10.238.156.139])
  by fmsmga005.fm.intel.com with ESMTP; 06 Sep 2019 01:17:51 -0700
From:   Liu Yi L <yi.l.liu@intel.com>
To:     alex.williamson@redhat.com, kwankhede@nvidia.com
Cc:     kevin.tian@intel.com, baolu.lu@linux.intel.com, yi.l.liu@intel.com,
        yi.y.sun@intel.com, joro@8bytes.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, yan.y.zhao@intel.com, shaopeng.he@intel.com,
        chenbo.xia@intel.com, jun.j.tian@intel.com
Subject: [PATCH v2 12/13] vfio/type1: use iommu_attach_group() for wrapping PF/VF as mdev
Date:   Thu,  5 Sep 2019 15:59:29 +0800
Message-Id: <1567670370-4484-13-git-send-email-yi.l.liu@intel.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1567670370-4484-1-git-send-email-yi.l.liu@intel.com>
References: <1567670370-4484-1-git-send-email-yi.l.liu@intel.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This patch uses iommu_attach_group() to do group attach when it is
for the case of wrapping a PF/VF as a mdev. iommu_attach_device()
doesn't support non-singleton iommu group attach. With this change,
wrapping PF/VF as mdev can work on non-singleton iommu groups.

Cc: Kevin Tian <kevin.tian@intel.com>
Cc: Lu Baolu <baolu.lu@linux.intel.com>
Suggested-by: Alex Williamson <alex.williamson@redhat.com>
Signed-off-by: Liu Yi L <yi.l.liu@intel.com>
---
 drivers/vfio/vfio_iommu_type1.c | 22 ++++++++++++++++++----
 1 file changed, 18 insertions(+), 4 deletions(-)

diff --git a/drivers/vfio/vfio_iommu_type1.c b/drivers/vfio/vfio_iommu_type1.c
index 054391f..317430d 100644
--- a/drivers/vfio/vfio_iommu_type1.c
+++ b/drivers/vfio/vfio_iommu_type1.c
@@ -1312,13 +1312,20 @@ static int vfio_mdev_attach_domain(struct device *dev, void *data)
 {
 	struct iommu_domain *domain = data;
 	struct device *iommu_device;
+	struct iommu_group *group;
 
 	iommu_device = vfio_mdev_get_iommu_device(dev);
 	if (iommu_device) {
 		if (iommu_dev_feature_enabled(iommu_device, IOMMU_DEV_FEAT_AUX))
 			return iommu_aux_attach_device(domain, iommu_device);
-		else
-			return iommu_attach_device(domain, iommu_device);
+		else {
+			group = iommu_group_get(iommu_device);
+			if (!group) {
+				WARN_ON(1);
+				return -EINVAL;
+			}
+			return iommu_attach_group(domain, group);
+		}
 	}
 
 	return -EINVAL;
@@ -1328,13 +1335,20 @@ static int vfio_mdev_detach_domain(struct device *dev, void *data)
 {
 	struct iommu_domain *domain = data;
 	struct device *iommu_device;
+	struct iommu_group *group;
 
 	iommu_device = vfio_mdev_get_iommu_device(dev);
 	if (iommu_device) {
 		if (iommu_dev_feature_enabled(iommu_device, IOMMU_DEV_FEAT_AUX))
 			iommu_aux_detach_device(domain, iommu_device);
-		else
-			iommu_detach_device(domain, iommu_device);
+		else {
+			group = iommu_group_get(iommu_device);
+			if (!group) {
+				WARN_ON(1);
+				return -EINVAL;
+			}
+			iommu_detach_group(domain, group);
+		}
 	}
 
 	return 0;
-- 
2.7.4

