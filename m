Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EE9B06FD45F
	for <lists+kvm@lfdr.de>; Wed, 10 May 2023 05:35:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235560AbjEJDfP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 9 May 2023 23:35:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39164 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235593AbjEJDeu (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 9 May 2023 23:34:50 -0400
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (mail-sn1nam02on2054.outbound.protection.outlook.com [40.107.96.54])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 69FCE5BB5;
        Tue,  9 May 2023 20:34:35 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=UK7gS24+JR7UiOLcZZgpVkQ4wGFhtCrjIphfknhu3bxsxjDxIvwHmNBOYlMHFhRT7Y4uA+L+ByCRtZpfyUNhlBHCv768d6yW1Vpej2fmmUkRuhTGHZo126eUvsMQNetxhBmo/yQiSbqL2EMrFNAykadEcym360tbsl9kYxCzcRnpkZfANkgA38jAT9HS0PstSy0R3WoxOCryOiEvUnFuC7HHH9zzTtxGzcUmkq3xiR3qlsGJHfmKmoNJtv4dI+gd3nP8zwDCQy5OyKbsbTZzq1g5hQYCO+C3gc5IgrGmLnCoiyTE8SnbYusruNPCc8OczcUxKFIA56ainsrIsfIaTA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=yJebtEKrtrvbLCiBOy7gpOUhYpCLuJx46uKWTr4rd0w=;
 b=LZpwr3UJfHIGx+w+3WJqSnUuxju9BDpFwHRQoNvkfuMXrt1fY3sA/WK6a5APPTRaZKObU9e4c0Neb7yt/mtS8p0xHgsFeR3zVCLw/ZOTeQ3GT2ht1bLHVg13BvRxx8vY9f7mJ9cTBuGsvkgNm5D0EAM5BUSsoNX293C54bfuQMrtnPfvBIJbgtKNOY2evpqC/0T1qhMRIWOUEQUIS4Uhs7iePDdCW7Rw8kCAuoerZnxKmQnc+J/QFuhdxcyV7L8ljAZmXl/TcAPFzOLQ5aYer8eQB04QAcB4MyyzO0uzbquYJ7WERWP2Cpw2Bl1ukn3g+bMZKydykNt/anv0o7tmIw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=arm.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=yJebtEKrtrvbLCiBOy7gpOUhYpCLuJx46uKWTr4rd0w=;
 b=Lc5l/fR04Xb/f2jenYtbrCR1qLipx0THIdj7T4S5A4BzNB8mdP/d+NwZjB7NzZijnvV7PwA30sjGT2yxBgzoUok3QExcl9xndMm6SMHr9wS2aRrVlQlO+eUyxi795F8vqgYDCQQO4B6IRfypTOcoCQ7a1QG5v71+MPjeor4S/PieLNcwOgqFXcqd95zdG0Rk8t90OQloK++8Zc1dYbFISp9RFygdy7wkkRbS5CuJrk1qzQuaYLUNFRPonBCW9YpwSN1jNUr61nF/9DMkKK3n7nftPEi2Y9Ky2WCZVm3lNrI+8uUcq3EtujTI8g0oueewNb5wtyVqRlE4tdGY6xC7OQ==
Received: from BN9P220CA0026.NAMP220.PROD.OUTLOOK.COM (2603:10b6:408:13e::31)
 by SJ2PR12MB8926.namprd12.prod.outlook.com (2603:10b6:a03:53b::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6363.32; Wed, 10 May
 2023 03:34:30 +0000
Received: from BL02EPF000145B8.namprd05.prod.outlook.com
 (2603:10b6:408:13e:cafe::32) by BN9P220CA0026.outlook.office365.com
 (2603:10b6:408:13e::31) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6387.18 via Frontend
 Transport; Wed, 10 May 2023 03:34:29 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.160)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 BL02EPF000145B8.mail.protection.outlook.com (10.167.241.208) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6387.19 via Frontend Transport; Wed, 10 May 2023 03:34:29 +0000
Received: from rnnvmail204.nvidia.com (10.129.68.6) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.5; Tue, 9 May 2023
 20:34:15 -0700
Received: from rnnvmail204.nvidia.com (10.129.68.6) by rnnvmail204.nvidia.com
 (10.129.68.6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.37; Tue, 9 May 2023
 20:34:14 -0700
Received: from Asurada-Nvidia.nvidia.com (10.127.8.10) by mail.nvidia.com
 (10.129.68.6) with Microsoft SMTP Server id 15.2.986.37 via Frontend
 Transport; Tue, 9 May 2023 20:34:13 -0700
From:   Nicolin Chen <nicolinc@nvidia.com>
To:     <jgg@nvidia.com>, <robin.murphy@arm.com>, <will@kernel.org>
CC:     <eric.auger@redhat.com>, <kevin.tian@intel.com>,
        <baolu.lu@linux.intel.com>, <joro@8bytes.org>,
        <shameerali.kolothum.thodi@huawei.com>, <jean-philippe@linaro.org>,
        <linux-arm-kernel@lists.infradead.org>, <iommu@lists.linux.dev>,
        <linux-kernel@vger.kernel.org>, <kvm@vger.kernel.org>,
        <alex.williamson@redhat.com>, <yi.l.liu@intel.com>
Subject: [PATCH v2 05/17] iommu/arm-smmu-v3: Add arm_smmu_hw_info
Date:   Tue, 9 May 2023 20:33:25 -0700
Message-ID: <07c9c019eb6cc9226d0117373dcfe0daf8436fee.1683688960.git.nicolinc@nvidia.com>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <cover.1683688960.git.nicolinc@nvidia.com>
References: <cover.1683688960.git.nicolinc@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL02EPF000145B8:EE_|SJ2PR12MB8926:EE_
X-MS-Office365-Filtering-Correlation-Id: 6e4e6883-18b7-4fb7-52e3-08db51077686
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: CfOwJiVZitsY2TPfj5ClKtX1U8UjXlX3cka5i7mi2Kt02/9H1Eg52FEgPg8WmBlltwuuT/9IcNaEttIaNcGsM5N6ha27Iqb1f+hRQdfIBEHdZ4QOnGbrsHYNa8SsdmTx2GDzcaSde1t7krXkELzakrjzYOwAXkcpspajo7eKZFfDAfqgB+3nJM5ahQuRSyOqDkD8b2kh3SUzexiYtcCkGfAO3aiaStKRQQtzMusjgzHlKBdCjuZXkDvy7WVvb8fCNtMwwXf+uoDtD7yuioUtERQ6E198lCBOxS6KQJQUcuXYSpZV/DWIZ2kBbhbstzHYNaO99lPou2UQQjFr46vB0j0gC/0Hm8Tv++txyN2KGMJJHDryMS4ZOGd4SplR9DUAFrV1PiVPfkwSLUU54NfFvuZzYjCQYObjjYPud+hEemCUX9oa/02PaQYGR4mGxqMdVRVe5WRrf09pHs6gWr/O7lPOG8OBxZt7k/YXFcphtC10PHSVYTJhH5P+6DyWb6wZscgXI19/yJeC2NDcEpgDouzq8Wj5/pSfXLRPk+VMLdI729YRPuEogTe50WwB11bU9AdLlFAzHdlCm8Z54rcjTN/bMMsI2iyRrwoGoJt4OcEU5oSFG2b4/AvYmLK0pbACqTftMi8t43RZlfZnGGGMbd63X9SXyOhAxlgF5bmnFyDnFWO4ysHEVesS5LzORKRasN3vmmDynj4n7wajtkc0fQ==
X-Forefront-Antispam-Report: CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230028)(4636009)(396003)(346002)(39860400002)(136003)(376002)(451199021)(36840700001)(40470700004)(46966006)(47076005)(36860700001)(26005)(186003)(478600001)(426003)(336012)(2616005)(40460700003)(7696005)(6666004)(8936002)(5660300002)(8676002)(86362001)(82310400005)(316002)(41300700001)(356005)(7636003)(40480700001)(70206006)(70586007)(36756003)(2906002)(82740400003)(110136005)(7416002)(54906003)(4326008);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 May 2023 03:34:29.6161
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 6e4e6883-18b7-4fb7-52e3-08db51077686
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BL02EPF000145B8.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ2PR12MB8926
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This is used to forward the host IDR values to the user space, so the
hypervisor and the guest VM can learn about the underlying hardware's
capabilities.

Also, set the ops->hw_info_type and ops->hwpt_type_bitmap accordingly.

Signed-off-by: Nicolin Chen <nicolinc@nvidia.com>
---
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c | 26 +++++++++++++++++++++
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h |  2 ++
 include/uapi/linux/iommufd.h                | 14 +++++++++++
 3 files changed, 42 insertions(+)

diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
index 2c53849cae30..89daf50be87b 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
@@ -2014,6 +2014,29 @@ static bool arm_smmu_capable(struct device *dev, enum iommu_cap cap)
 	}
 }
 
+static void *arm_smmu_hw_info(struct device *dev, u32 *length)
+{
+	struct arm_smmu_master *master = dev_iommu_priv_get(dev);
+	struct iommu_hw_info_smmuv3 *info;
+	void *base_idr;
+	int i;
+
+	if (!master || !master->smmu)
+		return ERR_PTR(-ENODEV);
+
+	info = kzalloc(sizeof(*info), GFP_KERNEL);
+	if (!info)
+		return ERR_PTR(-ENOMEM);
+
+	base_idr = master->smmu->base + ARM_SMMU_IDR0;
+	for (i = 0; i <= 5; i++)
+		info->idr[i] = readl_relaxed(base_idr + 0x4 * i);
+
+	*length = sizeof(*info);
+
+	return info;
+}
+
 static struct iommu_domain *arm_smmu_domain_alloc(unsigned type)
 {
 	struct arm_smmu_domain *smmu_domain;
@@ -2846,6 +2869,7 @@ static void arm_smmu_remove_dev_pasid(struct device *dev, ioasid_t pasid)
 
 static struct iommu_ops arm_smmu_ops = {
 	.capable		= arm_smmu_capable,
+	.hw_info		= arm_smmu_hw_info,
 	.domain_alloc		= arm_smmu_domain_alloc,
 	.probe_device		= arm_smmu_probe_device,
 	.release_device		= arm_smmu_release_device,
@@ -2857,6 +2881,8 @@ static struct iommu_ops arm_smmu_ops = {
 	.dev_disable_feat	= arm_smmu_dev_disable_feature,
 	.page_response		= arm_smmu_page_response,
 	.def_domain_type	= arm_smmu_def_domain_type,
+	.hw_info_type		= IOMMU_HW_INFO_TYPE_ARM_SMMUV3,
+	.hwpt_type_bitmap	= BIT_ULL(IOMMU_HWPT_TYPE_ARM_SMMUV3),
 	.pgsize_bitmap		= -1UL, /* Restricted during device attach */
 	.owner			= THIS_MODULE,
 	.default_domain_ops = &(const struct iommu_domain_ops) {
diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
index b574c58a3487..5fa010c6fe20 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
@@ -14,6 +14,8 @@
 #include <linux/mmzone.h>
 #include <linux/sizes.h>
 
+#include <uapi/linux/iommufd.h>
+
 /* MMIO registers */
 #define ARM_SMMU_IDR0			0x0
 #define IDR0_ST_LVL			GENMASK(28, 27)
diff --git a/include/uapi/linux/iommufd.h b/include/uapi/linux/iommufd.h
index 6845ce6e1e76..b1fe4c59ab82 100644
--- a/include/uapi/linux/iommufd.h
+++ b/include/uapi/linux/iommufd.h
@@ -534,6 +534,20 @@ struct iommu_hw_info_vtd {
 	__aligned_u64 ecap_reg;
 };
 
+/**
+ * struct iommu_hw_info_smmuv3 - ARM SMMUv3 device info
+ *
+ * @flags: Must be set to 0
+ * @__reserved: Must be 0
+ * @idr: Implemented features for the SMMU Non-secure programming interface.
+ *       Please refer to the chapters from 6.3.1 to 6.3.6 in the SMMUv3 Spec.
+ */
+struct iommu_hw_info_smmuv3 {
+	__u32 flags;
+	__u32 __reserved;
+	__u32 idr[6];
+};
+
 /**
  * struct iommu_hw_info - ioctl(IOMMU_DEVICE_GET_HW_INFO)
  * @size: sizeof(struct iommu_hw_info)
-- 
2.40.1

