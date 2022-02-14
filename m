Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1E2AC4B4D65
	for <lists+kvm@lfdr.de>; Mon, 14 Feb 2022 12:12:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349155AbiBNKvv (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 14 Feb 2022 05:51:51 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:43796 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349518AbiBNKut (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 14 Feb 2022 05:50:49 -0500
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2042.outbound.protection.outlook.com [40.107.243.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6459A66F83;
        Mon, 14 Feb 2022 02:14:57 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Tm0p3NeWj5resMCvzf/uKZYXxXLPTMu5MvShJMJFO3s41wWIj9XPOHxzUWlrdjwrdk4UEsL5LelyER1m8I7WiyqH4iV6fg+kKAlwhzq9/9NPZccZLoEb307vsNvuG7E3EzN0A5MxWPoJ9f1tA+hveHKsfl+tW0Z6E8NLFLs36Q0uo/NVlm/wgEwNJDTyq8j+tL5leJq40J0V7+0VansiDa6cl/jc55eQyjueFQ2mzXy2dDx3Rh8utl3o9u3a6hEL8glBLtSsBCEnBGDmLAZtYDse6FdIplzzNjO3Vg6lBZoDe8tsNUXOh8l2xJmkf3Rht77vUOyGvdZYNVMf9gw54g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=IQ3xZs15IkQkZXQZAT4fTm72jM2xdb2iaZ5lUwN1660=;
 b=fVxBGSGu0Xz9nGKzyxamrsP6hC+B6RPBLLfK5J2gHpp+WYkQIdxMQB0ygA0tHYleFRySzuDRziTl24QsIIhaWSU3JnaIx7wzzWO/GZ8qKVZ63ssJESl41RGUiP7zKPnnEJBjGfeBw/4KGLn1JSPja6se8JFmXRzVgHwInsXjS5hlhfHA6Y7COFsi4eKiskhXAxEAZkjTQXAy00Alj1lDy5eEb//OBINuBCvpI7tG2OJfUYRK57G29qQ8GZvsI2FxWLgzQFxLA0tseqkEYRBGcpB3MplL7T9Sf2lmxwQpqqjFr921EACuwGiZERBjeUZmUOL1wL5JuK35Dj450Pch+w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=IQ3xZs15IkQkZXQZAT4fTm72jM2xdb2iaZ5lUwN1660=;
 b=vxZ2bt6uoGdZ0dqfPs+qtLl+E/4MrstIM69rCAW7oOdSSlOx7r9uTPEO1iWtHmACnaiZrFc5wheBAN8BCPO1XR0VD43mL2jmhE3uP0U+FHO5xvKNZC31crivEhUEryWg/h/DSVs9FXNBbnYGDuA2pXP4tFz9quLxs8YVjfpELnA=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from MN2PR12MB3053.namprd12.prod.outlook.com (2603:10b6:208:c7::24)
 by CH2PR12MB4857.namprd12.prod.outlook.com (2603:10b6:610:64::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4975.19; Mon, 14 Feb
 2022 10:14:53 +0000
Received: from MN2PR12MB3053.namprd12.prod.outlook.com
 ([fe80::9117:ca88:805a:6d5b]) by MN2PR12MB3053.namprd12.prod.outlook.com
 ([fe80::9117:ca88:805a:6d5b%4]) with mapi id 15.20.4975.019; Mon, 14 Feb 2022
 10:14:52 +0000
Message-ID: <4373e8d7-e3e8-164c-75e3-6ca495a79167@amd.com>
Date:   Mon, 14 Feb 2022 15:44:34 +0530
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.4.1
Subject: Re: [PATCH v2 2/6] KVM: x86/pmu: Refactoring find_arch_event() to
 pmc_perf_hw_id()
Content-Language: en-US
To:     Jim Mattson <jmattson@google.com>
Cc:     Like Xu <like.xu.linux@gmail.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, David Dunn <daviddunn@google.com>,
        Stephane Eranian <eranian@google.com>,
        Kim Phillips <kim.phillips@amd.com>,
        Ravi Bangoria <ravi.bangoria@amd.com>
References: <20211130074221.93635-1-likexu@tencent.com>
 <20211130074221.93635-3-likexu@tencent.com>
 <CALMp9eQG7eqq+u3igApsRDV=tt0LdjZzmD_dC8zw=gt=f5NjSA@mail.gmail.com>
 <7de112b2-e6d1-1f9d-a040-1c4cfee40b22@gmail.com>
 <CALMp9eTVxN34fCV8q53_38R2DxNdR9_1aSoRmF8gKt2yhOMndg@mail.gmail.com>
 <3bedc79a-5e60-677c-465b-3bc8aa2daad8@gmail.com>
 <d4dae262-3063-3225-c6e1-3a8513a497ec@amd.com>
 <CALMp9eShc-o+OZ3j4kDkTbXmY58wQu6Rq6qviZAHsDr4X21a5Q@mail.gmail.com>
From:   Ravi Bangoria <ravi.bangoria@amd.com>
In-Reply-To: <CALMp9eShc-o+OZ3j4kDkTbXmY58wQu6Rq6qviZAHsDr4X21a5Q@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: PN2PR01CA0029.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:c01:25::34) To MN2PR12MB3053.namprd12.prod.outlook.com
 (2603:10b6:208:c7::24)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: f019f0b8-59f4-46c9-3ed9-08d9efa2d6ac
X-MS-TrafficTypeDiagnostic: CH2PR12MB4857:EE_
X-Microsoft-Antispam-PRVS: <CH2PR12MB48571C3CD610490D77F98690E0339@CH2PR12MB4857.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6430;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 9VFHzfpXXIN0dOfUCKV3oJB9o4/iHiDvQ0lUHrirjMcnuLPH5cXvkSui5wCqxjOs1ScHNQ/jImpmyw/471qXl6auKXFKC2SK95Hr35ZcOnH7v4A+uijkHGkPSd3XLX3gz7Js03KFHcTDrd0ZnimdZ9lEoYpdiKTvPO2RDmecC36OomspZPthOBHRyvnRyOywL7YRQgvFNnR+GW3INIv1kfodGpepfmHGC7RWf14lSKbUvy89EwXoHtAsKnPWJKfRfsyVrpZ8FcM870g/3/EklIuXDEar809Uv6ezR/Bf+VV+CpCCUjh0r0qRDC1cBJmLR4B2aogOQ3KtRASjYzWwo0q5J+tMNJBv14sWY/4flksWzKiiLqKnd75UTBvqmHHzOHZHhj0bxu+XZPYXeLk/D3dJ7O0yO43j8YmHmHdGM+5FcWB53cO+kRkLlfhNDGLY+/JcBz5wVL7ycvTaSyH44KEUPyzPiqcZGHvQO0mhqUirIZg8xk4Kjkk4T/dgV8HCwsi+zn3B8n0SKP7HAJ8bxc9YfbXzQdL91YV2wEtZsKAuCLlUUVpE+nVgQe5RIEZi/5aKrvHyF8zS16M0fifsJ07ciLVE9lP+JcUFrVbGBFu8GRMnX9FHtZxeKL1lpFn3kkrn9zZniO9d2ddMdUPybeQKn3TjDwN6uD42tc1mobZP+iVGrvk4y3XWYo2dQVsK+YSQ1hnKU0upttYrQP7L2V5ZFw1mZtgFgYe0OAZaPWZUEJI82S99QHze27K7PMHvlL7E58GSqT7dqRU9qsyDCMZCntza8lMrhizU3YHzvm0cbTyiSQrlfS2NTDvz+kHu
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR12MB3053.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(36756003)(2616005)(26005)(31696002)(2906002)(186003)(44832011)(8936002)(38100700002)(7416002)(5660300002)(53546011)(66556008)(4326008)(8676002)(66476007)(66946007)(508600001)(316002)(6916009)(54906003)(6506007)(6666004)(86362001)(31686004)(6512007)(966005)(6486002)(83380400001)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?QWlSS1BTZG9PTGQxSVIreVMxZ1VsWVlYS21EaFM4eXk1K3RBUDFvUDJ6djQx?=
 =?utf-8?B?aG9DNGpqK0M3bmdSbXNJMEdWZTlvTmdRa3dac29MZitjZkYySmtNUmx5NUs5?=
 =?utf-8?B?YWRwdHJxR3ZXZ2Zqa3NkRHZkRE1TVGJ0UHFrWmZEU09nOXdUYTNaT1JCZjF6?=
 =?utf-8?B?Rk1BVWM3WEJRTkpvYnFJVU9rSHU4THcxZnlvWHQ0Q0taS2JPYzYyMDdqWlIw?=
 =?utf-8?B?a0d5bElicUV6QTRDOU56aEh5NDNkWENpUjhvYXgyVDU4dHpubmtDbmRiL2NR?=
 =?utf-8?B?VktoUnkydnhEOVpldXJCblBoWEk0ak5UWkhxK3I2RXhSOHFWZTBzcTFpOGMx?=
 =?utf-8?B?bUMwVVlESlRFQ0JCMld1ellmSGhDVXVhYUlxSTNzTkYrTkJSNmcwOWg2eWVL?=
 =?utf-8?B?SURNUUc3UTNLRWNFSmhhWS9QcXNFc2o5M2pFbFlrY05vd3I3c3lKdzFQS3NF?=
 =?utf-8?B?VG9KL0dLSkx2RUt2ZWhlZkJJOU9pYVNHMDJqSXFWdi9ubnJNOWxvODdHSC9r?=
 =?utf-8?B?WEpCcWoveHZOTzhXWExJalFrV24xYjdORi9uYXhVTDM4VnVqb2RLYTFFRXZU?=
 =?utf-8?B?ZytraHdZL285UXJ3OWxPd2RRQTcwQ05ZMkhpRTZrYkRSMXJrSTc5R3hPQ2x3?=
 =?utf-8?B?L1hwN1FkeFZiYmVvWmlydC9LOVgvanRzNTVMWjNhWXlIRUc0OXB3dmhGZVgz?=
 =?utf-8?B?ZkVzZDRKUlQrYkYrSjEvd21WS3ZtRm5BZHR0dmFJa09yOUFYdzdaMmI1VjNF?=
 =?utf-8?B?eG1GeTNJNTcybEF6c2c5UWxSQ2x4SVEzMyt0eW9RWU1US1FZcFpnOTN5MFM1?=
 =?utf-8?B?L2RCZmY1U3RlWDNmL0V2ZVEvQ2ltWWpGQlcyTGxUNFVBY1JjamVpWTVlSEYx?=
 =?utf-8?B?bG9nVC9UUVNZajU0eEhZSXpWM3o1OG9YcTVOWEhSVVdEZnNER2VUWVBxdUdq?=
 =?utf-8?B?RklQdWZTQkNiV1pCV0pNV1V0T09pWitXRnpkQUl6UWMzNmpVZ1k5K2dETG1y?=
 =?utf-8?B?eUxURThCcFc0RlVkV3AyaTJVOUd1U3lVWmVBU2wrMlJJNEN4ZFQ2V2oyaDhJ?=
 =?utf-8?B?UVJZMlZsbC9XUDRxWEVaSDBRK1dNb1Nua3F1MTBPZTBxTWJ2VnQ5ektKWlIz?=
 =?utf-8?B?dmhVRk81cTQ2dzJ4cUh1bnNJbkY2VWpCUnFzL01mdkhHSVh1Y1hnbGtNd0k3?=
 =?utf-8?B?UGVrNXA2RUJ2cTNFcEdHK2ovdkVpNHNuVDU0ZEk0c2ZQUUFZeDdOSVRIdGZw?=
 =?utf-8?B?LzQ3OEdHRjBBSnptQjQyVHNOMzNzVlFqcTFHbCtXbnBpSU41ZFFZVnJaNWRH?=
 =?utf-8?B?MlJqSnpWWC8zNzRkL1JjTXdwUlRHeFhkQXp3Z1I0cU5yeDRuazJIdjRYMWx3?=
 =?utf-8?B?Y2x0RVEvTDF3TjNyakVqNzBLWTl5VVRNL3ZyV09NSzJycU1ZN1E1VWdnZU9j?=
 =?utf-8?B?bmo5Tis0Zm1oQjM4aUMraXo5UjVsZjUzY0hZcjkxQnFFUGZMZjNZT2kxVDl5?=
 =?utf-8?B?cEZKdktTRWlTdjNsS2Y5L05aVkN3NFF3L2g3dUt2MUpHS0dvS1ZEZzd2bktM?=
 =?utf-8?B?SEVjTk4yazRYR1ZDTFFYcFlmS3VWUEZRMGhJOENwNXZSWEk0blFxRkFheVI5?=
 =?utf-8?B?Rk5PU2RieklxdnY3ZzloSXVoMXNRWVBsaEpXZkxNZlRSV1UzN29zRk12Q2ht?=
 =?utf-8?B?eDB1VUtjOHlBbHFuazVFM2pydVJnazR0d0MzREV4WFBXTGFjSkh2NE5KbFRw?=
 =?utf-8?B?ZUtGRTFaNlhEeitvclBFMGgxOGE1ZC9OR0tUaXM5Z3BVelhGOXYrREJQeC8y?=
 =?utf-8?B?a3p5dlQ1U2J1NDZXeTNreEpCUy9zQWZRQ2RYNnA0eXVZQlRWellKcCtwV2pD?=
 =?utf-8?B?dlpUc0Z1UFpHZThFdUp4TmNBTkRMQTZSN0NIQ202eS8rZHFuaU5WZnk1Vmoy?=
 =?utf-8?B?NGg4aEpsbzVGM2tac3EzRExOTGsyenAxTVBTVXBVVzUwVkdBcjEwd211NGJP?=
 =?utf-8?B?RHVLYVVYZHAxMForY3pZSTk0OGxzRzNsN3pJZHNDMWpVcG9ydUNuWGtwYUts?=
 =?utf-8?B?R1FYS0x3eVFzNmo4a0VneEFGczMzbjdpK0pYOHN1N0RQK3FETUw0T1FueWd1?=
 =?utf-8?B?NlRoekpqaEhwR1pWYmhpdS9YSHpZSy90S3B4Skl0bE9BR0NFbHcxbkZ2UEp3?=
 =?utf-8?Q?Swv7kQleGJpQFo8EE+5ymp0=3D?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f019f0b8-59f4-46c9-3ed9-08d9efa2d6ac
X-MS-Exchange-CrossTenant-AuthSource: MN2PR12MB3053.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Feb 2022 10:14:52.6081
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: KEXcG9PuFchEy0cvMMYTyq2lNC2Y4ZCUzuVY68CcWmSZnUsfJZfzJKfP7r+eq5FGYHUmtXLazNGT71P0JXYYHQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR12MB4857
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 11-Feb-22 11:46 PM, Jim Mattson wrote:
> On Fri, Feb 11, 2022 at 1:56 AM Ravi Bangoria <ravi.bangoria@amd.com> wrote:
>>
>>
>>
>> On 10-Feb-22 4:58 PM, Like Xu wrote:
>>> cc Kim and Ravi to help confirm more details about this change.
>>>
>>> On 10/2/2022 3:30 am, Jim Mattson wrote:
>>>> By the way, the following events from amd_event_mapping[] are not
>>>> listed in the Milan PPR:
>>>> { 0x7d, 0x07, PERF_COUNT_HW_CACHE_REFERENCES }
>>>> { 0x7e, 0x07, PERF_COUNT_HW_CACHE_MISSES }
>>>> { 0xd0, 0x00, PERF_COUNT_HW_STALLED_CYCLES_FRONTEND }
>>>> { 0xd1, 0x00, PERF_COUNT_HW_STALLED_CYCLES_BACKEND }
>>>>
>>>> Perhaps we should build a table based on amd_f17h_perfmon_event_map[]
>>>> for newer AMD processors?
>>
>> I think Like's other patch series to unify event mapping across kvm
>> and host will fix it. No?
>> https://lore.kernel.org/lkml/20220117085307.93030-4-likexu@tencent.com
> 
> Yes, that should fix it. But why do we even bother? What is the
> downside of using PERF_TYPE_RAW all of the time?

There are few places where PERF_TYPE_HARDWARE and PERF_TYPE_RAW are treated
differently. Ex, x86_pmu_event_init(), perf_init_event(). So I think it makes
sense to keep using PERF_TYPE_HARDWARE for generalized events?

Ravi
