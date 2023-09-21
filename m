Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 555517A97B1
	for <lists+kvm@lfdr.de>; Thu, 21 Sep 2023 19:27:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229603AbjIUR1H (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 21 Sep 2023 13:27:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54970 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229901AbjIUR0r (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 21 Sep 2023 13:26:47 -0400
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on20626.outbound.protection.outlook.com [IPv6:2a01:111:f400:fe59::626])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9B4551FE7
        for <kvm@vger.kernel.org>; Thu, 21 Sep 2023 10:01:11 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=cLEezKFixK5Br/JxQwlfxDQHi3991kA6X9ngB463NfN/tmqL3VoZc8DGtbpHVwclksXEPtcZ6LQAjAWWuHxt2eMxiYW/lec1Mz7QPRKnsAaX4CaXrUYYpDUJKSW4p8vPEa8Rx8PA4LZ8k2G+ma/eIikDZvRe7bYE5biCO/pNX5XRS9dRto695ssigT5RY55OMuymQlcBchY8TJw6Kad4QwmujHlCVziVmWxQ+YpGA3dvvHpuPzocfVfnKrCGKwwWOS9fgXvO3FmrlZPdH5Qhl8fjpYIMxz4aJLPNmh+auLdvLhEoQsH1zkGMdoZQYQgPLRmLmpXbPcvQZR4pjQACog==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=vs0v/NljeSeqjShQU8l7ntCvJ7v12eFf8Z064gNRmlU=;
 b=kaZXwxchqlU3B5xSY8O1yytuLZwkqSDPQ/gVqG+isH6ReCao4TbkjAcgqCDWgYMPoiCYQoGcZh+Fy84vJmueb6gwIbTlVzbxgbSrwExl0EXOcjT7DLV6UNL/VAbAk6WQbalvEKI0rqkJppCRB89LouelnTxyN2gGf68XZF6+8Q9bCHT7WoT1aIv3s2wvpBUd0k/twZ9IWCDp36GBkkNGmp/WJcUs+nuWCX0kEPLyhPYCPLgE/fwn4vnsA2fn7t6FjmXxV5VUo98k5XujLu4X8tR+eFLVVTI4LonJBoTi6ZL5fFVDa+jI8agCggKne19ALC2mBKSXcV5aBvLECE6nBg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=redhat.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vs0v/NljeSeqjShQU8l7ntCvJ7v12eFf8Z064gNRmlU=;
 b=hKIuaWmJ61Qsr+dMRITkT7Lj4dxOmKkU07GPyO/5eaYgLf3ey2ss4IostbQ9fhY84R4a0xW/2QdpKT9Cmph3a1XX1PLiM6olECQ+qu0YILPyUi7JTzR0jQJdzOwl5rAy5yrvmLDV53cdE7qz2XuaOmaev771beqH3QJ+cfkzfIJhVokWCp3zUg1nhhyGKHpjHBmljkyKCq0zFa+UurKAZcYN/yxxw7GYSt0Ga+66i3dw8wAhHzclG0+bhmz74+oG0ESf9pCkGxu3mO48srJ2TLigBYUw75QpkpKNZdjowmHJf8rAelx7Sx0DgruA/NReMiFxUQ8WYS/lq7XzuqkvCw==
Received: from DM6PR02CA0132.namprd02.prod.outlook.com (2603:10b6:5:1b4::34)
 by PH8PR12MB7325.namprd12.prod.outlook.com (2603:10b6:510:217::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6792.28; Thu, 21 Sep
 2023 12:41:53 +0000
Received: from DS1PEPF00017090.namprd03.prod.outlook.com
 (2603:10b6:5:1b4:cafe::ce) by DM6PR02CA0132.outlook.office365.com
 (2603:10b6:5:1b4::34) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6792.31 via Frontend
 Transport; Thu, 21 Sep 2023 12:41:52 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.160)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 DS1PEPF00017090.mail.protection.outlook.com (10.167.17.132) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6792.20 via Frontend Transport; Thu, 21 Sep 2023 12:41:52 +0000
Received: from rnnvmail203.nvidia.com (10.129.68.9) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.41; Thu, 21 Sep
 2023 05:41:43 -0700
Received: from rnnvmail204.nvidia.com (10.129.68.6) by rnnvmail203.nvidia.com
 (10.129.68.9) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.41; Thu, 21 Sep
 2023 05:41:42 -0700
Received: from vdi.nvidia.com (10.127.8.10) by mail.nvidia.com (10.129.68.6)
 with Microsoft SMTP Server id 15.2.986.41 via Frontend Transport; Thu, 21 Sep
 2023 05:41:39 -0700
From:   Yishai Hadas <yishaih@nvidia.com>
To:     <alex.williamson@redhat.com>, <mst@redhat.com>,
        <jasowang@redhat.com>, <jgg@nvidia.com>
CC:     <kvm@vger.kernel.org>, <virtualization@lists.linux-foundation.org>,
        <parav@nvidia.com>, <feliu@nvidia.com>, <jiri@nvidia.com>,
        <kevin.tian@intel.com>, <joao.m.martins@oracle.com>,
        <leonro@nvidia.com>, <yishaih@nvidia.com>, <maorg@nvidia.com>
Subject: [PATCH vfio 05/11] virtio-pci: Introduce admin command sending function
Date:   Thu, 21 Sep 2023 15:40:34 +0300
Message-ID: <20230921124040.145386-6-yishaih@nvidia.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20230921124040.145386-1-yishaih@nvidia.com>
References: <20230921124040.145386-1-yishaih@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-NV-OnPremToCloud: ExternallySecured
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS1PEPF00017090:EE_|PH8PR12MB7325:EE_
X-MS-Office365-Filtering-Correlation-Id: 058fab27-fb7f-4339-ca9d-08dbbaa021ce
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: kLOfhF6rek/57gYUa/oZzlxT8dXMIGIU3BXGxPiIc6GEsjV791lne1gUfWFdZZT5SP5zKNCSgU8qDF8ZjiA36FO5OUj+L3J2MvrPTPtWgcdpDS8mYPBhO9JHbrFxD4TiShN577y7DFvH4dMG/CEGYh/QG0EtLfIkjFy1oKKdOClL0UUurSdV1Q83lwjU2zSan+glmxK2NriTpJK68bEUhoX4IT9bQ9mET4eMX8GdPLXIFPqwShf+bre+qw2GZftulJ8Ytt37TxtNib1fX6/2m29m7F5lhwFLlPrUBzCVi0zNi0YDWH4zIkgwJZFiD8t6tkNqWZrK5v03SkFoCaWVD5vRRrEWh+eONUvm2WH+9/tRPCCWlurMP1v5X0kYAIJdWp5Zw+Tlhjm2jH34ZZRDxgP1PkLq9v6islUJmo1TR8FEotN8fhaKGYIPxgPuT20HVx28gEn3XP3/O5P1q+ecBoA91g1baz9KWl42NkqXXJLRrfxR1dbGRxnGBBVA1TgZVrp7lYDYD50rLtGA/WRIqGl4LKfkKVOR+SqyYP/yWr4OHbuctEwPaW8FBZVhRkKfJuuef6hyx0C1IYZThWnpynBH1G1t1I05BI7sFgI9K/GqwFGzDW/aqSgqpH1JEyB/n2jUKq7CFF93wIdW3Kc4IKZuq9MgLD9ebxKlypn4SmsrLnGViyIpZD/nddmZFtnQw8UdaN1n99enu9CaMBJMNL6Kh8lzt0v4HGKIlgrQMgnTsY5cv0YgNJHgRyxTCGU/ML+b2pIcu9Ji9kVaRGLmZQ==
X-Forefront-Antispam-Report: CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230031)(4636009)(136003)(39860400002)(346002)(396003)(376002)(451199024)(1800799009)(186009)(82310400011)(36840700001)(46966006)(40470700004)(36756003)(40460700003)(83380400001)(8676002)(40480700001)(36860700001)(26005)(86362001)(356005)(4326008)(8936002)(41300700001)(336012)(7636003)(107886003)(426003)(1076003)(82740400003)(2616005)(7696005)(6666004)(47076005)(5660300002)(2906002)(70586007)(70206006)(316002)(54906003)(6636002)(110136005)(478600001)(2101003);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Sep 2023 12:41:52.6385
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 058fab27-fb7f-4339-ca9d-08dbbaa021ce
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DS1PEPF00017090.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH8PR12MB7325
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_PASS,SPF_NONE,URIBL_BLOCKED
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Feng Liu <feliu@nvidia.com>

Add support for sending admin command through admin virtqueue interface,
and expose generic API to execute virtio admin command. Reuse the send
synchronous command helper function at virtio transport layer. In
addition, add new result state of admin command and admin commands range
definitions.

Signed-off-by: Feng Liu <feliu@nvidia.com>
Reviewed-by: Parav Pandit <parav@nvidia.com>
Reviewed-by: Jiri Pirko <jiri@nvidia.com>
Signed-off-by: Yishai Hadas <yishaih@nvidia.com>
---
 drivers/virtio/virtio.c                |  7 +++
 drivers/virtio/virtio_pci_common.h     |  1 +
 drivers/virtio/virtio_pci_modern.c     |  2 +
 drivers/virtio/virtio_pci_modern_avq.c | 73 ++++++++++++++++++++++++++
 include/linux/virtio.h                 | 11 ++++
 include/linux/virtio_config.h          |  3 ++
 include/uapi/linux/virtio_pci.h        | 22 ++++++++
 7 files changed, 119 insertions(+)

diff --git a/drivers/virtio/virtio.c b/drivers/virtio/virtio.c
index f4080692b351..dd71f584a1bd 100644
--- a/drivers/virtio/virtio.c
+++ b/drivers/virtio/virtio.c
@@ -582,6 +582,13 @@ int virtio_device_restore(struct virtio_device *dev)
 EXPORT_SYMBOL_GPL(virtio_device_restore);
 #endif
 
+int virtio_admin_cmd_exec(struct virtio_device *vdev,
+			  struct virtio_admin_cmd *cmd)
+{
+	return vdev->config->exec_admin_cmd(vdev, cmd);
+}
+EXPORT_SYMBOL_GPL(virtio_admin_cmd_exec);
+
 static int virtio_init(void)
 {
 	if (bus_register(&virtio_bus) != 0)
diff --git a/drivers/virtio/virtio_pci_common.h b/drivers/virtio/virtio_pci_common.h
index 9bffa95274b6..a579f1338263 100644
--- a/drivers/virtio/virtio_pci_common.h
+++ b/drivers/virtio/virtio_pci_common.h
@@ -128,6 +128,7 @@ int vp_find_vqs(struct virtio_device *vdev, unsigned int nvqs,
 const char *vp_bus_name(struct virtio_device *vdev);
 void vp_destroy_avq(struct virtio_device *vdev);
 int vp_create_avq(struct virtio_device *vdev);
+int vp_avq_cmd_exec(struct virtio_device *vdev, struct virtio_admin_cmd *cmd);
 
 /* Setup the affinity for a virtqueue:
  * - force the affinity for per vq vector
diff --git a/drivers/virtio/virtio_pci_modern.c b/drivers/virtio/virtio_pci_modern.c
index a72c87687196..cac18872b088 100644
--- a/drivers/virtio/virtio_pci_modern.c
+++ b/drivers/virtio/virtio_pci_modern.c
@@ -515,6 +515,7 @@ static const struct virtio_config_ops virtio_pci_config_nodev_ops = {
 	.enable_vq_after_reset = vp_modern_enable_vq_after_reset,
 	.create_avq = vp_create_avq,
 	.destroy_avq = vp_destroy_avq,
+	.exec_admin_cmd = vp_avq_cmd_exec,
 };
 
 static const struct virtio_config_ops virtio_pci_config_ops = {
@@ -537,6 +538,7 @@ static const struct virtio_config_ops virtio_pci_config_ops = {
 	.enable_vq_after_reset = vp_modern_enable_vq_after_reset,
 	.create_avq = vp_create_avq,
 	.destroy_avq = vp_destroy_avq,
+	.exec_admin_cmd = vp_avq_cmd_exec,
 };
 
 /* the PCI probing function */
diff --git a/drivers/virtio/virtio_pci_modern_avq.c b/drivers/virtio/virtio_pci_modern_avq.c
index 114579ad788f..ca3fe10f616d 100644
--- a/drivers/virtio/virtio_pci_modern_avq.c
+++ b/drivers/virtio/virtio_pci_modern_avq.c
@@ -19,6 +19,79 @@ static u16 vp_modern_avq_index(struct virtio_pci_modern_device *mdev)
 	return vp_ioread16(&cfg->admin_queue_index);
 }
 
+#define VIRTIO_AVQ_SGS_MAX	4
+
+int vp_avq_cmd_exec(struct virtio_device *vdev, struct virtio_admin_cmd *cmd)
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
+	avq = vp_dev->admin ? vp_dev->admin->info.vq : NULL;
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
+	ret = virtqueue_exec_cmd(avq, sgs, out_num, in_num, sgs, GFP_KERNEL);
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
 int vp_create_avq(struct virtio_device *vdev)
 {
 	struct virtio_pci_device *vp_dev = to_vp_device(vdev);
diff --git a/include/linux/virtio.h b/include/linux/virtio.h
index 9d39706bed10..094a2ef1c8b8 100644
--- a/include/linux/virtio.h
+++ b/include/linux/virtio.h
@@ -110,6 +110,14 @@ int virtqueue_exec_cmd(struct virtqueue *vq,
 		       void *data,
 		       gfp_t gfp);
 
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
@@ -207,6 +215,9 @@ static inline struct virtio_driver *drv_to_virtio(struct device_driver *drv)
 	return container_of(drv, struct virtio_driver, driver);
 }
 
+int virtio_admin_cmd_exec(struct virtio_device *vdev,
+			  struct virtio_admin_cmd *cmd);
+
 int register_virtio_driver(struct virtio_driver *drv);
 void unregister_virtio_driver(struct virtio_driver *drv);
 
diff --git a/include/linux/virtio_config.h b/include/linux/virtio_config.h
index 028c51ea90ee..e213173e1291 100644
--- a/include/linux/virtio_config.h
+++ b/include/linux/virtio_config.h
@@ -95,6 +95,7 @@ typedef void vq_callback_t(struct virtqueue *);
  *	set.
  * @create_avq: initialize admin virtqueue resource.
  * @destroy_avq: destroy admin virtqueue resource.
+ * @exec_admin_cmd: Send admin command and get result.
  */
 struct virtio_config_ops {
 	void (*get)(struct virtio_device *vdev, unsigned offset,
@@ -124,6 +125,8 @@ struct virtio_config_ops {
 	int (*enable_vq_after_reset)(struct virtqueue *vq);
 	int (*create_avq)(struct virtio_device *vdev);
 	void (*destroy_avq)(struct virtio_device *vdev);
+	int (*exec_admin_cmd)(struct virtio_device *vdev,
+			      struct virtio_admin_cmd *cmd);
 };
 
 /* If driver didn't advertise the feature, it will never appear. */
diff --git a/include/uapi/linux/virtio_pci.h b/include/uapi/linux/virtio_pci.h
index f703afc7ad31..1f1ac6ac07df 100644
--- a/include/uapi/linux/virtio_pci.h
+++ b/include/uapi/linux/virtio_pci.h
@@ -207,4 +207,26 @@ struct virtio_pci_cfg_cap {
 
 #endif /* VIRTIO_PCI_NO_MODERN */
 
+/* Admin command status. */
+#define VIRTIO_ADMIN_STATUS_OK		0
+
+struct virtio_admin_cmd_hdr {
+	__le16 opcode;
+	/*
+	 * 1 - SR-IOV
+	 * 2-65535 - reserved
+	 */
+	__le16 group_type;
+	/* Unused, reserved for future extensions. */
+	__u8 reserved1[12];
+	__le64 group_member_id;
+} __packed;
+
+struct virtio_admin_cmd_status {
+	__le16 status;
+	__le16 status_qualifier;
+	/* Unused, reserved for future extensions. */
+	__u8 reserved2[4];
+} __packed;
+
 #endif
-- 
2.27.0

