Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 11C0F5B16D3
	for <lists+kvm@lfdr.de>; Thu,  8 Sep 2022 10:23:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230135AbiIHIXn (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 8 Sep 2022 04:23:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33386 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231499AbiIHIXf (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 8 Sep 2022 04:23:35 -0400
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on20610.outbound.protection.outlook.com [IPv6:2a01:111:f400:fe59::610])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 91776B9FB0
        for <kvm@vger.kernel.org>; Thu,  8 Sep 2022 01:23:32 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=mkgBRmZZrHpUz1v8GkmxZ4QRxDjLNvUxAu3bPHDc2nKG5D0vgpoGyyUZvr6/QWgmaZxtupmUgBJiU1qyb6bjfKoo5Qq5kiHy4lWqKJOBY3mNsKtMfeMW79y+TFlOvwJMs/UuBWXC8Yf1xUAzCbIqc7xMRIV+1dHJFuKjdXHGI1H6cI3T7CUZjcXp31lOUCQ/o/aUIPL/ImTOBiiLwtyH8/Y2xyXKIbRKx/UjCQ6e2eqhJGTHn1Xnn8yrCBrxD47KGPKTNP4B9Lv0xeSH2KU1F7oAeyorkPpIlcWDILCvxZ+8yu09aeZ6ebe7/PtBHljR9pAebczzwEMO0qKl2GnRLA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=RZcIMHX2r0ZocFiK4TEuf5MZqlfs6UbEikqe2ZGzY5g=;
 b=W2WMoSHNs12G8dJFPZizunlLuiGzgXnsh9WW7mYSSp3avjOUj5y2aVspmw2ZhavS3gqe2ARu935ul9bXu7WlR+cmtFV6M5OsFrHpr9Uk1TIgAf/TYl6v+qb+4P8yYDalZZIhwZp1r6F2H7CdGdjF+yG+/zpfBLkUMV9BsOS4qz6hlG2ESWOHYHCOzIQbyJeHv+DSie5l9kR0lzI23A0Ov8l9SJDeNcreRTwLmXNcnG3s3hbfQmfCiEtTkDenxGt3BA23/dfZCRXYMZskGCdH/ibvLS/SIhzy0k+Om8R+w9NrSmk4suLNriWVw3cV3xrRWFD6HmyUWmX0+THmlI8T7A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=RZcIMHX2r0ZocFiK4TEuf5MZqlfs6UbEikqe2ZGzY5g=;
 b=mEwBmOKD7NIkSGKi7GLnBJhBYsO+PCFuUNLIg4SX9WvwXSk2roWisNoXHc8MrniOwh5LQNn1trzF9bzltOSzP3uZ23YB0DCaEcwdPvTP7jaQIgWcmyIydXStgo2HCqqwnytM8iQkmrqVumn6fDK27aYj2MT5dy/056zicSqHgZo=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from MN0PR12MB5713.namprd12.prod.outlook.com (2603:10b6:208:370::18)
 by SN7PR12MB7202.namprd12.prod.outlook.com (2603:10b6:806:2a9::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5566.16; Thu, 8 Sep
 2022 08:23:29 +0000
Received: from MN0PR12MB5713.namprd12.prod.outlook.com
 ([fe80::a640:1178:3372:d925]) by MN0PR12MB5713.namprd12.prod.outlook.com
 ([fe80::a640:1178:3372:d925%7]) with mapi id 15.20.5612.012; Thu, 8 Sep 2022
 08:23:29 +0000
Message-ID: <27ef941b-05df-7fa4-a54e-8571b0bf70e7@amd.com>
Date:   Thu, 8 Sep 2022 13:53:18 +0530
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.13.0
Subject: Re: [kvm-unit-tests PATCH v3 10/13] x86/pmu: Update testcases to
 cover Intel Arch PMU Version 1
Content-Language: en-US
To:     Like Xu <like.xu.linux@gmail.com>
Cc:     kvm@vger.kernel.org, Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
References: <20220819110939.78013-1-likexu@tencent.com>
 <20220819110939.78013-11-likexu@tencent.com>
 <0666abab-ed22-6708-a794-de5449d049f1@amd.com>
 <a1e202f0-260e-fe00-4e39-42e390d4021b@gmail.com>
From:   Sandipan Das <sandipan.das@amd.com>
In-Reply-To: <a1e202f0-260e-fe00-4e39-42e390d4021b@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: PN2PR01CA0022.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:c01:25::27) To MN0PR12MB5713.namprd12.prod.outlook.com
 (2603:10b6:208:370::18)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MN0PR12MB5713:EE_|SN7PR12MB7202:EE_
X-MS-Office365-Filtering-Correlation-Id: 0185e890-3a57-4a4d-86e8-08da917368b5
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: YnTn5CE8hiEDCxhwJyPIBmeiK7nvLfciBz0kYS50HIc6zA/01X1Q6gXNYlAy7L7+G6KAS8ZV7eoqt90UvKF510lBUAFOrIXW6vZj0r7UqEsVqWTjcarllLsTtSKN22juEP5iXF17WkB9f6FQ/KdJOvmOxuIBfqMeALwoZ8ss+reSYeI39FXPuaVxQ/rKefbbd5avIoZC7MpYTtk0GqPqo4leIlMnfAoQW61YvJN5SEeUbdnZLkWwhOrwHiTFut6SoOAPnToSoQ0SnRyJITdiXqAacj/W3ARFp+g0JVVQaz7iGkKDhw17RTUjH69RgXLTuJEV0otYdaBScWywpVarMi6ORasA3Npl/pKSkXxKmf511lnnXzLcziTgnhRdWdUn46eLE6mDOLqbVBr73YT3WSm/HvzNVuwYy5hJgpK+BK6Gmi+7ExZXkjPoUUaIsvugz8apzkEJxK6bryfA/tU7x/EaSk7JOsKJBTN1hSd3rk0R2xCR2RrGuV3TcR8tpqzteNEnVLPR1AKeeI40Li/0pMkTqtKfaUL5DmnPz3vlIN8xG+1wxRpCvW+h4DKLM09kg5M94lSosfu5v07csFpF6UOlev8yh8W0duhmKrqt/5W8HZDqqLItzTugX3MEe2ZpA9yCXYWp+E4fT+EZikCVbyelgVk6YHAjOlz4V+V4uC6+FDVzPxLIbE/mBim4OhzyG0IES17JK4IuHaCEAfPF0Kx/kGcFxMswYanOTYCKCiAJB68cVTBe8Badx5lCWqzvSsVMHPHAtm3ob3p/aCd28jqCKhLvGFK4P8iuIromtgaVHgOx2z+zUd+/53cI92jynojQIlxYZNDH+1YJLuHnEg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN0PR12MB5713.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(346002)(39860400002)(136003)(366004)(376002)(396003)(6916009)(44832011)(8676002)(4326008)(54906003)(66556008)(66946007)(66476007)(38100700002)(5660300002)(2906002)(15650500001)(8936002)(316002)(6506007)(53546011)(31696002)(6512007)(6666004)(186003)(6486002)(478600001)(36756003)(26005)(41300700001)(83380400001)(86362001)(31686004)(2616005)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?TXpHWkVYbExoR2EzS3BNbnd3Y0k3enUwSldHNnlQdlZNMjhpOHcxT0NsNzhS?=
 =?utf-8?B?TzAvTVd5NWh1SGw3eFRaLzR4TStodVpFam5iRGVEaHpBR3pYRTdmc2JQQ2dh?=
 =?utf-8?B?UGhzS2QwdzFqRGdkcGJnQTR6Tnpya1lZVUZWYlFka3V6NDRBZjlqV2dYbkpn?=
 =?utf-8?B?R2E0a3VXUzFIS1gvSzFPSDViY2NYeFM1YVd5NUU1eFNDUVhmZEIxd2lzVWdY?=
 =?utf-8?B?MXZRZVVzWWwzSnd4YzJvM21pTmhnVjNDQ3hmRmFsUHM1aHpkckJaOEpOb1gr?=
 =?utf-8?B?UHBmY1dXc2VNWEx5WVFkSHZQYU81OUxqaW9DZmpSNEFUU2xtVG41dmlHL0Fu?=
 =?utf-8?B?b1ZuanhleVptdVZZUG1rbHZxcUVPVG00QWREamhaY1Q4VWdWNWVhNTk4Nzh0?=
 =?utf-8?B?LzJlazE2bVgrRW9TSUdSazRFMkNUaDAxMXVYeWJPUlhrV2EvaHYvT244QitS?=
 =?utf-8?B?dHpRdDc1c01pSk0wSUY5MzA0RElXVjZPa09qNlNZVXlqY2tyZWs5YUJ0QlUv?=
 =?utf-8?B?TFFjQ1dtVWdCdkVpcEJmN3JucXBJTUtLM2VPaUpPamtHSXB2eGRWcnlGNGps?=
 =?utf-8?B?Rno1OHRpcFZVYWJLVlp1ZjA0Vi9xWHdxUHE1WWF3WEw2WEtibWVWNEdwTmpS?=
 =?utf-8?B?bXFyLzFqbWc3eGpRV08rcFlob2JOZXBUQTVyVWduaXJhbFp4aksvNENTT2kr?=
 =?utf-8?B?cTZkYjVYWnRYNUVuRTBjZDdZNlk5VGVFQ0UrSmJ6cXVkVVB3emlLTC9WNE1Q?=
 =?utf-8?B?S2ZEN2VHUmxwZnFrMGJlcTV4a2JPUGUyY2RFU1lXQmVvamF3TVV2MVdVd3BZ?=
 =?utf-8?B?QnBhenJYZ1hLNXFoV240WXlibERvK0JSVTZLVGliYlk2bDh6NGNYRitURlAy?=
 =?utf-8?B?RDliL2JBa21TZ1BTSlBGQWVDdlpTZDFjTk52NjE4VVhrTTVjUS9WbHRpdWQ5?=
 =?utf-8?B?aFNwYm5FbTFSVjlYOVVBanpHOEFtSmttUWVld2dXUWFkT3FLM2QrRnRCSDQy?=
 =?utf-8?B?UWVnM1FEeVExd0ZhalVrSklHKzhwdVp2WWpqNVplZ0RGYWZTR2toQnZObWh2?=
 =?utf-8?B?Sk5Ib3ZycUs5bnNEdHJGVHRlM1FrLzUzRjR4eG5ITjJCR1R5ZmdtbUY3SXRz?=
 =?utf-8?B?eXhXL0JIbHBpdm9zRnpMVkM1YnMvM3R5QTdWMXF5VUNsQmNnMTAyOEJNYmo4?=
 =?utf-8?B?MFRjYjNTNFBVRXo1MktkUlRvUDB5MllWU1VyeW52MkN0c0NqRVQ2MWxLMnRz?=
 =?utf-8?B?ME1tYkdzZDRjclhqMysrT2gweGZaQVl3OThsSm12dEZoSXZmZE8wRUFoZ3Nz?=
 =?utf-8?B?ZjFwS3JhOSs2aUgxUm5BcXZiNWkyTk5DR2VBNDlucXZkSEpDbFdqSWFiajZB?=
 =?utf-8?B?QVZSVGNNUWk2UW9oZFRpRjZsQU1SRk5PNTFBNnpTS0FhZTlQOVRlVXhxdnJT?=
 =?utf-8?B?bW5YOFJBUUt3TUd2aUJrZGtlaTBmKzQwcTNGMEhGc29FOCtzR1I0NC83T080?=
 =?utf-8?B?MFhmM3BOd1NzamdiNUZ1TDdkM2MrdExnaWxtTXozeWVrYzNZL1NkSTVGTEVW?=
 =?utf-8?B?b2dMMC85YnAzdFExMTJua0hFLytzUktZTUo5REdCdG9YVGUxdmFMaE16dVh0?=
 =?utf-8?B?Yk4vTVZmM2xNcUhKbEtNNDFqcmFhdVp4UEpFZzQybEpRTFJXZ0FJcmxaV2cy?=
 =?utf-8?B?ZWVORnFzenBGb0NoUU9pZUtuSjVvaEhuVEE0OFRQZ1ZoTmV2TGc0S1h6QzNX?=
 =?utf-8?B?KzRnV1E1RGUvbTA0eW5LUUhmWHo0NDQ3WmpUZzNOTVArVmNiOVNvR0lqaDRR?=
 =?utf-8?B?S01NcU1ZZHE1c2hQRHowTFpETnFxZS9obHBnLzNSbnVTbXNlRkJlY1lJdlJy?=
 =?utf-8?B?UE5KaTNiNEdzWWRDVUdrOC9Kc3ZLQ2RuYnk3QmdxckhBYXMyd2Urdkc2ajdt?=
 =?utf-8?B?NnpNcXhkTXBkQlFKL0diQ016NUMySVZqTXZHdUM4TVB1QnpWMGdxenA0cnha?=
 =?utf-8?B?L2g1U2ZHb1Y0di9OWUtWTi93cVh0b3FKSGFmb1F1ODZPczdBdmx5TkJkNVBQ?=
 =?utf-8?B?aS80WGp5ck1BeEtRNmdCUWVSM3hMMTF5TTdtUkpJc0toU2JsTlVuQXhTWE9Z?=
 =?utf-8?Q?gd9a7eNuCXIiIXxnj1Gfl16m7?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0185e890-3a57-4a4d-86e8-08da917368b5
X-MS-Exchange-CrossTenant-AuthSource: MN0PR12MB5713.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Sep 2022 08:23:29.3620
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ZfZ8OVR/f/s6m446r0wWX0ZWwbZZY4ognO7mq30FA7u1yFyiUtMoecBEKTwsQ08EC86ChiQq1A8489MUe72BMA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR12MB7202
X-Spam-Status: No, score=-6.3 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,SPF_HELO_PASS,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 9/6/2022 7:05 PM, Like Xu wrote:
> On 6/9/2022 4:16 pm, Sandipan Das wrote:
>> Hi Like,
>>
>> On 8/19/2022 4:39 PM, Like Xu wrote:
>>> From: Like Xu <likexu@tencent.com>
>>>
>>> For most unit tests, the basic framework and use cases which test
>>> any PMU counter do not require any changes, except for two things:
>>>
>>> - No access to registers introduced only in PMU version 2 and above;
>>> - Expanded tolerance for testing counter overflows
>>>    due to the loss of uniform control of the gloabl_ctrl register
>>>
>>> Adding some pmu_version() return value checks can seamlessly support
>>> Intel Arch PMU Version 1, while opening the door for AMD PMUs tests.
>>>
>>> Signed-off-by: Like Xu <likexu@tencent.com>
>>> ---
>>>   x86/pmu.c | 64 +++++++++++++++++++++++++++++++++++++------------------
>>>   1 file changed, 43 insertions(+), 21 deletions(-)
>>>
>>> [...]
>>> @@ -327,13 +335,21 @@ static void check_counter_overflow(void)
>>>               cnt.config &= ~EVNTSEL_INT;
>>>           idx = event_to_global_idx(&cnt);
>>>           __measure(&cnt, cnt.count);
>>> -        report(cnt.count == 1, "cntr-%d", i);
>>> +
>>> +        report(check_irq() == (i % 2), "irq-%d", i);
>>> +        if (pmu_version() > 1)
>>> +            report(cnt.count == 1, "cntr-%d", i);
>>> +        else
>>> +            report(cnt.count < 4, "cntr-%d", i);
>>> +
>>> [...]
>>
>> Sorry I missed this in the previous response. With an upper bound of
>> 4, I see this test failing some times for at least one of the six
>> counters (with NMI watchdog disabled on the host) on a Milan (Zen 3)
>> system. Increasing it further does reduce the probability but I still
>> see failures. Do you see the same behaviour on systems with Zen 3 and
>> older processors?
> 
> A hundred runs on my machine did not report a failure.
> 

Was this on a Zen 4 system?

> But I'm not surprised by this, because some AMD platforms do
> have hw PMU errata which requires bios or ucode fixes.
> 
> Please help find the right upper bound for all your available AMD boxes.
> 

Even after updating the microcode, the tests failed just as often in an
overnight loop. However, upon closer inspection, the reason for failure
was different. The variance is well within the bounds now but sometimes,
is_the_count_reproducible() is true. Since this selects the original
verification criteria (cnt.count == 1), the tests fail.

> What makes me most nervous is that AMD's core hardware events run
> repeatedly against the same workload, and their count results are erratic.
> 

With that in mind, should we consider having the following change?

diff --git a/x86/pmu.c b/x86/pmu.c
index bb16b3c..39979b8 100644
--- a/x86/pmu.c
+++ b/x86/pmu.c
@@ -352,7 +352,7 @@ static void check_counter_overflow(void)
                .ctr = gp_counter_base,
                .config = EVNTSEL_OS | EVNTSEL_USR | (*gp_events)[1].unit_sel /* instructions */,
        };
-       bool precise_event = is_the_count_reproducible(&cnt);
+       bool precise_event = is_intel() ? is_the_count_reproducible(&cnt) : false;

        __measure(&cnt, 0);
        count = cnt.count;

With this, the tests always pass. I will run another overnight loop and
report back if I see any errors.

> You may check is_the_count_reproducible() in the test case:
> [1]https://lore.kernel.org/kvm/20220905123946.95223-7-likexu@tencent.com/

On Zen 4 systems, this is always false and the overflow tests always
pass irrespective of whether PerfMonV2 is enabled for the guest or not.

- Sandipan
