Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 491F07A9676
	for <lists+kvm@lfdr.de>; Thu, 21 Sep 2023 19:11:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229989AbjIURCW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 21 Sep 2023 13:02:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45138 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229869AbjIURCF (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 21 Sep 2023 13:02:05 -0400
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2061b.outbound.protection.outlook.com [IPv6:2a01:111:f400:7e89::61b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1DF00182
        for <kvm@vger.kernel.org>; Thu, 21 Sep 2023 10:01:06 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=l6EAL8IqdhZTB0L9Ci9Ku1TPfACxaDoNqRQvlbzwXoWZKjsa98OfdUmxhzxy8bUC4WrZ+O2DPHYroXOXJArL7zQaiOSqm1sS7RLGUB+TQxpReRUy15DZOLlU327YJufSykEM4PDP0SVfcZtOiLT48iOvia7yWP7TkbDOtXfyI3uCBWvWpSHC9xATUTbM/FGiQstvA9khAENL1cSM3+4z2MjNsr0VGJdO3Wmbw6C5w9gP1Sc/2nIh5yth1Jc2B+MJziuvO0Ft0beDWi+QWJdHFQw1rmAesVyiLE8nQ8xHwRdpfJZNzC7p67Cb1952f5HJlHWxXe5Ucdr6AnIxYRrBkw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=/S0ZFJNHbAruE1hYwcCiAQ+pYhNwNj5wHSYQXqHBcrk=;
 b=fu2FdjYMhBlHRiucm5n83e0IOCkh3/241oOm1j5iOLh8R5mb9AP5xqf6gLYnvgXIXtqCUG3NOiMukwTnPR8nfEafVmQsFn6b1tlkBW9lFHqqYYbPXlHYdUqnI0f9nDiL/tny1cG0keDkQdKkEQXtn4g/31KfGVRr3poSDh7wQvyALNmJCKzstGmTUW/pU30VzcGh+TqMzAuu/jv/zJgGsGeZ9tbDDHjZljXljIh7dx1ZUmMRYmLa2nFcIKwIWCS1n7R/EJ2MSLIXhEcKSmWSgBBXzYswVTPoM4q3ZPmEyz1+ShzDYaaUAayvI+mSJc8JS4tvOuxtyQyg1tUduAFIPA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=redhat.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/S0ZFJNHbAruE1hYwcCiAQ+pYhNwNj5wHSYQXqHBcrk=;
 b=R1qHNpWNQOwXMtSmbplvTAOPn5MKda1GCgjWwu55iQLTqeZpLvrj7Y5nHEe/zH87W5qMaiGeJAORNOcJOXUomW45Gmzz/ZKg/SWYm7yWdOmyCsOzxfbfj52qAZyEl++zBM4Hyf33FQIjUbGo3KTw4NNhu1N/mBjkabM9UFAaRvPr5JvY/pJ+yWucvfYwD2fGmhPRJvU/FnqldxAOowsTEcrTnjAhOMh0RuErklvaTkDXBpa1FLOW85yDnbQ89DvjRHna2jQ9AImD/qd2f/iIiTCoMPBe7zKEm41ehVSuHkl/tDvwyw4HoHm5MCNldZqd/6PWKG8jg9xBj3vJDHLRmA==
Received: from DM6PR02CA0128.namprd02.prod.outlook.com (2603:10b6:5:1b4::30)
 by BL1PR12MB5176.namprd12.prod.outlook.com (2603:10b6:208:311::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6792.28; Thu, 21 Sep
 2023 12:42:01 +0000
Received: from DS1PEPF00017090.namprd03.prod.outlook.com
 (2603:10b6:5:1b4:cafe::2d) by DM6PR02CA0128.outlook.office365.com
 (2603:10b6:5:1b4::30) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6792.31 via Frontend
 Transport; Thu, 21 Sep 2023 12:42:01 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.160)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 DS1PEPF00017090.mail.protection.outlook.com (10.167.17.132) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6792.20 via Frontend Transport; Thu, 21 Sep 2023 12:42:01 +0000
Received: from rnnvmail205.nvidia.com (10.129.68.10) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.41; Thu, 21 Sep
 2023 05:41:51 -0700
Received: from rnnvmail204.nvidia.com (10.129.68.6) by rnnvmail205.nvidia.com
 (10.129.68.10) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.41; Thu, 21 Sep
 2023 05:41:50 -0700
Received: from vdi.nvidia.com (10.127.8.10) by mail.nvidia.com (10.129.68.6)
 with Microsoft SMTP Server id 15.2.986.41 via Frontend Transport; Thu, 21 Sep
 2023 05:41:47 -0700
From:   Yishai Hadas <yishaih@nvidia.com>
To:     <alex.williamson@redhat.com>, <mst@redhat.com>,
        <jasowang@redhat.com>, <jgg@nvidia.com>
CC:     <kvm@vger.kernel.org>, <virtualization@lists.linux-foundation.org>,
        <parav@nvidia.com>, <feliu@nvidia.com>, <jiri@nvidia.com>,
        <kevin.tian@intel.com>, <joao.m.martins@oracle.com>,
        <leonro@nvidia.com>, <yishaih@nvidia.com>, <maorg@nvidia.com>
Subject: [PATCH vfio 07/11] virtio-pci: Introduce admin commands
Date:   Thu, 21 Sep 2023 15:40:36 +0300
Message-ID: <20230921124040.145386-8-yishaih@nvidia.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20230921124040.145386-1-yishaih@nvidia.com>
References: <20230921124040.145386-1-yishaih@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-NV-OnPremToCloud: ExternallySecured
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS1PEPF00017090:EE_|BL1PR12MB5176:EE_
X-MS-Office365-Filtering-Correlation-Id: e909e10b-5652-445d-c6bf-08dbbaa026df
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: s/f3GZJzflzutcOlycHFomKkrPLZg0yhFTue6vOLl6ypYN4wrLFKkd8YNizkatJ7oJgvIsB3KgdoyNBR48TheVaBWndwvoYvH9Gbpw1drMl6/5h7aZNq1Kc/KcNuhrqy9+Ns6LKxj1eyRx9XsGruVZ+wEyzJFPkUmTu+vi4QqAkReW3FOZDN1k2aA9roqhbydXGQ+my8c7zStJ4JYMtcG+3GPmPG3idxEf7w0CY2/AeV1db7XQ4WmTzbCdyozuTkdErRF2Pv6+eLY271jP4DkQeI8g9ZSIOm8UMtxY2QW2vp8EvtJSN/GSLyaXqlS6DadONqrz5qNdYUYr6PXbSmipRXYzsfrspQMdvhvjHZzD9MRi3oVnN+6atYNLxctvOPDIBhGojFFJWcBIsAKS2TTfcIhZp/aufnZuNTnAuCuiDjsgFQeMPVGj9txzDr1d1Q7rGk0opGIajyENwu9xNjNJzwl7oyl+Hui/itE54TTPlrITI6OUQZREsyYM0HkjyJcDI2Bouwv+tQAdy1/hc9gm/fzZDv3ynIVHyQLCsR7Ax1Rh9x2JiS6BYZLCn1IoSfEXiMNleR9CypNE25xf1O8etRoE5scaVd0/8VNN+pjGzBOsSWr2afp0jxtbkNncKPh3BH7ZRK+WSBk+jUlJDrVdA0ahnq61pnhqLJ1Hb0UoKAhFlCduvUyQhs7OJZdxP8nyZsIhwZNrJkWWFI+EFCOrEIYFuyt42uBqI1PR44e3UUmJPVk/6ngtqychDGag1FhosbnKhq8fOpEtCnHJhIVA==
X-Forefront-Antispam-Report: CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230031)(4636009)(136003)(376002)(39860400002)(396003)(346002)(82310400011)(186009)(1800799009)(451199024)(40470700004)(36840700001)(46966006)(6666004)(7696005)(36860700001)(82740400003)(86362001)(70586007)(70206006)(41300700001)(110136005)(54906003)(6636002)(316002)(478600001)(356005)(7636003)(107886003)(8676002)(8936002)(1076003)(4326008)(36756003)(40460700003)(26005)(47076005)(336012)(40480700001)(5660300002)(426003)(2616005)(83380400001)(2906002)(2101003);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Sep 2023 12:42:01.1384
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: e909e10b-5652-445d-c6bf-08dbbaa026df
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DS1PEPF00017090.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR12MB5176
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
index 1f1ac6ac07df..2bf275ad0f20 100644
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
 struct virtio_admin_cmd_hdr {
 	__le16 opcode;
 	/*
@@ -229,4 +246,31 @@ struct virtio_admin_cmd_status {
 	__u8 reserved2[4];
 } __packed;
 
+struct virtio_admin_cmd_legacy_wr_data {
+	u8 offset; /* Starting offset of the register(s) to write. */
+	u8 reserved[7];
+	u8 registers[];
+} __packed;
+
+struct virtio_admin_cmd_legacy_rd_data {
+	u8 offset; /* Starting offset of the register(s) to read. */
+} __packed;
+
+#define VIRTIO_ADMIN_CMD_NOTIFY_INFO_FLAGS_END 0
+#define VIRTIO_ADMIN_CMD_NOTIFY_INFO_FLAGS_OWNER_DEV 0x1
+#define VIRTIO_ADMIN_CMD_NOTIFY_INFO_FLAGS_OWNER_MEM 0x2
+
+#define VIRTIO_ADMIN_CMD_MAX_NOTIFY_INFO 4
+
+struct virtio_admin_cmd_notify_info_data {
+	u8 flags; /* 0 = end of list, 1 = owner device, 2 = member device */
+	u8 bar; /* BAR of the member or the owner device */
+	u8 padding[6];
+	__le64 offset; /* Offset within bar. */
+}; __packed
+
+struct virtio_admin_cmd_notify_info_result {
+	struct virtio_admin_cmd_notify_info_data entries[VIRTIO_ADMIN_CMD_MAX_NOTIFY_INFO];
+};
+
 #endif
-- 
2.27.0

