Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AA2AE3232B9
	for <lists+kvm@lfdr.de>; Tue, 23 Feb 2021 22:01:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231830AbhBWVAp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 23 Feb 2021 16:00:45 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:24746 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232730AbhBWU7g (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 23 Feb 2021 15:59:36 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1614113889;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=2Zf0tQxvRnkHA8cBVweUBHsnktsdQfi9e1GZo42Y2is=;
        b=SKjK9H/3KEj6BvjScVQXq2qWK8wnUreAk+lxh9SxrVMdpxSIxb3uciG6piXBgt5J7WcSmQ
        21kH63N4rzCjhiSGFy0a/vooC1JyzhLDik4ajjaI2vWpDQ1wuV/aPMP87ROSDkaUaPsWYs
        cNWCt57779PA4u4VF8nyr6bilehJO0c=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-357-EdtV7JUnMjqHcwchA4zbCg-1; Tue, 23 Feb 2021 15:58:05 -0500
X-MC-Unique: EdtV7JUnMjqHcwchA4zbCg-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id B9DE7E752;
        Tue, 23 Feb 2021 20:58:01 +0000 (UTC)
Received: from laptop.redhat.com (ovpn-114-34.ams2.redhat.com [10.36.114.34])
        by smtp.corp.redhat.com (Postfix) with ESMTP id A96375D9D0;
        Tue, 23 Feb 2021 20:57:45 +0000 (UTC)
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
Subject: [PATCH v14 07/13] iommu/smmuv3: Implement cache_invalidate
Date:   Tue, 23 Feb 2021 21:56:28 +0100
Message-Id: <20210223205634.604221-8-eric.auger@redhat.com>
In-Reply-To: <20210223205634.604221-1-eric.auger@redhat.com>
References: <20210223205634.604221-1-eric.auger@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Implement domain-selective, pasid selective and page-selective
IOTLB invalidations.

Signed-off-by: Eric Auger <eric.auger@redhat.com>

---

v13 -> v14:
- Add domain invalidation
- do global inval when asid is not provided with addr
  granularity

v7 -> v8:
- ASID based invalidation using iommu_inv_pasid_info
- check ARCHID/PASID flags in addr based invalidation
- use __arm_smmu_tlb_inv_context and __arm_smmu_tlb_inv_range_nosync

v6 -> v7
- check the uapi version

v3 -> v4:
- adapt to changes in the uapi
- add support for leaf parameter
- do not use arm_smmu_tlb_inv_range_nosync or arm_smmu_tlb_inv_context
  anymore

v2 -> v3:
- replace __arm_smmu_tlb_sync by arm_smmu_cmdq_issue_sync

v1 -> v2:
- properly pass the asid
---
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c | 74 +++++++++++++++++++++
 1 file changed, 74 insertions(+)

diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
index 4c19a1114de4..df3adc49111c 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
@@ -2949,6 +2949,79 @@ static void arm_smmu_detach_pasid_table(struct iommu_domain *domain)
 	mutex_unlock(&smmu_domain->init_mutex);
 }
 
+static int
+arm_smmu_cache_invalidate(struct iommu_domain *domain, struct device *dev,
+			  struct iommu_cache_invalidate_info *inv_info)
+{
+	struct arm_smmu_cmdq_ent cmd = {.opcode = CMDQ_OP_TLBI_NSNH_ALL};
+	struct arm_smmu_domain *smmu_domain = to_smmu_domain(domain);
+	struct arm_smmu_device *smmu = smmu_domain->smmu;
+
+	if (smmu_domain->stage != ARM_SMMU_DOMAIN_NESTED)
+		return -EINVAL;
+
+	if (!smmu)
+		return -EINVAL;
+
+	if (inv_info->version != IOMMU_CACHE_INVALIDATE_INFO_VERSION_1)
+		return -EINVAL;
+
+	if (inv_info->cache & IOMMU_CACHE_INV_TYPE_PASID ||
+	    inv_info->cache & IOMMU_CACHE_INV_TYPE_DEV_IOTLB) {
+		return -ENOENT;
+	}
+
+	if (!(inv_info->cache & IOMMU_CACHE_INV_TYPE_IOTLB))
+		return -EINVAL;
+
+	/* IOTLB invalidation */
+
+	switch (inv_info->granularity) {
+	case IOMMU_INV_GRANU_PASID:
+	{
+		struct iommu_inv_pasid_info *info =
+			&inv_info->granu.pasid_info;
+
+		if (info->flags & IOMMU_INV_ADDR_FLAGS_PASID)
+			return -ENOENT;
+		if (!(info->flags & IOMMU_INV_PASID_FLAGS_ARCHID))
+			return -EINVAL;
+
+		__arm_smmu_tlb_inv_context(smmu_domain, info->archid);
+		return 0;
+	}
+	case IOMMU_INV_GRANU_ADDR:
+	{
+		struct iommu_inv_addr_info *info = &inv_info->granu.addr_info;
+		size_t size = info->nb_granules * info->granule_size;
+		bool leaf = info->flags & IOMMU_INV_ADDR_FLAGS_LEAF;
+
+		if (info->flags & IOMMU_INV_ADDR_FLAGS_PASID)
+			return -ENOENT;
+
+		if (!(info->flags & IOMMU_INV_ADDR_FLAGS_ARCHID))
+			break;
+
+		arm_smmu_tlb_inv_range_domain(info->addr, size,
+					      info->granule_size, leaf,
+					      info->archid, smmu_domain);
+
+		arm_smmu_cmdq_issue_sync(smmu);
+		return 0;
+	}
+	case IOMMU_INV_GRANU_DOMAIN:
+		break;
+	default:
+		return -EINVAL;
+	}
+
+	/* Global S1 invalidation */
+	cmd.tlbi.vmid   = smmu_domain->s2_cfg.vmid;
+	arm_smmu_cmdq_issue_cmd(smmu, &cmd);
+	arm_smmu_cmdq_issue_sync(smmu);
+	return 0;
+}
+
 static bool arm_smmu_dev_has_feature(struct device *dev,
 				     enum iommu_dev_features feat)
 {
@@ -3048,6 +3121,7 @@ static struct iommu_ops arm_smmu_ops = {
 	.put_resv_regions	= generic_iommu_put_resv_regions,
 	.attach_pasid_table	= arm_smmu_attach_pasid_table,
 	.detach_pasid_table	= arm_smmu_detach_pasid_table,
+	.cache_invalidate	= arm_smmu_cache_invalidate,
 	.dev_has_feat		= arm_smmu_dev_has_feature,
 	.dev_feat_enabled	= arm_smmu_dev_feature_enabled,
 	.dev_enable_feat	= arm_smmu_dev_enable_feature,
-- 
2.26.2

