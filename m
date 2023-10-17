Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 81D957CC502
	for <lists+kvm@lfdr.de>; Tue, 17 Oct 2023 15:43:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343896AbjJQNnk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 17 Oct 2023 09:43:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35018 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343910AbjJQNnj (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 17 Oct 2023 09:43:39 -0400
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2066.outbound.protection.outlook.com [40.107.243.66])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 72F8CED
        for <kvm@vger.kernel.org>; Tue, 17 Oct 2023 06:43:36 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=kK6UEODU6iKJvNmHY+9uFeEIru0mP37xj6bh5neNX1zYyXWjYJuQc8vVDBdiIdG9Tvm7ZxrOYWDFL6+XSGma3XlYqirr1Hij8OLiG+p5nVkqJo9HPURxubdXjpS7fu44Rhr3all7S2pFJMFTtz6EH9f2R0nTGX5EkwYk0/bOWkwBe+NJSRiFa/R8KJ8AJ3V1yHJ/vGrqHfRtcaU8/zZRKssuZKhvBGSPjbv7d3wlfYo07wFYXkUKDxNh1osfXeHdykmJbghkU19IuQrkSAMbtw8fFbBGB2kdTy86+cJG/PtOeUJmChzLrcwoEfKbgzzRmN0vo5nyCor6b+L/nGaW+Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=4ueIy9hp+yuSDFUn+Cwq4VZ9wxfooOvfEfsfqTWEOdw=;
 b=V7He+MqMZMsPS3onkDXAv1wH2grmEuN7UfHrTtTIjxekEjVZ7mpFirEWKRI4GiiXsUxy9lFJ843COtGCLZzJP8EMdnY99L0QHzH0jo8OWiCsld4JcU4QU7Z2loPUa0hK06P++27TtJijDeMnASEg49+7zFcg0jDxVAbE5L0g4oqofNZR3kgKuxiYEdYM0D++mF/+6dHJ+UapziU5nDckPRda6zKUZ+mXXzoDSaEQSu8FB7tc6hsL4XbuUcChzhFiU5Wn3ChXI1PsK98uyEUGItWtlcCo0JX4tRPKKWR305Phff8JZvWLYxEJx0xRwBuOpEkuwf/MsfmAEw7/dgVWxw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=redhat.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4ueIy9hp+yuSDFUn+Cwq4VZ9wxfooOvfEfsfqTWEOdw=;
 b=D/XTlSNdfHFS+2aitWUPZaXmyHo1gnJRL2joTRwMS6OEBzLmtwk3fmEmBh46sqPHKVobWmqFKSOjO1Qfyw0sjhznEUW7W3YOKA0IOxDeW0VxsDbOUp88UTKE4Q59Egv2lXPuWvWWebhaa1gkhTCdrl2fZesAKtVzTDPv8WBWzYnCXYhd7e3PXseGsn9vLxUsfO7NCLh6IoF//dt6k6mbdcIWGfzvBac59TDeZufXhgIFvjooypJi+4uPgb1uH0Lz3UnAp/JQkshzy4WqkKLeIICjR1s9YKtydsvapKHpY4/WV9UtscvK68S6MNxJwC5m7SdOZM60ZVic+LcsCPbXcA==
Received: from SA0PR13CA0008.namprd13.prod.outlook.com (2603:10b6:806:130::13)
 by DS0PR12MB8366.namprd12.prod.outlook.com (2603:10b6:8:f9::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6886.35; Tue, 17 Oct
 2023 13:43:32 +0000
Received: from SA2PEPF00001508.namprd04.prod.outlook.com
 (2603:10b6:806:130:cafe::fb) by SA0PR13CA0008.outlook.office365.com
 (2603:10b6:806:130::13) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6907.18 via Frontend
 Transport; Tue, 17 Oct 2023 13:43:32 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.160)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 SA2PEPF00001508.mail.protection.outlook.com (10.167.242.40) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6907.20 via Frontend Transport; Tue, 17 Oct 2023 13:43:32 +0000
Received: from rnnvmail203.nvidia.com (10.129.68.9) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.41; Tue, 17 Oct
 2023 06:43:14 -0700
Received: from rnnvmail205.nvidia.com (10.129.68.10) by rnnvmail203.nvidia.com
 (10.129.68.9) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.41; Tue, 17 Oct
 2023 06:43:14 -0700
Received: from vdi.nvidia.com (10.127.8.10) by mail.nvidia.com (10.129.68.10)
 with Microsoft SMTP Server id 15.2.986.41 via Frontend Transport; Tue, 17 Oct
 2023 06:43:10 -0700
From:   Yishai Hadas <yishaih@nvidia.com>
To:     <alex.williamson@redhat.com>, <mst@redhat.com>,
        <jasowang@redhat.com>, <jgg@nvidia.com>
CC:     <kvm@vger.kernel.org>, <virtualization@lists.linux-foundation.org>,
        <parav@nvidia.com>, <feliu@nvidia.com>, <jiri@nvidia.com>,
        <kevin.tian@intel.com>, <joao.m.martins@oracle.com>,
        <si-wei.liu@oracle.com>, <leonro@nvidia.com>, <yishaih@nvidia.com>,
        <maorg@nvidia.com>
Subject: [PATCH V1 vfio 8/9] vfio/pci: Expose vfio_pci_iowrite/read##size()
Date:   Tue, 17 Oct 2023 16:42:16 +0300
Message-ID: <20231017134217.82497-9-yishaih@nvidia.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20231017134217.82497-1-yishaih@nvidia.com>
References: <20231017134217.82497-1-yishaih@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-NV-OnPremToCloud: ExternallySecured
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA2PEPF00001508:EE_|DS0PR12MB8366:EE_
X-MS-Office365-Filtering-Correlation-Id: fe720352-7dab-450d-08b4-08dbcf170dc4
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: PzyYS0fZWDn0wWvaN5pP3ItCxewfXXZDFAcNapxF/GA85eXKWaoOAZsFw3GJgK8KM+uOGrj1n58LKHilVLYnr6D4cfk7TP8iAmDYqvprF7e6v8Tk5RiC9rygUVG7XGPSpqjskBD0mDRhp/Elqleh6G7hlhxtRJkc2Qbmi2WhvB+LbfZP3aIcbuyBvt2D3MoAn+Lyt9q5qGYV9N6lN33xzmayY1LGqgaFPC6HpBblTVE2fyM2KwU4KZcOxjnhCc/r5P19p8PNKE2CtXq5qPn7lnKhfSxG0pqbSEA+e4ZdIAAQtqbvkyCvg3NeW5RAefD/IZm57cdw2br+2ryZt0Xc9Ohw9lf2VF/jXWCAIXKmmt5B4qO7/llsvBWvexNHiyY/w72JSwWVz96n+FgJb6FdTrg33hzK2oEfA9NLr1Zre6qKq6FHcaks4Ii7Dl/BYMNhWnS4usOToJUbT7iKBj5rxDdxQ3i3eFvHFh8MPurXNyzacFgk00gAY1W/xiEoFwas2GDDG9dUh2BCueuWaqRbxdXkPA4EJI3OrDvYSvOjvn++TlWMeeWfqfuS6a/MaQiRb1Ltbpl1WJ6u7jD3jGDThqlExK9fmjJwHKURw0kzuFUzYnUl6VsbN3TN1iZ+XC/PztIMAXu9NIztv5ATmRy4E59TudEoRNCx92zrTvXhHZsqc39RAnaqeCGFCu/HpeFUC79afERdaIBdPhQERaGzrL2PE7Yg4crMDPNZrGZnBT+izGWGZTvt2UTCTcVKEm/PWrVGQIgerlkcEjqJf55Olw==
X-Forefront-Antispam-Report: CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230031)(4636009)(346002)(39860400002)(396003)(376002)(136003)(230922051799003)(451199024)(64100799003)(82310400011)(186009)(1800799009)(36840700001)(40470700004)(46966006)(336012)(40480700001)(40460700003)(82740400003)(36756003)(356005)(47076005)(83380400001)(36860700001)(7636003)(26005)(7696005)(2906002)(54906003)(316002)(6636002)(70206006)(1076003)(426003)(2616005)(70586007)(478600001)(107886003)(110136005)(86362001)(41300700001)(8936002)(8676002)(4326008)(5660300002)(2101003);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Oct 2023 13:43:32.3643
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: fe720352-7dab-450d-08b4-08dbcf170dc4
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: SA2PEPF00001508.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR12MB8366
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
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
index 6f08b3ecbb89..817ec9a89123 100644
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
+EXPORT_SYMBOL_GPL(vfio_pci_iowrite##size);
 
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
+EXPORT_SYMBOL_GPL(vfio_pci_ioread##size);
 
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

