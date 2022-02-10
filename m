Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 53D954B0434
	for <lists+kvm@lfdr.de>; Thu, 10 Feb 2022 05:07:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233060AbiBJEHC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 9 Feb 2022 23:07:02 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:41352 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231302AbiBJEHA (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 9 Feb 2022 23:07:00 -0500
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2088.outbound.protection.outlook.com [40.107.237.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 10DE624587;
        Wed,  9 Feb 2022 20:07:02 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=S2dgrB6PERWAnBv0LvMaHQfVvm+pMb0vnxIxiww6uOthitHmhDiz/UKZ6MpFyxz3G2TL1NRT4qNDq3S48Ejk6MPFvg9KVEZNmzRtyLIJUQIKzxbJKmdGMFzV3FGj9snNz94B0SonmTpq+54uN2lP1Kpp+jCqQDvxTnE2zuQXrHm3Gc94Tplmy+glBsR0Rg89KRPXtD0IoPI6eQx3gw8fb1KL/UkvJ02vX++c2hhMKXA3uq30bKWWyByj3mVHJB5Vrc7PS3brG7TvMWdTldcTw42Db3JJ1y+5L7DrB0GKd5k2tmiczC84yRmM48ImWs7EVmvRokyP6UNfaFPmwjG5+Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Tfup3n9xcQGKHDy8lp5FgvSPvmo+PNc+KXqLP9w0mNM=;
 b=feZTibPRPyiI0pMt6UiXoxZbyZPLgUal+3wdp5BF2AbAcfXEuV4wsBRQkg26wAEdXMNpd6bfgC9NdGUJWM7nREFDMVOw+BhFFeuC73aoTnRSoAYZaMUOMZqGLiXjII2C9jQyeOs5YaVA20i3A6zdlt3goqa19ZEKDYaaBBGFrbNnw4TQnpVLXyEWTH6e76x/RXMfCQFu02fshlEptGbXX+yhQDYtlx81Ai01Vh4C6Ec5uLLocsAjtT8QKvJtXWQ0JIMVVc8R2HLzjHDT2DVpzTMh+L5O8eEoabgdTjYLVTNVwL4KFMB6Y5rM3jQJnCHCd3tKe3HE5BsXKH7jSSu1wQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Tfup3n9xcQGKHDy8lp5FgvSPvmo+PNc+KXqLP9w0mNM=;
 b=jySPzNMubr23m/GaSiTqYKKNkUwQAZb1Vv3aVkQJPa8d+6iOzP2Kfmv6atE9RMIM45slcxKc7S6WSEacu0nQOz57D4NlxJ33KokeMdWDZuXx5VAPnp/SSHInpdjCIzJmO6cyQtazIyqYVrco/bAnXoY4fQN2EnF+Ag2uGSe25DY=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from MN2PR12MB3053.namprd12.prod.outlook.com (2603:10b6:208:c7::24)
 by BYAPR12MB3174.namprd12.prod.outlook.com (2603:10b6:a03:133::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4951.18; Thu, 10 Feb
 2022 04:06:59 +0000
Received: from MN2PR12MB3053.namprd12.prod.outlook.com
 ([fe80::9117:ca88:805a:6d5b]) by MN2PR12MB3053.namprd12.prod.outlook.com
 ([fe80::9117:ca88:805a:6d5b%4]) with mapi id 15.20.4975.012; Thu, 10 Feb 2022
 04:06:59 +0000
Message-ID: <fc5fd517-7ad6-10e1-2582-ef1335dc82b2@amd.com>
Date:   Thu, 10 Feb 2022 09:36:40 +0530
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.4.1
Subject: Re: [PATCH v2] perf/amd: Implement erratum #1292 workaround for F19h
 M00-0Fh
Content-Language: en-US
To:     Jim Mattson <jmattson@google.com>
Cc:     eranian@google.com, santosh.shukla@amd.com, pbonzini@redhat.com,
        seanjc@google.com, wanpengli@tencent.com, vkuznets@redhat.com,
        joro@8bytes.org, peterz@infradead.org, mingo@redhat.com,
        alexander.shishkin@linux.intel.com, tglx@linutronix.de,
        bp@alien8.de, dave.hansen@linux.intel.com, hpa@zytor.com,
        kvm@vger.kernel.org, x86@kernel.org,
        linux-perf-users@vger.kernel.org, ananth.narayan@amd.com,
        kim.phillips@amd.com, Like Xu <like.xu.linux@gmail.com>,
        Ravi Bangoria <ravi.bangoria@amd.com>
References: <2e96421f-44b5-c8b7-82f7-5a9a9040104b@amd.com>
 <20220202105158.7072-1-ravi.bangoria@amd.com>
 <CALMp9eQHfAgcW-J1YY=01ki4m_YVBBEz6D1T662p2BUp05ZcPQ@mail.gmail.com>
 <3c97e081-ae46-d92d-fe8f-58642d6b773e@amd.com>
 <CALMp9eS72bhP=hGJRzTwGxG9XrijEnGKnJ-pqtHxYG-5Shs+2g@mail.gmail.com>
 <9b890769-e769-83ed-c953-d25930b067ba@amd.com>
 <CALMp9eQ9K+CXHVZ1zSyw78n-agM2+NQ1xJ4niO-YxSkQCLcK-A@mail.gmail.com>
 <e58ca80c-b54c-48b3-fb0b-3e9497c877b7@gmail.com>
 <CALMp9eRuBwj9Sg60jg2ucWd-XoAcE_kXP5ULFgpkSHg88sOJZQ@mail.gmail.com>
From:   Ravi Bangoria <ravi.bangoria@amd.com>
In-Reply-To: <CALMp9eRuBwj9Sg60jg2ucWd-XoAcE_kXP5ULFgpkSHg88sOJZQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BM1PR0101CA0002.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:b00:18::12) To MN2PR12MB3053.namprd12.prod.outlook.com
 (2603:10b6:208:c7::24)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 485a9624-26cd-4eef-142f-08d9ec4ac8cc
X-MS-TrafficTypeDiagnostic: BYAPR12MB3174:EE_
X-Microsoft-Antispam-PRVS: <BYAPR12MB317429CCB53A51C35F2EEDD4E02F9@BYAPR12MB3174.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: GIBTHfU9zaNCGOiMXjXa/6ySYH176MuJpC8Ea9XsBr1BXsdJMRzGqPuEL/bIMA80fOZhZYe1QFs4Vc/uKkSQ7zQbATrryvPLmEYmRv3Pn7r9oNiAUk6444SbEchHWGXOmtGT6Ej7naE31Z2jyz0Dd+gy6Vm4KLGP6tefAtOfus8Clzb91zmTC3RNG4H6Hwfl9CxyCgvL59XUQDzdnpvnAlGElXsY/agUunvMkrynbIklAOP3F397ShnmPFpD+NhuzDg4IvcPsHTgbMgq8BVqZYiNT71HYc5Q5PmAui/zrMFmvzxxsiyVcms0Kkh/HhAHuLgWRCf4Qg7tIiZXPxDvdWSgn8sZjax3jJOvECd0vFtVS2jBQE0dP6zwJ3I/wW2DXZzsW8DJVcSSdgNYgUp4sLcQUTgkmcUy9FDoR9wb0fB0wAAdKoo5dFt8P5O4Et/53DaWzjVqXv749ogoIcD93GbE1C8V0Q9JMWvJpG3qNPYX5fKjq8sWCuhYbxeFdTHzYRMY1ffx/ALGoWVpplV7AKBq+iCeh2OnDOWD7vxy3R0bXga+5zfq44X//oSn6vk0VICRtmKQ2YNC3hxe2qTXnsis8/gT2B3g4MCd4mPY3HI6y3zgGosFfUAIVq0tRgKeSna7VauMKPAommqg8BjFdnz35mKAhi95BxcoB1mCsLznjqEkvcBkE5cPjGdxGufs5WCGGDk0yirdwJUo2VtgqGMLWS/NMZCJIYaCp+vf33A=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR12MB3053.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(316002)(4326008)(2616005)(66946007)(38100700002)(53546011)(6666004)(6506007)(54906003)(2906002)(66556008)(66476007)(6916009)(508600001)(31696002)(6512007)(8676002)(83380400001)(36756003)(6486002)(8936002)(26005)(5660300002)(44832011)(31686004)(86362001)(7416002)(186003)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?WFNVV2JBYW15NjVoSlFqT0JKRWdKdnNRcFJiMzd2ZHVGNFplZEp0OXpienVk?=
 =?utf-8?B?UmJHZ2NjK2dtRWp1dnEzUnZYUXJxYkJReXZteVZoYXpuZXhDeENXTmRyWE1C?=
 =?utf-8?B?b2xFdjhyS2N4Q1VUcDRMcUtZK25URkVIKzJCb1Z0Q3JNLy96d2FqYjZyTXpq?=
 =?utf-8?B?M0ZnamdWTFZCaEw5blBnRWYrRWdXK2J4cFA5TVhHazhpaklwQUlLRE1CWWpn?=
 =?utf-8?B?ZGZjZ01SM0tpSk96UTZ1QWJkOG9RWTllVk43NzRETlVSZGoyOTRtbGhobFly?=
 =?utf-8?B?MjlmTFJ2NUhqK1diNitaalRVdDVOeGxYdHZLMXVSRmkxQ0IrVURuMXJQQXQ4?=
 =?utf-8?B?cnBmaThDRlpyS3N0NkN5RU1kR2pBd3gxSFVGb2tZR3JVeGcxay9sOHBiS3Bt?=
 =?utf-8?B?R0dTV3RMN1BUNVlwWXJ2RFFiZnRsR3owbC9selB6QWNOWGxqYVNId2txWnZE?=
 =?utf-8?B?eXlMVjRjblpLMlU4OGE4R0NXL0NkWElZWEg0azNoOTlEY3YvRlNwOGNKRE44?=
 =?utf-8?B?VWw5RTdYNmxhcGMvNFhvMGhNNVF3eWxGTThRYXhUY3VJaURjQWJ6MEJ6NWRD?=
 =?utf-8?B?cmJEZk9DT29VSEtsKzA5ZXZXVWJ3bGttY29TKzV1RCtWcW8vS2VwUXJCYjc5?=
 =?utf-8?B?cWVsU08yTDFoeFFlQmNjZ2FTN2hkWTVnUjNTL3YzY1BQbDdHNFYzVGRiQXBE?=
 =?utf-8?B?a2RTUUpZMjljTDBJeW1VM0dCcUNrRWg2Y0lPNG42bHVjTTgzdlhBdU9hd2c5?=
 =?utf-8?B?U0lwT2JkY3E1RGRyYzZzenBwQ3ZtZzlkQU4yZWtoUVFNaUlhUy9kODhDUXB6?=
 =?utf-8?B?dTQzQ1FsNnIwTzJmc1lCUzRoOVN2MnpNeEd1NGJaSWsxd2IvOG5TRllzZjg2?=
 =?utf-8?B?L0xpNkQ1TDBJbU5oNzRKckRqaVBaZGhKSVVrRlpxdlJ1SFY2VFlCcHZUM2Qz?=
 =?utf-8?B?VklOeUVkU1B1VlRMZGpjUWVlOElsK0YyNndBSnNSUUtwOVRlamRaaXgyM2hH?=
 =?utf-8?B?QzFrNnpsMFJxT3B4TElsRVhGYVRkM29MYUhrdXpzWUF6aEVjRHE3RWdCaHdw?=
 =?utf-8?B?bFMxUUQxS2JNbFZ0M2grWGM5OUkxR3AzNTVsRTBvSWZvc0pqT0dpOWE1UDFv?=
 =?utf-8?B?RjVZVVI0R0NZVjYrM2NPMExpUUtuZWx4SUhMeUo0VDVJY2lQODR2V3c1OVZB?=
 =?utf-8?B?dUVCK2FoalFqTmlYNGxHSm5jK3FxdnlHcnVIcnFuRTBuZklzWi8wUldwZUVw?=
 =?utf-8?B?YXNLRkpETUhiRDg4bmYxSDI1QlpJZG8rSHFwNnpuZlR0dW5JbHlrUDRtU2s5?=
 =?utf-8?B?alpaWk1HdDFyZ1RySXNyUnhhOGkvcC9ka2tUbjl4akZEQ21Wd2xQbXFTSFJL?=
 =?utf-8?B?UWtBbUdzT1duR1QxZDNWUlRxaGZTMlNscnB3VnNYV3dMTHZGcHI5dUxzNEFj?=
 =?utf-8?B?cHl5b2E3eUlkZGtqWW1IZTlkcitONW1qOTQybFc3amNQbmUwVkdVV3hvYUhY?=
 =?utf-8?B?ZVdzeFVBcXZHREhCWG9QWEwvMVNGRWZqQ1oxdnVkd2o5czV3eTVvbzBuNFZt?=
 =?utf-8?B?cjVGdjAyaVcxbTNMckhiUmwva2FWd1UyQ25sc2x6V0JEdmJRcjd0YkVqMXJw?=
 =?utf-8?B?ZDFKSUhZTmhVaGhvWEJaQnNkZXhCKzh5Tk5ydk1wSlR0alZBS2pJT1JmTDdu?=
 =?utf-8?B?eGpGdFQ3cVRoMFkrV0RkdzBHR25hY3lHUXhWZFVxdjNiWUxSU2NUOFliWVpl?=
 =?utf-8?B?SENHbmZ6S3N4TVUrM3NTS3pTMkZxa2wxRHI3NUFhcWliVGU5VFhlTDlHY0M2?=
 =?utf-8?B?QkJxK2xLQkxLbHpNS3RzeElBZHZTRGthdTB1V1g0cTVKbENTWkEwRzE4MjR1?=
 =?utf-8?B?RXFkODdOV0NReWZGSENIQmU5cWJmNEpnUkZpMUc3NWJDam1aU0FwYktsTWFi?=
 =?utf-8?B?WEo2KzJoK0dUc0Z2VzVHR1k4ZTE2SUIwYnlaNHRlQ1RnQW1UaU1ibWZRMTZH?=
 =?utf-8?B?bWJPVzVjRndYRVFDcVJXTC9QSytnMnl5MWh5MlE5bWdndVZLa2Y3QUpUVTZz?=
 =?utf-8?B?Kzdja3k1TWlLck9WVlZVeHhiNmx6UUdtdllSQXdsMEpYVlF0QktSclUvV1NH?=
 =?utf-8?B?ZituaFpZeTJzMkt3NWpwMUlLQTRBaE9GU0VZYlB5amx2aThhby8rTi9wMm9P?=
 =?utf-8?Q?doFrq/Xt0UTjgA/wqn9+Duo=3D?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 485a9624-26cd-4eef-142f-08d9ec4ac8cc
X-MS-Exchange-CrossTenant-AuthSource: MN2PR12MB3053.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Feb 2022 04:06:59.3782
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: NHXiOqtO8kIlnV8bLXz5ZZGcsl7AS2LZgNFsX5teunG/7ak9p0l3z+guh7dbR7bsxJ6sUNY5oi0J5t2iqITSDQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR12MB3174
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Jim,

On 10-Feb-22 3:10 AM, Jim Mattson wrote:
> On Wed, Feb 9, 2022 at 2:19 AM Like Xu <like.xu.linux@gmail.com> wrote:
>>
>> On 4/2/2022 9:01 pm, Jim Mattson wrote:
>>> On Fri, Feb 4, 2022 at 1:33 AM Ravi Bangoria <ravi.bangoria@amd.com> wrote:
>>>>
>>>>
>>>>
>>>> On 03-Feb-22 11:25 PM, Jim Mattson wrote:
>>>>> On Wed, Feb 2, 2022 at 9:18 PM Ravi Bangoria <ravi.bangoria@amd.com> wrote:
>>>>>>
>>>>>> Hi Jim,
>>>>>>
>>>>>> On 03-Feb-22 9:39 AM, Jim Mattson wrote:
>>>>>>> On Wed, Feb 2, 2022 at 2:52 AM Ravi Bangoria <ravi.bangoria@amd.com> wrote:
>>>>>>>>
>>>>>>>> Perf counter may overcount for a list of Retire Based Events. Implement
>>>>>>>> workaround for Zen3 Family 19 Model 00-0F processors as suggested in
>>>>>>>> Revision Guide[1]:
>>>>>>>>
>>>>>>>>    To count the non-FP affected PMC events correctly:
>>>>>>>>      o Use Core::X86::Msr::PERF_CTL2 to count the events, and
>>>>>>>>      o Program Core::X86::Msr::PERF_CTL2[43] to 1b, and
>>>>>>>>      o Program Core::X86::Msr::PERF_CTL2[20] to 0b.
>>>>>>>>
>>>>>>>> Note that the specified workaround applies only to counting events and
>>>>>>>> not to sampling events. Thus sampling event will continue functioning
>>>>>>>> as is.
>>>>>>>>
>>>>>>>> Although the issue exists on all previous Zen revisions, the workaround
>>>>>>>> is different and thus not included in this patch.
>>>>>>>>
>>>>>>>> This patch needs Like's patch[2] to make it work on kvm guest.
>>>>>>>
>>>>>>> IIUC, this patch along with Like's patch actually breaks PMU
>>>>>>> virtualization for a kvm guest.
>>>>>>>
>>>>>>> Suppose I have some code which counts event 0xC2 [Retired Branch
>>>>>>> Instructions] on PMC0 and event 0xC4 [Retired Taken Branch
>>>>>>> Instructions] on PMC1. I then divide PMC1 by PMC0 to see what
>>>>>>> percentage of my branch instructions are taken. On hardware that
>>>>>>> suffers from erratum 1292, both counters may overcount, but if the
>>>>>>> inaccuracy is small, then my final result may still be fairly close to
>>>>>>> reality.
>>>>>>>
>>>>>>> With these patches, if I run that same code in a kvm guest, it looks
>>>>>>> like one of those events will be counted on PMC2 and the other won't
>>>>>>> be counted at all. So, when I calculate the percentage of branch
>>>>>>> instructions taken, I either get 0 or infinity.
>>>>>>
>>>>>> Events get multiplexed internally. See below quick test I ran inside
>>>>>> guest. My host is running with my+Like's patch and guest is running
>>>>>> with only my patch.
>>>>>
>>>>> Your guest may be multiplexing the counters. The guest I posited does not.
>>>>
>>>> It would be helpful if you can provide an example.
>>>
>>> Perf on any current Linux distro (i.e. without your fix).
>>
>> The patch for errata #1292 (like most hw issues or vulnerabilities) should be
>> applied to both the host and guest.
> 
> As I'm sure you are aware, guests are often not patched. For example,
> we have a lot of Debian-9 guests running on Milan, despite the fact
> that it has to be booted with "nopcid" due to a bug introduced on
> 4.9-stable. We submitted the fix and notified Debian about a year ago,
> but they have not seen fit to cut a new kernel. Do you think they will
> cut a new kernel for this patch?
> 
>> For non-patched guests on a patched host, the KVM-created perf_events
>> will be true for is_sampling_event() due to get_sample_period().
>>
>> I think we (KVM) have a congenital defect in distinguishing whether guest
>> counters are used in counting mode or sampling mode, which is just
>> a different use of pure software.
> 
> I have no idea what you are saying. However, when kvm sees a guest
> counter used in sampling mode, it will just request a PERF_TYPE_RAW
> perf event with the INT bit set in 'config.' If it sees a guest
> counter used in counting mode, it will either request a PERF_TYPE_RAW
> perf event or a PERF_TYPE_HARDWARE perf event, depending on whether or
> not it finds the requested event in amd_event_mapping[].
> 
>>>
>>>>> I hope that you are not saying that kvm's *thread-pinned* perf events
>>>>> are not being multiplexed at the host level, because that completely
>>>>> breaks PMU virtualization.
>>>>
>>>> IIUC, multiplexing happens inside the guest.
>>>
>>> I'm not sure that multiplexing is the answer. Extrapolation may
>>> introduce greater imprecision than the erratum.
>>
>> If you run the same test on the patched host, the PMC2 will be
>> used in a multiplexing way. This is no different.
>>
>>>
>>> If you count something like "instructions retired" three ways:
>>> 1) Unfixed counter
>>> 2) PMC2 with the fix
>>> 3) Multiplexed on PMC2 with the fix
>>>
>>> Is (3) always more accurate than (1)?
> 
> Since Ravi has gone dark, I will answer my own question.

Sorry about the delay. I was discussing this internally with hw folks.

> 
> For better reproducibility, I simplified his program to:
> 
> int main() { return 0;}
> 
> On an unpatched Milan host, I get instructions retired between 21911
> and 21915. I get branch instructions retired between 5565 and 5566. It
> does not matter if I count them separately or at the same time.
> 
> After applying v3 of Ravi's patch, if I try to count these events at
> the same time, I get 36869 instructions retired and 4962 branch
> instructions on the first run. On subsequent runs, perf refuses to
> count both at the same time. I get branch instructions retired between
> 5565 and 5567, but no instructions retired. Instead, perf tells me:
> 
> Some events weren't counted. Try disabling the NMI watchdog:
> echo 0 > /proc/sys/kernel/nmi_watchdog
> perf stat ...
> echo 1 > /proc/sys/kernel/nmi_watchdog
> 
> If I just count one thing at a time (on the patched kernel), I get
> between 21911 and 21916 instructions retired, and I get between 5565
> and 5566 branch instructions retired.
> 
> I don't know under what circumstances the unfixed counters overcount
> or by how much. However, for this simple test case, the fixed PMC2
> yields the same results as any unfixed counter. Ravi's patch, however
> makes counting two of these events simultaneously either (a)
> impossible, or (b) highly inaccurate (from 10% under to 68% over).

In further discussions with our hardware team, I am given to understand
that the conditions under which the overcounting can happen, is quite
rare. In my tests, I've found that the patched vs. unpatched cases are
not significantly different to warrant the restriction introduced by
this fix. I have requested Peter to hold off pushing this fix.

> 
>> The loss of accuracy is due to a reduction in the number of trustworthy counters,
>> not to these two workaround patches. Any multiplexing (whatever on the host or
>> the guest) will result in a loss of accuracy. Right ?
> 
> Yes, that's my point. Fixing one inaccuracy by using a mechanism that
> introduces another inaccuracy only makes sense if the inaccuracy you
> are fixing is worse than the inaccuracy you are introducing. That does
> not appear to be the case here, but I am not privy to all of the
> details of this erratum.

Thanks,
Ravi
