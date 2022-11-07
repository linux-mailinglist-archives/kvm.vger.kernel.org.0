Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 430BF620244
	for <lists+kvm@lfdr.de>; Mon,  7 Nov 2022 23:29:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232085AbiKGW3v (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 7 Nov 2022 17:29:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52350 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230186AbiKGW3u (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 7 Nov 2022 17:29:50 -0500
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2041.outbound.protection.outlook.com [40.107.236.41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1480821262;
        Mon,  7 Nov 2022 14:29:49 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=h/kfQ6cy/R03CdfnN0bIFLNbh+IN8PbV+0TueqXAKfelYoyA2u/D8M+RQAXHNZKEnBC0oEjrVQvXiFZxrwkCErlJ3/AjXMg/7esjmnSZeyiLxR2WCmUYF/Cmxuo5bvFzMzrzMX/8iia7rO+ta1T9zVHbzs/dn6OL+Ubi5dlS/TyfomIiV6FbH+bTGPm7YtjxLvQkGG5VY5PwM/rd9EkBR9bRSeALm2Uu3mYIzI6cJGgRcwaqPgdrmnC0EhYqArcPwg2BdflxHL18iF1Xt6W7kTeJ+td4gQnr3iG1PVzzQ8PtF8DXPZCDB2PQPMVn3ALIomfwl9AW893B/czUpBQ7bQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ZLrFr57HupA6O5T8cpvT38WQofxfu8AoxEQNbqZIasQ=;
 b=WkRjQg6EcvzHqxG/suHzH7PYb6T6raUeDk8HtQ8bUGIAjx465Y8b4QFuliiqlBPQUEUs5SLQAVyNDUaRmaix7N2vJ2QExfEwCb8LMYPDuEO0pFklkhvSTix5ugXON/gPnX+qeyOQHwnScHiUHsXwPSCYTzVDAmNplxgYnqIqlu0ytwGhBiYn5juVelDKKwrI125hDQkKLT/lFufyXtHRlDteSUDpvUjVG1+FQ+pkvKqxTugfPDj+L5gpFwXnFGjQYdYlzG3YK22PaDQlD+faTuFh1yTK38pO6BSb+w0IWJVCEokMX5xqYmlVN+bTkAGUPNb7KkGdt5I0vsvMmYtlsg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ZLrFr57HupA6O5T8cpvT38WQofxfu8AoxEQNbqZIasQ=;
 b=REAvmaZfZ9uggjWVJmkjHU5XLBs/t7i6NRelmx/kS2tGlZPhwWahjBLeM0McBqS0RceMFPcKRjV3AuELTOB8Eq4FOp1yps1V4PqHEELuop5f871MofICFa15cOCvv/wL6vaCbBaJhHdvFClklh7t0jiTvbIno3dx738ZvV7rFKo=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DS7PR12MB6263.namprd12.prod.outlook.com (2603:10b6:8:95::17) by
 IA1PR12MB6164.namprd12.prod.outlook.com (2603:10b6:208:3e8::8) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5791.26; Mon, 7 Nov 2022 22:29:46 +0000
Received: from DS7PR12MB6263.namprd12.prod.outlook.com
 ([fe80::6f5:7c8f:32d9:e72c]) by DS7PR12MB6263.namprd12.prod.outlook.com
 ([fe80::6f5:7c8f:32d9:e72c%3]) with mapi id 15.20.5791.026; Mon, 7 Nov 2022
 22:29:46 +0000
Message-ID: <f25152d2-7045-94f4-d5dc-69b609c0be6a@amd.com>
Date:   Mon, 7 Nov 2022 16:29:44 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.2.2
Content-Language: en-US
To:     Jim Mattson <jmattson@google.com>
Cc:     x86@kernel.org, Borislav Petkov <bp@alien8.de>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>,
        Joao Martins <joao.m.martins@oracle.com>,
        Jonathan Corbet <corbet@lwn.net>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        David Woodhouse <dwmw@amazon.co.uk>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Juergen Gross <jgross@suse.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Tony Luck <tony.luck@intel.com>,
        Babu Moger <Babu.Moger@amd.com>,
        Tom Lendacky <thomas.lendacky@amd.com>, kvm@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20221104213651.141057-1-kim.phillips@amd.com>
 <20221104213651.141057-4-kim.phillips@amd.com>
 <CALMp9eSpKGCYK_1r3o326ui5RVoH73_RR5-LR2Div9Jm5zvk6A@mail.gmail.com>
From:   Kim Phillips <kim.phillips@amd.com>
Subject: Re: [PATCH 3/3] x86/speculation: Support Automatic IBRS under
 virtualization
In-Reply-To: <CALMp9eSpKGCYK_1r3o326ui5RVoH73_RR5-LR2Div9Jm5zvk6A@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: CH2PR12CA0017.namprd12.prod.outlook.com
 (2603:10b6:610:57::27) To DS7PR12MB6263.namprd12.prod.outlook.com
 (2603:10b6:8:95::17)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB6263:EE_|IA1PR12MB6164:EE_
X-MS-Office365-Filtering-Correlation-Id: 3d6ae764-1082-4103-7d38-08dac10f9315
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: HGmnFqxxW2f8Z9l4Z91BOxYOY7n1LzbBu+5+BCUd62/sJEl58r6jaQCqpwDfqc2bMcVuIseBSW2n/Y+iUxTTYXE6qmzh+11EERRNH4yFG+h5HEYGthP32ciySDIeMDvCl9d1gK3DMXlYBV59+bl/E19KJA5RDQfilVJ46LxCc3j5pli0062Xa59/+OMV25ARcRpkysBaf3JEwrbj1cK2ZWil7WztduQLV8zrZjqnqloOEY7wIGhQQf+heBl6Fc/t7+BFycK+mIU5k7fJJF/p/cmUnFaoorSnf/G7o2gci+X/RGd08PVBb/w9qegd83pwv0ORV9e1to6BodK+vLBBFbq5izbIUEzEzERvU95EHumE7rYOttgxMNDoTWQWegjJ3B5GluSp19j2TZJKmeTGmMeI3v7Tb0qAadNH3bz9yc3X84Xhz7vENq5F5GYOD9apwvvhK21xJpMe4SSkBv6E0M5F7sAQ+MXMcXimkwwpFYW3ge/hvF7Q4ofC4ApZaYtC+oTlMFXWp6PH1jvM0zSESJi2xt5JEI+ZT0ToBRMTNx6dyT2DXF/3pfASP+hxRN42ztrmc9qN5hEnIcYu8PYrP8NUvGheISpAi0MCfmT6lEUm3JWz4QP7dYylpkOAjsImPLnanDTxgV8PvlaFeRh/84z7xLQkYyrAbEjC5s/FgAQm7+05xtFaAuOQzqAlS79ovPEqofZml55m4yLefSC8GQSGGjj1b51uIdz+okRrCrGrIZhenTMmTROuyGt6Jro+qVw4aOhabnWBpRTRHcMlbaFUugKy+UMK/i6qpwUlTEg=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB6263.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(346002)(39860400002)(366004)(136003)(396003)(376002)(451199015)(6916009)(2616005)(186003)(41300700001)(38100700002)(8936002)(4326008)(8676002)(66556008)(66476007)(5660300002)(2906002)(44832011)(7416002)(54906003)(6506007)(6512007)(53546011)(26005)(316002)(478600001)(6486002)(66946007)(31686004)(86362001)(31696002)(36756003)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?SkQyb3V3YWZoWmZ1bXNOZUNLZUd0U2xLcEI5QXJtSURVbDlXZmw4Y3RLWXhI?=
 =?utf-8?B?NXQ5ZzY3YUVKU08yVjZZTVB2NGR5clpybXNnWDRlY0g0a1huaUxydGpQZk04?=
 =?utf-8?B?MWpRb3htcGExVEkyYTcrVTM3ZW40NWRaM3c5VHR0SS81b1BwVVRVaTIxRUI4?=
 =?utf-8?B?YUZkWkxDRE03cmNkYktqd1B0THkxblAxaytLU25hRUZKSUJGdlhuYlNScHlV?=
 =?utf-8?B?Sk51SldyanY3UlVodWlYRVdGSFBYdE43aUZCQ2hINGZQS1RkTXFGWndBTzEr?=
 =?utf-8?B?czdwOHNFVnNBRm1LQlRuUkY2bWt1UFJDMVZnM2R0dit3U2V0dFdQdzYvZllE?=
 =?utf-8?B?c0dRVGJIdGt1MmNxemtFMXpXZ3BGOUp4Vm4zaXBWR3hsZVdqVE1mVEE1cjNx?=
 =?utf-8?B?ZG43QW1hZzRudk4ya0M0bGN3Q29iMlU1SHRzanlabVljK2szeEd2Q1I2ZU5R?=
 =?utf-8?B?SlMyODlVR1hDZDZoNG84TXFhVGJpcTVJekRSK3B5L2dkYnB1ODhGeXg1Rllj?=
 =?utf-8?B?b01JcStsUHNxclFkNXd6WE02enZ1c1JsNXh5b214VDAwR09MKzhiRDRGczJo?=
 =?utf-8?B?bTR0ZTlLYlM5VjErZXN3cnNkNndBVll5cWdxaDd0Tk1uZUwvYkE2aVMvY2Zv?=
 =?utf-8?B?QzdLNGtTSjQ4bVNKcnNhVmt2VGJKN0hOa01tbXF3UCtwL0doQXBsV0tLWDlq?=
 =?utf-8?B?NlVkbDR3U3RTdkpNbEcwUzZoWUlTWFhVbFl3ZHF2UUNhMERNclFhUnBvaFpV?=
 =?utf-8?B?MThZVzJud2JSd2VKQU9OMmhGeHJ5aDBQQVF4OXpoK25vSkk3VWJySUtRRStD?=
 =?utf-8?B?WUZ3dzVMVlQyNlREZmM3N3M2UUtEVkdhWmZoTGgzMm0rakx3TmpMTHNqbWpl?=
 =?utf-8?B?NGtCdkZCOHV0cDVWb2JTckd1VGUxMmZUTWc1cmQxUE1CNTFQVHFFM3dxMm90?=
 =?utf-8?B?Z2xCai9kK0hUa3RCSkZlcDdqb3ViUzdZRjdIQ2Q5Rzdvb0dpamU1UGJpR3F2?=
 =?utf-8?B?aGIySEVhdUtrREVRU3A1SlRScWRLUFJNNkRXNWNhZzIwVXFFYjBVNnRJTllq?=
 =?utf-8?B?a0Vad1V2eGJKNG1GN1U3SHhBdzYyNGx0REtZNm1UaTdRY3JPTHpkRy93QmhF?=
 =?utf-8?B?OWYwTTJPdzRSaTIvdzNIZWRDbkhRNno4NzVhOHZ4VTNXcVhWdzVNK1k4RDU2?=
 =?utf-8?B?QWVRdEQ1RTNEUHV5clR6VlJzUWZWYm1XemhWS3JNVDhHZUVDMEdiVE5Gd0pG?=
 =?utf-8?B?M0lxWW10cGpIN3BYN3hxck5BZDhUNjZHRnRNNDF5RldLZ0ZUM0lwamIzcjFi?=
 =?utf-8?B?N21wR1FyMjRRdHJaSFdza0FkcjI1eHdtWXJkQjRkUmpPUStzczdRYkx3WlJU?=
 =?utf-8?B?SVNEVHVNTE55WXVudkJjWEJ5Z0JoUkdkSnhySTNiT2NtUlMxV1FZZnVVSUdz?=
 =?utf-8?B?cXJ4OFYxRS9KcTQveFdYOFVmSVUyblVhY2VKU0h4T2g4YmlPRVo2Zmo2ODhu?=
 =?utf-8?B?WTFVZTBMbER1VmtDQ1NzUDVUOW4wZVp0SXdnQXZPMnVjRERyZ1BPZjg1SHA3?=
 =?utf-8?B?SnVlVVBMUytSQ2F2S1V6Sk5aazYxMWt3dHVNWE1YZFF5UkZGYUtUcVhNaFJS?=
 =?utf-8?B?L0pBYTZPTTluQTNXQTh1VzgzeFY0bjRKOXB3bDJYSytYa2xIRmh1V1p3YTBG?=
 =?utf-8?B?bHlxOXhaNW9RVm1lek5OTWRJNVNZcXBMMUNOYTJJNEd3NHk4T09QSENoSTda?=
 =?utf-8?B?VmhMK0hJUzQrdUs5aDRveVA4WVhsWDZmYWR6VTE0cHJucTIxcVJvNlh6c1JG?=
 =?utf-8?B?S3dHUkM4cWxMMW1mcC8zb2xvODNjS1RrWGdWempwM2l0NGtONG1QSHZZb1ox?=
 =?utf-8?B?eERSMVhhcThhMDdzTSs5Sk85bmtPK2Z4dGtHdnF0L2lIUFBJSmlaNlJoMFZ1?=
 =?utf-8?B?dHhzTDR0Z2NZNUFYUG5pSnpsc3VDVjF4cUVaTm1wd3dwK2hjekF6MDRpK1R3?=
 =?utf-8?B?SUNuVlRZN2dVNCtOTS80dEJDZndLNlRMcVdkMHMwVGlnN1hyZXN5MDEwVWx4?=
 =?utf-8?B?UkJsNDFJMkxlQXY0VktvakVwZ01QS2c3UVA4N0UvdWsraHBFaWcwdkxHYWJK?=
 =?utf-8?Q?cE4KcUyXuBNbS3apfluWupcP7?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3d6ae764-1082-4103-7d38-08dac10f9315
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB6263.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Nov 2022 22:29:46.4227
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: /MBCb2txAiCiPaQKNryHxI3t5I0Jc+IS3q6nrLFIPlxOOsQVj1BNuTXDulqg/xT+IpeDZ9+ocWDNZYVAWvAqTQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR12MB6164
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 11/4/22 5:00 PM, Jim Mattson wrote:
> On Fri, Nov 4, 2022 at 2:38 PM Kim Phillips <kim.phillips@amd.com> wrote:
>>
>> VM Guests may want to use Auto IBRS, so propagate the CPUID to them.
>>
>> Co-developed-by: Babu Moger <Babu.Moger@amd.com>
>> Signed-off-by: Kim Phillips <kim.phillips@amd.com>
> 
> The APM says that, under AutoIBRS, CPL0 processes "have IBRS
> protection." I'm taking this to mean only that indirect branches in
> CPL0 are not subject to steering from a less privileged predictor
> mode. This would imply that indirect branches executed at CPL0 in L1
> could potentially be subject to steering by code running at CPL0 in
> L2, since L1 and L2 share hardware predictor modes.

That's true for AMD processors that don't support Same Mode IBRS, also
documented in the APM.

Processors that support AutoIBRS also support Same Mode IBRS (see
CPUID Fn8000_0008_EBX[IbrsSameMode] (bit 19)).

> Fortunately, there is an IBPB when switching VMCBs in svm_vcpu_load().
> But it might be worth noting that this is necessary for AutoIBRS to
> work (unless it actually isn't).

It is needed, but not for kernel/CPL0 code, rather to protect one
guest's user-space code from another's.

Kim
