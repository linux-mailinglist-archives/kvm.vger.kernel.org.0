Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C69F921E7C8
	for <lists+kvm@lfdr.de>; Tue, 14 Jul 2020 08:01:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726775AbgGNGBy (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 14 Jul 2020 02:01:54 -0400
Received: from mga03.intel.com ([134.134.136.65]:3745 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725876AbgGNGBw (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 14 Jul 2020 02:01:52 -0400
IronPort-SDR: IPjYTnMrSg3MjV5k2RAVAN+sn64h8zcgYR1ODEkZDL9eZCpUCt1HxU3pYvSb4RUPt3Dh3ZP5hm
 FNIqdg3auIKA==
X-IronPort-AV: E=McAfee;i="6000,8403,9681"; a="148812770"
X-IronPort-AV: E=Sophos;i="5.75,350,1589266800"; 
   d="scan'208";a="148812770"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Jul 2020 23:01:52 -0700
IronPort-SDR: DRuNNznlShmbBg/hXeyZXOHyQnvBnJVGJ9EUL1tNG54hFH5bs+YqLyY98X7Se6oqPAhLF2n9Vr
 xJMj4wloh6dQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.75,350,1589266800"; 
   d="scan'208";a="324450171"
Received: from allen-box.sh.intel.com ([10.239.159.139])
  by FMSMGA003.fm.intel.com with ESMTP; 13 Jul 2020 23:01:49 -0700
From:   Lu Baolu <baolu.lu@linux.intel.com>
To:     Joerg Roedel <joro@8bytes.org>,
        Alex Williamson <alex.williamson@redhat.com>
Cc:     Robin Murphy <robin.murphy@arm.com>,
        Jean-Philippe Brucker <jean-philippe@linaro.org>,
        Cornelia Huck <cohuck@redhat.com>,
        Kevin Tian <kevin.tian@intel.com>,
        Ashok Raj <ashok.raj@intel.com>,
        Dave Jiang <dave.jiang@intel.com>,
        Liu Yi L <yi.l.liu@intel.com>,
        iommu@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, Lu Baolu <baolu.lu@linux.intel.com>
Subject: [PATCH v3 1/4] iommu: Check IOMMU_DEV_FEAT_AUX feature in aux api's
Date:   Tue, 14 Jul 2020 13:57:00 +0800
Message-Id: <20200714055703.5510-2-baolu.lu@linux.intel.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200714055703.5510-1-baolu.lu@linux.intel.com>
References: <20200714055703.5510-1-baolu.lu@linux.intel.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The iommu aux-domain api's work only when IOMMU_DEV_FEAT_AUX is enabled
for the device. Add this check to avoid misuse.

Signed-off-by: Lu Baolu <baolu.lu@linux.intel.com>
---
 drivers/iommu/iommu.c | 16 +++++++++-------
 1 file changed, 9 insertions(+), 7 deletions(-)

diff --git a/drivers/iommu/iommu.c b/drivers/iommu/iommu.c
index 1ed1e14a1f0c..e1fdd3531d65 100644
--- a/drivers/iommu/iommu.c
+++ b/drivers/iommu/iommu.c
@@ -2725,11 +2725,13 @@ EXPORT_SYMBOL_GPL(iommu_dev_feature_enabled);
  */
 int iommu_aux_attach_device(struct iommu_domain *domain, struct device *dev)
 {
-	int ret = -ENODEV;
+	int ret;
 
-	if (domain->ops->aux_attach_dev)
-		ret = domain->ops->aux_attach_dev(domain, dev);
+	if (!iommu_dev_feature_enabled(dev, IOMMU_DEV_FEAT_AUX) ||
+	    !domain->ops->aux_attach_dev)
+		return -ENODEV;
 
+	ret = domain->ops->aux_attach_dev(domain, dev);
 	if (!ret)
 		trace_attach_device_to_domain(dev);
 
@@ -2748,12 +2750,12 @@ EXPORT_SYMBOL_GPL(iommu_aux_detach_device);
 
 int iommu_aux_get_pasid(struct iommu_domain *domain, struct device *dev)
 {
-	int ret = -ENODEV;
+	if (!iommu_dev_feature_enabled(dev, IOMMU_DEV_FEAT_AUX) ||
+	    !domain->ops->aux_get_pasid)
+		return -ENODEV;
 
-	if (domain->ops->aux_get_pasid)
-		ret = domain->ops->aux_get_pasid(domain, dev);
+	return domain->ops->aux_get_pasid(domain, dev);
 
-	return ret;
 }
 EXPORT_SYMBOL_GPL(iommu_aux_get_pasid);
 
-- 
2.17.1

