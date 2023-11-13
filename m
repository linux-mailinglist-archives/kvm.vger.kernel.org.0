Return-Path: <kvm+bounces-1575-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id C38A07E973F
	for <lists+kvm@lfdr.de>; Mon, 13 Nov 2023 09:03:57 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 79C88280C65
	for <lists+kvm@lfdr.de>; Mon, 13 Nov 2023 08:03:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E0FE21863B;
	Mon, 13 Nov 2023 08:03:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="X7Bmr38x"
X-Original-To: kvm@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD6D8168A9
	for <kvm@vger.kernel.org>; Mon, 13 Nov 2023 08:03:33 +0000 (UTC)
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2062.outbound.protection.outlook.com [40.107.92.62])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 447E710F4
	for <kvm@vger.kernel.org>; Mon, 13 Nov 2023 00:03:30 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=I5Cx+vPpmZnoCHBwmIXpxVn3Vr9F0pZ6sxP4M5V5sP41mGEj6bcn44hWAHFM2/al7jVcVjfwC5tZoOL17FKmsPCI6zFOI2YFbeFdWzszBvdOZpvJK/FadAoOP/CBCMp+datYr0C8L8xLPWZ3iSyDSfI6pjVNdzWPzwWmNryXJuMiWklF9jS9KxlJ8vUsmyPbWBpy6rCjKXSAE5PhrBadMGXIMYwWRa66ARurLC8jXvJP+rhk/JshQGntXhw4KwqP2DuHw9LmlxmWS33cPbxE5VkmQdWSIFg0rZdtFCSKwqziOWNph4wIxCPeDnZLmO1ki92WQq6ZhHvNifR9g+DzMw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=s8/VWGuEQSrmMw8Nvm7YaDLYnlmClQWqjp9/lNO2NqQ=;
 b=e4ryh/IQ6pKbI1a1si2v6w4SxPbPmwQfIP5TmNuAeGi0z/wCCR0RKtT5x96zwA6PEqNxAT2vwJ9SAnoTtH984zHAocnugyOBQs8uoKM/CSk60QH1wxw9MKD+KHtMHGqsAciRAJ2QJ274FETQOL8yQc+1p+oqLtBcjumWeCej2zPzFH4c1RleBR0kARUkriO65Sq4D8wXK4zky8ao2W6B96rOUzld2HbSBbJfIIJoYNwZYVbRNZzlg2MMxccqsBPW2QBl/vE7EGW5mElhXdaTIYMYDUzo/bR6wlVBcSnQxS18wv7pUoNMXIL2Dt1mWw+eQ0GNgLqvBawlgeOkB9anlg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.118.233) smtp.rcpttodomain=redhat.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=s8/VWGuEQSrmMw8Nvm7YaDLYnlmClQWqjp9/lNO2NqQ=;
 b=X7Bmr38xUo/D8etf0uhKq81hKqVaHjZbOkTqcr0MSfCLFWKw3/rlw7oSIaMSHvH+QToxdYnNzk3tsA1h92EhlaZdOJwbnJHmwfTfIB4pfgU0VBlmOyrXDpYR56WS5mS5ueezybT90SefLIlBPES3vv5bHs7B9DVARasbHqmbdlMkaxDlEJA4w195DKQ6JLk8E9pe724CCIVMHI6f+ItQ5FriYKuZgPHOo1nypTpOGtijNYrCAK9OgmLfjgZ500RDK+jUH4EFmkuLXeYk+X8zPRGBhUBaS19q6+3mpIraUg4YSCt3IJcpoDQCPkl34Jr8/V9JoV36o7PjRJyQ2HrBcA==
Received: from BL0PR02CA0073.namprd02.prod.outlook.com (2603:10b6:208:51::14)
 by IA0PR12MB7604.namprd12.prod.outlook.com (2603:10b6:208:438::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6977.28; Mon, 13 Nov
 2023 08:03:28 +0000
Received: from BL02EPF0001A104.namprd05.prod.outlook.com
 (2603:10b6:208:51:cafe::d0) by BL0PR02CA0073.outlook.office365.com
 (2603:10b6:208:51::14) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6977.31 via Frontend
 Transport; Mon, 13 Nov 2023 08:03:28 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.118.233)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.118.233 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.118.233; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.118.233) by
 BL02EPF0001A104.mail.protection.outlook.com (10.167.241.135) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.7002.13 via Frontend Transport; Mon, 13 Nov 2023 08:03:27 +0000
Received: from drhqmail201.nvidia.com (10.126.190.180) by mail.nvidia.com
 (10.127.129.6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.41; Mon, 13 Nov
 2023 00:03:17 -0800
Received: from drhqmail203.nvidia.com (10.126.190.182) by
 drhqmail201.nvidia.com (10.126.190.180) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.986.41; Mon, 13 Nov 2023 00:03:16 -0800
Received: from vdi.nvidia.com (10.127.8.10) by mail.nvidia.com
 (10.126.190.182) with Microsoft SMTP Server id 15.2.986.41 via Frontend
 Transport; Mon, 13 Nov 2023 00:03:12 -0800
From: Yishai Hadas <yishaih@nvidia.com>
To: <alex.williamson@redhat.com>, <mst@redhat.com>, <jasowang@redhat.com>,
	<jgg@nvidia.com>
CC: <kvm@vger.kernel.org>, <virtualization@lists.linux-foundation.org>,
	<parav@nvidia.com>, <feliu@nvidia.com>, <jiri@nvidia.com>,
	<kevin.tian@intel.com>, <joao.m.martins@oracle.com>, <si-wei.liu@oracle.com>,
	<leonro@nvidia.com>, <yishaih@nvidia.com>, <maorg@nvidia.com>
Subject: [PATCH V3 vfio 5/9] virtio-pci: Initialize the supported admin commands
Date: Mon, 13 Nov 2023 10:02:18 +0200
Message-ID: <20231113080222.91795-6-yishaih@nvidia.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20231113080222.91795-1-yishaih@nvidia.com>
References: <20231113080222.91795-1-yishaih@nvidia.com>
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
X-MS-TrafficTypeDiagnostic: BL02EPF0001A104:EE_|IA0PR12MB7604:EE_
X-MS-Office365-Filtering-Correlation-Id: 1bcae7ba-269a-4545-5b2b-08dbe41f04e8
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	2UjVJAXHMwJmGtPOpx2hUNaYB08s0TmUw8BwCq8lLrr8eK24BGo0hm00ouVd7ZJaaNvb253AbUYZH27Pqi6O9H0gB3hf6gi/AXNcE44vBwRdcY9hGJ+LU1MYsSjumYosmW9wAcsrtk2sj2cBx7LBvwiA158+//m3J3ZTEWRAoCLiMiExzYsm8xKX86KVsQOHoVkjgE4d42juu19eAKiaf5/aE1Mx4AJKD0xG8w03XKl5cG2/mRRQLg3L9f/BEMx6INr/tan6Hl2aUh2svLiMqIF4/VOyI2wliegI1sFDlg4rK4gJeK12s6VU5D03DIpvkIeqbu0p7BPgp1/tBTC0c5Pumzk5jsPukG895UCMH2fFVC/m0V4WwSErNRDrK/0EIt3vGKRmvvgfv0l75RKbx94OsTo4U7pLVDsJo/tR6b24FKZUMgUv7O5fHjOltGR+vbdwHJuLRW/1RSEuzmzheP/CniUqDjmj+f6fS56eMj71JEIr4guMQaW6KTajWe8q0ZmD+g46rO1QWvE+GMWn7zdfsN1t+3OFgG+f4QUP+cCAoHfhDMTJjoTNiKtanPp7i2r0cXLiQhroT8BqyzieqGEqIoT69hCt4K8BxVY21HeW9T9ynab7yJDc8C2uEmRpZK9q84S4fBfJfxzcEvCQH03xoQXlwfsA0H7MfQh1wTt4wc6GqLHhoIjp7cmmBg/XnBkzYv4DwiGMWrVAy2VZQ+FgeSiQaaf1+D5nkyZDppCoATxvVH5jYNBLwtZDn+SFbBWwaNijiaX0wUZ3NC2esw==
X-Forefront-Antispam-Report:
	CIP:216.228.118.233;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc7edge2.nvidia.com;CAT:NONE;SFS:(13230031)(4636009)(376002)(346002)(396003)(136003)(39860400002)(230922051799003)(64100799003)(82310400011)(451199024)(1800799009)(186009)(40470700004)(36840700001)(46966006)(316002)(54906003)(70206006)(6636002)(70586007)(83380400001)(82740400003)(110136005)(8676002)(40480700001)(8936002)(4326008)(478600001)(36756003)(356005)(7636003)(7696005)(40460700003)(5660300002)(86362001)(2616005)(107886003)(1076003)(36860700001)(2906002)(47076005)(26005)(336012)(426003)(41300700001)(2101003);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Nov 2023 08:03:27.8481
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 1bcae7ba-269a-4545-5b2b-08dbe41f04e8
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.118.233];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BL02EPF0001A104.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA0PR12MB7604

Initialize the supported admin commands upon activating the admin queue.

The supported commands are saved as part of the admin queue context.

Next patches in this series will expose APIs to use them.

Signed-off-by: Yishai Hadas <yishaih@nvidia.com>
---
 drivers/virtio/virtio_pci_common.h |  1 +
 drivers/virtio/virtio_pci_modern.c | 48 ++++++++++++++++++++++++++++--
 2 files changed, 47 insertions(+), 2 deletions(-)

diff --git a/drivers/virtio/virtio_pci_common.h b/drivers/virtio/virtio_pci_common.h
index a50a58014c9f..2e3ae417519d 100644
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
diff --git a/drivers/virtio/virtio_pci_modern.c b/drivers/virtio/virtio_pci_modern.c
index 18366a82408c..951014dbb086 100644
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
@@ -117,8 +123,9 @@ static int vp_modern_admin_cmd_exec(struct virtio_device *vdev,
 	}
 
 	mutex_lock(&vp_dev->admin_vq.cmd_lock);
-	ret = virtqueue_exec_admin_cmd(&vp_dev->admin_vq, sgs,
-				       out_num, in_num, sgs);
+	ret = virtqueue_exec_admin_cmd(&vp_dev->admin_vq,
+				       le16_to_cpu(cmd->opcode),
+				       sgs, out_num, in_num, sgs);
 	mutex_unlock(&vp_dev->admin_vq.cmd_lock);
 
 	if (ret) {
@@ -142,6 +149,42 @@ static int vp_modern_admin_cmd_exec(struct virtio_device *vdev,
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
@@ -151,6 +194,7 @@ static void vp_modern_avq_activate(struct virtio_device *vdev)
 		return;
 
 	__virtqueue_unbreak(admin_vq->info.vq);
+	virtio_pci_admin_cmd_list_init(vdev);
 }
 
 static void vp_modern_avq_deactivate(struct virtio_device *vdev)
-- 
2.27.0


