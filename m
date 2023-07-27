Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EA07476463D
	for <lists+kvm@lfdr.de>; Thu, 27 Jul 2023 07:52:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232665AbjG0FwE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 27 Jul 2023 01:52:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41168 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232422AbjG0Fvv (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 27 Jul 2023 01:51:51 -0400
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 99A5530F3;
        Wed, 26 Jul 2023 22:51:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1690437086; x=1721973086;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=rapigetQWIYey116Fahotdb3UUfJeYnWhEFac994Gac=;
  b=Yy/VTgVEncOuV0XJh2UlBNkcNhnKRBO5hENnPQoH1AH5RiKzsdQt+WNV
   v70xz/LaQQoRYALRDI5MhzxHTC2P55SzF+FQrQLKZ65pzr1BrTJ0VydmT
   eUIX818Ke53S2K/3NcM0SjUQ/reVJWFtO7XBNnEWqMc32BtmLB9q3Wokk
   W1zElZCRAqHi55JudSPHDlYxbiTFISzLjYdXCiSaG5GRF2siJZsdaPnW3
   yytCpU3H16MjKENQuOj+Z9V4s+wYJQflDSFg+FOMfvdDvqPwM8dFpSDjQ
   emtTy0SUxrPS3wb9FU0OG7t/a7wgypThNKi1vyvRDiLRFZhm7xKbNrrXa
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10783"; a="399152537"
X-IronPort-AV: E=Sophos;i="6.01,234,1684825200"; 
   d="scan'208";a="399152537"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Jul 2023 22:51:05 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10783"; a="840585289"
X-IronPort-AV: E=Sophos;i="6.01,234,1684825200"; 
   d="scan'208";a="840585289"
Received: from allen-box.sh.intel.com ([10.239.159.127])
  by fmsmga002.fm.intel.com with ESMTP; 26 Jul 2023 22:51:02 -0700
From:   Lu Baolu <baolu.lu@linux.intel.com>
To:     Joerg Roedel <joro@8bytes.org>, Will Deacon <will@kernel.org>,
        Robin Murphy <robin.murphy@arm.com>,
        Jason Gunthorpe <jgg@ziepe.ca>,
        Kevin Tian <kevin.tian@intel.com>,
        Jean-Philippe Brucker <jean-philippe@linaro.org>,
        Nicolin Chen <nicolinc@nvidia.com>
Cc:     Yi Liu <yi.l.liu@intel.com>,
        Jacob Pan <jacob.jun.pan@linux.intel.com>,
        iommu@lists.linux.dev, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Lu Baolu <baolu.lu@linux.intel.com>
Subject: [PATCH v2 05/12] iommu: Change the return value of dev_iommu_get()
Date:   Thu, 27 Jul 2023 13:48:30 +0800
Message-Id: <20230727054837.147050-6-baolu.lu@linux.intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230727054837.147050-1-baolu.lu@linux.intel.com>
References: <20230727054837.147050-1-baolu.lu@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Make dev_iommu_get() return 0 for success and error numbers for failure.
This will make the code neat and readable. No functionality changes.

Reviewed-by: Jacob Pan <jacob.jun.pan@linux.intel.com>
Signed-off-by: Lu Baolu <baolu.lu@linux.intel.com>
---
 drivers/iommu/iommu.c | 19 +++++++++++--------
 1 file changed, 11 insertions(+), 8 deletions(-)

diff --git a/drivers/iommu/iommu.c b/drivers/iommu/iommu.c
index 00309f66153b..4ba3bb692993 100644
--- a/drivers/iommu/iommu.c
+++ b/drivers/iommu/iommu.c
@@ -290,20 +290,20 @@ void iommu_device_unregister(struct iommu_device *iommu)
 }
 EXPORT_SYMBOL_GPL(iommu_device_unregister);
 
-static struct dev_iommu *dev_iommu_get(struct device *dev)
+static int dev_iommu_get(struct device *dev)
 {
 	struct dev_iommu *param = dev->iommu;
 
 	if (param)
-		return param;
+		return 0;
 
 	param = kzalloc(sizeof(*param), GFP_KERNEL);
 	if (!param)
-		return NULL;
+		return -ENOMEM;
 
 	mutex_init(&param->lock);
 	dev->iommu = param;
-	return param;
+	return 0;
 }
 
 static void dev_iommu_free(struct device *dev)
@@ -346,8 +346,9 @@ static int iommu_init_device(struct device *dev, const struct iommu_ops *ops)
 	struct iommu_group *group;
 	int ret;
 
-	if (!dev_iommu_get(dev))
-		return -ENOMEM;
+	ret = dev_iommu_get(dev);
+	if (ret)
+		return ret;
 
 	if (!try_module_get(ops->owner)) {
 		ret = -EINVAL;
@@ -2743,12 +2744,14 @@ int iommu_fwspec_init(struct device *dev, struct fwnode_handle *iommu_fwnode,
 		      const struct iommu_ops *ops)
 {
 	struct iommu_fwspec *fwspec = dev_iommu_fwspec_get(dev);
+	int ret;
 
 	if (fwspec)
 		return ops == fwspec->ops ? 0 : -EINVAL;
 
-	if (!dev_iommu_get(dev))
-		return -ENOMEM;
+	ret = dev_iommu_get(dev);
+	if (ret)
+		return ret;
 
 	/* Preallocate for the overwhelmingly common case of 1 ID */
 	fwspec = kzalloc(struct_size(fwspec, ids, 1), GFP_KERNEL);
-- 
2.34.1

