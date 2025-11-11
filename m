Return-Path: <kvm+bounces-62705-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 19F90C4B81E
	for <lists+kvm@lfdr.de>; Tue, 11 Nov 2025 06:13:44 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id A40653B0ABF
	for <lists+kvm@lfdr.de>; Tue, 11 Nov 2025 05:13:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 56AFB2BFC73;
	Tue, 11 Nov 2025 05:13:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="VDjrkfcT"
X-Original-To: kvm@vger.kernel.org
Received: from MW6PR02CU001.outbound.protection.outlook.com (mail-westus2azon11012005.outbound.protection.outlook.com [52.101.48.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CBD59192B75;
	Tue, 11 Nov 2025 05:13:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.48.5
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762838008; cv=fail; b=MPag6dEBhVKyXPTLbqbN3YUjUoMwNjR4l57lvne2fBRnSnvxUg8K0HWdG4E2GODTxesjhrPtXKIlxCXhrlZ1HIcjEtqnHL6mn78YNcE19DvDcDq0Bo5PPr2h+vMf+Ma8le8GZCS6Mm+1mzOIhQbleSFGIiPgGVeuVB+B9VJSbPc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762838008; c=relaxed/simple;
	bh=CVXjeL4ilGYdwcF07mQ1whRrqVOfrJ8rKJ1rJ8o9c5w=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=lQSr1PIRQLVoJBWpFKngOFQHuMT1GFzoKWRHIPB3L+jKAfNkGIpVGWn5b6EppAKW2lek4uJnuSnaAmnGWjYVq5UfW3KGJRuxfYgEgjLka8JEsedtZfQdnPWO9vU+KPt0epBtrncgQAbhHA2tqVMuFJ2tFVyHNmyN7S0nyC20H+s=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=VDjrkfcT; arc=fail smtp.client-ip=52.101.48.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=YdPiRvOJNQzQSO6Pe/S59Of92lcHAq28uyKcsUDA9LmBngxYrO7yLKmZ3okGtS73f8Aq7l56waQcc2NbquvTY6lTNbtok4HgJjDNFu0FNvi9slSuFrMip8lPazDFiqOW2eoOJn83wiPc+l4VtS3Fh0Vcznjk0ZFSmlsaIIALo7sKEUpT3tCD5XnqAt0zB3WH07+5UQ/AwEWqMQ2iDOVvJeWv3CcxvMjLfK2Pf99wmjVcp/jhiJKnJa8kYgtDResBkCGqFRrS788rkednP/LZPzlH3xYg5bmVMHoSy3fx3y9W0/K23rMRAbf7+uqpCktkESOIT+T5RqHctCMjTul8Ag==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=SfLY+StWgd89RasNXxXggmjoiUuGiW941YAAIzfupLw=;
 b=N4TTtaXpxFnNtF64ks3dhwCCedodIZM8xLfcs2KO2FsON/tZHpqOFo6cTComH+CJtY2Ld88AGaStifv4CJJwKr2nT+wj+rw6nzzcsb2Nv1FwztZWAPaHcy+2bOh72o7cw8nJEI2aCl4mtDXDTH2zfZ4m5DLOiCVyFkUStA1Kc7yxIKPYYw5MG2fADw10eTrZn54pA8lmxpwJ9PMyjKwzovl0Sj7RbCM8AyMSIlLoUt9Dfj5o91kAreupOpNUKhF+HT1y4csqfaQcAqmAVm2lOXh2r5ihiTJFG4wP2duBHqcorYEq1AImLidn6w2BECFdM5mzC0Gv7onraAC2eiKzyQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=8bytes.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=SfLY+StWgd89RasNXxXggmjoiUuGiW941YAAIzfupLw=;
 b=VDjrkfcT1TP7Vn0JP6yXLUIosUDwA73f4LZeEgUniXEGsfJ4aFJKWjmq0NvYMSI0JccoDDvPaO4I9LOu6qRnYMiZWE3+hSbt+qebV+CC46vSEEA54Nzf31nK8GmqWyzvfWasFtmbTRMUGYVMuwuYDtdKciOtCF4kBOyeipmURSqRFZ0sxtPOmVkR0rE+oqulZ16M+YU21uWAQHimUTojxx7ei5wbE3/zeMvLjl7nQPG3GelFnExykDjlyAR+XLHRjtmmglk8TLgIGi+kZUYGacCv5EZkdpBORcJChxkMIeUjCdCs6Y+OFGSkbhhjMkuwLOCgfrUsr7I+NrphqPOkFA==
Received: from DS7PR03CA0027.namprd03.prod.outlook.com (2603:10b6:5:3b8::32)
 by SN7PR12MB7883.namprd12.prod.outlook.com (2603:10b6:806:32b::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9298.16; Tue, 11 Nov
 2025 05:13:23 +0000
Received: from DS3PEPF0000C381.namprd04.prod.outlook.com
 (2603:10b6:5:3b8:cafe::3d) by DS7PR03CA0027.outlook.office365.com
 (2603:10b6:5:3b8::32) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9298.16 via Frontend Transport; Tue,
 11 Nov 2025 05:13:06 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.160)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 DS3PEPF0000C381.mail.protection.outlook.com (10.167.23.11) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9320.13 via Frontend Transport; Tue, 11 Nov 2025 05:13:23 +0000
Received: from rnnvmail204.nvidia.com (10.129.68.6) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20; Mon, 10 Nov
 2025 21:13:14 -0800
Received: from rnnvmail204.nvidia.com (10.129.68.6) by rnnvmail204.nvidia.com
 (10.129.68.6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20; Mon, 10 Nov
 2025 21:13:14 -0800
Received: from Asurada-Nvidia.nvidia.com (10.127.8.11) by mail.nvidia.com
 (10.129.68.6) with Microsoft SMTP Server id 15.2.2562.20 via Frontend
 Transport; Mon, 10 Nov 2025 21:13:13 -0800
From: Nicolin Chen <nicolinc@nvidia.com>
To: <joro@8bytes.org>, <afael@kernel.org>, <bhelgaas@google.com>,
	<alex@shazbot.org>, <jgg@nvidia.com>, <kevin.tian@intel.com>
CC: <will@kernel.org>, <robin.murphy@arm.com>, <lenb@kernel.org>,
	<baolu.lu@linux.intel.com>, <linux-arm-kernel@lists.infradead.org>,
	<iommu@lists.linux.dev>, <linux-kernel@vger.kernel.org>,
	<linux-acpi@vger.kernel.org>, <linux-pci@vger.kernel.org>,
	<kvm@vger.kernel.org>, <patches@lists.linux.dev>, <pjaroszynski@nvidia.com>,
	<vsethi@nvidia.com>, <helgaas@kernel.org>, <etzhao1900@gmail.com>
Subject: [PATCH v5 1/5] iommu: Lock group->mutex in iommu_deferred_attach()
Date: Mon, 10 Nov 2025 21:12:51 -0800
Message-ID: <11b3ab833d717feb41ce23ae6ebdc3af13ea55a7.1762835355.git.nicolinc@nvidia.com>
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
X-MS-TrafficTypeDiagnostic: DS3PEPF0000C381:EE_|SN7PR12MB7883:EE_
X-MS-Office365-Filtering-Correlation-Id: 967611e0-4ea0-45f8-0447-08de20e1097d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|7416014|376014|82310400026|36860700013;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?nrTeELvhBSRe2R2/trtVaVvZUgapDmtJzP6dI+2c4UGJEOkdzm9OY/tV974R?=
 =?us-ascii?Q?TT7Mhm9/qhrXJbGCMzTpKcjbshVpz2fZELH+G5tjlCcsCPXOg1zNJ6nTXtUI?=
 =?us-ascii?Q?nj2I/7g2fbcKCXwqCD4YxsC9clfoVjC3yXsr7naF0gQ2qK1UkYozeih25bwm?=
 =?us-ascii?Q?Oi59moPx5xpTGX2aFNBHF27e5V8MtWQumwIrOzfAq9wk/qX3YBPTs07aD4fO?=
 =?us-ascii?Q?YD2FKDsV0Zl5qVXLlXOuS2QmeWLmzJmdNelAYTs2UUxPl8ppTat/fu1mvNFr?=
 =?us-ascii?Q?orQS3zXoMW6KCJ28L/++oqUDn7lbTmHIfU8GR996zZApLIB61G/7asw1PPJl?=
 =?us-ascii?Q?IKLX4gHDwJKFfjIglybr/T02yo7RUeH3uUowJh0ziAweDUMKEhtwtOje7iPn?=
 =?us-ascii?Q?NJ3xjHNYdEw4m79dgDuPhhoArBuhCMCyFQCZtwNOXw1GXe5DxBJeA/rxKtpM?=
 =?us-ascii?Q?bjInTvo93lx+qIy1VODFwfv5SA9SK00BQZ2A7Zp0Ys2Ry4lC05rg7a59m1ju?=
 =?us-ascii?Q?/jwAyQWAfyQGtng093XH+MkCO7a83nv7nECzKZjqi1/yKh1BdVTurmkDfy+o?=
 =?us-ascii?Q?nQQiNdeSPMLlBx970vCGV/CQOvYqgxjt523PR+5yunSIzu09ZT8DJLz+vDPx?=
 =?us-ascii?Q?8mhIy1BoPpIzgMrYbzJVzwGI8UsFbGgC+NXz/VVmJHpYW8FtEOhe1BI2Wqha?=
 =?us-ascii?Q?YrPmdi6J5i9oNL9KJsizkfkVl79GpxT+1A4kp1CivXx0W/rEAkwnrUXJqyOt?=
 =?us-ascii?Q?XcuqwWKKcsUDuxzNzXJlYkNFblYJH8sFYkP+bCIVol9ety68UnCxpSu3abDy?=
 =?us-ascii?Q?oR95UGdFoJgtPLcR8TORoi0/A7SYo1b15ztAQn1Hx7R0oJPQsw8pFCUiS2LY?=
 =?us-ascii?Q?D4NAkUwkvnp5BDhPpUtyn79YMSBNVY5XfihIpk9YAf4l/YOpB6Mh9dDcuT+d?=
 =?us-ascii?Q?cPtOKE2oFXp2dbuy+p2RqwORIh42mVxlMesL0gDP4feWb83B0P37P53Xd8QJ?=
 =?us-ascii?Q?s2hfC91ON6QtqGpnv8H8mtyBkJm7FIyhNgzXrafmE0gKTYBWU+jxaTCOZrpM?=
 =?us-ascii?Q?X/KP11LD1IBiR/u5XlQx+iNXUVFfnHK/VjLPTTeItEeSoEKzxeezPTXrmjuU?=
 =?us-ascii?Q?LJlhuZQGyfwrJFJHk4nOXtLmVX33PLaF0iGqPbzQ+MDvXamhRGzOfvjU2w6a?=
 =?us-ascii?Q?DqwBE5hiwuxhYeH6JUQS9E6V0aX1Jmq7S8VJQBUdBjNdwLlehp234hxuwwSF?=
 =?us-ascii?Q?lsYD0lzWbqSSkqoB+Tu1LxgpkgQF1Bc+wNF93zFAuydPxKfc1UetRzB3KlwT?=
 =?us-ascii?Q?ubvpl1h0QWB+VZukB9Zik0Fa2Axz6UTAHWPueycBPc/wS5GTfxULhn4vsWWj?=
 =?us-ascii?Q?hM7A3rHoIqLYw+d/bu4xjb/qG33cnTGUCRrBiLBpPr7w03l3+6lW0HpdCzjW?=
 =?us-ascii?Q?LRydRILzaIq0L5vUbkS+80KJeEXanTTskJEY2bcpTS2yHJBES/PntFVSZ+hj?=
 =?us-ascii?Q?NOKyiHBzJZGs8NtpcPnHbbwp2udymVSiX0M8HSsOG7NJRewCvhSQzjYRewL+?=
 =?us-ascii?Q?TEJ76WClS1nv9svvnCg=3D?=
X-Forefront-Antispam-Report:
	CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230040)(1800799024)(7416014)(376014)(82310400026)(36860700013);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Nov 2025 05:13:23.0674
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 967611e0-4ea0-45f8-0447-08de20e1097d
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DS3PEPF0000C381.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR12MB7883

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


