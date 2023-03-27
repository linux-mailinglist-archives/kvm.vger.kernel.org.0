Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BE3F36CAE53
	for <lists+kvm@lfdr.de>; Mon, 27 Mar 2023 21:14:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230187AbjC0TOy (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 27 Mar 2023 15:14:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35324 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229946AbjC0TOl (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 27 Mar 2023 15:14:41 -0400
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2087.outbound.protection.outlook.com [40.107.223.87])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B1D70272C;
        Mon, 27 Mar 2023 12:14:21 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=LQYw+knAbOb06gDLy0BjLZSBgyDhg1O9pftiL5f7cAz6I3eGIfFzzk9IkwC4Y3+g+lydYgLMIA4bozdPqxdKQgVMo9+95fYwJov0zjTzGm/lxdlV4xL4baPSojSutjb+ne9x2PYxIJaADVk4JkliC0pVOnFwIWpmQx6KSSsxxEVKT1ixvRqOZO/SlE9878K/BMxqhFWSPFU/UxbKy8SC2MM/bEgqT/TcwMQGNyKJOxhYyT7ffa1AMYCXLDnPRBo8uno+BS2kdh4m/S4JhvyueNX3hFYTBOXtyg769LLatx01dIoMNYd9ue5Azri/bSBfIFizBv7Py3avy1Uut7+aeg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=KOc1eEdIyYOj1ErsYiqPRRGfGGEL6/LcrXI7BDXpiDY=;
 b=DJm2wbvlJ5KB9btxPLDYExwKp9KXlGQdigL0dKl4JsmdHlC0pNwC5ZP1dlLS2D5wxMdKZHDIOVURkg/5t1yKj/vsPR1FeyEOdAdIyHoam0hwE4jdvyAYb+EHx1rFvkDB4VypuAfDTYGyKTvIl8eqSrED+3pXPq5BHus6IdAbTPlawnxS4SI9IkfO64I/V/k34ERy2bWG0WpXiXIice01FQEir+W0HALQQSfHNDVijIhanYsDBbG5nVyqm6lwmfeUXp/dIvahNvFp4vpVfGZcTNHVmBLTv4hQYxdDJMbbutCQQ6NQh5VqUblSyvi4vt4effMMwvlaOPQhww7eWOZzcw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=KOc1eEdIyYOj1ErsYiqPRRGfGGEL6/LcrXI7BDXpiDY=;
 b=XdeNyAXAPDv5IDjZ7qeD04j2/Rs7V6FF3fiIi73Ak2uV3EwJOXL7P29EIbXmXJnUY1q4UXurcDu+9KwQAIFhSj+Fgj1lgyHtXrEiynzRo6ox2AnwWW9d0ozyuTodbIs1Z5LL/dFLB9mV/Hq8ojJkJnMNLG943wWFRKrb7bHz/aI=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DM4PR12MB5229.namprd12.prod.outlook.com (2603:10b6:5:398::12)
 by SN7PR12MB7129.namprd12.prod.outlook.com (2603:10b6:806:2a1::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.41; Mon, 27 Mar
 2023 19:14:18 +0000
Received: from DM4PR12MB5229.namprd12.prod.outlook.com
 ([fe80::5b56:bf13:70be:ea60]) by DM4PR12MB5229.namprd12.prod.outlook.com
 ([fe80::5b56:bf13:70be:ea60%5]) with mapi id 15.20.6178.041; Mon, 27 Mar 2023
 19:14:18 +0000
Message-ID: <2f5c1d5b-c275-fbd5-4cf4-f7b6d0cbff62@amd.com>
Date:   Mon, 27 Mar 2023 14:14:15 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.8.0
Subject: Re: [PATCH v16 8/8] x86/smpboot: Allow parallel bringup for SEV-ES
Content-Language: en-US
To:     David Woodhouse <dwmw2@infradead.org>,
        Borislav Petkov <bp@alien8.de>, Brian Gerst <brgerst@gmail.com>
Cc:     Usama Arif <usama.arif@bytedance.com>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "Phillips, Kim" <kim.phillips@amd.com>,
        "piotrgorski@cachyos.org" <piotrgorski@cachyos.org>,
        "oleksandr@natalenko.name" <oleksandr@natalenko.name>,
        "arjan@linux.intel.com" <arjan@linux.intel.com>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>,
        "hpa@zytor.com" <hpa@zytor.com>, "x86@kernel.org" <x86@kernel.org>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "paulmck@kernel.org" <paulmck@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "rcu@vger.kernel.org" <rcu@vger.kernel.org>,
        "mimoja@mimoja.de" <mimoja@mimoja.de>,
        "hewenliang4@huawei.com" <hewenliang4@huawei.com>,
        "seanjc@google.com" <seanjc@google.com>,
        "pmenzel@molgen.mpg.de" <pmenzel@molgen.mpg.de>,
        "fam.zheng@bytedance.com" <fam.zheng@bytedance.com>,
        "punit.agrawal@bytedance.com" <punit.agrawal@bytedance.com>,
        "simon.evans@bytedance.com" <simon.evans@bytedance.com>,
        "liangma@liangbit.com" <liangma@liangbit.com>,
        "gpiccoli@igalia.com" <gpiccoli@igalia.com>,
        Sabin Rapan <sabrapan@amazon.com>
References: <20230321194008.785922-1-usama.arif@bytedance.com>
 <20230321194008.785922-9-usama.arif@bytedance.com>
 <20230322224735.GAZBuFh9ld6FuYEyoH@fat_crate.local>
 <70628793e6777d07f27f43152df497e780925d18.camel@infradead.org>
 <20230323085138.GAZBwTGly7iOlvxrD4@fat_crate.local>
 <4dbdd277c4b26ae4b971a910209a3279f79f6837.camel@infradead.org>
 <CAMzpN2guz4HTQ8uir9Q=xrUpCYyBfuG2zGSJsakaqY7_OvxCPQ@mail.gmail.com>
 <20230327174746.GBZCHWwqIa4+nj1/qR@fat_crate.local>
 <e0e76d1de1e90aafa2d14f95648fff2569b21a73.camel@infradead.org>
From:   Tom Lendacky <thomas.lendacky@amd.com>
In-Reply-To: <e0e76d1de1e90aafa2d14f95648fff2569b21a73.camel@infradead.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: SN1PR12CA0088.namprd12.prod.outlook.com
 (2603:10b6:802:21::23) To DM4PR12MB5229.namprd12.prod.outlook.com
 (2603:10b6:5:398::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR12MB5229:EE_|SN7PR12MB7129:EE_
X-MS-Office365-Filtering-Correlation-Id: 697d7d31-8b2e-465e-8373-08db2ef77697
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ctRBARmJqrCvXhVldCEDMmiNqi1Dn5l/aOJYRi8bv0Nz4CBbwUBhSvhybXtuaZuStLe7Kie5HEDg38tcJluF0haw9tuBOtk0JRLNpwz8GnZemFt/zb/1B3Sqm21BqAsW+REjwxxqueSayzRBS9AhzMnJuQnzG4m/yvmfHgU46TgLpdt/bvEZWmKR8Ej9+CIdCLQcImtYrkfnm1r7Cc3CQmgU2Txmb7CseqRkNo6jNJTLbQxfVuEexZrXYS6DSY8W7/pEYenpz7ccQW+XxLkShMgSQd4U1/U7oAZ3KPLcRLKStkcqMrV01DzwmFmUiZjB/PalchFyeTAza5rnrZZprShBZMxvc4scAFCtqIOyKZS1Pblm7R2OUCqYEDktBdKgskcq1yfHJpK1/93wi0PEWn3LGf7DZpT8RcIW+83KVLIFdEVwt1r3Gbv3ruWBeTn+uduKw2gVPxuy5QICBlQP7NhaIhH+L6o1/0xKy6etBcKGlfrdIQ2EyuL+obvaft20gRyH2ZBBxw3px/+WNg1NsJG7ghql+21TS37hzvtdMM8DZcLF0EBv/XVpixavIdX5E3x/YeMFuKa0WdxPtS1SFUABCl8UollZRtzCQoAaEiKNw1Wg2NixZfV0H7Xwi+smTXQuTZchMeJoGBPeQ8MRlA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR12MB5229.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(376002)(136003)(396003)(39860400002)(366004)(346002)(451199021)(53546011)(6666004)(6512007)(6506007)(83380400001)(86362001)(36756003)(31696002)(2616005)(38100700002)(2906002)(41300700001)(6486002)(478600001)(31686004)(5660300002)(7416002)(8936002)(54906003)(110136005)(66946007)(66556008)(66476007)(8676002)(4326008)(26005)(186003)(316002)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?RHhSdE5FVU5oQ3VJZkxCN0dPdGJjMGpRTk50TVljdjZRL3RLaVBqcTRJRHh5?=
 =?utf-8?B?Q0xyK3g1NHkySmY0RXF6SWpBdXBGM2xmVXpxRXhxZGxVOHZJSDdQdER4MTJO?=
 =?utf-8?B?eFhIZDcrcjRQbnFPNUE1YWJOZG00QlEzd084d2g2Qk1UQnNYcHFvM3pUSE9n?=
 =?utf-8?B?MmhCUE9kRmU4cmNZTit0WE1KWW9TOVI2SEZBaXpUc3pabXcxUlFURWp0Z1lS?=
 =?utf-8?B?MVdpZnFsRVJRMFpuMWhHWHNiMFIydnVIeDYzQ1NMbWdrdlR4TFJPRkpWNk5q?=
 =?utf-8?B?aGxxQkFjUnZmc1JIM3RxVmcvaWtQaHJ3KzA1ME5nQXZENmN3YzVKVGdkYXAy?=
 =?utf-8?B?OXI2T0pLYlVsb1ltWTQ3UFp4RHcrSGVoelk1NE1yTEdiWVFIbkd5MjZkbWty?=
 =?utf-8?B?UFErMjIvRnZ2S01JUzV0cWQ2eWlkcGhDSlo3WTh3MkIrWEhVeHUwMkxQSDc3?=
 =?utf-8?B?dndwQ2xFcnVQQ1BrTy95V0NxQVZ1ZjJBREVhemxtZjdUNzRudU1qVmZZVlNE?=
 =?utf-8?B?V0tGTXdyM3pNWUJ0bVZ4MHpBcm44Yk1jRE5vVXFLTVJ5YnFCdFAvc2x6YWxy?=
 =?utf-8?B?NncyZE90NGNVdEpRMXBBcURwWU9lSUd3SFZkY0piL0pjRDVpZStkZ01QSTUz?=
 =?utf-8?B?VFdpYUxOSkE1aXFGeGVWcHl2NFd2ZHpPYmY3NTF6RnQ5Vjl0MTRxLzBzN0Ew?=
 =?utf-8?B?a3JmSC8wLzA1UjFabU8rK3lqOE5mYTlxajNPTnF0UkYyWUpjSXZiQ25rOElm?=
 =?utf-8?B?M3hTZHNSVUpqSFJQNFhtUm5CZk9mQ0ozYllaQ2tnQ2hzS3FYWktvTVdqc0hH?=
 =?utf-8?B?ZDdOS0t0akc2ck9FYUt6K0dKZ1NUbVN4VDdSaW03UGxDT2FuS2o0MThwNlZi?=
 =?utf-8?B?NURjMWxUVnFqTXNGUUZMcFJTSmZZaW9LZU1vbFlsRGFSMG5vT3lzUTZTazF1?=
 =?utf-8?B?UnAwMWE3c0NnTUU3R092c2FaMnZnTHlVdVpidmpUa0I4ZFh1UzBzOGowT0lx?=
 =?utf-8?B?emUrcndFYnR2cVE3Y0JRVkhnNU9RalFkcHMzMXcwK08ralNUcGpUN1IwVmw0?=
 =?utf-8?B?b0t1aWdZeUZma3FmSG5JSmhUNEw2YkFsbFNnUFFKMmxjOTcrQ1pDaW1Id1ht?=
 =?utf-8?B?MExMOWZJQ1p0KzdLa3dPUXR3bFlHT2tsNWx2OTJLTXhiRSs1TGxTVlJHelQv?=
 =?utf-8?B?d0V3TVpybkFNRkluckFsSHpJbU1NQ2U0d0dUWEp6dzJwRmtGeDRKMHMvTW5I?=
 =?utf-8?B?TTZ4QkFSTUh2RlFJN1AzaEMrWTBCWGduYU12MjVVRlhJSGcvWFRWL1dYQ2lM?=
 =?utf-8?B?ODltNzV4NksrRTQ0aTJNdk43QVU1RmtiTU5HRlIrbjQrVDYxN051MG1hWndW?=
 =?utf-8?B?WEFQd3ZDNVFGWEJ5bDF0OTJHOU4rNms4NUppZFkrbmV4NDRJL1RGbGp2a29Q?=
 =?utf-8?B?bE1pdDBTSnJRTFlIMkkxb1JsR0pGQWhJaHBvSFRmVHNqMHdCMTZRcTZ4bkZF?=
 =?utf-8?B?Z0phTWdPTy9ZY0pYTGNZTkxFV2M1UFNSKzRvK3BybU5iQmZwSjdVd25DdEdk?=
 =?utf-8?B?US9Zb09IYkJuOW9nZkhuaEczNEFUMzkrcFd5ZWtUOEQ5aFhDbEVPN1ZvaEs5?=
 =?utf-8?B?V3E3RmJERW5EdHpDaGNDcmVFS2ZVS3NBMGlRRlQ5d2lkNENvQ3Nublo0SlNa?=
 =?utf-8?B?VjA3cCt4QTdTNmNWRjB1UjBMK2RFZWl0a2FsbVpwOTdCUUdwTnZ5THJQU1ds?=
 =?utf-8?B?YnNwaG5IK3ZwbkRUS1BtKzVVeTVTTHFSWWVzQnovMkdEQ0dTL1Y5blkrZ1NZ?=
 =?utf-8?B?UE9TUWxxYThrQ0RoVHN3SXAybFA3VFV3RHM4ZWNERFFadFM0Sk0wdms2QS9L?=
 =?utf-8?B?K0JhREExeHg3VkxtR0t1VXJyWHl1NEFxTTY5MDdCakhQbGZER2VoUUZpcWlF?=
 =?utf-8?B?N1ZheUk2dkZVNFVkQUVmZmlVUlRWbjFCdGtTZ2xDZzZLdjBhZ2VpZzA4SlRo?=
 =?utf-8?B?aTk1TDBWbnFxYWdzbnBoRG1tQWYyK3IzQ0QrQTBSaHNYU0ZUemN5bzBwditX?=
 =?utf-8?B?TC9PZ05rUHJhZXFlY0VqMHJPbXczRGoxMllKakljOHhaam1qYU9oRzU3ZGZs?=
 =?utf-8?Q?OkERv/RnnYmQDt2e4Vko2gjLa?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 697d7d31-8b2e-465e-8373-08db2ef77697
X-MS-Exchange-CrossTenant-AuthSource: DM4PR12MB5229.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Mar 2023 19:14:18.6685
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: KfHtjgSSh/jmAPrtIhLi+HE3vwS1QWDEFEAcQLomgnJTx3XrpM7eUGA6Yk+TL/o37JEDHyBJmKwDip6HfOsLOQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR12MB7129
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 3/27/23 13:14, David Woodhouse wrote:
> On Mon, 2023-03-27 at 19:47 +0200, Borislav Petkov wrote:
>>> Making sure that the stack protector is either disabled or properly
>>> set up, and disabling any instrumentation/profiling/debug crap that
>>> isn't initialized yet.
>>
>> Lemme dump brain of what Tom and I were talking about today so that it
>> is documented somewhere.
>>
>> * re: stack protector: I was thinking to mark this function
>>
>>   __attribute__((no_stack_protector))
>>
>> but gcc added the function attribute way later:
>>
>> ~/src/gcc/gcc.git> git tag --contains 346b302d09c1e6db56d9fe69048acb32fbb97845
>> basepoints/gcc-12
>> basepoints/gcc-13
>> releases/gcc-11.1.0
>> releases/gcc-11.2.0
>> releases/gcc-11.3.0
>> releases/gcc-12.1.0
>> releases/gcc-12.2.0
>>
>> which means, that function would have to live somewhere in a file which
>> has stack protector disabled. One possible place would be
>> arch/x86/mm/mem_encrypt_identity.c which is kinda related.
> 
> Shouldn't the rest of head64.c have the stack protector disabled, for
> similar reasons?
> 
>> * re: stack: in order to be able to call a C function that early, we'd
>> have to put the VA of the initial stack back into %rsp as we switch
>> pagetables a bit earlier in there (thx Tom).
> 
> Hm, don't you have a stack at the point you added that call? I thought
> you did? It doesn't have to be *the* stack for the AP in question.
> Just "a" stack. And you have the lock on the real-mode one that you're
> using.

Unfortunately RSP has the identity mapped stack value and when the 
pagetable switch is performed the mapping to that stack is lost. It would 
need to be updated to the equivalent of __va(RSP) to get a stack that can 
be used without page faulting.

Thanks,
Tom

> 
>> So by then, doing all that cargo-cult just in order to not have a bunch
>> of lines in asm doesn't sound all that great anymore.
>>
>> * The __head per-function attribute is easily solved by lifting the
>> __head define into a common header.
>>
>> So meh, dunno. I guess we can do the asm thing for now, until a cleaner
>> solution without too many warts presents itself.
> 
> Hm, doesn't most of that just go away (or at least become "Already
> Broken; Someone Else's Problem™") if you just concede to put your new C
> function into head64.c along with a whole bunch of other existing
> CONFIG_AMD_MEM_ENCRYPT support?
> 
> (We still have to fix it if it's Someone Else's Problem, of course.
> It's just that you don't have to count that complexity towards your own
> part.)
