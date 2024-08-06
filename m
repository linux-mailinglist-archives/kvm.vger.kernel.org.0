Return-Path: <kvm+bounces-23361-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 87252948FA9
	for <lists+kvm@lfdr.de>; Tue,  6 Aug 2024 14:55:48 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 0E5891F228A6
	for <lists+kvm@lfdr.de>; Tue,  6 Aug 2024 12:55:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D07461C57B3;
	Tue,  6 Aug 2024 12:55:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="LHh/DItg"
X-Original-To: kvm@vger.kernel.org
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2054.outbound.protection.outlook.com [40.107.236.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6F4A31C462A;
	Tue,  6 Aug 2024 12:55:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.236.54
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722948923; cv=fail; b=UcZ7A9SbNoPBDtGiZ2hZz4k6IDWTRMnDdXBM/dBuq/pbFA9M/t6ZsaWng/pFDU7IZsj24u859jmyE9hXfK4PqtlRXux67n2rbNqqgFA4cL1OIiyYiofuLNDmixRZlA8DXCrluBBfryUno2NtAdRGM4/Isp8/ez4mPbqloElK1es=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722948923; c=relaxed/simple;
	bh=EsKZvdl7OwKxNS0d9+gZSKmkzUEouvpSaeDF2tyjgQg=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=YKfzWwS3FWIruo4o9a9b49DMBSmafNQSf64F9WicLdjvxWxWXCy7UDXQhwzhrXeneH8ccFscbUAO975w8Fng31R8KGtvuzd7c9HMSappcL5tXIEETLqzqIVDmXE605PoAHfKBY1GOSU8oYWDjgLeVuFD7SgWXWDDCsOFEWKHbyc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=LHh/DItg; arc=fail smtp.client-ip=40.107.236.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=BCpTiwFEswfO3uzmVGKb1/nKsok4c9/MOn8+TM8LEY2FuWL3UI41644mgZvc0YPmCF6C92qeVl2UrswKD0Ckmu89XGgSxBAVMNPJ2Q47D0JrgLV/GUA+LSr9QNM97yVV2KaksFXgm/W63+/2EuURbnUbhHmmevzsGLjdhxYNeyMpbtrR2G2h4foRfYGETpA0rA8ir24H0hGwrNe6T6s9ZEXtGgALgGHJ9Vo2ujs+uSjJrpQ2SaLM3kuVnJNuNmUUP+Ga1pXsLgDixW8N62aD0vo5akGoNNI08rGFQknO1B8LRryKShCIQL46Xo7/TlehLSr42SYH7dvkSOChPNajzg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=5I0t8O0w/u57qJw5LxOvPxQB01uNtXJb3uzDKpTAKdA=;
 b=aZVWnFJ+h2BAaohnGI1TpexPLzii3eW/6Jz3DoZs6ypkGFItTSS7HJ6+52AZIQpMnspPke6j8yIqW9Xsg7h4e2aJtzxZJx1+2ZXREL349gwG/eLJqDaD+GEQ+9olwvCeDyDq2+Kjq+JuF+uQ6kje9D2wZJDNyPl1J3ZpK/pi0LOXCw2i+XCkw7O2iNgkCTpMNBrZWZKKH1f4XhJ4258bZapk8r6Uby8hPRaqtPZgr6IMGzUWvzgMMRTJrn7lu7yH4ZbRomLHqi/kqOg3jTyNZov2AJMzqGwSdnv3QTXrBMbRdMtdc7oIAC5uGxwgsPFBceKtd2lakK8ulZc3WcEQAA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=linutronix.de smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5I0t8O0w/u57qJw5LxOvPxQB01uNtXJb3uzDKpTAKdA=;
 b=LHh/DItgxpjOGvQNQWLrq77K6k1V1sMTz82o0hSVtIhjPflGsFY6pmRZKatk21nHo085sJZarIxuJfXpIzImPwMDydB9k2WJDgVyH4Q7LbotsOZY+oE8PLTLcDnzgLeTCXjfIwat7sTAKzvaCdQ7iOrXgVks+HheGOBZrHMlA8o=
Received: from MW4PR03CA0140.namprd03.prod.outlook.com (2603:10b6:303:8c::25)
 by CH3PR12MB7715.namprd12.prod.outlook.com (2603:10b6:610:151::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7828.26; Tue, 6 Aug
 2024 12:55:14 +0000
Received: from SJ5PEPF000001C8.namprd05.prod.outlook.com
 (2603:10b6:303:8c:cafe::16) by MW4PR03CA0140.outlook.office365.com
 (2603:10b6:303:8c::25) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7828.28 via Frontend
 Transport; Tue, 6 Aug 2024 12:55:12 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 SJ5PEPF000001C8.mail.protection.outlook.com (10.167.242.36) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.7849.8 via Frontend Transport; Tue, 6 Aug 2024 12:55:12 +0000
Received: from BLR-L-RBANGORI.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Tue, 6 Aug
 2024 07:55:04 -0500
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
Subject: [PATCH v3 1/4] x86/split_lock: Move Split and Bus lock code to a dedicated file
Date: Tue, 6 Aug 2024 12:54:39 +0000
Message-ID: <20240806125442.1603-2-ravi.bangoria@amd.com>
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
X-MS-TrafficTypeDiagnostic: SJ5PEPF000001C8:EE_|CH3PR12MB7715:EE_
X-MS-Office365-Filtering-Correlation-Id: 65cceec6-b97a-4b08-b197-08dcb61702ae
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|376014|82310400026|36860700013|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?Rz5zsVUzc60sP4I1U57nTvtKJgYHuBfOindy1EftHBed0QwSP5r/dDH0RYAY?=
 =?us-ascii?Q?3jj+6lKcQIak7f+2LI1sRwjTL3ho43m5ASH3lD4EEAHZIL5GBx/tGR1R3XVC?=
 =?us-ascii?Q?H8HexAMSREUiMiVVtVMonquMqJtYSPGcuQM/l6lhhwT2Y3Q+HDXo0s0FR/ba?=
 =?us-ascii?Q?KfnKaeFyQ92Lx0zzbdgAThSwcNV7SA4WH4m0zR/FB+e2rT5AbOpcc/QXwZKq?=
 =?us-ascii?Q?Kwa/jL4KwqZIruxwHsXNwcl0fvmJW7L3LjVp124JIXhgu6LpwRaBQDM9GiiP?=
 =?us-ascii?Q?W0JiLMvHzy5aAxe42U9HzCt824cbvfYTmbSAYHXBMXRvcL42KR4rX7nv/GKn?=
 =?us-ascii?Q?7QK/wFTd46qp5GL/lyKdm2zFXSjjAP/Es6U8X0+dHj92xD+BC+qNWRxjNEVT?=
 =?us-ascii?Q?lWCDpyIpgPce/bYqk30MsvkbyYFkZ4u+UEpSGt+s6YEiZlgq2J8A/wkEi6Rz?=
 =?us-ascii?Q?9Wi5hMii18xy5ImF4LquZSSaeSHWxZ5O0M/kPp1rOcrZoe8rWPlIyCNhNXeE?=
 =?us-ascii?Q?S8LhioayQ51Hl4t0gbGTLkd5rD/rdvx0cZ+BmjybD4bndV7Jw4s/SAmJwGfT?=
 =?us-ascii?Q?DxyAZgWkP/PvQ3f1GOQFbIdGZmnzRYweALx1MJAbM0iLk/xe3eXRn40sdfv5?=
 =?us-ascii?Q?0CnJ4CWC/C2WJoC9CLd2HqV3IlhDom9+TtVEVfCJYmjEMrKdOU3bVbKb9bQf?=
 =?us-ascii?Q?LFsSQ+4PzDgbjIfdNA7/YUa1YD8ePsnKEQM/8AjrTvRjfbOUKvPUigH6r3Sw?=
 =?us-ascii?Q?ffGdn6bQ9oExuJbbuyzA03+CRrfH+zPlgHkYh3+Sb1wpv5et89srMB9fs2Rm?=
 =?us-ascii?Q?O6PvhbVg2rNfII8+e9xVHrLMWZnBZQS5tKjy8Ro/WzYTBezVqcsewaO6YnE5?=
 =?us-ascii?Q?4YE2jTZOpNP8cHa7dE66OeMzMbaBluplfnNzwpiX+1MsZBQnJ5ttLVs9vDE2?=
 =?us-ascii?Q?mpx85pdeKeNJDmgb/Rlrs/vVPOHHqusCZwSv2z2rf3+E6qd2lYn9Z2f1GdGB?=
 =?us-ascii?Q?I2fss+X76aiSeZI9PUkTm5Uf9d6THi+J/zLR0W3OgaNrgCKdR5L3pWp8Rc6i?=
 =?us-ascii?Q?KB2qmhMsJHrOXZ3zD846X+oEYTJcJgkIt6XcZxdSPec0huFejm1lBHvssX45?=
 =?us-ascii?Q?140QYPJDKxRP54QZSdT/hLUsVE81UyASIvi6nqHzKaSjn/wbxntrZb6wF5pe?=
 =?us-ascii?Q?pZrN/0fOJip2UC4fqd25GhxC9lmDM30m5jA2tQnN/iyId93xx3QqXrfftVPl?=
 =?us-ascii?Q?r+SF1TjtvJRshe1GPyitw0b4grPoBZRkFO4F1G2iNHnO02hbSANyJiFU/uCU?=
 =?us-ascii?Q?8pokpIBS/iYt/Z+Si8xcg9II+Bqw3rFVGx9d8xcn9YIATd7khODcaO+MxTKF?=
 =?us-ascii?Q?QtC4uxsVqJ0UurcjUr0RUZR3M+p3fOKgG7mLzPt8oK1gGniWHFeF0nfdTI1o?=
 =?us-ascii?Q?eCBxqLa6OljdKsW54LbLOGoVM+n5Npkr?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(7416014)(376014)(82310400026)(36860700013)(1800799024);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Aug 2024 12:55:12.3711
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 65cceec6-b97a-4b08-b197-08dcb61702ae
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SJ5PEPF000001C8.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR12MB7715

Bus Lock Detect functionality on AMD platforms works identical to Intel.
Move split_lock and bus_lock specific code from intel.c to a dedicated
file so that it can be compiled and supported on non-Intel platforms.

Signed-off-by: Ravi Bangoria <ravi.bangoria@amd.com>
---
 arch/x86/include/asm/cpu.h     |   4 +
 arch/x86/kernel/cpu/Makefile   |   1 +
 arch/x86/kernel/cpu/bus_lock.c | 410 +++++++++++++++++++++++++++++++++
 arch/x86/kernel/cpu/intel.c    | 406 --------------------------------
 4 files changed, 415 insertions(+), 406 deletions(-)
 create mode 100644 arch/x86/kernel/cpu/bus_lock.c

diff --git a/arch/x86/include/asm/cpu.h b/arch/x86/include/asm/cpu.h
index aa30fd8cad7f..051d872d2faf 100644
--- a/arch/x86/include/asm/cpu.h
+++ b/arch/x86/include/asm/cpu.h
@@ -31,6 +31,8 @@ extern void __init sld_setup(struct cpuinfo_x86 *c);
 extern bool handle_user_split_lock(struct pt_regs *regs, long error_code);
 extern bool handle_guest_split_lock(unsigned long ip);
 extern void handle_bus_lock(struct pt_regs *regs);
+void split_lock_init(void);
+void bus_lock_init(void);
 u8 get_this_hybrid_cpu_type(void);
 #else
 static inline void __init sld_setup(struct cpuinfo_x86 *c) {}
@@ -45,6 +47,8 @@ static inline bool handle_guest_split_lock(unsigned long ip)
 }
 
 static inline void handle_bus_lock(struct pt_regs *regs) {}
+static inline void split_lock_init(void) {}
+static inline void bus_lock_init(void) {}
 
 static inline u8 get_this_hybrid_cpu_type(void)
 {
diff --git a/arch/x86/kernel/cpu/Makefile b/arch/x86/kernel/cpu/Makefile
index 5857a0f5d514..9f74e0011f01 100644
--- a/arch/x86/kernel/cpu/Makefile
+++ b/arch/x86/kernel/cpu/Makefile
@@ -27,6 +27,7 @@ obj-y			+= aperfmperf.o
 obj-y			+= cpuid-deps.o
 obj-y			+= umwait.o
 obj-y 			+= capflags.o powerflags.o
+obj-y			+= bus_lock.o
 
 obj-$(CONFIG_X86_LOCAL_APIC)		+= topology.o
 
diff --git a/arch/x86/kernel/cpu/bus_lock.c b/arch/x86/kernel/cpu/bus_lock.c
new file mode 100644
index 000000000000..cffb3f2838dc
--- /dev/null
+++ b/arch/x86/kernel/cpu/bus_lock.c
@@ -0,0 +1,410 @@
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
+#if defined(CONFIG_CPU_SUP_INTEL)
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
+	X86_MATCH_VFM(INTEL_ICELAKE_X,	0),
+	X86_MATCH_VFM(INTEL_ICELAKE_L,	0),
+	X86_MATCH_VFM(INTEL_ICELAKE_D,	0),
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
+
+#endif /* defined(CONFIG_CPU_SUP_INTEL) */
diff --git a/arch/x86/kernel/cpu/intel.c b/arch/x86/kernel/cpu/intel.c
index 08b95a35b5cb..8a483f4ad026 100644
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
@@ -24,8 +20,6 @@
 #include <asm/hwcap2.h>
 #include <asm/elf.h>
 #include <asm/cpu_device_id.h>
-#include <asm/cmdline.h>
-#include <asm/traps.h>
 #include <asm/resctrl.h>
 #include <asm/numa.h>
 #include <asm/thermal.h>
@@ -41,28 +35,6 @@
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
@@ -547,9 +519,6 @@ static void init_intel_misc_features(struct cpuinfo_x86 *c)
 	wrmsrl(MSR_MISC_FEATURES_ENABLES, msr);
 }
 
-static void split_lock_init(void);
-static void bus_lock_init(void);
-
 static void init_intel(struct cpuinfo_x86 *c)
 {
 	early_init_intel(c);
@@ -907,381 +876,6 @@ static const struct cpu_dev intel_cpu_dev = {
 
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
-	X86_MATCH_VFM(INTEL_ICELAKE_X,	0),
-	X86_MATCH_VFM(INTEL_ICELAKE_L,	0),
-	X86_MATCH_VFM(INTEL_ICELAKE_D,	0),
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
-- 
2.34.1


