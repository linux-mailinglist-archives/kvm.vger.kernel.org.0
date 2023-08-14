Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AC60A77AFCB
	for <lists+kvm@lfdr.de>; Mon, 14 Aug 2023 04:59:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232682AbjHNC7F (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 13 Aug 2023 22:59:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41532 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232709AbjHNC6t (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 13 Aug 2023 22:58:49 -0400
Received: from NAM04-BN8-obe.outbound.protection.outlook.com (mail-bn8nam04on2139.outbound.protection.outlook.com [40.107.100.139])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8C70B1BF
        for <kvm@vger.kernel.org>; Sun, 13 Aug 2023 19:58:46 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=SunaOrdSI3DbJPUEl9+gMzmK65n7WxoKoGXdsejEiuwcDPAu8qYMWgnfCMUk9Pav7Rq8m89QLzo2cjc4/QZQVs0EkmpI3B0VCvBRi9HJd/HnTfSoxz3/ivkJqEzc/s5a1nAPrDlpUW7GK5CHBfWd9ja/6y1YHRHq3xyF37H3cJhJADwU3kJzL3xhTA5qr8vVHYeaV1SpqpIf+ESRJS/8JM0vuuEClpnqJsynXD/yONvEiFRG9cv3rb9fIU4wtzliHQDdavDc+CPQJ8efAtLYXfZYcKLcunvfuYQwS5ot/h/R3nTyQ+KB0SK9W2VB9y53Rl6u1fZHP45LZx2l/kxbKA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=XntEMejKOI7oM06vsNefA2LRa8+eokZEMy9le+Abwzw=;
 b=aR9RqndqcwW1nVqJHQN0r0qLJ2/jP6020yLQMF7ij8p25SeKXHuy0+5i1H93Giu0G5qYBqZrgmvEZKCC1mWEgm7Ozzb+l50SV0hf3qOx8yOgI1IXh9nZ4CX6PxB+JVdX8tzbxInZJzmQS7bv5vWOQx5iTGIqFRdimPhTp6b8BpL6kbkW1VBseMcJbvuDqL6aflxtg6F6ILR9zF5LqysY2FSxBCarJ57DE4l27bVRKVveoCgFDSAWseqY2Afl6rx9lZPfdYqJn8TghTL9RNjpoj3kM5cnRmNNSm4TIGvhvQpGwelkslIxSecVILvVzMwhjnw0jp8aFz4kFYYmVDTIqg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=os.amperecomputing.com; dmarc=pass action=none
 header.from=amperemail.onmicrosoft.com; dkim=pass
 header.d=amperemail.onmicrosoft.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amperemail.onmicrosoft.com; s=selector1-amperemail-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=XntEMejKOI7oM06vsNefA2LRa8+eokZEMy9le+Abwzw=;
 b=mdNUCn5m3u8DyTMJ72OD02905uY4KAyrjplkhcPaB3npvtTonHxXFy6VxsFzS+rfctFI1n58gMh7obUSe9Z4zakTfo8RtRBkA9cF5BQ8hsr76x4e8mMUGBzSG1s+H4aPpwt+BNEdhVNPNksllMPDAmjPxSNxCUlbrQqq2MEB/wE=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amperemail.onmicrosoft.com;
Received: from DM8PR01MB6824.prod.exchangelabs.com (2603:10b6:8:23::24) by
 SA1PR01MB7280.prod.exchangelabs.com (2603:10b6:806:1f3::22) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6678.24; Mon, 14 Aug 2023 02:58:43 +0000
Received: from DM8PR01MB6824.prod.exchangelabs.com
 ([fe80::d62f:d774:15b0:4a40]) by DM8PR01MB6824.prod.exchangelabs.com
 ([fe80::d62f:d774:15b0:4a40%4]) with mapi id 15.20.6678.022; Mon, 14 Aug 2023
 02:58:43 +0000
Message-ID: <1ce05000-264e-1fda-d193-8b27c3c293d8@amperemail.onmicrosoft.com>
Date:   Mon, 14 Aug 2023 10:58:32 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.14.0
Subject: Re: [PATCH] KVM: arm64: pmu: Resync EL0 state on counter rotation
To:     Marc Zyngier <maz@kernel.org>, kvmarm@lists.linux.dev,
        linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org
Cc:     James Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Oliver Upton <oliver.upton@linux.dev>,
        Zenghui Yu <yuzenghui@huawei.com>,
        Huang Shijie <shijie@os.amperecomputing.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Will Deacon <will@kernel.org>,
        Frank Wang <zwang@amperecomputing.com>
References: <20230811180520.131727-1-maz@kernel.org>
From:   Shijie Huang <shijie@amperemail.onmicrosoft.com>
In-Reply-To: <20230811180520.131727-1-maz@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: CH2PR18CA0028.namprd18.prod.outlook.com
 (2603:10b6:610:4f::38) To DM8PR01MB6824.prod.exchangelabs.com
 (2603:10b6:8:23::24)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM8PR01MB6824:EE_|SA1PR01MB7280:EE_
X-MS-Office365-Filtering-Correlation-Id: 1a65d94b-a52d-4b13-7eee-08db9c725e7c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 4Mwhcu+B87Bo3fSm8cCuKdQmqAUhJnpmG2pfs5NZ0idUjhSh11CU2Zfa4Eq21ZiP5tC0eSx6v7fJTvY1u79CsCwedBPcWj8HT3oBvqa09ECn8ev585LZgtMhjr31quUcff/wHgs+RHQLBEPmemLzH+pYpdrFuAYYaLKIP1CvY6GYpEFtTKPgmLEJrMKSpV6m4jak8hhBIcQdEh9bfFEd2FjPLIv5pwdH1/YnLnWj0dF0J4mwtgZt67jZ6M3/AI6eggNmOF9HxHsOKnb1HCewAalC0Orzy1esZC0Ju9U1fm2l0LycpbBGIRKMMc23p2N+ZL4QKdms3exm+WY0YB/sKsZVnP+qIscyH4KQMz+bDZd+XV5qTaPe85UTNe+ijItLPmUjzIJlks9IzGoAH9qyb1b6ZjbBpDL3AE63IySqUsINDZIJp7KARrtbaCY41NW6Gl3F47cIUkhfn4uM7L70h90oCzZUpnhYA5FQJvz2rbiwI3S+9r/QRgGdDS5oyuqMYF3AVD+hpr+bBHgArI9gDskR7iK00TMVDZ6r2vwDNvT6i1gHXlJWbFwie/htZuFso+sobawP9uY5ELghfP2Lnx9pK6xU+9SoK0GKeoaLYtpLZdk+OfeQSgh1yN4Xbj2i
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM8PR01MB6824.prod.exchangelabs.com;PTR:;CAT:NONE;SFS:(13230028)(136003)(396003)(376002)(366004)(39840400004)(346002)(186006)(1800799006)(451199021)(31686004)(6486002)(52116002)(966005)(6512007)(54906003)(6666004)(31696002)(38350700002)(38100700002)(83380400001)(83170400001)(6506007)(107886003)(2906002)(478600001)(42882007)(2616005)(41300700001)(8936002)(8676002)(26005)(7416002)(5660300002)(316002)(66476007)(66556008)(66946007)(4326008)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?b3Y5c0F0Z2FudUFjYVVSRjRQbTZZamZzY3lPRFhOSE9DenU0OVJwVVFXQXlB?=
 =?utf-8?B?S2tUdlBKTEh0RVB5dnp5RUwrNlQxM2RwTGZ0eWRYSFI5RFhSb2Vkc29uYWRm?=
 =?utf-8?B?N3k1RkUxQU9CVTZuYU9HcWNXMjFNVHlzOUdjZWxidE1XNXpFT0YrdzBPZVF5?=
 =?utf-8?B?UzlKNWd5U3RFZm1INzNpUmIxMWNnTVpsaWwzVDVuVnd4LzdWN01CWjJVd1J1?=
 =?utf-8?B?RXltMUFheDd5dDBGKzZ6VmtSd0ZBalg1S3ZUeE5uQWN2UkNrYjh3L1VMT01B?=
 =?utf-8?B?Vkd6akwrak95YUpiaW0vclYxREJPOG5ENGJyWTJ5SGZsaDZrS2FweVhhQ0RU?=
 =?utf-8?B?aUw2Z1BnUmZacndMTlFMTVhTbW5jNktIdERiVkdMb3QzOEpRbEZZc01GdVNn?=
 =?utf-8?B?aWN5dmtuVjBrUEgzMk1td3Z3YXhTUklXM1pCZW9xM29hd1JsdGo1RlNLY3RG?=
 =?utf-8?B?MWJkalEzdGhnZ212SlBrdy82eGx6dnZEVmtwK2VpUk1tY3ZBd1BQak5XUlUx?=
 =?utf-8?B?UUcyK3prR3g2aitFTkNBUHJKUlhlTDZGbFZHZXVIb1JvLzFtcUgyZ3I1eWVq?=
 =?utf-8?B?ZjcwdlNzUTQ0VHpVNDdPbnZEbElVWnJDR3BpckkxUVVPL2F1eW9zZTVSeFBq?=
 =?utf-8?B?TUgrM05aazU4cER2UnRxcGppaHhRbm4zdXQxSk5RemxrbnNYcXc3V1NDa1hO?=
 =?utf-8?B?MSs4WnlHOWFzRDdPdmVLQXc1MVFsQmVvaHlSNkdvRWRWckZycmhWUlpWVUJt?=
 =?utf-8?B?KzUyTldUTlZxR3FDbGV4ZUV6NFVXYWhick9qYmNsbTVkeGNuYjVkTzRoYU13?=
 =?utf-8?B?SzNuenRjWXptelRDOG5oREpOeU9GMy9zSjU1ZVlFQ2VVNnUvbmlxMHp0V05I?=
 =?utf-8?B?WnE0bGp6UlFiRmh5UDN3UjRwazhaSGlhZG1yeE9VVERRckdwdGJPQndxSVZ6?=
 =?utf-8?B?bTF6cFh4c0ZtQytUbVRYUEVJU0xJamlYZFk4cUxKSkxZQk9EM3ZzR3NYcW9y?=
 =?utf-8?B?dUtwMGQweVU3VXQ0SVc3WTlzZlhIRDIyVlowdTVGYjlyeWRZN2F6UG0yZXZl?=
 =?utf-8?B?Ull2UmZacjZER0tIYkF4Q2ZWYldWOFhHZWRsN3F1WXpqSE5ENW41TTVvRzdC?=
 =?utf-8?B?UkdyOGJlMnRubHNzRXZUN1krRVdlcUo0OW5KRERNN3hDTTZPQnhsTDNqVDZq?=
 =?utf-8?B?T3J1cnRxR2V0dFlSWnJQL3JRVkI5QTd0Kzd5b2FaM0E2eTlCbEo2Q0s5Tzda?=
 =?utf-8?B?QjBQV0VoSjAvZW1FMjJySlpJSmlVRzRtOGxocnV2eGdXRGZPZ2tnSlN2cHIw?=
 =?utf-8?B?WHBXWTdpVW4vS1lXMURQR3VGa0tPV05sSGJpUGl3dFBmZXJmc2k3czlvT05t?=
 =?utf-8?B?bDY0WkRCamxNODlXOXhLcjlyalBtdnhFNGhoNmYvMmo5RlhEMXBkdys3eVFx?=
 =?utf-8?B?QWh4dFlNMk1GSzlkWWx6MFREbXF0dnRJN0NXN05Rd04rU2xsZVVCcTRra1VX?=
 =?utf-8?B?SzFWVEsrbXdVaDFZc3p0TVNCcTFXQ0g5RnZodGhEVnBkaEIyZkZXRkM1MkhG?=
 =?utf-8?B?cU5UOVFjMG9JZk9Lb1V5a000SjBGQ0dsS0kvWm9Gc2tFRElEWGpEQXFzTjhs?=
 =?utf-8?B?RW5UZlBVZm9Nc1E5dkxwWHU1a1pPbFFLZzlHODd3MjVaSVM0aXowKy9uaWlV?=
 =?utf-8?B?UVdQNWxVQ05FSDJCcUVqQWg5OXpvMVNLditmMUNpSG56YmhINDFOZ0lOWmNI?=
 =?utf-8?B?WWYxaTdTdm95NmlOcVZ4RStLSWlJVTk1UFd2cDNmVUxEd0JnMlB6aGs4TFJ4?=
 =?utf-8?B?SVRBMG9hNDRNRXNGTWJRRk14RHFnYnJLeERBK2RMUkxsVWI0aFlEeThjQWcv?=
 =?utf-8?B?azhGbzhKYityUHRNd01YRFREcWlZbEExTUF0QWZ3T2YxRzZQTGFEZGJnQWpK?=
 =?utf-8?B?TlNFNmljZmdmRFk1dklKWFE0cGdNY2FDOXdaQ1ArUXpUcXR6NzgvNUFUVUJo?=
 =?utf-8?B?T24xWklhd1FtNlVtUkpuWkx3VVNDcWNiaVZuWTU2R0hSY1NzMHdqL2UveXJ0?=
 =?utf-8?B?MkdoSUdUb0VHUUF4QnpyWEZKejduZzBHSEJiL0ZEYTlDNURZd2dXK3oxR01n?=
 =?utf-8?B?S0d2bXJBdDlqTysveEZ5NmFzWWN5S2dUNTJBb1I5U1gyM0ZUbDZTQkhVQjZs?=
 =?utf-8?Q?CxWP+vp5Xwi/mJYAiQwx9Uk=3D?=
X-OriginatorOrg: amperemail.onmicrosoft.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1a65d94b-a52d-4b13-7eee-08db9c725e7c
X-MS-Exchange-CrossTenant-AuthSource: DM8PR01MB6824.prod.exchangelabs.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Aug 2023 02:58:43.0103
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3bc2b170-fd94-476d-b0ce-4229bdc904a7
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: cCqBbYGuXNXpYxKtC6ks/v4pNg5RGtXLT3cXT/RGMGjbiwnCw3c5+w0ukX2Oz1AS8yhe+h62vRmJT+9nglvhgvnpJeZ44PiGd6EIx4EJG7JTB6bSVXuz2ZcdzYmFTszN
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR01MB7280
X-Spam-Status: No, score=-5.6 required=5.0 tests=BAYES_00,DKIM_INVALID,
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

在 2023/8/12 2:05, Marc Zyngier 写道:
> Huang Shijie reports that, when profiling a guest from the host
> with a number of events that exceeds the number of available
> counters, the reported counts are wildly inaccurate. Without
> the counter oversubscription, the reported counts are correct.
>
> Their investigation indicates that upon counter rotation (which
> takes place on the back of a timer interrupt), we fail to
> re-apply the guest EL0 enabling, leading to the counting of host
> events instead of guest events.
>
> In order to solve this, add yet another hook between the host PMU
> driver and KVM, re-applying the guest EL0 configuration if the
> right conditions apply (the host is VHE, we are in interrupt
> context, and we interrupted a running vcpu). This triggers a new
> vcpu request which will apply the correct configuration on guest
> reentry.
>
> With this, we have the correct counts, even when the counters are
> oversubscribed.
>
> Reported-by: Huang Shijie <shijie@os.amperecomputing.com>
> Suggested-by: Oliver Upton <oliver.upton@linux.dev>
> Signed-off-by: Marc Zyngier <maz@kernel.org>
> Cc: Mark Rutland <mark.rutland@arm.com>
> Cc: Will Deacon <will@kernel.org>
> Link: https://lore.kernel.org/r/20230809013953.7692-1-shijie@os.amperecomputing.com
> ---
>   arch/arm64/include/asm/kvm_host.h |  1 +
>   arch/arm64/kvm/arm.c              |  3 +++
>   arch/arm64/kvm/pmu.c              | 18 ++++++++++++++++++
>   drivers/perf/arm_pmuv3.c          |  2 ++
>   include/kvm/arm_pmu.h             |  2 ++
>   5 files changed, 26 insertions(+)
>
> diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
> index d3dd05bbfe23..553040e0e375 100644
> --- a/arch/arm64/include/asm/kvm_host.h
> +++ b/arch/arm64/include/asm/kvm_host.h
> @@ -49,6 +49,7 @@
>   #define KVM_REQ_RELOAD_GICv4	KVM_ARCH_REQ(4)
>   #define KVM_REQ_RELOAD_PMU	KVM_ARCH_REQ(5)
>   #define KVM_REQ_SUSPEND		KVM_ARCH_REQ(6)
> +#define KVM_REQ_RESYNC_PMU_EL0	KVM_ARCH_REQ(7)
>   
>   #define KVM_DIRTY_LOG_MANUAL_CAPS   (KVM_DIRTY_LOG_MANUAL_PROTECT_ENABLE | \
>   				     KVM_DIRTY_LOG_INITIALLY_SET)
> diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
> index 72dc53a75d1c..978b0411082f 100644
> --- a/arch/arm64/kvm/arm.c
> +++ b/arch/arm64/kvm/arm.c
> @@ -803,6 +803,9 @@ static int check_vcpu_requests(struct kvm_vcpu *vcpu)
>   			kvm_pmu_handle_pmcr(vcpu,
>   					    __vcpu_sys_reg(vcpu, PMCR_EL0));
>   
> +		if (kvm_check_request(KVM_REQ_RESYNC_PMU_EL0, vcpu))
> +			kvm_vcpu_pmu_restore_guest(vcpu);
> +
>   		if (kvm_check_request(KVM_REQ_SUSPEND, vcpu))
>   			return kvm_vcpu_suspend(vcpu);
>   
> diff --git a/arch/arm64/kvm/pmu.c b/arch/arm64/kvm/pmu.c
> index 121f1a14c829..0eea225fd09a 100644
> --- a/arch/arm64/kvm/pmu.c
> +++ b/arch/arm64/kvm/pmu.c
> @@ -236,3 +236,21 @@ bool kvm_set_pmuserenr(u64 val)
>   	ctxt_sys_reg(hctxt, PMUSERENR_EL0) = val;
>   	return true;
>   }
> +
> +/*
> + * If we interrupted the guest to update the host PMU context, make
> + * sure we re-apply the guest EL0 state.
> + */
> +void kvm_vcpu_pmu_resync_el0(void)
> +{
> +	struct kvm_vcpu *vcpu;
> +
> +	if (!has_vhe() || !in_interrupt())
> +		return;
> +
> +	vcpu = kvm_get_running_vcpu();
> +	if (!vcpu)
> +		return;
> +
> +	kvm_make_request(KVM_REQ_RESYNC_PMU_EL0, vcpu);
> +}
> diff --git a/drivers/perf/arm_pmuv3.c b/drivers/perf/arm_pmuv3.c
> index 08b3a1bf0ef6..6a3d8176f54a 100644
> --- a/drivers/perf/arm_pmuv3.c
> +++ b/drivers/perf/arm_pmuv3.c
> @@ -772,6 +772,8 @@ static void armv8pmu_start(struct arm_pmu *cpu_pmu)
>   
>   	/* Enable all counters */
>   	armv8pmu_pmcr_write(armv8pmu_pmcr_read() | ARMV8_PMU_PMCR_E);
> +
> +	kvm_vcpu_pmu_resync_el0();
>   }

I read the perf code again, and find it maybe not good to do it in 
armv8pmu_start.

    Assume we install a new perf event to a CPU "x" from CPU 0,  a VM 
guest is running on CPU "x":

     perf_event_open() --> perf_install_in_context() -->

     call this function in  IPI interrupt: ___perf_install_in_context().

    armv8pmu_start() will be called in ___perf_install_in_context() in IPI.

    so kvm_vcpu_pmu_resync_el0() will _make_ a request by meeting the 
conditions:

              1.) in interrupt context.

              2.) a guest is running on this CPU.


But in actually, the request should not send out.

Please correct me if I am wrong.

IMHO, the best solution is add  a hook in the perf/core code, and make 
the request there.

I will send my v3 patch.


Thanks

Huang Shijie






>   
>   static void armv8pmu_stop(struct arm_pmu *cpu_pmu)
> diff --git a/include/kvm/arm_pmu.h b/include/kvm/arm_pmu.h
> index 847da6fc2713..3a8a70a60794 100644
> --- a/include/kvm/arm_pmu.h
> +++ b/include/kvm/arm_pmu.h
> @@ -74,6 +74,7 @@ int kvm_arm_pmu_v3_enable(struct kvm_vcpu *vcpu);
>   struct kvm_pmu_events *kvm_get_pmu_events(void);
>   void kvm_vcpu_pmu_restore_guest(struct kvm_vcpu *vcpu);
>   void kvm_vcpu_pmu_restore_host(struct kvm_vcpu *vcpu);
> +void kvm_vcpu_pmu_resync_el0(void);
>   
>   #define kvm_vcpu_has_pmu(vcpu)					\
>   	(test_bit(KVM_ARM_VCPU_PMU_V3, (vcpu)->arch.features))
> @@ -171,6 +172,7 @@ static inline u8 kvm_arm_pmu_get_pmuver_limit(void)
>   {
>   	return 0;
>   }
> +static inline void kvm_vcpu_pmu_resync_el0(void) {}
>   
>   #endif
>   
