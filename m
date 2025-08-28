Return-Path: <kvm+bounces-56052-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 21902B397EF
	for <lists+kvm@lfdr.de>; Thu, 28 Aug 2025 11:16:24 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id D4F2117E8E0
	for <lists+kvm@lfdr.de>; Thu, 28 Aug 2025 09:16:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C89CA2253EB;
	Thu, 28 Aug 2025 09:16:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="FDgH4A7A"
X-Original-To: kvm@vger.kernel.org
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2056.outbound.protection.outlook.com [40.107.244.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 65BBF25634;
	Thu, 28 Aug 2025 09:16:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.244.56
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756372574; cv=fail; b=r/SNiQbbpi53bFV+HAWrRZo+L/c9anft7+ReuRzhV8eomNmOooOCD7hyjW3LsRRHsAXDjZxpkVWFDnIHYnqHCvMgKnTyweR9meYAejyKUCyBixe6jDklLr+8VIlTxDxKM/Ykdgmj/NCjCEQXtqaltKOy3KbXNcGRLH2GrPKJChY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756372574; c=relaxed/simple;
	bh=bNI3F0nX8zXwevDkIcTAP2P4G07w03Iu+oy7A6Iiy/k=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=XVSty39i1m70tO6DRPidyWo4Prgk03lO50V4q9tVN5YExWWRQ69Bk1QEZCgGnccjYry0Mq2LzmtWwRFy9AafIDYPpQbpn7opY7jw+E3pT5o7ribgesVX0RE+0mMNG2sGM9LPTcaVoH2+bHAfYBZcAy06chHVfcR3DluTjOaSJaU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=FDgH4A7A; arc=fail smtp.client-ip=40.107.244.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=TMXhT7+S0Kxdaua1T+/2EzBTOI+8yQaD0E10UanN4KXLb1SItHhgDQoogfQPeaJSZjpr6iHuMeQwoCxqGfo/BO9EBcszxlHx02E22Xz7zw/r001VSIzjDrLscc100iE1JwLbQMgR0nWtefEWloRdqTbfHPqbxiyN8whWl7Y91i6HwJRYkimry4ABAT0sPDDc08lh7m+FaVFq0rWY2eiIta7B4WZYcQBSX9W/nXb83L2ZG44wCttM38kBMeZW1RxIzgvITRJnB0HPqVxk7aqp2c+60aAgN6yONWXkwc2gBkl3PdcshXsJLobMFfetsuSt8kqZSBxS77KrYgai4H/36g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=estzRpvoIUhVg0wVPBm1tMmWcZYiFPG5w6fYlxD/9lg=;
 b=IRJnrsac2Ar+WnCQuJewGmI2FNRafJ/4e3AaLGrXFtqMy1XMuvIl3YP1+s5PGGvBPPytW/6cMGjcTgOhrEHGN9slSw4kZBKDSwyU12ugPYCiULbiOW6+Wk9aFxRntuQ1RpDdK8DIoZHgS4XOCI+SFm/fd9z0Oik9QbeqtxxRjga/q/y3bi5891OpDFcCMUqrTjiVccslD5S/lfdkO1TNnuxUjbzq14IpqDO81ldRxECmXRY2Zot30wCEh3tgpgj6DHqKXEHWwy8/hBHX2ySPoF4vBYTTqggMq5NX46nIOYgARrTFlq/KA8uSStmSQWTsFVCSmUE9B97eIReLjvboFQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=estzRpvoIUhVg0wVPBm1tMmWcZYiFPG5w6fYlxD/9lg=;
 b=FDgH4A7AWpqLBAQDoT2HntphhSeXnsDFhHM+VNkPP9kqALA1PZRBqyZAXUCGobV/D51P2w/7iXKAvGcC3VbgaXdlzLFqDCEsvuhzQhh+pR1li4QZCpfo4tpCKfNoOaSlU25S1jKOi5dMYueqN1tzxzURuvwum3Z5hv63jUwHhiY=
Received: from CH0PR07CA0016.namprd07.prod.outlook.com (2603:10b6:610:32::21)
 by MW6PR12MB9000.namprd12.prod.outlook.com (2603:10b6:303:24b::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9052.21; Thu, 28 Aug
 2025 09:16:03 +0000
Received: from CH2PEPF00000099.namprd02.prod.outlook.com
 (2603:10b6:610:32:cafe::bc) by CH0PR07CA0016.outlook.office365.com
 (2603:10b6:610:32::21) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9073.17 via Frontend Transport; Thu,
 28 Aug 2025 09:16:03 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 CH2PEPF00000099.mail.protection.outlook.com (10.167.244.20) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.9052.8 via Frontend Transport; Thu, 28 Aug 2025 09:16:03 +0000
Received: from Satlexmb09.amd.com (10.181.42.218) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Thu, 28 Aug
 2025 02:04:06 -0500
Received: from BLR-L-NUPADHYA.xilinx.com (10.180.168.240) by
 satlexmb09.amd.com (10.181.42.218) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.2.1748.10; Thu, 28 Aug 2025 00:04:00 -0700
From: Neeraj Upadhyay <Neeraj.Upadhyay@amd.com>
To: <linux-kernel@vger.kernel.org>
CC: <bp@alien8.de>, <tglx@linutronix.de>, <mingo@redhat.com>,
	<dave.hansen@linux.intel.com>, <Thomas.Lendacky@amd.com>, <nikunj@amd.com>,
	<Santosh.Shukla@amd.com>, <Vasant.Hegde@amd.com>,
	<Suravee.Suthikulpanit@amd.com>, <David.Kaplan@amd.com>, <x86@kernel.org>,
	<hpa@zytor.com>, <peterz@infradead.org>, <seanjc@google.com>,
	<pbonzini@redhat.com>, <kvm@vger.kernel.org>,
	<kirill.shutemov@linux.intel.com>, <huibo.wang@amd.com>,
	<naveen.rao@amd.com>, <francescolavra.fl@gmail.com>, <tiala@microsoft.com>
Subject: [PATCH v10 01/18] x86/apic: Add new driver for Secure AVIC
Date: Thu, 28 Aug 2025 12:33:17 +0530
Message-ID: <20250828070334.208401-2-Neeraj.Upadhyay@amd.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20250828070334.208401-1-Neeraj.Upadhyay@amd.com>
References: <20250828070334.208401-1-Neeraj.Upadhyay@amd.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SATLEXMB03.amd.com (10.181.40.144) To satlexmb09.amd.com
 (10.181.42.218)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH2PEPF00000099:EE_|MW6PR12MB9000:EE_
X-MS-Office365-Filtering-Correlation-Id: 1ee945bf-0b72-4243-b632-08dde6138303
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|82310400026|376014|1800799024|36860700013;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?Y1IkuewebvR/eNu2J0fsvjRG/A2L+09iU6Ql6rlNowRo1LNqQ6/sXx/yYopX?=
 =?us-ascii?Q?jQyYMUDT7ThJMaYWjdpKR0CLiPrFZDjDuRx9Q1iQsEry/bBpUiVKn3qSXd5W?=
 =?us-ascii?Q?S73d7/lqy7OWvgsT9AhzPe8Fsnj91tacMVdZ6pa9uRtDuI3R9lX6F2GozB7c?=
 =?us-ascii?Q?G35Jolwr5RefAjVGa7/uzkw1+Q6pDJKhZZ6AaO3sdVntlf6Re7dir8YZBX6a?=
 =?us-ascii?Q?1HIHGZMKIA1y8gV2VGMLGLjGpH7SxWHnJQqgjUSm5k6fMbRYfS3q6GvUL2x/?=
 =?us-ascii?Q?2SznG/qOHUFDZE697WlSEUNhHNTI/FM2sx6lpELUSRYTfEgS4KVvXRv73J1o?=
 =?us-ascii?Q?AWp/K1tb41+drQK5D3OIIocxNXhAI4GdtzDoAoC9c7LEk1pJmvNvugvYJo1g?=
 =?us-ascii?Q?aXr9KJPK8+nPMBVzD5n8yVNnTAGnqg4t4kxgt9Mkkvugihvun/fMmfwJhR4W?=
 =?us-ascii?Q?yQpLM2rjIBFU8xCm0G9FgbYlc1vbW2SJeYRIA8+68CisAi64QXBfpg7cycQF?=
 =?us-ascii?Q?O7e0pysXAWLvMiYZmLqGYFSVmSX9jPp2Gisp1gpfFAdIy43ILfBV9VSWy39g?=
 =?us-ascii?Q?+tky8aCt34S2Au3eHW25ZpmXvKiNMurDm33XNxo6Ye8/h7NlBc8TvUx0ceMD?=
 =?us-ascii?Q?I3CztC10FKXeakLZgnoVuCBWLi/87D+W7Q1ixhvzWLV56+PrF9UVb/TT5b9V?=
 =?us-ascii?Q?RBYknUZIS+UDlgW+ngmHt3Ip1gCELJjljaHSAKuAJClA57zZAolwgP8EbTou?=
 =?us-ascii?Q?kpgmJVmhO6QmE8XOmRfg3pIWUXZQyHC/lH9yiHhHlfnkbIodCN6MTnYNldK5?=
 =?us-ascii?Q?BtIjFTq76HEc+eCcqenX8b93qZTYliTMwXKBsRpratBxmqk2uoEQ1YGELIj3?=
 =?us-ascii?Q?2Zw322Qqgmt82QsdAWLMnB9emiJ4Cgcm/LL/BWEWQ0PlNSs+fOFrixzUc8RZ?=
 =?us-ascii?Q?FcxoorvJ88aO8+EaxfGcxxpn8LLgYpaqzbkjM3VJAPw593TmL/YaCNagV9Qh?=
 =?us-ascii?Q?ri+fN/V71bLky/gsOTtk7Vg/vD2ovpBb/m8g5xm20Jhax6INYr/ytwN/frBN?=
 =?us-ascii?Q?IR3dMM8ZnT4zncPPVOcNujQPY9vEzFqrpng/cj6S3zqpRNeiTxvTOJGDpaer?=
 =?us-ascii?Q?HBiI4ibQHJWVu3QsvL6X/rMEJh57JB8SUwLbQ/4NDwfzB3NqWKMw77s5FlOV?=
 =?us-ascii?Q?GkygTGoQZBlpP1oOBs6LjRZ55XuLbk7Uig1QCjkGubYCcQFivOrlUez8aKAb?=
 =?us-ascii?Q?0F2+Fvdt6tAjF1hz8/jdLtp0SfxDjllZ0oUdng2HZDQuRaIlJhyDuwdKXuzt?=
 =?us-ascii?Q?K0r4JRe6ia3gKYSlFxU3CruvocyUr2ZWh3zf9KJWtJ1URaw/DnuWFFVN9m3k?=
 =?us-ascii?Q?u5vaqZbvBFzq98V0K1G7knfkqyDTwmpuKPIo62ESRgK4oVEi5gUQA5a+E/w9?=
 =?us-ascii?Q?jiq2fGDfnr0Iji2m6dI9gvpgOfYL9kB4M7NE84EyrMGBNxYr9MuWoRtUwCMP?=
 =?us-ascii?Q?/qo1AacMIxJNZT6GVOyWyvDQgmfb+rveFoIN?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(7416014)(82310400026)(376014)(1800799024)(36860700013);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Aug 2025 09:16:03.2758
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 1ee945bf-0b72-4243-b632-08dde6138303
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CH2PEPF00000099.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW6PR12MB9000

The Secure AVIC feature provides SEV-SNP guests hardware acceleration
for performance sensitive APIC accesses while securely managing the
guest-owned APIC state through the use of a private APIC backing page.
This helps prevent the hypervisor from generating unexpected interrupts
for a vCPU or otherwise violate architectural assumptions around the
APIC behavior.

Add a new x2APIC driver that will serve as the base of the Secure AVIC
support. It is initially the same as the x2APIC phys driver (without
IPI callbacks), but will be modified as features of Secure AVIC are
implemented.

As the new driver does not implement Secure AVIC features yet, if the
hypervisor sets the Secure AVIC bit in SEV_STATUS, maintain the existing
behavior to enforce the guest termination.

Co-developed-by: Kishon Vijay Abraham I <kvijayab@amd.com>
Signed-off-by: Kishon Vijay Abraham I <kvijayab@amd.com>
Reviewed-by: Tianyu Lan <tiala@microsoft.com>
Signed-off-by: Neeraj Upadhyay <Neeraj.Upadhyay@amd.com>
---
Changes since v9:

 - Commit log updates.

 arch/x86/Kconfig                    | 13 ++++++
 arch/x86/boot/compressed/sev.c      |  1 +
 arch/x86/coco/core.c                |  3 ++
 arch/x86/coco/sev/core.c            |  1 +
 arch/x86/include/asm/msr-index.h    |  4 +-
 arch/x86/kernel/apic/Makefile       |  1 +
 arch/x86/kernel/apic/x2apic_savic.c | 63 +++++++++++++++++++++++++++++
 include/linux/cc_platform.h         |  8 ++++
 8 files changed, 93 insertions(+), 1 deletion(-)
 create mode 100644 arch/x86/kernel/apic/x2apic_savic.c

diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index 348a193a3ede..a06aa954c66b 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -479,6 +479,19 @@ config X86_X2APIC
 
 	  If in doubt, say Y.
 
+config AMD_SECURE_AVIC
+	bool "AMD Secure AVIC"
+	depends on AMD_MEM_ENCRYPT && X86_X2APIC
+	help
+	  Enable this to get AMD Secure AVIC support on guests that have this feature.
+
+	  AMD Secure AVIC provides hardware acceleration for performance sensitive
+	  APIC accesses and support for managing guest owned APIC state for SEV-SNP
+	  guests. Secure AVIC does not support xapic mode. It has functional
+	  dependency on x2apic being enabled in the guest.
+
+	  If you don't know what to do here, say N.
+
 config X86_POSTED_MSI
 	bool "Enable MSI and MSI-x delivery by posted interrupts"
 	depends on X86_64 && IRQ_REMAP
diff --git a/arch/x86/boot/compressed/sev.c b/arch/x86/boot/compressed/sev.c
index fd1b67dfea22..74e083feb2d9 100644
--- a/arch/x86/boot/compressed/sev.c
+++ b/arch/x86/boot/compressed/sev.c
@@ -235,6 +235,7 @@ bool sev_es_check_ghcb_fault(unsigned long address)
 				 MSR_AMD64_SNP_VMSA_REG_PROT |		\
 				 MSR_AMD64_SNP_RESERVED_BIT13 |		\
 				 MSR_AMD64_SNP_RESERVED_BIT15 |		\
+				 MSR_AMD64_SNP_SECURE_AVIC |		\
 				 MSR_AMD64_SNP_RESERVED_MASK)
 
 /*
diff --git a/arch/x86/coco/core.c b/arch/x86/coco/core.c
index d4610af68114..989ca9f72ba3 100644
--- a/arch/x86/coco/core.c
+++ b/arch/x86/coco/core.c
@@ -104,6 +104,9 @@ static bool noinstr amd_cc_platform_has(enum cc_attr attr)
 	case CC_ATTR_HOST_SEV_SNP:
 		return cc_flags.host_sev_snp;
 
+	case CC_ATTR_SNP_SECURE_AVIC:
+		return sev_status & MSR_AMD64_SNP_SECURE_AVIC;
+
 	default:
 		return false;
 	}
diff --git a/arch/x86/coco/sev/core.c b/arch/x86/coco/sev/core.c
index 14ef5908fb27..f7a549f650e9 100644
--- a/arch/x86/coco/sev/core.c
+++ b/arch/x86/coco/sev/core.c
@@ -79,6 +79,7 @@ static const char * const sev_status_feat_names[] = {
 	[MSR_AMD64_SNP_IBS_VIRT_BIT]		= "IBSVirt",
 	[MSR_AMD64_SNP_VMSA_REG_PROT_BIT]	= "VMSARegProt",
 	[MSR_AMD64_SNP_SMT_PROT_BIT]		= "SMTProt",
+	[MSR_AMD64_SNP_SECURE_AVIC_BIT]		= "SecureAVIC",
 };
 
 /*
diff --git a/arch/x86/include/asm/msr-index.h b/arch/x86/include/asm/msr-index.h
index b65c3ba5fa14..2a6d4fd8659a 100644
--- a/arch/x86/include/asm/msr-index.h
+++ b/arch/x86/include/asm/msr-index.h
@@ -699,7 +699,9 @@
 #define MSR_AMD64_SNP_VMSA_REG_PROT	BIT_ULL(MSR_AMD64_SNP_VMSA_REG_PROT_BIT)
 #define MSR_AMD64_SNP_SMT_PROT_BIT	17
 #define MSR_AMD64_SNP_SMT_PROT		BIT_ULL(MSR_AMD64_SNP_SMT_PROT_BIT)
-#define MSR_AMD64_SNP_RESV_BIT		18
+#define MSR_AMD64_SNP_SECURE_AVIC_BIT	18
+#define MSR_AMD64_SNP_SECURE_AVIC	BIT_ULL(MSR_AMD64_SNP_SECURE_AVIC_BIT)
+#define MSR_AMD64_SNP_RESV_BIT		19
 #define MSR_AMD64_SNP_RESERVED_MASK	GENMASK_ULL(63, MSR_AMD64_SNP_RESV_BIT)
 #define MSR_AMD64_RMP_BASE		0xc0010132
 #define MSR_AMD64_RMP_END		0xc0010133
diff --git a/arch/x86/kernel/apic/Makefile b/arch/x86/kernel/apic/Makefile
index 52d1808ee360..581db89477f9 100644
--- a/arch/x86/kernel/apic/Makefile
+++ b/arch/x86/kernel/apic/Makefile
@@ -18,6 +18,7 @@ ifeq ($(CONFIG_X86_64),y)
 # APIC probe will depend on the listing order here
 obj-$(CONFIG_X86_NUMACHIP)	+= apic_numachip.o
 obj-$(CONFIG_X86_UV)		+= x2apic_uv_x.o
+obj-$(CONFIG_AMD_SECURE_AVIC)	+= x2apic_savic.o
 obj-$(CONFIG_X86_X2APIC)	+= x2apic_phys.o
 obj-$(CONFIG_X86_X2APIC)	+= x2apic_cluster.o
 obj-y				+= apic_flat_64.o
diff --git a/arch/x86/kernel/apic/x2apic_savic.c b/arch/x86/kernel/apic/x2apic_savic.c
new file mode 100644
index 000000000000..bea844f28192
--- /dev/null
+++ b/arch/x86/kernel/apic/x2apic_savic.c
@@ -0,0 +1,63 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/*
+ * AMD Secure AVIC Support (SEV-SNP Guests)
+ *
+ * Copyright (C) 2024 Advanced Micro Devices, Inc.
+ *
+ * Author: Neeraj Upadhyay <Neeraj.Upadhyay@amd.com>
+ */
+
+#include <linux/cc_platform.h>
+
+#include <asm/apic.h>
+#include <asm/sev.h>
+
+#include "local.h"
+
+static int savic_acpi_madt_oem_check(char *oem_id, char *oem_table_id)
+{
+	return x2apic_enabled() && cc_platform_has(CC_ATTR_SNP_SECURE_AVIC);
+}
+
+static int savic_probe(void)
+{
+	if (!cc_platform_has(CC_ATTR_SNP_SECURE_AVIC))
+		return 0;
+
+	if (!x2apic_mode) {
+		pr_err("Secure AVIC enabled in non x2APIC mode\n");
+		snp_abort();
+		/* unreachable */
+	}
+
+	return 1;
+}
+
+static struct apic apic_x2apic_savic __ro_after_init = {
+
+	.name				= "secure avic x2apic",
+	.probe				= savic_probe,
+	.acpi_madt_oem_check		= savic_acpi_madt_oem_check,
+
+	.dest_mode_logical		= false,
+
+	.disable_esr			= 0,
+
+	.cpu_present_to_apicid		= default_cpu_present_to_apicid,
+
+	.max_apic_id			= UINT_MAX,
+	.x2apic_set_max_apicid		= true,
+	.get_apic_id			= x2apic_get_apic_id,
+
+	.calc_dest_apicid		= apic_default_calc_apicid,
+
+	.nmi_to_offline_cpu		= true,
+
+	.read				= native_apic_msr_read,
+	.write				= native_apic_msr_write,
+	.eoi				= native_apic_msr_eoi,
+	.icr_read			= native_x2apic_icr_read,
+	.icr_write			= native_x2apic_icr_write,
+};
+
+apic_driver(apic_x2apic_savic);
diff --git a/include/linux/cc_platform.h b/include/linux/cc_platform.h
index 0bf7d33a1048..7fcec025c5e0 100644
--- a/include/linux/cc_platform.h
+++ b/include/linux/cc_platform.h
@@ -96,6 +96,14 @@ enum cc_attr {
 	 * enabled to run SEV-SNP guests.
 	 */
 	CC_ATTR_HOST_SEV_SNP,
+
+	/**
+	 * @CC_ATTR_SNP_SECURE_AVIC: Secure AVIC mode is active.
+	 *
+	 * The host kernel is running with the necessary features enabled
+	 * to run SEV-SNP guests with full Secure AVIC capabilities.
+	 */
+	CC_ATTR_SNP_SECURE_AVIC,
 };
 
 #ifdef CONFIG_ARCH_HAS_CC_PLATFORM
-- 
2.34.1


