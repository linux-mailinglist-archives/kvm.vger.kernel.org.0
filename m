Return-Path: <kvm+bounces-53921-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 22F98B1A525
	for <lists+kvm@lfdr.de>; Mon,  4 Aug 2025 16:43:25 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id B3181189CC87
	for <lists+kvm@lfdr.de>; Mon,  4 Aug 2025 14:43:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 24F41272E7E;
	Mon,  4 Aug 2025 14:43:16 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4307F2472B6
	for <kvm@vger.kernel.org>; Mon,  4 Aug 2025 14:43:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754318595; cv=none; b=JfNHmfNpxMGwAd0mczp6S+ytCDf3iG6d0UOI0zmHgNIXQnncvX//BrEbt5NCt13q0C0TAZs/LTw1JP5seniqlcmv3uxnCO1i3S1K9s3e2gMwd6PT2K24QLb76CEAQmBjMvDnEAObe504j9WnvJyW5VO1CfbgtykLx/xR7dKChJ4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754318595; c=relaxed/simple;
	bh=i7aFJCu7C6jLM0yOr65UWbIHECPW1fCbPBfeeGWxTP8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=myTGleYbsvXdkDysQB16xevq5t1GLIyVd0OYfAxgxq6DMhevN5cU5yipyPehVP8vq3fpII79xxdMKY3AluJ0FpYI97MIjgYJTKxWMKlCWNOqqQrFvajzUu8/3HTlk47xu1cBVkS/rdYsv6qOYDiiUIjoorKt6NIZ0Y5LdWsUKLE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id A73BE1E4D;
	Mon,  4 Aug 2025 07:43:05 -0700 (PDT)
Received: from raptor (usa-sjc-mx-foss1.foss.arm.com [172.31.20.19])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 7D0C43F738;
	Mon,  4 Aug 2025 07:43:12 -0700 (PDT)
Date: Mon, 4 Aug 2025 15:43:09 +0100
From: Alexandru Elisei <alexandru.elisei@arm.com>
To: Andre Przywara <andre.przywara@arm.com>
Cc: Will Deacon <will@kernel.org>,
	Julien Thierry <julien.thierry.kdev@gmail.com>,
	Marc Zyngier <maz@kernel.org>, kvm@vger.kernel.org,
	kvmarm@lists.linux.dev
Subject: Re: [PATCH kvmtool v3 3/6] arm64: nested: add support for setting
 maintenance IRQ
Message-ID: <aJDG_YhNKIJBKCyQ@raptor>
References: <20250729095745.3148294-1-andre.przywara@arm.com>
 <20250729095745.3148294-4-andre.przywara@arm.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250729095745.3148294-4-andre.przywara@arm.com>

Hi Andre,

'add' should be capitalized.

On Tue, Jul 29, 2025 at 10:57:42AM +0100, Andre Przywara wrote:
> Uses the new VGIC KVM device attribute to set the maintenance IRQ.
> This is fixed to use PPI 9, as a platform decision made by kvmtool,
> matching the SBSA recommendation.
> 
> Signed-off-by: Andre Przywara <andre.przywara@arm.com>
> ---
>  arm64/arm-cpu.c         |  3 ++-
>  arm64/gic.c             | 21 ++++++++++++++++++++-
>  arm64/include/kvm/gic.h |  2 +-
>  3 files changed, 23 insertions(+), 3 deletions(-)
> 
> diff --git a/arm64/arm-cpu.c b/arm64/arm-cpu.c
> index 69bb2cb2c..1e456f2c6 100644
> --- a/arm64/arm-cpu.c
> +++ b/arm64/arm-cpu.c
> @@ -14,7 +14,8 @@ static void generate_fdt_nodes(void *fdt, struct kvm *kvm)
>  {
>  	int timer_interrupts[4] = {13, 14, 11, 10};
>  
> -	gic__generate_fdt_nodes(fdt, kvm->cfg.arch.irqchip);
> +	gic__generate_fdt_nodes(fdt, kvm->cfg.arch.irqchip,
> +				kvm->cfg.arch.nested_virt);
>  	timer__generate_fdt_nodes(fdt, kvm, timer_interrupts);
>  	pmu__generate_fdt_nodes(fdt, kvm);
>  }
> diff --git a/arm64/gic.c b/arm64/gic.c
> index b0d3a1abb..7461b0f3f 100644
> --- a/arm64/gic.c
> +++ b/arm64/gic.c
> @@ -11,6 +11,8 @@
>  
>  #define IRQCHIP_GIC 0
>  
> +#define GIC_MAINT_IRQ	9
> +
>  static int gic_fd = -1;
>  static u64 gic_redists_base;
>  static u64 gic_redists_size;
> @@ -302,10 +304,15 @@ static int gic__init_gic(struct kvm *kvm)
>  
>  	int lines = irq__get_nr_allocated_lines();
>  	u32 nr_irqs = ALIGN(lines, 32) + GIC_SPI_IRQ_BASE;
> +	u32 maint_irq = GIC_MAINT_IRQ + 16;			/* PPI */

There's already a define for PPIs:

	u32 maint_irq = GIC_PPI_IRQ_BASE + GIC_MAINT_IRQ;

>  	struct kvm_device_attr nr_irqs_attr = {
>  		.group	= KVM_DEV_ARM_VGIC_GRP_NR_IRQS,
>  		.addr	= (u64)(unsigned long)&nr_irqs,
>  	};
> +	struct kvm_device_attr maint_irq_attr = {
> +		.group	= KVM_DEV_ARM_VGIC_GRP_MAINT_IRQ,
> +		.addr	= (u64)(unsigned long)&maint_irq,
> +	};
>  	struct kvm_device_attr vgic_init_attr = {
>  		.group	= KVM_DEV_ARM_VGIC_GRP_CTRL,
>  		.attr	= KVM_DEV_ARM_VGIC_CTRL_INIT,
> @@ -325,6 +332,13 @@ static int gic__init_gic(struct kvm *kvm)
>  			return ret;
>  	}
>  
> +	if (kvm->cfg.arch.nested_virt &&
> +	    !ioctl(gic_fd, KVM_HAS_DEVICE_ATTR, &maint_irq_attr)) {

I'm not sure how useful the HAS_DEVICE_ATTR call is here: kvm_cpu__arch_init(),
which checks for KVM_CAP_ARM_EL2 capability, is called before gic__init_gic()
(base_init() vs late_init()). So at this point we know that KVM supports nested
virtualization.

Was it that KVM at some point supported nested virtualization but didn't have
the KVM_DEV_ARM_VGIC_GRP_MAINT_IRQ device attribute implemented? And if that was
the case, do we want to support that version of KVM in kvmtool?

> +		ret = ioctl(gic_fd, KVM_SET_DEVICE_ATTR, &maint_irq_attr);
> +		if (ret)
> +			return ret;
> +	}
> +
>  	irq__routing_init(kvm);
>  
>  	if (!ioctl(gic_fd, KVM_HAS_DEVICE_ATTR, &vgic_init_attr)) {
> @@ -342,7 +356,7 @@ static int gic__init_gic(struct kvm *kvm)
>  }
>  late_init(gic__init_gic)
>  
> -void gic__generate_fdt_nodes(void *fdt, enum irqchip_type type)
> +void gic__generate_fdt_nodes(void *fdt, enum irqchip_type type, bool nested)

I think you can drop 'type' and 'nested' and pass kvm directly, see below why.

>  {
>  	const char *compatible, *msi_compatible = NULL;
>  	u64 msi_prop[2];
> @@ -350,6 +364,8 @@ void gic__generate_fdt_nodes(void *fdt, enum irqchip_type type)
>  		cpu_to_fdt64(ARM_GIC_DIST_BASE), cpu_to_fdt64(ARM_GIC_DIST_SIZE),
>  		0, 0,				/* to be filled */
>  	};
> +	u32 maint_irq[3] = {cpu_to_fdt32(1), cpu_to_fdt32(GIC_MAINT_IRQ),
                      ^
You can leave that empty for the compiler to figure it out, like for the
'reg_prop' local variable.

Also, there's a define to specify the IRQ type, it's GIC_FDT_IRQ_TYPE_PPI, you
might want to use that.

> +			    cpu_to_fdt32(0xff04)};
                                         ^^^^^^
I think gic__get_fdt_irq_cpumask(kvm) | IRQ_TYPE_LEVEL_HIGH is better, similar
to pmu.c and timer.c.

>  
>  	switch (type) {
>  	case IRQCHIP_GICV2M:
> @@ -377,6 +393,9 @@ void gic__generate_fdt_nodes(void *fdt, enum irqchip_type type)
>  	_FDT(fdt_property_cell(fdt, "#interrupt-cells", GIC_FDT_IRQ_NUM_CELLS));
>  	_FDT(fdt_property(fdt, "interrupt-controller", NULL, 0));
>  	_FDT(fdt_property(fdt, "reg", reg_prop, sizeof(reg_prop)));
> +	if (nested)
> +		_FDT(fdt_property(fdt, "interrupts", maint_irq,
> +				  sizeof(maint_irq)));

Braces around the if if statement body? (it's multiline even though it's on
instruction)

Thanks,
Alex

>  	_FDT(fdt_property_cell(fdt, "phandle", PHANDLE_GIC));
>  	_FDT(fdt_property_cell(fdt, "#address-cells", 2));
>  	_FDT(fdt_property_cell(fdt, "#size-cells", 2));
> diff --git a/arm64/include/kvm/gic.h b/arm64/include/kvm/gic.h
> index ad8bcbf21..1541a5824 100644
> --- a/arm64/include/kvm/gic.h
> +++ b/arm64/include/kvm/gic.h
> @@ -36,7 +36,7 @@ struct kvm;
>  int gic__alloc_irqnum(void);
>  int gic__create(struct kvm *kvm, enum irqchip_type type);
>  int gic__create_gicv2m_frame(struct kvm *kvm, u64 msi_frame_addr);
> -void gic__generate_fdt_nodes(void *fdt, enum irqchip_type type);
> +void gic__generate_fdt_nodes(void *fdt, enum irqchip_type type, bool nested);
>  u32 gic__get_fdt_irq_cpumask(struct kvm *kvm);
>  
>  int gic__add_irqfd(struct kvm *kvm, unsigned int gsi, int trigger_fd,
> -- 
> 2.25.1
> 

