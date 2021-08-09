Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 531063E4D3C
	for <lists+kvm@lfdr.de>; Mon,  9 Aug 2021 21:43:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235450AbhHIToE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 9 Aug 2021 15:44:04 -0400
Received: from mail-co1nam11on2079.outbound.protection.outlook.com ([40.107.220.79]:17184
        "EHLO NAM11-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S235001AbhHIToD (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 9 Aug 2021 15:44:03 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=XSiVxQnS9Ias0WogVd9dcK0hL4UqDwgE9EULgzRwg5B8ACxaW+Uwiebv/Bd+57U+iVbqhVdE0MTjuqbhvizZN4RfhqbvGPR1GFuHyyGH0T12QzwW5/AZjhZaZRVJsxMqjE2xbLAwhJTX0c3MVbEf5mRkaDuilvB56e/4ev77uyTDkdiXLvCkXd/cYTHSm16Y82qLy311LHfts9tYwwQvYPD7aLs4LGA2zaQWtSU/pgiLNiI+PA3tCfqEp8OM2n3ovAML9Kl/AbGVFaW1ZBnrY/6Z59cqUm3QT48ZQDrpatpFA5SgViyoQiJAdzjrtPMsoljCs9MV6r0f18srPMHcNA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=98F/i4TT8gQkH10sU4cMWCNIH39I/qQQvB5ur3kX+b8=;
 b=A6mxPDZ7yHYHwHU47x1B+awY7RWVn/LCNlCMA9DhqBjQbVhRkEe24W2FUg6gN4R5BlJoIefBHdcLeS5dOZIVLKlVJJVS15gkQz8fyl+GfrDbnaYgFHZvQTXbg3nKaf2rCGNySdrjk0nhdsJV0kqnrKQ3USw+/w/n2StE7hxr5Km/ZAMzqHwrNVaDBMGf09ylM7gBQJuDKh2IJtPI/WvhbWMDIMD2o9wmokSUlJdLPc1Q+VzzHTTerCYATshF4jfpigSJbW/t+yk5srUyhSFmxs9JsIfgUAkAseqa0tDzI9lxpSeWVrqq0wnYTn5i7gBzw+xy3kcp0Ra9//4ZWBqWzg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=98F/i4TT8gQkH10sU4cMWCNIH39I/qQQvB5ur3kX+b8=;
 b=NhjsUI0cT4Iu5z58cQ/vk+2XXOukfkdjfK2Iyq5mgAu+TeFJ7wWb7WF3aZGGq0+FWktD4AGedQW1pNGATttY18+7VLJzHSMsNzwMXt/vx/UcEbXYLAzRQ+eZm5C3XMlLivRdi/D716WwZ4n2q+CaHVjNuzJ+uL8De8SEO1AILAk=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=amd.com;
Received: from MW3PR12MB4553.namprd12.prod.outlook.com (2603:10b6:303:2c::19)
 by MWHPR12MB1551.namprd12.prod.outlook.com (2603:10b6:301:9::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4394.15; Mon, 9 Aug
 2021 19:43:35 +0000
Received: from MW3PR12MB4553.namprd12.prod.outlook.com
 ([fe80::3987:37e5:4db7:944e]) by MW3PR12MB4553.namprd12.prod.outlook.com
 ([fe80::3987:37e5:4db7:944e%6]) with mapi id 15.20.4394.023; Mon, 9 Aug 2021
 19:43:35 +0000
Subject: Re: [kvm-unit-tests PATCH 1/2] x86: access: Fix timeout failure by
 limiting number of flag combinations
To:     Sean Christopherson <seanjc@google.com>
Cc:     pbonzini@redhat.com, thuth@redhat.com, drjones@redhat.com,
        kvm@vger.kernel.org
References: <162826604263.32391.7580736822527851972.stgit@bmoger-ubuntu>
 <162826611747.32391.16149996928851353357.stgit@bmoger-ubuntu>
 <YQ1pA9nN6DP0veQ1@google.com>
From:   Babu Moger <babu.moger@amd.com>
Message-ID: <1f30bd0f-da1b-2aa0-e0c8-76d3b5410bcd@amd.com>
Date:   Mon, 9 Aug 2021 14:43:33 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
In-Reply-To: <YQ1pA9nN6DP0veQ1@google.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SA0PR11CA0082.namprd11.prod.outlook.com
 (2603:10b6:806:d2::27) To MW3PR12MB4553.namprd12.prod.outlook.com
 (2603:10b6:303:2c::19)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [10.236.31.0] (165.204.77.1) by SA0PR11CA0082.namprd11.prod.outlook.com (2603:10b6:806:d2::27) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4394.15 via Frontend Transport; Mon, 9 Aug 2021 19:43:34 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 258aac2a-b0b8-4680-5725-08d95b6df9f8
X-MS-TrafficTypeDiagnostic: MWHPR12MB1551:
X-Microsoft-Antispam-PRVS: <MWHPR12MB1551C94101FD03B2954FC26395F69@MWHPR12MB1551.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: QqhnzlIL49yooyaA28OgRL6b39rnPKqgzh8mQ65/dKeuCYBWPmTVMoh8KdZZj60OrIhQ5Mo1Cyr9etOf6Le2iyg20EUu+XvwNC6pBcZL4fAgV6uua3n8aJG3IkO1tM5wnliQ2sIAD+UGb/YI82pIDYnVIfG/gy07mjgVcQy9+A3Z1mAVQGCqacfgU3DAvLxNXNZlsM7WfzgnIh1PXZR+aC0jIJaPX5rhrqulITVInZjELs0RZxqzPNcCOfeAp7X2AB2C3RlDvZx0FtxWqMYIvXW+pVcIqTljCiW5P8Oi+OtDHY+eifM2LHleEeiynu72PyNuD4lsbkBjwlhciYV+4EAstdkMEZ5kh2JfoZfGfDZs/iW9S0Akd9KABd2qdpjmmhFC1YOb0vvt77bH11/zmtR+VRNsLnXgZMCIUyHer/QBKnLBKjloifvwMbJX/Mo286xLrGekOjCag+/wystWUox6kSrm7Xqw/Hyhuf6V0nqzVXFFLDXlxYeLG4PW89NUdQklRX5P2SmMBXQX0qxH8yLlbP4vtFF3iSbf6JJy7LR2l7jdnlejOcXK/KXILahHpYfDR17Hpo6D9LnHfKhPlDkEJAn9Zf5AF45bikTNgofqMdeeCVh2aRvcRiOWM2ArZ/X7whM79gtGwZhonkm+wMpWIlO9gEfTW6AwOX/V1Qr0KxcepFK/3xjIA6ExrseW1sU/PT8Tf1+YGxyA9d93clzZdyCXMKq8MyygN+s1I8t5YcB21d1M0b9S9Vb9uN+QgTJLyE7ydMeeLoPYNMA3tg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW3PR12MB4553.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(31686004)(8936002)(2906002)(44832011)(36756003)(66556008)(956004)(66476007)(66946007)(2616005)(8676002)(6486002)(186003)(83380400001)(53546011)(26005)(6916009)(5660300002)(16576012)(86362001)(31696002)(316002)(38100700002)(38350700002)(4326008)(52116002)(508600001)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?QkZpeXFNd0VxZ3hTejJqaTcrbWtqUWhPVVk5TUFPeWVvS3dsM2xJR1dpL0lm?=
 =?utf-8?B?ZGFMci9iSDk3MGZ3SGhsdlBCckZFcXQ1WldaVDEvUXYyQmlPNHJLWG1CTnhn?=
 =?utf-8?B?UkVacDdxREJvQjF4WUdTTGJ5cy9VMFRTUVdGRUZZVEl1ZU9RQ1RtM3E3SjV5?=
 =?utf-8?B?QTlKRkpWRlhzajZjQmdKcWg1aUZkRndnZW4vdDBISU1zT0lFeGVJNEIxRXRY?=
 =?utf-8?B?aG9rU3ZGNE5jcURGSWQ3M1pxZjY0N0FxNXpEamI0RTdCaURZOGp6Y1ZwY0NL?=
 =?utf-8?B?MUFqWXFPa0w3YUFvaE9DK1FOZnBqS09FQkpMNjYzOTc3VWswbGh5cnJyVHFB?=
 =?utf-8?B?Y1IrYjlHcnltOUhGU29KUStubGoyNzVHZC8wTzRUZ0Yrblg1VlRTTUhqYVVZ?=
 =?utf-8?B?dmk2eVAyTTRabUNJUDdyVlBBSFMxQWtPSTRNdk9qNnIyREh6L2U2eSt5VTNC?=
 =?utf-8?B?NG11N0gzQjF2SlhQN1lXVllqVld0Y1dYQnRLdHFQY2diZm52MjJGdHVuck44?=
 =?utf-8?B?QTBqRzdYLzBHdHF2cVhaeHlHSWJBZisrVkhydzdUNUlWTGRZanJnMzZCa1Q2?=
 =?utf-8?B?TmR2Y2FqcEpLbjJzcjNSbW90Q09QZDdoTzFwK0gyNjJvbmlRQnZXb3pGNXFK?=
 =?utf-8?B?amNQMDZTdGduZ3lQVjFCN2tTd3QvQnFxVGhZWXc3SUNUZTlxM1plTVBiUWtW?=
 =?utf-8?B?N3pjTUIxcWZnam5wQ1dLT09JUWd3cXRxYWs5WXNlZHVRRVdCbE1ocHF0MkR5?=
 =?utf-8?B?VUJpN0MxRlU1L3N0MFNDWVpObEJJMkZxSElLRkJBM2UwUnhxTkh2QS92TGRr?=
 =?utf-8?B?S0owKzA4YmFFbUVETEhub2YrZSsvRnl4dmhjWEVDbWUvbDZtS0tFWWRBUldj?=
 =?utf-8?B?Vjk3cTlVTGg4SExpY2NZZG1CUmhRUU1hQkdDcXMvMEtSTHpvYnpnNW9rdjR4?=
 =?utf-8?B?b3FpTzQ2QjVRRHVQRFQ0aEVjOXhXa1BZb1pmYmt5TjZLUlhYMDNEMzJUeFRL?=
 =?utf-8?B?cDc5eXpDejlyV3BnUGIzd0RNaU9PSndiTU5qdHhXUjRjQ2thMTF2Y2ZuVUlh?=
 =?utf-8?B?YWZDMmJrdElBQjFuUGtwazZMaEg1VCtyOFkvMVNjbGlPdFIzcWY5WGhDSGk4?=
 =?utf-8?B?eHRxS1NpeHorNzUzTTNLSDloYU4rVEVLUS9tR1IvNXZtaVpCa3hOL1pnTGRu?=
 =?utf-8?B?NjR6MC9SYS9YNzlmTS9WcFBaNWZ2d2JLOGROVjFDTlM4c1FtUVR6RHAvNit4?=
 =?utf-8?B?REJOUGJOYmN6UUZwcUdPc1dvSytaVTgwRjJDQSthY3RMY2tYZkUxc0hHWUkr?=
 =?utf-8?B?UDZKSVJxdlgxRThLVmhBa3g5SkYxVnlHWFRockxPdm80SkZKYVkvbklGTGRI?=
 =?utf-8?B?UFFZL2d2RkJLQWNxMlY2b1JCa1NLNnhqL0czTnV4ZEFQZ0dHUGpjWGFtSVdH?=
 =?utf-8?B?emlBUm9vbnFhdURrb3RDSGszWVc4a0F3dVprQmJkVjhraE9jYkJQWDRrRjhQ?=
 =?utf-8?B?d2lpRGVoRndhclFZd0ZUdUdNTHhvNXVURWtZdGpoUWZvS1BneEdIZWRNNFp3?=
 =?utf-8?B?dHNob3E1VzNhRVN2QU9xc2J2QVNuNTVNUTU0Z2crUllNdi9UbHd3RlRYYklD?=
 =?utf-8?B?ZFROQzBKK3VCYk9OT3gzeDhNMW9uZDNiRkwwVExkeXYwREtHcW5OcjVaYVFv?=
 =?utf-8?B?Tm5SYzdEMVFUV1NRL1grWkJVbVJ3V05wazVPbEJZOTlmaXl1MCtxZFBzc09Z?=
 =?utf-8?Q?neiUhL8JB/iz7f+4JMmbGccNPf8GhvAwQSN/n6r?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 258aac2a-b0b8-4680-5725-08d95b6df9f8
X-MS-Exchange-CrossTenant-AuthSource: MW3PR12MB4553.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Aug 2021 19:43:35.4245
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 5s3EGXC2cAwLl/LdPlrAOVMi6B5z31EwivbLOInxGl3Y8Ti7pIzg7L9UyUV2ug+i
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR12MB1551
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 8/6/21 11:53 AM, Sean Christopherson wrote:
> On Fri, Aug 06, 2021, Babu Moger wrote:
>> From: Babu Moger <Babu.Moger@amd.com>
>>
>> The test ./x86/access fails with a timeout. This is due to the number test
>> combination. The test cases increase exponentially as the features get
>> enabled. The new machine adds the feature AC_CPU_CR4_PKE. The default
>> timeout is 180 seconds. Seen this problem both on AMD and Intel machines.
>>
>> #./tests/access
>> qemu-system-x86_64: terminating on signal 15 from pid 20050 (timeout)
>> FAIL access (timeout; duration=180)
>>
>> This test can take about 7 minutes without timeout.
>> time ./tests/access
>> 58982405 tests, 0 failures
>> PASS access
>>
>> real	7m10.063s
>> user	7m9.063s
>> sys	0m0.309s
>>
>> Fix the problem by adding few more limit checks.
> 
> Please state somewhere in the changelog what is actually being changed, and the
> actual effect of the change.  E.g.
> 
>   Disallow protection keys testcase in combination with reserved bit
>   testcasess to further limit the number of tests run to avoid timeouts on
>   systems with support for protection keys.
> 
>   Disallowing this combination reduces the total number of tests from
>   58982405 to <???>, and the runtime from ~7 minutes to <???>

Sure. Will do.
> 
>> Signed-off-by: Babu Moger <Babu.Moger@amd.com>
>> ---
>>  x86/access.c |    4 ++--
>>  1 file changed, 2 insertions(+), 2 deletions(-)
>>
>> diff --git a/x86/access.c b/x86/access.c
>> index 47807cc..e371dd5 100644
>> --- a/x86/access.c
>> +++ b/x86/access.c
>> @@ -317,9 +317,9 @@ static _Bool ac_test_legal(ac_test_t *at)
>>      /*
>>       * Shorten the test by avoiding testing too many reserved bit combinations
>>       */
>> -    if ((F(AC_PDE_BIT51) + F(AC_PDE_BIT36) + F(AC_PDE_BIT13)) > 1)
>> +    if ((F(AC_PDE_BIT51) + F(AC_PDE_BIT36) + F(AC_PDE_BIT13) + F(AC_CPU_CR4_PKE)) > 1)
>>          return false;
>> -    if ((F(AC_PTE_BIT51) + F(AC_PTE_BIT36)) > 1)
>> +    if ((F(AC_PTE_BIT51) + F(AC_PTE_BIT36) + F(AC_CPU_CR4_PKE)) > 1)
> 
> Why are protection keys the sacrifical lamb?  Simply because they're the newest?

Yes. I added it because it was new ):.
> 
> And before we start killing off arbitrary combinations, what about sharding the
> test so that testcases that depend on a specific CR0/CR4/EFER bit, i.e. trigger
> a VM-Exit when the configuration changes, are separate runs?  Being able to run
> a specific combination would also hopefully make it easier to debug issues as
> the user could specify which combo to run without having to modify the code and
> recompile.
> 
> That probably won't actually reduce the total run time, but it would make each
> run a separate test and give developers a warm fuzzy feeling that they're indeed
> making progress :-)
> 
> Not sure how this could be automagically expressed this in unittest.cfg though...

Let me investigate if we can do that fairly easy. Will let you know.
Thanks
Babu
> 
>>          return false;
>>  
>>      return true;
>>
