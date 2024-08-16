Return-Path: <kvm+bounces-24362-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 34A92954502
	for <lists+kvm@lfdr.de>; Fri, 16 Aug 2024 11:02:59 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 59EA61C22FD2
	for <lists+kvm@lfdr.de>; Fri, 16 Aug 2024 09:02:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 47DC213E039;
	Fri, 16 Aug 2024 09:02:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="K4L9Fpu8"
X-Original-To: kvm@vger.kernel.org
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2052.outbound.protection.outlook.com [40.107.93.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BA98613DBBE;
	Fri, 16 Aug 2024 09:02:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.93.52
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723798956; cv=fail; b=CF1FD8BosYFSuNHCNnK/R0GhoMwcW6+1U66VlTdhoSAauUNgHvlfBbtAv84/GCAdI57ak9pE20Z/nWRxCJAvjp6AvN8tCkjOWtC8Sj7dRB9QCCbJCk82yk6nGHemJBQnarXHAzzvAvJjEoxdzDW/vle9ndtAIIiWESSFZWjw83M=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723798956; c=relaxed/simple;
	bh=vBCbdqBQLdsHOKBWDeoIfTmPyba4qU8tIfeM70JLJTo=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Lr+L4Ids2JUaGsZgxG+o8VlQ8ByJgWlF1q1gupmIWOc4vaaiU5c4aXqIUBxqxR2l4iA7IGjQ6tAmFeAGT6rQ6/K43OzRhDWRZj/Q4shR3vVwGYGFX8utY7lvXwWQ2TLcXW9oz0xnQFDlbscUo91/3mrfaD9RdPmXpVWYior+fH4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=K4L9Fpu8; arc=fail smtp.client-ip=40.107.93.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=PovGSLZ71UwV49tWyk0ChCXAoPXbmx9q0OU8dBhchTIOf1q8zcPFsJC181jz+s6TPSRp4kjqU2nEV0jM1hIhDluQYwjQhY5E6kP7jWsyj5sI0xrb4Zv73krlbLE/Gi+EoXnoTr5mLrlCNFFM+lzUy1lT7jMBzho+q4el4iEHpKWPzRSlS82qXphhfpnI8W+FzfABLleBUHm0qmZiZZK4T6EVvZjbWNwMpE4Yob8+7S4TUH0UtSMWicvNctbYIY1XOsTOFFWMNCa6aafb4Y99po7Bd/7AboCnCWuTi+mH1RO3n4zNy9sCWJoK1ZUUfhGWceM/0E0nKtr5NM5liSd+/A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=zRoRYGLiazx0feu6Fm11gTsP+sJWPCsWcl8GKQJ5n28=;
 b=P/87rpabrQHXCBdeFPEwNMp4bBMNsrdnl3fBtORY8PoA53o0fchaVk1lHcJ7zdUK6wbdXYZvlMwPVsyJIIuldU5DKnfliR62v0k7z4U4P9g6UoAcX0BTT+uFwDfdm7z/msciU0kp9Fecrkav0i+Yrbb8KL3fMW1gyiWwJ8t/8xqW8poisGadb7fbhRcqg8vbhI25i01ifrPpYml0Ll/om+V/WxwpRNM13XRHSaU+yDZ5zEloe5r6DuUjufIOE3jdT8oKoHXq8PkDpsegqok5ppkQ8MldtiFWIUXdq4ghW4AylaLobFNUZcoXPzbX+tW9QrQ5wTIt11+DQquokukoFQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=redhat.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zRoRYGLiazx0feu6Fm11gTsP+sJWPCsWcl8GKQJ5n28=;
 b=K4L9Fpu84PkiO0bMXK/WRsxta5qHpzfMT6ObAWv74fRBqM+LzTyISCpXqWvLYoqLOZXhxokRda/YlRNyZ+1pPucZNmdnbkEFTSnji1dSOF/f8+6QoZTaJ5SmJ3WoEPHOV5mkA4g+lwv8cHyepyiqrwp+4jOxn+t6QnRpbcK8Fx2XQ0QN/343YU38alCf54mlyCivHFUJRHpAwf+lW2XU8UIAcQz5l+0uEvWbWe9mZRD1aSK15pE1JaFDWGJEIhvhSTu0avCJZbVW6XYGQIc5awr/jl7G1GcixnQ4sjh7ylGxOxx0Yxde5doLmL5bw7aTzPbuT5AG1x/sxBcOpwwNcw==
Received: from DS7PR03CA0119.namprd03.prod.outlook.com (2603:10b6:5:3b7::34)
 by MW4PR12MB7143.namprd12.prod.outlook.com (2603:10b6:303:222::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7875.19; Fri, 16 Aug
 2024 09:02:31 +0000
Received: from DS3PEPF000099DF.namprd04.prod.outlook.com
 (2603:10b6:5:3b7:cafe::84) by DS7PR03CA0119.outlook.office365.com
 (2603:10b6:5:3b7::34) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7828.33 via Frontend
 Transport; Fri, 16 Aug 2024 09:02:31 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.160)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 DS3PEPF000099DF.mail.protection.outlook.com (10.167.17.202) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.7849.8 via Frontend Transport; Fri, 16 Aug 2024 09:02:31 +0000
Received: from rnnvmail202.nvidia.com (10.129.68.7) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4; Fri, 16 Aug
 2024 02:02:20 -0700
Received: from rnnvmail201.nvidia.com (10.129.68.8) by rnnvmail202.nvidia.com
 (10.129.68.7) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4; Fri, 16 Aug
 2024 02:02:20 -0700
Received: from c-237-113-220-225.mtl.labs.mlnx (10.127.8.12) by
 mail.nvidia.com (10.129.68.8) with Microsoft SMTP Server id 15.2.1544.4 via
 Frontend Transport; Fri, 16 Aug 2024 02:02:16 -0700
From: Dragos Tatulea <dtatulea@nvidia.com>
To: "Michael S . Tsirkin" <mst@redhat.com>, Jason Wang <jasowang@redhat.com>,
	Eugenio Perez Martin <eperezma@redhat.com>,
	<virtualization@lists.linux-foundation.org>
CC: Dragos Tatulea <dtatulea@nvidia.com>, Si-Wei Liu <si-wei.liu@oracle.com>,
	Saeed Mahameed <saeedm@nvidia.com>, Leon Romanovsky <leon@kernel.org>,
	<kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>, Gal Pressman
	<gal@nvidia.com>, Parav Pandit <parav@nvidia.com>, Xuan Zhuo
	<xuanzhuo@linux.alibaba.com>, Tariq Toukan <tariqt@nvidia.com>
Subject: [PATCH vhost v2 02/10] vdpa/mlx5: Introduce error logging function
Date: Fri, 16 Aug 2024 12:01:51 +0300
Message-ID: <20240816090159.1967650-3-dtatulea@nvidia.com>
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
X-MS-TrafficTypeDiagnostic: DS3PEPF000099DF:EE_|MW4PR12MB7143:EE_
X-MS-Office365-Filtering-Correlation-Id: cd25e243-2fb7-443a-1583-08dcbdd2293a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|376014|36860700013|82310400026;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?dW5LRXRDUktvdTVaREoxLytja3E5NGtDZC90VG14WnBXZitZOGZxODBlZ1lz?=
 =?utf-8?B?WVVKWWo4RlJPOHlYV2FuRndsYXgwWFFVSU1zUE90KzlqdDlaNHFyYlVybThj?=
 =?utf-8?B?K2VFTU45L0lNMTlPZTVSV1BaTTRWQXlURlVVNU9tNDUvVjYwV0xyREZCZXJK?=
 =?utf-8?B?SjMrMjVreE04bncraE5na1pYUlBBK1BhMnB1VW05RHBlMjk0OEl6RlRpbCtD?=
 =?utf-8?B?eHBZa0g1NzA5VEUrcHVkcFVES0pUaVNlM0R2OFBaZkVIMnBnZm9OSExKNzhQ?=
 =?utf-8?B?Y0I0dUZrQjVzdDFUK2RvOFU1c3lRd0NPYWFlMVRLNnJ1OGt3MEFGd1NrWkdJ?=
 =?utf-8?B?VUhoQ0UzakRCZEJCbmhLcDdsR0hCSnNMNzk4a0ErK1l1cHBmY1pPTitDMUxi?=
 =?utf-8?B?Mm80amxabmxoSE1kRjNTSkpjTUpqVkE5aWpQcXF2MkZkRzhOd0JWaEhueE9l?=
 =?utf-8?B?eW0zQng2c0x3Rjh4a1M4MUJUNVJPbFdMTjFTVC9xUTlsQ3dhSXZNa1Q4Wm14?=
 =?utf-8?B?RjQvN0JLTkNuVU1ibGZvTWUwd01LRGkxbjNWclN0MkN6S21XbVplRmxNelhE?=
 =?utf-8?B?RkdLbU03Q1JUT0tvTWszVEU2M1RLeFlvOHRacVdGRk9YWUR5Si9ERnlVWHEv?=
 =?utf-8?B?bXZzQlQ1ZEpDRk9oWGsybW51blBHa0FzaGxlOHYzMk9OWHNyMnRlSDRnaFE4?=
 =?utf-8?B?cGVhZEpCcHFXQjE1QkhCY1kzQnRqUFBXc2toNmVOTG1QR0RxUjNmd0wxQmJT?=
 =?utf-8?B?b1A5eVo2a2VGODBXTTh1K0FFa0xRSDRrc2Z2ZTJqckhUYkc0N3JWZ1ppT04r?=
 =?utf-8?B?QloyNk5CWEdBNEk5Q081VnJBRlgyZWc0enFsaDlLWWJ2b09PU0JtR2l6Wm9H?=
 =?utf-8?B?M1VqZVVDWkM2M0lvdGFJSlh5Nkp3RnNmRU9NR2ZlTG9mV2dZdFhtWjMwT2gr?=
 =?utf-8?B?cXhaZk0rY1RFVFRsRWhGa1V3RXprRC9wS0poVCt1QUsvb24vTVhGVXl3VXNH?=
 =?utf-8?B?RXZMdzRzYktCY1FLdDlQanVXd0tlck0vQTAyWWlucHJxVmcrcXVuaE54cnk1?=
 =?utf-8?B?dE9oeFFnSlV2OXR6dHdna0pZMFlpWVJSUmU3MHNXcW1NSUFDSmxMSWFTNy9w?=
 =?utf-8?B?eStsWVlieXkzZERFV0M0dThKd0VTUEQ4NGx2M3RaWHF2anR2c1JZRzMzaW82?=
 =?utf-8?B?d3VnbzN5Qys5d3FQVEJBbXgxNyswL08ybWFhZzFNRnBCcGkwV2daVlhlY1Rj?=
 =?utf-8?B?V1J0b28yRnNERHJVc0RQTUFHSEx6NTBBSGppVFJjYXFFQXc4clZTRXpOYnhp?=
 =?utf-8?B?cnVFK05YRGRnMG12YksyUzQxRUIrWjkvaDRYOGZGaTA5Tlo5bTBHenB1NStO?=
 =?utf-8?B?WEVaRytDaDdKL0dGNGZGN2ovQzFPZmdJYXBlRWhxNkNVYmNBMDNCa3pIczF1?=
 =?utf-8?B?di9mZHlsZDRtcWRMSmF4OUZ1QnRnNDI2am1XUkc0aWJJNm4rQjlIQk9LS2FK?=
 =?utf-8?B?QjlsUGR1WStpRU5oRks1aVVqWTVqYTFsRW9iWE84UUVxWlNvWHpQdnpYL3pt?=
 =?utf-8?B?YUNKN1hnWFhYdW15V05URE1kcDl5VW52MFlISzNaK2pGQ1pLNVgrbTV1UDhj?=
 =?utf-8?B?ZWdCc01XVHhRQ1JldnJHUXllRzliUjFrb2RTWEtNbWNwR0lwOVlKOHFMZFVL?=
 =?utf-8?B?ZnVXRnJHaTVwSXB4UDJTZVJWYmsxL2pKM2F6b2NrNm1xaEc2RDBWOFAveU93?=
 =?utf-8?B?VVloRE53eWRYSHZjQXR6TnczQ0JIWUlHSXN6MmhQbmxVKy8vRkcrSjBnOVcz?=
 =?utf-8?B?Z1hKZGwrZEUwc0pMd0R5ekZ3dGNsMnNGbW1hcitOKy8yTUF2LzF2cGJ4MUVx?=
 =?utf-8?B?ZmZVQ3lGWm8wY2EraHBMTVlKalNxcUhFelJMaWRvRFpyZHNZNTNnaUd6S01K?=
 =?utf-8?Q?OsNtm+1wgtlHcV1cEJSZmaKbctLy58pS?=
X-Forefront-Antispam-Report:
	CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230040)(1800799024)(376014)(36860700013)(82310400026);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Aug 2024 09:02:31.1128
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: cd25e243-2fb7-443a-1583-08dcbdd2293a
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DS3PEPF000099DF.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR12MB7143

mlx5_vdpa_err() was missing. This patch adds it and uses it in the
necessary places.

Signed-off-by: Dragos Tatulea <dtatulea@nvidia.com>
Reviewed-by: Tariq Toukan <tariqt@nvidia.com>
Acked-by: Eugenio Pérez <eperezma@redhat.com>
---
 drivers/vdpa/mlx5/core/mlx5_vdpa.h |  5 +++++
 drivers/vdpa/mlx5/net/mlx5_vnet.c  | 24 ++++++++++++------------
 2 files changed, 17 insertions(+), 12 deletions(-)

diff --git a/drivers/vdpa/mlx5/core/mlx5_vdpa.h b/drivers/vdpa/mlx5/core/mlx5_vdpa.h
index 50aac8fe57ef..424d445ebee4 100644
--- a/drivers/vdpa/mlx5/core/mlx5_vdpa.h
+++ b/drivers/vdpa/mlx5/core/mlx5_vdpa.h
@@ -135,6 +135,11 @@ int mlx5_vdpa_update_cvq_iotlb(struct mlx5_vdpa_dev *mvdev,
 int mlx5_vdpa_create_dma_mr(struct mlx5_vdpa_dev *mvdev);
 int mlx5_vdpa_reset_mr(struct mlx5_vdpa_dev *mvdev, unsigned int asid);
 
+#define mlx5_vdpa_err(__dev, format, ...)                                                          \
+	dev_err((__dev)->mdev->device, "%s:%d:(pid %d) error: " format, __func__, __LINE__,        \
+		 current->pid, ##__VA_ARGS__)
+
+
 #define mlx5_vdpa_warn(__dev, format, ...)                                                         \
 	dev_warn((__dev)->mdev->device, "%s:%d:(pid %d) warning: " format, __func__, __LINE__,     \
 		 current->pid, ##__VA_ARGS__)
diff --git a/drivers/vdpa/mlx5/net/mlx5_vnet.c b/drivers/vdpa/mlx5/net/mlx5_vnet.c
index fa78e8288ebb..12133e5d1285 100644
--- a/drivers/vdpa/mlx5/net/mlx5_vnet.c
+++ b/drivers/vdpa/mlx5/net/mlx5_vnet.c
@@ -1538,13 +1538,13 @@ static int suspend_vq(struct mlx5_vdpa_net *ndev, struct mlx5_vdpa_virtqueue *mv
 
 	err = modify_virtqueue_state(ndev, mvq, MLX5_VIRTIO_NET_Q_OBJECT_STATE_SUSPEND);
 	if (err) {
-		mlx5_vdpa_warn(&ndev->mvdev, "modify to suspend failed, err: %d\n", err);
+		mlx5_vdpa_err(&ndev->mvdev, "modify to suspend failed, err: %d\n", err);
 		return err;
 	}
 
 	err = query_virtqueue(ndev, mvq, &attr);
 	if (err) {
-		mlx5_vdpa_warn(&ndev->mvdev, "failed to query virtqueue, err: %d\n", err);
+		mlx5_vdpa_err(&ndev->mvdev, "failed to query virtqueue, err: %d\n", err);
 		return err;
 	}
 
@@ -1585,7 +1585,7 @@ static int resume_vq(struct mlx5_vdpa_net *ndev, struct mlx5_vdpa_virtqueue *mvq
 		 */
 		err = modify_virtqueue(ndev, mvq, 0);
 		if (err) {
-			mlx5_vdpa_warn(&ndev->mvdev,
+			mlx5_vdpa_err(&ndev->mvdev,
 				"modify vq properties failed for vq %u, err: %d\n",
 				mvq->index, err);
 			return err;
@@ -1600,15 +1600,15 @@ static int resume_vq(struct mlx5_vdpa_net *ndev, struct mlx5_vdpa_virtqueue *mvq
 	case MLX5_VIRTIO_NET_Q_OBJECT_STATE_RDY:
 		return 0;
 	default:
-		mlx5_vdpa_warn(&ndev->mvdev, "resume vq %u called from bad state %d\n",
+		mlx5_vdpa_err(&ndev->mvdev, "resume vq %u called from bad state %d\n",
 			       mvq->index, mvq->fw_state);
 		return -EINVAL;
 	}
 
 	err = modify_virtqueue_state(ndev, mvq, MLX5_VIRTIO_NET_Q_OBJECT_STATE_RDY);
 	if (err)
-		mlx5_vdpa_warn(&ndev->mvdev, "modify to resume failed for vq %u, err: %d\n",
-			       mvq->index, err);
+		mlx5_vdpa_err(&ndev->mvdev, "modify to resume failed for vq %u, err: %d\n",
+			      mvq->index, err);
 
 	return err;
 }
@@ -2002,13 +2002,13 @@ static int setup_steering(struct mlx5_vdpa_net *ndev)
 
 	ns = mlx5_get_flow_namespace(ndev->mvdev.mdev, MLX5_FLOW_NAMESPACE_BYPASS);
 	if (!ns) {
-		mlx5_vdpa_warn(&ndev->mvdev, "failed to get flow namespace\n");
+		mlx5_vdpa_err(&ndev->mvdev, "failed to get flow namespace\n");
 		return -EOPNOTSUPP;
 	}
 
 	ndev->rxft = mlx5_create_auto_grouped_flow_table(ns, &ft_attr);
 	if (IS_ERR(ndev->rxft)) {
-		mlx5_vdpa_warn(&ndev->mvdev, "failed to create flow table\n");
+		mlx5_vdpa_err(&ndev->mvdev, "failed to create flow table\n");
 		return PTR_ERR(ndev->rxft);
 	}
 	mlx5_vdpa_add_rx_flow_table(ndev);
@@ -2530,7 +2530,7 @@ static int mlx5_vdpa_get_vq_state(struct vdpa_device *vdev, u16 idx, struct vdpa
 
 	err = query_virtqueue(ndev, mvq, &attr);
 	if (err) {
-		mlx5_vdpa_warn(mvdev, "failed to query virtqueue\n");
+		mlx5_vdpa_err(mvdev, "failed to query virtqueue\n");
 		return err;
 	}
 	state->split.avail_index = attr.used_index;
@@ -3189,7 +3189,7 @@ static int mlx5_vdpa_compat_reset(struct vdpa_device *vdev, u32 flags)
 	if ((flags & VDPA_RESET_F_CLEAN_MAP) &&
 	    MLX5_CAP_GEN(mvdev->mdev, umem_uid_0)) {
 		if (mlx5_vdpa_create_dma_mr(mvdev))
-			mlx5_vdpa_warn(mvdev, "create MR failed\n");
+			mlx5_vdpa_err(mvdev, "create MR failed\n");
 	}
 	if (vq_reset)
 		setup_vq_resources(ndev, false);
@@ -3244,7 +3244,7 @@ static int set_map_data(struct mlx5_vdpa_dev *mvdev, struct vhost_iotlb *iotlb,
 		new_mr = mlx5_vdpa_create_mr(mvdev, iotlb);
 		if (IS_ERR(new_mr)) {
 			err = PTR_ERR(new_mr);
-			mlx5_vdpa_warn(mvdev, "create map failed(%d)\n", err);
+			mlx5_vdpa_err(mvdev, "create map failed(%d)\n", err);
 			return err;
 		}
 	} else {
@@ -3257,7 +3257,7 @@ static int set_map_data(struct mlx5_vdpa_dev *mvdev, struct vhost_iotlb *iotlb,
 	} else {
 		err = mlx5_vdpa_change_map(mvdev, new_mr, asid);
 		if (err) {
-			mlx5_vdpa_warn(mvdev, "change map failed(%d)\n", err);
+			mlx5_vdpa_err(mvdev, "change map failed(%d)\n", err);
 			goto out_err;
 		}
 	}
-- 
2.45.1


