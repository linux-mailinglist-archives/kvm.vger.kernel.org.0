Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 130A556245B
	for <lists+kvm@lfdr.de>; Thu, 30 Jun 2022 22:37:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237261AbiF3Uhe (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 30 Jun 2022 16:37:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59448 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237236AbiF3UhI (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 30 Jun 2022 16:37:08 -0400
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2041.outbound.protection.outlook.com [40.107.93.41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F12EC48813;
        Thu, 30 Jun 2022 13:37:05 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=iAGFcwhaaRwYU/3iik32VlXDxYLVZKhD7eE6xKUVsYBC5E3EXTc0p7hywZsV0A2LvhoWeDdwfx9sLwK0aPXEUQacP65DPkc6tWXpyUfvEkSWB76nNSvuQSRP9loaHnrvRZwG7GuvsCdHyL1j3RSoqX5R1unnrKBSvXFkS/eYukVibcRMqGE81k2pRu5Z1K+o7rfO+XHvJAZOVzNa9XOZvcIv15RRlTIh/6ifFsGhXiwWD2wv84TlvXKVkpPR1NHI++amKBRlLfz59OIL2xeY83LsEMQ374rsOdnEJRUEuy0AT/ry4tAgTs4gY7wk8UIQdaubNz5CYX0NY9styztp1A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=5p49u3a/z96HOODUZG2cpFPE3lUT8/dWo/hsnsdblnE=;
 b=Ur6r9RibOPUOGM503//YmGbsk62M12o80CtKr5izcVWlCqGHCvaCBB20Gw0DrDo50wxFW95zakYeGQ1gZ+O8EcFKgeeXk4ROpMZ090tLxHYFRxrvPc9D7CSGt0qJjT1OcOTubcrhjDuetAE3LwlcA/uKDTPr9qyw6fuI7iGOniWs4GghO72iR+kt9/kIwOIfWX3mhg0+kTUB1m5506DwuorHynxrhqjwbSMmuXw3Ea6SysSANSQNaN+Dt31ZpiF9TJWM1RBVQzOlAVJ0XYlRIUsVPFFSS0Bkh9I5reJn603uo37vpWbKA0rvJhr+ASrOdN0vIvm3LLKkEdNAf/e4lw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.235) smtp.rcpttodomain=gmail.com smtp.mailfrom=nvidia.com; dmarc=pass
 (p=reject sp=reject pct=100) action=none header.from=nvidia.com; dkim=none
 (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5p49u3a/z96HOODUZG2cpFPE3lUT8/dWo/hsnsdblnE=;
 b=deb2TL3KCmM/+rEVfsVMbxLOpBaKHrrQvqbZx7wPPYtLFoJKrLbZvO4aVwDlfPPUwew4twjLJiBpsO7C8U0l6wWMDxqyZRPQLaGvEIQYGPDYVTTno2YfUlyoie+RKA1M55ktH54bddF7nJSbIhIIuGub7EKifC6I9iKLgu5AjaRvOjkJvjpwZGwgox6927MtlD4WvB7WN4t4NZKtPzJUHYa30OQfFIFsBq/4CUSKnW8+z3zpu/zkrA4EQ0fnKWVMREkmaKbvAPnaiyPwvX7Y6oXyu8Gzuy7Qkp8eiXo6aSv78e/D90+6OUQm1nlY6K3DbP6xhW+k03FY8Uy4xN15Pg==
Received: from MWHPR1601CA0018.namprd16.prod.outlook.com
 (2603:10b6:300:da::28) by SA0PR12MB4510.namprd12.prod.outlook.com
 (2603:10b6:806:94::8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5395.14; Thu, 30 Jun
 2022 20:37:03 +0000
Received: from CO1NAM11FT014.eop-nam11.prod.protection.outlook.com
 (2603:10b6:300:da:cafe::a9) by MWHPR1601CA0018.outlook.office365.com
 (2603:10b6:300:da::28) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5395.15 via Frontend
 Transport; Thu, 30 Jun 2022 20:37:02 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.235)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.235 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.235; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (12.22.5.235) by
 CO1NAM11FT014.mail.protection.outlook.com (10.13.175.99) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.5395.14 via Frontend Transport; Thu, 30 Jun 2022 20:37:02 +0000
Received: from drhqmail202.nvidia.com (10.126.190.181) by
 DRHQMAIL107.nvidia.com (10.27.9.16) with Microsoft SMTP Server (TLS) id
 15.0.1497.32; Thu, 30 Jun 2022 20:37:02 +0000
Received: from drhqmail203.nvidia.com (10.126.190.182) by
 drhqmail202.nvidia.com (10.126.190.181) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.986.26; Thu, 30 Jun 2022 13:37:01 -0700
Received: from Asurada-Nvidia.nvidia.com (10.127.8.11) by mail.nvidia.com
 (10.126.190.182) with Microsoft SMTP Server id 15.2.986.26 via Frontend
 Transport; Thu, 30 Jun 2022 13:37:00 -0700
From:   Nicolin Chen <nicolinc@nvidia.com>
To:     <joro@8bytes.org>, <will@kernel.org>, <marcan@marcan.st>,
        <sven@svenpeter.dev>, <robin.murphy@arm.com>,
        <robdclark@gmail.com>, <baolu.lu@linux.intel.com>,
        <orsonzhai@gmail.com>, <baolin.wang7@gmail.com>,
        <zhang.lyra@gmail.com>, <jean-philippe@linaro.org>,
        <alex.williamson@redhat.com>, <jgg@nvidia.com>,
        <kevin.tian@intel.com>
CC:     <suravee.suthikulpanit@amd.com>, <alyssa@rosenzweig.io>,
        <dwmw2@infradead.org>, <mjrosato@linux.ibm.com>,
        <gerald.schaefer@linux.ibm.com>, <thierry.reding@gmail.com>,
        <vdumpa@nvidia.com>, <jonathanh@nvidia.com>, <cohuck@redhat.com>,
        <thunder.leizhen@huawei.com>, <christophe.jaillet@wanadoo.fr>,
        <chenxiang66@hisilicon.com>, <john.garry@huawei.com>,
        <yangyingliang@huawei.com>, <iommu@lists.linux-foundation.org>,
        <iommu@lists.linux.dev>, <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-arm-msm@vger.kernel.org>, <linux-s390@vger.kernel.org>,
        <linux-tegra@vger.kernel.org>,
        <virtualization@lists.linux-foundation.org>, <kvm@vger.kernel.org>
Subject: [PATCH v4 1/5] iommu: Return -EMEDIUMTYPE for incompatible domain and device/group
Date:   Thu, 30 Jun 2022 13:36:31 -0700
Message-ID: <20220630203635.33200-2-nicolinc@nvidia.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20220630203635.33200-1-nicolinc@nvidia.com>
References: <20220630203635.33200-1-nicolinc@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 384da35f-dc18-4987-f6d1-08da5ad849f9
X-MS-TrafficTypeDiagnostic: SA0PR12MB4510:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?5QpXE8fNrpIvWxk3Redu5MR4SHw/zIlY/iiyR6KOkRtO6hJAe+xr3EI2ugJ8?=
 =?us-ascii?Q?KYNI222o7g1F5eZONWoIhMdCHn63Izs1MhB8nxpR+T2QtTXC8JV8JiCiLUym?=
 =?us-ascii?Q?KF3R6K8HUOU1R2J+q0W8zziDqpRelZSz1Uc4RkAMZrU8oGJb4hW44BaKK1SD?=
 =?us-ascii?Q?q3N/7d9XN4YjxGC4vJs+9BaAtOOlukd+91lhXYAZquPwLmzx3z/+MG3swcMz?=
 =?us-ascii?Q?Tc69XHDUPNLZ0zuIbKKDWFirWDcEbvbgIS1zXYeMWbmeAxsbP2jBHCSHC8ya?=
 =?us-ascii?Q?dOAwvkiTh+j45j/+KrbOJeabrPnj6+qeqFCGHkLo1xheipMhuHwnYP2AN7mW?=
 =?us-ascii?Q?MlPQsPTrB24pWlQnh7uQcu5BJt704cAO7l8R2t6YKtO1EX4oY8WG9zkKCQT3?=
 =?us-ascii?Q?oKenTY1fr//XL5Bpi3GxC77sgQf6P1VL/4c1/4BVzo6AfYzGno8VtX0lkBOM?=
 =?us-ascii?Q?WugLUDRn2A78xdafFaP4kcQsrwopKznoNqgu44ax6MApr7leesGqkrLB65V/?=
 =?us-ascii?Q?pspWYIKdI3MJ+Ka7iIirHY3byyHU7SXuX2yHVcOdRds4as3mCYwRes/T6fkS?=
 =?us-ascii?Q?yDhNENHI1rBn19L4IrW+aYUarzPoXjURGxjV5DqZJQB0hp21CcRUNNo8I/bN?=
 =?us-ascii?Q?M+LatB80L6/Kd1GVp4aGFmM6qEN4kCWKJiFcVjt+6pNDRRoWkxb5xpHF+GZL?=
 =?us-ascii?Q?jpHwJFrdZlgq6dH6k0bLgyOm/L/Fhqrk9GCGvIUTCNvOeCJ1haBS43hBGH0l?=
 =?us-ascii?Q?O+RSVPcCImUWUXRp6+LJOF+A9Dd8anjMy59lXeUFxRXBABRn/xFsf3m9vTYg?=
 =?us-ascii?Q?NS209M+NHT/sTlzKmJ7/egDdt75fRFbcfcCkeWaSsM/izdytvWtAb/VkruA6?=
 =?us-ascii?Q?XxhsKOPTwVTkP+1pRxnZgA/mT1srldO37/XtpyhmEUNqlx+Eo9dYwmMSl4/f?=
 =?us-ascii?Q?4ixBbEpdWMnB4ILV0evBFa3e/hvyqrtYkzTfPPilS94=3D?=
X-Forefront-Antispam-Report: CIP:12.22.5.235;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(13230016)(4636009)(376002)(346002)(136003)(396003)(39860400002)(36840700001)(40470700004)(46966006)(82310400005)(83380400001)(40480700001)(36860700001)(70586007)(81166007)(921005)(478600001)(86362001)(36756003)(40460700003)(356005)(82740400003)(110136005)(2616005)(47076005)(30864003)(426003)(186003)(7406005)(26005)(1076003)(41300700001)(7696005)(54906003)(5660300002)(2906002)(8936002)(316002)(336012)(70206006)(8676002)(6666004)(7416002)(4326008)(334744004)(83996005)(2101003)(36900700001)(473944003);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Jun 2022 20:37:02.5494
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 384da35f-dc18-4987-f6d1-08da5ad849f9
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.235];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT014.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR12MB4510
X-Spam-Status: No, score=-1.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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
 drivers/iommu/omap-iommu.c                  |  3 +--
 drivers/iommu/s390-iommu.c                  |  2 +-
 drivers/iommu/sprd-iommu.c                  |  6 ++---
 drivers/iommu/tegra-gart.c                  |  2 +-
 drivers/iommu/virtio-iommu.c                |  3 +--
 13 files changed, 48 insertions(+), 46 deletions(-)

diff --git a/drivers/iommu/amd/iommu.c b/drivers/iommu/amd/iommu.c
index a56a9ad3273e..e851c3e91145 100644
--- a/drivers/iommu/amd/iommu.c
+++ b/drivers/iommu/amd/iommu.c
@@ -1743,7 +1743,7 @@ static int attach_device(struct device *dev,
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
index cdc86c39954e..15e7a2914b5a 100644
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
index 1d42084d0276..0103480648cb 100644
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

