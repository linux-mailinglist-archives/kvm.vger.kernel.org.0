Return-Path: <kvm+bounces-11102-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id DF3A1872E42
	for <lists+kvm@lfdr.de>; Wed,  6 Mar 2024 06:18:33 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 0F1011C234FD
	for <lists+kvm@lfdr.de>; Wed,  6 Mar 2024 05:18:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2E80619BBA;
	Wed,  6 Mar 2024 05:18:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="mkeB4cJn"
X-Original-To: kvm@vger.kernel.org
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2075.outbound.protection.outlook.com [40.107.244.75])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 54B7314F7F;
	Wed,  6 Mar 2024 05:18:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.244.75
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709702294; cv=fail; b=h0o7cKYUYyhV2zIQUkwazAYe/3wi/3MV9QZZcx8gsWyB4C9GtWVNudErDJTKlhSywke3b59b19Y8H5TE9mjRqdoMlw0iPJGa+S7pL0tJckgdmd46a6dEbZAdhhYmqQBK13dNUjjZGan5TnOqn7srKqa+SbqBqcOIa2cAaJpeDcU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709702294; c=relaxed/simple;
	bh=W/uOKsgoQAq1sTUF5cjzknkcO8MGQ+zAayeLcckidHI=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=F0PF8GT1ZUBbH/PdoO8lPZqpDbfoqTvt2gbOBoJd4M97G7rXmkAVMnZekqhfG5vh0hP3x+FsqfbtX4T4k7rBP1AEeOTu1IAeWqZo753LHYVVg1afLnZz8/DCnjsL3Em5cER7KsF6XxKQNhcRH5cShRDotbseC2vCSt0g0HtlyDs=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=mkeB4cJn; arc=fail smtp.client-ip=40.107.244.75
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=OebJF4OZXTLQo33H80+H/3yT+fdJkHRl5HIHIUGKlqq0r+XS04OcYnB+vnthUzSW9NJmXoEwGjmXJsQ5juR+5E4XyQUzqN94Nx1Vb8JF5s/0H2eB/l6CmTJiz5zjsQ07pSg8V1cqjDua2IGDFKFB1oHJTlZGLMUwzPhYn2iZkJluEH5abHE0lb0vG2P8nIufAyF+75W2uP08u8dTg3LCQuTATKSP9vnaTeAnDeHE2CkY23Zo/zj9578BbR0HT7jo4mOggFqD6nc8kVjKC5dXMqIsZnGgaAvi1CPHYHljFfhpX/bBfQOyht6foRCHBz+zNojr9SuoxJz5fMhyX2LOng==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=wK7asREL232uYRoodnWt8C3oQj8t4vf4nmCdGPd+Tfw=;
 b=Ps754+0W9J367ZvHwRWAUJxxdt6qS4r56AzFgL3XD9WZmyDnNBq+UZrHaX9MLCRJO3zO3/rUgyUnhc8SkPrZBiyjrYYJk9+X/vHJSBFEThaxFOxc8CQu9FT2W//HNz1pUUqqcYHR69lr4aSB1LBNc6igpniys8O6DAZDmClWRfTlFkiHnySQQB8XNkICyTAcUmHXWPTiBqEJLvLrK41Un7pCer3xrRLXqFaUhA1G8c8f/0TSTDxAI4eh6if0gLvL/Y8oew37yQ8QFSwUoqtAQpDHOt3P8fY1rwegst7Io+/wuqzl5zEdH+xlbvlmN6KSKr7tcybw58g4l4Rx3Vqscg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wK7asREL232uYRoodnWt8C3oQj8t4vf4nmCdGPd+Tfw=;
 b=mkeB4cJne9nLgrqiLZtJ4+KV395GmqTCkX09kttAnyrxHL4QCnMZPw7SWv40jYBbInJHng1XMVGImne2ORrwEluQYhAxHWgrkYOSEHtPUwP9mZmfj7Xv8M4HmFElOcfZUOi9paph2gQfLkARfXcnrh6fG3SQDevqv1vL3GmhYc8=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from PH7PR12MB5712.namprd12.prod.outlook.com (2603:10b6:510:1e3::13)
 by MN2PR12MB4062.namprd12.prod.outlook.com (2603:10b6:208:1d0::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7362.24; Wed, 6 Mar
 2024 05:18:07 +0000
Received: from PH7PR12MB5712.namprd12.prod.outlook.com
 ([fe80::9dcb:30:4f52:82f5]) by PH7PR12MB5712.namprd12.prod.outlook.com
 ([fe80::9dcb:30:4f52:82f5%5]) with mapi id 15.20.7362.019; Wed, 6 Mar 2024
 05:18:07 +0000
Message-ID: <265a906f-6179-4ec4-b46d-491930b3d9ac@amd.com>
Date: Wed, 6 Mar 2024 10:47:53 +0530
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] KVM: x86/svm/pmu: Set PerfMonV2 global control bits
 correctly
To: Sean Christopherson <seanjc@google.com>
Cc: Like Xu <like.xu.linux@gmail.com>, Dapeng Mi
 <dapeng1.mi@linux.intel.com>, pbonzini@redhat.com, mizhang@google.com,
 jmattson@google.com, ravi.bangoria@amd.com, nikunj.dadhania@amd.com,
 santosh.shukla@amd.com, manali.shukla@amd.com, babu.moger@amd.com,
 kvm list <kvm@vger.kernel.org>,
 "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
References: <20240301075007.644152-1-sandipan.das@amd.com>
 <06061a28-88c0-404b-98a6-83cc6cc8c796@gmail.com>
 <cc8699be-3aae-42aa-9c70-f8b6a9728ee3@amd.com>
 <f5bbe9ac-ca35-4c3e-8cd7-249839fbb8b8@linux.intel.com>
 <ZeYlEGORqeTPLK2_@google.com>
 <8a846ba5-d346-422e-817b-e00ab9701f19@gmail.com>
 <ZedUwKWW7PNkvUH1@google.com>
Content-Language: en-US
From: Sandipan Das <sandipan.das@amd.com>
In-Reply-To: <ZedUwKWW7PNkvUH1@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: PN3PR01CA0139.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:c01:bf::9) To PH7PR12MB5712.namprd12.prod.outlook.com
 (2603:10b6:510:1e3::13)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH7PR12MB5712:EE_|MN2PR12MB4062:EE_
X-MS-Office365-Filtering-Correlation-Id: c6dc0dfd-f817-42f4-5d09-08dc3d9cce4f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	5kMnHdo8kh1mcOYtWiflF/GyGA1ZC87IYY6nG69JfgBzmaJIPADYAJXB8I9FwRBpzcWjN/F7c7NL1ip75y7IdAMV741cEuluvXY/So4K2jJdIhiHaG+IouXcjGMnnKKr/XtQWt3FI60r0sivPWP5GDUonkuDZacLnulLXXqnU719XQphx2xh8YEJEgitPgjVVMeK8YTZ4Z9Cun9Jxre1PWHtbCVx4OkxMcqKN2qz64seHgIy37LtynGgTu92cvLHHIlESOVNeBpozJLesA0615dL5N6Sd075/V8u88748l/PMIrUs3LOmT4KC1v1A0t3Ob3ZD1eHn+Deg9IR5yn71exm3hMr42ikmmumMulj/x38MvssXOTS6nwoXCZytaZmatLXHJQCkw22R0PmEJFJnW1EqDKxYNSdnrP7XKxNiZZX7GW2FCX9DiPOQjPTlU7ve63Iiztel08d0MRpTwcCvcdj3zIP4CItBQQGimH3Cc7TWuVnpHD+zCi2DIB9tnQrxjbTewp9G6m2V/CFAAqOwH8f4YnxEVxr2+iacR++aUl+IF9UfRB/uBhS09BMfzwLw/3AlIP7mxtU1G8x68Hxud7yKiNpiHCLQS6GeFkM63En/4ygG6A7kCJvWq8U2nq/XHLziORV4VrOz2sdulUuEpDq+eVIyKZeAkKvgos6J+k=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH7PR12MB5712.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(376005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?cDVENUg4MVZYT3JRcVRodkNMV3JjZE9FcFM1MFEvS3V4UjkxMVI4OWJqVWx6?=
 =?utf-8?B?UlVkNE5UYjZOWlBiMTJBUGhyODFvdlJzNjV5ZWsvUE5VQTJWZGp4ODhEL0F1?=
 =?utf-8?B?M3pzQU43M2FJcnRkYVQ0WGV5bDQzNVdib1dlUUFIQmJqbzNJOVRpd3BHbTV4?=
 =?utf-8?B?cGNGSytTemgwUFhGWEF5N3Z1TXRZVE02eGxVdWpGMGpmQkIxTm83OCtYYkFj?=
 =?utf-8?B?M2tDWVdNRG8yMXcvVG9XQmpvTmdZN3NBdzlGREtNUFdlS1Y3dzQvZVIrODhE?=
 =?utf-8?B?elpXQ1ZYRXkyaG84OHJlQU41TjdSVlZ4bS9XbFN3eGQrZDQ4R1lzdHFRWStI?=
 =?utf-8?B?K1VXRnM4WjI3UzVPYTU2bWhFbnlJYXl1cStlM1drZWw4K3FMQ0JKa005VWlJ?=
 =?utf-8?B?dUQvaXlRV2VOVzY5eE1wekZjSHRXelIweDZDWmYvV3Nmd2RyL25oQm1sRVUv?=
 =?utf-8?B?elpKVVpOV3kzL1BSbzJ6aXM4WUVwYkdTcWNRWUI4QTk0SExid2NRWG1JMlNM?=
 =?utf-8?B?ZHJuazhrLzRSQVZQNXY5SHEwWlF3cVZJZHFIT0hRaGY5YVV3NlNHc2RBb21K?=
 =?utf-8?B?Y3d4dVNzVUJCT3o4Y3BGVlA3WGRtamw5dVZicCticWM3d1F2TFZJVEk3TmEz?=
 =?utf-8?B?Qm1zQllMeVhPRVVVeDlJM3NDZHlmMlZDYTJoYWZoTTF0bnBsd1dVSjhFeVUy?=
 =?utf-8?B?Z1REMmNjN2RGOFdnSjFnaWR3UmxuZ3hPWDEyRXh4Q1AxYURENVZTaXBEa2Q5?=
 =?utf-8?B?N3dtRnd2L2laa1N2UlRhT3VsUm9QbG5DMTNSTFhtSm9nUzdnRGMxaUhQZHUy?=
 =?utf-8?B?d0VNdE05L20ySUNSUXQ5b05KR1lqaTJCcFJFTWlQa0h3SlBoYy9BVDhWcSsz?=
 =?utf-8?B?SFFka2FpWWlqZ2J4QVFjbmprM0N2NXBIK2N6eXRWcXhlbC9QRHR6RzFuUFFp?=
 =?utf-8?B?dVhnWFNYRG9IVGFPZ3pwbld0bEc5cjRkeElveDZINWJpSUoxOVJLQXhNNDVq?=
 =?utf-8?B?YW9hcXh1ZEk3cXAyMEdxT0RJU1pONzdyTHVyZXQ3REZCRi9Yd01BSm1KVWZl?=
 =?utf-8?B?Q25ndHFEcEdTODdTT1d3d0RzcEtOek1ZWlh5QXREQW5PLy9Lcm9rUGp6OG85?=
 =?utf-8?B?WjhZVzY1ZGpRVStGcmIxKzBzeDNDWkQrcXFWdWFlUXNsclVJaGVLMDNHSXJ6?=
 =?utf-8?B?eDQzdy91OTRTbHZDQU5YOUNNNSt3cXVvRmdCeEZjZXh5MGVaVWJsWjk4bklp?=
 =?utf-8?B?NkVybWdzbCsvcGhIU1FEN0dMbXlDaHJiZVpiZ0tOa0wyNXhNaHJJWUFSd0F6?=
 =?utf-8?B?clIzNWpBZDNBZ0YvQXdpMWdBSFZpdE5hajI5djBlUjF5emV4REttTUV3a012?=
 =?utf-8?B?QkZBUThYUjV1dHpySk5YemNsUFlHRUFWZFZGWWM0emlFWUNzN1EwbnUwejM1?=
 =?utf-8?B?WFN2V2dGNzlSOHB2RVlxenNRZm4zY1M2VWhyaUhGcGc1azI4Y3EzbDhXb1cw?=
 =?utf-8?B?aWhTVU4zSG51dVZCdTBoaWtvbGNPUTZyc21MNnUyZStJUDNpRmU1ZHJVMzVN?=
 =?utf-8?B?c2JKZXRIdEF4ZS9pckVsc2tIU1E2TzEwWmttbjc5ZlhLRDVNVk9CZFA3YUwy?=
 =?utf-8?B?Y29FS2dPM0wxa1hSZkpublJXUTZBejRuUE10aXhkTjdzdmxRVTgzRHFIOElk?=
 =?utf-8?B?YWhjRUtkQ3BEalNqMEEzQTdNTldQUys2cTk2WENxQWwzaWJIN2NWeE93dXBY?=
 =?utf-8?B?V2duZzZKSS83dkliSkFFY0xOdldST28zMURJeTlCbmdJVjFjc20rZmg0UmNi?=
 =?utf-8?B?QTBlZkhQdzlvckE0V1NwaVFmOVNrQytGZFI5eE83d1l0ZzJqbzMvOXQxMlg1?=
 =?utf-8?B?Ung1RzhSZzdiN3haL1AyT05GT3gvUDc4WHVsTzFQV0xhM2tkeEJScjQ1Yk04?=
 =?utf-8?B?M0pZRVdNL2dlR1E1VFFFd1hxK3NwQXk5TFpBT05Cekd2Y1piMjF5NTF5bFR0?=
 =?utf-8?B?alZtMlVnZnJ3dWkxblVINzhPeWVpWkMxK1BRNkRtQ0ZjWVprcHB5WmFLSGdh?=
 =?utf-8?B?R3hHMTdBQUZSSHNjcmtZZ2tDK29uWE1OajBmbSt2cExWTUwzTzk3ejNvTEFZ?=
 =?utf-8?Q?THYWHaHAEw29u9Av9f3Meijtl?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c6dc0dfd-f817-42f4-5d09-08dc3d9cce4f
X-MS-Exchange-CrossTenant-AuthSource: PH7PR12MB5712.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Mar 2024 05:18:06.9481
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: KcP6BYUFcEN7iBtNg5L6ZNUlgz+C8Q2a3IqDRyVfg1bgU/HWPuUNzmMo+oe0A2wn7nM4JDmF9vn9U/YJEc1rfA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR12MB4062

On 3/5/2024 10:52 PM, Sean Christopherson wrote:
> On Tue, Mar 05, 2024, Like Xu wrote:
>> On 5/3/2024 3:46 am, Sean Christopherson wrote:
>>>>>>> ---
>>>>>>>     arch/x86/kvm/svm/pmu.c | 1 +
>>>>>>>     1 file changed, 1 insertion(+)
>>>>>>>
>>>>>>> diff --git a/arch/x86/kvm/svm/pmu.c b/arch/x86/kvm/svm/pmu.c
>>>>>>> index b6a7ad4d6914..14709c564d6a 100644
>>>>>>> --- a/arch/x86/kvm/svm/pmu.c
>>>>>>> +++ b/arch/x86/kvm/svm/pmu.c
>>>>>>> @@ -205,6 +205,7 @@ static void amd_pmu_refresh(struct kvm_vcpu *vcpu)
>>>>>>>         if (pmu->version > 1) {
>>>>>>>             pmu->global_ctrl_mask = ~((1ull << pmu->nr_arch_gp_counters) - 1);
>>>>>>>             pmu->global_status_mask = pmu->global_ctrl_mask;
>>>>>>> +        pmu->global_ctrl = ~pmu->global_ctrl_mask;
>>>>
>>>> It seems to be more easily understand to calculate global_ctrl firstly and
>>>> then derive the globol_ctrl_mask (negative logic).
>>>
>>> Hrm, I'm torn.  On one hand, awful name aside (global_ctrl_mask should really be
>>> something like global_ctrl_rsvd_bits), the computation of the reserved bits should
>>> come from the capabilities of the PMU, not from the RESET value.
>>>
>>> On the other hand, setting _all_ non-reserved bits will likely do the wrong thing
>>> if AMD ever adds bits in PerfCntGlobalCtl that aren't tied to general purpose
>>> counters.  But, that's a future theoretical problem, so I'm inclined to vote for
>>> Sandipan's approach.
>>
>> I suspect that Intel hardware also has this behaviour [*] although guest
>> kernels using Intel pmu version 1 are pretty much non-existent.
>>
>> [*] Table 10-1. IA-32 and Intel® 64 Processor States Following Power-up,
>> Reset, or INIT (Contd.)
> 
> Aha!  Nice.  To save people lookups, the table says:
> 
>   IA32_PERF_GLOBAL_CTRL:  Sets bits n-1:0 and clears the upper bits.
> 
> and 
> 
>   Where "n" is the number of general-purpose counters available in the processor.
> 
> Which means that (a) KVM can handle this in common code and (b) we can dodge the
> whole reserved bits chicken-and-egg problem since global_ctrl *can't* be derived
> from global_ctrl_mask.
> 
> This?  (compile tested only)
> 
> ---
> From: Sean Christopherson <seanjc@google.com>
> Date: Tue, 5 Mar 2024 09:02:26 -0800
> Subject: [PATCH] KVM: x86/pmu: Set enable bits for GP counters in
>  PERF_GLOBAL_CTRL at "RESET"
> 
> Set the enable bits for general purpose counters in IA32_PERF_GLOBAL_CTRL
> when refreshing the PMU to emulate the MSR's architecturally defined
> post-RESET behavior.  Per Intel's SDM:
> 
>   IA32_PERF_GLOBAL_CTRL:  Sets bits n-1:0 and clears the upper bits.
> 
> and
> 
>   Where "n" is the number of general-purpose counters available in the processor.
> 
> This is a long-standing bug that was recently exposed when KVM added
> supported for AMD's PerfMonV2, i.e. when KVM started exposing a vPMU with
> PERF_GLOBAL_CTRL to guest software that only knew how to program v1 PMUs
> (that don't support PERF_GLOBAL_CTRL).  Failure to emulate the post-RESET
> behavior results in such guests unknowingly leaving all general purpose
> counters globally disabled (the entire reason the post-RESET value sets
> the GP counter enable bits is to maintain backwards compatibility).
> 
> The bug has likely gone unnoticed because PERF_GLOBAL_CTRL has been
> supported on Intel CPUs for as long as KVM has existed, i.e. hardly anyone
> is running guest software that isn't aware of PERF_GLOBAL_CTRL on Intel
> PMUs.
> 
> Note, kvm_pmu_refresh() can be invoked multiple times, i.e. it's not a
> "pure" RESET flow.  But it can only be called prior to the first KVM_RUN,
> i.e. the guest will only ever observe the final value.
> 
> Reported-by: Reported-by: Babu Moger <babu.moger@amd.com>
> Cc: Like Xu <like.xu.linux@gmail.com>
> Cc: Mingwei Zhang <mizhang@google.com>
> Cc: Dapeng Mi <dapeng1.mi@linux.intel.com>
> Cc: Sandipan Das <sandipan.das@amd.com>
> Cc: stable@vger.kernel.org
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>  arch/x86/kvm/pmu.c | 14 +++++++++++++-
>  1 file changed, 13 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/x86/kvm/pmu.c b/arch/x86/kvm/pmu.c
> index 87cc6c8809ad..f61ce26aeb90 100644
> --- a/arch/x86/kvm/pmu.c
> +++ b/arch/x86/kvm/pmu.c
> @@ -741,6 +741,8 @@ static void kvm_pmu_reset(struct kvm_vcpu *vcpu)
>   */
>  void kvm_pmu_refresh(struct kvm_vcpu *vcpu)
>  {
> +	struct kvm_pmu *pmu = vcpu_to_pmu(vcpu);
> +
>  	if (KVM_BUG_ON(kvm_vcpu_has_run(vcpu), vcpu->kvm))
>  		return;
>  
> @@ -750,8 +752,18 @@ void kvm_pmu_refresh(struct kvm_vcpu *vcpu)
>  	 */
>  	kvm_pmu_reset(vcpu);
>  
> -	bitmap_zero(vcpu_to_pmu(vcpu)->all_valid_pmc_idx, X86_PMC_IDX_MAX);
> +	bitmap_zero(pmu->all_valid_pmc_idx, X86_PMC_IDX_MAX);
>  	static_call(kvm_x86_pmu_refresh)(vcpu);
> +
> +	/*
> +	 * At RESET, both Intel and AMD CPUs set all enable bits for general
> +	 * purpose counters in IA32_PERF_GLOBAL_CTRL (so that software that
> +	 * was written for v1 PMUs don't unknowingly leave GP counters disabled
> +	 * in the global controls).  Emulate that behavior when refreshing the
> +	 * PMU so that userspace doesn't need to manually set PERF_GLOBAL_CTRL.
> +	 */
> +	if (kvm_pmu_has_perf_global_ctrl(pmu))
> +		pmu->global_ctrl = GENMASK_ULL(pmu->nr_arch_gp_counters - 1, 0);
>  }
>  
>  void kvm_pmu_init(struct kvm_vcpu *vcpu)
> 
> base-commit: 1d7ae977d219e68698fdb9bed1049dc561038aa1

Thanks. This looks good.

Tested-by: Sandipan Das <sandipan.das@amd.com>


