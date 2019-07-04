Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 89F595F3F4
	for <lists+kvm@lfdr.de>; Thu,  4 Jul 2019 09:39:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726791AbfGDHiY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 4 Jul 2019 03:38:24 -0400
Received: from foss.arm.com ([217.140.110.172]:35744 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725945AbfGDHiX (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 4 Jul 2019 03:38:23 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id E82C8344;
        Thu,  4 Jul 2019 00:38:22 -0700 (PDT)
Received: from [10.1.197.45] (e112298-lin.cambridge.arm.com [10.1.197.45])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 7DE013F703;
        Thu,  4 Jul 2019 00:38:21 -0700 (PDT)
Subject: Re: [PATCH 52/59] KVM: arm64: nv: vgic: Allow userland to set VGIC
 maintenance IRQ
To:     Marc Zyngier <marc.zyngier@arm.com>,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        kvm@vger.kernel.org
Cc:     Andre Przywara <andre.przywara@arm.com>,
        Christoffer Dall <christoffer.dall@arm.com>,
        Dave Martin <Dave.Martin@arm.com>,
        Jintack Lim <jintack@cs.columbia.edu>,
        James Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>
References: <20190621093843.220980-1-marc.zyngier@arm.com>
 <20190621093843.220980-53-marc.zyngier@arm.com>
From:   Julien Thierry <julien.thierry@arm.com>
Message-ID: <23223923-125c-4d9b-eee9-071a4cf3de2a@arm.com>
Date:   Thu, 4 Jul 2019 08:38:20 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <20190621093843.220980-53-marc.zyngier@arm.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 21/06/2019 10:38, Marc Zyngier wrote:
> From: Andre Przywara <andre.przywara@arm.com>
> 
> The VGIC maintenance IRQ signals various conditions about the LRs, when
> the GIC's virtualization extension is used.
> So far we didn't need it, but nested virtualization needs to know about
> this interrupt, so add a userland interface to setup the IRQ number.
> The architecture mandates that it must be a PPI, on top of that this code
> only exports a per-device option, so the PPI is the same on all VCPUs.
> 
> Signed-off-by: Andre Przywara <andre.przywara@arm.com>
> [added some bits of documentation]
> Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
> ---
>  .../virtual/kvm/devices/arm-vgic-v3.txt       |  9 ++++++++
>  arch/arm/include/uapi/asm/kvm.h               |  1 +
>  arch/arm64/include/uapi/asm/kvm.h             |  1 +
>  include/kvm/arm_vgic.h                        |  3 +++
>  virt/kvm/arm/vgic/vgic-kvm-device.c           | 22 +++++++++++++++++++
>  5 files changed, 36 insertions(+)
> 
> diff --git a/Documentation/virtual/kvm/devices/arm-vgic-v3.txt b/Documentation/virtual/kvm/devices/arm-vgic-v3.txt
> index ff290b43c8e5..c70e8f2e0c9c 100644
> --- a/Documentation/virtual/kvm/devices/arm-vgic-v3.txt
> +++ b/Documentation/virtual/kvm/devices/arm-vgic-v3.txt
> @@ -249,3 +249,12 @@ Groups:
>    Errors:
>      -EINVAL: vINTID is not multiple of 32 or
>       info field is not VGIC_LEVEL_INFO_LINE_LEVEL
> +
> +  KVM_DEV_ARM_VGIC_GRP_MAINT_IRQ
> +    The attr field of kvm_device_attr encodes the following values:
> +    bits:     | 31   ....    5 | 4  ....  0 |
> +    values:   |      RES0      |   vINTID   |
> +
> +    The vINTID specifies which interrupt is generated when the vGIC
> +    must generate a maintenance interrupt. This must be a PPI.
> +

Something seems off. The documentation suggests that the value of the
attribute will be between 0-15 (and other values will be masked down to
a value between 0 and 15). However, in the code the value should be
between 16 and 32 (PPI INTID) and other values are rejected.

Am I reading this wrong?

Cheers,

Julien

> diff --git a/arch/arm/include/uapi/asm/kvm.h b/arch/arm/include/uapi/asm/kvm.h
> index 4602464ebdfb..a6af45645a6d 100644
> --- a/arch/arm/include/uapi/asm/kvm.h
> +++ b/arch/arm/include/uapi/asm/kvm.h
> @@ -233,6 +233,7 @@ struct kvm_vcpu_events {
>  #define KVM_DEV_ARM_VGIC_GRP_CPU_SYSREGS 6
>  #define KVM_DEV_ARM_VGIC_GRP_LEVEL_INFO  7
>  #define KVM_DEV_ARM_VGIC_GRP_ITS_REGS	8
> +#define KVM_DEV_ARM_VGIC_GRP_MAINT_IRQ	9
>  #define KVM_DEV_ARM_VGIC_LINE_LEVEL_INFO_SHIFT	10
>  #define KVM_DEV_ARM_VGIC_LINE_LEVEL_INFO_MASK \
>  			(0x3fffffULL << KVM_DEV_ARM_VGIC_LINE_LEVEL_INFO_SHIFT)
> diff --git a/arch/arm64/include/uapi/asm/kvm.h b/arch/arm64/include/uapi/asm/kvm.h
> index 563e2a8bae93..8e1c6ffe1b59 100644
> --- a/arch/arm64/include/uapi/asm/kvm.h
> +++ b/arch/arm64/include/uapi/asm/kvm.h
> @@ -295,6 +295,7 @@ struct kvm_vcpu_events {
>  #define KVM_DEV_ARM_VGIC_GRP_CPU_SYSREGS 6
>  #define KVM_DEV_ARM_VGIC_GRP_LEVEL_INFO  7
>  #define KVM_DEV_ARM_VGIC_GRP_ITS_REGS 8
> +#define KVM_DEV_ARM_VGIC_GRP_MAINT_IRQ  9
>  #define KVM_DEV_ARM_VGIC_LINE_LEVEL_INFO_SHIFT	10
>  #define KVM_DEV_ARM_VGIC_LINE_LEVEL_INFO_MASK \
>  			(0x3fffffULL << KVM_DEV_ARM_VGIC_LINE_LEVEL_INFO_SHIFT)
> diff --git a/include/kvm/arm_vgic.h b/include/kvm/arm_vgic.h
> index 17d32c2797c0..95c6232663c3 100644
> --- a/include/kvm/arm_vgic.h
> +++ b/include/kvm/arm_vgic.h
> @@ -229,6 +229,9 @@ struct vgic_dist {
>  
>  	int			nr_spis;
>  
> +	/* The GIC maintenance IRQ for nested hypervisors. */
> +	u32			maint_irq;
> +
>  	/* base addresses in guest physical address space: */
>  	gpa_t			vgic_dist_base;		/* distributor */
>  	union {
> diff --git a/virt/kvm/arm/vgic/vgic-kvm-device.c b/virt/kvm/arm/vgic/vgic-kvm-device.c
> index 44419679f91a..dfb1d7cc66b3 100644
> --- a/virt/kvm/arm/vgic/vgic-kvm-device.c
> +++ b/virt/kvm/arm/vgic/vgic-kvm-device.c
> @@ -241,6 +241,12 @@ static int vgic_get_common_attr(struct kvm_device *dev,
>  			     VGIC_NR_PRIVATE_IRQS, uaddr);
>  		break;
>  	}
> +	case KVM_DEV_ARM_VGIC_GRP_MAINT_IRQ: {
> +		u32 __user *uaddr = (u32 __user *)(long)attr->addr;
> +
> +		r = put_user(dev->kvm->arch.vgic.maint_irq, uaddr);
> +		break;
> +	}
>  	}
>  
>  	return r;
> @@ -627,6 +633,21 @@ static int vgic_v3_set_attr(struct kvm_device *dev,
>  		reg = tmp32;
>  		return vgic_v3_attr_regs_access(dev, attr, &reg, true);
>  	}
> +	case KVM_DEV_ARM_VGIC_GRP_MAINT_IRQ: {
> +		u32 __user *uaddr = (u32 __user *)(long)attr->addr;
> +		u32 val;
> +
> +		if (get_user(val, uaddr))
> +			return -EFAULT;
> +
> +		/* Must be a PPI. */
> +		if ((val >= VGIC_NR_PRIVATE_IRQS) || (val < VGIC_NR_SGIS))
> +			return -EINVAL;
> +
> +		dev->kvm->arch.vgic.maint_irq = val;
> +
> +		return 0;
> +	}
>  	case KVM_DEV_ARM_VGIC_GRP_CTRL: {
>  		int ret;
>  
> @@ -712,6 +733,7 @@ static int vgic_v3_has_attr(struct kvm_device *dev,
>  	case KVM_DEV_ARM_VGIC_GRP_CPU_SYSREGS:
>  		return vgic_v3_has_attr_regs(dev, attr);
>  	case KVM_DEV_ARM_VGIC_GRP_NR_IRQS:
> +	case KVM_DEV_ARM_VGIC_GRP_MAINT_IRQ:
>  		return 0;
>  	case KVM_DEV_ARM_VGIC_GRP_LEVEL_INFO: {
>  		if (((attr->attr & KVM_DEV_ARM_VGIC_LINE_LEVEL_INFO_MASK) >>
> 

-- 
Julien Thierry
