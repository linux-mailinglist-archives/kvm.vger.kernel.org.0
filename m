Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 57B8B43C808
	for <lists+kvm@lfdr.de>; Wed, 27 Oct 2021 12:47:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239786AbhJ0Kt3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 27 Oct 2021 06:49:29 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:29765 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S237283AbhJ0Kt2 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 27 Oct 2021 06:49:28 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1635331622;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=4jf1m3TJlglHhUX7yLsviN+p9FvmvAmCzhSZjHu7gUY=;
        b=SBvyK5ohu+tMjx1OK0WY7UtNuJvLnmUAO7A1G8RSuUwvO47pO5RpzbIzpSUwMi4KW+gk1o
        xNCYxuzRIDhMrN+X/h6AFP5Aq6MxRFglr9u/jBMcRasYOSqh0sGOwqKZLt/qeC933S/lvw
        KwB0d8EP+BZ6dVVzDKP8m92z238XiJ8=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-457-sitbeS-9M3-FpXC8aIuiYQ-1; Wed, 27 Oct 2021 06:47:01 -0400
X-MC-Unique: sitbeS-9M3-FpXC8aIuiYQ-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id B597D89CD12;
        Wed, 27 Oct 2021 10:46:57 +0000 (UTC)
Received: from laptop.redhat.com (unknown [10.39.193.154])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 571721042AEE;
        Wed, 27 Oct 2021 10:46:40 +0000 (UTC)
From:   Eric Auger <eric.auger@redhat.com>
To:     eric.auger.pro@gmail.com, eric.auger@redhat.com,
        iommu@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu, joro@8bytes.org,
        will@kernel.org, robin.murphy@arm.com, jean-philippe@linaro.org,
        zhukeqian1@huawei.com
Cc:     alex.williamson@redhat.com, jacob.jun.pan@linux.intel.com,
        yi.l.liu@intel.com, kevin.tian@intel.com, ashok.raj@intel.com,
        maz@kernel.org, peter.maydell@linaro.org, vivek.gautam@arm.com,
        shameerali.kolothum.thodi@huawei.com, wangxingang5@huawei.com,
        jiangkunkun@huawei.com, yuzenghui@huawei.com,
        nicoleotsuka@gmail.com, chenxiang66@hisilicon.com,
        sumitg@nvidia.com, nicolinc@nvidia.com, vdumpa@nvidia.com,
        zhangfei.gao@linaro.org, zhangfei.gao@gmail.com,
        lushenming@huawei.com, vsethi@nvidia.com
Subject: [RFC v16 9/9] iommu/smmuv3: Disallow nested mode in presence of HW MSI regions
Date:   Wed, 27 Oct 2021 12:44:28 +0200
Message-Id: <20211027104428.1059740-10-eric.auger@redhat.com>
In-Reply-To: <20211027104428.1059740-1-eric.auger@redhat.com>
References: <20211027104428.1059740-1-eric.auger@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Nested mode currently is not compatible with HW MSI reserved regions.
Indeed MSI transactions targeting those MSI doorbells bypass the SMMU.
This would require the guest to also bypass those ranges but the guest
has no information about them.

Let's check nested mode is not attempted in such configuration.

Signed-off-by: Eric Auger <eric.auger@redhat.com>
---
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c | 23 +++++++++++++++++++++
 1 file changed, 23 insertions(+)

diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
index ddfc069c10ae..12e7d7920f27 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
@@ -2488,6 +2488,23 @@ static void arm_smmu_detach_dev(struct arm_smmu_master *master)
 	arm_smmu_install_ste_for_dev(master);
 }
 
+static bool arm_smmu_has_hw_msi_resv_region(struct device *dev)
+{
+	struct iommu_resv_region *region;
+	bool has_msi_resv_region = false;
+	LIST_HEAD(resv_regions);
+
+	iommu_get_resv_regions(dev, &resv_regions);
+	list_for_each_entry(region, &resv_regions, list) {
+		if (region->type == IOMMU_RESV_MSI) {
+			has_msi_resv_region = true;
+			break;
+		}
+	}
+	iommu_put_resv_regions(dev, &resv_regions);
+	return has_msi_resv_region;
+}
+
 static int arm_smmu_attach_dev(struct iommu_domain *domain, struct device *dev)
 {
 	int ret = 0;
@@ -2545,6 +2562,12 @@ static int arm_smmu_attach_dev(struct iommu_domain *domain, struct device *dev)
 		ret = -EINVAL;
 		goto out_unlock;
 	}
+	/* Nested mode is not compatible with MSI HW reserved regions */
+	if (smmu_domain->stage == ARM_SMMU_DOMAIN_NESTED &&
+	    arm_smmu_has_hw_msi_resv_region(dev)) {
+		ret = -EINVAL;
+		goto out_unlock;
+	}
 
 	master->domain = smmu_domain;
 
-- 
2.26.3

