Return-Path: <kvm+bounces-4483-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 4C781813053
	for <lists+kvm@lfdr.de>; Thu, 14 Dec 2023 13:39:52 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id E2FE22831FC
	for <lists+kvm@lfdr.de>; Thu, 14 Dec 2023 12:39:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5973D4EB59;
	Thu, 14 Dec 2023 12:39:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="avk8tdDH"
X-Original-To: kvm@vger.kernel.org
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2061.outbound.protection.outlook.com [40.107.92.61])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 97529A3
	for <kvm@vger.kernel.org>; Thu, 14 Dec 2023 04:39:07 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=TqQwZhcWqxQnAaJOz4e4nzCPoA/zOGNasP3OJfW2v7y04bguHEYNzmC+PzXptTXPEUkpGRTm6kiEc1iHirCZyPbsddKcwo2+6ag5CcB3ZP2/aEka3kVMy9UiT++KcjvFbObDfUAQGp4N1p8Bs8o98xxiUgpf/pNWJzFTqw1YwePioF/b/HI5o2U6rDoTeiulqOQifMAS1NZAOjnyhf/rTwcN2DesoPZwhGUkyCFe5/ADMy1Ko2a0kSJsTn/uDjgJRO/Kty+FBB9HlEy3/6J3O37j5aCFGbl6jM8zaiOy66s52l7FoxVCbEWuXe30F4yKhLpp7/f4N6+Yfry/Vem2rw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=mpAm0bEKaeAlo1rHfNtr++UfqmG83LfCLt+fU8XYdog=;
 b=kiXaFDxINcwm4dTXwsi2mrjnwfW7Um2jwgTA9Gw0eQZDkpellKy0pfENC5HVfQD3R7d5yS+2v5O1nMC1+cHtbIwnCmTw5t8N+lomwOmjV9aBbjFFW59eOOrkAOtipffurV2tlPrDLahUEiONTREqfXsT4awVkNlU9Jw2KJ0w+Vu+kTJtk0PDAme7Xe/b7TWXdXUd5P+SisUpTLHTFk6rvDGKwQqEexHNYQ/yezc5LDj3YnA/pH3EvrdO24zbOVwaiIHk65qIUZZTOoRcoUe52fDEIYe8UFyHDhULJDZzXDC0wH15mkC3AlP1X5tqoCQfF+IVebW6lmiv/Q7TGqOl9g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=redhat.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=mpAm0bEKaeAlo1rHfNtr++UfqmG83LfCLt+fU8XYdog=;
 b=avk8tdDHY58vzSCiTtF2TdoP77ZEigY2f4OciaoCWIy8tmbb9pP2JGhYgGZ9sztTcLP/fLLTzO0dM6c70vmhWNJocYo4AYnp2bcm7zRzLpS7S4aDfT+ThdYvDNfVQOLMW1bx5X7feBbvwdr4NxmnaokM1vW6iEIL5tK4CgZl+i17NDUhSmM42usidHpTVJJOdjCdbdDH9n1fyCq/lUCPimqJmWDc0ht6QtampJ/YYkZl/iLbP6HM+NHlXf3cMG0uVdG+5q4rrfxZBQ6F4XpjrLng5CvpTCeZuVYw/yspWoRJj9R0ZBRINDmiljvqMkM43jNUpyX3gBnnLcZENybHjg==
Received: from DM6PR06CA0090.namprd06.prod.outlook.com (2603:10b6:5:336::23)
 by DS7PR12MB5837.namprd12.prod.outlook.com (2603:10b6:8:78::6) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.7091.28; Thu, 14 Dec 2023 12:39:04 +0000
Received: from DS3PEPF000099D7.namprd04.prod.outlook.com
 (2603:10b6:5:336:cafe::e6) by DM6PR06CA0090.outlook.office365.com
 (2603:10b6:5:336::23) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7091.28 via Frontend
 Transport; Thu, 14 Dec 2023 12:39:04 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.160)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 DS3PEPF000099D7.mail.protection.outlook.com (10.167.17.8) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.7091.26 via Frontend Transport; Thu, 14 Dec 2023 12:39:04 +0000
Received: from rnnvmail203.nvidia.com (10.129.68.9) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.41; Thu, 14 Dec
 2023 04:38:50 -0800
Received: from rnnvmail202.nvidia.com (10.129.68.7) by rnnvmail203.nvidia.com
 (10.129.68.9) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.41; Thu, 14 Dec
 2023 04:38:50 -0800
Received: from vdi.nvidia.com (10.127.8.10) by mail.nvidia.com (10.129.68.7)
 with Microsoft SMTP Server id 15.2.986.41 via Frontend Transport; Thu, 14 Dec
 2023 04:38:46 -0800
From: Yishai Hadas <yishaih@nvidia.com>
To: <alex.williamson@redhat.com>, <mst@redhat.com>, <jasowang@redhat.com>,
	<jgg@nvidia.com>
CC: <kvm@vger.kernel.org>, <virtualization@lists.linux-foundation.org>,
	<parav@nvidia.com>, <feliu@nvidia.com>, <jiri@nvidia.com>,
	<kevin.tian@intel.com>, <joao.m.martins@oracle.com>, <si-wei.liu@oracle.com>,
	<leonro@nvidia.com>, <yishaih@nvidia.com>, <maorg@nvidia.com>
Subject: [PATCH V8 vfio 5/9] virtio-pci: Initialize the supported admin commands
Date: Thu, 14 Dec 2023 14:38:04 +0200
Message-ID: <20231214123808.76664-6-yishaih@nvidia.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20231214123808.76664-1-yishaih@nvidia.com>
References: <20231214123808.76664-1-yishaih@nvidia.com>
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
X-MS-TrafficTypeDiagnostic: DS3PEPF000099D7:EE_|DS7PR12MB5837:EE_
X-MS-Office365-Filtering-Correlation-Id: 9d12ed81-51a6-498b-5f37-08dbfca1a847
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	+Fu+esBZnNhN4q4B+g59cESTv5CJmkzT/2+JhXMt3i7RIOh5vVu/pyFk9K9ukwCsqd8usuJOVmJtltngUXvpL84xioFbFyyawf+5VmR9iIo1fJIP4+4T9Mw0zpEbsRa3uwnfLl7AQTeO5pvpcC8aSFzuJUvSAQJTsIjZQlqw5WXcoG8O00Gimx32LA2CXC2hHGSBznJgBHzmtA7NY5KC8T0SYKsSfotRXIaHZ2pBnE1YRmHxGsr0P3vOjN5FU0altQV9CICF84jgd6D1qoShgMHB5Qkeey6Rl2wl0efc2jnU28FP9hWDq9t0wNZXDns78FLKUUVncvcT/C1+ZVj2byL8MAUEX5l2XVEHU2u2t7Wu88uyHD40rlF2ZM59/SvZuTq7GCmRiLg0kZIyo+ap4sMxXaHRhZhdzJzPTYlf1d5bFXmqFNQ+XkvJV0ivIMUfzYvivJ/w+QOk550noIFAFY0/oW65HHOPpdZpsJTMjjdJLgRTrZergUKigX1hYNZUXOSZkiQeEXJtFa4BT0DZZhmed+sIBfdRUJQvJ1gsMsUryKpOoED2wwyMQLXCTzMEgtdy2ftL1PXpJuxAgZR5x73EIFQ+2QRqNvGlYEgSTC7XD9oeutH7arJEQffCUKXrMZvEt4MoNvgsqxv5G4lSGeYEiU5K6ykEowA+w4LsSZqZLCmQbbEr/PAt4XcmZ+pKPGWbQuakgqdPhTFFp656avS6HRr09RIwDEuz34vpubtXYL5f+vTjRWugolugziUtbhUn0k/mIfaSCmzwo7zsFA==
X-Forefront-Antispam-Report:
	CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230031)(4636009)(376002)(346002)(396003)(39860400002)(136003)(230922051799003)(186009)(64100799003)(451199024)(1800799012)(82310400011)(46966006)(36840700001)(40470700004)(82740400003)(40460700003)(7636003)(356005)(2906002)(36756003)(41300700001)(86362001)(2616005)(4326008)(8676002)(8936002)(6666004)(40480700001)(478600001)(336012)(426003)(83380400001)(70586007)(70206006)(54906003)(6636002)(316002)(110136005)(7696005)(5660300002)(1076003)(36860700001)(107886003)(47076005)(26005)(2101003);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Dec 2023 12:39:04.4678
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 9d12ed81-51a6-498b-5f37-08dbfca1a847
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DS3PEPF000099D7.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR12MB5837

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


