Return-Path: <kvm+bounces-48836-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 9B759AD4181
	for <lists+kvm@lfdr.de>; Tue, 10 Jun 2025 20:03:06 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 521353A8503
	for <lists+kvm@lfdr.de>; Tue, 10 Jun 2025 18:02:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B948024633C;
	Tue, 10 Jun 2025 18:02:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="N9vmoIa8"
X-Original-To: kvm@vger.kernel.org
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2085.outbound.protection.outlook.com [40.107.236.85])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 15C631F1527;
	Tue, 10 Jun 2025 18:02:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.236.85
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749578536; cv=fail; b=RTyI9tSWJjq/fl8M/OiqviolT0H6V0P/1Lqkj8rapogOQTvsyUU9vxMfGOyWlA59lbMKqyK5rrojOeysnjvPaGQcyNxS0UNMpITM3Cz5Ugku3to//u4zZAYhjROhVDkfq/4e9rktq+lAujGtLbC8mY6JPLWAlsLInCULfe5MjMg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749578536; c=relaxed/simple;
	bh=hJJIqJIYCP/D5nvXSYOb2jhQ0lKyKaaEuLmDvj1xYNM=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=dOcwJ3TH3/x03k/v9E1gquqhvZtSze0xB7zxrdsYa3H6TRg02MkgByzpqEP2CnW8eOkRr/53vAfuSk+OGCIuK1IEjkpXL6TSLxTf/nHVHUeUKAFJzyLoZ9p5mGT2IrPL8Hr1A0xxtnthcEvbCatuG1lqNK5Ky+lJnergmPWEnPA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=N9vmoIa8; arc=fail smtp.client-ip=40.107.236.85
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=isvV8O43icsvKmAG2NXhcck+CCNsjreDNWCcNxxHZ1ynlUMiORbVH2n2IXj4qMH8WuX3/cM8UkZ1opCotSxSpiRfv4Iu+UOrlKqkkc7vyfbOcHqyztzQqvHzVVcG7QXab6TavITkHTDPuSscGntfd8jITgbHqkK4GEu7+7gSxNlDG0uPLdE8kEpGq97kLijCGWi8Ao2i5+kkyPTjwnyNf8zocrR+w4+NMF+0dge6/CPieq1RSVk3CFsnsPYCOggshmzGrt9sR/s5U25Bheg9jFiV9iXIPAnewIjHdK6756GE5QQEek73YouRjLCrgOYfo9DRnB9UZcMTPKqD6eEqDQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=7LkLIRcXYIPmBAAnlIdWd+OoMuw3Epjx/V5seHr8LMw=;
 b=tg/zYqkGAIe9c1asrj08mFbSg5WkXQI4OsPHgeLBwFTT8ylX/4uJdKUw+kcKTJqqpw82fjB+rfe9yNbow32wINbGw839w/v5tx+U3beGoBfTnBFBBvGhNQYZb9P65D0JrDCMBIYe/0iGawATzqeoMYPif1Fh4LVWnviZxeBhBTtDxYbQ1jF0UMTXfl7hzLIPgmzuoq5cXo9ohCU53ut7e2MP5M3lbbVTTYjWyjMbBS2jz6TWh0LOn6WfCgh3Iq0PdQ4y2oIQ10Z48rZo+gwUMGUToQ9IbLRer9yw3v2PjVXMJ0qDhHN/EgkNaWLPRMhJOnKhPvGWwPFVl8TXZpyvYA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7LkLIRcXYIPmBAAnlIdWd+OoMuw3Epjx/V5seHr8LMw=;
 b=N9vmoIa8TUXljeDss6zMvrSAfj1AG+Y9Np5O2d/oL72ZCQs7lS3mBs8JOviDFtXGxTbeo2KHsdpAP2Dy+RcRITnuqxqowxKDUUQlXFVet7wvXYNWlLdTJ41gKXeUPTRoEsovl1idshCDgFZgBKK7ouCuIjBI/8z3PSLeS68x2Q8=
Received: from BL0PR02CA0017.namprd02.prod.outlook.com (2603:10b6:207:3c::30)
 by PH7PR12MB6786.namprd12.prod.outlook.com (2603:10b6:510:1ac::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8792.34; Tue, 10 Jun
 2025 18:02:08 +0000
Received: from BL02EPF0002992B.namprd02.prod.outlook.com
 (2603:10b6:207:3c:cafe::cf) by BL0PR02CA0017.outlook.office365.com
 (2603:10b6:207:3c::30) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8792.35 via Frontend Transport; Tue,
 10 Jun 2025 18:02:07 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 BL02EPF0002992B.mail.protection.outlook.com (10.167.249.56) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.8835.15 via Frontend Transport; Tue, 10 Jun 2025 18:02:07 +0000
Received: from BLR-L-NUPADHYA.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Tue, 10 Jun
 2025 13:01:59 -0500
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
Subject: [RFC PATCH v7 20/37] x86/apic: Add new driver for Secure AVIC
Date: Tue, 10 Jun 2025 23:24:07 +0530
Message-ID: <20250610175424.209796-21-Neeraj.Upadhyay@amd.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20250610175424.209796-1-Neeraj.Upadhyay@amd.com>
References: <20250610175424.209796-1-Neeraj.Upadhyay@amd.com>
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
X-MS-TrafficTypeDiagnostic: BL02EPF0002992B:EE_|PH7PR12MB6786:EE_
X-MS-Office365-Filtering-Correlation-Id: a5ce33a8-f8fb-41df-4da7-08dda848ea42
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700013|1800799024|7416014|376014|82310400026;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?qpGQM9dq8VuYUNfOPB6JHKFOooLkDs90c2yUiCHiEhgGvYGuFBd4MaFaech+?=
 =?us-ascii?Q?fX5MrEocoMeroDG5mJBElrxy3lS8xN/6458XoMF07tg4STAX4GOpBkfgvXBy?=
 =?us-ascii?Q?TYZqDmauQVuPiAcaxwdo+wzBsc3N6sDRfdNp0lSCXM0nUbjqdAV7GcIJXM1c?=
 =?us-ascii?Q?fliSMztnBZH8OejNQaMTxOTojyzraVFBpsVz8SQPjk+porLK8N/2A9uI1k+q?=
 =?us-ascii?Q?tceDc5nvV8CfDFeAkzpbVDj8N7JlQi0ytXQfIAtWtSib9HMDPTbJPedft71w?=
 =?us-ascii?Q?P8mPLYs0I+pz0RItxeoM15WpODuK5wUScoj4KNr56Z6wthTEy2JqHmtpaFSG?=
 =?us-ascii?Q?JzyB47PHQVAfC4DNztVe8EkCBS2wApDHOQG9elrEVhf8spGzJCHtcN+wPMcT?=
 =?us-ascii?Q?jCd1zuW/c1QHaTZC2zfwC7M6YyWKshFpBWXSGfPUf2q5GHBmo9px9tY5z8mK?=
 =?us-ascii?Q?RfCqD6rwtwRq6Z/C57uM8kaXE7OtFbvYHS3YS6mpldqg46xFrMaxguZ+H42s?=
 =?us-ascii?Q?Jv2UZAvbEX1jyH6AUuFDRU1cbK7PDehnTVzlNotoCXb9VPH6x2gJyYNXQNTL?=
 =?us-ascii?Q?EdliB++oycqOCvju7s79Y2+IVZcr5mYQHUTb1q2gaqFG/+/4WO1QZbMVM1bV?=
 =?us-ascii?Q?RheliIlgoyKtlglB+5G8nkoFKWRa1BeHuQdDGjjiVteqa2JfTq36u0/tYMnh?=
 =?us-ascii?Q?JawIvNSEK695VYyJYUVj7nKflIOj4eTSKZtAbskkDhItl1+My1Oby+itKO4w?=
 =?us-ascii?Q?uHc1/zpOC+j3G05afwzr4fJUOwtvbyYjDnHwo+iQrmlYJKLGrxRF+jANWHX8?=
 =?us-ascii?Q?tVbYLRo+GcZS7+UPiuXcrAIP4vRxZM8UFcqxwFLEAYoZ58K7Wmsk9zDsQc0e?=
 =?us-ascii?Q?LLdQgq35xsdmdCdAuGOh/AD86ZMZrPn09+Th1vtdHMQrLe8s9hJqJ8OqVQYq?=
 =?us-ascii?Q?FxK65xvEAbTVqgzSid7aRkdv5RL39ugTwiefy1gsWiDSKSFyp4G+/eL3vHcB?=
 =?us-ascii?Q?FU9igviJ02oROLVHOYfqOiKgKTlmnHy4UvA2PdxAj3+ZsmUCDzkNl7dUl8nv?=
 =?us-ascii?Q?f0ZlWaZYjD3aUeGr06Lt2v8A4c4Qwjvb8OMmOFPS4GEw+fthcoxqFIxMmeJP?=
 =?us-ascii?Q?R0kHbvh9NctF8Gcvsw12n6VhkbRv42xadPhOhb6U0vmwg5A1mG/UKSDSMyW6?=
 =?us-ascii?Q?EoW9hXfYNA6C9Bd792HLwseyMco/2i27kDCMLG3tjNYvOmN54x0BCd5SPSXD?=
 =?us-ascii?Q?jtDEdyW5/fyZ2++ltmwjloeOVBAkHSk1lrGDhAgzvXyhE5as6eiM8YEk35RT?=
 =?us-ascii?Q?qf9MhWNj/JEGGfTWDyedKvL35zs9XVdtKmSNRdcCySkR9a+dNMK1gL9QL0Cr?=
 =?us-ascii?Q?YMa6VbL/JsFrQKcAEDo/CH/CGmw4FCW2pb+5G3ce/TFi2j8dwKyGHbqrHGYK?=
 =?us-ascii?Q?pJn7hDi+oXB+PBn9XNVfQO2PrUQxXPhYS+NMvKqJKtDvfS/s3Lnqt35u5vXn?=
 =?us-ascii?Q?z6uS5C16CZ2NXTCb4eOs+GkNo1yQ8idJ+PlV?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(36860700013)(1800799024)(7416014)(376014)(82310400026);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Jun 2025 18:02:07.7371
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: a5ce33a8-f8fb-41df-4da7-08dda848ea42
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BL02EPF0002992B.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB6786

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
Reviewed-by: Tianyu Lan <tiala@microsoft.com>
---
Changes since v6:

 - Add Tianyu's Reviewed-by.

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
index 340e5468980e..23afe08327be 100644
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
index b6db4e0b936b..e4d89a5f9f9f 100644
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
index b7dded3c8113..f617c8365f18 100644
--- a/arch/x86/include/asm/msr-index.h
+++ b/arch/x86/include/asm/msr-index.h
@@ -697,7 +697,9 @@
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


