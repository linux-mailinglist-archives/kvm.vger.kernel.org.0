Return-Path: <kvm+bounces-23362-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 9E5F3948FAB
	for <lists+kvm@lfdr.de>; Tue,  6 Aug 2024 14:56:07 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 1589D1F22F49
	for <lists+kvm@lfdr.de>; Tue,  6 Aug 2024 12:56:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0AC7F1C6898;
	Tue,  6 Aug 2024 12:55:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="OEgjvf3C"
X-Original-To: kvm@vger.kernel.org
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2063.outbound.protection.outlook.com [40.107.236.63])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 76BE11C463B;
	Tue,  6 Aug 2024 12:55:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.236.63
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722948927; cv=fail; b=isbr0IVfP1vlfzhttoeN6fLO0SJeutxLqN4sxKvwGu91keOOWAF8n19cUQpFjBF+535xbbqez5bR6fbFk5O51uO4lRMnQZG5KszNCy4CNrorTJQk0WSwgUu2t1+GzdpJD9lnpleA8bmOXGuJXkU5bgxMxqv5+w+g/0EazR14YM8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722948927; c=relaxed/simple;
	bh=n9+Tw/MqWTo092d4RdBYA7UHQpKB92KqyYVlsdYfb6s=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=FcznbiapZEB8IuBg6yy89fZ7rvi1FU+M7YEgGPDAO4lT9nqyAjHF7zoN4OdyD91iLJkKw0kvpzFNmNYp3eiyLA7fmIF06VMR0X8tuumJ2aDKyCcz2aqsvLG/4bQc2dVWvmzbsnWQFNnYCtpo4FLr0f5iy5giUXJqcKgurvfA/h0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=OEgjvf3C; arc=fail smtp.client-ip=40.107.236.63
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ap+7zOYGmo4NYG4i358yagd1dDf/+6kZ43Sv46AVtShA4/szyl8viuM33cMaGGo2dWx1H4x0EUvZhqcylpkyPqAq/kouLmJJWmwcsHE4CpjKwF0NyNhAcL8ktoNvK+ZpJFzmsQpXEEhPnYNuNzIGjO3vRxwvR+QE1NgQv+pFV4K/pjZ/ULH1Y/rnIuKyVCNf0I6eb6hF0LAWFrWUZgDi3YtAuMDCjSnHLs2rGuhQjfPRRZeIo6gGdG4DoyAOFoho75P9p+/EBGYJTgPb37HX+hbuZqV+Y6EIwF4YSesV2mXz7KNmo/aeJIB7FJHaQP/XOGqhcO9X2W9GABt4BmVufA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=UMwDGtSU640uNTIr1FkCsutRfFatJylBeHVmC4xVC7w=;
 b=hVu+swKMdXc0C7sfNwSf2NFI349m+e+h/t9vJTUGg0hZ5w74EUm+J8zIjqbx0ojH9xx9Jc9Rm9l1fhegw0ihE4wSLwwBrawpAv6dSbVZbRhk5wbHWgBQrrD4qBrLUTI6NSU3TToIpHvfZxtg7xbu6UM1A1mEux4SrI5SCktY6KhRuDSYeHc63fqFzTamxwFBNKPs3Cp1yoi7cAAfvzgliL3gT2FpHfmF3Z3EWn7DPc9xv/zEdApI/uJXxUudGtRu+wnMlnS9hcmXbtu9WCFbE0pCBuYsY1qMHqWyBlxUBcXS9YGv+Y+OOiFjQ6nYGWPUrDDF/mD16Y0IJUdNf/ToeA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=linutronix.de smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=UMwDGtSU640uNTIr1FkCsutRfFatJylBeHVmC4xVC7w=;
 b=OEgjvf3CsJ8kOF0fGVCezaYhqXRKcSHAzeST3fWk9aauwIn4+2bOmYqtqROopc+ixWGTQ3NOEwv/n0WTnIiB8SY3Kw5b4Y/IrRFPb7lSIYjJZSE6EFmq/UTMX+iGBkTUlSELw4+KnDwP2bbVWLRXSRjI6mRzDBpEgcyVDHGwhPs=
Received: from BYAPR08CA0053.namprd08.prod.outlook.com (2603:10b6:a03:117::30)
 by CH2PR12MB4309.namprd12.prod.outlook.com (2603:10b6:610:a4::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7849.13; Tue, 6 Aug
 2024 12:55:20 +0000
Received: from SJ5PEPF000001C9.namprd05.prod.outlook.com
 (2603:10b6:a03:117:cafe::36) by BYAPR08CA0053.outlook.office365.com
 (2603:10b6:a03:117::30) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7828.24 via Frontend
 Transport; Tue, 6 Aug 2024 12:55:19 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 SJ5PEPF000001C9.mail.protection.outlook.com (10.167.242.37) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.7849.8 via Frontend Transport; Tue, 6 Aug 2024 12:55:19 +0000
Received: from BLR-L-RBANGORI.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Tue, 6 Aug
 2024 07:55:11 -0500
From: Ravi Bangoria <ravi.bangoria@amd.com>
To: <tglx@linutronix.de>, <mingo@redhat.com>, <bp@alien8.de>,
	<dave.hansen@linux.intel.com>, <seanjc@google.com>, <pbonzini@redhat.com>,
	<thomas.lendacky@amd.com>, <jmattson@google.com>
CC: <ravi.bangoria@amd.com>, <hpa@zytor.com>, <rmk+kernel@armlinux.org.uk>,
	<peterz@infradead.org>, <james.morse@arm.com>, <lukas.bulwahn@gmail.com>,
	<arjan@linux.intel.com>, <j.granados@samsung.com>, <sibs@chinatelecom.cn>,
	<nik.borisov@suse.com>, <michael.roth@amd.com>, <nikunj.dadhania@amd.com>,
	<babu.moger@amd.com>, <x86@kernel.org>, <kvm@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>, <santosh.shukla@amd.com>,
	<ananth.narayan@amd.com>, <sandipan.das@amd.com>, <manali.shukla@amd.com>
Subject: [PATCH v3 2/4] x86/bus_lock: Add support for AMD
Date: Tue, 6 Aug 2024 12:54:40 +0000
Message-ID: <20240806125442.1603-3-ravi.bangoria@amd.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240806125442.1603-1-ravi.bangoria@amd.com>
References: <20240806125442.1603-1-ravi.bangoria@amd.com>
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
X-MS-TrafficTypeDiagnostic: SJ5PEPF000001C9:EE_|CH2PR12MB4309:EE_
X-MS-Office365-Filtering-Correlation-Id: e83777ee-d134-40f9-a923-08dcb617070e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700013|1800799024|376014|7416014|82310400026;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?Hkv+rq4avJpB4rFj0ieU3mKkN1YK4xF20o9IJKCE9HmBuS4YZQPzugP6TXlb?=
 =?us-ascii?Q?YSuMZdLIG4u35SmKckB7+H7LQD8LG9YHO3h/5SwMGbK7pEAWVLQqzRO6I4gH?=
 =?us-ascii?Q?av0ZQOhGP8XcjNaLDs6sm+S8qLutsAmlfxmm/oM0LXPDZje9Ek/LvTW9rKzK?=
 =?us-ascii?Q?lIhu/GcgPntLYqwew6qEZ/Fjq9fqgKO8ODhMfNSPqqQJwd1wnCugEvny3Tw5?=
 =?us-ascii?Q?N059mrk64iUjQ2Qv7uJoLEBusWQ/VsCGF7jQRh57xUrw+5luILLCvpOVvngI?=
 =?us-ascii?Q?TH6YsOhkxpKDJvMPBxOHE9PKO9fgFOUw7rHKOJWMMJFnx5SeqptCjgAypO+C?=
 =?us-ascii?Q?CU0bDU0V5qdSmwqWNu9hdrizny+JPPnT1fuyihf6j5DewONkodTxMgFdznMz?=
 =?us-ascii?Q?cHhP1GHS/5resg2apsnkRO73uenKGlSjc9xVbdmmD0eA8wJsIWzCTKce/VKT?=
 =?us-ascii?Q?hZo9yyk5qI2/+AEORGBJjJkulqPE4ENk2rDqgPR83gSdqBWc0BfoQfZLD4dm?=
 =?us-ascii?Q?MEn6G7cynWVmBSval0XrRQHwmp6XpgBAyJEyX87o/xh49vraUaaacmzlVPuJ?=
 =?us-ascii?Q?zqNDFmY8GZgbdq1uA6YnBX88iFSWPkQcHZHnWuLxmE+OWwJ2TE1SuUp5l7Bx?=
 =?us-ascii?Q?u+TQdENZaU2WffBJPWFsR7Dgr0ZE9XbPTUGX6YcDTHhDNlUiGxQmT4QDfVQP?=
 =?us-ascii?Q?gM+Y2YrPYON9UVfY0MgpUFCpX3jiNUMZHOVarPnljUOM2BXYLcLoiOvn1K/e?=
 =?us-ascii?Q?At+cfkLcj9Ou+iZETdxEr3GJBDcCv4/VR2g/IbBylCMhzzMZJchvLoeGr812?=
 =?us-ascii?Q?JAwdwy4FUmMDADUeZKj2+nTB2QOSXqLBst+NdESxLObvsr0FhgjqNCPIXZwB?=
 =?us-ascii?Q?rPGHLhR/xOUZZabFJijwVI+40sXzbfjbQdyJOuPjd1Q83qsijyfK/73c3uuL?=
 =?us-ascii?Q?fwNPuNoNbpl9udlNOIh9cLYbH997Bvim21bVGLbaEIxURGH1mYN+rzpvAOjf?=
 =?us-ascii?Q?PqhgxN+V4PCDIY/pDB1iBVuCCD3lD5fK07wIcC6AllHxZCIrbjtwRjAaRY9M?=
 =?us-ascii?Q?3lRktx0rdePS1g2QCQNrlEhNanqyxidQgCWEF7QCae741nC0lHb24HXLjwbQ?=
 =?us-ascii?Q?9q860W1opOWC/s4yWG7wfE4sm3YGZBjmF2ESIbi8ovBZTjmtfYAlfsTaYUpY?=
 =?us-ascii?Q?CWEkpCtVbi+LBpkbYG74lh25pUMIRlpSLKGc3/lz+5Y/FK3c6cuPPX4rSPEI?=
 =?us-ascii?Q?s0HtsBnoka+jasud7YpOlFjoxMrGI2r9JzaiS37saw3oT66HdYf6vBZv5hXn?=
 =?us-ascii?Q?8x16GeaGkydGX4ddAym2L/O+rukJCxWdi8UGK0A7mn2eXqHhIY7A/nNu1eJd?=
 =?us-ascii?Q?Pu8gQeMPPVwoQ+oQ5wslIzqlKqJ7PXBQUBSL8R6h1wlvMJ4t2g=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(36860700013)(1800799024)(376014)(7416014)(82310400026);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Aug 2024 12:55:19.7265
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: e83777ee-d134-40f9-a923-08dcb617070e
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SJ5PEPF000001C9.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR12MB4309

Add Bus Lock Detect (called Bus Lock Trap in AMD docs) support for AMD
platforms. Bus Lock Detect is enumerated with CPUID Fn0000_0007_ECX_x0
bit [24 / BUSLOCKTRAP]. It can be enabled through MSR_IA32_DEBUGCTLMSR.
When enabled, hardware clears DR6[11] and raises a #DB exception on
occurrence of Bus Lock if CPL > 0. More detail about the feature can be
found in AMD APM[1].

[1]: AMD64 Architecture Programmer's Manual Pub. 40332, Rev. 4.07 - June
     2023, Vol 2, 13.1.3.6 Bus Lock Trap
     https://bugzilla.kernel.org/attachment.cgi?id=304653

Signed-off-by: Ravi Bangoria <ravi.bangoria@amd.com>
---
 arch/x86/include/asm/cpu.h     | 8 +++++---
 arch/x86/kernel/cpu/bus_lock.c | 4 ++--
 arch/x86/kernel/cpu/common.c   | 2 ++
 arch/x86/kernel/cpu/intel.c    | 1 -
 include/linux/sched.h          | 2 +-
 5 files changed, 10 insertions(+), 7 deletions(-)

diff --git a/arch/x86/include/asm/cpu.h b/arch/x86/include/asm/cpu.h
index 051d872d2faf..c17fdf899835 100644
--- a/arch/x86/include/asm/cpu.h
+++ b/arch/x86/include/asm/cpu.h
@@ -26,14 +26,13 @@ int mwait_usable(const struct cpuinfo_x86 *);
 unsigned int x86_family(unsigned int sig);
 unsigned int x86_model(unsigned int sig);
 unsigned int x86_stepping(unsigned int sig);
-#ifdef CONFIG_CPU_SUP_INTEL
+#if defined(CONFIG_CPU_SUP_INTEL) || defined(CONFIG_CPU_SUP_AMD)
 extern void __init sld_setup(struct cpuinfo_x86 *c);
 extern bool handle_user_split_lock(struct pt_regs *regs, long error_code);
 extern bool handle_guest_split_lock(unsigned long ip);
 extern void handle_bus_lock(struct pt_regs *regs);
 void split_lock_init(void);
 void bus_lock_init(void);
-u8 get_this_hybrid_cpu_type(void);
 #else
 static inline void __init sld_setup(struct cpuinfo_x86 *c) {}
 static inline bool handle_user_split_lock(struct pt_regs *regs, long error_code)
@@ -49,7 +48,10 @@ static inline bool handle_guest_split_lock(unsigned long ip)
 static inline void handle_bus_lock(struct pt_regs *regs) {}
 static inline void split_lock_init(void) {}
 static inline void bus_lock_init(void) {}
-
+#endif
+#ifdef CONFIG_CPU_SUP_INTEL
+u8 get_this_hybrid_cpu_type(void);
+#else
 static inline u8 get_this_hybrid_cpu_type(void)
 {
 	return 0;
diff --git a/arch/x86/kernel/cpu/bus_lock.c b/arch/x86/kernel/cpu/bus_lock.c
index cffb3f2838dc..74c3ae6f1cd2 100644
--- a/arch/x86/kernel/cpu/bus_lock.c
+++ b/arch/x86/kernel/cpu/bus_lock.c
@@ -11,7 +11,7 @@
 #include <asm/traps.h>
 #include <asm/cpu.h>
 
-#if defined(CONFIG_CPU_SUP_INTEL)
+#if defined(CONFIG_CPU_SUP_INTEL) || defined(CONFIG_CPU_SUP_AMD)
 
 enum split_lock_detect_state {
 	sld_off = 0,
@@ -407,4 +407,4 @@ void __init sld_setup(struct cpuinfo_x86 *c)
 	sld_state_show();
 }
 
-#endif /* defined(CONFIG_CPU_SUP_INTEL) */
+#endif /* defined(CONFIG_CPU_SUP_INTEL) || defined(CONFIG_CPU_SUP_AMD) */
diff --git a/arch/x86/kernel/cpu/common.c b/arch/x86/kernel/cpu/common.c
index d4e539d4e158..a37670e1ab4d 100644
--- a/arch/x86/kernel/cpu/common.c
+++ b/arch/x86/kernel/cpu/common.c
@@ -1832,6 +1832,8 @@ static void identify_cpu(struct cpuinfo_x86 *c)
 	if (this_cpu->c_init)
 		this_cpu->c_init(c);
 
+	bus_lock_init();
+
 	/* Disable the PN if appropriate */
 	squash_the_stupid_serial_number(c);
 
diff --git a/arch/x86/kernel/cpu/intel.c b/arch/x86/kernel/cpu/intel.c
index 8a483f4ad026..799f18545c6e 100644
--- a/arch/x86/kernel/cpu/intel.c
+++ b/arch/x86/kernel/cpu/intel.c
@@ -610,7 +610,6 @@ static void init_intel(struct cpuinfo_x86 *c)
 	init_intel_misc_features(c);
 
 	split_lock_init();
-	bus_lock_init();
 
 	intel_init_thermal(c);
 }
diff --git a/include/linux/sched.h b/include/linux/sched.h
index d4cc144f72a3..6d1ff27e2f55 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -991,7 +991,7 @@ struct task_struct {
 #ifdef CONFIG_ARCH_HAS_CPU_PASID
 	unsigned			pasid_activated:1;
 #endif
-#ifdef	CONFIG_CPU_SUP_INTEL
+#if defined(CONFIG_CPU_SUP_INTEL) || defined(CONFIG_CPU_SUP_AMD)
 	unsigned			reported_split_lock:1;
 #endif
 #ifdef CONFIG_TASK_DELAY_ACCT
-- 
2.34.1


