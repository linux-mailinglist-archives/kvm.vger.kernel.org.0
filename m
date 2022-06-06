Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4467B53E318
	for <lists+kvm@lfdr.de>; Mon,  6 Jun 2022 10:55:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229999AbiFFGUW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 6 Jun 2022 02:20:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57922 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229892AbiFFGUE (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 6 Jun 2022 02:20:04 -0400
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2079.outbound.protection.outlook.com [40.107.244.79])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BF09B21E10;
        Sun,  5 Jun 2022 23:20:00 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=X+yoRHNb6Y1lEvdgXIT9mBtUUih+T/nOGdQWZqlrZW+S32JOgQ+kDuTaqPkvtBJ2Pyz/0zXIQFr+OnWGs04qYtlO6lwa8BogdZ8sj4ggGDrlwTh0ggBzOKx7F9uFvLbdaj/TO+p4pZ0LXZv26cpq8mbJS87D8kmcn0Xohyud85rBqN0CTWEP/nO2KKXxT53H38xumSPBb57jgCeGMyzh5qLvv3PGS2k/KybyZJL0cNPCq+UE16SvboJ6XBchRYES4l+tKvjDAPy0mk1booqplvPfsM91ix8YnT47vRdFVEUgD9t6yRqq8td1vWCDTEyBHRdxkxWtjFWxbprRab1Wbw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=2HFnWkjNuwvFTLEgfy+LKH/9Hv7pxkxUGW+YelLbjpw=;
 b=hEix5cl+XEjem40NGjgpi+hqXZuQ1TJ1ggiMz27QLers+moR2wbV5oGnZp5HPKK86CWP4pzUWkbuvFp3OSnrsdBSu3/T6wrgN7DJAWpNuAP4xOHcpdH3aPFUg77rmkpCjd4SNKCqV3vRXTBlcz8gvQ/PgqdpmS0qu5xS+M4ISqphA8ik3Zn0hkpB2KpSTJGRqrg9jT4bfKy5PmN39pE0mPstPRyF51v6sBR6a1UkjkkgBEiqi09LrFAH8A/k0RT9+eAwE1ESCSKHrWh+U0hq5T6XGjwGAcXYi2OiHVMJVLwNwajoSMhqqW70gNWos/iYXPsAiYXQNSAbvB2F1B8CdQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.236) smtp.rcpttodomain=samsung.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2HFnWkjNuwvFTLEgfy+LKH/9Hv7pxkxUGW+YelLbjpw=;
 b=kOZecp2VgSMnxZJPkTybdYN0FEMMc8ATEptt1vesrv+R5WdPagFtWCAWO6shYs8EvCXiSuGg+Y7S+WeHQZAnnQAz7WzYHgUPOIpTZ3R9lyZp+TM3+WxuQmDWoOS0QS/VGrSkv+XRci9m5/hv44xdrdLDsHaC+T9tFqNBL6PgMPuH0RYt9X1JFaGTThuhn1z8B2rkri7MSD3ahVhYt03WIcWQIISqImP/NNBDXGFcKa7QHOMOhjXG8z4yAy6j7pJZnyg6xZ8KtD9o298qiKIn6GIP3hyeWYLiRKjJ4tx47jpb3xqSfLznjrDRSoUGhbcY57m7oNJO0194FZt/FKhAiQ==
Received: from MW4PR03CA0009.namprd03.prod.outlook.com (2603:10b6:303:8f::14)
 by BN6PR12MB1444.namprd12.prod.outlook.com (2603:10b6:405:10::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5314.12; Mon, 6 Jun
 2022 06:19:58 +0000
Received: from CO1NAM11FT060.eop-nam11.prod.protection.outlook.com
 (2603:10b6:303:8f:cafe::69) by MW4PR03CA0009.outlook.office365.com
 (2603:10b6:303:8f::14) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5314.12 via Frontend
 Transport; Mon, 6 Jun 2022 06:19:57 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.236)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.236 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.236; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (12.22.5.236) by
 CO1NAM11FT060.mail.protection.outlook.com (10.13.175.132) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.5314.12 via Frontend Transport; Mon, 6 Jun 2022 06:19:57 +0000
Received: from rnnvmail205.nvidia.com (10.129.68.10) by DRHQMAIL109.nvidia.com
 (10.27.9.19) with Microsoft SMTP Server (TLS) id 15.0.1497.32; Mon, 6 Jun
 2022 06:19:57 +0000
Received: from rnnvmail205.nvidia.com (10.129.68.10) by rnnvmail205.nvidia.com
 (10.129.68.10) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.22; Sun, 5 Jun 2022
 23:19:56 -0700
Received: from Asurada-Nvidia.nvidia.com (10.127.8.12) by mail.nvidia.com
 (10.129.68.10) with Microsoft SMTP Server id 15.2.986.22 via Frontend
 Transport; Sun, 5 Jun 2022 23:19:54 -0700
From:   Nicolin Chen <nicolinc@nvidia.com>
To:     <jgg@nvidia.com>, <joro@8bytes.org>, <will@kernel.org>,
        <marcan@marcan.st>, <sven@svenpeter.dev>, <robin.murphy@arm.com>,
        <robdclark@gmail.com>, <m.szyprowski@samsung.com>,
        <krzysztof.kozlowski@linaro.org>, <baolu.lu@linux.intel.com>,
        <agross@kernel.org>, <bjorn.andersson@linaro.org>,
        <matthias.bgg@gmail.com>, <heiko@sntech.de>, <orsonzhai@gmail.com>,
        <baolin.wang7@gmail.com>, <zhang.lyra@gmail.com>, <wens@csie.org>,
        <jernej.skrabec@gmail.com>, <samuel@sholland.org>,
        <jean-philippe@linaro.org>, <alex.williamson@redhat.com>
CC:     <suravee.suthikulpanit@amd.com>, <alyssa@rosenzweig.io>,
        <alim.akhtar@samsung.com>, <dwmw2@infradead.org>,
        <yong.wu@mediatek.com>, <mjrosato@linux.ibm.com>,
        <gerald.schaefer@linux.ibm.com>, <thierry.reding@gmail.com>,
        <vdumpa@nvidia.com>, <jonathanh@nvidia.com>, <cohuck@redhat.com>,
        <iommu@lists.linux-foundation.org>, <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-arm-msm@vger.kernel.org>,
        <linux-samsung-soc@vger.kernel.org>,
        <linux-mediatek@lists.infradead.org>,
        <linux-rockchip@lists.infradead.org>, <linux-s390@vger.kernel.org>,
        <linux-sunxi@lists.linux.dev>, <linux-tegra@vger.kernel.org>,
        <virtualization@lists.linux-foundation.org>, <kvm@vger.kernel.org>
Subject: [PATCH 2/5] iommu: Ensure device has the same iommu_ops as the domain
Date:   Sun, 5 Jun 2022 23:19:24 -0700
Message-ID: <20220606061927.26049-3-nicolinc@nvidia.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20220606061927.26049-1-nicolinc@nvidia.com>
References: <20220606061927.26049-1-nicolinc@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: ddeb1635-b86f-4718-31d7-08da47849471
X-MS-TrafficTypeDiagnostic: BN6PR12MB1444:EE_
X-Microsoft-Antispam-PRVS: <BN6PR12MB1444CBF0CE59B3E7819C48F7ABA29@BN6PR12MB1444.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: RzKbDRKbCjtm3qbUSXwAfIVXaa3RZDSCG+LNftj4L/YNt+gsReSy+IS6IWAyvLwy/BG+61AxvHD0HcnynJOW/vhoB3kv3yqRzqpA659jYeVk1IvSBg+iJsrlINHjMuiHq2AtkZHWXdgKgwqeoDN/7g6t9ugWpS/jN7nuloyGVgGFJo0SitmL4HG+Fncz6KbMSGq1FNEBYA/F0NkUTat7usEQHpiBVM4BU2WVgp+zFyPeW1043DrKkXxGQIigkYwpubnTZni6/kinl9P7gaa7Hf/j0DbmuMrlVyTmwIzDffQOlDw5/bG4GgDGUELtdfJkmWJtRQLz2bTTsw7jrJKoPhzxSqqPiwnJ8PIy4lYU41+ZgGoj0Z8nQo8JxNgoolwcCz5Xf4rjFI1aTBG41hKdcJhw1UTzCC5y+4d9KvQWkaLb7Vd6CH4VwssAqUjLYQhJUubw2NKJs8NzW3glj0DwD0I9XsDp2hJl/PR4ZKY99RHjmrRTNqpV+U6sTncUvV73GZccDuHourXOhOI6Kuxf81pN7RUThc0PtVnaoShi46ebgfSnLi/XndIxoS1GLqb1gD6JPsZ1sYibH1D+evH09NFtxHNGcPZUx89C7s5Iftn483fc6b/bKBb4eZfZHT3jbi04XRTb+Fca4XM7faw5EyGXQtQNt18S8iUzb3p60y5xoDrmY5NTmURJUOzZZSkkfnQ/lPWnb9nN11ZmBj9J9OaQlyCIVuD1JC0kljYc3Wxz8C83Fl4Wdk/30261UAnLCjNHPpQOJnDRwBFs3JqY5w==
X-Forefront-Antispam-Report: CIP:12.22.5.236;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(13230001)(4636009)(40470700004)(46966006)(36840700001)(86362001)(4326008)(5660300002)(8676002)(40460700003)(6666004)(8936002)(7416002)(70586007)(70206006)(7696005)(356005)(36860700001)(30864003)(921005)(1076003)(316002)(7406005)(54906003)(110136005)(82310400005)(83380400001)(26005)(186003)(2906002)(36756003)(508600001)(2616005)(81166007)(47076005)(336012)(426003)(36900700001)(2101003)(83996005);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Jun 2022 06:19:57.6641
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: ddeb1635-b86f-4718-31d7-08da47849471
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.236];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT060.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN6PR12MB1444
X-Spam-Status: No, score=-3.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The core code should not call an iommu driver op with a struct device
parameter unless it knows that the dev_iommu_priv_get() for that struct
device was setup by the same driver. Otherwise in a mixed driver system
the iommu_priv could be casted to the wrong type.

Store the iommu_ops pointer in the iommu_domain and use it as a check to
validate that the struct device is correct before invoking any domain op
that accepts a struct device.

This allows removing the check of the domain op equality in VFIO.

Co-developed-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Nicolin Chen <nicolinc@nvidia.com>
---
 drivers/iommu/amd/iommu.c                   | 1 +
 drivers/iommu/apple-dart.c                  | 1 +
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c | 1 +
 drivers/iommu/arm/arm-smmu/arm-smmu.c       | 1 +
 drivers/iommu/arm/arm-smmu/qcom_iommu.c     | 1 +
 drivers/iommu/exynos-iommu.c                | 1 +
 drivers/iommu/fsl_pamu_domain.c             | 1 +
 drivers/iommu/intel/iommu.c                 | 1 +
 drivers/iommu/iommu.c                       | 4 ++++
 drivers/iommu/ipmmu-vmsa.c                  | 1 +
 drivers/iommu/msm_iommu.c                   | 1 +
 drivers/iommu/mtk_iommu.c                   | 1 +
 drivers/iommu/mtk_iommu_v1.c                | 1 +
 drivers/iommu/omap-iommu.c                  | 1 +
 drivers/iommu/rockchip-iommu.c              | 1 +
 drivers/iommu/s390-iommu.c                  | 1 +
 drivers/iommu/sprd-iommu.c                  | 1 +
 drivers/iommu/sun50i-iommu.c                | 1 +
 drivers/iommu/tegra-gart.c                  | 1 +
 drivers/iommu/tegra-smmu.c                  | 1 +
 drivers/iommu/virtio-iommu.c                | 1 +
 include/linux/iommu.h                       | 2 ++
 22 files changed, 26 insertions(+)

diff --git a/drivers/iommu/amd/iommu.c b/drivers/iommu/amd/iommu.c
index ad499658a6b6..679f7a265013 100644
--- a/drivers/iommu/amd/iommu.c
+++ b/drivers/iommu/amd/iommu.c
@@ -2285,6 +2285,7 @@ const struct iommu_ops amd_iommu_ops = {
 	.pgsize_bitmap	= AMD_IOMMU_PGSIZES,
 	.def_domain_type = amd_iommu_def_domain_type,
 	.default_domain_ops = &(const struct iommu_domain_ops) {
+		.iommu_ops	= &amd_iommu_ops,
 		.attach_dev	= amd_iommu_attach_device,
 		.detach_dev	= amd_iommu_detach_device,
 		.map		= amd_iommu_map,
diff --git a/drivers/iommu/apple-dart.c b/drivers/iommu/apple-dart.c
index e58dc310afd7..3d36d9a12aa7 100644
--- a/drivers/iommu/apple-dart.c
+++ b/drivers/iommu/apple-dart.c
@@ -775,6 +775,7 @@ static const struct iommu_ops apple_dart_iommu_ops = {
 	.pgsize_bitmap = -1UL, /* Restricted during dart probe */
 	.owner = THIS_MODULE,
 	.default_domain_ops = &(const struct iommu_domain_ops) {
+		.iommu_ops	= &apple_dart_iommu_ops,
 		.attach_dev	= apple_dart_attach_dev,
 		.detach_dev	= apple_dart_detach_dev,
 		.map_pages	= apple_dart_map_pages,
diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
index 6c393cd84925..471ceb60427c 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
@@ -2859,6 +2859,7 @@ static struct iommu_ops arm_smmu_ops = {
 	.pgsize_bitmap		= -1UL, /* Restricted during device attach */
 	.owner			= THIS_MODULE,
 	.default_domain_ops = &(const struct iommu_domain_ops) {
+		.iommu_ops		= &arm_smmu_ops,
 		.attach_dev		= arm_smmu_attach_dev,
 		.map_pages		= arm_smmu_map_pages,
 		.unmap_pages		= arm_smmu_unmap_pages,
diff --git a/drivers/iommu/arm/arm-smmu/arm-smmu.c b/drivers/iommu/arm/arm-smmu/arm-smmu.c
index 2ed3594f384e..52c2589a4deb 100644
--- a/drivers/iommu/arm/arm-smmu/arm-smmu.c
+++ b/drivers/iommu/arm/arm-smmu/arm-smmu.c
@@ -1597,6 +1597,7 @@ static struct iommu_ops arm_smmu_ops = {
 	.pgsize_bitmap		= -1UL, /* Restricted during device attach */
 	.owner			= THIS_MODULE,
 	.default_domain_ops = &(const struct iommu_domain_ops) {
+		.iommu_ops		= &arm_smmu_ops,
 		.attach_dev		= arm_smmu_attach_dev,
 		.map_pages		= arm_smmu_map_pages,
 		.unmap_pages		= arm_smmu_unmap_pages,
diff --git a/drivers/iommu/arm/arm-smmu/qcom_iommu.c b/drivers/iommu/arm/arm-smmu/qcom_iommu.c
index a8b63b855ffb..8806a621f81e 100644
--- a/drivers/iommu/arm/arm-smmu/qcom_iommu.c
+++ b/drivers/iommu/arm/arm-smmu/qcom_iommu.c
@@ -596,6 +596,7 @@ static const struct iommu_ops qcom_iommu_ops = {
 	.of_xlate	= qcom_iommu_of_xlate,
 	.pgsize_bitmap	= SZ_4K | SZ_64K | SZ_1M | SZ_16M,
 	.default_domain_ops = &(const struct iommu_domain_ops) {
+		.iommu_ops	= &qcom_iommu_ops,
 		.attach_dev	= qcom_iommu_attach_dev,
 		.detach_dev	= qcom_iommu_detach_dev,
 		.map		= qcom_iommu_map,
diff --git a/drivers/iommu/exynos-iommu.c b/drivers/iommu/exynos-iommu.c
index 71f2018e23fe..fa93f94313e3 100644
--- a/drivers/iommu/exynos-iommu.c
+++ b/drivers/iommu/exynos-iommu.c
@@ -1315,6 +1315,7 @@ static const struct iommu_ops exynos_iommu_ops = {
 	.pgsize_bitmap = SECT_SIZE | LPAGE_SIZE | SPAGE_SIZE,
 	.of_xlate = exynos_iommu_of_xlate,
 	.default_domain_ops = &(const struct iommu_domain_ops) {
+		.iommu_ops	= &exynos_iommu_ops,
 		.attach_dev	= exynos_iommu_attach_device,
 		.detach_dev	= exynos_iommu_detach_device,
 		.map		= exynos_iommu_map,
diff --git a/drivers/iommu/fsl_pamu_domain.c b/drivers/iommu/fsl_pamu_domain.c
index 94b4589dc67c..7bdce4168d2c 100644
--- a/drivers/iommu/fsl_pamu_domain.c
+++ b/drivers/iommu/fsl_pamu_domain.c
@@ -458,6 +458,7 @@ static const struct iommu_ops fsl_pamu_ops = {
 	.release_device	= fsl_pamu_release_device,
 	.device_group   = fsl_pamu_device_group,
 	.default_domain_ops = &(const struct iommu_domain_ops) {
+		.iommu_ops	= &fsl_pamu_ops,
 		.attach_dev	= fsl_pamu_attach_device,
 		.detach_dev	= fsl_pamu_detach_device,
 		.iova_to_phys	= fsl_pamu_iova_to_phys,
diff --git a/drivers/iommu/intel/iommu.c b/drivers/iommu/intel/iommu.c
index 0813b119d680..c6022484ca2d 100644
--- a/drivers/iommu/intel/iommu.c
+++ b/drivers/iommu/intel/iommu.c
@@ -4925,6 +4925,7 @@ const struct iommu_ops intel_iommu_ops = {
 	.page_response		= intel_svm_page_response,
 #endif
 	.default_domain_ops = &(const struct iommu_domain_ops) {
+		.iommu_ops		= &intel_iommu_ops,
 		.attach_dev		= intel_iommu_attach_device,
 		.detach_dev		= intel_iommu_detach_device,
 		.map_pages		= intel_iommu_map_pages,
diff --git a/drivers/iommu/iommu.c b/drivers/iommu/iommu.c
index 19cf28d40ebe..8a1f437a51f2 100644
--- a/drivers/iommu/iommu.c
+++ b/drivers/iommu/iommu.c
@@ -1963,6 +1963,10 @@ static int __iommu_attach_device(struct iommu_domain *domain,
 {
 	int ret;
 
+	/* Ensure the device was probe'd onto the same driver as the domain */
+	if (dev->bus->iommu_ops != domain->ops->iommu_ops)
+		return -EMEDIUMTYPE;
+
 	if (unlikely(domain->ops->attach_dev == NULL))
 		return -ENODEV;
 
diff --git a/drivers/iommu/ipmmu-vmsa.c b/drivers/iommu/ipmmu-vmsa.c
index e491e410add5..767b93da5800 100644
--- a/drivers/iommu/ipmmu-vmsa.c
+++ b/drivers/iommu/ipmmu-vmsa.c
@@ -877,6 +877,7 @@ static const struct iommu_ops ipmmu_ops = {
 	.pgsize_bitmap = SZ_1G | SZ_2M | SZ_4K,
 	.of_xlate = ipmmu_of_xlate,
 	.default_domain_ops = &(const struct iommu_domain_ops) {
+		.iommu_ops	= &ipmmu_ops,
 		.attach_dev	= ipmmu_attach_device,
 		.detach_dev	= ipmmu_detach_device,
 		.map		= ipmmu_map,
diff --git a/drivers/iommu/msm_iommu.c b/drivers/iommu/msm_iommu.c
index f09aedfdd462..29f6a6d5691e 100644
--- a/drivers/iommu/msm_iommu.c
+++ b/drivers/iommu/msm_iommu.c
@@ -682,6 +682,7 @@ static struct iommu_ops msm_iommu_ops = {
 	.pgsize_bitmap = MSM_IOMMU_PGSIZES,
 	.of_xlate = qcom_iommu_of_xlate,
 	.default_domain_ops = &(const struct iommu_domain_ops) {
+		.iommu_ops	= &msm_iommu_ops,
 		.attach_dev	= msm_iommu_attach_dev,
 		.detach_dev	= msm_iommu_detach_dev,
 		.map		= msm_iommu_map,
diff --git a/drivers/iommu/mtk_iommu.c b/drivers/iommu/mtk_iommu.c
index bb9dd92c9898..c5c45f65077d 100644
--- a/drivers/iommu/mtk_iommu.c
+++ b/drivers/iommu/mtk_iommu.c
@@ -937,6 +937,7 @@ static const struct iommu_ops mtk_iommu_ops = {
 	.pgsize_bitmap	= SZ_4K | SZ_64K | SZ_1M | SZ_16M,
 	.owner		= THIS_MODULE,
 	.default_domain_ops = &(const struct iommu_domain_ops) {
+		.iommu_ops	= &mtk_iommu_ops,
 		.attach_dev	= mtk_iommu_attach_device,
 		.detach_dev	= mtk_iommu_detach_device,
 		.map		= mtk_iommu_map,
diff --git a/drivers/iommu/mtk_iommu_v1.c b/drivers/iommu/mtk_iommu_v1.c
index e1cb51b9866c..77c53580f730 100644
--- a/drivers/iommu/mtk_iommu_v1.c
+++ b/drivers/iommu/mtk_iommu_v1.c
@@ -594,6 +594,7 @@ static const struct iommu_ops mtk_iommu_v1_ops = {
 	.pgsize_bitmap	= ~0UL << MT2701_IOMMU_PAGE_SHIFT,
 	.owner          = THIS_MODULE,
 	.default_domain_ops = &(const struct iommu_domain_ops) {
+		.iommu_ops	= &mtk_iommu_v1_ops,
 		.attach_dev	= mtk_iommu_v1_attach_device,
 		.detach_dev	= mtk_iommu_v1_detach_device,
 		.map		= mtk_iommu_v1_map,
diff --git a/drivers/iommu/omap-iommu.c b/drivers/iommu/omap-iommu.c
index bbc6c4cd7aae..a0bf85ccebcd 100644
--- a/drivers/iommu/omap-iommu.c
+++ b/drivers/iommu/omap-iommu.c
@@ -1739,6 +1739,7 @@ static const struct iommu_ops omap_iommu_ops = {
 	.device_group	= omap_iommu_device_group,
 	.pgsize_bitmap	= OMAP_IOMMU_PGSIZES,
 	.default_domain_ops = &(const struct iommu_domain_ops) {
+		.iommu_ops	= &omap_iommu_ops,
 		.attach_dev	= omap_iommu_attach_dev,
 		.detach_dev	= omap_iommu_detach_dev,
 		.map		= omap_iommu_map,
diff --git a/drivers/iommu/rockchip-iommu.c b/drivers/iommu/rockchip-iommu.c
index ab57c4b8fade..5f5387e902e0 100644
--- a/drivers/iommu/rockchip-iommu.c
+++ b/drivers/iommu/rockchip-iommu.c
@@ -1193,6 +1193,7 @@ static const struct iommu_ops rk_iommu_ops = {
 	.pgsize_bitmap = RK_IOMMU_PGSIZE_BITMAP,
 	.of_xlate = rk_iommu_of_xlate,
 	.default_domain_ops = &(const struct iommu_domain_ops) {
+		.iommu_ops	= &rk_iommu_ops,
 		.attach_dev	= rk_iommu_attach_device,
 		.detach_dev	= rk_iommu_detach_device,
 		.map		= rk_iommu_map,
diff --git a/drivers/iommu/s390-iommu.c b/drivers/iommu/s390-iommu.c
index c898bcbbce11..62e6d152b0a0 100644
--- a/drivers/iommu/s390-iommu.c
+++ b/drivers/iommu/s390-iommu.c
@@ -377,6 +377,7 @@ static const struct iommu_ops s390_iommu_ops = {
 	.device_group = generic_device_group,
 	.pgsize_bitmap = S390_IOMMU_PGSIZES,
 	.default_domain_ops = &(const struct iommu_domain_ops) {
+		.iommu_ops	= &s390_iommu_ops,
 		.attach_dev	= s390_iommu_attach_device,
 		.detach_dev	= s390_iommu_detach_device,
 		.map		= s390_iommu_map,
diff --git a/drivers/iommu/sprd-iommu.c b/drivers/iommu/sprd-iommu.c
index bd409bab6286..6e8ca34d6a00 100644
--- a/drivers/iommu/sprd-iommu.c
+++ b/drivers/iommu/sprd-iommu.c
@@ -423,6 +423,7 @@ static const struct iommu_ops sprd_iommu_ops = {
 	.pgsize_bitmap	= ~0UL << SPRD_IOMMU_PAGE_SHIFT,
 	.owner		= THIS_MODULE,
 	.default_domain_ops = &(const struct iommu_domain_ops) {
+		.iommu_ops	= &sprd_iommu_ops,
 		.attach_dev	= sprd_iommu_attach_device,
 		.detach_dev	= sprd_iommu_detach_device,
 		.map		= sprd_iommu_map,
diff --git a/drivers/iommu/sun50i-iommu.c b/drivers/iommu/sun50i-iommu.c
index c54ab477b8fd..560cff8e0f04 100644
--- a/drivers/iommu/sun50i-iommu.c
+++ b/drivers/iommu/sun50i-iommu.c
@@ -766,6 +766,7 @@ static const struct iommu_ops sun50i_iommu_ops = {
 	.probe_device	= sun50i_iommu_probe_device,
 	.release_device	= sun50i_iommu_release_device,
 	.default_domain_ops = &(const struct iommu_domain_ops) {
+		.iommu_ops	= &sun50i_iommu_ops,
 		.attach_dev	= sun50i_iommu_attach_device,
 		.detach_dev	= sun50i_iommu_detach_device,
 		.flush_iotlb_all = sun50i_iommu_flush_iotlb_all,
diff --git a/drivers/iommu/tegra-gart.c b/drivers/iommu/tegra-gart.c
index a6700a40a6f8..cd4553611cc9 100644
--- a/drivers/iommu/tegra-gart.c
+++ b/drivers/iommu/tegra-gart.c
@@ -278,6 +278,7 @@ static const struct iommu_ops gart_iommu_ops = {
 	.pgsize_bitmap	= GART_IOMMU_PGSIZES,
 	.of_xlate	= gart_iommu_of_xlate,
 	.default_domain_ops = &(const struct iommu_domain_ops) {
+		.iommu_ops	= &gart_iommu_ops,
 		.attach_dev	= gart_iommu_attach_dev,
 		.detach_dev	= gart_iommu_detach_dev,
 		.map		= gart_iommu_map,
diff --git a/drivers/iommu/tegra-smmu.c b/drivers/iommu/tegra-smmu.c
index 2f2b12033618..67c101d1ad66 100644
--- a/drivers/iommu/tegra-smmu.c
+++ b/drivers/iommu/tegra-smmu.c
@@ -971,6 +971,7 @@ static const struct iommu_ops tegra_smmu_ops = {
 	.of_xlate = tegra_smmu_of_xlate,
 	.pgsize_bitmap = SZ_4K,
 	.default_domain_ops = &(const struct iommu_domain_ops) {
+		.iommu_ops	= &tegra_smmu_ops,
 		.attach_dev	= tegra_smmu_attach_dev,
 		.detach_dev	= tegra_smmu_detach_dev,
 		.map		= tegra_smmu_map,
diff --git a/drivers/iommu/virtio-iommu.c b/drivers/iommu/virtio-iommu.c
index e3b812d8fa96..703d87922786 100644
--- a/drivers/iommu/virtio-iommu.c
+++ b/drivers/iommu/virtio-iommu.c
@@ -1017,6 +1017,7 @@ static struct iommu_ops viommu_ops = {
 	.of_xlate		= viommu_of_xlate,
 	.owner			= THIS_MODULE,
 	.default_domain_ops = &(const struct iommu_domain_ops) {
+		.iommu_ops		= &viommu_ops,
 		.attach_dev		= viommu_attach_dev,
 		.map			= viommu_map,
 		.unmap			= viommu_unmap,
diff --git a/include/linux/iommu.h b/include/linux/iommu.h
index 5e1afe169549..77deaf4fc7f8 100644
--- a/include/linux/iommu.h
+++ b/include/linux/iommu.h
@@ -261,6 +261,7 @@ struct iommu_ops {
 
 /**
  * struct iommu_domain_ops - domain specific operations
+ * @iommu_ops: Pointer to the ops associated with compatible devices
  * @attach_dev: attach an iommu domain to a device
  * @detach_dev: detach an iommu domain from a device
  * @map: map a physically contiguous memory region to an iommu domain
@@ -281,6 +282,7 @@ struct iommu_ops {
  * @free: Release the domain after use.
  */
 struct iommu_domain_ops {
+	const struct iommu_ops *iommu_ops;
 	int (*attach_dev)(struct iommu_domain *domain, struct device *dev);
 	void (*detach_dev)(struct iommu_domain *domain, struct device *dev);
 
-- 
2.17.1

