Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 180677CC4FA
	for <lists+kvm@lfdr.de>; Tue, 17 Oct 2023 15:43:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343941AbjJQNnV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 17 Oct 2023 09:43:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34198 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343839AbjJQNnT (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 17 Oct 2023 09:43:19 -0400
Received: from NAM04-DM6-obe.outbound.protection.outlook.com (mail-dm6nam04on2075.outbound.protection.outlook.com [40.107.102.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1220FED
        for <kvm@vger.kernel.org>; Tue, 17 Oct 2023 06:43:17 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=n6yAAQWiYONWi5MWdItCRsqeNaZUhmnjqE2f6ildgSRgXq/laHWuSDrXeKR62ajb5lPy27k3o8r09D3DLnNsw/X+oNo8L3vIFKXeZmWl6nTzCsbfREhVDwX/kbWSMm2rvH+04HTMg32l4xxYWVsBg1uKEqlv2dm0lhywTkhl3FPBHwKq2xYItbB1MkFvbkr9dl/n78gJ7U24ItGgO6GBADRjlKPGFG13K0AUN8sRPwn0MNroJJE3K9P+1Nbn9TLXoq1g9xDg6cPIe8ImvIrBOO1TiFxhb1Ibc+VEywh1540mLHynputJvaYe7Mg2/6R0huTz/etM3Wx+Z/HEPGK1gQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=XEMLOslbjE7s0T+I7e3viuv6x390oXFNqwpcKNl9tFU=;
 b=cm68+xVQvnIm+444pmYag3mcAgmfE6hfW9K7IoC0f9s6rwOcLZzgkKHP+KkaUA7g8IpfZfEOm78N6fJ9rPRQbthymijC8+SQ2ywOXxlsqYH6lWkPwDNPWqhPqSbKCl3Y7RA4E6YJcgdXc/r2frwieFEhSdAixFduB7rhgRDGVNJV+Ht1VpeFRxvvexmAwrQAFQxCBnrcm9kClMlKzyWdAAR2Ja1h7/XQMKuKQG0AbxTEHQWx31XX4sD3UOPGQ5OoXnW1bo1/pfePQ+AEgMx0IVlQQKboPsesUUa7hfUOSIeuxpR5Uq2IzjfX6mIDJkTpwQCQ97Yf+IZgUqcaiObGgA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=redhat.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=XEMLOslbjE7s0T+I7e3viuv6x390oXFNqwpcKNl9tFU=;
 b=ZZSrUfBeTmKquTfOcotjZMIEI2ixvDk91D10CtcnNfoBHdncdlQqyLF9usvBaWznJbGACHrz3Z5n6xB8LK1IbAC+jK6nMwQpPj1DOqX3eep3JCge5O9l6rbfbH1yjCrnX9iuHdYc53o6gGFpeXApetFWyVTbozX9M7KT7mJVeRYOvtPVUh6KfvzLJdjejmdPwHcWO/wxv6gabB5+qYWLVAD/WbknoqpjcqzH701IHxch/cLLAwm4RvxnmTHbWXh1jRWpCvNVLhlWbWcZnJzQotFcrs+MortEZ6+E/bPPLJ0p3TZCpuU1hTGqxtHmvQWsWlsYnLzbAjyud8lAsdIYZA==
Received: from SA0PR13CA0027.namprd13.prod.outlook.com (2603:10b6:806:130::32)
 by SN7PR12MB6768.namprd12.prod.outlook.com (2603:10b6:806:268::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6886.36; Tue, 17 Oct
 2023 13:43:14 +0000
Received: from SA2PEPF00001508.namprd04.prod.outlook.com
 (2603:10b6:806:130:cafe::9e) by SA0PR13CA0027.outlook.office365.com
 (2603:10b6:806:130::32) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6907.18 via Frontend
 Transport; Tue, 17 Oct 2023 13:43:14 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.160)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 SA2PEPF00001508.mail.protection.outlook.com (10.167.242.40) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6907.20 via Frontend Transport; Tue, 17 Oct 2023 13:43:14 +0000
Received: from rnnvmail202.nvidia.com (10.129.68.7) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.41; Tue, 17 Oct
 2023 06:42:58 -0700
Received: from rnnvmail205.nvidia.com (10.129.68.10) by rnnvmail202.nvidia.com
 (10.129.68.7) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.41; Tue, 17 Oct
 2023 06:42:57 -0700
Received: from vdi.nvidia.com (10.127.8.10) by mail.nvidia.com (10.129.68.10)
 with Microsoft SMTP Server id 15.2.986.41 via Frontend Transport; Tue, 17 Oct
 2023 06:42:54 -0700
From:   Yishai Hadas <yishaih@nvidia.com>
To:     <alex.williamson@redhat.com>, <mst@redhat.com>,
        <jasowang@redhat.com>, <jgg@nvidia.com>
CC:     <kvm@vger.kernel.org>, <virtualization@lists.linux-foundation.org>,
        <parav@nvidia.com>, <feliu@nvidia.com>, <jiri@nvidia.com>,
        <kevin.tian@intel.com>, <joao.m.martins@oracle.com>,
        <si-wei.liu@oracle.com>, <leonro@nvidia.com>, <yishaih@nvidia.com>,
        <maorg@nvidia.com>
Subject: [PATCH V1 vfio 4/9] virtio-pci: Introduce admin command sending function
Date:   Tue, 17 Oct 2023 16:42:12 +0300
Message-ID: <20231017134217.82497-5-yishaih@nvidia.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20231017134217.82497-1-yishaih@nvidia.com>
References: <20231017134217.82497-1-yishaih@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-NV-OnPremToCloud: ExternallySecured
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA2PEPF00001508:EE_|SN7PR12MB6768:EE_
X-MS-Office365-Filtering-Correlation-Id: 4e2fb57f-f699-49f4-982b-08dbcf17032f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: dcYYAlrKrx45sHm/jSlaimBQUbPw2ekTMAL4fJd7tV/epUIFxDnLGDUVOCQsmJv8cGipTVonIlaZXsM6zHTDpUtL9eC8bAv89fz58Gp5lABsUD1McUPKmCzOVORrsDm/QrFE6mRKDkT+mmZvHnqcUEcwxjVaDdp0QK/CtycUwS2V1vZerV02+gkyCBk6bbhmRNLSxs2uzCUMcMLdenviYW2JbwRSyxqXk2OeU/b6LUz8kfvAj68L4W+TaCM1W5lwPFv/ElCTcCn74QCpRnrEjaHy08pZUGRgP8PkOgqjpVlAjtzl/khsKKTtI4awOOZZQTNnogcdaldwV5ZdqlzAoB8lH5ZDKmp5vWwSvZL622xOIpVYrrfssa2wrKdB31Clc3Z4fpVs30zVfI9yLAVIQVDo8pQjaWCd1l0awKvFMHrnVykLxB79aV+anAt9S9DSwckekPxpYvRRADiYmxkrd6mdqjvEvSa375KO7fVLGuMM0UXh2Ufc7bOhXJR6NJrKQMW3CsyFMpHD24VJLSv75kb8vf36dc7W4tsznY/EjFphUv43scWNoIiEjW6rQrzmjGIZdph2qW+eDz8F3FOH/Lpm3TSjqmDKH8XuVu8QUMCoIAml3PlZJwwWAUhSb3uVx/2A/qcIMqaWL8CNvkUp6+OR82SAHyLbjbFMM64iFl26RftIUd3ziSEyVXow1k2eZ+gv0vJgMI6aGg/rpqS89faPhRLcJTSq49+kExCilEVa2I37CDe1U0TkhVQ5yKiNcgGWW9LHIqnxmir31vFd2w==
X-Forefront-Antispam-Report: CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230031)(4636009)(136003)(39860400002)(396003)(346002)(376002)(230922051799003)(82310400011)(186009)(64100799003)(1800799009)(451199024)(40470700004)(36840700001)(46966006)(36756003)(40480700001)(40460700003)(110136005)(316002)(54906003)(6636002)(70586007)(70206006)(86362001)(82740400003)(7636003)(356005)(36860700001)(83380400001)(426003)(336012)(107886003)(26005)(2616005)(1076003)(8936002)(6666004)(7696005)(2906002)(478600001)(41300700001)(5660300002)(8676002)(47076005)(4326008)(2101003);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Oct 2023 13:43:14.6142
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 4e2fb57f-f699-49f4-982b-08dbcf17032f
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: SA2PEPF00001508.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR12MB6768
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

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
index 01c5ba346471..cc159a8e6c70 100644
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
+	if (vp_modern_avq_is_abort(admin_vq)) {
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

