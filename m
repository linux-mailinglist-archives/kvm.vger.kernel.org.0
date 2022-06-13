Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 492EC547ED7
	for <lists+kvm@lfdr.de>; Mon, 13 Jun 2022 07:04:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229499AbiFMFEA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 13 Jun 2022 01:04:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47502 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229712AbiFMFD5 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 13 Jun 2022 01:03:57 -0400
Received: from NAM04-BN8-obe.outbound.protection.outlook.com (mail-bn8nam04on2073.outbound.protection.outlook.com [40.107.100.73])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1BD147661;
        Sun, 12 Jun 2022 22:03:56 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=WjsTOg0EGxgkitpenmmqoU8mHeUBbM4sbl645QDPF+kdoDCSeBVQ2uYrz1TAEJhuQY/FtTXGXbj72VYUHKsMn56XU+lG2s+M80D0aH/S3NsmbPCJAp21AEQMAtSVhIp/jX8QEC4XmYq9rkT/jc0YyOhhK4HE4lH4bhb9z/z7Wp5sU+SwBbO2Hf5f7Pz707HRgU0EAm08dfOOqW3DWBxmxzSmXFwm7xwrlCxAWRJ/y7TYNbsaPFDsNIjr8V1A8HZrFacB9e9sJsbQhYEbdwx6QxxoCMWoaHmaJeGb0oT9ByD09YDk3SWcIrYXmuFwvbqsXPZzC1RowfU25IXN6gJO/w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Z5NNKHc7trzGfPhsRof6hoO0e6lkEgR/hMYTmQQW5IE=;
 b=itRAvindSCBhSikBU0NQog5X7OmcyXPjCfH57zasFJ/LGaKqmT3rME3m/d9y9Hgw+V1hT0UG70Ynvge2MEc0OTJGoSUGDFxUWM+JUTNXZwKqAXneksiY6S8E97GyeZtm7yuC3lZV8kL2bpRx9w4QABXYzmRvtGGIFEVx6os+GI0RPphC8KOH65u4mTyvRWBg5TozBdG/oIEd/xFKt89e7OrR4hUh3NUkI2WlRsTkG1TFwXpw7WqfV8pMlamrHrrI895PE3sFW/ewabRJ1eP+5U7Mg541buM0loEYHa4eOsnxwlonlnGEml8zpl+8aPGOlbZvA8eOSI/Tb1O0EgVpbA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Z5NNKHc7trzGfPhsRof6hoO0e6lkEgR/hMYTmQQW5IE=;
 b=GHB9E1zA4CSl7x9b7NKfHP00fLDzKzMXBc5xdis/8PJJPx2JLIIGYROpf+CL0MloGlYAlKnKNMmP1g0JCG2zpYULuESS/+QfjHnPJ4PVvbnMu6DeEAnCQxEKG9MaHgkVGee4nfg/sMZxHVMI6nRmKDAaprO7zvkBXjdp9Vdc+gg=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from MN0PR12MB6101.namprd12.prod.outlook.com (2603:10b6:208:3cb::10)
 by MN2PR12MB4847.namprd12.prod.outlook.com (2603:10b6:208:1ba::27) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5332.14; Mon, 13 Jun
 2022 05:03:53 +0000
Received: from MN0PR12MB6101.namprd12.prod.outlook.com
 ([fe80::3839:4183:6783:b1d1]) by MN0PR12MB6101.namprd12.prod.outlook.com
 ([fe80::3839:4183:6783:b1d1%5]) with mapi id 15.20.5332.020; Mon, 13 Jun 2022
 05:03:52 +0000
Message-ID: <7eb5313e-dea0-c73e-5467-d01f0ca0fc2d@amd.com>
Date:   Mon, 13 Jun 2022 00:03:55 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.6.1
Subject: Re: [PATCH 1/2] x86: notify hypervisor about guest entering s2idle
 state
Content-Language: en-US
To:     Dave Hansen <dave.hansen@intel.com>,
        Grzegorz Jaszczyk <jaz@semihalf.com>
Cc:     linux-kernel@vger.kernel.org, Dmytro Maluka <dmy@semihalf.com>,
        Zide Chen <zide.chen@intel.corp-partner.google.com>,
        Peter Fang <peter.fang@intel.corp-partner.google.com>,
        Tomasz Nowicki <tn@semihalf.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Jonathan Corbet <corbet@lwn.net>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        "maintainer:X86 ARCHITECTURE (32-BIT AND 64-BIT)" <x86@kernel.org>,
        "H. Peter Anvin" <hpa@zytor.com>,
        "Rafael J. Wysocki" <rafael@kernel.org>,
        Len Brown <lenb@kernel.org>, Pavel Machek <pavel@ucw.cz>,
        Brijesh Singh <brijesh.singh@amd.com>,
        Ashish Kalra <ashish.kalra@amd.com>,
        Pratik Vishwakarma <Pratik.Vishwakarma@amd.com>,
        Hans de Goede <hdegoede@redhat.com>,
        Sachi King <nakato@nakato.io>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        David Dunn <daviddunn@google.com>,
        Wei Wang <wei.w.wang@intel.com>,
        Nicholas Piggin <npiggin@gmail.com>,
        "open list:KERNEL VIRTUAL MACHINE (KVM)" <kvm@vger.kernel.org>,
        "open list:DOCUMENTATION" <linux-doc@vger.kernel.org>,
        "open list:ACPI" <linux-acpi@vger.kernel.org>,
        "open list:HIBERNATION (aka Software Suspend, aka swsusp)" 
        <linux-pm@vger.kernel.org>
References: <20220609110337.1238762-1-jaz@semihalf.com>
 <20220609110337.1238762-2-jaz@semihalf.com>
 <f62ab257-b2e0-3097-e394-93a9e7a0d2bf@intel.com>
 <CAH76GKPo6VL33tBaZyszL8wvjpzJ7hjOg3o1JddaEnuGbwk=dQ@mail.gmail.com>
 <2854ae00-e965-ab0f-80dd-6012ae36b271@intel.com>
From:   Mario Limonciello <mario.limonciello@amd.com>
In-Reply-To: <2854ae00-e965-ab0f-80dd-6012ae36b271@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: DM3PR11CA0002.namprd11.prod.outlook.com
 (2603:10b6:0:54::12) To MN0PR12MB6101.namprd12.prod.outlook.com
 (2603:10b6:208:3cb::10)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: ef7d7dc4-5484-4835-c7f1-08da4cfa1c3c
X-MS-TrafficTypeDiagnostic: MN2PR12MB4847:EE_
X-Microsoft-Antispam-PRVS: <MN2PR12MB4847FD5B783EAF7DE6B09AEEE2AB9@MN2PR12MB4847.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Nn02EFKSqbB6psebBx1+AAiGXaWC1gWGHPmdzbAoAppBb2KwgMFdOWg9/fbW00J0f/CNodMz/CxvUlgzMTZ+kvStJH8xPuhijCMLRRD1DsDphBo5NFrxjrUyb/3CWAqvhjFPhkkzFkDSlO6NMHDlC5cVwEFBIQsfY8cLqJF01+xwOKBjQ7R2+FqmitMwWfbU6nbNVc3rxbbn+kMUOJXHNjqfdvmS8TzjoQq5RMhZnwfIoHDz+b3RDe4GkxJmSQsk3RNd1rrhn5FmBawVXzhSRjN4RtF3BwOBI3q34dl4D8GRGcQBHq+wCmED+5ywG7ci79nJ11TYc+baX7xx5yG3srYtC/P8Na8MbwhCafsGG6creVqlIEz/BrIgEN7Bqnmrhxu5cMgRCilRpqFV3xcQVBjV9Zh4e7V2Tc29V9ruDrFArYc2xaxCHRnOLFWRlil3lm5giioDULu+QYcOnygxKfayVQmCOqJdlrbxOThQNmK1mneaGD7W7EmcmwZ4A6gyYYDk8RmsDcVtJMe9I5nW4Z/Qxl/gGVt7yNX6Mi3RxsEzst+sUGBSyX2T8YocenLuFlTHcZEnCfk7PiNhJ69IS7mVSxM3S8H3L/deNflHBSJqMZY3Ad2fENdS5vssyd0ieEU+RIGT3cdKX0PAv/3v1srmfBg5SkIzmkPIsKqZeR9K9Vxaw2DqhHgW7P6Dk0C1/7NNeADTra2OQ5Tt4RqKBJ3FtU7zqNID7qRUDLY8xxxpZNVzjlJQNJRL1gc3tEPD
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN0PR12MB6101.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(366004)(44832011)(31696002)(2906002)(2616005)(6486002)(86362001)(5660300002)(186003)(8936002)(53546011)(6506007)(7406005)(7416002)(6512007)(508600001)(38100700002)(36756003)(110136005)(54906003)(66476007)(66556008)(31686004)(66946007)(83380400001)(8676002)(4326008)(316002)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 2
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?eDJ6VlpzVDNINEhxcXpiVlJIOWZiS29icEtybDBDNE9odnM4cGFkcU56bm5F?=
 =?utf-8?B?Yk1JMCtTak9Sb0hQODhvT2ZocnA4VEFUWk95TXIxaHEydTNpN1czV0RyZThD?=
 =?utf-8?B?alY0SnFHR0REei9QK3dqaWp3SVFCenJoMEE0cm15UktRaGVNVnRwTUl1S1BO?=
 =?utf-8?B?bUtFVUxjUHAwSmxhcWJHWFNwc3lNa2ZiQnpPMzg4akJMVkxsbElqV3dKeURX?=
 =?utf-8?B?aHBSTnhrNnMrNTZHWmdLVlVUb3ZMQlZtdlNGZ291UW9DSnpsRjVJK3hJaHpy?=
 =?utf-8?B?WWFGeXBTNzhVRy9OWXdwc0V1RkN5SE84azNNZ1VINjRIT3lGTmE3MUFKdWJF?=
 =?utf-8?B?M1RaQzZKQnl6Q0VGcGMyK1VDVE1XVDQ2SzA3cnozdW4rMENIL0RGQSt0NE1s?=
 =?utf-8?B?QlVQMlQwN2g0MzJWVkZLU1h1b1dPVE9zR2dQdVdtOXo5b0tEUHp5NXIwY3p2?=
 =?utf-8?B?WDF6TGtQSmZ3VnVmU0x5bHIxb3kvTk5WbUdxV0JheWMzZDVoMW1BZGlyT3Bl?=
 =?utf-8?B?SWVsVkxiVTZXTEpRRWdoMnpYSkZNMkQ5NUQvL3JMZkdINlNyWElObnhXaWZh?=
 =?utf-8?B?MlJ1c3JWRVRYUm83WmRRUHRFZVJzRm5lbkUwR0NoNWFFZ09hSXlrRXNtQ2U1?=
 =?utf-8?B?NlN3SlMvaE1mdENhSDRTaHFJVWdNMC9ScFJTcGh4Q0pZYzQzaDFvVEt0SkpY?=
 =?utf-8?B?c241cS80S3E5bWlaWGpBWHRML0NvaVVMbFRqWFJtanFWcnRlSWxZZ29qS1pt?=
 =?utf-8?B?WE9FVlFQTVcxMjRIdFJPdmxNRWZoMHpHYmNzOGJPc2g4T25SWU9xYXpiZUlR?=
 =?utf-8?B?NWY0SzZJcHRsNWRUSldBbXB5cmk4L1YzRE4wZEdSaWNQWnFLS0tleDF0SVJ3?=
 =?utf-8?B?VnI1cmd1Y0Z6U1YyakxPdFpEeGJaWThTZzhubTd2OGZLYkRUbHRMZkZ1RzZG?=
 =?utf-8?B?aEF6VWRBemNHcXAxV090MmZLRlluTkt1U1B3RmNnN0tuaEwyNTl5YjNyOTIv?=
 =?utf-8?B?MllzN2E2TUl2SzRmNzZZQ3pob0lha1Y2VWNFMThUZFJCWVBrdnlXeVJMRVE3?=
 =?utf-8?B?Uk5NM0tWeTE2c0F3Tmp1Tk9reEZDVUlZdG5YUnJ0N01mcTVNSDJKeVdKaEhx?=
 =?utf-8?B?WmZ4OW1xNFJ5L2dGbE13bXY4cVdydGFsZEJpUTlmcTV4YWExYmlVcGVkVFpv?=
 =?utf-8?B?WHJqR1hJSmY0MERQSDhUYzRGTjE1cjF6N0daVE1qU0lJcUZvUng3NUp4YW1V?=
 =?utf-8?B?RTQ3YjJISzdPOW5udjBLdU4yNGhWekpnZ2t4UmVrSzVDVWhZOTJGYzlieW93?=
 =?utf-8?B?b291dVMzK3ZxMXhDSlkvQXp4MExNa1dIQTlWSWgyYkR5bmNYMDJDTDh2U2R4?=
 =?utf-8?B?SlV1K3dJWDBpaFczUlBGZWgyMXd4R3RrcmZ0dkloc1FlcHAwSldFTmhCaFFk?=
 =?utf-8?B?Q1VWakVaNndCZHh0ai9OQWJJd0VIU21nNHVNOERhbHpKQzM2bHJ3V0FHZFhL?=
 =?utf-8?B?QVEwVTA5aDRNalcwSjllQjI2N2ZQUmN6eXptakdZNEt3SDJqZzFxNHZLT29F?=
 =?utf-8?B?ZHdpMmxDVmFuV3ZjVkd3cDhEdFR5QmhQc2J0VWg5bG1EbDNwb1orb1ZIMUZt?=
 =?utf-8?B?MDdnOGRrUXB1R3E5UnA2Nmd4SFF5dW5BRmhUZit6MTk4MjVNalBKdk1FZVlE?=
 =?utf-8?B?Z2JnMm40eE1ZblhjSEJsQnVWOVlkWGFnSHVQUkdFY3JJZmJQRytHUnBIRkkw?=
 =?utf-8?B?VkRITktuN3d1elRTUDQ2NndQQVZ2RngrMEhmdVhXR2kzOUFmVldBL1UrVjNB?=
 =?utf-8?B?RVdDOTJBZHE4TTliVmE4MVYrM3ZxbGRVdERuM2xBc2ZSUEJZT0htTk82RnpS?=
 =?utf-8?B?U1J0Q01PNSs3L0dOaHRnaEFWWHBoQlVJaG1ud2pCYXgyVkNVT0hRbTk5ODFT?=
 =?utf-8?B?M3Y0dlFxb2lTa0FQN25lQ1k0SlZLeUs0QS9hVlVGQmdGTTAySWVKQmk3dzVm?=
 =?utf-8?B?ZlJXNlo5TUE3dHpjTUREMjh4aEtKVUxKb3IvU3Q5RnhhU21Zak53cy94STFk?=
 =?utf-8?B?bWU4aVNvVUFiYXVBVUMvT0RwWWlaQjlEaTVHSFc5NWlFd29Tc1J4UUJXdDdo?=
 =?utf-8?B?WndXMUEyMGYxRjdaY2JINTM5WU5NYkZ0cTV5U0tzaFRObzFtZjF4WGhqRHVE?=
 =?utf-8?B?RnBBdnI0c1pmUTJvMm1XdHFzN1o5Z1l0OEtHZlFkeEM0NzdHREM2blAvV2dX?=
 =?utf-8?B?V05Oam5WT3hKRUFmeFRZQ1NDa05Cb3VqUGZOMGlqaFMrN0pERmJTTkhHMVFs?=
 =?utf-8?B?cTVqS3BNSkhUUE01d1VqaUZwZjhlWWMrenYxbklsM3E5OENNMytaK0FUaWp5?=
 =?utf-8?Q?Xmq/pxWvUtTavPEj+TDcYBFGZ8QErDWwVE6WkyaccCi+H?=
X-MS-Exchange-AntiSpam-MessageData-1: jYGJ0n8/OrfSEg==
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ef7d7dc4-5484-4835-c7f1-08da4cfa1c3c
X-MS-Exchange-CrossTenant-AuthSource: MN0PR12MB6101.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Jun 2022 05:03:52.7345
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: EijwH/pbhdJvdEmKBFNmtl+isEQZyIpNYLfIFeVYIkBS9qnRpsuXAo+2zLKdFWbt2VAjpXjYgOFIk7R4n+8DLQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR12MB4847
X-Spam-Status: No, score=-3.3 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 6/10/22 07:49, Dave Hansen wrote:
> On 6/10/22 04:36, Grzegorz Jaszczyk wrote:
>> czw., 9 cze 2022 o 16:27 Dave Hansen <dave.hansen@intel.com> napisał(a):
>>> On 6/9/22 04:03, Grzegorz Jaszczyk wrote:
>>>> Co-developed-by: Peter Fang <peter.fang@intel.corp-partner.google.com>
>>>> Signed-off-by: Peter Fang <peter.fang@intel.corp-partner.google.com>
>>>> Co-developed-by: Tomasz Nowicki <tn@semihalf.com>
>>>> Signed-off-by: Tomasz Nowicki <tn@semihalf.com>
>>>> Signed-off-by: Zide Chen <zide.chen@intel.corp-partner.google.com>
>>>> Co-developed-by: Grzegorz Jaszczyk <jaz@semihalf.com>
>>>> Signed-off-by: Grzegorz Jaszczyk <jaz@semihalf.com>
>>>> ---
>>>>   Documentation/virt/kvm/x86/hypercalls.rst | 7 +++++++
>>>>   arch/x86/kvm/x86.c                        | 3 +++
>>>>   drivers/acpi/x86/s2idle.c                 | 8 ++++++++
>>>>   include/linux/suspend.h                   | 1 +
>>>>   include/uapi/linux/kvm_para.h             | 1 +
>>>>   kernel/power/suspend.c                    | 4 ++++
>>>>   6 files changed, 24 insertions(+)
>>> What's the deal with these emails?
>>>
>>>          zide.chen@intel.corp-partner.google.com
>>>
>>> I see a smattering of those in the git logs, but never for Intel folks.
>> I've kept emails as they were in the original patch and I do not think
>> I should change them. This is what Zide and Peter originally used.
> 
> "Original patch"?  Where did you get this from?

Is this perhaps coming from Chromium Gerrit?  If so, I think you should 
include a link to the Gerrit code review discussion.

If it's not a public discussion/patch originally perhaps Suggested-by: 
might be a better tag to use.

> 
>>> I'll also say that I'm a bit suspicious of a patch that includes 5
>>> authors for 24 lines of code.  Did it really take five of you to write
>>> 24 lines of code?
>> This patch was built iteratively: original patch comes from Zide and
>> Peter, I've squashed it with Tomasz later changes and reworked by
>> myself for upstream. I didn't want to take credentials from any of the
>> above so ended up with Zide as an author and 3 co-developers. Please
>> let me know if that's an issue.
> 
> It just looks awfully fishy.
> 
> If it were me, and I'd put enough work into it to believe I deserved
> credit as an *author* (again, of ~13 lines of actual code), I'd probably
> just zap all the other SoB's and mention them in the changelog.  I'd
> also explain where the code came from.
> 
> Your text above wouldn't be horrible context to add to a cover letter.

