Return-Path: <kvm+bounces-62722-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 8BA0EC4BAD6
	for <lists+kvm@lfdr.de>; Tue, 11 Nov 2025 07:28:39 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 3541E3A3D0D
	for <lists+kvm@lfdr.de>; Tue, 11 Nov 2025 06:28:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9B1B02D739A;
	Tue, 11 Nov 2025 06:28:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="dJwQKWHR"
X-Original-To: kvm@vger.kernel.org
Received: from BYAPR05CU005.outbound.protection.outlook.com (mail-westusazon11010028.outbound.protection.outlook.com [52.101.85.28])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2BD492D0C7A;
	Tue, 11 Nov 2025 06:28:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.85.28
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762842511; cv=fail; b=JKfoaXFMWZhMswyACgtLnE0peFkXkmOy4f3bDUOa6M95kWtsNl7Y1JfiA9uJGePQDk0g+sfaXrzp4OiPTz+SnK/rNFGBW4mMHW3Vi3FQSWeahdSOAuS6L68rVyKZ1vaFdXWoIUAx7zNcect68qRAvp2xqcwptu5MCw3FUpjjVQ0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762842511; c=relaxed/simple;
	bh=vvjkNG/cIS1+9yN5fPFmlIWIPeb7AMAsbNBlrUmswxM=;
	h=Message-ID:Date:MIME-Version:Subject:To:CC:References:From:
	 In-Reply-To:Content-Type; b=Jiq1eX0FKpDEuQ9y+blfcVAb14YpDLihYQ1qki8HdZhR1vEYBY6UwA2YJ97y5JGZzbr2UnMI+BbO1GqQYzo91G5ueNeSDKMPAvd0kKrlhHiuRclCyWjpQ0OBY+uG37PGKf7VJig0dKbAKqv8sZJS9/KCc+7JGILW+4vGzeihla8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=dJwQKWHR; arc=fail smtp.client-ip=52.101.85.28
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=PNSxBvrYRlN+sWJgCUWpQ5twrY0RHqV/CebtCDAjgZ3FyTujKizP9IdS6JEH/QaA+Jr0ZCjG50CyVl74jM+uxh+kCCEHuwVrbatOGgQLwXuxp5+N3LzjsG/4S5VpxJErubAUnhcVisksaO7AVKRk8gegDl1sYDNilizCzn6DkBE8He7mMwgQNEu1kmAXbfV2sTz7vAnYAavPlU7c30iFnHMpIy+gDgZN2z3Tqevk0brxn3emM3JG2TjvTeRhVRHM4uK50bWrh0tKoAf06jnsO/sjh63Z3PU5B11qnSIMxwTtuDKvkWC4dC1j1JQ4pxlrcuUuU60WMWIqucIKXG4rPg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=26CZP3n03XL1oyHKQ6x1nClQkVh4Koje3/Kbb+rSW8c=;
 b=pZcfhVWE6byE7ko2cD+DE9XSRcIBZDtGAx3ZdcQ/lNIr1UrWMWW0M7b9o87s2/uaAJex8KGTT06GA2vTXWIJYKpM0ldJDsXjKzV7QD+hlS3XYyDo4A41nV92RuKIUPL8aqBd+g1goMiXH3p4Xidg+bhJjz+d0nM/RnOpRwtPEWwFMY4YfuCigyl80Lpx7+gXhJEwBlcMcu75b6VIfe+FZx8jSYCA11yFt8URaUJ4NXXLLP6PsXYpvZNdk7dhHYyEqqME1Gx0NnZ1SY+GvfmHjbJbRzURyPP31MmV284Axzzo5oNu3+L/Neys9NjL6nKSgBOlStm1HGQBfSiM7tz2hA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=gmail.com smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=26CZP3n03XL1oyHKQ6x1nClQkVh4Koje3/Kbb+rSW8c=;
 b=dJwQKWHReV9m82zeuQAMXZ6f8OptN1epO2X+xHmhFH0vropINt35EoOW507DH8pNKXYjk6UoGbet9AAlgClA0h2gyryZUM1MbjdBZ23X7ENVJsA03Lglt5BwBWPxxEJfW5n2GUMKPaB0CTitZWTzAsMr+GQrZxGp06GsUMDTu/A=
Received: from DM6PR04CA0019.namprd04.prod.outlook.com (2603:10b6:5:334::24)
 by MW3PR12MB4425.namprd12.prod.outlook.com (2603:10b6:303:5e::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9298.13; Tue, 11 Nov
 2025 06:28:26 +0000
Received: from DS2PEPF0000343C.namprd02.prod.outlook.com
 (2603:10b6:5:334:cafe::3c) by DM6PR04CA0019.outlook.office365.com
 (2603:10b6:5:334::24) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9320.15 via Frontend Transport; Tue,
 11 Nov 2025 06:28:26 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb08.amd.com; pr=C
Received: from satlexmb08.amd.com (165.204.84.17) by
 DS2PEPF0000343C.mail.protection.outlook.com (10.167.18.39) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9320.13 via Frontend Transport; Tue, 11 Nov 2025 06:28:26 +0000
Received: from satlexmb10.amd.com (10.181.42.219) by satlexmb08.amd.com
 (10.181.42.217) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.17; Mon, 10 Nov
 2025 22:28:25 -0800
Received: from satlexmb08.amd.com (10.181.42.217) by satlexmb10.amd.com
 (10.181.42.219) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.17; Mon, 10 Nov
 2025 22:28:25 -0800
Received: from [10.136.37.117] (10.180.168.240) by satlexmb08.amd.com
 (10.181.42.217) with Microsoft SMTP Server id 15.2.2562.17 via Frontend
 Transport; Mon, 10 Nov 2025 22:28:22 -0800
Message-ID: <7bc4b0b7-42ea-42fc-ae96-3084f44bdc81@amd.com>
Date: Tue, 11 Nov 2025 11:58:21 +0530
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 00/10] sched/kvm: Semantics-aware vCPU scheduling for
 oversubscribed KVM
To: Wanpeng Li <kernellwp@gmail.com>, Peter Zijlstra <peterz@infradead.org>,
	Ingo Molnar <mingo@redhat.com>, Thomas Gleixner <tglx@linutronix.de>, "Paolo
 Bonzini" <pbonzini@redhat.com>, Sean Christopherson <seanjc@google.com>
CC: Steven Rostedt <rostedt@goodmis.org>, Vincent Guittot
	<vincent.guittot@linaro.org>, Juri Lelli <juri.lelli@redhat.com>,
	<linux-kernel@vger.kernel.org>, <kvm@vger.kernel.org>, Wanpeng Li
	<wanpengli@tencent.com>
References: <20251110033232.12538-1-kernellwp@gmail.com>
Content-Language: en-US
From: K Prateek Nayak <kprateek.nayak@amd.com>
In-Reply-To: <20251110033232.12538-1-kernellwp@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS2PEPF0000343C:EE_|MW3PR12MB4425:EE_
X-MS-Office365-Filtering-Correlation-Id: 32a8036e-a836-447c-83ea-08de20eb8572
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|30052699003|1800799024|376014|7416014|82310400026|36860700013|13003099007;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?aVZvTUpiWkM0eVBlQzJmUnRIVHd0ZE9tMGkxaEp6WDVpTHF2UkUyUVU1clND?=
 =?utf-8?B?ek9RdG5xejI0aytoWEYrTWtaeXhFaUJrRHlqUitEZkcxWFltWEdCY2dEcGxs?=
 =?utf-8?B?c1RGSXpha3h6RUI5UEZkQWFsU3JhS2ZPRVBoSkpTTXhUNFhPaHRkUFNhZmVp?=
 =?utf-8?B?WEkzRURvV1RUY0wwWmhnMzFKVHJHeENQUHVGSkF0a25hWENnUWpkNnZpTDNX?=
 =?utf-8?B?SFZmcXZKY2V1UEE2MXdTMTVJQStqLzNKMWxucXBmY1d2THN3bHdOVy9kOHV5?=
 =?utf-8?B?eWJ1Q3BrdEMwbHZER3RNYlBJTUIvUnpSbzRNc3dUTFp3Qi9WUnlIeFptQ3pR?=
 =?utf-8?B?UlIzdTlnSXo4WGRiaHowRlU1NGRPZTV4N0RmOHZBZkt6MEJEeGliMTZtMisz?=
 =?utf-8?B?NXFCVmN0eGJmTkZGWm9GWlVXeTNnT0FSY1o3UE11SUdnMFpjdy82UWtzSVFj?=
 =?utf-8?B?QWpITXg2KzR2RS80SWszVE9MWkZnSHJ5L1JlcFg4RldEbjgxN242eEhQWUF3?=
 =?utf-8?B?R1Bic05nQ2dPQ3daY3RxSVBjRVNPZWkyMTIzblBrWk5EbkkxRnc5T0Z3VmJp?=
 =?utf-8?B?S2ZzTWZIYXcwYmdDQmoxZmtMN3lQZ05DRFFPZzRKT2p5bEJ2VUZBd0ZmYlpL?=
 =?utf-8?B?bk1aeWFWNzV5Znl4d3Zra1FsWm9GV256dFdOaURCVHZwdC9uQzdkZDZpNXBU?=
 =?utf-8?B?VzlhYVpGRE5JMWJuV3duK3pEM3JETzRobFpVbGJ1QXl6bU9VQmdic1BVTnZy?=
 =?utf-8?B?OHlsaEo4NU9lQWlRRUQ2Q1IreHFNQktVUjc2NW9vaVZLTi8reDlPMGxoRWsx?=
 =?utf-8?B?TklnQzRDUmRSY0NlWGlBN3RQL0xSVDMxWDBySmJDdUZ0b1NOYzljS2Zva0cz?=
 =?utf-8?B?WlRxc042ZndKUnNiUkdkUmdkREJ0cTBzNkllWThqMTh4UHVxNHFwNFJudWRR?=
 =?utf-8?B?UXZTU1JDYm43V21UbGlITG1hVVA1dmFWc2dZWStyME56NGVIWlF5QSszTEpQ?=
 =?utf-8?B?cTRSYVRGeUJnRktNajZPSFpsbUR6N0l0WTdwSktiUHRRS3FVaHN1STFETGI2?=
 =?utf-8?B?WnR1VmNjSDZ6LzdLeS9FODVkTGJiTkk3Yk9RWjZySVNDV3NFZklaSGs0TlZv?=
 =?utf-8?B?VTNhSUUySnhTVVUyRDZDTERYUHpGL1JYaUI5dnRyODEvd2RzS1BZMHFWQ1p0?=
 =?utf-8?B?VERXYmxzUENXaXRFREhrRG03Vk5jdUJlQWFmejN1eU10WkhZVzFZZDhtOGsw?=
 =?utf-8?B?OEZBSS9FL1JtOTQ3MkkzNmVDQVFKaEtNajN2TkdXemNReURYaVg3dG14VmRB?=
 =?utf-8?B?a250TnorT2NWV2RpbU5FOW13WHNaUmptOW1VYnA5RmxCYkkyUjROMDBWem4v?=
 =?utf-8?B?NjJ5aWp2ZFRNTUY4di9BMnVVNk9JSFp1MTRRZWtBcS9CUHVIRzQ0MFk1blph?=
 =?utf-8?B?dWppdGY2Zmo0MnNGU0FPcUlwaWRHTUNjRXBPM3pJWG9ZQWdwTjhmTkN1VGNH?=
 =?utf-8?B?MjBLKzlnN2tsTVpSUGRacGFjK0pRdFp2d0xzRTlnaksxQ05CLysyYWg4L0NW?=
 =?utf-8?B?YzIrSTA4OWlyRHkvMjY4UzFaN3ErelVYZi9aVkZHekhKdzBoL2VtNUZReDJP?=
 =?utf-8?B?K1F0d1RDK2xlanQrVGxMOXlMWm80a0FUcVBVYnRETzVORWdINEg5QUs1dHNC?=
 =?utf-8?B?eis1TVUwakRudnFsQ04xYmREVkhWdjdyOGRLenlhNWE2T1Rwd3FUbGM5eGdD?=
 =?utf-8?B?NG9xMzhlWkIwWjZVZWYyNzR5aHZscDFXYmZJdDBtU25DVVFZbnJSdHR1Qm4r?=
 =?utf-8?B?ZGpxRkRCVHVCZHVDeGRJUTYvWlpsa3Z5NlZZRCtmRGVqMkRvTk04VTYzdExQ?=
 =?utf-8?B?amRDT3NmN2ZWOVNKRFhOd2ZDODFvK216djE5Qm9Jazdzc0IybUowMk5pdjFO?=
 =?utf-8?B?QmVQNDBqTWhrUGpubTVVczh5LzJlaGJlaUhPNTNXKzFTQkxCRklUdTIvZk1r?=
 =?utf-8?B?aEhBZ09vTjk4S2pEdWVBYk9FWS82NlVhTGdCZW10NjVNOXhCWXBubjZWd1NR?=
 =?utf-8?Q?Sq1k/N?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:satlexmb08.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(30052699003)(1800799024)(376014)(7416014)(82310400026)(36860700013)(13003099007);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Nov 2025 06:28:26.0685
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 32a8036e-a836-447c-83ea-08de20eb8572
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb08.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DS2PEPF0000343C.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW3PR12MB4425

Hello Wanpeng,

I haven't looked at the entire series and the penalty calculation math
but I've a few questions looking at the cover-letter.

On 11/10/2025 9:02 AM, Wanpeng Li wrote:
> From: Wanpeng Li <wanpengli@tencent.com>
> 
> This series addresses long-standing yield_to() inefficiencies in
> virtualized environments through two complementary mechanisms: a vCPU
> debooster in the scheduler and IPI-aware directed yield in KVM.
> 
> Problem Statement
> -----------------
> 
> In overcommitted virtualization scenarios, vCPUs frequently spin on locks
> held by other vCPUs that are not currently running. The kernel's
> paravirtual spinlock support detects these situations and calls yield_to()
> to boost the lock holder, allowing it to run and release the lock.
> 
> However, the current implementation has two critical limitations:
> 
> 1. Scheduler-side limitation:
> 
>    yield_to_task_fair() relies solely on set_next_buddy() to provide
>    preference to the target vCPU. This buddy mechanism only offers
>    immediate, transient preference. Once the buddy hint expires (typically
>    after one scheduling decision), the yielding vCPU may preempt the target
>    again, especially in nested cgroup hierarchies where vruntime domains
>    differ.

So what you are saying is there are configurations out there where vCPUs
of same guest are put in different cgroups? Why? Does the use case
warrant enabling the cpu controller for the subtree? Are you running
with the "NEXT_BUDDY" sched feat enabled?

If they are in the same cgroup, the recent optimizations/fixes to
yield_task_fair() in queue:sched/core should help remedy some of the
problems you might be seeing.

For multiple cgroups, perhaps you can extend yield_task_fair() to do:

( Only build and boot tested on top of
    git.kernel.org/pub/scm/linux/kernel/git/peterz/queue.git sched/core
  at commit f82a0f91493f "sched/deadline: Minor cleanup in
  select_task_rq_dl()" )

diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index b4617d631549..87560f5a18b3 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -8962,10 +8962,28 @@ static void yield_task_fair(struct rq *rq)
 	 * which yields immediately again; without the condition the vruntime
 	 * ends up quickly running away.
 	 */
-	if (entity_eligible(cfs_rq, se)) {
+	do {
+		cfs_rq = cfs_rq_of(se);
+
+		/*
+		 * Another entity will be selected at next pick.
+		 * Single entity on cfs_rq can never be ineligible.
+		 */
+		if (!entity_eligible(cfs_rq, se))
+			break;
+
 		se->vruntime = se->deadline;
 		se->deadline += calc_delta_fair(se->slice, se);
-	}
+
+		/*
+		 * If we have more than one runnable task queued below
+		 * this cfs_rq, the next pick will likely go for a
+		 * different entity now that we have advanced the
+		 * vruntime and the deadline of the running entity.
+		 */
+		if (cfs_rq->h_nr_runnable > 1)
+			break;
+	} while ((se = parent_entity(se)));
 }
 
 static bool yield_to_task_fair(struct rq *rq, struct task_struct *p)
---

With that, I'm pretty sure there is a good chance we'll not select the
hierarchy that did a yield_to() unless there is a large discrepancy in
their weights and just advancing se->vruntime to se->deadline once isn't
enough to make it ineligible and you'll have to do it multiple time (at
which point that cgroup hierarchy needs to be studied).

As for the problem that NEXT_BUDDY hint is used only once, you can
perhaps reintroduce LAST_BUDDY which sets does a set_next_buddy() for
the "prev" task during schedule?

> 
>    This creates a ping-pong effect: the lock holder runs briefly, gets
>    preempted before completing critical sections, and the yielding vCPU
>    spins again, triggering another futile yield_to() cycle. The overhead
>    accumulates rapidly in workloads with high lock contention.
> 
> 2. KVM-side limitation:
> 
>    kvm_vcpu_on_spin() attempts to identify which vCPU to yield to through
>    directed yield candidate selection. However, it lacks awareness of IPI
>    communication patterns. When a vCPU sends an IPI and spins waiting for
>    a response (common in inter-processor synchronization), the current
>    heuristics often fail to identify the IPI receiver as the yield target.

Can't that be solved on the KVM end? Also shouldn't Patch 6 be on top
with a "Fixes:" tag.

> 
>    Instead, the code may boost an unrelated vCPU based on coarse-grained
>    preemption state, missing opportunities to accelerate actual IPI
>    response handling. This is particularly problematic when the IPI receiver
>    is runnable but not scheduled, as lock-holder-detection logic doesn't
>    capture the IPI dependency relationship.

Are you saying the yield_to() is called with an incorrect target vCPU?

> 
> Combined, these issues cause excessive lock hold times, cache thrashing,
> and degraded throughput in overcommitted environments, particularly
> affecting workloads with fine-grained synchronization patterns.
> 
-- 
Thanks and Regards,
Prateek


