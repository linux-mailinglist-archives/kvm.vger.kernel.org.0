Return-Path: <kvm+bounces-67558-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id B5A9AD08FB4
	for <lists+kvm@lfdr.de>; Fri, 09 Jan 2026 12:45:39 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id A07E23042821
	for <lists+kvm@lfdr.de>; Fri,  9 Jan 2026 11:41:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 476AC33A9E9;
	Fri,  9 Jan 2026 11:41:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="bOsvB8Ka"
X-Original-To: kvm@vger.kernel.org
Received: from PH8PR06CU001.outbound.protection.outlook.com (mail-westus3azon11012014.outbound.protection.outlook.com [40.107.209.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 09A0E33375D
	for <kvm@vger.kernel.org>; Fri,  9 Jan 2026 11:41:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.209.14
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767958903; cv=fail; b=h2q8DntyhosNUX4U3rQ0EGlqf6hQ2PiF3SCcs+WJ4nYQkvGJFTygAjGttSxMpwLAlXGLp9uOKhzhqrh3qbSPwX2ExInL01WEf3mccAnZgy2yDfsxg/BLcLRU1SiRRJ8PDDUxjwC9DHZX8qxnnzDnJ1dWy2JRvs8rqJoRRMQatWE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767958903; c=relaxed/simple;
	bh=I0XobOdAHvYyHUWpcdZdHbtOaEdn2Lzlk0gMp04LF6Q=;
	h=Message-ID:Date:MIME-Version:Subject:To:CC:References:From:
	 In-Reply-To:Content-Type; b=rnEaPbNb0S1UqTJmqY/U8K/XQ0R1X/3Iv+CwN5CAwa9us4cQIY1s8uAjiCpGgxUeG0r8vClzcIf7DFgf/dJq9OVsxAtHrT2dqjajAq9q31DdQcDr+ilJck2eiQ8bI42QFvvm9+IrX4LJSRMrmp85OaLvGdCFwaqnk4heQDVCws8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=bOsvB8Ka; arc=fail smtp.client-ip=40.107.209.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=JzUHFBzqwQNSVXjRwG47JW+UarJ9j0rzDtx0PVcvI6Y6HwVHxgFVEHsWifz2wBtad4sdYMRvTjM0k2JgCYhS2JbX84SS7rUco0pyTwcwraeRv6wEf7AVwAd/Chnk6LtpXULZ9D1LibY168xlnQ27EPM/MAiD62eJ7ki+eED/IgAKGaH5mDEPoCgTL7lFD5nsvGDB6VLPPS/eQD8s3G8cvyoCmh+qj25Q8WpgO/LMgphQf0lIPB7Deooqqfo8oA9l5j9u/Hz+rckJhmeaGiIo2Bz0c0zE0Bd1UeuLfJrPAST+eFMCJRh/9kI8kfogy+eDEXgXnzpnvRYzbtF6vzIWbQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=fufjMx6DZSLdRdkrR83gPsNDsD2VVgHIM9YtAjdKYxM=;
 b=MlgfjvAAbaO8PoXG2wsODFwDRS8vN/JsoIeQzXGgqL9QXpXRrcjy/yo6PFBKAeJat5NP5njHM6kTT+1aon9NysKHEV3Cwj6/DzEXho4p00oU1At74A4DSaS+0VVHm8GQ89ycTDC5TpjD9CYg5yb+QaT68oj3511hza2N5SEjhCBhQVRCtsHNi0Pm2pyok7e2CpC8NddBPMWkZkBaePmueLxaY36znyMu7vB1tkNW3SzZK8V1Tw5O3sVD2OZszlJ4pTRh5lzwTWyIl2XwA5/cuiUTxaTDWN57M67Q3/pHvSOa8tnJVHTuGZMReLXNv7npzsVtfnjDWASOdwd2ppLi3Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=temperror (sender ip
 is 165.204.84.17) smtp.rcpttodomain=intel.com smtp.mailfrom=amd.com;
 dmarc=temperror action=none header.from=amd.com; dkim=none (message not
 signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fufjMx6DZSLdRdkrR83gPsNDsD2VVgHIM9YtAjdKYxM=;
 b=bOsvB8KaDF1+gTBYZnsgXAfq655sOUjc1kFxOgdn9pwXwgQl6s7CZbkDi0MtcNSnDtV6/cj1xYCV3VySRfjqytghiq6eUdizD9IrVKIivjGbll1ueOi8urlIhpwah5tEItN16X/WGjX5Z15uzqExs8ooKfFy+DazYEWoKA328Kk=
Received: from CH2PR03CA0019.namprd03.prod.outlook.com (2603:10b6:610:59::29)
 by SN7PR12MB8602.namprd12.prod.outlook.com (2603:10b6:806:26d::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9499.2; Fri, 9 Jan
 2026 11:41:38 +0000
Received: from CH1PEPF0000AD75.namprd04.prod.outlook.com
 (2603:10b6:610:59:cafe::e6) by CH2PR03CA0019.outlook.office365.com
 (2603:10b6:610:59::29) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9499.5 via Frontend Transport; Fri, 9
 Jan 2026 11:41:18 +0000
X-MS-Exchange-Authentication-Results: spf=temperror (sender IP is
 165.204.84.17) smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=temperror action=none header.from=amd.com;
Received-SPF: TempError (protection.outlook.com: error in processing during
 lookup of amd.com: DNS Timeout)
Received: from satlexmb07.amd.com (165.204.84.17) by
 CH1PEPF0000AD75.mail.protection.outlook.com (10.167.244.54) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9520.1 via Frontend Transport; Fri, 9 Jan 2026 11:41:36 +0000
Received: from satlexmb08.amd.com (10.181.42.217) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.17; Fri, 9 Jan
 2026 05:41:35 -0600
Received: from [10.136.45.190] (10.180.168.240) by satlexmb08.amd.com
 (10.181.42.217) with Microsoft SMTP Server id 15.2.2562.17 via Frontend
 Transport; Fri, 9 Jan 2026 05:41:31 -0600
Message-ID: <df23391a-599a-495b-a1b2-ed548215e2c5@amd.com>
Date: Fri, 9 Jan 2026 17:11:29 +0530
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/5] i386: Implement CPUID 0x80000026
To: Zhao Liu <zhao1.liu@intel.com>
CC: <pbonzini@redhat.com>, <mtosatti@redhat.com>, <kvm@vger.kernel.org>,
	<qemu-devel@nongnu.org>, <seanjc@google.com>, <santosh.shukla@amd.com>,
	<nikunj.dadhania@amd.com>, <ravi.bangoria@amd.com>, <babu.moger@amd.com>,
	Shivansh Dhiman <shivansh.dhiman@amd.com>, K Prateek Nayak
	<kprateek.nayak@amd.com>
References: <20251121083452.429261-1-shivansh.dhiman@amd.com>
 <20251121083452.429261-2-shivansh.dhiman@amd.com>
 <aV4KVjjZXZSB5YGw@intel.com> <eb712000-bc67-468a-b691-097688233659@amd.com>
 <aWDEYEfB4va41+Tv@intel.com>
Content-Language: en-US
From: Shivansh Dhiman <shivansh.dhiman@amd.com>
In-Reply-To: <aWDEYEfB4va41+Tv@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH1PEPF0000AD75:EE_|SN7PR12MB8602:EE_
X-MS-Office365-Filtering-Correlation-Id: 876f0edb-b172-4fc2-5ef2-08de4f740bfa
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700013|376014|82310400026|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?dkZEekx1RTU3WGUzYmJMaHZ6QmFpcVgweERDeU5xYW9wNTArZmw1MUUzNnkz?=
 =?utf-8?B?dTZlUU5DaVB4b3ZYdndhN09XdlFCTThSNGRWWXY1dWZJUW84OThmeTN0Z3Rw?=
 =?utf-8?B?alNvMzVockZVdWZaNTNLTDVlM3dFTC82Z0QwZmtyZjlFaXVYTTVCLzgyWXlB?=
 =?utf-8?B?MUV0MVo4UnA3clg1Q2NNK1JVaGw3Mnd5d0hvdm8xbnFTL2tvYklxQXVsdjk4?=
 =?utf-8?B?ejVZa0FiYUdRWEp3R0ZHY0pMQTdFSVF0UU9McXp0cXpXZ2t6MnpxbzNGaHlj?=
 =?utf-8?B?M2pHRlMyb2ppQVNQcTlBYUttQ1dOc0xML2FWNHU0MWdYS1c0enBqV2dlb0tw?=
 =?utf-8?B?aXFGcmlLWTF3TElmclYzMm0wU2NZd1lMSWpqVm9VOEpLY2VTU2lZeWtNcHgy?=
 =?utf-8?B?dFArZWdVWmpPN1ZwMkdGVTl6bTEvalBnbk52NnYwV0NDS3VneFVhdWtUNmVT?=
 =?utf-8?B?aWhlVVQ2T2hPSlBxY3JIdkZFM2FobHFkdEZ5eE5HNW1ZQWZ1RGgzSDUyR0xV?=
 =?utf-8?B?b2RZU0JZMFlpVDNrNTVjSGdLSWlkenpjQ0IrNUNLU3lqZHVWekFoSDd6RDBz?=
 =?utf-8?B?ellzckZDNG9BbklRVloyV2M1YVpOeXdJWjJZMzFPelVOSDJCUXZldmx3c29N?=
 =?utf-8?B?QnVRZjdsdTV2TzlWdS9CdXNVT05jQUxHeG1aVlQ5UHcxeFQ2UTN0S0plZUYx?=
 =?utf-8?B?RkowZElDcXAvZ2Q5M3pPcXJ0U3lsYzFhR3BBZ3c5ZkNNVVpYU01IR0ozNVBl?=
 =?utf-8?B?Y2tVN1ppd2NVTUFqZU13SzZnamlzRkF4OEZmMUFubGE4UnArMFJIYVhveDFp?=
 =?utf-8?B?cTFSWDc2RDR4VEp2emlMdE80NmowWTljenJmM0luQTBVUUZWbjlybUtMbGhC?=
 =?utf-8?B?czZDeTRLeEtTZVhGbVZMcHRDT0hoQUhtUEU2UFczckk5UUl6bVl6SGs4Z0RI?=
 =?utf-8?B?Z3YvTzVtb2VnNEx0aFA0M2psblVvNTZxWjVnbGdBcTZLMzUrSURROXRCT2s1?=
 =?utf-8?B?bjNxODVNMEcwVkNUV0F2cnY3S2FFR0dQTlBTS0Yza2crLzVhZDd5WkJMTG1O?=
 =?utf-8?B?YXhYM3ZmdHFReWEyeWptdkQ1Q3BIUzVPWlhOL0g3YWJsV3pRZ05qam5NRVZo?=
 =?utf-8?B?WVJGQlRyZ2g4MFFzOTlod1l1OXFqUURDMzVaUm1SbGZQTG1tL3cvRlp6SkYz?=
 =?utf-8?B?QWlPbGFNMmZON1ViU012bGY4UlNNSk05SktVbk12Y2FVays5bXhQaitKYTA3?=
 =?utf-8?B?TUgwWi9zTHl5WDN6ZlZyOXVEOTdRSW9ZVlZnQi8yWWtPaWVYSUU4WHllZjJ1?=
 =?utf-8?B?OFh0S3R0YlJMajFzWllvN3hFU2l1WVB4dFFDWEk0NzZySjZqQVMvT3cySGxK?=
 =?utf-8?B?TUFiS29aVDdKM0xNMnZjYklzZWlmSkNzUDdLRXB3cUFoNGtVTm1VNEJPM0RV?=
 =?utf-8?B?bk1pYnV3RGFxOEQxTngrQk1oQXlNUGFBYllYSExHODgyR3RFRWlINHExMFVv?=
 =?utf-8?B?aEZDcTBROVBWeDhLTjlYTmJtblJubE1VcGx4V0ZlRUc4TWF2d2YvUTdxSXdQ?=
 =?utf-8?B?bzgwQktuN25nUVBVSldnanZQSFdXeWpHVWdFeUlWODZwSzVVMm15d2RabE4r?=
 =?utf-8?B?dUdFWW0yRlVBdHc5TjdScjlaMDQ5M0JpZHIvUHdUMnRnU1l5QlltQUVqVmgz?=
 =?utf-8?B?QjFCRU5jS0FPcjFNeTJ3b3BhbTFDcUhOUUNGNmN1V0x4QjNLVE9nUFhDakt1?=
 =?utf-8?B?RTlQbzVGbzZlUGkzRkJZRHVqV1RiWTBxa0w2OVgvbDdFYjlvMmdneUFLdVow?=
 =?utf-8?B?cDN3OFNvYWtHNVdvd1RwNkhmOGUyOE1obG5TWEE2SFVBZDJCTHNkVnpzMWJz?=
 =?utf-8?B?LzkxSDVOVVE0MmhFMkVhSjBrNlZLRTVRSEJjd1BFVE8rUm1ybkNFWjNrK3hE?=
 =?utf-8?B?MWxNZ2l6bG4xV0tKRVVUaCtnRjdVelU3M1ZFdW9rWjUzZmZ4a1JwOGtsVW9Z?=
 =?utf-8?B?emhuSWlkc2lBM002WWdySnhvZFhqUU91aFdZc1JQVkpIRDBuTlEvOVpKVWc0?=
 =?utf-8?B?d2NVdm1iZ3FBUU1LeDlMLzdOM2dsalJGR0EzNHFrZDFlWjhBUlBQSkRvL3F5?=
 =?utf-8?Q?H1VU=3D?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:satlexmb07.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(36860700013)(376014)(82310400026)(1800799024);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Jan 2026 11:41:36.8341
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 876f0edb-b172-4fc2-5ef2-08de4f740bfa
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb07.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CH1PEPF0000AD75.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR12MB8602



On 09-01-2026 14:33, Zhao Liu wrote:
> On Thu, Jan 08, 2026 at 04:03:12PM +0530, Shivansh Dhiman wrote:
>> Date: Thu, 8 Jan 2026 16:03:12 +0530
>> From: Shivansh Dhiman <shivansh.dhiman@amd.com>
>> Subject: Re: [PATCH 1/5] i386: Implement CPUID 0x80000026
>>
>> Hi Zhao,
>>
>> On 07-01-2026 12:55, Zhao Liu wrote:
>>> Hi Shivansh,
>>>
>>> Sorry for late reply.
>>>
>>> On Fri, Nov 21, 2025 at 08:34:48AM +0000, Shivansh Dhiman wrote:
>>>> Date: Fri, 21 Nov 2025 08:34:48 +0000
>>>> From: Shivansh Dhiman <shivansh.dhiman@amd.com>
>>>> Subject: [PATCH 1/5] i386: Implement CPUID 0x80000026
>>>> X-Mailer: git-send-email 2.43.0
>>>>
>>>> Implement CPUID leaf 0x80000026 (AMD Extended CPU Topology). It presents the
>>>> complete topology information to guests via a single CPUID with multiple
>>>> subleafs, each describing a specific hierarchy level, viz. core, complex,
>>>> die, socket.
>>>>
>>>> Note that complex/CCX level relates to "die" in QEMU, and die/CCD level is
>>>> not supported in QEMU yet. Hence, use CCX at CCD level until diegroups are
>>>> implemented.
>>>
>>> I'm trying to understand AMD's topology hierarchy by comparing it to the
>>> kernel's arch/x86/kernel/cpu/topology_ext.c file:
>>>
>>> static const unsigned int topo_domain_map_0b_1f[MAX_TYPE_1F] = {
>>> 	[SMT_TYPE]	= TOPO_SMT_DOMAIN,
>>> 	[CORE_TYPE]	= TOPO_CORE_DOMAIN,
>>> 	[MODULE_TYPE]	= TOPO_MODULE_DOMAIN,
>>> 	[TILE_TYPE]	= TOPO_TILE_DOMAIN,
>>> 	[DIE_TYPE]	= TOPO_DIE_DOMAIN,
>>> 	[DIEGRP_TYPE]	= TOPO_DIEGRP_DOMAIN,
>>> };
>>>
>>> static const unsigned int topo_domain_map_80000026[MAX_TYPE_80000026] = {
>>> 	[SMT_TYPE]		= TOPO_SMT_DOMAIN,
>>> 	[CORE_TYPE]		= TOPO_CORE_DOMAIN,
>>> 	[AMD_CCD_TYPE]		= TOPO_TILE_DOMAIN,
>>> 	[AMD_SOCKET_TYPE]	= TOPO_DIE_DOMAIN,
>>> };
>>
>> These mappings reuse some original names (SMT_TYPE and CORE_TYPE) along with the
>> new ones (AMD_CCD_TYPE and AMD_SOCKET_TYPE). I think to avoid defining more AMD
>> specific types the original names are used. So, essentially you can read them
>> like this:
>>
>> static const unsigned int topo_domain_map_80000026[MAX_TYPE_80000026] = {
>> 	[AMD_CORE_TYPE]		= TOPO_SMT_DOMAIN,
>> 	[AMD_CCX_TYPE]		= TOPO_CORE_DOMAIN,
>> 	[AMD_CCD_TYPE]		= TOPO_TILE_DOMAIN,
>> 	[AMD_SOCKET_TYPE]	= TOPO_DIE_DOMAIN,
>> };
> 
> Thank you! It's clear and I see the difference.
>  
>>> What particularly puzzles me is that "complex" isn't listed here, yet it
>>> should be positioned between "core" and CCD. Does this mean complex
>>> actually corresponds to kernel's module domain?
>>
>> There is a nuance with CPUID 80000026h related to the shifting of x2APIC ID.
>> According to APM, EAX[4:0] tells us the number of bits to shift x2APIC ID right
>> to get unique topology ID of the next instance of the current level type.
>>
>> So, all logical processors with the same next level ID share current level. This
>> results in mapping the Nth level type to (N-1)th domain. This is unlike Intel's
>> CPUID 0xb which maps Nth level type to Nth domain.
> 
> Yes, it's the core difference. I think it's better to have a helper
> clearly define the mapping between QEMU general topo level v.s. AMD topo
> types, similar to cpuid1f_topo_type().

Yeah. That can be done.

> 
>> Back to your question, the complex is same as tile since both represent a L3
>> cache boundary.
> 
> Yeah, this makes sense. CCD->die, and CCX->tile.
> 
>>> Back to QEMU, now CCX is mapped as QEMU's die level, and AMD socket is mapped
>>> to socket level. Should we revisit QEMU's topology level mapping for AMD, to
>>> align with the above topology domain mapping?
>>>
>>> If we want to go further: supporting CCD configuration would be quite
>>> tricky. I feel that adding another new parameter between the smp.dies
>>> and smp.sockets would create significant confusion.
>>
>> The current kernel doesn't have sensitivity to a level between L3 boundary and
>> socket. Also, most production systems in current AMD CPU landscape have CCD=CCX.
>> Only a handful of models feature CCD=2CCX, so this isn't an immediate pressing need.
>>
>> In QEMU's terminology, socket represents an actual socket and die represents the
>> L3 cache boundary. There is no intermediate level between them. Looking ahead,
>> when more granular topology information (like CCD) becomes necessary for VMs,
>> introducing a "diegroup" level would be the logical approach. This level would
>> fit naturally between die and socket, as its role cannot be fulfilled by
>> existing topology levels.
> 
> With your nice clarification, I think this problem has become a bit easier.
> 
> In fact, we can consider that CCD=CCX=die is currently the default
> assumption in QEMU. When future implementations require distinguishing between
> these CCD/CCX concepts, we can simply introduce an additional "smp.tiles" and
> map CCX to it. This may need a documentation or a compatibility option, but I
> believe these extra efforts are worthwhile.
> 
> And "smp.tiles" means "how many tiles in a die", so I feel it's perfect
> to describe CCX.

That indeed looks like a cleaner solution. However, I'm concerned about
retaining compatibility with existing "dies". But yeah, that's a task for a
later time.

> 
>> Also, I was looking at Intel's SDM Vol. 2A "Instruction Set Reference, A-Z"
>> Table 3-8. "Information Returned by CPUID Instruction". The presence of a
>> "diegrp" level between die and socket suggests Intel has already recognized the
>> need for this intermediate topology level. If this maps to a similar concept as
>> AMD's CCD, it would indeed strengthen the case for introducing a new level in QEMU.
> 
> SDM has "diedrp" but currently no product is using it. So it's hard for me
> to say what this layer will look like in the future, especially with
> topology-aware features/MSRs. Therefore, I prefer to add the "tile" if
> needed, as it aligns better with the existing hierarchy definition. Anyway,
> this is the future topic (though it is related with the last statement in your
> commit message). At least for now, how to map the AMD hierarchy is fairly
> clear.

Ack.

> 
> Thanks,
> Zhao
> 


