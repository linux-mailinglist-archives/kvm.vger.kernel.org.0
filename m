Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D15D92B7C8B
	for <lists+kvm@lfdr.de>; Wed, 18 Nov 2020 12:25:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727955AbgKRLXk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 18 Nov 2020 06:23:40 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:54208 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727862AbgKRLXj (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 18 Nov 2020 06:23:39 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1605698618;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=TA1QvZ93EHB7m+hrprtLWjkU3K78UufqyzxGxy4KwAk=;
        b=FDx8b65Nr0mM+UBIJ8qYDvHrBAH/ingvQFkbliXX1hjsjWeRC93HGWz9TMZ9ofhvH1/9u7
        1ztTPPGCc6GyQVcDPKy3ZTgMQ0HY/zFKB0A0L9STpK9ShNkyU359Rue+JwLxwRl0nAlgIb
        ytP7SgHeW1FYhVuWWq1UjqtowaKFx68=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-185-ClfTY1ZiPI6WwmbbonCnVQ-1; Wed, 18 Nov 2020 06:23:33 -0500
X-MC-Unique: ClfTY1ZiPI6WwmbbonCnVQ-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 12DED1891E84;
        Wed, 18 Nov 2020 11:23:31 +0000 (UTC)
Received: from laptop.redhat.com (ovpn-115-104.ams2.redhat.com [10.36.115.104])
        by smtp.corp.redhat.com (Postfix) with ESMTP id D2AC35B4A0;
        Wed, 18 Nov 2020 11:23:20 +0000 (UTC)
From:   Eric Auger <eric.auger@redhat.com>
To:     eric.auger.pro@gmail.com, eric.auger@redhat.com,
        iommu@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu, will@kernel.org,
        joro@8bytes.org, maz@kernel.org, robin.murphy@arm.com,
        alex.williamson@redhat.com
Cc:     jean-philippe@linaro.org, zhangfei.gao@linaro.org,
        zhangfei.gao@gmail.com, vivek.gautam@arm.com,
        shameerali.kolothum.thodi@huawei.com,
        jacob.jun.pan@linux.intel.com, yi.l.liu@intel.com, tn@semihalf.com,
        nicoleotsuka@gmail.com, yuzenghui@huawei.com
Subject: [PATCH v13 11/15] iommu/smmuv3: Enforce incompatibility between nested mode and HW MSI regions
Date:   Wed, 18 Nov 2020 12:21:47 +0100
Message-Id: <20201118112151.25412-12-eric.auger@redhat.com>
In-Reply-To: <20201118112151.25412-1-eric.auger@redhat.com>
References: <20201118112151.25412-1-eric.auger@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Nested mode currently is not compatible with HW MSI reserved regions.
Indeed MSI transactions targeting this MSI doorbells bypass the SMMU.

Let's check nested mode is not attempted in such configuration.

Signed-off-by: Eric Auger <eric.auger@redhat.com>
---
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c | 23 +++++++++++++++++++--
 1 file changed, 21 insertions(+), 2 deletions(-)

diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
index 5a05c2074c8a..ccf2fef10b69 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
@@ -2296,6 +2296,23 @@ static bool arm_smmu_share_msi_domain(struct iommu_domain *domain,
 	return share;
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
@@ -2350,10 +2367,12 @@ static int arm_smmu_attach_dev(struct iommu_domain *domain, struct device *dev)
 	/*
 	 * In nested mode we must check all devices belonging to the
 	 * domain share the same physical MSI doorbell. Otherwise nested
-	 * stage MSI binding is not supported.
+	 * stage MSI binding is not supported. Also nested mode is not
+	 * compatible with MSI HW reserved regions.
 	 */
 	if (smmu_domain->stage == ARM_SMMU_DOMAIN_NESTED &&
-		!arm_smmu_share_msi_domain(domain, dev)) {
+		(!arm_smmu_share_msi_domain(domain, dev) ||
+		 arm_smmu_has_hw_msi_resv_region(dev))) {
 		ret = -EINVAL;
 		goto out_unlock;
 	}
-- 
2.21.3

