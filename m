Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 82B0075B750
	for <lists+kvm@lfdr.de>; Thu, 20 Jul 2023 21:02:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229941AbjGTTB7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 20 Jul 2023 15:01:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51070 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229519AbjGTTB6 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 20 Jul 2023 15:01:58 -0400
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2088.outbound.protection.outlook.com [40.107.243.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B15041734;
        Thu, 20 Jul 2023 12:01:56 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=kn6ylFu0hBaTmvCMott0BU1Cg1pwgEtRSlaQUmcqy1/AzjBSS0Rmc0P9oWQCNloCVdGCUNUYByOxD7mxK0mC+uo2qBDq4i4Doe89sGHvte+qxAIqq266X/rZSQ8tZcHWkAi2RcsIsPhal0NZtbAznBZvZT9omp4Y5O2qc5VwZuLOkWok/+gtlQ5S3jlnjBKHiYc5v+4ea4vKBxmwMyxtyaldz/7M9uy7UUfMy+p+vfwEVZwvKICAOnZiCqTMnpFmIhOmeyX3PCcaZ2kAU3jqR3L0pvzW26yDPSuaakZL8u+mvY/9rK7ILF4mLisnQmpDNuTWHdS+SqBoBElaQfpEXw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=NxlDtA6ykLJ/Hzdd4vZOfPsUgcO76Ahzqh5cZmSFUH8=;
 b=WvwZoAmlbg8RMjG95PiyUTMLwomA3d9R+ex39hWBxgg4TK3jpsd5V+KMyZIm3zn1JWMrOur7BGybg5PkcIaFJMxSzoZ2rQ2ucuEsqTBjBWfBFl22oa5Q6Oiu3ffUwsGdrsemQ3A8tmgIYZ6+Jv2mYPBuchgx/U5VUnWtOxDL2VzkDaJA05yfp5JlQlaBYVbXT00X/hFLHYs1rte/rFS3nA8axMZZCkjqoNxbhiUtr1vdC5K9YbkwCOgcuXYm3xNDmP5VWH8GVN96/YxoxCCFITR4nM4LxH4HicG4Y7e8QBqawZqvQAQ3ZUiMUo6URfbGeQ7e+eodtaPXkZ4aOUnw2A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=NxlDtA6ykLJ/Hzdd4vZOfPsUgcO76Ahzqh5cZmSFUH8=;
 b=ACgbDlm/LCSaIIVItMNKCg9JhiJ9yYpNn/FLDnyqszg0dmWLBv+h3q5gqFJfsFhsIIydcHYrOrNiFr5+LglvJp90NNAufRiGd0Rml/yiFsSp9LuThQLQMjGxZ+8twNuLBtDk1Des1Bok3y3I+7u/DHGv/MpD+Er5e+2S1WmFNWY=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DM6PR12MB2843.namprd12.prod.outlook.com (2603:10b6:5:48::24) by
 BL1PR12MB5899.namprd12.prod.outlook.com (2603:10b6:208:397::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6609.28; Thu, 20 Jul
 2023 19:01:54 +0000
Received: from DM6PR12MB2843.namprd12.prod.outlook.com
 ([fe80::8eef:8dde:e1e1:2494]) by DM6PR12MB2843.namprd12.prod.outlook.com
 ([fe80::8eef:8dde:e1e1:2494%3]) with mapi id 15.20.6609.026; Thu, 20 Jul 2023
 19:01:50 +0000
Message-ID: <5b30bcce-0b65-9bf9-4eee-dd64d97a95db@amd.com>
Date:   Thu, 20 Jul 2023 14:01:48 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Firefox/102.0 Thunderbird/102.5.1
Subject: Re: [PATCH kernel 0/9 v6] KVM: SEV: Enable AMD SEV-ES DebugSwap
Content-Language: en-US
To:     Sean Christopherson <seanjc@google.com>
Cc:     kvm@vger.kernel.org, x86@kernel.org, linux-kernel@vger.kernel.org,
        Tom Lendacky <thomas.lendacky@amd.com>
References: <20230615063757.3039121-1-aik@amd.com>
 <a209f165-b9ae-a0b3-743c-9711f5123855@amd.com>
 <6c5d1e74-0f6d-7c9d-c4e7-a42342ca60aa@amd.com> <ZJWqBO6mPTWyMgMj@google.com>
 <4338da4e-300b-12f9-609e-d4b1d69eda0b@amd.com> <ZJ9OnJ9dzSmHFirC@google.com>
From:   Alexey Kardashevskiy <aik@amd.com>
In-Reply-To: <ZJ9OnJ9dzSmHFirC@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SN1PR12CA0088.namprd12.prod.outlook.com
 (2603:10b6:802:21::23) To DM6PR12MB2843.namprd12.prod.outlook.com
 (2603:10b6:5:48::24)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR12MB2843:EE_|BL1PR12MB5899:EE_
X-MS-Office365-Filtering-Correlation-Id: d3f44fe7-e2a8-4a9d-0d1f-08db8953c63c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: X6J5SmRjJp9VB/Sl3f/0l/nrd98+UzC3AqOyeUypUvZvhLeKdMNCkdvNZ3rj6N0IGCI4srs69kt/3SiaVn+I16OpfZzYrThEo1erY18GDnz4qO52phafl0yK/b60dIdGj667gEPPVKP2EGV7hLwsisHJN9NlOQvFcnpfw5VIvRuVFt9RRzE/trlyJWcAFDLzDwK4wk21JN5H7TJ+qhLaeRdXCRingL+OEZBCAKIH+BxvelO3DieJxQ/1ZYasBkMhhKzFW57UeHyB8bVHgCj2hUiSPRVwBIms8VrPj3ivmIAtaU4F+OJkBD8Zi5gJ5bxMe+t05OePu/aRdLmWwgY2lojl+Q0h3UNpXu2+N4dEg90jJ0QuhlThatE+Y71JdGX3apiBpl9R4+93luuRbUzAjiBbMD370lYSpwihISVCOIky8sp0zrtCoRhZFYLWQHB3ajBcdnBdi7FrQJHQkp9ZfbtTu8L+NrQBHYmemsm9Qm924d7UIq0WVDZMZ2y1Wu0+QSYiX1N4xY1nb1DkFglytfaRElzyDqaC6SyHSgFD4UQy6ToYBOIuVQKYYHMFJn2y7ityv2R4svPqdXfHbOXiJkv71QdPt1MYlXgdgDFWuW5MmVeZWX/CkE+rO0eSII2ka9cjCdjdwyNeaHMj4iMmxQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB2843.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(39860400002)(366004)(376002)(396003)(346002)(136003)(451199021)(31696002)(31686004)(38100700002)(36756003)(4744005)(2906002)(66476007)(8936002)(478600001)(8676002)(2616005)(83380400001)(5660300002)(6486002)(6512007)(53546011)(186003)(26005)(6506007)(6916009)(316002)(4326008)(66946007)(66556008)(41300700001)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?ZUx4bDFFbWlpZ3Q3N0s5YU1mTG50QTdadE1rZnBvVDJ1VFhNQmdab3ZrMURK?=
 =?utf-8?B?ZGxzK3hCU2JXUS9mMzZya2krVW4yMnVHeTZBWXBDK1ZKdjQwUHhCbVB3Q0VE?=
 =?utf-8?B?b1dzalMwTDdpQndlTkFrV2pwYWUxVUVnRUV3YUU4MkNMbGl3cE1ld3c5aTBj?=
 =?utf-8?B?MkpNaE95SmQzKzJGaHFCbzNkUlVSRTEwQ2pwL0k2K1JjN3hudEVvdnBtekFp?=
 =?utf-8?B?eGp4NVBlK2ZUWTRZU2NmUVA1djNWVEhnUGVkclVQUitFTmhZUU5VdzBtRDcr?=
 =?utf-8?B?bU03d2JCWnhXNTNBdGJSVEdlemszeHpHQmpjaFNrOG1kem9SVHpEVDNxeVoz?=
 =?utf-8?B?OGRCRU1jU3B6cjcyUXNiT1BkWWhnK3pUQ0hKNEJlV2I5Z2cyaG1lem1icWV4?=
 =?utf-8?B?VHM0cU9NT2FhWUFveWRzZkRSOXpSMUNZeFNjZUkzRE5DWGJiOXFQaE9wVUNS?=
 =?utf-8?B?QnB3UkFQdkdtUzJlalBZQWpJRHJEK0IyTThXTEg4YS8wa2RMOU1EZldIVDdM?=
 =?utf-8?B?Ly9QRW5KdStDZGV3SEFyYlA2U1p5K2QydEFranFpQlpFa1ZRS1dZRm8vaFBK?=
 =?utf-8?B?anBNd1JwajlOZ1g0NmNvVVk0aWMraXUrbUlCSjdZQ2hVaE1CbFB3dkUyejZi?=
 =?utf-8?B?eVZOY1BjVm44N3lwTmtyY3Z0ajRCSXZJU2V5SDlSbEFWaE5kTUo4ZWcxbHNP?=
 =?utf-8?B?dmIwSXFYaEZWNXRHZ2NidHd1dGZQSHlHMkhheU50aUNJL1J1QmJXMi9lekE0?=
 =?utf-8?B?bHpUalpZLzNRWkxqSGRmYW9TWE03LzE3WmVCaitDeEV3OEY0OG1oRjJvZHdm?=
 =?utf-8?B?T2dGeUEyU0hadkpxTmNKV1pPSEV1cU9hWUNqVDA2czM1K3NlZ2VEVnoxSHNs?=
 =?utf-8?B?LzBWYXBNZGg2YUVKenZSTS9XWDZlSkdNUDY2Q0lMTXJlaDRBMi9McHFMODFM?=
 =?utf-8?B?QktSa2xLSGVQRW1FMnZucXhtS1djUEpGNS8ySGRCSGh2dFg5TnRhVGlzTGht?=
 =?utf-8?B?aVNuYXpwQkJFZlhPWTg5djE2V1RySlFRdm8rVUNNL1VqcnAycGhFT2xIQnJj?=
 =?utf-8?B?WThWRGNGcWgrcGFwMlRHN1NMemNjWlJ1RUNWWm4xTk9IWnZUbkZqRnVSVk9s?=
 =?utf-8?B?Z0VpWEVFdlMxVUpNaDMzdjg1OGU1VXE1bUFnaUpwVDZGcDIrbm1SMWtEZ3ht?=
 =?utf-8?B?RjhSM29aOVNJeUduTTJRdzk1SlJXcVNLeUpwdkd2Yys0S3Z1SmZVa3ZFVENj?=
 =?utf-8?B?ZzZjNWxHZlQraXJSRWoyUGMxUXZjcUl1MnVpcnZYd2J6LzQ3OU5COWQwUXMr?=
 =?utf-8?B?RHMwWlNYNUhFQVhkbVBCb1doN0VqNUhHdEJhdjAwOHRHUHpWb2kvSmtEMHAr?=
 =?utf-8?B?TGs1Z2l3VDFZZGkwNk5SbHFzekFFbEM2L1paSjJuQ2dpMmNJZFVVaUJDV0FC?=
 =?utf-8?B?SGc4NHhCMHU5Z1FtTmZqWG1BSU9WNEFNK1hIUnRJUzM2dFdlZE1RQ1dYT1RM?=
 =?utf-8?B?N3RUV2ExRFBsTy9rckw3M1I3VmMvOEczOWpYaU03WmpBQ3JLOHFzUW5UMVkr?=
 =?utf-8?B?OHphZkRpTmFCK3o0NElUQnZpb25uQlJBT3poWUwzT0dtazlKS3dDSTMwbUdL?=
 =?utf-8?B?ZUYzdDNYaGgxaWVGN1JOTm45VzkwZHZvMjdnc1pOQzZjTlcwRXFVdkR5dGx5?=
 =?utf-8?B?cnFnZ1V2eTJNV1UyU0xaT0xCRytUU1Q3dTFOSVBTWGJOOXpuS3JmYUR2ZG0v?=
 =?utf-8?B?NTBNS2I4ei81b2lndkswdVdWcnNPMDQ3Z2xMVm91VzJRQ2RTb3RGTnNGZHFj?=
 =?utf-8?B?Vm9uVFRNQ3R2cjBuQVAycGlONWVxMk41VkJVV1QyaXVVdlBlM2VHM2t5TkFV?=
 =?utf-8?B?Z3V4TGxJcDFiL1ZSWmpvUkFUTG9DenplMXZLOVZ3WkpoREpQalVoaS8wWXFH?=
 =?utf-8?B?Wk5mc2tUMDhKT29VaHIzNjRyNC9PdHhLckdqNUIzR3RwOTNjeHZSN2ZlcXd0?=
 =?utf-8?B?cFViWDVDVTNVYTVhRFZUVjV2MmxMUlNLUEVMVFhuQy9VMkVtUHZZeVdTZ0ZN?=
 =?utf-8?B?SnZ3N29PWStpZkRieWlGRS9uRnJsbHRzNnRtTmdhZ01qcnlIdUJhR2NYMWp5?=
 =?utf-8?Q?ufXMd0iBq5z5AQJ51Y+wCwEkd?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d3f44fe7-e2a8-4a9d-0d1f-08db8953c63c
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB2843.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Jul 2023 19:01:50.5480
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: VLA2eWH6/YLY8UfbOhc1Xe33OgkB80I6SZbFshOUEQjWFq2ScrC0qCL9GlMMqSw/gjHiLPRz8fHMcOax5VHztg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR12MB5899
X-Spam-Status: No, score=-1.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,NICE_REPLY_A,
        RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 30/6/23 16:52, Sean Christopherson wrote:
> On Fri, Jun 30, 2023, Alexey Kardashevskiy wrote:
>>
>>
>> On 24/6/23 00:19, Sean Christopherson wrote:
>>> On Fri, Jun 23, 2023, Alexey Kardashevskiy wrote:
>>>> Sean, do you want me to repost with "v6" in all patches or this will do?
>>>
>>> No need on my end.
>>
>> Cool. My colleagues are gently asking if this is any closer to getting
>> pulled or not just yet? :) Thanks,
> 
> Just looked through it.  A few nits, but nothing I can't fix when applying.  I'm
> planning on applying it for 6.6 (pending testing, etc.), though I'm out next week
> so it'll be a week or three before that actually happens.

Soo three it is :)


-- 
Alexey
