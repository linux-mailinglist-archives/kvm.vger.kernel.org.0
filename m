Return-Path: <kvm+bounces-24368-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id BBFD8954518
	for <lists+kvm@lfdr.de>; Fri, 16 Aug 2024 11:05:08 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 6944028549A
	for <lists+kvm@lfdr.de>; Fri, 16 Aug 2024 09:05:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4232014830C;
	Fri, 16 Aug 2024 09:03:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="Io5KtwpY"
X-Original-To: kvm@vger.kernel.org
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2072.outbound.protection.outlook.com [40.107.220.72])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A858014C59A;
	Fri, 16 Aug 2024 09:03:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.220.72
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723798983; cv=fail; b=gdOuubGt5itKggvgwGbokbv1VYDM8FCkYU/zhTq7K/STUbcBRAjfIONwifn8GgtSG4VU8chw3++4Ux0Tssp0iHVGcmrPQlcDYXg/+WbaHbugqXJQSKQeEZ5T/HorTWAs2wvm9na0ZNPE4PmLJgpGc0F6uTfFaRgMYq8u4Yv4NoI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723798983; c=relaxed/simple;
	bh=AaojRqciGzZpgysJ+0AjGAE5jNukjY3I6kZx9XT/QlA=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Hnj1ZSxZDXCFUm/8MhoROtVqlKJ7vxjCRFF0cjfh8oY9TVS0zgmSVmJjLAZujR4XcIO0J49MX/TS08fNvLxgAaaY24wx5tbB8oLKSs9x6c3i7AIWMKYJhcSgVKkbsU6BoVq7nz0JM5C7FbsOLs2vyropp9A1esAVVKdAWzkOtrk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=Io5KtwpY; arc=fail smtp.client-ip=40.107.220.72
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=CUp1R9RztHXIRxCmBdbnnstwWkDffQmD+9PX3WusZ0GBP8PDps9Yvnu+n2u2yeGzUW4sdD2dy70AHhDGP3TJ5f7zQBnnroQPaqiq8IagYSIy9TWcli5feJaQhYTKUqudXiFBiJkh+tpFmNL4phthG5EewefCDsLsuBUp/ZedQs6OhOj0xpgZvkUELvKoiwwd990rBzL5h/sqQUbi0/uHXmo9Od8xTLvYVX16S1m22/3+01bCkeZDXDe2evsPfsl4R83Bgizi9mVLs0u9/DT1o1DawIUxkBUe828euOUFceiJIq8Kt/F6EaN7FcxBT8U0AsmMEsvmsVw8C1P+sylmZw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=9/WRppdg9XWVo0cpx8Hq1bCb18U/qC407LW87OYi+Js=;
 b=hiPxwZSoeA2+pfMoJE+Ao4EB35fhOkCfX0PxdIBHdSB0AGWv+ZI4ldY3nZocFiqE6Ht7fLb7kbbjEjRLYDe1zTXFRjF0tLzr5BQlcjq3IFh4CJHc0FJzfSq9DhxbSh4p0bwzZFkSU+2El3VwPO404mh+WSCoaiH/fRLw36aY1wo9TTyyr6OsZ6Z2yKYF+8xy24raaW+esA+1Q32lSo560UfEFw4efBwqsF7swBNxMRPcH01ZEJm9Sz/wLkY2AMR9oS0v1WSb2O6bXLzjFT+fiXCh8r/9u9BvAsuW1HzbnSipX7DPvKm0qPDpYGmotTBT9gKXN0qjWeWQJcdLFtEI6g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=redhat.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9/WRppdg9XWVo0cpx8Hq1bCb18U/qC407LW87OYi+Js=;
 b=Io5KtwpYnqOpydlz40nwhNeVEqzmkO502P+0wVv3AtveyxoPBmyHyTSkGW6G8sZ18WQnuCVZfZfQ+ki1KMUpQ6YS0cUY0LOkEO/vq7BKW5eM+oU4oAv/y3vggd0RtOzDuakPRhp1efkokoaYVzG3RVK1uBpAO0dURguOWaf+oylZxHit+0fyCtCKZfBJoENt9FB1wR0sf/3SjI8P9E/fXUKilMejeC7T8Y1OZL+HhOODLTcR+xKwiyfC/2wLMlSEythLVh2zsbFXJEPXaH4ZkYknAQQlsBlQZYzHPV4Ze8SwTMqUTZu0Z/DSvgpEJVuO2OwZDvzLbnX102Th9nzHpg==
Received: from BN0PR04CA0110.namprd04.prod.outlook.com (2603:10b6:408:ec::25)
 by PH0PR12MB7983.namprd12.prod.outlook.com (2603:10b6:510:28e::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7875.19; Fri, 16 Aug
 2024 09:02:54 +0000
Received: from BN1PEPF0000468E.namprd05.prod.outlook.com
 (2603:10b6:408:ec:cafe::43) by BN0PR04CA0110.outlook.office365.com
 (2603:10b6:408:ec::25) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7849.23 via Frontend
 Transport; Fri, 16 Aug 2024 09:02:54 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.161)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 BN1PEPF0000468E.mail.protection.outlook.com (10.167.243.139) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.7849.8 via Frontend Transport; Fri, 16 Aug 2024 09:02:53 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4; Fri, 16 Aug
 2024 02:02:41 -0700
Received: from rnnvmail201.nvidia.com (10.129.68.8) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4; Fri, 16 Aug
 2024 02:02:41 -0700
Received: from c-237-113-220-225.mtl.labs.mlnx (10.127.8.12) by
 mail.nvidia.com (10.129.68.8) with Microsoft SMTP Server id 15.2.1544.4 via
 Frontend Transport; Fri, 16 Aug 2024 02:02:37 -0700
From: Dragos Tatulea <dtatulea@nvidia.com>
To: "Michael S . Tsirkin" <mst@redhat.com>, Jason Wang <jasowang@redhat.com>,
	Eugenio Perez Martin <eperezma@redhat.com>,
	<virtualization@lists.linux-foundation.org>
CC: Dragos Tatulea <dtatulea@nvidia.com>, Si-Wei Liu <si-wei.liu@oracle.com>,
	Saeed Mahameed <saeedm@nvidia.com>, Leon Romanovsky <leon@kernel.org>,
	<kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>, Gal Pressman
	<gal@nvidia.com>, Parav Pandit <parav@nvidia.com>, Xuan Zhuo
	<xuanzhuo@linux.alibaba.com>, Tariq Toukan <tariqt@nvidia.com>
Subject: [PATCH vhost v2 07/10] vdpa/mlx5: Parallelize device resume
Date: Fri, 16 Aug 2024 12:01:56 +0300
Message-ID: <20240816090159.1967650-8-dtatulea@nvidia.com>
X-Mailer: git-send-email 2.45.1
In-Reply-To: <20240816090159.1967650-1-dtatulea@nvidia.com>
References: <20240816090159.1967650-1-dtatulea@nvidia.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-NV-OnPremToCloud: ExternallySecured
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN1PEPF0000468E:EE_|PH0PR12MB7983:EE_
X-MS-Office365-Filtering-Correlation-Id: eb613aad-8205-4caa-f76c-08dcbdd236e1
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|376014|36860700013|82310400026;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?bVlNTFV5Zk8wOTJwRWJLN2hQaGNoM2ZQVGNJUm9FS0FSaVFaOE1jRmZFdUxs?=
 =?utf-8?B?dUhCLzdtc2Y1SGJ6bG0yZGNGanZqRlhmQ0tTaU14K0g5aGtYN2kzTTJpalRz?=
 =?utf-8?B?OGNLZzZ6dXRjVlowUjNNblhoVTZrelB4UGJycmxhaWRid2RjZ0FEMDRibU5o?=
 =?utf-8?B?RXF6NjFhMEZWcjhBY3crRHlXd21pOXhjVEdqQXlIdkhid3F6aktQVEZHZ2JO?=
 =?utf-8?B?bDBxZ2EvWmlndytPSUhFcDBoVTczY3NSTU1BTEQzZmowYkpwbWdyVEJVcklz?=
 =?utf-8?B?UWYzZDdhYWlpVmJvcXFtLy9iSEYzL3h5elcwc2M4RnBOaHNTSTdFVHk5eGRB?=
 =?utf-8?B?Y1laYk84N3REbmNJcnNPaHQvY0xhcFgzWTRmeWl0VDJwYWtPOGdFMkFDa0NX?=
 =?utf-8?B?aVBxQ1pGTFFBRzlwaWxjanpZdXBqQlFhNEFiOVlGTzdPckNjSzFkRW13RmlS?=
 =?utf-8?B?ZXNwdlRUcmFobHNzbzg3WStWMmwwRkVzWEVXZmZ2ckV1RWNQeENZZEs2YVpn?=
 =?utf-8?B?ODUyVVE5TVZtOCtINm11SVZhdjZmYUpCM09PWWlnajdVaDlENENreXB4UGtN?=
 =?utf-8?B?NDNmY3F6UDNkQmtwejQxUzNBMFJLcGdYUjh2SXQvd20xQjl2dDkvd21wTVZE?=
 =?utf-8?B?c1dnb3ozb0E0MU1BWWM4dG1WL1c4M0VtaFh1M3Y0OGlWeXc1VzhxeUlpdmwy?=
 =?utf-8?B?NEFKdjM1V3FUTGJyYXhScmF0R1ZhNFE0TXJGMFMzQVZoVGVBVE5RYlg5L3ZL?=
 =?utf-8?B?ZGZxV2V4Y2NHUUN6dVNxN05KWk5HZVN6QzZLUCs5L2FuRStEbWcweHBwQ2lT?=
 =?utf-8?B?WkJyQ2xLTlB6YmdLeGNIajdLcVhRSGkvVWtMQ3dpTWZhcVNsdEpyS1U0d1lK?=
 =?utf-8?B?b1d3Q2FYRmlnK29aNUhpek1BSDhjeUdkTkFIUmZzd3hKclZCZzlQaGR6T25l?=
 =?utf-8?B?dCtrS1FCRisvMGxEeUdnM1AwWnJZUWZHUStZVDdlYVliWUVkYzg3VjNKRFpm?=
 =?utf-8?B?cnY4Ukd0YUdzYkxhNDlXR3VMVit1OHlHV1J0VUpXTWxFbnlneE13NG5SclRC?=
 =?utf-8?B?VmxLNWtITnlWaXFFMGVpVXBZTllIWExxZlp3cGswOEdLWUVnNUNoaEcwNWtD?=
 =?utf-8?B?NHJVOU5TbEppL3FsVW5IaDJaNGVzdWhTeVBGVVJBNzhuQ2N3dWJFanYwL3Q5?=
 =?utf-8?B?SHV6THpUbHV5WTRhODB2TUljSzR0eFZEWDI1ellHTmFYVXFOR1VpNTlxMG5v?=
 =?utf-8?B?L2VPSVR4dEhiVWRZZjhocW8zUEJCKzQzTHJzVDVneS9Zc0pFeXVER3BhUWdl?=
 =?utf-8?B?TU1yRWEzbHJ3Yy9mazdBSGwxVWhuY2wvOG85S2ZxbXFVRTJoS1JNRDhSYXNF?=
 =?utf-8?B?M21YY1owVUw3SjRkcnF2S0pRZDdJZGpvb3dlWGJKci9SNGlZa0VpVFc1blJT?=
 =?utf-8?B?N3BLUS9wbm9LL0V5UmJNUk1zSkczNVFKMEYrZU15WnpPNVBSejAwdlFEUldk?=
 =?utf-8?B?cUdSUW1IZDVNODR6WitWeW4zVTJtQkdjVXdvYXErTmxSL2xDbXZMOFhrY0hj?=
 =?utf-8?B?eUtPMXdvbUdBSkNiVXlrYUIvbE44TUk4K1lINW15QWJ2WDBLSW5FT1FCSzVQ?=
 =?utf-8?B?ZWNYc2FnQXhJQ3I5UWF1T3RaOE5hTlQwRkExZFZUa2NvSU9JWnF4dDJycGhF?=
 =?utf-8?B?M2tIMkgxeFp1eWl1TEZ6aEorTXViS08zbDljQnVjZ1h3cGhqMzlOdWNCU0FF?=
 =?utf-8?B?azlheVlqTzNjUGVRUlZCa25kaEdqejdBQzcwS2ZDQWY0NWxLeC9Dem9YKzRB?=
 =?utf-8?B?eVlTMzVWQmRINjFvTXVOdnFEUnluUktWOU9rd0U5bW1TWTBYQlBETzc0cUJF?=
 =?utf-8?B?cGJIUU5zaTNzZUFLSVRNQU9XczhVUDB2QTR2L2hvWStMTWNLSHV0RDgrTjdN?=
 =?utf-8?Q?EeXI+GLhdIVdCVc+VdPg2qBviExwEXcW?=
X-Forefront-Antispam-Report:
	CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230040)(1800799024)(376014)(36860700013)(82310400026);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Aug 2024 09:02:53.8828
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: eb613aad-8205-4caa-f76c-08dcbdd236e1
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BN1PEPF0000468E.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR12MB7983

Currently device resume works on vqs serially. Building up on previous
changes that converted vq operations to the async api, this patch
parallelizes the device resume.

For 1 vDPA device x 32 VQs (16 VQPs) attached to a large VM (256 GB RAM,
32 CPUs x 2 threads per core), the device resume time is reduced from
~16 ms to ~4.5 ms.

Signed-off-by: Dragos Tatulea <dtatulea@nvidia.com>
Reviewed-by: Tariq Toukan <tariqt@nvidia.com>
Acked-by: Eugenio Pérez <eperezma@redhat.com>
---
 drivers/vdpa/mlx5/net/mlx5_vnet.c | 40 +++++++++++--------------------
 1 file changed, 14 insertions(+), 26 deletions(-)

diff --git a/drivers/vdpa/mlx5/net/mlx5_vnet.c b/drivers/vdpa/mlx5/net/mlx5_vnet.c
index 5fba16c80dbb..0773bec917be 100644
--- a/drivers/vdpa/mlx5/net/mlx5_vnet.c
+++ b/drivers/vdpa/mlx5/net/mlx5_vnet.c
@@ -1675,10 +1675,15 @@ static int suspend_vq(struct mlx5_vdpa_net *ndev, struct mlx5_vdpa_virtqueue *mv
 	return suspend_vqs(ndev, mvq->index, 1);
 }
 
-static int resume_vq(struct mlx5_vdpa_net *ndev, struct mlx5_vdpa_virtqueue *mvq)
+static int resume_vqs(struct mlx5_vdpa_net *ndev, int start_vq, int num_vqs)
 {
+	struct mlx5_vdpa_virtqueue *mvq;
 	int err;
 
+	if (start_vq >= ndev->mvdev.max_vqs)
+		return -EINVAL;
+
+	mvq = &ndev->vqs[start_vq];
 	if (!mvq->initialized)
 		return 0;
 
@@ -1690,13 +1695,9 @@ static int resume_vq(struct mlx5_vdpa_net *ndev, struct mlx5_vdpa_virtqueue *mvq
 		/* Due to a FW quirk we need to modify the VQ fields first then change state.
 		 * This should be fixed soon. After that, a single command can be used.
 		 */
-		err = modify_virtqueues(ndev, mvq->index, 1, mvq->fw_state);
-		if (err) {
-			mlx5_vdpa_err(&ndev->mvdev,
-				"modify vq properties failed for vq %u, err: %d\n",
-				mvq->index, err);
+		err = modify_virtqueues(ndev, start_vq, num_vqs, mvq->fw_state);
+		if (err)
 			return err;
-		}
 		break;
 	case MLX5_VIRTIO_NET_Q_OBJECT_STATE_SUSPEND:
 		if (!is_resumable(ndev)) {
@@ -1712,25 +1713,12 @@ static int resume_vq(struct mlx5_vdpa_net *ndev, struct mlx5_vdpa_virtqueue *mvq
 		return -EINVAL;
 	}
 
-	err = modify_virtqueues(ndev, mvq->index, 1, MLX5_VIRTIO_NET_Q_OBJECT_STATE_RDY);
-	if (err)
-		mlx5_vdpa_err(&ndev->mvdev, "modify to resume failed for vq %u, err: %d\n",
-			      mvq->index, err);
-
-	return err;
+	return modify_virtqueues(ndev, start_vq, num_vqs, MLX5_VIRTIO_NET_Q_OBJECT_STATE_RDY);
 }
 
-static int resume_vqs(struct mlx5_vdpa_net *ndev)
+static int resume_vq(struct mlx5_vdpa_net *ndev, struct mlx5_vdpa_virtqueue *mvq)
 {
-	int err = 0;
-
-	for (int i = 0; i < ndev->cur_num_vqs; i++) {
-		int local_err = resume_vq(ndev, &ndev->vqs[i]);
-
-		err = local_err ? local_err : err;
-	}
-
-	return err;
+	return resume_vqs(ndev, mvq->index, 1);
 }
 
 static void teardown_vq(struct mlx5_vdpa_net *ndev, struct mlx5_vdpa_virtqueue *mvq)
@@ -3080,7 +3068,7 @@ static int mlx5_vdpa_change_map(struct mlx5_vdpa_dev *mvdev,
 			return err;
 	}
 
-	resume_vqs(ndev);
+	resume_vqs(ndev, 0, ndev->cur_num_vqs);
 
 	return 0;
 }
@@ -3204,7 +3192,7 @@ static void mlx5_vdpa_set_status(struct vdpa_device *vdev, u8 status)
 				teardown_vq_resources(ndev);
 
 			if (ndev->setup) {
-				err = resume_vqs(ndev);
+				err = resume_vqs(ndev, 0, ndev->cur_num_vqs);
 				if (err) {
 					mlx5_vdpa_warn(mvdev, "failed to resume VQs\n");
 					goto err_driver;
@@ -3628,7 +3616,7 @@ static int mlx5_vdpa_resume(struct vdpa_device *vdev)
 
 	down_write(&ndev->reslock);
 	mvdev->suspended = false;
-	err = resume_vqs(ndev);
+	err = resume_vqs(ndev, 0, ndev->cur_num_vqs);
 	register_link_notifier(ndev);
 	up_write(&ndev->reslock);
 
-- 
2.45.1


