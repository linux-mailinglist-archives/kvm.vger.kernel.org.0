Return-Path: <kvm+bounces-23596-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 30BC894B6BC
	for <lists+kvm@lfdr.de>; Thu,  8 Aug 2024 08:31:31 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 91171B23BE3
	for <lists+kvm@lfdr.de>; Thu,  8 Aug 2024 06:31:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 79DE3187871;
	Thu,  8 Aug 2024 06:31:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="hZHCfArs"
X-Original-To: kvm@vger.kernel.org
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2060.outbound.protection.outlook.com [40.107.244.60])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5005413210D;
	Thu,  8 Aug 2024 06:31:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.244.60
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723098669; cv=fail; b=ig3I/b3R0zjEU+dmtoChhaGxfImGOz4l19+xS4BQSnA2p1NxbanhHhWumKsuNwWYSz0cZBYCbEbaC5acJO1FW5n9vZ/9WGE1F/BHFQJ3HTu5kml8oBvCGPLnbJJ7rYnJMiCe45A3+v8TYfeD/x8s3udaTmlf810QO49BGbk0ZQU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723098669; c=relaxed/simple;
	bh=x1HiO08wUJnb9GD/GvSbBUdiMG0ex7Y4R3OAzERsB2c=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=lTBN6P2kjuTfvjxqeq6P2a19KNZSFjdVl0HcPOqQF2NBdYFZjEuwJxNieNHYszYDN1lOtLA8YkT65pZNNv9kcOS+nWK0msTI7KsCONUKj2WbNcpzvEb4BQ+NP0ZXrxzwLzntI3fZAOwc2MiQI0GT2EThe00mGUqsD4BCzpGne+E=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=hZHCfArs; arc=fail smtp.client-ip=40.107.244.60
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=qh3oMSI0cFvJOevppV0WD842EBER54p0UKfMfBmbe0tMXSCYWzltyJ9biCQd4guz9UDSXtppVuHtArNzV3LRSuD/uDxMne9Olan30P1IHvv5dJI3QXtYMybGmhj6KEXtODAs5n2CZr+DnY8Qu/dGYeBOtttQAbHUOGAkFGWshlSgWm1nB3Tu+0lP+amzlei/OqOXADndhhDAW1SZOhd/FFfDjhGDGyjtrjZFX3q46TTapdjQWe8WtA6voDdLg991Uz7Ge8TXDrRJOwyC+n9AbPDtPb9XrMf1FSZy6dIxnd4ZRtYDdW9FvjCxAUmlWKeKmaLEWVJqNXapYxhNVRSPHg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=yY9HCOikVtuD0ovx51yHFNpS/Tt4XgmRp4q5xAi6BIA=;
 b=i4RArC1CTbKgSsyaEtKUVyS7sdvTpovRkLJ/D7LtYAaSDXgALvPrAJCrwnmCfAVPp10mGyHIluoXqNm4LvoCtT7pZyV+tjeLybgvDuaBdmZJaEsNsedWZW4E92nT2tPzsy3/PYJz5lNKpQ38cIQbm6JFxa4guuMJa+CjPNp35sX8tF1vG1bV3YA62lHYV08ADLhFEZROslvOQ8upqIEqbgOZiH4YDpsCTvMlztiGB8vC2j7cJULqbB7EM5ttm8bW6guOUNCht1Yd2S18aXPo5Y9R5qFbOMZm83epwftzoAf0t8GS/MYPC6l/0Uy9l/JlVYPiH5mZ4HhsDcnC6O58JA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=linutronix.de smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=yY9HCOikVtuD0ovx51yHFNpS/Tt4XgmRp4q5xAi6BIA=;
 b=hZHCfArsj/E08bwHbWhPhe2G7R1LKKKIr/PUz7KQazPJdQrhaoXGonMncMfpQNhhezULR+NmtqzSxc/tS5ZBur+LDH3rQJp8Wvyl4WXnuJN4hYNN1xrsZLKN/WT+HVD8YiQFZw4j9fe2TfpRBLf0/z2UB/kcmlwQ5nK3V3MlCWQ=
Received: from BN9PR03CA0496.namprd03.prod.outlook.com (2603:10b6:408:130::21)
 by SJ1PR12MB6316.namprd12.prod.outlook.com (2603:10b6:a03:455::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7828.26; Thu, 8 Aug
 2024 06:31:03 +0000
Received: from BN2PEPF0000449D.namprd02.prod.outlook.com
 (2603:10b6:408:130:cafe::5d) by BN9PR03CA0496.outlook.office365.com
 (2603:10b6:408:130::21) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7828.29 via Frontend
 Transport; Thu, 8 Aug 2024 06:31:03 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 BN2PEPF0000449D.mail.protection.outlook.com (10.167.243.148) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.7849.8 via Frontend Transport; Thu, 8 Aug 2024 06:31:03 +0000
Received: from BLR-L-RBANGORI.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Thu, 8 Aug
 2024 01:30:52 -0500
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
Subject: [PATCH v4 1/4] x86/split_lock: Move Split and Bus lock code to a dedicated file
Date: Thu, 8 Aug 2024 06:29:34 +0000
Message-ID: <20240808062937.1149-2-ravi.bangoria@amd.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240808062937.1149-1-ravi.bangoria@amd.com>
References: <20240808062937.1149-1-ravi.bangoria@amd.com>
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
X-MS-TrafficTypeDiagnostic: BN2PEPF0000449D:EE_|SJ1PR12MB6316:EE_
X-MS-Office365-Filtering-Correlation-Id: 18f39ca8-b3a2-4b30-86d9-08dcb773acfe
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|1800799024|376014|36860700013|82310400026;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?6sxYhBtzN0GPKdEIbOjdWnf8yxQu9Y22M+BM8xTW2Wm806guTSGZ0avH8f92?=
 =?us-ascii?Q?8IufNbbnM4t1o+kBnYRoRQlJSaeiUW6ZQ4unOafOW5XnquLMFiD/WYla3j/J?=
 =?us-ascii?Q?ZkenBmWdlbdU7X1lstyHNewW2peQdkmgRQkli8mMCUmIV7Lsp8qknm41i9J1?=
 =?us-ascii?Q?ZCWKN7esEiSt1IfJ3P1P873HznuOMTM2XyPC8MJVJV8TDgk+kvQkhWs9UU0F?=
 =?us-ascii?Q?w3YQWvUnK84svoe68GY+Nlhv5LG82a5qpFJF+h1ITxkoWeBGDlAKc+tfCfe9?=
 =?us-ascii?Q?3S4KqJlgkh/p2iQqgn38q/eH0xJ9f0zcqC/CaYoPEUpCwOvABFkbPknhivKD?=
 =?us-ascii?Q?zf2oLDkmYcoRKiBG5xHPa+V8WG6zqQGjyk/mDEthRwnqT5RCcp/qQmPWzIJG?=
 =?us-ascii?Q?7SGQaSQgctxKXd3T0BLChfTdA7OQxzy17wHb9MlwT42wpHyrvo5x9BAg3/oW?=
 =?us-ascii?Q?VSCIgeH8QwNtrcvR0dBkR6C/GK9CUA7Vf9igo+wuaTDoIgUFWxBoW/W/IzV7?=
 =?us-ascii?Q?z8b8Cwb8F6jSUWV8/j5shRWbEL8Z4THzz2P0ilEZvGq26+SRuu2tLXzZgQa9?=
 =?us-ascii?Q?BkM1wPJ1GtH5dR77+STMBH/67ad0HbDY1LL/5MXblS6gdLjgeh3Gs6a2HRty?=
 =?us-ascii?Q?VVxQEHcj3O/JHAU8V2ZtMs8nXTcEWx0NaTbHwjB8YoAytYlJMTTV6Q9lSOx8?=
 =?us-ascii?Q?MJo5r4bKmSncXjzSrMVvX6kPCXnN5Kfo1MdFtGLzd0nYdPVH4MeoM+fvEILI?=
 =?us-ascii?Q?/cBO1pYZKztVFFZf1w7wNFbJbq+T1K/yZkO3ZSXClfe+bR+bYfDUT9Qp4ELQ?=
 =?us-ascii?Q?l+5TTGnPNu2sQk8qwX7zOdi3Lbv7gAAu+nmOZmL9vCnOnj2vulusBLQInjy3?=
 =?us-ascii?Q?has+l4RtZp1P5zHytsmDWae1tz7/ZIH485P7K6NeJ3X2tdeC4zc/T7kGu3Dh?=
 =?us-ascii?Q?/D6H1QyvhOmvIihAa3Q8ItVwQ1aeRdCKNvvw+EsgucVyhZkFv+EYDVwc3wBZ?=
 =?us-ascii?Q?6WryiR9b/ofdwMC8jbIRpTYdJN2RlwkJv0c5MaeUz/GNzJ7hY6lNGOiXjyrk?=
 =?us-ascii?Q?f6kK0yfwTmNd8Cr8wrz68t8uWDH8SaSNR6xfECJ0uAoTg1h1buM4jrtsZ4E2?=
 =?us-ascii?Q?vK2okKe29NKUdTMLqGMh1mY+kqMzWIln80XmbyA6QE1fHHK3VLOrOi9XxCKg?=
 =?us-ascii?Q?CJbX46BqGGq1JPyBr38GarKY70jcDRX6ERg6UH1RPIiETK5DbNNQGMXM927V?=
 =?us-ascii?Q?aGBQL4xUGlMh2od0WpSO0n1j9snIfQc+nfXw61aIPOnT9So6hhePECRBNJpL?=
 =?us-ascii?Q?ZNlCnBcy6RWuSGXTOA8iYf6T24oP5Z1+Dl1sTTjAgaUQR279L9I3eRMgi1tX?=
 =?us-ascii?Q?K5AipLYxJQRuzYT1+fFlB84n5rr716KB5P+SFHRFtsiA5HJJJ1r0wdGZ+irg?=
 =?us-ascii?Q?eky0KhC9NNS+RAKIAHh93kESIriwoFYh?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(7416014)(1800799024)(376014)(36860700013)(82310400026);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Aug 2024 06:31:03.0470
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 18f39ca8-b3a2-4b30-86d9-08dcb773acfe
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BN2PEPF0000449D.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ1PR12MB6316

Bus Lock Detect functionality on AMD platforms works identical to Intel.
Move split_lock and bus_lock specific code from intel.c to a dedicated
file so that it can be compiled and supported on non-Intel platforms.
Also, introduce CONFIG_X86_BUS_LOCK_DETECT, make it dependent on
CONFIG_CPU_SUP_INTEL and add compilation dependency of new bus_lock.c
file on CONFIG_X86_BUS_LOCK_DETECT.

Signed-off-by: Ravi Bangoria <ravi.bangoria@amd.com>
Reviewed-by: Tom Lendacky <thomas.lendacky@amd.com>
---
 arch/x86/Kconfig               |   8 +
 arch/x86/include/asm/cpu.h     |  11 +-
 arch/x86/kernel/cpu/Makefile   |   2 +
 arch/x86/kernel/cpu/bus_lock.c | 406 +++++++++++++++++++++++++++++++++
 arch/x86/kernel/cpu/intel.c    | 406 ---------------------------------
 include/linux/sched.h          |   2 +-
 kernel/fork.c                  |   2 +-
 7 files changed, 427 insertions(+), 410 deletions(-)
 create mode 100644 arch/x86/kernel/cpu/bus_lock.c

diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index 02775a61b557..db2aad850a8f 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -2427,6 +2427,14 @@ config CFI_AUTO_DEFAULT
 
 source "kernel/livepatch/Kconfig"
 
+config X86_BUS_LOCK_DETECT
+	bool "Split Lock Detect and Bus Lock Detect support"
+	depends on CPU_SUP_INTEL
+	default y
+	help
+	  Enable Split Lock Detect and Bus Lock Detect functionalities.
+	  See <file:Documentation/arch/x86/buslock.rst> for more information.
+
 endmenu
 
 config CC_HAS_NAMED_AS
diff --git a/arch/x86/include/asm/cpu.h b/arch/x86/include/asm/cpu.h
index aa30fd8cad7f..86cf7952ee86 100644
--- a/arch/x86/include/asm/cpu.h
+++ b/arch/x86/include/asm/cpu.h
@@ -26,12 +26,13 @@ int mwait_usable(const struct cpuinfo_x86 *);
 unsigned int x86_family(unsigned int sig);
 unsigned int x86_model(unsigned int sig);
 unsigned int x86_stepping(unsigned int sig);
-#ifdef CONFIG_CPU_SUP_INTEL
+#ifdef CONFIG_X86_BUS_LOCK_DETECT
 extern void __init sld_setup(struct cpuinfo_x86 *c);
 extern bool handle_user_split_lock(struct pt_regs *regs, long error_code);
 extern bool handle_guest_split_lock(unsigned long ip);
 extern void handle_bus_lock(struct pt_regs *regs);
-u8 get_this_hybrid_cpu_type(void);
+void split_lock_init(void);
+void bus_lock_init(void);
 #else
 static inline void __init sld_setup(struct cpuinfo_x86 *c) {}
 static inline bool handle_user_split_lock(struct pt_regs *regs, long error_code)
@@ -45,7 +46,13 @@ static inline bool handle_guest_split_lock(unsigned long ip)
 }
 
 static inline void handle_bus_lock(struct pt_regs *regs) {}
+static inline void split_lock_init(void) {}
+static inline void bus_lock_init(void) {}
+#endif
 
+#ifdef CONFIG_CPU_SUP_INTEL
+u8 get_this_hybrid_cpu_type(void);
+#else
 static inline u8 get_this_hybrid_cpu_type(void)
 {
 	return 0;
diff --git a/arch/x86/kernel/cpu/Makefile b/arch/x86/kernel/cpu/Makefile
index 5857a0f5d514..4efdf5c2efc8 100644
--- a/arch/x86/kernel/cpu/Makefile
+++ b/arch/x86/kernel/cpu/Makefile
@@ -59,6 +59,8 @@ obj-$(CONFIG_ACRN_GUEST)		+= acrn.o
 
 obj-$(CONFIG_DEBUG_FS)			+= debugfs.o
 
+obj-$(CONFIG_X86_BUS_LOCK_DETECT)	+= bus_lock.o
+
 quiet_cmd_mkcapflags = MKCAP   $@
       cmd_mkcapflags = $(CONFIG_SHELL) $(src)/mkcapflags.sh $@ $^
 
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
diff --git a/include/linux/sched.h b/include/linux/sched.h
index d4cc144f72a3..2b16e5cfeb36 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -991,7 +991,7 @@ struct task_struct {
 #ifdef CONFIG_ARCH_HAS_CPU_PASID
 	unsigned			pasid_activated:1;
 #endif
-#ifdef	CONFIG_CPU_SUP_INTEL
+#ifdef CONFIG_X86_BUS_LOCK_DETECT
 	unsigned			reported_split_lock:1;
 #endif
 #ifdef CONFIG_TASK_DELAY_ACCT
diff --git a/kernel/fork.c b/kernel/fork.c
index c1b343cba560..0b71fc9fa750 100644
--- a/kernel/fork.c
+++ b/kernel/fork.c
@@ -1182,7 +1182,7 @@ static struct task_struct *dup_task_struct(struct task_struct *orig, int node)
 	tsk->active_memcg = NULL;
 #endif
 
-#ifdef CONFIG_CPU_SUP_INTEL
+#ifdef CONFIG_X86_BUS_LOCK_DETECT
 	tsk->reported_split_lock = 0;
 #endif
 
-- 
2.34.1


