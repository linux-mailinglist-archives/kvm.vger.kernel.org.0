Return-Path: <kvm+bounces-29292-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 854DD9A6AB0
	for <lists+kvm@lfdr.de>; Mon, 21 Oct 2024 15:43:09 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id BD6E8B239A6
	for <lists+kvm@lfdr.de>; Mon, 21 Oct 2024 13:42:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E97AF1F8EF8;
	Mon, 21 Oct 2024 13:41:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="S1cOZ8UY"
X-Original-To: kvm@vger.kernel.org
Received: from outbound.mail.protection.outlook.com (mail-dm6nam04on2052.outbound.protection.outlook.com [40.107.102.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F3AB1F12EA;
	Mon, 21 Oct 2024 13:41:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.102.52
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729518096; cv=fail; b=T++1EhAb5sWiddTH7r7u+y/UnMO4AgNL3m9feYPfXDAUSPkedQK4/9eTAe7dJRkOtSsRxk8zBmu/hPcd0CIxJHp4RJKCIZyeXMbzGYu4aNSBbwGNnznz5Z1p/MloirMpScGXtRyJ9O3J6uhxtP6TC6nbYN7xVQxE4EmRsMpq78k=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729518096; c=relaxed/simple;
	bh=Ga/Vi8yVUKlEcNx7eBvsD0BaSj0Zi8IpgpybQ0mha8Y=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=JGYlzxBUYq7XQbaPq4ENlngra4zlL5H4VQewkq9thClAG+GIjUqW90NwscJVLawLxdAUGUQxLpyDGFlPFCv0DPxdndzXENmFMNG05MxTPlBZtvqg7hAxA0TPHJ1vUuGTZXmbBmWnL9Vg6ZrOBKR5I9vvV4iUABIF926hK3hxk3k=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=S1cOZ8UY; arc=fail smtp.client-ip=40.107.102.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=juTmLd7I9PjBj/M2LMeZz9HXOEXCa1MjKDtw1jtAkpvaCsv7lOgeEuTHM1aFLfjFaRmUmdumfoQQIUG3/mEQyNfimSNa4xqQymyngACXO8xIEJzq4R3//fBq+lgKB6dCZ/IodbXGpQPCMeaxNDZzgfdck+ejUgjPZ+Oz1mz6PrIAKg21hgORBzQc5tdNZoZ3AsgJ/CTZ0K/cLuZY1rQV1Cw9d3LT9Sa/jC6uJmrjJA23eLgRi6Emy4xdMtoNJMNve2FumaVxSLnfLYHJ8Fliofc/KLnxiE2HuiYQ5XyxkbSFpuxMi5E0tGLJE/I7AdfXgVDR5eVLQTY+NpQN6u4Uzg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=1+CxSH1g3xkZQPfs5XeBBJ1+43gSTlRB6LKA9UYGeCs=;
 b=cG7REzq20bZjMII05L3EV8vpeTJwsv9FKzND85EXXh99E4tIQaHzbwXQ95DNhi30yoeSNEypcdRfpHf0vAjaHL9VP3Osf8GfSg4xtxxB1yX1bBQcv18+j9DVGpFYCa/yFJmdX5xrLah8BWbejlPyUzQIKiJryjqoL75vZxK4k8UBCMK1qxPcWlAGXB3SPGcYos/YPWZ+TYyjv8Nersq1MXp6t5NT2Wn7tSuLmZap/CGaNK8Ibf6Rt0mDqUeuXf7su6VxaiDojymDnkIPvor4upWsdWZjEUWfs9xpgFxFOyxWn69EM53rGuVb+uWBEu2N+ocYkhXTPr1/9C0ZNQeU+Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=redhat.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1+CxSH1g3xkZQPfs5XeBBJ1+43gSTlRB6LKA9UYGeCs=;
 b=S1cOZ8UYnLnoftZDL/dLj763Fgsb75v+mzXJ/HTdZ1wjpTccOtYe0oNAp6iSo5ArJQCOjzi31GaWe7iknsHR0dP61795piCh8aSm6MeTNjL6yJfDSV5JepuKDMDw2gfwvuWK4tdQlN6KieeHoEf1mWGUUPVq5DCIpYSUTxgWT40BesWPAeeOAENd1x1DB5v/7gMzJt+ZkgBifep33nka71EuKFde/J5pNef2D+Mnr9eJIuKP/TUT08WhBWpwYkZ/AJdx4hnU3+T+owhNDBs8gtcZtW7/1yXcGyDkEfkyMRPwNdDH4HrTXVjRuyQbSFGaZ50WFDEHv9vcB2t+hDpWOQ==
Received: from SJ0PR13CA0003.namprd13.prod.outlook.com (2603:10b6:a03:2c0::8)
 by SA3PR12MB7976.namprd12.prod.outlook.com (2603:10b6:806:312::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8069.29; Mon, 21 Oct
 2024 13:41:28 +0000
Received: from MWH0EPF000989E9.namprd02.prod.outlook.com
 (2603:10b6:a03:2c0:cafe::11) by SJ0PR13CA0003.outlook.office365.com
 (2603:10b6:a03:2c0::8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8093.15 via Frontend
 Transport; Mon, 21 Oct 2024 13:41:27 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.161)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 MWH0EPF000989E9.mail.protection.outlook.com (10.167.241.136) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8093.14 via Frontend Transport; Mon, 21 Oct 2024 13:41:27 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4; Mon, 21 Oct
 2024 06:40:49 -0700
Received: from rnnvmail203.nvidia.com (10.129.68.9) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4; Mon, 21 Oct
 2024 06:40:48 -0700
Received: from c-237-113-220-225.mtl.labs.mlnx (10.127.8.12) by
 mail.nvidia.com (10.129.68.9) with Microsoft SMTP Server id 15.2.1544.4 via
 Frontend Transport; Mon, 21 Oct 2024 06:40:45 -0700
From: Dragos Tatulea <dtatulea@nvidia.com>
To: "Michael S . Tsirkin" <mst@redhat.com>, <virtualization@lists.linux.dev>,
	Si-Wei Liu <si-wei.liu@oracle.com>
CC: Dragos Tatulea <dtatulea@nvidia.com>, Jason Wang <jasowang@redhat.com>,
	Eugenio Perez Martin <eperezma@redhat.com>, <kvm@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>, Gal Pressman <gal@nvidia.com>, Parav Pandit
	<parav@nvidia.com>, Xuan Zhuo <xuanzhuo@linux.alibaba.com>
Subject: [PATCH vhost 0/2] vdpa/mlx5: Iova mapping related fixes
Date: Mon, 21 Oct 2024 16:40:38 +0300
Message-ID: <20241021134040.975221-1-dtatulea@nvidia.com>
X-Mailer: git-send-email 2.46.1
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
X-MS-TrafficTypeDiagnostic: MWH0EPF000989E9:EE_|SA3PR12MB7976:EE_
X-MS-Office365-Filtering-Correlation-Id: 7b85a3ea-fc7e-463a-6003-08dcf1d61033
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|82310400026|36860700013|376014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?BtZGz/5u9qohY+QH2kQlfdG4UBggT7to4dVqYkOnQPoiwyInrRMn/7jgScRR?=
 =?us-ascii?Q?uuzcmlc0qvq2xF8zgL1HcJHtzub3oIxlh7i04xlEY/6BLvJcZgMeRPTneUCX?=
 =?us-ascii?Q?SqUqHHKCDTiXQfIS/A3QWDV1Mx7J5GpjlvJKJ/Y7GwjPokaARuPVt2gy+BwE?=
 =?us-ascii?Q?jlPPiW/dOGisE6i3er5fD3ZoSwPOsSweATBecqbWfyUJnCXrITrHBYurUeN7?=
 =?us-ascii?Q?7YU8K8KKupqBeKsQZZxMCRYsPGNH+FjPEBmuoW06bPjkQXiERqR+3HroS+b2?=
 =?us-ascii?Q?GjBzi0wwhWItsUnkd7bzZOngGHj3urTD2W3LUAibFvvwthvRRxEub6P2ZB+Y?=
 =?us-ascii?Q?8tKlsaOL4dAXRNM3Z+Qu4Zt9OkCE4ixqsH9f2B2xhlImBWvDGJWaQUOzKM9i?=
 =?us-ascii?Q?BQf75Ne9AMXeStCVZzNaVNK4lv6gmlW1f7PJ6j23WYg9ueiJkRbu9gyaoJKb?=
 =?us-ascii?Q?QYJAB/XLYovPKL9R3UgP9fq7zqujnT0MNkvq6Ob7Ce+/O70tWjlKGKJvx0BU?=
 =?us-ascii?Q?veM/ifNUZpP9htm38qV7vSGnKuHFkU/UFn9aokKELDjgXVjSUm0w284gFpe3?=
 =?us-ascii?Q?DFTFhxm7L/T24Fywo44QRs4C0pyNGrWDGezMq4G54VsYpf+J1rvXQXVfG2mK?=
 =?us-ascii?Q?yzRHXbLOwGn2q/7DTp0lFKF57shJlvICpy8vQpmbC2DJX9nUbpDfaAGBzHtI?=
 =?us-ascii?Q?PLb1JCsKICZJqrTCgdD+LbJF3w76NTbq++Kj4uTnit8PNGKCsv6TUj9LVpMj?=
 =?us-ascii?Q?IMvZt+rMAPNz4ltiiRhzjwmhBpEJ99kv3OJOj/Ufy+NRMQDpXsivmfeVXZtv?=
 =?us-ascii?Q?Gx2Zj0B7tbLCsxsFx91gNLb8zSRSZ5p6+3q1LCvS3W6OEU/7vKcHPXso/L52?=
 =?us-ascii?Q?TjVSWFtxmshsoqHOpDSUVTc8RV4HSkU86k6d8bN2rNyva6sA4rOQTKTs35sz?=
 =?us-ascii?Q?tIiZdDPBcxeOxVWaaUO5ZwM3MsCeU75ChaHz8YhC/yJHq5VyytjIhig9jYZl?=
 =?us-ascii?Q?Anzs+6iU03uA0d8Yi45jwRu7GzxduUhSsuzahdLvlXDw15fdHSh0QP88sp6y?=
 =?us-ascii?Q?huNDZIrt0J+PaB4PITwYHB+iVMCMc9UY0ggE3ti9GuLyRWelRZ2Ffb0QtwUO?=
 =?us-ascii?Q?kT2nRtxASvz0gSkpydcFpS2kIC5vWkAxZlhgR5ETknFrm4pD7BK+NdSG/1pA?=
 =?us-ascii?Q?KTA2rdSxCUOgqwI1k7E/ws13uruJ4PpKTAvWk7F0iJp3lHEq5gyjLirEAGvX?=
 =?us-ascii?Q?CNZoXEx1Onb3EnilzPtdLbkF6k2SeITMk0ujbyQrfr0imo4v2YkASGrTWwXJ?=
 =?us-ascii?Q?ioK849rnooj+lwpRWd7cjfp13ZWXzvot6Gg1i3AVV4S6gKPcZ19hkqxGYkjH?=
 =?us-ascii?Q?5WeRG3yDBeGaew4De8m+jQ4qykbFhwTb02rrUQFnGBuF8dJn8Q=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230040)(1800799024)(82310400026)(36860700013)(376014);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Oct 2024 13:41:27.6240
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 7b85a3ea-fc7e-463a-6003-08dcf1d61033
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	MWH0EPF000989E9.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA3PR12MB7976

Here are 2 fixes from Si-Wei:
- The first one is an important fix that has to be applied as far
  back as possible (hence CC'ing linux-stable).
- The second is more of an improvement. That's why it doesn't have the
  Fixes tag.

I'd like to thank Si-Wei for the effort of finding and fixing these
issues. Especially the first issue which was very well hidden and
was there since day 1.

Si-Wei Liu (2):
  vdpa/mlx5: Fix PA offset with unaligned starting iotlb map
  vdpa/mlx5: Fix suboptimal range on iotlb iteration

 drivers/vdpa/mlx5/core/mr.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

-- 
2.46.1


