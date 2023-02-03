Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C263468A4D5
	for <lists+kvm@lfdr.de>; Fri,  3 Feb 2023 22:45:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233071AbjBCVpd (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 3 Feb 2023 16:45:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45798 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229610AbjBCVpb (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 3 Feb 2023 16:45:31 -0500
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2065.outbound.protection.outlook.com [40.107.243.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 44D7D8E49A;
        Fri,  3 Feb 2023 13:45:26 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=PNYpFQJyZLHLs1N1yoWBI5izFKkmHaOakarLi065Kb2/kHMPrlFDvo5sdoExYHaWO9jfl4osFWmmWFXcpDt+CM5xlJVkw5RZFBFOh0U95VumIbDICEhMsF1iVM14hpmhDn0xmpUY526HRXC2iWxlgOiz0Gezu8Np04+W0G38hTX7UABXRcDRFyEf/rDdnFf2ARr009ziPntFZx/BELu+f+m0w3B7DUuoCFadlfFwXZ4Wv+ljts+l5H9FC+aNbk6oAw8xLeAmSbmo+QFuTj0ZNOd4JAVCRnEzcR7mO645ujCAZOvRMvLLwvbFMtFxehNNB59k37LsY4ucHeqhE4SJsw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=8NS9X9dabI7Xulmb/wdW1zDk2TTFKtWTmppVveNLOAM=;
 b=n/rBSwct0KYcomAp6ce3rRin6I/xb4wdDRuJp49GpKql/hAjWzBiZ/qIkoFsOpRLgMc11ZmX4y6wH/F9Ajue5VRpTg/p9h09rw2g69mIvydg8YXNP0X3myw9bmPvSxA+JOrh4XBc6a8ZDar/9DKkPA565TTbzrP6HY9dtg0fY5ORpg6JA6ZJYt789ElgKhI1g6hfAKLMceoWnrbaIMUxneQ+dcjqznnBJ85r0bBVQJ2o2HxiIfsnGkxqarvgW15f70LLP3m95X93M0dZTzcJwm7dLTc22hd4VVlOWes3fs+owU5gtBqjyz3w2f8RUTvUjs8Lohz1nNxccUDPLMt3YA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8NS9X9dabI7Xulmb/wdW1zDk2TTFKtWTmppVveNLOAM=;
 b=1AHWJRLCNAXZsIhRNwPnhSqOPFUmoMtg3WY+lHpxUsDtQbOMdO4Eo/ljh+5lNJNa8wM36f2/y1MMXVfpkQzaDnA+8tUFaY8u8HAQa9TNiJkp879ZlXsO1YsiHPYkowpVGNUj6vkvkU6Yvnjoro/d04TwEaxLThAwKVs7M99Vmpw=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DS7PR12MB6263.namprd12.prod.outlook.com (2603:10b6:8:95::17) by
 SA1PR12MB6677.namprd12.prod.outlook.com (2603:10b6:806:250::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6064.27; Fri, 3 Feb
 2023 21:45:23 +0000
Received: from DS7PR12MB6263.namprd12.prod.outlook.com
 ([fe80::2ba2:7ffc:1e24:4bba]) by DS7PR12MB6263.namprd12.prod.outlook.com
 ([fe80::2ba2:7ffc:1e24:4bba%9]) with mapi id 15.20.6064.024; Fri, 3 Feb 2023
 21:45:23 +0000
Message-ID: <54fb46ad-10b7-dc87-5723-5437fe5f40a3@amd.com>
Date:   Fri, 3 Feb 2023 15:45:19 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.2
Subject: Re: [PATCH v6 07/11] x86/smpboot: Disable parallel boot for AMD CPUs
Content-Language: en-US
To:     "Woodhouse, David" <dwmw@amazon.co.uk>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "usama.arif@bytedance.com" <usama.arif@bytedance.com>,
        "arjan@linux.intel.com" <arjan@linux.intel.com>
Cc:     "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>,
        "thomas.lendacky@amd.com" <thomas.lendacky@amd.com>,
        "Mario.Limonciello@amd.com" <Mario.Limonciello@amd.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "seanjc@google.com" <seanjc@google.com>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "fam.zheng@bytedance.com" <fam.zheng@bytedance.com>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "liangma@liangbit.com" <liangma@liangbit.com>,
        "pmenzel@molgen.mpg.de" <pmenzel@molgen.mpg.de>,
        "mimoja@mimoja.de" <mimoja@mimoja.de>,
        "hewenliang4@huawei.com" <hewenliang4@huawei.com>,
        "hpa@zytor.com" <hpa@zytor.com>,
        "punit.agrawal@bytedance.com" <punit.agrawal@bytedance.com>,
        "simon.evans@bytedance.com" <simon.evans@bytedance.com>,
        "bp@alien8.de" <bp@alien8.de>,
        "paulmck@kernel.org" <paulmck@kernel.org>,
        "rcu@vger.kernel.org" <rcu@vger.kernel.org>,
        "x86@kernel.org" <x86@kernel.org>
References: <20230202215625.3248306-1-usama.arif@bytedance.com>
 <20230202215625.3248306-8-usama.arif@bytedance.com>
 <b3d9fbbf-e760-5d1d-9182-44c144abd1bf@amd.com>
 <d5ec64236ba75f0d3f3718fb69b2cb9169d8af0a.camel@amazon.co.uk>
From:   Kim Phillips <kim.phillips@amd.com>
Organization: AMD
In-Reply-To: <d5ec64236ba75f0d3f3718fb69b2cb9169d8af0a.camel@amazon.co.uk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: CH0PR08CA0029.namprd08.prod.outlook.com
 (2603:10b6:610:33::34) To DS7PR12MB6263.namprd12.prod.outlook.com
 (2603:10b6:8:95::17)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB6263:EE_|SA1PR12MB6677:EE_
X-MS-Office365-Filtering-Correlation-Id: 50b85a0b-4dd1-44e5-176c-08db062ff428
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: /hECHd+0QI6spE0Q2nTC5doT8qKVEYecxHD7S/dq3IshzojHUbOxypHKR1n2wR5GkjznsOsKnhewU02BKRUYXH5/svW/9Xl5NMReDQNm0K7EK4eEiclSkZYE9ZPwLCgqLxXZws1jokA2qAXd7qGZsjQZLixKGXTzvYLHcfyRGunOcwMkWit0b8ZZ4daVp22voTFlu/IpbH/EMNv9GxFijaCTf/n7PaS8HJneTHyDO6OS+MirFkQSm3lfPs0/DS6e4Ygpoy1k/TqO/ibMqdXgAu+HUi7XwwBiPn+G1QW5FQEOPFxDEfNQxLvFuOc6fgKuW73CUmfxrqQzaIYFo7yBVXjLr4tPCDvCLJWHFoBMNvhMXKuSAmaoOZtO63B5msbWspN8RYOukMDkGcInvd3fH91PuvFUvs/aR9y2kCKXWycc7AH3UDalHu8ziR0i0+nD64D2cBPHGPuQmEkREu4VrIRLI2CCMksrrA6ypCFyx77IGKqPrCnFX+AOjwUcgdxQXACZ0Cx9jd5EKgJwQjM0fc1h2rOi46fWsjxRV92Bz4nYUMVH6lmMehBKYiHNmu7sE9Nc5zD/jOOM39iGWv3e3gw8eitZ0wcZdfwmZoe8rdJaNo8j9AF2lSg3UqmqsPogljd+AWURnXyTuJnXmKgfJZYB+i921nNQWtAXuqVl4pfReRQ+Qf0IksJ4RDeW/KlCQhLzwTNMtp3IgUtd6K2glAadfhUQe20qsv+h5sxmKOs=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB6263.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(366004)(376002)(136003)(346002)(39860400002)(396003)(451199018)(44832011)(38100700002)(66946007)(6512007)(53546011)(83380400001)(31696002)(2616005)(6666004)(186003)(478600001)(66476007)(66556008)(6506007)(54906003)(4326008)(7416002)(316002)(110136005)(8676002)(2906002)(6486002)(45080400002)(5660300002)(86362001)(8936002)(36756003)(36916002)(41300700001)(31686004)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?RW9DU0JDWUVqelkvSVJJdEQrNWR5YStlbXA0M0w2aVNaN0diMzV1bFcvZzRm?=
 =?utf-8?B?VENmRUlaQThpOXI4QkJ1U05QMlJza25mYnJRUDhrQW5sejZxR3VqVTZ5NDhT?=
 =?utf-8?B?dzd5Y2k3KzhGRUpCY3p2QmxnUVBjYkdTUFdPN0ZqZC93cTZsRGtMazlTbGVm?=
 =?utf-8?B?YXRyYzlIemg3UWE0MkdLRmtFTlRoQWFXeUZHZjBmVXJObDBWcEc0K1NqWDdL?=
 =?utf-8?B?OHcvSFBBOFJWNXNlL1FBMGMwbitOZUxsTzkrVytKYTU4cmxTK3MvMERHbnlu?=
 =?utf-8?B?eVJBZXJ5N25kWWtGR0hpOGxnM2ZnbzFTK29zZFRra0ZlbG9QUTJQMjBDNFVu?=
 =?utf-8?B?TktkT1k4ZTJUZ25ualZuRkV5cVdQNSs3VjJiN0pDRHpSb3lNdHR4MmlZVi9p?=
 =?utf-8?B?cjkyZjFkR1JXS1Jjb1NRMGxTUUNtbWdtaUdQblhCRzhpa0dIbW1ndmQ3Y3pp?=
 =?utf-8?B?emtrenJVZmp2R2dxbGVlVHBQbEUyRW44K284R2ZrZHVtQlRxS0Jsd0ZUSXhi?=
 =?utf-8?B?U1RZdEtWVWJXSnpPL1ZVSHdNd01Zalh1bnVMQ01rVDgzaHR4V251dGEvM0or?=
 =?utf-8?B?elpOc2RsRkdvOWpEV0hmVWFFT3JWcEgzeFhsOC9iYkVmSFFQeGRHbk1UdjJU?=
 =?utf-8?B?Q0t5bHhRc1B5SUtydkRCNWhQMHRIWDVreHdVZ0YrRi9IcndiV3ZFaEd4bldo?=
 =?utf-8?B?bVJuVy80TkI5djM0aTJPS1FHMktxcjhVQnBHRndKbEVXVll2ZmdsMWdGSFlT?=
 =?utf-8?B?OXIyMnAyaEhZdDhoRCt0blg2dnRaVm9HUHFkYXpTdU02RmVPeUJWTFVqcE9U?=
 =?utf-8?B?VVJuVnVEM0cwQUdJTlJ3ZVlyWTRiVFlrcFRCQ3l3SUZJbkpKeWJCeDI1ZHRO?=
 =?utf-8?B?SHlta0phL2RZQzZvSUJzMkNqMnVaQyttSURnSVF1NG5Td2wwMzNvZ2VEWjBv?=
 =?utf-8?B?eHpJcDAvYWk3KzErbFFXd0JIMDVHMnVVS3dnU3gzOUorbXZoSUZWTUN5am1Q?=
 =?utf-8?B?cE1kd2NCWE5NL0dBZU5OUFNhZFJtbERsMWZoVmdTTEFmZ0xjMDQ4ZmtaakJO?=
 =?utf-8?B?QjJBNVhZaSttbDNtR3hwdzZMWHJvZTZjTXhLSDQ4dEhpM09Ea245aW94ZlNM?=
 =?utf-8?B?TUNoRHFhdkxzZVpMY0xTOWVNMytLVzFkdjgzL3Zra1lxWW40NThTQmhkSFEz?=
 =?utf-8?B?bkxqaWlkT0lMRHJYTy94MExHZzYxZTJzTDVUeHdWeWJOd0hVTm14T2lHSy84?=
 =?utf-8?B?Y3JUeXpQbm40azQ1Sm9uRlhXNk13ZER6VEF0dU1hMXljRnUwdVdiR0VCeGpK?=
 =?utf-8?B?Z1VSTzR4bGZlVEsySU53dkFFK0N0R0xQam11UDJhT2NQZ2RMK1J4bm1xSnhL?=
 =?utf-8?B?aVRxREhoRjJ4QWJVclBxSEN3dFQrMDl5UHZLU3UxNmwzTVpDaDNZYjRKbHJp?=
 =?utf-8?B?Y1RMOVhQenRXVUlvaU1nUVJIWFpDV3VBQjdXQjlEeHhZUmtnbXp2b0Vxdjk3?=
 =?utf-8?B?Vy8wSUVEQkRJbUg3ak9GNnpVemIrSjhCRVJseTdJcHgrZlZVOWIvMmNteW5U?=
 =?utf-8?B?ZC9sU3hsR21YNThlT1ZWUW5xV2tNS3FuYTFCUkRXQ1doOFVMcmZjTjRQMHZB?=
 =?utf-8?B?dGVHN0lleG4yVUNveWdIaExVaHYrK1Zva3ZSdTk5QXNTcEFKZDZNejJSczRj?=
 =?utf-8?B?d3NVZHNaSWtlaUlGdDlkTjE2UFVUTHkwUWJ5UFBCdi9KN1hjR2JzU2w5ZGg3?=
 =?utf-8?B?ZTdaMWVRQkxJaFp4NWMrUFBTTmttb1RWYXRFVGYreXd6cE5mR3NIdHZjOXVi?=
 =?utf-8?B?TWtqWnV4Q0xjdDdYcHpVNGtXaktkeWc1RlJEcEhCcjFCRUE2ZENqb01OS0xG?=
 =?utf-8?B?dWxnaGVYU0gvRGthNGc3WTJtdERpS0IxTmJDVUNmaUllRlhvZEJzd2I4RzVz?=
 =?utf-8?B?YjdkZFdpY2ZiRS8weWE5U3hLYS9lTlhrUFNMQ3c2dVcwU2RXVDFJY3Q0Zzhi?=
 =?utf-8?B?QlBZRmpYTTNLVU00bm5OUVg1S0ZzTXV2NWY4Y3piTm1SaEUyK2RKa1U2cFNX?=
 =?utf-8?B?ZlZ2VklIMHBCMkdmc3Q3b09jUFgraUFlQ1g2YnN1d1ozTUFiNjlBeFVBSStN?=
 =?utf-8?B?ODVpTWgwQmlpMGNFQkZtdGU5aTcvc3I0SWdHcFRFaTBmaXFRb0diTXRNL3Vt?=
 =?utf-8?Q?AOjmhjad6sBmpO4g10+08RIDMsSDfBRrmsAmyt00v4MG?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 50b85a0b-4dd1-44e5-176c-08db062ff428
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB6263.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Feb 2023 21:45:23.3960
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 6I3t70NP8vpDHnLpzyX9m4vmClNZnvaMhHqV7J5SS3a47GIamvGxU8kvm0L/pkYNfgwuh+HORplvVS6CnSNMWA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR12MB6677
X-Spam-Status: No, score=-1.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 2/3/23 2:19 PM, Woodhouse, David wrote:
> Would be interesting to know if that goes away if you test only the
> first part of the tree. My first inclination is to suspect that's a bug
> in the later patches... although the APIC ID mismatch is interesting.
> That part (with each AP getting its own APIC ID from CPUID) is in the
> *first* part of the series....

dwmw2/parallel-6.2-rc6-part1 (commit 942b3faa258c) re-enabled for
AMD gets the same splat(s):

[    3.195498] smp: Bringing up secondary CPUs ...
[    3.196670] x86: Booting SMP configuration:
[    3.200189] .... node  #0, CPUs:          #1
[    3.200247] CPU 1 to 93/x86/cpu:kick in 315 42 -155206575216 0 . 0 0 0 0 . 0 155217324423
[    3.200418] ------------[ cut here ]------------
[    3.200420] WARNING: CPU: 0 PID: 1 at arch/x86/kernel/cpu/common.c:2122 cpu_init+0x2d/0x1f0
[    3.200428] Modules linked in:
[    3.200430] CPU: 0 PID: 1 Comm: swapper/0 Not tainted 6.2.0-rc6+ #19
[    3.200433] Hardware name: AMD Corporation Speedway/Speedway, BIOS RSW1009C 07/27/2018
[    3.200435] RIP: 0010:cpu_init+0x2d/0x1f0
[    3.200438] Code: e5 41 56 41 55 41 54 53 65 48 8b 1c 25 80 2e 1f 00 65 44 8b 35 20 e4 99 47 48 8b 05 5d f7 51 02 44 89 f2 f0 48 0f ab 10 73 06 <0f> 0b eb 02 f3 90 48 8b 05 3e f7 51 02 48 0f a3 10 73 f1 45 85 f6
[    3.200440] RSP: 0000:ffffffffba203d70 EFLAGS: 00010083
[    3.200443] RAX: ffff8e027eef6e40 RBX: ffff8dfe80064b80 RCX: 0000000000000008
[    3.200444] RDX: 0000000000000000 RSI: ffff8df65c40b048 RDI: ffffffffb9f66418
[    3.200445] RBP: ffffffffba203d90 R08: 00000000fffffe4d R09: ffff8df65c406078
[    3.200446] R10: ffffffffba203dc0 R11: 0000000000000000 R12: 0000000000000000
[    3.200447] R13: 0000000000000000 R14: 0000000000000000 R15: 0000000000000000
[    3.200448] FS:  0000000000000000(0000) GS:ffff8df65c400000(0000) knlGS:0000000000000000
[    3.200450] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[    3.200451] CR2: 0000000000000000 CR3: 0000800307e12000 CR4: 00000000003100a0
[    3.200453] Call Trace:
[    3.200454] ---[ end trace 0000000000000000 ]---
[    3.200509] [Firmware Bug]: CPU0: APIC id mismatch. Firmware: 0 APIC: 2
[    3.284620]    #2
[    3.284669] CPU 2 to 93/x86/cpu:kick in 252 42 -155547668514 0 . 0 0 0 0 . 0 155548597197
[    3.284727] ------------[ cut here ]------------
[    3.284732] WARNING: CPU: 0 PID: 1 at arch/x86/kernel/cpu/common.c:2122 cpu_init+0x2d/0x1f0
[    3.284741] Modules linked in:
[    3.284745] CPU: 0 PID: 1 Comm: swapper/0 Tainted: G        W          6.2.0-rc6+ #19
[    3.284749] Hardware name: AMD Corporation Speedway/Speedway, BIOS RSW1009C 07/27/2018
[    3.284752] RIP: 0010:cpu_init+0x2d/0x1f0
[    3.284756] Code: e5 41 56 41 55 41 54 53 65 48 8b 1c 25 80 2e 1f 00 65 44 8b 35 20 e4 99 47 48 8b 05 5d f7 51 02 44 89 f2 f0 48 0f ab 10 73 06 <0f> 0b eb 02 f3 90 48 8b 05 3e f7 51 02 48 0f a3 10 73 f1 45 85 f6
[    3.284760] RSP: 0000:ffffffffba203d70 EFLAGS: 00010083
[    3.284764] RAX: ffff8e027eef6e40 RBX: ffff8dfe80064b80 RCX: 0000000000000008
[    3.284766] RDX: 0000000000000000 RSI: ffff8df65c40b048 RDI: ffffffffb9f66418
[    3.284769] RBP: ffffffffba203d90 R08: 00000000fffffe4d R09: ffff8df65c406078
[    3.284771] R10: ffffffffba203dc0 R11: 0000000000000000 R12: 0000000000000000
[    3.284773] R13: 0000000000000000 R14: 0000000000000000 R15: 0000000000000000
[    3.284775] FS:  0000000000000000(0000) GS:ffff8df65c400000(0000) knlGS:0000000000000000
[    3.284778] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[    3.284779] CR2: 0000000000000000 CR3: 0000800307e12000 CR4: 00000000003100a0
[    3.284781] Call Trace:
[    3.284783] ---[ end trace 0000000000000000 ]---
[    3.284841] [Firmware Bug]: CPU0: APIC id mismatch. Firmware: 0 APIC: 8
[    3.364[[   [. 343 35     5 5] [  3 364575  [
  3 [    [   [3 3 [ [  3

Thanks,

Kim
