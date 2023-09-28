Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6F5F07B1AE2
	for <lists+kvm@lfdr.de>; Thu, 28 Sep 2023 13:24:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232294AbjI1LYD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 28 Sep 2023 07:24:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47882 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232304AbjI1LXf (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 28 Sep 2023 07:23:35 -0400
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2087.outbound.protection.outlook.com [40.107.220.87])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7369495;
        Thu, 28 Sep 2023 04:18:40 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=NiYMiBVZhL8VVtiLZetaGmEHbYxU9nAUe+lhmX/H34RhcScB9RFjk/a8vkbtO4QExOg8PHsAVAQpy74L1qmBZPQIJ9gY+kqpg4TgRSL2IjA+8xhEyIqsuF/KVsZK6pJhHNVuTy+iHG3TAFPwRwt7hStsLcGymiPxxNeGdQB9dRK/tZop+pd4A2AXffNgKT8E3CvMVdBlfC4oueupLQbbgyyalyFxXcjkHIohc0N/jODGlt0ZBUO4Au564BjggES46tHcMdyeBdMFtiEHfnZIhHygvonqFN/mAn39mDcSiZ48waDevyIAKP2PCt9biXignNma+E5F48AAGx2Ez2x1Bg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=1hTJzAkwRMKcSpIR/6JkmtG+bNNEt0pUPApwD8MvZis=;
 b=nAcWi/WIhwiR/+ybtLWeM1NGGgCBsVC51EL7wJAZn8olyMMAgtC/o3isdwpht5vnaD5gRPMsI+Z30auStXBD5/zhaEHYInP+PxarbX0xs38rRMzGs31ysM5FZAG4OjstWdn/o1pe+jyMr+7N5Wi0K+SQQkGJcRYSSfbONDHGNVSy3jqt2vOEg9H0oFeXffIgP1jpmP6Yhl55mCcX4JhWuUk6FDBVRu3jnd448etPuTKKFOhBQdwkI2hD+q8Z8J+x/08RBGtLckW9FXe6i8BxBbIZ3NULg3U+fno+vI9OK+pXE71VencvRkSlm1KdmRDeqfcZ9Vhwc8kjCwgZsAf3fA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1hTJzAkwRMKcSpIR/6JkmtG+bNNEt0pUPApwD8MvZis=;
 b=ZjlefzI7jJ8iV+10qU5N6et8ZJZfnTjkq7hDnJ2brdEGxKsj73YrrXTifBbz5IOoxDkPMCzpaMfnj7ZV4vdSo+8P7+xokXJKAaeQjeBhrjaiwq0MBlmqZcRxJSH5xWhrv9nmZfOA26ufe6k/y92WzT/Kol7ecUJwqtlrRzukBSw=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DS7PR12MB6214.namprd12.prod.outlook.com (2603:10b6:8:96::13) by
 MN2PR12MB4208.namprd12.prod.outlook.com (2603:10b6:208:1d0::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6838.24; Thu, 28 Sep
 2023 11:18:37 +0000
Received: from DS7PR12MB6214.namprd12.prod.outlook.com
 ([fe80::2d00:60c4:e350:a14d]) by DS7PR12MB6214.namprd12.prod.outlook.com
 ([fe80::2d00:60c4:e350:a14d%4]) with mapi id 15.20.6813.027; Thu, 28 Sep 2023
 11:18:37 +0000
Message-ID: <3a6c693e-1ef4-6542-bc90-d4468773b97d@amd.com>
Date:   Thu, 28 Sep 2023 16:48:24 +0530
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.12.0
Subject: Re: [PATCH 00/13] Implement support for IBS virtualization
From:   Manali Shukla <manali.shukla@amd.com>
To:     Peter Zijlstra <peterz@infradead.org>,
        Sean Christopherson <seanjc@google.com>
Cc:     kvm@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-perf-users@vger.kernel.org, x86@kernel.org,
        pbonzini@redhat.com, bp@alien8.de, santosh.shukla@amd.com,
        ravi.bangoria@amd.com, thomas.lendacky@amd.com, nikunj@amd.com
References: <20230904095347.14994-1-manali.shukla@amd.com>
 <20230905154744.GB28379@noisy.programming.kicks-ass.net>
 <012c9897-51d7-87d3-e0e5-3856fa9644e5@amd.com>
 <20230906195619.GD28278@noisy.programming.kicks-ass.net>
 <188f7a79-ad47-eddd-a185-174e0970ad22@amd.com>
 <20230908133114.GK19320@noisy.programming.kicks-ass.net>
 <f98687e0-1fee-8208-261f-d93152871f00@amd.com>
In-Reply-To: <f98687e0-1fee-8208-261f-d93152871f00@amd.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: PN3PR01CA0058.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:c01:99::17) To DS7PR12MB6214.namprd12.prod.outlook.com
 (2603:10b6:8:96::13)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB6214:EE_|MN2PR12MB4208:EE_
X-MS-Office365-Filtering-Correlation-Id: 70e6f831-a07f-40ba-6d6e-08dbc014a907
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: zbE2LYJpmTh+Xn0FvNmQuMZndrv3tY8r5UEVW+Y5b4Jzq19wzEM3cS8tiCgwU8BqjacAcvvj65ltBUuYNXqWAcvUIwJz7n/kSWuR8in8Ki6oHnK8G/cf751GT0hFW39cyVYV6XRM9cohEIuu6UW9AGEpZVJH/vMDHeiIyZctFbQv3eOwkChjS1jAUyxCgjvKpTeMW81QaGzv1BHpNVeyXx4iuSTLMPs+fOBz1FWFi2NtjY0KCQkanIqDIQPMlj8dRHw4LfWJfLsCDCK8RfLZ/eOoCWpytbstBuMSszp3wscmE8WhnacW2s66pFVV/4XrW/rgReBEXEbbnMMOJm0GHKR3eD3IaSHWReCrrnAUkdstrXzPqwpQzKJJX/RojPdBZHM0MgL8M3OZKpukAj9r6Bh80gAm7ahu72Bn1R0aDheiglLBWK93WRmDJNrdV96dxElnk4WL96BRd5IF7WBv+wyiwOBV/ypYI47MsY8owl06EjQ77m9QkrL/Is1Om19LvQr+AUNrsGQ+/TIw0bidHeYFRnUMC0e63XVhntFHDsNsRniU6mdhFBU8qyVmpdh24rioqjOMd89BWqRXebLG9eprpU/kbC2j/b7oEIWBZhN3ITaDeVrcYedAGbBXhrRA0yLz3e1+Vgvgh4G13+oVjA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB6214.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(376002)(366004)(346002)(396003)(136003)(39860400002)(230922051799003)(186009)(1800799009)(64100799003)(451199024)(2906002)(31696002)(86362001)(53546011)(6512007)(2616005)(26005)(36756003)(6486002)(478600001)(6506007)(6666004)(38100700002)(83380400001)(5660300002)(41300700001)(31686004)(4326008)(8936002)(44832011)(8676002)(66556008)(66946007)(66476007)(110136005)(316002)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?R3VDR0dscFB6Q3lQOWdKQTZVd1B2N1Q0YWswL3JKNlJaa0pzZmxxMHgxWERx?=
 =?utf-8?B?Z2FDSHVpRXpvNVpCNEN6cWU2MnFWN2pOcHZzSzR0WmNJdUMrWDUvYkhHS1Rl?=
 =?utf-8?B?bFFybmdPQmxOTzlIL1Nkc0swV0Y4QjV2Q3FHZ0ZsbEUvZS9kZDFqbWVrR3pq?=
 =?utf-8?B?Mkl2bEdxZnFuQndvbWk5Y0FFYkEwdjJhczVQNTBYTVQvY1d0ZTZvMTZ1eEVP?=
 =?utf-8?B?L3RZQlJsVVNWbWwxZm9BZGN6U1Y2L0w0d0s2U0RYVGN2NXNWNVcxcU1WQ1cz?=
 =?utf-8?B?N2hZaGFDcTVUYzhEdllIYlk3bFRjQ0s3YTNESlh1Z1N6bnNIbzNkZWs4RER1?=
 =?utf-8?B?d2FyczFQeEtUTU5oSGNHS0tRWVByUTZGNm9hNTlxTmpBQ0RHcnQrbWhQbDlT?=
 =?utf-8?B?NTdXVERrSkpmcHlMbFVDVmQ5RWlSaHh3cVZLUm5ZenFkRGJyeU0yeFdSK1BY?=
 =?utf-8?B?eGxudThwbmJIdUFQSUZEQnFpZnJpK0h3bUp5elFMdGJPUHo1bElzamhiU1R3?=
 =?utf-8?B?K1RDSnBwSlg1MFRNNnQ0bU5ZK1hBNU5ITEhhOENzTDk1SWpHNjBCZFRGU3RO?=
 =?utf-8?B?T2NJd0dXTDFHekxHYUlzVFZmTXo4OCtsNlk2bS9YaUxRYzVzczVGL0wrbzJJ?=
 =?utf-8?B?Q1FVV3J4RDdWSUF2dDBrMnM1NmZjMWdaaG8wUjZIeDUrUzk0RnNGRFJnNW0z?=
 =?utf-8?B?U1VUd2txTmtGODljM2NwcVEvNE05NWEwY2lXOHRhak9NSHNzc1dBQnJkc1Jt?=
 =?utf-8?B?QVQ0bFZ0VUpBMmJWb0J5UlV4SnNFOGRLYTdaRm8xL0MzNXZ0M2NnaExLY3F2?=
 =?utf-8?B?S0tyRUYvSDRSOXBHRGdTSjV2ejZUVDdKZGxCNlJXbmhsTnprOHhUUU1qTzR0?=
 =?utf-8?B?V1VKbmFtbWxiZGhUaVlaWVZ6MnZqdmNndDVJOFYwUk5VVTF2am0zenZVOXhJ?=
 =?utf-8?B?REVtWlFmWDkyRkZZQkg5bFZqaVBPWVVJOHAzdVF0ZVhBcXoyekVMZjduQnly?=
 =?utf-8?B?ZnloL3hrWE42S0RSQ3dpQnZBUVBvZElxSGFFeXRyclBpcTNuc1RvSUdJRStz?=
 =?utf-8?B?Smduc2ZXTlBUT0pTSXY0TEgrRk5SRlZkZ1I1VzFXeUt0WWJUbHZOdjB4cW15?=
 =?utf-8?B?V0N1MW42SS9KTmhpU0xIY3BwRXZJTFZOYkQ2aEs3aXNleFN0bXI5QW5yNWFL?=
 =?utf-8?B?dXBRLzhoMUFwYm5pTzJKU0JzdUE4VStQZFZhTGl5RHJKRnQ1R3VLNFRmMExy?=
 =?utf-8?B?T05lcHQxR25tS1c5Vi9Hait2MFUvQTRkWVB4U2FvNTRnaHR4L0FvbmdKSmxo?=
 =?utf-8?B?V1NJVGtkWGJaVnZybDI3d1JBbkhnc2QyK1V2aUhFR3VjQ2NqSTFKZ3IvZGxN?=
 =?utf-8?B?czlMZ3MwMWFaaFRDc1NSZ2JiRHRvZVVjZFRpdEZZazYrMTl6WkxDZ0FlNmFz?=
 =?utf-8?B?R2xHZ0JETTV2S3o5M0FoSy9QMy9Ibmk3MjVjWlV1TWlMbEtEUDhRVUxEK1Nr?=
 =?utf-8?B?UWZNSVltL3A3MzBsNGRxZzNSWHBVMVI4ZUR5dzNSU1V2TDRXS09LcDF4SWhi?=
 =?utf-8?B?b0dvMVFpaGR5bTlRSWoweUdOVkFEN0pMU2kwczJDNnppWDhEdUJkR3c3aXZ3?=
 =?utf-8?B?MnYrK3hzajJleUh4WHVmbXBTZ1grUVNmbE05S0h1TjRhWFRrck1CUTdXRUdU?=
 =?utf-8?B?Nm5JS3h4WW1rM0VEcTR5Q2I1Sy9Cdlo5YVhob2tXQ09nT0Z6TWxXV2JoZ2U4?=
 =?utf-8?B?d1JoTkVXdmg0c09oNDN4czMzekFYQnBxckh3cUFaMWFzRDVna2JiYW9OMVpm?=
 =?utf-8?B?dUVNM3ppZVBkWFN5T0JZVk82Y0w0d2c1OWNkeHJ1ZzhkbTJYZXF3dEJ5SHNG?=
 =?utf-8?B?ck5qdlc1U0hKMkJoN1JGQjFTamZsckdZd0psWmttUFVFRWt5N25xM29ILzR3?=
 =?utf-8?B?cVJOVjRYMFhnbmk5czY5YXgyamtJVWwrRzBTRVJXd0VHbVlPcjhrM2kxREFj?=
 =?utf-8?B?MjFNWGFGSUtadGxsM0I1ZFd3cnErR3d2VCtEa0ZLVytZR1ZuK00xeDlzcDlW?=
 =?utf-8?B?TDduVi81cWJHQnVUTG5QeG10eE9mdUtsWFBTY203dVl2aHdVWkRjQlJUS3lF?=
 =?utf-8?Q?2xDixw6aMe5bHp0VO1KUoXacw?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 70e6f831-a07f-40ba-6d6e-08dbc014a907
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB6214.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Sep 2023 11:18:37.4645
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: tFK+fTOu6cNBjQuLyKJ6psQPT5y1pG1LAaQdj/KCDaFtrU9CaJCLgw3z5Sg4Pu1s1rjkhEgf9pj/wT9ouBg/NQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR12MB4208
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        NICE_REPLY_A,RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 9/11/2023 6:02 PM, Manali Shukla wrote:
> On 9/8/2023 7:01 PM, Peter Zijlstra wrote:
>> On Thu, Sep 07, 2023 at 09:19:51PM +0530, Manali Shukla wrote:
>>
>>>> I'm not sure I'm fluent in virt speak (in fact, I'm sure I'm not). Is
>>>> the above saying that a host can never IBS profile a guest?
>>>
>>> Host can profile a guest with IBS if VIBS is disabled for the guest. This is
>>> the default behavior. Host can not profile guest if VIBS is enabled for guest.
>>>
>>>>
>>>> Does the current IBS thing assert perf_event_attr::exclude_guest is set?
>>>
>>> Unlike AMD core pmu, IBS doesn't have Host/Guest filtering capability, thus
>>> perf_event_open() fails if exclude_guest is set for an IBS event.
>>
>> Then you must not allow VIBS if a host cpu-wide IBS counter exists.
>>
>> Also, VIBS reads like it can be (ab)used as a filter.
> 
> I think I get your point: If host IBS with exclude_guest=0 doesn't capture
> guest samples because of VIBS, it is an unintended behavior.
> 
> But if a guest cannot use IBS because a host is using it, that is also
> unacceptable behavior.
> 
> Let me think over it and come back.
> 
> - Manali

Hi Peter,

Apologies for the delay in response. It took me a while to think about
various possible solutions and their feasibility.

Problem with current design is, exclude_guest setting of the host IBS event is
not honored. Essentially, guest samples become invisible to the host IBS even
when exclude_guest=0, when VIBS is enabled on the guest.

Solution 1:
Enforce exclude_guest=1 for host IBS when hw supports VIBS, i.e.

        if (cpuid[VIBS])
                enforce exclude_guest=1
        else
                enforce exclude_guest=0

Disable/enable host IBS at VM Entry/VM Exit if cpuid[VIBS] is set and an active
IBS event exists on that cpu.

The major downside of this approach is, it will break all currently working
scripts which are using perf_event_open() to start an ibs event, since new
kernel will suddenly start failing for IBS events with exclude_guest=0. The
other issue is that the host with cpuid[VIBS] set, would not allow profiling any
guest from the host.

Solution 1.1:
This is an extension to Solution 1. Instead of keying off based on just
cpuid[VIBS] bit, introduce a kvm-amd module parameter and use both:

         if (cpuid[VIBS] && kvm-amd.ko loaded with vibs=1)
                enforce exclude_guest=1
         else
                enforce exclude_guest=0

KVM AMD vibs module parameter determines whether guest will be able to use VIBS
or not.  The kvm-amd.ko should be loaded with vibs=0, if a host wants to profile
guest and the kvm-amd.ko should be loaded with vibs=1, if a guest wants to use
VIBS. However, both are mutually exclusive.

The issue of digressing from current exclude_guest behavior remains with this
solution. Other issues are,
1) If the host IBS is active, with vibs=0, reloading of the kvm-amd.ko with
   vibs=1 will fail until IBS is running on the host.
2) If the host IBS is active, with vibs=1, reloading of the kvm-amd.ko with
   vibs=0 will fail until IBS is running on the host.

Solution 2:
Dynamically disable/enable VIBS per vCPU basis, i.e. when a host IBS is active,
guest will not be able to use VIBS _for that vCPU_. If the host is not using
IBS, VIBS will be enabled at VM Entry.

Although this solution does not digress from existing exclude_guest behavior, it
has its own limitations:
1) VIBS inside the guest is unreliable because host IBS can dynamically change
   VIBS behavior.
2) It works only for SVM and SEV guests, but not for SEV-ES and SEV-SNP guests
   since there is no way to disable VIBS dynamically.

From all the above solutions, we would be more inclined on implementing
solution 1.1.

-Manali
