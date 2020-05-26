Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B668B1E3269
	for <lists+kvm@lfdr.de>; Wed, 27 May 2020 00:24:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2403804AbgEZWYG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 26 May 2020 18:24:06 -0400
Received: from mail.kernel.org ([198.145.29.99]:52286 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389382AbgEZWYF (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 26 May 2020 18:24:05 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2C7AA2088E;
        Tue, 26 May 2020 22:24:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1590531844;
        bh=bXODFjp8Ywv103gRNHs84HK8k9PGXpcMXjSq7DT/7fs=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=j4eKyEpL1PC9SI+vCPEhpXKks0e85FglRbYocyOQmR74KWkcCEL57g+UrOFObQPnA
         /YZfuGkJpViiBQzZ7C/dcpGVtZInnjlmRzhKGmMp5qm+TCiHxLEzCfWMxQQgn543XQ
         KY0Cg1S3lN/p4ZAwkGzRulMSOLJWsF/nCsIGMAlM=
Date:   Wed, 27 May 2020 00:24:02 +0200
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
Message-ID: <20200526222402.GC179549@kroah.com>
References: <20200525221334.62966-1-andraprs@amazon.com>
 <20200525221334.62966-8-andraprs@amazon.com>
 <20200526065133.GD2580530@kroah.com>
 <72647fa4-79d9-7754-9843-a254487703ea@amazon.de>
 <20200526123300.GA2798@kroah.com>
 <59007eb9-fad3-9655-a856-f5989fa9fdb3@amazon.de>
 <20200526131708.GA9296@kroah.com>
 <29ebdc29-2930-51af-8a54-279c1e449a48@amazon.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <29ebdc29-2930-51af-8a54-279c1e449a48@amazon.de>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, May 26, 2020 at 03:44:30PM +0200, Alexander Graf wrote:
> 
> 
> On 26.05.20 15:17, Greg KH wrote:
> > 
> > On Tue, May 26, 2020 at 02:44:18PM +0200, Alexander Graf wrote:
> > > 
> > > 
> > > On 26.05.20 14:33, Greg KH wrote:
> > > > 
> > > > On Tue, May 26, 2020 at 01:42:41PM +0200, Alexander Graf wrote:
> > > > > 
> > > > > 
> > > > > On 26.05.20 08:51, Greg KH wrote:
> > > > > > 
> > > > > > On Tue, May 26, 2020 at 01:13:23AM +0300, Andra Paraschiv wrote:
> > > > > > > +#define NE "nitro_enclaves: "
> > > > > > 
> > > > > > Again, no need for this.
> > > > > > 
> > > > > > > +#define NE_DEV_NAME "nitro_enclaves"
> > > > > > 
> > > > > > KBUILD_MODNAME?
> > > > > > 
> > > > > > > +#define NE_IMAGE_LOAD_OFFSET (8 * 1024UL * 1024UL)
> > > > > > > +
> > > > > > > +static char *ne_cpus;
> > > > > > > +module_param(ne_cpus, charp, 0644);
> > > > > > > +MODULE_PARM_DESC(ne_cpus, "<cpu-list> - CPU pool used for Nitro Enclaves");
> > > > > > 
> > > > > > Again, please do not do this.
> > > > > 
> > > > > I actually asked her to put this one in specifically.
> > > > > 
> > > > > The concept of this parameter is very similar to isolcpus= and maxcpus= in
> > > > > that it takes CPUs away from Linux and instead donates them to the
> > > > > underlying hypervisor, so that it can spawn enclaves using them.
> > > > > 
> > > > >   From an admin's point of view, this is a setting I would like to keep
> > > > > persisted across reboots. How would this work with sysfs?
> > > > 
> > > > How about just as the "initial" ioctl command to set things up?  Don't
> > > > grab any cpu pools until asked to.  Otherwise, what happens when you
> > > > load this module on a system that can't support it?
> > > 
> > > That would give any user with access to the enclave device the ability to
> > > remove CPUs from the system. That's clearly a CAP_ADMIN task in my book.
> > 
> > Ok, what's wrong with that?
> 
> Would you want random users to get the ability to hot unplug CPUs from your
> system? At unlimited quantity? I don't :).

A random user, no, but one with admin rights, why not?  They can do that
already today on your system, this isn't new.

> > > Hence this whole split: The admin defines the CPU Pool, users can safely
> > > consume this pool to spawn enclaves from it.
> > 
> > But having the admin define that at module load / boot time, is a major
> > pain.  What tools do they have that allow them to do that easily?
> 
> The normal toolbox: editing /etc/default/grub, adding an /etc/modprobe.d/
> file.

Editing grub files is horrid, come on...

> When but at module load / boot time would you define it? I really don't want
> to have a device node that in theory "the world" can use which then allows
> any user on the system to hot unplug every CPU but 0 from my system.

But you have that already when the PCI device is found, right?  What is
the initial interface to the driver?  What's wrong with using that?

Or am I really missing something as to how this all fits together with
the different pieces?  Seeing the patches as-is doesn't really provide a
good overview, sorry.

> > > So I really don't think an ioctl would be a great user experience. Same for
> > > a sysfs file - although that's probably slightly better than the ioctl.
> > 
> > You already are using ioctls to control this thing, right?  What's wrong
> > with "one more"? :)
> 
> So what we *could* do is add an ioctl to set the pool size which then does a
> CAP_ADMIN check. That however means you now are in priority hell:
> 
> A user that wants to spawn an enclave as part of an nginx service would need
> to create another service to set the pool size and indicate the dependency
> in systemd control files.
> 
> Is that really better than a module parameter?

module parameters are hard to change, and manage control over who really
is changing them.

thanks,

greg k-h
