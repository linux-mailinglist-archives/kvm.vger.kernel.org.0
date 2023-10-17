Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 27C017CC4FD
	for <lists+kvm@lfdr.de>; Tue, 17 Oct 2023 15:43:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343839AbjJQNn1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 17 Oct 2023 09:43:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34296 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343951AbjJQNnZ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 17 Oct 2023 09:43:25 -0400
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2042.outbound.protection.outlook.com [40.107.94.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 67BB3F2
        for <kvm@vger.kernel.org>; Tue, 17 Oct 2023 06:43:23 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=AWx+21UEpM7DUqmnGplXYy94NvkOdWUGOGFfXf+vIftKfq9dnD+Kt5RnoP3lo0VJCDpQg13a7hhUD2d+N5YYM8Gkwx76qEgoDHMZ3XJ2YjadiacF8/zUoFHTb93kyeAmn8ugkUty8cF6y6Ucv8jwRNO+xfSY84ZIjLlgh0MSdsYnvErUMd44rZK7r0HhHg+Kop3O0/6mYjkbL5lFKcqGZRX/u8rrDHuyOqxAhAS4aEmczX/ymvNwrEgen4obTS1nNj6UW3HQ32lfPn/kAsDfyFDkOgDsXWOOCRXqW6FeV0sPoyomKWJ8My5Cv+xR2GRyuEGH87g0aWalO8gHDwQauw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=/Hzt3LlE9oKpkaEQVGO0qb6WbPswtHZG+hctn50Uums=;
 b=jX0V+uXs0zMW3Toa5SJGp4dNB8Wu/P9tegV0iyXbecwYjgz2BtcRKl556Gp/AtR5Yxwel2Xt16+7VqjM8T9hKrTIg1OITBWVUey90V1U/7VlTtOmdT/KubSd3drjlT7QWeiN5VRcL3Ba9BPZKD7ZjUrN/pdZ+h4H8uQxVHFpnKpAeEL1ht/MxBXD8wraDBQA5DyRr4fVe8C4EPfzAlD29OwX9EeTy+qJagizus198GfAkcINTfxSC2QXckzSjk0IA3oPDKAhG5dED8DedBmvWaYU2XYmaHlw+N/I5OjdyE5QQrhV24p9jvBy+o0Cri7WhO7jiJUbfUiZfcoBgSY5qw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=redhat.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/Hzt3LlE9oKpkaEQVGO0qb6WbPswtHZG+hctn50Uums=;
 b=Ot/0WPWnuIWsLZnHv6HITOAUpGbjtj0hDU5Bnjz69V2kO90vGHmpgqQ0DkEyD7f6d8sSghzg3iS+oiqMd0cExHQVwqsJUtimciC1NMc/1qsWKWodZmdOU5xg8U97gpxVYBwbElLodi+T1S6agrtqgxf8CkqpitKOQqgvO6mevSaVwIxaaO0bZYQ5iP+kV1A+K9YysGWEXTa4qYAopmUdEC38bZ92F/EkHP2358jvQdpgUK57YQoTbFtsGLDOpiW0dPEsovCWXkCwBJaZVtotUKcadL+LLMeRg88NnQ2xc34i2TcY/16z2BG2sJmagPpmmH4st0g/E+nltcNDf8CSfA==
Received: from MN2PR05CA0007.namprd05.prod.outlook.com (2603:10b6:208:c0::20)
 by DS7PR12MB6334.namprd12.prod.outlook.com (2603:10b6:8:95::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6886.35; Tue, 17 Oct
 2023 13:43:20 +0000
Received: from BL02EPF0001A103.namprd05.prod.outlook.com
 (2603:10b6:208:c0:cafe::3) by MN2PR05CA0007.outlook.office365.com
 (2603:10b6:208:c0::20) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6907.18 via Frontend
 Transport; Tue, 17 Oct 2023 13:43:20 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.161)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 BL02EPF0001A103.mail.protection.outlook.com (10.167.241.133) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6907.20 via Frontend Transport; Tue, 17 Oct 2023 13:43:20 +0000
Received: from rnnvmail205.nvidia.com (10.129.68.10) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.41; Tue, 17 Oct
 2023 06:43:06 -0700
Received: from rnnvmail205.nvidia.com (10.129.68.10) by rnnvmail205.nvidia.com
 (10.129.68.10) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.41; Tue, 17 Oct
 2023 06:43:06 -0700
Received: from vdi.nvidia.com (10.127.8.10) by mail.nvidia.com (10.129.68.10)
 with Microsoft SMTP Server id 15.2.986.41 via Frontend Transport; Tue, 17 Oct
 2023 06:43:02 -0700
From:   Yishai Hadas <yishaih@nvidia.com>
To:     <alex.williamson@redhat.com>, <mst@redhat.com>,
        <jasowang@redhat.com>, <jgg@nvidia.com>
CC:     <kvm@vger.kernel.org>, <virtualization@lists.linux-foundation.org>,
        <parav@nvidia.com>, <feliu@nvidia.com>, <jiri@nvidia.com>,
        <kevin.tian@intel.com>, <joao.m.martins@oracle.com>,
        <si-wei.liu@oracle.com>, <leonro@nvidia.com>, <yishaih@nvidia.com>,
        <maorg@nvidia.com>
Subject: [PATCH V1 vfio 6/9] virtio-pci: Introduce APIs to execute legacy IO admin commands
Date:   Tue, 17 Oct 2023 16:42:14 +0300
Message-ID: <20231017134217.82497-7-yishaih@nvidia.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20231017134217.82497-1-yishaih@nvidia.com>
References: <20231017134217.82497-1-yishaih@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-NV-OnPremToCloud: ExternallySecured
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL02EPF0001A103:EE_|DS7PR12MB6334:EE_
X-MS-Office365-Filtering-Correlation-Id: b8ba6ff7-a8e7-4523-8586-08dbcf1706bc
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 9oOB0cT0k1vNWuPUWbJ4L+Lz5hMSl2m3tF6P5BMqVoLMj3RWTMiNs1ZdTGw+ziH0eH6Bksutw7nTKYIrtPu87g8UkUYzJi4FklQnxhoW/dkv0PT6rUorkrgNqXzNXrx1oaqtB5UffZmuDgm/Sf2sYg4fEa5A9jt05vt5weuaWW31ceKICW0XtrFJpD1k+zZ8CqkAt79zKUnXYRYSYfjnUjxzQntgfzw7GgVtjhTGsIA9aQ1CvQ17qZDVeX43Ipco4ivgURHQoKirOtUyBhSsfwXTI6hnzpYu2oziGUpFK4fXt7YsXvWfb23N8gxZCHypbhLVvweuPRE+mqxP2i4w8RqLs/lGovqpgK3vLOfckL1FjR8XQbkyMF7WyKzNEYupe2Brqls0R2E/o3xp1s3YeDxTZGkfftg3uAakx+bP/agTjk/KbAoJU5+vO1ruFDIdZfGLaooCm0BnAshtR+8kwVk4iSU2MbjKywo+gnJFOR+XWHWDz/bTtSzcC1BkcAYFfNgsHxIr6r2B1RmrjyfSXwGosCZLg3el7YH8gQPqoJQMSR++CO3YvuC2/t2PXcYF+DMcpHvabUbUERwKCKZeBU7fhVJ6e5Lk/2Y4w9W/8JsvXTBIOufESauq7wZQA3/MppqqO6wDJ182R5IYI9IVBE4r8tidu6oN1mP2G37IiOmhmCeyBkWl90KUtFjdWkLgJt1y86zyHAfDGlJWmkjRpawP6MhwiyHBR4NE8rxpvJ2XwwKpBGGfvzSq9Amz2PW8
X-Forefront-Antispam-Report: CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230031)(4636009)(346002)(39860400002)(396003)(376002)(136003)(230922051799003)(451199024)(64100799003)(82310400011)(186009)(1800799009)(36840700001)(40470700004)(46966006)(336012)(40480700001)(40460700003)(82740400003)(36756003)(356005)(47076005)(83380400001)(36860700001)(6666004)(7636003)(26005)(7696005)(2906002)(54906003)(316002)(6636002)(70206006)(1076003)(426003)(2616005)(70586007)(478600001)(107886003)(110136005)(86362001)(41300700001)(8936002)(8676002)(4326008)(5660300002)(2101003);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Oct 2023 13:43:20.5241
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: b8ba6ff7-a8e7-4523-8586-08dbcf1706bc
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BL02EPF0001A103.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR12MB6334
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Introduce APIs to execute legacy IO admin commands.

It includes: list_query/use, io_legacy_read/write,
io_legacy_notify_info.

Those APIs will be used by the next patches from this series.

Signed-off-by: Yishai Hadas <yishaih@nvidia.com>
---
 drivers/virtio/virtio_pci_common.c |  11 ++
 drivers/virtio/virtio_pci_common.h |   2 +
 drivers/virtio/virtio_pci_modern.c | 206 +++++++++++++++++++++++++++++
 include/linux/virtio_pci_admin.h   |  18 +++
 4 files changed, 237 insertions(+)
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
index a21b9ba01a60..2785e61ed668 100644
--- a/drivers/virtio/virtio_pci_common.h
+++ b/drivers/virtio/virtio_pci_common.h
@@ -155,4 +155,6 @@ static inline void virtio_pci_legacy_remove(struct virtio_pci_device *vp_dev)
 int virtio_pci_modern_probe(struct virtio_pci_device *);
 void virtio_pci_modern_remove(struct virtio_pci_device *);
 
+struct virtio_device *virtio_pci_vf_get_pf_dev(struct pci_dev *pdev);
+
 #endif
diff --git a/drivers/virtio/virtio_pci_modern.c b/drivers/virtio/virtio_pci_modern.c
index cc159a8e6c70..00b65e20b2f5 100644
--- a/drivers/virtio/virtio_pci_modern.c
+++ b/drivers/virtio/virtio_pci_modern.c
@@ -719,6 +719,212 @@ static void vp_modern_destroy_avq(struct virtio_device *vdev)
 	vp_dev->del_vq(&vp_dev->admin_vq.info);
 }
 
+/*
+ * virtio_pci_admin_list_query - Provides to driver list of commands
+ * supported for the PCI VF.
+ * @dev: VF pci_dev
+ * @buf: buffer to hold the returned list
+ * @buf_size: size of the given buffer
+ *
+ * Returns 0 on success, or negative on failure.
+ */
+int virtio_pci_admin_list_query(struct pci_dev *pdev, u8 *buf, int buf_size)
+{
+	struct virtio_device *virtio_dev = virtio_pci_vf_get_pf_dev(pdev);
+	struct virtio_admin_cmd cmd = {};
+	struct scatterlist result_sg;
+
+	if (!virtio_dev)
+		return -ENODEV;
+
+	sg_init_one(&result_sg, buf, buf_size);
+	cmd.opcode = cpu_to_le16(VIRTIO_ADMIN_CMD_LIST_QUERY);
+	cmd.group_type = cpu_to_le16(VIRTIO_ADMIN_GROUP_TYPE_SRIOV);
+	cmd.result_sg = &result_sg;
+
+	return vp_modern_admin_cmd_exec(virtio_dev, &cmd);
+}
+EXPORT_SYMBOL_GPL(virtio_pci_admin_list_query);
+
+/*
+ * virtio_pci_admin_list_use - Provides to device list of commands
+ * used for the PCI VF.
+ * @dev: VF pci_dev
+ * @buf: buffer which holds the list
+ * @buf_size: size of the given buffer
+ *
+ * Returns 0 on success, or negative on failure.
+ */
+int virtio_pci_admin_list_use(struct pci_dev *pdev, u8 *buf, int buf_size)
+{
+	struct virtio_device *virtio_dev = virtio_pci_vf_get_pf_dev(pdev);
+	struct virtio_admin_cmd cmd = {};
+	struct scatterlist data_sg;
+
+	if (!virtio_dev)
+		return -ENODEV;
+
+	sg_init_one(&data_sg, buf, buf_size);
+	cmd.opcode = cpu_to_le16(VIRTIO_ADMIN_CMD_LIST_USE);
+	cmd.group_type = cpu_to_le16(VIRTIO_ADMIN_GROUP_TYPE_SRIOV);
+	cmd.data_sg = &data_sg;
+
+	return vp_modern_admin_cmd_exec(virtio_dev, &cmd);
+}
+EXPORT_SYMBOL_GPL(virtio_pci_admin_list_use);
+
+/*
+ * virtio_pci_admin_legacy_io_write - Write legacy registers of a member device
+ * @dev: VF pci_dev
+ * @opcode: op code of the io write command
+ * @offset: starting byte offset within the registers to write to
+ * @size: size of the data to write
+ * @buf: buffer which holds the data
+ *
+ * Returns 0 on success, or negative on failure.
+ */
+int virtio_pci_admin_legacy_io_write(struct pci_dev *pdev, u16 opcode,
+				     u8 offset, u8 size, u8 *buf)
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
+EXPORT_SYMBOL_GPL(virtio_pci_admin_legacy_io_write);
+
+/*
+ * virtio_pci_admin_legacy_io_read - Read legacy registers of a member device
+ * @dev: VF pci_dev
+ * @opcode: op code of the io read command
+ * @offset: starting byte offset within the registers to read from
+ * @size: size of the data to be read
+ * @buf: buffer to hold the returned data
+ *
+ * Returns 0 on success, or negative on failure.
+ */
+int virtio_pci_admin_legacy_io_read(struct pci_dev *pdev, u16 opcode,
+				    u8 offset, u8 size, u8 *buf)
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
+EXPORT_SYMBOL_GPL(virtio_pci_admin_legacy_io_read);
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
index 000000000000..cb916a4bc1b1
--- /dev/null
+++ b/include/linux/virtio_pci_admin.h
@@ -0,0 +1,18 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+#ifndef _LINUX_VIRTIO_PCI_ADMIN_H
+#define _LINUX_VIRTIO_PCI_ADMIN_H
+
+#include <linux/types.h>
+#include <linux/pci.h>
+
+int virtio_pci_admin_list_use(struct pci_dev *pdev, u8 *buf, int buf_size);
+int virtio_pci_admin_list_query(struct pci_dev *pdev, u8 *buf, int buf_size);
+int virtio_pci_admin_legacy_io_write(struct pci_dev *pdev, u16 opcode,
+				     u8 offset, u8 size, u8 *buf);
+int virtio_pci_admin_legacy_io_read(struct pci_dev *pdev, u16 opcode,
+				    u8 offset, u8 size, u8 *buf);
+int virtio_pci_admin_legacy_io_notify_info(struct pci_dev *pdev,
+					   u8 req_bar_flags, u8 *bar,
+					   u64 *bar_offset);
+
+#endif /* _LINUX_VIRTIO_PCI_ADMIN_H */
-- 
2.27.0

