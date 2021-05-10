Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2CF54377C95
	for <lists+kvm@lfdr.de>; Mon, 10 May 2021 08:54:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230151AbhEJGzp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 10 May 2021 02:55:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46416 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230074AbhEJGzp (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 10 May 2021 02:55:45 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 36264C061574
        for <kvm@vger.kernel.org>; Sun,  9 May 2021 23:54:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
        :Reply-To:Content-Type:Content-ID:Content-Description;
        bh=RcSq52eIXwC9wF6wEpHGzusRbVkYO0JaaHKEFZFJCck=; b=Zz0R6k3D4V3mos57AUJaTHimbe
        V+9MYW7gWl24Fn9IA8nku+pWprX6jlYzjrqDtVqRPqdjr4l3C3KNzwGE+7DmpmpcTN1Ufk7kzpTS3
        TLtjBCxlVhCu7XE3I45/BUxSP+oTDbJZaVup5Eq5Ns12GbO2KbQ5xu4j+tVCk05u+J1Gwv+hH+5/j
        oVwoFuRvjAgrdxDXo69Rmtd3Uv3fJ1rfCFupXxaY5NYlFhgPC9yqf1SbTjCivz81uV2DixeHkbjdh
        tVjTkjvWy0OrprHzXI9EqsK1VQGiw2b+CAornGlqpQL6InecJevC0D11cjFErb8MmR/kBE6M/hjT9
        p9vUVrww==;
Received: from [2001:4bb8:198:fbc8:e179:16d2:93d1:8e1] (helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.94 #2 (Red Hat Linux))
        id 1lfzo8-008Lov-Je; Mon, 10 May 2021 06:54:25 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     Joerg Roedel <joro@8bytes.org>,
        Alex Williamson <alex.williamson@redhat.com>
Cc:     David Woodhouse <dwmw2@infradead.org>,
        Lu Baolu <baolu.lu@linux.intel.com>,
        Will Deacon <will@kernel.org>,
        Kirti Wankhede <kwankhede@nvidia.com>,
        Jason Gunthorpe <jgg@ziepe.ca>,
        linux-arm-kernel@lists.infradead.org,
        iommu@lists.linux-foundation.org, kvm@vger.kernel.org
Subject: [PATCH 6/6] iommu: remove iommu_dev_feature_enabled
Date:   Mon, 10 May 2021 08:54:05 +0200
Message-Id: <20210510065405.2334771-7-hch@lst.de>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210510065405.2334771-1-hch@lst.de>
References: <20210510065405.2334771-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Remove the unused iommu_dev_feature_enabled function.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c |  1 -
 drivers/iommu/iommu.c                       | 13 -------------
 include/linux/iommu.h                       |  9 ---------
 3 files changed, 23 deletions(-)

diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
index 9689563eec0f30..77deabf2ab9c83 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
@@ -2666,7 +2666,6 @@ static struct iommu_ops arm_smmu_ops = {
 	.of_xlate		= arm_smmu_of_xlate,
 	.get_resv_regions	= arm_smmu_get_resv_regions,
 	.put_resv_regions	= generic_iommu_put_resv_regions,
-	.dev_feat_enabled	= arm_smmu_dev_feature_enabled,
 	.dev_enable_feat	= arm_smmu_dev_enable_feature,
 	.dev_disable_feat	= arm_smmu_dev_disable_feature,
 	.sva_bind		= arm_smmu_sva_bind,
diff --git a/drivers/iommu/iommu.c b/drivers/iommu/iommu.c
index c4b92270946c2f..3d0d67b918a98f 100644
--- a/drivers/iommu/iommu.c
+++ b/drivers/iommu/iommu.c
@@ -2888,19 +2888,6 @@ int iommu_dev_disable_feature(struct device *dev, enum iommu_dev_features feat)
 }
 EXPORT_SYMBOL_GPL(iommu_dev_disable_feature);
 
-bool iommu_dev_feature_enabled(struct device *dev, enum iommu_dev_features feat)
-{
-	if (dev->iommu && dev->iommu->iommu_dev) {
-		const struct iommu_ops *ops = dev->iommu->iommu_dev->ops;
-
-		if (ops->dev_feat_enabled)
-			return ops->dev_feat_enabled(dev, feat);
-	}
-
-	return false;
-}
-EXPORT_SYMBOL_GPL(iommu_dev_feature_enabled);
-
 /**
  * iommu_sva_bind_device() - Bind a process address space to a device
  * @dev: the device
diff --git a/include/linux/iommu.h b/include/linux/iommu.h
index ef9e7dcef76e90..c0685c88b3f8b5 100644
--- a/include/linux/iommu.h
+++ b/include/linux/iommu.h
@@ -198,7 +198,6 @@ struct iommu_iotlb_gather {
  *                      driver init to device driver init (default no)
  * @dev_has/enable/disable_feat: per device entries to check/enable/disable
  *                               iommu specific features.
- * @dev_feat_enabled: check enabled feature
  * @aux_attach/detach_dev: aux-domain specific attach/detach entries.
  * @sva_bind: Bind process address space to device
  * @sva_unbind: Unbind process address space from device
@@ -252,7 +251,6 @@ struct iommu_ops {
 	bool (*is_attach_deferred)(struct iommu_domain *domain, struct device *dev);
 
 	/* Per device IOMMU features */
-	bool (*dev_feat_enabled)(struct device *dev, enum iommu_dev_features f);
 	int (*dev_enable_feat)(struct device *dev, enum iommu_dev_features f);
 	int (*dev_disable_feat)(struct device *dev, enum iommu_dev_features f);
 
@@ -583,7 +581,6 @@ void iommu_release_device(struct device *dev);
 
 int iommu_dev_enable_feature(struct device *dev, enum iommu_dev_features f);
 int iommu_dev_disable_feature(struct device *dev, enum iommu_dev_features f);
-bool iommu_dev_feature_enabled(struct device *dev, enum iommu_dev_features f);
 
 struct iommu_sva *iommu_sva_bind_device(struct device *dev,
 					struct mm_struct *mm,
@@ -905,12 +902,6 @@ const struct iommu_ops *iommu_ops_from_fwnode(struct fwnode_handle *fwnode)
 	return NULL;
 }
 
-static inline bool
-iommu_dev_feature_enabled(struct device *dev, enum iommu_dev_features feat)
-{
-	return false;
-}
-
 static inline int
 iommu_dev_enable_feature(struct device *dev, enum iommu_dev_features feat)
 {
-- 
2.30.2

