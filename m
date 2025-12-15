Return-Path: <kvm+bounces-66045-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 157D3CC0080
	for <lists+kvm@lfdr.de>; Mon, 15 Dec 2025 22:49:17 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id CE7BC301CE94
	for <lists+kvm@lfdr.de>; Mon, 15 Dec 2025 21:43:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A165E32E696;
	Mon, 15 Dec 2025 21:42:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="ag9X4KWF"
X-Original-To: kvm@vger.kernel.org
Received: from DM1PR04CU001.outbound.protection.outlook.com (mail-centralusazon11010005.outbound.protection.outlook.com [52.101.61.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E044D32E120;
	Mon, 15 Dec 2025 21:42:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.61.5
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765834977; cv=fail; b=hIBE6iXGrxJvhAsOoyYRXRvcUIA2C3t8qim7MvGVOYzlBZyvHY6Ds3O+h9Bc7Y5Jnirme4v9p+Dk7h4xPpTuRUEyFcgJLGghhkoHFUJDEvw0D3lNHD9bvh0pMbodxbV3c9xDNraYoigCKpMlVBRhHZ0WsB7zqgJM6iZnf0NRQTQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765834977; c=relaxed/simple;
	bh=iak87dBxpjhwA5ZFdfPqn8XOtMIYt6yDIoIfAjlRmgE=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=PQDeuytTSp9xaJQmJP+uZgGrUuR4c7LaYJqC2qb/x0QIXs8G2OSNqkS4DT9Clj1jPh4F8zr1I2HjbpXvC6LTv9LZgTimeUMQNy/1HgoE5FP/my0Lxdwgikn1LOBub+ohXOB1IEeaVMbjtMFbk4gVh6FcI2UVYE79Xy/0CAs2u/c=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=ag9X4KWF; arc=fail smtp.client-ip=52.101.61.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=T/B6JxspX+sgj8FK51npUav1t7+wOr3ZeXhg7Fm9JlpSIYB1zt1FlRHOb0uyJpU0wu40Rth3KfqbS4quOKQYH5KSh/4n5n0bi9D9X/kK6mHe/XNuqVfSZcEBYUjiueDnR/J1O2tHP1Dk0vwmIM3xlqvbIWfXnql2vKkLb1lBitt8NLqTYueiAxY6eb6+lhMQYF44wvCRBln2JWRs3w0ArNaIagQ2hkSwCrffVhCgPVrmZTI8sdnNGNDMMWTSxeFHkaFRQP/bUoAx7kSnBQlETbCAGai5nPu04crBNT9LxQUEF+Fn/StVEwfVHF7oxzIPD//gyVIc4A2B3+ox8q3cdw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=n24JF2OvxWwOLG1IabA28dNDNHgQHJwMPeEGPPE2g8Q=;
 b=RLMG4x9HyZKvsHxVjZdgTQhftXYdozbajFVB4xdwsULqUgqefpiqpFh8bLs/tSyaLlvu5iOeRXEWcAFjTfbLDjQM+TJ3N2EByuedmtrOz0D1x4+g8nT9vmEpMJgp37nGR8FIpH9WJLj01HFrJqFNFegpu5LPSFkFNToqYY+nGjbhRBm3PEOJcKV3+iFDIdJ5N4TryRHWIqkz2b/Iz3yyzkHyF96W6K5KdBPwDbTJNOriOVYmmzOQV76orlmxcSwUUSTjPy+yivPCLjVjgCc7W6AlUHNE7UwrfTYSI2LCI51NmmgIbkje/JI+5dRa43xH335IIn0Pr+Q7b3vZbhpzng==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.118.232) smtp.rcpttodomain=8bytes.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=n24JF2OvxWwOLG1IabA28dNDNHgQHJwMPeEGPPE2g8Q=;
 b=ag9X4KWF3M5yDiJ+dEwwNTiM8MgXEi3oAuAOJ0agoK9hzKuuLqz6LGfDeahLJ5UxT5UNnbYNedmkUssruk6S+tn3+GOU5t+0YJp9v9RqXVkKNfgB2ke0C62g/aCxaY9q4lvr1NaSu/62h3PhQSKm679V+VxTQmaCgLgtAUz2eaR/vzy2Er3KerYx/TBgm7ApnbZ/cGL7W9aWBO90d4z2QT2nv1zfVYdIxtcg3UOGo6agxHi51bQkph0kuQTUN2QBtHGFTq2750AfRTdOWD3gmwSJgdhJHybiBd2L6iS9bE1ijexLWwgLTNsig4zysnBuIcuYSTTzDWA/Lxu3PqqGQg==
Received: from CH0PR03CA0273.namprd03.prod.outlook.com (2603:10b6:610:e6::8)
 by PH8PR12MB6770.namprd12.prod.outlook.com (2603:10b6:510:1c5::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9412.13; Mon, 15 Dec
 2025 21:42:49 +0000
Received: from CH1PEPF0000AD7B.namprd04.prod.outlook.com
 (2603:10b6:610:e6:cafe::9) by CH0PR03CA0273.outlook.office365.com
 (2603:10b6:610:e6::8) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9412.13 via Frontend Transport; Mon,
 15 Dec 2025 21:42:48 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.118.232)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.118.232 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.118.232; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.118.232) by
 CH1PEPF0000AD7B.mail.protection.outlook.com (10.167.244.58) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9434.6 via Frontend Transport; Mon, 15 Dec 2025 21:42:48 +0000
Received: from drhqmail201.nvidia.com (10.126.190.180) by mail.nvidia.com
 (10.127.129.5) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20; Mon, 15 Dec
 2025 13:42:31 -0800
Received: from drhqmail203.nvidia.com (10.126.190.182) by
 drhqmail201.nvidia.com (10.126.190.180) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.20; Mon, 15 Dec 2025 13:42:30 -0800
Received: from Asurada-Nvidia.nvidia.com (10.127.8.12) by mail.nvidia.com
 (10.126.190.182) with Microsoft SMTP Server id 15.2.2562.20 via Frontend
 Transport; Mon, 15 Dec 2025 13:42:29 -0800
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
Subject: [PATCH v8 2/5] iommu: Tidy domain for iommu_setup_dma_ops()
Date: Mon, 15 Dec 2025 13:42:17 -0800
Message-ID: <092a99f0b6d59237aa6a06f719f51fca59d7330a.1765834788.git.nicolinc@nvidia.com>
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
X-MS-TrafficTypeDiagnostic: CH1PEPF0000AD7B:EE_|PH8PR12MB6770:EE_
X-MS-Office365-Filtering-Correlation-Id: e86b11ed-2132-4710-6180-08de3c22e43e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|376014|1800799024|82310400026|36860700013;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?h4Ox8G6v/jOxjqs8Kr8m6RF8psWJs1XFjAwklMXRwmblHFLW8N8z0hmtXVeo?=
 =?us-ascii?Q?LUu+avW1M9ShXqustEP3av3htkdGHWhvtl6uN/XYSxD+i0L08niG7kLj/mQr?=
 =?us-ascii?Q?MgfH0xKk612jmtVuIEAR8qdWSzOH0qTtlZBpgfyB5sLF8qf+XWIMJvUm1Mp6?=
 =?us-ascii?Q?Fd4ccohSAv2gpQUz2NS62YLK3PhECLOm0U/r0xzE2F424pC0RbbOIOoU/2Cu?=
 =?us-ascii?Q?CMrDaG13lFY+P+XYlf61mojPZ0vXA9N4TOcjEAmNaoAn3bAiFa0u6zfFBrp4?=
 =?us-ascii?Q?N7J82xiMwypR5dB3Atudkc90tNrLS/xLEZGZw0bK3swbRGlDBN7G688f5/k2?=
 =?us-ascii?Q?ANNu0EgSVu1er0HXmIVf+19UuDUyMinJfmvb+vQ7OoXlYTQJc+R2S0U4vKtr?=
 =?us-ascii?Q?P3HOFyIKFF5bDUDVBLRf37d6R2+NbnT2ofI4VfdWXGUC1BWB2PxrKMZFStrn?=
 =?us-ascii?Q?Vw/Nc/GsSo5RZdfBC8Z66jnwJFD53hQoXIDnWdIoameh0yOaNDnO2YRnCF9N?=
 =?us-ascii?Q?kp3xjgmhgUtLUFJEHE9Mdf4G6fvTJT3P6To3H8bMME696jeCagQHMmHbjIx3?=
 =?us-ascii?Q?Mr8233A2A8OusPIgNFC6ZoYAgyGcTsY3nO/tsviIeK7qgW+uQXinaMSnxuxv?=
 =?us-ascii?Q?QWaLzg9CKzefH2j4bDI6PY63jYwYiD6pW04Gg2VZzWO6CMJ83kN/kgQiYY4b?=
 =?us-ascii?Q?aC4vsDK44+MXmG5MNrEyDG7hmHYFXWIJ/JGBMqpfaigbMyfM/W0w3r1U/LfZ?=
 =?us-ascii?Q?BhVJoquPd0WKLmzZEj/4WglOu9DMX3FcoC9dVXqYtiUbbsgWG6s5jKRr4TYG?=
 =?us-ascii?Q?4PlK4fHzL2HeFLuQjjda3J/6m1qwniRQBrmb3aHmwxlXx1OpCk3KTc4ez9aT?=
 =?us-ascii?Q?7YcFH5BBeE1FG4qWc4WejhwLSv1hMEZ1FvsjnjvkSxeSnJYhHVkkPolLPhs1?=
 =?us-ascii?Q?vmaKV8nOxDc46jN4iXR5oKSKZbZnveLiqHFsmnYhJY5rp8u2J/GAu9HOMDon?=
 =?us-ascii?Q?0vQIhM9XGpDcgZsE6dc+huzfVweO7QBtBBpE3EzKrvI45y+82ah+IfMO2Je6?=
 =?us-ascii?Q?oHpQAvJxtM2Pszt0uFetXmZW7iAFKBYLJVEv+cJmEqoho/mgkmsyePjBuYkI?=
 =?us-ascii?Q?FNVlWj855uB2eA85XoOVpOBuWKcZ3frrubTb/GR2Zx91lW8Wkgd5UUALjwbP?=
 =?us-ascii?Q?yizMB3nAnK3xInklYs+rPcsre57dfTjOWTkmDXCsIu5QFq5jOMfbGXGqZo7h?=
 =?us-ascii?Q?Rag1flQVpBIspzl/HcepZiOYYeZTAYNyQhM3UZnBRJfbiKAXz/u06uRNNtYo?=
 =?us-ascii?Q?1MRAbWBvhZ4lzaYO1Y25K2zkfSFwqY0U8KVee1hFjE3powyhpJHnTPhOMlWf?=
 =?us-ascii?Q?Br579EBGvkKStuBH/8n3TYZT4yXjcuskhMNvLCXyLQxC3RGp3GbdkU1J3Ro1?=
 =?us-ascii?Q?/SIGAGYQcpmMLk5dbCUYVkqWR5uSW/OjtBqJVkZf5OVmwr8M1HvyGRfQ/6ni?=
 =?us-ascii?Q?UtI/X/bUleEO1gRbO7389Nb/BumgryvJJ2YQ6bkdC9wY1q7IyE+j7iML+zai?=
 =?us-ascii?Q?erauwhva3u5cuiq6cgc=3D?=
X-Forefront-Antispam-Report:
	CIP:216.228.118.232;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc7edge1.nvidia.com;CAT:NONE;SFS:(13230040)(7416014)(376014)(1800799024)(82310400026)(36860700013);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Dec 2025 21:42:48.7378
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: e86b11ed-2132-4710-6180-08de3c22e43e
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.118.232];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CH1PEPF0000AD7B.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH8PR12MB6770

This function can only be called on the default_domain. Trivally pass it
in. In all three existing cases, the default domain was just attached to
the device.

This avoids iommu_setup_dma_ops() calling iommu_get_domain_for_dev() that
will be used by external callers.

Suggested-by: Jason Gunthorpe <jgg@nvidia.com>
Reviewed-by: Kevin Tian <kevin.tian@intel.com>
Reviewed-by: Lu Baolu <baolu.lu@linux.intel.com>
Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>
Tested-by: Dheeraj Kumar Srivastava <dheerajkumar.srivastava@amd.com>
Signed-off-by: Nicolin Chen <nicolinc@nvidia.com>
---
 drivers/iommu/dma-iommu.h | 5 +++--
 drivers/iommu/dma-iommu.c | 4 +---
 drivers/iommu/iommu.c     | 6 +++---
 3 files changed, 7 insertions(+), 8 deletions(-)

diff --git a/drivers/iommu/dma-iommu.h b/drivers/iommu/dma-iommu.h
index eca201c1f963..040d00252563 100644
--- a/drivers/iommu/dma-iommu.h
+++ b/drivers/iommu/dma-iommu.h
@@ -9,7 +9,7 @@
 
 #ifdef CONFIG_IOMMU_DMA
 
-void iommu_setup_dma_ops(struct device *dev);
+void iommu_setup_dma_ops(struct device *dev, struct iommu_domain *domain);
 
 int iommu_get_dma_cookie(struct iommu_domain *domain);
 void iommu_put_dma_cookie(struct iommu_domain *domain);
@@ -26,7 +26,8 @@ extern bool iommu_dma_forcedac;
 
 #else /* CONFIG_IOMMU_DMA */
 
-static inline void iommu_setup_dma_ops(struct device *dev)
+static inline void iommu_setup_dma_ops(struct device *dev,
+				       struct iommu_domain *domain)
 {
 }
 
diff --git a/drivers/iommu/dma-iommu.c b/drivers/iommu/dma-iommu.c
index c92088855450..aeaf8fad985c 100644
--- a/drivers/iommu/dma-iommu.c
+++ b/drivers/iommu/dma-iommu.c
@@ -2097,10 +2097,8 @@ void dma_iova_destroy(struct device *dev, struct dma_iova_state *state,
 }
 EXPORT_SYMBOL_GPL(dma_iova_destroy);
 
-void iommu_setup_dma_ops(struct device *dev)
+void iommu_setup_dma_ops(struct device *dev, struct iommu_domain *domain)
 {
-	struct iommu_domain *domain = iommu_get_domain_for_dev(dev);
-
 	if (dev_is_pci(dev))
 		dev->iommu->pci_32bit_workaround = !iommu_dma_forcedac;
 
diff --git a/drivers/iommu/iommu.c b/drivers/iommu/iommu.c
index 170e522b5bda..1e322f87b171 100644
--- a/drivers/iommu/iommu.c
+++ b/drivers/iommu/iommu.c
@@ -661,7 +661,7 @@ static int __iommu_probe_device(struct device *dev, struct list_head *group_list
 	}
 
 	if (group->default_domain)
-		iommu_setup_dma_ops(dev);
+		iommu_setup_dma_ops(dev, group->default_domain);
 
 	mutex_unlock(&group->mutex);
 
@@ -1949,7 +1949,7 @@ static int bus_iommu_probe(const struct bus_type *bus)
 			return ret;
 		}
 		for_each_group_device(group, gdev)
-			iommu_setup_dma_ops(gdev->dev);
+			iommu_setup_dma_ops(gdev->dev, group->default_domain);
 		mutex_unlock(&group->mutex);
 
 		/*
@@ -3155,7 +3155,7 @@ static ssize_t iommu_group_store_type(struct iommu_group *group,
 
 	/* Make sure dma_ops is appropriatley set */
 	for_each_group_device(group, gdev)
-		iommu_setup_dma_ops(gdev->dev);
+		iommu_setup_dma_ops(gdev->dev, group->default_domain);
 
 out_unlock:
 	mutex_unlock(&group->mutex);
-- 
2.43.0


