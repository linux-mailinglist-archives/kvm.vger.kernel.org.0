Return-Path: <kvm+bounces-71596-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id 2IFKOPRfnWkDPAQAu9opvQ
	(envelope-from <kvm+bounces-71596-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Tue, 24 Feb 2026 09:23:16 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [IPv6:2600:3c15:e001:75::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 17654183970
	for <lists+kvm@lfdr.de>; Tue, 24 Feb 2026 09:23:16 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id 6C9013038ADC
	for <lists+kvm@lfdr.de>; Tue, 24 Feb 2026 08:22:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8B03F366806;
	Tue, 24 Feb 2026 08:22:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="Vk2Q1Wjb"
X-Original-To: kvm@vger.kernel.org
Received: from CH1PR05CU001.outbound.protection.outlook.com (mail-northcentralusazon11010028.outbound.protection.outlook.com [52.101.193.28])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 223FC28D83E
	for <kvm@vger.kernel.org>; Tue, 24 Feb 2026 08:22:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.193.28
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771921333; cv=fail; b=pXqIMnw4ZdsI4sAJOhBePncBdzQOFZ3dY+5HnujWDD7RbILS83ci3ZGNzGPLj2mcqAd5tp3WjsCJc5axeJ4GFz9M8r+iMVQDu4Z5xl/y4BlKbakWJmVJ6crX8VyuN1dn1x4dywSWZRg8wTi3hHYYkZvRTeGUXp3vzrGEC8sgwB4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771921333; c=relaxed/simple;
	bh=59hJ5fCCKGLvSyo83BBGuUSRQjlcnHZSX+G36aQWDbA=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=e9IPzZipst65OLb541ccezGYCnSAUrAw+SJ5LIqALKsfcjVjfInWNmi82HoDzjbpo0unyo4GhgQUa9iyoL2w0lLywfoVGfX3PSGhMEF34DcBZ7Ed905FLFDUoZ5aTVwtvBCN4oR4JOIK2EmLHFdHGQmJR5ZprJJiVfLGbwe31ms=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=Vk2Q1Wjb; arc=fail smtp.client-ip=52.101.193.28
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=nnfu0/QQQaxIlLlOtgLOFpBMdodAtsF+Penb6dPwyiKYm1zUQxB9p2n66rYaDuONxGGheupWV6e0e5cKAek0UrdjPUzLdaVQa5c5qeqQPPA+JCWny1aDTKasImwyTbWnDHPZhiY/w4+u5iOo6TiWge2YXFd6hr1KwP2xZgYOzZdGBuh5x81KFQNwjNjPimeHN6WV66aZC4XCTjJAKiAbsi68mWpuB2iwdkorW5TaJGr8RBCqFqbUsuGR/wANFag0PLGH/0FkZvVuHrXGuypGg3NqHyPpZC0gEh0uSC1yQEKx74nb9mZY8fVRzRnjVmTtROpXTFuANN0E941Ss7VGBg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=GayymKbUPTXU9YrykY1oBwUY8WaqmUbNS/8y+Ck7jX0=;
 b=yTvCs1CFRTucds4aCZ1Heq0kyLIa0wd8tUCEMPqBP9tCCbZd0mtUC9ZKLUOExjtwtiSBG3OgMTQgAh8H4OSXOtOdpeTngfYwKcgUFCMP/wEaBut5Ahmfb+sBhSPEb2WHhEQckIdwPWRVBGR/jEjxe/IprXNe5HR4CMpygVV3hzqL0aAs94w8+9vcWdOclDFfejcQGmvUUaOXqHTGq+z1FPvJWVTJ8CYQqQRLAMW/ZG+wyMofbkALT5RvyNjgyOiwt+xD4FfTu2JwUsmsd3tLwveeqXaWxF0u1eBqZqiyrdhxpGgacYh6C7IBzB7dNtQzsbRupLzEpHvtmJYX+yxILw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=redhat.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=GayymKbUPTXU9YrykY1oBwUY8WaqmUbNS/8y+Ck7jX0=;
 b=Vk2Q1WjbCVyYXAEby3Yo5W5esJMof6DTb6Sp+RMAp5+ShHRojl0xgwsbrfxX9tFKCBulnxcUEwhTvJKwbhGLuWWod3ad3Hw3XsxGHE1aUhjQ0/HiAJEFWHnI4MqI7LDXFEZ3VzqwhpDzvGgXuVa67q8xcm+3W9X9J0fdU63JiSvvKoN4FBns8Fcq4JF2NTttBtpcubYK0jCoyuAGuV7bPr51lqabAQxHE9dHyQMui81tc0Wh4F6eR0g4Z91DDDfB0LJBoypi5b/jFyFhuwkY+dHjJMQhjc8XF7Xi5d7UAjW2L15vYVcVEr5mQ3eLK9n3ZWdM2yiB7633DbPlJwQIOQ==
Received: from SJ0PR13CA0095.namprd13.prod.outlook.com (2603:10b6:a03:2c5::10)
 by DM6PR12MB4139.namprd12.prod.outlook.com (2603:10b6:5:214::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9632.22; Tue, 24 Feb
 2026 08:22:04 +0000
Received: from CO1PEPF000075F0.namprd03.prod.outlook.com
 (2603:10b6:a03:2c5:cafe::f4) by SJ0PR13CA0095.outlook.office365.com
 (2603:10b6:a03:2c5::10) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9632.22 via Frontend Transport; Tue,
 24 Feb 2026 08:21:58 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.160)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 CO1PEPF000075F0.mail.protection.outlook.com (10.167.249.39) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9632.12 via Frontend Transport; Tue, 24 Feb 2026 08:22:03 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20; Tue, 24 Feb
 2026 00:21:46 -0800
Received: from rnnvmail202.nvidia.com (10.129.68.7) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20; Tue, 24 Feb
 2026 00:21:46 -0800
Received: from vdi.nvidia.com (10.127.8.10) by mail.nvidia.com (10.129.68.7)
 with Microsoft SMTP Server id 15.2.2562.20 via Frontend Transport; Tue, 24
 Feb 2026 00:21:43 -0800
From: Yishai Hadas <yishaih@nvidia.com>
To: <alex.williamson@redhat.com>, <jgg@nvidia.com>
CC: <kvm@vger.kernel.org>, <kevin.tian@intel.com>,
	<joao.m.martins@oracle.com>, <leonro@nvidia.com>, <yishaih@nvidia.com>,
	<maorg@nvidia.com>, <avihaih@nvidia.com>, <liulongfang@huawei.com>,
	<giovanni.cabiddu@intel.com>, <kwankhede@nvidia.com>
Subject: [PATCH vfio 6/6] vfio/mlx5: Add REINIT support to VFIO_MIG_GET_PRECOPY_INFO
Date: Tue, 24 Feb 2026 10:20:19 +0200
Message-ID: <20260224082019.25772-7-yishaih@nvidia.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20260224082019.25772-1-yishaih@nvidia.com>
References: <20260224082019.25772-1-yishaih@nvidia.com>
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
X-MS-TrafficTypeDiagnostic: CO1PEPF000075F0:EE_|DM6PR12MB4139:EE_
X-MS-Office365-Filtering-Correlation-Id: 72543737-f425-4fd9-df23-08de737dca92
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|82310400026|1800799024|36860700013;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?2Omv5eoHZv8Euza8GVzdo5Xt55tF6JPlsGAroe6J/si/fZCJfth3qIIqP2oE?=
 =?us-ascii?Q?gUcCxBnxQEBucm+m8xB/zw571Pt8b8fLfH9RQ6WnFYX5+34dP8qMPlCDgyX0?=
 =?us-ascii?Q?qsvduLWeRLjnHM92js9IQBpy9BN570NPYCcdeYYESS3AroasKLzjv+52VhtN?=
 =?us-ascii?Q?tRLD7OTK1GqkvvIR2p4GVNHR4ZtdS/EcRBaJjDvTI5Wvb4UWqdd5Gy/YtizH?=
 =?us-ascii?Q?+iZ891yccRkcE/mSrRc4LbFmmgKgGXFIwr4MvY0PHpyC76hMuaSScgyHM6xu?=
 =?us-ascii?Q?zc3mQqtQHjblp08ae4yJ4CmbXX9qxnbpbapTV1wa3ZPUahAub1yYEP2/lL89?=
 =?us-ascii?Q?PNQ7tfAWwaZk9mw880DQJoT4YNN4H8uDkF6PSgwL3DSI/0ESsUsGxPCvC0Mx?=
 =?us-ascii?Q?62XxTO9yIYOjdu0oDT2p+SsxLydJXRW1g2XrpPKmER3znWxgIUjxUAvY15BW?=
 =?us-ascii?Q?A6EbPBKKYEYTqUr4eTdlrGjvfXb0a8g/5Zq2A7a5LiwPc8qgeKZktYXEKzyT?=
 =?us-ascii?Q?++dscQKhr9V5PCaSSZVlc/21234hL/J728yIN1QkO02kDAvmmR5chYL+3igB?=
 =?us-ascii?Q?WPXQSuAAp8yh607rJiv9MeXkUClSl4YyoE4DeKSWj7XJFcdDebyPAG3Myy2x?=
 =?us-ascii?Q?tYEfVwWV5wqO1x9FdjZEcu+MniTvnTKuH3iZB6KIh9JbGNPH2ulbp9sC7J6O?=
 =?us-ascii?Q?sfjwF2/43t0Ru+dvv+o9GTpwIwy4zSqY38MoRt05gqH3ZkDF/0e8uACmwCdR?=
 =?us-ascii?Q?cZQWl5OMo8UeL426OwKwtXURYpTiEqw6oNCDgQEsXxF413/zZrfFzDbz62bm?=
 =?us-ascii?Q?m0w/QMeUxwE883rGKbE5Y5Gak/Ul+YYNNDCZmd9slLewTRMnNTkTb8snA0/1?=
 =?us-ascii?Q?eg2H8UfPNeordsPVqoOVxO2xos2K1+IBH50nv5jFjU/n6Cx8rjpR5gNHqXok?=
 =?us-ascii?Q?NE9uKDoi/B70NU3wELID5Va1R+ZSLdojJ4SqFkUdFA3UZetOlkHUzqkUcy9A?=
 =?us-ascii?Q?3iFo2wHndNIeRkHu42t50uY+Pe2mJx4xt9keZVlY1qTwwYnki8GcPzff96HC?=
 =?us-ascii?Q?JFnvFZAWugVcRQ65o4EOYr+Hme2BUo1B5td2/aHNPAptA074RFyIG0E5nyvW?=
 =?us-ascii?Q?1rDwUSpdyFb8JvBirudENS5ldYPq3g1GKsSJFAMtBw57SniYh7aQp1vvw+Qa?=
 =?us-ascii?Q?AXNA8B7x8PInAR52t0Ido3KupDtcNTgYNBFPJg/flJ8LZ1nzcvdEELmHoysF?=
 =?us-ascii?Q?oxVFm7yYBoQcw+/Y1DZvftiJTv5/l+LMBwjiLuDcuWmV0C9HD9WkYdNQ1cAQ?=
 =?us-ascii?Q?KFmE6dYEdxvOmY/1pYE/KBIghdYzIZTXcWEQGuPzttC/auRfAvxUm2sKOmGf?=
 =?us-ascii?Q?bbVNnQUNSLy45ysr1x7cQLO5Y0vrQE8GaLfpgd1tNyZnECJDcGEzKljC+pb4?=
 =?us-ascii?Q?aKNwPvK+GepUyBF4zCY7KzScO2Gy54xI+qrX5X97c09SWf3Qlh8DskyVphzn?=
 =?us-ascii?Q?eP70SFbfT0N4My/bEIKlt2hReZCC+ST+rrA8D7ZU1i2re+alFUy0iwHdkoRn?=
 =?us-ascii?Q?uYvy+lfJQQI7iG+J6et2geKHqUZiSeMamG5gUlgegG9aqd1A0iTIXYfqAbw9?=
 =?us-ascii?Q?FkQ8if1ud+NXE6f382/BtdeCjWd1KfPc++lV506tBQ+zO98v2tsQX/iEi8C7?=
 =?us-ascii?Q?+hfqgg=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230040)(376014)(82310400026)(1800799024)(36860700013);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	v33+0xBeieurDIDqd/mrIJkI4l9OrPPC49XGupaFJegSfkySZlUOESNTlBKxwEaSXFdN27cm0OykYHoMjoBGx3qb6Wq3U6SH//wLRc2kLlyzfirUxL7Y2+89dWwa8ugin6aqy79icxjpkFF3kPMbFyNaAshwHV9zP+wsArWW1YzDeqULgHfWZm0VIyJMB0Cz6XLPpGW4QaEp3A3AH/cYxsqGoUW4w5ny9OyNrvxUrUEYdDkK77DGOu3/KzDt7ZAPMSGuump0uEO9dYNmTT2yAD+POEXS41vkOeHZLuAuIwKSBAk4De4jJv7vxyciOYsLRmzKYV3RBn+jAjHB6Yd52rpRqPUPlHUXLB5VCFvooG4KBZ//LvMAOrE72rxknq14mSkPW8hDTfwczvY0+jlVXGQKFHv1hELVlfOiKm5BTNcgWNB9n0sjkLJmbWEJ/qyR
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Feb 2026 08:22:03.8463
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 72543737-f425-4fd9-df23-08de737dca92
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CO1PEPF000075F0.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB4139
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [1.34 / 15.00];
	ARC_REJECT(1.00)[cv is fail on i=2];
	MID_CONTAINS_FROM(1.00)[];
	DMARC_POLICY_ALLOW(-0.50)[nvidia.com,reject];
	R_MISSING_CHARSET(0.50)[];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c15:e001:75::/64:c];
	R_DKIM_ALLOW(-0.20)[Nvidia.com:s=selector2];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-71596-lists,kvm=lfdr.de];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	DKIM_TRACE(0.00)[Nvidia.com:+];
	ASN(0.00)[asn:63949, ipnet:2600:3c15::/32, country:SG];
	RCPT_COUNT_TWELVE(0.00)[12];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[yishaih@nvidia.com,kvm@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	TO_DN_NONE(0.00)[];
	NEURAL_HAM(-0.00)[-0.999];
	DBL_BLOCKED_OPENRESOLVER(0.00)[Nvidia.com:dkim,sin.lore.kernel.org:helo,sin.lore.kernel.org:rdns,nvidia.com:mid,nvidia.com:email];
	TAGGED_RCPT(0.00)[kvm];
	RCVD_COUNT_SEVEN(0.00)[9]
X-Rspamd-Queue-Id: 17654183970
X-Rspamd-Action: no action

When userspace opts into VFIO_DEVICE_FEATURE_MIG_PRECOPY_INFOv2, the
driver may report the VFIO_PRECOPY_INFO_REINIT output flag in response
to the VFIO_MIG_GET_PRECOPY_INFO ioctl, along with a new initial_bytes
value.

The presence of the VFIO_PRECOPY_INFO_REINIT flag indicates to the
caller that new initial data is available in the migration stream.

If the firmware reports a new initial-data chunk, any previously dirty
bytes in memory are treated as initial bytes, since the caller must read
both sets before reaching the end of the initial-data region.

In this case, the driver issues a new SAVE command to fetch the data and
prepare it for a subsequent read() from userspace.

Signed-off-by: Yishai Hadas <yishaih@nvidia.com>
---
 drivers/vfio/pci/mlx5/cmd.c  | 20 ++++++--
 drivers/vfio/pci/mlx5/cmd.h  |  5 +-
 drivers/vfio/pci/mlx5/main.c | 97 +++++++++++++++++++++++-------------
 3 files changed, 83 insertions(+), 39 deletions(-)

diff --git a/drivers/vfio/pci/mlx5/cmd.c b/drivers/vfio/pci/mlx5/cmd.c
index 18b8d8594070..5fe0621b5fbd 100644
--- a/drivers/vfio/pci/mlx5/cmd.c
+++ b/drivers/vfio/pci/mlx5/cmd.c
@@ -87,7 +87,7 @@ int mlx5vf_cmd_resume_vhca(struct mlx5vf_pci_core_device *mvdev, u16 op_mod)
 
 int mlx5vf_cmd_query_vhca_migration_state(struct mlx5vf_pci_core_device *mvdev,
 					  size_t *state_size, u64 *total_size,
-					  u8 query_flags)
+					  u8 *mig_state, u8 query_flags)
 {
 	u32 out[MLX5_ST_SZ_DW(query_vhca_migration_state_out)] = {};
 	u32 in[MLX5_ST_SZ_DW(query_vhca_migration_state_in)] = {};
@@ -152,6 +152,10 @@ int mlx5vf_cmd_query_vhca_migration_state(struct mlx5vf_pci_core_device *mvdev,
 			MLX5_GET64(query_vhca_migration_state_out, out,
 				   remaining_total_size) : *state_size;
 
+	if (mig_state && mvdev->mig_state_cap)
+		*mig_state = MLX5_GET(query_vhca_migration_state_out, out,
+				      migration_state);
+
 	return 0;
 }
 
@@ -277,6 +281,9 @@ void mlx5vf_cmd_set_migratable(struct mlx5vf_pci_core_device *mvdev,
 	if (MLX5_CAP_GEN_2(mvdev->mdev, migration_in_chunks))
 		mvdev->chunk_mode = 1;
 
+	if (MLX5_CAP_GEN_2(mvdev->mdev, migration_state))
+		mvdev->mig_state_cap = 1;
+
 end:
 	mlx5_vf_put_core_dev(mvdev->mdev);
 }
@@ -555,6 +562,7 @@ void mlx5vf_put_data_buffer(struct mlx5_vhca_data_buffer *buf)
 {
 	spin_lock_irq(&buf->migf->list_lock);
 	buf->stop_copy_chunk_num = 0;
+	buf->pre_copy_init_bytes_chunk = false;
 	list_add_tail(&buf->buf_elm, &buf->migf->avail_list);
 	spin_unlock_irq(&buf->migf->list_lock);
 }
@@ -689,7 +697,8 @@ static void mlx5vf_save_callback(int status, struct mlx5_async_work *context)
 				!next_required_umem_size;
 		if (async_data->header_buf) {
 			status = add_buf_header(async_data->header_buf, image_size,
-						initial_pre_copy);
+						initial_pre_copy ||
+						async_data->buf->pre_copy_init_bytes_chunk);
 			if (status)
 				goto err;
 		}
@@ -708,9 +717,12 @@ static void mlx5vf_save_callback(int status, struct mlx5_async_work *context)
 			}
 		}
 		spin_unlock_irqrestore(&migf->list_lock, flags);
-		if (initial_pre_copy) {
+		if (initial_pre_copy || async_data->buf->pre_copy_init_bytes_chunk) {
 			migf->pre_copy_initial_bytes += image_size;
-			migf->state = MLX5_MIGF_STATE_PRE_COPY;
+			if (initial_pre_copy)
+				migf->state = MLX5_MIGF_STATE_PRE_COPY;
+			if (async_data->buf->pre_copy_init_bytes_chunk)
+				async_data->buf->pre_copy_init_bytes_chunk = false;
 		}
 		if (stop_copy_last_chunk)
 			migf->state = MLX5_MIGF_STATE_COMPLETE;
diff --git a/drivers/vfio/pci/mlx5/cmd.h b/drivers/vfio/pci/mlx5/cmd.h
index 7d2c10be2e60..deed0f132f39 100644
--- a/drivers/vfio/pci/mlx5/cmd.h
+++ b/drivers/vfio/pci/mlx5/cmd.h
@@ -62,6 +62,7 @@ struct mlx5_vhca_data_buffer {
 	u32 *mkey_in;
 	enum dma_data_direction dma_dir;
 	u8 stop_copy_chunk_num;
+	bool pre_copy_init_bytes_chunk;
 	struct list_head buf_elm;
 	struct mlx5_vf_migration_file *migf;
 };
@@ -97,6 +98,7 @@ struct mlx5_vf_migration_file {
 	u32 record_tag;
 	u64 stop_copy_prep_size;
 	u64 pre_copy_initial_bytes;
+	u64 pre_copy_initial_bytes_start;
 	size_t next_required_umem_size;
 	u8 num_ready_chunks;
 	/* Upon chunk mode preserve another set of buffers for stop_copy phase */
@@ -175,6 +177,7 @@ struct mlx5vf_pci_core_device {
 	u8 mdev_detach:1;
 	u8 log_active:1;
 	u8 chunk_mode:1;
+	u8 mig_state_cap:1;
 	struct completion tracker_comp;
 	/* protect migration state */
 	struct mutex state_mutex;
@@ -199,7 +202,7 @@ int mlx5vf_cmd_suspend_vhca(struct mlx5vf_pci_core_device *mvdev, u16 op_mod);
 int mlx5vf_cmd_resume_vhca(struct mlx5vf_pci_core_device *mvdev, u16 op_mod);
 int mlx5vf_cmd_query_vhca_migration_state(struct mlx5vf_pci_core_device *mvdev,
 					  size_t *state_size, u64 *total_size,
-					  u8 query_flags);
+					  u8 *migration_state, u8 query_flags);
 void mlx5vf_cmd_set_migratable(struct mlx5vf_pci_core_device *mvdev,
 			       const struct vfio_migration_ops *mig_ops,
 			       const struct vfio_log_ops *log_ops);
diff --git a/drivers/vfio/pci/mlx5/main.c b/drivers/vfio/pci/mlx5/main.c
index 68e051c48d40..0d4e363a4e3b 100644
--- a/drivers/vfio/pci/mlx5/main.c
+++ b/drivers/vfio/pci/mlx5/main.c
@@ -464,8 +464,10 @@ static long mlx5vf_precopy_ioctl(struct file *filp, unsigned int cmd,
 	struct mlx5_vhca_data_buffer *buf;
 	struct vfio_precopy_info info = {};
 	loff_t *pos = &filp->f_pos;
+	u8 migration_state = 0;
 	size_t inc_length = 0;
-	bool end_of_data = false;
+	bool reinit_state;
+	bool end_of_data;
 	int ret;
 
 	ret = vfio_check_precopy_ioctl(&mvdev->core_device.vdev, cmd, arg,
@@ -492,7 +494,8 @@ static long mlx5vf_precopy_ioctl(struct file *filp, unsigned int cmd,
 		 * As so, the other code below is safe with the proper locks.
 		 */
 		ret = mlx5vf_cmd_query_vhca_migration_state(mvdev, &inc_length,
-							    NULL, MLX5VF_QUERY_INC);
+							    NULL, &migration_state,
+							    MLX5VF_QUERY_INC);
 		if (ret)
 			goto err_state_unlock;
 	}
@@ -503,41 +506,67 @@ static long mlx5vf_precopy_ioctl(struct file *filp, unsigned int cmd,
 		goto err_migf_unlock;
 	}
 
-	if (migf->pre_copy_initial_bytes > *pos) {
-		info.initial_bytes = migf->pre_copy_initial_bytes - *pos;
+	/*
+	 * opt-in for VFIO_DEVICE_FEATURE_MIG_PRECOPY_INFOv2 serves
+	 * as opt-in for VFIO_PRECOPY_INFO_REINIT as well
+	 */
+	reinit_state = mvdev->core_device.vdev.precopy_info_flags_fix &&
+			migration_state == MLX5_QUERY_VHCA_MIG_STATE_OPER_MIGRATION_INIT;
+	end_of_data = !(migf->max_pos - *pos);
+	if (reinit_state) {
+		/*
+		 * Any bytes already present in memory are treated as initial
+		 * bytes, since the caller is required to read them before
+		 * reaching the new initial-bytes region.
+		 */
+		migf->pre_copy_initial_bytes_start = *pos;
+		migf->pre_copy_initial_bytes = migf->max_pos - *pos;
+		info.initial_bytes = migf->pre_copy_initial_bytes + inc_length;
+		info.flags |= VFIO_PRECOPY_INFO_REINIT;
 	} else {
-		info.dirty_bytes = migf->max_pos - *pos;
-		if (!info.dirty_bytes)
-			end_of_data = true;
-		info.dirty_bytes += inc_length;
+		if (migf->pre_copy_initial_bytes_start +
+		    migf->pre_copy_initial_bytes > *pos) {
+			WARN_ON_ONCE(end_of_data);
+			info.initial_bytes = migf->pre_copy_initial_bytes_start +
+				migf->pre_copy_initial_bytes - *pos;
+		} else {
+			info.dirty_bytes = (migf->max_pos - *pos) + inc_length;
+		}
 	}
+	mutex_unlock(&migf->lock);
 
-	if (!end_of_data || !inc_length) {
-		mutex_unlock(&migf->lock);
-		goto done;
-	}
+	if ((reinit_state || end_of_data) && inc_length) {
+		/*
+		 * In case we finished transferring the current state and the
+		 * device has a dirty state, or that the device has a new init
+		 * state, save a new state to be ready for.
+		 */
+		buf = mlx5vf_get_data_buffer(migf, DIV_ROUND_UP(inc_length, PAGE_SIZE),
+					     DMA_FROM_DEVICE);
+		if (IS_ERR(buf)) {
+			ret = PTR_ERR(buf);
+			mlx5vf_mark_err(migf);
+			goto err_state_unlock;
+		}
 
-	mutex_unlock(&migf->lock);
-	/*
-	 * We finished transferring the current state and the device has a
-	 * dirty state, save a new state to be ready for.
-	 */
-	buf = mlx5vf_get_data_buffer(migf, DIV_ROUND_UP(inc_length, PAGE_SIZE),
-				     DMA_FROM_DEVICE);
-	if (IS_ERR(buf)) {
-		ret = PTR_ERR(buf);
-		mlx5vf_mark_err(migf);
-		goto err_state_unlock;
-	}
+		buf->pre_copy_init_bytes_chunk = reinit_state;
+		ret = mlx5vf_cmd_save_vhca_state(mvdev, migf, buf, true, true);
+		if (ret) {
+			mlx5vf_mark_err(migf);
+			mlx5vf_put_data_buffer(buf);
+			goto err_state_unlock;
+		}
 
-	ret = mlx5vf_cmd_save_vhca_state(mvdev, migf, buf, true, true);
-	if (ret) {
-		mlx5vf_mark_err(migf);
-		mlx5vf_put_data_buffer(buf);
-		goto err_state_unlock;
+		/*
+		 * SAVE appends a header record via add_buf_header(),
+		 * let's account it as well.
+		 */
+		if (reinit_state)
+			info.initial_bytes += sizeof(struct mlx5_vf_migration_header);
+		else
+			info.dirty_bytes += sizeof(struct mlx5_vf_migration_header);
 	}
 
-done:
 	mlx5vf_state_mutex_unlock(mvdev);
 	if (copy_to_user((void __user *)arg, &info,
 			 offsetofend(struct vfio_precopy_info, dirty_bytes)))
@@ -570,7 +599,7 @@ static int mlx5vf_pci_save_device_inc_data(struct mlx5vf_pci_core_device *mvdev)
 	if (migf->state == MLX5_MIGF_STATE_ERROR)
 		return -ENODEV;
 
-	ret = mlx5vf_cmd_query_vhca_migration_state(mvdev, &length, NULL,
+	ret = mlx5vf_cmd_query_vhca_migration_state(mvdev, &length, NULL, NULL,
 				MLX5VF_QUERY_INC | MLX5VF_QUERY_FINAL);
 	if (ret)
 		goto err;
@@ -636,7 +665,7 @@ mlx5vf_pci_save_device_data(struct mlx5vf_pci_core_device *mvdev, bool track)
 	if (ret)
 		goto out;
 
-	ret = mlx5vf_cmd_query_vhca_migration_state(mvdev, &length, &full_size, 0);
+	ret = mlx5vf_cmd_query_vhca_migration_state(mvdev, &length, &full_size, NULL, 0);
 	if (ret)
 		goto out_pd;
 
@@ -1123,7 +1152,7 @@ mlx5vf_pci_step_device_state_locked(struct mlx5vf_pci_core_device *mvdev,
 		enum mlx5_vf_migf_state state;
 		size_t size;
 
-		ret = mlx5vf_cmd_query_vhca_migration_state(mvdev, &size, NULL,
+		ret = mlx5vf_cmd_query_vhca_migration_state(mvdev, &size, NULL, NULL,
 					MLX5VF_QUERY_INC | MLX5VF_QUERY_CLEANUP);
 		if (ret)
 			return ERR_PTR(ret);
@@ -1248,7 +1277,7 @@ static int mlx5vf_pci_get_data_size(struct vfio_device *vdev,
 
 	mutex_lock(&mvdev->state_mutex);
 	ret = mlx5vf_cmd_query_vhca_migration_state(mvdev, &state_size,
-						    &total_size, 0);
+						    &total_size, NULL, 0);
 	if (!ret)
 		*stop_copy_length = total_size;
 	mlx5vf_state_mutex_unlock(mvdev);
-- 
2.18.1


