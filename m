Return-Path: <kvm+bounces-34596-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id E0A1AA025F8
	for <lists+kvm@lfdr.de>; Mon,  6 Jan 2025 13:50:23 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id C25111644D3
	for <lists+kvm@lfdr.de>; Mon,  6 Jan 2025 12:50:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F3EBD1DF742;
	Mon,  6 Jan 2025 12:47:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="O/mlrA1m"
X-Original-To: kvm@vger.kernel.org
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2040.outbound.protection.outlook.com [40.107.237.40])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BE18F1DE2DC;
	Mon,  6 Jan 2025 12:47:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.237.40
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736167669; cv=fail; b=XTESLKsFCRf97RmNLOgVf7+e9wjQG/V48KfsiEKJ/2fkFsZj9Koh96iOsoUB1y2nsDDni/OFs3OarEXr17tgciVcAUqR+7lHF1EKtoXwpoMdTkqd9+NZGaa5mmxAkoJK6RurHxr/QyvZe2jzBrQfxAV6I+Np+jxQN8FMnE8fxMQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736167669; c=relaxed/simple;
	bh=wi7Uv4BEsuelueC0YmslEb5C445DaXbBz8R4gK4Aed8=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=mk3/p2dsJaQgT2rfO+vc+3oOh7Abyi/sxs5n6CnD7Io3OQ3RQ3ciX9BCio+634HP7rLlECmsOX7gMdaqADXK5MYotXcentIcnh/QVt91YABdttHHKnuglrPD7u8yXcMjZ0DdiydSZ9NhlUikwlYUumCWhAvmXTHBE6NJHVIy/Hw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=O/mlrA1m; arc=fail smtp.client-ip=40.107.237.40
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=q/HTV/N1vTnxdHIBxfY7d6dC5qk4Sw05aE011szzhalGcsnVkwCgfbKWnGZ2kjz440PXhOmlAE3+yylsW92IzWpYgJpwmy5oNM3qArSfHHS9Cq+baBKHTJ7YVXkprRPhtlmB++7LFph/yMSQs7bz2SI5x/vP6m3FtwwX2bt/6DWXO0tDKqm34O3nLsYItObXHy3p6BZbDQBRJ/rhl1manlQYC0Y3Dn9BArwRN56DalBmKjsVOHiO8RjQ3R0meYWV6hQoofi4otVIN4Ezp67D4tFaaR/NuRGAovaVSR7OBuRJvtNzLKlvK2rAghDkqPu9nHFGE9nw8gMCWLqjkSf3yg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=12bt6AUK1z28BMFXiBFUdsddjh3wX2+NzHdvwB8afJs=;
 b=B/JZml8ULsU6IJIadS8TXbVWNYWY5/bUGQ5H7NQdkMR7rDY3s1ABVlIsOJQUvomPWuofJtT4OW+SSoSmWGYwF8rDJdHE/bAU3lCxwzpxgN4DuIPGa41P0XKGLEDBJNkhIB4bm6BQvt0yOIqqSeGtC4zYr3/c6mUdmlt7MdADWl6XAnBO6bseluXQ4daUnkIqlBhLjUjzRQdwh44nL3fRXzSKKCTUDOEzJTLaqka3frLEeo8/7gQ7m+C2IfXEj0YhndTatKwS8ISBXWQiUVJKhWN3diWzpn0mLTnlEwvNfeQKxFue+8/7elx0WNWtoszONI3lgkwqNKc6qbkBAdKRzQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=12bt6AUK1z28BMFXiBFUdsddjh3wX2+NzHdvwB8afJs=;
 b=O/mlrA1mahwB3rNvwaWyjyFFyKYikK17YMKm8dsEhrID+cxau/RT9oowTOK5B4QwL45Fy6CDrvqjtLnx7kZg5/EamMrCBke+zVkUKb31WyMP/ImYf1n41ce1AsrAdoyFyjq2jzKfSOBB8YyGqPCXAR9WzNrhj7w+Ak+PhMkS7yI=
Received: from PH8PR07CA0008.namprd07.prod.outlook.com (2603:10b6:510:2cd::16)
 by DM4PR12MB6088.namprd12.prod.outlook.com (2603:10b6:8:af::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8314.17; Mon, 6 Jan
 2025 12:47:39 +0000
Received: from CY4PEPF0000EDD5.namprd03.prod.outlook.com
 (2603:10b6:510:2cd:cafe::40) by PH8PR07CA0008.outlook.office365.com
 (2603:10b6:510:2cd::16) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8314.17 via Frontend Transport; Mon,
 6 Jan 2025 12:47:39 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 CY4PEPF0000EDD5.mail.protection.outlook.com (10.167.241.201) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.8335.7 via Frontend Transport; Mon, 6 Jan 2025 12:47:38 +0000
Received: from gomati.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Mon, 6 Jan
 2025 06:47:34 -0600
From: Nikunj A Dadhania <nikunj@amd.com>
To: <linux-kernel@vger.kernel.org>, <thomas.lendacky@amd.com>, <bp@alien8.de>,
	<x86@kernel.org>
CC: <kvm@vger.kernel.org>, <mingo@redhat.com>, <tglx@linutronix.de>,
	<dave.hansen@linux.intel.com>, <pgonda@google.com>, <seanjc@google.com>,
	<pbonzini@redhat.com>, <nikunj@amd.com>, <francescolavra.fl@gmail.com>
Subject: [PATCH v16 10/13] x86/tsc: Switch Secure TSC guests away from kvm-clock
Date: Mon, 6 Jan 2025 18:16:30 +0530
Message-ID: <20250106124633.1418972-11-nikunj@amd.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20250106124633.1418972-1-nikunj@amd.com>
References: <20250106124633.1418972-1-nikunj@amd.com>
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
X-MS-TrafficTypeDiagnostic: CY4PEPF0000EDD5:EE_|DM4PR12MB6088:EE_
X-MS-Office365-Filtering-Correlation-Id: 72a3d367-80e7-499b-2cd3-08dd2e504d96
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|376014|7416014|36860700013|82310400026;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?rIy7rVGE9NgxRinEUExjIEdKkWLDIHZMWlkZyw9z45KD140WQqEWs4NbIOMt?=
 =?us-ascii?Q?jvGawa+Zd8nDVmmpO6zfT4+g1JLoWLUEs8rVC5ABa5ku5uSb4x8vhDK/0kO4?=
 =?us-ascii?Q?gL+nuJojG0xkXag+lLpwPFXjGABLbxcg4coWFw2pwFuUfQl1p5wJMu9OhS+r?=
 =?us-ascii?Q?Npp8GhXAwNxypJp+3RJ3Yu5eiw+3zeXGzkm/9gY6uBLEZCh7I7gvOMckZqnr?=
 =?us-ascii?Q?4imBf3aBXA/KNDhDwCgE0yxVBPXiEDHkIFiCvRo/O8i/ZA3dEVYpXSfFrKH3?=
 =?us-ascii?Q?n7CgFA+HeJrpZjYAE4rFxJHXnylGj/4Bj3kLMRSM+8OAG+3Ss1O6BI1qG1ro?=
 =?us-ascii?Q?k/uGasjEJcXAqR4CZxxbHFHiXREYCdstBmvXPWoUi4++2uS93b1jmvjEuM0b?=
 =?us-ascii?Q?KRefzTJOrwtHRJHCbIZxozEdWO+tnbTDkipq/LLkOYsTcznrRLE9F4wHeDXI?=
 =?us-ascii?Q?aJknqIBMBCnnPfXK6LV254uvq9p+kwhopIzorNrByKHUIVH/MsPs/2wlSww+?=
 =?us-ascii?Q?gXyZM+XcXyFa7njjlMCo8qhGJQPJV7A287u1VvOiRwJkanpOoIQej4PNWS6x?=
 =?us-ascii?Q?CRPddJB7RuC25PKHr0NcfaEbErtwuvT955zLktPNLNR2GlGgn2C1ec0NWu6/?=
 =?us-ascii?Q?tKNvWJDQ/KkuINn6ZMUdmUYdTQiWWCl1SNxdTwjPCskPt6iX0mrWsU722Ivy?=
 =?us-ascii?Q?Y+r1aigFDQn+7JAvYY9Sy/226ImGfp9/NV9+MWAk3gJGnW6jPq8Coujg0qIg?=
 =?us-ascii?Q?+LQo0BKZAv9bcVO14MpYNRr+aHvwemf0zt4INcmr6bH7MDLmcrnJ0WEU0wp9?=
 =?us-ascii?Q?0vdomWbnAyEOJtK299wNoawcSB6JkzL6D1PZPsb2UCPELuDgDLl/T/yzUj+B?=
 =?us-ascii?Q?GSWVRYD5n/1aJUZrokfo8BbPUdfhuopeVXhci8HozRohqJqW8bJz++zfrD/m?=
 =?us-ascii?Q?Lky47mRbBibW3q1V0woq9icZqBR8faQU+q8fPA2WkLApmpoUVpF1rlAF3vcZ?=
 =?us-ascii?Q?grFHIfcwvOy9Ig+BfXUPhB7XG6IVjgWIfp8Z5rFMwsAWxFJvC3jgJmhaNuUx?=
 =?us-ascii?Q?5HwGoZOcbrnahOajiWapEbf6+itH2KyPHhBKJiBReEGDuxv2Wb8aJoiQ9WXy?=
 =?us-ascii?Q?NtnPgFY4qnUrHn9XpQN7ptZD+UyeX6kUKGJEA8cd8J8pvOnz0T08sdi8YsxX?=
 =?us-ascii?Q?ZAcX8emQjZ5UPWOZ6o5UFzEE4HozRE1Vd32VLhz3Jo7MkIHMg9x2WBPD35Es?=
 =?us-ascii?Q?beFX9ecAQ85iOgkvKI/3NLuNYvJiaMDwmutgn+DynYKxcTfx6c58WdG/64F6?=
 =?us-ascii?Q?8Z+8LMBDw3CUpN9WkuPmX5CHMfpOADhsnHU56PG7/yDZHi+6XN5vvp66AWsi?=
 =?us-ascii?Q?D3Q9Yn72zASXHXEyAi64YrUTZvk7gHMMgpxvMyKy8C+GPSUDlwoYBIKQ8U0c?=
 =?us-ascii?Q?/BACJVsyVi27fj7/UzGd3n6hVI4/jhXd0S4yBWSQJgRfsIhhDOBElMvEU/1H?=
 =?us-ascii?Q?LgIYDwvUh14d00E=3D?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(1800799024)(376014)(7416014)(36860700013)(82310400026);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Jan 2025 12:47:38.8708
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 72a3d367-80e7-499b-2cd3-08dd2e504d96
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CY4PEPF0000EDD5.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB6088

Although the kernel switches over to a stable TSC clocksource instead of
kvm-clock, TSC frequency calibration still relies on the kvm-clock based
frequency calibration. This is due to kvmclock_init() unconditionally
updating the x86_platform's CPU and TSC callbacks.

For Secure TSC enabled guests, use the GUEST_TSC_FREQ MSR to discover the
TSC frequency instead of relying on kvm-clock based frequency calibration.
Override both CPU and TSC frequency calibration callbacks with
securetsc_get_tsc_khz(). Since the difference between CPU base and TSC
frequency does not apply in this case, the same callback is being used.

Additionally, warn users when kvm-clock is selected as the clocksource for
Secure TSC enabled guests. Users can change the clocksource to kvm-clock
using the sysfs interface while running on a Secure TSC enabled guest.
Switching to the hypervisor-controlled kvm-clock can lead to potential
security issues.

Taint the kernel and issue a warning to the user when the clocksource
switches to kvm-clock, ensuring they are aware of the change and its
implications.

Signed-off-by: Nikunj A Dadhania <nikunj@amd.com>
---
 arch/x86/include/asm/sev.h |  2 ++
 arch/x86/coco/sev/core.c   | 21 +++++++++++++++++++++
 arch/x86/kernel/kvmclock.c | 11 +++++++++++
 arch/x86/kernel/tsc.c      |  4 ++++
 4 files changed, 38 insertions(+)

diff --git a/arch/x86/include/asm/sev.h b/arch/x86/include/asm/sev.h
index bdcdaac4df1c..5d9685f92e5c 100644
--- a/arch/x86/include/asm/sev.h
+++ b/arch/x86/include/asm/sev.h
@@ -482,6 +482,7 @@ int snp_send_guest_request(struct snp_msg_desc *mdesc, struct snp_guest_req *req
 			   struct snp_guest_request_ioctl *rio);
 
 void __init snp_secure_tsc_prepare(void);
+void __init snp_secure_tsc_init(void);
 
 #else	/* !CONFIG_AMD_MEM_ENCRYPT */
 
@@ -524,6 +525,7 @@ static inline void snp_msg_free(struct snp_msg_desc *mdesc) { }
 static inline int snp_send_guest_request(struct snp_msg_desc *mdesc, struct snp_guest_req *req,
 					 struct snp_guest_request_ioctl *rio) { return -ENODEV; }
 static inline void __init snp_secure_tsc_prepare(void) { }
+static inline void __init snp_secure_tsc_init(void) { }
 
 #endif	/* CONFIG_AMD_MEM_ENCRYPT */
 
diff --git a/arch/x86/coco/sev/core.c b/arch/x86/coco/sev/core.c
index dbf4531c6271..9c971637e56b 100644
--- a/arch/x86/coco/sev/core.c
+++ b/arch/x86/coco/sev/core.c
@@ -103,6 +103,7 @@ static u64 secrets_pa __ro_after_init;
  */
 static u64 snp_tsc_scale __ro_after_init;
 static u64 snp_tsc_offset __ro_after_init;
+static u64 snp_tsc_freq_khz __ro_after_init;
 
 /* #VC handler runtime per-CPU data */
 struct sev_es_runtime_data {
@@ -3273,3 +3274,23 @@ void __init snp_secure_tsc_prepare(void)
 
 	pr_debug("SecureTSC enabled");
 }
+
+static unsigned long securetsc_get_tsc_khz(void)
+{
+	return snp_tsc_freq_khz;
+}
+
+void __init snp_secure_tsc_init(void)
+{
+	unsigned long long tsc_freq_mhz;
+
+	if (!cc_platform_has(CC_ATTR_GUEST_SNP_SECURE_TSC))
+		return;
+
+	setup_force_cpu_cap(X86_FEATURE_TSC_KNOWN_FREQ);
+	rdmsrl(MSR_AMD64_GUEST_TSC_FREQ, tsc_freq_mhz);
+	snp_tsc_freq_khz = (unsigned long)(tsc_freq_mhz * 1000);
+
+	x86_platform.calibrate_cpu = securetsc_get_tsc_khz;
+	x86_platform.calibrate_tsc = securetsc_get_tsc_khz;
+}
diff --git a/arch/x86/kernel/kvmclock.c b/arch/x86/kernel/kvmclock.c
index 5b2c15214a6b..960260a8d884 100644
--- a/arch/x86/kernel/kvmclock.c
+++ b/arch/x86/kernel/kvmclock.c
@@ -21,6 +21,7 @@
 #include <asm/hypervisor.h>
 #include <asm/x86_init.h>
 #include <asm/kvmclock.h>
+#include <asm/sev.h>
 
 static int kvmclock __initdata = 1;
 static int kvmclock_vsyscall __initdata = 1;
@@ -150,6 +151,16 @@ bool kvm_check_and_clear_guest_paused(void)
 
 static int kvm_cs_enable(struct clocksource *cs)
 {
+	/*
+	 * TSC clocksource should be used for a guest with Secure TSC enabled,
+	 * taint the kernel and warn when the user changes the clocksource to
+	 * kvm-clock.
+	 */
+	if (cc_platform_has(CC_ATTR_GUEST_SNP_SECURE_TSC)) {
+		add_taint(TAINT_WARN, LOCKDEP_STILL_OK);
+		WARN_ONCE(1, "For Secure TSC guest, changing the clocksource is not allowed!\n");
+	}
+
 	vclocks_set_used(VDSO_CLOCKMODE_PVCLOCK);
 	return 0;
 }
diff --git a/arch/x86/kernel/tsc.c b/arch/x86/kernel/tsc.c
index a85594644e13..34dec0b72ea8 100644
--- a/arch/x86/kernel/tsc.c
+++ b/arch/x86/kernel/tsc.c
@@ -31,6 +31,7 @@
 #include <asm/i8259.h>
 #include <asm/topology.h>
 #include <asm/uv/uv.h>
+#include <asm/sev.h>
 
 unsigned int __read_mostly cpu_khz;	/* TSC clocks / usec, not used here */
 EXPORT_SYMBOL(cpu_khz);
@@ -1514,6 +1515,9 @@ void __init tsc_early_init(void)
 	/* Don't change UV TSC multi-chassis synchronization */
 	if (is_early_uv_system())
 		return;
+
+	snp_secure_tsc_init();
+
 	if (!determine_cpu_tsc_frequencies(true))
 		return;
 	tsc_enable_sched_clock();
-- 
2.34.1


