Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9BE027BD997
	for <lists+kvm@lfdr.de>; Mon,  9 Oct 2023 13:25:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346255AbjJILZY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 9 Oct 2023 07:25:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52024 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346298AbjJILZP (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 9 Oct 2023 07:25:15 -0400
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2042.outbound.protection.outlook.com [40.107.243.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E46D0D6;
        Mon,  9 Oct 2023 04:25:07 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=CwRzzl9e3x/DsEkNLZsnsg0ch8BoX/Xkq5LZ+2Yf9A6IRaiT7MazD1WyRLPD4fEITHvl5NwBRF1LzdeDlQhCV8OWYhq24Sff4E0gjq5wu8GIFnmZE9rYMwTVM2p0xhc4mXhi4Gzb1CcY4KxOLxJMGBWBoqr7b06PHhVC7EAUVa86J0SfHmG5T92rR5c9iyO6D/ah0hQCYfz939zoUrM5Gwf7FH0aZbEEo0WhHVQuLmpUr/oxUBga2EkBd/PFN+kBiLyrEjOczl0xBQzGAhAlahQAzgn61k+DgTMU81y+liugAgsBmgSr0SbMWFJo4/uOhRr3En9CvMKj4elkiYBPKQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=elzKdMTRh3uezwMcgzMejLd/DLpkMeh3g8HOvOAJXm0=;
 b=CADQCMUvdAHA6k4i+WBpyBb3HNUjtoUUH+VcgT9nrSUkzmh6bRsbrxZg9+K765nwrVekj2J5Gy0nlr8PHSyo1WFm8JwWGlZHi1QnjCvktgvxTg2oMhMTsbjfLkNc08sadZmZ6f+YTvOoI08E/6U/MzbwhGr1XeL8ucu8RI6/C+QSyyY503+hcMdM+iGGkgT7awUQ0GOZJz/zUJbOMkvVc7kdVvpVrAwCgS7TblfdkI7O2Aapq1tQ1KcuM4tm4k9vX1zLlllVA8L9apDScW5A2Qjj7rXOUg45HS+NpecDOsWMsDIQN6tDWqfQS09CPiXUcwSwUu0p/ivCH5EwzUjbIA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=redhat.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=elzKdMTRh3uezwMcgzMejLd/DLpkMeh3g8HOvOAJXm0=;
 b=SKc/HR0sXMjPZysXJmI1igcxXatIknchiKwM1tdoApypoZDT+uKDvjw9hTdPsVfZRXo7OTqlDfHatmEspB6iU8cc4xI+Yk4hnF2YcYaq6sfvEVS1baN40zV78Gks2iDL4jZGxc8nX0fLd16Vxt4dEYm2CCA/rg6ctiArzOElWXQaIjWhuVCp4QcbwMFxspRjnaX5Af3xVjdH+xe/31R4h+8WfPoVvpWBsTjE0AKI/Zjy7nzDnMmWY4pRA/LvNPRc87/wf6Ix9fz3+gTb7scoxCdZPmqRPi6Q4PON0VQTjsQCg/pkzciaKOJ4fTXbtoTdfyK82dfxpaOxK7wD/SI3Mw==
Received: from PH8PR20CA0012.namprd20.prod.outlook.com (2603:10b6:510:23c::10)
 by DM6PR12MB4975.namprd12.prod.outlook.com (2603:10b6:5:1bd::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6863.38; Mon, 9 Oct
 2023 11:25:05 +0000
Received: from SN1PEPF0002BA4B.namprd03.prod.outlook.com
 (2603:10b6:510:23c:cafe::29) by PH8PR20CA0012.outlook.office365.com
 (2603:10b6:510:23c::10) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6863.33 via Frontend
 Transport; Mon, 9 Oct 2023 11:25:03 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.160)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 SN1PEPF0002BA4B.mail.protection.outlook.com (10.167.242.68) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6838.14 via Frontend Transport; Mon, 9 Oct 2023 11:25:02 +0000
Received: from rnnvmail205.nvidia.com (10.129.68.10) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.41; Mon, 9 Oct 2023
 04:24:47 -0700
Received: from rnnvmail204.nvidia.com (10.129.68.6) by rnnvmail205.nvidia.com
 (10.129.68.10) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.41; Mon, 9 Oct 2023
 04:24:47 -0700
Received: from c-237-113-220-225.mtl.labs.mlnx (10.127.8.12) by
 mail.nvidia.com (10.129.68.6) with Microsoft SMTP Server id 15.2.986.41 via
 Frontend Transport; Mon, 9 Oct 2023 04:24:44 -0700
From:   Dragos Tatulea <dtatulea@nvidia.com>
To:     "Michael S . Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        Eugenio Perez Martin <eperezma@redhat.com>,
        Si-Wei Liu <si-wei.liu@oracle.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Leon Romanovsky <leon@kernel.org>,
        <virtualization@lists.linux-foundation.org>
CC:     Dragos Tatulea <dtatulea@nvidia.com>, <kvm@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, Parav Pandit <parav@nvidia.com>,
        Xuan Zhuo <xuanzhuo@linux.alibaba.com>
Subject: [PATCH vhost v3 08/16] vdpa/mlx5: Collapse "dvq" mr add/delete functions
Date:   Mon, 9 Oct 2023 14:23:53 +0300
Message-ID: <20231009112401.1060447-9-dtatulea@nvidia.com>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20231009112401.1060447-1-dtatulea@nvidia.com>
References: <20231009112401.1060447-1-dtatulea@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-NV-OnPremToCloud: ExternallySecured
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SN1PEPF0002BA4B:EE_|DM6PR12MB4975:EE_
X-MS-Office365-Filtering-Correlation-Id: d6397982-5a08-453b-e820-08dbc8ba61ae
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: V2OOseJi8bJ46Ttdkw32Pd8G39naxrrlMCs3lb+5AOnx3J+fVVtyov1gP1lajmWz0HaEYKp6qMylIlLa8RK4uOOayoAqUiOIgG9SX1VrjP8yrPtRI8mMOtxuhxsLrYn6CEvp+Ar4vzFOo8kuKvee8b+dy4vKdoExaZ07XMT6trm2yPr4Y9XCjMi9m9DkRXRT+lJCPjT3VyGhFsvCdGKFq56E3HFLAc37RScBR5kkSUeTdFeHIltZXQUEi14SrtEW15e3TkNY9XFIVG8q6ptaeYP04Yznnu5+plTukGUtlkqt3dmJ0pvCRbIbxuc/ZH8CGLiSSVhpl6J7suPjCX448p+DV1eB5ya9Fzeq6ldblEzSDnvWdLwzLZ11b1ODZEQSg0C4foOaalAa9w2MbjC3Ay4fLZMtUFafsDP3FTc2cVcps70FG8RuKpjEceDYD0ePZauJiGL/ynfS6KraOaCOtSeVRBQADudk+vVwC/IzikQi6f9Bi3+agBMQ1uM2b2RDk+ZPgNDBd/MEV2VWGBbSJ3LZzvkk4plE//IN8lJ6L4XRnVLbBEWMA9QQHMO7ABpa7BbLa/VObm+tVbTVthGblfkUx9qXOzjf1ndK5QNq4Poa6JF/L+T6Ar1aXtStVmCtE+GCm5xsokgpoQaAPJTiIF90S0TjZGqQtQQPn2fe5EuseR6HnG6N4NbOJb1WDfWN9WLO8k1hCcTdwa7bxA0+S4J1c/En/77lJlZy8npS0j3DPpYQI6P/UL1rLtuRU/2x
X-Forefront-Antispam-Report: CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230031)(4636009)(136003)(39860400002)(346002)(396003)(376002)(230922051799003)(451199024)(64100799003)(82310400011)(186009)(1800799009)(46966006)(40470700004)(36840700001)(40480700001)(40460700003)(83380400001)(1076003)(2616005)(336012)(426003)(26005)(47076005)(66574015)(36860700001)(54906003)(70206006)(70586007)(110136005)(316002)(8936002)(8676002)(4326008)(5660300002)(41300700001)(6666004)(2906002)(478600001)(82740400003)(36756003)(356005)(7636003)(86362001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Oct 2023 11:25:02.9975
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: d6397982-5a08-453b-e820-08dbc8ba61ae
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: SN1PEPF0002BA4B.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB4975
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Now that the cvq code is out of mlx5_vdpa_create/destroy_mr, the "dvq"
functions can be folded into their callers.

Having "dvq" in the naming will no longer be accurate in the downstream
patches.

Acked-by: Jason Wang <jasowang@redhat.com>
Acked-by: Eugenio Pérez <eperezma@redhat.com>
Signed-off-by: Dragos Tatulea <dtatulea@nvidia.com>
---
 drivers/vdpa/mlx5/core/mr.c | 16 +++++-----------
 1 file changed, 5 insertions(+), 11 deletions(-)

diff --git a/drivers/vdpa/mlx5/core/mr.c b/drivers/vdpa/mlx5/core/mr.c
index 587300e7c18e..fde00497f4ad 100644
--- a/drivers/vdpa/mlx5/core/mr.c
+++ b/drivers/vdpa/mlx5/core/mr.c
@@ -489,7 +489,7 @@ static void destroy_user_mr(struct mlx5_vdpa_dev *mvdev, struct mlx5_vdpa_mr *mr
 	}
 }
 
-static void _mlx5_vdpa_destroy_dvq_mr(struct mlx5_vdpa_dev *mvdev, unsigned int asid)
+static void _mlx5_vdpa_destroy_mr(struct mlx5_vdpa_dev *mvdev, unsigned int asid)
 {
 	struct mlx5_vdpa_mr *mr = &mvdev->mr;
 
@@ -513,7 +513,7 @@ void mlx5_vdpa_destroy_mr_asid(struct mlx5_vdpa_dev *mvdev, unsigned int asid)
 
 	mutex_lock(&mr->mkey_mtx);
 
-	_mlx5_vdpa_destroy_dvq_mr(mvdev, asid);
+	_mlx5_vdpa_destroy_mr(mvdev, asid);
 
 	mutex_unlock(&mr->mkey_mtx);
 }
@@ -524,9 +524,9 @@ void mlx5_vdpa_destroy_mr(struct mlx5_vdpa_dev *mvdev)
 	prune_iotlb(mvdev);
 }
 
-static int _mlx5_vdpa_create_dvq_mr(struct mlx5_vdpa_dev *mvdev,
-				    struct vhost_iotlb *iotlb,
-				    unsigned int asid)
+static int _mlx5_vdpa_create_mr(struct mlx5_vdpa_dev *mvdev,
+				struct vhost_iotlb *iotlb,
+				unsigned int asid)
 {
 	struct mlx5_vdpa_mr *mr = &mvdev->mr;
 	int err;
@@ -550,12 +550,6 @@ static int _mlx5_vdpa_create_dvq_mr(struct mlx5_vdpa_dev *mvdev,
 	return 0;
 }
 
-static int _mlx5_vdpa_create_mr(struct mlx5_vdpa_dev *mvdev,
-				struct vhost_iotlb *iotlb, unsigned int asid)
-{
-	return _mlx5_vdpa_create_dvq_mr(mvdev, iotlb, asid);
-}
-
 int mlx5_vdpa_create_mr(struct mlx5_vdpa_dev *mvdev, struct vhost_iotlb *iotlb,
 			unsigned int asid)
 {
-- 
2.41.0

