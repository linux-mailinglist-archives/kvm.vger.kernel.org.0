Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 407175FE958
	for <lists+kvm@lfdr.de>; Fri, 14 Oct 2022 09:17:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229775AbiJNHRk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 14 Oct 2022 03:17:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34336 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229684AbiJNHRi (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 14 Oct 2022 03:17:38 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 34645156248;
        Fri, 14 Oct 2022 00:17:37 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C003B619B5;
        Fri, 14 Oct 2022 07:17:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9574EC433C1;
        Fri, 14 Oct 2022 07:17:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1665731856;
        bh=0pPj5VQmg7ELN7p5cEQ7x+syOAOEDx0Lxdibop5z+kk=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=FcojzmZefS8zu+NZigI0OAPB+5ui5gdHtchmlxScbfbZCou4KlJV0m2KfPEItE33/
         Za21QFAD435y43xLzYtx5jHSOf/CE+gNLaXUJvP6nh+8/eiOZ+JzgtOBu7je5iMGVR
         5kq2fl8AvxEXRDlmeBntYzL2+xfEDeSEI2MQHsxA=
Date:   Fri, 14 Oct 2022 09:18:20 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Nipun Gupta <nipun.gupta@amd.com>
Cc:     robh+dt@kernel.org, krzysztof.kozlowski+dt@linaro.org,
        rafael@kernel.org, eric.auger@redhat.com,
        alex.williamson@redhat.com, cohuck@redhat.com,
        puneet.gupta@amd.com, song.bao.hua@hisilicon.com,
        mchehab+huawei@kernel.org, maz@kernel.org, f.fainelli@gmail.com,
        jeffrey.l.hugo@gmail.com, saravanak@google.com,
        Michael.Srba@seznam.cz, mani@kernel.org, yishaih@nvidia.com,
        jgg@ziepe.ca, jgg@nvidia.com, robin.murphy@arm.com,
        will@kernel.org, joro@8bytes.org, masahiroy@kernel.org,
        ndesaulniers@google.com, linux-arm-kernel@lists.infradead.org,
        linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org, kvm@vger.kernel.org, okaya@kernel.org,
        harpreet.anand@amd.com, nikhil.agarwal@amd.com,
        michal.simek@amd.com, aleksandar.radovanovic@amd.com, git@amd.com
Subject: Re: [RFC PATCH v4 2/8] bus/cdx: add the cdx bus driver
Message-ID: <Y0kNPHOjKiQ3XfqI@kroah.com>
References: <20220803122655.100254-1-nipun.gupta@amd.com>
 <20221014044049.2557085-1-nipun.gupta@amd.com>
 <20221014044049.2557085-3-nipun.gupta@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221014044049.2557085-3-nipun.gupta@amd.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Oct 14, 2022 at 10:10:43AM +0530, Nipun Gupta wrote:
> --- a/drivers/bus/Makefile
> +++ b/drivers/bus/Makefile
> @@ -20,6 +20,9 @@ obj-$(CONFIG_INTEL_IXP4XX_EB)	+= intel-ixp4xx-eb.o
>  obj-$(CONFIG_MIPS_CDMM)		+= mips_cdmm.o
>  obj-$(CONFIG_MVEBU_MBUS) 	+= mvebu-mbus.o
>  
> +#CDX bus

No need for a comment like this :)

> +obj-$(CONFIG_CDX_BUS)		+= cdx/
> +
>  # Interconnect bus driver for OMAP SoCs.
>  obj-$(CONFIG_OMAP_INTERCONNECT)	+= omap_l3_smx.o omap_l3_noc.o
>  
> diff --git a/drivers/bus/cdx/Kconfig b/drivers/bus/cdx/Kconfig
> new file mode 100644
> index 000000000000..98ec05ad708d
> --- /dev/null
> +++ b/drivers/bus/cdx/Kconfig
> @@ -0,0 +1,13 @@
> +# SPDX-License-Identifier: GPL-2.0
> +#
> +# CDX bus configuration
> +#
> +# Copyright (C) 2022, Advanced Micro Devices, Inc.
> +#
> +
> +config CDX_BUS
> +	bool "CDX Bus driver"
> +	help
> +		Driver to enable CDX Bus infrastructure. CDX bus uses
> +		CDX controller and firmware to scan the FPGA based
> +		devices.

Why bool?  Not as a module?  That's broken.

And "FPGA based devices" means nothing to me, please expand on what this
all is as it is not descriptive at all.

Also list the module name please.



> diff --git a/drivers/bus/cdx/Makefile b/drivers/bus/cdx/Makefile
> new file mode 100644
> index 000000000000..2e8f42611dfc
> --- /dev/null
> +++ b/drivers/bus/cdx/Makefile
> @@ -0,0 +1,8 @@
> +# SPDX-License-Identifier: GPL-2.0
> +#
> +# Makefile for CDX
> +#
> +# Copyright (C) 2022, Advanced Micro Devices, Inc.
> +#
> +
> +obj-$(CONFIG_CDX_BUS) += cdx.o
> diff --git a/drivers/bus/cdx/cdx.c b/drivers/bus/cdx/cdx.c
> new file mode 100644
> index 000000000000..5a366f4ae69c
> --- /dev/null
> +++ b/drivers/bus/cdx/cdx.c
> @@ -0,0 +1,366 @@
> +// SPDX-License-Identifier: GPL-2.0
> +/*
> + * CDX bus driver.
> + *
> + * Copyright (C) 2022, Advanced Micro Devices, Inc.
> + */
> +
> +/*
> + * Architecture Overview
> + * =====================
> + * CDX is a Hardware Architecture designed for AMD FPGA devices. It
> + * consists of sophisticated mechanism for interaction between FPGA,
> + * Firmware and the APUs (Application CPUs).
> + *
> + * Firmware resides on RPU (Realtime CPUs) which interacts with
> + * the FPGA program manager and the APUs. The RPU provides memory-mapped
> + * interface (RPU if) which is used to communicate with APUs.
> + *
> + * The diagram below shows an overview of the CDX architecture:
> + *
> + *          +--------------------------------------+
> + *          |    Application CPUs (APU)            |
> + *          |                                      |
> + *          |                    CDX device drivers|
> + *          |     Linux OS                |        |
> + *          |                        CDX bus       |
> + *          |                             |        |
> + *          |                     CDX controller   |
> + *          |                             |        |
> + *          +-----------------------------|--------+
> + *                                        | (discover, config,
> + *                                        |  reset, rescan)
> + *                                        |
> + *          +------------------------| RPU if |----+
> + *          |                             |        |
> + *          |                             V        |
> + *          |          Realtime CPUs (RPU)         |
> + *          |                                      |
> + *          +--------------------------------------+
> + *                                |
> + *          +---------------------|----------------+
> + *          |  FPGA               |                |
> + *          |      +-----------------------+       |
> + *          |      |           |           |       |
> + *          | +-------+    +-------+   +-------+   |
> + *          | | dev 1 |    | dev 2 |   | dev 3 |   |
> + *          | +-------+    +-------+   +-------+   |
> + *          +--------------------------------------+
> + *
> + * The RPU firmware extracts the device information from the loaded FPGA
> + * image and implements a mechanism that allows the APU drivers to
> + * enumerate such devices (device personality and resource details) via
> + * a dedicated communication channel. RPU mediates operations such as
> + * discover, reset and rescan of the FPGA devices for the APU. This is
> + * done using memory mapped interface provided by the RPU to APU.
> + */
> +
> +#include <linux/init.h>
> +#include <linux/kernel.h>
> +#include <linux/slab.h>
> +#include <linux/cdx/cdx_bus.h>
> +
> +#include "cdx.h"
> +
> +/*
> + * Default DMA mask for devices on a CDX bus
> + */
> +#define CDX_DEFAULT_DMA_MASK	(~0ULL)
> +
> +static struct cdx_controller_t *cdx_controller;

You don't get a static device, sorry, everything must be dynamic or your
design is broken.

And remove the crazy "_t" from your structure name, checkpatch should
have complained about that.



> +
> +static int reset_cdx_device(struct device *dev, void * __always_unused data)

__always_unused is never needed.

But the funny thing is, you added that variable, why are you not using
it?  If it's not used, then don't have it.

Try to get others at AMD to review your code first, before sending your
next batch out, this is really really odd...

greg k-h
