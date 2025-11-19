Return-Path: <kvm+bounces-63639-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ams.mirrors.kernel.org (ams.mirrors.kernel.org [IPv6:2a01:60a::1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id BB0D8C6C30A
	for <lists+kvm@lfdr.de>; Wed, 19 Nov 2025 01:56:33 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ams.mirrors.kernel.org (Postfix) with ESMTPS id 9457E34E4A0
	for <lists+kvm@lfdr.de>; Wed, 19 Nov 2025 00:53:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D3CFC234984;
	Wed, 19 Nov 2025 00:52:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="OPV/kopV"
X-Original-To: kvm@vger.kernel.org
Received: from DM5PR21CU001.outbound.protection.outlook.com (mail-centralusazon11011046.outbound.protection.outlook.com [52.101.62.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 516B422D780;
	Wed, 19 Nov 2025 00:52:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.62.46
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763513576; cv=fail; b=hCpdni8//85bBI78quJC9+AQnqVeLWDt+NjvLoYDJG+xbzmTuGUhRBEbC3OGdNUTSZWlbdW0nkpd4kkp6VYU9PUIjX9XSHyoVqbEYOzgh7EBY832Guzf8GJNiyW4zgdDG8vJuqY4c2iaul8VPc93X9C1wKa3JExrtTFu1Ks4vBA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763513576; c=relaxed/simple;
	bh=SYorAc+87wj3DkYWD88E+XlPWUaxf/WpFuAo+FbC2+c=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=a0+7ihaUWdS653widN4ErO3Re5NQ9sq+olouAwPMhqFJy5bIkQE454S3KDWnRbB+Rx4xt5EijCefmQQbHpttVrlg3Gru4zg62wCTn0T6sSGIaX4nFPA6L2uDGWN2T0L4WeU+xz2tzlj7KKo0SBG9Z5PntW2d3g6tmdQj2Ics7jk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=OPV/kopV; arc=fail smtp.client-ip=52.101.62.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=vEb1COWj4azM3pum0qxvI+aKEZxyhVnw4UNr5hAJ4e1dlaaI4f+YTP/ABlTFhDBktz1OHFqF/dcTCfIHIsxVd8uL7HnRRumZd/y2/s+aSzFknlCYwJnsMze5kf5kbwTmeJAiFzPpWxImv7f5LR/soRwdV+TZHtfTVpDo9HLt233kgyFGnIVSWGquxATHHu86lZRaqgWvjNqLDoLRVWWW4xFpCR9Y4AHrlDdyCiluoqKy8kGPYGs1GrpSQeiQACF4KMiY+3LXKvz2JfuO98kXBHL/kAVD8zzLX+abd1y8i8mniDzlN6ApriwWPyo53DoN7d4trVA06UDycrsJSDDTfA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=WUR4BM/DW5FAcf29ydQ8n6TSp2s4y3ASMhhwrnUl9P8=;
 b=ixoavb9/msfAhcznfZ+Zbk87SlpDpMzh+q7ZzDGY1+XCk1PAdXdOFHntyv6E0sw3bYCEbkmCV/vxiJKbwAghvF+6D3afi9AXlimA6EpOHaYcIxpetzNOhiVtpoBEi+bHtVzItMEZweSyXBS9+dVKcQdi9LDLUfPtbapT9MbDA4n68iWUFRk+B6eC9Jk1zN4iX1/7y+tnzqQmcZXDt0ZHMnZjD3LX+9kEc9Kw8CNfvlW70OCMmy/MVQLLnmlK0MA7GgYrouI1m1EBGDD91sA0yBsu8EjRiedIYF0/NIN2jZXLkm+nCxDFC8aSmr4SkGGnMC3v3mke1jKDGJPAigzujg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=arm.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=WUR4BM/DW5FAcf29ydQ8n6TSp2s4y3ASMhhwrnUl9P8=;
 b=OPV/kopV/ngtFYanhm8NHG7BK8c+O4qISZoD+jtvSiu22Rv3Db3UYIA9tXylz5mnMqQnj1EzQa5tvxGUmoMX87KPC5BOnYJngtRALa+V3S9+1SgvNLbJBkUz3g9bVadpQDAAUceW8oqEo8szSiLqt7KYI+1wZCeYD5VhmKtw1AEQHwiNXJ4QmdLroR8TA8M5XS320JFceLoY1kKQ2DJ6fI/DxolKx81RrHmaUsONdl+KpFtlj74/vVHv1Rny1/cktANeSqT42qOkFyXaNRgk/u8cnHBLQJb7kwNevJzftGLQjG0kUbuJgtS4IyDl9RR8zEJO/cAe4U0ztUpVItKc7w==
Received: from SA1P222CA0121.NAMP222.PROD.OUTLOOK.COM (2603:10b6:806:3c5::9)
 by LV3PR12MB9409.namprd12.prod.outlook.com (2603:10b6:408:21d::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9343.10; Wed, 19 Nov
 2025 00:52:50 +0000
Received: from SN1PEPF0002636C.namprd02.prod.outlook.com
 (2603:10b6:806:3c5:cafe::c1) by SA1P222CA0121.outlook.office365.com
 (2603:10b6:806:3c5::9) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9343.10 via Frontend Transport; Wed,
 19 Nov 2025 00:52:50 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.161)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 SN1PEPF0002636C.mail.protection.outlook.com (10.167.241.137) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9343.9 via Frontend Transport; Wed, 19 Nov 2025 00:52:49 +0000
Received: from rnnvmail203.nvidia.com (10.129.68.9) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20; Tue, 18 Nov
 2025 16:52:27 -0800
Received: from rnnvmail205.nvidia.com (10.129.68.10) by rnnvmail203.nvidia.com
 (10.129.68.9) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20; Tue, 18 Nov
 2025 16:52:27 -0800
Received: from Asurada-Nvidia.nvidia.com (10.127.8.11) by mail.nvidia.com
 (10.129.68.10) with Microsoft SMTP Server id 15.2.2562.20 via Frontend
 Transport; Tue, 18 Nov 2025 16:52:25 -0800
From: Nicolin Chen <nicolinc@nvidia.com>
To: <robin.murphy@arm.com>, <joro@8bytes.org>, <afael@kernel.org>,
	<bhelgaas@google.com>, <alex@shazbot.org>, <jgg@nvidia.com>,
	<kevin.tian@intel.com>
CC: <will@kernel.org>, <lenb@kernel.org>, <baolu.lu@linux.intel.com>,
	<linux-arm-kernel@lists.infradead.org>, <iommu@lists.linux.dev>,
	<linux-kernel@vger.kernel.org>, <linux-acpi@vger.kernel.org>,
	<linux-pci@vger.kernel.org>, <kvm@vger.kernel.org>,
	<patches@lists.linux.dev>, <pjaroszynski@nvidia.com>, <vsethi@nvidia.com>,
	<helgaas@kernel.org>, <etzhao1900@gmail.com>
Subject: [PATCH v6 2/5] iommu: Tidy domain for iommu_setup_dma_ops()
Date: Tue, 18 Nov 2025 16:52:08 -0800
Message-ID: <513c71e739d0b9c515a0e7a45248e4a092567e79.1763512374.git.nicolinc@nvidia.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <cover.1763512374.git.nicolinc@nvidia.com>
References: <cover.1763512374.git.nicolinc@nvidia.com>
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
X-MS-TrafficTypeDiagnostic: SN1PEPF0002636C:EE_|LV3PR12MB9409:EE_
X-MS-Office365-Filtering-Correlation-Id: 558ed652-5d6b-4358-1e6d-08de2705f6b2
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700013|376014|7416014|1800799024|82310400026;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?w5x1H0vt8Rk/0A61Kee7nhm/01PQLKrWdRWWCkoL6HDGql7Sz8xv93OjlTHz?=
 =?us-ascii?Q?dBBl7ZShzT67Z1HndmncUdhexQF5Dil+61efaHiZqKxElIEfAtr9/m44+7P8?=
 =?us-ascii?Q?lWMF8Z0n9TJD9oZkIKFoC3FXr5Vt4FwCR4EllNDNub4Um/9Mhl/WDGK4nl9G?=
 =?us-ascii?Q?DuTvxQ3xRXgm+Kke/oR5RcBxXGZp0vHlpx7m3HlGKUIpqCSoAD5L402z58me?=
 =?us-ascii?Q?KBjRP/MP/pvwG3UrNZvLHtahV4XKRlWD42oRbGGA7A7DoKxZ68aWiiFA6GVn?=
 =?us-ascii?Q?1kyYyjJTg0P+qeVyRe9Yvig3RsBHzg51mUOc3fnn8zOtxFiiWLx87wDQW8C1?=
 =?us-ascii?Q?3vTSrWHVhr2zw4e4awcweJJNsKCkt35izyao9Ugwp/rfTnJ78D+cLTPQoOML?=
 =?us-ascii?Q?fkqYyEzRIUPdn1XlPq1TAnHttBje1iY7g0jamHeLek+0nKkX+NDZgDpkZbCF?=
 =?us-ascii?Q?2AhYFVviPk9J40cF/OO2vjGkyxWkLmtVxRfz4rD4WLlGaaPbILa7QHA7nmjq?=
 =?us-ascii?Q?i3FG/mlUoXZ4jtL47qhjX6xx6dOqjcPQQQuFRyg2DjsHP49vCioSJpQOGNBk?=
 =?us-ascii?Q?bVrWGQWKVSTV4TvWKY+AT8wWQ1pB5IkPpuvlHRJ7mbUDNNN10uB9AvyHwF76?=
 =?us-ascii?Q?LDvuwjx1AmtQQzMokl1ofMwVW0yNIREBTjgm6IvwJzn2dYXf4OLgU287ty5u?=
 =?us-ascii?Q?EN48sXINbotf8tnU1k41xM/+UHutUwBZ5BkYnj4obgUCC7GmxtU0L6qfh1ur?=
 =?us-ascii?Q?9P6mW7urEOt1a0s3N/1HDOFnJKifF3AJWgCpMvHFMPZvwWQuI0dLg8hByk/i?=
 =?us-ascii?Q?XQw33ln2Eb4NN2/5E/uAVNcNoVbFXH1yOizh/ls8/RPP/vKJFlDI2tz2W+8h?=
 =?us-ascii?Q?pQhBx1ZSTm7X5NHcIRZD5tK6FOUjCt5RXXdhMrDno6FrR8ajKaFgUnW+V+eX?=
 =?us-ascii?Q?ykHa8S4AwN2RYpCfjkqeS7qyfar99No/0iWLG8DCm+YQw8CkmJ1QciiN/anH?=
 =?us-ascii?Q?EQMqW/NiShKEzUnXACJi03fzR3FMGwsw6XTYtK36iMRXrAk644H3xvl2iFTg?=
 =?us-ascii?Q?5GWVx8b+pY8OVoVV6K8QuWM9dxB+D9dOx50/OnKAa7oNwPhgcd9mPYHUeVoy?=
 =?us-ascii?Q?BF6p7uH587jq07rvUDHgkac8ka+qhA/3p7PaoOShW7HlsU27ME50q8V7E/9g?=
 =?us-ascii?Q?ZOY2ybk60ItSjiZxd6beMmJ5oWsMq1h1fjkSy40w9p67MyeJX8GcQZS2yvo1?=
 =?us-ascii?Q?HtIQgUiCU69pDXfB4iKO9HVzUR47A1G3ds6RN6GmUGdyZX513nqy/cCG5OjE?=
 =?us-ascii?Q?gdlNCGsf3VvnS9+GezVAXMbTklBlOM4onLeHDyIKA46lzBbMZTsnwhU8maBA?=
 =?us-ascii?Q?xpt2l5Aw8CH8Yceoe1mdiyneuvGh/JecBl5UxK1RlJFdrwbHw2nEsqaDPY+/?=
 =?us-ascii?Q?EqsJQhG6VAqo0DlrGRz1KzD6opD1E83OzQrlo1bNph0it4aSk64xEu/fyXda?=
 =?us-ascii?Q?n5X79q0V+as4dwipPdbUQ1ktXMb2Rk468um77km8inB6WMnQ0DUwMRyziVG6?=
 =?us-ascii?Q?seXLUUc5/GdbEZrIY0Y=3D?=
X-Forefront-Antispam-Report:
	CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230040)(36860700013)(376014)(7416014)(1800799024)(82310400026);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Nov 2025 00:52:49.8719
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 558ed652-5d6b-4358-1e6d-08de2705f6b2
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SN1PEPF0002636C.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV3PR12MB9409

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


