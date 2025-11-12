Return-Path: <kvm+bounces-62844-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ams.mirrors.kernel.org (ams.mirrors.kernel.org [213.196.21.55])
	by mail.lfdr.de (Postfix) with ESMTPS id 5B1D6C50C30
	for <lists+kvm@lfdr.de>; Wed, 12 Nov 2025 07:50:59 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ams.mirrors.kernel.org (Postfix) with ESMTPS id D3D8034C1C1
	for <lists+kvm@lfdr.de>; Wed, 12 Nov 2025 06:50:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7C7DF28468D;
	Wed, 12 Nov 2025 06:50:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="Hraxjkrw"
X-Original-To: kvm@vger.kernel.org
Received: from PH7PR06CU001.outbound.protection.outlook.com (mail-westus3azon11010012.outbound.protection.outlook.com [52.101.201.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2A07A35CBC5;
	Wed, 12 Nov 2025 06:50:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.201.12
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762930250; cv=fail; b=bjXXM+mV7DdpnoHG2RsVPfxOS7YL3gK2k7QLgpFE5gIkj+DeoPxfadHVHHhyBDxXf2b0TUUuaEryphykqJ0JfYAMHCj/Vp2UTt3mTbRe77Ikh7Ft728ajYdVmOmlckN2SkWNQBMEKCUUBzb0LaBoF28WKTgYK9Wk5eKadft+VIE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762930250; c=relaxed/simple;
	bh=zlfA18QPFThNe1dIwGI+55AGNm9J1xZ8ttbiGB2qNa8=;
	h=Message-ID:Date:MIME-Version:Subject:To:CC:References:From:
	 In-Reply-To:Content-Type; b=aoCSAr32RVF2KEdBvFFKVAaTKH5HWj9p+y13CcEHfMcSd+kJFE14ZJ8DuVFZeFiUFA+gkDGCN600sDnzPOv98FtMnLjxPX3dF1ZGCynDo4p21MuJVpAcIInlRul8NIrmVW0a3aLtz3O3YNcTADwAZHc2athY10VbBkwD/6YM4Uo=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=Hraxjkrw; arc=fail smtp.client-ip=52.101.201.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=d+aHu0heeVBISA8TPY8QH68Dg4lmJEJA1Pq2ixcYsrIiX8XVYI2zJ3ljMcA6C0xobG5C9cVTNXUXC0CHxF5zr7y340K+bRhmzM7KkeaFBd+adlfAySudT2A3qjlpchBMn65WlsnmvGJcSgYXC88nYW42gvuT4+mMvMQ3sL+0B46Y23GM+TSPedKWvQbOfFROjvTOFvrCpgWVvSOqxO1CVRN+OLhMzjLjJmRbtE8NuTnV+Ee3U1IQhWwJfuhaNq5E70AJQhcazOLOXB/YEsd+Dc164BzoHxceerbK6k8Umvf/JIGchQfe3LObUykNfGZvVWKBPzkb7UXgZO4iuIPBxQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=4kz0u9OYwHqi6xvBKpOTV/rBre4PpPtFRzpgfCoZAqc=;
 b=FP8jwRaV2CFvX72Ca8GFu/yBQ9OaDxVhXr0ijFco9JpT8lYPeid99cG9oAoZGWvYA3spsnffH8DIeugOKasmz/80FKunvAgC6VcNiqHzYcRQ86waIPRjfzGGhDOWto5m2XECppcYCbSN910N6MtJ2MFYhJ6IJd2OLd63DhQb+8Ep98zfOBgBUQRwq4Nog12vnm9+tQNz9/ino2NnGEfKwxuxZVILiRhp5B0lwjCllS8HlON4+lPo1LHXdwQrTqvE4lU/mR9maTsO21gOygHYpxr23hza6wB2t/IY2L2W3AIMfGa7faiTAUDwVNm8Z76AE0FGkJBHLxM/8hfXXBFxNw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=gmail.com smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4kz0u9OYwHqi6xvBKpOTV/rBre4PpPtFRzpgfCoZAqc=;
 b=Hraxjkrw0/6mxuxWHof02+CWLIPuVL+FGYlnB89yi02iDLk9lKfUkzH/w4hvMfAyMv06mbBLLR8Y7nmlpQNopSe8ZFZG74/wZ1uypyIRDFEa1sNbJ54IyzKEjTELq9oN7/5MlTBfnecCzrgek4fXkMh2sn0JUgwJ7WDYKd+wtos=
Received: from DS7PR03CA0223.namprd03.prod.outlook.com (2603:10b6:5:3ba::18)
 by MW5PR12MB5684.namprd12.prod.outlook.com (2603:10b6:303:1a1::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9298.16; Wed, 12 Nov
 2025 06:50:41 +0000
Received: from CY4PEPF0000EDD7.namprd03.prod.outlook.com
 (2603:10b6:5:3ba:cafe::6a) by DS7PR03CA0223.outlook.office365.com
 (2603:10b6:5:3ba::18) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9298.13 via Frontend Transport; Wed,
 12 Nov 2025 06:50:41 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb08.amd.com; pr=C
Received: from satlexmb08.amd.com (165.204.84.17) by
 CY4PEPF0000EDD7.mail.protection.outlook.com (10.167.241.203) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9320.13 via Frontend Transport; Wed, 12 Nov 2025 06:50:40 +0000
Received: from SATLEXMB04.amd.com (10.181.40.145) by satlexmb08.amd.com
 (10.181.42.217) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.2.2562.17; Tue, 11 Nov
 2025 22:50:40 -0800
Received: from satlexmb07.amd.com (10.181.42.216) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Wed, 12 Nov
 2025 00:50:40 -0600
Received: from [172.31.184.125] (10.180.168.240) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server id 15.2.2562.17 via Frontend
 Transport; Tue, 11 Nov 2025 22:50:37 -0800
Message-ID: <74b13a0d-9f49-4a5d-8554-3e68be7cca88@amd.com>
Date: Wed, 12 Nov 2025 12:20:31 +0530
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 03/10] sched/fair: Add cgroup LCA finder for hierarchical
 yield
To: Wanpeng Li <kernellwp@gmail.com>, Peter Zijlstra <peterz@infradead.org>,
	Ingo Molnar <mingo@redhat.com>, Thomas Gleixner <tglx@linutronix.de>, "Paolo
 Bonzini" <pbonzini@redhat.com>, Sean Christopherson <seanjc@google.com>
CC: Steven Rostedt <rostedt@goodmis.org>, Vincent Guittot
	<vincent.guittot@linaro.org>, Juri Lelli <juri.lelli@redhat.com>,
	<linux-kernel@vger.kernel.org>, <kvm@vger.kernel.org>, Wanpeng Li
	<wanpengli@tencent.com>
References: <20251110033232.12538-1-kernellwp@gmail.com>
 <20251110033232.12538-4-kernellwp@gmail.com>
Content-Language: en-US
From: K Prateek Nayak <kprateek.nayak@amd.com>
In-Reply-To: <20251110033232.12538-4-kernellwp@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Received-SPF: None (SATLEXMB04.amd.com: kprateek.nayak@amd.com does not
 designate permitted sender hosts)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY4PEPF0000EDD7:EE_|MW5PR12MB5684:EE_
X-MS-Office365-Filtering-Correlation-Id: 3f4d77d4-c64a-4575-7719-08de21b7cb6e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|82310400026|7416014|376014|36860700013;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?dmhvZ3B4UnNBaFVaTm8wRDMzU1FvRTJGQnJmSTBvZ0ExZjdDYmhsZm91RXdQ?=
 =?utf-8?B?eWEwRTRGcms2SlRiN2RIWnlOckVYU0FDY05Qclp0TFhEZ0d0R3U4cHFCcFh1?=
 =?utf-8?B?WTNoS3N0N09oMFNodG8rc3VpLytBc3hjdmNtTnhkM254aUN3U3BnSkYyTERi?=
 =?utf-8?B?dDVvcUFUR0pleTF4LzNCdWRXQ01lUFJXVC82cWVQOFBPWXFKSTlJcjhyYXB0?=
 =?utf-8?B?N1FMT3FndHArK25JNVNXbWJPQVNPOS9sUk1xTVlOTlpWSG5TYUpERytDaElN?=
 =?utf-8?B?NDJGZEF2cjZyMmFUVjQ1b3U2YXNIMzhUTW84Z0V5MExsUHdZYWN2RnZnRXdi?=
 =?utf-8?B?aC9vbmRaZ3ZtNXZMdTZvL05kTzdzRGFRdmtpU2hFY0JKZ3hkaGNOK3d0UGg1?=
 =?utf-8?B?TitGamp0eGJ1NHRiSHk5OHo3U0o2UGF2NjljNWlEdUYwcTFMK24vR3lTMkN0?=
 =?utf-8?B?dFN3M2JYTEV6Z1hpNnVDTThpclZSZzNFc3JHOGVXZjNja05vb1pKZ1M3Mkdm?=
 =?utf-8?B?SW4wYXFqWXNPOWMyQXZOaTVFMnc1ekZSVlhKMzkvTEpvTkYvNFFoV0ZRYUEr?=
 =?utf-8?B?b2Q4Rm5xNnowNEFCYUgyMnlHWnlRRTRQNGpVbzRyV3g3c1NaM2RkNGRneFZu?=
 =?utf-8?B?UkZHQ05lSE9IS0prdk9TdnVyZzFTZ1VlTVA2OXZXbWtra3RyL3p6YlNxZDls?=
 =?utf-8?B?VVorQVVmY2EreUQwRFZUekZWTllqbDl4VGxxRXI1VlduQVZaNllMVHk0Qk41?=
 =?utf-8?B?TXhGeThYTW1pV0g1TWE1OVk5Wm4zeGNKYWlNZmJEUWVjK0lVdExOamI2UHh6?=
 =?utf-8?B?Zi82N2FMbUJNK2h6NElhaDlSaFZwUzVkWmJiL0d0cWEvanc4L3l2a3QvS09V?=
 =?utf-8?B?SERIUGJUVGxGN1FiekRFWjJJaHltbEVNMDRGWjBsYnFWc3RIODVQRVFIeC9H?=
 =?utf-8?B?Y0lFazBJejJYWllpY2FnRE1hZStLblRDNWIyTWFDZ3pxQjJqYmhDeEk1elRl?=
 =?utf-8?B?SXlpeHB4dVc5WWtIOWhVUkQzcE9Rc0ZBakI4d2hzZVZTRWQzR1BiNCs0S0Fs?=
 =?utf-8?B?SlpTcjVSd0NlWFNLditxRlNQTUxrZHJCK2N5MkxMSWtqcUQwWlU1ZVloajdL?=
 =?utf-8?B?N2FYd2hLRHMxbjRIV3I2MXJNeGdmMHZrSWtrMUFNVVYwV2dIZ1lqc2p0cmtR?=
 =?utf-8?B?dDJjOHN6MEZXMzAwS2NXM1ZVdmtBZ2dhN04rUUNjNlAxU1hWMmMxSm5ENk1l?=
 =?utf-8?B?bXZ1WExPMzVzMFRPenk4N0Y0aXBvOGN3RjVNNlF2bXl0Z05aYlR4NEx3Z3FH?=
 =?utf-8?B?UHVwYjI5YTlIOHRMcGdSU3JJQXlzQ1JKZ1BFS3ZRUXI5VzFHcGZqYzNyS3ky?=
 =?utf-8?B?UDVkTUZmbzUxSGJWRkFXRVAraTJ2d3I3THQ0YWFha3N5UjVYb2U5NGoxVUEw?=
 =?utf-8?B?R3drTjRNYzNCYUJ6TkczWmV0aHM5U0Y0d3ZzMWVDMDN3Rkg2M3hPUVphRE1z?=
 =?utf-8?B?a1FiWmE2R0NSb0llbjhnejhjWUtvUTJ6R2hHaHJtM1pUUUR2TDltOTJGSFVw?=
 =?utf-8?B?RHV5Tk55MmFJallCMndYSGtEVWdHdzVRR0RYeGdnV25pU1hIN255bG1INmtY?=
 =?utf-8?B?TktTSkpCYzI5Zk1NbENNY2xrdUF1K1hueWtmREpHbzZHL1M1QmFsdEE3U3ln?=
 =?utf-8?B?RnlrNnl6M2RxalMyU0ZNTllmK2g1YTRjell5T1lVTkcvV293UmN6QUNIN2dJ?=
 =?utf-8?B?WUU2S3dOWERycEdtRG1vSDg4Q1JuYmp6ajZ2TDZ0K3EwdStoN0lwd29GOUk4?=
 =?utf-8?B?aDcvRWtrRzZTUXZpVlJpRkt3WUpIYUg2TkNxMnNuNy9SMHI5WjVobWJ4dVhR?=
 =?utf-8?B?a1pvZitTRmhHNUpHNXRGN1lGV25UNkdwcjZ1OEtNaE5MRnI2SXlSOVNSaEps?=
 =?utf-8?B?Y0p4bTk1OXowdHpTOHgzM2dXd2JTcWxYRUY2cmQwOWxGZEkyc3YyWCtjTDRH?=
 =?utf-8?B?V2N2VXlMSEZCT2dvR3o3b1FXOC83Y0hyclMxL3UxWEN4NG9NbVlUQmxrcG1H?=
 =?utf-8?B?TmtPL1FnemFaWDJlQjJHaUJWbTFYeEJ5OFEydktwMXhjT2VydHA3VDlJNDBl?=
 =?utf-8?Q?/9cY=3D?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:satlexmb08.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(1800799024)(82310400026)(7416014)(376014)(36860700013);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Nov 2025 06:50:40.8063
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 3f4d77d4-c64a-4575-7719-08de21b7cb6e
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb08.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CY4PEPF0000EDD7.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW5PR12MB5684

Hello Wanpeng,

On 11/10/2025 9:02 AM, Wanpeng Li wrote:
> +/*
> + * Find the lowest common ancestor (LCA) in the cgroup hierarchy for EEVDF.
> + * We walk up both entity hierarchies under rq->lock protection.
> + * Task migration requires task_rq_lock, ensuring parent chains remain stable.
> + * We locate the first common cfs_rq where both entities coexist, representing
> + * the appropriate level for vruntime adjustments and EEVDF field updates
> + * (deadline, vlag) to maintain scheduler consistency.
> + */
> +static bool __maybe_unused yield_deboost_find_lca(struct sched_entity *se_y, struct sched_entity *se_t,
> +				    struct sched_entity **se_y_lca_out,
> +				    struct sched_entity **se_t_lca_out,
> +				    struct cfs_rq **cfs_rq_common_out)
> +{
> +	struct sched_entity *se_y_lca, *se_t_lca;
> +	struct cfs_rq *cfs_rq_common;
> +
> +#ifdef CONFIG_FAIR_GROUP_SCHED
> +	se_t_lca = se_t;
> +	se_y_lca = se_y;
> +
> +	while (se_t_lca && se_y_lca && se_t_lca->depth != se_y_lca->depth) {
> +		if (se_t_lca->depth > se_y_lca->depth)
> +			se_t_lca = se_t_lca->parent;
> +		else
> +			se_y_lca = se_y_lca->parent;
> +	}
> +
> +	while (se_t_lca && se_y_lca) {
> +		if (cfs_rq_of(se_t_lca) == cfs_rq_of(se_y_lca)) {
> +			cfs_rq_common = cfs_rq_of(se_t_lca);
> +			goto found_lca;
> +		}
> +		se_t_lca = se_t_lca->parent;
> +		se_y_lca = se_y_lca->parent;
> +	}
> +	return false;
> +#else
> +	if (cfs_rq_of(se_y) != cfs_rq_of(se_t))
> +		return false;
> +	cfs_rq_common = cfs_rq_of(se_y);
> +	se_y_lca = se_y;
> +	se_t_lca = se_t;
> +#endif
> +
> +found_lca:
> +	if (!se_y_lca || !se_t_lca)
> +		return false;

Can that even happen? They should meet at the root cfs_rq.
Also all of this seems to be just find_matching_se() from
fair.c. Can't we just reuse that?

> +
> +	if (cfs_rq_common->nr_queued <= 1)
> +		return false;
> +
> +	if (!se_y_lca->slice)
> +		return false;

Is that even possible?

> +
> +	*se_y_lca_out = se_y_lca;
> +	*se_t_lca_out = se_t_lca;
> +	*cfs_rq_common_out = cfs_rq_common;

Again, find_matching_se() does pretty much similar thing
and you can just use cfs_rq_of(se) to get the common cfs_rq.

> +	return true;
> +}
> +
>  /*
>   * sched_yield() is very simple
>   */

-- 
Thanks and Regards,
Prateek


