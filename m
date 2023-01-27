Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AD57D67EF33
	for <lists+kvm@lfdr.de>; Fri, 27 Jan 2023 21:06:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233186AbjA0UGe (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 27 Jan 2023 15:06:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49644 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232421AbjA0UGJ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 27 Jan 2023 15:06:09 -0500
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2060d.outbound.protection.outlook.com [IPv6:2a01:111:f400:7e8a::60d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6A47824CBE;
        Fri, 27 Jan 2023 12:05:11 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=IwCRObDLUR4lDzILfX+uSkRt5RdkJCh4hrL0ilj1Q12QDCdzYdKPT67gVI51yQnNt14fur0NeCe11a2GSJXIN2pnyv5hp/gt9TenpKTXsJVww+QnF2YaiGUUkkaQUdlJYahJ7Qaxv2BR2ORAFVoylDwUpVYZqKjSKUQjSn5d+ZcOZshEaiDs8jXZiX9HNyaTa4myGUuBS+dBO1EhIRQsdA0uXcU4YIcJ9ul2ghFRaA/x2MZERVaYXV99x5pbpU+gbACHFtyJEGj8TGExixZjmFPSK78r1T1HhTdd9VYOiT+eAlV/DA7MruuGY+kiScBSxqo/BbxkWQkSLlCUmvHLlw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=mXVjs3EYyLasqPSgAoXLLOKEm+zYFSEF3Hi6bBiavhQ=;
 b=GZtf9zXZej+pCJO2a9lu6kULzUCst+Abcliy7IVgNm4a2QPtT8vw4j7IxGDFmQ1krNARk4XTHGKilkBQzTa5hXxnogUCM4EDuLb7URJE2QTqCnJ7qV+wAv1SULJk9gGTSv6JadLeQdqfNqq41xz12W8EOC2edTlBSmK4MjurkQbnex9gUqLPjQ2+G6CtCfG2xye8HUMDto7s/2ntraXA+XbbZnoLpPXCShXkrBEvkXZpa/IAjwuuHl/Eef9sNH9G5PUkkX6P90Hklj/m7JNI/uDpl58c06jJVVEghmvy6Bf8xGMZ8UG94kHWTKzKQk87PZlVkX3ACir+cY1IyDT+0g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=lists.infradead.org
 smtp.mailfrom=nvidia.com; dmarc=pass (p=reject sp=reject pct=100) action=none
 header.from=nvidia.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=mXVjs3EYyLasqPSgAoXLLOKEm+zYFSEF3Hi6bBiavhQ=;
 b=nEpT16Vzgl0PA8phSsHIfJ//yz8Gdqco1iN4FkyeenvexT5YRhex9QVxCGdZyYF8HZ9YkBx4A4xntzEUCXsbSJRSRzrMV2jATq6KvTyLX7megpykrJiD6zaLpr9qxIaSIGT8F0IfTLR+9ihuvnQZ56WTT73BB2w01/NiBQGo0CivWAC4zsSW5wmz6WhqFxbBipzcpTtXhZB8S0x4g+k4SdaJ7WlY9uiP6FEqtDb1NAWIk+W30oKQsh2N9Wit8wom+zj/iCKyUxWc90QLfGGD9J5MOpfR6DlLS/q5xseR1gxQ9CnY50H2M1QFEXUI2INJj+0f/f2DqN7N2gPnz4WX4w==
Received: from BN9PR03CA0070.namprd03.prod.outlook.com (2603:10b6:408:fc::15)
 by IA0PR12MB7531.namprd12.prod.outlook.com (2603:10b6:208:43f::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6043.22; Fri, 27 Jan
 2023 20:05:07 +0000
Received: from BN8NAM11FT059.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:fc:cafe::1f) by BN9PR03CA0070.outlook.office365.com
 (2603:10b6:408:fc::15) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6043.25 via Frontend
 Transport; Fri, 27 Jan 2023 20:05:07 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.161)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 BN8NAM11FT059.mail.protection.outlook.com (10.13.177.120) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6043.23 via Frontend Transport; Fri, 27 Jan 2023 20:05:07 +0000
Received: from rnnvmail204.nvidia.com (10.129.68.6) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.36; Fri, 27 Jan
 2023 12:04:57 -0800
Received: from rnnvmail205.nvidia.com (10.129.68.10) by rnnvmail204.nvidia.com
 (10.129.68.6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.36; Fri, 27 Jan
 2023 12:04:56 -0800
Received: from Asurada-Nvidia.nvidia.com (10.127.8.12) by mail.nvidia.com
 (10.129.68.10) with Microsoft SMTP Server id 15.2.986.36 via Frontend
 Transport; Fri, 27 Jan 2023 12:04:55 -0800
From:   Nicolin Chen <nicolinc@nvidia.com>
To:     <jgg@nvidia.com>, <kevin.tian@intel.com>, <robin.murphy@arm.com>,
        <joro@8bytes.org>, <will@kernel.org>, <agross@kernel.org>,
        <andersson@kernel.org>, <konrad.dybcio@linaro.org>,
        <yong.wu@mediatek.com>, <matthias.bgg@gmail.com>,
        <thierry.reding@gmail.com>, <alex.williamson@redhat.com>,
        <cohuck@redhat.com>
CC:     <vdumpa@nvidia.com>, <jonathanh@nvidia.com>,
        <iommu@lists.linux.dev>, <linux-kernel@vger.kernel.org>,
        <linux-arm-msm@vger.kernel.org>,
        <linux-mediatek@lists.infradead.org>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-tegra@vger.kernel.org>, <kvm@vger.kernel.org>
Subject: [PATCH 1/4] iommu: Add a broken_unmanaged_domain flag in iommu_ops
Date:   Fri, 27 Jan 2023 12:04:17 -0800
Message-ID: <0875479d24a53670e17db8a11945664a6bb4a25b.1674849118.git.nicolinc@nvidia.com>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <cover.1674849118.git.nicolinc@nvidia.com>
References: <cover.1674849118.git.nicolinc@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN8NAM11FT059:EE_|IA0PR12MB7531:EE_
X-MS-Office365-Filtering-Correlation-Id: f42cbbc0-a718-4abb-ac8f-08db00a1c9df
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: zuSgDPdKH+iQ/mM5iESN3ezTXb4PN5DA1Pmljx8A5erhH+BQk9CMrzf7ua+i5qoO9AWsrBbuXbvXkCZnWyiabqE9jm4MZrWOOIAhS9bgaQjoKXucGAbYnmQH3I9FGqxbYh/m7ZXafmTy50V8X6mHCWfGbAaQIDDIDaz77TIVkWY/AEozp09B2WzaUNCCTolmgEHX2ys6bdBFqZF2HXObkuHk599P1P1o2OSIDaHT35K7DIQ9vYu5ufC8R6vfYfMsTQGFVEnAYxhMUNuwI93e+cg2wScERTFTydM1WG1IURk66gk7FzcRi7XVWngHtNJ7Loi35r2WO6yEQmLH8hOI3sT5R9Snd/63ItdUrjJT5QdDg7JnkLjtTW6c7tVf6JUbYXyMTHYucxv+88DejD5xlamXG9hgm1Jjm3ij0cBCvLOHla6MQYbwpV4gGuXDPSgz6uJ39sfJ4i/r8uytM//Ol0WW1HS9JYIkcp7O9/Zmu9ODgBdH8w34gC1wRqRJdRg1QIAkIv4yCk8+PJJkGjMw9cJETA66VHJvx74mV/pNCMY190SqfoTEkl2kjI2FfgqmwKX+6KyCMls0lPq8v2e9ApV5R4pukcpH29nU7Vg7Ae/gVuTTKCShXFWEt/LtaT4X2w8b5TJjTiBkrnJ8wyUWnkbYxmguCsSW90tGg+7FtiuslNfxXLHp31HbDjlBRCm7
X-Forefront-Antispam-Report: CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230025)(4636009)(396003)(136003)(346002)(376002)(39860400002)(451199018)(46966006)(36840700001)(7696005)(186003)(26005)(478600001)(47076005)(2616005)(336012)(82310400005)(426003)(83380400001)(6666004)(316002)(54906003)(41300700001)(7636003)(8676002)(356005)(70206006)(82740400003)(110136005)(921005)(8936002)(4326008)(86362001)(5660300002)(70586007)(7416002)(36756003)(40480700001)(36860700001)(2906002);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Jan 2023 20:05:07.7639
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: f42cbbc0-a718-4abb-ac8f-08db00a1c9df
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT059.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA0PR12MB7531
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        SPF_HELO_PASS,SPF_NONE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Both IOMMU_DOMAIN_UNMANAGED and IOMMU_DOMAIN_DMA require the support
of __IOMMU_DOMAIN_PAGING capability, i.e. iommu_map/unmap. However,
some older iommu drivers do not fully support that, and these drivers
also do not advertise support for dma-iommu.c via IOMMU_DOMAIN_DMA,
or use arm_iommu_create_mapping(), so largely their implementations
of IOMMU_DOMAIN_UNMANAGED are untested. This means that a user like
vfio/iommufd does not likely work with them.

Several of them have obvious problems:
  * fsl_pamu_domain.c
    Without map/unmap ops in the default_domain_ops, it isn't an
    unmanaged domain at all.
  * mtk_iommu_v1.c
    With a fixed 4M "pagetable", it can only map exactly 4G of
    memory, but doesn't set the aperture.
  * tegra-gart.c
    Its notion of attach/detach and groups has to be a complete lie to
    get around all the other API expectations.

Some others might work but have never been tested with vfio/iommufd:
  * msm_iommu.c
  * omap-iommu.c
  * tegra-smmu.c

Thus, mark all these drivers as having "broken" UNAMANGED domains and
add a new device_iommu_unmanaged_supported() API for vfio/iommufd and
dma-iommu to refuse to work with these drivers.

Co-developed-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Nicolin Chen <nicolinc@nvidia.com>
---
 drivers/iommu/fsl_pamu_domain.c |  1 +
 drivers/iommu/iommu.c           | 24 ++++++++++++++++++++++++
 drivers/iommu/msm_iommu.c       |  1 +
 drivers/iommu/mtk_iommu_v1.c    |  1 +
 drivers/iommu/omap-iommu.c      |  1 +
 drivers/iommu/tegra-gart.c      |  1 +
 drivers/iommu/tegra-smmu.c      |  1 +
 include/linux/iommu.h           | 11 +++++++++++
 8 files changed, 41 insertions(+)

diff --git a/drivers/iommu/fsl_pamu_domain.c b/drivers/iommu/fsl_pamu_domain.c
index 4408ac3c49b6..1f3a4c8c78ad 100644
--- a/drivers/iommu/fsl_pamu_domain.c
+++ b/drivers/iommu/fsl_pamu_domain.c
@@ -448,6 +448,7 @@ static struct iommu_device *fsl_pamu_probe_device(struct device *dev)
 }
 
 static const struct iommu_ops fsl_pamu_ops = {
+	.broken_unmanaged_domain = true,
 	.capable	= fsl_pamu_capable,
 	.domain_alloc	= fsl_pamu_domain_alloc,
 	.probe_device	= fsl_pamu_probe_device,
diff --git a/drivers/iommu/iommu.c b/drivers/iommu/iommu.c
index 5f6a85aea501..648fc04143b8 100644
--- a/drivers/iommu/iommu.c
+++ b/drivers/iommu/iommu.c
@@ -1897,6 +1897,30 @@ bool device_iommu_capable(struct device *dev, enum iommu_cap cap)
 }
 EXPORT_SYMBOL_GPL(device_iommu_capable);
 
+/**
+ * device_iommu_unmanaged_supported() - full support of IOMMU_DOMAIN_UNMANAGED
+ * @dev: device that is behind the iommu
+ *
+ * In general, all IOMMU drivers can allocate IOMMU_DOMAIN_UNMANAGED domains.
+ * However, some of them set the broken_unmanaged_domain, indicating something
+ * is wrong about its support of IOMMU_DOMAIN_UNMANAGED/__IOMMU_DOMAIN_PAGING.
+ * This can happen, when a driver lies about the support to get around with the
+ * IOMMU API, merely for other drivers to use, or when a driver has never been
+ * tested with vfio/iommufd that need a full support of IOMMU_DOMAIN_UNMANAGED.
+ *
+ * Return: true if an IOMMU is present and broken_unmanaged_domain is not set,
+ *         otherwise, false.
+ */
+bool device_iommu_unmanaged_supported(struct device *dev)
+{
+	if (dev->iommu && dev->iommu->iommu_dev &&
+	    !dev_iommu_ops(dev)->broken_unmanaged_domain)
+		return true;
+
+	return false;
+}
+EXPORT_SYMBOL_GPL(device_iommu_unmanaged_supported);
+
 /**
  * iommu_set_fault_handler() - set a fault handler for an iommu domain
  * @domain: iommu domain
diff --git a/drivers/iommu/msm_iommu.c b/drivers/iommu/msm_iommu.c
index c60624910872..9c0bd5aee10b 100644
--- a/drivers/iommu/msm_iommu.c
+++ b/drivers/iommu/msm_iommu.c
@@ -675,6 +675,7 @@ irqreturn_t msm_iommu_fault_handler(int irq, void *dev_id)
 }
 
 static struct iommu_ops msm_iommu_ops = {
+	.broken_unmanaged_domain = true,
 	.domain_alloc = msm_iommu_domain_alloc,
 	.probe_device = msm_iommu_probe_device,
 	.device_group = generic_device_group,
diff --git a/drivers/iommu/mtk_iommu_v1.c b/drivers/iommu/mtk_iommu_v1.c
index ca581ff1c769..c2ecbff6592c 100644
--- a/drivers/iommu/mtk_iommu_v1.c
+++ b/drivers/iommu/mtk_iommu_v1.c
@@ -578,6 +578,7 @@ static int mtk_iommu_v1_hw_init(const struct mtk_iommu_v1_data *data)
 }
 
 static const struct iommu_ops mtk_iommu_v1_ops = {
+	.broken_unmanaged_domain = true,
 	.domain_alloc	= mtk_iommu_v1_domain_alloc,
 	.probe_device	= mtk_iommu_v1_probe_device,
 	.probe_finalize = mtk_iommu_v1_probe_finalize,
diff --git a/drivers/iommu/omap-iommu.c b/drivers/iommu/omap-iommu.c
index 2fd7702c6709..17ed392b9f63 100644
--- a/drivers/iommu/omap-iommu.c
+++ b/drivers/iommu/omap-iommu.c
@@ -1733,6 +1733,7 @@ static struct iommu_group *omap_iommu_device_group(struct device *dev)
 }
 
 static const struct iommu_ops omap_iommu_ops = {
+	.broken_unmanaged_domain = true,
 	.domain_alloc	= omap_iommu_domain_alloc,
 	.probe_device	= omap_iommu_probe_device,
 	.release_device	= omap_iommu_release_device,
diff --git a/drivers/iommu/tegra-gart.c b/drivers/iommu/tegra-gart.c
index ed53279d1106..9af56d2ec6c1 100644
--- a/drivers/iommu/tegra-gart.c
+++ b/drivers/iommu/tegra-gart.c
@@ -267,6 +267,7 @@ static void gart_iommu_sync(struct iommu_domain *domain,
 }
 
 static const struct iommu_ops gart_iommu_ops = {
+	.broken_unmanaged_domain = true,
 	.domain_alloc	= gart_iommu_domain_alloc,
 	.probe_device	= gart_iommu_probe_device,
 	.device_group	= generic_device_group,
diff --git a/drivers/iommu/tegra-smmu.c b/drivers/iommu/tegra-smmu.c
index 5b1af40221ec..d1e4c4825d74 100644
--- a/drivers/iommu/tegra-smmu.c
+++ b/drivers/iommu/tegra-smmu.c
@@ -962,6 +962,7 @@ static int tegra_smmu_of_xlate(struct device *dev,
 }
 
 static const struct iommu_ops tegra_smmu_ops = {
+	.broken_unmanaged_domain = true,
 	.domain_alloc = tegra_smmu_domain_alloc,
 	.probe_device = tegra_smmu_probe_device,
 	.device_group = tegra_smmu_device_group,
diff --git a/include/linux/iommu.h b/include/linux/iommu.h
index 46e1347bfa22..919a5dbad75b 100644
--- a/include/linux/iommu.h
+++ b/include/linux/iommu.h
@@ -245,6 +245,10 @@ struct iommu_iotlb_gather {
  *                    pasid, so that any DMA transactions with this pasid
  *                    will be blocked by the hardware.
  * @pgsize_bitmap: bitmap of all possible supported page sizes
+ * @broken_unmanaged_domain: IOMMU_DOMAIN_UNMANAGED is not fully functional; the
+ *                           driver does not really support iommu_map/unmap, but
+ *                           uses UNMANAGED domains for the IOMMU API, called by
+ *                           other SOC drivers.
  * @owner: Driver module providing these ops
  */
 struct iommu_ops {
@@ -277,6 +281,7 @@ struct iommu_ops {
 
 	const struct iommu_domain_ops *default_domain_ops;
 	unsigned long pgsize_bitmap;
+	bool broken_unmanaged_domain;
 	struct module *owner;
 };
 
@@ -455,6 +460,7 @@ static inline const struct iommu_ops *dev_iommu_ops(struct device *dev)
 extern int bus_iommu_probe(struct bus_type *bus);
 extern bool iommu_present(struct bus_type *bus);
 extern bool device_iommu_capable(struct device *dev, enum iommu_cap cap);
+extern bool device_iommu_unmanaged_supported(struct device *dev);
 extern struct iommu_domain *iommu_domain_alloc(struct bus_type *bus);
 extern struct iommu_group *iommu_group_get_by_id(int id);
 extern void iommu_domain_free(struct iommu_domain *domain);
@@ -742,6 +748,11 @@ static inline bool device_iommu_capable(struct device *dev, enum iommu_cap cap)
 	return false;
 }
 
+static inline bool device_iommu_unmanaged_supported(struct device *dev)
+{
+	return false;
+}
+
 static inline struct iommu_domain *iommu_domain_alloc(struct bus_type *bus)
 {
 	return NULL;
-- 
2.39.1

