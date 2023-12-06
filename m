Return-Path: <kvm+bounces-3676-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id EAB778069EC
	for <lists+kvm@lfdr.de>; Wed,  6 Dec 2023 09:40:52 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 8BB9FB20BBA
	for <lists+kvm@lfdr.de>; Wed,  6 Dec 2023 08:40:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 41BCC2C863;
	Wed,  6 Dec 2023 08:40:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="jRNjVBLH"
X-Original-To: kvm@vger.kernel.org
Received: from NAM04-DM6-obe.outbound.protection.outlook.com (mail-dm6nam04on2066.outbound.protection.outlook.com [40.107.102.66])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 33315D65
	for <kvm@vger.kernel.org>; Wed,  6 Dec 2023 00:40:16 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=O5F5ZgTqEDEVxo2TMm/28a4/68vVYzZSTCUzS2MfSRVyPZbfmDon+BqvIG/Yeyk8Ehtd0HAaPqyU9fqJvRA8RGx9/YxqZwLH05ivkcFLqyHDEFTgXUeEpnCvuoiLZX+Zazex/YSavScvUanPuqUzUexMm09/l3tJEjSX/eELQB/r4o9B8tJ0L+YS+IWBAauXES2XxsD5gfizIX/bm8HzqCtanSBYqngBFvKas/c5oiht051bOU+q7oEzb45CgdOomQGfDbnx649YCqXuU9Kzl1IBbJGlTE6EqpGTHaTPAjclFxih/7NejtqWZenXxMvPwwArdA0MWNQBJyBpTReRTQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=mpAm0bEKaeAlo1rHfNtr++UfqmG83LfCLt+fU8XYdog=;
 b=Izgr6h420nP+pNCOukei4ZUp+VavOGDxhljvNM5+KYaze6xraMGIYxmsJDMKSyt6cvbM33xlXFd0Tp1kNO7oCyiJ4WFh8ShxnUOQXc4FTkPVAvAuAQomnZG3CTPrGRrzxr4SRRLlMFadYPg3akBCvNO1IyN0bCHjbCnRJcNC/rV+mmsrlnsLYZiSU1I8pCQF/GUgicucK9y68t/IiKGnrbohUcysvZAoUFa7+P+deY7669/lHu+tE2S25r1C0BnfqB8b4ptN77Vbke7VI2NK5o/dM+4bO63D5RMfoZIIBvG7tPSM3JBZeHMT3CkKIPiV/xE3Gl2G5m7hTrR7w4nbKQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=redhat.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=mpAm0bEKaeAlo1rHfNtr++UfqmG83LfCLt+fU8XYdog=;
 b=jRNjVBLHy2mxtHK6If/VIHGltttuF3mx/l1wL/J/IzkQsSHtvmnievptjFd7UT8WTbfUxT4wpskFKiyy39vzwdx9r6BTH0UQYfG3Echk5ae3tukY91vY1Mo540QVV6k4otTGweodF4dpWV9gzmAjXf72s/FBxtMSn2Vk/tOalc+cwL5qbI71L6hHTysyXkagkrwUmRsq+eRGc2Cfjj9SMYPut5X9CEc/Nxhy7qZiOxbz+6vHggvQD2asoeb9McJmyN1uR982rB8DNL3DnH2X5W36DsWeKDJgAIjPwlxh4oVsq6d/oao9ZTNMHD2sUyx+a2vfLG7+6JPLrT/xN1vofw==
Received: from CH0PR03CA0093.namprd03.prod.outlook.com (2603:10b6:610:cd::8)
 by BL1PR12MB5705.namprd12.prod.outlook.com (2603:10b6:208:384::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7068.25; Wed, 6 Dec
 2023 08:40:12 +0000
Received: from SN1PEPF0002BA52.namprd03.prod.outlook.com
 (2603:10b6:610:cd:cafe::2d) by CH0PR03CA0093.outlook.office365.com
 (2603:10b6:610:cd::8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7046.34 via Frontend
 Transport; Wed, 6 Dec 2023 08:40:12 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.160)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 SN1PEPF0002BA52.mail.protection.outlook.com (10.167.242.75) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.7068.20 via Frontend Transport; Wed, 6 Dec 2023 08:40:12 +0000
Received: from rnnvmail205.nvidia.com (10.129.68.10) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.41; Wed, 6 Dec 2023
 00:40:00 -0800
Received: from rnnvmail201.nvidia.com (10.129.68.8) by rnnvmail205.nvidia.com
 (10.129.68.10) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.41; Wed, 6 Dec 2023
 00:39:59 -0800
Received: from vdi.nvidia.com (10.127.8.10) by mail.nvidia.com (10.129.68.8)
 with Microsoft SMTP Server id 15.2.986.41 via Frontend Transport; Wed, 6 Dec
 2023 00:39:55 -0800
From: Yishai Hadas <yishaih@nvidia.com>
To: <alex.williamson@redhat.com>, <mst@redhat.com>, <jasowang@redhat.com>,
	<jgg@nvidia.com>
CC: <kvm@vger.kernel.org>, <virtualization@lists.linux-foundation.org>,
	<parav@nvidia.com>, <feliu@nvidia.com>, <jiri@nvidia.com>,
	<kevin.tian@intel.com>, <joao.m.martins@oracle.com>, <si-wei.liu@oracle.com>,
	<leonro@nvidia.com>, <yishaih@nvidia.com>, <maorg@nvidia.com>
Subject: [PATCH V6 vfio 5/9] virtio-pci: Initialize the supported admin commands
Date: Wed, 6 Dec 2023 10:38:53 +0200
Message-ID: <20231206083857.241946-6-yishaih@nvidia.com>
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
X-MS-TrafficTypeDiagnostic: SN1PEPF0002BA52:EE_|BL1PR12MB5705:EE_
X-MS-Office365-Filtering-Correlation-Id: f6a9a63c-a1d2-4411-caa9-08dbf636f630
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	C+zwddx7mPYljHRIS7dJ/+NEigy1GaHaNy4H93456lVhkp1I19YvmpCvdYb+wB8kClBgulObh8+TjSx0F6EesyBzfuiblDGY29sY2SHY/pyyGV6ppxZBraxFyZprZaLgk9t32s1QJdEVQzosPyKLa6a7q9j3pI9VVXmWxu+DuSxfndBwtJtfshlkEQzY3kV1p0KLrB9hthqa3QUsjFubunUVYKNq6BbLrBjrY8XLtIHtaUajH3bYT5zv5z66K7UyI0jujfkkxIEps3d57nMbyKHR4AMpGBfHVZ6BM3s+4Fzr/eQ3DkoYmAmpjqovi1nNz4k1gf7QqZgGwkerDB+pUzKmxHpqAZ0bkWLy9rTcjhS78K3eX0xTtkJ7caFSRHYTPOrV1XkpF4pMlkakXIAYHHQ5pMf5mHFOCzV2GeYGZHN3E+ThULpyQCmh8nMBThaBnFnLGvhoYQhBHUrY11z3ZYy0zEwE0yLPoBV6Itxk4VIWO1+6H3Lo0P6YHf2llnvjDb1kzzMoLDGetbsa0rxnF+E1/gaCRaGwx8+rGNeOAMbLTRBSry+fORC30GAKv7NK5U4af1xJw8Rm6AzYImxRtqmEqqzN8k1+wXQzE2bNWkIfVBOrJDdYNhA846D4dBnWyr4EvL1HvNAOHEXoNK+iHJPeeeP8tRgiqovT9GqysrI6PIi9OSx/oF2GXVXLmuekUcPT1GoMPiK+smi3nUcGBPNNPex3MtzXr1eUwKmcsAJ+uFASBux90HwPaVxnAhDD8GkdZqrmjl2U+aft99H9Nw==
X-Forefront-Antispam-Report:
	CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230031)(4636009)(346002)(39860400002)(136003)(376002)(396003)(230922051799003)(186009)(82310400011)(64100799003)(451199024)(1800799012)(36840700001)(46966006)(40470700004)(70586007)(70206006)(110136005)(36860700001)(7636003)(356005)(83380400001)(82740400003)(426003)(336012)(26005)(1076003)(107886003)(2616005)(7696005)(478600001)(6636002)(316002)(54906003)(8676002)(4326008)(86362001)(8936002)(5660300002)(2906002)(40480700001)(36756003)(41300700001)(47076005)(40460700003)(2101003);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Dec 2023 08:40:12.0710
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: f6a9a63c-a1d2-4411-caa9-08dbf636f630
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SN1PEPF0002BA52.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR12MB5705

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


