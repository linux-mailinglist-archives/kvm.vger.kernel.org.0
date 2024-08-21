Return-Path: <kvm+bounces-24718-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 13A80959ADB
	for <lists+kvm@lfdr.de>; Wed, 21 Aug 2024 13:55:55 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 8F6C11F21C56
	for <lists+kvm@lfdr.de>; Wed, 21 Aug 2024 11:55:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EE9D51B3B1C;
	Wed, 21 Aug 2024 11:42:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="cQSvW1Ts"
X-Original-To: kvm@vger.kernel.org
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2074.outbound.protection.outlook.com [40.107.223.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5A8621B253B;
	Wed, 21 Aug 2024 11:42:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.223.74
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724240526; cv=fail; b=PiGWGvC2/oK+p9YfZWKiPy91Q609Z4rrxNnWe+Pdf33fKxNHnnSstcyfOW0tJrpbOmOBD6sws9uVwWnXx4rPN8mYztCkioVmG6R3dE7lFAIqp8wH++2igwQdpxFQCdFJDFXvgWtMRnrJdr+ajGiWNJDDfDlaFTkLWh7bLVt6Rb8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724240526; c=relaxed/simple;
	bh=U1sIKMc8LQ66Bv9U0BivUu/LigTPV1lCnvbmZ5mId1s=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=asHdVvFnphCXGBsZb4R+UmpTQIw3tadAyMvgCRelQGJtaeSbF2SI1DiCnv6RmmkNpSwPh5cvAsU6fNQkm+0SUXJWu8Q8D7nB7kga+y2BatKvbf1CgZh03kVnCU7Q3DIm8/5Z+VYxYw6khunOE65VN61gjuOxKPi4Sr+Obazs7NU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=cQSvW1Ts; arc=fail smtp.client-ip=40.107.223.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ssPpJjtj5NLp7JESL+mH6SFcCPzqtC6cHMlOxUPWj81lTsm8RSFdsKrB/MjU9ZMb2M9+Ri4l6k6W7+35jUVe6qnbgylr3rZOXaC302Grx5T4jawXenTtedydL1XzjpLz0he4icF0/XML9pcaTjYIjvvlHo0Q0ey/i/bzuAngrnThL9TtAL24CgdfXMM8YoRlvrfgx3kPR+GeF/pjhrFcf/+Gwa8Akdcfxc1LTbv/YHEPmcfc8IL0I4t6bQ/RDg1BOqRzHj4lMq5o5p4KXydHAUyEVhPJDXS7ER6hyQttAHlGndDWfVHaWn4LpZ+VnNM4IjdgX/Wqw3UEgWNv2Cfp7g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=/JzMx+i+G96tUwYKskpjpgDVQD+c8DXAXzYPTNkTEbA=;
 b=lDlkkxljuHJdKT169W+FiI1eUSSo9OB2kZl2B4Pjmn3mmiKdzizqvZXDHzoElnM5XlHPOJsCH6OXqcJpQ/xJeHArUMG9EQNbTCKSyUv3Ff2fdN9VPM81l2Bqcwc6kXqwD9Lv53n/xLPamWCwFG7M5xAC+WSIpqdWS9fmXgBZB+zfYCguziQAmr6uDvIAGfVvf3Tr+mu59pznpOROUzQHPzJ1sx6rCJYDueMQDzrPQpDwROq3l7ddlnQD48PW+kUfdHPD0m4Cd5+E0OHzy3nksNqjQVjKLr3TzXo5I5DFcayzSycaXHyxsUTwaTqyV+djSv65mycpaayoQI7ZUxBYEA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=redhat.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/JzMx+i+G96tUwYKskpjpgDVQD+c8DXAXzYPTNkTEbA=;
 b=cQSvW1TsxT+aRXH9bpbVnyHBLXt7vanWtP/aU1n7ozSqk+LVqzOz3pUiIKxJkXuYU7G2PnTU3ekZaWKb4IR4F0IaXd3q40Aai7QR0/Ojeks53d9aDY8kF4rea/6t+POAJf1P5bWbJ7vKRZjHpsqGWQxh8q2OtM2HJWRc2Vn0u7ApPDPwXmu59a8BLp36fLZAz2lDU9AON8t+9ryiIDNua02u6Fkowz2EF3prsuvuL+pHy1oN8HGHYheBC0D7NXtEXtWSsUShCIaZ89EGryJ2+/DMFC5GguXsK2lDdT1Dpj+tKJQNnqf2pf6VeVAt/d9TgM9c67bZphY5xQ1uGT9QQQ==
Received: from SJ0PR03CA0367.namprd03.prod.outlook.com (2603:10b6:a03:3a1::12)
 by CY5PR12MB6369.namprd12.prod.outlook.com (2603:10b6:930:21::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7897.16; Wed, 21 Aug
 2024 11:42:01 +0000
Received: from CO1PEPF000044F0.namprd05.prod.outlook.com
 (2603:10b6:a03:3a1:cafe::fc) by SJ0PR03CA0367.outlook.office365.com
 (2603:10b6:a03:3a1::12) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7897.16 via Frontend
 Transport; Wed, 21 Aug 2024 11:42:01 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.161)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 CO1PEPF000044F0.mail.protection.outlook.com (10.167.241.70) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.7897.11 via Frontend Transport; Wed, 21 Aug 2024 11:42:01 +0000
Received: from rnnvmail203.nvidia.com (10.129.68.9) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4; Wed, 21 Aug
 2024 04:41:50 -0700
Received: from rnnvmail201.nvidia.com (10.129.68.8) by rnnvmail203.nvidia.com
 (10.129.68.9) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4; Wed, 21 Aug
 2024 04:41:49 -0700
Received: from c-237-113-220-225.mtl.labs.mlnx (10.127.8.12) by
 mail.nvidia.com (10.129.68.8) with Microsoft SMTP Server id 15.2.1544.4 via
 Frontend Transport; Wed, 21 Aug 2024 04:41:46 -0700
From: Dragos Tatulea <dtatulea@nvidia.com>
To: "Michael S . Tsirkin" <mst@redhat.com>, Jason Wang <jasowang@redhat.com>,
	Eugenio Perez Martin <eperezma@redhat.com>, Si-Wei Liu
	<si-wei.liu@oracle.com>, <virtualization@lists.linux-foundation.org>, "Gal
 Pressman" <gal@nvidia.com>
CC: Dragos Tatulea <dtatulea@nvidia.com>, <kvm@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>, Parav Pandit <parav@nvidia.com>, Xuan Zhuo
	<xuanzhuo@linux.alibaba.com>, Cosmin Ratiu <cratiu@nvidia.com>
Subject: [PATCH vhost 6/7] vdpa/mlx5: Introduce init/destroy for MR resources
Date: Wed, 21 Aug 2024 14:41:00 +0300
Message-ID: <20240821114100.2261167-8-dtatulea@nvidia.com>
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
X-MS-TrafficTypeDiagnostic: CO1PEPF000044F0:EE_|CY5PR12MB6369:EE_
X-MS-Office365-Filtering-Correlation-Id: 50e2cb66-15f4-4837-073d-08dcc1d6456a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|36860700013|82310400026|376014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?9xpQevqBwpwT+XW6kbywSKoTw8YSKDTwkLlyHT/G27dUhYtD9OPIiU9tOZKO?=
 =?us-ascii?Q?gwAtfRyJvbaCuxPzev5RM0ME5+WSGbaDgCbzaWbQrSnmE1XdG/dFB07XelBf?=
 =?us-ascii?Q?Q9/Mch4cDbr9lcEU002ikPoFQuIEbeRZKd9aqxbcS87kDtjQUn4oMhiLWpX+?=
 =?us-ascii?Q?QqOktm77uFHw2tKt4ZxTDuqSOzFXXdRdQn+j7NEOSY+qbMIYFcvOawKAHmHG?=
 =?us-ascii?Q?ZUgT1OjK9tLZlQbn4m1KoTXqXYY6z3ZeUc6JuA8a32q8D8+bPpj/nLXdXep9?=
 =?us-ascii?Q?rebGd3cG57GkV+jxpNptqyKa/4YfQkko1W9IIFi05qhuNU0MnYa7GOVzeldb?=
 =?us-ascii?Q?1G3J2nZWWuIElvNvTISlGGKx5N595EgWr8+oWV2FaVrOwGsprmDZuAuJwpWz?=
 =?us-ascii?Q?RTpUFR0QLykN/ybf7RPouIxfTRpZlPoQFf1+6VHmS7CII9jMNJhTxU9AGW1R?=
 =?us-ascii?Q?/iAsWw6y19G2E9cKjBIBehqLt3XvSqhV5e6qXAhbpwvbmsvrAR40QRQIfo4W?=
 =?us-ascii?Q?CudN4C53FUaMhjNO7r8jyBRs8D9RunmgSefid8WrFD6gzGEjhJs4cUfE70S+?=
 =?us-ascii?Q?OytQlJgjmFtyxG7p7ALTQsfYRZ92fMz084u5UF+I/c2FH8bYz4CmsNpyjsve?=
 =?us-ascii?Q?SHl1kJchlwuY8k/513JOoQcbgkk/5cezf+UFeJvMEFlpW8kaCCRqPLCAonts?=
 =?us-ascii?Q?DfKi9N6w/IwgmoMmUAqBjuuJpPS/Y2/PEmFPwG6aFUc8ZXzATjYqq0C7lmLU?=
 =?us-ascii?Q?tYLO37xjPn8OVQhm+dIMVdhrRaEiaQCPN2Dy4W0NH9MQUzOSUa1Hq8L+sX3i?=
 =?us-ascii?Q?xwa8Y5o2O0uMI71ThJeIM0zEh/GHQlw+v97d0DYy5+ls5Ge5+AJ+fwAgA8eq?=
 =?us-ascii?Q?W8VggSmwhOSdAoAOc1+W4Ucxbu0rAT+tikIzG3yYxg/uvlPuESsMcXjvz4Fp?=
 =?us-ascii?Q?g+X5jakGysTO0hXsaO070YK1weVXRfHGcaE3Sk2GufQ/Okg15g015PQbPR3B?=
 =?us-ascii?Q?nalnoa0IuMsQyXkq2C2WKmShZZepstR0K4Nnzipmei60mq1NnlV0U0/gnHhh?=
 =?us-ascii?Q?02CyxwIae3NbVBagbOKByY0y5psYDdIw7vqpy+IE5pc6n5z3M2NK6phFpLJK?=
 =?us-ascii?Q?XanWXXzZXDzbm9ZpbGNHgPpYQXYJwZGf3XrgaT2QAbQ8mEM4FXNM8gGaztcg?=
 =?us-ascii?Q?ebxQFtLbYo55zGO9wSGl5L2QMpebz9OhJkS+CMj6K50hUnwTlcv3+6K2KIhp?=
 =?us-ascii?Q?JYCss1JS6870FbR1ZMeaHvLOjjeHtAgjTShx4knzX9G2IGFTJ5NRwUoYq7py?=
 =?us-ascii?Q?mQUU/HT6y4Sy/i7/qxEhD7gYBvG1prDQlfsFNmFzj264OwSU4028eCz+ysT5?=
 =?us-ascii?Q?HddKBoj//MMxn1LoUFvtqg7/kvqSlpjw++LsG1OzR6rzV9Oo2WLAyjQaR+tb?=
 =?us-ascii?Q?J9cbAkE1+lWf3QfhpnzQNK2mF/u8w4Lk?=
X-Forefront-Antispam-Report:
	CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230040)(1800799024)(36860700013)(82310400026)(376014);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Aug 2024 11:42:01.0568
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 50e2cb66-15f4-4837-073d-08dcc1d6456a
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CO1PEPF000044F0.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY5PR12MB6369

There's currently not a lot of action happening during
the init/destroy of MR resources. But more will be added
in the upcoming patches.

Signed-off-by: Dragos Tatulea <dtatulea@nvidia.com>
Reviewed-by: Cosmin Ratiu <cratiu@nvidia.com>
---
 drivers/vdpa/mlx5/core/mlx5_vdpa.h |  2 ++
 drivers/vdpa/mlx5/core/mr.c        | 17 +++++++++++++++++
 drivers/vdpa/mlx5/core/resources.c |  3 ---
 drivers/vdpa/mlx5/net/mlx5_vnet.c  | 10 ++++++++--
 4 files changed, 27 insertions(+), 5 deletions(-)

diff --git a/drivers/vdpa/mlx5/core/mlx5_vdpa.h b/drivers/vdpa/mlx5/core/mlx5_vdpa.h
index 89b564cecddf..c3e17bc888e8 100644
--- a/drivers/vdpa/mlx5/core/mlx5_vdpa.h
+++ b/drivers/vdpa/mlx5/core/mlx5_vdpa.h
@@ -138,6 +138,8 @@ int mlx5_vdpa_create_mkey(struct mlx5_vdpa_dev *mvdev, u32 *mkey, u32 *in,
 int mlx5_vdpa_destroy_mkey(struct mlx5_vdpa_dev *mvdev, u32 mkey);
 struct mlx5_vdpa_mr *mlx5_vdpa_create_mr(struct mlx5_vdpa_dev *mvdev,
 					 struct vhost_iotlb *iotlb);
+int mlx5_vdpa_init_mr_resources(struct mlx5_vdpa_dev *mvdev);
+void mlx5_vdpa_destroy_mr_resources(struct mlx5_vdpa_dev *mvdev);
 void mlx5_vdpa_clean_mrs(struct mlx5_vdpa_dev *mvdev);
 void mlx5_vdpa_get_mr(struct mlx5_vdpa_dev *mvdev,
 		      struct mlx5_vdpa_mr *mr);
diff --git a/drivers/vdpa/mlx5/core/mr.c b/drivers/vdpa/mlx5/core/mr.c
index f20f2a8a701d..ec75f165f832 100644
--- a/drivers/vdpa/mlx5/core/mr.c
+++ b/drivers/vdpa/mlx5/core/mr.c
@@ -843,3 +843,20 @@ int mlx5_vdpa_reset_mr(struct mlx5_vdpa_dev *mvdev, unsigned int asid)
 
 	return 0;
 }
+
+int mlx5_vdpa_init_mr_resources(struct mlx5_vdpa_dev *mvdev)
+{
+	struct mlx5_vdpa_mr_resources *mres = &mvdev->mres;
+
+	INIT_LIST_HEAD(&mres->mr_list_head);
+	mutex_init(&mres->lock);
+
+	return 0;
+}
+
+void mlx5_vdpa_destroy_mr_resources(struct mlx5_vdpa_dev *mvdev)
+{
+	struct mlx5_vdpa_mr_resources *mres = &mvdev->mres;
+
+	mutex_destroy(&mres->lock);
+}
diff --git a/drivers/vdpa/mlx5/core/resources.c b/drivers/vdpa/mlx5/core/resources.c
index fe2ca3458f6c..aeae31d0cefa 100644
--- a/drivers/vdpa/mlx5/core/resources.c
+++ b/drivers/vdpa/mlx5/core/resources.c
@@ -256,7 +256,6 @@ int mlx5_vdpa_alloc_resources(struct mlx5_vdpa_dev *mvdev)
 		mlx5_vdpa_warn(mvdev, "resources already allocated\n");
 		return -EINVAL;
 	}
-	mutex_init(&mvdev->mres.lock);
 	res->uar = mlx5_get_uars_page(mdev);
 	if (IS_ERR(res->uar)) {
 		err = PTR_ERR(res->uar);
@@ -301,7 +300,6 @@ int mlx5_vdpa_alloc_resources(struct mlx5_vdpa_dev *mvdev)
 err_uctx:
 	mlx5_put_uars_page(mdev, res->uar);
 err_uars:
-	mutex_destroy(&mvdev->mres.lock);
 	return err;
 }
 
@@ -318,7 +316,6 @@ void mlx5_vdpa_free_resources(struct mlx5_vdpa_dev *mvdev)
 	dealloc_pd(mvdev, res->pdn, res->uid);
 	destroy_uctx(mvdev, res->uid);
 	mlx5_put_uars_page(mvdev->mdev, res->uar);
-	mutex_destroy(&mvdev->mres.lock);
 	res->valid = false;
 }
 
diff --git a/drivers/vdpa/mlx5/net/mlx5_vnet.c b/drivers/vdpa/mlx5/net/mlx5_vnet.c
index 8a51c492a62a..1cadcb05a5c7 100644
--- a/drivers/vdpa/mlx5/net/mlx5_vnet.c
+++ b/drivers/vdpa/mlx5/net/mlx5_vnet.c
@@ -3434,6 +3434,7 @@ static void mlx5_vdpa_free(struct vdpa_device *vdev)
 
 	free_fixed_resources(ndev);
 	mlx5_vdpa_clean_mrs(mvdev);
+	mlx5_vdpa_destroy_mr_resources(&ndev->mvdev);
 	if (!is_zero_ether_addr(ndev->config.mac)) {
 		pfmdev = pci_get_drvdata(pci_physfn(mvdev->mdev->pdev));
 		mlx5_mpfs_del_mac(pfmdev, ndev->config.mac);
@@ -3962,12 +3963,15 @@ static int mlx5_vdpa_dev_add(struct vdpa_mgmt_dev *v_mdev, const char *name,
 	if (err)
 		goto err_mpfs;
 
-	INIT_LIST_HEAD(&mvdev->mres.mr_list_head);
+	err = mlx5_vdpa_init_mr_resources(mvdev);
+	if (err)
+		goto err_res;
+
 
 	if (MLX5_CAP_GEN(mvdev->mdev, umem_uid_0)) {
 		err = mlx5_vdpa_create_dma_mr(mvdev);
 		if (err)
-			goto err_res;
+			goto err_mr_res;
 	}
 
 	err = alloc_fixed_resources(ndev);
@@ -4009,6 +4013,8 @@ static int mlx5_vdpa_dev_add(struct vdpa_mgmt_dev *v_mdev, const char *name,
 	free_fixed_resources(ndev);
 err_mr:
 	mlx5_vdpa_clean_mrs(mvdev);
+err_mr_res:
+	mlx5_vdpa_destroy_mr_resources(mvdev);
 err_res:
 	mlx5_vdpa_free_resources(&ndev->mvdev);
 err_mpfs:
-- 
2.45.1


