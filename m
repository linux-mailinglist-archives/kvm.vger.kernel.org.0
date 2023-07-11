Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4801374E2FD
	for <lists+kvm@lfdr.de>; Tue, 11 Jul 2023 03:09:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231186AbjGKBJC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 10 Jul 2023 21:09:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50572 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231177AbjGKBI5 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 10 Jul 2023 21:08:57 -0400
Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 28E53E7A;
        Mon, 10 Jul 2023 18:08:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1689037732; x=1720573732;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=KFCYwINW+Ez0BStnuTZ0pJyGBX2+iWULH1gI+15dKZA=;
  b=LE66WEKzBF8h3unZK8MDTnJNOaX/dldl+D9mnLaD8yCKfAguGYSsSON3
   qO1dcMqbF7xpZM7JJD3S/3FRetiGiwWg/r8pk3zp2OfoeBYjD6tTvp6I7
   2blXtFEc55iWRW42iHLrNCIFdZi/9AQ4kFHNsKCjJ5d1fZRSFux5li6L8
   p6+s6w5l+rLNgSbLTT+J2AhUpDVs/r2uK1H63vq4WRnNNrewMt1flvKXc
   RcRktOigxJ+GMPxIbTDlTcB1kxBDTbCfHAlBJeA6Q2L+Uzh3O+w2COXvr
   5dGSDrYHcQXHYra9YS1rWSfMbpI04pNvBHqlnUzIi8G5+GUPGeOiVm6l6
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10767"; a="344816099"
X-IronPort-AV: E=Sophos;i="6.01,195,1684825200"; 
   d="scan'208";a="344816099"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Jul 2023 18:08:51 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10767"; a="810999867"
X-IronPort-AV: E=Sophos;i="6.01,195,1684825200"; 
   d="scan'208";a="810999867"
Received: from allen-box.sh.intel.com ([10.239.159.127])
  by FMSMGA003.fm.intel.com with ESMTP; 10 Jul 2023 18:08:48 -0700
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
Subject: [PATCH 4/9] iommu: Change the return value of dev_iommu_get()
Date:   Tue, 11 Jul 2023 09:06:37 +0800
Message-Id: <20230711010642.19707-5-baolu.lu@linux.intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230711010642.19707-1-baolu.lu@linux.intel.com>
References: <20230711010642.19707-1-baolu.lu@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Make dev_iommu_get() return 0 for success and error numbers for failure.
This will make the code neat and readable. No functionality changes.

Signed-off-by: Lu Baolu <baolu.lu@linux.intel.com>
---
 drivers/iommu/iommu.c | 19 ++++++++++---------
 1 file changed, 10 insertions(+), 9 deletions(-)

diff --git a/drivers/iommu/iommu.c b/drivers/iommu/iommu.c
index 41328f03e8b4..65895b987e22 100644
--- a/drivers/iommu/iommu.c
+++ b/drivers/iommu/iommu.c
@@ -287,20 +287,20 @@ void iommu_device_unregister(struct iommu_device *iommu)
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
@@ -351,10 +351,9 @@ static int __iommu_probe_device(struct device *dev, struct list_head *group_list
 	 * but for now enforcing a simple global ordering is fine.
 	 */
 	mutex_lock(&iommu_probe_device_lock);
-	if (!dev_iommu_get(dev)) {
-		ret = -ENOMEM;
+	ret = dev_iommu_get(dev);
+	if (ret)
 		goto err_unlock;
-	}
 
 	if (!try_module_get(ops->owner)) {
 		ret = -EINVAL;
@@ -2751,12 +2750,14 @@ int iommu_fwspec_init(struct device *dev, struct fwnode_handle *iommu_fwnode,
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

