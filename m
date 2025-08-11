Return-Path: <kvm+bounces-54389-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [142.0.200.124])
	by mail.lfdr.de (Postfix) with ESMTPS id 626E1B20430
	for <lists+kvm@lfdr.de>; Mon, 11 Aug 2025 11:47:20 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 227D34E13BC
	for <lists+kvm@lfdr.de>; Mon, 11 Aug 2025 09:47:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9F8832153C1;
	Mon, 11 Aug 2025 09:45:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="rAW6aDNi"
X-Original-To: kvm@vger.kernel.org
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2070.outbound.protection.outlook.com [40.107.220.70])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D77122135B9;
	Mon, 11 Aug 2025 09:45:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.220.70
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754905530; cv=fail; b=n7Xr7AwQcx0BWGcbonDPdLKn23g3Kk8OHLk99NMd5os1mzZFP7Ikqw4e4Sycsa+03ZrrQeGFJeezw0NgHfRwR512xZHqEIZAnECVePToR/oj4TdoN6qdUfsXSu5rZ24pp9KdP0XXCeIA589Bi+g26cvdxsQ6afmSjXBq1lZbjsQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754905530; c=relaxed/simple;
	bh=GnxOXz3UPszb0HbrmadTEH71buNcoGwZWzLkvXTL1mQ=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=sD0wXv+rs9XwzlDxhhFo+SL47KpgLPJ6syjfMnV7fIo9gRrNO26HvuYRkBLc8D52f4yaGozYbaflacBA/iOOusVHa8cNn3DhoV9XG6kKJFQ9jbzFNh7gQfrkqv5goEzqOx4Zk5cQOteftZRkVa19UFU1IzPjpumiYGiOrSkgHcI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=rAW6aDNi; arc=fail smtp.client-ip=40.107.220.70
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=LXPdjmsbPkNXLU3r5CGKw2xV4M+Ps9zjYFFvTlkqGH6dSILJSEb7BnbkGojbmRyYSR3WfpUHYHGwAUBRxX5dR+TOKyVfL9BSRcMvi/TQvzJUu+8Qt3fgMPbqx7kLi+kMTGiaE8OPmysbgxU9pnt5dxt6Qg+MXFdk9xNsXTuUf33Y6jxcxQZqB3IC0KbyktnCOzCTbxeUnb8NWwJ19WTl0TNz0/yX9zJNhl/ut/9tanBLd/8GjjWDPfbjbn/lqCT2cPmqzcMwtdd3FTL2F9Qrh19h7LySPYbaxr5kaSznwlpbQKPnOZdOqVgF6ecWcJ05J/Mys/sxL2gFkKeyt+S1yw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=BKH006ZAMItBEGlpnvTF1I95rE/W/mHAGCcRBsgSCNQ=;
 b=ZExaAyoWvsTcfw8MhFJApi3WogbGn1+j7ugvuKwOs4XSBYR9ryQbfgdnKJuHAle4YEo+hOtDJfp88HvocdD52BmbFKKl80KuojmWHY1oa/XnKsTnMd6bAwLszkHc2z5njnjd5ohZY77ryn3w/6OdecIkXU1sN+BMbc4mhumpUWrfL0YzGsWk1hztFrairfVhjpNUEUxrD/ZXUin3QqlRB0c0Z1xmTThF0aLP0ca1R9NdAby5JP/UdbIcPdzzxu5rW4ldqscB9tyhYOgl3bnGuPSy/ezRTo10c29bPOHmnaMZW2yHUeR5O04nJnWDBHE6YwuAAf2YMl23J9CpdJ7oOA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=BKH006ZAMItBEGlpnvTF1I95rE/W/mHAGCcRBsgSCNQ=;
 b=rAW6aDNi4d+xMWocYP/IK9SiDZz7TCAvktH4zddXy9qNuHD/gtlFhcCPcoUk802zCUlsAOL0SQBghFRIRb2fh7tB80Z06hQCxj3rpcoc2eMhHQJxSyv4OOd4Rkc0e7q/ZnB74wGyTqCi0gmyG8u3CdxU+yyBGdPFQmH4gY9uOn4=
Received: from CH0PR03CA0264.namprd03.prod.outlook.com (2603:10b6:610:e5::29)
 by IA1PR12MB6044.namprd12.prod.outlook.com (2603:10b6:208:3d4::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9009.20; Mon, 11 Aug
 2025 09:45:24 +0000
Received: from CH2PEPF00000142.namprd02.prod.outlook.com
 (2603:10b6:610:e5:cafe::29) by CH0PR03CA0264.outlook.office365.com
 (2603:10b6:610:e5::29) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9009.22 via Frontend Transport; Mon,
 11 Aug 2025 09:45:24 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 CH2PEPF00000142.mail.protection.outlook.com (10.167.244.75) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.9031.11 via Frontend Transport; Mon, 11 Aug 2025 09:45:24 +0000
Received: from BLR-L-NUPADHYA.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Mon, 11 Aug
 2025 04:45:17 -0500
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
Subject: [PATCH v9 01/18] x86/apic: Add new driver for Secure AVIC
Date: Mon, 11 Aug 2025 15:14:27 +0530
Message-ID: <20250811094444.203161-2-Neeraj.Upadhyay@amd.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20250811094444.203161-1-Neeraj.Upadhyay@amd.com>
References: <20250811094444.203161-1-Neeraj.Upadhyay@amd.com>
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
X-MS-TrafficTypeDiagnostic: CH2PEPF00000142:EE_|IA1PR12MB6044:EE_
X-MS-Office365-Filtering-Correlation-Id: 813acd71-1782-408b-afea-08ddd8bbcbd2
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|36860700013|82310400026|376014|7416014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?yFgcS1rLD0BJdJCBlxzxt0PZD8Jv+DQXBL0YoKNUDrn7OIds8S8R9C59Ihfa?=
 =?us-ascii?Q?FqVQMRfES8dRkayQdcyHobERWSIWCWVTHAH7w+/GKRVFElRYkNPiskZsT1Vt?=
 =?us-ascii?Q?azfVvM0oIM/3TvPElUpus/TQbprFvKhiYPQ72Nxr2W6ek4Y4lKJIKqSBGvUV?=
 =?us-ascii?Q?Qn8OGTyjDXy29JmAGsrEaY5VxmQOkPi40wN2PYx6T2bcIs5s/BA2aRjRIHvn?=
 =?us-ascii?Q?oxpNcCy2PTOGF1srCMYsCjfB6aETH86KwFTMh6kjqgqlAu9NbrfGGtvnjE41?=
 =?us-ascii?Q?YtQqPsX2WYJ9Hw0b13CYpPDeL4MbkA+52LqqDwRQqyvX8ZDUMZJdIJOxNzCH?=
 =?us-ascii?Q?NY9bJ0/L91dQZYfogfVeX8EesPhZbgQ4cNwWWxIZi8lCmp684eAu15f4HJN9?=
 =?us-ascii?Q?b875fYu4w3l78L/jYFD96Ve1PWOiLzQvEIJVEOGrGFYUEN4gSfnPkI66UrXi?=
 =?us-ascii?Q?CU9mV7oCB9afkLdwWNyyx0PT+Z897RVu3l6L4Q9huGrIcbvSMFB9QusiSuYl?=
 =?us-ascii?Q?mUnqgOK1boEjp60o80WV4+x6NWlJto8GfPnVawfwV79hExV4OSTi4Borhk62?=
 =?us-ascii?Q?LrGRKAAvb1Emfhe5Z4qIrCawCnJtj8mOFC1eU0XYRw9iPStO/m/H3GPG03mu?=
 =?us-ascii?Q?h0Iy0sR3rgr1/91skv4RW24GSbhbgM3Wb3b5i1R76M3frSmEq49J23u4iGIH?=
 =?us-ascii?Q?AwqqXgE2eNqJs8f8OV0xCnlODvQmzigDC0t5jfQZ4P8Cabz4lxuHQ9wrpL4e?=
 =?us-ascii?Q?QyhcpqOvBWCG3ngqzIARn8s14nMxJxpOYNdwrLFt8Jcydt1NTddsA8SPJ+dr?=
 =?us-ascii?Q?+3i+1d2h5Hh1PC/AF0tCBfl6d1hyu3HkLcm+HH2yuj4niomq1BLG/jaJ9QNh?=
 =?us-ascii?Q?fMo5VOXZdaYZ1AglBVW5L2oTYThssNgEvzkATnHKLpc9ymXMc14zwf1mshQQ?=
 =?us-ascii?Q?GUUU9LUsm4RqahNTALKaa1nqgrUuPT43IgK4VwrR27ju9/ct9UsovDH4MZMA?=
 =?us-ascii?Q?8eSiXSmF4QM2AZ48pgyhEn1YYBKWkIds55YOhe3HAdEdRraMBo1E8In4ab2B?=
 =?us-ascii?Q?34qkH9662AJpZntPPY64LcJrzpXsZ0M7kp9S0g3jaB+facmH5Wvne5L5ya1b?=
 =?us-ascii?Q?fa/jVQYv2LlT6kQwFJXPwjV7+gmLMWFyMZhX/z/Dn10YNGpVEPOwksNJHKlj?=
 =?us-ascii?Q?O2/J3hHCeDuhL8+LVNH/EXrGtnEgFTcVudfdFWEkfs1GviyBAp7petLaRMqU?=
 =?us-ascii?Q?cJvkx/LG2fbgTn9JOeTCukj2tXCvRPxuUwXsfcd0A7kX+Wxgl7pe/sHFzuNv?=
 =?us-ascii?Q?Z8ul+nUNtydNwWcCQS7L0Ji3DFUJWv8ZnVWCvRE7cx0maxqQSl1g5mcvRctn?=
 =?us-ascii?Q?OKiQvMtcy3CQWbSWLrp4zElnZ2O1+cZBpxy294xhBORh37oh4zhAsicp1sze?=
 =?us-ascii?Q?l7+yUGMI/+0ZzOptDRFVeYqK4vWti0W/3wJ0ySuYr5qlcpRyPinufR+49avm?=
 =?us-ascii?Q?XmQMxr5BNEb3rU8EN5WqXRC3AJ1r9JNIQ27I?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(1800799024)(36860700013)(82310400026)(376014)(7416014);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Aug 2025 09:45:24.5992
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 813acd71-1782-408b-afea-08ddd8bbcbd2
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CH2PEPF00000142.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR12MB6044

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
Changes since v8:

 - No changes.

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
index 58d890fe2100..70ce4f7b2f69 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -483,6 +483,19 @@ config X86_X2APIC
 
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


