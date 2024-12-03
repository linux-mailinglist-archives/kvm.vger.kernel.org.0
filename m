Return-Path: <kvm+bounces-32902-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id F2FFA9E18E2
	for <lists+kvm@lfdr.de>; Tue,  3 Dec 2024 11:10:33 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 3BC36B357DE
	for <lists+kvm@lfdr.de>; Tue,  3 Dec 2024 09:02:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C81A11DFD84;
	Tue,  3 Dec 2024 09:01:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="m3o7GOfi"
X-Original-To: kvm@vger.kernel.org
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2072.outbound.protection.outlook.com [40.107.92.72])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 75CF61DED7B;
	Tue,  3 Dec 2024 09:01:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.92.72
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733216491; cv=fail; b=mEHmLgoD9NAtFvyq6Hc3cQUYTvAeE5AlOdzxUANvMlLCUItzMn0/REKR1HQnJvTnTLb8G//jpq+JgwPKL2OmL+au2y2hcR6l+2kuzRhEZmYTchPiYNMq+4K4h1sFgLooQUBmYXU+1WQY4j5k13QCAS56eoOcGiX89Ep07P3id+I=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733216491; c=relaxed/simple;
	bh=IXLNWsV9sKb5nADPd61OXSqhkiGqNvdMP/TJnGan+GQ=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=CbL9qF65IycVlq4gnjPWBtZgiu6cBsfSCWqLXXURal6NlfG/AM07BTVtkl0Q7tvIKCIVA58J+mevsGgtj85+1Lv77uJHaTGMQkloqbMsJ7adgn8vf3CCscb6NGOxWbtfivurmT5GIjbE5gpz0UvWb9uDOCtKvesI7GFmTo7c75k=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=m3o7GOfi; arc=fail smtp.client-ip=40.107.92.72
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=UVhhRgUhFx1NIbdEPiJOVtPOrVCjfF+sKFCUtw6NZUJgWsh5bFORjA5bnzIdxzz8zofTfCpfspLbigPFNfjOyzjnSuWmxBmHNDbewa8ohFD9ow7I1yID4Lje9hCB8Yw2N5WHHBGuOndica1SRu1wIZ3J133nACb9PrzvqyWwEHiT3CmVa8Bl4LCm0CCr0hxCZGGbeGQnsHEOsRLCWLFZ708U/4br6RUjEoBRpHK7tqNNTgCHs/+jhQypsE0+IouM2ZjpeHEKQPXV/T/9ie+jbIptnOb8/eNKsmLUIKeNZ9l5upULKjXfV0dhdb4GB3oJRai8xlEcPd4xDzvooKa1qg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=yw9z+VxqVynV0S6nQaMMizVq7s1ywCddudECnIr6VtY=;
 b=zPfPs61IM//ARTKAdLZL7GMqjNsunNtxF6IR4fvsTah7wZ+frwv1wUcH0TrGvhK+34YQYJBHxxjDvIJB/jD0CSYo7AUQ0Zrh0gwT6kq1LUwIihRhK3q0HAxUnJzBATCpYQoORYPb5128gL7z0r8t6ZY0zVUFke6ArxvkbCDR/kFIWumG4n35ylhH12vdDIKS1ZWhMrOXsCWpBQcLuwe4xfuNRnsDiInZvXd4AQuYe0esH5sdqabYj7oFXKG6clqrFlCjxQ4UoaWvj9IB4YK+Xrd8c/ZlmkeC82jGBaSe0lb0S6fe1kXJI7qWc0QFJjowEw2UKbF/IrlX67omYpjFyQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=yw9z+VxqVynV0S6nQaMMizVq7s1ywCddudECnIr6VtY=;
 b=m3o7GOfiHu4SD9pns5qfEH6FWzUZidsFqOZNAF2qVJ4bPQt7we9E3RRQTGJQ50CDtDBJ/WPGNv8k/YYBXgpcLWvSXJsJqqjnkJrV40d3yDno16V4kQwUzYL5jm1Q6IFmn87Q3Ue0cHStxViGb0VfWSNwM4rGllAF6r6a+eIv7tE=
Received: from CH0P221CA0029.NAMP221.PROD.OUTLOOK.COM (2603:10b6:610:11d::7)
 by CY5PR12MB6203.namprd12.prod.outlook.com (2603:10b6:930:24::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8207.18; Tue, 3 Dec
 2024 09:01:20 +0000
Received: from CH1PEPF0000A349.namprd04.prod.outlook.com
 (2603:10b6:610:11d:cafe::40) by CH0P221CA0029.outlook.office365.com
 (2603:10b6:610:11d::7) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8207.19 via Frontend Transport; Tue,
 3 Dec 2024 09:01:19 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 CH1PEPF0000A349.mail.protection.outlook.com (10.167.244.9) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.8230.7 via Frontend Transport; Tue, 3 Dec 2024 09:01:19 +0000
Received: from gomati.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Tue, 3 Dec
 2024 03:01:15 -0600
From: Nikunj A Dadhania <nikunj@amd.com>
To: <linux-kernel@vger.kernel.org>, <thomas.lendacky@amd.com>, <bp@alien8.de>,
	<x86@kernel.org>, <kvm@vger.kernel.org>
CC: <mingo@redhat.com>, <tglx@linutronix.de>, <dave.hansen@linux.intel.com>,
	<pgonda@google.com>, <seanjc@google.com>, <pbonzini@redhat.com>,
	<nikunj@amd.com>
Subject: [PATCH v15 03/13] x86/sev: Add Secure TSC support for SNP guests
Date: Tue, 3 Dec 2024 14:30:35 +0530
Message-ID: <20241203090045.942078-4-nikunj@amd.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20241203090045.942078-1-nikunj@amd.com>
References: <20241203090045.942078-1-nikunj@amd.com>
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
X-MS-TrafficTypeDiagnostic: CH1PEPF0000A349:EE_|CY5PR12MB6203:EE_
X-MS-Office365-Filtering-Correlation-Id: fdfc8240-0ca6-4183-99ac-08dd13790db1
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700013|1800799024|82310400026|376014|7416014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?+uIrslOAvpgiKWBPyOPJj40WYLPz0Tpe5VaXBejVvYPDyJawdKktqJtt6V86?=
 =?us-ascii?Q?VSh1w8IDXg7nvYSUIfD4zegtJZxcxxdo8msO4uROPe4NfVU9XsTOW9zP+MOW?=
 =?us-ascii?Q?K6F4EAko66R/WzuU6TpCGKChcZlD2lavTH02F78e2L3YrCISf/UTqto53OlF?=
 =?us-ascii?Q?4TV5HZEjRzuz4NY3qMI2g7q4iF5+c4TPQEfYHXqtwNywrwmulFdx8M4+a2QB?=
 =?us-ascii?Q?5mjTgOMtRsFxXEmoybEDTVKzMnc1Cnb8m4EXoy3B2bNkHB6wc76izeIjevxf?=
 =?us-ascii?Q?WWCmqnvPeJJuGXSJZyIEq2TBM+394+11gJDggPzrb93Ut5dM5bV1CViv35S7?=
 =?us-ascii?Q?LMrxxw9BpRGj4WK9Ke2E/QlprgRnQVuYIs4rzoo0Icq5mHOFRFBALoGFpzX8?=
 =?us-ascii?Q?FMsGEV0XLpHJpl994cbUOHZx7gy2/SjXNWhf059IWj4eXqauqORLkLNIoWtc?=
 =?us-ascii?Q?+v/unIxMdM69SThb5yXV6uMT2kqiSQgahlTp2wd+vDs9W2gDuyvYgaNJs/8E?=
 =?us-ascii?Q?ehhdfkhp/MZux5aPLLfv/nOPzV1pPT0j2eJvwQXjLA239+rFK2b7LZPnYG/X?=
 =?us-ascii?Q?x5CJQmliREkWuvSr9p7kc7WHXyMX4woi13ciLJSGRx/EQiDskrt4h26OPRFO?=
 =?us-ascii?Q?fyh+yNcNaP02iQ2Fiy0QU/GsIeyHOaD+vJoW3WF9LggwX+XKGMDj5di4XUPq?=
 =?us-ascii?Q?rcA96FRIVzSB3MUlcnFxaLsYoMrXwOpFIxsqpT885IG6j+TYqZ4kxIa8XBPt?=
 =?us-ascii?Q?t1jzigIm4KYGDn/H9KWewD0HVli6AgalAB5rpltstYuViE1jTrup4BWJoyRK?=
 =?us-ascii?Q?V3EKo7QuYR+dSwcqqE8T5KKEREjzNBXs5UTJrUJgfzg8spF2Pn1BLZf68QRD?=
 =?us-ascii?Q?jLTF1Xx60xnHxFck3xOxfebnTIzgWdVLpb+CthAEW4HyJT2b11IDlmHK+jwO?=
 =?us-ascii?Q?IcszT67KMJU8YKPRHciib2kecfLm1fuRYZllvJQlsgKCrCBzyEuKQhIvF/ZG?=
 =?us-ascii?Q?CgoXiCpC8KBcTCP1hKlvnmqcVw4kIBHJgguF536KU/sZILzRD6GfnCD88Dro?=
 =?us-ascii?Q?AkUa+2pcTzMJndkCHU4Uui44Sfmp/V0BxqCQ/P3eVr7l5Wf6g30/CQtSuhsj?=
 =?us-ascii?Q?dHaHwf84J5LKVwtrTeQCDCdYL+zVKqAKILuett5FFvlLH/kCU8K706eSdJNC?=
 =?us-ascii?Q?/NaXefJDlfn5+le8DpzmxOsUNQ5eGUETE4DSR1Q1ppeatBEltqsCLlc1nxd0?=
 =?us-ascii?Q?gp4nxXhw13mOxHTZxhKKcN3vdSSc/zWR22so/lDIvg48MTa7SLmiDT5JKNuV?=
 =?us-ascii?Q?2DjqVpkxl4GukbTdkdH3yWxTKe59lu+jCe/hvaT2XFGfdNKeeKudaHmaxco6?=
 =?us-ascii?Q?mD+Ap2IXmVaVKHPPql8jBUNfYM2W98HZlPrhnJ2b0A0xbZkJxPWIq8XoCJhV?=
 =?us-ascii?Q?V5Z1PjdbMJwBIfgE9mxtMJunnB8sEQRQ?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(36860700013)(1800799024)(82310400026)(376014)(7416014);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Dec 2024 09:01:19.7410
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: fdfc8240-0ca6-4183-99ac-08dd13790db1
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CH1PEPF0000A349.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY5PR12MB6203

Add support for Secure TSC in SNP-enabled guests. Secure TSC allows guests
to securely use RDTSC/RDTSCP instructions, ensuring that the parameters
used cannot be altered by the hypervisor once the guest is launched.

Secure TSC-enabled guests need to query TSC information from the AMD
Security Processor. This communication channel is encrypted between the AMD
Security Processor and the guest, with the hypervisor acting merely as a
conduit to deliver the guest messages to the AMD Security Processor. Each
message is protected with AEAD (AES-256 GCM).

Signed-off-by: Nikunj A Dadhania <nikunj@amd.com>
Tested-by: Peter Gonda <pgonda@google.com>
Reviewed-by: Tom Lendacky <thomas.lendacky@amd.com>
---
 arch/x86/include/asm/sev-common.h |   1 +
 arch/x86/include/asm/sev.h        |  22 ++++++
 arch/x86/include/asm/svm.h        |   6 +-
 include/linux/cc_platform.h       |   8 +++
 arch/x86/coco/core.c              |   3 +
 arch/x86/coco/sev/core.c          | 116 ++++++++++++++++++++++++++++++
 arch/x86/mm/mem_encrypt.c         |   2 +
 7 files changed, 156 insertions(+), 2 deletions(-)

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
index 53f3048f484e..9fd02efef08e 100644
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
@@ -473,6 +492,8 @@ void snp_msg_free(struct snp_msg_desc *mdesc);
 int snp_send_guest_request(struct snp_msg_desc *mdesc, struct snp_guest_req *req,
 			   struct snp_guest_request_ioctl *rio);
 
+void __init snp_secure_tsc_prepare(void);
+
 #else	/* !CONFIG_AMD_MEM_ENCRYPT */
 
 #define snp_vmpl 0
@@ -514,6 +535,7 @@ static inline struct snp_msg_desc *snp_msg_alloc(void) { return NULL; }
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
index a61898c7f114..39683101b526 100644
--- a/arch/x86/coco/sev/core.c
+++ b/arch/x86/coco/sev/core.c
@@ -96,6 +96,14 @@ static u64 sev_hv_features __ro_after_init;
 /* Secrets page physical address from the CC blob */
 static u64 secrets_pa __ro_after_init;
 
+/*
+ * For Secure TSC guests, the BP fetches TSC_INFO using SNP guest messaging and
+ * initializes snp_tsc_scale and snp_tsc_offset. These values are replicated
+ * across the APs VMSA fields (TSC_SCALE and TSC_OFFSET).
+ */
+static u64 snp_tsc_scale __ro_after_init;
+static u64 snp_tsc_offset __ro_after_init;
+
 /* #VC handler runtime per-CPU data */
 struct sev_es_runtime_data {
 	struct ghcb ghcb_page;
@@ -1277,6 +1285,12 @@ static int wakeup_cpu_via_vmgexit(u32 apic_id, unsigned long start_ip)
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
@@ -3127,3 +3141,105 @@ int snp_send_guest_request(struct snp_msg_desc *mdesc, struct snp_guest_req *req
 }
 EXPORT_SYMBOL_GPL(snp_send_guest_request);
 
+static int __init snp_get_tsc_info(void)
+{
+	struct snp_guest_request_ioctl *rio;
+	struct snp_tsc_info_resp *tsc_resp;
+	struct snp_tsc_info_req *tsc_req;
+	struct snp_msg_desc *mdesc;
+	struct snp_guest_req *req;
+	unsigned char *buf;
+	int rc = -ENOMEM;
+
+	tsc_req = kzalloc(sizeof(*tsc_req), GFP_KERNEL);
+	if (!tsc_req)
+		return rc;
+
+	tsc_resp = kzalloc(sizeof(*tsc_resp), GFP_KERNEL);
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
+	/*
+	 * The intermediate response buffer is used while decrypting the
+	 * response payload. Make sure that it has enough space to cover
+	 * the authtag.
+	 */
+	buf = kzalloc(SNP_TSC_INFO_RESP_SZ + AUTHTAG_LEN, GFP_KERNEL);
+	if (!buf)
+		goto e_free_rio;
+
+	mdesc = snp_msg_alloc();
+	if (IS_ERR_OR_NULL(mdesc))
+		goto e_free_buf;
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
+	req->resp_buf = buf;
+	req->resp_sz = sizeof(*tsc_resp) + AUTHTAG_LEN;
+	req->exit_code = SVM_VMGEXIT_GUEST_REQUEST;
+
+	rc = snp_send_guest_request(mdesc, req, rio);
+	if (rc)
+		goto e_request;
+
+	memcpy(tsc_resp, buf, sizeof(*tsc_resp));
+	pr_debug("%s: response status 0x%x scale 0x%llx offset 0x%llx factor 0x%x\n",
+		 __func__, tsc_resp->status, tsc_resp->tsc_scale, tsc_resp->tsc_offset,
+		 tsc_resp->tsc_factor);
+
+	if (tsc_resp->status == 0) {
+		snp_tsc_scale = tsc_resp->tsc_scale;
+		snp_tsc_offset = tsc_resp->tsc_offset;
+	} else {
+		pr_err("Failed to get TSC info, response status 0x%x\n", tsc_resp->status);
+		rc = -EIO;
+	}
+
+e_request:
+	/* The response buffer contains sensitive data, explicitly clear it. */
+	memzero_explicit(buf, sizeof(buf));
+	memzero_explicit(tsc_resp, sizeof(*tsc_resp));
+e_free_mdesc:
+	snp_msg_free(mdesc);
+e_free_buf:
+	kfree(buf);
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
+	if (!cc_platform_has(CC_ATTR_GUEST_SEV_SNP) ||
+	    !cc_platform_has(CC_ATTR_GUEST_SNP_SECURE_TSC))
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


