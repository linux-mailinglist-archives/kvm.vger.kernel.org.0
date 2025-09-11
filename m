Return-Path: <kvm+bounces-57273-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id C415DB527C8
	for <lists+kvm@lfdr.de>; Thu, 11 Sep 2025 06:38:10 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 7F71D3A5B4D
	for <lists+kvm@lfdr.de>; Thu, 11 Sep 2025 04:38:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D8A3923BD02;
	Thu, 11 Sep 2025 04:38:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="kx9AmEWR"
X-Original-To: kvm@vger.kernel.org
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2070.outbound.protection.outlook.com [40.107.223.70])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2DD4C329F3C;
	Thu, 11 Sep 2025 04:37:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.223.70
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757565482; cv=fail; b=C5xIiNX/K7LTdcIZNq85BgTt/zMAg7Jrim7MNdYIZIQtVxMf7yek+EcDvOjYW7nko5PwvQsxhO3s2dwaD1ZkTTZ0qfIejiyirhEUaKI+sBaHXEbSHAPwlm2sCx7rMl6il+cR2QeKA3oeMYedeFBq5Hprrs2O982cistyi8datW8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757565482; c=relaxed/simple;
	bh=3hDYoxkyVgQHOkYcoI7Z1Ln8LrwTkf4HmSbi5sNYcko=;
	h=Message-ID:Date:MIME-Version:Subject:To:CC:References:From:
	 In-Reply-To:Content-Type; b=ULDVDyvQZYDkFTVZaRjo17qQqeo3hFXY0i78yY2iERab2VLCRMgiQUc7BPiJz4akj7ajiWaWmRAOb7KXLorn5sr6Z+72VQqVjUmQCeccWZY9QAQUOhWzoYgXUdt+yABk5XWw8OGpneHRuRlxT4ej4DzHWCdbjbVhC8lF0HHKT4g=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=kx9AmEWR; arc=fail smtp.client-ip=40.107.223.70
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=TCyGj6USZT2RFbbVHDO0n2usmXk/j9r3ik09H4I6Qtu8uewSZ9mkHPUp1Po1EpcecgT3jmiY6tFrgDdW+oBga/NelA06BV2EaVWiBWPwHAVVnODXc8eQX6O8zSuhGSnOPFAnz22Lf65bCaLNtOYhEgJykW18nWWbM3zLXKx5hs08vHkoRsGVciugp6YkYjV8tlQaZCnavXRhbcV0ZL9OvnP9+3JyjGj9DgTBmFC9gIbRZoCDE2m1qVCg3Upv861/hqoSnLsN8abO5bZAqALaJyLbUMT2r+u5bh+e8qlNS+PUU1d0wYF+0kZHZkrHZ/46hkoUIUma1zGqJKOKRhoxyg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=zoHePVqIWxrtYnkox6Kj7fWxAnUVHjkCBKfIygL1ZYY=;
 b=m2kf7EWtRszEjp+fVVhhg23Jb6bS+kbmyT8ubup3Im0QKsXk26vkhTtnI3D/Atfdymhqk2LIiMlq7rErXFPWp2ILNnGJUnHJFXAj/WcHc9J4oA+qHYfFINeKcaGjDwuWxrjKiUkaINN3NwLWOJQfiEapRX8svT0J3PNAM1owSPgtfPBhqlCLAgHEaIj6dUZspXtrFnJE9+at7s49W+NCcWC2q+069frQtU5NKnu9N7882OXe2VPSW1xABgIV5J3LNAY4hpPvS/uP24bEb1FUIuGS1ozwoXHDKlnHRDIBIIw6vs6ReBOQCkseQPe5U6bZE2SGZfUKx3F/sbLzV4Lu+A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=linutronix.de smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zoHePVqIWxrtYnkox6Kj7fWxAnUVHjkCBKfIygL1ZYY=;
 b=kx9AmEWRS8gbi2a0Q6Iyll40gm4fLqIWlrs533UuuNdi3xDNHortDnFeFyF8OFBlSMI03EM6t0Itn5vH7KWNZ5vGNuCvNbdf/4x0Ky7dEZgM3nkW4PSfFUMor2YhwS8pQH6+feyeLklOZ8M0gy3Zvd5SXpXT241pdsGG7vcYPKM=
Received: from BY5PR17CA0058.namprd17.prod.outlook.com (2603:10b6:a03:167::35)
 by DM4PR12MB8500.namprd12.prod.outlook.com (2603:10b6:8:190::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9094.22; Thu, 11 Sep
 2025 04:37:54 +0000
Received: from SJ5PEPF000001CB.namprd05.prod.outlook.com
 (2603:10b6:a03:167:cafe::9b) by BY5PR17CA0058.outlook.office365.com
 (2603:10b6:a03:167::35) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9073.25 via Frontend Transport; Thu,
 11 Sep 2025 04:37:54 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb08.amd.com; pr=C
Received: from satlexmb08.amd.com (165.204.84.17) by
 SJ5PEPF000001CB.mail.protection.outlook.com (10.167.242.40) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9115.13 via Frontend Transport; Thu, 11 Sep 2025 04:37:53 +0000
Received: from Satlexmb09.amd.com (10.181.42.218) by satlexmb08.amd.com
 (10.181.42.217) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.17; Wed, 10 Sep
 2025 21:37:53 -0700
Received: from satlexmb08.amd.com (10.181.42.217) by satlexmb09.amd.com
 (10.181.42.218) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.17; Wed, 10 Sep
 2025 21:37:52 -0700
Received: from [172.31.178.191] (10.180.168.240) by satlexmb08.amd.com
 (10.181.42.217) with Microsoft SMTP Server id 15.2.2562.17 via Frontend
 Transport; Wed, 10 Sep 2025 21:37:46 -0700
Message-ID: <8a4272f7-0d22-43f0-993b-6d53172b7f65@amd.com>
Date: Thu, 11 Sep 2025 10:07:39 +0530
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 1/4] x86/cpu/topology: Always try
 cpu_parse_topology_ext() on AMD/Hygon
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
	Borislav Petkov <bp@alien8.de>, Dave Hansen <dave.hansen@linux.intel.com>,
	Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>,
	Jonathan Corbet <corbet@lwn.net>, <x86@kernel.org>
CC: Naveen rao <naveen.rao@amd.com>, Sairaj Kodilkar <sarunkod@amd.com>, "H.
 Peter Anvin" <hpa@zytor.com>, "Peter Zijlstra (Intel)"
	<peterz@infradead.org>, "Xin Li (Intel)" <xin@zytor.com>, Pawan Gupta
	<pawan.kumar.gupta@linux.intel.com>, <linux-kernel@vger.kernel.org>,
	<kvm@vger.kernel.org>, Mario Limonciello <mario.limonciello@amd.com>,
	"Gautham R. Shenoy" <gautham.shenoy@amd.com>, Babu Moger
	<babu.moger@amd.com>, Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
	<stable@vger.kernel.org>, Naveen N Rao <naveen@kernel.org>
References: <20250901170418.4314-1-kprateek.nayak@amd.com>
 <20250901170418.4314-2-kprateek.nayak@amd.com> <87o6rirrvc.ffs@tglx>
Content-Language: en-US
From: K Prateek Nayak <kprateek.nayak@amd.com>
In-Reply-To: <87o6rirrvc.ffs@tglx>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ5PEPF000001CB:EE_|DM4PR12MB8500:EE_
X-MS-Office365-Filtering-Correlation-Id: f8c6feff-a299-4ff7-3ba1-08ddf0ecf914
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|30052699003|376014|7416014|36860700013|1800799024|13003099007;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?eEJadjFKWGRDaVhpQUhMVHA3UklyUmYveGwzeHVjbTZuOU5Takl1VUFNdUlj?=
 =?utf-8?B?QnFpR1FSbFIwR0NYbS9rMlJ1SGxCM21pWUNqYkdSV1lhTjFHdFpCWDB6WFNr?=
 =?utf-8?B?a052bTYyU1hoSktVRGJiUWJJd0NYOWxUT2hOa0tHV29ubUl0M3ArWlBUU1Ez?=
 =?utf-8?B?UHlMSGt4a3VPK1ZwNzdGc2l6N0ZJdmN2akpFdmc5TUxQZjMwOUR4SC9wdSto?=
 =?utf-8?B?UjBjdWUyTkJoeFI5cVJaczdZNHZ2enlzUFZKdVFqeHhHZVZXM0g5YkpkVk5u?=
 =?utf-8?B?MDF2ZldJU09semc5RlFUM3pYSlQzLy9Lb0ZOL3I0aWk1emRDbmtFZ2JmWkpM?=
 =?utf-8?B?a1JOVGtQSzExY0hTL1FJOFZaL3IrMFljRmNFSHMxTVpCUS9iYit4azZqbmNT?=
 =?utf-8?B?WldIdktsNkk2d29Sa0FHQmthc2Y1Z2hHbTlkOWV2T3Z5SVIwUjE3L2Mrc0lz?=
 =?utf-8?B?U2p5RlhnbFBDaXNIbW1EUUVESVFyMVRWbDZFSnFqSkl2S1pzUzZVUnZ3alEz?=
 =?utf-8?B?L1NaYzRYcStkR2ZZSk14ZUZYdTFqWkRmMG1SUlhZL3hVWHl1UTdxK0lXVWpY?=
 =?utf-8?B?dlRZb2RJRGxCaEZPZTRKOCtLOFdtQStsK3R5Rzg4cmtZN3MrOE5PYkZvNkJB?=
 =?utf-8?B?TnNlMzYxa2tIVEk0TzBmMFp2TWJMc29aRGR3eG9VNXJaK1NjVG1RZTltMDZ6?=
 =?utf-8?B?aWJKRHdmWXhPZC9DdjFEd2VHTTJZdmhtc2l1ejBzU1lDelovUkIrYjNjVm9H?=
 =?utf-8?B?UXhsaUllWnBRTFZOeVpXeURxZDFEVXNNVVU2c2ttTS9KY1dJUkQ1WmJ2SHdQ?=
 =?utf-8?B?SE9ycUROZFk5S3RyYVFHVG5yMHFCUEQ3YWx4dUtUQkNRQ1lsa0hCaDBiLzR6?=
 =?utf-8?B?aHpmRFRsRVJESEJWVmQwYUVJNXdQNVA0TVFpT3M3UW41am5CeXRJM2ZDZWlX?=
 =?utf-8?B?djB4NG1oak10cU13Rko1dmhrWEYyamFrcFcvWCtPSjlQaXFCSEVMTjdJbVVS?=
 =?utf-8?B?a21WeDFRQjdvUVhDMVRpVzNtL3NTd09YNEtvZzg2TGpEemhqVVlHTTJnRG0z?=
 =?utf-8?B?aE54WDhQK2tuREE5aGdpMExBRWNHdWlUY2hJWkZtSWttbmluaXFxUTNCNWdR?=
 =?utf-8?B?dzZSK0JEVXU5VnR6MlI1c3hZQ2dJN2xrQlhsUXV0RGZsU3AyMUdmSW5nc3BF?=
 =?utf-8?B?MHJ3WlRJbm9rZlJnQWN5ZXU1aVNjVWduVGJDOU5Za1BYdmQ0RjQ4ejVzZVBv?=
 =?utf-8?B?dWJJZDNoZURGNWYzaUV6RlMrLzNtL2xCazJKSDJOVTAzUDU4YU0wM1Z0UVUw?=
 =?utf-8?B?RmtUQjdRMFJnbVh2Y0R3Y1dhSGZYUUxIWm1SVi9IdmNuTUZWcFIxbmxWZEVX?=
 =?utf-8?B?a3pjNG9CTzRlUzY3eVVsbVpvSlBHVjhXOGpLY1h6TzRBZDV0OUNCZ3pRdTlS?=
 =?utf-8?B?S2w2VUtaSmhJTWI2RWZacmxuWHVucXVIUjVRUEhRYlluRWRwQ3lwRkgzUXBs?=
 =?utf-8?B?Rzg5dmlVaXBpTkNTS0N5REh1b2FHQVdESHVldkFRczczY0FMeG1DUm4xdnRC?=
 =?utf-8?B?UWpEZ2I2VnRaWXdqck5uMzRrNVN3elJJTUlpeUN2NzFKVG1neWNDT1MzNXVN?=
 =?utf-8?B?aVl1UFZOL1BXYWFzRm1CSUZVbHBPN0hOM2JjQ3lEVkpxeitYZ0pIVm9IUmlV?=
 =?utf-8?B?R1ZaMkNUaEZFN0dFVENBT256b1dNb0lacnJ6RG1YM1RoUSs5YktJTGRQTHZy?=
 =?utf-8?B?YnBJY3IwZnU1MWh0VTQ0N3d1dCtoME5wYVRBcmZTckplanBQMjZLNHpXK0hr?=
 =?utf-8?B?MEF0N0xyaDlVMDVlWkFxTjBLSkJoKzZXSUV4UTF4ZnROY3l6bnRBL2VKL1I5?=
 =?utf-8?B?S1AzWEFpeml3b1FteHRiSm53d2x0VnJSQ1NWRkp4bDhnRlgyQVVxUjhFOGwz?=
 =?utf-8?B?bXhCY0JWTEZLR2xibG05U0psYm5pRGFmVEpWbTI5OEdYOEhNeGFveUNnOW41?=
 =?utf-8?Q?Hs/PvbZaycHcHrw2z/ahB/QfDMieaw=3D?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:satlexmb08.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(82310400026)(30052699003)(376014)(7416014)(36860700013)(1800799024)(13003099007);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Sep 2025 04:37:53.6938
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: f8c6feff-a299-4ff7-3ba1-08ddf0ecf914
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb08.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SJ5PEPF000001CB.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB8500

Hello Thomas,

On 9/11/2025 1:40 AM, Thomas Gleixner wrote:
> On Mon, Sep 01 2025 at 17:04, K. Prateek Nayak wrote:
>> Unconditionally call cpu_parse_topology_ext() on AMD and Hygon
>> processors to first parse the topology using the XTOPOLOGY leaves
>> (0x80000026 / 0xb) before using the TOPOEXT leaf (0x8000001e).
>>
>> While at it, break down the single large comment in parse_topology_amd()
>> to better highlight the purpose of each CPUID leaf.
>>
>> Cc: stable@vger.kernel.org # Only v6.9 and above; Depends on x86 topology rewrite
>> Link: https://lore.kernel.org/lkml/1529686927-7665-1-git-send-email-suravee.suthikulpanit@amd.com/ [1]
>> Link: https://lore.kernel.org/lkml/20080818181435.523309000@linux-os.sc.intel.com/ [2]
>> Link: https://bugzilla.kernel.org/show_bug.cgi?id=206537 [3]
>> Suggested-by: Naveen N Rao (AMD) <naveen@kernel.org>
>> Fixes: 3986a0a805e6 ("x86/CPU/AMD: Derive CPU topology from CPUID function 0xB when available")
>> Signed-off-by: K Prateek Nayak <kprateek.nayak@amd.com>
>> ---
>> Changelog v4..v5:
>>
>> o Made a note on only targeting versions >= v6.9 for stable backports
>>   since the fix depends on the x86 topology rewrite. (Boris)
> 
> Shouldn't that be backported? I think so, so leave that v6.9 and above
> comment out. The stable folks will notice that it does not apply to pre
> 6.9 kernels and send you a nice email asking you to provide a solution
> for pre 6.9 stable kernels.

Ack! Since this is already in tip:x86/urgent as commit cba4262a19af
("x86/cpu/topology: Always try cpu_parse_topology_ext() on AMD/Hygon")
let me know if I should resend it or that comment can be zapped
in-place.

I can also send out a separate patch targeting stable with the intended
changes. Since we are on the topic, here is the patch I would have sent
out to stable:

(Note: Only tested on top of v6.6.105 stable on a Zen3 machine; no
 changes found in /sys/devices/system/cpu/cpu*/topology/* with the patch
 applied on top)

From: K Prateek Nayak <kprateek.nayak@amd.com>
Subject: [PATCH stable] x86/cpu/amd: Always try detect_extended_topology()
 on AMD processors

commit cba4262a19afae21665ee242b3404bcede5a94d7 upstream.

Support for parsing the topology on AMD/Hygon processors using CPUID leaf 0xb
was added in

  3986a0a805e6 ("x86/CPU/AMD: Derive CPU topology from CPUID function 0xB when available").

In an effort to keep all the topology parsing bits in one place, this commit
also introduced a pseudo dependency on the TOPOEXT feature to parse the CPUID
leaf 0xb.

The TOPOEXT feature (CPUID 0x80000001 ECX[22]) advertises the support for
Cache Properties leaf 0x8000001d and the CPUID leaf 0x8000001e EAX for
"Extended APIC ID" however support for 0xb was introduced alongside the x2APIC
support not only on AMD [1], but also historically on x86 [2].

The support for the 0xb leaf is expected to be confirmed by ensuring

  leaf <= max supported cpuid_level

and then parsing the level 0 of the leaf to confirm EBX[15:0]
(LogProcAtThisLevel) is non-zero as stated in the definition of
"CPUID_Fn0000000B_EAX_x00 [Extended Topology Enumeration]
(Core::X86::Cpuid::ExtTopEnumEax0)" in Processor Programming Reference (PPR)
for AMD Family 19h Model 01h Rev B1 Vol1 [3] Sec. 2.1.15.1 "CPUID Instruction
Functions".

This has not been a problem on baremetal platforms since support for TOPOEXT
(Fam 0x15 and later) predates the support for CPUID leaf 0xb (Fam 0x17[Zen2]
and later), however, for AMD guests on QEMU, the "x2apic" feature can be
enabled independent of the "topoext" feature where QEMU expects topology and
the initial APICID to be parsed using the CPUID leaf 0xb (especially when
number of cores > 255) which is populated independent of the "topoext" feature
flag.

Unconditionally call detect_extended_topology() on AMD processors to first
parse the topology using the extended topology leaf 0xb before using the
TOPOEXT leaf (0x8000001e).

Fixes: 3986a0a805e6 ("x86/CPU/AMD: Derive CPU topology from CPUID function 0xB when available")
Suggested-by: Naveen N Rao (AMD) <naveen@kernel.org>
Signed-off-by: K Prateek Nayak <kprateek.nayak@amd.com>
Link: https://lore.kernel.org/lkml/1529686927-7665-1-git-send-email-suravee.suthikulpanit@amd.com/ [1]
Link: https://lore.kernel.org/lkml/20080818181435.523309000@linux-os.sc.intel.com/ [2]
Link: https://bugzilla.kernel.org/show_bug.cgi?id=206537 [3]
---
For stable maintainers,

The original changes from commit cba4262a19af ("x86/cpu/topology: Always try
cpu_parse_topology_ext() on AMD/Hygon") cannot be easily backported due to the
extensive x86 topology rewrite in v6.9.

This patch cleanly applies on top of all stable kernels from v6.6.y to v5.4.y.
Boris' S-o-b from commit commit cba4262a19af has been dropped since the changes
on top of the stable kernels are slightly different.
---
 arch/x86/kernel/cpu/amd.c | 37 ++++++++++++++++++++++---------------
 1 file changed, 22 insertions(+), 15 deletions(-)

diff --git a/arch/x86/kernel/cpu/amd.c b/arch/x86/kernel/cpu/amd.c
index 864d62e94614..33d8bbdd7b69 100644
--- a/arch/x86/kernel/cpu/amd.c
+++ b/arch/x86/kernel/cpu/amd.c
@@ -391,34 +391,41 @@ static void legacy_fixup_core_id(struct cpuinfo_x86 *c)
  */
 static void amd_get_topology(struct cpuinfo_x86 *c)
 {
+	/*
+	 * Try to get the topology information from the 0xb leaf first.
+	 * If detect_extended_topology() returns 0, parsing was successful
+	 * and APIC ID, cpu_core_id, cpu_die_id, phys_proc_id, and
+	 * __max_die_per_package are already populated.
+	 */
+	bool has_extended_topology = !detect_extended_topology(c);
 	int cpu = smp_processor_id();
 
+	if (has_extended_topology)
+		c->x86_coreid_bits = get_count_order(c->x86_max_cores);
+
 	/* get information required for multi-node processors */
 	if (boot_cpu_has(X86_FEATURE_TOPOEXT)) {
-		int err;
 		u32 eax, ebx, ecx, edx;
 
 		cpuid(0x8000001e, &eax, &ebx, &ecx, &edx);
 
-		c->cpu_die_id  = ecx & 0xff;
-
 		if (c->x86 == 0x15)
 			c->cu_id = ebx & 0xff;
 
-		if (c->x86 >= 0x17) {
-			c->cpu_core_id = ebx & 0xff;
-
-			if (smp_num_siblings > 1)
-				c->x86_max_cores /= smp_num_siblings;
-		}
-
 		/*
-		 * In case leaf B is available, use it to derive
-		 * topology information.
+		 * If the extended topology leaf 0xb leaf doesn't exits,
+		 * derive CORE and DIE information from the 0x8000001e leaf.
 		 */
-		err = detect_extended_topology(c);
-		if (!err)
-			c->x86_coreid_bits = get_count_order(c->x86_max_cores);
+		if (!has_extended_topology) {
+			c->cpu_die_id  = ecx & 0xff;
+
+			if (c->x86 >= 0x17) {
+				c->cpu_core_id = ebx & 0xff;
+
+				if (smp_num_siblings > 1)
+					c->x86_max_cores /= smp_num_siblings;
+			}
+		}
 
 		cacheinfo_amd_init_llc_id(c, cpu);
 

base-commit: fe9731e100041bb2cc186717bde3e05ca175623b
--

Let me know what you think.

-- 
Thanks and Regards,
Prateek


