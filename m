Return-Path: <kvm+bounces-62706-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ams.mirrors.kernel.org (ams.mirrors.kernel.org [IPv6:2a01:60a::1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id ED189C4B827
	for <lists+kvm@lfdr.de>; Tue, 11 Nov 2025 06:14:03 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ams.mirrors.kernel.org (Postfix) with ESMTPS id 342E034D8E2
	for <lists+kvm@lfdr.de>; Tue, 11 Nov 2025 05:14:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E2FDA31282D;
	Tue, 11 Nov 2025 05:13:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="Aqaw8UXj"
X-Original-To: kvm@vger.kernel.org
Received: from DM5PR21CU001.outbound.protection.outlook.com (mail-centralusazon11011050.outbound.protection.outlook.com [52.101.62.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 49F9E28642B;
	Tue, 11 Nov 2025 05:13:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.62.50
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762838012; cv=fail; b=Mv5fg5cQMsQnMZ0d2erTmbvtEJOT9wUM5sVU7sFMv7k5tEDl5IqbMQce1dQrSL2ZTBKwAIEyBjSCLqosknZ83397JHMGXVV2gIuPXOYoSQdWzvkLZqMS81MnyxXuPTqOF+ZWHdRYHZtOiQyB03H3x+CXuEr9XmyCk5etJdQQ3Nk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762838012; c=relaxed/simple;
	bh=r2RDsAzgdaE/JyhAeXDikklT+ili752HmUOOVlhePiE=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=MTCf7jg3bBXj0gygedhkvEWQSOOBXbYcku+3Z3IYuLzMTDkdAqvvi5vnKqcmJB1A5k1LZBGhI9hoQFpZeJ/eeX+vhz+SrnFuMYuWcaSjBWWGhf1uI/dGW3LZHhlcy0tKsd32gWok1aPpp+yzJVYbG6+zYcj01HHU3V0RoBEi16Y=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=Aqaw8UXj; arc=fail smtp.client-ip=52.101.62.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=sfcOKtQW5mi4OKEaFzo8anSlvzNL/+tXBnZx2r5XemDNoVITBMuHRtCUhcvAuByOkSLmLEOSTL95bMzyI+uiwGagQKAEPGJokXrT614q/m3629JxMF7xNl4qmH5U9AK+mBwZguohK05kpdqi4dIRPNv8IoSPx9DusqjQYXyiAkUjgmuxiwDT9tYAHK5svn5IrzTHovQn8glOgm7eCbmSV/QN1VnF7j16lAzqkD73fVt3eZ+cpMBPKgYKIl6k5zX+nD4g4i0p6vuOyPxTFwIxiocEmTU5nQe23RFnNwBhwkbkcZoXWPetEuKbgln0oATPNeqax25IQMMgDsXNxYbozQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Api3QGiN1vZzzSxnCPcJpwGKKtv9U8wUa3/s+H4ug1I=;
 b=sebBY1Fc+Km9XCUKkCqbx7odEUy94sh9Qk3pHUMY7sdm4WjmxMkxId9t3U+nmRj19QVFPiKcE/tTt/H6DhZNOMfN+DpqPPI+D4d5mNqHYklvF2fbxoCJJg8px4VkygKSU62AojeDULp7tVhv4iFRFuIJpT4aUy2zGLYr+8VVaqwiuML2g1zWhTHlZIiAs2w86wLoRxJbE1cei3EBMZoAGNdBhP3pXNw3W96Qbs3q6f+pimSa4mlYti0/KZQlul5VRAcJD51pWrzKrDfEBNtDu1Resnd3di7/kwHihcMsuCPRyQiZva6ZZoBgwe/NoczStkqMmCtcxNoCWVzk4VfMfQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=8bytes.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Api3QGiN1vZzzSxnCPcJpwGKKtv9U8wUa3/s+H4ug1I=;
 b=Aqaw8UXj4MR8SBX3p/NzkEwWiAoE63zcqe95hL8pHnQCPEFGnSTLvNxOv8VFy4YFTnKHXi2TpWJ9m3Org3wN2nxd6Ylio1bXlr/2jYctrzasc3j8vskxdWJaJsv4XLHfxWl/Xmx+cPISnBKl4ICbGkT8uX55XP1i7FYAA70J/sFt1Alq424gp/Sd3ZyNl6UE5F+aahbO4mAcB4bf9EBgt9FvD0D9R0LE7T7oM5bRGDhPauluaoRA5p/84/qxGPFT7DotAipIshyvj5TFDLW0Usqx5HpTP14v2aKV8Qls3tDvpUe9oupgPPwvMIV9cBWWGDD2uebcEPJUhlQKii9fjg==
Received: from DS7PR03CA0002.namprd03.prod.outlook.com (2603:10b6:5:3b8::7) by
 DM4PR12MB5867.namprd12.prod.outlook.com (2603:10b6:8:66::18) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9298.16; Tue, 11 Nov 2025 05:13:25 +0000
Received: from DS3PEPF0000C381.namprd04.prod.outlook.com
 (2603:10b6:5:3b8:cafe::b2) by DS7PR03CA0002.outlook.office365.com
 (2603:10b6:5:3b8::7) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9298.16 via Frontend Transport; Tue,
 11 Nov 2025 05:13:09 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.160)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 DS3PEPF0000C381.mail.protection.outlook.com (10.167.23.11) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9320.13 via Frontend Transport; Tue, 11 Nov 2025 05:13:25 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20; Mon, 10 Nov
 2025 21:13:16 -0800
Received: from rnnvmail204.nvidia.com (10.129.68.6) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20; Mon, 10 Nov
 2025 21:13:16 -0800
Received: from Asurada-Nvidia.nvidia.com (10.127.8.11) by mail.nvidia.com
 (10.129.68.6) with Microsoft SMTP Server id 15.2.2562.20 via Frontend
 Transport; Mon, 10 Nov 2025 21:13:14 -0800
From: Nicolin Chen <nicolinc@nvidia.com>
To: <joro@8bytes.org>, <afael@kernel.org>, <bhelgaas@google.com>,
	<alex@shazbot.org>, <jgg@nvidia.com>, <kevin.tian@intel.com>
CC: <will@kernel.org>, <robin.murphy@arm.com>, <lenb@kernel.org>,
	<baolu.lu@linux.intel.com>, <linux-arm-kernel@lists.infradead.org>,
	<iommu@lists.linux.dev>, <linux-kernel@vger.kernel.org>,
	<linux-acpi@vger.kernel.org>, <linux-pci@vger.kernel.org>,
	<kvm@vger.kernel.org>, <patches@lists.linux.dev>, <pjaroszynski@nvidia.com>,
	<vsethi@nvidia.com>, <helgaas@kernel.org>, <etzhao1900@gmail.com>
Subject: [PATCH v5 2/5] iommu: Tiny domain for iommu_setup_dma_ops()
Date: Mon, 10 Nov 2025 21:12:52 -0800
Message-ID: <431cccb8279eb84376c641981f57e9ceece8febf.1762835355.git.nicolinc@nvidia.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <cover.1762835355.git.nicolinc@nvidia.com>
References: <cover.1762835355.git.nicolinc@nvidia.com>
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
X-MS-TrafficTypeDiagnostic: DS3PEPF0000C381:EE_|DM4PR12MB5867:EE_
X-MS-Office365-Filtering-Correlation-Id: 38564999-91bb-4563-4cba-08de20e10aac
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|1800799024|7416014|376014|36860700013;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?zG8gvNsIyFrZrLPDUyJYLoqlzrF36NEGaemyqP3aKq77RJQZ2qF21kFRE1tm?=
 =?us-ascii?Q?Dx2TV7P1BJJ3mMk2Vk1i81KK/gmgZjnr0OATmVcUESJ0pM8X3o46tBn+f40o?=
 =?us-ascii?Q?e6ujWxiL7tCXu2OMMJ7E+0jeEm5eqUJ48jz7bfT63qvKUZu1jeMKao+/ht0D?=
 =?us-ascii?Q?F0Oew00FhUXkYQ+FA3ZcK6p7SYo3mYAhGtOggrhYLCUkJI6sOHAPT7Rjx3jE?=
 =?us-ascii?Q?8JqCFu29KyN911bLRYo6fdlK9yLZevKBSbRx9NAFAVb2Dpur+exzFMd2qrR7?=
 =?us-ascii?Q?JsVKqgJvaGH2LUJMyxbPTXsRZ2G/GbUbnwaW0K4WjlEEDUp0hyAZSZgjKVPz?=
 =?us-ascii?Q?pjPHs0B8T/spTRnI2wlhcbOZAMr7Et0g1aQ1a6pxXAwkEkKEXOByAL4fVIJ2?=
 =?us-ascii?Q?6ymWt+fFpusITnexhDmcd8B2HqqsGllKhPfF38AjkKt8IhIcJtEmomgtDFYL?=
 =?us-ascii?Q?VnMNjFzQt0zQ+t+Uw94jqGBLTZHNOnrZJWJmCQ5yQrQPRx6tJMTKfzBOyOUw?=
 =?us-ascii?Q?3IJwOXXhAELVEJIBRTgHL4WYNRsmIA7lhdbIeFmWJa+QCX7vqvsMmJ77NBdl?=
 =?us-ascii?Q?CuZS9o0Y/jRioqnLFwPLgs07UCVH5g9+v1HnvsHvPlL4pScRXe5v6UtqFd1r?=
 =?us-ascii?Q?OPEAn5oP7OzIKYkh6r1ed4DymXUpuVih0tbPrFc1UjPoPu+zNQ2uPokl94Pf?=
 =?us-ascii?Q?QN824oebwP7cJEt7Y9SYNMYarQEs3Gyz8/0/6Vk0X1Vv4sPFzYQ0hkaOayW3?=
 =?us-ascii?Q?VPjJoonHGn/GtjkHoS2DZLTT8S83T2IeKchldDoYDDnhfZwPuQiGK76gUv0W?=
 =?us-ascii?Q?HCZSyeO8kC8PoPQ7Kp+IaQi07qR29aS1YPKQnC5LO72pvT+mSdLe8GkvRB+d?=
 =?us-ascii?Q?OyccoorP/zV6lO4L5if7Ud3cQ7oToQRLV79OPNlQLGaPBDIfgY08Do9RUowV?=
 =?us-ascii?Q?w5TLinsaXKN74bal50j4GFrQIAJIZA3ahluY9XkUx0UQeHhC1ijOmdAriphu?=
 =?us-ascii?Q?1YskXs0As03reFyoIRK822kts+Rc7Rva0SrubohPygChRwZwNk8Aa9vGlPGI?=
 =?us-ascii?Q?nhLbNsZCodidRZkfXhMOYYyDB7nPcphTQIvIllpVmZu84vkufX3WhnjMYU7o?=
 =?us-ascii?Q?fiPYDxFc0SpaGY6Q2NSLee1qoyZsY+gWGqXUihZ4D1Ll0BGRjZRsm0K0TH5p?=
 =?us-ascii?Q?tIVSFTPL7EhYNpZCfHKzz11NjdXtUBVQGerhHlR+LE6ECv5hdQFWp9O1BK5g?=
 =?us-ascii?Q?QFYL2uEgLNdaF/aAVptUOoACjV+zHGNLRNCoIvVXeOtAfym5o8kJzUmCo0M8?=
 =?us-ascii?Q?xRrJe+Orvb6tQuu3XSlMze8WoxCGMP41hxIBZ9kqRW3lCj/oeln216PUhO/x?=
 =?us-ascii?Q?iEQd4aoV0TBGwTvQ1s+ohV5STxHU+RUfbjNnHSAyxRuhuPj/ptE8QmctT32H?=
 =?us-ascii?Q?3rGF2u1dJCsHXI0xzAZ4I6wcf8ahAPJvBEAgklJiLolrVZClWgBcl7DfI464?=
 =?us-ascii?Q?GJSxhAqtM8c0rvvPYBGs9BM4vT4lx48jgIbwtYvNXEa4f/yEeGH7FI06HywG?=
 =?us-ascii?Q?v0CrCSnM65X0tQpN6R8=3D?=
X-Forefront-Antispam-Report:
	CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230040)(82310400026)(1800799024)(7416014)(376014)(36860700013);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Nov 2025 05:13:25.0859
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 38564999-91bb-4563-4cba-08de20e10aac
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DS3PEPF0000C381.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB5867

This function can only be called on the default_domain. Trivally pass it
in. In all three existing cases, the default domain was just attached to
the device.

This avoids iommu_setup_dma_ops() calling iommu_get_domain_for_dev() the
that will be used by external callers.

Suggested-by: Jason Gunthorpe <jgg@nvidia.com>
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


