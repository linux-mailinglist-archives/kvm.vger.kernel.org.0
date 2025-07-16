Return-Path: <kvm+bounces-52607-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 07F14B072C3
	for <lists+kvm@lfdr.de>; Wed, 16 Jul 2025 12:10:47 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id F06773AEF8E
	for <lists+kvm@lfdr.de>; Wed, 16 Jul 2025 10:10:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AD4892F273C;
	Wed, 16 Jul 2025 10:10:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="hXJpIv0Z"
X-Original-To: kvm@vger.kernel.org
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2055.outbound.protection.outlook.com [40.107.220.55])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EA2C22F2C56;
	Wed, 16 Jul 2025 10:10:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.220.55
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752660625; cv=fail; b=syETPRS6JOtUjjvbFXQGEaOvV8IBv3kCyRh5stL0qqxClxFr6JE/3v/oSeX8Xr/XL9dMuy5hAdF0rqt3FM/sanHIEUbz2kGGGkc8S9EwhGyX2n0QdMBl4ww3T7N30wARhfJL/hU72Nt4DjPYFPEAEojkzhowM5g+QuZnC5Kfh10=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752660625; c=relaxed/simple;
	bh=5KcC5+s11lQKVIYWiS9dABOofmUthY+qBjTLE3m7is8=;
	h=Message-ID:Date:MIME-Version:Subject:To:CC:References:From:
	 In-Reply-To:Content-Type; b=s3Vcxx+6neG6cUWZHh6fgi5USwAdd04ByZws2V1ohm886XwZs/eb9i77ZxgZzRX/qtuvpiYZIysejmpvYzRRZNF4qMLrZ1jo3HcpaO75fI08131r3/W4AheSi8Ml/G3VS5gr/GrkEh1NoYdjEOtc6olsse8L1JKh3DrJiSad2v8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=hXJpIv0Z; arc=fail smtp.client-ip=40.107.220.55
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=s9iDAYlsZuFsz5tbh6+rIy8n3Yvsr/X80b1kcD9y1OkISdICyJA423lnKsnQ+cEuEi3s+/qkb9hNN+lHNe96EXIl18cO7EckgkPA87qrVtLRfVR8M8MMD0rXcRW5t5KEOgJdxabo5jjVMu+X8/pcILAX67koRwLXeMeIAn5IhpvXPojDnlmUKdZYunUyGgnd0rt/bpZm36dL1XfvX9BsX8tUcQKKOh6FsC+DQdYId/lZYHwawn9psFKXHol3OqNg9EezsWRsYbzLbApd289XlBk2/+9DyFQjibGRvO7jGWbdDGpbtJ9ue6izfxTSaK0T72ohHphXsJjBiefzRKrOww==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=2fN1eAO0+Nw1gIQpJKtSFwYISMMMpOZ2zzT0ibdKviU=;
 b=HK0u3S7xLzjF5ad01ACQWCxZDtPnAA2IxdBUBC+LwTEQ9v8FZhSBUVT1Zflu3LxXgXSec/WVGm3ychK7Ad5FTvfiqmlQfBp4TDMF+QaW/pD/RqDQsxObiOd5WE0lERyEkSB00AOJ7xj1V9JxjGgNiLbKKdmox509C1KLI3JEdbilxkz/iMV+wmbwMY5SCZrLCXgirzlewXbbrkZjftz2KagQb/2EShXTvNZ8b3moyeF0JncK472zGY3LCkyoKBfTiLyDCe4Mux/L2j++8/qIwUJXKHruSezolLLEoU6wS1PpTy3kHQdmRvFDPXf9vP++rpUTd8TzOC6colqaKujA1g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=linux.intel.com smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2fN1eAO0+Nw1gIQpJKtSFwYISMMMpOZ2zzT0ibdKviU=;
 b=hXJpIv0ZUA4fcRigjEq05SwPymVMewlGvt5CSc7OYXMdRvE3I6itG4gmQNRcazDtFI+jMxerEa7U7oqOA0IM/awW59IPdjv2Z0ZwrcBoIWz/mjfM8+NaaqDj4DhyAgZpd/tbOaquxu7P218mJ8TdpDi8jig1CVnX+ZYtj5CDe8Y=
Received: from MN2PR22CA0019.namprd22.prod.outlook.com (2603:10b6:208:238::24)
 by BN7PPFED9549B84.namprd12.prod.outlook.com (2603:10b6:40f:fc02::6e7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8678.33; Wed, 16 Jul
 2025 10:10:19 +0000
Received: from BL02EPF0001A0FD.namprd03.prod.outlook.com
 (2603:10b6:208:238:cafe::9d) by MN2PR22CA0019.outlook.office365.com
 (2603:10b6:208:238::24) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8943.20 via Frontend Transport; Wed,
 16 Jul 2025 10:10:19 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB03.amd.com; pr=C
Received: from SATLEXMB03.amd.com (165.204.84.17) by
 BL02EPF0001A0FD.mail.protection.outlook.com (10.167.242.104) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.8922.22 via Frontend Transport; Wed, 16 Jul 2025 10:10:18 +0000
Received: from SATLEXMB06.amd.com (10.181.40.147) by SATLEXMB03.amd.com
 (10.181.40.144) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Wed, 16 Jul
 2025 05:10:18 -0500
Received: from SATLEXMB04.amd.com (10.181.40.145) by SATLEXMB06.amd.com
 (10.181.40.147) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Wed, 16 Jul
 2025 05:10:18 -0500
Received: from [10.252.203.104] (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server id 15.1.2507.39 via Frontend
 Transport; Wed, 16 Jul 2025 05:10:14 -0500
Message-ID: <afafc865-b42f-4a9d-82d7-a72de16bb47b@amd.com>
Date: Wed, 16 Jul 2025 15:40:13 +0530
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v1 04/11] KVM: x86: Add emulation support for Extented LVT
 registers
To: "Mi, Dapeng" <dapeng1.mi@linux.intel.com>, <kvm@vger.kernel.org>,
	<linux-perf-users@vger.kernel.org>, <linux-doc@vger.kernel.org>
CC: <seanjc@google.com>, <pbonzini@redhat.com>, <nikunj@amd.com>,
	<bp@alien8.de>, <peterz@infradead.org>, <mingo@redhat.com>,
	<mizhang@google.com>, <thomas.lendacky@amd.com>, <ravi.bangoria@amd.com>,
	<Sandipan.Das@amd.com>
References: <20250627162550.14197-1-manali.shukla@amd.com>
 <20250627162550.14197-5-manali.shukla@amd.com>
 <3b37d820-12cd-4f33-b059-66e12693b779@linux.intel.com>
Content-Language: en-US
From: Manali Shukla <manali.shukla@amd.com>
In-Reply-To: <3b37d820-12cd-4f33-b059-66e12693b779@linux.intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL02EPF0001A0FD:EE_|BN7PPFED9549B84:EE_
X-MS-Office365-Filtering-Correlation-Id: c80b48bf-0a50-4d66-eb1e-08ddc450f7a9
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|1800799024|36860700013|376014|7416014|13003099007;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?Um1FUTVvU0FlOHRaS2hwVkhnRnAxck1td3ZUbWI5NTY5Q1BXOXNVL1dSbHdC?=
 =?utf-8?B?RU8zWDRWZ3BTaG1KYStzVS9haENCb2JsQlJhYXd5UklNNGk3clVFSFhWZGRV?=
 =?utf-8?B?MmRyRlk3T1ZlSjVlMjlVS0xRTC91S215VDRQcW1VL1M5Tzk2bitrZVBHYTJy?=
 =?utf-8?B?UVRTa1Q3VUJRcUFPRUkzV3Y2QllaM0ZOb0hhMWlLeDU2d1U3MzNsdlBPRVdF?=
 =?utf-8?B?NEhzTFNkckdRNUp4S1lTV2pNRnF0Tk8wbTB6VXd5R1A5VFZlSlJvblNWRUhO?=
 =?utf-8?B?Z2RPb2NXZ05NVURYS0g1aWFnTUk4TTkxWGY0R0dzcU51NUdBN3dNUmd3cnVj?=
 =?utf-8?B?RHhmc1dkL055OG1QWDVIcXk0NFNCNFhSR1FaYmE4bTNlUnpDZU1SU0Vhc3V3?=
 =?utf-8?B?WnFNY1dLL2RUS0d3TDJVWFNuTnhiVjVqMjgyYUZ5YjkzMTR2R3d1aTBJdVdy?=
 =?utf-8?B?cFM4bUowaHNMdE9naHI2d1Nmam1peHRaL3JlSWFIRmw1RG8wcWZZbFJHVU1r?=
 =?utf-8?B?ZEFKc0pwL3NwYjljUlRBcWp0aTNkNEVuT0ZKUmxFUDgvcFZiRit5bVQzSmd0?=
 =?utf-8?B?cCtUQkxMaWhRaW81Z1pHU2Y2T3NvbEpFenljVnZ4VVVTSVVkVlFoWHd3M09J?=
 =?utf-8?B?N1djSXlGYUZNRCsrWjJaL29uUlBDODl6TXVOd3VMb3pXQjIzaDJVUmdKcEt4?=
 =?utf-8?B?aUZ2NUEyWHQxcGhwSHMzVnA0SVRJZ0cva3FrZW5vU1pxL2R2TC82YjhEa2xz?=
 =?utf-8?B?dk9JcDgvbG9rWUVQNTRsdFpZNTNmNzc0MEZvWHVzeTBkek1mWlRJU0ZpRjZr?=
 =?utf-8?B?UTZPbC9mWk5UOTcxeEVwRWZoZC91UmlSYVlMZzRDY1N0aUNHQWVDRXRkYmd3?=
 =?utf-8?B?VlBmWXpxNTQ0Z0lmN3IwR25QYjdYM0U4ekk5bGtsNGowS29VWkNTdTdwdmtO?=
 =?utf-8?B?Q3J2S3JVQkdrQy9SYm1abFJoSUhiTC9mWGVvOXZoSXFQMElMck85Q3NzWDcy?=
 =?utf-8?B?dm1YdmFRYW81Zk1IWlBWa1RwQTVRL2FvMXVlQ2hOd0pWcjNnYTFtSmFaZ3Iz?=
 =?utf-8?B?SnI3ejhKSE1NV25KRlMvU1cycExFb1FXLzBaN3FNTDFKd3ErWW9jU1RCRGV6?=
 =?utf-8?B?Q1JVcCtaNW9HeFU0Z0ZqM0tkVWZ4L0Q4ODJxRFFSOTVPTWhadGViWjFyRkli?=
 =?utf-8?B?V1BtUkhjYTlQWk5OSU1oUFdmbHlTM29oYmhxbzhhS3RvWTRJb25aQVhpdVdo?=
 =?utf-8?B?OFNTd0FJZ09ZU3EzUWV1TDdZYjBsWlF3WjR5d3BoaHlLb241VlNvQzRkR05s?=
 =?utf-8?B?dlkrc3JucXFwTWFRMkdPUUUxTFJydnllQUhzaXJYdmNjMGpmQkd5NnZpVUFD?=
 =?utf-8?B?alZqUFBWTFEvRCtpc0F4RCtPd0Yvd1U3eTFzTUVGcmRKTG5MRGE4U2JiVVJJ?=
 =?utf-8?B?bzRtbkFCdUF1TUtBc3JFTTlDaG9pSjJDZkd0bE1DdzhNN1huK1U5dDNpWVpi?=
 =?utf-8?B?Y05FL2Mza0hEZjNMdjQ2bFp5RFRFamkrdzJsQnNhNFY3OElBb0xnTnlHY3pB?=
 =?utf-8?B?bkdCeGdXTkZ3WUNxdi94YmlYdWVlRXhsU1dJaU8rYXJMM2xwbjNUelgwTjZk?=
 =?utf-8?B?cXdXZWZ5Q09IRHNmZUtzenBlazlvdHUrRnZUUTNPNnF1S1dkMHplZEk5TlNh?=
 =?utf-8?B?cTRVck54NDhCb2FqT200bW5Cc3ZKNlJJNEdHQW1adFlXekR3Qzh5YVVkRTZG?=
 =?utf-8?B?V2xEM2hOcVJ6c25naHVTVlAzT3ptRVFGTFNWVmJrc1piZmc5cFpGZUJZQVpl?=
 =?utf-8?B?R2VFcXY4OHFpOEp5VFkxd2YxTXd6MGhaUURndzh2aUlSaVQ1bUk2ODkvcnFR?=
 =?utf-8?B?TU1vSHpKQWI1K1Q0ZXBlTnVVQ0ltWnlLejcrRUxvTmlCZlF6Yks2RWhsZG9W?=
 =?utf-8?B?RmgydnEyWHFXZFJTTmtwZ1R6bGtOSTk1MVcvMHFOVXJWNlMzb3VOWElEeGI3?=
 =?utf-8?B?cnFjbjFvcTFwUUN6VURVZTB0UTB3aHBDODlXcGNWaDRrWkZjSjFqdUc2V1JX?=
 =?utf-8?B?SE11cHJ6cHlTVmhHaFVjMFFaK0s0TzBGSUhLZz09?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB03.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(82310400026)(1800799024)(36860700013)(376014)(7416014)(13003099007);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Jul 2025 10:10:18.7501
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: c80b48bf-0a50-4d66-eb1e-08ddc450f7a9
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB03.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BL02EPF0001A0FD.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN7PPFED9549B84

Hi Dapeng Mi,

Thanks for reviewing my patches.

On 7/15/2025 8:28 AM, Mi, Dapeng wrote:
> 
> On 6/28/2025 12:25 AM, Manali Shukla wrote:
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
>>  arch/x86/include/asm/apicdef.h | 17 +++++++++
>>  arch/x86/kvm/cpuid.c           |  6 +++
>>  arch/x86/kvm/lapic.c           | 69 +++++++++++++++++++++++++++++++++-
>>  arch/x86/kvm/lapic.h           |  1 +
>>  arch/x86/kvm/svm/avic.c        |  4 ++
>>  arch/x86/kvm/svm/svm.c         |  4 ++
>>  6 files changed, 99 insertions(+), 2 deletions(-)
>>
>> diff --git a/arch/x86/include/asm/apicdef.h b/arch/x86/include/asm/apicdef.h
>> index 094106b6a538..4c0f580578aa 100644
>> --- a/arch/x86/include/asm/apicdef.h
>> +++ b/arch/x86/include/asm/apicdef.h
>> @@ -146,6 +146,23 @@
>>  #define		APIC_EILVT_MSG_EXT	0x7
>>  #define		APIC_EILVT_MASKED	(1 << 16)
>>  
>> +/*
>> + * Initialize extended APIC registers to the default value when guest
>> + * is started and EXTAPIC feature is enabled on the guest.
>> + *
>> + * APIC_EFEAT is a read only Extended APIC feature register, whose
>> + * default value is 0x00040007. However, bits 0, 1, and 2 represent
>> + * features that are not currently emulated by KVM. Therefore, these
>> + * bits must be cleared during initialization. As a result, the
>> + * default value used for APIC_EFEAT in KVM is 0x00040000.
>> + *
>> + * APIC_ECTRL is a read-write Extended APIC control register, whose
>> + * default value is 0x0.
>> + */
>> +
>> +#define		APIC_EFEAT_DEFAULT	0x00040000
>> +#define		APIC_ECTRL_DEFAULT	0x0
>> +
>>  #define APIC_BASE (fix_to_virt(FIX_APIC_BASE))
>>  #define APIC_BASE_MSR		0x800
>>  #define APIC_X2APIC_ID_MSR	0x802
>> diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
>> index eb7be340138b..7270d22fbf31 100644
>> --- a/arch/x86/kvm/cpuid.c
>> +++ b/arch/x86/kvm/cpuid.c
>> @@ -458,6 +458,12 @@ void kvm_vcpu_after_set_cpuid(struct kvm_vcpu *vcpu)
>>  	/* Invoke the vendor callback only after the above state is updated. */
>>  	kvm_x86_call(vcpu_after_set_cpuid)(vcpu);
>>  
>> +	/*
>> +	 * Initialize extended LVT registers at guest startup to support delivery
>> +	 * of interrupts via the extended APIC space (offsets 0x400–0x530).
>> +	 */
>> +	kvm_apic_init_eilvt_regs(vcpu);
>> +
>>  	/*
>>  	 * Except for the MMU, which needs to do its thing any vendor specific
>>  	 * adjustments to the reserved GPA bits.
>> diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
>> index 00ca2b0faa45..cffe44eb3f2b 100644
>> --- a/arch/x86/kvm/lapic.c
>> +++ b/arch/x86/kvm/lapic.c
>> @@ -1624,9 +1624,13 @@ static inline struct kvm_lapic *to_lapic(struct kvm_io_device *dev)
>>  }
>>  
>>  #define APIC_REG_MASK(reg)	(1ull << ((reg) >> 4))
>> +#define APIC_REG_EXT_MASK(reg)	(1ull << (((reg) >> 4) - 0x40))
> 
> It seems there is no difference on the MASK definition between
> APIC_REG_MASK() and APIC_REG_EXT_MASK(). Why not directly use the original
> APIC_REG_MASK()?
> 

The Extended LVT registers range from 0x400 to 0x530. When using
APIC_REG_MASK(reg) with reg = 0x400 (as an example), the operation
results in a right shift of 64(0x40) bits, causing an overflow. This was
the actual reason of creating a new macro for extended APIC register space.

> BTW, If we indeed need to define this new macro, could we define the macro
> like blow?
> 
> #define APIC_REG_EXT_MASK(reg)	(1ull << (((reg) - 0x400) >> 4))
> 
> It's more easily to understand. 
> 

I can define the macro in this way.

> 
>>  #define APIC_REGS_MASK(first, count) \
>>  	(APIC_REG_MASK(first) * ((1ull << (count)) - 1))
>>  
>> +#define APIC_LAST_REG_OFFSET		0x3f0
>> +#define APIC_EXT_LAST_REG_OFFSET	0x530
>> +
>>  u64 kvm_lapic_readable_reg_mask(struct kvm_lapic *apic)
>>  {
>>  	/* Leave bits '0' for reserved and write-only registers. */
>> @@ -1668,6 +1672,8 @@ EXPORT_SYMBOL_GPL(kvm_lapic_readable_reg_mask);
>>  static int kvm_lapic_reg_read(struct kvm_lapic *apic, u32 offset, int len,
>>  			      void *data)
>>  {
>> +	u64 valid_reg_ext_mask = 0;
>> +	unsigned int last_reg = APIC_LAST_REG_OFFSET;
>>  	unsigned char alignment = offset & 0xf;
>>  	u32 result;
>>  
>> @@ -1677,13 +1683,44 @@ static int kvm_lapic_reg_read(struct kvm_lapic *apic, u32 offset, int len,
>>  	 */
>>  	WARN_ON_ONCE(apic_x2apic_mode(apic) && offset == APIC_ICR);
>>  
>> +	/*
>> +	 * The local interrupts are extended to include LVT registers to allow
>> +	 * additional interrupt sources when the EXTAPIC feature bit is enabled.
>> +	 * The Extended Interrupt LVT registers are located at APIC offsets 400-530h.
>> +	 */
>> +	if (guest_cpu_cap_has(apic->vcpu, X86_FEATURE_EXTAPIC)) {
>> +		valid_reg_ext_mask =
>> +			APIC_REG_EXT_MASK(APIC_EFEAT) |
>> +			APIC_REG_EXT_MASK(APIC_ECTRL) |
>> +			APIC_REG_EXT_MASK(APIC_EILVTn(0)) |
>> +			APIC_REG_EXT_MASK(APIC_EILVTn(1)) |
>> +			APIC_REG_EXT_MASK(APIC_EILVTn(2)) |
>> +			APIC_REG_EXT_MASK(APIC_EILVTn(3));
>> +		last_reg = APIC_EXT_LAST_REG_OFFSET;
>> +	}
> 
> Why not move this code piece into kvm_lapic_readable_reg_mask() and
> directly use APIC_REG_MASK() for these extended regs? Then we don't need to
> modify the below code. 
> 
> 


