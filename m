Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0CD5377D919
	for <lists+kvm@lfdr.de>; Wed, 16 Aug 2023 05:35:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241634AbjHPDey (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 15 Aug 2023 23:34:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49046 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241652AbjHPDcl (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 15 Aug 2023 23:32:41 -0400
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2096.outbound.protection.outlook.com [40.107.220.96])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 886EF2705
        for <kvm@vger.kernel.org>; Tue, 15 Aug 2023 20:31:27 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=EHvq2hpkn/wHeEHsoFMy2ShuV/K2gH7aoA+7RI7cxkZEQny3sRdLpxO32vtpuIC9kKG6LODkEB4eVr0JgNkUJ02OKprz8U154NMU1gfdH5nhKLbPb3vJzwiTR4QI52OsTpztqpdhpPKhQcH5WkOqj2j1VoQWiEEXTE8xR8/b+q/ZBPjsEswBGfb03JHT19OFfBPI6nKcHfaf9CD48b13ecWgc/DaiwCfUNETj4LH9dCnNKCRu3N5bMuFs73cRtV9GWZoq/66d2TP46xqQgJUE+wZWttxWfgZ0DdOHbHu5HSmDtiCwxwIP2Z0QFc64qDbYnQ9/nNypDymIJtSmsc7VA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=MUX68QX/R4Qpazayrgd2WmfL9cMWPrKWZO7pmGEdogg=;
 b=Zm2V6pXNW9yfhT0aCLEEHJauJ1uvgphf+ZJCx8n4ghHN6O6LnmVLOWNjKwo4n9+bci5C1pWL2GeCfJtKx3n1LIadM5OPUMJW2+tfxYz4TSonFLD/DNSU/MCX+BR9uJtRk6k+FgOMkaePeyZzQNmANc+Ar+HKrLoB0o8hbxnJREhO8uLPHfpMG0CkG0olbLGkoT4Ss1rV7/fd538Cf/phZLjoflMWQ7neBuqOz8xc5mRyBngcZHh6P27lFO7SKvCXiZJts54UzDv67jczlPbvXAuiqNznAOULKdDC/YDC6xAiubtPUwgtJupm4pT/N7fzMKqSGm41cA85p9bAQ3v08A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=os.amperecomputing.com; dmarc=pass action=none
 header.from=amperemail.onmicrosoft.com; dkim=pass
 header.d=amperemail.onmicrosoft.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amperemail.onmicrosoft.com; s=selector1-amperemail-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=MUX68QX/R4Qpazayrgd2WmfL9cMWPrKWZO7pmGEdogg=;
 b=hH8MQ6qi9nupPUk9SOll9CENm7NhIhmWrhNPCSDWrupTrp5K2tx/Js1s1KBJje2fV7JEybGVIElaeyT36yeUEaTRq8GRKuQF7UmZqW3BycSZ/KwByGEXIx8QDr6NOYUG8PLMqTrrZoP/qvTsBY3IdmQhz+e8xEzYhPRUXLMMuio=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amperemail.onmicrosoft.com;
Received: from DM8PR01MB6824.prod.exchangelabs.com (2603:10b6:8:23::24) by
 PH0PR01MB6358.prod.exchangelabs.com (2603:10b6:510:12::18) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6678.26; Wed, 16 Aug 2023 03:31:23 +0000
Received: from DM8PR01MB6824.prod.exchangelabs.com
 ([fe80::d62f:d774:15b0:4a40]) by DM8PR01MB6824.prod.exchangelabs.com
 ([fe80::d62f:d774:15b0:4a40%4]) with mapi id 15.20.6678.025; Wed, 16 Aug 2023
 03:31:22 +0000
Message-ID: <71a7f15f-e81e-a529-b7fe-fb020ebeca91@amperemail.onmicrosoft.com>
Date:   Wed, 16 Aug 2023 11:31:13 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.14.0
Subject: Re: [PATCH] KVM: arm64: pmu: Resync EL0 state on counter rotation
To:     Leo Yan <leo.yan@linaro.org>, Marc Zyngier <maz@kernel.org>
Cc:     kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org,
        kvm@vger.kernel.org, James Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Oliver Upton <oliver.upton@linux.dev>,
        Zenghui Yu <yuzenghui@huawei.com>,
        Huang Shijie <shijie@os.amperecomputing.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Will Deacon <will@kernel.org>
References: <20230811180520.131727-1-maz@kernel.org>
 <20230814071627.GA3963214@leoy-huanghe> <87leecq0hj.wl-maz@kernel.org>
 <20230816030412.GB135657@leoy-huanghe.lan>
From:   Shijie Huang <shijie@amperemail.onmicrosoft.com>
In-Reply-To: <20230816030412.GB135657@leoy-huanghe.lan>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: CH0PR04CA0089.namprd04.prod.outlook.com
 (2603:10b6:610:74::34) To DM8PR01MB6824.prod.exchangelabs.com
 (2603:10b6:8:23::24)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM8PR01MB6824:EE_|PH0PR01MB6358:EE_
X-MS-Office365-Filtering-Correlation-Id: 41c3bde3-bb64-442e-a5c3-08db9e094359
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: jahPFgXNu7EGUSwfQiwD/Ku/iX8WW4DEwVJJv2KUBnaPL+ts1YvUtJoCKjiWnRoZHKq0dYyucQjNXmIQE/ns5zLG2jKGCm3OJPAFPv2BOiu/ASObeqvaUuM6Wg45TribWJ7gDz/VwDIhwGm3OYJhXEd574NtjHgs7/w4y85aMcYIQukLFJG6rC3YVAM074U52W8GyfkFOwZJjTAwY4aQO92ZrjhFOAe1LJxK7gr41jEqC/va3jNEhgnuA4udDxMuW2Z5dynX2i2kBMiis+mZbEwJQ3PocT8B1ED1DxMiff5W54XPf4nACeTi0ue+H3UyZLkpfmOVW4wdtHagXPBs+l9rkPAxtjGODZmjVFpbTeD+ivHWmzozYkr3EsikyNQ2AO3os09B90PfLYsLZgURsCojpm+bRMqhkWQIff7Yj2sSH4qewARlU3767KTQ7s8qYlCyoB/nXdXCSqU5oNTTWlFgCX7qkVBRmWeCK0kQa/t8SdCpJiZfs/L9zpRIAUKKJDq8jg+kwM6F3HxU4PWWtD+DhXMPyntdwnKzADzB+aIZ1uqaGEpKyGGYHxdNsQCLZieihDGvDajBpthTzOQuE0hNv3Nd4CSIXdqrvztvqpgpW0i8UbuB88pMKPxfPuRxjj27ACTfMV6v8PYm9Y7eXA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM8PR01MB6824.prod.exchangelabs.com;PTR:;CAT:NONE;SFS:(13230031)(376002)(366004)(396003)(39850400004)(346002)(136003)(1800799009)(451199024)(186009)(6666004)(54906003)(31686004)(42882007)(66476007)(66556008)(66946007)(6512007)(6486002)(6506007)(2906002)(478600001)(26005)(110136005)(7416002)(5660300002)(2616005)(83380400001)(41300700001)(316002)(52116002)(8936002)(4326008)(83170400001)(8676002)(38350700002)(38100700002)(31696002)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?a0tmcWFpMVpRbEltdzV6YXVZQUR4akR0UDNna2NaOFZ3TVN5QnBBYURGVDI0?=
 =?utf-8?B?amJ2Qkc5c2Q5ZXc1SVJyWi9iSElaQ0N5U1hMcHdUOGhQNFYyakJtRDI4dVY3?=
 =?utf-8?B?dE9hamhiNkpjZjR0RXluTk1qL2ZndzFhN2tGa3NEbzUwSWxjYXFlMEgyRWFq?=
 =?utf-8?B?cXYzUFJ1R2c2RXNUWkZxbksycmdUQndXejlDOEpERkptZnRFMFg4QkJhY0hj?=
 =?utf-8?B?WURrb2tGVDUzYmRBc3FibDFrd0FzWjJTZ0lVYSsxUVpSbjJ3UWw2S0c1Q2Vs?=
 =?utf-8?B?aDFCbVJFdzZKYmVqT0pVZysxYXhiNy94QVF4R3NnTGhIeUZNbjRJZWRac1hU?=
 =?utf-8?B?U1dSTTAwUk9rRmlkUUJ1ZXdTeXFJV2h4RjZwdzhLcWpoUDUySldxYzZQUEgv?=
 =?utf-8?B?aGl3Z2hzRDNka29HWFpCdXRZVEdLSEFHd21XZGQxMEFUZFc1K2tnekJwZ2Jw?=
 =?utf-8?B?V0ViN29YYzFDbS84bXFkR2tHMGg4a0JubS9zSC9Wb00zY1d6b2ltWDRBY1k5?=
 =?utf-8?B?ZVJMZU1tOXI1S1FMVXBOUHlzZ2RXTDJYR2tzOTVwNjZvSVJlMlUwMTBRNVNa?=
 =?utf-8?B?M3JXT3AvaitvcDVsMUFSR3JQSVFOK1RLVGt0S29WTlFKbkFGR1dVODZabFNk?=
 =?utf-8?B?cnhmVnl6allyc2Q1dTRtVDBiVjVMVUIxN0huTk41eUFTcmJDbE1ad3hXOUNE?=
 =?utf-8?B?TnZtYUUvdTI0YS9neDFHdHhRY2JNa2tQSEprU09IeWplU21iWnhyTFM1aGVz?=
 =?utf-8?B?RU5hVzB1SGxzUWswY2M0OHNEMGlBOWFlcUtrY1Z2OUdpQkFHV2RuWklDWnZs?=
 =?utf-8?B?SnRpemtzKzZjR0lwN2VaNytwQ3Uxa2pLZEwxNnZoSDZ2aWZNUW5JSzY3bWlR?=
 =?utf-8?B?VFNEUmw3QUFSeTdPU2FIVGpqWFJSTmY1ZmRBN0FiUXIrQkZMRXBYUzAweHNO?=
 =?utf-8?B?Z1JMNHAwK0FCYjQ1ZjBOYW1WTFR3YTA1QUlTRDU4RjdnNzVzeXZGK01QWFkx?=
 =?utf-8?B?ZzhNVVR2OW9hMXcwRU03eXBqb3pDUnhPaUlMejhqdUJrQTF4TDNUOG95TENw?=
 =?utf-8?B?T1lNZXVnTGhWbmJrUms3ZWNFc0ZlOEg4NzhvOTRiVWtFbnVsNE1XTXZ5Y0hR?=
 =?utf-8?B?a3RiUmoxOG5kN0ZSWVR6QUg1RE1FMGY4YUNrT0lwdVZNVXd6M3V6OGJnY0sx?=
 =?utf-8?B?VkZ1dGZTN1ZHRFEvUTFKN1Q0bjNlU0dnVVFycHNnUnpjR2JaWmhvc1BoRVVX?=
 =?utf-8?B?cjRxdnJpTEQ0M2E0bWFxWXYzNm1RUXZDejZSaC9KSnQvdFNSVmtwV3FYTzF5?=
 =?utf-8?B?WUR1aXU1UlVLUnQzdzJWKzErV1FDNU1QcVVWYjJSdTVXL0VhRWJxVE5odzV6?=
 =?utf-8?B?UmdTdm1ZRE5hZE81UEFTRzBuUHlCWlhjeXNKM2JPTURUSlUxRUVBZnNiUzdM?=
 =?utf-8?B?SDNuMitEeFdHSjVNSUQ5SDR2YlBOK21ldW12V2pMY1BTbHNqRVh3Z0EwSCtB?=
 =?utf-8?B?Y0RGUHNoZzJLbGsxS3plNGpMNm45NHFsMHl0UXJHWnZ5TXlYdGQ3bmJ2NmRS?=
 =?utf-8?B?Mm5Xd3ErZ0tVQ0phbnlIa3gzbE0vWWFzT2NIWXNxRGVIMXByK2JXR3Ewenpw?=
 =?utf-8?B?NzNiYVF2RVBnRVZ2UlpFS0pxUXgvb3pRdUxnTWRzRGU4emdENkJIdzM4amNv?=
 =?utf-8?B?RWpKd081WUNPUXVjVG1zMnkzbG9DKzV1d2dDenhiNHJHV0I2ODZ1b0NKMVZs?=
 =?utf-8?B?UmFYa1RvRHBVUnQwd0ZhZG9vV29MMXlET2p6bnpNZ0NBS2VwVXc0bTdqVW1W?=
 =?utf-8?B?MkxBM2VlT09WdkpGSlNLVktPd09PM2l0N2dEWDJhdWlHQXVGcXhQT2dOVjhN?=
 =?utf-8?B?Tk5rUFFtQTlWSlNXZFVHQ2JXVDgzaENYU0NWYVllRU5rbmhocHpWYlhDN0tr?=
 =?utf-8?B?UkZBaFppbGpKM25zME9HU3hScUg0dVVMZzJ6c0NlZ0xkMy85SC9OTTZTN0xw?=
 =?utf-8?B?Z21LS1JydEdIdUdaODNkU0NTUG45dHk4enlkd0plMXM0S1Q3UTdMcFdES1lU?=
 =?utf-8?B?WjlmVEVoVmdWVmNWZ1B6dmRrRXFHYXYvRE1oNXBhS0ZDMXg4Y1BDS3hEaWRa?=
 =?utf-8?B?c2pMTjBwYm85SEVyL09HVDlGc3lTMWhVTEVwUHZlS1F2VDdHWlJmYmxmTU92?=
 =?utf-8?Q?qRAa5NJdPzREP4vET91Hi/0=3D?=
X-OriginatorOrg: amperemail.onmicrosoft.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 41c3bde3-bb64-442e-a5c3-08db9e094359
X-MS-Exchange-CrossTenant-AuthSource: DM8PR01MB6824.prod.exchangelabs.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Aug 2023 03:31:22.6683
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3bc2b170-fd94-476d-b0ce-4229bdc904a7
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: NnJNEqJ2Vj/iUxj1GFepStwNpn/Euotcytu+Sm+SivtS9EChFvDHC05Zf8zdAhvQQ3gOILsDtO9pL9Mfi2SqaJdBledDFxemcSc+SilhsR9Iz0q6C05pTpgF2aYVfmtA
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR01MB6358
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,DKIM_INVALID,
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

在 2023/8/16 11:04, Leo Yan 写道:
> On Tue, Aug 15, 2023 at 07:32:40AM +0100, Marc Zyngier wrote:
>> On Mon, 14 Aug 2023 08:16:27 +0100,
>> Leo Yan <leo.yan@linaro.org> wrote:
>>> On Fri, Aug 11, 2023 at 07:05:20PM +0100, Marc Zyngier wrote:
>>>> Huang Shijie reports that, when profiling a guest from the host
>>>> with a number of events that exceeds the number of available
>>>> counters, the reported counts are wildly inaccurate. Without
>>>> the counter oversubscription, the reported counts are correct.
>>>>
>>>> Their investigation indicates that upon counter rotation (which
>>>> takes place on the back of a timer interrupt), we fail to
>>>> re-apply the guest EL0 enabling, leading to the counting of host
>>>> events instead of guest events.
>>> Seems to me, it's not clear for why the counter rotation will cause
>>> the issue.
>> Maybe unclear to you, but rather clear to me (and most people else on
>> Cc).
> I have to admit this it true.
>
>>> In the example shared by Shijie in [1], the cycle counter is enabled
>>> for both host and guest
>> No. You're misreading the example. We're profiling the guest from the
>> host, and the guest has no PMU access.
>>
>>> and cycle counter is a dedicated event
>>> which does not share counter with other events.  Even there have
>>> counter rotation, it should not impact the cycle counter.
>> Who says that we're counting cycles using the cycle counter? This is
>> an event like any other, and it can be counted on any counter.
> Sorry for noise.
>
>>> I mean if we cannot explain clearly for this part, we don't find the
>>> root cause, and this patch (and Shijie's patch) just walks around the
>>> issue.
>> We have the root cause. You just need to think a bit harder.
> Let me elaborate a bit more for my concern.  The question is how we can
> know the exactly the host and the guest have the different counter
> enabling?
>
> Shijie's patch relies on perf event rotation to trigger syncing for
> PMU PMEVTYPER and PMCCFILTR registers.  The perf event rotation will
> enable and disable some events, but it doesn't mean the host and the
> guest enable different counters.  If we use the perf event rotation to

In the event rotation, it does mean the host and guest use different 
counters.

Please read my previoust email which shows an example. :)


Thanks

Huang Shijie


> trigger syncing, there must introduce redundant operations.
>
>
