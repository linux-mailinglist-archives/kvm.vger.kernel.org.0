Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3D5147BD980
	for <lists+kvm@lfdr.de>; Mon,  9 Oct 2023 13:24:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346236AbjJILYk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 9 Oct 2023 07:24:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59052 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346216AbjJILYj (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 9 Oct 2023 07:24:39 -0400
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2075.outbound.protection.outlook.com [40.107.244.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A1542C6;
        Mon,  9 Oct 2023 04:24:37 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Dl/oZ7/fLgTecJO74VEcKKb9DoY2t/tEzoC1/F8J/OqdrKuRYBOx5RPdJq2+Uucy8DW/EFN22xttmmEkca6/v256vdcVZ6kHocgVZ22oyoqxzkMf8Mq5eMopmcR1R1Z/sXhP1cuhDrDOD1yERCsGzGc7qI+D8P0tfqOm15H1Nt+IGkdjxnOUu3j8zHgW6GquzF+Vl2yFSywjXff9RXsylDi6aaD1+iHogO7naoU2QVNIlI9LRd+BTKPzL/MOULey7pRyM91B+EX4UXMay+ktxtdT2Iyoa69VT49fxPujrf64QVw88H446Tys3MgZRj48fDLqsQeN6EDAZvORE211dQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Ks0yqKFa9s2l5F9bXQdb3gSn8cxS7t2k+S80slwQQFY=;
 b=mLXjL5ApuVmO7pBuA0qZmyockV9qT70VRNLBiSFi+DSl1813Xpc4HEAIkM727u2QOyeM2F+tR//5tZO2FNp0jYUD5OnTYKNwmD2KGXotlWGNs5agivLd4kx2wpLOYqGpfv56u9UHBSxO7skFcrlBSsbnQJfp/TL6O6FsfO2ZLRoCnPQpjysNxyv2xZa78qqDqr5kzfhlHLuetfrRNJBbX0bkzPfRuqZVcG2fDT0Ii4syKn3rfKUIlj47mcKfN4tH2e2fheCad2DI6sIsj7SWrX1BC4NVoQiHzFUTN1mhORz6XyfHQVh8p0k8VZGKE7r8DBZ89D1omuDvXjva7KR0/g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=redhat.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Ks0yqKFa9s2l5F9bXQdb3gSn8cxS7t2k+S80slwQQFY=;
 b=E5Fdl+S54A5JB3fXMBXrNVsX5kI/FW4stDAsa4q1IOF0eLpuotXWViAv0TS/oRHTAJV2UOlo6exLeLrVdyH/PPSexgOaFOJrPx0C7Tx98umcIr8C6U/oFdqJej5Lu0zgY2QT7glOit3wUmumrKXnO7OshXomOnRGXCDZ7+v7E3LSuDbn0cX9AlCTieQzDRhSOpPusvEBfojRZov7Q0914UOYwJwBLCAuXHed8WOIKPE/JbgHFoHX9ORv1YRU3EhmxcO3x+OJYsidkscHpDzeVw1fCK5z+wZ03c08Ms+q4qLGJhzj2s3sc8sVkupMfO9TOJcaY9LA7hCVOfnSyE3a+w==
Received: from BL1PR13CA0100.namprd13.prod.outlook.com (2603:10b6:208:2b9::15)
 by SJ2PR12MB8806.namprd12.prod.outlook.com (2603:10b6:a03:4d0::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6838.37; Mon, 9 Oct
 2023 11:24:35 +0000
Received: from MN1PEPF0000ECD9.namprd02.prod.outlook.com
 (2603:10b6:208:2b9:cafe::5d) by BL1PR13CA0100.outlook.office365.com
 (2603:10b6:208:2b9::15) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6886.21 via Frontend
 Transport; Mon, 9 Oct 2023 11:24:34 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.161)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 MN1PEPF0000ECD9.mail.protection.outlook.com (10.167.242.138) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6838.14 via Frontend Transport; Mon, 9 Oct 2023 11:24:34 +0000
Received: from rnnvmail205.nvidia.com (10.129.68.10) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.41; Mon, 9 Oct 2023
 04:24:19 -0700
Received: from rnnvmail204.nvidia.com (10.129.68.6) by rnnvmail205.nvidia.com
 (10.129.68.10) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.41; Mon, 9 Oct 2023
 04:24:19 -0700
Received: from c-237-113-220-225.mtl.labs.mlnx (10.127.8.12) by
 mail.nvidia.com (10.129.68.6) with Microsoft SMTP Server id 15.2.986.41 via
 Frontend Transport; Mon, 9 Oct 2023 04:24:16 -0700
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
        Xuan Zhuo <xuanzhuo@linux.alibaba.com>,
        Gal Pressman <gal@nvidia.com>
Subject: [PATCH mlx5-vhost v3 01/16] vdpa/mlx5: Expose descriptor group mkey hw capability
Date:   Mon, 9 Oct 2023 14:23:46 +0300
Message-ID: <20231009112401.1060447-2-dtatulea@nvidia.com>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20231009112401.1060447-1-dtatulea@nvidia.com>
References: <20231009112401.1060447-1-dtatulea@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-NV-OnPremToCloud: ExternallySecured
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MN1PEPF0000ECD9:EE_|SJ2PR12MB8806:EE_
X-MS-Office365-Filtering-Correlation-Id: 0ac7d9d3-7c63-4cb1-ae2a-08dbc8ba50d6
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: wyeIsLVFGFhg1JtmwvSbzR+KaaobtyhrXYfrQAIMxy2FsYcVEsx6ZWcAbX65FEVJbTO1FqGaOpnuKGmAT/tAI/DEEcwca0y5qSyCx0Qib84EkXme7k3qMGMmmqPIIUHh+c7V5MObecCAbPWpVKFf2SE/wpbgFiP12akqaWQhGGAA88eEIwDTEuGex8WXno6xj2MMjzHFkwR74Vh4dQtFZO/FuhEW6ETUI3Et5jasr6yZ6J+mAQhdkP7sDKsukiCtFPb6IfXNKGYJ3Rv9TS0fhIpR98Hj5ygSzY2CSSIx1McbT0cQXMyVm2aai3qi5lV+6qCYcFyTMGU9JM+6LVxSWfWp90AEhabeivdU/c8+WIWjPjJKH4m1hcnQBmipXWyXDF+QtyXkRalWsc0HEP6U34cMi0Tc5UK5mpu1b9m+Bj7vbPbxOEyKkljGVUxu3b5t18C+VCaMHzSTO2OBqb7ubVC3QXmZczShPNS3VAkm93i/I267KGm6xof5+YxGZbYGQUqd6j1tPdWhqJH0yXv+p+7YFUVPmJdrFV+XtsGDgxxiNU2AvzdHJJMacFLOW5Iq7YmrCpPWlwrSfQbOrYSA40GY29yk7S2uHgoLvjHe6w81OyGsANfkoCa+hU9dY6c00bxZkck/d4f2URzJdsogKWEGLxQ9SZDrPzqJGtSfj4liAVhtQEU1QFS7CZBK77HCdBkC5p4OphF3EU0M6pXFjXZ66Grg1zoUJT6f5wfHsOCtM5ESum/0eC10QDomVUxj
X-Forefront-Antispam-Report: CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230031)(4636009)(346002)(136003)(376002)(39860400002)(396003)(230922051799003)(186009)(64100799003)(82310400011)(451199024)(1800799009)(40470700004)(36840700001)(46966006)(40480700001)(40460700003)(83380400001)(2616005)(107886003)(1076003)(336012)(426003)(26005)(47076005)(36860700001)(54906003)(110136005)(70586007)(316002)(70206006)(8936002)(8676002)(4326008)(41300700001)(5660300002)(6666004)(2906002)(4744005)(478600001)(82740400003)(36756003)(356005)(7636003)(86362001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Oct 2023 11:24:34.6901
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 0ac7d9d3-7c63-4cb1-ae2a-08dbc8ba50d6
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: MN1PEPF0000ECD9.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ2PR12MB8806
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Necessary for improved live migration flow. Actual support will be added
in a downstream patch.

Reviewed-by: Gal Pressman <gal@nvidia.com>
Signed-off-by: Dragos Tatulea <dtatulea@nvidia.com>
---
 include/linux/mlx5/mlx5_ifc.h | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/include/linux/mlx5/mlx5_ifc.h b/include/linux/mlx5/mlx5_ifc.h
index dd8421d021cf..ec15330b970d 100644
--- a/include/linux/mlx5/mlx5_ifc.h
+++ b/include/linux/mlx5/mlx5_ifc.h
@@ -1231,7 +1231,13 @@ struct mlx5_ifc_virtio_emulation_cap_bits {
 	u8         max_emulated_devices[0x8];
 	u8         max_num_virtio_queues[0x18];
 
-	u8         reserved_at_a0[0x60];
+	u8         reserved_at_a0[0x20];
+
+	u8	   reserved_at_c0[0x13];
+	u8         desc_group_mkey_supported[0x1];
+	u8         reserved_at_d4[0xc];
+
+	u8         reserved_at_e0[0x20];
 
 	u8         umem_1_buffer_param_a[0x20];
 
-- 
2.41.0

