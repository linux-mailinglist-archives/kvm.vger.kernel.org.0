Return-Path: <kvm+bounces-69336-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id QEyULxrxeWnT1AEAu9opvQ
	(envelope-from <kvm+bounces-69336-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Wed, 28 Jan 2026 12:20:58 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 0FFD4A036D
	for <lists+kvm@lfdr.de>; Wed, 28 Jan 2026 12:20:58 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id A448D303FFEA
	for <lists+kvm@lfdr.de>; Wed, 28 Jan 2026 11:19:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D016733DEF7;
	Wed, 28 Jan 2026 11:19:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="jLnNsach"
X-Original-To: kvm@vger.kernel.org
Received: from CO1PR03CU002.outbound.protection.outlook.com (mail-westus2azon11010054.outbound.protection.outlook.com [52.101.46.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 57FF72FD697
	for <kvm@vger.kernel.org>; Wed, 28 Jan 2026 11:19:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.46.54
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769599194; cv=fail; b=HsfJNNq+DGV+iXmUI+X2ZL12Jkqw7+407XbnFA/SzUgcvpPcaQIPaJwUhuXUJaNdw+YATArZxxfPCTKCtE9Gmrnmj9e4+6mg3FaRrpsnYJc0C8nDvrFOiLQ9Dmw+IS6EZIRqjORlIzX46kbYNnWModcXP84U7uVRSurV2IGPaus=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769599194; c=relaxed/simple;
	bh=g3q6I3UTANsPPTGcTNkVyG/YdBWqEdiTzxRDtMXriTE=;
	h=Message-ID:Date:MIME-Version:Subject:To:CC:References:From:
	 In-Reply-To:Content-Type; b=rDC/GYpmWmF+lvotLEHYHucijP/LPYIuO2jNtBVaX/m3hmCbwsP+yZQruXla2tKnxWqb+Y8bf5pK7mpjZUFZQ3cUaL4yeGhM29enkY+lq99HspUnrG2h30WOe3XpNW9znjmZF1R0JotTt6H6KmyLSw8+sZwE14BUCeQsvqlqJVI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=jLnNsach; arc=fail smtp.client-ip=52.101.46.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=C8k4fYWm4L5wJgdkIxPoTsZNRehChATWWz7cIKufn1GGM5YsES99QhPCyb3ehsTAMA6EAw5cpGa+IcLoVcZnQhYNkAPFilG0o+9+i0YsKmNJ3aQkoB+vyN5M1CrXYgS4kMDOje4MSMdoZjZV+J0GQdlRwDLb5Ie4oICI7JprX2eqJ2V/B5LLpIrx22guzusGG1hTVpIYEK8BBvLqtbkuQati1o67JqgHbq+P9H3/9gfdJx+mNyMDjHntm1u6jgux+ilGchIdK9ZNGURfS/H8oy4z9nJ6zLVQCJzDxYlnFTZmmzPdT8FzUc4vUw9l1GYJZpd/ekv49X5+SfsmRfGQCA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=t6INM0p9r2IP6i8sUlfh5jz1XwT1/o729QvGKqs92sE=;
 b=bshEMr3ZCD3Dm3CpIs0hHKn3g1h95bJAR1Sr59bLXwySH/bFwJH73D4yL+Ph52V/IEzPtLFQ1GrGGK7vFIIW+UTuLuX76i3fHP5IPItMF5TDipjTX4JwUXtJPhr+lul+DtPgDg0xiTshOwXvDGdBCgLj7IDC3Gt7w9bLf5EhOzVqzq1uBsewE9DCdEcVntoDKDyCZeeH8g5ELl94wfMaVh+rBvj5LdHqZGCoNfWktrvD3hMlO4MKUO/OrNdUlBuNnwJ9qMSkL8wg4XcKCXPM5JI2o762LF5qcCE9ELaSUASRT561lkcyevIj/yknVK/uzH6D65FO4TwMIV4B0d+TXg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=oracle.com smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=t6INM0p9r2IP6i8sUlfh5jz1XwT1/o729QvGKqs92sE=;
 b=jLnNsachtdMaJXoRZGYCcnOnZo7hRu4WHlZV3GYA0f+0pZF9PBN3FmSS0dXAa88qTGi7MAI9vPdFTHh4OEU4uOxF6zjGm+i/8D4oy4/ajxjBQQvc42tw+aH84diDFsyP2umfTqLvjM0D9qATShd4NqQAlHfZpzTKjYlCljgBbk8=
Received: from BYAPR11CA0073.namprd11.prod.outlook.com (2603:10b6:a03:f4::14)
 by IA1PR12MB9061.namprd12.prod.outlook.com (2603:10b6:208:3ab::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9564.7; Wed, 28 Jan
 2026 11:19:47 +0000
Received: from SJ1PEPF000023D1.namprd02.prod.outlook.com
 (2603:10b6:a03:f4:cafe::32) by BYAPR11CA0073.outlook.office365.com
 (2603:10b6:a03:f4::14) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9564.7 via Frontend Transport; Wed,
 28 Jan 2026 11:19:47 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb07.amd.com; pr=C
Received: from satlexmb07.amd.com (165.204.84.17) by
 SJ1PEPF000023D1.mail.protection.outlook.com (10.167.244.7) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9564.3 via Frontend Transport; Wed, 28 Jan 2026 11:19:46 +0000
Received: from [10.252.204.230] (10.180.168.240) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.17; Wed, 28 Jan
 2026 05:19:41 -0600
Message-ID: <ef5f77ac-e633-4c68-a83f-7fa978545fad@amd.com>
Date: Wed, 28 Jan 2026 16:49:35 +0530
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH RESEND 3/5] amd-iommu: Add support for set/unset IOMMU
 for VFIO PCI devices
Content-Language: en-US
To: Alejandro Jimenez <alejandro.j.jimenez@oracle.com>,
	<qemu-devel@nongnu.org>, <kvm@vger.kernel.org>, <vasant.hegde@amd.com>,
	<suravee.suthikulpanit@amd.com>
CC: <mst@redhat.com>, <imammedo@redhat.com>, <anisinha@redhat.com>,
	<marcel.apfelbaum@gmail.com>, <pbonzini@redhat.com>,
	<richard.henderson@linaro.org>, <eduardo@habkost.net>, <yi.l.liu@intel.com>,
	<eric.auger@redhat.com>, <zhenzhong.duan@intel.com>, <cohuck@redhat.com>,
	<seanjc@google.com>, <iommu@lists.linux.dev>, <kevin.tian@intel.com>,
	<joro@8bytes.org>
References: <20251118101532.4315-1-sarunkod@amd.com>
 <20251118101532.4315-4-sarunkod@amd.com>
 <f7097f24-6c4e-42eb-a2ab-968b6814e969@oracle.com>
From: Sairaj Kodilkar <sarunkod@amd.com>
In-Reply-To: <f7097f24-6c4e-42eb-a2ab-968b6814e969@oracle.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: satlexmb08.amd.com (10.181.42.217) To satlexmb07.amd.com
 (10.181.42.216)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ1PEPF000023D1:EE_|IA1PR12MB9061:EE_
X-MS-Office365-Filtering-Correlation-Id: b1cb8048-c8b5-413e-ff14-08de5e5f250a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700013|82310400026|376014|7416014|1800799024|7142099003;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?U01LeHpESGw0MCtxOU1QUjg3L05YNzZzRTVYUzBtKzg3eDZ2cmZQVGt3bTg3?=
 =?utf-8?B?eDdzZHhXTDFaa2hodEpaZ1I3Nmw3MjM1REgxYkVrVXVTekZVV2Y5bGZVbEty?=
 =?utf-8?B?OHJ3RzRYSlc4NmxPdGNjK3lub01hbDhlcmdLQWJoTExQTmZvdDVUSTVKOSth?=
 =?utf-8?B?c1Uwb2YzenNJWkVLQXhYeW5RUmluc2JsK1RzTW9ZMU92SEo0UFhEcWtWQjky?=
 =?utf-8?B?RWhOU2FnQzJFZmRSb0RBQnpWaERFcEVLdUdpRmZQS3h1OVlweXN1YXBlSFlE?=
 =?utf-8?B?S09tc1ZmbHJ0SVBUdVdJcTB4SzRINHFUTlM2WXZFT2ZCZ2VGSmJ2NXdhZk5L?=
 =?utf-8?B?UDE4M2ZyODZ4NWN4THdmS3A2MDJ6dnRrNWdYNDhtM0V0RzRjaTZMTWxSSE1X?=
 =?utf-8?B?bFVKZUl0RTNITWtwSmx5M3pHTHppVWF4OEw0dE9ZeHZEYkNhYzdlbEdDV2tN?=
 =?utf-8?B?Skw3U3NKWCtCc0NUcXBybnZTbUtvNFVET3hzckhIYXFjbHhDWURvcXRkOVdM?=
 =?utf-8?B?aWR5QUhsOW5paXd5anZpZ1RsaW54cTYyN2s4Vm84SVdST0RDY2cvNnRLS3hP?=
 =?utf-8?B?bnV1dFBxR2Y2K0NvS2JVWFBZZmFCQ05tNUFLSkN2eUZ5cUtTdlovMlp4bkpY?=
 =?utf-8?B?TXhoRld6UVN3NDY1bzNGYzB1anRnU041UlYwbXE0TXluYkkxdmk2MGtCTFVE?=
 =?utf-8?B?YWMvVEFIczkwV2JLWm9FZ2lHaHU3dmtzMnNkNDNzMTczdjRGT1dPdTZNODRr?=
 =?utf-8?B?SmVRRXRKOEUxMklyZkpZVGx4NnBaUlZkWXZyTDFWS0dzanBzeTkrRmNMUlcz?=
 =?utf-8?B?YUxRMUhKbkRxdTBuaE5RS0VUbUpuc0pIdVdwRGpqNGRxeWRpNUZBTXFvVmxC?=
 =?utf-8?B?VnZ2VkNleWxFWnowZmdnZFEvRG9XRWdYU0piRnVkVEt2eGU1OEV4MFBaNk5k?=
 =?utf-8?B?TWxnVVJYMldncXQ5ZUF1ZUZtZGZPeHNqdHZmTnBTRUx4QzZnTnBxZHNKWmhJ?=
 =?utf-8?B?Yk41eDYyMDEzRnhvdlZ3b0hSVS9BVnYrWnBTZE5ULytCLzZWM2plNkVKM21G?=
 =?utf-8?B?MlY1clRDenBEdGdmbUNtcFA0ZklhbVFndi9sdHlyQ2JvUEQyUVZjTFk0ME4y?=
 =?utf-8?B?Wm0rYncwV0FxT1orTkdmSGxTQ1FwcDR3Q3p1dHZVczRvTlVMdit1aFpNZkxG?=
 =?utf-8?B?dkk5RVQ0UGF4RkxJVzhvZnNiZ2tWdFN3N1Bld29PM2pLNkowU29nZTZoM2Q2?=
 =?utf-8?B?N25VdE5GYlZSU0xFZSt6WG54RHJXVDdMa0Zrbm5QdXV5UCthclJOTzVVOUtx?=
 =?utf-8?B?NFdoeUptcW9HTDJuajdzTlc4UkhiRmJTUDUzcEJQWUg4YkQvOUFtczFEZFRR?=
 =?utf-8?B?U2pXREVSazNmV1pYdEVvdTVIcnplcXNiVDVLMHYvc2MyZitKVkQ4RjlwM2d0?=
 =?utf-8?B?d2VLRUE4NitVTS8wWjUwVXZPbGpUVFg0OHJHMG1lWnhXSHFvWWlTblQ3RytL?=
 =?utf-8?B?VGhjMC91L1hFU1hURENIVHQ3L2g3bmRYUThMWERGRjJrREZEWW5lbXQwOHNs?=
 =?utf-8?B?R3lFdUZwTFB1OXNVdUJ0Z2F6U1RpdHlNZUp4UXNlZlVrMDRMTTl0OVZjaFRB?=
 =?utf-8?B?enA3VElXa1J3SVA5SFdsNENoazFLQnVXUjA0S2FJYU5EZU56aExYR1JLcVBa?=
 =?utf-8?B?M1BPRzBPV1k0NytjNHpyczZ2eTNmU2pvOXhlYmNNekxJbDhHczJGZ09ML3A2?=
 =?utf-8?B?by9BSCs4VUJTQkpnd3R3VWVLRklUYlMwTXFhK0VrZ0QwQkFhTlZrZnVheEdj?=
 =?utf-8?B?b3VTTDZCMmxrVk9EVitRQ1c5MnBFeEROdmhhVGEySE9PYmtSY1Q3cmRORVY4?=
 =?utf-8?B?ZGh5M2tnL1JzaldZYnVYMEFEQnh5YVdHZ0RzWURmeUJDeGVRZ3k5NlB6Uk1N?=
 =?utf-8?B?K1JscW4xSng2TnEzMW1tWUNOWm5VYlh1SmMxUDNvRkt2QnNBby82R2dSWFpL?=
 =?utf-8?B?Q3V5akIrTmVKNlpqY0ZCQWFreElBcHk0aTZ6ZzZkeDFyZ2lMUE5WSGNWU0Jq?=
 =?utf-8?B?dDRTUUx4OC92TUJ2cHhzU2dKakNRQjBheG42eUp2bEx1UkhqRjIzY3BJWWhZ?=
 =?utf-8?B?akN0dWovWWMxQmZMY3FpY3NtUXd3QVhqS1JpZng3U1VpNTdTS1F4Zjk5WG1Q?=
 =?utf-8?B?dndPR2dZTWZIWlBJMlFDclhuNStJTWgyblpudVNjbzd0WG5UVllvRzNVVzdk?=
 =?utf-8?B?VnJ3V0tUbWhzRW9BNkUvcUZpalJBPT0=?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:satlexmb07.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(36860700013)(82310400026)(376014)(7416014)(1800799024)(7142099003);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Jan 2026 11:19:46.8224
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: b1cb8048-c8b5-413e-ff14-08de5e5f250a
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb07.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SJ1PEPF000023D1.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR12MB9061
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [1.34 / 15.00];
	SUSPICIOUS_RECIPS(1.50)[];
	ARC_REJECT(1.00)[cv is fail on i=2];
	DMARC_POLICY_ALLOW(-0.50)[amd.com,quarantine];
	R_DKIM_ALLOW(-0.20)[amd.com:s=selector1];
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-69336-lists,kvm=lfdr.de];
	DBL_BLOCKED_OPENRESOLVER(0.00)[amd.com:email,amd.com:dkim,amd.com:mid,sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[20];
	MIME_TRACE(0.00)[0:+];
	FREEMAIL_CC(0.00)[redhat.com,gmail.com,linaro.org,habkost.net,intel.com,google.com,lists.linux.dev,8bytes.org];
	DKIM_TRACE(0.00)[amd.com:+];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[sarunkod@amd.com,kvm@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	TO_DN_SOME(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	MID_RHS_MATCH_FROM(0.00)[];
	NEURAL_HAM(-0.00)[-1.000];
	TAGGED_RCPT(0.00)[kvm];
	RCVD_COUNT_SEVEN(0.00)[7]
X-Rspamd-Queue-Id: 0FFD4A036D
X-Rspamd-Action: no action



On 1/28/2026 7:10 AM, Alejandro Jimenez wrote:
> Hi,
>
> On 11/18/25 5:15 AM, Sairaj Kodilkar wrote:
>> From: Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
>>
>> "Set" function tracks VFIO devices in the hash table. This is useful when
>> looking up per-device host IOMMU information later on.
>>
>> Signed-off-by: Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
>> Signed-off-by: Sairaj Kodilkar <sarunkod@amd.com>
>> ---
>>   hw/i386/amd_iommu.c | 71 +++++++++++++++++++++++++++++++++++++++++++++
>>   hw/i386/amd_iommu.h |  8 +++++
>>   2 files changed, 79 insertions(+)
>>
>> diff --git a/hw/i386/amd_iommu.c b/hw/i386/amd_iommu.c
>> index 378e0cb55eab..8b146f4d33d2 100644
>> --- a/hw/i386/amd_iommu.c
>> +++ b/hw/i386/amd_iommu.c
>> @@ -382,6 +382,22 @@ static guint amdvi_uint64_hash(gconstpointer v)
>>       return (guint)*(const uint64_t *)v;
>>   }
>>   
>> +static guint amdvi_dte_hash(gconstpointer v)
>> +{
>> +    const struct AMDVI_dte_key *key = v;
>> +    guint value = (guint)(uintptr_t)key->bus;
>> +
>> +    return (guint)(value << 8 | key->devfn);
>> +}
>> +
>> +static gboolean amdvi_dte_equal(gconstpointer v1, gconstpointer v2)
>> +{
>> +    const struct AMDVI_dte_key *key1 = v1;
>> +    const struct AMDVI_dte_key *key2 = v2;
>> +
>> +    return (key1->bus == key2->bus) && (key1->devfn == key2->devfn);
>> +}
>> +
>>   static AMDVIIOTLBEntry *amdvi_iotlb_lookup(AMDVIState *s, hwaddr addr,
>>                                              uint64_t devid)
>>   {
>> @@ -2291,8 +2307,60 @@ static AddressSpace *amdvi_host_dma_iommu(PCIBus *bus, void *opaque, int devfn)
>>       return &iommu_as[devfn]->as;
>>   }
>>   
>> +static bool amdvi_set_iommu_device(PCIBus *bus, void *opaque, int devfn,
>> +                                   HostIOMMUDevice *hiod, Error **errp)
>> +{
>> +    AMDVIState *s = opaque;
>> +    struct AMDVI_dte_key *new_key;
>> +    struct AMDVI_dte_key key = {
>> +        .bus = bus,
>> +        .devfn = devfn,
>> +    };
>> +
>> +    assert(hiod);
>> +    assert(0 <= devfn && devfn < PCI_DEVFN_MAX);
>> +
>> +    if (g_hash_table_lookup(s->hiod_hash, &key)) {
>> +        error_setg(errp, "Host IOMMU device already exist");
> nit: s/exist/exists/

Sure

>> +        return false;
>> +    }
>> +
>> +    if (hiod->caps.type != IOMMU_HW_INFO_TYPE_AMD &&
>> +        hiod->caps.type != IOMMU_HW_INFO_TYPE_DEFAULT) {
>> +        error_setg(errp, "IOMMU hardware is not compatible");
>> +        return false;
>> +    }
>> +
>> +    new_key = g_malloc(sizeof(*new_key));
> When allocating the new key, use g_new0() instead of g_malloc(), matches
> the current code better e.g.
>
> new_key = g_new0(AMDVIHIODKey, 1);
>
> *the AMDVIHIODKey type comes from a suggestion I make later.

Right

>> +    new_key->bus = bus;
>> +    new_key->devfn = devfn;
>> +
>> +    object_ref(hiod);
>> +    g_hash_table_insert(s->hiod_hash, new_key, hiod);
>> +
>> +    return true;
>> +}
>> +
>> +static void amdvi_unset_iommu_device(PCIBus *bus, void *opaque,
>> +                                     int devfn)
>> +{
>> +    AMDVIState *s = opaque;
>> +    struct AMDVI_dte_key key = {
>> +        .bus = bus,
>> +        .devfn = devfn,
>> +    };
>> +
>> +    if (!g_hash_table_lookup(s->hiod_hash, &key)) {
>> +        return;
>> +    }
>> +
>> +    g_hash_table_remove(s->hiod_hash, &key);
>> +}
>> +
> I think we have to explicitly decrement the reference count for the hiod
> object when removing the last entry from s->hiod_hash.
>
> It looks like the best approach is to pass a custom value_destroy_func
> callback for it when calling g_hash_table_new_full() to create the table.
> Both the VT-d and virtio IOMMU implementations do it via that method.

Good catch, Will do this !

>
>>   static const PCIIOMMUOps amdvi_iommu_ops = {
>>       .get_address_space = amdvi_host_dma_iommu,
>> +    .set_iommu_device = amdvi_set_iommu_device,
>> +    .unset_iommu_device = amdvi_unset_iommu_device,
>>   };
>>   
>>   static const MemoryRegionOps mmio_mem_ops = {
>> @@ -2510,6 +2578,9 @@ static void amdvi_sysbus_realize(DeviceState *dev, Error **errp)
>>       s->iotlb = g_hash_table_new_full(amdvi_uint64_hash,
>>                                        amdvi_uint64_equal, g_free, g_free);
>>   
>> +    s->hiod_hash = g_hash_table_new_full(amdvi_dte_hash,
>> +                                         amdvi_dte_equal, g_free, g_free);
>> +
> As I mentioned above, I think the last parameter to g_hash_table_new_full()
> should be a custom destroy function with a call to:
>
> object_unref((HostIOMMUDevice *)v);
>
>
>>       /* set up MMIO */
>>       memory_region_init_io(&s->mr_mmio, OBJECT(s), &mmio_mem_ops, s,
>>                             "amdvi-mmio", AMDVI_MMIO_SIZE);
>> diff --git a/hw/i386/amd_iommu.h b/hw/i386/amd_iommu.h
>> index daf82fc85f96..e6f6902fe06d 100644
>> --- a/hw/i386/amd_iommu.h
>> +++ b/hw/i386/amd_iommu.h
>> @@ -358,6 +358,11 @@ struct AMDVIPCIState {
>>       uint32_t capab_offset;       /* capability offset pointer    */
>>   };
>>   
>> +struct AMDVI_dte_key {
>> +    PCIBus *bus;
>> +    uint8_t devfn;
>> +};
>> +
> For consistency with earlier usage, use a typedef and CamelCase for the new
> AMDVI_dte_key definition i.e.
>
> typedef struct AMDVIDTEKey {
>      PCIBus *bus;
>      uint8_t devfn;
> } AMDVIDTEKey;
>
> having it in the header file is best I think. I will send a patch moving
> other definitions to amd_iommu.h as well.
>
> But I am not sure that using "dte" in this case is the best choice. I had
> this comment written for another section, fits better here:
>
> hiod_hash and amdvi_dte_hash() should probably use a similar naming to
> signal their relationship. Maybe they can all be 'hiod' based i.e.
> amdvi_hiod_hash().
> This seems to be the choice the VT-d implementation made, and it also
> signals we are using the same HostIOMMUDevice abstraction/model. I get that
> the device the HostIOMMUDevice represents is identified by a unique DTE on
> the host side IOMMU structures, so I am not arguing the naming is
> incorrect, but since we also have many places in the code that act on the
> guest DTE (e.g. amdvi_get_dte()), it would be better to avoid overloading
> 'dte' to avoid confusion.
>
> If the above makes sense, then we should also use `typedef struct
> AMDVIHIODKey` instead...
>
> Thank you,
> Alejandro

Yeah I am in favour of HIOD base naming, will update it in V2

Thanks
Sairaj

>
>>   struct AMDVIState {
>>       X86IOMMUState iommu;        /* IOMMU bus device             */
>>       AMDVIPCIState *pci;         /* IOMMU PCI device             */
>> @@ -416,6 +421,9 @@ struct AMDVIState {
>>       /* IOTLB */
>>       GHashTable *iotlb;
>>   
>> +    /* HostIOMMUDevice hash table*/
>> +    GHashTable *hiod_hash;
>> +
>>       /* Interrupt remapping */
>>       bool ga_enabled;
>>       bool xtsup;


