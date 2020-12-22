Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 309B62E0E1B
	for <lists+kvm@lfdr.de>; Tue, 22 Dec 2020 19:09:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727696AbgLVSIU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 22 Dec 2020 13:08:20 -0500
Received: from mail-eopbgr760045.outbound.protection.outlook.com ([40.107.76.45]:49756
        "EHLO NAM02-CY1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727264AbgLVSIT (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 22 Dec 2020 13:08:19 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Px/wLuTQ65xmXD1ElIKIb9sHXsXOtDspGqrpbXS5svfmwjBvMvk/NhIvEpsaa+oPMyQROhU0ZXVvb+AMAhn1Hn8IP69hO2GD/veo5uXXkNbhkx+m5nLl4PP51oCz0rbsWgVsi0N7HUIwaKYW1sUcQn+wyT+GQxO0wAS524QwOlpWXnweXoDcswPGPdcLT07NFYG/A6rL5y9Q0smUFGm9E6ZOr/+PHhcVh9QbKldZeWVP6x84J4pwfAPBhxT0CA0iTSKmrky59K0BuKB4WBzPj818wrYH0oXIc1VaUfMHBRI0vi6yaGdnkX0+WS/3J9XDwrl0r0zAZJ+IcZ/4ariYmg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=E3oyB6BKcgrlz/HkFiBcrp1ABMP5wQlWZLATHi5CWAg=;
 b=HNAqdJ42nlin4UZpDVwVCPhy+aFwC8ej6NS+NE1H2kcibbzHzZ8K34Qc3rIxxB11ON0h47DuYjGznvS1Ku2oHJQfk4IS44MiR6VeRcyeox31wJQGK15dglRhuX1LB9JzPThGkFPLOxuupqUVCWswTXHYCWSpSbysVRWyNU3YAqjVoAA2iyfWKNbL+I6o2Y7Nff6HtFb3QqlsQRIhnouI923Tiki0HuR5yIP5TKeB3GkVS2UT//qSibfp7vCKv/9cmsjzQulOox2O9AsniDZJCLtSe9/wvJVKIREfkiPxZQTClzHsw19VjaD9451sXDZhz+e3NzESvXrXm23X6QejdA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector2-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=E3oyB6BKcgrlz/HkFiBcrp1ABMP5wQlWZLATHi5CWAg=;
 b=ecjMy1EPV5kMph3gBFn6JPHYDp0oAAHvt0n5UwmJ3OeHhlgqwAg9Usc2g9LMTPThqE8GuwAd3cP9Mp0AvxAjSiuyBjjdwkZ/aPIM7WFthiWwOs5csOa5jCffChmoBl6pMLarIrTu0X077DkE0QiBaiSmJF7SOWY+IGGlguRcXo4=
Authentication-Results: amd.com; dkim=none (message not signed)
 header.d=none;amd.com; dmarc=none action=none header.from=amd.com;
Received: from SN1PR12MB2560.namprd12.prod.outlook.com (2603:10b6:802:26::19)
 by SN1PR12MB2463.namprd12.prod.outlook.com (2603:10b6:802:22::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3676.33; Tue, 22 Dec
 2020 18:07:31 +0000
Received: from SN1PR12MB2560.namprd12.prod.outlook.com
 ([fe80::8c0e:9a64:673b:4fff]) by SN1PR12MB2560.namprd12.prod.outlook.com
 ([fe80::8c0e:9a64:673b:4fff%5]) with mapi id 15.20.3676.033; Tue, 22 Dec 2020
 18:07:31 +0000
Subject: Re: [PATCH 1/2] x86/cpufeatures: Add the Virtual SPEC_CTRL feature
To:     Sean Christopherson <seanjc@google.com>
Cc:     Jim Mattson <jmattson@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "Yu, Fenghua" <fenghua.yu@intel.com>,
        Tony Luck <tony.luck@intel.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        kvm list <kvm@vger.kernel.org>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Joerg Roedel <joro@8bytes.org>,
        the arch/x86 maintainers <x86@kernel.org>,
        kyung.min.park@intel.com, LKML <linux-kernel@vger.kernel.org>,
        Krish Sadhukhan <krish.sadhukhan@oracle.com>,
        "H . Peter Anvin" <hpa@zytor.com>, mgross@linux.intel.com,
        Vitaly Kuznetsov <vkuznets@redhat.com>, kim.phillips@amd.com,
        wei.huang2@amd.com
References: <160738054169.28590.5171339079028237631.stgit@bmoger-ubuntu>
 <160738067105.28590.10158084163761735153.stgit@bmoger-ubuntu>
 <CALMp9eTk6B2832EN8EhL51m8UqmHLTfeOjdKs8TvFSSAUxGk2Q@mail.gmail.com>
 <2e929c9a-9da9-e7da-9fd4-8e0ea2163a19@amd.com>
 <CALMp9eRzYoVqr0zm60+pkJbGF+t0ry8k7y=X=R1paDhUUPSVCw@mail.gmail.com>
 <00fdc56a-5ac4-94a0-88b4-42e4cf46f083@amd.com> <X+IvzsazR8f2LjLw@google.com>
From:   Babu Moger <babu.moger@amd.com>
Message-ID: <e026c64f-e36e-efea-9252-509090670bf7@amd.com>
Date:   Tue, 22 Dec 2020 12:07:30 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
In-Reply-To: <X+IvzsazR8f2LjLw@google.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [165.204.77.1]
X-ClientProxiedBy: SN4PR0501CA0093.namprd05.prod.outlook.com
 (2603:10b6:803:22::31) To SN1PR12MB2560.namprd12.prod.outlook.com
 (2603:10b6:802:26::19)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [10.236.31.136] (165.204.77.1) by SN4PR0501CA0093.namprd05.prod.outlook.com (2603:10b6:803:22::31) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3700.22 via Frontend Transport; Tue, 22 Dec 2020 18:07:30 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: b2c3efec-e02a-4369-2841-08d8a6a473a3
X-MS-TrafficTypeDiagnostic: SN1PR12MB2463:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SN1PR12MB246335B26C898EF48CA9FD6D95DF0@SN1PR12MB2463.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7691;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: VrR6NKeOW2xqOTnxl4ZtyQOV3e5iN8Q1NgSkVndADO/4J7mCwd6LaIIAqXSJ1oDzVqLCmIgJOfRQ0xWYBfueHPwNwSfJ0iDjTLGN6sjIjDALLlNOgKiht9WAEdfscGZ00ZXEFXUuoo31wsEYFyKK+DVpA10GFd5/bI58TmZPkRxBFKhuRkClATUr8pw29Z9lwUc1myPBxjOCzVkJ+0Lm7TG6gGYXK8raPTC6EZgcBrRQCTGFtSuRIpuz++RcJe/iOJhEBH2NJhknIPU0a0HMouo9sLWm83PhXkqFZlbyVA3HRy5aWbwwlsJOa9h4VP+vw4gkA5sQ5jVikoUotf9B7xBS26qbiogMYKPzVkBygJd+8SKqrmFOMHSEzOJ9YN81CeIheOiOlU1RldiZcEgFhrYD7o11o0qQbMXiSnG/PPn6tL0Oe3oaMwEWwYqXzB8fACmIZ4RHZ2YO9WHh4oCv6gouZC+Ei2N2t5HxbhR4sXk=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN1PR12MB2560.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(136003)(396003)(376002)(366004)(39860400002)(346002)(16576012)(66556008)(478600001)(52116002)(6486002)(31686004)(31696002)(44832011)(66476007)(66946007)(6916009)(5660300002)(86362001)(53546011)(7416002)(8936002)(16526019)(316002)(36756003)(186003)(26005)(8676002)(956004)(54906003)(4326008)(2616005)(2906002)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?d3BDYWdpeXNhTCsrOWw1VzdMYWVYQXE3NFpxNHZueE5vYU8xck9QNjR3U2xF?=
 =?utf-8?B?aUlhcmt4TDhhZzhDemdZWWh5WU41eTVpcXVUNi9DNmt0dTJwY3doVENlcFhX?=
 =?utf-8?B?RnZwNFc3Q0d1blNGYWU1aEF2VHo1S0FuUFo5RXRwSXJhNHYwbnh2UUdmRWVv?=
 =?utf-8?B?UVlOUGhkWVRrQ3BwWGVxUGNhYncweVN5bitFc1BBV1AvQWQ1VXlVZnZycW5h?=
 =?utf-8?B?NTBCRkMxdGVtZ0M1NGxZRnpadDRnbWhsQ2ZBb2gzK3c1TE02MmJqZmptc2dW?=
 =?utf-8?B?WVYreXNtSk1zNExoTEIxN1ptWS9OYitkK0Nwamp0QklsVEE0ZGprbmltMjhk?=
 =?utf-8?B?WWdkTitodjdRUUV4OXVPdTd1Q0tTQmM4eDc4L1VocmlyMEtEUWlpdGdya0U0?=
 =?utf-8?B?VDFoZElqYWJZZFVhT2p2OHdScTZlSWhQbkNYZ1JVQzNRdFF1NmR2c3hYRVlj?=
 =?utf-8?B?SXhMencxbkYwZDNXQkdhVWJNTDhEZXI0YWRuVnJQaElSRWowTm0xQVgxRnpr?=
 =?utf-8?B?ZERIdG1jVUQrVW04azU5NkZtdGF4VEVUNyszeUlqQTRtb3p2djB2bmJrZmVV?=
 =?utf-8?B?TFdFUFpHazRwSDFkZnBYVU43cnY3RXdXSmdkMDdaU3hHMEw5b2ozb1JxN204?=
 =?utf-8?B?MTRLTHEzQ0xjcVBsY3VPM24wQkNXNy9XckI0dUdraXpObUtiWVNIVktESXFm?=
 =?utf-8?B?YTZzYTQwODlja3Uzb0ZXWTk3M1FKU0lsS3pDQUV4bzU2NDF2dHNVWFhPbWFU?=
 =?utf-8?B?ZVJJODF1Y2F5b1VYRDJGaFJ3UnI4OUdxanZtQkUyV3pqVWJZMk5vNUIydXZs?=
 =?utf-8?B?THBzYTVlZDhvSm8xR2lQdm5jSGFEZzNVc0FGNVkwVHo3MmFjd1ZRNFVwZVlB?=
 =?utf-8?B?Q25rdHlVWWt3UVdUVGJ6NkoySVg3dHdXNVZ5dTJzTjRrWXFNV3NzYndFUmRF?=
 =?utf-8?B?YVlRYm1PeWhpaFpYcXJMT1JnVzlyQUdxaTEvUHdLbGdOTyt2Wi9MaTduZmtD?=
 =?utf-8?B?cWVUYUdBSWdQQlV0SU9XYStzWlJta2dscjVhVVhlZ1E4bmRRVktwQmtjemt2?=
 =?utf-8?B?Z0c3cDRwSkJtRmFJUm1sUVFzVHVQVENER0FUb0EzOCthcjFxcmwzSTlFeTMw?=
 =?utf-8?B?NS94ZnpVYVF0dk5seDJBUnduUDRndzZiZVJJNy9Md201S1N3RVlnQlhVVlZs?=
 =?utf-8?B?cnowWlZTWWtHUWlzTjVGb2pxeHVVdHltRDFFY0lEMHNncjBwMHJCZ05RUWRV?=
 =?utf-8?B?aU1nSDJEKzFjOHpINU9lQU9taVFQczV6TndQRGprTVZxbnkrS2c2NXZwa3NC?=
 =?utf-8?Q?7r+n4yUkLd6k9ErJvr5FuPpoMoOlwSepb5?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-AuthSource: SN1PR12MB2560.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Dec 2020 18:07:31.6805
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-Network-Message-Id: b2c3efec-e02a-4369-2841-08d8a6a473a3
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Q1aiP5rq2Hv+CoU3+Q5REwtlKAMBVINBczRnGrqW14NUW7paYHbHoE9lpdA6CfJT
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN1PR12MB2463
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 12/22/20 11:41 AM, Sean Christopherson wrote:
> On Tue, Dec 22, 2020, Babu Moger wrote:
>>
>> On 12/9/20 5:11 PM, Jim Mattson wrote:
>>> On Wed, Dec 9, 2020 at 2:39 PM Babu Moger <babu.moger@amd.com> wrote:
>>>>
>>>> On 12/7/20 5:22 PM, Jim Mattson wrote:
>>>>> On Mon, Dec 7, 2020 at 2:38 PM Babu Moger <babu.moger@amd.com> wrote:
>>>>>> diff --git a/arch/x86/include/asm/cpufeatures.h b/arch/x86/include/asm/cpufeatures.h
>>>>>> index dad350d42ecf..d649ac5ed7c7 100644
>>>>>> --- a/arch/x86/include/asm/cpufeatures.h
>>>>>> +++ b/arch/x86/include/asm/cpufeatures.h
>>>>>> @@ -335,6 +335,7 @@
>>>>>>  #define X86_FEATURE_AVIC               (15*32+13) /* Virtual Interrupt Controller */
>>>>>>  #define X86_FEATURE_V_VMSAVE_VMLOAD    (15*32+15) /* Virtual VMSAVE VMLOAD */
>>>>>>  #define X86_FEATURE_VGIF               (15*32+16) /* Virtual GIF */
>>>>>> +#define X86_FEATURE_V_SPEC_CTRL                (15*32+20) /* Virtual SPEC_CTRL */
>>>>>
>>>>> Shouldn't this bit be reported by KVM_GET_SUPPORTED_CPUID when it's
>>>>> enumerated on the host?
>>>>
>>>> Jim, I am not sure if this needs to be reported by
>>>> KVM_GET_SUPPORTED_CPUID. I dont see V_VMSAVE_VMLOAD or VGIF being reported
>>>> via KVM_GET_SUPPORTED_CPUID. Do you see the need for that?
>>>
>>> Every little bit helps. No, it isn't *needed*. But then again, this
>>> entire patchset isn't *needed*, is it?
>>>
>>
>> Working on v2 of these patches. Saw this code comment(in
>> arch/x86/kvm/cpuid.c) on about exposing SVM features to the guest.
>>
>>
>>         /*
>>          * Hide all SVM features by default, SVM will set the cap bits for
>>          * features it emulates and/or exposes for L1.
>>          */
>>         kvm_cpu_cap_mask(CPUID_8000_000A_EDX, 0);
>>
>>
>> Should we go ahead with the changes here?
> 
> Probably not, as the current SVM implementation aligns with the intended use of
> KVM_GET_SUPPORTED_CPUID.  The current approach is to enumerate what SVM features
> KVM can virtualize or emulate for a nested VM, i.e. what SVM features an L1 VMM
> can use and thus can be set in a vCPU's CPUID model.  For V_SPEC_CTRL, I'm
> pretty sure Jim was providing feedback for the non-nested case of reporting
> host/KVM support of the feature itself.
> 
> There is the question of whether or not KVM should have an ioctl() to report
> what virtualization features are supported/enabled.  AFAIK, it's not truly
> required as userspace can glean the information via /proc/cpuinfo (especially
> now that vmx_features exists), raw CPUID, and KVM module params.  Providing an
> ioctl() would likely be a bit cleaner for userspace, but I'm guessing that ship
> has already sailed for most VMMs.
> 

Sean, Thanks for the clarifications.
