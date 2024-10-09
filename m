Return-Path: <kvm+bounces-28211-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 77F02996572
	for <lists+kvm@lfdr.de>; Wed,  9 Oct 2024 11:33:06 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 2FE0428304C
	for <lists+kvm@lfdr.de>; Wed,  9 Oct 2024 09:33:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6C56C1922D7;
	Wed,  9 Oct 2024 09:29:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="lMOTW0Ag"
X-Original-To: kvm@vger.kernel.org
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2056.outbound.protection.outlook.com [40.107.94.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BC3B9191F87;
	Wed,  9 Oct 2024 09:29:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.94.56
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728466196; cv=fail; b=D4Zn/QTZYrki0azV+KZNj3faTKOP6gCuF0h/rpQX4Cuh+gUib6OLVVumM5sY1WF29KjwPHIXYvHB0qEquD+P4uMsD9a7VEwfZFmAwzQ+z1aydvbJlOlvu16qQnVxjb52qw7QqiN+SqXQq+6/oUlU1hlusnwUCIyAscGaXeDMzRc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728466196; c=relaxed/simple;
	bh=xFXj0qbsFs4gSUNA3KsQrrFvr89H7n9VD0jjRGKk8dg=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Yk1A8MUIl0eTtWEKi/V8KcFIElsxmMFBCwLnbEfQEK5CMHsAKVX5WoYXcO0WWUjdFVdc0ZhymrIlwTOuncaODwKVTGz15csbZaMO7+ZsZR9FRMgJN8wTuz4zgE6xqWBjusoXRzwtjUcZw8coVe1BlvbmekYIZrqNYsPafO0+s70=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=lMOTW0Ag; arc=fail smtp.client-ip=40.107.94.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=zPTi0dHVT+SAeVH0dz5i88nkdODXdDYJdrZSx6qxa6Jn/SHg2Ia89aTDKYz+mXkVpI8GLslAJu/G9owAhRdD4yk2hgnwIKQN62Gi+BwVlj7GKITbNKoqk8ZkunJCx5E/oSLUDEG4meY5QxWu48Sx7UYeYq3dhkqYzQGH9sH51qu0oHcWPVcraxsofwlUmlSd6Cxh06nXTJLSiRNKaogyT2lwc/PUMjPM6mGarN5lW5hLUxFyzloWMBwRDI5RNHoLc8KWS+tZDZUEweP86kkw/IBn9z+kHDm/WeP0+2Ta254sBhAbGgRIV/V/B7n0FlmuZhCCReWewiG9PIKNBXjH7w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=dJ9zoDZrmnAyNFQc599pS6W4PzcyiD0qMJGqLzwN3gY=;
 b=uMgUxZSegvTDBbGnR5c5KCKHPdhc3G3obIAbZX/wN4q7n6Ls+2/E8KSByPg5UZ07sDqAL3OhjPuCFPfzn+JfbeUVDaPXDkAvzD25lxofkOCGJiu5I1ANoqNL/WKi0FL/xNQQcgyuVFBNPlefMU70tsb1+CwrkPgf/cvcqgD9LTjr7vWygG/9PsLn7n07AYDC2HcIl3yFg10j06yhmTbWZ3lWhUBnN7tMADKRMq7gTdxkIXOf/F4WYbQEJymVD76F7mtnWaZ6vSrKaArSIcZDgmOINtJR2RBw+j6xFoFC+2ev7KZ8VRFGByMzdzob109bGFsqu9IC7Biq91kHKgzsag==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=dJ9zoDZrmnAyNFQc599pS6W4PzcyiD0qMJGqLzwN3gY=;
 b=lMOTW0AgZ5tWc/xrahTNwHI/0GbuWgxLVWU0gYe7egCReaElR5zUV6taQSU1wWrffEWeygSrAMj12up+NgCB2APkmZwN7U3hb8lzbjfFLtdocfrRWS0jTPM4Z3eInQYqmLQUPB2MaB4YJZ/TBsTEKm5fYPM/UwlBLsW41ZsVJ1Y=
Received: from MN0P220CA0026.NAMP220.PROD.OUTLOOK.COM (2603:10b6:208:52e::19)
 by SJ2PR12MB7894.namprd12.prod.outlook.com (2603:10b6:a03:4c6::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8026.23; Wed, 9 Oct
 2024 09:29:48 +0000
Received: from BL02EPF00021F68.namprd02.prod.outlook.com
 (2603:10b6:208:52e:cafe::d9) by MN0P220CA0026.outlook.office365.com
 (2603:10b6:208:52e::19) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8048.18 via Frontend
 Transport; Wed, 9 Oct 2024 09:29:48 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 BL02EPF00021F68.mail.protection.outlook.com (10.167.249.4) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.8048.13 via Frontend Transport; Wed, 9 Oct 2024 09:29:47 +0000
Received: from gomati.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Wed, 9 Oct
 2024 04:29:44 -0500
From: Nikunj A Dadhania <nikunj@amd.com>
To: <linux-kernel@vger.kernel.org>, <thomas.lendacky@amd.com>, <bp@alien8.de>,
	<x86@kernel.org>, <kvm@vger.kernel.org>
CC: <mingo@redhat.com>, <tglx@linutronix.de>, <dave.hansen@linux.intel.com>,
	<pgonda@google.com>, <seanjc@google.com>, <pbonzini@redhat.com>,
	<nikunj@amd.com>
Subject: [PATCH v12 10/19] x86/sev: Add Secure TSC support for SNP guests
Date: Wed, 9 Oct 2024 14:58:41 +0530
Message-ID: <20241009092850.197575-11-nikunj@amd.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20241009092850.197575-1-nikunj@amd.com>
References: <20241009092850.197575-1-nikunj@amd.com>
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
X-MS-TrafficTypeDiagnostic: BL02EPF00021F68:EE_|SJ2PR12MB7894:EE_
X-MS-Office365-Filtering-Correlation-Id: f08557ea-8b0f-4e1e-1498-08dce844eb21
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700013|1800799024|82310400026|376014|7416014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?eJXGOqAkcUmpuQt6bZaTTcacSn2Ey8afEnJTZxelxk2yEFYD1TZP5YSupKEN?=
 =?us-ascii?Q?CAYLXYfxwhNcZ0KZYGpJ8kAF70QJGUvXK3IquvK2u4AwXyqWOi5On2zlNKPg?=
 =?us-ascii?Q?NFk3ZgMYAz3WHWIhHa55WC4imnye6mg0zPSDYT04VfJ5eXVUxBljz20lgp+m?=
 =?us-ascii?Q?8J+puHW8BCfA1szfMyZS3wrzuK2gUvaGhwN1S8TQQRhRbfB4q6IxE1qdlTuL?=
 =?us-ascii?Q?A33zSQ9Cd2ppqOuYebTAAL9syDTdv46BoRWpuvzh7TJHCqE5fisTpNI7SleF?=
 =?us-ascii?Q?YMsgCMU+QQNB2RLE+IY7R57DW1kAMqGXnfCZn32T7BKJsOYGNpvIfVvMrJNR?=
 =?us-ascii?Q?nL4D6wuwq4rr/CkwWw43qLLVy/Y7Jow9X/MHpymyUpJ254YCZDy2snYvw/eM?=
 =?us-ascii?Q?laiAKBY+L5RiKrtsIO7t+c2OZTuL3tolbjBWNL7jhKbnKYRmX+HI056ZxNjM?=
 =?us-ascii?Q?cbsl1XVLLGk0zkcmRT1aAL2BE2pIyck7rDLlZlTCsYlE1SYQsHJUz8Kkv6CA?=
 =?us-ascii?Q?ogoH6Pu2YY7T/JH98zz9mPnFD+xxyM1W8VQdZ3PFGIWczwapPmNgjlw1fdkS?=
 =?us-ascii?Q?LJHAyBq6mo/q6iB9WNN7k4y4BnIzcqNRtB6RFpN3GmGv3Ck5vOpqlo41+rtL?=
 =?us-ascii?Q?cGB6xx8RPDEef1oGkXwm3wC9UfEPoyNbIObzxMI1ezGT8cWX71RK+Zysuh9R?=
 =?us-ascii?Q?PDexC6seaoNFb/vdCvw4Tex0RRqAWN9YC4Scmm0jR4NCuVdu5TdpocAdr4GA?=
 =?us-ascii?Q?g8I16GnFngcI1Lg376jWfJ2oI/njGONXbJK21be+2MSz8+mAAv2tL/4dxiWY?=
 =?us-ascii?Q?hFoIW1gYEp5SxyUQDQHZy+3piQ0/oJ0rPeMsp9Umzftw/9ir++2HKMtxl/iC?=
 =?us-ascii?Q?nNR02GIi7GQklRINU9kNTtQH9KpBqkNkBDS3sBXQUoKm0tdKg2hA9pIrjByZ?=
 =?us-ascii?Q?oKmmwFK5Q7imqqXG7Z+KjOU2Wsa9GTuEh91b/swzyrq0/mr1KDUNO0Y6/W5Y?=
 =?us-ascii?Q?UxQ4tgVfdA05G3ikRfFSfT4jTxLkZxkRbBX8VzQe7ZhqdlkPUDLfzl8WkK/Y?=
 =?us-ascii?Q?IU26x4lgiDe+T6DG/1ltjQvatS40hJX2PeOr3Tljz9TRWf5Xz/aUUalcA8XC?=
 =?us-ascii?Q?mIvAKZnNg0Skh5d/uMJhgoHNDOmOZIlYGpH1v4raGO83DNDy1Oa/sMKZ5W2H?=
 =?us-ascii?Q?UZGosyJkW8lZr4bL0HEtF/Xp2pIVxq6FpMHXejp/l9G16xBzr4Nb9zpf0JOp?=
 =?us-ascii?Q?Yv2Jsy+km1Xj6rYRdSaDwwMSh1vRytfHNp4UDSBBhupscB9RUaoay9awtM4u?=
 =?us-ascii?Q?OJryr3VfULjLglnKPyMUaXwSrs0UK6lllVrP7ta6NGlgUM9pt+rcu3WUXwH4?=
 =?us-ascii?Q?txV66kE=3D?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(36860700013)(1800799024)(82310400026)(376014)(7416014);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Oct 2024 09:29:47.9064
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: f08557ea-8b0f-4e1e-1498-08dce844eb21
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BL02EPF00021F68.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ2PR12MB7894

Add support for Secure TSC in SNP-enabled guests. Secure TSC allows guests
to securely use RDTSC/RDTSCP instructions, ensuring that the parameters
used cannot be altered by the hypervisor once the guest is launched.

Secure TSC-enabled guests need to query TSC information from the AMD
Security Processor. This communication channel is encrypted between the AMD
Security Processor and the guest, with the hypervisor acting merely as a
conduit to deliver the guest messages to the AMD Security Processor. Each
message is protected with AEAD (AES-256 GCM). Use a minimal AES GCM library
to encrypt and decrypt SNP guest messages for communication with the PSP.

Use mem_encrypt_init() to fetch SNP TSC information from the AMD Security
Processor and initialize snp_tsc_scale and snp_tsc_offset. During secondary
CPU initialization, set the VMSA fields GUEST_TSC_SCALE (offset 2F0h) and
GUEST_TSC_OFFSET (offset 2F8h) with snp_tsc_scale and snp_tsc_offset,
respectively.

Since handle_guest_request() is common routine used by both the SEV guest
driver and Secure TSC code, move it to the SEV header file.

Signed-off-by: Nikunj A Dadhania <nikunj@amd.com>
Tested-by: Peter Gonda <pgonda@google.com>
Reviewed-by: Tom Lendacky <thomas.lendacky@amd.com>
---
 arch/x86/include/asm/sev-common.h |  1 +
 arch/x86/include/asm/sev.h        | 46 ++++++++++++++++
 arch/x86/include/asm/svm.h        |  6 +-
 arch/x86/coco/sev/core.c          | 91 +++++++++++++++++++++++++++++++
 arch/x86/mm/mem_encrypt.c         |  4 ++
 5 files changed, 146 insertions(+), 2 deletions(-)

diff --git a/arch/x86/include/asm/sev-common.h b/arch/x86/include/asm/sev-common.h
index 98726c2b04f8..655eb0ac5032 100644
--- a/arch/x86/include/asm/sev-common.h
+++ b/arch/x86/include/asm/sev-common.h
@@ -206,6 +206,7 @@ struct snp_psc_desc {
 #define GHCB_TERM_NO_SVSM		7	/* SVSM is not advertised in the secrets page */
 #define GHCB_TERM_SVSM_VMPL0		8	/* SVSM is present but has set VMPL to 0 */
 #define GHCB_TERM_SVSM_CAA		9	/* SVSM is present but CAA is not page aligned */
+#define GHCB_TERM_SECURE_TSC		10	/* Secure TSC initialization failed */
 
 #define GHCB_RESP_CODE(v)		((v) & GHCB_MSR_INFO_MASK)
 
diff --git a/arch/x86/include/asm/sev.h b/arch/x86/include/asm/sev.h
index d6ad5f6b1ff3..9169b18eeb78 100644
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
 
@@ -174,6 +177,22 @@ struct snp_guest_msg {
 	u8 payload[PAGE_SIZE - sizeof(struct snp_guest_msg_hdr)];
 } __packed;
 
+#define SNP_TSC_INFO_REQ_SZ	128
+#define SNP_TSC_INFO_RESP_SZ	128
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
@@ -497,6 +516,27 @@ static inline void snp_msg_cleanup(struct snp_msg_desc *mdesc)
 int snp_send_guest_request(struct snp_msg_desc *mdesc, struct snp_guest_req *req,
 			   struct snp_guest_request_ioctl *rio);
 
+static inline int handle_guest_request(struct snp_msg_desc *mdesc, u64 exit_code,
+				       struct snp_guest_request_ioctl *rio, u8 type,
+				       void *req_buf, size_t req_sz, void *resp_buf,
+				       u32 resp_sz)
+{
+	struct snp_guest_req req = {
+		.msg_version	= rio->msg_version,
+		.msg_type	= type,
+		.vmpck_id	= mdesc->vmpck_id,
+		.req_buf	= req_buf,
+		.req_sz		= req_sz,
+		.resp_buf	= resp_buf,
+		.resp_sz	= resp_sz,
+		.exit_code	= exit_code,
+	};
+
+	return snp_send_guest_request(mdesc, &req, rio);
+}
+
+void __init snp_secure_tsc_prepare(void);
+
 #else	/* !CONFIG_AMD_MEM_ENCRYPT */
 
 #define snp_vmpl 0
@@ -538,6 +578,12 @@ static inline struct snp_msg_desc *snp_msg_alloc(void) { return NULL; }
 static inline void snp_msg_cleanup(struct snp_msg_desc *mdesc) { }
 static inline int snp_send_guest_request(struct snp_msg_desc *mdesc, struct snp_guest_req *req,
 					 struct snp_guest_request_ioctl *rio) { return -ENODEV; }
+static inline int handle_guest_request(struct snp_msg_desc *mdesc, u64 exit_code,
+				       struct snp_guest_request_ioctl *rio, u8 type,
+				       void *req_buf, size_t req_sz, void *resp_buf,
+				       u32 resp_sz) { return -ENODEV; }
+
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
diff --git a/arch/x86/coco/sev/core.c b/arch/x86/coco/sev/core.c
index e5e78b04f56c..d7e92fa1f6ff 100644
--- a/arch/x86/coco/sev/core.c
+++ b/arch/x86/coco/sev/core.c
@@ -98,6 +98,10 @@ static u64 secrets_pa __ro_after_init;
 
 static struct snp_msg_desc *snp_mdesc;
 
+/* Secure TSC values read using TSC_INFO SNP Guest request */
+static u64 snp_tsc_scale __ro_after_init;
+static u64 snp_tsc_offset __ro_after_init;
+
 /* #VC handler runtime per-CPU data */
 struct sev_es_runtime_data {
 	struct ghcb ghcb_page;
@@ -1175,6 +1179,12 @@ static int wakeup_cpu_via_vmgexit(u32 apic_id, unsigned long start_ip)
 	vmsa->vmpl		= snp_vmpl;
 	vmsa->sev_features	= sev_status >> 2;
 
+	/* Set Secure TSC parameters */
+	if (cc_platform_has(CC_ATTR_GUEST_SNP_SECURE_TSC)) {
+		vmsa->tsc_scale = snp_tsc_scale;
+		vmsa->tsc_offset = snp_tsc_offset;
+	}
+
 	/* Switch the page over to a VMSA page now that it is initialized */
 	ret = snp_set_vmsa(vmsa, caa, apic_id, true);
 	if (ret) {
@@ -2985,3 +2995,84 @@ int snp_send_guest_request(struct snp_msg_desc *mdesc, struct snp_guest_req *req
 	return 0;
 }
 EXPORT_SYMBOL_GPL(snp_send_guest_request);
+
+static int __init snp_get_tsc_info(void)
+{
+	static u8 buf[SNP_TSC_INFO_RESP_SZ + AUTHTAG_LEN];
+	struct snp_guest_request_ioctl rio;
+	struct snp_tsc_info_resp tsc_resp;
+	struct snp_tsc_info_req *tsc_req;
+	struct snp_msg_desc *mdesc;
+	struct snp_guest_req req;
+	int rc;
+
+	/*
+	 * The intermediate response buffer is used while decrypting the
+	 * response payload. Make sure that it has enough space to cover the
+	 * authtag.
+	 */
+	BUILD_BUG_ON(sizeof(buf) < (sizeof(tsc_resp) + AUTHTAG_LEN));
+
+	mdesc = snp_msg_alloc();
+	if (IS_ERR_OR_NULL(mdesc))
+		return -ENOMEM;
+
+	rc = snp_msg_init(mdesc, snp_vmpl);
+	if (rc)
+		return rc;
+
+	tsc_req = kzalloc(sizeof(struct snp_tsc_info_req), GFP_KERNEL);
+	if (!tsc_req)
+		return -ENOMEM;
+
+	memset(&req, 0, sizeof(req));
+	memset(&rio, 0, sizeof(rio));
+	memset(buf, 0, sizeof(buf));
+
+	req.msg_version = MSG_HDR_VER;
+	req.msg_type = SNP_MSG_TSC_INFO_REQ;
+	req.vmpck_id = snp_vmpl;
+	req.req_buf = tsc_req;
+	req.req_sz = sizeof(*tsc_req);
+	req.resp_buf = buf;
+	req.resp_sz = sizeof(tsc_resp) + AUTHTAG_LEN;
+	req.exit_code = SVM_VMGEXIT_GUEST_REQUEST;
+
+	rc = snp_send_guest_request(mdesc, &req, &rio);
+	if (rc)
+		goto err_req;
+
+	memcpy(&tsc_resp, buf, sizeof(tsc_resp));
+	pr_debug("%s: response status %x scale %llx offset %llx factor %x\n",
+		 __func__, tsc_resp.status, tsc_resp.tsc_scale, tsc_resp.tsc_offset,
+		 tsc_resp.tsc_factor);
+
+	if (tsc_resp.status == 0) {
+		snp_tsc_scale = tsc_resp.tsc_scale;
+		snp_tsc_offset = tsc_resp.tsc_offset;
+	} else {
+		pr_err("Failed to get TSC info, response status %x\n", tsc_resp.status);
+		rc = -EIO;
+	}
+
+err_req:
+	/* The response buffer contains the sensitive data, explicitly clear it. */
+	memzero_explicit(buf, sizeof(buf));
+	memzero_explicit(&tsc_resp, sizeof(tsc_resp));
+	memzero_explicit(&req, sizeof(req));
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
index 0a120d85d7bb..996ca27f0b72 100644
--- a/arch/x86/mm/mem_encrypt.c
+++ b/arch/x86/mm/mem_encrypt.c
@@ -94,6 +94,10 @@ void __init mem_encrypt_init(void)
 	/* Call into SWIOTLB to update the SWIOTLB DMA buffers */
 	swiotlb_update_mem_attributes();
 
+	/* Initialize SNP Secure TSC */
+	if (cc_platform_has(CC_ATTR_GUEST_SEV_SNP))
+		snp_secure_tsc_prepare();
+
 	print_mem_encrypt_feature_info();
 }
 
-- 
2.34.1


