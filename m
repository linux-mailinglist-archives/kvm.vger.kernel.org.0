Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4CB843AEDAD
	for <lists+kvm@lfdr.de>; Mon, 21 Jun 2021 18:19:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231320AbhFUQWB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 21 Jun 2021 12:22:01 -0400
Received: from foss.arm.com ([217.140.110.172]:36758 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231487AbhFUQVB (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 21 Jun 2021 12:21:01 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id DBB921042;
        Mon, 21 Jun 2021 09:18:46 -0700 (PDT)
Received: from [192.168.0.110] (unknown [172.31.20.19])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 694C53F694;
        Mon, 21 Jun 2021 09:18:45 -0700 (PDT)
Subject: Re: [PATCH v4 7/9] KVM: arm64: timer: Refactor IRQ configuration
To:     Marc Zyngier <maz@kernel.org>,
        linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org,
        kvmarm@lists.cs.columbia.edu
Cc:     James Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Eric Auger <eric.auger@redhat.com>,
        Hector Martin <marcan@marcan.st>,
        Mark Rutland <mark.rutland@arm.com>,
        Zenghui Yu <yuzenghui@huawei.com>, kernel-team@android.com
References: <20210601104005.81332-1-maz@kernel.org>
 <20210601104005.81332-8-maz@kernel.org>
From:   Alexandru Elisei <alexandru.elisei@arm.com>
Message-ID: <92a66e4a-a9bf-1568-5af8-7b2ecbb77661@arm.com>
Date:   Mon, 21 Jun 2021 17:19:38 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <20210601104005.81332-8-maz@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Marc,

On 6/1/21 11:40 AM, Marc Zyngier wrote:
> As we are about to add some more things to the timer IRQ
> configuration, move this code out of the main timer init code
> into its own set of functions.
>
> No functional changes.

That looks to be the case for me:

Reviewed-by: Alexandru Elisei <alexandru.elisei@arm.com>

Thanks,

Alex

>
> Signed-off-by: Marc Zyngier <maz@kernel.org>
> ---
>  arch/arm64/kvm/arch_timer.c | 57 +++++++++++++++++++++----------------
>  1 file changed, 33 insertions(+), 24 deletions(-)
>
> diff --git a/arch/arm64/kvm/arch_timer.c b/arch/arm64/kvm/arch_timer.c
> index e2288b6bf435..3cd170388d88 100644
> --- a/arch/arm64/kvm/arch_timer.c
> +++ b/arch/arm64/kvm/arch_timer.c
> @@ -973,6 +973,35 @@ static int kvm_timer_dying_cpu(unsigned int cpu)
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
> +
>  int kvm_timer_hyp_init(bool has_gic)
>  {
>  	struct arch_timer_kvm_info *info;
> @@ -986,22 +1015,11 @@ int kvm_timer_hyp_init(bool has_gic)
>  		return -ENODEV;
>  	}
>  
> -	/* First, do the virtual EL1 timer irq */
> -
> -	if (info->virtual_irq <= 0) {
> -		kvm_err("kvm_arch_timer: invalid virtual timer IRQ: %d\n",
> -			info->virtual_irq);
> -		return -ENODEV;
> -	}
> -	host_vtimer_irq = info->virtual_irq;
> +	err = kvm_irq_init(info);
> +	if (err)
> +		return err;
>  
> -	host_vtimer_irq_flags = irq_get_trigger_type(host_vtimer_irq);
> -	if (host_vtimer_irq_flags != IRQF_TRIGGER_HIGH &&
> -	    host_vtimer_irq_flags != IRQF_TRIGGER_LOW) {
> -		kvm_err("Invalid trigger for vtimer IRQ%d, assuming level low\n",
> -			host_vtimer_irq);
> -		host_vtimer_irq_flags = IRQF_TRIGGER_LOW;
> -	}
> +	/* First, do the virtual EL1 timer irq */
>  
>  	err = request_percpu_irq(host_vtimer_irq, kvm_arch_timer_handler,
>  				 "kvm guest vtimer", kvm_get_running_vcpus());
> @@ -1027,15 +1045,6 @@ int kvm_timer_hyp_init(bool has_gic)
>  	/* Now let's do the physical EL1 timer irq */
>  
>  	if (info->physical_irq > 0) {
> -		host_ptimer_irq = info->physical_irq;
> -		host_ptimer_irq_flags = irq_get_trigger_type(host_ptimer_irq);
> -		if (host_ptimer_irq_flags != IRQF_TRIGGER_HIGH &&
> -		    host_ptimer_irq_flags != IRQF_TRIGGER_LOW) {
> -			kvm_err("Invalid trigger for ptimer IRQ%d, assuming level low\n",
> -				host_ptimer_irq);
> -			host_ptimer_irq_flags = IRQF_TRIGGER_LOW;
> -		}
> -
>  		err = request_percpu_irq(host_ptimer_irq, kvm_arch_timer_handler,
>  					 "kvm guest ptimer", kvm_get_running_vcpus());
>  		if (err) {
