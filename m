Return-Path: <kvm+bounces-66997-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 967A0CF2109
	for <lists+kvm@lfdr.de>; Mon, 05 Jan 2026 07:27:13 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 972ED3013ED6
	for <lists+kvm@lfdr.de>; Mon,  5 Jan 2026 06:27:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 69A8E325710;
	Mon,  5 Jan 2026 06:27:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="SAI+ZzI7"
X-Original-To: kvm@vger.kernel.org
Received: from CY7PR03CU001.outbound.protection.outlook.com (mail-westcentralusazon11010028.outbound.protection.outlook.com [40.93.198.28])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9E9371DF27D;
	Mon,  5 Jan 2026 06:26:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.93.198.28
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767594421; cv=fail; b=Kfnn5qR0uRDoViHsqqwb2z1s2qinLkRJJUOTd3hR6dO7RHjzZjGZr8CySMA5PKwQIShgraj/6E0IiepiE0qkIh6JxolnZeKk7Ovk92HTgCoYQQN59b94F179TbIzy/XE/Biys+i/QgWl77EwxvfbAqmcvcX3qPH/tZYiXb2GBXw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767594421; c=relaxed/simple;
	bh=np/WK6vRdsHJxn9Q8ZgHNlU6fJuZ85HWiHIT6+KY+pk=;
	h=Message-ID:Date:MIME-Version:Subject:To:CC:References:From:
	 In-Reply-To:Content-Type; b=CSZ3Rzp7XHTXHjGQhDXYD3PSYHD6wQi2vtxTURnSNHlPEC0A0dgyeGHAH4ST+9qHwup4qUg48EqQ4wMxM95mbQX19dFXo0TkkuUYgegvBU+ND3D6iKvxYZRMT3iXcFoapGobRIkxx6kxVUWpIX7CNx6/gPfjLu0pRvvOFb7xshQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=SAI+ZzI7; arc=fail smtp.client-ip=40.93.198.28
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=VsBXZwYBdKD9Ox7k4C1YDVz+iAgjyfvCheNSrhWpGbUEXuFKLLslICilF3paj0NC5+wbZVjc1HiR+bgSk8JEj51E1mSchEDTgL3rFwHk24Sob3xG5OAT2xwH+WngEIpPd2ss+Lqgm0PvIjlOf6MRw1PtIYMu7WBikwXYEYTV/XuZQHyn16vPnU6FghWE9IAPkd4b5WmvTfORZAtw/gu3E2owC37kXjLySiBFQLpJXfadqxVV9p9Dv/XjWoAqS7+z9gx56ZVdxAgHbWoEi++PALOHpSZxu8v0w+893h5mheRs5NOUUY2GYI2DtFtdCSV0dNKfxfDhhkM8EVq+erNecg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=qZZXBqZ2Tv3EHBGyeUw/5H2TqCCF8EwdicAXcdOfJSk=;
 b=mbzSRxqC8CktCF5+FX/euvBqJhqpfsEdx95rPfAOW7k1hu878PikuD/slj23L25DLl1XUP4qd/yJAKKyXyoqgAtK1tlCgp7bxEWl5+nrSBcZHQW+AW6GvYFz7YharuxUBWlh7Es33c4Ca1PHwo3hLccQ6opiZZp+6boMr/BQ7xqutJEmBkySSFdQfu1VaI+/kxuDViGGVFdkrBhJmC1SvG4wLtO87IYjhyO6wJzIM3F5ZoI0VGlGeam/+vAQwGh0hdpyPSL0pivEfu6pU8UcHx0nlWoVLnpra+X0WaXhALQPDUfOCVHo+PHxlKX2uFZ/Hhz7MxKKSNsU+9TbrovFAw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=gmail.com smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qZZXBqZ2Tv3EHBGyeUw/5H2TqCCF8EwdicAXcdOfJSk=;
 b=SAI+ZzI7G66dn6ipltCTqnqSqIoHJSpmS0l7R3hmzh0FCW4g6BohbBw92NKGjV5pyoIj+KSuet2Ji1AtqzrdLUewHWW5YFwkXPtlF1SP8enBlRigJL6yDWspACtJ3wQrBapyLA5HJI53dGlal/Mr9gAp55MBm0m/zYjSxVlJ4Zo=
Received: from MN2PR16CA0062.namprd16.prod.outlook.com (2603:10b6:208:234::31)
 by PH0PR12MB999113.namprd12.prod.outlook.com (2603:10b6:510:38f::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9478.4; Mon, 5 Jan
 2026 06:26:55 +0000
Received: from BN2PEPF00004FBB.namprd04.prod.outlook.com
 (2603:10b6:208:234:cafe::60) by MN2PR16CA0062.outlook.office365.com
 (2603:10b6:208:234::31) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9478.4 via Frontend Transport; Mon, 5
 Jan 2026 06:26:28 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb07.amd.com; pr=C
Received: from satlexmb07.amd.com (165.204.84.17) by
 BN2PEPF00004FBB.mail.protection.outlook.com (10.167.243.181) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9499.1 via Frontend Transport; Mon, 5 Jan 2026 06:26:55 +0000
Received: from Satlexmb09.amd.com (10.181.42.218) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.17; Mon, 5 Jan
 2026 00:26:54 -0600
Received: from satlexmb08.amd.com (10.181.42.217) by satlexmb09.amd.com
 (10.181.42.218) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.17; Sun, 4 Jan
 2026 22:26:54 -0800
Received: from [10.136.46.19] (10.180.168.240) by satlexmb08.amd.com
 (10.181.42.217) with Microsoft SMTP Server id 15.2.2562.17 via Frontend
 Transport; Mon, 5 Jan 2026 00:26:51 -0600
Message-ID: <f76772c1-7ece-4bc2-a67f-1ba07256604a@amd.com>
Date: Mon, 5 Jan 2026 11:56:51 +0530
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 0/9] sched/kvm: Semantics-aware vCPU scheduling for
 oversubscribed KVM
To: Wanpeng Li <kernellwp@gmail.com>, Peter Zijlstra <peterz@infradead.org>,
	Ingo Molnar <mingo@redhat.com>, Thomas Gleixner <tglx@linutronix.de>, "Paolo
 Bonzini" <pbonzini@redhat.com>, Sean Christopherson <seanjc@google.com>
CC: Christian Borntraeger <borntraeger@linux.ibm.com>, Steven Rostedt
	<rostedt@goodmis.org>, Vincent Guittot <vincent.guittot@linaro.org>, "Juri
 Lelli" <juri.lelli@redhat.com>, <linux-kernel@vger.kernel.org>,
	<kvm@vger.kernel.org>, Wanpeng Li <wanpengli@tencent.com>
References: <20251219035334.39790-1-kernellwp@gmail.com>
Content-Language: en-US
From: K Prateek Nayak <kprateek.nayak@amd.com>
In-Reply-To: <20251219035334.39790-1-kernellwp@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN2PEPF00004FBB:EE_|PH0PR12MB999113:EE_
X-MS-Office365-Filtering-Correlation-Id: bd984c0d-11ee-40af-32af-08de4c236c46
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700013|82310400026|376014|7416014|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?bkFCMnBBRWZoZ3BtMUFCQjUra0dFUmUzZ09FVUZKUGtzSUg2TTJ0dGpDZlBi?=
 =?utf-8?B?YXpvb1pGeVUvNjl3TENUcHJNbG5FK2FvN1VFRGcvVjdndGc5Z0pwWWQvZ1ZO?=
 =?utf-8?B?OEU4eGF5TWFOUWo4ZG9KeWhRQzQ2ZU80V3R1VGJ5cDVad0tpY3Ayc0lXeVBV?=
 =?utf-8?B?aFcrUEk4TUN1T3o5RW50U2dPcnczZTVmaXZuZTVqWHBMdmd0UTJCM2NGV0JH?=
 =?utf-8?B?Tk5hV1hKdUJjUmZWQ0dPeUM2UVhRMGRqTHE2TTUxL2J3M1hWM0lXQjdoNk81?=
 =?utf-8?B?WDlwem81REFzRytFSE93WHZ3OHRIZUloTnBVN0VQYXhldmZ3dEI0bXhaS1hK?=
 =?utf-8?B?ZnV2dzZwdWtMR3pQaG9lK3VuNGdKYXlTOFdSRFd2QVprL0RCbHhLazc5V25Q?=
 =?utf-8?B?UjhleXJIQmYvMGh4N2hQbng4b0IwelNuUWFkbFoyelY1SVBpZWN0VEl0SjVD?=
 =?utf-8?B?c2x3bVFtVmdIK0VFY3ZFanc4TUYrbThhV0Fzdy9HZjczcGsyN3BON2syeDFJ?=
 =?utf-8?B?VWY3S2RFWSs4NmFhaERubUpBSFYxb0ovZExYOUtTc3N1QWJ0dmJiMjlKcVlo?=
 =?utf-8?B?ZTRHbXQ5cWRrTDFma3kyOEFra0JkdTNUbmhoQ25vOTZ4Q1VURlhGMjJ5c3R5?=
 =?utf-8?B?a1ZtcjRxdlpWeEhOa3dnT245bjFKdVJ3NmFFcGcxRGdoc1BQOVVPakdmT3Fz?=
 =?utf-8?B?WUlpVHEzOFcxQW9XR3dER1FEQXVwaUpIQ1cyKzd6ZTRNdzNBWXZQMjMvZTFz?=
 =?utf-8?B?ZWU2Ym9NSFVlRkd2VW1IYkQ2SjJmSjUyNHFKeVB5TURJZDQvM1dzdXJISHpi?=
 =?utf-8?B?MkFlUzM5VkYyVzUyNytGWm93dVBoQW5DTE1iUXY2OW9lNGFGWmVEbDlpdzF1?=
 =?utf-8?B?WURvUGpkU0xJVVRzNDd1RGxMTkZYSHlHNXFTZ3RWcXJheFlONUJsRW84K2lp?=
 =?utf-8?B?Y09QSkMvZkJabFE0WU5iYjczWmF1UmpabThiUjdsOGlKRDhiVXlQZkxWZi8x?=
 =?utf-8?B?OU5pcXFpV1FxU1AvNDFUcHAzYjdhZGFKQ0xmb1VpR2I5VXA2UUpKNDBnTU52?=
 =?utf-8?B?U3dMblhWb0FoUzdlTk85RWFYMzJnSDdHNFl1TzNOb3NtNER1QnNmUVZzUzc4?=
 =?utf-8?B?T0dxYXE0bHJpeWtRQjZ3N3pUd25vTjFZYnVBUGY5a1VSOTBvazJIUWFLSXFi?=
 =?utf-8?B?R1ZiK0tXNUE4YjVWdVNEVXJlbVhTQzFXSkx6Y3daSkJRTXFxRlJYbWI0ekFw?=
 =?utf-8?B?Nno5dkJWNmFoaXREamxaUitkT2RqQXdadmg2RWtTRCttc0wrY2RYYzdWMkxm?=
 =?utf-8?B?TmIxZnlyOXRkMXVrcHA4RitQcGE0NWZ2cHZnVjAveFo1TTYxMUNlVEZsa2Qr?=
 =?utf-8?B?R0E0M0ZxeFZNWC92REl3MDdESXlZaVQzcWFlWXYyK3F4WlBHMEUxVFFqSVNG?=
 =?utf-8?B?d015clFwa09WVThqendzTHZrZVZBMFB6c2plNGk3SlVYeWFqTU5taDNJRSsv?=
 =?utf-8?B?RlVvckltMWVwLzkzVjFSbTNEOVB4QnNweklWaGZZbU9xU1M5bDV0dXF2QnBT?=
 =?utf-8?B?VDZWaDM1U0tJbkw3TFluclc2aHU0akYzRk5mMnEyU0o2VUUrVmtHQWpXeGZy?=
 =?utf-8?B?d21ZcE04dkNIZWIyb2dHMlRaUTVNdytEV2NRdVUxZWt1UlA0Nm9XZFBpbXox?=
 =?utf-8?B?QmRrZnBHaVhyeFpJU1l6cFhmOHZsNjRGMVVkRTZUcXFveVMyWVQ3MFVQY1kz?=
 =?utf-8?B?UFpUMUFITUxCem5rVVdWajhNSThmT3ZFbWNTblJQdVE0dFFYVUJnbkRuYU1i?=
 =?utf-8?B?MlBlSE1XenV2SDVGaGVLZWZSNFV3TVZraHI2YWo5d3FnV1h1SU5qWWFBam1t?=
 =?utf-8?B?R0hsaTZudERvLzE4dlk4b254aERwYTdhTmxRYk02QzR0eFJEUEV1RDFDZzFj?=
 =?utf-8?B?Qk1xZE1TNkhLeld5TllCc3dtb1pBMGFkR3kwbGs2eUNyd24rREdsM3hMcVNH?=
 =?utf-8?B?NnN0VlJleTZvL1ZvVTE3K2hhYXpJeFpoOW5JVG0yZG1vRUtmVm52ZUdZSkl3?=
 =?utf-8?B?QmptNnc4U3RIaXpnc2V1aEhXNkJDRFJLNnR4aXE4L29KWnBlbzA4aVg0WVBY?=
 =?utf-8?Q?R7fM=3D?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:satlexmb07.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(36860700013)(82310400026)(376014)(7416014)(1800799024);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Jan 2026 06:26:55.6867
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: bd984c0d-11ee-40af-32af-08de4c236c46
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb07.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BN2PEPF00004FBB.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR12MB999113

Hello Wanpeng,

On 12/19/2025 9:23 AM, Wanpeng Li wrote:
> Part 1: Scheduler vCPU Debooster (patches 1-5)
> 
> Augment yield_to_task_fair() with bounded vruntime penalties to provide
> sustained preference beyond the buddy mechanism. When a vCPU yields to a
> target, apply a carefully tuned vruntime penalty to the yielding vCPU,
> ensuring the target maintains scheduling advantage for longer periods.

Do you still see the problem after the fixes in commits:

127b90315ca0 ("sched/proxy: Yield the donor task")
79104becf42b ("sched/fair: Forfeit vruntime on yield")

Starting 79104becf42b, we push the vruntime on yield too which should
prevent the yield loop between vCPUs on same cgroup on the same vCPU.

If you have the following cgroup hierarchy:

           root
          /    \
         /      \
        /        \
       A          B
      / \         |
     /   \        |
  vCPU0  vCPU1  vCPU0

and vCPU0(A) yields to vCPU1(A) in the same cgroup vCPU1 should start
running after vCPU0 has pushed its vruntime enough to make it
ineligible.

If you have vCPUs across different cgroups with CPU controllers enabled,
I hope you have a very good reason to have such a setup because
otherwise, this is just too much to complexity for some theoretical,
insane deployment.

> 
> The mechanism is EEVDF-aware and cgroup-hierarchy-aware:
> 
> - Locate the lowest common ancestor (LCA) in the cgroup hierarchy where
>   both the yielding and target tasks coexist. This ensures vruntime
>   adjustments occur at the correct hierarchy level, maintaining fairness
>   across cgroup boundaries.
> 
> - Update EEVDF scheduler fields (vruntime, deadline) atomically to keep
>   the scheduler state consistent. Note that vlag is intentionally not
>   modified as it will be recalculated on dequeue/enqueue cycles. The
>   penalty shifts the yielding task's virtual deadline forward, allowing
>   the target to run.
> 
> - Apply queue-size-adaptive penalties that scale from 6.0x scheduling
>   granularity for 2-task scenarios (strong preference) down to 1.0x for
>   large queues (>12 tasks), balancing preference against starvation risks.
> 
> - Implement reverse-pair debouncing: when task A yields to B, then B yields
>   to A within a short window (~600us), downscale the penalty to prevent
>   ping-pong oscillation.
> 
> - Rate-limit penalty application to 6ms intervals to prevent pathological
>   overhead when yields occur at very high frequency.

I still don't like all this complexity. How much better is it than doing
something like a:

  (Only build tested)

diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index 7377f9117501..fbb263ea7d5a 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -9079,6 +9079,7 @@ static void yield_task_fair(struct rq *rq)
 static bool yield_to_task_fair(struct rq *rq, struct task_struct *p)
 {
 	struct sched_entity *se = &p->se;
+	unsigned long weight;
 
 	/* !se->on_rq also covers throttled task */
 	if (!se->on_rq)
@@ -9089,6 +9090,32 @@ static bool yield_to_task_fair(struct rq *rq, struct task_struct *p)
 
 	yield_task_fair(rq);
 
+	se = &rq->donor->se;
+	weight = se->load.weight;
+
+	/* Proportionally yield the hierarchy. */
+	while ((se = parent_entity(se))) {
+		unsigned long gcfs_rq_weight = group_cfs_rq(se)->load.weight;
+		struct cfs_rq *cfs_rq = cfs_rq_of(se);
+
+		WARN_ON_ONCE(se != cfs_rq->curr);
+		update_curr(cfs_rq);
+
+		/* Don't yield beyond the point of ineligibility. */
+		if (!entity_eligible(cfs_rq, se))
+			break;
+		/*
+		 * Proportionally increase the vruntime based on the slice
+		 * and the weight of the yielding subtree.
+		 */
+		se->vruntime += div_u64(calc_delta_fair(se->slice, se) * weight, gcfs_rq_weight);
+		update_deadline(cfs_rq, se);
+
+		/* Update the proportional wight of task on parent hierarchy. */
+		weight = (se->load.weight * weight) / gcfs_rq_weight;
+		if (!weight)
+			break;
+	}
 	return true;
 }
 
base-commit: 6ab7973f254071faf20fe5fcc502a3fe9ca14a47
---

Prepared on top of tip:sched/core. I don't like the above either and I'm
90% sure commit 79104becf42b ("sched/fair: Forfeit vruntime on yield")
will solve the problem you are seeing.

> Performance Results
> -------------------
> 
> Test environment: Intel Xeon, 16 physical cores, 16 vCPUs per VM
> 
> Dbench 16 clients per VM (filesystem metadata operations):
>   2 VMs: +14.4% throughput (lock contention reduction)
>   3 VMs:  +9.8% throughput
>   4 VMs:  +6.7% throughput
> 

And what does the cgroup hierarchy look like for these tests?

-- 
Thanks and Regards,
Prateek


