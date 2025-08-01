Return-Path: <kvm+bounces-53829-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 8DCACB17F65
	for <lists+kvm@lfdr.de>; Fri,  1 Aug 2025 11:34:20 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 190F5A83D50
	for <lists+kvm@lfdr.de>; Fri,  1 Aug 2025 09:34:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2A575233736;
	Fri,  1 Aug 2025 09:33:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="3HfPrbpx"
X-Original-To: kvm@vger.kernel.org
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2046.outbound.protection.outlook.com [40.107.92.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0BD68231856;
	Fri,  1 Aug 2025 09:33:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.92.46
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754040800; cv=fail; b=OZrwzBoJLBSoFNyFrCvgarn+UABa652nq+lrvS8SU8bmcQP9JB/j2Mxfq1Yr7R1pXCiLBDQW2mHl0cc9qimE68/YUnDSsCVwAm9pUbECDDMVnrQKGvR4agpZT30w/gwBQBzX1fJubBqbxqDYivPnivPwPrY0jmXK1NQzFgsc4JY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754040800; c=relaxed/simple;
	bh=Wh1yqcs3ZhFiZjuvB2hjB1t3WdowtuzYCejMrgV7o5A=;
	h=Message-ID:Date:MIME-Version:Subject:To:CC:References:From:
	 In-Reply-To:Content-Type; b=N2NZKzZmJOx47tMYqzSJITKY8/QoDnJ90nKhIhwqx/pewhelwNnHbrBsZ9IGepIAeyT8v/k6K39YO6VKTIcha6dtfShIgwrHIBBahiK2Ew+D8jsEy3ZotS86M6JRWTghzkji+pWmevdw9GNRnMv8Sz/heypN0bAaFGhCM1IXi+Y=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=3HfPrbpx; arc=fail smtp.client-ip=40.107.92.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ngwVmWQN1ndjkmT8cnF/Fg0vDrSzkjE3hZ9tYZRExde55ybdAnEHWUYJOljgOGjbe2ecbtD2U58Dbb5WkK/U8AniLGXmRRXjbQJRjDGDkpT3PHJmcqdHa3o5SzCxYCKkDsn4DLLnjvzR/9ZpeFWyyfvJeI7GDjpiYV2xKvRHrj/aCHR3jkh474J5NvXlD6WvPoiVHIThP6EjnOZZ3ZzqVaxeL2p9diYLuiaNHhhmhT+uoG8HP5B8Q88H+mnnDlXF5pOcfZxkYzfUMh1CfBiAevcXPqzsBzNFiUYoxowrj3u+QcsBrj3OJcbHhhuuiHTxFvOeoz2+4qYFhZx8BkiWug==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Vf1muetZ2fAmDm2VuEcVYsMLtvwmn7pxUuosq04nEyc=;
 b=kZhDUZU4i4zJuewmTCbmtKSEiW2RDgMl/E6xZ4bBGWGur+9lzRti3wijU10wLy/SQ4KfR6EdrEI7nGuzDlQOURqDXJiBCW/Gdietn2UXE4eRtgfhEyuem1QdQ0UgxtNZ4o8k5jWVqEDnUp+n8ehnpEJVj5nxKKkU//nIT26U8ZM40w7YogyJF30pVGTHwCPhubX6H0OwYtiQxZ8ntrUU7gnOkrVxIwRXIwYEN19h/irPy3QZ4tJ0475KERhbOOaqHm2ZAsQQrv6a63KM1KGiVAqMpcAhkkEJTNh64aIMgKD4/Ebg7qpNDKFDbss9vz8e//nkRAKq2oLrPLT3RSovIw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=linux.intel.com smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Vf1muetZ2fAmDm2VuEcVYsMLtvwmn7pxUuosq04nEyc=;
 b=3HfPrbpxCsZl8Kyy3siZCOKmczHrNW0EIvHY3QtNFCel2KabgQ/huN3DfNFNql7oR3m+VspXZdM0R6w6Fd1WKuxEq/W651CQnVFOKl+udAc4p3qal0fPTMbH4+VeOoq5/mFCr4goTfKTYFAQvCk+vDE6KPH9NEwpjZ8aSt3PeYA=
Received: from MW4PR03CA0178.namprd03.prod.outlook.com (2603:10b6:303:8d::33)
 by DM4PR12MB6231.namprd12.prod.outlook.com (2603:10b6:8:a6::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8989.12; Fri, 1 Aug
 2025 09:33:14 +0000
Received: from CY4PEPF0000E9CD.namprd03.prod.outlook.com
 (2603:10b6:303:8d:cafe::a9) by MW4PR03CA0178.outlook.office365.com
 (2603:10b6:303:8d::33) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8964.27 via Frontend Transport; Fri,
 1 Aug 2025 09:33:13 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB03.amd.com; pr=C
Received: from SATLEXMB03.amd.com (165.204.84.17) by
 CY4PEPF0000E9CD.mail.protection.outlook.com (10.167.241.132) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.9009.8 via Frontend Transport; Fri, 1 Aug 2025 09:33:12 +0000
Received: from SATLEXMB06.amd.com (10.181.40.147) by SATLEXMB03.amd.com
 (10.181.40.144) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Fri, 1 Aug
 2025 04:33:12 -0500
Received: from SATLEXMB03.amd.com (10.181.40.144) by SATLEXMB06.amd.com
 (10.181.40.147) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Fri, 1 Aug
 2025 04:33:11 -0500
Received: from [10.252.219.240] (10.180.168.240) by SATLEXMB03.amd.com
 (10.181.40.144) with Microsoft SMTP Server id 15.1.2507.39 via Frontend
 Transport; Fri, 1 Aug 2025 04:33:08 -0500
Message-ID: <e0af8ca8-c7ad-4ef9-a8eb-554593e07139@amd.com>
Date: Fri, 1 Aug 2025 15:03:07 +0530
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
 <afafc865-b42f-4a9d-82d7-a72de16bb47b@amd.com>
 <71d741d1-9250-4a64-b695-16f8bdc338e7@linux.intel.com>
Content-Language: en-US
From: Manali Shukla <manali.shukla@amd.com>
In-Reply-To: <71d741d1-9250-4a64-b695-16f8bdc338e7@linux.intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY4PEPF0000E9CD:EE_|DM4PR12MB6231:EE_
X-MS-Office365-Filtering-Correlation-Id: db14f8fd-4dcd-4ff5-fb72-08ddd0de6fa0
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|1800799024|7416014|376014|36860700013|13003099007;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?SXZaVlZLc2JhUFpVYVJBL2c4Z0tvZktPa3I1SmFIMnBBRXpFaEJGcXAxOTg3?=
 =?utf-8?B?Y3dLSlNIZUMvcTlWTDRibDRFTmk4SFpyeTEyS0dVZE0wQ2JPS29UV09NWDNp?=
 =?utf-8?B?eEJCdFNYSmRLaHFwa0RDSjNMTVJFc0F3L1FZZEV3WURTMkd4NUprQkFGd0Nx?=
 =?utf-8?B?TnBteHB5dkVmRGlWaG9RNDVxZXFwV1lZM3FwOTZrSHNKMm9QaU1oSTZIT2Z0?=
 =?utf-8?B?TExXQTU0elkyZlFZMk5jRHhoLzg5SGhVZTRKT0pXQU56RW8wUloyZXJDY3J3?=
 =?utf-8?B?dEJ6bWxtTFJYYVlRTnhpVjdvUUZ0a1dqNEs3aFhLQzNKSzZsdGRvelc2Wk5v?=
 =?utf-8?B?c3FzTkloWGdJODJ3YTZhTEdSRmovVlhYdG1LMG9rN0N2cTRwZVIwQTluRlIz?=
 =?utf-8?B?V3VFbFNZM2IzNFlLZ2p6a3F4Z1Q5YWdUUzZNcGRScXVtK1g3MkpOT3UwWFhW?=
 =?utf-8?B?NUhWbmQ1STBzTHR3SVZOb0JOYUhBaDVEVStxWDV3SVFuMFd0T0dkVHlyT3I5?=
 =?utf-8?B?UlBIeHpIZnBIT0wzNis1UDdDQ3VOMEt3c1VHalZEeXpPV3dwYjlzVFRSTW5I?=
 =?utf-8?B?VUk4SzV5UGN3MmhtYzhmeWJtVnJNMjhoWGhpejBob29CbTMxYWxnWXh6M093?=
 =?utf-8?B?YmtMNHFvUDFKVjFJR3JraXc0M3JZMU9XSEVhdHFIc2lsVHg5UEplVStQaXZN?=
 =?utf-8?B?bUVSVDY1cXhtRmZSTzBLNlVpenVCL1BnUnJPQkYrMGtSSkJoN09HOUFjUHBH?=
 =?utf-8?B?Wk1GNXZFeXFPVnFXa0lZVTArV1RXcU53b2xkQU5ORnB6VnNadnI4ZGJndjFE?=
 =?utf-8?B?aHJVTVN3dkRwVEVVaUh1YXBWcU96QUVlb3hEZ2tuc0htcGZFZjB4azZaYVFJ?=
 =?utf-8?B?c0tkbDNiZEp5KzByYlRGSXl6VU1maTVKenQydjUvTHRCL2Z1ejg3Z3R2RC9q?=
 =?utf-8?B?U1V4UVRoN1JhK3Z1SHFXbDM0UlByUys5TG4zTndWakNzNTlodUxocUdVNkxH?=
 =?utf-8?B?WjcxZWNZTHdDSWNQRW5aQkZTWERZVmJzT3ZuVXZNdkpnZTJMWkhCUGk3S3No?=
 =?utf-8?B?NGF0SWFiaWRjOFVDcXk5UHpyMWZLUXVRMmRheXdXUnhNVVdwV1NyQVptdVJx?=
 =?utf-8?B?RFN6bHNwWnkvQldrSk5uZkhqZXBhd29FOG85RnkzSXB4Yk5RQWtBSXJHUExh?=
 =?utf-8?B?MEJST0gxMko3RGErN2c1LzZWK00rZWphQ1I3Wll0RzR4NVE5Y3IzbmRncTN6?=
 =?utf-8?B?eE9tVXpxZlN2Q2QvYWluSktjd2xsd1kyc01XQXdsQWtvUUlLN3pDUEc0ZC9C?=
 =?utf-8?B?S3A0dDlxZU16N3BUNWVDWkpoS1Q3WkFuSTZSQnFRb0RydkdZNFhHL1NWaG56?=
 =?utf-8?B?WjFydmpoNTZlUUZGSXhlSU1WanRwK3NJcEdVU2FoK2drbWFBRERTZ1hBMlBu?=
 =?utf-8?B?MGRQNnNpVk1lRlJhdmtFTG9TdGlDM3hYdWhuVWVYZnk3c0FEZ2wrZlo5Y3Rn?=
 =?utf-8?B?OVlOYmRwM2FhUVVPcytKZlFqS1NpSU55RTdMTk1MYWQrc1g5SGxRWXh4R2oz?=
 =?utf-8?B?NWw1TUxhVTQzYW5pWlQ0enk1cU91eFF5TjNHMVI1cEVIWm1DbWd3ZUorOXhu?=
 =?utf-8?B?VUoyQVRVUTRTd05hMmhNdm1XNWpndFhla1VaakVlcFhCVWcrSm9CaHpEa0Yz?=
 =?utf-8?B?WkdIaWhNMjBCaXk1MFRRZXhtc1R3a3JYdHNNRTJNbmxIU05tbFd6Y09QaEY5?=
 =?utf-8?B?VFZaUU9hUlBnbnkrd05lbmp3Z01QWEVRN0w0NWJIOW1jYTQxT2FoeEdBVkN3?=
 =?utf-8?B?YUYxOTY2bWZHelpwZlh5UjdoY21ZOUZBOUxCM2F6VzBwUnlkd2MxdDRNYTRy?=
 =?utf-8?B?K0QvWGw0V1Y0UXNvQTQySFRzMkdIZkdsSmc5MEkyZ3BNcEdMbjU1eU5hcGZT?=
 =?utf-8?B?eUVlR0tFUzVxb2RJZ0Ftdm9ZdkQxM3p1OW5HQVgvTXFWK1FKU0JhNnRtdVNh?=
 =?utf-8?B?N0N2RUpGQTZRPT0=?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB03.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(82310400026)(1800799024)(7416014)(376014)(36860700013)(13003099007);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Aug 2025 09:33:12.9743
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: db14f8fd-4dcd-4ff5-fb72-08ddd0de6fa0
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB03.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CY4PEPF0000E9CD.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB6231

On 7/17/2025 7:32 AM, Mi, Dapeng wrote:
> 
> On 7/16/2025 6:10 PM, Manali Shukla wrote:
>> Hi Dapeng Mi,
>>
>> Thanks for reviewing my patches.
>>
>> On 7/15/2025 8:28 AM, Mi, Dapeng wrote:
>>> On 6/28/2025 12:25 AM, Manali Shukla wrote:
>>>> From: Santosh Shukla <santosh.shukla@amd.com>
>>>>
>>>> The local interrupts are extended to include more LVT registers in
>>>> order to allow additional interrupt sources, like Instruction Based
>>>> Sampling (IBS) and many more.
>>>>
>>>> Currently there are four additional LVT registers defined and they are
>>>> located at APIC offsets 400h-530h.
>>>>
>>>> AMD IBS driver is designed to use EXTLVT (Extended interrupt local
>>>> vector table) by default for driver initialization.
>>>>
>>>> Extended LVT registers are required to be emulated to initialize the
>>>> guest IBS driver successfully.
>>>>
>>>> Please refer to Section 16.4.5 in AMD Programmer's Manual Volume 2 at
>>>> https://bugzilla.kernel.org/attachment.cgi?id=306250 for more details
>>>> on Extended LVT.
>>>>
>>>> Signed-off-by: Santosh Shukla <santosh.shukla@amd.com>
>>>> Co-developed-by: Manali Shukla <manali.shukla@amd.com>
>>>> Signed-off-by: Manali Shukla <manali.shukla@amd.com>
>>>> ---
>>>>  arch/x86/include/asm/apicdef.h | 17 +++++++++
>>>>  arch/x86/kvm/cpuid.c           |  6 +++
>>>>  arch/x86/kvm/lapic.c           | 69 +++++++++++++++++++++++++++++++++-
>>>>  arch/x86/kvm/lapic.h           |  1 +
>>>>  arch/x86/kvm/svm/avic.c        |  4 ++
>>>>  arch/x86/kvm/svm/svm.c         |  4 ++
>>>>  6 files changed, 99 insertions(+), 2 deletions(-)
>>>>
>>>> diff --git a/arch/x86/include/asm/apicdef.h b/arch/x86/include/asm/apicdef.h
>>>> index 094106b6a538..4c0f580578aa 100644
>>>> --- a/arch/x86/include/asm/apicdef.h
>>>> +++ b/arch/x86/include/asm/apicdef.h
>>>> @@ -146,6 +146,23 @@
>>>>  #define		APIC_EILVT_MSG_EXT	0x7
>>>>  #define		APIC_EILVT_MASKED	(1 << 16)
>>>>  
>>>> +/*
>>>> + * Initialize extended APIC registers to the default value when guest
>>>> + * is started and EXTAPIC feature is enabled on the guest.
>>>> + *
>>>> + * APIC_EFEAT is a read only Extended APIC feature register, whose
>>>> + * default value is 0x00040007. However, bits 0, 1, and 2 represent
>>>> + * features that are not currently emulated by KVM. Therefore, these
>>>> + * bits must be cleared during initialization. As a result, the
>>>> + * default value used for APIC_EFEAT in KVM is 0x00040000.
>>>> + *
>>>> + * APIC_ECTRL is a read-write Extended APIC control register, whose
>>>> + * default value is 0x0.
>>>> + */
>>>> +
>>>> +#define		APIC_EFEAT_DEFAULT	0x00040000
>>>> +#define		APIC_ECTRL_DEFAULT	0x0
>>>> +
>>>>  #define APIC_BASE (fix_to_virt(FIX_APIC_BASE))
>>>>  #define APIC_BASE_MSR		0x800
>>>>  #define APIC_X2APIC_ID_MSR	0x802
>>>> diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
>>>> index eb7be340138b..7270d22fbf31 100644
>>>> --- a/arch/x86/kvm/cpuid.c
>>>> +++ b/arch/x86/kvm/cpuid.c
>>>> @@ -458,6 +458,12 @@ void kvm_vcpu_after_set_cpuid(struct kvm_vcpu *vcpu)
>>>>  	/* Invoke the vendor callback only after the above state is updated. */
>>>>  	kvm_x86_call(vcpu_after_set_cpuid)(vcpu);
>>>>  
>>>> +	/*
>>>> +	 * Initialize extended LVT registers at guest startup to support delivery
>>>> +	 * of interrupts via the extended APIC space (offsets 0x400–0x530).
>>>> +	 */
>>>> +	kvm_apic_init_eilvt_regs(vcpu);
>>>> +
>>>>  	/*
>>>>  	 * Except for the MMU, which needs to do its thing any vendor specific
>>>>  	 * adjustments to the reserved GPA bits.
>>>> diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
>>>> index 00ca2b0faa45..cffe44eb3f2b 100644
>>>> --- a/arch/x86/kvm/lapic.c
>>>> +++ b/arch/x86/kvm/lapic.c
>>>> @@ -1624,9 +1624,13 @@ static inline struct kvm_lapic *to_lapic(struct kvm_io_device *dev)
>>>>  }
>>>>  
>>>>  #define APIC_REG_MASK(reg)	(1ull << ((reg) >> 4))
>>>> +#define APIC_REG_EXT_MASK(reg)	(1ull << (((reg) >> 4) - 0x40))
>>> It seems there is no difference on the MASK definition between
>>> APIC_REG_MASK() and APIC_REG_EXT_MASK(). Why not directly use the original
>>> APIC_REG_MASK()?
>>>
>> The Extended LVT registers range from 0x400 to 0x530. When using
>> APIC_REG_MASK(reg) with reg = 0x400 (as an example), the operation
>> results in a right shift of 64(0x40) bits, causing an overflow. This was
>> the actual reason of creating a new macro for extended APIC register space.
> 
> I see. Just ignored that the bit could extend 64 bits.
> 
> 
>>
>>> BTW, If we indeed need to define this new macro, could we define the macro
>>> like blow?
>>>
>>> #define APIC_REG_EXT_MASK(reg)	(1ull << (((reg) - 0x400) >> 4))
>>>
>>> It's more easily to understand. 
>>>
>> I can define the macro in this way.
>>
>>>>  #define APIC_REGS_MASK(first, count) \
>>>>  	(APIC_REG_MASK(first) * ((1ull << (count)) - 1))
>>>>  
>>>> +#define APIC_LAST_REG_OFFSET		0x3f0
>>>> +#define APIC_EXT_LAST_REG_OFFSET	0x530
>>>> +
>>>>  u64 kvm_lapic_readable_reg_mask(struct kvm_lapic *apic)
>>>>  {
>>>>  	/* Leave bits '0' for reserved and write-only registers. */
>>>> @@ -1668,6 +1672,8 @@ EXPORT_SYMBOL_GPL(kvm_lapic_readable_reg_mask);
>>>>  static int kvm_lapic_reg_read(struct kvm_lapic *apic, u32 offset, int len,
>>>>  			      void *data)
>>>>  {
>>>> +	u64 valid_reg_ext_mask = 0;
>>>> +	unsigned int last_reg = APIC_LAST_REG_OFFSET;
>>>>  	unsigned char alignment = offset & 0xf;
>>>>  	u32 result;
>>>>  
>>>> @@ -1677,13 +1683,44 @@ static int kvm_lapic_reg_read(struct kvm_lapic *apic, u32 offset, int len,
>>>>  	 */
>>>>  	WARN_ON_ONCE(apic_x2apic_mode(apic) && offset == APIC_ICR);
>>>>  
>>>> +	/*
>>>> +	 * The local interrupts are extended to include LVT registers to allow
>>>> +	 * additional interrupt sources when the EXTAPIC feature bit is enabled.
>>>> +	 * The Extended Interrupt LVT registers are located at APIC offsets 400-530h.
>>>> +	 */
>>>> +	if (guest_cpu_cap_has(apic->vcpu, X86_FEATURE_EXTAPIC)) {
>>>> +		valid_reg_ext_mask =
>>>> +			APIC_REG_EXT_MASK(APIC_EFEAT) |
>>>> +			APIC_REG_EXT_MASK(APIC_ECTRL) |
>>>> +			APIC_REG_EXT_MASK(APIC_EILVTn(0)) |
>>>> +			APIC_REG_EXT_MASK(APIC_EILVTn(1)) |
>>>> +			APIC_REG_EXT_MASK(APIC_EILVTn(2)) |
>>>> +			APIC_REG_EXT_MASK(APIC_EILVTn(3));
>>>> +		last_reg = APIC_EXT_LAST_REG_OFFSET;
>>>> +	}
>>> Why not move this code piece into kvm_lapic_readable_reg_mask() and
>>> directly use APIC_REG_MASK() for these extended regs? Then we don't need to
>>> modify the below code. 
> 
> I still think we should get a unified APIC reg mask even for the extended
> APIC with kvm_lapic_readable_reg_mask() helper. We can extend current
> kvm_lapic_readable_reg_mask() and let it return a 128 bits bitmap, maybe
> like this,
> 
> void kvm_lapic_readable_reg_mask(struct kvm_lapic *apic, u64 *mask)
> 
> This makes code more easily maintain. 
> 
> 

Sorry for the delay.

The reason why I am wary of this approach is because
kvm_lapic_readable_reg_mask() is currently being used in
vmx_update_msr_bitmap_x2apic(), where we directly use its return value:

    if (mode & MSR_BITMAP_MODE_X2APIC_APICV)
        msr_bitmap[read_idx] =
~kvm_lapic_readable_reg_mask(vcpu->arch.apic);
    else
        msr_bitmap[read_idx] = ~0ull;
    msr_bitmap[write_idx] = ~0ull;

Where msr_bitmap is a u64 array.

Changing kvm_lapic_readable_reg_mask() to return a 128-bit mask would
require changes in vmx_update_msr_bitmap_x2apic() too.

- Manali

>>>
>>


