Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5045E77B584
	for <lists+kvm@lfdr.de>; Mon, 14 Aug 2023 11:31:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232753AbjHNJbY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 14 Aug 2023 05:31:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41284 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236148AbjHNJah (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 14 Aug 2023 05:30:37 -0400
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2136.outbound.protection.outlook.com [40.107.244.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 18058E6E
        for <kvm@vger.kernel.org>; Mon, 14 Aug 2023 02:30:07 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=A85TlHHuD4dQvhI4+CqPION2k13sVc9Gf603d/wmlcCB6dO9/echX793wstkqCeVmlBr7qwPtS0Q7M0NTA7SkR8+54LxJxOi8voAQ9XQVgCoTxU/970Ckb6DRUZ7wkvt6IbWqVdPjHrTwDqfJ2iyQgBYJSE2plPmzHKbss8PXYFTMU+Nu0xDOkM3NGTvcMIa/JhWaN94opMvw+nHkiC0Y+JqyOkiig+9+fxTUFVLFFkatpgY3T8MeNhdcFb9kIk3yfr4EzcTk/XQhgziKnEwRztOipdO+zSOg769bNilmRSnC/Sr9GS8h5S822C/zUxJ5X9YxS14PNAPRAKQKzXjow==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=QQipDltr4FUPICRwhEVfAdn0hoJxLGRLHx6VNMWYlzw=;
 b=CVxVlwsGagw4Yc6dhOOsnLTyDN4pzvcYGG3d2FhC+dN1VUpOJ1Cy//gQSeJk8KFtygX1Tm5s53HmK9LR8mJ0C38bzFTIGP1SqMclcddh7I5JDGLOUQ5pQqQT9o91sssOM3jh1Zj2ZtYuC/L5we35CLDgcqPMuKNtyXv9cOAT+rL0KVeJ/5oim0WJTSS8PysgQ8fhvpOu5FKBbh+nMUuYcFi73XRZqEOqgI/bEMxvvc1tLJXy4rJFeZ/HWCVy7O9JV/Asq5goOkiFtgEzwecKQitU9J6Z/3CoiKpMWAUOCKAEnZMmhLD3maetX5z0c/cxOsMwfNzpK9yXINKfTVwqGw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=os.amperecomputing.com; dmarc=pass action=none
 header.from=amperemail.onmicrosoft.com; dkim=pass
 header.d=amperemail.onmicrosoft.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amperemail.onmicrosoft.com; s=selector1-amperemail-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=QQipDltr4FUPICRwhEVfAdn0hoJxLGRLHx6VNMWYlzw=;
 b=C8yKpLlh7QORUzriQYgTgTwwZGRc743KWyLKptPDl5WNSBP4lx4SHonXVC6fTLz0Id/bnqaRSwOQUfu9WdDDLVtnmTa18ZqhzhFq9HCIri+XZjUrRej3Q0K+m8HpUVftabdfgehTlBusL18lQhgwqkp2fGx19dwownx78oVQ/+g=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amperemail.onmicrosoft.com;
Received: from DM8PR01MB6824.prod.exchangelabs.com (2603:10b6:8:23::24) by
 SN7PR01MB7901.prod.exchangelabs.com (2603:10b6:806:34e::10) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6652.30; Mon, 14 Aug 2023 09:30:04 +0000
Received: from DM8PR01MB6824.prod.exchangelabs.com
 ([fe80::d62f:d774:15b0:4a40]) by DM8PR01MB6824.prod.exchangelabs.com
 ([fe80::d62f:d774:15b0:4a40%4]) with mapi id 15.20.6678.022; Mon, 14 Aug 2023
 09:30:03 +0000
Message-ID: <8640c3c7-b117-5754-6ac4-910988e5374f@amperemail.onmicrosoft.com>
Date:   Mon, 14 Aug 2023 17:29:54 +0800
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
From:   Shijie Huang <shijie@amperemail.onmicrosoft.com>
In-Reply-To: <20230814084710.GA69080@leoy-huanghe.lan>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: CH2PR10CA0014.namprd10.prod.outlook.com
 (2603:10b6:610:4c::24) To DM8PR01MB6824.prod.exchangelabs.com
 (2603:10b6:8:23::24)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM8PR01MB6824:EE_|SN7PR01MB7901:EE_
X-MS-Office365-Filtering-Correlation-Id: a4d584c6-fae3-4923-b73b-08db9ca90a27
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 5D1ekvkyowieZ1RS1A8A24NQ7r5vU+8XuLTXjFTNhz2Ru8cqHSwWJ/OdofxIJO7vPTziouMTvCLcUrOizcrWJOJjyBIVLIexit0D4U4IvTx5Znl33hjUehJuUKS4vdQsDikkhYXuYph1v6Dt0+WrcWNEfEWXlwuSRHFBWXSyJZolJpw8VGO8SkoQOpht/clU1xMCTMbB3Dd3Wel7PJQDScEz0MxEE3ZOVh+A7/GVx1vuDJsGa/74WLdLTDQ78KYJMphjSabrsYUYTmk7o63qoN3zLv1T/QBV7lVw/vt03spMSri5VAtustx5tQYqW8am4VqMMSRKsOqqlmrAN41ZpNwJ7e1SAuQbFBV6LHc1DITw/UsCgysyWYals7DZz4CIoYVAd5kBBvAPOpZj28dlXWJN3nLZiPrvBsEQzyCkoVjZgqVbRCyYhHazuYJvH7G5Yu98Op2igL4Sm9YdLQAiHGEZIJNDaMKBoDNs74mKKqG9xo3E202bIfOA/ai0vn6Bt0r2wFPBAZzrR9w2YzB//Wr4YUeEauxOU+BxG93Fa5oKMwYcE8mnTDrIuVefmi7tJpl+lR1IDp2e19UDnDuPc9Pb64rfe3FMs4VOzrUl7jXOSSFA+VRdQb0zV19jmlfqAVPBPM7w/xruF09IxMyqOQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM8PR01MB6824.prod.exchangelabs.com;PTR:;CAT:NONE;SFS:(13230028)(366004)(39850400004)(136003)(396003)(346002)(376002)(1800799006)(186006)(451199021)(42882007)(2616005)(478600001)(31696002)(6512007)(2906002)(52116002)(6486002)(6666004)(7416002)(6506007)(26005)(66556008)(83170400001)(316002)(54906003)(66476007)(31686004)(6916009)(38350700002)(4326008)(38100700002)(66946007)(41300700001)(5660300002)(8936002)(8676002)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?cGhzQmM1NVJxbVM4MDBXR2tOTWkxZXNEb3hhQjd5MDFCaXBrektSbmtBbEY0?=
 =?utf-8?B?V0RkQWU1RVFmWUFnT0ZvYTFvS3h6cVBWeDNWR2ZwbnhIYVZuOVJRV2dwZ3d4?=
 =?utf-8?B?aTBmVWpxV1VJYkMzVHJyK2ZrNVV0dGExWHJ3NkpnS0JPRzhsZ0F4ZlhNcGZ1?=
 =?utf-8?B?aDMwUjR1UlRDUWZ2VHdLQVNPUkNKRCtxUkpMelRaaUdBZzRhRW9mVnE1Z2dE?=
 =?utf-8?B?RXdSSnFoZ0Y5YVBXMnVTUm9jOU1sWFo1U2RRZFR0ZmNickxnUzJ4elhLS2Fv?=
 =?utf-8?B?NFBpeFBCeER3cXpPMWcvNmxpOVhZbTdxWlArUmh5c2doSlF0K0I4UHQraUFa?=
 =?utf-8?B?dWVZY2ZrL3NTSEs3Z25ZVDh1aDFDRFFaSEVaREVQcTRISDJFMXNrQUdVMjFS?=
 =?utf-8?B?amsyc3BLSSttdURScTMwaFNDck5GbnpoeUUweExQMmtERm9YTVhGY1RPdGtm?=
 =?utf-8?B?NmhjNmFnNEI2RUxPdCtFWXlNcGZIMlJhdFBGa0dKSENMWUZ6N00yTVVWbExk?=
 =?utf-8?B?bHl2bDI4M1ZyYTA4cVZkYy9Va1QzeXlwMjB4UG5nNU1aRUR0Z1JRcTMycThT?=
 =?utf-8?B?Z0ZSL2pXQ1JZTXpIU3NoWENBT1d4T0FoUFlORnVLeVJnRTAvZ056SEpjTm44?=
 =?utf-8?B?RnhPZnZPdzhYd0h6TUhoL3JoLzhZVTB5Zjd4Tm9kMEUrR3dQSTNoSmR3ODNk?=
 =?utf-8?B?ZGJMcjhCWUNvcEFFYWgyaWE4bDdBc2dLY1hUeFBQd1hCN0N0ZEF1MjNkbHdX?=
 =?utf-8?B?ejZpdkF5ZWNENG9MVTlIWWswb2FBMGtNSkVxekxCeXlHaThDeFFDRW9CV0ZK?=
 =?utf-8?B?RmR4MkdJWkJ1d3BocmQrRlZRMmxhVHUvaHpUSFpQTHJFUzlFUkEzb1IvYWtD?=
 =?utf-8?B?OXFuaUZKNWpvUGVWU3pzSHJuSkdYdjJrejB2TXhVUXRzM0FuYm1uZjAyLzVo?=
 =?utf-8?B?dkxRUGVYNUtOQnJZS3o3MzVtNWJzRUlDTHVXVVYrTm8vSFAzQlJmVGoxQkUx?=
 =?utf-8?B?b2pxQ2VPS21MT2NabzdvWmFFOVNTMHFpOEdBU1ZLbG5EbTBjVUZpSm80SDQy?=
 =?utf-8?B?QlVtUnByYzhOQ0ljN1kvcnhOVHdCY1ZZeEswMUdjekNSSzlWd2s0REY4SWdh?=
 =?utf-8?B?VGkwOUdsT0JKRTVsTksyaDhxaFIybDBuUnFHMEFOOVJUUVc4K05pNHFyQ3NR?=
 =?utf-8?B?Q3Vqck9rSndYYS80aEN1ckIzSUdzZmxKcDJLaUU1KzhCZ2FyMmwrcGRrLzd3?=
 =?utf-8?B?UWxUWGIzUWFCcFlrekYwTm5PVGV3Q2VQVFZCSmRXNlkzQkVsL21lR0dHOUJh?=
 =?utf-8?B?emsyNWlmWGx5Z25OMkpjSnZjYmJtdjhyNitGalBlTWtTVnFNeG5tUld1c2t5?=
 =?utf-8?B?cjF2OExPU3Mxem02Wk9hanRSZ1VyVXhkVGxFVkt6VldKNVk4RFZlTmQrYkU4?=
 =?utf-8?B?RGpwZkRNSnNUbVFwMEdYSlBhbFRGYjBiSmRuVE91cUxJZ0syMndObDFJdEVB?=
 =?utf-8?B?VDM2dlNOTmFReXdoK0Zuam1aMjBXL3gyYnlSZG1ocnJ1N1hYb2piRkwzemta?=
 =?utf-8?B?UFdpdDc1V0lLVnBHNDhkb3h4bEhTajRxVzdnaWt0U2ZrYTlZUEoxZlBkS1cr?=
 =?utf-8?B?SWVIZ1NXUWFyZ2FDRW1lcTdoWlF1UlV5azd4NE9YMXJMeUIyaXJaRGEzTXFH?=
 =?utf-8?B?bUpxQThwcGZZOGlTYi9DY1laUDl6NG5UZjJJZUJUcnpCNkYrR1lFR2hYUU5u?=
 =?utf-8?B?eEh6R0xQMEppWVRNWEFNM2w1T211NDZRcXRpNlBuRksrZ29KTk85eVYydXdp?=
 =?utf-8?B?MFd2N29tdVpwU3dqTHVxdzdZNTFkYTB6VE1naE1pcUw2NU5YS2k4cVNINFJ6?=
 =?utf-8?B?NE5mN0MzNWhMKzU4OU5ZQXdia2FBRVpMRFViNGJjeHJIdTlZdzUzWlJxQml0?=
 =?utf-8?B?K1N2Z2hIdkV0ek1CQTlpdzhPUEpYZWluZnFiL3JGTGs1eFUzUDE5QnJPOGt2?=
 =?utf-8?B?d1FBNXh0bGhSRGpEMHFyMnJjd2NieUF3NTIrNWJYQS9zbjBZRE0rMkpnaHN2?=
 =?utf-8?B?OFhCcjIvT0l3MTZiaCtHMklQSmtXbnVLZ29sYmZVNDM0Wm43SWg5czJmMUtr?=
 =?utf-8?B?QlpkSDJNNGZkTGtGT2NkWlFjaW1TT3RxMEZQVURUWmE4elJiQWpGSUEzRk50?=
 =?utf-8?Q?+OzC80+EtZ7Mn19s1Jqf4ko=3D?=
X-OriginatorOrg: amperemail.onmicrosoft.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a4d584c6-fae3-4923-b73b-08db9ca90a27
X-MS-Exchange-CrossTenant-AuthSource: DM8PR01MB6824.prod.exchangelabs.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Aug 2023 09:30:03.7922
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3bc2b170-fd94-476d-b0ce-4229bdc904a7
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: KDqx7PRMBAk/XCT2fp5gzhPRe2eG3rYbkSfDBP/1Mx1ZDf27IExjLNG90Y+FM7RoZXUqzIA6EsuhTvntBRlNrWow+qmH5w906Xk9KNiRAhKAnqR5Y9dXye4orDoAxRyY
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR01MB7901
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

在 2023/8/14 16:47, Leo Yan 写道:
> Hi Shijie,
>
> On Mon, Aug 14, 2023 at 04:12:23PM +0800, Shijie Huang wrote:
>
> [...]
>
>>>> Their investigation indicates that upon counter rotation (which
>>>> takes place on the back of a timer interrupt), we fail to
>>>> re-apply the guest EL0 enabling, leading to the counting of host
>>>> events instead of guest events.
>>> Seems to me, it's not clear for why the counter rotation will cause
>>> the issue.
>>>
>>> In the example shared by Shijie in [1], the cycle counter is enabled for
>>> both host and guest, and cycle counter is a dedicated event which does
>>> not share counter with other events.  Even there have counter rotation,
>>> it should not impact the cycle counter.
>> Just take a simple case:
>>
>>     perf stat -e cycles:G,cycles:H, e2,e3,e4,e5,e6,e7 ....
>>
>>
>> Assume we have 8 events, but PMU only privides 7 counters(cycle + 6 normal)
> Thanks for the detailed info, now I understand it.
>
> Seems to me, based on Marc's patch, we need to apply below change.  In
> below code, we don't need to change the perf core code and we can
> resolve it as a common issue for Arm PMU drivers.
>
>
> diff --git a/arch/arm64/kvm/pmu.c b/arch/arm64/kvm/pmu.c
> index 121f1a14c829..8f9673cdadec 100644
> --- a/arch/arm64/kvm/pmu.c
> +++ b/arch/arm64/kvm/pmu.c
> @@ -38,14 +38,20 @@ struct kvm_pmu_events *kvm_get_pmu_events(void)
>   void kvm_set_pmu_events(u32 set, struct perf_event_attr *attr)
>   {
>   	struct kvm_pmu_events *pmu = kvm_get_pmu_events();
> +	int resync;
>   
>   	if (!kvm_arm_support_pmu_v3() || !pmu || !kvm_pmu_switch_needed(attr))
>   		return;
>   
> +	resync = pmu->events_guest != set;

If we set two events in guest, the resync will set

For example:

            perf stat -e cycles:Gu, cycles:Gk


If so, this is not reasonble...


Thanks

Huang Shijie

> +
>   	if (!attr->exclude_host)
>   		pmu->events_host |= set;
>   	if (!attr->exclude_guest)
>   		pmu->events_guest |= set;
> +
> +	if (resync)
> +		kvm_vcpu_pmu_resync_el0();
>   }
>   
>   /*
> @@ -60,6 +66,8 @@ void kvm_clr_pmu_events(u32 clr)
>   
>   	pmu->events_host &= ~clr;
>   	pmu->events_guest &= ~clr;
> +
> +	kvm_vcpu_pmu_resync_el0();
>   }
>
