Return-Path: <kvm+bounces-29228-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 38FDF9A59F9
	for <lists+kvm@lfdr.de>; Mon, 21 Oct 2024 07:57:32 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 95648B21119
	for <lists+kvm@lfdr.de>; Mon, 21 Oct 2024 05:57:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5F0BB1CEEBB;
	Mon, 21 Oct 2024 05:57:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="WT3lbEsa"
X-Original-To: kvm@vger.kernel.org
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2047.outbound.protection.outlook.com [40.107.243.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 45D2546B5;
	Mon, 21 Oct 2024 05:57:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.243.47
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729490240; cv=fail; b=rG8G/k3a+mSz76QFKq841++Cq3/nN76GhpSicxrZ+vdKstPXWXIx+Qe+09R6PNMPEjnNWIW5ROORQ0z2p3gqcjbcnVz+mfiXXxdQ+ZH2t2/osiJs3A57a+JtALtPLtxTZatDB3byX9pHTfYAm8J2yJjB8+ufxEN6whdL6SLAsT4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729490240; c=relaxed/simple;
	bh=2cYneHiZ7lhly5g9wC5RnHe5LCa1OiS0PPCqMT8NIxA=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=GH088SLShkiB3td4iQU/eEBnnKlWvXeW4GciqMarbnQMUkhZRs3BwMJM2HjXm9g2qrPAAtTnIYki22mEw+dtTgjplIgrP/iVUBi0pYetEjL3L/TkK/XfbhlJCbS+IYGg0q2HRyA+oVt5KCT29d5JgWurF4E2StkjFIS0zkUvR2w=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=WT3lbEsa; arc=fail smtp.client-ip=40.107.243.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=oj0oEN8DLqBICoAijmEAstkRLXRe7UJDXLXxJRdv97b5QrPa3tieBdg9BrzCtg/jiSnKolJQFfAYYTuNDhZNu5M0/u3iCJBSK+Nt95GX82KHwpZbO9IYEG8h9Kmjhytvy71yA/rlrfSEh+andpkVDbwm0k2FxUBH32JKeKKwrHZzesPReVyI0cKXeczuM/JqdhcHJa2v437mKMH5jNgYAcLT5TQTXdN7J6dz9lI924gTgQ+eFybt7SIjycswatgivahsIirJh7WspAKJ7kBhqrdmBsvWwKcMev6d9sVJ7rvtLYLKwLKIr1e9pQ8ou5nwEMUSi9hiiPY4L8IkNHDfpA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=av7ni6W/FD7sSVHrnAsF5wTB6mM6MxVdUEwzfDVl/7A=;
 b=Zg6O6/tiflQ3R1XqRoIcYAr+PS0syWE0FO3oLaZYP4ia2nrVEvdqgMaXJMoUOuXvtHeorm7y7eLI6JMp0y3QCY6lEjiv43zGMoD10+LURF6Ey2ixe8M2sf2vhymwBu9lyZayqR4eGz6gZYKJ2qkkPyNukHIhxM1GboFWJKGSUu7ADM7oqF0/2uSXHdhB2Y14HFeBIe64HBJKqIWsjArMKyto1nhxkVjrGsSS1yMvA5Jtp2sRmcphV//4cA2y85mOK5EygdEv8fVdnmfRqgbYGIaYAGyJZq52MK+TJwPJadqIkVVVJurrkygVyKZ3+ky+ueoERWtXmSNZy5732ioyrA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=av7ni6W/FD7sSVHrnAsF5wTB6mM6MxVdUEwzfDVl/7A=;
 b=WT3lbEsawTdo7EXi8v+H6pOwxyMkEk6dwWDD6TsE5KcItRzVCf2gOOAsHCNUYq0RsepCgKFCMes68lacjLwvEnJrVTwh01Wea3Qhz4R9PJuVSLqn38Sa7M8zOs1dViWCcorpuEnSMbThnxB8MEAoPIU0tWLpNQGjuolngdOCNTo=
Received: from SJ0PR05CA0018.namprd05.prod.outlook.com (2603:10b6:a03:33b::23)
 by PH7PR12MB5830.namprd12.prod.outlook.com (2603:10b6:510:1d5::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8069.28; Mon, 21 Oct
 2024 05:57:12 +0000
Received: from SJ5PEPF000001D3.namprd05.prod.outlook.com
 (2603:10b6:a03:33b:cafe::86) by SJ0PR05CA0018.outlook.office365.com
 (2603:10b6:a03:33b::23) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8093.15 via Frontend
 Transport; Mon, 21 Oct 2024 05:57:12 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 SJ5PEPF000001D3.mail.protection.outlook.com (10.167.242.55) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.8093.14 via Frontend Transport; Mon, 21 Oct 2024 05:57:12 +0000
Received: from gomati.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Mon, 21 Oct
 2024 00:54:43 -0500
From: Nikunj A Dadhania <nikunj@amd.com>
To: <linux-kernel@vger.kernel.org>, <thomas.lendacky@amd.com>, <bp@alien8.de>,
	<x86@kernel.org>, <kvm@vger.kernel.org>
CC: <mingo@redhat.com>, <tglx@linutronix.de>, <dave.hansen@linux.intel.com>,
	<pgonda@google.com>, <seanjc@google.com>, <pbonzini@redhat.com>,
	<nikunj@amd.com>
Subject: [PATCH v13 03/13] x86/sev: Add Secure TSC support for SNP guests
Date: Mon, 21 Oct 2024 11:21:46 +0530
Message-ID: <20241021055156.2342564-4-nikunj@amd.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20241021055156.2342564-1-nikunj@amd.com>
References: <20241021055156.2342564-1-nikunj@amd.com>
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
X-MS-TrafficTypeDiagnostic: SJ5PEPF000001D3:EE_|PH7PR12MB5830:EE_
X-MS-Office365-Filtering-Correlation-Id: 1e2018eb-b566-4c2b-64d0-08dcf1953528
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|376014|82310400026|1800799024|36860700013;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?eB2VolvVTcebyKjGEmyAFn81UmqnfCrC/Ztf7hjZbaz78z6YmLfdWT/q1wb5?=
 =?us-ascii?Q?TWs4YsvU3uXzpOa4P9UrYrGqritqVCYZyUGdv6DH4uizfch1752JjYHdcHzd?=
 =?us-ascii?Q?dKc1cnt6Ym0GJO4SI6yQJwejZi50VCHPgKLeZw8TbW6eEiBRG2b1e4h90fEj?=
 =?us-ascii?Q?MP3HQTGBd8UBoODZqT2pBl1cxVNmoPpMZqGZ72MxC+JtNR1lmT4EAs1v8c8J?=
 =?us-ascii?Q?7nB2dsyAKMxd2sLriZ5M+5YxTPVzRB+rFOwMoB7fMK6DHPjhgUWaZOvw5OUZ?=
 =?us-ascii?Q?Yd7xS7tQ/oVJU4GdmDyg8rwUt0pEpa/B4BGcQ/mFEPhu3iJF/ypUfnVkylCT?=
 =?us-ascii?Q?fY6nneeJ67jUX2zQv08h/43WbeIOVwvSCKaeMp563s3xT/iRmzdLuXVKgbE0?=
 =?us-ascii?Q?8SrcKLapYBVOYgWzsVjXkx+rO8oq63y/fkmEdHi4YcvW5cBzTnV+yrxrqUQM?=
 =?us-ascii?Q?yYtdmLrF6k3TDQ+N1A+peIvN8qT7lhg2pV9spb2RzU85EQQHMe4kn4ZZEz4R?=
 =?us-ascii?Q?hvvwdLO3KLSoa0JOmbXOVTHTYXMFqdGa1m4nVWZm6x+ogNvDiexVQ+k8nRQF?=
 =?us-ascii?Q?9xMnRGg/nMumdfbyGbgQFOVgqTFFybnNv1UR/zcYi8V3KzilMiK7lvbvqZkc?=
 =?us-ascii?Q?en/FZbJxExg8x51ZVS/Xt5xzT4PHaWpYLu28uboC2SYbey+Cm4DYUKYupLWn?=
 =?us-ascii?Q?1ZwZReOOIYqWDsCvOKsRxxoiOGU8HnRMEfr+59WKJYAUOL6ufph5h4Je/k3E?=
 =?us-ascii?Q?+6/+KYKKUaSg/3DSp/JE+yZEwwZ4L85cy81SPYm9MkF9pJ/WykLPKnbGckV1?=
 =?us-ascii?Q?UX5t5/0+yxmm9QNXjpX4V2yEI0KCpy3DKBrjkaTuvLmKsSNB8/f29eiCkqzZ?=
 =?us-ascii?Q?aebWF3SoKJHi+HBoLCnkGcmDCzqPacig0vmWiWORhNAfqlk0mZwaC1YUgbsq?=
 =?us-ascii?Q?IroK/WdO7BoYVoG+RGyXXmp0s0Co3VfRsJgPGlQvEM4Zr1VN+d9PrFjQgdb2?=
 =?us-ascii?Q?aUJqLbiwhQAfG6EzoF+PAZBkGjdDhG988n7k7Os0dTRw500z18uj+pa+pgd4?=
 =?us-ascii?Q?s/uVT7uVlQ2ug8xRnhdvrobAmTIC3WsXwThBzSL3W430C+xHyg1Sp95HBOkc?=
 =?us-ascii?Q?uV8sLTtJbodoD2jGqsCrDg2TfvNlxUcr+n/wBHPGRLcEA57qj1NdY8sHIusU?=
 =?us-ascii?Q?r75NoGqihthSgOT6Kpm7vrCf1TUT0NY1SSwg1J2Z1KdMLHwgfCpn4GL4M4AP?=
 =?us-ascii?Q?7YC0zlvjlJNfgANky6keP8cHNSaIayqM8tuoOREKXgfzWRjaqj1xLCg0san5?=
 =?us-ascii?Q?3DBcp8BXsgVactshkCPmgiPa6KrSy1twjc2KEXPN1s4sxmdrJuZZPo2BbZHE?=
 =?us-ascii?Q?q09e2m6a/GSWEbrHTTbGWlxn8YSrBA8f+wITJ+/irpt1lndalA=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(7416014)(376014)(82310400026)(1800799024)(36860700013);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Oct 2024 05:57:12.2466
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 1e2018eb-b566-4c2b-64d0-08dcf1953528
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SJ5PEPF000001D3.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB5830

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

Add confidential compute platform attribute CC_ATTR_GUEST_SNP_SECURE_TSC
that can be used by the guest to query whether the Secure TSC feature is
active.

Since handle_guest_request() is common routine used by both the SEV guest
driver and Secure TSC code, move it to the SEV header file.

Signed-off-by: Nikunj A Dadhania <nikunj@amd.com>
Tested-by: Peter Gonda <pgonda@google.com>
Reviewed-by: Tom Lendacky <thomas.lendacky@amd.com>
---
 arch/x86/include/asm/sev-common.h |  1 +
 arch/x86/include/asm/sev.h        | 46 ++++++++++++++++
 arch/x86/include/asm/svm.h        |  6 +-
 include/linux/cc_platform.h       |  8 +++
 arch/x86/coco/core.c              |  3 +
 arch/x86/coco/sev/core.c          | 91 +++++++++++++++++++++++++++++++
 arch/x86/mm/mem_encrypt.c         |  4 ++
 7 files changed, 157 insertions(+), 2 deletions(-)

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
diff --git a/include/linux/cc_platform.h b/include/linux/cc_platform.h
index caa4b4430634..cb7103dc124f 100644
--- a/include/linux/cc_platform.h
+++ b/include/linux/cc_platform.h
@@ -88,6 +88,14 @@ enum cc_attr {
 	 * enabled to run SEV-SNP guests.
 	 */
 	CC_ATTR_HOST_SEV_SNP,
+
+	/**
+	 * @CC_ATTR_GUEST_SNP_SECURE_TSC: SNP Secure TSC is active.
+	 *
+	 * The platform/OS is running as a guest/virtual machine and actively
+	 * using AMD SEV-SNP Secure TSC feature.
+	 */
+	CC_ATTR_GUEST_SNP_SECURE_TSC,
 };
 
 #ifdef CONFIG_ARCH_HAS_CC_PLATFORM
diff --git a/arch/x86/coco/core.c b/arch/x86/coco/core.c
index 0f81f70aca82..5b9a358a3254 100644
--- a/arch/x86/coco/core.c
+++ b/arch/x86/coco/core.c
@@ -100,6 +100,9 @@ static bool noinstr amd_cc_platform_has(enum cc_attr attr)
 	case CC_ATTR_HOST_SEV_SNP:
 		return cc_flags.host_sev_snp;
 
+	case CC_ATTR_GUEST_SNP_SECURE_TSC:
+		return sev_status & MSR_AMD64_SNP_SECURE_TSC;
+
 	default:
 		return false;
 	}
diff --git a/arch/x86/coco/sev/core.c b/arch/x86/coco/sev/core.c
index c96b742789c5..965209067f03 100644
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
@@ -1148,6 +1152,12 @@ static int wakeup_cpu_via_vmgexit(u32 apic_id, unsigned long start_ip)
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
@@ -2942,3 +2952,84 @@ int snp_send_guest_request(struct snp_msg_desc *mdesc, struct snp_guest_req *req
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


