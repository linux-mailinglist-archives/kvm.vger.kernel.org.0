Return-Path: <kvm+bounces-59865-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [142.0.200.124])
	by mail.lfdr.de (Postfix) with ESMTPS id 32EE8BD1792
	for <lists+kvm@lfdr.de>; Mon, 13 Oct 2025 07:37:11 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 5E1C34E7F07
	for <lists+kvm@lfdr.de>; Mon, 13 Oct 2025 05:37:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 029222DC76A;
	Mon, 13 Oct 2025 05:37:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="to/ikK68"
X-Original-To: kvm@vger.kernel.org
Received: from DM5PR21CU001.outbound.protection.outlook.com (mail-centralusazon11011004.outbound.protection.outlook.com [52.101.62.4])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5BEF42D46C8;
	Mon, 13 Oct 2025 05:37:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.62.4
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760333824; cv=fail; b=M45khXPgwPqDH8/1a6qeRJyq2B8gbBMb6mFDZNwYWv9UckGqMrYkXBE/w2cUeMz4GVAq5p79J0B3vKZGy9ds+u8MEXlzW2FFPIwC4iLPq1cDU7ml5UKVANj0LYjmRbuACyAre3B/bMCFUxEfoOw1PpI75prc5DkuQQRi5nmnvYE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760333824; c=relaxed/simple;
	bh=rBk3S3c50Ey/xa3dv/jN/yI6HIAiBoFrI5fTst1309M=;
	h=Message-ID:Date:MIME-Version:Subject:To:CC:References:From:
	 In-Reply-To:Content-Type; b=e8rwh48YvC+hPmOONA4zACsXVZ7facbXaOUQxC0uQgVpp7liVXVOVWavBlvhMgeFAZiTonKnv/xDK9rKicYj59LtaMFlx8gYWYZdSk2Olud1AeeiCrc0Prz2ZEd2rKwsZL0c6mJCC/SiyoxWtKfrgzKcjNKaIrcg1JjGsUnUIrs=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=to/ikK68; arc=fail smtp.client-ip=52.101.62.4
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=CXp74rNsS61WrAVhb7Bmw9vNKqcTuLtJKsHiaB+xqJcBLYV98dm6ZXzqt5bJMU7bnjja9eJk5DBx1IE6DHzs/8EqOeskuIWKBBBE5I7PnfrcFkVhnafbjnp5hqVzKQW+6hP5RwWqlcBUYVkSbo80QKPfhssydRrvgGe0RSDMoHBu+ErLjmm559jQcHDYvF0viXVyEXil83uNLQ6goF3KVUeU6PSh4pQ4waUqriS49VRq009SeoJRRbaYBr73Q8IVrv1Zvd2nvqt8MAhuQ0xAG7Od0OQ3+bebu9Va8AhOFOyzLoUzx2qfJ0nhj+uAXqsb9GDUwa+Wtj9/YKXBY4IfZw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=gCOHY5HoceEsEQ+Ui+8xfMqaJtME11MyU2pzhMT1Zf8=;
 b=MEf2F3loXot+YnQzlLqRMUEevBZ87Y72hJ8oVLucpgAfedsGs5+K0BHy+s+MnaQ+p2sDTlxX2KcRV+rPzP2/LjNhEjwbzoSNnSFRBIuWwbheQnH+Akhm5iefF9qBHLSxMv4XFkfTYQh8Lq3g7ePfCQNEAPCg7SxXDmR+VHfYwqvxEOiqLg9s8r5y/VQ30qVSwNBnvofHbC3i62SeI4lgTSJ7kRUhvFaP3h/wXLk1z3C9hdYGTqSXE8mvOgrYiKrPryvYNCk68m52IPapV4MjLh6a2VmDUUyDgeZ8RqxAwYBnncoG3VFhXFcQcNTa7GIPMCN7npq3fmlcdkJ8b6g8jQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=kernel.org smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=gCOHY5HoceEsEQ+Ui+8xfMqaJtME11MyU2pzhMT1Zf8=;
 b=to/ikK68d6r4gjtalLxQJ+nmhyUzPs/My0xKQYmEHBi6c6BTU3Fb4y7KQrQLWvPU53fHCh6zKtnaDj6XaT5JZ+wQLDZVm8NrI1OpqskoyH+0JBb74K2XEdc5DqLJVmFS/eiITs0ndx/yJ/UWKx8VuZhFRxm8JIwE6ra8qYpTB+g=
Received: from SJ0P220CA0009.NAMP220.PROD.OUTLOOK.COM (2603:10b6:a03:41b::25)
 by MN2PR12MB4111.namprd12.prod.outlook.com (2603:10b6:208:1de::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9203.12; Mon, 13 Oct
 2025 05:36:58 +0000
Received: from SJ1PEPF00001CDD.namprd05.prod.outlook.com
 (2603:10b6:a03:41b:cafe::d2) by SJ0P220CA0009.outlook.office365.com
 (2603:10b6:a03:41b::25) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9203.13 via Frontend Transport; Mon,
 13 Oct 2025 05:36:50 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb08.amd.com; pr=C
Received: from satlexmb08.amd.com (165.204.84.17) by
 SJ1PEPF00001CDD.mail.protection.outlook.com (10.167.242.5) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9228.7 via Frontend Transport; Mon, 13 Oct 2025 05:36:57 +0000
Received: from Satlexmb09.amd.com (10.181.42.218) by satlexmb08.amd.com
 (10.181.42.217) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.17; Sun, 12 Oct
 2025 22:36:56 -0700
Received: from satlexmb08.amd.com (10.181.42.217) by satlexmb09.amd.com
 (10.181.42.218) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.17; Sun, 12 Oct
 2025 22:36:56 -0700
Received: from [10.252.198.192] (10.180.168.240) by satlexmb08.amd.com
 (10.181.42.217) with Microsoft SMTP Server id 15.2.2562.17 via Frontend
 Transport; Sun, 12 Oct 2025 22:36:52 -0700
Message-ID: <bbb7f19b-f54f-4d15-82c9-4468aaa8daca@amd.com>
Date: Mon, 13 Oct 2025 11:06:51 +0530
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
 <1acb5a6d-377b-4f0a-8a70-0dddaefa149c@amd.com>
 <gugvbbcl3q6qu3dabwyl75nsf7tvy4tbsa34s4on2q5jclz3fd@4my3uhrovbtv>
Content-Language: en-US
From: Manali Shukla <manali.shukla@amd.com>
In-Reply-To: <gugvbbcl3q6qu3dabwyl75nsf7tvy4tbsa34s4on2q5jclz3fd@4my3uhrovbtv>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ1PEPF00001CDD:EE_|MN2PR12MB4111:EE_
X-MS-Office365-Filtering-Correlation-Id: 47089c3c-ff10-45cd-e9fa-08de0a1a8679
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700013|376014|7416014|1800799024|82310400026|13003099007;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?TnJyZHV3Q0dwdUNweUpuMUR4amJ3a3dMdVl1eVRqcE9kTGJaOCtpUE1pSnVR?=
 =?utf-8?B?U0xLbE1UYjZYeW9kZFREaFZ2V3duMVByUXZjMjlvNW5obGdKWEVDemthNXRN?=
 =?utf-8?B?R1R1aFJ6aWFaNUtmOXJBaXB5U3k4WWQ5Yjk0YkdXSnJMbVM3aWNUK1grelBl?=
 =?utf-8?B?M2x0VVo1Si83ZDlmOXgyU2xWRFZkcWw0TG0xWnNRNVpzM0ZXOVkwbkdMU3hE?=
 =?utf-8?B?VHdxTnBBQzl0R1l3UGhrZXY0ZlZQRXVGMm8ycGRwVVdhT2MyK2FrdDljR1RL?=
 =?utf-8?B?c1FyRnF3K3l4NnFvaG16T3AwZENBMHZRellCZ011V1Fsb3o0aktNRm5sTlJL?=
 =?utf-8?B?L1R6dldoaWZGa3BrLzVOR0hUMVV6aGlrb3VYVFVDUVFpSHV2cXFCZ0xWQ0tQ?=
 =?utf-8?B?US85TmpmNHVob1pzMzBEdHAwZkIyYXVpYzBNc1pESEp1YnhZR05aMUU2dFl4?=
 =?utf-8?B?c2NzYWhvb1I0MFpQUkJ1T3I4L0NVdEU3MjZLODIyM0lxRDhPUG9BYkN5VmJG?=
 =?utf-8?B?dHNYYWdTQm1SNXh4MXJmNGNOTll2NFdJODV0ZS85ODVpTGNuVHl3OVR1WDdH?=
 =?utf-8?B?amZLTTlvWU1NdG4vNXRUSTRuUXo0dW9BTE1mTTIxZnpvR3g3WEV3eXhqd3Iv?=
 =?utf-8?B?Vy9Dd3lBdUs2WWthUEgxUXV0M1ZpbVhqYVJTT3dXSEkrNHFPK09ybGROdGhw?=
 =?utf-8?B?ZmJQeFpoQmc5MDVockVaR00wcm4xOWhURnJ4UlV3WjFCWEU3U1EvaFZMbWJ2?=
 =?utf-8?B?TCtXak9NTUNmVkdSbE1FTnZjV3NnN2UzbWJHVk1ydTJTUFF3MWhVSUxrMlVj?=
 =?utf-8?B?R0dra1MxeWxvVFVoYUxHVHU1SVUzc3RVbWJCVThFb0JFeEJ3REh6OS9VakZz?=
 =?utf-8?B?MnFacTY1ZExTNnVvYUJtbUFxTUh4b0xqME9FZjJUcjZZVzZiSFFJYXJSV29a?=
 =?utf-8?B?SFFuYmNlZEZLTkl2cE9sOW5mcUU1R1hMVDdidWF1YUc5eUJjcmxZOXg5M0sx?=
 =?utf-8?B?cnErWDBBQ2dQempFRmZYNC9VV0ZkTXNGM2tmZFRTR0lHcXNHOWh4ajB2dHZ3?=
 =?utf-8?B?SzNPbmM1OFVhTm1YYzNBZkJkSGpYTC9GeWJ1T2c0QzBSZ2E5dVJHS2NYRkVL?=
 =?utf-8?B?NDJsbUlIWWhjWmU1NUROZjA2eGFJRVo1dVBDeXZOQ3haL2lXcWtxSXFYeUF3?=
 =?utf-8?B?dUs0MGd5MFNFaVE4SVViVkFEN3dIbkJhK09vdklIYWxxRVJSdlR1M3B6R2ti?=
 =?utf-8?B?cm1IbFRJMk5HalBNVGgwRVpwYmVUMXVzaHpaa3JIMmx3TENNME5jbDRkS2Ju?=
 =?utf-8?B?NG9LbEFoQ0FETWRyUVJaVTI1dkpUUGlIdlRSbDlwWEs4VHdQUWFxaG9iQXJF?=
 =?utf-8?B?dXRKcWl3MzRnS2Fsd0VMMGpWanBWcHBEdDZOR3RkZTdVZVVBb01vQ1ptY3pz?=
 =?utf-8?B?d0dUZk82VlNyZ3d0ZlJocUd4eEU1YTFleFFUWXlRczJMT092a2NNNXNtQzlW?=
 =?utf-8?B?OHVOeU1QeWNBYnhCNm9SNi9Kd0p1ak04UHZhQXhHbmgzeWozQVUxQzVsZ1Nx?=
 =?utf-8?B?VHBGYmx5anBVNkRlZVVUR0tPcDdJcytueVF5TWkveHU2QkRnMGdaMGxhb1NS?=
 =?utf-8?B?ZTZjNm1zSW5CUG1Tam9ZcVJKaHRCdGc2aC80S3FZS0pXVFIrb01rc2dweFlT?=
 =?utf-8?B?MkFMZHZscThUM3lXZ2JQcmRGRjNuTFhEK0FLc2thOHd1WmNzNHRKWUJhN2RV?=
 =?utf-8?B?VWtycEhSVHhyaFIveE9ra0g0ZXkrM3lWTDQ2ckxaVHlQeXE5MGxsZWdyMmZ4?=
 =?utf-8?B?b25yMVNadlNUZnhmS0VRdDhmbDIvKzVtbmJKaHRBaEJXY3Z1MStPbi9kT2g0?=
 =?utf-8?B?ckg5aTBWNG1xSlE5ei9EdG9kdDg3Tlk2VGVraGFZYXVvV3NMN2RyaitCOERi?=
 =?utf-8?B?RGd3QUhOejJndXg3MUR1NlI2S21ZUkxOSnZTNlNyVlovcGpVcU1zTzlteXhJ?=
 =?utf-8?B?OWRhaiswaHlEOHJWUmhoNCsyK2V4WGFLWWVINTE3NjBXUC91QmN0dFBTVHpu?=
 =?utf-8?B?WFVFUzg5LzRoMGJsR1hsNnJWMDJkQm1kRDhNTnRGSGc3M2VlRHBRbFE5UVR2?=
 =?utf-8?Q?VcZ0=3D?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:satlexmb08.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(36860700013)(376014)(7416014)(1800799024)(82310400026)(13003099007);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Oct 2025 05:36:57.3401
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 47089c3c-ff10-45cd-e9fa-08de0a1a8679
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb08.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SJ1PEPF00001CDD.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR12MB4111

On 10/8/2025 12:28 PM, Naveen N Rao wrote:
> On Wed, Sep 17, 2025 at 09:04:57PM +0530, Manali Shukla wrote:
>> Hi Naveen,
>>
>> Thank you for reviewing my patches.
>>
>> On 9/8/2025 7:09 PM, Naveen N Rao wrote:
>>> On Mon, Sep 01, 2025 at 10:52:12AM +0530, Manali Shukla wrote:
>>>> From: Santosh Shukla <santosh.shukla@amd.com>
>>>>
>>>> Local interrupts can be extended to include more LVT registers in
>>>> order to allow additional interrupt sources, like Instruction Based
>>>> Sampling (IBS).
>>>>
>>>> The Extended APIC feature register indicates the number of extended
>>>> Local Vector Table(LVT) registers in the local APIC.  Currently, there
>>>> are 4 extended LVT registers available which are located at APIC
>>>> offsets (400h-530h).
>>>>
>>>> The EXTLVT feature bit changes the behavior associated with reading
>>>> and writing an extended LVT register when AVIC is enabled. When the
>>>> EXTLVT and AVIC are enabled, a write to an extended LVT register
>>>> changes from a fault style #VMEXIT to a trap style #VMEXIT and a read
>>>> of an extended LVT register no longer triggers a #VMEXIT [2].
>>>>
>>>> Presence of the EXTLVT feature is indicated via CPUID function
>>>> 0x8000000A_EDX[27].
>>>>
>>>> More details about the EXTLVT feature can be found at [1].
>>>>
>>>> [1]: AMD Programmer's Manual Volume 2,
>>>> Section 16.4.5 Extended Interrupts.
>>>> https://bugzilla.kernel.org/attachment.cgi?id=306250
>>>>
>>>> [2]: AMD Programmer's Manual Volume 2,
>>>> Table 15-22. Guest vAPIC Register Access Behavior.
>>>> https://bugzilla.kernel.org/attachment.cgi?id=306250
>>>>
>>>> Signed-off-by: Santosh Shukla <santosh.shukla@amd.com>
>>>> Signed-off-by: Manali Shukla <manali.shukla@amd.com>
>>>> ---
>>>>  arch/x86/include/asm/cpufeatures.h | 1 +
>>>>  1 file changed, 1 insertion(+)
>>>>
>>>> diff --git a/arch/x86/include/asm/cpufeatures.h b/arch/x86/include/asm/cpufeatures.h
>>>> index 286d509f9363..0dd44cbf7196 100644
>>>> --- a/arch/x86/include/asm/cpufeatures.h
>>>> +++ b/arch/x86/include/asm/cpufeatures.h
>>>> @@ -378,6 +378,7 @@
>>>>  #define X86_FEATURE_X2AVIC		(15*32+18) /* "x2avic" Virtual x2apic */
>>>>  #define X86_FEATURE_V_SPEC_CTRL		(15*32+20) /* "v_spec_ctrl" Virtual SPEC_CTRL */
>>>>  #define X86_FEATURE_VNMI		(15*32+25) /* "vnmi" Virtual NMI */
>>>> +#define X86_FEATURE_EXTLVT		(15*32+27) /* Extended Local vector Table */
>>>
>>> Per APM Vol 3, Appendix E.4.9 "Function 8000_000Ah", bit 27 is:
>>> ExtLvtAvicAccessChgExtended: Interrupt Local Vector Table Register AVIC 
>>> Access changes. See “Virtual APIC Register Accesses.”
>>>
>>> And, APM Vol 2, 15.29.3.1 "Virtual APIC Register Accesses" says:
>>> Extended Interrupt [3:0] Local Vector Table Registers:
>>> 	CPUID Fn8000_000A_EDX[27]=1:
>>> 		Read: Allowed
>>> 		Write: #VMEXIT (trap)
>>> 	CPUID Fn8000_000A_EDX[27]=0:
>>> 		Read: #VMEXIT (fault)
>>> 		Write: #VMEXIT(fault)
>>>
>>> So, as far as I can tell, this feature is only used to determine how 
>>> AVIC hardware handles accesses to the extended LVT entries. Does this 
>>> matter for vIBS? In the absence of this feature, we should take a fault 
>>> and KVM should be able to handle that.
>>>
>>
>> Yes, but KVM still needs to emulate extended LVT registers to handle the
>> fault when the guest IBS driver attempts to read/write extended LVT
>> registers.
>>
>> "KVM: x86: Add emulation support for Extented LVT registers"
>> patch covers two aspects:
>>
>> Extended LVT register emulation (EXTAPIC feature bit in
>> CPUID 0x80000001:ECX[3])
>>
>> ExtLvtAvicAccessChgExtended which changes the behavior of read/write
>> access when AVIC is enabled.
> 
> Sure, it will be good if you can separate out the changes required for 
> the latter, and perhaps move those at the beginning of this series.
> 
> - Naveen
> 

Sure. Will split the patches in V3.

-Manali


