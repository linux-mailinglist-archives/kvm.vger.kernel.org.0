Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 81CAA38CB73
	for <lists+kvm@lfdr.de>; Fri, 21 May 2021 19:00:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237362AbhEURBu (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 21 May 2021 13:01:50 -0400
Received: from foss.arm.com ([217.140.110.172]:51702 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234370AbhEURBt (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 21 May 2021 13:01:49 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 17F7F1424;
        Fri, 21 May 2021 10:00:26 -0700 (PDT)
Received: from [192.168.0.110] (unknown [172.31.20.19])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id AC43B3F73D;
        Fri, 21 May 2021 10:00:24 -0700 (PDT)
Subject: Re: [PATCH v3 4/9] KVM: arm64: vgic: Let an interrupt controller
 advertise lack of HW deactivation
To:     Marc Zyngier <maz@kernel.org>,
        linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org,
        kvmarm@lists.cs.columbia.edu
Cc:     James Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Eric Auger <eric.auger@redhat.com>,
        Hector Martin <marcan@marcan.st>,
        Mark Rutland <mark.rutland@arm.com>, kernel-team@android.com
References: <20210510134824.1910399-1-maz@kernel.org>
 <20210510134824.1910399-5-maz@kernel.org>
From:   Alexandru Elisei <alexandru.elisei@arm.com>
Message-ID: <417846b3-ff5e-1832-82b2-3e0064275944@arm.com>
Date:   Fri, 21 May 2021 18:01:05 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <20210510134824.1910399-5-maz@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Marc,

On 5/10/21 2:48 PM, Marc Zyngier wrote:
> The vGIC, as architected by ARM, allows a virtual interrupt to
> trigger the deactivation of a physical interrupt. This allows
> the following interrupt to be delivered without requiring an exit.

If I got this right, the AIC doesn't implement/ignores the ICH_LR_EL2.HW bit. Does
it mean that the CPU IF behaves as if HW = 0b0, meaning it asserts a maintenance
interrupt on virtual interrupt deactivation when ICH_LR_EL2.EOI = 0b1? I assume
that's the case, just double checking.

I am wondering what would happen if we come across an interrupt controller where
the CPU IF cannot assert a maintenance interrupt at all and we rely on the EOI bit
to take us out of the guest to deactivate the HW interrupt. I have to say that it
looks a bit strange to start relying on the maintenance interrupt to emulate
interrupt deactivate for hardware interrupts, but at the same timer allowing an
interrupt controller without a maintenance interrupt.

Other than that, this idea sounds like the best thing to do considering the
circumstances, I certainly can't think of anything better.

>
> However, some implementations have choosen not to implement this,
> meaning that we will need some unsavoury workarounds to deal with this.
>
> On detecting such a case, taint the kernel and spit a nastygram.
> We'll deal with this in later patches.
>
> Signed-off-by: Marc Zyngier <maz@kernel.org>
> ---
>  arch/arm64/kvm/vgic/vgic-init.c       | 10 ++++++++++
>  include/kvm/arm_vgic.h                |  3 +++
>  include/linux/irqchip/arm-vgic-info.h |  2 ++
>  3 files changed, 15 insertions(+)
>
> diff --git a/arch/arm64/kvm/vgic/vgic-init.c b/arch/arm64/kvm/vgic/vgic-init.c
> index 9fd23f32aa54..5b06a9970a57 100644
> --- a/arch/arm64/kvm/vgic/vgic-init.c
> +++ b/arch/arm64/kvm/vgic/vgic-init.c
> @@ -524,6 +524,16 @@ int kvm_vgic_hyp_init(void)
>  	if (!gic_kvm_info)
>  		return -ENODEV;
>  
> +	/*
> +	 * If we get one of these oddball non-GICs, taint the kernel,
> +	 * as we have no idea of how they *really* behave.
> +	 */
> +	if (gic_kvm_info->no_hw_deactivation) {
> +		kvm_info("Non-architectural vgic, tainting kernel\n");
> +		add_taint(TAINT_CPU_OUT_OF_SPEC, LOCKDEP_STILL_OK);
> +		kvm_vgic_global_state.no_hw_deactivation = true;
> +	}

IMO, since this means we're going to rely even more on the maintenance interrupt
(not just for software emulation of level sensitive interrupts), I think there
should be some sort of dependency on having something that resembles a working
maintenance interrupt.

Thanks,

Alex

> +
>  	switch (gic_kvm_info->type) {
>  	case GIC_V2:
>  		ret = vgic_v2_probe(gic_kvm_info);
> diff --git a/include/kvm/arm_vgic.h b/include/kvm/arm_vgic.h
> index ec621180ef09..e45b26e8d479 100644
> --- a/include/kvm/arm_vgic.h
> +++ b/include/kvm/arm_vgic.h
> @@ -72,6 +72,9 @@ struct vgic_global {
>  	bool			has_gicv4;
>  	bool			has_gicv4_1;
>  
> +	/* Pseudo GICv3 from outer space */
> +	bool			no_hw_deactivation;
> +
>  	/* GIC system register CPU interface */
>  	struct static_key_false gicv3_cpuif;
>  
> diff --git a/include/linux/irqchip/arm-vgic-info.h b/include/linux/irqchip/arm-vgic-info.h
> index 0319636be928..d39d0b591c5a 100644
> --- a/include/linux/irqchip/arm-vgic-info.h
> +++ b/include/linux/irqchip/arm-vgic-info.h
> @@ -30,6 +30,8 @@ struct gic_kvm_info {
>  	bool		has_v4;
>  	/* rvpeid support */
>  	bool		has_v4_1;
> +	/* Deactivation impared, subpar stuff */
> +	bool		no_hw_deactivation;
>  };
>  
>  #ifdef CONFIG_KVM
