Return-Path: <kvm+bounces-62842-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 49D01C50BF1
	for <lists+kvm@lfdr.de>; Wed, 12 Nov 2025 07:43:00 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id D572A3A57FE
	for <lists+kvm@lfdr.de>; Wed, 12 Nov 2025 06:40:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D081C2DF15A;
	Wed, 12 Nov 2025 06:40:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="Irb6LUYv"
X-Original-To: kvm@vger.kernel.org
Received: from CY7PR03CU001.outbound.protection.outlook.com (mail-westcentralusazon11010003.outbound.protection.outlook.com [40.93.198.3])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 50B5323D7D7;
	Wed, 12 Nov 2025 06:40:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.93.198.3
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762929625; cv=fail; b=ezmBJV8pYfhF3PoDSXyB55STw2ngvT86tcGxAxvTHb4Yx8a8ps9zzqO9y+Z8dflpxy/kk0T/ehzE4V0xDaXh5xkGbBrkRx5xcXd8oH+ynLpdWZC3EgqepmjCrPs1LuxsmPWC75x/3ezXk6zAFyXjeWNOikusrtJBxJX1xJJMnus=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762929625; c=relaxed/simple;
	bh=CFpjrTn0SC1Zbh+4bMXR6VX8alLERexWRSfVZi68+DQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:CC:References:From:
	 In-Reply-To:Content-Type; b=q6gEiGryvb9uBA7fuA6eJYgvMuLjDJ0dx6vygWcFakXMeeWpZxdJw4+OGBidTvfhwXAE9WqHPP1iw+AiQ9oUddTHMt1nM/g++Wx6vEv+RN4aq7H6s0JMo8Ial6uar5LXSHG7WzJY9NbqrynZIHaf88tG87Bs67MD4qzJOklolWY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=Irb6LUYv; arc=fail smtp.client-ip=40.93.198.3
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=gWPd7bdpWZUOd/jSjUJLBn+4VmzwnizrkRhQuhqoyMwqmPTjS01U0v+uE/8/7ORzKK4M/Gbrt91uR+7p7qQwT2r6xrqBpd9uQwMn7/K799SefKkRd/NCunl5NqkLUEpdfXZW3Enzojl4Nzrrl2NrPnsLDdOHGsiJZBgStsRs6kAsgeMXCl2Czh+ksRDQyIgcNmNc2lqCSIQyEVvM1BLixIglAqrSMpaCqIOjhpmbA1DBWx/0KXYn2VKFEm9q7JWYqJ/bE76FF8l2WjGyA4lwq7PjzoWYNRlPHe9XfDFHKcy1OQvccbI8PCg4qkFQlToMCfgSs9Mcy8DAlDyhZTEqpA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=uZP6kwpcudXUkUA7O9pKuv3YvBRwOyJO2zOB/TWeIEI=;
 b=yun/7EvQxC1T5cI63+ceHNwMbn5ORhbOWLgHMKu5wGkZn9m80kXmwFyM4wEF+Bcn6Y3jUZLvVN9PFY/ZpYs25qsYUcoAJ13Gn0XjqFVOfd9cDpXCQJBu/zyxwxq5b1o10+6C27OgQ/sipEnK8kf8gCgBDFTKmklQwpuSBQrQgImq5vM2y5tIz8ID9Vh9uXXQTUH7Js+ji5oI1TztmTg55Uu+Fnsr4/jZQ+rA0n7OfhxTOEsgpMxuLw5pmtRc/M5vQh+P8IF6+fx6UyvlrdbFRyr62UwHwcEaO4rdnKq1EaS2MbiBBUP0WlOsTezAiBN9NmsHy5SMYHziumOvvSlk4g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=gmail.com smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=uZP6kwpcudXUkUA7O9pKuv3YvBRwOyJO2zOB/TWeIEI=;
 b=Irb6LUYvToZR9KIE9nUsivY+rAUgVTfzO27lBMvMafCZ0HUN/USq6vRnsUi76dNiROBRhvKVlMdpqx/lKOtHiuyehQ/fIfXgX448gbgJHXMmzBRAFdN1Mp3V5DqjV1d9Yd9HPtVfPadcnaN3WgOTsns0IgY+upJooL2Dpp/PH4w=
Received: from SJ0PR05CA0024.namprd05.prod.outlook.com (2603:10b6:a03:33b::29)
 by MW6PR12MB8897.namprd12.prod.outlook.com (2603:10b6:303:24a::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9298.16; Wed, 12 Nov
 2025 06:40:20 +0000
Received: from SJ1PEPF000026CA.namprd04.prod.outlook.com
 (2603:10b6:a03:33b:cafe::86) by SJ0PR05CA0024.outlook.office365.com
 (2603:10b6:a03:33b::29) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9320.15 via Frontend Transport; Wed,
 12 Nov 2025 06:40:20 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb08.amd.com; pr=C
Received: from satlexmb08.amd.com (165.204.84.17) by
 SJ1PEPF000026CA.mail.protection.outlook.com (10.167.244.107) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9320.13 via Frontend Transport; Wed, 12 Nov 2025 06:40:20 +0000
Received: from satlexmb10.amd.com (10.181.42.219) by satlexmb08.amd.com
 (10.181.42.217) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.17; Tue, 11 Nov
 2025 22:40:19 -0800
Received: from satlexmb07.amd.com (10.181.42.216) by satlexmb10.amd.com
 (10.181.42.219) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.17; Tue, 11 Nov
 2025 22:40:19 -0800
Received: from [172.31.184.125] (10.180.168.240) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server id 15.2.2562.17 via Frontend
 Transport; Tue, 11 Nov 2025 22:40:16 -0800
Message-ID: <015bfa4d-d89c-4d4e-be06-d6e46aec28cb@amd.com>
Date: Wed, 12 Nov 2025 12:10:15 +0530
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 02/10] sched/fair: Add rate-limiting and validation
 helpers
To: Wanpeng Li <kernellwp@gmail.com>, Peter Zijlstra <peterz@infradead.org>,
	Ingo Molnar <mingo@redhat.com>, Thomas Gleixner <tglx@linutronix.de>, "Paolo
 Bonzini" <pbonzini@redhat.com>, Sean Christopherson <seanjc@google.com>
CC: Steven Rostedt <rostedt@goodmis.org>, Vincent Guittot
	<vincent.guittot@linaro.org>, Juri Lelli <juri.lelli@redhat.com>,
	<linux-kernel@vger.kernel.org>, <kvm@vger.kernel.org>, Wanpeng Li
	<wanpengli@tencent.com>
References: <20251110033232.12538-1-kernellwp@gmail.com>
 <20251110033232.12538-3-kernellwp@gmail.com>
Content-Language: en-US
From: K Prateek Nayak <kprateek.nayak@amd.com>
In-Reply-To: <20251110033232.12538-3-kernellwp@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ1PEPF000026CA:EE_|MW6PR12MB8897:EE_
X-MS-Office365-Filtering-Correlation-Id: 912e5b33-b0a6-45ce-366b-08de21b659bd
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|376014|36860700013|82310400026|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?QmFwZmxnN0haRXlOQStXbStCU1lPV1dTcUJnQWlEWDRxNGJMV0l3d283OWgw?=
 =?utf-8?B?WTV5R1lOWlhSeWpXSWNVeFJZYncrdjBNV2ZZaVpwRWZnaHE4Zm9uaWl4SDU5?=
 =?utf-8?B?SWJCWU5jYU4rbm00OEliemlDZE1keGJUZERjS1Z0bHgrR0p5bFc2VlcrbEFn?=
 =?utf-8?B?NXYyaVU5VTN4aTRnNDFUYnJzKzg5dm9yK0g2OFA1aXZ5Zk5WaGdiaWdyODdt?=
 =?utf-8?B?ZzBwK3NBNjFjbDl6eWNmSVdsZHBQNVpIbkluS0NOYTNRY1M0RUZSMUpOUGZt?=
 =?utf-8?B?bGNTQVJ1cmErZ3A3dzh2NW9nM3g4SlI5T25WNnBiemJLeFdiWnFXZDNJR0Vs?=
 =?utf-8?B?ak5jenB0WmMrY3VOTUJ4Yk8zVTYyY2xVbzg1MGZSbm54WFMveXVPRXNmS2Zj?=
 =?utf-8?B?eU9YL1JmRTM5TldEOUpwZFFTVTl0WFMwd3pOSVgyMkxtcTFXclBYeGp2QmRS?=
 =?utf-8?B?bkxHTDJaWW5hT2lBazd2OG1zQmp5cmpwSUdUa0dPOUQrVDBWSEhQTklyam83?=
 =?utf-8?B?M0w2ZFZMdWRUUi9QMFhBeWFObElYZ0JuZWM2SHhTdWJmZWs3dW1nV1d5N0Y1?=
 =?utf-8?B?aURRVnZhYlVwSXNTZVdBODczWkgrQVkzL2NLVVRGVHpLK0wwN2dtVFFyTXNo?=
 =?utf-8?B?YnhYNlpGZXdrcmE2WDFHYm82SnZ0WnJWVU9BK2J3RmZkcEJaZGw0QUJqUTBL?=
 =?utf-8?B?UzRpZUhhLzFiNFo1T0ZHTDM3S2NKdnlOaFo5WVkzcUY2Ri8xVXByUmpLNDB4?=
 =?utf-8?B?NmxORWkyLzdHanJnZmtOMGVIRFBQM0FXY04rODZwam1GYkxITS9FVUFGT0ww?=
 =?utf-8?B?bDVuRTlMWWVVZXVBRkV3OTZzTll6aFZRbHowaXh1d3dGNE93QytQaFdCbEsx?=
 =?utf-8?B?dzFUVGtzdHJNVStYR0YzSG5SWndNbGg5Wlc0WTJ3Z0NEZm1VQnRDb01zMEVT?=
 =?utf-8?B?OTYzYUZYYWswWXQzampFQVBPaHR3b050NmU2ZUtyKzNhR2txZmZOZ0NvZ0Mr?=
 =?utf-8?B?T0dLZVFSU0hWWlFWMER6WFQ0WHdFdlJITkY5clY4TUdJRVVUc3RvOU03aHNr?=
 =?utf-8?B?Sm85ZEZTcU1kRENiMWxMWTN5bCtIaXpzRzJicjJZUVZqRnVJbllRUnc1SytX?=
 =?utf-8?B?QVAwUzV1Qk1ZOTgyelA2WU15OElRTXFiNllLcUt0M3hPSHFLQ1ZXZzRzV0Vu?=
 =?utf-8?B?SEthdkJHSVkxYmZUTldvTlRQclozaVloVVAvTUg2RzhKV3F0dWRSUFR2a0Ji?=
 =?utf-8?B?R3ZpMklDMm9tcHhNT3VXeFUvSWMwTjJNR0Qvb29oNkp6RVBwWG5hNTc0WkZJ?=
 =?utf-8?B?K0NkOUN1QXB0VHZVQTdaMjMwNW1tdWczaGNlS2hjYVRtbEFEOUdTSW4rc2hj?=
 =?utf-8?B?eWpHNU1kamQwVTVuaXl1dlJzTlI1STJlUGgzeHB1SjUxcnAxWFp4Zk5wcktI?=
 =?utf-8?B?OXQ4N1lBelowZytEczhTTi9FZ3o2RFdFMVByZ1pMa2h1dkl4Tnd6dnc1Y1lI?=
 =?utf-8?B?MEJpaW9aalhOVWEwZzBXQ3V1dFRlSDBIbnduM3ExSzBuQnlPOEFHbXlGTU5h?=
 =?utf-8?B?TjNTMWpuVDR1NlFFZG1rcnU0UUlFU3o3QU1uZHRoT3JuS0NqUmQwVkZlRHdG?=
 =?utf-8?B?WHdIcG1WbTZ3S2xMU25pVGE3Z0xtMnV3dld4c0l4V3B2MExhaUVIYVJUdUVO?=
 =?utf-8?B?aUV5U0w1OVZjZ0gzalZiL0o3TnFXNlRybEduSitZL3hqd3VhTG1FcVJsNjlV?=
 =?utf-8?B?enZzMHVLU3haUEEwNFFObHEybytIWDhENFZ3c1B6aUxvbm1DN2pnemU5eDFR?=
 =?utf-8?B?eXpXZ0tYQllNeHhpZS8xakh2K0FvU0t3dXJRbWw4SXRkcDRMTUZ4Z212dGUx?=
 =?utf-8?B?cTJ6S1NObCtGZERtOTdMa3FhQ1M4L2NxRzNOWnh0VlBUc1hZZStUTm5JdFlI?=
 =?utf-8?B?Z2plREE2cVVVM096RnhjZVJTTnF5L0lJNDM2UnJVMDVJSjN5MFNHblFtQlBL?=
 =?utf-8?B?SFd0d1R4akdUVHdLWmJEVlJSMVNmMFFQa21ScUEvaTV2ZlhKZjJRdWpVdDJh?=
 =?utf-8?B?OXd2clFNK1VqSWpiS1FEM0cvZWtZVUY1TDZHOFk2bG9XMEZyL0M3R2tZSzg2?=
 =?utf-8?Q?gWDg=3D?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:satlexmb08.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(7416014)(376014)(36860700013)(82310400026)(1800799024);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Nov 2025 06:40:20.5165
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 912e5b33-b0a6-45ce-366b-08de21b659bd
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb08.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SJ1PEPF000026CA.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW6PR12MB8897

Hello Wanpeng,

On 11/10/2025 9:02 AM, Wanpeng Li wrote:
> +/*
> + * High-frequency yield gating to reduce overhead on compute-intensive workloads.
> + * Returns true if the yield should be skipped due to frequency limits.
> + *
> + * Optimized: single threshold with READ_ONCE/WRITE_ONCE, refresh timestamp on every call.
> + */
> +static bool yield_deboost_rate_limit(struct rq *rq, u64 now_ns)
> +{
> +	u64 last = READ_ONCE(rq->yield_deboost_last_time_ns);
> +	bool limited = false;
> +
> +	if (last) {
> +		u64 delta = now_ns - last;
> +		limited = (delta <= 6000ULL * NSEC_PER_USEC);
> +	}
> +
> +	WRITE_ONCE(rq->yield_deboost_last_time_ns, now_ns);

We only look at local rq so READ_ONCE()/WRITE_ONCE() seems
unnecessary.

> +	return limited;
> +}
> +
> +/*
> + * Validate tasks and basic parameters for yield deboost operation.
> + * Performs comprehensive safety checks including feature enablement,
> + * NULL pointer validation, task state verification, and same-rq requirement.
> + * Returns false with appropriate debug logging if any validation fails,
> + * ensuring only safe and meaningful yield operations proceed.
> + */
> +static bool __maybe_unused yield_deboost_validate_tasks(struct rq *rq, struct task_struct *p_target,
> +					  struct task_struct **p_yielding_out,
> +					  struct sched_entity **se_y_out,
> +					  struct sched_entity **se_t_out)
> +{
> +	struct task_struct *p_yielding;
> +	struct sched_entity *se_y, *se_t;
> +	u64 now_ns;
> +
> +	if (!sysctl_sched_vcpu_debooster_enabled)
> +		return false;
> +
> +	if (!rq || !p_target)
> +		return false;
> +
> +	now_ns = rq->clock;

Brief look at Patch 5 suggests we are under the rq_lock so might
as well use the rq_clock(rq) helper. Also, you have to do a
update_rq_clock() since it isn't done until yield_task_fair().

> +
> +	if (yield_deboost_rate_limit(rq, now_ns))
> +		return false;
> +
> +	p_yielding = rq->curr;
> +	if (!p_yielding || p_yielding == p_target ||
> +	    p_target->sched_class != &fair_sched_class ||
> +	    p_yielding->sched_class != &fair_sched_class)
> +		return false;

yield_to() in syscall.c has already checked for the sched
class matching under double_rq_lock. That cannot change by the
time we are here.

> +
> +	se_y = &p_yielding->se;
> +	se_t = &p_target->se;
> +
> +	if (!se_t || !se_y || !se_t->on_rq || !se_y->on_rq)
> +		return false;
> +
> +	if (task_rq(p_yielding) != rq || task_rq(p_target) != rq)

yield_to() has already checked for this under double_rq_lock()
so this too should be unnecessary.

> +		return false;
> +
> +	*p_yielding_out = p_yielding;
> +	*se_y_out = se_y;
> +	*se_t_out = se_t;

Why do we need these pointers? Can't the caller simply do:

    if (!yield_deboost_validate_tasks(rq, target))
        return;

    p_yielding = rq->donor;
    se_y_out = &p_yielding->se;
    se_t = &target->se;

That reminds me - now that we have proxy execution, you need
to re-evaluate the usage of rq->curr (running context) vs
rq->donor (vruntime context) when looking at all this.

> +	return true;
> +}
> +
>  /*
>   * sched_yield() is very simple
>   */

-- 
Thanks and Regards,
Prateek


