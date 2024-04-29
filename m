Return-Path: <kvm+bounces-16136-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 38DD28B50FA
	for <lists+kvm@lfdr.de>; Mon, 29 Apr 2024 08:08:01 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id E4287281C63
	for <lists+kvm@lfdr.de>; Mon, 29 Apr 2024 06:07:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 90B4B14273;
	Mon, 29 Apr 2024 06:07:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="AZ037UzQ"
X-Original-To: kvm@vger.kernel.org
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2048.outbound.protection.outlook.com [40.107.94.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8668413FE7;
	Mon, 29 Apr 2024 06:07:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.94.48
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714370842; cv=fail; b=H5M/cDsRLPBVFwtdYz9XSL/dxAMqLPniDhWwa+ZESqKkQlT9u6DDGsotX+i2wtm1B2nfot1GfOc0i0ZUcbmCKVYjEDsmGbfRpMbHsMOIjFCvchHvjHOla4CIDa2x8zuEvcORgLT2QrnQuomCJ18P6G6cSM925Qvbp0VvSejpqqg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714370842; c=relaxed/simple;
	bh=rgzbCeAEq+vsUY/E7Y2cQ4c87iMIrqALI/G72LtCASg=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Cl5hapgt7mWqx7qoiBktU0567++xPWzfBdAP5JFYLjLpv1OhoXNt5tcTNmnwH9KOoFVfHvd0pHP55S4ybbbTGNgxEOm001j8T6D2ChHtE9oN5KJtvcmVcAP6He7Y0mBdPDF8JboBN1uO2Fa3nwxZ5FQS0H4foy8Z+O4jmHReuFs=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=AZ037UzQ; arc=fail smtp.client-ip=40.107.94.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=UFVatkt+KZHaF/5KG209V+CITV2iGIB10UarxBvim7sqnWcqHPXMLQt8pFFQqQxPDhsv8K6jdua6EolLRP5go5YvU2QNFrTpErjLtZQRB3rtnB6GlwJjz61drWomXy3w5nGqsSs5lGN1utt06jq0ny5f3drvLSFe5lTSWQjoTyp/Rwfxwjvg8YZE5uIhNTldeV1kXg381ojUZT1UoONhlZCYa7ZodrRTfkprjcrLAmKTcDSk/Nis1taJlttisindU0VktQ/ekIu6/R5URsVYpamf/8YPFL4ue2L4MYYCqOkyAxZ2J80ZmIjTGgNZ5oXz+9pzPO664nk8mE49/dKOpg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=UosfrT/MMsgBkujPmt6chExeQ8VyvgyVXq4a2Dpg9A8=;
 b=FWvQ3Mbe0PPKerCUSrxYqzpPjTnyqmlz74p8EiSsf+jR8oY7zBrVjXUpmAHR5ehfmIIOS7COxaesfw2a2zje/IiU8wQJurOwK02Fz/KpmJtGJTbfmKHT0NnutDwSHrsQ/X89MUukJWScUFYw6IkRGV2olRqy2tG0sZeG9anv2wEHJMv7QXfHZ9dtl/B8NJdEzZT8/u2vc0/uaz9w/eNqN38S2wLopaTIaG7l47FLtIE7rvLqMVAPk9qtQrHyqGBxY5Xe+lNmGE0hIbZ0/j6z68Wo9ZbYqCzdrNFLglUWQEiAoDjl8gux97ninm3/8pBA9nK+wA7hsp+oucLTeGyJWA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=linutronix.de smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=UosfrT/MMsgBkujPmt6chExeQ8VyvgyVXq4a2Dpg9A8=;
 b=AZ037UzQnFxPWKkcxq4nzEoYR6PZs3xaV4bfdjZaCj1aDJHgy69ZD3LEDtkxbYh0EIDL4oYSNnjJfo+hvreR4PegDaOqTgrqCIX+FfURWX0RDAbx6ov1EIGU79qcAy2lbJ7VEEN1UXQAZPd5ZYwzd5pEgAjz0/KCRTAGJSZfviE=
Received: from CH2PR15CA0006.namprd15.prod.outlook.com (2603:10b6:610:51::16)
 by SA1PR12MB6823.namprd12.prod.outlook.com (2603:10b6:806:25e::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7519.34; Mon, 29 Apr
 2024 06:07:17 +0000
Received: from CH2PEPF00000143.namprd02.prod.outlook.com
 (2603:10b6:610:51:cafe::2b) by CH2PR15CA0006.outlook.office365.com
 (2603:10b6:610:51::16) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7519.34 via Frontend
 Transport; Mon, 29 Apr 2024 06:07:17 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 CH2PEPF00000143.mail.protection.outlook.com (10.167.244.100) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.7544.18 via Frontend Transport; Mon, 29 Apr 2024 06:07:17 +0000
Received: from BLR-5CG113396H.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.35; Mon, 29 Apr
 2024 01:07:06 -0500
From: Ravi Bangoria <ravi.bangoria@amd.com>
To: <tglx@linutronix.de>, <mingo@redhat.com>, <bp@alien8.de>,
	<dave.hansen@linux.intel.com>, <seanjc@google.com>, <pbonzini@redhat.com>,
	<thomas.lendacky@amd.com>
CC: <ravi.bangoria@amd.com>, <hpa@zytor.com>, <rmk+kernel@armlinux.org.uk>,
	<peterz@infradead.org>, <james.morse@arm.com>, <lukas.bulwahn@gmail.com>,
	<arjan@linux.intel.com>, <j.granados@samsung.com>, <sibs@chinatelecom.cn>,
	<nik.borisov@suse.com>, <michael.roth@amd.com>, <nikunj.dadhania@amd.com>,
	<babu.moger@amd.com>, <x86@kernel.org>, <kvm@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>, <santosh.shukla@amd.com>,
	<ananth.narayan@amd.com>, <sandipan.das@amd.com>
Subject: [PATCH 1/3] x86/split_lock: Move Split and Bus lock code to a dedicated file
Date: Mon, 29 Apr 2024 11:36:41 +0530
Message-ID: <20240429060643.211-2-ravi.bangoria@amd.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20240429060643.211-1-ravi.bangoria@amd.com>
References: <20240429060643.211-1-ravi.bangoria@amd.com>
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
X-MS-TrafficTypeDiagnostic: CH2PEPF00000143:EE_|SA1PR12MB6823:EE_
X-MS-Office365-Filtering-Correlation-Id: 76d8ac76-6367-4190-f49e-08dc68129f62
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230031|376005|7416005|1800799015|82310400014|36860700004;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?0nIq/5aHrtxnuC00ou8JZ+OsXIpxzPiqSQUVqAffhSlmOcb1gSw+EU8jFvMS?=
 =?us-ascii?Q?esNbAZ40Y0s0jMO73uBe5mHwYR6+Hxdxk4BFnXoOVcwuDt4xqvmYLA/NAqr/?=
 =?us-ascii?Q?mNaAGBduFFujrniiQTu3r5ad71Rpa2pcRdEEc6IxDjgi9T1jc0mJAlBosiJl?=
 =?us-ascii?Q?ZSW0R6FJs8UfziX9/a7rF3nh4+mTPV3qRgeMHyM+7GdHduAdl5WRvFoLlNLq?=
 =?us-ascii?Q?A+ybrkHHb9mZgHie8HVLOFUKCmZygqWfhT6wFirTWM4HdtBvvkCv25o7f7NB?=
 =?us-ascii?Q?sWoh115EPXeocndxBUkZQK5GIlxZarOHLGazNxZ/CaK/Yiaf0kszK05B6McC?=
 =?us-ascii?Q?YJ+Pqf4yuaOo6kG7niWChL8KYiPlZ29CxFNA+JSx8XYE0B4RaSAI2/Da9Oyt?=
 =?us-ascii?Q?BKw5TtcZIrXKuqJLS3Md/CKuMm5uIFwdRfy56m1k2MfwlTxRvUeGv8dI6pVn?=
 =?us-ascii?Q?4nbKmLD8YoRubc9wYUmJ045HmssEySCSQOawcYjAc16nj7PRhThZjB1sGd8X?=
 =?us-ascii?Q?EI84sZgNpfVdKWc1medbOaLkyAkjwzR1W3ujm9vTCiJyI98MTXkxBCKmxdut?=
 =?us-ascii?Q?uUsgF3ea7qOIZ58dYjUhqZGxF2KWiyIMKLJCMLXT7+AKOOwjr4/rfOrGebsp?=
 =?us-ascii?Q?SQpjEHvn1ZL99vN5MlhysqaQ+dUIOW5htuPEUpc7rpxATxooHaKqDwUwDe4I?=
 =?us-ascii?Q?7RQhdLZ6Tc+4Nkw3PtnQjmmowsUJs6R25yDToWAP4/hsnwgR34M86RHMMCs1?=
 =?us-ascii?Q?rW1a+jLnYeT/G1Va4PmKLWLmqeGQ3HQ4fk0ZSVlv28p3Nlb4cl90VhhCdPBz?=
 =?us-ascii?Q?qoj5ukE83lMwVc3cwe8Y3YQRYTdW2Cil+l6pmP+uUkVXWTY7lV7yJnKrOyJx?=
 =?us-ascii?Q?Xe8mEw6mKFcb9am+vKLsoQbYJSqVCtqhjsy2nkllXPZLLRnTa0nfIYiYoBOm?=
 =?us-ascii?Q?cdK7d3NH/YncOZ4pamiMZx6gJE57RdF6LwWTUJKLWKuLJ8ZVQKCw+o5YL4gB?=
 =?us-ascii?Q?TEO98Ec0IFbfJBePTLKNnnHHwIRD/TZmDwGB5GtLTY4XoZPHAPpIrF+yQzAC?=
 =?us-ascii?Q?NZpQ2PTmcOi8MU+FX44kvkikPh03iyY2AeJ65Kt5iJja97tCFHvzoxowt58d?=
 =?us-ascii?Q?ozvaAnXKMvIMoVOzRtsG6iL+Hxp7lOOvr8CUAQmmMvhiWwTLwu5xCrhXEMgj?=
 =?us-ascii?Q?rTBMlnfWm91kWrbBLeLe2SLjCQuI3qO7EWjQdugssQ6m/5F8mDzAGOzZp1b5?=
 =?us-ascii?Q?p1etAH0q3VGctqcjvxW1IxjLabM6i6Xewcxq4LK5B/T6ZaK36PqGN8A0XOav?=
 =?us-ascii?Q?9kONR2WzI0crXl8MS2PXD0ZHbITaFVJfhNpQLtp5EpFJxJ/66XUfgR9S7Pkj?=
 =?us-ascii?Q?TC75oj7aTMUzeOC/X73t3VTFoOgH?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230031)(376005)(7416005)(1800799015)(82310400014)(36860700004);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Apr 2024 06:07:17.1749
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 76d8ac76-6367-4190-f49e-08dc68129f62
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CH2PEPF00000143.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR12MB6823

Upcoming AMD uarch will support Bus Lock Detect, which functionally works
identical to Intel. Move split_lock and bus_lock specific code from
intel.c to a dedicated file so that it can be compiled and supported on
non-intel platforms.

Signed-off-by: Ravi Bangoria <ravi.bangoria@amd.com>
---
 arch/x86/include/asm/cpu.h           |   4 +
 arch/x86/kernel/cpu/Makefile         |   1 +
 arch/x86/kernel/cpu/intel.c          | 407 ---------------------------
 arch/x86/kernel/cpu/split-bus-lock.c | 406 ++++++++++++++++++++++++++
 4 files changed, 411 insertions(+), 407 deletions(-)
 create mode 100644 arch/x86/kernel/cpu/split-bus-lock.c

diff --git a/arch/x86/include/asm/cpu.h b/arch/x86/include/asm/cpu.h
index aa30fd8cad7f..4b5c31dc8112 100644
--- a/arch/x86/include/asm/cpu.h
+++ b/arch/x86/include/asm/cpu.h
@@ -51,6 +51,10 @@ static inline u8 get_this_hybrid_cpu_type(void)
 	return 0;
 }
 #endif
+
+void split_lock_init(void);
+void bus_lock_init(void);
+
 #ifdef CONFIG_IA32_FEAT_CTL
 void init_ia32_feat_ctl(struct cpuinfo_x86 *c);
 #else
diff --git a/arch/x86/kernel/cpu/Makefile b/arch/x86/kernel/cpu/Makefile
index eb4dbcdf41f1..86a10472ad1d 100644
--- a/arch/x86/kernel/cpu/Makefile
+++ b/arch/x86/kernel/cpu/Makefile
@@ -27,6 +27,7 @@ obj-y			+= aperfmperf.o
 obj-y			+= cpuid-deps.o
 obj-y			+= umwait.o
 obj-y 			+= capflags.o powerflags.o
+obj-y 			+= split-bus-lock.o
 
 obj-$(CONFIG_X86_LOCAL_APIC)		+= topology.o
 
diff --git a/arch/x86/kernel/cpu/intel.c b/arch/x86/kernel/cpu/intel.c
index 3c3e7e5695ba..730d7a065b8a 100644
--- a/arch/x86/kernel/cpu/intel.c
+++ b/arch/x86/kernel/cpu/intel.c
@@ -7,13 +7,9 @@
 #include <linux/smp.h>
 #include <linux/sched.h>
 #include <linux/sched/clock.h>
-#include <linux/semaphore.h>
 #include <linux/thread_info.h>
 #include <linux/init.h>
 #include <linux/uaccess.h>
-#include <linux/workqueue.h>
-#include <linux/delay.h>
-#include <linux/cpuhotplug.h>
 
 #include <asm/cpufeature.h>
 #include <asm/msr.h>
@@ -23,9 +19,6 @@
 #include <asm/microcode.h>
 #include <asm/hwcap2.h>
 #include <asm/elf.h>
-#include <asm/cpu_device_id.h>
-#include <asm/cmdline.h>
-#include <asm/traps.h>
 #include <asm/resctrl.h>
 #include <asm/numa.h>
 #include <asm/thermal.h>
@@ -41,28 +34,6 @@
 #include <asm/apic.h>
 #endif
 
-enum split_lock_detect_state {
-	sld_off = 0,
-	sld_warn,
-	sld_fatal,
-	sld_ratelimit,
-};
-
-/*
- * Default to sld_off because most systems do not support split lock detection.
- * sld_state_setup() will switch this to sld_warn on systems that support
- * split lock/bus lock detect, unless there is a command line override.
- */
-static enum split_lock_detect_state sld_state __ro_after_init = sld_off;
-static u64 msr_test_ctrl_cache __ro_after_init;
-
-/*
- * With a name like MSR_TEST_CTL it should go without saying, but don't touch
- * MSR_TEST_CTL unless the CPU is one of the whitelisted models.  Writing it
- * on CPUs that do not support SLD can cause fireworks, even when writing '0'.
- */
-static bool cpu_model_supports_sld __ro_after_init;
-
 /*
  * Processors which have self-snooping capability can handle conflicting
  * memory type across CPUs by snooping its own cache. However, there exists
@@ -595,9 +566,6 @@ static void init_intel_misc_features(struct cpuinfo_x86 *c)
 	wrmsrl(MSR_MISC_FEATURES_ENABLES, msr);
 }
 
-static void split_lock_init(void);
-static void bus_lock_init(void);
-
 static void init_intel(struct cpuinfo_x86 *c)
 {
 	early_init_intel(c);
@@ -954,381 +922,6 @@ static const struct cpu_dev intel_cpu_dev = {
 
 cpu_dev_register(intel_cpu_dev);
 
-#undef pr_fmt
-#define pr_fmt(fmt) "x86/split lock detection: " fmt
-
-static const struct {
-	const char			*option;
-	enum split_lock_detect_state	state;
-} sld_options[] __initconst = {
-	{ "off",	sld_off   },
-	{ "warn",	sld_warn  },
-	{ "fatal",	sld_fatal },
-	{ "ratelimit:", sld_ratelimit },
-};
-
-static struct ratelimit_state bld_ratelimit;
-
-static unsigned int sysctl_sld_mitigate = 1;
-static DEFINE_SEMAPHORE(buslock_sem, 1);
-
-#ifdef CONFIG_PROC_SYSCTL
-static struct ctl_table sld_sysctls[] = {
-	{
-		.procname       = "split_lock_mitigate",
-		.data           = &sysctl_sld_mitigate,
-		.maxlen         = sizeof(unsigned int),
-		.mode           = 0644,
-		.proc_handler	= proc_douintvec_minmax,
-		.extra1         = SYSCTL_ZERO,
-		.extra2         = SYSCTL_ONE,
-	},
-};
-
-static int __init sld_mitigate_sysctl_init(void)
-{
-	register_sysctl_init("kernel", sld_sysctls);
-	return 0;
-}
-
-late_initcall(sld_mitigate_sysctl_init);
-#endif
-
-static inline bool match_option(const char *arg, int arglen, const char *opt)
-{
-	int len = strlen(opt), ratelimit;
-
-	if (strncmp(arg, opt, len))
-		return false;
-
-	/*
-	 * Min ratelimit is 1 bus lock/sec.
-	 * Max ratelimit is 1000 bus locks/sec.
-	 */
-	if (sscanf(arg, "ratelimit:%d", &ratelimit) == 1 &&
-	    ratelimit > 0 && ratelimit <= 1000) {
-		ratelimit_state_init(&bld_ratelimit, HZ, ratelimit);
-		ratelimit_set_flags(&bld_ratelimit, RATELIMIT_MSG_ON_RELEASE);
-		return true;
-	}
-
-	return len == arglen;
-}
-
-static bool split_lock_verify_msr(bool on)
-{
-	u64 ctrl, tmp;
-
-	if (rdmsrl_safe(MSR_TEST_CTRL, &ctrl))
-		return false;
-	if (on)
-		ctrl |= MSR_TEST_CTRL_SPLIT_LOCK_DETECT;
-	else
-		ctrl &= ~MSR_TEST_CTRL_SPLIT_LOCK_DETECT;
-	if (wrmsrl_safe(MSR_TEST_CTRL, ctrl))
-		return false;
-	rdmsrl(MSR_TEST_CTRL, tmp);
-	return ctrl == tmp;
-}
-
-static void __init sld_state_setup(void)
-{
-	enum split_lock_detect_state state = sld_warn;
-	char arg[20];
-	int i, ret;
-
-	if (!boot_cpu_has(X86_FEATURE_SPLIT_LOCK_DETECT) &&
-	    !boot_cpu_has(X86_FEATURE_BUS_LOCK_DETECT))
-		return;
-
-	ret = cmdline_find_option(boot_command_line, "split_lock_detect",
-				  arg, sizeof(arg));
-	if (ret >= 0) {
-		for (i = 0; i < ARRAY_SIZE(sld_options); i++) {
-			if (match_option(arg, ret, sld_options[i].option)) {
-				state = sld_options[i].state;
-				break;
-			}
-		}
-	}
-	sld_state = state;
-}
-
-static void __init __split_lock_setup(void)
-{
-	if (!split_lock_verify_msr(false)) {
-		pr_info("MSR access failed: Disabled\n");
-		return;
-	}
-
-	rdmsrl(MSR_TEST_CTRL, msr_test_ctrl_cache);
-
-	if (!split_lock_verify_msr(true)) {
-		pr_info("MSR access failed: Disabled\n");
-		return;
-	}
-
-	/* Restore the MSR to its cached value. */
-	wrmsrl(MSR_TEST_CTRL, msr_test_ctrl_cache);
-
-	setup_force_cpu_cap(X86_FEATURE_SPLIT_LOCK_DETECT);
-}
-
-/*
- * MSR_TEST_CTRL is per core, but we treat it like a per CPU MSR. Locking
- * is not implemented as one thread could undo the setting of the other
- * thread immediately after dropping the lock anyway.
- */
-static void sld_update_msr(bool on)
-{
-	u64 test_ctrl_val = msr_test_ctrl_cache;
-
-	if (on)
-		test_ctrl_val |= MSR_TEST_CTRL_SPLIT_LOCK_DETECT;
-
-	wrmsrl(MSR_TEST_CTRL, test_ctrl_val);
-}
-
-static void split_lock_init(void)
-{
-	/*
-	 * #DB for bus lock handles ratelimit and #AC for split lock is
-	 * disabled.
-	 */
-	if (sld_state == sld_ratelimit) {
-		split_lock_verify_msr(false);
-		return;
-	}
-
-	if (cpu_model_supports_sld)
-		split_lock_verify_msr(sld_state != sld_off);
-}
-
-static void __split_lock_reenable_unlock(struct work_struct *work)
-{
-	sld_update_msr(true);
-	up(&buslock_sem);
-}
-
-static DECLARE_DELAYED_WORK(sl_reenable_unlock, __split_lock_reenable_unlock);
-
-static void __split_lock_reenable(struct work_struct *work)
-{
-	sld_update_msr(true);
-}
-static DECLARE_DELAYED_WORK(sl_reenable, __split_lock_reenable);
-
-/*
- * If a CPU goes offline with pending delayed work to re-enable split lock
- * detection then the delayed work will be executed on some other CPU. That
- * handles releasing the buslock_sem, but because it executes on a
- * different CPU probably won't re-enable split lock detection. This is a
- * problem on HT systems since the sibling CPU on the same core may then be
- * left running with split lock detection disabled.
- *
- * Unconditionally re-enable detection here.
- */
-static int splitlock_cpu_offline(unsigned int cpu)
-{
-	sld_update_msr(true);
-
-	return 0;
-}
-
-static void split_lock_warn(unsigned long ip)
-{
-	struct delayed_work *work;
-	int cpu;
-
-	if (!current->reported_split_lock)
-		pr_warn_ratelimited("#AC: %s/%d took a split_lock trap at address: 0x%lx\n",
-				    current->comm, current->pid, ip);
-	current->reported_split_lock = 1;
-
-	if (sysctl_sld_mitigate) {
-		/*
-		 * misery factor #1:
-		 * sleep 10ms before trying to execute split lock.
-		 */
-		if (msleep_interruptible(10) > 0)
-			return;
-		/*
-		 * Misery factor #2:
-		 * only allow one buslocked disabled core at a time.
-		 */
-		if (down_interruptible(&buslock_sem) == -EINTR)
-			return;
-		work = &sl_reenable_unlock;
-	} else {
-		work = &sl_reenable;
-	}
-
-	cpu = get_cpu();
-	schedule_delayed_work_on(cpu, work, 2);
-
-	/* Disable split lock detection on this CPU to make progress */
-	sld_update_msr(false);
-	put_cpu();
-}
-
-bool handle_guest_split_lock(unsigned long ip)
-{
-	if (sld_state == sld_warn) {
-		split_lock_warn(ip);
-		return true;
-	}
-
-	pr_warn_once("#AC: %s/%d %s split_lock trap at address: 0x%lx\n",
-		     current->comm, current->pid,
-		     sld_state == sld_fatal ? "fatal" : "bogus", ip);
-
-	current->thread.error_code = 0;
-	current->thread.trap_nr = X86_TRAP_AC;
-	force_sig_fault(SIGBUS, BUS_ADRALN, NULL);
-	return false;
-}
-EXPORT_SYMBOL_GPL(handle_guest_split_lock);
-
-static void bus_lock_init(void)
-{
-	u64 val;
-
-	if (!boot_cpu_has(X86_FEATURE_BUS_LOCK_DETECT))
-		return;
-
-	rdmsrl(MSR_IA32_DEBUGCTLMSR, val);
-
-	if ((boot_cpu_has(X86_FEATURE_SPLIT_LOCK_DETECT) &&
-	    (sld_state == sld_warn || sld_state == sld_fatal)) ||
-	    sld_state == sld_off) {
-		/*
-		 * Warn and fatal are handled by #AC for split lock if #AC for
-		 * split lock is supported.
-		 */
-		val &= ~DEBUGCTLMSR_BUS_LOCK_DETECT;
-	} else {
-		val |= DEBUGCTLMSR_BUS_LOCK_DETECT;
-	}
-
-	wrmsrl(MSR_IA32_DEBUGCTLMSR, val);
-}
-
-bool handle_user_split_lock(struct pt_regs *regs, long error_code)
-{
-	if ((regs->flags & X86_EFLAGS_AC) || sld_state == sld_fatal)
-		return false;
-	split_lock_warn(regs->ip);
-	return true;
-}
-
-void handle_bus_lock(struct pt_regs *regs)
-{
-	switch (sld_state) {
-	case sld_off:
-		break;
-	case sld_ratelimit:
-		/* Enforce no more than bld_ratelimit bus locks/sec. */
-		while (!__ratelimit(&bld_ratelimit))
-			msleep(20);
-		/* Warn on the bus lock. */
-		fallthrough;
-	case sld_warn:
-		pr_warn_ratelimited("#DB: %s/%d took a bus_lock trap at address: 0x%lx\n",
-				    current->comm, current->pid, regs->ip);
-		break;
-	case sld_fatal:
-		force_sig_fault(SIGBUS, BUS_ADRALN, NULL);
-		break;
-	}
-}
-
-/*
- * CPU models that are known to have the per-core split-lock detection
- * feature even though they do not enumerate IA32_CORE_CAPABILITIES.
- */
-static const struct x86_cpu_id split_lock_cpu_ids[] __initconst = {
-	X86_MATCH_INTEL_FAM6_MODEL(ICELAKE_X,	0),
-	X86_MATCH_INTEL_FAM6_MODEL(ICELAKE_L,	0),
-	X86_MATCH_INTEL_FAM6_MODEL(ICELAKE_D,	0),
-	{}
-};
-
-static void __init split_lock_setup(struct cpuinfo_x86 *c)
-{
-	const struct x86_cpu_id *m;
-	u64 ia32_core_caps;
-
-	if (boot_cpu_has(X86_FEATURE_HYPERVISOR))
-		return;
-
-	/* Check for CPUs that have support but do not enumerate it: */
-	m = x86_match_cpu(split_lock_cpu_ids);
-	if (m)
-		goto supported;
-
-	if (!cpu_has(c, X86_FEATURE_CORE_CAPABILITIES))
-		return;
-
-	/*
-	 * Not all bits in MSR_IA32_CORE_CAPS are architectural, but
-	 * MSR_IA32_CORE_CAPS_SPLIT_LOCK_DETECT is.  All CPUs that set
-	 * it have split lock detection.
-	 */
-	rdmsrl(MSR_IA32_CORE_CAPS, ia32_core_caps);
-	if (ia32_core_caps & MSR_IA32_CORE_CAPS_SPLIT_LOCK_DETECT)
-		goto supported;
-
-	/* CPU is not in the model list and does not have the MSR bit: */
-	return;
-
-supported:
-	cpu_model_supports_sld = true;
-	__split_lock_setup();
-}
-
-static void sld_state_show(void)
-{
-	if (!boot_cpu_has(X86_FEATURE_BUS_LOCK_DETECT) &&
-	    !boot_cpu_has(X86_FEATURE_SPLIT_LOCK_DETECT))
-		return;
-
-	switch (sld_state) {
-	case sld_off:
-		pr_info("disabled\n");
-		break;
-	case sld_warn:
-		if (boot_cpu_has(X86_FEATURE_SPLIT_LOCK_DETECT)) {
-			pr_info("#AC: crashing the kernel on kernel split_locks and warning on user-space split_locks\n");
-			if (cpuhp_setup_state(CPUHP_AP_ONLINE_DYN,
-					      "x86/splitlock", NULL, splitlock_cpu_offline) < 0)
-				pr_warn("No splitlock CPU offline handler\n");
-		} else if (boot_cpu_has(X86_FEATURE_BUS_LOCK_DETECT)) {
-			pr_info("#DB: warning on user-space bus_locks\n");
-		}
-		break;
-	case sld_fatal:
-		if (boot_cpu_has(X86_FEATURE_SPLIT_LOCK_DETECT)) {
-			pr_info("#AC: crashing the kernel on kernel split_locks and sending SIGBUS on user-space split_locks\n");
-		} else if (boot_cpu_has(X86_FEATURE_BUS_LOCK_DETECT)) {
-			pr_info("#DB: sending SIGBUS on user-space bus_locks%s\n",
-				boot_cpu_has(X86_FEATURE_SPLIT_LOCK_DETECT) ?
-				" from non-WB" : "");
-		}
-		break;
-	case sld_ratelimit:
-		if (boot_cpu_has(X86_FEATURE_BUS_LOCK_DETECT))
-			pr_info("#DB: setting system wide bus lock rate limit to %u/sec\n", bld_ratelimit.burst);
-		break;
-	}
-}
-
-void __init sld_setup(struct cpuinfo_x86 *c)
-{
-	split_lock_setup(c);
-	sld_state_setup();
-	sld_state_show();
-}
-
 #define X86_HYBRID_CPU_TYPE_ID_SHIFT	24
 
 /**
diff --git a/arch/x86/kernel/cpu/split-bus-lock.c b/arch/x86/kernel/cpu/split-bus-lock.c
new file mode 100644
index 000000000000..6ba04dc8ea64
--- /dev/null
+++ b/arch/x86/kernel/cpu/split-bus-lock.c
@@ -0,0 +1,406 @@
+// SPDX-License-Identifier: GPL-2.0
+
+#define pr_fmt(fmt) "x86/split lock detection: " fmt
+
+#include <linux/semaphore.h>
+#include <linux/workqueue.h>
+#include <linux/delay.h>
+#include <linux/cpuhotplug.h>
+#include <asm/cpu_device_id.h>
+#include <asm/cmdline.h>
+#include <asm/traps.h>
+#include <asm/cpu.h>
+
+enum split_lock_detect_state {
+	sld_off = 0,
+	sld_warn,
+	sld_fatal,
+	sld_ratelimit,
+};
+
+/*
+ * Default to sld_off because most systems do not support split lock detection.
+ * sld_state_setup() will switch this to sld_warn on systems that support
+ * split lock/bus lock detect, unless there is a command line override.
+ */
+static enum split_lock_detect_state sld_state __ro_after_init = sld_off;
+static u64 msr_test_ctrl_cache __ro_after_init;
+
+/*
+ * With a name like MSR_TEST_CTL it should go without saying, but don't touch
+ * MSR_TEST_CTL unless the CPU is one of the whitelisted models.  Writing it
+ * on CPUs that do not support SLD can cause fireworks, even when writing '0'.
+ */
+static bool cpu_model_supports_sld __ro_after_init;
+
+static const struct {
+	const char			*option;
+	enum split_lock_detect_state	state;
+} sld_options[] __initconst = {
+	{ "off",	sld_off   },
+	{ "warn",	sld_warn  },
+	{ "fatal",	sld_fatal },
+	{ "ratelimit:", sld_ratelimit },
+};
+
+static struct ratelimit_state bld_ratelimit;
+
+static unsigned int sysctl_sld_mitigate = 1;
+static DEFINE_SEMAPHORE(buslock_sem, 1);
+
+#ifdef CONFIG_PROC_SYSCTL
+static struct ctl_table sld_sysctls[] = {
+	{
+		.procname       = "split_lock_mitigate",
+		.data           = &sysctl_sld_mitigate,
+		.maxlen         = sizeof(unsigned int),
+		.mode           = 0644,
+		.proc_handler	= proc_douintvec_minmax,
+		.extra1         = SYSCTL_ZERO,
+		.extra2         = SYSCTL_ONE,
+	},
+};
+
+static int __init sld_mitigate_sysctl_init(void)
+{
+	register_sysctl_init("kernel", sld_sysctls);
+	return 0;
+}
+
+late_initcall(sld_mitigate_sysctl_init);
+#endif
+
+static inline bool match_option(const char *arg, int arglen, const char *opt)
+{
+	int len = strlen(opt), ratelimit;
+
+	if (strncmp(arg, opt, len))
+		return false;
+
+	/*
+	 * Min ratelimit is 1 bus lock/sec.
+	 * Max ratelimit is 1000 bus locks/sec.
+	 */
+	if (sscanf(arg, "ratelimit:%d", &ratelimit) == 1 &&
+	    ratelimit > 0 && ratelimit <= 1000) {
+		ratelimit_state_init(&bld_ratelimit, HZ, ratelimit);
+		ratelimit_set_flags(&bld_ratelimit, RATELIMIT_MSG_ON_RELEASE);
+		return true;
+	}
+
+	return len == arglen;
+}
+
+static bool split_lock_verify_msr(bool on)
+{
+	u64 ctrl, tmp;
+
+	if (rdmsrl_safe(MSR_TEST_CTRL, &ctrl))
+		return false;
+	if (on)
+		ctrl |= MSR_TEST_CTRL_SPLIT_LOCK_DETECT;
+	else
+		ctrl &= ~MSR_TEST_CTRL_SPLIT_LOCK_DETECT;
+	if (wrmsrl_safe(MSR_TEST_CTRL, ctrl))
+		return false;
+	rdmsrl(MSR_TEST_CTRL, tmp);
+	return ctrl == tmp;
+}
+
+static void __init sld_state_setup(void)
+{
+	enum split_lock_detect_state state = sld_warn;
+	char arg[20];
+	int i, ret;
+
+	if (!boot_cpu_has(X86_FEATURE_SPLIT_LOCK_DETECT) &&
+	    !boot_cpu_has(X86_FEATURE_BUS_LOCK_DETECT))
+		return;
+
+	ret = cmdline_find_option(boot_command_line, "split_lock_detect",
+				  arg, sizeof(arg));
+	if (ret >= 0) {
+		for (i = 0; i < ARRAY_SIZE(sld_options); i++) {
+			if (match_option(arg, ret, sld_options[i].option)) {
+				state = sld_options[i].state;
+				break;
+			}
+		}
+	}
+	sld_state = state;
+}
+
+static void __init __split_lock_setup(void)
+{
+	if (!split_lock_verify_msr(false)) {
+		pr_info("MSR access failed: Disabled\n");
+		return;
+	}
+
+	rdmsrl(MSR_TEST_CTRL, msr_test_ctrl_cache);
+
+	if (!split_lock_verify_msr(true)) {
+		pr_info("MSR access failed: Disabled\n");
+		return;
+	}
+
+	/* Restore the MSR to its cached value. */
+	wrmsrl(MSR_TEST_CTRL, msr_test_ctrl_cache);
+
+	setup_force_cpu_cap(X86_FEATURE_SPLIT_LOCK_DETECT);
+}
+
+/*
+ * MSR_TEST_CTRL is per core, but we treat it like a per CPU MSR. Locking
+ * is not implemented as one thread could undo the setting of the other
+ * thread immediately after dropping the lock anyway.
+ */
+static void sld_update_msr(bool on)
+{
+	u64 test_ctrl_val = msr_test_ctrl_cache;
+
+	if (on)
+		test_ctrl_val |= MSR_TEST_CTRL_SPLIT_LOCK_DETECT;
+
+	wrmsrl(MSR_TEST_CTRL, test_ctrl_val);
+}
+
+void split_lock_init(void)
+{
+	/*
+	 * #DB for bus lock handles ratelimit and #AC for split lock is
+	 * disabled.
+	 */
+	if (sld_state == sld_ratelimit) {
+		split_lock_verify_msr(false);
+		return;
+	}
+
+	if (cpu_model_supports_sld)
+		split_lock_verify_msr(sld_state != sld_off);
+}
+
+static void __split_lock_reenable_unlock(struct work_struct *work)
+{
+	sld_update_msr(true);
+	up(&buslock_sem);
+}
+
+static DECLARE_DELAYED_WORK(sl_reenable_unlock, __split_lock_reenable_unlock);
+
+static void __split_lock_reenable(struct work_struct *work)
+{
+	sld_update_msr(true);
+}
+static DECLARE_DELAYED_WORK(sl_reenable, __split_lock_reenable);
+
+/*
+ * If a CPU goes offline with pending delayed work to re-enable split lock
+ * detection then the delayed work will be executed on some other CPU. That
+ * handles releasing the buslock_sem, but because it executes on a
+ * different CPU probably won't re-enable split lock detection. This is a
+ * problem on HT systems since the sibling CPU on the same core may then be
+ * left running with split lock detection disabled.
+ *
+ * Unconditionally re-enable detection here.
+ */
+static int splitlock_cpu_offline(unsigned int cpu)
+{
+	sld_update_msr(true);
+
+	return 0;
+}
+
+static void split_lock_warn(unsigned long ip)
+{
+	struct delayed_work *work;
+	int cpu;
+
+	if (!current->reported_split_lock)
+		pr_warn_ratelimited("#AC: %s/%d took a split_lock trap at address: 0x%lx\n",
+				    current->comm, current->pid, ip);
+	current->reported_split_lock = 1;
+
+	if (sysctl_sld_mitigate) {
+		/*
+		 * misery factor #1:
+		 * sleep 10ms before trying to execute split lock.
+		 */
+		if (msleep_interruptible(10) > 0)
+			return;
+		/*
+		 * Misery factor #2:
+		 * only allow one buslocked disabled core at a time.
+		 */
+		if (down_interruptible(&buslock_sem) == -EINTR)
+			return;
+		work = &sl_reenable_unlock;
+	} else {
+		work = &sl_reenable;
+	}
+
+	cpu = get_cpu();
+	schedule_delayed_work_on(cpu, work, 2);
+
+	/* Disable split lock detection on this CPU to make progress */
+	sld_update_msr(false);
+	put_cpu();
+}
+
+bool handle_guest_split_lock(unsigned long ip)
+{
+	if (sld_state == sld_warn) {
+		split_lock_warn(ip);
+		return true;
+	}
+
+	pr_warn_once("#AC: %s/%d %s split_lock trap at address: 0x%lx\n",
+		     current->comm, current->pid,
+		     sld_state == sld_fatal ? "fatal" : "bogus", ip);
+
+	current->thread.error_code = 0;
+	current->thread.trap_nr = X86_TRAP_AC;
+	force_sig_fault(SIGBUS, BUS_ADRALN, NULL);
+	return false;
+}
+EXPORT_SYMBOL_GPL(handle_guest_split_lock);
+
+void bus_lock_init(void)
+{
+	u64 val;
+
+	if (!boot_cpu_has(X86_FEATURE_BUS_LOCK_DETECT))
+		return;
+
+	rdmsrl(MSR_IA32_DEBUGCTLMSR, val);
+
+	if ((boot_cpu_has(X86_FEATURE_SPLIT_LOCK_DETECT) &&
+	    (sld_state == sld_warn || sld_state == sld_fatal)) ||
+	    sld_state == sld_off) {
+		/*
+		 * Warn and fatal are handled by #AC for split lock if #AC for
+		 * split lock is supported.
+		 */
+		val &= ~DEBUGCTLMSR_BUS_LOCK_DETECT;
+	} else {
+		val |= DEBUGCTLMSR_BUS_LOCK_DETECT;
+	}
+
+	wrmsrl(MSR_IA32_DEBUGCTLMSR, val);
+}
+
+bool handle_user_split_lock(struct pt_regs *regs, long error_code)
+{
+	if ((regs->flags & X86_EFLAGS_AC) || sld_state == sld_fatal)
+		return false;
+	split_lock_warn(regs->ip);
+	return true;
+}
+
+void handle_bus_lock(struct pt_regs *regs)
+{
+	switch (sld_state) {
+	case sld_off:
+		break;
+	case sld_ratelimit:
+		/* Enforce no more than bld_ratelimit bus locks/sec. */
+		while (!__ratelimit(&bld_ratelimit))
+			msleep(20);
+		/* Warn on the bus lock. */
+		fallthrough;
+	case sld_warn:
+		pr_warn_ratelimited("#DB: %s/%d took a bus_lock trap at address: 0x%lx\n",
+				    current->comm, current->pid, regs->ip);
+		break;
+	case sld_fatal:
+		force_sig_fault(SIGBUS, BUS_ADRALN, NULL);
+		break;
+	}
+}
+
+/*
+ * CPU models that are known to have the per-core split-lock detection
+ * feature even though they do not enumerate IA32_CORE_CAPABILITIES.
+ */
+static const struct x86_cpu_id split_lock_cpu_ids[] __initconst = {
+	X86_MATCH_INTEL_FAM6_MODEL(ICELAKE_X,	0),
+	X86_MATCH_INTEL_FAM6_MODEL(ICELAKE_L,	0),
+	X86_MATCH_INTEL_FAM6_MODEL(ICELAKE_D,	0),
+	{}
+};
+
+static void __init split_lock_setup(struct cpuinfo_x86 *c)
+{
+	const struct x86_cpu_id *m;
+	u64 ia32_core_caps;
+
+	if (boot_cpu_has(X86_FEATURE_HYPERVISOR))
+		return;
+
+	/* Check for CPUs that have support but do not enumerate it: */
+	m = x86_match_cpu(split_lock_cpu_ids);
+	if (m)
+		goto supported;
+
+	if (!cpu_has(c, X86_FEATURE_CORE_CAPABILITIES))
+		return;
+
+	/*
+	 * Not all bits in MSR_IA32_CORE_CAPS are architectural, but
+	 * MSR_IA32_CORE_CAPS_SPLIT_LOCK_DETECT is.  All CPUs that set
+	 * it have split lock detection.
+	 */
+	rdmsrl(MSR_IA32_CORE_CAPS, ia32_core_caps);
+	if (ia32_core_caps & MSR_IA32_CORE_CAPS_SPLIT_LOCK_DETECT)
+		goto supported;
+
+	/* CPU is not in the model list and does not have the MSR bit: */
+	return;
+
+supported:
+	cpu_model_supports_sld = true;
+	__split_lock_setup();
+}
+
+static void sld_state_show(void)
+{
+	if (!boot_cpu_has(X86_FEATURE_BUS_LOCK_DETECT) &&
+	    !boot_cpu_has(X86_FEATURE_SPLIT_LOCK_DETECT))
+		return;
+
+	switch (sld_state) {
+	case sld_off:
+		pr_info("disabled\n");
+		break;
+	case sld_warn:
+		if (boot_cpu_has(X86_FEATURE_SPLIT_LOCK_DETECT)) {
+			pr_info("#AC: crashing the kernel on kernel split_locks and warning on user-space split_locks\n");
+			if (cpuhp_setup_state(CPUHP_AP_ONLINE_DYN,
+					      "x86/splitlock", NULL, splitlock_cpu_offline) < 0)
+				pr_warn("No splitlock CPU offline handler\n");
+		} else if (boot_cpu_has(X86_FEATURE_BUS_LOCK_DETECT)) {
+			pr_info("#DB: warning on user-space bus_locks\n");
+		}
+		break;
+	case sld_fatal:
+		if (boot_cpu_has(X86_FEATURE_SPLIT_LOCK_DETECT)) {
+			pr_info("#AC: crashing the kernel on kernel split_locks and sending SIGBUS on user-space split_locks\n");
+		} else if (boot_cpu_has(X86_FEATURE_BUS_LOCK_DETECT)) {
+			pr_info("#DB: sending SIGBUS on user-space bus_locks%s\n",
+				boot_cpu_has(X86_FEATURE_SPLIT_LOCK_DETECT) ?
+				" from non-WB" : "");
+		}
+		break;
+	case sld_ratelimit:
+		if (boot_cpu_has(X86_FEATURE_BUS_LOCK_DETECT))
+			pr_info("#DB: setting system wide bus lock rate limit to %u/sec\n", bld_ratelimit.burst);
+		break;
+	}
+}
+
+void __init sld_setup(struct cpuinfo_x86 *c)
+{
+	split_lock_setup(c);
+	sld_state_setup();
+	sld_state_show();
+}
-- 
2.44.0


