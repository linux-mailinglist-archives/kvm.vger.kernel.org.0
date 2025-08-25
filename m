Return-Path: <kvm+bounces-55605-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 307DBB33A16
	for <lists+kvm@lfdr.de>; Mon, 25 Aug 2025 11:03:46 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id E8DD217929C
	for <lists+kvm@lfdr.de>; Mon, 25 Aug 2025 09:03:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4DF332BE020;
	Mon, 25 Aug 2025 09:03:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="bxjVZCKR"
X-Original-To: kvm@vger.kernel.org
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2075.outbound.protection.outlook.com [40.107.236.75])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BF5E22417E6;
	Mon, 25 Aug 2025 09:03:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.236.75
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756112614; cv=fail; b=J5CjwHa6qrMnCjEJfT2Jqx+I8KdasW4rg72nwcr7/Y7tvdS4hOhStja5BD0ArOMHy8h4GO1CFOh3HYmXb7ZZlAKHyQxpO3tvV/Z4mLFzfCrm8dK6GYv5HAEgmR405kToV0QP36Sl+yswDp7oYj6IEDi/cu/gE0PzDZGLYGETsno=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756112614; c=relaxed/simple;
	bh=LAUqRm5+6MRiuLzpYxy48pwkG/HmahHgSOYakMfY79k=;
	h=Message-ID:Date:MIME-Version:Subject:To:CC:References:From:
	 In-Reply-To:Content-Type; b=Q0M9guZLKwcX/bM2hOhuYjx5BlTPfP2aXrXIDWUES5ulRjOtslwzwYnvzLRtyeNd3Cxx7SrJJIas7OvXb5wGbIZSDMOFbhQgvHwMKl1nfDIlICs1bopy3w0d6+N6JUeB3d9NVKFOdj7g8rkMLjHvd/6rDNTO6ctwpxEVU3Egyy0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=bxjVZCKR; arc=fail smtp.client-ip=40.107.236.75
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=HEMA4sXhHAWJXCBR3dxShA2QZdRKs7tK5mBvPBLNM/++g+/ypBpVdoqdP3bCfWHTNk9K/hc+i6We6tvrJmGqy2UADIhXSn8Sa7bwgurg9k+TH5GzOF1S/rF9JgWcnuEv0e3dJ5W4ZejdSL4EmsSrXhj8tQuEgQZbjyrxktBU7n3l+FWUejBasOFv15+KxJMcSUiV5nuI5aoxpt3gFsgLFdzacCDZxTAuoPfsRwIR2De5SWJIwFzDtI5zJjO3/1rOpgKefYJOG1UL36S/3QlqgMgr16QZOHVZewxc+7dgaHu+VJgwCgVmQZGmgu9vmmc+RapB6SQF70XiiT7PvkebUQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=FM0ogPfYkpfLgi5+KP46LCeG5W0YnQ5zBBDX3lR6Py0=;
 b=l46ioxFUpqiYXWuOnQ4C367eniX2DTm0Cjt9MsQiZlbUNLvClr7d3360op3A47AtTWcKIyeUMTyzY67nkli98XEhDDo5FPQaA8r7NrAWaJ29IcshnHciCWTSFnnBCiismxGyk4yX2F5PKVWtGykG7hkJIC9hnKIqdJxEB9UYDYDLGM5VDdNRtmtvjvgYUfN+1YFkDU73uWQWOz0hFqesYB/ZTXjbaeEyBbx+j0Da7pOcWBFCgWv17cMe7WP9ygb2Hu4G5rrqosnv6Y+sxao90SKd4zacMuQYLlNJO/lz0t8PvB5s2PM/lVFKBTz0KvlvxHwIFJilZd/1HQDVGGhxVg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=alien8.de smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=FM0ogPfYkpfLgi5+KP46LCeG5W0YnQ5zBBDX3lR6Py0=;
 b=bxjVZCKRq5H0M4t4hjuM+BIco9/i3pYt0W+kZYEvXYkDnHlLKbFeUOKGW1F9WZVY3jwhGMcYY1b2tUUBVcUcr9y0LnB4tWtov7FIm5JH4zK0Wh1NpY2rs+wF5vVtJqGJ2CXKkBSIAjS3Q06L6eQhYFMkRbsSglbwiBv1/k9hAe4=
Received: from MN2PR12CA0019.namprd12.prod.outlook.com (2603:10b6:208:a8::32)
 by DS7PR12MB8273.namprd12.prod.outlook.com (2603:10b6:8:ed::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9052.21; Mon, 25 Aug
 2025 09:03:26 +0000
Received: from BN2PEPF00004FBC.namprd04.prod.outlook.com
 (2603:10b6:208:a8:cafe::ca) by MN2PR12CA0019.outlook.office365.com
 (2603:10b6:208:a8::32) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9052.21 via Frontend Transport; Mon,
 25 Aug 2025 09:03:26 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 BN2PEPF00004FBC.mail.protection.outlook.com (10.167.243.182) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.9073.11 via Frontend Transport; Mon, 25 Aug 2025 09:03:25 +0000
Received: from SATLEXMB06.amd.com (10.181.40.147) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Mon, 25 Aug
 2025 04:03:25 -0500
Received: from SATLEXMB04.amd.com (10.181.40.145) by SATLEXMB06.amd.com
 (10.181.40.147) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Mon, 25 Aug
 2025 04:03:24 -0500
Received: from [172.31.184.125] (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server id 15.1.2507.39 via Frontend
 Transport; Mon, 25 Aug 2025 04:03:18 -0500
Message-ID: <f0ef442b-44ba-465b-86aa-93a810f8e488@amd.com>
Date: Mon, 25 Aug 2025 14:33:17 +0530
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 0/4] x86/cpu/topology: Fix the preferred order of
 initial APIC ID parsing on AMD/Hygon
To: Borislav Petkov <bp@alien8.de>
CC: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, Dave
 Hansen <dave.hansen@linux.intel.com>, Sean Christopherson
	<seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>, <x86@kernel.org>,
	Naveen rao <naveen.rao@amd.com>, Sairaj Kodilkar <sarunkod@amd.com>, "H.
 Peter Anvin" <hpa@zytor.com>, "Peter Zijlstra (Intel)"
	<peterz@infradead.org>, "Xin Li (Intel)" <xin@zytor.com>, Pawan Gupta
	<pawan.kumar.gupta@linux.intel.com>, Tom Lendacky <thomas.lendacky@amd.com>,
	<linux-kernel@vger.kernel.org>, <kvm@vger.kernel.org>, Mario Limonciello
	<mario.limonciello@amd.com>, "Gautham R. Shenoy" <gautham.shenoy@amd.com>,
	Babu Moger <babu.moger@amd.com>, Suravee Suthikulpanit
	<suravee.suthikulpanit@amd.com>, Naveen N Rao <naveen@kernel.org>
References: <20250825075732.10694-1-kprateek.nayak@amd.com>
 <20250825084950.GAaKwjrvrmXZStqrji@fat_crate.local>
Content-Language: en-US
From: K Prateek Nayak <kprateek.nayak@amd.com>
In-Reply-To: <20250825084950.GAaKwjrvrmXZStqrji@fat_crate.local>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN2PEPF00004FBC:EE_|DS7PR12MB8273:EE_
X-MS-Office365-Filtering-Correlation-Id: 2860479a-b9a1-4563-e673-08dde3b64058
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|1800799024|7416014|376014|36860700013;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?Mk40SlN0eVFJRU5IRlE2d0ZZK1U2UHEzVEF0R1FTNmN5VmJ2TUZvWUlXK1Rh?=
 =?utf-8?B?RllYNjgvYjkrYWtpR3lUSHMxaGtnZ2U2VHY1Z0pzaEhhditQc291dEdFand2?=
 =?utf-8?B?YVVwNkdaR1J2dWdtYXN1bnJ5K1RsT3pPZllOOSsyVHM4UFJlaFpYS0lCK0lQ?=
 =?utf-8?B?dEtqd3RLMkNWOC9LU3pkVjB3V3cwNnZ2aHN5NWlTdk54TDR5MVpIbjFwUDB3?=
 =?utf-8?B?bW1zZ2xicFE4M0N2K0ZLNUxza0RCNjRZN2RUL3hlZytaUFN2MWd0SEZwRndS?=
 =?utf-8?B?MWlRSGhFKzlXZ3hwbmRYQXVaTXQ0ZEpIU3NNL1BzT2s4MzhQczRxUEtRYWxx?=
 =?utf-8?B?akh1U1l0VVZPVVhYMEkrb2c5NVZwZDNua3J0TXdNaDNFd01EekNnVnhRZTdN?=
 =?utf-8?B?UzNkeWVpNVhvRTVTZ1JDaGoyK3VxWEx6VEtxTVlCRExHWDJwUzlmUDhabXN0?=
 =?utf-8?B?bmJMNDIvNEYwdzN4KzUzZktpYVc4Zysxb1BQNVJQUXA1cFNWVUtMdVdlcVU1?=
 =?utf-8?B?TmhrY2o3UFYwUDk4d1ZXcFZVTjl1NXZHK1pOYVZCT1dQVlFHT0VDTUZZTy9a?=
 =?utf-8?B?RmZZWG1nZEk2eTN3SWJKUnpsRGgvMWRGejJJck03ekZPTjVRUVBTM01SV3Zp?=
 =?utf-8?B?alphWkExZTQwWC9GUnFPZitPanJLN0lycWUvSjBXKzM4N1RDbGFSVzhHMGVM?=
 =?utf-8?B?SnhXbG9UZ2hnaTlqWEZJREJWaHNZKzN6U25ZUHY3Q0xKdmg3dmtVY2Juajlp?=
 =?utf-8?B?VE1teXRWQkJqczBsNDBCZEJ1VVhVVmpXajFRc0V2YXcxRUErRytjNVlaNjlh?=
 =?utf-8?B?RFlxeExHdkVRQVdDYko4MURxUWxUNkRXRXU4RGVQVU1xUDJ6T0lXT0RqS3N1?=
 =?utf-8?B?Mm1aTmRpYXFMMWpzYWxCVE9ocjFsZUl3czBXT0RxTWVvdlRNTE5hYitkcTFj?=
 =?utf-8?B?ekdjeWFRM3ZveWhOZnp5MDVma0R2VlEyc3NyU1hJR3hUam9JM1Bnd3RWYitK?=
 =?utf-8?B?d2RFWjZ3L1MyVzJKUzhuZFovQ2FOVUNUZ1FvQkJub0kyek1ySFFDRUdZUWtY?=
 =?utf-8?B?UytReUN3K0w1TXFqeHgyRGxhdU5ZbTZZVUNZVm5Gb3J2SkVUWGNaeUlEUGR4?=
 =?utf-8?B?cUZ3T0hPdWZZUlhTSkJ1RFNYWVMyelJGODdCenk0eWxNUjJ4b0I1Y3JwdWpX?=
 =?utf-8?B?b0t5VHVDcjNiajFEa1d4dkIzbHRqeWNkdXNIcER2Z3pyaHpZdkwrejk4Rjli?=
 =?utf-8?B?NHhyeUV4clFtZi9YOXhFamRaMm1RdkZuN0hBUkNLV0lrZjV6M1NsU29CZE1J?=
 =?utf-8?B?SkVDaFYzOXJwR1VUcGYxWDR1S3ZpN1lHTWFWRTkyeGluUy9VQXNEcXFORllr?=
 =?utf-8?B?L3hpY1NIcHpTOXkzdjJlM2lkVUhFL3loM3NTVFU4TTRESzY1UE5MRlV5bThV?=
 =?utf-8?B?S1RoU2xsQ0FtM3lZbk9DNmI5bzdzbXNsS01Qby9vbmZoQzBPanE5Y3ErbEIv?=
 =?utf-8?B?VmhPNkpnUkFKRHV4ajkwMnBoZU1DOTlTa05RQlpkeG9peGVNQVVlL2RMSmdZ?=
 =?utf-8?B?TVY3dEVUMzhhV2VBSEJ2TWZaekpCUUdjdElnTjJCUXFueGVTSUI3eGtvLzNl?=
 =?utf-8?B?L1JCeHI2SzJjYzE1Wm1SdVZaYkxJRDdacnZSNnNXZGNFUmtHWWVDQ0FRUGkv?=
 =?utf-8?B?aUN5SDUzYnlZQTNERWFOUmVEN3l3ZVpxYkZSaTVFVmp5aG5oOXUzUlRKVnFE?=
 =?utf-8?B?ZFhScEF1cTZZbUxvS3BrbWUwMWNrVTFjWk9vakYzMUlEMWN0a1dCS1NRU3pX?=
 =?utf-8?B?ckp0UUF0dEZWUENHVk1Qd3BGc2I0MUhpRWF4WWdtSmMweXZUQXVnVXU4RHZq?=
 =?utf-8?B?ckIrZ3hyNlFNVHl3YXBGMUxjRzdBZUc0OEcxS3NrdFZ6TEFTTGlRbjlsVTd1?=
 =?utf-8?B?bnhjUWVBdy8rcjBZNkIrNlJRRjJSZzFnS3o4Q3RPNlVzSXROeGl5bW5ybkh2?=
 =?utf-8?B?RlJBcmF2VHRwQ1VGa2dsWm9vNWpiY0lGYjVHRndKVVRkL1MreHhaSkpYR0w0?=
 =?utf-8?Q?L29U5U?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(82310400026)(1800799024)(7416014)(376014)(36860700013);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Aug 2025 09:03:25.9177
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 2860479a-b9a1-4563-e673-08dde3b64058
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BN2PEPF00004FBC.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR12MB8273

Hello Boris,

On 8/25/2025 2:19 PM, Borislav Petkov wrote:
> On Mon, Aug 25, 2025 at 07:57:28AM +0000, K Prateek Nayak wrote:
>> This led us down a rabbit hole of XTOPOLOGY vs TOPOEXT support, preferred
> 
> So in order to save people the rabbit hole wandering each time they (or we)
> have to undertake, I think we should document what the whole logic and
> precedences are wrt CPUID leafs and topology. What should be done where and so
> on.
> 
> And those commit messages have a lot of text which explains that and I think
> it would be worth the effort to start holding it down here
> Documentation/arch/x86/topology.rst
> 
> No long texts, no big explanations - just the plain facts and what the current
> strategy is wrt to which CPUID leafs we parse for what in what order and so
> on.
> 
> You could start the AMD side, it doesn't have to be exhaustive - just the
> facts from this rabbit hole trip.
> 
> And then we'll keep extending it and filling out the details so that it is
> right there written down in one place.
> 
> Makes sense?

Ack. I'll start working on it.

-- 
Thanks and Regards,
Prateek


