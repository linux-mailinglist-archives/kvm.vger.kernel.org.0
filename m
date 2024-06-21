Return-Path: <kvm+bounces-20265-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id B060D9125D1
	for <lists+kvm@lfdr.de>; Fri, 21 Jun 2024 14:46:50 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id D302A1C204F6
	for <lists+kvm@lfdr.de>; Fri, 21 Jun 2024 12:46:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 35F2B176FA7;
	Fri, 21 Jun 2024 12:40:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="E8zfnDk+"
X-Original-To: kvm@vger.kernel.org
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2058.outbound.protection.outlook.com [40.107.220.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9BE1C176AD6;
	Fri, 21 Jun 2024 12:40:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.220.58
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718973637; cv=fail; b=O9lY25sqBZ37SqLQA1i8j6YLr0/VGwN6NaYEtwzcXYWdwQImAnk8kOz5CpNSujqjQ2OaIJnFSUxgJuKrjEpFQ2QqqdlvPp6GlpO+slFTZSAAu9Ue3TOe1x3V03hyKgltC0AlN1YTzJLdciAg02gfsVMRwAhA+owfscSacwAzNyw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718973637; c=relaxed/simple;
	bh=i0kENcj60qGZYsyiYTxQUz4TJ/zM+XC5TOE1U2zUGoQ=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=kU4eI08OCRwiSXsNbZxgv9xnNRh0BQ7U6AKucCwLyOo500cOST+dNLegMVI9ICxxUfUQkB/pcLv8d0OlvnqC2Iz9NTmHlrKNmmiRoCUblPxo0cTr/uWOQspJU0cT63NNI6DjvsIY7ofrIZQ7HDQ2mY3cAb2Z8Z8HVU2QEFWuKkc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=E8zfnDk+; arc=fail smtp.client-ip=40.107.220.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=DW6/LZsLVk81YO6bIqrb9Ch0F+4NWTJVV8jZ1VL4OgUwx3RvYUK7FedF0FmNtAijwj9GjCtIgpiREYFo8BXxS7I9Vj0fPuAD+1JYMyHRb67Kk05weiBUKdck2l6DORs9uawlr4HdbSg2jCISoVQWz2VGWjvV627XXqfSRmjqzBzNU7nsjIXhf6Zffo/XAGvv8qnsftlYxFWj4UoFD76gLVnb22sLPukABq0YRFvJ9E1wJ+38HS1sSxb25xL0Ug831ayuQQB0a6MuS80SGddCvIkwKs3Bn1MbShBVTeXRpAszBxBKUob0NGURjA2NFD6e9LD5aYDqj0i0qAHiBSnHLw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=5Es21Umwwn5PpUyX9jS0LB5uwpqpirnODpdwQo6olrU=;
 b=QRGgB0hF8L/AXOMRh0yV/M0GyXlM2U3esDjHegX2+/he9Nltud3z1nnW7DI2IyQJ0wpUH3cAulsMrw2zwkrR1ECbdXPCgCAbkqsjV6K06R7HFFbk1F5u1uRiXkG0WV99oZ0S29rpsvjeKAX8TXeek3F8aG8MN7Ji66RUqTiLarj7/9mYHGxdYDvH/bUERftPq9cawXAbM1fni5tgUl12pHA2+gPWaAITfjdlTvHG/QdT8ORbYTxEYgfEH5d4t7+1UvyfkXCAGVTsU+Bmr+WM46lca8jaQn54ad5YBGVXdkGhXvMxYHy9WwvHmSOD2xjzFNRN83wjqg5KdFZULm1tUw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5Es21Umwwn5PpUyX9jS0LB5uwpqpirnODpdwQo6olrU=;
 b=E8zfnDk+TVaIXra7MD9aq5AtrnVjhfoWkCKW+O37xFYBb3xjhAA4mV+thWibIjB+QSmeP33isveD+403PEtk7XA3oLa42d5Hf8Hb8nbKVmScHsfQKE5M77ci5Rk7+riMqn+SlC6h/sBdPX+8BiI+2kEfhJpTtKgYIY9WeE2DFso=
Received: from DS0PR17CA0018.namprd17.prod.outlook.com (2603:10b6:8:191::18)
 by PH8PR12MB7133.namprd12.prod.outlook.com (2603:10b6:510:22e::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7677.30; Fri, 21 Jun
 2024 12:40:33 +0000
Received: from DS3PEPF0000C37E.namprd04.prod.outlook.com
 (2603:10b6:8:191:cafe::c) by DS0PR17CA0018.outlook.office365.com
 (2603:10b6:8:191::18) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7677.36 via Frontend
 Transport; Fri, 21 Jun 2024 12:40:33 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 DS3PEPF0000C37E.mail.protection.outlook.com (10.167.23.8) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.7677.15 via Frontend Transport; Fri, 21 Jun 2024 12:40:33 +0000
Received: from gomati.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Fri, 21 Jun
 2024 07:40:27 -0500
From: Nikunj A Dadhania <nikunj@amd.com>
To: <linux-kernel@vger.kernel.org>, <thomas.lendacky@amd.com>, <bp@alien8.de>,
	<x86@kernel.org>, <kvm@vger.kernel.org>
CC: <mingo@redhat.com>, <tglx@linutronix.de>, <dave.hansen@linux.intel.com>,
	<pgonda@google.com>, <seanjc@google.com>, <pbonzini@redhat.com>,
	<nikunj@amd.com>
Subject: [PATCH v10 18/24] x86/sev: Add Secure TSC support for SNP guests
Date: Fri, 21 Jun 2024 18:08:57 +0530
Message-ID: <20240621123903.2411843-19-nikunj@amd.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20240621123903.2411843-1-nikunj@amd.com>
References: <20240621123903.2411843-1-nikunj@amd.com>
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
X-MS-TrafficTypeDiagnostic: DS3PEPF0000C37E:EE_|PH8PR12MB7133:EE_
X-MS-Office365-Filtering-Correlation-Id: fd59bf99-9172-471a-9504-08dc91ef5786
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230037|82310400023|7416011|376011|1800799021|36860700010;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?p3I6Iq+HCqmsZ4lF7saLEedn8aIZsPnZWWEFBDffG7sxXwD1ffG2OE/wYzY3?=
 =?us-ascii?Q?UJHoU15n2eM1ngzCjTYVKYAr5x8eY9AMMsOEBG5/S6uGAfAjx624sDt+quXT?=
 =?us-ascii?Q?Q/UC9BE1IDcOSxyTrjay/qT3lHvksFZEJT+CXhQN6uBQqWagqgkQYg/rw7da?=
 =?us-ascii?Q?HumtqaXlc/htOQD80OPVo+hk3j9Hcs2CDhIYGCzFhu8agmkLR7cDgtdh6xC3?=
 =?us-ascii?Q?YEO4uZOHhGPL/fsEAKx4Wl5M/pjidEYJiffKBq4d+nBFni6DY01KaelKkEGt?=
 =?us-ascii?Q?B6rYCMlji8LspiqpS0tw3bGjsazkFIIirskgmu3I9mkzVXXaRrWr7uzzV/Mz?=
 =?us-ascii?Q?rvq0/YZbeOanKHvwX1g7QNn1CfDShfwMaelNzZ5QrZ7G3HlQZIT+s92L2M2E?=
 =?us-ascii?Q?HT36j9j+TGHhnuXWRLFScX9UisG2tWTnaDu/rs2tt4399vM7R6vSBvYhTkbp?=
 =?us-ascii?Q?qEGzU5tanAU0tBQuvKsChR9c3ArTZCJsfsVEaCPM/HDxYMYpLRt8ceLw3Z66?=
 =?us-ascii?Q?oLy58v6e5ZqXCgwAf7vcjN4wJdQxQBUK1CCiSTL1W96By7qESfR815j3VgrV?=
 =?us-ascii?Q?oOo1NZ8WyDOSIsFNbKqsNT7aRYQfXQMPf+K3pO5bKNFeGpNhBeyiI3EMUNMS?=
 =?us-ascii?Q?HbKlEzQYuPKhfppzAXjblMjLb/2Ti6EgfrTt13NE37uWRqWp83CmZ264Fby8?=
 =?us-ascii?Q?le81yoWj3PR20pRbF4hqd74DekTen4blO8X5tIDu8r4+SMRMUMEARhH1fJBo?=
 =?us-ascii?Q?2VCUSiQVJLZMtkbUn5GkSgSO6luuv3sqiPkIlQ11AxyONnh6ivh+tFMBtSfp?=
 =?us-ascii?Q?q3RtSLlLb94k6HSbX4Z33LdtbN8qkbvTrTmF3hs3nNwChGczyBzZ73W1cjLf?=
 =?us-ascii?Q?FvLVbH7x5acJxnzI3eZbXQenubCg+Xq7Gk5iS8IB7Kc3h2BQYV3V47D+caoj?=
 =?us-ascii?Q?K8d0aka7kOyriQ2ziOxL3eZJBUK9LEle9Qsit9bUu2PFRH4Yul00bHeUuz8F?=
 =?us-ascii?Q?XfqTTNq8PXtv5ZnhAiabPnHzutKGW3y1TSj2lLZ+lmps9p77NR57xAK4khxX?=
 =?us-ascii?Q?a4Xg17MvLp/pGa2NGlYrTmIOx4PVJA8adRno4NBqvV3b0E8Y4D6BgbiEmzK9?=
 =?us-ascii?Q?qU8f4z1c0MakPMeufz8wc1zVYHzngwp/XH/ia18lJx+QHNjelIIKCH7RU2mV?=
 =?us-ascii?Q?csP7bnKRHisDbAFJCa5LhJdMaEicBXjPuFJrpPaY7kyMPgl16iogPMFVv5bT?=
 =?us-ascii?Q?gZAHVfHDSiYcSSrr5vCTe84jzQf8QFvKqhWnEU5uT39bwF7pW+7SxXPeLCw2?=
 =?us-ascii?Q?1uiliXkZOuCvATMxABdBrh3RsxzA7GCP9NaWPdgwW+cDF427zij90ew34cmM?=
 =?us-ascii?Q?94CPcty4ZYitfD2sws44RDZ5muWyb2iXSttk1ylZSt0G+6xa3g=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230037)(82310400023)(7416011)(376011)(1800799021)(36860700010);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Jun 2024 12:40:33.0166
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: fd59bf99-9172-471a-9504-08dc91ef5786
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DS3PEPF0000C37E.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH8PR12MB7133

Add support for Secure TSC in SNP enabled guests. Secure TSC allows guest
to securely use RDTSC/RDTSCP instructions as the parameters being used
cannot be changed by the hypervisor once the guest is launched.

Secure TSC enabled guests need to query TSC info from the AMD Security
Processor. This communication channel is encrypted between the AMD Security
Processor and the guest, the hypervisor is just the conduit to deliver the
guest messages to the AMD Security Processor. Each message is protected
with an AEAD (AES-256 GCM). Use minimal AES GCM library to encrypt/decrypt
SNP Guest messages to communicate with the PSP.

Use the mem_encrypt_init() to fetch SNP TSC info from the AMD Security
Processor and initialize the snp_tsc_scale and snp_tsc_offset. During
secondary CPU initialization set VMSA fields GUEST_TSC_SCALE (offset 2F0h)
and GUEST_TSC_OFFSET(offset 2F8h) with snp_tsc_scale and snp_tsc_offset
respectively.

Signed-off-by: Nikunj A Dadhania <nikunj@amd.com>
Tested-by: Peter Gonda <pgonda@google.com>
---
 arch/x86/include/asm/sev-common.h |  1 +
 arch/x86/include/asm/sev.h        | 22 ++++++++
 arch/x86/include/asm/svm.h        |  6 ++-
 arch/x86/coco/sev/core.c          | 90 +++++++++++++++++++++++++++++++
 arch/x86/mm/mem_encrypt.c         |  4 ++
 5 files changed, 121 insertions(+), 2 deletions(-)

diff --git a/arch/x86/include/asm/sev-common.h b/arch/x86/include/asm/sev-common.h
index e90d403f2068..4cb3ea6564da 100644
--- a/arch/x86/include/asm/sev-common.h
+++ b/arch/x86/include/asm/sev-common.h
@@ -181,6 +181,7 @@ struct snp_psc_desc {
 #define GHCB_TERM_NO_SVSM		7	/* SVSM is not advertised in the secrets page */
 #define GHCB_TERM_SVSM_VMPL0		8	/* SVSM is present but has set VMPL to 0 */
 #define GHCB_TERM_SVSM_CAA		9	/* SVSM is present but CAA is not page aligned */
+#define GHCB_TERM_SECURE_TSC		10	/* Secure TSC initialization failed */
 
 #define GHCB_RESP_CODE(v)		((v) & GHCB_MSR_INFO_MASK)
 
diff --git a/arch/x86/include/asm/sev.h b/arch/x86/include/asm/sev.h
index c5ead3230d18..f2ce29345163 100644
--- a/arch/x86/include/asm/sev.h
+++ b/arch/x86/include/asm/sev.h
@@ -160,6 +160,9 @@ enum msg_type {
 	SNP_MSG_VMRK_REQ,
 	SNP_MSG_VMRK_RSP,
 
+	SNP_MSG_TSC_INFO_REQ = 17,
+	SNP_MSG_TSC_INFO_RSP,
+
 	SNP_MSG_TYPE_MAX
 };
 
@@ -191,6 +194,22 @@ struct snp_guest_msg {
 #define SNP_GUEST_MSG_SIZE 4096
 #define SNP_GUEST_MSG_PAYLOAD_SIZE (SNP_GUEST_MSG_SIZE - sizeof(struct snp_guest_msg))
 
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
 struct snp_guest_dev {
 	struct device *dev;
 	struct miscdevice misc;
@@ -212,6 +231,7 @@ struct snp_guest_dev {
 		struct snp_report_req report;
 		struct snp_derived_key_req derived_key;
 		struct snp_ext_report_req ext_report;
+		struct snp_tsc_info_req tsc_info;
 	} req;
 	unsigned int vmpck_id;
 };
@@ -481,6 +501,7 @@ static inline void *alloc_shared_pages(size_t sz)
 	return page_address(page);
 }
 
+void __init snp_secure_tsc_prepare(void);
 
 #else	/* !CONFIG_AMD_MEM_ENCRYPT */
 
@@ -522,6 +543,7 @@ static inline int snp_send_guest_request(struct snp_guest_dev *snp_dev, struct s
 					 struct snp_guest_request_ioctl *rio) { return -EINVAL; }
 static inline void free_shared_pages(void *buf, size_t sz) { }
 static inline void *alloc_shared_pages(size_t sz) { return NULL; }
+static inline void __init snp_secure_tsc_prepare(void) { }
 
 #endif	/* CONFIG_AMD_MEM_ENCRYPT */
 
diff --git a/arch/x86/include/asm/svm.h b/arch/x86/include/asm/svm.h
index 728c98175b9c..91d6c8a79aa2 100644
--- a/arch/x86/include/asm/svm.h
+++ b/arch/x86/include/asm/svm.h
@@ -410,7 +410,9 @@ struct sev_es_save_area {
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
@@ -542,7 +544,7 @@ static inline void __unused_size_checks(void)
 	BUILD_BUG_RESERVED_OFFSET(sev_es_save_area, 0x1c0);
 	BUILD_BUG_RESERVED_OFFSET(sev_es_save_area, 0x248);
 	BUILD_BUG_RESERVED_OFFSET(sev_es_save_area, 0x298);
-	BUILD_BUG_RESERVED_OFFSET(sev_es_save_area, 0x2f0);
+	BUILD_BUG_RESERVED_OFFSET(sev_es_save_area, 0x300);
 	BUILD_BUG_RESERVED_OFFSET(sev_es_save_area, 0x320);
 	BUILD_BUG_RESERVED_OFFSET(sev_es_save_area, 0x380);
 	BUILD_BUG_RESERVED_OFFSET(sev_es_save_area, 0x3f0);
diff --git a/arch/x86/coco/sev/core.c b/arch/x86/coco/sev/core.c
index e0b79e292fcf..7aed6819930b 100644
--- a/arch/x86/coco/sev/core.c
+++ b/arch/x86/coco/sev/core.c
@@ -96,6 +96,10 @@ static u64 sev_hv_features __ro_after_init;
 /* Secrets page physical address from the CC blob */
 static u64 secrets_pa __ro_after_init;
 
+/* Secure TSC values read using TSC_INFO SNP Guest request */
+static u64 snp_tsc_scale __ro_after_init;
+static u64 snp_tsc_offset __ro_after_init;
+
 /* #VC handler runtime per-CPU data */
 struct sev_es_runtime_data {
 	struct ghcb ghcb_page;
@@ -1173,6 +1177,12 @@ static int wakeup_cpu_via_vmgexit(u32 apic_id, unsigned long start_ip)
 	vmsa->vmpl		= snp_vmpl;
 	vmsa->sev_features	= sev_status >> 2;
 
+	/* Set Secure TSC parameters */
+	if (cc_platform_has(CC_ATTR_GUEST_SECURE_TSC)) {
+		vmsa->tsc_scale = snp_tsc_scale;
+		vmsa->tsc_offset = snp_tsc_offset;
+	}
+
 	/* Switch the page over to a VMSA page now that it is initialized */
 	ret = snp_set_vmsa(vmsa, caa, apic_id, true);
 	if (ret) {
@@ -2965,3 +2975,83 @@ void snp_guest_messaging_exit(struct snp_guest_dev *snp_dev)
 	iounmap(snp_dev->secrets);
 }
 EXPORT_SYMBOL_GPL(snp_guest_messaging_exit);
+
+static struct snp_guest_dev tsc_snp_dev __initdata;
+
+static int __init snp_get_tsc_info(void)
+{
+	struct snp_tsc_info_req *tsc_req = &tsc_snp_dev.req.tsc_info;
+	static u8 buf[SNP_TSC_INFO_RESP_SZ + AUTHTAG_LEN];
+	struct snp_guest_request_ioctl rio;
+	struct snp_tsc_info_resp tsc_resp;
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
+	if (!snp_assign_vmpck(&tsc_snp_dev, 0))
+		return -EINVAL;
+
+	rc = snp_guest_messaging_init(&tsc_snp_dev);
+	if (rc)
+		return rc;
+
+	memset(tsc_req, 0, sizeof(*tsc_req));
+	memset(&req, 0, sizeof(req));
+	memset(&rio, 0, sizeof(rio));
+	memset(buf, 0, sizeof(buf));
+
+	req.msg_version = MSG_HDR_VER;
+	req.msg_type = SNP_MSG_TSC_INFO_REQ;
+	req.vmpck_id = tsc_snp_dev.vmpck_id;
+	req.req_buf = tsc_req;
+	req.req_sz = sizeof(*tsc_req);
+	req.resp_buf = buf;
+	req.resp_sz = sizeof(tsc_resp) + AUTHTAG_LEN;
+	req.exit_code = SVM_VMGEXIT_GUEST_REQUEST;
+
+	rc = snp_send_guest_request(&tsc_snp_dev, &req, &rio);
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
+	snp_guest_messaging_exit(&tsc_snp_dev);
+
+	return rc;
+}
+
+void __init snp_secure_tsc_prepare(void)
+{
+	if (!cc_platform_has(CC_ATTR_GUEST_SECURE_TSC))
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


