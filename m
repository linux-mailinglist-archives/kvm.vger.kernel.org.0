Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EA7472A101C
	for <lists+kvm@lfdr.de>; Fri, 30 Oct 2020 22:27:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727801AbgJ3V07 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 30 Oct 2020 17:26:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43644 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726163AbgJ3V07 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 30 Oct 2020 17:26:59 -0400
Received: from galois.linutronix.de (Galois.linutronix.de [IPv6:2a0a:51c0:0:12e:550::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5F891C0613CF;
        Fri, 30 Oct 2020 14:26:59 -0700 (PDT)
From:   Thomas Gleixner <tglx@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1604093217;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=lNbtlaZ/0LN/46kZovZUcDI1Xg+UKquiVqEtTjo0iIE=;
        b=F7WuPLvWNOQWWuT91OMZTZb6yYnucYWeyyPUiS428UCfd2bZO6dDhRG8BDwU8MnIF7vUOU
        1sqn+X3GtGZPdL+ShOtU+2eChvO8xaGX+f5L0BiWP3QjsDzso7wJxOueNyQ+hxcMjjHfIX
        p/gv0UU56XSYSCG15oSvMUbWcbpaiiClzn/UFMYhNQRxIML+f1/LaBzdGHGdxR+uF5vqV2
        Hgg5K8EmlskQ1gNgPbyqxh8oeq6+cl8tqKBzx+X2ix0cPd6xWNu9oB5XUoPks1OqPY7f8f
        eCW+/6tDEokRzw1pDM+Qp1Nd6r5wHO88YE1bVVaAFBiJ3s9TkZamGFtykTJtoA==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1604093217;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=lNbtlaZ/0LN/46kZovZUcDI1Xg+UKquiVqEtTjo0iIE=;
        b=WTQ+SiV5y1AeRGWEP4cuQams5PRsxX8WkWaldViC8HL7AEz5qVHF3GxJwZLTF4uT2feC8K
        C6cmair8Fm+7QhCw==
To:     Dave Jiang <dave.jiang@intel.com>, vkoul@kernel.org,
        megha.dey@intel.com, maz@kernel.org, bhelgaas@google.com,
        alex.williamson@redhat.com, jacob.jun.pan@intel.com,
        ashok.raj@intel.com, jgg@mellanox.com, yi.l.liu@intel.com,
        baolu.lu@intel.com, kevin.tian@intel.com, sanjay.k.kumar@intel.com,
        tony.luck@intel.com, jing.lin@intel.com, dan.j.williams@intel.com,
        kwankhede@nvidia.com, eric.auger@redhat.com, parav@mellanox.com,
        jgg@mellanox.com, rafael@kernel.org, netanelg@mellanox.com,
        shahafs@mellanox.com, yan.y.zhao@linux.intel.com,
        pbonzini@redhat.com, samuel.ortiz@intel.com, mona.hossain@intel.com
Cc:     Megha Dey <megha.dey@linux.intel.com>, dmaengine@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org,
        kvm@vger.kernel.org
Subject: Re: [PATCH v4 13/17] dmaengine: idxd: ims setup for the vdcm
In-Reply-To: <160408393950.912050.6095700006969517668.stgit@djiang5-desk3.ch.intel.com>
References: <160408357912.912050.17005584526266191420.stgit@djiang5-desk3.ch.intel.com> <160408393950.912050.6095700006969517668.stgit@djiang5-desk3.ch.intel.com>
Date:   Fri, 30 Oct 2020 22:26:57 +0100
Message-ID: <875z6rmmla.fsf@nanos.tec.linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Oct 30 2020 at 11:52, Dave Jiang wrote:
> Add setup for IMS enabling for the mediated device.

....

> Register with the irq bypass manager in order to allow the IMS interrupt be
> injected into the guest and bypass the host.

Why is this part of the patch which adds IMS support? This are two
completely different things.

Again, Documentation/process/submitting-patches.rst is very clear about
this:
        Solve only one problem per patch.

You want me to review the IMS related things. Why are you mixing that
completely unrelated bypass stuff to it?

> +void vidxd_free_ims_entries(struct vdcm_idxd *vidxd)
> +{
> +	struct irq_domain *irq_domain;
> +	struct mdev_device *mdev = vidxd->vdev.mdev;
> +	struct device *dev = mdev_dev(mdev);
> +	int i;
> +
> +	for (i = 0; i < VIDXD_MAX_MSIX_VECS; i++)
> +		vidxd->irq_entries[i].entry = NULL;

See below.

> +	irq_domain = dev_get_msi_domain(dev);
> +	if (irq_domain)
> +		msi_domain_free_irqs(irq_domain, dev);
> +	else
> +		dev_warn(dev, "No IMS irq domain.\n");

How is the code even getting to this point if the domain allocation
failed in the first place?

> +int vidxd_setup_ims_entries(struct vdcm_idxd *vidxd)
> +{
> +	struct irq_domain *irq_domain;
> +	struct idxd_device *idxd = vidxd->idxd;
> +	struct mdev_device *mdev = vidxd->vdev.mdev;
> +	struct device *dev = mdev_dev(mdev);
> +	int vecs = VIDXD_MAX_MSIX_VECS - 1;

Some sensible comment about the -1 is missing here.

> +	struct msi_desc *entry;
> +	struct ims_irq_entry *irq_entry;
> +	int rc, i = 0;
> +
> +	irq_domain = idxd->ims_domain;
> +	dev_set_msi_domain(dev, irq_domain);
> +	rc = msi_domain_alloc_irqs(irq_domain, dev, vecs);
> +	if (rc < 0)
> +		return rc;
> +
> +	for_each_msi_entry(entry, dev) {
> +		irq_entry = &vidxd->irq_entries[i];
> +		irq_entry->vidxd = vidxd;
> +		irq_entry->entry = entry;

What's the business with storing the MSI entry here? Just to do this:

       ims_idx = vidxd->irq_entries[vidx - 1].entry->device_msi.hwirq;

and this:

      if (vidxd->irq_entries[i].entry->device_msi.hwirq == handle) {

What's wrong with storing the hardware interrupt index right here
instead of handing that pointer around? The usage sites have no reason
to know about the entry itself.

> +		irq_entry->id = i;

Again, what is the point of storing the array offset in the array slot?
If it _is_ useful then adding a comment is not too much asked for.

So the place I found which uses it cannot compute the index obviously,
but this:

        vidxd_send_interrupt(irq_entry->vidxd, irq_entry->id + 1);

is again just voodoo programming. Why can't you just provide a data set
which contains data ready for consumption at the usage site?

> diff --git a/kernel/irq/msi.c b/kernel/irq/msi.c
> index c7e47c26cd90..89cf60a30803 100644
> --- a/kernel/irq/msi.c
> +++ b/kernel/irq/msi.c
> @@ -536,6 +536,7 @@ int msi_domain_alloc_irqs(struct irq_domain *domain, struct device *dev,
>  
>  	return ops->domain_alloc_irqs(domain, dev, nvec);
>  }
> +EXPORT_SYMBOL(msi_domain_alloc_irqs);

Sigh... This want's to be a preperatory patch and the export wants to be
EXPORT_SYMBOL_GPL
  
Thanks,

        tglx
