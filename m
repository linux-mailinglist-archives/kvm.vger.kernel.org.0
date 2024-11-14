Return-Path: <kvm+bounces-31845-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 346AC9C8680
	for <lists+kvm@lfdr.de>; Thu, 14 Nov 2024 10:54:18 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id A4C6BB240F3
	for <lists+kvm@lfdr.de>; Thu, 14 Nov 2024 09:54:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6ADFE1F7545;
	Thu, 14 Nov 2024 09:54:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="lvxAuLYU"
X-Original-To: kvm@vger.kernel.org
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2063.outbound.protection.outlook.com [40.107.237.63])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AC76B1DB95F
	for <kvm@vger.kernel.org>; Thu, 14 Nov 2024 09:54:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.237.63
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731578043; cv=fail; b=Lms0pfLx5S9uts0um072AiAPz7M80KpGBVvrQdeFecgo5P/7PTPp80l/ix2M9PNthLrmtHnEUbcDCT7X0yu0M0kB0oR3XbRPUEc2MuvREL3J5aUAhnvLqAV+2HkiJYq2wgdnCPVd8TCwU5aG31QZglVTQ9TBYIL64pawLEHDXnk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731578043; c=relaxed/simple;
	bh=RQaWun7u1fY6GMT7d9X7QHKO6MM0bU2brzD64fR6bdI=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ln1bBwsf/8bKjD9KDWoDtjDetl998EI0EFew1xXS6KwZ35mQKtUVczyXIwq5VlfI1+IW5cd2KoJpz4KvOJvEXT0DOQw+hqv8b2jzsObxocHLcaTw336IeMKkVKbEfpOJrp4n2EXwpQeSi6s7mqVAOfPiIz9SacbjuZGNepYjZaA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=lvxAuLYU; arc=fail smtp.client-ip=40.107.237.63
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=xtftN0J3AasqKewxG92DfW2+mY9nlA2YWtaGg1jRFzze8WL3JYuosdq82BoohkfCKR1/L43Kr6vfBABj3loBnBgK43KwZjzqnFwxrAPMsewPJIqSVYHz7Z67FfD3EnXjaKnZFsqCe92dI4ZXEZ/AlLtk5Z2445Uoic7su2fBQhnJ1eXS/+YLW4Dshj8OEAQImFu7TrmRqGVZi3T3vW1UsLR9bo0pTf3azpPIHYDD4vwF0mQdolU+Pc9gOxdFbB9V1ID0InXXocDHav6Z2lH/I5g/eiQopMkTY1RCvxHkxTIpSpP/vCryYoXd976AroAX4uAw2ZAw93eSMpAobE+TQQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ZjoYG4v9oHHIwObI//4QXotrH9aDGLhA47wACENWwa8=;
 b=ad1aq6EuDcg8AV0BmGCdld3Drt+i7XxuK0wQKy/cgrDgXU/6bhvgr9D3S21HgruHOADp6qZaVBWLvNn6d4rlBFAGnIWFASpJHZpvTfOH1jfe6zGoFvYqz+02NbM6nRHhPX2L1LqItJ2CMKOiWxy78gzDJrrqPpkS5MQ5q5rOIjACAYTt/XwiLfMeSPHOcZgmaflTKYgQdR24FJe9yPmuhswrtafAIsNteGGTyq6Av33DIr38e+Z5Tlba+PJTSdBCnCpTNjtRmxm9SKs92UrBJGw6POk0EdcVe2j/7OiNX9PB87UJUvG7X4ld+gXnit72/ZsYiu1fQsvNAYyncZoLGA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.118.232) smtp.rcpttodomain=redhat.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ZjoYG4v9oHHIwObI//4QXotrH9aDGLhA47wACENWwa8=;
 b=lvxAuLYUZ3oK0cUmu1QHtjt0Kl7RcEcExZBqqNDcxIe3pKIvdTbyECFmto3gmtEE+2hmtqf0S3o50azZIDSEaj9doo6KTe9KbQpr1SWRShx9VXXMMtkBEH2FQ64kdk2/UBReVAhiVwnC4MKm05xqfz/W3nDi9DUbFNdDNrmINfiTDw8csY5BlwUrRZvGdOODXDcfP4qtPaTzEHNHefQ7g7shR3gk/rWjK8YATeJg4yShy4K67rGJ/cFXkfQzD09ZDdjO5S1Jw6IbL2aaMkfonWLn4GF/ZQZXzLPWlQEPlWn7XPsuWP9ThhP7Eebx++2HB2qWd2U7z0P5DU6TPHu3Ww==
Received: from CH2PR17CA0005.namprd17.prod.outlook.com (2603:10b6:610:53::15)
 by MW4PR12MB7383.namprd12.prod.outlook.com (2603:10b6:303:219::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8158.17; Thu, 14 Nov
 2024 09:53:57 +0000
Received: from DS2PEPF0000343C.namprd02.prod.outlook.com
 (2603:10b6:610:53:cafe::9b) by CH2PR17CA0005.outlook.office365.com
 (2603:10b6:610:53::15) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8158.18 via Frontend
 Transport; Thu, 14 Nov 2024 09:53:57 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.118.232)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.118.232 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.118.232; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.118.232) by
 DS2PEPF0000343C.mail.protection.outlook.com (10.167.18.39) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8158.14 via Frontend Transport; Thu, 14 Nov 2024 09:53:57 +0000
Received: from drhqmail201.nvidia.com (10.126.190.180) by mail.nvidia.com
 (10.127.129.5) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4; Thu, 14 Nov
 2024 01:53:51 -0800
Received: from drhqmail202.nvidia.com (10.126.190.181) by
 drhqmail201.nvidia.com (10.126.190.180) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.4; Thu, 14 Nov 2024 01:53:50 -0800
Received: from vdi.nvidia.com (10.127.8.10) by mail.nvidia.com
 (10.126.190.181) with Microsoft SMTP Server id 15.2.1544.4 via Frontend
 Transport; Thu, 14 Nov 2024 01:53:48 -0800
From: Yishai Hadas <yishaih@nvidia.com>
To: <alex.williamson@redhat.com>, <jgg@nvidia.com>
CC: <kvm@vger.kernel.org>, <kevin.tian@intel.com>,
	<joao.m.martins@oracle.com>, <leonro@nvidia.com>, <yishaih@nvidia.com>,
	<maorg@nvidia.com>
Subject: [PATCH vfio 1/2] vfio/mlx5: Fix an unwind issue in mlx5vf_add_migration_pages()
Date: Thu, 14 Nov 2024 11:53:17 +0200
Message-ID: <20241114095318.16556-2-yishaih@nvidia.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20241114095318.16556-1-yishaih@nvidia.com>
References: <20241114095318.16556-1-yishaih@nvidia.com>
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
X-MS-TrafficTypeDiagnostic: DS2PEPF0000343C:EE_|MW4PR12MB7383:EE_
X-MS-Office365-Filtering-Correlation-Id: b3af2e89-ea25-49e4-0648-08dd049241f0
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|36860700013|376014|82310400026;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?ORaRlhQr3LbIfjFL3A3YlGqwBFpIHVdsmbhdnTnfEmZKEH1ZyCrwmkT4r3eS?=
 =?us-ascii?Q?rKXl+5VJXi2uICD21rkrvX32M8jO1PFbOTHHtWnc6yl/zs1UfbJtYjazBu2y?=
 =?us-ascii?Q?7MIfH/EUp5tDcrpynlXY8yr7D7XFxnFv5pdODC4i63Cu83BX29v0tkMPSXC7?=
 =?us-ascii?Q?nZmbNoRDd6C677dm+j6TzwNGg3Fl/N0qcRR/5lr04vo4DN7aJMuGfHyPOwcu?=
 =?us-ascii?Q?I3I4wMnQfaBaU/pwJbKsGOGn5W5/0NPZWEW18FCjAA8pU2JfZL2aMPpYZjQQ?=
 =?us-ascii?Q?ht3Qh3+6AbKKgZxnEzlcwR0EwitX2WFgrYBLHCOn6jTduoPwoWkvdGNyWft/?=
 =?us-ascii?Q?Z1CpYs5UiopfkzBFe21MxCrrJvkEKBKX9pOdjQQHV1yhRWce/HbVM3NQR/UP?=
 =?us-ascii?Q?t/yicD6FxsCkcnzx0Z/OYJYt7n0hHYK8fJUO+d4BccwVUA2Zr1rBNrlxklNY?=
 =?us-ascii?Q?qEQyM374mqXbowqU27cAKQH0de02YXUINdn2AGkon13TiYo8+qFbayElVIGZ?=
 =?us-ascii?Q?zIv5e30UxGHJ8yLiyoziDk4euIszMzkR5ANhHLOISbMJGqGrNMWcrYOXz3//?=
 =?us-ascii?Q?uEz1jUkade2H4fsv2yrE81cqSHO67lxyNOHpFJHjJ0BdSEFnbmkoknmid3UT?=
 =?us-ascii?Q?fTASPTmheSh/RqhTcIxDew8YXIfVwHsNhU/19B61I05vfuK2TXP5laicvEcV?=
 =?us-ascii?Q?lvlrB8O1Li67aJW5BwQK3Buu7g4whISME+q+bnpMWRpHhxJ3dRA/CEnue6e4?=
 =?us-ascii?Q?BJWcEPOQNcGHxPmT3d02BsLywS4ata7BWwejUaaOfmaJ4tcA37uKA6hQa7gS?=
 =?us-ascii?Q?4RS6FMpN5VEaE5h1/RwNdxUJQZNYSVdkogftOw884/SF1vHVxJZOZB+fnijO?=
 =?us-ascii?Q?U1ht+UiaTupNlKwDS6iLr8i7KCjqv6AsMZUGORVluXJVLyTZLazn+YYL/66D?=
 =?us-ascii?Q?aeeKcM8pbEaYIfvzcz+RNmQTfzwkWbvdQpkdN851XxhjJQFdWGFtpXzGlsl+?=
 =?us-ascii?Q?QXhQBxuzRoCd4mCooTR0q36W8qVtJPJc1FMP0JIqp4r7+Bm3K74rmErdRNjL?=
 =?us-ascii?Q?2AwecW0JzJaVtzqXbNPjSYMNk2T/GXJR8lDuTgsxOhdsipIaMPl8M6KZmYol?=
 =?us-ascii?Q?AV+1ClDwc2e6TFygGPO+oHoVfz7v1TtnsqnYvruSP3OpQpC5CTlzDMBHjNNn?=
 =?us-ascii?Q?3vgIfylPlWynM+3unF2HeCm3BqPcwcpRguisVs9WpfHcdtDdIAb5UTQ0yvGC?=
 =?us-ascii?Q?GD/Aj9hg1eaB6mBEkC06uVwbAwWbBzeF9rylJloV0AN1VT4D1LtOmFOZbelg?=
 =?us-ascii?Q?m4A+fkOL+xMA1enWyY3sawHDnrhb2XpQuL0qDnzlpxnyj6OlKqiEupkN2aCM?=
 =?us-ascii?Q?JIwAqNAD2ajRQRZmZYOdGNcnNxgjtKkdcne8MMBv6TPtV6fWng=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:216.228.118.232;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc7edge1.nvidia.com;CAT:NONE;SFS:(13230040)(1800799024)(36860700013)(376014)(82310400026);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Nov 2024 09:53:57.3214
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: b3af2e89-ea25-49e4-0648-08dd049241f0
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.118.232];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DS2PEPF0000343C.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR12MB7383

Fix an unwind issue in mlx5vf_add_migration_pages().

If a set of pages is allocated but fails to be added to the SG table,
they need to be freed to prevent a memory leak.

Any pages successfully added to the SG table will be freed as part of
mlx5vf_free_data_buffer().

Fixes: 6fadb021266d ("vfio/mlx5: Implement vfio_pci driver for mlx5 devices")
Signed-off-by: Yishai Hadas <yishaih@nvidia.com>
---
 drivers/vfio/pci/mlx5/cmd.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/vfio/pci/mlx5/cmd.c b/drivers/vfio/pci/mlx5/cmd.c
index 41a4b0cf4297..7527e277c898 100644
--- a/drivers/vfio/pci/mlx5/cmd.c
+++ b/drivers/vfio/pci/mlx5/cmd.c
@@ -423,6 +423,7 @@ static int mlx5vf_add_migration_pages(struct mlx5_vhca_data_buffer *buf,
 	unsigned long filled;
 	unsigned int to_fill;
 	int ret;
+	int i;
 
 	to_fill = min_t(unsigned int, npages, PAGE_SIZE / sizeof(*page_list));
 	page_list = kvzalloc(to_fill * sizeof(*page_list), GFP_KERNEL_ACCOUNT);
@@ -443,7 +444,7 @@ static int mlx5vf_add_migration_pages(struct mlx5_vhca_data_buffer *buf,
 			GFP_KERNEL_ACCOUNT);
 
 		if (ret)
-			goto err;
+			goto err_append;
 		buf->allocated_length += filled * PAGE_SIZE;
 		/* clean input for another bulk allocation */
 		memset(page_list, 0, filled * sizeof(*page_list));
@@ -454,6 +455,9 @@ static int mlx5vf_add_migration_pages(struct mlx5_vhca_data_buffer *buf,
 	kvfree(page_list);
 	return 0;
 
+err_append:
+	for (i = filled - 1; i >= 0; i--)
+		__free_page(page_list[i]);
 err:
 	kvfree(page_list);
 	return ret;
-- 
2.18.1


