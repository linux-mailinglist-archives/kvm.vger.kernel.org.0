Return-Path: <kvm+bounces-39243-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 26EBDA4596B
	for <lists+kvm@lfdr.de>; Wed, 26 Feb 2025 10:06:24 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 19B9C16EA25
	for <lists+kvm@lfdr.de>; Wed, 26 Feb 2025 09:06:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 767ED22423B;
	Wed, 26 Feb 2025 09:06:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="lALKxbcD"
X-Original-To: kvm@vger.kernel.org
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2065.outbound.protection.outlook.com [40.107.244.65])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4A7DC20AF8E;
	Wed, 26 Feb 2025 09:06:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.244.65
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740560770; cv=fail; b=jL4FaSnHICrnYV86NsMWviYSyc7eCyqBF19dXy/xjMaftTHoocTWgB8SaiB2NAQ0FePNN28INHRFRX/dMXykv1NB+anIxYRPF4hAPDWkHbNZkBmHyBCgbSCWd67gLfKt1KP8HmNXiH5Pa3MSLzZaZQRQlzd+p6FNxoOu9kLwP3c=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740560770; c=relaxed/simple;
	bh=AGWhOL64aMztAe1CdTGvXU6UyjNJ5mUAQYMfRqkJUj8=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=B9fEiJHh056W3gRr8NTxZfo3dRiTu0AuhX+rXsmohUFpOKvmQcVaAsxV2s1O8TUY24yPNPTR7qbu2Bw74Tu4r6GbhJ5xQryPw/+29GuoyKeverfUTBaxW/i9+EcC2pQ+WUU0thqEtrjGETPdmjMCJyLO98UF0CiiAXk5jTuJjpE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=lALKxbcD; arc=fail smtp.client-ip=40.107.244.65
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=lC66LDql8V5rNm9sTlRgFFbyPDUfX3OJzLY3IwbKJFrOZ5AH/859EWbC3JY39ieSgVopiU2kFJqw1whNaxrD4fROZAoExS/HVOo+3gnZlqpGm05SXGmcktb4UV51wpGiGZvOLQ12KpOVxkOCnaKGEY67N2zF0BPoHI3NQdnk9PtHgOHK7FlfxJJqAkGc5hoD1GzvXHI+AoyO3ZSayLN6Wgx5RiBDRXCNQ9BF3DffT9io+Lj1+JrzsHUB64mD9SYe5MiXX9erYgFK1a7Vlr/tw07hC3lWPdyjr2Pf6Ll8GOHYY9juHiLCeYHqmDorBOyicZTNdYQZWgfk8YJZ/xudUQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=dyhSwW21TACWTBU4L8BDOnE5hxVwe7vAH7ppASVyoSU=;
 b=F5nRgYZNwsfsE62N1CQpgxAlF96UINV06pZ0/gBvpeuzvMjVN+NIGki0KJphZNvdSLXmbDv1V8RN+EjCz9gVSPNMfWQ3/yGBKyx49mnp3r7O8u7B/nokAGvg2RA1JHg/i1rmLacDpLU8mUPTXvVSWBahMuiG2456KpN6O2qZRVTj+ryRSfHVTRFEIuHETR58vQ1Yz6oQm3Sbg36fMonubhA8vj93J923mFbX8NspR25eUgRCOO4sz3jVDg7DeurctZ9JY3F4wNSxMKriQ9OKDwiZ/dSt5DCJZHcU9DWW5drEs2w+pD0e9t8uTv0DWqMkXCmndHtMwdE/jwgEJI9+BA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=dyhSwW21TACWTBU4L8BDOnE5hxVwe7vAH7ppASVyoSU=;
 b=lALKxbcDkOZryjgfj7EAH58/Hy3kr4tq4NsTNvdKLQNJjmdO3GwxVnWdHUeY1tViDCXKjVoBLy7cNkMY2lhVAzTZcBEILGYwUQ/B1+tC6ElcBNSHue0vxzts261yK6fer6kAHnkzH0wAzjP/6UOKD9nLkePFMhJ4gmHNXyNOp8Y=
Received: from SJ0PR13CA0006.namprd13.prod.outlook.com (2603:10b6:a03:2c0::11)
 by PH7PR12MB8038.namprd12.prod.outlook.com (2603:10b6:510:27c::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8466.20; Wed, 26 Feb
 2025 09:06:04 +0000
Received: from SJ1PEPF0000231E.namprd03.prod.outlook.com
 (2603:10b6:a03:2c0:cafe::2e) by SJ0PR13CA0006.outlook.office365.com
 (2603:10b6:a03:2c0::11) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8489.15 via Frontend Transport; Wed,
 26 Feb 2025 09:06:03 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 SJ1PEPF0000231E.mail.protection.outlook.com (10.167.242.230) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.8489.16 via Frontend Transport; Wed, 26 Feb 2025 09:06:03 +0000
Received: from BLR-L-NUPADHYA.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Wed, 26 Feb
 2025 03:05:55 -0600
From: Neeraj Upadhyay <Neeraj.Upadhyay@amd.com>
To: <linux-kernel@vger.kernel.org>
CC: <bp@alien8.de>, <tglx@linutronix.de>, <mingo@redhat.com>,
	<dave.hansen@linux.intel.com>, <Thomas.Lendacky@amd.com>, <nikunj@amd.com>,
	<Santosh.Shukla@amd.com>, <Vasant.Hegde@amd.com>,
	<Suravee.Suthikulpanit@amd.com>, <David.Kaplan@amd.com>, <x86@kernel.org>,
	<hpa@zytor.com>, <peterz@infradead.org>, <seanjc@google.com>,
	<pbonzini@redhat.com>, <kvm@vger.kernel.org>,
	<kirill.shutemov@linux.intel.com>, <huibo.wang@amd.com>, <naveen.rao@amd.com>
Subject: [RFC v2 01/17] x86/apic: Add new driver for Secure AVIC
Date: Wed, 26 Feb 2025 14:35:09 +0530
Message-ID: <20250226090525.231882-2-Neeraj.Upadhyay@amd.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20250226090525.231882-1-Neeraj.Upadhyay@amd.com>
References: <20250226090525.231882-1-Neeraj.Upadhyay@amd.com>
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
X-MS-TrafficTypeDiagnostic: SJ1PEPF0000231E:EE_|PH7PR12MB8038:EE_
X-MS-Office365-Filtering-Correlation-Id: 31ba67ba-c39f-4aa4-c89e-08dd5644cc15
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|82310400026|376014|7416014|36860700013;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?axfY9Mm2oFQc3qwm1D7GKRuACBQuyCQ/pmv84ttpH/NLWkH9S2rUNJ0eBCXi?=
 =?us-ascii?Q?1fUuBru0Y4PBE/VOrG8ZowhFJC6S20qv9Nevb8qMlqkkOkLL/xb6/jxdi8ht?=
 =?us-ascii?Q?rjKpjQ91MtFC+Q53KWJ6lidmCdKPtpTmgGVidc4b6nOV2Dy1ZPhYjouYR69R?=
 =?us-ascii?Q?WczO55P1cgzNnJYF6ua6HDlV/vsPZonWbeeqBXdyE0ARwgWH/g8HEi15VRq0?=
 =?us-ascii?Q?g4QdBDZlXZjyoHa47qLQIjIaSfFD/TwSE7bcTvKXbe1qwZzZMa7Ji2FQCLBg?=
 =?us-ascii?Q?apgCm2+OOhzT0VQDdsdixVhsJlmbHCt1/ByplRO/fY697hLSH1I5jbSBv+xx?=
 =?us-ascii?Q?FVTkLqA2vRxAwvAw8XGFU+pEXgo5gaMZjWBQ9XkdL0La6ey1c9dQlu/WGE5V?=
 =?us-ascii?Q?654UAAs+AJzAdFfAEE/RPiB+fB8LVn5CUeT1F4AUHaO9GwurCx4tJiKCkc5S?=
 =?us-ascii?Q?pjGTDqsU16VEbSDlWSkGEaXaFT6Y2edYwj2A79auS7Lb3oN8M5ZzOS7wwqii?=
 =?us-ascii?Q?/4E1czBeWiUBq26VVmqyR0qPWEvzeAEaxx1CC3ZwDHKPA0h6sGlK1GeOqx8p?=
 =?us-ascii?Q?sdmV5TeqULNFLjj2dklppBA16jN/X+SMWiaylYYSxitRW1VNYUHXx01B4qsk?=
 =?us-ascii?Q?j+CtHZLFTVFFyiCQCi0DdGzbFyyXcTE3KgxZl2VfbZYbkPsqkwh6TDrhR9VC?=
 =?us-ascii?Q?ME4NZDmlhYQa92O+79JpqJvpgkoApfAycL5nXpAKRry1ZUXr8dPMHlWU/b9T?=
 =?us-ascii?Q?vB0rxR/qKYvDttdBWgeHPM6AGLoo08Cf4xRLlt7SdFMYptTIv+q8yyy6oQFQ?=
 =?us-ascii?Q?l1I5/WiRyBCceXb60WwEBHGpTH+sXiJrRN6OVdbBqFFWvNuUWYsfYaRiGzNs?=
 =?us-ascii?Q?71GfYQsOTgheAF9DyPwK1uCQVa656M+P2mcK3bRKpODM0T0+MheAbynhNuYn?=
 =?us-ascii?Q?7fifAoIEHonKO/E1otZkbTG1GDiqNkpVh0K8ckcVs89spjoUHV+PkhP/HR0p?=
 =?us-ascii?Q?L7hZVTkDnoKpdhSVoBcixqbm6Et533w4L8clBNoG+Q73hYD7jIfT84G3WJPx?=
 =?us-ascii?Q?WIrab0yP1GZjup9VSXUUd13VUY1CLngQdYB03ArNo+8oNEfKTqegSjPUX+oy?=
 =?us-ascii?Q?3KM5sSj/zqiNA6Z+vvppnX+4R2XQBv5Bcw7hlRQuCSpqTrHXlVO+UjUWlVCn?=
 =?us-ascii?Q?0bA42ig4M1UAggXhOj4G61hvvWQeVAs4NtXYMCoHbZGf9o8V/kWr9YxbuBEY?=
 =?us-ascii?Q?BcPrmxIT3PK/RHU6MLV0zWipjoD/bC3VQOlb54yPmQD0JPnqqlRPOO8nxonD?=
 =?us-ascii?Q?15ylPCTqxiPER3/rp1nAwNKa+80Vk0rpfYYYad6v9QsYjqdlqBGYJejVEux3?=
 =?us-ascii?Q?yYcI3MF/lzcnjDcujTggicjp9DODZIZsYkjL+GFEOnhjdfAUvd3TTEqbbdov?=
 =?us-ascii?Q?2VQDFfY+0OB8E0argjuTNmdMZ6sU6wZ2l8Hp218eJw3Lo2KBhPp8YByhAeJQ?=
 =?us-ascii?Q?674SldknTWauGyg=3D?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(1800799024)(82310400026)(376014)(7416014)(36860700013);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Feb 2025 09:06:03.6504
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 31ba67ba-c39f-4aa4-c89e-08dd5644cc15
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SJ1PEPF0000231E.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB8038

The Secure AVIC feature provides SEV-SNP guests hardware acceleration
for performance sensitive APIC accesses while securely managing the
guest-owned APIC state through the use of a private APIC backing page.
This helps prevent hypervisor from generating unexpected interrupts for
a vCPU or otherwise violate architectural assumptions around APIC
behavior.

Add a new x2APIC driver that will serve as the base of the Secure AVIC
support. It is initially the same as the x2APIC phys driver, but will be
modified as features of Secure AVIC are implemented.

If the hypervisor sets the Secure AVIC bit in SEV_STATUS and the bit is
not set in SNP_FEATURES_PRESENT, maintain the current behavior to
enforce the guest termination.

Co-developed-by: Kishon Vijay Abraham I <kvijayab@amd.com>
Signed-off-by: Kishon Vijay Abraham I <kvijayab@amd.com>
Signed-off-by: Neeraj Upadhyay <Neeraj.Upadhyay@amd.com>
---

Changes since v1:

 - Updated the commit log to highlight the behavior for the case when
   guest SNP_FEATURES_PRESENT does not have SECURE AVIC set and
   Hv has set the bit in SEV_STATUS.

 - Select AMD_SECURE_AVIC config if AMD_MEM_ENCRYPT config is enabled.

 - Updated the config AMD_SECURE_AVIC description to highlight
   functional dependency on x2apic enablement.

 arch/x86/Kconfig                    |  14 ++++
 arch/x86/boot/compressed/sev.c      |   1 +
 arch/x86/coco/core.c                |   3 +
 arch/x86/include/asm/msr-index.h    |   4 +-
 arch/x86/kernel/apic/Makefile       |   1 +
 arch/x86/kernel/apic/x2apic_savic.c | 112 ++++++++++++++++++++++++++++
 include/linux/cc_platform.h         |   8 ++
 7 files changed, 142 insertions(+), 1 deletion(-)
 create mode 100644 arch/x86/kernel/apic/x2apic_savic.c

diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index 42c8a69bfb49..7776645e71d1 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -474,6 +474,19 @@ config X86_X2APIC
 
 	  If you don't know what to do here, say N.
 
+config AMD_SECURE_AVIC
+	bool "AMD Secure AVIC"
+	depends on X86_X2APIC
+	help
+	  This enables AMD Secure AVIC support on guests that have this feature.
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
@@ -1557,6 +1570,7 @@ config AMD_MEM_ENCRYPT
 	select X86_MEM_ENCRYPT
 	select UNACCEPTED_MEMORY
 	select CRYPTO_LIB_AESGCM
+	select AMD_SECURE_AVIC
 	help
 	  Say yes to enable support for the encryption of system memory.
 	  This requires an AMD processor that supports Secure Memory
diff --git a/arch/x86/boot/compressed/sev.c b/arch/x86/boot/compressed/sev.c
index bb55934c1cee..798fdd3dbd1e 100644
--- a/arch/x86/boot/compressed/sev.c
+++ b/arch/x86/boot/compressed/sev.c
@@ -394,6 +394,7 @@ void do_boot_stage2_vc(struct pt_regs *regs, unsigned long exit_code)
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
index 72765b2fe0d8..a42d88e9def8 100644
--- a/arch/x86/include/asm/msr-index.h
+++ b/arch/x86/include/asm/msr-index.h
@@ -683,7 +683,9 @@
 #define MSR_AMD64_SNP_VMSA_REG_PROT	BIT_ULL(MSR_AMD64_SNP_VMSA_REG_PROT_BIT)
 #define MSR_AMD64_SNP_SMT_PROT_BIT	17
 #define MSR_AMD64_SNP_SMT_PROT		BIT_ULL(MSR_AMD64_SNP_SMT_PROT_BIT)
-#define MSR_AMD64_SNP_RESV_BIT		18
+#define MSR_AMD64_SNP_SECURE_AVIC_BIT	18
+#define MSR_AMD64_SNP_SECURE_AVIC 	BIT_ULL(MSR_AMD64_SNP_SECURE_AVIC_BIT)
+#define MSR_AMD64_SNP_RESV_BIT		19
 #define MSR_AMD64_SNP_RESERVED_MASK	GENMASK_ULL(63, MSR_AMD64_SNP_RESV_BIT)
 #define MSR_AMD64_RMP_BASE		0xc0010132
 #define MSR_AMD64_RMP_END		0xc0010133
diff --git a/arch/x86/kernel/apic/Makefile b/arch/x86/kernel/apic/Makefile
index 3bf0487cf3b7..12153993c12b 100644
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
index 000000000000..c3a4d387c63f
--- /dev/null
+++ b/arch/x86/kernel/apic/x2apic_savic.c
@@ -0,0 +1,112 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/*
+ * AMD Secure AVIC Support (SEV-SNP Guests)
+ *
+ * Copyright (C) 2024 Advanced Micro Devices, Inc.
+ *
+ * Author: Neeraj Upadhyay <Neeraj.Upadhyay@amd.com>
+ */
+
+#include <linux/cpumask.h>
+#include <linux/cc_platform.h>
+
+#include <asm/apic.h>
+#include <asm/sev.h>
+
+#include "local.h"
+
+static int x2apic_savic_acpi_madt_oem_check(char *oem_id, char *oem_table_id)
+{
+	return x2apic_enabled() && cc_platform_has(CC_ATTR_SNP_SECURE_AVIC);
+}
+
+static void x2apic_savic_send_IPI(int cpu, int vector)
+{
+	u32 dest = per_cpu(x86_cpu_to_apicid, cpu);
+
+	/* x2apic MSRs are special and need a special fence: */
+	weak_wrmsr_fence();
+	__x2apic_send_IPI_dest(dest, vector, APIC_DEST_PHYSICAL);
+}
+
+static void
+__send_IPI_mask(const struct cpumask *mask, int vector, int apic_dest)
+{
+	unsigned long query_cpu;
+	unsigned long this_cpu;
+	unsigned long flags;
+
+	/* x2apic MSRs are special and need a special fence: */
+	weak_wrmsr_fence();
+
+	local_irq_save(flags);
+
+	this_cpu = smp_processor_id();
+	for_each_cpu(query_cpu, mask) {
+		if (apic_dest == APIC_DEST_ALLBUT && this_cpu == query_cpu)
+			continue;
+		__x2apic_send_IPI_dest(per_cpu(x86_cpu_to_apicid, query_cpu),
+				       vector, APIC_DEST_PHYSICAL);
+	}
+	local_irq_restore(flags);
+}
+
+static void x2apic_savic_send_IPI_mask(const struct cpumask *mask, int vector)
+{
+	__send_IPI_mask(mask, vector, APIC_DEST_ALLINC);
+}
+
+static void x2apic_savic_send_IPI_mask_allbutself(const struct cpumask *mask, int vector)
+{
+	__send_IPI_mask(mask, vector, APIC_DEST_ALLBUT);
+}
+
+static int x2apic_savic_probe(void)
+{
+	if (!cc_platform_has(CC_ATTR_SNP_SECURE_AVIC))
+		return 0;
+
+	if (!x2apic_mode) {
+		pr_err("Secure AVIC enabled in non x2APIC mode\n");
+		snp_abort();
+	}
+
+	pr_info("Secure AVIC Enabled\n");
+
+	return 1;
+}
+
+static struct apic apic_x2apic_savic __ro_after_init = {
+
+	.name				= "secure avic x2apic",
+	.probe				= x2apic_savic_probe,
+	.acpi_madt_oem_check		= x2apic_savic_acpi_madt_oem_check,
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
+	.send_IPI			= x2apic_savic_send_IPI,
+	.send_IPI_mask			= x2apic_savic_send_IPI_mask,
+	.send_IPI_mask_allbutself	= x2apic_savic_send_IPI_mask_allbutself,
+	.send_IPI_allbutself		= x2apic_send_IPI_allbutself,
+	.send_IPI_all			= x2apic_send_IPI_all,
+	.send_IPI_self			= x2apic_send_IPI_self,
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


