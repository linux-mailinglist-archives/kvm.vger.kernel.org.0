Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4CBC677C62B
	for <lists+kvm@lfdr.de>; Tue, 15 Aug 2023 04:59:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234103AbjHOC7Y (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 14 Aug 2023 22:59:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59760 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234381AbjHOC7V (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 14 Aug 2023 22:59:21 -0400
Received: from NAM04-BN8-obe.outbound.protection.outlook.com (mail-bn8nam04on2103.outbound.protection.outlook.com [40.107.100.103])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 738F7173D
        for <kvm@vger.kernel.org>; Mon, 14 Aug 2023 19:59:20 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=GEkFM5pbdM/IFF1XkqtxC+ck4qr1VzXkG76DimHI7gtVE0Ci6y9ottCyst9d9Rh8qLaDsBlpPk7MHkf7XYt7IA0kMrfaLKx/jCUcPQhsKi7aScnpEGtojqZ2K1PVvc5C6mV/1LsKRPya1TOtYUZP15uoSB8O7UuVWmsA/A51q1uQwn9S+O5U3Os/ENo5bCwVwuoC3KlNKybSxvZ67Ck2Z2SqirTbgc+poKj2Lblk3S0j+8FEW5gaq7Bda7q3N0Pnl/AfGqINugTn2Z2fNXiFOhRCou0UT/8r+uMEFXielfES2PTOlesDGDI9eK16m0daAz5iqW8XXxgSXnLygayz1A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=K5VEz6pChcEd3Df3qwj7h2FJIfHjESyWeEIQOXYJ7qU=;
 b=Z8l/hFvBKfF24Ck3SPNSbLge8qB2t7vqBiIMH8eEycDjvYedFq7xZamQgJrajHa223Mf5jXv0cgWkiK6UxKtSwikRL0fLNJaXUFW0tdJtE/4SMKHGINSHozDU86rImu3/TI4ZMpdiCwWeXIVAeRFd1rCKDvP7BbPMadW7lAcDMjgbwe/UGDkj+RDwSybIIKkCBCQXBJ9zw0XOcf+sigU0vlc57ZvTCWGgNyuos8v8W5Orcoj7hqFtRGVikK6NweI5xVbiYHsZWM/kUfGP1kDvaeQu7CiiG/AIbvGA+kgTUWNRiu2nT+i0yGN8Y0Divp33AvaKOp/LOh+S2Ub+XDO9Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=os.amperecomputing.com; dmarc=pass action=none
 header.from=amperemail.onmicrosoft.com; dkim=pass
 header.d=amperemail.onmicrosoft.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amperemail.onmicrosoft.com; s=selector1-amperemail-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=K5VEz6pChcEd3Df3qwj7h2FJIfHjESyWeEIQOXYJ7qU=;
 b=w7sWtOiqGfAUVM1eeoPN2LY2jGKRslGkdUcpFbY6/uizP2LLY8YUAC+3MKWFutDZlhsTpIGkL57HbRnvB9HYl9jFTh6Km5DGIdwqXKcb2iKUURxg/1Z1P7wCUgG++DzA2hdtiCGF5yK7Pb/qKLv/wK6IXwElVVlFRP+Of+Uo8xY=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amperemail.onmicrosoft.com;
Received: from DM8PR01MB6824.prod.exchangelabs.com (2603:10b6:8:23::24) by
 SJ2PR01MB8660.prod.exchangelabs.com (2603:10b6:a03:574::16) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6678.24; Tue, 15 Aug 2023 02:59:15 +0000
Received: from DM8PR01MB6824.prod.exchangelabs.com
 ([fe80::d62f:d774:15b0:4a40]) by DM8PR01MB6824.prod.exchangelabs.com
 ([fe80::d62f:d774:15b0:4a40%4]) with mapi id 15.20.6678.025; Tue, 15 Aug 2023
 02:59:14 +0000
Message-ID: <3285dd21-a1cc-7df0-b2f6-999ed4669901@amperemail.onmicrosoft.com>
Date:   Tue, 15 Aug 2023 10:59:03 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.14.0
Subject: Re: [PATCH] KVM: arm64: pmu: Resync EL0 state on counter rotation
To:     Leo Yan <leo.yan@linaro.org>
Cc:     Marc Zyngier <maz@kernel.org>, kvmarm@lists.linux.dev,
        linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org,
        James Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Oliver Upton <oliver.upton@linux.dev>,
        Zenghui Yu <yuzenghui@huawei.com>,
        Huang Shijie <shijie@os.amperecomputing.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Will Deacon <will@kernel.org>
References: <20230811180520.131727-1-maz@kernel.org>
 <20230814071627.GA3963214@leoy-huanghe>
 <5608d22d-47c3-2a03-a3d9-ba8ec51679a3@amperemail.onmicrosoft.com>
 <20230814084710.GA69080@leoy-huanghe.lan>
 <8640c3c7-b117-5754-6ac4-910988e5374f@amperemail.onmicrosoft.com>
 <20230814100154.GB69080@leoy-huanghe.lan>
From:   Shijie Huang <shijie@amperemail.onmicrosoft.com>
In-Reply-To: <20230814100154.GB69080@leoy-huanghe.lan>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: CH0PR03CA0400.namprd03.prod.outlook.com
 (2603:10b6:610:11b::20) To DM8PR01MB6824.prod.exchangelabs.com
 (2603:10b6:8:23::24)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM8PR01MB6824:EE_|SJ2PR01MB8660:EE_
X-MS-Office365-Filtering-Correlation-Id: 0f43ff65-4fb5-4772-896a-08db9d3b9b68
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: CqhROsmMVbK0MJQwk3T/ITImxuxihGBB9G1DqOHOFM1UGq0HTmIiLHMWsLZewa8que+PRMx9ExzdFO+vFSnStGqKf5OvWR36rHdcEf4LQozBZXcxvmVq4YbXFkZObI87pD5whgvbWUbs8u323kPeH8gZ/1SX3rTVb68mfRGojn6XuJIiaIVATMHhIpiv8C7hKx1l24RuF0G15UcQbm4iYok8UP47VKIsiAaZTQC8yhs/6YirKx6vvcl59jCP7wdjBSOO/p3YSeTSF3gzIaTq3PTJ1FQpwu7y8eP7FW3cgNAVGOFVxilkErbNUDWOP7yFwgsq0XRz3OmYmFIAoRUFAvlG8c8833uUCV77OlVrC1lEn1nZApA6opPU+Y4j9mxzhj3ohRR0q+y2UqnDLHHHAisHbvInu60BIMGPPy8EvTJ7SfQvS/bc00wEDAaRIOgx9PsMbJv00eRD5FJhJ/p8k8+rq8JHjWihQdJ3TbpJEzR3Q3OZumhAgjOK/7xRSbyJTcma9yWkURYxXYbr9fLYxAzrMftMz/VR462hdp5D6LU8zkdWp8kGfaoFVi9eSxYg3N1MIQ+KHy48oqdgIDx8xsl1PyVO+HZ1guA9LmRg9pMNxWhAn2/WP55zUeQNCuhr8CipBpyJXPk8b8//F8ZwIA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM8PR01MB6824.prod.exchangelabs.com;PTR:;CAT:NONE;SFS:(13230028)(39850400004)(376002)(346002)(366004)(136003)(396003)(186006)(1800799006)(451199021)(83380400001)(42882007)(31686004)(31696002)(41300700001)(38100700002)(478600001)(38350700002)(66946007)(54906003)(6512007)(66556008)(66476007)(6916009)(316002)(8676002)(8936002)(5660300002)(83170400001)(4326008)(2616005)(26005)(6486002)(6506007)(6666004)(2906002)(7416002)(52116002)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?d0E5SUtEaXlIdFUxc3p3SUdTUGwvTmdVTC9qWVR6WVRNTW5aVHhyaGJNNnZ6?=
 =?utf-8?B?T2dkM1B1N1U1QWhBKzJLL1pvYVdndWd4MkJCdVdBbVdXazR0Z3FTMDJGcyt2?=
 =?utf-8?B?aWZkeklHTHd6VU1BaGFmVWJIOUpMN0kvTUJ1aUdxRTBHUFdzS3dxQ3V4cnNN?=
 =?utf-8?B?SWN1V29pcnhvTU93Z2xjYVhZRkpPVEZJNW5IQkJKS2tMa0M2dVlCUVNjV0ND?=
 =?utf-8?B?MHpYbkJhdWVPSkRYaU5kMXBXQnRlbjhmemFyUDJ1M0ltZkJUdndXeXdkVURV?=
 =?utf-8?B?UzJHc3JkdzVacER6SEdvRWZaSUxvOFhoSDRiZzgzZG96QmQrMXFVRXhrNDd0?=
 =?utf-8?B?a1ZLb1dlTkI2R2ZzOGNTVTU4UHhlN2FmNFVwdnAxWEdKaWxxbklaaDFSUDVn?=
 =?utf-8?B?dGhuR3VndDZRQnNuQWdOUUR6dnN0MlJVVzZHdnhrdzVBa01UcUFtdjc1eDNO?=
 =?utf-8?B?d3BsWTljZlUyUGZGMXhqV21JbEZnd09iZWZvQUtxR0JHcDFoeDlydzNzcXQ1?=
 =?utf-8?B?TWRuczhnRFZiVDJwMFpQeUpLTHlmS1o2dXcrS1lYV1R5UTIvbGNsQkY3SHpk?=
 =?utf-8?B?bVErenVSTkkrdWlOa1Qxd0syYjU3TFJDcU56Z2tVQnJtRnRiWnVrYUk0d05Q?=
 =?utf-8?B?Rm9EV0p2T2J4RWtEY2pyWWg2U1VwV3hwT2NId2VPdEtqc0FRNzZKN1RGYzVC?=
 =?utf-8?B?cUNheEpOK2JqTGdpb2EyT1FOdloyalBJczZTdHFaenp4OUFmMmhQVWdHQlVi?=
 =?utf-8?B?dGFMVEJ6WDhhcG1zNW43OTBvMVYveU5Tc09DdmQvMWswRlRNWHFmMmFnbits?=
 =?utf-8?B?UDdSUFZvK0ZvdFJZRTQrOWF2TUNXYk40TC9zRU5SeXJOajY3VlVxUmprY1lp?=
 =?utf-8?B?RlpLVkcwVTV1V1hQY3ZKZ0M5SXZvNVh4RXdtOWgyWWxlUWdmLythTnBOU0Ns?=
 =?utf-8?B?Tkc2QkRtWFZ1cTNvMHVRbHRvMkFhMEhlZ0pwd2VYbXlsMSt5alB1Y1pJNmxR?=
 =?utf-8?B?QkNPTTBtNkphdXZsMHZyb2hKMHRVRTkxMFF0VzdtRzBzTTh4TGdtcEdyRzQ3?=
 =?utf-8?B?d2ZGK05TVEVqM2xUYTRsRXJ3ajF6b3BObGJ1c3VMaTZZMlNkWUlsQTMzbFVm?=
 =?utf-8?B?aks2TDBNbVhHS3k1QzY4eE5Dc3NEcm5lZWhZSFhETCtMb0RxQ1VXSkVkR2tk?=
 =?utf-8?B?MXQwVGgvdTJ5elNsV0tjenRUK3pGMjJQZTBlRmJZWExOYzE2T1FjU2Jjc1Nt?=
 =?utf-8?B?MW5rVnZhTWVmY2tqZWZSdWRvZ1h3RUpYYnBibmcvN0crODgrTzZKOS9KU2tX?=
 =?utf-8?B?KzhPSW92Y3JlTzVXakRTL0srd2x0RmEvNmxoSVp4eUM3UVlqYWtWTzhETU5V?=
 =?utf-8?B?S3pUamN4a3MycURvNm40SFBFc2hRNXFTZUY1R0hSTVREWW1kY2hFcHRtdHJO?=
 =?utf-8?B?SFA4UmRqKzVXTC9DSGRlWlZRRUlCRXg5Y0tmWmxLVkNZQ2JYaGgyclFuV0NE?=
 =?utf-8?B?eXNkVk5Hb0ROaHUrQ3ZZeElFYUR1YmNpMktzbHFUVDRQaDgySm1pVys2ZXJj?=
 =?utf-8?B?VU9iWmZCNUdScnJUQTBNd0JhMnNKNHhCN215QjZQMkhPWW4rNVl4YmxIcXJ2?=
 =?utf-8?B?SHZKUDRZVTc5MXF5OURWRTRCNkZkZVBRdnFqenFxeUhFbERzWlBHV0JYbXBW?=
 =?utf-8?B?WkMzNlpjclZVbGoxRk8xSjY4MStYQzJzdytKNVZxaVZYVC9yT01iYnBocU0z?=
 =?utf-8?B?Y1BMUzZsMTE3cmpRSXlOSUpMRmZNcjllN09mR3hBcDVxZElSelJRWmYyTzcy?=
 =?utf-8?B?T20yeDFDV2hjYmNxay9UTzVneEdlUmJVallHNDBJOVNraEVKUjVuN0NvZWkx?=
 =?utf-8?B?bzVQLyt0ZDROL2xYWXJickF5RGVpWDQvWnA0NTZLanV6UUdOQ204R0pQZktN?=
 =?utf-8?B?M2dmT285dnNCMGdHR3JWeGVMMWQ2WVVBZ1ZGTUFUdHhVeWIxVTI4M2UzUHhX?=
 =?utf-8?B?YTBaejBGeE5uUHpsWTFTblJHaytuMWZFcHp4VjFJYWJQbXlZZnhrWWJLK2kw?=
 =?utf-8?B?RExYS251QXBiNUZqcERjUmV5R1dkQ1BXcnhJSVRLSDkvWHFlc3NLTy8rUGd2?=
 =?utf-8?B?K0pzeXA4MSt2dm0xQ2R1eU5KSXl0cDZWcG03cWlycHVGcFlka051OS9hMCsv?=
 =?utf-8?Q?Gpgq6OeJS61IlebNqTozEXM=3D?=
X-OriginatorOrg: amperemail.onmicrosoft.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0f43ff65-4fb5-4772-896a-08db9d3b9b68
X-MS-Exchange-CrossTenant-AuthSource: DM8PR01MB6824.prod.exchangelabs.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Aug 2023 02:59:14.5907
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3bc2b170-fd94-476d-b0ce-4229bdc904a7
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 7Hy+22YNwJkT/KHZKhDmm+Tg08PKuxwJe2s3zXPJHrNFuLDXtEjiN8bStzstRs6Du3wPVb6WRMfG8YxaTWDdMqoTumdf0o+Ki3R2qVw7VGCgb8JTEYGFCx8/aUJsJ0Q4
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ2PR01MB8660
X-Spam-Status: No, score=-3.5 required=5.0 tests=BAYES_00,DKIM_INVALID,
        DKIM_SIGNED,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
        HEADER_FROM_DIFFERENT_DOMAINS,NICE_REPLY_A,RCVD_IN_DNSWL_BLOCKED,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Leo,

在 2023/8/14 18:01, Leo Yan 写道:
> Hi Shijie,
>
> On Mon, Aug 14, 2023 at 05:29:54PM +0800, Shijie Huang wrote:
>
>
> [...]
>
>>> Seems to me, based on Marc's patch, we need to apply below change.  In
>>> below code, we don't need to change the perf core code and we can
>>> resolve it as a common issue for Arm PMU drivers.
>>>
>>>
>>> diff --git a/arch/arm64/kvm/pmu.c b/arch/arm64/kvm/pmu.c
>>> index 121f1a14c829..8f9673cdadec 100644
>>> --- a/arch/arm64/kvm/pmu.c
>>> +++ b/arch/arm64/kvm/pmu.c
>>> @@ -38,14 +38,20 @@ struct kvm_pmu_events *kvm_get_pmu_events(void)
>>>    void kvm_set_pmu_events(u32 set, struct perf_event_attr *attr)
>>>    {
>>>    	struct kvm_pmu_events *pmu = kvm_get_pmu_events();
>>> +	int resync;
>>>    	if (!kvm_arm_support_pmu_v3() || !pmu || !kvm_pmu_switch_needed(attr))
>>>    		return;
>>> +	resync = pmu->events_guest != set;
>> If we set two events in guest, the resync will set
>>
>> For example:
>>
>>             perf stat -e cycles:Gu, cycles:Gk
>>
>>
>> If so, this is not reasonble...
> You mean if set two guest events, the kvm_vcpu_pmu_resync_el0() will
> be invoked twice, and the second calling is not reasonable, right?

IMHO, even the first time is not reasonable. why call 
kvm_vcpu_pmu_resync_el0() when event rotation

does not happen?



> I can accept this since I personally think this should not introduce
> much performance penalty.
>
> I understand your preference to call kvm_vcpu_pmu_resync_el0() from
> perf core layer, but this is not a common issue for all PMU events and
> crossing arches.  Furthermore, even perf core rotates events, it's not

If we can find a better way to fix it in PMU code, I am okay too. :)

I tried to fix it in PMU code, but I am not satified with it.


> necessarily mean we must restore events for guest in the case there
> have no event is enabled for guest.

Not only for events in guest, but also for the events in the host too.

In the kvm_vcpu_pmu_restore_guest(), it also disable the EL0 for host 
events.


Thanks

Huang Shijie

>
> Thanks,
> Leo
