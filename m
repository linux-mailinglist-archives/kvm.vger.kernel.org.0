Return-Path: <kvm+bounces-43540-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id E9577A91785
	for <lists+kvm@lfdr.de>; Thu, 17 Apr 2025 11:18:33 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 5D82D44652A
	for <lists+kvm@lfdr.de>; Thu, 17 Apr 2025 09:18:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6D8AB226883;
	Thu, 17 Apr 2025 09:18:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="kODfM7Rw"
X-Original-To: kvm@vger.kernel.org
Received: from NAM04-BN8-obe.outbound.protection.outlook.com (mail-bn8nam04on2052.outbound.protection.outlook.com [40.107.100.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BCE5C207DE3;
	Thu, 17 Apr 2025 09:18:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.100.52
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744881500; cv=fail; b=FIar0WxbzbTD2TEaQvx6o4hxQOMUtqkTJwQzvoueVp0w8ZxZMISZwEnOgEtbWPILjr+arNaHnTatA3+OMs7I61MD3ABxG9qWc4SpKxzi5dlVXi5jaZ1rmED5OuPGlZzMy3c3V4XnkovXzet9iGnj4YPJXSxlRVRhAKuB6OIXteM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744881500; c=relaxed/simple;
	bh=3J29uTJ3lylg7qpG7RdGPO8+sHtE9ITbyPnwOR4pZVQ=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=JSAt60lsbLBzx2u0B9uROPXQHeYx4kP5EHf8iWlhsDzqjmlyQVeC/J6ZU1whPTma/PPNlDGw6VYjL6UctPALyG3KvshIhHHLWJmM38RW0ivk00MVOdSrXPgMeo2SAJOwGciyr8h0r05Cah8wbLP+gtfp93whc+SzMUt50x8L1FU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=kODfM7Rw; arc=fail smtp.client-ip=40.107.100.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=NY13VxGdwip0yB44KC9dkamaQGFp+4zzPtCRnPCGudykNMOorNz0p8VUYn9r6FknQB5+1OwiiX71xWPh9YVxArNrLN7m9aR47vdFDOOSHOW6ipuF0sHSC60sv5i6PP43rIrwWjg53bIKWgE9LJ0I61DS5EWJY9aG9pl8h+GVjb4WLtjVdOMYxdCDlVhdsNrMiIoMQLBJM6BtFGIk/dhlzzGTEUga0WiwXtY4GzWyAMfG/sSEV0JwGBQABcamS/ZgX3n+MTMpsws2jdo5Wzs34L2LlI3nThp+sWlOn133foBknrwalt360KejS9F4zStHIijJhQDteuJKnx40JYB4kg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=oIetTAEo+OAsgsq1z78tYJOioTcVJuq8iyoRWEOMDtU=;
 b=QV7HIqJRh1HUaJUb7vEIW+kKvzXrLf11Ro0WKTA2GzVMWxFkDpxwE0LT0VCprLt6phUcx/MK1y++jh+nP5Z0sIELwBwUiNXcsT3sekH+25z4iDv0IT3a0/r6SlafGtr8gtF1uvmZuxXymwgBKV51JlU1DFXaK3WSyJi9S66xy99pLcN26uO41dItD9LvXdwX9FyXSZf1X9uAYT3Ly9c3VB4TsjOdlszNosuOp0cWWY4i1lLO6FYfojkNfwGcYaRDzu3i/G6dVv5jjrfjVa4CYSdaa595row3nFU3SZQQLfmLRBRmnLR4mSK7NE0DWpTjSH+7W7jEs4NPfZ0NpLwB3g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=oIetTAEo+OAsgsq1z78tYJOioTcVJuq8iyoRWEOMDtU=;
 b=kODfM7Rwo124FRDcmxz6/Pgi0lNmHpe/pXA38yQMTLxMc9FkucobagmXiBG4z56eDo0QcmpN6vLcdmUCYcTX7LEl4ubl9/bXOhOFinBecRyamAy0gH7eGfdQ72yewrXwCskIgBJzgzrXuO0Kl/uNbThAWWSy5GElXns5RCXrdDA=
Received: from MN0P221CA0005.NAMP221.PROD.OUTLOOK.COM (2603:10b6:208:52a::15)
 by IA1PR12MB9532.namprd12.prod.outlook.com (2603:10b6:208:595::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8632.33; Thu, 17 Apr
 2025 09:18:13 +0000
Received: from BN2PEPF000055DF.namprd21.prod.outlook.com
 (2603:10b6:208:52a:cafe::a1) by MN0P221CA0005.outlook.office365.com
 (2603:10b6:208:52a::15) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8655.22 via Frontend Transport; Thu,
 17 Apr 2025 09:18:13 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 BN2PEPF000055DF.mail.protection.outlook.com (10.167.245.9) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.8678.4 via Frontend Transport; Thu, 17 Apr 2025 09:18:13 +0000
Received: from BLR-L-NUPADHYA.xilinx.com (10.180.168.240) by
 SATLEXMB04.amd.com (10.181.40.145) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Thu, 17 Apr 2025 04:18:02 -0500
From: Neeraj Upadhyay <Neeraj.Upadhyay@amd.com>
To: <linux-kernel@vger.kernel.org>
CC: <bp@alien8.de>, <tglx@linutronix.de>, <mingo@redhat.com>,
	<dave.hansen@linux.intel.com>, <Thomas.Lendacky@amd.com>, <nikunj@amd.com>,
	<Santosh.Shukla@amd.com>, <Vasant.Hegde@amd.com>,
	<Suravee.Suthikulpanit@amd.com>, <David.Kaplan@amd.com>, <x86@kernel.org>,
	<hpa@zytor.com>, <peterz@infradead.org>, <seanjc@google.com>,
	<pbonzini@redhat.com>, <kvm@vger.kernel.org>,
	<kirill.shutemov@linux.intel.com>, <huibo.wang@amd.com>,
	<naveen.rao@amd.com>, <francescolavra.fl@gmail.com>
Subject: [PATCH v4 02/18] x86/apic: Add new driver for Secure AVIC
Date: Thu, 17 Apr 2025 14:46:52 +0530
Message-ID: <20250417091708.215826-3-Neeraj.Upadhyay@amd.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20250417091708.215826-1-Neeraj.Upadhyay@amd.com>
References: <20250417091708.215826-1-Neeraj.Upadhyay@amd.com>
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
X-MS-TrafficTypeDiagnostic: BN2PEPF000055DF:EE_|IA1PR12MB9532:EE_
X-MS-Office365-Filtering-Correlation-Id: b443564d-67c3-4cf4-86ea-08dd7d90c7c9
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700013|1800799024|7416014|376014|82310400026;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?e8u6fZtQ6z4aiB/EZnprkKIH3+Yb9ziXx/ZvM/rmM5o04JJDPyQbxP6tLmAD?=
 =?us-ascii?Q?1SEvkZpsFO99DdvoVC43sChHdbr6M2aMDlEnOcre8AGIOPuSgKFN2+zX16eQ?=
 =?us-ascii?Q?9MODvxjc3TgtDLTJblgLMiTJUjBIsznvqcIMua81DxBy7yxwEuQ8jf2xFb5p?=
 =?us-ascii?Q?J4J8AaQ42Zo+GRRWrJrXfB6QGMMdshqtB36VfmZN//IAC9JGEO07dzqcjqXm?=
 =?us-ascii?Q?1qEf2RYmMOh/QrjuAKA9DMOhSpqLve8PrGsZzRlLBJXbUzITaAyRSG7cgd8s?=
 =?us-ascii?Q?Bg3auEqVzhmP0ECZ51Pjypz5sIIwVcpvDTcQzf503h/P+Rc5jnSQhT0TWbbu?=
 =?us-ascii?Q?YziTybjf8VdqieapZ3FvNExOoK4Z9YXRYTOROApqg/TiQsDveNHfUcne3ut/?=
 =?us-ascii?Q?bAWQwrAaYiWR55xuevssP0Yj5e1VvRAEhkTpEubHq8/tFGP7rLNZBZk4l5mN?=
 =?us-ascii?Q?ZOTwMHhuussaeBaJPRF7Tivl3Flrl7opsQGnnZ3S4gk+rGVxfl2hwc3zNGjJ?=
 =?us-ascii?Q?QRI0jro+pKfQ/LTbVWmngJ2474GyQV8i5xoDtGSNcOEY/ZKfB5Omfvw/gjEX?=
 =?us-ascii?Q?VZagvMhXCjBefKIhqqwZE0TEV425H2Fc1294sUnfFb/efwyu4LyRUDcHuoR0?=
 =?us-ascii?Q?GjifEFezPHvLhxHu69HuqLIMtWXhDmlXVHGnQvh+HcOsRPBP5g6w/tVflPG4?=
 =?us-ascii?Q?VnvKfoGCQAsu/35w61zf+h9V3tNXD8bfXjeZ1ryI6nfv2QsXlhBc53g2uk2M?=
 =?us-ascii?Q?2za/FodBbe2BdyBV7WDGFuj5Utt9CFSrChv4lQq1xwyi6+k++f0uEVy0qKn1?=
 =?us-ascii?Q?pdopC4U4n6z7q1rhmuuK2HbFVhfwdFxLfMrT9vwbmOT1mLZkIFVhlvrBTdP6?=
 =?us-ascii?Q?KlFxSFw7Yl38TjYn1yMGqEdJSYiupjeA5qoBeqcJ365ePRp4kkNFApc0a4Xe?=
 =?us-ascii?Q?4U/IpxR+Upgj6/B0hRCkLUopr0DCVfcWRaL+UK8E0hK8x6GcdfPIB7rSNQWc?=
 =?us-ascii?Q?6jDt2GDDCK8JKRFVRuRDp0qd3INMBtgI2llehEdVg+7m41yjetLJZhhuz3PC?=
 =?us-ascii?Q?9/SknPPFpg5xvav+nAYLKOpTFZfg5tHzPHXMdEagULJ/BpwzRLFY2/TDqgxT?=
 =?us-ascii?Q?hBVbX9FvbbZBVPsjES/0HZt09+eP+GVHGhj5tjN9wdjal3OKgfPZfwlWbl5C?=
 =?us-ascii?Q?FO/pCSY3s8ALuZC/uPVP2aEWDttALVSV9LztaTZkDQZNsgIv/M2nQArtGD5x?=
 =?us-ascii?Q?D4o3rcxFc2Ftm0BtGrDlPTYLbAXfBX0Z1Epf+Yhcly3RkFO6rHj9WkGSL/kj?=
 =?us-ascii?Q?Ou6tgKebGLTa/yOcWtsWc7jjq+KdKLVqvtuVIIUuUt5JsjyyblR6V10LboJb?=
 =?us-ascii?Q?GVJOj5WYTqBNvhmDBHfd0S9Lilao/JgEF9s4hn+Uys8E+hWMo/9pOwxcj6Fz?=
 =?us-ascii?Q?aZe8CdMg5qWd1Yos17phgWq40tmY/zyonIllVgnYAin9CjoBOXSis8eK+0Dn?=
 =?us-ascii?Q?YJlQIkVObgHlVakTJ5Ti9zLPhG+nP7cWtm4i?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(36860700013)(1800799024)(7416014)(376014)(82310400026);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Apr 2025 09:18:13.6685
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: b443564d-67c3-4cf4-86ea-08dd7d90c7c9
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BN2PEPF000055DF.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR12MB9532

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
Changes since v3:

 - Removed IPI callbacks which were copy of x2apic_phys.c.
 - Add a comment in savic_probe() to mention that code after
   snp_abort() is unreachable.
 - Removed "x2apic_" from apic callback func names.

 arch/x86/Kconfig                    | 13 ++++++
 arch/x86/boot/compressed/sev.c      |  1 +
 arch/x86/coco/core.c                |  3 ++
 arch/x86/include/asm/msr-index.h    |  4 +-
 arch/x86/kernel/apic/Makefile       |  1 +
 arch/x86/kernel/apic/x2apic_savic.c | 63 +++++++++++++++++++++++++++++
 include/linux/cc_platform.h         |  8 ++++
 7 files changed, 92 insertions(+), 1 deletion(-)
 create mode 100644 arch/x86/kernel/apic/x2apic_savic.c

diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index aeac63b11fc2..d2a505000a9b 100644
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
index 6eadd790f4e5..a418e80cfcf3 100644
--- a/arch/x86/boot/compressed/sev.c
+++ b/arch/x86/boot/compressed/sev.c
@@ -399,6 +399,7 @@ void do_boot_stage2_vc(struct pt_regs *regs, unsigned long exit_code)
 				 MSR_AMD64_SNP_VMSA_REG_PROT |		\
 				 MSR_AMD64_SNP_RESERVED_BIT13 |		\
 				 MSR_AMD64_SNP_RESERVED_BIT15 |		\
+				 MSR_AMD64_SNP_SECURE_AVIC |		\
 				 MSR_AMD64_SNP_RESERVED_MASK)
 
 /*
diff --git a/arch/x86/coco/core.c b/arch/x86/coco/core.c
index 9a0ddda3aa69..3d7bf37e2155 100644
--- a/arch/x86/coco/core.c
+++ b/arch/x86/coco/core.c
@@ -102,6 +102,9 @@ static bool noinstr amd_cc_platform_has(enum cc_attr attr)
 	case CC_ATTR_HOST_SEV_SNP:
 		return cc_flags.host_sev_snp;
 
+	case CC_ATTR_SNP_SECURE_AVIC:
+		return sev_status & MSR_AMD64_SNP_SECURE_AVIC;
+
 	default:
 		return false;
 	}
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


