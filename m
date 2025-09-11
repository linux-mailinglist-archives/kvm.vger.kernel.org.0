Return-Path: <kvm+bounces-57276-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id D1BABB52879
	for <lists+kvm@lfdr.de>; Thu, 11 Sep 2025 08:07:09 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 7412C56811E
	for <lists+kvm@lfdr.de>; Thu, 11 Sep 2025 06:07:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0BF48178372;
	Thu, 11 Sep 2025 06:06:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="g5nA35sB"
X-Original-To: kvm@vger.kernel.org
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2047.outbound.protection.outlook.com [40.107.94.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9C1A7247280;
	Thu, 11 Sep 2025 06:06:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.94.47
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757570810; cv=fail; b=Ucdg/Ov5JuC7ATZkGiHr24j21zJ0QgzZThdt/HaSet7b53HFMe2jl5v3gVDhrmIVBXQjYH3kjb3P3gTxqWJdxkSi7+wH2mU5Fec5XH8B/FAGURmkxNYipCI3rnfRqdXA8m7VuaRUcy51/k+vs+koai4suvqJVpfmGLsTi9aaWfc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757570810; c=relaxed/simple;
	bh=iJzJftAaPgksThhZjb2bSC6PluMpBpeWQiiorYak+DU=;
	h=Message-ID:Date:MIME-Version:Subject:From:To:CC:References:
	 In-Reply-To:Content-Type; b=nHwdxvYHGZuSJ8Zy9ZK7Bp2iN7tIp/82NHbCV9y1TRpYDVz+o5H4ILhh7GAd97NRgFLqLzqIa9NkkjqEjgy17JA75Zdc7mWE0aM5DZ/mVRQ9YgaZ6MfFdVKS+aKZCDD1X+WMtblhwDSb0kEKLLRMvPKVCXsy+SDsaEf/eoL+8Gc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=g5nA35sB; arc=fail smtp.client-ip=40.107.94.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=apdEPG+SfBL3MfB9t5VGSstgXzTK7k2aqSPMTwxDBS9Kp6EDC0+OB4l9TDdRbxsIk96zBa9rQs9zx0baDkYqFB2sDTjmreDTDQbjO0DZ0PRa9PFhRq6mv7kZG02axv9O/BHFIK+7P/dKlvBzEh/UL2wMRFtUwTJOj9HDtnYTpa8RnzeSk+dPCKRYOFtzDzaTPD8V4f5pS69dhOsxp4YO2zB1jcLzzjURf/qJ7YuU+T+4qk5wiRVxer0vv2UxlKqFyFuJryQ3m16ig22oAtLqfUtHYvBcqSmjYrUeratvwtWV9brXVuBkZBdimbzINQytaDauINiGIpMt09X+p8myDQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=GgsY0MjSCfdx/ravmwalCP/xdo4Ft3nyVFSapPC9djo=;
 b=hvmfhh2UQGKPwULajN1pSvCsz5CDG/YdhMdxA1cZXiVS/HzVr73RyfYYW8Bgz8RR+xs82jbNv2qMlFTDZ/Et1hhZERSP3V1eRRtueoqWH3YNG8Q0EBgLzvr9gDxdtSphmccfuJ+4Z8WL6OuB5OQUC6pl5ngm28jEEo8p+/qGO/lk6CKUS2N//PdstJCRiYlBf+U4ekgXL3Jc3BJIn0ITiuazHKbNe8qr5W4KBQ1gBk+C1CvOCkLKpuP7jxIAcS0ZqTcuYuoheJgHrgvwUK0zhXepZJJsvXtwqILpTRfW+voUM2eZf6LptzxRap+flR/uNAiOCMV/5UYsj+PIE7eYgQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=linutronix.de smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=GgsY0MjSCfdx/ravmwalCP/xdo4Ft3nyVFSapPC9djo=;
 b=g5nA35sBhJEKVaJFCopwCkCshfCgWxUblZf8iyTXwav6teCmeTRg8VhYs+BZudnPVUME+p03BXSVuz6AIR7IhcREZg/llbZdnmKy9YQyhAZ/qH3AV8SVkIPrwIN9I8MlS3Ema6cAST+d+mTEKxu0EDCW1B/iGfyRicvb04gRAo8=
Received: from BY1P220CA0002.NAMP220.PROD.OUTLOOK.COM (2603:10b6:a03:59d::6)
 by CH2PR12MB4231.namprd12.prod.outlook.com (2603:10b6:610:7d::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9094.22; Thu, 11 Sep
 2025 06:06:44 +0000
Received: from SJ5PEPF000001D0.namprd05.prod.outlook.com
 (2603:10b6:a03:59d:cafe::a) by BY1P220CA0002.outlook.office365.com
 (2603:10b6:a03:59d::6) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9115.17 via Frontend Transport; Thu,
 11 Sep 2025 06:06:43 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb08.amd.com; pr=C
Received: from satlexmb08.amd.com (165.204.84.17) by
 SJ5PEPF000001D0.mail.protection.outlook.com (10.167.242.52) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9115.13 via Frontend Transport; Thu, 11 Sep 2025 06:06:43 +0000
Received: from satlexmb08.amd.com (10.181.42.217) by satlexmb08.amd.com
 (10.181.42.217) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.17; Wed, 10 Sep
 2025 23:06:43 -0700
Received: from [172.31.178.191] (10.180.168.240) by satlexmb08.amd.com
 (10.181.42.217) with Microsoft SMTP Server id 15.2.2562.17 via Frontend
 Transport; Wed, 10 Sep 2025 23:06:36 -0700
Message-ID: <e4a791dd-5189-4f32-a229-fa93ec9d9d5d@amd.com>
Date: Thu, 11 Sep 2025 11:36:30 +0530
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 1/4] x86/cpu/topology: Always try
 cpu_parse_topology_ext() on AMD/Hygon
From: K Prateek Nayak <kprateek.nayak@amd.com>
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
	Borislav Petkov <bp@alien8.de>, Dave Hansen <dave.hansen@linux.intel.com>,
	Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>,
	Jonathan Corbet <corbet@lwn.net>, <x86@kernel.org>
CC: Naveen rao <naveen.rao@amd.com>, Sairaj Kodilkar <sarunkod@amd.com>, "H.
 Peter Anvin" <hpa@zytor.com>, "Peter Zijlstra (Intel)"
	<peterz@infradead.org>, "Xin Li (Intel)" <xin@zytor.com>, Pawan Gupta
	<pawan.kumar.gupta@linux.intel.com>, <linux-kernel@vger.kernel.org>,
	<kvm@vger.kernel.org>, Mario Limonciello <mario.limonciello@amd.com>,
	"Gautham R. Shenoy" <gautham.shenoy@amd.com>, Babu Moger
	<babu.moger@amd.com>, Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
	<stable@vger.kernel.org>, Naveen N Rao <naveen@kernel.org>
References: <20250901170418.4314-1-kprateek.nayak@amd.com>
 <20250901170418.4314-2-kprateek.nayak@amd.com> <87o6rirrvc.ffs@tglx>
 <8a4272f7-0d22-43f0-993b-6d53172b7f65@amd.com>
Content-Language: en-US
In-Reply-To: <8a4272f7-0d22-43f0-993b-6d53172b7f65@amd.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ5PEPF000001D0:EE_|CH2PR12MB4231:EE_
X-MS-Office365-Filtering-Correlation-Id: 8dcd180b-2d30-4d81-6450-08ddf0f961fa
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|7416014|1800799024|82310400026|36860700013;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?QzVSWmJ3VU5nWWJmRlZjaTlKWjN1d3A3Tnh6eDVQdGpZR01xV08yczNSVVY1?=
 =?utf-8?B?UGJNK2dmR1R6TzZJRjY1bWgxa2hINVA4ZUpSTWxSTXpYS090ZjdXZTZUZSs0?=
 =?utf-8?B?L0R3M2FGRE1lRHdDOWx4OHNGZlZOelVRTXlFMUxxZlZLck9sUEhnVEN4aDN6?=
 =?utf-8?B?djNiL0RlclQyRFhWUDY4d2ZoUXRSYzZUTjBudFNQUWU5SHNSbWFBaDdXek9K?=
 =?utf-8?B?Vk9xeURjRjFFemxFMTF6T2Mzb1kvK1Rpb2d2L1NwR2pRREl0aW8yVkJIckZ0?=
 =?utf-8?B?blMzeU1IWXhhck5nQ2lsTlpocEFSNVlISFNUSDFEQnZkY3RCdVY5OVp3QzQw?=
 =?utf-8?B?U2kwSkk3bndxYlZjWHU0cjhNM0Y4bmYrMkQxd1RwRnYrM3NSbkQ2VUZUVkgw?=
 =?utf-8?B?L2dpcllzZmw4SXlSZUlQb2FMa2tBWXZJaTVwaG95U0NZVGFWc0FIQmJPKzdw?=
 =?utf-8?B?ampWL20rZGdHdnJiQWFLc242UWNKMUNxSW9SKzhGcER1d2ZWSVJJSjdWcW8w?=
 =?utf-8?B?c3o2a1FuTzBRZFdDeitsbENZeW5MamFYZG9ubEtHWnBxWHpBeldxSzRORkVB?=
 =?utf-8?B?ZmhEQ1JSa2M2WXg2YUdaYWNLaGUyeE1LendEN3VIUHIrNDNmVE85UHRvemw3?=
 =?utf-8?B?ajN6MXludkFScHVZODB5MUtyNEVncXpKNDN1U0NWUEZSbHNiOEExYkpWK0xO?=
 =?utf-8?B?NFprTmpPYnBVYzNFTzhQQ2NHdWUrNThFbVlFYUFKWklnUW5kTTQ1UFhZdFZC?=
 =?utf-8?B?WElwTzNYdzZJZE9oWDR5dUtGcVJoZTBwaTJ5emd2bzh0cDJnU1ZuUzBDWEJR?=
 =?utf-8?B?eDIxTk13R1BoNWordHhsSjhzQ2RTLzh5b2pSQ3VWbFkxM2tvVG0vV3RCdU1n?=
 =?utf-8?B?ZFpidE1BMTJPdHh0Rmp3OWFpQ2hVOGhWb3RWVkNvc2cvaFZUNncrQmxUZWlE?=
 =?utf-8?B?YXg5WTJLc3JlWmdiRnlHV3YwV29yQXB3NnhHV2ovZWFBbTYxSzV2SDRIMXJl?=
 =?utf-8?B?NmNzRmhiOVJ2aFpicFNaaXZNQ0o3SFdRWStvWWhrb3g5SlBBa25QMUc0NEJU?=
 =?utf-8?B?QlRnV1hybUp6ZnlobzVJc1UwR2dTakxRS1hGSUNTeEJGdlJGZzBxNmVkN3JG?=
 =?utf-8?B?TG5ueHFGbVNKYzNUYnRiczJPSTgwaTNGNkM2VXdERVBtN3MvZlIydytTczht?=
 =?utf-8?B?UHFlaUhSbjBNd0toUXBYVTViM1BtUll2VXdnWE9vbUFaZWE1YjQzbzVxdDdy?=
 =?utf-8?B?QUwxNUNONkx1akNVWU9kTDczaVhtZVlpYTVHZC9pVVR1SERXbUt6RVNTS2tE?=
 =?utf-8?B?alBneFBpaHcyNzdmZGtRNHNpa1d5YmdaTlJENjBtc2l1dnVxTEorVWo5K3pz?=
 =?utf-8?B?OFIxWjhZOGtkbU1nSlJKY1JCUGI1dC9sOUxpMXErMWI0cmZqOXhOTGlEck5j?=
 =?utf-8?B?SU1zRkUxZFpCeDh4cU1jWllCNlpoRnRQQkNnR2R4eEUwcWQxNzF3Nk9ra0ts?=
 =?utf-8?B?NHhKek5PWXdYTk92NUhhS0FwSURpUjNpRStSUDl0WVUvWUFkQ3N4cG5iL1A4?=
 =?utf-8?B?TnlLZjlyYy9SS1QxcEZ4TEUvMmtKZ3J3VHM1NzgvTlIvbmJwSnA3N2t4em9W?=
 =?utf-8?B?M0l0OFVKczk3UVpSWVNYczlFZVBIZ0hxUExyemtLUXZQV0h4QUtLSDBOMXE4?=
 =?utf-8?B?ekxiMWY3RFJON2FiWWZzcDI1ZUQ4bFNuWG84YkhYNTc1aldUeERlMnYwMkl4?=
 =?utf-8?B?dzhYQVdBQS95L0dDSU5WZThZM012dkhSUEdGeEZsRG9zaVBRRkE3QTVxUkQ2?=
 =?utf-8?B?aUtody9zUEFVa2NWbTFQSEpLckVuUVpVOUg5RTM4bDg0dDdPbktuNXc5R2hZ?=
 =?utf-8?B?VXFiY1NqWkJLbFBjd3J4dU5LK1pxdzFGdjFHMGxta0xRbGhmYkxrWHJKWmJi?=
 =?utf-8?B?Tm0rRFdXTEJ4b1U5N09Mazdpa1M3T0l0U0Vzcm93OWswcTNIK2MyK3BIa3ly?=
 =?utf-8?B?Rk5rSXhTMHg1a0xIVzNiYk1FMlZFQytOM1M4b0FabUNaTUkvOXlvZUJVLzFD?=
 =?utf-8?Q?Z3UDbK?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:satlexmb08.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(376014)(7416014)(1800799024)(82310400026)(36860700013);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Sep 2025 06:06:43.6455
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 8dcd180b-2d30-4d81-6450-08ddf0f961fa
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb08.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SJ5PEPF000001D0.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR12MB4231

On 9/11/2025 10:07 AM, K Prateek Nayak wrote:
>  		/*
> -		 * In case leaf B is available, use it to derive
> -		 * topology information.
> +		 * If the extended topology leaf 0xb leaf doesn't exits,
> +		 * derive CORE and DIE information from the 0x8000001e leaf.
>  		 */
> -		err = detect_extended_topology(c);
> -		if (!err)
> -			c->x86_coreid_bits = get_count_order(c->x86_max_cores);
> +		if (!has_extended_topology) {
> +			c->cpu_die_id  = ecx & 0xff;

Just noticed that we still need that "cpu_die_id" from 0x8000001e since
0xb on AMD does not implement the LEVEL_TYPE of DIE_TYPE (5).

> +
> +			if (c->x86 >= 0x17) {
> +				c->cpu_core_id = ebx & 0xff;
> +
> +				if (smp_num_siblings > 1)
> +					c->x86_max_cores /= smp_num_siblings;
> +			}
> +		}

-- 
Thanks and Regards,
Prateek


