Return-Path: <kvm+bounces-22786-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id D882C9432D8
	for <lists+kvm@lfdr.de>; Wed, 31 Jul 2024 17:14:11 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id EDEAD1C20866
	for <lists+kvm@lfdr.de>; Wed, 31 Jul 2024 15:14:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F3DE01C6890;
	Wed, 31 Jul 2024 15:09:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="dyQRI2Nf"
X-Original-To: kvm@vger.kernel.org
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2082.outbound.protection.outlook.com [40.107.92.82])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 288BD1C232E;
	Wed, 31 Jul 2024 15:09:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.92.82
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722438568; cv=fail; b=eAQirNVkR+3xRAhgYtYANNYRSxG2HWCzObF4gzAU3Vz2RuHosX+Ic9beqahdp6xIh6nbp3BC+F4F/0MOo8dJ1ps9s2IT2sO0zFi4yvCjL2l8Kim/UlF9Np2SCA4eQYLASerTNJMA+jYkj9E+i1R/CH/aInOjcyW/5L2ho0kA5nM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722438568; c=relaxed/simple;
	bh=iaXoBx6lsgfXyR7THnyyodnRKXmFqANcRlbfLAcrl1E=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=MapqzHZbCnHikBrv2/NYHXPhcurd3Q27OfV0s3j5vJon4Y2iKN4Wd0f+rkzaIYqJ1ymLvZjeGA/wu08hopECYxEv6fDPwf6+AgOyvlnPQRM8qiXWWMfIYlf/jnUItNa0/NPwKIscIFrzqFONpBuSCpejwjfPUPAUF234kD3QvTs=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=dyQRI2Nf; arc=fail smtp.client-ip=40.107.92.82
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Mb3OWEMfJDDFQIstBjMtYwjiiJrJWY74NT36zyxceyGtD9PU34f9VNsDWYLS5OQ1ypY5o/Yv67SNQyfOF9MZ0xjpc3dMcEJc1vNFrWDwWisxaDMeMkeRHxGu9yLvugX/s0rInlbGcqK3YS6ug6a3dyILhhiy/1x0kABWnNx/4ieBQYh9LVTphPM3MDnVza0Xygusyv+4+n69vz+12Vi/hpMBXlTOMtIcjpUMqRhYvPGOVsdWx8BVsbmqfGpczPtYTV9K44FUFe6Ek8/BTisDaGkCkwzYagBDVtNmU38tH5CjRDDOgGUI8BIkeB5aCewLepy+d1G+FQaqCdz+ybZiLA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=dYLQVJjvBgsar8MUVP4HHfuEpFxqxsNv2B/YLptzzqI=;
 b=YadNUvNgUbqeh4T8SjYVTez6bLnVjtIaNrkOZTWSWs+pwsEJ1LKcf0kHowQqsielh3edu/E/4Kp6isNKwKxXc+YdWPWlrdx3rURLyDvggggxOUFf5tCFFEhMfuKiRf5e24DiNquY/hSUBhrBKT5nTjrFCqa+TcNWWXWmAtSNUr8sBxXjjVq2uB/A/a2DJE9XYQnwJ2EYsj67iITdIGk3lpjCI6tl+muHbjbIJMDQESN2vcP2TclkSYPMgybcyzvu+MrgvoBmidzfU5zmJQGqvT43h31X8uC+hqlLmJQ5w11L308I6fc9H5j/lnKV2LLRx+78qw3F2KmkKDAlAiZLWw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=dYLQVJjvBgsar8MUVP4HHfuEpFxqxsNv2B/YLptzzqI=;
 b=dyQRI2Nf+7q9RqvzvUpmHXigIV6t6UjLX8YV7NEBoZdSrXZW/G9v7JGRMX7iDFdhUi2ofTUBB2q8JPS1KBL4QUE0SnJt10N4YQ3ewdIk00rGwxHIlwXw24aqpE/l56/WOkxF5TCLuOJqrhJCm3IrHWSM+4Eb8C5wynAIie5+7qI=
Received: from CH0PR08CA0020.namprd08.prod.outlook.com (2603:10b6:610:33::25)
 by IA1PR12MB8588.namprd12.prod.outlook.com (2603:10b6:208:44f::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7807.27; Wed, 31 Jul
 2024 15:09:22 +0000
Received: from DS3PEPF0000C37B.namprd04.prod.outlook.com
 (2603:10b6:610:33:cafe::12) by CH0PR08CA0020.outlook.office365.com
 (2603:10b6:610:33::25) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7784.35 via Frontend
 Transport; Wed, 31 Jul 2024 15:09:22 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 DS3PEPF0000C37B.mail.protection.outlook.com (10.167.23.5) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.7828.19 via Frontend Transport; Wed, 31 Jul 2024 15:09:22 +0000
Received: from gomati.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Wed, 31 Jul
 2024 10:09:18 -0500
From: Nikunj A Dadhania <nikunj@amd.com>
To: <linux-kernel@vger.kernel.org>, <thomas.lendacky@amd.com>, <bp@alien8.de>,
	<x86@kernel.org>, <kvm@vger.kernel.org>
CC: <mingo@redhat.com>, <tglx@linutronix.de>, <dave.hansen@linux.intel.com>,
	<pgonda@google.com>, <seanjc@google.com>, <pbonzini@redhat.com>,
	<nikunj@amd.com>
Subject: [PATCH v11 14/20] x86/sev: Add Secure TSC support for SNP guests
Date: Wed, 31 Jul 2024 20:38:05 +0530
Message-ID: <20240731150811.156771-15-nikunj@amd.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20240731150811.156771-1-nikunj@amd.com>
References: <20240731150811.156771-1-nikunj@amd.com>
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
X-MS-TrafficTypeDiagnostic: DS3PEPF0000C37B:EE_|IA1PR12MB8588:EE_
X-MS-Office365-Filtering-Correlation-Id: 6b674d2e-3647-4974-5e22-08dcb172c257
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700013|376014|7416014|1800799024|82310400026;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?X1XGvgQsJxTc7UEmAym6HWABNXUJf0zC1reOlXgpdBvwfpB1WrCQYUM8Lwnl?=
 =?us-ascii?Q?JxP9OhX5tyS00nNB/H8irYTVGdCknCRWtwJqt6iICZN51dNeBVIUSo5BcdS3?=
 =?us-ascii?Q?ShIYZVqsM+AV1vGv/cEm4klOROgcc35hBNJQ+hS6nZ/7ftoc6IVQaRXxDt4F?=
 =?us-ascii?Q?qy9oGfjvHEUu3HzXhKs9NIsk9oh8L+y3zc4pH7TT2/qor0hFwVfnhRPdLXyy?=
 =?us-ascii?Q?fIhiiTEOx18K544K2/IaD+m7ZO/JYk4SUF+898LlMEODvDqZ3FKxhBpOA67G?=
 =?us-ascii?Q?M59+U99cZOBAopfXmL24H0YAnUGRDl+zQ7xl8+U6Ahky0XTO/uaQyBnA+yNS?=
 =?us-ascii?Q?Wb/Qha9xhAEgsdi6q7v+k86Kxx3g5hsXhrRVa0IJh0IR9BssBz0guj5tjwiZ?=
 =?us-ascii?Q?HTCw6Ygs9DI3OLB7P4kdSxEVRjLQMv0Y1xuyEj16bpxb9m+jYZ6GOc6ohas0?=
 =?us-ascii?Q?hbKtzpzUXGndGscUwFsFhNMZEeTuqNZylSqN9tu5Ttrn5zRcUGCagMmI9nAI?=
 =?us-ascii?Q?O0Ycj4D/TxzwlXcnSmOadj3YqfQgv0fu5B6utxRlH6ZdqF8pjwA1SLroypQg?=
 =?us-ascii?Q?3y4UqKjqGoOzIQre6nSdGZoLfOteTXLl9cJcIlxiYtyNzXWDNMFXJkWd+tLY?=
 =?us-ascii?Q?xyAbMLn7q7qxKS/NEdVXn8EjILtZqOSoNmMrRl+9ny+BVDjFIxG91c/GG4lE?=
 =?us-ascii?Q?UUQ89tqIkvahd0xUp5I1dA9Tg+MZDB9rEq8zHqqVl12L8nGLVrqOn8uRX9dN?=
 =?us-ascii?Q?goHlRB0lW8FXvc1JUDjfYr+93DRLGW8B2FW4EauoinaOD6kVbgumVAC+jHXE?=
 =?us-ascii?Q?wp1zrH1OzxBuLfPX2FTDI9jL5ntCrrn3xbZG31RjjCe5fHmuWZoQWSX90wQS?=
 =?us-ascii?Q?Uv5x7jTgfcsA/KNjQGGoHV4XJ7TceIOMoOdcxjijmpd5Ji2yBcKVa2N7i8HR?=
 =?us-ascii?Q?ueKiF/bNEStzpBgszJdjrAP+tiAvXjTvgQT7bwBq3CeNZVGeeMe7ErQvvzou?=
 =?us-ascii?Q?SDY/MwoZV4dt0wo/cO9BDaHdpaog0/PQ2OJsrAkuDuJxOQJsXVZVaiZGf0gz?=
 =?us-ascii?Q?mBVukbGiTAZu99OLB+Yw1NG47p7AangbR859p2aCybRcDIcpA2vd6i8INkqw?=
 =?us-ascii?Q?ek/LP7CCSYkO/sEpuQeL0WwQbgS3GtAyf0egkmXw7dLiChrym5soO7pv78Tv?=
 =?us-ascii?Q?5z+S/lw6+kze0HUpjCslnYxH1kvD7QhW/BXyg0v071r6XMmukHCGTJ4+EpjY?=
 =?us-ascii?Q?vRT8fmPKffNTdJK2GjqcbxWv5LxJvN5UHvaUn/nmdaOOClD0OnE2ffrFN+LH?=
 =?us-ascii?Q?3bBRtluLKuwq64iL+Qe6BqGRFUiSUuLLwLxTEyf6RW3U2V24inri6VAU8iN+?=
 =?us-ascii?Q?7iX0SwbECfqmXGB+1UgyglxBxzd29JXR9b9uPeNgYb7ywbWW/OIpCzK/AHE5?=
 =?us-ascii?Q?BfcO4Vd/Kb1aovp4Nei5/68t6g+2n/bV?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(36860700013)(376014)(7416014)(1800799024)(82310400026);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 31 Jul 2024 15:09:22.3567
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 6b674d2e-3647-4974-5e22-08dcb172c257
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DS3PEPF0000C37B.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR12MB8588

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
---
 arch/x86/include/asm/sev-common.h       |  1 +
 arch/x86/include/asm/sev.h              | 46 +++++++++++++
 arch/x86/include/asm/svm.h              |  6 +-
 arch/x86/coco/sev/core.c                | 91 +++++++++++++++++++++++++
 arch/x86/mm/mem_encrypt.c               |  4 ++
 drivers/virt/coco/sev-guest/sev-guest.c | 19 ------
 6 files changed, 146 insertions(+), 21 deletions(-)

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
index eda435eba53e..f95fa64bf480 100644
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
@@ -499,6 +518,27 @@ static inline void snp_msg_cleanup(struct snp_msg_desc *mdesc)
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
@@ -545,6 +585,12 @@ static inline struct snp_msg_desc *snp_msg_alloc(void) { return NULL; }
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
index f0dea3750ca9..1695a933106b 100644
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
@@ -549,7 +551,7 @@ static inline void __unused_size_checks(void)
 	BUILD_BUG_RESERVED_OFFSET(sev_es_save_area, 0x1c0);
 	BUILD_BUG_RESERVED_OFFSET(sev_es_save_area, 0x248);
 	BUILD_BUG_RESERVED_OFFSET(sev_es_save_area, 0x298);
-	BUILD_BUG_RESERVED_OFFSET(sev_es_save_area, 0x2f0);
+	BUILD_BUG_RESERVED_OFFSET(sev_es_save_area, 0x300);
 	BUILD_BUG_RESERVED_OFFSET(sev_es_save_area, 0x320);
 	BUILD_BUG_RESERVED_OFFSET(sev_es_save_area, 0x380);
 	BUILD_BUG_RESERVED_OFFSET(sev_es_save_area, 0x3f0);
diff --git a/arch/x86/coco/sev/core.c b/arch/x86/coco/sev/core.c
index aaeeca938265..9815aa419978 100644
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
+	if (cc_platform_has(CC_ATTR_GUEST_SECURE_TSC)) {
+		vmsa->tsc_scale = snp_tsc_scale;
+		vmsa->tsc_offset = snp_tsc_offset;
+	}
+
 	/* Switch the page over to a VMSA page now that it is initialized */
 	ret = snp_set_vmsa(vmsa, caa, apic_id, true);
 	if (ret) {
@@ -2981,3 +2991,84 @@ int snp_send_guest_request(struct snp_msg_desc *mdesc, struct snp_guest_req *req
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
 
diff --git a/drivers/virt/coco/sev-guest/sev-guest.c b/drivers/virt/coco/sev-guest/sev-guest.c
index 019eca753f85..db1b00db624d 100644
--- a/drivers/virt/coco/sev-guest/sev-guest.c
+++ b/drivers/virt/coco/sev-guest/sev-guest.c
@@ -64,25 +64,6 @@ static inline struct snp_guest_dev *to_snp_dev(struct file *file)
 	return container_of(dev, struct snp_guest_dev, misc);
 }
 
-static int handle_guest_request(struct snp_msg_desc *mdesc, u64 exit_code,
-				struct snp_guest_request_ioctl *rio, u8 type,
-				void *req_buf, size_t req_sz, void *resp_buf,
-				u32 resp_sz)
-{
-	struct snp_guest_req req = {
-		.msg_version	= rio->msg_version,
-		.msg_type	= type,
-		.vmpck_id	= mdesc->vmpck_id,
-		.req_buf	= req_buf,
-		.req_sz		= req_sz,
-		.resp_buf	= resp_buf,
-		.resp_sz	= resp_sz,
-		.exit_code	= exit_code,
-	};
-
-	return snp_send_guest_request(mdesc, &req, rio);
-}
-
 struct snp_req_resp {
 	sockptr_t req_data;
 	sockptr_t resp_data;
-- 
2.34.1


