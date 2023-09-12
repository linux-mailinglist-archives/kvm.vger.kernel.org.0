Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 49D1C79D18D
	for <lists+kvm@lfdr.de>; Tue, 12 Sep 2023 15:02:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235400AbjILNCU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 12 Sep 2023 09:02:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56014 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235368AbjILNCQ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 12 Sep 2023 09:02:16 -0400
Received: from NAM02-DM3-obe.outbound.protection.outlook.com (mail-dm3nam02on2057.outbound.protection.outlook.com [40.107.95.57])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 47AF810D8;
        Tue, 12 Sep 2023 06:02:12 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=mMjYq7mAvdMvWVNgH0736qQBAy/ywSF7BWKkQZIuUuuSjmBbMbXw6OfPIg7vj7AqZe62i/TUTOBYwqF4+JKOk6YMfxTDhWx8UwmpW0ebIhyubqMFne1l1pzE8riLWlc/F913rPuA3CTGn0bPuR/EXVx5i6sasiHckSD3If34TTxcNxRj+43qFPOmioJXnl/k1wLRtM8gRfbtV4CVlC7DAQbN9T8jgySxeDCGjP3SCBcpv4AA0E0ypVZWtvR+pZ6jzxwDA8mw+45SqCOT9ofM5NXoO90XfsydObRmg++n/a+cggR38zIUZo/mSzbk4lfOOXmTJU0wSp0HMXd6+kpFoA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Jcw78nTzQZ3ExNwGj4MBKC+eXGaqAVO5WPZzwt8aXrE=;
 b=ENv1+TtJw49o+TgQdk5ufg2cTQaflvdJf0cN8IlfetTEwgStQdg+KBqq2+bGuthODTXTsrj9epvw+2K/ac2Q1IvKGc4NX8zAyCRZbV4qPCvLTN6wqPwiUnMmA7cx43buklGVV1oKRZfddsVEGbsu6kg0gUn+w1FAPycLwdw75qHcjMefRy0E4udmakQudt5iFA8oprtkyk978wUo/psxeOG+JA7qlQfgQ3f8c/zMtd7tYy0HQdHxhkotoGLZC/Ify5VWdIO1NLueokE90RNNtLjBGHxCcxXe36OAF4MttmqrdLKRafp9+U91nyOcGghiSFVf5ImYO63oY8WSMp/fTQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=redhat.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Jcw78nTzQZ3ExNwGj4MBKC+eXGaqAVO5WPZzwt8aXrE=;
 b=Jw1rjYovY9E4D81FfnLPGDL+qQvkamaRMF4ltT3+gF6xvy9TvR5fw77+lQDG50cuSuZKldwWVZasVz7IZziHMAyGPmP4JAl8DI3mlk5fzqPX5MeiT+xcjar/nurkt5HRmZ0p+o7KHH15gwOiYr0JdWLpDAnnH6Uz1lsMjcuxryYpS1hTO30QAhi++8YSKeel85A2cySDuLXHxd7AHHzGNYdlK/3L6wMdw4guCGObr7292e0HR0lYfrcJNIu21hLRp7WsKF7dj9drdSjCtsCb+ajHO/wcIn72+tKvp5PCZRI6Dn5+vZMynFd9G2Kh2eRSgWqZ5Kavz8NvztgLPACqzA==
Received: from CY8PR12CA0010.namprd12.prod.outlook.com (2603:10b6:930:4e::25)
 by CY5PR12MB6527.namprd12.prod.outlook.com (2603:10b6:930:30::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6768.30; Tue, 12 Sep
 2023 13:02:10 +0000
Received: from CY4PEPF0000E9D5.namprd05.prod.outlook.com
 (2603:10b6:930:4e:cafe::1d) by CY8PR12CA0010.outlook.office365.com
 (2603:10b6:930:4e::25) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6768.38 via Frontend
 Transport; Tue, 12 Sep 2023 13:02:10 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.161)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 CY4PEPF0000E9D5.mail.protection.outlook.com (10.167.241.76) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6792.17 via Frontend Transport; Tue, 12 Sep 2023 13:02:10 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.5; Tue, 12 Sep 2023
 06:02:00 -0700
Received: from rnnvmail205.nvidia.com (10.129.68.10) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.37; Tue, 12 Sep
 2023 06:01:59 -0700
Received: from c-237-113-220-225.mtl.labs.mlnx (10.127.8.12) by
 mail.nvidia.com (10.129.68.10) with Microsoft SMTP Server id 15.2.986.37 via
 Frontend Transport; Tue, 12 Sep 2023 06:01:57 -0700
From:   Dragos Tatulea <dtatulea@nvidia.com>
To:     Jason Wang <jasowang@redhat.com>,
        =?UTF-8?q?Eugenio=20P=C3=A9rez?= <eperezma@redhat.com>,
        Si-Wei Liu <si-wei.liu@oracle.com>,
        "Michael S . Tsirkin" <mst@redhat.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        <virtualization@lists.linux-foundation.org>,
        <linux-kernel@vger.kernel.org>
CC:     Dragos Tatulea <dtatulea@nvidia.com>,
        Parav Pandit <parav@nvidia.com>,
        Xuan Zhuo <xuanzhuo@linux.alibaba.com>, <kvm@vger.kernel.org>
Subject: [PATCH 04/16] vdpa/mlx5: Create helper function for dma mappings
Date:   Tue, 12 Sep 2023 16:01:14 +0300
Message-ID: <20230912130132.561193-5-dtatulea@nvidia.com>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230912130132.561193-1-dtatulea@nvidia.com>
References: <20230912130132.561193-1-dtatulea@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-NV-OnPremToCloud: ExternallySecured
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY4PEPF0000E9D5:EE_|CY5PR12MB6527:EE_
X-MS-Office365-Filtering-Correlation-Id: 79f33d2c-c0e6-4e01-5c3a-08dbb39079f8
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: RHmb/dXs0Ql0jauXpDcnD5Sa0Id4cufz7LBthfvhE18Y5h4o+iV87tAvxhRdwyrXkiIcNy+xAoDJzbKkwBnbxeEOaT21kbbI9cJk0KXByfMDXkxqIovEgqDsw3nfXwb4TDKihmfCpXui7bEfFPlW9Y5dDyyG2srPXW4akKTt4ohZiteKyURAHoZqF6MnkwQI3o2xOPHBfRaFeyzAlaK6oS3C1PBufuOCYsOAERRzqi0LZW1rXXnKKhnVKKUiOM9SGN/Ew3nG0ff+a9IzDB14/QCHY2fuTbcQz9EaPukeHYQWANeB5gz8TZXCZ9n5KFRV+OOw3X3h6TSysHERtngE81gUCcOLj1c4FpX2eqorMMZmUyd2hTxghucjkRRPoY6LJmGG/d0XVn9WiNj5YS/IAIV6nyoUJAKMS6tz1cLHzdHi0yvza/fzMjnFYwyuFWek2HF3FPcouBsCru1/jgmNdcejn1/WtaMKv8LBF9Btsm8q+pH3uHO+UKyaUHjF19sZV9OAV3FirBm5xEpIpDJW7x8xHI9m7mSbUvE3WJyisXvdXY2GcrTNcK2+lj9X5Npmp+EI/1VUxEEd+fUhLxfBzYBlLsZl8OWitKNwQX/i452P+puGHOBUUEC2ShHI95MChWBr0sNxlmoPgr803395xHxxPacKybIKUZU9fU5KGo878bUkyTZTS3OIBWyfIekq/0e9u+8ueayt/KOpKqCoK1BCSujZggNrq60TWxEwi3M=
X-Forefront-Antispam-Report: CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230031)(4636009)(376002)(396003)(39860400002)(136003)(346002)(451199024)(82310400011)(186009)(1800799009)(36840700001)(40470700004)(46966006)(7636003)(54906003)(6666004)(86362001)(356005)(36756003)(82740400003)(40460700003)(36860700001)(47076005)(40480700001)(1076003)(2616005)(2906002)(336012)(426003)(83380400001)(8676002)(26005)(478600001)(8936002)(41300700001)(316002)(4326008)(70206006)(70586007)(5660300002)(110136005);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Sep 2023 13:02:10.4633
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 79f33d2c-c0e6-4e01-5c3a-08dbb39079f8
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CY4PEPF0000E9D5.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY5PR12MB6527
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Necessary for upcoming cvq separation from mr allocation.

Signed-off-by: Dragos Tatulea <dtatulea@nvidia.com>
---
 drivers/vdpa/mlx5/core/mlx5_vdpa.h | 1 +
 drivers/vdpa/mlx5/core/mr.c        | 5 +++++
 drivers/vdpa/mlx5/net/mlx5_vnet.c  | 4 ++--
 3 files changed, 8 insertions(+), 2 deletions(-)

diff --git a/drivers/vdpa/mlx5/core/mlx5_vdpa.h b/drivers/vdpa/mlx5/core/mlx5_vdpa.h
index ca56242972b3..3748f027cfe9 100644
--- a/drivers/vdpa/mlx5/core/mlx5_vdpa.h
+++ b/drivers/vdpa/mlx5/core/mlx5_vdpa.h
@@ -120,6 +120,7 @@ int mlx5_vdpa_create_mr(struct mlx5_vdpa_dev *mvdev, struct vhost_iotlb *iotlb,
 			unsigned int asid);
 void mlx5_vdpa_destroy_mr(struct mlx5_vdpa_dev *mvdev);
 void mlx5_vdpa_destroy_mr_asid(struct mlx5_vdpa_dev *mvdev, unsigned int asid);
+int mlx5_vdpa_create_dma_mr(struct mlx5_vdpa_dev *mvdev);
 
 #define mlx5_vdpa_warn(__dev, format, ...)                                                         \
 	dev_warn((__dev)->mdev->device, "%s:%d:(pid %d) warning: " format, __func__, __LINE__,     \
diff --git a/drivers/vdpa/mlx5/core/mr.c b/drivers/vdpa/mlx5/core/mr.c
index 5a1971fcd87b..7bd0883b8b25 100644
--- a/drivers/vdpa/mlx5/core/mr.c
+++ b/drivers/vdpa/mlx5/core/mr.c
@@ -619,3 +619,8 @@ int mlx5_vdpa_handle_set_map(struct mlx5_vdpa_dev *mvdev, struct vhost_iotlb *io
 
 	return err;
 }
+
+int mlx5_vdpa_create_dma_mr(struct mlx5_vdpa_dev *mvdev)
+{
+	return mlx5_vdpa_create_mr(mvdev, NULL, 0);
+}
diff --git a/drivers/vdpa/mlx5/net/mlx5_vnet.c b/drivers/vdpa/mlx5/net/mlx5_vnet.c
index 37be945a0230..d34c19b4e139 100644
--- a/drivers/vdpa/mlx5/net/mlx5_vnet.c
+++ b/drivers/vdpa/mlx5/net/mlx5_vnet.c
@@ -2836,7 +2836,7 @@ static int mlx5_vdpa_reset(struct vdpa_device *vdev)
 	++mvdev->generation;
 
 	if (MLX5_CAP_GEN(mvdev->mdev, umem_uid_0)) {
-		if (mlx5_vdpa_create_mr(mvdev, NULL, 0))
+		if (mlx5_vdpa_create_dma_mr(mvdev))
 			mlx5_vdpa_warn(mvdev, "create MR failed\n");
 	}
 	up_write(&ndev->reslock);
@@ -3441,7 +3441,7 @@ static int mlx5_vdpa_dev_add(struct vdpa_mgmt_dev *v_mdev, const char *name,
 		goto err_mpfs;
 
 	if (MLX5_CAP_GEN(mvdev->mdev, umem_uid_0)) {
-		err = mlx5_vdpa_create_mr(mvdev, NULL, 0);
+		err = mlx5_vdpa_create_dma_mr(mvdev);
 		if (err)
 			goto err_res;
 	}
-- 
2.41.0

