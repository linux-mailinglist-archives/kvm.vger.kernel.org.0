Return-Path: <kvm+bounces-42301-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id D16A7A779AA
	for <lists+kvm@lfdr.de>; Tue,  1 Apr 2025 13:37:06 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 061C8188FE8B
	for <lists+kvm@lfdr.de>; Tue,  1 Apr 2025 11:37:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 004FD1FAC4D;
	Tue,  1 Apr 2025 11:36:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="Tgyu+/da"
X-Original-To: kvm@vger.kernel.org
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2065.outbound.protection.outlook.com [40.107.243.65])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3A9DD1F03C1;
	Tue,  1 Apr 2025 11:36:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.243.65
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743507415; cv=fail; b=BSJdAfWq6tj89lIzTZUTVCyXtifnFegMMInWKQ5GrdLF8sM32PXoZFbuf9oLRNkaTyPXkZh8U2g2WIPoQ34keqUwoz1elJ+sEUeUhsVgyt5xaJxqR8eqK3mPvPVgQ2aEKXFjg28gPJXJUaHu9Ty/Q32F64dO0aB5sFRCVWpV9K8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743507415; c=relaxed/simple;
	bh=gn/KRJBi0dQtReCqlw76RAw6dKub2WBlEX+Sb9KxbVk=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=WhyiBiWbMQH4I8b+wCQH6BaSPQqzacHFPwUbFcbpdCUcPtWx1NRKNf6pVP385SGUBPEyoHMXF6OFoL2rATS+r3yDYHrvTfkUWwAlNEkamcLb9o39d/x6cdRdz1Sf3tiV9vy9zpV68sHvaqemw7Pz/k67KvhhDnKJjnKHyyqiX3s=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=Tgyu+/da; arc=fail smtp.client-ip=40.107.243.65
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=G0fbd1zGWA/12S5yN30204fCgX/s10A5k8xX3EGWHlRX8TfeKubXEYdgAlkNHEJNWbYlSd62lC5WG4sOD/ZkH9ggn9DoA0f4ySBEzvtdnoK/eXw2h1PSUYPgJSy3NPO9iXrGGIDCrmozEyK0H0Ux4KDYrLb1ssD4lxudFgWlXfmyssXbS/f48DtfM/fHlssI/RzQ556Sb3kuSHnhLgItsk8tktXCgcJPDwyu4DKpXIaWSboqWa8CYIvMIFHv6PPPR8tJ5cpjFr+Hwu2Tc+mfMApO6TFLhVKSTvBdGl40H9OIi3rsuNxPykSnNNP5YdHIHHLVv600F9znjDUQeflLUA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=yliu0McHsU7z6pSWaXqb/jXJz/r2hKiFQOpxxkwTJ0M=;
 b=aHrVszWIZ8PTwXs98lS13oXLlO8cVwJWWiFYnfVppoW/okDqlYI0p+2k8FX3AjVPw4Agai8QSBAMwVH0YQJX8Cu7zm32sXPSGFKOcuRXipfK33KhK2pmCP5qmbjQVPGtQ5Ix2yCjLmPMvdLqXnwEzP9BwFIanRdHtwLdxsQxKYs6tKjWzZoGOP5BiqZmonI9SLHFAEwXX1KzNHGFw3pyQg/z9ybTJs+eXFnBPS5v87aJpyF3U+vbSRt/EBSEpgOo/tFg5FqnO4Ym164oDAhY5j3klQl1T9lsrXSBqJ6WORJDVs0MdWtb84QLqZw6oobaNCMRKYnulUIFvC/pN624/Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=yliu0McHsU7z6pSWaXqb/jXJz/r2hKiFQOpxxkwTJ0M=;
 b=Tgyu+/dae18oIW67YAZOOvlZJeF2N9RwBjfGiAloum4o+z45M9B2KDBfts24roRWf2IlqbjIIygntODPVfzMvADqqPeVfN0zzswp72Kb4CLpi4cZLHYbfntoU6USRu1s6yjTHlfY875OAoiZdZmq0L6TpFj8rdFZ/p/Mo2/zVYE=
Received: from MW4PR02CA0018.namprd02.prod.outlook.com (2603:10b6:303:16d::17)
 by LV8PR12MB9154.namprd12.prod.outlook.com (2603:10b6:408:190::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8534.44; Tue, 1 Apr
 2025 11:36:49 +0000
Received: from MWH0EPF000989EB.namprd02.prod.outlook.com
 (2603:10b6:303:16d:cafe::30) by MW4PR02CA0018.outlook.office365.com
 (2603:10b6:303:16d::17) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8534.54 via Frontend Transport; Tue,
 1 Apr 2025 11:36:48 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 MWH0EPF000989EB.mail.protection.outlook.com (10.167.241.138) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.8606.22 via Frontend Transport; Tue, 1 Apr 2025 11:36:48 +0000
Received: from BLR-L-NUPADHYA.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Tue, 1 Apr
 2025 06:36:42 -0500
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
Subject: [PATCH v3 01/17] x86/apic: Add new driver for Secure AVIC
Date: Tue, 1 Apr 2025 17:06:00 +0530
Message-ID: <20250401113616.204203-2-Neeraj.Upadhyay@amd.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20250401113616.204203-1-Neeraj.Upadhyay@amd.com>
References: <20250401113616.204203-1-Neeraj.Upadhyay@amd.com>
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
X-MS-TrafficTypeDiagnostic: MWH0EPF000989EB:EE_|LV8PR12MB9154:EE_
X-MS-Office365-Filtering-Correlation-Id: b3df1e53-07ca-48be-4e72-08dd71117d2e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|36860700013|82310400026|376014|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?nLNKkrfkt3QY4CfeJp7v5okqnHYtnjye4uh8iSi/N1RDkcOVVt9zgqiOULYZ?=
 =?us-ascii?Q?yNhSJ6sfRMjwWBy3VXWLIv8sgfxvGsr9EOKD+WAx3e/3CzTLI8yh3hvp7KNA?=
 =?us-ascii?Q?sHonuGuIubiLn/VhlUU9sdheAi1Ldrt5yao4u6iiP/VmovZUh1rqf4v4upfU?=
 =?us-ascii?Q?dj9OpD30AX7hf7xPeI7IBxwP8EWnUXmpNq1nDIKMc1Vp05HwbVnG34+PNzMW?=
 =?us-ascii?Q?JYXk5YKQlPFdzqwP+2Ez962siC2nekPlYeqijFaFZgsgO1xd3LkzBGGmpNZP?=
 =?us-ascii?Q?DNNbHglIzi1HTHgAS4c94h6fY8/951zocjYOikuL+tSb28WXwPtXd+4z7K5X?=
 =?us-ascii?Q?Ih4mrJZHw+qd7QTE2IQuZYP9SRSM+PX4IoXVhXsbn8nBiybkKg91cne4r/HR?=
 =?us-ascii?Q?vsweNH6OE+92+W4Q+30ZYeV1a3kwMDBJ7Pdtc6zAV6w/HWDcBYEdTPx74/rp?=
 =?us-ascii?Q?IcZdeKQOXSbcLvy1tHflwXWENr6eCmzH4EqMWkp+sG8TdMMCL33zeHobytmO?=
 =?us-ascii?Q?fjsIspYfIwfsQoWczcJ3H+mJpNw9GkTL5CUygtg/OrofN27CGbKwi4pdvzPt?=
 =?us-ascii?Q?IzvwyS4XK3nUmmRDNbpyzIkhoGzyXliTZOruwUh5+DZWizXXWYcxdoF7pjC+?=
 =?us-ascii?Q?wUZVuIZB1cg91h8ChceBSIyjjoRD3/EADhNRLi1HVga8ZPJdd7UdGXgSKnlz?=
 =?us-ascii?Q?50z9sWqwHIEvH7kblRlodMpZXCY5j8ML0Pox8xPB/AVhzXK0OxwclwgW+RXN?=
 =?us-ascii?Q?g2TZNgSVgJi/2Ng2HXNMS0rdH+OxxsBfFefqWfQRdioVnd56/gHqdMvgGjKp?=
 =?us-ascii?Q?JzUbt3HNdhoQIm9NfRtR+NT6EZgnozV8cSKb1jbd1ZbGzzV2wNm0YRJky/cX?=
 =?us-ascii?Q?kRnI1C1ddusqFcaTFpecBluV87CetahlCyBxfwPPdtAnEYT21yM0uWwcFzD1?=
 =?us-ascii?Q?upRdfdQSivNnEJHMZXHKOVDrcLI3EdYmZyE8VJf3/5Ksf2/x4cVcbuxat4I4?=
 =?us-ascii?Q?cVzB6lHl5EJDEJS/Ru0kGzMDIi41bA7fkX1GeD49NMLuTq2YQKraZPXoZ0ih?=
 =?us-ascii?Q?Ip1BbjihuftycETBqIADv2z57J2+x7zNT9q7ZIiXOSPc4ETJ8OeFb3zIEkzP?=
 =?us-ascii?Q?ERwj4Q8yPlQaT8hFsxOoc6XF6lRvWkbionANKLi/tFVN/sgM4dO3BSzBcJ1c?=
 =?us-ascii?Q?RyYZV+g2cXmq2F6ThNuWlx+465vWcM7arKNU+wDWQ80s/KdEt/lpC1l3AiRX?=
 =?us-ascii?Q?XVN03Lzzp6/iEU2wyE04Dek3IcKWJtVvI2AAVzrFerCTDhVahh22a5UTnaqk?=
 =?us-ascii?Q?gri51asXtB5h7MLsoeXhITtAFqJMHTR9P9tpDMEQEhljLLv/GtqwEQ0RXqnI?=
 =?us-ascii?Q?55xZGfAtZAhlAMCE9oVN7v1asOYFjVxSf9nzbii1HrbBszDp7onWeDkb+IkS?=
 =?us-ascii?Q?H8V5FiNRPprZ3AlMobQv5TTQdy3gpiAv802PgxTELGAEHUfz3E/8vQ=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(7416014)(36860700013)(82310400026)(376014)(1800799024);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Apr 2025 11:36:48.3641
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: b3df1e53-07ca-48be-4e72-08dd71117d2e
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	MWH0EPF000989EB.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV8PR12MB9154

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
Changes since v2:

 - Do not autoselect AMD_SECURE_AVIC config when AMD_MEM_ENCRYPT config
   is enabled. Make AMD_SECURE_AVIC depend on AMD_MEM_ENCRYPT.
 - Misc cleanups.

 arch/x86/Kconfig                    |  13 ++++
 arch/x86/boot/compressed/sev.c      |   1 +
 arch/x86/coco/core.c                |   3 +
 arch/x86/include/asm/msr-index.h    |   4 +-
 arch/x86/kernel/apic/Makefile       |   1 +
 arch/x86/kernel/apic/x2apic_savic.c | 109 ++++++++++++++++++++++++++++
 include/linux/cc_platform.h         |   8 ++
 7 files changed, 138 insertions(+), 1 deletion(-)
 create mode 100644 arch/x86/kernel/apic/x2apic_savic.c

diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index 6db2e925eb35..3695a6cd0d4e 100644
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
index e6134ef2263d..0090b6f1d6f9 100644
--- a/arch/x86/include/asm/msr-index.h
+++ b/arch/x86/include/asm/msr-index.h
@@ -685,7 +685,9 @@
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
index 000000000000..28cb32e3d803
--- /dev/null
+++ b/arch/x86/kernel/apic/x2apic_savic.c
@@ -0,0 +1,109 @@
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
+static void x2apic_savic_send_ipi(int cpu, int vector)
+{
+	u32 dest = per_cpu(x86_cpu_to_apicid, cpu);
+
+	/* x2apic MSRs are special and need a special fence: */
+	weak_wrmsr_fence();
+	__x2apic_send_IPI_dest(dest, vector, APIC_DEST_PHYSICAL);
+}
+
+static void __send_ipi_mask(const struct cpumask *mask, int vector, bool excl_self)
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
+		if (excl_self && this_cpu == query_cpu)
+			continue;
+		__x2apic_send_IPI_dest(per_cpu(x86_cpu_to_apicid, query_cpu),
+				       vector, APIC_DEST_PHYSICAL);
+	}
+	local_irq_restore(flags);
+}
+
+static void x2apic_savic_send_ipi_mask(const struct cpumask *mask, int vector)
+{
+	__send_ipi_mask(mask, vector, false);
+}
+
+static void x2apic_savic_send_ipi_mask_allbutself(const struct cpumask *mask, int vector)
+{
+	__send_ipi_mask(mask, vector, true);
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
+	.send_IPI			= x2apic_savic_send_ipi,
+	.send_IPI_mask			= x2apic_savic_send_ipi_mask,
+	.send_IPI_mask_allbutself	= x2apic_savic_send_ipi_mask_allbutself,
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


