Return-Path: <kvm+bounces-66043-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [104.64.211.4])
	by mail.lfdr.de (Postfix) with ESMTPS id 9EB32CBFFD3
	for <lists+kvm@lfdr.de>; Mon, 15 Dec 2025 22:43:02 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id E61883020A2D
	for <lists+kvm@lfdr.de>; Mon, 15 Dec 2025 21:42:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0AC4432D0C2;
	Mon, 15 Dec 2025 21:42:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="fsHdj8of"
X-Original-To: kvm@vger.kernel.org
Received: from BL0PR03CU003.outbound.protection.outlook.com (mail-eastusazon11012033.outbound.protection.outlook.com [52.101.53.33])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0FE4332C942;
	Mon, 15 Dec 2025 21:42:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.53.33
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765834973; cv=fail; b=CnD18jJEkseSMmS+Oc4M9HXknwvFPuQtfJflzxcfbfLoz209zDQDlXDxCgBUzBGXhgk8T1AH2K4sw2EbxPWdXc5/aG7RM4kSGMd3CyZi6DDF1Z0BCqBIDknH+V6aJELsnIBtqG2c0GZLgFo2QkcLKnoB5sbnzTaApthxb18LHPg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765834973; c=relaxed/simple;
	bh=GqcqOS72YzIiQcbj2Ir6WDIrVfFjQyPYTHVv2Zk+PNY=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=HlykS2mG7o+cp+yMl2UfUEmmfMQWyM9XtkiPdIsJAPp2HSck2NjFHWAnTTD2iDozlarJeXnN+G83BBDLTrrXcj/sm2rz4r9/Ubf17XIZaZzzIIQNdas95TZ6qiyB2YIfbPdD1Q93EzWWQ/Q0iTOGXRm9Z/sGkmnuh8e4qeqIjag=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=fsHdj8of; arc=fail smtp.client-ip=52.101.53.33
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=kqmVWg+cScZwqI5aaA+6UIo6TW9lkHlyWr+WMTLfzZMK19sbKnLEfgUJgwgsNtnQ2IvBV05wwUwCUUwkkX2lbkdpo6zB5BqmAGk/Y+jMN1c1d1dKr22TzFUCcyyDiGvyuGy4ObblkGrIWUlY2v1TObJWwE8lu97QI/sMpuCfMeJCMycu5IZnQONgsyxptvWIFqcTfG95sgOw5+mj2t42vMUuzLyJmpmHm/ysC6QQZ2/Jg7rvZpEaue3CRcwDTbp9uXH7SyHgDOaWzOEUrwd7MzTdqp7h6X5PZckQYCqqC73pxoLTlHadWZlMe2ZNcetkvqfTRm3tEXvsQRYhmIsRvQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=riWsnW6hB0/zA+AA1KOBCMc0XajvpmaI1abm81ImIow=;
 b=NooUwdPuLWvNQJbkds8i+cTcQ8oXpIZAFLLnOZXfo+8hFFLdVPOSl3WBhKp6PFduik51WWIxJjh3p+7OFdUiz5ZrEjI8XIYtlg7gx20fCHARZuB/NL9Ec9RSbevkA0uL8oaJCu0fddqInBTXWYE5DksY3z2RYt/4TILong7Ak9qkV4GFDvsVOveeQIrDpL1St9hgBBnUGbo3NeKXBuV/HkjTEXD4ZUIxRQ6pV2rZRUZloKRjJTWK14bUAGU9vTF8bFCnd8vBLJsAqwAE7lAmAYOHI3vqRGTwflrg50rPbunoY5zDbaEssSqvxsOed83WjuKV8pTs9zQn7tpHzIyaEA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.118.232) smtp.rcpttodomain=8bytes.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=riWsnW6hB0/zA+AA1KOBCMc0XajvpmaI1abm81ImIow=;
 b=fsHdj8ofd1Hn3P3+S9tgNmTYA/bm7EnWWfQOz5GiZkrhnSHpP55ZWrn/A8vYnycMVeaLtkGMBdFsxbf6rj0e/V5csxwHmyq3gQzJjra82tqV3SLNXhNQnkou7WWrmZG8NwNzepEN+fYmFcynbjDvda5Eb5aXBgU/1/Tvipdh+bMCV4WsZlB8o5jbdfH3bZuH3naka7180gIcHEcRA1yBE6EwSOdwfG5zhrXI/vXPCsdJZaMVC5fv8SBhy4f+pobw+REb35UUvTqnJbZiiIqTJxVHEjFaB+2immuKFyzVOuT0b4Ex7j21wd7ICnTb7+Uwp1dfpQNjvhU5jzJjhkd4JA==
Received: from CH0PR03CA0295.namprd03.prod.outlook.com (2603:10b6:610:e6::30)
 by DS0PR12MB9321.namprd12.prod.outlook.com (2603:10b6:8:1b8::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9412.13; Mon, 15 Dec
 2025 21:42:48 +0000
Received: from CH1PEPF0000AD7B.namprd04.prod.outlook.com
 (2603:10b6:610:e6:cafe::a8) by CH0PR03CA0295.outlook.office365.com
 (2603:10b6:610:e6::30) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9412.13 via Frontend Transport; Mon,
 15 Dec 2025 21:42:46 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.118.232)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.118.232 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.118.232; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.118.232) by
 CH1PEPF0000AD7B.mail.protection.outlook.com (10.167.244.58) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9434.6 via Frontend Transport; Mon, 15 Dec 2025 21:42:45 +0000
Received: from drhqmail202.nvidia.com (10.126.190.181) by mail.nvidia.com
 (10.127.129.5) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20; Mon, 15 Dec
 2025 13:42:29 -0800
Received: from drhqmail203.nvidia.com (10.126.190.182) by
 drhqmail202.nvidia.com (10.126.190.181) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.20; Mon, 15 Dec 2025 13:42:29 -0800
Received: from Asurada-Nvidia.nvidia.com (10.127.8.12) by mail.nvidia.com
 (10.126.190.182) with Microsoft SMTP Server id 15.2.2562.20 via Frontend
 Transport; Mon, 15 Dec 2025 13:42:28 -0800
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
Subject: [PATCH v8 1/5] iommu: Lock group->mutex in iommu_deferred_attach()
Date: Mon, 15 Dec 2025 13:42:16 -0800
Message-ID: <cb38f91526596f4efd0cd1cffa50b4c1b334f7a4.1765834788.git.nicolinc@nvidia.com>
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
X-MS-TrafficTypeDiagnostic: CH1PEPF0000AD7B:EE_|DS0PR12MB9321:EE_
X-MS-Office365-Filtering-Correlation-Id: 09fd4fad-a020-45ad-1ed2-08de3c22e295
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|82310400026|7416014|376014|36860700013;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?XqOQfS3J/VzuTm4BkZOOfdIBBk4UN20Q03DJqOXprvOq17xo4NShSKkKmM36?=
 =?us-ascii?Q?CK5Tm8u7o0hA9DRWb02tLuaZY8Q8AYAgZGMddWiU3uCQfffUHe62hORdim5N?=
 =?us-ascii?Q?SIMg9jv48Ykvg8C48QigZmnoDKOn0mppawvRINoSiqnyLycYeY+DRThWFjkO?=
 =?us-ascii?Q?0AiyOk5QUjEJXbRPBGkUZqguFmGTG+e9GmcXObo4FwC67inKYL1oWTQHnhk4?=
 =?us-ascii?Q?LIJY/+4Z1eDdtbTVaPnomyLC9gW9DLgeO9GoxAEY4+MyLbj+rnQ3GIFpOfCF?=
 =?us-ascii?Q?XJNHQko+OMvMj3J7/5V22/of8A3LcUxqpjhxOD5vAi02rEOn4/0VtVmDCxnL?=
 =?us-ascii?Q?WZ+T3w4UAB6ckW8bj/fBj45B/ConFdZjfnZD8ufG6iGdUDSA8+1Ya+hXQjIW?=
 =?us-ascii?Q?eZLjQJ+I4Xk5Bru7IMMnmTPqEW9zFtk4FjL+jhgNpEndMdmTVO+2SyVJacmI?=
 =?us-ascii?Q?o1lAasVLeBWrs8T/xbFuWLu95RRvHB+qSMcv5ZEiya682EtypnMhM4s5GKYB?=
 =?us-ascii?Q?a7nhj/cmrjFQEJ1ZMIr2t3ceuRZDL4e5R7PgUmGH70qMoDf8iI9OgFC4dTnU?=
 =?us-ascii?Q?D+osmG746x1nQh+pgLyvKsB922j6N2n26MZUG71aTZ/jf/NJ/ac3R+oDkbie?=
 =?us-ascii?Q?JHkmD9WS8ojaZ7DNCFFA1qX5yx8Hf86f1xnky9soJGEKRowVygZrC0XxH+j4?=
 =?us-ascii?Q?CMfIhNWmn9ah2rNFRrW0QyMItnpgVGMq21+Nnb+yo0AcKjdUFnEcnZjq3i/K?=
 =?us-ascii?Q?hQeNPASEYWUmo+pAmbd2UNWYA2rrsGenA4Y5mvqNEIfElxgTH58C3mM17v/T?=
 =?us-ascii?Q?KJDPkwajzN9/mSJdAn6I9SfTYFenO3X2zVLUFO95n+9avTJBsR5hvMF5Ikhm?=
 =?us-ascii?Q?bbSuDUG4a1cKeSZsLW/wSbsUTrV7xWklma1+joRCG4+5j4BBCZ8qeMF9ci/G?=
 =?us-ascii?Q?DjQUwb1rTBXuiobW75nLPSWXDRByeeb3YKzWYTnejmEtgjZCZGuUaaWws7FH?=
 =?us-ascii?Q?L6chPnptDxyfLmNRmJulzpps2UemgTb0pjbMdI+S598NZp2M2V3EduMqeu60?=
 =?us-ascii?Q?OvNKgsritwU7zh7s+W2LjPvoXIMk4n6Zzv4zQyiEYqfLMvYM6OQ97cZVnS2x?=
 =?us-ascii?Q?DHQSqbQv8lwwR0ymkBCpyzSRPE/M2MmgXeC10Mtze6m69TntGrAHLkID3+8D?=
 =?us-ascii?Q?+nVnIKx9bwd+W89FiICbW9SoqOHwoCTtVQF1EIc+6fLi8D2GLE0JUb5T4UTe?=
 =?us-ascii?Q?3st4vC7uxUdsV7YlLrCMIVvUQFaJdi8ph2PbOx9EsdOh5XAd4zdFTIALnmPF?=
 =?us-ascii?Q?eoz/OphZ//IibOQ6HOhGoJ2IoJ/DDjvw81iIdBkIbPWuFfn2XgRgN4RAoP6S?=
 =?us-ascii?Q?AL2qfzHZi/EYFLpn95EQBooiNEtp3SZfNiV6RaFaANOCXiu7xVVWslMTEz4x?=
 =?us-ascii?Q?+hyyI+Zw5ux68kMwWZskulY11aCg7TYGYBbVbMPcoDzFDdNI0gmUyCwp+SYq?=
 =?us-ascii?Q?kGtgIlJ3l2L29ss8QYORVQdlhec9vQbei5sAZ2imwfJdhm/3sHybMtmz6Rxb?=
 =?us-ascii?Q?a54HzYH/mhM5JxRFO9Q=3D?=
X-Forefront-Antispam-Report:
	CIP:216.228.118.232;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc7edge1.nvidia.com;CAT:NONE;SFS:(13230040)(1800799024)(82310400026)(7416014)(376014)(36860700013);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Dec 2025 21:42:45.9629
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 09fd4fad-a020-45ad-1ed2-08de3c22e295
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.118.232];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CH1PEPF0000AD7B.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR12MB9321

The iommu_deferred_attach() function invokes __iommu_attach_device(), but
doesn't hold the group->mutex like other __iommu_attach_device() callers.

Though there is no pratical bug being triggered so far, it would be better
to apply the same locking to this __iommu_attach_device(), since the IOMMU
drivers nowaday are more aware of the group->mutex -- some of them use the
iommu_group_mutex_assert() function that could be potentially in the path
of an attach_dev callback function invoked by the __iommu_attach_device().

Worth mentioning that the iommu_deferred_attach() will soon need to check
group->resetting_domain that must be locked also.

Thus, grab the mutex to guard __iommu_attach_device() like other callers.

Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>
Reviewed-by: Kevin Tian <kevin.tian@intel.com>
Reviewed-by: Lu Baolu <baolu.lu@linux.intel.com>
Tested-by: Dheeraj Kumar Srivastava <dheerajkumar.srivastava@amd.com>
Signed-off-by: Nicolin Chen <nicolinc@nvidia.com>
---
 drivers/iommu/iommu.c | 13 ++++++++++---
 1 file changed, 10 insertions(+), 3 deletions(-)

diff --git a/drivers/iommu/iommu.c b/drivers/iommu/iommu.c
index 2ca990dfbb88..170e522b5bda 100644
--- a/drivers/iommu/iommu.c
+++ b/drivers/iommu/iommu.c
@@ -2185,10 +2185,17 @@ EXPORT_SYMBOL_GPL(iommu_attach_device);
 
 int iommu_deferred_attach(struct device *dev, struct iommu_domain *domain)
 {
-	if (dev->iommu && dev->iommu->attach_deferred)
-		return __iommu_attach_device(domain, dev, NULL);
+	/*
+	 * This is called on the dma mapping fast path so avoid locking. This is
+	 * racy, but we have an expectation that the driver will setup its DMAs
+	 * inside probe while being single threaded to avoid racing.
+	 */
+	if (!dev->iommu || !dev->iommu->attach_deferred)
+		return 0;
 
-	return 0;
+	guard(mutex)(&dev->iommu_group->mutex);
+
+	return __iommu_attach_device(domain, dev, NULL);
 }
 
 void iommu_detach_device(struct iommu_domain *domain, struct device *dev)
-- 
2.43.0


