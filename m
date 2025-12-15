Return-Path: <kvm+bounces-66046-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [IPv6:2600:3c15:e001:75::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 11AB4CBFFF4
	for <lists+kvm@lfdr.de>; Mon, 15 Dec 2025 22:44:00 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id 285A9301FA69
	for <lists+kvm@lfdr.de>; Mon, 15 Dec 2025 21:43:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A51CB32E74E;
	Mon, 15 Dec 2025 21:43:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="pwj9HIkn"
X-Original-To: kvm@vger.kernel.org
Received: from BYAPR05CU005.outbound.protection.outlook.com (mail-westusazon11010007.outbound.protection.outlook.com [52.101.85.7])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E9BF132D7E0;
	Mon, 15 Dec 2025 21:42:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.85.7
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765834979; cv=fail; b=iID8qJQAdf0Ru+c7Ei08jzwXFgWXpGPqvRIwk/+Z3yvcr6X0XqMvgwpWYN5xpL92ufvECW4YDR2qiv30gYtxxmsBDsQnh767jS1OwIVvR+1uTYxBTio+BbiUOvFp6/TiZfRJG9MwgWD1s/HhqtlQstXXKCfsOG6mC+TYcmCmCI8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765834979; c=relaxed/simple;
	bh=S+kyA5z+ydNZbDgTJb6u3FhVwqlLLM0RU25LYvDQkOU=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=mZStyKVLktIDf9xQ9GETGdkOtY9spxRa/51/S4XaBWwhOZBQSKiHqvUtFvaeb7vfDXHrtHsTGHHazMdI9m6PeMyp44fnOPBbCzwFxFjidONcODylaNmeBjpp1OD2bxUmKE3Ub5eZ4AymEtHcqj4AuVzm/9C5stuK3F44oegzMUI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=pwj9HIkn; arc=fail smtp.client-ip=52.101.85.7
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=HZxSM6jcnannviA6Emwc5tHCeO0bUHd2ZV86Kh3IzIIO/noyR3b8YFVnxzF4w5j8zH4B9SGVQ9ekCQDJNEv+9rXzfca8STSZewaHvFkbNrIVb5BETJbuZIaIb4YquXnLdu2y9EjexpXhiH/n1G+SS7vOkgmXhnXIitDQnOBtMdvSY5Z6lCtAorg8NQWB1omb53H7PDmPh+I4Cme+IZsAJfkkSGhGlLqFE4BA+hbcnkd962SLZ9RX5EtPHaoNY4i1dyzkBIHnoSFtR4gca5ybKiUrGfazsCpEOIoAUHUcCjk38PCIMmOHiE+uCAuMOVQTNdah/ZqV0nD9Yla1+um01A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=oqgtoxpNLa6VGu6WtylxAOwYkEJNcK3xtHLzmGUkZUg=;
 b=tXqFC8+S20DvEKhjf4dvmz14DPcQuJiikAP77ALw5Jlcp4LtovoiIY95/PVN8fiRWRoDvHVLarL3VMoZUcoX0rMIt/7M47t58YhSSuCeSmIDBxs/w+73yT1mu+bxXSLrobPo2ESAASEKUZZJT4DCitwqrcxFowe2JH0NM2twqfKtc4MSsu9mawTBY+OK6B1RRmqOK+X5ARCuqsyitzxVkvOsCHFjFxTUAuhetixlSk4dtSskb0oluOljS9fBrCakbI+ZhFMewVWH6cWyhoI+DxhGUah+Cm04hC2rb8wJbau9hXRXZQQuGGLf7pT/Hi5rRx5XwjBeyvG7XzfmwJtzDg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.118.233) smtp.rcpttodomain=8bytes.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=oqgtoxpNLa6VGu6WtylxAOwYkEJNcK3xtHLzmGUkZUg=;
 b=pwj9HIknub7gTSfXNQMr95oq6ZD/PpCA8rrQaiy4EbQy4pdr84huKGA+eGCNKBtASCpAbx80S9LQ6NYQGf2p9mL5IG+hE95aEuaCkMrpms7yu4PtSTeEa5HmbDQa9mPEaE442RzLq8p1kzFZyEZ40Ql7xtfQ2jzF5V9tN3qeJcbd2CmVIZR9efHevF9T02Ax5Iav5Rm+muT/HOkX2CEGaKQn0L0NgiP4JfAofHbWMVt4rEcAOkiC+UeEEmKT3U6IvtNfZRh6dvibO+F3D8+7ygeSsYGVI59boS08mkTOcvqqZAzbBzH+OxP/9DG6gs7yne+34JrnHzOmwt52pUlQVQ==
Received: from MN0P223CA0007.NAMP223.PROD.OUTLOOK.COM (2603:10b6:208:52b::27)
 by MN0PR12MB6341.namprd12.prod.outlook.com (2603:10b6:208:3c2::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9412.13; Mon, 15 Dec
 2025 21:42:46 +0000
Received: from BL6PEPF0001AB52.namprd02.prod.outlook.com
 (2603:10b6:208:52b:cafe::e0) by MN0P223CA0007.outlook.office365.com
 (2603:10b6:208:52b::27) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9412.13 via Frontend Transport; Mon,
 15 Dec 2025 21:42:34 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.118.233)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.118.233 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.118.233; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.118.233) by
 BL6PEPF0001AB52.mail.protection.outlook.com (10.167.241.4) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9434.6 via Frontend Transport; Mon, 15 Dec 2025 21:42:46 +0000
Received: from drhqmail201.nvidia.com (10.126.190.180) by mail.nvidia.com
 (10.127.129.6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20; Mon, 15 Dec
 2025 13:42:32 -0800
Received: from drhqmail203.nvidia.com (10.126.190.182) by
 drhqmail201.nvidia.com (10.126.190.180) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.20; Mon, 15 Dec 2025 13:42:31 -0800
Received: from Asurada-Nvidia.nvidia.com (10.127.8.12) by mail.nvidia.com
 (10.126.190.182) with Microsoft SMTP Server id 15.2.2562.20 via Frontend
 Transport; Mon, 15 Dec 2025 13:42:30 -0800
From: Nicolin Chen <nicolinc@nvidia.com>
To: <joro@8bytes.org>
CC: <will@kernel.org>, <robin.murphy@arm.com>, <afael@kernel.org>,
	<lenb@kernel.org>, <bhelgaas@google.com>, <alex@shazbot.org>,
	<jgg@nvidia.com>, <kevin.tian@intel.com>, <baolu.lu@linux.intel.com>,
	<linux-arm-kernel@lists.infradead.org>, <iommu@lists.linux.dev>,
	<linux-kernel@vger.kernel.org>, <linux-acpi@vger.kernel.org>,
	<linux-pci@vger.kernel.org>, <kvm@vger.kernel.org>,
	<patches@lists.linux.dev>, <pjaroszynski@nvidia.com>, <vsethi@nvidia.com>,
	<helgaas@kernel.org>, <etzhao1900@gmail.com>
Subject: [PATCH v8 3/5] iommu: Add iommu_driver_get_domain_for_dev() helper
Date: Mon, 15 Dec 2025 13:42:18 -0800
Message-ID: <9ace5b395ce7d05c774c30b9d596c0d5eba7f788.1765834788.git.nicolinc@nvidia.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <cover.1765834788.git.nicolinc@nvidia.com>
References: <cover.1765834788.git.nicolinc@nvidia.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-NV-OnPremToCloud: ExternallySecured
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL6PEPF0001AB52:EE_|MN0PR12MB6341:EE_
X-MS-Office365-Filtering-Correlation-Id: e18bd816-d6ce-46a6-d852-08de3c22e2c3
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700013|376014|1800799024|7416014|82310400026;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?CaIIZis65qJ/ilyrRl1wK+sDPNHxBRYf2pK0jOu7iQLM/8F8sK3MiG6U8vE+?=
 =?us-ascii?Q?iA1i+6X6ABXpVTOJ6yAerpBq5HqjdLIiWkS0TGTyBVPW2DvvGPjEpkh5ceVu?=
 =?us-ascii?Q?Du2e2nePrdDuwVJN5zgcUZcW7Gubf2eRfx5y2lHM7aXVS7yvvxdF0Y6QPSLQ?=
 =?us-ascii?Q?x1XTug1oGvXAYaJWYxseKQlpTm/vFPgrowkJI47QOizDAQOkh+lD3zP8VLgg?=
 =?us-ascii?Q?iYhroWQ5clOumVTgQGDg8Q9m2xU1ULPU1uIXqpK7dZlJIv3YF6xYun2bz2jX?=
 =?us-ascii?Q?k0dWlk4cZD9pdbcz6CUfq5PEZe4vkB9xLbMZg1bfAxRInlidtt1G84AWN0dH?=
 =?us-ascii?Q?f3lmMeJ0ywvUc/qS063s6f59L6j9aG2aIivpWLFgSBgb7wXb3LoQv6Zdv8xr?=
 =?us-ascii?Q?d22unYZg3Ytc82GpLch2Z0+9YxYZG0h+RvS7xFS2jw0vN/93jlbAkdlCrLHg?=
 =?us-ascii?Q?dzkVYuHRW2UQ5Bz114WSiXcXrdgV7KPRRPLUlhX89GDoB9+ussUtNACgniiN?=
 =?us-ascii?Q?XrAkZ8n5rWBAS+0EgMOBFSZdFuM6Nq+cf7+TyptuUt68dEDWuWD9dA/ff9ob?=
 =?us-ascii?Q?0/GwFzb7o9WZsYgr4BaKpY7qmzDZVx0fv2k1hGEHPWwLsmTPLyF/jYszVq6e?=
 =?us-ascii?Q?nYak5HIsrR/HjaAIscbKx70zQTgjeJlGTXnk/Q1xuQAd11X8IgtTCOFQ1+rM?=
 =?us-ascii?Q?Unk9/KC6wduUt/AN4lG83lYn4qimCI5bExQvCAQtwtOhGiNfy+gNvhuynKs7?=
 =?us-ascii?Q?ZXZWomcYtVr6m9oqJGjtFymb7bFKeHZaZttDUYYlFo61zmBnCWXeuhLjkwit?=
 =?us-ascii?Q?67mnv2MUqCLrjzqEmYAw3Y7l70fy131LBkRatLKJjc8Dq/DtZmpD7Tq1/yiA?=
 =?us-ascii?Q?foUEOXL/rPJ6T9ZYsD9rufCBjiMrXyAzpA/Pf+q63LaPa/H5HjA3d0X9CrXL?=
 =?us-ascii?Q?/RaS7muvCTOOdvlNJwTeJmLVGVT03/XhqtKeTt8Z2f/ynmWJgMhQZGCXvomK?=
 =?us-ascii?Q?ffOpr60JiICU1SI3VjFbNPs95I1J5HgUP1RRA4r8PzPj8xi9zstIE0J5qENw?=
 =?us-ascii?Q?AEhoq+SojDcDgM+AUv/h0IFVepaA3liOoOiXFHK/Z18ZvvW2vM7sI7voNkaq?=
 =?us-ascii?Q?4J7q0zwjDxVhKUQJc7Dl1I8rVTQ+fYZ7f5j3RvTbyQW9G5BVW2tbzY4GkZVe?=
 =?us-ascii?Q?oWTcSSAj9tchVpTQxWBf2GnwyhFXUvseIAODZXDYAmE4VOtQOPLV7p91p6ka?=
 =?us-ascii?Q?9ND7V3sWpSRSaN3CAjPIr+f24dBC6SSEQQ9pLYVk3VPCpGAHPD/bhx899RXp?=
 =?us-ascii?Q?/qkKv+C3MECqqY7FZau2UePUd6S4tXeHvlFrs8YzD0UeMGs/BQgYkjt/1obJ?=
 =?us-ascii?Q?qoOpL9teoFtAHpD44FaDWUfnYCExmJZaz3qrl7JC5aJYBhz3pA7ePSFT3K9a?=
 =?us-ascii?Q?AE2Y2ADTrPb51CkKuNROe977ia65lBmeQJIhS2E5+kuNdS5cy+P3ASN6+3O0?=
 =?us-ascii?Q?f9HbOtzoWDWBZE/xUly7a0eCEtMcH7eW593ODIg2vpVWgpkFvlxDAlwuhzBF?=
 =?us-ascii?Q?JelpSQNbYeAHfWpNZv4=3D?=
X-Forefront-Antispam-Report:
	CIP:216.228.118.233;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc7edge2.nvidia.com;CAT:NONE;SFS:(13230040)(36860700013)(376014)(1800799024)(7416014)(82310400026);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Dec 2025 21:42:46.2423
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: e18bd816-d6ce-46a6-d852-08de3c22e2c3
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.118.233];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BL6PEPF0001AB52.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN0PR12MB6341

There is a need to stage a resetting PCI device to temporarily the blocked
domain and then attach back to its previously attached domain after reset.

This can be simply done by keeping the "previously attached domain" in the
iommu_group->domain pointer while adding an iommu_group->resetting_domain,
which gives troubles to IOMMU drivers using the iommu_get_domain_for_dev()
for a device's physical domain in order to program IOMMU hardware.

And in such for-driver use cases, the iommu_group->mutex must be held, so
it doesn't fit in external callers that don't hold the iommu_group->mutex.

Introduce a new iommu_driver_get_domain_for_dev() helper, exclusively for
driver use cases that hold the iommu_group->mutex, to separate from those
external use cases.

Add a lockdep_assert_not_held to the existing iommu_get_domain_for_dev()
and highlight that in a kdoc.

Reviewed-by: Kevin Tian <kevin.tian@intel.com>
Reviewed-by: Lu Baolu <baolu.lu@linux.intel.com>
Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>
Tested-by: Dheeraj Kumar Srivastava <dheerajkumar.srivastava@amd.com>
Signed-off-by: Nicolin Chen <nicolinc@nvidia.com>
---
 include/linux/iommu.h                       |  1 +
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c |  5 ++--
 drivers/iommu/iommu.c                       | 28 +++++++++++++++++++++
 3 files changed, 32 insertions(+), 2 deletions(-)

diff --git a/include/linux/iommu.h b/include/linux/iommu.h
index 8c66284a91a8..ff097df318b9 100644
--- a/include/linux/iommu.h
+++ b/include/linux/iommu.h
@@ -910,6 +910,7 @@ extern int iommu_attach_device(struct iommu_domain *domain,
 extern void iommu_detach_device(struct iommu_domain *domain,
 				struct device *dev);
 extern struct iommu_domain *iommu_get_domain_for_dev(struct device *dev);
+struct iommu_domain *iommu_driver_get_domain_for_dev(struct device *dev);
 extern struct iommu_domain *iommu_get_dma_domain(struct device *dev);
 extern int iommu_map(struct iommu_domain *domain, unsigned long iova,
 		     phys_addr_t paddr, size_t size, int prot, gfp_t gfp);
diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
index d16d35c78c06..b8d2fef3ee6b 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
@@ -3125,7 +3125,8 @@ int arm_smmu_set_pasid(struct arm_smmu_master *master,
 		       struct arm_smmu_domain *smmu_domain, ioasid_t pasid,
 		       struct arm_smmu_cd *cd, struct iommu_domain *old)
 {
-	struct iommu_domain *sid_domain = iommu_get_domain_for_dev(master->dev);
+	struct iommu_domain *sid_domain =
+		iommu_driver_get_domain_for_dev(master->dev);
 	struct arm_smmu_attach_state state = {
 		.master = master,
 		.ssid = pasid,
@@ -3191,7 +3192,7 @@ static int arm_smmu_blocking_set_dev_pasid(struct iommu_domain *new_domain,
 	 */
 	if (!arm_smmu_ssids_in_use(&master->cd_table)) {
 		struct iommu_domain *sid_domain =
-			iommu_get_domain_for_dev(master->dev);
+			iommu_driver_get_domain_for_dev(master->dev);
 
 		if (sid_domain->type == IOMMU_DOMAIN_IDENTITY ||
 		    sid_domain->type == IOMMU_DOMAIN_BLOCKED)
diff --git a/drivers/iommu/iommu.c b/drivers/iommu/iommu.c
index 1e322f87b171..672597100e9a 100644
--- a/drivers/iommu/iommu.c
+++ b/drivers/iommu/iommu.c
@@ -2217,6 +2217,15 @@ void iommu_detach_device(struct iommu_domain *domain, struct device *dev)
 }
 EXPORT_SYMBOL_GPL(iommu_detach_device);
 
+/**
+ * iommu_get_domain_for_dev() - Return the DMA API domain pointer
+ * @dev: Device to query
+ *
+ * This function can be called within a driver bound to dev. The returned
+ * pointer is valid for the lifetime of the bound driver.
+ *
+ * It should not be called by drivers with driver_managed_dma = true.
+ */
 struct iommu_domain *iommu_get_domain_for_dev(struct device *dev)
 {
 	/* Caller must be a probed driver on dev */
@@ -2225,10 +2234,29 @@ struct iommu_domain *iommu_get_domain_for_dev(struct device *dev)
 	if (!group)
 		return NULL;
 
+	lockdep_assert_not_held(&group->mutex);
+
 	return group->domain;
 }
 EXPORT_SYMBOL_GPL(iommu_get_domain_for_dev);
 
+/**
+ * iommu_driver_get_domain_for_dev() - Return the driver-level domain pointer
+ * @dev: Device to query
+ *
+ * This function can be called by an iommu driver that wants to get the physical
+ * domain within an iommu callback function where group->mutex is held.
+ */
+struct iommu_domain *iommu_driver_get_domain_for_dev(struct device *dev)
+{
+	struct iommu_group *group = dev->iommu_group;
+
+	lockdep_assert_held(&group->mutex);
+
+	return group->domain;
+}
+EXPORT_SYMBOL_GPL(iommu_driver_get_domain_for_dev);
+
 /*
  * For IOMMU_DOMAIN_DMA implementations which already provide their own
  * guarantees that the group and its default domain are valid and correct.
-- 
2.43.0


