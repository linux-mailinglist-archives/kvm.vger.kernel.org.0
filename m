Return-Path: <kvm+bounces-57849-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id D94CDB7EFA6
	for <lists+kvm@lfdr.de>; Wed, 17 Sep 2025 15:09:32 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 370E1189AD83
	for <lists+kvm@lfdr.de>; Wed, 17 Sep 2025 13:02:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 228573161A5;
	Wed, 17 Sep 2025 12:57:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="0pkP81LZ"
X-Original-To: kvm@vger.kernel.org
Received: from PH0PR06CU001.outbound.protection.outlook.com (mail-westus3azon11011068.outbound.protection.outlook.com [40.107.208.68])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D3C5D1B3925;
	Wed, 17 Sep 2025 12:57:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.208.68
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758113838; cv=fail; b=OUQFN4KoqdWssRqTsYCFP5CJc15fqew3GXCtHPUnua5X22ZQMiO7ljnyYX/CQDJazJ0VuN9b/xWm9woZUXn5nUriOetEa6Ydgsk7mnjWjn8bwzmpFXyk2jvxcRMCm9jvDeO2zE2ReApJefnhngADP/1RMnzagdWIGs8HKc1nDqs=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758113838; c=relaxed/simple;
	bh=6R7iKD43tfpVJpFf2hPCS2BDdT1JY4er0cWl7tbRjKU=;
	h=Message-ID:Date:MIME-Version:Subject:To:CC:References:From:
	 In-Reply-To:Content-Type; b=VhOXs0xLAlpY5m95OvaWO4dvwg9bCgUQ7g7XAT6iMQiDc0o+7BVeiJ89vIHivzug61crrcEwgwIiddXBVojqhzaIhHH5a1y5BjKweAtL5Nrv1XV7nelt5KJ3HQlYcT7ejti3LSM8ID+/GOBMJAKGTku2TpFfGoIIM5+m0vi1OMg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=0pkP81LZ; arc=fail smtp.client-ip=40.107.208.68
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=cu0UaB19WKqmH/A0Oa0jj5qKl4FckKN24yjLcW+zRCqvvWIo4E/r2QAnjsottQCfzq5DOur4uXHHkE9nkJj68b7PzKOYtv1G4IUlrNGbTKyyhU2uv3VN8SxiO1QCNiPaYwdFMag55F0sBYZQ26GLeTa1Bzin6s0klO3qNzSMxuTbHGQDntY0vhpo9kcHsY3oELKzUwueKnyDXc+YALLa9IDBPSAVBnMbumpCxvPplTSuDg8h3GznAk6m2DI3Zd/OLx9vFePv1QKRmjqSemq/QYQW1ifhZHeg1clPo2Y6brtQnWVgTS76px3iwazmMA/uV6pIgZNoo4C5T32un8hOoQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Bh+9/yjpA36Z0gYELBd1VLnddNycO0Y4Cu5XB0uUMEM=;
 b=XY1TkbHdlvWxjy3UvvCiNY6vAsaQjHEjnf+Ss/X6VTw7ERgA4eAeLew9kyZiy0eKs4/oJAO8tODGqDDiyFqMnpVO9VWbL/lBdQ/t71NHwOO/ZVUzsvAk2W4k05NIExjDjTTAF90zV9oTQrGEmB35yM8+swYG29ahA+Rk+pqjwmBAx6jvWMCk0qQpsnIzfG7KB7cyHXUzbQoHIQ5bVgkrJqdTzRJJuNs2lhrSZ9n5Uyws0LXqES8Ynl/QvEXuQmE4ijlv8bnionooxPQaJ6ZF5CPrPUpgFX+P1tDyT6ngTRcNyxHXLnOYBPKt0O5RJuwoog1ibv/4olO3pQ5F13+Leg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=kernel.org smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Bh+9/yjpA36Z0gYELBd1VLnddNycO0Y4Cu5XB0uUMEM=;
 b=0pkP81LZP7E1Y9v+EO/9yLc8ITzDhEAPNMmU0WcDNXxDP+1Dh9Fh0LVsOg0WsLemJXB2dZhEh9Zk7RniuLn4rp0kGkYnBy3yTBgqoXEpnUPNBtHqrjUfot1QYcHhpa/S/O/KswayM4gMDzWCd2+4RZf+Ewm/K81n7bM60h56azk=
Received: from SJ0PR13CA0103.namprd13.prod.outlook.com (2603:10b6:a03:2c5::18)
 by CH2PR12MB4245.namprd12.prod.outlook.com (2603:10b6:610:af::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9115.23; Wed, 17 Sep
 2025 12:57:09 +0000
Received: from MWH0EPF000989EC.namprd02.prod.outlook.com
 (2603:10b6:a03:2c5:cafe::86) by SJ0PR13CA0103.outlook.office365.com
 (2603:10b6:a03:2c5::18) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9137.13 via Frontend Transport; Wed,
 17 Sep 2025 12:57:09 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb08.amd.com; pr=C
Received: from satlexmb08.amd.com (165.204.84.17) by
 MWH0EPF000989EC.mail.protection.outlook.com (10.167.241.139) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9137.12 via Frontend Transport; Wed, 17 Sep 2025 12:57:09 +0000
Received: from SATLEXMB05.amd.com (10.181.40.146) by satlexmb08.amd.com
 (10.181.42.217) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.2.2562.17; Wed, 17 Sep
 2025 05:57:08 -0700
Received: from satlexmb08.amd.com (10.181.42.217) by SATLEXMB05.amd.com
 (10.181.40.146) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Wed, 17 Sep
 2025 07:57:08 -0500
Received: from [10.252.198.192] (10.180.168.240) by satlexmb08.amd.com
 (10.181.42.217) with Microsoft SMTP Server id 15.2.2562.17 via Frontend
 Transport; Wed, 17 Sep 2025 05:57:03 -0700
Message-ID: <9f2b02e2-f3b2-40aa-8e31-e940f4c2b90b@amd.com>
Date: Wed, 17 Sep 2025 18:27:02 +0530
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 05/12] KVM: x86: Add emulation support for Extented LVT
 registers
To: Naveen N Rao <naveen@kernel.org>
CC: <kvm@vger.kernel.org>, <linux-perf-users@vger.kernel.org>,
	<linux-doc@vger.kernel.org>, <seanjc@google.com>, <pbonzini@redhat.com>,
	<nikunj@amd.com>, <bp@alien8.de>, <peterz@infradead.org>, <mingo@redhat.com>,
	<mizhang@google.com>, <thomas.lendacky@amd.com>, <ravi.bangoria@amd.com>,
	<Sandipan.Das@amd.com>
References: <20250901051656.209083-1-manali.shukla@amd.com>
 <20250901052238.209184-1-manali.shukla@amd.com>
 <xnwr5tch7yeme3feo6m4irp46ju5lu6gr4kurn6oxlgoutvabt@3k3xh2pbdbje>
Content-Language: en-US
From: Manali Shukla <manali.shukla@amd.com>
In-Reply-To: <xnwr5tch7yeme3feo6m4irp46ju5lu6gr4kurn6oxlgoutvabt@3k3xh2pbdbje>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Received-SPF: None (SATLEXMB05.amd.com: manali.shukla@amd.com does not
 designate permitted sender hosts)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MWH0EPF000989EC:EE_|CH2PR12MB4245:EE_
X-MS-Office365-Filtering-Correlation-Id: 6a8555f2-ea20-4de5-2346-08ddf5e9b67d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|82310400026|36860700013|7416014|376014|13003099007;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?eElrWFJWdkdVZ0k0S2kyV2MyY21neEpLZFNzOGpUWkduZHM0dzRJUTRTTlAr?=
 =?utf-8?B?cmduYTVQaWJDa1RxK2g4OXhDN21PM3FPS2d5c2paZnRhRnpWK2JDcGlXeDhJ?=
 =?utf-8?B?TUhMRk13ck5OUThWT0xJR0NqeXMvY25laWNkVWhWNjExMkJXVXBuRXdERU1v?=
 =?utf-8?B?ZE80RFdHT0tpMVlvaEhaYnVIaGJ5MzJyb0hQWE01ajg4cW5UQncvaUFBT3hB?=
 =?utf-8?B?a243eitMSFF2Y3k1VitSU3gyQ281M1JBTHc5aURWODA0OWNDeCtkandzV3RI?=
 =?utf-8?B?djJTYWEzTDZTMHo5RUtteUEwbXlFZjdLcGwyZzAzSFdSMElzU0hoTng2T3Q4?=
 =?utf-8?B?OFhaTzlLYkhzWWRReXpxVkRwblVMRFNra2ptRlZ2bGppb0hSVzRJbUpWelQ0?=
 =?utf-8?B?RlZwOG83L2l6dkd6WHg0WnhWU1ZNT0VrektJUkJMd2JtaVo5QkJEZVFqc3FK?=
 =?utf-8?B?WkVYSVFvQXZva2NGRy9QVlMxN2kzcHBlb2l5NXdneiszREJwamh1VkpKQ0FO?=
 =?utf-8?B?YUt3bEhWWi9paTNYSDJpamNoaE9IRUc0WWJQT1pvNk0raG1uSHdZTzRGTmIz?=
 =?utf-8?B?eEx3K2J0YXFnSWdZZzNhWjM0WjFIR2JvYTFvQnppazVUb21FaXBpaUhFNVVr?=
 =?utf-8?B?Y0Nmc0MyakhzTER2bTV6VFBCbkM3R0hmZzl1REdYWGJNV3lheEdsSGVNMzVk?=
 =?utf-8?B?Q2VaZ2VndkRVS0pVbnpSc1dsMGV0WDFsUzZGSHdGV2dNQXR1YVBHMEtwRGxr?=
 =?utf-8?B?dk5XQzI4NTUwRDdnZkVuUlcxd1A2UlBLRzllQ05tc1JXb1I1SDhvMUcrWWF2?=
 =?utf-8?B?VDAwZ1RMRzNDRm1UOGsyTjZYNW9UVEpBcU1VUEJKRk4xYUlsRGNvUUVRdW5Q?=
 =?utf-8?B?c2NMZWxPeWk1YkNqNTNvN09Sb3NvQk9WRDl5T3ZSNFFmTTc4SDMzVVl5d2VZ?=
 =?utf-8?B?RmtqYkZrQ2pWc1RmTW1vOVVKR2RUS0VkVkQzcXhUSkZ2S0NGR09SV2JaNTJw?=
 =?utf-8?B?L0diaDEvSUlNNFdla2tEcXNqallndEJjODI2Q0JLVWlJNkl5d2RpdmNEbm4w?=
 =?utf-8?B?VlhXVHd2L0oxYzlPTWpVYWhkZWU2MGxrYklBQ3NNZi95MS92MUl1d2RGS3Y0?=
 =?utf-8?B?UEE4cXpyS0RGOHRqcHd2YVdQSlEyVGE1WWNITmZBempaVVBWYjdRaWVSNHRJ?=
 =?utf-8?B?bHczbEhWZEQwZVRBeVhUeG93RmQ5SkErdkJxeEt2TUMwU1RSQnlZZGtGcE1l?=
 =?utf-8?B?REdZaXNZSFRaVzJIREhvdVJuS0EwdC8zRXBDOS8wN3RSVUF6Q0VYN0tCcFV2?=
 =?utf-8?B?V1Vpc1FVMnJwZ0I3V2xHbm5VVURiZEJlU1NCYnBLNmVPZnVpL0dlVnRuZFF1?=
 =?utf-8?B?NjYyNlRaL29GVkVtdEM2V2RXUXBPdmNYR21kc1pPTVVKejlaRlJkS0t1UWQ0?=
 =?utf-8?B?bTVsMEhpUjdTQ0tzUXVYOXFOd0hzTk5NVXBBSVZYR3RxMjd1Mm5hMklDMVg1?=
 =?utf-8?B?SXEyUVp0SzM0UXNVWEU3UTNoS0RnNk5tbDkyOGFjckc2VS9OWGcxOUNWczFB?=
 =?utf-8?B?c0ZwYjRsR0JkKzQwclJOZ0k0Mm9SWHFBQUlOUnExTHVwYit4VjdtT1Bycklv?=
 =?utf-8?B?cEd2ZU1KTzNiaGZiYTJ1WUVXNVd5UW15Q0Y1S1pKcVY5M09qTVZNUE5MdjVT?=
 =?utf-8?B?UWJQZlh1eGVwK2NnaERtMVlMODNvdnVzZDJsZHl1WUNxeVlucXBXS0RiMUIw?=
 =?utf-8?B?OU45c09YNmtPZytOcndTS1hnVGtJN3dEU1RhSHJ5M1ZRYmJucU5DOFROY2FR?=
 =?utf-8?B?aThmWUVmZzhsdEFBR0ZJSHFScmErZUt6SkVDWXA4Q2NtdEVncnIydVVOc2tn?=
 =?utf-8?B?bm5TNURGQjZpZ1VlanNaQzgvaWQzanpIZzhBa3VUaHpMWUt4SjRubXV5Q1RC?=
 =?utf-8?B?Wk1tRnQrdHpZZCs1Y1dmamZYVXFJUFduTnJDSWdvcEp4Z1ExSnp6TFhVNE9R?=
 =?utf-8?B?ZVB2TzlpaFNBPT0=?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:satlexmb08.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(1800799024)(82310400026)(36860700013)(7416014)(376014)(13003099007);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Sep 2025 12:57:09.2978
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 6a8555f2-ea20-4de5-2346-08ddf5e9b67d
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb08.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	MWH0EPF000989EC.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR12MB4245

On 9/8/2025 7:11 PM, Naveen N Rao wrote:
> On Mon, Sep 01, 2025 at 10:52:38AM +0530, Manali Shukla wrote:
>> From: Santosh Shukla <santosh.shukla@amd.com>
>>
>> The local interrupts are extended to include more LVT registers in
>> order to allow additional interrupt sources, like Instruction Based
>> Sampling (IBS) and many more.
>>
>> Currently there are four additional LVT registers defined and they are
>> located at APIC offsets 400h-530h.
>>
>> AMD IBS driver is designed to use EXTLVT (Extended interrupt local
>> vector table) by default for driver initialization.
>>
>> Extended LVT registers are required to be emulated to initialize the
>> guest IBS driver successfully.
>>
>> Please refer to Section 16.4.5 in AMD Programmer's Manual Volume 2 at
>> https://bugzilla.kernel.org/attachment.cgi?id=306250 for more details
>> on Extended LVT.
>>
>> Signed-off-by: Santosh Shukla <santosh.shukla@amd.com>
>> Co-developed-by: Manali Shukla <manali.shukla@amd.com>
>> Signed-off-by: Manali Shukla <manali.shukla@amd.com>
>> ---
>>  arch/x86/include/asm/apicdef.h | 17 ++++++++++++++
>>  arch/x86/kvm/cpuid.c           |  6 +++++
>>  arch/x86/kvm/lapic.c           | 42 ++++++++++++++++++++++++++++++++++
>>  arch/x86/kvm/lapic.h           |  1 +
>>  arch/x86/kvm/svm/avic.c        |  4 ++++
>>  arch/x86/kvm/svm/svm.c         |  6 +++++
>>  6 files changed, 76 insertions(+)
>>
> 
> <snip>
> 
>> diff --git a/arch/x86/kvm/svm/avic.c b/arch/x86/kvm/svm/avic.c
>> index a34c5c3b164e..1b46de10e328 100644
>> --- a/arch/x86/kvm/svm/avic.c
>> +++ b/arch/x86/kvm/svm/avic.c
>> @@ -669,6 +669,10 @@ static bool is_avic_unaccelerated_access_trap(u32 offset)
>>  	case APIC_LVTERR:
>>  	case APIC_TMICT:
>>  	case APIC_TDCR:
>> +	case APIC_EILVTn(0):
>> +	case APIC_EILVTn(1):
>> +	case APIC_EILVTn(2):
>> +	case APIC_EILVTn(3):
> 
> This should actually be conditional on X86_FEATURE_EXTLVT.

Sure. I will incorporate it in V2.>
> I also forgot to add for the previous patch: the feature name needs to 
> be changed to reflect the true nature of the feature bit.

Ack, I agree the feature bit name should reflect its true nature.
Happy to rename it. Any specific suggestion for the name?

> 
> 
> - Naveen
> 


