Return-Path: <kvm+bounces-54991-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 4E604B2C71E
	for <lists+kvm@lfdr.de>; Tue, 19 Aug 2025 16:34:24 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 36FD75A4F5D
	for <lists+kvm@lfdr.de>; Tue, 19 Aug 2025 14:29:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 100ED274B5A;
	Tue, 19 Aug 2025 14:29:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="BN9OchKe"
X-Original-To: kvm@vger.kernel.org
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2088.outbound.protection.outlook.com [40.107.223.88])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8336B26F285;
	Tue, 19 Aug 2025 14:29:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.223.88
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755613751; cv=fail; b=q3s3qMgr1zGrHRQQLUPk8aya2Kwwnm5ule88aQEoDAHbxa8Eb30E7mVGotdo7/mE5TRACfgSlcVrzyVluttkNIp7pn/pZ3C2/dme47z+L18CEaSEBrzFipW/NwitDcSmX3/A7X2ivfy+6hxep56Kc5H/PGqqvl5rRDiK1Mx3VOk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755613751; c=relaxed/simple;
	bh=MprpQXXYGhrJng3og+ZG4MCytT2+esBmbfzpYFE0rWs=;
	h=Message-ID:Date:MIME-Version:Subject:To:CC:References:From:
	 In-Reply-To:Content-Type; b=AecoxTEvv0TsPpT8CoF3PwQYLn3rg/wT6QJ9sFW+sXH8Y6WAkRBqdoa9IEd8DaqDLUjaNtyU/p0GcQmwyoAGfU201VaekueDZTSyY9m+PTfojK6k1Bdp/dcd6qJf5oQHvIVMdF/4zmwxNngH8mKyleJe5diiucefgleLQUZJk0s=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=BN9OchKe; arc=fail smtp.client-ip=40.107.223.88
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=XS5Pc+Geewl9gQvLbKOU7mAWoQQGA1qLIqvDk6JyNGmb0t83sWcS7NqV+cZySEXdyqNC8kCOiMMNsNxU6he25xlnRs4RZKi8I+oIKeZ1pH+C6Ok7q2h9DbWtqCvR103uLa7ZAvptHtwVQ7gX9ITCA2nHpH1KrR/72wsfw5s1Q+6GM4i1EImThc63x9hefZgYUe+HkH8/NgoYrPqlBSQXNdxn5Tf3xoLc9xcxv1BaZadiNZbtAHcYm/jjFEZGe9ZO14OoU/zjGoHyNUYlnQW4KkL/Cef2tDXG7yx4BMZZgOAYRWEOUsNMUW+/eH6VEzg7+1hmFJnH6xrPxbddpaxGzQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Ng5t+S/pXCOBnaFvOWUSNAWVlrZ/+dsCz1IhUcGElqI=;
 b=ffzt7bUIrRaEaj+k8r76t3XKCKC+tSoqhplyrRkJB2/nLNPQuC0MrEKpk9OHiTa21mr/b+7hSfTP+krgkaWwdID1X6tv24LNIVlYeWRNJRRFgzSC4gak5lcq+QakDceYhCeVxri2vvyV/+LZyUANEBgUNhz4Aliu3I/yX2kiStiaan8c6zhqEDatwYyZ+AGUk1VFwvD6d1rnuswZuU15P+GyFe3le6so++/yEQWY0cWhLqKsd1tMg0w7Uhakp6/mGgsUAa3iMQmSA4GSQR+BpPAZCWaEB6C8hWFVH4Jhv9gsag0PMpkvXW3faA/NvocMTgS7d9sisT7HTpe4p7JKLg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=alien8.de smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Ng5t+S/pXCOBnaFvOWUSNAWVlrZ/+dsCz1IhUcGElqI=;
 b=BN9OchKe+ApoA+rvd/6u/z8p+nZ5BoMeDGrTfXkUhyWwuJtY9XIt9ivB6lLYIGKVeZYfUcZ5CiRzh5HE3f+wZhHDxYtWFzl3bwNEWVUaZViFiz/N69rMAAugppSunYUtvM3szBOkMYV/55nLZujEsoH4SkvfovK6B5yzpYV4nlg=
Received: from SJ0PR03CA0142.namprd03.prod.outlook.com (2603:10b6:a03:33c::27)
 by DM4PR12MB6136.namprd12.prod.outlook.com (2603:10b6:8:a9::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9031.24; Tue, 19 Aug
 2025 14:29:01 +0000
Received: from CO1PEPF000075ED.namprd03.prod.outlook.com
 (2603:10b6:a03:33c:cafe::b9) by SJ0PR03CA0142.outlook.office365.com
 (2603:10b6:a03:33c::27) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9031.20 via Frontend Transport; Tue,
 19 Aug 2025 14:29:01 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 CO1PEPF000075ED.mail.protection.outlook.com (10.167.249.36) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.9052.8 via Frontend Transport; Tue, 19 Aug 2025 14:29:01 +0000
Received: from SATLEXMB05.amd.com (10.181.40.146) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Tue, 19 Aug
 2025 09:28:59 -0500
Received: from SATLEXMB03.amd.com (10.181.40.144) by SATLEXMB05.amd.com
 (10.181.40.146) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Tue, 19 Aug
 2025 09:28:59 -0500
Received: from [172.31.184.125] (10.180.168.240) by SATLEXMB03.amd.com
 (10.181.40.144) with Microsoft SMTP Server id 15.1.2507.39 via Frontend
 Transport; Tue, 19 Aug 2025 09:28:53 -0500
Message-ID: <e3a8e247-0ced-4354-b7cf-25ee7beb9987@amd.com>
Date: Tue, 19 Aug 2025 19:58:52 +0530
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 0/4] x86/cpu/topology: Work around the nuances of
 virtualization on AMD/Hygon
To: Borislav Petkov <bp@alien8.de>
CC: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, Dave
 Hansen <dave.hansen@linux.intel.com>, Sean Christopherson
	<seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>, <x86@kernel.org>,
	Naveen rao <naveen.rao@amd.com>, Sairaj Kodilkar <sarunkod@amd.com>, "H.
 Peter Anvin" <hpa@zytor.com>, "Peter Zijlstra (Intel)"
	<peterz@infradead.org>, "Xin Li (Intel)" <xin@zytor.com>, Pawan Gupta
	<pawan.kumar.gupta@linux.intel.com>, <linux-kernel@vger.kernel.org>,
	<kvm@vger.kernel.org>, Mario Limonciello <mario.limonciello@amd.com>,
	"Gautham R. Shenoy" <gautham.shenoy@amd.com>, Babu Moger
	<babu.moger@amd.com>, Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
References: <20250818060435.2452-1-kprateek.nayak@amd.com>
 <20250819113447.GJaKRhVx6lBPUc6NMz@fat_crate.local>
Content-Language: en-US
From: K Prateek Nayak <kprateek.nayak@amd.com>
In-Reply-To: <20250819113447.GJaKRhVx6lBPUc6NMz@fat_crate.local>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Received-SPF: None (SATLEXMB05.amd.com: kprateek.nayak@amd.com does not
 designate permitted sender hosts)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO1PEPF000075ED:EE_|DM4PR12MB6136:EE_
X-MS-Office365-Filtering-Correlation-Id: b0086019-1236-4b3a-5ba7-08dddf2cbdbd
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|82310400026|36860700013|7416014|376014;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?aGZDZm55STZaU3dYQkxqMDBFU3JySmdzazU5WG4ybEZXamRDUlRMZGswa2NG?=
 =?utf-8?B?RlBXbHpsMkxhZXh3Ti95VkI3WW1HMmQvclh1REtEeGdoMFN1Q0NyT2FPelFO?=
 =?utf-8?B?SEU0bWR1dzgySGJmU1NrQWh3T0ovK0Z0U3R6cG9OZ0lyeGhqMzk2anlGcmdk?=
 =?utf-8?B?d1hZUFQ5MWh0WlRCUURtY1JJS21NenFjejRSY1NnU0Z2OXRSUWI5Z051a1Np?=
 =?utf-8?B?dmI0b0Y3N1h0ejI4MWlTODk0REgyUVdIT1BlYmNGL0NRT3hNTmlGU2gwTTR4?=
 =?utf-8?B?VzYzYWhxMld6LzFWZlFFc2U0ZHB4cS9udnlINkhUSWVNUFdqTThnRG9rYUh3?=
 =?utf-8?B?ZVc4bStEL0ZRY0Z6ZGlWdHo3TUk2UmdvazhBRVZMbWhhaVJUTFByaDNFZnBE?=
 =?utf-8?B?eHNGdFNyZWNGNDNlbGgxL3VUOVd0UEZsZWgzeHF3bFRCMldkOEJWWUo5eVBU?=
 =?utf-8?B?ekI3azF3RWpwOEpTbTNDQndtSTU2OE56eS9uUWdFM3RvOEcyOVBYVWZ5d1ll?=
 =?utf-8?B?eUZodTdGeTFEaVZObWE2YzNOMFkrTm9DeHZTM2tqekhyaXdqOVZONi9Fc3Bv?=
 =?utf-8?B?cjlweXhxVVdFTTAvRDkrRkNNaXo4K3pLc2VPQkd6K2xxRmdGMGwySDlnTnRT?=
 =?utf-8?B?MXdlWm5QQmVpZGxGeEFiVjlockQwbVBvSmZVRVFpYm54S3o3SGpHdzMzVUpF?=
 =?utf-8?B?aGVvK1hFOFBNeDFEaFhwc3lYRm5OeE9NQi9QOWtITVl0MWYzb2FCbkNEazFp?=
 =?utf-8?B?VytCSTg1WElQSStCVUVSS0w1RmRYdE56M09kSXFiNUg0b3JlVnNRa2NaWU4x?=
 =?utf-8?B?aXIrbDVQY3djQzJrbEpsV2tacnVZNFh0ejdQL010YjY3Y21YYlNMYUgxTE5H?=
 =?utf-8?B?WVMwMGVTaTdBOGQzdi9wTytXb2hRT3psRE5PcmhOM2NRc3M3dVBod0RWUUhK?=
 =?utf-8?B?Y0l2elFKSmM1Tk9uME9HNy9BVHZ2Q3hEUnhDZ0dWZlJjcCs4RXdSQUxWbGNp?=
 =?utf-8?B?bmQ1N2drV3k2QUtaVGVRazZHcmRMYmxOek03NGM3ZkdPaC82YldYRGwzVGZP?=
 =?utf-8?B?eCtIeVNkbTE1WWFTQUpEdHR2QW1QNUpDRW5NRXVkdE9ObjNhSjJ2M1dFVENi?=
 =?utf-8?B?ZWxjb3NOVnhibUd3RVA0ZjcwTlJkYzJKaHJxTkdIMlUzRVU1dXVabUpmUjZh?=
 =?utf-8?B?T3crQVdOd0lETnZUbktqdlJyRUE5SzQ4R05SbGtaMDYvMUhlbXpNYWQ3bVNk?=
 =?utf-8?B?UFF3VXNxa2IxaVRHWEFSUkkxVGVFR29HcnZNUlUwN05RV0JpcnZGQ2V2Rnh2?=
 =?utf-8?B?NHU3N1FpUE9FY01aVEc2TG05UGFqUjN0elE2MTFGVnp0MFlPOFVmN2xkSmpw?=
 =?utf-8?B?ZzdZUmMwWWI3SjI5U0xJY3ZyY2ZoZS83RG9MaGxOb0RBZHVWQytPS0QxaHdN?=
 =?utf-8?B?YUZ5NWxSVzFCaVhQTFJVSnExREdpK0ZVZEppK1dmZHloWnVTbm5JMTZqbzFt?=
 =?utf-8?B?RnF4ZnZIQUtGUGw4WVpURFNqbGYvUDVQMjhJOUJjUHVaSnVLOXh1SFlTK3JC?=
 =?utf-8?B?MCtGbVFmT2NqYy8zakdSWnJuVEdKRWg4cGk5c1JBTTlTL2hRNzNhVnlLZUwr?=
 =?utf-8?B?TzFzVjFNTFhHUjdLUXY2UTdvYjhRUTNqMitvbTVOaWxoNU9icjRxY253VXhZ?=
 =?utf-8?B?SkVKV3BuNXBYbHpBZEpLSTJEWTc2RUN0dU45Q0NMb0NjMGJ2dTRjUkF2UU9L?=
 =?utf-8?B?UGZ4aEN0MjAwV2pPQTBYTmlnWUFuYzhlSDBJbUJvQmVTVGtLMFJzMzBwQThT?=
 =?utf-8?B?Vm5IdVJvZk82eFZJY2d1WTYrS01nTEZGWmFwRGZwakJ1akdVWDl6dDVseDlv?=
 =?utf-8?B?cVRqYk9CeUR2ek8zblpNalRoeHF5bHVoTzVRS2UzbzI2OTk5cCt4Y1g1UFNV?=
 =?utf-8?B?Q2txM20wRFFOeTBnUDJ4VU02RWcwaDBZZ0ZjQmdHN2JYd1pXdm44bzNscDM5?=
 =?utf-8?B?UnN2VHBkSnlnPT0=?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(1800799024)(82310400026)(36860700013)(7416014)(376014);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Aug 2025 14:29:01.0000
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: b0086019-1236-4b3a-5ba7-08dddf2cbdbd
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CO1PEPF000075ED.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB6136

Hello Boris,

On 8/19/2025 5:04 PM, Borislav Petkov wrote:
> Lemme try to make some sense of this because the wild use of names and things
> is making my head spin...
> 
> On Mon, Aug 18, 2025 at 06:04:31AM +0000, K Prateek Nayak wrote:
>> When running an AMD guest on QEMU with > 255 cores, the following FW_BUG
>> was noticed with recent kernels:
>>
>>     [Firmware Bug]: CPU 512: APIC ID mismatch. CPUID: 0x0000 APIC: 0x0200
>>
>> Naveen, Sairaj debugged the cause to commit c749ce393b8f ("x86/cpu: Use
>> common topology code for AMD") where, after the rework, the initial
>> APICID was set using the CPUID leaf 0x8000001e EAX[31:0] as opposed to
> 
> That's
> 
> CPUID_Fn8000001E_ECX [Node Identifiers] (Core::X86::Cpuid::NodeId)

Small correction here, this is actually,

CPUID_Fn8000001E_EAX [Extended APIC ID] (Core::X86::Cpuid::ExtApicId)

> 
>> the value from CPUID leaf 0xb EDX[31:0] previously.
> 
> That's
> 
> CPUID_Fn0000000B_EDX [Extended Topology Enumeration]
> (Core::X86::Cpuid::ExtTopEnumEdx)
> 
>> This led us down a rabbit hole of XTOPOEXT vs TOPOEXT support, preferred
> 
> What is XTOPOEXT? 
> 
> CPUID_Fn0000000B_EDX?
> 
> Please define all your things properly so that we can have common base when
> reading this text.

Sorry about that! This should actually be "X86_FEATURE_XTOPOLOGY" which
is a synthetic feature set when topology parsing via one of the following
CPUID leaf is successful:

- 0x1f
  V2 Extended Topology Enumeration Leaf
  (Intel only)

- 0x80000026
  CPUID_Fn80000026_E[A,B,C]X_x0[0...3] [Extended CPU Topology]
  Core::X86::Cpuid::ExCpuTopologyE[a,b,c]x[0..3]
  (AMD only)

- 0xb
  CPUID_Fn0000000B_E[A,B,C]X_x0[0..2] [Extended Topology Enumeration]
  Core::X86::Cpuid::ExtTopEnumE[a,b,c]x[0..2]
  (Both Intel and AMD)

The parsing of the leaves is tried in the same order as above.

> 
> TOPOEXT is, I presume:
> 
> #define X86_FEATURE_TOPOEXT		( 6*32+22) /* "topoext" Topology extensions CPUID leafs */
> 
> Our PPR says:
> 
> CPUID_Fn80000001_ECX [Feature Identifiers] (Core::X86::Cpuid::FeatureExtIdEcx)
> 
> "22 TopologyExtensions: topology extensions support. Read-only. Reset:
> Fixed,1. 1=Indicates support for Core::X86::Cpuid::CachePropEax0 and
> Core::X86::Cpuid::ExtApicId."
> 
> Those leafs are:
> 
> CPUID_Fn8000001D_EAX_x00 [Cache Properties (DC)] (Core::X86::Cpuid::CachePropEax0)
> 
> DC topology info. Probably not important for this here.
> 
> and
> 
> CPUID_Fn8000001E_EAX [Extended APIC ID] (Core::X86::Cpuid::ExtApicId)
> 
> the extended APIC ID is there.
> 
> How is this APIC ID different from the extended APIC ID in
> 
> CPUID_Fn0000000B_EDX [Extended Topology Enumeration] (Core::X86::Cpuid::ExtTopEnumEdx)
> 
> ?

On baremetal, they are the same. On QEMU, when we launch a guest with
a topology that contains more than 256 cores on a single socket, QEMU
0s out all the bits in CPUID_Fn8000001E [1] since it fears a collision
in the "CoreId[7:0]" field of
"CPUID_Fn8000001E_EBX [Core Identifiers] (Core::X86::Cpuid::CoreId)"

Since
"CPUID_Fn0000000B_EBX_x01 [Extended Topology Enumeration]" and 
"LogProcAtThisLevel[15:0]" can describe a domain with up to 2^16 cores,
the Core ID can always be derived correctly from this even when the
number of cores in the guest topology crosses 256.

> 
>> order of their parsing, and QEMU nuances like [1] where QEMU 0's out the
>> CPUID leaf 0x8000001e on CPUs where Core ID crosses 255 fearing a
>> Core ID collision in the 8 bit field which leads to the reported FW_BUG.
> 
> Is that what the hw does though?

We don't have baremetal systems with more than 256 cores per socket and
when that happens, I believe the expectation from H/W is to just use
CPUID_Fn80000026 leaf or the CPUID_Fn0000000B leaf.

> 
> Has this been verified instead of willy nilly clearing CPUID leafs in qemu?
> 
>> Following were major observations during the debug which the two
>> patches address respectively:
>>
>> 1. The support for CPUID leaf 0xb is independent of the TOPOEXT feature
> 
> Yes, PPR says so.
> 
>>    and is rather linked to the x2APIC enablement.
> 
> Because the SDM says:
> 
> "Bits 31-00: x2APIC ID of the current logical processor."
> 
> ?

SDM Vol. 3A Sec. 11.12.8 "CPUID Extensions And Topology Enumeration"
reads:

  For Intel 64 and IA-32 processors that support x2APIC, a value of 1
  reported by CPUID.01H:ECX[21] indicates that the processor supports
  x2APIC and the extended topology enumeration leaf (CPUID.0BH).

  The extended topology enumeration leaf can be accessed by executing
  CPUID with EAX = 0BH. Processors that do not support x2APIC may
  support CPUID leaf 0BH. Software can detect the availability of the
  extended topology enumeration leaf (0BH) by performing two steps:

  1. Check maximum input value for basic CPUID information by executing
     CPUID with EAX= 0. If CPUID.0H:EAX is greater than or equal or 11
     (0BH), then proceed to next step

  2. Check CPUID.EAX=0BH, ECX=0H:EBX is non-zero.

  If both of the above conditions are true, extended topology
  enumeration leaf is available.

> 
> Is our version not containing the x2APIC ID?

We too have the Extended APIC ID in both CPUID_Fn0000000B and
CPUID_Fn8000001E_EAX and they both match on baremetal. The problem is
only for virtualized guest whose topology contains more than 256
cores per socket because of [1]

> 
>> On baremetal, this has
>>    not been a problem since TOPOEXT support (Fam 0x15 and above)
>>    predates the support for CPUID leaf 0xb (Fam 0x17[Zen2] and above)
>>    however, in virtualized environment, the support for x2APIC can be
>>    enabled independent of topoext where QEMU expects the guest to parse
>>    the topology and the APICID from CPUID leaf 0xb.
> 
> So we're fixing a qemu bug?
> 
> Why isn't qemu force-enabling TOPOEXT support when one requests x2APIC?
> 
> My initial reaction: fix qemu.

This is possible, however what should be the right thing for
CPUID_Fn8000001E_EBX [Core Identifiers] (Core::X86::Cpuid::CoreId)?

Should QEMU just wrap and start counting the Core Identifiers again
from 0?

Or Should QEMU go ahead and populate just the
CPUID_Fn8000001E_EAX [Extended APIC ID] (Core::X86::Cpuid::ExtApicId)
fields and continue to zero out EBX and ECX when CoreID > 255?

[1] https://github.com/qemu/qemu/commit/35ac5dfbcaa4b

-- 
Thanks and Regards,
Prateek


