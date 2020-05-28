Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D5CE31E61E0
	for <lists+kvm@lfdr.de>; Thu, 28 May 2020 15:13:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390199AbgE1NNE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 28 May 2020 09:13:04 -0400
Received: from mail.kernel.org ([198.145.29.99]:59602 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390131AbgE1NND (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 28 May 2020 09:13:03 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 95899207F5;
        Thu, 28 May 2020 13:13:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1590671582;
        bh=0LoxBSgj9kjgSMU2tdRzJ0q0gLxGcXYoAwi3ISbj/ko=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=gUuo1ofJk4pp4/+5nVmfM7chE03J6X4AU5dppXFuENOtzyMsWe8I3mqMqfmD1ysF6
         uJZgHzyZl++IoJkiYpUHcYPF9TA6ww1JarejzIpnID4Cfmp2/OdUcjYWOhBhaddk+L
         2PWDYdz3dUg+CmplVTQ10eGFbd+Gg3E0a5yn9EUU=
Date:   Thu, 28 May 2020 15:12:59 +0200
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
Message-ID: <20200528131259.GA3345766@kroah.com>
References: <20200525221334.62966-1-andraprs@amazon.com>
 <20200525221334.62966-8-andraprs@amazon.com>
 <20200526065133.GD2580530@kroah.com>
 <72647fa4-79d9-7754-9843-a254487703ea@amazon.de>
 <20200526123300.GA2798@kroah.com>
 <59007eb9-fad3-9655-a856-f5989fa9fdb3@amazon.de>
 <20200526131708.GA9296@kroah.com>
 <29ebdc29-2930-51af-8a54-279c1e449a48@amazon.de>
 <20200526222402.GC179549@kroah.com>
 <b4f17cbd-7471-fe61-6e7e-1399bd96e24e@amazon.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b4f17cbd-7471-fe61-6e7e-1399bd96e24e@amazon.de>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, May 28, 2020 at 03:01:36PM +0200, Alexander Graf wrote:
> 
> 
> On 27.05.20 00:24, Greg KH wrote:
> > 
> > On Tue, May 26, 2020 at 03:44:30PM +0200, Alexander Graf wrote:
> > > 
> > > 
> > > On 26.05.20 15:17, Greg KH wrote:
> > > > 
> > > > On Tue, May 26, 2020 at 02:44:18PM +0200, Alexander Graf wrote:
> > > > > 
> > > > > 
> > > > > On 26.05.20 14:33, Greg KH wrote:
> > > > > > 
> > > > > > On Tue, May 26, 2020 at 01:42:41PM +0200, Alexander Graf wrote:
> > > > > > > 
> > > > > > > 
> > > > > > > On 26.05.20 08:51, Greg KH wrote:
> > > > > > > > 
> > > > > > > > On Tue, May 26, 2020 at 01:13:23AM +0300, Andra Paraschiv wrote:
> > > > > > > > > +#define NE "nitro_enclaves: "
> > > > > > > > 
> > > > > > > > Again, no need for this.
> > > > > > > > 
> > > > > > > > > +#define NE_DEV_NAME "nitro_enclaves"
> > > > > > > > 
> > > > > > > > KBUILD_MODNAME?
> > > > > > > > 
> > > > > > > > > +#define NE_IMAGE_LOAD_OFFSET (8 * 1024UL * 1024UL)
> > > > > > > > > +
> > > > > > > > > +static char *ne_cpus;
> > > > > > > > > +module_param(ne_cpus, charp, 0644);
> > > > > > > > > +MODULE_PARM_DESC(ne_cpus, "<cpu-list> - CPU pool used for Nitro Enclaves");
> > > > > > > > 
> > > > > > > > Again, please do not do this.
> > > > > > > 
> > > > > > > I actually asked her to put this one in specifically.
> > > > > > > 
> > > > > > > The concept of this parameter is very similar to isolcpus= and maxcpus= in
> > > > > > > that it takes CPUs away from Linux and instead donates them to the
> > > > > > > underlying hypervisor, so that it can spawn enclaves using them.
> > > > > > > 
> > > > > > >    From an admin's point of view, this is a setting I would like to keep
> > > > > > > persisted across reboots. How would this work with sysfs?
> > > > > > 
> > > > > > How about just as the "initial" ioctl command to set things up?  Don't
> > > > > > grab any cpu pools until asked to.  Otherwise, what happens when you
> > > > > > load this module on a system that can't support it?
> > > > > 
> > > > > That would give any user with access to the enclave device the ability to
> > > > > remove CPUs from the system. That's clearly a CAP_ADMIN task in my book.
> > > > 
> > > > Ok, what's wrong with that?
> > > 
> > > Would you want random users to get the ability to hot unplug CPUs from your
> > > system? At unlimited quantity? I don't :).
> > 
> > A random user, no, but one with admin rights, why not?  They can do that
> > already today on your system, this isn't new.
> > 
> > > > > Hence this whole split: The admin defines the CPU Pool, users can safely
> > > > > consume this pool to spawn enclaves from it.
> > > > 
> > > > But having the admin define that at module load / boot time, is a major
> > > > pain.  What tools do they have that allow them to do that easily?
> > > 
> > > The normal toolbox: editing /etc/default/grub, adding an /etc/modprobe.d/
> > > file.
> > 
> > Editing grub files is horrid, come on...
> 
> It's not editing grub files, it's editing template config files that then
> are used as input for grub config file generation :).
> 
> > > When but at module load / boot time would you define it? I really don't want
> > > to have a device node that in theory "the world" can use which then allows
> > > any user on the system to hot unplug every CPU but 0 from my system.
> > 
> > But you have that already when the PCI device is found, right?  What is
> > the initial interface to the driver?  What's wrong with using that?
> > 
> > Or am I really missing something as to how this all fits together with
> > the different pieces?  Seeing the patches as-is doesn't really provide a
> > good overview, sorry.
> 
> Ok, let me walk you through the core donation process.
> 
> Imagine you have a parent VM with 8 cores. Every one of those virtual cores
> is 1:1 mapped to a physical core.
> 
> You enumerate the PCI device, you start working with it. None of that
> changes your topology.
> 
> You now create an enclave spanning 2 cores. The hypervisor will remove the
> 1:1 map for those 2 cores and instead mark them as "free floating" on the
> remaining 6 cores. It then uses the 2 freed up cores and creates a 1:1 map
> for the enclave's 2 cores
> 
> To ensure that we still see a realistic mapping of core topology, we need to
> remove those 2 cores from the parent VM's scope of execution. The way this
> is done today is by going through CPU offlining.
> 
> The first and obvious option would be to offline all respective CPUs when an
> enclave gets created. But unprivileged users should be able to spawn
> enclaves. So how do I ensure that my unprivileged user doesn't just offline
> all of my parent VM's CPUs?
> 
> The option implemented here is that we fold this into a two-stage approach.
> The admin reserves a "pool" of cores for enclaves to use. Unprivileged users
> can then consume cores from that pool, but not more than those.
> 
> That way, unprivileged users have no influence over whether a core is
> enabled or not. They can only consume the pool of cores that was dedicated
> for enclave use.
> 
> It also has the big advantage that you don't have dynamically changing CPU
> topology in your system. Long living processes that adjust their environment
> to the topology can still do so, without cores getting pulled out under
> their feet.

Ok, that makes more sense, but:

> > > > > So I really don't think an ioctl would be a great user experience. Same for
> > > > > a sysfs file - although that's probably slightly better than the ioctl.
> > > > 
> > > > You already are using ioctls to control this thing, right?  What's wrong
> > > > with "one more"? :)
> > > 
> > > So what we *could* do is add an ioctl to set the pool size which then does a
> > > CAP_ADMIN check. That however means you now are in priority hell:
> > > 
> > > A user that wants to spawn an enclave as part of an nginx service would need
> > > to create another service to set the pool size and indicate the dependency
> > > in systemd control files.
> > > 
> > > Is that really better than a module parameter?
> > 
> > module parameters are hard to change, and manage control over who really
> > is changing them.
> 
> What is hard about
> 
> $ echo 1-5 > /sys/module/nitro_enclaves/parameters/ne_cpus

So at runtime, after all is booted and up and going, you just ripped
cores out from under someone's feet?  :)

And the code really handles writing to that value while the module is
already loaded and up and running?  At a quick glance, it didn't seem
like it would handle that very well as it only is checked at ne_init()
time.

Or am I missing something?

Anyway, yes, if you can dynamically do this at runtime, that's great,
but it feels ackward to me to rely on one configuration thing as a
module parameter, and everything else through the ioctl interface.
Unification would seem to be a good thing, right?

thanks,

greg k-h
