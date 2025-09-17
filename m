Return-Path: <kvm+bounces-57910-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 31FA1B809E4
	for <lists+kvm@lfdr.de>; Wed, 17 Sep 2025 17:36:57 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 0A14A4676BB
	for <lists+kvm@lfdr.de>; Wed, 17 Sep 2025 15:36:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 60ABC3386F2;
	Wed, 17 Sep 2025 15:36:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="CAMBHtG/"
X-Original-To: kvm@vger.kernel.org
Received: from PH7PR06CU001.outbound.protection.outlook.com (mail-westus3azon11010032.outbound.protection.outlook.com [52.101.201.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A44F33AE93;
	Wed, 17 Sep 2025 15:36:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.201.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758123399; cv=fail; b=QEDYarWwpzbEsJFvhQmYz+OTN80HPSRRW98836KROooX09rXIL+aCM1kGCAvxnRbTQ3nHkWW1HLu93Tf32MvtqOKwP/+Zca1Uw64DF/lSfHrS62snjdwCJcEFAEis9Gof2RFn8/i7vntguo68dwT8ytASQe6UfYIxdJxe4aHxNQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758123399; c=relaxed/simple;
	bh=rEds35wRjlv4Fa/rXn2vDcObwu9+iKDAIS8LdzlMpcc=;
	h=Message-ID:Date:MIME-Version:Subject:To:CC:References:From:
	 In-Reply-To:Content-Type; b=erf4rHDEsRcDxZFFdfr4Mb1juSDJlt5BTJUnCcMBnXRmpeZeB0tFTzNRlWFKPCCEUpffZEutvXuI5GelJxxm6e/W/nXspxa+nYcxFghupj9yYb+GX8qP4GX8EaIXn4oK2rBSu2itgijPTszeyKq+2j8NwapntynthGNVp1uLso4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=CAMBHtG/; arc=fail smtp.client-ip=52.101.201.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=GEokmgYmat2SgoXtquA0vvTlyRqDM9iQFDQ4cGMPRbOmwlDU5Jjlc+2hQlSUKBOdEwWPUTEskBLoN/nuVBMXVr+DgSLOAOZVQkefT8WsTFBF4EqB4yo1cQ2fdZI99FVv+R9lI7cn6ds1oprS/rCpB8ZlxsL0SfkwI6AA0mtqA2MWtQkRVbhIKqjzSMrhEZNniKjPkquYlaluMgL2ZTvUKCy/GndD8igdB+2S+21Qqb2hYw1SdHERGGNfcH9ivMqKIsSIwrfolONJP8APGMozzaVRyHTLX0uvxyT35952QGQ5xuo0ZspjAhaoAMSZyTgzkN+soMDsOioZXhgd3AWszw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=kb2IwOP4F55GsCzOCIPYLp5IR94sw7YZtPuVhZ+pH5s=;
 b=tHQ+1pqy93bPnqDeh4T8TrMgV1FbGuY3Ij69dxxDH1cFKVtSUUzi8BCJ+YIGiXA47eWppn8wgU5OGaoKKA5Ibs8JcPEpU3TAPZLnbrLGaUnvwO3/qdWmThNnmWT7pz3XSHEgcCyYKMs1SizFLazxq6jI3gGIS3quE999xc8If7xPkoNkmXOiGVaqkaFf1N8d5SNd4UP6N0ZEyFGZ6eLZwGSpA1z8U80vipUEqlREh2+JWr83NUKT4VWIFh0d40o+ln/6KlsZq+oTCimBha02ayn5tdKu92klACpMykFAUUWuOTEh5kA2Z5pMcyK2zJc92+bVfzfO/j3zfNLMe0SRsw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=kernel.org smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kb2IwOP4F55GsCzOCIPYLp5IR94sw7YZtPuVhZ+pH5s=;
 b=CAMBHtG/W8yKhQ5rp4kG1hBtvKemLSMK7e05ZbYpTibFRCREhP27ikITqmVTrU39biFwzo93zNVGpB5AmwzGikD9PH42jBONc8IYiI5XT+wsrCldIQiXH2iLIjEYdqP2MNWPRhuyZzbf/xsaaBEA54FYHGryZ1L70bOjOc0pMpw=
Received: from PH7P220CA0163.NAMP220.PROD.OUTLOOK.COM (2603:10b6:510:33b::24)
 by MN2PR12MB4190.namprd12.prod.outlook.com (2603:10b6:208:1dd::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9137.13; Wed, 17 Sep
 2025 15:35:12 +0000
Received: from CY4PEPF0000E9D4.namprd03.prod.outlook.com
 (2603:10b6:510:33b:cafe::b8) by PH7P220CA0163.outlook.office365.com
 (2603:10b6:510:33b::24) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9137.13 via Frontend Transport; Wed,
 17 Sep 2025 15:35:12 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb07.amd.com; pr=C
Received: from satlexmb07.amd.com (165.204.84.17) by
 CY4PEPF0000E9D4.mail.protection.outlook.com (10.167.241.139) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9137.12 via Frontend Transport; Wed, 17 Sep 2025 15:35:11 +0000
Received: from SATLEXMB06.amd.com (10.181.40.147) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.2.2562.17; Wed, 17 Sep
 2025 08:35:03 -0700
Received: from satlexmb08.amd.com (10.181.42.217) by SATLEXMB06.amd.com
 (10.181.40.147) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Wed, 17 Sep
 2025 10:35:03 -0500
Received: from [10.252.198.192] (10.180.168.240) by satlexmb08.amd.com
 (10.181.42.217) with Microsoft SMTP Server id 15.2.2562.17 via Frontend
 Transport; Wed, 17 Sep 2025 08:34:58 -0700
Message-ID: <1acb5a6d-377b-4f0a-8a70-0dddaefa149c@amd.com>
Date: Wed, 17 Sep 2025 21:04:57 +0530
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 04/12] x86/cpufeatures: Add CPUID feature bit for
 Extended LVT
To: Naveen N Rao <naveen@kernel.org>
CC: <kvm@vger.kernel.org>, <linux-perf-users@vger.kernel.org>,
	<linux-doc@vger.kernel.org>, <seanjc@google.com>, <pbonzini@redhat.com>,
	<nikunj@amd.com>, <bp@alien8.de>, <peterz@infradead.org>, <mingo@redhat.com>,
	<mizhang@google.com>, <thomas.lendacky@amd.com>, <ravi.bangoria@amd.com>,
	<Sandipan.Das@amd.com>
References: <20250901051656.209083-1-manali.shukla@amd.com>
 <20250901052212.209171-1-manali.shukla@amd.com>
 <kgavy7x2hweqc5fbg65fwxv7twmaiyt3l5brluqhxt57rjfvmq@aixr2qd436a2>
Content-Language: en-US
From: Manali Shukla <manali.shukla@amd.com>
In-Reply-To: <kgavy7x2hweqc5fbg65fwxv7twmaiyt3l5brluqhxt57rjfvmq@aixr2qd436a2>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY4PEPF0000E9D4:EE_|MN2PR12MB4190:EE_
X-MS-Office365-Filtering-Correlation-Id: 43da8b63-f640-403e-2433-08ddf5ffca6c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|82310400026|36860700013|7416014|376014|13003099007;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?R1hyWllac3c0L0Z4TUowS2kyNmdvcllFN2szQ2tNb3ViUEdPYzEwemgrWHB3?=
 =?utf-8?B?RWF1aE9PZkZiUWl6a3crdytFUmdwOEY4Um00Ynp2azdNQW5kMnN1UkJSdFBX?=
 =?utf-8?B?bUg3bVFHcmQ1azVMOXdUYmR1TDlNNWFEMUluNnJCNkVXMUZQTnN0emIzK1pm?=
 =?utf-8?B?ZTNIUnFIeWJpUEg0K0YwTURhT3BwL051dGorcDkzK1Z5UDYxVXpNNElpb1pM?=
 =?utf-8?B?T1gvVkRIVDROTkZOVUNmUnU0RnFYTkFUYVAxREtFRFAzM3BlUkF2eFVmNi9k?=
 =?utf-8?B?SmxVb1g5TXlnU3FPTEdDbW1PUDRmZjlSTXNCZ0NVNlk4OU11eUdMTFRNYzho?=
 =?utf-8?B?OGNCYU83M0dTQ0VDcjVtNWdQSHNyeHpqbkRLT1U0Z2V2QzlqTEF6K1lMb2xi?=
 =?utf-8?B?OEx2b2lNSU5YTEd0U3E3Z3c4N21tb3ZZUlFscnRGVWRaT1U3YVVqQ1RJRkYz?=
 =?utf-8?B?cVVDK0UyM1hMbFc2cUxRTXNLZUFXU0dnd25IUmdNZTB4WUZFQ0dzQSsxeWlZ?=
 =?utf-8?B?SHI1b2VzdENWZzV0QWVMb0Nmdkc3TWRrUVRza2IyNWNHQjJueUw5TEkwY3J5?=
 =?utf-8?B?cC9wbzdueWVSYVVZaFVEeHJRSU1pQlRtUW9Qdm9HMFVWYXpaVW9hdFBPTmFK?=
 =?utf-8?B?Z25UVUxmWG5KclVUVUZBOXQ4Y0t4YnVhdUdpRzVwRnYvaEl6OFNvYWIzQU0w?=
 =?utf-8?B?SW9ERUMvckVjcVBPcno5MWdyZDM4b0RNSDBkaFZJSTlpbDhYR0wwMVc4OUYr?=
 =?utf-8?B?VktWUUJ1M1FTNGhlV2lJZEE0cXJYTFpqTEplMGVQZlQ5di9NaXJuSGV3WTVK?=
 =?utf-8?B?VlpNeGF6dHkvSlYxVmdXMmhuZG1rS2JVV2NNTmF4ZHAzQUxvTjlWd3AzNXBz?=
 =?utf-8?B?YnYxZEVHV2pSa0tNWUhjMWluWFZNT0c1cmM5K0pITWhYU0RqL3RqUGZJblQ4?=
 =?utf-8?B?UjN1TjhoazhsbWh0UG9QdTkxRUNNRURFKytQaTBQWE1CTWVyeC95M1lQbkh0?=
 =?utf-8?B?MEtWZXBXMklORHhoR3FSZzh5Nk5Jb3NwRTFmWjh5eTVGUXk4alhLV3pRYVZp?=
 =?utf-8?B?ZG5HTXEzR083K1FxbnNreXB6VVEyb1dOMG5DOTV1WkZWL09RbzZWNHhNNDZu?=
 =?utf-8?B?d2NlWHdKVzBlWnFGK21WTnoxb2RnNng1MmorbEtsSnZtdmZWam12K0FCaHQ3?=
 =?utf-8?B?amE3TEF0N2VzSDB2d3p6dHh6QkVlYkU3dmlHYU93VURic2l1czdxTTdob2or?=
 =?utf-8?B?LzhJTVZna1k1ZzRmVnhRUHIxV3Y2WTBhUm9DenRSYXcyWFdCaXVXREhGUVlh?=
 =?utf-8?B?VGF5cm9uWEhWUzFvc01OanBDYU9JNEZEL0dPMmFCakZ1TDlYWjBIbUdObCto?=
 =?utf-8?B?amt6cmFLVzc3VWFLb2hzVFJVcHoranIyVCswd1BYQWprL2pxbzBlcVNjSTBI?=
 =?utf-8?B?ODllYW9vVzUxZUhFZjdON1c4UFRWUld1cmU1TjVqQUp2ZkFMR3RCOVZPQkFW?=
 =?utf-8?B?WHgycmV2cTdCTWtMeUdnQlRraGVNbDA1L1dZRGdsVUF5ZFBNaGtmTE9kdklu?=
 =?utf-8?B?NkdjV3QwRXRFei9oN3VlYW43YXNORDVDU1R4OEVUVTM5OENKUGt2TEZhQVJW?=
 =?utf-8?B?UTd4ODQxN3B0MEhBeG1obTgyTGJ6ek52azRaUGRKMGRuSTlVWHFiZnNEZ3l4?=
 =?utf-8?B?QXFaR25JOFA5L2VZLzkzUXBhQVlQRlo0eWEyMS9xUitMRDB2c2lkU01WaFJI?=
 =?utf-8?B?eXNSbEJsNys0ZE1xZmF1Q3p1OFpHejhvLzA2dHBlUVJNbFdJaUI1SmNkaW9O?=
 =?utf-8?B?QW9BbTlsbTJrdlVwcDJZbDNxV2w1RE1JK2lGREZKQkdYZ25RY1BNRUdyemdh?=
 =?utf-8?B?SWEvcXZnbXBOenkvaG1BTG41elpTWWJsMWt6clRPa0x0ZzM4Q2pvUUloTlpu?=
 =?utf-8?B?MytET3VEZUFhQVNDRGhkalhjd20veGs4MElCYmUvQ0NlRjVPVzFDY09GMElJ?=
 =?utf-8?B?SzZwbiswWElBPT0=?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:satlexmb07.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(1800799024)(82310400026)(36860700013)(7416014)(376014)(13003099007);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Sep 2025 15:35:11.7159
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 43da8b63-f640-403e-2433-08ddf5ffca6c
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb07.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CY4PEPF0000E9D4.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR12MB4190

Hi Naveen,

Thank you for reviewing my patches.

On 9/8/2025 7:09 PM, Naveen N Rao wrote:
> On Mon, Sep 01, 2025 at 10:52:12AM +0530, Manali Shukla wrote:
>> From: Santosh Shukla <santosh.shukla@amd.com>
>>
>> Local interrupts can be extended to include more LVT registers in
>> order to allow additional interrupt sources, like Instruction Based
>> Sampling (IBS).
>>
>> The Extended APIC feature register indicates the number of extended
>> Local Vector Table(LVT) registers in the local APIC.  Currently, there
>> are 4 extended LVT registers available which are located at APIC
>> offsets (400h-530h).
>>
>> The EXTLVT feature bit changes the behavior associated with reading
>> and writing an extended LVT register when AVIC is enabled. When the
>> EXTLVT and AVIC are enabled, a write to an extended LVT register
>> changes from a fault style #VMEXIT to a trap style #VMEXIT and a read
>> of an extended LVT register no longer triggers a #VMEXIT [2].
>>
>> Presence of the EXTLVT feature is indicated via CPUID function
>> 0x8000000A_EDX[27].
>>
>> More details about the EXTLVT feature can be found at [1].
>>
>> [1]: AMD Programmer's Manual Volume 2,
>> Section 16.4.5 Extended Interrupts.
>> https://bugzilla.kernel.org/attachment.cgi?id=306250
>>
>> [2]: AMD Programmer's Manual Volume 2,
>> Table 15-22. Guest vAPIC Register Access Behavior.
>> https://bugzilla.kernel.org/attachment.cgi?id=306250
>>
>> Signed-off-by: Santosh Shukla <santosh.shukla@amd.com>
>> Signed-off-by: Manali Shukla <manali.shukla@amd.com>
>> ---
>>  arch/x86/include/asm/cpufeatures.h | 1 +
>>  1 file changed, 1 insertion(+)
>>
>> diff --git a/arch/x86/include/asm/cpufeatures.h b/arch/x86/include/asm/cpufeatures.h
>> index 286d509f9363..0dd44cbf7196 100644
>> --- a/arch/x86/include/asm/cpufeatures.h
>> +++ b/arch/x86/include/asm/cpufeatures.h
>> @@ -378,6 +378,7 @@
>>  #define X86_FEATURE_X2AVIC		(15*32+18) /* "x2avic" Virtual x2apic */
>>  #define X86_FEATURE_V_SPEC_CTRL		(15*32+20) /* "v_spec_ctrl" Virtual SPEC_CTRL */
>>  #define X86_FEATURE_VNMI		(15*32+25) /* "vnmi" Virtual NMI */
>> +#define X86_FEATURE_EXTLVT		(15*32+27) /* Extended Local vector Table */
> 
> Per APM Vol 3, Appendix E.4.9 "Function 8000_000Ah", bit 27 is:
> ExtLvtAvicAccessChgExtended: Interrupt Local Vector Table Register AVIC 
> Access changes. See “Virtual APIC Register Accesses.”
> 
> And, APM Vol 2, 15.29.3.1 "Virtual APIC Register Accesses" says:
> Extended Interrupt [3:0] Local Vector Table Registers:
> 	CPUID Fn8000_000A_EDX[27]=1:
> 		Read: Allowed
> 		Write: #VMEXIT (trap)
> 	CPUID Fn8000_000A_EDX[27]=0:
> 		Read: #VMEXIT (fault)
> 		Write: #VMEXIT(fault)
> 
> So, as far as I can tell, this feature is only used to determine how 
> AVIC hardware handles accesses to the extended LVT entries. Does this 
> matter for vIBS? In the absence of this feature, we should take a fault 
> and KVM should be able to handle that.
> 

Yes, but KVM still needs to emulate extended LVT registers to handle the
fault when the guest IBS driver attempts to read/write extended LVT
registers.

"KVM: x86: Add emulation support for Extented LVT registers"
patch covers two aspects:

Extended LVT register emulation (EXTAPIC feature bit in
CPUID 0x80000001:ECX[3])

ExtLvtAvicAccessChgExtended which changes the behavior of read/write
access when AVIC is enabled.

> 
> - Naveen
> 




