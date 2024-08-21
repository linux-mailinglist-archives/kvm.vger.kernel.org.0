Return-Path: <kvm+bounces-24713-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id DD11E959AC9
	for <lists+kvm@lfdr.de>; Wed, 21 Aug 2024 13:53:56 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 0C6081C22422
	for <lists+kvm@lfdr.de>; Wed, 21 Aug 2024 11:53:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0DD521AD5CC;
	Wed, 21 Aug 2024 11:41:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="cbq/RRgO"
X-Original-To: kvm@vger.kernel.org
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2070.outbound.protection.outlook.com [40.107.220.70])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9533C1D12F4;
	Wed, 21 Aug 2024 11:41:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.220.70
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724240507; cv=fail; b=hkVJK01lvshpxfqOXstt+xKstIG/p//dFmWPR/cz7DZPKB8dPmNn5xU6Vpeoh45W6yBavZ20T2KsU9MYlEc1l5xvBgyYQyb25SIf3B9FPLtj/LD7mzW7KjWj960JhsrdBtT94Q61dpRf+nm81IlHY/5CgUJJvdxa7RjVG8QfmRs=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724240507; c=relaxed/simple;
	bh=2a6QHscod92D5hWXROT7+iAX//sffO+pBeJj9zU2bn8=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=InAO6RwvU7lzxUzyxQg6vjN6cfst1WB31iNs4z8kLaJxd9baZKLSoJ6yHh5dttXMbp81s3nJfNk45MpvI700nLfd9/vwRWDxR7O1dR8wwhum/qEN98R+E4awtaysI7DsceJ+H2MriIPw4JNOMLykCb1vQNRhUPd7Yxo6T7Zabp0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=cbq/RRgO; arc=fail smtp.client-ip=40.107.220.70
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=rvhSUpUrduB8Qu9YRgCA2cJTwLtqb3mtHUk7ndcyNmLi+XoHe8o0l67yO/m5c/U0sXV7h+mmNRRgfgDEU/7nDYz704Xd3yKjP3g6yQkYIbGGDxB5UzwBBlhEIpoIvy7kxOGmrPV5r2Bds5TZ02Jqtx7mkvQViqxDbC8hB5a58Ml5GtcTGP7GZMhu1QpW70+Nh5RyAJIv6QbdUJMcbdyA6aCNjuBQiqhFZv+1XOIZzrJdL7Uea1EJHE3t+3ZF0+xwEQFdPf7xX4w5WwQaFKf6wihEqkqEZRPboeNn+7mmj+BWkhnK4NKIi3/JeFvJktei/H3GaUopcFEiq4YMZxPx0g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=S3Sqg0EI5z7707p6hh+yzr98PaapwkNd/2wOsUOC0+E=;
 b=fmIzGBz58jkyL/H2fLPDXNxQ7okmU3Dz+bMJDq5JU42JwuZrKMfFE4AmO7vA1Bl6rZXGOYfq+FYzYpQev6MAwONDonV1p+Wl9ZhW6uQD356MZmDEm3C87q0Uj4ZqwPKfFo/oDswxyzfdYBZWTrsTojKF3cEZ+ZL+eMzkrTvKuiT+l+mVuLwY3f9QAl84hzAxR3js7XgFpbkPcp4i1ALne7StSa1V2zOQJiHlPegg5HX2Pz3fZpGHt1v85p+S12Dyr9R4I2fRDPQbJLeWsvnMePPN6Evkcwmw3g7y+M53Dp8AsJmLi5y0C0nHxt+3c7IyQeC8JwJLCaQIzpnze7jEgg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=redhat.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=S3Sqg0EI5z7707p6hh+yzr98PaapwkNd/2wOsUOC0+E=;
 b=cbq/RRgOVgVY/tTjRrFgFwv9ZDqPIaVjf2b9mN1jGf5hKKdkRLulhZ+ajt6Zv/ubjn6WVyGRgPdZGA30hFUrBQmpcSjRh3qftUuqy6jftpbuYzdp3SvtW3LnfOOiZJv4McnaGvLBgIieB/yVqbWUXSXbUkbtyxF4kykU/KhJaaBK4X/CKC7hQ5tf0XleW+IWm+rTNr527C6gaMa2B4aaKBnZZTrn5mM0FTvQ7e93xbyHaVbWwHpfVBfYtQxNPI5A0sQCVJ4h4hWu/gbV1Onqyr6WeUWqPmt5T0iBGzrgHgW9JaBhfiox/cX4Ye1UzQYpwjKNRcHpyaoJeydErghuQg==
Received: from BY3PR05CA0027.namprd05.prod.outlook.com (2603:10b6:a03:254::32)
 by PH0PR12MB8097.namprd12.prod.outlook.com (2603:10b6:510:295::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7875.25; Wed, 21 Aug
 2024 11:41:41 +0000
Received: from CO1PEPF000044EF.namprd05.prod.outlook.com
 (2603:10b6:a03:254:cafe::78) by BY3PR05CA0027.outlook.office365.com
 (2603:10b6:a03:254::32) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7897.13 via Frontend
 Transport; Wed, 21 Aug 2024 11:41:41 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.161)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 CO1PEPF000044EF.mail.protection.outlook.com (10.167.241.69) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.7897.11 via Frontend Transport; Wed, 21 Aug 2024 11:41:41 +0000
Received: from rnnvmail203.nvidia.com (10.129.68.9) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4; Wed, 21 Aug
 2024 04:41:28 -0700
Received: from rnnvmail201.nvidia.com (10.129.68.8) by rnnvmail203.nvidia.com
 (10.129.68.9) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4; Wed, 21 Aug
 2024 04:41:27 -0700
Received: from c-237-113-220-225.mtl.labs.mlnx (10.127.8.12) by
 mail.nvidia.com (10.129.68.8) with Microsoft SMTP Server id 15.2.1544.4 via
 Frontend Transport; Wed, 21 Aug 2024 04:41:25 -0700
From: Dragos Tatulea <dtatulea@nvidia.com>
To: "Michael S . Tsirkin" <mst@redhat.com>, Jason Wang <jasowang@redhat.com>,
	Eugenio Perez Martin <eperezma@redhat.com>, Si-Wei Liu
	<si-wei.liu@oracle.com>, <virtualization@lists.linux-foundation.org>, "Gal
 Pressman" <gal@nvidia.com>
CC: Dragos Tatulea <dtatulea@nvidia.com>, <kvm@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>, Parav Pandit <parav@nvidia.com>, Xuan Zhuo
	<xuanzhuo@linux.alibaba.com>
Subject: [PATCH vhost 0/7] vdpa/mlx5: Optimze MKEY operations
Date: Wed, 21 Aug 2024 14:40:54 +0300
Message-ID: <20240821114100.2261167-2-dtatulea@nvidia.com>
X-Mailer: git-send-email 2.45.1
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
X-MS-TrafficTypeDiagnostic: CO1PEPF000044EF:EE_|PH0PR12MB8097:EE_
X-MS-Office365-Filtering-Correlation-Id: 193123ba-e645-4df9-e607-08dcc1d63997
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|1800799024|36860700013|376014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?6Ci3D3aPMxKVzsrDPnFXXyDTOL82B4gYzXI3UadTwcNvu1d4QsyP3ROpfkGx?=
 =?us-ascii?Q?KrD8pW0bgNxxnJ14+JacXMAp10+ikQIhGyKHUR24BK855TANKWUStrrIXR0O?=
 =?us-ascii?Q?d9iKyfoXBsX7tLm3QGt584D5T5UbwRXoqES/9x27hS3gK5ZW3QMeM8ua33eX?=
 =?us-ascii?Q?bk68mZxKtEmMhlT4cKuBHgEFTY5hi2O2NRE//nAoA7K1e5YCuL8k+9bYUJUr?=
 =?us-ascii?Q?hEm2xjP8xYZMYANvY3ktDmt3wrHkwNiqMiDMlXwxaxWz4OBp7D8PEz6QyigI?=
 =?us-ascii?Q?xPHtCjC3g3JDStiJAKR6zIhSx4vb45MkReQmw6fnwLMdbTdjRxuMgu7So7cJ?=
 =?us-ascii?Q?hRyEg3uyw6hUv+AYk0jBeWutj5bitTyc+glc23NcpmjsJfqlLo53AdpcDegK?=
 =?us-ascii?Q?duV8wf6GD1NMbKOWpLM6yy4IsXk2JxqxBchSUkn0hNdFsnB9m64dsSWe1sUM?=
 =?us-ascii?Q?hzjeJ5xm5P9+BiG3DL1PHxUezwrpmo3BiqteaFV1iqGaRwumY0EIk+R3rIrT?=
 =?us-ascii?Q?io23GocB90fgz/oWIfpJPARya5NqWIvIRYg1LtisbogLahkS2MHcrZxIZ1Ip?=
 =?us-ascii?Q?UHuXYS3zY1Y/ZbJU4B/Iw3F/dSwHiNLpX2QJxUCBHOZ9yT/Zvr2pey4L8oRl?=
 =?us-ascii?Q?Po0z9k7Vxmumuur7L60Vo+VRTUU3OaNx9NBO5f56PVmcMK7pC73IJFxq5a4K?=
 =?us-ascii?Q?jziiDfp9C7T0UgvgvsUgB1K5iAr7CcB/j2/g3LTNmhTqAlNr2OaRYvrGSefI?=
 =?us-ascii?Q?gqkZwccP0jV+cHWLi8VK48rBdKF0P+9lX5tPgrcFRyZY4EU6qJxLIkDTk48K?=
 =?us-ascii?Q?v5G3ptJw7RGO6uH4iz1F07vQQuWmA7OkWLBSXfdHVTqHh8NJeWgwClOhFBpd?=
 =?us-ascii?Q?cY6UgrodCshX2LzvModCsAf6mzdueqa4/QP3qWzFMP7XYguTzoZ6fQs31ASP?=
 =?us-ascii?Q?MdS8JRDdKRIdb4qGzr/LZMLlm0l48R+9uQ77q++KK+M/ISDPccPRIngtg1vY?=
 =?us-ascii?Q?knYspqLWFngh3ltA1ygf2US6n/C29bTqQEubZ6X7osL9s5RqVRaI06bbxXwL?=
 =?us-ascii?Q?8Rq16jlMiLMuS2RFetjRRLu0mqgiB8HmEgvG29U+Lz5HA+XS4j6YjUJcYDDc?=
 =?us-ascii?Q?PIprwnqa7xPFXbJZVtOF4mjpEX12VoBqbQEq1U4bDg7/lPGq8ppl1zb049x/?=
 =?us-ascii?Q?EBQpid7fwXvn1a+XkCbQJNuEwm7Xf4QyelwII/DdmjLwKVmXsuPNHBAVKQ7j?=
 =?us-ascii?Q?y12bF7wNWTGeUg/0F7pS4WhwmzMjKYxd7q89vZCe2CuowTpTN/Eo9nvAAytf?=
 =?us-ascii?Q?aJg81OtZ0elVHY+NMO35fJ1RMTwun6PHIGFyIGDVKDmLo9VlU3ygcr8jDCSL?=
 =?us-ascii?Q?OJ8bdM08PTfIgS/dbH0wKIbspwrmnetJIycEyQh34jmH4rdgbRBbKOz1mIxG?=
 =?us-ascii?Q?A4RZKeM4nEs/ta27kiGzs638vuLb6v4u?=
X-Forefront-Antispam-Report:
	CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230040)(82310400026)(1800799024)(36860700013)(376014);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Aug 2024 11:41:41.2248
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 193123ba-e645-4df9-e607-08dcc1d63997
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CO1PEPF000044EF.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR12MB8097

This series improves the time of .set_map() operations by parallelizing
the MKEY creation and deletion for direct MKEYs. Looking at the top
level MKEY creation/deletion functions, the following improvement can be
seen:

|-------------------+-------------|
| operation         | improvement |
|-------------------+-------------|
| create_user_mr()  | 3-5x        |
| destroy_user_mr() | 8x          |
|-------------------+-------------|

The last part of the series introduces lazy MKEY deletion which
postpones the MKEY deletion to a later point in a workqueue.

As this series and the previous ones were targeting live migration,
we can also observe improvements on this front:

|-------------------+------------------+------------------|
| Stage             | Downtime #1 (ms) | Downtime #2 (ms) |
|-------------------+------------------+------------------|
| Baseline          | 3140             | 3630             |
| Parallel MKEY ops | 1200             | 2000             |
| Deferred deletion | 1014             | 1253             |
|-------------------+------------------+------------------|

Test configuration: 256 GB VM, 32 CPUs x 2 threads per core, 4 x mlx5
vDPA devices x 32 VQs (16 VQPs)

This series must be applied on top of the parallel VQ suspend/resume
series [0].

[0] https://lore.kernel.org/all/20240816090159.1967650-1-dtatulea@nvidia.com/

Dragos Tatulea (7):
  vdpa/mlx5: Create direct MKEYs in parallel
  vdpa/mlx5: Delete direct MKEYs in parallel
  vdpa/mlx5: Rename function
  vdpa/mlx5: Extract mr members in own resource struct
  vdpa/mlx5: Rename mr_mtx -> lock
  vdpa/mlx5: Introduce init/destroy for MR resources
  vdpa/mlx5: Postpone MR deletion

 drivers/vdpa/mlx5/core/mlx5_vdpa.h |  25 ++-
 drivers/vdpa/mlx5/core/mr.c        | 284 ++++++++++++++++++++++++-----
 drivers/vdpa/mlx5/core/resources.c |   3 -
 drivers/vdpa/mlx5/net/mlx5_vnet.c  |  53 +++---
 4 files changed, 293 insertions(+), 72 deletions(-)

-- 
2.45.1


