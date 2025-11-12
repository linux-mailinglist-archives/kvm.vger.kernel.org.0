Return-Path: <kvm+bounces-62860-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id D533AC50EAE
	for <lists+kvm@lfdr.de>; Wed, 12 Nov 2025 08:25:42 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 9657D1898465
	for <lists+kvm@lfdr.de>; Wed, 12 Nov 2025 07:26:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7E3BA2C0F7C;
	Wed, 12 Nov 2025 07:25:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="SGPiXibf"
X-Original-To: kvm@vger.kernel.org
Received: from DM5PR21CU001.outbound.protection.outlook.com (mail-centralusazon11011031.outbound.protection.outlook.com [52.101.62.31])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B7D3D19258E;
	Wed, 12 Nov 2025 07:25:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.62.31
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762932334; cv=fail; b=TOP88nXPWEyGdfLxEQXgK5LSzsSk7obYElBkTOMiwPtDHwpG9mfxur/55P/hK9mMCcMBm1qAPaBvJ0hYresdxE/TFAufaWqoRJGe62Lx8HNSt83BsbNzVmGDnKoIQsIf25ise6L1S2MR0gO47AMw7ggTHSu2NuX7cdSQ3YxZ4uw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762932334; c=relaxed/simple;
	bh=hv8RTcwl3RVtFERT/L2DkgeEgMIZlzZvJ8Pn4yRBYNo=;
	h=Message-ID:Date:MIME-Version:Subject:To:CC:References:From:
	 In-Reply-To:Content-Type; b=NxwYDEVPzvVddnTmjPDURxow875OTPQTf8hG/2LfHlgnGHoCb4CYoduYuwyAulsvVkej0CsIV/SA2AMdIGC4IWuKeLpPaocV3XPMIwpV4X12HGgEU/BFnIXzjzcVR8lzqAr8dSUZEhZnJOM1JtikwcnVF6Go2qtL3koznOW4uuQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=SGPiXibf; arc=fail smtp.client-ip=52.101.62.31
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ua7iMN5kZi5hhLNP52mN5gA8c8XCG2ByfIsrppM6qvsLqaeYNanqSZ3K57Oz/TyUknaHv2UO69/S5BMh6+akqEyEyNwP+y593ZSvtr2ctcqnSavtWD1G9K+FZ+o7NK48cyGQTHK5N+mJJFlOJ+jSCVaQv82t71tDlIELawlUDaqvJTrGiQBFBDEKywWfLw2GDoaPoYpeoQDgdkLAefd2GWYhYFIQcVQdEQDdJMf77bJ8h5sCRqGbmnozItCNHJT2Bv+X97UAKkAWs/VBzISbfMTku5mntp6s0cb97oI0CDtPuLg36x/oWsYwh+dOfcDCDf4yL6zkPUaDki6Oved0Gw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=zw9DaHdgSn/7dX6JVn8pKl6/Q3fG7EmvyRikmDlO/RU=;
 b=spWx/FYOsI9LyS4VOEriy0W9tkX1jsBbE1wgKOpgKKi5Rq1BGT9C5lhxm84pBjW0/5LBcyPprSjaFhw31PdiDbPovFfHEciKyVQeh+IGcQUTIRjUGMLBkGTdMYTt0E2GmtUuZ6fTy2FCV2dIeutOG0eDF9i7leh4EFgNscXCNOtFmbc2chkaPaQWcXIAepLVPAZOcPhAyZ3j8jugy3h+QOsereXqjmCEJ+GXiShAyO2n7KyDXJtSX5LOW4Enbk/l3U3ZFVIYGjx9noakuNUsjneKp3h4z/It6oXya15kGIWtvWyDhitGiuYtQ/M0Ctyz2NAFit88PnXB9gO4chGI6w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=gmail.com smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zw9DaHdgSn/7dX6JVn8pKl6/Q3fG7EmvyRikmDlO/RU=;
 b=SGPiXibfEfjT7i8yupOuG0RMV8GqIxHOTgoBQJRMckwwdVjqOwwiY8DxyqYtAhnkaCvL6h5+5FhhAgHE/CZdCtAZg44o62pKBtfVW17rBkfjmfiTBM8iyd0ANmVD7Jn6XudrVPvTzI2sgi1VW+UM7PpabUMfu+lWScw5k4PlMKw=
Received: from MW4PR03CA0085.namprd03.prod.outlook.com (2603:10b6:303:b6::30)
 by DS0PR12MB8365.namprd12.prod.outlook.com (2603:10b6:8:f8::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9320.15; Wed, 12 Nov
 2025 07:25:28 +0000
Received: from MWH0EPF000989EB.namprd02.prod.outlook.com
 (2603:10b6:303:b6:cafe::f6) by MW4PR03CA0085.outlook.office365.com
 (2603:10b6:303:b6::30) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9298.16 via Frontend Transport; Wed,
 12 Nov 2025 07:25:28 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb07.amd.com; pr=C
Received: from satlexmb07.amd.com (165.204.84.17) by
 MWH0EPF000989EB.mail.protection.outlook.com (10.167.241.138) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9320.13 via Frontend Transport; Wed, 12 Nov 2025 07:25:28 +0000
Received: from SATLEXMB05.amd.com (10.181.40.146) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.2.2562.17; Tue, 11 Nov
 2025 23:25:27 -0800
Received: from satlexmb07.amd.com (10.181.42.216) by SATLEXMB05.amd.com
 (10.181.40.146) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Wed, 12 Nov
 2025 01:25:27 -0600
Received: from [172.31.184.125] (10.180.168.240) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server id 15.2.2562.17 via Frontend
 Transport; Tue, 11 Nov 2025 23:25:24 -0800
Message-ID: <ef7d974e-7fcd-4e30-8a0d-8b97e00478bc@amd.com>
Date: Wed, 12 Nov 2025 12:55:23 +0530
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 04/10] sched/fair: Add penalty calculation and application
 logic
To: Wanpeng Li <kernellwp@gmail.com>, Peter Zijlstra <peterz@infradead.org>,
	Ingo Molnar <mingo@redhat.com>, Thomas Gleixner <tglx@linutronix.de>, "Paolo
 Bonzini" <pbonzini@redhat.com>, Sean Christopherson <seanjc@google.com>
CC: Steven Rostedt <rostedt@goodmis.org>, Vincent Guittot
	<vincent.guittot@linaro.org>, Juri Lelli <juri.lelli@redhat.com>,
	<linux-kernel@vger.kernel.org>, <kvm@vger.kernel.org>, Wanpeng Li
	<wanpengli@tencent.com>
References: <20251110033232.12538-1-kernellwp@gmail.com>
 <20251110033232.12538-5-kernellwp@gmail.com>
Content-Language: en-US
From: K Prateek Nayak <kprateek.nayak@amd.com>
In-Reply-To: <20251110033232.12538-5-kernellwp@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
Received-SPF: None (SATLEXMB05.amd.com: kprateek.nayak@amd.com does not
 designate permitted sender hosts)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MWH0EPF000989EB:EE_|DS0PR12MB8365:EE_
X-MS-Office365-Filtering-Correlation-Id: 59ebe526-c55a-4c37-917f-08de21bca7a2
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|1800799024|376014|36860700013|7416014;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?dzRmelFOU0FqUHdjbjg4MmhjTFY0Tk9GZmFURUhSaTlSSjNEbEVpVXpQWmM1?=
 =?utf-8?B?dTBVNTVBT0EySWcxR2YvYnZMTStMbEZGTUYxN0JVa0hvbThMOHlUNzFoZ1Jp?=
 =?utf-8?B?ZCtaeFZRaE9YNGEzVEtjS2kwRGZUSGxFemh2UUFUMklieXFWbTI1VDhMdFo5?=
 =?utf-8?B?dlo5SnJUVU1nMVI2K3NLTDQ1T2JYdmlFRXZZbFFWWFN0NTRpbHkwNGhQTFFr?=
 =?utf-8?B?WlNvZFc4bUtWNDcyT0xJRTByYzVZU3Mzc21XcCtzSFcxRXhTTTBWbWY4bjk3?=
 =?utf-8?B?d3dpbWZuUE50UEZtY0ttdkVDSTF0UExYcjhlRjV5ZmtNNUIra0hJdzRjWExI?=
 =?utf-8?B?dDhHMUxWT2ZkSjhHcm4xT0Z4VEY3TUpaMk9tcFZMRkxOcnkxQXM3T3BwQ2d6?=
 =?utf-8?B?dG8xdkV0Y0o3Z3FlYlZBY2FCb3NoR2EvVWpGOGE5N2VEWURFdW5yaDRTY3Fa?=
 =?utf-8?B?VTRPdXZ4Tm1qQ0JCT1RYcTgyenVEUHhjeEpFWkdFdVo2TXlWdjRFREhqMmZY?=
 =?utf-8?B?QTdZSG12V0Y0VVlQRno5eFYvRnYvU216TkpFbmNxUlFHVkpNY2IvL29RV3pV?=
 =?utf-8?B?QVVwR1RTRmMzNWNrZzU1UmpYaENZT2p6dzAxMWNaOUxObWFpenRjTVlQci90?=
 =?utf-8?B?U3pnQ3ByWHhHdFpzWXl4OUVZajMxbHRhNm41OGoxaDJ0YlJoL2JjQk1xMEdW?=
 =?utf-8?B?OUMySTNoSXRlK05WUmVRZlM4aFBPcnJ6RGY2RmpYKzdFU0Eyc05oR1VNWkl5?=
 =?utf-8?B?c1B5OGt5N3FvSTZvRXZrQWRqS3d2Vm9HbGkyS0ZYWXA0SHJzdUs4TnZnMUdX?=
 =?utf-8?B?eThRSjJoMklhdHZNb3FLbzZmQnc1QjFOWW85OGtPNnlnT0Q1MFFiQ3pOSTd0?=
 =?utf-8?B?OENBbmZ6WlhQT3pxNHp4TnprZ3h4VWx6MHhrMjVyc00vd3QxcTdyQUJZTlZo?=
 =?utf-8?B?VTM1eTBIa0EwRS9EeUFmM1lmblRiQnRITTBuRmhFc0RyZVF0MDYrYUVkZk8w?=
 =?utf-8?B?dFhXaWhIclNRVnBBZERJSlNVOFdmQnNIMmFiT1FxUitGRzBKQUF3NDJvNkhG?=
 =?utf-8?B?TVpFaHd4ZERYdUZRb3VRZnZMOExvUjlCaHNGc28vMEo5WFQ4VjBnRUVJeHJq?=
 =?utf-8?B?VFVlSGdFVjc4QVo3MW85QVlQTFpJR2JhQ0pFNVkxQXpldlBYWkVLTTlpNkdj?=
 =?utf-8?B?YUcwTTVvR2NVZUpYSUtPTDJHUTlhMlROZmhtb3FTRFNCeFFieFJvRXV4ZFdD?=
 =?utf-8?B?L1NpRnFDeGswdU1wdWt6Z05vcUJxTTVVanVTMU1mRVhrd3M3NE1NZ1hqeXJs?=
 =?utf-8?B?NWNGTnI2bTVua3llakt2MEFDNUVXZFVBNEhBK0JucStWQWkwS3llMVh0RlUx?=
 =?utf-8?B?MXl6bmxQQWxFREhzTDNaS2pMaFMyWmFUTHZMcGs5Q0h4TjBXazlyOGJvcTVx?=
 =?utf-8?B?TFR2VjRSZVl6THhKTEUvQmpaZVBUUGNlR2R3R0hJK0FqcGQyZXBUM1J4aE9w?=
 =?utf-8?B?MWhkaTJ4aHlLM3FycGNwbU0yMUJRb0xsVnpHS2dUeDRxeGRQK3dRZHJLUXpk?=
 =?utf-8?B?Nnd4dUp2QzBDVG4wd1ZibUFNVUVHajVzSVlzRldtbU5vaEhzTEdHL0E3bm5y?=
 =?utf-8?B?czF0czZvNmJOTzc0b2VXYzZtQmgzbFhWMmZCTUVFU1lIUXM2U1ZuSUNyZENv?=
 =?utf-8?B?K09LZVR0aGdSK3hlcnRpQ3lPWmpOWjJYTG1jRHJiZmI1ZEJ1bThrck5nS3pn?=
 =?utf-8?B?TDZZdXBQUzlhZEdhbm1tTWNya3NqU3VpTFQ3MllQT1pYdExreWJxTHdtejJY?=
 =?utf-8?B?QXdrT2JHRDRSdXMyZExESkt2VHI4TW9oNVBGYVEydmppZzFEeUNXLytCTy84?=
 =?utf-8?B?V0JNUS9nRlZYT2JKcTFPYnJ5MGRHUG95ZWpqbzdDdWY1NVJXakZ0Ty9kL3dU?=
 =?utf-8?B?OXQzY2RKTVlSbWY5SEd3Zm9CeVY1d3JMVUFyK0s1K3YwbUpQRTdjekEwMENP?=
 =?utf-8?B?Vk44eWJGckhqMTZPWjdoWUxTbmU1Z2Nzb3NET1lSTWZlNHVDR0h6SGozeTB1?=
 =?utf-8?B?c3FoMzdPMDZLbEliK1E2Q25kcFRFY3pXUU5qR0JDd2VQVEdiQkp0UC90cURF?=
 =?utf-8?Q?zwFc=3D?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:satlexmb07.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(82310400026)(1800799024)(376014)(36860700013)(7416014);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Nov 2025 07:25:28.1879
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 59ebe526-c55a-4c37-917f-08de21bca7a2
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb07.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	MWH0EPF000989EB.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR12MB8365

Hello Wanpeng,

On 11/10/2025 9:02 AM, Wanpeng Li wrote:
> +/*
> + * Calculate penalty with debounce logic for EEVDF yield deboost.
> + * Computes vruntime penalty based on fairness gap (need) plus granularity,
> + * applies queue-size-based caps to prevent excessive penalties in small queues,
> + * and implements reverse-pair debounce (~300us) to reduce ping-pong effects.
> + * Returns 0 if no penalty needed, otherwise returns clamped penalty value.
> + */
> +static u64 __maybe_unused yield_deboost_calculate_penalty(struct rq *rq, struct sched_entity *se_y_lca,
> +				    struct sched_entity *se_t_lca, struct sched_entity *se_t,
> +				    int nr_queued)
> +{
> +	u64 gran, need, penalty, maxp;
> +	u64 gran_floor;
> +	u64 weighted_need, base;
> +
> +	gran = calc_delta_fair(sysctl_sched_base_slice, se_y_lca);
> +	/* Low-bound safeguard for gran when slice is abnormally small */
> +	gran_floor = calc_delta_fair(sysctl_sched_base_slice >> 1, se_y_lca);
> +	if (gran < gran_floor)

Is this even possible?

> +		gran = gran_floor;
> +
> +	need = 0;
> +	if (se_t_lca->vruntime > se_y_lca->vruntime)
> +		need = se_t_lca->vruntime - se_y_lca->vruntime;

So I'm assuming you want the yielding task's vruntime to
cross the target's vruntime simply because one task somewhere
down the hierarchy said so.

> +
> +	/* Apply 10% boost to need when positive (weighted_need = need * 1.10) */
> +	penalty = gran;

So at the very least I see it getting weighted(base_slice / 2) penalty
... 

> +	if (need) {
> +		/* weighted_need = need + 10% */
> +		weighted_need = need + need / 10;
> +		/* clamp to avoid overflow when adding to gran (still capped later) */
> +		if (weighted_need > U64_MAX - penalty)
> +			weighted_need = U64_MAX - penalty;
> +		penalty += weighted_need;

... if not more ...

> +	}
> +
> +	/* Apply debounce via helper to avoid ping-pong */
> +	penalty = yield_deboost_apply_debounce(rq, se_t, penalty, need, gran);

... since without debounce, penalty remains same.

> +
> +	/* Upper bound (cap): slightly more aggressive for mid-size queues */
> +	if (nr_queued == 2)
> +		maxp = gran * 6;		/* Strongest push for 2-task ping-pong */
> +	else if (nr_queued == 3)
> +		maxp = gran * 4;		/* 4.0 * gran */
> +	else if (nr_queued <= 6)
> +		maxp = (gran * 5) / 2;		/* 2.5 * gran */
> +	else if (nr_queued <= 8)
> +		maxp = gran * 2;		/* 2.0 * gran */
> +	else if (nr_queued <= 12)
> +		maxp = (gran * 3) / 2;		/* 1.5 * gran */
> +	else
> +		maxp = gran;			/* 1.0 * gran */

And all the nr_queued calculations are based on the entities queued
and not the "h_nr_queued" so we can have a boat load of tasks to
run above but since one task decided to call yield_to() let us make
them all starve a little?

> +
> +	if (penalty < gran)
> +		penalty = gran;
> +	if (penalty > maxp)
> +		penalty = maxp;
> +
> +	/* If no need, apply refined baseline push (low risk + mid risk combined). */
> +	if (need == 0) {
> +		/*
> +		 * Baseline multiplier for need==0:
> +		 *   2        -> 1.00 * gran
> +		 *   3        -> 0.9375 * gran
> +		 *   4–6      -> 0.625 * gran
> +		 *   7–8      -> 0.50  * gran
> +		 *   9–12     -> 0.375 * gran
> +		 *   >12      -> 0.25  * gran
> +		 */
> +		base = gran;
> +		if (nr_queued == 3)
> +			base = (gran * 15) / 16;	/* 0.9375 */
> +		else if (nr_queued >= 4 && nr_queued <= 6)
> +			base = (gran * 5) / 8;		/* 0.625 */
> +		else if (nr_queued >= 7 && nr_queued <= 8)
> +			base = gran / 2;		/* 0.5 */
> +		else if (nr_queued >= 9 && nr_queued <= 12)
> +			base = (gran * 3) / 8;		/* 0.375 */
> +		else if (nr_queued > 12)
> +			base = gran / 4;		/* 0.25 */
> +
> +		if (penalty < base)
> +			penalty = base;
> +	}
> +
> +	return penalty;
> +}
> +
> +/*
> + * Apply penalty and update EEVDF fields for scheduler consistency.
> + * Safely applies vruntime penalty with overflow protection, then updates
> + * EEVDF-specific fields (deadline, vlag) and cfs_rq min_vruntime to maintain
> + * scheduler state consistency. Returns true on successful application,
> + * false if penalty cannot be safely applied.
> + */
> +static void __maybe_unused yield_deboost_apply_penalty(struct rq *rq, struct sched_entity *se_y_lca,
> +				 struct cfs_rq *cfs_rq_common, u64 penalty)
> +{
> +	u64 new_vruntime;
> +
> +	/* Overflow protection */
> +	if (se_y_lca->vruntime > (U64_MAX - penalty))
> +		return;
> +
> +	new_vruntime = se_y_lca->vruntime + penalty;
> +
> +	/* Validity check */
> +	if (new_vruntime <= se_y_lca->vruntime)
> +		return;
> +
> +	se_y_lca->vruntime = new_vruntime;
> +	se_y_lca->deadline = se_y_lca->vruntime + calc_delta_fair(se_y_lca->slice, se_y_lca);

And with that we update vruntime to an arbitrary value simply
because one task in the hierarchy decided to call yield_to().

Since we are on the topic, you are also missing an update_curr()
which is only done in yield_task_fair() so you are actually
looking at old vruntime for the yielding entity.

> +	se_y_lca->vlag = avg_vruntime(cfs_rq_common) - se_y_lca->vruntime;
> +	update_min_vruntime(cfs_rq_common);
> +}
> +
>  /*
>   * sched_yield() is very simple
>   */

-- 
Thanks and Regards,
Prateek


