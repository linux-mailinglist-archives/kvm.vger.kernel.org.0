Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B8F7F7CC4FC
	for <lists+kvm@lfdr.de>; Tue, 17 Oct 2023 15:43:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343949AbjJQNn0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 17 Oct 2023 09:43:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34270 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343839AbjJQNnY (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 17 Oct 2023 09:43:24 -0400
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2082.outbound.protection.outlook.com [40.107.93.82])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9ED20F0
        for <kvm@vger.kernel.org>; Tue, 17 Oct 2023 06:43:22 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=aRsUzWxoR8cuAwBB/uycR5Ig6g/YlRjFXGmnjH9Md/hzhoL+HQj4GowQnk+3KuKNM0dbEsPQkkNFELFg/MJBwOGZ9V6e/k279hN+hitMl0/J3fJ6502rjOTyDQs5uvsb30tp5JPg+SvYpg0VtPIATnD8VKC3dqq1/035UP85nu2Vh3QA4dqjXghI/nHX1zEqGYPSryfZ4WKXLzrJOI3i0F3bs2lOk4nMiZ/RxEU/tdVBpKQBtnKA6318VOGFwYIFtFOX2g+efHqppULMuLtRBFn4heZhRJ4QfvTCM/pUHAXzmCUDBI8U1fXS8j4kvDZSXLoYwSOadwLhZQ5AXz4o7g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=EQgtRhF9nwY4OCM4TqXlToBYKLhPSI0T2PByC8kLY30=;
 b=CJPFZZDcJ3Jd1VcN/DDkXenB9GXON3pm8s/IXoLymZMLgVMw2KWTZZ5OR5WzErqA/3U9CSVuuLUbdTDU1fpqu6PIdNvQISI5yWMdwCZG2mPWZPsd87QNSqfrtf635S8eWULO6qkzjNao9I+LBuF0TUZ4sDvjLoW26YwuUTx1KIkpgor8ch3HM6TadXiZpGx4eCAqpsqkDvQhpmtfuDXv55qVdfiqN4o8KOXXA1fSRZ/fG/iitQThgbdyx3M7Qo4r/5jON7Rkus61FGyij7TkmTF3Ge0QHQLDj4iT5m31ayJgqsxw0G5gr34yB9L7PdWTJU2aaLEPoQ1i2ju306Rz2Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=redhat.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=EQgtRhF9nwY4OCM4TqXlToBYKLhPSI0T2PByC8kLY30=;
 b=lIot3yfkWg6J99dOJCkO+p7v4A9u6DFusD6sQaRyXzrwdhBst5MJKbfjY/YKXXVxZVBUO8OtptseypUDXRT8jCL4AB0KAu1BahsmOx98OYxWaa+1Pb8gLjgLOM3NLVSLJUFn+IkLJvflukFhraXk/8JSdrAo3EP7Cvgdf6EZa3jJ9TjMGhbpAu1rPhojnMKX0NkERg2DZFY/KiCtW3w86/rvzksQZYeJKCpqAWn0PaypdiG02UgQ1rg9FS6WThHQwUgeRfyq3CtfUiTm+gDpi746TzkFYkqzxck0GeZjaxg6nOuGBi93x6ywwwsp8T7tAEwO5QEg8XtDoqVgtKFTcQ==
Received: from BN9PR03CA0725.namprd03.prod.outlook.com (2603:10b6:408:110::10)
 by MW3PR12MB4571.namprd12.prod.outlook.com (2603:10b6:303:5c::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6886.35; Tue, 17 Oct
 2023 13:43:20 +0000
Received: from SA2PEPF00001507.namprd04.prod.outlook.com
 (2603:10b6:408:110:cafe::65) by BN9PR03CA0725.outlook.office365.com
 (2603:10b6:408:110::10) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6886.36 via Frontend
 Transport; Tue, 17 Oct 2023 13:43:20 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.160)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 SA2PEPF00001507.mail.protection.outlook.com (10.167.242.39) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6907.20 via Frontend Transport; Tue, 17 Oct 2023 13:43:19 +0000
Received: from rnnvmail205.nvidia.com (10.129.68.10) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.41; Tue, 17 Oct
 2023 06:43:02 -0700
Received: from rnnvmail205.nvidia.com (10.129.68.10) by rnnvmail205.nvidia.com
 (10.129.68.10) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.41; Tue, 17 Oct
 2023 06:43:02 -0700
Received: from vdi.nvidia.com (10.127.8.10) by mail.nvidia.com (10.129.68.10)
 with Microsoft SMTP Server id 15.2.986.41 via Frontend Transport; Tue, 17 Oct
 2023 06:42:58 -0700
From:   Yishai Hadas <yishaih@nvidia.com>
To:     <alex.williamson@redhat.com>, <mst@redhat.com>,
        <jasowang@redhat.com>, <jgg@nvidia.com>
CC:     <kvm@vger.kernel.org>, <virtualization@lists.linux-foundation.org>,
        <parav@nvidia.com>, <feliu@nvidia.com>, <jiri@nvidia.com>,
        <kevin.tian@intel.com>, <joao.m.martins@oracle.com>,
        <si-wei.liu@oracle.com>, <leonro@nvidia.com>, <yishaih@nvidia.com>,
        <maorg@nvidia.com>
Subject: [PATCH V1 vfio 5/9] virtio-pci: Introduce admin commands
Date:   Tue, 17 Oct 2023 16:42:13 +0300
Message-ID: <20231017134217.82497-6-yishaih@nvidia.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20231017134217.82497-1-yishaih@nvidia.com>
References: <20231017134217.82497-1-yishaih@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-NV-OnPremToCloud: ExternallySecured
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA2PEPF00001507:EE_|MW3PR12MB4571:EE_
X-MS-Office365-Filtering-Correlation-Id: dfb71b83-c02e-4f42-d35b-08dbcf170650
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: raWoEgi5i7RF6GWIoeeiHtFBY68srW/RS7tMzEeSXund998Yx+FhhY3z4DTL2cNqnXmy+oyEBqddVh/IyF73a9peMPW4FFv6sA8TnDJesFI3gt8ZrVXYmZyBjKeyEkY0AdaakXwriFMiS7TPY0lLY7ULp+b0P1jp8wR3Hz+PrjcnakoZuosBuN0TMJ6JTfStYUgjyzB3IJFneUi3FI1aE7b67hjReahWbLYsmrJgQY847LIenuIQNEBKWnSos2Nf1IMK27uBbDoJe3+K06ElqWua4zSIsfhVabToPp+X0nAbg52CbhqOrrSu0WPb0xTkxcrD7K82JKc/NaMFXhDV+/IgsOWpDxCT79bECcB8lQ0VHCpR147rh6ziYgozRRcxKdcvhp8ExdOJK3UIE3YqVDZzld44S/JJOUyYHqxweSrczS2c25bc3k0xld6JEmbLhOD9zhjNOgrKiI8h2mbaEP+CIImbJGnFR6Y5ZjHNu3djo1FPK4xmgZC1PVwmiGhahEd2vlD/jTTbFu4zeiMPJqNvQPzplJ0TNDhJLG2Zu62kQFB4XKyPRKR/R6m4i8KWsUZJU7eDl28SX5qYSd2i8c7QoC0e9QIWRMNH2gMBFyw7e3N+oiOgjBgfl1PporqXeNsnb+8A6/OFF0kqkQUmW3IeoQl2ZfkVP7tn+ohjz66MVfcdmuSuvRKe7eLmscfyLdNGUtgOxS9otY5R1LKuRVP5XH3VCJgG3dqVbL09L11c453YhbluL6D3lpBzxkg9
X-Forefront-Antispam-Report: CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230031)(4636009)(136003)(376002)(39860400002)(346002)(396003)(230922051799003)(451199024)(186009)(82310400011)(64100799003)(1800799009)(40470700004)(36840700001)(46966006)(7696005)(316002)(40460700003)(40480700001)(478600001)(70206006)(110136005)(70586007)(6666004)(54906003)(6636002)(356005)(83380400001)(47076005)(36860700001)(82740400003)(86362001)(336012)(2616005)(107886003)(26005)(1076003)(41300700001)(426003)(5660300002)(36756003)(7636003)(8936002)(4326008)(2906002)(8676002)(2101003);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Oct 2023 13:43:19.8808
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: dfb71b83-c02e-4f42-d35b-08dbcf170650
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: SA2PEPF00001507.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW3PR12MB4571
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

Introduces admin commands, as follow:

The "list query" command can be used by the driver to query the
set of admin commands supported by the virtio device.
The "list use" command is used to inform the virtio device which
admin commands the driver will use.
The "legacy common cfg rd/wr" commands are used to read from/write
into the legacy common configuration structure.
The "legacy dev cfg rd/wr" commands are used to read from/write
into the legacy device configuration structure.
The "notify info" command is used to query the notification region
information.

Signed-off-by: Feng Liu <feliu@nvidia.com>
Reviewed-by: Parav Pandit <parav@nvidia.com>
Reviewed-by: Jiri Pirko <jiri@nvidia.com>
Signed-off-by: Yishai Hadas <yishaih@nvidia.com>
---
 include/uapi/linux/virtio_pci.h | 44 +++++++++++++++++++++++++++++++++
 1 file changed, 44 insertions(+)

diff --git a/include/uapi/linux/virtio_pci.h b/include/uapi/linux/virtio_pci.h
index 68eacc9676dc..6e42c211fc08 100644
--- a/include/uapi/linux/virtio_pci.h
+++ b/include/uapi/linux/virtio_pci.h
@@ -210,6 +210,23 @@ struct virtio_pci_cfg_cap {
 /* Admin command status. */
 #define VIRTIO_ADMIN_STATUS_OK		0
 
+/* Admin command opcode. */
+#define VIRTIO_ADMIN_CMD_LIST_QUERY	0x0
+#define VIRTIO_ADMIN_CMD_LIST_USE	0x1
+
+/* Admin command group type. */
+#define VIRTIO_ADMIN_GROUP_TYPE_SRIOV	0x1
+
+/* Transitional device admin command. */
+#define VIRTIO_ADMIN_CMD_LEGACY_COMMON_CFG_WRITE	0x2
+#define VIRTIO_ADMIN_CMD_LEGACY_COMMON_CFG_READ		0x3
+#define VIRTIO_ADMIN_CMD_LEGACY_DEV_CFG_WRITE		0x4
+#define VIRTIO_ADMIN_CMD_LEGACY_DEV_CFG_READ		0x5
+#define VIRTIO_ADMIN_CMD_LEGACY_NOTIFY_INFO		0x6
+
+/* Increment MAX_OPCODE to next value when new opcode is added */
+#define VIRTIO_ADMIN_MAX_CMD_OPCODE			0x6
+
 struct __packed virtio_admin_cmd_hdr {
 	__le16 opcode;
 	/*
@@ -229,4 +246,31 @@ struct __packed virtio_admin_cmd_status {
 	__u8 reserved2[4];
 };
 
+struct __packed virtio_admin_cmd_legacy_wr_data {
+	__u8 offset; /* Starting offset of the register(s) to write. */
+	__u8 reserved[7];
+	__u8 registers[];
+};
+
+struct __packed virtio_admin_cmd_legacy_rd_data {
+	__u8 offset; /* Starting offset of the register(s) to read. */
+};
+
+#define VIRTIO_ADMIN_CMD_NOTIFY_INFO_FLAGS_END 0
+#define VIRTIO_ADMIN_CMD_NOTIFY_INFO_FLAGS_OWNER_DEV 0x1
+#define VIRTIO_ADMIN_CMD_NOTIFY_INFO_FLAGS_OWNER_MEM 0x2
+
+#define VIRTIO_ADMIN_CMD_MAX_NOTIFY_INFO 4
+
+struct __packed virtio_admin_cmd_notify_info_data {
+	__u8 flags; /* 0 = end of list, 1 = owner device, 2 = member device */
+	__u8 bar; /* BAR of the member or the owner device */
+	__u8 padding[6];
+	__le64 offset; /* Offset within bar. */
+};
+
+struct virtio_admin_cmd_notify_info_result {
+	struct virtio_admin_cmd_notify_info_data entries[VIRTIO_ADMIN_CMD_MAX_NOTIFY_INFO];
+};
+
 #endif
-- 
2.27.0

