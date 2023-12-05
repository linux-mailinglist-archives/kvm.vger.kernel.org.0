Return-Path: <kvm+bounces-3603-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id BC831805AC3
	for <lists+kvm@lfdr.de>; Tue,  5 Dec 2023 18:07:54 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 6CA6128256F
	for <lists+kvm@lfdr.de>; Tue,  5 Dec 2023 17:07:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BAC7B6929F;
	Tue,  5 Dec 2023 17:07:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="fnP2/fC8"
X-Original-To: kvm@vger.kernel.org
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2066.outbound.protection.outlook.com [40.107.93.66])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E27FBA1
	for <kvm@vger.kernel.org>; Tue,  5 Dec 2023 09:07:38 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=P2LUmEl6ScRaJ5gaEqnY5kJVZfecP+hEU1J8VUbXZv4grNVlhn3lHmuiEkOxM57VZlg9uDcYvslarDGHKjKfMjnVo5D7oC91VuTDd/Vw/ZMeCX1QF3DUe5kt5sMUiBjCPzlaSwKHaPod0SpoxXDs0dMfIbJTXmFf84RZH+WCIv0ISan3pc77cOc719TUxHfp6E59eHrggfybbBiLrqcQh5+OaIpxdZOu6VK1Z6Q+/0Pj3Zl7R9uWIyo1vi39f0yBvcM4ssHpLBpSkAp+PJDC/PfC/pc2opFtWydjqUG1LgKeM3nSnuRhGRYaMZPsAeVNHR58FpIBeiM0z+Sodc9Ufw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=szqSpjH8gveSqBHOKS7GHJvcjlJTjHrh3TblVtqYI7o=;
 b=jX24Qmg+V1bCqI6g6v6FgGv9+VYghz3mrMFo+QdKgjSYq+KnxMm5OXnSO82JX6xzMmgKQfYz210HCCxIE1cASmXdQVapNUMpb97SPeMudfeyAVTSvkmCXxiVbMP86FvIZztZSXKz+ncQl+kCf2gp/9GgvN/LhzKhALMkfZwzqKn2mD3WUWs21CxCQWHpzCNG9WfR5goZWKu0eyQTpu+iROaPmXDeBq6P83ffqW/2xjASTvmcvTtPEb8JdtYaiZo2RwRkL1AniNV6B1HQqB1yMs2M+ldGs1C3+qHZlcz1dUZci7q0xgAOFRinOAk75puEAFG437aBApPkfp1EXNx/zQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=redhat.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=szqSpjH8gveSqBHOKS7GHJvcjlJTjHrh3TblVtqYI7o=;
 b=fnP2/fC81ggoyAyBkE4NuYjUa9iQrPgU3+/3w4RMS0QnlXa8FJOxvKUlvI17LLWivGqmrrzQPRsu2fFqIdcKpftupl6twCaDq5757e0n1K6IgOyp7McJg4vXFEVleCBx8q/Ei0H1gNhmNHhBhTfqQVzd12nOMw37hpJ+4g4EfotR1egsYa/rUK1J0Kng3X4+zkBhP0+XZuPp1rfCekbsf3CJLY3ooEuZOBzUAtwZp32aLbYzx/Io95tsRjwq6NcvC7kDPFo+piptVUNGYCqaaLuJ36l3KL1tIVsOMNpv0VfTyJHFNZhofe324hjI0mB+naWr9fIW5Yd18czBhgb5Lw==
Received: from SJ0PR05CA0034.namprd05.prod.outlook.com (2603:10b6:a03:33f::9)
 by MW4PR12MB7237.namprd12.prod.outlook.com (2603:10b6:303:22a::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7046.34; Tue, 5 Dec
 2023 17:07:33 +0000
Received: from MWH0EPF000989E7.namprd02.prod.outlook.com
 (2603:10b6:a03:33f:cafe::c0) by SJ0PR05CA0034.outlook.office365.com
 (2603:10b6:a03:33f::9) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7068.24 via Frontend
 Transport; Tue, 5 Dec 2023 17:07:33 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.161)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 MWH0EPF000989E7.mail.protection.outlook.com (10.167.241.134) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.7068.20 via Frontend Transport; Tue, 5 Dec 2023 17:07:33 +0000
Received: from rnnvmail203.nvidia.com (10.129.68.9) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.41; Tue, 5 Dec 2023
 09:07:11 -0800
Received: from rnnvmail202.nvidia.com (10.129.68.7) by rnnvmail203.nvidia.com
 (10.129.68.9) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.41; Tue, 5 Dec 2023
 09:07:11 -0800
Received: from vdi.nvidia.com (10.127.8.10) by mail.nvidia.com (10.129.68.7)
 with Microsoft SMTP Server id 15.2.986.41 via Frontend Transport; Tue, 5 Dec
 2023 09:07:07 -0800
From: Yishai Hadas <yishaih@nvidia.com>
To: <alex.williamson@redhat.com>, <mst@redhat.com>, <jasowang@redhat.com>,
	<jgg@nvidia.com>
CC: <kvm@vger.kernel.org>, <virtualization@lists.linux-foundation.org>,
	<parav@nvidia.com>, <feliu@nvidia.com>, <jiri@nvidia.com>,
	<kevin.tian@intel.com>, <joao.m.martins@oracle.com>, <si-wei.liu@oracle.com>,
	<leonro@nvidia.com>, <yishaih@nvidia.com>, <maorg@nvidia.com>
Subject: [PATCH V5 vfio 4/9] virtio-pci: Introduce admin commands
Date: Tue, 5 Dec 2023 19:06:18 +0200
Message-ID: <20231205170623.197877-5-yishaih@nvidia.com>
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
X-MS-TrafficTypeDiagnostic: MWH0EPF000989E7:EE_|MW4PR12MB7237:EE_
X-MS-Office365-Filtering-Correlation-Id: be564066-1d0d-4d10-1cbf-08dbf5b4ac09
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	2HOcdPmHtySu5pUK4p9gNCwdB8rtScDS2qFsYW2bUCnrJ0OWX47A7r78iDPX/wGrWgpfUz8j+3qQYqqVkuJrfnCs0yxdxdJsqa7Vodpfr9jhX1cgwasCm7UC3yyeOPAe4wISolM/g+AipR1dgM9fWLBKDfxe+rxThe0OuSng9kXTztieeldIx59bgS2FjOE5e6NlANYmE8dPW2o/VBJwL1YUVX9CSPMz21Gu+WLvzPrrNmyO8FOaYnQE1W78f2Xt2YfU63ubbhSyhxgShbZw/b+eCHGsFV0oGZCRDwmkh9Pq9vopb63WDzaRp0H2FehPoJs0oIakBmAWiEPvUyC1DQNKQewYV/JlkS1+shgusvIJZuBTyciU0Z3YuYjqZQdcEVegonES13TvUOw5WlGaqfh3KPd7XMPc571J8/CAiMAzGNybPXywPTi+VVq3tTJgbIHayCKncnR5Zwl2VRr/Ywf0qf2Jz4/t5yzW2VHBQUD/vpkCK7EoSgjS6M9ZKYgf6CNLTQI1tiiS/D0wRcg7cu/xqey5X+kmJmxkmbzOALGJeZ0rD9eWj2fY4+bPoot5SmMzD/bd6K/NXRvUU8Qrtt5Jrj69O0xTv+3lHolOwVKNMoulivFRQhhS5SSu8iiO9vlsDffZAEM+zVIn4SVwByY5AyNlFXHI7a7N845uQnulaBS3GKfbqLwto3SiX8bUQ8CZ4biJSbuA5bcTE74ho2dGguVXFpFocH6m3feVf27BuLlMtTIymGY/tZa43rZY
X-Forefront-Antispam-Report:
	CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230031)(4636009)(346002)(136003)(376002)(39860400002)(396003)(230922051799003)(82310400011)(1800799012)(451199024)(186009)(64100799003)(36840700001)(46966006)(40470700004)(40480700001)(40460700003)(478600001)(7696005)(8936002)(107886003)(2616005)(6666004)(47076005)(1076003)(26005)(4326008)(6636002)(426003)(336012)(110136005)(54906003)(70206006)(70586007)(316002)(8676002)(83380400001)(82740400003)(2906002)(36756003)(7636003)(356005)(5660300002)(86362001)(41300700001)(36860700001)(2101003);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Dec 2023 17:07:33.0691
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: be564066-1d0d-4d10-1cbf-08dbf5b4ac09
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	MWH0EPF000989E7.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR12MB7237

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
Acked-by: Michael S. Tsirkin <mst@redhat.com>
Signed-off-by: Yishai Hadas <yishaih@nvidia.com>
---
 include/uapi/linux/virtio_pci.h | 41 +++++++++++++++++++++++++++++++++
 1 file changed, 41 insertions(+)

diff --git a/include/uapi/linux/virtio_pci.h b/include/uapi/linux/virtio_pci.h
index 187fd9e34a30..ef3810dee7ef 100644
--- a/include/uapi/linux/virtio_pci.h
+++ b/include/uapi/linux/virtio_pci.h
@@ -226,6 +226,20 @@ struct virtio_pci_cfg_cap {
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
 struct __packed virtio_admin_cmd_hdr {
 	__le16 opcode;
 	/*
@@ -245,4 +259,31 @@ struct __packed virtio_admin_cmd_status {
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


