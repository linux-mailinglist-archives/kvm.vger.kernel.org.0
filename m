Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 93A153A82BA
	for <lists+kvm@lfdr.de>; Tue, 15 Jun 2021 16:25:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231466AbhFOO1h (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 15 Jun 2021 10:27:37 -0400
Received: from foss.arm.com ([217.140.110.172]:37076 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231384AbhFOO1T (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 15 Jun 2021 10:27:19 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 4E12212FC;
        Tue, 15 Jun 2021 07:25:14 -0700 (PDT)
Received: from [192.168.0.110] (unknown [172.31.20.19])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id CD51A3F719;
        Tue, 15 Jun 2021 07:25:12 -0700 (PDT)
Subject: Re: [PATCH v4 4/9] KVM: arm64: vgic: Let an interrupt controller
 advertise lack of HW deactivation
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
 <20210601104005.81332-5-maz@kernel.org>
From:   Alexandru Elisei <alexandru.elisei@arm.com>
Message-ID: <fa1fee85-04c6-d0a8-bd93-64d2ebc32e4a@arm.com>
Date:   Tue, 15 Jun 2021 15:26:02 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <20210601104005.81332-5-maz@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Marc,

On 6/1/21 11:40 AM, Marc Zyngier wrote:
> The vGIC, as architected by ARM, allows a virtual interrupt to
> trigger the deactivation of a physical interrupt. This allows
> the following interrupt to be delivered without requiring an exit.
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
> index 6752d084934d..340c51d87677 100644
> --- a/arch/arm64/kvm/vgic/vgic-init.c
> +++ b/arch/arm64/kvm/vgic/vgic-init.c
> @@ -532,6 +532,16 @@ int kvm_vgic_hyp_init(void)
>  		return -ENXIO;
>  	}
>  
> +	/*
> +	 * If we get one of these oddball non-GICs, taint the kernel,
> +	 * as we have no idea of how they *really* behave.
> +	 */
> +	if (gic_kvm_info->no_hw_deactivation) {
> +		kvm_info("Non-architectural vgic, tainting kernel\n");
> +		add_taint(TAINT_CPU_OUT_OF_SPEC, LOCKDEP_STILL_OK);

I'm trying to figure out what are the effects of tainting the kernel, besides
those nasty messages. In Documentation/admin-guide/tainted-kernels.rst, I found
this bit:

[..] the information is mainly of interest once someone wants to investigate some
problem, as its real cause might be the event that got the kernel tainted. That's
why bug reports from tainted kernels will often be ignored by developers, hence
try to reproduce problems with an untainted kernel.

The lack of HW deactivation affects only KVM, I was wondering if we could taint
the kernel the first time a VM created. If the above doc is to go by, someone who
is running Linux on an M1, but not using KVM, might stand a better chance to get
support when something goes wrong in that case.

What do you think?

Thanks,

Alex

> +		kvm_vgic_global_state.no_hw_deactivation = true;
> +	}
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
> index 7c0d08ebb82c..a75b2c7de69d 100644
> --- a/include/linux/irqchip/arm-vgic-info.h
> +++ b/include/linux/irqchip/arm-vgic-info.h
> @@ -32,6 +32,8 @@ struct gic_kvm_info {
>  	bool		has_v4;
>  	/* rvpeid support */
>  	bool		has_v4_1;
> +	/* Deactivation impared, subpar stuff */
> +	bool		no_hw_deactivation;
>  };
>  
>  #ifdef CONFIG_KVM
