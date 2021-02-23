Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 74CAF3232C0
	for <lists+kvm@lfdr.de>; Tue, 23 Feb 2021 22:03:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234512AbhBWVB6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 23 Feb 2021 16:01:58 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:44735 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233440AbhBWVA3 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 23 Feb 2021 16:00:29 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1614113943;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=SXWc8ATTZ4eP+hdUawfXEBN7iawZP9INSzT40ei/Jzs=;
        b=JDmKD7gEbXCB9kQzQMGPQguZbW/vcEtucTWXVTHfbUXS+M7ObaZrwXXpcBvD6SILFMqhxQ
        0HDeYez8JkhIxz7bK2ck+1XceQVPR3y2dBozaWSFstJFDIy2Ux5m4yYPSif8TQppGjFTDt
        MSGL62aCRifer+OzVwCPugccSUGVggM=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-583-eRb9Sc1COni79CumsNAESQ-1; Tue, 23 Feb 2021 15:58:58 -0500
X-MC-Unique: eRb9Sc1COni79CumsNAESQ-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id DBA22835E27;
        Tue, 23 Feb 2021 20:58:54 +0000 (UTC)
Received: from laptop.redhat.com (ovpn-114-34.ams2.redhat.com [10.36.114.34])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 26D2C5D9D0;
        Tue, 23 Feb 2021 20:58:34 +0000 (UTC)
From:   Eric Auger <eric.auger@redhat.com>
To:     eric.auger.pro@gmail.com, eric.auger@redhat.com,
        iommu@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu, will@kernel.org,
        maz@kernel.org, robin.murphy@arm.com, joro@8bytes.org,
        alex.williamson@redhat.com, tn@semihalf.com, zhukeqian1@huawei.com
Cc:     jacob.jun.pan@linux.intel.com, yi.l.liu@intel.com,
        wangxingang5@huawei.com, jiangkunkun@huawei.com,
        jean-philippe@linaro.org, zhangfei.gao@linaro.org,
        zhangfei.gao@gmail.com, vivek.gautam@arm.com,
        shameerali.kolothum.thodi@huawei.com, yuzenghui@huawei.com,
        nicoleotsuka@gmail.com, lushenming@huawei.com, vsethi@nvidia.com
Subject: [PATCH v14 11/13] iommu/smmuv3: Implement bind/unbind_guest_msi
Date:   Tue, 23 Feb 2021 21:56:32 +0100
Message-Id: <20210223205634.604221-12-eric.auger@redhat.com>
In-Reply-To: <20210223205634.604221-1-eric.auger@redhat.com>
References: <20210223205634.604221-1-eric.auger@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The bind/unbind_guest_msi() callbacks check the domain
is NESTED and redirect to the dma-iommu implementation.

Signed-off-by: Eric Auger <eric.auger@redhat.com>

---

v6 -> v7:
- remove device handle argument
---
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c | 43 +++++++++++++++++++++
 1 file changed, 43 insertions(+)

diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
index ca6f796aeb95..f783c2804872 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
@@ -2922,6 +2922,47 @@ static void arm_smmu_get_resv_regions(struct device *dev,
 	iommu_dma_get_resv_regions(dev, head);
 }
 
+static int
+arm_smmu_bind_guest_msi(struct iommu_domain *domain,
+			dma_addr_t giova, phys_addr_t gpa, size_t size)
+{
+	struct arm_smmu_domain *smmu_domain = to_smmu_domain(domain);
+	struct arm_smmu_device *smmu;
+	int ret = -EINVAL;
+
+	mutex_lock(&smmu_domain->init_mutex);
+	smmu = smmu_domain->smmu;
+	if (!smmu)
+		goto out;
+
+	if (smmu_domain->stage != ARM_SMMU_DOMAIN_NESTED)
+		goto out;
+
+	ret = iommu_dma_bind_guest_msi(domain, giova, gpa, size);
+out:
+	mutex_unlock(&smmu_domain->init_mutex);
+	return ret;
+}
+
+static void
+arm_smmu_unbind_guest_msi(struct iommu_domain *domain, dma_addr_t giova)
+{
+	struct arm_smmu_domain *smmu_domain = to_smmu_domain(domain);
+	struct arm_smmu_device *smmu;
+
+	mutex_lock(&smmu_domain->init_mutex);
+	smmu = smmu_domain->smmu;
+	if (!smmu)
+		goto unlock;
+
+	if (smmu_domain->stage != ARM_SMMU_DOMAIN_NESTED)
+		goto unlock;
+
+	iommu_dma_unbind_guest_msi(domain, giova);
+unlock:
+	mutex_unlock(&smmu_domain->init_mutex);
+}
+
 static int arm_smmu_attach_pasid_table(struct iommu_domain *domain,
 				       struct iommu_pasid_table_config *cfg)
 {
@@ -3182,6 +3223,8 @@ static struct iommu_ops arm_smmu_ops = {
 	.attach_pasid_table	= arm_smmu_attach_pasid_table,
 	.detach_pasid_table	= arm_smmu_detach_pasid_table,
 	.cache_invalidate	= arm_smmu_cache_invalidate,
+	.bind_guest_msi		= arm_smmu_bind_guest_msi,
+	.unbind_guest_msi	= arm_smmu_unbind_guest_msi,
 	.dev_has_feat		= arm_smmu_dev_has_feature,
 	.dev_feat_enabled	= arm_smmu_dev_feature_enabled,
 	.dev_enable_feat	= arm_smmu_dev_enable_feature,
-- 
2.26.2

