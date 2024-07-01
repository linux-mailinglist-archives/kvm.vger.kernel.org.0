Return-Path: <kvm+bounces-20811-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id E1D4491EAD7
	for <lists+kvm@lfdr.de>; Tue,  2 Jul 2024 00:34:28 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 45AA2B20F84
	for <lists+kvm@lfdr.de>; Mon,  1 Jul 2024 22:34:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 19549171662;
	Mon,  1 Jul 2024 22:34:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="MkmYvybQ"
X-Original-To: kvm@vger.kernel.org
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2058.outbound.protection.outlook.com [40.107.236.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BC96712C7FD;
	Mon,  1 Jul 2024 22:34:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.236.58
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719873258; cv=fail; b=gBhRHTlxMIDf4287jISuarxfIwQeIbs4EbTqwhjdWUxSdzcYfLn4ViKyGVh2IQX9dC11Rm5rXTZVXmxcFiJ5Sep+Ldn1VSZV+8g0i41GYaPCq2MDAy6olPCuxACHToMhTghtjieEtpjqvE5dmvNC2Sb9lYLC0W9Hbuxgoqg8F6M=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719873258; c=relaxed/simple;
	bh=vZFv3KZ6ihnKKNTwhHm2QXa7biBRbfN8WP/JwPgZV0I=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=kF4EURT590JlGig9cj5nq1yLbl9TZUyJ1ykhuggfbiWdB2DpgSN69c4Szax/Wj1H7VO3ianuq/PeZyoAV4tWc8qpwu3bQImEEH3fGJ111zfMQmNMy6ZTYuDRxS3e0FnyQ8kYYMtD5IfZWQvdqrvm2gfQHIeCr2+AOu02XKZt5b0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=MkmYvybQ; arc=fail smtp.client-ip=40.107.236.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=QxaaikIO1oHOh3/VqO5z7vPjU2eUsBqIrMxRpVx98zzCJtyEHvEwyyXi4Qg9r/FlZwNQkFwJf8tw3TZ+u1silTv8uO5/56j6510WRR5G9IrjiToSzTCE/BzYFG3WaBfjI1oUWBbu+eFYc2w5JOgrTaFvWi2Gd0yU+mQRX1VFhpc6NIpNQ8GdEcxrUFrAVHZ+5NC4Vw50l9jwn/ppituvUVs3fEGrtYjc8X3S8zf9BmdpG94d9sa5dWUHGCKgrEgi2/Kf/FW84pOGdiWobI1S5Ce1yjdBKMYtkPaDpJija7Olpgdtl5qqHgYTxUA42Bt67BoqPQFhxWqw1oOdGvvv2A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=8pb1E/sJeQuEWq+xtS85vWCPlEeOuQlEq0PYaVOdGhI=;
 b=Ufob/4e1gh+jQcOthC81zzlLS2jzGbEAbFLIJN4qpIDZcQUI+eJhwt7dja/YheEdmt7G0nq45yjyamfwdPSxjZg1tAoRDTcCK54ixOVt/csMmzo7TfAyfA3R+q00WGkphAM5CioaNTREbCsfz5EtYju06Nmjz5BEbSePNTvbmXSN91+gpdNDhQP7Yt/+uVXf3Y0hEqp55cUZeJq8a1GYA/rmEBxLnkrGqKDKmIqvoS2c/J/lDrB/6E6msv5EmImQmsQ/1M3aecOHY8beNyXs4hDgouTVj69o6jiefJ/Qnlc8PUBjhjaoEdP2Bebt/oorE8VobYT0K3D5R+mGzu1SHg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8pb1E/sJeQuEWq+xtS85vWCPlEeOuQlEq0PYaVOdGhI=;
 b=MkmYvybQfMaHsdPMZOpzR7yyB8uXDHgSaIkHpoq0+nA1yBUGtgdgAjKmpPKts0iOUOm3aQxe5s5JMiKJ5mFfnsyvgzsY2ppPn5L9Lx17mijBBOvBqJ8vvFbIXFZs20OYZS1yGepZhqqnA81/Xnk2sKyqyV1j6UAdOFg0hAMFJqY=
Received: from CH0PR04CA0026.namprd04.prod.outlook.com (2603:10b6:610:76::31)
 by SN7PR12MB6958.namprd12.prod.outlook.com (2603:10b6:806:262::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7719.29; Mon, 1 Jul
 2024 22:34:13 +0000
Received: from CH1PEPF0000AD74.namprd04.prod.outlook.com
 (2603:10b6:610:76:cafe::d9) by CH0PR04CA0026.outlook.office365.com
 (2603:10b6:610:76::31) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7719.33 via Frontend
 Transport; Mon, 1 Jul 2024 22:34:13 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 CH1PEPF0000AD74.mail.protection.outlook.com (10.167.244.52) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.7741.18 via Frontend Transport; Mon, 1 Jul 2024 22:34:13 +0000
Received: from localhost (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Mon, 1 Jul
 2024 17:34:12 -0500
From: Michael Roth <michael.roth@amd.com>
To: <kvm@vger.kernel.org>
CC: <linux-coco@lists.linux.dev>, <linux-kernel@vger.kernel.org>,
	<x86@kernel.org>, <pbonzini@redhat.com>, <seanjc@google.com>,
	<jroedel@suse.de>, <thomas.lendacky@amd.com>, <pgonda@google.com>,
	<ashish.kalra@amd.com>, <bp@alien8.de>, <pankaj.gupta@amd.com>,
	<liam.merwick@oracle.com>
Subject: [PATCH v3 2/3] x86/sev: Move sev_guest.h into common SEV header
Date: Mon, 1 Jul 2024 17:31:47 -0500
Message-ID: <20240701223148.3798365-3-michael.roth@amd.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20240701223148.3798365-1-michael.roth@amd.com>
References: <20240701223148.3798365-1-michael.roth@amd.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SATLEXMB04.amd.com (10.181.40.145) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH1PEPF0000AD74:EE_|SN7PR12MB6958:EE_
X-MS-Office365-Filtering-Correlation-Id: c94f95e6-d15d-4998-9b47-08dc9a1deeef
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|1800799024|7416014|36860700013|82310400026;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?o/NT038mrCNYPmK4xSgTy6Mo0V1TWhwDsOTrNsLppy8GjwMEVtQSuck149ZF?=
 =?us-ascii?Q?ba6qRa0VmUBhK5e0RdZjP/uY2UbLS3dgyCgrm/n5Xp4F7T/nX8aw4neK5GUA?=
 =?us-ascii?Q?JQJF/cak0I5NEW9YNc4tFe9/Z+fW+PbOknqzCHAWT1au6G7Zp6IQJmRGo3bM?=
 =?us-ascii?Q?mQ6zbBFHhKIL4wlILQsUXbq+y+ILSko+D/THqPVFet+X/es1YohrjYz+GrHS?=
 =?us-ascii?Q?4jbX1Rlg1iAOBT+0HAW1FqOJlmofWT3qu48fxoYZPO2xBBXthFd7I1IugdTv?=
 =?us-ascii?Q?eXUDGxsdSjDO1QUZ6AICago8otokxZBfKlBhIrXOIsGRxwKAXNeLWT/xfxis?=
 =?us-ascii?Q?yZWs9CIKCXwwOW/AR+YslLbpFi8CfpwqATLWINjKNQH3sc53hNNtOsJWqNn4?=
 =?us-ascii?Q?dzS4RMGKWQp8NwKdGwrjWDE3XK2TU/ISbCzJCzKOAy324M2rFANjBdfe8YDh?=
 =?us-ascii?Q?chr/jxptxDAHxcsmh/KzbB+4vuM73W1NdrDKuYU1w8pQc5yZsYgF7Hhc/jK5?=
 =?us-ascii?Q?FjFEFrjo8raU/wQtXCySLNvRY7qzq5uHvzgFZjPhu6wrjDkuSEWqJEKwTAi6?=
 =?us-ascii?Q?TKwgCSpFk8LVw7A3mvyBGQbNHtYE48agBdDST33mtxK93fJCFGTVNTFy+K5A?=
 =?us-ascii?Q?4RQ63uLijmFWD+EdRNt7de/UzHxrliItJad161auLSTePcUZ4pKApqG7M74x?=
 =?us-ascii?Q?Rw8pTJuhRWh8le9uV55jsrsRZnITl2LcAVhmtiPo2PHn3lr3zExlnvGll6Um?=
 =?us-ascii?Q?DugkG/MharuucmoLSNws6x4UENlPZ7Hyi8JOb/vnlyeoD2Kj4zPUvnT9Fkgj?=
 =?us-ascii?Q?nQlN71KDOmNkf/Y8K+7umZeCLKZ6H30QlzM6nOtT9OnAtBdbvx/EWn+KLbEr?=
 =?us-ascii?Q?/GUHUXU4J8QKUDS6XSz+ytxbLGdYrPP23wVplhnrlYWd6A30zlNcpBiUNXud?=
 =?us-ascii?Q?PMYfQXP1PGL0UnquPxyc7s8hx6eZEer3Vj2IeBaeSzwU7TTKcmZKFKdHeY4x?=
 =?us-ascii?Q?HieAMzJXblVhuE05ESH1oM+rNUCM5Gd82kc9dIJjImWDihp6foyFo1qK78eA?=
 =?us-ascii?Q?CMa7F0y1SP3WScfXml02lQCVT1o0zmJWebCC8gChBGcRB6Fpf4mrDY/qI+E7?=
 =?us-ascii?Q?nTGcuBtTsnn6AAQAqUE90XZgq7jKadfoJV4IgJcLFjQGjvjloe+Dqq+pqg9h?=
 =?us-ascii?Q?8Qo4prH4rnPEiqIF5esfvNKfg2hZAkCnVp2MooRPSz1BDIXZzF3F8+RQtcOK?=
 =?us-ascii?Q?VB6iNOPU35d2QVleLGnZUnhU/uqAeL1An/Oyi2S4OiGD8cnkvx35nllo9gwm?=
 =?us-ascii?Q?zi2H3q9tp1iPHGHDWRQVcQWuXyH4DI/dNu1W9JIBS7rd9Cd16yRHvGV1plPh?=
 =?us-ascii?Q?1czqUfyCzBiu7yaiHcJjoi3EUIiWJRYEx/GOdqm06aMDIhE98w=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(376014)(1800799024)(7416014)(36860700013)(82310400026);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Jul 2024 22:34:13.2239
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: c94f95e6-d15d-4998-9b47-08dc9a1deeef
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CH1PEPF0000AD74.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR12MB6958

sev_guest.h currently contains various definitions relating to the
format of SNP_GUEST_REQUEST commands to SNP firmware. Currently only the
sev-guest driver makes use of them, but when the KVM side of this is
implemented there's a need to parse the SNP_GUEST_REQUEST header to
determine whether additional information needs to be provided to the
guest. Prepare for this by moving those definitions to a common header
that's shared by host/guest code so that KVM can also make use of them.

Reviewed-by: Tom Lendacky <thomas.lendacky@amd.com>
Reviewed-by: Liam Merwick <liam.merwick@oracle.com>
Signed-off-by: Michael Roth <michael.roth@amd.com>
---
 arch/x86/include/asm/sev.h              | 48 +++++++++++++++++++
 drivers/virt/coco/sev-guest/sev-guest.c |  2 -
 drivers/virt/coco/sev-guest/sev-guest.h | 63 -------------------------
 3 files changed, 48 insertions(+), 65 deletions(-)
 delete mode 100644 drivers/virt/coco/sev-guest/sev-guest.h

diff --git a/arch/x86/include/asm/sev.h b/arch/x86/include/asm/sev.h
index 1936f37e3371..72f9ba3a2fee 100644
--- a/arch/x86/include/asm/sev.h
+++ b/arch/x86/include/asm/sev.h
@@ -119,6 +119,54 @@ struct snp_req_data {
 	unsigned int data_npages;
 };
 
+#define MAX_AUTHTAG_LEN		32
+
+/* See SNP spec SNP_GUEST_REQUEST section for the structure */
+enum msg_type {
+	SNP_MSG_TYPE_INVALID = 0,
+	SNP_MSG_CPUID_REQ,
+	SNP_MSG_CPUID_RSP,
+	SNP_MSG_KEY_REQ,
+	SNP_MSG_KEY_RSP,
+	SNP_MSG_REPORT_REQ,
+	SNP_MSG_REPORT_RSP,
+	SNP_MSG_EXPORT_REQ,
+	SNP_MSG_EXPORT_RSP,
+	SNP_MSG_IMPORT_REQ,
+	SNP_MSG_IMPORT_RSP,
+	SNP_MSG_ABSORB_REQ,
+	SNP_MSG_ABSORB_RSP,
+	SNP_MSG_VMRK_REQ,
+	SNP_MSG_VMRK_RSP,
+
+	SNP_MSG_TYPE_MAX
+};
+
+enum aead_algo {
+	SNP_AEAD_INVALID,
+	SNP_AEAD_AES_256_GCM,
+};
+
+struct snp_guest_msg_hdr {
+	u8 authtag[MAX_AUTHTAG_LEN];
+	u64 msg_seqno;
+	u8 rsvd1[8];
+	u8 algo;
+	u8 hdr_version;
+	u16 hdr_sz;
+	u8 msg_type;
+	u8 msg_version;
+	u16 msg_sz;
+	u32 rsvd2;
+	u8 msg_vmpck;
+	u8 rsvd3[35];
+} __packed;
+
+struct snp_guest_msg {
+	struct snp_guest_msg_hdr hdr;
+	u8 payload[4000];
+} __packed;
+
 struct sev_guest_platform_data {
 	u64 secrets_gpa;
 };
diff --git a/drivers/virt/coco/sev-guest/sev-guest.c b/drivers/virt/coco/sev-guest/sev-guest.c
index 654290a8e1ba..f0ea26f18cbf 100644
--- a/drivers/virt/coco/sev-guest/sev-guest.c
+++ b/drivers/virt/coco/sev-guest/sev-guest.c
@@ -29,8 +29,6 @@
 #include <asm/svm.h>
 #include <asm/sev.h>
 
-#include "sev-guest.h"
-
 #define DEVICE_NAME	"sev-guest"
 #define AAD_LEN		48
 #define MSG_HDR_VER	1
diff --git a/drivers/virt/coco/sev-guest/sev-guest.h b/drivers/virt/coco/sev-guest/sev-guest.h
deleted file mode 100644
index 21bda26fdb95..000000000000
--- a/drivers/virt/coco/sev-guest/sev-guest.h
+++ /dev/null
@@ -1,63 +0,0 @@
-/* SPDX-License-Identifier: GPL-2.0-only */
-/*
- * Copyright (C) 2021 Advanced Micro Devices, Inc.
- *
- * Author: Brijesh Singh <brijesh.singh@amd.com>
- *
- * SEV-SNP API spec is available at https://developer.amd.com/sev
- */
-
-#ifndef __VIRT_SEVGUEST_H__
-#define __VIRT_SEVGUEST_H__
-
-#include <linux/types.h>
-
-#define MAX_AUTHTAG_LEN		32
-
-/* See SNP spec SNP_GUEST_REQUEST section for the structure */
-enum msg_type {
-	SNP_MSG_TYPE_INVALID = 0,
-	SNP_MSG_CPUID_REQ,
-	SNP_MSG_CPUID_RSP,
-	SNP_MSG_KEY_REQ,
-	SNP_MSG_KEY_RSP,
-	SNP_MSG_REPORT_REQ,
-	SNP_MSG_REPORT_RSP,
-	SNP_MSG_EXPORT_REQ,
-	SNP_MSG_EXPORT_RSP,
-	SNP_MSG_IMPORT_REQ,
-	SNP_MSG_IMPORT_RSP,
-	SNP_MSG_ABSORB_REQ,
-	SNP_MSG_ABSORB_RSP,
-	SNP_MSG_VMRK_REQ,
-	SNP_MSG_VMRK_RSP,
-
-	SNP_MSG_TYPE_MAX
-};
-
-enum aead_algo {
-	SNP_AEAD_INVALID,
-	SNP_AEAD_AES_256_GCM,
-};
-
-struct snp_guest_msg_hdr {
-	u8 authtag[MAX_AUTHTAG_LEN];
-	u64 msg_seqno;
-	u8 rsvd1[8];
-	u8 algo;
-	u8 hdr_version;
-	u16 hdr_sz;
-	u8 msg_type;
-	u8 msg_version;
-	u16 msg_sz;
-	u32 rsvd2;
-	u8 msg_vmpck;
-	u8 rsvd3[35];
-} __packed;
-
-struct snp_guest_msg {
-	struct snp_guest_msg_hdr hdr;
-	u8 payload[4000];
-} __packed;
-
-#endif /* __VIRT_SEVGUEST_H__ */
-- 
2.25.1


