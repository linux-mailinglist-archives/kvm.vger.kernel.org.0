Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C09557BD99A
	for <lists+kvm@lfdr.de>; Mon,  9 Oct 2023 13:25:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346330AbjJILZ1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 9 Oct 2023 07:25:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51902 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346302AbjJILZL (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 9 Oct 2023 07:25:11 -0400
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2081.outbound.protection.outlook.com [40.107.94.81])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 599EC129;
        Mon,  9 Oct 2023 04:25:02 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=nR54YzSwT/cxGJ9R0frM+IRMn6GtsZX4yDgGb1NMhfervUARASdO3NAQEL4jcKVQ3JKdNIDeMgwhrU1LnL8Q8RvA4mefiOcz8ZilLhv4fU1NTkmV7VpWn3lRTCj1RShdn840kXmqlD2ihbYWOnEEraxhTO/jNWCodwQbWPeRqkOgVTI6mr5kHUMoVbd6Qr/eKdPT1c00GiLEUUUpKrXb7r39dEF8JvGNrGocs0HtP78TjzBJPqsFxlW63qF009B/tn/L0RDTCbTe4LGlx4BwQrBLKgHE1o4Fjw/ER4uiWhq8SymqD6zZFXh2dmhC+pIY7RkTwUKpvdxp7U3vtrbjDg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=sqfty/jYzKnLc/JEwSMOvq4UGNN3rkOgV9qEyvqXUKk=;
 b=KAQlrfx9qDTnGtkQ8+psa0wgciQ68xC2ePwm8FzVzYkpqpbeYq0f3VaB+4DqG3MAMbAfnFMXkidH7pbq0n/6FyFfnMrtwWdLQnjnCI3WI3nZV5XfvZu/1XjVUC/nqEupllwmr5r3j/qwkJt62kTaNfe7GQN9qUmPE/hI/GW22YkPm7EhzOma4WIDCa6a900JUJNmTxNphZdMKz1dIisn36dKzpn788VzXomiH7jf5rYNu7kFqChNeS9rfTB/Fsiq8nL/s6Oa0NRPrKOa3+/1iH3Ul2+s7Fmt7bWH58YiIO2SeKRMgB7urOUVWLiP3M7x/GhTPPGZM+S1RTbLRUCnzg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=redhat.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=sqfty/jYzKnLc/JEwSMOvq4UGNN3rkOgV9qEyvqXUKk=;
 b=UyTqBMsMAAhpe0S2VLxY8lziOC1IqsF7U1hYbAC8IpOKLIhJbzxvB0Wbyjx+KsQastCYWL1UkyiufiYyj0FFy8hzNB/bitKR9s/rlvg821ad76UnnvieP48DEDcb9pkSZ6n2SR6sIwPgdGpMRI1+dflCfxW42J9YooS1+Qp662sZ4MlHLsQr+MrumLzeQHvOPB9w0jHbK+2a+XcJeQXYw7TtTB9xy2uNi8YexDcNtGKUWYDVrp65XQqrNbYbTWIeOqP3I472IM2qz74tAPG5zgimc52FCtip8GubxDMsN69V81aqdRu5TU0X1dUYA7Y0NVaCJ1ZpD5L3ik77e5XtbQ==
Received: from BLAPR03CA0032.namprd03.prod.outlook.com (2603:10b6:208:32d::7)
 by PH0PR12MB7887.namprd12.prod.outlook.com (2603:10b6:510:26d::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6838.43; Mon, 9 Oct
 2023 11:24:59 +0000
Received: from MN1PEPF0000ECD5.namprd02.prod.outlook.com
 (2603:10b6:208:32d:cafe::5) by BLAPR03CA0032.outlook.office365.com
 (2603:10b6:208:32d::7) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6863.37 via Frontend
 Transport; Mon, 9 Oct 2023 11:24:59 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.161)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 MN1PEPF0000ECD5.mail.protection.outlook.com (10.167.242.133) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6838.22 via Frontend Transport; Mon, 9 Oct 2023 11:24:59 +0000
Received: from rnnvmail203.nvidia.com (10.129.68.9) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.41; Mon, 9 Oct 2023
 04:24:43 -0700
Received: from rnnvmail204.nvidia.com (10.129.68.6) by rnnvmail203.nvidia.com
 (10.129.68.9) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.41; Mon, 9 Oct 2023
 04:24:43 -0700
Received: from c-237-113-220-225.mtl.labs.mlnx (10.127.8.12) by
 mail.nvidia.com (10.129.68.6) with Microsoft SMTP Server id 15.2.986.41 via
 Frontend Transport; Mon, 9 Oct 2023 04:24:40 -0700
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
Subject: [PATCH vhost v3 07/16] vdpa/mlx5: Take cvq iotlb lock during refresh
Date:   Mon, 9 Oct 2023 14:23:52 +0300
Message-ID: <20231009112401.1060447-8-dtatulea@nvidia.com>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20231009112401.1060447-1-dtatulea@nvidia.com>
References: <20231009112401.1060447-1-dtatulea@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-NV-OnPremToCloud: ExternallySecured
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MN1PEPF0000ECD5:EE_|PH0PR12MB7887:EE_
X-MS-Office365-Filtering-Correlation-Id: df07ddcd-29a2-4475-2fd4-08dbc8ba5fa6
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: E6pNu0ufCgR5HLXjXutWH4pe+K8PpVLKlbzyh54pM8878HddeSxfdOTqzNV+nefhz5CtLrhzxUx0PEVIsvtWW2dxHaxwt4r5+hGpT9bHrbDipx0kxZwoMF7oTSZ2ruScJQ9mefReN+sOE4ZZKYDGZzrkJKMstKlJjBGwnv7Ao+OLF8fHXsd0pJpY2lAH1/3p5oRbH6TISgFhAxG9gJz5z7THUNjvuIBkqu2PG+KDtLCtm789BquLH9fkped+rwn/tbC57XkXiZAnuUPbR1OGoakCuF70AuNFiacCblskNJIj1Bi/hwU/edzEVhTCzkyIm1JVHJvMd5iCdO3OGXs6RLwlDqmzUajFlzth4zsvJEDXP8S0OY3/uD3LjsN4BdgDXNAq9mSoZqbFR7P7FNBxOpF9xT8HOdc4Ox0rvkwuUPDfBFydEBxIykhGQFFvKFNBNDQHZE03zqjlYajYPmyGIWQelJbv9nUWvEAhvYJREUFHBdRPkW/ULUPq4r8TBOgSVg45x75Q3G++ymH+xgCWKk4Ew4lbir6V5fGDhsFNsdVIIzk7xiP21mswRCB/TaQpmJ4CKJyeb1o1bLBq+TFuLbbK3TlJVYdQ+jtRJPPpXKoY3hRrLF89aXRaOWfasl26A+knSDfjeExepZ+la/O/A6b3PMG4JXbdO6AUr/EwLR4Id4au7gOkNxyUXxGPc77YmF4vTUCLsEWSRIq9HlpfLlAjOn52CuX7d7zEj5Zy8pTc/CFJ1iTV61BRu7FWkpJ7n+AIOK6fpaBjwyyU/gp4u+YBI8m3Gow64odmZHc5XWo=
X-Forefront-Antispam-Report: CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230031)(4636009)(39860400002)(136003)(396003)(376002)(346002)(230922051799003)(451199024)(64100799003)(1800799009)(186009)(82310400011)(40470700004)(36840700001)(46966006)(1076003)(478600001)(966005)(2616005)(66574015)(2906002)(47076005)(336012)(426003)(26005)(83380400001)(5660300002)(110136005)(54906003)(70206006)(8936002)(4326008)(8676002)(41300700001)(70586007)(316002)(40480700001)(82740400003)(356005)(7636003)(36860700001)(36756003)(40460700003)(86362001)(6666004);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Oct 2023 11:24:59.5224
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: df07ddcd-29a2-4475-2fd4-08dbc8ba5fa6
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: MN1PEPF0000ECD5.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR12MB7887
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The reslock is taken while refresh is called but iommu_lock is more
specific to this resource. So take the iommu_lock during cvq iotlb
refresh.

Based on Eugenio's patch [0].

[0] https://lore.kernel.org/lkml/20230112142218.725622-4-eperezma@redhat.com/

Acked-by: Jason Wang <jasowang@redhat.com>
Suggested-by: Eugenio Pérez <eperezma@redhat.com>
Reviewed-by: Eugenio Pérez <eperezma@redhat.com>
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

