Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DC4D860C690
	for <lists+kvm@lfdr.de>; Tue, 25 Oct 2022 10:35:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231888AbiJYIf0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 25 Oct 2022 04:35:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37340 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232298AbiJYIfT (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 25 Oct 2022 04:35:19 -0400
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2082.outbound.protection.outlook.com [40.107.92.82])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BCB87BCB88
        for <kvm@vger.kernel.org>; Tue, 25 Oct 2022 01:35:13 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jn9KfxOIA2TbjTIYEwbpAHGr1ZQaw4kshRmdd/wwmzePgYwHb4GJthl+UlcHTWPpzcyzufry2UJMFP9Go6bmPeWGcAxbuKWs1mhUThTPvuPi871JuJfgfIwXalr+0AOXhyr3Eff0AZmxfXRH6BKEUtPPJi0gF2hqJ9skHDpB9XmGiGX8TGmXqnNKGW/HwKYYAIXflKah7+KiyyPj+lBBpQ0G9QJ8BstiJWyy1565k0xfwdA0fNxkAgtK3+h/Nf/5N5cB08kQxf+9iAW3LBK9zSb+2Hh0Tzi5DpaSVgONis6qdC/z7k7F4lJ6CWEmDq3vT2BcM+MT0INjEVz0HzTPyA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=3/3+m6GtZxBzp7Pp7lOjn1NLFwfq+lt5ivtm8caGsek=;
 b=Ra6q+1SD2Vazv78aasjX8+PooUsYe0aNk7/ZLCjhTuZK8SPlXYcJaUH0Qmr673gqh8Pz0fD0e4gOj9XO8OTNNIPSWQVZ9jDMvpbJh9gKY6HayKK8QIAdF0RpvAH20MgqiEGSVsuFkx4CkyfMhua4Dhg+2XilMabQaDJxOeerkaOC3BjhQ1itc4chjmiV12Wm/E4iJZETv082z4PONDuP/hbxy5XvaGxkYIweK0sp3QJpi5Sx2ZpY7KryMN28ulOiNN2/x4KQIAeeMCv+6Nx7u73ieJ8kpKyhxqTsWQRJx+BELZpQ5N3TWE3AtoZuumpvYaOu/X+0jCAVC0vylKRZSg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3/3+m6GtZxBzp7Pp7lOjn1NLFwfq+lt5ivtm8caGsek=;
 b=zzdwMD+OFp64qo3mijLYn2GjPvZWPHU7EQhKBOHAyoeHnf3c4W1dLSCcRvqG8znN8/qOPfjXNcXHV6yabBThc9WvEPIXEzZ05PApwXwOmFels7Y2l1f/9SFhqz26JcVTPn7GHKbOxG2R0AaF8DrQj1D1juLStUvqhlYXpassHSg=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from PH7PR12MB5712.namprd12.prod.outlook.com (2603:10b6:510:1e3::13)
 by IA1PR12MB6092.namprd12.prod.outlook.com (2603:10b6:208:3ec::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5746.27; Tue, 25 Oct
 2022 08:35:11 +0000
Received: from PH7PR12MB5712.namprd12.prod.outlook.com
 ([fe80::5e18:8583:e725:f5d3]) by PH7PR12MB5712.namprd12.prod.outlook.com
 ([fe80::5e18:8583:e725:f5d3%6]) with mapi id 15.20.5723.033; Tue, 25 Oct 2022
 08:35:11 +0000
Message-ID: <e8d5d9b4-6bc9-2dd2-6dc1-f342129f8ef6@amd.com>
Date:   Tue, 25 Oct 2022 14:04:55 +0530
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.0
Subject: Re: [kvm-unit-tests PATCH v3 10/13] x86/pmu: Update testcases to
 cover Intel Arch PMU Version 1
Content-Language: en-US
To:     Like Xu <like.xu.linux@gmail.com>
Cc:     kvm@vger.kernel.org, Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Jim Mattson <jmattson@google.com>
References: <20220819110939.78013-1-likexu@tencent.com>
 <20220819110939.78013-11-likexu@tencent.com>
 <0666abab-ed22-6708-a794-de5449d049f1@amd.com>
 <a1e202f0-260e-fe00-4e39-42e390d4021b@gmail.com>
 <27ef941b-05df-7fa4-a54e-8571b0bf70e7@amd.com>
 <991bf043-3c5e-09f6-9080-ce8ae5c819e7@gmail.com>
 <0210ab19-78b0-d036-687d-1201abc2c732@gmail.com>
From:   Sandipan Das <sandipan.das@amd.com>
In-Reply-To: <0210ab19-78b0-d036-687d-1201abc2c732@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: PN2PR01CA0198.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:c01:e9::7) To PH7PR12MB5712.namprd12.prod.outlook.com
 (2603:10b6:510:1e3::13)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH7PR12MB5712:EE_|IA1PR12MB6092:EE_
X-MS-Office365-Filtering-Correlation-Id: 8f9f792e-ba30-418d-6c00-08dab663d4ad
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: fRXn72fOcaEKB5ylXGyE4w+kHrHkbIFSDUk48uRV3XPHWcTvwOeXUYthluPDgxrWHHHQ0T1d9lgk+LE23lZnZ4I7NxlW6+D47XNLzkZmujoB63/uwRkxylDpc7ntSibWj/kb2kkylwT2eIZx1BNyGjxmaUIzGNqfJKrxpQHlIPf6AppPQwrXlOG/+O4KjhuSELj1lTJ2VWnw8tD4YGtXXA0qVmoe4/nzVc9ISbZXw8l2nU93y1lE5cp4HofO1GLc+ALisvy6DjQ8q/rjZtYwto4X7zzK3mXPbYRmXYAyLzhC7vkHGGzEvfvD0W/j9sz2gwxBwXykq2oW/RMiC6M3k7DxAcmvLfq9COTpbskEoaCANVsCYVeev8H+4L2wrkY5fhBPNsoYHt6Ik9v+jAGj2/HudnlkABouXzlG2jcYGtcCmsyvl/VTsv9oojvMaKbrTfaOahxKF82J/nAFO8I9aJTu4MI5wGIzbKLE/ikYMgodMmqxxC2qIYVioLcUqHtQCyUre21cgAYjYxvgSC1EIzYM2KQu2IbatTPv13sqd7ev+FbtqVPH/GnwA4wLqZdtKe2iocER+r79K0ap6PlqZwwLGP4Mun6pdFzpoATyA3Vfe6lOmaYU8gMSZPgbbVXKalEbSppxf9A9mfUHpDjjGcyCQ3VHLcv++DLxt2VmNeuhrgoa95LWCaUl+KOOlFki6t/Wb/OmgukIqVqxf1pnfMNeq+EazaFTDN4+c7uBbzX8o+skE0eDHRXemGwCvgSMGpxESf4A6Un4zk9Hv24ndjVh3ak0v97lISkqf8u6KrgoruqRRIRmzK+/4f1RIX+sxnSjY3CbAxpBzP+GKB07nA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH7PR12MB5712.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(136003)(366004)(346002)(39860400002)(396003)(376002)(451199015)(8676002)(66476007)(44832011)(4326008)(66556008)(41300700001)(66946007)(2906002)(15650500001)(8936002)(54906003)(316002)(38100700002)(6916009)(5660300002)(6486002)(83380400001)(53546011)(478600001)(6666004)(6506007)(86362001)(31696002)(26005)(6512007)(186003)(2616005)(31686004)(36756003)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?RU12QlJtMEtQZ080aFp0RG93dFMreHg4dUtxdFFtMWlkOXlOZTBuN2NlTE51?=
 =?utf-8?B?cFhEMW9DZ2ZJQnhWRlVPV2xSaXRmSkgzV2tMRGNyekV3VFNIQ2FDc0FMenQ2?=
 =?utf-8?B?QSs3Q1ViYWpwazhCbWt3SWUxOEk0ZnFwNHg3OFhINDdQTU53UUVvdWU5bWVH?=
 =?utf-8?B?OW5TZ2VpRjJPY1hTMWwzT1VibFg4blVGbGNqUHNPNlA4emlicHJGMGlwNzdO?=
 =?utf-8?B?ZHZxeEhUNTRBTTVUZlZobVdHM2xlcW41RFJHeThrSytJV1VaaGVtVzFSQTVs?=
 =?utf-8?B?bmk2VU5CbnBNSXU0eDlHNDlna1RuOXV2cHM5Nk43THIySWR0UkZmN3oxT3dr?=
 =?utf-8?B?c2dXT0N2VFVnMk1rWW5TSUJtMGVDLzVEVnZ4cVk2T0tKYVk3aWNwTUtFaWR5?=
 =?utf-8?B?RFhZb0p1RS93VDROcUxQZXNzYnpPTnVaZ3c4MHhqMnZGU0pROXF6WlNueEpT?=
 =?utf-8?B?cWJwV1RpVkppVnhCOXhDVnRzN2RTclEzL3Y4d3JqL0xwMTBwMEsyRXlPMzZj?=
 =?utf-8?B?SmhzU0hVMWVXMmNxL2xjU1JKWlQzcVBBakIzc3RVcnB0b25FaTF4N1ZiZjhL?=
 =?utf-8?B?MVFJZ3BZaFh0SHp2UTZWWHRsTWNUZ3g1QWNBdWt4Tk56YTBpUjFZTCtUOFBm?=
 =?utf-8?B?aW1jb2llem1MR1lwSVlQNnRuRVgwaFRQSkVkRFlOUkNDcU82Qm5kcmdZeUVl?=
 =?utf-8?B?YjlSa2U1YmFjQytqdi8rR2UxZXMvV1pNeStmYlNoYVVsMFQ0aHI2aC84TVNV?=
 =?utf-8?B?ekU1bW80UHd5ZTZOSENZVk0vakN6c1cyd2VjQ3ZwbXJRNEFpclZnUDNOSjMz?=
 =?utf-8?B?a2tIYUc2S2NoZU5ZUXBJK1l6RHpCd1dpSklSVWJkNVU1YWQrM1VMTDhmOUlT?=
 =?utf-8?B?VkxuTENTOHFBa0llUUNFWGpDVGw2NHJaOFhHVXRzUHZiMDU1ZlA5bTFYbmVo?=
 =?utf-8?B?QlpPRWVyUmh6MGdON1BJZFVWKy9RNEVXamtOZ3FHNFhaVTI4amVZVGdxZVpO?=
 =?utf-8?B?azQxSWNFbHBDMnhXTWl4aWJ3Z1V1czVERWNjWnhlNmJVcVhJQUxReHVTcmRV?=
 =?utf-8?B?cUc0cnhWZjdXSUsxTUE5M3ZSVk5TanRlRHYwYjVsS0NaclFlL3kwMnpIbXNL?=
 =?utf-8?B?TGhPNnFiODNJMHk5N2NqeXE1cnppMUZYRU1NWTBEU3NCVU9MZjZyL2xtWnNu?=
 =?utf-8?B?cmFGWEMvUi8xMG5iY2hTR0gxTnlLWmV4ZDB6dDlqMlpMKzdzYWcyc1o3Ni9M?=
 =?utf-8?B?OUhBcUhhNnhrQXZFTHdVWkVuL0wzbXlYSGkxZjlTVFhMbWpKZUl5RStOMFM0?=
 =?utf-8?B?UUxieFViZnVWQW9yRHd4TTd6REIzREJSdDhxSXhVUnFrcnRlTmw1eWtHdjRt?=
 =?utf-8?B?Uy9MYzgxY2R5OGN3Rk9oY2JWNUJqR0w1RGZISXRkaTNzRlYvK2JQaXRaNHRE?=
 =?utf-8?B?TGMvLys2WCtQb2k0S1VLQ3lDdnptempOMGtHdjFnUTluaXUxWWlCRjBUMTVR?=
 =?utf-8?B?RVVWOHd3cEdhanBERWFaU0JpZHZLSytBVEY4bHV2eDgxajJoVEFPelc2R1c1?=
 =?utf-8?B?WklvMnFvUUtVVlRnOUdVVHJYN3lPV2cxeGVpcUU1ZHhsZE1nVFA3OGFjWlF1?=
 =?utf-8?B?Skc5WEs3dC84aW9wTStibUEzMDd6UUNMVkpjU0xsSnNwOE1Xd1U0aEwzM2lB?=
 =?utf-8?B?YTcvZVRGRjJWWjV4ZHZzWkFTK3UzbWlpRFBWSWNGSGdaNVE5RDNDdlBscVVs?=
 =?utf-8?B?RWtKM0VuN1lVcWdnRmNUc0I1WDNBbEhIK0M1amZoRi9JNnVYZlR6eS9kbzdB?=
 =?utf-8?B?MGFhMGFwSmNGV3N4bVdNTVU1Y21zNkJKTDNXYkJmblg2MmxPMWRTeVgzNjRY?=
 =?utf-8?B?WTdyWTlPTTd5djkzdXIvZU9iOXljWTQrMUluVUxTdkNGMnllZ25TZUdGQUJ0?=
 =?utf-8?B?N05OdDQveW1WOXQvWjh0SzhDNDdvb1pFM2h6U2FwOU1VazFMdUxHdmxPYVJ5?=
 =?utf-8?B?ZFVqbHhnWmtTS1BwZS9Pay8xRDFKdlJzMm55ZmZkVzVPODNRUTYxWlJ1NjRq?=
 =?utf-8?B?aGlLRUVTdkNqaUQwUDU4a2x1N3RKT2I0UFJTbnJlTEFSWjdnL3J1Um03SW9l?=
 =?utf-8?Q?OoXh1pRfj4vS1OP0q8RVEKVHk?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8f9f792e-ba30-418d-6c00-08dab663d4ad
X-MS-Exchange-CrossTenant-AuthSource: PH7PR12MB5712.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Oct 2022 08:35:11.6248
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 2nNeKZ04txFagVZ/3ZD7nVdwODbRkI/Nq8J+gqbcVd1Y41X8oLa3UmPI+widwO8oVaRprruQ2oRcw32ZCjYe+A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR12MB6092
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,URIBL_BLOCKED autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Like,

On 10/21/2022 1:02 PM, Like Xu wrote:
> Hi Sandipan,
> 
> On 19/9/2022 3:09 pm, Like Xu wrote:
>> On 8/9/2022 4:23 pm, Sandipan Das wrote:
>>> On 9/6/2022 7:05 PM, Like Xu wrote:
>>>> On 6/9/2022 4:16 pm, Sandipan Das wrote:
>>>>> Hi Like,
>>>>>
>>>>> On 8/19/2022 4:39 PM, Like Xu wrote:
>>>>>> From: Like Xu <likexu@tencent.com>
>>>>>>
>>>>>> For most unit tests, the basic framework and use cases which test
>>>>>> any PMU counter do not require any changes, except for two things:
>>>>>>
>>>>>> - No access to registers introduced only in PMU version 2 and above;
>>>>>> - Expanded tolerance for testing counter overflows
>>>>>>     due to the loss of uniform control of the gloabl_ctrl register
>>>>>>
>>>>>> Adding some pmu_version() return value checks can seamlessly support
>>>>>> Intel Arch PMU Version 1, while opening the door for AMD PMUs tests.
>>>>>>
>>>>>> Signed-off-by: Like Xu <likexu@tencent.com>
>>>>>> ---
>>>>>>    x86/pmu.c | 64 +++++++++++++++++++++++++++++++++++++------------------
>>>>>>    1 file changed, 43 insertions(+), 21 deletions(-)
>>>>>>
>>>>>> [...]
>>>>>> @@ -327,13 +335,21 @@ static void check_counter_overflow(void)
>>>>>>                cnt.config &= ~EVNTSEL_INT;
>>>>>>            idx = event_to_global_idx(&cnt);
>>>>>>            __measure(&cnt, cnt.count);
>>>>>> -        report(cnt.count == 1, "cntr-%d", i);
>>>>>> +
>>>>>> +        report(check_irq() == (i % 2), "irq-%d", i);
>>>>>> +        if (pmu_version() > 1)
>>>>>> +            report(cnt.count == 1, "cntr-%d", i);
>>>>>> +        else
>>>>>> +            report(cnt.count < 4, "cntr-%d", i);
>>>>>> +
>>>>>> [...]
>>>>>
>>>>> Sorry I missed this in the previous response. With an upper bound of
>>>>> 4, I see this test failing some times for at least one of the six
>>>>> counters (with NMI watchdog disabled on the host) on a Milan (Zen 3)
>>>>> system. Increasing it further does reduce the probability but I still
>>>>> see failures. Do you see the same behaviour on systems with Zen 3 and
>>>>> older processors?
>>>>
>>>> A hundred runs on my machine did not report a failure.
>>>>
>>>
>>> Was this on a Zen 4 system?
>>>
>>>> But I'm not surprised by this, because some AMD platforms do
>>>> have hw PMU errata which requires bios or ucode fixes.
>>>>
>>>> Please help find the right upper bound for all your available AMD boxes.
>>>>
>>>
>>> Even after updating the microcode, the tests failed just as often in an
>>> overnight loop. However, upon closer inspection, the reason for failure
>>> was different. The variance is well within the bounds now but sometimes,
>>> is_the_count_reproducible() is true. Since this selects the original
>>> verification criteria (cnt.count == 1), the tests fail.
>>>
>>>> What makes me most nervous is that AMD's core hardware events run
>>>> repeatedly against the same workload, and their count results are erratic.
>>>>
>>>
>>> With that in mind, should we consider having the following change?
>>>
>>> diff --git a/x86/pmu.c b/x86/pmu.c
>>> index bb16b3c..39979b8 100644
>>> --- a/x86/pmu.c
>>> +++ b/x86/pmu.c
>>> @@ -352,7 +352,7 @@ static void check_counter_overflow(void)
>>>                  .ctr = gp_counter_base,
>>>                  .config = EVNTSEL_OS | EVNTSEL_USR | (*gp_events)[1].unit_sel /* instructions */,
>>>          };
>>> -       bool precise_event = is_the_count_reproducible(&cnt);
>>> +       bool precise_event = is_intel() ? is_the_count_reproducible(&cnt) : false;
>>>
>>>          __measure(&cnt, 0);
>>>          count = cnt.count;
>>>
>>> With this, the tests always pass. I will run another overnight loop and
>>> report back if I see any errors.
>>>
>>>> You may check is_the_count_reproducible() in the test case:
>>>> [1]https://lore.kernel.org/kvm/20220905123946.95223-7-likexu@tencent.com/>>>>
>>> On Zen 4 systems, this is always false and the overflow tests always
>>> pass irrespective of whether PerfMonV2 is enabled for the guest or not.
>>>
>>> - Sandipan
>>
>> I could change it to:
>>
>>          if (is_intel())
>>              report(cnt.count == 1, "cntr-%d", i);
>>          else
>>              report(cnt.count < 4, "cntr-%d", i);
> 
> On AMD (zen3/zen4) machines this seems to be the only way to ensure that the test cases don't fail:
> 
>         if (is_intel())
>             report(cnt.count == 1, "cntr-%d", i);
>         else
>             report(cnt.count == 0xffffffffffff || cnt.count < 7, "cntr-%d", i);
> 
> but it means some hardware counter defects, can you further confirm that this hardware behaviour
> is in line with your expectations ?
> 

I am yet to investigate as to why there would a variance in count but with this updated
test condition, I can confirm that the tests pass on all my systems.

- Sandipan

>>
>> but this does not explain the difference, that is for the same workload:
>>
>> if a retired hw event like "PMCx0C0 [Retired Instructions] (ExRetInstr)" is configured,
>> then it's expected to count "the number of instructions retired", the value is only relevant
>> for workload and it should remain the same over multiple measurements,
>>
>> but there are two hardware counters, one AMD and one Intel, both are reset to an identical value
>> (like "cnt.count = 1 - count"), and when they overflow, the Intel counter can stay exactly at 1,
>> while the AMD counter cannot.
>>
>> I know there are ulterior hardware micro-arch implementation differences here,
>> but what AMD is doing violates the semantics of "retired".
>>
>> Is this behavior normal by design ?
>> I'm not sure what I'm missing, this behavior is reinforced in zen4 as you said.
>>

