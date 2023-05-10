Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 397A76FD44D
	for <lists+kvm@lfdr.de>; Wed, 10 May 2023 05:34:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229734AbjEJDeZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 9 May 2023 23:34:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38276 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229564AbjEJDeX (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 9 May 2023 23:34:23 -0400
Received: from NAM02-DM3-obe.outbound.protection.outlook.com (mail-dm3nam02on2079.outbound.protection.outlook.com [40.107.95.79])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A13C91FF3;
        Tue,  9 May 2023 20:34:21 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gWonM3qM/FXWfx7IxJmXr8wChJT3NrSVdNx/Jw/EJalWGCtjZkwT5yuViSJ8HmZW4gtBWzVxla01cgd+Xra/q/cLW8OcNRTDqvRCA5gH+HAmioelL/XPL5BNmVHYqM41MPS0AFLcYYG/E40y1V4UFJ544xXTCCp6PwJciyHQy4rwvZZFIAzrLVb5J6gI/gwLf3hWN8Ub9k6OAvpBdJ1baGeWEWZORvCVHlJjU6ce0jK7SWq0dW7majMP05tVfLvzgNyk0/TX/V86p4l7HfKr5nA0En8ckYEeoQzg77er924vXrlf/Dpa6/oADf8RMcWCyEMB0X5hEhoq7MlDrwptsg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=hSbSlCr03XeDRoHeAnKC4x+Qxv/DX5Kz0F0kI7nfSzg=;
 b=L/SAx1HcQ3aPGIgz+ufgvI03FygA1QSZxND5doj+rNu3IjeA8qFp9MCsWXkzehT36/Q308AI8XgQlvF+UMVnExWBGB15z05I1ydSLz8dTOmFGYQFxrsRVSSpwDGV10Fca5wUAtIdszwlseT2fS6ipBVW1c4tVkbLyRvQUA8IUHf0vH99u76wxdsEH+ZnuCKfCSm8T8y1TSTKM0N66XQ784oeUcfcq1C9ckVSVvX7ERp81RjrU8njOTxSEATF8ENjtumcCNVCx1apPjblkqPqo5GgYiz7V+JTCtkbeqEKCTNcbzk26bdsoRDBQNJt5S/E41IdBSeb4GIjeHOjYZYt2A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=arm.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hSbSlCr03XeDRoHeAnKC4x+Qxv/DX5Kz0F0kI7nfSzg=;
 b=F5BZhaZOLLXyAznV5M3eRAnMWf6TiQWAXn3GJnyj+3mgUPwKYQaohbtO99A/ddvctRBOs9wh7NtakCCi171Odkhid33vfulb90h90g7Ql0JeP4Ux4kaE42rm/aXk1R1ZCDs6QTlKslGMLHfJ8oeb3rOfknLLMb/l6yWnIquvgGNbu9XeN1k6EDMzt8zwLC4ChiVHFVG1WcXdSnL4DzZfVaLGZNkXfG00CIpMD5FvGwh/Plkox+bsnyXmIF2sw18u5ZnI2XSznr5qtaeY8EohTq33B/0pPUfjPGq4sJvUWIYgjy+gFV9+WdphXkKYSoorReWZ177awX43s8Am2SI+VA==
Received: from BN9PR03CA0359.namprd03.prod.outlook.com (2603:10b6:408:f6::34)
 by CY8PR12MB7100.namprd12.prod.outlook.com (2603:10b6:930:60::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6340.20; Wed, 10 May
 2023 03:34:19 +0000
Received: from BN8NAM11FT065.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:f6:cafe::7c) by BN9PR03CA0359.outlook.office365.com
 (2603:10b6:408:f6::34) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6363.33 via Frontend
 Transport; Wed, 10 May 2023 03:34:19 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.161)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 BN8NAM11FT065.mail.protection.outlook.com (10.13.177.63) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6387.18 via Frontend Transport; Wed, 10 May 2023 03:34:19 +0000
Received: from rnnvmail202.nvidia.com (10.129.68.7) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.5; Tue, 9 May 2023
 20:34:10 -0700
Received: from rnnvmail204.nvidia.com (10.129.68.6) by rnnvmail202.nvidia.com
 (10.129.68.7) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.37; Tue, 9 May 2023
 20:34:09 -0700
Received: from Asurada-Nvidia.nvidia.com (10.127.8.10) by mail.nvidia.com
 (10.129.68.6) with Microsoft SMTP Server id 15.2.986.37 via Frontend
 Transport; Tue, 9 May 2023 20:34:08 -0700
From:   Nicolin Chen <nicolinc@nvidia.com>
To:     <jgg@nvidia.com>, <robin.murphy@arm.com>, <will@kernel.org>
CC:     <eric.auger@redhat.com>, <kevin.tian@intel.com>,
        <baolu.lu@linux.intel.com>, <joro@8bytes.org>,
        <shameerali.kolothum.thodi@huawei.com>, <jean-philippe@linaro.org>,
        <linux-arm-kernel@lists.infradead.org>, <iommu@lists.linux.dev>,
        <linux-kernel@vger.kernel.org>, <kvm@vger.kernel.org>,
        <alex.williamson@redhat.com>, <yi.l.liu@intel.com>
Subject: [PATCH v2 01/17] vfio: Remove VFIO_TYPE1_NESTING_IOMMU
Date:   Tue, 9 May 2023 20:33:21 -0700
Message-ID: <a0ca90a794e68a870457aa1a9a4329c1cd2e71c6.1683688960.git.nicolinc@nvidia.com>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <cover.1683688960.git.nicolinc@nvidia.com>
References: <cover.1683688960.git.nicolinc@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN8NAM11FT065:EE_|CY8PR12MB7100:EE_
X-MS-Office365-Filtering-Correlation-Id: b9537d55-329c-45f6-213e-08db51077032
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 3Iav346U5iebInO33CVa4wASxQ3gObKo/IPk2OGOdYloceIt7kRK8ThsWZe5wTBceTvr6/ay6j0QYMPGkDe/jPgTLDToEOYKfwvFpYE/pkPm27iV9K1Dt3SWmsES685yW9MMhVTpEtRy/Z3M0V1fWe1OoTYu6mkJ1hzKK+T5jJuUmuo12jiX4Vbr5YCA1zqf06l1MWdTWUuAN2x8xPfcX9qkRdJEvRtCGkKvawI2T4aio1+9jwp9Sh/4fW5TJGJ74uupvTNNS0+MEym0qX+sVmvl8esQU3cr9Uo/nwPmGLb6MWXl4uFPdcGfmQeCcWIoA5w0xWq70FckGEmgoONyt+RMwNOOfubX+E7Yichnmdt9wpQvVRs3ZPWWAnb9fc2ca3D9Ywg/wvm/YNV1coQ0IWcg9hyxXMDSNKHscY8SA3YBN6zt0zzD5XFtv0hnPIY1uUj4u6Wq2g+ECe2uJ+sTVOe6dyny1wwfz0voAalhl/sHW7WBjbYIoVihuHWAtMvUY+lRJsYyNVE5sZheIePaKYdTX1ljrUy/xFRcHeIEt0mPcx3V1DvD7veQ9RxCuQ1ZUDy3QX2z7kEaWqMscpr1wyoyUoXfwwi1HbhsxRT8R2gkpHAR+Vr3rkL5GaU0O8T16FxxwVtiw6bgc0wsiYxE44ILk2g2Wxon4xHDrc/u7bkMXj3hlcF91bzn33BRTZyUsJ1hoSiRAi3HiOPwZjaAQdMZ5NigGkxlTL/mD9JLgB4GjqwvQ2w3shb0eSjbDOqT
X-Forefront-Antispam-Report: CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230028)(4636009)(376002)(396003)(346002)(39860400002)(136003)(451199021)(40470700004)(46966006)(36840700001)(4326008)(86362001)(36756003)(82310400005)(2906002)(70206006)(478600001)(7416002)(40480700001)(47076005)(83380400001)(336012)(426003)(6666004)(7696005)(186003)(966005)(316002)(26005)(110136005)(5660300002)(70586007)(40460700003)(54906003)(8936002)(356005)(2616005)(41300700001)(8676002)(82740400003)(7636003)(36860700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 May 2023 03:34:19.0136
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: b9537d55-329c-45f6-213e-08db51077032
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT065.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR12MB7100
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

From: Jason Gunthorpe <jgg@nvidia.com>

This control causes the ARM SMMU drivers to choose a stage 2
implementation for the IO pagetable (vs the stage 1 usual default),
however this choice has no visible impact to the VFIO user. Further qemu
never implemented this and no other userspace user is known.

The original description in commit f5c9ecebaf2a ("vfio/iommu_type1: add
new VFIO_TYPE1_NESTING_IOMMU IOMMU type") suggested this was to "provide
SMMU translation services to the guest operating system" however the rest
of the API to set the guest table pointer for the stage 1 was never
completed, or at least never upstreamed, rendering this part useless dead
code.

Since the current patches to enable nested translation, aka userspace page
tables, rely on iommufd and will not use the enable_nesting()
iommu_domain_op, remove this infrastructure. However, don't cut too deep
into the SMMU drivers for now expecting the iommufd work to pick it up -
we still need to create S2 IO page tables.

Remove VFIO_TYPE1_NESTING_IOMMU and everything under it including the
enable_nesting iommu_domain_op.

Just in-case there is some userspace using this continue to treat
requesting it as a NOP, but do not advertise support any more.

Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Nicolin Chen <nicolinc@nvidia.com>
---
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c | 16 ----------------
 drivers/iommu/arm/arm-smmu/arm-smmu.c       | 16 ----------------
 drivers/iommu/iommu.c                       | 10 ----------
 drivers/iommu/iommufd/vfio_compat.c         |  7 +------
 drivers/vfio/vfio_iommu_type1.c             | 12 +-----------
 include/linux/iommu.h                       |  3 ---
 include/uapi/linux/vfio.h                   |  2 +-
 7 files changed, 3 insertions(+), 63 deletions(-)

diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
index 3fd83fb75722..2c53849cae30 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
@@ -2740,21 +2740,6 @@ static struct iommu_group *arm_smmu_device_group(struct device *dev)
 	return group;
 }
 
-static int arm_smmu_enable_nesting(struct iommu_domain *domain)
-{
-	struct arm_smmu_domain *smmu_domain = to_smmu_domain(domain);
-	int ret = 0;
-
-	mutex_lock(&smmu_domain->init_mutex);
-	if (smmu_domain->smmu)
-		ret = -EPERM;
-	else
-		smmu_domain->stage = ARM_SMMU_DOMAIN_NESTED;
-	mutex_unlock(&smmu_domain->init_mutex);
-
-	return ret;
-}
-
 static int arm_smmu_of_xlate(struct device *dev, struct of_phandle_args *args)
 {
 	return iommu_fwspec_add_ids(dev, args->args, 1);
@@ -2881,7 +2866,6 @@ static struct iommu_ops arm_smmu_ops = {
 		.flush_iotlb_all	= arm_smmu_flush_iotlb_all,
 		.iotlb_sync		= arm_smmu_iotlb_sync,
 		.iova_to_phys		= arm_smmu_iova_to_phys,
-		.enable_nesting		= arm_smmu_enable_nesting,
 		.free			= arm_smmu_domain_free,
 	}
 };
diff --git a/drivers/iommu/arm/arm-smmu/arm-smmu.c b/drivers/iommu/arm/arm-smmu/arm-smmu.c
index 6e0813b26fb6..97d3fbcbd7f3 100644
--- a/drivers/iommu/arm/arm-smmu/arm-smmu.c
+++ b/drivers/iommu/arm/arm-smmu/arm-smmu.c
@@ -1484,21 +1484,6 @@ static struct iommu_group *arm_smmu_device_group(struct device *dev)
 	return group;
 }
 
-static int arm_smmu_enable_nesting(struct iommu_domain *domain)
-{
-	struct arm_smmu_domain *smmu_domain = to_smmu_domain(domain);
-	int ret = 0;
-
-	mutex_lock(&smmu_domain->init_mutex);
-	if (smmu_domain->smmu)
-		ret = -EPERM;
-	else
-		smmu_domain->stage = ARM_SMMU_DOMAIN_NESTED;
-	mutex_unlock(&smmu_domain->init_mutex);
-
-	return ret;
-}
-
 static int arm_smmu_set_pgtable_quirks(struct iommu_domain *domain,
 		unsigned long quirks)
 {
@@ -1579,7 +1564,6 @@ static struct iommu_ops arm_smmu_ops = {
 		.flush_iotlb_all	= arm_smmu_flush_iotlb_all,
 		.iotlb_sync		= arm_smmu_iotlb_sync,
 		.iova_to_phys		= arm_smmu_iova_to_phys,
-		.enable_nesting		= arm_smmu_enable_nesting,
 		.set_pgtable_quirks	= arm_smmu_set_pgtable_quirks,
 		.free			= arm_smmu_domain_free,
 	}
diff --git a/drivers/iommu/iommu.c b/drivers/iommu/iommu.c
index b44fd1a76997..13a2e0e26884 100644
--- a/drivers/iommu/iommu.c
+++ b/drivers/iommu/iommu.c
@@ -2680,16 +2680,6 @@ static int __init iommu_init(void)
 }
 core_initcall(iommu_init);
 
-int iommu_enable_nesting(struct iommu_domain *domain)
-{
-	if (domain->type != IOMMU_DOMAIN_UNMANAGED)
-		return -EINVAL;
-	if (!domain->ops->enable_nesting)
-		return -EINVAL;
-	return domain->ops->enable_nesting(domain);
-}
-EXPORT_SYMBOL_GPL(iommu_enable_nesting);
-
 int iommu_set_pgtable_quirks(struct iommu_domain *domain,
 		unsigned long quirk)
 {
diff --git a/drivers/iommu/iommufd/vfio_compat.c b/drivers/iommu/iommufd/vfio_compat.c
index fe02517c73cc..2c5a523b5354 100644
--- a/drivers/iommu/iommufd/vfio_compat.c
+++ b/drivers/iommu/iommufd/vfio_compat.c
@@ -291,12 +291,7 @@ static int iommufd_vfio_check_extension(struct iommufd_ctx *ictx,
 	case VFIO_DMA_CC_IOMMU:
 		return iommufd_vfio_cc_iommu(ictx);
 
-	/*
-	 * This is obsolete, and to be removed from VFIO. It was an incomplete
-	 * idea that got merged.
-	 * https://lore.kernel.org/kvm/0-v1-0093c9b0e345+19-vfio_no_nesting_jgg@nvidia.com/
-	 */
-	case VFIO_TYPE1_NESTING_IOMMU:
+	case __VFIO_RESERVED_TYPE1_NESTING_IOMMU:
 		return 0;
 
 	/*
diff --git a/drivers/vfio/vfio_iommu_type1.c b/drivers/vfio/vfio_iommu_type1.c
index 3d4dd9420c30..0bce568f129a 100644
--- a/drivers/vfio/vfio_iommu_type1.c
+++ b/drivers/vfio/vfio_iommu_type1.c
@@ -72,7 +72,6 @@ struct vfio_iommu {
 	uint64_t		pgsize_bitmap;
 	uint64_t		num_non_pinned_groups;
 	bool			v2;
-	bool			nesting;
 	bool			dirty_page_tracking;
 	struct list_head	emulated_iommu_groups;
 };
@@ -2200,12 +2199,6 @@ static int vfio_iommu_type1_attach_group(void *iommu_data,
 	if (!domain->domain)
 		goto out_free_domain;
 
-	if (iommu->nesting) {
-		ret = iommu_enable_nesting(domain->domain);
-		if (ret)
-			goto out_domain;
-	}
-
 	ret = iommu_attach_group(domain->domain, group->iommu_group);
 	if (ret)
 		goto out_domain;
@@ -2546,9 +2539,7 @@ static void *vfio_iommu_type1_open(unsigned long arg)
 	switch (arg) {
 	case VFIO_TYPE1_IOMMU:
 		break;
-	case VFIO_TYPE1_NESTING_IOMMU:
-		iommu->nesting = true;
-		fallthrough;
+	case __VFIO_RESERVED_TYPE1_NESTING_IOMMU:
 	case VFIO_TYPE1v2_IOMMU:
 		iommu->v2 = true;
 		break;
@@ -2643,7 +2634,6 @@ static int vfio_iommu_type1_check_extension(struct vfio_iommu *iommu,
 	switch (arg) {
 	case VFIO_TYPE1_IOMMU:
 	case VFIO_TYPE1v2_IOMMU:
-	case VFIO_TYPE1_NESTING_IOMMU:
 	case VFIO_UNMAP_ALL:
 		return 1;
 	case VFIO_UPDATE_VADDR:
diff --git a/include/linux/iommu.h b/include/linux/iommu.h
index 1e1124f79b56..470b088a13f7 100644
--- a/include/linux/iommu.h
+++ b/include/linux/iommu.h
@@ -360,7 +360,6 @@ struct iommu_ops {
  * @enforce_cache_coherency: Prevent any kind of DMA from bypassing IOMMU_CACHE,
  *                           including no-snoop TLPs on PCIe or other platform
  *                           specific mechanisms.
- * @enable_nesting: Enable nesting
  * @set_pgtable_quirks: Set io page table quirks (IO_PGTABLE_QUIRK_*)
  * @free: Release the domain after use.
  */
@@ -393,7 +392,6 @@ struct iommu_domain_ops {
 				    dma_addr_t iova);
 
 	bool (*enforce_cache_coherency)(struct iommu_domain *domain);
-	int (*enable_nesting)(struct iommu_domain *domain);
 	int (*set_pgtable_quirks)(struct iommu_domain *domain,
 				  unsigned long quirks);
 
@@ -566,7 +564,6 @@ extern int iommu_page_response(struct device *dev,
 extern int iommu_group_id(struct iommu_group *group);
 extern struct iommu_domain *iommu_group_default_domain(struct iommu_group *);
 
-int iommu_enable_nesting(struct iommu_domain *domain);
 int iommu_set_pgtable_quirks(struct iommu_domain *domain,
 		unsigned long quirks);
 
diff --git a/include/uapi/linux/vfio.h b/include/uapi/linux/vfio.h
index e57112f63760..ecbd013ae6ea 100644
--- a/include/uapi/linux/vfio.h
+++ b/include/uapi/linux/vfio.h
@@ -35,7 +35,7 @@
 #define VFIO_EEH			5
 
 /* Two-stage IOMMU */
-#define VFIO_TYPE1_NESTING_IOMMU	6	/* Implies v2 */
+#define __VFIO_RESERVED_TYPE1_NESTING_IOMMU	6	/* Implies v2 */
 
 #define VFIO_SPAPR_TCE_v2_IOMMU		7
 
-- 
2.40.1

