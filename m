Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7771077C87F
	for <lists+kvm@lfdr.de>; Tue, 15 Aug 2023 09:25:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234809AbjHOHZI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 15 Aug 2023 03:25:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48620 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234771AbjHOHYe (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 15 Aug 2023 03:24:34 -0400
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2125.outbound.protection.outlook.com [40.107.93.125])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 98711F4
        for <kvm@vger.kernel.org>; Tue, 15 Aug 2023 00:24:32 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lt1MIbszIPT8vxEms1LERcPxxqXKJjANouTF+4vB2jFJhW98Qor3/fVlxtkhSZG2AdH8XvGIb0QqILvqmXLdwkM2gcNpbrWi7MmAYVeebXIE7uqxAqHWw7dyn6lYoCUYzo23SEs1WUcd1B92qxoug8/SP1xlkzswaZ5L6Tx9HIFxP6wGjATZ5NUIveLtotOD0+FRwwKO8pizFSiOsEt3F/8WfDqw+uENqVND744+384TUDsIykmep9St1rsgpChhP5BsaKU9sPY8PM91vGfs8+p6h/PYQAHKgtgccL0w9M/EinXKDXSmagV6tU4SBfiksbklHddFjUbShyEr63bdLA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Qig99UihoqRsVrvoPEbekC86kU+VhDhkNt799FPy7bU=;
 b=C058VjTMqiAoZmHgYmE+rIuTLqKYi0LkBOuQmFa8Rch/8wWtefNIPdrI/tWvwYX9AvzGGmWBfvwwOB1onDX8bv+sKOEAbdSW9eCox9OdC/AJK9rPNx/uST0cqKwSquDhF94YTUmhzWGOT4YnQL9vGMH0QD88NfiMXgzPP5gphFLmNlV/eSKMgGlafufaogiqFNa5UwuZ/nDjiSOpz4EMQG4IoCOF/FeDJgT2vIWyicYhmkaY75lfRu/Riodt60ZxU1OGMVJDhE1ERn1EtUC8WmRx2qPzNhPfYz1HSf2xRpbY/sJEjxiVIwcyiDil3RqCBZFEZb1DvxoLjn6BfyBpxg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=os.amperecomputing.com; dmarc=pass action=none
 header.from=amperemail.onmicrosoft.com; dkim=pass
 header.d=amperemail.onmicrosoft.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amperemail.onmicrosoft.com; s=selector1-amperemail-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Qig99UihoqRsVrvoPEbekC86kU+VhDhkNt799FPy7bU=;
 b=OdAm2YmTU7whd1MLHKA39O7dUCc7SYIvBypgMcfGStnnnDO8k2V7A8J+FB4kNeQxlOClZUqOm/ulyllt31t8vVjMwt2WwR4k+0HHamlrDtcUL6uAZV9n0D/U9QcNrHaz1V/J0wBiOKdTylCXAcMiuttAjcN60yrC+VUlj3pGC3w=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amperemail.onmicrosoft.com;
Received: from DM8PR01MB6824.prod.exchangelabs.com (2603:10b6:8:23::24) by
 SJ0PR01MB6205.prod.exchangelabs.com (2603:10b6:a03:297::13) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6678.26; Tue, 15 Aug 2023 07:24:28 +0000
Received: from DM8PR01MB6824.prod.exchangelabs.com
 ([fe80::d62f:d774:15b0:4a40]) by DM8PR01MB6824.prod.exchangelabs.com
 ([fe80::d62f:d774:15b0:4a40%4]) with mapi id 15.20.6678.025; Tue, 15 Aug 2023
 07:24:28 +0000
Message-ID: <cbbd8fe4-b52d-9bf0-7f12-06eb84fb9993@amperemail.onmicrosoft.com>
Date:   Tue, 15 Aug 2023 15:24:18 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.14.0
Subject: Re: [PATCH] KVM: arm64: pmu: Resync EL0 state on counter rotation
To:     Marc Zyngier <maz@kernel.org>
Cc:     kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org,
        kvm@vger.kernel.org, James Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Oliver Upton <oliver.upton@linux.dev>,
        Zenghui Yu <yuzenghui@huawei.com>,
        Huang Shijie <shijie@os.amperecomputing.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Will Deacon <will@kernel.org>,
        Frank Wang <zwang@amperecomputing.com>
References: <20230811180520.131727-1-maz@kernel.org>
 <1ce05000-264e-1fda-d193-8b27c3c293d8@amperemail.onmicrosoft.com>
 <87msysq0qe.wl-maz@kernel.org>
From:   Shijie Huang <shijie@amperemail.onmicrosoft.com>
In-Reply-To: <87msysq0qe.wl-maz@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: CH0PR03CA0263.namprd03.prod.outlook.com
 (2603:10b6:610:e5::28) To DM8PR01MB6824.prod.exchangelabs.com
 (2603:10b6:8:23::24)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM8PR01MB6824:EE_|SJ0PR01MB6205:EE_
X-MS-Office365-Filtering-Correlation-Id: 22efbef6-9cef-4e4d-41b1-08db9d60a8d5
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 3zcfTvVy7VP0ly0s6ZwY2JBhzW/c8GO3wwtTmoLABGHw6BVWoMWpTOVEj5ZgzIHQjRAmQo9eK9UiQibOSAuYu1ksy8zFVlEdySUkWRF8isYenBY6PfhFD6oLXrxUD9MEaGjWnrK0HsK86espZjVMRssVnHdyUtjiTxeIM0ELf/B34PmI3H10ZzFXxAWuUu60GCj1sOensjrIg4Tmb18ixQj8tgVGd2uvoV6FIEG28R+oMq5nElrmE+csTE1xPsywwF6Mqc4B6DiGOMdkMHG9IXe/UlBKe7F+Jow+uOx8iqCeKlAaqjawZZhRzJksmxqkLkKVckDBHO7Cv6qyRQzATNlWGskOQ4wGRbL/y+k9yYz0frMFBWQPAmaHDKczUcG9nQqGaRi3MbfZ25t5D2X4bz8ANgA2uqAXQ/HhaGdoAtM6Aqxa3IrZ5t5MMZ+EqGn+VUgrosi+BMT4i4KrHJJJOyvqwWu3Ru8RwvHJL8Kl+H2yG/hinPBw17py3aWgsYkwUT7yX8m1WkqEB/ABWjJMk9tcAkLsfxZ6x9wU3i6Si39KguHe0Femrse7ojjTtb6oJrynqmhLpn3bzL55gmtwCM7/a0YsVQp07l5CoHKAOXXGb0DQicOUVTIQu0zAUkmPhlAeeRjdoIWxs9eHMpptqA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM8PR01MB6824.prod.exchangelabs.com;PTR:;CAT:NONE;SFS:(13230028)(136003)(39850400004)(366004)(346002)(396003)(376002)(451199021)(186006)(1800799006)(26005)(107886003)(42882007)(6512007)(52116002)(2616005)(83380400001)(6506007)(41300700001)(54906003)(66476007)(66556008)(66946007)(6916009)(2906002)(316002)(5660300002)(8936002)(8676002)(7416002)(4326008)(478600001)(6666004)(6486002)(966005)(83170400001)(31696002)(38100700002)(38350700002)(31686004)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?NHlMWnRaa0cxWldtQkYzYUVkTEtEVlQyWlNiem5hc0VvMzZtRzRWaFY5WkJa?=
 =?utf-8?B?TzhtNmdnV1h5Mzh6RjBBcHJlNHFGSS9EMGtEajVuUXh0MUFEeHNldnRnYjRG?=
 =?utf-8?B?cTl1SGtmb0JKY3RHSG1PaEJ6MXQ1eVFYbnJmYUs0dmYwelJaa3MyZFJ3N3pB?=
 =?utf-8?B?S1hDalBtWVkwbUoxMDhBbFJ4b2Q3ZHRGbVdiNzFoV0lKQ0RFU2lvVFYzNmp5?=
 =?utf-8?B?VFloNTFaT3BSMUdsWnpncG83K3JwN3hWWFF4WmVaUjZKWDF6UzdKTC9UTVNU?=
 =?utf-8?B?dGwwbEd6bnFkTmRYa256UjRDK3g2ajRCcUlEVzhqRUhTdHE2ZUx3bDJ1QWhC?=
 =?utf-8?B?YXd0akRMV3h2ais0b1gyaG8xeGdOV0o4TVVQUm90S3M0ellZdTFicHFOLzY2?=
 =?utf-8?B?Ui9XaXQ0UzBNQnowRStSY0VCNFdmS3lSNDZWbGpCTWJsNS9RWlJzQUpDVWJG?=
 =?utf-8?B?TkFiUElDR1NIWFNMdnNkR09GelpudVBTenVuWXZjdzNEOWsrVVpBdUxXR3VT?=
 =?utf-8?B?L1ZQYkNQN3QvUG1jaEFkMm5lSlVJWW10RWwyL1U0OWhLZnVSd245ZmJycjA3?=
 =?utf-8?B?VnZNOGpNaG5tVTEwRzNDMkJteWpXbTl5QTY1WEVUZEdzN01zNkRIUFdxUitv?=
 =?utf-8?B?dWtEcHlIVE1wbHM4ZWRyU3J3WmdwNk0wcEZKS1MrSml3Q0N3Q3E1Y2NJSVhF?=
 =?utf-8?B?Y3dnQi8vREtKUFlZSU85T096MmpVRWs2S3dSR1M2VHdRS25TbWxHQmVQdGUv?=
 =?utf-8?B?WmN0em4xYXl2Z3AxRzA2WXhwNW90RFB4K2VXcTJ6MGZIS0owYUJZN0JKUklk?=
 =?utf-8?B?S1VqTFhhVG5CQkFTL2JLSkRFQzdOOWY0VDc5QUtaVmR6amhZU1VMVExqK3h6?=
 =?utf-8?B?MVlaT0kzd0tqVkJZTjAzN2JYek15WjI4VXZCK0NYU2hPenpOOSt0Rnh1Lyth?=
 =?utf-8?B?MzZYclZQRVQ1MkMrMTBjbHM5UmRCMGlEZll1QVZqZWszdzVNR1EzSmJ2UGRE?=
 =?utf-8?B?cjNCdGJJQWFhYTZpUzJSSDZxNlZFUENRMWt3TEtvRHdPZzFTSFo2RDduZjhC?=
 =?utf-8?B?aURyMDVZYmoyQ3EzUHArWVZxTTlaMnZhWTFvd3ZOVWhqb2lRTFFtOE5yTWxO?=
 =?utf-8?B?S1B1bEFiODZxKzBWY0tzNWh3VThMNFMrR0VGRlg3YTh4UVVFNEU5NWJiZ0ky?=
 =?utf-8?B?Q3c0dFhFUEFsdGYrZ1p0NUU1TUFIL09DbUR4bElSdkN6ZU83SUNJYVFyWW1K?=
 =?utf-8?B?Z3RHaU1MN2czZUgrV0c2dlJQa2NEUVpKaWcvMTF3a3ZPWXVyb0pMRy84eDlw?=
 =?utf-8?B?UEFXN2lpK2VGZm9HemxwR0tiQWU1VC81Sll0bjAvQlB4ZGlDNGx4blA5dXZs?=
 =?utf-8?B?OFhGTUtkL2JRdUQ0RFplZWdkNVRPcmxpNWpDMWhQb21PaGdkWFZIVzhvaWRZ?=
 =?utf-8?B?SndwL1dpUm9nUjY5bkpWblVZSHI3dmRHcTFKakxJd0FGZnZnd29FWExKK2o4?=
 =?utf-8?B?RTcvelpxbVhsK0d6aFZ6STJ4Q2JsSHdCRzJoYzhubVk5TXR4Y0VPQ3BPSHkv?=
 =?utf-8?B?ZVB0MzZTbTR4T0ZSbVVzRk1XQTR5cFc2bzRtdEFxU1NhM1c1NGdLdzB0ZTZH?=
 =?utf-8?B?OVZidG5PQ2RBMVJER0dMZm1CcGY4TjJNb1BkRU9KajE5RkptWUtxQ0ovRzQ1?=
 =?utf-8?B?djd2TXpZQ3p1anlwRWNzY09PNnIyc1UvNEs2V3VyQnpGa0U3NVNHR3FjdkJx?=
 =?utf-8?B?Uk5XRHFyM3BtVVhLU0doVVpQV0QzbmRzTlc2L3JDcGYyY0ZQWWc1eE1FWDJy?=
 =?utf-8?B?aVNNL3JZWnlldG5tWkhqZmQ2cTIrc0w5S2lzNHhkaHdORTl1ZFBCUWhqaGlL?=
 =?utf-8?B?Q20rdnZ2OGhVNGs0b2Z2VGhMRjNDNk1OTzJrWHo4NjkxVHFmcm5pOUNvVDV2?=
 =?utf-8?B?cUFUajkzTWlKNTI5eVhEYkZuTGhLazlka2xDeVJqS3dnM3crVXlKY1RMTitJ?=
 =?utf-8?B?OG0xWmtoT2RhVE9Mc1ZHNElCaFN2VldXQ1JSd3QzNWs1cTZmbDM2VHltQlov?=
 =?utf-8?B?WklucWVkWFAyNmIvbVBQV0hOMGpBVDdtWjI2UjVnY2V5ak5wb1NBaVlDeUNn?=
 =?utf-8?B?a1lTTjNvd0RkY2JWS2JPQXM2dWF5LzdXMjJQZklpY3JQUlhvQzJES2ZWT1hm?=
 =?utf-8?Q?9o7tzf70/biIiAPSKHt4z1Q=3D?=
X-OriginatorOrg: amperemail.onmicrosoft.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 22efbef6-9cef-4e4d-41b1-08db9d60a8d5
X-MS-Exchange-CrossTenant-AuthSource: DM8PR01MB6824.prod.exchangelabs.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Aug 2023 07:24:27.9769
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3bc2b170-fd94-476d-b0ce-4229bdc904a7
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Y7u1/Tn6CQ4haJqeh/qr6UjuVNH/uvloiXVPf1oxAgTG4hDLUHzXqQ7fYuNcqWXJxYeQXW3vvSgO27k0ZXUthq+5bTp41SaTS6F2i8//BOCLyU/xq0z02mOdnOHT2WQZ
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR01MB6205
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

Hi Marc,

在 2023/8/15 14:27, Marc Zyngier 写道:
> On Mon, 14 Aug 2023 03:58:32 +0100,
> Shijie Huang <shijie@amperemail.onmicrosoft.com> wrote:
>> Hi Marc,
>>
>> 在 2023/8/12 2:05, Marc Zyngier 写道:
>>> Huang Shijie reports that, when profiling a guest from the host
>>> with a number of events that exceeds the number of available
>>> counters, the reported counts are wildly inaccurate. Without
>>> the counter oversubscription, the reported counts are correct.
>>>
>>> Their investigation indicates that upon counter rotation (which
>>> takes place on the back of a timer interrupt), we fail to
>>> re-apply the guest EL0 enabling, leading to the counting of host
>>> events instead of guest events.
>>>
>>> In order to solve this, add yet another hook between the host PMU
>>> driver and KVM, re-applying the guest EL0 configuration if the
>>> right conditions apply (the host is VHE, we are in interrupt
>>> context, and we interrupted a running vcpu). This triggers a new
>>> vcpu request which will apply the correct configuration on guest
>>> reentry.
>>>
>>> With this, we have the correct counts, even when the counters are
>>> oversubscribed.
>>>
>>> Reported-by: Huang Shijie <shijie@os.amperecomputing.com>
>>> Suggested-by: Oliver Upton <oliver.upton@linux.dev>
>>> Signed-off-by: Marc Zyngier <maz@kernel.org>
>>> Cc: Mark Rutland <mark.rutland@arm.com>
>>> Cc: Will Deacon <will@kernel.org>
>>> Link: https://lore.kernel.org/r/20230809013953.7692-1-shijie@os.amperecomputing.com
>>> ---
>>>    arch/arm64/include/asm/kvm_host.h |  1 +
>>>    arch/arm64/kvm/arm.c              |  3 +++
>>>    arch/arm64/kvm/pmu.c              | 18 ++++++++++++++++++
>>>    drivers/perf/arm_pmuv3.c          |  2 ++
>>>    include/kvm/arm_pmu.h             |  2 ++
>>>    5 files changed, 26 insertions(+)
>>>
>>> diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
>>> index d3dd05bbfe23..553040e0e375 100644
>>> --- a/arch/arm64/include/asm/kvm_host.h
>>> +++ b/arch/arm64/include/asm/kvm_host.h
>>> @@ -49,6 +49,7 @@
>>>    #define KVM_REQ_RELOAD_GICv4	KVM_ARCH_REQ(4)
>>>    #define KVM_REQ_RELOAD_PMU	KVM_ARCH_REQ(5)
>>>    #define KVM_REQ_SUSPEND		KVM_ARCH_REQ(6)
>>> +#define KVM_REQ_RESYNC_PMU_EL0	KVM_ARCH_REQ(7)
>>>      #define KVM_DIRTY_LOG_MANUAL_CAPS
>>> (KVM_DIRTY_LOG_MANUAL_PROTECT_ENABLE | \
>>>    				     KVM_DIRTY_LOG_INITIALLY_SET)
>>> diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
>>> index 72dc53a75d1c..978b0411082f 100644
>>> --- a/arch/arm64/kvm/arm.c
>>> +++ b/arch/arm64/kvm/arm.c
>>> @@ -803,6 +803,9 @@ static int check_vcpu_requests(struct kvm_vcpu *vcpu)
>>>    			kvm_pmu_handle_pmcr(vcpu,
>>>    					    __vcpu_sys_reg(vcpu, PMCR_EL0));
>>>    +		if (kvm_check_request(KVM_REQ_RESYNC_PMU_EL0, vcpu))
>>> +			kvm_vcpu_pmu_restore_guest(vcpu);
>>> +
>>>    		if (kvm_check_request(KVM_REQ_SUSPEND, vcpu))
>>>    			return kvm_vcpu_suspend(vcpu);
>>>    diff --git a/arch/arm64/kvm/pmu.c b/arch/arm64/kvm/pmu.c
>>> index 121f1a14c829..0eea225fd09a 100644
>>> --- a/arch/arm64/kvm/pmu.c
>>> +++ b/arch/arm64/kvm/pmu.c
>>> @@ -236,3 +236,21 @@ bool kvm_set_pmuserenr(u64 val)
>>>    	ctxt_sys_reg(hctxt, PMUSERENR_EL0) = val;
>>>    	return true;
>>>    }
>>> +
>>> +/*
>>> + * If we interrupted the guest to update the host PMU context, make
>>> + * sure we re-apply the guest EL0 state.
>>> + */
>>> +void kvm_vcpu_pmu_resync_el0(void)
>>> +{
>>> +	struct kvm_vcpu *vcpu;
>>> +
>>> +	if (!has_vhe() || !in_interrupt())
>>> +		return;
>>> +
>>> +	vcpu = kvm_get_running_vcpu();
>>> +	if (!vcpu)
>>> +		return;
>>> +
>>> +	kvm_make_request(KVM_REQ_RESYNC_PMU_EL0, vcpu);
>>> +}
>>> diff --git a/drivers/perf/arm_pmuv3.c b/drivers/perf/arm_pmuv3.c
>>> index 08b3a1bf0ef6..6a3d8176f54a 100644
>>> --- a/drivers/perf/arm_pmuv3.c
>>> +++ b/drivers/perf/arm_pmuv3.c
>>> @@ -772,6 +772,8 @@ static void armv8pmu_start(struct arm_pmu *cpu_pmu)
>>>      	/* Enable all counters */
>>>    	armv8pmu_pmcr_write(armv8pmu_pmcr_read() | ARMV8_PMU_PMCR_E);
>>> +
>>> +	kvm_vcpu_pmu_resync_el0();
>>>    }
>> I read the perf code again, and find it maybe not good to do it in
>> armv8pmu_start.
>>
>>     Assume we install a new perf event to a CPU "x" from CPU 0,  a VM
>> guest is running on CPU "x":
>>
>>      perf_event_open() --> perf_install_in_context() -->
>>
>>      call this function in  IPI interrupt: ___perf_install_in_context().
>>
>>     armv8pmu_start() will be called in ___perf_install_in_context() in IPI.
>>
>>     so kvm_vcpu_pmu_resync_el0() will _make_ a request by meeting the
>> conditions:
>>
>>               1.) in interrupt context.
>>
>>               2.) a guest is running on this CPU.
>>
>>
>> But in actually, the request should not send out.
> Why shouldn't it be applied? This isn't supposed to be always
> necessary, but it needs to be applied whenever there is a possibility
> for counters to be updated behind our back, something that is a pretty
> event anyway.

okay.


>> Please correct me if I am wrong.
>>
>> IMHO, the best solution is add  a hook in the perf/core code, and make
>> the request there.
> I disagree. I'm still completely opposed to anything that will add
> such a hook in the core perf code, specially as a weak symbol. The
> interactions must be strictly between the PMUv3 driver and KVM,
> because they are the only parties involved here.
>
> I will *not* take such a patch.

okay, please ignore my v3 patch.

Tested_by: Huang Shijie <shijie@os.amperecomputing.com>


Thanks

Huang Shijie

>
> 	M.
>
