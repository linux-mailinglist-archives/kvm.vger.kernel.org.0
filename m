Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 98E5B1B651F
	for <lists+kvm@lfdr.de>; Thu, 23 Apr 2020 22:05:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726200AbgDWUFx (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 23 Apr 2020 16:05:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40198 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726181AbgDWUFx (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 23 Apr 2020 16:05:53 -0400
Received: from mail-qt1-x844.google.com (mail-qt1-x844.google.com [IPv6:2607:f8b0:4864:20::844])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4C349C09B045
        for <kvm@vger.kernel.org>; Thu, 23 Apr 2020 13:05:52 -0700 (PDT)
Received: by mail-qt1-x844.google.com with SMTP id i68so6014678qtb.5
        for <kvm@vger.kernel.org>; Thu, 23 Apr 2020 13:05:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=OGu+H9Gxb4tDFOp8fw7exxKfo/lmw1deEj+U+KuzxgA=;
        b=esGb0qsr8S2R0qKpqcjD9DwR12EsySXYgYnUu0i6LoNRLHfDiOcOGOfE1ip57oJT4I
         9JoZdQywHPq8WwQZyKjBCegka9UlyLCmBj/4PJ2gTi9a1GRLgmw1lBi6/67XfkoxHjtF
         QIDZSX0x/NjOMGXbmKkpw1qlMTexOynEVkORye9X4iR4JffO3n+BQYmExdQpvKUWvZ5u
         CQLLPjUzxy3QmpI3ZMjz32ZbvpMtFduWvOuy/c3rIPw+SnUda5vZIqDGmqcKqF9nOQ7n
         UUzZg3Fom3EvQGVr7dk46QzhEHMVshgJI+0kEysmMee+yWRtbMmfLghZXzmWbJ8uNisB
         QjMw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=OGu+H9Gxb4tDFOp8fw7exxKfo/lmw1deEj+U+KuzxgA=;
        b=Ra1S0XW+gVWrjvtPoPIayiHIHW8Qpc1g611yZ6OCreYakf+qPt4hJJDT0icj/PwiKb
         6kO7uErPqbq41Vx73Vq3KpedJc8iKXr55jQFzR4i7ffmaIPjcZMod679X7FUMjeL/iv+
         69FuWSVOyYede5QrUxn+ls3IcD2vQI/2UPWddpqNPYo90H1+Qj0EGXOewC/0ChLA8dYe
         eeV52ZH67uib1t+XG8iZfnpKzfqmUSY+w5pTtKONA4x7J/i8JOZQtZEiuKbWAZ6rGHp9
         gFq80LWPjwQEbOdISOmsXHmenkjeCgnBqaZw2YyuCNiIQOkgI/zScqIjRQ2OueJJMfIy
         IFvw==
X-Gm-Message-State: AGi0PuZiyfVf0TzWNivoL0YdRSZ4YaP75VzM8wn+smqg9Y6xxJvjtZdo
        mtmm7JQgYzv91cbr4Rwk+2oUKw==
X-Google-Smtp-Source: APiQypKgTkhoslLa1VaSlI6+/e0Q/twNfuGjIX2/4S0TUHP9uXc8vJs6MhROT+wFJvVo/Suzu/usIg==
X-Received: by 2002:ac8:2c66:: with SMTP id e35mr5990474qta.188.1587672351308;
        Thu, 23 Apr 2020 13:05:51 -0700 (PDT)
Received: from ziepe.ca (hlfxns017vw-142-68-57-212.dhcp-dynamic.fibreop.ns.bellaliant.net. [142.68.57.212])
        by smtp.gmail.com with ESMTPSA id 70sm2291707qkh.67.2020.04.23.13.04.46
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Thu, 23 Apr 2020 13:05:17 -0700 (PDT)
Received: from jgg by mlx.ziepe.ca with local (Exim 4.90_1)
        (envelope-from <jgg@ziepe.ca>)
        id 1jRi5M-0007gM-Ow; Thu, 23 Apr 2020 17:04:36 -0300
Date:   Thu, 23 Apr 2020 17:04:36 -0300
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
Subject: Re: [PATCH RFC 07/15] Documentation: Interrupt Message store
Message-ID: <20200423200436.GA29181@ziepe.ca>
References: <158751095889.36773.6009825070990637468.stgit@djiang5-desk3.ch.intel.com>
 <158751207000.36773.18208950543781892.stgit@djiang5-desk3.ch.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <158751207000.36773.18208950543781892.stgit@djiang5-desk3.ch.intel.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Apr 21, 2020 at 04:34:30PM -0700, Dave Jiang wrote:

> diff --git a/Documentation/ims-howto.rst b/Documentation/ims-howto.rst
> new file mode 100644
> index 000000000000..a18de152b393
> +++ b/Documentation/ims-howto.rst
> @@ -0,0 +1,210 @@
> +.. SPDX-License-Identifier: GPL-2.0
> +.. include:: <isonum.txt>
> +
> +==========================
> +The IMS Driver Guide HOWTO
> +==========================
> +
> +:Authors: Megha Dey
> +
> +:Copyright: 2020 Intel Corporation
> +
> +About this guide
> +================
> +
> +This guide describes the basics of Interrupt Message Store (IMS), the
> +need to introduce a new interrupt mechanism, implementation details of
> +IMS in the kernel, driver changes required to support IMS and the general
> +misconceptions and FAQs associated with IMS.

I'm not sure why we need to call this IMS in kernel documentat? I know
Intel is using this term, but this document is really only talking
about extending the existing platform_msi stuff, which looks pretty
good actually.

A lot of this is good for the cover letter..

> +Implementation of IMS in the kernel
> +===================================
> +
> +The Linux kernel today already provides a generic mechanism to support
> +non-PCI compliant MSI interrupts for platform devices (platform-msi.c).
> +To support IMS interrupts, we create a new IMS IRQ domain and extend the
> +existing infrastructure. Dynamic allocation of IMS vectors is a requirement
> +for devices which support Scalable I/O Virtualization. A driver can allocate
> +and free vectors not just once during probe (as was the case with MSI/MSI-X)
> +but also in the post probe phase where actual demand is available. Thus, a
> +new API, platform_msi_domain_alloc_irqs_group is introduced which drivers
> +using IMS would be able to call multiple times. The vectors allocated each
> +time this API is called are associated with a group ID. To free the vectors
> +associated with a particular group, the platform_msi_domain_free_irqs_group
> +API can be called. The existing drivers using platform-msi infrastructure
> +will continue to use the existing alloc (platform_msi_domain_alloc_irqs)
> +and free (platform_msi_domain_free_irqs) APIs and are assigned a default
> +group ID of 0.
> +
> +Thus, platform-msi.c provides the generic methods which can be used by any
> +non-pci MSI interrupt type while the newly created ims-msi.c provides IMS
> +specific callbacks that can be used by drivers capable of generating IMS
> +interrupts. 

How exactly is an IMS interrupt is different from a platform msi?

It looks like it is just some thin wrapper around msi_domain - what is
it for?

> +FAQs and general misconceptions:
> +================================
> +
> +** There were some concerns raised by Thomas Gleixner and Marc Zyngier
> +during Linux plumbers conference 2019:
> +
> +1. Enumeration of IMS needs to be done by PCI core code and not by
> +   individual device drivers:
> +
> +   Currently, if the kernel needs a generic way to discover IMS capability
> +   without host driver dependency, the PCIE Designated Vendor specific
> +
> +   However, we cannot have a standard way of enumerating the IMS size
> +   because for context based devices, the interrupt message is part of
> +   the context itself which is managed entirely by the driver. Since
> +   context creation is done on demand, there is no way to tell during boot
> +   time, the maximum number of contexts (and hence the number of interrupt
> +   messages)that the device can support.

FWIW, I agree with this.

Like platform-msi, IMS should be controlled entirely by the driver.

> +2. Why is Intel designing a new interrupt mechanism rather than extending
> +   MSI-X to address its limitations? Isn't 2048 device interrupts enough?
> +
> +   MSI-X has a rigid definition of one-table and on-device storage and does
> +   not provide the full flexibility required for future multi-tile
> +   accelerator designs.
> +   IMS was envisioned to be used with large number of ADIs in devices where
> +   each will need unique interrupt resources. For example, a DSA shared
> +   work queue can support large number of clients where each client can
> +   have its own interrupt. In future, with user interrupts, we expect the
> +   demand for messages to increase further.

Generally agree

> +Device Driver Changes:
> +=====================
> +
> +1. platform_msi_domain_alloc_irqs_group (struct device *dev, unsigned int
> +   nvec, const struct platform_msi_ops *platform_ops, int *group_id)
> +   to allocate IMS interrupts, where:
> +
> +   dev: The device for which to allocate interrupts
> +   nvec: The number of interrupts to allocate
> +   platform_ops: Callbacks for platform MSI ops (to be provided by driver)
> +   group_id: returned by the call, to be used to free IRQs of a certain type
> +
> +   eg: static struct platform_msi_ops ims_ops  = {
> +        .irq_mask               = ims_irq_mask,
> +        .irq_unmask             = ims_irq_unmask,
> +        .write_msg              = ims_write_msg,
> +        };
> +
> +        int group;
> +        platform_msi_domain_alloc_irqs_group (dev, nvec, platform_ops, &group)
> +
> +   where, struct platform_msi_ops:
> +   irq_mask:   mask an interrupt source
> +   irq_unmask: unmask an interrupt source
> +   irq_write_msi_msg: write message content
> +
> +   This API can be called multiple times. Every time a new group will be
> +   associated with the allocated vectors. Group ID starts from 0.

Need much more closer look, but this seems conceptually fine to me.

As above the API here is called platform_msi - which seems good to
me. Again not sure why the word IMS is needed

Jason
