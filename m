Return-Path: <kvm+bounces-1573-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id B92B47E973A
	for <lists+kvm@lfdr.de>; Mon, 13 Nov 2023 09:03:43 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 6F0AC280D3E
	for <lists+kvm@lfdr.de>; Mon, 13 Nov 2023 08:03:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7C56915AD6;
	Mon, 13 Nov 2023 08:03:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="P1RTmWW6"
X-Original-To: kvm@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 19F58182D8
	for <kvm@vger.kernel.org>; Mon, 13 Nov 2023 08:03:24 +0000 (UTC)
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2069.outbound.protection.outlook.com [40.107.243.69])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7FDF110F1
	for <kvm@vger.kernel.org>; Mon, 13 Nov 2023 00:03:22 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=V36QLUmpe/BSwaIzrZcSwTLalJATgu/xXPjippn5YYbK4WMhTDIdLpgdMLeazj8YLCz2i3hpqjbikYZjcEuazWky4ARN60Dr+NLFUlbpbnJi2huX1+lqzNJStWZT+4T7plkxLk83fDrzkr5xLmJzTo+If5qNZhKYEVfDqHrIb2nlx1VCSmkTAjqagFvrIhRWSclTzopTtoQdsibYptdz8vspUwPC9ERw7PdiVwQe9k3YF3G9OtgtWADwEj/1zwDKo15Vc4leLPqmIeWZWF59GoGN71biu95x+hRf7Z9ELxIs2kEcwr1scHAcw/YlHTtuyhf7Zf+pQ0JxpCeFhfORXA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=SUOELnc9gN3QcaO1Jw+WXoSAT6SnBkUu3zTkeoSxxQw=;
 b=K2obPcsw/GEVBzPtKwA6KHz2HMqKerAXTJd8UXfS98hsZf3MfogMOeaEeXkyuQrCjuYhYqREK8LKDQmHL45ZWvc4DpMwWv77gO4wmdww2f/vzXiF+WcRzuFxE9mK/AwuQJzISVZzOD+F2Gg63E7ii20wmS5BBsFdn3uLRVEaje0D1wzB8JJPhkiItp6nQVZMTHA69TpaM3rnTqk/kAtZooNj21ExbU4mr+utGjMcE0MYSU2WL143pU325oVLCylb7f/zgKJYn6XATKEqECaO25z4/n4Tf2zfvLOUaRPRfLR7558RVxq+rvO+4h4BJlHRgERdAXPDNShZhacr7L2e6Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.118.233) smtp.rcpttodomain=redhat.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=SUOELnc9gN3QcaO1Jw+WXoSAT6SnBkUu3zTkeoSxxQw=;
 b=P1RTmWW6lDOiRuUmIvT3Pl9d7OLF+Sasd4HgZtWDq8rsPjxt0gRvxCsQKDFVFBcH032quDN/99zlVLYYgaqSNDZgKT4G8zkoEOdNDPR3QpWSqyC5I9uULCBXu7puy/DAnDnVytIk2eVZyWLTWMQwFx5UwpAtzT3Zm0ORADvC5FPqP0dHK1kg8bXA2ytQlo8rggiFz55uH/WDrH9PubXBKtJpUzRVL9TNyv1XI2L03igDO2vLpJW3VRxLG7TkcuX50RfN58AenSbRiOfdnOo2vI5k03nMGyrkbJx6zNnJmwOi3LMLSt62iq0CuH1zFn6wPMzzV0uGgQreurVq05nSQw==
Received: from BL1PR13CA0288.namprd13.prod.outlook.com (2603:10b6:208:2bc::23)
 by CH0PR12MB5186.namprd12.prod.outlook.com (2603:10b6:610:b9::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6977.29; Mon, 13 Nov
 2023 08:03:19 +0000
Received: from BL02EPF0001A103.namprd05.prod.outlook.com
 (2603:10b6:208:2bc:cafe::12) by BL1PR13CA0288.outlook.office365.com
 (2603:10b6:208:2bc::23) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7002.15 via Frontend
 Transport; Mon, 13 Nov 2023 08:03:19 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.118.233)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.118.233 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.118.233; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.118.233) by
 BL02EPF0001A103.mail.protection.outlook.com (10.167.241.133) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.7002.13 via Frontend Transport; Mon, 13 Nov 2023 08:03:19 +0000
Received: from drhqmail201.nvidia.com (10.126.190.180) by mail.nvidia.com
 (10.127.129.6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.41; Mon, 13 Nov
 2023 00:03:08 -0800
Received: from drhqmail203.nvidia.com (10.126.190.182) by
 drhqmail201.nvidia.com (10.126.190.180) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.986.41; Mon, 13 Nov 2023 00:03:07 -0800
Received: from vdi.nvidia.com (10.127.8.10) by mail.nvidia.com
 (10.126.190.182) with Microsoft SMTP Server id 15.2.986.41 via Frontend
 Transport; Mon, 13 Nov 2023 00:03:04 -0800
From: Yishai Hadas <yishaih@nvidia.com>
To: <alex.williamson@redhat.com>, <mst@redhat.com>, <jasowang@redhat.com>,
	<jgg@nvidia.com>
CC: <kvm@vger.kernel.org>, <virtualization@lists.linux-foundation.org>,
	<parav@nvidia.com>, <feliu@nvidia.com>, <jiri@nvidia.com>,
	<kevin.tian@intel.com>, <joao.m.martins@oracle.com>, <si-wei.liu@oracle.com>,
	<leonro@nvidia.com>, <yishaih@nvidia.com>, <maorg@nvidia.com>
Subject: [PATCH V3 vfio 3/9] virtio-pci: Introduce admin command sending function
Date: Mon, 13 Nov 2023 10:02:16 +0200
Message-ID: <20231113080222.91795-4-yishaih@nvidia.com>
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
X-MS-TrafficTypeDiagnostic: BL02EPF0001A103:EE_|CH0PR12MB5186:EE_
X-MS-Office365-Filtering-Correlation-Id: bbcb12d2-c522-49da-a477-08dbe41effe3
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	NPnh5/moFhI/39NkAXQlu+JH499uKJ3lkNiffe/UqqKd1pxidwqwpPLBxdBkddXZQHOYal8BZ+X6OgFHSmyhR+HbwygbxYkgkW3rdXDWwTYlvdRaJnMSVDlZlZpj7gP179jgEQYWkEjYjONBCpL3pRzqqLPr7lKTM/V23Z0I/7gc8gF2ZWz/fg0bt5T8nNnu3OFvnlQ7+AOC3rw7FDI5oz+W895UhOlnJ+6KtCvgShWUmKCLqKf0OKAzyJgUBuO4/DUpzaHBHuXfYOC3CN3FrHYB8Vi0XaqEGHscP7yjDpZWyDcHCLdJi+Lc+90WzYOkU2/GbAdtoXxkhGFiO4acB+mL3xsxrxa/GftXEgR0G3WjhIjsYknXNm0zV+zYSt+eiW13F6KsMDqdXiwaoGs+vCMHGFV2KWeFOkuDLIeuogZx/L2NkeIQ7sZMHku7Y96zXk5ccdoX4Mm4EWie0elOlPlFBKL9CVoCcwclnU2aL54M8m0apixuZ9vM/j/mRHg46WqyWUKA4911MSC+W77jqRNHEDuo/mY9OraJaSycVrjwaaWUullL+VYOKMY+Fj6GEHyenmgzjcx844VFb+T4pdGe4dEH6Bx6T0aC4svd9uxT/z3/ScIEPdJNw/dxfxKPC4oU9/8suNcJ7g5XThmMFrDdTeC0Df+PYOYqtsbPK1ZKMHVBnYa8FlRn45n/FnBIdjEwvIezdr+uOfAU4J7dznewoU6unht3qdL689WC1gXgIUQ7+FAOqIlooEYbpbHFRd/mo0LZxwmiNY28+s8qKg==
X-Forefront-Antispam-Report:
	CIP:216.228.118.233;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc7edge2.nvidia.com;CAT:NONE;SFS:(13230031)(4636009)(376002)(396003)(346002)(136003)(39860400002)(230922051799003)(82310400011)(186009)(64100799003)(1800799009)(451199024)(40470700004)(46966006)(36840700001)(40480700001)(40460700003)(54906003)(70586007)(70206006)(110136005)(6636002)(316002)(82740400003)(7636003)(356005)(86362001)(36756003)(36860700001)(83380400001)(26005)(1076003)(107886003)(426003)(336012)(6666004)(2616005)(7696005)(2906002)(478600001)(5660300002)(47076005)(41300700001)(8676002)(4326008)(8936002)(2101003);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Nov 2023 08:03:19.4286
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: bbcb12d2-c522-49da-a477-08dbe41effe3
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.118.233];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BL02EPF0001A103.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR12MB5186

From: Feng Liu <feliu@nvidia.com>

Add support for sending admin command through admin virtqueue interface.
Abort any inflight admin commands once device reset completes. Activate
admin queue when device becomes ready; deactivate on device reset.

To comply to the below specification statement [1], the admin virtqueue
is activated for upper layer users only after setting DRIVER_OK status.

[1] The driver MUST NOT send any buffer available notifications to the
device before setting DRIVER_OK.

Signed-off-by: Feng Liu <feliu@nvidia.com>
Reviewed-by: Parav Pandit <parav@nvidia.com>
Signed-off-by: Yishai Hadas <yishaih@nvidia.com>
---
 drivers/virtio/virtio_pci_common.h |   3 +
 drivers/virtio/virtio_pci_modern.c | 143 ++++++++++++++++++++++++++++-
 include/linux/virtio.h             |   8 ++
 include/uapi/linux/virtio_pci.h    |  22 +++++
 4 files changed, 174 insertions(+), 2 deletions(-)

diff --git a/drivers/virtio/virtio_pci_common.h b/drivers/virtio/virtio_pci_common.h
index 7306128e63e9..a50a58014c9f 100644
--- a/drivers/virtio/virtio_pci_common.h
+++ b/drivers/virtio/virtio_pci_common.h
@@ -29,6 +29,7 @@
 #include <linux/virtio_pci_modern.h>
 #include <linux/highmem.h>
 #include <linux/spinlock.h>
+#include <linux/mutex.h>
 
 struct virtio_pci_vq_info {
 	/* the actual virtqueue */
@@ -44,6 +45,8 @@ struct virtio_pci_vq_info {
 struct virtio_pci_admin_vq {
 	/* Virtqueue info associated with this admin queue. */
 	struct virtio_pci_vq_info info;
+	/* serializing admin commands execution and virtqueue deletion */
+	struct mutex cmd_lock;
 	/* Name of the admin queue: avq.$vq_index. */
 	char name[10];
 	u16 vq_index;
diff --git a/drivers/virtio/virtio_pci_modern.c b/drivers/virtio/virtio_pci_modern.c
index ce915018b5b0..18366a82408c 100644
--- a/drivers/virtio/virtio_pci_modern.c
+++ b/drivers/virtio/virtio_pci_modern.c
@@ -38,6 +38,132 @@ static bool vp_is_avq(struct virtio_device *vdev, unsigned int index)
 	return index == vp_dev->admin_vq.vq_index;
 }
 
+static int virtqueue_exec_admin_cmd(struct virtio_pci_admin_vq *admin_vq,
+				    struct scatterlist **sgs,
+				    unsigned int out_num,
+				    unsigned int in_num,
+				    void *data)
+{
+	struct virtqueue *vq;
+	int ret, len;
+
+	vq = admin_vq->info.vq;
+	if (!vq)
+		return -EIO;
+
+	ret = virtqueue_add_sgs(vq, sgs, out_num, in_num, data, GFP_KERNEL);
+	if (ret < 0)
+		return -EIO;
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
+static int vp_modern_admin_cmd_exec(struct virtio_device *vdev,
+				    struct virtio_admin_cmd *cmd)
+{
+	struct scatterlist *sgs[VIRTIO_AVQ_SGS_MAX], hdr, stat;
+	struct virtio_pci_device *vp_dev = to_vp_device(vdev);
+	struct virtio_admin_cmd_status *va_status;
+	unsigned int out_num = 0, in_num = 0;
+	struct virtio_admin_cmd_hdr *va_hdr;
+	u16 status;
+	int ret;
+
+	if (!virtio_has_feature(vdev, VIRTIO_F_ADMIN_VQ))
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
+	mutex_lock(&vp_dev->admin_vq.cmd_lock);
+	ret = virtqueue_exec_admin_cmd(&vp_dev->admin_vq, sgs,
+				       out_num, in_num, sgs);
+	mutex_unlock(&vp_dev->admin_vq.cmd_lock);
+
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
+static void vp_modern_avq_activate(struct virtio_device *vdev)
+{
+	struct virtio_pci_device *vp_dev = to_vp_device(vdev);
+	struct virtio_pci_admin_vq *admin_vq = &vp_dev->admin_vq;
+
+	if (!virtio_has_feature(vdev, VIRTIO_F_ADMIN_VQ))
+		return;
+
+	__virtqueue_unbreak(admin_vq->info.vq);
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
+	__virtqueue_break(admin_vq->info.vq);
+}
+
 static void vp_transport_features(struct virtio_device *vdev, u64 features)
 {
 	struct virtio_pci_device *vp_dev = to_vp_device(vdev);
@@ -213,6 +339,8 @@ static void vp_set_status(struct virtio_device *vdev, u8 status)
 	/* We should never be setting status to 0. */
 	BUG_ON(status == 0);
 	vp_modern_set_status(&vp_dev->mdev, status);
+	if (status & VIRTIO_CONFIG_S_DRIVER_OK)
+		vp_modern_avq_activate(vdev);
 }
 
 static void vp_reset(struct virtio_device *vdev)
@@ -229,6 +357,9 @@ static void vp_reset(struct virtio_device *vdev)
 	 */
 	while (vp_modern_get_status(mdev))
 		msleep(1);
+
+	vp_modern_avq_deactivate(vdev);
+
 	/* Flush pending VQ/configuration callbacks. */
 	vp_synchronize_vectors(vdev);
 }
@@ -404,8 +535,11 @@ static struct virtqueue *setup_vq(struct virtio_pci_device *vp_dev,
 		goto err;
 	}
 
-	if (is_avq)
+	if (is_avq) {
+		mutex_lock(&vp_dev->admin_vq.cmd_lock);
 		vp_dev->admin_vq.info.vq = vq;
+		mutex_unlock(&vp_dev->admin_vq.cmd_lock);
+	}
 
 	return vq;
 
@@ -442,8 +576,11 @@ static void del_vq(struct virtio_pci_vq_info *info)
 	struct virtio_pci_device *vp_dev = to_vp_device(vq->vdev);
 	struct virtio_pci_modern_device *mdev = &vp_dev->mdev;
 
-	if (vp_is_avq(&vp_dev->vdev, vq->index))
+	if (vp_is_avq(&vp_dev->vdev, vq->index)) {
+		mutex_lock(&vp_dev->admin_vq.cmd_lock);
 		vp_dev->admin_vq.info.vq = NULL;
+		mutex_unlock(&vp_dev->admin_vq.cmd_lock);
+	}
 
 	if (vp_dev->msix_enabled)
 		vp_modern_queue_vector(mdev, vq->index,
@@ -662,6 +799,7 @@ int virtio_pci_modern_probe(struct virtio_pci_device *vp_dev)
 	vp_dev->isr = mdev->isr;
 	vp_dev->vdev.id = mdev->id;
 
+	mutex_init(&vp_dev->admin_vq.cmd_lock);
 	return 0;
 }
 
@@ -669,5 +807,6 @@ void virtio_pci_modern_remove(struct virtio_pci_device *vp_dev)
 {
 	struct virtio_pci_modern_device *mdev = &vp_dev->mdev;
 
+	mutex_destroy(&vp_dev->admin_vq.cmd_lock);
 	vp_modern_remove(mdev);
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
index d50f080cf621..5ef12a877d6a 100644
--- a/include/uapi/linux/virtio_pci.h
+++ b/include/uapi/linux/virtio_pci.h
@@ -209,4 +209,26 @@ struct virtio_pci_cfg_cap {
 
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


