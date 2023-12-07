Return-Path: <kvm+bounces-3845-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 37BDA808584
	for <lists+kvm@lfdr.de>; Thu,  7 Dec 2023 11:30:34 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id EE61BB21F96
	for <lists+kvm@lfdr.de>; Thu,  7 Dec 2023 10:30:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2F2CD37D2F;
	Thu,  7 Dec 2023 10:29:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="VT0XFs9c"
X-Original-To: kvm@vger.kernel.org
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2075.outbound.protection.outlook.com [40.107.94.75])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0D05BD5E
	for <kvm@vger.kernel.org>; Thu,  7 Dec 2023 02:29:44 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=GpG1iu9wCUN48ukbu6aGuM6N8xgCg0u448v4lPkNzC8+am8O470dE2eRPyUdHOV9z7rnUukv5AzI/OoOTiMoMKBvcfeffC8v4Bj+8J3bZDd35d1AUdee1eNU6IEjyjG9VLfh7aaK5lvL+Fthl3aVqycwf0WDjthZXrLv/El+tfx49HnR3pq2JobZkAnlFPRYnMge4jd6/knu6qgTyZzuTZbHlJbMlQbjhK9qWdsHyPZyf4Jrqb3XYflqbkFAyyopKxelsuq5IaHDIpmvC7NYmTHZKaIrrbhR63/mDWKDjtS9Rk9CcxRq+s+kMR6OHxIdw/z0VkZ0UYWAvX2pOwFFXg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=VgIKkOuiHrt7PxkVu4tnXbZ5QFPoip7IueGEP1vcYuc=;
 b=j2Yx/h6r7IH13x8SkAXU6Ng61fhbGLB1eve24TwTXoLj5ek+hpFgfKmTzw0YZlBtf2GkOUaJpQJp8NQluSmFFAf1Zt7f932Nke1yKBjACJQuGOqFAneUDrfzku+iUEVmKVYrIBdKgCwAgK0fseSJNs2dxeGag7LRdnH4rr+J3sZUvsdnIlfEl5niVuWv97My8JZbrY2sr5T2yPqE/6meRJ3NuG2aKt/mu7NeRRyaqwESJMN7R/iz7/aJIndOwgqIJUKxvJYp+Edq2GXP0Kh6WD7ncxNicqu5R72TdIxEyWGB58QNsrcTallZmHJlNRmgO5vjInqfJxXUhGoxrMinEA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=redhat.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=VgIKkOuiHrt7PxkVu4tnXbZ5QFPoip7IueGEP1vcYuc=;
 b=VT0XFs9ci5sO1j7+owzGa8cz+QFQjyDfMiSYFqtolEbljK+GbevZPoQPtKCC46Cuqyza8XHQon/7XHID3JJwl9dk0KZgaAJigw/oGutTmF8TeVXyJnskvIVlUhC6MKbzpza8M7dF7RmuBD0fBgrNXvgxtBHLdnbmGQBy2Hao+ufEsCqUy/Am56JEhHS8snGlfZFdJvVi4ufxQPnVARQIDwbhmgJ9HF9pmKlhdAaT6iNEfaTHzaIZBrbJ983cnFbv71upsQTykTkbQaunfZfyPd2lRV4OrX3iE0XJq8EYQ8FpYqD6kSsJqP00jLtLEBWaNv7FWE8aNSV0kRpShmCBBg==
Received: from DM6PR06CA0060.namprd06.prod.outlook.com (2603:10b6:5:54::37) by
 BL1PR12MB5994.namprd12.prod.outlook.com (2603:10b6:208:39a::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7046.34; Thu, 7 Dec
 2023 10:29:41 +0000
Received: from DS2PEPF0000343E.namprd02.prod.outlook.com
 (2603:10b6:5:54:cafe::68) by DM6PR06CA0060.outlook.office365.com
 (2603:10b6:5:54::37) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7046.33 via Frontend
 Transport; Thu, 7 Dec 2023 10:29:40 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.161)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 DS2PEPF0000343E.mail.protection.outlook.com (10.167.18.41) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.7068.20 via Frontend Transport; Thu, 7 Dec 2023 10:29:40 +0000
Received: from rnnvmail202.nvidia.com (10.129.68.7) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.41; Thu, 7 Dec 2023
 02:29:31 -0800
Received: from rnnvmail204.nvidia.com (10.129.68.6) by rnnvmail202.nvidia.com
 (10.129.68.7) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.41; Thu, 7 Dec 2023
 02:29:31 -0800
Received: from vdi.nvidia.com (10.127.8.10) by mail.nvidia.com (10.129.68.6)
 with Microsoft SMTP Server id 15.2.986.41 via Frontend Transport; Thu, 7 Dec
 2023 02:29:27 -0800
From: Yishai Hadas <yishaih@nvidia.com>
To: <alex.williamson@redhat.com>, <mst@redhat.com>, <jasowang@redhat.com>,
	<jgg@nvidia.com>
CC: <kvm@vger.kernel.org>, <virtualization@lists.linux-foundation.org>,
	<parav@nvidia.com>, <feliu@nvidia.com>, <jiri@nvidia.com>,
	<kevin.tian@intel.com>, <joao.m.martins@oracle.com>, <si-wei.liu@oracle.com>,
	<leonro@nvidia.com>, <yishaih@nvidia.com>, <maorg@nvidia.com>
Subject: [PATCH V7 vfio 8/9] vfio/pci: Expose vfio_pci_core_iowrite/read##size()
Date: Thu, 7 Dec 2023 12:28:19 +0200
Message-ID: <20231207102820.74820-9-yishaih@nvidia.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20231207102820.74820-1-yishaih@nvidia.com>
References: <20231207102820.74820-1-yishaih@nvidia.com>
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
X-MS-TrafficTypeDiagnostic: DS2PEPF0000343E:EE_|BL1PR12MB5994:EE_
X-MS-Office365-Filtering-Correlation-Id: cb0e585f-3370-41dc-4638-08dbf70f6b82
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	wBeeKR5oWtKy7Oz6pr8FetZPGjLaP82o+OE+Fnl40RKGyyvzJ/A25Wj83IGsVa1lG4cgG9IWCiThRqphUSU/a7VpCg9WkRRY5xeBoyZ3fOT83ZT8SIHGS2NeZ5Fb8NRttgwqU1WglXhcjS2h8/OFK8eJXjPIkHZ1PCQWkGdCKA+FNQn2hlDGaE2VFz9Ax/BPKyHp/ngAe3LClKnLhlKprDYx+tzaGLeKnrKOR1YmyAynWL2ly3AhtMwxFSssXADnfnqp3RgA54x/44o7IKruTqDH6AWsKDHOhMtBDGY7ZhMH95Sc5OCdLQHUDBPQVJeMow4c9pUd2egAS5JtRbg/r6bmtyLBkVD1OEtBFWkQzmEAm9XmgfnllJOVHQvVApdv0lJToMzMx3Bj66zIF2wPnDreKVqTTyK2qrU4yGhk24giEJLOKOUbYtaJRwl3wnYyw+Oc/cnRuxuGFmCPlrL2E5nTa8bO1au4F045oSKcmRgusWmJTPzJw5sDAJmQX+Yxl7UuxlfDIppps96XT4fm2mSz3bm3b0MfYr4lORL0jjlqde/I1l2b9p7F91uif5M3OA3Hb0VzRGOcpyId7XUyGiBUq3nrabM8hD0tC2/287kKuxzz8UqaeNdR+odINBh5bDw80Qr3Zb7/k1Z7+m1aZVOesz2FgV22unNsiWRWmMImm4LiUMe/Gfy+HFw4dyvMK/Mbm0KOo5rV9cmmqa69ZGmbzimPpop6Ler8yr9D9JgiVdST1frl3bN/hB4n63o+6n5z6MjHhfz30k56VTOkPg==
X-Forefront-Antispam-Report:
	CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230031)(4636009)(376002)(136003)(346002)(396003)(39860400002)(230922051799003)(82310400011)(451199024)(64100799003)(186009)(1800799012)(46966006)(36840700001)(40470700004)(7696005)(36860700001)(478600001)(47076005)(356005)(2616005)(7636003)(1076003)(107886003)(36756003)(40480700001)(26005)(6666004)(83380400001)(82740400003)(426003)(336012)(8936002)(8676002)(70206006)(110136005)(70586007)(54906003)(40460700003)(316002)(86362001)(2906002)(41300700001)(5660300002)(4326008)(6636002)(2101003);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Dec 2023 10:29:40.1920
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: cb0e585f-3370-41dc-4638-08dbf70f6b82
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DS2PEPF0000343E.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR12MB5994

Expose vfio_pci_core_iowrite/read##size() to let it be used by drivers.

This functionality is needed to enable direct access to some physical
BAR of the device with the proper locks/checks in place.

The next patches from this series will use this functionality on a data
path flow when a direct access to the BAR is needed.

Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Yishai Hadas <yishaih@nvidia.com>
---
 drivers/vfio/pci/vfio_pci_rdwr.c | 50 +++++++++++++++++---------------
 include/linux/vfio_pci_core.h    | 19 ++++++++++++
 2 files changed, 45 insertions(+), 24 deletions(-)

diff --git a/drivers/vfio/pci/vfio_pci_rdwr.c b/drivers/vfio/pci/vfio_pci_rdwr.c
index a9887fd6de46..07fea08ea8a2 100644
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
 
@@ -364,21 +366,21 @@ static void vfio_pci_ioeventfd_do_write(struct vfio_pci_ioeventfd *ioeventfd,
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
-		vfio_pci_iowrite64(ioeventfd->vdev, test_mem,
-				   ioeventfd->data, ioeventfd->addr);
+		vfio_pci_core_iowrite64(ioeventfd->vdev, test_mem,
+					ioeventfd->data, ioeventfd->addr);
 		break;
 #endif
 	}
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


