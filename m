Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2288120F026
	for <lists+kvm@lfdr.de>; Tue, 30 Jun 2020 10:05:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731049AbgF3IFs (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 30 Jun 2020 04:05:48 -0400
Received: from mail.kernel.org ([198.145.29.99]:43254 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731014AbgF3IFk (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 30 Jun 2020 04:05:40 -0400
Received: from localhost (unknown [84.241.197.94])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5CF7620759;
        Tue, 30 Jun 2020 08:05:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1593504339;
        bh=wWSfqiUJtrzmxK9QO1B29WqsNSrAagcMWusAIHro7NQ=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=tYqMAa4Nd7/QQaLSl6ZDhsRRStDPBlHasRsgQqYmx4sAZmlT+ILY1dUldkLRD5US4
         7pJVlXmVnl+mV/LwNxdkXhEAWQWYp2AWEgx1M5k9wAVWZPFY+MTMQx8bsGoMNkEILf
         RrgyRHwQkgVZDvHhe9PVJtWt1F7Bxp4EQab2rmMU=
Date:   Tue, 30 Jun 2020 10:05:35 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     "Paraschiv, Andra-Irina" <andraprs@amazon.com>
Cc:     linux-kernel@vger.kernel.org,
        Anthony Liguori <aliguori@amazon.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Colm MacCarthaigh <colmmacc@amazon.com>,
        Bjoern Doebel <doebel@amazon.de>,
        David Woodhouse <dwmw@amazon.co.uk>,
        Frank van der Linden <fllinden@amazon.com>,
        Alexander Graf <graf@amazon.de>,
        Martin Pohlack <mpohlack@amazon.de>,
        Matt Wilson <msw@amazon.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Balbir Singh <sblbir@amazon.com>,
        Stefano Garzarella <sgarzare@redhat.com>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        Stewart Smith <trawets@amazon.com>,
        Uwe Dannowski <uwed@amazon.de>, kvm@vger.kernel.org,
        ne-devel-upstream@amazon.com
Subject: Re: [PATCH v4 07/18] nitro_enclaves: Init misc device providing the
 ioctl interface
Message-ID: <20200630080535.GD619174@kroah.com>
References: <20200622200329.52996-1-andraprs@amazon.com>
 <20200622200329.52996-8-andraprs@amazon.com>
 <20200629162013.GA718066@kroah.com>
 <b87e2eeb-39cf-8de5-0f5f-1db04b3e2794@amazon.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b87e2eeb-39cf-8de5-0f5f-1db04b3e2794@amazon.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Jun 29, 2020 at 08:45:25PM +0300, Paraschiv, Andra-Irina wrote:
> 
> 
> On 29/06/2020 19:20, Greg KH wrote:
> > 
> > On Mon, Jun 22, 2020 at 11:03:18PM +0300, Andra Paraschiv wrote:
> > > +static int __init ne_init(void)
> > > +{
> > > +     struct pci_dev *pdev = pci_get_device(PCI_VENDOR_ID_AMAZON,
> > > +                                           PCI_DEVICE_ID_NE, NULL);
> > > +     int rc = -EINVAL;
> > > +
> > > +     if (!pdev)
> > > +             return -ENODEV;
> > Ick, that's a _very_ old-school way of binding to a pci device.  Please
> > just be a "real" pci driver and your probe function will be called if
> > your hardware is present (or when it shows up.)  To do it this way
> > prevents your driver from being auto-loaded for when your hardware is
> > seen in the system, as well as lots of other things.
> 
> This check is mainly here in the case any codebase is added before the pci
> driver register call below.

What do you mean by "codebase"?  You control this driver, just do all of
the logic in the probe() function, no need to do this in the module init
call.

> And if we log any error with dev_err() instead of pr_err() before the driver
> register.

Don't do that.

> That check was only for logging purposes, if done with dev_err(). I removed
> the check in v5.

Again, don't do it :)

> 
> > > +
> > > +     if (!zalloc_cpumask_var(&ne_cpu_pool.avail, GFP_KERNEL))
> > > +             return -ENOMEM;
> > > +
> > > +     mutex_init(&ne_cpu_pool.mutex);
> > > +
> > > +     rc = pci_register_driver(&ne_pci_driver);
> > Nice, you did it right here, but why the above crazy test?
> > 
> > > +     if (rc < 0) {
> > > +             dev_err(&pdev->dev,
> > > +                     "Error in pci register driver [rc=%d]\n", rc);
> > > +
> > > +             goto free_cpumask;
> > > +     }
> > > +
> > > +     return 0;
> > You leaked a reference on that pci device, didn't you?  Not good :(
> 
> Yes, the pci get device call needs its pair - pci_dev_put(). I added it here
> and for the other occurrences where it was missing.

Again, just don't do it and then you don't have to worry about any of
this.

thanks,

greg k-h
