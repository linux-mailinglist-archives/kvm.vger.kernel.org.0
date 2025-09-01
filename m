Return-Path: <kvm+bounces-56399-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 3678AB3D829
	for <lists+kvm@lfdr.de>; Mon,  1 Sep 2025 06:22:16 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id DE15E3B815F
	for <lists+kvm@lfdr.de>; Mon,  1 Sep 2025 04:22:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3E9C7226863;
	Mon,  1 Sep 2025 04:22:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="zZ+CNOV/"
X-Original-To: kvm@vger.kernel.org
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2066.outbound.protection.outlook.com [40.107.94.66])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5C46611CBA;
	Mon,  1 Sep 2025 04:22:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.94.66
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756700524; cv=fail; b=kCUQns1z9d+FTbRq163KlGi0KwFIvMMfC8tXnlQ8/ddHv11PfQzTkTW1kBCYC1rVG9LhBmXaJFDoeXsWPEEL4l0vmqtILMb77t4pSYOIUJAS8iFQcCRLGED57KhZQ1KQHjyF0K5CPrz/KcjSvo9vJHTmvQXwvnTjUs0kd7VMIKU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756700524; c=relaxed/simple;
	bh=CPrOrInkVdJuIVP4ZDjSr8vlR1EFLNTUNDGu/r+INR4=;
	h=Message-ID:Date:MIME-Version:Subject:To:CC:References:From:
	 In-Reply-To:Content-Type; b=P1jwHjVknMCIxgKHdiuAhWFQYh1NGDiCA6hWYh2HIZ7Z+2VhiJ12HKo3L2FsUK/D1krunEYkOx05iMQ7hYIb59KRRYAE+ZI2evbA7rHopetwF7unP9yjtbky7IFd06ehPiu7RalX4emOhryLW2IFO45C6mNd31GuS5gE3arEi8E=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=zZ+CNOV/; arc=fail smtp.client-ip=40.107.94.66
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=vUiGkvYhBdPa7YDw3L8Cpbq0QKTmnl9ltg5hFOrj8o+Ldlm3WeG90s7PBu7I563cYE5ar8RtwwLtsZnfF/fZNtK4Akf7lXvgqqZ2er3iPnv1YPipz/jHbNLGKMqwb/rQOruDmL84Z7XI9hN+vrISlAFnht0Dk9MMo+V3i/UJIfF7Ha7bz0E3KE17dmfiCmdSxgOwhY26HTsmEjpQwQA42QYk+LZb4Uio857fj85DmzhoboQRI78YXGjbwhQFx57z3v1VPrCkj4fZy0qopK2JvMQp4hMZHKQAMrWGYF/6OtgOMbsm1iXYmjZ9XRRw8t3i+e5eIH0xfIXs1sgs5CAEPA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=LXX2uiu1IcgjL4aTHJ9C0tgMpNUm7cDYW9a2P6Ki+Pw=;
 b=QWHthLutsMNbi+D2pTNpcTZEISQJxBp2g8UKSVNawFE6YrR1Vp9LgVtcoigGtjE8OxtandCjVhrvP6ixNZFOJ15Du37KEU5jdsGs8vvO+aswk5MAuYj9RlTrPjQDyCiASAOlBdE8LMV5q+V4p31Gpiq2Eili4E3npQmWzkq4MbJUIW4jUcOHGSAf962ySmSJlsuPwQQFwCNosBgBTaymUBRpRNJ6RHdxw70Z6BEjhbYu0ctwWqTb9ochZ0Hc21maPP1BWbkwxIH5yiiSaEZc3MV0nG/E+MIwUhz4czUlNQTS3BYkX23OKShrN87Qy8pfUSsVbxpoC3Oq48nmKj/aew==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=alien8.de smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=LXX2uiu1IcgjL4aTHJ9C0tgMpNUm7cDYW9a2P6Ki+Pw=;
 b=zZ+CNOV/YTu5x2w7UxNwez9N+0Zge1+jDNhwfMHr5rMp7kQvgAu/ucJs6ZYYUEd7O/cmfWUENeSqlkJSM5wfhxqOwLNhlCyedfO8VOstQc9PbrnLk1EhCZpGnF8GYMHQS5sf20YQwBeG0RleEUpNFyBxyNMjVRhctrruAWuBor8=
Received: from CH0PR03CA0263.namprd03.prod.outlook.com (2603:10b6:610:e5::28)
 by BY5PR12MB4164.namprd12.prod.outlook.com (2603:10b6:a03:207::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9052.19; Mon, 1 Sep
 2025 04:22:00 +0000
Received: from CH1PEPF0000AD77.namprd04.prod.outlook.com
 (2603:10b6:610:e5:cafe::1d) by CH0PR03CA0263.outlook.office365.com
 (2603:10b6:610:e5::28) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9073.26 via Frontend Transport; Mon,
 1 Sep 2025 04:22:00 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB03.amd.com; pr=C
Received: from SATLEXMB03.amd.com (165.204.84.17) by
 CH1PEPF0000AD77.mail.protection.outlook.com (10.167.244.55) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.9073.11 via Frontend Transport; Mon, 1 Sep 2025 04:21:59 +0000
Received: from satlexmb08.amd.com (10.181.42.217) by SATLEXMB03.amd.com
 (10.181.40.144) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Sun, 31 Aug
 2025 23:21:59 -0500
Received: from SATLEXMB04.amd.com (10.181.40.145) by satlexmb08.amd.com
 (10.181.42.217) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.2.1748.10; Sun, 31 Aug
 2025 21:21:59 -0700
Received: from [10.136.36.137] (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server id 15.1.2507.39 via Frontend
 Transport; Sun, 31 Aug 2025 23:21:54 -0500
Message-ID: <939c23b3-2a43-4083-985c-ab0b16a3c452@amd.com>
Date: Mon, 1 Sep 2025 09:51:53 +0530
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 2/4] x86/cpu/topology: Always try
 cpu_parse_topology_ext() on AMD/Hygon
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
	<suravee.suthikulpanit@amd.com>, Naveen N Rao <naveen@kernel.org>,
	<stable@vger.kernel.org>
References: <20250825075732.10694-1-kprateek.nayak@amd.com>
 <20250825075732.10694-3-kprateek.nayak@amd.com>
 <20250830171921.GAaLMymVpsFhjWtylo@fat_crate.local>
Content-Language: en-US
From: K Prateek Nayak <kprateek.nayak@amd.com>
In-Reply-To: <20250830171921.GAaLMymVpsFhjWtylo@fat_crate.local>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH1PEPF0000AD77:EE_|BY5PR12MB4164:EE_
X-MS-Office365-Filtering-Correlation-Id: 4e228e43-e969-4d10-46ed-08dde90f186a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|36860700013|1800799024|376014|7416014;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?dllYU3FnY2VmVHhtL2JyUWZQSmVpb051TWI5Vk1PQi9rYlhKbFlkWkJPbTJq?=
 =?utf-8?B?SXl0Y0x1N0VzZkhRbnlHcnJqanpvVWhZK0pQVUQwbUNBOWZmUGFjeThGYVZJ?=
 =?utf-8?B?em9WMTEvaHM0NURJaWtPdFkzRkk0ZnhhTEtYbFpQdVpJK2VzY2JhVlE3S3F0?=
 =?utf-8?B?WWxlUTJCMGwrMEhpSEZEMDVwM2JydFRWZWhBdzFVRzZQV2JCUmRYTGdEcTM2?=
 =?utf-8?B?dWFEUFJVMmdyN2ZWQUFCdDNtVGxSL1E5R3BXc0dPN1ArYlVMaytuZEdMdzBI?=
 =?utf-8?B?U0ZBTFoyc3RvQlZGL2Urd0paejNhc1VBYUl1c1NBZmFKWFBCd0wwUjhNcU1N?=
 =?utf-8?B?dEtYWlM0Z1JDMzNQU2p6N1VGR2pnMDNKd3dtVDllNlFMeWhqQ0FOZGorQ1k2?=
 =?utf-8?B?cWdBRlQ5S1NRS0dQVkpoa2swL0lRM1lPYlJ0K2VmbUcvL1IxTldMYnkyYVZy?=
 =?utf-8?B?cFVGWUpnS200NWNIdVQ2eWU1Vit6VnQzdGRMODYxNzlBbjNaMG95Nm16clBJ?=
 =?utf-8?B?V0hENDBxZTRlSTlGYkF0alZ2b05mcUNkNUVTU1AwdGJxaTlNRG1pdzNaU05I?=
 =?utf-8?B?SHdpcW5Ta3kwSWVUNFZSdGtyTnJ3UjhUdmlyVmh2bjJPVndpb1BMV2lnQ1BU?=
 =?utf-8?B?QXM1WFd4dGV2ZW5KS2Q3cUU2TFJHM256aENnRklKUEVUNURlL2RIUmhaaGVj?=
 =?utf-8?B?Z1JzSW9LcHlDVDEwVSt4ZDVLMzJ2dndjeUwzbisyT0JvdGR6a0RGalFpbzhl?=
 =?utf-8?B?b2Naa01sNTVwSG1JQ2dvUEhuV3BoZGlKYWxaRFdzKzNWTC9Nd1ZEcUN0QmFk?=
 =?utf-8?B?S3hqdit0WmQvc2dmK2k2elJYc2xSMU4vemd2T1FBb0R6WVZzU2F2RDdMRWtt?=
 =?utf-8?B?V0lOb2lSRk01NXdKdFZmYnd0eWtJajQ2elcwM24rVndEMzRhbUcrQWNKQmZh?=
 =?utf-8?B?ZmlRQnlBSzE5Q0JlZFdtdk5Bem04REVCY0dPUVVjdUNxL2NLbFFzdnRGa3cx?=
 =?utf-8?B?REUxdU9Vemp3Wjl2alJpb1JNencrOGNVeitYNHJwUG9OTW40cXJEcndlU0h3?=
 =?utf-8?B?M2hnY1RJTWIvR0RsbjRqVTFSb2U2Mnpqbm1QSXlwazUzcEk4WFU4WGhsV2lm?=
 =?utf-8?B?UWJ5K3d3MWgxdTFibm83a0R5OHhOZHpCbjVaUk5oWlVYb01TR0FlYzlBdksv?=
 =?utf-8?B?UTZ1UzZ0L0NRaUlHOFV6aGdaaVAwQzcxWTNxRWJRK1VWVnljYlFtZTF2Mkgz?=
 =?utf-8?B?Q3k1UVV4ZS9TMDVhNEdZU1U3dERrZ1hzUGp6a2NTclIxQm5GeElBemNwRC9y?=
 =?utf-8?B?SGk1bE5JemZmbityRFNnck1HMmxQdk1SZDRPb01tVzVHdWVCUmNnL2pNTVlk?=
 =?utf-8?B?UG14WGlIU2V5ZkpGalVTM0twVDNCT0NGUVUyZ29OL2pTeHQ2a25adURvdEdB?=
 =?utf-8?B?OUE3L1hXelJ1RXBJamxjc1M1UmhLaUdJTytmZ0dHWjd0RmJQL3QxL1hjSUtD?=
 =?utf-8?B?YngrZ015RHppbHFDOEh2M2ZZWTZKZnU1QWJjQys3VkU3bTdxU25CSGFxYXRE?=
 =?utf-8?B?b2lieE9taFdsSm9kc3pydW54RDFNZW5TMkROQit2SytudmNxYWtOQklaRDY4?=
 =?utf-8?B?YTFtQlUxbEFJeTlVcnBoVm5FbGdXaFBEa0YzMFZlK1RjWmFzaS9hRW5vcHow?=
 =?utf-8?B?R0RxWENWbWllM083cEE1NGhlTTJSaG9WbUJacGE2UHNIQkRDOEFwR3RldGd6?=
 =?utf-8?B?ZGJ3Qi9rZnM1VE82d2JsV1BaYkt5L1BzQ3lBQms4ckZKcWQ4bWZ6VGxSRkxn?=
 =?utf-8?B?Ym9YNE1FOTNscHNneEVaTDBhTFlsdEJ4RGY4MTdYSmRiODI3bmRoWWk1T28z?=
 =?utf-8?B?eGtJZ0lKRUh1MXhpTmxlWFZ2TU9zM3pQYVRqUk1rWEg1OERxRGpSSEJtSW41?=
 =?utf-8?B?aFUyd0dvS0dnY3Jna05LblVUUlNaTUZ0MXNkczBTeGx2UGl3WUVoWnhKU1Fo?=
 =?utf-8?B?Tk52akRmUWx1UnhZSHhsUUE2S3dHaWh0WnlYaHo1UmdMWEF5cFZ1aVY0M0FK?=
 =?utf-8?B?a3Y0RjNPR1BGbTgycFlaTm5BTkdVSGRMYU53Zz09?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB03.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(82310400026)(36860700013)(1800799024)(376014)(7416014);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Sep 2025 04:21:59.9319
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 4e228e43-e969-4d10-46ed-08dde90f186a
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB03.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CH1PEPF0000AD77.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR12MB4164

Hello Boris,

On 8/30/2025 10:49 PM, Borislav Petkov wrote:
> On Mon, Aug 25, 2025 at 07:57:30AM +0000, K Prateek Nayak wrote:
>> This has not been a problem on baremetal platforms since support for
>> TOPOEXT (Fam 0x15 and later) predates the support for CPUID leaf 0xb
>> (Fam 0x17[Zen2] and later), however, for AMD guests on QEMU, "x2apic"
>> feature can be enabled independent of the "topoext" feature where QEMU
>> expects topology and the initial APICID to be parsed using the CPUID
>> leaf 0xb (especially when number of cores > 255) which is populated
>> independent of the "topoext" feature flag.
> 
> This sounds like we're fixing the kernel because someone *might* supply
> a funky configuration to qemu. You need to understand that we're not wagging
> the dog and fixing the kernel because of that.
> 
> If someone manages to enable some weird concoction of feature flags in qemu,
> we certainly won't "fix" that in the kernel.
> 
> So let's concentrate that text around fixing the issue of parsing CPUID
> topology leafs which we should parse and looking at CPUID flags only for those
> feature leafs, for which those flags are existing.
> 
> If qemu wants stuff to work, then it better emulate the feature flag
> configuration like the hw does.

Ack. I'll add the relevant details in
Documentation/arch/x86/topology.rst in the next version as discussed but
I believe you discovered the intentions for this fix in the kernel
below.

> 
>> Unconditionally call cpu_parse_topology_ext() on AMD and Hygon
>> processors to first parse the topology using the XTOPOLOGY leaves
>> (0x80000026 / 0xb) before using the TOPOEXT leaf (0x8000001e).
>>
>> Cc: stable@vger.kernel.org # Only v6.9 and above
>> Link: https://lore.kernel.org/lkml/1529686927-7665-1-git-send-email-suravee.suthikulpanit@amd.com/ [1]
>> Link: https://lore.kernel.org/lkml/20080818181435.523309000@linux-os.sc.intel.com/ [2]
>> Link: https://bugzilla.kernel.org/show_bug.cgi?id=206537 [3]
>> Suggested-by: Naveen N Rao (AMD) <naveen@kernel.org>
>> Fixes: 3986a0a805e6 ("x86/CPU/AMD: Derive CPU topology from CPUID function 0xB when available")
>> Signed-off-by: K Prateek Nayak <kprateek.nayak@amd.com>
>> ---
>> Changelog v3..v4:
>>
>> o Quoted relevant section of the PPR justifying the changes.
>>
>> o Moved this patch up ahead.
>>
>> o Cc'd stable and made a note that backports should target v6.9 and
>>   above since this depends on the x86 topology rewrite.
> 
> Put that explanation in the CC:stable comment.

Ack.

> 
>> ---
>>  arch/x86/kernel/cpu/topology_amd.c | 8 ++------
>>  1 file changed, 2 insertions(+), 6 deletions(-)
>>
>> diff --git a/arch/x86/kernel/cpu/topology_amd.c b/arch/x86/kernel/cpu/topology_amd.c
>> index 827dd0dbb6e9..4e3134a5550c 100644
>> --- a/arch/x86/kernel/cpu/topology_amd.c
>> +++ b/arch/x86/kernel/cpu/topology_amd.c
>> @@ -175,18 +175,14 @@ static void topoext_fixup(struct topo_scan *tscan)
>>  
>>  static void parse_topology_amd(struct topo_scan *tscan)
>>  {
>> -	bool has_topoext = false;
>> -
>>  	/*
>> -	 * If the extended topology leaf 0x8000_001e is available
>> -	 * try to get SMT, CORE, TILE, and DIE shifts from extended
>> +	 * Try to get SMT, CORE, TILE, and DIE shifts from extended
>>  	 * CPUID leaf 0x8000_0026 on supported processors first. If
>>  	 * extended CPUID leaf 0x8000_0026 is not supported, try to
>>  	 * get SMT and CORE shift from leaf 0xb first, then try to
>>  	 * get the CORE shift from leaf 0x8000_0008.
>>  	 */
>> -	if (cpu_feature_enabled(X86_FEATURE_TOPOEXT))
>> -		has_topoext = cpu_parse_topology_ext(tscan);
>> +	bool has_topoext = cpu_parse_topology_ext(tscan);
> 
> Ok, I see what the point here is - you want to parse topology regardless of
> X86_FEATURE_TOPOEXT.
> 
> Which is true - latter "indicates support for Core::X86::Cpuid::CachePropEax0
> and Core::X86::Cpuid::ExtApicId" only and the leafs cpu_parse_topology_ext()
> attempts to parse are different ones.
> 
> So, "has_topoext" doesn't have anything to do with X86_FEATURE_TOPOEXT - it
> simply means that the topology extensions parser found some extensions and
> parsed them. So let's rename that variable differently so that there is no
> confusion.
> 
> You can do the renaming in parse_8000_001e() in a later patch as that is only
> a cosmetic thing and we don't want to send that to stable.

Ack! Does "has_xtopology" sound good or should we go for something more
explicit like "has_xtopology_0x26_0xb"?

Patch 3 will get rid of that "has_topoext" argument in parse_8000_001e()
entirely so I'll rename the local variable here and use the subsequent
cleanup for parse_8000_001e().

-- 
Thanks and Regards,
Prateek


