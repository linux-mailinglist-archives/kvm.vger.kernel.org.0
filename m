Return-Path: <kvm+bounces-24715-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id E973B959AD3
	for <lists+kvm@lfdr.de>; Wed, 21 Aug 2024 13:54:43 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 9C93128278F
	for <lists+kvm@lfdr.de>; Wed, 21 Aug 2024 11:54:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3EE771AF4E7;
	Wed, 21 Aug 2024 11:41:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="IfEni7b+"
X-Original-To: kvm@vger.kernel.org
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2088.outbound.protection.outlook.com [40.107.236.88])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BB15B1AF4C6;
	Wed, 21 Aug 2024 11:41:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.236.88
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724240518; cv=fail; b=umBAnSv1Icc37OWUZkTze+9Bm0Td0o0ewRrVny8R1rMVsZBhU17SCNIsIuMp60kkbEHWK3eQx0wzejCmUfRcbWdOeA+W7/np40xvmcUiNF8066RmjCnBdHfsfbrc5jQ5qFCU8VSlguwysvgITN78yYb8x6IFjE0YL1R6Gi/SEWI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724240518; c=relaxed/simple;
	bh=B99iV/82iKQbHub91kQZzVytCTtsTt+PrPW0hbjqZ2o=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Clv1QuPAe6dlqQ1f3fuzaDAqy4F4t0Z08B5mwiF/Ze8HDMOsIIF9LWLv/v/IkdKf0VJDPsD3cp6GaYyvOWR7bi6bYnm2Fxyt8/zh4FxegvElcUImo6r4aOgbJjOPkquMAqGfGE3MrMfDN277wu0PtaxmM72tr2vnEY2KfpUlLH8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=IfEni7b+; arc=fail smtp.client-ip=40.107.236.88
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Mfb2ShL6f10lUO4Ss+ALfzBK8LiiftKTbYeL/e4Tny1Am86hqIddoJ0odqj7nPiFUPjkFExFejHu5XkuCrsryQSocYQjrhDDpUir1N9vXmudS3TcTLgvQrlKVO+YRZxdQbRIM3N3xCKR/lENZW5uGuX3iH8svaTZNakZdKuyFqXhdoBEcB4W9EaqtLdqVNJe4q/6d9jnJiLZOVlquTgmJfS6rOjHJzsiRF7W2IaQwQs3Oh8FrtO2U1o9KckZQybjx1+3zOKoZR700YF+hhB3zjudpfaKkCE/nJmRgUIKqz46wJqA5gkXdCwQV6nEjc5Xk+JfN+6yLkZ6wSXvSzJtxQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=T4d+PTjaMFkC4xdZw3JnzT0oM8Mh0RfDqURheqd+GKE=;
 b=quEPLw2RLS1OAxyiXaoFqZuOx1sSi3GQdw65/bOy4OrU3BBVza8BwixVBYxbzScgHoFc7f5tqYaBYiRV94GIMZrGbWYcErNjq7qjSaExN7Dh+qRMEuARjqHiHhFXw29uNWM+CwQeRQZp3PlJX3B+e7BI165Am8uA+DVU20XCNwm/DWS6dwy+oYi/Rr321uj4ROI9KvW4NoblMpuco82EErlRC4ov+nBR7azXoZmIJVmS1LKfFiZdvXps5gjYY5GZZxl6trVTNf1xXJ92bYnq7p45aYfeLfNDfkPCjA6QZR5i2RaQdltMlelI6Sm6FJPaUjkNaxe8N3QxEOaFi2KBVQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=redhat.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=T4d+PTjaMFkC4xdZw3JnzT0oM8Mh0RfDqURheqd+GKE=;
 b=IfEni7b+OSSa/cRnLDxvZ8kGb7QOP2fPdP64IewXlirrixLfjbgimr2qMspnvJHYnoDYlY/RCobQ/i2dh+AT5fhcLSv8ba6TqWxiTNE4w45LOF5gLnjIhuUvX89AzbEn4dBz4Sdwe0zht22ypXZI1lKnFWuXAN2WrUbb82fMlX+dKU/FE2/SX8FjRuB+3yQYQivhcZ2o8LqpGR+sk8fcsKzRAOQploO6BWZ9vIQYUEDVnN7VGFW6i2fWdA3oeBz4btVYVpl8BvNiw7fcJN0Uf0noVVE7PR+60faI2ot4r/xuiwqPG6hHQc1cqfiYw8s/5KHRR/KPN6nIMRl+xlGsWg==
Received: from MW4PR03CA0310.namprd03.prod.outlook.com (2603:10b6:303:dd::15)
 by CY8PR12MB8314.namprd12.prod.outlook.com (2603:10b6:930:7b::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7875.25; Wed, 21 Aug
 2024 11:41:52 +0000
Received: from CO1PEPF000044EE.namprd05.prod.outlook.com
 (2603:10b6:303:dd:cafe::99) by MW4PR03CA0310.outlook.office365.com
 (2603:10b6:303:dd::15) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7875.21 via Frontend
 Transport; Wed, 21 Aug 2024 11:41:51 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.161)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 CO1PEPF000044EE.mail.protection.outlook.com (10.167.241.68) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.7897.11 via Frontend Transport; Wed, 21 Aug 2024 11:41:51 +0000
Received: from rnnvmail202.nvidia.com (10.129.68.7) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4; Wed, 21 Aug
 2024 04:41:39 -0700
Received: from rnnvmail201.nvidia.com (10.129.68.8) by rnnvmail202.nvidia.com
 (10.129.68.7) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4; Wed, 21 Aug
 2024 04:41:38 -0700
Received: from c-237-113-220-225.mtl.labs.mlnx (10.127.8.12) by
 mail.nvidia.com (10.129.68.8) with Microsoft SMTP Server id 15.2.1544.4 via
 Frontend Transport; Wed, 21 Aug 2024 04:41:35 -0700
From: Dragos Tatulea <dtatulea@nvidia.com>
To: "Michael S . Tsirkin" <mst@redhat.com>, Jason Wang <jasowang@redhat.com>,
	Eugenio Perez Martin <eperezma@redhat.com>, Si-Wei Liu
	<si-wei.liu@oracle.com>, <virtualization@lists.linux-foundation.org>, "Gal
 Pressman" <gal@nvidia.com>
CC: Dragos Tatulea <dtatulea@nvidia.com>, <kvm@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>, Parav Pandit <parav@nvidia.com>, Xuan Zhuo
	<xuanzhuo@linux.alibaba.com>, Cosmin Ratiu <cratiu@nvidia.com>
Subject: [PATCH vhost 3/7] vdpa/mlx5: Rename function
Date: Wed, 21 Aug 2024 14:40:57 +0300
Message-ID: <20240821114100.2261167-5-dtatulea@nvidia.com>
X-Mailer: git-send-email 2.45.1
In-Reply-To: <20240821114100.2261167-2-dtatulea@nvidia.com>
References: <20240821114100.2261167-2-dtatulea@nvidia.com>
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
X-MS-TrafficTypeDiagnostic: CO1PEPF000044EE:EE_|CY8PR12MB8314:EE_
X-MS-Office365-Filtering-Correlation-Id: d5e2a10b-b1b8-448a-c9d3-08dcc1d63fd4
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|36860700013|376014|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?0gLKV2FaWiEcmqeHxgHYXU7Jotedi8NTFe3gpQcAZLTg89Hz2Sz1/9SE8DUP?=
 =?us-ascii?Q?tHc2EbL2YkIPBEH/ic9QjZBva83iITTBn7tjPJKljMOM0I/hzkmaavRtQ7ml?=
 =?us-ascii?Q?mmZuUzPsb1fjUGh2V7mADYWDTXavSY3qOZmTfn78TJ862CFBtlAFxfls5ijt?=
 =?us-ascii?Q?4oC4LsPMhkNFtvGK3dcI6hHReELycd2KLr5tX2+O63FzNuU9BjfXlpj2gKBV?=
 =?us-ascii?Q?ra7RdI0y0FOP24bZjk/BDFMxTr1SzM4fU5ayEBBUztyPNtbkzBG+56Tkf0Q9?=
 =?us-ascii?Q?L02NaKMTRB/pfOCWfPysxiOBJnO72yXE+/z1mGVS7uHS5BY+A4tSeUnw9JZi?=
 =?us-ascii?Q?57BCyi/gyul2ZhmutnlK9JJh1/806YJMI+ZbwNCjewc6hpy19d8DO31nJmIC?=
 =?us-ascii?Q?rp8tdStkajWlGJ1a+kKRvgtC02+dRby/FnDbw5KVtUvHpXBzP0VxV0RJfPqV?=
 =?us-ascii?Q?Niw3IGJvyp92GVX2bTvi8948tcpydl+IK9MrOKxkdHO2eNVV8CeXSXvQJMj4?=
 =?us-ascii?Q?rE7fOVPDQ2MVHJVkEr38Y7MEiEvf/b9mNvkh4U6/2NUVPgvza8cGbNijm3Nb?=
 =?us-ascii?Q?sbqsIDsXa14oZNHVo3ONwQATNB7EBYs4ZrN0Uj4XPeDJQwVpKwzpyHt8uGRo?=
 =?us-ascii?Q?PVX0b31wdlAmk3A05Ih1YwTTSLEjNs3LHrvoe+o8MiYOMVpncaPxo4jkxvHh?=
 =?us-ascii?Q?igJFDCpbAVY2ZxEmVjx+BkuWyFEJnUh3EIQkRFRet5ykmv7v6D0nDSoBUMjD?=
 =?us-ascii?Q?0O4X2qjd2mni6yz4KXKxGwB0vHq2C3CsCn808fxAeqhjdeNJQDR+j4pWTYZJ?=
 =?us-ascii?Q?v9sBY1LiEea44GZzvuY3lcTvV/NRhfDTR750Fvz2cYqaaNSjWTUjUifuvYd3?=
 =?us-ascii?Q?nELsoUToqi+cIUorZkcY7wuzNERulcpbGE1X4kKAOubQEr3Q3fRCX10sP/ZT?=
 =?us-ascii?Q?KdHDUUKhjnGkKAt+uIByFDe9JHiXTqNyUCLiYGDwf6tZcjo5NVK/5rWWWRNF?=
 =?us-ascii?Q?Gbz/ZqSSQs0VcqKFf0MqS87K6s/wEZCrnXsKASztlYLRQZ+g57Xt5bHj7roC?=
 =?us-ascii?Q?bbiwJXWyFM5N8pLOpiKpyRsF5M/91+rFzamemJoY31al0mF0Q0A0oEN8JZUJ?=
 =?us-ascii?Q?9/PAlPywe5sxBGa1YO84uGHIKHPTRggnvoM71mdSvCazfJ4/MBqtV5sUfLL7?=
 =?us-ascii?Q?aofAboejZoeUehZsMzH07MQ3flUk4ZTqhQST//oFhi/KQCbIs3zZNFXtoYey?=
 =?us-ascii?Q?9qnXQauds+MI/IJTPAiD9UYcJxHZc5f8DQny76W+cljD7przUSb6Ae7EsSzc?=
 =?us-ascii?Q?iwMtdq5ryMhbaB95gNy9hcVPir4ijBRVg8JohdltHWvegPD+dUjniOyQvKZu?=
 =?us-ascii?Q?9Rtta3CI92xBc6fcrJ1trMxMts0LN/HwlT0ZrQwdUsbCIqEc13URe9XyUQ42?=
 =?us-ascii?Q?mC25P+vKH8QJyOseJKFNFND+SWjuQ6jB?=
X-Forefront-Antispam-Report:
	CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230040)(82310400026)(36860700013)(376014)(1800799024);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Aug 2024 11:41:51.6902
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: d5e2a10b-b1b8-448a-c9d3-08dcc1d63fd4
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CO1PEPF000044EE.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR12MB8314

A followup patch will use this name for something else.

Signed-off-by: Dragos Tatulea <dtatulea@nvidia.com>
Reviewed-by: Cosmin Ratiu <cratiu@nvidia.com>
---
 drivers/vdpa/mlx5/core/mlx5_vdpa.h | 2 +-
 drivers/vdpa/mlx5/core/mr.c        | 2 +-
 drivers/vdpa/mlx5/net/mlx5_vnet.c  | 8 ++++----
 3 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/vdpa/mlx5/core/mlx5_vdpa.h b/drivers/vdpa/mlx5/core/mlx5_vdpa.h
index 24fa00afb24f..4d217d18239c 100644
--- a/drivers/vdpa/mlx5/core/mlx5_vdpa.h
+++ b/drivers/vdpa/mlx5/core/mlx5_vdpa.h
@@ -135,7 +135,7 @@ int mlx5_vdpa_create_mkey(struct mlx5_vdpa_dev *mvdev, u32 *mkey, u32 *in,
 int mlx5_vdpa_destroy_mkey(struct mlx5_vdpa_dev *mvdev, u32 mkey);
 struct mlx5_vdpa_mr *mlx5_vdpa_create_mr(struct mlx5_vdpa_dev *mvdev,
 					 struct vhost_iotlb *iotlb);
-void mlx5_vdpa_destroy_mr_resources(struct mlx5_vdpa_dev *mvdev);
+void mlx5_vdpa_clean_mrs(struct mlx5_vdpa_dev *mvdev);
 void mlx5_vdpa_get_mr(struct mlx5_vdpa_dev *mvdev,
 		      struct mlx5_vdpa_mr *mr);
 void mlx5_vdpa_put_mr(struct mlx5_vdpa_dev *mvdev,
diff --git a/drivers/vdpa/mlx5/core/mr.c b/drivers/vdpa/mlx5/core/mr.c
index 8cedf2969991..149edea09c8f 100644
--- a/drivers/vdpa/mlx5/core/mr.c
+++ b/drivers/vdpa/mlx5/core/mr.c
@@ -719,7 +719,7 @@ static void mlx5_vdpa_show_mr_leaks(struct mlx5_vdpa_dev *mvdev)
 
 }
 
-void mlx5_vdpa_destroy_mr_resources(struct mlx5_vdpa_dev *mvdev)
+void mlx5_vdpa_clean_mrs(struct mlx5_vdpa_dev *mvdev)
 {
 	for (int i = 0; i < MLX5_VDPA_NUM_AS; i++)
 		mlx5_vdpa_update_mr(mvdev, NULL, i);
diff --git a/drivers/vdpa/mlx5/net/mlx5_vnet.c b/drivers/vdpa/mlx5/net/mlx5_vnet.c
index 822092eccb32..cf2b77ebc72b 100644
--- a/drivers/vdpa/mlx5/net/mlx5_vnet.c
+++ b/drivers/vdpa/mlx5/net/mlx5_vnet.c
@@ -3223,7 +3223,7 @@ static void mlx5_vdpa_set_status(struct vdpa_device *vdev, u8 status)
 err_driver:
 	unregister_link_notifier(ndev);
 err_setup:
-	mlx5_vdpa_destroy_mr_resources(&ndev->mvdev);
+	mlx5_vdpa_clean_mrs(&ndev->mvdev);
 	ndev->mvdev.status |= VIRTIO_CONFIG_S_FAILED;
 err_clear:
 	up_write(&ndev->reslock);
@@ -3275,7 +3275,7 @@ static int mlx5_vdpa_compat_reset(struct vdpa_device *vdev, u32 flags)
 	}
 
 	if (flags & VDPA_RESET_F_CLEAN_MAP)
-		mlx5_vdpa_destroy_mr_resources(&ndev->mvdev);
+		mlx5_vdpa_clean_mrs(&ndev->mvdev);
 	ndev->mvdev.status = 0;
 	ndev->mvdev.suspended = false;
 	ndev->cur_num_vqs = MLX5V_DEFAULT_VQ_COUNT;
@@ -3433,7 +3433,7 @@ static void mlx5_vdpa_free(struct vdpa_device *vdev)
 	ndev = to_mlx5_vdpa_ndev(mvdev);
 
 	free_fixed_resources(ndev);
-	mlx5_vdpa_destroy_mr_resources(mvdev);
+	mlx5_vdpa_clean_mrs(mvdev);
 	if (!is_zero_ether_addr(ndev->config.mac)) {
 		pfmdev = pci_get_drvdata(pci_physfn(mvdev->mdev->pdev));
 		mlx5_mpfs_del_mac(pfmdev, ndev->config.mac);
@@ -4008,7 +4008,7 @@ static int mlx5_vdpa_dev_add(struct vdpa_mgmt_dev *v_mdev, const char *name,
 err_res2:
 	free_fixed_resources(ndev);
 err_mr:
-	mlx5_vdpa_destroy_mr_resources(mvdev);
+	mlx5_vdpa_clean_mrs(mvdev);
 err_res:
 	mlx5_vdpa_free_resources(&ndev->mvdev);
 err_mpfs:
-- 
2.45.1


