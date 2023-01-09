Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2D7B9661E6C
	for <lists+kvm@lfdr.de>; Mon,  9 Jan 2023 06:24:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234414AbjAIFYf (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 9 Jan 2023 00:24:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57972 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236380AbjAIFYC (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 9 Jan 2023 00:24:02 -0500
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2040.outbound.protection.outlook.com [40.107.236.40])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 20CFB13DE7;
        Sun,  8 Jan 2023 21:20:34 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=bRG8aiuBXJpomNSvt+ddUUcMhhDZZurPiLbO/3srF9Ds4kx81UNtJePM4WEDjWe7AX/YooLNIDbTk2Hn2jFtmXFCmb14tsB1ptS1XTLdThYu8i3Zy507zrDX/K1QxLHMVi8HRhc8BXJ99ec01dhjhVLNgpJUPJl0axxBDivTyLvYQRl4MOPXIUJQFrcK7qLLshV2aEJULBH9JXB0OMMB6ZOXzXUM/QcWoKtG8B9dyO0wB8oLDCCa5Oxvrug+1se39opKVNNrQEtqK7u3iYXIB5Cc29j8aQwNiK7MJWaE70kBOLmxVzbSDk9RmN3JPy9W4DcYMrHBwO/ymEJ01i0htA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=LfbCcdMpE5hjcAwxHzxTeKOIiBXuOD2NHi3NPY1wMlo=;
 b=dJ1yUKQ3AyY5eK9jM1fxXpjZwF/ngj78qRSyludrIm9CSR7T8jco+I9R6JLrm9qP3BsArFgDnvx9UxmdsPO4a5drPFzYehb04sauHS/O9u5fRQ9HKcThWjKYlYPukNiyZKahGSPNIowcnfLuOLkhtowv93zGtpQ8KpYy3RjCFkkSpu/Hyilh6nELYxUd8rwhMFTCK6Zt3tEyS6kmRO5xwUUUfTyXIUnBP2jtNeUPIiarvDoEnYcgWmmhRIuTKyEYG5O1VPk2YJ4LCmfGQftTWJFM0zMQFo/gYxR87qSwpKTInCfW6/vSRvM0mTYnLqC40uNzGRsM5Uao4yNg84C2XA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=LfbCcdMpE5hjcAwxHzxTeKOIiBXuOD2NHi3NPY1wMlo=;
 b=UoIWlv8EX2iaJ95Q9cngpYC1uhNLCAL651fxGd45lLn1YolglmkgJVVeh/1JGgLn0WvfU+71blPno2Nkw1B3zCh6LyqTE2xDopS0ouYMnXE4FpF5p7Qs8lLM6I7mld12FIEnuxL/quVIgxVWLlCXAckVG1Yjko/q1WqJG+rEF1o=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DM6PR12MB2843.namprd12.prod.outlook.com (2603:10b6:5:48::24) by
 PH8PR12MB6988.namprd12.prod.outlook.com (2603:10b6:510:1bf::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5986.18; Mon, 9 Jan
 2023 05:20:32 +0000
Received: from DM6PR12MB2843.namprd12.prod.outlook.com
 ([fe80::2867:7b21:95a4:aaf]) by DM6PR12MB2843.namprd12.prod.outlook.com
 ([fe80::2867:7b21:95a4:aaf%4]) with mapi id 15.20.5986.018; Mon, 9 Jan 2023
 05:20:31 +0000
Message-ID: <bb25ea31-c02d-8a4f-af88-cf6e62e23717@amd.com>
Date:   Mon, 9 Jan 2023 16:20:17 +1100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.1
Subject: Re: [PATCH kernel v2 0/3] KVM: SEV: Enable AMD SEV-ES DebugSwap
Content-Language: en-US
To:     kvm@vger.kernel.org
Cc:     x86@kernel.org, linux-kernel@vger.kernel.org,
        Venu Busireddy <venu.busireddy@oracle.com>,
        Tony Luck <tony.luck@intel.com>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Sean Christopherson <seanjc@google.com>,
        Sandipan Das <sandipan.das@amd.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Pawan Gupta <pawan.kumar.gupta@linux.intel.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Michael Roth <michael.roth@amd.com>,
        Mario Limonciello <mario.limonciello@amd.com>,
        Jan Kara <jack@suse.cz>, Ingo Molnar <mingo@redhat.com>,
        Huang Rui <ray.huang@amd.com>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Daniel Sneddon <daniel.sneddon@linux.intel.com>,
        Brijesh Singh <brijesh.singh@amd.com>,
        Borislav Petkov <bp@alien8.de>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Andrew Cooper <andrew.cooper3@citrix.com>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        "Jason A. Donenfeld" <Jason@zx2c4.com>,
        "H. Peter Anvin" <hpa@zytor.com>
References: <20221209043804.942352-1-aik@amd.com>
From:   Alexey Kardashevskiy <aik@amd.com>
In-Reply-To: <20221209043804.942352-1-aik@amd.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SY4P282CA0010.AUSP282.PROD.OUTLOOK.COM
 (2603:10c6:10:a0::20) To DM6PR12MB2843.namprd12.prod.outlook.com
 (2603:10b6:5:48::24)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR12MB2843:EE_|PH8PR12MB6988:EE_
X-MS-Office365-Filtering-Correlation-Id: e89157c8-8050-44d1-15fd-08daf2013a65
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: tkiKYoFbJY1cWeAwxQRJB3WTbSsOdgfT1vgymxVTiZuFQ/zn0iz7iNGyqrVN33n3Lv+UQegliZ4ecsXVWH+Emwmy8PzJS2C8pObAeP9tlr9u2FsV8VY5JCFTyM4IYcGXjNZF+pOqzcmoCj2mkKz0xcIeZJCfR7dSGb1HAPsbMbe2j11sLKUhV+4RXtDklEXTPitrpk5+g4R1PX6jcEgoQEY0j5610AR0bQXYNo+nChH0BTXP+w4cYnU3dYQhHyCV9SSAtGbYpU0xudnP13lne4oY4E1SNZNmZ0UxQsdu8ELG3yWdPxAGRhf7oWDUVQt1mJFB1HvJEkXmwpowAlGJYOmh4EJHiyt+3kZ8giYSG4TD0gwerh+97INmH/FiH1gV2/mrRyVcqu8C4TGsbbiFeytanCVF4p6rQaYgJXsa3bEnXnayT/Vbw4qhZgGi2FKzyH9PTMme9RxuXjCRmYXt0HrFpLb1+An4rqtag17OD3wxMaSVwnoYxQi14y6O2mMCFc+Mz2aO6pAhxJXa7Wd15C8iGTDLbY4cEOLhVJRRV0eRg1Y7gB+gw3vcIWM3szctiSBYnCkG+FHrJrQo1LA3qG2TV3wCGnNud/awmoIoiKJxJ9JVBz9koPjPfcr2GG8WB5gsWXwmIAinYbxdQnR9pG+bt2FbL0QdaVM0v9aDA+r0XjYVDhzLt2qGy6346otbu5zAXDo+5IoNzs/yZQ50D3jkwbzozKLmdM4uJOogq06+Gutm7bR5lCoZ3+e60ZZ+lBNBvlPmphQkGUxCrgxhhdUB5q0PLxWA89ZQbv0Y7zc=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB2843.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(376002)(346002)(136003)(366004)(396003)(39860400002)(451199015)(2906002)(31686004)(5660300002)(7416002)(966005)(36756003)(41300700001)(8936002)(66556008)(66946007)(66476007)(83380400001)(8676002)(4326008)(31696002)(2616005)(54906003)(6916009)(6666004)(6512007)(38100700002)(6486002)(316002)(53546011)(26005)(186003)(478600001)(6506007)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?NDBoTnJuRjdXdnpMcmEwYUVQVFZucUN1RERpb1l6dXBSWTFobUFndUJWcVhT?=
 =?utf-8?B?TWo2dGcxMEdOakhmNk5EazdHdjRCZlRsY3RJVWw2UTdoK0RqWU5LZmEwYVdG?=
 =?utf-8?B?czI5cU5rczBHWm10dUF2Tko5Ny9pVVloTXBXVHVUNzB2WjdwcnppTTQ5anls?=
 =?utf-8?B?WFlhZmllSkZvSGxKUE5jeldpUHBieWt1Wkt3aXk0SzF5LzhQZGpUQVNualRk?=
 =?utf-8?B?THc5NFlVd29iRkQvdisySDR4Vi9LK2lvTktZT29aVGlOc2lrbTZzSzcra0h4?=
 =?utf-8?B?b1hHL0RDV0ZoeUowL2JRZlhlM0laRUxmUTk4cG9wNzN3dGJiS2oySUE1NFhE?=
 =?utf-8?B?U1A1Ukt5WllpdXdDaGIva2lxejZMb09WUEpaNHdlWDRnRU1ERS9INzU1VnVF?=
 =?utf-8?B?S0tHRlc3ZFJ3YkdjTm9yNlRRVC9LMW16T3UxQi9uNUttZTJCK1h4U0l5dkxx?=
 =?utf-8?B?K0lhUTZGaU1acmliallkcUJDVlpXNlp6NU1ueGNkU05yNjJxSjhUYk9CQWFS?=
 =?utf-8?B?bG9YdFI5d0VqT0wveUpMVXlaTVU0RTBPMGk1OG5tV2Y4YndOQURYcHhwTkpW?=
 =?utf-8?B?OW92eVIvdUFLaWlOOG9Vb2JjYUFWenJCa3kvNnBteWZPTDZxcXo3Z2xvTGds?=
 =?utf-8?B?d0QrK2dES1dlbnlObFRlcnJud1F6WnBtcWNzODVqdm9uc1hDRDVVODRmeGk3?=
 =?utf-8?B?YnR1Z1pFOGIyejQyTFFKNkFzRjQ0dGFHdlJHcHlBU0JqMGVpdWl1OHJQNWF4?=
 =?utf-8?B?ZmNWb3dvOVhUUktTREd2MjFKclhhZ1ZXNFpQYXJZMGFTemZvYWpDQ0dFSkRR?=
 =?utf-8?B?YlZvai9hNklMZFNJZ0J1Tm1xUmtsU2loTXovbGdmbUEvUm1salFOeTRIMzRT?=
 =?utf-8?B?MWoxVUpPQXQzbFBUMStZTTY2Y2RHZEhEM1hWVkVIeEpwMVJ6Q09LUnFDZTlZ?=
 =?utf-8?B?cm5nTi91djFnZ1hmTG1IdW5kb21wMzFKa0VEdWtxbFBLSStaeWpQSUNZQVY0?=
 =?utf-8?B?RFpLZXliMjlxOXJGalE1U2tpL3ZDeDBhazRjNEJQNjh4Rm9NWEhxaEtobGl2?=
 =?utf-8?B?VjBJRnZ3VWdHbjErS04wZzJJOCtuODBzQTcvMmp6SHNsSUdJN2RYT3J6MXJI?=
 =?utf-8?B?bXNlLzIvM1h1ZEtMNEpjcVdjK1FUT00rOEU5Mzk1Sk9zQmNDd2wxSEdVdC9m?=
 =?utf-8?B?M0Vsenk4elYwTmplaUx2cnJFYVkrY2ZnbXBHNFl5UDRlanhxQUJWQjZyeTFV?=
 =?utf-8?B?SHVyNjVmVkU5RHNTYjVyeXpURUkrclYzT1o3SmhxV0NMQkxEY29mKzArRDJL?=
 =?utf-8?B?TVNVWTRhQVY1OXdJbGQ1M2NhU1gvanhvSm8xN1IzSi80czJDbXlWN1VLRFB0?=
 =?utf-8?B?ejNLakdWQnJUNW44dHdRSVVkaFpDQndTWng1Vi9vcmdzZktLc0huMVlDSjdL?=
 =?utf-8?B?SmhmOGV4WmRrcm1TM3dWVm94V0ZNUkhDNEZxZnFDeXQvVUx2VmlsVU5mVzNL?=
 =?utf-8?B?SlFiWVdUdTZxVzJoQzJKMlhyRUx4N2F5QlMzSTh5TWErZEw1SE9FVGpqamll?=
 =?utf-8?B?c2dHdEtUU1lCMFZITjBLSFVhTGdoRjZ2dkZ5VW5jTG9TWXpPZG5KbWdQa1Jx?=
 =?utf-8?B?UW80OGVlaDd2OG91TlZPMWlLNDZwNDk5M3RXcllkeC9yWnJFNXdNcUxsN1d6?=
 =?utf-8?B?RERtQ1hYSVEvVEZKYjhwd0Exa2cvN1YxVUQvRklZWC8vRGtOUm9ZNGV6R0tR?=
 =?utf-8?B?b1VNejlrQ0lSQjl6UUlRWEtBUUdGTkpRSEl2QkFQYzRuVmdDeTVtb01TYVVa?=
 =?utf-8?B?NTdsamlUTmFialV1cHVQRm9QN09sTFZHelROdjBpMWxoL3FicWxnOE5nNDhP?=
 =?utf-8?B?cXZXakVaQ3JwdlpwVEE2QitwWWNlS2ExMEFXeTgwNm5ZNis2a3JpZnlWMXRv?=
 =?utf-8?B?SVQ5T3Bpem11dFhNZ0R1M01GZTJNdXAxNmk0TC9majZtZEtTOFRZMnhhamNx?=
 =?utf-8?B?Q0x4SWNtOVNSTkdXQUthOGppQXZVbU5wK1lYdDFzeWJPV2NMMTYzcGMzYUtH?=
 =?utf-8?B?OE5IZm5YVHRtME1xSVpoRW1odTEzWXdEVDFJbjU3OS9xTHNqVS8rYUxRQVQz?=
 =?utf-8?Q?nSfFsB6z6bEDV4Vt9iZ//+qOS?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e89157c8-8050-44d1-15fd-08daf2013a65
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB2843.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Jan 2023 05:20:31.7907
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 7C22dqQuRjAT/dz9USx9Ep+6LCsBGDcCdYnOc9jFGbaMHxe1QfgiJ0mQXpjziBm8PueMb6iXyX1AYadEuGo3Ag==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH8PR12MB6988
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 9/12/22 15:38, Alexey Kardashevskiy wrote:
> This is to use another AMD SEV-ES hardware assisted register swap,
> more detail in 2/3. The patches are fairly independend but required in
> this order.
> 
> This is based on sha1 0d1409e4ff08 and requires something like this
> for X86_FEATURE_NO_NESTED_DATA_BP:
> https://lkml.org/lkml/2022/11/29/1229
> 
> This patchset is pushed out at
> https://github.com/aik/linux/commits/debugswap
> 
> 
> Please comment. Thanks.

Ping? Thanks,


> 
> btw the enormous cc: list came from get_maintainer.pl, keep it like
> this or tell the script something to reduce the list?
> 
> 
> Alexey Kardashevskiy (3):
>    x86/amd: Cache values in percpu variables
>    KVM: SEV: Enable data breakpoints in SEV-ES
>    x86/sev: Do not handle #VC for DR7 read/write
> 
>   arch/x86/include/asm/debugreg.h        |  9 +++-
>   arch/x86/include/asm/msr-index.h       |  1 +
>   arch/x86/include/asm/svm.h             |  1 +
>   arch/x86/kvm/svm/svm.h                 | 16 +++++--
>   tools/arch/x86/include/asm/msr-index.h |  1 +
>   arch/x86/kernel/cpu/amd.c              | 45 ++++++++++++++------
>   arch/x86/kernel/sev.c                  |  6 +++
>   arch/x86/kvm/svm/sev.c                 | 29 +++++++++++++
>   arch/x86/kvm/svm/svm.c                 |  3 +-
>   9 files changed, 90 insertions(+), 21 deletions(-)
> 

-- 
Alexey
