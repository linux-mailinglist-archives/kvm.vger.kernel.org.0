Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EC705395921
	for <lists+kvm@lfdr.de>; Mon, 31 May 2021 12:41:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231426AbhEaKnd (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 31 May 2021 06:43:33 -0400
Received: from Galois.linutronix.de ([193.142.43.55]:53646 "EHLO
        galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231409AbhEaKnH (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 31 May 2021 06:43:07 -0400
From:   Thomas Gleixner <tglx@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1622457686;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to; bh=DkYWBZqlHfDLHs3VHHFUBhkPLWH2ujbiiCtKaGt9OtQ=;
        b=kbzeZ8HzzmHvgOCTjbZY5uO8IB+f2P1hWy09rAQnAK9BajcqlRlz7Vb2pVN93vxRC0jakC
        1VYEFmZkuqoj1WBL5rduadQ607w9N2MN84Od15JjMpz8STZhdbO4EtRO8tQ0t2kydC3zET
        GWRqm1j/Xl85y8DNsY/7qjRDTGTpfy56MezIh9zA6VPyepkG1hNOjD+TOkUL3yOoB1aDmb
        aGWlqbm5pootOphYg6oX3F3QASAopGDpEMU5sF1P0UK72Vo9hrkeufTy1J8lG0jFiFBko8
        ScdXGt6I4IPnd8n6XjgWVxWJpSpKQVPOu/CBArbMGCl1Owwn79wLc7fdirj8ZQ==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1622457686;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to; bh=DkYWBZqlHfDLHs3VHHFUBhkPLWH2ujbiiCtKaGt9OtQ=;
        b=HE9eE0UX5y+lRuLEaHmipJm7gxrOIieS0Yq85ci2o6WS45RWZl/WDd3g9+lTuhWiSfXtR+
        g8kAEvB2DD/J5WAQ==
To:     Jason Gunthorpe <jgg@nvidia.com>, Dave Jiang <dave.jiang@intel.com>
Cc:     alex.williamson@redhat.com, kwankhede@nvidia.com, vkoul@kernel.org,
        megha.dey@intel.com, jacob.jun.pan@intel.com, ashok.raj@intel.com,
        yi.l.liu@intel.com, baolu.lu@intel.com, kevin.tian@intel.com,
        sanjay.k.kumar@intel.com, tony.luck@intel.com,
        dan.j.williams@intel.com, eric.auger@redhat.com,
        pbonzini@redhat.com, dmaengine@vger.kernel.org,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Subject: Re: [PATCH v6 05/20] vfio: mdev: common lib code for setting up Interrupt Message Store
In-Reply-To: <20210528163906.GN1002214@nvidia.com>
Date:   Mon, 31 May 2021 12:41:25 +0200
Message-ID: <87tumj423u.ffs@nanos.tec.linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, May 28 2021 at 13:39, Jason Gunthorpe wrote:
> On Fri, May 28, 2021 at 09:37:56AM -0700, Dave Jiang wrote:
>> On 5/28/2021 5:21 AM, Jason Gunthorpe wrote:
>> > On Thu, May 27, 2021 at 06:49:59PM -0700, Dave Jiang wrote:
>> > > > > +static int mdev_msix_enable(struct mdev_irq *mdev_irq, int nvec)
>> > > > > +{
>> > > > > +	struct mdev_device *mdev = irq_to_mdev(mdev_irq);
>> > > > > +	struct device *dev;
>> > > > > +	int rc;
>> > > > > +
>> > > > > +	if (nvec != mdev_irq->num)
>> > > > > +		return -EINVAL;
>> > > > > +
>> > > > > +	if (mdev_irq->ims_num) {
>> > > > > +		dev = &mdev->dev;
>> > > > > +		rc = msi_domain_alloc_irqs(dev_get_msi_domain(dev), dev, mdev_irq->ims_num);
>> > > >
>> > > > Huh? The PCI device should be the only device touching IRQ stuff. I'm
>> > > > nervous to see you mix in the mdev struct device into this function.
>> > >
>> > > As we talked about in the other thread. We have a single IMS domain per
>> > > device. The domain is set to the mdev 'struct device' and we allocate the
>> > > vectors to each mdev 'struct device' so we can manage those IMS vectors
>> > > specifically for that mdev.
>> >
>> > That is not the point, I'm asking if you should be calling
>> > dev_set_msi_domain(mdev) at all
>> 
>> I'm not familiar with the standard way of doing this. Should I not set the
>> domain to the mdev 'struct device' because I can have multiple mdev using
>> the same domain? With the domain set, I am able to retrieve it and call the
>> msi_domain_alloc_irqs() in common code. Alternatively we can pass in the
>> domain during init and not rely on dev->msi_
>
> Honestly, I don't know. I would prefer Thomas confirm what is the
> correct way to use the msi_domain as IDXD is going to be the reference
> everyone copies.

The general expectation is that the MSI irqdomain is retrievable from
struct device for any device which supports MSI.

Thanks,

        tglx


