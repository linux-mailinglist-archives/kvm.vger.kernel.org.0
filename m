Return-Path: <kvm+bounces-62995-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ams.mirrors.kernel.org (ams.mirrors.kernel.org [IPv6:2a01:60a::1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id 53862C56AF4
	for <lists+kvm@lfdr.de>; Thu, 13 Nov 2025 10:50:36 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ams.mirrors.kernel.org (Postfix) with ESMTPS id 96C1134F136
	for <lists+kvm@lfdr.de>; Thu, 13 Nov 2025 09:49:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EF8352E0B68;
	Thu, 13 Nov 2025 09:48:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="vpw483f7"
X-Original-To: kvm@vger.kernel.org
Received: from SN4PR2101CU001.outbound.protection.outlook.com (mail-southcentralusazon11012066.outbound.protection.outlook.com [40.93.195.66])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 23FF82E03EF;
	Thu, 13 Nov 2025 09:48:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.93.195.66
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763027322; cv=fail; b=bFRnJnjDUQRKkAov6RD+BnyohxRI5X0w5uP0WTz5LX2NyLKylfr+0/+64mF/e8Msh2DCLHynrqWqd/rDOw9nDgsuwTWPZthB2yZ2kKPaUgpVMc0msg0k8KRn2MogbHyy0LyADHs1e6sczRSUkgLpXAJMomJN00doTOok9SlXH0Y=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763027322; c=relaxed/simple;
	bh=6lhqOULMy/TALZubuZ9LO97n2+eTTt3WYn6bdJ+g+8o=;
	h=Message-ID:Date:MIME-Version:Subject:To:CC:References:From:
	 In-Reply-To:Content-Type; b=bYCXBFIalaSHAJKgF31rlAdZWpJVsB9H4qiOiQaOL+8UftFnQATtwt6isdPPIfLRIqAHv6yVXXxfrTqiE4ZCpPa/5MgIoh57tZC9mtd8VRXsVgNYuuNKNUWow3BX+DeoQqwWdcqmNjKPuHe7zkjwtDJmtOwkMoH1Y1XBTP7sM7w=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=vpw483f7; arc=fail smtp.client-ip=40.93.195.66
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=brWkH3gCZp2xYegTWm7eUiQPZptEyJ5pBk268+LVlR1Yh5ueLSWTM4G6aYddVeJ2OILQ1cRzd6gMlQ8xl1D41AR1dkqXF64Qdj3cdVGlNOku6J9aGbSU/0yqeIu6SGoDpBkok5tl3x601IitnLpSedOJUELl/4FTmON9c1y8NuMnEvLcwboktwQJCWSXtod0LpfKmf3xyu0IkwXdnm7m3z5V/YGlKMuIWYrDteJypI94fkDpI/f/NZQvJ5xp34DS2/8MkYHT3qL/s6QM0Uh2/3fQYuVTj3Aiy98d4HughYLxqycEicWQ3SlkhN6462U9bfaabubZswhMJVkeLDM/sQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=DOlRXFZRNspKxI8enoAFhFIFMuuoBLWDwWcDChGKR7s=;
 b=sXMVKccAPgG806teqcaqCjTt32g6bzu/p1hb14Qt2tsvEuSH34uQFzzKHduA5s/L0mEurAnXJazKG6RuWKajTzou+n70whpKGOWh6QZjePl+i1SG1Nyusjw4CUpMyI2xk+CWu9Xc+cWSYI6zrzYnyeNodyBa9RyQ2dZvv2TaoENaENhhxcFAE8/OMLOHiaStsFwVgkZ631dmECETdFmVOYdjZpB4f8t7MWv53wD/qMBK41KjBXThQD7LV5HU+IPsOXAta40NOVQomwZd+1XsKPbLUiJElF+scGGfD6JTQnt/P4CBx0VpQtVfBm02HCHpQjOnFpSuMO6CGSNze1GHYg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=gmail.com smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=DOlRXFZRNspKxI8enoAFhFIFMuuoBLWDwWcDChGKR7s=;
 b=vpw483f7bW4gtfiUJqXIpWFe1oN8pFLqlZm8WOU92wvtGXRuc0wGvetrNPJBHmdeqWlL3IA2DZi9VzSsp5LKoxeHf/OAVkFQ0/o75MCiRA5EO7mPYss4B6UZY+HO4epBoNQyy2p5T+Ex2m07KgtUwiC4YPLwrZ1AFiEwuZqaAzQ=
Received: from CH0P221CA0014.NAMP221.PROD.OUTLOOK.COM (2603:10b6:610:11c::12)
 by PH8PR12MB6700.namprd12.prod.outlook.com (2603:10b6:510:1cf::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9320.15; Thu, 13 Nov
 2025 09:48:36 +0000
Received: from DS3PEPF000099E2.namprd04.prod.outlook.com
 (2603:10b6:610:11c:cafe::9) by CH0P221CA0014.outlook.office365.com
 (2603:10b6:610:11c::12) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9320.17 via Frontend Transport; Thu,
 13 Nov 2025 09:48:34 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb08.amd.com; pr=C
Received: from satlexmb08.amd.com (165.204.84.17) by
 DS3PEPF000099E2.mail.protection.outlook.com (10.167.17.201) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9320.13 via Frontend Transport; Thu, 13 Nov 2025 09:48:35 +0000
Received: from satlexmb10.amd.com (10.181.42.219) by satlexmb08.amd.com
 (10.181.42.217) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.17; Thu, 13 Nov
 2025 01:48:34 -0800
Received: from satlexmb07.amd.com (10.181.42.216) by satlexmb10.amd.com
 (10.181.42.219) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.17; Thu, 13 Nov
 2025 01:48:34 -0800
Received: from [10.136.45.200] (10.180.168.240) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server id 15.2.2562.17 via Frontend
 Transport; Thu, 13 Nov 2025 01:48:31 -0800
Message-ID: <34b2d375-1535-41c1-9ec4-bb054641abd5@amd.com>
Date: Thu, 13 Nov 2025 15:18:30 +0530
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
 <079d48d9-a663-49d5-9bc6-f6518eb54810@amd.com>
 <CANRm+Cy2O9j_itDmJcAwUebV2h=2hvfZxuxtHqKD-vF1XohGAw@mail.gmail.com>
Content-Language: en-US
From: K Prateek Nayak <kprateek.nayak@amd.com>
In-Reply-To: <CANRm+Cy2O9j_itDmJcAwUebV2h=2hvfZxuxtHqKD-vF1XohGAw@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS3PEPF000099E2:EE_|PH8PR12MB6700:EE_
X-MS-Office365-Filtering-Correlation-Id: 8483f6e4-c5e9-44b8-7ec2-08de2299d079
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|1800799024|376014|7416014|36860700013;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?QlNMLzFKa2lXdjhMMTNxNjlUOFZJWXRiaE9McGcyeTJKcENTaHhramNneTlx?=
 =?utf-8?B?YnkzOEh1V2NDWHdtbGtKSnhmdk9POElUMW1NYkJsS2ZaWjRRajhPODJxSHNO?=
 =?utf-8?B?NjI5L0RuUDlGMjhnTjJhSTJzV2lpVjI1TlhyeVNJL29pb3dDRTlYd2pJbDJW?=
 =?utf-8?B?UXJzZEVzc2JhTHhMMEpvbzZvcU9rWWxMOVRDWjJUVlNrcjhhb2prNGh1UXB0?=
 =?utf-8?B?d3c2STVyYjdFUXE3akxwTGkwYnF4Q3huOE5NTmc0RTIyUm0wUUNOaWtaNU8r?=
 =?utf-8?B?MHdmU1dWcmZBdGpWc3FvSnRmZ1JuK2RhSnhwZTRKNnVhRnRPYVJtSGM4UGlj?=
 =?utf-8?B?eVVkYlY2dXFsdTZCK3ljS09tbnJWT01BZVp4WHNFNnh0QXNIOXZ3c2duTG1j?=
 =?utf-8?B?ODQrVkh3bjVLQWlubS9jMzRJWlNhajB4cE1DdjlSZUhHeG5RK3JPTHhxSWph?=
 =?utf-8?B?NkVTTnkxLzB1TmFsbjkzSmxoU1NpUE42MWd2bkI4K3pMUXF4QkZJU1J2am5k?=
 =?utf-8?B?S3FlK2pkY3h4RnZvZ3psckQ3MkEzWk8vbVFmMUNTdjFrRWhBRHpURndUTE5W?=
 =?utf-8?B?N3VPYmtXUVFubXRHbXFDdm1taEFFVEFlWElqSWwzSzQrOXl0NnJyVnBPVmNj?=
 =?utf-8?B?a3lQWTJsQWFtWHp5UENPcXhYaExMZTdlZjZKaFVoMzJyVEFaRmdkc1BZbm91?=
 =?utf-8?B?bVpqMlBrbzFxSklKalVMWW80YTUxeEJyUHpLaUJFQW9CaG5xUjhuR3FJdDZZ?=
 =?utf-8?B?VTJnNCtiNEJZcU5FV1J0UDNGTHQ3UHpUZ1VaUXU0QlNWamozazMxbEk4elpM?=
 =?utf-8?B?WU82Um42MStUQ1R2VWJndlpnSll3OENRcFlmdStHemZBOXJRL3FRZzFNZXlZ?=
 =?utf-8?B?dmQraElnN2Vjb1lGWmh3WHpJZXNWb1NlSWRSUFo5ME83cHpFZENkNG1iT0FZ?=
 =?utf-8?B?anBYUHkybGU0VURDV3dxd1pSb2VPZHF2N2xCSklYR0o5STliQVVPVHBXWkh3?=
 =?utf-8?B?OTdSeFE2RWI2R3NyaUFickplTjhsRE9KSXpWUWJSbkJFRklESXBENTVQUHFH?=
 =?utf-8?B?Y0FCa3VRMk52K3YzMytGK3Jya2k2MlA3b3RlL21NK0JHdW54N1BiVnFjZzk0?=
 =?utf-8?B?RkFzL0NDblo4L2o5dzh1V2FUMTFURFdPZ2grR0RXMU96WGlidXMrdWFZRTMr?=
 =?utf-8?B?WjBZZUxTS1JMd3VCWERrenRVS3M1V1UzS3UwckJPUzZPcDBLaUpvQVFSUGh0?=
 =?utf-8?B?Q3RIYm1kWXY1aFJIYm01UExVbi9QdnA4OTFKR0VidDV2T29MU2VOZGl1MlN4?=
 =?utf-8?B?MDN4ckRFcitsaVBLVy9kelBQT0JpRDFjdWNKRGJwQW05SGNicTU3SW5RL2VS?=
 =?utf-8?B?NDVSVUJTY3JHRXlEdTRMY2d1TGhZN28wai9oMm9jYmVlMEJkR2RqN240UEk1?=
 =?utf-8?B?MUh4SGpTR2hUYnE3RHplV1BCakpnanpscndEbSsxK3JsVmtxVTRHRFhuazV5?=
 =?utf-8?B?M0ZhVXNBM2VxbDY2eDJMVGkvOXVIaE1qK1BzbE9pUFVEUXRBb0dzY3ppaXRJ?=
 =?utf-8?B?a1VqNTNvb3dYZTQvcXpEbjhrNXNxUWNjMEdxWkI3S3VOSlI2MUtoUS9Xem5l?=
 =?utf-8?B?WXZpNmlWbDZmemJrSUl0Yks1YkhzZm5XUkRRakIxMW1nSnJjVWFMMnJuMGx5?=
 =?utf-8?B?ZnZGTitLTDVKekZaUjZUQ0k3NVF2RHVzckdaTm9BSUpCaVkyOEV4NnhLK3Fz?=
 =?utf-8?B?eVpiT25LWWQxRjdGcjdEQlorQmZXSUJjY0poTllLRHpVM3JmdGI5dURtT0d1?=
 =?utf-8?B?elF1Q0Y4ZmtVM0txbGdxeVNDYkt6M2Z2Sk9lRXhuR3hPc2hnTm01QlhoL3lN?=
 =?utf-8?B?UkhNYVhLZWdEdGRDM1UyM1h3clF1ZC9nTEFPRGhWMEVYKzgzSVAycU1xLzFh?=
 =?utf-8?B?TmQzQ0dKMThNVi9kZHJYUDEvcWU2NXFOVFNMVUhDS3pIdzhsaVBvZkdkVTFv?=
 =?utf-8?B?SnBVcDdDR3pKamNLRkVxK3R2YUlmZzlkd3RMRkN3UHZtNE5sZHBlQjlaNGZW?=
 =?utf-8?B?eWR6ZGwzTWNBdVBCQmI0V01hTndRTStwQWJDRHByWkY4MS9lR2tySTBVNk9I?=
 =?utf-8?Q?r9Kw=3D?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:satlexmb08.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(82310400026)(1800799024)(376014)(7416014)(36860700013);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Nov 2025 09:48:35.5344
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 8483f6e4-c5e9-44b8-7ec2-08de2299d079
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb08.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DS3PEPF000099E2.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH8PR12MB6700

Hello Wanpeng,

On 11/13/2025 2:03 PM, Wanpeng Li wrote:
>>>> diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
>>>> index b4617d631549..87560f5a18b3 100644
>>>> --- a/kernel/sched/fair.c
>>>> +++ b/kernel/sched/fair.c
>>>> @@ -8962,10 +8962,28 @@ static void yield_task_fair(struct rq *rq)
>>>>          * which yields immediately again; without the condition the vruntime
>>>>          * ends up quickly running away.
>>>>          */
>>>> -       if (entity_eligible(cfs_rq, se)) {
>>>> +       do {
>>>> +               cfs_rq = cfs_rq_of(se);
>>>> +
>>>> +               /*
>>>> +                * Another entity will be selected at next pick.
>>>> +                * Single entity on cfs_rq can never be ineligible.
>>>> +                */
>>>> +               if (!entity_eligible(cfs_rq, se))
>>>> +                       break;
>>>> +
>>>>                 se->vruntime = se->deadline;
>>>
>>> Setting vruntime = deadline zeros out lag. Does this cause fairness
>>> drift with repeated yields? We explicitly recalculate vlag after
>>> adjustment to preserve EEVDF invariants.
>>
>> We only push deadline when the entity is eligible. Ineligible entity
>> will break out above. Also I don't get how adding a penalty to an
>> entity in the cgroup hierarchy of the yielding task when there are
>> other runnable tasks considered as "preserve(ing) EEVDF invariants".
> 
> Our penalty preserves EEVDF invariants by recalculating all scheduler state:
>    se->vruntime = new_vruntime;
>    se->deadline = se->vruntime + calc_delta_fair(se->slice, se);
>    se->vlag = avg_vruntime(cfs_rq) - se->vruntime;
>    update_min_vruntime(cfs_rq); // maintains cfs_rq consistency

So your exact implementation in yield_deboost_apply_penalty() is:

> +	new_vruntime = se_y_lca->vruntime + penalty;
> +
> +	/* Validity check */
> +	if (new_vruntime <= se_y_lca->vruntime)
> +		return;
> +
> +	se_y_lca->vruntime = new_vruntime;

You've updated this vruntime to something that you've seen fit based on
your performance data - better performance is not necessarily fair.

update_curr() uses:

    /* Time elapsed. */
    delta_exec = now - se->exec_start;
    se->exec_start = now;

    curr->vruntime += calc_delta_fair(delta_exec, curr);


"delta_exec" is based on the amount of time entity has run as opposed
to the penalty calculation which simply advances the vruntime by half a
slice because someone in the hierarchy decided to yield.

Also assume the vCPU yielding and the target is on the same cgroup -
you'll advance the vruntime of task in yield_deboost_apply_penalty() and
then again in yield_task_fair()?


> +	se_y_lca->deadline = se_y_lca->vruntime + calc_delta_fair(se_y_lca->slice, se_y_lca);
> +	se_y_lca->vlag = avg_vruntime(cfs_rq_common) - se_y_lca->vruntime;

There is no point in setting vlag for a running entity

> +	update_min_vruntime(cfs_rq_common);

> This is the same update pattern used in update_curr(). The EEVDF
> relationship lag = (V - v) * w remains valid—vlag becomes more
> negative as vruntime increases.

Sure "V" just moves to the new avg_vruntime() to give the 0-lag
point but modifying the vruntime arbitrarily doesn't seem fair to
me.

> The presence of other runnable tasks
> doesn't affect the mathematical correctness; each entity's lag is
> computed independently relative to avg_vruntime.
> 
>>
>>>
>>>>                 se->deadline += calc_delta_fair(se->slice, se);
>>>> -       }
>>>> +
>>>> +               /*
>>>> +                * If we have more than one runnable task queued below
>>>> +                * this cfs_rq, the next pick will likely go for a
>>>> +                * different entity now that we have advanced the
>>>> +                * vruntime and the deadline of the running entity.
>>>> +                */
>>>> +               if (cfs_rq->h_nr_runnable > 1)
>>>
>>> Stopping at h_nr_runnable > 1 may not handle cross-cgroup yield_to()
>>> correctly. Shouldn't the penalty apply at the LCA of yielder and
>>> target? Otherwise the vruntime adjustment might not affect the level
>>> where they actually compete.
>>
>> So here is the case I'm going after - consider the following
>> hierarchy:
>>
>>      root
>>     /    \
>>   CG0   CG1
>>    |     |
>>    A     B
>>
>>   CG* are cgroups and, [A-Z]* are tasks
>>
>> A decides to yield to B, and advances its deadline on CG0's timeline.
>> Currently, if CG0 is eligible and CG1 isn't, pick will still select
>> CG0 which will in-turn select task A and it'll yield again. This
>> cycle repeates until vruntime of CG0 turns large enough to make itself
>> ineligible and route the EEVDF pick to CG1.
> 
> Yes, natural convergence works, but requires multiple cycles. Your
> h_nr_runnable > 1 stops propagation when another entity might be
> picked, but "might" depends on vruntime ordering which needs time to
> develop. Our penalty forces immediate ineligibility at the LCA. One
> penalty application vs N natural yield cycles.
> 
>>
>> Now consider:
>>
>>
>>        root
>>       /    \
>>     CG0   CG1
>>    /   \   |
>>   A     C  B
>>
>> Same scenario: A yields to B. A advances its vruntime and deadline
>> as a prt of yield. Now, why should CG0 sacrifice its fair share of
>> runtime for A when task B is runnable? Just because one task decided
>> to yield to another task in a different cgroup doesn't mean other
>> waiting tasks on that hierarchy suffer.
> 
> You're right that C suffers unfairly if it's independent work. This is
> a known tradeoff.

So KVM is only one of the user of yield_to(). This whole debouncer
infrastructure seems to be over complicating all this. If anything
is yielding across cgroup boundary - that seems like bad
configuration and if necessary, the previous suggestion does stuff
fairly. I don't mind accounting the lost time in
yield_to_task_fair() and account it to target task but apart from
that, I don't think any of it is "fair".

Again, maybe it is only me and everyone else sees the vision having
dealt with virtualization.

-- 
Thanks and Regards,
Prateek


