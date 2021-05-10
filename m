Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6217E377C8D
	for <lists+kvm@lfdr.de>; Mon, 10 May 2021 08:54:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230135AbhEJGzi (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 10 May 2021 02:55:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46336 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230098AbhEJGzf (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 10 May 2021 02:55:35 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BEA10C061573
        for <kvm@vger.kernel.org>; Sun,  9 May 2021 23:54:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
        :Reply-To:Content-Type:Content-ID:Content-Description;
        bh=0VMSk2WoZ7U5DtJ0FPU/Vhd6vJz43QHbgxIeBWhNb/I=; b=KFyjDO1zPsK6JPBlXOAElYMkwI
        KQzyEp3R7D5caVRr1N0oJ2D2CUAqaQAoEb4FUeqm6numcnbXvftlVFFu+Qx2DprmftXow1bpkwRpr
        FCw9/Peq73NhBWMt7///LEEBCn58efP6ITA3zURBLg5rt8ivstn41DWHbhzur9273Y7y8SUPr00td
        3G59w9MS8E7jhRNYehv5MASC8AUJBOUJjw5TMYtIX44aHXInsvZI8GnbUVJ3TgDTRzfl14dsv81Ev
        x3NZjmxNebU+sYoOjebp8qey508RCAP6LMXHhiK+b/q5rtLDeIVGwWGgZ5TvjbV7Xw1E6wM435xux
        lwXARPlg==;
Received: from [2001:4bb8:198:fbc8:e179:16d2:93d1:8e1] (helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.94 #2 (Red Hat Linux))
        id 1lfznu-008Lo5-Bp; Mon, 10 May 2021 06:54:10 +0000
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
Subject: [PATCH 1/6] iommu: remove the unused dev_has_feat method
Date:   Mon, 10 May 2021 08:54:00 +0200
Message-Id: <20210510065405.2334771-2-hch@lst.de>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210510065405.2334771-1-hch@lst.de>
References: <20210510065405.2334771-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This method is never actually called.  Simplify the instance in
intel-iommu that is directly called by inlining the relevant code.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c |  1 -
 drivers/iommu/intel/iommu.c                 | 67 ++-------------------
 include/linux/iommu.h                       |  4 +-
 3 files changed, 7 insertions(+), 65 deletions(-)

diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
index 54b2f27b81d439..9689563eec0f30 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
@@ -2666,7 +2666,6 @@ static struct iommu_ops arm_smmu_ops = {
 	.of_xlate		= arm_smmu_of_xlate,
 	.get_resv_regions	= arm_smmu_get_resv_regions,
 	.put_resv_regions	= generic_iommu_put_resv_regions,
-	.dev_has_feat		= arm_smmu_dev_has_feature,
 	.dev_feat_enabled	= arm_smmu_dev_feature_enabled,
 	.dev_enable_feat	= arm_smmu_dev_enable_feature,
 	.dev_disable_feat	= arm_smmu_dev_disable_feature,
diff --git a/drivers/iommu/intel/iommu.c b/drivers/iommu/intel/iommu.c
index 708f430af1c440..ba1060f6785119 100644
--- a/drivers/iommu/intel/iommu.c
+++ b/drivers/iommu/intel/iommu.c
@@ -5326,72 +5326,18 @@ static int intel_iommu_disable_auxd(struct device *dev)
 	return 0;
 }
 
-/*
- * A PCI express designated vendor specific extended capability is defined
- * in the section 3.7 of Intel scalable I/O virtualization technical spec
- * for system software and tools to detect endpoint devices supporting the
- * Intel scalable IO virtualization without host driver dependency.
- *
- * Returns the address of the matching extended capability structure within
- * the device's PCI configuration space or 0 if the device does not support
- * it.
- */
-static int siov_find_pci_dvsec(struct pci_dev *pdev)
-{
-	int pos;
-	u16 vendor, id;
-
-	pos = pci_find_next_ext_capability(pdev, 0, 0x23);
-	while (pos) {
-		pci_read_config_word(pdev, pos + 4, &vendor);
-		pci_read_config_word(pdev, pos + 8, &id);
-		if (vendor == PCI_VENDOR_ID_INTEL && id == 5)
-			return pos;
-
-		pos = pci_find_next_ext_capability(pdev, pos, 0x23);
-	}
-
-	return 0;
-}
-
-static bool
-intel_iommu_dev_has_feat(struct device *dev, enum iommu_dev_features feat)
-{
-	struct device_domain_info *info = get_domain_info(dev);
-
-	if (feat == IOMMU_DEV_FEAT_AUX) {
-		int ret;
-
-		if (!dev_is_pci(dev) || dmar_disabled ||
-		    !scalable_mode_support() || !pasid_mode_support())
-			return false;
-
-		ret = pci_pasid_features(to_pci_dev(dev));
-		if (ret < 0)
-			return false;
-
-		return !!siov_find_pci_dvsec(to_pci_dev(dev));
-	}
-
-	if (feat == IOMMU_DEV_FEAT_IOPF)
-		return info && info->pri_supported;
-
-	if (feat == IOMMU_DEV_FEAT_SVA)
-		return info && (info->iommu->flags & VTD_FLAG_SVM_CAPABLE) &&
-			info->pasid_supported && info->pri_supported &&
-			info->ats_supported;
-
-	return false;
-}
-
 static int
 intel_iommu_dev_enable_feat(struct device *dev, enum iommu_dev_features feat)
 {
 	if (feat == IOMMU_DEV_FEAT_AUX)
 		return intel_iommu_enable_auxd(dev);
 
-	if (feat == IOMMU_DEV_FEAT_IOPF)
-		return intel_iommu_dev_has_feat(dev, feat) ? 0 : -ENODEV;
+	if (feat == IOMMU_DEV_FEAT_IOPF) {
+		struct device_domain_info *info = get_domain_info(dev);
+
+		if (info &&  info->pri_supported)
+			return 0;
+	}
 
 	if (feat == IOMMU_DEV_FEAT_SVA) {
 		struct device_domain_info *info = get_domain_info(dev);
@@ -5552,7 +5498,6 @@ const struct iommu_ops intel_iommu_ops = {
 	.get_resv_regions	= intel_iommu_get_resv_regions,
 	.put_resv_regions	= generic_iommu_put_resv_regions,
 	.device_group		= intel_iommu_device_group,
-	.dev_has_feat		= intel_iommu_dev_has_feat,
 	.dev_feat_enabled	= intel_iommu_dev_feat_enabled,
 	.dev_enable_feat	= intel_iommu_dev_enable_feat,
 	.dev_disable_feat	= intel_iommu_dev_disable_feat,
diff --git a/include/linux/iommu.h b/include/linux/iommu.h
index 32d448050bf76e..1092a7f967a5e8 100644
--- a/include/linux/iommu.h
+++ b/include/linux/iommu.h
@@ -141,8 +141,7 @@ struct iommu_resv_region {
  *			 supported, this feature must be enabled before and
  *			 disabled after %IOMMU_DEV_FEAT_SVA.
  *
- * Device drivers query whether a feature is supported using
- * iommu_dev_has_feature(), and enable it using iommu_dev_enable_feature().
+ * Device drivers enable a feature using iommu_dev_enable_feature().
  */
 enum iommu_dev_features {
 	IOMMU_DEV_FEAT_AUX,
@@ -256,7 +255,6 @@ struct iommu_ops {
 	bool (*is_attach_deferred)(struct iommu_domain *domain, struct device *dev);
 
 	/* Per device IOMMU features */
-	bool (*dev_has_feat)(struct device *dev, enum iommu_dev_features f);
 	bool (*dev_feat_enabled)(struct device *dev, enum iommu_dev_features f);
 	int (*dev_enable_feat)(struct device *dev, enum iommu_dev_features f);
 	int (*dev_disable_feat)(struct device *dev, enum iommu_dev_features f);
-- 
2.30.2

