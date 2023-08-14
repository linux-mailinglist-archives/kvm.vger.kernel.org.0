Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 942F977B541
	for <lists+kvm@lfdr.de>; Mon, 14 Aug 2023 11:16:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233448AbjHNJQQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 14 Aug 2023 05:16:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48246 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235686AbjHNJP7 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 14 Aug 2023 05:15:59 -0400
Received: from NAM04-MW2-obe.outbound.protection.outlook.com (mail-mw2nam04on2113.outbound.protection.outlook.com [40.107.101.113])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C527D12D
        for <kvm@vger.kernel.org>; Mon, 14 Aug 2023 02:15:56 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Eoau669Mfng5Q0q54TFE7NX/V9T8UF/iyI37lGDxKjIX9oPLCKD0ycDTDKZanUdinnUdtnr4tJriaQTHhEOZ5gfEo8k9cVGrTTi06/ZSURHmjoZcuWqZcXopS5sbRrMsmP89YbjB3dhk4a7JKOC1zDB8hi69F5DqfpXWK1Rg84vldSC+/E5UkrWixwo/at3SPE8HDj9miGbug7g5jOycmS9hYwhcShm8oyv0UvJzoFYoU8hnoZcK3HUy3pHYB5jqB/NkNHkFq0fBKbobkYsKrSYSlrcTE2v+K+qvjV1Jjh4jy0j6UsHEC4ySjkwHcFAIWKTuzXJqLDR2oIuAGiJ/Ag==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=JbD3Gssg+b37Inau5vhHNm6JrVv8ySlM1m0v1aezCzI=;
 b=oZqH7f7Nbis0l6cKl/hj5Eth8sKy/Aq7411LkWzIlgJYhg7E2QdFpnt7t9mWA69hzSzppbDF1LnAQD4qgt8MEapuAeI+VzXDxjHZM2FWDwM02Dwfcl9HZc4v/araryXOeI5rYNmfq4yg0O97i8PwISMvjyPSrHXkzNNRq2xzZ1fH5HkIBA00q4RkfupxyED7684g379RoHYIPso5k4YnLmolmRB9CBKXgZKR1+RvNI4SMTkttGCO1DoRI6ixCBf78heczlo4UBQuAmnyXLWQYG7sUunVmiapsyIS04XNLQzZYD1ArLYG3XcRzfLHmrZQ1VhTo5r1uLF6eRyT1hcYmw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=os.amperecomputing.com; dmarc=pass action=none
 header.from=amperemail.onmicrosoft.com; dkim=pass
 header.d=amperemail.onmicrosoft.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amperemail.onmicrosoft.com; s=selector1-amperemail-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=JbD3Gssg+b37Inau5vhHNm6JrVv8ySlM1m0v1aezCzI=;
 b=Vjb5v3AXcccP1xd0IxqAHYzzd0UxhN+A5dW3xA5UUaEtZP60MnhVkVX9PAnUlnx21dZrcufSq8gaIqQu252iCpOUDK0OYyYsrEc4u0w48CqbN/bAoA6owwwFCcnpIkLWnMynEB39Nfqf+XfjoRhZeuIlSitqGlq2HSBNpYEnT4A=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amperemail.onmicrosoft.com;
Received: from DM8PR01MB6824.prod.exchangelabs.com (2603:10b6:8:23::24) by
 SJ0PR01MB7330.prod.exchangelabs.com (2603:10b6:a03:3f6::23) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6678.24; Mon, 14 Aug 2023 09:15:51 +0000
Received: from DM8PR01MB6824.prod.exchangelabs.com
 ([fe80::d62f:d774:15b0:4a40]) by DM8PR01MB6824.prod.exchangelabs.com
 ([fe80::d62f:d774:15b0:4a40%4]) with mapi id 15.20.6678.022; Mon, 14 Aug 2023
 09:15:51 +0000
Message-ID: <8dd10018-fb29-d98b-82d2-143b086a6285@amperemail.onmicrosoft.com>
Date:   Mon, 14 Aug 2023 17:15:42 +0800
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
X-ClientProxiedBy: CH0PR03CA0224.namprd03.prod.outlook.com
 (2603:10b6:610:e7::19) To DM8PR01MB6824.prod.exchangelabs.com
 (2603:10b6:8:23::24)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM8PR01MB6824:EE_|SJ0PR01MB7330:EE_
X-MS-Office365-Filtering-Correlation-Id: c284a98a-900d-441e-70b0-08db9ca70e11
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: lCzSSpwNHHTl9nmoUIbS2U664q8bFT2guoRyp7DgKtLl69AlBHN7+hm8eSYDYFIlI0j5nJQ275KBHm85BSJeYRwTmuxPazd8JeVrNBHrSAkmYX/8yfgY9AISKugLAPunBz6QM59yfExzMsUikINE7ccThRls/1ApTszsUwwxEYmfXAlojjKWchWZTJ6EQa7XqJxquEzRR7ZFzWFbJgXbQ0/rLWw2Ukg5HPKbbcws7jx72pu+W5mJGpf5lS4VsP/1/KGByZmsr2U5m/FXaAzpcFOxc3DM09TYNXlSF0PeF/VZFWsP5pLoh4XhpLaq6RO3pzxUqAc8UFUM3hXDjmlpttznHL2k3DgcVrASw+y+4+zIJskmPn96v5EoqmeBA7kIEtyUZq1uWY1s56GQiIoOAPxWbA1SPKxaPTm16K0u2e5iQZaigtN2zs3gZHSiwjXAPjVgx2SikZLZQUD7Ml2pUFu15hx7vKpvFsjYSpF+5zL/9b83A20x45itnVdsc/VYLQToDMa3yBAyJvnZkGQaJcbYooKZusPvB6Hgs7RYp1TobacbYrdY2DI7XUXARQ+/vwFPtbga5AjV/oY0dfAUKwXUKYnpvfC9Lnu99IZVj/1Q4CZKqYPYIBvOj8swDZ4Zg2BHLq0ojvBYp+XtWe4wMg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM8PR01MB6824.prod.exchangelabs.com;PTR:;CAT:NONE;SFS:(13230028)(396003)(136003)(39850400004)(346002)(366004)(376002)(1800799006)(186006)(451199021)(31686004)(966005)(6512007)(6666004)(52116002)(6486002)(31696002)(38350700002)(38100700002)(83170400001)(26005)(6506007)(7416002)(2906002)(478600001)(54906003)(2616005)(42882007)(8676002)(66556008)(66946007)(41300700001)(8936002)(5660300002)(66476007)(6916009)(316002)(4326008)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?aVpYbUlHNGNVVWI3Slc5VjVVWnV4WnBFS1pXMUZHYUFCTnhWS2hiMkd2eEg0?=
 =?utf-8?B?N2R1R0JPR2lNVk9JbWpHbTF4Ui9oZ0FoR3BNZFRQbjNhSTJPWUVYQ3NRMnpS?=
 =?utf-8?B?QWo2dk5KeGdTY1F2U3RkSi9BVzcvNVkwZndRRWVqQ3k1dWVSdndJMHkrckxO?=
 =?utf-8?B?RmJKWWNmYzhkWG9ETWo1ZStENHA4N3dRWWErWVB4RlZxVG1nR3ZBVFVuWlMr?=
 =?utf-8?B?VkxZVzBjVENHYVlCaDhiVURkRnpQRG95WDRMTmVVaXpxdXNyQW8xbTk3alpk?=
 =?utf-8?B?RTZWTDYzQ1lVaEtBajFFU096WHRGV09sWkl2cFd5U3hYb1ZNdTljQlNHcy9v?=
 =?utf-8?B?VG9aVDdYZ0FPSGYvR29Mc1luMGw3bUtHL2x5QzhCSXRuRDBpVFFCNzZMclJl?=
 =?utf-8?B?VU5zWGhtaHEwTXJFVkYyWUR1MkVxQi8yOXlIUlhjMVplSHgzNHdFQ3RYNFQ5?=
 =?utf-8?B?cVk5bVB0TmtJVE9rM0tzNTBIbFhqSjdDVVNjZ3NkZ2REbHJNcnV4YnpCQlpR?=
 =?utf-8?B?S0hmcnNockFmWUxuL0NJeDVxdVlCVERDbnowSzc1akRRSjVwaWJOc1JpY3hZ?=
 =?utf-8?B?a3NZRkpRQjF0S3F5Vms3QWxmNTlINTVNTDVUWUdNckU5YjFxeXVyS1k2MFlh?=
 =?utf-8?B?dlVUYVdEN0lRNE51empoRmx3K045N08wNGJvSnNUMTgrUTBMTU1hZllzRTUx?=
 =?utf-8?B?Z3dzRlZtYUpieVQvY3dreGpVengyMDM1VzNXUHdXYURsL2tSS3pWbERsV2dm?=
 =?utf-8?B?ZG5hTHhtRXlnay9SODBFUDJ0Z1hjcXpvd0lYdUJjbmY4U0NBbktUVmJET2Z4?=
 =?utf-8?B?NGhabERiVVlvUzV6RnZQL3dOSjFWMlJPNGk3Kzh4djFDeC9kWGpTdnQwUUVH?=
 =?utf-8?B?YUxBR3ZIRk5EOUhOS2NEOWt6ajRtNXgvSHl6a01tYXBpRnAwV1ZsTlhOK1dh?=
 =?utf-8?B?NFh2RWNCaTNVR2ZkMTU0cHRTTldZenhqYUtZTlV3bWNia2xwZW84SEl0MVln?=
 =?utf-8?B?cDB1ZWxaTFlMSUh3aXIyV3VFM0gvUzZ4YWkzMFRkMktWNkdOYU9lQXFxaUJu?=
 =?utf-8?B?b2xtQXd4Tk05UDJwRGpFTXNwRXB4UWY4UVZYR05hV0VTSWJuK2wvVi9aOXpn?=
 =?utf-8?B?N3BVMVlpQjdKSXphTzlWVDdxa2dZWmpvVit2VzJydHhTcWJocEk2elZrdU5l?=
 =?utf-8?B?bW9TSHdOT0EvamhCWXFyK001MGZBT2IxSWVEUjBuODhGeWtKN3VsMFNBU3VY?=
 =?utf-8?B?ZkFrRzI1a3pyWXhsdmpVUWpMTzRWayt6VnZwaTNXT1h4VGorSHVaNGY0c2dX?=
 =?utf-8?B?UiswM3lPNlZwTUN4eXhIUGRMQ1VIVG1rMkN2Tkt3U2U4RDBRUWM2aUVpTHND?=
 =?utf-8?B?V1JxQjFha3VwcVRneWE4NUNtUm0wRlp4dkNYTDYrckFVSjV2aGxNbVNGYjhQ?=
 =?utf-8?B?Z2k1N3FtV3E5VWVoTUhORmNkaHFZVFdtbHRiTlU4MDdTNVo5Y0pmb05rVWpn?=
 =?utf-8?B?bEJkNm40YUVpU3lLdXJCdkNyUHlwcHJUZHI4bkJxSzRQN0F4RG5xMjBvSHRV?=
 =?utf-8?B?QkVPWCtkSHUrVldYME5hQmh4TzZNUGxad0xKY3VtNFRoRGM2SEdYY2hJNTIx?=
 =?utf-8?B?eXBDeXFWejhlNGRUOFl2MTNvTnk1djVWV21TMVhnd3k3UG03ZWRlLzlQVXd3?=
 =?utf-8?B?UThCYklnRGVJQ3lwV2ErYWdyVHlJN2dsNS9uT0JNWFFlbktoUkhXV2x1SXNr?=
 =?utf-8?B?cVZSbU5WUWlnaHhqU1pCY2V2N0ozd0VUM1lRSy9BWlVnN09lWnVXSkphbThs?=
 =?utf-8?B?Q0RDZWgyNHhvSWY2RllrZGxTTDB1aDhvNE9ROFF1dld4TURMY2taUk9aL1gz?=
 =?utf-8?B?U1JjMFRQbkFpYXdKR1Z6V0JRU2VHV0FSNnZhdk9lYTZMaVNsSk5CMjU0TkI1?=
 =?utf-8?B?ZnE4N0l5TDRaMk9lT1EzRVFLUzFmVGg4MnpuQUMrdnFXQkJWaXIxLzYwMmJ4?=
 =?utf-8?B?SUZ1V3IvZjBpcGVRV1ZsNVF0dWJxVVlGK281OUIwOERDWUFKMkhUcElFazlH?=
 =?utf-8?B?b0VDczl6RnlwblRqUEJZejVTTTZ5WVFycnRuT3F4d25IUStuTldPWnlwNWJN?=
 =?utf-8?B?c011TjZRSTRXTHBXcGFpSDNzZWUvbEtNRWh5Zmc1d2wvWVVuajJRTnpkaDI5?=
 =?utf-8?Q?/DF4joXpsxWz9go/j7z2/Ok=3D?=
X-OriginatorOrg: amperemail.onmicrosoft.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c284a98a-900d-441e-70b0-08db9ca70e11
X-MS-Exchange-CrossTenant-AuthSource: DM8PR01MB6824.prod.exchangelabs.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Aug 2023 09:15:51.3658
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3bc2b170-fd94-476d-b0ce-4229bdc904a7
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 7axRIzv76DGVz5Qksg3stAAzc740VU73gVSgLbzfPkjeN8JMLqBchkprnTtRrN9tjFz59r6DZJEI9JPnux2kWDLTdiSBUatTpnoWe7JtZEmg4X4GzyETnKyrwI5iX933
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR01MB7330
X-Spam-Status: No, score=-3.5 required=5.0 tests=BAYES_00,DKIM_INVALID,
        DKIM_SIGNED,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
        HEADER_FROM_DIFFERENT_DOMAINS,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
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

I am not sure which one is better. :)

My own latest solution is v3:

http://lists.infradead.org/pipermail/linux-arm-kernel/2023-August/859377.html


Thanks

Huang Shijie

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
