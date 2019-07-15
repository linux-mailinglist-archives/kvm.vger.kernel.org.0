Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2B8B2696D1
	for <lists+kvm@lfdr.de>; Mon, 15 Jul 2019 17:07:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388498AbfGOPFo (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 15 Jul 2019 11:05:44 -0400
Received: from relay10.mail.gandi.net ([217.70.178.230]:49465 "EHLO
        relay10.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732946AbfGOPFn (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 15 Jul 2019 11:05:43 -0400
Received: from localhost (alyon-656-1-672-152.w92-137.abo.wanadoo.fr [92.137.69.152])
        (Authenticated sender: gregory.clement@bootlin.com)
        by relay10.mail.gandi.net (Postfix) with ESMTPSA id 9E46124000F;
        Mon, 15 Jul 2019 15:03:00 +0000 (UTC)
From:   Gregory CLEMENT <gregory.clement@bootlin.com>
To:     Auger Eric <eric.auger@redhat.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        Antoine Tenart <antoine.tenart@bootlin.com>,
        =?utf-8?Q?Miqu=C3=A8l?= Raynal <miquel.raynal@bootlin.com>,
        Maxime Chevallier <maxime.chevallier@bootlin.com>,
        Nadav Haklai <nadavh@marvell.com>
Subject: Re: [PATCH] vfio: platform: reset: add support for XHCI reset hook
In-Reply-To: <c152f211-0757-521e-64ea-543f6c89d9b2@redhat.com>
References: <20190711143159.21961-1-gregory.clement@bootlin.com> <c152f211-0757-521e-64ea-543f6c89d9b2@redhat.com>
Date:   Mon, 15 Jul 2019 17:03:00 +0200
Message-ID: <87d0ib732z.fsf@FE-laptop>
MIME-Version: 1.0
Content-Type: text/plain
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Eric,

> Hi Gregory,
>
> On 7/11/19 4:31 PM, Gregory CLEMENT wrote:
>> The VFIO reset hook is called every time a platform device is passed
>> to a guest or removed from a guest.
>> 
>> When the XHCI device is unbound from the host, the host driver
>> disables the XHCI clocks/phys/regulators so when the device is passed
>> to the guest it becomes dis-functional.
>> 
>> This initial implementation uses the VFIO reset hook to enable the
>> XHCI clocks/phys on behalf of the guest.
>
> the platform reset module must also make sure there are no more DMA
> requests and interrupts that can be sent by the device anymore.

OK I will take care of it too.


>> 
>> Ported from Marvell LSP code originally written by Yehuda Yitschak
>> 
>> Signed-off-by: Gregory CLEMENT <gregory.clement@bootlin.com>
>> ---
>>  drivers/vfio/platform/reset/Kconfig           |  8 +++
>>  drivers/vfio/platform/reset/Makefile          |  2 +
>>  .../vfio/platform/reset/vfio_platform_xhci.c  | 60 +++++++++++++++++++
>>  3 files changed, 70 insertions(+)
>>  create mode 100644 drivers/vfio/platform/reset/vfio_platform_xhci.c
>> 
>> diff --git a/drivers/vfio/platform/reset/Kconfig b/drivers/vfio/platform/reset/Kconfig
>> index 392e3c09def0..14f620fd250d 100644
>> --- a/drivers/vfio/platform/reset/Kconfig
>> +++ b/drivers/vfio/platform/reset/Kconfig
>> @@ -22,3 +22,11 @@ config VFIO_PLATFORM_BCMFLEXRM_RESET
>>  	  Enables the VFIO platform driver to handle reset for Broadcom FlexRM
>>  
>>  	  If you don't know what to do here, say N.
>> +
>> +config VFIO_PLATFORM_XHCI_RESET
>> +	tristate "VFIO support for USB XHCI reset"
>> +	depends on VFIO_PLATFORM
>> +	help
>> +	  Enables the VFIO platform driver to handle reset for USB XHCI
>> +
>> +	  If you don't know what to do here, say N.
>> diff --git a/drivers/vfio/platform/reset/Makefile b/drivers/vfio/platform/reset/Makefile
>> index 7294c5ea122e..d84c4d3dc041 100644
>> --- a/drivers/vfio/platform/reset/Makefile
>> +++ b/drivers/vfio/platform/reset/Makefile
>> @@ -1,7 +1,9 @@
>>  # SPDX-License-Identifier: GPL-2.0
>>  vfio-platform-calxedaxgmac-y := vfio_platform_calxedaxgmac.o
>>  vfio-platform-amdxgbe-y := vfio_platform_amdxgbe.o
>> +vfio-platform-xhci-y := vfio_platform_xhci.o
>>  
>>  obj-$(CONFIG_VFIO_PLATFORM_CALXEDAXGMAC_RESET) += vfio-platform-calxedaxgmac.o
>>  obj-$(CONFIG_VFIO_PLATFORM_AMDXGBE_RESET) += vfio-platform-amdxgbe.o
>>  obj-$(CONFIG_VFIO_PLATFORM_BCMFLEXRM_RESET) += vfio_platform_bcmflexrm.o
>> +obj-$(CONFIG_VFIO_PLATFORM_XHCI_RESET) += vfio-platform-xhci.o
>> diff --git a/drivers/vfio/platform/reset/vfio_platform_xhci.c b/drivers/vfio/platform/reset/vfio_platform_xhci.c
>> new file mode 100644
>> index 000000000000..7b75a04402ee
>> --- /dev/null
>> +++ b/drivers/vfio/platform/reset/vfio_platform_xhci.c
>> @@ -0,0 +1,60 @@
>> +// SPDX-License-Identifier: GPL-2.0-or-later
>> +/*
>> + * VFIO platform driver specialized for XHCI reset
>> + *
>> + * Copyright 2016 Marvell Semiconductors, Inc.
>> + *
>> + */
>> +
>> +#include <linux/clk.h>
>> +#include <linux/device.h>
>> +#include <linux/init.h>
>> +#include <linux/io.h>
>> +#include <linux/kernel.h>
> io, init, kernel should be removable (noticed init and kernel.h also are
> in other reset modules though)

OK

>> +#include <linux/module.h>
>> +#include <linux/of.h>
>> +#include <linux/phy/phy.h>
>> +#include <linux/usb/phy.h>
>> +
>> +#include "../vfio_platform_private.h"
>> +
>> +#define MAX_XHCI_CLOCKS		4
> Where does this number come from?
>
> From Documentation/devicetree/bindings/usb/usb-xhci.txt I understand
> there are max 2 clocks, "core" and "reg" (I don't have any specific
> knowledge on the device though).

Right, I guess the intent was to be future proof if there is more clocks
needed, but as we don't know, it's better to use the number of clokck we
know.

>
>> +#define MAX_XHCI_PHYS		2
> not used

Right!

>> +
>> +int vfio_platform_xhci_reset(struct vfio_platform_device *vdev)
>> +{
>> +	struct device *dev = vdev->device;
>> +	struct device_node *np = dev->of_node;
>> +	struct usb_phy *usb_phy;
>> +	struct clk *clk;
>> +	int ret, i;
>> +
>> +	/*
>> +	 * Compared to the native driver, no need to handle the
>> +	 * deferred case, because the resources are already
>> +	 * there
>> +	 */
>> +	for (i = 0; i < MAX_XHCI_CLOCKS; i++) {
>> +		clk = of_clk_get(np, i);
>> +		if (!IS_ERR(clk)) {
>> +			ret = clk_prepare_enable(clk);
>> +			if (ret)
>> +				return -ENODEV;
> return ret?

OK

>> +		}
>> +	}
>> +
>> +	usb_phy = devm_usb_get_phy_by_phandle(dev, "usb-phy", 0);
>> +	if (!IS_ERR(usb_phy)) {
>> +		ret = usb_phy_init(usb_phy);
>> +		if (ret)
>> +			return -ENODEV;
> return ret?

OK

Thanks,

Gregory

>> +	}
>
>> +
>> +	return 0;
>> +}
>> +
>> +module_vfio_reset_handler("generic-xhci", vfio_platform_xhci_reset);
>> +
>> +MODULE_AUTHOR("Yehuda Yitschak");
>> +MODULE_DESCRIPTION("Reset support for XHCI vfio platform device");
>> +MODULE_LICENSE("GPL");
>> 
> Thanks
>
> Eric

-- 
Gregory Clement, Bootlin
Embedded Linux and Kernel engineering
http://bootlin.com
