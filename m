Return-Path: <kvm+bounces-64273-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ams.mirrors.kernel.org (ams.mirrors.kernel.org [213.196.21.55])
	by mail.lfdr.de (Postfix) with ESMTPS id 8A043C7C237
	for <lists+kvm@lfdr.de>; Sat, 22 Nov 2025 02:59:39 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ams.mirrors.kernel.org (Postfix) with ESMTPS id 0B0083542D5
	for <lists+kvm@lfdr.de>; Sat, 22 Nov 2025 01:59:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 88B7D2DA749;
	Sat, 22 Nov 2025 01:58:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="Nu5ryfps"
X-Original-To: kvm@vger.kernel.org
Received: from CH1PR05CU001.outbound.protection.outlook.com (mail-northcentralusazon11010022.outbound.protection.outlook.com [52.101.193.22])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B13F82D0C95;
	Sat, 22 Nov 2025 01:58:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.193.22
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763776683; cv=fail; b=tSXHAN1+qHwK6hFzskSiG+ZONMfyUtCD/scapjhyDNDDhb9UOtQhK5Q0wKpOslHFZvZ5VX3ZxrtVx5QZA1eiUcHz/oCi9UitlCfE0wOcEfY+9QFCDHBHgT2Ra9B9i+SzCHHYVetKdtkvcP0JNIM9ugRq8ZZjyaRBTEgWTImGeos=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763776683; c=relaxed/simple;
	bh=A64zjTYF3W/ybqoUMOHjdlmEcE4yQ1qCDuT5mgR9AMM=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ElFyIj2G/GopXEvt0nUM9/YzAs+ROIgvw3na9NYd6BIXrnF9IiuE5CkAkt4+wBlHOLRoJSgv3Jt6HHifaPQCIP44yHpjDX1515UvzG4YVygs9BeLCTdgDl/F8mb0uTdWUszpN4PqOFoGfjhr1tmNY9rBGJZ5ddN2Uj10BqHTBcI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=Nu5ryfps; arc=fail smtp.client-ip=52.101.193.22
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=EUuwMmhQtJ+4LbgnboLrSw3TYEkQdje0vLQpWqpumJhbjm/unTeJidHO1B1l+yIwfiVMXL5dGfvGayFqj0JDLyvC0+pdFpk02GgoSyQAafc+jJWw7LDsSgvqQ9JKhXyVCLx5dkOCwHYcj6HsH/POezAuyS+0hacgmLLO4UoL26PCsjCs7gQovPM1q2okOvIQ3Gv/ldt7TjnKt+MVwI5/81Ct/KoRBLKoScI5gXupTBe9e+riXNiLh4zgh51eOHJ0wBkbtxrCOyFmTkr4BxrHOwbVK3QKig0UnUALKxbTG7FWm+9UJdogWZuzv8bQcgkkCaiU+xwjX+Sy1rJuXKFOJA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Svzub6DeZ2jA3O3RdEx2V+Smcw0K4U3C6DATv57Flio=;
 b=r7ZOXV2Nkc+cOaG4aySBoMNYXIQ8YB8QhmDKn55hyw5S8hnFQxtZ+A4/IGPiwTHChBXwAQVHQ7/US+afPA9/UFmrmX4sDX8XCA5RKB1UNESOe277DnVPUsKQf3zypWF/LB7SNtdfZP+9WAZVybE5T/zuTCB0ZXjrCGlKTLMFWF8h9Aa+NmHhxkI6QY/1ZfsEsvcvhPrjEZju/poTx6eKMh26q2+76ES714tq5WBKmr+yjomqX7lvYDOYMFPYOvjnSY5FKVjG7XlNX11yLuQ1dS/MJXs9ef6LUoSAIm3TSwTbVAA5uC9CLkL3VzzcY8Q9oku/T7IQSZhx15slSAk20g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.118.232) smtp.rcpttodomain=8bytes.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Svzub6DeZ2jA3O3RdEx2V+Smcw0K4U3C6DATv57Flio=;
 b=Nu5ryfps+5DdUj1g3dO9wHQ66vS5iEim4zH0/S3g8Xk4XEB2nlJoE9m0qsmKMTCxeYQv1Tqon4zXxyN6zbCrob2EFk8YpzUxcU+p9yRgQs++Aapr9pvS49rUGismmGTqm7e9RrWfndRMKHaINUGeHaxp9jJ6+VXV+/3G/RqsRg37+4I1RzQuGkdEXB41OAJxM4y1biGkjc4MzNILKesRjUIsbKGkSabNRKW3R7zmT8yeb7QJh8sUSJJjz4PUttVPlYKNb21IZXiqYx9ZRn+DZGN9bsj9u6kRlswCSJfmW+BiBIR8lvsGix4YW3r3RxwIUR39jjtQH2xRxp+O86e/gg==
Received: from BLAPR03CA0068.namprd03.prod.outlook.com (2603:10b6:208:329::13)
 by SA1PR12MB7272.namprd12.prod.outlook.com (2603:10b6:806:2b6::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9343.10; Sat, 22 Nov
 2025 01:57:56 +0000
Received: from BL02EPF0001A105.namprd05.prod.outlook.com
 (2603:10b6:208:329:cafe::ee) by BLAPR03CA0068.outlook.office365.com
 (2603:10b6:208:329::13) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9343.10 via Frontend Transport; Sat,
 22 Nov 2025 01:57:44 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.118.232)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.118.232 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.118.232; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.118.232) by
 BL02EPF0001A105.mail.protection.outlook.com (10.167.241.137) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9343.9 via Frontend Transport; Sat, 22 Nov 2025 01:57:55 +0000
Received: from drhqmail201.nvidia.com (10.126.190.180) by mail.nvidia.com
 (10.127.129.5) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20; Fri, 21 Nov
 2025 17:57:48 -0800
Received: from drhqmail202.nvidia.com (10.126.190.181) by
 drhqmail201.nvidia.com (10.126.190.180) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.20; Fri, 21 Nov 2025 17:57:48 -0800
Received: from Asurada-Nvidia.nvidia.com (10.127.8.11) by mail.nvidia.com
 (10.126.190.181) with Microsoft SMTP Server id 15.2.2562.20 via Frontend
 Transport; Fri, 21 Nov 2025 17:57:47 -0800
From: Nicolin Chen <nicolinc@nvidia.com>
To: <joro@8bytes.org>, <afael@kernel.org>, <bhelgaas@google.com>,
	<alex@shazbot.org>, <jgg@nvidia.com>
CC: <will@kernel.org>, <robin.murphy@arm.com>, <lenb@kernel.org>,
	<kevin.tian@intel.com>, <baolu.lu@linux.intel.com>,
	<linux-arm-kernel@lists.infradead.org>, <iommu@lists.linux.dev>,
	<linux-kernel@vger.kernel.org>, <linux-acpi@vger.kernel.org>,
	<linux-pci@vger.kernel.org>, <kvm@vger.kernel.org>,
	<patches@lists.linux.dev>, <pjaroszynski@nvidia.com>, <vsethi@nvidia.com>,
	<helgaas@kernel.org>, <etzhao1900@gmail.com>
Subject: [PATCH v7 3/5] iommu: Add iommu_driver_get_domain_for_dev() helper
Date: Fri, 21 Nov 2025 17:57:30 -0800
Message-ID: <71f3af9b3c1cd02eb92484d3d3e9fa89dbb2a928.1763775108.git.nicolinc@nvidia.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <cover.1763775108.git.nicolinc@nvidia.com>
References: <cover.1763775108.git.nicolinc@nvidia.com>
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
X-MS-TrafficTypeDiagnostic: BL02EPF0001A105:EE_|SA1PR12MB7272:EE_
X-MS-Office365-Filtering-Correlation-Id: 602caba6-d83c-4618-3958-08de296a8de0
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|7416014|36860700013|1800799024|82310400026;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?gnkLIWgLd6AS2zJnv+p2dDCrgOJtg1vxddzmZ0jI2NYfHYgo2tc/8bA0/ZE2?=
 =?us-ascii?Q?OvTLPnV1+bvEDCndvtciyMiBE3Tsw3K//8YPfOoROa8RKZxPJD4/9ZZGvJDP?=
 =?us-ascii?Q?0T2TOBUxFqtAf30ay93ppH7ANYnnNc/ln6062rW/HdmGuiIzbk1M9gwsseAJ?=
 =?us-ascii?Q?eJqVq4rbLnkUw0yJRQ9yfzKzIphzA5TCiaL+yzPCZPj1ppQ/Y25D5grM0NZ+?=
 =?us-ascii?Q?8vnbml+B15Bpm+z7/HbugHn4PXvlEGwrDhK8BpOX6nQw9k3bpOgd9CDmotJ8?=
 =?us-ascii?Q?E4/3xQyz3AwYJCjDOOwcyn5C8fhKwWHTCE461FEsB9WH3BIl/l73d+Szn6tp?=
 =?us-ascii?Q?TXcWvDzGCYJJfHBYdifqdOgXnuu5jFjDMRQU383SXw7oZDn1BZ2yC/SKre3U?=
 =?us-ascii?Q?oe0nz3hYdRqLW7y1LwpQkexdce7NcAGzGS+b+RRML1n1t23RNCxTx5SChx53?=
 =?us-ascii?Q?AHNeN2Bom1DyRbdOmqFjC9J2ZGxr9C9dQ0/mLQ7ZBz3ouoiNdNYXElieP0tD?=
 =?us-ascii?Q?VIpywsuNfCdzjzio3SY/vAo5YIejMVWuP9bZskKgAcUFl9bB0YFqXK2RqbRd?=
 =?us-ascii?Q?6bJTUatqaPJc6WeTZlIGr9VyXP2iAZKywTDkTlHafvAtr02sNSvBS5ZyBo2J?=
 =?us-ascii?Q?ttUclhmNZi0wN/5oVaFbg5MebtTDwsBXGZnKNgGy1LUKMfp+Qryhw7+qwLwM?=
 =?us-ascii?Q?KH+sV2vETJQ8V5dEmi2skRpSCzQEMjcqN4q9sH8xRE9014B+OKahd0qB87ba?=
 =?us-ascii?Q?9aLQtz7EMGGknpO07uecqZtNvu+D0nfQ4oeCoY4CJWL2ulI+XAvYvc1kj/pi?=
 =?us-ascii?Q?pPpM70sZMndcvzEtxStg78LODbzZ1l+8sddtdlPwniUHydRhCux0U7D4Ey7s?=
 =?us-ascii?Q?HqbTNMZFFEccL5wzC0ONrJPOcklhAQ0R2Neqm0tTegQQSnn1w1t7OKnSmGVf?=
 =?us-ascii?Q?R0acFgUUstzoO+1fHu3Lu8WcWPTQ9sWJrrBBVZs6MmNNwtEyMKfqcIa62/h/?=
 =?us-ascii?Q?MplBbrTrDH76KiXFlVwVH/hstnBLrdpeN63IqBsQoup2xg4FtPuVjozxrAyG?=
 =?us-ascii?Q?epx4ihfkmNLP9m8X3h7v8P9OfaMTfdd2/NcIqAPH4On++pxdMofEVu00HXxQ?=
 =?us-ascii?Q?R0zZn3zfaWR2wVxxvr8MjS6tM0TGPky3/Aj9xuNKiydqY0zhuEZf1+wCqK6t?=
 =?us-ascii?Q?O5q92jhHcJc+7eo2eC4hDs997G+nl6dTXhBOtCEojtuWfvHjG7dEj35FdjMk?=
 =?us-ascii?Q?P1hjhEe1+qYlqFS860M6jwekjhSXN4FRNSBbFNflGyUctRWgGtAO+x+7+SfO?=
 =?us-ascii?Q?A7C3K7I4cbgQ7h9LWKo/wE7z3Hn+UTzhxFj4CIiTWNT6D4+Lq9usdwEBmIS1?=
 =?us-ascii?Q?yKBpBIJNCDZQWKnq45Cw4KBlyWVWXM3NzTL2JgX7Rhlj3O/MtZujCz3derBn?=
 =?us-ascii?Q?znSH1fAdFwuYs6GGZspU+ul4AwatCUXIcyEkKgmqXV8pngeebvfMT0GDtUNt?=
 =?us-ascii?Q?IFaKNQklrvo2BZTANVTFC2pG9OXwpujDrrrnNewkPtzYOB2gR5k93TxS1HsB?=
 =?us-ascii?Q?mDcUO8qt8MYEEBCZIlk=3D?=
X-Forefront-Antispam-Report:
	CIP:216.228.118.232;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc7edge1.nvidia.com;CAT:NONE;SFS:(13230040)(376014)(7416014)(36860700013)(1800799024)(82310400026);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Nov 2025 01:57:55.4927
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 602caba6-d83c-4618-3958-08de296a8de0
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.118.232];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BL02EPF0001A105.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR12MB7272

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
Signed-off-by: Nicolin Chen <nicolinc@nvidia.com>
---
 include/linux/iommu.h                       |  1 +
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c |  5 ++--
 drivers/iommu/iommu.c                       | 28 +++++++++++++++++++++
 3 files changed, 32 insertions(+), 2 deletions(-)

diff --git a/include/linux/iommu.h b/include/linux/iommu.h
index 801b2bd9e8d49..a42a2d1d7a0b7 100644
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
index a33fbd12a0dd9..412d1a9b31275 100644
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
index 1e322f87b1710..672597100e9a0 100644
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


