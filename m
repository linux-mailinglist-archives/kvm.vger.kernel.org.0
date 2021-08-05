Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8DBD73E1E95
	for <lists+kvm@lfdr.de>; Fri,  6 Aug 2021 00:26:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239058AbhHEW0j (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 5 Aug 2021 18:26:39 -0400
Received: from mail-mw2nam10on2085.outbound.protection.outlook.com ([40.107.94.85]:34529
        "EHLO NAM10-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S238450AbhHEW0i (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 5 Aug 2021 18:26:38 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=QD75qXWAi/UNrs1/znG79eTo4FUAjDO/lZxFy7Y6tp32dqFhcI5YS1SVfJOOhKmw/mb5BZjdTlR7ghGqSAKK3hZZZ4ud10/NCzfBj/77cOk7MjJHNhdPsgflmE4COD3BbTJK9dIJWyTmZWYKddl9xi6uuQfocb0la0ymjdM5f++djtnDbtziQoMstJWzm4qUHBMtqxKDAZ0gID5elcSfeUfrCtb3ZXJQf8fhOgiLshfyPr3V92Dy3AfqN3zRllvHhONuQeTBISKNfBMGXJALDHj+BGcmp6tqDqS9mT8YCGueY9kNo1SBhQxyZoPTiQOSSBzlh1wvL77pKYkpNQKWSg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fKf7YedtqDm7TXbHec+oyqMp3eH/0rZDzC9NkYCQx4U=;
 b=MaxT1STM5waH4GsTDxT3HDA6sywm1omxyK0B97Ebgpng8ql4tcAIN0A2L0uxwOowToqIloMmTN4lIsdxMuk8uqC0X8y9I16YsRoWt9A1OaXTAlb2HN/SQ0AirhqX+5Pp1cEMYoYkpj27mH95cZF7qIQdoKI0HZyw8n6UiMg9zk9PD11xumfw+idtpPXkv614kLSKosYDKSIrWirrJnhTu1XZxLaTOEQnhXRBkHX+CBT5Gplh/KgvgPuXydgZJwyiHWqEjqntofODW+h+DGN4sygehJJuwPfawAtpSJql07V9Fh77IBsnVzz6P9P4mv/Af8Hj8aqD8iuEx6/J2MUYOA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fKf7YedtqDm7TXbHec+oyqMp3eH/0rZDzC9NkYCQx4U=;
 b=deDz0iwtdUg3tgRtZPAaNTWdxbSyRAuTkcsvVTgfRw6aDA4HjqLu/KlpZzPOLEB/l3xjoF58F1bCgBk2MwaUUBFt49ZfLlVX/NGXctLiH8YUYaoN4X+g3Ju3E0LXHqNVKCKinht+y6OmPl8jiRtyBlcYsto0ucbg4N/Eg0SsHvs=
Authentication-Results: zytor.com; dkim=none (message not signed)
 header.d=none;zytor.com; dmarc=none action=none header.from=amd.com;
Received: from DM5PR1201MB0201.namprd12.prod.outlook.com (2603:10b6:4:5b::21)
 by DM6PR12MB3210.namprd12.prod.outlook.com (2603:10b6:5:185::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4394.17; Thu, 5 Aug
 2021 22:26:19 +0000
Received: from DM5PR1201MB0201.namprd12.prod.outlook.com
 ([fe80::7410:8a22:1bdb:d24d]) by DM5PR1201MB0201.namprd12.prod.outlook.com
 ([fe80::7410:8a22:1bdb:d24d%6]) with mapi id 15.20.4394.017; Thu, 5 Aug 2021
 22:26:19 +0000
Subject: Re: [PATCH v1 1/3] KVM: x86: Convert TDP level calculation to
 vendor's specific code
To:     Sean Christopherson <seanjc@google.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        pbonzini@redhat.com, vkuznets@redhat.com, wanpengli@tencent.com,
        jmattson@google.com, joro@8bytes.org, tglx@linutronix.de,
        mingo@redhat.com, bp@alien8.de, x86@kernel.org, hpa@zytor.com
References: <20210805205504.2647362-1-wei.huang2@amd.com>
 <20210805205504.2647362-2-wei.huang2@amd.com> <YQxdbq+yoTIJmpL+@google.com>
From:   Wei Huang <wei.huang2@amd.com>
Message-ID: <9ebc9da6-82ce-542b-2043-b4502facb33e@amd.com>
Date:   Thu, 5 Aug 2021 17:26:17 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
In-Reply-To: <YQxdbq+yoTIJmpL+@google.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SA9PR03CA0001.namprd03.prod.outlook.com
 (2603:10b6:806:20::6) To DM5PR1201MB0201.namprd12.prod.outlook.com
 (2603:10b6:4:5b::21)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [10.236.31.84] (165.204.77.1) by SA9PR03CA0001.namprd03.prod.outlook.com (2603:10b6:806:20::6) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4394.17 via Frontend Transport; Thu, 5 Aug 2021 22:26:18 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 70d3870b-3175-40a3-d378-08d958600c1a
X-MS-TrafficTypeDiagnostic: DM6PR12MB3210:
X-Microsoft-Antispam-PRVS: <DM6PR12MB3210DA0D35E43F25E5EFFD74CFF29@DM6PR12MB3210.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: s3RLVLdMxSNYB3oYvQgbmmgGqG0iaEbiVkXMHwIofvqSkks+v9Jmypcfs5uHFjdVY3llQQIpuXAbc1n3VIApGhk/r6GnXSyY5/jMJZ13swofV24uR35rSOxJ3tqGt3M4dRQvENkV0GaqPEVU7J/u1hMNpDPf/rvEZfk6XoKGlST8UIEi+yFdLXVYLZCl6Mn5zLBTV4XeZ+qGFeGMDsLwddVO/MLK3GX7YA4e28p+vOhRq5CljZ1F2VUd+dZ9kJnsZgBJOVcbWLePJKIj6po9Yj9kJYtfdIRxx6qGOf8EN+BzcaQUZmJgl69tNr9Rn7cX9VFTDj8ngJeSDPMTdHU+MqX9Xjk+wsAqtmHz2mStCRRA/vs4xD0pskXQMYPGQKN/+jWAaXwjLzEArIyXdSbBerk/2XJtaRkQ359uBPL0zs+xDyqYuTAHzitiAg8Uv3IDXowQ6sEfl0r3CExOz0pl5PoKDNARITXFB6/Gxaxrg+OxStqvnge2r9IQHEYetzdmROrYk+akA0h2aRfoAPRb4PXeA1UbsA1GWBDyWpy/aGTYJFHShl710LHFXr+UGGOylPMlYCCojmWwXiLArhRh3eZsxtcmFXE49ICqbaXB6nTGjjDqvKfo1tBQnsxpn2HhuBNbkMuh3a2ayNpJRB+w1xar19n3kMNlCrwuFw7Rq0tENWol755WULGU0yAfY6yhEH5FEK9JN3uIkuF5a/N9CeM3qGDdHSW9gDuKSSYKIjYG9Cf1E/SSBK0De+dXzLQTx//R0e6RoHNaW1dOzYjgcg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR1201MB0201.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(376002)(346002)(366004)(39860400002)(396003)(136003)(26005)(8676002)(2616005)(956004)(16576012)(2906002)(31686004)(6916009)(316002)(38100700002)(36756003)(6486002)(86362001)(38350700002)(5660300002)(7416002)(53546011)(66946007)(66556008)(66476007)(478600001)(186003)(31696002)(52116002)(8936002)(4326008)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?YXVEYWJEZGs0OXgrU1FCYmdPQ1RqSENtSlZTRDVPWExzeTU4bFdWYVBieTlK?=
 =?utf-8?B?aXo1d3h0S2NjL3JKUHNOSlVsbll5cjIweW9xbDFvZDM5YWtRNnNxWUthaEhl?=
 =?utf-8?B?LzNmWStweFV0ZytlaWtkS21vVnEvUnFwOHhacWFTZGU0TS9lTE9ZMGc1eW8z?=
 =?utf-8?B?RWc5bk4zdWZFTHFoTFR4ZFlST3FHTlpJYmlXWlBpMTg5NENOd2tiVk1aMVhN?=
 =?utf-8?B?NXlxWlhIRnlxWjdkdmRBR3ExRVdoeWNpRnQvZzNTZEloQmdLZEVURGNlM1hr?=
 =?utf-8?B?V2ZSRytjcHZUc2svZkJLMXVxeFBmcXVEamI4NFNzSGo3UG5qRlRnN1lBSkNu?=
 =?utf-8?B?UUx5d1VkV1NxcEVTR1YyNmxNNkQraFhSbWNGdS9iaUkvWmZzZytjUzNBb0x2?=
 =?utf-8?B?K3RlS0Q2bGMvMzRJK09lekQveGFBMEgrY2tLNEYvUFBmVWgvOEFtcWM3MXdN?=
 =?utf-8?B?Y083Y01YM2QxOXh4NDY2WnhZS2JNRzExdjE0Q0Y4bTJnR0NHUytOZlpHS1FC?=
 =?utf-8?B?T1VVYXhyNzY3U1YxcEN4NFVQTE83dWhidmY3NE16N2p3ZTE1NmVPWUV6YXpQ?=
 =?utf-8?B?Y25LYmRkM0NpS2dLbVZCUHAwd2V0WWR2WUJxOHBRaUlKd3NzOElqVlpxVHRT?=
 =?utf-8?B?cnFnSHVvLy9BejQvMkJhYVFhS2s1dlJIZ3pkc29jV25KT0ZwWW1pa3JtR2Fv?=
 =?utf-8?B?cktLYXYrbWkxOStTVGhtZ0R0emc0TjFJMnNxeW1kMHdQZWtiUFJ3QW9Ebzd2?=
 =?utf-8?B?MVgzYlFQRUQ5WU5xNWlXbmJzQ0Qzc3RaQXl3aU1sb2R1dnJ2WGViSmU2MkNj?=
 =?utf-8?B?SDJaSkkrNTRSWXppRTlXNnRzTHc3Qjh1V2RMdkxXcEdueW5ZVzRLaHA0aGJY?=
 =?utf-8?B?RHRqaFgvSXZHeHVManMyS1FQWkRqSytpUlRKamRJamdJTCt2YzNTRmt2clkx?=
 =?utf-8?B?ZE8zMk91K0IzSGJsZVJZVDRiZU4rNjczd2cwVUJQTk5OZFcwL2ozbDByMkN6?=
 =?utf-8?B?a1FxZ2VyMGpnbmk4c1ZUVnhya3l2MHBMZC9kK1lScDEvVDNsNVhPeFJDa3Fr?=
 =?utf-8?B?aU5jQnE4WU8zUGtXdkZLT2tFOTZKTEFjSERPOUYxallSY3hZYUkyK1RaRmY1?=
 =?utf-8?B?S0tPRlJ3ajNUWTNyK0k5K2FtbDFxRXJGSnlGMWlzeHR2YkV1eWZ2Zzkzb2VY?=
 =?utf-8?B?T2Y4TE5sZ1lhVXU4UFZIS1cvbVM5RWh1UVBKcE12UGJOdmhCcnc5TzBicnE5?=
 =?utf-8?B?UFQ1dzRhK3ZsL3dhc2hPODdNeHNLMk5PdXp1Lzh3NXBQaC9LTFZYVmpheEJa?=
 =?utf-8?B?engyTmwrYitldGxsdzBLbG5ocmNQMVJMQ2hoT2cxZFcrcmx5cnNUTHROYTVX?=
 =?utf-8?B?TExLSHdmZ2E3cjhMQTNVMWo2a1MvMTZZaUZKRm1ueWtBWFZKVGxPZ3piWml5?=
 =?utf-8?B?K2czdWxpeWovR1BiUk1nakl5WWlldERyVHdUZFVRL1kwek90M2UrL1FWVnpE?=
 =?utf-8?B?aS80anpoUjc0bTdMTDVLMU5XamZuKzNIWVp1b0VuSmN6eWhkSkg2SlhxWFVr?=
 =?utf-8?B?eTcrY1V1MnhVdTQySGhVT3pKZHJqN21heTY4Q0ZtR3JPRFBhdC9VZGhOU2J3?=
 =?utf-8?B?MjErMVUvZXVoVVJrUExiTUQ3OG1aV082MDNTNHlWbXJWSVRiSzVqd2FIZGoz?=
 =?utf-8?B?b0dSazhHMHRJdS9qWkNQVnhrWGZxNlF2NnNMVnB0anRqU01YbFhrT0dJR0dQ?=
 =?utf-8?Q?TUGGxegqPnPeJ6I6oLaXvKl7DGUCmw3l+Ki0W0b?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 70d3870b-3175-40a3-d378-08d958600c1a
X-MS-Exchange-CrossTenant-AuthSource: DM5PR1201MB0201.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Aug 2021 22:26:19.4304
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: KGZOI+jB7/lWRtZ6l+QBWp0v/QdXKvJrdtZ0pPKA0rw4/r1ojsXEudwheEaRGBFh
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB3210
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 8/5/21 4:51 PM, Sean Christopherson wrote:
> On Thu, Aug 05, 2021, Wei Huang wrote:
>> Currently the TDP level for x86 vCPU is calculated by checking both
>> MAXPHYADDR and max_tdp_level. This design assumes that all x86 CPUs have
>> the flexibility of changing the nested page table level different from host
>> CPU. This assumption might not be true.
> 
> Heh, no need to be circumspect, just state that 5-level NPT inherits CR4.LA57
> from the host.  I didn't fully understand this sentence until I looked at patch 3.

Sure, I will fix the comments

> 
>> To solve this problem, let us
>> create a kvm_x86_ops specific function for TDP level calculation.
>>
>> Signed-off-by: Wei Huang <wei.huang2@amd.com>
>> ---
> 
> ...
> 
>> diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
>> index 974cbfb1eefe..20ddfbac966e 100644
>> --- a/arch/x86/include/asm/kvm_host.h
>> +++ b/arch/x86/include/asm/kvm_host.h
>> @@ -723,7 +723,6 @@ struct kvm_vcpu_arch {
>>  
>>  	u64 reserved_gpa_bits;
>>  	int maxphyaddr;
>> -	int max_tdp_level;
> 
> Ha, this is leftover crud that can get zapped no matter what.
> 

Correct, this field is not being used at this moment and should be removed.

>>  	/* emulate context */
>>  
> 
> ...
> 
>> -static inline int kvm_mmu_get_tdp_level(struct kvm_vcpu *vcpu)
>> -{
>> -	/* Use 5-level TDP if and only if it's useful/necessary. */
>> -	if (max_tdp_level == 5 && cpuid_maxphyaddr(vcpu) <= 48)
> 
> I'd strongly prefer to keep this logic in the MMU.  When this was in vendor code,
> there were multiple bugs where the MMU and VMX didn't communicate correctly, I
> really don't want to back down that road.
> 
> Actually, I'm very, very tempted to say we should simply drop the cpuid_maxphyaddr()
> bit and just return the max level (and I suppose rename it), e.g.
> 
> 	return mmu_tdp_level;
> 
> It's effectively a single 4kb page per VM, and Intel's numbers on 5-level paging
> were that there was no measurable cost to the extra level.  I would hope that
> holds true here, too.

4KB waste per VM is possibly OK. My concern is the unnecessary perf cost
of one extra level. But if you think the hit is minimal, then returning
mmu_tdp_level without checking cpuid_maxphyaddr() is cleaner.

> 
> If we want to keep the MAXPHYADDR behavior, I'd vote for something like:
> 
> diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> index b4b65c21b2ca..7e35f2bf89b4 100644
> --- a/arch/x86/kvm/mmu/mmu.c
> +++ b/arch/x86/kvm/mmu/mmu.c
> @@ -97,6 +97,7 @@ module_param_named(flush_on_reuse, force_flush_and_sync_on_reuse, bool, 0644);
>  bool tdp_enabled = false;
> 
>  static int max_huge_page_level __read_mostly;
> +static int tdp_root_level __read_mostly;
>  static int max_tdp_level __read_mostly;
> 
>  enum {
> @@ -4645,6 +4646,9 @@ static union kvm_mmu_role kvm_calc_mmu_role_common(struct kvm_vcpu *vcpu,
> 
>  static inline int kvm_mmu_get_tdp_level(struct kvm_vcpu *vcpu)
>  {
> +       if (tdp_root_level)
> +               return tdp_root_level;
> +
>         /* Use 5-level TDP if and only if it's useful/necessary. */
>         if (max_tdp_level == 5 && cpuid_maxphyaddr(vcpu) <= 48)
>                 return 4;
> @@ -5336,10 +5340,11 @@ void kvm_mmu_invpcid_gva(struct kvm_vcpu *vcpu, gva_t gva, unsigned long pcid)
>          */
>  }
> 
> -void kvm_configure_mmu(bool enable_tdp, int tdp_max_root_level,
> -                      int tdp_huge_page_level)
> +void kvm_configure_mmu(bool enable_tdp, int tdp_forced_root_level,
> +                      int tdp_max_root_level, int tdp_huge_page_level)
>  {
>         tdp_enabled = enable_tdp;
> +       tdp_root_level = tdp_forced_root_level;
>         max_tdp_level = tdp_max_root_level;
> 
>         /*
> 
