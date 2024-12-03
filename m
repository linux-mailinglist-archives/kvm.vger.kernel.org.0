Return-Path: <kvm+bounces-32909-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id A8ED59E16A0
	for <lists+kvm@lfdr.de>; Tue,  3 Dec 2024 10:04:53 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 69AC62884FE
	for <lists+kvm@lfdr.de>; Tue,  3 Dec 2024 09:04:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CAF391E1337;
	Tue,  3 Dec 2024 09:01:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="x2+TXyV1"
X-Original-To: kvm@vger.kernel.org
Received: from NAM04-DM6-obe.outbound.protection.outlook.com (mail-dm6nam04on2085.outbound.protection.outlook.com [40.107.102.85])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7349B1DE3B9;
	Tue,  3 Dec 2024 09:01:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.102.85
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733216515; cv=fail; b=Yl37pZYFWug6ZMQyBJJDCZk5dCnjyMf0vlKfXGsaUFQ5mN0HCU29yeixksNneGduFs/FYJeQMMSKdfpEvzqneIa/wsdzi0B8WIs63L9Kd07gXF+mNxcnge1t3fwxAVXZTMSUY16RsHQ8LanxYeq7WFQqARApXI6Rt5fFn2mlsF0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733216515; c=relaxed/simple;
	bh=Tz6CZU9AlSBuu4PVH1vfwh24LbRJxkEZIvcaSBZcDkA=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=TKX/CP9aqZ+zz0R5FL6g75aGn2D0WIdcwQBzA7PYnaUdNoVsH1crZmE+XRGOTeeFNeqMkCbD1k94Vh1HvXTtahH0EoH/Ylro6vE7apUWaxh+AW3rHyGRLttTpmgPGAWJ7CkG7a/+A9dzIJlO8VetTkShCDUXfYLqJsLEpWzh6O0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=x2+TXyV1; arc=fail smtp.client-ip=40.107.102.85
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=BDBKZpxazekaGrZYrVHHuvvdmSFVZ0llhJnA9LmV8Z00bGpbjcKuqCJVXZhwcd6Wg+BGqq0myGu+zZk0pD3z7PYytZmVw8N8We15uM8Udl0nNZEe6GHvQa55kCVfxPfVWQthBAHFQxOUKepSbSlr4bIF6bAdwuVDqhFgDzJ9IiXihaq5KVJCYbQRw5VtluCDW1WFFj8YiURvY4/KqYdmeoaIDTzyafQDqls1nBxIXwvOokmtfTa40nWPu8VbfVwgv4qv9b7uyJ0YmpM29iHZvRsLZNhZL4y8Ois68LejSvG3LcuTLolFyrGzizVDmQtFM3roD76l8S19RIDHymJUyw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ANGx2jD0891ExjocqhNzetd//WRjNa2RbPQ36Hour8Q=;
 b=MrF/Br3Z2Cv/hdSJCbPAvIhNPjwJw/BO901CMK9tgHNBv59hwoFbYGdrMDoP21qypyqLieJkjDhpFdG5nV++pZEbXA6NlxKZD1tCWl6fTyDUsqDTxJZIeojXZmtT2QW3yoSgi83/KevA2AdB/QKAPBvTJeTBlz77sUjBIX6MmbTcNAUBfsfV9htl1bM6WGPRM6ie24b+/XNifY41SwhGRSV24e6mQlEnVGdBj3FIfrieqfObC5MZxG6BtuPJQOtkTXXlLQd6HP6x1pmNk+k+BN6quCFoBRRQKmtLB9CR8aOc2U+vC0eCph0VuZztWJFpfrxxoy6JvGWdyGtYanhVVw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ANGx2jD0891ExjocqhNzetd//WRjNa2RbPQ36Hour8Q=;
 b=x2+TXyV1r5ALC71F5e66pAa0s8V0auwttgx4LqFPJP+05JRQtUjCSL2gKeVHJ3VGYUDtAgz/Bh4v+IECban+vLyasXj7CPhO+Og9TvKcG7zGF9ykLe4VqtQkuZaZOM/FjGBZ2mZznZOl9uoC4JJbevAZot4X0tiARWOFLEU7H8I=
Received: from CH2PR16CA0016.namprd16.prod.outlook.com (2603:10b6:610:50::26)
 by DM4PR12MB6088.namprd12.prod.outlook.com (2603:10b6:8:af::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8207.17; Tue, 3 Dec
 2024 09:01:49 +0000
Received: from CH1PEPF0000A34C.namprd04.prod.outlook.com
 (2603:10b6:610:50:cafe::cd) by CH2PR16CA0016.outlook.office365.com
 (2603:10b6:610:50::26) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8207.18 via Frontend Transport; Tue,
 3 Dec 2024 09:01:49 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 CH1PEPF0000A34C.mail.protection.outlook.com (10.167.244.6) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.8230.7 via Frontend Transport; Tue, 3 Dec 2024 09:01:49 +0000
Received: from gomati.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Tue, 3 Dec
 2024 03:01:45 -0600
From: Nikunj A Dadhania <nikunj@amd.com>
To: <linux-kernel@vger.kernel.org>, <thomas.lendacky@amd.com>, <bp@alien8.de>,
	<x86@kernel.org>, <kvm@vger.kernel.org>
CC: <mingo@redhat.com>, <tglx@linutronix.de>, <dave.hansen@linux.intel.com>,
	<pgonda@google.com>, <seanjc@google.com>, <pbonzini@redhat.com>,
	<nikunj@amd.com>, Alexey Makhalov <alexey.makhalov@broadcom.com>, "Juergen
 Gross" <jgross@suse.com>, Boris Ostrovsky <boris.ostrovsky@oracle.com>
Subject: [PATCH v15 11/13] tsc: Switch to native sched clock
Date: Tue, 3 Dec 2024 14:30:43 +0530
Message-ID: <20241203090045.942078-12-nikunj@amd.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20241203090045.942078-1-nikunj@amd.com>
References: <20241203090045.942078-1-nikunj@amd.com>
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
X-MS-TrafficTypeDiagnostic: CH1PEPF0000A34C:EE_|DM4PR12MB6088:EE_
X-MS-Office365-Filtering-Correlation-Id: b61b4ab8-f2cc-4940-4de4-08dd13791f54
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700013|1800799024|82310400026|7416014|376014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?FhzQ8bkNPBBSoBzSxegdaxsWqKs63GNzY9ZeNAtJ3ibQMD8+l9gz2YzQoxRc?=
 =?us-ascii?Q?M4EbrCzspYGpyLAO4/rbpqxWb4a/OODkAH3/piFYQYcX3fgZG4S8WCDOSfoE?=
 =?us-ascii?Q?BcP+pY5rWBvs9S/9IvYccXR7IptFtJpmEF5lzi8EyiJm6JcVjJsEdCdMUa8G?=
 =?us-ascii?Q?nUFIVLgI+TbbJqsBrR5rWjOTObhHLHGeY+UO8CdAaCu9GlJBf6Eqww2/YXq2?=
 =?us-ascii?Q?UQKxbIz4v5L6sTPQYsovv7TdSJqzxo5Mz/H1nLbhOQiuWWlP95tuWGhYsIil?=
 =?us-ascii?Q?PLQP0Az2hA/GX5jn+zlolW5SfsOJfWgsgTGy2gyGGU53Zd2vqUvlPlsjZXyq?=
 =?us-ascii?Q?roTHHs2kYXTWQhae9Dh6cyu/0/qzCq+oGr12F1j/ZodfpSQnd6+0H0v7B9Fi?=
 =?us-ascii?Q?3vmbd/G38kyIybOaD3BeDMPO6H4NRVWdJhC/zC4Ora2wO7/WQqjroGS6M7UU?=
 =?us-ascii?Q?CaQ3oZ7E6QZVyx94/60SpRqmmqfSy6wniP6OxRrlevQOVYiF5D8oeEbvdJE4?=
 =?us-ascii?Q?GxhYenAoGR9toBIuaCvDSdnuYv0cCxz5/+UtTmxpA/X4YT5Dtn11bTmpA/Tl?=
 =?us-ascii?Q?kNhxsbiRRZcxpc9SgVv9uJonmKP3voJTJ5pTaDDTTDoSUuAruvT5H0rMXxgI?=
 =?us-ascii?Q?/RISMFdCYWfYfPlXwCaQ7z87lG0++7eRTUDSTJuz2dqd73PW/5IFPNotTT2D?=
 =?us-ascii?Q?+tRchskF7ptiH/iZEsNmglyb2TB+Oxz2mdEZt6VrNl2cc6Cg85/DfbpMAIhe?=
 =?us-ascii?Q?LhHIDCLrgK89v1yNv/WgUp64P0o4LyWBPiKSzCcvRIxHzMm3I5Y9R6FdsUrp?=
 =?us-ascii?Q?1y06tB24XMWieLPYklQ3u2/hBKFjeT/EqYF66V6IcmIgsHJuIzQwktG5zVa8?=
 =?us-ascii?Q?G7x8LLzd57pOAO42R9CAiKWcMg74MGxJ14W1WhXmowtjCOdpEuM5JPXOuGFJ?=
 =?us-ascii?Q?ND8QC9EkeQFLok2tqTK22scG037DwjS+Qow/oPiI2KLWhqV2RncVX/c3nNGT?=
 =?us-ascii?Q?4KvFv/QsI6mdv/U78OwLtHSFFlOJZfBtIm7rmRWyCB+xTPC/71h2F345AraZ?=
 =?us-ascii?Q?5C1CX90Pt+Qd63pOP9Dj9i9pipeBgkGnWVc4Gvvb5kODWKTmcbKNAYgZ6wg8?=
 =?us-ascii?Q?9xYPqWo338SLzJTVvSqSiqLV7pM/kSrlJacCpae/LA/ZtQXsEk2N+g9EfKVd?=
 =?us-ascii?Q?GuzPIDocpQGR2SPSlekyGqTWTzkRsgtYSXDd2Cmc7/FgBF9xYq6GWpeBZ2zs?=
 =?us-ascii?Q?8qzNUxMPQVV5yo0gNw6rZOOAGzL80MqKMpiN/NhOB80krg8ivrP3eGQ12pLn?=
 =?us-ascii?Q?RiWWo+X9/eUZEcXZ/hife8dKZig23IGfsccx/F+ig4oUKUjh8qShDu31z4mY?=
 =?us-ascii?Q?BniWCva5EgRS02VQrdNhwImsJBLdrqB7JQtEQzGA4HxwXgUoH5WcgOMdJ8ab?=
 =?us-ascii?Q?NIMCmP0isxSb5VjrouaAadp30zcbx+nR?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(36860700013)(1800799024)(82310400026)(7416014)(376014);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Dec 2024 09:01:49.3442
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: b61b4ab8-f2cc-4940-4de4-08dd13791f54
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CH1PEPF0000A34C.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB6088

Although the kernel switches over to stable TSC clocksource instead of PV
clocksource, the scheduler still keeps on using PV clocks as the sched
clock source. This is because KVM, Xen and VMWare, switch the paravirt
sched clock handler in their init routines. HyperV is the only PV clock
source that checks if the platform provides an invariant TSC and does not
switch to PV sched clock.

When switching back to stable TSC, restore the scheduler clock to
native_sched_clock().

As the clock selection happens in the stop machine context, schedule
delayed work to update the static_call()

Cc: Alexey Makhalov <alexey.makhalov@broadcom.com>
Cc: Juergen Gross <jgross@suse.com>
Cc: Boris Ostrovsky <boris.ostrovsky@oracle.com>
Signed-off-by: Nikunj A Dadhania <nikunj@amd.com>
---
 arch/x86/kernel/tsc.c | 19 +++++++++++++++++++
 1 file changed, 19 insertions(+)

diff --git a/arch/x86/kernel/tsc.c b/arch/x86/kernel/tsc.c
index 900edcde0c9e..a337c7e0b26e 100644
--- a/arch/x86/kernel/tsc.c
+++ b/arch/x86/kernel/tsc.c
@@ -273,10 +273,25 @@ bool using_native_sched_clock(void)
 {
 	return static_call_query(pv_sched_clock) == native_sched_clock;
 }
+
+static void enable_native_sc_work(struct work_struct *work)
+{
+	pr_info("using native sched clock\n");
+	paravirt_set_sched_clock(native_sched_clock);
+}
+static DECLARE_DELAYED_WORK(enable_native_sc, enable_native_sc_work);
+
+static void enable_native_sched_clock(void)
+{
+	if (!using_native_sched_clock())
+		schedule_delayed_work(&enable_native_sc, 0);
+}
 #else
 u64 sched_clock_noinstr(void) __attribute__((alias("native_sched_clock")));
 
 bool using_native_sched_clock(void) { return true; }
+
+static void enable_native_sched_clock(void) { }
 #endif
 
 notrace u64 sched_clock(void)
@@ -1158,6 +1173,10 @@ static void tsc_cs_tick_stable(struct clocksource *cs)
 static int tsc_cs_enable(struct clocksource *cs)
 {
 	vclocks_set_used(VDSO_CLOCKMODE_TSC);
+
+	/* Restore native_sched_clock() when switching to TSC */
+	enable_native_sched_clock();
+
 	return 0;
 }
 
-- 
2.34.1


