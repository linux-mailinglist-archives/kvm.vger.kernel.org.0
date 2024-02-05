Return-Path: <kvm+bounces-8055-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id C9C3284AA2E
	for <lists+kvm@lfdr.de>; Tue,  6 Feb 2024 00:03:42 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 451771F2B759
	for <lists+kvm@lfdr.de>; Mon,  5 Feb 2024 23:03:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 63FC34E1C3;
	Mon,  5 Feb 2024 23:01:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="FRffR468"
X-Original-To: kvm@vger.kernel.org
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2041.outbound.protection.outlook.com [40.107.236.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A00374D117;
	Mon,  5 Feb 2024 23:01:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.236.41
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707174116; cv=fail; b=iuzCgqC59jl+irKF8EcoCMA5pK26Y8lnIjF6K3UiTTJnmrce60vw15wYmkpJ8pvjVkI662HEqfUBUgysHQ6ikS/f3/SpdZLqCVYSiZl5+K0bQ7oWleNG4p2CK9BUgfFQ6vavKKHg6NGLPp0iebybUsTG9u/jLOSzHh90mvs4Apo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707174116; c=relaxed/simple;
	bh=owwjcoGGStmN63lXGjH/eV80f59La9EvgXlI/QDXEjk=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=QmRmPi6oGw5xaiSosHWoPIGDjQn2d9acy9rLJWQRxrosanoTn5jUXt5ozm8+0iqch25yydDU1VyF1vzgsCfoukDBhdWKuapy+qibyhRkPgjUl+jcGcAmBnoAqVcghBQp3gyhjIVvNP5Zxpl4pxxNdxY58Vjipo8egWB2wqFhlzs=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=FRffR468; arc=fail smtp.client-ip=40.107.236.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Nqt0raxZHGjpq7iMwqTeg2uVZ9CL9BF6CuXmOmuau7CzXpwfJ2IgViI/wfoeCMugoYWhKr52yu+lm728aQxA2jxmLl89iInvhhJS7Mro+dgPZDN56qGGAfdCLi8cy71dnma8M96w4bJbOaxCbpr6RXq9ifz+Ibo577z6QOIXi5HJ2vCz6CImGCNijKLAFMFyPdMFmRBxxY3gnq8b+/kMpjn2+bDUE5T8QikOybsCxx7wKm2jQ/xS0XIOm94Qie7EcFQSNIDDpVG9SdB3lMtGOzrKJYiTirzkzso1GrLnRBtPcOazdDkGULt29jZyEl/Nn1qnf96MqbMsVuumk7DGbQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ukLiNMdzJRJ3xKT6ABQY+BTldfZjLmnOQ8mHhXsEyaM=;
 b=lJsi+GarPgTH1VancWMCJrmPC6qYdM2oDO42Mf6lv/OJbtmnUsHnOkBjlwtKdtQ65Kyy2Leq+4CIzI+h+3uYyvADdTv805v25iKnKm8OLPPtS6Dpzg2iint8dqcI1dbOH1skhHO1NeqLNAlPz6QHTzm5u4ctr2m5Vzqr/eWTd9toIygbmZaMhCq4dH+lrOQFD5nzx14nBpQuloWGyZzOokRslw215FrAhMJmV8ndzyJdHdq6n9oD5RtMcv4D1LXgj4VNkhJGChy4d3df9iAu6Q2NX3rLfkb8VxK8bGrEAa0SxsF8PSdgHozn0YtPgFmuEQK4HCK+nVGjFpYuiQOXAQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.118.232) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ukLiNMdzJRJ3xKT6ABQY+BTldfZjLmnOQ8mHhXsEyaM=;
 b=FRffR468TyCUQlcRf4ytZf8njZo+NUq8AVVDJ0ZXWF6y+s2kLuyFjPvuVrXF4QMCD45BzWwCij88sVw0/Nin9xPOKW0qLu8IO65lsNoqJWwTYsaPERAFqIhUyCr/3gCThyK6o8LJ2ZG7ML9QiuRZzk0dd3lx6rXn0YL0nvaOmP6RrybEGmxOB7lFIhLcQxLXMF5nEYa86GMe6jWkMVyXIySm4oRH+KOTMcmZwLHyNbOjkKE9Wo8FBaSdvWiNsqxShqsYo1MtQXF6wY+ZIAHHy392FCNutonMHEb3HRi+LNsdIWX/0kZkatbFRHTfK9nXnqAD1p9swM2oabqw8ow2Og==
Received: from DS7PR05CA0076.namprd05.prod.outlook.com (2603:10b6:8:57::13) by
 PH8PR12MB7232.namprd12.prod.outlook.com (2603:10b6:510:224::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7270.16; Mon, 5 Feb
 2024 23:01:51 +0000
Received: from DS3PEPF000099D3.namprd04.prod.outlook.com
 (2603:10b6:8:57:cafe::56) by DS7PR05CA0076.outlook.office365.com
 (2603:10b6:8:57::13) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7270.14 via Frontend
 Transport; Mon, 5 Feb 2024 23:01:51 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.118.232)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.118.232 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.118.232; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.118.232) by
 DS3PEPF000099D3.mail.protection.outlook.com (10.167.17.4) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.7249.19 via Frontend Transport; Mon, 5 Feb 2024 23:01:51 +0000
Received: from drhqmail203.nvidia.com (10.126.190.182) by mail.nvidia.com
 (10.127.129.5) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.41; Mon, 5 Feb 2024
 15:01:41 -0800
Received: from drhqmail202.nvidia.com (10.126.190.181) by
 drhqmail203.nvidia.com (10.126.190.182) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1258.12; Mon, 5 Feb 2024 15:01:40 -0800
Received: from sgarnayak-dt.nvidia.com (10.127.8.9) by mail.nvidia.com
 (10.126.190.181) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1258.12 via Frontend
 Transport; Mon, 5 Feb 2024 15:01:33 -0800
From: <ankita@nvidia.com>
To: <ankita@nvidia.com>, <jgg@nvidia.com>, <alex.williamson@redhat.com>,
	<yishaih@nvidia.com>, <mst@redhat.com>,
	<shameerali.kolothum.thodi@huawei.com>, <kevin.tian@intel.com>,
	<clg@redhat.com>, <oleksandr@natalenko.name>,
	<satyanarayana.k.v.p@intel.com>, <eric.auger@redhat.com>,
	<brett.creeley@amd.com>, <horms@kernel.org>, <rrameshbabu@nvidia.com>
CC: <aniketa@nvidia.com>, <cjia@nvidia.com>, <kwankhede@nvidia.com>,
	<targupta@nvidia.com>, <vsethi@nvidia.com>, <acurrid@nvidia.com>,
	<apopple@nvidia.com>, <jhubbard@nvidia.com>, <danw@nvidia.com>,
	<anuaggarwal@nvidia.com>, <mochs@nvidia.com>, <kvm@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>, <virtualization@lists.linux-foundation.org>
Subject: [PATCH v17 1/3] vfio/pci: rename and export do_io_rw()
Date: Tue, 6 Feb 2024 04:31:21 +0530
Message-ID: <20240205230123.18981-2-ankita@nvidia.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20240205230123.18981-1-ankita@nvidia.com>
References: <20240205230123.18981-1-ankita@nvidia.com>
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
X-MS-TrafficTypeDiagnostic: DS3PEPF000099D3:EE_|PH8PR12MB7232:EE_
X-MS-Office365-Filtering-Correlation-Id: 49281476-ea14-4b1f-5eb6-08dc269e705b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	uP6EQhDBcYIq92FhaMayqiPHcxqvvvuXNP32RAfUfKdXqFRGD1yBFYl28YiVcFhn66ookEtPVS/dExo5Vbbj1RFJx3Tucz6E7JFmTDNonzBjLyZwQ+Nt6DXqow2uQdMdTMep0d5Ze3/6jA2NkNwTQeN+2Oz86adaUfifUqpWjfvJZWHZXy/te1CNbXUPfRN6e/4THfF1U5eQhTCfNyBQuBPtRf68JsXThgotn2EInuB131pTitJ0CHynXeb+gHyn8QV7DvEw3V6PQCAe6mvcZeFAO2Galtws/gLXYKBRpVNrFuDajg4FdKb7JiFN0PJWW8oPyoF4HqhUE2VvInQUrE1qkrGC0eSUZAejvir7CpItXBhhPuHidU7k554V+VKzY7e7YgGsNa/w24CBnvt8zXQ8lVc7uwsbpvW9AAjjQjzhQO8fDWjoMYUREWpuQQx+etwe/UnHgk0CbazG/8VDPmzNjGSW86RgqpvXxKNDjkKNwvEOWUj5vbWxPv+8hmM4XxLhBjuljZmcGEJejoA4sS1cM6gQHsKT3DGBU/HPvRmIFKJj0RoMBXiWPUN/nPsA+W40+Cr/C17/dsHQOd9mqkY4BeperDwUR5RNVUAVfPC+q46QDj9kgkQGMOoenn7uXR3uixY3GMHz3M+4SARPYiHQC6a5ysWb8dUinuoz0sLGAVVLDEW5eVMtBXZbbOv+zYD8WQwHbMCS5CcPDfswIQ+jXtcyU3Gp3oOPI5u0ow8DhmMZaSu4o2WamHDqtj/A
X-Forefront-Antispam-Report:
	CIP:216.228.118.232;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc7edge1.nvidia.com;CAT:NONE;SFS:(13230031)(4636009)(346002)(396003)(39860400002)(136003)(376002)(230922051799003)(82310400011)(64100799003)(186009)(1800799012)(451199024)(40470700004)(36840700001)(46966006)(7636003)(110136005)(316002)(54906003)(6636002)(83380400001)(82740400003)(356005)(2616005)(7696005)(6666004)(1076003)(26005)(2906002)(7416002)(70206006)(70586007)(86362001)(5660300002)(478600001)(8676002)(336012)(47076005)(4326008)(426003)(8936002)(36756003)(40480700001)(40460700003)(2876002)(36860700001)(921011)(41300700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Feb 2024 23:01:51.0086
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 49281476-ea14-4b1f-5eb6-08dc269e705b
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.118.232];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DS3PEPF000099D3.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH8PR12MB7232

From: Ankit Agrawal <ankita@nvidia.com>

do_io_rw() is used to read/write to the device MMIO. The grace hopper
VFIO PCI variant driver require this functionality to read/write to
its memory.

Rename this as vfio_pci_core functions and export as GPL.

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


