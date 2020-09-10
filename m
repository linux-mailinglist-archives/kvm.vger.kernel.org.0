Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EAA6426449C
	for <lists+kvm@lfdr.de>; Thu, 10 Sep 2020 12:50:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730279AbgIJKts (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 10 Sep 2020 06:49:48 -0400
Received: from mga06.intel.com ([134.134.136.31]:21877 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726932AbgIJKqr (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 10 Sep 2020 06:46:47 -0400
IronPort-SDR: gsnL3XoYtFLgU9MMq6XFDmMuJjMc7PqVM5Anrl9k3S3AvA2uL7JsfRqfkfRN+bgL26zL8Z4Hod
 GIUQl6shTlSQ==
X-IronPort-AV: E=McAfee;i="6000,8403,9739"; a="220066292"
X-IronPort-AV: E=Sophos;i="5.76,412,1592895600"; 
   d="scan'208";a="220066292"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Sep 2020 03:43:35 -0700
IronPort-SDR: qqVbpwoHpXRw4uXJ/tF3bbA1eNSZ9spkgvcv01qCUk9F3wUDG1llqTkogCuM1gdz7aeNmlTVRt
 OEIkkJhIargg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.76,412,1592895600"; 
   d="scan'208";a="334137214"
Received: from jacob-builder.jf.intel.com ([10.7.199.155])
  by orsmga008.jf.intel.com with ESMTP; 10 Sep 2020 03:43:35 -0700
From:   Liu Yi L <yi.l.liu@intel.com>
To:     alex.williamson@redhat.com, eric.auger@redhat.com,
        baolu.lu@linux.intel.com, joro@8bytes.org
Cc:     kevin.tian@intel.com, jacob.jun.pan@linux.intel.com,
        ashok.raj@intel.com, yi.l.liu@intel.com, jun.j.tian@intel.com,
        yi.y.sun@intel.com, jean-philippe@linaro.org, peterx@redhat.com,
        jasowang@redhat.com, hao.wu@intel.com, stefanha@gmail.com,
        iommu@lists.linux-foundation.org, kvm@vger.kernel.org
Subject: [PATCH v7 12/16] vfio/type1: Add vSVA support for IOMMU-backed mdevs
Date:   Thu, 10 Sep 2020 03:45:29 -0700
Message-Id: <1599734733-6431-13-git-send-email-yi.l.liu@intel.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1599734733-6431-1-git-send-email-yi.l.liu@intel.com>
References: <1599734733-6431-1-git-send-email-yi.l.liu@intel.com>
Sender: kvm-owner@vger.kernel.org
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
 drivers/vfio/vfio_iommu_type1.c | 36 +++++++++++++++++++++++++++++++-----
 1 file changed, 31 insertions(+), 5 deletions(-)

diff --git a/drivers/vfio/vfio_iommu_type1.c b/drivers/vfio/vfio_iommu_type1.c
index b67ce2d..5cef732 100644
--- a/drivers/vfio/vfio_iommu_type1.c
+++ b/drivers/vfio/vfio_iommu_type1.c
@@ -2438,29 +2438,49 @@ static int vfio_iommu_resv_refresh(struct vfio_iommu *iommu,
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
 
 	if (dc->user) {
 		unsigned long arg = *(unsigned long *)dc->data;
 
-		iommu_uapi_sva_unbind_gpasid(dc->domain,
-					     dev, (void __user *)arg);
+		iommu_uapi_sva_unbind_gpasid(dc->domain, iommu_device,
+					     (void __user *)arg);
 	} else {
 		struct iommu_gpasid_bind_data *unbind_data =
 				(struct iommu_gpasid_bind_data *)dc->data;
 
-		iommu_sva_unbind_gpasid(dc->domain, dev, unbind_data);
+		iommu_sva_unbind_gpasid(dc->domain,
+					iommu_device, unbind_data);
 	}
 	return 0;
 }
@@ -3116,8 +3136,14 @@ static int vfio_dev_cache_invalidate_fn(struct device *dev, void *data)
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
2.7.4

