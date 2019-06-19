Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3AD314B5B2
	for <lists+kvm@lfdr.de>; Wed, 19 Jun 2019 11:57:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731358AbfFSJ5y (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 19 Jun 2019 05:57:54 -0400
Received: from mx1.redhat.com ([209.132.183.28]:51408 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726479AbfFSJ5y (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 19 Jun 2019 05:57:54 -0400
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id B8E5430872F5;
        Wed, 19 Jun 2019 09:57:53 +0000 (UTC)
Received: from gondolin (dhcp-192-192.str.redhat.com [10.33.192.192])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 2027619C5B;
        Wed, 19 Jun 2019 09:57:36 +0000 (UTC)
Date:   Wed, 19 Jun 2019 11:57:34 +0200
From:   Cornelia Huck <cohuck@redhat.com>
To:     Sylvain Bauza <sbauza@redhat.com>
Cc:     Alex Williamson <alex.williamson@redhat.com>,
        "Daniel P. =?UTF-8?B?QmVycmFuZ8Op?=" <berrange@redhat.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        Libvirt Devel <libvir-list@redhat.com>,
        Kirti Wankhede <kwankhede@nvidia.com>,
        Erik Skultety <eskultet@redhat.com>,
        Pavel Hrdina <phrdina@redhat.com>
Subject: Re: mdevctl: A shoestring mediated device management and
 persistence utility
Message-ID: <20190619115734.59b3b6bb.cohuck@redhat.com>
In-Reply-To: <CALOCmu=6Xmw-_-SVXujCEcgPY2CQiBQKgfUMJ45WnZ_9XORyUw@mail.gmail.com>
References: <20190523172001.41f386d8@x1.home>
        <20190617140000.GA2021@redhat.com>
        <20190617085438.07607e8b@x1.home>
        <20190617151030.GG3380@redhat.com>
        <20190617110517.353b4f16@x1.home>
        <20190618130148.43ba5837.cohuck@redhat.com>
        <CALOCmukPWiXiM+mN0hCTvSwfdHy5UdERU8WnvOXiBrMQ9tH3VA@mail.gmail.com>
        <20190618161210.053d6550@x1.home>
        <CALOCmu=6Xmw-_-SVXujCEcgPY2CQiBQKgfUMJ45WnZ_9XORyUw@mail.gmail.com>
Organization: Red Hat GmbH
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.47]); Wed, 19 Jun 2019 09:57:53 +0000 (UTC)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, 19 Jun 2019 11:04:15 +0200
Sylvain Bauza <sbauza@redhat.com> wrote:

> On Wed, Jun 19, 2019 at 12:27 AM Alex Williamson <alex.williamson@redhat.com>
> wrote:
> 
> > On Tue, 18 Jun 2019 14:48:11 +0200
> > Sylvain Bauza <sbauza@redhat.com> wrote:
> >  
> > > On Tue, Jun 18, 2019 at 1:01 PM Cornelia Huck <cohuck@redhat.com> wrote:

> > > > I think we need to reach consensus about the actual scope of the
> > > > mdevctl tool.
> > > >
> > > >  
> > > Thanks Cornelia, my thoughts:
> > >
> > > - Is it supposed to be responsible for managing *all* mdev devices in  
> > > >   the system, or is it more supposed to be a convenience helper for
> > > >   users/software wanting to manage mdevs?
> > > >  
> > >
> > > The latter. If an operator (or some software) wants to create mdevs by  
> > not  
> > > using mdevctl (and rather directly calling the sysfs), I think it's OK.
> > > That said, mdevs created by mdevctl would be supported by systemctl,  
> > while  
> > > the others not but I think it's okay.  
> >
> > I agree (sort of), and I'm hearing that we should drop any sort of
> > automatic persistence of mdevs created outside of mdevctl.  The problem
> > comes when we try to draw the line between unmanaged and manged
> > devices.  For instance, if we have a command to list mdevs it would
> > feel incomplete if it didn't list all mdevs both those managed by
> > mdevctl and those created elsewhere.  For managed devices, I expect
> > we'll also have commands that allow the mode of the device to be
> > switched between transient, saved, and persistent.  Should a user then
> > be allowed to promote an unmanaged device to one of these modes via the
> > same command?  Should they be allowed to stop an unmanaged device
> > through driverctl?  Through systemctl?  These all seem like reasonable
> > things to do, so what then is the difference between transient and
> > unmanaged mdev and is mdevctl therefore managing all mdevs, not just
> > those it has created?
> >
> >  
> Well, IMHO, mdevs created by mdevctl could all be persisted or transient
> just by adding an option when calling mdevctl, like :
> "mdevctl create-mdev [--transient] <uuid> <pci_id> <type>" where default
> would be persisting the mdev.

This sounds useful; the caller can avoid fiddling with sysfs entries
directly, while not committing to a permanent configuration.

> 
> For mdevs *not* created by mdevctl, then a usecase could be "I'd like to
> ask mdevctl to manage mdevs I already created" and if so, a mdevctl command
> like :
> "mdevctl manage-mdev [--transient] <mdev_uuid>"

What kind of 'managing' would this actually enable? If we rely on
mdevctl working with sysfs directly for transient devices, I can't
really think of anything...

> 
> Of course, that would mean that when you list mdevs by "mdev list-all" you
> wouldn't get mdevs managed by mdevctl.
> Thoughts ?
> 
> > - Do we want mdevctl to manage config files for individual mdevs, or  
> > > >   are they supposed to be in a common format that can also be managed
> > > >   by e.g. libvirt?
> > > >  
> > >
> > > Unless I misunderstand, I think mdevctl just helps to create mdevs for
> > > being used by guests created either by libvirt or QEMU or even others.
> > > How a guest would allocate a mdev (ie. saying "I'll use this specific  
> > mdev  
> > > UUID") is IMHO not something for mdevctl.  
> >
> > Right, mdevctl isn't concerned with how a specific mdev is used, but I
> > think what Connie is after is more the proposal from Daniel where
> > libvirt can essentially manage mdevctl config files itself and then
> > only invoke mdevctl for the dirty work of creating and deleting
> > devices.  In fact, assuming systemd, libvirt could avoid direct
> > interaction with mdevctl entirely, instead using systemctl device units
> > to start and stop the mdevs.  Maybe where that proposal takes a turn is
> > when we again consider non-systemd hosts, where maybe mdevctl needs to
> > write out an init script per mdev and libvirt injecting itself into
> > manipulation of the config files would either need to perform the same
> > or fall back to mdevctl.  Unfortunately there seems to be an ultimatum
> > to either condone external config file manipulation or expand the scope
> > of the project into becoming a library.
> >
> >  
> Well, like I said, I think it's maybe another user case : just using
> libvirt when you want a guest having vGPUs and then libvirt would create
> mdevs (so users wouln't need to know at that).
> That said, for the moment, I think we don't really need it so maybe a new
> RFE once we at least have mdevctl packaged and supported by RHEL ?

If we allow config file handling directly, libvirt could start using it
even without mdevctl present? (Not sure if that makes sense.)

> 
> 
> > - Should mdevctl be a stand-alone tool, provide library functions, or  
> > > >   both? Related: should it keep any internal state that is not written
> > > >   to disk? (I think that also plays into the transient vs. persistent
> > > >   question.)  
> >
> > I don't think we want an mdevctld, if that's what you mean by internal

Yeah, mdevctld--.

> > state not written to disk.  I think we ideally want all state in the
> > mdev config files or discerned through sysfs.  How we handle
> > non-systemd hosts may throw a wrench in that though since currently the
> > systemd integration relies on a template to support arbitrary mdevs and
> > I'm not sure how to replicate that in other init services.  If we need
> > to dynamically manage per mdev init files in addition to config files,
> > we're not so self contained.
> >  
> > > FWIW, I'd love using mdevctl for OpenStack (Nova) just at least for
> > > creating persisted mdevs (ie. mdevs that would be recreated after  
> > rebooting  
> > > using systemctl). That's the real use case I need.
> > > Whether libvirt would internally support mdevctl would be nice but that's
> > > not really something Nova needs, so I leave others providing their own
> > > thoughts.
> > >
> > >
> > > My personal opinion is that mdevctl should be able to tolerate mdevs  
> > > > being configured by other means, but probably should not try to impose
> > > > its own configuration if it detects that (unless explicitly asked to do
> > > > so). Not sure how feasible that goal is.
> > > >
> > > > That's what I misunderstand : in order to have a guest using a vGPU,  
> > you  
> > > need to do two things :
> > > 1/ create the mdev
> > > 2/ allocate this created dev to a specific guest config
> > >
> > > Of course, we could imagine a way to have both steps to be done directly  
> > by  
> > > libvirt, but from my opinion, mdevctl is really helping 1/ and not 2/.  
> >
> > Yep, we also don't want to presume libvirt is the only consumer here.
> > mdevctl should also support other VM management tools, users who write
> > their own management scripts, and even non-VM related use cases.
> >
> >  
> Oh yes, please don't premuse mdevctl is only needed by libvirt.
> FWIW, once mdevctl is supported by RHEL, I'd love to use it for OpenStack
> Nova at least because I want to persist the mdevs.
> At the moment, Nova just creates mdevs directly by sysfs and look the
> existing onces up by sysfs, but upstream community in Nova thinks the
> mission statement is not about managing mdevs so we don't really want to
> add in Nova some kind of DB persistence just for mdevs.

So, Nova would basically poke mdevctl, but not interact with the config
files directly? Or am I misunderstanding?

> 
> > > A well-defined config file format is probably a win, even if it only  
> > > > ends up being used by mdevctl itself.  
> >
> > Yes, regardless of whether others touch them, conversion scripts on
> > upgrade should be avoided.  Do we need something beyond a key=value
> > file?  So far we're only storing the mdev type and startup mode, but
> > vfio-ap clearly needs more, apparently key=value1,value2,... type
> > representation.  Still, I think I'd prefer simple over jumping to xml
> > or json or yaml.  Thanks,
> >
> >  
> Heh, in OpenStack discussing about a file format is possibly one of the
> longest arguments we already have, so I leave others to say their own
> opinions but FWIW, as we use Python we tend to prefer YAML files. I don't
> care about the format tho, just take the most convenient for libvirt I'd
> say.

Aww, and here I was looking forward to a nice file format discussion...

More seriously, as I said in my other reply, .ini style would be good,
but using JSON probably gives us more flexibility in the long run.
