Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 02D85387DE3
	for <lists+kvm@lfdr.de>; Tue, 18 May 2021 18:50:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346743AbhERQvx (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 18 May 2021 12:51:53 -0400
Received: from foss.arm.com ([217.140.110.172]:56918 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230355AbhERQvu (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 18 May 2021 12:51:50 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 0D5986D;
        Tue, 18 May 2021 09:50:32 -0700 (PDT)
Received: from [192.168.0.110] (unknown [172.31.20.19])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id A0A2F3F73B;
        Tue, 18 May 2021 09:50:30 -0700 (PDT)
Subject: Re: [PATCH v3 1/9] irqchip/gic: Split vGIC probing information from
 the GIC code
To:     Marc Zyngier <maz@kernel.org>,
        linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org,
        kvmarm@lists.cs.columbia.edu
Cc:     James Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Eric Auger <eric.auger@redhat.com>,
        Hector Martin <marcan@marcan.st>,
        Mark Rutland <mark.rutland@arm.com>, kernel-team@android.com
References: <20210510134824.1910399-1-maz@kernel.org>
 <20210510134824.1910399-2-maz@kernel.org>
From:   Alexandru Elisei <alexandru.elisei@arm.com>
Message-ID: <cca6328e-1710-a7ac-e89e-a7dabe16f81f@arm.com>
Date:   Tue, 18 May 2021 17:51:11 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <20210510134824.1910399-2-maz@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Marc,

On 5/10/21 2:48 PM, Marc Zyngier wrote:
> The vGIC advertising code is unsurprisingly very much tied to
> the GIC implementations. However, we are about to extend the
> support to lesser implementations.
>
> Let's dissociate the vgic registration from the GIC code and
> move it into KVM, where it makes a bit more sense. This also
> allows us to mark the gic_kvm_info structures as __initdata.
>
> Signed-off-by: Marc Zyngier <maz@kernel.org>
> ---
>  arch/arm64/kvm/vgic/vgic-init.c        | 18 +++++++++--
>  drivers/irqchip/irq-gic-common.c       | 13 --------
>  drivers/irqchip/irq-gic-common.h       |  2 --
>  drivers/irqchip/irq-gic-v3.c           |  6 ++--
>  drivers/irqchip/irq-gic.c              |  6 ++--
>  include/linux/irqchip/arm-gic-common.h | 25 +---------------
>  include/linux/irqchip/arm-vgic-info.h  | 41 ++++++++++++++++++++++++++
>  7 files changed, 63 insertions(+), 48 deletions(-)
>  create mode 100644 include/linux/irqchip/arm-vgic-info.h
>
> diff --git a/arch/arm64/kvm/vgic/vgic-init.c b/arch/arm64/kvm/vgic/vgic-init.c
> index 58cbda00e56d..2fdb65529594 100644
> --- a/arch/arm64/kvm/vgic/vgic-init.c
> +++ b/arch/arm64/kvm/vgic/vgic-init.c
> @@ -482,6 +482,16 @@ static irqreturn_t vgic_maintenance_handler(int irq, void *data)
>  	return IRQ_HANDLED;
>  }
>  
> +static struct gic_kvm_info *gic_kvm_info;
> +
> +void __init vgic_set_kvm_info(const struct gic_kvm_info *info)
> +{
> +	BUG_ON(gic_kvm_info != NULL);
> +	gic_kvm_info = kmalloc(sizeof(*info), GFP_KERNEL);
> +	if (gic_kvm_info)
> +		*gic_kvm_info = *info;
> +}
> +
>  /**
>   * kvm_vgic_init_cpu_hardware - initialize the GIC VE hardware
>   *
> @@ -509,10 +519,8 @@ void kvm_vgic_init_cpu_hardware(void)
>   */
>  int kvm_vgic_hyp_init(void)
>  {
> -	const struct gic_kvm_info *gic_kvm_info;
>  	int ret;
>  
> -	gic_kvm_info = gic_get_kvm_info();
>  	if (!gic_kvm_info)
>  		return -ENODEV;
>  
> @@ -536,10 +544,14 @@ int kvm_vgic_hyp_init(void)
>  		ret = -ENODEV;
>  	}
>  
> +	kvm_vgic_global_state.maint_irq = gic_kvm_info->maint_irq;
> +
> +	kfree(gic_kvm_info);
> +	gic_kvm_info = NULL;

I double checked and gic_kvm_info is not used after this point (vgic_{v2,v3}_probe
make copies of the various fields). And after returning an error (below) this
function cannot be called again.

> +
>  	if (ret)
>  		return ret;
>  
> -	kvm_vgic_global_state.maint_irq = gic_kvm_info->maint_irq;
>  	ret = request_percpu_irq(kvm_vgic_global_state.maint_irq,
>  				 vgic_maintenance_handler,
>  				 "vgic", kvm_get_running_vcpus());
> diff --git a/drivers/irqchip/irq-gic-common.c b/drivers/irqchip/irq-gic-common.c
> index f47b41dfd023..a610821c8ff2 100644
> --- a/drivers/irqchip/irq-gic-common.c
> +++ b/drivers/irqchip/irq-gic-common.c
> @@ -12,19 +12,6 @@
>  
>  static DEFINE_RAW_SPINLOCK(irq_controller_lock);
>  
> -static const struct gic_kvm_info *gic_kvm_info;
> -
> -const struct gic_kvm_info *gic_get_kvm_info(void)
> -{
> -	return gic_kvm_info;
> -}
> -
> -void gic_set_kvm_info(const struct gic_kvm_info *info)
> -{
> -	BUG_ON(gic_kvm_info != NULL);
> -	gic_kvm_info = info;
> -}
> -
>  void gic_enable_of_quirks(const struct device_node *np,
>  			  const struct gic_quirk *quirks, void *data)
>  {
> diff --git a/drivers/irqchip/irq-gic-common.h b/drivers/irqchip/irq-gic-common.h
> index ccba8b0fe0f5..27e3d4ed4f32 100644
> --- a/drivers/irqchip/irq-gic-common.h
> +++ b/drivers/irqchip/irq-gic-common.h
> @@ -28,6 +28,4 @@ void gic_enable_quirks(u32 iidr, const struct gic_quirk *quirks,
>  void gic_enable_of_quirks(const struct device_node *np,
>  			  const struct gic_quirk *quirks, void *data);
>  
> -void gic_set_kvm_info(const struct gic_kvm_info *info);
> -
>  #endif /* _IRQ_GIC_COMMON_H */
> diff --git a/drivers/irqchip/irq-gic-v3.c b/drivers/irqchip/irq-gic-v3.c
> index 37a23aa6de37..453fc425eede 100644
> --- a/drivers/irqchip/irq-gic-v3.c
> +++ b/drivers/irqchip/irq-gic-v3.c
> @@ -103,7 +103,7 @@ EXPORT_SYMBOL(gic_nonsecure_priorities);
>  /* ppi_nmi_refs[n] == number of cpus having ppi[n + 16] set as NMI */
>  static refcount_t *ppi_nmi_refs;
>  
> -static struct gic_kvm_info gic_v3_kvm_info;
> +static struct gic_kvm_info gic_v3_kvm_info __initdata;
>  static DEFINE_PER_CPU(bool, has_rss);
>  
>  #define MPIDR_RS(mpidr)			(((mpidr) & 0xF0UL) >> 4)
> @@ -1852,7 +1852,7 @@ static void __init gic_of_setup_kvm_info(struct device_node *node)
>  
>  	gic_v3_kvm_info.has_v4 = gic_data.rdists.has_vlpis;
>  	gic_v3_kvm_info.has_v4_1 = gic_data.rdists.has_rvpeid;
> -	gic_set_kvm_info(&gic_v3_kvm_info);
> +	vgic_set_kvm_info(&gic_v3_kvm_info);
>  }
>  
>  static int __init gic_of_init(struct device_node *node, struct device_node *parent)
> @@ -2168,7 +2168,7 @@ static void __init gic_acpi_setup_kvm_info(void)
>  
>  	gic_v3_kvm_info.has_v4 = gic_data.rdists.has_vlpis;
>  	gic_v3_kvm_info.has_v4_1 = gic_data.rdists.has_rvpeid;
> -	gic_set_kvm_info(&gic_v3_kvm_info);
> +	vgic_set_kvm_info(&gic_v3_kvm_info);
>  }
>  
>  static int __init
> diff --git a/drivers/irqchip/irq-gic.c b/drivers/irqchip/irq-gic.c
> index b1d9c22caf2e..2de9ec8ece0c 100644
> --- a/drivers/irqchip/irq-gic.c
> +++ b/drivers/irqchip/irq-gic.c
> @@ -119,7 +119,7 @@ static DEFINE_STATIC_KEY_TRUE(supports_deactivate_key);
>  
>  static struct gic_chip_data gic_data[CONFIG_ARM_GIC_MAX_NR] __read_mostly;
>  
> -static struct gic_kvm_info gic_v2_kvm_info;
> +static struct gic_kvm_info gic_v2_kvm_info __initdata;
>  
>  static DEFINE_PER_CPU(u32, sgi_intid);
>  
> @@ -1451,7 +1451,7 @@ static void __init gic_of_setup_kvm_info(struct device_node *node)
>  		return;
>  
>  	if (static_branch_likely(&supports_deactivate_key))
> -		gic_set_kvm_info(&gic_v2_kvm_info);
> +		vgic_set_kvm_info(&gic_v2_kvm_info);
>  }
>  
>  int __init
> @@ -1618,7 +1618,7 @@ static void __init gic_acpi_setup_kvm_info(void)
>  
>  	gic_v2_kvm_info.maint_irq = irq;
>  
> -	gic_set_kvm_info(&gic_v2_kvm_info);
> +	vgic_set_kvm_info(&gic_v2_kvm_info);
>  }
>  
>  static int __init gic_v2_acpi_init(union acpi_subtable_headers *header,
> diff --git a/include/linux/irqchip/arm-gic-common.h b/include/linux/irqchip/arm-gic-common.h
> index fa8c0455c352..1177f3a1aed5 100644
> --- a/include/linux/irqchip/arm-gic-common.h
> +++ b/include/linux/irqchip/arm-gic-common.h
> @@ -7,8 +7,7 @@
>  #ifndef __LINUX_IRQCHIP_ARM_GIC_COMMON_H
>  #define __LINUX_IRQCHIP_ARM_GIC_COMMON_H
>  
> -#include <linux/types.h>
> -#include <linux/ioport.h>
> +#include <linux/irqchip/arm-vgic-info.h>
>  
>  #define GICD_INT_DEF_PRI		0xa0
>  #define GICD_INT_DEF_PRI_X4		((GICD_INT_DEF_PRI << 24) |\
> @@ -16,28 +15,6 @@
>  					(GICD_INT_DEF_PRI << 8) |\
>  					GICD_INT_DEF_PRI)
>  
> -enum gic_type {
> -	GIC_V2,
> -	GIC_V3,
> -};
> -
> -struct gic_kvm_info {
> -	/* GIC type */
> -	enum gic_type	type;
> -	/* Virtual CPU interface */
> -	struct resource vcpu;
> -	/* Interrupt number */
> -	unsigned int	maint_irq;
> -	/* Virtual control interface */
> -	struct resource vctrl;
> -	/* vlpi support */
> -	bool		has_v4;
> -	/* rvpeid support */
> -	bool		has_v4_1;
> -};
> -
> -const struct gic_kvm_info *gic_get_kvm_info(void);
> -
>  struct irq_domain;
>  struct fwnode_handle;
>  int gicv2m_init(struct fwnode_handle *parent_handle,
> diff --git a/include/linux/irqchip/arm-vgic-info.h b/include/linux/irqchip/arm-vgic-info.h
> new file mode 100644
> index 000000000000..0319636be928
> --- /dev/null
> +++ b/include/linux/irqchip/arm-vgic-info.h
> @@ -0,0 +1,41 @@
> +/* SPDX-License-Identifier: GPL-2.0-only */
> +/*
> + * include/linux/irqchip/arm-vgic-info.h
> + *
> + * Copyright (C) 2016 ARM Limited, All Rights Reserved.
> + */
> +#ifndef __ARM_VGIC_INFO_H
> +#define __ARM_VGIC_INFO_H

Totally irrelevant nitpick, but the header guards from the other files in this
directory are like __LINUX_IRQCHIP_ARM_VGIC_INFO_H. Regardless, the patch looks
correct to me, the functions are called at the exact moment in the boot flow, only
where the VGIC info is saved is different:

Reviewed-by: Alexandru Elisei <alexandru.elisei@arm.com>

Thanks,

Alex

> +
> +#include <linux/types.h>
> +#include <linux/ioport.h>
> +
> +enum gic_type {
> +	/* Full GICv2 */
> +	GIC_V2,
> +	/* Full GICv3, optionally with v2 compat */
> +	GIC_V3,
> +};
> +
> +struct gic_kvm_info {
> +	/* GIC type */
> +	enum gic_type	type;
> +	/* Virtual CPU interface */
> +	struct resource vcpu;
> +	/* Interrupt number */
> +	unsigned int	maint_irq;
> +	/* Virtual control interface */
> +	struct resource vctrl;
> +	/* vlpi support */
> +	bool		has_v4;
> +	/* rvpeid support */
> +	bool		has_v4_1;
> +};
> +
> +#ifdef CONFIG_KVM
> +void vgic_set_kvm_info(const struct gic_kvm_info *info);
> +#else
> +static inline void vgic_set_kvm_info(const struct gic_kvm_info *info) {}
> +#endif
> +
> +#endif
