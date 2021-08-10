Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3BB2B3E869C
	for <lists+kvm@lfdr.de>; Wed, 11 Aug 2021 01:38:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235502AbhHJXiz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 10 Aug 2021 19:38:55 -0400
Received: from mail-bn8nam12on2079.outbound.protection.outlook.com ([40.107.237.79]:50432
        "EHLO NAM12-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S235493AbhHJXiy (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 10 Aug 2021 19:38:54 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ddIhOf69AWWIkXpntdUqV4Q3VZiXpz7MuzAZeGTV2jF9xMERRBsQh79PmwhV7cJzQW8J7pKLigYQx9YLgDGzVJwB7vHR7aa/LmuNCjynQ+WluzE7UtrrS8jXpD4us8NktHsjrYhlHNRfBNds3n9AmzfUl2uI0SlikzjvIGy8vILc35lChb7ioIXQePs3ivabkAGlDUz9XFTc2Op0H94/CQ7iXHJqia7qvGX3/ej2BHX8f+qF2PMHIxmqmH5Cqd6G/bqEyWNJSbiSxCIlOyuDuwZsb5RytOOeU1mi0sbvuq9zcheo7spw+X5KlPt4ja98NOme4HW+JWMZW8RlURqz6Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/sanUJvGYGJTvyWFa1Hq19fB3SmnVb+jsnlETSdvRVU=;
 b=j0F2+9u4z/5ORMxeDSnraCk0oXHc2K0ejoLVDuCZJXimbV4fmfbHnkDx5ueFe3wNf5gVrDqwrDq1tIVJPbjcuNgdn0amkkwNcy4Nrpv2dzTvs8Y7qb2LFaUqrajEgT8NPSjVwPwZEYMJ0rEeGI4GRmGItwNe48xbRTFlKA/PVSMdALY9vG6NfASpZiDcOuP8/uytJLpKG0apgHuvOKdozn4akFF4wvZCLAWhYNH5csydFlVYjOeIISs0G+Fv7e8rTBGstAmvLn6UEquLI3GhWv7nbGzXNGO8ujasXLuw4qEYU8XqjUpPKOIe042FDcrpNoUQ48RUu8VXNEA7RWCDJA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/sanUJvGYGJTvyWFa1Hq19fB3SmnVb+jsnlETSdvRVU=;
 b=e/j4RqZoxKLaaPDBESb8sl1Z+Yrq0zplXqueA2jpD6SCH01CwCfMwVoxRASyFPA5qoK6UjR9MzBOy/QJfRtzE7BoCm0y0QXw4P67mq9s3ig6ySiI/QVlotg30NIt0YYuhAU5UP//hC+sOWCrF93bTIda4l9RzGxGG1Y2WtXej4s=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=amd.com;
Received: from MW3PR12MB4553.namprd12.prod.outlook.com (2603:10b6:303:2c::19)
 by MWHPR12MB1502.namprd12.prod.outlook.com (2603:10b6:301:10::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4394.21; Tue, 10 Aug
 2021 23:38:29 +0000
Received: from MW3PR12MB4553.namprd12.prod.outlook.com
 ([fe80::3987:37e5:4db7:944e]) by MW3PR12MB4553.namprd12.prod.outlook.com
 ([fe80::3987:37e5:4db7:944e%6]) with mapi id 15.20.4394.023; Tue, 10 Aug 2021
 23:38:29 +0000
Subject: Re: [kvm-unit-tests PATCH 1/2] x86: access: Fix timeout failure by
 limiting number of flag combinations
From:   Babu Moger <babu.moger@amd.com>
To:     Sean Christopherson <seanjc@google.com>
Cc:     pbonzini@redhat.com, thuth@redhat.com, drjones@redhat.com,
        kvm@vger.kernel.org
References: <162826604263.32391.7580736822527851972.stgit@bmoger-ubuntu>
 <162826611747.32391.16149996928851353357.stgit@bmoger-ubuntu>
 <YQ1pA9nN6DP0veQ1@google.com> <1f30bd0f-da1b-2aa0-e0c8-76d3b5410bcd@amd.com>
 <7d0aa9b1-2eb7-8c89-9c2b-7712c5031aed@amd.com>
Message-ID: <4af3323d-90e9-38a0-f11a-f4e89d0c0b50@amd.com>
Date:   Tue, 10 Aug 2021 18:38:27 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
In-Reply-To: <7d0aa9b1-2eb7-8c89-9c2b-7712c5031aed@amd.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SN1PR12CA0108.namprd12.prod.outlook.com
 (2603:10b6:802:21::43) To MW3PR12MB4553.namprd12.prod.outlook.com
 (2603:10b6:303:2c::19)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [10.236.31.0] (165.204.77.1) by SN1PR12CA0108.namprd12.prod.outlook.com (2603:10b6:802:21::43) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4415.13 via Frontend Transport; Tue, 10 Aug 2021 23:38:28 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: f0d64813-0267-4dd0-1e0f-08d95c57f520
X-MS-TrafficTypeDiagnostic: MWHPR12MB1502:
X-Microsoft-Antispam-PRVS: <MWHPR12MB1502623DF429DF132BDA428D95F79@MWHPR12MB1502.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: UNeK4tdG3ov0ZP8qp/256ydpajRERqEKrR3kvj3sC3w1NSQqJuPT89QmPO/zSG944v5FPSkp/Ws/qFDR/GlVvv21x7u2OlP/6miZBP17pHZZ31Hfv5M8n02CVTljZHZbJMVB2RYm72cvBsD0E1xJ7jlbLRcqhls6EHEZh2Tfil8X3HT1Uod9MJS3R/qn+QCqTG7O51zQF2bB3ivDeGCLXeDCrNAsCdNw7seRiGdgptoBKtNh+waeu67XW9P8ifAVPk/iMvJnXkQ68o1+ug7Qzvsl4rA340vkX/+KLLisq8RQ8AHN/YHTcHqe4F3h0wpiSNlWLDh+tGZfG2wHuH6ZhSOFmd/qMvYtVn4m3LhTUFqT48sxn4f5fu0AD3JmNDAwfvFu0TPkRBOhXSofeqe6sshQcL5nmVowbijsuNH5UayQhEOqzT6H9Fo/ufCb4+rc5FK+p00FMq5lIFhq56WqLxlNMELrZI1SDXrCzRfr9XnoIIq+wtX/IGgTyNPO16a2fHRRJZ14aOhP0l0YJ8/im2B9KjZBS6B+bM8PVbfSTySvo72cCBuuQols7+lPJR0okasFwyIyEHcy7mNvitETlL5pKb21NhgRSBSqA4P55iBDO3DmALe3cw39zn03asXUEv13TCEx/qcoVREeim0px9fn5SGVaV0mFwkcCrU+EnidS7xNzvPSXuK2p6JoBgBXRIIjh41u57fAxl79Z7sIuz0SQXQCdyRfAAXAgC0LlYm/mTDcnaZ5Lx10BdyAIHRuyzQxsMQ0uVLqpWdUAIVRRA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW3PR12MB4553.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(136003)(346002)(39860400002)(376002)(366004)(396003)(8936002)(6486002)(2906002)(478600001)(4326008)(8676002)(66476007)(316002)(16576012)(66556008)(52116002)(956004)(53546011)(5660300002)(66946007)(38100700002)(38350700002)(6916009)(2616005)(31696002)(186003)(26005)(86362001)(31686004)(44832011)(36756003)(83380400001)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?QjVNZFFLOGVrSzk3ZFM5YjBlS0Naa084ek92dW8wcWVIeWFBMW5WelRxVGZT?=
 =?utf-8?B?dnV3WWRKcFc5V1E2R0xqNjI4eXNsVlpTZ1ZWMVdwRWU4UlRyZEJ1a2RZZ2VP?=
 =?utf-8?B?NDZHeXRMNUtXeXRTYVEvbVM2UUpWT0FpVDdvc1NNRU0xWEMzRGE4WmtiaEpL?=
 =?utf-8?B?SzdIdkJrajkyUHQ3dWdBT25YNHA2eHZnd1pCSTdvTWU5TE50N0JydHJkU2U5?=
 =?utf-8?B?Zi82cjRycTdKVVJBbUFDRElnSE1XYW5IV3J1aGpwK3ROQjZTVURqZDhmbmZN?=
 =?utf-8?B?anRWdCtuTEI2T1dHWXZILzZZUFBUY2k5QjBuUFFjY21OUjVhVGJwNHlyaTN4?=
 =?utf-8?B?bXZtcFhkZ1ZxQmNZRUZhNXM5YnRyRDRXODQvTEVnOForOVNiOTRoRndKcFlp?=
 =?utf-8?B?OUNUNC9MWGp6dmF0MDllUk9Ya254d29FNzVNUWE2OWU5c09CaDJ6cnU1bWFx?=
 =?utf-8?B?QTBoa1lBakpLOHpBYlJvbjZoK1drOW5yZi9zc2dLaW9iTUcwNVNNUnV2bGY1?=
 =?utf-8?B?emlqbURvWWpBOUxLQmR1RjM5ZEpBdlcvR2pmaG4yTis5dUNNUjNFQzFhZnJZ?=
 =?utf-8?B?cnUrUTcyTFQyWDF0SXJNeXJ2QngzTkVuaFJyY0U2OGwxUG5mN1pFYXAycHRZ?=
 =?utf-8?B?aXVzV3Bhdlc2UEoyZDNTMm5DRHFCZnN6L2R2NmlqMlFWZ2FzR2FNOXU3ODU5?=
 =?utf-8?B?MkxKZk14cDJEaS9tSkJNNDAzbWRqcjB2aXczckN6Rm9INWdXUkdLbzNSa1FO?=
 =?utf-8?B?aGl5amF5M2NKUDVQZ2lLNHlnY0lZTnQydHh3ZERnTHFoQVNIS08wcms1Z2d4?=
 =?utf-8?B?bHJZNUIrTTN1YXI3STRQS3ROdTNwUW56YzVTeS9hQ0h3UG9mRWUxWkZTSWRL?=
 =?utf-8?B?MlBmSXkydDZYS2JYbmQzalE0YXVkMjh0L2M5OGIrWUlMVUtJWWllL0R6blFJ?=
 =?utf-8?B?NW8yVEY3N0RhWExUL3M4aXFac3hubm05Y0RnaEdRcnZQaHc4Rk8yK1F6Nmg2?=
 =?utf-8?B?aGRpdGhYV0dmeTI3MEpSdktEOVVDYTJtcFRzT21qY3IwYWhpS3V5cHZBTm43?=
 =?utf-8?B?elViVzhNMTFtNlJJSk90bzdvdWNLTlVuMmxSU1ZtTGJSZWNwNlBJSVh4Wmpu?=
 =?utf-8?B?VnhpcVE0bnBXRHgzOXUrQnZWVW9WbllRSm9lUzk0U3lta3dpYlgra2VJajFX?=
 =?utf-8?B?cmtNdFZaY2I3VnYvMHFYNXBleGErK0FnbzBDa29ndzdwZ1dkaGpCb04yMVZH?=
 =?utf-8?B?dDkyb0wzZ3NvNlM2UGtmNVl1UGxjYkxFVTFqd0VWU1U2cGRKeWt1TzdTVGtK?=
 =?utf-8?B?VjVTdURTWDhYMUxZdWJDRWE2WStwNy9FZFg0RDBmcFlqdFFGV3pmcDIvTXQ4?=
 =?utf-8?B?VnY5bWx1QTVDMXA2UzAyMm1ES1J5QW85V1hIVWxUd1pmRzdKbkRyT211RW1u?=
 =?utf-8?B?Z2w5czloWkxMUW43dThXSExoT3A5WjRDZ0pzb251YmV4TjdoRmFYVjhqUWN1?=
 =?utf-8?B?MTVvNDQxeW9JOExIMi9wNDl2KzJkREV6U3l4aURXRnFoSmgwMzh4VFV6RGd2?=
 =?utf-8?B?ZFVIdDFEbkl2L1d1djIrZHR6ZjZLaU1yNlVBSWFKNi9YUnVGRWdHdjRWN0xO?=
 =?utf-8?B?S1pEWVUrSlpYcjJZNWZ2bDJ0ZXpKVm1HN1QxRmVNRFd1NXYxWTRBc2lQQW5v?=
 =?utf-8?B?VEx3YU00bS90R3dqMzF1MjZjWEF4aEZMOFU4UGZUNGxsTCtiQ3lDYjVDVW9O?=
 =?utf-8?Q?75rTi68haZPu8+MAiBQaQB5d8B3YJ58ATV7YMbe?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f0d64813-0267-4dd0-1e0f-08d95c57f520
X-MS-Exchange-CrossTenant-AuthSource: MW3PR12MB4553.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Aug 2021 23:38:29.7404
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 6cMnFVG1f/A6VErHmHu+5UXrPi9B5bTDBJAIW6f0hKIayOeKSqq7ZHznL8iqBg0o
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR12MB1502
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 8/10/21 11:59 AM, Babu Moger wrote:
> 
> 
> On 8/9/21 2:43 PM, Babu Moger wrote:
>>
>>
>> On 8/6/21 11:53 AM, Sean Christopherson wrote:
>>> On Fri, Aug 06, 2021, Babu Moger wrote:
>>>> From: Babu Moger <Babu.Moger@amd.com>
>>>>
>>>> The test ./x86/access fails with a timeout. This is due to the number test
>>>> combination. The test cases increase exponentially as the features get
>>>> enabled. The new machine adds the feature AC_CPU_CR4_PKE. The default
>>>> timeout is 180 seconds. Seen this problem both on AMD and Intel machines.
>>>>
>>>> #./tests/access
>>>> qemu-system-x86_64: terminating on signal 15 from pid 20050 (timeout)
>>>> FAIL access (timeout; duration=180)
>>>>
>>>> This test can take about 7 minutes without timeout.
>>>> time ./tests/access
>>>> 58982405 tests, 0 failures
>>>> PASS access
>>>>
>>>> real	7m10.063s
>>>> user	7m9.063s
>>>> sys	0m0.309s
>>>>
>>>> Fix the problem by adding few more limit checks.
>>>
>>> Please state somewhere in the changelog what is actually being changed, and the
>>> actual effect of the change.  E.g.
>>>
>>>   Disallow protection keys testcase in combination with reserved bit
>>>   testcasess to further limit the number of tests run to avoid timeouts on
>>>   systems with support for protection keys.
>>>
>>>   Disallowing this combination reduces the total number of tests from
>>>   58982405 to <???>, and the runtime from ~7 minutes to <???>
>>
>> Sure. Will do.
>>>
>>>> Signed-off-by: Babu Moger <Babu.Moger@amd.com>
>>>> ---
>>>>  x86/access.c |    4 ++--
>>>>  1 file changed, 2 insertions(+), 2 deletions(-)
>>>>
>>>> diff --git a/x86/access.c b/x86/access.c
>>>> index 47807cc..e371dd5 100644
>>>> --- a/x86/access.c
>>>> +++ b/x86/access.c
>>>> @@ -317,9 +317,9 @@ static _Bool ac_test_legal(ac_test_t *at)
>>>>      /*
>>>>       * Shorten the test by avoiding testing too many reserved bit combinations
>>>>       */
>>>> -    if ((F(AC_PDE_BIT51) + F(AC_PDE_BIT36) + F(AC_PDE_BIT13)) > 1)
>>>> +    if ((F(AC_PDE_BIT51) + F(AC_PDE_BIT36) + F(AC_PDE_BIT13) + F(AC_CPU_CR4_PKE)) > 1)
>>>>          return false;
>>>> -    if ((F(AC_PTE_BIT51) + F(AC_PTE_BIT36)) > 1)
>>>> +    if ((F(AC_PTE_BIT51) + F(AC_PTE_BIT36) + F(AC_CPU_CR4_PKE)) > 1)
>>>
>>> Why are protection keys the sacrifical lamb?  Simply because they're the newest?
>>
>> Yes. I added it because it was new ):.
>>>
>>> And before we start killing off arbitrary combinations, what about sharding the
>>> test so that testcases that depend on a specific CR0/CR4/EFER bit, i.e. trigger
>>> a VM-Exit when the configuration changes, are separate runs?  Being able to run
>>> a specific combination would also hopefully make it easier to debug issues as
>>> the user could specify which combo to run without having to modify the code and
>>> recompile.
>>>
>>> That probably won't actually reduce the total run time, but it would make each
>>> run a separate test and give developers a warm fuzzy feeling that they're indeed
>>> making progress :-)
>>>
>>> Not sure how this could be automagically expressed this in unittest.cfg though...
> 
> As we know now that we cannot run a huge number of tests without running
> into timeout, I was thinking of adding a extra parameter "max_runs" for
> these tests and add a check in ac_test_run to limit the number of runs.
> The max_runs will be set to default 10000000. But it can be changed in
> unittests.cfg. Something like this.
> 
> [access]
>  file = access.flat
>  arch = x86_64
> -extra_params = -cpu max
> +extra_params = -cpu max -append 10000000

No. This will not work. The PKU feature flag is bit 30. That is 2^30
iterations to cover the tests for this feature. Looks like I need to split
the tests into PKU and non PKU tests. For PKU tests I may need to change
the bump frequency (in ac_test_bump_one) to much higher value. Right now,
it is 1. Let me try that,

>  timeout = 180
> 
> Thoughts?
> 
>>
>> Let me investigate if we can do that fairly easy. Will let you know.
>> Thanks
>> Babu
>>>
>>>>          return false;
>>>>  
>>>>      return true;
>>>>
