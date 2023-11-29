Return-Path: <kvm+bounces-2774-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 77BF27FD9BF
	for <lists+kvm@lfdr.de>; Wed, 29 Nov 2023 15:39:41 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 9B7E31C211C1
	for <lists+kvm@lfdr.de>; Wed, 29 Nov 2023 14:39:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5B2A61CA82;
	Wed, 29 Nov 2023 14:39:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="WZJ5kKGu"
X-Original-To: kvm@vger.kernel.org
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2040.outbound.protection.outlook.com [40.107.236.40])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8F7C719A6
	for <kvm@vger.kernel.org>; Wed, 29 Nov 2023 06:39:06 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=bUyLd8Ct6GrfxKchCugP+7nv4m/qmfS8qZp6en1olmpoeG2/JGzpe8EXUeR+aohVE7AqRVqnSiIStJnOmkBAjhPlILYKGvtH5ViTNWa0D0bjX08T1gzw1mxraaBO1cueQUrRGcSDGclcRwdmlc4j2/boaMtFw0K9eir6izu//RkzPCdGgQwL8gF6RUzWSvDIUD0irihLkOs4ERZz7EoAvf9zMYrTGEep17B2n0hr5BtLbH471zrMf+5K5tt6/3/0Itm9xpmb3leWyDmm5hfqEFAwP2G0RBsqkGdOFOGEOvWsOYsTLB1aiAerqEZlFdO8tVIzngLq6WMo9YzAjOqwaA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=P1eFzxJ/LjJHaZZ59rqE75yCcH0bNXHQfZmDKNhUSPI=;
 b=DWXA+TEorcC2vUcecTij3fZkGsXL37kZs1Z2bNkZDhqChMAtw3yyIh2KfWUpi//kltiEtz15ozvhpi789PEmK7oONFPDZn23ibTXOegLpwsUJU7eP8O7yQJnDLL+wiXkuJPjXUCae6SUcUUfEd0xclnsEnT5bPbUZjRhZhjfFcEnWiVa2usdYotqT3auvoy0/QM8djEK6JoUo9CBgMxeLSC942jMojFQEjtS9OGvhrKZ7RwyPe8kVBPbkmF6IVltPSTedMa9ka6oebomD84MgUKYtXcMcs3TRU1a9FxR+0F/u78CmkOTgpret+8JmYZq54cfDuRxoQk7ESienKwTXQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.118.233) smtp.rcpttodomain=redhat.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=P1eFzxJ/LjJHaZZ59rqE75yCcH0bNXHQfZmDKNhUSPI=;
 b=WZJ5kKGuXFAFUsgNIk5wWTtkZct8Dm7RDa47A+IG77RELExXtuXqfetGDehpvUDIFbsCjc2M7PKiIWhprEcCf2TcUBB/kOPplxmRfwBqFKMPpJF+R0nGXhF/pUbXgGu0MRwSWGUlnqxdzTgjQ0lV55bloncngyFDSOcCmugP7Pe++kEvNM0XeTWJilq1cgpf1V363DQ8OdwwKT2lv1+xY3Rro+/HL75HNZO3KDFwzWxPzv2jHzZQfPG5uMJyjHdTey3gEVCJZvB2/JOc7zeiDQJlEoEK/8gftQQ80GkMuxyL8KTh80sdcn0vrBiQ6XCxvKfiv+vtvPta8dvQ55D4Ow==
Received: from DS7PR03CA0360.namprd03.prod.outlook.com (2603:10b6:8:55::33) by
 IA1PR12MB7663.namprd12.prod.outlook.com (2603:10b6:208:424::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7025.30; Wed, 29 Nov
 2023 14:39:02 +0000
Received: from CY4PEPF0000EDD4.namprd03.prod.outlook.com
 (2603:10b6:8:55:cafe::60) by DS7PR03CA0360.outlook.office365.com
 (2603:10b6:8:55::33) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6977.31 via Frontend
 Transport; Wed, 29 Nov 2023 14:39:02 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.118.233)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.118.233 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.118.233; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.118.233) by
 CY4PEPF0000EDD4.mail.protection.outlook.com (10.167.241.208) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.7046.17 via Frontend Transport; Wed, 29 Nov 2023 14:39:02 +0000
Received: from drhqmail202.nvidia.com (10.126.190.181) by mail.nvidia.com
 (10.127.129.6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.41; Wed, 29 Nov
 2023 06:38:54 -0800
Received: from drhqmail203.nvidia.com (10.126.190.182) by
 drhqmail202.nvidia.com (10.126.190.181) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.986.41; Wed, 29 Nov 2023 06:38:54 -0800
Received: from vdi.nvidia.com (10.127.8.10) by mail.nvidia.com
 (10.126.190.182) with Microsoft SMTP Server id 15.2.986.41 via Frontend
 Transport; Wed, 29 Nov 2023 06:38:50 -0800
From: Yishai Hadas <yishaih@nvidia.com>
To: <alex.williamson@redhat.com>, <mst@redhat.com>, <jasowang@redhat.com>,
	<jgg@nvidia.com>
CC: <kvm@vger.kernel.org>, <virtualization@lists.linux-foundation.org>,
	<parav@nvidia.com>, <feliu@nvidia.com>, <jiri@nvidia.com>,
	<kevin.tian@intel.com>, <joao.m.martins@oracle.com>, <si-wei.liu@oracle.com>,
	<leonro@nvidia.com>, <yishaih@nvidia.com>, <maorg@nvidia.com>
Subject: [PATCH V4 vfio 7/9] vfio/pci: Expose vfio_pci_core_setup_barmap()
Date: Wed, 29 Nov 2023 16:37:44 +0200
Message-ID: <20231129143746.6153-8-yishaih@nvidia.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20231129143746.6153-1-yishaih@nvidia.com>
References: <20231129143746.6153-1-yishaih@nvidia.com>
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
X-MS-TrafficTypeDiagnostic: CY4PEPF0000EDD4:EE_|IA1PR12MB7663:EE_
X-MS-Office365-Filtering-Correlation-Id: 87d36962-2e91-4dae-97ac-08dbf0e8ee5f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	eNx8uEFvw5B42v5HzTffv0Br+oFmSpOaSgTJRzCdxGPfNGBY715MvmIqLbphajR8kHaqEzpyL+8P9yxvm19UvD86eM2hiDYsH+sUF65xZQrOv1j+SKuNPrBSoC8lrrBsfC/74SCIB0ITwHi7ZkVmVj22Z/73U5TAyntbEVkXoS/Qzyi3Iay0N9txy02Nto4OVtJIo/gJt5E4I471wd3THKWDS3oQwd68AqEBL3bh1aT5+rrGykRvUYmtRG9OOpfm3RSx4NvP1iEx3lxjHwaUfZ9UGxd21OHgvwgZnf2mF/ws5HqSHbItIfo288nK1S3Ml6WZK0Rx1RWfPWNO9traj/m8fCbxPF7XZqPq3EdsK92yPKoUhX6Aia0OO+Qs1zkSh/2owLkft1dcGdZ2XmQqQFuGtkukOWsvp9W1FGZieT44SaBOXrEqBMNa9vzQYuovEjOoLFs5TiQ4/Et3ot+zLYIxJXqSbPk+ycbFu0wQj1MnThEorQLmfJ1FM7hGYAhkweGttviz950g8HgWmmrW2iP2145+BjMFXhHsCBqjHODVIl7RC0jM6QfJOQ4PFwYYKY9KDnOzQF1Ot3RwdlXvFbyODpzx8u5KqIT9d5nGVCv+5DzE4dhVY188cQvmgvWfDsLYSG3ebe98jhVMhF5hZuMZysdPBcyYOESA47qEor3+1xWTVu8Dy/eQRthX6cp7ZvZtS3ToWsUg7mMZ1p4fngBP+QyIJZFADNQuzkNalOcbt1NefX5Og4cAyJ2ezu24bH3REEnbWspVRTiFsPjy0A==
X-Forefront-Antispam-Report:
	CIP:216.228.118.233;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc7edge2.nvidia.com;CAT:NONE;SFS:(13230031)(4636009)(376002)(396003)(39860400002)(346002)(136003)(230922051799003)(64100799003)(451199024)(186009)(82310400011)(1800799012)(46966006)(40470700004)(36840700001)(40460700003)(356005)(82740400003)(7636003)(426003)(478600001)(8676002)(4326008)(8936002)(36756003)(54906003)(6636002)(70586007)(86362001)(70206006)(26005)(316002)(110136005)(1076003)(107886003)(2616005)(336012)(7696005)(41300700001)(83380400001)(47076005)(36860700001)(6666004)(2906002)(5660300002)(40480700001)(2101003);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Nov 2023 14:39:02.4440
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 87d36962-2e91-4dae-97ac-08dbf0e8ee5f
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.118.233];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CY4PEPF0000EDD4.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR12MB7663

Expose vfio_pci_core_setup_barmap() to be used by drivers.

This will let drivers to mmap a BAR and re-use it from both vfio and the
driver when it's applicable.

This API will be used in the next patches by the vfio/virtio coming
driver.

Signed-off-by: Yishai Hadas <yishaih@nvidia.com>
---
 drivers/vfio/pci/vfio_pci_core.c | 25 +++++++++++++++++++++++++
 drivers/vfio/pci/vfio_pci_rdwr.c | 28 ++--------------------------
 include/linux/vfio_pci_core.h    |  1 +
 3 files changed, 28 insertions(+), 26 deletions(-)

diff --git a/drivers/vfio/pci/vfio_pci_core.c b/drivers/vfio/pci/vfio_pci_core.c
index 1929103ee59a..ebea39836dd9 100644
--- a/drivers/vfio/pci/vfio_pci_core.c
+++ b/drivers/vfio/pci/vfio_pci_core.c
@@ -684,6 +684,31 @@ void vfio_pci_core_disable(struct vfio_pci_core_device *vdev)
 }
 EXPORT_SYMBOL_GPL(vfio_pci_core_disable);
 
+int vfio_pci_core_setup_barmap(struct vfio_pci_core_device *vdev, int bar)
+{
+	struct pci_dev *pdev = vdev->pdev;
+	void __iomem *io;
+	int ret;
+
+	if (vdev->barmap[bar])
+		return 0;
+
+	ret = pci_request_selected_regions(pdev, 1 << bar, "vfio");
+	if (ret)
+		return ret;
+
+	io = pci_iomap(pdev, bar, 0);
+	if (!io) {
+		pci_release_selected_regions(pdev, 1 << bar);
+		return -ENOMEM;
+	}
+
+	vdev->barmap[bar] = io;
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(vfio_pci_core_setup_barmap);
+
 void vfio_pci_core_close_device(struct vfio_device *core_vdev)
 {
 	struct vfio_pci_core_device *vdev =
diff --git a/drivers/vfio/pci/vfio_pci_rdwr.c b/drivers/vfio/pci/vfio_pci_rdwr.c
index e27de61ac9fe..6f08b3ecbb89 100644
--- a/drivers/vfio/pci/vfio_pci_rdwr.c
+++ b/drivers/vfio/pci/vfio_pci_rdwr.c
@@ -200,30 +200,6 @@ static ssize_t do_io_rw(struct vfio_pci_core_device *vdev, bool test_mem,
 	return done;
 }
 
-static int vfio_pci_setup_barmap(struct vfio_pci_core_device *vdev, int bar)
-{
-	struct pci_dev *pdev = vdev->pdev;
-	int ret;
-	void __iomem *io;
-
-	if (vdev->barmap[bar])
-		return 0;
-
-	ret = pci_request_selected_regions(pdev, 1 << bar, "vfio");
-	if (ret)
-		return ret;
-
-	io = pci_iomap(pdev, bar, 0);
-	if (!io) {
-		pci_release_selected_regions(pdev, 1 << bar);
-		return -ENOMEM;
-	}
-
-	vdev->barmap[bar] = io;
-
-	return 0;
-}
-
 ssize_t vfio_pci_bar_rw(struct vfio_pci_core_device *vdev, char __user *buf,
 			size_t count, loff_t *ppos, bool iswrite)
 {
@@ -262,7 +238,7 @@ ssize_t vfio_pci_bar_rw(struct vfio_pci_core_device *vdev, char __user *buf,
 		}
 		x_end = end;
 	} else {
-		int ret = vfio_pci_setup_barmap(vdev, bar);
+		int ret = vfio_pci_core_setup_barmap(vdev, bar);
 		if (ret) {
 			done = ret;
 			goto out;
@@ -438,7 +414,7 @@ int vfio_pci_ioeventfd(struct vfio_pci_core_device *vdev, loff_t offset,
 		return -EINVAL;
 #endif
 
-	ret = vfio_pci_setup_barmap(vdev, bar);
+	ret = vfio_pci_core_setup_barmap(vdev, bar);
 	if (ret)
 		return ret;
 
diff --git a/include/linux/vfio_pci_core.h b/include/linux/vfio_pci_core.h
index 562e8754869d..67ac58e20e1d 100644
--- a/include/linux/vfio_pci_core.h
+++ b/include/linux/vfio_pci_core.h
@@ -127,6 +127,7 @@ int vfio_pci_core_match(struct vfio_device *core_vdev, char *buf);
 int vfio_pci_core_enable(struct vfio_pci_core_device *vdev);
 void vfio_pci_core_disable(struct vfio_pci_core_device *vdev);
 void vfio_pci_core_finish_enable(struct vfio_pci_core_device *vdev);
+int vfio_pci_core_setup_barmap(struct vfio_pci_core_device *vdev, int bar);
 pci_ers_result_t vfio_pci_core_aer_err_detected(struct pci_dev *pdev,
 						pci_channel_state_t state);
 
-- 
2.27.0


