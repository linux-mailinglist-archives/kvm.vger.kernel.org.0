Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1C98B2B419D
	for <lists+kvm@lfdr.de>; Mon, 16 Nov 2020 11:46:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729459AbgKPKpB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 16 Nov 2020 05:45:01 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:28619 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729434AbgKPKpA (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 16 Nov 2020 05:45:00 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1605523498;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=oEgdYkNM3jqg5gj2etSX4w67affN+BFuiyONEoNAjNs=;
        b=QvLDMDNiUF8lO80XsR2p4bbQS5yWRJ1PVXNf25jYQRIep3r8rInvExf264TBjshkBMnLiD
        bWK8KVhwTusjn78nAQDdcSEAzfgVxtdP3Bzyx+meLFiNt/l6FPkeGiqg9NHkcdeJFainlx
        vFGzESheO+YqB2jz84j7R1weRqTHtE0=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-590-mUeifrzjP9-60bEOIt_qug-1; Mon, 16 Nov 2020 05:44:57 -0500
X-MC-Unique: mUeifrzjP9-60bEOIt_qug-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 012E9108E1A2;
        Mon, 16 Nov 2020 10:44:50 +0000 (UTC)
Received: from laptop.redhat.com (ovpn-113-230.ams2.redhat.com [10.36.113.230])
        by smtp.corp.redhat.com (Postfix) with ESMTP id B14AC5C5AF;
        Mon, 16 Nov 2020 10:44:39 +0000 (UTC)
From:   Eric Auger <eric.auger@redhat.com>
To:     eric.auger.pro@gmail.com, eric.auger@redhat.com,
        iommu@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu, will@kernel.org,
        joro@8bytes.org, maz@kernel.org, robin.murphy@arm.com
Cc:     jean-philippe@linaro.org, zhangfei.gao@linaro.org,
        zhangfei.gao@gmail.com, vivek.gautam@arm.com,
        shameerali.kolothum.thodi@huawei.com, alex.williamson@redhat.com,
        jacob.jun.pan@linux.intel.com, yi.l.liu@intel.com, tn@semihalf.com,
        nicoleotsuka@gmail.com
Subject: [PATCH v12 12/15] iommu/smmuv3: Implement bind/unbind_guest_msi
Date:   Mon, 16 Nov 2020 11:43:13 +0100
Message-Id: <20201116104316.31816-13-eric.auger@redhat.com>
In-Reply-To: <20201116104316.31816-1-eric.auger@redhat.com>
References: <20201116104316.31816-1-eric.auger@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
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
index 0c5ab4005f76..5aa9e0e747fa 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
@@ -2738,6 +2738,47 @@ static void arm_smmu_get_resv_regions(struct device *dev,
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
@@ -2970,6 +3011,8 @@ static struct iommu_ops arm_smmu_ops = {
 	.attach_pasid_table	= arm_smmu_attach_pasid_table,
 	.detach_pasid_table	= arm_smmu_detach_pasid_table,
 	.cache_invalidate	= arm_smmu_cache_invalidate,
+	.bind_guest_msi		= arm_smmu_bind_guest_msi,
+	.unbind_guest_msi	= arm_smmu_unbind_guest_msi,
 	.dev_has_feat		= arm_smmu_dev_has_feature,
 	.dev_feat_enabled	= arm_smmu_dev_feature_enabled,
 	.dev_enable_feat	= arm_smmu_dev_enable_feature,
-- 
2.21.3

