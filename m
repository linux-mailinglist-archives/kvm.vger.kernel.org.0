Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4A79E477CE3
	for <lists+kvm@lfdr.de>; Thu, 16 Dec 2021 20:55:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241140AbhLPTzm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 16 Dec 2021 14:55:42 -0500
Received: from mail-dm6nam10on2066.outbound.protection.outlook.com ([40.107.93.66]:6243
        "EHLO NAM10-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229909AbhLPTzl (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 16 Dec 2021 14:55:41 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=BA9JEu3YcWEiAKNoHn/bjG98ydXCWDzinKW6a0aGiO2vbQuiVj63jf2sbslgFCNMMi/tVItZgbH+OkRnDtfAP8rmMlnoT3cfaUE5e06TB2IOgCP4GNpeq2UNUN0s7wquhib1o2gIF2szMIqkwy+gIBPczTAwCnfq3/ZtS8c5q/iPj0cJcbdXJx2UANRLAr8VT6fi6a9QyXtPAWVqkQDergHDIBlcZAk7EHziT+k5VXrQT98+I3ePgXzFqLX9mLh7LEb9xgJIib265iFtgOmGRDXSQGVT1a2xrsuSZCzSYxWV+54Q67hhiaIqOZpUwaLSjVfhAcPxb1tbaom3S2AYAw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=WWPLzv/4aB1VVHagjB0cIUXGuPaFBrtEJBVvsNVNXPc=;
 b=cZ6gg8F7PXKzXaB0E9I+lD5z2YPVNgfdO2mQzR2gWy0Cr4YDrNUo7SH3QiUNsGRTiW+edqz6pZz50I75AgpmZs6enV0j6yYQVZ1DFjEJzIeFvIsRnBCV+VlbeLl1IAQ7K4aDc1pQ4/n2PprOQLGXF1Fp315IJDfe/HdHwtLHQWR0iQLseybsyQnsmrDtxmu1nXqBh4O2Dikov8hweFCkwiKmr9MuhVAHDzclhGPmeUGNXIFWu03a6uiEGKM+LkhXQ4hoOA5SOUFa/kgUZQXtADhdCTkX+WkRya/IIqMgLUwNFbnNTHibF+mHTx4INiSHrmfGSPslKykk2htvs+D2Lw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=WWPLzv/4aB1VVHagjB0cIUXGuPaFBrtEJBVvsNVNXPc=;
 b=cotis0SxexMRnge0aPaSUkdbQ4F2YMuimBe7gqMFWhLGkJhX664o0JbcCPn+xXpBrfZ+Yd2r8eqO7ULh0CgMy2fgAz5vSuzlj79LRzGwqkhb4Oy11O3X15DzVn6+Sf/Vaz9nB/EEl2ZA4Zt1PgzTfGxK8DR5Wu53OO8RfDAqsv0=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DM4PR12MB5229.namprd12.prod.outlook.com (2603:10b6:5:398::12)
 by DM8PR12MB5462.namprd12.prod.outlook.com (2603:10b6:8:24::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4778.16; Thu, 16 Dec
 2021 19:55:39 +0000
Received: from DM4PR12MB5229.namprd12.prod.outlook.com
 ([fe80::1ddd:71e4:5803:e44a]) by DM4PR12MB5229.namprd12.prod.outlook.com
 ([fe80::1ddd:71e4:5803:e44a%3]) with mapi id 15.20.4734.028; Thu, 16 Dec 2021
 19:55:39 +0000
Subject: Re: [PATCH v3 0/9] Parallel CPU bringup for x86_64
To:     David Woodhouse <dwmw2@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>
Cc:     Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        "x86@kernel.org" <x86@kernel.org>,
        "H . Peter Anvin" <hpa@zytor.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        "Paul E . McKenney" <paulmck@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "rcu@vger.kernel.org" <rcu@vger.kernel.org>,
        "mimoja@mimoja.de" <mimoja@mimoja.de>,
        "hewenliang4@huawei.com" <hewenliang4@huawei.com>,
        "hushiyuan@huawei.com" <hushiyuan@huawei.com>,
        "luolongjun@huawei.com" <luolongjun@huawei.com>,
        "hejingxian@huawei.com" <hejingxian@huawei.com>
References: <20211215145633.5238-1-dwmw2@infradead.org>
 <761c1552-0ca0-403b-3461-8426198180d0@amd.com>
 <f0b4eddc2cdb3aae190bacd0a5285c393e4f8ea3.camel@infradead.org>
From:   Tom Lendacky <thomas.lendacky@amd.com>
Message-ID: <0247ce40-1f1e-3581-95a2-8a1d51cb8fad@amd.com>
Date:   Thu, 16 Dec 2021 13:55:36 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
In-Reply-To: <f0b4eddc2cdb3aae190bacd0a5285c393e4f8ea3.camel@infradead.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: SN7PR04CA0173.namprd04.prod.outlook.com
 (2603:10b6:806:125::28) To DM4PR12MB5229.namprd12.prod.outlook.com
 (2603:10b6:5:398::12)
MIME-Version: 1.0
Received: from office-ryzen.texastahm.com (67.79.209.213) by SN7PR04CA0173.namprd04.prod.outlook.com (2603:10b6:806:125::28) with Microsoft SMTP Server (version=TLS1_2, cipher=) via Frontend Transport; Thu, 16 Dec 2021 19:55:37 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: bece2fea-a617-48ba-c7c7-08d9c0ce08a4
X-MS-TrafficTypeDiagnostic: DM8PR12MB5462:EE_
X-Microsoft-Antispam-PRVS: <DM8PR12MB546219D00773F26ABD0260CAEC779@DM8PR12MB5462.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: kYeoQUUlFPlMORv95jC/lq59p3LrRhKSRFP8kvl+5tgZGcr+J6IaaFwWYCev5O67MgiYwcBQbzKU1DHg5I7frTiuchp32/dtdpQ85J7d1awoIDmPu+kT3AZRiVneDNrVHzudTCodVYuHJkLaqOwkUR3qvrYUAvazwSIn7m3hVxb33FylZncOQ78T7/hCNcpyEyOS8i/Z81/PSoYQkk16MWR/s9wNbst3tYNsfVAkghIoNz7EOF6pJovKmYlS2wCMK2YtjHRBbL35nX+rQmyp52RKygCJGS2ToVMoESr5PkG53qqxD4Llf2whQa7lQajKSYMtv1v3xemXtdRgCIeUv2KINQOBpkVlaZ3u0aknp+yhe7yZtoraGcYnQqKiiD5lmJd/TW4JH+NCfTrpNe2WVYfQfdee4zTAKEGW6AlyuvJ1AjKEDl32bHyoAdGQmSrkGivggDw+mEfVObv6A8KWPhZ6t4id/OVcgfWXrH1lVCqh74A8JgQsSibXGcH4m28553uppXX8pLIpKmP9owMlTMFwmTE4koX6ItI1QkVOQnXUkEws+zCkx7IYcNFMehrKp4uOSJHhwYNKOMu085lhvlS5oGzSl7USasf7ax4UFuSXkqFhXCFsUK8/vHZO66S56fEQZTXjBty5t6F0P4LIPSsIjPvucQvvQIpWJaTSP6Wn8w8+NViIug9AK732pv59b312OJk3ZasWyjHs1oUFuDBKwk+Y1PX1YauL2E2w8vJWa4/bgzURiULxlgienwoMXZqwqY8A7x6IiklSXXRjKbc7U32Vc1o2LO8Zex9KRqHH0cXmORCdci+nhNMbsVjdJS6O/vCpWJkoib2djr3FqA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR12MB5229.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(66946007)(7416002)(66556008)(316002)(54906003)(53546011)(966005)(6506007)(31686004)(6486002)(4326008)(31696002)(110136005)(8676002)(508600001)(186003)(86362001)(66476007)(956004)(8936002)(4001150100001)(36756003)(5660300002)(6512007)(2906002)(26005)(2616005)(38100700002)(83380400001)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?WGNScjZQOG10QUxocGRRSW9qbVVmSmFlWFRnYllnVFpscndaTGI5ak92YzRu?=
 =?utf-8?B?ckYxbC9JNktkMWZmSENWVXRpUVhVMndlSlQ5bGlzUDJHaWg4OW9GQnBkTVQz?=
 =?utf-8?B?ODJlKzRxVjFWdFB3MEVFYzRBcDBJcm5Gc3R4Y1FXaEFQSjhXSWJkNk1yZ1Bp?=
 =?utf-8?B?eUd1UFhQUUNjSCtnVGRmZUNUbXByWFdPRXU2c3RtR09mb2xoRXFkRlRkTG9G?=
 =?utf-8?B?ek9kWE1YSlZ2ZFAxbmsyWFVFbGV4R0Z6VVg3MnljdkpIQUNwYm9FamY5MElt?=
 =?utf-8?B?VFhLbWxpeStZOU55YUsyTlJIVTV4SDJwa0orQXM0WkM0ZE5wVTRqcVhLZVVm?=
 =?utf-8?B?ZEV4N2NGbHVQaHJ6K0NVd1FmV0RYZmpiSlJ3TmgzVHhWLzZwZWZOODlTTlh4?=
 =?utf-8?B?RXkzYm4rdE9zZjU2Yk04b1VCS1I1ODlZbXU2amszc3JyVTJ1azUzaElxYURa?=
 =?utf-8?B?UnZPcGUwSGkvZjdlT29KQTNhbFdnN0I1NmNtRFhxbFpwNHhSakNQaWtlTTRh?=
 =?utf-8?B?ZzM3MDZzeDZhcFRaK1BkeHFJYkJaalRvcG43aHVYTmZBNCtwbHRIOEY5dllD?=
 =?utf-8?B?SStnSElndi84ZDJYYWNJaWJnWlFVSTJJR1VVVkl2azZiQUNMYVVQZUovSUkv?=
 =?utf-8?B?ZUxBYVkwQmRaZFNiOUhuQmgwNnMyUE5qZHNjZTRpdUVkeEEzbkVVNnR0VWRr?=
 =?utf-8?B?dmlCZ0lBZmFkMnZuZjg0RjF4a0JkRmVCRWpBcnI4WVdwdFYxbGd4VW5XblB0?=
 =?utf-8?B?Nld2RmxjVGxNMlFSTktzMXY1T1dGSFQvaVNjenEyOFp2aW55NzR2RmdybVR1?=
 =?utf-8?B?bHUzSXVod2RJTWo4K2h3aFNXTHRJM3F4V3l1eU5QMkxiU0RSS2U2VU5BaGN1?=
 =?utf-8?B?UWRESG9DSk1SL20yZnpBL3laMG5yZHFsM2VxMTZ1TDNnTFMwQkMzbGVmSlNU?=
 =?utf-8?B?UUJhZHRqVXBzaWR0VUFTbmZ3dm0wTy95TVB3elRIWmMvcjJIL2ZES0FWR0ZT?=
 =?utf-8?B?eGtvcFlmWTZnblBnRGtpTVRUV2JTQkVLUGRvYXlYdXUvVGpIdWdPZ0owdFNS?=
 =?utf-8?B?dWtrQ3NqSGdiRS92VXBFZFhQK1pRbWdMWTdTc2hXWVZTa0lSQzBaQk8wMGJn?=
 =?utf-8?B?M3hkaUxiSFNkL0pWVmZWZm94djlOTjhGTXV4WW56MldpeWc0SGtCTVNBdzRo?=
 =?utf-8?B?UWVPL1RoclJ4TzE3NFJmUk1ScTNmNnZxSWxOS2ZoV0pQRUh4M3l1eG1WMlBU?=
 =?utf-8?B?b2grZlZsL2Q0dTZQVHBTNUphcnZjcHJrQTgyTXE3Z1QxNFNyZ2srT2ZmNmdO?=
 =?utf-8?B?a3FMc2RrUkhZT09wY0JuWG1NcDM5OTJCNEFyU0VuYlFST1g1SmI0LzZRSjYw?=
 =?utf-8?B?RTZGdzZnazNobkFhZjlRb2hEakFrZUNYZ0JqK0UyTy9zd1ZIWmtQYlhxbFFW?=
 =?utf-8?B?aDNRZVB2UnVZbHNoU0l4THk4UFFualQzV1ZUbHdLalFqL2N3V0t5Rjh0UGFB?=
 =?utf-8?B?cUdKSDh2MFUrVU1SS1M1cThZTU5aVjdJcDJDcWd5UnhMcjMyM2FBNmhUMUxn?=
 =?utf-8?B?Q1lndUozcnpzaEI4d2l0SW5IeGRINWtzdng3UzYzWjZkMjhqNkMvVlBDSWwr?=
 =?utf-8?B?WDlOUkFlanBGalZaVjZ2NUdBWlZ6WXg2WUJ1eGpqQ1pIT3ovSmdwK1JidnFY?=
 =?utf-8?B?a0hiZ3JjY2lhU0tjUjU2K2pId1p6TW5QWFFMODd3RjJOeEFlRlFxVlJpVk9Y?=
 =?utf-8?B?U0ZkdGZQellIdWNvK2hPVlRpTjNjVFdKSGIrSU9WeHpiYytyZisxRUQyaVRX?=
 =?utf-8?B?OHk2T0EyREsyT0tsMW9XRDUzaWg2MDNlUkVVdlVuL1hMY0ZIbnVKb3lmWVZC?=
 =?utf-8?B?V21OQ2lac2MzT29hUXRuYUk2UEVJc1hBVkhzckFQaGhrWnIzNXVjdGlSUTB4?=
 =?utf-8?B?VzZndEdMWlYyRUZMUUNEOW9KWXVLdHlsQXB2Wi96a0hnTDlZTDFoTWw2Y1Zi?=
 =?utf-8?B?dGZLK240cG1tOHJZVFVSalYrd1FzYjJjUURuYnVRenFvekM5VkVjL2tlM0tm?=
 =?utf-8?B?V1hrL0RCUEhmUGNMcVVBeXVIOTJCV1poQ0U5MUZhbTRNWDlLSGZOUndKNHBq?=
 =?utf-8?B?dTU0Y2lMbnVYL0cvc3VxYTFieHhxZXBEYU1xZmJPeDk4aXh1c2ZVMGJEa0h5?=
 =?utf-8?Q?yvy889OxSCoECmSYhdqYAys=3D?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bece2fea-a617-48ba-c7c7-08d9c0ce08a4
X-MS-Exchange-CrossTenant-AuthSource: DM4PR12MB5229.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Dec 2021 19:55:39.3664
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 0Gb/8WlajSBvwIxJ1PLiqQVh/vd4RWFbYQW7HlVAmSnAuH1IIIB1DQzXT9/CK4vomc781VH1R6nmOXH4IK8Rvw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM8PR12MB5462
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 12/16/21 1:52 PM, David Woodhouse wrote:
> On Thu, 2021-12-16 at 10:27 -0600, Tom Lendacky wrote:
>> On 12/15/21 8:56 AM, David Woodhouse wrote:
>>
>>> Doing the INIT/SIPI/SIPI in parallel for all APs and *then* waiting for
>>> them shaves about 80% off the AP bringup time on a 96-thread socket
>>> Skylake box (EC2 c5.metal) — from about 500ms to 100ms.
>>>
>>> There are more wins to be had with further parallelisation, but this is
>>> the simple part.
>>
>> I applied this series and began booting a regular non-SEV guest and hit a
>> failure at 39 vCPUs. No panic or warning, just a reset and OVMF was
>> executing again. I'll try to debug what's going, but not sure how quickly
>> I'll arrive at anything.
> 
> I've pushed the SEV-ES fix to
> https://git.infradead.org/users/dwmw2/linux.git/shortlog/refs/heads/parallel-5.16
> and in doing so I've moved the 'no_parallel_bringup' command line
> argument earlier in the series, to Thomas's "Support parallel startup
> of secondary CPUs" commit (now 191f0899757). It would be interesting to
> see if you can reproduce with just that much, both with and with
> no_parallel_bringup. And then whether the subsequent commit that
> actually enables the parallel INIT/SIPI/SIPI actually makes the
> difference?
> 

I'll pull it down and give it try.

Thanks,
Tom

> Thanks!
> 
