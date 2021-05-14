Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8DE943809D4
	for <lists+kvm@lfdr.de>; Fri, 14 May 2021 14:46:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233513AbhENMrl (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 14 May 2021 08:47:41 -0400
Received: from szxga06-in.huawei.com ([45.249.212.32]:2984 "EHLO
        szxga06-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233576AbhENMr1 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 14 May 2021 08:47:27 -0400
Received: from dggems705-chm.china.huawei.com (unknown [172.30.72.60])
        by szxga06-in.huawei.com (SkyGuard) with ESMTP id 4FhSrf1FYnzmWKt;
        Fri, 14 May 2021 20:44:02 +0800 (CST)
Received: from dggema764-chm.china.huawei.com (10.1.198.206) by
 dggems705-chm.china.huawei.com (10.3.19.182) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id
 15.1.2176.2; Fri, 14 May 2021 20:46:14 +0800
Received: from [10.174.185.179] (10.174.185.179) by
 dggema764-chm.china.huawei.com (10.1.198.206) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.2176.2; Fri, 14 May 2021 20:46:13 +0800
Subject: Re: [PATCH v3 7/9] KVM: arm64: timer: Refactor IRQ configuration
To:     Marc Zyngier <maz@kernel.org>
CC:     <linux-arm-kernel@lists.infradead.org>, <kvm@vger.kernel.org>,
        <kvmarm@lists.cs.columbia.edu>, <kernel-team@android.com>,
        Hector Martin <marcan@marcan.st>
References: <20210510134824.1910399-1-maz@kernel.org>
 <20210510134824.1910399-8-maz@kernel.org>
From:   Zenghui Yu <yuzenghui@huawei.com>
Message-ID: <9f28e15b-26d0-5d3e-8f0e-8026ece536e0@huawei.com>
Date:   Fri, 14 May 2021 20:46:13 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.9.0
MIME-Version: 1.0
In-Reply-To: <20210510134824.1910399-8-maz@kernel.org>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.174.185.179]
X-ClientProxiedBy: dggems705-chm.china.huawei.com (10.3.19.182) To
 dggema764-chm.china.huawei.com (10.1.198.206)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 2021/5/10 21:48, Marc Zyngier wrote:
> As we are about to add some more things to the timer IRQ
> configuration, move this code out of the main timer init code
> into its own set of functions.
> 
> No functional changes.
> 
> Signed-off-by: Marc Zyngier <maz@kernel.org>
> ---
>  arch/arm64/kvm/arch_timer.c | 61 ++++++++++++++++++++++---------------
>  1 file changed, 37 insertions(+), 24 deletions(-)
> 
> diff --git a/arch/arm64/kvm/arch_timer.c b/arch/arm64/kvm/arch_timer.c
> index e2288b6bf435..7fa4f446456a 100644
> --- a/arch/arm64/kvm/arch_timer.c
> +++ b/arch/arm64/kvm/arch_timer.c
> @@ -973,6 +973,39 @@ static int kvm_timer_dying_cpu(unsigned int cpu)
>  	return 0;
>  }
>  
> +static void kvm_irq_fixup_flags(unsigned int virq, u32 *flags)
> +{
> +	*flags = irq_get_trigger_type(virq);
> +	if (*flags != IRQF_TRIGGER_HIGH && *flags != IRQF_TRIGGER_LOW) {
> +		kvm_err("Invalid trigger for timer IRQ%d, assuming level low\n",
> +			virq);
> +		*flags = IRQF_TRIGGER_LOW;
> +	}
> +}
> +
> +static int kvm_irq_init(struct arch_timer_kvm_info *info)
> +{
> +	struct irq_domain *domain = NULL;
> +	struct fwnode_handle *fwnode;
> +	struct irq_data *data;

Shouldn't this belong to patch #8?

> +
> +	if (info->virtual_irq <= 0) {
> +		kvm_err("kvm_arch_timer: invalid virtual timer IRQ: %d\n",
> +			info->virtual_irq);
> +		return -ENODEV;
> +	}
> +
> +	host_vtimer_irq = info->virtual_irq;
> +	kvm_irq_fixup_flags(host_vtimer_irq, &host_vtimer_irq_flags);
> +
> +	if (info->physical_irq > 0) {
> +		host_ptimer_irq = info->physical_irq;
> +		kvm_irq_fixup_flags(host_ptimer_irq, &host_ptimer_irq_flags);
> +	}
> +
> +	return 0;
> +}

Otherwise this look like a good refactoring.

Zenghui
