Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 34F8E379395
	for <lists+kvm@lfdr.de>; Mon, 10 May 2021 18:19:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231243AbhEJQUS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 10 May 2021 12:20:18 -0400
Received: from foss.arm.com ([217.140.110.172]:33710 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230254AbhEJQUQ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 10 May 2021 12:20:16 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id C6F31168F;
        Mon, 10 May 2021 09:19:11 -0700 (PDT)
Received: from C02TD0UTHF1T.local (unknown [10.57.4.9])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 063FE3F73B;
        Mon, 10 May 2021 09:19:09 -0700 (PDT)
Date:   Mon, 10 May 2021 17:19:07 +0100
From:   Mark Rutland <mark.rutland@arm.com>
To:     Marc Zyngier <maz@kernel.org>
Cc:     linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org,
        kvmarm@lists.cs.columbia.edu, James Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Eric Auger <eric.auger@redhat.com>,
        Hector Martin <marcan@marcan.st>, kernel-team@android.com
Subject: Re: [PATCH v3 3/9] KVM: arm64: vgic: Be tolerant to the lack of
 maintenance interrupt
Message-ID: <20210510161907.GD92897@C02TD0UTHF1T.local>
References: <20210510134824.1910399-1-maz@kernel.org>
 <20210510134824.1910399-4-maz@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210510134824.1910399-4-maz@kernel.org>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, May 10, 2021 at 02:48:18PM +0100, Marc Zyngier wrote:
> As it turns out, not all the interrupt controllers are able to
> expose a vGIC maintenance interrupt as a distrete signal.
> And to be fair, it doesn't really matter as all we require is
> for *something* to kick us out of guest mode out way or another.
> 
> On systems that do not expose a maintenance interrupt as such,
> there are two outcomes:
> 
> - either the virtual CPUIF does generate an interrupt, and
>   by the time we are back to the host the interrupt will have long
>   been disabled (as we set ICH_HCR_EL2.EN to 0 on exit). In this case,
>   interrupt latency is as good as it gets.
> 
> - or some other event (physical timer) will take us out of the guest
>   anyway, and the only drawback is a bad interrupt latency.

IIRC we won't have a a guaranteed schedular tick for NO_HZ_FULL, so in
that case we'll either need to set a period software maintenance
interrupt, or reject this combination at runtime (either when trying to
isolate the dynticks CPUs, or when trying to create a VM).

Otherwise, it's very likely that something will take us out of the guest
from time to time, but we won't have a strict guarantee (e.g. if all
guest memory is pinned).

Thanks,
Mark.

> 
> So let's be tolerant to the lack of maintenance interrupt, and just let
> the user know that their mileage may vary...
> 
> Signed-off-by: Marc Zyngier <maz@kernel.org>
> ---
>  arch/arm64/kvm/vgic/vgic-init.c | 10 +++++-----
>  1 file changed, 5 insertions(+), 5 deletions(-)
> 
> diff --git a/arch/arm64/kvm/vgic/vgic-init.c b/arch/arm64/kvm/vgic/vgic-init.c
> index 2fdb65529594..9fd23f32aa54 100644
> --- a/arch/arm64/kvm/vgic/vgic-init.c
> +++ b/arch/arm64/kvm/vgic/vgic-init.c
> @@ -524,11 +524,6 @@ int kvm_vgic_hyp_init(void)
>  	if (!gic_kvm_info)
>  		return -ENODEV;
>  
> -	if (!gic_kvm_info->maint_irq) {
> -		kvm_err("No vgic maintenance irq\n");
> -		return -ENXIO;
> -	}
> -
>  	switch (gic_kvm_info->type) {
>  	case GIC_V2:
>  		ret = vgic_v2_probe(gic_kvm_info);
> @@ -552,6 +547,11 @@ int kvm_vgic_hyp_init(void)
>  	if (ret)
>  		return ret;
>  
> +	if (!kvm_vgic_global_state.maint_irq) {
> +		kvm_err("No maintenance interrupt available, fingers crossed...\n");
> +		return 0;
> +	}
> +
>  	ret = request_percpu_irq(kvm_vgic_global_state.maint_irq,
>  				 vgic_maintenance_handler,
>  				 "vgic", kvm_get_running_vcpus());
> -- 
> 2.29.2
> 
