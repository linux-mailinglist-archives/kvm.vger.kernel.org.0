Return-Path: <kvm+bounces-25-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 608057DAD25
	for <lists+kvm@lfdr.de>; Sun, 29 Oct 2023 17:01:26 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id B3C96B21449
	for <lists+kvm@lfdr.de>; Sun, 29 Oct 2023 16:01:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3ABEC10942;
	Sun, 29 Oct 2023 16:01:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="aq0CxYBL"
X-Original-To: kvm@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 81CCED51E
	for <kvm@vger.kernel.org>; Sun, 29 Oct 2023 16:01:02 +0000 (UTC)
Received: from NAM04-DM6-obe.outbound.protection.outlook.com (mail-dm6nam04on2050.outbound.protection.outlook.com [40.107.102.50])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4BFC3D3
	for <kvm@vger.kernel.org>; Sun, 29 Oct 2023 09:00:57 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=B61p6ONTiAJqflx4e4lVHjVtDSnfLTXsKtU4j80vSoI5kfnC4HQKTCUsDyCTc+EKJNa75hiJFRzGxZHlTPmDQuOthEOMeyPI+TQFef0vQhpj89zg4zbQn/87x8HP3u+qdiZGG3t3q8GR1gq6kVAJ0s5QLNBB3uDmi5gh5V4Axwnpi8/RVLXprzOIexQq+3LC1CSnala7PjfsHHD6tCqtTxArgG6pOxu80M7LR7fugOOdSNZ89C1hH/cwhhq3Rwjc+pOsSCi/fcBcuGif/SUgOx8JI3AyQg8Y/490+F99IL8CBk62ZVtwMDAg6LB4DcUhX00viOzi/m5jd95gM32wgg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=iVYIrKKUPXKdSSmymniXjMPrYne3DFomu3f/EDbx190=;
 b=XVAEATo/SdFo1oiGcLaHpCOB4eSyrog9QmZlL1pOtR9TGiFtAfgpzuxWe5thfkIqKVkuBVGGUEXBnrrQD4oY9arLdTWnk8oH6Q2ZwVojdCFhqlf/YOnrD1fDiyVTV8/B+0LHiigbbhrSbujfNhNYiZ0HteD39FIYmmtfQeTuFZ4oJ7m9XgTCaBYe2g/d+1Y/Tyos4rLhFvjVkK2dZfIuKM34VKdAU4kRWQyAVJVQ0wQerO7FmZtPBRWuT+zVuktSn3mmyL8Big9U1XrWBRAbBFwRz6heRGemF164PAQWZsyYLae5wc4ZhsLmo1JLy4O2TI9GOUB0AsUBKiRWLoGShw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.118.232) smtp.rcpttodomain=redhat.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=iVYIrKKUPXKdSSmymniXjMPrYne3DFomu3f/EDbx190=;
 b=aq0CxYBL2JU0a5eLkpPup26fii/wnKdksYWjIc/IQ9xnQ1or84TewsItZOMgACTrMItBj+0IQ+zreBckUo5JrzjMcRto6sliT8eRWJC3AQCuwwpAkKg06i8QSQeLzPdJ4gF/LfuOTPZNad0tleH8BTUMsG7u/fVgyGx0yeG5tHxsQwqOnDv6Ty3HjiQ0YqOc97aadz2kbsZ03IQsDtLutWix9hRjiulrFyFI3JWkOPiy0kIqgJJy+KIakOIVBoPEYXh/aldOPx0KzRXmvCJv/AIfOBOE3VAdUCZOJ0VHFcnfyrs12kt4jaoQmZWHnPa4D3ySXo2g+WAkk9oyAqikVQ==
Received: from BLAPR05CA0033.namprd05.prod.outlook.com (2603:10b6:208:335::14)
 by MN2PR12MB4357.namprd12.prod.outlook.com (2603:10b6:208:262::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6933.26; Sun, 29 Oct
 2023 16:00:52 +0000
Received: from BL6PEPF0001AB4A.namprd04.prod.outlook.com
 (2603:10b6:208:335:cafe::cc) by BLAPR05CA0033.outlook.office365.com
 (2603:10b6:208:335::14) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6954.14 via Frontend
 Transport; Sun, 29 Oct 2023 16:00:52 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.118.232)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.118.232 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.118.232; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.118.232) by
 BL6PEPF0001AB4A.mail.protection.outlook.com (10.167.242.68) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6933.15 via Frontend Transport; Sun, 29 Oct 2023 16:00:52 +0000
Received: from drhqmail201.nvidia.com (10.126.190.180) by mail.nvidia.com
 (10.127.129.5) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.41; Sun, 29 Oct
 2023 09:00:36 -0700
Received: from drhqmail203.nvidia.com (10.126.190.182) by
 drhqmail201.nvidia.com (10.126.190.180) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.986.41; Sun, 29 Oct 2023 09:00:36 -0700
Received: from vdi.nvidia.com (10.127.8.10) by mail.nvidia.com
 (10.126.190.182) with Microsoft SMTP Server id 15.2.986.41 via Frontend
 Transport; Sun, 29 Oct 2023 09:00:32 -0700
From: Yishai Hadas <yishaih@nvidia.com>
To: <alex.williamson@redhat.com>, <mst@redhat.com>, <jasowang@redhat.com>,
	<jgg@nvidia.com>
CC: <kvm@vger.kernel.org>, <virtualization@lists.linux-foundation.org>,
	<parav@nvidia.com>, <feliu@nvidia.com>, <jiri@nvidia.com>,
	<kevin.tian@intel.com>, <joao.m.martins@oracle.com>, <si-wei.liu@oracle.com>,
	<leonro@nvidia.com>, <yishaih@nvidia.com>, <maorg@nvidia.com>
Subject: [PATCH V2 vfio 6/9] virtio-pci: Introduce APIs to execute legacy IO admin commands
Date: Sun, 29 Oct 2023 17:59:49 +0200
Message-ID: <20231029155952.67686-7-yishaih@nvidia.com>
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
X-MS-TrafficTypeDiagnostic: BL6PEPF0001AB4A:EE_|MN2PR12MB4357:EE_
X-MS-Office365-Filtering-Correlation-Id: c86b02f0-d424-4098-78bd-08dbd8983a41
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	dRxYo+pIWP5eYFY4wr7YSXce1xt+LgJVlzrfCRrMcT1s3be3dd1uVZRNvDj8ry3JDxJmH8Mb5Ddo8XA68yutlwl2tGJfPg07AM8PALCQyIvkf/fqbyA7j3L6S6YQfjwoxTpSJ7bydKOuBiD4hhDp8eqByiO98AUMLlC4P/Uxrrrpw2CMTXXcA+myr7HFqUBvb56M/pppdy/VAqK/mifIRudn1leLnzxj9Ko9G8OAtL+jXdYblM9eOeLYojbwBKlINhHKbmI6Yj7eN1aTY5oy5x5FAVUCMW+X9e7Mj6qO1s4Tk3WFIIlN58LI4CWdbhw8QQ/jXEj0pBpb/nf9+4PKU7NWNmmeoJvuXwRjyL7XJGZM4JDeibJEnZvJsxAhko34oIJ+j8aNpmXdkkAIssLi/kkX8K0Ya6lLAMzd8aAr4/3a4fsxbNNPvlvGcSh6AbnzanepETwiZAS08LQM85+xBE/fKgRhV5zBH8Y3RO1raMdKia3Bvp25bBpIyE0NxC7ANj6kUXnwf0cefT4bwzcZCN4u3YQ0qZhYcdw07YCO6/3dwoCWxXn4MtwlCPZI+AKVHrOJuBXIEeShZo5+khzqsCwhZC2SpR+LUH6PuCU1sHwsC9A3VVOyfzUJpXxbP60lgjAXr2MTQZmaw4KS6ntKXwULWmd/KXzSiXXzYgA/BoIeK3Bb9nBs2xZsPIraLXinUc2ftTvPVu0BXzvl93IcPtBIFhBTgIKtWgRdQfQzjbNdkXMvp+dtTR5omNs02YRHxrbxRs5weXnrWDoP92OEVg==
X-Forefront-Antispam-Report:
	CIP:216.228.118.232;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc7edge1.nvidia.com;CAT:NONE;SFS:(13230031)(4636009)(346002)(396003)(136003)(39860400002)(376002)(230922051799003)(451199024)(64100799003)(1800799009)(82310400011)(186009)(40470700004)(46966006)(36840700001)(2906002)(40460700003)(36860700001)(6636002)(54906003)(70206006)(70586007)(47076005)(356005)(7636003)(82740400003)(316002)(107886003)(6666004)(7696005)(26005)(478600001)(83380400001)(110136005)(2616005)(426003)(1076003)(336012)(41300700001)(5660300002)(30864003)(8936002)(8676002)(4326008)(86362001)(40480700001)(36756003)(2101003);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Oct 2023 16:00:52.5180
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: c86b02f0-d424-4098-78bd-08dbd8983a41
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.118.232];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BL6PEPF0001AB4A.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR12MB4357

Introduce APIs to execute legacy IO admin commands.

It includes: io_legacy_read/write for both common and the device
registers, io_legacy_notify_info.

In addition, exposing an API to check whether the legacy IO commands are
supported. (i.e. virtio_pci_admin_has_legacy_io()).

Those APIs will be used by the next patches from this series.

Signed-off-by: Yishai Hadas <yishaih@nvidia.com>
---
 drivers/virtio/virtio_pci_common.c |  11 ++
 drivers/virtio/virtio_pci_common.h |   2 +
 drivers/virtio/virtio_pci_modern.c | 241 +++++++++++++++++++++++++++++
 include/linux/virtio_pci_admin.h   |  21 +++
 4 files changed, 275 insertions(+)
 create mode 100644 include/linux/virtio_pci_admin.h

diff --git a/drivers/virtio/virtio_pci_common.c b/drivers/virtio/virtio_pci_common.c
index 6b4766d5abe6..212d68401d2c 100644
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
index 9e07e556a51a..07d4f863ac44 100644
--- a/drivers/virtio/virtio_pci_common.h
+++ b/drivers/virtio/virtio_pci_common.h
@@ -156,4 +156,6 @@ static inline void virtio_pci_legacy_remove(struct virtio_pci_device *vp_dev)
 int virtio_pci_modern_probe(struct virtio_pci_device *);
 void virtio_pci_modern_remove(struct virtio_pci_device *);
 
+struct virtio_device *virtio_pci_vf_get_pf_dev(struct pci_dev *pdev);
+
 #endif
diff --git a/drivers/virtio/virtio_pci_modern.c b/drivers/virtio/virtio_pci_modern.c
index 25e27aa79cab..def0f2de6091 100644
--- a/drivers/virtio/virtio_pci_modern.c
+++ b/drivers/virtio/virtio_pci_modern.c
@@ -15,6 +15,7 @@
  */
 
 #include <linux/delay.h>
+#include <linux/virtio_pci_admin.h>
 #define VIRTIO_PCI_NO_LEGACY
 #define VIRTIO_RING_NO_LEGACY
 #include "virtio_pci_common.h"
@@ -794,6 +795,246 @@ static void vp_modern_destroy_avq(struct virtio_device *vdev)
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
+ * virtio_pci_admin_legacy_io_write_common - Write common legacy registers
+ * of a member device
+ * @dev: VF pci_dev
+ * @offset: starting byte offset within the registers to write to
+ * @size: size of the data to write
+ * @buf: buffer which holds the data
+ *
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
+ * virtio_pci_admin_legacy_io_write_device - Write device legacy registers
+ * of a member device
+ * @dev: VF pci_dev
+ * @offset: starting byte offset within the registers to write to
+ * @size: size of the data to write
+ * @buf: buffer which holds the data
+ *
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
+ * virtio_pci_admin_legacy_device_io_read - Read legacy device registers of
+ * a member device
+ * @dev: VF pci_dev
+ * @offset: starting byte offset within the registers to read from
+ * @size: size of the data to be read
+ * @buf: buffer to hold the returned data
+ *
+ * Returns 0 on success, or negative on failure.
+ */
+int virtio_pci_admin_legacy_device_io_read(struct pci_dev *pdev, u8 offset,
+					   u8 size, u8 *buf)
+{
+	return virtio_pci_admin_legacy_io_read(pdev,
+					VIRTIO_ADMIN_CMD_LEGACY_COMMON_CFG_READ,
+					offset, size, buf);
+}
+EXPORT_SYMBOL_GPL(virtio_pci_admin_legacy_device_io_read);
+
+/*
+ * virtio_pci_admin_legacy_common_io_read - Read legacy common registers of
+ * a member device
+ * @dev: VF pci_dev
+ * @offset: starting byte offset within the registers to read from
+ * @size: size of the data to be read
+ * @buf: buffer to hold the returned data
+ *
+ * Returns 0 on success, or negative on failure.
+ */
+int virtio_pci_admin_legacy_common_io_read(struct pci_dev *pdev, u8 offset,
+					    u8 size, u8 *buf)
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
+ * @bar: on output the BAR number of the member device
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


