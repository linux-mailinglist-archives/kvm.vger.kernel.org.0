Return-Path: <kvm+bounces-26799-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 8AD25977E8E
	for <lists+kvm@lfdr.de>; Fri, 13 Sep 2024 13:38:03 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 1ABE31F23B30
	for <lists+kvm@lfdr.de>; Fri, 13 Sep 2024 11:38:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C0C4F1BD4E4;
	Fri, 13 Sep 2024 11:37:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="zRd+xlQi"
X-Original-To: kvm@vger.kernel.org
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2075.outbound.protection.outlook.com [40.107.93.75])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 394091D88B9;
	Fri, 13 Sep 2024 11:37:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.93.75
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726227465; cv=fail; b=NfkcIWkreKU5ZdfLNe9NGiS1bX9cBSFVHFTkpuhZB232YlXGw4YEHnHOpc+WfOsZIEMD15hKIocoh3wW1/rcnx7T9wbExoOcAh/OYgeO2meGOl+LuFNr8aIopsXUqcKFxWgQlzi4c1ufZHg+QTtFs7Nh30mmCUhVPPhXFucuNRY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726227465; c=relaxed/simple;
	bh=QVRVp+550Vrs47zoH2e9vARHcU9hi+lLUadP4vNR60s=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=G0F2DsORNgn0e8VGWmQuCyqXN6w1myZICH0k5koj4yPC2ptwpPFbjWkS2YkvDvlSLkGZJH93tf/D59CNeT6Yf2TUat1RguUnUMgqWBBKqnh5qo5sYLG4UMQA4CZLdbHn0hG9EePnkNtQfuf2cuKh9SP0+V6IrnhZUdH0Z9ryiaY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=zRd+xlQi; arc=fail smtp.client-ip=40.107.93.75
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=QXofbhfHWglRXO8y0fTQ6J6xgjtO/jNF19gsFQE7LzkyKP7Ot0PnDyNiA+aUbc9OZWXJgkOnsIHjvL9kKY+E9u0keCuzGB//SNT3lzFiZEQObLMGLbb96Vkxk8fxB9m9XnWfrThEOV0pt51ujnBd4lKW9z5pKpBawasgbSDe0imsK7IXLbj6gkbHFXmxqSO9xE+Sd81zdxUhe9lRSVOJ32lNtPjEf3cf4CCGLS021W7QudeRDBHFob4W7BVNc5TNQb+D4WcAUBJHUY9icbK0TbMdcoTP4pXWOoHc09DrRvPbzv1gYmENJYuImrdz3CvIIi3/yzLOmoShEg1g/RQXKA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=aQ9caO4fzy3IrliaUJl+EpEQYxzb1FXu062SfsRKLuw=;
 b=ws3X94dRK6wfHD/CUciKjKmH6aLYjbTuIB4K6qtsUx305VtFhSYjpcpHozBlEATWsYiGhK4BOxvkGurJdEtEB5cW/B45VkcknNhuGxhRpdHlH/EmTiD1hyZchsDsodJ7w61mkqpwCK3wuZV6Ymrdey0fFg8rTBDYHvgbmcQZ+jzPUNC7CAApFgrHmw1MEF+y2y4x764XxNpk2Ipx8R0rICG35TMJLze8aYLVFvJT6jlw7Kc0JYUGUBgNL+QJCEC+MFBKiK6YVABzsRzPSSFZZNSxemTIlOcSYR1YGm7FJwyf9at40zp0QNeT7qVk5qgHlzAk2FKdQ4dZMfJAjxsC4g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=aQ9caO4fzy3IrliaUJl+EpEQYxzb1FXu062SfsRKLuw=;
 b=zRd+xlQixJirzpl8cuFWze6SOqVwONvg7lkLwxhvEonggvq5YWT7gjO+OunCNLw80RBYmQu5GzC6rl/FS8mvkRWCq1ouVnIxPWUGpRtIQBj0gNUsbNqN7p8NRMZ2O6bRZd3DzHx09Tav0Bv8xfL+xpB7BtATZRt0ewpG34/T3Yc=
Received: from DS7PR03CA0126.namprd03.prod.outlook.com (2603:10b6:5:3b4::11)
 by IA1PR12MB8264.namprd12.prod.outlook.com (2603:10b6:208:3f5::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7939.25; Fri, 13 Sep
 2024 11:37:36 +0000
Received: from DS3PEPF000099DE.namprd04.prod.outlook.com
 (2603:10b6:5:3b4:cafe::bb) by DS7PR03CA0126.outlook.office365.com
 (2603:10b6:5:3b4::11) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7939.24 via Frontend
 Transport; Fri, 13 Sep 2024 11:37:36 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 DS3PEPF000099DE.mail.protection.outlook.com (10.167.17.200) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.7918.13 via Frontend Transport; Fri, 13 Sep 2024 11:37:36 +0000
Received: from BLR-L-NUPADHYA.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Fri, 13 Sep
 2024 06:37:30 -0500
From: Neeraj Upadhyay <Neeraj.Upadhyay@amd.com>
To: <linux-kernel@vger.kernel.org>
CC: <tglx@linutronix.de>, <mingo@redhat.com>, <dave.hansen@linux.intel.com>,
	<Thomas.Lendacky@amd.com>, <nikunj@amd.com>, <Santosh.Shukla@amd.com>,
	<Vasant.Hegde@amd.com>, <Suravee.Suthikulpanit@amd.com>, <bp@alien8.de>,
	<David.Kaplan@amd.com>, <x86@kernel.org>, <hpa@zytor.com>,
	<peterz@infradead.org>, <seanjc@google.com>, <pbonzini@redhat.com>,
	<kvm@vger.kernel.org>
Subject: [RFC 01/14] x86/apic: Add new driver for Secure AVIC
Date: Fri, 13 Sep 2024 17:06:52 +0530
Message-ID: <20240913113705.419146-2-Neeraj.Upadhyay@amd.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20240913113705.419146-1-Neeraj.Upadhyay@amd.com>
References: <20240913113705.419146-1-Neeraj.Upadhyay@amd.com>
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
X-MS-TrafficTypeDiagnostic: DS3PEPF000099DE:EE_|IA1PR12MB8264:EE_
X-MS-Office365-Filtering-Correlation-Id: 3e59dd1a-b26e-46f0-8dac-08dcd3e876f9
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|82310400026|7416014|36860700013|376014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?BJXKPM3BT+wtPs1iFRmMVWghS8s7CjvwnkLNuZSW/acHuSer+bUxw7FOa4NK?=
 =?us-ascii?Q?STd60PtQLfeXJJ3zOLCrRYLM6GW6BP8kLFkBgFlgCegWfhOW5uvPYrcLNl4I?=
 =?us-ascii?Q?fjoIawiP8YX/Pt3EXyxeBwFCH8KVjtRT92zZxZkJqVQA8zDByWzpF2M7Xg02?=
 =?us-ascii?Q?ZlKPdQBLji8UkYuVXpCKZpIEMDgNQJ595wf/R2r0gkJqJpqUIO7noBUcU8z9?=
 =?us-ascii?Q?OwrnC2l8ihM3OfEGTmxjFec1xD2c3CkJOQzIio3MeiNk7A/BjofCWAAwPeI2?=
 =?us-ascii?Q?WYemtxQJ6AdGh6NReELirRxt9JS0Ks+tnfwLpv94huq5sDqS2DvQrBHHExiK?=
 =?us-ascii?Q?E8vCZxEwJq9vsS0MuIajxiPPY2JN2/ZeJdgUPNNoaHYkrmuezEBe9nGGOnvl?=
 =?us-ascii?Q?aBgJtxZOkJkz4guAiquK8OU86Ow8XRIftS6dg7yKsMHyoX9Aev76faHxp5FO?=
 =?us-ascii?Q?ZESPJMYIed5Odagv3vDU53gpGRO3JZN+gX07nYh+vzUXcBGWlUXC9+0FTYi5?=
 =?us-ascii?Q?Im+YmLHtLdnShqQk4v20ozpdm3Zwq1Y7ZsUc82X+TNCoj/45EEqNFvbJEb5T?=
 =?us-ascii?Q?S85X4da7RIHDeeXgnrhBB/n5LyiWti6yB/cTPs4qS2A/cHmCunWt6YTTZo7D?=
 =?us-ascii?Q?9YjndxPt96cX9oOduQ8SdiMK7J4qcIL13caUL7I7iTn1J5FW3mectNZTsmnK?=
 =?us-ascii?Q?W4b1dgCHh0dkS7HSb8zXuECpeCJwxvW6i+7qwyQnvv+vzx8En29+VqN0SeE3?=
 =?us-ascii?Q?4/VWMWam7zh04qnYWFttlzV+3I3EJA03cvRkjbceOF2vrKtgmvhK5OmUDvlf?=
 =?us-ascii?Q?TTSdybk84n7snr7TJJsGc4OmfJEvIvNLA7LZvQxZtjxjIFsJqeP3zANi7gw/?=
 =?us-ascii?Q?tXVH2eaz240jKTAzOG/L+2WOr6xnDigXZvrTon3ll6TR3gh0SP6FkS6goP/W?=
 =?us-ascii?Q?lmseEviTK0+QlB8x0oXjNQPQEhx+dYVSmFsp8tWEef1kWJZtdamEIIxmwvSN?=
 =?us-ascii?Q?saSm+6mx9ChyxjCYpWOLRDGaOSWDSqREiYtyzIVd1aKVdc3Nx4m6GXRuLDq2?=
 =?us-ascii?Q?p7LbK1uQT4PnHphfXoJ+aViIgr9cx87ZYc+kckwrAxanM8Se6I36DxBzaq/f?=
 =?us-ascii?Q?kooCJu5Y//fK70Ue7L1O5s7mncGSNXpSsfvcqlbG49Z//gcciwJ0VAJAIrSm?=
 =?us-ascii?Q?o1zf42mLV4RkztZxu9cM6N0VWQCcm0hCnUb5AWTorS/mHMhBM28jP0JJHo8n?=
 =?us-ascii?Q?wpGCGA/L28ATUhOkMVgJngFLUfUl92Ra/w7abgO5atf5OOnt+1N5O4VIyAyi?=
 =?us-ascii?Q?yQyEXunTqXlZZhIxIyU5o7LL8559w2Yf4BkdUaAe+LQJxcT+b2XaO9wTX2Hw?=
 =?us-ascii?Q?hFNMrfO0AGqi8PKRuqMkE/JOL5yhjaUCEU8Y9GYFzHeBLJS/W/l+0swvbju/?=
 =?us-ascii?Q?kJ2igiBfQhcdFgyXojYAytwIpIE9WPWx?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(1800799024)(82310400026)(7416014)(36860700013)(376014);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Sep 2024 11:37:36.0769
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 3e59dd1a-b26e-46f0-8dac-08dcd3e876f9
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DS3PEPF000099DE.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR12MB8264

From: Kishon Vijay Abraham I <kvijayab@amd.com>

The Secure AVIC feature provides SEV-SNP guests hardware acceleration
for performance sensitive APIC accesses while securely managing the
guest-owned APIC state through the use of a private APIC backing page.
This helps prevent malicious hypervisor from generating unexpected
interrupts for a vCPU or otherwise violate architectural assumptions
around APIC behavior.

Add a new x2APIC driver that will serve as the base of the Secure AVIC
support. It is initially the same as the x2APIC phys driver, but will be
modified as features of Secure AVIC are implemented.

Signed-off-by: Kishon Vijay Abraham I <kvijayab@amd.com>
Co-developed-by: Neeraj Upadhyay <Neeraj.Upadhyay@amd.com>
Signed-off-by: Neeraj Upadhyay <Neeraj.Upadhyay@amd.com>
---
 arch/x86/Kconfig                    |  12 +++
 arch/x86/boot/compressed/sev.c      |   1 +
 arch/x86/coco/core.c                |   3 +
 arch/x86/include/asm/msr-index.h    |   4 +-
 arch/x86/kernel/apic/Makefile       |   1 +
 arch/x86/kernel/apic/x2apic_savic.c | 112 ++++++++++++++++++++++++++++
 include/linux/cc_platform.h         |   8 ++
 7 files changed, 140 insertions(+), 1 deletion(-)
 create mode 100644 arch/x86/kernel/apic/x2apic_savic.c

diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index 007bab9f2a0e..b05b4e9d2e49 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -469,6 +469,18 @@ config X86_X2APIC
 
 	  If you don't know what to do here, say N.
 
+config AMD_SECURE_AVIC
+	bool "AMD Secure AVIC"
+	depends on X86_X2APIC && AMD_MEM_ENCRYPT
+	help
+	  This enables AMD Secure AVIC support on guests that have this feature.
+
+	  AMD Secure AVIC provides hardware acceleration for performance sensitive
+	  APIC accesses and support for managing guest owned APIC state for SEV-SNP
+	  guests.
+
+	  If you don't know what to do here, say N.
+
 config X86_POSTED_MSI
 	bool "Enable MSI and MSI-x delivery by posted interrupts"
 	depends on X86_64 && IRQ_REMAP
diff --git a/arch/x86/boot/compressed/sev.c b/arch/x86/boot/compressed/sev.c
index cd44e120fe53..ec038be0a048 100644
--- a/arch/x86/boot/compressed/sev.c
+++ b/arch/x86/boot/compressed/sev.c
@@ -394,6 +394,7 @@ void do_boot_stage2_vc(struct pt_regs *regs, unsigned long exit_code)
 				 MSR_AMD64_SNP_VMSA_REG_PROT |		\
 				 MSR_AMD64_SNP_RESERVED_BIT13 |		\
 				 MSR_AMD64_SNP_RESERVED_BIT15 |		\
+				 MSR_AMD64_SNP_SECURE_AVIC_ENABLED |	\
 				 MSR_AMD64_SNP_RESERVED_MASK)
 
 /*
diff --git a/arch/x86/coco/core.c b/arch/x86/coco/core.c
index 0f81f70aca82..4c3bc031e9a9 100644
--- a/arch/x86/coco/core.c
+++ b/arch/x86/coco/core.c
@@ -100,6 +100,9 @@ static bool noinstr amd_cc_platform_has(enum cc_attr attr)
 	case CC_ATTR_HOST_SEV_SNP:
 		return cc_flags.host_sev_snp;
 
+	case CC_ATTR_SNP_SECURE_AVIC:
+		return sev_status & MSR_AMD64_SNP_SECURE_AVIC_ENABLED;
+
 	default:
 		return false;
 	}
diff --git a/arch/x86/include/asm/msr-index.h b/arch/x86/include/asm/msr-index.h
index 82c6a4d350e0..d0583619c978 100644
--- a/arch/x86/include/asm/msr-index.h
+++ b/arch/x86/include/asm/msr-index.h
@@ -658,7 +658,9 @@
 #define MSR_AMD64_SNP_VMSA_REG_PROT	BIT_ULL(MSR_AMD64_SNP_VMSA_REG_PROT_BIT)
 #define MSR_AMD64_SNP_SMT_PROT_BIT	17
 #define MSR_AMD64_SNP_SMT_PROT		BIT_ULL(MSR_AMD64_SNP_SMT_PROT_BIT)
-#define MSR_AMD64_SNP_RESV_BIT		18
+#define MSR_AMD64_SNP_SECURE_AVIC_BIT	18
+#define MSR_AMD64_SNP_SECURE_AVIC_ENABLED BIT_ULL(MSR_AMD64_SNP_SECURE_AVIC_BIT)
+#define MSR_AMD64_SNP_RESV_BIT		19
 #define MSR_AMD64_SNP_RESERVED_MASK	GENMASK_ULL(63, MSR_AMD64_SNP_RESV_BIT)
 
 #define MSR_AMD64_VIRT_SPEC_CTRL	0xc001011f
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
index 000000000000..97dac09a7f42
--- /dev/null
+++ b/arch/x86/kernel/apic/x2apic_savic.c
@@ -0,0 +1,112 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/*
+ * AMD Secure AVIC Support (SEV-SNP Guests)
+ *
+ * Copyright (C) 2024 Advanced Micro Devices, Inc.
+ *
+ * Author: Kishon Vijay Abraham I <kvijayab@amd.com>
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
index caa4b4430634..801208678450 100644
--- a/include/linux/cc_platform.h
+++ b/include/linux/cc_platform.h
@@ -88,6 +88,14 @@ enum cc_attr {
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


