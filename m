Return-Path: <kvm+bounces-3093-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 54E478008F5
	for <lists+kvm@lfdr.de>; Fri,  1 Dec 2023 11:50:04 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 77CEC1C20F01
	for <lists+kvm@lfdr.de>; Fri,  1 Dec 2023 10:50:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2017C210E9;
	Fri,  1 Dec 2023 10:49:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="Qjwzzcxd"
X-Original-To: kvm@vger.kernel.org
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2053.outbound.protection.outlook.com [40.107.94.53])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C4E7B10F1;
	Fri,  1 Dec 2023 02:49:45 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=M1cjpykQXSsdTKf/PZUA6ZuRNGqVOyN6XIsXc8SRktZPPf3y4NpO6EK6LvDLWH5lqTqwJKmhjTmzORP0YKk5WQHy9byeaAeUMC5hNaPQrabEZzhk9PsrcR/sY3l+VZUGLnTXhy9q75bBG5V3DiUzxUg+ArZApTJfkJlbnYErIQ2sFPO1/3CwutmGafZIIWRSsOPQXZzOc1KzUf/TtxmAYy6l6Hd9gzalSsgWDiPRqfCcfM2x91GD71ncZD99WgRAAiZu5to0yaKQku5VkuKP2kW5A1u4vclLlfZvWt7kF0h4Eas5gwbuSSCVTeOQk2PyZeSpI+Qg49IfO2f4lgx5xg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=b6hDxocxpj5OzTimObjmwJdf213sHeAV07ZmX51gJo0=;
 b=Pp28i5A3wWb+90VhQZV4AWWVwtTJ9iyW0ESY4aF3b8FG9TPlHwZhs9Y1SIfc1t3o23yyxIkbHhMxhxNc7XT2bxmUsdtv/w7AvlyrPCQIv6OWkAqN8LYC2PJC3+tq9etBRg25u6QGpHJQZGgZ5/oh+18tUtfxXHtQ0a4MUM4K322e9VwQGw7b/BktjvzaMJNbilC06Q1oe5QrV3GC92vg6cSDdGZGkcoQewE3RpZmLforQhKkYylPf2EspWoHCUPOz0k5a5ycG/iuMTqFvXDXwyIKn3U4rGZw4Xv7ETrhJnbtV9jXf6z4UrwHX0pzqWgJEBDYSjmWv/kK4VkpQJTz3g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=redhat.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=b6hDxocxpj5OzTimObjmwJdf213sHeAV07ZmX51gJo0=;
 b=QjwzzcxdEbxoDa1DWwjep5QTohhbK3bS0rPeWcKa1HABcGIytiK/C+CjJ9Hf4vxlxAhVaiz5lM6aDQH/kT1dxDaxj+Uv31HliDjahUKEKPGwhA1/eqipqqMA68Llys3Ple9fxeb31ng5O/NqRh38pjsqZcZ+qNWB2NcNxU8VCC8PM46RVurS92L7AqrOSktnD/5fYSztdOPqbuH51k5yUeSdyyGdqCSyJNJ/v8LmEZ394XpFb0lsiBKgKzEkrzed7+wRqyC+JQkOvaxbJ3zXSs1BOnndwjgftIpSXdkaZrwrvNCOG1DSmyLRPl+mQ7xZsU1XhnO+j1WI15DuDGMyKQ==
Received: from BL0PR02CA0079.namprd02.prod.outlook.com (2603:10b6:208:51::20)
 by PH0PR12MB8052.namprd12.prod.outlook.com (2603:10b6:510:28b::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7046.24; Fri, 1 Dec
 2023 10:49:43 +0000
Received: from BL02EPF0001A0FA.namprd03.prod.outlook.com
 (2603:10b6:208:51:cafe::a7) by BL0PR02CA0079.outlook.office365.com
 (2603:10b6:208:51::20) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7046.23 via Frontend
 Transport; Fri, 1 Dec 2023 10:49:43 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.160)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 BL02EPF0001A0FA.mail.protection.outlook.com (10.167.242.101) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.7046.17 via Frontend Transport; Fri, 1 Dec 2023 10:49:42 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.41; Fri, 1 Dec 2023
 02:49:26 -0800
Received: from rnnvmail204.nvidia.com (10.129.68.6) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.41; Fri, 1 Dec 2023
 02:49:26 -0800
Received: from c-237-113-220-225.mtl.labs.mlnx (10.127.8.12) by
 mail.nvidia.com (10.129.68.6) with Microsoft SMTP Server id 15.2.986.41 via
 Frontend Transport; Fri, 1 Dec 2023 02:49:23 -0800
From: Dragos Tatulea <dtatulea@nvidia.com>
To: "Michael S . Tsirkin" <mst@redhat.com>, Jason Wang <jasowang@redhat.com>,
	Eugenio Perez Martin <eperezma@redhat.com>, Si-Wei Liu
	<si-wei.liu@oracle.com>, Saeed Mahameed <saeedm@nvidia.com>, Leon Romanovsky
	<leon@kernel.org>, <virtualization@lists.linux-foundation.org>
CC: Dragos Tatulea <dtatulea@nvidia.com>, <kvm@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>, Gal Pressman <galp@nvidia.com>, Parav Pandit
	<parav@nvidia.com>, Xuan Zhuo <xuanzhuo@linux.alibaba.com>
Subject: [PATCH vhost 2/7] vdpa/mlx5: Split function into locked and unlocked variants
Date: Fri, 1 Dec 2023 12:48:52 +0200
Message-ID: <20231201104857.665737-3-dtatulea@nvidia.com>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231201104857.665737-1-dtatulea@nvidia.com>
References: <20231201104857.665737-1-dtatulea@nvidia.com>
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
X-MS-TrafficTypeDiagnostic: BL02EPF0001A0FA:EE_|PH0PR12MB8052:EE_
X-MS-Office365-Filtering-Correlation-Id: 10bf0976-c178-43af-b9f4-08dbf25b39eb
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	OVHDmkUXYoslfIzi8AZ0BIwVHWpuw9cJXTB44HU739z5aA92R7LNE0gGSrdLXEpS0Ts3SEUoWAwCjIfpJdzjDfPhHXFP6XLQHVfuIJ3eVXYgMged7uFLgVzL7xAuWxjnFl6avcyfxTM2sc39oLR9y5nKSzJybv0EFfHwmZ7mkmztZMcaNf+myo6Ei4z8MDNjQYGvtwwAuPxWgdMC6MVQK6sItfl9ZPlaWuJDbWoHaXP9eVdn99V7hCN0QqOF7OT7YlYnlRJnEo9rs6sWtOT8RKgXy60JpKXwVu5KUBOTccIfqGTXbeukQwBXJSslnTroXt2q2RrF0CTSrgoYkoz7yTMjnpBXNw9NDaCzcbN5Oau0VH8p80HI1tYVnv9bLzSb7P0CKm1zqwr7oB1bKnWqFfbauE2H0rbFfIJmXyhor8edIyoq9Ld9S7Qkj0A7Lk7AXeLvNkVbgHIY0BKAHwKiB/UaRP+CmSFXwbbqZqi36JSMPkcT/0LvSLo6WuUhgPBgdkRszHZtp36HhrQRxhN99CWo8QrAkm9hmNCTFRFudTVxtwI+L411YiZzGFAyBrlEr++fEsWCx0iooE3bHy+8okuvSxzzn7ZAC/MsEMolqtM/oClHj4oyfLPblpDEA8Pd+dGXLlgKOoeH3CME+glMZyd7PR8kDk9x07+mwI+votry0C6MvmZlebCDPTc7jcPOnZCb4FRdkIliZkihCHObgV1Y4aR/rymw4Gg/YZXwCvfmFgirsh+RGD/zzt7BnxFm
X-Forefront-Antispam-Report:
	CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230031)(4636009)(396003)(376002)(346002)(39860400002)(136003)(230922051799003)(186009)(64100799003)(82310400011)(451199024)(1800799012)(40470700004)(36840700001)(46966006)(40480700001)(86362001)(40460700003)(70586007)(70206006)(7636003)(356005)(82740400003)(36756003)(83380400001)(54906003)(47076005)(426003)(36860700001)(1076003)(26005)(2616005)(6666004)(110136005)(2906002)(316002)(4326008)(8676002)(5660300002)(336012)(8936002)(478600001)(41300700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Dec 2023 10:49:42.8877
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 10bf0976-c178-43af-b9f4-08dbf25b39eb
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BL02EPF0001A0FA.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR12MB8052

mlx5_vdpa_destroy_mr contains more logic than _mlx5_vdpa_destroy_mr.
There is no reason for this to be the case. All the logic can go into
the unlocked variant.

Using the unlocked version is needed in a follow-up patch. And it also
makes it more consistent with mlx5_vdpa_create_mr.

Signed-off-by: Dragos Tatulea <dtatulea@nvidia.com>
---
 drivers/vdpa/mlx5/core/mr.c | 31 ++++++++++++++++---------------
 1 file changed, 16 insertions(+), 15 deletions(-)

diff --git a/drivers/vdpa/mlx5/core/mr.c b/drivers/vdpa/mlx5/core/mr.c
index 2197c46e563a..8c80d9e77935 100644
--- a/drivers/vdpa/mlx5/core/mr.c
+++ b/drivers/vdpa/mlx5/core/mr.c
@@ -498,32 +498,32 @@ static void destroy_user_mr(struct mlx5_vdpa_dev *mvdev, struct mlx5_vdpa_mr *mr
 
 static void _mlx5_vdpa_destroy_mr(struct mlx5_vdpa_dev *mvdev, struct mlx5_vdpa_mr *mr)
 {
+	if (!mr)
+		return;
+
 	if (mr->user_mr)
 		destroy_user_mr(mvdev, mr);
 	else
 		destroy_dma_mr(mvdev, mr);
 
+	for (int i = 0; i < MLX5_VDPA_NUM_AS; i++) {
+		if (mvdev->mr[i] == mr)
+			mvdev->mr[i] = NULL;
+	}
+
 	vhost_iotlb_free(mr->iotlb);
+
+	kfree(mr);
 }
 
 void mlx5_vdpa_destroy_mr(struct mlx5_vdpa_dev *mvdev,
 			  struct mlx5_vdpa_mr *mr)
 {
-	if (!mr)
-		return;
-
 	mutex_lock(&mvdev->mr_mtx);
 
 	_mlx5_vdpa_destroy_mr(mvdev, mr);
 
-	for (int i = 0; i < MLX5_VDPA_NUM_AS; i++) {
-		if (mvdev->mr[i] == mr)
-			mvdev->mr[i] = NULL;
-	}
-
 	mutex_unlock(&mvdev->mr_mtx);
-
-	kfree(mr);
 }
 
 void mlx5_vdpa_update_mr(struct mlx5_vdpa_dev *mvdev,
@@ -535,10 +535,7 @@ void mlx5_vdpa_update_mr(struct mlx5_vdpa_dev *mvdev,
 	mutex_lock(&mvdev->mr_mtx);
 
 	mvdev->mr[asid] = new_mr;
-	if (old_mr) {
-		_mlx5_vdpa_destroy_mr(mvdev, old_mr);
-		kfree(old_mr);
-	}
+	_mlx5_vdpa_destroy_mr(mvdev, old_mr);
 
 	mutex_unlock(&mvdev->mr_mtx);
 
@@ -546,8 +543,12 @@ void mlx5_vdpa_update_mr(struct mlx5_vdpa_dev *mvdev,
 
 void mlx5_vdpa_destroy_mr_resources(struct mlx5_vdpa_dev *mvdev)
 {
+	mutex_lock(&mvdev->mr_mtx);
+
 	for (int i = 0; i < MLX5_VDPA_NUM_AS; i++)
-		mlx5_vdpa_destroy_mr(mvdev, mvdev->mr[i]);
+		_mlx5_vdpa_destroy_mr(mvdev, mvdev->mr[i]);
+
+	mutex_unlock(&mvdev->mr_mtx);
 
 	prune_iotlb(mvdev->cvq.iotlb);
 }
-- 
2.42.0


