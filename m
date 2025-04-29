Return-Path: <kvm+bounces-44691-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id BA73CAA02A4
	for <lists+kvm@lfdr.de>; Tue, 29 Apr 2025 08:12:24 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id EECDF5A5E05
	for <lists+kvm@lfdr.de>; Tue, 29 Apr 2025 06:11:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 353B827466A;
	Tue, 29 Apr 2025 06:11:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="WPQisdVL"
X-Original-To: kvm@vger.kernel.org
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2077.outbound.protection.outlook.com [40.107.220.77])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B3BBB2741C8;
	Tue, 29 Apr 2025 06:11:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.220.77
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745907098; cv=fail; b=IE++tb0SmxKKjjSfF6Dpv/bi9eYMSfdRxgbc5+n0Oql8PWW14XpjjJS1AmWpLXrMqqnxUkp/0WxZK63HSbvruSo9+gEyU8M+ogL8vvlPmePuErfO3Hk+lMILnMpVepYD+Co1LNBzrxcsNpkJrglS+NENRfETlAOKhXimgusP3/Q=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745907098; c=relaxed/simple;
	bh=jLd6XQ9S8cJssxDuNdqUObyaVe2dT0d7KWCQe5rsIF8=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ncFMpbCDuOIz7YBLZNySH+rGcG7OmQexHlk3riMYDe4wCNwlWb4feeQruifCcbCJ8p4ejuD3i61el9PfwFaQ6ejl9tnHTe3PfjNwrgFB9W0W2RDS+PMH4UeaccvoZ0SRB6Ckh7ptcv3o3Dj7UP2apSIhvz9HtM/kqv239sYdjpo=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=WPQisdVL; arc=fail smtp.client-ip=40.107.220.77
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=NT2MYTfV1Mmb0mCy0K7gEN5uzKHo3VBEtJwAPbiKzY+JRq8tTga3hvHVgoyIl+rTi1tqaxBdHIc2TOWtrnFVE0IebDN1M96mBPLhGGoaRziB6ytlPtqX2kj9WK4lBDl7s0QnBNVuZOFU7MIUdA8HWCfXe+wc1bT0tFA2AclRVz2piiElQNl05eUGmzkooLNBZzDl54rsDgfV5zS5Ial18l7ewVIKAC9J4ngwkUP8nyXPMzqIkxXMrSF/FIDqwJtNpK/0CtBQ4DtG3aVbMn8fWDRlYVOhJj91LlvFi9zMujJWdJQd0Z3d8m6IRVhujxpu/ND3WskiYYBiQxchHEE9/A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=4ybKsW75ceHcs3MwENBEDaSxvdOHGRiWsprw8BAtmQI=;
 b=nNncieCWuv02YDIksAe4TWckh5yiw34x9AUB3wxkogJMF848d+wYtk5ASIilbXo6Cdy8T0FCAbvJ0HzJc9+IfyAR7WhhsBC/EjyDvY/2e9xNCypQxBPF/NABy7U1OqO0TaTUcSMzQE5FN3IoO5bSlWW1v8r0i2DNljJYVwc1IpI1dgSZDVXRk06vbnAcneafCPKoCxIkRsBbVol97vt5K93QjPU9HAuiuxKWTykgvQTADyS+CB+F8mG8ZuT0A+9KCjkbxQGW4RmQjLvRfMGYriw8XVA+ncTuyCi/LfnAct/5qEkjXPtZtrR2D9C2xB2U5AoVJOKj1/Ar4kT63hgy4g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4ybKsW75ceHcs3MwENBEDaSxvdOHGRiWsprw8BAtmQI=;
 b=WPQisdVL9/54f4OaG1hic0/O1Av8UXIblkSLbthU7fMDrBPvPcRr/YULgA2tkdEqKn1ueNUtt/OdRKItJqa+Nw6qlVOWZHppzSEWxgj2Kvawpx1MVGEatMCZVZm4ihs9xmGG0EIXOD7Xhy2yptwlzqWbFlkpfkn0PiuzrEriHgk=
Received: from MN2PR14CA0026.namprd14.prod.outlook.com (2603:10b6:208:23e::31)
 by SJ0PR12MB6685.namprd12.prod.outlook.com (2603:10b6:a03:478::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8678.33; Tue, 29 Apr
 2025 06:11:30 +0000
Received: from BL6PEPF0001AB53.namprd02.prod.outlook.com
 (2603:10b6:208:23e:cafe::e8) by MN2PR14CA0026.outlook.office365.com
 (2603:10b6:208:23e::31) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8655.38 via Frontend Transport; Tue,
 29 Apr 2025 06:11:29 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 BL6PEPF0001AB53.mail.protection.outlook.com (10.167.241.5) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.8699.20 via Frontend Transport; Tue, 29 Apr 2025 06:11:29 +0000
Received: from BLR-L-NUPADHYA.xilinx.com (10.180.168.240) by
 SATLEXMB04.amd.com (10.181.40.145) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Tue, 29 Apr 2025 01:11:22 -0500
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
Subject: [PATCH v5 03/20] x86/apic: Add new driver for Secure AVIC
Date: Tue, 29 Apr 2025 11:39:47 +0530
Message-ID: <20250429061004.205839-4-Neeraj.Upadhyay@amd.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20250429061004.205839-1-Neeraj.Upadhyay@amd.com>
References: <20250429061004.205839-1-Neeraj.Upadhyay@amd.com>
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
X-MS-TrafficTypeDiagnostic: BL6PEPF0001AB53:EE_|SJ0PR12MB6685:EE_
X-MS-Office365-Filtering-Correlation-Id: f043ed10-3697-4222-9adc-08dd86e4aeb4
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|7416014|82310400026|1800799024|36860700013;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?h02Y/PMkB8l8TDz2Yu0UN90lIL81rUzbRgHiPs6NEI95cgfeUt1SnuB3iJ+D?=
 =?us-ascii?Q?lKd89bnbFj7JrwtXk1099pk2jXcW3vlplzIDvAdci3F14cCDqvwiYmUyikBT?=
 =?us-ascii?Q?yRSDoXahOoNdwjLcXvyYVY9c8V6qGKFb6OFOdIjBzwV4SqQzC1ALGKMKUyk/?=
 =?us-ascii?Q?3rPyJCgb0tyXsSnxziOfn0ykxyRkE7OzWTMeDW4XYgM00ngTSOzXjJaGmmkl?=
 =?us-ascii?Q?SB7EjcWepBWS995wFM7ZuUQsr+7/UiKRPbHikkT9H8M+KpKqTDzlxFc2Y6i/?=
 =?us-ascii?Q?efMAtmZLWj7SsJFOpuZap64WpUGyFPJv8TT+qwSAkpHVviEhR/8+v65bQ4Ls?=
 =?us-ascii?Q?Cn6ch3MJNrXey/p0gsjwsh0ZgihsySrlVwPjGeTlnhWQwQo2hW/vrZIUmkHJ?=
 =?us-ascii?Q?nOqB8GMqnFIBXUbJUilOkM3vQK2Hgdqkp2izHFuxp+YNhRyh0AaNAMx2g1Sy?=
 =?us-ascii?Q?D2fuqUeYQD5daHLWBvZXmYEFyyb0Ru96P+tL+jRfPSaqySSkDsevnV8fSA/a?=
 =?us-ascii?Q?PSHUqo7ef9VgNRnYSv8diduipAIqnKTU51V7i4JksMSGbqzZOYeHujK4F38o?=
 =?us-ascii?Q?wpudXWUvSjCnBNFCyHv0K1z7r1byNCpjKcI5a2tlc715utS9zf1Tvz1Gh5EF?=
 =?us-ascii?Q?AThlhGvGS37Tl7uyZZkN1EI0FU7uZQOTh54sJ4399Je/GMwd1MEZAK7epST0?=
 =?us-ascii?Q?R8bw1vMzXrJ8ny78MKqrM1qOn28OL1VS8LOweW1JvKiksrvYP0VlDwuuMhkw?=
 =?us-ascii?Q?QfekXijh9uq080jBQe6alzsNz8OFa9Fk0N+8u6fMvO+wMrkBf2BrikhyfL6H?=
 =?us-ascii?Q?//eXk8LCgdxcAZbWw3vvtEgHghF4Sq4hpxjuh1BQDqvY5JdX8lolt9Tlzl5w?=
 =?us-ascii?Q?hrMLQqP+TAvkOMuzz1LfNC5eSJLIrvlMz1CVg+N5ynzhyzf4XYSDpv3bUgRT?=
 =?us-ascii?Q?IfktNx5EoBjBcSDbtJwt4/jsTCFwr7HsZAW3mkF7KTGEneEKdMUUqBTjE+vc?=
 =?us-ascii?Q?x/wTIOk66BZFR882j1pRUQUKUjenGKD0EcY/OHGhQAkzxXteh2I7Qg8Ip1Zq?=
 =?us-ascii?Q?Y6D8BJd714kzg7AQ/cuxj+kF+sEGHIVzrqsCbzjqKcLvIBjtCnWmnLZ2KI0B?=
 =?us-ascii?Q?pAWRN18icGE2KrRYMIWq69LUXCcoW/9b91fYqiftdyWs32Fgoi8mbDZu09Nw?=
 =?us-ascii?Q?xh6QMSFWlrLi25OOJD+pMGY8g3NYcORBmCdnBY7G9tYc5nSY67eGA4LOHXqx?=
 =?us-ascii?Q?JGRlvnZGUCKBDXdCWSpqiLRgYJpbIINPtpQk299sMocG6Zg5E1gfOvpFVTtR?=
 =?us-ascii?Q?tfszpzoZy2kCoKNNy4+xlLabrH2H303WtznFaNIsqdeif+RceOb7DjjCjcJP?=
 =?us-ascii?Q?hSg2SHE3ZjS49oqxj7QP0sYpJ8kNXzzjBMAz31fwg3KTYtGaUlgs0frqEkEE?=
 =?us-ascii?Q?NAIEL0W+21ez7aM5i38sTWCm97Fg8PoZ+AK2gO0o20biAz3HPQW3aDPRekSD?=
 =?us-ascii?Q?BoFPrZqTQVNp4cMb3INCgBlr4XkAefI68yrb?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(376014)(7416014)(82310400026)(1800799024)(36860700013);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Apr 2025 06:11:29.7772
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: f043ed10-3697-4222-9adc-08dd86e4aeb4
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BL6PEPF0001AB53.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR12MB6685

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
Changes since v4:
 - No change

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
index 478c65149cf0..795c1bd74141 100644
--- a/arch/x86/boot/compressed/sev.c
+++ b/arch/x86/boot/compressed/sev.c
@@ -364,6 +364,7 @@ void do_boot_stage2_vc(struct pt_regs *regs, unsigned long exit_code)
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


