Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8FC8F3E963F
	for <lists+kvm@lfdr.de>; Wed, 11 Aug 2021 18:43:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229588AbhHKQna (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 11 Aug 2021 12:43:30 -0400
Received: from mail-mw2nam10on2047.outbound.protection.outlook.com ([40.107.94.47]:11341
        "EHLO NAM10-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229484AbhHKQn2 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 11 Aug 2021 12:43:28 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=PjDKIadq33PTCSH2wHiPHMILDI+mMce28VQrSogcdw37AlBs2iueKwdwpx9JCnXHI9fxLmK/K75FUlNX5T+AQdJEOMlesUS9wS5edO0LjQ6GXi2USawweBtdOOeXMZhyTxQyKJPnBRbXc1S5m+0prOCgGZBaoO2P47+QK9Xyd7mQl/C07RpDy9qnxgJZ/J0AtXNunADKqhzBPY1j9crXEocMvKb2UFKmk+2P6ogcEz4lUyG+5aDnCLWWeuA7csseycV77D8tX0jOY8gD7REySjDvEfWeYtojtfvtJiXRk10MBoDg4FJbzl6V3XxTrz+wpUVDH913InzpnS340Y+/jg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Ujtc8AWZhbRkVpD9LQ7zVyUfgXSewG7NdbZqXai3I9c=;
 b=gUbsMFd2f9Aspl+2NrhTkjVSnLkecqo72Tkcq2zX5hIL2Q0/IqdeJy280dqmrJV4ZvNwL8x4C+xLVBunS2D4xk+ngVVbGuNy8TxLW8KdC5kGlW1bJ9KCdrXm3Cyi25CGP0C6yIq9YvVl5GcKUzt8GN30yWL11reEwfS3PbqicISvXf5iI1D2oEtSIFtNx4pslE2SXTxrFCH2A75cK7j7NlVvpRzORkr6X2IoGakY/BTOMlRsXtpuWiYF4mfjU8azsxyc5uuD3tHABnGPweURU+6IIdwK+lpnoasibNjE2bTZWKdaJKid43pU/l8A8P1Ihy28y7DnjWxMPvdIHSkF3g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Ujtc8AWZhbRkVpD9LQ7zVyUfgXSewG7NdbZqXai3I9c=;
 b=4/yM+rq9SNij77iJkVgVAwC312gTP7lCqTjooXabMejNHsFDHWI2lJfUYkJvjYZSlxiiFJTagsWRpLeara1+zSmjMLpkQxuNTA+CMUSq8iKJksFMj/1V2LAnvKzwTv1xdQewrfINXls2+jikWiD7JlEebI0L/TUfslU8CvMKZUE=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=amd.com;
Received: from MW3PR12MB4553.namprd12.prod.outlook.com (2603:10b6:303:2c::19)
 by MW3PR12MB4556.namprd12.prod.outlook.com (2603:10b6:303:52::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4415.16; Wed, 11 Aug
 2021 16:43:03 +0000
Received: from MW3PR12MB4553.namprd12.prod.outlook.com
 ([fe80::3987:37e5:4db7:944e]) by MW3PR12MB4553.namprd12.prod.outlook.com
 ([fe80::3987:37e5:4db7:944e%6]) with mapi id 15.20.4394.026; Wed, 11 Aug 2021
 16:43:02 +0000
Subject: Re: [kvm-unit-tests PATCH 1/2] x86: access: Fix timeout failure by
 limiting number of flag combinations
To:     Sean Christopherson <seanjc@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, thuth@redhat.com,
        drjones@redhat.com, kvm@vger.kernel.org
References: <162826604263.32391.7580736822527851972.stgit@bmoger-ubuntu>
 <162826611747.32391.16149996928851353357.stgit@bmoger-ubuntu>
 <YQ1pA9nN6DP0veQ1@google.com> <1f30bd0f-da1b-2aa0-e0c8-76d3b5410bcd@amd.com>
 <7d0aa9b1-2eb7-8c89-9c2b-7712c5031aed@amd.com>
 <4af3323d-90e9-38a0-f11a-f4e89d0c0b50@amd.com>
 <b348c0f6-70fa-053f-86fa-8284b7bc33a4@redhat.com>
 <29220431-5b08-9419-636e-d4331648aed1@amd.com> <YRP3HxfCRMQBt2Ty@google.com>
From:   Babu Moger <babu.moger@amd.com>
Message-ID: <961c43ff-9043-5033-d461-cf81f40fc8d3@amd.com>
Date:   Wed, 11 Aug 2021 11:43:01 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
In-Reply-To: <YRP3HxfCRMQBt2Ty@google.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SA9PR13CA0090.namprd13.prod.outlook.com
 (2603:10b6:806:23::35) To MW3PR12MB4553.namprd12.prod.outlook.com
 (2603:10b6:303:2c::19)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [10.236.31.0] (165.204.77.1) by SA9PR13CA0090.namprd13.prod.outlook.com (2603:10b6:806:23::35) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4436.8 via Frontend Transport; Wed, 11 Aug 2021 16:43:02 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 4125f809-a5e5-418e-dbc8-08d95ce71612
X-MS-TrafficTypeDiagnostic: MW3PR12MB4556:
X-Microsoft-Antispam-PRVS: <MW3PR12MB455629FAEC09569F59A5607295F89@MW3PR12MB4556.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7691;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 82+umPCXxuBJVjddtc3df2oEpmfOEiwHuWj4VrakMkdEi6l6RKsOAwKthVAJCmMW0DhSl1lXyvkWZp1bLZSz8SMP2cxhu6fe6SsH4Y5ipyYbiXZl00h2PGubFrUKFoXsEtpD6ylcqg+SA4EPTo5J6hEohraO3ZzS97quTmZRUqF5ZD5dsNNrdXBk2MwFk75CW3xuwZ77CcXfcJaiYKMUPo4Y1oTzUeVNCNJfMtDaHAoKdJONR88R9+VmL/RClfJK0a00uoxI4Ek++L2JNBUpiGLI6lwPmflkENVtvrXFIJuJqwdgQWf5LGl7JhKEDKdXtF4vCIwBtEpOGmz/uFSrOEk7Lo2xfok69BajfjDctYNdLA1mqSJPgIGZ0d76mpfjyoQHJjBfxv6b3/EAJKYj+TkZzvah3QZ/gCJZu1WUq9QY96wWQairR3mNq6gJ6qszbevOxhHVpg7G6oGaukShvRgQFj5LQzop3tyLdmraUmRHlA/sRRXtqJMwnEav+gFX+Odrw6Uw7MyXsjzqLpvogd+VOUTgVQlqHZO8yUkqLcXD9ngIdvr3tfO4UczHJvbyWOPt2XiMAIelC4TMHKOYdo5Mt2LX0gKgazu68HQCDwumCdNhCiawcvbGnbd+rIvl6lwKSFdVyft7gk/L2oq6fyGs3apVhuTKWAMXu97XrTX3lfXq9bt8KyyZnovG5lncvS/GTDQ0SYmZ/3UAu0eUG0lk8+NBGiSr4aoNDmT61xRS7kTjZpCi1JI5r7hgXgZUmasqz6/pNIZLiVYscyCcjw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW3PR12MB4553.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(39860400002)(376002)(346002)(136003)(366004)(396003)(16576012)(8936002)(316002)(38350700002)(38100700002)(2616005)(956004)(2906002)(478600001)(6916009)(53546011)(44832011)(5660300002)(26005)(8676002)(52116002)(36756003)(83380400001)(186003)(66476007)(86362001)(66556008)(66946007)(31696002)(6486002)(31686004)(4326008)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?T1FBRWprM0RCa3JZZVd1OEljekdteFBkMVVYc2JHbVpvdmJWZkZGUWVwRlRF?=
 =?utf-8?B?ak9VUkJXcmk3NTFpWFIyWFJkTmNzdGMwcHUrY1ZHYWVYckRNSnJPSXpBMTd6?=
 =?utf-8?B?UTc4UnlTWmpUVndSMHZNUmt2b2tURmVmclYzN2xrcGR6QWVhSHozeWRZYXFO?=
 =?utf-8?B?b05lUit1Y3hicG1jQ01kZTJrQVEwdTMvMWUvdWxvSXM3Wi9JOUJYb2dnUXZk?=
 =?utf-8?B?WDNacFBOL2dnMUVNbk1JeXdPOWt0ZSsxRlJNUTQvWXpKaUdkMmpBcUpyVEs0?=
 =?utf-8?B?R3orM2tVVWQ1R3E3L0k1SUlWTjhGcDRvMk1pZlNBM1o4cFMwNk9WTCs5dGto?=
 =?utf-8?B?Q1hGQVdKc2xRTlRFNVhOclNqSG5SLzZ4OUcwUGxWQTNFdEM5M3g2akV1UlV6?=
 =?utf-8?B?WGtPOEtpcU1IcUQ4U0h1WEJ3a3dwdWRxbEc0RmJhL3VYckI4R2RNZGJBZ1R3?=
 =?utf-8?B?VlVqdkxndFo5Y204M2YwaitmS01EYityRUV1OWVFSU9xclV2YXhQUW9mbkZi?=
 =?utf-8?B?MEtsVG5pOFNlbUNoQjVzRlBIN2lPRzdvMnFLNzJJMzUvYlB0N1ZsUEllMDFv?=
 =?utf-8?B?S0czalo5VE95MWxGTHV6TUtPV01Qcm5ORnNGd1B4OW1CS3BQeVF1cFlZaDZW?=
 =?utf-8?B?TzlLcGNrMnNHZldUOHVPV3ZPWmJTcUx1Wkd5UEJ2akNZU0NtZTFaM2tHc1pw?=
 =?utf-8?B?ZllZc0phejg2eXpFSjhxVHIrOGZNTlo2UzJmRDFJRVZnbnZsUnM3TWZxSkhT?=
 =?utf-8?B?OVZ5d2lDd2pNVFJhTjFMVlJpTEdYdHRVM3U0eFVPZEJCREM2TXc5aUluK2pV?=
 =?utf-8?B?RksxVVYwaHN1ZVJyV2t6NlZISUpTNUxyL2piRm5LVnEwTVZxT0szek11WHZS?=
 =?utf-8?B?b0o3TklSTDFWVFNkaFphZEpmbVFOeENEZVdPYTFxV3pvVk1pb0pTSll2NDk2?=
 =?utf-8?B?amVkNks5S3dkNUFMQjQwMTVnTW9sTVMxZUNWQ1JabjdTREJpYVh2UnFWZEth?=
 =?utf-8?B?UnBJZ0M5cG1qbTVPZnF1U1lsRXJuMUl1elNlRjMvRUl5VW8rRmIrSHU2S3J4?=
 =?utf-8?B?MkRhTkFqSzU4NFF4bEJOMjBZT1BZbVBBMitlZ2tpUGlZOTFqOVB2M1ZjSHFt?=
 =?utf-8?B?YXFzUTcrN1JkSEg1aDJ2UDluUG5Sa1pLbEg4SEVVcWdsM1hTWm5PZVJ0V1Z3?=
 =?utf-8?B?clZJbi8raW0ydUduTnhjOW5mS1E3WkVoOU0xcHAxS1ptVVFzR0ZUR0lsdzY4?=
 =?utf-8?B?VDVrWGJ5emh4N1JuTkFIUVFLNS80cmhYRnNOenpjQXp2bFp6aXFUd2RpSFJL?=
 =?utf-8?B?aWVkNEluMHJ2KzdJcnYrMlNTU2s3M21QcUdXZDR3VTlEalpxOUJPOHZodFBr?=
 =?utf-8?B?SlNEMm9Kd3dSSEphb2JDL2lzakplOUk4L2JMOFFhUDJBTjFINUp2cU41eDlp?=
 =?utf-8?B?THYxbWZHR3ZnVDFrRXF5QTllV3c3YkJXMXN2NmFzYnRXN3p2TkVKVFBnRGtP?=
 =?utf-8?B?Y2IrZ1VSNlE3aEtReXVYOG4yUDBUdXFsaERvTHdoZzJwdE41dHlmL1dmR2FZ?=
 =?utf-8?B?WjRiZWxMNVM2ZjdmZFF1UWxUZzhHaFhRUmMyanJSL0RPVytWUVl2UWU1Q05L?=
 =?utf-8?B?aEhOM1FhQzFDbVU0Y1lLK2lzMDNRY1ArY2FyT1FOUm14bUxITG8raXRZak0y?=
 =?utf-8?B?d1hKNFJwOXVxQ1I1RXJYQVNyRE9Qc0l6THJjRkpNNTY1NzZWWmh2QkxsbzNP?=
 =?utf-8?Q?+S/jhhnOP+KLUGwF+cljrRw0CkxECYAXy0JB9h7?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4125f809-a5e5-418e-dbc8-08d95ce71612
X-MS-Exchange-CrossTenant-AuthSource: MW3PR12MB4553.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Aug 2021 16:43:02.8356
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: v2PFJxwDf2EM17lHSCftWNebKoGGSIE00mvNgMHYj8jd3vh1eynUiJIQfWF+7pMm
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW3PR12MB4556
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 8/11/21 11:13 AM, Sean Christopherson wrote:
> On Wed, Aug 11, 2021, Babu Moger wrote:
>>
>> On 8/11/21 2:09 AM, Paolo Bonzini wrote:
>>> On 11/08/21 01:38, Babu Moger wrote:
>>>> No. This will not work. The PKU feature flag is bit 30. That is 2^30
>>>> iterations to cover the tests for this feature. Looks like I need to split
>>>> the tests into PKU and non PKU tests. For PKU tests I may need to change
>>>> the bump frequency (in ac_test_bump_one) to much higher value. Right now,
>>>> it is 1. Let me try that,
>>>
>>> The simplest way to cut on tests, which is actually similar to this patch,
>>> would be:
>>>
>>> - do not try all combinations of PTE access bits when reserved bits are set
>>>
>>> - do not try combinations with more than one reserved bit set
>>
>> Did you mean this? Just doing this reduces the combination by huge number.
>> I don't need to add your first PTE access combinations.
>>
>> diff --git a/x86/access.c b/x86/access.c
>> index 47807cc..a730b6b 100644
>> --- a/x86/access.c
>> +++ b/x86/access.c
>> @@ -317,9 +317,7 @@ static _Bool ac_test_legal(ac_test_t *at)
>>      /*
>>       * Shorten the test by avoiding testing too many reserved bit
>> combinations
>>       */
>> -    if ((F(AC_PDE_BIT51) + F(AC_PDE_BIT36) + F(AC_PDE_BIT13)) > 1)
>> -        return false;
>> -    if ((F(AC_PTE_BIT51) + F(AC_PTE_BIT36)) > 1)
>> +    if ((F(AC_PDE_BIT51) + F(AC_PDE_BIT36) + F(AC_PDE_BIT13) +
>> F(AC_PTE_BIT51) + F(AC_PTE_BIT36)) > 1)
>>          return false;
>>
>>      return true;
> 
> Looks good to me, is it sufficient to keep the overall runtime sane?.  And maybe

It keeps the running time about 2 minutes.

> update the comment too, e.g. something like
> 
> 	/*
> 	 * Skip testing multiple reserved bits to shorten the test.  Reserved
> 	 * bit page faults are terminal and multiple reserved bits do not affect
> 	 * the error code; the odds of a KVM bug are super low, and the odds of
> 	 * actually being able to detect a bug are even lower.
> 	 */
> 

Sure. Will update the commit log.
Thanks
Babu
