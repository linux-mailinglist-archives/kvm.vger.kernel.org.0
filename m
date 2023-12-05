Return-Path: <kvm+bounces-3607-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id A1391805ACC
	for <lists+kvm@lfdr.de>; Tue,  5 Dec 2023 18:08:23 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 41C561F21F72
	for <lists+kvm@lfdr.de>; Tue,  5 Dec 2023 17:08:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 035AC67E8E;
	Tue,  5 Dec 2023 17:07:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="IDdiam7n"
X-Original-To: kvm@vger.kernel.org
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2051.outbound.protection.outlook.com [40.107.220.51])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 50592A9
	for <kvm@vger.kernel.org>; Tue,  5 Dec 2023 09:07:51 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=KoeM02CHDNljI8b5DjhPi4AJZpn1nn9ktR7eqH7YEUeEZYYj/6qmlniUDJPMhBpIfO5SZYB2oCO2x8SruYZ2CzA7pW5+jLOklmJ3Uz11WX2i0PE5lLUhJzznMnlwIZWH9SCyip1qJtboYXQq5jQnA+bA0C01kX5E4d+eaDsnrhDn82mNdSHKAc3VP4WOKWVJH1E9Y5pzaJorUroMzWvQuVrru5Bg6eYx1Z595IDb1uagvX1ZmRrPssXXO2/WrM52oFuczuD0TQSUVBLqeCOitygqsFxd2Z9kzkcxlj9YUs7jaGmRlMD0+G60tHlYRasjEYukAweoBErFaSzapEKRSg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=xPNw5QdR76GyahpCO2xXCaRjqjcAOLXCu3+tQWQrNPo=;
 b=RiiTSeeTyxcohxrVGx5N4ArLuekFjBWykqN48UeTz0/K2onrTkbRzmjyO60d49D673WQLxTqKLv6z1pf2LzE+AT73SntZ3yzlX5xzvnqAwteh+SpKj9cBwUZiQqZRPaEQbGpJDismWy/MQ3z7KdfLL4ljhArRFbxcOX6z6ELTNvTLRycrcn9v/u7jwkQBT27LxwefhBdFnAiBuc/PEwdtglQM9VU1csdUimSILnzTDtbaFJCzpkR8/4TwpvesOV7esuoUZldNEIWiqUCkgAj7hxZmVXso/hyTX9AscgKa+Jd4xtgpdeTUzUzCZE5OnfpYJ99Atfxww+td8b626MkgA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=redhat.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xPNw5QdR76GyahpCO2xXCaRjqjcAOLXCu3+tQWQrNPo=;
 b=IDdiam7nJHuUwZRTp6aPitPWDmh0hoJKJnTAcMgyJl7JP9Pu+c8sgXVah2gs/olXS4arnH33yj5d/LvyZDGUJnhzZkQ6556jiKMcNMeCmhxoXgCF6X7gWFvj6+HdCEua6TKvuMieTMykSnNiVZil7u6fx09vshaBwCUH9i3NeyJcB5lNpYIC4OH/RZ2Edg7Z6+SoeoFZkuYvyITP5rodjyos5FB56Xw4GT2w7kyTNQ39btb8SsBMwacLAXZVix07OlHUHlUDs8qlQHnf4vyjCcCRT3iznHPBrLjMHyrZM3E4vFCefJZPvwCIZIiarjgTA7yf2wDpluO4pyE6wQp4LA==
Received: from MW4PR04CA0037.namprd04.prod.outlook.com (2603:10b6:303:6a::12)
 by SJ1PR12MB6098.namprd12.prod.outlook.com (2603:10b6:a03:45f::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7046.34; Tue, 5 Dec
 2023 17:07:47 +0000
Received: from CO1PEPF000044FC.namprd21.prod.outlook.com
 (2603:10b6:303:6a:cafe::58) by MW4PR04CA0037.outlook.office365.com
 (2603:10b6:303:6a::12) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7046.34 via Frontend
 Transport; Tue, 5 Dec 2023 17:07:47 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.160)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 CO1PEPF000044FC.mail.protection.outlook.com (10.167.241.202) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.7091.2 via Frontend Transport; Tue, 5 Dec 2023 17:07:47 +0000
Received: from rnnvmail203.nvidia.com (10.129.68.9) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.41; Tue, 5 Dec 2023
 09:07:29 -0800
Received: from rnnvmail202.nvidia.com (10.129.68.7) by rnnvmail203.nvidia.com
 (10.129.68.9) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.41; Tue, 5 Dec 2023
 09:07:28 -0800
Received: from vdi.nvidia.com (10.127.8.10) by mail.nvidia.com (10.129.68.7)
 with Microsoft SMTP Server id 15.2.986.41 via Frontend Transport; Tue, 5 Dec
 2023 09:07:25 -0800
From: Yishai Hadas <yishaih@nvidia.com>
To: <alex.williamson@redhat.com>, <mst@redhat.com>, <jasowang@redhat.com>,
	<jgg@nvidia.com>
CC: <kvm@vger.kernel.org>, <virtualization@lists.linux-foundation.org>,
	<parav@nvidia.com>, <feliu@nvidia.com>, <jiri@nvidia.com>,
	<kevin.tian@intel.com>, <joao.m.martins@oracle.com>, <si-wei.liu@oracle.com>,
	<leonro@nvidia.com>, <yishaih@nvidia.com>, <maorg@nvidia.com>
Subject: [PATCH V5 vfio 8/9] vfio/pci: Expose vfio_pci_core_iowrite/read##size()
Date: Tue, 5 Dec 2023 19:06:22 +0200
Message-ID: <20231205170623.197877-9-yishaih@nvidia.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20231205170623.197877-1-yishaih@nvidia.com>
References: <20231205170623.197877-1-yishaih@nvidia.com>
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
X-MS-TrafficTypeDiagnostic: CO1PEPF000044FC:EE_|SJ1PR12MB6098:EE_
X-MS-Office365-Filtering-Correlation-Id: 8da67795-a145-4cc7-7396-08dbf5b4b47b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	C7NZV05hmYVWSle53K4Rp1fiJyCb0o/rBdZpgqn1FuxQCyaeg4KXhDsIrr7p37s5m8VSzBti9wtjYJU5SStHPLLV1tAsfXhGsP/VMWwZcYBaxltfiNj8nIZ0DQeFIzY5Lxix+RuUSDXzz7MZX4JdFmP0rLLCrsAgwN49+A++jSKHjcpQzdwRHI6m8KG4MoJKRnTciuKFFzxx6n2CU9aB2jT+HhKCdvb5AXDA+FqxJiycg0SXf7dhCUGM/KmwbALSSaSc74I+aUX5ooNjkcBFNAjHwlkyyj7GB7d+nXPPNOAZeK48BwYczaDzV88A4NHO9MbPu5DKaylaXJ/3p9kn5E/HismnyXHytNiuj0/zS39eAz9Gh3j78IjjARSqILqoMJHV6zxuqrMlJho3e+9P6EEw1t7dCtk4adA3c3NNYe2ylah0egpwG6oj1sdmzIKicpFDBu5DIiCHqv0qqil/3fcrheiIlaPMMPhZkLWNESgXBH+LHlkG1edZ9uPtLHBchh7XKhyIO2H2BuI6M+ItkbTkjRU2eNVTp4CySa1P5aDNVQfxXUSajobRNh9WIfCXEgkFXH90WKC/rN26J2PVx59GMyiFvTV4v8BhZs65MH0kjcHpNMU1vQGdtFpgQ/adfv3UbWJ13hQRDe0YvQJGWoClHrVAb0THnBMUTY4HKWnQmSa4U3OmwNLW0jjsz7qU6K7d7Mcyfcsr2WC8G2XX5LAC7cNrbm9Ku1iHY0/pnooFCNvG2hgL87UlY5snoXu2gdDauAAkffANN3b3nVlAxg==
X-Forefront-Antispam-Report:
	CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230031)(4636009)(346002)(376002)(39860400002)(136003)(396003)(230922051799003)(451199024)(186009)(1800799012)(82310400011)(64100799003)(36840700001)(46966006)(40470700004)(40460700003)(426003)(336012)(26005)(83380400001)(7696005)(107886003)(2616005)(1076003)(36860700001)(47076005)(6666004)(41300700001)(8936002)(5660300002)(4326008)(8676002)(2906002)(6636002)(478600001)(316002)(54906003)(70586007)(110136005)(70206006)(86362001)(36756003)(356005)(7636003)(82740400003)(40480700001)(2101003);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Dec 2023 17:07:47.2402
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 8da67795-a145-4cc7-7396-08dbf5b4b47b
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CO1PEPF000044FC.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ1PR12MB6098

Expose vfio_pci_core_iowrite/read##size() to let it be used by drivers.

This functionality is needed to enable direct access to some physical
BAR of the device with the proper locks/checks in place.

The next patches from this series will use this functionality on a data
path flow when a direct access to the BAR is needed.

Signed-off-by: Yishai Hadas <yishaih@nvidia.com>
---
 drivers/vfio/pci/vfio_pci_rdwr.c | 46 +++++++++++++++++---------------
 include/linux/vfio_pci_core.h    | 19 +++++++++++++
 2 files changed, 43 insertions(+), 22 deletions(-)

diff --git a/drivers/vfio/pci/vfio_pci_rdwr.c b/drivers/vfio/pci/vfio_pci_rdwr.c
index a9887fd6de46..448ee90a3bb1 100644
--- a/drivers/vfio/pci/vfio_pci_rdwr.c
+++ b/drivers/vfio/pci/vfio_pci_rdwr.c
@@ -38,7 +38,7 @@
 #define vfio_iowrite8	iowrite8
 
 #define VFIO_IOWRITE(size) \
-static int vfio_pci_iowrite##size(struct vfio_pci_core_device *vdev,		\
+int vfio_pci_core_iowrite##size(struct vfio_pci_core_device *vdev,	\
 			bool test_mem, u##size val, void __iomem *io)	\
 {									\
 	if (test_mem) {							\
@@ -55,7 +55,8 @@ static int vfio_pci_iowrite##size(struct vfio_pci_core_device *vdev,		\
 		up_read(&vdev->memory_lock);				\
 									\
 	return 0;							\
-}
+}									\
+EXPORT_SYMBOL_GPL(vfio_pci_core_iowrite##size);
 
 VFIO_IOWRITE(8)
 VFIO_IOWRITE(16)
@@ -65,7 +66,7 @@ VFIO_IOWRITE(64)
 #endif
 
 #define VFIO_IOREAD(size) \
-static int vfio_pci_ioread##size(struct vfio_pci_core_device *vdev,		\
+int vfio_pci_core_ioread##size(struct vfio_pci_core_device *vdev,	\
 			bool test_mem, u##size *val, void __iomem *io)	\
 {									\
 	if (test_mem) {							\
@@ -82,7 +83,8 @@ static int vfio_pci_ioread##size(struct vfio_pci_core_device *vdev,		\
 		up_read(&vdev->memory_lock);				\
 									\
 	return 0;							\
-}
+}									\
+EXPORT_SYMBOL_GPL(vfio_pci_core_ioread##size);
 
 VFIO_IOREAD(8)
 VFIO_IOREAD(16)
@@ -119,13 +121,13 @@ static ssize_t do_io_rw(struct vfio_pci_core_device *vdev, bool test_mem,
 				if (copy_from_user(&val, buf, 4))
 					return -EFAULT;
 
-				ret = vfio_pci_iowrite32(vdev, test_mem,
-							 val, io + off);
+				ret = vfio_pci_core_iowrite32(vdev, test_mem,
+							      val, io + off);
 				if (ret)
 					return ret;
 			} else {
-				ret = vfio_pci_ioread32(vdev, test_mem,
-							&val, io + off);
+				ret = vfio_pci_core_ioread32(vdev, test_mem,
+							     &val, io + off);
 				if (ret)
 					return ret;
 
@@ -141,13 +143,13 @@ static ssize_t do_io_rw(struct vfio_pci_core_device *vdev, bool test_mem,
 				if (copy_from_user(&val, buf, 2))
 					return -EFAULT;
 
-				ret = vfio_pci_iowrite16(vdev, test_mem,
-							 val, io + off);
+				ret = vfio_pci_core_iowrite16(vdev, test_mem,
+							      val, io + off);
 				if (ret)
 					return ret;
 			} else {
-				ret = vfio_pci_ioread16(vdev, test_mem,
-							&val, io + off);
+				ret = vfio_pci_core_ioread16(vdev, test_mem,
+							     &val, io + off);
 				if (ret)
 					return ret;
 
@@ -163,13 +165,13 @@ static ssize_t do_io_rw(struct vfio_pci_core_device *vdev, bool test_mem,
 				if (copy_from_user(&val, buf, 1))
 					return -EFAULT;
 
-				ret = vfio_pci_iowrite8(vdev, test_mem,
-							val, io + off);
+				ret = vfio_pci_core_iowrite8(vdev, test_mem,
+							     val, io + off);
 				if (ret)
 					return ret;
 			} else {
-				ret = vfio_pci_ioread8(vdev, test_mem,
-						       &val, io + off);
+				ret = vfio_pci_core_ioread8(vdev, test_mem,
+							    &val, io + off);
 				if (ret)
 					return ret;
 
@@ -364,16 +366,16 @@ static void vfio_pci_ioeventfd_do_write(struct vfio_pci_ioeventfd *ioeventfd,
 {
 	switch (ioeventfd->count) {
 	case 1:
-		vfio_pci_iowrite8(ioeventfd->vdev, test_mem,
-				  ioeventfd->data, ioeventfd->addr);
+		vfio_pci_core_iowrite8(ioeventfd->vdev, test_mem,
+				       ioeventfd->data, ioeventfd->addr);
 		break;
 	case 2:
-		vfio_pci_iowrite16(ioeventfd->vdev, test_mem,
-				   ioeventfd->data, ioeventfd->addr);
+		vfio_pci_core_iowrite16(ioeventfd->vdev, test_mem,
+					ioeventfd->data, ioeventfd->addr);
 		break;
 	case 4:
-		vfio_pci_iowrite32(ioeventfd->vdev, test_mem,
-				   ioeventfd->data, ioeventfd->addr);
+		vfio_pci_core_iowrite32(ioeventfd->vdev, test_mem,
+					ioeventfd->data, ioeventfd->addr);
 		break;
 #ifdef iowrite64
 	case 8:
diff --git a/include/linux/vfio_pci_core.h b/include/linux/vfio_pci_core.h
index 67ac58e20e1d..85e84b92751b 100644
--- a/include/linux/vfio_pci_core.h
+++ b/include/linux/vfio_pci_core.h
@@ -131,4 +131,23 @@ int vfio_pci_core_setup_barmap(struct vfio_pci_core_device *vdev, int bar);
 pci_ers_result_t vfio_pci_core_aer_err_detected(struct pci_dev *pdev,
 						pci_channel_state_t state);
 
+#define VFIO_IOWRITE_DECLATION(size) \
+int vfio_pci_core_iowrite##size(struct vfio_pci_core_device *vdev,	\
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
+int vfio_pci_core_ioread##size(struct vfio_pci_core_device *vdev,	\
+			bool test_mem, u##size *val, void __iomem *io);
+
+VFIO_IOREAD_DECLATION(8)
+VFIO_IOREAD_DECLATION(16)
+VFIO_IOREAD_DECLATION(32)
+
 #endif /* VFIO_PCI_CORE_H */
-- 
2.27.0


