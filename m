Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E7AF5114F89
	for <lists+kvm@lfdr.de>; Fri,  6 Dec 2019 11:56:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726244AbfLFK4h (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 6 Dec 2019 05:56:37 -0500
Received: from inca-roads.misterjones.org ([213.251.177.50]:37079 "EHLO
        inca-roads.misterjones.org" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726154AbfLFK4g (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 6 Dec 2019 05:56:36 -0500
Received: from www-data by cheepnis.misterjones.org with local (Exim 4.80)
        (envelope-from <maz@kernel.org>)
        id 1idBHd-0001CF-6Z; Fri, 06 Dec 2019 11:56:25 +0100
To:     linmiaohe <linmiaohe@huawei.com>
Subject: Re: [PATCH] KVM: arm: fix missing =?UTF-8?Q?free=5Fpercpu=5Firq?=  =?UTF-8?Q?=20in=20kvm=5Ftimer=5Fhyp=5Finit=28=29?=
X-PHP-Originating-Script: 0:main.inc
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Fri, 06 Dec 2019 10:56:24 +0000
From:   Marc Zyngier <maz@kernel.org>
Cc:     <pbonzini@redhat.com>, <rkrcmar@redhat.com>, <james.morse@arm.com>,
        <julien.thierry.kdev@gmail.com>, <suzuki.poulose@arm.com>,
        <linux-arm-kernel@lists.infradead.org>,
        <kvmarm@lists.cs.columbia.edu>, <linux-kernel@vger.kernel.org>,
        <kvm@vger.kernel.org>
In-Reply-To: <1574476229-15448-1-git-send-email-linmiaohe@huawei.com>
References: <1574476229-15448-1-git-send-email-linmiaohe@huawei.com>
Message-ID: <96f07f61e3356c942ce934f81efc4a94@www.loen.fr>
X-Sender: maz@kernel.org
User-Agent: Roundcube Webmail/0.7.2
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Rcpt-To: linmiaohe@huawei.com, pbonzini@redhat.com, rkrcmar@redhat.com, james.morse@arm.com, julien.thierry.kdev@gmail.com, suzuki.poulose@arm.com, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, linux-kernel@vger.kernel.org, kvm@vger.kernel.org
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on cheepnis.misterjones.org); SAEximRunCond expanded to false
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 2019-11-23 02:30, linmiaohe wrote:
> From: Miaohe Lin <linmiaohe@huawei.com>
>
> When host_ptimer_irq request irq resource failed, we forget
> to release the host_vtimer_irq resource already requested.
> Fix this missing irq release and other similar scenario.

That's really not a big deal, as nothing but KVM can use the
timers anyway, but I guess it doesn't hurt to be correct.

>
> Fixes: 9e01dc76be6a ("KVM: arm/arm64: arch_timer: Assign the phys
> timer on VHE systems")
> Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>
> ---
>  virt/kvm/arm/arch_timer.c | 17 ++++++++++++-----
>  1 file changed, 12 insertions(+), 5 deletions(-)
>
> diff --git a/virt/kvm/arm/arch_timer.c b/virt/kvm/arm/arch_timer.c
> index f182b2380345..73867f97040c 100644
> --- a/virt/kvm/arm/arch_timer.c
> +++ b/virt/kvm/arm/arch_timer.c
> @@ -935,7 +935,7 @@ int kvm_timer_hyp_init(bool has_gic)
>  					    kvm_get_running_vcpus());
>  		if (err) {
>  			kvm_err("kvm_arch_timer: error setting vcpu affinity\n");
> -			goto out_free_irq;
> +			goto out_free_vtimer_irq;
>  		}
>
>  		static_branch_enable(&has_gic_active_state);
> @@ -960,7 +960,7 @@ int kvm_timer_hyp_init(bool has_gic)
>  		if (err) {
>  			kvm_err("kvm_arch_timer: can't request ptimer interrupt %d 
> (%d)\n",
>  				host_ptimer_irq, err);
> -			return err;
> +			goto out_disable_gic_state;
>  		}
>
>  		if (has_gic) {
> @@ -968,7 +968,7 @@ int kvm_timer_hyp_init(bool has_gic)
>  						    kvm_get_running_vcpus());
>  			if (err) {
>  				kvm_err("kvm_arch_timer: error setting vcpu affinity\n");
> -				goto out_free_irq;
> +				goto out_free_ptimer_irq;
>  			}
>  		}
>
> @@ -977,15 +977,22 @@ int kvm_timer_hyp_init(bool has_gic)
>  		kvm_err("kvm_arch_timer: invalid physical timer IRQ: %d\n",
>  			info->physical_irq);
>  		err = -ENODEV;
> -		goto out_free_irq;
> +		goto out_disable_gic_state;
>  	}
>
>  	cpuhp_setup_state(CPUHP_AP_KVM_ARM_TIMER_STARTING,
>  			  "kvm/arm/timer:starting", kvm_timer_starting_cpu,
>  			  kvm_timer_dying_cpu);
>  	return 0;
> -out_free_irq:
> +
> +out_free_ptimer_irq:
> +	free_percpu_irq(host_ptimer_irq, kvm_get_running_vcpus());
> +out_disable_gic_state:
> +	if (has_gic)
> +		static_branch_disable(&has_gic_active_state);

Given that we're failing the init of KVM, this is totally
superfluous. Also, this state is still valid, no matter
what happens (the GIC is not going away from under our feet).

> +out_free_vtimer_irq:
>  	free_percpu_irq(host_vtimer_irq, kvm_get_running_vcpus());
> +
>  	return err;
>  }

Thanks,

         M.
-- 
Jazz is not dead. It just smells funny...
