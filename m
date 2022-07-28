Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1CFCA583AC2
	for <lists+kvm@lfdr.de>; Thu, 28 Jul 2022 10:55:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235166AbiG1Izh (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 28 Jul 2022 04:55:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37274 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232973AbiG1Ize (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 28 Jul 2022 04:55:34 -0400
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2055.outbound.protection.outlook.com [40.107.93.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 82ACF5465C;
        Thu, 28 Jul 2022 01:55:32 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=faEW7jQq/JTjUwkaulRWjXjyg2Uf/b5D4JpSS8SFF9J/kD1VNRvcU/ER/clL4vrwxl4jDqrd7VFyzWccBco+YqEeqWnEfrkazgvx4UNTktZmGMKyePjE/G7cLqlpVEl1AQwn81LjInZCUOMhRvI70pf+mArevD6B2v60kB55Hs2iknf3dqo1lz4AVQ0iAKUr0PQp++gXlIQl+30SwaxzEErgnMTScZ0o2u5ykdVPTaHoFrxWfUlJ48S1x7gao01P5DarqqRkvGX2K5bsCh/GZe0qrZDiEQApPjI5+kFa/u/SDThO9xOIcvUAVzkhJBM9GbS4IT2+0taQ/h0Jyz1wIA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=01QpA+ex8tsqnjXdnb4cW8q//GT5fWIglamtCgTdt/0=;
 b=aCe0DiHVZyOHF8rWxXzNDuCSDPBc+jLXHPWXMUM8YTEr/wGUZrxoSnuteMGUTYaLfZd5HoVQCBX9OZxKeKYptP2cOBUFMaFja75/esBwAq5gq+WphahITJKrFFHrYgPGakp4aeyToOww415O9itpYw8yuvLpoL8XJf5/B2Fim30Q+22jkuv6H/LL9bqKebZodwWzuRM7tLNrdA1Pt1SpbfU/wfVLR6pJ6xYG3xcL7jspT+HaQtCRE+o0NMQKDVMulPlQs0S6Ohgcs01CksU2NWDBjFtA42zxH4ajucs4YwHNSyHfYN4BOPJ9X93HCqQnnsdfNhFfqoFJPe3weATS5w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=01QpA+ex8tsqnjXdnb4cW8q//GT5fWIglamtCgTdt/0=;
 b=hcoYcJsXUII3LG7zzI7a+bitXhcIkwISsHSzTrgbN9xMioKdsXiec5EmwBKXzz6Mx3edvGf10sZSn8fhIsGeAFZTEuGFYAiBk07Y9Ols0dFwt87GYzSKEHHA2qKWR/xJ6JHXkBUYr/3ufgluZTEJZMweTJyWq+b3NGCRKgOFFgM=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DM8PR12MB5445.namprd12.prod.outlook.com (2603:10b6:8:24::7) by
 CH2PR12MB4150.namprd12.prod.outlook.com (2603:10b6:610:a6::24) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5458.19; Thu, 28 Jul 2022 08:55:30 +0000
Received: from DM8PR12MB5445.namprd12.prod.outlook.com
 ([fe80::d4af:b726:bc18:e60c]) by DM8PR12MB5445.namprd12.prod.outlook.com
 ([fe80::d4af:b726:bc18:e60c%7]) with mapi id 15.20.5458.025; Thu, 28 Jul 2022
 08:55:30 +0000
Message-ID: <257483ff-0224-ad67-614e-2c9e6c9d99a3@amd.com>
Date:   Thu, 28 Jul 2022 15:55:26 +0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.11.0
Subject: Re: [PATCH] KVM: SVM: Do not virtualize MSR accesses for APIC LVTT
 register
Content-Language: en-US
To:     Maxim Levitsky <mlevitsk@redhat.com>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Cc:     pbonzini@redhat.com, seanjc@google.com, jon.grimm@amd.com
References: <20220725033428.3699-1-suravee.suthikulpanit@amd.com>
 <6c1596d7203b7044a628c10b97eb076ad0ae525f.camel@redhat.com>
From:   Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
In-Reply-To: <6c1596d7203b7044a628c10b97eb076ad0ae525f.camel@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SG2P153CA0019.APCP153.PROD.OUTLOOK.COM (2603:1096:4:c7::6)
 To DM8PR12MB5445.namprd12.prod.outlook.com (2603:10b6:8:24::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 560d09fa-9fb5-4580-05be-08da7076ec94
X-MS-TrafficTypeDiagnostic: CH2PR12MB4150:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 2N+opXigTC7knXwK6sqJ2aZNm5vF9rTV6iJhQoSTJPNAC/d3NtAExgiiLjm7sWqiQIu/qFKfgkIGuwAivxutPiD8MwtejYm3B0WCK+ED+T8+RHaW6L+6nMz7sC/rE/KaeXyQP6+hR0m7NwvxD6rgYDWeqC5MsieXWQC+52Fxpc6YtImiZosJjj8r1EX+6iBMtDRHVFg/P3nKAMX+5P9OpGCxwnFPVgeY7MkMAX+5fH0MpyCzOEaEzeQyltEp+7KssbeXj1nDt1vwXe7JPk+iU/mAfRe9Et7nBxye9/cJ0MqCi9rdBCkcCx2sGJJVj4HWbVTACdjFZIj08ScClOXwE9VapjoimgG+Ycqb9k7KdqBnWIuL0prM1MOTAXf2rmG28vbZxb5DaWkMBn+awL4n5IS37Zt1Hu4mb8ptCn0mbz7CMkB7Vc4HwavvvGkGbkkU2Pu3iBXkkJ3jOU5oEz4zxJVYMiu3q5IF1gBWOeq9SVFOTAt6CWPi3wEgevYqYr3Fq8VrzKwXewRHIRauOfhBpBuc1UlQD6ucVWQuftmcVXh02QD0L42E30PVm1FCWoEw7PAdGFsE8m6B5gWdD/PNqbNNWzdsgGOyasSNUSHF0DmU5sofIs3QfJNqgEWzJ/vvdAkkdl0Y3Q/NLO86mcuRU3ocv+ZEjX1YToRKS2P7LvQv2YmaT9YVkhV2CJqGUhRKig7GPazcoQh6cbjMmQrcr9v7umTJzB5roT93Dgs4nK5xOLB+UPePaGillPFPGnpIH46AHOhsNMABaNl6fVEUwHoFo1yi7H5nBRxQuLdBQkzv6JWbxNBhQSM78qRmF1nD+RYt3mUarSY4SYelgh6zXg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM8PR12MB5445.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(39860400002)(136003)(366004)(346002)(396003)(376002)(6512007)(8936002)(2906002)(66476007)(4326008)(6486002)(478600001)(8676002)(66556008)(66946007)(53546011)(31696002)(36756003)(186003)(316002)(86362001)(6506007)(31686004)(41300700001)(6666004)(5660300002)(83380400001)(38100700002)(44832011)(2616005)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?Z0o0UXlCMXQrVjJrTnR4WXFEMzVlZ1VOMUg2ajFUM1d5WmZ5QW4vNTVCVTBh?=
 =?utf-8?B?aEt6K3B6OG5KcjJ4SW5qWDBKQ1JmRWtZWS9xZHNUeHZEUEc2clVPVC9iVlAw?=
 =?utf-8?B?RnByaUlNNjF2QVdQeEMwNXJkZHhuRUJhNHo4YXlxTi9mNm5sc1ZHK2Z1V1pm?=
 =?utf-8?B?alhqV0ZIT1hvdzJ1Tm00R2l1RWpkMVBOdi9BVkVPUzdBTTlUYzZRUjJUSis5?=
 =?utf-8?B?Q2JyNW8rMnN4STN6YWM0aGRWOGhUVkR1T3RyWFJ5QWdteWZ2UTZIbHhybUlW?=
 =?utf-8?B?Rjh6TmYxUTlDRlp5NzQrTXpTcDVsS0QvQ0h2akNxeUJZZ3libmM1TTRQUWZQ?=
 =?utf-8?B?cVRIaVdvazdIOE9ZQlNYTVh6dTFTcklzcEF0VWtTelBzcWtnb2pXN0ttR3VK?=
 =?utf-8?B?MzE3SzNoem9kNzZsQWMwZkJKd0MwclB5L1Zob0htQWZMZklOVXRvS3VLdnRD?=
 =?utf-8?B?NE8yRHQyM21VSzFFQmF6UzI1WnNvTG9oTitoL0NoTnYya1o3ZFFMWVpqaytx?=
 =?utf-8?B?WU12aWhRcjAyQlpVU2RvMlY5dXF3WWk0b1U3ZGRnbWJSd1RjK2J3VjBDdStO?=
 =?utf-8?B?U3hEMVY2c0Q3RmRmUWZVSU9DNHJ1V0w4V3dpY2JCem5XTlVFOFBJMDM0V2lq?=
 =?utf-8?B?cFdjeURjV01xbURoUUJRdzJFaDZ6UWZhWGt6WW5TWFdxZkw1aWplMDB0UUMz?=
 =?utf-8?B?dnhvOFVZWDhCODE2OVJGOG44KzRXWE9SKzg5NnZQd09PRHh1TUpzdmpBRGp1?=
 =?utf-8?B?ZVFUTHZCY1Z3bnBqNUtPM1hHT2dFOG5rbk1PNUlnaUM2VVFMcDRTL0xEaGIx?=
 =?utf-8?B?ZWlsMGFaekpIYnhxMlUyVkdkVllubzlSQTVWaWlGRExRbGRUdkJjTnJxMko3?=
 =?utf-8?B?NThvbDQrSWtESmk3ZnpJdnFmNHlWWUF4bkZUR1ZHdUVQQmRVR1orekVxZGNz?=
 =?utf-8?B?WGVyTCswOGZkNzBvQWlBais5QVZBd3ZCQ1RrZDRSMmRnTCs5Y2tRRGZNQ0RL?=
 =?utf-8?B?bWdYa2QrdjlTOStZNnJ0cnhrMDZobW9ZZnE2Vk1kdk1ZdU8xV2RVWUd0WXp3?=
 =?utf-8?B?dkUxOFcxbG5nREJLZ0FHallZcU1VUUpPSXl0NitFQzFUdkFDb0RIZy9uZFlr?=
 =?utf-8?B?VDQ5UG9TdXptZ2Fha01jbElOcCtmbU5oQk5sQi9Wejd3eHk2WjVRU1o3dUVY?=
 =?utf-8?B?UjZzTHdFcWRVYVNyTzBENFpjcHpuK0RtN2kwQlU5WXBVVXlDSzZaUjFvSjZN?=
 =?utf-8?B?bzlMbVlBOHdqQXByMXh3MHJmYk1SYjRGUGMwWkJ2U1djWnBwcWhNemFqa25h?=
 =?utf-8?B?cTk3VXVFZ2g4QjUvU0czUjRLN0tKdzlQQWlLbUpKakZOOE1YMk11UlZrWmJ4?=
 =?utf-8?B?UlZDK3ZseUJMa0NaQmw2cVBibjdTU2Z3LzJtRytJeXk2ckk4OVV2R0tPL3RR?=
 =?utf-8?B?eTBwZy9BZkNMRTJXUHpSWjV2T1A1T0QrRFRQVHBNZm55Z0RrNEswUHR5QXdE?=
 =?utf-8?B?QlRlQVRVTHkzak0zVzQ0eThNSDJGaXQvOUllTzBQaENJdWgralowQXJESkhF?=
 =?utf-8?B?aGNYdTF6WmFwZ1FPK1F3YmNRUk1TdFo2UVByU041cEc0Z1ltYkZWYTQ2VWtC?=
 =?utf-8?B?U3A4TFNobEcydEZLWGl4SmF0M1dYbURNUTdTVHBkUTkwQ0ZESXpNb0VqWTRq?=
 =?utf-8?B?dFhPZUsxck1HSnZiR2VUbEUrdC9qN3V1OWpFNlJ4TjlzemlZdUd3REI3eHRq?=
 =?utf-8?B?QzFiU0kydFM4Rlo5V3pSSXNueCtYRXA5VlhPbTN3SHQrQ3ZHcVVvbWRJcGlY?=
 =?utf-8?B?QlJzU0l5ek53dHN6Q1F6bnN6d010MXZ5NzYwM2M2M01mYmZIcWRiMGRNRXVw?=
 =?utf-8?B?eHQwYXVxVHRIdm5Ib042OG45Y084dzQ1VDFZemJFNXJxTm4zbEloeEJYL2Fk?=
 =?utf-8?B?ZG1iNHlzeUFUVWFtQUFWUWQwQUxHRmsxQlIvN2NmcFpIUExWaXRiNG8rWkVZ?=
 =?utf-8?B?SGZwOXdGc1A5eGhYeXdCWVFIbE9xeEZoYmFPVHBmb1NMYTlQZEdBeVVFWGhm?=
 =?utf-8?B?Vm5Rb2dIMngwcTh0SHJKeWUwVnJBWHlSbStYSCtsaTlDcVJNOTUwd1VwNWFt?=
 =?utf-8?B?dUIycDBnM1IxcklxdTFpeEMwYmcwalFRbTFYUVViM2Vvb1ZrelpLZ2Z3MW1n?=
 =?utf-8?Q?KWqDzr3xL4MFkqHfDoYoXMl9h7UmLD30N0lRKhBteM9l?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 560d09fa-9fb5-4580-05be-08da7076ec94
X-MS-Exchange-CrossTenant-AuthSource: DM8PR12MB5445.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Jul 2022 08:55:30.7046
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: F0S7JWEHBS3x3oNUOpmz0y2SUxoD4ZZkBfZnQJPrAHrOVJcPo7h5gal4E1eDO631mxqOpgUkhB9bn2zFGT31RA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR12MB4150
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Maxim,

On 7/28/22 2:38 PM, Maxim Levitsky wrote:
> On Sun, 2022-07-24 at 22:34 -0500, Suravee Suthikulpanit wrote:
>> AMD does not support APIC TSC-deadline timer mode. AVIC hardware
>> will generate GP fault when guest kernel writes 1 to bits [18]
>> of the APIC LVTT register (offset 0x32) to set the timer mode.
>> (Note: bit 18 is reserved on AMD system).
>>
>> Therefore, always intercept and let KVM emulate the MSR accesses.
>>
>> Fixes: f3d7c8aa6882 ("KVM: SVM: Fix x2APIC MSRs interception")
>> Signed-off-by: Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
>> ---
>>   arch/x86/kvm/svm/svm.c | 9 ++++++++-
>>   1 file changed, 8 insertions(+), 1 deletion(-)
>>
>> diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
>> index aef63aae922d..3e0639a68385 100644
>> --- a/arch/x86/kvm/svm/svm.c
>> +++ b/arch/x86/kvm/svm/svm.c
>> @@ -118,7 +118,14 @@ static const struct svm_direct_access_msrs {
>>   	{ .index = X2APIC_MSR(APIC_ESR),		.always = false },
>>   	{ .index = X2APIC_MSR(APIC_ICR),		.always = false },
>>   	{ .index = X2APIC_MSR(APIC_ICR2),		.always = false },
>> -	{ .index = X2APIC_MSR(APIC_LVTT),		.always = false },
>> +
>> +	/*
>> +	 * Note:
>> +	 * AMD does not virtualize APIC TSC-deadline timer mode, but it is
>> +	 * emulated by KVM. When setting APIC LVTT (0x832) register bit 18,
>> +	 * the AVIC hardware would generate GP fault. Therefore, always
>> +	 * intercept the MSR 0x832, and do not setup direct_access_msr.
>> +	 */
>>   	{ .index = X2APIC_MSR(APIC_LVTTHMR),		.always = false },
>>   	{ .index = X2APIC_MSR(APIC_LVTPC),		.always = false },
>>   	{ .index = X2APIC_MSR(APIC_LVT0),		.always = false },
> 
> 
> LVT is not something I would expect x2avic to even try to emulate, I would expect
> it to dumbly forward the write to apic backing page (garbage in, garbage out) and then
> signal trap vmexit?
> 
> I also think that regular AVIC works like that (just forwards the write to the page).

The main difference b/w AVIC and x2AVIC is the MSR interception control, which needs to
not-intercept x2APIC MSRs for x2AVIC (allowing HW to virtualize MSR accesses).
However, the hypervisor can decide which x2APIC MSR to intercept and emulate.

> I am asking because there is a remote possibility that due to some bug the guest got
> direct access to x2apic registers of the host, and this is how you got that #GP.
> Could you double check it?

I have verified this behavior with the HW designer and requested them to document
this in the next AMD programmers manual that will include x2AVIC details.

> We really need x2avic (and vNMI) spec to be published to know exactly how all of this
> is supposed to work.

I have raised the concern to the team responsible for publishing the doc.

Best Regards,
Suravee

