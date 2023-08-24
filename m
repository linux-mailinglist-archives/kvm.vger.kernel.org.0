Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D4CD7787425
	for <lists+kvm@lfdr.de>; Thu, 24 Aug 2023 17:27:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242129AbjHXP0j (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 24 Aug 2023 11:26:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33800 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242203AbjHXP0U (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 24 Aug 2023 11:26:20 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B46FF19B2
        for <kvm@vger.kernel.org>; Thu, 24 Aug 2023 08:25:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1692890732;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=I68/GBXzgIeykhJKJ/R9njNTye2zNl+rr739FJ1Wzkc=;
        b=HdcX0Hh4RN/rwCOLGdA1fLzxZh8mvq0iAMnzmyXkWBb58T7SGgGj/MOFYDw2ipRta1sN9K
        pmhxYKOVb39RMzvLksH06BjMpJjEQpkfSpCo+iw5O2xEzVV2j84E176Zt2SU7WjoGvdc3t
        Xzn0STEg1tFocyfR662a7uuNG8WNO1Y=
Received: from mail-io1-f70.google.com (mail-io1-f70.google.com
 [209.85.166.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-471-7PCiflZKN6S4f38i6fl7Hg-1; Thu, 24 Aug 2023 11:25:30 -0400
X-MC-Unique: 7PCiflZKN6S4f38i6fl7Hg-1
Received: by mail-io1-f70.google.com with SMTP id ca18e2360f4ac-790d561d943so598680739f.1
        for <kvm@vger.kernel.org>; Thu, 24 Aug 2023 08:25:30 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1692890730; x=1693495530;
        h=content-transfer-encoding:mime-version:organization:references
         :in-reply-to:message-id:subject:cc:to:from:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=I68/GBXzgIeykhJKJ/R9njNTye2zNl+rr739FJ1Wzkc=;
        b=l/Y7zpmwKF0ZVxDvG/ldnV8VaBBuQxcWhW+EQq8lmD29sjbPUi/rXeSQF4GXnIdTjQ
         GmtTLK93t9oqI/TV6Dlpz0hHqWq7nQCbNHAK/rZnix67k5uBtE0YnA9PHIWNDxisyPyW
         ck1K5jrdSgussfuxLwAxeLBnLFLuDv3918QqUaZeQ0HazxIcC81Msfd53CNnPIqqbDV8
         7KUqAE/v1NDw8ARUrKQkkt+8MOcMcupEGudKRV/wDmpMbh/8NoFN8qBLwSRaLkr6c/eH
         09XdX4qqZvqKc5fbNpfFd4luiiTn8sW3zQysDPDTvgckHoVYnvHTb8dbfKANm6xvU83v
         qUGw==
X-Gm-Message-State: AOJu0Yw4B3u5y2W6Rx/MSxHe5CeDm7SQ+CVZLR3sFilDiC+vw9sr2LPD
        ZBtpilnBVaEcDJxoP5U7f/7kJFB5scmYvNLF+xAzWaMBlt2Zh97XcEj8p7OG4CaQrAzA88rmTQv
        fK7LbzrguzKZa
X-Received: by 2002:a6b:720b:0:b0:787:8d2:e0c with SMTP id n11-20020a6b720b000000b0078708d20e0cmr6671540ioc.12.1692890729769;
        Thu, 24 Aug 2023 08:25:29 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEke3AIwUL3voDBxvHAh2VGnvJHrolmd2TOjjUuh6KzxktMdE9vcGe82anmrMXRho36BrIQGg==
X-Received: by 2002:a6b:720b:0:b0:787:8d2:e0c with SMTP id n11-20020a6b720b000000b0078708d20e0cmr6671520ioc.12.1692890729546;
        Thu, 24 Aug 2023 08:25:29 -0700 (PDT)
Received: from redhat.com ([38.15.60.12])
        by smtp.gmail.com with ESMTPSA id b19-20020a5d8953000000b0079199e52035sm4604093iot.52.2023.08.24.08.25.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 24 Aug 2023 08:25:28 -0700 (PDT)
Date:   Thu, 24 Aug 2023 09:25:27 -0600
From:   Alex Williamson <alex.williamson@redhat.com>
To:     "Zeng, Xin" <xin.zeng@intel.com>
Cc:     "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "Cabiddu, Giovanni" <giovanni.cabiddu@intel.com>,
        "andriy.shevchenko@linux.intel.com" 
        <andriy.shevchenko@linux.intel.com>,
        "Cao, Yahui" <yahui.cao@intel.com>,
        "jgg@nvidia.com" <jgg@nvidia.com>,
        "yishaih@nvidia.com" <yishaih@nvidia.com>,
        "shameerali.kolothum.thodi@huawei.com" 
        <shameerali.kolothum.thodi@huawei.com>,
        "Tian, Kevin" <kevin.tian@intel.com>
Subject: Re: [RFC 5/5] vfio/qat: Add vfio_pci driver for Intel QAT VF
 devices
Message-ID: <20230824092527.143eebbc.alex.williamson@redhat.com>
In-Reply-To: <DM4PR11MB550203FB22F8D6F0EAF8F717881CA@DM4PR11MB5502.namprd11.prod.outlook.com>
References: <20230630131304.64243-1-xin.zeng@intel.com>
        <20230630131304.64243-6-xin.zeng@intel.com>
        <20230726133726.7e2cf1e8.alex.williamson@redhat.com>
        <DM4PR11MB550203FB22F8D6F0EAF8F717881CA@DM4PR11MB5502.namprd11.prod.outlook.com>
Organization: Red Hat
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_NONE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, 23 Aug 2023 15:29:47 +0000
"Zeng, Xin" <xin.zeng@intel.com> wrote:

> Thanks for the comments, Alex.
> On Thursday, July 27, 2023 3:37 AM, Alex Williamson wrote:
> > >  drivers/vfio/pci/Kconfig                 |   2 +
> > >  drivers/vfio/pci/Makefile                |   1 +
> > >  drivers/vfio/pci/qat/Kconfig             |  13 +
> > >  drivers/vfio/pci/qat/Makefile            |   4 +
> > >  drivers/vfio/pci/qat/qat_vfio_pci_main.c | 518  
> > +++++++++++++++++++++++
> > 
> > Rename to main.c.  
> 
> Will do in next version.
> 
> >   
> > >  5 files changed, 538 insertions(+)
> > >  create mode 100644 drivers/vfio/pci/qat/Kconfig
> > >  create mode 100644 drivers/vfio/pci/qat/Makefile
> > >  create mode 100644 drivers/vfio/pci/qat/qat_vfio_pci_main.c
> > >
> > > diff --git a/drivers/vfio/pci/Kconfig b/drivers/vfio/pci/Kconfig
> > > index f9d0c908e738..47c9773cf0c7 100644
> > > --- a/drivers/vfio/pci/Kconfig
> > > +++ b/drivers/vfio/pci/Kconfig
> > > @@ -59,4 +59,6 @@ source "drivers/vfio/pci/mlx5/Kconfig"
> > >
> > >  source "drivers/vfio/pci/hisilicon/Kconfig"
> > >
> > > +source "drivers/vfio/pci/qat/Kconfig"
> > > +
> > >  endif
> > > diff --git a/drivers/vfio/pci/Makefile b/drivers/vfio/pci/Makefile
> > > index 24c524224da5..dcc6366df8fa 100644
> > > --- a/drivers/vfio/pci/Makefile
> > > +++ b/drivers/vfio/pci/Makefile
> > > @@ -11,3 +11,4 @@ obj-$(CONFIG_VFIO_PCI) += vfio-pci.o
> > >  obj-$(CONFIG_MLX5_VFIO_PCI)           += mlx5/
> > >
> > >  obj-$(CONFIG_HISI_ACC_VFIO_PCI) += hisilicon/
> > > +obj-$(CONFIG_QAT_VFIO_PCI) += qat/
> > > diff --git a/drivers/vfio/pci/qat/Kconfig b/drivers/vfio/pci/qat/Kconfig
> > > new file mode 100644
> > > index 000000000000..38e5b4a0ca9c
> > > --- /dev/null
> > > +++ b/drivers/vfio/pci/qat/Kconfig
> > > @@ -0,0 +1,13 @@
> > > +# SPDX-License-Identifier: GPL-2.0-only
> > > +config QAT_VFIO_PCI
> > > +	tristate "VFIO support for QAT VF PCI devices"
> > > +	depends on X86  
> > 
> > What specific X86 dependency exists here?  CRYPTO_DEV_QAT and the
> > various versions of the QAT driver don't seem to have an explicit arch
> > dependency, therefore this shouldn't either.  
> 
> You are right. Will remove it.
> 
> >   
> > > +	depends on VFIO_PCI_CORE  
> > 
> > select VFIO_PCI_CORE, this was updated for all vfio-pci variant drivers
> > for v6.5.  
> 
> Will update it.
> 
> >   
> > > +
> > > diff --git a/drivers/vfio/pci/qat/qat_vfio_pci_main.c  
> > b/drivers/vfio/pci/qat/qat_vfio_pci_main.c  
> > > new file mode 100644
> > > index 000000000000..af971fd05fd2
> > > --- /dev/null
> > > +++ b/drivers/vfio/pci/qat/qat_vfio_pci_main.c
> > > @@ -0,0 +1,518 @@
> > > +// SPDX-License-Identifier: GPL-2.0-only
> > > +/* Copyright(c) 2023 Intel Corporation */
> > > +#include <linux/anon_inodes.h>
> > > +#include <linux/container_of.h>
> > > +#include <linux/device.h>
> > > +#include <linux/file.h>
> > > +#include <linux/init.h>
> > > +#include <linux/kernel.h>
> > > +#include <linux/module.h>
> > > +#include <linux/mutex.h>
> > > +#include <linux/pci.h>
> > > +#include <linux/sizes.h>
> > > +#include <linux/types.h>
> > > +#include <linux/uaccess.h>
> > > +#include <linux/vfio_pci_core.h>
> > > +#include <linux/qat/qat_vf_mig.h>
> > > +
> > > +struct qat_vf_mig_data {
> > > +	u8 state[SZ_4K];
> > > +};
> > > +
> > > +struct qat_vf_migration_file {
> > > +	struct file *filp;
> > > +	struct mutex lock; /* protect migration region context */
> > > +	bool disabled;
> > > +
> > > +	size_t total_length;
> > > +	struct qat_vf_mig_data mig_data;
> > > +};
> > > +
> > > +static void qat_vf_vfio_pci_remove(struct pci_dev *pdev)
> > > +{
> > > +	struct qat_vf_core_device *qat_vdev = qat_vf_drvdata(pdev);
> > > +
> > > +	vfio_pci_core_unregister_device(&qat_vdev->core_device);
> > > +	vfio_put_device(&qat_vdev->core_device.vdev);
> > > +}
> > > +
> > > +static const struct pci_device_id qat_vf_vfio_pci_table[] = {
> > > +	/* Intel QAT GEN4 4xxx VF device */
> > > +	{ PCI_DRIVER_OVERRIDE_DEVICE_VFIO(PCI_VENDOR_ID_INTEL,  
> > 0x4941) },
> > 
> > Should this driver depend on CRYPTO_DEV_QAT_4XXX if that's the only
> > supported PF driver?  
> 
> This module has not any dependency to QAT_4XXX module at build time, but it indeed has implicit
> dependency on QAT_4XXX runtime to enable SRIOV and complete the QAT 4xxx VF migration,
> do you think we still need to put this dependency explicitly in Kconfig?

What benefit does it serve a user to be able to build this module if
the runtime dependency isn't present in the kernel?  We have
COMPILE_TEST to support build time regression testing.  Thanks,

Alex

