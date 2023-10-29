Return-Path: <kvm+bounces-21-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 9BB0B7DAD1B
	for <lists+kvm@lfdr.de>; Sun, 29 Oct 2023 17:01:00 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 4C50FB20F71
	for <lists+kvm@lfdr.de>; Sun, 29 Oct 2023 16:00:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CA974DDD4;
	Sun, 29 Oct 2023 16:00:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="ScvYEH5J"
X-Original-To: kvm@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 48A33D30A
	for <kvm@vger.kernel.org>; Sun, 29 Oct 2023 16:00:40 +0000 (UTC)
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2057.outbound.protection.outlook.com [40.107.243.57])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ECEEABF
	for <kvm@vger.kernel.org>; Sun, 29 Oct 2023 09:00:37 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Xe+ycbpavKf3xvDq0p8wWIT0LE4nD3rC4jl5mo3pSc9O/sgj6ELvsmMD3dbCftPuNdJ6kVAv3J7+x/xXPFojqrqiCQofxqGDyH6E6BBBFCfCrjA1/hLa/lPlBynRYj/EFwHN8HV7YPgsl56B3H1elhUmxNEFpZOhbM06uiyQLSN6vWK5BSrMyo/bYjDbrx2p35YleGbxBujKRiKP04J3/Ep790BHB+otdCDCYIbqIj0/z34R60XaxdFXAaD//CRQMwfzteVAcz6jlSVh0GG6OYdmzeGe9mSlmGX6yonOg8PNUpYTLa5wEZp1zyzeiibi0aiLWsPs3pGJJYv69tYLVw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=QoXJJ65hJ3oxd4gyAd6VdWsgJpfTuB0y3so2/NqlF18=;
 b=m1Er9zhAMcUputp5w2ZLF1TcH2MRTONMmSOHbtMcy0WHDpt05GO1U86kmRSwko3wID9lRghuWVYr3gBS0pmW/AbbgPhBWN5a+kfqP4a8S3WAHtElCcQFDpa5//jiDY3Zw/lkUCysPNajiGp+bZSgbFNhJMFZTKnmm8+nweXgIJSB/mXgG1hv2ef8G4yc4/kiKr14ybJlpMG3ZXk2H1FqY9mYvWWCQL3A5aMDi9QwH7izp3TK37ims1SkFjcfdGxSsNcWSuGpDnetKPSgiUmatEr11ITKVb4vw9Y+ul1Fcj3xI9URKMkTdABsKN4q/EPSlxsXe8DYSOpnNcdXZzbliQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.118.233) smtp.rcpttodomain=redhat.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=QoXJJ65hJ3oxd4gyAd6VdWsgJpfTuB0y3so2/NqlF18=;
 b=ScvYEH5Jg8EHSZc6oY3Uvat3fP2rt8j/OVIBDeYAG63QsLLVRM63ZXL+wPF/OdfyZnWp3JJhNWpGdUz5mc5JB+ftfN6Ep56kL1Yen/Z2a36+CPY7+tc+NpdX9Znetlxz9KHHR7P8Bbhamzai3/wJ2PKcs0ch66XyjPRkQOGvjEgBDc4lRwjov7AEKlsdunjRsQJmCGcq+9dNYVa92HN7CCD2JOWWf5ppQATJAb785Z9WB6iSLYkRdpeF3jckFErRTMLV++l2t9f1Z3rhqqnGJQMmjEuYRusEVnNyAiaqzC0vFHSoo4vqv+XOEt85klGRdw3d4b+1b9ohJ9gYhtHPWQ==
Received: from DM6PR02CA0089.namprd02.prod.outlook.com (2603:10b6:5:1f4::30)
 by BL1PR12MB5334.namprd12.prod.outlook.com (2603:10b6:208:31d::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6933.26; Sun, 29 Oct
 2023 16:00:35 +0000
Received: from DS1PEPF0001709C.namprd05.prod.outlook.com
 (2603:10b6:5:1f4:cafe::82) by DM6PR02CA0089.outlook.office365.com
 (2603:10b6:5:1f4::30) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6933.26 via Frontend
 Transport; Sun, 29 Oct 2023 16:00:35 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.118.233)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.118.233 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.118.233; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.118.233) by
 DS1PEPF0001709C.mail.protection.outlook.com (10.167.18.106) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6933.15 via Frontend Transport; Sun, 29 Oct 2023 16:00:35 +0000
Received: from drhqmail201.nvidia.com (10.126.190.180) by mail.nvidia.com
 (10.127.129.6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.41; Sun, 29 Oct
 2023 09:00:24 -0700
Received: from drhqmail203.nvidia.com (10.126.190.182) by
 drhqmail201.nvidia.com (10.126.190.180) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.986.41; Sun, 29 Oct 2023 09:00:24 -0700
Received: from vdi.nvidia.com (10.127.8.10) by mail.nvidia.com
 (10.126.190.182) with Microsoft SMTP Server id 15.2.986.41 via Frontend
 Transport; Sun, 29 Oct 2023 09:00:20 -0700
From: Yishai Hadas <yishaih@nvidia.com>
To: <alex.williamson@redhat.com>, <mst@redhat.com>, <jasowang@redhat.com>,
	<jgg@nvidia.com>
CC: <kvm@vger.kernel.org>, <virtualization@lists.linux-foundation.org>,
	<parav@nvidia.com>, <feliu@nvidia.com>, <jiri@nvidia.com>,
	<kevin.tian@intel.com>, <joao.m.martins@oracle.com>, <si-wei.liu@oracle.com>,
	<leonro@nvidia.com>, <yishaih@nvidia.com>, <maorg@nvidia.com>
Subject: [PATCH V2 vfio 3/9] virtio-pci: Introduce admin command sending function
Date: Sun, 29 Oct 2023 17:59:46 +0200
Message-ID: <20231029155952.67686-4-yishaih@nvidia.com>
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
X-MS-TrafficTypeDiagnostic: DS1PEPF0001709C:EE_|BL1PR12MB5334:EE_
X-MS-Office365-Filtering-Correlation-Id: d42ed2f2-8965-422b-802f-08dbd8983016
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	QNhiHAtnGFs5UkAlblCzconngg0oORBkB43M7U0iodvf2wVX57HUpaHyYVgiGki5Ly86gq7WsiMakQsYnjOpCTFwxrjnavQQSmxWJRjw3RgUac0tR1blISw3Zc0Xmur1Cw1LbSyUpQ2sq9PznSS2N4x28K5D5+EkGjiW7h/fVa7MTftS5Oda8liWFMgUq7vNIvRbGcMkZmmUGnpfACIymB0tKAGRAZjJkSjR99oc0FlzsHHU6uoZpj+zWakPnUtbzLpSYcw7ZcciqT2Dem2dMYZ9MLXVFGZ7NHwuEw05USypbkBmwDcdoJBz57y4KJN3CaOVYqTlmC+wabJk+avWT9xD1YTRk02Shrzqvav3k2mF2hWkkxVi7njduWkV+zyzOI+KpnM7+2+DcJQgkATYlbcM3n5glZ2gjhxLzqpvzycoDOn/hFK3S4Vyrajsw37UsVdyUCBbdVloue5mJvQT8wgTRKX8X3XFobWtgYXYLUNMOCyk6544pHM4j++zgU/RCow1d65EVIHDTmpv3wmOEqNyhfkwOpFBfRZ2AgTNBoIgd+bzwPJTDqyZ0y8/PbQw0lws9/9wRF4LZSzc0+o/YxYR8I24dzOCdjZiVM848TF88U5stn1ekM6AsC6oixBua4/qOOsztnPOKV8Nftxrh04eQAvfKmCKJ/a3Xw4u1+7Oq/DZXNOon1dqDdFR4po/emHAZy7ioN6CI9+V9p/0l1G3D1tv2bZVJzUx7xu/ORH6CbfK/yDy8jY6MOduBb69v39ybepa0Y9yIivr/8Fw0Q==
X-Forefront-Antispam-Report:
	CIP:216.228.118.233;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc7edge2.nvidia.com;CAT:NONE;SFS:(13230031)(4636009)(136003)(346002)(376002)(39860400002)(396003)(230922051799003)(186009)(451199024)(1800799009)(64100799003)(82310400011)(36840700001)(40470700004)(46966006)(5660300002)(41300700001)(2906002)(110136005)(54906003)(70206006)(70586007)(40460700003)(8936002)(8676002)(4326008)(40480700001)(478600001)(316002)(6636002)(83380400001)(356005)(7636003)(107886003)(36860700001)(47076005)(86362001)(36756003)(7696005)(6666004)(1076003)(426003)(336012)(26005)(2616005)(82740400003)(2101003);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Oct 2023 16:00:35.4904
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: d42ed2f2-8965-422b-802f-08dbd8983016
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.118.233];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DS1PEPF0001709C.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR12MB5334

From: Feng Liu <feliu@nvidia.com>

Add support for sending admin command through admin virtqueue interface.
Abort any inflight admin commands once device reset completes.

To enforce the below statement from the specification [1], the admin
queue is activated for the upper layer users only post of setting status
to DRIVER_OK.

[1] The driver MUST NOT send any buffer available notifications to the
device before setting DRIVER_OK.

Signed-off-by: Feng Liu <feliu@nvidia.com>
Reviewed-by: Parav Pandit <parav@nvidia.com>
Signed-off-by: Yishai Hadas <yishaih@nvidia.com>
---
 drivers/virtio/virtio_pci_common.h |   3 +
 drivers/virtio/virtio_pci_modern.c | 174 +++++++++++++++++++++++++++++
 include/linux/virtio.h             |   8 ++
 include/uapi/linux/virtio_pci.h    |  22 ++++
 4 files changed, 207 insertions(+)

diff --git a/drivers/virtio/virtio_pci_common.h b/drivers/virtio/virtio_pci_common.h
index e03af0966a4b..a21b9ba01a60 100644
--- a/drivers/virtio/virtio_pci_common.h
+++ b/drivers/virtio/virtio_pci_common.h
@@ -44,9 +44,12 @@ struct virtio_pci_vq_info {
 struct virtio_pci_admin_vq {
 	/* Virtqueue info associated with this admin queue. */
 	struct virtio_pci_vq_info info;
+	struct completion flush_done;
+	refcount_t refcount;
 	/* Name of the admin queue: avq.$index. */
 	char name[10];
 	u16 vq_index;
+	bool abort;
 };
 
 /* Our device structure */
diff --git a/drivers/virtio/virtio_pci_modern.c b/drivers/virtio/virtio_pci_modern.c
index 01c5ba346471..ccd7a4d9f57f 100644
--- a/drivers/virtio/virtio_pci_modern.c
+++ b/drivers/virtio/virtio_pci_modern.c
@@ -36,6 +36,58 @@ static bool vp_is_avq(struct virtio_device *vdev, unsigned int index)
 	return index == vp_dev->admin_vq.vq_index;
 }
 
+static bool vp_modern_avq_get(struct virtio_pci_admin_vq *admin_vq)
+{
+	return refcount_inc_not_zero(&admin_vq->refcount);
+}
+
+static void vp_modern_avq_put(struct virtio_pci_admin_vq *admin_vq)
+{
+	if (refcount_dec_and_test(&admin_vq->refcount))
+		complete(&admin_vq->flush_done);
+}
+
+static bool vp_modern_avq_is_abort(const struct virtio_pci_admin_vq *admin_vq)
+{
+	return READ_ONCE(admin_vq->abort);
+}
+
+static void
+vp_modern_avq_set_abort(struct virtio_pci_admin_vq *admin_vq, bool abort)
+{
+	/* Mark the AVQ to abort, so that inflight commands can be aborted. */
+	WRITE_ONCE(admin_vq->abort, abort);
+}
+
+static void vp_modern_avq_activate(struct virtio_device *vdev)
+{
+	struct virtio_pci_device *vp_dev = to_vp_device(vdev);
+	struct virtio_pci_admin_vq *admin_vq = &vp_dev->admin_vq;
+
+	if (!virtio_has_feature(vdev, VIRTIO_F_ADMIN_VQ))
+		return;
+
+	init_completion(&admin_vq->flush_done);
+	refcount_set(&admin_vq->refcount, 1);
+	vp_modern_avq_set_abort(admin_vq, false);
+}
+
+static void vp_modern_avq_deactivate(struct virtio_device *vdev)
+{
+	struct virtio_pci_device *vp_dev = to_vp_device(vdev);
+	struct virtio_pci_admin_vq *admin_vq = &vp_dev->admin_vq;
+
+	if (!virtio_has_feature(vdev, VIRTIO_F_ADMIN_VQ))
+		return;
+
+	vp_modern_avq_set_abort(admin_vq, true);
+	/* Balance with refcount_set() during vp_modern_avq_activate */
+	vp_modern_avq_put(admin_vq);
+
+	/* Wait for all the inflight admin commands to be aborted */
+	wait_for_completion(&vp_dev->admin_vq.flush_done);
+}
+
 static void vp_transport_features(struct virtio_device *vdev, u64 features)
 {
 	struct virtio_pci_device *vp_dev = to_vp_device(vdev);
@@ -172,6 +224,8 @@ static void vp_set_status(struct virtio_device *vdev, u8 status)
 	/* We should never be setting status to 0. */
 	BUG_ON(status == 0);
 	vp_modern_set_status(&vp_dev->mdev, status);
+	if (status & VIRTIO_CONFIG_S_DRIVER_OK)
+		vp_modern_avq_activate(vdev);
 }
 
 static void vp_reset(struct virtio_device *vdev)
@@ -188,6 +242,9 @@ static void vp_reset(struct virtio_device *vdev)
 	 */
 	while (vp_modern_get_status(mdev))
 		msleep(1);
+
+	vp_modern_avq_deactivate(vdev);
+
 	/* Flush pending VQ/configuration callbacks. */
 	vp_synchronize_vectors(vdev);
 }
@@ -505,6 +562,121 @@ static bool vp_get_shm_region(struct virtio_device *vdev,
 	return true;
 }
 
+static int virtqueue_exec_admin_cmd(struct virtio_pci_admin_vq *admin_vq,
+				    struct scatterlist **sgs,
+				    unsigned int out_num,
+				    unsigned int in_num,
+				    void *data,
+				    gfp_t gfp)
+{
+	struct virtqueue *vq;
+	int ret, len;
+
+	if (!vp_modern_avq_get(admin_vq))
+		return -EIO;
+
+	vq = admin_vq->info.vq;
+
+	ret = virtqueue_add_sgs(vq, sgs, out_num, in_num, data, gfp);
+	if (ret < 0)
+		goto out;
+
+	if (unlikely(!virtqueue_kick(vq))) {
+		ret = -EIO;
+		goto out;
+	}
+
+	while (!virtqueue_get_buf(vq, &len) &&
+	       !virtqueue_is_broken(vq) &&
+	       !vp_modern_avq_is_abort(admin_vq))
+		cpu_relax();
+
+	if (vp_modern_avq_is_abort(admin_vq) || virtqueue_is_broken(vq)) {
+		ret = -EIO;
+		goto out;
+	}
+out:
+	vp_modern_avq_put(admin_vq);
+	return ret;
+}
+
+#define VIRTIO_AVQ_SGS_MAX	4
+
+static int vp_modern_admin_cmd_exec(struct virtio_device *vdev,
+				    struct virtio_admin_cmd *cmd)
+{
+	struct scatterlist *sgs[VIRTIO_AVQ_SGS_MAX], hdr, stat;
+	struct virtio_pci_device *vp_dev = to_vp_device(vdev);
+	struct virtio_admin_cmd_status *va_status;
+	unsigned int out_num = 0, in_num = 0;
+	struct virtio_admin_cmd_hdr *va_hdr;
+	struct virtqueue *avq;
+	u16 status;
+	int ret;
+
+	avq = virtio_has_feature(vdev, VIRTIO_F_ADMIN_VQ) ?
+		vp_dev->admin_vq.info.vq : NULL;
+	if (!avq)
+		return -EOPNOTSUPP;
+
+	va_status = kzalloc(sizeof(*va_status), GFP_KERNEL);
+	if (!va_status)
+		return -ENOMEM;
+
+	va_hdr = kzalloc(sizeof(*va_hdr), GFP_KERNEL);
+	if (!va_hdr) {
+		ret = -ENOMEM;
+		goto err_alloc;
+	}
+
+	va_hdr->opcode = cmd->opcode;
+	va_hdr->group_type = cmd->group_type;
+	va_hdr->group_member_id = cmd->group_member_id;
+
+	/* Add header */
+	sg_init_one(&hdr, va_hdr, sizeof(*va_hdr));
+	sgs[out_num] = &hdr;
+	out_num++;
+
+	if (cmd->data_sg) {
+		sgs[out_num] = cmd->data_sg;
+		out_num++;
+	}
+
+	/* Add return status */
+	sg_init_one(&stat, va_status, sizeof(*va_status));
+	sgs[out_num + in_num] = &stat;
+	in_num++;
+
+	if (cmd->result_sg) {
+		sgs[out_num + in_num] = cmd->result_sg;
+		in_num++;
+	}
+
+	ret = virtqueue_exec_admin_cmd(&vp_dev->admin_vq, sgs,
+				       out_num, in_num,
+				       sgs, GFP_KERNEL);
+	if (ret) {
+		dev_err(&vdev->dev,
+			"Failed to execute command on admin vq: %d\n.", ret);
+		goto err_cmd_exec;
+	}
+
+	status = le16_to_cpu(va_status->status);
+	if (status != VIRTIO_ADMIN_STATUS_OK) {
+		dev_err(&vdev->dev,
+			"admin command error: status(%#x) qualifier(%#x)\n",
+			status, le16_to_cpu(va_status->status_qualifier));
+		ret = -status;
+	}
+
+err_cmd_exec:
+	kfree(va_hdr);
+err_alloc:
+	kfree(va_status);
+	return ret;
+}
+
 static int vp_modern_create_avq(struct virtio_device *vdev)
 {
 	struct virtio_pci_device *vp_dev = to_vp_device(vdev);
@@ -530,6 +702,7 @@ static int vp_modern_create_avq(struct virtio_device *vdev)
 		return PTR_ERR(vq);
 	}
 
+	refcount_set(&vp_dev->admin_vq.refcount, 0);
 	vp_dev->admin_vq.info.vq = vq;
 	vp_modern_set_queue_enable(&vp_dev->mdev, avq->info.vq->index, true);
 	return 0;
@@ -542,6 +715,7 @@ static void vp_modern_destroy_avq(struct virtio_device *vdev)
 	if (!virtio_has_feature(vdev, VIRTIO_F_ADMIN_VQ))
 		return;
 
+	WARN_ON(refcount_read(&vp_dev->admin_vq.refcount));
 	vp_dev->del_vq(&vp_dev->admin_vq.info);
 }
 
diff --git a/include/linux/virtio.h b/include/linux/virtio.h
index 4cc614a38376..b0201747a263 100644
--- a/include/linux/virtio.h
+++ b/include/linux/virtio.h
@@ -103,6 +103,14 @@ int virtqueue_resize(struct virtqueue *vq, u32 num,
 int virtqueue_reset(struct virtqueue *vq,
 		    void (*recycle)(struct virtqueue *vq, void *buf));
 
+struct virtio_admin_cmd {
+	__le16 opcode;
+	__le16 group_type;
+	__le64 group_member_id;
+	struct scatterlist *data_sg;
+	struct scatterlist *result_sg;
+};
+
 /**
  * struct virtio_device - representation of a device using virtio
  * @index: unique position on the virtio bus
diff --git a/include/uapi/linux/virtio_pci.h b/include/uapi/linux/virtio_pci.h
index f703afc7ad31..68eacc9676dc 100644
--- a/include/uapi/linux/virtio_pci.h
+++ b/include/uapi/linux/virtio_pci.h
@@ -207,4 +207,26 @@ struct virtio_pci_cfg_cap {
 
 #endif /* VIRTIO_PCI_NO_MODERN */
 
+/* Admin command status. */
+#define VIRTIO_ADMIN_STATUS_OK		0
+
+struct __packed virtio_admin_cmd_hdr {
+	__le16 opcode;
+	/*
+	 * 1 - SR-IOV
+	 * 2-65535 - reserved
+	 */
+	__le16 group_type;
+	/* Unused, reserved for future extensions. */
+	__u8 reserved1[12];
+	__le64 group_member_id;
+};
+
+struct __packed virtio_admin_cmd_status {
+	__le16 status;
+	__le16 status_qualifier;
+	/* Unused, reserved for future extensions. */
+	__u8 reserved2[4];
+};
+
 #endif
-- 
2.27.0


