Return-Path: <kvm+bounces-46443-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 9D0A3AB6436
	for <lists+kvm@lfdr.de>; Wed, 14 May 2025 09:25:51 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 215F117778E
	for <lists+kvm@lfdr.de>; Wed, 14 May 2025 07:25:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2161720B7FB;
	Wed, 14 May 2025 07:24:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="j9jq/B/U"
X-Original-To: kvm@vger.kernel.org
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2061.outbound.protection.outlook.com [40.107.92.61])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 867CC20298A;
	Wed, 14 May 2025 07:24:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.92.61
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747207477; cv=fail; b=PGq/guXloj7HWjQztS/UjiDTBcAoV/XzOpkKKTbxRNSD7xfbYaAK52ReBbWkgyVOFY1sJm8OVN//z5k86xpMWmt5VGjXE+jXUhUa4gZY2Rz6/BxMPBewo7/+mU5k9YaPEjMc+qRSOzKH8sNy03afaryAblKCdz+bk4eJu0Ho4jo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747207477; c=relaxed/simple;
	bh=MdpytVp2+Z6houLFSoqt+/oMRqv0JEldqhvM1YyWqcM=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=X4NIM8cP99bEpVLc4ZTMGsxn4Z0HJhv9To9qQRVt6X04YyJ5JSXclFBBfFdUHdhTwzFuL09/GSBJiQ+yT4YZVkxiDZYnqz978WIqLQd+QBovbQPNIvMUJyhQppXOKcEJgSSruo520AWb3GZ6OHFDjItbZr7Msr9cihvAh8KIjF4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=j9jq/B/U; arc=fail smtp.client-ip=40.107.92.61
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=IZt61fKm1BcQ/jqfvIp5EyeUcfePEgtrded0PJhvzuilR9moak8TfssFg8ln9LMd+USlloZOivNQrzxqHVGmqtALCVJm1Zry+ZvuGJHTeiP1/scppAa7cIv7BXVMJ/ajbQ5BTXhO8kMbqYDhBeq+8zOyIjDfh4lELGoo71lS2tT7XoODOEz2aJIz9a5Vh7L6RrOPLaHgM73WOZ7dC9U6VQwww6PWOQGVg9dcwTqLL/MNTMzniPTNJXyU0VzbJF2a6WGc1HIKHitF1HCqgsrhL2x+yw6IVKPFHOm/5Zd2K2n9SZ1MnGEWfaZl7PWWTfJ4NZ5TzxPoADqpbDq5NFpW7A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=lM9qaq9XkQRBcc5nU4W8iwfa8yMZPVZGsTpWI7aqT0M=;
 b=rliQeUrmLFfxoBL+TuguJ3ZzKG9AxF6wlhzZjwef/phsEfgYufGVfJ2nc+Azo1DLDd+lACf8asogype0p4ijHI3JHJGEw1ky+iCEeGqOtSurOEj+yhGQt9whuAmNyu/dLFHXQ+nvDtfv4hJr1rl6dTAvVPc9cTDu107kWEQlFI3O/HnbqEf+XGmkOp3erY7kZ1nQguh4418R9GAXKAEU0XYQJjVQItXI/m7/ZoC3+UiQhLXyg/ctdvVwoDzuuZgd4xbyaMKkuIt8VjGSU3ARNevDydwdndgyxFIWwc/9pyHiNQU6EcxbmTfM0JDEOM8NmjaC3pOEWplI2ewn9B/7uA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=lM9qaq9XkQRBcc5nU4W8iwfa8yMZPVZGsTpWI7aqT0M=;
 b=j9jq/B/U/hHevu7q8jZ8hujdlyw07gLjLpQoo629jsQGjmVUJyQu33dICZb3LM2q2fphEQtnKhapi3ZyCFobI39osmym4zZRJfnGiMUORYMRUYySaVmuGFMgyblWnCoHt4eiFlP1qgR0M6wD/tnTdHj6p1IKmOBIiaPU/pJII0o=
Received: from MN2PR20CA0040.namprd20.prod.outlook.com (2603:10b6:208:235::9)
 by CH1PR12MB9646.namprd12.prod.outlook.com (2603:10b6:610:2af::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8722.23; Wed, 14 May
 2025 07:24:29 +0000
Received: from BN3PEPF0000B076.namprd04.prod.outlook.com
 (2603:10b6:208:235:cafe::55) by MN2PR20CA0040.outlook.office365.com
 (2603:10b6:208:235::9) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8699.31 via Frontend Transport; Wed,
 14 May 2025 07:24:28 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 BN3PEPF0000B076.mail.protection.outlook.com (10.167.243.121) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.8722.18 via Frontend Transport; Wed, 14 May 2025 07:24:28 +0000
Received: from BLR-L-NUPADHYA.xilinx.com (10.180.168.240) by
 SATLEXMB04.amd.com (10.181.40.145) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Wed, 14 May 2025 02:24:18 -0500
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
Subject: [RFC PATCH v6 15/32] x86/apic: Add new driver for Secure AVIC
Date: Wed, 14 May 2025 12:47:46 +0530
Message-ID: <20250514071803.209166-16-Neeraj.Upadhyay@amd.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20250514071803.209166-1-Neeraj.Upadhyay@amd.com>
References: <20250514071803.209166-1-Neeraj.Upadhyay@amd.com>
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
X-MS-TrafficTypeDiagnostic: BN3PEPF0000B076:EE_|CH1PR12MB9646:EE_
X-MS-Office365-Filtering-Correlation-Id: bcc86cf7-9914-45bf-cff6-08dd92b85cf5
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|376014|82310400026|1800799024|36860700013;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?BmWhgX7I+B0MCm8yDKuVuWuBAQ2+roV43M1NlOIu60hxMGiDLqjdmzPu4agV?=
 =?us-ascii?Q?EeNFvJklFR6hf61Irxj1DrFw5135gC+lkSn8N/H8rVLQJAPt4Q14X9mnEx1d?=
 =?us-ascii?Q?QPProdUntc6AyLQJz8b0S4UW8SShZEzTWxkV6O8eylBGYCIoHvIdr48iDyde?=
 =?us-ascii?Q?+xkjKVH5EMCO/tLVsj3MyDT83kqdK9LdQt5kQGnn63qZ7pB6DmlwWWECtZN4?=
 =?us-ascii?Q?D13I0ozYRzVpWOIZCqU0pYtGyi44K+nzb26U5CMGv/LcEs2FewwjMBWcExzP?=
 =?us-ascii?Q?r79oWjiXzm9+bf4r5sBDiNH/LbUaBu74IExkK00L0xgJdX0ji5eYFOhv8MpB?=
 =?us-ascii?Q?JkH2UVajHrucSkMS7BASEvRWCgrDcgLkcu605bMl2lyDbP2SkNExBGKg0U1a?=
 =?us-ascii?Q?f+cAWi0c5+YghO+DXeRx9zyc8Yd0yUByP+emRS9x79racWCN54vsXHscPFJT?=
 =?us-ascii?Q?re+MlBtyY/4eVbwJ1hn05pXkogiQQ2LD1QItFCYxc5phb5YS4nYdhJcU4DiF?=
 =?us-ascii?Q?Pfio3jUhMIiYJt85VytOy/GiIFRqhxDUOzU7AhQx12p13k1FXuLeYUjv0nnF?=
 =?us-ascii?Q?8FssiJWixhHJUcrjjvSwpXQyHO08IqTLVINsKjZ4+Ux2ggH9p416YJnI/pzL?=
 =?us-ascii?Q?aDI4JKm2rvth9MsiTtuRw4jDUf1dOBvPQo+iZJH0TRzPm1Tr92v8tbrN0VKK?=
 =?us-ascii?Q?TZitdxC/yMPlawkWGD11Dmb8trTjtArTNQZURPTlrfCPU3N56R0GsBMmlGZs?=
 =?us-ascii?Q?6yW0BJw4pyYHzxtWB4NDgXhA1Xc7kIrLQ8jPiwf6lqYBOUWZrZrVY1NT8aHG?=
 =?us-ascii?Q?4JqQ9SuH/Cdwg1QnsJXaeIwZ9lAgd7NVm5H8lOG+8Bn7yyfySpL1V+Z9Ukp7?=
 =?us-ascii?Q?PWCoDeqPOOYLuLgB+goH8zAiZBo2hkX8Ae2lBrSuya4bL/K1hhpCQ5iU3Jdb?=
 =?us-ascii?Q?gSWa5dQmVAtZj4nRG+ClMVZJ7nPOr845nMu3N/wkic4eo8GyTkvoLfQfg1bm?=
 =?us-ascii?Q?2UGGkOQnc4j67CtwYm+aKlxsEqVZ016GbZOaXW4cjBJkbN+a652JbGv37qE/?=
 =?us-ascii?Q?+68bb1knZcCB9L2OUb1lmf3srqxuyEOyjRqTMsuhbBf+Gnwr8TJ315gINy8S?=
 =?us-ascii?Q?dDNF1YaOLx3rOWBm7iv5J0BkyILq5QEt8+0+KfXKQZ4IRBfGdT562mElMo08?=
 =?us-ascii?Q?LRB+Sh7PbQxZ3Tm/26q1/o5mEsjz3rq9nI6vjl0hP9xThav6Sd+k2Wd7hb06?=
 =?us-ascii?Q?vU8IAKisDQfPR08l8/CZn/FDX8pEucom/nPsAmcRXlgYIqm3PcRpw60yo17B?=
 =?us-ascii?Q?bcVZM8vFo4m09b32+VJNu7Cu0oOXBXWHEZDsdwMPllLODUA9Fo9yr56Y5kpK?=
 =?us-ascii?Q?PPUanKT2/pPhNCIuP+E1FN5TRIvOUIbH1J7BIkS+NTixGK10vA8NsLuiA4FZ?=
 =?us-ascii?Q?KMAdvIws17azK/rK/LzmxnafOrqJ9nzi36Unbqpll0ChvHzhhX82pXCTPrPY?=
 =?us-ascii?Q?juJQRoLgHcmTqujt5rjzSW6iNyEg+D+rxcIv?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(7416014)(376014)(82310400026)(1800799024)(36860700013);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 May 2025 07:24:28.7302
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: bcc86cf7-9914-45bf-cff6-08dd92b85cf5
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BN3PEPF0000B076.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH1PR12MB9646

The Secure AVIC feature provides SEV-SNP guests hardware acceleration
for performance sensitive APIC accesses while securely managing the
guest-owned APIC state through the use of a private APIC backing page.
This helps prevent hypervisor from generating unexpected interrupts for
a vCPU or otherwise violate architectural assumptions around APIC
behavior.

Add a new x2APIC driver that will serve as the base of the Secure AVIC
support. It is initially the same as the x2APIC phys driver (without
IPI callbacks), but will be modified as features of Secure AVIC are
implemented.

As the new driver does not implement Secure AVIC features yet, if the
hypervisor sets the Secure AVIC bit in SEV_STATUS, maintain the existing
behavior to enforce the guest termination.

Co-developed-by: Kishon Vijay Abraham I <kvijayab@amd.com>
Signed-off-by: Kishon Vijay Abraham I <kvijayab@amd.com>
Signed-off-by: Neeraj Upadhyay <Neeraj.Upadhyay@amd.com>
---
Changes since v5:

 - Add "SecureAVIC" to sev_status_feat_names.

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
index 0f63f550ab52..b26c45b3a4a3 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -486,6 +486,19 @@ config X86_X2APIC
 
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
index 612b443296d3..31287003a249 100644
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
index 7e946dc74b80..2a604b24a02e 100644
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
index ac21dc19dde2..d32908b93b30 100644
--- a/arch/x86/include/asm/msr-index.h
+++ b/arch/x86/include/asm/msr-index.h
@@ -689,7 +689,9 @@
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


