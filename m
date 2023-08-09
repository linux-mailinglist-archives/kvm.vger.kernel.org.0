Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 15ADE775639
	for <lists+kvm@lfdr.de>; Wed,  9 Aug 2023 11:17:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231750AbjHIJRn (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 9 Aug 2023 05:17:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47758 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230506AbjHIJRm (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 9 Aug 2023 05:17:42 -0400
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2123.outbound.protection.outlook.com [40.107.223.123])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F0E781FD5;
        Wed,  9 Aug 2023 02:17:39 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=IcxOHpfa/eNIcxj6uYRxvL/djfpBywAFLpL1FQ79JOVhxi/n7R4mG0CMv+w9H0NCoCMqpAFFl0U3Iqwlu3O1H20yL2X2mS4MMEZdjbaiyLlz2Gf7JYgit2TuVZZaucCLUR19H7LXToHsP53Oe5DTuqCaD6Nmo86HU1CDwNJ2po0unK//eLXwM2s/xX7d+LuDLDR200gbwXa1pLcUAQwQVh6XzsM4bEDtz1kFx+ozuIBOkOQ7j0slI3CF8qk6GXuO7Kbk7r9R5+iUYNy6SaMo57TOhsLA2xE6J3OPDCxYpZmb5uE+yzxGXuxDrU/ddOkb1aUPapQ4cM8o2F5SrhOcsA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=7foVcb/1T/lI/HIJfYtnG8xSzIzQD6CDJRM7Yq2MZBk=;
 b=g3nF5QRp3BPy64uZDi/az6s3vkOb9C+uDFycaYSjJZmDEVBEn9Xg0nDOfTKx1VH3SL4ENfLiUlYi3JwCclzphnyrpHBy9uVx3M2tI7CgM9H7wfz71RSrXvrBVIJbQN2j2pTRNddYEfHTtsCBU1m71X/h/TY2UJlZbBteGziZ+ZvNLnBzuRoMOxTDnOMV/t7MKXsCeZFYVeEjTPtnszW9Ue/Y2rSkGIQ7Q8dL74frsh9/CRN4gVEmP42TcxuikRr/Hf50f6aqcscZaAjJY5f1vIMDvz2zZka6PYuARUjjlXXUgs7+ptA826baiGE/RFirD6+ujIBWKXk2Q8OAVDO/4w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=os.amperecomputing.com; dmarc=pass action=none
 header.from=amperemail.onmicrosoft.com; dkim=pass
 header.d=amperemail.onmicrosoft.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amperemail.onmicrosoft.com; s=selector1-amperemail-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7foVcb/1T/lI/HIJfYtnG8xSzIzQD6CDJRM7Yq2MZBk=;
 b=bZeMgMyIitIx3izcedzF6w67QP122KOAaeW6huKijQv+ULX+NqqU5+Oku2cO78AgepISQ1AORYylCjbx689WodwpWOkMkPdBrIq44kir388G2qc35ao4h3q+ZIaYFiAb7Ke1+I/CvdwjQDL7N3rhG696qAc/mWW3hnTC2k2C+aE=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amperemail.onmicrosoft.com;
Received: from DM8PR01MB6824.prod.exchangelabs.com (2603:10b6:8:23::24) by
 PH0PR01MB6229.prod.exchangelabs.com (2603:10b6:510:1f::20) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6652.28; Wed, 9 Aug 2023 09:17:37 +0000
Received: from DM8PR01MB6824.prod.exchangelabs.com
 ([fe80::d62f:d774:15b0:4a40]) by DM8PR01MB6824.prod.exchangelabs.com
 ([fe80::d62f:d774:15b0:4a40%4]) with mapi id 15.20.6652.026; Wed, 9 Aug 2023
 09:17:36 +0000
Message-ID: <1bb556dc-8adc-63ea-75b3-ad0596f1b89e@amperemail.onmicrosoft.com>
Date:   Wed, 9 Aug 2023 17:17:26 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.14.0
Subject: Re: [PATCH] perf/core: fix the bug in the event multiplexing
To:     Oliver Upton <oliver.upton@linux.dev>,
        Huang Shijie <shijie@os.amperecomputing.com>
Cc:     maz@kernel.org, james.morse@arm.com, suzuki.poulose@arm.com,
        yuzenghui@huawei.com, catalin.marinas@arm.com, will@kernel.org,
        pbonzini@redhat.com, peterz@infradead.org, ingo@redhat.com,
        acme@kernel.org, mark.rutland@arm.com,
        alexander.shishkin@linux.intel.com, jolsa@kernel.org,
        namhyung@kernel.org, irogers@google.com,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        linux-perf-users@vger.kernel.org, patches@amperecomputing.com,
        zwang@amperecomputing.com
References: <20230809013953.7692-1-shijie@os.amperecomputing.com>
 <ZNNNY3MlokEIj4y8@linux.dev>
From:   Shijie Huang <shijie@amperemail.onmicrosoft.com>
In-Reply-To: <ZNNNY3MlokEIj4y8@linux.dev>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: CH2PR03CA0030.namprd03.prod.outlook.com
 (2603:10b6:610:59::40) To DM8PR01MB6824.prod.exchangelabs.com
 (2603:10b6:8:23::24)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM8PR01MB6824:EE_|PH0PR01MB6229:EE_
X-MS-Office365-Filtering-Correlation-Id: 9ee0f904-7443-403f-8541-08db98b97854
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: dliWHYIoBzhRYMWxqzbcLmXN6s13Cet1YdRr+Z3JbB9LLmC8jsF1H1ULuF32KkmMzcQ5ZQPRWgTvgMcNc+aY9jacpC/IOQ89q6mXCD0tQA5AsbwQu6iQxq1OqE86oTxfz/0i4FbqMA818yLidw6CDTUNOwmA6vhd654O1wCKcpdWuusOfVlkG3XcZGsoPsxZ6+8APP0j0O38xLbqCf6yhzMrRbftNnX4JdFh9a8B29Hpwi0Mx6pR/ujOYGmoQ0p91FEkwp9cqRfleYb+6Hg4X/GYp5rtUE8NJfkjxPG2ouG8bfRbnJ7g4wPN7aB+A10Twy02f6AAxgBdLGlPZn77bzaF37iaKg9NLCXXEiNX3SZR3ByCJpESbdUgJoDlQoRdb1Xju9XPrK48hfGaxb1hW0LiP+dAGAmtRlUxPuE65L8nb2KdNSW5mknz+f4FbD1xj0UEbhAyVePXFSgrTCwW5arEZqQhek22/I9n0IrkwDPYnHStUkNNjpQZprx2aoe4Tx4GVEcSAAIYwPj+rFTLy2psqN0bsUpaGzKXe9vLGsx+I1g1ioHSv2BtrG5ZomnFZhgNj4Yi3LMhPNMLc8JqSq50MMAp6kpAJY4n7I3u27PrOC6IIiPz5F7v7hc9R0E/4mc8Z8kmYNzPmkNgHu8ghg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM8PR01MB6824.prod.exchangelabs.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(396003)(136003)(346002)(376002)(366004)(39850400004)(451199021)(1800799006)(186006)(6512007)(83170400001)(26005)(6506007)(107886003)(110136005)(38100700002)(38350700002)(5660300002)(7416002)(31696002)(4326008)(2906002)(66476007)(66946007)(66556008)(8936002)(8676002)(316002)(41300700001)(6666004)(6486002)(52116002)(478600001)(31686004)(83380400001)(42882007)(2616005)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?Szl5WXZSZk56alY4MURzYmFybzR1TnVXN3NNNXNta3lpR1hCTFpST2ZIM3lp?=
 =?utf-8?B?V0Q3SXZFL0FKQjcrRFJseVdJNzlnTHlmNzFTQUVsNEJEKzg2SDRoY3IrSk1O?=
 =?utf-8?B?dTFocC8zcGZWY3B1YzUrT0ZFcm9KWmVlZzk5ck9nSDJtZ2kvMlpjS2ttOXdH?=
 =?utf-8?B?SXZDTWhkWmpLRDZ1LzBDS1pTVk9xanhwbjQzVTBCWkg0ZDcxNGRvelRFYTNj?=
 =?utf-8?B?MGFlZkFkcHBiRm5iU0p1SmtzVDcxa09oV2hwNlFOZTVkNFBWTXlHaG9tM042?=
 =?utf-8?B?NlhZbCszT0VnNXYraVk0SmpPM3kvUzVMN2o2YVJjREFOaHQycERUSkpiSjl5?=
 =?utf-8?B?YVpvQzQ5R3R0SzdYKzdRUyswWjFJTzN5eHZPcHBFRitMNDc3N3BnR0ZDVDFr?=
 =?utf-8?B?NjVOUVdROVc2azRqeUJ0V2UvRWIrS21ZSXFtU0lZTVpVeS9FNGgzekZDSVhw?=
 =?utf-8?B?eTlDaHM1SGpJbmUrWUtJeGJqWXl3R285SjFRcGtKaUlTZVNDTVhtcU94dEZ0?=
 =?utf-8?B?UHZENXJhTmZXc0dqUFVrSWtqcDZ3bTluVHAwSDlRRE03dHI4ZTlWcGJRVEhI?=
 =?utf-8?B?MDM3OWlNVVdkTTJFM3V1UE41bjZJTHNUYmFCSjdQRzB4K2R2OFJydFo3cWRq?=
 =?utf-8?B?dWdmWFJVM3Z4SVkrS2NLYjZkd25wcGRwRnFVcFFBZXkzamVMQ291R3JvcmRa?=
 =?utf-8?B?ZzFZcVJuQmE3SkNITzJzTmJRWmQ3dHFMbVNaMzJhQXBjRjNnQnNtRTAzdTY1?=
 =?utf-8?B?cHZibnhwK1pBdU9LUWhwZTZVNDB5U2dueXIzTG1zUkE2elZsemZGQUFFcGht?=
 =?utf-8?B?L2ltQ0hCSWt6eU90V3JnSTBoTTByUU5jRXFCRWZ1TWREY09Ud2dvSHlXdU55?=
 =?utf-8?B?VlBvc2NwSVJPYTl6dkdOdnhjRFV5aWVMRU5zTXVJMVRIbVBmQ24zWERnUUVn?=
 =?utf-8?B?S1NDYnJFL3JSN1VFQit6Q1hQT2h1REV0d25oZUFrbnpQSmhCZXNTaURjQmJF?=
 =?utf-8?B?cnlJb2haWGZua3pJK0tPdkFmQUdTSXl3UzNSRFk0d2hpcW94bjF6eEQyb2hE?=
 =?utf-8?B?Y3ZSQSt3RHJJeWN6TlV4MEkzRHpZbnkrTXBrTFlGS2QrVlViTlFQSUtBNzJB?=
 =?utf-8?B?WE5hTlF1UmVZUDVvSWV6M2xLVVZWZERFWDRKLys1UG9QRElqKzhkaXZGV0oy?=
 =?utf-8?B?WUdTVGZZVEthMEVlS25ZcUQzUE5SaXUrNnBLcTZ1S0t3ODh6cEU1UG1SUTZp?=
 =?utf-8?B?ZmNCVmp2bE8yb2xMZ1FDNkh0QzVVNjk1TEFCT0VRN0VQZHpnZWZETHRJWTgv?=
 =?utf-8?B?WDM2dmc1TEhvR2pVd2MzMURCdm9NRCtOaklWalFyRnBRMVB3bUFILzNuS1lu?=
 =?utf-8?B?NUtraFlxQW1XZEpCN3QrcllpVUVSU0o4TFlLeUY2UXhaZTh2S1RkUjZ6QU50?=
 =?utf-8?B?ektaYkxZVUhjTmdabVkvaFkwODlybXovRVJ5QWk1R2V5dWF2WmRZYTJPODlC?=
 =?utf-8?B?aUVDZ2U1NkdkS2NvK2hNQWI1THZhek5wSEtDckNLdVh1ZkV1RGZlZmY2OCtJ?=
 =?utf-8?B?UWJqdFNySEY0ZndLbWRaR3VDd3UreTF5c2ViblhzRmZiVFFmMkNEbUdURldq?=
 =?utf-8?B?dHNhTW5Rb1pQMlQ0SDBVQ0tDb3lZOHpvRDhyblYwM2tEYjcwYUpaTGM3YVJl?=
 =?utf-8?B?K1lNUEU1QXJ4V243Yk82d0RNWm5qSUwxd3JnWG8wMFdyQW8zOS9oWXJRckIw?=
 =?utf-8?B?YTE0a3NtaVF2SUtqd1hncVhoME9GNXR6Q3lQdjZtdUUwb1hTZ25lTWhEVjBS?=
 =?utf-8?B?MTdidTZJYnBhaVBwUm02d3dBenZCOXFoNHZnV09HRHRJdlV1LzY0SitSMWV3?=
 =?utf-8?B?dlM4dVU5QW1wSkRHS1BkdGZiamEyYVlGVkdEaHdLMzAvai84cEkybWU1MjVH?=
 =?utf-8?B?QVJvWCs1SG94R3ZUMW03Y25xZEJ3UEhyN0I2RE1Ody82VExaMFN0b3pQZHhv?=
 =?utf-8?B?SFlwc0IzR1BXQ1ozVHpWMSsvUlNyTFMrSXQ1amNnTkhaWWFWZ1RqVUIwUEhN?=
 =?utf-8?B?WTRDckV4dGlnalVWbm9vd3lSQXhKSFNZdU16ZzYyRFRHLzdtemFib21YZEZO?=
 =?utf-8?B?SDZpcFdvOEVDWFpDYWlsdDNCL0hUek9LeHQxQXpiRkN5WlZRTHNDYU1MLzRO?=
 =?utf-8?Q?j4pVqNRarcVjHAFSvlf+wFk=3D?=
X-OriginatorOrg: amperemail.onmicrosoft.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9ee0f904-7443-403f-8541-08db98b97854
X-MS-Exchange-CrossTenant-AuthSource: DM8PR01MB6824.prod.exchangelabs.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Aug 2023 09:17:36.0264
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3bc2b170-fd94-476d-b0ce-4229bdc904a7
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: kUM40mXJ2DyfRNk2QXSSmdW6t6FM6l3z1PlsJIQEj9JgyrjKjNZcVQ6xCA9unJ6ZPFEguLCD+BYGQRV1KJqL3uY/HUzafVouKoEfrRkMc9iWSbXsZ4CY89w+x8AdHLi0
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR01MB6229
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_INVALID,
        DKIM_SIGNED,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
        HEADER_FROM_DIFFERENT_DOMAINS,NICE_REPLY_A,RCVD_IN_DNSWL_BLOCKED,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Oliver,

在 2023/8/9 16:25, Oliver Upton 写道:
> Hi Huang,
>
> On Wed, Aug 09, 2023 at 09:39:53AM +0800, Huang Shijie wrote:
>> 2.) Root cause.
>> 	There is only 7 counters in my arm64 platform:
>> 	  (one cycle counter) + (6 normal counters)
>>
>> 	In 1.3 above, we will use 10 event counters.
>> 	Since we only have 7 counters, the perf core will trigger
>>         	event multiplexing in hrtimer:
>> 	     merge_sched_in() -->perf_mux_hrtimer_restart() -->
>> 	     perf_rotate_context().
>>
>>         In the perf_rotate_context(), it does not restore some PMU registers
>>         as context_switch() does.  In context_switch():
>>               kvm_sched_in()  --> kvm_vcpu_pmu_restore_guest()
>>               kvm_sched_out() --> kvm_vcpu_pmu_restore_host()
>>
>>         So we got wrong result.
> This is a rather vague description of the problem. AFAICT, the
> issue here is on VHE systems we wind up getting the EL0 count
> enable/disable bits backwards when entering the guest, which is
> corroborated by the data you have below.
>
>> +void arch_perf_rotate_pmu_set(void)
>> +{
>> +	if (is_guest())
>> +		kvm_vcpu_pmu_restore_guest(NULL);
>> +	else
>> +		kvm_vcpu_pmu_restore_host(NULL);
>> +}
>> +
> This sort of hook is rather nasty, and I'd strongly prefer a solution
> that's confined to KVM. I don't think the !is_guest() branch is
> necessary at all. Regardless of how the pmu context is changed, we need
> to go through vcpu_put() before getting back out to userspace.
>
> We can check for a running vCPU (ick) from kvm_set_pmu_events() and either
> do the EL0 bit flip there or make a request on the vCPU to call
> kvm_vcpu_pmu_restore_guest() immediately before reentering the guest.
> I'm slightly leaning towards the latter, unless anyone has a better idea
> here.

Thanks a lot, I will check the code about the latter one, and try to fix 
it again.


Thanks

Huang Shijie

