Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B45151E22D5
	for <lists+kvm@lfdr.de>; Tue, 26 May 2020 15:17:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729079AbgEZNRM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 26 May 2020 09:17:12 -0400
Received: from mail.kernel.org ([198.145.29.99]:59010 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727009AbgEZNRM (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 26 May 2020 09:17:12 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id ACFA42084C;
        Tue, 26 May 2020 13:17:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1590499031;
        bh=egI/LvLS2AXB3+lf2+0PQAeIwQPh1OllZaCbHGvcvDU=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=RSR614FCRHoFfDR65URe9ilJwa4jTUBvqwrElqhm1tALkKH0XLyolqxid1Ya6lIqe
         FywkMzprZJtWrBDKwkIhL9ImnNUFTSTMeMZ+4tAzwY4qICHDh3ML+srhaibw6pJo+H
         j8eyoEFK9WFns94nrlaRP3+Wy3XzptIwtxvAkDjY=
Date:   Tue, 26 May 2020 15:17:08 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Alexander Graf <graf@amazon.de>
Cc:     Andra Paraschiv <andraprs@amazon.com>,
        linux-kernel@vger.kernel.org,
        Anthony Liguori <aliguori@amazon.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Colm MacCarthaigh <colmmacc@amazon.com>,
        Bjoern Doebel <doebel@amazon.de>,
        David Woodhouse <dwmw@amazon.co.uk>,
        Frank van der Linden <fllinden@amazon.com>,
        Martin Pohlack <mpohlack@amazon.de>,
        Matt Wilson <msw@amazon.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Balbir Singh <sblbir@amazon.com>,
        Stefano Garzarella <sgarzare@redhat.com>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        Stewart Smith <trawets@amazon.com>,
        Uwe Dannowski <uwed@amazon.de>, kvm@vger.kernel.org,
        ne-devel-upstream@amazon.com
Subject: Re: [PATCH v3 07/18] nitro_enclaves: Init misc device providing the
 ioctl interface
Message-ID: <20200526131708.GA9296@kroah.com>
References: <20200525221334.62966-1-andraprs@amazon.com>
 <20200525221334.62966-8-andraprs@amazon.com>
 <20200526065133.GD2580530@kroah.com>
 <72647fa4-79d9-7754-9843-a254487703ea@amazon.de>
 <20200526123300.GA2798@kroah.com>
 <59007eb9-fad3-9655-a856-f5989fa9fdb3@amazon.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <59007eb9-fad3-9655-a856-f5989fa9fdb3@amazon.de>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, May 26, 2020 at 02:44:18PM +0200, Alexander Graf wrote:
> 
> 
> On 26.05.20 14:33, Greg KH wrote:
> > 
> > On Tue, May 26, 2020 at 01:42:41PM +0200, Alexander Graf wrote:
> > > 
> > > 
> > > On 26.05.20 08:51, Greg KH wrote:
> > > > 
> > > > On Tue, May 26, 2020 at 01:13:23AM +0300, Andra Paraschiv wrote:
> > > > > +#define NE "nitro_enclaves: "
> > > > 
> > > > Again, no need for this.
> > > > 
> > > > > +#define NE_DEV_NAME "nitro_enclaves"
> > > > 
> > > > KBUILD_MODNAME?
> > > > 
> > > > > +#define NE_IMAGE_LOAD_OFFSET (8 * 1024UL * 1024UL)
> > > > > +
> > > > > +static char *ne_cpus;
> > > > > +module_param(ne_cpus, charp, 0644);
> > > > > +MODULE_PARM_DESC(ne_cpus, "<cpu-list> - CPU pool used for Nitro Enclaves");
> > > > 
> > > > Again, please do not do this.
> > > 
> > > I actually asked her to put this one in specifically.
> > > 
> > > The concept of this parameter is very similar to isolcpus= and maxcpus= in
> > > that it takes CPUs away from Linux and instead donates them to the
> > > underlying hypervisor, so that it can spawn enclaves using them.
> > > 
> > >  From an admin's point of view, this is a setting I would like to keep
> > > persisted across reboots. How would this work with sysfs?
> > 
> > How about just as the "initial" ioctl command to set things up?  Don't
> > grab any cpu pools until asked to.  Otherwise, what happens when you
> > load this module on a system that can't support it?
> 
> That would give any user with access to the enclave device the ability to
> remove CPUs from the system. That's clearly a CAP_ADMIN task in my book.

Ok, what's wrong with that?

> Hence this whole split: The admin defines the CPU Pool, users can safely
> consume this pool to spawn enclaves from it.

But having the admin define that at module load / boot time, is a major
pain.  What tools do they have that allow them to do that easily?

> So I really don't think an ioctl would be a great user experience. Same for
> a sysfs file - although that's probably slightly better than the ioctl.

You already are using ioctls to control this thing, right?  What's wrong
with "one more"? :)

> Other options I can think of:
> 
>   * sysctl (for modules?)

Ick.

>   * module parameter (as implemented here)

Ick.

>   * proc file (deprecated FWIW)

Ick.

> The key is the tenant split: Admin sets the pool up, user consumes. This
> setup should happen (early) on boot, so that system services can spawn
> enclaves.

But it takes more than jus this initial "split up" to set the pool up,
right?  Why not make this part of that initial process?  What makes this
so special you have to do this at module load time only?

thanks,

greg k-h
