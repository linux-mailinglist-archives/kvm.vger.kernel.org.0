Return-Path: <kvm+bounces-8851-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 5A0CA8573E3
	for <lists+kvm@lfdr.de>; Fri, 16 Feb 2024 04:02:17 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 78F12B2413E
	for <lists+kvm@lfdr.de>; Fri, 16 Feb 2024 03:02:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8B9961095A;
	Fri, 16 Feb 2024 03:01:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="h1l8C48O"
X-Original-To: kvm@vger.kernel.org
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2046.outbound.protection.outlook.com [40.107.244.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 11D03FBF7;
	Fri, 16 Feb 2024 03:01:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.244.46
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708052516; cv=fail; b=XLip8OivZMUKf33zNoICuTZG+llFU9tYaDG5Qwa549zsiS7r8+Y3MiVa/VxYKsh77+XnDxhKGNPDUWT68btTVoBXaozpw906whaSiU2w3he4EpNdCIJHq/2/Wm2RwThIvGKdCcNs+cV7X+U1D6emcC7EW97LjRiJtm7m4m07LKQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708052516; c=relaxed/simple;
	bh=CeeEx7kwun80sSlTCVImKxwqcBRFgRwX3yWP/egGzE0=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=t84IrbxG86PhB0m7vE75d5lgZX5X3RemhpRGMWWV6c7lMttYbMhplfqu/woE+kJCB5qjXnH84Yz8Jc4oouenoVwon4um9HbLFxbcnIF1uZSpGRFrhcS6ocRyOthS0pNJvEhpfEsAXicLDQDhsc/zlqb005/XCK4WqCfO+ak/SQ4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=h1l8C48O; arc=fail smtp.client-ip=40.107.244.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Sfp5Rj5cjP2Ce0eXajEmA2fvYlsCsSVMkFRuWFDnYuEt2CSsfFN9jpg7h9Y+k+1ZFrblxBCViiMmRvwC2F7gKoi/iDQOXunH+Rz1aigRKIrPmdrTmeZ+hu/GToG4jkHPQ+HtjPpE39PfGNBpBNb6jOI4xzseU6D8inUZS/y8jNd3bflsMfOxVP3KFa/f66t6wi9Pv+EQawbULiKlIOueBw5uTy5acDUSf0MX0PDBudc6EqMnBB2TnWcmLIdv4aUrRKslXTUyVPKaWOLWVwe9Mn6Q41v5skHIVDezuSUvo00788MLo1joejg3Q+j6hjgPrRlNAtu0zmnqCmcPtPn2QA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Vy67KIk2U4bG+jefgEJKzRYEhIgWJ5vXPnO556ROweo=;
 b=Dhr0qlOJt9jf2wD+8UI5qMMfqk/yxlRFbSllHDPBn+Wr8/zpfdZgABm24jsDuObbnyzMUj/BxpmGO/t+0aLAg+qf/zpiYxnVyLz/YPfFWZ4+EeUJE57OXMrz0YFe8WQFURyhdmg22ON49z3Xztk4+gohIS4ccd2XoV4zWkFSU9y61kseC3Lr75ReYJX1irJ4wJMyESjPmgd0wCXCkLxoSJtEC6M7MKo3YOzSh0Wa64+0RGyKEMLfjLPzP8qhX0vwxDHdkA5TfKMTLBltUCW/azguhvTwclYsnEK+fJMJdQ+NdZcdlSahMSTfrj3V2iArAXW/P4j/cJI1NUwBSnCKSQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.118.233) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Vy67KIk2U4bG+jefgEJKzRYEhIgWJ5vXPnO556ROweo=;
 b=h1l8C48OH35BO0YnY2ZWxTvKEkBUQM+sbqYOUtQl2UWWNRu3PdAwIqJDfjbPZq+tUckwNZxAvaxPa5mQnJcxdRy3/hP1OotO8qZ8eesz/bF/oArcO6RWIJkkj14gFWqXnsooSFHAtKYwx4oXxt2xcrZ7GjC5Faae+FlJnQnK0arhJP4vpRHgOYp2Q6aH1nhyQjJOzN+badmnZ4vBB40SRRkkDUmKgnBBaSSWY542pnKI4CsZvrpJnLmOToTu8dFQq0Snh3e9P//QSz7b+IjT1ZC3KmEKJZjev4T6P5yScIYZMsRjCgKs+80B6a+KUWAR8zJqqfr9eUo6kCWhjLn+Gw==
Received: from BN7PR06CA0048.namprd06.prod.outlook.com (2603:10b6:408:34::25)
 by SA1PR12MB7317.namprd12.prod.outlook.com (2603:10b6:806:2ba::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7316.14; Fri, 16 Feb
 2024 03:01:52 +0000
Received: from BN3PEPF0000B06C.namprd21.prod.outlook.com
 (2603:10b6:408:34:cafe::d3) by BN7PR06CA0048.outlook.office365.com
 (2603:10b6:408:34::25) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7270.41 via Frontend
 Transport; Fri, 16 Feb 2024 03:01:52 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.118.233)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.118.233 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.118.233; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.118.233) by
 BN3PEPF0000B06C.mail.protection.outlook.com (10.167.243.71) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.7316.0 via Frontend Transport; Fri, 16 Feb 2024 03:01:52 +0000
Received: from drhqmail203.nvidia.com (10.126.190.182) by mail.nvidia.com
 (10.127.129.6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.41; Thu, 15 Feb
 2024 19:01:45 -0800
Received: from drhqmail202.nvidia.com (10.126.190.181) by
 drhqmail203.nvidia.com (10.126.190.182) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1258.12; Thu, 15 Feb 2024 19:01:45 -0800
Received: from sgarnayak-dt.nvidia.com (10.127.8.9) by mail.nvidia.com
 (10.126.190.181) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1258.12 via Frontend
 Transport; Thu, 15 Feb 2024 19:01:38 -0800
From: <ankita@nvidia.com>
To: <ankita@nvidia.com>, <jgg@nvidia.com>, <alex.williamson@redhat.com>,
	<yishaih@nvidia.com>, <shameerali.kolothum.thodi@huawei.com>,
	<kevin.tian@intel.com>, <mst@redhat.com>, <eric.auger@redhat.com>,
	<jgg@ziepe.ca>, <oleksandr@natalenko.name>, <clg@redhat.com>,
	<satyanarayana.k.v.p@intel.com>, <brett.creeley@amd.com>, <horms@kernel.org>,
	<shannon.nelson@amd.com>
CC: <aniketa@nvidia.com>, <cjia@nvidia.com>, <kwankhede@nvidia.com>,
	<targupta@nvidia.com>, <vsethi@nvidia.com>, <acurrid@nvidia.com>,
	<apopple@nvidia.com>, <jhubbard@nvidia.com>, <danw@nvidia.com>,
	<anuaggarwal@nvidia.com>, <mochs@nvidia.com>, <kvm@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>, <virtualization@lists.linux-foundation.org>
Subject: [PATCH v18 1/3] vfio/pci: rename and export do_io_rw()
Date: Fri, 16 Feb 2024 08:31:26 +0530
Message-ID: <20240216030128.29154-2-ankita@nvidia.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20240216030128.29154-1-ankita@nvidia.com>
References: <20240216030128.29154-1-ankita@nvidia.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
X-NV-OnPremToCloud: ExternallySecured
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN3PEPF0000B06C:EE_|SA1PR12MB7317:EE_
X-MS-Office365-Filtering-Correlation-Id: 258646a4-7bdb-4194-1d02-08dc2e9ba07d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	OC72srW4X7yRqtZCpAJ7dNp2sECDXeteRaifTUjR1DA5mOxheBhAqreyxysKTBDWtZmpRDqulLhmzYhfz9QL8u+CHA/NNl4jXme8SqJTjLOp5aZPszc0tt0XSvfG3reM1H3xuu195mxf1OTZIvfAoNuxOuMgH3/LU8d8CIzapvfsZi/m/6xG24Y59z69qxMLGXaSuUiuLh8toheLuf8CzoW5WLZAV1sIa9RNfOZUwkryZ9NI9ri9Zk1rYjpfMUUPSkKPN1gsGVAxLvTEATiOreqH8AOXcCTwDjumbGAQ4cN2vqW1ODh65JjHnZgNMfhdSRpxcFl/PnlEYatInmMLniFx+4bdJmEYrsjfQpffE58qkJxLFhSx5jVssnfSGw0fgx21M5cn66LwDazJFWBs1JqRauUHa+F5vxg00mKoPozh6nJKZ2REah2GhyRDlzZsiJiKPeIZdxPmq7IitFTcCSWS/poH6A9+wPAenKLz9brsA0g386afxnvSPKnYrAXOLDp6bkgOwLH+bpW48S5XDlA/qboxoFSrqUO1dxA1bh8NVo/ve9C8S9+jpPCsVL9Vx+VNuSP8CTQ35doz8XRTVDzCjXP3iqInPHBq1Se4xnLJ48OH4G6qTS2OQGlulvgKqKKQ3BFVBi+AWMYBMkqqxysSngUEJ3ZspPj7iZJ9sUg=
X-Forefront-Antispam-Report:
	CIP:216.228.118.233;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc7edge2.nvidia.com;CAT:NONE;SFS:(13230031)(4636009)(346002)(136003)(376002)(39860400002)(396003)(230922051799003)(82310400011)(451199024)(186009)(64100799003)(1800799012)(36860700004)(40470700004)(46966006)(7416002)(5660300002)(2876002)(2906002)(426003)(336012)(26005)(41300700001)(1076003)(2616005)(8936002)(8676002)(70586007)(70206006)(4326008)(83380400001)(921011)(6666004)(316002)(110136005)(478600001)(7696005)(54906003)(82740400003)(86362001)(36756003)(7636003)(356005);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Feb 2024 03:01:52.5099
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 258646a4-7bdb-4194-1d02-08dc2e9ba07d
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.118.233];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BN3PEPF0000B06C.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR12MB7317

From: Ankit Agrawal <ankita@nvidia.com>

do_io_rw() is used to read/write to the device MMIO. The grace hopper
VFIO PCI variant driver require this functionality to read/write to
its memory.

Rename this as vfio_pci_core functions and export as GPL.

Reviewed-by: Kevin Tian <kevin.tian@intel.com>
Signed-off-by: Ankit Agrawal <ankita@nvidia.com>
---
 drivers/vfio/pci/vfio_pci_rdwr.c | 16 +++++++++-------
 include/linux/vfio_pci_core.h    |  5 ++++-
 2 files changed, 13 insertions(+), 8 deletions(-)

diff --git a/drivers/vfio/pci/vfio_pci_rdwr.c b/drivers/vfio/pci/vfio_pci_rdwr.c
index 07fea08ea8a2..03b8f7ada1ac 100644
--- a/drivers/vfio/pci/vfio_pci_rdwr.c
+++ b/drivers/vfio/pci/vfio_pci_rdwr.c
@@ -96,10 +96,10 @@ VFIO_IOREAD(32)
  * reads with -1.  This is intended for handling MSI-X vector tables and
  * leftover space for ROM BARs.
  */
-static ssize_t do_io_rw(struct vfio_pci_core_device *vdev, bool test_mem,
-			void __iomem *io, char __user *buf,
-			loff_t off, size_t count, size_t x_start,
-			size_t x_end, bool iswrite)
+ssize_t vfio_pci_core_do_io_rw(struct vfio_pci_core_device *vdev, bool test_mem,
+			       void __iomem *io, char __user *buf,
+			       loff_t off, size_t count, size_t x_start,
+			       size_t x_end, bool iswrite)
 {
 	ssize_t done = 0;
 	int ret;
@@ -201,6 +201,7 @@ static ssize_t do_io_rw(struct vfio_pci_core_device *vdev, bool test_mem,
 
 	return done;
 }
+EXPORT_SYMBOL_GPL(vfio_pci_core_do_io_rw);
 
 int vfio_pci_core_setup_barmap(struct vfio_pci_core_device *vdev, int bar)
 {
@@ -279,8 +280,8 @@ ssize_t vfio_pci_bar_rw(struct vfio_pci_core_device *vdev, char __user *buf,
 		x_end = vdev->msix_offset + vdev->msix_size;
 	}
 
-	done = do_io_rw(vdev, res->flags & IORESOURCE_MEM, io, buf, pos,
-			count, x_start, x_end, iswrite);
+	done = vfio_pci_core_do_io_rw(vdev, res->flags & IORESOURCE_MEM, io, buf, pos,
+				      count, x_start, x_end, iswrite);
 
 	if (done >= 0)
 		*ppos += done;
@@ -348,7 +349,8 @@ ssize_t vfio_pci_vga_rw(struct vfio_pci_core_device *vdev, char __user *buf,
 	 * probing, so we don't currently worry about access in relation
 	 * to the memory enable bit in the command register.
 	 */
-	done = do_io_rw(vdev, false, iomem, buf, off, count, 0, 0, iswrite);
+	done = vfio_pci_core_do_io_rw(vdev, false, iomem, buf, off, count,
+				      0, 0, iswrite);
 
 	vga_put(vdev->pdev, rsrc);
 
diff --git a/include/linux/vfio_pci_core.h b/include/linux/vfio_pci_core.h
index 85e84b92751b..cf9480a31f3e 100644
--- a/include/linux/vfio_pci_core.h
+++ b/include/linux/vfio_pci_core.h
@@ -130,7 +130,10 @@ void vfio_pci_core_finish_enable(struct vfio_pci_core_device *vdev);
 int vfio_pci_core_setup_barmap(struct vfio_pci_core_device *vdev, int bar);
 pci_ers_result_t vfio_pci_core_aer_err_detected(struct pci_dev *pdev,
 						pci_channel_state_t state);
-
+ssize_t vfio_pci_core_do_io_rw(struct vfio_pci_core_device *vdev, bool test_mem,
+			       void __iomem *io, char __user *buf,
+			       loff_t off, size_t count, size_t x_start,
+			       size_t x_end, bool iswrite);
 #define VFIO_IOWRITE_DECLATION(size) \
 int vfio_pci_core_iowrite##size(struct vfio_pci_core_device *vdev,	\
 			bool test_mem, u##size val, void __iomem *io);
-- 
2.34.1


