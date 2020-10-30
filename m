Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1A93829FCEB
	for <lists+kvm@lfdr.de>; Fri, 30 Oct 2020 06:05:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726427AbgJ3FFN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 30 Oct 2020 01:05:13 -0400
Received: from mga06.intel.com ([134.134.136.31]:5284 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725771AbgJ3FFM (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 30 Oct 2020 01:05:12 -0400
IronPort-SDR: CmzV1i/joy6Xw4urXRAbi1fAeoO5M/6W7iZo4zCooT1i4tQOMcKN9sjyqsCmNhAkJLRRl33iGT
 1SnDsc5yjE4g==
X-IronPort-AV: E=McAfee;i="6000,8403,9789"; a="230196553"
X-IronPort-AV: E=Sophos;i="5.77,432,1596524400"; 
   d="scan'208";a="230196553"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Oct 2020 22:05:11 -0700
IronPort-SDR: LAC9eXFTdRYGEAuqJicF6BzOJWdyPWAZq2sNCKStnfDq5f+EsVQJvT3m8DWkUsYk0SH/garix/
 T2Sf8JN+V6Og==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.77,432,1596524400"; 
   d="scan'208";a="425261545"
Received: from allen-box.sh.intel.com ([10.239.159.139])
  by fmsmga001.fm.intel.com with ESMTP; 29 Oct 2020 22:05:08 -0700
From:   Lu Baolu <baolu.lu@linux.intel.com>
To:     Joerg Roedel <joro@8bytes.org>,
        Alex Williamson <alex.williamson@redhat.com>
Cc:     Robin Murphy <robin.murphy@arm.com>,
        Jean-Philippe Brucker <jean-philippe@linaro.org>,
        Cornelia Huck <cohuck@redhat.com>,
        Kevin Tian <kevin.tian@intel.com>,
        Ashok Raj <ashok.raj@intel.com>,
        Dave Jiang <dave.jiang@intel.com>,
        Liu Yi L <yi.l.liu@intel.com>, Zeng Xin <xin.zeng@intel.com>,
        iommu@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, Lu Baolu <baolu.lu@linux.intel.com>
Subject: [PATCH v6 2/5] iommu: Use bus iommu ops for aux related callback
Date:   Fri, 30 Oct 2020 12:58:06 +0800
Message-Id: <20201030045809.957927-3-baolu.lu@linux.intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20201030045809.957927-1-baolu.lu@linux.intel.com>
References: <20201030045809.957927-1-baolu.lu@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The aux-domain apis were designed for macro driver where the subdevices
are created and used inside a device driver. Use the device's bus iommu
ops instead of that in iommu domain for various callbacks.

Signed-off-by: Lu Baolu <baolu.lu@linux.intel.com>
---
 drivers/iommu/iommu.c | 16 ++++++++++------
 1 file changed, 10 insertions(+), 6 deletions(-)

diff --git a/drivers/iommu/iommu.c b/drivers/iommu/iommu.c
index 6bbdd959f9f3..17f2686664db 100644
--- a/drivers/iommu/iommu.c
+++ b/drivers/iommu/iommu.c
@@ -2913,10 +2913,11 @@ EXPORT_SYMBOL_GPL(iommu_dev_feature_enabled);
  */
 int iommu_aux_attach_device(struct iommu_domain *domain, struct device *dev)
 {
+	const struct iommu_ops *ops = dev->bus->iommu_ops;
 	int ret = -ENODEV;
 
-	if (domain->ops->aux_attach_dev)
-		ret = domain->ops->aux_attach_dev(domain, dev);
+	if (ops && ops->aux_attach_dev)
+		ret = ops->aux_attach_dev(domain, dev);
 
 	if (!ret)
 		trace_attach_device_to_domain(dev);
@@ -2927,8 +2928,10 @@ EXPORT_SYMBOL_GPL(iommu_aux_attach_device);
 
 void iommu_aux_detach_device(struct iommu_domain *domain, struct device *dev)
 {
-	if (domain->ops->aux_detach_dev) {
-		domain->ops->aux_detach_dev(domain, dev);
+	const struct iommu_ops *ops = dev->bus->iommu_ops;
+
+	if (ops && ops->aux_detach_dev) {
+		ops->aux_detach_dev(domain, dev);
 		trace_detach_device_from_domain(dev);
 	}
 }
@@ -2936,10 +2939,11 @@ EXPORT_SYMBOL_GPL(iommu_aux_detach_device);
 
 int iommu_aux_get_pasid(struct iommu_domain *domain, struct device *dev)
 {
+	const struct iommu_ops *ops = dev->bus->iommu_ops;
 	int ret = -ENODEV;
 
-	if (domain->ops->aux_get_pasid)
-		ret = domain->ops->aux_get_pasid(domain, dev);
+	if (ops && ops->aux_get_pasid)
+		ret = ops->aux_get_pasid(domain, dev);
 
 	return ret;
 }
-- 
2.25.1

