Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 869D52EA721
	for <lists+kvm@lfdr.de>; Tue,  5 Jan 2021 10:16:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727922AbhAEJOY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 5 Jan 2021 04:14:24 -0500
Received: from mail.kernel.org ([198.145.29.99]:46964 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727658AbhAEJOX (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 5 Jan 2021 04:14:23 -0500
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org [51.254.78.96])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3756C225AC;
        Tue,  5 Jan 2021 09:13:42 +0000 (UTC)
Received: from disco-boy.misterjones.org ([51.254.78.96] helo=www.loen.fr)
        by disco-boy.misterjones.org with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
        (Exim 4.94)
        (envelope-from <maz@kernel.org>)
        id 1kwiPL-005OSj-R8; Tue, 05 Jan 2021 09:13:39 +0000
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
 format=flowed
Content-Transfer-Encoding: 8bit
Date:   Tue, 05 Jan 2021 09:13:39 +0000
From:   Marc Zyngier <maz@kernel.org>
To:     Shenming Lu <lushenming@huawei.com>
Cc:     Eric Auger <eric.auger@redhat.com>, Will Deacon <will@kernel.org>,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Alex Williamson <alex.williamson@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>,
        wanghaibin.wang@huawei.com, yuzenghui@huawei.com
Subject: Re: [RFC PATCH v2 2/4] KVM: arm64: GICv4.1: Try to save hw pending
 state in save_pending_tables
In-Reply-To: <20210104081613.100-3-lushenming@huawei.com>
References: <20210104081613.100-1-lushenming@huawei.com>
 <20210104081613.100-3-lushenming@huawei.com>
User-Agent: Roundcube Webmail/1.4.9
Message-ID: <b0f0b2544f8e231ebb5b5545be226164@kernel.org>
X-Sender: maz@kernel.org
X-SA-Exim-Connect-IP: 51.254.78.96
X-SA-Exim-Rcpt-To: lushenming@huawei.com, eric.auger@redhat.com, will@kernel.org, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, linux-kernel@vger.kernel.org, alex.williamson@redhat.com, cohuck@redhat.com, lorenzo.pieralisi@arm.com, wanghaibin.wang@huawei.com, yuzenghui@huawei.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 2021-01-04 08:16, Shenming Lu wrote:
> After pausing all vCPUs and devices capable of interrupting, in order
> to save the information of all interrupts, besides flushing the pending
> states in kvm’s vgic, we also try to flush the states of VLPIs in the
> virtual pending tables into guest RAM, but we need to have GICv4.1 and
> safely unmap the vPEs first.
> 
> Signed-off-by: Shenming Lu <lushenming@huawei.com>
> ---
>  arch/arm64/kvm/vgic/vgic-v3.c | 58 +++++++++++++++++++++++++++++++----
>  1 file changed, 52 insertions(+), 6 deletions(-)
> 
> diff --git a/arch/arm64/kvm/vgic/vgic-v3.c 
> b/arch/arm64/kvm/vgic/vgic-v3.c
> index 9cdf39a94a63..a58c94127cb0 100644
> --- a/arch/arm64/kvm/vgic/vgic-v3.c
> +++ b/arch/arm64/kvm/vgic/vgic-v3.c
> @@ -1,6 +1,8 @@
>  // SPDX-License-Identifier: GPL-2.0-only
> 
>  #include <linux/irqchip/arm-gic-v3.h>
> +#include <linux/irq.h>
> +#include <linux/irqdomain.h>
>  #include <linux/kvm.h>
>  #include <linux/kvm_host.h>
>  #include <kvm/arm_vgic.h>
> @@ -356,6 +358,38 @@ int vgic_v3_lpi_sync_pending_status(struct kvm
> *kvm, struct vgic_irq *irq)
>  	return 0;
>  }
> 
> +/*
> + * The deactivation of the doorbell interrupt will trigger the
> + * unmapping of the associated vPE.
> + */
> +static void unmap_all_vpes(struct vgic_dist *dist)
> +{
> +	struct irq_desc *desc;
> +	int i;
> +
> +	if (!kvm_vgic_global_state.has_gicv4_1)
> +		return;
> +
> +	for (i = 0; i < dist->its_vm.nr_vpes; i++) {
> +		desc = irq_to_desc(dist->its_vm.vpes[i]->irq);
> +		irq_domain_deactivate_irq(irq_desc_get_irq_data(desc));
> +	}
> +}
> +
> +static void map_all_vpes(struct vgic_dist *dist)
> +{
> +	struct irq_desc *desc;
> +	int i;
> +
> +	if (!kvm_vgic_global_state.has_gicv4_1)
> +		return;
> +
> +	for (i = 0; i < dist->its_vm.nr_vpes; i++) {
> +		desc = irq_to_desc(dist->its_vm.vpes[i]->irq);
> +		irq_domain_activate_irq(irq_desc_get_irq_data(desc), false);
> +	}
> +}
> +
>  /**
>   * vgic_v3_save_pending_tables - Save the pending tables into guest 
> RAM
>   * kvm lock and all vcpu lock must be held
> @@ -365,14 +399,18 @@ int vgic_v3_save_pending_tables(struct kvm *kvm)
>  	struct vgic_dist *dist = &kvm->arch.vgic;
>  	struct vgic_irq *irq;
>  	gpa_t last_ptr = ~(gpa_t)0;
> -	int ret;
> +	int ret = 0;
>  	u8 val;
> 
> +	/* As a preparation for getting any VLPI states. */
> +	unmap_all_vpes(dist);

What if the VPEs are not mapped yet? Is it possible to snapshot a VM
that has not run at all?

> +
>  	list_for_each_entry(irq, &dist->lpi_list_head, lpi_list) {
>  		int byte_offset, bit_nr;
>  		struct kvm_vcpu *vcpu;
>  		gpa_t pendbase, ptr;
>  		bool stored;
> +		bool is_pending = irq->pending_latch;
> 
>  		vcpu = irq->target_vcpu;
>  		if (!vcpu)
> @@ -387,24 +425,32 @@ int vgic_v3_save_pending_tables(struct kvm *kvm)
>  		if (ptr != last_ptr) {
>  			ret = kvm_read_guest_lock(kvm, ptr, &val, 1);
>  			if (ret)
> -				return ret;
> +				goto out;
>  			last_ptr = ptr;
>  		}
> 
>  		stored = val & (1U << bit_nr);
> -		if (stored == irq->pending_latch)
> +
> +		if (irq->hw)
> +			vgic_v4_get_vlpi_state(irq, &is_pending);

You don't check the return value here, so I wonder why the checks
in vgic_v4_get_vlpi_state().

Another thing that worries me is that vgic_v4_get_vlpi_state() doesn't
have any cache invalidation, and can end-up hitting in the CPU cache
(there is no guarantee of coherency between the GIC and the CPU, only
that the GIC will have flushed its caches).

I'd expect this to happen at unmap time, though, in order to avoid
repeated single byte invalidations.

> +
> +		if (stored == is_pending)
>  			continue;
> 
> -		if (irq->pending_latch)
> +		if (is_pending)
>  			val |= 1 << bit_nr;
>  		else
>  			val &= ~(1 << bit_nr);
> 
>  		ret = kvm_write_guest_lock(kvm, ptr, &val, 1);
>  		if (ret)
> -			return ret;
> +			goto out;
>  	}
> -	return 0;
> +
> +out:
> +	map_all_vpes(dist);
> +
> +	return ret;
>  }
> 
>  /**

Thanks,

         M.
-- 
Jazz is not dead. It just smells funny...
