Return-Path: <kvm+bounces-12694-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 5630E88C2E1
	for <lists+kvm@lfdr.de>; Tue, 26 Mar 2024 14:02:26 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 0CF5E2E30A0
	for <lists+kvm@lfdr.de>; Tue, 26 Mar 2024 13:02:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 80CE17173E;
	Tue, 26 Mar 2024 13:02:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="uAGahPb1"
X-Original-To: kvm@vger.kernel.org
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2132.outbound.protection.outlook.com [40.107.244.132])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 045E8495FD;
	Tue, 26 Mar 2024 13:02:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.244.132
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711458133; cv=fail; b=uEs+68Nt7TMcEgZlFOxoCYpbr3RLJc/9UUCdplWkXhepgIaSEoIibQ2U4z3yaEOxQ5gYX+bnt0+Be3IIpugi1eFKtvk0EzayeEv/ibV4p3trpAjUMCH4xKNu8J+jcHd8J97JbMCPrSMlza3cwtDGeFCx/vk73r6iZZWduukIr84=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711458133; c=relaxed/simple;
	bh=qQqGDX4hd3LbLxD2YHlXK1sGgB3Ha8HVZpJ/PwonmzY=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=RXAKuLhBntAppQjntZd/HFaQ0ZhebW9tWCZkCyMX5oCZ5rpfgWf5CNjQwKnb75IldzX82ALLHmxZjKYGiQaff0+JVLDboz8noqwXX6gANRpBWyvI3ixzrENv+UUMr/xCOJ2Cdo+QCxODN4BfkWoF5nG8g3Q11pdczLO3L8I+a1Q=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=uAGahPb1; arc=fail smtp.client-ip=40.107.244.132
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gBw4ySI4KujbPJuKCuctAfBQoddAUCr7VEptLRKDaAwLPqw5lYFmUtSUwqLOD7GPoWtPdAe2cqC+vfZOx3YCwxeO+ZXxW9KdHn/RgGYr/mhiOpV43jXA/JJdK8euSnsGY1qnh0nE5H+BAWYSbTygltmyYaw3WNMpzABy/wEUemrIN7wShj7RPtMFKoK8kmP1qf7dJRkXI9wnXjF9jfmfsJr6caReUTLpSi5OH+HBr80VcJzC1HEz3X+oYA1BV5mA0VD24hyEi+WibkS34MDcXG6zzn2qzZqE2w+2J0WrhSE1UBGsbDRW6Thf6suDwzIgAsuhAjddeZvbRisTlnnZFg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=THHoi1S1RHkeIi/M1p40fBBLKtDgoQvKHfWivmz40nU=;
 b=Xe/HSei4IGXOfWH0QC2cLRVs72NaJ4C0p+XE8XCO1GwU74dg2LDZGxMORugzS3ZdYXh4S8oJs6OV/8ctBoTfeeTN9C5hZD2G2/pY3/PyVrafXp7hgIYA/dnbBzYJeMXnGe+STb8Sdnu218TR81akalU2KD8X76A4K4QwK4EHn+tmFLmg8os300l7L71QVoJbaYMxEBeNVrCh+gOtys7/K08vkP//fNLIFOOl9up0D8tTUAYP6jZe3A8nKHjCAADXrNNfizAI4fn4OM7HRHiitUsV7WqrAQf1kPb6Njf/jYpUp984ljN40e1h1qPpyXGqcwl3/9Bo0Phfbzo6LoXssg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=THHoi1S1RHkeIi/M1p40fBBLKtDgoQvKHfWivmz40nU=;
 b=uAGahPb1ff4vt5JBwdPwc6mfXRGYUz3iO8XuNDBbn52GszVX0rr6fDhEDIA9L4K5DXzGnIZpEAOaRnr9EEl0qnK4XDAJKdHEpJjObQEwWTOcsJNlGTD+NWhUpYY7wyC0SbNBu5tAfIsgHdNSvT8d0m1FiXEKHIrNxQTlZ/KuK3k=
Received: from BL1PR12MB5732.namprd12.prod.outlook.com (2603:10b6:208:387::17)
 by SJ1PR12MB6170.namprd12.prod.outlook.com (2603:10b6:a03:45b::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7409.33; Tue, 26 Mar
 2024 13:02:09 +0000
Received: from BL1PR12MB5732.namprd12.prod.outlook.com
 ([fe80::1032:4da5:7572:508]) by BL1PR12MB5732.namprd12.prod.outlook.com
 ([fe80::1032:4da5:7572:508%6]) with mapi id 15.20.7409.031; Tue, 26 Mar 2024
 13:02:09 +0000
Message-ID: <9f6b46dd-5903-46ce-ba85-488f5b7adf00@amd.com>
Date: Tue, 26 Mar 2024 08:01:52 -0500
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] KVM: SEV-ES: Don't intercept MSR_IA32_DEBUGCTLMSR for
 SEV-ES guests
Content-Language: en-US
To: Ravi Bangoria <ravi.bangoria@amd.com>, seanjc@google.com,
 pbonzini@redhat.com
Cc: tglx@linutronix.de, mingo@redhat.com, bp@alien8.de,
 dave.hansen@linux.intel.com, x86@kernel.org, hpa@zytor.com,
 michael.roth@amd.com, nikunj.dadhania@amd.com, kvm@vger.kernel.org,
 linux-kernel@vger.kernel.org, santosh.shukla@amd.com
References: <20240326081143.715-1-ravi.bangoria@amd.com>
From: Tom Lendacky <thomas.lendacky@amd.com>
Autocrypt: addr=thomas.lendacky@amd.com; keydata=
 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
 vFkWitqCJg==
In-Reply-To: <20240326081143.715-1-ravi.bangoria@amd.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SA1P222CA0102.NAMP222.PROD.OUTLOOK.COM
 (2603:10b6:806:35e::10) To BL1PR12MB5732.namprd12.prod.outlook.com
 (2603:10b6:208:387::17)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL1PR12MB5732:EE_|SJ1PR12MB6170:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	vNIYDEoEh8G1EWKsm9n1wiJOlXq4X/P67tQtA2IY8n5gbs8ReHznRVVZqlOwaHVOsszbfaBnYovviK2qFMU7am8zi6KRk3LRHmUPd8xOZUENxjQbuio8KM5itMO4DdXcitFCEPQvLnp/oZKKZ3ACKZSczCEHj9wwbsz7lTuhD85WeRlW7HTSGNCNigEYSHC5LZ5QMYFShQq3Md4adKgl60TO4bAPwgwxSSbMpt9rbtntRswWmzm4K/X5vxoqYf70ygQ/dCPMciWfUT0ejLMtHTZhXsc9eMO/SpPbk27/DOKUlsS4rYl1XdAy1y3/LbD67vbRu++rLJSagQjXvHefPy+No6uOtLdxPXuGQLk812jtDl4jaJ5sJxX5oRn3pP0bSooYPCJtJJeucNxmLk0Gxun6jxTI6ZDl5PlnsD9v/hgJptXPX0Jqy4Ne8yoIBML6kEdf3cbgsldqGh4w+l5RUK+oz4P6SCokh0GltU6soIsraFk0d1r501vQ0MpgXEPYEBFjMlDfp7fw4rL03yxF267O0DW8DN1gpUv/5loz/fs+Bk/tp7ncqfOu85Z07PvL54gTBZ49TiLc9z2xUxLjCVLNZsFW6CJeXm8RXT/osKw=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR12MB5732.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(366007)(376005)(7416005)(1800799015);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?dzdNWUdlTTVqYTFTZWJPVVhNeE1OVkJ0aTdiZ09QaTl0MlA2VC9KTVMwMUpH?=
 =?utf-8?B?bldLelU4SUxvYjRwUmwrQTNHUXhIOXo0dHRmbTdiMzVKYjdBTldnV1FpV01B?=
 =?utf-8?B?N0M3VXJ1TmsvTTg2ZFd5R3R1b2RvVzUzV1hjd0JYOWU3MFo4cXMvVytrdDd2?=
 =?utf-8?B?YUp1bm5MV25yVW1JNklzVWtvc2l3Rnp4TkZSN2NMTnRYYTJ6SzZhSVdsaFlu?=
 =?utf-8?B?THJvb1hFZXhtZGE1dHBZK1Y3VG1XTmFtejY3T09ubUw3Q1ZXaldBTVplUmFp?=
 =?utf-8?B?MGlYMFFseHEySEtVcHBXMmV0NVNPNW1ud0w5TzMzOTJJK1VUeHNzb3dWRjVp?=
 =?utf-8?B?Y29FTllGNWNkZ1lzbDh1VVN5Z1dXbTg3Y0lsU2dheU82eFVLYnRqRzMwNzZK?=
 =?utf-8?B?M3ZMTnl4R0Uwc3o2OGRBRzUwODJCaFdZZ3ZVOWlDcTZJSTJVbm9jNW1hbTlp?=
 =?utf-8?B?bllBbURrSTgrTFVkM3BaRkJaZ1dRN0tJbVhDZ0gyQ2MxcVNXRFN5cFZEVDE5?=
 =?utf-8?B?UTk4ZzJXN0Y2a00wS2M3NFZ1VEptY1RGeWQwUERuTkVVY2RQTVJtUjU0ZUxD?=
 =?utf-8?B?L1Q0VDU2bTNOREdidlNVOEIwN2J6SFNZVVN4M0I3RW90KzNiUEM4QTlrNWFQ?=
 =?utf-8?B?aW41ZU1NSVdKUG9QdmluczNpK0Fmd3IyaXltTFJGQkdkbzV6dklXUHY4L3BK?=
 =?utf-8?B?b0ZPMFkrMkdCc09ReW5tU0JhaUkxMGJRQ2hjbkxsZU56bDlhOEVRaXZPS1V6?=
 =?utf-8?B?a2JmRVBhMjVSTEdOeTN3UXY4SUxPRXRjZm5yVUZwaDFJaXM2OG8zMG9mUVBt?=
 =?utf-8?B?dlpDVmp0aU5UaG02SDdZTDJsa0Z4K3NNSnVodk5TNUV4VzB0a3hvT1JuaDVa?=
 =?utf-8?B?SFVJci8yOUFVR1l5UklIdjhOUUVKMVNnYVMyTktaYTdTRzZ4RmE5VFFHajZQ?=
 =?utf-8?B?R2Zyb2xVYWxUcmxGZ2VKVS9PT1FNelhhMmpNWk4xWW00RC9URGwrdzJZZysy?=
 =?utf-8?B?eUgxRjAyazduckVhWlpYeStwcCtmSFNuOTYzYXdQREluK1NkNC9iTVlZL2Nz?=
 =?utf-8?B?L1FTZHJxOEY0YWR1RzZkQlpEQklvYjMwYlpvRFFFbVJyTFF5SERYSXRPNjNB?=
 =?utf-8?B?amt5MXpqOG1rUDd6MklzRHJmZEtNeXJabnBNUzlhdkhnMFVDVkFEOUhrc05j?=
 =?utf-8?B?UGdvSCt4R1VROXV4ZkxmckxQaGZqWkVBWVI0RTRGdGxVL2pFMUk2K21tVmJy?=
 =?utf-8?B?ODErVzJ4WkROL2tJWlI2ZGltd3J0a2xiTHVjZEF5RGpHT054ZDFYeTNmZFRv?=
 =?utf-8?B?T1FyVkdlNHYvKzRibmpZSzBJWGcyelQ1MmwvKzlITWRMa0RYQnkrTDNZZmlw?=
 =?utf-8?B?aUpWSjlsMHBzRjF3SmRzaTAveEQ0ZGMySFVtejNYL29ONEd2aUhrYWlubTdO?=
 =?utf-8?B?TU4ySjZKNnRtY1lTRUxFNDhiOVVsd3BMbG1LcWgvVHMrbzdlUmpkN2pGZTV0?=
 =?utf-8?B?QzBRN2N0dGFoODh6WUVLYnJtRGtkbStHTnlKSkQyeWZzcGFEVEh0bmdZaTZh?=
 =?utf-8?B?UHhNUWQ5S0NlbEtCeFJWSGlrdittSG5KZURROUdERWtyczFqVnpXbUxoaDBH?=
 =?utf-8?B?b1M5NTdtMDM0ZVZ6Nk5jSHd0RUI2S3ZzeE1ZU2ZrbGcxa3dlRWNmZy9DbzdT?=
 =?utf-8?B?V3B2V0JEaHpyTC9HbnFjMWQ3OXpkWkxDcDV3N3hOdkRObGxHbTNsMlpaWWtR?=
 =?utf-8?B?cUJsdHYzemlqYkhIcEVsdGl3UG1kTEZpZzJwUHdIekkyUVlrZUc2NjFjNU1j?=
 =?utf-8?B?R1ZWTDM5ZWJLRHFDSlVyQXVKVjlkZHhMU0xhcGtob01SV3EwU092a3Nsd1ZC?=
 =?utf-8?B?TGN5ZEVwNlF3eTZxNFU2TzdTUzIxODNIenoyTTZWVjYyZG9vRXk3bkJUaUho?=
 =?utf-8?B?blEzZXJkbGRJYzJnMmRqOWNxb1F3YndCbFA0bVlHMmlzNzlQaDc0UzVkNi9O?=
 =?utf-8?B?a1IwaUdtNUIzejJWVFRHUTg4Y3AzczBEUWswenlIZHpSU3BQc2NqeGJYRDEx?=
 =?utf-8?B?UC9BaHdMYTNPa21ORXdQTjcyd2E0eHpZOWYwSW9MZnViWTZkaVp2R2xMV01h?=
 =?utf-8?Q?/evvca+ldeorvsVeuvulB0190?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 919904af-5d81-4ef1-c976-08dc4d94f204
X-MS-Exchange-CrossTenant-AuthSource: BL1PR12MB5732.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Mar 2024 13:02:09.2016
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 24DmDH1vb7SsMu3aYoXNwgAPA6vMFYcMPOa/MorH9rWW0+wJe1mp7wjv4ulGDw4h5AhrHjSdoE4jpf2NOttcUA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ1PR12MB6170

On 3/26/24 03:11, Ravi Bangoria wrote:
> Currently, LBR Virtualization is dynamically enabled and disabled for
> a vcpu by intercepting writes to MSR_IA32_DEBUGCTLMSR. This helps by
> avoiding unnecessary save/restore of LBR MSRs when nobody is using it
> in the guest. However, SEV-ES guest mandates LBR Virtualization to be
> _always_ ON[1] and thus this dynamic toggling doesn't work for SEV-ES
> guest, in fact it results into fatal error:
> 
> SEV-ES guest on Zen3, kvm-amd.ko loaded with lbrv=1
> 
>    [guest ~]# wrmsr 0x1d9 0x4
>    KVM: entry failed, hardware error 0xffffffff
>    EAX=00000004 EBX=00000000 ECX=000001d9 EDX=00000000
>    ...
> 
> Fix this by never intercepting MSR_IA32_DEBUGCTLMSR for SEV-ES guests.

Adding something to the commit message that this MSR is fully virtualized 
(swap type A) would be good to have.  Aside from that.

Reviewed-by: Tom Lendacky <thomas.lendacky@amd.com>

> 
> [1]: AMD64 Architecture Programmer's Manual Pub. 40332, Rev. 4.07 - June
>       2023, Vol 2, 15.35.2 Enabling SEV-ES.
>       https://bugzilla.kernel.org/attachment.cgi?id=304653
> 
> Fixes: 376c6d285017 ("KVM: SVM: Provide support for SEV-ES vCPU creation/loading")
> Signed-off-by: Ravi Bangoria <ravi.bangoria@amd.com>
> ---
>   arch/x86/kvm/svm/sev.c | 1 +
>   arch/x86/kvm/svm/svm.c | 1 +
>   arch/x86/kvm/svm/svm.h | 2 +-
>   3 files changed, 3 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
> index a8ce5226b3b5..ef932a7ff9bd 100644
> --- a/arch/x86/kvm/svm/sev.c
> +++ b/arch/x86/kvm/svm/sev.c
> @@ -3073,6 +3073,7 @@ static void sev_es_init_vmcb(struct vcpu_svm *svm)
>   	/* Clear intercepts on selected MSRs */
>   	set_msr_interception(vcpu, svm->msrpm, MSR_EFER, 1, 1);
>   	set_msr_interception(vcpu, svm->msrpm, MSR_IA32_CR_PAT, 1, 1);
> +	set_msr_interception(vcpu, svm->msrpm, MSR_IA32_DEBUGCTLMSR, 1, 1);
>   	set_msr_interception(vcpu, svm->msrpm, MSR_IA32_LASTBRANCHFROMIP, 1, 1);
>   	set_msr_interception(vcpu, svm->msrpm, MSR_IA32_LASTBRANCHTOIP, 1, 1);
>   	set_msr_interception(vcpu, svm->msrpm, MSR_IA32_LASTINTFROMIP, 1, 1);
> diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
> index e90b429c84f1..5a82135ae84e 100644
> --- a/arch/x86/kvm/svm/svm.c
> +++ b/arch/x86/kvm/svm/svm.c
> @@ -99,6 +99,7 @@ static const struct svm_direct_access_msrs {
>   	{ .index = MSR_IA32_SPEC_CTRL,			.always = false },
>   	{ .index = MSR_IA32_PRED_CMD,			.always = false },
>   	{ .index = MSR_IA32_FLUSH_CMD,			.always = false },
> +	{ .index = MSR_IA32_DEBUGCTLMSR,		.always = false },
>   	{ .index = MSR_IA32_LASTBRANCHFROMIP,		.always = false },
>   	{ .index = MSR_IA32_LASTBRANCHTOIP,		.always = false },
>   	{ .index = MSR_IA32_LASTINTFROMIP,		.always = false },
> diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
> index 8ef95139cd24..7a1b60bcebff 100644
> --- a/arch/x86/kvm/svm/svm.h
> +++ b/arch/x86/kvm/svm/svm.h
> @@ -30,7 +30,7 @@
>   #define	IOPM_SIZE PAGE_SIZE * 3
>   #define	MSRPM_SIZE PAGE_SIZE * 2
>   
> -#define MAX_DIRECT_ACCESS_MSRS	47
> +#define MAX_DIRECT_ACCESS_MSRS	48
>   #define MSRPM_OFFSETS	32
>   extern u32 msrpm_offsets[MSRPM_OFFSETS] __read_mostly;
>   extern bool npt_enabled;

