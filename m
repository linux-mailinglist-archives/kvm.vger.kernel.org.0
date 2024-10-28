Return-Path: <kvm+bounces-29810-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id CF61B9B2475
	for <lists+kvm@lfdr.de>; Mon, 28 Oct 2024 06:40:45 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 5F6F01F2155A
	for <lists+kvm@lfdr.de>; Mon, 28 Oct 2024 05:40:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 35C911D0BA3;
	Mon, 28 Oct 2024 05:35:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="N7SfWOA0"
X-Original-To: kvm@vger.kernel.org
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2057.outbound.protection.outlook.com [40.107.94.57])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 869AB1CF2AE;
	Mon, 28 Oct 2024 05:35:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.94.57
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730093750; cv=fail; b=FwFsHgFnc8N6pe7L/3BTsejbq4/dExXDUhR9hoEjGRmnXLkUsWaPknByC6RGpQsMWC4o8dLfeqQXxx5lKEzFeveTVTRSwx4Cfl7aMVHIdK8aM9cWL/9sx1hoIKz2DuSqr00CsUlzNMt/VP7j+ZrdOr7tjywvfY51Hc5DG8MyFWA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730093750; c=relaxed/simple;
	bh=KcuVe6tvnsfd+IKKQi4vkI1D0HN4ZCzvsoAIWepPZoI=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=id9ofhoXxBjy/x8oFJSvxJf2r4UUhICLGLmFNqQyj0BuIKCJn8zdAMV+pQFsa/YmHacOU1KCMiuJnoD5fTSSiwmJPB2RPL7607akg6X2CwOrqod1EBWzvopXG9ETIgfM2nHDFxgX8TxNyZ44LsFZv56zwOr4/IRu2sdRTUOc07Y=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=N7SfWOA0; arc=fail smtp.client-ip=40.107.94.57
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=OVC25jDXFs1xp3s/o4WqOeaw70f+3D3lMtxd07a70WNSre+90IzYSGSugy2ijBRQpLmYnWohNwZ0snsg6bxk/HqOgQG7NcsQHdyJpREq2UNhWZAJlb+FRgEqhFZcgwapcHXuP2RnJg5usVW6kyzX9NUbQ8ZB8r0lVElJR87NWuBnJJJrfgpw1IM8WU/sw19pgK/pV4Ny0ZJf65LC1aD3v53/zrp5++o77RSTRdOgosb5wSK1ZAEyEuVkP6BbuW9PaBJhfd7anlDfNiG6h/jOZqW0Q/yDsoECIQqRF3mBLGcQeNH0r9ZJtselBClnu579jRp2vg6zyMKs4mHM0wJfvg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=U3brF1Z3m8W78VNKIzQdWgsHj8gOmkzBWQuD+SmGK3g=;
 b=LYgsJAI9iG7ncnhJNg44V1uZrwO+OiM1z21RYG4R4/9U+MUMfzdEeu6pbXgziUia9/cZsgBhoXKvuk6fRNj02nyM3Cv7ew/BysomnaZ6P5t6C6xRJUZYH/sWHGUxdbaTBDrie496WlEpSBAR5/4xRzULgWgA5zA581oZ1bMJyUZ0wEdgJ15bo7UCmlOfqICfkIjgaqniWwpL0n4eF++8xgoE5Cd4ZSfGtf0xQyrgEwsZ+u230noOnF9q5C5gvIRr1EwzuJelCputpqgg+mJjVNUqoh8KTqj3hb8RNCIbfHlseozOodJwwvLvbxqIVR1bFemUss1H9KTTsU3qCU01Og==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=U3brF1Z3m8W78VNKIzQdWgsHj8gOmkzBWQuD+SmGK3g=;
 b=N7SfWOA08SXNpTVnvVApGkl820o6X/2E8gQwRdE9XOh2BMb/rHBTx6aDP8MX+/ccJe3MTy8+iKB9Dz7VoF5E2gSUaJb4KOyT7TIvVCP0ma+WNCo6yzVhRZI6fDagOnNAmWmNhicwLn2v6OY+1dj9+V7olfbguVZGMSPu3wipWPA=
Received: from BN1PR14CA0005.namprd14.prod.outlook.com (2603:10b6:408:e3::10)
 by SA1PR12MB8117.namprd12.prod.outlook.com (2603:10b6:806:334::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8093.25; Mon, 28 Oct
 2024 05:35:42 +0000
Received: from BL6PEPF0001AB58.namprd02.prod.outlook.com
 (2603:10b6:408:e3:cafe::39) by BN1PR14CA0005.outlook.office365.com
 (2603:10b6:408:e3::10) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8093.25 via Frontend
 Transport; Mon, 28 Oct 2024 05:35:41 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 BL6PEPF0001AB58.mail.protection.outlook.com (10.167.241.10) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.8114.16 via Frontend Transport; Mon, 28 Oct 2024 05:35:41 +0000
Received: from gomati.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Mon, 28 Oct
 2024 00:35:37 -0500
From: Nikunj A Dadhania <nikunj@amd.com>
To: <linux-kernel@vger.kernel.org>, <thomas.lendacky@amd.com>, <bp@alien8.de>,
	<x86@kernel.org>, <kvm@vger.kernel.org>
CC: <mingo@redhat.com>, <tglx@linutronix.de>, <dave.hansen@linux.intel.com>,
	<pgonda@google.com>, <seanjc@google.com>, <pbonzini@redhat.com>,
	<nikunj@amd.com>
Subject: [PATCH v14 09/13] tsc: Use the GUEST_TSC_FREQ MSR for discovering TSC frequency
Date: Mon, 28 Oct 2024 11:04:27 +0530
Message-ID: <20241028053431.3439593-10-nikunj@amd.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20241028053431.3439593-1-nikunj@amd.com>
References: <20241028053431.3439593-1-nikunj@amd.com>
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
X-MS-TrafficTypeDiagnostic: BL6PEPF0001AB58:EE_|SA1PR12MB8117:EE_
X-MS-Office365-Filtering-Correlation-Id: adb7418b-a61a-4fef-6817-08dcf7125cc5
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|7416014|1800799024|82310400026|36860700013;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?LbjwYDY9OnarOQIESl6sB2nUCmQ2yzop3cpx50O/m0sSapaiedQAJ/9n45lG?=
 =?us-ascii?Q?dGsgAd51OdOKLZ0/c8eXQ9wXdkPfJgonZt5himbm8tofP88E21O9IvAznwUo?=
 =?us-ascii?Q?w2KIBof0zkSS6SRyZsOxJ46BWk/d+v8g0Z4fZaVtLT8ycvFjeNBiwJ0dm71d?=
 =?us-ascii?Q?6070PREp9Z6lZ0g3Kx46JgSuX0S6SxrHqjPLKXC8hx1rjn0CXWl0yb+EWNsm?=
 =?us-ascii?Q?FYyZLDAz0xPp90GnFZpDyXvxmjp1pAnMoFJV2gh1vWXjuXedSmEAGBM7aZ/Y?=
 =?us-ascii?Q?l7zU/WH8nVqe+iHODQMe19hRWLn8c1yzKJMt2kK6hOcSTNU4Rz+kiTa9OSBa?=
 =?us-ascii?Q?0hTtYp2gQOUGUQQNjWbtK/nVj4eUTUdKv9aRrgCKED+Rz4rqA1e9YWKrrXIA?=
 =?us-ascii?Q?1xBJsS7cfZtEYp5nfv8i01nH74lsxfwovI9leutzcI1xfQT+XHOmdK7FGRED?=
 =?us-ascii?Q?sPXtTCLyNuXTqGRNMzHDOqaIoIJM/4jKqXM+WSOGPbydeSi8SFLt2xadIACH?=
 =?us-ascii?Q?OrasKRDhY5/rGkrGbniTron6mS04eGPpPZfOaa34UtIe0fPil1DhD1Fx87Xa?=
 =?us-ascii?Q?uwFWrBWOvJBX4Ck162z3hvxRXoXxuQFTeZVIGXr3oxVUQg/97r8TZuwYM41V?=
 =?us-ascii?Q?3G+LezTk5YOoy2B54Mc2yY/M0wdFyR0G3bKFPCPgHraHBmg+YEvvKSDBneVx?=
 =?us-ascii?Q?JAtjZLmP0r2Ovh4u8fXgeMfOlFhBg+Gb5TEm/r9dezNC4iCmiAFNpcDryLJH?=
 =?us-ascii?Q?fRx6ocROgYH1DgA3JkrF+RjUTNX/pge6pTLrlNl/Bkc5F9yAvM3Xk9MPZcax?=
 =?us-ascii?Q?DMEtiiadUG8QGEAbmgJYB9axWcHgWyaJpKUi/UhVz2yUYebCujU6bRclNwVQ?=
 =?us-ascii?Q?OZNrA/Ms7ngdq0ba2LFKARXJxFuq+VnnC49XkNKLOkxWElg9uxjLREaJJdtO?=
 =?us-ascii?Q?474b1zZIM8egTicxZjtJTrbOi3gzyGbCM3eUgwat1IkPG0xU5n368arGTTl6?=
 =?us-ascii?Q?oYwbWOjHatR461J4jCTC3DHPIeQYiPZ3y6/rXXFfoSn7+sajQROogj1fef5c?=
 =?us-ascii?Q?+Mmir7xPywFGsh4S88vJDJpVcdIFJdSOwmKbkPHahV/CYYufAq7VUMm2m2yV?=
 =?us-ascii?Q?WNTDpn9NxQUFTB2zjcV9LhsOKh5vjq8/bzH8VjJRu72I+SV8s3vfbEVvAZeR?=
 =?us-ascii?Q?K051gUHeIsrnW40/Pj4zw/4XfA7ZoNbGVfkmpLchSqSz0oFmxP8LUmms0G5J?=
 =?us-ascii?Q?Zji74RSKmqVuXUW7Ougfb9gd8uzMq3WDvUU8PJDGTDxvPk3q86v3sJ8rTZ7u?=
 =?us-ascii?Q?+2KB38jeEMAZFpqXokEHJNvPZBiBGR7Ci4II1B1gBIlgbW+iLdvWBn8mIITD?=
 =?us-ascii?Q?/pxifS+jMDYwf/ij3gisM9X+ftA8BjYXzxUIuO5Qe/ACSI+dYg=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(376014)(7416014)(1800799024)(82310400026)(36860700013);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Oct 2024 05:35:41.7055
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: adb7418b-a61a-4fef-6817-08dcf7125cc5
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BL6PEPF0001AB58.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR12MB8117

Calibrating the TSC frequency using the kvmclock is not correct for
SecureTSC enabled guests. Use the platform provided TSC frequency via the
GUEST_TSC_FREQ MSR (C001_0134h).

Signed-off-by: Nikunj A Dadhania <nikunj@amd.com>
---
 arch/x86/include/asm/sev.h |  2 ++
 arch/x86/coco/sev/core.c   | 16 ++++++++++++++++
 arch/x86/kernel/tsc.c      |  5 +++++
 3 files changed, 23 insertions(+)

diff --git a/arch/x86/include/asm/sev.h b/arch/x86/include/asm/sev.h
index d27c4e0f9f57..9ee63ddd0d90 100644
--- a/arch/x86/include/asm/sev.h
+++ b/arch/x86/include/asm/sev.h
@@ -536,6 +536,7 @@ static inline int handle_guest_request(struct snp_msg_desc *mdesc, u64 exit_code
 }
 
 void __init snp_secure_tsc_prepare(void);
+void __init snp_secure_tsc_init(void);
 
 #else	/* !CONFIG_AMD_MEM_ENCRYPT */
 
@@ -584,6 +585,7 @@ static inline int handle_guest_request(struct snp_msg_desc *mdesc, u64 exit_code
 				       u32 resp_sz) { return -ENODEV; }
 
 static inline void __init snp_secure_tsc_prepare(void) { }
+static inline void __init snp_secure_tsc_init(void) { }
 
 #endif	/* CONFIG_AMD_MEM_ENCRYPT */
 
diff --git a/arch/x86/coco/sev/core.c b/arch/x86/coco/sev/core.c
index 140759fafe0c..0be9496b8dea 100644
--- a/arch/x86/coco/sev/core.c
+++ b/arch/x86/coco/sev/core.c
@@ -3064,3 +3064,19 @@ void __init snp_secure_tsc_prepare(void)
 
 	pr_debug("SecureTSC enabled");
 }
+
+static unsigned long securetsc_get_tsc_khz(void)
+{
+	unsigned long long tsc_freq_mhz;
+
+	setup_force_cpu_cap(X86_FEATURE_TSC_KNOWN_FREQ);
+	rdmsrl(MSR_AMD64_GUEST_TSC_FREQ, tsc_freq_mhz);
+
+	return (unsigned long)(tsc_freq_mhz * 1000);
+}
+
+void __init snp_secure_tsc_init(void)
+{
+	x86_platform.calibrate_cpu = securetsc_get_tsc_khz;
+	x86_platform.calibrate_tsc = securetsc_get_tsc_khz;
+}
diff --git a/arch/x86/kernel/tsc.c b/arch/x86/kernel/tsc.c
index dfe6847fd99e..730cbbd4554e 100644
--- a/arch/x86/kernel/tsc.c
+++ b/arch/x86/kernel/tsc.c
@@ -30,6 +30,7 @@
 #include <asm/i8259.h>
 #include <asm/topology.h>
 #include <asm/uv/uv.h>
+#include <asm/sev.h>
 
 unsigned int __read_mostly cpu_khz;	/* TSC clocks / usec, not used here */
 EXPORT_SYMBOL(cpu_khz);
@@ -1514,6 +1515,10 @@ void __init tsc_early_init(void)
 	/* Don't change UV TSC multi-chassis synchronization */
 	if (is_early_uv_system())
 		return;
+
+	if (cc_platform_has(CC_ATTR_GUEST_SNP_SECURE_TSC))
+		snp_secure_tsc_init();
+
 	if (!determine_cpu_tsc_frequencies(true))
 		return;
 	tsc_enable_sched_clock();
-- 
2.34.1


