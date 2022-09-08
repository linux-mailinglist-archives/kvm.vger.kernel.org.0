Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 201035B1441
	for <lists+kvm@lfdr.de>; Thu,  8 Sep 2022 08:01:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230047AbiIHGBE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 8 Sep 2022 02:01:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60766 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230052AbiIHGA7 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 8 Sep 2022 02:00:59 -0400
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2085.outbound.protection.outlook.com [40.107.237.85])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EF63993209;
        Wed,  7 Sep 2022 23:00:54 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=nq6wb5F2IaVjHYdtmedkl2S8IkMZvsIbwNv2oyFCZG6o9rhT6YnVfyiksGHFhwtLoDG/bipK2qpmYRrmEwMqxN/w0ajCbBrTvVg0dqoK4mE70KIBIbF1fxAkYq0MYugKgyE6pwU+UCbQud3vnxn19ehtLk05gGS4q19zQF3Rt4qHdxdH7Pw/DgypiTDm0NQUo++WDXg39zwdLOUYSLxnnZArwGW/XQLgyWbWNGidx8OsIYfi4xRzUgakZpNNZtw2vQdYSSSM1cT84Uvc7IjRgdauA9WZpSe+5JY6vhg5Nm5Re2dLCLlQdfx7xHK7GUzGxmqqOYrXCOF/evCfkTUmmw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=b0Y3MIpezrXEN73GZIkGBs5jVlRlGxTRqymhYrXEG8E=;
 b=e+5ubCqWeihO8ohmDa3arCDHqohN2jHgOCowoTHjMgKnN3BxAZM8+fzhwDOIM/+VvtQJKlW3AiX8UZXSbg7yp1Rd98w2IJhFOyAnLhPL9N5Arcdm1Z5YWLxawhXjCCpZVLqL+igFZxxWouFtqCR+VwkKPdSc/5Fuemdp7gp0zv3NeXG5dXwcxHyqaVSqeC7GBzCDsWIvYHVOdpZPEgLfv5Pc9n4zb8rLvrUHWJcSzb6TOgoUsMq1/nkqdcbeFyl3VEVxVq8Z/iL2TZ8Gf2YDjsBaGOmLrD5P83Y5mAUu3SVFUXHKZ1IB9HAjCRCKN2hnf0ERJp6d/5M0048NXWOCzQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=b0Y3MIpezrXEN73GZIkGBs5jVlRlGxTRqymhYrXEG8E=;
 b=s5XASpGhpOCZSAIf2yK68PElRYKvbBg1Dl6UcL0MHja1iKtJmRK0JSsL/bxcPEdg6PIMgX6ZEi8yhOZrEMVihHiY3FAXrbDfteDYlKT9CsbRDWI6YHEXHZlFruxdHv0Ky8zFDNHkg+gbDxuadt6CvZdOoB28xgA+EjYMikfutqE=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from PH7PR12MB5712.namprd12.prod.outlook.com (2603:10b6:510:1e3::13)
 by DS7PR12MB5789.namprd12.prod.outlook.com (2603:10b6:8:74::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5612.16; Thu, 8 Sep
 2022 06:00:52 +0000
Received: from PH7PR12MB5712.namprd12.prod.outlook.com
 ([fe80::e459:32ff:cdfc:fc8b]) by PH7PR12MB5712.namprd12.prod.outlook.com
 ([fe80::e459:32ff:cdfc:fc8b%8]) with mapi id 15.20.5588.016; Thu, 8 Sep 2022
 06:00:52 +0000
Message-ID: <63e6c2da-653f-6f0d-8d56-f1c24122c76d@amd.com>
Date:   Thu, 8 Sep 2022 11:30:40 +0530
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.13.0
Subject: Re: [PATCH 4/4] KVM: x86/cpuid: Add AMD CPUID ExtPerfMonAndDbg leaf
 0x80000022
Content-Language: en-US
To:     Like Xu <like.xu.linux@gmail.com>,
        Jim Mattson <jmattson@google.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20220905123946.95223-1-likexu@tencent.com>
 <20220905123946.95223-5-likexu@tencent.com>
 <CALMp9eQtjZ-iRiW5Jusa+NF-P0sdHtcoR8fPiBSKtNXKgstgVA@mail.gmail.com>
 <0e0f773b-0dde-2282-c2d0-fad2311f59a7@gmail.com>
 <CALMp9eQQe-XDUZmNtg5Z+Vv8hMu_R_fuTv2+-ZfuRwzNUmW0fA@mail.gmail.com>
 <d63e79d8-fcbc-9def-4a90-e7a4614493bb@gmail.com>
 <CALMp9eSXTpkKpmqJiS=0NuQOjCFKDeOqjN3wWfyPCBhx-H=Vsw@mail.gmail.com>
 <c07eb8bf-67fc-c645-18f2-cd1623c7a093@amd.com>
 <c6559d3e-38ec-9a2c-7698-995eb9f265c6@gmail.com>
From:   Sandipan Das <sandipan.das@amd.com>
In-Reply-To: <c6559d3e-38ec-9a2c-7698-995eb9f265c6@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: PN2PR01CA0194.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:c01:e8::19) To PH7PR12MB5712.namprd12.prod.outlook.com
 (2603:10b6:510:1e3::13)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 30718b09-045a-4b07-4871-08da915f7c8c
X-MS-TrafficTypeDiagnostic: DS7PR12MB5789:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: afWrnVvV1nP1XiGJCngOcqn30EMePqDB8JtxMw0RBfvqiOY8lpUub0K5ezwaVGiSYQfAoM0kGIitRsRysjFjghi3H/QqwsvIqY3f5FwR00V8JGhlShrX8BqDaBYXK8N5r+4/6h5R42KI8UDy/5jdREo0hMbm9K0JuCTDqXk8tOcvAYDzGxXSp0jsLF6rVdwnMLrCaA1jf1csBKHTQVKhEvYDlBaeP9ceIWoJPnWeZl9aVD4DLToSAx914GCXrVrNKBdE0hV1rF1ONZe01DMkRoSnoaPtTwT7ivXPtWPtp/BZZyr2bxHgIzLfLm2l04tG8xFCwATPGVTe15W49MV+uZFKs0Kh1HpWWb6vcHr5xV8clqXwwOmDkJLKORMBeeCnHPBvFmuJRZJWLh/bw0yR2WMPJflQnB+bq9v3HTuRSDnerYUR0p57Nka/UA45Aq4UzuHY7qaQsWurKYU2lXXDJ9qnkhTQeZovbvjf9XzkJEa/TCoWNSZkqpHoMh/hJ2NlHsl7g17BfQWf0yKVdRkAzk+a8I9NfC36DV823zLbaNicKUOT28/VS8gaACPoeSoYN5AOfM/jeNmH5oj+QXPJAp+95OH0idCsUQwqGU2fh/vbkk7YgdQNOVwHLtgvqNOeWBZLxrGpNqEVE8DW3IIrWe7w1q1UZR57KM5yda+nNa/5/BkXeyw4DfZAmB3d6ds7M4Vfl0W218E7URcqhIBCyQJvaDIlZHFHzjCOCgeIJvVWTXppk6qUS5Avbo/w7V+TePvqz/RXLL547rACaxk5ByugBaER18drwfSkdRYqaquNnOEQqvvgvKiqzHhWraQmvRSHZxO7YdQvyevS11fFNQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH7PR12MB5712.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(376002)(366004)(136003)(396003)(39860400002)(346002)(478600001)(53546011)(6506007)(6666004)(26005)(6512007)(41300700001)(83380400001)(186003)(38100700002)(2616005)(8936002)(8676002)(31686004)(4326008)(86362001)(66946007)(66476007)(66556008)(31696002)(5660300002)(36756003)(2906002)(44832011)(54906003)(316002)(110136005)(6486002)(19627235002)(213903007)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?aUg1U1p2YWRpajhCcGY3NXFNZXlXRXV2MGpHMGxaeXZGcGVjeXVuZEVtZFE2?=
 =?utf-8?B?bFVjZTlDSHJZdDkwSDVlZlhqeGwxTTNwQVByOHQwN2lOR3BsaUErbDZrczdG?=
 =?utf-8?B?RzFBZUxFOE1qZ1dKSHFCUTFNSUFqUjZuNzFRdnNkeHE2UzdiakV0YmtaSDIz?=
 =?utf-8?B?WEFGdlpRT1RnR2ovSHhSV2Q0WTJUSTFuUXptRTlydzhBam1nOVk1cUw4WXVy?=
 =?utf-8?B?U0tJZFhlaUpSTTROcWRQeTNodTJCbThkRjRaVXVKYmZRdXdNT3dnSEJNUk5F?=
 =?utf-8?B?SHVzV1pwQzY0R3dVbFkxUVF2QUJIQWduWXFrZHB6QmVNS3J3WjNXRUxyb3FW?=
 =?utf-8?B?T0gyYjhubVg4TW9jbFNpaXU1WDkrYjBHc1ZnOS9jTDBpcjJ1Z0JyVkp1N2xG?=
 =?utf-8?B?QVFUdVhCTHJaUFBwNytlTkE5MlhPQmU4TndxUmNhQWNpbDhmRFJWa3F2eXJN?=
 =?utf-8?B?RENHd3g2TnJjMW9JN3h0OG4vZ3YzN0lRVjdTYXorNE1VSGwvSWNjK25PTnFM?=
 =?utf-8?B?SHV3eUFaSUh6U1RFUTlPckxlZmtRWFFjTEVBVGFGdUhPeXMyOFY1M2FoTzNx?=
 =?utf-8?B?MERGellSYmk1K0FlSWxMSGNTMElWSGw3aGVWWDlva3RITExqdHhwaERQY2N6?=
 =?utf-8?B?VmVWQk1KYTZtNXlMazU0a0h1ZmFicXFTbmlTVDkwTHZHbkxjQm9rZUNnejRZ?=
 =?utf-8?B?QTlpU2NDYnJkUkpibHM1c01xZXhNTVdEWU1nKzZWRUVpaWUzaVNLRVMvcG1J?=
 =?utf-8?B?VVpaT0FhUjdxR1hYWERTbU5xQXNIeDY4bUFYTGRteGVSUTg2MnRiR3dSNFJJ?=
 =?utf-8?B?QWVWL2NpRW1OZnpSRGFqYmlPMmFRbEV6NGZ4UUJIVmtGTDJOU1dRUUEwc2Vz?=
 =?utf-8?B?aFRoRm9iUE5OSXRFWnpuSit2aWhzRWtDeVFWbDcxRVMxaitLMUY4MzJLMG9C?=
 =?utf-8?B?L3haKytnYzlIYm05cTFWZHhKeTdHR1hydElHdStsT0xURm5hejg1OFE3SDl1?=
 =?utf-8?B?YmZiU1VSenlWaDJaY1U3YWtMY250SHVETTNCTmd1N1hHRU52VXc0anlIUC9C?=
 =?utf-8?B?QXlzZVV1YUx4MStoVDA0Vm44SWV3a2hvV2h4SEh1dlJhTjE3UDNVRWplK0E4?=
 =?utf-8?B?VTN4WXpvK0s0RzBCUlRZMTJsbVd4blA2UlBueUZPQXNYMGI4ZEdxSlpvR2xt?=
 =?utf-8?B?SWpXMW1IYjZ5ZzdxdGhXVkkvTUFmQ1dRQ2RuRCtYd3d3WE82RW81NlNEWTkz?=
 =?utf-8?B?YU05dDNqZ0hoN2k1b2xTa3pxU3RnaTg0QnVKZDN2TnFnbXVkS05sdGhZeDAx?=
 =?utf-8?B?VW1rYno0VDVuUXdBeDU4ZXYxTnppN3dPSktwRXJhL2FWeGgzTDlkemhzVFdI?=
 =?utf-8?B?WFNuVmRDbk9SYUIvMHFuQXBNNjRoaWxMVkptY0ZmcndxL04rd0hBRkd6VTd4?=
 =?utf-8?B?emlNSXBQL1phZlAxMHoyL1N0MVhaRDg1MHJzMFBqbG01SitWcFgyeGRLeDJK?=
 =?utf-8?B?cElZTHV3VTJEVTNEdkh4bVFTMHcyTVN5a1c0QkJPaDRFTFRyVlhuUnNlWDl4?=
 =?utf-8?B?OWpJQmNBcFpLcU5jbW0vckM4L1FLWmc5YzhPd1lQZGJmMWMzbzc2K2p1UDA2?=
 =?utf-8?B?L1ZLUmZGOEJyeTNoS29mTnhuZzZoVW9McFZJVGVoV1hmSHdObFYrUnJEWTdL?=
 =?utf-8?B?QXRXdUcwNWNyVGxrZXN5UnBHbUFTbmVlQjdLZHVjRjEwTjNFWEN5ZXJYd3px?=
 =?utf-8?B?VGVmSmJ4YkdwRnVXTFVScGNNMVpvbTM3MlpaTFpqbmxDbzBpNU1tSHBSMFg2?=
 =?utf-8?B?a0xheFJjUDNXR2w5czVSeXI0OFBYR3grVkg1ditJaFFic1ZrWkduUXZxSkRW?=
 =?utf-8?B?amRYRnRFbyt3Tk05M2EybTA4NlBNZXREVmhyNkpkOThVMm5oK3B5eXE5Zkpm?=
 =?utf-8?B?K0xLcm13elpzNG94cHRXTEUyMkJEVzE0T1VCek5NM3M1WExEaXBRamV3SlRp?=
 =?utf-8?B?bTNkTm5TZlI1SFRoZTdRMUZwM1FxSDdWcDlKMkNCUTNkcks3Y1Vpc2ZHZFlL?=
 =?utf-8?B?YU5RRE9OaDhqZndLbGpqanA0NGhJc2xQb2puRXlkVmdadXhjZUZYbFlqdUdz?=
 =?utf-8?Q?xe7zQGLkTizhMptrkGyKqzy12?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 30718b09-045a-4b07-4871-08da915f7c8c
X-MS-Exchange-CrossTenant-AuthSource: PH7PR12MB5712.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Sep 2022 06:00:52.5241
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: aX/4fMnwxuG4smMJWrnCPoZixZor57+SEodkvRFgh8rA66ruuFAbbjmE0/lSkuge/oD9EX8418my5omwsVPW8w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR12MB5789
X-Spam-Status: No, score=-6.3 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 9/7/2022 12:09 PM, Like Xu wrote:
> On 7/9/2022 1:52 pm, Sandipan Das wrote:
>> On 9/7/2022 9:41 AM, Jim Mattson wrote:
>>> On Tue, Sep 6, 2022 at 8:59 PM Like Xu <like.xu.linux@gmail.com> wrote:
>>> [...]
>>>>>>>> diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
>>>>>>>> index 75dcf7a72605..08a29ab096d2 100644
>>>>>>>> --- a/arch/x86/kvm/cpuid.c
>>>>>>>> +++ b/arch/x86/kvm/cpuid.c
>>>>>>>> @@ -1094,7 +1094,7 @@ static inline int __do_cpuid_func(struct kvm_cpuid_array *array, u32 function)
>>>>>>>>                    entry->edx = 0;
>>>>>>>>                    break;
>>>>>>>>            case 0x80000000:
>>>>>>>> -               entry->eax = min(entry->eax, 0x80000021);
>>>>>>>> +               entry->eax = min(entry->eax, 0x80000022);
>>>>>>>>                    /*
>>>>>>>>                     * Serializing LFENCE is reported in a multitude of ways, and
>>>>>>>>                     * NullSegClearsBase is not reported in CPUID on Zen2; help
>>>>>>>> @@ -1203,6 +1203,25 @@ static inline int __do_cpuid_func(struct kvm_cpuid_array *array, u32 function)
>>>>>>>>                    if (!static_cpu_has_bug(X86_BUG_NULL_SEG))
>>>>>>>>                            entry->eax |= BIT(6);
>>>>>>>>                    break;
>>>>>>>> +       /* AMD Extended Performance Monitoring and Debug */
>>>>>>>> +       case 0x80000022: {
>>>>>>>> +               union cpuid_0x80000022_eax eax;
>>>>>>>> +               union cpuid_0x80000022_ebx ebx;
>>>>>>>> +
>>>>>>>> +               entry->eax = entry->ebx = entry->ecx = entry->edx = 0;
>>>>>>>> +               if (!enable_pmu)
>>>>>>>> +                       break;
>>>>>>>> +
>>>>>>>> +               if (kvm_pmu_cap.version > 1) {
>>>>>>>> +                       /* AMD PerfMon is only supported up to V2 in the KVM. */
>>>>>>>> +                       eax.split.perfmon_v2 = 1;
>>>>>>>> +                       ebx.split.num_core_pmc = min(kvm_pmu_cap.num_counters_gp,
>>>>>>>> +                                                    KVM_AMD_PMC_MAX_GENERIC);
>>>>>>>
>>>>>>> Note that the number of core PMCs has to be at least 6 if
>>>>>>> guest_cpuid_has(vcpu, X86_FEATURE_PERFCTR_CORE). I suppose this leaf
>>>>>>> could claim fewer, but the first 6 PMCs must work, per the v1 PMU
>>>>>>> spec. That is, software that knows about PERFCTR_CORE, but not about
>>>>>>> PMU v2, can rightfully expect 6 PMCs.
>>>>>>
>>>>>> I thought the NumCorePmc number would only make sense if
>>>>>> CPUID.80000022.eax.perfmon_v2
>>>>>> bit was present, but considering that the user space is perfectly fine with just
>>>>>> configuring the
>>>>>> NumCorePmc number without setting perfmon_v2 bit at all, so how about:
>>>>>
>>>>> CPUID.80000022H might only make sense if X86_FEATURE_PERFCTR_CORE is
>>>>> present. It's hard to know in the absence of documentation.
>>>>
>>>> Whenever this happens, we may always leave the definition of behavior to the
>>>> hypervisor.
>>>
>>> I disagree. If CPUID.0H reports "AuthenticAMD," then AMD is the sole
>>> authority on behavior.
> 
> The real world isn't like that, because even AMD has multiple implementations in cases
> where the hardware specs aren't explicitly stated, and sometimes they're intentionally vague.
> And the hypervisor can't do nothing, it prefers one over the other and maintains maximum compatibility with the legacy user space.
> 
>>>
>>
>> I understand that official documentation is not out yet. However, for Zen 4
>> models, it is expected that both the PerfMonV2 bit of CPUID.80000022H EAX and
>> the PerfCtrExtCore bit of CPUID.80000001H ECX will be set.
> 
> Is PerfCtrExtCore a PerfMonV2 or PerfMonV3+ precondition ?
> Is PerfCtrExtCore a CPUID.80000022 precondition ?
> 
> Should we always expect CPUID_Fn80000022_EBX.NumCorePmc to reflect the real
> Number of Core Performance Counters regardless of whether PerfMonV2 is set ?
> 

This is the suggested method for detecting the number of counters:

  If CPUID Fn8000_0022_EAX[PerfMonV2] is set, then use the new interface in
  CPUID Fn8000_0022_EBX to determine the number of counters.

  Else if CPUID Fn8000_0001_ECX[PerfCtrExtCore] is set, then six counters
  are available.

  Else, four legacy counters are available.

There will be an APM update that will have this information in the
"Detecting Hardware Support for Performance Counters" section.

>>
>>>>>
>>>>>>           /* AMD Extended Performance Monitoring and Debug */
>>>>>>           case 0x80000022: {
>>>>>>                   union cpuid_0x80000022_eax eax;
>>>>>>                   union cpuid_0x80000022_ebx ebx;
>>>>>>                   bool perfctr_core;
>>>>>>
>>>>>>                   entry->eax = entry->ebx = entry->ecx = entry->edx = 0;
>>>>>>                   if (!enable_pmu)
>>>>>>                           break;
>>>>>>
>>>>>>                   perfctr_core = kvm_cpu_cap_has(X86_FEATURE_PERFCTR_CORE);
>>>>>>                   if (!perfctr_core)
>>>>>>                           ebx.split.num_core_pmc = AMD64_NUM_COUNTERS;
>>>>>>                   if (kvm_pmu_cap.version > 1) {
>>>>>>                           /* AMD PerfMon is only supported up to V2 in the KVM. */
>>>>>>                           eax.split.perfmon_v2 = 1;
>>>>>>                           ebx.split.num_core_pmc = min(kvm_pmu_cap.num_counters_gp,
>>>>>>                                                        KVM_AMD_PMC_MAX_GENERIC);
>>>>>>                   }
>>>>>>                   if (perfctr_core) {
>>>>>>                           ebx.split.num_core_pmc = max(ebx.split.num_core_pmc,
>>>>>>                                                        AMD64_NUM_COUNTERS_CORE);
>>>>>>                   }
>>>>>
>>>>> This still isn't quite right. All AMD CPUs must support a minimum of 4 PMCs.
>>>>
>>>> K7 at least. I could not confirm that all antique AMD CPUs have 4 counters w/o
>>>> perfctr_core.
>>>
>>> The APM says, "All implementations support the base set of four
>>> performance counter / event-select pairs." That is unequivocal.
>>>
>>
>> That is true. The same can be inferred from amd_core_pmu_init() in
>> arch/x86/events/amd/core.c. If PERFCTR_CORE is not detected, it assumes
>> that the four legacy counters are always available.
>>
>> - Sandipan

