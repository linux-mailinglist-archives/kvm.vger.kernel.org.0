Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9BB75246DBC
	for <lists+kvm@lfdr.de>; Mon, 17 Aug 2020 19:12:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389357AbgHQRMG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 17 Aug 2020 13:12:06 -0400
Received: from mail.kernel.org ([198.145.29.99]:48680 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389308AbgHQRMB (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 17 Aug 2020 13:12:01 -0400
Received: from localhost (104.sub-72-107-126.myvzw.com [72.107.126.104])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C44AF2067C;
        Mon, 17 Aug 2020 17:12:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597684321;
        bh=BFKmMwm3OgowIDbWwU9+GxfmhcLKDlOgozUQDhUzMwE=;
        h=Date:From:To:Cc:Subject:In-Reply-To:From;
        b=I0l69/eVcqo9XoM5DNTMT2IHtJeSrEZ38TqHPaQ/MVg8ogXat9uYkR7vEL1h7hC/z
         4cLCk8F86byzwpWkE5mzd9DLMcDhX/pCeCX3FeDhyRFWxlZX5zhabrxqFjID+r4yxO
         t824qZlf+pcCGkc+eCBMReSoEY+74OYfzcbpY05c=
Date:   Mon, 17 Aug 2020 12:11:59 -0500
From:   Bjorn Helgaas <helgaas@kernel.org>
To:     Alex =?iso-8859-1?Q?Benn=E9e?= <alex.bennee@linaro.org>
Cc:     kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, kvmarm@lists.cs.columbia.edu,
        christoffer.dall@arm.com, maz@kernel.org,
        Robert Richter <rrichter@marvell.com>,
        linux-pci@vger.kernel.org
Subject: Re: [PATCH  v1 1/3] arm64: allow de-selection of ThunderX PCI
 controllers
Message-ID: <20200817171159.GA1426023@bjorn-Precision-5520>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20200804124417.27102-2-alex.bennee@linaro.org>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Aug 04, 2020 at 01:44:15PM +0100, Alex Bennée wrote:
> For a pure VirtIO guest bringing in all the PCI quirk handling adds a
> significant amount of bloat to kernel we don't need. Solve this by
> adding a CONFIG symbol for the ThunderX PCI devices and allowing it to
> be turned off. Saving over 300k from the uncompressed vmlinux:

It *looks* like just turning off CONFIG_PCI_QUIRKS should be
sufficient because pci-thunder-ecam.c and pci-thunder-pem.c are
wrapped with:

  #if defined(CONFIG_PCI_HOST_THUNDER_PEM) || (defined(CONFIG_ACPI) && defined(CONFIG_PCI_QUIRKS))

so if you turn off CONFIG_PCI_HOST_THUNDER_ECAM,
CONFIG_PCI_HOST_THUNDER_PEM, and CONFIG_PCI_QUIRKS that should omit
pci-thunder-ecam.o and pci-thunder-pem.o.  But I must be missing
something.

>   -rwxr-xr-x 1 alex alex  85652472 Aug  3 16:48 vmlinux*
>   -rwxr-xr-x 1 alex alex  86033880 Aug  3 16:39 vmlinux.orig*
> 
> Signed-off-by: Alex Bennée <alex.bennee@linaro.org>
> Cc: Robert Richter <rrichter@marvell.com>
> Cc: linux-pci@vger.kernel.org
> Cc: linux-arm-kernel@lists.infradead.org
> ---
>  arch/arm64/Kconfig.platforms    | 2 ++
>  arch/arm64/configs/defconfig    | 1 +
>  drivers/pci/controller/Kconfig  | 7 +++++++
>  drivers/pci/controller/Makefile | 4 ++--
>  4 files changed, 12 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/arm64/Kconfig.platforms b/arch/arm64/Kconfig.platforms
> index 8dd05b2a925c..a328eebdaa59 100644
> --- a/arch/arm64/Kconfig.platforms
> +++ b/arch/arm64/Kconfig.platforms
> @@ -253,12 +253,14 @@ config ARCH_SPRD
>  
>  config ARCH_THUNDER
>  	bool "Cavium Inc. Thunder SoC Family"
> +        select PCI_THUNDER
>  	help
>  	  This enables support for Cavium's Thunder Family of SoCs.
>  
>  config ARCH_THUNDER2
>  	bool "Cavium ThunderX2 Server Processors"
>  	select GPIOLIB
> +        select PCI_THUNDER

Indent these with tabs, not spaces, to be consistent with other
whitespace usage in this file.

>  	help
>  	  This enables support for Cavium's ThunderX2 CN99XX family of
>  	  server processors.
> diff --git a/arch/arm64/configs/defconfig b/arch/arm64/configs/defconfig
> index 2ca7ba69c318..d840cba99941 100644
> --- a/arch/arm64/configs/defconfig
> +++ b/arch/arm64/configs/defconfig
> @@ -199,6 +199,7 @@ CONFIG_PCI_HOST_GENERIC=y
>  CONFIG_PCI_XGENE=y
>  CONFIG_PCIE_ALTERA=y
>  CONFIG_PCIE_ALTERA_MSI=y
> +CONFIG_PCI_THUNDER=y
>  CONFIG_PCI_HOST_THUNDER_PEM=y
>  CONFIG_PCI_HOST_THUNDER_ECAM=y
>  CONFIG_PCIE_ROCKCHIP_HOST=m
> diff --git a/drivers/pci/controller/Kconfig b/drivers/pci/controller/Kconfig
> index adddf21fa381..28335ffa5d48 100644
> --- a/drivers/pci/controller/Kconfig
> +++ b/drivers/pci/controller/Kconfig
> @@ -286,6 +286,13 @@ config PCI_LOONGSON
>  	  Say Y here if you want to enable PCI controller support on
>  	  Loongson systems.
>  
> +config PCI_THUNDER
> +       bool "Thunder X PCIE controllers"
> +       depends on ARM64
> +       select PCI_QUIRKS
> +       help
> +          Say Y here to enable ThunderX ECAM and PEM PCI controllers.

Indent with tabs, not spaces.

The existing Kconfig help text refers to simply "Thunder", not
"Thunder X", so both of these references should probably follow suit.

s/PCIE controllers/PCIe controllers/

>  source "drivers/pci/controller/dwc/Kconfig"
>  source "drivers/pci/controller/mobiveil/Kconfig"
>  source "drivers/pci/controller/cadence/Kconfig"
> diff --git a/drivers/pci/controller/Makefile b/drivers/pci/controller/Makefile
> index efd9733ead26..8fad4781a5d3 100644
> --- a/drivers/pci/controller/Makefile
> +++ b/drivers/pci/controller/Makefile
> @@ -45,8 +45,8 @@ obj-y				+= mobiveil/
>  # ARM64 and use internal ifdefs to only build the pieces we need
>  # depending on whether ACPI, the DT driver, or both are enabled.
>  
> +obj-$(CONFIG_PCI_THUNDER) += pci-thunder-ecam.o
> +obj-$(CONFIG_PCI_THUNDER) += pci-thunder-pem.o
>  ifdef CONFIG_PCI
> -obj-$(CONFIG_ARM64) += pci-thunder-ecam.o
> -obj-$(CONFIG_ARM64) += pci-thunder-pem.o
>  obj-$(CONFIG_ARM64) += pci-xgene.o
>  endif
> -- 
> 2.20.1
> 
