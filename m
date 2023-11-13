Return-Path: <kvm+bounces-1577-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id EACDD7E9743
	for <lists+kvm@lfdr.de>; Mon, 13 Nov 2023 09:04:11 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 5B72D280D8E
	for <lists+kvm@lfdr.de>; Mon, 13 Nov 2023 08:04:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E21891A5A0;
	Mon, 13 Nov 2023 08:03:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="mzF5768r"
X-Original-To: kvm@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3E7A11A58D
	for <kvm@vger.kernel.org>; Mon, 13 Nov 2023 08:03:45 +0000 (UTC)
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2083.outbound.protection.outlook.com [40.107.94.83])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9838E10F4
	for <kvm@vger.kernel.org>; Mon, 13 Nov 2023 00:03:43 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=BzIlqyjgjPIdB6yt5CDiDqUyQPX0O7zXVV1gf3aYl6Thla73w8bpKXdHxUn/jwJgyG0qFg2qRsB1O9+Z4Sx3ppwCb8JV4oRLpC/bujHb7NpnPi+Q3Kg0nozDnpRTxp6KIuCjo06fBXCYGskMhP8n4Z+JWcMn/oNx4INP3Ml0qra2DopH9PRSliSZtNdbPOhIaBloPdSbxeoNfSDORPjXWIQOo+l4geGkmjXwQILuevBATMly0riygZb+pLL2evAnuMqxY0yjavbaX/n2krhTlHLGKmSbA+0kSDJIIpJl/s1OMUy+1klEUKF4dVTTSKhG7FvDsjFosk+GBYS5DpWl2A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=4ueIy9hp+yuSDFUn+Cwq4VZ9wxfooOvfEfsfqTWEOdw=;
 b=E8JyMuctXotieSEE+iH3q+IPMe3kbI5viRR9qFwVsHSYtObmJKLddZWrr0xX2Adcv/qPYv7pe3EoUFVFpAi4I1Qrw+WJzY3FDT73iPc/yk1R6ZKCNRtNNLnQYsnoLq9vQPts+SQeP3sXTmaGnWYAP+a0Gp4qbZIPCXyfOEC6aYCbUizRHgMFUpcovgIrYGe2r3GbVY59PGAFYeCSsdQjCATOATJ4J+BKJvNQnzaykqThbjfQmGTf1HclUqAQOk8iKAFyqQZ8jImi/xav0XIdIfL9An9+KWvIQvilXZmG7UcRaTMwrpWeqUyhPaA1fBablZhx1xTYyaFjQmLilW291g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.118.233) smtp.rcpttodomain=redhat.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4ueIy9hp+yuSDFUn+Cwq4VZ9wxfooOvfEfsfqTWEOdw=;
 b=mzF5768rlVwga+1Ipw7VphAWhePpZYba6Q7X6W/f3Co0Ga9MZfJELotQPwgVcIs2ewjmWkZ1ThcFSDa2wO2HOvsVcLzXM902aq4wlgGpYSPNJLvX20ElwSONehL+vFrKUvqmMofgSFH61vsF+KOg1aGSsIqLBk2h/wySg+l/eXY1skMWv9lfPzsay2/mOou2/wYHLfoY2zIYqIWetPy+g/x+NJoG3me2j64vzDJ4q8Qo3VBkjKSp1VDi3h/YjnGqcPOP0RvsRSBx65Un928hAYO5Y2UnkWg9ipeIuMhv1YpTKm7sCkBD8ZTL8qzIrmhcvUmAVTZH6Tt0a6HV5G2MQA==
Received: from MN2PR13CA0011.namprd13.prod.outlook.com (2603:10b6:208:160::24)
 by PH7PR12MB6720.namprd12.prod.outlook.com (2603:10b6:510:1b3::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6977.29; Mon, 13 Nov
 2023 08:03:39 +0000
Received: from BL02EPF0001A102.namprd05.prod.outlook.com
 (2603:10b6:208:160:cafe::95) by MN2PR13CA0011.outlook.office365.com
 (2603:10b6:208:160::24) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7002.15 via Frontend
 Transport; Mon, 13 Nov 2023 08:03:38 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.118.233)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.118.233 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.118.233; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.118.233) by
 BL02EPF0001A102.mail.protection.outlook.com (10.167.241.134) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.7002.13 via Frontend Transport; Mon, 13 Nov 2023 08:03:38 +0000
Received: from drhqmail201.nvidia.com (10.126.190.180) by mail.nvidia.com
 (10.127.129.6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.41; Mon, 13 Nov
 2023 00:03:29 -0800
Received: from drhqmail203.nvidia.com (10.126.190.182) by
 drhqmail201.nvidia.com (10.126.190.180) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.986.41; Mon, 13 Nov 2023 00:03:29 -0800
Received: from vdi.nvidia.com (10.127.8.10) by mail.nvidia.com
 (10.126.190.182) with Microsoft SMTP Server id 15.2.986.41 via Frontend
 Transport; Mon, 13 Nov 2023 00:03:25 -0800
From: Yishai Hadas <yishaih@nvidia.com>
To: <alex.williamson@redhat.com>, <mst@redhat.com>, <jasowang@redhat.com>,
	<jgg@nvidia.com>
CC: <kvm@vger.kernel.org>, <virtualization@lists.linux-foundation.org>,
	<parav@nvidia.com>, <feliu@nvidia.com>, <jiri@nvidia.com>,
	<kevin.tian@intel.com>, <joao.m.martins@oracle.com>, <si-wei.liu@oracle.com>,
	<leonro@nvidia.com>, <yishaih@nvidia.com>, <maorg@nvidia.com>
Subject: [PATCH V3 vfio 8/9] vfio/pci: Expose vfio_pci_iowrite/read##size()
Date: Mon, 13 Nov 2023 10:02:21 +0200
Message-ID: <20231113080222.91795-9-yishaih@nvidia.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20231113080222.91795-1-yishaih@nvidia.com>
References: <20231113080222.91795-1-yishaih@nvidia.com>
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
X-MS-TrafficTypeDiagnostic: BL02EPF0001A102:EE_|PH7PR12MB6720:EE_
X-MS-Office365-Filtering-Correlation-Id: 92aee18e-9777-478b-73ed-08dbe41f0b22
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	JkWkqCPT4eVmG3A7JkwWNrRLw307bGcr3tse9ri4GARXnbQPVwyBZqgYS+xVMmulA7EjcSV10xh15QW4KlPMnyiVyQuLrg3rUJxFR7286cs9/4LPe3hzTpy5QeryChJBFxPgFM+q+dg85Z+SD6T+S15I01PhpLb+FqrZsFvEndsRKcyh1r+hCHNdGMfClEHqW4oGD9+nWno9a6Dx3XDTZiqSy5kou6FQTSddnBbdmlpzoplFZ4GNRCIJwWlyOJypUPkps5Wel3WQVAW6l3pDeKso7TK+LRxrj7IBx5VS2Ho+EvAnUrE4hxW6P1RLEPYZobF+4uL+gsVSHXA/UyPhYWn/CfvzHcrFsTkomgFDHf1czQP4m6aJEXIZHiEYRbDwz6tWEgwQaGmTXRNOWAILt8XWszkyaupdgiOQUwxY1kruuXA8/0/waEROck4nwuZjGROXFT6I5BRak1DVn/G8qs4TGsDRjTEo7lxJPXt7V9sLa5V+xrgk7J5f/CNTmejeos0Cnrhsv9F5Fr+RiaGXYeJGKG6u2u3n+bjsWEVeNxwJeXZdjoBa27GFToQvAJj7lKIKTQrgC0b28PpkUCpXtq6dV8eZi3ZjP9GGfmgcvNbBVgeR/aCr0BGee5Y/l64XuVtVz/6Kqqg2RG+Kj0RRkq+yrOE7fvZclmTb6bt0C6bdPTx7fVDFOvq1rk9yJRmwVWhOnnkS1hskEiKcl/oQPB9IWs/rOI6WfrscPk1cCfQ8dAzL28VuMrpYAHs4REbC/4QRE5kSNvlXbNoB+Mzh3g==
X-Forefront-Antispam-Report:
	CIP:216.228.118.233;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc7edge2.nvidia.com;CAT:NONE;SFS:(13230031)(4636009)(376002)(346002)(136003)(39860400002)(396003)(230922051799003)(1800799009)(64100799003)(186009)(82310400011)(451199024)(46966006)(36840700001)(40470700004)(40460700003)(26005)(1076003)(107886003)(336012)(426003)(2616005)(7696005)(6666004)(36860700001)(83380400001)(47076005)(5660300002)(4326008)(8676002)(8936002)(41300700001)(2906002)(478600001)(316002)(6636002)(110136005)(54906003)(70206006)(70586007)(82740400003)(36756003)(86362001)(7636003)(356005)(40480700001)(2101003);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Nov 2023 08:03:38.3108
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 92aee18e-9777-478b-73ed-08dbe41f0b22
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.118.233];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BL02EPF0001A102.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB6720

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


