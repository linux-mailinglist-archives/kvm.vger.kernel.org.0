Return-Path: <kvm+bounces-4792-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 7C9AB818491
	for <lists+kvm@lfdr.de>; Tue, 19 Dec 2023 10:34:49 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 073891F2676F
	for <lists+kvm@lfdr.de>; Tue, 19 Dec 2023 09:34:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AFB4C1426B;
	Tue, 19 Dec 2023 09:34:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="puYyN0La"
X-Original-To: kvm@vger.kernel.org
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2056.outbound.protection.outlook.com [40.107.223.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2960114004
	for <kvm@vger.kernel.org>; Tue, 19 Dec 2023 09:34:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Q3/MWV05ZfrPEZjSy+oAaFXknS+EukmgakkwVrgXvzyRd0BVx/OQuRy/XbIPaTnpRNLE6G/8to78JeV88qp53o+AK1MCyZCUcxWLSH2pL7/Z+G2Fw1XdCUkILH2H8jRrpGZ+rSa5qqY1Dn7KfjTW0NOXIo1oeeVSirhF+TU9BUnSy9imFUFtBA9YJ0cgegosHIJBucw+boohl9ezASNZoimjsmeWMGlasTRVF+JJ0lSxQv/9lQ7e8MyzpvzKdYqoycfJnHZ1+y729Ekvw1dPCiSdivT+EgnPdxQuPbRgTLxgnxTJY424cRLPa1p1YMy/BLTiIa7mCW6jDQ7T7JNg2Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=p3rD/laXW2j2E5Y6CEogzSgZzqXzNA/t8hlqQpDVpis=;
 b=cb8iRuac0NESLkHD9DGIxbjyaiu2tPNNLU+DfAwPO4oId9ogf9H92+Nz2oZ5RVWKfc8zYPbLGA7t0fSyG81cc+fU/WtaD5AtGSzLV7CDue1nafkERMPh4A7bQ0PZrmDnTSkV+MPBkumcX2ezjLooAeVnJSjy30JbrJeSmWNFMPGFxC8ncht97YHcy9x/VpEVwSPHjb/Z5snjTKwtXG4650/8ru5qSZeXAkiANcWE7LtbcWbGdV21VsQZq2lyD29b2fwe0nLC7268v4wzZGOq9c+ZHoxQn4bfjCqgH89iiaE62rpVRwQ5hxUFnUX8UW5OZxtL8XDbWFbEyMt0lTJcug==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.118.233) smtp.rcpttodomain=redhat.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=p3rD/laXW2j2E5Y6CEogzSgZzqXzNA/t8hlqQpDVpis=;
 b=puYyN0LaEUB81xwvN3cYMeHMZp2DK4I3zPPrs+MN5BOau0dTuVc2V+z2KOw1p/Y1bD7bZd4D3bDNqwiOQ+RKGZ5xsJTGmAf78mQ0hMKphLMyyYjzkRiti+Q9PhqZ6NbVMCzvl7aE31vRY0QmKsKaCsNYsX77PFP9zEJllIEb5RYB/qXcD8sr36XKA2NoT6N+xksDGRNwa7Sr/XaAKDkzJQ7QPVmCdmGiM3s9vc2FQWZWit7qCqrcKC7QpwfYGio9GydfselDM9YzMoI5YK/XWlG9AczIJDljxegbafkjoxuqg5owbO0e70sqrnkA6jzOnLGoY0MOnvVwqe6qP9mzzg==
Received: from BL0PR03CA0032.namprd03.prod.outlook.com (2603:10b6:208:2d::45)
 by DM4PR12MB5296.namprd12.prod.outlook.com (2603:10b6:5:39d::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7091.38; Tue, 19 Dec
 2023 09:34:22 +0000
Received: from BL6PEPF0001AB59.namprd02.prod.outlook.com
 (2603:10b6:208:2d:cafe::67) by BL0PR03CA0032.outlook.office365.com
 (2603:10b6:208:2d::45) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7091.39 via Frontend
 Transport; Tue, 19 Dec 2023 09:34:22 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.118.233)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.118.233 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.118.233; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.118.233) by
 BL6PEPF0001AB59.mail.protection.outlook.com (10.167.241.11) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.7113.14 via Frontend Transport; Tue, 19 Dec 2023 09:34:22 +0000
Received: from drhqmail203.nvidia.com (10.126.190.182) by mail.nvidia.com
 (10.127.129.6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.41; Tue, 19 Dec
 2023 01:34:09 -0800
Received: from drhqmail202.nvidia.com (10.126.190.181) by
 drhqmail203.nvidia.com (10.126.190.182) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.986.41; Tue, 19 Dec 2023 01:34:08 -0800
Received: from vdi.nvidia.com (10.127.8.10) by mail.nvidia.com
 (10.126.190.181) with Microsoft SMTP Server id 15.2.986.41 via Frontend
 Transport; Tue, 19 Dec 2023 01:34:05 -0800
From: Yishai Hadas <yishaih@nvidia.com>
To: <alex.williamson@redhat.com>, <mst@redhat.com>, <jasowang@redhat.com>,
	<jgg@nvidia.com>
CC: <kvm@vger.kernel.org>, <virtualization@lists.linux-foundation.org>,
	<parav@nvidia.com>, <feliu@nvidia.com>, <jiri@nvidia.com>,
	<kevin.tian@intel.com>, <joao.m.martins@oracle.com>, <si-wei.liu@oracle.com>,
	<leonro@nvidia.com>, <yishaih@nvidia.com>, <maorg@nvidia.com>
Subject: [PATCH V10 vfio 6/9] virtio-pci: Introduce APIs to execute legacy IO admin commands
Date: Tue, 19 Dec 2023 11:32:44 +0200
Message-ID: <20231219093247.170936-7-yishaih@nvidia.com>
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
X-MS-TrafficTypeDiagnostic: BL6PEPF0001AB59:EE_|DM4PR12MB5296:EE_
X-MS-Office365-Filtering-Correlation-Id: 91d0b2da-853b-446e-6c98-08dc0075aece
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	BpYUJPyn0J5vse1vo39ZHdlnHJ0VRGGYf31jX4kyEuxBH+uEd+WyjI0E88TulRpQxOFBJZvJUEey7xHBs3VGQMzyFa04j9Y4v8OsqRdFJDeRLsrMj3exlYQ8IO96//LetfGpAre9OIesT6n5ym+qfRAwF+8FPlY8z7l/JwDNkagJWAtlDN5GcDW1Hj1PUqUXzvQcqeIJDpPnlZhEmkXYmyfhyxsyBK7AJ4lzc4TFBOhjBheKuNFGi3nH3bQXU2YxIKC5PCj+AH3qiJvL62YPUl2zfXQQGWMK9R6WhhqSN80rGOuhviiUhOMmeqfsDMsQEPQYWdDTa3r4nfXT0kiwDR3qPg9Ae+wbbyAddmewhsk94tMx+dDo2R2u7hWde4D4GNCs0JkQ1/Yh5Jc1580XJu6Ojo7CUVPeWPPIZryCtWsDFdUTokzxMHqCcQhq+QhDvb7NcGads8lRDYehDLck5dQhROogvXGXJu/LCB/311BJEBLuxXWURF//ZenLORoA2bTuPVxfdTCB9DtzXrPSeRhC+wB75ml2q9vKtctPyPB5q/78YIN0VjuNR2AvY1PPbTWvqETLNkks0/C9STKhVOqmrnoZ0+S3EPqqIWMTE0+y17hZ8ctI+hogR1Z97mdqCegZPQiNgMdPtbOXN4M7s9ThqHTt90RVj6ama8z+hEymtNzQ2JK5fIEsguyJUcM6SvLZFoSYLcTQ2dWDQnAZXHzj7p5ASllsheMIsg7XAtbBa9k48SoINpRchAainlDqxEdJ2vXQuvtEFqSCPrV92w==
X-Forefront-Antispam-Report:
	CIP:216.228.118.233;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc7edge2.nvidia.com;CAT:NONE;SFS:(13230031)(4636009)(346002)(376002)(39860400002)(396003)(136003)(230922051799003)(186009)(451199024)(82310400011)(1800799012)(64100799003)(36840700001)(46966006)(40470700004)(107886003)(47076005)(83380400001)(1076003)(2616005)(426003)(336012)(26005)(36860700001)(4326008)(5660300002)(8936002)(41300700001)(30864003)(2906002)(478600001)(6666004)(7696005)(54906003)(70206006)(70586007)(8676002)(316002)(6636002)(110136005)(36756003)(86362001)(7636003)(356005)(82740400003)(40480700001)(40460700003)(2101003);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Dec 2023 09:34:22.1830
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 91d0b2da-853b-446e-6c98-08dc0075aece
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.118.233];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BL6PEPF0001AB59.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB5296

Introduce APIs to execute legacy IO admin commands.

It includes: io_legacy_read/write for both common and the device
configuration, io_legacy_notify_info.

In addition, exposing an API to check whether the legacy IO commands are
supported. (i.e. virtio_pci_admin_has_legacy_io()).

Those APIs will be used by the next patches from this series.

Note:
Unlike modern drivers which support hardware virtio devices, legacy
drivers assume software-based devices: e.g. they don't use proper memory
barriers on ARM, use big endian on PPC, etc. X86 drivers are mostly ok
though, more or less by chance. For now, only support legacy IO on X86.

Acked-by: Michael S. Tsirkin <mst@redhat.com>
Signed-off-by: Yishai Hadas <yishaih@nvidia.com>
---
 drivers/virtio/Makefile                     |   1 +
 drivers/virtio/virtio_pci_admin_legacy_io.c | 244 ++++++++++++++++++++
 drivers/virtio/virtio_pci_common.c          |  11 +
 drivers/virtio/virtio_pci_common.h          |   2 +
 include/linux/virtio_pci_admin.h            |  23 ++
 5 files changed, 281 insertions(+)
 create mode 100644 drivers/virtio/virtio_pci_admin_legacy_io.c
 create mode 100644 include/linux/virtio_pci_admin.h

diff --git a/drivers/virtio/Makefile b/drivers/virtio/Makefile
index 8e98d24917cc..73ace62af440 100644
--- a/drivers/virtio/Makefile
+++ b/drivers/virtio/Makefile
@@ -7,6 +7,7 @@ obj-$(CONFIG_VIRTIO_MMIO) += virtio_mmio.o
 obj-$(CONFIG_VIRTIO_PCI) += virtio_pci.o
 virtio_pci-y := virtio_pci_modern.o virtio_pci_common.o
 virtio_pci-$(CONFIG_VIRTIO_PCI_LEGACY) += virtio_pci_legacy.o
+virtio_pci-$(CONFIG_VIRTIO_PCI_ADMIN_LEGACY) += virtio_pci_admin_legacy_io.o
 obj-$(CONFIG_VIRTIO_BALLOON) += virtio_balloon.o
 obj-$(CONFIG_VIRTIO_INPUT) += virtio_input.o
 obj-$(CONFIG_VIRTIO_VDPA) += virtio_vdpa.o
diff --git a/drivers/virtio/virtio_pci_admin_legacy_io.c b/drivers/virtio/virtio_pci_admin_legacy_io.c
new file mode 100644
index 000000000000..819cfbbc67c3
--- /dev/null
+++ b/drivers/virtio/virtio_pci_admin_legacy_io.c
@@ -0,0 +1,244 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/*
+ * Copyright (c) 2023, NVIDIA CORPORATION & AFFILIATES. All rights reserved
+ */
+
+#include <linux/virtio_pci_admin.h>
+#include "virtio_pci_common.h"
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
index a39bffd5fd46..7fef52bee455 100644
--- a/drivers/virtio/virtio_pci_common.h
+++ b/drivers/virtio/virtio_pci_common.h
@@ -156,6 +156,8 @@ static inline void virtio_pci_legacy_remove(struct virtio_pci_device *vp_dev)
 int virtio_pci_modern_probe(struct virtio_pci_device *);
 void virtio_pci_modern_remove(struct virtio_pci_device *);
 
+struct virtio_device *virtio_pci_vf_get_pf_dev(struct pci_dev *pdev);
+
 #define VIRTIO_LEGACY_ADMIN_CMD_BITMAP \
 	(BIT_ULL(VIRTIO_ADMIN_CMD_LEGACY_COMMON_CFG_WRITE) | \
 	 BIT_ULL(VIRTIO_ADMIN_CMD_LEGACY_COMMON_CFG_READ) | \
diff --git a/include/linux/virtio_pci_admin.h b/include/linux/virtio_pci_admin.h
new file mode 100644
index 000000000000..f4a100a0fe2e
--- /dev/null
+++ b/include/linux/virtio_pci_admin.h
@@ -0,0 +1,23 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+#ifndef _LINUX_VIRTIO_PCI_ADMIN_H
+#define _LINUX_VIRTIO_PCI_ADMIN_H
+
+#include <linux/types.h>
+#include <linux/pci.h>
+
+#ifdef CONFIG_VIRTIO_PCI_ADMIN_LEGACY
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
+#endif
+
+#endif /* _LINUX_VIRTIO_PCI_ADMIN_H */
-- 
2.27.0


