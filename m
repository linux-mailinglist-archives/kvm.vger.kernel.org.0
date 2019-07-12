Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5409866768
	for <lists+kvm@lfdr.de>; Fri, 12 Jul 2019 09:03:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726127AbfGLHDk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 12 Jul 2019 03:03:40 -0400
Received: from mx1.redhat.com ([209.132.183.28]:55902 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725866AbfGLHDk (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 12 Jul 2019 03:03:40 -0400
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id E93A485543;
        Fri, 12 Jul 2019 07:03:39 +0000 (UTC)
Received: from [10.36.116.46] (ovpn-116-46.ams2.redhat.com [10.36.116.46])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 4939E5DDDC;
        Fri, 12 Jul 2019 07:03:35 +0000 (UTC)
From:   Auger Eric <eric.auger@redhat.com>
Subject: Re: [PATCH] vfio: platform: reset: add support for XHCI reset hook
To:     Gregory CLEMENT <gregory.clement@bootlin.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        Antoine Tenart <antoine.tenart@bootlin.com>,
        =?UTF-8?Q?Miqu=c3=a8l_Raynal?= <miquel.raynal@bootlin.com>,
        Maxime Chevallier <maxime.chevallier@bootlin.com>,
        Nadav Haklai <nadavh@marvell.com>
References: <20190711143159.21961-1-gregory.clement@bootlin.com>
Message-ID: <c152f211-0757-521e-64ea-543f6c89d9b2@redhat.com>
Date:   Fri, 12 Jul 2019 09:03:28 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.4.0
MIME-Version: 1.0
In-Reply-To: <20190711143159.21961-1-gregory.clement@bootlin.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.28]); Fri, 12 Jul 2019 07:03:40 +0000 (UTC)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Gregory,

On 7/11/19 4:31 PM, Gregory CLEMENT wrote:
> The VFIO reset hook is called every time a platform device is passed
> to a guest or removed from a guest.
> 
> When the XHCI device is unbound from the host, the host driver
> disables the XHCI clocks/phys/regulators so when the device is passed
> to the guest it becomes dis-functional.
> 
> This initial implementation uses the VFIO reset hook to enable the
> XHCI clocks/phys on behalf of the guest.

the platform reset module must also make sure there are no more DMA
requests and interrupts that can be sent by the device anymore.
> 
> Ported from Marvell LSP code originally written by Yehuda Yitschak
> 
> Signed-off-by: Gregory CLEMENT <gregory.clement@bootlin.com>
> ---
>  drivers/vfio/platform/reset/Kconfig           |  8 +++
>  drivers/vfio/platform/reset/Makefile          |  2 +
>  .../vfio/platform/reset/vfio_platform_xhci.c  | 60 +++++++++++++++++++
>  3 files changed, 70 insertions(+)
>  create mode 100644 drivers/vfio/platform/reset/vfio_platform_xhci.c
> 
> diff --git a/drivers/vfio/platform/reset/Kconfig b/drivers/vfio/platform/reset/Kconfig
> index 392e3c09def0..14f620fd250d 100644
> --- a/drivers/vfio/platform/reset/Kconfig
> +++ b/drivers/vfio/platform/reset/Kconfig
> @@ -22,3 +22,11 @@ config VFIO_PLATFORM_BCMFLEXRM_RESET
>  	  Enables the VFIO platform driver to handle reset for Broadcom FlexRM
>  
>  	  If you don't know what to do here, say N.
> +
> +config VFIO_PLATFORM_XHCI_RESET
> +	tristate "VFIO support for USB XHCI reset"
> +	depends on VFIO_PLATFORM
> +	help
> +	  Enables the VFIO platform driver to handle reset for USB XHCI
> +
> +	  If you don't know what to do here, say N.
> diff --git a/drivers/vfio/platform/reset/Makefile b/drivers/vfio/platform/reset/Makefile
> index 7294c5ea122e..d84c4d3dc041 100644
> --- a/drivers/vfio/platform/reset/Makefile
> +++ b/drivers/vfio/platform/reset/Makefile
> @@ -1,7 +1,9 @@
>  # SPDX-License-Identifier: GPL-2.0
>  vfio-platform-calxedaxgmac-y := vfio_platform_calxedaxgmac.o
>  vfio-platform-amdxgbe-y := vfio_platform_amdxgbe.o
> +vfio-platform-xhci-y := vfio_platform_xhci.o
>  
>  obj-$(CONFIG_VFIO_PLATFORM_CALXEDAXGMAC_RESET) += vfio-platform-calxedaxgmac.o
>  obj-$(CONFIG_VFIO_PLATFORM_AMDXGBE_RESET) += vfio-platform-amdxgbe.o
>  obj-$(CONFIG_VFIO_PLATFORM_BCMFLEXRM_RESET) += vfio_platform_bcmflexrm.o
> +obj-$(CONFIG_VFIO_PLATFORM_XHCI_RESET) += vfio-platform-xhci.o
> diff --git a/drivers/vfio/platform/reset/vfio_platform_xhci.c b/drivers/vfio/platform/reset/vfio_platform_xhci.c
> new file mode 100644
> index 000000000000..7b75a04402ee
> --- /dev/null
> +++ b/drivers/vfio/platform/reset/vfio_platform_xhci.c
> @@ -0,0 +1,60 @@
> +// SPDX-License-Identifier: GPL-2.0-or-later
> +/*
> + * VFIO platform driver specialized for XHCI reset
> + *
> + * Copyright 2016 Marvell Semiconductors, Inc.
> + *
> + */
> +
> +#include <linux/clk.h>
> +#include <linux/device.h>
> +#include <linux/init.h>
> +#include <linux/io.h>
> +#include <linux/kernel.h>
io, init, kernel should be removable (noticed init and kernel.h also are
in other reset modules though)
> +#include <linux/module.h>
> +#include <linux/of.h>
> +#include <linux/phy/phy.h>
> +#include <linux/usb/phy.h>
> +
> +#include "../vfio_platform_private.h"
> +
> +#define MAX_XHCI_CLOCKS		4
Where does this number come from?

From Documentation/devicetree/bindings/usb/usb-xhci.txt I understand
there are max 2 clocks, "core" and "reg" (I don't have any specific
knowledge on the device though).

> +#define MAX_XHCI_PHYS		2
not used
> +
> +int vfio_platform_xhci_reset(struct vfio_platform_device *vdev)
> +{
> +	struct device *dev = vdev->device;
> +	struct device_node *np = dev->of_node;
> +	struct usb_phy *usb_phy;
> +	struct clk *clk;
> +	int ret, i;
> +
> +	/*
> +	 * Compared to the native driver, no need to handle the
> +	 * deferred case, because the resources are already
> +	 * there
> +	 */
> +	for (i = 0; i < MAX_XHCI_CLOCKS; i++) {
> +		clk = of_clk_get(np, i);
> +		if (!IS_ERR(clk)) {
> +			ret = clk_prepare_enable(clk);
> +			if (ret)
> +				return -ENODEV;
return ret?
> +		}
> +	}
> +
> +	usb_phy = devm_usb_get_phy_by_phandle(dev, "usb-phy", 0);
> +	if (!IS_ERR(usb_phy)) {
> +		ret = usb_phy_init(usb_phy);
> +		if (ret)
> +			return -ENODEV;
return ret?
> +	}

> +
> +	return 0;
> +}
> +
> +module_vfio_reset_handler("generic-xhci", vfio_platform_xhci_reset);
> +
> +MODULE_AUTHOR("Yehuda Yitschak");
> +MODULE_DESCRIPTION("Reset support for XHCI vfio platform device");
> +MODULE_LICENSE("GPL");
> 
Thanks

Eric
