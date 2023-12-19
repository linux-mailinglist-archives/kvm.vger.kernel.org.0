Return-Path: <kvm+bounces-4791-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id A78DD81848F
	for <lists+kvm@lfdr.de>; Tue, 19 Dec 2023 10:34:41 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 431C728517F
	for <lists+kvm@lfdr.de>; Tue, 19 Dec 2023 09:34:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6E10F13FF9;
	Tue, 19 Dec 2023 09:34:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="EO85a0xR"
X-Original-To: kvm@vger.kernel.org
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2065.outbound.protection.outlook.com [40.107.244.65])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 27A5213FEC
	for <kvm@vger.kernel.org>; Tue, 19 Dec 2023 09:34:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=HzWEADHesGUv3ZQDBrUutYn1gWohXsLZv13S5Wj5FqD0YyHHXdnjd3FJeVSrV7cg9igrAXSg5axXI/QM9gAbiGcBft3kxOOMlb5LyxRjqeRHDmAJoOJ+W6EvaZMHVAd7S1tVl7WjBrocdsCLJSvzIQixHbCyni9dx6t6u/1CZqBtI3KQPNxO5VFM/7PXGL+GWN0AKmjig3ebfo0S4pxNpzFcSDL5HgivbotrhemA1bPd+9MWlHvPO8jsnFzb0LTntbe0+XGA1tbYqV8FRtz1OuMaXXLr1t6IaHEzVa5wQDcIqmgnWVryog9laf25rXnvErH/PZFokPFI8y3Z7QV8fQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=tql1nsvIV4GqdKTlAiPSR+4iWnRRT9U1RRRI9/H9gYE=;
 b=iG3eDaAIdWH+oJCQIwIM7hC1M0/vuYgvpF95SRc7/pVbsIgfIiOzwq0L/LTcoENUBezUngCNZI2m017pmrHKUOJfqKvzpU+bfMBjGkiy7iXuGbpfQrfjkyxy/KqDvb6kYA32lB7WpIJr4uLcanzhdNKSHFJaqh5xUx6Q0wuotl5HWUUixS1sU3NyDBYF8hIcNxHEN9jq1AnZ34XteHtzCurqtfxaTx7UO7dZRhwaR58iyH4UIf8xm4jI/A3iDa8RUw3iRuJU98xGB30GZRJEkEQ2D/3gyf/enKUt6B9/YiGqteP8J5J3/Bx6aLszWeEcn9ZbeVIkLzfeHyDD55tx0Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.118.233) smtp.rcpttodomain=redhat.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=tql1nsvIV4GqdKTlAiPSR+4iWnRRT9U1RRRI9/H9gYE=;
 b=EO85a0xR/1sw2YoOV6DlfUanHRdu6XtEdPu8fbkEwj6UWV1YHbn4f8DIyaQlL63HfxdNYDIjLYfyPTgEhrmwvQVHHzXIsNn93lULWuRnstBLR7A8RPDKN93lldVwgsiPcFnv8SpmUMbhI7FrbnArIRcvFTct6WHK5h7f4PNgDb4MBYP0CAd7HuuwLjY32HURBuLER31Kcb3P8tbmhGJi5sKGTRxC2WUjITRqPL7Wc5778TDq1JMRvgIpKormdz2/XRfaH+VlfWGJPwEraI9CP/wU9Kcl9+EGtVGki/G1yOtU/CIIzMSk3gZw4VB5OCP3DT9wzSbHUSmXZJyFLBM9eg==
Received: from BL0PR03CA0009.namprd03.prod.outlook.com (2603:10b6:208:2d::22)
 by CO6PR12MB5412.namprd12.prod.outlook.com (2603:10b6:5:35e::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7113.18; Tue, 19 Dec
 2023 09:34:19 +0000
Received: from BL6PEPF0001AB59.namprd02.prod.outlook.com
 (2603:10b6:208:2d:cafe::57) by BL0PR03CA0009.outlook.office365.com
 (2603:10b6:208:2d::22) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7091.38 via Frontend
 Transport; Tue, 19 Dec 2023 09:34:18 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.118.233)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.118.233 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.118.233; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.118.233) by
 BL6PEPF0001AB59.mail.protection.outlook.com (10.167.241.11) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.7113.14 via Frontend Transport; Tue, 19 Dec 2023 09:34:18 +0000
Received: from drhqmail203.nvidia.com (10.126.190.182) by mail.nvidia.com
 (10.127.129.6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.41; Tue, 19 Dec
 2023 01:34:05 -0800
Received: from drhqmail202.nvidia.com (10.126.190.181) by
 drhqmail203.nvidia.com (10.126.190.182) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.986.41; Tue, 19 Dec 2023 01:34:05 -0800
Received: from vdi.nvidia.com (10.127.8.10) by mail.nvidia.com
 (10.126.190.181) with Microsoft SMTP Server id 15.2.986.41 via Frontend
 Transport; Tue, 19 Dec 2023 01:34:01 -0800
From: Yishai Hadas <yishaih@nvidia.com>
To: <alex.williamson@redhat.com>, <mst@redhat.com>, <jasowang@redhat.com>,
	<jgg@nvidia.com>
CC: <kvm@vger.kernel.org>, <virtualization@lists.linux-foundation.org>,
	<parav@nvidia.com>, <feliu@nvidia.com>, <jiri@nvidia.com>,
	<kevin.tian@intel.com>, <joao.m.martins@oracle.com>, <si-wei.liu@oracle.com>,
	<leonro@nvidia.com>, <yishaih@nvidia.com>, <maorg@nvidia.com>
Subject: [PATCH V10 vfio 5/9] virtio-pci: Initialize the supported admin commands
Date: Tue, 19 Dec 2023 11:32:43 +0200
Message-ID: <20231219093247.170936-6-yishaih@nvidia.com>
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
X-MS-TrafficTypeDiagnostic: BL6PEPF0001AB59:EE_|CO6PR12MB5412:EE_
X-MS-Office365-Filtering-Correlation-Id: 0ee7d784-11a7-4e35-38f2-08dc0075ac73
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	0MQBnYy6/vzX2/NXNnnGASL8m3YsFd5PVEsnk+p0/J7ImFkBHylDvmL72S4I+5Ms5EFpIoAltl1WX22XzT/8NPxD4ZQbROS4mnIMjNI3HHiuYrFEFK/UToILX3Dy5q+h51qjzzzofWrl4Anlu34vBnK6XCg+dIowdslTZ6iEUkXhC0DipbtGZPMfrd+xlIR2mHM1TiirD3FEPhBwgt7aaRd7CMmbRHNDbJ942b+DZDgSoJCjEtFZFJHxS6/G5G4BeC1WyC2WLJ/azvmjkIxPuK6VcnrO4NWy+2FCCVPQkB3URLejmfaI9m0BklnVkFxoy0TKBwyC15A97w9WyfBzkgXW/PCNKu/sw8gc06PfdXTyEYuLJNcpZZJ8kga5EES+QTDWNqDahBE4YdEa/9yM33lUtgkrE2y7pZZ/RcFRkOlA1Niw4QRx4dKDWKdywE7U5i/DbgiPCuQ1wI46ULfHx1JK26AsMRh1ONZIBcYcO3QC1Tb8mPiNxvM3dswiHcytQzjvIvyrs+Af4VZBLOUlxk8vJqoUi0+GchEY7+0LvdQMyGXIWgQ1AxrfVRzJsfnrG7+0rxwxdDJCiDximDVUQD6kE7ROsZrjI+nzlyczvlDAkYr7KfVhVnYg3d7zgt85TLwzOtUB03WMczH+vKnbL6ZtCxXGOFC/7wy4H39Br+E/gTpyuH8aTYKGDQJMD96gJukwUtIjY8npg96mJEXAAWZ/hRk/SM93gzfG8FcOt6j3zoilvG62fTLwaxIr9duC7aR0+ePFY/BAXtS/1PNt3g==
X-Forefront-Antispam-Report:
	CIP:216.228.118.233;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc7edge2.nvidia.com;CAT:NONE;SFS:(13230031)(4636009)(136003)(346002)(39860400002)(376002)(396003)(230922051799003)(1800799012)(451199024)(82310400011)(64100799003)(186009)(46966006)(40470700004)(36840700001)(4326008)(8936002)(8676002)(5660300002)(2906002)(7696005)(478600001)(6666004)(110136005)(70206006)(70586007)(54906003)(316002)(6636002)(41300700001)(356005)(7636003)(40480700001)(36860700001)(47076005)(86362001)(36756003)(82740400003)(40460700003)(107886003)(26005)(426003)(336012)(1076003)(2616005)(83380400001)(2101003);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Dec 2023 09:34:18.2455
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 0ee7d784-11a7-4e35-38f2-08dc0075ac73
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.118.233];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BL6PEPF0001AB59.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO6PR12MB5412

Initialize the supported admin commands upon activating the admin queue.

The supported commands are saved as part of the admin queue context.

Next patches in this series will expose APIs to use them.

Reviewed-by: Feng Liu <feliu@nvidia.com>
Acked-by: Michael S. Tsirkin <mst@redhat.com>
Signed-off-by: Yishai Hadas <yishaih@nvidia.com>
---
 drivers/virtio/virtio_pci_common.h |  1 +
 drivers/virtio/virtio_pci_modern.c | 48 ++++++++++++++++++++++++++++--
 2 files changed, 47 insertions(+), 2 deletions(-)

diff --git a/drivers/virtio/Kconfig b/drivers/virtio/Kconfig
index 0a53a61231c2..c17193544268 100644
--- a/drivers/virtio/Kconfig
+++ b/drivers/virtio/Kconfig
@@ -60,6 +60,11 @@ config VIRTIO_PCI
 
 	  If unsure, say M.
 
+config VIRTIO_PCI_ADMIN_LEGACY
+	bool
+	depends on VIRTIO_PCI && (X86 || COMPILE_TEST)
+	default y
+
 config VIRTIO_PCI_LEGACY
 	bool "Support for legacy virtio draft 0.9.X and older devices"
 	default y
diff --git a/drivers/virtio/virtio_pci_common.h b/drivers/virtio/virtio_pci_common.h
index 282d087a9266..a39bffd5fd46 100644
--- a/drivers/virtio/virtio_pci_common.h
+++ b/drivers/virtio/virtio_pci_common.h
@@ -47,6 +47,7 @@ struct virtio_pci_admin_vq {
 	struct virtio_pci_vq_info info;
 	/* serializing admin commands execution and virtqueue deletion */
 	struct mutex cmd_lock;
+	u64 supported_cmds;
 	/* Name of the admin queue: avq.$vq_index. */
 	char name[10];
 	u16 vq_index;
@@ -155,6 +156,24 @@ static inline void virtio_pci_legacy_remove(struct virtio_pci_device *vp_dev)
 int virtio_pci_modern_probe(struct virtio_pci_device *);
 void virtio_pci_modern_remove(struct virtio_pci_device *);
 
+#define VIRTIO_LEGACY_ADMIN_CMD_BITMAP \
+	(BIT_ULL(VIRTIO_ADMIN_CMD_LEGACY_COMMON_CFG_WRITE) | \
+	 BIT_ULL(VIRTIO_ADMIN_CMD_LEGACY_COMMON_CFG_READ) | \
+	 BIT_ULL(VIRTIO_ADMIN_CMD_LEGACY_DEV_CFG_WRITE) | \
+	 BIT_ULL(VIRTIO_ADMIN_CMD_LEGACY_DEV_CFG_READ) | \
+	 BIT_ULL(VIRTIO_ADMIN_CMD_LEGACY_NOTIFY_INFO))
+
+/* Unlike modern drivers which support hardware virtio devices, legacy drivers
+ * assume software-based devices: e.g. they don't use proper memory barriers
+ * on ARM, use big endian on PPC, etc. X86 drivers are mostly ok though, more
+ * or less by chance. For now, only support legacy IO on X86.
+ */
+#ifdef CONFIG_VIRTIO_PCI_ADMIN_LEGACY
+#define VIRTIO_ADMIN_CMD_BITMAP VIRTIO_LEGACY_ADMIN_CMD_BITMAP
+#else
+#define VIRTIO_ADMIN_CMD_BITMAP 0
+#endif
+
 int vp_modern_admin_cmd_exec(struct virtio_device *vdev,
 			     struct virtio_admin_cmd *cmd);
 
diff --git a/drivers/virtio/virtio_pci_modern.c b/drivers/virtio/virtio_pci_modern.c
index 9bd66300a80a..f62b530aa3b5 100644
--- a/drivers/virtio/virtio_pci_modern.c
+++ b/drivers/virtio/virtio_pci_modern.c
@@ -39,6 +39,7 @@ static bool vp_is_avq(struct virtio_device *vdev, unsigned int index)
 }
 
 static int virtqueue_exec_admin_cmd(struct virtio_pci_admin_vq *admin_vq,
+				    u16 opcode,
 				    struct scatterlist **sgs,
 				    unsigned int out_num,
 				    unsigned int in_num,
@@ -51,6 +52,11 @@ static int virtqueue_exec_admin_cmd(struct virtio_pci_admin_vq *admin_vq,
 	if (!vq)
 		return -EIO;
 
+	if (opcode != VIRTIO_ADMIN_CMD_LIST_QUERY &&
+	    opcode != VIRTIO_ADMIN_CMD_LIST_USE &&
+	    !((1ULL << opcode) & admin_vq->supported_cmds))
+		return -EOPNOTSUPP;
+
 	ret = virtqueue_add_sgs(vq, sgs, out_num, in_num, data, GFP_KERNEL);
 	if (ret < 0)
 		return -EIO;
@@ -117,8 +123,9 @@ int vp_modern_admin_cmd_exec(struct virtio_device *vdev,
 	}
 
 	mutex_lock(&vp_dev->admin_vq.cmd_lock);
-	ret = virtqueue_exec_admin_cmd(&vp_dev->admin_vq, sgs,
-				       out_num, in_num, sgs);
+	ret = virtqueue_exec_admin_cmd(&vp_dev->admin_vq,
+				       le16_to_cpu(cmd->opcode),
+				       sgs, out_num, in_num, sgs);
 	mutex_unlock(&vp_dev->admin_vq.cmd_lock);
 
 	if (ret) {
@@ -142,6 +149,43 @@ int vp_modern_admin_cmd_exec(struct virtio_device *vdev,
 	return ret;
 }
 
+static void virtio_pci_admin_cmd_list_init(struct virtio_device *virtio_dev)
+{
+	struct virtio_pci_device *vp_dev = to_vp_device(virtio_dev);
+	struct virtio_admin_cmd cmd = {};
+	struct scatterlist result_sg;
+	struct scatterlist data_sg;
+	__le64 *data;
+	int ret;
+
+	data = kzalloc(sizeof(*data), GFP_KERNEL);
+	if (!data)
+		return;
+
+	sg_init_one(&result_sg, data, sizeof(*data));
+	cmd.opcode = cpu_to_le16(VIRTIO_ADMIN_CMD_LIST_QUERY);
+	cmd.group_type = cpu_to_le16(VIRTIO_ADMIN_GROUP_TYPE_SRIOV);
+	cmd.result_sg = &result_sg;
+
+	ret = vp_modern_admin_cmd_exec(virtio_dev, &cmd);
+	if (ret)
+		goto end;
+
+	*data &= cpu_to_le64(VIRTIO_ADMIN_CMD_BITMAP);
+	sg_init_one(&data_sg, data, sizeof(*data));
+	cmd.opcode = cpu_to_le16(VIRTIO_ADMIN_CMD_LIST_USE);
+	cmd.data_sg = &data_sg;
+	cmd.result_sg = NULL;
+
+	ret = vp_modern_admin_cmd_exec(virtio_dev, &cmd);
+	if (ret)
+		goto end;
+
+	vp_dev->admin_vq.supported_cmds = le64_to_cpu(*data);
+end:
+	kfree(data);
+}
+
 static void vp_modern_avq_activate(struct virtio_device *vdev)
 {
 	struct virtio_pci_device *vp_dev = to_vp_device(vdev);
@@ -151,6 +195,7 @@ static void vp_modern_avq_activate(struct virtio_device *vdev)
 		return;
 
 	__virtqueue_unbreak(admin_vq->info.vq);
+	virtio_pci_admin_cmd_list_init(vdev);
 }
 
 static void vp_modern_avq_deactivate(struct virtio_device *vdev)
-- 
2.27.0


