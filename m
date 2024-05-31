Return-Path: <kvm+bounces-18487-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id BEA288D5983
	for <lists+kvm@lfdr.de>; Fri, 31 May 2024 06:37:42 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 31A2DB23325
	for <lists+kvm@lfdr.de>; Fri, 31 May 2024 04:37:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D9FA48002A;
	Fri, 31 May 2024 04:34:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="He3qPR7U"
X-Original-To: kvm@vger.kernel.org
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2055.outbound.protection.outlook.com [40.107.94.55])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 72330823BC;
	Fri, 31 May 2024 04:34:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.94.55
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717130084; cv=fail; b=hFKEznWoABTZUEJ6cwL7n31DFU+N425nCKIPajT3qymjpprZxdP5Lj01jW4Nv31r4nxvVIHiyvd5GT+hOI3zA7MzUZHT+5IKteONtcZ9nL/b4y2QQ7etuk4pdITEPkmJWfBuAMyrNa7XF18oit/XO7zikWj/2KEmMx2TCSHPkcY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717130084; c=relaxed/simple;
	bh=tp1vMkb7i2BpoJ85KK0ZmC6pZS3sYv7hsvwjTQWBRD8=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=pk5PaIpGKChV6hsxoVNoTbX9qNd3IGoQNRtN3JGVaVtNGh96WC4om23WkUCtzeuJAe8DIOX8oXAQfp72OWmIe+sfOsuUde/c/5ySk1IIA1AL7acHKdXu1rPEmJ/2OltGyygcWwpTVXlD6GB008mS/0gh8vNcdLxfvTn2uUqe95E=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=He3qPR7U; arc=fail smtp.client-ip=40.107.94.55
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=IdALJ7XQq784jgQKi6ofYgJXWnWqxkFqqJ74NVlgRghrDfjvT8Fu7KHC0Vznw4WQGfAh047IKi5M4eiR5Rtr5zsBmP1kggzpMbQ3omGJFVtHEaNgDtpCgVveCGoFdVL2qwsny1DuB145vSdNBZnryWBrRAFp2H09uMwH8WlhtDXPROrA7pjhrFGU3A42GQi5G4eudU2iRYSsKXiEuIKbBpYQRFedKMxA1zdwkSYbg5bJklehHTlrFa7C9a+KleE8jXo6diUOVlSQOaGllx8O1oJn6LOuRPxpQrgFKbY9Do4umWbZVUqWuF+duzYVBS8PPYfYpyFJINovvh5ozAh6Kw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=/jWlAnrnYANpPBOexW5g/QcD4cGrSyswF7bO1sXX9GQ=;
 b=nzIm/nUG3S+T0Bj8Q8+K+nDC88FYH/fT9gSyfHdCVQ9K2EYA3ByI0eJw7BCutLglGgdsg0ofZILU7O/Da1Q+DkG8B85F6HtI3V5RUuUj3uWznbuB/ZRzjMHYdfLd5q/aA+RX2K6Hwy/YU2jPJqEybWZ3u7y9v+aNMNDEsH3Zr4jWHGP6RvAJVoKkaE4YXOgv0QUbV43KlBboqSa8E3u7PTWcq72rLDYmZ7NTW1Y2o3U/Pa8yasyqtPX48HQVxvQCgVjFl9KRCwIdbAea/aajSEIXk2XJfqrbhlYYgmhRUV5r6Luthm51dxWg5Hb9FL4woh+Ni0ttpctuMi5koEUf1Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/jWlAnrnYANpPBOexW5g/QcD4cGrSyswF7bO1sXX9GQ=;
 b=He3qPR7UF9uer41oE7gsC5jeEa4N1oTqOon4OtUNe8qDnXPR50I9LtvclxcBBxesB3RpQVEpaxWCCQDqCquDlRuaeGxY38h/3U6vTbFCkHQf0QDX4RoOGmyWhXH6nTf8c0sS81gpoTx7d8Mv/YqRgP+KFSQfXhx+EhwvxvHmZZE=
Received: from DM6PR08CA0043.namprd08.prod.outlook.com (2603:10b6:5:1e0::17)
 by SA0PR12MB4496.namprd12.prod.outlook.com (2603:10b6:806:9b::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7633.22; Fri, 31 May
 2024 04:34:40 +0000
Received: from DS3PEPF000099D9.namprd04.prod.outlook.com
 (2603:10b6:5:1e0:cafe::16) by DM6PR08CA0043.outlook.office365.com
 (2603:10b6:5:1e0::17) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7633.24 via Frontend
 Transport; Fri, 31 May 2024 04:34:40 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 DS3PEPF000099D9.mail.protection.outlook.com (10.167.17.10) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.7633.15 via Frontend Transport; Fri, 31 May 2024 04:34:39 +0000
Received: from gomati.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.35; Thu, 30 May
 2024 23:34:35 -0500
From: Nikunj A Dadhania <nikunj@amd.com>
To: <linux-kernel@vger.kernel.org>, <thomas.lendacky@amd.com>, <bp@alien8.de>,
	<x86@kernel.org>, <kvm@vger.kernel.org>
CC: <mingo@redhat.com>, <tglx@linutronix.de>, <dave.hansen@linux.intel.com>,
	<pgonda@google.com>, <seanjc@google.com>, <pbonzini@redhat.com>,
	<nikunj@amd.com>
Subject: [PATCH v9 18/24] x86/sev: Add Secure TSC support for SNP guests
Date: Fri, 31 May 2024 10:00:32 +0530
Message-ID: <20240531043038.3370793-19-nikunj@amd.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20240531043038.3370793-1-nikunj@amd.com>
References: <20240531043038.3370793-1-nikunj@amd.com>
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
X-MS-TrafficTypeDiagnostic: DS3PEPF000099D9:EE_|SA0PR12MB4496:EE_
X-MS-Office365-Filtering-Correlation-Id: 284de39a-db75-49f6-e3fd-08dc812afc42
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230031|82310400017|36860700004|7416005|1800799015|376005;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?x0Tt4qP3F9oIt108gEdkoOkF0xTHed7/kLtKAH3HHP7MLNJga41F7qSbiV/9?=
 =?us-ascii?Q?e/9nTi5xIP5/ZzDad4+md1LFEGFf8pj7O+2VpRj2/0Tt2N6gBJM5emJn5tBo?=
 =?us-ascii?Q?it4XtGDUi0R0eZ5ExnFBaB4c/HnvU3h6hh2wAXtNmrpIvjStPjZpJ4uJzgJ2?=
 =?us-ascii?Q?hrk9RCo1oJh+W/7BA8URZybFuYH0Qo6MHfsJ42Ar1uBf0N/icqrbKtVFASLn?=
 =?us-ascii?Q?KpMEClvT6CfQszZEzt5QaiRb7sWcYxzRo6n69FDlVzhrpWLShkhS1o/ft6AN?=
 =?us-ascii?Q?fOxPktjna10mdkpxxlkwhu3wJWG29o0zR4pKt3+eWDLDwY/K7VYwpmVXTWmw?=
 =?us-ascii?Q?v5aRHznDCHwmbQ9nGSmiPpBI3x2DDbcZNg69GXOPSQaScVJgqRs51wvz8hoA?=
 =?us-ascii?Q?c9W2lXdSNmPtYAibhOQ6h/LgZsCg+z8JUnPyIOEqDNWAe4AgmpCWy1Xa0Rr/?=
 =?us-ascii?Q?FDEqXOt99o9f9guIdnWPsZq6k/ih35QXdsZcb8aMEluSpMk9DwIMhwf60pFq?=
 =?us-ascii?Q?nLFY6tAQrHcEMNVLVlpajt+lYi4MUafgWJN8aiUkNm97np8g/MnvTPx5UEFA?=
 =?us-ascii?Q?7g3IBj3RV6ee+HjRnYT8DWJVhPVaj0hwe5ZT7t1f8AQTYIkitVgrYqdtEqpg?=
 =?us-ascii?Q?vPFISZeEX9bX9BmesmHdMcQWULZNaPqm0fZWEO1lkW1bZ1BpGTcdvDrMAETn?=
 =?us-ascii?Q?sdC+l5Sxw8bdx/l6/GRXgk77CFL3O1w6NUtpGhhOACcVu4c8cVOCnaPn5kjn?=
 =?us-ascii?Q?wj6iCSd3e43q8Ko/GzKrENyKzDMw1sqsMBKlYo+scUc3UhgylPOmYqdWBCMQ?=
 =?us-ascii?Q?/kUt3hskUk7CAbhK9cfhxbiBjKdY5UhIdM21pKSxX/q8dzjy0n3wfcEPWWNP?=
 =?us-ascii?Q?7iXzmAIP5DaZtsSC96QddrgB9O411fzKuNeTsY8W+x1xemcGSzImMirgJ4nU?=
 =?us-ascii?Q?V0t+4Wplc3INjla2tBYL+9xNR/f3LnERFPXUBSwEqnLNq6F3LZmmuOUJ7Ajj?=
 =?us-ascii?Q?feSO/blU4q/bpW4mSdtii3sXyiXH8i6RklaiBpw9JrqcRShDq8kdMEMKQ63O?=
 =?us-ascii?Q?LaXKrghpuJHrw6EqjsBB1vYv80iEYLfvO1m26XhD3EP+HJccwh1k933OI9ev?=
 =?us-ascii?Q?h9Zwiiki1NRG+S5RCwhS4aOqAuyAuTfE0j9UqARBow2HAed/hUePQkS4mP4B?=
 =?us-ascii?Q?Q34OwKAOFyTVru/nVsOW3LjuVcdMve1uFeznuEudmcsP2dzqgr3wEI6cqnNu?=
 =?us-ascii?Q?Us/ONL6WJ2c4c/5hfZhPIYHfrb5j1R2dmY80oHURJk8s8wtnjHKdVunblwUa?=
 =?us-ascii?Q?cnFSwrq9LzGBIycxpME9DsXuzH+cq0leJMKfuVLhxuhyje3ZaWgpTNGTWOgv?=
 =?us-ascii?Q?YiohDgQ=3D?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230031)(82310400017)(36860700004)(7416005)(1800799015)(376005);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 31 May 2024 04:34:39.9838
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 284de39a-db75-49f6-e3fd-08dc812afc42
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DS3PEPF000099D9.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR12MB4496

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
 arch/x86/kernel/sev.c             | 90 +++++++++++++++++++++++++++++++
 arch/x86/mm/mem_encrypt.c         |  4 ++
 5 files changed, 121 insertions(+), 2 deletions(-)

diff --git a/arch/x86/include/asm/sev-common.h b/arch/x86/include/asm/sev-common.h
index 5a8246dd532f..2cd9a6a45b39 100644
--- a/arch/x86/include/asm/sev-common.h
+++ b/arch/x86/include/asm/sev-common.h
@@ -163,6 +163,7 @@ struct snp_psc_desc {
 #define GHCB_TERM_NOT_VMPL0		3	/* SNP guest is not running at VMPL-0 */
 #define GHCB_TERM_CPUID			4	/* CPUID-validation failure */
 #define GHCB_TERM_CPUID_HV		5	/* CPUID failure during hypervisor fallback */
+#define GHCB_TERM_SECURE_TSC		6	/* Secure TSC initialization failed */
 
 #define GHCB_RESP_CODE(v)		((v) & GHCB_MSR_INFO_MASK)
 
diff --git a/arch/x86/include/asm/sev.h b/arch/x86/include/asm/sev.h
index 128bf71302a3..d6dc44c12fea 100644
--- a/arch/x86/include/asm/sev.h
+++ b/arch/x86/include/asm/sev.h
@@ -173,6 +173,9 @@ enum msg_type {
 	SNP_MSG_VMRK_REQ,
 	SNP_MSG_VMRK_RSP,
 
+	SNP_MSG_TSC_INFO_REQ = 17,
+	SNP_MSG_TSC_INFO_RSP,
+
 	SNP_MSG_TYPE_MAX
 };
 
@@ -204,6 +207,22 @@ struct snp_guest_msg {
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
@@ -225,6 +244,7 @@ struct snp_guest_dev {
 		struct snp_report_req report;
 		struct snp_derived_key_req derived_key;
 		struct snp_ext_report_req ext_report;
+		struct snp_tsc_info_req tsc_info;
 	} req;
 	unsigned int vmpck_id;
 };
@@ -362,6 +382,7 @@ static inline void *alloc_shared_pages(size_t sz)
 	return page_address(page);
 }
 
+void __init snp_secure_tsc_prepare(void);
 #else
 static inline void sev_es_ist_enter(struct pt_regs *regs) { }
 static inline void sev_es_ist_exit(void) { }
@@ -395,6 +416,7 @@ static inline int snp_send_guest_request(struct snp_guest_dev *snp_dev, struct s
 					 struct snp_guest_request_ioctl *rio) { return -EINVAL; }
 static inline void free_shared_pages(void *buf, size_t sz) { }
 static inline void *alloc_shared_pages(size_t sz) { return NULL; }
+static inline void __init snp_secure_tsc_prepare(void) { }
 #endif
 
 #ifdef CONFIG_KVM_AMD_SEV
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
diff --git a/arch/x86/kernel/sev.c b/arch/x86/kernel/sev.c
index c56cb2f15ec7..b4458af92a73 100644
--- a/arch/x86/kernel/sev.c
+++ b/arch/x86/kernel/sev.c
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
@@ -1045,6 +1049,12 @@ static int wakeup_cpu_via_vmgexit(u32 apic_id, unsigned long start_ip)
 	vmsa->vmpl		= 0;
 	vmsa->sev_features	= sev_status >> 2;
 
+	/* Set Secure TSC parameters */
+	if (cc_platform_has(CC_ATTR_GUEST_SECURE_TSC)) {
+		vmsa->tsc_scale = snp_tsc_scale;
+		vmsa->tsc_offset = snp_tsc_offset;
+	}
+
 	/* Switch the page over to a VMSA page now that it is initialized */
 	ret = snp_set_vmsa(vmsa, true);
 	if (ret) {
@@ -2660,3 +2670,83 @@ void snp_guest_messaging_exit(struct snp_guest_dev *snp_dev)
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


