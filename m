Return-Path: <kvm+bounces-55267-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 91570B2F5F3
	for <lists+kvm@lfdr.de>; Thu, 21 Aug 2025 13:10:45 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 53C9AAC1F53
	for <lists+kvm@lfdr.de>; Thu, 21 Aug 2025 11:08:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7376530C340;
	Thu, 21 Aug 2025 11:07:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="Cv23CoBq"
X-Original-To: kvm@vger.kernel.org
Received: from NAM02-BN1-obe.outbound.protection.outlook.com (mail-bn1nam02on2071.outbound.protection.outlook.com [40.107.212.71])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EA03C257846;
	Thu, 21 Aug 2025 11:07:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.212.71
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755774426; cv=fail; b=eMtp38riWVlBq5pKnoJTYt+4CKHm33Mz/GyhKuLxHrlGM6XI45wLMz4s9xq7oqoxm8VNxC4cKH/tKl0+w22ozaI869oyyNoBLxvlZ7dFalgFNhjQdxu8kamJc7N2Vu545NuJnLBMcjgWLcN5WFeTxeuuqO+Ql4sSbpdwKfrWYbM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755774426; c=relaxed/simple;
	bh=V+ZDyGS8elwbOulusmvL/sebQtNITgEWFLn9cmSKe0E=;
	h=Message-ID:Date:MIME-Version:Subject:To:CC:References:From:
	 In-Reply-To:Content-Type; b=tq1K91jWg2X+Y3dcMraQ/uI15W716nQmrYCDqJqm89HlpYxwYaS/1/urH1OIoLjVeFewhEpUl5kriawpJnmpx7hnr8meAr0OGwhhwu6OfFnYzIBWEyVHAIq2U3O2QhwAsg3TrjzujFh2pdf1ieCXPI0iUaeNbfb034Rr/Syg1So=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=Cv23CoBq; arc=fail smtp.client-ip=40.107.212.71
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=BS3/yDlr27w4QoX/G1td/1KeeveJJyZHKCTaAGZDjS26MKR1LrnNAJ0cZYwtTQTSLEZI5f8JKNxfNoSJNBqrUiHGCDiJKC1YpC6423wJs6tWsQnPibVI9ckGT6WFeGEeHrxNRz4No2VTiUOUryUgsz3cRrj7v2WAdK86toSH7DE+LPSuuWQJVOA8gnVrJdoEL3JPfk79pRzPjieJRESrQVZvDHe8Gvt3TFin65sAHiW55otjqb4gV34Om/CeKnBew81f4xOHlD/yWg0CijvQzti1ye3YHitpYZpQsCt2kdZCuHQOk0D3cDn3G98eZCVKHN0aPmG8/j3R2SiFW0LzDw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=FXuV5t28yl74qkRAW6x7SoU2eZT3R0AypArvfcMPeag=;
 b=cuqFFWHviz4pxsIWGPsLLSmcvmUeCUDfRw/YyeXy2RPNZWGbERYmwfvnP/hVz3r3M8eDQI5caUzZIZzxa00GuE5W0Dl3RtK4RoeRpolDs6sZBErImusjJBMRrGoPaVIZV2zZsBk2GE4KAOfV2SJ6cfS7m1aGXcyLl2caA4RysqbT/7mcpuv2DaDNzbFKhhUgV9NmuU6kcqmjJ6QuvngoVz++4TYh0dN6Yp/I1iyEWPQ0qQ2fNjWN5bMnui44xBHGmezmXgK/RwDDF8Md5N14k74wa4g90ruxexB5MK2gtljyTmdxwS351WPpdIHEjrx8BPAIsbdnskUgx/qOv2Dv3Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=infradead.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=FXuV5t28yl74qkRAW6x7SoU2eZT3R0AypArvfcMPeag=;
 b=Cv23CoBqKTf7C0+IITxy68Pr1V2+Fb1zwkO3H+jo6bF493locMxG9rnVYmkXegp34reo9S3Tv1alwDOb+VyxAsO9FdCWxIzqzN9BupWDpNgUvh5duY9n4YfjTRMUOf/PJA5H0ndqnHY93aZlmnSbvAn9xalacmv1A/9qNzdY5FM=
Received: from BL0PR0102CA0068.prod.exchangelabs.com (2603:10b6:208:25::45) by
 DM6PR12MB4468.namprd12.prod.outlook.com (2603:10b6:5:2ac::24) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9052.14; Thu, 21 Aug 2025 11:06:59 +0000
Received: from BL02EPF00029928.namprd02.prod.outlook.com
 (2603:10b6:208:25:cafe::e6) by BL0PR0102CA0068.outlook.office365.com
 (2603:10b6:208:25::45) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9052.15 via Frontend Transport; Thu,
 21 Aug 2025 11:07:39 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 BL02EPF00029928.mail.protection.outlook.com (10.167.249.53) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.9052.8 via Frontend Transport; Thu, 21 Aug 2025 11:06:59 +0000
Received: from [10.236.30.53] (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Thu, 21 Aug
 2025 06:06:57 -0500
Message-ID: <46cf87e2-8100-47ef-b19e-f6a1b76f660d@amd.com>
Date: Thu, 21 Aug 2025 06:06:57 -0500
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v9 2/2] KVM: SEV: Add SEV-SNP CipherTextHiding support
To: "Kalra, Ashish" <ashish.kalra@amd.com>, Randy Dunlap
	<rdunlap@infradead.org>, <corbet@lwn.net>, <seanjc@google.com>,
	<pbonzini@redhat.com>, <tglx@linutronix.de>, <mingo@redhat.com>,
	<bp@alien8.de>, <dave.hansen@linux.intel.com>, <x86@kernel.org>,
	<hpa@zytor.com>, <thomas.lendacky@amd.com>, <herbert@gondor.apana.org>
CC: <akpm@linux-foundation.org>, <rostedt@goodmis.org>, <paulmck@kernel.org>,
	<michael.roth@amd.com>, <linux-doc@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>, <kvm@vger.kernel.org>
References: <cover.1755721927.git.ashish.kalra@amd.com>
 <95abc49edfde36d4fb791570ea2a4be6ad95fd0d.1755721927.git.ashish.kalra@amd.com>
 <5dff05c1-474e-4fff-a19b-7c17b4db6173@infradead.org>
 <7eed1970-4e7d-4b3a-a3c1-198b0a6521d5@amd.com>
 <922eaff1-b2dc-447c-9b9c-ac1281ee000d@amd.com>
 <db253af8-1248-4d68-adec-83e318924cd8@amd.com>
From: Kim Phillips <kim.phillips@amd.com>
Content-Language: en-US
In-Reply-To: <db253af8-1248-4d68-adec-83e318924cd8@amd.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: SATLEXMB04.amd.com (10.181.40.145) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL02EPF00029928:EE_|DM6PR12MB4468:EE_
X-MS-Office365-Filtering-Correlation-Id: 6bb17ab6-42cd-4b51-d66f-08dde0a2d97c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700013|7416014|376014|82310400026|1800799024|921020;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?TnpZdXVMTi9reFBlUGdmWERKWlV5emJ1ZlE0Umg2NkUxWmpqSjFXeG4wZjFq?=
 =?utf-8?B?QVEydUp4OUlSTDMvcWZaTEQ3SEFocks3WVFKU0N2VDkya01pZlBpWDhOK21L?=
 =?utf-8?B?Z0NLdWlndzdPR2dTSzZqQXpDY0o3RVdYNUZNOTE0d2pSSlNQQnJja09xN0tH?=
 =?utf-8?B?UWZiM1RIZVR6VkJwaXgzdGJvRnFCT0Z1RE5hMlBmNlR6T1lUeVlFSnBUU3N0?=
 =?utf-8?B?MnZMRHYyeUlmQWVTVktQTGlZVS9POEtUNmZXWFhDK05GRjZrSnA2L05QVWQx?=
 =?utf-8?B?cUtuVTM1YkxMUEw4b2pzbEFaVUFEMlUzSXpmMVNwTVU5QjBsYjVhQ2xpK0li?=
 =?utf-8?B?L1VnVThLakkzdThXZGYzQnoxKzI0bWFNQ0YxR3NkQVRGNWlmWDA5c3NHNWVP?=
 =?utf-8?B?Z1J5MnZBb0FDa0xjQ1hzZXM5L1E5ZjRaRm5hQ2hROUkvaTBjYUxZYzVtRlVR?=
 =?utf-8?B?WGxvVGt3UXBVb3pOUzdrdk1WR3dKK0Uva0JLNHZpRnlEVXd4THc1UEtCakdQ?=
 =?utf-8?B?WWF2Y3NlRGlrMk4zZnJIM0VHVDZUanRXWmN2N1hCd3BpWmFBUzJya0ZyWU5i?=
 =?utf-8?B?ODFsZk9meXdEdDFIUzBvYWI0S3dFOGFYTFMvYW5QZ00wVUkvU0lVb3NEamVY?=
 =?utf-8?B?S2FlVXNJcUxkTVd5MlYrblBDS1ZEUFZudWFac0NDaitpS3ArdDhDK2l5VWwy?=
 =?utf-8?B?ZUZBanZkbU1pVjdKcnpON0JEckR4enV6MTNFZjJOR0IrMkFpV1F3dXVlNE85?=
 =?utf-8?B?bkZVR0V0REkyR2loTzZPSHBpSXhsRlZMek5GTWErelduYVZsNlhzZEMvMnJC?=
 =?utf-8?B?aXc4ME00L3luQlpqcG5GRGVKZEhlNFduazlpODRUWlJRVUpsaFZhK1o4M0JD?=
 =?utf-8?B?SGdFN0NHdGNJZ3JVQVVnL04yQVlOcDh1ZXY5L00rOTlJdC9JdUFUVUl4VHNv?=
 =?utf-8?B?dm5LbS9sT0d3V3JIM0pDVW5OVUZvaFlYdFJXZTI3ckE4T01Ub0tJdmFIWkdK?=
 =?utf-8?B?Tm5BcFNGaWlZTlBiUzV0TnUzOTAvMDdEZ3d5SStpNHpLUFFYdnhlS2NBRVRm?=
 =?utf-8?B?akpYb3crdFNBbktrTTBORlhLVUVSUkdsSXFidlk4ZFliczRkcm9yV0NwY25E?=
 =?utf-8?B?cjdtYjNrWFRtQ1BMSmxVZ08ydnJFOHRmeTFDZVdCWk42b0NJajZia3JvU2Zq?=
 =?utf-8?B?WTVsajB0UklpUjBhYzhTU0lZWnlKSHN1MW54TUZ2MUpmblIyOW91MlE4Qll0?=
 =?utf-8?B?eWR2WmU1V0pZTFBpdHIwYkk3U3NnVVExME1DRm5YaFhzTEc4WTE3MDN6Qkt1?=
 =?utf-8?B?ZnBxQWNCeUszWE13a2libEhPZkpBb0xLa25kK2Y3NVNSWDFLWFVWbVRYOE9M?=
 =?utf-8?B?SGljMFcrZ0k5RUd1WGRGazRpeEdBNzIvaW50VkszaUpwRDExY0hBanF5b04v?=
 =?utf-8?B?Q0Y1YVMzREN6VnZuY0ZSQVZMbktlSTc0VHFCaThsa3d5OXp1dHlFS1lENEVC?=
 =?utf-8?B?c1VPRWt6SWlOUUxQYWhpYXJSMFpQVytkZlhaalhXQmxHNW95L0JTMXpJMFYy?=
 =?utf-8?B?aDZNUVNhOGhEVitRTGhKL2lRQ0lmVTR5dHNZTEg1Y2JaUWNaTllza0NZM0sv?=
 =?utf-8?B?M3NGcUNyejhzL2MyaGk0L1ZTZmM5UDI4aFNhMWpTanUwd0ZWaVhhYXJxMGx3?=
 =?utf-8?B?ZEZiU2ZGcmhUelVNTmw1U2hRWEU1a1V0aXJUMXZ2cFZGYUxVYkVGdy9QWkVF?=
 =?utf-8?B?R25CZFBJY2xRNkpZWXc5RkV6ejNKZy9NZkVIZmlCRkRPMWgwcVo4bEx3a1pH?=
 =?utf-8?B?d05hM090SlB0eU1DbjVyUW1PNmFScFNGOUt2TDRFVXFhd3QrSGZveWxEOWF6?=
 =?utf-8?B?QzZjbjF6UHlxOGwzRjBSaG8ybmh0N1ZXREtZSlhUSWd2d3Rpb0Z0WDQvSGRN?=
 =?utf-8?B?bmZCZGJqMjZrSk1JNzlCOG1ETFR0bE96UWJFOE0xcGdKVHFnclZFTGxHdUlj?=
 =?utf-8?B?NktrTXMySzlBdGxsWTA1WlZqdHArL1F3S3MwdnNYT3pzQXFrQ1puU1ZRdUxP?=
 =?utf-8?B?U0ZVNzV2SGNMQXh5NFBaTGtOV3hDTkE4ZlRHdz09?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(36860700013)(7416014)(376014)(82310400026)(1800799024)(921020);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Aug 2025 11:06:59.4209
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 6bb17ab6-42cd-4b51-d66f-08dde0a2d97c
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BL02EPF00029928.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB4468

On 8/21/25 5:58 AM, Kalra, Ashish wrote:
> On 8/21/2025 5:30 AM, Kim Phillips wrote:
>> On 8/20/25 6:23 PM, Kalra, Ashish wrote:
>>> On 8/20/2025 5:45 PM, Randy Dunlap wrote:
>>>> On 8/20/25 1:50 PM, Ashish Kalra wrote:
>>>>> @@ -3064,10 +3070,32 @@ void __init sev_hardware_setup(void)
>>>>>    out:
>>>>>        if (sev_enabled) {
>>>>>            init_args.probe = true;
>>>>> +
>>>>> +        if (sev_is_snp_ciphertext_hiding_supported())
>>>>> +            init_args.max_snp_asid = min(nr_ciphertext_hiding_asids,
>>>>> +                             min_sev_asid - 1);
>>>>> +
>>>>>            if (sev_platform_init(&init_args))
>>>>>                sev_supported = sev_es_supported = sev_snp_supported = false;
>>>>>            else if (sev_snp_supported)
>>>>>                sev_snp_supported = is_sev_snp_initialized();
>>>>> +
>>>>> +        if (sev_snp_supported)
>>>>> +            nr_ciphertext_hiding_asids = init_args.max_snp_asid;
>>>>> +
>>>>> +        /*
>>>>> +         * If ciphertext hiding is enabled, the joint SEV-ES/SEV-SNP
>>>>> +         * ASID range is partitioned into separate SEV-ES and SEV-SNP
>>>>> +         * ASID ranges, with the SEV-SNP range being [1..max_snp_asid]
>>>>> +         * and the SEV-ES range being [max_snp_asid..max_sev_es_asid].
>>>>                                        [max_snp_asid + 1..max_sev_es_asid]
>>>> ?
>>> Yes.
>> So why wouldn't you have left Sean's original "(max_snp_asid..max_sev_es_asid]" as-is?
>>
>> Kim
>>
> Because that i believe is a typo and the correct SEV-ES range is [max_snp_asid + 1..max_sev_es_asid].

It's not, though.

[max_snp_asid..max_sev_es_asid]

and

(max_snp_asid..max_sev_es_asid]

are two completely different things.


You also modified Sean's Documentation/ changes.  A consistent "joint 
SEV-ES+SEV-SNP" is preferred.

Thanks,

Kim

