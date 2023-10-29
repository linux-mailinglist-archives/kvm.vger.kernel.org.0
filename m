Return-Path: <kvm+bounces-22-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 3803F7DAD1C
	for <lists+kvm@lfdr.de>; Sun, 29 Oct 2023 17:01:03 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id DCF72281585
	for <lists+kvm@lfdr.de>; Sun, 29 Oct 2023 16:01:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C11E6101E6;
	Sun, 29 Oct 2023 16:00:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="Yl6tHrlf"
X-Original-To: kvm@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7CB9DF9EF
	for <kvm@vger.kernel.org>; Sun, 29 Oct 2023 16:00:45 +0000 (UTC)
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2059.outbound.protection.outlook.com [40.107.220.59])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2A1BBB6
	for <kvm@vger.kernel.org>; Sun, 29 Oct 2023 09:00:42 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=LalhbfXYiW/gdn3X+qmqZGpptrSSmj2rA+g16EM5A6joWgpFjbEwpzFXUpNmmX4LeZHan4CVLQPovW8RDOq2PJhZAK5rMGMefuC/MCW6gGjOdNAjebZaNT53+qawITkImVdHZxH+WNFt2ebtpO9UOTcRrgV3xkiM8pWnlevWE+nBrWktE/9ApMHZ67s5J72J12+nL+5nkpVT1E2gEoufvBMJj2AMvkKHwSGaNbXB2qJavJcCcaPWApwls2URLNn7oaePW++fQOnTE8UWxoVDOnLd1ZrovRzHjux5zDLDySsCE09ocfL200gNPdJqLOU8PyHt5IEDPWc07l83zLlUYQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=KmDuJuZdmuKcbpUmMujeAtWfvbQ1fjxPunvz6WU8IOM=;
 b=Be4Uj7FT9RbFScTGGja4pjfti3EdycYiDlpkoHhm9zz0ED0lb6pMSwICGRb3uZprKKX1xB/GDCJKRa9oWf4MdfuWJwpmzdbG43P3jpp8EwiTvoh9/CZfUkLeYhOuIW4xECH1IpVzaIYOZWSvc0EaUEWmWY3DLfY98Aq4mXbH7PcsY8Rs9SR73H9zTO/YfgVMKIloc4nJF657+NIhiUBnjd2apL854O3TVWY6vXPO3ty1GJ1UcqPNOUFmaLZRSlJeW5qkgstvlLa2ioy9FFRyMWly+fAjmkJtvEMcJ2SJjAgICUKEnbAzggNmYhSOPmxCUiLK0E3ek5EkcQBrw/UyIw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.118.233) smtp.rcpttodomain=redhat.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=KmDuJuZdmuKcbpUmMujeAtWfvbQ1fjxPunvz6WU8IOM=;
 b=Yl6tHrlf3FKRAIpJU8jLWIxlOS6+vIC/PffWnedZW/InLoRW4yrtOJdVz6QPN6meU4pCPxynytFjMJwGJ9OicZ8R/rFEUugXl8m4ERkpgLPwPXpN+L0jFzMvediLwdeYkGqsyzpdZDm+TTmQKSzX6rAdsEc4zK8F7MjnMxBkxVkFxHn9WZcFeti3oag+lbHJrVqBt4prbN4yO93YjzslWNgPvE/Ab9cJzZ440S572mA+QtyXay0ca/WPwHACdQrhueA02CsVzzuCOACdvnSmxPnkauSolF5UWiMy9awCqJamnr+Nn14ix7T6nAY9+O+P+Sp3I4tJeBmRwnS5YWbOug==
Received: from DM6PR02CA0104.namprd02.prod.outlook.com (2603:10b6:5:1f4::45)
 by MN2PR12MB4502.namprd12.prod.outlook.com (2603:10b6:208:263::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6933.26; Sun, 29 Oct
 2023 16:00:39 +0000
Received: from DS1PEPF0001709C.namprd05.prod.outlook.com
 (2603:10b6:5:1f4:cafe::9a) by DM6PR02CA0104.outlook.office365.com
 (2603:10b6:5:1f4::45) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6933.27 via Frontend
 Transport; Sun, 29 Oct 2023 16:00:39 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.118.233)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.118.233 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.118.233; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.118.233) by
 DS1PEPF0001709C.mail.protection.outlook.com (10.167.18.106) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6933.15 via Frontend Transport; Sun, 29 Oct 2023 16:00:39 +0000
Received: from drhqmail202.nvidia.com (10.126.190.181) by mail.nvidia.com
 (10.127.129.6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.41; Sun, 29 Oct
 2023 09:00:32 -0700
Received: from drhqmail203.nvidia.com (10.126.190.182) by
 drhqmail202.nvidia.com (10.126.190.181) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.986.41; Sun, 29 Oct 2023 09:00:32 -0700
Received: from vdi.nvidia.com (10.127.8.10) by mail.nvidia.com
 (10.126.190.182) with Microsoft SMTP Server id 15.2.986.41 via Frontend
 Transport; Sun, 29 Oct 2023 09:00:28 -0700
From: Yishai Hadas <yishaih@nvidia.com>
To: <alex.williamson@redhat.com>, <mst@redhat.com>, <jasowang@redhat.com>,
	<jgg@nvidia.com>
CC: <kvm@vger.kernel.org>, <virtualization@lists.linux-foundation.org>,
	<parav@nvidia.com>, <feliu@nvidia.com>, <jiri@nvidia.com>,
	<kevin.tian@intel.com>, <joao.m.martins@oracle.com>, <si-wei.liu@oracle.com>,
	<leonro@nvidia.com>, <yishaih@nvidia.com>, <maorg@nvidia.com>
Subject: [PATCH V2 vfio 5/9] virtio-pci: Initialize the supported admin commands
Date: Sun, 29 Oct 2023 17:59:48 +0200
Message-ID: <20231029155952.67686-6-yishaih@nvidia.com>
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
X-MS-TrafficTypeDiagnostic: DS1PEPF0001709C:EE_|MN2PR12MB4502:EE_
X-MS-Office365-Filtering-Correlation-Id: 3011836d-2cdb-4e83-c6c3-08dbd8983284
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	hJBEN6buJgFoGtsDp9V7WsX+IYtkvhoLjI/TcfJnAUB0uVinlgyCD/37fh0ckxpbwsKoescqwI7jILjAWKtQJCbojEj16DRM032Ht7oft1AttN/m6tpL/WdfH7xMcqy/RmLCUiW3Xw4hKCs0+FyCjs9EBjHIs9wOGEiFMUBmIx/36CZQ9ngf1C7KvBYGNzGZ6B+hmlDyPO1rQk1MFuPQsqf5WlA/OGgGrCJyqKJTkfh5UDgCe61Rpv38+E6aUHFK3lMtAK4oxWOc4hfdy+aw9CB8+XhA1GAb/6KU918Ka3SfS+sXC0W6Mrugiv+ur4f9m9MwgYnmP/6gdP30zINmLDA/GZzl/ZMv2cNm2jvTrg12Mp8WZWkiZXt6cTUUyPk8qyKaJYanWrFJu7rWzvS2x09L/+TmgZgIrWLUK4af8fFFB0FM/2m7PEUyNOJo46UGVkC990BJfgM2R+q9Wh+JFAf7SpsiocxoWJDDRUzC83foUxXg8AKiJE/clTPp1td7wl9MFnC+gNzmb026kXGPTAW6vnG8aoGhfpHtYk5dduKNScM56k3lt5A2GgsQDfq4bkbyXlMu3v2c0vrEcsJI4FVJcznCf3StDM1Cyv/fWnDpk2sNWsi2P9OXhP9aVmuhIwpYCEkvL8jpQwtnV6gjRMfMlY5TmZkeYBebRPn6TPWcg83bmGn4A+ZJvKa8gzSpQKwnb1avHjLIHGYXhWajXsJhLVrCjNCGtjNogJ5Q6I9LqADaNhUyxGu0Oxq8zIydbkL5GrJznXQbSPiU2YneRw==
X-Forefront-Antispam-Report:
	CIP:216.228.118.233;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc7edge2.nvidia.com;CAT:NONE;SFS:(13230031)(4636009)(376002)(346002)(136003)(396003)(39860400002)(230922051799003)(64100799003)(82310400011)(1800799009)(186009)(451199024)(40470700004)(36840700001)(46966006)(478600001)(7696005)(6666004)(70206006)(70586007)(110136005)(336012)(26005)(426003)(107886003)(1076003)(2616005)(41300700001)(2906002)(8676002)(8936002)(4326008)(316002)(6636002)(54906003)(5660300002)(86362001)(36756003)(36860700001)(83380400001)(47076005)(82740400003)(356005)(7636003)(40460700003)(40480700001)(2101003);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Oct 2023 16:00:39.5841
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 3011836d-2cdb-4e83-c6c3-08dbd8983284
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.118.233];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DS1PEPF0001709C.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR12MB4502

Initialize the supported admin commands upon activating the admin queue.

The supported commands are saved as part of the admin queue context, it
will be used by the next patches from this series.

Note:
As we don't want to let upper layers to execute admin commands before
that this initialization step was completed, we set ref count to 1 only
post of that flow and use a non ref counted version command for this
internal flow.

Signed-off-by: Yishai Hadas <yishaih@nvidia.com>
---
 drivers/virtio/virtio_pci_common.h |  1 +
 drivers/virtio/virtio_pci_modern.c | 77 +++++++++++++++++++++++++++++-
 2 files changed, 77 insertions(+), 1 deletion(-)

diff --git a/drivers/virtio/virtio_pci_common.h b/drivers/virtio/virtio_pci_common.h
index a21b9ba01a60..9e07e556a51a 100644
--- a/drivers/virtio/virtio_pci_common.h
+++ b/drivers/virtio/virtio_pci_common.h
@@ -46,6 +46,7 @@ struct virtio_pci_admin_vq {
 	struct virtio_pci_vq_info info;
 	struct completion flush_done;
 	refcount_t refcount;
+	u64 supported_cmds;
 	/* Name of the admin queue: avq.$index. */
 	char name[10];
 	u16 vq_index;
diff --git a/drivers/virtio/virtio_pci_modern.c b/drivers/virtio/virtio_pci_modern.c
index ccd7a4d9f57f..25e27aa79cab 100644
--- a/drivers/virtio/virtio_pci_modern.c
+++ b/drivers/virtio/virtio_pci_modern.c
@@ -19,6 +19,9 @@
 #define VIRTIO_RING_NO_LEGACY
 #include "virtio_pci_common.h"
 
+static int vp_modern_admin_cmd_exec(struct virtio_device *vdev,
+				    struct virtio_admin_cmd *cmd);
+
 static u64 vp_get_features(struct virtio_device *vdev)
 {
 	struct virtio_pci_device *vp_dev = to_vp_device(vdev);
@@ -59,6 +62,42 @@ vp_modern_avq_set_abort(struct virtio_pci_admin_vq *admin_vq, bool abort)
 	WRITE_ONCE(admin_vq->abort, abort);
 }
 
+static void virtio_pci_admin_init_cmd_list(struct virtio_device *virtio_dev)
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
@@ -67,6 +106,7 @@ static void vp_modern_avq_activate(struct virtio_device *vdev)
 	if (!virtio_has_feature(vdev, VIRTIO_F_ADMIN_VQ))
 		return;
 
+	virtio_pci_admin_init_cmd_list(vdev);
 	init_completion(&admin_vq->flush_done);
 	refcount_set(&admin_vq->refcount, 1);
 	vp_modern_avq_set_abort(admin_vq, false);
@@ -562,6 +602,35 @@ static bool vp_get_shm_region(struct virtio_device *vdev,
 	return true;
 }
 
+static int __virtqueue_exec_admin_cmd(struct virtio_pci_admin_vq *admin_vq,
+				    struct scatterlist **sgs,
+				    unsigned int out_num,
+				    unsigned int in_num,
+				    void *data,
+				    gfp_t gfp)
+{
+	struct virtqueue *vq;
+	int ret, len;
+
+	vq = admin_vq->info.vq;
+
+	ret = virtqueue_add_sgs(vq, sgs, out_num, in_num, data, gfp);
+	if (ret < 0)
+		return ret;
+
+	if (unlikely(!virtqueue_kick(vq)))
+		return -EIO;
+
+	while (!virtqueue_get_buf(vq, &len) &&
+	       !virtqueue_is_broken(vq))
+		cpu_relax();
+
+	if (virtqueue_is_broken(vq))
+		return -EIO;
+
+	return 0;
+}
+
 static int virtqueue_exec_admin_cmd(struct virtio_pci_admin_vq *admin_vq,
 				    struct scatterlist **sgs,
 				    unsigned int out_num,
@@ -653,7 +722,13 @@ static int vp_modern_admin_cmd_exec(struct virtio_device *vdev,
 		in_num++;
 	}
 
-	ret = virtqueue_exec_admin_cmd(&vp_dev->admin_vq, sgs,
+	if (cmd->opcode == VIRTIO_ADMIN_CMD_LIST_QUERY ||
+	    cmd->opcode == VIRTIO_ADMIN_CMD_LIST_USE)
+		ret = __virtqueue_exec_admin_cmd(&vp_dev->admin_vq, sgs,
+				       out_num, in_num,
+				       sgs, GFP_KERNEL);
+	else
+		ret = virtqueue_exec_admin_cmd(&vp_dev->admin_vq, sgs,
 				       out_num, in_num,
 				       sgs, GFP_KERNEL);
 	if (ret) {
-- 
2.27.0


