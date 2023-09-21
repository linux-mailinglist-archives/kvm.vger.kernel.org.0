Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1DB047A97D6
	for <lists+kvm@lfdr.de>; Thu, 21 Sep 2023 19:27:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230269AbjIUR2A (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 21 Sep 2023 13:28:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54856 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230076AbjIUR1g (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 21 Sep 2023 13:27:36 -0400
Received: from NAM04-BN8-obe.outbound.protection.outlook.com (mail-bn8nam04on2060c.outbound.protection.outlook.com [IPv6:2a01:111:f400:7e8d::60c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 604522122
        for <kvm@vger.kernel.org>; Thu, 21 Sep 2023 10:01:15 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=obs13qzRLqEp2cvKb7XAL3FTvpzxqO20AiQrfkzNfGp0QGTqbi+ze6ZL+wUCiOSeEcK6LFhYGZSQZdOzQmLwkm4yScuLD65Q+75m8wo8AwnLYZB1BUBokeNK4YT53SeWuS1KdqvRJoWVHiCGp3ZcfOvJONVOdoxQ9VcFKk8xVM4HCzjLTTexFlPP09VujhlrriMDde+q9ZywmxQPi4cJcJpcjJ4dhyHctYlRAFBzy313UGVla+tn7JFroSUk8SGs7aKKd6gfNruarg1ClMCkdjY3zkOK1G6yxVJ9e/VK5jQYaksw0Y88FUoFRz23WQ/AMsQbYup04VoQPPuTlLRvbQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=wo6WmwIdSkX0NeDL2rVYm1D/kPxM7/2CfouItdS7Ck8=;
 b=M3m7oUDuQq/IIaNXAXJb30uY7MDND6cTasFNBLL4YrmffUGYJ/Rn97lHZbSrm+pZQUfTvj8HO4wcU02H768emfiHQxLriGwN6SEJh9or5DeYKLGl8mnYxrqwvsNDoRQSJINRUfDIr2jcRY1chLAlP84WpM+laNeNJk1FOn/oN49Xt9LUrqbwJkHtnxXwxG8gN34v1GJOyw5g2KQpVcSxEZQ0Bfb6uhX6PjXojrQdaXW3Df6lPDugSjbbjJDcXztjhBqLA4uGlzhky35s8OYt7JWkS8dRX3+rmHW0Yu7ZPUVvnLNv9BtheDwy5q6H3rc2Y2JEQBglbQEHVhGXXaSphg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=redhat.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wo6WmwIdSkX0NeDL2rVYm1D/kPxM7/2CfouItdS7Ck8=;
 b=GfYy9s7iUOVw4+oAT/ZhUGJcJpR4oY4ev/PDIjjX2eN7SmVMAAB4FVH9K7FEg+IKFwqSppXeNwA0iOxq8YlQYM/+SLcFiK/wED6ULzfQ+YHT4qOIfZnbxx5cFNuLk+rmC+1jMyL5xty9upK5Y5sut58aKPc1kTuxPsu/NM/K8VUKmju8WWDGWzbQEBEJZYAW5uxUCYlQ7TXGfiB5RUzFagorUhCTfDBf6okd9rKahZ62Jn8O3j1tzODgY8QVZvmj7EJtdiGn6d0nOUEMtUG71QL0OxmAE9EiKZR5TFkS2f+PXzigeMPN4eduE8Z6JwkVE8gj6ifW3q5/nH+DQz9a1w==
Received: from BYAPR11CA0041.namprd11.prod.outlook.com (2603:10b6:a03:80::18)
 by DS0PR12MB8501.namprd12.prod.outlook.com (2603:10b6:8:15d::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6792.30; Thu, 21 Sep
 2023 12:42:16 +0000
Received: from DS3PEPF000099D5.namprd04.prod.outlook.com
 (2603:10b6:a03:80:cafe::a0) by BYAPR11CA0041.outlook.office365.com
 (2603:10b6:a03:80::18) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6792.30 via Frontend
 Transport; Thu, 21 Sep 2023 12:42:15 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.161)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 DS3PEPF000099D5.mail.protection.outlook.com (10.167.17.6) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6792.20 via Frontend Transport; Thu, 21 Sep 2023 12:42:15 +0000
Received: from rnnvmail202.nvidia.com (10.129.68.7) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.41; Thu, 21 Sep
 2023 05:42:03 -0700
Received: from rnnvmail204.nvidia.com (10.129.68.6) by rnnvmail202.nvidia.com
 (10.129.68.7) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.41; Thu, 21 Sep
 2023 05:42:02 -0700
Received: from vdi.nvidia.com (10.127.8.10) by mail.nvidia.com (10.129.68.6)
 with Microsoft SMTP Server id 15.2.986.41 via Frontend Transport; Thu, 21 Sep
 2023 05:41:59 -0700
From:   Yishai Hadas <yishaih@nvidia.com>
To:     <alex.williamson@redhat.com>, <mst@redhat.com>,
        <jasowang@redhat.com>, <jgg@nvidia.com>
CC:     <kvm@vger.kernel.org>, <virtualization@lists.linux-foundation.org>,
        <parav@nvidia.com>, <feliu@nvidia.com>, <jiri@nvidia.com>,
        <kevin.tian@intel.com>, <joao.m.martins@oracle.com>,
        <leonro@nvidia.com>, <yishaih@nvidia.com>, <maorg@nvidia.com>
Subject: [PATCH vfio 10/11] vfio/virtio: Expose admin commands over virtio device
Date:   Thu, 21 Sep 2023 15:40:39 +0300
Message-ID: <20230921124040.145386-11-yishaih@nvidia.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20230921124040.145386-1-yishaih@nvidia.com>
References: <20230921124040.145386-1-yishaih@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-NV-OnPremToCloud: ExternallySecured
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS3PEPF000099D5:EE_|DS0PR12MB8501:EE_
X-MS-Office365-Filtering-Correlation-Id: 26ef6772-5ae2-4483-1404-08dbbaa02f5a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Koq1JKg6gKopejYPxqvIjWdkwKr4lBUruFca9uQxAXl5vRHaMeMvkJyRBgXLP0gQkIV0SSTAI7smPqE7dgey98JAh/u/lMbPZo7wz/AqqCIoOwZrtbfRYJTKeB06B8HbveLeTPadapqQwWq8YPQx/FyjJ2HWtTizTd1e8+W59LIqMHYvxfSkZ0SyU+UTsxv1eEkoknlBYpxxgKuBcw6K8PXzWEb1SQp+TE5UafiAqIWMrdp3GGSkNgDzIhvJH7MQzC5lAO9c9GT+6bAdzmJ2t31pcJI6JwNWxamcpIRlVxZKVTdv/YfU2zrXm3FFOwhvYv0PM+14PWWW51jLzb4QopNRonRWZA+HmeUmMDfSH+jFanpqEGOSQ1RTLyidc4aChkowalIu3LQ4LRRwBNVilPHavasqw+yKixCc00wS9Sunnj8adHS4rJf3WmVAVpXYVedQeBX6V4oxMUDGRLz9wxNgB8Cf2+UYzQJ5e2BRdP/qESpkiNNUBV1139+f3R+OotXqIy8RGdE8DTo7B6lwOh8CirBUusIqFLWT7DyRlrpFfS9yAaMK0DKXXd70kntbAUTPYBYWR6EsQbUm4sYJ2iGiSPx0F43oGlWNpnnygEixRsOQA5NMJT/I4+OVl4C2GV57R6yaowjIhGv5XYcm4cyx1XVqO1b2OyT2DnSLxrrdFHZ5BklE8SqHNk9VhHLMSN4tBibFeKRcuu79GuWgf3QEpYKk+mw1GcS/rjpQGo4CEo483I19ZhyqIQ7c6MizFUJ/S/FuMX/oI0pLK7Wk4g==
X-Forefront-Antispam-Report: CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230031)(4636009)(136003)(346002)(396003)(376002)(39860400002)(451199024)(1800799009)(186009)(82310400011)(36840700001)(40470700004)(46966006)(7696005)(6666004)(40460700003)(36756003)(40480700001)(7636003)(356005)(86362001)(82740400003)(36860700001)(1076003)(2906002)(426003)(47076005)(336012)(26005)(8936002)(478600001)(83380400001)(5660300002)(110136005)(4326008)(54906003)(41300700001)(316002)(70586007)(6636002)(2616005)(70206006)(107886003)(8676002)(2101003);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Sep 2023 12:42:15.3460
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 26ef6772-5ae2-4483-1404-08dbbaa02f5a
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DS3PEPF000099D5.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR12MB8501
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_PASS,SPF_NONE,URIBL_BLOCKED
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Expose admin commands over the virtio device, to be used by the
vfio-virtio driver in the next patches.

It includes: list query/use, legacy write/read, read notify_info.

Signed-off-by: Yishai Hadas <yishaih@nvidia.com>
---
 drivers/vfio/pci/virtio/cmd.c | 146 ++++++++++++++++++++++++++++++++++
 drivers/vfio/pci/virtio/cmd.h |  27 +++++++
 2 files changed, 173 insertions(+)
 create mode 100644 drivers/vfio/pci/virtio/cmd.c
 create mode 100644 drivers/vfio/pci/virtio/cmd.h

diff --git a/drivers/vfio/pci/virtio/cmd.c b/drivers/vfio/pci/virtio/cmd.c
new file mode 100644
index 000000000000..f068239cdbb0
--- /dev/null
+++ b/drivers/vfio/pci/virtio/cmd.c
@@ -0,0 +1,146 @@
+// SPDX-License-Identifier: GPL-2.0 OR Linux-OpenIB
+/*
+ * Copyright (c) 2023, NVIDIA CORPORATION & AFFILIATES. All rights reserved
+ */
+
+#include "cmd.h"
+
+int virtiovf_cmd_list_query(struct pci_dev *pdev, u8 *buf, int buf_size)
+{
+	struct virtio_device *virtio_dev = virtio_pci_vf_get_pf_dev(pdev);
+	struct scatterlist out_sg;
+	struct virtio_admin_cmd cmd = {};
+
+	if (!virtio_dev)
+		return -ENOTCONN;
+
+	sg_init_one(&out_sg, buf, buf_size);
+	cmd.opcode = VIRTIO_ADMIN_CMD_LIST_QUERY;
+	cmd.group_type = VIRTIO_ADMIN_GROUP_TYPE_SRIOV;
+	cmd.result_sg = &out_sg;
+
+	return virtio_admin_cmd_exec(virtio_dev, &cmd);
+}
+
+int virtiovf_cmd_list_use(struct pci_dev *pdev, u8 *buf, int buf_size)
+{
+	struct virtio_device *virtio_dev = virtio_pci_vf_get_pf_dev(pdev);
+	struct scatterlist in_sg;
+	struct virtio_admin_cmd cmd = {};
+
+	if (!virtio_dev)
+		return -ENOTCONN;
+
+	sg_init_one(&in_sg, buf, buf_size);
+	cmd.opcode = VIRTIO_ADMIN_CMD_LIST_USE;
+	cmd.group_type = VIRTIO_ADMIN_GROUP_TYPE_SRIOV;
+	cmd.data_sg = &in_sg;
+
+	return virtio_admin_cmd_exec(virtio_dev, &cmd);
+}
+
+int virtiovf_cmd_lr_write(struct virtiovf_pci_core_device *virtvdev, u16 opcode,
+			  u8 offset, u8 size, u8 *buf)
+{
+	struct virtio_device *virtio_dev =
+		virtio_pci_vf_get_pf_dev(virtvdev->core_device.pdev);
+	struct virtio_admin_cmd_data_lr_write *in;
+	struct scatterlist in_sg;
+	struct virtio_admin_cmd cmd = {};
+	int ret;
+
+	if (!virtio_dev)
+		return -ENOTCONN;
+
+	in = kzalloc(sizeof(*in) + size, GFP_KERNEL);
+	if (!in)
+		return -ENOMEM;
+
+	in->offset = offset;
+	memcpy(in->registers, buf, size);
+	sg_init_one(&in_sg, in, sizeof(*in) + size);
+	cmd.opcode = opcode;
+	cmd.group_type = VIRTIO_ADMIN_GROUP_TYPE_SRIOV;
+	cmd.group_member_id = virtvdev->vf_id + 1;
+	cmd.data_sg = &in_sg;
+	ret = virtio_admin_cmd_exec(virtio_dev, &cmd);
+
+	kfree(in);
+	return ret;
+}
+
+int virtiovf_cmd_lr_read(struct virtiovf_pci_core_device *virtvdev, u16 opcode,
+			 u8 offset, u8 size, u8 *buf)
+{
+	struct virtio_device *virtio_dev =
+		virtio_pci_vf_get_pf_dev(virtvdev->core_device.pdev);
+	struct virtio_admin_cmd_data_lr_read *in;
+	struct scatterlist in_sg, out_sg;
+	struct virtio_admin_cmd cmd = {};
+	int ret;
+
+	if (!virtio_dev)
+		return -ENOTCONN;
+
+	in = kzalloc(sizeof(*in), GFP_KERNEL);
+	if (!in)
+		return -ENOMEM;
+
+	in->offset = offset;
+	sg_init_one(&in_sg, in, sizeof(*in));
+	sg_init_one(&out_sg, buf, size);
+	cmd.opcode = opcode;
+	cmd.group_type = VIRTIO_ADMIN_GROUP_TYPE_SRIOV;
+	cmd.data_sg = &in_sg;
+	cmd.result_sg = &out_sg;
+	cmd.group_member_id = virtvdev->vf_id + 1;
+	ret = virtio_admin_cmd_exec(virtio_dev, &cmd);
+
+	kfree(in);
+	return ret;
+}
+
+int virtiovf_cmd_lq_read_notify(struct virtiovf_pci_core_device *virtvdev,
+				u8 req_bar_flags, u8 *bar, u64 *bar_offset)
+{
+	struct virtio_device *virtio_dev =
+		virtio_pci_vf_get_pf_dev(virtvdev->core_device.pdev);
+	struct virtio_admin_cmd_notify_info_result *out;
+	struct scatterlist out_sg;
+	struct virtio_admin_cmd cmd = {};
+	int ret;
+
+	if (!virtio_dev)
+		return -ENOTCONN;
+
+	out = kzalloc(sizeof(*out), GFP_KERNEL);
+	if (!out)
+		return -ENOMEM;
+
+	sg_init_one(&out_sg, out, sizeof(*out));
+	cmd.opcode = VIRTIO_ADMIN_CMD_LEGACY_NOTIFY_INFO;
+	cmd.group_type = VIRTIO_ADMIN_GROUP_TYPE_SRIOV;
+	cmd.result_sg = &out_sg;
+	cmd.group_member_id = virtvdev->vf_id + 1;
+	ret = virtio_admin_cmd_exec(virtio_dev, &cmd);
+	if (!ret) {
+		struct virtio_admin_cmd_notify_info_data *entry;
+		int i;
+
+		ret = -ENOENT;
+		for (i = 0; i < VIRTIO_ADMIN_CMD_MAX_NOTIFY_INFO; i++) {
+			entry = &out->entries[i];
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
+	kfree(out);
+	return ret;
+}
diff --git a/drivers/vfio/pci/virtio/cmd.h b/drivers/vfio/pci/virtio/cmd.h
new file mode 100644
index 000000000000..c2a3645f4b90
--- /dev/null
+++ b/drivers/vfio/pci/virtio/cmd.h
@@ -0,0 +1,27 @@
+// SPDX-License-Identifier: GPL-2.0 OR Linux-OpenIB
+/*
+ * Copyright (c) 2023, NVIDIA CORPORATION & AFFILIATES. All rights reserved.
+ */
+
+#ifndef VIRTIO_VFIO_CMD_H
+#define VIRTIO_VFIO_CMD_H
+
+#include <linux/kernel.h>
+#include <linux/virtio.h>
+#include <linux/vfio_pci_core.h>
+#include <linux/virtio_pci.h>
+
+struct virtiovf_pci_core_device {
+	struct vfio_pci_core_device core_device;
+	int vf_id;
+};
+
+int virtiovf_cmd_list_query(struct pci_dev *pdev, u8 *buf, int buf_size);
+int virtiovf_cmd_list_use(struct pci_dev *pdev, u8 *buf, int buf_size);
+int virtiovf_cmd_lr_write(struct virtiovf_pci_core_device *virtvdev, u16 opcode,
+			  u8 offset, u8 size, u8 *buf);
+int virtiovf_cmd_lr_read(struct virtiovf_pci_core_device *virtvdev, u16 opcode,
+			 u8 offset, u8 size, u8 *buf);
+int virtiovf_cmd_lq_read_notify(struct virtiovf_pci_core_device *virtvdev,
+				u8 req_bar_flags, u8 *bar, u64 *bar_offset);
+#endif /* VIRTIO_VFIO_CMD_H */
-- 
2.27.0

