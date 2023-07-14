Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C9D1C752E88
	for <lists+kvm@lfdr.de>; Fri, 14 Jul 2023 03:30:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232904AbjGNBaO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 13 Jul 2023 21:30:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56428 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232681AbjGNBaL (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 13 Jul 2023 21:30:11 -0400
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10olkn2032.outbound.protection.outlook.com [40.92.40.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 129172D64;
        Thu, 13 Jul 2023 18:30:09 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=UiBFavJaMgdqjsPTCb3EfcTT/2ushEGIYUf0omxJpm92j77vKiK+/zpOmqcLIVlPqv0OtC9w4y8TAm20NcuEcgXUeHwQ8Btl2yfYcwU7d/vAR4XnrsETtYuzDtolJVbnlEiGtL6irlvcTBY5Moz5jQmu1hGr8xB+sPOrRish4NBLPbCGHDaJGTchqDYCeyFKP8Ol/blYN9TRzplkW0oo7s+jfrsn4s9L7m+os9pLcASGVb9FUIDoZNnFE/w7jS+XgZTR1GE/imaaU3AnOWSJhiEOKyuEhZRELKJ06S+KeZDG/sxkjdvib1O4i1IhWl6h3i6VgZwBEu6owX4EVJ1VYA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=UlP0cSqhlrBQJdDDGzLeaTuq0QL5Ee7Ke0wHKxE6+8o=;
 b=gzhDoel81JPMMqn8HGsqbTrI2JNDOhB7w7WpWvakq7sQL+Yo9HJYI87RqRHHtgpZEVxuh/wpT96aHW6TNPoKyiBzMh8oSdlKD2wlwZzouzOc1jHbNXqaEDoemycbEyBT+KQneJKjHJ5/9dzELkKKhKlLi1hYUvXaCw5rtSoAJmszqeon/Bgumc7CNVdXCNqnPDaUrrXhi+CafNOOzlFNR6bmH77Q5+j8JupMPLSez62k95qOek0GDspPjKrVl9dFU+S1gmPqWo/Yf6z60mEehjHKoHQ4nPM8qNd7Jeauc6K0Q3VT/Bp0Nlah5KIYt9S8YikVulLypjZPfJxgpdSiew==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=outlook.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=UlP0cSqhlrBQJdDDGzLeaTuq0QL5Ee7Ke0wHKxE6+8o=;
 b=Fwa3g5zKLDy6vToIaDwDGHrhzLUISmz90zeYeFrffyx2r6Q6rO4hLLy/zSotKn59j4Q1LPVYJaLPw5w2Bb1rdC7HDLRV5NiIKnTuu5VtPDj3hjJ8GIGD8gYMJQnqPtK4lBR8ZyaYMspOzumoiqNjv75wGyTzXkWJ8mgAZF5ZxJ0KuAg+4x8Az5VcyxGf9tOqxlejvad61DjmTNZBMiUy3gWHPnFJUq5qBzKffsu2bL6b3UkvXmeCgTKkdwPyFJweYuZR+nXjfXqIVyY/n8r1Y2+Nukj/CTjoxBb9GwI0ZnKSvEdCN5iC2K2BOUPi/v/ymu9+2CozgSL5iK4yZy57VQ==
Received: from DM6PR03MB4140.namprd03.prod.outlook.com (2603:10b6:5:5c::12) by
 SA3PR03MB7185.namprd03.prod.outlook.com (2603:10b6:806:2f4::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6588.20; Fri, 14 Jul
 2023 01:30:07 +0000
Received: from DM6PR03MB4140.namprd03.prod.outlook.com
 ([fe80::b184:f2e2:b60a:2526]) by DM6PR03MB4140.namprd03.prod.outlook.com
 ([fe80::b184:f2e2:b60a:2526%4]) with mapi id 15.20.6588.017; Fri, 14 Jul 2023
 01:30:07 +0000
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
 <a6fd8266-54a8-bb4b-f3d2-643a94e27e9e@intel.com>
From:   Wang Jianchao <jianchwa@outlook.com>
Message-ID: <DM6PR03MB41405C84C56FCEE7110263CECD34A@DM6PR03MB4140.namprd03.prod.outlook.com>
Date:   Fri, 14 Jul 2023 09:29:55 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
In-Reply-To: <a6fd8266-54a8-bb4b-f3d2-643a94e27e9e@intel.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-TMN:  [LYq78CdYIU6HYH9UtLi7Pcu0Q2Kh8GCQL5OvUeHCE0c=]
X-ClientProxiedBy: SG2PR01CA0147.apcprd01.prod.exchangelabs.com
 (2603:1096:4:8f::27) To DM6PR03MB4140.namprd03.prod.outlook.com
 (2603:10b6:5:5c::12)
X-Microsoft-Original-Message-ID: <0d8324a2-6297-c3b8-f258-3f2bbc161801@outlook.com>
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR03MB4140:EE_|SA3PR03MB7185:EE_
X-MS-Office365-Filtering-Correlation-Id: 06f96db1-359d-41ab-7cf4-08db8409dae5
X-MS-Exchange-SLBlob-MailProps: Cq7lScuPrnpRiBCNjHstdiVGgGTicbc/URsj4WL/EztbK8kySEV9mJPAHekw9SvdlLVp74fmYWq60+/hGbC51TpmIfW6Qd4R3p20HfnXIERF2MOPFBHZLMtGNO6IazxsVCMwc0Gd/NolAvgsk8yZB6e8Q2XZzmuu63Vkym/kPXTrb7tJ3RS280AeAAFw1GofNO1LPKyvsSHgEETm/27j7aQ3kwiXq0RbMEnI5xxs3iwqty8LuNXJUGPQ+A53II/b0zOrt1nE3dv4DH8WICrB4DJiUeHy0uCV07czPYRTYWnyjeFC0NDRYnqVc+EFMWdkgWrE2/QQvr96k0FpYVEl7hSZWb1pzQaSJ1u9hcnapkbO7yRaANKTpTdJlxPCmiNj5zZLBLNViPcIGSkRfcRV5LhTT9Q/ukp2Af6ZwDkPJWz47fiYTrfvx1ASWefL6+NmkccVSHjpscG14yFAsaxdnvozTIcdKXpZjUSChrCO057XaT02fK1Ss9DRu5LY1pGJKOQkTtBB3z6QKh6lqnGidxxXchStAnHDklbU8wQFGdwXj2g4SQIBpMDLAA2BuHpu1frF43l3l3JTUTVURMNAIgmyPp6CO1QCrE8jQnJ/P1hblU/Mh5W900kKrvVJItNw9e1mkTbGJU3FoH0LJS+3KVWTcxtoCv6bbZLQZJHv6lKud0zgNDrEaF1OZnjI3MJTU2D0r3m8YTs79+iqfydxnvYAwDbtS1XbO2KJZRQ1fX9xkL9oUDZVb1YiZWt4+QHGsHxIJj9LDmM=
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: zpEUsDWiUMQ6s9QDJDJw2YBXNn8zhfSHfHL3f/Eoic9BbkINrxZ0pCrnbMqN51JQECTWrooCe5zt3MnVjugZe1SKErM4DPqs4lu8oxRlYvfWuCXPFCanileidyu4KhkuaTxnk/J/VgLblsXy3m1SpgUQOL6qa0mhOPW+f9aFBh/j8UxapVfUcQv3U7Cw7UCtG0Kbl7sPuy4pgY4k0QWb5p+0MGtUQOdwuKO/hxT0IgFmWyg83ZgRsJetOkZCKw1bBXkgOIQS+S/oHWykIcVmnJzrv1Z4eFivS2n/6RQdUlpkAbzjC05SWvHm3KtknBEkbfct0ekXH6j1JeOgConzByFrsZCYzesIVHHM78YVVnRKvzB4ZF40XWy+77qMY6cYwKnMruDrTGEVeNs8eMZA3gflX0z3pHhCj19YonKWy87fdJ+2D8yU49+MdtpbtlAppMmNxOZT6s4Ys4yqPlyxd1mmBOdq6XZFEs9q9DnDa//Oh+e5NC8ThmBx8TTw4L41lAmtsItjRRhDnFmoyHrJYGQnT/AOy4dosmUdaBxUih2U47KCVtaq9EnqTLBnshUt
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?UkVuNjh3eGdhMXdmc2syN3NxcXViNFV4VGxtcjg1MU9qbUhOYnE5azZSdDRF?=
 =?utf-8?B?blA4Q2ZmSnlNRkVqeEJDcFVucUlLam5wa09qWTNyNEZQWnEvcEh2UDdqeElu?=
 =?utf-8?B?djNhUHZiRmd5bmt0cHBaa1JzQjdiNDBSUDcwZkpnUU5GQmxRUnUwMnNZZXBZ?=
 =?utf-8?B?emYvQjc3Umd2ZWpJazBaVzRuTmFYVGM2cDlGbkwyL0I3UklHTmltekFKNzFJ?=
 =?utf-8?B?dUZvbnFmRE9SQ2xEVXdUeW1XTWI2Q09md1JFYzZIU09ibno4WXpYMm5ZZ0Ez?=
 =?utf-8?B?cXBHLzNvR3ZMSEUvbk40YnpRUkh0UDN1aUxJR3QrSDFNaHRiSXhHMExFa2Jp?=
 =?utf-8?B?RjE4NTZGYmU3OExXVENvYVAxYzI3QVNtVDI2MzZ0SjdrbERtaCttOEhVTCs0?=
 =?utf-8?B?clR6M0FybkxzMStvM0VtTy9abzdRRWFmVEQ1cEgwMUlINll6RUFIckV3WVVP?=
 =?utf-8?B?RXFITzNCeUZEelNsYnlEYWdTaVVlR3VRTU5xSjlXOHRpanI3ZlFWQmkwVmhU?=
 =?utf-8?B?UStQTUJsZkozK1RscHJBSkFjdFZXbjFkQkxiMTVHbnprZDFjSHJIK1ZBL3VB?=
 =?utf-8?B?VktNclJnWkYzTDVxTHFRVjJWelJRZFBrVUlHcnlUYVpuRFN4OUlwenZSWWEy?=
 =?utf-8?B?Zk10eUg1TXJPMkFDWE1yb3VDS2RpWm14Mis4UG9xeTY1SDNwN2JEcXJ0dU1o?=
 =?utf-8?B?YWQvajY1QVFSeDRTcGdCUlMxcW9aOVNSMkRNcEYrcXlqaVdCazh3M2pQOW0v?=
 =?utf-8?B?MG9JNkV5RG8zY1dJaUt1ODJHZXlFL3Yva3ExRDRYZEpIR0YwWndZQ0lwWnNi?=
 =?utf-8?B?TTlPaEJlemtJWEpudkFLTFc3UmZNRktSZFBDM0xSRlMxY0QxK01wTkt2UTJu?=
 =?utf-8?B?RHpaMGhzNzhzeGpQU0lXaDAzZURhekU5RHB3Zkp1aEtwV0xFVWdIRGNveDBx?=
 =?utf-8?B?cmlZdWNmTStqQmNxRUM0SWxQNE01WXdpUFhHLzVpZCtQcUlidmFPV24rVGpz?=
 =?utf-8?B?Vkg1amFRazgxbmFKZ1VSMkI3U1Z4cEFhRk4vUUFVSy9TaG1wd3Q4MUFsNktv?=
 =?utf-8?B?dmpQL1VMZjEvTk5qNjNhWmJhTkIyVmZtbE1ZUjVwTzY0WlRjNXgvSmtadUpM?=
 =?utf-8?B?b3IwUVY4VWp0NUY0cGMrYmw5RUJhc1Y3ZTBnUGlYd0ZGMVBkSzk4c0V3QjFx?=
 =?utf-8?B?cTN5TFI1TFhYUFZ6endPRHZjdUN0Y0dmOHUwQ2lTUlFTSVN6bGg5ZVhmNzlR?=
 =?utf-8?B?ekNhZ2Rvb1lFc29Ubm15aGkyaTFqWHBMVkw3NFpnTDM5SUQxaWdhcWJkeU85?=
 =?utf-8?B?eTVVUVNJd00xUUlhdG04MWUzUkxtRWlXRXhJMElRMC82b0tCWUFQVjJKWE5r?=
 =?utf-8?B?ZFFOUk4wYmduazRyM01NWWxFRFNKczBIdGVrN1Mya3RTSFdPRXVQc1BmdHBL?=
 =?utf-8?B?YS9Zc09Wbm80QWJ0b3dpckNpRk5Nem85OWk2dVJYa2szai9QelBMZ0xuck1u?=
 =?utf-8?B?TWt0ZDVFRWNlL2NZbkFZN0pvWkxuSENpSXgwdmtEaGdRTjZibGlXRUFXRk1t?=
 =?utf-8?B?c05qM01KMWpzTW5UQnNMR0dOVHVWdHg3eWJHNzRxK3dyUm1sTFhXMWU4R1VO?=
 =?utf-8?Q?aYGNaOTGUrVXccpjXoCIZEWoX8T5IRToqRXV2J1wp4JA=3D?=
X-OriginatorOrg: outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 06f96db1-359d-41ab-7cf4-08db8409dae5
X-MS-Exchange-CrossTenant-AuthSource: DM6PR03MB4140.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Jul 2023 01:30:06.9575
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 84df9e7f-e9f6-40af-b435-aaaaaaaaaaaa
X-MS-Exchange-CrossTenant-RMS-PersistedConsumerOrg: 00000000-0000-0000-0000-000000000000
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA3PR03MB7185
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



On 2023.07.13 21:32, Xiaoyao Li wrote:
> On 7/13/2023 10:50 AM, Wang Jianchao wrote:
>>
>>
>> On 2023.07.13 02:14, Zhi Wang wrote:
>>> On Fri,  7 Jul 2023 14:17:58 +0800
>>> Wang Jianchao <jianchwa@outlook.com> wrote:
>>>
>>>> Hi
>>>>
>>>> This patchset attemps to introduce a new pv feature, lazy tscdeadline.
>>>> Everytime guest write msr of MSR_IA32_TSC_DEADLINE, a vm-exit occurs
>>>> and host side handle it. However, a lot of the vm-exit is unnecessary
>>>> because the timer is often over-written before it expires.
>>>>
>>>> v : write to msr of tsc deadline
>>>> | : timer armed by tsc deadline
>>>>
>>>>           v v v v v        | | | | |
>>>> --------------------------------------->  Time
>>>>
>>>> The timer armed by msr write is over-written before expires and the
>>>> vm-exit caused by it are wasted. The lazy tscdeadline works as following,
>>>>
>>>>           v v v v v        |       |
>>>> --------------------------------------->  Time
>>>>                            '- arm -'
>>>>
>>>
>>> Interesting patch.
>>>
>>> I am a little bit confused of the chart above. It seems the write of MSR,
>>> which is said to cause VM exit, is not reduced in the chart of lazy
>>> tscdeadline, only the times of arm are getting less. And the benefit of
>>> lazy tscdeadline is said coming from "less vm exit". Maybe it is better
>>> to imporve the chart a little bit to help people jump into the idea
>>> easily?
>>
>> Thanks so much for you comment and sorry for my poor chart.
>>
>> Let me try to rework the chart.
>>
>> Before this patch, every time guest start or modify a hrtimer, we need to write the msr of tsc deadline,
>> a vm-exit occurs and host arms a hv or sw timer for it.
>>
>>
>> w: write msr
>> x: vm-exit
>> t: hv or sw timer
>>
>>
>> Guest
>>           w
>> --------------------------------------->  Time
>> Host     x              t
>>  
>> However, in some workload that needs setup timer frequently, msr of tscdeadline is usually overwritten
>> many times before the timer expires. And every time we modify the tscdeadline, a vm-exit ocurrs
>>
>>
>> 1. write to msr with t0
>>
>> Guest
>>           w0
>> ---------------------------------------->  Time
>> Host     x0             t0
>>
>>   2. write to msr with t1
>> Guest
>>               w1
>> ------------------------------------------>  Time
>> Host         x1          t0->t1
>>
>>
>> 2. write to msr with t2
>> Guest
>>                  w2
>> ------------------------------------------>  Time
>> Host            x2          t1->t2
>>  
>> 3. write to msr with t3
>> Guest
>>                      w3
>> ------------------------------------------>  Time
>> Host                x3           t2->t3
>>
>>
>>
>> What this patch want to do is to eliminate the vm-exit of x1 x2 and x3 as following,
>>
>>
>> Firstly, we have two fields shared between guest and host as other pv features, saying,
>>   - armed, the value of tscdeadline that has a timer in host side, only updated by __host__ side
>>   - pending, the next value of tscdeadline, only updated by __guest__ side
>>
>>
>> 1. write to msr with t0
>>
>>               armed   : t0
>>               pending : t0
>> Guest
>>           w0
>> ---------------------------------------->  Time
>> Host     x0             t0
>>
>> vm-exit occurs and arms a timer for t0 in host side
> 
> What's the initial value of @armed and @pending?

Both of them are zero.

@armed is only updated by host
@pending is updated by guest

Guest side will check @armed, it it is zero, jumps to wrmsrl

> 
>>   2. write to msr with t1
>>
>>               armed   : t0
>>               pending : t1
>>
>> Guest
>>               w1
>> ------------------------------------------>  Time
>> Host                     t0
>>
>> the value of tsc deadline that has been armed, namely t0, is smaller than t1, needn't to write
>> to msr but just update pending
> 
> if t1 < t0, then it triggers the vm exit, right?

Yes. If new tsc deadline value is smaller than @armed, namely t1 here, it jumps to wrmsrl

> And in this case, I think @armed will be updated to t1. What about pending? will it get updated to t1 or not?

Yes, the guest jumps to wrmsrl and causes a vm-exit, the host side will update the @armed and re-arm the timer


Thanks
Jianchao

> 
>>
>> 3. write to msr with t2
>>
>>               armed   : t0
>>               pending : t2
>>   Guest
>>                  w2
>> ------------------------------------------>  Time
>> Host                      t0
>>   Similar with step 2, just update pending field with t2, no vm-exit
>>
>>
>> 4.  write to msr with t3
>>
>>               armed   : t0
>>               pending : t3
>>
>> Guest
>>                      w3
>> ------------------------------------------>  Time
>> Host                       t0
>> Similar with step 2, just update pending field with t3, no vm-exit
>>
>>
>> 5.  t0 expires, arm t3
>>
>>               armed   : t3
>>               pending : t3
>>
>>
>> Guest
>>                              ------------------------------------------>  Time
>> Host                       t0  ------> t3
>>
>> t0 is fired, it checks the pending field and re-arm a timer based on it.
>>
>>
>> Here is the core ideal of this patch ;)
>>
>>
>> Thanks
>> Jianchao
>>
>>>
>>>> The 1st timer is responsible for arming the next timer. When the armed
>>>> timer is expired, it will check pending and arm a new timer.
>>>>
>>>> In the netperf test with TCP_RR on loopback, this lazy_tscdeadline can
>>>> reduce vm-exit obviously.
>>>>
>>>>                           Close               Open
>>>> --------------------------------------------------------
>>>> VM-Exit
>>>>               sum         12617503            5815737
>>>>              intr      0% 37023            0% 33002
>>>>             cpuid      0% 1                0% 0
>>>>              halt     19% 2503932         47% 2780683
>>>>         msr-write     79% 10046340        51% 2966824
>>>>             pause      0% 90               0% 84
>>>>     ept-violation      0% 584              0% 336
>>>>     ept-misconfig      0% 0                0% 2
>>>> preemption-timer      0% 29518            0% 34800
>>>> -------------------------------------------------------
>>>> MSR-Write
>>>>              sum          10046455            2966864
>>>>          apic-icr     25% 2533498         93% 2781235
>>>>      tsc-deadline     74% 7512945          6% 185629
>>>>
>>>> This patchset is made and tested on 6.4.0, includes 3 patches,
>>>>
>>>> The 1st one adds necessary data structures for this feature
>>>> The 2nd one adds the specific msr operations between guest and host
>>>> The 3rd one are the one make this feature works.
>>>>
>>>> Any comment is welcome.
>>>>
>>>> Thanks
>>>> Jianchao
>>>>
>>>> Wang Jianchao (3)
>>>>     KVM: x86: add msr register and data structure for lazy tscdeadline
>>>>     KVM: x86: exchange info about lazy_tscdeadline with msr
>>>>     KVM: X86: add lazy tscdeadline support to reduce vm-exit of msr-write
>>>>
>>>>
>>>>   arch/x86/include/asm/kvm_host.h      |  10 ++++++++
>>>>   arch/x86/include/uapi/asm/kvm_para.h |   9 +++++++
>>>>   arch/x86/kernel/apic/apic.c          |  47 ++++++++++++++++++++++++++++++++++-
>>>>   arch/x86/kernel/kvm.c                |  13 ++++++++++
>>>>   arch/x86/kvm/cpuid.c                 |   1 +
>>>>   arch/x86/kvm/lapic.c                 | 128 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++------
>>>>   arch/x86/kvm/lapic.h                 |   4 +++
>>>>   arch/x86/kvm/x86.c                   |  26 ++++++++++++++++++++
>>>>   8 files changed, 229 insertions(+), 9 deletions(-)
>>>
> 
