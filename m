Return-Path: <kvm+bounces-63638-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ams.mirrors.kernel.org (ams.mirrors.kernel.org [IPv6:2a01:60a::1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id AB569C6C2F5
	for <lists+kvm@lfdr.de>; Wed, 19 Nov 2025 01:55:57 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ams.mirrors.kernel.org (Postfix) with ESMTPS id 2BF04347912
	for <lists+kvm@lfdr.de>; Wed, 19 Nov 2025 00:53:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 89588221542;
	Wed, 19 Nov 2025 00:52:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="HEVTIho5"
X-Original-To: kvm@vger.kernel.org
Received: from BYAPR05CU005.outbound.protection.outlook.com (mail-westusazon11010035.outbound.protection.outlook.com [52.101.85.35])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1AFC2218E91;
	Wed, 19 Nov 2025 00:52:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.85.35
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763513571; cv=fail; b=RIiXLoZZVzU380UNE6dUclqiqm11rDgPZ/Bx4KUcjtBdM33JBI8P+akpXbXs1yZXkdAg+AwuUc/n16P9uZgM5PROnqVK1ELG037+BqmiQpK8fhbNubuazVI2uDA/ItLGzGddYAxUZ7gqecmjcQP3F7HvrsUPHCeuoEfdTH9B06o=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763513571; c=relaxed/simple;
	bh=zygvyRf8iVJZfTeOONOEj6jHA6bECqcSFQ3liTODmy0=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=AIR8WxwVK0ZBKkM151GrdN2F0jyRJxAOfj5sRJy/fZ2SgYOdxOf85cpBhF4/etu5nIXfElqZ1Lhy8gdimkfMvB6FEWY8jdP3CORAHEetxGVUi0IGxyZHYLydm37Fd8lOkXq/6w9kpJg5RkudBtX6GHh+xl6+VEdFQtVRw6vWw7s=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=HEVTIho5; arc=fail smtp.client-ip=52.101.85.35
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=NcNr1QEr0ZKAvAwrzQd5K02o0FuT+lm8UqvFXTtSdMuBA7C38xE+r7Haxed6+0ELGn3vkExIy4vLuGzRt9K5dnIn2D9fFB40OjRR9AsFx3P9+2Z68WY11oKJINa5ddcgbRH2g4RMch1NHmKZTcvxqSAwy6svbybrgwrBOvzUmFxbs+BqkFrKtPvDoaS4Jsgsya2/o0EuyP+9X522Y8uNcr+jVS7PRXRUema5hgbd90PbKh95AizKWyGhdDXaA6iCFALrM/HSt3JefTXLIjms4rAhfZkwVodeC5fr2WartpdNWCi6dVQ+nHLDlUsw33sKJRyI2H3um+FE/HHg/AHk5Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=mNY9x1RtcvkkzqkoxtEh/9kLnwrlK2GzglZgK+WuMC0=;
 b=Rd8/RIVx6rOi+FyR7M8lnt91J56oxWQLlJM36huZOxsF1YMWwCtkruRLx29zKFvTWSub1lHxjtk/N2WwrnzyYNtm7NuCMaeKTgccxC+v45fVYgk5fx+9TPfDWnzT+wsAX+zKckgGKLHLz9Og7JHneZN/wD4ukheJRwGcQrcmQD0cAX+7R9ncvzln5Jo8KOPREWuHaWfxU71KDj6303SQqAOZNt+HNvyBRbgMcw+UsJlL1yKKDNXSdWEsPEV/k3rWWfJtx4ZuE3go12qZa6X6gfThCrBzG53FDer/mOZ/4nP1c7rkivEmRa3tDbpg0yeeI0gfxF6l6WADrmiPmvkZLw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=arm.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=mNY9x1RtcvkkzqkoxtEh/9kLnwrlK2GzglZgK+WuMC0=;
 b=HEVTIho5TIFeKJxLO3rGoOUehtCasKljbwQIS3ZWoDl/RXmTQAioslX+h0JrRTB9FqaNS/2R4OxIeVxfKVy1JsyZzw4PseZ1HdvduwfHTb0yT947C+xsXfHTzce4UrK1kbxONfQCdJqTVUMT8xxGuXABrRj25C1tEelVo5MdXElqUYCKKL6U3gnJJzfv6aTC1eNe84HXs4mPc5yauIln55sUIDcGq0jT0kSDvfyL45H55g14tPiwb6rCVeK3wx59S0t44bZETthXEgKXbymWsZV1bXjumNngiFN8DGQu/l03KRGpfCSTFcSi1fvSE48l9yku8VW2YhcaeAXVHFvuUw==
Received: from SA0PR11CA0188.namprd11.prod.outlook.com (2603:10b6:806:1bc::13)
 by LV3PR12MB9266.namprd12.prod.outlook.com (2603:10b6:408:21b::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9343.10; Wed, 19 Nov
 2025 00:52:46 +0000
Received: from SN1PEPF0002636E.namprd02.prod.outlook.com
 (2603:10b6:806:1bc:cafe::d4) by SA0PR11CA0188.outlook.office365.com
 (2603:10b6:806:1bc::13) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9343.10 via Frontend Transport; Wed,
 19 Nov 2025 00:52:46 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.161)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 SN1PEPF0002636E.mail.protection.outlook.com (10.167.241.139) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9320.13 via Frontend Transport; Wed, 19 Nov 2025 00:52:46 +0000
Received: from rnnvmail202.nvidia.com (10.129.68.7) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20; Tue, 18 Nov
 2025 16:52:26 -0800
Received: from rnnvmail205.nvidia.com (10.129.68.10) by rnnvmail202.nvidia.com
 (10.129.68.7) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20; Tue, 18 Nov
 2025 16:52:25 -0800
Received: from Asurada-Nvidia.nvidia.com (10.127.8.11) by mail.nvidia.com
 (10.129.68.10) with Microsoft SMTP Server id 15.2.2562.20 via Frontend
 Transport; Tue, 18 Nov 2025 16:52:24 -0800
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
Subject: [PATCH v6 1/5] iommu: Lock group->mutex in iommu_deferred_attach()
Date: Tue, 18 Nov 2025 16:52:07 -0800
Message-ID: <bad420df60c3ed07a51591ce3ab001d7e4254a2a.1763512374.git.nicolinc@nvidia.com>
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
X-MS-TrafficTypeDiagnostic: SN1PEPF0002636E:EE_|LV3PR12MB9266:EE_
X-MS-Office365-Filtering-Correlation-Id: a7f236d8-e029-4ffa-bb6a-08de2705f483
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|1800799024|7416014|36860700013|376014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?zANtdOEQOoaoCYcgF/VIBLoMMYm+vCkK5rFq/pWAxF4+kt6twvwobcaI6h3I?=
 =?us-ascii?Q?QqC875t1ofMAorlF7gDQ1wCdBcqkmN9ai2jFWcREGmY8PH2F1thj3xamTSxV?=
 =?us-ascii?Q?HgwPpXjyYnQBrP3svzMjAwl3vHFfNi2cEQUcLid2Su77jwSw9v719yL3R5fB?=
 =?us-ascii?Q?yK/qRkqeAEhr6ToNTWfdi6N6uPm6IubwxYSMtyEL2Ga++KiM0Y5PU7KNpvaj?=
 =?us-ascii?Q?tWGwKuu/jPGL16PXzCL8Kcn1axqm6PJIosZfiSxYhhOrsr5w1Lr4n9zbWGkN?=
 =?us-ascii?Q?ETvGuUufgbzHYSpt5VVgjJZK6wPkdGM7nmRbVxfPGeuZZN604juEahdwzbIv?=
 =?us-ascii?Q?Jl7kI6AyBVSlcu7FNqE/7jQCmKumpleHpG2eBot3NZ2204HxK28sT8BmPQlB?=
 =?us-ascii?Q?zGGlHaeqUc+dILi6BJeOyOHH9S1U5Cq2w1+JW9d9uqxsIafvTaJ9JGQKc9/N?=
 =?us-ascii?Q?gGstc8qgD9/zLwAIn9SM2z/zCpArLOyAhvYVFqvwTI6B1X77zQxJ52qPyuM8?=
 =?us-ascii?Q?ThroZosjl5hsY2eKelrCutiZZsLOcPXdXp5uM0FE+toZtDbqBH6O0orMO8Wr?=
 =?us-ascii?Q?KZWd7RhoyyxkjLsSTAPkaCRKyotq0n7gXqXwsDl4wQORrZCgRXUPNUywdu+2?=
 =?us-ascii?Q?8A2zwf+oNOvJfugtJdTuTpJF/p4ROS2GUF4mE8fIaut4+kSOiqJyo9iwHN/S?=
 =?us-ascii?Q?0tZAMo7zq0Ty5xEDPtWrLoG+q1zVMwvUV9fNrybhaVutdxt4vbRyxLNfydXb?=
 =?us-ascii?Q?u+MFTBcBMG0XGSt/PSMrYJYYMhdeIzNYFECK+Zvwh1WIeg/IxB3xyjcll9qN?=
 =?us-ascii?Q?ivpzQSW5gBk/AWqRYFPyOQ7JEBft1NYXwn5UGByIEjxI7C2mPiBWGyryR63V?=
 =?us-ascii?Q?l3X4pLIEZYdS8/VJ1ZMfSWuBCN6BQdCFotPI+xEtgldMahEBn9uwfQGhvArF?=
 =?us-ascii?Q?R+0BuLpYliWbCHnhIOYUc8nlgOV16EhP5w8GIAHYJWGG4DW12m5pIbjxQjvz?=
 =?us-ascii?Q?CcgPxOEcHLJcOW6IZdmuh2n7Z0CJh4+eFrsrzPdSRXhk+P+XzsvT0o7QzM8L?=
 =?us-ascii?Q?BWhJKQOE42o+CR+s7eDjMUzTtAw6Kl3wZOl/h1Onq8GtsOSAOF7nbKgLOecl?=
 =?us-ascii?Q?Ubeuxu6zDeq2bZvel2rl3jMUj/sbyVm5u8NTRPyOkJTpLYrhSdcVs/1Rmj6u?=
 =?us-ascii?Q?X4SI96/3x3cEVelw6TsU8b9yOicoNTY3Fcjh9/Vp3TE260S17TFodWxyA7gb?=
 =?us-ascii?Q?mY8LNe/xx4AuAQ2uw/TYdbsAqmJ5td762Vk4QuhrYRTmW0ohuVftd9bhgImU?=
 =?us-ascii?Q?qtCaafs8hErI6FAcorJgP5j6WdlhyEbjz8UL2jmpk+e+0u92XupXZ+D0QUPP?=
 =?us-ascii?Q?v1QHYNC4IOg3h/1QUIF9j8ZKPy/29zfJ1C7s0Up1+qq65X+MFRqoD2eTrkZ6?=
 =?us-ascii?Q?MBK3rgYuogvZFax1rqzijUKYZZeoSxJh8NnxELT3cJ0ONfpdRpJXAaYAoazA?=
 =?us-ascii?Q?AKOLTmcXofGpQFvVFAC9JSLh79I4axb18ZwkxfAw6pbBYOS8HeDFCNPAMExJ?=
 =?us-ascii?Q?8IzGEp2nVo7edwnw8Pw=3D?=
X-Forefront-Antispam-Report:
	CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230040)(82310400026)(1800799024)(7416014)(36860700013)(376014);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Nov 2025 00:52:46.2392
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: a7f236d8-e029-4ffa-bb6a-08de2705f483
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SN1PEPF0002636E.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV3PR12MB9266

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
Signed-off-by: Nicolin Chen <nicolinc@nvidia.com>
---
 drivers/iommu/iommu.c | 13 ++++++++++---
 1 file changed, 10 insertions(+), 3 deletions(-)

diff --git a/drivers/iommu/iommu.c b/drivers/iommu/iommu.c
index 2ca990dfbb884..170e522b5bda4 100644
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


