Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4BAB5722A3B
	for <lists+kvm@lfdr.de>; Mon,  5 Jun 2023 17:07:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232530AbjFEPHV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 5 Jun 2023 11:07:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47166 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230247AbjFEPHT (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 5 Jun 2023 11:07:19 -0400
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 4A8D59C;
        Mon,  5 Jun 2023 08:07:18 -0700 (PDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 60B7FD75;
        Mon,  5 Jun 2023 08:08:03 -0700 (PDT)
Received: from [10.57.85.135] (unknown [10.57.85.135])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id BED333F663;
        Mon,  5 Jun 2023 08:07:14 -0700 (PDT)
Message-ID: <79f43d6b-7407-56c5-3c7d-c8fc48625e95@arm.com>
Date:   Mon, 5 Jun 2023 16:07:09 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; rv:102.0) Gecko/20100101
 Thunderbird/102.11.2
Subject: Re: [PATCH 1/3] arm64: Add a capability for FEAT_BBM level 2
Content-Language: en-GB
To:     Colton Lewis <coltonlewis@google.com>, kvm@vger.kernel.org
Cc:     Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will@kernel.org>, Marc Zyngier <maz@kernel.org>,
        Oliver Upton <oliver.upton@linux.dev>,
        James Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Zenghui Yu <yuzenghui@huawei.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        kvmarm@lists.linux.dev, Ricardo Koller <ricarkol@google.com>
References: <20230602170147.1541355-1-coltonlewis@google.com>
 <20230602170147.1541355-2-coltonlewis@google.com>
From:   Robin Murphy <robin.murphy@arm.com>
In-Reply-To: <20230602170147.1541355-2-coltonlewis@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 2023-06-02 18:01, Colton Lewis wrote:
> From: Ricardo Koller <ricarkol@google.com>
> 
> Add a new capability to detect "Stage-2 Translation table
> break-before-make" (FEAT_BBM) level 2.

Why does this patch invent spurious "stage 2" references everywhere? The 
full name of FEAT_BBM is "Translation table break-before-make levels", 
and it is not specific to one stage of translation.

Thanks,
Robin.

> Signed-off-by: Ricardo Koller <ricarkol@google.com>
> ---
>   arch/arm64/kernel/cpufeature.c | 11 +++++++++++
>   arch/arm64/tools/cpucaps       |  1 +
>   2 files changed, 12 insertions(+)
> 
> diff --git a/arch/arm64/kernel/cpufeature.c b/arch/arm64/kernel/cpufeature.c
> index c331c49a7d19c..c538060f7f66b 100644
> --- a/arch/arm64/kernel/cpufeature.c
> +++ b/arch/arm64/kernel/cpufeature.c
> @@ -2455,6 +2455,17 @@ static const struct arm64_cpu_capabilities arm64_features[] = {
>   		.min_field_value = 1,
>   		.matches = has_cpuid_feature,
>   	},
> +	{
> +		.desc = "Stage-2 Translation table break-before-make level 2",
> +		.type = ARM64_CPUCAP_SYSTEM_FEATURE,
> +		.capability = ARM64_HAS_STAGE2_BBM2,
> +		.sys_reg = SYS_ID_AA64MMFR2_EL1,
> +		.sign = FTR_UNSIGNED,
> +		.field_pos = ID_AA64MMFR2_EL1_BBM_SHIFT,
> +		.field_width = 4,
> +		.min_field_value = 2,
> +		.matches = has_cpuid_feature,
> +	},
>   	{
>   		.desc = "TLB range maintenance instructions",
>   		.capability = ARM64_HAS_TLB_RANGE,
> diff --git a/arch/arm64/tools/cpucaps b/arch/arm64/tools/cpucaps
> index 40ba95472594d..010aca1892642 100644
> --- a/arch/arm64/tools/cpucaps
> +++ b/arch/arm64/tools/cpucaps
> @@ -41,6 +41,7 @@ HAS_PAN
>   HAS_RAS_EXTN
>   HAS_RNG
>   HAS_SB
> +HAS_STAGE2_BBM2
>   HAS_STAGE2_FWB
>   HAS_TIDCP1
>   HAS_TLB_RANGE
> --
> 2.41.0.rc0.172.g3f132b7071-goog
> 
> _______________________________________________
> linux-arm-kernel mailing list
> linux-arm-kernel@lists.infradead.org
> http://lists.infradead.org/mailman/listinfo/linux-arm-kernel
