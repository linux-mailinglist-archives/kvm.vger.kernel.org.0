Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6E3C61B6537
	for <lists+kvm@lfdr.de>; Thu, 23 Apr 2020 22:11:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726375AbgDWULU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 23 Apr 2020 16:11:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41062 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726057AbgDWULU (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 23 Apr 2020 16:11:20 -0400
Received: from mail-qv1-xf43.google.com (mail-qv1-xf43.google.com [IPv6:2607:f8b0:4864:20::f43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 18930C09B042
        for <kvm@vger.kernel.org>; Thu, 23 Apr 2020 13:11:20 -0700 (PDT)
Received: by mail-qv1-xf43.google.com with SMTP id q2so3576508qvd.1
        for <kvm@vger.kernel.org>; Thu, 23 Apr 2020 13:11:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to
         :user-agent;
        bh=lWtwv24Nfi0axiyCp3rc/Sxd+Qy0bmZpIX4zlE10TGU=;
        b=E8SsOA0QTJuBO3ylcTS2xJsVATuHuxVjAatduicQzuspBirkZTmaN7KsZ6488gy1x5
         hVMem2vuSKMAm6WRqtcHA6AsKeB38+XVlUj65g41PzO7wqQmIkfYnc2xIFfFiCi3FR5T
         KEIKtRoxDy1RwWlu4xSglVFmVpQaVyMah7amYQi1rnQ6+Vagd86hWwWBpsVcvLLcnf0+
         gjs9BvZD18tfGRTrq/znf09Tpnxqx+67K7tH6cdI0WV2BACgOO+d6z10Eqk7uiRX9HaU
         3FY1WkZCCbU6ggo/3Mj+g2XNtO0IyDlH6QN7vxfIKFJnUTzvceAGGaI7L40VJpEcn/TR
         oq5g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to:user-agent;
        bh=lWtwv24Nfi0axiyCp3rc/Sxd+Qy0bmZpIX4zlE10TGU=;
        b=UwYHFK7mY0mVCYelQ6GYR69HIsFOYAyJedfR37lVR9gqJTyiUOWMKcr9efwvs9t29W
         7GezEPn2GBxK5FhvlaEO81nA2lldI9okfhe0feSjICEgrsrcAx5x8k9G8WEH5/YLGZcD
         UiNEgM5IMUtZZ45chFAwAMJAo3y/ROoH2kMrcFmJIYNe2d4Wob2eNhuMdo1ad5HKoOjh
         s3YKD2AiZDDMwxxtbZ39Hym1fjdQGOPwlT0Q2TLsMRN+fR8FnyBJmO/TxNPyieO8dFn0
         iAS/RwUwZfKMUpvt2C5b5087vGheS2hSOb91iNU4RlpB/u2ZI3Qnpb+mtvkHAl5FZBrO
         IyIw==
X-Gm-Message-State: AGi0Puac6Yo4ksnFRr4psKdek1LbghjPt3EDPdzacsqyFg89IMAlx6lh
        0/9QOVCVxL6HHKQ6oCrVqdK59Q==
X-Google-Smtp-Source: APiQypKuPAopgt+O2z/cQxgPn4lmcCmWiRkwb8I7ACO1Hf+8ae3BUi01fvAzpbYMvGtIS+7kz8qhyg==
X-Received: by 2002:a0c:ed42:: with SMTP id v2mr5911795qvq.94.1587672679177;
        Thu, 23 Apr 2020 13:11:19 -0700 (PDT)
Received: from ziepe.ca (hlfxns017vw-142-68-57-212.dhcp-dynamic.fibreop.ns.bellaliant.net. [142.68.57.212])
        by smtp.gmail.com with ESMTPSA id g12sm2476558qtu.69.2020.04.23.13.11.18
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Thu, 23 Apr 2020 13:11:18 -0700 (PDT)
Received: from jgg by mlx.ziepe.ca with local (Exim 4.90_1)
        (envelope-from <jgg@ziepe.ca>)
        id 1jRiBq-0007lh-1P; Thu, 23 Apr 2020 17:11:18 -0300
Date:   Thu, 23 Apr 2020 17:11:18 -0300
From:   Jason Gunthorpe <jgg@ziepe.ca>
To:     Dave Jiang <dave.jiang@intel.com>
Cc:     vkoul@kernel.org, megha.dey@linux.intel.com, maz@kernel.org,
        bhelgaas@google.com, rafael@kernel.org, gregkh@linuxfoundation.org,
        tglx@linutronix.de, hpa@zytor.com, alex.williamson@redhat.com,
        jacob.jun.pan@intel.com, ashok.raj@intel.com, yi.l.liu@intel.com,
        baolu.lu@intel.com, kevin.tian@intel.com, sanjay.k.kumar@intel.com,
        tony.luck@intel.com, jing.lin@intel.com, dan.j.williams@intel.com,
        kwankhede@nvidia.com, eric.auger@redhat.com, parav@mellanox.com,
        dmaengine@vger.kernel.org, linux-kernel@vger.kernel.org,
        x86@kernel.org, linux-pci@vger.kernel.org, kvm@vger.kernel.org
Subject: Re: [PATCH RFC 04/15] drivers/base: Add support for a new IMS irq
 domain
Message-ID: <20200423201118.GA29567@ziepe.ca>
References: <158751095889.36773.6009825070990637468.stgit@djiang5-desk3.ch.intel.com>
 <158751205175.36773.1874642824360728883.stgit@djiang5-desk3.ch.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <158751205175.36773.1874642824360728883.stgit@djiang5-desk3.ch.intel.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Apr 21, 2020 at 04:34:11PM -0700, Dave Jiang wrote:
> diff --git a/drivers/base/ims-msi.c b/drivers/base/ims-msi.c
> new file mode 100644
> index 000000000000..738f6d153155
> +++ b/drivers/base/ims-msi.c
> @@ -0,0 +1,100 @@
> +// SPDX-License-Identifier: GPL-2.0-only
> +/*
> + * Support for Device Specific IMS interrupts.
> + *
> + * Copyright © 2019 Intel Corporation.
> + *
> + * Author: Megha Dey <megha.dey@intel.com>
> + */
> +
> +#include <linux/dmar.h>
> +#include <linux/irq.h>
> +#include <linux/mdev.h>
> +#include <linux/pci.h>
> +
> +/*
> + * Determine if a dev is mdev or not. Return NULL if not mdev device.
> + * Return mdev's parent dev if success.
> + */
> +static inline struct device *mdev_to_parent(struct device *dev)
> +{
> +	struct device *ret = NULL;
> +	struct device *(*fn)(struct device *dev);
> +	struct bus_type *bus = symbol_get(mdev_bus_type);
> +
> +	if (bus && dev->bus == bus) {
> +		fn = symbol_get(mdev_dev_to_parent_dev);
> +		ret = fn(dev);
> +		symbol_put(mdev_dev_to_parent_dev);
> +		symbol_put(mdev_bus_type);

No, things like this are not OK in the drivers/base

Whatever this is doing needs to be properly architected in some
generic way.

> +static int dev_ims_prepare(struct irq_domain *domain, struct device *dev,
> +			   int nvec, msi_alloc_info_t *arg)
> +{
> +	if (dev_is_mdev(dev))
> +		dev = mdev_to_parent(dev);

Like maybe the caller shouldn't be passing in a mdev in the first
place, or some generic driver layer scheme is needed to go from a
child device (eg a mdev or one of these new virtual bus things) to the
struct device that owns the IRQ interface.

> +	init_irq_alloc_info(arg, NULL);
> +	arg->dev = dev;
> +	arg->type = X86_IRQ_ALLOC_TYPE_IMS;

Also very bewildering to see X86_* in drivers/base

> +struct irq_domain *arch_create_ims_irq_domain(struct irq_domain *parent,
> +					      const char *name)
> +{
> +	struct fwnode_handle *fn;
> +	struct irq_domain *domain;
> +
> +	fn = irq_domain_alloc_named_fwnode(name);
> +	if (!fn)
> +		return NULL;
> +
> +	domain = msi_create_irq_domain(fn, &ims_ir_domain_info, parent);
> +	if (!domain)
> +		return NULL;
> +
> +	irq_domain_update_bus_token(domain, DOMAIN_BUS_PLATFORM_MSI);
> +	irq_domain_free_fwnode(fn);
> +
> +	return domain;
> +}

I'm still not really clear why all this is called IMS.. This looks
like the normal boilerplate to setup an IRQ domain? What is actually
'ims' in here?

> diff --git a/drivers/vfio/mdev/mdev_private.h b/drivers/vfio/mdev/mdev_private.h
> index 7d922950caaf..c21f1305a76b 100644
> +++ b/drivers/vfio/mdev/mdev_private.h
> @@ -36,7 +36,6 @@ struct mdev_device {
>  };
>  
>  #define to_mdev_device(dev)	container_of(dev, struct mdev_device, dev)
> -#define dev_is_mdev(d)		((d)->bus == &mdev_bus_type)
>  
>  struct mdev_type {
>  	struct kobject kobj;
> diff --git a/include/linux/mdev.h b/include/linux/mdev.h
> index 0ce30ca78db0..fa2344e239ef 100644
> +++ b/include/linux/mdev.h
> @@ -144,5 +144,8 @@ void mdev_unregister_driver(struct mdev_driver *drv);
>  struct device *mdev_parent_dev(struct mdev_device *mdev);
>  struct device *mdev_dev(struct mdev_device *mdev);
>  struct mdev_device *mdev_from_dev(struct device *dev);
> +struct device *mdev_dev_to_parent_dev(struct device *dev);
> +
> +#define dev_is_mdev(dev) ((dev)->bus == symbol_get(mdev_bus_type))

NAK on the symbol_get

Jason
