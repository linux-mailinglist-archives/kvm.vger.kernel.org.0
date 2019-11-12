Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 774DCF971C
	for <lists+kvm@lfdr.de>; Tue, 12 Nov 2019 18:30:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726952AbfKLRav (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 12 Nov 2019 12:30:51 -0500
Received: from foss.arm.com ([217.140.110.172]:38120 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726718AbfKLRau (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 12 Nov 2019 12:30:50 -0500
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id DDF2F30E;
        Tue, 12 Nov 2019 09:30:49 -0800 (PST)
Received: from [10.1.196.63] (e123195-lin.cambridge.arm.com [10.1.196.63])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id E910E3F534;
        Tue, 12 Nov 2019 09:30:48 -0800 (PST)
Subject: Re: [kvm-unit-tests PATCH 14/17] arm: gic: Prepare for receiving GIC
 group 0 interrupts via FIQs
To:     Andre Przywara <andre.przywara@arm.com>,
        Andrew Jones <drjones@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org,
        kvm@vger.kernel.org, Marc Zyngier <maz@kernel.org>
References: <20191108144240.204202-1-andre.przywara@arm.com>
 <20191108144240.204202-15-andre.przywara@arm.com>
From:   Alexandru Elisei <alexandru.elisei@arm.com>
Message-ID: <228de8c4-fd3a-73c6-9d76-5e4d9c0f25c5@arm.com>
Date:   Tue, 12 Nov 2019 17:30:47 +0000
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20191108144240.204202-15-andre.przywara@arm.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi,

On 11/8/19 2:42 PM, Andre Przywara wrote:
> To differentiate between the two interrupt groups, we will configure
> group 0 to be delivered as FIQs, while group 1 interrupts still use the
> IRQ "pin".
> For this we need to teach kvm-unit-tests to deal with FIQs, also need to
> tell the VGIC to deliver FIQs. This requires some bits here and there to
> be set, which are annoyingly different between GICv2 and GICv3.
>
> Add the required code in the GIC library to easily enable FIQ delivery
> later on, in gic.c.
>
> Signed-off-by: Andre Przywara <andre.przywara@arm.com>
> ---
>  lib/arm/asm/arch_gicv3.h   |  7 +++++++
>  lib/arm/asm/gic-v2.h       |  7 ++++++-
>  lib/arm/asm/processor.h    | 10 ++++++++++
>  lib/arm/gic-v2.c           | 34 +++++++++++++++++++++++++++++++++-
>  lib/arm64/asm/arch_gicv3.h |  9 +++++++++
>  lib/arm64/asm/processor.h  | 10 ++++++++++
>  lib/arm64/processor.c      |  2 ++
>  7 files changed, 77 insertions(+), 2 deletions(-)
>
> diff --git a/lib/arm/asm/arch_gicv3.h b/lib/arm/asm/arch_gicv3.h
> index 163008d..33fd75c 100644
> --- a/lib/arm/asm/arch_gicv3.h
> +++ b/lib/arm/asm/arch_gicv3.h
> @@ -20,6 +20,7 @@
>  #define ICC_EOIR0			__ACCESS_CP15(c12, 0,  c8, 1)
>  #define ICC_IAR1			__ACCESS_CP15(c12, 0, c12, 0)
>  #define ICC_EOIR1			__ACCESS_CP15(c12, 0, c12, 1)
> +#define ICC_IGRPEN0			__ACCESS_CP15(c12, 0, c12, 6)
>  #define ICC_IGRPEN1			__ACCESS_CP15(c12, 0, c12, 7)
>  
>  static inline void gicv3_write_pmr(u32 val)
> @@ -54,6 +55,12 @@ static inline void gicv3_write_eoir(u32 irq, int group)
>  	isb();
>  }
>  
> +static inline void gicv3_write_grpen0(u32 val)
> +{
> +	write_sysreg(val, ICC_IGRPEN0);
> +	isb();
> +}
> +
>  static inline void gicv3_write_grpen1(u32 val)
>  {
>  	write_sysreg(val, ICC_IGRPEN1);
> diff --git a/lib/arm/asm/gic-v2.h b/lib/arm/asm/gic-v2.h
> index b57ee35..ed083ea 100644
> --- a/lib/arm/asm/gic-v2.h
> +++ b/lib/arm/asm/gic-v2.h
> @@ -14,7 +14,10 @@
>  
>  #define GICD_ENABLE			0x1
>  
> -#define GICC_ENABLE			0x1
> +#define GICC_GRP0_ENABLE		0x1
> +#define GICC_GRP1_ENABLE		0x2
> +#define GICC_ACKCTL			0x4
> +#define GICC_FIQEN			0x8
>  #define GICC_IAR_INT_ID_MASK		0x3ff
>  
>  #ifndef __ASSEMBLY__
> @@ -32,6 +35,8 @@ extern struct gicv2_data gicv2_data;
>  
>  extern int gicv2_init(void);
>  extern void gicv2_enable_defaults(void);
> +extern void gicv2_enable_group1(bool enable);
> +extern void gicv2_enable_fiq(bool enable);
>  extern u32 gicv2_read_iar(int group);
>  extern u32 gicv2_iar_irqnr(u32 iar);
>  extern void gicv2_write_eoir(u32 irqstat, int group);
> diff --git a/lib/arm/asm/processor.h b/lib/arm/asm/processor.h
> index a8c4628..6b5dd1e 100644
> --- a/lib/arm/asm/processor.h
> +++ b/lib/arm/asm/processor.h
> @@ -35,6 +35,16 @@ static inline unsigned long current_cpsr(void)
>  
>  #define current_mode() (current_cpsr() & MODE_MASK)
>  
> +static inline void local_fiq_enable(void)
> +{
> +	asm volatile("cpsie f" : : : "memory", "cc");
> +}
> +
> +static inline void local_fiq_disable(void)
> +{
> +	asm volatile("cpsid f" : : : "memory", "cc");
> +}
> +
>  static inline void local_irq_enable(void)
>  {
>  	asm volatile("cpsie i" : : : "memory", "cc");
> diff --git a/lib/arm/gic-v2.c b/lib/arm/gic-v2.c
> index d2af01e..360aaa3 100644
> --- a/lib/arm/gic-v2.c
> +++ b/lib/arm/gic-v2.c
> @@ -23,7 +23,39 @@ void gicv2_enable_defaults(void)
>  	writel(GICD_ENABLE, dist + GICD_CTLR);
>  
>  	writel(GICC_INT_PRI_THRESHOLD, cpu_base + GICC_PMR);
> -	writel(GICC_ENABLE, cpu_base + GICC_CTLR);
> +	writel(GICC_GRP0_ENABLE, cpu_base + GICC_CTLR);
> +}
> +
> +void gicv2_enable_fiq(bool enable)

This is unexpected - the function to enable the delivery of FIQs is called
gicv2_enable_fiq, but the function to enable the delivery of IRQs is called
gicv2_enable_group1. How about we rename this one to gicv2_enable_group0 and we
state that by convention group 0 interrupts will be delivered as FIQs, so it
matches the behaviour of GICv3?

It's also a bit strange that a function with 'enable' in the name actually has the
opposite behaviour based on a parameter. How about we split it into two functions
without a parameter, one called gicv2_enable_group0 and the other
gicv2_disable_group0? Same for gicv2_enable_group1 -> gicv2_enable_group1 +
gicv2_disable_group1.

Also, have you considered adding similar functions for gicv3
(gicv3_{enable,disable}_group1 and gicv3_{enable,disable}_group0) so we're
consistent across both gic versions?

Thanks,
Alex
> +{
> +	void *cpu_base = gicv2_cpu_base();
> +	u32 reg = readl(cpu_base + GICC_CTLR);
> +
> +	if (enable) {
> +		reg |= GICC_GRP0_ENABLE;
> +		reg |= GICC_FIQEN;
> +	} else {
> +		reg &= ~GICC_GRP0_ENABLE;
> +		reg &= ~GICC_FIQEN;
> +	}
> +
> +	writel(reg, cpu_base + GICC_CTLR);
> +}
> +
> +void gicv2_enable_group1(bool enable)
> +{
> +	void *cpu_base = gicv2_cpu_base();
> +	u32 reg = readl(cpu_base + GICC_CTLR);
> +
> +	if (enable) {
> +		reg |= GICC_GRP1_ENABLE;
> +		reg |= GICC_ACKCTL;
> +	} else {
> +		reg &= ~GICC_GRP1_ENABLE;
> +		reg &= ~GICC_ACKCTL;
> +	}
> +
> +	writel(reg, cpu_base + GICC_CTLR);
>  }
>  
>  u32 gicv2_read_iar(int group)
> diff --git a/lib/arm64/asm/arch_gicv3.h b/lib/arm64/asm/arch_gicv3.h
> index 972b97e..6938bc5 100644
> --- a/lib/arm64/asm/arch_gicv3.h
> +++ b/lib/arm64/asm/arch_gicv3.h
> @@ -14,8 +14,11 @@
>  #define ICC_IAR0_EL1			sys_reg(3, 0, 12, 8, 0)
>  #define ICC_EOIR0_EL1			sys_reg(3, 0, 12, 8, 1)
>  #define ICC_SGI1R_EL1			sys_reg(3, 0, 12, 11, 5)
> +#define ICC_IAR0_EL1			sys_reg(3, 0, 12, 8, 0)
>  #define ICC_IAR1_EL1			sys_reg(3, 0, 12, 12, 0)
> +#define ICC_EOIR0_EL1			sys_reg(3, 0, 12, 8, 1)
>  #define ICC_EOIR1_EL1			sys_reg(3, 0, 12, 12, 1)
> +#define ICC_GRPEN0_EL1			sys_reg(3, 0, 12, 12, 6)
>  #define ICC_GRPEN1_EL1			sys_reg(3, 0, 12, 12, 7)
>  
>  #ifndef __ASSEMBLY__
> @@ -64,6 +67,12 @@ static inline void gicv3_write_eoir(u32 irq, int group)
>  	isb();
>  }
>  
> +static inline void gicv3_write_grpen0(u32 val)
> +{
> +	asm volatile("msr_s " xstr(ICC_GRPEN0_EL1) ", %0" : : "r" ((u64)val));
> +	isb();
> +}
> +
>  static inline void gicv3_write_grpen1(u32 val)
>  {
>  	asm volatile("msr_s " xstr(ICC_GRPEN1_EL1) ", %0" : : "r" ((u64)val));
> diff --git a/lib/arm64/asm/processor.h b/lib/arm64/asm/processor.h
> index 1d9223f..69086e9 100644
> --- a/lib/arm64/asm/processor.h
> +++ b/lib/arm64/asm/processor.h
> @@ -68,6 +68,16 @@ static inline unsigned long current_level(void)
>  	return el & 0xc;
>  }
>  
> +static inline void local_fiq_enable(void)
> +{
> +	asm volatile("msr daifclr, #1" : : : "memory");
> +}
> +
> +static inline void local_fiq_disable(void)
> +{
> +	asm volatile("msr daifset, #1" : : : "memory");
> +}
> +
>  static inline void local_irq_enable(void)
>  {
>  	asm volatile("msr daifclr, #2" : : : "memory");
> diff --git a/lib/arm64/processor.c b/lib/arm64/processor.c
> index 2a024e3..8d7b921 100644
> --- a/lib/arm64/processor.c
> +++ b/lib/arm64/processor.c
> @@ -190,8 +190,10 @@ void vector_handlers_default_init(vector_fn *handlers)
>  {
>  	handlers[EL1H_SYNC]	= default_vector_sync_handler;
>  	handlers[EL1H_IRQ]	= default_vector_irq_handler;
> +	handlers[EL1H_FIQ]	= default_vector_irq_handler;
>  	handlers[EL0_SYNC_64]	= default_vector_sync_handler;
>  	handlers[EL0_IRQ_64]	= default_vector_irq_handler;
> +	handlers[EL0_FIQ_64]	= default_vector_irq_handler;
>  }
>  
>  /* Needed to compile with -Wmissing-prototypes */
