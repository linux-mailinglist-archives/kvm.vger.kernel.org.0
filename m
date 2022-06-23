Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 902265589B8
	for <lists+kvm@lfdr.de>; Thu, 23 Jun 2022 22:01:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229554AbiFWUBr (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 23 Jun 2022 16:01:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60226 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230204AbiFWUBn (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 23 Jun 2022 16:01:43 -0400
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (mail-sn1anam02on2064.outbound.protection.outlook.com [40.107.96.64])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E201C3969B;
        Thu, 23 Jun 2022 13:01:38 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=WU23p7FnamMhP+cZHe0e3YTlIJZl9LDBIeo2iN7iuFOv748N8uk39W4Ad2yuDYWNzNtzKiu5Xq5ZrvVK00rld1xy+ntDUTxNxYWBqDg6nLg2acyxkM3J306N/RZxrBL+7Wp081mwbQCrwdVoVongAz7XghYcVZ0OizoUhDm5BuJ7vS5tWB9AeX7mi0QKsFdCYbs0ab0qQwGZ9S0mgkhlO5dQEOy88TfwjzBcVAEowty2WYWWbZe9pqYBLoWo0GTUGx8ivOZQm44dkLi/blU2AGcYKa9JFRsmCeHr1Onhs8vFSmP6Nhcv6amDzVMlgq2CeRULDJLivuu1suaE4HdZrw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=W1+1KQnxBFEB/SzR59OiFF1wSnYuPbtifHaTOkG7BzM=;
 b=nAB75WhXnlm1ILoBDlpZcynDctGsJRgg67FYYQXlV8raJmfOmLm7mm7X+Snl93KwycXgmGmlPhUUepTy8EiHW8RcmvZshiIZ3jizgt4skFnHHdYzCfDVm0HDuht51YhFSbLpOrmx4wefMujuXu6mdhvABtYZSPwfR4e+33rBsngitZre/UMm4KdU2+2ACChe1ZgRkRtKjfNjxy/JRoSDMcQbBLEZGcZp7xBBtxX4GLEr3J3TDCF5RO9D4Ults/f+NKJi54S3j2fu+052DJ3S1A5bBuoVZo24XMqVb2J+lrmr3aMMbnXAF8cGcRtEd1x8qdzRFUTXjf/xHHKukzU/5w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.234) smtp.rcpttodomain=linux.intel.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=W1+1KQnxBFEB/SzR59OiFF1wSnYuPbtifHaTOkG7BzM=;
 b=CBlhzdc3L0lhcjW0JcMDwtL4IDVYYRq0wbIhgkGbzh65g3l1pFnYnynXy9zsWsm2e4toD5cUL0KBhvHnZKFA3Hef5FySKwxf55kmBDDkkNqaNdnjtOwLwHTz8yMcUIZ7kR0ChLCRpR/K7EOhLMHe82Sa+ChWK1omvxuYaQ2zIt54LtIyx+U7XeS15Az548rca9nSZ0niudWn/SgbX+QATOKc/PPqlMCoQYih2VVGJaMDwXGMpjJfEXcJpgYcp7vKekcAPW34E6VmIh4w7Z9OVejOGHPAYVg3FN7koazNP2IhMy72+Z/gaEzQBqvISHtceG7yrp9nUYDiLBFJUYmGQw==
Received: from DS7PR03CA0319.namprd03.prod.outlook.com (2603:10b6:8:2b::27) by
 CH0PR12MB5123.namprd12.prod.outlook.com (2603:10b6:610:be::12) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5373.15; Thu, 23 Jun 2022 20:01:34 +0000
Received: from DM6NAM11FT025.eop-nam11.prod.protection.outlook.com
 (2603:10b6:8:2b:cafe::99) by DS7PR03CA0319.outlook.office365.com
 (2603:10b6:8:2b::27) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5373.16 via Frontend
 Transport; Thu, 23 Jun 2022 20:01:34 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.234)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.234 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.234; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (12.22.5.234) by
 DM6NAM11FT025.mail.protection.outlook.com (10.13.172.197) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.5373.15 via Frontend Transport; Thu, 23 Jun 2022 20:01:34 +0000
Received: from rnnvmail203.nvidia.com (10.129.68.9) by DRHQMAIL101.nvidia.com
 (10.27.9.10) with Microsoft SMTP Server (TLS) id 15.0.1497.32; Thu, 23 Jun
 2022 20:01:33 +0000
Received: from rnnvmail204.nvidia.com (10.129.68.6) by rnnvmail203.nvidia.com
 (10.129.68.9) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.26; Thu, 23 Jun
 2022 13:01:32 -0700
Received: from Asurada-Nvidia.nvidia.com (10.127.8.10) by mail.nvidia.com
 (10.129.68.6) with Microsoft SMTP Server id 15.2.986.26 via Frontend
 Transport; Thu, 23 Jun 2022 13:01:30 -0700
From:   Nicolin Chen <nicolinc@nvidia.com>
To:     <joro@8bytes.org>, <will@kernel.org>, <marcan@marcan.st>,
        <sven@svenpeter.dev>, <robin.murphy@arm.com>,
        <robdclark@gmail.com>, <baolu.lu@linux.intel.com>,
        <matthias.bgg@gmail.com>, <orsonzhai@gmail.com>,
        <baolin.wang7@gmail.com>, <zhang.lyra@gmail.com>,
        <jean-philippe@linaro.org>, <alex.williamson@redhat.com>,
        <jgg@nvidia.com>, <kevin.tian@intel.com>
CC:     <suravee.suthikulpanit@amd.com>, <alyssa@rosenzweig.io>,
        <dwmw2@infradead.org>, <yong.wu@mediatek.com>,
        <mjrosato@linux.ibm.com>, <gerald.schaefer@linux.ibm.com>,
        <thierry.reding@gmail.com>, <vdumpa@nvidia.com>,
        <jonathanh@nvidia.com>, <cohuck@redhat.com>,
        <thunder.leizhen@huawei.com>, <tglx@linutronix.de>,
        <chenxiang66@hisilicon.com>, <christophe.jaillet@wanadoo.fr>,
        <john.garry@huawei.com>, <yangyingliang@huawei.com>,
        <jordan@cosmicpenguin.net>, <iommu@lists.linux-foundation.org>,
        <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-arm-msm@vger.kernel.org>,
        <linux-mediatek@lists.infradead.org>, <linux-s390@vger.kernel.org>,
        <linux-tegra@vger.kernel.org>,
        <virtualization@lists.linux-foundation.org>, <kvm@vger.kernel.org>
Subject: [PATCH v3 1/5] iommu: Return -EMEDIUMTYPE for incompatible domain and device/group
Date:   Thu, 23 Jun 2022 13:00:25 -0700
Message-ID: <20220623200029.26007-2-nicolinc@nvidia.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20220623200029.26007-1-nicolinc@nvidia.com>
References: <20220623200029.26007-1-nicolinc@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 95bcdada-814f-4b20-0cfd-08da55532ca1
X-MS-TrafficTypeDiagnostic: CH0PR12MB5123:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?G9IgKU9rbo8WwoOhnrTZzFq3LGw3K6XQ6HGoFY0WebknY5dagO8EqJw6TEkP?=
 =?us-ascii?Q?UxmByxtHZ73LEHt1k2QCWU9No2NqliNIkXVTaE1QUueRK+UEivrY5qNamAAs?=
 =?us-ascii?Q?e8FqsUuJmZXeaOu+a3H4xaY1BtunEcWO72pXB66AhG+4+CpV3w8E1PiJjnnV?=
 =?us-ascii?Q?dCtnJnqdoxGdxCzejSNMZr2BDA7DxC/tlj+IQyazCm++/RkIozeClNX5jCBT?=
 =?us-ascii?Q?TFXdgZXq4rRWuQFsO3UJhv8/fp4sBsGDnoLiDI7c5AzpMkQLKZTmRxBS8I68?=
 =?us-ascii?Q?yb/D0qiDlmxLJIr07Yh0lzLp8TCDEDUHb8ZK6W177UqWXuhkSWe/iDn7rQ+C?=
 =?us-ascii?Q?6a9aGrswku2iqrg/8O1aS4bANQoRwe3d5j9wtOZaI2QdDqRu0j6tJrvjQAzZ?=
 =?us-ascii?Q?dgpS5oPDa4PWkQjUROk2NBoMfSi/kwF/RmEmIouJAIAMednBrvjbbvQy3e5C?=
 =?us-ascii?Q?uOQ7KSV8BZuX8bH09I/sSC2ZyzeEseJROOoiHDbsXjTjpi+H7ep5PSECGf/6?=
 =?us-ascii?Q?XA0Xj4chPN/SYxqfccRfFUCjWSQD8CXl9MPLH0pC6wXe/UPIHQ0Ko/mfW9ZT?=
 =?us-ascii?Q?BlAF8C5iFIXtVqmBbkrvCbPMuJ8GcC+47iKTdFX3yJEA0NKOlMjAO2tCEgDI?=
 =?us-ascii?Q?yi0u3YgwHAYgb/KZz6fsESwYWJGJX08hpdTbF5TuK/cHuCE7onBoP91EUiu/?=
 =?us-ascii?Q?G8EWUBFwv1dEyFQLLnUCPrCqxGYIxJ19iJY7j9mHE7KkqRsC9v1xpIg/ubBl?=
 =?us-ascii?Q?ao7XJ72mF/8O3zKKQNYGJ0YtyvXw3dtlhjwh8UykXcWsC/pv5tFK2rCWIXaG?=
 =?us-ascii?Q?0ietjFrezsusCfQJOWqF7ffjUK8l4enTdgvrXYPFYArV07u358JPfFSy7iiR?=
 =?us-ascii?Q?dFlfIVzVM8rgV2XuNasPlz4LrlzrehFjx496QfA93UYH2cdzoA2dwV/a4FQj?=
 =?us-ascii?Q?9UbBSNgPBK9YuYiL7lTsOA=3D=3D?=
X-Forefront-Antispam-Report: CIP:12.22.5.234;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(13230016)(4636009)(136003)(346002)(396003)(376002)(39860400002)(46966006)(40470700004)(36840700001)(356005)(921005)(478600001)(41300700001)(6666004)(26005)(30864003)(36860700001)(40480700001)(70586007)(8936002)(82310400005)(83380400001)(82740400003)(2906002)(81166007)(7416002)(7406005)(7696005)(5660300002)(186003)(2616005)(47076005)(426003)(110136005)(8676002)(336012)(1076003)(40460700003)(54906003)(36756003)(4326008)(316002)(86362001)(70206006)(334744004)(36900700001)(2101003)(83996005)(473944003);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Jun 2022 20:01:34.4182
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 95bcdada-814f-4b20-0cfd-08da55532ca1
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.234];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT025.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR12MB5123
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Cases like VFIO wish to attach a device to an existing domain that was
not allocated specifically from the device. This raises a condition
where the IOMMU driver can fail the domain attach because the domain and
device are incompatible with each other.

This is a soft failure that can be resolved by using a different domain.

Provide a dedicated errno from the IOMMU driver during attach that the
reason attached failed is because of domain incompatability. EMEDIUMTYPE
is chosen because it is never used within the iommu subsystem today and
evokes a sense that the 'medium' aka the domain is incompatible.

VFIO can use this to know attach is a soft failure and it should continue
searching. Otherwise the attach will be a hard failure and VFIO will
return the code to userspace.

Update all drivers to return EMEDIUMTYPE in their failure paths that are
related to domain incompatability. Also remove adjacent error prints for
these soft failures, to prevent a kernel log spam, since -EMEDIUMTYPE is
clear enough to indicate an incompatability error.

Add kdocs describing this behavior.

Suggested-by: Jason Gunthorpe <jgg@nvidia.com>
Reviewed-by: Kevin Tian <kevin.tian@intel.com>
Signed-off-by: Nicolin Chen <nicolinc@nvidia.com>
---
 drivers/iommu/amd/iommu.c                   |  2 +-
 drivers/iommu/apple-dart.c                  |  4 +--
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c | 15 +++--------
 drivers/iommu/arm/arm-smmu/arm-smmu.c       |  6 ++---
 drivers/iommu/arm/arm-smmu/qcom_iommu.c     |  9 ++-----
 drivers/iommu/intel/iommu.c                 | 10 +++-----
 drivers/iommu/iommu.c                       | 28 +++++++++++++++++++++
 drivers/iommu/ipmmu-vmsa.c                  |  4 +--
 drivers/iommu/mtk_iommu_v1.c                |  2 +-
 drivers/iommu/omap-iommu.c                  |  3 +--
 drivers/iommu/s390-iommu.c                  |  2 +-
 drivers/iommu/sprd-iommu.c                  |  6 ++---
 drivers/iommu/tegra-gart.c                  |  2 +-
 drivers/iommu/virtio-iommu.c                |  3 +--
 14 files changed, 49 insertions(+), 47 deletions(-)

diff --git a/drivers/iommu/amd/iommu.c b/drivers/iommu/amd/iommu.c
index 840831d5d2ad..ad499658a6b6 100644
--- a/drivers/iommu/amd/iommu.c
+++ b/drivers/iommu/amd/iommu.c
@@ -1662,7 +1662,7 @@ static int attach_device(struct device *dev,
 	if (domain->flags & PD_IOMMUV2_MASK) {
 		struct iommu_domain *def_domain = iommu_get_dma_domain(dev);
 
-		ret = -EINVAL;
+		ret = -EMEDIUMTYPE;
 		if (def_domain->type != IOMMU_DOMAIN_IDENTITY)
 			goto out;
 
diff --git a/drivers/iommu/apple-dart.c b/drivers/iommu/apple-dart.c
index 8af0242a90d9..e58dc310afd7 100644
--- a/drivers/iommu/apple-dart.c
+++ b/drivers/iommu/apple-dart.c
@@ -495,10 +495,10 @@ static int apple_dart_attach_dev(struct iommu_domain *domain,
 
 	if (cfg->stream_maps[0].dart->force_bypass &&
 	    domain->type != IOMMU_DOMAIN_IDENTITY)
-		return -EINVAL;
+		return -EMEDIUMTYPE;
 	if (!cfg->stream_maps[0].dart->supports_bypass &&
 	    domain->type == IOMMU_DOMAIN_IDENTITY)
-		return -EINVAL;
+		return -EMEDIUMTYPE;
 
 	ret = apple_dart_finalize_domain(domain, cfg);
 	if (ret)
diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
index 88817a3376ef..5b64138f549d 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
@@ -2420,24 +2420,15 @@ static int arm_smmu_attach_dev(struct iommu_domain *domain, struct device *dev)
 			goto out_unlock;
 		}
 	} else if (smmu_domain->smmu != smmu) {
-		dev_err(dev,
-			"cannot attach to SMMU %s (upstream of %s)\n",
-			dev_name(smmu_domain->smmu->dev),
-			dev_name(smmu->dev));
-		ret = -ENXIO;
+		ret = -EMEDIUMTYPE;
 		goto out_unlock;
 	} else if (smmu_domain->stage == ARM_SMMU_DOMAIN_S1 &&
 		   master->ssid_bits != smmu_domain->s1_cfg.s1cdmax) {
-		dev_err(dev,
-			"cannot attach to incompatible domain (%u SSID bits != %u)\n",
-			smmu_domain->s1_cfg.s1cdmax, master->ssid_bits);
-		ret = -EINVAL;
+		ret = -EMEDIUMTYPE;
 		goto out_unlock;
 	} else if (smmu_domain->stage == ARM_SMMU_DOMAIN_S1 &&
 		   smmu_domain->stall_enabled != master->stall_enabled) {
-		dev_err(dev, "cannot attach to stall-%s domain\n",
-			smmu_domain->stall_enabled ? "enabled" : "disabled");
-		ret = -EINVAL;
+		ret = -EMEDIUMTYPE;
 		goto out_unlock;
 	}
 
diff --git a/drivers/iommu/arm/arm-smmu/arm-smmu.c b/drivers/iommu/arm/arm-smmu/arm-smmu.c
index 2ed3594f384e..072cac5ab5a4 100644
--- a/drivers/iommu/arm/arm-smmu/arm-smmu.c
+++ b/drivers/iommu/arm/arm-smmu/arm-smmu.c
@@ -1135,10 +1135,8 @@ static int arm_smmu_attach_dev(struct iommu_domain *domain, struct device *dev)
 	struct arm_smmu_device *smmu;
 	int ret;
 
-	if (!fwspec || fwspec->ops != &arm_smmu_ops) {
-		dev_err(dev, "cannot attach to SMMU, is it on the same bus?\n");
-		return -ENXIO;
-	}
+	if (!fwspec || fwspec->ops != &arm_smmu_ops)
+		return -EMEDIUMTYPE;
 
 	/*
 	 * FIXME: The arch/arm DMA API code tries to attach devices to its own
diff --git a/drivers/iommu/arm/arm-smmu/qcom_iommu.c b/drivers/iommu/arm/arm-smmu/qcom_iommu.c
index 4c077c38fbd6..8372f985c14a 100644
--- a/drivers/iommu/arm/arm-smmu/qcom_iommu.c
+++ b/drivers/iommu/arm/arm-smmu/qcom_iommu.c
@@ -381,13 +381,8 @@ static int qcom_iommu_attach_dev(struct iommu_domain *domain, struct device *dev
 	 * Sanity check the domain. We don't support domains across
 	 * different IOMMUs.
 	 */
-	if (qcom_domain->iommu != qcom_iommu) {
-		dev_err(dev, "cannot attach to IOMMU %s while already "
-			"attached to domain on IOMMU %s\n",
-			dev_name(qcom_domain->iommu->dev),
-			dev_name(qcom_iommu->dev));
-		return -EINVAL;
-	}
+	if (qcom_domain->iommu != qcom_iommu)
+		return -EMEDIUMTYPE;
 
 	return 0;
 }
diff --git a/drivers/iommu/intel/iommu.c b/drivers/iommu/intel/iommu.c
index 44016594831d..db5fb799e350 100644
--- a/drivers/iommu/intel/iommu.c
+++ b/drivers/iommu/intel/iommu.c
@@ -4323,19 +4323,15 @@ static int prepare_domain_attach_device(struct iommu_domain *domain,
 		return -ENODEV;
 
 	if (dmar_domain->force_snooping && !ecap_sc_support(iommu->ecap))
-		return -EOPNOTSUPP;
+		return -EMEDIUMTYPE;
 
 	/* check if this iommu agaw is sufficient for max mapped address */
 	addr_width = agaw_to_width(iommu->agaw);
 	if (addr_width > cap_mgaw(iommu->cap))
 		addr_width = cap_mgaw(iommu->cap);
 
-	if (dmar_domain->max_addr > (1LL << addr_width)) {
-		dev_err(dev, "%s: iommu width (%d) is not "
-		        "sufficient for the mapped address (%llx)\n",
-		        __func__, addr_width, dmar_domain->max_addr);
-		return -EFAULT;
-	}
+	if (dmar_domain->max_addr > (1LL << addr_width))
+		return -EMEDIUMTYPE;
 	dmar_domain->gaw = addr_width;
 
 	/*
diff --git a/drivers/iommu/iommu.c b/drivers/iommu/iommu.c
index 847ad47a2dfd..5b0afe39275e 100644
--- a/drivers/iommu/iommu.c
+++ b/drivers/iommu/iommu.c
@@ -1972,6 +1972,20 @@ static int __iommu_attach_device(struct iommu_domain *domain,
 	return ret;
 }
 
+/**
+ * iommu_attach_device - Attach a device to an IOMMU domain
+ * @domain: IOMMU domain to attach
+ * @dev: Device that will be attached
+ *
+ * Returns 0 on success and error code on failure
+ *
+ * Specifically, -EMEDIUMTYPE is returned as a soft failure if the domain and
+ * the device are incompatible in some way. This indicates that a caller should
+ * try another existing IOMMU domain or allocate a new one. And note that it's
+ * recommended to keep kernel print free when reporting -EMEDIUMTYPE error, as
+ * this function can be called to test compatibility with domains that will fail
+ * the test, which will result in a kernel log spam.
+ */
 int iommu_attach_device(struct iommu_domain *domain, struct device *dev)
 {
 	struct iommu_group *group;
@@ -2098,6 +2112,20 @@ static int __iommu_attach_group(struct iommu_domain *domain,
 	return ret;
 }
 
+/**
+ * iommu_attach_group - Attach an IOMMU group to an IOMMU domain
+ * @domain: IOMMU domain to attach
+ * @group: IOMMU group that will be attached
+ *
+ * Returns 0 on success and error code on failure
+ *
+ * Specifically, -EMEDIUMTYPE is returned as a soft failure if the domain and
+ * the device are incompatible in some way. This indicates that a caller should
+ * try another existing IOMMU domain or allocate a new one. And note that it's
+ * recommended to keep kernel print free when reporting -EMEDIUMTYPE error, as
+ * this function can be called to test compatibility with domains that will fail
+ * the test, which will result in a kernel log spam.
+ */
 int iommu_attach_group(struct iommu_domain *domain, struct iommu_group *group)
 {
 	int ret;
diff --git a/drivers/iommu/ipmmu-vmsa.c b/drivers/iommu/ipmmu-vmsa.c
index 8fdb84b3642b..82d63394b166 100644
--- a/drivers/iommu/ipmmu-vmsa.c
+++ b/drivers/iommu/ipmmu-vmsa.c
@@ -628,9 +628,7 @@ static int ipmmu_attach_device(struct iommu_domain *io_domain,
 		 * Something is wrong, we can't attach two devices using
 		 * different IOMMUs to the same domain.
 		 */
-		dev_err(dev, "Can't attach IPMMU %s to domain on IPMMU %s\n",
-			dev_name(mmu->dev), dev_name(domain->mmu->dev));
-		ret = -EINVAL;
+		ret = -EMEDIUMTYPE;
 	} else
 		dev_info(dev, "Reusing IPMMU context %u\n", domain->context_id);
 
diff --git a/drivers/iommu/mtk_iommu_v1.c b/drivers/iommu/mtk_iommu_v1.c
index e1cb51b9866c..5386d889429d 100644
--- a/drivers/iommu/mtk_iommu_v1.c
+++ b/drivers/iommu/mtk_iommu_v1.c
@@ -304,7 +304,7 @@ static int mtk_iommu_v1_attach_device(struct iommu_domain *domain, struct device
 	/* Only allow the domain created internally. */
 	mtk_mapping = data->mapping;
 	if (mtk_mapping->domain != domain)
-		return 0;
+		return -EMEDIUMTYPE;
 
 	if (!data->m4u_dom) {
 		data->m4u_dom = dom;
diff --git a/drivers/iommu/omap-iommu.c b/drivers/iommu/omap-iommu.c
index d9cf2820c02e..6bc8925726bf 100644
--- a/drivers/iommu/omap-iommu.c
+++ b/drivers/iommu/omap-iommu.c
@@ -1471,8 +1471,7 @@ omap_iommu_attach_dev(struct iommu_domain *domain, struct device *dev)
 
 	/* only a single client device can be attached to a domain */
 	if (omap_domain->dev) {
-		dev_err(dev, "iommu domain is already attached\n");
-		ret = -EBUSY;
+		ret = -EMEDIUMTYPE;
 		goto out;
 	}
 
diff --git a/drivers/iommu/s390-iommu.c b/drivers/iommu/s390-iommu.c
index c898bcbbce11..ddcb78b284bb 100644
--- a/drivers/iommu/s390-iommu.c
+++ b/drivers/iommu/s390-iommu.c
@@ -127,7 +127,7 @@ static int s390_iommu_attach_device(struct iommu_domain *domain,
 	/* Allow only devices with identical DMA range limits */
 	} else if (domain->geometry.aperture_start != zdev->start_dma ||
 		   domain->geometry.aperture_end != zdev->end_dma) {
-		rc = -EINVAL;
+		rc = -EMEDIUMTYPE;
 		spin_unlock_irqrestore(&s390_domain->list_lock, flags);
 		goto out_restore;
 	}
diff --git a/drivers/iommu/sprd-iommu.c b/drivers/iommu/sprd-iommu.c
index bd409bab6286..f6ae230ca1cd 100644
--- a/drivers/iommu/sprd-iommu.c
+++ b/drivers/iommu/sprd-iommu.c
@@ -237,10 +237,8 @@ static int sprd_iommu_attach_device(struct iommu_domain *domain,
 	struct sprd_iommu_domain *dom = to_sprd_domain(domain);
 	size_t pgt_size = sprd_iommu_pgt_size(domain);
 
-	if (dom->sdev) {
-		pr_err("There's already a device attached to this domain.\n");
-		return -EINVAL;
-	}
+	if (dom->sdev)
+		return -EMEDIUMTYPE;
 
 	dom->pgt_va = dma_alloc_coherent(sdev->dev, pgt_size, &dom->pgt_pa, GFP_KERNEL);
 	if (!dom->pgt_va)
diff --git a/drivers/iommu/tegra-gart.c b/drivers/iommu/tegra-gart.c
index a6700a40a6f8..011c33e6ae31 100644
--- a/drivers/iommu/tegra-gart.c
+++ b/drivers/iommu/tegra-gart.c
@@ -112,7 +112,7 @@ static int gart_iommu_attach_dev(struct iommu_domain *domain,
 	spin_lock(&gart->dom_lock);
 
 	if (gart->active_domain && gart->active_domain != domain) {
-		ret = -EBUSY;
+		ret = -EMEDIUMTYPE;
 	} else if (dev_iommu_priv_get(dev) != domain) {
 		dev_iommu_priv_set(dev, domain);
 		gart->active_domain = domain;
diff --git a/drivers/iommu/virtio-iommu.c b/drivers/iommu/virtio-iommu.c
index 25be4b822aa0..a41a62dccb4d 100644
--- a/drivers/iommu/virtio-iommu.c
+++ b/drivers/iommu/virtio-iommu.c
@@ -733,8 +733,7 @@ static int viommu_attach_dev(struct iommu_domain *domain, struct device *dev)
 		 */
 		ret = viommu_domain_finalise(vdev, domain);
 	} else if (vdomain->viommu != vdev->viommu) {
-		dev_err(dev, "cannot attach to foreign vIOMMU\n");
-		ret = -EXDEV;
+		ret = -EMEDIUMTYPE;
 	}
 	mutex_unlock(&vdomain->mutex);
 
-- 
2.17.1

