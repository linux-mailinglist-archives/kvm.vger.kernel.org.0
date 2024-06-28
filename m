Return-Path: <kvm+bounces-20692-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 05E9091C65D
	for <lists+kvm@lfdr.de>; Fri, 28 Jun 2024 21:08:17 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 69A42B250F1
	for <lists+kvm@lfdr.de>; Fri, 28 Jun 2024 19:08:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B03CC7710B;
	Fri, 28 Jun 2024 19:07:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="5fPqxj77"
X-Original-To: kvm@vger.kernel.org
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2084.outbound.protection.outlook.com [40.107.236.84])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D21DF7407D;
	Fri, 28 Jun 2024 19:07:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.236.84
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719601635; cv=fail; b=rj2cNdrJ76/RLKwKKIfbeqAvteHRPe4+A08tdRxWFT8aSHuphiNoqMKA1y5YQxEMEMVcuUXOczvQgfq2bh56M08DYYVKop4nw7XLYewzdjVaweIbrPFhVxzfeGg48PUQkp8Z3K4u5iA0nX206Y6r0Lmp/XWlgnz8Ou2cFZxqQS4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719601635; c=relaxed/simple;
	bh=vZFv3KZ6ihnKKNTwhHm2QXa7biBRbfN8WP/JwPgZV0I=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ApS4UMMG21SlIDBoUe+5LdFNh/rodMBPZgx3bRV/c4+HbMc61+llmXncnOXe9lnvoTF2PpdH83WEN9DXHgdlBEunKTavrY4RU6goKTKfQVdpNRDoHVYt3n9cmhqaMxyztmCLRtlusjOqkJKNZtwPWTEGWQE7C2SWEGzZ7gyq3Ic=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=5fPqxj77; arc=fail smtp.client-ip=40.107.236.84
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ZkTEbhvmhJDHuxDxBLyc3Ie+47x3+Dmz594psLNMInehzt5qPvUaB7WZ9xQfnJpatuaI9Z53q8yGHIg2prYLtP3kH47HUD5fL3Lxa5fydAPg5BhLnYMgDWKSszngAl/aIadn0mx3eEnl4bu8XycauRRo0zA8FVkdKhMHrXlB3HZ6rJ7ONREZwMbplGYkxclw5gHbE0lmDidZNTyisvs69srZjMpXeBxFJZ6ptoD4bOdjEA/oF7KqT1aqR/aZdo9DFBBaOgbP2JpWORw0YaFXKYm7rL8jH0c+JDTJZtcreY+tBDHUMTOCSaqrBW0V+rdpcQWaCFhlLn20eteMyN9THw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=8pb1E/sJeQuEWq+xtS85vWCPlEeOuQlEq0PYaVOdGhI=;
 b=K+V7FaO7v0NbbMaA1cGqP33gPpArNA+dl+3+1gK/dadspq/EjIyrvYjQ+riqBeWRAK0xnzcbV8s6eWBoW9VWWLf609deHS50bnf+47zM8tXvwgPQX0jPvzrNnZ4GujbR43a2bLhGrXjXwBaMmyqsYBVP3dmZjRgoqpJfAL4sRWnluFZRnfemEaj8xKR8M/QpswjlR2+3Naj6ewl2gT66YGy6tkl2+LB0A0PbFqbp4rq7GZXIffus32Yv0tQH6cC5CgB1GJ5gcHVrsu2BQ3fIwxrzyVVjSgWdhow2YrUeL8v+IibUJ3no6OlvyUo0POFDsvF+48yDFKa2s7UGaASyXw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8pb1E/sJeQuEWq+xtS85vWCPlEeOuQlEq0PYaVOdGhI=;
 b=5fPqxj77uj5OwSCdWZeH91bJPWh0JxHdpSyKPxxLoje9YnjM3rj/JT7UfoJsCXC5Dk85OzgUbKsks0X4N4+swQl9b72vHL9hqONBPzbUeqot6JI5tkkbsDQEZ3K3KuZAqtFRa0bpQCIxbkbrKZTjuNraV1nUoZ61VF1Wvm58GnU=
Received: from CH0P221CA0030.NAMP221.PROD.OUTLOOK.COM (2603:10b6:610:11d::18)
 by MN0PR12MB5978.namprd12.prod.outlook.com (2603:10b6:208:37d::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7698.32; Fri, 28 Jun
 2024 19:07:09 +0000
Received: from CH1PEPF0000AD78.namprd04.prod.outlook.com
 (2603:10b6:610:11d:cafe::2f) by CH0P221CA0030.outlook.office365.com
 (2603:10b6:610:11d::18) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7719.28 via Frontend
 Transport; Fri, 28 Jun 2024 19:07:09 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 CH1PEPF0000AD78.mail.protection.outlook.com (10.167.244.56) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.7677.15 via Frontend Transport; Fri, 28 Jun 2024 19:07:08 +0000
Received: from localhost (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Fri, 28 Jun
 2024 14:07:08 -0500
From: Michael Roth <michael.roth@amd.com>
To: <kvm@vger.kernel.org>
CC: <linux-coco@lists.linux.dev>, <linux-kernel@vger.kernel.org>,
	<x86@kernel.org>, <pbonzini@redhat.com>, <seanjc@google.com>,
	<jroedel@suse.de>, <thomas.lendacky@amd.com>, <pgonda@google.com>,
	<ashish.kalra@amd.com>, <bp@alien8.de>, <pankaj.gupta@amd.com>,
	<liam.merwick@oracle.com>
Subject: [PATCH v2 2/3] x86/sev: Move sev_guest.h into common SEV header
Date: Fri, 28 Jun 2024 13:52:43 -0500
Message-ID: <20240628185244.3615928-3-michael.roth@amd.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20240628185244.3615928-1-michael.roth@amd.com>
References: <20240628185244.3615928-1-michael.roth@amd.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SATLEXMB03.amd.com (10.181.40.144) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH1PEPF0000AD78:EE_|MN0PR12MB5978:EE_
X-MS-Office365-Filtering-Correlation-Id: 4df05f16-5a00-46c9-3b60-08dc97a58238
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|36860700013|376014|1800799024|82310400026;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?YHIWuxZ62Sj95EY6a9B3lyqoxypQxdXS9X1xP8ZmjpqzuHur5Dd9Lzd3BZUS?=
 =?us-ascii?Q?5yJCwKl08Y6fSGvoWkZIXRJbki5e72FFWW3HWMM1pMKZPVVJYBBibdoh60u+?=
 =?us-ascii?Q?nQtUHCRG9TbfnINq5xTfEarx5UDEpeyVxmVwVLR3wLZAG0lpEW0D/PKGQuQ4?=
 =?us-ascii?Q?5dDbmXcEubuG00KgnShCJoJlAs1jqFBIDt/EYDD2PuN3856ryr6U9+L2dLi4?=
 =?us-ascii?Q?+KA5nEbActEv+rn4cJ/KdJdXt7K4kReHgLsIwoQ0jOrQuhqE7PumzERoH5ci?=
 =?us-ascii?Q?txS3k6KW64s1PRNyarZsB9CmVCaM2n2Yt2QhPMMxoLSCJWsdX12fl6sgMtU/?=
 =?us-ascii?Q?jiXmagAg65EV7hcp3NyuyjzmwvqrKlC7e8VoITtcs7GyIscIfDNLRqRn01OG?=
 =?us-ascii?Q?b+e8FJnHcHbhSaiOmxQi6mi49NRt+k5ZZ68XPlwCMajYJrFQ5iXXwYSuV5fx?=
 =?us-ascii?Q?+SsEJpK0i1ozJ/qC9ySp8PGVTVctWe2C57YVdnJF2Uk8vfLqLaAoVigXZoJk?=
 =?us-ascii?Q?BJMX+bPJXJrKKEJnewJwwmCeesE1bpiIgblJ3jaDfkDkSxmKQyfrC4bHcQFh?=
 =?us-ascii?Q?04X5q2xKdBYd9j2K69TLewmRDziFwRN48gmZq1lDsuUnILUQJMoiCQyU2fKe?=
 =?us-ascii?Q?k29JGUDwHMHSlQdAZgVvP+Ra6jgCA4FGqBAA87UxjV8ByXCydn96ILrl8Ivt?=
 =?us-ascii?Q?GKDBjCEvJFwFEUvUP5D3S2fWFFgATNTDqBFMVRGTakwLgCUSqmXDZtgw/NyG?=
 =?us-ascii?Q?DBpbIHz330DJqPy2bkgttZ9U6ABsgniPzpThccMHP6+eUUqmrcpZjCrJ1POt?=
 =?us-ascii?Q?t83MTYar2j/ozBRnSptsFmhA6/1P1ELZ3IqmA++swuSO5/j6Biwq16M6vADe?=
 =?us-ascii?Q?WncXS65zz+c+bkplIQjWfMiS1EmyHADWzyU1vA7QcOnj9NNNz+5AykhHD+N+?=
 =?us-ascii?Q?YQJOr/frA4Qry4vjEW5pt4kcYE0xElvg2puuSmObiwdDMEh4zkr0nawwd4w7?=
 =?us-ascii?Q?H0vLNFYK584GVj+r3vZZEN25ir5JKQ5nqsmAlxnCcFAy+8nWqAi7/X23HmKx?=
 =?us-ascii?Q?+cN5S4L3pGbd2iPCv6l21fP5GmS0kHwk31s5zdV0VRu4vap56Z0VTNPHZPLf?=
 =?us-ascii?Q?iuc3HdWHIOQbcwYS54b34KbHGFOVICVkkkmIFGInFltF6bfhqaE9Jb317Ogw?=
 =?us-ascii?Q?rmR7cstCy78/s4D6H31S/UoWHJNByK8Jiqj2dBkGsabl/vV+mwvb0s8ITneK?=
 =?us-ascii?Q?YevJBGwkN32sMs8k2dBRYa8EmY3tteIKMGFh47RpHcRMvLxNapMkVJf3P7kn?=
 =?us-ascii?Q?j4PLYtj+ENIXZbsxW3pyKH3NSUNat0r6CpFq6PTv+RXuhIFkokS3Pxw+z3Gq?=
 =?us-ascii?Q?9/7b/PIjPJ+/6khJ7EGoMUBMf/yhozGxr+MaOK9FUmWjkJuc0w=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(7416014)(36860700013)(376014)(1800799024)(82310400026);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Jun 2024 19:07:08.9107
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 4df05f16-5a00-46c9-3b60-08dc97a58238
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CH1PEPF0000AD78.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN0PR12MB5978

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


