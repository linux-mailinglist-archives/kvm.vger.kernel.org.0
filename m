Return-Path: <kvm+bounces-32939-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 2013B9E27AE
	for <lists+kvm@lfdr.de>; Tue,  3 Dec 2024 17:37:57 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id DB766165725
	for <lists+kvm@lfdr.de>; Tue,  3 Dec 2024 16:37:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1F8C01F8AFB;
	Tue,  3 Dec 2024 16:37:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=brainfault-org.20230601.gappssmtp.com header.i=@brainfault-org.20230601.gappssmtp.com header.b="nuGIkOQq"
X-Original-To: kvm@vger.kernel.org
Received: from mail-io1-f48.google.com (mail-io1-f48.google.com [209.85.166.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5F9811F76BC
	for <kvm@vger.kernel.org>; Tue,  3 Dec 2024 16:37:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733243869; cv=none; b=TUJCvZtRyW3LXcmB4s7ATfk6F7SCo6S5QejdCHwb8b77LzENRgI16Ji46VdUKec7BweHxbpQ1F0CtzPlek5VCwr6JClCgEymw7ewW9oYYxnO8kYxARgqC5Xdx1t7RT1Q7WAUPb3k1l2UhkH7jYLT0j4r/esMA+8LWE2YChvI8xo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733243869; c=relaxed/simple;
	bh=ofyNNqa9LTqECGe/gznO0EdfOgfFJo0pEY4QR+7Ei5o=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=o8olXxMgtkPGeaG3aExjKj9kMxVOq5LGHeN7mOtFYbIcAMB6Mz2V5RQ3T5BcwabK8E80IHdO1aB8HIjKkFs7f5iFDaUiQIdv4h6NP0G0u+DrJyruK6M/ovn3GE5dSEfbsZh524Fy69Zuc0j7tqx7RUEVkOMfuUMQ1KFtY16P0Po=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=brainfault.org; spf=none smtp.mailfrom=brainfault.org; dkim=pass (2048-bit key) header.d=brainfault-org.20230601.gappssmtp.com header.i=@brainfault-org.20230601.gappssmtp.com header.b=nuGIkOQq; arc=none smtp.client-ip=209.85.166.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=brainfault.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=brainfault.org
Received: by mail-io1-f48.google.com with SMTP id ca18e2360f4ac-841a9c504d4so228751239f.0
        for <kvm@vger.kernel.org>; Tue, 03 Dec 2024 08:37:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=brainfault-org.20230601.gappssmtp.com; s=20230601; t=1733243866; x=1733848666; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=SVEw9Z9xC+e2116o+1WJfODi8M47QRe9C2e4ZFiB9Qs=;
        b=nuGIkOQqO0IoXQdY7H6EFS7elzVhFkdOmrOtb1YBUkiIcIbDwDEOhC//s0jniyM2p2
         QMYNQRghg2gvhN+9XDKvcFHTkeR4pGlT47Lit/FrvMk5TzQk+TOPh+miHty7q+Kjp75F
         DfIrWLX21Pd4jCOt4Zh70hai5pcIlpbCie1erHAPTPoMfyIqrsbTewMrnZWmgik4ohTB
         LqVTHrFg+F/kDNfED/9HQCS0Pw4Dyc6CG1FLsaqfp/HYZfTMYbhC/TLeCUwveNbNY7r8
         h44KTyQodHDa6HlMWGmQP4LLEMRgakXEmGTnaOq6OS52PW7lL+uZb2IQVeSoLeEMisfM
         /jQw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1733243866; x=1733848666;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=SVEw9Z9xC+e2116o+1WJfODi8M47QRe9C2e4ZFiB9Qs=;
        b=KmBP7JHPqJJtDWkl1IxoHl8unAX3tV4Z83gh7uTx26L7+39mFkXvBy8TzpUkFZcTK3
         6wLjXE+ky1uHwUkiN5UWtIFbDQDJfMSGNZ8+xP08Vwrra/W8eEK+DgTod3biXWLAhseX
         w8dB+aYX1HfgfmUNSCDbWYP+MoltW+jUuwbzfn+YO9bkxh+z1478i4Ki1xabFz5Nxk1z
         KBTGyGyYwMcQ2W1Ekq8QOw2XeESoAcPyD4Goxd1J2NRgjeLYX9dL+05afnPWJmt/xWzp
         LRvxSRawRKuk47cCLwnojMIqz17Mu0uRjjBdDFvI7MCUNWZ53V/C7yOXfABPoPbxhqsz
         ZAjw==
X-Forwarded-Encrypted: i=1; AJvYcCXbb+MgZhXjI59YtdZDJneXLgBZ1UqA60Ge1AtQcTZQMMQSCcamz/EX327y8tvCt6baxoI=@vger.kernel.org
X-Gm-Message-State: AOJu0Yy5YgZl6KUWoz65Au2lp1sQBnzazJzhmsyOHJhDtkVkdb5K6m+h
	HFvsNPo8khwSHvO5HnzU6Kn90gwgxje6MfgEbJr5QP03f75nrD9c/JjT9/BmaPg2bC9ufFwWlvs
	8JmbI9xNBQtPEb7YU9FPDMd30yDzGBJEsmEvl9Q==
X-Gm-Gg: ASbGnct7qjuuHqcgN2appDcJAe6c1EOLOaHlTAqk/1aeuqxbgHBmDXv2mGGDDTocL7X
	XeIoThuur5R8AfAxgdthzFBxEdGJZYfcc9A==
X-Google-Smtp-Source: AGHT+IEZS46Tt3F60SbyrRtm2o2atDwxxLqUtooVOzxuLEORF7+J61E8/7nJWNy4oOtVonZIMZTW80oPYgYr7U4CpuY=
X-Received: by 2002:a05:6602:1593:b0:843:e11e:e7e1 with SMTP id
 ca18e2360f4ac-8445b6da045mr370006839f.14.1733243866405; Tue, 03 Dec 2024
 08:37:46 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20241114161845.502027-17-ajones@ventanamicro.com>
 <20241114161845.502027-18-ajones@ventanamicro.com> <87mshcub2u.ffs@tglx>
In-Reply-To: <87mshcub2u.ffs@tglx>
From: Anup Patel <anup@brainfault.org>
Date: Tue, 3 Dec 2024 22:07:35 +0530
Message-ID: <CAAhSdy08gi998HsTkGpaV+bTWczVSL6D8c7EmuTQqovo63oXDw@mail.gmail.com>
Subject: Re: [RFC PATCH 01/15] irqchip/riscv-imsic: Use hierarchy to reach irq_set_affinity
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Andrew Jones <ajones@ventanamicro.com>, iommu@lists.linux.dev, 
	kvm-riscv@lists.infradead.org, kvm@vger.kernel.org, 
	linux-riscv@lists.infradead.org, linux-kernel@vger.kernel.org, 
	tjeznach@rivosinc.com, zong.li@sifive.com, joro@8bytes.org, will@kernel.org, 
	robin.murphy@arm.com, atishp@atishpatra.org, alex.williamson@redhat.com, 
	paul.walmsley@sifive.com, palmer@dabbelt.com, aou@eecs.berkeley.edu
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Dec 3, 2024 at 7:23=E2=80=AFPM Thomas Gleixner <tglx@linutronix.de>=
 wrote:
>
> On Thu, Nov 14 2024 at 17:18, Andrew Jones wrote:
> > @@ -96,9 +96,8 @@ static int imsic_irq_set_affinity(struct irq_data *d,=
 const struct cpumask *mask
> >                                 bool force)
> >  {
> >       struct imsic_vector *old_vec, *new_vec;
> > -     struct irq_data *pd =3D d->parent_data;
> >
> > -     old_vec =3D irq_data_get_irq_chip_data(pd);
> > +     old_vec =3D irq_data_get_irq_chip_data(d);
> >       if (WARN_ON(!old_vec))
> >               return -ENOENT;
> >
> > @@ -116,13 +115,13 @@ static int imsic_irq_set_affinity(struct irq_data=
 *d, const struct cpumask *mask
> >               return -ENOSPC;
> >
> >       /* Point device to the new vector */
> > -     imsic_msi_update_msg(d, new_vec);
> > +     imsic_msi_update_msg(irq_get_irq_data(d->irq), new_vec);
>
> This looks more than fishy. See below.
>
> > @@ -245,7 +247,7 @@ static bool imsic_init_dev_msi_info(struct device *=
dev,
> >               if (WARN_ON_ONCE(domain !=3D real_parent))
> >                       return false;
> >  #ifdef CONFIG_SMP
> > -             info->chip->irq_set_affinity =3D imsic_irq_set_affinity;
> > +             info->chip->irq_set_affinity =3D irq_chip_set_affinity_pa=
rent;
>
> This should use msi_domain_set_affinity(), which does the right thing:
>
>   1) It invokes the irq_set_affinity() callback of the parent domain
>
>   2) It composes the message via the hierarchy
>
>   3) It writes the message with the msi_write_msg() callback of the top
>      level domain
>
> Sorry, I missed that when reviewing the original IMSIC MSI support.
>
> The whole IMSIC MSI support can be moved over to MSI LIB which makes all
> of this indirection go away and your intermediate domain will just fit
> in.
>
> Uncompiled patch below. If that works, it needs to be split up properly.
>
> Note, this removes the setup of the irq_retrigger callback, but that's
> fine because on hierarchical domains irq_chip_retrigger_hierarchy() is
> invoked anyway. See try_retrigger().

The IMSIC driver was merged one kernel release before common
MSI LIB was merged.

We should definitely update the IMSIC driver to use MSI LIB, I will
try your suggested changes (below) and post a separate series.

Thanks,
Anup

>
> Thanks,
>
>         tglx
> ---
>  drivers/irqchip/Kconfig                    |    1
>  drivers/irqchip/irq-gic-v2m.c              |    1
>  drivers/irqchip/irq-imx-mu-msi.c           |    1
>  drivers/irqchip/irq-msi-lib.c              |   11 +-
>  drivers/irqchip/irq-mvebu-gicp.c           |    1
>  drivers/irqchip/irq-mvebu-odmi.c           |    1
>  drivers/irqchip/irq-mvebu-sei.c            |    1
>  drivers/irqchip/irq-riscv-imsic-platform.c |  131 +---------------------=
-------
>  include/linux/msi.h                        |   11 ++
>  9 files changed, 32 insertions(+), 127 deletions(-)
>
> --- a/drivers/irqchip/Kconfig
> +++ b/drivers/irqchip/Kconfig
> @@ -587,6 +587,7 @@ config RISCV_IMSIC
>         select IRQ_DOMAIN_HIERARCHY
>         select GENERIC_IRQ_MATRIX_ALLOCATOR
>         select GENERIC_MSI_IRQ
> +       select IRQ_MSI_LIB
>
>  config RISCV_IMSIC_PCI
>         bool
> --- a/drivers/irqchip/irq-gic-v2m.c
> +++ b/drivers/irqchip/irq-gic-v2m.c
> @@ -255,6 +255,7 @@ static void __init gicv2m_teardown(void)
>  static struct msi_parent_ops gicv2m_msi_parent_ops =3D {
>         .supported_flags        =3D GICV2M_MSI_FLAGS_SUPPORTED,
>         .required_flags         =3D GICV2M_MSI_FLAGS_REQUIRED,
> +       .chip_flags             =3D MSI_CHIP_FLAG_SET_EOI | MSI_CHIP_FLAG=
_SET_ACK,
>         .bus_select_token       =3D DOMAIN_BUS_NEXUS,
>         .bus_select_mask        =3D MATCH_PCI_MSI | MATCH_PLATFORM_MSI,
>         .prefix                 =3D "GICv2m-",
> --- a/drivers/irqchip/irq-imx-mu-msi.c
> +++ b/drivers/irqchip/irq-imx-mu-msi.c
> @@ -214,6 +214,7 @@ static void imx_mu_msi_irq_handler(struc
>  static const struct msi_parent_ops imx_mu_msi_parent_ops =3D {
>         .supported_flags        =3D IMX_MU_MSI_FLAGS_SUPPORTED,
>         .required_flags         =3D IMX_MU_MSI_FLAGS_REQUIRED,
> +       .chip_flags             =3D MSI_CHIP_FLAG_SET_EOI | MSI_CHIP_FLAG=
_SET_ACK,
>         .bus_select_token       =3D DOMAIN_BUS_NEXUS,
>         .bus_select_mask        =3D MATCH_PLATFORM_MSI,
>         .prefix                 =3D "MU-MSI-",
> --- a/drivers/irqchip/irq-msi-lib.c
> +++ b/drivers/irqchip/irq-msi-lib.c
> @@ -28,6 +28,7 @@ bool msi_lib_init_dev_msi_info(struct de
>                                struct msi_domain_info *info)
>  {
>         const struct msi_parent_ops *pops =3D real_parent->msi_parent_ops=
;
> +       struct irq_chip *chip =3D info->chip;
>         u32 required_flags;
>
>         /* Parent ops available? */
> @@ -92,10 +93,10 @@ bool msi_lib_init_dev_msi_info(struct de
>         info->flags                     |=3D required_flags;
>
>         /* Chip updates for all child bus types */
> -       if (!info->chip->irq_eoi)
> -               info->chip->irq_eoi     =3D irq_chip_eoi_parent;
> -       if (!info->chip->irq_ack)
> -               info->chip->irq_ack     =3D irq_chip_ack_parent;
> +       if (!chip->irq_eoi && (pops->chip_flags & MSI_CHIP_FLAG_SET_EOI))
> +               chip->irq_eoi           =3D irq_chip_eoi_parent;
> +       if (!chip->irq_ack && (pops->chip_flags & MSI_CHIP_FLAG_SET_ACK))
> +               chip->irq_ack           =3D irq_chip_ack_parent;
>
>         /*
>          * The device MSI domain can never have a set affinity callback. =
It
> @@ -105,7 +106,7 @@ bool msi_lib_init_dev_msi_info(struct de
>          * device MSI domain aside of mask/unmask which is provided e.g. =
by
>          * PCI/MSI device domains.
>          */
> -       info->chip->irq_set_affinity    =3D msi_domain_set_affinity;
> +       chip->irq_set_affinity          =3D msi_domain_set_affinity;
>         return true;
>  }
>  EXPORT_SYMBOL_GPL(msi_lib_init_dev_msi_info);
> --- a/drivers/irqchip/irq-mvebu-gicp.c
> +++ b/drivers/irqchip/irq-mvebu-gicp.c
> @@ -161,6 +161,7 @@ static const struct irq_domain_ops gicp_
>  static const struct msi_parent_ops gicp_msi_parent_ops =3D {
>         .supported_flags        =3D GICP_MSI_FLAGS_SUPPORTED,
>         .required_flags         =3D GICP_MSI_FLAGS_REQUIRED,
> +       .chip_flags             =3D MSI_CHIP_FLAG_SET_EOI | MSI_CHIP_FLAG=
_SET_ACK,
>         .bus_select_token       =3D DOMAIN_BUS_GENERIC_MSI,
>         .bus_select_mask        =3D MATCH_PLATFORM_MSI,
>         .prefix                 =3D "GICP-",
> --- a/drivers/irqchip/irq-mvebu-odmi.c
> +++ b/drivers/irqchip/irq-mvebu-odmi.c
> @@ -157,6 +157,7 @@ static const struct irq_domain_ops odmi_
>  static const struct msi_parent_ops odmi_msi_parent_ops =3D {
>         .supported_flags        =3D ODMI_MSI_FLAGS_SUPPORTED,
>         .required_flags         =3D ODMI_MSI_FLAGS_REQUIRED,
> +       .chip_flags             =3D MSI_CHIP_FLAG_SET_EOI | MSI_CHIP_FLAG=
_SET_ACK,
>         .bus_select_token       =3D DOMAIN_BUS_GENERIC_MSI,
>         .bus_select_mask        =3D MATCH_PLATFORM_MSI,
>         .prefix                 =3D "ODMI-",
> --- a/drivers/irqchip/irq-mvebu-sei.c
> +++ b/drivers/irqchip/irq-mvebu-sei.c
> @@ -356,6 +356,7 @@ static void mvebu_sei_reset(struct mvebu
>  static const struct msi_parent_ops sei_msi_parent_ops =3D {
>         .supported_flags        =3D SEI_MSI_FLAGS_SUPPORTED,
>         .required_flags         =3D SEI_MSI_FLAGS_REQUIRED,
> +       .chip_flags             =3D MSI_CHIP_FLAG_SET_EOI | MSI_CHIP_FLAG=
_SET_ACK,
>         .bus_select_mask        =3D MATCH_PLATFORM_MSI,
>         .bus_select_token       =3D DOMAIN_BUS_GENERIC_MSI,
>         .prefix                 =3D "SEI-",
> --- a/drivers/irqchip/irq-riscv-imsic-platform.c
> +++ b/drivers/irqchip/irq-riscv-imsic-platform.c
> @@ -21,6 +21,7 @@
>  #include <linux/smp.h>
>
>  #include "irq-riscv-imsic-state.h"
> +#include "irq-msi-lib.h"
>
>  static bool imsic_cpu_page_phys(unsigned int cpu, unsigned int guest_ind=
ex,
>                                 phys_addr_t *out_msi_pa)
> @@ -84,19 +85,10 @@ static void imsic_irq_compose_msg(struct
>  }
>
>  #ifdef CONFIG_SMP
> -static void imsic_msi_update_msg(struct irq_data *d, struct imsic_vector=
 *vec)
> -{
> -       struct msi_msg msg =3D { };
> -
> -       imsic_irq_compose_vector_msg(vec, &msg);
> -       irq_data_get_irq_chip(d)->irq_write_msi_msg(d, &msg);
> -}
> -
>  static int imsic_irq_set_affinity(struct irq_data *d, const struct cpuma=
sk *mask_val,
>                                   bool force)
>  {
>         struct imsic_vector *old_vec, *new_vec;
> -       struct irq_data *pd =3D d->parent_data;
>
>         old_vec =3D irq_data_get_irq_chip_data(pd);
>         if (WARN_ON(!old_vec))
> @@ -115,14 +107,11 @@ static int imsic_irq_set_affinity(struct
>         if (!new_vec)
>                 return -ENOSPC;
>
> -       /* Point device to the new vector */
> -       imsic_msi_update_msg(d, new_vec);
> -
>         /* Update irq descriptors with the new vector */
> -       pd->chip_data =3D new_vec;
> +       d->chip_data =3D new_vec;
>
>         /* Update effective affinity of parent irq data */
> -       irq_data_update_effective_affinity(pd, cpumask_of(new_vec->cpu));
> +       irq_data_update_effective_affinity(d, cpumask_of(new_vec->cpu));
>
>         /* Move state of the old vector to the new vector */
>         imsic_vector_move(old_vec, new_vec);
> @@ -137,6 +126,9 @@ static struct irq_chip imsic_irq_base_ch
>         .irq_unmask             =3D imsic_irq_unmask,
>         .irq_retrigger          =3D imsic_irq_retrigger,
>         .irq_compose_msi_msg    =3D imsic_irq_compose_msg,
> +#ifdef CONFIG_SMP
> +       .irq_set_affinity       =3D imsic_irq_set_affinity,
> +#endif
>         .flags                  =3D IRQCHIP_SKIP_SET_WAKE |
>                                   IRQCHIP_MASK_ON_SUSPEND,
>  };
> @@ -172,22 +164,6 @@ static void imsic_irq_domain_free(struct
>         irq_domain_free_irqs_parent(domain, virq, nr_irqs);
>  }
>
> -static int imsic_irq_domain_select(struct irq_domain *domain, struct irq=
_fwspec *fwspec,
> -                                  enum irq_domain_bus_token bus_token)
> -{
> -       const struct msi_parent_ops *ops =3D domain->msi_parent_ops;
> -       u32 busmask =3D BIT(bus_token);
> -
> -       if (fwspec->fwnode !=3D domain->fwnode || fwspec->param_count !=
=3D 0)
> -               return 0;
> -
> -       /* Handle pure domain searches */
> -       if (bus_token =3D=3D ops->bus_select_token)
> -               return 1;
> -
> -       return !!(ops->bus_select_mask & busmask);
> -}
> -
>  #ifdef CONFIG_GENERIC_IRQ_DEBUGFS
>  static void imsic_irq_debug_show(struct seq_file *m, struct irq_domain *=
d,
>                                  struct irq_data *irqd, int ind)
> @@ -210,104 +186,15 @@ static const struct irq_domain_ops imsic
>  #endif
>  };
>
> -#ifdef CONFIG_RISCV_IMSIC_PCI
> -
> -static void imsic_pci_mask_irq(struct irq_data *d)
> -{
> -       pci_msi_mask_irq(d);
> -       irq_chip_mask_parent(d);
> -}
> -
> -static void imsic_pci_unmask_irq(struct irq_data *d)
> -{
> -       irq_chip_unmask_parent(d);
> -       pci_msi_unmask_irq(d);
> -}
> -
> -#define MATCH_PCI_MSI          BIT(DOMAIN_BUS_PCI_MSI)
> -
> -#else
> -
> -#define MATCH_PCI_MSI          0
> -
> -#endif
> -
> -static bool imsic_init_dev_msi_info(struct device *dev,
> -                                   struct irq_domain *domain,
> -                                   struct irq_domain *real_parent,
> -                                   struct msi_domain_info *info)
> -{
> -       const struct msi_parent_ops *pops =3D real_parent->msi_parent_ops=
;
> -
> -       /* MSI parent domain specific settings */
> -       switch (real_parent->bus_token) {
> -       case DOMAIN_BUS_NEXUS:
> -               if (WARN_ON_ONCE(domain !=3D real_parent))
> -                       return false;
> -#ifdef CONFIG_SMP
> -               info->chip->irq_set_affinity =3D imsic_irq_set_affinity;
> -#endif
> -               break;
> -       default:
> -               WARN_ON_ONCE(1);
> -               return false;
> -       }
> -
> -       /* Is the target supported? */
> -       switch (info->bus_token) {
> -#ifdef CONFIG_RISCV_IMSIC_PCI
> -       case DOMAIN_BUS_PCI_DEVICE_MSI:
> -       case DOMAIN_BUS_PCI_DEVICE_MSIX:
> -               info->chip->irq_mask =3D imsic_pci_mask_irq;
> -               info->chip->irq_unmask =3D imsic_pci_unmask_irq;
> -               break;
> -#endif
> -       case DOMAIN_BUS_DEVICE_MSI:
> -               /*
> -                * Per-device MSI should never have any MSI feature bits
> -                * set. It's sole purpose is to create a dumb interrupt
> -                * chip which has a device specific irq_write_msi_msg()
> -                * callback.
> -                */
> -               if (WARN_ON_ONCE(info->flags))
> -                       return false;
> -
> -               /* Core managed MSI descriptors */
> -               info->flags |=3D MSI_FLAG_ALLOC_SIMPLE_MSI_DESCS |
> -                              MSI_FLAG_FREE_MSI_DESCS;
> -               break;
> -       case DOMAIN_BUS_WIRED_TO_MSI:
> -               break;
> -       default:
> -               WARN_ON_ONCE(1);
> -               return false;
> -       }
> -
> -       /* Use hierarchial chip operations re-trigger */
> -       info->chip->irq_retrigger =3D irq_chip_retrigger_hierarchy;
> -
> -       /*
> -        * Mask out the domain specific MSI feature flags which are not
> -        * supported by the real parent.
> -        */
> -       info->flags &=3D pops->supported_flags;
> -
> -       /* Enforce the required flags */
> -       info->flags |=3D pops->required_flags;
> -
> -       return true;
> -}
> -
> -#define MATCH_PLATFORM_MSI             BIT(DOMAIN_BUS_PLATFORM_MSI)
> -
>  static const struct msi_parent_ops imsic_msi_parent_ops =3D {
>         .supported_flags        =3D MSI_GENERIC_FLAGS_MASK |
>                                   MSI_FLAG_PCI_MSIX,
>         .required_flags         =3D MSI_FLAG_USE_DEF_DOM_OPS |
> -                                 MSI_FLAG_USE_DEF_CHIP_OPS,
> +                                 MSI_FLAG_USE_DEF_CHIP_OPS |
> +                                 MSI_FLAG_PCI_MSI_MASK_PARENT,
>         .bus_select_token       =3D DOMAIN_BUS_NEXUS,
>         .bus_select_mask        =3D MATCH_PCI_MSI | MATCH_PLATFORM_MSI,
> -       .init_dev_msi_info      =3D imsic_init_dev_msi_info,
> +       .init_dev_msi_info      =3D msi_lib_init_dev_msi_info,
>  };
>
>  int imsic_irqdomain_init(void)
> --- a/include/linux/msi.h
> +++ b/include/linux/msi.h
> @@ -558,11 +558,21 @@ enum {
>         MSI_FLAG_NO_AFFINITY            =3D (1 << 21),
>  };
>
> +/*
> + * Flags for msi_parent_ops::chip_flags
> + */
> +enum {
> +       MSI_CHIP_FLAG_SET_EOI           =3D (1 << 0),
> +       MSI_CHIP_FLAG_SET_ACK           =3D (1 << 1),
> +};
> +
>  /**
>   * struct msi_parent_ops - MSI parent domain callbacks and configuration=
 info
>   *
>   * @supported_flags:   Required: The supported MSI flags of the parent d=
omain
>   * @required_flags:    Optional: The required MSI flags of the parent MS=
I domain
> + * @chip_flags:                Optional: Select MSI chip callbacks to up=
date with defaults
> + *                     in msi_lib_init_dev_msi_info().
>   * @bus_select_token:  Optional: The bus token of the real parent domain=
 for
>   *                     irq_domain::select()
>   * @bus_select_mask:   Optional: A mask of supported BUS_DOMAINs for
> @@ -575,6 +585,7 @@ enum {
>  struct msi_parent_ops {
>         u32             supported_flags;
>         u32             required_flags;
> +       u32             chip_flags;
>         u32             bus_select_token;
>         u32             bus_select_mask;
>         const char      *prefix;

