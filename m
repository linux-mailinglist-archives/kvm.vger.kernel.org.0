Return-Path: <kvm+bounces-2773-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 176C67FD9BD
	for <lists+kvm@lfdr.de>; Wed, 29 Nov 2023 15:39:37 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 814F8B218A3
	for <lists+kvm@lfdr.de>; Wed, 29 Nov 2023 14:39:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 29C7E34CEC;
	Wed, 29 Nov 2023 14:39:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="ILQjJqpl"
X-Original-To: kvm@vger.kernel.org
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2073.outbound.protection.outlook.com [40.107.94.73])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5205F1730
	for <kvm@vger.kernel.org>; Wed, 29 Nov 2023 06:38:59 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Dxw0YgaNBcIJzLtq1TyzOxa0zNfu90aIZpai6QAAaO7VWwE3drjwZEmHxpnVMph/MIUknWaXVQBo+SNQRz14wNE/tTHzVgXS6KpgR7zGdakhyBTFNXA1ow/2S7T1EFMlaqRs2CqWfwETxjW2pp0i7bfvygHBS/TPTWZhuHPi0Hyo1Cgltl3/x52lIO5S0R94tI12tJZLJ0nyeI8VJmWWdCDmsFOn2lXKpmccauQJ9b1ulEfMRucduPwBdqXAXn5ukhFm2YQr0uRZ6pE/RyZ1hH6zIrmwoivFd0T5OP/cPjMGFAZxZ5Ihb2ZU7eVdtsLXWqnRUEjSULvWpT0ueue9Cg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=i3J/WylKKMHjcPOepx+1JsuAu31mMLH/Sey3xx2iRns=;
 b=UyJxoUNEJ/cMELawBro+8EuSZk/6B2Kr5WOIswfKsSrdG+MiU3NLQm6/fecVCJeW8AdW8430MsXmLBOca8U45XE2UYLEi1kJrAYcR0VeEGzT0AJXtL5uxfyqZ1faHZ+OtwrvXNPjTTg6Hapqxkcw+A7oQ0U5jX+VtPrHxWUZTefw/3kc9icd2cH16mXYj6slffkcMWvW3IQPRsHvnmMwwXMW/Ct7MzYtCvC4U0g32btgpf0DAGzKYmj2IcbhhwOieJUyNVLt02yc3rw06oKX9zq9UWUuK84gmBhDPkkVRdtMwY9hBDHVIo/Y0ZdB797VEdAkeRJn5P+7E52Fr/XFWQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.118.232) smtp.rcpttodomain=redhat.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=i3J/WylKKMHjcPOepx+1JsuAu31mMLH/Sey3xx2iRns=;
 b=ILQjJqplY5srb1KDfzkqoJluCCSYLW/utkoJA3kmEpzecNJApMN3cQ9T8DhSJ1NMnTTYiV+rn3DhyYVl9HdFptVJj+gfnDtB1lJi6z8FBo4z3F7X6c+zJdEeuKcIVrNWWZjBKtyjFYt0xyBvqr8Qv90ZsXBe241i+5NtwLSx9ijWEJxCoNeE6Irgv9F+03be72AriWiCq11/RcN7xYrpC7ebBe7vE2TsZrMB7QruTSQ8k8h5HEJ5ufWLhlSGQS7lBW2taWMrlmXUAZDqL+QuQQFrAX43/k1ijal6VyxLhtIJ4pBxcxmm81RyMNcNLlBoL4uZSt0WEFtNHSRH/f1puw==
Received: from DS7PR03CA0343.namprd03.prod.outlook.com (2603:10b6:8:55::17) by
 IA0PR12MB7752.namprd12.prod.outlook.com (2603:10b6:208:442::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7025.29; Wed, 29 Nov
 2023 14:38:55 +0000
Received: from CY4PEPF0000EDD4.namprd03.prod.outlook.com
 (2603:10b6:8:55:cafe::c0) by DS7PR03CA0343.outlook.office365.com
 (2603:10b6:8:55::17) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7002.20 via Frontend
 Transport; Wed, 29 Nov 2023 14:38:54 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.118.232)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.118.232 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.118.232; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.118.232) by
 CY4PEPF0000EDD4.mail.protection.outlook.com (10.167.241.208) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.7046.17 via Frontend Transport; Wed, 29 Nov 2023 14:38:54 +0000
Received: from drhqmail201.nvidia.com (10.126.190.180) by mail.nvidia.com
 (10.127.129.5) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.41; Wed, 29 Nov
 2023 06:38:46 -0800
Received: from drhqmail203.nvidia.com (10.126.190.182) by
 drhqmail201.nvidia.com (10.126.190.180) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.986.41; Wed, 29 Nov 2023 06:38:46 -0800
Received: from vdi.nvidia.com (10.127.8.10) by mail.nvidia.com
 (10.126.190.182) with Microsoft SMTP Server id 15.2.986.41 via Frontend
 Transport; Wed, 29 Nov 2023 06:38:43 -0800
From: Yishai Hadas <yishaih@nvidia.com>
To: <alex.williamson@redhat.com>, <mst@redhat.com>, <jasowang@redhat.com>,
	<jgg@nvidia.com>
CC: <kvm@vger.kernel.org>, <virtualization@lists.linux-foundation.org>,
	<parav@nvidia.com>, <feliu@nvidia.com>, <jiri@nvidia.com>,
	<kevin.tian@intel.com>, <joao.m.martins@oracle.com>, <si-wei.liu@oracle.com>,
	<leonro@nvidia.com>, <yishaih@nvidia.com>, <maorg@nvidia.com>
Subject: [PATCH V4 vfio 5/9] virtio-pci: Initialize the supported admin commands
Date: Wed, 29 Nov 2023 16:37:42 +0200
Message-ID: <20231129143746.6153-6-yishaih@nvidia.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20231129143746.6153-1-yishaih@nvidia.com>
References: <20231129143746.6153-1-yishaih@nvidia.com>
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
X-MS-TrafficTypeDiagnostic: CY4PEPF0000EDD4:EE_|IA0PR12MB7752:EE_
X-MS-Office365-Filtering-Correlation-Id: 5a12ceca-b496-415f-f27e-08dbf0e8e9cc
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	/26q8GH0ztWjqLV2UO+Rfqe6LyYP0QODxhbAkRY7jQW1vOL/fmFY7VXL8DAcdgHZoPZg07hMlOK51ZNk4iRNKCc21tDqz/4dwKB/qGwP+mptXvgF+PPJIg43dZIkWIOp03VnhVfTjwU1vaeEr9GDt6LZ6qqluXXrs2WQ1kJMX8rF6mzXaiWBoOHRk6kXWLEf1j0umKEjatAArz9q6iUXk1n4Ec5M8WsUBHS+8RkEX+T+k5sD6kRbuJadrFbkU9uX56zv+lRWzDgKcdieVhtxDrfp7AhSI5/sAK/zPh/es7eaCiRbUAtwqgWoBUyPTySzT0TarPmHlAR6GfXBpWm8sWelsRvWPR48QAr2OIxpKQmrvHegMWCNMBIuvB+yGDsoynQvvURfs6bdjBowUw7gGfTNQy07zpjiskvsiQN4nrDyIVApuMlAiXWvkeEnqmk4CxpusfdkMfeaCfh0zR+5LVPHnbSyNP4lao25xUgEJLe3C+wksan5Rt8DzC5LyBoPRuTc7Rjw545OnXrSRqUWPqzdzCq9cGm1By+QIKOeoxH2ybPWUGRZu8G/eomfJyWDCWPyefdWmQUL/bSj4KI88Z86+3KpWOs8fqbVRP9paBTUe3Q7kYpecJSjEfof62R+WQdHEei2yoMzMGnta4S9wpwGXGuv6s8H4eDqLK+oDScvF73dXwjzEX5zhVOcJcnloUTOHeKfHBdAXAKjSU+ZSpVCs8ZuALZJm2rmA3/85ZYA5wmabQhdC12S25AJ1WGm50o7W3cr9JjDsJyI03MyKw==
X-Forefront-Antispam-Report:
	CIP:216.228.118.232;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc7edge1.nvidia.com;CAT:NONE;SFS:(13230031)(4636009)(346002)(376002)(396003)(136003)(39860400002)(230922051799003)(451199024)(82310400011)(186009)(64100799003)(1800799012)(40470700004)(46966006)(36840700001)(107886003)(2616005)(26005)(426003)(336012)(1076003)(7696005)(47076005)(478600001)(36860700001)(5660300002)(83380400001)(2906002)(54906003)(70586007)(70206006)(41300700001)(8676002)(8936002)(6636002)(316002)(4326008)(110136005)(36756003)(356005)(7636003)(82740400003)(40460700003)(86362001)(40480700001)(2101003);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Nov 2023 14:38:54.6940
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 5a12ceca-b496-415f-f27e-08dbf0e8e9cc
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.118.232];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CY4PEPF0000EDD4.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA0PR12MB7752

Initialize the supported admin commands upon activating the admin queue.

The supported commands are saved as part of the admin queue context.

Next patches in this series will expose APIs to use them.

Reviewed-by: Feng Liu <feliu@nvidia.com>
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


