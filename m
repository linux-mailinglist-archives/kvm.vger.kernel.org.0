Return-Path: <kvm+bounces-31417-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 1D7EF9C39E5
	for <lists+kvm@lfdr.de>; Mon, 11 Nov 2024 09:44:06 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id A391B1F221F8
	for <lists+kvm@lfdr.de>; Mon, 11 Nov 2024 08:44:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 06EE9175D26;
	Mon, 11 Nov 2024 08:43:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="TVda9pYs"
X-Original-To: kvm@vger.kernel.org
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2079.outbound.protection.outlook.com [40.107.243.79])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 20778171E5F
	for <kvm@vger.kernel.org>; Mon, 11 Nov 2024 08:43:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.243.79
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731314587; cv=fail; b=Q8p8ai25eG34onYYZZ5mEEdYeGhcFvKxB8iOYjMBFBGUpiMwvH1MJlRgcTbWxhRv0PHlT6Co01yakceB1GJBeHQf/ATnNJEKnda2Civoj6nIIb0ohT1Sjg27seZ6TUBUNSv4OfrxASvKOrXFlysDFXTDiVO4GXgSQE/l+xu58cA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731314587; c=relaxed/simple;
	bh=QYGMKAMl8mTsCS6jHu129ITEZw1xUMTxBUAweAW3Gqs=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=sEFoRtKOAC2hyyF0QgNegknbJd+QYYUDyltMwy1W6lY+CleR0zpYwxcQQ5Xye+Bvh4CdCBBNi+39GDsezerdOhVi4QXeTaCG7l3bzF0HXkii8NU++AxXJZEKbh9a23GK4lK8ASg3golbmp8ebj1wNx1G7M/qZWuv2VCaalHpKuo=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=TVda9pYs; arc=fail smtp.client-ip=40.107.243.79
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=uBxDPllhXVJczSEpV1LPkpysfIqGCpdwet4mH3HFpoPOVoQhkxParsalvmPfbYQmznOXh0Vkumjcjwt999gWrf89mxSYCq4NwsJOQMrIW5AaT4BwlivXQqDmJCDoTkQkA+CclFigi8kAraX68vce/PDJDbDj2PC0L/86Vz21+EnhXxktG2wUk87neRNcH6wD3L+bNlWfMMyCvjbfQHBhQQxBZOhHXfEiXvsBlrn1Q+/1b5Gulfp5gW+e1B3k3hxVGdyyJMD73tBP8R1/MjqifMYCVJFwmePnaLu0iFhRmOr8gjn52Gb/234ntjALZt1rUNxIK5KvvKs1lyo0t3bu/Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=AnmjS5Ws8pOTnu3tw1SCuin/i2X1p8HKm4b/6Fk3VPM=;
 b=dT+XlLLq5qxSQFEq/Y5r4W+06QjGAmsKH9LiKrHXAwzkxwy2EJKqwxBM/mpNie1YUN/xxNl43OfdK7CpXncuowv9QKPS8I2nY8x8lPH8uAbPj6HimCwa35rku1cJcx8SRp75iJ85VgmXGs3NY+0XMktfP5xJxlCiLpsCU5mePC1PHlFY/krHk/kHzyi5YLlPcuKcvRqHlYv0PsnfQHvRFXH7R9FnTmYX2NNOkfxtCF28f3GQvUoi8i5otn5MlHl0BcheLZ59DU0JLapFwtG0FvZpvQj+vZukXLG1BSe4uQrVndFY/A5HA+hH45/03BuyENOEO8yQfwtLyQv2n7DNJA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=redhat.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=AnmjS5Ws8pOTnu3tw1SCuin/i2X1p8HKm4b/6Fk3VPM=;
 b=TVda9pYs6UlQzuqJW7Pbi6tnmOabheKdYCnXWSmA1aDhUzJCFfxnANvWTjkJdSBHYMKLwlFRzBRVZUVqAFN9g65IEoJO3Tx3r1xK4XN+f/QIOQBpQz4P6+jDj4QNJG65FNq7Vw6hHJXq6JFWEvYHyEacjKWQTtT2SUzXRuA2iayIsTwpOv9WUlYd6UG/sE/AQcrcpi6eq1Hae8hVq0K+6njiFEQWIbmnaT7B3dXIXnUOy60XwmIvmU17qDCdawEehdf1/vh/HOvRO3MDuZU2dG+KUHoAB+Bdl7tzvS/Tnil1FO0FDV393kGWFmL89tjBAWiYAc4g/WhSJoLJgLwA1Q==
Received: from MW4PR04CA0048.namprd04.prod.outlook.com (2603:10b6:303:6a::23)
 by MW6PR12MB8705.namprd12.prod.outlook.com (2603:10b6:303:24c::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8137.28; Mon, 11 Nov
 2024 08:43:02 +0000
Received: from MWH0EPF000971E9.namprd02.prod.outlook.com
 (2603:10b6:303:6a:cafe::30) by MW4PR04CA0048.outlook.office365.com
 (2603:10b6:303:6a::23) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8137.27 via Frontend
 Transport; Mon, 11 Nov 2024 08:43:01 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.161)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 MWH0EPF000971E9.mail.protection.outlook.com (10.167.243.71) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8158.14 via Frontend Transport; Mon, 11 Nov 2024 08:43:01 +0000
Received: from rnnvmail204.nvidia.com (10.129.68.6) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4; Mon, 11 Nov
 2024 00:42:46 -0800
Received: from rnnvmail202.nvidia.com (10.129.68.7) by rnnvmail204.nvidia.com
 (10.129.68.6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4; Mon, 11 Nov
 2024 00:42:45 -0800
Received: from vdi.nvidia.com (10.127.8.10) by mail.nvidia.com (10.129.68.7)
 with Microsoft SMTP Server id 15.2.1544.4 via Frontend Transport; Mon, 11 Nov
 2024 00:42:42 -0800
From: Yishai Hadas <yishaih@nvidia.com>
To: <alex.williamson@redhat.com>, <mst@redhat.com>, <jasowang@redhat.com>,
	<jgg@nvidia.com>
CC: <kvm@vger.kernel.org>, <virtualization@lists.linux-foundation.org>,
	<parav@nvidia.com>, <feliu@nvidia.com>, <kevin.tian@intel.com>,
	<joao.m.martins@oracle.com>, <leonro@nvidia.com>, <yishaih@nvidia.com>,
	<maorg@nvidia.com>
Subject: [PATCH V2 vfio 4/7] virtio-pci: Introduce APIs to execute device parts admin commands
Date: Mon, 11 Nov 2024 10:41:54 +0200
Message-ID: <20241111084157.88044-5-yishaih@nvidia.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20241111084157.88044-1-yishaih@nvidia.com>
References: <20241111084157.88044-1-yishaih@nvidia.com>
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
X-MS-TrafficTypeDiagnostic: MWH0EPF000971E9:EE_|MW6PR12MB8705:EE_
X-MS-Office365-Filtering-Correlation-Id: 6a27b0a1-57fa-4671-7c6d-08dd022cda33
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700013|376014|82310400026|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?FvwJIBrLY0CKO1Yz6Q9EkPAwYfJTfAmXkuzlXJ2F8qeXd0EPIkIWOZc+upj9?=
 =?us-ascii?Q?errvbGRSJqwZnsb7BHhiGeHTBHKCN59tIEUuGk3zl/Qqia6ktTfTh/slQQS/?=
 =?us-ascii?Q?af3LIfMWdjXJaFXlR9dYQTN/VKyLKz+E0D1HDH+wMSEudX44iDXD0gcMJY2d?=
 =?us-ascii?Q?26EAWpWze0ngINKu9zHvxng8xNUIbfo4gFxycWNpDhdhxDWvD3tEOc3QoqLk?=
 =?us-ascii?Q?u2qFJcleFxa9/sxvjVxJ3raqH8vYbApQeBtdcTXpLlKOkh9uT94WAf9Fvaqu?=
 =?us-ascii?Q?dFXGOrgEXHMsf/2CCWTtwYB7uIhL2wf9gPbyfqW60UxTCuK5Bt3U4K9ux2W7?=
 =?us-ascii?Q?nCUv2Um7plgaLFg71IjBUqFLEFbTVR3dh2gKA1Een82dKuRLLA3IjyqFePIl?=
 =?us-ascii?Q?YlN6tK5d2htN6OCg/ynm9ATsHg6G9FuwjlXJbzcJg+3SBny8EvdyO5jHIN9X?=
 =?us-ascii?Q?ysouH2wMQO7zWyWKijzqrNuXOt43jg+pYNJJ2+2QxEMmIhaDi/YhSQPFYH2R?=
 =?us-ascii?Q?/bWHpvZhCsJ31bOgKOecoz1aw8tYlPnR28+TG/ZH4QGdci8HdnvWNPo6LtiP?=
 =?us-ascii?Q?bE93Lc/1khvt/sX+H4WpHbRU0bhBXA3A1Q/zfYUh+COd8PRRRBHOrjRGQjOv?=
 =?us-ascii?Q?hoQXurLQgFsKqGjDC0ilg/zYcBmlByLh6KkkeuA1H/xKIIL6W8EPphPQSTDj?=
 =?us-ascii?Q?/2dZ5zZf7t+dTdcW7BcVcIKXXrWwtznGSEDsesdqUBXNsKyFLnE6zUKjNM2d?=
 =?us-ascii?Q?OKuDGhrJxTvmG/uBqCs3LtkkDjvjCPF3z+CafsDpQVSebQTBnLmo2ePySHgx?=
 =?us-ascii?Q?UckhRWnaKEo0yyqEvOkA9ADPTgx8a1YxUC13VnyNexW4MZQO5m87kc2UUzcS?=
 =?us-ascii?Q?RcHt9ggn8Kfsvz+Vy8Fs55L744D+6dkZwugqRUp9tbxMZtNygEX5YCwodSde?=
 =?us-ascii?Q?DnNvJDdJMUz90UQDogZpPZN39RY9zPLmLZGNVSMsdHPKt9oLEveVtoqq9B1A?=
 =?us-ascii?Q?Vphnkodn5EKlfzbFKkDXpY6bp9cUL0iqFowGfKE8i9IB5KWh5XddszUHeqYI?=
 =?us-ascii?Q?9O0mj+pSC2O+gcIkqKkn+H+nj6YLTJFcbd7U17G7mQDJQfni6/C0pX4ek0Dr?=
 =?us-ascii?Q?tDTQ1qKrrBCc+Kh1VP6s4zFoMcMXKGBjMaRNahPNsQQlyM1U1vf0ZAnDDMHi?=
 =?us-ascii?Q?2jV7/s/MdnMJb5CdVoCPIRnmkOxQPPDgSoToQrl+NIjKHeeamo125y3disDG?=
 =?us-ascii?Q?AdA9ko6NCEiOaEKb3smbWmGuZBcYfyIRtUxgB7nHhWoKYPZ0AzkMGQNOqZ8e?=
 =?us-ascii?Q?nZzo9xc110W57Iw45v4RaQuADMi7Zo4KXsT0oHY3D2p2PV0zkrHve06kqSnC?=
 =?us-ascii?Q?U1ruHX2xnvdgZC8o7D1W6ycaS+Pn+CkBcvNaIioiUIgH43IFvQ=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230040)(36860700013)(376014)(82310400026)(1800799024);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Nov 2024 08:43:01.7694
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 6a27b0a1-57fa-4671-7c6d-08dd022cda33
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	MWH0EPF000971E9.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW6PR12MB8705

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


