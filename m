Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 526D330797D
	for <lists+kvm@lfdr.de>; Thu, 28 Jan 2021 16:21:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231879AbhA1PTY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 28 Jan 2021 10:19:24 -0500
Received: from szxga06-in.huawei.com ([45.249.212.32]:11463 "EHLO
        szxga06-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231220AbhA1PSx (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 28 Jan 2021 10:18:53 -0500
Received: from DGGEMS413-HUB.china.huawei.com (unknown [172.30.72.59])
        by szxga06-in.huawei.com (SkyGuard) with ESMTP id 4DRPG938VYzjDJD;
        Thu, 28 Jan 2021 23:17:05 +0800 (CST)
Received: from DESKTOP-5IS4806.china.huawei.com (10.174.184.42) by
 DGGEMS413-HUB.china.huawei.com (10.3.19.213) with Microsoft SMTP Server id
 14.3.498.0; Thu, 28 Jan 2021 23:17:54 +0800
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
Subject: [RFC PATCH 01/11] iommu/arm-smmu-v3: Add feature detection for HTTU
Date:   Thu, 28 Jan 2021 23:17:32 +0800
Message-ID: <20210128151742.18840-2-zhukeqian1@huawei.com>
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

The SMMU which supports HTTU (Hardware Translation Table Update) can
update the access flag and the dirty state of TTD by hardware. It is
essential to track dirty pages of DMA.

This adds feature detection, none functional change.

Co-developed-by: Keqian Zhu <zhukeqian1@huawei.com>
Signed-off-by: Kunkun Jiang <jiangkunkun@huawei.com>
---
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c | 16 ++++++++++++++++
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h |  8 ++++++++
 include/linux/io-pgtable.h                  |  1 +
 3 files changed, 25 insertions(+)

diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
index 8ca7415d785d..0f0fe71cc10d 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
@@ -1987,6 +1987,7 @@ static int arm_smmu_domain_finalise(struct iommu_domain *domain,
 		.pgsize_bitmap	= smmu->pgsize_bitmap,
 		.ias		= ias,
 		.oas		= oas,
+		.httu_hd	= smmu->features & ARM_SMMU_FEAT_HTTU_HD,
 		.coherent_walk	= smmu->features & ARM_SMMU_FEAT_COHERENCY,
 		.tlb		= &arm_smmu_flush_ops,
 		.iommu_dev	= smmu->dev,
@@ -3224,6 +3225,21 @@ static int arm_smmu_device_hw_probe(struct arm_smmu_device *smmu)
 	if (reg & IDR0_HYP)
 		smmu->features |= ARM_SMMU_FEAT_HYP;
 
+	switch (FIELD_GET(IDR0_HTTU, reg)) {
+	case IDR0_HTTU_NONE:
+		break;
+	case IDR0_HTTU_HA:
+		smmu->features |= ARM_SMMU_FEAT_HTTU_HA;
+		break;
+	case IDR0_HTTU_HAD:
+		smmu->features |= ARM_SMMU_FEAT_HTTU_HA;
+		smmu->features |= ARM_SMMU_FEAT_HTTU_HD;
+		break;
+	default:
+		dev_err(smmu->dev, "unknown/unsupported HTTU!\n");
+		return -ENXIO;
+	}
+
 	/*
 	 * The coherency feature as set by FW is used in preference to the ID
 	 * register, but warn on mismatch.
diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
index 96c2e9565e00..e91bea44519e 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
@@ -33,6 +33,10 @@
 #define IDR0_ASID16			(1 << 12)
 #define IDR0_ATS			(1 << 10)
 #define IDR0_HYP			(1 << 9)
+#define IDR0_HTTU			GENMASK(7, 6)
+#define IDR0_HTTU_NONE			0
+#define IDR0_HTTU_HA			1
+#define IDR0_HTTU_HAD			2
 #define IDR0_COHACC			(1 << 4)
 #define IDR0_TTF			GENMASK(3, 2)
 #define IDR0_TTF_AARCH64		2
@@ -286,6 +290,8 @@
 #define CTXDESC_CD_0_TCR_TBI0		(1ULL << 38)
 
 #define CTXDESC_CD_0_AA64		(1UL << 41)
+#define CTXDESC_CD_0_HD			(1UL << 42)
+#define CTXDESC_CD_0_HA			(1UL << 43)
 #define CTXDESC_CD_0_S			(1UL << 44)
 #define CTXDESC_CD_0_R			(1UL << 45)
 #define CTXDESC_CD_0_A			(1UL << 46)
@@ -604,6 +610,8 @@ struct arm_smmu_device {
 #define ARM_SMMU_FEAT_RANGE_INV		(1 << 15)
 #define ARM_SMMU_FEAT_BTM		(1 << 16)
 #define ARM_SMMU_FEAT_SVA		(1 << 17)
+#define ARM_SMMU_FEAT_HTTU_HA		(1 << 18)
+#define ARM_SMMU_FEAT_HTTU_HD		(1 << 19)
 	u32				features;
 
 #define ARM_SMMU_OPT_SKIP_PREFETCH	(1 << 0)
diff --git a/include/linux/io-pgtable.h b/include/linux/io-pgtable.h
index ea727eb1a1a9..1a00ea8562c7 100644
--- a/include/linux/io-pgtable.h
+++ b/include/linux/io-pgtable.h
@@ -97,6 +97,7 @@ struct io_pgtable_cfg {
 	unsigned long			pgsize_bitmap;
 	unsigned int			ias;
 	unsigned int			oas;
+	bool				httu_hd;
 	bool				coherent_walk;
 	const struct iommu_flush_ops	*tlb;
 	struct device			*iommu_dev;
-- 
2.19.1

