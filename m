Return-Path: <kvm+bounces-4794-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id C23BF818495
	for <lists+kvm@lfdr.de>; Tue, 19 Dec 2023 10:35:04 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 6BF15283216
	for <lists+kvm@lfdr.de>; Tue, 19 Dec 2023 09:35:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 51E1914A89;
	Tue, 19 Dec 2023 09:34:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="gQ66xKYS"
X-Original-To: kvm@vger.kernel.org
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2045.outbound.protection.outlook.com [40.107.244.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E1DDD1427F
	for <kvm@vger.kernel.org>; Tue, 19 Dec 2023 09:34:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Du5ICgKQvnimGlWAHbo9I3eA/4W8yoox0r8WbyeSBxQu6CZj/n/kR+tojCHO4wfG3zTpSuqIGFt4Gy4edPIjYgoNrwUY2oXR1iV8kmOTPnUc34HTHd0qByveA+4rWew8JYXvOnKIQlnR+XnM9C7QpNj/bEH9/LDsuKhQ6RpB425XIHQmDe4hxnCLO0gusbHcQ6vqQLi95TzHmpP9B8IoNXOL4UJJTh18SJrR2SBoNVO89wfBj8IN5dY3A6my2lRVbs2OYqQjHWuSzUwXLnE3Fkgyn3CCsfck6dRw6oEa9nlmjg5sWEJvtiKy7YfbLydgPGet78NirMf72eXBRTzwJA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=hXcK/G8oJC+S6lyVvbGQZzxzVj/DYU7hqLkvWu6O0BI=;
 b=j2BG87Q3ZMyJwJNLS3KfhTBu1Or9ZalOsvgf+60GlnKh5T6tLrVSn9kuzD8MuIIekLLJDIrDrZKbzqULIOIQTVLPXZkQWPaSqz/OP9ot/xBHmL7y26aFmxqLWv+Ae3/b/Y8a0ONrmQ+6bCMjvP+p4PzzzZPARqSMW84fAYgy+RbxYdGLvugqFD5Qv/ZoNYIPBrFM+8QZdV37y6DuR04K2tK+Dh4yFVGK4kp1mrWysfsRH7w5d6KlBt5L1bEH4WG/hrqbTnVZgloh9GJuycM7t0YUMnMOL5yOahAUeLCs4GJXgfr7YP/uur/Ezw6gJCsJHfA+N+PdZQtcBi+38PTF9w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.118.232) smtp.rcpttodomain=redhat.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hXcK/G8oJC+S6lyVvbGQZzxzVj/DYU7hqLkvWu6O0BI=;
 b=gQ66xKYSQmlWQAJi1fw1IJG1Sqnh2ngevUNiTCYm7Km2Z0COcy4G6vf7wvGarxjTmQiG8kOH7b5bg46Yg1Mf7TfVgTyF+nslsqWquSMoTlLbDLwiOpLg+gHJLNYsakfnTcUb+AORgo7NyqdHX56IDsARJBYjmL2v1yNcp0O2pA2FmFw2ZHOKoUvamrDFQHTejDUEGMzl6SakBQWSyoNIyXeYgBaeMm/2HUkq18jS6qo7REH4ajrSmiod/52Xu/UYv9fkAHhN6m20pB9N3QZ/2bZYvrzc0Lb/vLCW0QT05DlSlfSUtc0gqrc053eqx99OTyOMjnyiHUga/Neyfh3oEw==
Received: from DM6PR02CA0129.namprd02.prod.outlook.com (2603:10b6:5:1b4::31)
 by SN7PR12MB7228.namprd12.prod.outlook.com (2603:10b6:806:2ab::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7091.37; Tue, 19 Dec
 2023 09:34:26 +0000
Received: from CY4PEPF0000EDD0.namprd03.prod.outlook.com
 (2603:10b6:5:1b4:cafe::97) by DM6PR02CA0129.outlook.office365.com
 (2603:10b6:5:1b4::31) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7091.38 via Frontend
 Transport; Tue, 19 Dec 2023 09:34:25 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.118.232)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.118.232 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.118.232; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.118.232) by
 CY4PEPF0000EDD0.mail.protection.outlook.com (10.167.241.204) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.7113.14 via Frontend Transport; Tue, 19 Dec 2023 09:34:25 +0000
Received: from drhqmail201.nvidia.com (10.126.190.180) by mail.nvidia.com
 (10.127.129.5) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.41; Tue, 19 Dec
 2023 01:34:16 -0800
Received: from drhqmail202.nvidia.com (10.126.190.181) by
 drhqmail201.nvidia.com (10.126.190.180) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.986.41; Tue, 19 Dec 2023 01:34:16 -0800
Received: from vdi.nvidia.com (10.127.8.10) by mail.nvidia.com
 (10.126.190.181) with Microsoft SMTP Server id 15.2.986.41 via Frontend
 Transport; Tue, 19 Dec 2023 01:34:13 -0800
From: Yishai Hadas <yishaih@nvidia.com>
To: <alex.williamson@redhat.com>, <mst@redhat.com>, <jasowang@redhat.com>,
	<jgg@nvidia.com>
CC: <kvm@vger.kernel.org>, <virtualization@lists.linux-foundation.org>,
	<parav@nvidia.com>, <feliu@nvidia.com>, <jiri@nvidia.com>,
	<kevin.tian@intel.com>, <joao.m.martins@oracle.com>, <si-wei.liu@oracle.com>,
	<leonro@nvidia.com>, <yishaih@nvidia.com>, <maorg@nvidia.com>
Subject: [PATCH V10 vfio 8/9] vfio/pci: Expose vfio_pci_core_iowrite/read##size()
Date: Tue, 19 Dec 2023 11:32:46 +0200
Message-ID: <20231219093247.170936-9-yishaih@nvidia.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20231219093247.170936-1-yishaih@nvidia.com>
References: <20231219093247.170936-1-yishaih@nvidia.com>
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
X-MS-TrafficTypeDiagnostic: CY4PEPF0000EDD0:EE_|SN7PR12MB7228:EE_
X-MS-Office365-Filtering-Correlation-Id: 8524eab0-3bc5-457a-91a4-08dc0075b0f1
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	YSkgP/leGf6BqZumtWNadizh8S25yi5h3mY2dvu9y5dv2Mz5lZ8DLO3yuidj/kCw4rTTf1WZqRB6Pc+IRKx1c8SfmlR8DOsUt6uZ3gxty07/m+xg+NHRF5SiID1LcwQ4jyVQDia6GF/th36Y090CCuAH4kz6rT721HJAhusTvf/tzkOJgRR4JLqYJpHvW+Pv1BZ7zNdHozuSv7+x3bif3RXKWODlsRilRRWRl+T7xI961oBESsw89T/NHNT9nTgVToKyeyDzMZkeQIO+dwXUowO1cWu91tfj0ecW+pQE8vzgPyNknaPg3d94VExaewYI+07mG5hDimHqnhn87QmkglP7MAIftz2ZqD7qlPwQvKwasxe38crGebLwk7fuXDjxiftTbIb3Jx6gybHoTPloOpZFB6ttDp4oabm4awh1+OxC9BJgefNRvyMIWtWHnz8ephYA7KNxKUzq8zrVd45GhF+QpeiPz5wrUENSVDjqZrWDPM5PDMVdnO3k1CRWyus400C1upTmD5xkWrUAr3Zq/Mc5aurTJ2QQDW5LqVvgkobhxAaNVDC5v6GSBGFpy8l0+/6dvB1hT6DNJ1C4jAOQg6mSh4S0uIAWf887tirGlY+OXAvNw7XgzZZOsV5AxCBXHCy0lVQ2iE58lnkiawxHvXNIm+CpAdfCzYqcul7wUskwct4h2e/n7Xz7JHVJPnQ5T7xW6JCXm19/qvjmVSVUfCMqsrfeOqq9waultHMDPHqxaDj3loLc/wQfh3+DeI4Osr/AjfOX+GIF2gGNEhwVog==
X-Forefront-Antispam-Report:
	CIP:216.228.118.232;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc7edge1.nvidia.com;CAT:NONE;SFS:(13230031)(4636009)(39860400002)(136003)(346002)(376002)(396003)(230922051799003)(186009)(1800799012)(82310400011)(451199024)(64100799003)(40470700004)(36840700001)(46966006)(40480700001)(2616005)(478600001)(54906003)(107886003)(1076003)(110136005)(426003)(6666004)(336012)(83380400001)(6636002)(70206006)(70586007)(316002)(5660300002)(47076005)(7696005)(8676002)(8936002)(4326008)(26005)(36860700001)(40460700003)(7636003)(356005)(2906002)(82740400003)(86362001)(41300700001)(36756003)(2101003);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Dec 2023 09:34:25.8625
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 8524eab0-3bc5-457a-91a4-08dc0075b0f1
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.118.232];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CY4PEPF0000EDD0.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR12MB7228

Expose vfio_pci_core_iowrite/read##size() to let it be used by drivers.

This functionality is needed to enable direct access to some physical
BAR of the device with the proper locks/checks in place.

The next patches from this series will use this functionality on a data
path flow when a direct access to the BAR is needed.

Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>
Reviewed-by: Kevin Tian <kevin.tian@intel.com>
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


