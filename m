Return-Path: <kvm+bounces-67368-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 374F1D02564
	for <lists+kvm@lfdr.de>; Thu, 08 Jan 2026 12:16:48 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 703FD31DDBB4
	for <lists+kvm@lfdr.de>; Thu,  8 Jan 2026 11:07:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BB12A3DA7F4;
	Thu,  8 Jan 2026 10:33:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="MdX+oJmE"
X-Original-To: kvm@vger.kernel.org
Received: from CO1PR03CU002.outbound.protection.outlook.com (mail-westus2azon11010041.outbound.protection.outlook.com [52.101.46.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B4A7A3D5D91
	for <kvm@vger.kernel.org>; Thu,  8 Jan 2026 10:33:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.46.41
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767868407; cv=fail; b=NyFuzv890+mSMgkA58tVzGVEvvXFsFIoVckIqvaj43Ft9v8Pf2r8RcEji487YAFaJpnH8LD2Ur3OI7VRe/xsVNiluWxxq96DVZd4CoopiMSTq/sUOdwhySOQFpRzinCxyTIK0Wywz7Y9nXtqAa+qdoXlUYyfkbzL87XIp02AsTk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767868407; c=relaxed/simple;
	bh=pKM0baxLivq48Sco0V1d08vji85RFzm6n06tNom5g8s=;
	h=Message-ID:Date:MIME-Version:Subject:To:CC:References:From:
	 In-Reply-To:Content-Type; b=EPndMulGV8wBKZ8XLq/Znz4f4ICTXGLgNlbmb5YhpNrjfvz8Ta8+j6cU3HUpWXBAfGr7HzbyO3HOGqmw6AVGlfQfGbdCUvEElqAVY59emZC2BChZ69lIAkH8cgGuKJnm++EWfUbuEgcMR+5wnMCaypCNiocbg7LNnFE/adh4YLI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=MdX+oJmE; arc=fail smtp.client-ip=52.101.46.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Pbs8zvxX0HYHGz1AGOyuubl/6B2B8tOqsWL9ZzDt6LjSKXhvKd3Ijfk7aao6+fbn+3+LDBJN5Rg0YuVYKgKrfns6/zWKA0qYEtJm7KaKwompdAJ+tVKhnAWLU2dAIcq7gPkUvaQsTJDRzxljk//nNx0TuDG+jX9Qv4HX0TN/OycAg80eHpGubKQNEMdHCCwuJXLV2lR4NvCgAi83DTqgV5x8JMww3Sg7lNvb/fXs/UnwXWx944UyxNm5cQj6X8FB0XdqG9OhlWddQeSDsr74OPRCTEkpG5x4oxG0VfqBSOFspLAp8ytyAWHoWWiwcd2ZDbWmr6yec2fWW+jD7iLZ4g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=FXyrCU8G+78vVYue4sPBuq8Ep9e9JK5JSwB4uC2p26c=;
 b=Tm9i410xsH2ryn2K3c+pqJyM+ZHuIxr2jt8Ino6+jt/y1Mtd8yKwmluDxn55Dd73cawqZxczXGBhdpNUKyGxCKzhXO6psYJzG6V7MLywG+PeGnP+quUE1RKVJ7KdRbl1nVqcjGNaG3UrI5jK3Tai6w6jIuZMdkiZXfgPufU32GFQE9U3AwvQBSTBWnQVEYCIXFPsLzhIG2UYeGY35PklInOokGu8/f7nhkdjZrPK2iYcX32cVY9vGSHUpripXzgV53e20bYhLQgB74uPSwZ5laU49j0yzyj2bx/nVvBkHZuwk83gn3gvU/tLQsSio9yNdQ9BFbJ3BPzqirvzQXivrA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=intel.com smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=FXyrCU8G+78vVYue4sPBuq8Ep9e9JK5JSwB4uC2p26c=;
 b=MdX+oJmEq/lzwa+yWxeYuPHQWfCzRZy2H36Vs13OGvl4jgOLytZZYaZpsdJfsEmCfGhZf4EbdcZB+YAzJuWGeVsKN+QFfmAdrbtcdD71r2C2Aiu7wLM7gOZHwrg7JvqspR/hUuSUGs7mPCNdaMu9q/1AvEy2pkX9W+EiNP3o9co=
Received: from BL1PR13CA0189.namprd13.prod.outlook.com (2603:10b6:208:2be::14)
 by DS7PR12MB8322.namprd12.prod.outlook.com (2603:10b6:8:ed::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9499.3; Thu, 8 Jan
 2026 10:33:16 +0000
Received: from BL6PEPF0001AB55.namprd02.prod.outlook.com
 (2603:10b6:208:2be:cafe::80) by BL1PR13CA0189.outlook.office365.com
 (2603:10b6:208:2be::14) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9499.2 via Frontend Transport; Thu, 8
 Jan 2026 10:33:16 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb07.amd.com; pr=C
Received: from satlexmb07.amd.com (165.204.84.17) by
 BL6PEPF0001AB55.mail.protection.outlook.com (10.167.241.7) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9520.1 via Frontend Transport; Thu, 8 Jan 2026 10:33:16 +0000
Received: from satlexmb07.amd.com (10.181.42.216) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.17; Thu, 8 Jan
 2026 04:33:16 -0600
Received: from [10.85.34.88] (10.180.168.240) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server id 15.2.2562.17 via Frontend
 Transport; Thu, 8 Jan 2026 02:33:13 -0800
Message-ID: <eb712000-bc67-468a-b691-097688233659@amd.com>
Date: Thu, 8 Jan 2026 16:03:12 +0530
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/5] i386: Implement CPUID 0x80000026
To: Zhao Liu <zhao1.liu@intel.com>, Shivansh Dhiman <shivansh.dhiman@amd.com>
CC: <pbonzini@redhat.com>, <mtosatti@redhat.com>, <kvm@vger.kernel.org>,
	<qemu-devel@nongnu.org>, <seanjc@google.com>, <santosh.shukla@amd.com>,
	<nikunj.dadhania@amd.com>, <ravi.bangoria@amd.com>, <babu.moger@amd.com>
References: <20251121083452.429261-1-shivansh.dhiman@amd.com>
 <20251121083452.429261-2-shivansh.dhiman@amd.com>
 <aV4KVjjZXZSB5YGw@intel.com>
Content-Language: en-US
From: Shivansh Dhiman <shivansh.dhiman@amd.com>
In-Reply-To: <aV4KVjjZXZSB5YGw@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL6PEPF0001AB55:EE_|DS7PR12MB8322:EE_
X-MS-Office365-Filtering-Correlation-Id: d6df3641-5e7d-438f-e66f-08de4ea15577
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|82310400026|36860700013|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?WDltTkdWSU1US0s4ZGVTV1pCWUtlbGpzM0VPL0tKVE1YamJ1aHUvbzhUbko1?=
 =?utf-8?B?azJmT0hLODljb2ZnQWRidWJreEVzajl6TThIUFZRTzkvOEordGJaL1FXVlZJ?=
 =?utf-8?B?Z0pYWGszYUtPd1lSSHY1VytoK3lVYXNCdFEyOWs3VFl5K1pRc1k3YndyVkRt?=
 =?utf-8?B?WGltMXR3dThVQVpkM21YRmNMYVVmempNSytpVjN5ZXVTS2psWlpTK0QwOE40?=
 =?utf-8?B?cHpscWVHQjFWVm1hekVPOGovVnViTmZKSStVRFM5Q0VsSGVCTDlidE1iMlRC?=
 =?utf-8?B?elc4Sk95a3NwT1Z2Q2IzeW1zWmE0bndTZEhwQWVsYnVmU2RjeTBJRXovcXdC?=
 =?utf-8?B?dWF5VFhYRFc4dWJrYkFWVW50eUxXcTg3YzBWN0h0NEVBM2hBbG1PR3R0Zlli?=
 =?utf-8?B?eEErNzVhS1pVQm45NE0rVjIwVVBWMmdyckgxTkxMb2Zib1lXaGV6VDZ4M1dj?=
 =?utf-8?B?Z3pOR2lrZ1BxY3BTK3dScjZIbnI3OWlDUjNBbmduWWN4NkZUTWprNjB0L2dx?=
 =?utf-8?B?eWsrYWNXSzEvZWhaL3VqT2JzeXorUG1Eb09peHBocWwzekQ1ZHJpNng0SFJD?=
 =?utf-8?B?NGQvL3krbnYwTmV1bFNjRithYUtXT0tKTEdORHErRENXVnlpdGFBQWhDdGJ4?=
 =?utf-8?B?bXo5TnJSR25jQlNIdHQveU8vSXlwWTVpN25hYk9Va2Y5TllnNWk3TmY0SThC?=
 =?utf-8?B?Q3hYNVJMd3FzT2hCVGdmdkUxTlUwWGJzNXQremtHR3hGY1BMZVNJRm5CWGky?=
 =?utf-8?B?YTd2dnZLWnRZVXFFbzk0emMvY0xGZmNKYUF3TUxGUFFHczJTVEVKYW0zaUxU?=
 =?utf-8?B?N0l0RXZtZjZQUjN4eVF6M05laXV6Wmd1dE5WeDV1Y3dyd0xCT1ZjYk05MElZ?=
 =?utf-8?B?NUl1UW1MTzVQeHlqcmY5ZWhSSmxmc3FGWWVWMU5SanVmNVJIZ2JCR0Vvdlc2?=
 =?utf-8?B?ZlovdEZRYUoyVEJGWjRXL3FZOXNlS1lRL3pjRGtRcW1leklmQTc2NW1aZ0Jx?=
 =?utf-8?B?TWpmNFpRUk5WYWdkZkQyVEZ2cEMxcnFMcHRlUzlIWVlFdFE1R2VFNW1abjZ0?=
 =?utf-8?B?cjJ1VjgzZ0tGdTRscnVURDArRGMwcXVUSU9sK0hMMEJvQ0Jpckl0T0hJbXEw?=
 =?utf-8?B?K2phWCtKOEUyZUJ6K215bE94eW5tb2gvRDRUQmxOY2VSU3hlYXhab0VyZTR3?=
 =?utf-8?B?cFcvcFh6Y200OWkzZ2gyOHhZYUd5b1NKSTdRM0VoTUxPb1FteFlybi9NdE0r?=
 =?utf-8?B?QjI1Y08veEU3cEhocWZCUHJxcXdJY2JQOVJxQmFlSzFxdWZ1WHBoWTJiREFm?=
 =?utf-8?B?b21hNGp4UGxyS0xIWEJ5S2JzZkhrS3drTW15eDUrUldGQ0NQSjUyWHNma21I?=
 =?utf-8?B?Q0FzanZsVnVrblhSOThXTmhBRUJSWVhtYisrRDFlQkI1Tm9QWTdXTWkyZFRo?=
 =?utf-8?B?VEhBb25rYkI4REtkYTY2Ukl5UGlsa29kNXdzS0RKb3JrYjFhVlB6TGlYWDFB?=
 =?utf-8?B?c25jNGN5a01nUDBJbmIrMzJSeUtMYkMxZng5Qk1IZ0xFK1FZK2tsL3gzZG5W?=
 =?utf-8?B?WEp0YUZGaytlV0ZwSzVXVWFpMXE5dVhmdlNrM1pIWktYUWhadmd0eDFUQVps?=
 =?utf-8?B?TEdTZU9QeUticC9kelExZ2VWK1VkcjZYc1dPYitLMmNmYlZTVXBGRlNDdEp1?=
 =?utf-8?B?WFZPdmdtK1JuL01iYnlHZnA5Zi9QZVRvR1dtMk1xazBKdGxXWkRCZkJ4UURk?=
 =?utf-8?B?S3poTXltWTl1ZXFpRytydWlpcmlhVEJKWlZMUXJxR0ZMVDY5aWVybFFNOTRh?=
 =?utf-8?B?Q1VJbktFSlNEbmlVMHVqUUN4RG9NT0Eyc25VZ04rM00xdmhuYWFVcmpMRFBJ?=
 =?utf-8?B?NVd2bnRXT0ZQYnVSSm9wM1djT0ZPSC91MG01K3hvY3NBMFdMeWFVTFNDMnZr?=
 =?utf-8?B?TUUxbG1WOUJ6eHpEdklqVjI4RlVTTEF1c1diWUZGdGhKaU9EWFZpSiszeUJD?=
 =?utf-8?B?NHFXdkpmaWpRT1NIOHRJbkdVOEpZUUY0Y3dzVndhT2dVdzhGUFVGTzZCWlJ0?=
 =?utf-8?B?UCtzekFKQzNRNXhyQUF1Rk5OVllTNFB3clM4RXlDS3BlNTNxZFB5TWtCeTNB?=
 =?utf-8?Q?oz7Y=3D?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:satlexmb07.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(376014)(82310400026)(36860700013)(1800799024);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Jan 2026 10:33:16.3455
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: d6df3641-5e7d-438f-e66f-08de4ea15577
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb07.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BL6PEPF0001AB55.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR12MB8322

Hi Zhao,

On 07-01-2026 12:55, Zhao Liu wrote:
> Hi Shivansh,
> 
> Sorry for late reply.
> 
> On Fri, Nov 21, 2025 at 08:34:48AM +0000, Shivansh Dhiman wrote:
>> Date: Fri, 21 Nov 2025 08:34:48 +0000
>> From: Shivansh Dhiman <shivansh.dhiman@amd.com>
>> Subject: [PATCH 1/5] i386: Implement CPUID 0x80000026
>> X-Mailer: git-send-email 2.43.0
>>
>> Implement CPUID leaf 0x80000026 (AMD Extended CPU Topology). It presents the
>> complete topology information to guests via a single CPUID with multiple
>> subleafs, each describing a specific hierarchy level, viz. core, complex,
>> die, socket.
>>
>> Note that complex/CCX level relates to "die" in QEMU, and die/CCD level is
>> not supported in QEMU yet. Hence, use CCX at CCD level until diegroups are
>> implemented.
> 
> I'm trying to understand AMD's topology hierarchy by comparing it to the
> kernel's arch/x86/kernel/cpu/topology_ext.c file:
> 
> static const unsigned int topo_domain_map_0b_1f[MAX_TYPE_1F] = {
> 	[SMT_TYPE]	= TOPO_SMT_DOMAIN,
> 	[CORE_TYPE]	= TOPO_CORE_DOMAIN,
> 	[MODULE_TYPE]	= TOPO_MODULE_DOMAIN,
> 	[TILE_TYPE]	= TOPO_TILE_DOMAIN,
> 	[DIE_TYPE]	= TOPO_DIE_DOMAIN,
> 	[DIEGRP_TYPE]	= TOPO_DIEGRP_DOMAIN,
> };
> 
> static const unsigned int topo_domain_map_80000026[MAX_TYPE_80000026] = {
> 	[SMT_TYPE]		= TOPO_SMT_DOMAIN,
> 	[CORE_TYPE]		= TOPO_CORE_DOMAIN,
> 	[AMD_CCD_TYPE]		= TOPO_TILE_DOMAIN,
> 	[AMD_SOCKET_TYPE]	= TOPO_DIE_DOMAIN,
> };

These mappings reuse some original names (SMT_TYPE and CORE_TYPE) along with the
new ones (AMD_CCD_TYPE and AMD_SOCKET_TYPE). I think to avoid defining more AMD
specific types the original names are used. So, essentially you can read them
like this:

static const unsigned int topo_domain_map_80000026[MAX_TYPE_80000026] = {
	[AMD_CORE_TYPE]		= TOPO_SMT_DOMAIN,
	[AMD_CCX_TYPE]		= TOPO_CORE_DOMAIN,
	[AMD_CCD_TYPE]		= TOPO_TILE_DOMAIN,
	[AMD_SOCKET_TYPE]	= TOPO_DIE_DOMAIN,
};

> 
> What particularly puzzles me is that "complex" isn't listed here, yet it
> should be positioned between "core" and CCD. Does this mean complex
> actually corresponds to kernel's module domain?

There is a nuance with CPUID 80000026h related to the shifting of x2APIC ID.
According to APM, EAX[4:0] tells us the number of bits to shift x2APIC ID right
to get unique topology ID of the next instance of the current level type.

So, all logical processors with the same next level ID share current level. This
results in mapping the Nth level type to (N-1)th domain. This is unlike Intel's
CPUID 0xb which maps Nth level type to Nth domain.

Back to your question, the complex is same as tile since both represent a L3
cache boundary.

> 
> Back to QEMU, now CCX is mapped as QEMU's die level, and AMD socket is mapped
> to socket level. Should we revisit QEMU's topology level mapping for AMD, to
> align with the above topology domain mapping?
> 
> If we want to go further: supporting CCD configuration would be quite
> tricky. I feel that adding another new parameter between the smp.dies
> and smp.sockets would create significant confusion.

The current kernel doesn't have sensitivity to a level between L3 boundary and
socket. Also, most production systems in current AMD CPU landscape have CCD=CCX.
Only a handful of models feature CCD=2CCX, so this isn't an immediate pressing need.

In QEMU's terminology, socket represents an actual socket and die represents the
L3 cache boundary. There is no intermediate level between them. Looking ahead,
when more granular topology information (like CCD) becomes necessary for VMs,
introducing a "diegroup" level would be the logical approach. This level would
fit naturally between die and socket, as its role cannot be fulfilled by
existing topology levels.

Also, I was looking at Intel's SDM Vol. 2A "Instruction Set Reference, A-Z"
Table 3-8. "Information Returned by CPUID Instruction". The presence of a
"diegrp" level between die and socket suggests Intel has already recognized the
need for this intermediate topology level. If this maps to a similar concept as
AMD's CCD, it would indeed strengthen the case for introducing a new level in QEMU.

> 
>> Signed-off-by: Shivansh Dhiman <shivansh.dhiman@amd.com>
>> ---
>>  target/i386/cpu.c     | 76 +++++++++++++++++++++++++++++++++++++++++++
>>  target/i386/kvm/kvm.c | 17 ++++++++++
>>  2 files changed, 93 insertions(+)
>>
>> diff --git a/target/i386/cpu.c b/target/i386/cpu.c
>> index 641777578637..b7827e448aa5 100644
>> --- a/target/i386/cpu.c
>> +++ b/target/i386/cpu.c
>> @@ -495,6 +495,78 @@ static void encode_topo_cpuid1f(CPUX86State *env, uint32_t count,
>>      assert(!(*eax & ~0x1f));
>>  }
>>  
>> +/*
>> + * CPUID_Fn80000026: Extended CPU Topology
>> + *
>> + * EAX Bits Description
>> + * 31:5 Reserved
>> + *  4:0 Number of bits to shift Extended APIC ID right to get a unique
>> + *      topology ID of the current hierarchy level.
>> + *
>> + * EBX Bits Description
>> + * 31:16 Reserved
>> + * 15:0  Number of logical processors at the current hierarchy level.
>> + *
>> + * ECX Bits Description
>> + * 31:16 Reserved
>> + * 15:8  Level Type. Values:
>> + *       Value   Description
>> + *       0h      Reserved
>> + *       1h      Core
>> + *       2h      Complex
>> + *       3h      Die
>> + *       4h      Socket
>> + *       FFh-05h Reserved
>> + * 7:0   Input ECX
>> + *
>> + * EDX Bits Description
>> + * 31:0 Extended APIC ID of the logical processor
>> + */
> 
> I feel this long comment is not necessary, since people could check APM for
> details. Or this description could be included in commit message.

Sure. Will do. Thanks.

> 
>> +static void encode_topo_cpuid80000026(CPUX86State *env, uint32_t count,
>> +                                X86CPUTopoInfo *topo_info,
>> +                                uint32_t *eax, uint32_t *ebx,
>> +                                uint32_t *ecx, uint32_t *edx)
> 
> Regards,
> Zhao
> 


