Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4D13869DA12
	for <lists+kvm@lfdr.de>; Tue, 21 Feb 2023 05:21:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233027AbjBUEUw (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 20 Feb 2023 23:20:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40986 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232411AbjBUEUt (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 20 Feb 2023 23:20:49 -0500
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2045.outbound.protection.outlook.com [40.107.243.45])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4D89B241D7;
        Mon, 20 Feb 2023 20:20:48 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=AZD+GC0LtaeFCQhGdvg9nFzYn3XNxPqfyFYHOdEVx0iu2jVN0Ssbnw1OQJ2GE1S2LIhgTe+SBzueJb737WLdRMtJEFIyn9f0gdpcGhTz++YbSAnkT7Rx6rBQg+jlIeLU1i2RFEjoz4s60NR6EzFq0ldQVNtnL12gXkkABDbe1l4mEbyVKGaRDUxCwztPXG0JzzECGoloXLwhU4PLmgFxXAEHvJuMHHxggb92PQE0n6lM+3VaRDpHrUFWlAxbIwlaf4OLOh8lwvZYhtfr7bOGZ4vsATfSLB0LZHS/2Ga4KRiJGYVMUhVLqO2VzgAWU0yLyvbnw/JNW08FC/+vaPjXmQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=8Nr+tvdxjp4fylNXgqQT7u2GeQRkc3cCkA4Ms4RuSqQ=;
 b=HyQw/LpNmK5oIvT7AQ/XnFHBFhfExzskMmKbOORHkL+EZGjrpdxkAIXEd/XPDUfwGfBaP07tmWtV3R/JTUTSYiDian4PoWYPO8xCxzthAjHLf9iCJ0+K8OODOx9Cr8XBq7R/T4Z5Gn4vwi9rRBW/yPQxUqQ6NoWrVhv4PPToageHKkqwYgI1Y51C74mEdqfiY6Ew8WI1HXMfbPxz+hccfnZXQYLMBOgAowLm/8v5TrMuNMP2WvD3fLN1QGKk42AW31CV+r1wkQVLXO7nnG+XEKl6tnw9Oj+tUYoYyqab2pgQK+6vm1scwSyESGAr+/Hs1oNW/fOolyWtkR8Bnk6wOg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8Nr+tvdxjp4fylNXgqQT7u2GeQRkc3cCkA4Ms4RuSqQ=;
 b=nHsfURU6UY7KQnBbHICvVZN+IPcs/klh+pVv0u3gFRUCWp/9s/KVdEcO9xTeGk0RNHOiSMAKhEg6MCQ07FV3pjEvfRhJ8SMRcH3IVTHOvlgPzVCg2pcDkStQlik+qwdHwAYzXDcY9O9rPBsq4OfQyYDWLU3awPaDD9lOMXrzt8U=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DS7PR12MB6263.namprd12.prod.outlook.com (2603:10b6:8:95::17) by
 CH0PR12MB5091.namprd12.prod.outlook.com (2603:10b6:610:be::10) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6111.20; Tue, 21 Feb 2023 04:20:46 +0000
Received: from DS7PR12MB6263.namprd12.prod.outlook.com
 ([fe80::e144:1523:4928:b4]) by DS7PR12MB6263.namprd12.prod.outlook.com
 ([fe80::e144:1523:4928:b4%5]) with mapi id 15.20.6111.021; Tue, 21 Feb 2023
 04:20:45 +0000
Message-ID: <6a25f9a6-c4c4-ddb4-a3c7-c151bd7f2a89@amd.com>
Date:   Mon, 20 Feb 2023 22:20:41 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.1
Subject: Re: [PATCH v9 0/8] Parallel CPU bringup for x86_64
To:     David Woodhouse <dwmw2@infradead.org>,
        Oleksandr Natalenko <oleksandr@natalenko.name>
Cc:     tglx@linutronix.de, Usama Arif <usama.arif@bytedance.com>,
        arjan@linux.intel.com, mingo@redhat.com, bp@alien8.de,
        dave.hansen@linux.intel.com, hpa@zytor.com, x86@kernel.org,
        pbonzini@redhat.com, paulmck@kernel.org,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        rcu@vger.kernel.org, mimoja@mimoja.de, hewenliang4@huawei.com,
        thomas.lendacky@amd.com, seanjc@google.com, pmenzel@molgen.mpg.de,
        fam.zheng@bytedance.com, punit.agrawal@bytedance.com,
        simon.evans@bytedance.com, liangma@liangbit.com,
        Piotr Gorski <lucjan.lucjanov@gmail.com>,
        "Limonciello, Mario" <Mario.Limonciello@amd.com>
References: <20230215145425.420125-1-usama.arif@bytedance.com>
 <2668799.mvXUDI8C0e@natalenko.name>
 <ed8d662351cfe5793f8cc7e7e8c514d05d16c501.camel@infradead.org>
 <2668869.mvXUDI8C0e@natalenko.name>
 <2a67f6cf18dd2c1879fad9fd8a28242918d3e5d2.camel@infradead.org>
 <982e1d6140705414e8fd60b990bd259a@natalenko.name>
 <715CBABF-4017-4784-8F30-5386F1524830@infradead.org>
 <67dbc69f-b712-8971-f1c9-5d07f506a19c@amd.com>
 <42dc683e2846ae8fc1e09715aaf7884660e1a386.camel@infradead.org>
Content-Language: en-US
From:   Kim Phillips <kim.phillips@amd.com>
Organization: AMD
In-Reply-To: <42dc683e2846ae8fc1e09715aaf7884660e1a386.camel@infradead.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: SN7PR04CA0020.namprd04.prod.outlook.com
 (2603:10b6:806:f2::25) To DS7PR12MB6263.namprd12.prod.outlook.com
 (2603:10b6:8:95::17)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB6263:EE_|CH0PR12MB5091:EE_
X-MS-Office365-Filtering-Correlation-Id: 3d96cf98-783f-4ed2-fa31-08db13c3009c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: /pvggjZ1KDKs5lCbhJLCuhkIQyMcvY8YwDPgRpcjcHkwESl1XyBTQ9ytBfg7YV0nQ0VxoSt/UKy2qzV42+M2SYqCR7MUaAVYA1JewNXLMxTenDRFdbPDEW8W97AnA1NiVgFxEwowcwtHq7YQov/BkvUKBKxTJIgdpFHl3th4TM6wCM8JmB+NAjGOn+e3w7BI4IOeuO+zJ7JnD2zrNAXmbE3HITjU03UR5tMuRJ8YT6JUxgKDmSR8mX3MG6SFGWmh40b5vMsAVTpby9FssgLqPg6EHTjYCNm17oohGKG8Cc4WiW7I//tKZjCzB5mKgjLepYhCMAC0qbFzm2IYSeLIkuaegPpsEh+eKWvMN6NDiyVjA/qnhfq4VXnR6e7Ub88UjI6xZWrD7R/isoVqBjt+VfFz8POSLBLzwbR/RhEEQC5pvL/WRJqf7UfkY92I8suvAesToLLzYewbgH7H5RfqaEzrW0kpS9BTlI6fCROIdcCxFbBj+A/NxeBRSCrIRwyX1t3E3TI6gAdtVG5GCweTFDzgfpjDmMzwbd8hJ44AQZS1ernTspjne1bmLTJgRzULBzmauVDaZRh5QnYXtgnz2rooqUJiavWKApM6WjeA5R0vM8n8mkyL+PeNm8ofZnBT02JaBAW36WbCvyYz8c/H512w3k8GSoytPqPf2eu0ck2KlAN6kyhzrl/tnI5ytnsEyEGhAdhFgSRx3DGiu7VarYQ14+8ZQ/YzxGYrS3xKxZ0=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB6263.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(136003)(366004)(396003)(346002)(39860400002)(376002)(451199018)(38100700002)(44832011)(31696002)(86362001)(5660300002)(7416002)(2906002)(36916002)(31686004)(478600001)(6486002)(6512007)(53546011)(66574015)(186003)(36756003)(6666004)(66556008)(54906003)(316002)(110136005)(6506007)(2616005)(4326008)(41300700001)(66946007)(66476007)(83380400001)(8936002)(8676002)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?aGR2SS9JK2kvUVQ5WDhPRk5GZTVvelRxODJQcEIwL0JIZ3ZoL1UwOEdxR3R4?=
 =?utf-8?B?QlIycDU0eXRKSHBlZHR0UE0vRS9ud0tTMHpFK25XZFhnS2lvbkxnNzZxQlo3?=
 =?utf-8?B?c29FVXRnUkdoM2FFdHdvWkVvYWo2Qk5GTHR3WFpuNnEzdXBHOHBjSkN2UE9m?=
 =?utf-8?B?MjZ4NW1ZK2c4WFRlMzZ3T0xZTGxKUHNwVTAvVU9kUjFEenhWNXdBQWE3NVl0?=
 =?utf-8?B?OVNzUlRZMFBTeTAwZGQySyt3YjBEMUhmWTdaTEpDbFR0d0JpblFKQmloS0Yr?=
 =?utf-8?B?eDNHVmpjamVPMEN4c2ljMkRWbUJQZ2hJeWRMOXZQQkpYY0JiQ3Z3Z0RQTWlY?=
 =?utf-8?B?aGdxd0VJTWZwdTFwbE5iRzlwNGZzcE1iNytQMnViT2R4MHlZaHpWdGVvQ0Rh?=
 =?utf-8?B?MWxyQWNyeUVZTlM4K25xeEJDempKSUg1WUZ0a0NidDdJMDNaKzczYittblJ0?=
 =?utf-8?B?bkZVUnhtU2ZPM05SS3YrV0haQTF1S0N4S0dKWDBIajBoSDFURDNCTnowWFF0?=
 =?utf-8?B?OFlvTEZrTVcrSmNpODZ2ZFFDZXRIMmhuaTI1ZHlQSXFydXhsb3JkM3R3ZWhj?=
 =?utf-8?B?UDBkanhjSnNSRjV6aDYyZ29GOE1CYjdEb0FpbHFrZ3MwWEZrR01mUGgyNzB6?=
 =?utf-8?B?MlhkS1c3TXcrTmp1QUFGdVYzRnUyNk4wbXNyaVNRTUo5dDVFNFVObmxGTTNE?=
 =?utf-8?B?Y3pqN3g3ZE5UNTVJamdHM2pNRFNMZVZsL21nWHVrZlg5VGVYOTd5eHUrU3Ro?=
 =?utf-8?B?cE5RSUJiRFpQTFB1b2ptdENETmhtbGg4WXdrdVlhd2xJem40cFUxQk9Jclpa?=
 =?utf-8?B?NUxFM1JJN1d3Qkdkelg1eHhxVDA4SCtZQVdyYTVVaUp5ek51RVR6Z3E2b0pt?=
 =?utf-8?B?S3cxZkNMZnhGNlZzTFA1VzhpNmRsTUg2UXRwN3BZdk5LRWJ6bXVKcHhUMkFW?=
 =?utf-8?B?OWxLTjVsTjduN2lmK3RETElRQUVtT1ZQY1RaWDlHTUJUcVRBVHNmN255UzFW?=
 =?utf-8?B?UklYem4vMXcrYXd1T094VStSQUUzbjdoRldqdEtvTTdLc3NLYzZZdG1YMmh0?=
 =?utf-8?B?NDNYaDB2WWw1QXVnRTJpb3pVOGYyWWYyNENHVXU1czZFNGtYNlI5U0s2KzJ4?=
 =?utf-8?B?T1ZPY21LRVhqWEQrSWczTUtaUDd4WDBBWnFKaTJRdEIrTXdUN3FlSk1TNTZR?=
 =?utf-8?B?STFjdStWRVhhdERDUWtja3ZoRCs1b2V4WHNNajZEMGtVbWpHazgyNVdUcXNz?=
 =?utf-8?B?dE55bWRYOWczWlRSZUMwWnBId1lXT2ZMSFBFdng1NnNyeGZ1aUlmQ0dWSkZr?=
 =?utf-8?B?K0t4SlRhbTd6WDZSMzVxbUlhVFNrR1k1bno3ems4MkdPYnp2R044OVNzUG4w?=
 =?utf-8?B?Y01ZdFVZc2VlZlk3eTlSa3V0SDZydDZqdkpyMmVKVXdlcGhXZ3hnVzJFTHJW?=
 =?utf-8?B?Q240SDZTdVFOeEFMRmlxYS9mZDJZWkV5Ylg5aFNHbFJSVkdGZXZGbmxXK1kv?=
 =?utf-8?B?R0hiMUhMR25OdEphdXRDZEczYzJqNUI3Lzg0bFZxQWpMYmV1a0NybE8xNnpn?=
 =?utf-8?B?eGQrNWpGMmE0NnQ2QUxQZHg2ajlhQnVqM1VkSXRtaXZEZXJDR01lWmNXbjhI?=
 =?utf-8?B?WWVsZTRBZU9OQ2dwTE5SY2JTcEFFb1FFeDFqYk9XaGdEQVVGejVCVjJqYk5K?=
 =?utf-8?B?aHBnM0hKWTVEVFU5N0ZhNEZLdTZZWk9aaUR3Q2VYT0JWeHNweG5ncHNNVTRr?=
 =?utf-8?B?WDNZdk5nUHc2Umw1aHZ4VjlGNG12YWFyN2VZK0U2STlGbjFMZUtGT0VPazZI?=
 =?utf-8?B?aENIN1I3ajZTK202d294aXFnT1BsZnIzZWdrYzBFa1EzWlBzdnNYMzR2MUlJ?=
 =?utf-8?B?QStYVktqaWJ1ZzRpVzArVEdmR2ZOU3VST3o5a2ZOOUl5N1NRYXRDSmRvY1E1?=
 =?utf-8?B?TnkxS0dIc1FleXY0akY5MnlXWEhRcm1TbXo1VnRuUTZSUzBnbEJMVjg1SGVj?=
 =?utf-8?B?MGhCcTU4R0xBSkRQZW1oQ3ovdjRmZWhhSnI5WjNibUF1SGpCYTBMcVRSL1Fy?=
 =?utf-8?B?Q2c1QmpUVEhvdTlseDN5aXM2c0NtNlQ0S0ZBd2c4Y0JJVjRiV2tUQ1RXa2Rj?=
 =?utf-8?B?bVpOcWZ4OHRJTkQ3TTBDMDlYNHFzNEF2VDY1eGNrWll4VEVOL3VBRXVLQmZ1?=
 =?utf-8?Q?9JE0YT9hh/H6RVuQy1z3RglisMnStsP77zTZUIYkdsbC?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3d96cf98-783f-4ed2-fa31-08db13c3009c
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB6263.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Feb 2023 04:20:45.6175
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: a5ur0gJBJNiW9C20TAePq+DSbDtJ/dvIXf3c3/aRJivxciB/2Ny+ds4QdPswVPdjge17Ua3QRZELw5lj16/tYg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR12MB5091
X-Spam-Status: No, score=-1.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 2/20/23 5:30 PM, David Woodhouse wrote:
> On Mon, 2023-02-20 at 17:23 -0600, Kim Phillips wrote:
>> On 2/20/23 3:39 PM, David Woodhouse wrote:
>>> On 20 February 2023 21:23:38 GMT, Oleksandr Natalenko <oleksandr@natalenko.name> wrote:
>>>> On 20.02.2023 21:31, David Woodhouse wrote:
>>>>> On Mon, 2023-02-20 at 17:40 +0100, Oleksandr Natalenko wrote:
>>>>>> On pondělí 20. února 2023 17:20:13 CET David Woodhouse wrote:
>>>>>>> On Mon, 2023-02-20 at 17:08 +0100, Oleksandr Natalenko wrote:
>>>>>>>>
>>>>>>>> I've applied this to the v6.2 kernel, and suspend/resume broke on
>>>>>>>> my
>>>>>>>> Ryzen 5950X desktop. The machine suspends just fine, but on
>>>>>>>> resume
>>>>>>>> the screen stays blank, and there's no visible disk I/O.
>>>>>>>>
>>>>>>>> Reverting the series brings suspend/resume back to working state.
>>>>>>>
>>>>>>> Hm, thanks. What if you add 'no_parallel_bringup' on the command
>>>>>>> line?
>>>>>>
>>>>>> If the `no_parallel_bringup` param is added, the suspend/resume
>>>>>> works.
>>>>>
>>>>> Thanks for the testing. Can I ask you to do one further test: apply the
>>>>> series only as far as patch 6/8 'x86/smpboot: Support parallel startup
>>>>> of secondary CPUs'.
>>>>>
>>>>> That will do the new startup asm sequence where each CPU finds its own
>>>>> per-cpu data so it *could* work in parallel, but doesn't actually do
>>>>> the bringup in parallel yet.
>>>>
>>>> With patches 1 to 6 (including) applied and no extra cmdline
>>>> params added the resume doesn't work.
>>>
>>> Hm. Kim, is there some weirdness with the way AMD CPUs get their
>>> APIC ID in CPUID 0x1? Especially after resume?
>>
>> Not to my knowledge.  Mario?

I tested v9-up-to-6/8 on a Ryzen 3000 that passed your between-v6 & v7
tree commits (ce7e2d1e046a for the parallel-6.2-rc6-part1 tag
and 17bbd12ee03 for parallel-6.2-rc6), and it, too, fails to resume
v9-up-to-6/8 after suspend.

> Oleksandr, please could you show the output of 'cpuid' after a
> successful resume?  I'm particularly looking for this part...
> 
> 
> $ sudo cpuid | grep -A1 1/ebx
>     miscellaneous (1/ebx):
>        process local APIC physical ID = 0x0 (0)
> --
>     miscellaneous (1/ebx):
>        process local APIC physical ID = 0x2 (2)
> ...

The Ryzens have a different pattern it seems:

$ sudo cpuid | grep -A1 \(1/ebx
    miscellaneous (1/ebx):
       process local APIC physical ID = 0x0 (0)
--
    miscellaneous (1/ebx):
       process local APIC physical ID = 0x1 (1)
--
    miscellaneous (1/ebx):
       process local APIC physical ID = 0x2 (2)
--
    miscellaneous (1/ebx):
       process local APIC physical ID = 0x3 (3)
--
    miscellaneous (1/ebx):
       process local APIC physical ID = 0x4 (4)
--
    miscellaneous (1/ebx):
       process local APIC physical ID = 0x5 (5)
--
    miscellaneous (1/ebx):
       process local APIC physical ID = 0x6 (6)
--
    miscellaneous (1/ebx):
       process local APIC physical ID = 0x7 (7)


I tested the v7 series on Ryzen, it also fails, so
Ryzen users were last known good with those two
aforementioned commits on your tree:

git://git.infradead.org/users/dwmw2/linux.git

Thanks,

Kim
