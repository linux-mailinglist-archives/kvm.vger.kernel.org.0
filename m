Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1A9BE34AFC7
	for <lists+kvm@lfdr.de>; Fri, 26 Mar 2021 21:05:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230247AbhCZUFM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 26 Mar 2021 16:05:12 -0400
Received: from mail-mw2nam12on2050.outbound.protection.outlook.com ([40.107.244.50]:54562
        "EHLO NAM12-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S230107AbhCZUEk (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 26 Mar 2021 16:04:40 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=NEdjg9qpJ5ahcCZInNqQUx7SsvwcpJa9oK6s2l3LK5TVlJEGwjR1MVM7Hf63Tanzg6YSS2Avk5U9ZVcaWOE3BoV6FIBRf1EfE6s0vjnmSeJgAIKciccUKGTk7zgCgeFHWNg4Ewswka+TPQKoJK9ybAmPwVmKTpe+/eHmOlFRQViAWPYunhg6ROnyLe3YUay56UzODSTrmeZvBp7zvfo7V+twQLKwMLFxFqgputKOsu2oMAV4t1vw/cA0Cu+zUzKOkSLCpjCuKSAtwIm5g+nRBopGRsG7HG8EMGHcYo8OIqhxVNpd2lI1T8XnewvWgird/sG0yn4tKUvq26vL2oHDBQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=C5GWWGElY7u2XIX4UET1BnmH3TVo0144OVfb6X8qGKc=;
 b=MSf57MGPPmhpjFlC4tzMMdQUw4Kbvl1kLPBB7zPVTVUDQhqCfeAZABV21VvRJzcZhvbC4/Qni+AVtydSrelwgbKy6Qu15WL0sWPz8IS1rLV4tT7UYlhNxXjLOZjyprIiSIs4RvIsIJ9Nl0gsHRkwG3CV59Hd1wqKpARtz37eLGtgQqm2HDDA2PjplXCyfr6Khwe9YrEXabwMm/sOBo6DYu6VgoDhkvEPgadcwhY3eDYmd7EHJBWNFfOOl8kHzPu6Dae2Emhlk71TJK6IPM9mxIg5f0EeH8/Zog0SMFu4zRVkT7DqyXIid4vX2uzJKkHMOecZ1ib5koYOBC3A4vZ4tA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=C5GWWGElY7u2XIX4UET1BnmH3TVo0144OVfb6X8qGKc=;
 b=GtBvo/ofAmEgFJNN52Anv6d3GH9cCHqgQJDIUbpVUVOpHcZUgg2NRuz8a5uhWTxGKY74YKER9YumaZnZeF71bYWT0teOHh8F9yyG0WglxlPxvIGJ0G+h9KNj6Z7LM8883g2KxonaOO0BC9pDmP21c+4PsySuY/U6A0grZpWTK84=
Authentication-Results: google.com; dkim=none (message not signed)
 header.d=none;google.com; dmarc=none action=none header.from=amd.com;
Received: from SN6PR12MB2718.namprd12.prod.outlook.com (2603:10b6:805:6f::22)
 by SN6PR12MB2687.namprd12.prod.outlook.com (2603:10b6:805:73::26) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3977.24; Fri, 26 Mar
 2021 20:04:37 +0000
Received: from SN6PR12MB2718.namprd12.prod.outlook.com
 ([fe80::30fb:2d6c:a0bf:2f1d]) by SN6PR12MB2718.namprd12.prod.outlook.com
 ([fe80::30fb:2d6c:a0bf:2f1d%3]) with mapi id 15.20.3955.027; Fri, 26 Mar 2021
 20:04:37 +0000
Cc:     brijesh.singh@amd.com, linux-kernel@vger.kernel.org,
        x86@kernel.org, kvm@vger.kernel.org, ak@linux.intel.com,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Joerg Roedel <jroedel@suse.de>,
        "H. Peter Anvin" <hpa@zytor.com>, Tony Luck <tony.luck@intel.com>,
        Dave Hansen <dave.hansen@intel.com>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        David Rientjes <rientjes@google.com>,
        Sean Christopherson <seanjc@google.com>
Subject: Re: [RFC Part1 PATCH 03/13] x86: add a helper routine for the
 PVALIDATE instruction
To:     Borislav Petkov <bp@alien8.de>
References: <20210324164424.28124-1-brijesh.singh@amd.com>
 <20210324164424.28124-4-brijesh.singh@amd.com>
 <20210326143026.GB27507@zn.tnic>
 <9c9773d1-c494-2dfe-cd2a-95e3cfdfa09f@amd.com>
 <bddf2257-4178-c230-c40f-389db529a950@amd.com>
 <20210326191241.GJ25229@zn.tnic>
From:   Brijesh Singh <brijesh.singh@amd.com>
Message-ID: <0c1037ce-cd40-0c22-0dae-29bcec488feb@amd.com>
Date:   Fri, 26 Mar 2021 15:04:35 -0500
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.8.1
In-Reply-To: <20210326191241.GJ25229@zn.tnic>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Originating-IP: [70.112.153.56]
X-ClientProxiedBy: SA9PR13CA0156.namprd13.prod.outlook.com
 (2603:10b6:806:28::11) To SN6PR12MB2718.namprd12.prod.outlook.com
 (2603:10b6:805:6f::22)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from Brijeshs-MacBook-Pro.local (70.112.153.56) by SA9PR13CA0156.namprd13.prod.outlook.com (2603:10b6:806:28::11) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3999.18 via Frontend Transport; Fri, 26 Mar 2021 20:04:36 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 29ec59a0-2d32-48ca-30b7-08d8f0926213
X-MS-TrafficTypeDiagnostic: SN6PR12MB2687:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SN6PR12MB26874101B8A1D91D5CC6AB92E5619@SN6PR12MB2687.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4303;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: mS6bDU/hhXIrDj/EPhBbadX8W5LUh5UiviKbG/vtGxRJkJ/igr/umiNvJJWoSWpGHraTJS1Zz0miS2xmR7OalPyyeefmOW5Y+q55wYkCEN2KDfLhgDjbHbBqa+SlIyttSOJ6CzGC5blzIVzhf1za2kzZuh01WjIncv05NIo/dn4hyCbPjNfch1Zytryu4ixHp9xsFt/fbiqVhEBMTUHHC9Uv8HXtJftFb52D9gc1jnn7qMSQ8XL1tm7qmo3HygeYVSZLest9X3DAw2V2oIaYebN+es+skER1eStGha2M/ZORBPAswTjKQ5dxwJ7Y8xzUyzgJktJVvji1l/1VyZTubxQHRq9xOY7gtvSJgSlZ7DYVWqo2tfP/gkqInsIlqZH0kmvRuLwiwh3oepku9wcoy/W6pXKGxTH3JYhYjdKioQWY5VeYCnpes6ndRORUIBm8M6DH8XNfwUiko8q6xpP048IIpic5thH4eVKsbk+y25FcC398dY6JXetpkSzCUL4rzSeClZ+7hw3UorQABd3XgS9f8MyhsLDZrRcVGlvZirUkzlRctq/Fh5pEPF7UPRiS/DY68PmHIQrDaNNy9o22puJj4aEw2iA0fh9eE1CL+D8Y73txay/a09Ae0ox1KaKHyNRL/K2fRAEXx3cvGiDyGLHBJGZrWqtEz/8esTdXlfxchQPlaIiv8P1y08NHrf0wGoGNfQdr+n5XQ9Gkl8CT4A==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR12MB2718.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(39860400002)(396003)(376002)(346002)(136003)(366004)(44832011)(4326008)(36756003)(316002)(186003)(26005)(53546011)(38100700001)(2906002)(6506007)(6486002)(956004)(16526019)(31686004)(2616005)(6512007)(31696002)(5660300002)(66476007)(66556008)(52116002)(54906003)(66946007)(478600001)(8676002)(7416002)(8936002)(6916009)(86362001)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?RjFmRzZ4MlBYQ2MrYU1LMjdGZHdwaFlYcjY3MmNUMVdWU0d4MkY0NVlnMmxR?=
 =?utf-8?B?eHd3ZEI2ZFkwSHJFNEs4M3F4OGJHWHZIRTJHYmNGejRyK1lFcUNLTCszMGxy?=
 =?utf-8?B?b2lmNURaYmVJMEVwK21uMVFXYm01bEl1S25pK3NOeUxaYURjTW1wSHo1RHY1?=
 =?utf-8?B?RGxpeURnTjNzNFJzV1g2dGEybXM5Mm9xTXFaMTN0UkRTMHMza1F0VEc4Uk5V?=
 =?utf-8?B?aVJIaWRPVXN5MGI0L09FVDlNVHZ0Y0t6bytjdlFWYWd6Ykg0M0dzUXkxbFUy?=
 =?utf-8?B?aFdWVlU3ZFNMMkNONlNpQm4wR21qTFQ5VzFzVmJWMHVlQkEzeU1rajdrQnhH?=
 =?utf-8?B?bkpZRzJyK1ZHd0ZjaGFJaWZzTGoyL2txVGVrbzA5RjFlNjV0OVVDZSszRlI2?=
 =?utf-8?B?R1o2NDV1MUlIcHZsWnZGRTVjY2FCN2tCYXYxVkU4M0l0M1V2VnA4c2ZVNWwx?=
 =?utf-8?B?TksxSWMyTmpFRFRLeWpNVkV1M2dXQTBaclNqbnhEbG1MOUN0N2xQaDJMSmUr?=
 =?utf-8?B?MFpZa2VybUNEQjBOREUwWitTRzdhajg5SFRLQkhzdmZnRW5QdStraFREZXN2?=
 =?utf-8?B?ai8vaGNGalhXc3l6bzN6aENiNzNHWUU5cEZBRm9ySW9INGVKMjJsN0dERzdy?=
 =?utf-8?B?MVYvVWdYamIrTExLTnBOb0gyblJOK2plazR4ZDd3U2JKRjdCRnNLWHI2bEJs?=
 =?utf-8?B?Y3JkRjdWMnFlVVg1OFF3UXBvdVJsU3NSVjFuZDM1L3dVUU96bGNMY0VZY0xG?=
 =?utf-8?B?SGVlQW1UNU5FYTduK1d2NXNucjdqbnU0ZnJITEN2cDdDU1ZBbmZwNER1VTh4?=
 =?utf-8?B?akJFZjFEeUJVRHR0N1RRci9lYUhNTGlINUpzWGh2cDFXODVYa2wvaDFxSjVM?=
 =?utf-8?B?RTNFOHpNNVV3dW93WGRxenlkTVMvMEs2dDlERmd5YVJIcHFyK2NnZ1ZxRkFo?=
 =?utf-8?B?cnEyVGlzWmdpeUZSMXkwcUlJU0poUE0va251Tjg4TTMvRmhZNUltNlN2dW1L?=
 =?utf-8?B?TnJQYzVoYWNFSmZIU1dua3piMFBrNW1HeUx4SUJPQ204UVExRE85SmRZT2JQ?=
 =?utf-8?B?YWtvakpuMEJwRDNxOGtDWFgrY0JGOTB6WE0yN3d4NlFRTnNTbHpSNzRlOGxD?=
 =?utf-8?B?SExtOGxUU3JtWmhQUURGZWdUMWlRQmpZbVRSalhuVlR6UERqTUgwNHh5OWR6?=
 =?utf-8?B?NHVZYU9mNVppcnpnemZzc1o0ZURqT2lXUnhydHhBOWlCaEtUYTMwSE9QaWcr?=
 =?utf-8?B?Qm50TmgvUWZhd0h1QlpTZXBqaXpRQ01SSGlXcmduOE96UFo1OFBuYmJlVjdt?=
 =?utf-8?B?N0RSaFkxcWlYWDVrd0pTdTd3Vk1LK1hBOU1yTTZlUDdOamtJM3FvL0NjUllW?=
 =?utf-8?B?Mk5QSmlDTUdGWDcwbHR6RzBaVWNnSkVPREJnMGVjUi9IUDJEQmtHaWtxTEpS?=
 =?utf-8?B?VnhFTTRYdjlqVjgvT0ZndmNMMUFhd1o2c2pyWlI1QUhKaTJ0OG9Danp3Rm1M?=
 =?utf-8?B?VDRsNnk1MWh2UnFXRXZTRU15aDFuYTlZcU5reHZlc0xQTHo0NVllTG9HT0RI?=
 =?utf-8?B?bnFZck5EcEE1N2l1bXBXUDhZYWZpcWd6RXFzREF4azJnWDRITDFIeVVtMU1q?=
 =?utf-8?B?M25qWEdXU1lWOFU4T01OamxydnE0SkVJLzRuRU96aVpUWDRBUEREYUVDUXlu?=
 =?utf-8?B?aFVaZGZrTEJuN0ZCc0R3bHNZODdsam9vZ3IvMlNkTExMMS9haDJuMzRkWUR3?=
 =?utf-8?Q?rI6fwZs5W2fUO5xI5x+puTDwIuq6696z5U+1juU?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 29ec59a0-2d32-48ca-30b7-08d8f0926213
X-MS-Exchange-CrossTenant-AuthSource: SN6PR12MB2718.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Mar 2021 20:04:37.5930
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Yosxhzh0+qU8IjLvvGjmyVCyGSjw8n2kG+wLLGQCvkjYLnHe8wuswKPdZSNi5xxKmxHDx+ls5hQSUEf1jp9Raw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR12MB2687
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


On 3/26/21 2:12 PM, Borislav Petkov wrote:
> On Fri, Mar 26, 2021 at 01:22:24PM -0500, Brijesh Singh wrote:
>> Should I do the same for the sev-es.c ? Currently, I am keeping all the
>> SEV-SNP specific changes in sev-snp.{c,h}. After a rename of
>> sev-es.{c,h} from both the arch/x86/kernel and arch-x86/boot/compressed
>> I can add the SNP specific stuff to it.
>>
>> Thoughts ?
> SNP depends on the whole functionality in SEV-ES, right? Which means,
> SNP will need all the functionality of sev-es.c.

Yes, SEV-SNP needs the whole SEV-ES functionality.  I will work add
pre-patch to rename sev-es to sev, then add SNP changes in the sev.c.

thanks

>
> But sev-es.c is a lot more code than the header and snp is
>
>  arch/x86/kernel/sev-snp.c               | 269 ++++++++++++++++++++++++
>
> oh well, not so much.
>
> I guess a single
>
> arch/x86/kernel/sev.c
>
> is probably ok.
>
> We can always do arch/x86/kernel/sev/ later and split stuff then when it
> starts getting real fat and impacts complication times.
>
> Btw, there's also arch/x86/kernel/sev-es-shared.c and that can be
>
> arch/x86/kernel/sev-shared.c
>
> then.
>
> Thx.
>
