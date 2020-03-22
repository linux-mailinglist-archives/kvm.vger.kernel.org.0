Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CD4EB18E8A1
	for <lists+kvm@lfdr.de>; Sun, 22 Mar 2020 13:26:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727116AbgCVM01 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 22 Mar 2020 08:26:27 -0400
Received: from mga18.intel.com ([134.134.136.126]:51562 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727096AbgCVM00 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 22 Mar 2020 08:26:26 -0400
IronPort-SDR: qjSaPrQYT3Myhd6t5jdSMOhQk8R9LkFLLCeeUz2JiM2PgCIWNxxW1Wc+AwjMvgSUfj2xUjsAJr
 d4r+UlMnoYGw==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Mar 2020 05:26:23 -0700
IronPort-SDR: otHhxyJ/DdEO6E/Tuzgk+1XlBpwM4FqDJ5EBJp/djmZ4fXQInX5o+MieGn4MV1FKPSNmXGtVJe
 8kI/ULE5CQrg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.72,292,1580803200"; 
   d="scan'208";a="239663884"
Received: from jacob-builder.jf.intel.com ([10.7.199.155])
  by orsmga008.jf.intel.com with ESMTP; 22 Mar 2020 05:26:23 -0700
From:   "Liu, Yi L" <yi.l.liu@intel.com>
To:     alex.williamson@redhat.com, eric.auger@redhat.com
Cc:     kevin.tian@intel.com, jacob.jun.pan@linux.intel.com,
        joro@8bytes.org, ashok.raj@intel.com, yi.l.liu@intel.com,
        jun.j.tian@intel.com, yi.y.sun@intel.com, jean-philippe@linaro.org,
        peterx@redhat.com, iommu@lists.linux-foundation.org,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org, hao.wu@intel.com
Subject: [PATCH v1 8/8] vfio/type1: Add vSVA support for IOMMU-backed mdevs
Date:   Sun, 22 Mar 2020 05:32:05 -0700
Message-Id: <1584880325-10561-9-git-send-email-yi.l.liu@intel.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1584880325-10561-1-git-send-email-yi.l.liu@intel.com>
References: <1584880325-10561-1-git-send-email-yi.l.liu@intel.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Liu Yi L <yi.l.liu@intel.com>

Recent years, mediated device pass-through framework (e.g. vfio-mdev)
are used to achieve flexible device sharing across domains (e.g. VMs).
Also there are hardware assisted mediated pass-through solutions from
platform vendors. e.g. Intel VT-d scalable mode which supports Intel
Scalable I/O Virtualization technology. Such mdevs are called IOMMU-
backed mdevs as there are IOMMU enforced DMA isolation for such mdevs.
In kernel, IOMMU-backed mdevs are exposed to IOMMU layer by aux-domain
concept, which means mdevs are protected by an iommu domain which is
aux-domain of its physical device. Details can be found in the KVM
presentation from Kevin Tian. IOMMU-backed equals to IOMMU-capable.

https://events19.linuxfoundation.org/wp-content/uploads/2017/12/\
Hardware-Assisted-Mediated-Pass-Through-with-VFIO-Kevin-Tian-Intel.pdf

This patch supports NESTING IOMMU for IOMMU-backed mdevs by figuring
out the physical device of an IOMMU-backed mdev and then invoking IOMMU
requests to IOMMU layer with the physical device and the mdev's aux
domain info.

With this patch, vSVA (Virtual Shared Virtual Addressing) can be used
on IOMMU-backed mdevs.

Cc: Kevin Tian <kevin.tian@intel.com>
CC: Jacob Pan <jacob.jun.pan@linux.intel.com>
CC: Jun Tian <jun.j.tian@intel.com>
Cc: Alex Williamson <alex.williamson@redhat.com>
Cc: Eric Auger <eric.auger@redhat.com>
Cc: Jean-Philippe Brucker <jean-philippe@linaro.org>
Signed-off-by: Liu Yi L <yi.l.liu@intel.com>
---
 drivers/vfio/vfio_iommu_type1.c | 23 ++++++++++++++++++++---
 1 file changed, 20 insertions(+), 3 deletions(-)

diff --git a/drivers/vfio/vfio_iommu_type1.c b/drivers/vfio/vfio_iommu_type1.c
index 937ec3f..d473665 100644
--- a/drivers/vfio/vfio_iommu_type1.c
+++ b/drivers/vfio/vfio_iommu_type1.c
@@ -132,6 +132,7 @@ struct vfio_regions {
 
 struct domain_capsule {
 	struct iommu_domain *domain;
+	struct vfio_group *group;
 	void *data;
 };
 
@@ -148,6 +149,7 @@ static int vfio_iommu_for_each_dev(struct vfio_iommu *iommu,
 	list_for_each_entry(d, &iommu->domain_list, next) {
 		dc.domain = d->domain;
 		list_for_each_entry(g, &d->group_list, next) {
+			dc.group = g;
 			ret = iommu_group_for_each_dev(g->iommu_group,
 						       &dc, fn);
 			if (ret)
@@ -2347,7 +2349,12 @@ static int vfio_bind_gpasid_fn(struct device *dev, void *data)
 	struct iommu_gpasid_bind_data *gbind_data =
 		(struct iommu_gpasid_bind_data *) dc->data;
 
-	return iommu_sva_bind_gpasid(dc->domain, dev, gbind_data);
+	if (dc->group->mdev_group)
+		return iommu_sva_bind_gpasid(dc->domain,
+			vfio_mdev_get_iommu_device(dev), gbind_data);
+	else
+		return iommu_sva_bind_gpasid(dc->domain,
+						dev, gbind_data);
 }
 
 static int vfio_unbind_gpasid_fn(struct device *dev, void *data)
@@ -2356,8 +2363,13 @@ static int vfio_unbind_gpasid_fn(struct device *dev, void *data)
 	struct iommu_gpasid_bind_data *gbind_data =
 		(struct iommu_gpasid_bind_data *) dc->data;
 
-	return iommu_sva_unbind_gpasid(dc->domain, dev,
+	if (dc->group->mdev_group)
+		return iommu_sva_unbind_gpasid(dc->domain,
+					vfio_mdev_get_iommu_device(dev),
 					gbind_data->hpasid);
+	else
+		return iommu_sva_unbind_gpasid(dc->domain, dev,
+						gbind_data->hpasid);
 }
 
 /**
@@ -2429,7 +2441,12 @@ static int vfio_cache_inv_fn(struct device *dev, void *data)
 	struct iommu_cache_invalidate_info *cache_inv_info =
 		(struct iommu_cache_invalidate_info *) dc->data;
 
-	return iommu_cache_invalidate(dc->domain, dev, cache_inv_info);
+	if (dc->group->mdev_group)
+		return iommu_cache_invalidate(dc->domain,
+			vfio_mdev_get_iommu_device(dev), cache_inv_info);
+	else
+		return iommu_cache_invalidate(dc->domain,
+						dev, cache_inv_info);
 }
 
 static long vfio_iommu_type1_ioctl(void *iommu_data,
-- 
2.7.4

