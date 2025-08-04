Return-Path: <kvm+bounces-53924-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 3516DB1A535
	for <lists+kvm@lfdr.de>; Mon,  4 Aug 2025 16:48:10 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id E042B3B9AF0
	for <lists+kvm@lfdr.de>; Mon,  4 Aug 2025 14:48:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C3F7F1F4612;
	Mon,  4 Aug 2025 14:48:01 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C52961F4615
	for <kvm@vger.kernel.org>; Mon,  4 Aug 2025 14:47:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754318881; cv=none; b=B9qadGZzdJwDZH8KcuDYWkcNoNK2u4gJZUy/Jtu6fLt3cWP72E/9TwlA62Y7IvilM+YGCQhLvGbBz7qaddR73EZk/jYDYppkKz1QkoV0S8xk4E7Mm7gNBAOHLrIEfLaiJ5emPZ2LZFk1+P+dyFatZw7YCbvN3v5YuwcpsQNBR8o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754318881; c=relaxed/simple;
	bh=tRnh4pGZAMs0ZMK796mJ6/fWGo5O49/gAs0OJw7S6D8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=uh2AWjulKxk2iUVgqkZsc9+4CzyTVuORja296Y+YOBQi84JNOuElw25QGTZxhB6FP2Q+Se0+XvuR6T82Eki3GfkQp00ccINa6NbPE+FltuZekFeSKZsiUu3OEi/VCpVF3edIspqkXqdx8vwxAQIyA2wnHsl44gD9vkmSY9xfNq4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 08541150C;
	Mon,  4 Aug 2025 07:47:51 -0700 (PDT)
Received: from raptor (usa-sjc-mx-foss1.foss.arm.com [172.31.20.19])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id CE7763F738;
	Mon,  4 Aug 2025 07:47:57 -0700 (PDT)
Date: Mon, 4 Aug 2025 15:47:55 +0100
From: Alexandru Elisei <alexandru.elisei@arm.com>
To: Andre Przywara <andre.przywara@arm.com>
Cc: Will Deacon <will@kernel.org>,
	Julien Thierry <julien.thierry.kdev@gmail.com>,
	Marc Zyngier <maz@kernel.org>, kvm@vger.kernel.org,
	kvmarm@lists.linux.dev
Subject: Re: [PATCH kvmtool v3 6/6] arm64: Generate HYP timer interrupt
 specifiers
Message-ID: <aJDIG8cJQjzbwj3w@raptor>
References: <20250729095745.3148294-1-andre.przywara@arm.com>
 <20250729095745.3148294-7-andre.przywara@arm.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250729095745.3148294-7-andre.przywara@arm.com>

Hi Andre,

On Tue, Jul 29, 2025 at 10:57:45AM +0100, Andre Przywara wrote:
> From: Marc Zyngier <maz@kernel.org>
> 
> FEAT_VHE introduced a non-secure EL2 virtual timer, along with its
> interrupt line. Consequently the arch timer DT binding introduced a fifth
> interrupt to communicate this interrupt number.
> 
> Refactor the interrupts property generation code to deal with a variable
> number of interrupts, and forward five interrupts instead of four in case
> nested virt is enabled.
> 
> Signed-off-by: Marc Zyngier <maz@kernel.org>
> Signed-off-by: Andre Przywara <andre.przywara@arm.com>
> ---
>  arm64/arm-cpu.c           |  4 +---
>  arm64/include/kvm/timer.h |  2 +-
>  arm64/timer.c             | 29 ++++++++++++-----------------
>  3 files changed, 14 insertions(+), 21 deletions(-)
> 
> diff --git a/arm64/arm-cpu.c b/arm64/arm-cpu.c
> index 1e456f2c6..abdd6324f 100644
> --- a/arm64/arm-cpu.c
> +++ b/arm64/arm-cpu.c
> @@ -12,11 +12,9 @@
>  
>  static void generate_fdt_nodes(void *fdt, struct kvm *kvm)
>  {
> -	int timer_interrupts[4] = {13, 14, 11, 10};
> -
>  	gic__generate_fdt_nodes(fdt, kvm->cfg.arch.irqchip,
>  				kvm->cfg.arch.nested_virt);
> -	timer__generate_fdt_nodes(fdt, kvm, timer_interrupts);
> +	timer__generate_fdt_nodes(fdt, kvm);
>  	pmu__generate_fdt_nodes(fdt, kvm);
>  }
>  
> diff --git a/arm64/include/kvm/timer.h b/arm64/include/kvm/timer.h
> index 928e9ea7a..81e093e46 100644
> --- a/arm64/include/kvm/timer.h
> +++ b/arm64/include/kvm/timer.h
> @@ -1,6 +1,6 @@
>  #ifndef ARM_COMMON__TIMER_H
>  #define ARM_COMMON__TIMER_H
>  
> -void timer__generate_fdt_nodes(void *fdt, struct kvm *kvm, int *irqs);
> +void timer__generate_fdt_nodes(void *fdt, struct kvm *kvm);
>  
>  #endif /* ARM_COMMON__TIMER_H */
> diff --git a/arm64/timer.c b/arm64/timer.c
> index 861f2d994..2ac6144f9 100644
> --- a/arm64/timer.c
> +++ b/arm64/timer.c
> @@ -5,31 +5,26 @@
>  #include "kvm/timer.h"
>  #include "kvm/util.h"
>  
> -void timer__generate_fdt_nodes(void *fdt, struct kvm *kvm, int *irqs)
> +void timer__generate_fdt_nodes(void *fdt, struct kvm *kvm)
>  {
>  	const char compatible[] = "arm,armv8-timer\0arm,armv7-timer";
>  	u32 cpu_mask = gic__get_fdt_irq_cpumask(kvm);
> -	u32 irq_prop[] = {
> -		cpu_to_fdt32(GIC_FDT_IRQ_TYPE_PPI),
> -		cpu_to_fdt32(irqs[0]),
> -		cpu_to_fdt32(cpu_mask | IRQ_TYPE_LEVEL_LOW),
> +	int irqs[5] = {13, 14, 11, 10, 12};
> +	int nr = ARRAY_SIZE(irqs);
> +	u32 irq_prop[nr * 3];
>  
> -		cpu_to_fdt32(GIC_FDT_IRQ_TYPE_PPI),
> -		cpu_to_fdt32(irqs[1]),
> -		cpu_to_fdt32(cpu_mask | IRQ_TYPE_LEVEL_LOW),
> +	if (!kvm->cfg.arch.nested_virt)
> +		nr--;

I'm confused.

FEAT_VHE introduced the EL2 virtual timer, and my interpretation of the Arm ARM
is that the EL2 virtual timer is present if an only if FEAT_VHE:

"In an implementation of the Generic Timer that includes EL3, if EL3 can use
AArch64, the following timers are implemented:
[..]
* When FEAT_VHE is implemented, a Non-secure EL2 virtual timer."

Is my interpretation correct?

KVM doesn't allow FEAT_VHE and FEAT_E2H0 to coexist (in
nested.c::limit_nv_id_reg()), to force E2H to be RES0. Assuming my interpretion
is correct, shouldn't the check be:

	if (!kvm->cfg.arch.nested_virt || kvm->cfg.arch.e2h0)
		nr--;

Thanks,
Alex

>  
> -		cpu_to_fdt32(GIC_FDT_IRQ_TYPE_PPI),
> -		cpu_to_fdt32(irqs[2]),
> -		cpu_to_fdt32(cpu_mask | IRQ_TYPE_LEVEL_LOW),
> -
> -		cpu_to_fdt32(GIC_FDT_IRQ_TYPE_PPI),
> -		cpu_to_fdt32(irqs[3]),
> -		cpu_to_fdt32(cpu_mask | IRQ_TYPE_LEVEL_LOW),
> -	};
> +	for (int i = 0; i < nr; i++) {
> +		irq_prop[i * 3 + 0] = cpu_to_fdt32(GIC_FDT_IRQ_TYPE_PPI);
> +		irq_prop[i * 3 + 1] = cpu_to_fdt32(irqs[i]);
> +		irq_prop[i * 3 + 2] = cpu_to_fdt32(cpu_mask | IRQ_TYPE_LEVEL_LOW);
> +	}
>  
>  	_FDT(fdt_begin_node(fdt, "timer"));
>  	_FDT(fdt_property(fdt, "compatible", compatible, sizeof(compatible)));
> -	_FDT(fdt_property(fdt, "interrupts", irq_prop, sizeof(irq_prop)));
> +	_FDT(fdt_property(fdt, "interrupts", irq_prop, nr * 3 * sizeof(irq_prop[0])));
>  	_FDT(fdt_property(fdt, "always-on", NULL, 0));
>  	if (kvm->cfg.arch.force_cntfrq > 0)
>  		_FDT(fdt_property_cell(fdt, "clock-frequency", kvm->cfg.arch.force_cntfrq));
> -- 
> 2.25.1
> 

