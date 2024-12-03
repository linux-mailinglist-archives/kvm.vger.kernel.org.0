Return-Path: <kvm+bounces-32924-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 661329E1E4A
	for <lists+kvm@lfdr.de>; Tue,  3 Dec 2024 14:54:04 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 27988287CEB
	for <lists+kvm@lfdr.de>; Tue,  3 Dec 2024 13:54:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F1FDA1F4265;
	Tue,  3 Dec 2024 13:53:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linutronix.de header.i=@linutronix.de header.b="ggEBgtSD";
	dkim=permerror (0-bit key) header.d=linutronix.de header.i=@linutronix.de header.b="iVaNrvhl"
X-Original-To: kvm@vger.kernel.org
Received: from galois.linutronix.de (Galois.linutronix.de [193.142.43.55])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 194291E501B;
	Tue,  3 Dec 2024 13:53:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=193.142.43.55
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733234031; cv=none; b=LPqqh9pTUm9N4rjq7PHceEYWdazbOaoI8qumqkyZrsOsQNq5iWkzuxIy4EmvYGk1qb+MWBXLbRYr/CKSNgP4jPNPhhcCs2s9QZTgrCRA+uHxtdXCQyjtyEDJ4qGZpgU8ROJ+daKsbsh3+eHAkX2F64f8gCykygjxG6YX7mjq0jE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733234031; c=relaxed/simple;
	bh=0wgOusxsqpVrRa2kFV14ilOo2YTArM2TDkdBjDdTQHg=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=FHGZE8zarF9O+cZZDW8Xo5Q6EtNYR9nMIpa9kjOh2h99ZAKe0H3CVIB3oW7saGb4cjET/puOLrqIcnqJWADZfUNv9laJ3XeNikIuURcVX7eDXyTl1bhKwueG85cKBCysq41xBDNSxe5LtKi/WaDzSLVfOuCc6reCmwuvah0QDZQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linutronix.de; spf=pass smtp.mailfrom=linutronix.de; dkim=pass (2048-bit key) header.d=linutronix.de header.i=@linutronix.de header.b=ggEBgtSD; dkim=permerror (0-bit key) header.d=linutronix.de header.i=@linutronix.de header.b=iVaNrvhl; arc=none smtp.client-ip=193.142.43.55
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linutronix.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linutronix.de
From: Thomas Gleixner <tglx@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020; t=1733234025;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=OimwqB/r3Nk8nQ65+nIw8ce4/cpQcWXc94E5L47e94w=;
	b=ggEBgtSDOAy4LGfQ9NiI/Qt5eSz6BNxrbNAqvxl4riEe6EMaG2q2IA/j1xhQT4mh+dS39i
	i2qmcRXm2ALdLKY4AnBWIdvfItpSIt1SwCDdPZfKqJICvh0/xPFvTgUbmQvGpUOAGD2KOW
	FcFFB7pUW6h2LUShktZyAch90lxBoNEreUlVhvhkf1M8cyg6kGPzkGeuw3KDnbsAUD8y4G
	/Y8aG9iv6WuG/5mBDSqjGZfHvMErwfUhvon/EikhzOVAKHLu5wKvhAZmbibkZlWi866xd7
	CXQ29aSmAAvNuUuLnaWlu2NjwihWDLOFaO/38WBWMLzddGzrA+AmXc6z8SNqWA==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020e; t=1733234025;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=OimwqB/r3Nk8nQ65+nIw8ce4/cpQcWXc94E5L47e94w=;
	b=iVaNrvhl9p04kXc772sB0Sf1jrTkbKLTmAbfzBVZIIdreUvY3FXCwWRknD7EcMGavum43P
	h8Dl4WJqEmSStwAQ==
To: Andrew Jones <ajones@ventanamicro.com>, iommu@lists.linux.dev,
 kvm-riscv@lists.infradead.org, kvm@vger.kernel.org,
 linux-riscv@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: tjeznach@rivosinc.com, zong.li@sifive.com, joro@8bytes.org,
 will@kernel.org, robin.murphy@arm.com, anup@brainfault.org,
 atishp@atishpatra.org, alex.williamson@redhat.com,
 paul.walmsley@sifive.com, palmer@dabbelt.com, aou@eecs.berkeley.edu
Subject: Re: [RFC PATCH 01/15] irqchip/riscv-imsic: Use hierarchy to reach
 irq_set_affinity
In-Reply-To: <20241114161845.502027-18-ajones@ventanamicro.com>
References: <20241114161845.502027-17-ajones@ventanamicro.com>
 <20241114161845.502027-18-ajones@ventanamicro.com>
Date: Tue, 03 Dec 2024 14:53:45 +0100
Message-ID: <87mshcub2u.ffs@tglx>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain

On Thu, Nov 14 2024 at 17:18, Andrew Jones wrote:
> @@ -96,9 +96,8 @@ static int imsic_irq_set_affinity(struct irq_data *d, const struct cpumask *mask
>  				  bool force)
>  {
>  	struct imsic_vector *old_vec, *new_vec;
> -	struct irq_data *pd = d->parent_data;
>  
> -	old_vec = irq_data_get_irq_chip_data(pd);
> +	old_vec = irq_data_get_irq_chip_data(d);
>  	if (WARN_ON(!old_vec))
>  		return -ENOENT;
>  
> @@ -116,13 +115,13 @@ static int imsic_irq_set_affinity(struct irq_data *d, const struct cpumask *mask
>  		return -ENOSPC;
>  
>  	/* Point device to the new vector */
> -	imsic_msi_update_msg(d, new_vec);
> +	imsic_msi_update_msg(irq_get_irq_data(d->irq), new_vec);

This looks more than fishy. See below.

> @@ -245,7 +247,7 @@ static bool imsic_init_dev_msi_info(struct device *dev,
>  		if (WARN_ON_ONCE(domain != real_parent))
>  			return false;
>  #ifdef CONFIG_SMP
> -		info->chip->irq_set_affinity = imsic_irq_set_affinity;
> +		info->chip->irq_set_affinity = irq_chip_set_affinity_parent;

This should use msi_domain_set_affinity(), which does the right thing:

  1) It invokes the irq_set_affinity() callback of the parent domain

  2) It composes the message via the hierarchy

  3) It writes the message with the msi_write_msg() callback of the top
     level domain

Sorry, I missed that when reviewing the original IMSIC MSI support.

The whole IMSIC MSI support can be moved over to MSI LIB which makes all
of this indirection go away and your intermediate domain will just fit
in.

Uncompiled patch below. If that works, it needs to be split up properly.

Note, this removes the setup of the irq_retrigger callback, but that's
fine because on hierarchical domains irq_chip_retrigger_hierarchy() is
invoked anyway. See try_retrigger().

Thanks,

        tglx
---
 drivers/irqchip/Kconfig                    |    1 
 drivers/irqchip/irq-gic-v2m.c              |    1 
 drivers/irqchip/irq-imx-mu-msi.c           |    1 
 drivers/irqchip/irq-msi-lib.c              |   11 +-
 drivers/irqchip/irq-mvebu-gicp.c           |    1 
 drivers/irqchip/irq-mvebu-odmi.c           |    1 
 drivers/irqchip/irq-mvebu-sei.c            |    1 
 drivers/irqchip/irq-riscv-imsic-platform.c |  131 +----------------------------
 include/linux/msi.h                        |   11 ++
 9 files changed, 32 insertions(+), 127 deletions(-)

--- a/drivers/irqchip/Kconfig
+++ b/drivers/irqchip/Kconfig
@@ -587,6 +587,7 @@ config RISCV_IMSIC
 	select IRQ_DOMAIN_HIERARCHY
 	select GENERIC_IRQ_MATRIX_ALLOCATOR
 	select GENERIC_MSI_IRQ
+	select IRQ_MSI_LIB
 
 config RISCV_IMSIC_PCI
 	bool
--- a/drivers/irqchip/irq-gic-v2m.c
+++ b/drivers/irqchip/irq-gic-v2m.c
@@ -255,6 +255,7 @@ static void __init gicv2m_teardown(void)
 static struct msi_parent_ops gicv2m_msi_parent_ops = {
 	.supported_flags	= GICV2M_MSI_FLAGS_SUPPORTED,
 	.required_flags		= GICV2M_MSI_FLAGS_REQUIRED,
+	.chip_flags		= MSI_CHIP_FLAG_SET_EOI | MSI_CHIP_FLAG_SET_ACK,
 	.bus_select_token	= DOMAIN_BUS_NEXUS,
 	.bus_select_mask	= MATCH_PCI_MSI | MATCH_PLATFORM_MSI,
 	.prefix			= "GICv2m-",
--- a/drivers/irqchip/irq-imx-mu-msi.c
+++ b/drivers/irqchip/irq-imx-mu-msi.c
@@ -214,6 +214,7 @@ static void imx_mu_msi_irq_handler(struc
 static const struct msi_parent_ops imx_mu_msi_parent_ops = {
 	.supported_flags	= IMX_MU_MSI_FLAGS_SUPPORTED,
 	.required_flags		= IMX_MU_MSI_FLAGS_REQUIRED,
+	.chip_flags		= MSI_CHIP_FLAG_SET_EOI | MSI_CHIP_FLAG_SET_ACK,
 	.bus_select_token       = DOMAIN_BUS_NEXUS,
 	.bus_select_mask	= MATCH_PLATFORM_MSI,
 	.prefix			= "MU-MSI-",
--- a/drivers/irqchip/irq-msi-lib.c
+++ b/drivers/irqchip/irq-msi-lib.c
@@ -28,6 +28,7 @@ bool msi_lib_init_dev_msi_info(struct de
 			       struct msi_domain_info *info)
 {
 	const struct msi_parent_ops *pops = real_parent->msi_parent_ops;
+	struct irq_chip *chip = info->chip;
 	u32 required_flags;
 
 	/* Parent ops available? */
@@ -92,10 +93,10 @@ bool msi_lib_init_dev_msi_info(struct de
 	info->flags			|= required_flags;
 
 	/* Chip updates for all child bus types */
-	if (!info->chip->irq_eoi)
-		info->chip->irq_eoi	= irq_chip_eoi_parent;
-	if (!info->chip->irq_ack)
-		info->chip->irq_ack	= irq_chip_ack_parent;
+	if (!chip->irq_eoi && (pops->chip_flags & MSI_CHIP_FLAG_SET_EOI))
+		chip->irq_eoi		= irq_chip_eoi_parent;
+	if (!chip->irq_ack && (pops->chip_flags & MSI_CHIP_FLAG_SET_ACK))
+		chip->irq_ack		= irq_chip_ack_parent;
 
 	/*
 	 * The device MSI domain can never have a set affinity callback. It
@@ -105,7 +106,7 @@ bool msi_lib_init_dev_msi_info(struct de
 	 * device MSI domain aside of mask/unmask which is provided e.g. by
 	 * PCI/MSI device domains.
 	 */
-	info->chip->irq_set_affinity	= msi_domain_set_affinity;
+	chip->irq_set_affinity		= msi_domain_set_affinity;
 	return true;
 }
 EXPORT_SYMBOL_GPL(msi_lib_init_dev_msi_info);
--- a/drivers/irqchip/irq-mvebu-gicp.c
+++ b/drivers/irqchip/irq-mvebu-gicp.c
@@ -161,6 +161,7 @@ static const struct irq_domain_ops gicp_
 static const struct msi_parent_ops gicp_msi_parent_ops = {
 	.supported_flags	= GICP_MSI_FLAGS_SUPPORTED,
 	.required_flags		= GICP_MSI_FLAGS_REQUIRED,
+	.chip_flags		= MSI_CHIP_FLAG_SET_EOI | MSI_CHIP_FLAG_SET_ACK,
 	.bus_select_token       = DOMAIN_BUS_GENERIC_MSI,
 	.bus_select_mask	= MATCH_PLATFORM_MSI,
 	.prefix			= "GICP-",
--- a/drivers/irqchip/irq-mvebu-odmi.c
+++ b/drivers/irqchip/irq-mvebu-odmi.c
@@ -157,6 +157,7 @@ static const struct irq_domain_ops odmi_
 static const struct msi_parent_ops odmi_msi_parent_ops = {
 	.supported_flags	= ODMI_MSI_FLAGS_SUPPORTED,
 	.required_flags		= ODMI_MSI_FLAGS_REQUIRED,
+	.chip_flags		= MSI_CHIP_FLAG_SET_EOI | MSI_CHIP_FLAG_SET_ACK,
 	.bus_select_token	= DOMAIN_BUS_GENERIC_MSI,
 	.bus_select_mask	= MATCH_PLATFORM_MSI,
 	.prefix			= "ODMI-",
--- a/drivers/irqchip/irq-mvebu-sei.c
+++ b/drivers/irqchip/irq-mvebu-sei.c
@@ -356,6 +356,7 @@ static void mvebu_sei_reset(struct mvebu
 static const struct msi_parent_ops sei_msi_parent_ops = {
 	.supported_flags	= SEI_MSI_FLAGS_SUPPORTED,
 	.required_flags		= SEI_MSI_FLAGS_REQUIRED,
+	.chip_flags		= MSI_CHIP_FLAG_SET_EOI | MSI_CHIP_FLAG_SET_ACK,
 	.bus_select_mask	= MATCH_PLATFORM_MSI,
 	.bus_select_token	= DOMAIN_BUS_GENERIC_MSI,
 	.prefix			= "SEI-",
--- a/drivers/irqchip/irq-riscv-imsic-platform.c
+++ b/drivers/irqchip/irq-riscv-imsic-platform.c
@@ -21,6 +21,7 @@
 #include <linux/smp.h>
 
 #include "irq-riscv-imsic-state.h"
+#include "irq-msi-lib.h"
 
 static bool imsic_cpu_page_phys(unsigned int cpu, unsigned int guest_index,
 				phys_addr_t *out_msi_pa)
@@ -84,19 +85,10 @@ static void imsic_irq_compose_msg(struct
 }
 
 #ifdef CONFIG_SMP
-static void imsic_msi_update_msg(struct irq_data *d, struct imsic_vector *vec)
-{
-	struct msi_msg msg = { };
-
-	imsic_irq_compose_vector_msg(vec, &msg);
-	irq_data_get_irq_chip(d)->irq_write_msi_msg(d, &msg);
-}
-
 static int imsic_irq_set_affinity(struct irq_data *d, const struct cpumask *mask_val,
 				  bool force)
 {
 	struct imsic_vector *old_vec, *new_vec;
-	struct irq_data *pd = d->parent_data;
 
 	old_vec = irq_data_get_irq_chip_data(pd);
 	if (WARN_ON(!old_vec))
@@ -115,14 +107,11 @@ static int imsic_irq_set_affinity(struct
 	if (!new_vec)
 		return -ENOSPC;
 
-	/* Point device to the new vector */
-	imsic_msi_update_msg(d, new_vec);
-
 	/* Update irq descriptors with the new vector */
-	pd->chip_data = new_vec;
+	d->chip_data = new_vec;
 
 	/* Update effective affinity of parent irq data */
-	irq_data_update_effective_affinity(pd, cpumask_of(new_vec->cpu));
+	irq_data_update_effective_affinity(d, cpumask_of(new_vec->cpu));
 
 	/* Move state of the old vector to the new vector */
 	imsic_vector_move(old_vec, new_vec);
@@ -137,6 +126,9 @@ static struct irq_chip imsic_irq_base_ch
 	.irq_unmask		= imsic_irq_unmask,
 	.irq_retrigger		= imsic_irq_retrigger,
 	.irq_compose_msi_msg	= imsic_irq_compose_msg,
+#ifdef CONFIG_SMP
+	.irq_set_affinity	= imsic_irq_set_affinity,
+#endif
 	.flags			= IRQCHIP_SKIP_SET_WAKE |
 				  IRQCHIP_MASK_ON_SUSPEND,
 };
@@ -172,22 +164,6 @@ static void imsic_irq_domain_free(struct
 	irq_domain_free_irqs_parent(domain, virq, nr_irqs);
 }
 
-static int imsic_irq_domain_select(struct irq_domain *domain, struct irq_fwspec *fwspec,
-				   enum irq_domain_bus_token bus_token)
-{
-	const struct msi_parent_ops *ops = domain->msi_parent_ops;
-	u32 busmask = BIT(bus_token);
-
-	if (fwspec->fwnode != domain->fwnode || fwspec->param_count != 0)
-		return 0;
-
-	/* Handle pure domain searches */
-	if (bus_token == ops->bus_select_token)
-		return 1;
-
-	return !!(ops->bus_select_mask & busmask);
-}
-
 #ifdef CONFIG_GENERIC_IRQ_DEBUGFS
 static void imsic_irq_debug_show(struct seq_file *m, struct irq_domain *d,
 				 struct irq_data *irqd, int ind)
@@ -210,104 +186,15 @@ static const struct irq_domain_ops imsic
 #endif
 };
 
-#ifdef CONFIG_RISCV_IMSIC_PCI
-
-static void imsic_pci_mask_irq(struct irq_data *d)
-{
-	pci_msi_mask_irq(d);
-	irq_chip_mask_parent(d);
-}
-
-static void imsic_pci_unmask_irq(struct irq_data *d)
-{
-	irq_chip_unmask_parent(d);
-	pci_msi_unmask_irq(d);
-}
-
-#define MATCH_PCI_MSI		BIT(DOMAIN_BUS_PCI_MSI)
-
-#else
-
-#define MATCH_PCI_MSI		0
-
-#endif
-
-static bool imsic_init_dev_msi_info(struct device *dev,
-				    struct irq_domain *domain,
-				    struct irq_domain *real_parent,
-				    struct msi_domain_info *info)
-{
-	const struct msi_parent_ops *pops = real_parent->msi_parent_ops;
-
-	/* MSI parent domain specific settings */
-	switch (real_parent->bus_token) {
-	case DOMAIN_BUS_NEXUS:
-		if (WARN_ON_ONCE(domain != real_parent))
-			return false;
-#ifdef CONFIG_SMP
-		info->chip->irq_set_affinity = imsic_irq_set_affinity;
-#endif
-		break;
-	default:
-		WARN_ON_ONCE(1);
-		return false;
-	}
-
-	/* Is the target supported? */
-	switch (info->bus_token) {
-#ifdef CONFIG_RISCV_IMSIC_PCI
-	case DOMAIN_BUS_PCI_DEVICE_MSI:
-	case DOMAIN_BUS_PCI_DEVICE_MSIX:
-		info->chip->irq_mask = imsic_pci_mask_irq;
-		info->chip->irq_unmask = imsic_pci_unmask_irq;
-		break;
-#endif
-	case DOMAIN_BUS_DEVICE_MSI:
-		/*
-		 * Per-device MSI should never have any MSI feature bits
-		 * set. It's sole purpose is to create a dumb interrupt
-		 * chip which has a device specific irq_write_msi_msg()
-		 * callback.
-		 */
-		if (WARN_ON_ONCE(info->flags))
-			return false;
-
-		/* Core managed MSI descriptors */
-		info->flags |= MSI_FLAG_ALLOC_SIMPLE_MSI_DESCS |
-			       MSI_FLAG_FREE_MSI_DESCS;
-		break;
-	case DOMAIN_BUS_WIRED_TO_MSI:
-		break;
-	default:
-		WARN_ON_ONCE(1);
-		return false;
-	}
-
-	/* Use hierarchial chip operations re-trigger */
-	info->chip->irq_retrigger = irq_chip_retrigger_hierarchy;
-
-	/*
-	 * Mask out the domain specific MSI feature flags which are not
-	 * supported by the real parent.
-	 */
-	info->flags &= pops->supported_flags;
-
-	/* Enforce the required flags */
-	info->flags |= pops->required_flags;
-
-	return true;
-}
-
-#define MATCH_PLATFORM_MSI		BIT(DOMAIN_BUS_PLATFORM_MSI)
-
 static const struct msi_parent_ops imsic_msi_parent_ops = {
 	.supported_flags	= MSI_GENERIC_FLAGS_MASK |
 				  MSI_FLAG_PCI_MSIX,
 	.required_flags		= MSI_FLAG_USE_DEF_DOM_OPS |
-				  MSI_FLAG_USE_DEF_CHIP_OPS,
+				  MSI_FLAG_USE_DEF_CHIP_OPS |
+				  MSI_FLAG_PCI_MSI_MASK_PARENT,
 	.bus_select_token	= DOMAIN_BUS_NEXUS,
 	.bus_select_mask	= MATCH_PCI_MSI | MATCH_PLATFORM_MSI,
-	.init_dev_msi_info	= imsic_init_dev_msi_info,
+	.init_dev_msi_info	= msi_lib_init_dev_msi_info,
 };
 
 int imsic_irqdomain_init(void)
--- a/include/linux/msi.h
+++ b/include/linux/msi.h
@@ -558,11 +558,21 @@ enum {
 	MSI_FLAG_NO_AFFINITY		= (1 << 21),
 };
 
+/*
+ * Flags for msi_parent_ops::chip_flags
+ */
+enum {
+	MSI_CHIP_FLAG_SET_EOI		= (1 << 0),
+	MSI_CHIP_FLAG_SET_ACK		= (1 << 1),
+};
+
 /**
  * struct msi_parent_ops - MSI parent domain callbacks and configuration info
  *
  * @supported_flags:	Required: The supported MSI flags of the parent domain
  * @required_flags:	Optional: The required MSI flags of the parent MSI domain
+ * @chip_flags:		Optional: Select MSI chip callbacks to update with defaults
+ *			in msi_lib_init_dev_msi_info().
  * @bus_select_token:	Optional: The bus token of the real parent domain for
  *			irq_domain::select()
  * @bus_select_mask:	Optional: A mask of supported BUS_DOMAINs for
@@ -575,6 +585,7 @@ enum {
 struct msi_parent_ops {
 	u32		supported_flags;
 	u32		required_flags;
+	u32		chip_flags;
 	u32		bus_select_token;
 	u32		bus_select_mask;
 	const char	*prefix;

