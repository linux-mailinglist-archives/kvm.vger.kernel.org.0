Return-Path: <kvm+bounces-34591-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 0077EA025EA
	for <lists+kvm@lfdr.de>; Mon,  6 Jan 2025 13:48:59 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 4DDF81883C64
	for <lists+kvm@lfdr.de>; Mon,  6 Jan 2025 12:48:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D366B1DE89A;
	Mon,  6 Jan 2025 12:47:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="rNSxlEVb"
X-Original-To: kvm@vger.kernel.org
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2067.outbound.protection.outlook.com [40.107.93.67])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 909301DAC92;
	Mon,  6 Jan 2025 12:47:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.93.67
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736167651; cv=fail; b=OBT8MzAagK7f5okGR07e0eoj7VTWu7x+CV2SpF1dCj0/OTjCPBF+hoU47DLaGawwZ0dtwF1La3PncP2yir9w9oJtDmjeRcdfJtE8TDSGBsYGDOvIfdZ8BT1OZPLFAAMogu/V2twKZ/Zi2utgT85JtY6AO/ir/mU93fYWDWUTge4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736167651; c=relaxed/simple;
	bh=2+Z2A6q3X8ztQKcHUIib/4PdtFd3FqfSByLAG5HUSZU=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=TznoweNwRwAJWpT6RQlTkAuaRXNW65H7cZTk8CC2IsZNIEE9djeN/gC9hDP47cKcjhzw8lFrELYTHxlOzRHNVq8SRt9WSl7hfprogoe8rdbHijO5yS8cBqxFDfUycqepC1T6N14Q4SinbdFQh2nH27FYTDmTFdw63NchAUNKUn8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=rNSxlEVb; arc=fail smtp.client-ip=40.107.93.67
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=qHIjTTEMpB2UXBGsdJ+8sw7+kXx4vuzaCuh9rh5VY21fm2ydgf/SQXAxEBdxnBfVjFKpERBPiRjC3dK1E1EiIa8QOWlmrnufJvXa6LJ9wL87KFFGrDNE/kUQ+1LrpzlG1xAK9s3DAumJND99kyRtPCX4zf1ZwY8Itlkj9ZK7wUMhKwHRz4KKLuI2eIlsv70ji2VQUfWS8IZIgmIfGDCk0Nm9APY5HwFJcrqZzX7sbIYNvrCCBHJkdF0CpebczdBnZJiSWBPj+cnP3/OsosD5hvM3DjorGbjqUAoJuOjeVZPAhRzasj02yr1dI6QRH9Z0vqp6o0ZqCoMpO9bDUfRWTg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=AZ1yNYiV3cgC7Od5vge15wj9ydZFwz9HGRXqSrsd7Xg=;
 b=NlCbnsz8INUETKYDC/Uw5vaG4/YsRXn4S+8BBsgjZmauEF9B5pbxWPvZBrk+mZ+yMMS51xTnnadea4bcGmJKXfZkE8kZfBqPUyNiTaWUAwDH4MxZgGj1YB1gOvoqpdEeBeGF+BfMyNySJZHZn8np/6J5hohDHXPQWR8K9iye2x4D/z0ZUkwp9wXsuYxDfFysPjQ7mjtKQFqbwiGVsGco8Oq1F+n4xfKP+Mnjq8MYRRcpGrZmtABhuIBXIq9j1Mgoy8lHCwBg4nAuUbM5jygTrVlXVH29UAgFkZ5sGCdgR6lPKXyDB97IUUBj0XixP8C98xCy3kwScApM8/F7Y4r16A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=AZ1yNYiV3cgC7Od5vge15wj9ydZFwz9HGRXqSrsd7Xg=;
 b=rNSxlEVbNF2wS56d50jQbkNT/uBFXFG+zs0YpeuYleQiGp/QXkwyUax9Ah+wMYFNCauNsoeOxConAejkSg4uhq6KxsKvyxsy5kQD055o1/7ee1UDf8a8K5CaQvImtkFC0pUXdvz5BazJKSLfZ4TSUriL8U5soRmF7o90K6xCHf4=
Received: from PH7P221CA0017.NAMP221.PROD.OUTLOOK.COM (2603:10b6:510:32a::32)
 by DS7PR12MB8292.namprd12.prod.outlook.com (2603:10b6:8:e2::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8314.17; Mon, 6 Jan
 2025 12:47:19 +0000
Received: from CY4PEPF0000EDD2.namprd03.prod.outlook.com
 (2603:10b6:510:32a:cafe::85) by PH7P221CA0017.outlook.office365.com
 (2603:10b6:510:32a::32) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8314.17 via Frontend Transport; Mon,
 6 Jan 2025 12:47:19 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 CY4PEPF0000EDD2.mail.protection.outlook.com (10.167.241.198) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.8335.7 via Frontend Transport; Mon, 6 Jan 2025 12:47:19 +0000
Received: from gomati.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Mon, 6 Jan
 2025 06:47:13 -0600
From: Nikunj A Dadhania <nikunj@amd.com>
To: <linux-kernel@vger.kernel.org>, <thomas.lendacky@amd.com>, <bp@alien8.de>,
	<x86@kernel.org>
CC: <kvm@vger.kernel.org>, <mingo@redhat.com>, <tglx@linutronix.de>,
	<dave.hansen@linux.intel.com>, <pgonda@google.com>, <seanjc@google.com>,
	<pbonzini@redhat.com>, <nikunj@amd.com>, <francescolavra.fl@gmail.com>
Subject: [PATCH v16 05/13] x86/sev: Add Secure TSC support for SNP guests
Date: Mon, 6 Jan 2025 18:16:25 +0530
Message-ID: <20250106124633.1418972-6-nikunj@amd.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20250106124633.1418972-1-nikunj@amd.com>
References: <20250106124633.1418972-1-nikunj@amd.com>
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
X-MS-TrafficTypeDiagnostic: CY4PEPF0000EDD2:EE_|DS7PR12MB8292:EE_
X-MS-Office365-Filtering-Correlation-Id: ea285610-13aa-4992-192d-08dd2e504207
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|36860700013|7416014|376014|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?KVnHlGlWWrgtnyC7wOMCL/Y/oLUe/pH/VfjUGOmaeXFi5d8+W7/as0M9o6PG?=
 =?us-ascii?Q?bx7PMpbFtnDyiNlMnKojnCyVaTPyztWulZgUBRqeV7JW1AQK7v3tCzlR+7z0?=
 =?us-ascii?Q?KrJmAsanAr5V8jr5tNyJZckc89oDkBfg54BWai8loLl+ZiQzoCc6H4GwFqRy?=
 =?us-ascii?Q?VyOftnwaghpv0JJWuucusx57Ll/upZM/wnMoENRV1LIW1iE5MxdOsYS4uqsb?=
 =?us-ascii?Q?tGFcYAVhtNjVrkJn/Uo+dYdcWZs6WSf5qRlYkdddsNEpxm/9yhHRAXFFsQOP?=
 =?us-ascii?Q?2NkFs5HPY4SHeX9i84pNc2Oq7jS9Hg7rgU1H5twAGQzxLM8rxyKrJ5BUMVhd?=
 =?us-ascii?Q?lAf+2/XqAr4kX1n54vPAlIuJ2NT7cCA2KNV4JuKqR0Vf0RFF4G5QE5W/+J0J?=
 =?us-ascii?Q?IFb47CAK8c+gtMTktEHM2Cc7fu6oeAY5AEbxh4uOQKdFeuuiQLWYf7drTVk2?=
 =?us-ascii?Q?VjFJJR2+UoNuSx6BfiIk8rm18kUS25Rh/tmmsKADITNysuFpTalhrQIn+pPC?=
 =?us-ascii?Q?DLkGXTalOosc+6cS/DkillVrTT7CR4HWDxkcFyigP1qbTVVeMtKTCFD2EZa/?=
 =?us-ascii?Q?k7JHfiFG89Trw5qwtNB9du6JdCeAOiiyb6HsSCc8gRgpsyVGnN0bIxlu5Zc0?=
 =?us-ascii?Q?np7dZ+ry8OCVLZOjXmFmGU4LlvkHCNPjVyTdnLCkPAfPTZDbJmbO2OVCUMiZ?=
 =?us-ascii?Q?j+kdSKjk72hyj7/XiIrmu62FFdQ6IhXbm4s4MtKL2DvyrJj706jyMKKJlkUS?=
 =?us-ascii?Q?U8JM1o/C2xQsUAoYC1W9+4Zw+GCROhwqz/mfUR00dYRjhEOnZdAfc5rZW168?=
 =?us-ascii?Q?G+3O7fukhzBE0oLNAcu51x8roirgJZDMwSOWbM3hZJxdO8ir+ntO9Yc2IKSU?=
 =?us-ascii?Q?6Xes30OGGTb6oLEEG9kOcPO0uLcB7nJG16AhhaJLeC0SSsTWxRC1NJmdI3g7?=
 =?us-ascii?Q?xuUEcc41iPgT53arHiyTKZ/7aiQawqMc+phPqmk/TRKGnedcBTi2vHXMkotP?=
 =?us-ascii?Q?+lfo75DAmcJ91mjuvBYVFvrWw4vfto3P+phSL8+xi8IVY9cEvttqdqbMyDlA?=
 =?us-ascii?Q?pOvUynMdv0UkQcUUuIwYAcpV4PEO0X+VsHlp3Ljs96g+ndG3VIBdBHaBkvbx?=
 =?us-ascii?Q?VdSUfKt1+GUFHZjXPYGvwMEgOyomfUHlpuW2D+0Sy2T1TmAa8GMTZon7YWpB?=
 =?us-ascii?Q?Kmi0UKw/FTliStAiVhAzRdmJ+rovm2xpxCk5NZgNdIQs3FDmObiiBQHM/L7h?=
 =?us-ascii?Q?vN3R83KxHysM+gHapWOqT3/fr1lSKXkMQMBAC+9DAyz08fHxud30tYiLbxMP?=
 =?us-ascii?Q?wpVoZtASpRRwrNHVBEsGew99NDTOUeW8ED7zQmEnNA3wXJFe54zJuUJwB77v?=
 =?us-ascii?Q?TSas2/ZI9S5A9DGWqkQW9xg+d40SC2I/4gEHyr/iyPTw3ZXshAXbRJ+mx/pe?=
 =?us-ascii?Q?riItBKxirsjoLpMN3FNVVP+M4nkRMYXLdlNTGcNaMfwlMnir6/1SFQeRP3rK?=
 =?us-ascii?Q?+KRQyuLsvaIsoYc=3D?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(82310400026)(36860700013)(7416014)(376014)(1800799024);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Jan 2025 12:47:19.4782
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: ea285610-13aa-4992-192d-08dd2e504207
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CY4PEPF0000EDD2.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR12MB8292

Add support for Secure TSC in SNP-enabled guests. Secure TSC allows guests
to securely use RDTSC/RDTSCP instructions, ensuring that the parameters
used cannot be altered by the hypervisor once the guest is launched.

Secure TSC-enabled guests need to query TSC information from the AMD
Security Processor. This communication channel is encrypted between the AMD
Security Processor and the guest, with the hypervisor acting merely as a
conduit to deliver the guest messages to the AMD Security Processor. Each
message is protected with AEAD (AES-256 GCM).

Signed-off-by: Nikunj A Dadhania <nikunj@amd.com>
---
 arch/x86/include/asm/sev-common.h |   1 +
 arch/x86/include/asm/sev.h        |  21 ++++++
 arch/x86/include/asm/svm.h        |   6 +-
 include/linux/cc_platform.h       |   8 +++
 arch/x86/coco/core.c              |   4 ++
 arch/x86/coco/sev/core.c          | 107 ++++++++++++++++++++++++++++++
 arch/x86/mm/mem_encrypt.c         |   2 +
 7 files changed, 147 insertions(+), 2 deletions(-)

diff --git a/arch/x86/include/asm/sev-common.h b/arch/x86/include/asm/sev-common.h
index 50f5666938c0..6ef92432a5ce 100644
--- a/arch/x86/include/asm/sev-common.h
+++ b/arch/x86/include/asm/sev-common.h
@@ -206,6 +206,7 @@ struct snp_psc_desc {
 #define GHCB_TERM_NO_SVSM		7	/* SVSM is not advertised in the secrets page */
 #define GHCB_TERM_SVSM_VMPL0		8	/* SVSM is present but has set VMPL to 0 */
 #define GHCB_TERM_SVSM_CAA		9	/* SVSM is present but CAA is not page aligned */
+#define GHCB_TERM_SECURE_TSC		10	/* Secure TSC initialization failed */
 
 #define GHCB_RESP_CODE(v)		((v) & GHCB_MSR_INFO_MASK)
 
diff --git a/arch/x86/include/asm/sev.h b/arch/x86/include/asm/sev.h
index 0937ac7a96db..bdcdaac4df1c 100644
--- a/arch/x86/include/asm/sev.h
+++ b/arch/x86/include/asm/sev.h
@@ -146,6 +146,9 @@ enum msg_type {
 	SNP_MSG_VMRK_REQ,
 	SNP_MSG_VMRK_RSP,
 
+	SNP_MSG_TSC_INFO_REQ = 17,
+	SNP_MSG_TSC_INFO_RSP,
+
 	SNP_MSG_TYPE_MAX
 };
 
@@ -174,6 +177,21 @@ struct snp_guest_msg {
 	u8 payload[PAGE_SIZE - sizeof(struct snp_guest_msg_hdr)];
 } __packed;
 
+#define SNP_TSC_INFO_REQ_SZ	128
+
+struct snp_tsc_info_req {
+	u8 rsvd[SNP_TSC_INFO_REQ_SZ];
+} __packed;
+
+struct snp_tsc_info_resp {
+	u32 status;
+	u32 rsvd1;
+	u64 tsc_scale;
+	u64 tsc_offset;
+	u32 tsc_factor;
+	u8 rsvd2[100];
+} __packed;
+
 struct snp_guest_req {
 	void *req_buf;
 	size_t req_sz;
@@ -463,6 +481,8 @@ void snp_msg_free(struct snp_msg_desc *mdesc);
 int snp_send_guest_request(struct snp_msg_desc *mdesc, struct snp_guest_req *req,
 			   struct snp_guest_request_ioctl *rio);
 
+void __init snp_secure_tsc_prepare(void);
+
 #else	/* !CONFIG_AMD_MEM_ENCRYPT */
 
 #define snp_vmpl 0
@@ -503,6 +523,7 @@ static inline struct snp_msg_desc *snp_msg_alloc(void) { return NULL; }
 static inline void snp_msg_free(struct snp_msg_desc *mdesc) { }
 static inline int snp_send_guest_request(struct snp_msg_desc *mdesc, struct snp_guest_req *req,
 					 struct snp_guest_request_ioctl *rio) { return -ENODEV; }
+static inline void __init snp_secure_tsc_prepare(void) { }
 
 #endif	/* CONFIG_AMD_MEM_ENCRYPT */
 
diff --git a/arch/x86/include/asm/svm.h b/arch/x86/include/asm/svm.h
index 2b59b9951c90..92e18798f197 100644
--- a/arch/x86/include/asm/svm.h
+++ b/arch/x86/include/asm/svm.h
@@ -417,7 +417,9 @@ struct sev_es_save_area {
 	u8 reserved_0x298[80];
 	u32 pkru;
 	u32 tsc_aux;
-	u8 reserved_0x2f0[24];
+	u64 tsc_scale;
+	u64 tsc_offset;
+	u8 reserved_0x300[8];
 	u64 rcx;
 	u64 rdx;
 	u64 rbx;
@@ -564,7 +566,7 @@ static inline void __unused_size_checks(void)
 	BUILD_BUG_RESERVED_OFFSET(sev_es_save_area, 0x1c0);
 	BUILD_BUG_RESERVED_OFFSET(sev_es_save_area, 0x248);
 	BUILD_BUG_RESERVED_OFFSET(sev_es_save_area, 0x298);
-	BUILD_BUG_RESERVED_OFFSET(sev_es_save_area, 0x2f0);
+	BUILD_BUG_RESERVED_OFFSET(sev_es_save_area, 0x300);
 	BUILD_BUG_RESERVED_OFFSET(sev_es_save_area, 0x320);
 	BUILD_BUG_RESERVED_OFFSET(sev_es_save_area, 0x380);
 	BUILD_BUG_RESERVED_OFFSET(sev_es_save_area, 0x3f0);
diff --git a/include/linux/cc_platform.h b/include/linux/cc_platform.h
index caa4b4430634..0bf7d33a1048 100644
--- a/include/linux/cc_platform.h
+++ b/include/linux/cc_platform.h
@@ -81,6 +81,14 @@ enum cc_attr {
 	 */
 	CC_ATTR_GUEST_SEV_SNP,
 
+	/**
+	 * @CC_ATTR_GUEST_SNP_SECURE_TSC: SNP Secure TSC is active.
+	 *
+	 * The platform/OS is running as a guest/virtual machine and actively
+	 * using AMD SEV-SNP Secure TSC feature.
+	 */
+	CC_ATTR_GUEST_SNP_SECURE_TSC,
+
 	/**
 	 * @CC_ATTR_HOST_SEV_SNP: AMD SNP enabled on the host.
 	 *
diff --git a/arch/x86/coco/core.c b/arch/x86/coco/core.c
index 0f81f70aca82..715c2c09582f 100644
--- a/arch/x86/coco/core.c
+++ b/arch/x86/coco/core.c
@@ -97,6 +97,10 @@ static bool noinstr amd_cc_platform_has(enum cc_attr attr)
 	case CC_ATTR_GUEST_SEV_SNP:
 		return sev_status & MSR_AMD64_SEV_SNP_ENABLED;
 
+	case CC_ATTR_GUEST_SNP_SECURE_TSC:
+		return (sev_status & MSR_AMD64_SEV_SNP_ENABLED) &&
+			(sev_status & MSR_AMD64_SNP_SECURE_TSC);
+
 	case CC_ATTR_HOST_SEV_SNP:
 		return cc_flags.host_sev_snp;
 
diff --git a/arch/x86/coco/sev/core.c b/arch/x86/coco/sev/core.c
index feb145df6bf7..00a0ac3baab7 100644
--- a/arch/x86/coco/sev/core.c
+++ b/arch/x86/coco/sev/core.c
@@ -96,6 +96,14 @@ static u64 sev_hv_features __ro_after_init;
 /* Secrets page physical address from the CC blob */
 static u64 secrets_pa __ro_after_init;
 
+/*
+ * For Secure TSC guests, the BSP fetches TSC_INFO using SNP guest messaging and
+ * initializes snp_tsc_scale and snp_tsc_offset. These values are replicated
+ * across the APs VMSA fields (TSC_SCALE and TSC_OFFSET).
+ */
+static u64 snp_tsc_scale __ro_after_init;
+static u64 snp_tsc_offset __ro_after_init;
+
 /* #VC handler runtime per-CPU data */
 struct sev_es_runtime_data {
 	struct ghcb ghcb_page;
@@ -1272,6 +1280,12 @@ static int wakeup_cpu_via_vmgexit(u32 apic_id, unsigned long start_ip)
 	vmsa->vmpl		= snp_vmpl;
 	vmsa->sev_features	= sev_status >> 2;
 
+	/* Populate AP's TSC scale/offset to get accurate TSC values. */
+	if (cc_platform_has(CC_ATTR_GUEST_SNP_SECURE_TSC)) {
+		vmsa->tsc_scale = snp_tsc_scale;
+		vmsa->tsc_offset = snp_tsc_offset;
+	}
+
 	/* Switch the page over to a VMSA page now that it is initialized */
 	ret = snp_set_vmsa(vmsa, caa, apic_id, true);
 	if (ret) {
@@ -3121,3 +3135,96 @@ int snp_send_guest_request(struct snp_msg_desc *mdesc, struct snp_guest_req *req
 	return 0;
 }
 EXPORT_SYMBOL_GPL(snp_send_guest_request);
+
+static int __init snp_get_tsc_info(void)
+{
+	struct snp_guest_request_ioctl *rio;
+	struct snp_tsc_info_resp *tsc_resp;
+	struct snp_tsc_info_req *tsc_req;
+	struct snp_msg_desc *mdesc;
+	struct snp_guest_req *req;
+	int rc = -ENOMEM;
+
+	tsc_req = kzalloc(sizeof(*tsc_req), GFP_KERNEL);
+	if (!tsc_req)
+		return rc;
+
+	/*
+	 * The intermediate response buffer is used while decrypting the
+	 * response payload. Make sure that it has enough space to cover
+	 * the authtag.
+	 */
+	tsc_resp = kzalloc(sizeof(*tsc_resp) + AUTHTAG_LEN, GFP_KERNEL);
+	if (!tsc_resp)
+		goto e_free_tsc_req;
+
+	req = kzalloc(sizeof(*req), GFP_KERNEL);
+	if (!req)
+		goto e_free_tsc_resp;
+
+	rio = kzalloc(sizeof(*rio), GFP_KERNEL);
+	if (!rio)
+		goto e_free_req;
+
+	mdesc = snp_msg_alloc();
+	if (IS_ERR_OR_NULL(mdesc))
+		goto e_free_rio;
+
+	rc = snp_msg_init(mdesc, snp_vmpl);
+	if (rc)
+		goto e_free_mdesc;
+
+	req->msg_version = MSG_HDR_VER;
+	req->msg_type = SNP_MSG_TSC_INFO_REQ;
+	req->vmpck_id = snp_vmpl;
+	req->req_buf = tsc_req;
+	req->req_sz = sizeof(*tsc_req);
+	req->resp_buf = (void *)tsc_resp;
+	req->resp_sz = sizeof(*tsc_resp) + AUTHTAG_LEN;
+	req->exit_code = SVM_VMGEXIT_GUEST_REQUEST;
+
+	rc = snp_send_guest_request(mdesc, req, rio);
+	if (rc)
+		goto e_request;
+
+	pr_debug("%s: response status 0x%x scale 0x%llx offset 0x%llx factor 0x%x\n",
+		 __func__, tsc_resp->status, tsc_resp->tsc_scale, tsc_resp->tsc_offset,
+		 tsc_resp->tsc_factor);
+
+	if (!tsc_resp->status) {
+		snp_tsc_scale = tsc_resp->tsc_scale;
+		snp_tsc_offset = tsc_resp->tsc_offset;
+	} else {
+		pr_err("Failed to get TSC info, response status 0x%x\n", tsc_resp->status);
+		rc = -EIO;
+	}
+
+e_request:
+	/* The response buffer contains sensitive data, explicitly clear it. */
+	memzero_explicit(tsc_resp, sizeof(*tsc_resp) + AUTHTAG_LEN);
+e_free_mdesc:
+	snp_msg_free(mdesc);
+e_free_rio:
+	kfree(rio);
+e_free_req:
+	kfree(req);
+ e_free_tsc_resp:
+	kfree(tsc_resp);
+e_free_tsc_req:
+	kfree(tsc_req);
+
+	return rc;
+}
+
+void __init snp_secure_tsc_prepare(void)
+{
+	if (!cc_platform_has(CC_ATTR_GUEST_SNP_SECURE_TSC))
+		return;
+
+	if (snp_get_tsc_info()) {
+		pr_alert("Unable to retrieve Secure TSC info from ASP\n");
+		sev_es_terminate(SEV_TERM_SET_LINUX, GHCB_TERM_SECURE_TSC);
+	}
+
+	pr_debug("SecureTSC enabled");
+}
diff --git a/arch/x86/mm/mem_encrypt.c b/arch/x86/mm/mem_encrypt.c
index 0a120d85d7bb..95bae74fdab2 100644
--- a/arch/x86/mm/mem_encrypt.c
+++ b/arch/x86/mm/mem_encrypt.c
@@ -94,6 +94,8 @@ void __init mem_encrypt_init(void)
 	/* Call into SWIOTLB to update the SWIOTLB DMA buffers */
 	swiotlb_update_mem_attributes();
 
+	snp_secure_tsc_prepare();
+
 	print_mem_encrypt_feature_info();
 }
 
-- 
2.34.1


