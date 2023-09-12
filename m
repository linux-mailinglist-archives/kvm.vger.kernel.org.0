Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C361479D1A7
	for <lists+kvm@lfdr.de>; Tue, 12 Sep 2023 15:03:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235273AbjILNDE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 12 Sep 2023 09:03:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41190 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235428AbjILNCv (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 12 Sep 2023 09:02:51 -0400
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2041.outbound.protection.outlook.com [40.107.236.41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A21031993;
        Tue, 12 Sep 2023 06:02:26 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=CU2Qs/Y+0hNfucwN+34cCL5zoMqAkfs+aT4+bnbhjlKa1NY2kk8Zv/A8RoEB55NYRgqXL8/ksQOzlilZ/RUp9fOwqYUJ11GgabgcrMRlE3L1aUXd1l97WYd68xiNAH7M69flB50F5zJsRJp8Vnm2AsoDYVCPIR1PVZe8xf93Z8T+oJs6fohvYuPV7xb4Hu8Tu0IypwzEm5QHOqMIpO3ZScO8OIUsikokpXixRIcksQZlTR2DIF1jwoT7cFtRMsuVJKsf1dV9dt2kF5iOfdR8CvAE4pUFxHu6UT+xrTKl+SV7Cy1xB+11L1M0GTzPRHDxEfKLd+2iNDpTGMFy9KZLeQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=BCeSvy0nChMIti0ZnBRuBRUFtl31nAh7dJm/MoH4xA4=;
 b=Q7kD0uBiEAIJQ/z1TcsIXDZKcjPi1rF0wG9H7lEXNU52//Y+1b6gyYjBER0HOe6kbUibZy8U5viu6mzxzZ8cij5vzDuJCA5SrCN6E7RwOAxuSeAPrMcNFZCzRdRLVXDYtRLPufPsZ2YcXHkVN37apUUYRFZMSDNhxaiJ6ftAkdm/vxmpfTdc9yEwq+ViDLJSGz0rp4zdhA7L9RCxyF2B1jWwiw3hbUWick9vhB1c6xlHWedIZKoDbcapq3whtgGq3pjCPHcAucDXru6MgW8YOLWq/N4ZuRY+HAYvzktS/vKdyQDMdO0jOmk1Q/JRzY3xEjiRQdNOb6LEsHyVy6TvyA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=redhat.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=BCeSvy0nChMIti0ZnBRuBRUFtl31nAh7dJm/MoH4xA4=;
 b=cAKboH7lwjTFzyaKLLTva1tcXDZrWeu5NeOmks+qTjjA5bXo63jqSZ5SBDXItIEDsqyuM7rU0M4DyEOGGIX4wBEcuc1AbXyTtYr6E1StCzJN/pdp0fiqQ6sIFtpwhNiqSrFw26aSE1/7IbErgZ7C9jCwb9h+gVmVlvGkpqW+Fj3p+6Hhi76ETeWNt8ZlSQxTEUB8UAuhYrOhTcqsTv3dmoVBF5SOCKEKP0mAQJAX2KFsenPzrK+Ug9b3ylyWg7PZw9hbk9trLVUbQVvetOad23+zJbNX6udpU809Dl/fmxQ3mWusubUKIPay4lYOrYZNY8IWPdOZikY5PqX6qWUdMw==
Received: from SJ0PR03CA0254.namprd03.prod.outlook.com (2603:10b6:a03:3a0::19)
 by IA0PR12MB7626.namprd12.prod.outlook.com (2603:10b6:208:438::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6768.35; Tue, 12 Sep
 2023 13:02:24 +0000
Received: from CO1PEPF000042AB.namprd03.prod.outlook.com
 (2603:10b6:a03:3a0:cafe::c8) by SJ0PR03CA0254.outlook.office365.com
 (2603:10b6:a03:3a0::19) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6768.37 via Frontend
 Transport; Tue, 12 Sep 2023 13:02:24 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.160)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 CO1PEPF000042AB.mail.protection.outlook.com (10.167.243.40) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6792.17 via Frontend Transport; Tue, 12 Sep 2023 13:02:24 +0000
Received: from rnnvmail205.nvidia.com (10.129.68.10) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.5; Tue, 12 Sep 2023
 06:02:06 -0700
Received: from rnnvmail205.nvidia.com (10.129.68.10) by rnnvmail205.nvidia.com
 (10.129.68.10) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.37; Tue, 12 Sep
 2023 06:02:06 -0700
Received: from c-237-113-220-225.mtl.labs.mlnx (10.127.8.12) by
 mail.nvidia.com (10.129.68.10) with Microsoft SMTP Server id 15.2.986.37 via
 Frontend Transport; Tue, 12 Sep 2023 06:02:03 -0700
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
Subject: [PATCH 06/16] vdpa/mlx5: Take cvq iotlb lock during refresh
Date:   Tue, 12 Sep 2023 16:01:16 +0300
Message-ID: <20230912130132.561193-7-dtatulea@nvidia.com>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230912130132.561193-1-dtatulea@nvidia.com>
References: <20230912130132.561193-1-dtatulea@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-NV-OnPremToCloud: ExternallySecured
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO1PEPF000042AB:EE_|IA0PR12MB7626:EE_
X-MS-Office365-Filtering-Correlation-Id: 145c4461-2c01-42f0-ebb4-08dbb390820a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 5LUCawOLE4uhv70DYg3J231RtpypVoc3XBS2NgqCIcf7N9yxkXAZFwqghPTKfJfdeRw08Zys44R8cXACpX3/qDwWkSltuR/USVX0QicJZbsljo+WoXDY+WckOKU1NwALvNhTQyBZZvaHE+QFwxqStk8dyTepp72i1rp2om3a+FDK+APo5Uv1sFxBrkYmPSTc9cfDTDCdvj2k+ZZcFUQ/CoUO7p5LTwUChacQpQnsB5aOQH9yxWfyQepgcBy5USPEF0N1JkthIfOMXGRqCaJCvu3zG+eN/zcJZ3JkBlrXDszTYNq8erECNr2HTC1VsVRcvv5JK6/yHdEUbEHQxX9TFwcNrJdJqOWog7jCqXBeCsk6YtyhD0C3FS3MAwmL13aN1RYywzwXSB3c0bdNMbtlrC3Z9UkWwd5It6Jxx7hnJrJDSbdyxRBW0kw+xu6Lu79JB6XX3eAcEeMUJesX1Z/rVXMhIcn0X9xYc3QEAlDnjE6gHC0t62NA/Rf5ozRYH4EDBqR3V14GAJMg0OJsUpaqdGJ5zixPLH/Patl5ZGXaR915sN7dU3GivaH/N63rmi2bqIzUxwO9g0lI5KCmN7X4UTAZRDYWnNuOw3Rz+66A8N4VdaFkFcJyJtRPKNkSiPsV1LpR4bziOaNVK2auESbvHYnPpy9HjnlxtikmVGGgcRhRO6gpakOgDNIZH2hlc7LbSxJG0IDUatB8uiVHyp2e1x4BOAsC237r4c6p9lRHSGYolPuNgC4Pk0O7eYJCP7iJv5dVAQ1kIFdRrRN7X05j9Li3lIzOnxIIoYrWuJPpv0c=
X-Forefront-Antispam-Report: CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230031)(4636009)(39860400002)(396003)(136003)(376002)(346002)(82310400011)(451199024)(1800799009)(186009)(46966006)(40470700004)(36840700001)(2906002)(70206006)(40480700001)(26005)(1076003)(336012)(426003)(41300700001)(316002)(54906003)(110136005)(8676002)(70586007)(478600001)(966005)(4326008)(5660300002)(8936002)(6666004)(40460700003)(36756003)(36860700001)(66574015)(47076005)(2616005)(83380400001)(7636003)(86362001)(82740400003)(356005);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Sep 2023 13:02:24.0223
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 145c4461-2c01-42f0-ebb4-08dbb390820a
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1PEPF000042AB.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA0PR12MB7626
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The reslock is taken while refresh is called but iommu_lock is more
specific to this resource. So take the iommu_lock during cvq iotlb
refresh.

Based on Eugenio's patch [0].

[0] https://lore.kernel.org/lkml/20230112142218.725622-4-eperezma@redhat.com/

Suggested-by: Eugenio Pérez <eperezma@redhat.com>
Signed-off-by: Dragos Tatulea <dtatulea@nvidia.com>
---
 drivers/vdpa/mlx5/core/mr.c | 10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

diff --git a/drivers/vdpa/mlx5/core/mr.c b/drivers/vdpa/mlx5/core/mr.c
index fcb6ae32e9ed..587300e7c18e 100644
--- a/drivers/vdpa/mlx5/core/mr.c
+++ b/drivers/vdpa/mlx5/core/mr.c
@@ -590,11 +590,19 @@ int mlx5_vdpa_update_cvq_iotlb(struct mlx5_vdpa_dev *mvdev,
 				struct vhost_iotlb *iotlb,
 				unsigned int asid)
 {
+	int err;
+
 	if (mvdev->group2asid[MLX5_VDPA_CVQ_GROUP] != asid)
 		return 0;
 
+	spin_lock(&mvdev->cvq.iommu_lock);
+
 	prune_iotlb(mvdev);
-	return dup_iotlb(mvdev, iotlb);
+	err = dup_iotlb(mvdev, iotlb);
+
+	spin_unlock(&mvdev->cvq.iommu_lock);
+
+	return err;
 }
 
 int mlx5_vdpa_create_dma_mr(struct mlx5_vdpa_dev *mvdev)
-- 
2.41.0

