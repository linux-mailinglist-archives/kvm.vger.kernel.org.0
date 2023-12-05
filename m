Return-Path: <kvm+bounces-3605-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id EA483805AC7
	for <lists+kvm@lfdr.de>; Tue,  5 Dec 2023 18:08:10 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 7BBBCB20E30
	for <lists+kvm@lfdr.de>; Tue,  5 Dec 2023 17:08:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 352E2692BD;
	Tue,  5 Dec 2023 17:07:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="IIn0D/k2"
X-Original-To: kvm@vger.kernel.org
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2066.outbound.protection.outlook.com [40.107.92.66])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 326DDA1
	for <kvm@vger.kernel.org>; Tue,  5 Dec 2023 09:07:42 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=eoAp78NNlasOo82xeqQsjOZ9ItcUwmizs7qjZgevyq5gEQibThRVJchvavQWhoZuM7dxsUpy9QietPPKZP0JPnoIS1oHLpqSGPNaW9AFsh5bKpKg8YVMsMAUEwEg9fVbMjiskKMMCA0cDRfeBbiwE0YQKQsmU50RI01PdadlkRGEN0fKl66u32zxpJiGLET48kzpYm6+BqCFOWShJYqUqnMRHtzFMTSAMrQaeL9+B9hAVg66p4AUYcF9E8bVr+BG+RutC/RVcndMEKVPmIs8ptpZ1UL015Vc82yqPALXkVdKLPP9CmynaVp4y3wRZHHjq5p+cy+KmHhzJpxgn1WSNA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=mpAm0bEKaeAlo1rHfNtr++UfqmG83LfCLt+fU8XYdog=;
 b=HV7NMvW38+H7T2GsgxOVT0JJmmub6kDj+7ubYdnnom4LMOUAlnX7bLRKgGqON/S4pdkVDoXgp+GO+WQTMmfLZhaSy5ortwZd3sXGzbopqQFYGtwAKiAk6f08O9JpP4rm5f6Fc8UiZRyi57a2WoNDQgsq67DPFzwpBAJp9kNGMtxaSJNBG/kTeUAWxPHjYmYBARbmK4/j4r9VmV7tl0J8kJQFSp1oyQ5DiY9g9Kvcyk6TKkAmGElzJbQYLC3d68vFDrzwQ2W+JjwvzNwpUS1N2rCZLzMf15+OU7Dov3UDt99fr/l7iEfNw2/T0Xp7pjxIm+7hpZK2uqWweKRs56pryA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=redhat.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=mpAm0bEKaeAlo1rHfNtr++UfqmG83LfCLt+fU8XYdog=;
 b=IIn0D/k2OsNxEhIygGwFiMyCbeEzMzQqr02Wvv/h9He7YPPLUg4d6rTA6uEpgN+mRTrY+HZlhRPjK33abCAv2Gk/2IP6B0j7QQ/yzxvv/bQfJTv/5T8KXGfhIvkxoUY8UT21N7Yvi1cfp3NpSTogbk4u7plSV7V2LCuADnTdHSMVqT83umgNwA1vT9Hx9op4nzwmCtu7Yr9jlvHo0Z00xXTi5ogk7EGI9lqD2Y6B1jmghWcROfV2Ojav4Fbmvk6+PVjgbr5pTBzym3XQhaM13aX6hZ9dxKi5stxlyBvV+a5Dk0ShYc0boZDmsjKpBS+1Yr1vTtC2Ge16Vx4wBe91Yw==
Received: from BYAPR21CA0024.namprd21.prod.outlook.com (2603:10b6:a03:114::34)
 by MN2PR12MB4302.namprd12.prod.outlook.com (2603:10b6:208:1de::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7046.34; Tue, 5 Dec
 2023 17:07:37 +0000
Received: from MWH0EPF000989E9.namprd02.prod.outlook.com
 (2603:10b6:a03:114:cafe::51) by BYAPR21CA0024.outlook.office365.com
 (2603:10b6:a03:114::34) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7091.7 via Frontend
 Transport; Tue, 5 Dec 2023 17:07:37 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.161)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 MWH0EPF000989E9.mail.protection.outlook.com (10.167.241.136) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.7068.20 via Frontend Transport; Tue, 5 Dec 2023 17:07:37 +0000
Received: from rnnvmail204.nvidia.com (10.129.68.6) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.41; Tue, 5 Dec 2023
 09:07:16 -0800
Received: from rnnvmail202.nvidia.com (10.129.68.7) by rnnvmail204.nvidia.com
 (10.129.68.6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.41; Tue, 5 Dec 2023
 09:07:15 -0800
Received: from vdi.nvidia.com (10.127.8.10) by mail.nvidia.com (10.129.68.7)
 with Microsoft SMTP Server id 15.2.986.41 via Frontend Transport; Tue, 5 Dec
 2023 09:07:11 -0800
From: Yishai Hadas <yishaih@nvidia.com>
To: <alex.williamson@redhat.com>, <mst@redhat.com>, <jasowang@redhat.com>,
	<jgg@nvidia.com>
CC: <kvm@vger.kernel.org>, <virtualization@lists.linux-foundation.org>,
	<parav@nvidia.com>, <feliu@nvidia.com>, <jiri@nvidia.com>,
	<kevin.tian@intel.com>, <joao.m.martins@oracle.com>, <si-wei.liu@oracle.com>,
	<leonro@nvidia.com>, <yishaih@nvidia.com>, <maorg@nvidia.com>
Subject: [PATCH V5 vfio 5/9] virtio-pci: Initialize the supported admin commands
Date: Tue, 5 Dec 2023 19:06:19 +0200
Message-ID: <20231205170623.197877-6-yishaih@nvidia.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20231205170623.197877-1-yishaih@nvidia.com>
References: <20231205170623.197877-1-yishaih@nvidia.com>
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
X-MS-TrafficTypeDiagnostic: MWH0EPF000989E9:EE_|MN2PR12MB4302:EE_
X-MS-Office365-Filtering-Correlation-Id: f2410218-3ddd-4808-ffa7-08dbf5b4aea8
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	7f+Rqwk0uOM7sLq/f3J5KiCb9YBkNJsM0a2M92sCiWZYOKvGCOhO8sxlec2PvSm2ekZOUEQNKt1KoOddQRdTTPGoubQRoundheXK5ZxG44RT660QB8jpuZzDsvt8RgcPu0MunxnWmwouVesZ9cSKDVtpC/iqKi6Gjx2ctMLPfdnMhksFfrPPdJf9z5cl3z2S0Mo22ym++qdD+UNWYJHNe87HX6yNvK0AFnVzXJrK6QjVroRa8SVOfVcwTNLuciEKcMn+9MvtyljqA0sizhJE945BkyFC5jXrOSUfy1VwWFn1JI/LpBuIEDcrBv+sRHoNHFPs8wtsQ2oTJMxVhgYMquDsnqUG+5M9QwMXEvdkhrSRcohxkB4f2y/Rd7bbsIhvNG6JWdPdwiwLfoXkbXQEaDzz9RQ/IECdAQZDEIMDnRXx+BRyVm5u8b2lmgP5sXN8TlTrx5XirUBRRw3aFYq9LpH76AHyVD4ocL8yKFgvqb6S0L4ea9VPofigR6BvVPYAQKVsxrlSYiXNUAmdJ0dQMDQXKnHOxFyaGJyZo61AQxi4Bq9fj2RoPIo7L6KvUR0vAaZzhMtl4E3wGDk2ENHDD1QlRxIY3cNipvIZaeRIrmK9atLMdSOldq9TBELK6UZ/mmKjWlCeWenvGLueDip97QU/ijCmBKHPrATmVV6I6K0ZHafIpDTMCe6m0DT/KL+2tXJ9o4Az0Kpu5DgKdxvPgoDfPkNQpBYViSShLDkgCd3oi3ed7Zvl7snLD2JoLUvfp18RzSVDH9ewCGoVXwxm3w==
X-Forefront-Antispam-Report:
	CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230031)(4636009)(39860400002)(346002)(376002)(136003)(396003)(230922051799003)(186009)(64100799003)(82310400011)(451199024)(1800799012)(36840700001)(40470700004)(46966006)(40480700001)(36860700001)(2906002)(316002)(110136005)(54906003)(6636002)(7636003)(70586007)(8676002)(86362001)(70206006)(36756003)(41300700001)(8936002)(4326008)(356005)(47076005)(5660300002)(82740400003)(83380400001)(478600001)(40460700003)(426003)(26005)(1076003)(336012)(7696005)(107886003)(2616005)(2101003);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Dec 2023 17:07:37.4880
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: f2410218-3ddd-4808-ffa7-08dbf5b4aea8
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	MWH0EPF000989E9.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR12MB4302

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


