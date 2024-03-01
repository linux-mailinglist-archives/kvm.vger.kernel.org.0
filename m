Return-Path: <kvm+bounces-10606-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id DDEB986DDC3
	for <lists+kvm@lfdr.de>; Fri,  1 Mar 2024 10:01:24 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 5579F1F215CC
	for <lists+kvm@lfdr.de>; Fri,  1 Mar 2024 09:01:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6552F6A343;
	Fri,  1 Mar 2024 09:01:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="jMRM1JRE"
X-Original-To: kvm@vger.kernel.org
Received: from NAM02-BN1-obe.outbound.protection.outlook.com (mail-bn1nam02on2068.outbound.protection.outlook.com [40.107.212.68])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1E4AA6A02F;
	Fri,  1 Mar 2024 09:01:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.212.68
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709283667; cv=fail; b=IUIkWVb+wSOsS/8EfG1v2FasuMghHCKiu2/U1eLADgUD2SsdNWQHkfySK0w87fyvigbFKemH6sHuAbkylJhnwJuZ3wBONNkiA9hzd1SqYcHR5Ajk1/5IOE670nsKAthqvV9Y2yP1IUTRJCwJltk3kbbZF7Q3SpSdcU4GAlqoAT4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709283667; c=relaxed/simple;
	bh=SI7gSMkG3sED4PKL6WP9YxJtujG5H2iMLHZdp853LLQ=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=ZVPUAxnTkQ6ZvDE0zN5Vk4VPtt/dXflKUWyhZ5tVL8tAlYemmvQ+tXHvA5sDvGznQt8Z7vTDKO+7hG/gVaG05VN01SYBXxLHqQZT7m/cu1vmyUosCMvct6+p/FleLenZzRN12dVhQiAV6ImjIxfsAGaERwhDyaC+r+EPzxjSiN0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=jMRM1JRE; arc=fail smtp.client-ip=40.107.212.68
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=D58+bhrpg9QAdfQ6pk98iX2rhyYT7Ne8el1bOTQoQK81sxCQCw4Dl3sKi1u4ja6EpbbKxqYgH9fvRsApYbWLs3pI6af2JyaUXUpzYU9IBWswxE7xeufzWdKLQs3pO5fEWvHoGpUM95BqO4sS0z5r/l/V7vJsshxR+UvbWfB2xRp3HCRCAkYmZrscgO4V9hNJ5opzbSTkMjZ5UGxHT7rpnKGaF7/UrZcYFqtUpTnqjE2GaP0B5izBbAkOoUevogl/u6Alr/ydhm64Ed1IWuXBlTxoZK21r/3hGmT+xq1emSu+Zy24urgtwA+1AJXJEoZkB0Z+aCo18Ln9PhiKz4rZ2A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=zwL3A3MsLVT691y50xv8tiF6LuYRqztD575pPNCw5xE=;
 b=DlzuDD7iTIbUHmRIRtNlWJoJMDoJB+s93djt0lQdwQJ9n2rWNJzaFnvY9YsUJkXa588qko69NupUw0vl0rjks6XkuxybSYtt+C89G6oZS7DPYc4Y/RQKY7Ai+knJQWTeTM/Y2ugio5YpjGW9sCxZbcEe6Ub6zwRoIG7tGN9fgAl+G0Ivf+SEs9Q1Cu+IL1xP43bVrIFsdpTcPa5ndgJhiFXbKA6RhLLFOHop9G0MGitU0lMdnIDnwTKsmYlEwQjcGyBgM3Y5Kyljp5AGpSCcKNd3CkxDSNNBBLoyW1n3kaZmBvfcDnORZIC13ZEW4qljUyEP9TYt3ar5oBOm8qJOCw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zwL3A3MsLVT691y50xv8tiF6LuYRqztD575pPNCw5xE=;
 b=jMRM1JRE34PzKk1h9YbBMHl+GbIdZIjRz9hc1s+0ISdVy2axueVTi0OKeNA7ixoD1WViYaC9LCazWvgA03IZ3mIaF+NWpyaBdgvItfeyvcKEzSAZdEW4W5jxKhA9bZrgxCh3FsTkjeZCS6AtQHLgseqDMXHmAz1qxFr82CS0gKY=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from PH7PR12MB5712.namprd12.prod.outlook.com (2603:10b6:510:1e3::13)
 by DM4PR12MB6397.namprd12.prod.outlook.com (2603:10b6:8:b4::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7339.32; Fri, 1 Mar
 2024 09:01:01 +0000
Received: from PH7PR12MB5712.namprd12.prod.outlook.com
 ([fe80::9dcb:30:4f52:82f5]) by PH7PR12MB5712.namprd12.prod.outlook.com
 ([fe80::9dcb:30:4f52:82f5%5]) with mapi id 15.20.7316.039; Fri, 1 Mar 2024
 09:01:01 +0000
Message-ID: <cc8699be-3aae-42aa-9c70-f8b6a9728ee3@amd.com>
Date: Fri, 1 Mar 2024 14:30:51 +0530
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] KVM: x86/svm/pmu: Set PerfMonV2 global control bits
 correctly
To: Like Xu <like.xu.linux@gmail.com>
Cc: seanjc@google.com, pbonzini@redhat.com, dapeng1.mi@linux.intel.com,
 mizhang@google.com, jmattson@google.com, ravi.bangoria@amd.com,
 nikunj.dadhania@amd.com, santosh.shukla@amd.com, manali.shukla@amd.com,
 babu.moger@amd.com, kvm list <kvm@vger.kernel.org>,
 "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
References: <20240301075007.644152-1-sandipan.das@amd.com>
 <06061a28-88c0-404b-98a6-83cc6cc8c796@gmail.com>
Content-Language: en-US
From: Sandipan Das <sandipan.das@amd.com>
In-Reply-To: <06061a28-88c0-404b-98a6-83cc6cc8c796@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: PN3PR01CA0072.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:c01:99::19) To PH7PR12MB5712.namprd12.prod.outlook.com
 (2603:10b6:510:1e3::13)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH7PR12MB5712:EE_|DM4PR12MB6397:EE_
X-MS-Office365-Filtering-Correlation-Id: 4f258b00-cb75-4bb1-7e7b-08dc39ce1e1c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	kj0DZlxCeLzT0d1cdmjMeCOeNIuIBY1QXlx/01royxAWnkmxtA6Tui0LM15Yga53qBN+N52gdq3p6Rc/vTcfdFzUdKMCy24PkXiBFZzFobCDa8pyKuAIeW/z5yU2xqaQ5RY0TaD8tKnowHIbRHCZY7a/WOIMr6BDzP4ESf4jMva+27wVmkXh3uL/m0hNEg7x3x8UgMq1oV60TfD28zt970A5jAqzxSh9CL1S3oKPuq4jF1xlu3bo398NadDM4HvoBkl3FIdQRcDurI9/H3Ili7anTq2jvb2baAFGcERb7pcW7B8IcuIWCPGfqyDxo2kpeFR6R+q9rKqylPmKkK4TjyRiaGh5mCOn1tBykjaIQDh/HKLOhmE+Blc9a4EZNkE5kS2S6eSz9UUuYbi5NvS4ShcHSIczjsBjvCANEguHLxuUNAHK/pjtdRrG+m9jGkIVqfm4z0qJmo3xPPMTFG48iPYJyh0Jb4gdMv0PRhJ1K8IDPPrvDaLbH+u52ThagOKCeqf/Q8Qn1L2ZHO57t7fjjmG8ZRaKpjm2j8zx08c47Bjvyw+QKwyb0xZV0ysTfyF3/lTL//dfdCYbbGGB3hO/zEH2gYMGjfSFNweGhNOuU+4RhTqB1zKslSskmpLFgWEM
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH7PR12MB5712.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?UFpON2pYdWpzNzBSOE4vUEVWSW1ZQ0JwTXpkb1FqdDF0MDhHREN6MXNXT3pa?=
 =?utf-8?B?UmZwNjQrU3UweW9PNStEdDNzbG1aZlhGS0dCVUhRM1crSnhaS3pHS2xBRkJQ?=
 =?utf-8?B?dGNZU3R6Y0ZmcFNnNkdpcmNxcTdKbWF6d1hSU01YRWZUd1NOQ0Z3MGRHN203?=
 =?utf-8?B?Vi9rRWlwNnJZWGcrRjF4cWpqTTBQL2N2cTYzeDhCWHV4OFZGb29DRWlyYm4v?=
 =?utf-8?B?U01uRXdjM1pFcnl3QTBJUUxBT0VnOUsyck9XbEJIUHpVMnFpSURDSEwyZmFQ?=
 =?utf-8?B?OXpqc3JWekRPUjVhcGZuMTZ3dThiTngrVHY4YndzWFFidkpybjFQYmZrQWhF?=
 =?utf-8?B?MWl6M2tJdG81QlcwS1ZSWndoNXVHNkZ5Z2dLdXN2eDdGSEhxeWs4R3BiQXgy?=
 =?utf-8?B?TW45YjNjWjdlclZiYWxZdk5OWWU1cmJkYkNuTXFMeVlWV3drL3F1NEpwelNR?=
 =?utf-8?B?Z1E0bnFBN21pQTFiZHE0TExWRFVndVJreHYzL3NYYzgzRVN4OTJkeDhBLzA2?=
 =?utf-8?B?d083WmtnNVloQ0RlcU5JQ0JuNkpGTVJMcGhVTkRlWG5RVlZnYkVQdTlBTEV2?=
 =?utf-8?B?NWNoRVNrUk1rWTY5OFRDaGlvOWFwLzNhUllHRjRMbHJEL3BCZGRNZHJlZllG?=
 =?utf-8?B?VzVPYzNRaGlydGZrdUxTM3owbVBpMDVhS1JncU1NQnFqaEh6L2t5cTFRTW5H?=
 =?utf-8?B?QjlEaFJndDZ1SUd2NnM0QkM5QlFmaEFuYm1UQ0tSUng0MloxcHl3YnhhbUZj?=
 =?utf-8?B?S1VjeUdZZU1iVmNTVjRIaitBSDR4L1JOL003aytZTzlqWklWZmk0ZGpJeGh6?=
 =?utf-8?B?WHRvcktuQnp5K3EyVUpOcHROaVNISnJTOThEM1pST3QxdnBaMkFsTUNWYkF1?=
 =?utf-8?B?c2t0TDBpM1NPeEFEUlNWeXlXQnBVM1dkeWtQdlQ1NGdKdnp3aUhrWkNCVzU2?=
 =?utf-8?B?WjJTZGNaYWY2anEvYWR4SWppWTZubHBxN0I0NDU3a00zT1BYNmp4Mk80NkQr?=
 =?utf-8?B?TS80Vkk2MXQ1RGVoMjlVMUdqRkd6M3QrK1hyT0trRjBJaWtlUHN0MXRva1NF?=
 =?utf-8?B?QkRhbFAvaVlUV3d0M3JhSHJOMHlDcFBCVHpCQVQvT1lycFlLS3hzK0lQQ01H?=
 =?utf-8?B?ZFVLNlgwcWVzc3NBajQzNFdGRUZjZk9uUlJiUUhnTTNvaDd4TkNzYWhtdmsv?=
 =?utf-8?B?SmR1M3dGRTVLQVAyT29QRkJoQk50YzNiVy9kdWJkbnVZdjhBTTZlb2Rtckwv?=
 =?utf-8?B?bGRmR0U3NHJ3UXFrQk96b2V0M2hFZjh6TW54NVBTUDhmVjR1N0FWb3BTM05I?=
 =?utf-8?B?UlROclpJRlhxMndSMXd3M0luazV2S0hTTjVubmpaYTdXTDhxeXVTbXZiS0M4?=
 =?utf-8?B?bTRnendYOEhZSEp3YWV2dCtNcTNiTFN1amNqaVpYZE9KNHdBK2VoNEtGenlR?=
 =?utf-8?B?YmYyUjllOUN3NHZVcmtpMTh6YXV0VkFFT05tdU01bHBZMi9nRklqZWhoYnBB?=
 =?utf-8?B?MStLUUV0aFNMQ0svQzFuMkZGUTd2NjJKN0h4MkNYM2R5eGFEMjErSkRvb0U1?=
 =?utf-8?B?d1VKR0hVNUhOU1hEc0hZTTI4VGxoK2JzclVjd3JqN090YWVCaFNOY3R6R2lH?=
 =?utf-8?B?M3FCcTVGYkRTVVpETFJULzFEM3FDeUpFTUxiOHdqalBpSDVTWW54OXNmd2J4?=
 =?utf-8?B?NGYzY2N6Y21kMUhRVFpOck1sYTZyQmFMUzRxcHFFelhHeHRDNGFhUlZxU0E1?=
 =?utf-8?B?S0JvZHZGVUR6bU92TEdVL1JUQlFMOWpac3o3TmZLWE9XWUVSeTFPQlE0UmRv?=
 =?utf-8?B?ZlVsVmRuazJVVVEwYUNOOUZDOU82bDJCMk1Zb281WXlrcEgxNEtYV0h4TENm?=
 =?utf-8?B?QlVhUUxWbWVoOUFoaXRzamg4RlJzOG9qdllmd0w1dXNhOFBnQi9CU2RsK0xF?=
 =?utf-8?B?Qm9MWUF3VnFyL1lzNFZPS1p4bVhVZTE5VlFyVE96UWNMVHhXekhVb05VYXE5?=
 =?utf-8?B?MUxSbjRvOXlXR1FacW94L3N0YlZ2aUovOGZRM3R0cjJEMWRJTkVTdDZna2lF?=
 =?utf-8?B?ejZnbkJ6Y3Q5TkNwWjR4MEM4MVBTQWRKd250Y2JJUjU1MVFSU0w2Q2wzODNj?=
 =?utf-8?Q?jm6NKEMeZnOyejymHUo9ri8xS?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4f258b00-cb75-4bb1-7e7b-08dc39ce1e1c
X-MS-Exchange-CrossTenant-AuthSource: PH7PR12MB5712.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Mar 2024 09:01:01.4514
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: llkK92KRf++xty+z6RSQBBgB7Dz5t/OYIowzUeDlMZ03GVF0H/CZ1zLie9GnEkq6e4St1fDQgmoUQbZbv0EQdg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB6397

On 3/1/2024 2:07 PM, Like Xu wrote:
> On 1/3/2024 3:50 pm, Sandipan Das wrote:
>> With PerfMonV2, a performance monitoring counter will start operating
>> only when both the PERF_CTLx enable bit as well as the corresponding
>> PerfCntrGlobalCtl enable bit are set.
>>
>> When the PerfMonV2 CPUID feature bit (leaf 0x80000022 EAX bit 0) is set
>> for a guest but the guest kernel does not support PerfMonV2 (such as
>> kernels older than v5.19), the guest counters do not count since the
>> PerfCntrGlobalCtl MSR is initialized to zero and the guest kernel never
>> writes to it.
> 
> If the vcpu has the PerfMonV2 feature, it should not work the way legacy
> PMU does. Users need to use the new driver to operate the new hardware,
> don't they ? One practical approach is that the hypervisor should not set
> the PerfMonV2 bit for this unpatched 'v5.19' guest.
> 

My understanding is that the legacy method of managing the counters should
still work because the enable bits in PerfCntrGlobalCtl are expected to be
set. The AMD PPR does mention that the PerfCntrEn bitfield of PerfCntrGlobalCtl
is set to 0x3f after a system reset. That way, the guest kernel can use either
the new or legacy method.

>>
>> This is not observed on bare-metal as the default value of the
>> PerfCntrGlobalCtl MSR after a reset is 0x3f (assuming there are six
>> counters) and the counters can still be operated by using the enable
>> bit in the PERF_CTLx MSRs. Replicate the same behaviour in guests for
>> compatibility with older kernels.
>>
>> Before:
>>
>>    $ perf stat -e cycles:u true
>>
>>     Performance counter stats for 'true':
>>
>>                     0      cycles:u
>>
>>           0.001074773 seconds time elapsed
>>
>>           0.001169000 seconds user
>>           0.000000000 seconds sys
>>
>> After:
>>
>>    $ perf stat -e cycles:u true
>>
>>     Performance counter stats for 'true':
>>
>>               227,850      cycles:u
>>
>>           0.037770758 seconds time elapsed
>>
>>           0.000000000 seconds user
>>           0.037886000 seconds sys
>>
>> Reported-by: Babu Moger <babu.moger@amd.com>
>> Fixes: 4a2771895ca6 ("KVM: x86/svm/pmu: Add AMD PerfMonV2 support")
>> Signed-off-by: Sandipan Das <sandipan.das@amd.com>
>> ---
>>   arch/x86/kvm/svm/pmu.c | 1 +
>>   1 file changed, 1 insertion(+)
>>
>> diff --git a/arch/x86/kvm/svm/pmu.c b/arch/x86/kvm/svm/pmu.c
>> index b6a7ad4d6914..14709c564d6a 100644
>> --- a/arch/x86/kvm/svm/pmu.c
>> +++ b/arch/x86/kvm/svm/pmu.c
>> @@ -205,6 +205,7 @@ static void amd_pmu_refresh(struct kvm_vcpu *vcpu)
>>       if (pmu->version > 1) {
>>           pmu->global_ctrl_mask = ~((1ull << pmu->nr_arch_gp_counters) - 1);
>>           pmu->global_status_mask = pmu->global_ctrl_mask;
>> +        pmu->global_ctrl = ~pmu->global_ctrl_mask;
>>       }
>>         pmu->counter_bitmask[KVM_PMC_GP] = ((u64)1 << 48) - 1;


