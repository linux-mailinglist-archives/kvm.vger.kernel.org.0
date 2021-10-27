Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 01E2F43C7F7
	for <lists+kvm@lfdr.de>; Wed, 27 Oct 2021 12:46:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241547AbhJ0Ksj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 27 Oct 2021 06:48:39 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:52536 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S241540AbhJ0Kse (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 27 Oct 2021 06:48:34 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1635331568;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=/wWoc6t6AOckXTnAZ7Ldd/3Pb194iKhVVhHdl2FeLkU=;
        b=IzI95/VrB9SvVUZbRKnnPQ37IIYWIeTbLd7H3WGWiVho84TWYDDzU0Ee95Lvwtgc0AlDFa
        9uw+zprhO9Ba5gR9ZkL0c3Lk3YcIRb3mWofPBli+U8vJ/i1hfFIcIrh8sc0J+uzaefdaLL
        RIAhSYtmCeHHxbuasFMtdz465y9z9K4=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-376-IBd4Yo9MP-WEqWhBBS6iLQ-1; Wed, 27 Oct 2021 06:46:05 -0400
X-MC-Unique: IBd4Yo9MP-WEqWhBBS6iLQ-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 0E07210A8E04;
        Wed, 27 Oct 2021 10:46:02 +0000 (UTC)
Received: from laptop.redhat.com (unknown [10.39.193.154])
        by smtp.corp.redhat.com (Postfix) with ESMTP id E769610016FE;
        Wed, 27 Oct 2021 10:45:48 +0000 (UTC)
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
Subject: [RFC v16 5/9] iommu/smmuv3: Implement attach/detach_pasid_table
Date:   Wed, 27 Oct 2021 12:44:24 +0200
Message-Id: <20211027104428.1059740-6-eric.auger@redhat.com>
In-Reply-To: <20211027104428.1059740-1-eric.auger@redhat.com>
References: <20211027104428.1059740-1-eric.auger@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On attach_pasid_table() we program STE S1 related info set
by the guest into the actual physical STEs. At minimum
we need to program the context descriptor GPA and compute
whether the stage1 is translated/bypassed or aborted.

On detach, the stage 1 config is unset and the abort flag is
unset.

Signed-off-by: Eric Auger <eric.auger@redhat.com>

---
v14 -> v15:
- add a comment before arm_smmu_get_cd_ptr to warn the
  developper this function must not be used in case of nested
  (Keqian)

v13 -> v14:
- on PASID table detach, reset the abort flag (Keqian)

v7 -> v8:
- remove smmu->features check, now done on domain finalize

v6 -> v7:
- check versions and comment the fact we don't need to take
  into account s1dss and s1fmt
v3 -> v4:
- adapt to changes in iommu_pasid_table_config
- different programming convention at s1_cfg/s2_cfg/ste.abort

v2 -> v3:
- callback now is named set_pasid_table and struct fields
  are laid out differently.

v1 -> v2:
- invalidate the STE before changing them
- hold init_mutex
- handle new fields
---
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c | 93 +++++++++++++++++++++
 1 file changed, 93 insertions(+)

diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
index 5e0917e1226b..bb2681581283 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
@@ -1004,6 +1004,10 @@ static void arm_smmu_write_cd_l1_desc(__le64 *dst,
 	WRITE_ONCE(*dst, cpu_to_le64(val));
 }
 
+/*
+ * Must not be used in case of nested mode where the CD table is owned
+ * by the guest
+ */
 static __le64 *arm_smmu_get_cd_ptr(struct arm_smmu_domain *smmu_domain,
 				   u32 ssid)
 {
@@ -2809,6 +2813,93 @@ static void arm_smmu_get_resv_regions(struct device *dev,
 	iommu_dma_get_resv_regions(dev, head);
 }
 
+static int arm_smmu_attach_pasid_table(struct iommu_domain *domain,
+				       struct iommu_pasid_table_config *cfg)
+{
+	struct arm_smmu_domain *smmu_domain = to_smmu_domain(domain);
+	struct arm_smmu_master *master;
+	struct arm_smmu_device *smmu;
+	unsigned long flags;
+	int ret = -EINVAL;
+
+	if (cfg->format != IOMMU_PASID_FORMAT_SMMUV3)
+		return -EINVAL;
+
+	if (cfg->version != PASID_TABLE_CFG_VERSION_1 ||
+	    cfg->vendor_data.smmuv3.version != PASID_TABLE_SMMUV3_CFG_VERSION_1)
+		return -EINVAL;
+
+	mutex_lock(&smmu_domain->init_mutex);
+
+	smmu = smmu_domain->smmu;
+
+	if (!smmu)
+		goto out;
+
+	if (smmu_domain->stage != ARM_SMMU_DOMAIN_NESTED)
+		goto out;
+
+	switch (cfg->config) {
+	case IOMMU_PASID_CONFIG_ABORT:
+		smmu_domain->s1_cfg.set = false;
+		smmu_domain->abort = true;
+		break;
+	case IOMMU_PASID_CONFIG_BYPASS:
+		smmu_domain->s1_cfg.set = false;
+		smmu_domain->abort = false;
+		break;
+	case IOMMU_PASID_CONFIG_TRANSLATE:
+		/* we do not support S1 <-> S1 transitions */
+		if (smmu_domain->s1_cfg.set)
+			goto out;
+
+		/*
+		 * we currently support a single CD so s1fmt and s1dss
+		 * fields are also ignored
+		 */
+		if (cfg->pasid_bits)
+			goto out;
+
+		smmu_domain->s1_cfg.cdcfg.cdtab_dma = cfg->base_ptr;
+		smmu_domain->s1_cfg.set = true;
+		smmu_domain->abort = false;
+		break;
+	default:
+		goto out;
+	}
+	spin_lock_irqsave(&smmu_domain->devices_lock, flags);
+	list_for_each_entry(master, &smmu_domain->devices, domain_head)
+		arm_smmu_install_ste_for_dev(master);
+	spin_unlock_irqrestore(&smmu_domain->devices_lock, flags);
+	ret = 0;
+out:
+	mutex_unlock(&smmu_domain->init_mutex);
+	return ret;
+}
+
+static void arm_smmu_detach_pasid_table(struct iommu_domain *domain)
+{
+	struct arm_smmu_domain *smmu_domain = to_smmu_domain(domain);
+	struct arm_smmu_master *master;
+	unsigned long flags;
+
+	mutex_lock(&smmu_domain->init_mutex);
+
+	if (smmu_domain->stage != ARM_SMMU_DOMAIN_NESTED)
+		goto unlock;
+
+	smmu_domain->s1_cfg.set = false;
+	smmu_domain->abort = false;
+
+	spin_lock_irqsave(&smmu_domain->devices_lock, flags);
+	list_for_each_entry(master, &smmu_domain->devices, domain_head)
+		arm_smmu_install_ste_for_dev(master);
+	spin_unlock_irqrestore(&smmu_domain->devices_lock, flags);
+
+unlock:
+	mutex_unlock(&smmu_domain->init_mutex);
+}
+
 static bool arm_smmu_dev_has_feature(struct device *dev,
 				     enum iommu_dev_features feat)
 {
@@ -2906,6 +2997,8 @@ static struct iommu_ops arm_smmu_ops = {
 	.of_xlate		= arm_smmu_of_xlate,
 	.get_resv_regions	= arm_smmu_get_resv_regions,
 	.put_resv_regions	= generic_iommu_put_resv_regions,
+	.attach_pasid_table	= arm_smmu_attach_pasid_table,
+	.detach_pasid_table	= arm_smmu_detach_pasid_table,
 	.dev_has_feat		= arm_smmu_dev_has_feature,
 	.dev_feat_enabled	= arm_smmu_dev_feature_enabled,
 	.dev_enable_feat	= arm_smmu_dev_enable_feature,
-- 
2.26.3

