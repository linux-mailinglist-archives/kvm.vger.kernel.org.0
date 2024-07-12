Return-Path: <kvm+bounces-21496-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 27C9792F820
	for <lists+kvm@lfdr.de>; Fri, 12 Jul 2024 11:41:43 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 4AF021C2188E
	for <lists+kvm@lfdr.de>; Fri, 12 Jul 2024 09:41:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BC3A0158A12;
	Fri, 12 Jul 2024 09:41:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="R1+cJht4"
X-Original-To: kvm@vger.kernel.org
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2045.outbound.protection.outlook.com [40.107.220.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AEC6213D51E;
	Fri, 12 Jul 2024 09:41:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.220.45
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720777271; cv=fail; b=lBPxVlSqQqZERXd/W3yyVS/AdrNiHNlpUJe2gBJwtVEYZK2X0eg3vSaHG79ytxhKELBTVxz1AslW9+TvdbhyVyLyP1eMmc911/Hfz721gZAilAHpPGq0pVD8seKY7s+LhjzzZWX1FaIQpIH2zLP0WHK6pHzcmzOO5vDPip9vEuw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720777271; c=relaxed/simple;
	bh=FdDutJ0Nr/zgUys2vq1EZNADolPDSMCq7giKnFYf+/o=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=MGsTU2FO8UCVsNvZsh9vh+woSge3PRq6RJbMN6xHhAq0JPKiSnjd1CYODFxTEmHDJuDVEXvVCT6kftiQTpYNo03ab0JBwYhLwqjfC/TQtwlh/rxMZ0FvjhvJhJIbMIq4hbv4HQyY5r5FS80+Llm2Lgzfpc9KWRe1PNMXTe0WF1o=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=R1+cJht4; arc=fail smtp.client-ip=40.107.220.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=yEL6+V0J/GrN3UJlJR+UFlPETiN28QiYo2Ld7nVUfo7HZdrY/yRMG4KzrJ7GZndcEj0yGIaeWENhxlSa9WhYL0FurIxuxj/CAinByDUftxE/1CF2ZEEAMvVm3/xjt9i7piFRV4YJN/5QktUlmGMx6eZ4bPClqYuCR5Z/SOVCIy7TtLrVoyzfKdhlIA+2Mydg1GywsKkdvdXCMPXdWOdVhxlT48Mdeck9X0hPUPlHCi9gz8NYwNLzvkhoqHfEkgXpI/Wy2i4unAckBbRcycMN1hCHQ9lxNRa0jbwlYKgooJ1evNyxejjRtpjlWK8QDGf215Po0yXwbRbTK4Yl5fYlKg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=G/CdgHy5BLgCrA/MN/TzXfZLXB0KjHLg36W+spRGkPY=;
 b=DQ3biCe1H7GvMnef5Mrmi5qimtIfy9Kokbxd4jwuNbX00f5rc7CjBh9kD2utybpQMphADGtbtwztGjlEFYnukfVz8E/c2tklGZPtaodTJPOYhVrdHQNnkTIWPmMiDxWowtlMhkXOJ8loUUAYwtvE3hdWY3RdO7VZVHSKDG05y/MupdgylTILIDWf/96pefM3awvAwHaZv7zgyTIIhP+d6aDkpNwyb8JrEmAAYLZKO99k3J3yKdyIU+V3cCnTDi9hBUsi3gjPECLdmVoIjjFiSuh18vfYsLW+Az0oyQhiCzCQZnlWH4WfiBOv89r2kP1LQgf6TPvCUXvlKqPEqllMKw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=linutronix.de smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=G/CdgHy5BLgCrA/MN/TzXfZLXB0KjHLg36W+spRGkPY=;
 b=R1+cJht4yPPhzq7vHkJ6O2RBHHhXcCkpr1ev4gEbcgQ3m8SyqjWvIkz+HR2Ksj50dW2MW1cneEfzrinvOIsl/Jfulns6LY2irRgoKEi92Zr+ael3KYi+6ooLhIgxdEFu2U8HczhisZD/yrtsd1atKnE9F9c5qfzummUr7L0TRJU=
Received: from DS7PR03CA0098.namprd03.prod.outlook.com (2603:10b6:5:3b7::13)
 by PH8PR12MB7375.namprd12.prod.outlook.com (2603:10b6:510:215::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7741.36; Fri, 12 Jul
 2024 09:41:04 +0000
Received: from DS3PEPF0000C37F.namprd04.prod.outlook.com
 (2603:10b6:5:3b7:cafe::d8) by DS7PR03CA0098.outlook.office365.com
 (2603:10b6:5:3b7::13) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7762.23 via Frontend
 Transport; Fri, 12 Jul 2024 09:41:04 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 DS3PEPF0000C37F.mail.protection.outlook.com (10.167.23.9) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.7762.17 via Frontend Transport; Fri, 12 Jul 2024 09:41:04 +0000
Received: from BLR-L-RBANGORI.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Fri, 12 Jul
 2024 04:40:55 -0500
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
	<ananth.narayan@amd.com>, <sandipan.das@amd.com>, <manali.shukla@amd.com>,
	<jmattson@google.com>
Subject: [PATCH v2 1/4] x86/split_lock: Move Split and Bus lock code to a dedicated file
Date: Fri, 12 Jul 2024 09:39:40 +0000
Message-ID: <20240712093943.1288-2-ravi.bangoria@amd.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240712093943.1288-1-ravi.bangoria@amd.com>
References: <20240712093943.1288-1-ravi.bangoria@amd.com>
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
X-MS-TrafficTypeDiagnostic: DS3PEPF0000C37F:EE_|PH8PR12MB7375:EE_
X-MS-Office365-Filtering-Correlation-Id: 74168020-336e-4913-9ae8-08dca256bf93
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|376014|82310400026|1800799024|36860700013;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?HVH77Yv8VL/8Yi3XzfWEhl6+nsUjXJlrruOudBtfnLCIkuRYixgEeI2xmeg4?=
 =?us-ascii?Q?aLnqOo9T0Zu7JZ9leEzE5aBzDsh5XtTdbXokJlxueIz43d+PK0Kajk4IYe+8?=
 =?us-ascii?Q?fZCkQxiw+bUp8U0HtlLJarvxLEaPtN3OxGeHRZHSeIf54VHTg+W22czzrqa7?=
 =?us-ascii?Q?v+/KnOub/31lRtt7/0BA2+QQsEGPo/d2NonFLcgpdoEeQw9F9n6p4cSXQON2?=
 =?us-ascii?Q?UJPN7qHCtqr3jmdrMJ0eqMjw2LbKO2UJDmqg6m2TSsHDWkrnabCHAhj1pope?=
 =?us-ascii?Q?AZngZJ3VaQA3tlDzt0n7NdRcwNCoCsru+Hk6oNTzeiAXiKoc/Re6QjwygbkT?=
 =?us-ascii?Q?jxnUXSg/lExESPkLemrgeLSoFiCZhzzhiVIAkKV9pwIfEwXwohoss8U/+GFX?=
 =?us-ascii?Q?D7U13FwE6o8SmA8rGwaCvhY2q8ACdgrrBPPgI/h97mVn0dp/hli0i1ZfaPhk?=
 =?us-ascii?Q?p613r4AiMKWBWL+xk/16peFapzsohZnd1rg+Mx8IiqsMNUEXY0SABYBt33Tc?=
 =?us-ascii?Q?0FTGxf7mrNx4hX4u9qFGW8BSxQ9WH4eLd3mulphPht9xsFT9LfOxotD3GhJE?=
 =?us-ascii?Q?mcLJclLykCaAh+izzz8txtQDbUnFvfc4DjyNU5UtkbuhrvSrElMAP6yWEzWZ?=
 =?us-ascii?Q?7zFcvZ5PWUWXcN0DsHmGRt0Z77zVHcGU75RBor7kg2YNCaeyJqzIA76Xl+3W?=
 =?us-ascii?Q?5zZkeVczftn/+YnlhtTWBCvftURRLiZcAgbKE9Iwq4MzPxuxV/Dpn01hZ4XH?=
 =?us-ascii?Q?lZ/REQdgQbusRL0PwVlWVa/vBRZsb0nak3eIJnzMrA+g1xT4/uCtSQz4tLXg?=
 =?us-ascii?Q?F8E6GFohR+OTTWzK/G2/A88u5gGbug+kRHiCOs8oPsV4863m4w0UOvnuSkLQ?=
 =?us-ascii?Q?6x9Myb5OaKs48UxrRKSNMFvAqFoozD2kzukC2BtHUFZ5z5nsoQVuDlFqZSBl?=
 =?us-ascii?Q?VpgIYfaVsA8Zjgysp8aton7onmVcphl8l5KnoqVUwylL1Xzf1mhQb1KToR2I?=
 =?us-ascii?Q?5+84uqvt6oUF8RGtESOqM9OUzghOSdCyd68xUuqeZm23PUcSzeV4OSRomVrx?=
 =?us-ascii?Q?+JNfjX9/EEuNpPSsnlMg/2IlC84y3cMTfeF5QQ6d+5zV82L4VIuNqErRdp2p?=
 =?us-ascii?Q?WjhArMlLc60ORptQ6THsJoK2wYSZkm73zF9eVNsYahfGvYIJ+GknVOgJv8pn?=
 =?us-ascii?Q?5cl4WtL8QifJUlLL/iP+K64j5df7C8qoTG085OQeTUrKZ6cWpsqSMmbhWyJu?=
 =?us-ascii?Q?fSBqDzkfcbhFJ2rfnwaBlGuug/tX4c6P5e0Poi3PGv89tMxObiE/HFl5C7bw?=
 =?us-ascii?Q?eQFEg8E+NrVQG7fPFsx/dPPz6h0njK4paBxLuIZ3wj0dMaOZ+llfNy5/gNIW?=
 =?us-ascii?Q?qarmc8LNSLtiioEZMNFWdahix/1Hk79HLoOA0aoPfod+8WTMqgmMA/shyXGe?=
 =?us-ascii?Q?Rr78YP4NfDSQg/l3gmTgsPmuIur2ppgK?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(7416014)(376014)(82310400026)(1800799024)(36860700013);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Jul 2024 09:41:04.3370
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 74168020-336e-4913-9ae8-08dca256bf93
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DS3PEPF0000C37F.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH8PR12MB7375

Upcoming AMD uarch will support Bus Lock Detect, which functionally works
identical to Intel. Move split_lock and bus_lock specific code from
intel.c to a dedicated file so that it can be compiled and supported on
non-Intel platforms.

Signed-off-by: Ravi Bangoria <ravi.bangoria@amd.com>
---
 arch/x86/include/asm/cpu.h     |   4 +
 arch/x86/kernel/cpu/Makefile   |   1 +
 arch/x86/kernel/cpu/bus_lock.c | 406 +++++++++++++++++++++++++++++++++
 arch/x86/kernel/cpu/intel.c    | 406 ---------------------------------
 4 files changed, 411 insertions(+), 406 deletions(-)
 create mode 100644 arch/x86/kernel/cpu/bus_lock.c

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
index 000000000000..704e9241b964
--- /dev/null
+++ b/arch/x86/kernel/cpu/bus_lock.c
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


