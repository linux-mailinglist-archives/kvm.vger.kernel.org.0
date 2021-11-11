Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5909044D8F5
	for <lists+kvm@lfdr.de>; Thu, 11 Nov 2021 16:14:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234086AbhKKPRR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 11 Nov 2021 10:17:17 -0500
Received: from mail-bn8nam11on2050.outbound.protection.outlook.com ([40.107.236.50]:10983
        "EHLO NAM11-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S234057AbhKKPRP (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 11 Nov 2021 10:17:15 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=O+JyUM110HpwNztI1E/+1k8NMBea1SQun0L3Sb4LZZoy7Wnf+CuEiLTIBnB5cExEZPwopmqHmwTVKbR0Jj3ONEU32nTzj7/ehFpTynZWaJD7PTMuHjZYslynX8UXVUs50m2ATC+8RmvfFyR5qXLZFhBYnMylnOsK03Tt7qK0SIzKdGbvdpUjC9FHyNIawmM5VlNquJSKofMlUT0HJ+//Pmf6Zq3Gl4E030vAHUwqLVOeEdtRFttjp0u9aviAn4PMJOVYcksAp5AxgJcrpFQyn2nAfn4EA5lfvwH4F15bOGNXZWNVTSXY02p5at8+kPXUg244yi/01mkDZIwwfqTLQg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=2iY+sXa4T5iglHdDZq3jj3L3RmBcAO2UYvP3NF/rd2M=;
 b=ff9FymUbDXuRkxvxfgZTaTG/9w4D/rVGzlXHSYaZoC26KkVKAdyQ1V7drZNRyS71WFzMKYXt0z4JRnwIO5MM13YsRB98yDwsM0mnXBCPFT8lLw/De+Ij8V4au/jCAZ7GF7ujjtHz+FhiGSWPfNkQqtMbOhU3pjaJJKOollbWtDKGrqWgtMuLlVKpyc9uPMs2YkoaYB4m215Nc8dy4w4KaIiEikMplNG+Pbzf8jLQq7XlpjAGY0Jh5JiUn0ujC4scpbEHRSbVbP9gYmFGZWsd43vpICIfHhuUdBseE3H3IWVwkgY7pMZb9kNe9KLMDjJOmKYdEMUynYg1XUx05kAeEw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2iY+sXa4T5iglHdDZq3jj3L3RmBcAO2UYvP3NF/rd2M=;
 b=ScvS2DR1xA/hk9qsxdiEWG8UUlc0FGRiXVhhj9Pkkqdxbw8jOuiQbpaWrUsqUrFHpwmqlaAS9vb2R/W+roK9P4VUPPdd2EqKXn5qQD5skjzuy5Kz/lbZNBvbXiqX+SuG4a817vpPl9kc6iGOTxHmezyzPbsEslM3e/+zoD2/7fg=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=amd.com;
Received: from DM4PR12MB5229.namprd12.prod.outlook.com (2603:10b6:5:398::12)
 by DM8PR12MB5480.namprd12.prod.outlook.com (2603:10b6:8:24::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4669.10; Thu, 11 Nov
 2021 15:14:24 +0000
Received: from DM4PR12MB5229.namprd12.prod.outlook.com
 ([fe80::a87d:568d:994f:c5f9]) by DM4PR12MB5229.namprd12.prod.outlook.com
 ([fe80::a87d:568d:994f:c5f9%9]) with mapi id 15.20.4690.020; Thu, 11 Nov 2021
 15:14:24 +0000
Subject: Re: [PATCH 1/2] KVM: SEV: Return appropriate error codes if SEV-ES
 scratch setup fails
To:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20211109222350.2266045-1-seanjc@google.com>
 <20211109222350.2266045-2-seanjc@google.com>
From:   Tom Lendacky <thomas.lendacky@amd.com>
Message-ID: <fc56edb6-5154-4532-242f-4acb8b448330@amd.com>
Date:   Thu, 11 Nov 2021 09:14:22 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
In-Reply-To: <20211109222350.2266045-2-seanjc@google.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SA9PR11CA0017.namprd11.prod.outlook.com
 (2603:10b6:806:6e::22) To DM4PR12MB5229.namprd12.prod.outlook.com
 (2603:10b6:5:398::12)
MIME-Version: 1.0
Received: from office-ryzen.texastahm.com (67.79.209.213) by SA9PR11CA0017.namprd11.prod.outlook.com (2603:10b6:806:6e::22) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4690.15 via Frontend Transport; Thu, 11 Nov 2021 15:14:23 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 39a249f1-915b-498e-8f7d-08d9a525f1f4
X-MS-TrafficTypeDiagnostic: DM8PR12MB5480:
X-Microsoft-Antispam-PRVS: <DM8PR12MB5480E4BD1C7B556459F4E575EC949@DM8PR12MB5480.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: jTY6ym7SicatD4bXfaU/1BN1E/AZseMxMYC4PBOTQPquLbPuK/p9zZNL2WD83HZiFBB/0NZprNDhqYM6cbbfdDcMw+gB8YbPDIZLmwFHfZHdCqFeUlXBgpbR/0padQ0o4jMrzG9FWsOgnukoMlcf4RPoi0KU+4RymGBxrJN05YztzzNiynabkD4vukdzoDdvBV8nN6o+2nXYileJ0CClBE77UXp0XD9L/hotVIOea5V5fU6HCD0W75nOmf1j9aEPwpdS4TxYT2NWMFA6ninHuWcHg3ejvugknpqjQDTFe7uPjb3F0SOJklKEV+rJlxaPPi0srdszLi1K+koxAa90TvgzFyxYNL/FMR0ZnKgByxv35N+pR5Rb7G83nGjcKdVbfrqrwfMJgygpo6UG0KjVbiPdN2ZTV1eNWcsp996WK3aQbRYTC44Rgkgxb91Oo+brffbYku/I1ucnJTvdVAj1g1ofnIhsEx/CHvvIxqo74LNh+d2fSve+hrf8vdre/6wbbJaWxi7BQs9x2eupecyncI0elSqHoXcSCoreBXB24HGuG9ZX6n5uMUbFvUwJCy59kQ+m7wgR+MvyUyw5A9guBeDg+s53mWnYDcJ5ItMOuU6OvieWt1uHosAy79lJsKys/GZSnIWjba1ed9tKLOdkJTV9q7+TpRenN1zP80v4qR+jPfVPv6xsoGC3DkKUkcylBYIpf/nD4GnCPLFO8Tdpu/FoRVHn20qn/y3XpSH11M/TBx8vb5LU+ztrVCWjT9Fs
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR12MB5229.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(316002)(54906003)(956004)(66556008)(38100700002)(31696002)(508600001)(8676002)(110136005)(5660300002)(53546011)(2616005)(31686004)(2906002)(83380400001)(26005)(6486002)(86362001)(8936002)(6506007)(4326008)(66476007)(66946007)(6512007)(186003)(36756003)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?djgyT1B6dFM3UDUwT1FPNDZOQXVndTgwaTExcm4xT212OUMvcnRIYXM5ZlU5?=
 =?utf-8?B?N1BiYjlQZWNMYVdBRmpxTEtKcnZScUtHZW5wU0V4MHIvSTFZdWhVQ1JvMEZY?=
 =?utf-8?B?cTRwT005YTAyOHJYemQ0OVEreFIvQm9FeUlMb1lzWWxBeHVwbkpjelFua3Bv?=
 =?utf-8?B?K2VwelR3bGxPYmxTempDWUY4aDcvMTRlTUkwUzVzK3JDdllDc3JwZ1VjOEMz?=
 =?utf-8?B?U1ZTOVZWZmlSeGUrbGQ3VEVydS8xM1FoWDJUMXVhVnRCcXVvMEcrVEhScWEz?=
 =?utf-8?B?SE1lL2ppQmpPWGlnbE5oUzVYdHN0VlV2QkZjTzVQVzVlV2VsTmtWYzVlWC9X?=
 =?utf-8?B?RXBnWW5YY3J6RGs3VitBYlVmT0ZLUTBMUDJocVpmM01ja29PZWR4TERLUmRn?=
 =?utf-8?B?aWo3MFZOVUIyMHVQWXR3YnBVa0FQanZrZUV3VFVtL3J5aDZsUWQ3dHJib3Nu?=
 =?utf-8?B?aWhlSEhpRkNuemw4VE1QZXZFSWlPYkNxbXc4N0grR09lWGZLQk04VXArY01p?=
 =?utf-8?B?VVdOSUlqVEo0VlJoSndZQ1U3aTJHL1R5eGJhRTJkT0ZBVjY4MkExM2VCSXI5?=
 =?utf-8?B?MEtWLzdMdWhGR3FyTkloR2VycG1rRTdLWHo1dDBFdlBibEx2cXBHK2IyNWRK?=
 =?utf-8?B?U1VyLy8xWFV5d1NiOW5vRVNwUVQ2bS8yWVJkakt5ZUlDR29MK05sSDcvUHJO?=
 =?utf-8?B?cEpXMmY3SVo5cnhzSW1WWGFJM1NBNkxCZUJoeU8yckVlV3kzOFNENjgvSnpO?=
 =?utf-8?B?c1lhMDhONmoxYWpXWENNWkI0SFFkeGEyaFluR0NEeFVOQWhLclNYWThOWjY4?=
 =?utf-8?B?V1JNR3R6WjZnZXU2d1MyNmh4blVLeG9ySmVIVkx0b3FxeE05NzhUcFN0MUlY?=
 =?utf-8?B?N2lWY0tVamVPZE1zZCtodnNoTmQ3UmhqcHJ1Mk9sanFsZzNuRnY4MHlTOUpy?=
 =?utf-8?B?UEduMERTTi9tOXJjalh4eS8wemhpT3pGT3BEbUpuNVRYZ3BrWmdGV3BHZ3Uw?=
 =?utf-8?B?aUV6SmlML2ZlcFM3RHhrbndiQS80bTByZGFoWXBpeVNjOFZQSlEzakRzQnhs?=
 =?utf-8?B?VngyL2dVaXZFSXRLWlFVdC9yWElYb2NXT2x3ZlZ1Z3JkT2R5QkJkRE14eWV0?=
 =?utf-8?B?Y3FNdnZKaHVNWVZzd1lOT1lGRllXM0Q2Y0doNTFQTDREUTg3Q0VKdkpBNWgz?=
 =?utf-8?B?OFJNMkNKUnFKSFVoTkVpa0RDSXQ3amNtMkhBTi94MnlpQ2dSQ3lBT0ZnVEVt?=
 =?utf-8?B?Z1dmQ3dxYXlLM20reFpxaEUvWnhINE04bk5JY3dSSnIzdjFNY2NLWmxocVo2?=
 =?utf-8?B?QUNQbDV6eGswT1REaUwwWk9RL2cvK0I1dE02NTJrVGM0SGJpYkVzSlFSM1k2?=
 =?utf-8?B?TDNvYjk5TG5RZkhoWmZ5bEZXOTNwbDhXUlh0dDFUTkZiSWVuZlBicHpZYU16?=
 =?utf-8?B?YVIvSllrVVZaUjZkV09NVXFiWGpOWllKNG1scjB6M1NEUG84VEMzVGcydEVy?=
 =?utf-8?B?VkYyN0pPSUo3NFlEL05jWmx3SWFxOWpPaTE3U2JVUUNmZkZNdDBNSU5BK0xv?=
 =?utf-8?B?aUdTSFNTVkhVaWF1TzhKdVcwbUk5VGxTcDRxN0k1eGxBYkVwNHJ5bmFwNDFI?=
 =?utf-8?B?N3dmUGR1S3c3c0tZUE5tVy9Sc09qZFF6WFQzK05vWnZWdVZLczA3Y3ZZcUcz?=
 =?utf-8?B?K21xeUZNZG5oWDBhL2c4Y29JM1NNYkszZEVEUEtSMUtxZTYwdXMyeGpPc1lK?=
 =?utf-8?B?WGZMTlV2Q0JBNW5kSmIzVHp2ZVJGemd2WVdrN3RNZTUwUVF1L1BtRHRiaUt3?=
 =?utf-8?B?VXZkWUd4dVVsZUZrL2xPWGd1MU1WMThXdkRsMCtyWE5XcG9OWFZ2ZXRMdU81?=
 =?utf-8?B?bTgxNDJEZlk1UjJBMHUxU3hVNzdraDVBdXFNUC9zV3VndjczNXZxVXAyVGYz?=
 =?utf-8?B?NjU0cGxDbmpFNjE2eVdvckVneG5zRDVKbGhBNFJBUjYyN3V5OCt1clVzRWFu?=
 =?utf-8?B?V2Z0RjdHby9oQWZURDhMNHQ1QXliTTNzbEZIdGxIUWNIV0xpVGRIRSt3dGgv?=
 =?utf-8?B?N1FOc05BU3pXYzcxNFNEYjhOTGhhNndYSUdNY0NVUDhOOWVKMDcwdThWT1dT?=
 =?utf-8?B?c1NZd2ZDNFNyTE1wWndPakY4WnBhcU5oZFBaVGVuUk0vZFA1SlR5c2l1bGxY?=
 =?utf-8?Q?VSI9gyMfAOhaNpznaYSRYqw=3D?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 39a249f1-915b-498e-8f7d-08d9a525f1f4
X-MS-Exchange-CrossTenant-AuthSource: DM4PR12MB5229.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Nov 2021 15:14:24.4571
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: jmdVPRiHazBEdD2a8qgWTUuj6svYONIgJoLZNvoezRVTfZRlxpHr5PaQ7gXIKdqVjruuSgMLP+lApA6SV0VDJQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM8PR12MB5480
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 11/9/21 4:23 PM, Sean Christopherson wrote:
> Return appropriate error codes if setting up the GHCB scratch area for an
> SEV-ES guest fails.  In particular, returning -EINVAL instead of -ENOMEM
> when allocating the kernel buffer could be confusing as userspace would
> likely suspect a guest issue.

Based on previous feedback and to implement the changes to the GHCB 
specification, I'm planning on submitting a patch that will return an 
error code back to the guest, instead of terminating the guest, if the 
scratch area fails to be setup properly. So you could hold off on this 
patch if you want.

Thanks,
Tom

> 
> Fixes: 8f423a80d299 ("KVM: SVM: Support MMIO for an SEV-ES guest")
> Cc: Tom Lendacky <thomas.lendacky@amd.com>
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>   arch/x86/kvm/svm/sev.c | 31 ++++++++++++++++++-------------
>   1 file changed, 18 insertions(+), 13 deletions(-)
> 
> diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
> index 3e2769855e51..ea8069c9b5cb 100644
> --- a/arch/x86/kvm/svm/sev.c
> +++ b/arch/x86/kvm/svm/sev.c
> @@ -2299,7 +2299,7 @@ void pre_sev_run(struct vcpu_svm *svm, int cpu)
>   }
>   
>   #define GHCB_SCRATCH_AREA_LIMIT		(16ULL * PAGE_SIZE)
> -static bool setup_vmgexit_scratch(struct vcpu_svm *svm, bool sync, u64 len)
> +static int setup_vmgexit_scratch(struct vcpu_svm *svm, bool sync, u64 len)
>   {
>   	struct vmcb_control_area *control = &svm->vmcb->control;
>   	struct ghcb *ghcb = svm->ghcb;
> @@ -2310,14 +2310,14 @@ static bool setup_vmgexit_scratch(struct vcpu_svm *svm, bool sync, u64 len)
>   	scratch_gpa_beg = ghcb_get_sw_scratch(ghcb);
>   	if (!scratch_gpa_beg) {
>   		pr_err("vmgexit: scratch gpa not provided\n");
> -		return false;
> +		return -EINVAL;
>   	}
>   
>   	scratch_gpa_end = scratch_gpa_beg + len;
>   	if (scratch_gpa_end < scratch_gpa_beg) {
>   		pr_err("vmgexit: scratch length (%#llx) not valid for scratch address (%#llx)\n",
>   		       len, scratch_gpa_beg);
> -		return false;
> +		return -EINVAL;
>   	}
>   
>   	if ((scratch_gpa_beg & PAGE_MASK) == control->ghcb_gpa) {
> @@ -2335,7 +2335,7 @@ static bool setup_vmgexit_scratch(struct vcpu_svm *svm, bool sync, u64 len)
>   		    scratch_gpa_end > ghcb_scratch_end) {
>   			pr_err("vmgexit: scratch area is outside of GHCB shared buffer area (%#llx - %#llx)\n",
>   			       scratch_gpa_beg, scratch_gpa_end);
> -			return false;
> +			return -EINVAL;
>   		}
>   
>   		scratch_va = (void *)svm->ghcb;
> @@ -2348,18 +2348,18 @@ static bool setup_vmgexit_scratch(struct vcpu_svm *svm, bool sync, u64 len)
>   		if (len > GHCB_SCRATCH_AREA_LIMIT) {
>   			pr_err("vmgexit: scratch area exceeds KVM limits (%#llx requested, %#llx limit)\n",
>   			       len, GHCB_SCRATCH_AREA_LIMIT);
> -			return false;
> +			return -EINVAL;
>   		}
>   		scratch_va = kzalloc(len, GFP_KERNEL_ACCOUNT);
>   		if (!scratch_va)
> -			return false;
> +			return -ENOMEM;
>   
>   		if (kvm_read_guest(svm->vcpu.kvm, scratch_gpa_beg, scratch_va, len)) {
>   			/* Unable to copy scratch area from guest */
>   			pr_err("vmgexit: kvm_read_guest for scratch area failed\n");
>   
>   			kfree(scratch_va);
> -			return false;
> +			return -EFAULT;
>   		}
>   
>   		/*
> @@ -2375,7 +2375,7 @@ static bool setup_vmgexit_scratch(struct vcpu_svm *svm, bool sync, u64 len)
>   	svm->ghcb_sa = scratch_va;
>   	svm->ghcb_sa_len = len;
>   
> -	return true;
> +	return 0;
>   }
>   
>   static void set_ghcb_msr_bits(struct vcpu_svm *svm, u64 value, u64 mask,
> @@ -2514,10 +2514,10 @@ int sev_handle_vmgexit(struct kvm_vcpu *vcpu)
>   	ghcb_set_sw_exit_info_1(ghcb, 0);
>   	ghcb_set_sw_exit_info_2(ghcb, 0);
>   
> -	ret = -EINVAL;
>   	switch (exit_code) {
>   	case SVM_VMGEXIT_MMIO_READ:
> -		if (!setup_vmgexit_scratch(svm, true, control->exit_info_2))
> +		ret = setup_vmgexit_scratch(svm, true, control->exit_info_2);
> +		if (ret)
>   			break;
>   
>   		ret = kvm_sev_es_mmio_read(vcpu,
> @@ -2526,7 +2526,8 @@ int sev_handle_vmgexit(struct kvm_vcpu *vcpu)
>   					   svm->ghcb_sa);
>   		break;
>   	case SVM_VMGEXIT_MMIO_WRITE:
> -		if (!setup_vmgexit_scratch(svm, false, control->exit_info_2))
> +		ret = setup_vmgexit_scratch(svm, false, control->exit_info_2);
> +		if (ret)
>   			break;
>   
>   		ret = kvm_sev_es_mmio_write(vcpu,
> @@ -2569,6 +2570,7 @@ int sev_handle_vmgexit(struct kvm_vcpu *vcpu)
>   		vcpu_unimpl(vcpu,
>   			    "vmgexit: unsupported event - exit_info_1=%#llx, exit_info_2=%#llx\n",
>   			    control->exit_info_1, control->exit_info_2);
> +		ret = -EINVAL;
>   		break;
>   	default:
>   		ret = svm_invoke_exit_handler(vcpu, exit_code);
> @@ -2579,8 +2581,11 @@ int sev_handle_vmgexit(struct kvm_vcpu *vcpu)
>   
>   int sev_es_string_io(struct vcpu_svm *svm, int size, unsigned int port, int in)
>   {
> -	if (!setup_vmgexit_scratch(svm, in, svm->vmcb->control.exit_info_2))
> -		return -EINVAL;
> +	int r;
> +
> +	r = setup_vmgexit_scratch(svm, in, svm->vmcb->control.exit_info_2);
> +	if (r)
> +		return r;
>   
>   	return kvm_sev_es_string_io(&svm->vcpu, size, port,
>   				    svm->ghcb_sa, svm->ghcb_sa_len / size, in);
> 
