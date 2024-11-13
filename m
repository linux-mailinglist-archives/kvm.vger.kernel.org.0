Return-Path: <kvm+bounces-31730-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 787E89C6E54
	for <lists+kvm@lfdr.de>; Wed, 13 Nov 2024 12:55:59 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 8E2B4B27DD4
	for <lists+kvm@lfdr.de>; Wed, 13 Nov 2024 11:55:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 107EF2036F2;
	Wed, 13 Nov 2024 11:53:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="ecsB16Rh"
X-Original-To: kvm@vger.kernel.org
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2044.outbound.protection.outlook.com [40.107.93.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1949020264A
	for <kvm@vger.kernel.org>; Wed, 13 Nov 2024 11:53:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.93.44
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731498792; cv=fail; b=IdyduG2iz0tItArGhXyyBhGQPUbYLCXF10OZ0D4coCTtZLd21J9c3Htwddqm66Vc7q+vCm6EAZSi58DW+tVXBu7SBVsiJk6M6uiHC54Vm1raUuynJH4j424FSBcQKaXOpD7sustvAeVDZQWhE73dGFIZjAPTyvYGgq150R6QRQs=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731498792; c=relaxed/simple;
	bh=QYGMKAMl8mTsCS6jHu129ITEZw1xUMTxBUAweAW3Gqs=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Plvp2RSj2FYY7Hn9hXvsSosRbv4HPEWV3A6WG/hNJdvrKEIG6QWnRZY0m0z84UNSh6UNxL1rPFDFPJ4VXNSzRspOqHjRHpK5mQcXzTkWNpF71zmsKoWSbkEFjflkoN63Mep4kI42T//UtTm2GHLq/C1BJn8N2v98RmCQPkaWsco=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=ecsB16Rh; arc=fail smtp.client-ip=40.107.93.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=gwrzkbkqlw5l3SoCF5H4pAFCUTRHRVomXr+U5xnubeVhky9qZ/H5wvbdglVpFeKPfP+Z1/ZcufTgBYJbWpPaCxsZtNakv1POA1xFTgwD569gj1Ev5SwZM7E98kSEiYZoxwuRDlfZ1Sm7PxIyHwBb88LihDKzCDXE5M3aP+N44s5sSSTJJh54OkRobX+K4abDNgSgM9mBs5+PsSxJ5j3cosp+IK+Thb77yVaSqln+FCH6twTtsuICAuCfzyDA3g6cSmOgdMKsvCx/ls2bmtxzA/zEsv/yrbxRqcinmw9YerMATCbmvhRfn5mm1eMR76xC1o5pwYDGHtVarsSpfSJvDw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=AnmjS5Ws8pOTnu3tw1SCuin/i2X1p8HKm4b/6Fk3VPM=;
 b=RgNMPT3IyKLm1qBGTWOOd6Ssh4UQ1b78apjzfOfj7Z0fhy2MviWNkBk45v7giN5HZr4xNtVdat0LpG4hh5pgr/S/nC2xC5BjO7dByWfDv9rA4pO8QBqF97qbktzcVTw4Ks/IkVoo7ZFT97b2JEcWY/FBnblHq/GMyoUx42BbAFlrMBOv9pF73MLw2ZKuAWp36hgObYDoR8QOcL78YXnCL/QUNREE41fpVDJ5dDqfUUudB8xd4qGZjUevZ00a7YK2te4jR1JSSIiYkshvEOldciQiyKgDl90IPksaGxnEynEIH6CnByfYaW0MticsqNCSK47i24BruSN0K3zK2flHAw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=redhat.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=AnmjS5Ws8pOTnu3tw1SCuin/i2X1p8HKm4b/6Fk3VPM=;
 b=ecsB16Rhc4M7dx30gP2zfKy5H2m72zdaD24UPWgF8LC1C+7rzoypctZ/bhh68INzYe6mIv6InGPSSESnXXdwrOMi1e0piIbMxCq6ZC+n11QvxrPAQwR8x3hxR8yx4Sz121CuhDsN3iq6S4hLYOLxKjyC+r1c4uH6CIRpoF+lUwjptABtzOhwQCCnZ7cuFS9W5ZolGqeBPYY6oAA/vwzyySVn1XvrI4dIPNwH/Ed3kO9R6AUWTQ/uc2y5yPjYx2GU9ITLZnYinQXq2zK1VdJD9hegkMlwD2oWUubEVHg3y4CszUO7MGJFOBkAjb/RUghoofJnvzRZJWu0x3XK8W8Cqw==
Received: from SN7PR18CA0011.namprd18.prod.outlook.com (2603:10b6:806:f3::19)
 by SJ2PR12MB9137.namprd12.prod.outlook.com (2603:10b6:a03:562::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8137.28; Wed, 13 Nov
 2024 11:53:04 +0000
Received: from SA2PEPF000015CA.namprd03.prod.outlook.com
 (2603:10b6:806:f3:cafe::ae) by SN7PR18CA0011.outlook.office365.com
 (2603:10b6:806:f3::19) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8137.27 via Frontend
 Transport; Wed, 13 Nov 2024 11:53:04 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.160)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 SA2PEPF000015CA.mail.protection.outlook.com (10.167.241.200) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8158.14 via Frontend Transport; Wed, 13 Nov 2024 11:53:03 +0000
Received: from rnnvmail205.nvidia.com (10.129.68.10) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4; Wed, 13 Nov
 2024 03:52:55 -0800
Received: from rnnvmail202.nvidia.com (10.129.68.7) by rnnvmail205.nvidia.com
 (10.129.68.10) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4; Wed, 13 Nov
 2024 03:52:54 -0800
Received: from vdi.nvidia.com (10.127.8.10) by mail.nvidia.com (10.129.68.7)
 with Microsoft SMTP Server id 15.2.1544.4 via Frontend Transport; Wed, 13 Nov
 2024 03:52:51 -0800
From: Yishai Hadas <yishaih@nvidia.com>
To: <alex.williamson@redhat.com>, <mst@redhat.com>, <jasowang@redhat.com>,
	<jgg@nvidia.com>
CC: <kvm@vger.kernel.org>, <virtualization@lists.linux-foundation.org>,
	<parav@nvidia.com>, <feliu@nvidia.com>, <kevin.tian@intel.com>,
	<joao.m.martins@oracle.com>, <leonro@nvidia.com>, <yishaih@nvidia.com>,
	<maorg@nvidia.com>
Subject: [PATCH V4 vfio 4/7] virtio-pci: Introduce APIs to execute device parts admin commands
Date: Wed, 13 Nov 2024 13:51:57 +0200
Message-ID: <20241113115200.209269-5-yishaih@nvidia.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20241113115200.209269-1-yishaih@nvidia.com>
References: <20241113115200.209269-1-yishaih@nvidia.com>
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
X-MS-TrafficTypeDiagnostic: SA2PEPF000015CA:EE_|SJ2PR12MB9137:EE_
X-MS-Office365-Filtering-Correlation-Id: 9e7c1c93-d231-4e23-624d-08dd03d9bb3e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|36860700013|1800799024|376014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?8KoHBtyn6yW2JD62Zug+ABFcmYtYcyGrgWcRu63gNlKab09e/xxmIRy6tbhE?=
 =?us-ascii?Q?oC5aBcUpAPbnMhjfbtYCmrKR7IGdfiO6AA1Yd2Kidhb2EjxDXmUwgUwBks0x?=
 =?us-ascii?Q?6xSxKwgljOugWfn/C/hsktMbKyjjGSqc4UU8jnHdlyvf1Q3KBfRTRjs+bDBK?=
 =?us-ascii?Q?kYqOj5MjWhpU4acoRf26vx8wceeun6aNUkrTBCwGcv6/0U3oWlxY8WAHt/iX?=
 =?us-ascii?Q?VOWrgW5AnLMCpe7FHWf9IXqU+SjmJu5qF9dpkzqy5+UB+DirAK9oY98gWpGx?=
 =?us-ascii?Q?P+qSn8+HOkrY3v3TnVfiEc1QWheUfR2zZyGfpo4fStMI1AKVUb/XVO+JZ8Fa?=
 =?us-ascii?Q?/epSzcMOU8BriJ4LRBN5h62BRJ/OFEAQ72Y1CUKGFQ3ZbrPxA+mjV5hZ1owX?=
 =?us-ascii?Q?bm1hPmpHGsOr1xZXCANNpsWwDbBGRIH/8jWby3Np4kfRFwwd2Gr6/ltmzPn2?=
 =?us-ascii?Q?NSWYzOO5sq2EKMdeN0r58f/dIWoHjNUu4RZ0LVm2nHVLCR+9h/t2hzmsdTBJ?=
 =?us-ascii?Q?Dvt/2pRQdXXXuAWvEnAWN2NuENXMJxpKcJ7MDqHz29EvTUQ6ejjbIvW4hr97?=
 =?us-ascii?Q?guJ8jE+tYdn/q6P71MrDjToNeLCVvyXY23VLLv29DQ1wkBuf+LYTEJndp29I?=
 =?us-ascii?Q?mCjfwPnQX1xaaEFNPx0Ti0bTu2V6NAPBC3NUYzqYqMNl9vbqogkPnc2N4Msp?=
 =?us-ascii?Q?BqMIO4OtsfXE6maNjOEUXbbcf48R8WFUkhvSRwEHYwLect9nukXCiQqFEOZ1?=
 =?us-ascii?Q?wl/KNqUo/ND+ISssNv9GwqG8O7VbxuLa3RN4F6H1KfBTz1CEoBQGHq2+tldT?=
 =?us-ascii?Q?MKISj/8qr7EeLve4QlToqqzEuLTHPYSyBUURpeFIUYQhEjQttR9Xx4q6Q0Lt?=
 =?us-ascii?Q?nMjYH15eOIICirnLkJkv/rCZpatEF+J65uInTfOzpUe31R994fMpb1oIeGp5?=
 =?us-ascii?Q?OjIrDGbWAiLEADJkDHmlsMs+4Lj88fhtSRrWjCpstHiPx6l3FJqCBWnKAlTe?=
 =?us-ascii?Q?aCxuz+wxDfHkrfSJyUyEJ3VoZhdEMlxkgRFbX7+3EoXlDoSSGmAtsyTIwweh?=
 =?us-ascii?Q?1YAWlc8aNJNRgIq0XEE9h5zUFfDChK1BD1xR3Sek80jwkHG2JJzhqDCZE+Zy?=
 =?us-ascii?Q?OyDEqqfS6YOOQk2Wnq0tl5cLAhB5B116sZ+Fwz/7MaMXyeKaFeO5k1sVVeGt?=
 =?us-ascii?Q?VJf70t0CI91kJQ7q1xvByCyR5CJsLFh5RAIvTC1rez2A+bEms9u5q12C/NbW?=
 =?us-ascii?Q?pc2iBf9y/JYJP/TrQXVWg8Rltbff3wKPXtL0T1l0xsYHacqJef28le1TnKV0?=
 =?us-ascii?Q?h9KTSe/teoM3lMGlPz7bfi69YufAaDQt8g+GSwH8J3fH9JFb3V/3OeQWeplN?=
 =?us-ascii?Q?ossBmGAJbpH6Ji2XHRxOlPmaUfIa4hs0xf7W266dfxYjYK71OQ=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230040)(82310400026)(36860700013)(1800799024)(376014);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Nov 2024 11:53:03.9442
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 9e7c1c93-d231-4e23-624d-08dd03d9bb3e
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SA2PEPF000015CA.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ2PR12MB9137

Introduce APIs to handle the execution of device parts admin commands.

These APIs cover functionalities such as mode setting, object creation
and destruction, and operations like parts get/set and metadata
retrieval.

These APIs will be utilized in upcoming patches within this series.

Acked-by: Michael S. Tsirkin <mst@redhat.com>
Signed-off-by: Yishai Hadas <yishaih@nvidia.com>
---
 drivers/virtio/virtio_pci_common.h |   8 +-
 drivers/virtio/virtio_pci_modern.c | 348 +++++++++++++++++++++++++++++
 include/linux/virtio_pci_admin.h   |  11 +
 3 files changed, 366 insertions(+), 1 deletion(-)

diff --git a/drivers/virtio/virtio_pci_common.h b/drivers/virtio/virtio_pci_common.h
index 04b1d17663b3..0d00740cca07 100644
--- a/drivers/virtio/virtio_pci_common.h
+++ b/drivers/virtio/virtio_pci_common.h
@@ -173,7 +173,13 @@ struct virtio_device *virtio_pci_vf_get_pf_dev(struct pci_dev *pdev);
 #define VIRTIO_DEV_PARTS_ADMIN_CMD_BITMAP \
 	(BIT_ULL(VIRTIO_ADMIN_CMD_CAP_ID_LIST_QUERY) | \
 	 BIT_ULL(VIRTIO_ADMIN_CMD_DRIVER_CAP_SET) | \
-	 BIT_ULL(VIRTIO_ADMIN_CMD_DEVICE_CAP_GET))
+	 BIT_ULL(VIRTIO_ADMIN_CMD_DEVICE_CAP_GET) | \
+	 BIT_ULL(VIRTIO_ADMIN_CMD_RESOURCE_OBJ_CREATE) | \
+	 BIT_ULL(VIRTIO_ADMIN_CMD_RESOURCE_OBJ_DESTROY) | \
+	 BIT_ULL(VIRTIO_ADMIN_CMD_DEV_PARTS_METADATA_GET) | \
+	 BIT_ULL(VIRTIO_ADMIN_CMD_DEV_PARTS_GET) | \
+	 BIT_ULL(VIRTIO_ADMIN_CMD_DEV_PARTS_SET) | \
+	 BIT_ULL(VIRTIO_ADMIN_CMD_DEV_MODE_SET))
 
 /* Unlike modern drivers which support hardware virtio devices, legacy drivers
  * assume software-based devices: e.g. they don't use proper memory barriers
diff --git a/drivers/virtio/virtio_pci_modern.c b/drivers/virtio/virtio_pci_modern.c
index 8ddac2829bc8..3f5aba71cfde 100644
--- a/drivers/virtio/virtio_pci_modern.c
+++ b/drivers/virtio/virtio_pci_modern.c
@@ -15,6 +15,7 @@
  */
 
 #include <linux/delay.h>
+#include <linux/virtio_pci_admin.h>
 #define VIRTIO_PCI_NO_LEGACY
 #define VIRTIO_RING_NO_LEGACY
 #include "virtio_pci_common.h"
@@ -875,6 +876,353 @@ static bool vp_get_shm_region(struct virtio_device *vdev,
 	return true;
 }
 
+/*
+ * virtio_pci_admin_has_dev_parts - Checks whether the device parts
+ * functionality is supported
+ * @pdev: VF pci_dev
+ *
+ * Returns true on success.
+ */
+bool virtio_pci_admin_has_dev_parts(struct pci_dev *pdev)
+{
+	struct virtio_device *virtio_dev = virtio_pci_vf_get_pf_dev(pdev);
+	struct virtio_pci_device *vp_dev;
+
+	if (!virtio_dev)
+		return false;
+
+	if (!virtio_has_feature(virtio_dev, VIRTIO_F_ADMIN_VQ))
+		return false;
+
+	vp_dev = to_vp_device(virtio_dev);
+
+	if (!((vp_dev->admin_vq.supported_cmds & VIRTIO_DEV_PARTS_ADMIN_CMD_BITMAP) ==
+		VIRTIO_DEV_PARTS_ADMIN_CMD_BITMAP))
+		return false;
+
+	return vp_dev->admin_vq.max_dev_parts_objects;
+}
+EXPORT_SYMBOL_GPL(virtio_pci_admin_has_dev_parts);
+
+/*
+ * virtio_pci_admin_mode_set - Sets the mode of a member device
+ * @pdev: VF pci_dev
+ * @flags: device mode's flags
+ *
+ * Note: caller must serialize access for the given device.
+ * Returns 0 on success, or negative on failure.
+ */
+int virtio_pci_admin_mode_set(struct pci_dev *pdev, u8 flags)
+{
+	struct virtio_device *virtio_dev = virtio_pci_vf_get_pf_dev(pdev);
+	struct virtio_admin_cmd_dev_mode_set_data *data;
+	struct virtio_admin_cmd cmd = {};
+	struct scatterlist data_sg;
+	int vf_id;
+	int ret;
+
+	if (!virtio_dev)
+		return -ENODEV;
+
+	vf_id = pci_iov_vf_id(pdev);
+	if (vf_id < 0)
+		return vf_id;
+
+	data = kzalloc(sizeof(*data), GFP_KERNEL);
+	if (!data)
+		return -ENOMEM;
+
+	data->flags = flags;
+	sg_init_one(&data_sg, data, sizeof(*data));
+	cmd.opcode = cpu_to_le16(VIRTIO_ADMIN_CMD_DEV_MODE_SET);
+	cmd.group_type = cpu_to_le16(VIRTIO_ADMIN_GROUP_TYPE_SRIOV);
+	cmd.group_member_id = cpu_to_le64(vf_id + 1);
+	cmd.data_sg = &data_sg;
+	ret = vp_modern_admin_cmd_exec(virtio_dev, &cmd);
+
+	kfree(data);
+	return ret;
+}
+EXPORT_SYMBOL_GPL(virtio_pci_admin_mode_set);
+
+/*
+ * virtio_pci_admin_obj_create - Creates an object for a given type and operation,
+ * following the max objects that can be created for that request.
+ * @pdev: VF pci_dev
+ * @obj_type: Object type
+ * @operation_type: Operation type
+ * @obj_id: Output unique object id
+ *
+ * Note: caller must serialize access for the given device.
+ * Returns 0 on success, or negative on failure.
+ */
+int virtio_pci_admin_obj_create(struct pci_dev *pdev, u16 obj_type, u8 operation_type,
+				u32 *obj_id)
+{
+	struct virtio_device *virtio_dev = virtio_pci_vf_get_pf_dev(pdev);
+	u16 data_size = sizeof(struct virtio_admin_cmd_resource_obj_create_data);
+	struct virtio_admin_cmd_resource_obj_create_data *obj_create_data;
+	struct virtio_resource_obj_dev_parts obj_dev_parts = {};
+	struct virtio_pci_admin_vq *avq;
+	struct virtio_admin_cmd cmd = {};
+	struct scatterlist data_sg;
+	void *data;
+	int id = -1;
+	int vf_id;
+	int ret;
+
+	if (!virtio_dev)
+		return -ENODEV;
+
+	vf_id = pci_iov_vf_id(pdev);
+	if (vf_id < 0)
+		return vf_id;
+
+	if (obj_type != VIRTIO_RESOURCE_OBJ_DEV_PARTS)
+		return -EOPNOTSUPP;
+
+	if (operation_type != VIRTIO_RESOURCE_OBJ_DEV_PARTS_TYPE_GET &&
+	    operation_type != VIRTIO_RESOURCE_OBJ_DEV_PARTS_TYPE_SET)
+		return -EINVAL;
+
+	avq = &to_vp_device(virtio_dev)->admin_vq;
+	if (!avq->max_dev_parts_objects)
+		return -EOPNOTSUPP;
+
+	id = ida_alloc_range(&avq->dev_parts_ida, 0,
+			     avq->max_dev_parts_objects - 1, GFP_KERNEL);
+	if (id < 0)
+		return id;
+
+	*obj_id = id;
+	data_size += sizeof(obj_dev_parts);
+	data = kzalloc(data_size, GFP_KERNEL);
+	if (!data) {
+		ret = -ENOMEM;
+		goto end;
+	}
+
+	obj_create_data = data;
+	obj_create_data->hdr.type = cpu_to_le16(obj_type);
+	obj_create_data->hdr.id = cpu_to_le32(*obj_id);
+	obj_dev_parts.type = operation_type;
+	memcpy(obj_create_data->resource_obj_specific_data, &obj_dev_parts,
+	       sizeof(obj_dev_parts));
+	sg_init_one(&data_sg, data, data_size);
+	cmd.opcode = cpu_to_le16(VIRTIO_ADMIN_CMD_RESOURCE_OBJ_CREATE);
+	cmd.group_type = cpu_to_le16(VIRTIO_ADMIN_GROUP_TYPE_SRIOV);
+	cmd.group_member_id = cpu_to_le64(vf_id + 1);
+	cmd.data_sg = &data_sg;
+	ret = vp_modern_admin_cmd_exec(virtio_dev, &cmd);
+
+	kfree(data);
+end:
+	if (ret)
+		ida_free(&avq->dev_parts_ida, id);
+
+	return ret;
+}
+EXPORT_SYMBOL_GPL(virtio_pci_admin_obj_create);
+
+/*
+ * virtio_pci_admin_obj_destroy - Destroys an object of a given type and id
+ * @pdev: VF pci_dev
+ * @obj_type: Object type
+ * @id: Object id
+ *
+ * Note: caller must serialize access for the given device.
+ * Returns 0 on success, or negative on failure.
+ */
+int virtio_pci_admin_obj_destroy(struct pci_dev *pdev, u16 obj_type, u32 id)
+{
+	struct virtio_device *virtio_dev = virtio_pci_vf_get_pf_dev(pdev);
+	struct virtio_admin_cmd_resource_obj_cmd_hdr *data;
+	struct virtio_pci_device *vp_dev;
+	struct virtio_admin_cmd cmd = {};
+	struct scatterlist data_sg;
+	int vf_id;
+	int ret;
+
+	if (!virtio_dev)
+		return -ENODEV;
+
+	vf_id = pci_iov_vf_id(pdev);
+	if (vf_id < 0)
+		return vf_id;
+
+	if (obj_type != VIRTIO_RESOURCE_OBJ_DEV_PARTS)
+		return -EINVAL;
+
+	data = kzalloc(sizeof(*data), GFP_KERNEL);
+	if (!data)
+		return -ENOMEM;
+
+	data->type = cpu_to_le16(obj_type);
+	data->id = cpu_to_le32(id);
+	sg_init_one(&data_sg, data, sizeof(*data));
+	cmd.opcode = cpu_to_le16(VIRTIO_ADMIN_CMD_RESOURCE_OBJ_DESTROY);
+	cmd.group_type = cpu_to_le16(VIRTIO_ADMIN_GROUP_TYPE_SRIOV);
+	cmd.group_member_id = cpu_to_le64(vf_id + 1);
+	cmd.data_sg = &data_sg;
+	ret = vp_modern_admin_cmd_exec(virtio_dev, &cmd);
+	if (!ret) {
+		vp_dev = to_vp_device(virtio_dev);
+		ida_free(&vp_dev->admin_vq.dev_parts_ida, id);
+	}
+
+	kfree(data);
+	return ret;
+}
+EXPORT_SYMBOL_GPL(virtio_pci_admin_obj_destroy);
+
+/*
+ * virtio_pci_admin_dev_parts_metadata_get - Gets the metadata of the device parts
+ * identified by the below attributes.
+ * @pdev: VF pci_dev
+ * @obj_type: Object type
+ * @id: Object id
+ * @metadata_type: Metadata type
+ * @out: Upon success holds the output for 'metadata type size'
+ *
+ * Note: caller must serialize access for the given device.
+ * Returns 0 on success, or negative on failure.
+ */
+int virtio_pci_admin_dev_parts_metadata_get(struct pci_dev *pdev, u16 obj_type,
+					    u32 id, u8 metadata_type, u32 *out)
+{
+	struct virtio_device *virtio_dev = virtio_pci_vf_get_pf_dev(pdev);
+	struct virtio_admin_cmd_dev_parts_metadata_result *result;
+	struct virtio_admin_cmd_dev_parts_metadata_data *data;
+	struct scatterlist data_sg, result_sg;
+	struct virtio_admin_cmd cmd = {};
+	int vf_id;
+	int ret;
+
+	if (!virtio_dev)
+		return -ENODEV;
+
+	if (metadata_type != VIRTIO_ADMIN_CMD_DEV_PARTS_METADATA_TYPE_SIZE)
+		return -EOPNOTSUPP;
+
+	vf_id = pci_iov_vf_id(pdev);
+	if (vf_id < 0)
+		return vf_id;
+
+	data = kzalloc(sizeof(*data), GFP_KERNEL);
+	if (!data)
+		return -ENOMEM;
+
+	result = kzalloc(sizeof(*result), GFP_KERNEL);
+	if (!result) {
+		ret = -ENOMEM;
+		goto end;
+	}
+
+	data->hdr.type = cpu_to_le16(obj_type);
+	data->hdr.id = cpu_to_le32(id);
+	data->type = metadata_type;
+	sg_init_one(&data_sg, data, sizeof(*data));
+	sg_init_one(&result_sg, result, sizeof(*result));
+	cmd.opcode = cpu_to_le16(VIRTIO_ADMIN_CMD_DEV_PARTS_METADATA_GET);
+	cmd.group_type = cpu_to_le16(VIRTIO_ADMIN_GROUP_TYPE_SRIOV);
+	cmd.group_member_id = cpu_to_le64(vf_id + 1);
+	cmd.data_sg = &data_sg;
+	cmd.result_sg = &result_sg;
+	ret = vp_modern_admin_cmd_exec(virtio_dev, &cmd);
+	if (!ret)
+		*out = le32_to_cpu(result->parts_size.size);
+
+	kfree(result);
+end:
+	kfree(data);
+	return ret;
+}
+EXPORT_SYMBOL_GPL(virtio_pci_admin_dev_parts_metadata_get);
+
+/*
+ * virtio_pci_admin_dev_parts_get - Gets the device parts identified by the below attributes.
+ * @pdev: VF pci_dev
+ * @obj_type: Object type
+ * @id: Object id
+ * @get_type: Get type
+ * @res_sg: Upon success holds the output result data
+ * @res_size: Upon success holds the output result size
+ *
+ * Note: caller must serialize access for the given device.
+ * Returns 0 on success, or negative on failure.
+ */
+int virtio_pci_admin_dev_parts_get(struct pci_dev *pdev, u16 obj_type, u32 id,
+				   u8 get_type, struct scatterlist *res_sg,
+				   u32 *res_size)
+{
+	struct virtio_device *virtio_dev = virtio_pci_vf_get_pf_dev(pdev);
+	struct virtio_admin_cmd_dev_parts_get_data *data;
+	struct scatterlist data_sg;
+	struct virtio_admin_cmd cmd = {};
+	int vf_id;
+	int ret;
+
+	if (!virtio_dev)
+		return -ENODEV;
+
+	if (get_type != VIRTIO_ADMIN_CMD_DEV_PARTS_GET_TYPE_ALL)
+		return -EOPNOTSUPP;
+
+	vf_id = pci_iov_vf_id(pdev);
+	if (vf_id < 0)
+		return vf_id;
+
+	data = kzalloc(sizeof(*data), GFP_KERNEL);
+	if (!data)
+		return -ENOMEM;
+
+	data->hdr.type = cpu_to_le16(obj_type);
+	data->hdr.id = cpu_to_le32(id);
+	data->type = get_type;
+	sg_init_one(&data_sg, data, sizeof(*data));
+	cmd.opcode = cpu_to_le16(VIRTIO_ADMIN_CMD_DEV_PARTS_GET);
+	cmd.group_type = cpu_to_le16(VIRTIO_ADMIN_GROUP_TYPE_SRIOV);
+	cmd.group_member_id = cpu_to_le64(vf_id + 1);
+	cmd.data_sg = &data_sg;
+	cmd.result_sg = res_sg;
+	ret = vp_modern_admin_cmd_exec(virtio_dev, &cmd);
+	if (!ret)
+		*res_size = cmd.result_sg_size;
+
+	kfree(data);
+	return ret;
+}
+EXPORT_SYMBOL_GPL(virtio_pci_admin_dev_parts_get);
+
+/*
+ * virtio_pci_admin_dev_parts_set - Sets the device parts identified by the below attributes.
+ * @pdev: VF pci_dev
+ * @data_sg: The device parts data, its layout follows struct virtio_admin_cmd_dev_parts_set_data
+ *
+ * Note: caller must serialize access for the given device.
+ * Returns 0 on success, or negative on failure.
+ */
+int virtio_pci_admin_dev_parts_set(struct pci_dev *pdev, struct scatterlist *data_sg)
+{
+	struct virtio_device *virtio_dev = virtio_pci_vf_get_pf_dev(pdev);
+	struct virtio_admin_cmd cmd = {};
+	int vf_id;
+
+	if (!virtio_dev)
+		return -ENODEV;
+
+	vf_id = pci_iov_vf_id(pdev);
+	if (vf_id < 0)
+		return vf_id;
+
+	cmd.opcode = cpu_to_le16(VIRTIO_ADMIN_CMD_DEV_PARTS_SET);
+	cmd.group_type = cpu_to_le16(VIRTIO_ADMIN_GROUP_TYPE_SRIOV);
+	cmd.group_member_id = cpu_to_le64(vf_id + 1);
+	cmd.data_sg = data_sg;
+	return vp_modern_admin_cmd_exec(virtio_dev, &cmd);
+}
+EXPORT_SYMBOL_GPL(virtio_pci_admin_dev_parts_set);
+
 static const struct virtio_config_ops virtio_pci_config_nodev_ops = {
 	.get		= NULL,
 	.set		= NULL,
diff --git a/include/linux/virtio_pci_admin.h b/include/linux/virtio_pci_admin.h
index f4a100a0fe2e..dffc92c17ad2 100644
--- a/include/linux/virtio_pci_admin.h
+++ b/include/linux/virtio_pci_admin.h
@@ -20,4 +20,15 @@ int virtio_pci_admin_legacy_io_notify_info(struct pci_dev *pdev,
 					   u64 *bar_offset);
 #endif
 
+bool virtio_pci_admin_has_dev_parts(struct pci_dev *pdev);
+int virtio_pci_admin_mode_set(struct pci_dev *pdev, u8 mode);
+int virtio_pci_admin_obj_create(struct pci_dev *pdev, u16 obj_type, u8 operation_type,
+				u32 *obj_id);
+int virtio_pci_admin_obj_destroy(struct pci_dev *pdev, u16 obj_type, u32 id);
+int virtio_pci_admin_dev_parts_metadata_get(struct pci_dev *pdev, u16 obj_type,
+					    u32 id, u8 metadata_type, u32 *out);
+int virtio_pci_admin_dev_parts_get(struct pci_dev *pdev, u16 obj_type, u32 id,
+				   u8 get_type, struct scatterlist *res_sg, u32 *res_size);
+int virtio_pci_admin_dev_parts_set(struct pci_dev *pdev, struct scatterlist *data_sg);
+
 #endif /* _LINUX_VIRTIO_PCI_ADMIN_H */
-- 
2.27.0


