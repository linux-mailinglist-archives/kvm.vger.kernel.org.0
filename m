Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 39202872B3
	for <lists+kvm@lfdr.de>; Fri,  9 Aug 2019 09:09:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405691AbfHIHJD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 9 Aug 2019 03:09:03 -0400
Received: from inca-roads.misterjones.org ([213.251.177.50]:43265 "EHLO
        inca-roads.misterjones.org" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725954AbfHIHJD (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 9 Aug 2019 03:09:03 -0400
Received: from 78.163-31-62.static.virginmediabusiness.co.uk ([62.31.163.78] helo=why)
        by cheepnis.misterjones.org with esmtpsa (TLSv1.2:AES256-GCM-SHA384:256)
        (Exim 4.80)
        (envelope-from <maz@kernel.org>)
        id 1hvz1H-0002zE-LG; Fri, 09 Aug 2019 09:08:59 +0200
Date:   Fri, 9 Aug 2019 08:08:56 +0100
From:   Marc Zyngier <maz@kernel.org>
To:     Alexandru Elisei <alexandru.elisei@arm.com>
Cc:     linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        kvm@vger.kernel.org, andre.przywara@arm.com
Subject: Re: [PATCH] KVM: arm/arm64: vgic: Reevaluate level sensitive
 interrupts on enable
Message-ID: <20190809080856.61ab570b@why>
In-Reply-To: <1565171600-11082-1-git-send-email-alexandru.elisei@arm.com>
References: <1565171600-11082-1-git-send-email-alexandru.elisei@arm.com>
Organization: Approximate
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SA-Exim-Connect-IP: 62.31.163.78
X-SA-Exim-Rcpt-To: alexandru.elisei@arm.com, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, andre.przywara@arm.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on cheepnis.misterjones.org); SAEximRunCond expanded to false
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed,  7 Aug 2019 10:53:20 +0100
Alexandru Elisei <alexandru.elisei@arm.com> wrote:

> A HW mapped level sensitive interrupt asserted by a device will not be put
> into the ap_list if it is disabled at the VGIC level. When it is enabled
> again, it will be inserted into the ap_list and written to a list register
> on guest entry regardless of the state of the device.
> 
> We could argue that this can also happen on real hardware, when the command
> to enable the interrupt reached the GIC before the device had the chance to
> de-assert the interrupt signal; however, we emulate the distributor and
> redistributors in software and we can do better than that.
> 
> Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>
> ---
>  virt/kvm/arm/vgic/vgic-mmio.c | 16 ++++++++++++++++
>  1 file changed, 16 insertions(+)
> 
> diff --git a/virt/kvm/arm/vgic/vgic-mmio.c b/virt/kvm/arm/vgic/vgic-mmio.c
> index 3ba7278fb533..44efc2ff863f 100644
> --- a/virt/kvm/arm/vgic/vgic-mmio.c
> +++ b/virt/kvm/arm/vgic/vgic-mmio.c
> @@ -113,6 +113,22 @@ void vgic_mmio_write_senable(struct kvm_vcpu *vcpu,
>  		struct vgic_irq *irq = vgic_get_irq(vcpu->kvm, vcpu, intid + i);
>  
>  		raw_spin_lock_irqsave(&irq->irq_lock, flags);
> +		if (vgic_irq_is_mapped_level(irq)) {
> +			bool was_high = irq->line_level;
> +
> +			/*
> +			 * We need to update the state of the interrupt because
> +			 * the guest might have changed the state of the device
> +			 * while the interrupt was disabled at the VGIC level.
> +			 */
> +			irq->line_level = vgic_get_phys_line_level(irq);
> +			/*
> +			 * Deactivate the physical interrupt so the GIC will let
> +			 * us know when it is asserted again.
> +			 */
> +			if (!irq->active && was_high && !irq->line_level)
> +				vgic_irq_set_phys_active(irq, false);
> +		}
>  		irq->enabled = true;
>  		vgic_queue_irq_unlock(vcpu->kvm, irq, flags);
>  


Applied, thanks.

	M.
-- 
Without deviation from the norm, progress is not possible.
