Return-Path: <kvm+bounces-57911-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id A5131B80B73
	for <lists+kvm@lfdr.de>; Wed, 17 Sep 2025 17:49:06 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 50F457BB973
	for <lists+kvm@lfdr.de>; Wed, 17 Sep 2025 15:44:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9FDD93451BF;
	Wed, 17 Sep 2025 15:40:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="eBExI8L9"
X-Original-To: kvm@vger.kernel.org
Received: from CY7PR03CU001.outbound.protection.outlook.com (mail-westcentralusazon11010008.outbound.protection.outlook.com [40.93.198.8])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 36ABE33AE9E;
	Wed, 17 Sep 2025 15:40:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.93.198.8
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758123626; cv=fail; b=W263uUCakbWsm4LKImu4qgv2hyBerEKisv3wcIImXHulTlUDweTZANX+RI/RHFiHbVVAzPqzNwyJNcWSqx/qDSO4SHtk6KuY5C3oYAe5Y/Ra0ut4P1oNWPhnbFS+sNaYlNPwGwbyMYbOwJn44CM7gaSqCK5ZH06EQ6bpJTYtSgY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758123626; c=relaxed/simple;
	bh=rrGZqxqGqEtqgHUn85T3gl41DMveUblGWDnw7AyK120=;
	h=Message-ID:Date:MIME-Version:Subject:To:CC:References:From:
	 In-Reply-To:Content-Type; b=O3UXQlpUfjG60k4Qk+QlwTOanAOzlxGEPRniXt4S/YVRCpuaMqQsfuhXVdwZwJ89lomyOrBbd/+6X3p8jlhaKEzHz17vCTMUTT97pvppUGIvo8nDw27cQUFy+7xC+XX9kPszdzBrO+weG8kMfnkVPwbZYeXasgubcDbm3vGQaj4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=eBExI8L9; arc=fail smtp.client-ip=40.93.198.8
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=kktV4wlAcKOkGcsU2YdV21XzZ4+1OLagN18rMuJ63XK+44JfByVci/aEYBemmxKaa6tbm44vtLCBsObY4KfcONSS9CcX9H0WxFYhFY3aMpXuOT9v8o3G+tokRWcqqiQQk6FxE8OuuzlaRau7bel+70hdSNr3y4g3NG6OJFXfzJJIiMOFnc8VF/p6fIMkzzixaazP/GUx1HJzz1SOlkhqITfr7wmusI1M3CIaCpcttED+QOfpC9nedvbCSG8IlCWBIszDrMkmcvG0B0AFC8aDia4EOjwaudcHYKGBLkKvtq7BvbQmJ/eGc2WznhFwF6I+KUdWHF8Mnyar2Kj7TMMJmA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=VWY9LMhIXpHRew7oh7WR1H2/o0DaeuP34aAjI7fNEw4=;
 b=KgqIkAlVflV+ZucsN5wXsFitWFZvwL/aRbx0m4mgEV+Q2ux4IlMsKa/ZcOJrEZ8twtvtFGIhQ9ALXdpJz8PAeZIX8F0jtUc60ptOW3Y3EZLniIxQBeA6F+5ICXhYNKJbk8doovDBATWI/K9t/85ESEJhkpN2pokCdwr3i1I2YEFS4k4RVhOC0M63uwSfAX5ARdwaRl0Ne7mHZWLHLQbK1olS4FqLhMDbHSuOrtOdRZrei/NjPbcxWDJTWuTms6iqx2X6YV9YYAA5oY7r88+vYIkQ4VIIlg/YjSgF9XXqMtE+XSLp+6KlvS/B73r7AfAMNkRuxHezjBPbgQRkbbIrNg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=google.com smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=VWY9LMhIXpHRew7oh7WR1H2/o0DaeuP34aAjI7fNEw4=;
 b=eBExI8L9FhumwSGkvuj1uVzj+9iq8PnzUwucoonNSF9unjRVxp8MqRU0EOfA/EVJEkRiJK7hZrUXHjF2tbPq9UuI57sfQ0qfXIXEHUI6+Flb9Q9I8Sebr5OC2+vJZfY2/RDZtgjht9x4c8QbFU7+O9KRYv5UASC+qQ14PAjzE8k=
Received: from SN6PR2101CA0016.namprd21.prod.outlook.com
 (2603:10b6:805:106::26) by PH7PR12MB8054.namprd12.prod.outlook.com
 (2603:10b6:510:27f::15) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9115.22; Wed, 17 Sep
 2025 15:40:19 +0000
Received: from SA2PEPF00003F61.namprd04.prod.outlook.com
 (2603:10b6:805:106:cafe::a2) by SN6PR2101CA0016.outlook.office365.com
 (2603:10b6:805:106::26) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9160.3 via Frontend Transport; Wed,
 17 Sep 2025 15:40:19 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb08.amd.com; pr=C
Received: from satlexmb08.amd.com (165.204.84.17) by
 SA2PEPF00003F61.mail.protection.outlook.com (10.167.248.36) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9137.12 via Frontend Transport; Wed, 17 Sep 2025 15:40:18 +0000
Received: from satlexmb10.amd.com (10.181.42.219) by satlexmb08.amd.com
 (10.181.42.217) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.17; Wed, 17 Sep
 2025 08:40:18 -0700
Received: from satlexmb07.amd.com (10.181.42.216) by satlexmb10.amd.com
 (10.181.42.219) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.17; Wed, 17 Sep
 2025 08:40:18 -0700
Received: from [10.252.198.192] (10.180.168.240) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server id 15.2.2562.17 via Frontend
 Transport; Wed, 17 Sep 2025 08:40:14 -0700
Message-ID: <00d97fad-f67a-47c4-a829-fb7295dc6d19@amd.com>
Date: Wed, 17 Sep 2025 21:10:08 +0530
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 06/12] x86/cpufeatures: Add CPUID feature bit for VIBS
 in SVM/SEV guests
To: Nikunj A Dadhania <nikunj@amd.com>
CC: <seanjc@google.com>, <pbonzini@redhat.com>, <bp@alien8.de>,
	<peterz@infradead.org>, <mingo@redhat.com>, <mizhang@google.com>,
	<thomas.lendacky@amd.com>, <ravi.bangoria@amd.com>, <Sandipan.Das@amd.com>,
	<kvm@vger.kernel.org>, <linux-perf-users@vger.kernel.org>,
	<linux-doc@vger.kernel.org>
References: <20250901051656.209083-1-manali.shukla@amd.com>
 <20250901052304.209199-1-manali.shukla@amd.com> <85v7lq31hd.fsf@amd.com>
Content-Language: en-US
From: Manali Shukla <manali.shukla@amd.com>
In-Reply-To: <85v7lq31hd.fsf@amd.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA2PEPF00003F61:EE_|PH7PR12MB8054:EE_
X-MS-Office365-Filtering-Correlation-Id: d57783b6-a77f-4488-afbe-08ddf6008167
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|36860700013|376014|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?WEtCSEZ6ZXI3YmF0ZWZGQXlMbnI2UGlIY2ZlaWE4UlIvNk1ZMFF1MmIxSGFq?=
 =?utf-8?B?Q2sxa29uUmdqMVZYRkdldnVhQWVtKzN2NVhRR0FEUm5LTWptbWZJZWJ2Qm9L?=
 =?utf-8?B?bWNCVjQ3dG01a3JXTUJ1d1k2cElrVFJrOXZjN3RIUWYzL1FUUDMrR24xenk0?=
 =?utf-8?B?bjlreTlGeUdleThJK1poQ2xWRHlzYWxOZExtTUhpVGNYS3pVaXhwQzUrWXFM?=
 =?utf-8?B?VXhnWTM5TzFzU3U5d0YyRldKYlBhWUY4UWdycHRQaWZ2UFJDMGt6MHlSMFc3?=
 =?utf-8?B?Wm5zZUd2b1A5dk1PUzV6eWVBSUZXdk5Ma2JCMVBaRXNHcnZNa0k5bFBjeG8w?=
 =?utf-8?B?eE9FWVFlSFBPejk3ZkFXSWxXbmRMZiswd082alpUY0Q0d1R0ZXlpakNyam9X?=
 =?utf-8?B?cVFhdzhvZDR4M3lqTmkyZk1GUUI2b0JnM3BFMmQ2Ym5hN01oSFdrd1MrSTVP?=
 =?utf-8?B?V0c2SnRFa3JCZlB2YjJBK0dDUVQ5N1Yvd3NqYzd2OFpCRUlNNURPd1lQMmpS?=
 =?utf-8?B?Y3YrckVOZ3AxQWNyVE5ZTElSbVBYYjF6N09vdXM4MUNDRXhYS2liem5tUVhD?=
 =?utf-8?B?VmlBclpEVk01ZTNNUEhNUUFpL3JyNTNxZStkY2FTVmUrSENieUExb2ljWVB3?=
 =?utf-8?B?a1VES2d0UDlleklXNmdXWjlmTU9PNzFaY3dadHV2UWxseFFObnJqNjBqRzEv?=
 =?utf-8?B?NFNZUVM5SXRuSTBuNW1RTG1VVFg0RHVoQkVsbWsrVmpWT0EwaFloYUNEY2Fl?=
 =?utf-8?B?SUxxakw2bnZ4d3Bvb1FsZHFUdlBvTWZBM3h1dUNPRFpjdldqa3M4eUEwK1pq?=
 =?utf-8?B?YzJvLys2UTVza3p3VWlOZC8wR29Vdmd4amlCK3hvZkNHYklWeXNZYnhsV0Q0?=
 =?utf-8?B?RXNuNEJsUFMwaVJQbGxlcWpiYjlXQ2NkcjJBTkFVakFKRHM2UWhDWUs1dnJi?=
 =?utf-8?B?TFFPTm1LS09SYXZSTitUNFIvbTh2YVhjSXhZY0hhN292c3JIRTBNL0xrb0xx?=
 =?utf-8?B?R2VRVHI3WWUwMnVDbGdLYkpicVErc2VZRG05NEg2TUFtWEF6N2JPME1hQTdL?=
 =?utf-8?B?SnlMekNNcjc3YlJZcWl4K3BHait3aG1vNllQTjRYR3laeURwcEtjUUhOc00y?=
 =?utf-8?B?WkJjK2dxRnFKSitKanFOUkoxOTc1ZFVwL2NBTGZhWnQ2NG9Fd0hqYUlHcTVH?=
 =?utf-8?B?bG5VSzYySi9meFJ5M2luUWJ5TUtwSHhXczlITzVuaW1jRVlHZHMwMzIveVQ4?=
 =?utf-8?B?a09IcUNIUlAvK1o1bkwzc3RINlo4MmdyWjF0T2hXdVJWK2xPVy9QcUVETmVU?=
 =?utf-8?B?eXgwMnBrQTgrSGhUbkNoVVk1a1FSOHE3Rk9ZMThNNU0yZ3FZMzB5VHNNYm5V?=
 =?utf-8?B?RHBPMmtDR0tOdTBDNGF0R3BKSk9YY3ZZZExtQ2ZyL28rVmdxSnVDYnVlb2FZ?=
 =?utf-8?B?dUJpczBtZ1ZCblpIVllsbHFkVWUxeHFNWnNmUnRUVVM2cVhWSXBWRmovazJB?=
 =?utf-8?B?OC9uUStKU251MUgxUzZjQXZhaWZkd291aEdhc2diUk5Ic1BmcUlYVVp1TlYr?=
 =?utf-8?B?K1ZCOVlaRXNZbDY4Vy9jUmRZT01GQkJQT3k5YmFPaVJWaG44VXA4UnpVakJO?=
 =?utf-8?B?T1RwdStaUVd0dS9yM1ErSkpTTVFxZlhMSnlzNkNwNHV2OTErcUpEVk1vcVR4?=
 =?utf-8?B?QmNWb0dxTkJUcU8zcWJxVnBNcHRhUWkwV0x1U01ySVJuT2ZNZjczOFJPUGVn?=
 =?utf-8?B?RzcxVXUyelQ0UC9wMzJldDhZdXhEWExLUTVKNVVoRHNCRGczWkRaVlJYNHph?=
 =?utf-8?B?ajg1NnMyYW85UGw4WnE2NU9reXgzdVJJV0ZNeW1IaFFXWmZHaXMwSUhMNEox?=
 =?utf-8?B?SXdDQ0YrRjk5d2dybHYwVFRWb0NRV1BwNVp2NWJwN1gyd2Z3ZG5vZ0tYYjV6?=
 =?utf-8?B?eWN6U2pVWm9VNzIxby9lVDYrZlhLVXVqREdDZ0VKLzZZTmJZbmVoV0FCVnk4?=
 =?utf-8?B?d2JjWm9DVllyTnFiWFljUkl0OWQvc2F3QkxlSTJzdjN2UGc2VEtQMjdSZ3N2?=
 =?utf-8?Q?UV9Mo4?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:satlexmb08.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(82310400026)(36860700013)(376014)(1800799024);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Sep 2025 15:40:18.7613
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: d57783b6-a77f-4488-afbe-08ddf6008167
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb08.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SA2PEPF00003F61.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB8054

On 9/10/2025 6:31 PM, Nikunj A Dadhania wrote:
> Manali Shukla <manali.shukla@amd.com> writes:
> 
>> From: Santosh Shukla <santosh.shukla@amd.com>
>>
>> The virtualized IBS (VIBS) feature allows the guest to collect IBS
>> samples without exiting the guest.
>>
>> Presence of the VIBS feature is indicated via CPUID function
>> 0x8000000A_EDX[26].
>>
>> Signed-off-by: Santosh Shukla <santosh.shukla@amd.com>
>> Signed-off-by: Manali Shukla <manali.shukla@amd.com>
>> ---
>>  arch/x86/include/asm/cpufeatures.h | 1 +
>>  1 file changed, 1 insertion(+)
>>
>> diff --git a/arch/x86/include/asm/cpufeatures.h b/arch/x86/include/asm/cpufeatures.h
>> index 0dd44cbf7196..3c31dea00671 100644
>> --- a/arch/x86/include/asm/cpufeatures.h
>> +++ b/arch/x86/include/asm/cpufeatures.h
>> @@ -379,6 +379,7 @@
>>  #define X86_FEATURE_V_SPEC_CTRL		(15*32+20) /* "v_spec_ctrl" Virtual SPEC_CTRL */
>>  #define X86_FEATURE_VNMI		(15*32+25) /* "vnmi" Virtual NMI */
>>  #define X86_FEATURE_EXTLVT		(15*32+27) /* Extended Local vector Table */
>> +#define X86_FEATURE_VIBS		(15*32+26) /* Virtual IBS */
> 
> Please move before EXTLVT to maintain bit position order
> 
> Regards,
> Nikunj

Ack, will fix it up in V3.

-Manali

> 
>>  #define X86_FEATURE_SVME_ADDR_CHK	(15*32+28) /* SVME addr check */
>>  #define X86_FEATURE_BUS_LOCK_THRESHOLD	(15*32+29) /* Bus lock threshold */
>>  #define X86_FEATURE_IDLE_HLT		(15*32+30) /* IDLE HLT intercept */
>> -- 
>> 2.43.0


