Return-Path: <kvm+bounces-64272-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ams.mirrors.kernel.org (ams.mirrors.kernel.org [IPv6:2a01:60a::1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id EB33FC7C229
	for <lists+kvm@lfdr.de>; Sat, 22 Nov 2025 02:59:15 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ams.mirrors.kernel.org (Postfix) with ESMTPS id B0624341C5F
	for <lists+kvm@lfdr.de>; Sat, 22 Nov 2025 01:59:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3431A2D73BD;
	Sat, 22 Nov 2025 01:58:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="IFoSU8s7"
X-Original-To: kvm@vger.kernel.org
Received: from CO1PR03CU002.outbound.protection.outlook.com (mail-westus2azon11010008.outbound.protection.outlook.com [52.101.46.8])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ACFB4253F11;
	Sat, 22 Nov 2025 01:58:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.46.8
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763776682; cv=fail; b=TFd/g2Uct3BorDaY88/mj+5Q9d44ZwpZapdhrRXPFvN2IoiiuPp5XVJP3Xj1rHwe5lXajV4iZ8LYRLMXNoK5dXuDhAQX2Tfx9GluEVPT1Cm7MmY2TMMoQ2FfIHMcPmYzlHR0+dLzy53NR6uDHuNY0Lg0gz547p4IhWHPXJxB7Lg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763776682; c=relaxed/simple;
	bh=SYorAc+87wj3DkYWD88E+XlPWUaxf/WpFuAo+FbC2+c=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=r+yK3XJLk7QOi5SBf/whQMQmspdJl1q58TncP+kS66tjBZrdk/XppUp6VTZ1gQfD09G2GvHWlnRDR0mwM1c1tO2a9k5kpsqIcJpGwZXdT0awMOz3fCd3sY1tpfzpoBPpAQlt0dv/FCl3C1x3BMViNgjIlJCEHqAzTOwkg+YTa+o=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=IFoSU8s7; arc=fail smtp.client-ip=52.101.46.8
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=k/e6zyN+eBzVlvAYbyktxZqJPzmPrnJF3e0Uonl71bes86fnfbebmTb9eCK6ek59FtE347DULqwpgGVlIvJ6HjRPKjKuFkQny6FvXYcSStC8LmLBAZ3GipqvhKcE35hkdBc5x9QUpbRIZKG329WlDWNmEdMpFb0V8Xxt2TX3rSY08yAXIqV9yhYBZmCMgN9OVPWKllNDMFhQ/mF7fqiRbbqN2CRTgpusokJ0uldztByhiAf5B9OdoQPrcwmeLeVUlWG6nDvjGWZdjQAEg7thTSYyYp9VgLInG43lmeiwaSApFPnnZseE/Obj5HqZxFcLc+lNJXYDgNNH0VUMiYZabQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=WUR4BM/DW5FAcf29ydQ8n6TSp2s4y3ASMhhwrnUl9P8=;
 b=CjqPRShhIlH02aBi5kQi6FtKZ4NEl6Vgv/ZInEMffEwUJ9uRRGfFmf+4bWMzivoTESTi5pzX5wjKyKt4DDFfD6y3TYVOgDfE6K7csTNbrXS7g28VpJs+k/L9HSmxI7TCW4e0e6vUobNhgyBUHnQkc00DWfq+FmoTzyJpb57TSMjntOGrsZSKss4NS8JiA/wspIUT7LxlyKfUTCvov2PuETQUm/axac8G7TTZMBnfuPrqYiVhgg+XguTSbhz5RJpFsGNNSrlCQVAzCNOQlqJrA2fMz22jxZQXyn3xsZH9Rwk9Huyed0sTkSReAgHmDe/Hmt7O6jxuOzvp8JTXRUPeUw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.118.233) smtp.rcpttodomain=8bytes.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=WUR4BM/DW5FAcf29ydQ8n6TSp2s4y3ASMhhwrnUl9P8=;
 b=IFoSU8s7l80kH35fYijegslq5V5thzBmGwC5ZU2A10osd5HKAcf2JpHyixpwjpVsfvgJz7cEOiFWdnvSlo+OXDRD5LgGB76gMb62tOVwM/s2OSlQQ8hf+BWXeWSs1162mjglrQr372m4IXjoIeSLThjzs9DjZpmmsbS/Z9YuLZvN0/jpO9ovIAQOMxX4o3TtsqbEFP0GMZ9ee5KoT0AM89q1Jyx/kD5Oebu4xiwCe/rsGKQOsR1w50WTWjA43F1fGxjz5iwzImHM/v7r2+WleMkDNUwWnEfoGO1MIyH9jhy1ZOqXpulI9ZCzSgTDVVDteoixE/4mUTjfr9CBRWxc0A==
Received: from BN0PR04CA0118.namprd04.prod.outlook.com (2603:10b6:408:ec::33)
 by IA0PR12MB8982.namprd12.prod.outlook.com (2603:10b6:208:481::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9343.11; Sat, 22 Nov
 2025 01:57:57 +0000
Received: from BN1PEPF00005FFD.namprd05.prod.outlook.com
 (2603:10b6:408:ec:cafe::e0) by BN0PR04CA0118.outlook.office365.com
 (2603:10b6:408:ec::33) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9343.14 via Frontend Transport; Sat,
 22 Nov 2025 01:57:53 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.118.233)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.118.233 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.118.233; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.118.233) by
 BN1PEPF00005FFD.mail.protection.outlook.com (10.167.243.229) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9343.9 via Frontend Transport; Sat, 22 Nov 2025 01:57:57 +0000
Received: from drhqmail201.nvidia.com (10.126.190.180) by mail.nvidia.com
 (10.127.129.6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20; Fri, 21 Nov
 2025 17:57:47 -0800
Received: from drhqmail202.nvidia.com (10.126.190.181) by
 drhqmail201.nvidia.com (10.126.190.180) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.20; Fri, 21 Nov 2025 17:57:46 -0800
Received: from Asurada-Nvidia.nvidia.com (10.127.8.11) by mail.nvidia.com
 (10.126.190.181) with Microsoft SMTP Server id 15.2.2562.20 via Frontend
 Transport; Fri, 21 Nov 2025 17:57:45 -0800
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
Subject: [PATCH v7 2/5] iommu: Tidy domain for iommu_setup_dma_ops()
Date: Fri, 21 Nov 2025 17:57:29 -0800
Message-ID: <6e8aacd34b038e7534fc5cb3fa21ab31b1af01ad.1763775108.git.nicolinc@nvidia.com>
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
X-MS-TrafficTypeDiagnostic: BN1PEPF00005FFD:EE_|IA0PR12MB8982:EE_
X-MS-Office365-Filtering-Correlation-Id: 880375d0-6254-4ecd-c0e6-08de296a8ee2
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|7416014|376014|1800799024|36860700013;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?Csc5NEtKV+WRsdvh7U6xEH3fy9Ipr5MkJ2q7TsFNJ5DRKf8V45Zn8Th4dtKH?=
 =?us-ascii?Q?GSYDzfhar2vTUvM4/VL/vsHa8loHHlEreLMsF4ezLruJbw+LbCpEubUCajxF?=
 =?us-ascii?Q?GoxlucgREtzBxpScEZ2a2cGgqurjN8Wl9uWx4sFWTlUX3ZxN038WxNtwWKVT?=
 =?us-ascii?Q?DfC7JcWz6TaBnT3CnvLfzaNUz60HSksvGBz9yYLjFRNwhxpULUPAFTvHsSl2?=
 =?us-ascii?Q?/JcHjaglpaS4mXTfzADisimHmEePMewRU/OBrAbV4CZb8uS7b3jd4D4klNRk?=
 =?us-ascii?Q?xm+1J6krE7DidvfUBgE9r+aHD6c2O5a8yukQ/OfakXNkWak8Z01b2KKFSh62?=
 =?us-ascii?Q?PuNJgMMONVsd2L2ObxcV6UkXCg4ZXX3+Jnv27/Xi1D97KgMwztcdRqxdv4/Y?=
 =?us-ascii?Q?HXPW8nA5rmXuJtcZApJOwFeEcm4blj0TZL0jLOz8hca3WqYErVAWXX0//wCM?=
 =?us-ascii?Q?ImQBJm8vaStQkVwA36xqSLR8UfPcGQAt6cP6Pj7DIFB4gz6zxBuuCcSap5EF?=
 =?us-ascii?Q?h+B/hjpcLqxwj3ZkJ7vPbWYq1F14FTn+zUQVT5lKZqlHUCJePD/r3awFFV8n?=
 =?us-ascii?Q?cGDbPLIA2cl9M4qAhTDKSBVVKXJ6qRjFJEloFY1kjiaxQ2hGM9Kj9wqMd2E0?=
 =?us-ascii?Q?nWHNpP5vhjlFVK+e8TfmCODW2vOFJ57Ye7GcVHf4SeQqrTW3+Lm62/NDNqeC?=
 =?us-ascii?Q?AUhyQbsXu5WL1ILfLTb0AQP8PlV/3deXfI5mRMLmDnjbAMt+0jzJqICU3/tG?=
 =?us-ascii?Q?dGBh468hEF114rTmBD2SPhUbwR4vwMH7Xq0jtfi2Dy53n0V3JLuKE/NwJp8d?=
 =?us-ascii?Q?KKcMn4ik3gDfjgWNIy2eyplFisINzqHXFSiN8/5UI7VvDrsnY4XRU4gzHRP9?=
 =?us-ascii?Q?ii93qkdm9K8oXokYUXrCrUnN6aMrIdNaQfSSYP/0QS2pPtcvKzZuS1KWBxfN?=
 =?us-ascii?Q?nbLewXc0vM9+udh4O9JPNcfl5bxKz+EoNhYP892IfmGiOw+CNcF0hziKRRcY?=
 =?us-ascii?Q?Kc+ajGGoRwlP37TNKe9FDP2V5ogtq3vXKxaYFzQ9PX9epL1W9TqoGsY7JeG1?=
 =?us-ascii?Q?T506a1j4ck1O+8GbymBiDVd447U6d/QluKH1fdcmeweVw3W2mRtBQQH3JTZX?=
 =?us-ascii?Q?eHLkdqSK3dV2p5U8bYbeKx3fw7h5MZWvmCxIAS4Ftgo6jBK8CflNnT5GRWE5?=
 =?us-ascii?Q?IsMiVjQ21SCiN6GuMoe4J6rLDCI0GhrTpp+Y5NurXHxatFGqqoSJ7hseovmG?=
 =?us-ascii?Q?zy47eaeoOLO3UYiIGhfPR4IF+yXN6joS6w2V8/HcOq2CyLqHiU0RFgRZr8Qf?=
 =?us-ascii?Q?ll5yBJCQ5C2rfnrUPaOetzUxY6rL7664wKfLaphcejX7u8wZ6jM6eJjc7nmh?=
 =?us-ascii?Q?Xnoe6XecZrQaABfdFy9nv7C8rlXDBh+Ky8i7U7K8bmEYoW9tWy7JrZIvfztU?=
 =?us-ascii?Q?sn3kqwAATdBwtbtz8HhM+eznTY1ssQb2+dJZf5uWme5YkWRpote3aezsxbXK?=
 =?us-ascii?Q?/V88iBGWtBdFh2Ba6h2XWVcXjN2RzjhBv0iIe1hT3fo1Y1C2/RTuJ814GZ4x?=
 =?us-ascii?Q?DLCdZI99WZtDJV75gug=3D?=
X-Forefront-Antispam-Report:
	CIP:216.228.118.233;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc7edge2.nvidia.com;CAT:NONE;SFS:(13230040)(82310400026)(7416014)(376014)(1800799024)(36860700013);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Nov 2025 01:57:57.1474
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 880375d0-6254-4ecd-c0e6-08de296a8ee2
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.118.233];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BN1PEPF00005FFD.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA0PR12MB8982

This function can only be called on the default_domain. Trivally pass it
in. In all three existing cases, the default domain was just attached to
the device.

This avoids iommu_setup_dma_ops() calling iommu_get_domain_for_dev() that
will be used by external callers.

Suggested-by: Jason Gunthorpe <jgg@nvidia.com>
Reviewed-by: Kevin Tian <kevin.tian@intel.com>
Reviewed-by: Lu Baolu <baolu.lu@linux.intel.com>
Signed-off-by: Nicolin Chen <nicolinc@nvidia.com>
---
 drivers/iommu/dma-iommu.h | 5 +++--
 drivers/iommu/dma-iommu.c | 4 +---
 drivers/iommu/iommu.c     | 6 +++---
 3 files changed, 7 insertions(+), 8 deletions(-)

diff --git a/drivers/iommu/dma-iommu.h b/drivers/iommu/dma-iommu.h
index eca201c1f9639..040d002525632 100644
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
index 7944a3af4545e..e8ffb50c66dbf 100644
--- a/drivers/iommu/dma-iommu.c
+++ b/drivers/iommu/dma-iommu.c
@@ -2096,10 +2096,8 @@ void dma_iova_destroy(struct device *dev, struct dma_iova_state *state,
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
index 170e522b5bda4..1e322f87b1710 100644
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


