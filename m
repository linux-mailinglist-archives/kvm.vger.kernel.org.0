Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6B1063E3EB8
	for <lists+kvm@lfdr.de>; Mon,  9 Aug 2021 06:11:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232821AbhHIEMM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 9 Aug 2021 00:12:12 -0400
Received: from mail-dm6nam11on2082.outbound.protection.outlook.com ([40.107.223.82]:38816
        "EHLO NAM11-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S230365AbhHIEML (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 9 Aug 2021 00:12:11 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=eR/In7lgUYEyTHsR1gKxRpU/qV9au/cD9daFrbV8fD6Y3kedKW5zTTP8iJCsTHg7zHACmqnMyf51PWyPT8V3Lenrni1b6Zxs4zL8QbQEwG802uAQwJw9NCIWjWkOb9iwAwCdAI649qpGzpppm/HhGC7kVPIrSA34jOLW+IJ4J2uredw8Nht6eYPeqBRS9xfaq9CNAWwWaqiGo8hn+v38MI8yW/JtFZW15ViFK5mMwhdL9tWAz6KNmbCJVtJLxX/phR0YPnrBdBXUz37E8wQOZkh/0PeTA+vIHnXgvTKiPhnyqjKikH+9PAQv9T3x3lRIKpfqZknVy5Q/KhzVibHbNQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=G5YRSY8t6RTaPAUrAO85JONkzm0w5SkkP7wmol4b9zg=;
 b=DTy4zVxVEdw76otObIzGyX2f7vi3FbBaeykvnF+iG4el1ZxyZdj3C7NjKq0wWOJnKP9ZIAVhYnSdXtONFokU4mtjIuarY1ZWE6FgelfxIqD36TPSFk6yI30xpB9QlLQYokIbNj0JKf4dxo2fqQUM4EryGyD9ve+ZLT3qMOoY9GrRE81RdosOkOkxmKFrBCCOj9ytW4tYGKaZ/fiAhghxdpxl/HF42DEXM9O/gFd89QuXntBhjquq5BRCvdsSklW3Vll9W2vyvwDkptirSCe11cT76gH/lVBfIkzWOagaJu0GMIiRfO11VeHJHeVAoOcJXLK4OEwky825+USscvO6WA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=G5YRSY8t6RTaPAUrAO85JONkzm0w5SkkP7wmol4b9zg=;
 b=MH83VOyZz6M2TiV7GUlHrcfHAhjRaaNE36ZNVqxIZFr/1oCndq5RiU202UGQTNoDDUQFtbYhzE4H56338ZWWfRCfS21GN4cDPMWrjDAH77OitN1AphYDjdgiLmDllfArvZ7kVn18QodoC5XRyXcPwRD9nqZRSOfdK9/A326tiYk=
Authentication-Results: zytor.com; dkim=none (message not signed)
 header.d=none;zytor.com; dmarc=none action=none header.from=amd.com;
Received: from DM5PR1201MB0201.namprd12.prod.outlook.com (2603:10b6:4:5b::21)
 by DM5PR12MB1434.namprd12.prod.outlook.com (2603:10b6:3:77::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4394.17; Mon, 9 Aug
 2021 04:11:44 +0000
Received: from DM5PR1201MB0201.namprd12.prod.outlook.com
 ([fe80::7410:8a22:1bdb:d24d]) by DM5PR1201MB0201.namprd12.prod.outlook.com
 ([fe80::7410:8a22:1bdb:d24d%6]) with mapi id 15.20.4394.022; Mon, 9 Aug 2021
 04:11:44 +0000
Subject: Re: [PATCH v2 1/3] KVM: x86: Allow CPU to force vendor-specific TDP
 level
To:     Yu Zhang <yu.c.zhang@linux.intel.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        pbonzini@redhat.com, seanjc@google.com, vkuznets@redhat.com,
        wanpengli@tencent.com, jmattson@google.com, joro@8bytes.org,
        tglx@linutronix.de, mingo@redhat.com, bp@alien8.de, x86@kernel.org,
        hpa@zytor.com
References: <20210808192658.2923641-1-wei.huang2@amd.com>
 <20210808192658.2923641-2-wei.huang2@amd.com>
 <20210809035806.5cqdqm5vkexvngda@linux.intel.com>
From:   Wei Huang <wei.huang2@amd.com>
Message-ID: <c6324362-1439-ef94-789b-5934c0e1cdb8@amd.com>
Date:   Sun, 8 Aug 2021 23:11:40 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
In-Reply-To: <20210809035806.5cqdqm5vkexvngda@linux.intel.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SA9PR13CA0170.namprd13.prod.outlook.com
 (2603:10b6:806:28::25) To DM5PR1201MB0201.namprd12.prod.outlook.com
 (2603:10b6:4:5b::21)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [172.31.10.87] (165.204.77.11) by SA9PR13CA0170.namprd13.prod.outlook.com (2603:10b6:806:28::25) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4415.4 via Frontend Transport; Mon, 9 Aug 2021 04:11:42 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 2e1249f7-30c8-4115-e3b1-08d95aebcc12
X-MS-TrafficTypeDiagnostic: DM5PR12MB1434:
X-Microsoft-Antispam-PRVS: <DM5PR12MB14349840F4C6B3B223B27891CFF69@DM5PR12MB1434.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: oq1h1XDFrjBSJy0P08VhulezI4lgEVwof+a750LO7IY6VeJL24uJcs4RzJKoEEPcMfK8vkGvHyFAIsni9bxkQYi+619SobT5+tWe9CcRgcWWNZ+Ne4zf/sPyJWkYUGzhnxsYmcORpzYejhpoqZ6i/jZ6tLFZySpGf02OQFIo7M/DcuYZr1BP2sUH9nx+mshiXOrZUWYw+mQUtveXAlVdAhokytlv4892HQde7Nba/XR9R2/KN/K9ziJKanFPMfOgry63nBeAVmJWSOKkodGukmp0YAMbmDASm9AxJnP/IU5HfJpJXhpehzBtuqtHhmD08osOOmb4aG1yjFq3nJl+WbvO2T+CwTafbo0SFgpvQNyZeu371H0k5HV4LYRKgWgg8CQKkx5++eDkZHtZINP8QIaTQ7Gb9y6EfVT8jepgGEjButFi8nTJF+QCLzRJaIfAWc/swhPCW9MB2a2hLF0hsR0vWT9IpsTGJhqAIehxuU9rfv/HaHHEe3ehiQxoALZoKZ32it0ltuIRi7c4dd1uaxgBE1Xep11w19P5fKsCBPyKwHLPPKhgvdQQOknaV3OapIr6pnV2zkDIfRRgDCrGXPT8rGPI+v5/+fdKkIRwynVSWQri3MATu5KIavIpJ5Bj3tRqRTrteTYIZ2ZYqZ21rh4H9YAwtQ/OJOMxjCrX6ilwze6PRUF+LwYU8ItXY27v5E47byyH7egDFCnef+tHTAIZAthS4sQAXmCHHDheEBSRiOG53waC5pEd8Vqe3UYH
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR1201MB0201.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(39860400002)(136003)(346002)(376002)(366004)(396003)(36756003)(956004)(16576012)(38100700002)(38350700002)(2616005)(66476007)(8936002)(53546011)(52116002)(6486002)(2906002)(31696002)(26005)(316002)(66946007)(478600001)(86362001)(4326008)(6916009)(31686004)(83380400001)(186003)(8676002)(66556008)(7416002)(5660300002)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?MURncGhaTGtsSFVaWlBKWGxreWN0K2prNnlSVnFRSVpQMm5VbU81WUcvOW9r?=
 =?utf-8?B?NUZqQjZIY2lQZGxWYW42QXh0RjRzVlFHQUozUGErWFYrZjMvdkhqbWVIblUr?=
 =?utf-8?B?SC85dWlwZE5CVmZuUVFzTWdWYnpaaVhZcmViWG5OZGZlWjlpVGJybHpSOEdY?=
 =?utf-8?B?YnlwN3J2cFVGU3FBV3ROWGx0NURsSVJMd25lYndsUW44dDY1UzNIb3I1d2tM?=
 =?utf-8?B?ekdHRHZrSVVKYlRsT3hOV2N3emtRMXRvbXI3T2wvc2lwSG5tMTlXeDlmczlN?=
 =?utf-8?B?N1ZrNEZBdHJ4aFlXWHRhbUJibkdDRm1RWTV0R2lURWVRWEo1Y1N2VjZ6c2xL?=
 =?utf-8?B?bGJKTHJwTDc4MWt5c1RSMFlrOTZyNFZDUHhLNHlVclFkbTBJV2tVOHAyaGgv?=
 =?utf-8?B?aWVMb2QwdUMrTXRWMGtiQjdGaHI1ZldPdDYwTHJEa2ZwUytkeVFjUDRGTm54?=
 =?utf-8?B?OEhKN1N2S3BjYlAzU0tSTFBRZmFINEwyMXYzS1Bjd2x3ZGFhTHRYMFBacUtj?=
 =?utf-8?B?ZjZiYXJvTmIvQ3BDT2t5U1dqOENPemYyVzVpcnF4djdwVEc3QkRybzNHdTZx?=
 =?utf-8?B?dk5JSVdRckpqN3VWdjhVZ2dzNjM2M0ZQcGNVNEVkeTR2VjY0RmpMQ0FqdjZa?=
 =?utf-8?B?V2dwK0dsa002SVJxM2dJc21RSHQ5N1JjQzZWb2x5V0tQMGhJR2NkSlRXb3BY?=
 =?utf-8?B?aHlJZjR2cXM3OG1Fcmh5djRiTDNGVmxQb0lrTStwQkpWUno0RUtPclVxQkQy?=
 =?utf-8?B?SEpVeWVXMkRYQXd1bHBzRU5WMFR4bFE5SGtuZ3RBaE44OUtTeG5RMGJqU1R5?=
 =?utf-8?B?eHRLRUF5a1oxWWtMOExBVEtWRHVoOUUxYVg0eHplUWhNMXFXYUlxM1JIWTFj?=
 =?utf-8?B?UFlNVSsxNDhNb0QrbzJkOXNIN0tEZUthNWJ4bVZTTnVWeUVieWI1RytjRnBG?=
 =?utf-8?B?ZXMrbFBlWVNNRDZWZ3FrU1J6OG1iMnFvallpWFk3RzAvY25ESjVoZ0FMck1i?=
 =?utf-8?B?cUZDdnpLM2dhMkQ3cXpvYjg0eUc2OGtNWU56R2ozSGdsdy9sV3lPYlZuUlVE?=
 =?utf-8?B?VVNOZWYyaEFUcXVUcHVkMDJsTzE4TUxYMytqRHBPRFMzNlpBTjUwa1ErQmJ5?=
 =?utf-8?B?NXJzaW9iNXlQYUoxakNQdHl5OGYyRVJaUys5Z2pTWGxNNlpUNzNnS2hlcS90?=
 =?utf-8?B?c1hybjN1cWtDY2MwZTJwR0RsblVCREdDTVVwbzlyVERLTDFWLzBOY2lRZ3Ar?=
 =?utf-8?B?YUhiaWVRWWZnVW54MmZKRW9JYUptOUVqWk1pWHZITEtPbFNPRmlWZ2Z5NjVD?=
 =?utf-8?B?TUlMaEJhQmFlU2lURnpvNWJidjNLZFA2Zjdnek11VEFMandtMnN3eXNoTWNU?=
 =?utf-8?B?T1htSkNMd0h6aWRWRHJVTWk0QzlwZmJod2ZibWNNWHhXU0hRTFRtQklRYjhB?=
 =?utf-8?B?d3ZsWVdQV0hkMU9qMFpXdEJNbEhmQWNMWDFBYllITHVkNmh4WWo0M1ozTWdE?=
 =?utf-8?B?Z1ZGUDM1Zmt4RW5scjRlSzVVV0NwUnVDSDBESE4wTmVWQS95bnNPVTVsR29v?=
 =?utf-8?B?NkVkYzZNRnFKZE1PbllzUk4yd01iM3hNN3loeWdCODFaMHRjNkdMdkRkdVBq?=
 =?utf-8?B?N0laSHQzWWc3SXJYdnJWZjdWLzRmSlpKcDd3NHNWbHJIN1BUR1FYTUg4THVm?=
 =?utf-8?B?a0g3QzEzOUxlU1ZmQ0RSTUdDenU0WGdiUFBDczV1ZXN0TjdpUlZEcERJVlFL?=
 =?utf-8?Q?Evdoxa5GAVZIAARPowIZEpzQNHErgmkD2r94diC?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2e1249f7-30c8-4115-e3b1-08d95aebcc12
X-MS-Exchange-CrossTenant-AuthSource: DM5PR1201MB0201.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Aug 2021 04:11:43.9139
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: qne8r56diZaP6B7rmxwuMZL0nbJEwTSO9KQ9xFckWy57fMtbwn69UDynU4EBDi4h
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR12MB1434
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 8/8/21 10:58 PM, Yu Zhang wrote:
> On Sun, Aug 08, 2021 at 02:26:56PM -0500, Wei Huang wrote:
>> AMD future CPUs will require a 5-level NPT if host CR4.LA57 is set.
> 
> Sorry, but why? NPT is not indexed by HVA.

NPT is not indexed by HVA - it is always indexed by GPA. What I meant is 
NPT page table level has to be the same as the host OS page table: if 
5-level page table is enabled in host OS (CR4.LA57=1), guest NPT has to 
5-level too.

> 
>> To prevent kvm_mmu_get_tdp_level() from incorrectly changing NPT level
>> on behalf of CPUs, add a new parameter in kvm_configure_mmu() to force
>> a fixed TDP level.
>>
>> Signed-off-by: Wei Huang <wei.huang2@amd.com>
>> ---
>>   arch/x86/include/asm/kvm_host.h |  5 ++---
>>   arch/x86/kvm/mmu/mmu.c          | 10 ++++++++--
>>   arch/x86/kvm/svm/svm.c          |  4 +++-
>>   arch/x86/kvm/vmx/vmx.c          |  3 ++-
>>   4 files changed, 15 insertions(+), 7 deletions(-)
>>
>> diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
>> index 974cbfb1eefe..6d16f75cc8da 100644
>> --- a/arch/x86/include/asm/kvm_host.h
>> +++ b/arch/x86/include/asm/kvm_host.h
>> @@ -723,7 +723,6 @@ struct kvm_vcpu_arch {
>>   
>>   	u64 reserved_gpa_bits;
>>   	int maxphyaddr;
>> -	int max_tdp_level;
>>   
>>   	/* emulate context */
>>   
>> @@ -1747,8 +1746,8 @@ void kvm_mmu_invalidate_gva(struct kvm_vcpu *vcpu, struct kvm_mmu *mmu,
>>   void kvm_mmu_invpcid_gva(struct kvm_vcpu *vcpu, gva_t gva, unsigned long pcid);
>>   void kvm_mmu_new_pgd(struct kvm_vcpu *vcpu, gpa_t new_pgd);
>>   
>> -void kvm_configure_mmu(bool enable_tdp, int tdp_max_root_level,
>> -		       int tdp_huge_page_level);
>> +void kvm_configure_mmu(bool enable_tdp, int tdp_forced_root_level,
>> +		       int tdp_max_root_level, int tdp_huge_page_level);
>>   
>>   static inline u16 kvm_read_ldt(void)
>>   {
>> diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
>> index 66f7f5bc3482..c11ee4531f6d 100644
>> --- a/arch/x86/kvm/mmu/mmu.c
>> +++ b/arch/x86/kvm/mmu/mmu.c
>> @@ -97,6 +97,7 @@ module_param_named(flush_on_reuse, force_flush_and_sync_on_reuse, bool, 0644);
>>   bool tdp_enabled = false;
>>   
>>   static int max_huge_page_level __read_mostly;
>> +static int tdp_root_level __read_mostly;
> 
> I think this is a broken design - meaning KVM can only use 5-level or
> 4-level NPT for all VMs.

Broken normally means non-functional or buggy, which doesn't apply here. 
A good TLB design should be able to offset the potential overhead of 
5-level page table for most cases.

> 
> B.R.
> Yu
> 
>>   static int max_tdp_level __read_mostly;
>>   
>>   enum {
>> @@ -4562,6 +4563,10 @@ static union kvm_mmu_role kvm_calc_mmu_role_common(struct kvm_vcpu *vcpu,
>>   
>>   static inline int kvm_mmu_get_tdp_level(struct kvm_vcpu *vcpu)
>>   {
>> +	/* tdp_root_level is architecture forced level, use it if nonzero */
>> +	if (tdp_root_level)
>> +		return tdp_root_level;
>> +
>>   	/* Use 5-level TDP if and only if it's useful/necessary. */
>>   	if (max_tdp_level == 5 && cpuid_maxphyaddr(vcpu) <= 48)
>>   		return 4;
>> @@ -5253,10 +5258,11 @@ void kvm_mmu_invpcid_gva(struct kvm_vcpu *vcpu, gva_t gva, unsigned long pcid)
>>   	 */
>>   }
>>   
>> -void kvm_configure_mmu(bool enable_tdp, int tdp_max_root_level,
>> -		       int tdp_huge_page_level)
>> +void kvm_configure_mmu(bool enable_tdp, int tdp_forced_root_level,
>> +		       int tdp_max_root_level, int tdp_huge_page_level)
>>   {
>>   	tdp_enabled = enable_tdp;
>> +	tdp_root_level = tdp_forced_root_level;
>>   	max_tdp_level = tdp_max_root_level;
>>   
>>   	/*
>> diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
>> index e8ccab50ebf6..f361d466e18e 100644
>> --- a/arch/x86/kvm/svm/svm.c
>> +++ b/arch/x86/kvm/svm/svm.c
>> @@ -1015,7 +1015,9 @@ static __init int svm_hardware_setup(void)
>>   	if (!boot_cpu_has(X86_FEATURE_NPT))
>>   		npt_enabled = false;
>>   
>> -	kvm_configure_mmu(npt_enabled, get_max_npt_level(), PG_LEVEL_1G);
>> +	/* Force VM NPT level equal to the host's max NPT level */
>> +	kvm_configure_mmu(npt_enabled, get_max_npt_level(),
>> +			  get_max_npt_level(), PG_LEVEL_1G);
>>   	pr_info("kvm: Nested Paging %sabled\n", npt_enabled ? "en" : "dis");
>>   
>>   	/* Note, SEV setup consumes npt_enabled. */
>> diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
>> index 927a552393b9..034e1397c7d5 100644
>> --- a/arch/x86/kvm/vmx/vmx.c
>> +++ b/arch/x86/kvm/vmx/vmx.c
>> @@ -7803,7 +7803,8 @@ static __init int hardware_setup(void)
>>   		ept_lpage_level = PG_LEVEL_2M;
>>   	else
>>   		ept_lpage_level = PG_LEVEL_4K;
>> -	kvm_configure_mmu(enable_ept, vmx_get_max_tdp_level(), ept_lpage_level);
>> +	kvm_configure_mmu(enable_ept, 0, vmx_get_max_tdp_level(),
>> +			  ept_lpage_level);
>>   
>>   	/*
>>   	 * Only enable PML when hardware supports PML feature, and both EPT
>> -- 
>> 2.31.1
>>
