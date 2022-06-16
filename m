Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8176F54D5B1
	for <lists+kvm@lfdr.de>; Thu, 16 Jun 2022 02:05:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350181AbiFPADY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 15 Jun 2022 20:03:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41030 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230172AbiFPADT (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 15 Jun 2022 20:03:19 -0400
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2050.outbound.protection.outlook.com [40.107.92.50])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 390A44F464;
        Wed, 15 Jun 2022 17:03:17 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=RRG/OP2OZDq7ETtlUJ5m9cHbLPU78hPkHDz42W5ha0tfKNLBPxDoXu5f80Ngbu6YTGKXIwqUcTf/XsvBj09Q/dGOlslEXdARNaIoD0/Q356QWPlbqRJ1JKyCswXWvo8aQJaU5fkOwDNzsMOV2kjFwJoI+lqJn7yo98m2fF9h3vbcuLDwUFUESvfZfx+vDQAeJ0wbdpLZkxP3d/3QmBXgR/5D2L7sfmiCamtUIvTcqKCltT2tuSiY0vCYvpwaC4K3CS8yuAlF141AQj6mfjIv7nuIjVYb/cfbvNBER5cA6BSo03qlx2QAuUxX2nQmzoSWRhNBjYX3rS0cFO+CdsU7Lw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Jd+am/4X2PkmMoAOUdBxof9qh2blHLzmUNpBLn2r/zE=;
 b=cd76jxknVIoPjLyo8lu41pawiTv62hB2qPmDrV4Qslvovkh+FoZ03irRlhzH0c0sqQQzztBg2kQjYmYLPHw4Wrm0eWNnNpwMAv2kFyZEffKow3kRIo/OtlP7TA8aXSnVXnCT0hNkRpjLi0ymCre7lfdL9kxP04eZwd01mKCHofqjlJG5+jGAlBNdXsDIdheALbQNY8tI+1KDP1ALnjILTLgXv6AkNjkm2i7fxPxQHyt4Wqb6DGm7aMU4OCYeZ5mjA8lq9BzbSvzH4/kEOoh37xenGpdzsajYK4IDGeAOTfsRF2UxNnXdp5EqlcyGFytTkoxO8QFq50dtJ7feISKz7Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.235) smtp.rcpttodomain=linux.intel.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Jd+am/4X2PkmMoAOUdBxof9qh2blHLzmUNpBLn2r/zE=;
 b=aD2jdN4bE8oDDyeMbXGaUYHMvPOn/zxKB7DXvXMcqXAFTtwv3PZZgdqg/Vwy2Et56m3MhdpNwMSHY2Bwfpe97n9jVTSJvoplbr11kxgb+clXF0fQEyUBCINlE62qo34Y32mctWwhw3kLS32BYocn1QeQ1otlUQ7tXUSin3rarLkgrmXd7KwxKnJxeZ4C8kvBZ1zPxU2EjlbSoP2QPiaQZS/lc6clDSfLsI8DdmKZtDQl59B04+px05PaNwQkwiKq9UvzCBs+pl/ksHLVUMK+yHgr9/dnyr3GOfRLVctryjUz3c7xabWK2VU7q+tDjfhP+3g0DzYQhMbw9spDHPjLHQ==
Received: from MW4P220CA0016.NAMP220.PROD.OUTLOOK.COM (2603:10b6:303:115::21)
 by BN6PR12MB1651.namprd12.prod.outlook.com (2603:10b6:405:4::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5353.14; Thu, 16 Jun
 2022 00:03:14 +0000
Received: from CO1NAM11FT038.eop-nam11.prod.protection.outlook.com
 (2603:10b6:303:115:cafe::d4) by MW4P220CA0016.outlook.office365.com
 (2603:10b6:303:115::21) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5332.13 via Frontend
 Transport; Thu, 16 Jun 2022 00:03:14 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.235)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.235 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.235; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (12.22.5.235) by
 CO1NAM11FT038.mail.protection.outlook.com (10.13.174.231) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.5332.12 via Frontend Transport; Thu, 16 Jun 2022 00:03:13 +0000
Received: from drhqmail202.nvidia.com (10.126.190.181) by
 DRHQMAIL107.nvidia.com (10.27.9.16) with Microsoft SMTP Server (TLS) id
 15.0.1497.32; Thu, 16 Jun 2022 00:03:12 +0000
Received: from drhqmail201.nvidia.com (10.126.190.180) by
 drhqmail202.nvidia.com (10.126.190.181) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.986.22; Wed, 15 Jun 2022 17:03:12 -0700
Received: from Asurada-Nvidia.nvidia.com (10.127.8.11) by mail.nvidia.com
 (10.126.190.180) with Microsoft SMTP Server id 15.2.986.22 via Frontend
 Transport; Wed, 15 Jun 2022 17:03:10 -0700
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
        <christophe.jaillet@wanadoo.fr>, <john.garry@huawei.com>,
        <chenxiang66@hisilicon.com>, <saiprakash.ranjan@codeaurora.org>,
        <isaacm@codeaurora.org>, <yangyingliang@huawei.com>,
        <jordan@cosmicpenguin.net>, <iommu@lists.linux-foundation.org>,
        <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-arm-msm@vger.kernel.org>,
        <linux-mediatek@lists.infradead.org>, <linux-s390@vger.kernel.org>,
        <linux-tegra@vger.kernel.org>,
        <virtualization@lists.linux-foundation.org>, <kvm@vger.kernel.org>
Subject: [PATCH v2 1/5] iommu: Return -EMEDIUMTYPE for incompatible domain and device/group
Date:   Wed, 15 Jun 2022 17:03:00 -0700
Message-ID: <20220616000304.23890-2-nicolinc@nvidia.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20220616000304.23890-1-nicolinc@nvidia.com>
References: <20220616000304.23890-1-nicolinc@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 62c11344-bf77-4ed2-49ac-08da4f2b9bb0
X-MS-TrafficTypeDiagnostic: BN6PR12MB1651:EE_
X-Microsoft-Antispam-PRVS: <BN6PR12MB16518335A12A563551F96754ABAC9@BN6PR12MB1651.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: pHnYkzOlVrMIlPvrP04e1MK7gEJankOTDbdO5IIxQVCPKquBp55uxcNK+ye2NOqoNnvNkVky0juxuF8RNji70OxXzbhzz2ME4JDOqbHSiwAOcD7r0v4/yfV1UhSnqtKc6+DbyqeofoeMfLU/W278hXciXSZQEwKWBzva9E1yBwOeiaB2rjMsMXULG917eoW+BrNFpnenkq3+EpOzhQiwYw7oU/FVfnclMdMclhS3URdgrndpeMHU9kDsJlJE1YWO6kCE1fEYAcQrOfdnvhSxhUEKpHECGm2FaDLfCAs1T8J64aQBed+gUeZgDuVK8/i7hGP6cnfer6DhJv4jUNCkCyK87YwGKVjahyaMvO5+jpVBqGDu/eUqf4H3KQa8O2E+fuluX1hI4mAcAUp9PjMUodHBlb/vgLWu5rR324X2c5ZqSu9SN3gSNkt76D2jMrn22CAlgHrUPxq52Kf2CFW9FTILJ68W9lHHWQA0BEYOWgBAsDUOiqctp33oXYT9iUWR1A7q55pZ2Q6RPL5djyhuAHdO/We9mXTKpPlxs5xgT2G9F5R4HvHqaJXE9+M6VvyvXR0BtF6fgiE/NSugugyf0mmP4lHgik7IgXdBI1zXpCl6h4/fbbqd2i0YKq5PQ4JoFseZrRwLWKRF9KhrxEIM9JKNHy3d5n2GZLJK6alQcjuxj3NSZ9rbq+amdcCg5Opmde7hcXNofyz2LAN/sCIfkoNCzjfnwi7YezBrPJkOLu2We+N97PS5IujvXx15k+ObwEq/mSIItgbvtMs/P5ERMEm4SyRZauLNavWZV82wcox0bUKp8/4VZ4REHoL3tX8eR3Vjxq30vawtB0BrLJ1erQ==
X-Forefront-Antispam-Report: CIP:12.22.5.235;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(13230016)(4636009)(40470700004)(36840700001)(46966006)(4326008)(70206006)(921005)(40460700003)(356005)(2906002)(8676002)(70586007)(86362001)(7416002)(7406005)(8936002)(81166007)(30864003)(82310400005)(5660300002)(186003)(316002)(336012)(508600001)(47076005)(2616005)(6666004)(7696005)(26005)(36860700001)(110136005)(83380400001)(426003)(1076003)(54906003)(36756003)(334744004)(36900700001)(2101003)(83996005)(473944003);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Jun 2022 00:03:13.9462
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 62c11344-bf77-4ed2-49ac-08da4f2b9bb0
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.235];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT038.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN6PR12MB1651
X-Spam-Status: No, score=-2.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
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
related to domain incompatability. Also turn adjacent error prints into
debug prints, for these soft failures, to prevent a kernel log spam.

Add kdocs describing this behavior.

Suggested-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Nicolin Chen <nicolinc@nvidia.com>
---
 drivers/iommu/amd/iommu.c                   |  2 +-
 drivers/iommu/apple-dart.c                  |  4 +--
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c | 12 ++++-----
 drivers/iommu/arm/arm-smmu/arm-smmu.c       |  4 +--
 drivers/iommu/arm/arm-smmu/qcom_iommu.c     |  4 +--
 drivers/iommu/intel/iommu.c                 |  6 ++---
 drivers/iommu/iommu.c                       | 28 +++++++++++++++++++++
 drivers/iommu/ipmmu-vmsa.c                  |  4 +--
 drivers/iommu/mtk_iommu_v1.c                |  2 +-
 drivers/iommu/omap-iommu.c                  |  4 +--
 drivers/iommu/s390-iommu.c                  |  2 +-
 drivers/iommu/sprd-iommu.c                  |  4 +--
 drivers/iommu/tegra-gart.c                  |  2 +-
 drivers/iommu/virtio-iommu.c                |  4 +--
 14 files changed, 55 insertions(+), 27 deletions(-)

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
index 88817a3376ef..1c66e4b6d852 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
@@ -2420,24 +2420,24 @@ static int arm_smmu_attach_dev(struct iommu_domain *domain, struct device *dev)
 			goto out_unlock;
 		}
 	} else if (smmu_domain->smmu != smmu) {
-		dev_err(dev,
+		dev_dbg(dev,
 			"cannot attach to SMMU %s (upstream of %s)\n",
 			dev_name(smmu_domain->smmu->dev),
 			dev_name(smmu->dev));
-		ret = -ENXIO;
+		ret = -EMEDIUMTYPE;
 		goto out_unlock;
 	} else if (smmu_domain->stage == ARM_SMMU_DOMAIN_S1 &&
 		   master->ssid_bits != smmu_domain->s1_cfg.s1cdmax) {
-		dev_err(dev,
+		dev_dbg(dev,
 			"cannot attach to incompatible domain (%u SSID bits != %u)\n",
 			smmu_domain->s1_cfg.s1cdmax, master->ssid_bits);
-		ret = -EINVAL;
+		ret = -EMEDIUMTYPE;
 		goto out_unlock;
 	} else if (smmu_domain->stage == ARM_SMMU_DOMAIN_S1 &&
 		   smmu_domain->stall_enabled != master->stall_enabled) {
-		dev_err(dev, "cannot attach to stall-%s domain\n",
+		dev_dbg(dev, "cannot attach to stall-%s domain\n",
 			smmu_domain->stall_enabled ? "enabled" : "disabled");
-		ret = -EINVAL;
+		ret = -EMEDIUMTYPE;
 		goto out_unlock;
 	}
 
diff --git a/drivers/iommu/arm/arm-smmu/arm-smmu.c b/drivers/iommu/arm/arm-smmu/arm-smmu.c
index 2ed3594f384e..1d40023253d8 100644
--- a/drivers/iommu/arm/arm-smmu/arm-smmu.c
+++ b/drivers/iommu/arm/arm-smmu/arm-smmu.c
@@ -1136,8 +1136,8 @@ static int arm_smmu_attach_dev(struct iommu_domain *domain, struct device *dev)
 	int ret;
 
 	if (!fwspec || fwspec->ops != &arm_smmu_ops) {
-		dev_err(dev, "cannot attach to SMMU, is it on the same bus?\n");
-		return -ENXIO;
+		dev_dbg(dev, "cannot attach to SMMU, is it on the same bus?\n");
+		return -EMEDIUMTYPE;
 	}
 
 	/*
diff --git a/drivers/iommu/arm/arm-smmu/qcom_iommu.c b/drivers/iommu/arm/arm-smmu/qcom_iommu.c
index 4c077c38fbd6..fd4e3f10d2bf 100644
--- a/drivers/iommu/arm/arm-smmu/qcom_iommu.c
+++ b/drivers/iommu/arm/arm-smmu/qcom_iommu.c
@@ -382,11 +382,11 @@ static int qcom_iommu_attach_dev(struct iommu_domain *domain, struct device *dev
 	 * different IOMMUs.
 	 */
 	if (qcom_domain->iommu != qcom_iommu) {
-		dev_err(dev, "cannot attach to IOMMU %s while already "
+		dev_dbg(dev, "cannot attach to IOMMU %s while already "
 			"attached to domain on IOMMU %s\n",
 			dev_name(qcom_domain->iommu->dev),
 			dev_name(qcom_iommu->dev));
-		return -EINVAL;
+		return -EMEDIUMTYPE;
 	}
 
 	return 0;
diff --git a/drivers/iommu/intel/iommu.c b/drivers/iommu/intel/iommu.c
index 44016594831d..0dd13330fe12 100644
--- a/drivers/iommu/intel/iommu.c
+++ b/drivers/iommu/intel/iommu.c
@@ -4323,7 +4323,7 @@ static int prepare_domain_attach_device(struct iommu_domain *domain,
 		return -ENODEV;
 
 	if (dmar_domain->force_snooping && !ecap_sc_support(iommu->ecap))
-		return -EOPNOTSUPP;
+		return -EMEDIUMTYPE;
 
 	/* check if this iommu agaw is sufficient for max mapped address */
 	addr_width = agaw_to_width(iommu->agaw);
@@ -4331,10 +4331,10 @@ static int prepare_domain_attach_device(struct iommu_domain *domain,
 		addr_width = cap_mgaw(iommu->cap);
 
 	if (dmar_domain->max_addr > (1LL << addr_width)) {
-		dev_err(dev, "%s: iommu width (%d) is not "
+		dev_dbg(dev, "%s: iommu width (%d) is not "
 		        "sufficient for the mapped address (%llx)\n",
 		        __func__, addr_width, dmar_domain->max_addr);
-		return -EFAULT;
+		return -EMEDIUMTYPE;
 	}
 	dmar_domain->gaw = addr_width;
 
diff --git a/drivers/iommu/iommu.c b/drivers/iommu/iommu.c
index 847ad47a2dfd..ea118a2acfe5 100644
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
+ * recommended to keep kernel print free or simply use dev_dbg() when reporting
+ * -EMEDIUMTYPE error, since this function can be called to test compatibility
+ * with domains that will fail the test, which will result in a kernel log spam.
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
+ * recommended to keep kernel print free or simply use dev_dbg() when reporting
+ * -EMEDIUMTYPE error, since this function can be called to test compatibility
+ * with domains that will fail the test, which will result in a kernel log spam.
+ */
 int iommu_attach_group(struct iommu_domain *domain, struct iommu_group *group)
 {
 	int ret;
diff --git a/drivers/iommu/ipmmu-vmsa.c b/drivers/iommu/ipmmu-vmsa.c
index 8fdb84b3642b..9e6ef5eb7722 100644
--- a/drivers/iommu/ipmmu-vmsa.c
+++ b/drivers/iommu/ipmmu-vmsa.c
@@ -628,9 +628,9 @@ static int ipmmu_attach_device(struct iommu_domain *io_domain,
 		 * Something is wrong, we can't attach two devices using
 		 * different IOMMUs to the same domain.
 		 */
-		dev_err(dev, "Can't attach IPMMU %s to domain on IPMMU %s\n",
+		dev_dbg(dev, "Can't attach IPMMU %s to domain on IPMMU %s\n",
 			dev_name(mmu->dev), dev_name(domain->mmu->dev));
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
index d9cf2820c02e..b5429adb6aed 100644
--- a/drivers/iommu/omap-iommu.c
+++ b/drivers/iommu/omap-iommu.c
@@ -1471,8 +1471,8 @@ omap_iommu_attach_dev(struct iommu_domain *domain, struct device *dev)
 
 	/* only a single client device can be attached to a domain */
 	if (omap_domain->dev) {
-		dev_err(dev, "iommu domain is already attached\n");
-		ret = -EBUSY;
+		dev_dbg(dev, "iommu domain is already attached\n");
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
index bd409bab6286..6881021f8c48 100644
--- a/drivers/iommu/sprd-iommu.c
+++ b/drivers/iommu/sprd-iommu.c
@@ -238,8 +238,8 @@ static int sprd_iommu_attach_device(struct iommu_domain *domain,
 	size_t pgt_size = sprd_iommu_pgt_size(domain);
 
 	if (dom->sdev) {
-		pr_err("There's already a device attached to this domain.\n");
-		return -EINVAL;
+		pr_debug("There's already a device attached to this domain.\n");
+		return -EMEDIUMTYPE;
 	}
 
 	dom->pgt_va = dma_alloc_coherent(sdev->dev, pgt_size, &dom->pgt_pa, GFP_KERNEL);
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
index 25be4b822aa0..0a8988d3f7bd 100644
--- a/drivers/iommu/virtio-iommu.c
+++ b/drivers/iommu/virtio-iommu.c
@@ -733,8 +733,8 @@ static int viommu_attach_dev(struct iommu_domain *domain, struct device *dev)
 		 */
 		ret = viommu_domain_finalise(vdev, domain);
 	} else if (vdomain->viommu != vdev->viommu) {
-		dev_err(dev, "cannot attach to foreign vIOMMU\n");
-		ret = -EXDEV;
+		dev_dbg(dev, "cannot attach to foreign vIOMMU\n");
+		ret = -EMEDIUMTYPE;
 	}
 	mutex_unlock(&vdomain->mutex);
 
-- 
2.17.1

