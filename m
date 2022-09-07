Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9F5835B0C2B
	for <lists+kvm@lfdr.de>; Wed,  7 Sep 2022 20:07:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230143AbiIGSHc (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 7 Sep 2022 14:07:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35944 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229619AbiIGSHX (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 7 Sep 2022 14:07:23 -0400
Received: from mail-yw1-x1133.google.com (mail-yw1-x1133.google.com [IPv6:2607:f8b0:4864:20::1133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8927F186F5
        for <kvm@vger.kernel.org>; Wed,  7 Sep 2022 11:07:20 -0700 (PDT)
Received: by mail-yw1-x1133.google.com with SMTP id 00721157ae682-3454e58fe53so79999157b3.2
        for <kvm@vger.kernel.org>; Wed, 07 Sep 2022 11:07:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date;
        bh=Q0vTK06IR+ZL8EpAGvEa/budrk9KX1y8VgjrRzMvDsc=;
        b=DIIfWiE1wRs0xyWH7ZtajFeRbD1Al35nYTx1/182nv9/NrQ7suZwD0SjziB7tEsaK5
         QYvwFPwRfPLoxuJGtQDpJ3ycupQNfUwRB/dnGV6xSzbJMMAC6n4KzA+U+uFXWwnNb9X3
         kOlbem0IBb6/+HapJhSmuhFldCZERHwb7b2L7Bm7JGtMhWsKeaSwpyGVsTJnXE2uHzmS
         H5ziAua33RqJRRNWNDq4eLv9YFymf5htMueHK/+JLtTGcTPT+gZCLXkevNcUJU31RhwE
         SQU2HjJUrvNw7ynNEH4dpy4KbumwkE5iI7qrK+KseikPBhGobMuLzHZngXMlpsRp69SZ
         5o2Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date;
        bh=Q0vTK06IR+ZL8EpAGvEa/budrk9KX1y8VgjrRzMvDsc=;
        b=1RAGqUTUcQrt5Iynj+UOvXGvSxL49oRUAhkCEVsg9Ew/IF1VcSkQLaDXpIgtI466J5
         z9/UlToF9leszEFF2Bb49Q6y3ZQaHisess47dSCTUyKj4pepVKqpV/SPbRwp3PgO7Y/A
         MjXEG/6zJJGGyoG35sX581GpbGmI3fFYv5MxoOcVxoebQYMKbu4FLAJ4pa3w3I0HqGrm
         bHPLggIYhjwF8CGjTUrbS7xXLMTPUdXdz3IEMeRoj8AkuGRRJxmVYZ2FiumGidspdTrj
         hJTQCtTwhKbt4OT6XcujoOkgVBv5DIeU+68HVG9v7oqA8zTAzk92+lozlO5KWZNWbTrs
         Xo5Q==
X-Gm-Message-State: ACgBeo0pVvGn2WZAZx36NaKMD1CaUvNkp9PLq36PoAF4ABzafHyMkOSX
        wHG558HPBfvubMzP848qBg953dcUoc5cl4kLoCo8SA==
X-Google-Smtp-Source: AA6agR6gdCESeEdQPUbCb86Ddepa+Tj79XAXMB+2Er966ZkfYA3xeKaGcba336w+UOMFe1SRRvauH1Y84icNcf3h2cU=
X-Received: by 2002:a81:4a84:0:b0:345:ace:699d with SMTP id
 x126-20020a814a84000000b003450ace699dmr4404896ywa.126.1662574039506; Wed, 07
 Sep 2022 11:07:19 -0700 (PDT)
MIME-Version: 1.0
References: <20220803122655.100254-1-nipun.gupta@amd.com> <20220906134801.4079497-1-nipun.gupta@amd.com>
 <20220906134801.4079497-3-nipun.gupta@amd.com> <CAGETcx8d8ZpuEC2Uqrzw-We21goC8EZR=6J-6YZBjruw=QKdHg@mail.gmail.com>
 <DM6PR12MB3082418E55B09054ED71CD6CE8419@DM6PR12MB3082.namprd12.prod.outlook.com>
In-Reply-To: <DM6PR12MB3082418E55B09054ED71CD6CE8419@DM6PR12MB3082.namprd12.prod.outlook.com>
From:   Saravana Kannan <saravanak@google.com>
Date:   Wed, 7 Sep 2022 11:06:43 -0700
Message-ID: <CAGETcx__da82amhYAkuBGQQ0y0_UxYvUYiDBXm-N5s6FpCC0hQ@mail.gmail.com>
Subject: Re: [RFC PATCH v3 2/7] bus/cdx: add the cdx bus driver
To:     "Gupta, Nipun" <Nipun.Gupta@amd.com>
Cc:     "robh+dt@kernel.org" <robh+dt@kernel.org>,
        "krzysztof.kozlowski+dt@linaro.org" 
        <krzysztof.kozlowski+dt@linaro.org>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "rafael@kernel.org" <rafael@kernel.org>,
        "eric.auger@redhat.com" <eric.auger@redhat.com>,
        "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
        "cohuck@redhat.com" <cohuck@redhat.com>,
        "Gupta, Puneet (DCG-ENG)" <puneet.gupta@amd.com>,
        "song.bao.hua@hisilicon.com" <song.bao.hua@hisilicon.com>,
        "mchehab+huawei@kernel.org" <mchehab+huawei@kernel.org>,
        "maz@kernel.org" <maz@kernel.org>,
        "f.fainelli@gmail.com" <f.fainelli@gmail.com>,
        "jeffrey.l.hugo@gmail.com" <jeffrey.l.hugo@gmail.com>,
        "Michael.Srba@seznam.cz" <Michael.Srba@seznam.cz>,
        "mani@kernel.org" <mani@kernel.org>,
        "yishaih@nvidia.com" <yishaih@nvidia.com>,
        "jgg@ziepe.ca" <jgg@ziepe.ca>, "jgg@nvidia.com" <jgg@nvidia.com>,
        "robin.murphy@arm.com" <robin.murphy@arm.com>,
        "will@kernel.org" <will@kernel.org>,
        "joro@8bytes.org" <joro@8bytes.org>,
        "masahiroy@kernel.org" <masahiroy@kernel.org>,
        "ndesaulniers@google.com" <ndesaulniers@google.com>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        "linux-kbuild@vger.kernel.org" <linux-kbuild@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "okaya@kernel.org" <okaya@kernel.org>,
        "Anand, Harpreet" <harpreet.anand@amd.com>,
        "Agarwal, Nikhil" <nikhil.agarwal@amd.com>,
        "Simek, Michal" <michal.simek@amd.com>,
        "Radovanovic, Aleksandar" <aleksandar.radovanovic@amd.com>,
        "git (AMD-Xilinx)" <git@amd.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Sep 6, 2022 at 8:21 PM Gupta, Nipun <Nipun.Gupta@amd.com> wrote:
>
> [AMD Official Use Only - General]
>
>
>
> > -----Original Message-----
> > From: Saravana Kannan <saravanak@google.com>
> > Sent: Wednesday, September 7, 2022 6:03 AM
> > To: Gupta, Nipun <Nipun.Gupta@amd.com>
> > Cc: robh+dt@kernel.org; krzysztof.kozlowski+dt@linaro.org;
> > gregkh@linuxfoundation.org; rafael@kernel.org; eric.auger@redhat.com;
> > alex.williamson@redhat.com; cohuck@redhat.com; Gupta, Puneet (DCG-ENG)
> > <puneet.gupta@amd.com>; song.bao.hua@hisilicon.com;
> > mchehab+huawei@kernel.org; maz@kernel.org; f.fainelli@gmail.com;
> > jeffrey.l.hugo@gmail.com; Michael.Srba@seznam.cz; mani@kernel.org;
> > yishaih@nvidia.com; jgg@ziepe.ca; jgg@nvidia.com; robin.murphy@arm.com;
> > will@kernel.org; joro@8bytes.org; masahiroy@kernel.org;
> > ndesaulniers@google.com; linux-arm-kernel@lists.infradead.org; linux-
> > kbuild@vger.kernel.org; linux-kernel@vger.kernel.org;
> > devicetree@vger.kernel.org; kvm@vger.kernel.org; okaya@kernel.org; Anand,
> > Harpreet <harpreet.anand@amd.com>; Agarwal, Nikhil
> > <nikhil.agarwal@amd.com>; Simek, Michal <michal.simek@amd.com>;
> > Radovanovic, Aleksandar <aleksandar.radovanovic@amd.com>; git (AMD-Xilinx)
> > <git@amd.com>
> > Subject: Re: [RFC PATCH v3 2/7] bus/cdx: add the cdx bus driver
> >
> > [CAUTION: External Email]
> >
> > On Tue, Sep 6, 2022 at 6:48 AM Nipun Gupta <nipun.gupta@amd.com> wrote:
> > >
> > > CDX bus supports the scanning and probing of FPGA based
> > > devices. These devices are registers as CDX devices.
> > >
> > > The bus driver sets up the basic infrastructure and fetches
> > > the device related information from the firmware.
> > >
> > > CDX bus is capable of scanning devices dynamically,
> > > supporting rescanning of dynamically added, removed or
> > > updated devices.
> > >
> > > Signed-off-by: Nipun Gupta <nipun.gupta@amd.com>
> > > ---
> > >
> > > Basic overview of CDX bus architecture is provided in [patch 0/7].
> > >
> > > Please NOTE: This RFC change does not support the CDX bus firmware
> > > interface as it is under development, and this series aims to get
> > > an early feedback from the community. Firmware interaction are
> > > stubbed as MCDI APIs which is a protocol used by AMD to interact
> > > with Firmware.
> > >
> > >  MAINTAINERS                       |   2 +
> > >  drivers/bus/Kconfig               |   1 +
> > >  drivers/bus/Makefile              |   3 +
> > >  drivers/bus/cdx/Kconfig           |   7 +
> > >  drivers/bus/cdx/Makefile          |   3 +
> > >  drivers/bus/cdx/cdx.c             | 437 ++++++++++++++++++++++++++++++
> > >  drivers/bus/cdx/cdx.h             |  34 +++
> > >  drivers/bus/cdx/mcdi_stubs.c      |  54 ++++
> > >  drivers/bus/cdx/mcdi_stubs.h      |  76 ++++++
> > >  include/linux/cdx/cdx_bus.h       |  93 +++++++
> > >  include/linux/mod_devicetable.h   |  13 +
> > >  scripts/mod/devicetable-offsets.c |   4 +
> > >  scripts/mod/file2alias.c          |  12 +
> > >  13 files changed, 739 insertions(+)
> > >  create mode 100644 drivers/bus/cdx/Kconfig
> > >  create mode 100644 drivers/bus/cdx/Makefile
> > >  create mode 100644 drivers/bus/cdx/cdx.c
> > >  create mode 100644 drivers/bus/cdx/cdx.h
> > >  create mode 100644 drivers/bus/cdx/mcdi_stubs.c
> > >  create mode 100644 drivers/bus/cdx/mcdi_stubs.h
> > >  create mode 100644 include/linux/cdx/cdx_bus.h
> > >
>
> <snip>
>
> > > +
> > > +static int cdx_device_add(struct device *parent,
> > > +                         struct cdx_dev_params_t *dev_params)
> > > +{
> > > +       struct cdx_device *cdx_dev;
> > > +       int ret;
> > > +
> > > +       cdx_dev = kzalloc(sizeof(*cdx_dev), GFP_KERNEL);
> > > +       if (!cdx_dev) {
> > > +               dev_err(parent,
> > > +                       "memory allocation for cdx dev failed\n");
> > > +               return -ENOMEM;
> > > +       }
> > > +
> > > +       /* Populate resource */
> > > +       memcpy(cdx_dev->res, dev_params->res, sizeof(struct resource) *
> > > +               dev_params->res_count);
> > > +       cdx_dev->res_count = dev_params->res_count;
> > > +
> > > +       /* Populate CDX dev params */
> > > +       cdx_dev->req_id = dev_params->req_id;
> > > +       cdx_dev->vendor = dev_params->vendor;
> > > +       cdx_dev->device = dev_params->device;
> > > +       cdx_dev->bus_id = dev_params->bus_id;
> > > +       cdx_dev->func_id = dev_params->func_id;
> > > +       cdx_dev->dma_mask = CDX_DEFAULT_DMA_MASK;
> > > +
> > > +       /* Initiaize generic device */
> > > +       device_initialize(&cdx_dev->dev);
> > > +       cdx_dev->dev.parent = parent;
> > > +       cdx_dev->dev.bus = &cdx_bus_type;
> > > +       cdx_dev->dev.dma_mask = &cdx_dev->dma_mask;
> > > +       cdx_dev->dev.release = cdx_device_release;
> >
> > How will these devices get resources like clocks, regulators, etc that
> > might be provided by other DT based devices? Is that not possible?
> >
> > I also see that v2 of this series has a "swnode" implementation that
> > was used to set the fwnode of these CDX devices. Why are these devices
> > no longer getting the fwnode set? Also, swnode doesn't have support
> > for the fwnode.add_links() ops. It also doesn't seem to support the
> > parent of a swnode being another fwnode of a different type (DT). I'm
> > not sure about the history behind that, but maybe swnode is not the
> > right fit or you might need to add support for these to swnode. All of
> > this is to say that if you set these things up correctly, fw_devlink
> > can work for CDX devices and that might be helpful.
>
> In the RFC v2 we were trying to use the platform bus for CDX devices,
> and in that implementation sw_node was used, but now we understand
> that using platform bus for dynamic devices is not a good approach.

Whether you use platform bus or not shouldn't have any impact on where
the device has a fwnode or not.

> So, changes in RFC v3 are to have a CDX bus for CDX devices.

This doesn't answer most of my questions though. Can you answer them please?

-Saravana

>
> Regards,
> Nipun
>
> >
> > -Saravana
> > > +
> > > +       /* Set Name */
> > > +       dev_set_name(&cdx_dev->dev, "cdx-%02x:%02x", cdx_dev->bus_id,
> > > +                       cdx_dev->func_id);
> > > +
> > > +       ret = device_add(&cdx_dev->dev);
> > > +       if (ret != 0) {
> > > +               dev_err(&cdx_dev->dev,
> > > +                       "cdx device add failed: %d", ret);
> > > +               goto fail;
> > > +       }
> > > +
> > > +       return 0;
> > > +
> > > +fail:
> > > +       /*
> > > +        * Do not free cdx_dev here as it would be freed in
> > > +        * cdx_device_release() called from within put_device().
> > > +        */
> > > +       put_device(&cdx_dev->dev);
> > > +
> > > +       return ret;
> > > +}
> > > +
> > > +static int cdx_bus_device_discovery(struct platform_device *pdev)
> > > +{
> > > +       struct cdx_mcdi_t *cdx_mcdi = platform_get_drvdata(pdev);
> > > +       int num_cdx_bus, num_cdx_func;
> > > +       uint8_t bus_id, func_id;
> > > +       int ret;
> > > +
> > > +       cdx_controller_pdev = pdev;
> > > +
> > > +       /* MCDI FW Read: Fetch the number of CDX buses present*/
> > > +       num_cdx_bus = cdx_mcdi_get_num_buses(cdx_mcdi);
> > > +
> > > +       for (bus_id = 0; bus_id < num_cdx_bus; bus_id++) {
> > > +               /* MCDI FW Read: Fetch the number of devices present */
> > > +               num_cdx_func = cdx_mcdi_get_num_funcs(cdx_mcdi, bus_id);
> > > +
> > > +               for (func_id = 0; func_id < num_cdx_func; func_id++) {
> > > +                       struct cdx_dev_params_t dev_params;
> > > +
> > > +                       /* MCDI FW: Get the device config */
> > > +                       ret = cdx_mcdi_get_func_config(cdx_mcdi, bus_id,
> > > +                                       func_id, &dev_params);
> > > +                       if (ret) {
> > > +                               dev_err(&pdev->dev,
> > > +                                       "CDX device config get failed for bus: %d\n",
> > > +                                       ret);
> > > +                               goto fail;
> > > +                       }
> > > +
> > > +                       /* Add the device to the cdx bus */
> > > +                       ret = cdx_device_add(&pdev->dev, &dev_params);
> > > +                       if (ret == -EPROBE_DEFER) {
> > > +                               goto fail;
> > > +                       } else if (ret) {
> > > +                               dev_err(&pdev->dev,
> > > +                                       "registering cdx dev: %d failed: %d\n",
> > > +                                       func_id, ret);
> > > +                               goto fail;
> > > +                       } else {
> > > +                               dev_dbg(&pdev->dev,
> > > +                                       "CDX dev: %d on cdx bus: %d created\n",
> > > +                                       func_id, bus_id);
> > > +                       }
> > > +               }
> > > +       }
> > > +
> > > +       return 0;
> > > +fail:
> > > +       cdx_unregister_devices(&cdx_bus_type);
> > > +       return ret;
> > > +}
> > > +
> > > +static int cdx_bus_probe(struct platform_device *pdev)
> > > +{
> > > +       struct cdx_mcdi_t *cdx_mcdi;
> > > +       int ret;
> > > +
> > > +       cdx_mcdi = kzalloc(sizeof(*cdx_mcdi), GFP_KERNEL);
> > > +       if (!cdx_mcdi) {
> > > +               dev_err(&pdev->dev, "Failed to allocate memory for cdx_mcdi\n");
> > > +               return -ENOMEM;
> > > +       }
> > > +
> > > +       /* MCDI FW: Initialize the FW path */
> > > +       ret = cdx_mcdi_init(cdx_mcdi);
> > > +       if (ret) {
> > > +               dev_err(&pdev->dev, "MCDI Initialization failed: %d\n", ret);
> > > +               goto mcdi_init_fail;
> > > +       }
> > > +       platform_set_drvdata(pdev, cdx_mcdi);
> > > +
> > > +       /* Discover all the devices on the bus */
> > > +       ret = cdx_bus_device_discovery(pdev);
> > > +       if (ret) {
> > > +               dev_err(&pdev->dev,
> > > +                       "CDX bus device discovery failed: %d\n", ret);
> > > +               goto device_discovery_fail;
> > > +       }
> > > +
> > > +       return 0;
> > > +
> > > +mcdi_init_fail:
> > > +       kfree(cdx_mcdi);
> > > +device_discovery_fail:
> > > +       cdx_mcdi_finish(cdx_mcdi);
> > > +
> > > +       return ret;
> > > +}
> > > +
> > > +static int cdx_bus_remove(struct platform_device *pdev)
> > > +{
> > > +       struct cdx_mcdi_t *cdx_mcdi = platform_get_drvdata(pdev);
> > > +
> > > +       cdx_unregister_devices(&cdx_bus_type);
> > > +
> > > +       cdx_mcdi_finish(cdx_mcdi);
> > > +       kfree(cdx_mcdi);
> > > +
> > > +       return 0;
> > > +}
> > > +
> > > +static void cdx_bus_shutdown(struct platform_device *pdev)
> > > +{
> > > +       cdx_bus_remove(pdev);
> > > +}
> > > +
> > > +static const struct of_device_id cdx_match_table[] = {
> > > +       {.compatible = "xlnx,cdxbus-controller-1.0",},
> > > +       { },
> > > +};
> > > +
> > > +MODULE_DEVICE_TABLE(of, cdx_match_table);
> > > +
> > > +static struct platform_driver cdx_bus_driver = {
> > > +       .driver = {
> > > +                  .name = "cdx-bus",
> > > +                  .pm = NULL,
> > > +                  .of_match_table = cdx_match_table,
> > > +                  },
> > > +       .probe = cdx_bus_probe,
> > > +       .remove = cdx_bus_remove,
> > > +       .shutdown = cdx_bus_shutdown,
> > > +};
> > > +
> > > +static int __init cdx_bus_driver_init(void)
> > > +{
> > > +       int ret;
> > > +
> > > +       ret = bus_register(&cdx_bus_type);
> > > +       if (ret < 0) {
> > > +               pr_err("bus type registration failed for CDX: %d\n", ret);
> > > +               return ret;
> > > +       }
> > > +
> > > +       ret = platform_driver_register(&cdx_bus_driver);
> > > +       if (ret < 0) {
> > > +               pr_err("platform_driver_register() failed: %d\n", ret);
> > > +               goto fail;
> > > +       }
> > > +
> > > +       return 0;
> > > +
> > > +fail:
> > > +       bus_unregister(&cdx_bus_type);
> > > +       return ret;
> > > +}
> > > +postcore_initcall(cdx_bus_driver_init);
> > > diff --git a/drivers/bus/cdx/cdx.h b/drivers/bus/cdx/cdx.h
> > > new file mode 100644
> > > index 000000000000..db0569431c10
> > > --- /dev/null
> > > +++ b/drivers/bus/cdx/cdx.h
> > > @@ -0,0 +1,34 @@
> > > +// SPDX-License-Identifier: GPL-2.0
> > > +/*
> > > + * Header file for the CDX Bus
> > > + *
> > > + * Copyright (C) 2022, Advanced Micro Devices, Inc.
> > > + */
> > > +
> > > +#ifndef _CDX_H_
> > > +#define _CDX_H_
> > > +
> > > +#include <linux/cdx/cdx_bus.h>
> > > +#include <linux/irqdomain.h>
> > > +
> > > +/**
> > > + * struct cdx_dev_params_t - CDX device parameters
> > > + * @vendor: Vendor ID for CDX device
> > > + * @device: Device ID for CDX device
> > > + * @bus_id: Bus ID for this CDX device
> > > + * @func_id: Function ID for this device
> > > + * @res: array of MMIO region entries
> > > + * @res_count: number of valid MMIO regions
> > > + * @req_id: Requestor ID associated with CDX device
> > > + */
> > > +struct cdx_dev_params_t {
> > > +       u16 vendor;
> > > +       u16 device;
> > > +       u8 bus_id;
> > > +       u8 func_id;
> > > +       struct resource res[MAX_CDX_DEV_RESOURCES];
> > > +       u8 res_count;
> > > +       u32 req_id;
> > > +};
> > > +
> > > +#endif /* _CDX_H_ */
> > > diff --git a/drivers/bus/cdx/mcdi_stubs.c b/drivers/bus/cdx/mcdi_stubs.c
> > > new file mode 100644
> > > index 000000000000..cc9d30fa02f8
> > > --- /dev/null
> > > +++ b/drivers/bus/cdx/mcdi_stubs.c
> > > @@ -0,0 +1,54 @@
> > > +// SPDX-License-Identifier: GPL-2.0
> > > +/*
> > > + * MCDI Firmware interaction for CDX bus.
> > > + *
> > > + * Copyright (C) 2022, Advanced Micro Devices, Inc.
> > > + */
> > > +
> > > +#include <linux/ioport.h>
> > > +
> > > +#include "cdx.h"
> > > +#include "mcdi_stubs.h"
> > > +
> > > +int cdx_mcdi_init(struct cdx_mcdi_t *cdx_mcdi)
> > > +{
> > > +       cdx_mcdi->id = 0;
> > > +       cdx_mcdi->flags = 0;
> > > +
> > > +       return 0;
> > > +}
> > > +
> > > +void cdx_mcdi_finish(struct cdx_mcdi_t *cdx_mcdi)
> > > +{
> > > +}
> > > +
> > > +int cdx_mcdi_get_num_buses(struct cdx_mcdi_t *cdx_mcdi)
> > > +{
> > > +       return 1;
> > > +}
> > > +
> > > +int cdx_mcdi_get_num_funcs(struct cdx_mcdi_t *cdx_mcdi, int bus_num)
> > > +{
> > > +       return 1;
> > > +}
> > > +
> > > +int cdx_mcdi_get_func_config(struct cdx_mcdi_t *cdx_mcdi,
> > > +                            uint8_t bus_id, uint8_t func_id,
> > > +                            struct cdx_dev_params_t *dev_params)
> > > +{
> > > +       dev_params->res[0].start = 0xe4020000;
> > > +       dev_params->res[0].end = 0xe4020FFF;
> > > +       dev_params->res[0].flags = IORESOURCE_MEM;
> > > +       dev_params->res[1].start = 0xe4100000;
> > > +       dev_params->res[1].end = 0xE411FFFF;
> > > +       dev_params->res[1].flags = IORESOURCE_MEM;
> > > +       dev_params->res_count = 2;
> > > +
> > > +       dev_params->req_id = 0x250;
> > > +       dev_params->vendor = 0x10ee;
> > > +       dev_params->device = 0x8084;
> > > +       dev_params->bus_id = bus_id;
> > > +       dev_params->func_id = func_id;
> > > +
> > > +       return 0;
> > > +}
> > > diff --git a/drivers/bus/cdx/mcdi_stubs.h b/drivers/bus/cdx/mcdi_stubs.h
> > > new file mode 100644
> > > index 000000000000..7b6f79d48ce9
> > > --- /dev/null
> > > +++ b/drivers/bus/cdx/mcdi_stubs.h
> > > @@ -0,0 +1,76 @@
> > > +// SPDX-License-Identifier: GPL-2.0
> > > +/*
> > > + * Header file for MCDI FW interaction for CDX bus.
> > > + *
> > > + * Copyright (C) 2022, Advanced Micro Devices, Inc.
> > > + */
> > > +
> > > +#ifndef _MCDI_STUBS_H_
> > > +#define _MCDI_STUBS_H_
> > > +
> > > +#include "cdx.h"
> > > +
> > > +/**
> > > + * struct cdx_mcdi_t - CDX MCDI Firmware interface, to interact
> > > + *                    with CDX controller.
> > > + * @id: ID for MCDI Firmware interface
> > > + * @flags: Associated flags
> > > + */
> > > +struct cdx_mcdi_t {
> > > +       u32 id;
> > > +       u32 flags;
> > > +       /* Have more MCDI interface related data */
> > > +};
> > > +
> > > +/**
> > > + * cdx_mcdi_init - Initialize the MCDI Firmware interface
> > > + *     for the CDX controller.
> > > + * @cdx_mcdi: pointer to MCDI interface
> > > + *
> > > + * Return 0 on success, <0 on failure
> > > + */
> > > +int cdx_mcdi_init(struct cdx_mcdi_t *cdx_mcdi);
> > > +
> > > +/**
> > > + * cdx_mcdi_finish - Close the MCDI Firmware interface.
> > > + * @cdx_mcdi: pointer to MCDI interface
> > > + */
> > > +void cdx_mcdi_finish(struct cdx_mcdi_t *cdx_mcdi);
> > > +
> > > +/**
> > > + * cdx_mcdi_get_num_buses - Get the total number of busses on
> > > + *     the controller.
> > > + * @cdx_mcdi: pointer to MCDI interface.
> > > + *
> > > + * Return total number of busses available on the controller,
> > > + *     <0 on failure
> > > + */
> > > +int cdx_mcdi_get_num_buses(struct cdx_mcdi_t *cdx_mcdi);
> > > +
> > > +/**
> > > + * cdx_mcdi_get_num_funcs - Get the total number of functions on
> > > + *     a particular bus of the controller.
> > > + * @cdx_mcdi: pointer to MCDI interface.
> > > + * @bus_num: Bus number.
> > > + *
> > > + * Return total number of functions available on the bus, <0 on failure
> > > + */
> > > +int cdx_mcdi_get_num_funcs(struct cdx_mcdi_t *cdx_mcdi, int bus_num);
> > > +
> > > +/**
> > > + * cdx_mcdi_get_func_config - Get configuration for a particular
> > > + *     bus_id:func_id
> > > + * @cdx_mcdi: pointer to MCDI interface.
> > > + * @bus_num: Bus number.
> > > + * @func_id: Function number.
> > > + * @dev_params: Pointer to cdx_dev_params_t, this is populated by this
> > > + *     function with the configuration corresponding to the provided
> > > + *     bus_id:func_id.
> > > + *
> > > + * Return 0 total number of functions available on the bus, <0 on failure
> > > + */
> > > +int cdx_mcdi_get_func_config(struct cdx_mcdi_t *cdx_mcdi,
> > > +                            uint8_t bus_id, uint8_t func_id,
> > > +                            struct cdx_dev_params_t *dev_params);
> > > +
> > > +#endif /* _MCDI_STUBS_H_ */
> > > diff --git a/include/linux/cdx/cdx_bus.h b/include/linux/cdx/cdx_bus.h
> > > new file mode 100644
> > > index 000000000000..6e870b2c87d9
> > > --- /dev/null
> > > +++ b/include/linux/cdx/cdx_bus.h
> > > @@ -0,0 +1,93 @@
> > > +// SPDX-License-Identifier: GPL-2.0
> > > +/*
> > > + * CDX bus public interface
> > > + *
> > > + * Copyright (C) 2022, Advanced Micro Devices, Inc.
> > > + *
> > > + */
> > > +#ifndef _CDX_BUS_H_
> > > +#define _CDX_BUS_H_
> > > +
> > > +#include <linux/mod_devicetable.h>
> > > +#include <linux/device.h>
> > > +
> > > +#define MAX_CDX_DEV_RESOURCES  6
> > > +
> > > +/**
> > > + * struct cdx_device - CDX device object
> > > + * @dev: Linux driver model device object
> > > + * @vendor: Vendor ID for CDX device
> > > + * @device: Device ID for CDX device
> > > + * @bus_id: Bus ID for this CDX device
> > > + * @func_id: Function ID for this device
> > > + * @res: array of MMIO region entries
> > > + * @res_count: number of valid MMIO regions
> > > + * @dma_mask: Default DMA mask
> > > + * @flags: CDX device flags
> > > + * @req_id: Requestor ID associated with CDX device
> > > + * @driver_override: driver name to force a match; do not set directly,
> > > + *                   because core frees it; use driver_set_override() to
> > > + *                   set or clear it.
> > > + */
> > > +struct cdx_device {
> > > +       struct device dev;
> > > +       u16 vendor;
> > > +       u16 device;
> > > +       u8 bus_id;
> > > +       u8 func_id;
> > > +       struct resource res[MAX_CDX_DEV_RESOURCES];
> > > +       u8 res_count;
> > > +       u64 dma_mask;
> > > +       u16 flags;
> > > +       u32 req_id;
> > > +       const char *driver_override;
> > > +};
> > > +
> > > +#define to_cdx_device(_dev) \
> > > +       container_of(_dev, struct cdx_device, dev)
> > > +
> > > +/**
> > > + * struct cdx_driver - CDX device driver
> > > + * @driver: Generic device driver
> > > + * @match_id_table: table of supported device matching Ids
> > > + * @probe: Function called when a device is added
> > > + * @remove: Function called when a device is removed
> > > + * @shutdown: Function called at shutdown time to quiesce the device
> > > + * @suspend: Function called when a device is stopped
> > > + * @resume: Function called when a device is resumed
> > > + * @driver_managed_dma: Device driver doesn't use kernel DMA API for
> > DMA.
> > > + *             For most device drivers, no need to care about this flag
> > > + *             as long as all DMAs are handled through the kernel DMA API.
> > > + *             For some special ones, for example VFIO drivers, they know
> > > + *             how to manage the DMA themselves and set this flag so that
> > > + *             the IOMMU layer will allow them to setup and manage their
> > > + *             own I/O address space.
> > > + */
> > > +struct cdx_driver {
> > > +       struct device_driver driver;
> > > +       const struct cdx_device_id *match_id_table;
> > > +       int (*probe)(struct cdx_device *dev);
> > > +       int (*remove)(struct cdx_device *dev);
> > > +       void (*shutdown)(struct cdx_device *dev);
> > > +       int (*suspend)(struct cdx_device *dev, pm_message_t state);
> > > +       int (*resume)(struct cdx_device *dev);
> > > +       bool driver_managed_dma;
> > > +};
> > > +
> > > +#define to_cdx_driver(_drv) \
> > > +       container_of(_drv, struct cdx_driver, driver)
> > > +
> > > +/*
> > > + * Macro to avoid include chaining to get THIS_MODULE
> > > + */
> > > +#define cdx_driver_register(drv) \
> > > +       __cdx_driver_register(drv, THIS_MODULE)
> > > +
> > > +int __must_check __cdx_driver_register(struct cdx_driver *cdx_driver,
> > > +                                      struct module *owner);
> > > +
> > > +void cdx_driver_unregister(struct cdx_driver *driver);
> > > +
> > > +extern struct bus_type cdx_bus_type;
> > > +
> > > +#endif /* _CDX_BUS_H_ */
> > > diff --git a/include/linux/mod_devicetable.h
> > b/include/linux/mod_devicetable.h
> > > index 549590e9c644..9b94be83d53e 100644
> > > --- a/include/linux/mod_devicetable.h
> > > +++ b/include/linux/mod_devicetable.h
> > > @@ -911,4 +911,17 @@ struct ishtp_device_id {
> > >         kernel_ulong_t driver_data;
> > >  };
> > >
> > > +/**
> > > + * struct cdx_device_id - CDX device identifier
> > > + * @vendor: vendor ID
> > > + * @device: Device ID
> > > + *
> > > + * Type of entries in the "device Id" table for CDX devices supported by
> > > + * a CDX device driver.
> > > + */
> > > +struct cdx_device_id {
> > > +       __u16 vendor;
> > > +       __u16 device;
> > > +};
> > > +
> > >  #endif /* LINUX_MOD_DEVICETABLE_H */
> > > diff --git a/scripts/mod/devicetable-offsets.c b/scripts/mod/devicetable-
> > offsets.c
> > > index c0d3bcb99138..62dc988df84d 100644
> > > --- a/scripts/mod/devicetable-offsets.c
> > > +++ b/scripts/mod/devicetable-offsets.c
> > > @@ -262,5 +262,9 @@ int main(void)
> > >         DEVID(ishtp_device_id);
> > >         DEVID_FIELD(ishtp_device_id, guid);
> > >
> > > +       DEVID(cdx_device_id);
> > > +       DEVID_FIELD(cdx_device_id, vendor);
> > > +       DEVID_FIELD(cdx_device_id, device);
> > > +
> > >         return 0;
> > >  }
> > > diff --git a/scripts/mod/file2alias.c b/scripts/mod/file2alias.c
> > > index 80d973144fde..c36e1f624e39 100644
> > > --- a/scripts/mod/file2alias.c
> > > +++ b/scripts/mod/file2alias.c
> > > @@ -1452,6 +1452,17 @@ static int do_dfl_entry(const char *filename, void
> > *symval, char *alias)
> > >         return 1;
> > >  }
> > >
> > > +/* Looks like: cdx:vNdN */
> > > +static int do_cdx_entry(const char *filename, void *symval,
> > > +                          char *alias)
> > > +{
> > > +       DEF_FIELD(symval, cdx_device_id, vendor);
> > > +       DEF_FIELD(symval, cdx_device_id, device);
> > > +
> > > +       sprintf(alias, "cdx:v%08Xd%08Xd", vendor, device);
> > > +       return 1;
> > > +}
> > > +
> > >  /* Does namelen bytes of name exactly match the symbol? */
> > >  static bool sym_is(const char *name, unsigned namelen, const char *symbol)
> > >  {
> > > @@ -1531,6 +1542,7 @@ static const struct devtable devtable[] = {
> > >         {"ssam", SIZE_ssam_device_id, do_ssam_entry},
> > >         {"dfl", SIZE_dfl_device_id, do_dfl_entry},
> > >         {"ishtp", SIZE_ishtp_device_id, do_ishtp_entry},
> > > +       {"cdx", SIZE_cdx_device_id, do_cdx_entry},
> > >  };
> > >
> > >  /* Create MODULE_ALIAS() statements.
> > > --
> > > 2.25.1
> > >
