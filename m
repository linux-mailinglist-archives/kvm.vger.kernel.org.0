Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F16F21C2FFD
	for <lists+kvm@lfdr.de>; Mon,  4 May 2020 00:25:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729197AbgECWZQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 3 May 2020 18:25:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43832 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1729151AbgECWZP (ORCPT
        <rfc822;kvm@vger.kernel.org>); Sun, 3 May 2020 18:25:15 -0400
Received: from mail-qk1-x742.google.com (mail-qk1-x742.google.com [IPv6:2607:f8b0:4864:20::742])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7836CC061A0E
        for <kvm@vger.kernel.org>; Sun,  3 May 2020 15:25:15 -0700 (PDT)
Received: by mail-qk1-x742.google.com with SMTP id q7so14906433qkf.3
        for <kvm@vger.kernel.org>; Sun, 03 May 2020 15:25:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to
         :user-agent;
        bh=fE1DsHMLeD3vUe7bC1r7mfbyeNGV2bFbtoi5gmdBxnc=;
        b=Iuv8uvwIEuuVEU+E9/d0lU12GRhwJXxzMOTrQ92WjdBA04tJLjmPxjp6gl1VrNZWnn
         oMQMWjSyMu4om5lGhqyLodhcxZV4LEsdWktKi016L5V6uap1LaKTC5qqc4vxcbZAFvDM
         bZHtM6mulmG8tAtV+/WvpEdo3YntvODOaINQ0HA9BxegSyeUbeaPrpkmsMyv2v1j4VBn
         ut4AbaXhIdUNp+1/2wTh1OPq3A2TQiYewm3OPEC/WaQgMgxyQDaHqVDe1AkfMXpvCguz
         L5R4vAPnsbO0bMb5A0XtxBOPspzZhnRZlXAVY9E+ZVDYwtDa1Jtuvs1FkJo/bUFrF7Ud
         x4yA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to:user-agent;
        bh=fE1DsHMLeD3vUe7bC1r7mfbyeNGV2bFbtoi5gmdBxnc=;
        b=tpzS7iAiAtWmlX77wZDk6IoJNY+TAFSxcsF2Y2uWuu9FSUaOpFtlTcehizEL9uALXX
         zSB8PMUanOYMumet0G2iqrKK0FQ9mkZprf+glkIkwJp1u4NuU/BcqQmrop/hsxkSnnN6
         vpiM5tWBS21f5cHPkFr1YhlGJH+/1UfNFxuJFcvXvtlJaWqD/wS0bJ7ki3yF6WuFYYVW
         SGqtGTr5HHtDRQgorFg4FuxQBlW9v7vlKgyGvmoNsgF6TyfyvhMVRb26/1v2NIfLWDAd
         0jx43urqsDaY6pMCItKz6QYpmJ4JTVJOaDu6S1aW0GDXQ+tEi+QryTNH67moS1SYgXIK
         7jig==
X-Gm-Message-State: AGi0PuaX6CgXs4aZfvchKMVr3HebbTnFb07BnCz2WVptoI2uAdgfLbrN
        svo6BRbkpRWZChLMGmOob/BUXw==
X-Google-Smtp-Source: APiQypLo8CBxepN9L5tiMWDFp5DJImiXdhLUtRbT60zIZXhhiuntugGhkFhRsYpUPOjZpXopTs+nrg==
X-Received: by 2002:a37:ac14:: with SMTP id e20mr12271790qkm.23.1588544714466;
        Sun, 03 May 2020 15:25:14 -0700 (PDT)
Received: from ziepe.ca (hlfxns017vw-142-68-57-212.dhcp-dynamic.fibreop.ns.bellaliant.net. [142.68.57.212])
        by smtp.gmail.com with ESMTPSA id w69sm1792213qka.75.2020.05.03.15.25.13
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Sun, 03 May 2020 15:25:13 -0700 (PDT)
Received: from jgg by mlx.ziepe.ca with local (Exim 4.90_1)
        (envelope-from <jgg@ziepe.ca>)
        id 1jVN2v-0002Sw-33; Sun, 03 May 2020 19:25:13 -0300
Date:   Sun, 3 May 2020 19:25:13 -0300
From:   Jason Gunthorpe <jgg@ziepe.ca>
To:     "Dey, Megha" <megha.dey@linux.intel.com>
Cc:     Dave Jiang <dave.jiang@intel.com>, vkoul@kernel.org,
        maz@kernel.org, bhelgaas@google.com, rafael@kernel.org,
        gregkh@linuxfoundation.org, tglx@linutronix.de, hpa@zytor.com,
        alex.williamson@redhat.com, jacob.jun.pan@intel.com,
        ashok.raj@intel.com, yi.l.liu@intel.com, baolu.lu@intel.com,
        kevin.tian@intel.com, sanjay.k.kumar@intel.com,
        tony.luck@intel.com, jing.lin@intel.com, dan.j.williams@intel.com,
        kwankhede@nvidia.com, eric.auger@redhat.com, parav@mellanox.com,
        dmaengine@vger.kernel.org, linux-kernel@vger.kernel.org,
        x86@kernel.org, linux-pci@vger.kernel.org, kvm@vger.kernel.org
Subject: Re: [PATCH RFC 04/15] drivers/base: Add support for a new IMS irq
 domain
Message-ID: <20200503222513.GS26002@ziepe.ca>
References: <158751095889.36773.6009825070990637468.stgit@djiang5-desk3.ch.intel.com>
 <158751205175.36773.1874642824360728883.stgit@djiang5-desk3.ch.intel.com>
 <20200423201118.GA29567@ziepe.ca>
 <35f701d9-1034-09c7-8117-87fb8796a017@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <35f701d9-1034-09c7-8117-87fb8796a017@linux.intel.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, May 01, 2020 at 03:30:02PM -0700, Dey, Megha wrote:
> Hi Jason,
> 
> On 4/23/2020 1:11 PM, Jason Gunthorpe wrote:
> > On Tue, Apr 21, 2020 at 04:34:11PM -0700, Dave Jiang wrote:
> > > diff --git a/drivers/base/ims-msi.c b/drivers/base/ims-msi.c
> > > new file mode 100644
> > > index 000000000000..738f6d153155
> > > +++ b/drivers/base/ims-msi.c
> > > @@ -0,0 +1,100 @@
> > > +// SPDX-License-Identifier: GPL-2.0-only
> > > +/*
> > > + * Support for Device Specific IMS interrupts.
> > > + *
> > > + * Copyright © 2019 Intel Corporation.
> > > + *
> > > + * Author: Megha Dey <megha.dey@intel.com>
> > > + */
> > > +
> > > +#include <linux/dmar.h>
> > > +#include <linux/irq.h>
> > > +#include <linux/mdev.h>
> > > +#include <linux/pci.h>
> > > +
> > > +/*
> > > + * Determine if a dev is mdev or not. Return NULL if not mdev device.
> > > + * Return mdev's parent dev if success.
> > > + */
> > > +static inline struct device *mdev_to_parent(struct device *dev)
> > > +{
> > > +	struct device *ret = NULL;
> > > +	struct device *(*fn)(struct device *dev);
> > > +	struct bus_type *bus = symbol_get(mdev_bus_type);
> > > +
> > > +	if (bus && dev->bus == bus) {
> > > +		fn = symbol_get(mdev_dev_to_parent_dev);
> > > +		ret = fn(dev);
> > > +		symbol_put(mdev_dev_to_parent_dev);
> > > +		symbol_put(mdev_bus_type);
> > 
> > No, things like this are not OK in the drivers/base
> > 
> > Whatever this is doing needs to be properly architected in some
> > generic way.
> 
> Basically what I am trying to do here is to determine if the device is an
> mdev device or not.

Why? mdev devices are virtual they don't have HW elements.

The caller should use the concrete pci_device to allocate
platform_msi? What is preventing this?

> > > +struct irq_domain *arch_create_ims_irq_domain(struct irq_domain *parent,
> > > +					      const char *name)
> > > +{
> > > +	struct fwnode_handle *fn;
> > > +	struct irq_domain *domain;
> > > +
> > > +	fn = irq_domain_alloc_named_fwnode(name);
> > > +	if (!fn)
> > > +		return NULL;
> > > +
> > > +	domain = msi_create_irq_domain(fn, &ims_ir_domain_info, parent);
> > > +	if (!domain)
> > > +		return NULL;
> > > +
> > > +	irq_domain_update_bus_token(domain, DOMAIN_BUS_PLATFORM_MSI);
> > > +	irq_domain_free_fwnode(fn);
> > > +
> > > +	return domain;
> > > +}
> > 
> > I'm still not really clear why all this is called IMS.. This looks
> > like the normal boilerplate to setup an IRQ domain? What is actually
> > 'ims' in here?
> 
> It is just a way to create a new domain specifically for IMS interrupts.
> Although, since there is a platform_msi_create_irq_domain already, which
> does something similar, I will use the same for IMS as well.

But this is all code already intended to be used by the platform, why
is it in drivers/base?

> Also, since there is quite a stir over the name 'IMS' do you have any
> suggestion for a more generic name for this?

It seems we have a name, this is called platform_msi in Linux?

Jason
