Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B84EB775688
	for <lists+kvm@lfdr.de>; Wed,  9 Aug 2023 11:38:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232069AbjHIJiI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 9 Aug 2023 05:38:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42110 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229489AbjHIJiH (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 9 Aug 2023 05:38:07 -0400
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2135.outbound.protection.outlook.com [40.107.93.135])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 30DD4E5F;
        Wed,  9 Aug 2023 02:38:06 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=B5+bZH6drXII8/DsZP6c0AKJgB4UVrRtoNhsNEpmzmRpcCe/2DdP9XbeM13hxruXqygBzd+wc1uI0J8pfzexn43PUPFJUFBSxgt62ykf7NLg0LAND3gxrgguOA3rUmQveqp0vBRZUYlbwrdwfCrVo3J+E1wOlfNQRl18bFs7WffOBUzclL2l2Tcp7n0z2DrlvTDxT5RPquDAWxJxZdnc3jVtuIpyBAcTJ4dwyatAEZIcauPcRz94suJ2924OK+I3/kDmrfjOK09d6bDMLk5Xvaw4e4nebLS5AEZJu27vmiJJRz9LIR3BpHd87O3d9t9h/d/PiFT6z+eElFaLycZqPA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=VO3A0T6YXPBiOJxaagHYwhcmBj+2fqcr1nAF4wNnPWw=;
 b=i2GcHhH6ltptk9Dsxvt5ja6hZNtiQaiZxjP+YOtvlQgy9NHvNZo043JfAaHS4jANh5wmc+iiU9AHoJrBAGGRcKFMdoqGU2D2Ldzefy48tvJSpGJZLcyPTDnF+tl19quSOI2U6/5/c5mDrbl6unHtfHLT1nByEzHW7gCiG6zs0ILXO+pxb4OMQ9agPPMGBbYuRmVtBv98xYw6H4gl73ZFQ3segtYUM0taSUb+tupvhUVaJRgCpN6RhQ0VC2D5A5l95j8GfnAxlaNITP8/2S6AuFrMkglmCKxxCiD8ZqSuAo+Lvz/yiOxAnb2UzRniJ52yvto2IRQav4v56iW/c3ozgQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=os.amperecomputing.com; dmarc=pass action=none
 header.from=amperemail.onmicrosoft.com; dkim=pass
 header.d=amperemail.onmicrosoft.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amperemail.onmicrosoft.com; s=selector1-amperemail-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=VO3A0T6YXPBiOJxaagHYwhcmBj+2fqcr1nAF4wNnPWw=;
 b=C6tB1fOSg5oKmnueSAq+NMhlow1Q6UJKvrMP7feT2vUpExKULvgB+zlctCcgo7ibeMMhc4aXCbpdMkmL25Xs+cKDAX7vQgO2Fd7jFDHBb1js5+A45mb1NOohQ5svZryz2a7On4NaQWOidA/KXiPeE+Ip7zHwpE9qbG+6aidHf8I=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amperemail.onmicrosoft.com;
Received: from DM8PR01MB6824.prod.exchangelabs.com (2603:10b6:8:23::24) by
 PH0PR01MB6199.prod.exchangelabs.com (2603:10b6:510:1b::15) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6652.28; Wed, 9 Aug 2023 09:38:01 +0000
Received: from DM8PR01MB6824.prod.exchangelabs.com
 ([fe80::d62f:d774:15b0:4a40]) by DM8PR01MB6824.prod.exchangelabs.com
 ([fe80::d62f:d774:15b0:4a40%4]) with mapi id 15.20.6652.026; Wed, 9 Aug 2023
 09:38:00 +0000
Message-ID: <b57b1852-9245-d539-c254-28d1834a64dc@amperemail.onmicrosoft.com>
Date:   Wed, 9 Aug 2023 17:37:51 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.14.0
Subject: Re: [PATCH] perf/core: fix the bug in the event multiplexing
To:     Mark Rutland <mark.rutland@arm.com>,
        Oliver Upton <oliver.upton@linux.dev>
Cc:     Huang Shijie <shijie@os.amperecomputing.com>, maz@kernel.org,
        james.morse@arm.com, suzuki.poulose@arm.com, yuzenghui@huawei.com,
        catalin.marinas@arm.com, will@kernel.org, pbonzini@redhat.com,
        peterz@infradead.org, ingo@redhat.com, acme@kernel.org,
        alexander.shishkin@linux.intel.com, jolsa@kernel.org,
        namhyung@kernel.org, irogers@google.com,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        linux-perf-users@vger.kernel.org, patches@amperecomputing.com,
        zwang@amperecomputing.com
References: <20230809013953.7692-1-shijie@os.amperecomputing.com>
 <ZNNNY3MlokEIj4y8@linux.dev> <ZNNa0abhS53cMNcK@FVFF77S0Q05N>
From:   Shijie Huang <shijie@amperemail.onmicrosoft.com>
In-Reply-To: <ZNNa0abhS53cMNcK@FVFF77S0Q05N>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: CH0PR13CA0048.namprd13.prod.outlook.com
 (2603:10b6:610:b2::23) To DM8PR01MB6824.prod.exchangelabs.com
 (2603:10b6:8:23::24)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM8PR01MB6824:EE_|PH0PR01MB6199:EE_
X-MS-Office365-Filtering-Correlation-Id: 160eee96-7ea7-4944-0634-08db98bc524f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 9/O//dE58QJemE8K0ohmr9h7OwyEs5aM7sRoelgRNgwzm5cSwF0JRrEYrFU7j6znFcfWjnRG+wplCHA0ESkqKsAUq1SkUEaI7HxQo2lX/ypW2BVKZEQOl7jKl1peYPfX1PCBRxu6qIGwHdckbsOaUxfl01dLncy0MCzWmGJYGBh8q2b+hiTdsCfAV9z+YG+rxlxna6njQIlhwY+WhuL67fIcnPw/V/xCpwKQXQKot83bDqVmxemC8GHUCueNZN0CQVvaUa3m47RVuEwXeu6aA0IVfR0Q4XuZvV0rM+cbbbvEsXRnUcwrWzBj+jOVTN4CHdGrZl/NT3qd23rnUT6Ptx5gltdnrWXriYLqzUVuxxEHBYd234MRPNLWwLAhRdCZZYLXcc6M9GY/nFF1PncTl40lf2r613k6DQusBNg9ecUDF1c1EW0iumd8s8Hgqd2VSxHyKJFpRRgeqMtT3AKOVV14lNOJQykxxdubqbpmutnAICpoDf4d5l66fEK5OcpZmNoKVPLOSGwrt27Gj6xSHkQ9s5ixgbFh4MJQwUHkiD1pVlgDK0G6SoHRtw7QpLsAaevpODTcpbyCkpX6WIEu3eZmr7GkMoITYottDJNzqOHcn1b9k30OkCLt+lb8R6SC3019mlPhQ/aUtlZ3B21NRQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM8PR01MB6824.prod.exchangelabs.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(346002)(39850400004)(376002)(366004)(136003)(396003)(1800799006)(186006)(451199021)(110136005)(478600001)(4326008)(66946007)(66556008)(107886003)(66476007)(6506007)(26005)(6486002)(6666004)(6512007)(2906002)(8676002)(316002)(41300700001)(7416002)(5660300002)(83170400001)(8936002)(31696002)(38350700002)(38100700002)(2616005)(83380400001)(42882007)(52116002)(31686004)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?R1V2UDNqbVFacEcxbFUxYVFQdnJXQnF0b1ZLSWhLYUVlSC9vVmZxVDZXa1FW?=
 =?utf-8?B?R0xaN0tpbFJDU2xvckdaYkpyUjdaTFVoOEt6QmVwVEUrWng5QjhwSGt3SlZP?=
 =?utf-8?B?cThpaGpBZUZoVVV3TVN4bnF6YjNkd1pReFJCdm9aNHJRYks2SW90YWMxZWZL?=
 =?utf-8?B?cTFFaW9uc0xDL2ZWaGphWGplTTlObjJDLzZyT1NGVElvbDcyVkhKM3dib3pw?=
 =?utf-8?B?TzZZZGgwdWVPVEdBSHNUSmlYUVpOa1R0ZTY0VUVROWZqYXlKbE5pMzExWHcy?=
 =?utf-8?B?aGZBWkdjWm5NY0RUbUJpM2NlU3ZMU0k1TktjNFpFbDV2UDBldGtxT1p6VDZ0?=
 =?utf-8?B?TDRHN2pNaEVqUmZqRG9XUXBuT2hOcWQyTHZwdHRYWWRlUzlqREQxYTM1eVVL?=
 =?utf-8?B?T1E1bGozMlMxUHhGMkhiTm1pc2JrZEwwTVBMOWJPcnRrODA1Ym1FVm1xMHdz?=
 =?utf-8?B?UDhEVll2WDJ2QU8zM1EyYTNmTUxteVR2Nm53TERDckIzTkVad3NqUUhYNFl4?=
 =?utf-8?B?S01DL2VvSEdrR3hqSTRvMUZ5THl2NHZsbytmQ2ZxUEdycVQ5aythTXJaL0Q2?=
 =?utf-8?B?QktzdmVrTHloazlmUFpTU05wcExtZ0ZkMlZJb3pNemlpc1VHYnY5Wk5TRjht?=
 =?utf-8?B?dWJJTjFHbkFPd3FyNExYWHV4UEJyOVN3cklodmhGRnpDaW1mM2MvdmhkN1Rh?=
 =?utf-8?B?UGFjVzA5dW1PenFaU1ZYRVJxenNqUmY4YVJoaDdhWjdZS3JBYXBpdHFBMlll?=
 =?utf-8?B?YXZOUzVKNDA1SVVZMnNQK2dPK2daN2NId2MwZTI3OEYyR0VBNm8zOXExamQv?=
 =?utf-8?B?OFFHNFFhbVFkdGxyVCtZRlRQeU9kVk9XditZdWhlT0RORkwzck1nR2ZwK016?=
 =?utf-8?B?RmI2Yng5RlgyWTlvenNpQ3pwRE14RVlEUWFyTFdWMDB6Z0VPaUh6VmUzeW9Q?=
 =?utf-8?B?bFR1TVZsOFhBNGZ5NmhkZngrMmhUWGxVcUR2WTY3VTVwUURQUnROQlVBWFNF?=
 =?utf-8?B?ckx3ZVdBaW91dHFDYmwrQm1wVEFrZVp5YmhPbDBhalpOV2Q3WTNpWW1XcGtz?=
 =?utf-8?B?aHRmWXNRYTBkeFVRYkVtYUFCTVBQNlMxUFcycndKeU93TE5sbnBLY3JGWVFH?=
 =?utf-8?B?QlhjbUNuK0RHS2VoMVUrWFZmZXI3YmxGY3RLU1FEUEU4RDB1bFZYRGFjbFVE?=
 =?utf-8?B?SS9ORnp3VUhzT3JEYW10QWEvNnA3K1dmK3k0cnNCUi94cmJEUFp6M0pzZWJP?=
 =?utf-8?B?SysvZnBuNTBqcHQ0LzhBdnlrVlhYc3Q1NHBqeDVXMTlSbTljQXJQUVBZL3Zr?=
 =?utf-8?B?ak1kaXFleXRQUHZyYVJiWHZIRmhlUWEwSGJSMVpYWng4eVB6T2hVeHd0SzJk?=
 =?utf-8?B?MmFTdFVKNWJERkloYU01dCt1bFhCc3Zycm1wQkx1SHVSYnFld0c0cTAzSVBO?=
 =?utf-8?B?Y253MG9lRk5McjVOWnhlbzFqL0l5WVZXWFFaNFdGdkp4N3RxT3h0ZCtRb1lH?=
 =?utf-8?B?cE9BUnZHWnpyUmFzL0VQY21Yam9lVHBCWnVtREIvYlQxYUNHSXM1OW5qSkdC?=
 =?utf-8?B?emFRSHdNcXdjNGYwYzMyMFI3OFFpdzFGVHcwMWhmS2RxSmx2OUU1SG0zOWQ2?=
 =?utf-8?B?N0hlNHpjSVl3Y09vZnc1YmFiR1hpUTNFbTN3NU9Fc3lOcGdnaHJTc1NOQ1A3?=
 =?utf-8?B?aUQzN0FRMzI4YVlvV3BYeXh5aFNGbW1ZeFUwNmIrbGZ6aFVnN3ArRk1TSkln?=
 =?utf-8?B?V1VMT2FNclhYRkUrMitEQkdOQzN2YXNKcFZNTHVRR0wyMWVYMjZWRU5FSURB?=
 =?utf-8?B?cjdIamNzWjN2UGYvbWVWZzcxREhnVEhsTkxOSzZnWE5rRUxPcW9NeGM1YUpU?=
 =?utf-8?B?ZHRqdHFjN0FLcnBBUnVzNHRrYkFzQ3lFYjkyaE1VYkMydVh6cWdEalBEOFZo?=
 =?utf-8?B?d0hYWmN6MW9zK2RDdTZSazZMOGpPSUZ0OEYwUnJ3RDk3a0NlYnBLZmpYRzNy?=
 =?utf-8?B?S3lSWDB2T0E2UmZ6KzVYM3M2RXdFMmRxenY4Y296cWpMWW9mMFJJZ2VEN3J0?=
 =?utf-8?B?RG9KS0EzV3RrZzVBZFhlcmRXZjdqalIrRStqQUJsa3J2NmhSamZ0cTI5RDRE?=
 =?utf-8?B?NisyTm01QXN0WTlTSnlud2JpUnJvTlRVV3dGYkZiaVBmalh3TjVoUmMwZEY2?=
 =?utf-8?Q?IFY7bs2mhnemDGYkWnf6JE8=3D?=
X-OriginatorOrg: amperemail.onmicrosoft.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 160eee96-7ea7-4944-0634-08db98bc524f
X-MS-Exchange-CrossTenant-AuthSource: DM8PR01MB6824.prod.exchangelabs.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Aug 2023 09:38:00.7271
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3bc2b170-fd94-476d-b0ce-4229bdc904a7
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: PWm/LHbhhp+cCwYwrMubagV9SaUiGJztWI/S3oeiV9k8o+tqVUp3gZgoPTSgu4AEuhQcIi68dABXLhGNwIwlNbAM6fwmy3vdq4gI5u+nxJ/ydK9l5k9sm0rEhwBJMfyz
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR01MB6199
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_INVALID,
        DKIM_SIGNED,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
        HEADER_FROM_DIFFERENT_DOMAINS,NICE_REPLY_A,RCVD_IN_DNSWL_BLOCKED,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Mark,

在 2023/8/9 17:22, Mark Rutland 写道:
> On Wed, Aug 09, 2023 at 08:25:07AM +0000, Oliver Upton wrote:
>> Hi Huang,
>>
>> On Wed, Aug 09, 2023 at 09:39:53AM +0800, Huang Shijie wrote:
>>> 2.) Root cause.
>>> 	There is only 7 counters in my arm64 platform:
>>> 	  (one cycle counter) + (6 normal counters)
>>>
>>> 	In 1.3 above, we will use 10 event counters.
>>> 	Since we only have 7 counters, the perf core will trigger
>>>         	event multiplexing in hrtimer:
>>> 	     merge_sched_in() -->perf_mux_hrtimer_restart() -->
>>> 	     perf_rotate_context().
>>>
>>>         In the perf_rotate_context(), it does not restore some PMU registers
>>>         as context_switch() does.  In context_switch():
>>>               kvm_sched_in()  --> kvm_vcpu_pmu_restore_guest()
>>>               kvm_sched_out() --> kvm_vcpu_pmu_restore_host()
>>>
>>>         So we got wrong result.
>> This is a rather vague description of the problem. AFAICT, the
>> issue here is on VHE systems we wind up getting the EL0 count
>> enable/disable bits backwards when entering the guest, which is
>> corroborated by the data you have below.
> Yep; IIUC the issue here is that when we take an IRQ from a guest and reprogram
> the PMU in the IRQ handler, the IRQ handler will program the PMU with
> appropriate host/guest/user/etc filters for a *host* context, and then we'll
> return back into the guest without reconfigurign the event filtering for a
> *guest* context.
Yes.
>
> That can happen for perf_rotate_context(), or when we install an event into a
> running context, as that'll happen via an IPI.
>
>>> +void arch_perf_rotate_pmu_set(void)
>>> +{
>>> +	if (is_guest())
>>> +		kvm_vcpu_pmu_restore_guest(NULL);
>>> +	else
>>> +		kvm_vcpu_pmu_restore_host(NULL);
>>> +}
>>> +
>> This sort of hook is rather nasty, and I'd strongly prefer a solution
>> that's confined to KVM. I don't think the !is_guest() branch is
>> necessary at all. Regardless of how the pmu context is changed, we need
>> to go through vcpu_put() before getting back out to userspace.
>>
>> We can check for a running vCPU (ick) from kvm_set_pmu_events() and either
>> do the EL0 bit flip there or make a request on the vCPU to call
>> kvm_vcpu_pmu_restore_guest() immediately before reentering the guest.
>> I'm slightly leaning towards the latter, unless anyone has a better idea
>> here.
> The latter sounds reasonable to me.

okay. I prefer the latter one now. :)


Thanks

Huang Shijie

>
> I suspect we need to take special care here to make sure we leave *all* events
> in a good state when re-entering the guest or if we get to kvm_sched_out()
> after *removing* an event via an IPI -- it'd be easy to mess either case up and
> leave some events in a bad state.
>
> Thanks,
> Mark.
