Return-Path: <kvm+bounces-51852-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 02F80AFDE4C
	for <lists+kvm@lfdr.de>; Wed,  9 Jul 2025 05:39:55 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 5BAF17B7106
	for <lists+kvm@lfdr.de>; Wed,  9 Jul 2025 03:38:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6C2C420127D;
	Wed,  9 Jul 2025 03:38:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="TU7v5Msz"
X-Original-To: kvm@vger.kernel.org
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2052.outbound.protection.outlook.com [40.107.237.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C5E0C1F4E57;
	Wed,  9 Jul 2025 03:38:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.237.52
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752032320; cv=fail; b=VJ3bGusy0l4m94tBELqtRCmKLwQ/B+K/EC0Q3XrmHghrfvzn0FQ1JNVMrVwcJEjWgpMs1t93PLkcDZ06KyKMwFCyNqurjbCedwKg/LsPIvKloSXe81e+c+QnVlpVHe3fEhxhkQqPNSO95WiQZyAphOXHVtLAw31QP5QdWlA/gWI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752032320; c=relaxed/simple;
	bh=JU1U6sJc1dpJguFGCd3hDPq8sXxNWtwWJ7wmu/XG2bw=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=IEww1BCCHwYdkXbOg0jgBvmtxfVzk57E7U9s6RA5O+FtOlNDb0bil101mAU/tWjQLkUTMCU+ji2sE3p7qoW3hyYSuzvVfYgLHOSqsPlf7ei2CO+ci+KVv8txXiXrGrRoiZDJg8FrxwhatZQ6W77RM3FmpC0Paqad7RSTt0Hk+wM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=TU7v5Msz; arc=fail smtp.client-ip=40.107.237.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=MviUr3j6+/w3RxrLiIVWmTuP0exDNnWJ2u39W4MqSL/Pt7g3u25Xa3Yv0EqtFkRD6Q0KM9qs4AFoRnjquKSkdS9kZNgbqfiAJHkEhyoAC8iUjGIISW/5lkO0YTlZcpquK3fFgf/++pLiufAH3FG0tby1Kdq3FrX93AGPh2yG1fkco+zdxPd0ZpCgbFmd5ocI6hoWa1do9M8wg2lOYYCkMr9xbfh8eEvleDYLFkYQFgo0UA0+dBHv0KQC3Pl+0p5LOoAJ+KYNyB0sSbbGLlL6oK5RcNg8O9vKp7gXgE2B/73/tvLeXtfXjCYmX7K38I6zpXViD5hszO73v2gnfI/huw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=bvkkrZrABFfbSfv/UR//KJCbvJCl7dUztxGJ6hQ5o4c=;
 b=kVqnfQu9nvpkdOEBBz+l11XZNMXxJH13iBER93JslVP9hTJuhzNhCP6ctP39q9Ujbep/JABjxjHmTvsMlvSZVRjYSjfqhu/70PwOYxp7a1y1wdl6FdYJDp+Tdv3dF3f0r/3LlwHuJwWwoiumoC/q52qHDHMY67zPt3kcBGHD8Ty1sJVti9FvveN4GVibr26TdunLmu+hyQlHCHwxqMcSnjZT4QCFCC2ciIlSpcrhgS5KBgI7u/KQOaqi1oRiCeQO1jebNWxeFRexBYWBfEcnDV7Oj+4Fs4AoaPsHTa970o+ob5CwwUSQUN6SvGGIQazHm7JNJsTBxp0PZh3V0GTDjw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=bvkkrZrABFfbSfv/UR//KJCbvJCl7dUztxGJ6hQ5o4c=;
 b=TU7v5Mszl0+0M26xdbC2wDdJAMfJvSlGpTvsfByZc8oMroH2zjzbkvOcElUwyym9YZ17AJrGkxJSPweQDG3S8h/3r5AIq6dWZon9db87aiQ/A8oS1QXKGNCOfCfKcSiML4wDCoIJKz0p4WPqKrcce4Kf0ukv80TbGpi+VaEhE6s=
Received: from BN0PR02CA0030.namprd02.prod.outlook.com (2603:10b6:408:e4::35)
 by DS7PR12MB8289.namprd12.prod.outlook.com (2603:10b6:8:d8::7) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8901.24; Wed, 9 Jul 2025 03:38:33 +0000
Received: from BL6PEPF0001AB4A.namprd04.prod.outlook.com
 (2603:10b6:408:e4:cafe::63) by BN0PR02CA0030.outlook.office365.com
 (2603:10b6:408:e4::35) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8922.21 via Frontend Transport; Wed,
 9 Jul 2025 03:38:32 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 BL6PEPF0001AB4A.mail.protection.outlook.com (10.167.242.68) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.8901.15 via Frontend Transport; Wed, 9 Jul 2025 03:38:32 +0000
Received: from BLR-L-NUPADHYA.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Tue, 8 Jul
 2025 22:38:26 -0500
From: Neeraj Upadhyay <Neeraj.Upadhyay@amd.com>
To: <linux-kernel@vger.kernel.org>
CC: <bp@alien8.de>, <tglx@linutronix.de>, <mingo@redhat.com>,
	<dave.hansen@linux.intel.com>, <Thomas.Lendacky@amd.com>, <nikunj@amd.com>,
	<Santosh.Shukla@amd.com>, <Vasant.Hegde@amd.com>,
	<Suravee.Suthikulpanit@amd.com>, <David.Kaplan@amd.com>, <x86@kernel.org>,
	<hpa@zytor.com>, <peterz@infradead.org>, <seanjc@google.com>,
	<pbonzini@redhat.com>, <kvm@vger.kernel.org>,
	<kirill.shutemov@linux.intel.com>, <huibo.wang@amd.com>,
	<naveen.rao@amd.com>, <kai.huang@intel.com>
Subject: [RFC PATCH v8 18/35] x86/apic: Add new driver for Secure AVIC
Date: Wed, 9 Jul 2025 09:02:25 +0530
Message-ID: <20250709033242.267892-19-Neeraj.Upadhyay@amd.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20250709033242.267892-1-Neeraj.Upadhyay@amd.com>
References: <20250709033242.267892-1-Neeraj.Upadhyay@amd.com>
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
X-MS-TrafficTypeDiagnostic: BL6PEPF0001AB4A:EE_|DS7PR12MB8289:EE_
X-MS-Office365-Filtering-Correlation-Id: 3f0b1238-43a6-4be5-3575-08ddbe9a1417
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|7416014|376014|36860700013|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?fGg2LNBsDituUWdPVYCLRGu7c2AuGilDwjvd97tem+s/NJ6qVBHcZhjG50nZ?=
 =?us-ascii?Q?nYQ9Lvl+acOpPjkNVyBBQXF+A8Zb3sxY0J1BzMhkiB3KyEtJlMPWZVfBBxhQ?=
 =?us-ascii?Q?IcgcoK7KJW9X46kd0zmN8uy+yCl90p6dHznOGnQz6wUOuNZp2fF/mjTTH7pr?=
 =?us-ascii?Q?/tIuyRHPe+EyZpCzmgtQ2G0Q7jFWjDg76/EINIG5L7tncjBjYCIbCPrHHJNh?=
 =?us-ascii?Q?1kg0Zp+i7Msr0YNN/qbA81zRKZBUGR5rUfmes8nec9ycbcXSr+Nyy8ulaP/i?=
 =?us-ascii?Q?PUjJd2lCBuZlLw9tlnqtO/8eyEtc0prCbGheBuHS0BcwQRDUNany5e1Tsw6U?=
 =?us-ascii?Q?SRhvRAMkKrDpoDEehDaOxvXF4TiSqk4llnqN8kmHf+pFNf+8cG5qtHOnAZpc?=
 =?us-ascii?Q?GBhjZ6bdFHbOkFgH5xB2NGwZT4nYiJQws1m1Q5Ilh2LXJwQ41KyTba/Kvfsf?=
 =?us-ascii?Q?ZFiQn337RGL9u8rif7nOU6OMOWcFa0EyNmhK1y1Z7TNAaqOCgzX6jMd6v2H8?=
 =?us-ascii?Q?rD5+4HKsZ8lm/YkG+PtnCsvD5oGL4zGLm/bqqphEq7a911Mt3SYqL8kQ4eVK?=
 =?us-ascii?Q?ikONcqv8I+ZlhkBa5ksCElEgfZwwPE4BLEbwZJl1+IzCNJI8DrmKC4i45sZA?=
 =?us-ascii?Q?SiibOMt8rrZwvPgc6Y7CiWRD4jZ9b/shl6teilL5PclDCmgxEI+XkSPv9XuJ?=
 =?us-ascii?Q?d7J1OZ7mkxX3UzDnOIVv03n+pVTXNYkftzArZJYR9TiqpppLsee/13itn9YL?=
 =?us-ascii?Q?yOh4aO8fZAHMDnWlCvlXSxkizVirpvDGpWUPRjzGXMTQtdLv07yP4f0SBs5L?=
 =?us-ascii?Q?Gz8Cu59S2zjDNxnS8xwvQAaG/svLxFJRZwpAWqWIFBCRq08C5zR3AuT/Rrau?=
 =?us-ascii?Q?u3Y/NCrPrqJcKSsexsKGzcWe9mIAto1axKYt2usRV++pWAuJU0Hfi4//yjBi?=
 =?us-ascii?Q?iOZJBaZ14lDNNB1ie1QTgtp+wmr96l64o2uN206TOn2r1UujYUUOWcKGJSM9?=
 =?us-ascii?Q?eDp52tApPnDcMexQNPpMndI4znDjVHcMDyFmIvToaHxPTlEEvb5RzxfOBZNe?=
 =?us-ascii?Q?oWyFpTCcyFe7vbhgWJYC7Pi24lmu264CsgmRCNfUthdTATndPnO8DVMnySCs?=
 =?us-ascii?Q?hpAnaaZrCMEe30oGF6F2Dm09auohVoNhAu92g/wYexUX6Y/ZuYUDZuUSfRRl?=
 =?us-ascii?Q?gYQnJTvdLfn3fPeOmqQPdgDh9/E9D5H49EfIlVkwQPEL6Dlh7vpZb+CIm9AG?=
 =?us-ascii?Q?3qAPdJghsLEPlUMahDLvIb0Ja7B3o4T2mfuVEOgKHpU2bDSnU/XHpfr6q+Xe?=
 =?us-ascii?Q?5wGIt05lPpDmqjhi9KNiaC+Obf2haYopNm5XJ4GVf2mkyn/3WVyMJEjB4Igt?=
 =?us-ascii?Q?+BUR5aTAExUHa1P40ibI3zAM1lATvcqBm981vz1NKC6pxJcZu85JCjqFq4Aj?=
 =?us-ascii?Q?pAXQ0uz4aJonlhRV4MmYKDxz8QteA3Fiuqln46EN54IKTejErZZmVwMC4M2W?=
 =?us-ascii?Q?uPaP6UOmlV3b5tvFL0znPQnJZrrEVE3VZTtI?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(82310400026)(7416014)(376014)(36860700013)(1800799024);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Jul 2025 03:38:32.7357
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 3f0b1238-43a6-4be5-3575-08ddbe9a1417
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BL6PEPF0001AB4A.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR12MB8289

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
Reviewed-by: Tianyu Lan <tiala@microsoft.com>
Signed-off-by: Neeraj Upadhyay <Neeraj.Upadhyay@amd.com>
---
Changes since v7:
 - No change.

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
index 5b3362af7d65..368292309568 100644
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
index fc59ce78c477..a19691436ea6 100644
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
index 7490bb5c0776..045c0d7e160b 100644
--- a/arch/x86/include/asm/msr-index.h
+++ b/arch/x86/include/asm/msr-index.h
@@ -698,7 +698,9 @@
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


