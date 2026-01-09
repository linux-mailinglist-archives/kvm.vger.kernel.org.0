Return-Path: <kvm+bounces-67542-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 5BBC8D080EB
	for <lists+kvm@lfdr.de>; Fri, 09 Jan 2026 10:03:31 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 3BAB93047180
	for <lists+kvm@lfdr.de>; Fri,  9 Jan 2026 09:01:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AA5E832861C;
	Fri,  9 Jan 2026 09:01:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="hfK79jKJ"
X-Original-To: kvm@vger.kernel.org
Received: from DM1PR04CU001.outbound.protection.outlook.com (mail-centralusazon11010044.outbound.protection.outlook.com [52.101.61.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 69AFA32938B
	for <kvm@vger.kernel.org>; Fri,  9 Jan 2026 09:01:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.61.44
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767949274; cv=fail; b=nY7WMaOjSqAz1oxUso7PLpDBP2/AmjOtn5B2S3Wj5b0QB25+aPmFmz7F2CEFZW/NWkoJ9/WNcwInXTqlppbvOM4T8PDycsx9nJh9zny567fJU13rRGb7zIDh+lY2ouUFNH9A5Tkm6/idR121XCFFcDqwJ6RYIyNA32bHxe/FfEA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767949274; c=relaxed/simple;
	bh=OPZl+cgQNMfvuqItfsshtMslWG+G5ydF1nMAmvAzGjs=;
	h=Message-ID:Date:MIME-Version:Subject:To:CC:References:From:
	 In-Reply-To:Content-Type; b=BoA9aQ2cZhJyMOHQG/ZDC4Bs/rcRq9WiGHP+BuwQztYQ0AafPLuP4tWs3J8ooaTs5m0XRNOnZUJt53nUwFyRiLu8kYrZiC04JtL4vBHE5T80+Ii67C04DpMxqiM0M/bhwbNG57bReLMqk+KZQ5a0G/oC6PIUYjUqs1tuhQwb+I0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=hfK79jKJ; arc=fail smtp.client-ip=52.101.61.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=yDVKSO0g1DQ36lHgYs7wEqOINNOKhGB4rFlNoynEDROdqmkc+pgNVwaINSbbblesyjt/IYiAULkOxirC/273AtaPCo/o9c550KO7qoW307w6HEgOOYXX2UXoTLLkKajgdoEcC1Ux1hez77koM1reD3Yf4wvxBhjV7fEXo1q1/jIj0Z84z37nxuZN5C7fPPXBULun1Nqid89GChQbCKmoQrxzj6XPczXKfNL+geWMXkAsfTDtxbhg4y2MOOxw9vm/+m+LFP48vVwJp0wWMsN0sVGZwtji2mQ7GQpTRlw1X2DRil8a2zhvdwqxqL4JeX4g6RJ6aw5o2Vf2ojNYkIU7ZA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=WYm+OHDA8CRZZcDcwlyqzPzA4uoexBzNbmosm2g7bII=;
 b=y6g8KY5cccQqpq2h0Y2nFwmBqpTCeh/95DHwJ5Olvdm2g4XeYeMSvHdMQ8g96/fm8xweffi4D66PHIy3805LNbQ2+AOqVQjg+EpmQ4bMmzj8tVy+qih2/H5RMpqp/2EWDMx2xoTGzEo9j1ythVmixibOfkC3k9OwGLLzw1kNpuFi4YQnR3EgxbZ3iaQcH3IBg29uilfYu5vzbzHjWW4efarWMEmWjOHaY7cOi7vRcZ1y+jOfblq1ZsLX99Sx6QvYSLrtSDe6UGTuo/oIacGdO0lQAdOwqnVDZfTaBbwnVPHScKgkcRBugthWa6xkIzj1JYdD6g+M1GBMWXSFC7A2YQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=intel.com smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=WYm+OHDA8CRZZcDcwlyqzPzA4uoexBzNbmosm2g7bII=;
 b=hfK79jKJNKyCrCsU3Ma29c3tHVIaSzhSWDpWmwGfoOmAN9tMfWd4onTbweK6rP00n3a+ws+ELPZaYJnfkS6srYD37+uiTf3R1ByfjEddjxzSGCL0nOSSJpZrDJRs4j95yoj1rnIrkfu19Vs0sLXIuJkuTYcuaJl5uzcCM7qm4WY=
Received: from DS0PR17CA0024.namprd17.prod.outlook.com (2603:10b6:8:191::29)
 by MW4PR12MB5602.namprd12.prod.outlook.com (2603:10b6:303:169::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9499.2; Fri, 9 Jan
 2026 09:01:02 +0000
Received: from DS2PEPF00003445.namprd04.prod.outlook.com
 (2603:10b6:8:191:cafe::80) by DS0PR17CA0024.outlook.office365.com
 (2603:10b6:8:191::29) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9499.5 via Frontend Transport; Fri, 9
 Jan 2026 09:01:02 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb07.amd.com; pr=C
Received: from satlexmb07.amd.com (165.204.84.17) by
 DS2PEPF00003445.mail.protection.outlook.com (10.167.17.72) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9520.1 via Frontend Transport; Fri, 9 Jan 2026 09:01:01 +0000
Received: from SATLEXMB04.amd.com (10.181.40.145) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.2.2562.17; Fri, 9 Jan
 2026 03:01:00 -0600
Received: from satlexmb07.amd.com (10.181.42.216) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Fri, 9 Jan
 2026 03:01:00 -0600
Received: from [10.136.45.190] (10.180.168.240) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server id 15.2.2562.17 via Frontend
 Transport; Fri, 9 Jan 2026 01:00:56 -0800
Message-ID: <8ef42171-5473-449f-bd72-e9874fa6f7f1@amd.com>
Date: Fri, 9 Jan 2026 14:30:56 +0530
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 2/5] i386: Add CPU property x-force-cpuid-0x80000026
To: Zhao Liu <zhao1.liu@intel.com>, Shivansh Dhiman <shivansh.dhiman@amd.com>
CC: <pbonzini@redhat.com>, <mtosatti@redhat.com>, <kvm@vger.kernel.org>,
	<qemu-devel@nongnu.org>, <seanjc@google.com>, <santosh.shukla@amd.com>,
	<nikunj.dadhania@amd.com>, <ravi.bangoria@amd.com>, <babu.moger@amd.com>
References: <20251121083452.429261-1-shivansh.dhiman@amd.com>
 <20251121083452.429261-3-shivansh.dhiman@amd.com>
 <aV4PgVwYVXHgmCi3@intel.com>
Content-Language: en-US
From: Shivansh Dhiman <shivansh.dhiman@amd.com>
In-Reply-To: <aV4PgVwYVXHgmCi3@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Received-SPF: None (SATLEXMB04.amd.com: shivansh.dhiman@amd.com does not
 designate permitted sender hosts)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS2PEPF00003445:EE_|MW4PR12MB5602:EE_
X-MS-Office365-Filtering-Correlation-Id: 0052be78-94ed-4e74-e3f5-08de4f5d9d4a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|36860700013|376014|82310400026;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?K0ZXcWlDc2tRSUJxVmhkMW1ia1lUR2UzRjlnazh6d1RQS0s2N2JiNkEvYUR1?=
 =?utf-8?B?bG9Ma0srMVRzb3hSeHlvTzlFQnVzaVNNdzRLVHI5TVZrQnhGYnlmS08xYVo4?=
 =?utf-8?B?V3V2QUliRUV3UHdLelhBd1NKcWZyYitDMXQ5NTFNSC91R1FnSUZYSkYxcEFK?=
 =?utf-8?B?QXU2VWNIYXpnS3ZGU2FZOEYrTW5sdC9qY3o3NS9lVDY5b0hXQ0lBOUo5RTF1?=
 =?utf-8?B?L2ViL0R0d3Z1S3FHZUxiWFhnTnNvWUtGOEJld1cvZXl3T0dyRDhYcjNCdjhJ?=
 =?utf-8?B?T1ErK1dsbzRjSXpqbEo5MjIyNjRTTWdmdFV4R2hYT0IzaUpyMG9nL3ZsUFNO?=
 =?utf-8?B?UGcyeGhUV3BIN3ExdEJyNzJTR2tDMnd2MTA3UVNlL0RtMUhjYUlZK01LTzNu?=
 =?utf-8?B?UWpFMUFuamoycWtXQnFUM1hRcUUxeXJuMzVtWUFmaXExQ25LSGx4cUZaVXZy?=
 =?utf-8?B?UVZENjhYdFNmNzBmNytTTC9FUDN0VTBGNm13UDJEYWd1ZWthWkR5eTIvVDB2?=
 =?utf-8?B?d1RzWDBGSndDanJTYVMwdHNXU0hYTmlQdTdJTXZWOXZTK1RzekRwWXN3Q1M1?=
 =?utf-8?B?cWxMb1BvUjVlTEhBbVFyWFA5bmZEVWlXZlQwYzFkOVNKZmhFaVlBWVBLa0NT?=
 =?utf-8?B?NXdPZktSTHhDQ2czSldQUzlIS1dkVHh3VjBhcFc1VzJmZGs3ZjhGaVhrbmpr?=
 =?utf-8?B?SUF2QTVneDlxR1l5bng5RkVaTkMyK2o0dWJuU0Irc1grV1pjU2lmb0M4N09V?=
 =?utf-8?B?S1ZUN3RjUWhyem43WlhOK05oNFQ0UTQwZjY4bmVPdGN4U2ZpeXdXNGRpYlk4?=
 =?utf-8?B?WllhQnNZbTBNTWRSeXdYcGxuS0VEblRkN1Q4L0hzNVFiK0E1eUQzb0gzbXVH?=
 =?utf-8?B?VUFiTDUwZldGS203bXdIVFk2VnU2U3RDMDlVVXc1V1B4WTc0d2JZVkdYVTgv?=
 =?utf-8?B?TmR4QWwyZU1ZZm5tL3ZnbVB0OG93SDd0VEVLOWNRdnFITlJPanh2bUFVc25U?=
 =?utf-8?B?T28yTmpvVGE5bzViVGN2SFV6NTh3OVA5Z1ljallRd1V3Mi95N1FiLzlnK3FZ?=
 =?utf-8?B?TkhWVmhTekU2d1NWS3pUc09PaXJxUGhUeEhYTDVPcHk5MGNWbU1hYjc5cGVw?=
 =?utf-8?B?VEw2N0FVZ1BVZTZJUXhuTXBoTmxmQllIOWdCdk5VcUUwcVY1V0tiMk1WZmtK?=
 =?utf-8?B?dW9xWXFGeXZzZjNHcnJhYjhaY2R2K0NzT2N3MEN0RDIvSUsya0pWRGt2aS9O?=
 =?utf-8?B?WGdSVk1mSkJWMG43NXJ3anJEbElDSXVoMXdRUUNaK1dGdVR3YWRQaER5ejRE?=
 =?utf-8?B?Y3BzQm40T3lDOVJJc3hROXVPa2VySFJSYUVoVlJxRVZBblZ1L3dtajVHRmRQ?=
 =?utf-8?B?d1Y5M0Yzc0dnTUVUcVBvNXNhb2MweDdpNGdCR1VlWU4rWTBHanYvazBpSklp?=
 =?utf-8?B?UkR5S0sxY0tVdEhZRnI5MURYdXFvTEVDT2ZpeDZaM0psY3lpeEE0NGxCak1Z?=
 =?utf-8?B?U0oxai9CbzFsb0JZVWZ0OUlMclFZZXZxelFnU0dLT2xMdFB3TmRSK3c4UjF4?=
 =?utf-8?B?VUp0UEhYZnNqMXFreVdnR3V0WVlHaDdXRFhGS1RqTjEyK2tKQzVRM2dPRXk0?=
 =?utf-8?B?TFZPMG01OFk0Q3lBeWdVakRETGtFTHh2a1BMdmVDRW5RZ0Y1MC92L2gxUkp0?=
 =?utf-8?B?Vjlad3hMazdKOEg1b0FPbzUrL3hyMGhuS05ERy9xeERPRnhwRDgyZnZ0ZXB5?=
 =?utf-8?B?ZkFRSHlQRjNLVDFPbVJxTUJuNHNRT0Q4K2VKUVZwbm5wN2F3alJFS3lwWkF1?=
 =?utf-8?B?aHB6R2Q1dVVGMGxhREh4OUNRSzBlUTBKbkhyWHdlYTVNRkk3UnYxK29DRkZO?=
 =?utf-8?B?VU8wYVJpMElLc2NDc2xadys3WGQxYWl3Zk9pYlNmTEJFeHE5YW9RWHVSdkdh?=
 =?utf-8?B?Sm55UmFNcWtDWHQyWFhaWVRSYXI2Y2NXbmJuSGczMEp1WUh4VERQbmMxUHpC?=
 =?utf-8?B?bFA3R052dVRHK21mY3JiMUxkWHk3U0dNaE5YejRMZHE0R3VIdW9aeTYzRTZC?=
 =?utf-8?B?SGkxc0J6U2tpRzJVNGpnVy9NeXA5TWZhUk96Yjd6d1BTZHVBK2RWWHdFNFBL?=
 =?utf-8?Q?RhFE=3D?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:satlexmb07.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(1800799024)(36860700013)(376014)(82310400026);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Jan 2026 09:01:01.9747
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 0052be78-94ed-4e74-e3f5-08de4f5d9d4a
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb07.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DS2PEPF00003445.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR12MB5602

Hi Zhao,

On 07-01-2026 13:17, Zhao Liu wrote:
> On Fri, Nov 21, 2025 at 08:34:49AM +0000, Shivansh Dhiman wrote:
>> diff --git a/target/i386/cpu.c b/target/i386/cpu.c
>> index b7827e448aa5..01c4da7cf134 100644
>> --- a/target/i386/cpu.c
>> +++ b/target/i386/cpu.c
>> @@ -9158,6 +9158,12 @@ void x86_cpu_expand_features(X86CPU *cpu, Error **errp)
>>          if (env->features[FEAT_7_0_EBX] & CPUID_7_0_EBX_SGX) {
>>              x86_cpu_adjust_level(cpu, &env->cpuid_min_level, 0x12);
>>          }
>> +
>> +        /* Enable CPUID[0x80000026] for AMD Genoa models and above */
>> +        if (cpu->force_cpuid_0x80000026 ||
>> +            (!xcc->model && x86_is_amd_zen4_or_above(cpu))) {
> 
> I understand you want to address max/host CPU case here, but it's still
> may not guarentee the compatibility with old QEMU PC mahinces, e.g.,
> boot a old PC machine on v11.0 QEMU, it can still have this leaf.

Wouldn't initializing x-force-cpuid-0x80000026 default to false prevent this?
Oh, but, this CPUID can still be enabled on an older machine-type with latest
QEMU with the existing checks. And probably this could also affect live migration.

> 
> So it would be better to add a compat option to disable 0x80000026 for
> old PC machines by default.

Does this look fine?

GlobalProperty pc_compat_10_2[] = {
    { TYPE_X86_CPU, "x-force-cpuid-0x80000026", "false" },
};
const size_t pc_compat_10_2_len = G_N_ELEMENTS(pc_compat_10_2);


> 
> If needed, to avoid unnecessarily enabling extended CPU topology, I think
> it's possible to implement a check similar to x86_has_cpuid_0x1f().

Do you mean something like this? I avoided it initially because it is
functionally same as current one, and a bit lengthy.

/* Enable CPUID[0x80000026] for AMD Genoa models and above */
static inline bool x86_has_cpuid_0x80000026(X86CPU *cpu) {
    X86CPUClass *xcc = X86_CPU_GET_CLASS(cpu);
    return cpu->force_cpuid_0x80000026 ||
	(!xcc->model && x86_is_amd_zen4_or_above(cpu));
}

...

if (x86_has_cpuid_0x80000026(cpu))
    x86_cpu_adjust_level(cpu, &env->cpuid_min_xlevel, 0x80000026);


Thanks for the review.
Shivansh

> 
>> +            x86_cpu_adjust_level(cpu, &env->cpuid_min_xlevel, 0x80000026);
>> +        }
>>      }
> 
> Thanks,
> Zhao
> 


