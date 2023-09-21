Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 06A7E7A97C8
	for <lists+kvm@lfdr.de>; Thu, 21 Sep 2023 19:27:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230200AbjIUR1q (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 21 Sep 2023 13:27:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55122 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229790AbjIUR1K (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 21 Sep 2023 13:27:10 -0400
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on20625.outbound.protection.outlook.com [IPv6:2a01:111:f400:fe5a::625])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 46178CDA
        for <kvm@vger.kernel.org>; Thu, 21 Sep 2023 10:01:13 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=CskpOzTrBeA3lBGkmgyJG/q3CFBrVvri/t9NCxq9WJLR/a+S9VKY+3G6R9NrPJZoGfyCwEJFOu5harSrwYL26Jo/epBG+WNjvdkNN22LpYTVEMkMbD2wYgfUt7iHKnweaRumZYTEzh9NI9Wr1+jBN53V5C1WAfrZttCuhcko2D07vokqIfolMA4DSeJWWjE5x71uVfwJOzgqOiNeJINhpyIQGz7aCM9PX58VQ+JhmhcRvP+wWlAJ5Oh44w6BUXRDWAiM2z6mVxZtcjbPJpKZBYC3etykA1JvZpZj7aPXaszI2mDpzpXIznhOeR2GVcbXhWbYaIXrlhi6BcW2x1dPSQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=EJelJnn/JyXTdadjpJZBsKAweBrMvLSpqlwHLntWW68=;
 b=IfH2bm7lwlS+7YNvsfvxahGPUWAoFI8X3SYVu0UX/qu2cKjpmx5TjcC0awR9ttZLQmyPEWJQvneCimdsvM8jLUvgROym1+PiQps3Q7uILP12CTwIJFne9T+dKf7jMkHvwBCMECAwJXfnViYZLzhbFVDSawi5whoBlvIbsgR7bqBi82zgZKEfl1xHOm7ws4RIvDKiZQmhavuZdCukyvtpsmyHd4PRH87z99SHe7fe7tAUrFfnXC2JGgsB1HyqdTiv/wJRYdhNYTjvHdKpdSm6Lr9KS7k+jgpYAe+5w5xyG8mKJqK3Q/XffYg333nb6ePQQcYFLIoAorL7hK8eyX2/mw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=redhat.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=EJelJnn/JyXTdadjpJZBsKAweBrMvLSpqlwHLntWW68=;
 b=Lt2YkDrBi9OUx8AVqgHl2HHqi0DqV708IYDz5ShUfbAAUSgynR/8gTBIC5aVu+GG04Z+4seZ9uzmItHlMybwgBUUXcT9BxS88Lunhx4d4H+MiGv61x0xrZtxeuu4eNYN09VQf0zudroj7xMYmdNcUEL464/EqK9jwgQqzsXrxDRHdh+8WNurS6zG5/MRwqh5P3q+mSwryb1g1LoMB9NwuD2QvWXCTzFe/tRJjrTk4JQRmWimhYpQ6vwb9/qatHB6/33ASVF4tORov+2llc8hMplB9oZNb2qaWcv8rrUqYaro4abf6Fko58DwB/IVuDhxaUzbK9RjDIyGLRo/9+iRFg==
Received: from CH0PR03CA0208.namprd03.prod.outlook.com (2603:10b6:610:e4::33)
 by MN0PR12MB5979.namprd12.prod.outlook.com (2603:10b6:208:37e::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6813.19; Thu, 21 Sep
 2023 12:42:11 +0000
Received: from DS3PEPF000099D9.namprd04.prod.outlook.com
 (2603:10b6:610:e4:cafe::d3) by CH0PR03CA0208.outlook.office365.com
 (2603:10b6:610:e4::33) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6792.31 via Frontend
 Transport; Thu, 21 Sep 2023 12:42:11 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.161)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 DS3PEPF000099D9.mail.protection.outlook.com (10.167.17.10) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6792.19 via Frontend Transport; Thu, 21 Sep 2023 12:42:11 +0000
Received: from rnnvmail205.nvidia.com (10.129.68.10) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.41; Thu, 21 Sep
 2023 05:41:59 -0700
Received: from rnnvmail204.nvidia.com (10.129.68.6) by rnnvmail205.nvidia.com
 (10.129.68.10) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.41; Thu, 21 Sep
 2023 05:41:58 -0700
Received: from vdi.nvidia.com (10.127.8.10) by mail.nvidia.com (10.129.68.6)
 with Microsoft SMTP Server id 15.2.986.41 via Frontend Transport; Thu, 21 Sep
 2023 05:41:55 -0700
From:   Yishai Hadas <yishaih@nvidia.com>
To:     <alex.williamson@redhat.com>, <mst@redhat.com>,
        <jasowang@redhat.com>, <jgg@nvidia.com>
CC:     <kvm@vger.kernel.org>, <virtualization@lists.linux-foundation.org>,
        <parav@nvidia.com>, <feliu@nvidia.com>, <jiri@nvidia.com>,
        <kevin.tian@intel.com>, <joao.m.martins@oracle.com>,
        <leonro@nvidia.com>, <yishaih@nvidia.com>, <maorg@nvidia.com>
Subject: [PATCH vfio 09/11] vfio/pci: Expose vfio_pci_iowrite/read##size()
Date:   Thu, 21 Sep 2023 15:40:38 +0300
Message-ID: <20230921124040.145386-10-yishaih@nvidia.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20230921124040.145386-1-yishaih@nvidia.com>
References: <20230921124040.145386-1-yishaih@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-NV-OnPremToCloud: ExternallySecured
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS3PEPF000099D9:EE_|MN0PR12MB5979:EE_
X-MS-Office365-Filtering-Correlation-Id: 0f24e8f8-d919-44f6-9938-08dbbaa02cda
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Wz13dtetZ1aRPZGvRfvyGrnaeLodu6N4FZZFSL8v4MDX2woKieMMM8xwjyDkwk4j+7iFnh2PQYTOY9/WvhHpRNLysIL/6BkuQYKsFYFdb3Zs0QgTqFbx882rwdGkphzZULC/CUOUs8onKhYmaXITssx6bprDN52ao3m79ATbMj4jsFouxkYTVkjG7NW/D+Mf9d72NlqG3ZFTEzUkGHxtiPZJvRoVxp091s73FEXBXLGdcs/7JL+Z+Khu36Cbvyo5KETlbCnhJVHhSZOOrbtjp1Y9T9mnFQMb2dAxcZ3Y9QoWYVtNdL/OMOYMIpNZpkoL6j0eagaJ1WY4yhtkeWbrf6z9Wb+7YfSuPQL7NHw+Z9BSAOg7mYFYTrx7grHqc5rzZ0XSfO8DGnUecKIttkWxo3MLaS2oCGy//+6BgbZ+Oo9bnEbMnOJNnRKkAkN9gZue0AIrz5KVErzQz2oZIXJ8EoEfJLm9Feqp4iJFINePKNnY25uAdNS+GQsDAgVJpq5Yl7i/f4Xy536iHD2cqNfUOBCeVfbjo3kmemrTF4evwz50hjpQhH6zLllc2l8WgrTxD2rk6/iGomPXMfosdOBYiqvdjo+CP4OuhAKM1zI+Fg4ZE4V70k0K8LuzTaF3zM5QNOsiGI4SQa/eksknI2l5Fco61DjRoFXwJjUCTGRvenOCLldMw1NKOj8u61HCEwBzsr2husT7LjFg/iKpSfWdcli63vqTQIa/KZIMhik1i/wc/G8Ah8cp3tGtqI2NIASARPsGWlPRgVj2jxPTgXaVIw==
X-Forefront-Antispam-Report: CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230031)(4636009)(136003)(39860400002)(396003)(346002)(376002)(1800799009)(82310400011)(186009)(451199024)(46966006)(36840700001)(40470700004)(478600001)(6666004)(83380400001)(8936002)(8676002)(7696005)(70586007)(70206006)(54906003)(6636002)(316002)(110136005)(5660300002)(40460700003)(107886003)(1076003)(2616005)(36756003)(36860700001)(82740400003)(86362001)(40480700001)(4326008)(336012)(2906002)(47076005)(426003)(26005)(41300700001)(356005)(7636003)(2101003);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Sep 2023 12:42:11.1708
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 0f24e8f8-d919-44f6-9938-08dbbaa02cda
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DS3PEPF000099D9.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN0PR12MB5979
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_PASS,SPF_NONE,URIBL_BLOCKED
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Expose vfio_pci_iowrite/read##size() to let it be used by drivers.

This functionality is needed to enable direct access to some physical
BAR of the device with the proper locks/checks in place.

The next patches from this series will use this functionality on a data
path flow when a direct access to the BAR is needed.

Signed-off-by: Yishai Hadas <yishaih@nvidia.com>
---
 drivers/vfio/pci/vfio_pci_rdwr.c | 10 ++++++----
 include/linux/vfio_pci_core.h    | 19 +++++++++++++++++++
 2 files changed, 25 insertions(+), 4 deletions(-)

diff --git a/drivers/vfio/pci/vfio_pci_rdwr.c b/drivers/vfio/pci/vfio_pci_rdwr.c
index 6f08b3ecbb89..5d84bad7d30c 100644
--- a/drivers/vfio/pci/vfio_pci_rdwr.c
+++ b/drivers/vfio/pci/vfio_pci_rdwr.c
@@ -38,7 +38,7 @@
 #define vfio_iowrite8	iowrite8
 
 #define VFIO_IOWRITE(size) \
-static int vfio_pci_iowrite##size(struct vfio_pci_core_device *vdev,		\
+int vfio_pci_iowrite##size(struct vfio_pci_core_device *vdev,		\
 			bool test_mem, u##size val, void __iomem *io)	\
 {									\
 	if (test_mem) {							\
@@ -55,7 +55,8 @@ static int vfio_pci_iowrite##size(struct vfio_pci_core_device *vdev,		\
 		up_read(&vdev->memory_lock);				\
 									\
 	return 0;							\
-}
+}									\
+EXPORT_SYMBOL(vfio_pci_iowrite##size);
 
 VFIO_IOWRITE(8)
 VFIO_IOWRITE(16)
@@ -65,7 +66,7 @@ VFIO_IOWRITE(64)
 #endif
 
 #define VFIO_IOREAD(size) \
-static int vfio_pci_ioread##size(struct vfio_pci_core_device *vdev,		\
+int vfio_pci_ioread##size(struct vfio_pci_core_device *vdev,		\
 			bool test_mem, u##size *val, void __iomem *io)	\
 {									\
 	if (test_mem) {							\
@@ -82,7 +83,8 @@ static int vfio_pci_ioread##size(struct vfio_pci_core_device *vdev,		\
 		up_read(&vdev->memory_lock);				\
 									\
 	return 0;							\
-}
+}									\
+EXPORT_SYMBOL(vfio_pci_ioread##size);
 
 VFIO_IOREAD(8)
 VFIO_IOREAD(16)
diff --git a/include/linux/vfio_pci_core.h b/include/linux/vfio_pci_core.h
index 67ac58e20e1d..22c915317788 100644
--- a/include/linux/vfio_pci_core.h
+++ b/include/linux/vfio_pci_core.h
@@ -131,4 +131,23 @@ int vfio_pci_core_setup_barmap(struct vfio_pci_core_device *vdev, int bar);
 pci_ers_result_t vfio_pci_core_aer_err_detected(struct pci_dev *pdev,
 						pci_channel_state_t state);
 
+#define VFIO_IOWRITE_DECLATION(size) \
+int vfio_pci_iowrite##size(struct vfio_pci_core_device *vdev,		\
+			bool test_mem, u##size val, void __iomem *io);
+
+VFIO_IOWRITE_DECLATION(8)
+VFIO_IOWRITE_DECLATION(16)
+VFIO_IOWRITE_DECLATION(32)
+#ifdef iowrite64
+VFIO_IOWRITE_DECLATION(64)
+#endif
+
+#define VFIO_IOREAD_DECLATION(size) \
+int vfio_pci_ioread##size(struct vfio_pci_core_device *vdev,		\
+			bool test_mem, u##size *val, void __iomem *io);
+
+VFIO_IOREAD_DECLATION(8)
+VFIO_IOREAD_DECLATION(16)
+VFIO_IOREAD_DECLATION(32)
+
 #endif /* VFIO_PCI_CORE_H */
-- 
2.27.0

