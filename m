Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4C29738B003
	for <lists+kvm@lfdr.de>; Thu, 20 May 2021 15:32:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235741AbhETNdm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 20 May 2021 09:33:42 -0400
Received: from szxga06-in.huawei.com ([45.249.212.32]:3628 "EHLO
        szxga06-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231733AbhETNdl (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 20 May 2021 09:33:41 -0400
Received: from dggems701-chm.china.huawei.com (unknown [172.30.72.60])
        by szxga06-in.huawei.com (SkyGuard) with ESMTP id 4Fm9Zy1rlJzmXDj;
        Thu, 20 May 2021 21:30:02 +0800 (CST)
Received: from dggema764-chm.china.huawei.com (10.1.198.206) by
 dggems701-chm.china.huawei.com (10.3.19.178) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id
 15.1.2176.2; Thu, 20 May 2021 21:32:19 +0800
Received: from [10.174.185.179] (10.174.185.179) by
 dggema764-chm.china.huawei.com (10.1.198.206) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.2176.2; Thu, 20 May 2021 21:32:18 +0800
Subject: Re: [PATCH v4 01/66] arm64: Add ARM64_HAS_NESTED_VIRT cpufeature
To:     Marc Zyngier <maz@kernel.org>
CC:     <linux-arm-kernel@lists.infradead.org>,
        <kvmarm@lists.cs.columbia.edu>, <kvm@vger.kernel.org>,
        Andre Przywara <andre.przywara@arm.com>,
        "Christoffer Dall" <christoffer.dall@arm.com>,
        Jintack Lim <jintack@cs.columbia.edu>,
        "Haibo Xu" <haibo.xu@linaro.org>,
        James Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        <kernel-team@android.com>, Jintack Lim <jintack.lim@linaro.org>
References: <20210510165920.1913477-1-maz@kernel.org>
 <20210510165920.1913477-2-maz@kernel.org>
From:   Zenghui Yu <yuzenghui@huawei.com>
Message-ID: <e20813df-cb19-9856-b80d-16b3bffc2f7d@huawei.com>
Date:   Thu, 20 May 2021 21:32:17 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.9.0
MIME-Version: 1.0
In-Reply-To: <20210510165920.1913477-2-maz@kernel.org>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.174.185.179]
X-ClientProxiedBy: dggems706-chm.china.huawei.com (10.3.19.183) To
 dggema764-chm.china.huawei.com (10.1.198.206)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 2021/5/11 0:58, Marc Zyngier wrote:
> From: Jintack Lim <jintack.lim@linaro.org>
> 
> Add a new ARM64_HAS_NESTED_VIRT feature to indicate that the
> CPU has the ARMv8.3 nested virtualization capability.
> 
> This will be used to support nested virtualization in KVM.
> 
> Signed-off-by: Jintack Lim <jintack.lim@linaro.org>
> Signed-off-by: Andre Przywara <andre.przywara@arm.com>
> Signed-off-by: Christoffer Dall <christoffer.dall@arm.com>
> Signed-off-by: Marc Zyngier <maz@kernel.org>
> ---
>  .../admin-guide/kernel-parameters.txt         |  4 +++
>  arch/arm64/include/asm/cpucaps.h              |  1 +
>  arch/arm64/kernel/cpufeature.c                | 25 +++++++++++++++++++
>  3 files changed, 30 insertions(+)

[...]

> diff --git a/arch/arm64/kernel/cpufeature.c b/arch/arm64/kernel/cpufeature.c
> index efed2830d141..056de86d7f6f 100644
> --- a/arch/arm64/kernel/cpufeature.c
> +++ b/arch/arm64/kernel/cpufeature.c
> @@ -1645,6 +1645,21 @@ static void cpu_copy_el2regs(const struct arm64_cpu_capabilities *__unused)
>  		write_sysreg(read_sysreg(tpidr_el1), tpidr_el2);
>  }
>  
> +static bool nested_param;
> +static bool has_nested_virt_support(const struct arm64_cpu_capabilities *cap,
> +				    int scope)
> +{
> +	return has_cpuid_feature(cap, scope) &&
> +		nested_param;
> +}

Nitpick:

How about putting them into a single line (they still perfectly
fit within the 80-colume limit)?

Zenghui
