Return-Path: <kvm+bounces-3842-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id B074280857D
	for <lists+kvm@lfdr.de>; Thu,  7 Dec 2023 11:30:05 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id E1F421C21F9A
	for <lists+kvm@lfdr.de>; Thu,  7 Dec 2023 10:30:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B756239AC6;
	Thu,  7 Dec 2023 10:29:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="uSfRM53p"
X-Original-To: kvm@vger.kernel.org
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2069.outbound.protection.outlook.com [40.107.94.69])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A21D913D
	for <kvm@vger.kernel.org>; Thu,  7 Dec 2023 02:29:32 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ZDNqUBFu4ZJwTI34k6ot7d/EMzRQp1JCN2AnedppAAy4DwEo+M+7ieVKb9mrYbFFxOKJJezMlYxexc7QZZZtN5ofR49IPhOGpjIdSzQ17WcXQAH3aCB9mc4AIm1y0QnC7GbDhoXNr25GWEZcORsalhJM/IsLKZ307bpwKCR+H0EheNhEfb816kMma7PXycGuYe6GDJ8kEpmj1IzXGRDEfq1y+mlRI6nW0c3LLjoiEscKBnq4OJxsTuNtZMkwwp4wAl1KpVDIf9qdRnaqq1DJGWnLCTMXxHXUHorWZb1vzKwam0TfNpL8oP6ce1V3oDsdnT5iNBSBk4aDCFW4o3ruxA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=mpAm0bEKaeAlo1rHfNtr++UfqmG83LfCLt+fU8XYdog=;
 b=ZfXBLu1DXp2+VftWUYyeAtN/b7t2DGwCxpulseJ7iz/5ZwKWvtqoyA1fFe8jj/CRFhEVLHTozV2ScM2Wwf9ALVFlWZLY5eNPSQtmpgD9VqT6sKgHeBCjDdBGInHKIzdwHbHSnrk2d/xYsF8oJ4R4p6VWDYf7yJslUTNJ2cZmRWVdVL0zKdrvxwwlFIes8My8aLXkp/bOOqFn+6s+s9s8GvV7mR4KYuQddiNgvzh7SHKRHHzkSWlCkqiBtQbD3NSBHHnCQzrouTwWuMPz1jv8Tvfi5tkNKQMVRkmrb5jd95iW/osk0KQ3HUGs9NqPDQ2hyKo0c3rUaly3AWj8JSlyZw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=redhat.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=mpAm0bEKaeAlo1rHfNtr++UfqmG83LfCLt+fU8XYdog=;
 b=uSfRM53p2zu4XCal1h7DDrdjLuIb4DVnavESkd+MUM5Ild1CiiRTfSkKLukL9xKNOOk99qKC+AI33SncOE8YworLlxuh4kw/3G//LIwyjRTBdtdgtvMee4vv2WqccOJpGqLRnVXcHZJ90PVKf1K/HtBvi28dlXzI0Vgs6UsxKywAg8eLEp/DM4nRCec4jF150OHjg/bmJFHn+gbrkqBZt3nJolmOo1KGJyZCqcrzw4kTN8XgM/zLGMWrbAI+XYVxu8i2iwMH5XFXvmdFw5Bavn/GAGRUVtpnagF0/OWDvwpt7pItM0j+lMbI59PI39pJ7XpNchmtPpPdu9bFHy4aSA==
Received: from BN1PR12CA0023.namprd12.prod.outlook.com (2603:10b6:408:e1::28)
 by CY8PR12MB7340.namprd12.prod.outlook.com (2603:10b6:930:50::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7025.28; Thu, 7 Dec
 2023 10:29:30 +0000
Received: from SN1PEPF00026368.namprd02.prod.outlook.com
 (2603:10b6:408:e1:cafe::2b) by BN1PR12CA0023.outlook.office365.com
 (2603:10b6:408:e1::28) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7046.34 via Frontend
 Transport; Thu, 7 Dec 2023 10:29:29 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.160)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 SN1PEPF00026368.mail.protection.outlook.com (10.167.241.133) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.7068.20 via Frontend Transport; Thu, 7 Dec 2023 10:29:29 +0000
Received: from rnnvmail204.nvidia.com (10.129.68.6) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.41; Thu, 7 Dec 2023
 02:29:19 -0800
Received: from rnnvmail204.nvidia.com (10.129.68.6) by rnnvmail204.nvidia.com
 (10.129.68.6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.41; Thu, 7 Dec 2023
 02:29:19 -0800
Received: from vdi.nvidia.com (10.127.8.10) by mail.nvidia.com (10.129.68.6)
 with Microsoft SMTP Server id 15.2.986.41 via Frontend Transport; Thu, 7 Dec
 2023 02:29:15 -0800
From: Yishai Hadas <yishaih@nvidia.com>
To: <alex.williamson@redhat.com>, <mst@redhat.com>, <jasowang@redhat.com>,
	<jgg@nvidia.com>
CC: <kvm@vger.kernel.org>, <virtualization@lists.linux-foundation.org>,
	<parav@nvidia.com>, <feliu@nvidia.com>, <jiri@nvidia.com>,
	<kevin.tian@intel.com>, <joao.m.martins@oracle.com>, <si-wei.liu@oracle.com>,
	<leonro@nvidia.com>, <yishaih@nvidia.com>, <maorg@nvidia.com>
Subject: [PATCH V7 vfio 5/9] virtio-pci: Initialize the supported admin commands
Date: Thu, 7 Dec 2023 12:28:16 +0200
Message-ID: <20231207102820.74820-6-yishaih@nvidia.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20231207102820.74820-1-yishaih@nvidia.com>
References: <20231207102820.74820-1-yishaih@nvidia.com>
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
X-MS-TrafficTypeDiagnostic: SN1PEPF00026368:EE_|CY8PR12MB7340:EE_
X-MS-Office365-Filtering-Correlation-Id: 2df0977f-82ac-400a-6ddb-08dbf70f64f3
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	+65607KF0PXsMoYxhZqc4cJuBtwP+VWB+tWgVqaj6gE6QzJOJ4cocujjWNL82UdMg3D4OGzoAsUpuK9uL1QWKwnSebt1pJ+Jm9KrdGIbjgzvXYbqtNh1nX4sUXURKHESPsgb4tbMhCORsTqzMl5tlnVVKm7l8EVNAEpI4lLIj4L+eH4hDydjU2E3iJiZyllyk0HZImyjnGJ+22WM4QLq+S2IxEKORNfH+3kOniD0arUx4wNenxZTMUCqSPuy00aCoAxgyqAfRQ9o82v6x+teKX4ughgoZjMcFVPk34a2Udxx82EmOYCjS6mTkt9Og/ZHXjsXH50BxUV0ir5nigksVAzfLp+spSJHwePUVUsCb959xB0/tA0n/Vj9wkX+/SCLvfFe7J5L4Au2VhPEJ5H/GxepeHDLFvG3DKwM6PhvvkI8TEKjzHSMfFbH8QE4TlOB59EbQ1EmWrIAZejBbNKApjeNmS/gOWNmx6I1cVKV5w2m38w63pkZ64kx2hHhfsyh2gGz+gGy/36mAh9SaoR0mqsiE7okR+/GmpORamkHvfGA+D0OUIAOL3GUEsOLTupi1BROc9OinLC2y668keV2aiN1OTzPXzFKHb0cWcwfF/b9f3Y3rfkI0rZQ6sJ69xytAwAej839TlxWPJahosyc+pFvYBn+5b8UTPiP0bApyUxSP/vg34JvHBoiHrrTa3gD1i+BXg+S3UlyR/2eeNoQEKXdQBNWmaNr7zzpj1xrEfL5w8SWtdGwldzzAbMIk4o19W+8t58ElyUVjpQggqyAVQ==
X-Forefront-Antispam-Report:
	CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230031)(4636009)(396003)(136003)(346002)(376002)(39860400002)(230922051799003)(186009)(451199024)(64100799003)(1800799012)(82310400011)(36840700001)(46966006)(40470700004)(40460700003)(86362001)(36756003)(82740400003)(7636003)(356005)(2906002)(7696005)(5660300002)(478600001)(107886003)(336012)(426003)(1076003)(26005)(41300700001)(83380400001)(8676002)(2616005)(6636002)(70586007)(70206006)(316002)(54906003)(8936002)(4326008)(110136005)(36860700001)(40480700001)(47076005)(2101003);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Dec 2023 10:29:29.2052
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 2df0977f-82ac-400a-6ddb-08dbf70f64f3
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SN1PEPF00026368.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR12MB7340

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


