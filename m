Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B00B532A73A
	for <lists+kvm@lfdr.de>; Tue,  2 Mar 2021 18:07:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1839102AbhCBQFe (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 2 Mar 2021 11:05:34 -0500
Received: from mga01.intel.com ([192.55.52.88]:37927 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1343520AbhCBMpB (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 2 Mar 2021 07:45:01 -0500
IronPort-SDR: xCCDjtu+zN6K6c9FdWgFGpy9prsGbkzl8s/VDEDJFQmo1kpu6CwhMWqjL/+XkKnKSNaJ930MUJ
 ZcpQAVFiO9dw==
X-IronPort-AV: E=McAfee;i="6000,8403,9910"; a="206431237"
X-IronPort-AV: E=Sophos;i="5.81,216,1610438400"; 
   d="scan'208";a="206431237"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Mar 2021 04:37:21 -0800
IronPort-SDR: b01cnbmL4VNWHjMTVTn0VrFg5n+zP3jzVtQDTNf6cGCvNZJCyLEWmN92u+AztyGIMvAM/xls97
 FCFXND7pZ2FQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.81,216,1610438400"; 
   d="scan'208";a="427472133"
Received: from yiliu-dev.bj.intel.com (HELO dual-ub.bj.intel.com) ([10.238.156.135])
  by fmsmga004.fm.intel.com with ESMTP; 02 Mar 2021 04:37:16 -0800
From:   Liu Yi L <yi.l.liu@intel.com>
To:     alex.williamson@redhat.com, eric.auger@redhat.com,
        baolu.lu@linux.intel.com, joro@8bytes.org
Cc:     kevin.tian@intel.com, jacob.jun.pan@linux.intel.com,
        ashok.raj@intel.com, yi.l.liu@intel.com, jun.j.tian@intel.com,
        yi.y.sun@intel.com, jean-philippe@linaro.org, peterx@redhat.com,
        jasowang@redhat.com, hao.wu@intel.com, stefanha@gmail.com,
        iommu@lists.linux-foundation.org, kvm@vger.kernel.org,
        jgg@nvidia.com, Lingshan.Zhu@intel.com, vivek.gautam@arm.com
Subject: [Patch v8 07/10] vfio/type1: Add vSVA support for IOMMU-backed mdevs
Date:   Wed,  3 Mar 2021 04:35:42 +0800
Message-Id: <20210302203545.436623-8-yi.l.liu@intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210302203545.436623-1-yi.l.liu@intel.com>
References: <20210302203545.436623-1-yi.l.liu@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Recent years, mediated device pass-through framework (e.g. vfio-mdev)
is used to achieve flexible device sharing across domains (e.g. VMs).
Also there are hardware assisted mediated pass-through solutions from
platform vendors. e.g. Intel VT-d scalable mode which supports Intel
Scalable I/O Virtualization technology. Such mdevs are called IOMMU-
backed mdevs as there are IOMMU enforced DMA isolation for such mdevs.
In kernel, IOMMU-backed mdevs are exposed to IOMMU layer by aux-domain
concept, which means mdevs are protected by an iommu domain which is
auxiliary to the domain that the kernel driver primarily uses for DMA
API. Details can be found in the KVM presentation as below:

https://events19.linuxfoundation.org/wp-content/uploads/2017/12/Hardware-Assisted-Mediated-Pass-Through-with-VFIO-Kevin-Tian-Intel.pdf

This patch extends NESTING_IOMMU ops to IOMMU-backed mdev devices. The
main requirement is to use the auxiliary domain associated with mdev.

Cc: Kevin Tian <kevin.tian@intel.com>
CC: Jacob Pan <jacob.jun.pan@linux.intel.com>
CC: Jun Tian <jun.j.tian@intel.com>
Cc: Alex Williamson <alex.williamson@redhat.com>
Cc: Eric Auger <eric.auger@redhat.com>
Cc: Jean-Philippe Brucker <jean-philippe@linaro.org>
Cc: Joerg Roedel <joro@8bytes.org>
Cc: Lu Baolu <baolu.lu@linux.intel.com>
Signed-off-by: Liu Yi L <yi.l.liu@intel.com>
Reviewed-by: Eric Auger <eric.auger@redhat.com>
---
v5 -> v6:
*) add review-by from Eric Auger.

v1 -> v2:
*) check the iommu_device to ensure the handling mdev is IOMMU-backed
---
 drivers/vfio/vfio_iommu_type1.c | 35 ++++++++++++++++++++++++++++-----
 1 file changed, 30 insertions(+), 5 deletions(-)

diff --git a/drivers/vfio/vfio_iommu_type1.c b/drivers/vfio/vfio_iommu_type1.c
index 86b6d8f9789a..883a79f36c46 100644
--- a/drivers/vfio/vfio_iommu_type1.c
+++ b/drivers/vfio/vfio_iommu_type1.c
@@ -2635,18 +2635,37 @@ static int vfio_iommu_resv_refresh(struct vfio_iommu *iommu,
 	return ret;
 }
 
+static struct device *vfio_get_iommu_device(struct vfio_group *group,
+					    struct device *dev)
+{
+	if (group->mdev_group)
+		return vfio_mdev_get_iommu_device(dev);
+	else
+		return dev;
+}
+
 static int vfio_dev_bind_gpasid_fn(struct device *dev, void *data)
 {
 	struct domain_capsule *dc = (struct domain_capsule *)data;
 	unsigned long arg = *(unsigned long *)dc->data;
+	struct device *iommu_device;
+
+	iommu_device = vfio_get_iommu_device(dc->group, dev);
+	if (!iommu_device)
+		return -EINVAL;
 
-	return iommu_uapi_sva_bind_gpasid(dc->domain, dev,
+	return iommu_uapi_sva_bind_gpasid(dc->domain, iommu_device,
 					  (void __user *)arg);
 }
 
 static int vfio_dev_unbind_gpasid_fn(struct device *dev, void *data)
 {
 	struct domain_capsule *dc = (struct domain_capsule *)data;
+	struct device *iommu_device;
+
+	iommu_device = vfio_get_iommu_device(dc->group, dev);
+	if (!iommu_device)
+		return -EINVAL;
 
 	/*
 	 * dc->user is a toggle for the unbind operation. When user
@@ -2659,12 +2678,12 @@ static int vfio_dev_unbind_gpasid_fn(struct device *dev, void *data)
 	if (dc->user) {
 		unsigned long arg = *(unsigned long *)dc->data;
 
-		iommu_uapi_sva_unbind_gpasid(dc->domain,
-					     dev, (void __user *)arg);
+		iommu_uapi_sva_unbind_gpasid(dc->domain, iommu_device,
+					     (void __user *)arg);
 	} else {
 		ioasid_t pasid = *(ioasid_t *)dc->data;
 
-		iommu_sva_unbind_gpasid(dc->domain, dev, pasid);
+		iommu_sva_unbind_gpasid(dc->domain, iommu_device, pasid);
 	}
 	return 0;
 }
@@ -3295,8 +3314,14 @@ static int vfio_dev_cache_invalidate_fn(struct device *dev, void *data)
 {
 	struct domain_capsule *dc = (struct domain_capsule *)data;
 	unsigned long arg = *(unsigned long *)dc->data;
+	struct device *iommu_device;
+
+	iommu_device = vfio_get_iommu_device(dc->group, dev);
+	if (!iommu_device)
+		return -EINVAL;
 
-	iommu_uapi_cache_invalidate(dc->domain, dev, (void __user *)arg);
+	iommu_uapi_cache_invalidate(dc->domain, iommu_device,
+				    (void __user *)arg);
 	return 0;
 }
 
-- 
2.25.1

