Return-Path: <kvm+bounces-24370-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 3DF3A95451E
	for <lists+kvm@lfdr.de>; Fri, 16 Aug 2024 11:05:41 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 61EE51C235CC
	for <lists+kvm@lfdr.de>; Fri, 16 Aug 2024 09:05:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B45A4140394;
	Fri, 16 Aug 2024 09:03:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="l2zvYyNM"
X-Original-To: kvm@vger.kernel.org
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2062.outbound.protection.outlook.com [40.107.244.62])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5AE4814E2CC;
	Fri, 16 Aug 2024 09:03:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.244.62
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723798987; cv=fail; b=nDif/AiolPcfJCM90CiAdh3hv+4owuqyaxvmnci5Zgn5mJCCFgmQaq7fRX1c3bvbxULiundJK7tAIzY/uOfliMwFbgJO3f+sa1vncXDEG7g66t3K+aUplK1Zs8xlpHqs5HPoXdRKO5aqN4s8mGh9pd1CpB2QQZ4jgFkhQIZPGHc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723798987; c=relaxed/simple;
	bh=tHVRznIQYDYzoAY9hjgpWyz0H1mNIttNlf8Odx9u9PI=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=frWbn3JqMUgJ/o8jsxDeCCeelb7a8aTPtFOK2I9v+wL2dB5gnwGQ72kEMIG+jwJL6zXCDXip11h5BYqnGuVeHItjEau7AvPE1dRwScweIBqmmq4akFuwGheJRXxYSl+Z0ulaE7/bl7OMTF5WVSQIDxH8+XOSZrnMsu6QMlGYi4w=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=l2zvYyNM; arc=fail smtp.client-ip=40.107.244.62
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=yqE6E+7BrwwTu2pi3kx8oulEZ6cW8uniBgNQDbfhv3ZZ5trzoXiHQoWvr8IxwSXBJjiAGIoLYjnuG8kOHJroghzcNYAs66uoYFPFxkwLCnItRyR1Ais5xjexITSMoD++2cOd0Am9IUVyrSI/4TzKiTlXWUs1LcxtzOP5yU5vGkZXb0zjighk04gTJXtYAvmfCra3DAZ2zMKfwXDyyZzbV6r9VKmOki1bkaroy+ALJkKopYq9wYM0X61lXX6ugzQQJwvOUT7THqhgSOpPaw0XedSd5h65cmqReXVfSqOpp/ylFhAFkMb13ixBaIvMSeHmuqD8ZTFurBGqPwbvAeaDRg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=VLhZSNSFuIMzzAIr7N7eaMqtvHZK/6Wnakhktq+y4MU=;
 b=ciAwwSgeiUJwl4fOAsIIVB5mq6A4ueszBBMrnV6ZDtUXkGxnGQstgUb58c9hT2XgP8oW0UccWCjVnN/M9Bg45ObgOtSrg53YMEK0Ht8KNtNRHn5A7GjkL/RfzaDevqEZFc8ciOudapnj/vR5VJ5VYZZaWv4HnOBFd9NIu+g+fFPFMnSox7j/5rIt7NDTXudPx8CeOkNnnX6fLs7i90g/BMeEIzTY2ViMCq8I70jZiEJDAJKzpJOKV7ZRUrqzRgsfZKIrhEfwORtCV763Ay0pFH779ANBgwRWo+HICnYgKR+Gh7YoZ6JTyEb4tXc8tIuVMjWL8Nt4S8C+pSe7uqIqvg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=redhat.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=VLhZSNSFuIMzzAIr7N7eaMqtvHZK/6Wnakhktq+y4MU=;
 b=l2zvYyNMe3zUSi4P9IJ6K+I6tKtVx6oECl/ViBYZvSi92isJh4UMjpM83BXZQwbXdUPgUxIpph1xG3f97eXyVj/li0i/+JqqbcPGjA+SB/hVF/I5R12F8q16Il5ak6AOfIeGgJMwnpYn7be3AELOpvDTi/QepsMhHtnpJ2Q4a2TxZNhJk0GwxyCqLtyvNL657S77dhjZZsCeYlrSxShIlQbVsndr33cSjebOooqxNUCqUmjHzCqvkcfSZO6UGvIkQoq7l+jfWIkI81rhUBEpNd2FhB2BhivYvrC5BLyPi0vDN6dDSuAVHHcH5G3V0F9hcSza1O+Pr9+49evN+c23xw==
Received: from BN0PR07CA0009.namprd07.prod.outlook.com (2603:10b6:408:141::8)
 by DS0PR12MB9399.namprd12.prod.outlook.com (2603:10b6:8:1b8::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7875.19; Fri, 16 Aug
 2024 09:03:03 +0000
Received: from BN1PEPF0000468B.namprd05.prod.outlook.com
 (2603:10b6:408:141:cafe::c7) by BN0PR07CA0009.outlook.office365.com
 (2603:10b6:408:141::8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7849.22 via Frontend
 Transport; Fri, 16 Aug 2024 09:03:03 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.161)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 BN1PEPF0000468B.mail.protection.outlook.com (10.167.243.136) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.7849.8 via Frontend Transport; Fri, 16 Aug 2024 09:03:03 +0000
Received: from rnnvmail203.nvidia.com (10.129.68.9) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4; Fri, 16 Aug
 2024 02:02:49 -0700
Received: from rnnvmail201.nvidia.com (10.129.68.8) by rnnvmail203.nvidia.com
 (10.129.68.9) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4; Fri, 16 Aug
 2024 02:02:49 -0700
Received: from c-237-113-220-225.mtl.labs.mlnx (10.127.8.12) by
 mail.nvidia.com (10.129.68.8) with Microsoft SMTP Server id 15.2.1544.4 via
 Frontend Transport; Fri, 16 Aug 2024 02:02:45 -0700
From: Dragos Tatulea <dtatulea@nvidia.com>
To: "Michael S . Tsirkin" <mst@redhat.com>, Jason Wang <jasowang@redhat.com>,
	Eugenio Perez Martin <eperezma@redhat.com>,
	<virtualization@lists.linux-foundation.org>
CC: Dragos Tatulea <dtatulea@nvidia.com>, Si-Wei Liu <si-wei.liu@oracle.com>,
	Saeed Mahameed <saeedm@nvidia.com>, Leon Romanovsky <leon@kernel.org>,
	<kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>, Gal Pressman
	<gal@nvidia.com>, Parav Pandit <parav@nvidia.com>, Xuan Zhuo
	<xuanzhuo@linux.alibaba.com>, Tariq Toukan <tariqt@nvidia.com>
Subject: [PATCH vhost v2 09/10] vdpa/mlx5: Small improvement for change_num_qps()
Date: Fri, 16 Aug 2024 12:01:58 +0300
Message-ID: <20240816090159.1967650-10-dtatulea@nvidia.com>
X-Mailer: git-send-email 2.45.1
In-Reply-To: <20240816090159.1967650-1-dtatulea@nvidia.com>
References: <20240816090159.1967650-1-dtatulea@nvidia.com>
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
X-MS-TrafficTypeDiagnostic: BN1PEPF0000468B:EE_|DS0PR12MB9399:EE_
X-MS-Office365-Filtering-Correlation-Id: 370a02ea-1f97-490c-35f8-08dcbdd23c73
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|82310400026|376014|36860700013;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?Pa2xMqRrOfk60Hs9kdTChInLvjrHHm0ctg0mH8kZrYGSufJE9fJYzkpZx11P?=
 =?us-ascii?Q?IrObUkAHERqduXiQ2GK8wk1l+cjN6/X8jgpANSSdCrV7lYuJWAGBI+WrUIBU?=
 =?us-ascii?Q?P4mkSa4MTfsq2XqzeWcVNa/NwQURZ29UtVeWlvVnnog7AwTf2Y9k8BmunJzT?=
 =?us-ascii?Q?19MZKFghCOQJ0uVvDSDMMXdxZK5WAv7tnwZJRdk6ERKwtqoUkSvcxKx5vuMY?=
 =?us-ascii?Q?Os1ppSwZx7awuUWz7LcdKPNiwe4zq4OpLqVTqyTCDxWm8j/an6ohhjKToYIx?=
 =?us-ascii?Q?ao7cUGMHL1AvpwHRgxX6Ks95NaoLUm2yEeq/Di05FdMgzdwypL+df9YsvtB3?=
 =?us-ascii?Q?KzYGLWlNCB/xMp53rwA6b2v6l2YmMfkKxwi6ENKMJSFD7ZLpl0axHu8S7hCU?=
 =?us-ascii?Q?bvEQcZzszDps9UniJlcpHgPe7kPZg0QZt/CfSEpjD8yJsjvHtgERGTnKy5i9?=
 =?us-ascii?Q?ZUEnErOimQ9aavIvLVTG1SNAUO+yKIbQJnOiZDPtXCZfVm0stef1MGfe8UYO?=
 =?us-ascii?Q?qnRXqRc6ekJH5gdvPfo0f5dQLZnc6ZkY0VeDo8hrmTFmUweW3yAVacPXOzZl?=
 =?us-ascii?Q?FuQOg5KGaT49037DVpgnEHwIEwEKK/G5AGZW7cWRdMm61YQscV/iB/ck0Pl1?=
 =?us-ascii?Q?59PROtHIvkgANqbYM4FVDqSXO6mYRdTcUjsfNvSFADQzZX87k6y4oS4Ac+rB?=
 =?us-ascii?Q?hTpavRBPFH5Vuzouyey3kpooyJTM5/g5YnepN2upb5+HR6jRzePOvx+oD2aU?=
 =?us-ascii?Q?weGi5XCegOkngbi6TcEhr8s5DIQjdfkl+QvPeoEiXBy7HVDL06V36LL86h6T?=
 =?us-ascii?Q?JDZm0As+z/z4PdgrcVZMyEcA7IcHlyxX5LBhLAzjaYvoLzNUrbnvLOYi8huD?=
 =?us-ascii?Q?KvblzVoWJaHWINsi2oWWe52WSLT+N+adnyvUb8SrFoxRRXgNh8DUUQA/etTP?=
 =?us-ascii?Q?mKKTlGuOWmUGfMvbdACYmdAtTmMOl4sMZRoB7UASDmCa6IN7VDdFTg0E6hAj?=
 =?us-ascii?Q?i/HeolZ4BhrWOwVvQxmH55WthXlfBzl9ydVVSOMVC2bBH12b/MWqx8sciy78?=
 =?us-ascii?Q?bg/FBCULVqKiowr6v61iv0odhnjDx+WeKpSXHVXJyWd8YP1OVSrj6Zq4S1fC?=
 =?us-ascii?Q?2PmR4C8jZagcDlTeOjyE35PuxqNZY6iRAW6vijG2IMJW7Q0yVldZ8/Ygpmp9?=
 =?us-ascii?Q?443JiDMe6R8y+uYTSSwMIPEdVWjWuJj7IxpVVMu1T+Zx7HE5jWsdqnwngT/R?=
 =?us-ascii?Q?OiSjEI68dnZY4elqO6Alvh2Vwt7KHaeDSh+9D8FfzkthUGaOXxUeHZH0GJw+?=
 =?us-ascii?Q?Dm9vn8yz+KWWjlY9oPVSoUjEN2PlaQ2wX03hXmyjY4u2mF6JjYXz3cherIGj?=
 =?us-ascii?Q?zJ/tzw47sE0TUZOt3A5CF1bz0ZGmie+mvGXp/iN9W7AsTWaFCaYhqbWIiRMd?=
 =?us-ascii?Q?zeOAED7dI+xgvCby6QO/RUnniTzCevE3?=
X-Forefront-Antispam-Report:
	CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230040)(1800799024)(82310400026)(376014)(36860700013);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Aug 2024 09:03:03.2233
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 370a02ea-1f97-490c-35f8-08dcbdd23c73
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BN1PEPF0000468B.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR12MB9399

change_num_qps() has a lot of multiplications by 2 to convert
the number of VQ pairs to number of VQs. This patch simplifies
the code by doing the VQP -> VQ count conversion at the beginning
in a variable.

Signed-off-by: Dragos Tatulea <dtatulea@nvidia.com>
Reviewed-by: Tariq Toukan <tariqt@nvidia.com>
---
 drivers/vdpa/mlx5/net/mlx5_vnet.c | 21 +++++++++++----------
 1 file changed, 11 insertions(+), 10 deletions(-)

diff --git a/drivers/vdpa/mlx5/net/mlx5_vnet.c b/drivers/vdpa/mlx5/net/mlx5_vnet.c
index 65063c507130..d1a01c229110 100644
--- a/drivers/vdpa/mlx5/net/mlx5_vnet.c
+++ b/drivers/vdpa/mlx5/net/mlx5_vnet.c
@@ -2219,16 +2219,17 @@ static virtio_net_ctrl_ack handle_ctrl_mac(struct mlx5_vdpa_dev *mvdev, u8 cmd)
 static int change_num_qps(struct mlx5_vdpa_dev *mvdev, int newqps)
 {
 	struct mlx5_vdpa_net *ndev = to_mlx5_vdpa_ndev(mvdev);
-	int cur_qps = ndev->cur_num_vqs / 2;
+	int cur_vqs = ndev->cur_num_vqs;
+	int new_vqs = newqps * 2;
 	int err;
 	int i;
 
-	if (cur_qps > newqps) {
-		err = modify_rqt(ndev, 2 * newqps);
+	if (cur_vqs > new_vqs) {
+		err = modify_rqt(ndev, new_vqs);
 		if (err)
 			return err;
 
-		for (i = ndev->cur_num_vqs - 1; i >= 2 * newqps; i--) {
+		for (i = cur_vqs - 1; i >= new_vqs; i--) {
 			struct mlx5_vdpa_virtqueue *mvq = &ndev->vqs[i];
 
 			if (is_resumable(ndev))
@@ -2237,27 +2238,27 @@ static int change_num_qps(struct mlx5_vdpa_dev *mvdev, int newqps)
 				teardown_vq(ndev, mvq);
 		}
 
-		ndev->cur_num_vqs = 2 * newqps;
+		ndev->cur_num_vqs = new_vqs;
 	} else {
-		ndev->cur_num_vqs = 2 * newqps;
-		for (i = cur_qps * 2; i < 2 * newqps; i++) {
+		ndev->cur_num_vqs = new_vqs;
+		for (i = cur_vqs; i < new_vqs; i++) {
 			struct mlx5_vdpa_virtqueue *mvq = &ndev->vqs[i];
 
 			err = mvq->initialized ? resume_vq(ndev, mvq) : setup_vq(ndev, mvq, true);
 			if (err)
 				goto clean_added;
 		}
-		err = modify_rqt(ndev, 2 * newqps);
+		err = modify_rqt(ndev, new_vqs);
 		if (err)
 			goto clean_added;
 	}
 	return 0;
 
 clean_added:
-	for (--i; i >= 2 * cur_qps; --i)
+	for (--i; i >= cur_vqs; --i)
 		teardown_vq(ndev, &ndev->vqs[i]);
 
-	ndev->cur_num_vqs = 2 * cur_qps;
+	ndev->cur_num_vqs = cur_vqs;
 
 	return err;
 }
-- 
2.45.1


