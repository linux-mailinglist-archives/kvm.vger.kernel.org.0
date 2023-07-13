Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 90ED1751FDA
	for <lists+kvm@lfdr.de>; Thu, 13 Jul 2023 13:25:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232802AbjGMLZJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 13 Jul 2023 07:25:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34528 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231693AbjGMLZH (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 13 Jul 2023 07:25:07 -0400
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11olkn2094.outbound.protection.outlook.com [40.92.19.94])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 28AE626A1;
        Thu, 13 Jul 2023 04:25:06 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=S5k1sCrOcR+eVdEefIyz62+JSAA5bQtC4NZXm2YvfwBNcqcMqRIDAJ7rvSaXgDCCW4hzB1EICBa/6ZeZR/QuCbaXc52LvroQNx7QK4uZ32E1qaIimpoUzX6u4Fn8iXk2BWkAneg7DdTsm7w9WrYH6qVZKThw1rbLKny4EZWf4nlwaWAjmVEoO7HVo799PNHTwKG2CysfRoUR7FB0XkNpGnZGwzu5ifLCPcst3HOSzOMp0CwCdb6ZYsfCjElOcemwbpE5BbLOATzqkE8P38RHAFfAuxwi89RSL6TXbfYFlfZ2zB4FZnnld7vRo21589FoNQZgLVng3OsUKxtuHNbS2Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=EUp735ezLrpfaCtn8iocDk+bEFmiTmz0NOQLD1NGQJ4=;
 b=PuFyBMI8r+LU5w5hoffskTA+cz7Cup6aSodMxOR9QPI6DccG/LlKr7b3MIcwzeezrs+szpfuck7uuin2it+mZ9riBtOHU0/aqyS/EctluuYFFADg1PcXFe4y/UR/0UFijzTvA2ZXI+SvE8DXvExKutqvBOIMojezJXXoXCNdH4pEUnLcD5+d6hFhU4HNgEeI/BT7J2q0XwwkWjnmO8xY75/6W1WNLXX+ZzxZiB8mjcugyjv2p4W8cQrtoFzi17hqQ9z1E+1V+nG5NXPmQ4Ho+Z2paGhy1C3gU+llibgg0p4Srp62CihrLnCAiYkYi2eQSR9hXs8IiwlEd3xFAlR3Jw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=outlook.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=EUp735ezLrpfaCtn8iocDk+bEFmiTmz0NOQLD1NGQJ4=;
 b=j3986HuxR9c7/0I5DC5cozQT3lWYef90ZOIurLsTLF1Eci0FovJFw/D0LfA7x8d+ID/fCx3EC59vpmeQKv58Jd5ACQf/niUn7ONxj0qpM6IZrT48HcFpckXmavqP+BhPU+4kaIuBLrCviAj6iB2X4UlGV+YisSZRXoSJcq3mKRbgjvyicZ8MZtKr4V+UsbErqj8KktIpi2T2TZBWauXXacGjqkxlTYo4zIAYClg5AqrnzeQuI4sIwlU6IEuYGfV14+aVVSe0RdzV5IxeiRenAsi0nKyHPWcpo9sdKOj5SdJNUyhHWG1OA74P6uTCpwP3AKImxkc3eIom3sf2VQJYxA==
Received: from BYAPR03MB4133.namprd03.prod.outlook.com (2603:10b6:a03:7d::19)
 by SJ0PR03MB6763.namprd03.prod.outlook.com (2603:10b6:a03:40a::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6565.26; Thu, 13 Jul
 2023 11:25:04 +0000
Received: from BYAPR03MB4133.namprd03.prod.outlook.com
 ([fe80::8e5a:85a7:372b:39c3]) by BYAPR03MB4133.namprd03.prod.outlook.com
 ([fe80::8e5a:85a7:372b:39c3%6]) with mapi id 15.20.6588.022; Thu, 13 Jul 2023
 11:25:04 +0000
Subject: Re: [RFC 0/3] KVM: x86: introduce pv feature lazy tscdeadline
To:     Xiaoyao Li <xiaoyao.li@intel.com>,
        Zhi Wang <zhi.wang.linux@gmail.com>
Cc:     seanjc@google.com, tglx@linutronix.de, mingo@redhat.com,
        bp@alien8.de, dave.hansen@linux.intel.com, x86@kernel.org,
        hpa@zytor.com, kvm@vger.kernel.org, arkinjob@outlook.com,
        linux-kernel@vger.kernel.org
References: <BYAPR03MB4133436C792BBF9EC6D77672CD2DA@BYAPR03MB4133.namprd03.prod.outlook.com>
 <20230712211453.000025f6.zhi.wang.linux@gmail.com>
 <BYAPR03MB4133E3A1487ED160FBB59E0CCD37A@BYAPR03MB4133.namprd03.prod.outlook.com>
 <20230713095755.00003d27.zhi.wang.linux@gmail.com>
 <93e37735-f0d6-9603-615e-e17d59a7b537@intel.com>
From:   Wang Jianchao <jianchwa@outlook.com>
Message-ID: <BYAPR03MB41332D18C30341F8D35FAE2ECD37A@BYAPR03MB4133.namprd03.prod.outlook.com>
Date:   Thu, 13 Jul 2023 19:24:48 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
In-Reply-To: <93e37735-f0d6-9603-615e-e17d59a7b537@intel.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-TMN:  [9ZXnzksSj1uwTxUPJdP/HFjbE4c2KzOyHufPTXs6E+U=]
X-ClientProxiedBy: SI2PR02CA0040.apcprd02.prod.outlook.com
 (2603:1096:4:196::6) To BYAPR03MB4133.namprd03.prod.outlook.com
 (2603:10b6:a03:7d::19)
X-Microsoft-Original-Message-ID: <1f8c2c15-55e3-4e08-9c2e-e73c7280723d@outlook.com>
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BYAPR03MB4133:EE_|SJ0PR03MB6763:EE_
X-MS-Office365-Filtering-Correlation-Id: 3fc786bf-abfa-4534-1165-08db8393cdaf
X-MS-Exchange-SLBlob-MailProps: Cq7lScuPrnpRiBCNjHstdpiJs+aCKuFNY1a62yxnEDXMzTQZC+qXpt7t03HwKPlCn8LQqfs/KKkiOba0LHAXQQD+Sx4YhiL+dGd7DjaDXpMwPY/kZ1MaTzdn6w/ColOrlT6LOaYImH2firL2Kwbi0xzsUlWO8m8Bx374BDq2X/IWGKHV5+HTE0cW8a/8NoBJVmYr7nZZUcqqZpQyYC54qHBGEmp6CKirMfO5HJRRxwmZVnv/iRUgnq2mqfaWGjM+I8NNFExUW98i0E8eciIwfDcNNOeUlVDxyzDduY0N667kCTP/kjQKJxeMdVZ0tI4PHFrJ7YKPqDzYIDslK0LjetQLo62639DxdiSokKm80ZyC7b35wYT7MaMlyKJSovGI7/XXw4a9dawUovJBrIm8K3UH6xkwWZrlzQ5LrzfynpA7hTaCyHT0MeobN/jsaGBpW7p1tBvQpIwrxi1OcaDSOBN/2/vSdgGp2V7nYbsEyY8Yrh/sAoG/FUAITv+/X5A5zNYvcdIVH+x6nBFQtID6DrCyu8N5kkSBwuG/Dj4y9QcyhSNyALUSIuVZHWQFHwioFoemUtgg7hlZGSO+Y0j7AFkIL6dqO5SM8PQRIdk206k7ZYHKBSeU8fzovmh2aCc5dJ4TgkIgPp0A1YF4RdvdETYwB7mdIPUqZh9on3oYZBIqvorXDlB3Se3ME93/kES/K8AH/eA/BUje6Xv9newy0CojSobxampA2mo6ZV+lVrvAnp2arTNS+u/4ayaNAUT/uMM9oMm2c6s=
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 6kkcN/+YtmgjHq07Q7EbKs15lPhhpAdFG9InCdCquw38j3yGiyEhLXLUN2h29vjW/AeDP4po36XY8hgyOdQ9Xt44uPnh7Q72o+3pxyB0sySeFCybaK3BKAgRPZu6dr4DjxTkOu8ksgOwq5LG4rg8p+7pE/DOK2KmiWC9l/UfL3JnEeL3Ry43UtlXh8VUZdMwZInhFPEe3Iv2ohJNqb/5fDtI3K3ahp77K0u03E1GaKgIrQElzXYSkr4zz6RNX95gp5VLAhJQpOjFirXMs8o4SB0PeIsbh3jTWp35bBvOeOziUPnnm6wtbWGWmb10TpmGfGdbFN6p0mP9n0ZRspa8lGHRiB/EJ66Cj93eNb5VGDuGC0vNay1VIEG9cNXFBCdoJJrnglTNQw9H9NRzXJ17lUH/zdoqvmLGMyEDIIwltUzOchrRSp3zPEFyA3Vm1i+W23iwrXzkTk3PYOtFq6iEYAXSMWNzIYUqyiGoeeGqSMgOSSbmyUI7uiTX4qJLM4WuOvNSW1AIpe4Qs4te0sjlM2HwvVIJmKP9PrcDPzQi3vkeBA+jmrTP5VACsDMgnE/I
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?VXFoWXdGMjRRVzl5QnBac2dnOFVvQWxMb0hXWFpZTHJWUWVGYVVtZ2hZZlIz?=
 =?utf-8?B?VENXNzNra2tpUUtrc3lGRFJpR0F6bUpXWlZGaCtSMlBWS2ZyY3BkMGJuT3hy?=
 =?utf-8?B?dUlPQ2g1eHlGbG96amVIL0lVbFpTdW1ldllHQjB1QS9Nc2F3dUk0Z0Eva3hU?=
 =?utf-8?B?NXBRR01OcUU4cEJOa3hWK3RxQk0xdVRtc1Rjb2dJVE9hdUNkVGxIbVN0cmtO?=
 =?utf-8?B?K1NIS0NJS2N1M1RqbVlOcStUVGNYSXdlemI1WllSaks5VzZVMkhHa1Z3YS9v?=
 =?utf-8?B?dURZcGtDd0V4cXd3QTBwZGtFcURyZUozS2tVSkdiTENqSnpndUJGODVyckhV?=
 =?utf-8?B?cEVucHB0VTZpTWVkbDNibENFL2p1ejRPZC9pZGF6cDZldFl2MWpqNFhveHZs?=
 =?utf-8?B?SXFFVVRyRzI1NUt4UU9SaVNUa1VRMFU4ZmhlRWo1bmhSdGIyVjFnaTFsNmF4?=
 =?utf-8?B?SmltdzJuckFWcHFLZEsxem8rSGh1K3dyTU1jajZGUFdxUlZJWmQ0Nmc3L0FZ?=
 =?utf-8?B?QXFQM29GTW11cnNBZVhESjdvRFB0MHVreENsT2tKdjcvNVNQUms2NTlodDZO?=
 =?utf-8?B?YnhFbHlJdml1ZlF4QmZrV3VuUGs5eEUrRUNtcE5uWUR1Nk5NS1hNZ1VxK2Fx?=
 =?utf-8?B?MUxZd0lrL1FqTEt2Q2JtNjRZbjlUU3Z2V1RhUFp4Y2x5WEdWbi9qMEkzNTYy?=
 =?utf-8?B?cnk1cGtyNzBlOWI4MU8wcGZWQ1ZOeWxxWldndG0yN3FMdlA2b252ZjZQWmlG?=
 =?utf-8?B?QzhUZm5sMkQrOVYxaXBXVHcvRFNYQmwvR2JhY25ZSTd0VEI0azNNcjB6SGla?=
 =?utf-8?B?U0hjSlZlZzBJcUpFWWkycURrVG05amxsTjF5MWZmNzNrd3d0MnNvNitGemVD?=
 =?utf-8?B?c05pZVk2Q1VRZ3FGVGhMV1R1bEUzUGdISThFZ1hCSGNmczc1Y1JBMXhXcFpM?=
 =?utf-8?B?R2trR2U2MWphbkUyNHhhRVNnZzJ0UklDZW5zak9ZcjIvV1B5UG92aDZzUmZl?=
 =?utf-8?B?Wkx2cityU202amc2eG9ML0x5ZnNCNlFTMmdBTHFXcGlPL0NhQzRkUDU5VTI5?=
 =?utf-8?B?c3VZdzNxKzNyLzRoRGdnVzA3TGpETHBjVmpodHh3azd3RDRjUkdlRjhqNi9N?=
 =?utf-8?B?Qjg1M0JFcWIvOTIrdUFHN2RiUVJoZEhFV0tlL0xLQnMxcU9XNmwxa0xXVWcr?=
 =?utf-8?B?UllWYTdFQVRFK1QrMXhtLzd1NkJuTkZmUEp2ZEN1d3ZSQ0JOdlFNSng5L3JZ?=
 =?utf-8?B?QkFkZlowaW05TTZndUhueDdMZ2dXSm1nNnJ4c0ttRENvNnVYUWRxajZFVngv?=
 =?utf-8?B?Nmk5d09RSURGMUZTdDBGUlo2dGZ4VXd2M05udEd3aUpLN0dDTHE3WWpCOTVv?=
 =?utf-8?B?S1FUSlllOTZNaHFWTnV4UUYrekkrMDl6YVZDOGhsek1kdUVJOXBDenZ6b1Jl?=
 =?utf-8?B?RzBVQ1hVTG1ZUHprc0hHSUROOFJQV2FEcnB1N2hHQTYvUk9YRGR4REtVbi9q?=
 =?utf-8?B?cHNQUTNhOEwzM2FyNTlOaDlnQlhsc3NMVndYREN1QkN1eGlQM1lIaXA0WWlG?=
 =?utf-8?B?V0U0NHBkRFF5QmNrRk1mTk9tdk11Wnd3VlphKy9rYk9XT0Fzby84MTUybUJO?=
 =?utf-8?Q?gKF98y3F8rcf4MzGg9sim1I0XB+xSqCvihVBkSrCo8LI=3D?=
X-OriginatorOrg: outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3fc786bf-abfa-4534-1165-08db8393cdaf
X-MS-Exchange-CrossTenant-AuthSource: BYAPR03MB4133.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Jul 2023 11:25:04.2211
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 84df9e7f-e9f6-40af-b435-aaaaaaaaaaaa
X-MS-Exchange-CrossTenant-RMS-PersistedConsumerOrg: 00000000-0000-0000-0000-000000000000
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR03MB6763
X-Spam-Status: No, score=0.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_MUA_MOZILLA,
        FREEMAIL_FROM,NICE_REPLY_A,RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H2,
        SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 2023.07.13 18:27, Xiaoyao Li wrote:
> On 7/13/2023 2:57 PM, Zhi Wang wrote:
>> On Thu, 13 Jul 2023 10:50:36 +0800
>> Wang Jianchao <jianchwa@outlook.com> wrote:
>>
>>>
>>>
>>> On 2023.07.13 02:14, Zhi Wang wrote:
>>>> On Fri,  7 Jul 2023 14:17:58 +0800
>>>> Wang Jianchao <jianchwa@outlook.com> wrote:
>>>>
>>>>> Hi
>>>>>
>>>>> This patchset attemps to introduce a new pv feature, lazy tscdeadline.
>>>>> Everytime guest write msr of MSR_IA32_TSC_DEADLINE, a vm-exit occurs
>>>>> and host side handle it. However, a lot of the vm-exit is unnecessary
>>>>> because the timer is often over-written before it expires.
>>>>>
>>>>> v : write to msr of tsc deadline
>>>>> | : timer armed by tsc deadline
>>>>>
>>>>>           v v v v v        | | | | |
>>>>> --------------------------------------->  Time
>>>>>
>>>>> The timer armed by msr write is over-written before expires and the
>>>>> vm-exit caused by it are wasted. The lazy tscdeadline works as following,
>>>>>
>>>>>           v v v v v        |       |
>>>>> --------------------------------------->  Time
>>>>>                            '- arm -'
>>>>>
>>>>
>>>> Interesting patch.
>>>>
>>>> I am a little bit confused of the chart above. It seems the write of MSR,
>>>> which is said to cause VM exit, is not reduced in the chart of lazy
>>>> tscdeadline, only the times of arm are getting less. And the benefit of
>>>> lazy tscdeadline is said coming from "less vm exit". Maybe it is better
>>>> to imporve the chart a little bit to help people jump into the idea
>>>> easily?
>>>
>>> Thanks so much for you comment and sorry for my poor chart.
>>>
>>
>> You don't have to say sorry here. :) Save it for later when you actually
>> break something.
>>
>>> Let me try to rework the chart.
>>>
>>> Before this patch, every time guest start or modify a hrtimer, we need to write the msr of tsc deadline,
>>> a vm-exit occurs and host arms a hv or sw timer for it.
>>>
>>>
>>> w: write msr
>>> x: vm-exit
>>> t: hv or sw timer
>>>
>>>
>>> Guest
>>>           w
>>> --------------------------------------->  Time
>>> Host     x              t
>>>  
>>> However, in some workload that needs setup timer frequently, msr of tscdeadline is usually overwritten
>>> many times before the timer expires. And every time we modify the tscdeadline, a vm-exit ocurrs
>>>
>>>
>>> 1. write to msr with t0
>>>
>>> Guest
>>>           w0
>>> ---------------------------------------->  Time
>>> Host     x0             t0
>>>
>>>   2. write to msr with t1
>>> Guest
>>>               w1
>>> ------------------------------------------>  Time
>>> Host         x1          t0->t1
>>>
>>>
>>> 2. write to msr with t2
>>> Guest
>>>                  w2
>>> ------------------------------------------>  Time
>>> Host            x2          t1->t2
>>>  
>>> 3. write to msr with t3
>>> Guest
>>>                      w3
>>> ------------------------------------------>  Time
>>> Host                x3           t2->t3
>>>
>>>
>>>
>>> What this patch want to do is to eliminate the vm-exit of x1 x2 and x3 as following,
>>>
>>>
>>> Firstly, we have two fields shared between guest and host as other pv features, saying,
>>>   - armed, the value of tscdeadline that has a timer in host side, only updated by __host__ side
>>>   - pending, the next value of tscdeadline, only updated by __guest__ side
>>>
>>>
>>> 1. write to msr with t0
>>>
>>>               armed   : t0
>>>               pending : t0
>>> Guest
>>>           w0
>>> ---------------------------------------->  Time
>>> Host     x0             t0
>>>
>>> vm-exit occurs and arms a timer for t0 in host side
>>>
>>>   2. write to msr with t1
>>>
>>>               armed   : t0
>>>               pending : t1
>>>
>>> Guest
>>>               w1
>>> ------------------------------------------>  Time
>>> Host                     t0
>>>
>>> the value of tsc deadline that has been armed, namely t0, is smaller than t1, needn't to write
>>> to msr but just update pending
>>>
>>>
>>> 3. write to msr with t2
>>>
>>>               armed   : t0
>>>               pending : t2
>>>   Guest
>>>                  w2
>>> ------------------------------------------>  Time
>>> Host                      t0
>>>   Similar with step 2, just update pending field with t2, no vm-exit
>>>
>>>
>>> 4.  write to msr with t3
>>>
>>>               armed   : t0
>>>               pending : t3
>>>
>>> Guest
>>>                      w3
>>> ------------------------------------------>  Time
>>> Host                       t0
>>> Similar with step 2, just update pending field with t3, no vm-exit
>>>
>>>
>>> 5.  t0 expires, arm t3
>>>
>>>               armed   : t3
>>>               pending : t3
>>>
>>>
>>> Guest
>>>                              ------------------------------------------>  Time
>>> Host                       t0  ------> t3
>>>
>>> t0 is fired, it checks the pending field and re-arm a timer based on it.
>>>
>>>
>>> Here is the core ideal of this patch ;)
>>>
>>
>> That's much better. Please keep this in the cover letter in the next RFC.
>>
>> My concern about this approach is: it might slightly affect timing
>> sensitive workload in the guest, as the approach merges the deadline
>> interrupt. The guest might see less deadline interrupts than before. It
>> might be better to have a comparison of number of deadline interrupts
>> in the cover letter.
> 
> I don't think guest will get less deadline interrupts since the deadline is updated always before the timer expires.
> 
> However, host will get more deadline interrupt because timer for t0 is not disarmed when new deadline (t1, t2, t3) is programmed.
> 

I forget to avoid to inject local timer interrupt of t0 in this version. This will be modified in V3 patchset.
But there is still a vm-exit of preemption timer for t0 ...
The worst case is: guest program t0 t1, t1's vm-exit due to msr write is avoided but t0's preemption vm-exit replace it.
In the other case, there should be benefit of vm-exit.

Thanks
Jianchao

