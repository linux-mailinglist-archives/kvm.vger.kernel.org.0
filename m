Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A05A1395DF5
	for <lists+kvm@lfdr.de>; Mon, 31 May 2021 15:51:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231462AbhEaNwS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 31 May 2021 09:52:18 -0400
Received: from Galois.linutronix.de ([193.142.43.55]:54528 "EHLO
        galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233195AbhEaNuT (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 31 May 2021 09:50:19 -0400
From:   Thomas Gleixner <tglx@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1622468916;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=vUGnwmNIvLYO/jZ5MAEgJ5Gavah59hCALFrOBiJoZqI=;
        b=Z9KFwG7pRRZTRDn0/yTIkCk9q+AizJzq2LyjzGLBFpSyLxKBZuuhN2M73ceeyXTPlJWzeQ
        lSfO6N+k0zcBuVgJ1gNI6K8t2HPwka5ESixWVIgQzyuNZ1fbe21Z8tSIyyNqqCYgMdvW+a
        7MmclI3U4Id1O3kG7+na7hv7ZOMZfOHkr4i+DbSkpSrRa08W3Gbfasvvg+g88jbt5zP0ov
        Zjuc6HnwJZEj58hcv+cDIU99tqlh4ygJnq38wlsvbayXDazUNEs2OD6sQcZTtvBBzvvqih
        i5xhMdu/0UR2cJ3NWKtdpR8IAO5B9MiIwhv3KleTOBlJAsrZLtNTnuQuhwjl8w==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1622468916;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=vUGnwmNIvLYO/jZ5MAEgJ5Gavah59hCALFrOBiJoZqI=;
        b=fgBGrA82NlpiLod1V6elErM0dmOfr/lrDI4kEcD/i/R1ygN4NRQgHy2v0vh2DtzGY5+WTM
        0It9FDPY2Rf+WTBw==
To:     Dave Jiang <dave.jiang@intel.com>, alex.williamson@redhat.com,
        kwankhede@nvidia.com, vkoul@kernel.org, jgg@mellanox.com
Cc:     Jason Gunthorpe <jgg@nvidia.com>, megha.dey@intel.com,
        jacob.jun.pan@intel.com, ashok.raj@intel.com, yi.l.liu@intel.com,
        baolu.lu@intel.com, kevin.tian@intel.com, sanjay.k.kumar@intel.com,
        tony.luck@intel.com, dan.j.williams@intel.com,
        eric.auger@redhat.com, pbonzini@redhat.com,
        dmaengine@vger.kernel.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Subject: Re: [PATCH v6 05/20] vfio: mdev: common lib code for setting up Interrupt Message Store
In-Reply-To: <162164277624.261970.7989190254803052804.stgit@djiang5-desk3.ch.intel.com>
References: <162164243591.261970.3439987543338120797.stgit@djiang5-desk3.ch.intel.com> <162164277624.261970.7989190254803052804.stgit@djiang5-desk3.ch.intel.com>
Date:   Mon, 31 May 2021 15:48:35 +0200
Message-ID: <87pmx73tfw.ffs@nanos.tec.linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, May 21 2021 at 17:19, Dave Jiang wrote:
> Add common helper code to setup IMS once the MSI domain has been
> setup by the device driver. The main helper function is
> mdev_ims_set_msix_trigger() that is called by the VFIO ioctl
> VFIO_DEVICE_SET_IRQS. The function deals with the setup and
> teardown of emulated and IMS backed eventfd that gets exported
> to the guest kernel via VFIO as MSIX vectors.

So this talks about IMS, but the functionality is all named mdev_msix*
and mdev_irqs*. Confused.

> +/*
> + * Mediate device IMS library code

Mediated?

> +static int mdev_msix_set_vector_signal(struct mdev_irq *mdev_irq, int vector, int fd)
> +{
> +	int rc, irq;
> +	struct mdev_device *mdev = irq_to_mdev(mdev_irq);
> +	struct mdev_irq_entry *entry;
> +	struct device *dev = &mdev->dev;
> +	struct eventfd_ctx *trigger;
> +	char *name;
> +	bool pasid_en;
> +	u32 auxval;
> +
> +	if (vector < 0 || vector >= mdev_irq->num)
> +		return -EINVAL;
> +
> +	entry = &mdev_irq->irq_entries[vector];
> +
> +	if (entry->ims)
> +		irq = dev_msi_irq_vector(dev, entry->ims_id);
> +	else
> +		irq = 0;

I have no idea what this does. Comments are overrated...

Aside of that dev_msi_irq_vector() seems to be a gross misnomer. AFAICT
it retrieves the Linux interrupt number and not some vector.

> +	pasid_en = mdev_irq->pasid != INVALID_IOASID ? true : false;
> +
> +	/* IMS and invalid pasid is not a valid configuration */
> +	if (entry->ims && !pasid_en)
> +		return -EINVAL;

Why is this not validated already?

> +	if (entry->trigger) {
> +		if (irq) {
> +			irq_bypass_unregister_producer(&entry->producer);
> +			free_irq(irq, entry->trigger);
> +			if (pasid_en) {
> +				auxval = ims_ctrl_pasid_aux(0, false);
> +				irq_set_auxdata(irq, IMS_AUXDATA_CONTROL_WORD, auxval);

Why can't this be done in the irq chip when the interrupt is torn down?
Just because the irq chip driver, which is thankfully not merged yet,
has been implemented that way?

I did this aux dance because someone explained to me that this has to be
handled seperately and has to be changed independent of all the
interrupt setup and whatever. But looking at the actual usage now that's
clearly not the case.

What's the exact order of all this? I assume so:

    1) mdev_irqs_init()
    2) mdev_irqs_set_pasid()
    3) mdev_set_msix_trigger()

Right? See below.

> +}
> +EXPORT_SYMBOL_GPL(mdev_irqs_set_pasid);

> +	if (fd < 0)
> +		return 0;
> +
> +	name = kasprintf(GFP_KERNEL, "vfio-mdev-irq[%d](%s)", vector, dev_name(dev));
> +	if (!name)
> +		return -ENOMEM;
> +
> +	trigger = eventfd_ctx_fdget(fd);
> +	if (IS_ERR(trigger)) {
> +		kfree(name);
> +		return PTR_ERR(trigger);
> +	}
> +
> +	entry->name = name;
> +	entry->trigger = trigger;
> +
> +	if (!irq)
> +		return 0;

These exit conditions are completely confusing.

> +	if (pasid_en) {
> +		auxval = ims_ctrl_pasid_aux(mdev_irq->pasid, true);
> +		rc = irq_set_auxdata(irq, IMS_AUXDATA_CONTROL_WORD, auxval);
> +		if (rc < 0)
> +			goto err;

Again. This can be handled in the interrupt chip when the interrupt is
set up through request_irq().

> +static int mdev_msix_enable(struct mdev_irq *mdev_irq, int nvec)
> +{
> +	struct mdev_device *mdev = irq_to_mdev(mdev_irq);
> +	struct device *dev;
> +	int rc;
> +
> +	if (nvec != mdev_irq->num)
> +		return -EINVAL;
> +
> +	if (mdev_irq->ims_num) {
> +		dev = &mdev->dev;
> +		rc = msi_domain_alloc_irqs(dev_get_msi_domain(dev), dev, mdev_irq->ims_num);

The allocation of the interrupts happens _after_ PASID has been
set and PASID is per device, right?

So the obvious place to store PASID is in struct device because the
device pointer is for one stored in the msi entry descriptor and it is
also handed down to the irq domain allocation function. So this can be
checked at allocation time already.

What's unclear to me is under which circumstances does the IMS interrupt
require a PASID.

   1) Always
   2) Use case dependent

Thanks,

        tglx
