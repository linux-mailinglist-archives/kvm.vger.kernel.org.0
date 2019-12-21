Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1AAA812892D
	for <lists+kvm@lfdr.de>; Sat, 21 Dec 2019 14:19:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726826AbfLUNTk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 21 Dec 2019 08:19:40 -0500
Received: from inca-roads.misterjones.org ([213.251.177.50]:48178 "EHLO
        inca-roads.misterjones.org" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726182AbfLUNTk (ORCPT
        <rfc822;kvm@vger.kernel.org>); Sat, 21 Dec 2019 08:19:40 -0500
Received: from 78.163-31-62.static.virginmediabusiness.co.uk ([62.31.163.78] helo=why)
        by cheepnis.misterjones.org with esmtpsa (TLSv1.2:AES256-GCM-SHA384:256)
        (Exim 4.80)
        (envelope-from <maz@kernel.org>)
        id 1iiefS-00035I-DI; Sat, 21 Dec 2019 14:19:38 +0100
Date:   Sat, 21 Dec 2019 13:19:36 +0000
From:   Marc Zyngier <maz@kernel.org>
To:     Andrew Murray <andrew.murray@arm.com>
Cc:     will@kernel.org, Catalin Marinas <catalin.marinas@arm.com>,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Sudeep Holla <sudeep.holla@arm.com>,
        kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v2 03/18] arm64: KVM: define SPE data structure for each
 vcpu
Message-ID: <20191221131936.21fa2dfa@why>
In-Reply-To: <20191220143025.33853-4-andrew.murray@arm.com>
References: <20191220143025.33853-1-andrew.murray@arm.com>
        <20191220143025.33853-4-andrew.murray@arm.com>
Organization: Approximate
X-Mailer: Claws Mail 3.17.4 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SA-Exim-Connect-IP: 62.31.163.78
X-SA-Exim-Rcpt-To: andrew.murray@arm.com, will@kernel.org, catalin.marinas@arm.com, kvm@vger.kernel.org, linux-kernel@vger.kernel.org, sudeep.holla@arm.com, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on cheepnis.misterjones.org); SAEximRunCond expanded to false
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, 20 Dec 2019 14:30:10 +0000
Andrew Murray <andrew.murray@arm.com> wrote:

> From: Sudeep Holla <sudeep.holla@arm.com>
> 
> In order to support virtual SPE for guest, so define some basic structs.
> This features depends on host having hardware with SPE support.
> 
> Since we can support this only on ARM64, add a separate config symbol
> for the same.
> 
> Signed-off-by: Sudeep Holla <sudeep.holla@arm.com>
> [ Add irq_level, rename irq to irq_num for kvm_spe ]
> Signed-off-by: Andrew Murray <andrew.murray@arm.com>
> ---
>  arch/arm64/include/asm/kvm_host.h |  2 ++
>  arch/arm64/kvm/Kconfig            |  7 +++++++
>  include/kvm/arm_spe.h             | 19 +++++++++++++++++++
>  3 files changed, 28 insertions(+)
>  create mode 100644 include/kvm/arm_spe.h
> 
> diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
> index c61260cf63c5..f5dcff912645 100644
> --- a/arch/arm64/include/asm/kvm_host.h
> +++ b/arch/arm64/include/asm/kvm_host.h
> @@ -35,6 +35,7 @@
>  #include <kvm/arm_vgic.h>
>  #include <kvm/arm_arch_timer.h>
>  #include <kvm/arm_pmu.h>
> +#include <kvm/arm_spe.h>
>  
>  #define KVM_MAX_VCPUS VGIC_V3_MAX_CPUS
>  
> @@ -302,6 +303,7 @@ struct kvm_vcpu_arch {
>  	struct vgic_cpu vgic_cpu;
>  	struct arch_timer_cpu timer_cpu;
>  	struct kvm_pmu pmu;
> +	struct kvm_spe spe;
>  
>  	/*
>  	 * Anything that is not used directly from assembly code goes
> diff --git a/arch/arm64/kvm/Kconfig b/arch/arm64/kvm/Kconfig
> index a475c68cbfec..af5be2c57dcb 100644
> --- a/arch/arm64/kvm/Kconfig
> +++ b/arch/arm64/kvm/Kconfig
> @@ -35,6 +35,7 @@ config KVM
>  	select HAVE_KVM_EVENTFD
>  	select HAVE_KVM_IRQFD
>  	select KVM_ARM_PMU if HW_PERF_EVENTS
> +	select KVM_ARM_SPE if (HW_PERF_EVENTS && ARM_SPE_PMU)
>  	select HAVE_KVM_MSI
>  	select HAVE_KVM_IRQCHIP
>  	select HAVE_KVM_IRQ_ROUTING
> @@ -61,6 +62,12 @@ config KVM_ARM_PMU
>  	  Adds support for a virtual Performance Monitoring Unit (PMU) in
>  	  virtual machines.
>  
> +config KVM_ARM_SPE
> +	bool
> +	---help---
> +	  Adds support for a virtual Statistical Profiling Extension(SPE) in
> +	  virtual machines.
> +
>  config KVM_INDIRECT_VECTORS
>         def_bool KVM && (HARDEN_BRANCH_PREDICTOR || HARDEN_EL2_VECTORS)
>  
> diff --git a/include/kvm/arm_spe.h b/include/kvm/arm_spe.h
> new file mode 100644
> index 000000000000..48d118fdb174
> --- /dev/null
> +++ b/include/kvm/arm_spe.h
> @@ -0,0 +1,19 @@
> +// SPDX-License-Identifier: GPL-2.0
> +/*
> + * Copyright (C) 2019 ARM Ltd.
> + */
> +
> +#ifndef __ASM_ARM_KVM_SPE_H
> +#define __ASM_ARM_KVM_SPE_H
> +
> +#include <uapi/linux/kvm.h>
> +#include <linux/kvm_host.h>

I don't believe these are required at this stage.

> +
> +struct kvm_spe {
> +	int irq_num;

'irq' was the right name *if* this represents a Linux irq. If this
instead represents a guest PPI, then it should be named 'intid'.

In either case, please document what this represents.

> +	bool ready; /* indicates that SPE KVM instance is ready for use */
> +	bool created; /* SPE KVM instance is created, may not be ready yet */
> +	bool irq_level;

What does this represent? The state of the interrupt on the host? The
guest? Something else? Also, please consider grouping related fields
together.

> +};

If you've added a config option that controls the selection of the SPE
feature, why doesn't this result in an empty structure when it isn't
selected?

> +
> +#endif /* __ASM_ARM_KVM_SPE_H */

Thanks,

	M.
-- 
Jazz is not dead. It just smells funny...
