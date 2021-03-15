Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1895F33B090
	for <lists+kvm@lfdr.de>; Mon, 15 Mar 2021 12:03:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229875AbhCOLCr (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 15 Mar 2021 07:02:47 -0400
Received: from foss.arm.com ([217.140.110.172]:60478 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229519AbhCOLC1 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 15 Mar 2021 07:02:27 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 956C6D6E;
        Mon, 15 Mar 2021 04:02:26 -0700 (PDT)
Received: from e121166-lin.cambridge.arm.com (e121166-lin.cambridge.arm.com [10.1.196.255])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id E3B953F70D;
        Mon, 15 Mar 2021 04:02:25 -0700 (PDT)
Date:   Mon, 15 Mar 2021 11:02:20 +0000
From:   Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>
To:     Marc Zyngier <maz@kernel.org>
Cc:     linux-kernel@vger.kernel.org,
        LAKML <linux-arm-kernel@lists.infradead.org>,
        KVM <kvm@vger.kernel.org>
Subject: Re: [PATCH v2 1/1] irqchip/gic-v4.1: Disable vSGI upon (GIC CPUIF <
 v4.1) detection
Message-ID: <20210315110220.GA18335@e121166-lin.cambridge.arm.com>
References: <0201111162841.3151-1-lorenzo.pieralisi@arm.com>
 <20210302102744.12692-1-lorenzo.pieralisi@arm.com>
 <20210302102744.12692-2-lorenzo.pieralisi@arm.com>
 <87zgzdxxf2.wl-maz@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87zgzdxxf2.wl-maz@kernel.org>
User-Agent: Mutt/1.9.4 (2018-02-28)
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Mar 08, 2021 at 07:22:57PM +0000, Marc Zyngier wrote:
> Hi Lorenzo,
> 
> On Tue, 02 Mar 2021 10:27:44 +0000,
> Lorenzo Pieralisi <lorenzo.pieralisi@arm.com> wrote:
> > 
> > GIC CPU interfaces versions predating GIC v4.1 were not built to
> > accommodate vINTID within the vSGI range; as reported in the GIC
> > specifications (8.2 "Changes to the CPU interface"), it is
> > CONSTRAINED UNPREDICTABLE to deliver a vSGI to a PE with
> > ID_AA64PFR0_EL1.GIC < b0011.
> > 
> > Check the GIC CPUIF version by reading the SYS_ID_AA64_PFR0_EL1.
> > 
> > Disable vSGIs if a CPUIF version < 4.1 is detected to prevent using
> > vSGIs on systems where they may misbehave.
> > 
> > Signed-off-by: Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>
> > Cc: Marc Zyngier <maz@kernel.org>
> > ---
> >  arch/arm64/kvm/vgic/vgic-mmio-v3.c     |  4 ++--
> >  arch/arm64/kvm/vgic/vgic-v3.c          |  3 ++-
> >  drivers/irqchip/irq-gic-v3-its.c       |  6 +++++-
> >  drivers/irqchip/irq-gic-v3.c           | 22 ++++++++++++++++++++++
> >  include/kvm/arm_vgic.h                 |  1 +
> >  include/linux/irqchip/arm-gic-common.h |  2 ++
> >  include/linux/irqchip/arm-gic-v3.h     |  1 +
> >  7 files changed, 35 insertions(+), 4 deletions(-)
> > 
> > diff --git a/arch/arm64/kvm/vgic/vgic-mmio-v3.c b/arch/arm64/kvm/vgic/vgic-mmio-v3.c
> > index 15a6c98ee92f..66548cd2a715 100644
> > --- a/arch/arm64/kvm/vgic/vgic-mmio-v3.c
> > +++ b/arch/arm64/kvm/vgic/vgic-mmio-v3.c
> > @@ -86,7 +86,7 @@ static unsigned long vgic_mmio_read_v3_misc(struct kvm_vcpu *vcpu,
> >  		}
> >  		break;
> >  	case GICD_TYPER2:
> > -		if (kvm_vgic_global_state.has_gicv4_1)
> > +		if (kvm_vgic_global_state.has_gicv4_1_vsgi)
> >  			value = GICD_TYPER2_nASSGIcap;
> >  		break;
> >  	case GICD_IIDR:
> > @@ -119,7 +119,7 @@ static void vgic_mmio_write_v3_misc(struct kvm_vcpu *vcpu,
> >  		dist->enabled = val & GICD_CTLR_ENABLE_SS_G1;
> >  
> >  		/* Not a GICv4.1? No HW SGIs */
> > -		if (!kvm_vgic_global_state.has_gicv4_1)
> > +		if (!kvm_vgic_global_state.has_gicv4_1_vsgi)
> >  			val &= ~GICD_CTLR_nASSGIreq;
> >  
> >  		/* Dist stays enabled? nASSGIreq is RO */
> > diff --git a/arch/arm64/kvm/vgic/vgic-v3.c b/arch/arm64/kvm/vgic/vgic-v3.c
> > index 52915b342351..57b73100e8cc 100644
> > --- a/arch/arm64/kvm/vgic/vgic-v3.c
> > +++ b/arch/arm64/kvm/vgic/vgic-v3.c
> > @@ -533,7 +533,7 @@ int vgic_v3_map_resources(struct kvm *kvm)
> >  		return ret;
> >  	}
> >  
> > -	if (kvm_vgic_global_state.has_gicv4_1)
> > +	if (kvm_vgic_global_state.has_gicv4_1_vsgi)
> >  		vgic_v4_configure_vsgis(kvm);
> >  
> >  	return 0;
> > @@ -589,6 +589,7 @@ int vgic_v3_probe(const struct gic_kvm_info *info)
> >  	if (info->has_v4) {
> >  		kvm_vgic_global_state.has_gicv4 = gicv4_enable;
> >  		kvm_vgic_global_state.has_gicv4_1 = info->has_v4_1 && gicv4_enable;
> > +		kvm_vgic_global_state.has_gicv4_1_vsgi = info->has_v4_1_vsgi && gicv4_enable;
> >  		kvm_info("GICv4%s support %sabled\n",
> >  			 kvm_vgic_global_state.has_gicv4_1 ? ".1" : "",
> >  			 gicv4_enable ? "en" : "dis");
> > diff --git a/drivers/irqchip/irq-gic-v3-its.c b/drivers/irqchip/irq-gic-v3-its.c
> > index ed46e6057e33..ee2a2ca27d5c 100644
> > --- a/drivers/irqchip/irq-gic-v3-its.c
> > +++ b/drivers/irqchip/irq-gic-v3-its.c
> > @@ -5412,7 +5412,11 @@ int __init its_init(struct fwnode_handle *handle, struct rdists *rdists,
> >  	if (has_v4 & rdists->has_vlpis) {
> >  		const struct irq_domain_ops *sgi_ops;
> >  
> > -		if (has_v4_1)
> > +		/*
> > +		 * Enable vSGIs only if the ITS and the
> > +		 * GIC CPUIF support them.
> > +		 */
> > +		if (has_v4_1 && rdists->has_vsgi_cpuif)
> >  			sgi_ops = &its_sgi_domain_ops;
> >  		else
> >  			sgi_ops = NULL;
> 
> This doesn't seem right. If you pass NULL for the SGI ops, you also
> lose the per-VPE doorbells and stick to the terrible GICv4.0 behaviour
> (see the use of has_v4_1() in irq-gic-v4.c). I don't think that is
> what you really want.

Yes, I was caught out again - we use the sgi_ops to detect v4.1 behaviour,
I will remove this hunk.

> > diff --git a/drivers/irqchip/irq-gic-v3.c b/drivers/irqchip/irq-gic-v3.c
> > index eb0ee356a629..fd6cd9a5de34 100644
> > --- a/drivers/irqchip/irq-gic-v3.c
> > +++ b/drivers/irqchip/irq-gic-v3.c
> > @@ -31,6 +31,21 @@
> >  
> >  #include "irq-gic-common.h"
> >  
> > +#ifdef CONFIG_ARM64
> > +#include <asm/cpufeature.h>
> > +
> > +static inline bool gic_cpuif_has_vsgi(void)
> > +{
> > +	unsigned long fld, reg = read_sanitised_ftr_reg(SYS_ID_AA64PFR0_EL1);
> > +
> > +	fld = cpuid_feature_extract_unsigned_field(reg, ID_AA64PFR0_GIC_SHIFT);
> > +
> > +	return fld >= 0x3;
> > +}
> > +#else
> > +static inline bool gic_cpuif_has_vsgi(void) { return false; }
> > +#endif
> 
> Why do we need to expose this in the GICv3 driver instead of the GICv4
> code? At the moment, you track this state:
> 
> - in gic_data.rdists.has_vsgi_cpuif
> - indirectly in gic_v3_kvm_info.has_v4_1_vsgi
> - indirectly in kvm_vgic_global_state.has_gicv4_1_vsgi
> 
> Can't we simplify the logic and track it *once*? Or even better, just
> evaluate it when required? I hacked the following stuff based on your
> patch (untested). What do you think?

Thanks for that I will give it a shot - it makes sense. I will have
a look to see if we can consolidate these v4.0 vs v4.1 checks somehow
before reposting.

Thanks a lot for the review.

Lorenzo

> Thanks,
> 
> 	M.
> 
> diff --git a/arch/arm64/kvm/vgic/vgic-mmio-v3.c b/arch/arm64/kvm/vgic/vgic-mmio-v3.c
> index 15a6c98ee92f..2f1b156021a6 100644
> --- a/arch/arm64/kvm/vgic/vgic-mmio-v3.c
> +++ b/arch/arm64/kvm/vgic/vgic-mmio-v3.c
> @@ -86,7 +86,7 @@ static unsigned long vgic_mmio_read_v3_misc(struct kvm_vcpu *vcpu,
>  		}
>  		break;
>  	case GICD_TYPER2:
> -		if (kvm_vgic_global_state.has_gicv4_1)
> +		if (kvm_vgic_global_state.has_gicv4_1 && gic_cpuif_has_vsgi())
>  			value = GICD_TYPER2_nASSGIcap;
>  		break;
>  	case GICD_IIDR:
> @@ -119,7 +119,7 @@ static void vgic_mmio_write_v3_misc(struct kvm_vcpu *vcpu,
>  		dist->enabled = val & GICD_CTLR_ENABLE_SS_G1;
>  
>  		/* Not a GICv4.1? No HW SGIs */
> -		if (!kvm_vgic_global_state.has_gicv4_1)
> +		if (!kvm_vgic_global_state.has_gicv4_1 || !gic_cpuif_has_vsgi())
>  			val &= ~GICD_CTLR_nASSGIreq;
>  
>  		/* Dist stays enabled? nASSGIreq is RO */
> diff --git a/drivers/irqchip/irq-gic-v4.c b/drivers/irqchip/irq-gic-v4.c
> index 5d1dc9915272..864fa9bbda4c 100644
> --- a/drivers/irqchip/irq-gic-v4.c
> +++ b/drivers/irqchip/irq-gic-v4.c
> @@ -87,17 +87,37 @@ static struct irq_domain *gic_domain;
>  static const struct irq_domain_ops *vpe_domain_ops;
>  static const struct irq_domain_ops *sgi_domain_ops;
>  
> +#ifdef CONFIG_ARM64
> +#include <asm/cpufeature.h>
> +
> +bool gic_cpuif_has_vsgi(void)
> +{
> +	unsigned long fld, reg = read_sanitised_ftr_reg(SYS_ID_AA64PFR0_EL1);
> +
> +	fld = cpuid_feature_extract_unsigned_field(reg, ID_AA64PFR0_GIC_SHIFT);
> +
> +	return fld >= 0x3;
> +}
> +#else
> +bool gic_cpuif_has_vsgi(void) { }
> +#endif
> +
>  static bool has_v4_1(void)
>  {
>  	return !!sgi_domain_ops;
>  }
>  
> +static bool has_v4_1_sgi(void)
> +{
> +	return has_v4_1() && gic_cpuif_has_vsgi();
> +}
> +
>  static int its_alloc_vcpu_sgis(struct its_vpe *vpe, int idx)
>  {
>  	char *name;
>  	int sgi_base;
>  
> -	if (!has_v4_1())
> +	if (!has_v4_1_sgi())
>  		return 0;
>  
>  	name = kasprintf(GFP_KERNEL, "GICv4-sgi-%d", task_pid_nr(current));
> @@ -182,7 +202,7 @@ static void its_free_sgi_irqs(struct its_vm *vm)
>  {
>  	int i;
>  
> -	if (!has_v4_1())
> +	if (!has_v4_1_sgi())
>  		return;
>  
>  	for (i = 0; i < vm->nr_vpes; i++) {
> diff --git a/include/linux/irqchip/arm-gic-v4.h b/include/linux/irqchip/arm-gic-v4.h
> index 943c3411ca10..2c63375bbd43 100644
> --- a/include/linux/irqchip/arm-gic-v4.h
> +++ b/include/linux/irqchip/arm-gic-v4.h
> @@ -145,4 +145,6 @@ int its_init_v4(struct irq_domain *domain,
>  		const struct irq_domain_ops *vpe_ops,
>  		const struct irq_domain_ops *sgi_ops);
>  
> +bool gic_cpuif_has_vsgi(void);
> +
>  #endif
> 
> -- 
> Without deviation from the norm, progress is not possible.
