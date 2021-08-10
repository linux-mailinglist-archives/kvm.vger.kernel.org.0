Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B5EC93E7DE2
	for <lists+kvm@lfdr.de>; Tue, 10 Aug 2021 18:59:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229679AbhHJRAF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 10 Aug 2021 13:00:05 -0400
Received: from mail-dm6nam10on2081.outbound.protection.outlook.com ([40.107.93.81]:39360
        "EHLO NAM10-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229474AbhHJRAE (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 10 Aug 2021 13:00:04 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=XgvZ+W1gDdH3p3lDpbQNqlV+cx9v1PmFNjMkEjbWl4A6NcFLAKoxigcQsQ5ZNOm96onnxYpt87USYa3bmkwtpNSJLOUl+BJclI/KkavPA0oxCJGQ1dl+h0sOiztXx0NcyckOy6DX1+We9GY3zQXtMVnoIrplcIBe2MGJG7U03nNJCdMEAjyA7I0YHDHqZ8g2tMH0i6dvjp5q3O7LxEh1PG2i0eyrVqh+6H+0EyePS1NZqHgiUKg58LFxnw7++wVErXpEF+iAz9de45ggAzBJoif/BGXcK1VG7TWVi0yuGDXyL9Hmy6hY0K5f8scz/T36cq10Crbmg9DKxuLAbmnp+g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fOCmh5IWwOhmGvv1ZS9RxdG5YCRqjdS+uS4Z/hoL088=;
 b=Ibefb26SX/2BJqIKvlLSxU8SdB33Hv2hGDthi0fGk6P5m33itnwR0Itx8EPazAKOhzK/aesXcesJSOMeBvNCpFg/SuJ7POgF6C4FcL53AeeU2uq8ItSMUgsjFB+Mnnubzg6mhtzWzL3LNz5Rgtw1wHad074hMMqV4b+oc/UuyW/Ctm+Q8PPqpb1Xq8MWJlIPhpsuV4LqVbYJj8XKb1pPpOOzQq2E1+M1K9+SPHoo3izUI+msBGV0UaLrF4oVvdQZPrhs9BgReAP1pGZT14o1xvH8zdQCcxSms7aPYvgSVzejyC2hMNP9DGzkjvHQI4eyBRUczokzz3BY2z5XZmNSzQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fOCmh5IWwOhmGvv1ZS9RxdG5YCRqjdS+uS4Z/hoL088=;
 b=JnNwAFDEzgSBLW3TaaHuVaCAUSZ7Ojf3tAGJJ/H4SNVjF4UgVtil6gY1U94u6JCn0HQo6O5LrZ6Kwh/vtx6ygJDBeQ4vgPGZAEmKG9eEpPMMwZMx2Wm9GxkSG3OFQIGaSrf5ywYhZM8f765Gzhz80urFa2WkHVZL7F+AgNlh/NI=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=amd.com;
Received: from MW3PR12MB4553.namprd12.prod.outlook.com (2603:10b6:303:2c::19)
 by MW2PR12MB2539.namprd12.prod.outlook.com (2603:10b6:907:9::30) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4394.20; Tue, 10 Aug
 2021 16:59:40 +0000
Received: from MW3PR12MB4553.namprd12.prod.outlook.com
 ([fe80::3987:37e5:4db7:944e]) by MW3PR12MB4553.namprd12.prod.outlook.com
 ([fe80::3987:37e5:4db7:944e%6]) with mapi id 15.20.4394.023; Tue, 10 Aug 2021
 16:59:40 +0000
Subject: Re: [kvm-unit-tests PATCH 1/2] x86: access: Fix timeout failure by
 limiting number of flag combinations
From:   Babu Moger <babu.moger@amd.com>
To:     Sean Christopherson <seanjc@google.com>
Cc:     pbonzini@redhat.com, thuth@redhat.com, drjones@redhat.com,
        kvm@vger.kernel.org
References: <162826604263.32391.7580736822527851972.stgit@bmoger-ubuntu>
 <162826611747.32391.16149996928851353357.stgit@bmoger-ubuntu>
 <YQ1pA9nN6DP0veQ1@google.com> <1f30bd0f-da1b-2aa0-e0c8-76d3b5410bcd@amd.com>
Message-ID: <7d0aa9b1-2eb7-8c89-9c2b-7712c5031aed@amd.com>
Date:   Tue, 10 Aug 2021 11:59:38 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
In-Reply-To: <1f30bd0f-da1b-2aa0-e0c8-76d3b5410bcd@amd.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SA0PR11CA0130.namprd11.prod.outlook.com
 (2603:10b6:806:131::15) To MW3PR12MB4553.namprd12.prod.outlook.com
 (2603:10b6:303:2c::19)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [10.236.31.0] (165.204.77.1) by SA0PR11CA0130.namprd11.prod.outlook.com (2603:10b6:806:131::15) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4415.13 via Frontend Transport; Tue, 10 Aug 2021 16:59:39 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: c144116d-dd1c-4009-ed37-08d95c203e52
X-MS-TrafficTypeDiagnostic: MW2PR12MB2539:
X-Microsoft-Antispam-PRVS: <MW2PR12MB2539D288BAF490012593A18195F79@MW2PR12MB2539.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: DW/HlepEFInEFvMytQtDScy3g8L7rBTeGGSVMQscOYgpCqyiu68jDl2lirIKdbolth7jzKzfBxOZh+lCPpHcvaPxIHVWQGUOIfAlRhLBC0ujqHrstMpk4l5JHvvtIbF/96C4g6EQCmrZBIgst62dSAaJwxrnNLY1ptlA+VQB8Lbw48HopK2yHDBl9pGuquuS6wVO5ezdd0yxIvn9rGXApf3c2lZ9NLH3vM3WgbDsPE1u34XUAV0XOs99/2QKGs7wriwLMNTOIjj5xHe0djKJQibCKGxv0Ukx4BEF1ZqH1+8AlkXzvHDVovZ2GL0IiyP8k4RK3RDeouc1J2VmcDSjvsuuv+NiiQuGJYp5ALT7xhJXwZTOtBTW8yXdQIDsp0YCgK+hSbAr3O9pTVWySxNGa2X0mvXs2TCGDnVpjSg4JfOpSM2zTBans372YmUIFfqSEkj7BV3XqVcSwaco/fZjjnW7+IUJdQ2eLgZa+GhSEiCT/Kupe46owalCQGB77yeLgvlSael3c7dBBAXIIfHyASFYeYT4vp0WyYDQ1H/al7cGBCv2tqOoB3sjH25UfLfYpWzhPobjYfFAJnG9/ZVyfvQQPQ2sj5nNI+sbGKlPp6elsD+XduzzfF19Ac+PteGgSDiQg4DVBvUr/3n6GAIHuVz8hADn76oKGx8sK11Ll1bHNV3j7uxJQer2hEhxfOH9YlaCTp7WTVnPzsTEEvyMntaGDABXR+RH4oYgjAU+KNlXPHohiQtNfRjbavd28lKIIjNkq8Q/PqFWTtZu6zvaWA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW3PR12MB4553.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(136003)(376002)(39860400002)(396003)(346002)(366004)(53546011)(52116002)(26005)(8676002)(2906002)(31686004)(38350700002)(38100700002)(31696002)(8936002)(316002)(16576012)(86362001)(36756003)(66556008)(66476007)(83380400001)(4326008)(2616005)(956004)(6486002)(66946007)(44832011)(5660300002)(186003)(478600001)(6916009)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?VmhDVEsrTkluQThDa1NnWGFYYVdQL0czOUVBSjM0SWJQK0FyTk0wQ2cxRkhY?=
 =?utf-8?B?Mm4vUWlNNTNua2tHOEd1Sk12KzJUN0JuTEp4dktwOGhDa21LaUtFeXQrNVN2?=
 =?utf-8?B?c1pKMko5b1E2ajdZSFovaW42VzNCcDdnQXdwd0VuVVVXZDNLdjFBbzEzeEMy?=
 =?utf-8?B?V1FpcVhTUVlQbitkUHRwcHdWYzRDbk5PQ2FnVUdIZ0xEbGp2dGx4S00zME0z?=
 =?utf-8?B?Q29GVDVSRnk0VE9waXA2Y3FxWmtYME9KcnBKZUQ2bTA3dzA1a3VQYnIzME9j?=
 =?utf-8?B?SElzSEd0RnNjSWdLVW5ZT3BJQzgrOGtKaGZ4R2pIb1JYd2JHaHB1KzdsSlVY?=
 =?utf-8?B?K0FtRnR3c2phbVBVdnNyK1JNTlJMNlc3akQrVVJObkt6SkhJKy94cFY0MEx0?=
 =?utf-8?B?M2dHSWNlS29EZWZYQk9uMHVEYmdqSUVvMHRCb3gzYWx3K3dCQitaYzRUcVMr?=
 =?utf-8?B?VU5PZnJLZW9heWFSNXFYbnk3RmtBblEvRTlKTURNNnZDTjdMZklEMW9tZnhI?=
 =?utf-8?B?RVVKU3Y2WjE3a2NkaFhWSFpIVm5rZTlueDU0bm1nTjA1em1YTGhPbklRYjdz?=
 =?utf-8?B?c245R01BRUZ2TWlSc0R4NUNaVDMrUlpaRnpDOFpLN2pNSzRESkFpTWFFZHpj?=
 =?utf-8?B?bHJ4K3g0dU5ja0lwdGFneGdXNkkvRjQ1bWJEa1V5aWVkTnFRelRWTUt1RitI?=
 =?utf-8?B?bEJlTTRZMFZVcGFzZFVpQTJMNzluejY2SWVMR1VBcHVsM1QwM0wySDJaYkRa?=
 =?utf-8?B?RHJHalZoN2ZoYmdoQkt4Mjh1UGsyMEwvenNESlI0ejlaanVUcWpxVEFTTFBu?=
 =?utf-8?B?R1Q3ODF3bXN3NWR6bWZtS2FUbkpaOFBoT2lYaVJ1VUtqUnZ1OEEvQ1loK1lP?=
 =?utf-8?B?aWhvYjJMZ3pOMHZRdmFTdTdONnE1SkNvRTFLK1MvdmdNOVhCMjZxSmRHWE82?=
 =?utf-8?B?dGtFcEJNcFFWVWhmZndyMFRYUTYvTDhSVDNoRkZocGgxTjhSUStXcWNyVjdI?=
 =?utf-8?B?aEh4K0Jham9FNEExYUdwVmlkMXNaR0dpZ2JyTkd3MGg1WlV4K2JFWjlDT3lH?=
 =?utf-8?B?aThzYm8vbklaMmE0UjcvelpNNmJCQnRWWVcvWDNNZlB5KzZPWklYTDRodkdO?=
 =?utf-8?B?NGpjbXJSVjdQbkZZdVZCdllvanpnU0ZFLzdrL0ZzZXVWT0pET3M2OG81RHdo?=
 =?utf-8?B?SlAvQVRFTmpYelBCRzAySWZNNXFHU2pjeWdEaXJRMjVlN2dZaGxrSmg5a3po?=
 =?utf-8?B?ZjgycFpNd2FaSG9IRGQ1a0VwZlpOM004SUpNQXMrVWI5dFB3ZW5QWWVrNU8w?=
 =?utf-8?B?aWlMenhDOWxDK3lKZGV2SWROb3YzcFhlc0dvbnVtL2FBd1FrYjNIemNvMk1y?=
 =?utf-8?B?bEo3M1ozMFRrQ2N0ZlpIUDBWL2lTZUppRnhIcEs1YUJlWlhwSGtmZE9QYTIr?=
 =?utf-8?B?NW1OcXlaTExvYjNUaUdPU1pIY3pjODVtNjlYUUtOUDU2bFRjWXV4VjRvbGJ1?=
 =?utf-8?B?NFkrTjJGU0hYcW5wWFRaUWwrMVZjeDJlaC8vRm45dGFnT3FsZ1VyUjI0eVZE?=
 =?utf-8?B?bDRNUDc5K2JwOHFRaGJTL0lmbmVnWkdaazEwRWlUR2dqNnNETE1aNEpwci9U?=
 =?utf-8?B?L25nR1BoTDBtUndFcnFjOGhUTWRRTzJ3YXR5Kyt3OGlQdFVKMGtvUjY2TEIw?=
 =?utf-8?B?bzZJcmlBWk43QnMwYTFSNEdwNlliWFRoNExZUnExYlZKb1VOS3E3cHA2blVI?=
 =?utf-8?Q?LaBcGpkOn3gAq6ILHitWv0cwStxVyWlBFocsCEb?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c144116d-dd1c-4009-ed37-08d95c203e52
X-MS-Exchange-CrossTenant-AuthSource: MW3PR12MB4553.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Aug 2021 16:59:40.6047
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: LNfO/3oDzza+Q6LBpUxyRLXS241yh/Ly3X161QxuzQQU9/0t/F6eGzAMnaGTR27k
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW2PR12MB2539
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 8/9/21 2:43 PM, Babu Moger wrote:
> 
> 
> On 8/6/21 11:53 AM, Sean Christopherson wrote:
>> On Fri, Aug 06, 2021, Babu Moger wrote:
>>> From: Babu Moger <Babu.Moger@amd.com>
>>>
>>> The test ./x86/access fails with a timeout. This is due to the number test
>>> combination. The test cases increase exponentially as the features get
>>> enabled. The new machine adds the feature AC_CPU_CR4_PKE. The default
>>> timeout is 180 seconds. Seen this problem both on AMD and Intel machines.
>>>
>>> #./tests/access
>>> qemu-system-x86_64: terminating on signal 15 from pid 20050 (timeout)
>>> FAIL access (timeout; duration=180)
>>>
>>> This test can take about 7 minutes without timeout.
>>> time ./tests/access
>>> 58982405 tests, 0 failures
>>> PASS access
>>>
>>> real	7m10.063s
>>> user	7m9.063s
>>> sys	0m0.309s
>>>
>>> Fix the problem by adding few more limit checks.
>>
>> Please state somewhere in the changelog what is actually being changed, and the
>> actual effect of the change.  E.g.
>>
>>   Disallow protection keys testcase in combination with reserved bit
>>   testcasess to further limit the number of tests run to avoid timeouts on
>>   systems with support for protection keys.
>>
>>   Disallowing this combination reduces the total number of tests from
>>   58982405 to <???>, and the runtime from ~7 minutes to <???>
> 
> Sure. Will do.
>>
>>> Signed-off-by: Babu Moger <Babu.Moger@amd.com>
>>> ---
>>>  x86/access.c |    4 ++--
>>>  1 file changed, 2 insertions(+), 2 deletions(-)
>>>
>>> diff --git a/x86/access.c b/x86/access.c
>>> index 47807cc..e371dd5 100644
>>> --- a/x86/access.c
>>> +++ b/x86/access.c
>>> @@ -317,9 +317,9 @@ static _Bool ac_test_legal(ac_test_t *at)
>>>      /*
>>>       * Shorten the test by avoiding testing too many reserved bit combinations
>>>       */
>>> -    if ((F(AC_PDE_BIT51) + F(AC_PDE_BIT36) + F(AC_PDE_BIT13)) > 1)
>>> +    if ((F(AC_PDE_BIT51) + F(AC_PDE_BIT36) + F(AC_PDE_BIT13) + F(AC_CPU_CR4_PKE)) > 1)
>>>          return false;
>>> -    if ((F(AC_PTE_BIT51) + F(AC_PTE_BIT36)) > 1)
>>> +    if ((F(AC_PTE_BIT51) + F(AC_PTE_BIT36) + F(AC_CPU_CR4_PKE)) > 1)
>>
>> Why are protection keys the sacrifical lamb?  Simply because they're the newest?
> 
> Yes. I added it because it was new ):.
>>
>> And before we start killing off arbitrary combinations, what about sharding the
>> test so that testcases that depend on a specific CR0/CR4/EFER bit, i.e. trigger
>> a VM-Exit when the configuration changes, are separate runs?  Being able to run
>> a specific combination would also hopefully make it easier to debug issues as
>> the user could specify which combo to run without having to modify the code and
>> recompile.
>>
>> That probably won't actually reduce the total run time, but it would make each
>> run a separate test and give developers a warm fuzzy feeling that they're indeed
>> making progress :-)
>>
>> Not sure how this could be automagically expressed this in unittest.cfg though...

As we know now that we cannot run a huge number of tests without running
into timeout, I was thinking of adding a extra parameter "max_runs" for
these tests and add a check in ac_test_run to limit the number of runs.
The max_runs will be set to default 10000000. But it can be changed in
unittests.cfg. Something like this.

[access]
 file = access.flat
 arch = x86_64
-extra_params = -cpu max
+extra_params = -cpu max -append 10000000
 timeout = 180

Thoughts?

> 
> Let me investigate if we can do that fairly easy. Will let you know.
> Thanks
> Babu
>>
>>>          return false;
>>>  
>>>      return true;
>>>
