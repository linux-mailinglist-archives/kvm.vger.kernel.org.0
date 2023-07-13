Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 43116751681
	for <lists+kvm@lfdr.de>; Thu, 13 Jul 2023 04:51:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233393AbjGMCvR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 12 Jul 2023 22:51:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60816 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232177AbjGMCvP (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 12 Jul 2023 22:51:15 -0400
Received: from NAM04-MW2-obe.outbound.protection.outlook.com (mail-mw2nam04olkn2093.outbound.protection.outlook.com [40.92.46.93])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 88B3010EC;
        Wed, 12 Jul 2023 19:51:13 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=GBzRfny5GKCVQ1l1mVhDBwHessVLUabLw5ihsrdAnZ++4huvEGoI5GhcS34QBH3CsN/9vcCjypegayz0aPwNYmMm8FfbHkETo4vfqzkwhckI//QR846iquSxllXxor29uZZjDRDrBDTuX3w2HTcuMpGenhSzCJ/tes4vVNjRIZihzAsGBjyMqLoWSw5pw2Rs/UPFdSf93AjCJyK0R4eD7HAUNtr4LwpD+qfkH9cYQMBKxdDLIEMT78sWUlElsevhGxvrHT9iGLYlMrHBNJlk9eLq2idCum78Pp8kd2Q2FyDXIslXHWh6uUyZievNhm1VQsyGcub2Ffp0QAl0F/fINA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=/15EdV7BMBHgbrev1nKI6E/E57sDufhDSx8PjIkZews=;
 b=N/K64AB+7F3ZzzE+2UvKR34ZsO0S0gXWE6Wnz2RPg2V2FGvqnSy4BbKcVQxekGY/GiIcmtSw+79Q8p2UXgre8aZrdLj0aWuWzx4Abu3bzcMKNO+3+XvAiIA51Kg1Vh4i3eofEa/Oa/xSOBiNtcEWT9ao6gwOipaMreCOtiO/EcNssFCLxtabL3cwcnuapn16z7imd/mqxFpKuDFxJ/LnjJBHbBsVHfl9Qo/LG0XUeVu72/fc6+H7PTw/phS5h9pg9Z89pUQ8IJz8hD/hY7wl55oaVn7hSoVore6411U5/18jL9SZUWo5TjJD+sgqol8FvkwPAj4T3fg8Sycfqpnzxg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=outlook.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/15EdV7BMBHgbrev1nKI6E/E57sDufhDSx8PjIkZews=;
 b=HqXVBGS+EpmtJ0oKForrKaZnkRZE1Ajt//RVrnS5zwCjQgZh16na1Yoa7uIM5NWJ8kBpoZF5UKUUiRb5NZPRQsWlblOLdQSqZT+8Ys0OVPYPwTILGVv8RSvMnB1IXTb/HXtJGD8urKVfHOgsKXWcGW97/AmGCwGLDop5+a6J3fMtj2MbrNqrymVUBi0oumgqt9TD0j3vonMxrg8HOhHYYFnQ9Hbu357hWdqypZOXRIUDVRrcE/j68KNDELC+I6A8aPnXBcbpthQSRnpprXFoGGKPJ6NJT07nS7Our7ZhCo8Vh19snXq1XdOfqFVPM/3Up9tdbY/KMAgJVqyJAKXPBQ==
Received: from BYAPR03MB4133.namprd03.prod.outlook.com (2603:10b6:a03:7d::19)
 by BLAPR03MB5540.namprd03.prod.outlook.com (2603:10b6:208:296::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6565.31; Thu, 13 Jul
 2023 02:51:11 +0000
Received: from BYAPR03MB4133.namprd03.prod.outlook.com
 ([fe80::8e5a:85a7:372b:39c3]) by BYAPR03MB4133.namprd03.prod.outlook.com
 ([fe80::8e5a:85a7:372b:39c3%6]) with mapi id 15.20.6588.022; Thu, 13 Jul 2023
 02:51:10 +0000
Subject: Re: [RFC 0/3] KVM: x86: introduce pv feature lazy tscdeadline
To:     Zhi Wang <zhi.wang.linux@gmail.com>
Cc:     seanjc@google.com, tglx@linutronix.de, mingo@redhat.com,
        bp@alien8.de, dave.hansen@linux.intel.com, x86@kernel.org,
        hpa@zytor.com, kvm@vger.kernel.org, arkinjob@outlook.com,
        linux-kernel@vger.kernel.org
References: <BYAPR03MB4133436C792BBF9EC6D77672CD2DA@BYAPR03MB4133.namprd03.prod.outlook.com>
 <20230712211453.000025f6.zhi.wang.linux@gmail.com>
From:   Wang Jianchao <jianchwa@outlook.com>
Message-ID: <BYAPR03MB4133E3A1487ED160FBB59E0CCD37A@BYAPR03MB4133.namprd03.prod.outlook.com>
Date:   Thu, 13 Jul 2023 10:50:36 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
In-Reply-To: <20230712211453.000025f6.zhi.wang.linux@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-TMN:  [Xi9tgcV33Pp00/w9nDLSeDSzNKKrEnvH]
X-ClientProxiedBy: TYWPR01CA0021.jpnprd01.prod.outlook.com
 (2603:1096:400:aa::8) To BYAPR03MB4133.namprd03.prod.outlook.com
 (2603:10b6:a03:7d::19)
X-Microsoft-Original-Message-ID: <f2c8fe5f-c14d-0d3b-3acd-b693b4eff789@outlook.com>
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BYAPR03MB4133:EE_|BLAPR03MB5540:EE_
X-MS-Office365-Filtering-Correlation-Id: 95c5a117-966a-43de-8793-08db834c0380
X-MS-Exchange-SLBlob-MailProps: WaIXnCbdHrPfHmnrCCekJJVeItfeyJ7botfuNWkHsHr/e3BNVf24PH10jl22vkgMqym0KWJehoej4V7IpLuu3M+kS6uXKJxbpjJSBl3o1amNgU/qKrKqGMxzYpMkZHpdcNG3fj2kXmk7wC+i9eDgTecvDVc3zobZ01RxuMyhB1kWNkDePd37gMDTnc2DqZT4HlxKqP5otMaZNHlzgxPla0o9m+3k1g6QEeRwqBNtxU5OCyXBIiHd/Eo/4pQjejbLrIbom129pz5pB/a0KPsZ82jgstsbTt7h354o+QMDGh3Tv+uE74PN1JYuzcsikidEG17F3M+Xv2PYiMBnSQX8+4Z7DnzLqUgcfhw6uF8vF48LqUHV5TUYP7ig4A3w3izdyBn37rIKv0hYfar8iXbf6tS03xgUWBu4m2qWFPQvP4tOnkxvP2ruMbbUc2FyMBUHbVo7Aaw/w17Gi/M9hXed/5xBYhzRsd25V7NFqrwAX98W05VKJtSb9rmkrNhd7taYuSaE9MWqGOTmiTpDIHJ9opM9dL0VCfalAelTXD+mW3w1eUTWCh/BAZZrmJbNvsx9izi7jxQdVnBCtkN/KGQV93+d3FVoF2ekUD9pZVnEyrvAZOFLusXFTZ9Z3a6TV6oEicMFq+UMZD4JiHsR7DHVsz5jOjo0jVaEgpQ7yUui4Sc+id/g7f8A9KJn8WprbzaIJfQPmRtqaJAwLuD8j+EpOzutPx8uxU7D0Tbhx0QkQuySy+9Kl8xYqHmDpffI/tywEPhYzidEGrk=
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: j+J4sNhLnoPdtqxRdlBjvwcDIHUFa4VX8o7HbJi3ht4m30yoBYMf5K5NPayBlxw5kLjY4lV347evKeMJE4R4p7OwxkLSgS47ObkDVPatXIbFvdN+3iMZ5/jJkpIFR9E7BIc7EbZ5wwP29THd1ryc5B6uwhDyrk3j+daRW667HGr1Qt8gl/XcEONsBIc8stkX7Hbvx6VV8EvdBffalXY2do9IiD80dLR2nb1fWIkFIUxFNj0vYnvaWn2n6bIqvkboXl/dJ7ZrX2X83AE5vRToxThk8cysreQaRH75ar+JxAdkk7pYDSc9r/axORW/AWK1t7z/a9KZMrE0IZEK8L71Gl5TDfJ5a2dwHAAWq5SpOs64f5MZut6nQMOGpItBGOebx4ntcZiUfS0lmh9BGKE+V/DPBMT4NruVq3mGIWBACHKrGH5lYn3BHVonoqJ6KfgZgfkgr/kVvb8udtf4v1ByR4HNkBKdMFgXORpj07GuM+GMohjEQPTiUKmXIaMih8MYFlafTKKnVQMSDvQ2iOOwbt0Pzqcv548EYTDeP/RBbMJxK0Kdn95xDM6QCI3D/1+C
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?czV6MG5JWEg2SUI5QWtGbjlIT01LSHpuaGs1MS9TNFh4d0xNNWdFd2JnQTRE?=
 =?utf-8?B?MnMwalVkMUtXbzV1NjRIR3AyK1haQ0x0eFp2a01HRDlyNnhzYmNjWGFGbGRl?=
 =?utf-8?B?SjlFOThGUktjWFZ4WVptYkpEMFNDN3U4L0F5Wm5BdUlrWTVSN3U2NzBIaGRM?=
 =?utf-8?B?VTcyb0pWMlI1bWE1L25PdUlZb1Z1NzhnNjgxQXRXM3pCR3gwSC9EQ2FZTlJP?=
 =?utf-8?B?QTRwVnpkcmV6MHUzZVp1WEZGSDJDT2V3T2h5dDFsTkdjd2FRclEzZUkxYXJm?=
 =?utf-8?B?ZUFIeHBBSXlCY3orV2E4Q3Rnd3dJUzcwaW5HTFg0VUU2UHBGOGFEbGVLYmVy?=
 =?utf-8?B?NzIrMDlnOUlscjRvUlV2dko5QWRxU0l1azgzeFFPdFNhK2RtRW1sZjdxSCtq?=
 =?utf-8?B?dVRscWwzS3Q0VWNaY241NUNnUVVDS2ZEcE9ENlVNRUFkUCs1eklKREJ6RHpp?=
 =?utf-8?B?WEFsU2RNOEVrcmNVU3dvN1FMaGR0aTNJTFViRWJaRFFYODZsalJPcXUwQkk2?=
 =?utf-8?B?dHZrTWN3MXdGRS80b3d0aTRqMVM5Tm91d3UybE55cHI1Tkw3aWpuSlhuaFhD?=
 =?utf-8?B?MTNLZE1FQ1FGc01LNWxoRm82MlpVZnhXcGt4OS96YnJoTzMrMUFDOE1aTjkw?=
 =?utf-8?B?MHEycGx3QzVUSjByTGdaQWRhMTMrRzZmVnZmQW55N2txQmJnZjk4c0I2VUxB?=
 =?utf-8?B?WnBmeTdiSzRNK0MzN2ZxdXgrT2ZkOXpuZit2OEdMK2FlSC96S1RLdU1kQ0xV?=
 =?utf-8?B?aXlrN3prRWNkZy9IWFpnNUdNekIraEJZM0luYXpFZDIxV0lFMGpxQWRYL1dq?=
 =?utf-8?B?U3NKZXA0eGlYOW1zM1NnaUJhWTNOTUd4QkUvb2t2SmZYUUJTcUppbjBxYWdH?=
 =?utf-8?B?U0NOSHJNMFBEM2lGMlIwczArK25qVkFXd05uRHpLdkhqYXFYNTEyL2NKdmZr?=
 =?utf-8?B?eFlVT3hia0hPMGdRQ3dkd0N2OGhZWE5xQnNuUFZrV0h5RzljZDBPQ1FEdk0w?=
 =?utf-8?B?UExET0pWZDRUM29vVFdmNlh1WHcwYzNKbjRNYTBXRjlvaldMVG83WUZpSTd0?=
 =?utf-8?B?bVluQzZUcUYybThGMG1DRlE3SjlqZ3ZsV2JBSGl4Z3BQNlp6ODRKZkk0eFYr?=
 =?utf-8?B?UnhCd0RyRkllU0IyYnREM25jZjdxdm9adlJNZi9HZVRSN2ozTlhpTWcvZEJP?=
 =?utf-8?B?bUQ4SEhrQS9OTUxDTURFNTZOUWVUeWczSTB0MTB1Z0owSTBFeXgwSnB2b20y?=
 =?utf-8?B?TWR5bWVGV1N5L3ZOTXhBMkZTNENnVjREVXZ4UTZTckpVT21kY3Jva21ScENu?=
 =?utf-8?B?VkluSUFoZkFHSHU5K0FjdDJEcldiS3IzZlpwdktXMmdaRWdSTzVmTUd3aHlj?=
 =?utf-8?B?NHN0UnBYU2JJc2gzd2NGVk02dlBaZjRvbVgxU1lkY1FQVjJ6YVc3SnVmd05N?=
 =?utf-8?B?aHE2Z2NkRXo4K2hMbWUwd1MrVjh5RFpKeHhSelg3YWZrajh3NTRxQlpZWjda?=
 =?utf-8?B?bEFRNUx3aXlMOWo5L3p0d0Uyc0V3dzFKTWs5TjlxcEZvM3VaUjVGZUo5QzBq?=
 =?utf-8?B?SmlwRjhZODMxdXRVUFBYb2dmUktsanM5ME5XbTc5TVplWTVyVzVBMERWNERF?=
 =?utf-8?Q?y1jvq/uSVjIIG4GzrDW7DwVPc0zRYiFF2VmeInEfrbl4=3D?=
X-OriginatorOrg: outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 95c5a117-966a-43de-8793-08db834c0380
X-MS-Exchange-CrossTenant-AuthSource: BYAPR03MB4133.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Jul 2023 02:51:10.6322
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 84df9e7f-e9f6-40af-b435-aaaaaaaaaaaa
X-MS-Exchange-CrossTenant-RMS-PersistedConsumerOrg: 00000000-0000-0000-0000-000000000000
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BLAPR03MB5540
X-Spam-Status: No, score=0.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_MUA_MOZILLA,
        FREEMAIL_FROM,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,
        SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 2023.07.13 02:14, Zhi Wang wrote:
> On Fri,  7 Jul 2023 14:17:58 +0800
> Wang Jianchao <jianchwa@outlook.com> wrote:
> 
>> Hi
>>
>> This patchset attemps to introduce a new pv feature, lazy tscdeadline.
>> Everytime guest write msr of MSR_IA32_TSC_DEADLINE, a vm-exit occurs
>> and host side handle it. However, a lot of the vm-exit is unnecessary
>> because the timer is often over-written before it expires. 
>>
>> v : write to msr of tsc deadline
>> | : timer armed by tsc deadline
>>
>>          v v v v v        | | | | |
>> --------------------------------------->  Time  
>>
>> The timer armed by msr write is over-written before expires and the
>> vm-exit caused by it are wasted. The lazy tscdeadline works as following,
>>
>>          v v v v v        |       |
>> --------------------------------------->  Time  
>>                           '- arm -'
>>
> 
> Interesting patch.
> 
> I am a little bit confused of the chart above. It seems the write of MSR,
> which is said to cause VM exit, is not reduced in the chart of lazy
> tscdeadline, only the times of arm are getting less. And the benefit of
> lazy tscdeadline is said coming from "less vm exit". Maybe it is better
> to imporve the chart a little bit to help people jump into the idea
> easily?

Thanks so much for you comment and sorry for my poor chart.

Let me try to rework the chart.

Before this patch, every time guest start or modify a hrtimer, we need to write the msr of tsc deadline,
a vm-exit occurs and host arms a hv or sw timer for it.


w: write msr
x: vm-exit
t: hv or sw timer


Guest
         w       
--------------------------------------->  Time  
Host     x              t         
 

However, in some workload that needs setup timer frequently, msr of tscdeadline is usually overwritten
many times before the timer expires. And every time we modify the tscdeadline, a vm-exit ocurrs


1. write to msr with t0

Guest
         w0         
---------------------------------------->  Time  
Host     x0             t0     

 
2. write to msr with t1
Guest
             w1         
------------------------------------------>  Time  
Host         x1          t0->t1     


2. write to msr with t2
Guest
                w2         
------------------------------------------>  Time  
Host            x2          t1->t2     
 

3. write to msr with t3
Guest
                    w3         
------------------------------------------>  Time  
Host                x3           t2->t3     



What this patch want to do is to eliminate the vm-exit of x1 x2 and x3 as following,


Firstly, we have two fields shared between guest and host as other pv features, saying,
 - armed, the value of tscdeadline that has a timer in host side, only updated by __host__ side
 - pending, the next value of tscdeadline, only updated by __guest__ side


1. write to msr with t0

             armed   : t0
             pending : t0
Guest
         w0         
---------------------------------------->  Time  
Host     x0             t0     

vm-exit occurs and arms a timer for t0 in host side

 
2. write to msr with t1

             armed   : t0
             pending : t1

Guest
             w1         
------------------------------------------>  Time  
Host                     t0    

the value of tsc deadline that has been armed, namely t0, is smaller than t1, needn't to write
to msr but just update pending


3. write to msr with t2

             armed   : t0
             pending : t2
 
Guest
                w2         
------------------------------------------>  Time  
Host                      t0  
 
Similar with step 2, just update pending field with t2, no vm-exit


4.  write to msr with t3

             armed   : t0
             pending : t3

Guest
                    w3         
------------------------------------------>  Time  
Host                       t0
Similar with step 2, just update pending field with t3, no vm-exit


5.  t0 expires, arm t3

             armed   : t3
             pending : t3


Guest
                            
------------------------------------------>  Time  
Host                       t0  ------> t3

t0 is fired, it checks the pending field and re-arm a timer based on it.


Here is the core ideal of this patch ;)


Thanks
Jianchao

> 
>> The 1st timer is responsible for arming the next timer. When the armed
>> timer is expired, it will check pending and arm a new timer.
>>
>> In the netperf test with TCP_RR on loopback, this lazy_tscdeadline can
>> reduce vm-exit obviously.
>>
>>                          Close               Open
>> --------------------------------------------------------
>> VM-Exit
>>              sum         12617503            5815737
>>             intr      0% 37023            0% 33002
>>            cpuid      0% 1                0% 0
>>             halt     19% 2503932         47% 2780683
>>        msr-write     79% 10046340        51% 2966824
>>            pause      0% 90               0% 84
>>    ept-violation      0% 584              0% 336
>>    ept-misconfig      0% 0                0% 2
>> preemption-timer      0% 29518            0% 34800
>> -------------------------------------------------------
>> MSR-Write
>>             sum          10046455            2966864
>>         apic-icr     25% 2533498         93% 2781235
>>     tsc-deadline     74% 7512945          6% 185629
>>
>> This patchset is made and tested on 6.4.0, includes 3 patches,
>>
>> The 1st one adds necessary data structures for this feature
>> The 2nd one adds the specific msr operations between guest and host
>> The 3rd one are the one make this feature works.
>>
>> Any comment is welcome.
>>
>> Thanks
>> Jianchao
>>
>> Wang Jianchao (3)
>> 	KVM: x86: add msr register and data structure for lazy tscdeadline
>> 	KVM: x86: exchange info about lazy_tscdeadline with msr
>> 	KVM: X86: add lazy tscdeadline support to reduce vm-exit of msr-write
>>
>>
>>  arch/x86/include/asm/kvm_host.h      |  10 ++++++++
>>  arch/x86/include/uapi/asm/kvm_para.h |   9 +++++++
>>  arch/x86/kernel/apic/apic.c          |  47 ++++++++++++++++++++++++++++++++++-
>>  arch/x86/kernel/kvm.c                |  13 ++++++++++
>>  arch/x86/kvm/cpuid.c                 |   1 +
>>  arch/x86/kvm/lapic.c                 | 128 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++------
>>  arch/x86/kvm/lapic.h                 |   4 +++
>>  arch/x86/kvm/x86.c                   |  26 ++++++++++++++++++++
>>  8 files changed, 229 insertions(+), 9 deletions(-)
> 
