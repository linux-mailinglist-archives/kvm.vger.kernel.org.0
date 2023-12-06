Return-Path: <kvm+bounces-3677-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 9A2188069EE
	for <lists+kvm@lfdr.de>; Wed,  6 Dec 2023 09:41:01 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 42D7E280EE5
	for <lists+kvm@lfdr.de>; Wed,  6 Dec 2023 08:41:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B64A82D7BD;
	Wed,  6 Dec 2023 08:40:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="csqQFt26"
X-Original-To: kvm@vger.kernel.org
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2041.outbound.protection.outlook.com [40.107.236.41])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F3539D5B
	for <kvm@vger.kernel.org>; Wed,  6 Dec 2023 00:40:21 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=doDDvTeq9gpzg2somenPIXjFzjWE+i1vhYiqwskGHI+vpV28/A3AKcYq36OJI68dpjQcfN5TZeDyE4siiv+gSpwEHzJjDxW/EXs+515WH5gPnorTwcbraekQIydwpzQ6oTsWgDQwkHh/QVHQOgm5nSjHFqgNTx7cthHC2ESoxy7LG+Uv863UY/9yOZ8L22IIk2m8H1VJ56THgFJ6u2D/NLarGM9hqO97qDlmdG9jTkVecwcUGJMYxFEUIuAPGsYceK2kB1bAnST+iGd6InBZgM05zBm/azrkWVX1n5xr96y/ClYKSj05pRTcDoRJYnecJkD3hTxpkEDuulYSqyNrWQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=6hi0XY5g/f5M1A4bC1GvlmpAy3GL0utyR5QxW/yOU2U=;
 b=Ae9M++kD/nmwa4/nKKSLlckwFgohbyZrQIZwIJksPNysMYJu7lW/Jg8iXPuHGQbnE12ov/orHKMaBY1yqf1xDpuoLQmAwCFB75KDc3NFqAy9Mmv4pyUuPthqx51TdjzJDH+28RlwSXp0t0Bc0lwx1EO/2GHQwmEJWDfxCnVNupDRGBkUuh+nqlEbu9gdzafILezXiOiVVwS1X7P4aMPkx7rYKZFn0Auhh+GaYn3lRajiMqOn6wLKhb+QHSreT83g9YQVkLTg3UHT2kKKJRuxqocFypO32C66RfPQLOk4FETsRw55AwjUeahF5hKXFE/6372jRpGU5S+jHHILU1KkjQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=redhat.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6hi0XY5g/f5M1A4bC1GvlmpAy3GL0utyR5QxW/yOU2U=;
 b=csqQFt26nxuFJYvbcfAQ8d61a9+BJfpv7Fjytnos2DEcO4RdqoijBB+Km0zqGZncbHlDTzGwV060ndbFfEJM0FPt3UQHRn19dc1svHnh9K9iUBGpc15vPsIs7SxY4iy9zMlaT9+dRxijehdbcYu/eo6cbUOpr5KBUcQpGT0X95xGV3xsYLFtQdh01KYxip/x3lo6T4K3kAyCMtxNnGMgxZNdQJ4tQORXKfBakRchatKIAddHdQljJMLXrmtXUFlsfv/S4Qtp/Tc0ARijSRFDnXI02De0iOhrrUi+SPhComYe+wC6u/XQ2ixIEq+Y3mzwz+0Di0q6nhNRH4/Ii4AV8w==
Received: from CH5PR04CA0021.namprd04.prod.outlook.com (2603:10b6:610:1f4::14)
 by DM4PR12MB5248.namprd12.prod.outlook.com (2603:10b6:5:39c::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7046.34; Wed, 6 Dec
 2023 08:40:16 +0000
Received: from SN1PEPF0002BA4E.namprd03.prod.outlook.com
 (2603:10b6:610:1f4:cafe::d9) by CH5PR04CA0021.outlook.office365.com
 (2603:10b6:610:1f4::14) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7046.34 via Frontend
 Transport; Wed, 6 Dec 2023 08:40:16 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.161)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 SN1PEPF0002BA4E.mail.protection.outlook.com (10.167.242.71) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.7068.20 via Frontend Transport; Wed, 6 Dec 2023 08:40:16 +0000
Received: from rnnvmail205.nvidia.com (10.129.68.10) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.41; Wed, 6 Dec 2023
 00:40:04 -0800
Received: from rnnvmail201.nvidia.com (10.129.68.8) by rnnvmail205.nvidia.com
 (10.129.68.10) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.41; Wed, 6 Dec 2023
 00:40:03 -0800
Received: from vdi.nvidia.com (10.127.8.10) by mail.nvidia.com (10.129.68.8)
 with Microsoft SMTP Server id 15.2.986.41 via Frontend Transport; Wed, 6 Dec
 2023 00:40:00 -0800
From: Yishai Hadas <yishaih@nvidia.com>
To: <alex.williamson@redhat.com>, <mst@redhat.com>, <jasowang@redhat.com>,
	<jgg@nvidia.com>
CC: <kvm@vger.kernel.org>, <virtualization@lists.linux-foundation.org>,
	<parav@nvidia.com>, <feliu@nvidia.com>, <jiri@nvidia.com>,
	<kevin.tian@intel.com>, <joao.m.martins@oracle.com>, <si-wei.liu@oracle.com>,
	<leonro@nvidia.com>, <yishaih@nvidia.com>, <maorg@nvidia.com>
Subject: [PATCH V6 vfio 6/9] virtio-pci: Introduce APIs to execute legacy IO admin commands
Date: Wed, 6 Dec 2023 10:38:54 +0200
Message-ID: <20231206083857.241946-7-yishaih@nvidia.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20231206083857.241946-1-yishaih@nvidia.com>
References: <20231206083857.241946-1-yishaih@nvidia.com>
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
X-MS-TrafficTypeDiagnostic: SN1PEPF0002BA4E:EE_|DM4PR12MB5248:EE_
X-MS-Office365-Filtering-Correlation-Id: 63a0ab13-320f-48ce-75a4-08dbf636f8cb
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	Yke21ZiQf90IoZIgXi9qmoRabFZNEJiY/eENVPEoKv68TpIetSiyUoyk1JTwJk/QVMy17HruytUQet/PGC4OicqDDUFfId2WoFb68UrX3oeBRxYxadRHxazbmyrFZLyoSYgfWyBeAi+sAADXRWutMfdHQMMzvqTGOjtT9VF9kCYqXLXu3JwyQg/igYVV4GkQC9QFEmPHuKboGGvIQgX8aer4Me0FVp1GGGEtlfAjk1p5bEKnPE1sDAesQ33C9FRQ496SecMNSejl5Y0KJUm+tCsqegiA2Vwttc2I0wGXH8r4xgIu+vtPX3VPxXdQXAlzE4DxZkQdyXQrxQB7Ot5Um67k4nZTjWi9P8r8juLZL7ZPj90t3rTkQXqUCr414atTsuV2HHhOiK63tu4+Cazg7p+eFMBFegwSym6EhBuOKSw0LxHpdSgJqITqrVSf2VyfXbHPUnBWNf8B4wVWCoTfLC8dU06bQpW3LEI9+tzUz3yyJhY2XlmziHzK6htaHjEX7bbl56mR12jVzHZC3+9hqQFXbVxrbBw6RNniAlQcf3tkbUI4f/oHfW1qP+qIJfCxTAHnBBm0DPdTt1iDGtrn0SUL+4kR3gEuwbweIEbtvh30fsyPhrn8KrfVMBFU0ElQSQv1ClhXaNaaKmgAwzuu+yfbVeuDeUdVt7ZzMIdTrRPPRXXFaAkcZoguIuJ1S7hnwNAV1LgYhOXu8rEBxqjhkCLimtfMPifz+bOlHoZOGpv5PIOw/rVn1HgegJZNZf+rOI2hCavTMCGTWyGgYUHmUg==
X-Forefront-Antispam-Report:
	CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230031)(4636009)(396003)(376002)(39860400002)(346002)(136003)(230922051799003)(1800799012)(451199024)(64100799003)(186009)(82310400011)(46966006)(36840700001)(40470700004)(40460700003)(426003)(478600001)(83380400001)(2616005)(26005)(336012)(6666004)(7696005)(1076003)(107886003)(316002)(110136005)(7636003)(6636002)(54906003)(36756003)(8676002)(86362001)(8936002)(70206006)(41300700001)(4326008)(70586007)(36860700001)(40480700001)(30864003)(2906002)(5660300002)(82740400003)(356005)(47076005)(2101003);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Dec 2023 08:40:16.4401
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 63a0ab13-320f-48ce-75a4-08dbf636f8cb
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SN1PEPF0002BA4E.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB5248

Introduce APIs to execute legacy IO admin commands.

It includes: io_legacy_read/write for both common and the device
configuration, io_legacy_notify_info.

In addition, exposing an API to check whether the legacy IO commands are
supported. (i.e. virtio_pci_admin_has_legacy_io()).

Those APIs will be used by the next patches from this series.

Acked-by: Michael S. Tsirkin <mst@redhat.com>
Signed-off-by: Yishai Hadas <yishaih@nvidia.com>
---
 drivers/virtio/virtio_pci_common.c |  11 ++
 drivers/virtio/virtio_pci_common.h |   2 +
 drivers/virtio/virtio_pci_modern.c | 245 +++++++++++++++++++++++++++++
 include/linux/virtio_pci_admin.h   |  21 +++
 4 files changed, 279 insertions(+)
 create mode 100644 include/linux/virtio_pci_admin.h

diff --git a/drivers/virtio/virtio_pci_common.c b/drivers/virtio/virtio_pci_common.c
index fafd13d0e4d4..9f93330fc2cc 100644
--- a/drivers/virtio/virtio_pci_common.c
+++ b/drivers/virtio/virtio_pci_common.c
@@ -645,6 +645,17 @@ static struct pci_driver virtio_pci_driver = {
 	.sriov_configure = virtio_pci_sriov_configure,
 };
 
+struct virtio_device *virtio_pci_vf_get_pf_dev(struct pci_dev *pdev)
+{
+	struct virtio_pci_device *pf_vp_dev;
+
+	pf_vp_dev = pci_iov_get_pf_drvdata(pdev, &virtio_pci_driver);
+	if (IS_ERR(pf_vp_dev))
+		return NULL;
+
+	return &pf_vp_dev->vdev;
+}
+
 module_pci_driver(virtio_pci_driver);
 
 MODULE_AUTHOR("Anthony Liguori <aliguori@us.ibm.com>");
diff --git a/drivers/virtio/virtio_pci_common.h b/drivers/virtio/virtio_pci_common.h
index 2e3ae417519d..af676b3b9907 100644
--- a/drivers/virtio/virtio_pci_common.h
+++ b/drivers/virtio/virtio_pci_common.h
@@ -156,4 +156,6 @@ static inline void virtio_pci_legacy_remove(struct virtio_pci_device *vp_dev)
 int virtio_pci_modern_probe(struct virtio_pci_device *);
 void virtio_pci_modern_remove(struct virtio_pci_device *);
 
+struct virtio_device *virtio_pci_vf_get_pf_dev(struct pci_dev *pdev);
+
 #endif
diff --git a/drivers/virtio/virtio_pci_modern.c b/drivers/virtio/virtio_pci_modern.c
index 951014dbb086..37a0035f8381 100644
--- a/drivers/virtio/virtio_pci_modern.c
+++ b/drivers/virtio/virtio_pci_modern.c
@@ -15,6 +15,7 @@
  */
 
 #include <linux/delay.h>
+#include <linux/virtio_pci_admin.h>
 #define VIRTIO_PCI_NO_LEGACY
 #define VIRTIO_RING_NO_LEGACY
 #include "virtio_pci_common.h"
@@ -774,6 +775,250 @@ static void vp_modern_destroy_avq(struct virtio_device *vdev)
 	vp_dev->del_vq(&vp_dev->admin_vq.info);
 }
 
+#define VIRTIO_LEGACY_ADMIN_CMD_BITMAP \
+	(BIT_ULL(VIRTIO_ADMIN_CMD_LEGACY_COMMON_CFG_WRITE) | \
+	 BIT_ULL(VIRTIO_ADMIN_CMD_LEGACY_COMMON_CFG_READ) | \
+	 BIT_ULL(VIRTIO_ADMIN_CMD_LEGACY_DEV_CFG_WRITE) | \
+	 BIT_ULL(VIRTIO_ADMIN_CMD_LEGACY_DEV_CFG_READ) | \
+	 BIT_ULL(VIRTIO_ADMIN_CMD_LEGACY_NOTIFY_INFO))
+
+/*
+ * virtio_pci_admin_has_legacy_io - Checks whether the legacy IO
+ * commands are supported
+ * @dev: VF pci_dev
+ *
+ * Returns true on success.
+ */
+bool virtio_pci_admin_has_legacy_io(struct pci_dev *pdev)
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
+	if ((vp_dev->admin_vq.supported_cmds & VIRTIO_LEGACY_ADMIN_CMD_BITMAP) ==
+		VIRTIO_LEGACY_ADMIN_CMD_BITMAP)
+		return true;
+	return false;
+}
+EXPORT_SYMBOL_GPL(virtio_pci_admin_has_legacy_io);
+
+static int virtio_pci_admin_legacy_io_write(struct pci_dev *pdev, u16 opcode,
+					    u8 offset, u8 size, u8 *buf)
+{
+	struct virtio_device *virtio_dev = virtio_pci_vf_get_pf_dev(pdev);
+	struct virtio_admin_cmd_legacy_wr_data *data;
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
+	data = kzalloc(sizeof(*data) + size, GFP_KERNEL);
+	if (!data)
+		return -ENOMEM;
+
+	data->offset = offset;
+	memcpy(data->registers, buf, size);
+	sg_init_one(&data_sg, data, sizeof(*data) + size);
+	cmd.opcode = cpu_to_le16(opcode);
+	cmd.group_type = cpu_to_le16(VIRTIO_ADMIN_GROUP_TYPE_SRIOV);
+	cmd.group_member_id = cpu_to_le64(vf_id + 1);
+	cmd.data_sg = &data_sg;
+	ret = vp_modern_admin_cmd_exec(virtio_dev, &cmd);
+
+	kfree(data);
+	return ret;
+}
+
+/*
+ * virtio_pci_admin_legacy_io_write_common - Write legacy common configuration
+ * of a member device
+ * @dev: VF pci_dev
+ * @offset: starting byte offset within the common configuration area to write to
+ * @size: size of the data to write
+ * @buf: buffer which holds the data
+ *
+ * Note: caller must serialize access for the given device.
+ * Returns 0 on success, or negative on failure.
+ */
+int virtio_pci_admin_legacy_common_io_write(struct pci_dev *pdev, u8 offset,
+					    u8 size, u8 *buf)
+{
+	return virtio_pci_admin_legacy_io_write(pdev,
+					VIRTIO_ADMIN_CMD_LEGACY_COMMON_CFG_WRITE,
+					offset, size, buf);
+}
+EXPORT_SYMBOL_GPL(virtio_pci_admin_legacy_common_io_write);
+
+/*
+ * virtio_pci_admin_legacy_io_write_device - Write legacy device configuration
+ * of a member device
+ * @dev: VF pci_dev
+ * @offset: starting byte offset within the device configuration area to write to
+ * @size: size of the data to write
+ * @buf: buffer which holds the data
+ *
+ * Note: caller must serialize access for the given device.
+ * Returns 0 on success, or negative on failure.
+ */
+int virtio_pci_admin_legacy_device_io_write(struct pci_dev *pdev, u8 offset,
+					    u8 size, u8 *buf)
+{
+	return virtio_pci_admin_legacy_io_write(pdev,
+					VIRTIO_ADMIN_CMD_LEGACY_DEV_CFG_WRITE,
+					offset, size, buf);
+}
+EXPORT_SYMBOL_GPL(virtio_pci_admin_legacy_device_io_write);
+
+static int virtio_pci_admin_legacy_io_read(struct pci_dev *pdev, u16 opcode,
+					   u8 offset, u8 size, u8 *buf)
+{
+	struct virtio_device *virtio_dev = virtio_pci_vf_get_pf_dev(pdev);
+	struct virtio_admin_cmd_legacy_rd_data *data;
+	struct scatterlist data_sg, result_sg;
+	struct virtio_admin_cmd cmd = {};
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
+	data->offset = offset;
+	sg_init_one(&data_sg, data, sizeof(*data));
+	sg_init_one(&result_sg, buf, size);
+	cmd.opcode = cpu_to_le16(opcode);
+	cmd.group_type = cpu_to_le16(VIRTIO_ADMIN_GROUP_TYPE_SRIOV);
+	cmd.group_member_id = cpu_to_le64(vf_id + 1);
+	cmd.data_sg = &data_sg;
+	cmd.result_sg = &result_sg;
+	ret = vp_modern_admin_cmd_exec(virtio_dev, &cmd);
+
+	kfree(data);
+	return ret;
+}
+
+/*
+ * virtio_pci_admin_legacy_device_io_read - Read legacy device configuration of
+ * a member device
+ * @dev: VF pci_dev
+ * @offset: starting byte offset within the device configuration area to read from
+ * @size: size of the data to be read
+ * @buf: buffer to hold the returned data
+ *
+ * Note: caller must serialize access for the given device.
+ * Returns 0 on success, or negative on failure.
+ */
+int virtio_pci_admin_legacy_device_io_read(struct pci_dev *pdev, u8 offset,
+					   u8 size, u8 *buf)
+{
+	return virtio_pci_admin_legacy_io_read(pdev,
+					VIRTIO_ADMIN_CMD_LEGACY_DEV_CFG_READ,
+					offset, size, buf);
+}
+EXPORT_SYMBOL_GPL(virtio_pci_admin_legacy_device_io_read);
+
+/*
+ * virtio_pci_admin_legacy_common_io_read - Read legacy common configuration of
+ * a member device
+ * @dev: VF pci_dev
+ * @offset: starting byte offset within the common configuration area to read from
+ * @size: size of the data to be read
+ * @buf: buffer to hold the returned data
+ *
+ * Note: caller must serialize access for the given device.
+ * Returns 0 on success, or negative on failure.
+ */
+int virtio_pci_admin_legacy_common_io_read(struct pci_dev *pdev, u8 offset,
+					   u8 size, u8 *buf)
+{
+	return virtio_pci_admin_legacy_io_read(pdev,
+					VIRTIO_ADMIN_CMD_LEGACY_COMMON_CFG_READ,
+					offset, size, buf);
+}
+EXPORT_SYMBOL_GPL(virtio_pci_admin_legacy_common_io_read);
+
+/*
+ * virtio_pci_admin_legacy_io_notify_info - Read the queue notification
+ * information for legacy interface
+ * @dev: VF pci_dev
+ * @req_bar_flags: requested bar flags
+ * @bar: on output the BAR number of the owner or member device
+ * @bar_offset: on output the offset within bar
+ *
+ * Returns 0 on success, or negative on failure.
+ */
+int virtio_pci_admin_legacy_io_notify_info(struct pci_dev *pdev,
+					   u8 req_bar_flags, u8 *bar,
+					   u64 *bar_offset)
+{
+	struct virtio_device *virtio_dev = virtio_pci_vf_get_pf_dev(pdev);
+	struct virtio_admin_cmd_notify_info_result *result;
+	struct virtio_admin_cmd cmd = {};
+	struct scatterlist result_sg;
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
+	result = kzalloc(sizeof(*result), GFP_KERNEL);
+	if (!result)
+		return -ENOMEM;
+
+	sg_init_one(&result_sg, result, sizeof(*result));
+	cmd.opcode = cpu_to_le16(VIRTIO_ADMIN_CMD_LEGACY_NOTIFY_INFO);
+	cmd.group_type = cpu_to_le16(VIRTIO_ADMIN_GROUP_TYPE_SRIOV);
+	cmd.group_member_id = cpu_to_le64(vf_id + 1);
+	cmd.result_sg = &result_sg;
+	ret = vp_modern_admin_cmd_exec(virtio_dev, &cmd);
+	if (!ret) {
+		struct virtio_admin_cmd_notify_info_data *entry;
+		int i;
+
+		ret = -ENOENT;
+		for (i = 0; i < VIRTIO_ADMIN_CMD_MAX_NOTIFY_INFO; i++) {
+			entry = &result->entries[i];
+			if (entry->flags == VIRTIO_ADMIN_CMD_NOTIFY_INFO_FLAGS_END)
+				break;
+			if (entry->flags != req_bar_flags)
+				continue;
+			*bar = entry->bar;
+			*bar_offset = le64_to_cpu(entry->offset);
+			ret = 0;
+			break;
+		}
+	}
+
+	kfree(result);
+	return ret;
+}
+EXPORT_SYMBOL_GPL(virtio_pci_admin_legacy_io_notify_info);
+
 static const struct virtio_config_ops virtio_pci_config_nodev_ops = {
 	.get		= NULL,
 	.set		= NULL,
diff --git a/include/linux/virtio_pci_admin.h b/include/linux/virtio_pci_admin.h
new file mode 100644
index 000000000000..446ced8cb050
--- /dev/null
+++ b/include/linux/virtio_pci_admin.h
@@ -0,0 +1,21 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+#ifndef _LINUX_VIRTIO_PCI_ADMIN_H
+#define _LINUX_VIRTIO_PCI_ADMIN_H
+
+#include <linux/types.h>
+#include <linux/pci.h>
+
+bool virtio_pci_admin_has_legacy_io(struct pci_dev *pdev);
+int virtio_pci_admin_legacy_common_io_write(struct pci_dev *pdev, u8 offset,
+					    u8 size, u8 *buf);
+int virtio_pci_admin_legacy_common_io_read(struct pci_dev *pdev, u8 offset,
+					   u8 size, u8 *buf);
+int virtio_pci_admin_legacy_device_io_write(struct pci_dev *pdev, u8 offset,
+					    u8 size, u8 *buf);
+int virtio_pci_admin_legacy_device_io_read(struct pci_dev *pdev, u8 offset,
+					   u8 size, u8 *buf);
+int virtio_pci_admin_legacy_io_notify_info(struct pci_dev *pdev,
+					   u8 req_bar_flags, u8 *bar,
+					   u64 *bar_offset);
+
+#endif /* _LINUX_VIRTIO_PCI_ADMIN_H */
-- 
2.27.0


