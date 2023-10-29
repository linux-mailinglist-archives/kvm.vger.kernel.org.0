Return-Path: <kvm+bounces-23-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id A6DAC7DAD22
	for <lists+kvm@lfdr.de>; Sun, 29 Oct 2023 17:01:09 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 5AC1A2812E4
	for <lists+kvm@lfdr.de>; Sun, 29 Oct 2023 16:01:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A8207D512;
	Sun, 29 Oct 2023 16:01:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="EAITY+Mh"
X-Original-To: kvm@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A02851095F
	for <kvm@vger.kernel.org>; Sun, 29 Oct 2023 16:00:54 +0000 (UTC)
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2070.outbound.protection.outlook.com [40.107.223.70])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E1E84BA
	for <kvm@vger.kernel.org>; Sun, 29 Oct 2023 09:00:50 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=cJTHAeSG/6kMXPqb4/7oowmLG6iVknDvhxEIWY/IAMjatlc4p3U/9TXHDM905+tWpzZf0V7ouDF19LkCEj0sGa8QfGGetooWu/8iHyiEtmOHSNQEDEfwo3m34dnSmnmPd+QVOfGFYPJMIuyv9wUtl/HzWz2+DNkX4XPHe9/jZ1iJdU/KcogZftyvocVRQ7mxKphQWlI8MZSQ252Hc/sN4KxMC3JrnrY+uxrGiu9LyAW8s/WYUvieGq6+fsYi0a5B4dUUuaxrjSg4MRfkV+NWaHnj6yHZ5gYEg0KfeX+b3bYeUCZVZkRTcBWte8+v/xNvUmxKYqV8uPC/VJmUg3O5fQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=4ueIy9hp+yuSDFUn+Cwq4VZ9wxfooOvfEfsfqTWEOdw=;
 b=lDMh0GxQTTWCWfS34+RIPv7ODEd6D8e5rMDSJh+JicqVG/8HtIlnJNuaTXo3LTHszBa2myg+y3MHcpaPGnr+bP5XGxgBRPWn5iEGLMvlkbRxgRbRwSNkKjrkI4vOCrzf9xOMUx9RKiMgLJ4L3HgAJKQjx533xtVGnGQvoAZzTy66nzGAmtlOWAKUvVu+gn5Q9bW/clguq4kRRAuDQSwWbfQIW9aaoFmadyWbw2O6BuN+SW/9mgG0divj2H//4nqutCcFm1qmhq5RomQhiQeSsUuwZDFLFMjC+yrTLyLYCHXiWczLDDT1fq87hHmQsDJxt/MD6+igynoy1Uu+54lD+w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.118.233) smtp.rcpttodomain=redhat.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4ueIy9hp+yuSDFUn+Cwq4VZ9wxfooOvfEfsfqTWEOdw=;
 b=EAITY+Mh9sm+/cZa7Sah2MlA972k2ksb9JpMXekMXSsxPeFUh5SMOr0RgWmXR9y8A2GoXyKNIexpluUSSl3LxJc/b5XOcxEVCumcJjna96r0UC+frx7zQAkEwHnZvIbt8d7u3QpOCWS3uNmy3rjw5jk/IF1zkeFl2JEmx27fGiVo774jTwvDW+/Y7NIjl14GYyvhA2PNucAl8K1gL31yUHOnxqv5VxK49XMQ2MX8q+cyssZcFb9ENPkHzo+Y+jr+hOu2MKRwDLoHA8jGF2mVQY68oEXfRalXe9GZwrxMCz97+wxhBqaEBx7KuKC5U4EMM05dE26DwBWlHlm7vbk40g==
Received: from DM6PR06CA0017.namprd06.prod.outlook.com (2603:10b6:5:120::30)
 by CY5PR12MB6106.namprd12.prod.outlook.com (2603:10b6:930:29::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6933.19; Sun, 29 Oct
 2023 16:00:49 +0000
Received: from DS1PEPF00017099.namprd05.prod.outlook.com
 (2603:10b6:5:120:cafe::22) by DM6PR06CA0017.outlook.office365.com
 (2603:10b6:5:120::30) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6933.26 via Frontend
 Transport; Sun, 29 Oct 2023 16:00:48 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.118.233)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.118.233 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.118.233; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.118.233) by
 DS1PEPF00017099.mail.protection.outlook.com (10.167.18.103) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6933.15 via Frontend Transport; Sun, 29 Oct 2023 16:00:48 +0000
Received: from drhqmail201.nvidia.com (10.126.190.180) by mail.nvidia.com
 (10.127.129.6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.41; Sun, 29 Oct
 2023 09:00:44 -0700
Received: from drhqmail203.nvidia.com (10.126.190.182) by
 drhqmail201.nvidia.com (10.126.190.180) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.986.41; Sun, 29 Oct 2023 09:00:43 -0700
Received: from vdi.nvidia.com (10.127.8.10) by mail.nvidia.com
 (10.126.190.182) with Microsoft SMTP Server id 15.2.986.41 via Frontend
 Transport; Sun, 29 Oct 2023 09:00:40 -0700
From: Yishai Hadas <yishaih@nvidia.com>
To: <alex.williamson@redhat.com>, <mst@redhat.com>, <jasowang@redhat.com>,
	<jgg@nvidia.com>
CC: <kvm@vger.kernel.org>, <virtualization@lists.linux-foundation.org>,
	<parav@nvidia.com>, <feliu@nvidia.com>, <jiri@nvidia.com>,
	<kevin.tian@intel.com>, <joao.m.martins@oracle.com>, <si-wei.liu@oracle.com>,
	<leonro@nvidia.com>, <yishaih@nvidia.com>, <maorg@nvidia.com>
Subject: [PATCH V2 vfio 8/9] vfio/pci: Expose vfio_pci_iowrite/read##size()
Date: Sun, 29 Oct 2023 17:59:51 +0200
Message-ID: <20231029155952.67686-9-yishaih@nvidia.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20231029155952.67686-1-yishaih@nvidia.com>
References: <20231029155952.67686-1-yishaih@nvidia.com>
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
X-MS-TrafficTypeDiagnostic: DS1PEPF00017099:EE_|CY5PR12MB6106:EE_
X-MS-Office365-Filtering-Correlation-Id: 79ff22c6-02c7-47bd-6589-08dbd89837ee
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	K9e8+PRsS+k4e24+sfxL5wAvw21aN7abug4HXH6Mmmy3aVOcbl6OL9tuHQxJxnySmqcd6I0QrKydSzvWNLcnUxboeBSd81DzMfOBOoz3oNmCzZCW7zSLAXSLmGCGc2bHoNA6VH91BV86D5WhyNk/+JIUFkMOUxbXhwf0Sz+HICJQB6TLVt8gifoj75un8J3ikZal12x3z34vR7Llu0Q0OB/XIKzGirVJ6RvFTHWNLmCTVKs1O+Cfl81NG6bO/R0/Y/AuEQ+FksRTagVzDLFfJhGnJfipqEO+rDhg4b6Wr9RICldwIRitK4IlfQ65K8eCeC5RUHf5cqbB2HA0fYOgBVVV5lRs7ysfgIzZ2REmmZglvA98iUJaB1/ru7V2JavI1JH9vjkHvrXhatbeYkk4fKLXHK1HvixxjSskmeIcMRHuVYEydYvNwbeZ4ZyqhMoUk1UlU1vTGDR7nL5NjaEl5UV6ywsLRnuWCzVE4nxTTNvVSFki+kDyCdLsYkHS76D6s4GBFD8TAcMnFKCV1+92ogJcEyUauXaja1oQDLqBZmElLJ7+zu3YAT1O2A5oXQhfOSf5RZnG5gVWaWp+otH9JWYcJgr01hghM+IMEQbA4DWOibWkh/EnKRuyvbZQ+7KkcObJKT3SNNRuzsUj4A08Mvdrvn/dVamlvITfayiim7tznTUGenbo/KXe6YqiR8JuyxWBa2xDquwjMmRD6ohv8+L73IqMjZhGMSo7O8kqj+KDolSRsF2OeFdlm+2gFu67Biu1sjfaABL4lLe210B2fA==
X-Forefront-Antispam-Report:
	CIP:216.228.118.233;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc7edge2.nvidia.com;CAT:NONE;SFS:(13230031)(4636009)(376002)(396003)(346002)(136003)(39860400002)(230922051799003)(64100799003)(82310400011)(451199024)(1800799009)(186009)(40470700004)(36840700001)(46966006)(2906002)(5660300002)(41300700001)(6636002)(40480700001)(40460700003)(356005)(26005)(4326008)(82740400003)(7636003)(83380400001)(8676002)(70586007)(8936002)(107886003)(110136005)(54906003)(1076003)(6666004)(36860700001)(36756003)(2616005)(478600001)(7696005)(316002)(70206006)(426003)(86362001)(336012)(47076005)(2101003);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Oct 2023 16:00:48.6649
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 79ff22c6-02c7-47bd-6589-08dbd89837ee
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.118.233];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DS1PEPF00017099.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY5PR12MB6106

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


