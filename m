Return-Path: <kvm+bounces-62969-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [142.0.200.124])
	by mail.lfdr.de (Postfix) with ESMTPS id E6CA2C55AC6
	for <lists+kvm@lfdr.de>; Thu, 13 Nov 2025 05:43:06 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id DAD764E1A72
	for <lists+kvm@lfdr.de>; Thu, 13 Nov 2025 04:43:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9E63A3054F7;
	Thu, 13 Nov 2025 04:42:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="H0Lratlx"
X-Original-To: kvm@vger.kernel.org
Received: from CH4PR04CU002.outbound.protection.outlook.com (mail-northcentralusazon11013066.outbound.protection.outlook.com [40.107.201.66])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AC1681917F0;
	Thu, 13 Nov 2025 04:42:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.201.66
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763008947; cv=fail; b=ntDGVBfkTf24twz9IoesiY66/q7PYq/BgufX5/PEXPxv9rA3ktAvIFsbbF/96o7zPwrdbuibgSLVDXY/62z/4EQgAdcgajgixgCt99+Y5Yl2AW5o5TzG216qGPxVfVXYKYPHifoQVzTvxhtbBdxMedJdBBGfFotLn50seriWlNI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763008947; c=relaxed/simple;
	bh=KT6rLlTgqdR2/bAy9QXmO7kAZpZUF3KFSUkxdLntYZ4=;
	h=Message-ID:Date:MIME-Version:Subject:To:CC:References:From:
	 In-Reply-To:Content-Type; b=JfT4SXfMNX7DW2YZbb/kzrMWBHb90cCwwaVdRgD7X/GG8VfPe2wM10pl43VoQ7nD0NK7ZZDAytuwb6ZQW3cu7rlXkrahFi5vx9Isa7ssM3Z7zgx+eZoo2xeuE4n3bWuALwfn9LDNQHI9pGe1cy4NrtXHG0yhgGxjUVW8xqwa6N0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=H0Lratlx; arc=fail smtp.client-ip=40.107.201.66
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=JtxuzUczhql9P+89O/L+VMDyX6RiwF+7rPb3bLSKAra9IOm5wHrBcD1dJ8c32PQtuji8xptSnky1TiMIJIWKFR3RTx0mtY9U+ZsDMHa0JnPhDUyjvKJTQM+wIMFejF6FJlPdtzoIevhQamW9yrFOx1I54BCGCK8rvwfOHv/3fQj2uKR4jAZopYaHdex1NYOGOC09otH7YPvD0TKSWaoqXVZ/uQcnSrzbnT2thEFmI3ZxBXMKbeEfVRORas/RrSdnCklQaTxLOjvfi/4Vw6kxQU1e8cKImHA8scwoU+9X1YTndxCize+TlSZuDCFXxXu4Tc1QTCMBlwPQj71VG1tuqQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=DvdXHGVcVeT81IhciuZaTupXZ5htZ5tabiU0wTXytpM=;
 b=IvJDLk111HkQ66UvFr9uLbqs3qdTOg84S8jRPS9MUBtlkgQR8JMdE5as852CnzBR+/e0lWPIy4VvsXaFmEb0g+W5gytdwXu0/2hFZLpDll+Z1uO6DDd8vmOmrzDKtHXM246UBXHJCVa5Q1L1Bub+XJ7Q59JGapPO0FgORnh3qsrN7BPlk9Ob3wEmUwK8v/7TOqEzAWDPWjylJbpTr2MTywAF/0W8/er397YNh7d29D1uBEGJpeLRr9K8w8MGje+6GQuaQ88MJ9LMxDgOrt01PugraBe26M7P8409opQICKtgG5cvxDM8Jkg0OMTrQGHDZVHFoXeGslmB0TV6kapWcQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=gmail.com smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=DvdXHGVcVeT81IhciuZaTupXZ5htZ5tabiU0wTXytpM=;
 b=H0LratlxFDEkZa99RY1Ja4n7t3zycQV90mFw5aKjPTIuI3aP7gQEUbGoPaj646iJBc3S+q5+m1tY6ZopD8xtay4uSSKv3ipwHrvyTCN6bghtfRpxHf/518soFvrImg5jSNVYDMG8ZsiS6a3E4ymT/NwqRVXwg5HVYoVdxe2+A6M=
Received: from SN7PR04CA0007.namprd04.prod.outlook.com (2603:10b6:806:f2::12)
 by SJ0PR12MB5635.namprd12.prod.outlook.com (2603:10b6:a03:42a::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9320.16; Thu, 13 Nov
 2025 04:42:20 +0000
Received: from SA2PEPF00003F66.namprd04.prod.outlook.com
 (2603:10b6:806:f2:cafe::79) by SN7PR04CA0007.outlook.office365.com
 (2603:10b6:806:f2::12) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9320.15 via Frontend Transport; Thu,
 13 Nov 2025 04:42:20 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb08.amd.com; pr=C
Received: from satlexmb08.amd.com (165.204.84.17) by
 SA2PEPF00003F66.mail.protection.outlook.com (10.167.248.41) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9320.13 via Frontend Transport; Thu, 13 Nov 2025 04:42:19 +0000
Received: from satlexmb10.amd.com (10.181.42.219) by satlexmb08.amd.com
 (10.181.42.217) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.17; Wed, 12 Nov
 2025 20:42:18 -0800
Received: from satlexmb07.amd.com (10.181.42.216) by satlexmb10.amd.com
 (10.181.42.219) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.17; Wed, 12 Nov
 2025 20:42:18 -0800
Received: from [10.136.45.200] (10.180.168.240) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server id 15.2.2562.17 via Frontend
 Transport; Wed, 12 Nov 2025 20:42:15 -0800
Message-ID: <079d48d9-a663-49d5-9bc6-f6518eb54810@amd.com>
Date: Thu, 13 Nov 2025 10:12:13 +0530
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 00/10] sched/kvm: Semantics-aware vCPU scheduling for
 oversubscribed KVM
To: Wanpeng Li <kernellwp@gmail.com>
CC: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>,
	Thomas Gleixner <tglx@linutronix.de>, Paolo Bonzini <pbonzini@redhat.com>,
	Sean Christopherson <seanjc@google.com>, Steven Rostedt
	<rostedt@goodmis.org>, Vincent Guittot <vincent.guittot@linaro.org>, "Juri
 Lelli" <juri.lelli@redhat.com>, <linux-kernel@vger.kernel.org>,
	<kvm@vger.kernel.org>, Wanpeng Li <wanpengli@tencent.com>
References: <20251110033232.12538-1-kernellwp@gmail.com>
 <7bc4b0b7-42ea-42fc-ae96-3084f44bdc81@amd.com>
 <CANRm+CxZfFVk=dX3Koi_RUH6ppr_zc6fs3HHPaYkRGwV7h9L7w@mail.gmail.com>
Content-Language: en-US
From: K Prateek Nayak <kprateek.nayak@amd.com>
In-Reply-To: <CANRm+CxZfFVk=dX3Koi_RUH6ppr_zc6fs3HHPaYkRGwV7h9L7w@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA2PEPF00003F66:EE_|SJ0PR12MB5635:EE_
X-MS-Office365-Filtering-Correlation-Id: a8f02354-a6a4-4afe-f99f-08de226f07a1
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700013|1800799024|376014|7416014|30052699003|82310400026|13003099007;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?TkovenJlUXZpVHQvNUdSVEE0ZnZGcWZRL1dBZWdWWDFnNDdRcUJtOGIzMkg4?=
 =?utf-8?B?NllLRmZ2NEpuczZJYkhDV0QzcUNUWDMrVk84N084Q0RzbWdrVGl2TU93eWMz?=
 =?utf-8?B?b2NXZEdWaVp3b3BEZVM3M2JzcXZwRjY1c29zTWllUWcwTjY3cWtvcWx0L3ph?=
 =?utf-8?B?NjhLTmNxWXdia21iSlp1TzNWYjdKVVBNODJuakNOUEVrUmtmT1lHRUdvOFFt?=
 =?utf-8?B?Rk8yaHVTcklQRVdReFRTbHQ3VXhnNE1GdGI1eituWVkzRDlscWxsVDY4K2k3?=
 =?utf-8?B?STFUNUpGOVhqMVh4RjRpelpVeWVBVFgwMjVJM2FrWWM2cjRTQmNRaG5ucGQv?=
 =?utf-8?B?WHlLTHQyUEZzNXlXYmVRbWlneUJTSjhjN1N4UVVrLytGU3loVXhJVDY5QVhv?=
 =?utf-8?B?U2J1TEdYU1laWGs5TzdxMHpsTURpNTNycWVEaHlsdFRHK3FLUktLVVFoVUUx?=
 =?utf-8?B?QndXQlJLUEtDSkRLWG9JRWREdjlyNEMxd2pQK3JyaS8yT3BITk1nOEtyc3Fk?=
 =?utf-8?B?TVNhekFqYi9RaG8xbWtVWndxMG5yNEhFcUpybFBtaTY0SlA2Mmw1VXRVdDF0?=
 =?utf-8?B?eVlIdjg0bDAwWUR3R3A5WUZpOHFTeDhKRFFXcllrUjBZSFRqL3ZEdW1XM3lp?=
 =?utf-8?B?TjlIem81U1FhKzkrU0h0ZU5FRnBXSDd3UTRkOWlXV0RyUUhmMG9sc0FLT0xx?=
 =?utf-8?B?VXpuRVQzU001cTgzdzlkSXprNTZvWHo3Y2svMmFoSnMxa2liUDZKTVpSY0Q0?=
 =?utf-8?B?U1lzM2R2ejlQa2dhUTI3eGpPYlRZVnNzMTI4N1phdmZIRm0wYU9lQkdrNjJH?=
 =?utf-8?B?VlFuemYrMk9RNUQ3YjdOVXVqOElEOTBERDdCZ3hhaTNDSk5HaEZWUUJZMTgx?=
 =?utf-8?B?NGhiaGErcGEzdGpLbEpnTjU3dHZwYUVab2tzT21pYkUxUWp5SFc2dHBYYWlw?=
 =?utf-8?B?MDBESm1EYWZCc2kwRmJUaGxsMktldEljdXFqVnhlcm05NTRoSUFIOE43Vnpu?=
 =?utf-8?B?UzNnOUNMSTJWeVg0anR6NzZzOGYvN0x3bXU2YWxqTDVnRkFQRHFrTzlrcW1k?=
 =?utf-8?B?ZUpHUEFaa2VEUWtLRVVIakFnc0RmK2FGS3EvbVd6NEtSeGR1RUlJK2h2dkxk?=
 =?utf-8?B?ZjZkL1g5SFJ3N0lhUUFkVkVualFZNzNLMUsyUUxIaWNnekVTNVhnVFZubkhU?=
 =?utf-8?B?SUhwSEZsNEVBWWdsdjZyUkVZb2xvTzE1VXp6RHFJdzZLOEROZGpHRWh0dEtn?=
 =?utf-8?B?T2dqVTlRZXU5S05pRDAzMFhFRW5veXVkcm9sN2RSUno2TTg0UzMrY282K0tt?=
 =?utf-8?B?UzVIUy8yVEs0c1hqb2xBZW9YcGNVWTRRNUpQRWdlRWlVZGxmeEd1VmJQOFYw?=
 =?utf-8?B?bTZDZ0o1dnYzNlZzelVkVUhTeWMyT1FrZXBPa2FVWkJ0VklSaDQvZDNrRjNF?=
 =?utf-8?B?MWRGRlpJN1RHRjROc3JBTndPcGtWb2JmOHFXRG9FbGt1bW5HWlRJdDlhTUlK?=
 =?utf-8?B?UXRpU2R4MEhPU1hRSDRWU0dMT2tzbWhJSkJ2MWkvUzNsM1V1OVBrR3g5UU5v?=
 =?utf-8?B?UGdpYzM2LzZjVlBBaWhlWEpELytuU2ZFV2M0MEtzNjZ4UkVacFp3TGJPU1h6?=
 =?utf-8?B?bHlpL2doNEowa3hMZUV0UC9rQWoyNkx2SW96YUJxc3JGRHNzRmtEejFaSzFV?=
 =?utf-8?B?Tm4wVnlGVWxUcXpObWkvWDQ4TmlOcDV4QnhOMmd4cnRPcjVDN3hjV1lNYTA2?=
 =?utf-8?B?NzVGR3NaMnFBaXp3WS9ZUHhTcGxnQ2tsdjYvb1Y3dHdlVDVJbVJXSE95dnY3?=
 =?utf-8?B?SjgrMjNJK0I1OHZNWDg5czg1VDRhTUVTMW0rWTVYVk1iYk5ZS2tqcDg1dzVW?=
 =?utf-8?B?bE5XM2NIeUZOZzBwSHBvdk8rbXlyRWJhRWhrMDI0SHhTOVh6eExFbWFUZjk0?=
 =?utf-8?B?NUlNL0s0emRuN1AvUUdPbTVVcEZZTE45aGVFWElpSTUrR2NPN3hHSXZHRTBi?=
 =?utf-8?B?ZFdSbTVtV2gvRE5kVDVzSHBaS3paN1RWWU5HVDRWZEMzZ0JSMjhFVExUTUo3?=
 =?utf-8?B?OGozdHA4VG93UUtkVlp5eUZtbm5IeUFxNjFiNTd3MW1NdmphYVRiZTF0QWll?=
 =?utf-8?Q?qAw4=3D?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:satlexmb08.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(36860700013)(1800799024)(376014)(7416014)(30052699003)(82310400026)(13003099007);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Nov 2025 04:42:19.7307
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: a8f02354-a6a4-4afe-f99f-08de226f07a1
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb08.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SA2PEPF00003F66.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR12MB5635

Hello Wanpeng,

On 11/12/2025 10:24 AM, Wanpeng Li wrote:
>>
>> ( Only build and boot tested on top of
>>     git.kernel.org/pub/scm/linux/kernel/git/peterz/queue.git sched/core
>>   at commit f82a0f91493f "sched/deadline: Minor cleanup in
>>   select_task_rq_dl()" )
>>
>> diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
>> index b4617d631549..87560f5a18b3 100644
>> --- a/kernel/sched/fair.c
>> +++ b/kernel/sched/fair.c
>> @@ -8962,10 +8962,28 @@ static void yield_task_fair(struct rq *rq)
>>          * which yields immediately again; without the condition the vruntime
>>          * ends up quickly running away.
>>          */
>> -       if (entity_eligible(cfs_rq, se)) {
>> +       do {
>> +               cfs_rq = cfs_rq_of(se);
>> +
>> +               /*
>> +                * Another entity will be selected at next pick.
>> +                * Single entity on cfs_rq can never be ineligible.
>> +                */
>> +               if (!entity_eligible(cfs_rq, se))
>> +                       break;
>> +
>>                 se->vruntime = se->deadline;
> 
> Setting vruntime = deadline zeros out lag. Does this cause fairness
> drift with repeated yields? We explicitly recalculate vlag after
> adjustment to preserve EEVDF invariants.

We only push deadline when the entity is eligible. Ineligible entity
will break out above. Also I don't get how adding a penalty to an
entity in the cgroup hierarchy of the yielding task when there are
other runnable tasks considered as "preserve(ing) EEVDF invariants".

> 
>>                 se->deadline += calc_delta_fair(se->slice, se);
>> -       }
>> +
>> +               /*
>> +                * If we have more than one runnable task queued below
>> +                * this cfs_rq, the next pick will likely go for a
>> +                * different entity now that we have advanced the
>> +                * vruntime and the deadline of the running entity.
>> +                */
>> +               if (cfs_rq->h_nr_runnable > 1)
> 
> Stopping at h_nr_runnable > 1 may not handle cross-cgroup yield_to()
> correctly. Shouldn't the penalty apply at the LCA of yielder and
> target? Otherwise the vruntime adjustment might not affect the level
> where they actually compete.

So here is the case I'm going after - consider the following
hierarchy:

     root
    /    \
  CG0   CG1
   |     |
   A     B

  CG* are cgroups and, [A-Z]* are tasks

A decides to yield to B, and advances its deadline on CG0's timeline.
Currently, if CG0 is eligible and CG1 isn't, pick will still select
CG0 which will in-turn select task A and it'll yield again. This
cycle repeates until vruntime of CG0 turns large enough to make itself
ineligible and route the EEVDF pick to CG1.

Now consider:


       root
      /    \
    CG0   CG1
   /   \   |
  A     C  B

Same scenario: A yields to B. A advances its vruntime and deadline
as a prt of yield. Now, why should CG0 sacrifice its fair share of
runtime for A when task B is runnable? Just because one task decided
to yield to another task in a different cgroup doesn't mean other
waiting tasks on that hierarchy suffer.

> 
>> +                       break;
>> +       } while ((se = parent_entity(se)));
>>  }
>>
>>  static bool yield_to_task_fair(struct rq *rq, struct task_struct *p)
>> ---
> 
> Fixed one-slice penalties underperformed in our testing (dbench:
> +14.4%/+9.8%/+6.7% for 2/3/4 VMs). We found adaptive scaling (6.0×
> down to 1.0× based on queue size) necessary to balance effectiveness
> against starvation.

If all vCPUs of a VM are in the same cgroup - yield_to() should work
just fine. If this "target" task is not selected then either some
entity in the hierarchy, or the task is ineligible and EEVDF pick has
decided to go with something else.

It is not "starvation" but rather you've received you for fair share
of "proportional runtime" and now you wait. If you really want to
follow EEVDF maybe you compute the vlag and if it is behind the
avg_vruntime, you account it to the "target" task - that would be
in the spirit of the EEVDF algorithm.

> 
>>
>> With that, I'm pretty sure there is a good chance we'll not select the
>> hierarchy that did a yield_to() unless there is a large discrepancy in
>> their weights and just advancing se->vruntime to se->deadline once isn't
>> enough to make it ineligible and you'll have to do it multiple time (at
>> which point that cgroup hierarchy needs to be studied).
>>
>> As for the problem that NEXT_BUDDY hint is used only once, you can
>> perhaps reintroduce LAST_BUDDY which sets does a set_next_buddy() for
>> the "prev" task during schedule?
> 
> That's an interesting idea. However, LAST_BUDDY was removed from the
> scheduler due to concerns about fairness and latency regressions in
> general workloads. Reintroducing it globally might regress non-vCPU
> workloads.
> 
> Our approach is more targeted: apply vruntime penalties specifically
> in the yield_to() path (controlled by debugfs flag), avoiding impact
> on general scheduling. The debooster is inert unless explicitly
> enabled and rate-limited to prevent pathological overhead.

Yeah, I'm still not on board with the idea but maybe I don't see the
vision. Hope other scheduler folks can chime in.

> 
>>
>>>
>>>    This creates a ping-pong effect: the lock holder runs briefly, gets
>>>    preempted before completing critical sections, and the yielding vCPU
>>>    spins again, triggering another futile yield_to() cycle. The overhead
>>>    accumulates rapidly in workloads with high lock contention.
>>>
>>> 2. KVM-side limitation:
>>>
>>>    kvm_vcpu_on_spin() attempts to identify which vCPU to yield to through
>>>    directed yield candidate selection. However, it lacks awareness of IPI
>>>    communication patterns. When a vCPU sends an IPI and spins waiting for
>>>    a response (common in inter-processor synchronization), the current
>>>    heuristics often fail to identify the IPI receiver as the yield target.
>>
>> Can't that be solved on the KVM end?
> 
> Yes, the IPI tracking is entirely KVM-side (patches 6-10). The
> scheduler-side debooster (patches 1-5) and KVM-side IPI tracking are
> orthogonal mechanisms:
>    - Debooster: sustains yield_to() preference regardless of *who* is
> yielding to whom
>    - IPI tracking: improves *which* target is selected when a vCPU spins
> 
> Both showed independent gains in our testing, and combined effects
> were approximately additive.

I'll try to look at the KVM bits but I'm not familiar enough with
those bits enough to review it well :)

> 
>> Also shouldn't Patch 6 be on top with a "Fixes:" tag.
> 
> You're right. Patch 6 (last_boosted_vcpu bug fix) is a standalone
> bugfix and should be at the top with a Fixes tag. I'll reorder it in
> v2 with:
> Fixes: 7e513617da71 ("KVM: Rework core loop of kvm_vcpu_on_spin() to
> use a single for-loop")

Thank you.

> 
>>
>>>
>>>    Instead, the code may boost an unrelated vCPU based on coarse-grained
>>>    preemption state, missing opportunities to accelerate actual IPI
>>>    response handling. This is particularly problematic when the IPI receiver
>>>    is runnable but not scheduled, as lock-holder-detection logic doesn't
>>>    capture the IPI dependency relationship.
>>
>> Are you saying the yield_to() is called with an incorrect target vCPU?
> 
> Yes - more precisely, the issue is in kvm_vcpu_on_spin()'s target
> selection logic before yield_to() is called. Without IPI tracking, it
> relies on preemption state, which doesn't capture "vCPU waiting for
> IPI response from specific other vCPU."
> 
> The IPI tracking records sender→receiver relationships at interrupt
> delivery time (patch 8), enabling kvm_vcpu_on_spin() to directly boost
> the IPI receiver when the sender spins (patch 9). This addresses
> scenarios where the spinning vCPU is waiting for IPI acknowledgment
> rather than lock release.
> 
> Performance (16 pCPU host, 16 vCPUs/VM, PARSEC workloads):
>    - Dedup: +47.1%/+28.1%/+1.7% for 2/3/4 VMs
>    - VIPS: +26.2%/+12.7%/+6.0% for 2/3/4 VMs
> 
> Gains are most pronounced at moderate overcommit where the IPI
> receiver is often runnable but not scheduled.
> 
> Thanks again for the review and suggestions.
> 
> Best regards,
> Wanpeng

-- 
Thanks and Regards,
Prateek


