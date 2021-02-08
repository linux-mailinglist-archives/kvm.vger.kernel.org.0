Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 96D4E312B99
	for <lists+kvm@lfdr.de>; Mon,  8 Feb 2021 09:23:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229870AbhBHIWw (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 8 Feb 2021 03:22:52 -0500
Received: from mail.kernel.org ([198.145.29.99]:37732 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229766AbhBHIWd (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 8 Feb 2021 03:22:33 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0382464E7C;
        Mon,  8 Feb 2021 08:21:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1612772512;
        bh=Sc4SyiQNkQRCBMHLyFUuSu5h5GfleBywijQHNH8VGwY=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=uJALf7V4OHLbpIhOfAaIY+MW1DSl6gXscF6VMcBh40t2jSQt5+FY63KEiG5/CcOKn
         HwOtotob3s8s5mWKCjZ8R2yckWr0niOxr9yvGYFM5KRqUfmRhq7iDoNF7tNiQP1xkl
         5HW7Tnd4J9yiImoLgJX4gc0c99c6AdQtsHdEoJ0zVfKQWUbl4A3k5AhITSxeNBZSnM
         gAsDTp+NIMv3oSMlyWQOBSJQ7YQbEscsEdxxoCGM2zAlQcIv8mPFwxC13BuzX+1PCB
         w/lULHjroi+HVcAWeGxBZThE8Axw0VEbz2QG7NJrcIenkZ+KOSkqMRootvv6mLMg3u
         P/e9iMqmKYCBA==
Date:   Mon, 8 Feb 2021 10:21:48 +0200
From:   Leon Romanovsky <leon@kernel.org>
To:     Megha Dey <megha.dey@intel.com>
Cc:     tglx@linutronix.de, linux-kernel@vger.kernel.org,
        dave.jiang@intel.com, ashok.raj@intel.com, kevin.tian@intel.com,
        dwmw@amazon.co.uk, x86@kernel.org, tony.luck@intel.com,
        dan.j.williams@intel.com, jgg@mellanox.com, kvm@vger.kernel.org,
        iommu@lists.linux-foundation.org, alex.williamson@redhat.com,
        bhelgaas@google.com, maz@kernel.org, linux-pci@vger.kernel.org,
        baolu.lu@linux.intel.com, ravi.v.shankar@intel.com
Subject: Re: [PATCH 11/12] platform-msi: Add platform check for subdevice irq
 domain
Message-ID: <20210208082148.GA20265@unreal>
References: <1612385805-3412-1-git-send-email-megha.dey@intel.com>
 <1612385805-3412-12-git-send-email-megha.dey@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1612385805-3412-12-git-send-email-megha.dey@intel.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Feb 03, 2021 at 12:56:44PM -0800, Megha Dey wrote:
> From: Lu Baolu <baolu.lu@linux.intel.com>
>
> The pci_subdevice_msi_create_irq_domain() should fail if the underlying
> platform is not able to support IMS (Interrupt Message Storage). Otherwise,
> the isolation of interrupt is not guaranteed.
>
> For x86, IMS is only supported on bare metal for now. We could enable it
> in the virtualization environments in the future if interrupt HYPERCALL
> domain is supported or the hardware has the capability of interrupt
> isolation for subdevices.
>
> Cc: David Woodhouse <dwmw@amazon.co.uk>
> Cc: Leon Romanovsky <leon@kernel.org>
> Cc: Kevin Tian <kevin.tian@intel.com>
> Suggested-by: Thomas Gleixner <tglx@linutronix.de>
> Link: https://lore.kernel.org/linux-pci/87pn4nk7nn.fsf@nanos.tec.linutronix.de/
> Link: https://lore.kernel.org/linux-pci/877dqrnzr3.fsf@nanos.tec.linutronix.de/
> Link: https://lore.kernel.org/linux-pci/877dqqmc2h.fsf@nanos.tec.linutronix.de/
> Signed-off-by: Lu Baolu <baolu.lu@linux.intel.com>
> Signed-off-by: Megha Dey <megha.dey@intel.com>
> ---
>  arch/x86/pci/common.c       | 74 +++++++++++++++++++++++++++++++++++++++++++++
>  drivers/base/platform-msi.c |  8 +++++
>  include/linux/msi.h         |  1 +
>  3 files changed, 83 insertions(+)
>
> diff --git a/arch/x86/pci/common.c b/arch/x86/pci/common.c
> index 3507f45..263ccf6 100644
> --- a/arch/x86/pci/common.c
> +++ b/arch/x86/pci/common.c
> @@ -12,6 +12,8 @@
>  #include <linux/init.h>
>  #include <linux/dmi.h>
>  #include <linux/slab.h>
> +#include <linux/iommu.h>
> +#include <linux/msi.h>
>
>  #include <asm/acpi.h>
>  #include <asm/segment.h>
> @@ -724,3 +726,75 @@ struct pci_dev *pci_real_dma_dev(struct pci_dev *dev)
>  	return dev;
>  }
>  #endif
> +
> +#ifdef CONFIG_DEVICE_MSI

Sorry for my naive question, but I see it in all your patches in this series
and wonder why did you wrap everything with ifdefs?.

All *.c code is wrapped with those ifdefs, which is hard to navigate and
unlikely to give any code/size optimization benefit if kernel is compiled
without CONFIG_DEVICE_MSI. The more common approach is to put those
ifdef in the public header files and leave to the compiler to drop not
called functions.

Thanks
