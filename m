Return-Path: <kvm+bounces-28216-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 6631399657C
	for <lists+kvm@lfdr.de>; Wed,  9 Oct 2024 11:34:50 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 26A8828214E
	for <lists+kvm@lfdr.de>; Wed,  9 Oct 2024 09:34:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C1B76194080;
	Wed,  9 Oct 2024 09:30:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="OVkHUS35"
X-Original-To: kvm@vger.kernel.org
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2054.outbound.protection.outlook.com [40.107.243.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 82300192D97;
	Wed,  9 Oct 2024 09:30:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.243.54
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728466217; cv=fail; b=WZ8K1syyqbMS9fQMzP2QaEKxJxYADogiu1XSm5YxXgAeB84KRsnHHaz/WphE19jI9akPcH1A4HYW9IXbbFIeHxUcrBVR0Nnb7ELD1BwdA2ei+s6IBrFAtOI//XrJUhqRpsfyz7rHOj3ieHApTV/xo9igb7Nvwl8AeuR+xG8YRMY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728466217; c=relaxed/simple;
	bh=Ay6VfP83eIo7iEaEyZIBOZKOm5hmC6I+HBlHA3WWths=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=OK9nJGIv78ma9rybybfc55xnKDjDJt9gY2e0CmCeMFAGdRUSLw2K4Up+wpCeFMkx0/oc+2O55g2fp2jm5vjpBjCFCXRPBDzLxSebBQ5moa1m6LOe/pkQJ6QAk4RDUa+UX+GFMhyePrarkt/rafNRo7SF5BtyWgo5avM3W4I1tkY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=OVkHUS35; arc=fail smtp.client-ip=40.107.243.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=pgRacWySNWyYxu7RuRAD5kjayFSim3XLGKLd2scCvH92ooz88RrrTAfGaXrFkG958HtWHcJpm0FqN16LjScW4SyD7S6MSTctQFho6eSGZ1rK5mh+F/YjZ0BJymbXRDUcMw7afej7g56OBtLJ3Y7QA9Qt5PZxDFU9bMnBk8LU663iMplb9UOXLvslwLM5GNef3RmJj2Rh/ZM4pMCdpRsBQ1HJN8R1wxCJJuWJl5vBvSr3oFEiJyd3y0BD9yomH1aJtxRLtkiJjdHwHWv47Ycn4OzE4Q0KXwraztGf6r6VQFd4YVhdp46l6r+5+ZOFMmPuv9XUkAZvayEdNY1TEZ9d/g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=npqZ0UxLwNdAK/61C0ThIVdI3pLl974pEbXbWWz6pfs=;
 b=GqIYCoD0Bh18i6jCNSjAfkASvj0TFl3gXRIT0gG7s+VqNuzoCypkOQ16EAbSjSE4eBR4lQTHV5QW981WYcnA2OoUy3MLVZuC9gjhjQ9QpuaxXfhO1laU17rtAzBOhKbzFsr6OrWa5Estox6pfNh4L6g94nw8Lnrv8pR3nxiDkHbqe9dz5BHjHKNC82SqXf0EALd6xSsgqsKFg9JbCRJVKBFLdcciXqmMlRtC0Zrhg2f5+GQ2VpIfzrI/rkvgapuk4pBtSqL4/KcS/8vD4p57iGh+jjCjq+OqP/pojkV83ZqqthXORPhEYN96zEM5vU5C9JEiAUe89e80SAq9tL4pXQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=npqZ0UxLwNdAK/61C0ThIVdI3pLl974pEbXbWWz6pfs=;
 b=OVkHUS35+Nt/KiASlCLJY/s+FswvKc57U8tE/vwwxC+m9EATFtiES4XEDef8SDnOhg82mEMi57Gkr7te7jEbskxw7UtzCdx2J27T1sBRT40vim/yzVdtjdu6TZayV74aLj7s9fsNOWzOiGbz2l3dXKza6KdJyIUaq8iRbE+wrvw=
Received: from MN2PR17CA0035.namprd17.prod.outlook.com (2603:10b6:208:15e::48)
 by SJ2PR12MB7962.namprd12.prod.outlook.com (2603:10b6:a03:4c2::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8026.22; Wed, 9 Oct
 2024 09:30:11 +0000
Received: from BL02EPF00021F69.namprd02.prod.outlook.com
 (2603:10b6:208:15e:cafe::e5) by MN2PR17CA0035.outlook.office365.com
 (2603:10b6:208:15e::48) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8048.17 via Frontend
 Transport; Wed, 9 Oct 2024 09:30:11 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 BL02EPF00021F69.mail.protection.outlook.com (10.167.249.5) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.8048.13 via Frontend Transport; Wed, 9 Oct 2024 09:30:11 +0000
Received: from gomati.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Wed, 9 Oct
 2024 04:30:07 -0500
From: Nikunj A Dadhania <nikunj@amd.com>
To: <linux-kernel@vger.kernel.org>, <thomas.lendacky@amd.com>, <bp@alien8.de>,
	<x86@kernel.org>, <kvm@vger.kernel.org>
CC: <mingo@redhat.com>, <tglx@linutronix.de>, <dave.hansen@linux.intel.com>,
	<pgonda@google.com>, <seanjc@google.com>, <pbonzini@redhat.com>,
	<nikunj@amd.com>
Subject: [PATCH v12 16/19] x86/kvmclock: Use clock source callback to update kvm sched clock
Date: Wed, 9 Oct 2024 14:58:47 +0530
Message-ID: <20241009092850.197575-17-nikunj@amd.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20241009092850.197575-1-nikunj@amd.com>
References: <20241009092850.197575-1-nikunj@amd.com>
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
X-MS-TrafficTypeDiagnostic: BL02EPF00021F69:EE_|SJ2PR12MB7962:EE_
X-MS-Office365-Filtering-Correlation-Id: 5f67c8f8-7abf-463c-5a5a-08dce844f921
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|1800799024|376014|36860700013|82310400026;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?X/oB4xEYFEEzNYz9k5pG3KNdLSadD5+r4QlYybuo/wYMAzN/rjFGjFVVYd1b?=
 =?us-ascii?Q?DeKGL5At41ANrVLl1CET2pNlhTRLs31IMiUIfs0F+yqcUvehAIzZgTwKAxBG?=
 =?us-ascii?Q?4Bmgq8k8P01HYYrbv4XU5sEm+YGkJCYpduK16NQQWn+liilF8ph0z3J3or9C?=
 =?us-ascii?Q?cz3j7KifLSLD1IzkpE5jQhfOiQMQcY6GO/beesAaNpqcz1J5I8fHiNtg96+/?=
 =?us-ascii?Q?N5TpY6gQbhnO+iApFftAOih14CuG+yFu+vukdCjeuqmCSCE+OALqEW7kzmmv?=
 =?us-ascii?Q?+tUWWYclLk2tMcmR4DYopcb2rNKzpeThZp5zUkmTBUX+fOH3MmlnenkfPm/V?=
 =?us-ascii?Q?Zuiw2Gy5/ZCUHA7wLXvO+xo5mZV4ZrUe3LjJaPstpdLc9zK9U+7R2Z4oKxGA?=
 =?us-ascii?Q?vqu0dJTNOOKfmbbVBmYIXB8qMK3y0SqUlt1CqgPyIICtmmmSJKYopFdbFqgc?=
 =?us-ascii?Q?zxXMggDi7o4p2M+WCqvjTjcTqbjBPRl9k8O4ORGBOSfcxudMDw7rWtNChAds?=
 =?us-ascii?Q?FhzBV4RxFNhtgKGfqpR4LlNezS4e5Q4/ScAnb7Rkcc1fdGp4M88cFQs4dEKt?=
 =?us-ascii?Q?yidbyhvAhFpyahIceOvuaFC1bmiUJYa1IGzypXI02fnBvNXzi6rdQL3p46yY?=
 =?us-ascii?Q?doaNMlTKP6b26ReF62HaYMvkYCZnV0mPSD0DhkOnfKnEkkOZsIasbNhQw60p?=
 =?us-ascii?Q?MZbWIG4SasrKxPqY17R5BhReEWM+155RzHvJdjYkBHrdg0slGPN1TAQabLp0?=
 =?us-ascii?Q?YSlZuJ0XGGCKx7vVR1o6KXt1XDT4eYl1LxdPUXV7TR/pnReREJjkI7Ucq+mR?=
 =?us-ascii?Q?ba8WyxH0Ta7eR1GKd/1N+FvnyUJC9BzqMLjEnO5JL6MoTOq5eaamEQMT0a1a?=
 =?us-ascii?Q?tSNTE8tZ/K23gbQXHjhTgIVH0TAH2Yw5QHMqNMDbTjvASQXV/XhuBCub16Yz?=
 =?us-ascii?Q?IGZvdxcpTUuj/Rf3tXW8g+galEgn8uAjg8TUYtHE6VyAAqtYsWFO+hF4ZptD?=
 =?us-ascii?Q?Yfz+RC0WDlPmRk4Ovtorp+9DHBdpBpy8BPuNKgnLTLyQoTuQXf4LxFl9sj5R?=
 =?us-ascii?Q?Q+4cmlIqao3J6w8+pgjGt3+ngofA626s4P14RUcWHQyrqQ18QgfQC3dX5V3x?=
 =?us-ascii?Q?uFEOQE7aJNWl/TQAVtEWE2nU9h+Z3eJwlIycmip4YCLVcYonNWRuPpRAaKZS?=
 =?us-ascii?Q?vg1yZbJEBhI1C4DJuX05OmB6z/KrucJZFJhdhtRd0INtz/cJWy34HivB4eZF?=
 =?us-ascii?Q?SZiLtu8sYWr0WrR1hbjwzKqnxJfErL6xT1SRKsKPAtToRuCG57+Yq++3QYLz?=
 =?us-ascii?Q?0avokSzzQ7ZQ7A6zYtF6hKBtUOs1TyvCFStucTIP1IZ02zQneCmQETOCw9VW?=
 =?us-ascii?Q?NjoStuWH9S95uDSwciTCqpp9yTXC?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(7416014)(1800799024)(376014)(36860700013)(82310400026);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Oct 2024 09:30:11.4275
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 5f67c8f8-7abf-463c-5a5a-08dce844f921
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BL02EPF00021F69.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ2PR12MB7962

Although the kernel switches over to stable TSC clocksource instead of
kvmclock, the scheduler still keeps on using kvmclock as the sched clock.
This is due to kvm_sched_clock_init() updating the pv_sched_clock()
unconditionally.

Use the clock source enable/disable callbacks to initialize
kvm_sched_clock_init() and update the pv_sched_clock().

As the clock selection happens in the stop machine context, schedule
delayed work to update the static_call()

Signed-off-by: Nikunj A Dadhania <nikunj@amd.com>
---
 arch/x86/kernel/kvmclock.c | 34 +++++++++++++++++++++++++++++-----
 1 file changed, 29 insertions(+), 5 deletions(-)

diff --git a/arch/x86/kernel/kvmclock.c b/arch/x86/kernel/kvmclock.c
index 5b2c15214a6b..5cd3717e103b 100644
--- a/arch/x86/kernel/kvmclock.c
+++ b/arch/x86/kernel/kvmclock.c
@@ -21,6 +21,7 @@
 #include <asm/hypervisor.h>
 #include <asm/x86_init.h>
 #include <asm/kvmclock.h>
+#include <asm/timer.h>
 
 static int kvmclock __initdata = 1;
 static int kvmclock_vsyscall __initdata = 1;
@@ -148,12 +149,39 @@ bool kvm_check_and_clear_guest_paused(void)
 	return ret;
 }
 
+static u64 (*old_pv_sched_clock)(void);
+
+static void enable_kvm_sc_work(struct work_struct *work)
+{
+	u8 flags;
+
+	old_pv_sched_clock = static_call_query(pv_sched_clock);
+	flags = pvclock_read_flags(&hv_clock_boot[0].pvti);
+	kvm_sched_clock_init(flags & PVCLOCK_TSC_STABLE_BIT);
+}
+
+static DECLARE_DELAYED_WORK(enable_kvm_sc, enable_kvm_sc_work);
+
+static void disable_kvm_sc_work(struct work_struct *work)
+{
+	if (old_pv_sched_clock)
+		paravirt_set_sched_clock(old_pv_sched_clock);
+}
+static DECLARE_DELAYED_WORK(disable_kvm_sc, disable_kvm_sc_work);
+
 static int kvm_cs_enable(struct clocksource *cs)
 {
 	vclocks_set_used(VDSO_CLOCKMODE_PVCLOCK);
+	schedule_delayed_work(&enable_kvm_sc, 0);
+
 	return 0;
 }
 
+static void kvm_cs_disable(struct clocksource *cs)
+{
+	schedule_delayed_work(&disable_kvm_sc, 0);
+}
+
 static struct clocksource kvm_clock = {
 	.name	= "kvm-clock",
 	.read	= kvm_clock_get_cycles,
@@ -162,6 +190,7 @@ static struct clocksource kvm_clock = {
 	.flags	= CLOCK_SOURCE_IS_CONTINUOUS,
 	.id     = CSID_X86_KVM_CLK,
 	.enable	= kvm_cs_enable,
+	.disable = kvm_cs_disable,
 };
 
 static void kvm_register_clock(char *txt)
@@ -287,8 +316,6 @@ static int kvmclock_setup_percpu(unsigned int cpu)
 
 void __init kvmclock_init(void)
 {
-	u8 flags;
-
 	if (!kvm_para_available() || !kvmclock)
 		return;
 
@@ -317,9 +344,6 @@ void __init kvmclock_init(void)
 	if (kvm_para_has_feature(KVM_FEATURE_CLOCKSOURCE_STABLE_BIT))
 		pvclock_set_flags(PVCLOCK_TSC_STABLE_BIT);
 
-	flags = pvclock_read_flags(&hv_clock_boot[0].pvti);
-	kvm_sched_clock_init(flags & PVCLOCK_TSC_STABLE_BIT);
-
 	x86_platform.calibrate_tsc = kvm_get_tsc_khz;
 	x86_platform.calibrate_cpu = kvm_get_tsc_khz;
 	x86_platform.get_wallclock = kvm_get_wallclock;
-- 
2.34.1


