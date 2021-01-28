Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 74A08307979
	for <lists+kvm@lfdr.de>; Thu, 28 Jan 2021 16:21:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231690AbhA1PTF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 28 Jan 2021 10:19:05 -0500
Received: from szxga06-in.huawei.com ([45.249.212.32]:11462 "EHLO
        szxga06-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231204AbhA1PSw (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 28 Jan 2021 10:18:52 -0500
Received: from DGGEMS413-HUB.china.huawei.com (unknown [172.30.72.59])
        by szxga06-in.huawei.com (SkyGuard) with ESMTP id 4DRPG93c68zjDPv;
        Thu, 28 Jan 2021 23:17:05 +0800 (CST)
Received: from DESKTOP-5IS4806.china.huawei.com (10.174.184.42) by
 DGGEMS413-HUB.china.huawei.com (10.3.19.213) with Microsoft SMTP Server id
 14.3.498.0; Thu, 28 Jan 2021 23:17:56 +0800
From:   Keqian Zhu <zhukeqian1@huawei.com>
To:     <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <kvm@vger.kernel.org>,
        <kvmarm@lists.cs.columbia.edu>, <iommu@lists.linux-foundation.org>,
        Will Deacon <will@kernel.org>,
        "Alex Williamson" <alex.williamson@redhat.com>,
        Marc Zyngier <maz@kernel.org>,
        Catalin Marinas <catalin.marinas@arm.com>
CC:     Kirti Wankhede <kwankhede@nvidia.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Mark Rutland <mark.rutland@arm.com>,
        James Morse <james.morse@arm.com>,
        "Robin Murphy" <robin.murphy@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        <wanghaibin.wang@huawei.com>, <jiangkunkun@huawei.com>,
        <yuzenghui@huawei.com>, <lushenming@huawei.com>
Subject: [RFC PATCH 03/11] iommu/arm-smmu-v3: Add feature detection for BBML
Date:   Thu, 28 Jan 2021 23:17:34 +0800
Message-ID: <20210128151742.18840-4-zhukeqian1@huawei.com>
X-Mailer: git-send-email 2.8.4.windows.1
In-Reply-To: <20210128151742.18840-1-zhukeqian1@huawei.com>
References: <20210128151742.18840-1-zhukeqian1@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.174.184.42]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: jiangkunkun <jiangkunkun@huawei.com>

When altering a translation table descriptor of some specific reasons,
we require break-before-make procedure. But it might cause problems when
the TTD is alive. The I/O streams might not tolerate translation faults.

If the SMMU supports BBML level 1 or BBML level 2, we can change the block
size without using break-before-make.

This adds feature detection for BBML, none functional change.

Co-developed-by: Keqian Zhu <zhukeqian1@huawei.com>
Signed-off-by: Kunkun Jiang <jiangkunkun@huawei.com>
---
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c | 24 ++++++++++++++++++++-
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h |  6 ++++++
 include/linux/io-pgtable.h                  |  1 +
 3 files changed, 30 insertions(+), 1 deletion(-)

diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
index 8cc9d7536b08..9208881a571c 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
@@ -1947,7 +1947,7 @@ static int arm_smmu_domain_finalise_s2(struct arm_smmu_domain *smmu_domain,
 static int arm_smmu_domain_finalise(struct iommu_domain *domain,
 				    struct arm_smmu_master *master)
 {
-	int ret;
+	int ret, bbml;
 	unsigned long ias, oas;
 	enum io_pgtable_fmt fmt;
 	struct io_pgtable_cfg pgtbl_cfg;
@@ -1988,12 +1988,20 @@ static int arm_smmu_domain_finalise(struct iommu_domain *domain,
 		return -EINVAL;
 	}
 
+	if (smmu->features & ARM_SMMU_FEAT_BBML2)
+		bbml = 2;
+	else if (smmu->features & ARM_SMMU_FEAT_BBML1)
+		bbml = 1;
+	else
+		bbml = 0;
+
 	pgtbl_cfg = (struct io_pgtable_cfg) {
 		.pgsize_bitmap	= smmu->pgsize_bitmap,
 		.ias		= ias,
 		.oas		= oas,
 		.httu_hd	= smmu->features & ARM_SMMU_FEAT_HTTU_HD,
 		.coherent_walk	= smmu->features & ARM_SMMU_FEAT_COHERENCY,
+		.bbml		= bbml,
 		.tlb		= &arm_smmu_flush_ops,
 		.iommu_dev	= smmu->dev,
 	};
@@ -3328,6 +3336,20 @@ static int arm_smmu_device_hw_probe(struct arm_smmu_device *smmu)
 
 	/* IDR3 */
 	reg = readl_relaxed(smmu->base + ARM_SMMU_IDR3);
+	switch (FIELD_GET(IDR3_BBML, reg)) {
+	case IDR3_BBML0:
+		break;
+	case IDR3_BBML1:
+		smmu->features |= ARM_SMMU_FEAT_BBML1;
+		break;
+	case IDR3_BBML2:
+		smmu->features |= ARM_SMMU_FEAT_BBML2;
+		break;
+	default:
+		dev_err(smmu->dev, "unknown/unsupported BBM behavior level\n");
+		return -ENXIO;
+	}
+
 	if (FIELD_GET(IDR3_RIL, reg))
 		smmu->features |= ARM_SMMU_FEAT_RANGE_INV;
 
diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
index e91bea44519e..11e526ab7239 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
@@ -55,6 +55,10 @@
 #define IDR1_SIDSIZE			GENMASK(5, 0)
 
 #define ARM_SMMU_IDR3			0xc
+#define IDR3_BBML			GENMASK(12, 11)
+#define IDR3_BBML0			0
+#define IDR3_BBML1			1
+#define IDR3_BBML2			2
 #define IDR3_RIL			(1 << 10)
 
 #define ARM_SMMU_IDR5			0x14
@@ -612,6 +616,8 @@ struct arm_smmu_device {
 #define ARM_SMMU_FEAT_SVA		(1 << 17)
 #define ARM_SMMU_FEAT_HTTU_HA		(1 << 18)
 #define ARM_SMMU_FEAT_HTTU_HD		(1 << 19)
+#define ARM_SMMU_FEAT_BBML1		(1 << 20)
+#define ARM_SMMU_FEAT_BBML2		(1 << 21)
 	u32				features;
 
 #define ARM_SMMU_OPT_SKIP_PREFETCH	(1 << 0)
diff --git a/include/linux/io-pgtable.h b/include/linux/io-pgtable.h
index 1a00ea8562c7..26583beeb5d9 100644
--- a/include/linux/io-pgtable.h
+++ b/include/linux/io-pgtable.h
@@ -99,6 +99,7 @@ struct io_pgtable_cfg {
 	unsigned int			oas;
 	bool				httu_hd;
 	bool				coherent_walk;
+	int				bbml;
 	const struct iommu_flush_ops	*tlb;
 	struct device			*iommu_dev;
 
-- 
2.19.1

