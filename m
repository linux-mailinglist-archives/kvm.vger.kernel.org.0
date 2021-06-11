Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E131A3A469D
	for <lists+kvm@lfdr.de>; Fri, 11 Jun 2021 18:37:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229685AbhFKQjl (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 11 Jun 2021 12:39:41 -0400
Received: from foss.arm.com ([217.140.110.172]:34758 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229517AbhFKQjl (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 11 Jun 2021 12:39:41 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id CAE61D6E;
        Fri, 11 Jun 2021 09:37:42 -0700 (PDT)
Received: from [192.168.0.110] (unknown [172.31.20.19])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 6145B3F719;
        Fri, 11 Jun 2021 09:37:41 -0700 (PDT)
Subject: Re: [PATCH v4 3/9] KVM: arm64: vgic: Be tolerant to the lack of
 maintenance interrupt masking
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
 <20210601104005.81332-4-maz@kernel.org>
From:   Alexandru Elisei <alexandru.elisei@arm.com>
Message-ID: <a02e67c6-fceb-ed6a-fc73-8649d8d18dd8@arm.com>
Date:   Fri, 11 Jun 2021 17:38:33 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <20210601104005.81332-4-maz@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Marc,

On 6/1/21 11:39 AM, Marc Zyngier wrote:
> As it turns out, not all the interrupt controllers are able to
> expose a vGIC maintenance interrupt that can be independently
> enabled/disabled.
>
> And to be fair, it doesn't really matter as all we require is
> for the interrupt to kick us out of guest mode out way or another.
>
> To that effect, add gic_kvm_info.no_maint_irq_mask for an interrupt
> controller to advertise the lack of masking.
>
> Signed-off-by: Marc Zyngier <maz@kernel.org>
> ---
>  arch/arm64/kvm/vgic/vgic-init.c       | 8 +++++++-
>  include/linux/irqchip/arm-vgic-info.h | 2 ++
>  2 files changed, 9 insertions(+), 1 deletion(-)
>
> diff --git a/arch/arm64/kvm/vgic/vgic-init.c b/arch/arm64/kvm/vgic/vgic-init.c
> index 2fdb65529594..6752d084934d 100644
> --- a/arch/arm64/kvm/vgic/vgic-init.c
> +++ b/arch/arm64/kvm/vgic/vgic-init.c
> @@ -519,12 +519,15 @@ void kvm_vgic_init_cpu_hardware(void)
>   */
>  int kvm_vgic_hyp_init(void)
>  {
> +	bool has_mask;
>  	int ret;
>  
>  	if (!gic_kvm_info)
>  		return -ENODEV;
>  
> -	if (!gic_kvm_info->maint_irq) {
> +	has_mask = !gic_kvm_info->no_maint_irq_mask;

This double negative is pretty awkward, I suppose this was done to avoid changes
to the gic drivers, because the default value is 0 (false). Just an idea, maybe
renaming it to maint_irq_unmaskable would be more readable?

Other than that, the patch looks good:

Reviewed-by: Alexandru Elisei <alexandru.elisei@arm.com>

Thanks,

Alex

> +
> +	if (has_mask && !gic_kvm_info->maint_irq) {
>  		kvm_err("No vgic maintenance irq\n");
>  		return -ENXIO;
>  	}
> @@ -552,6 +555,9 @@ int kvm_vgic_hyp_init(void)
>  	if (ret)
>  		return ret;
>  
> +	if (!has_mask)
> +		return 0;
> +
>  	ret = request_percpu_irq(kvm_vgic_global_state.maint_irq,
>  				 vgic_maintenance_handler,
>  				 "vgic", kvm_get_running_vcpus());
> diff --git a/include/linux/irqchip/arm-vgic-info.h b/include/linux/irqchip/arm-vgic-info.h
> index a25d4da5697d..7c0d08ebb82c 100644
> --- a/include/linux/irqchip/arm-vgic-info.h
> +++ b/include/linux/irqchip/arm-vgic-info.h
> @@ -24,6 +24,8 @@ struct gic_kvm_info {
>  	struct resource vcpu;
>  	/* Interrupt number */
>  	unsigned int	maint_irq;
> +	/* No interrupt mask, no need to use the above field */
> +	bool		no_maint_irq_mask;
>  	/* Virtual control interface */
>  	struct resource vctrl;
>  	/* vlpi support */
