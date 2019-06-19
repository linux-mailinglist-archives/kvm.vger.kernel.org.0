Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 73FCB4B52F
	for <lists+kvm@lfdr.de>; Wed, 19 Jun 2019 11:47:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731374AbfFSJrJ convert rfc822-to-8bit (ORCPT
        <rfc822;lists+kvm@lfdr.de>); Wed, 19 Jun 2019 05:47:09 -0400
Received: from mx1.redhat.com ([209.132.183.28]:47918 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726958AbfFSJrI (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 19 Jun 2019 05:47:08 -0400
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id D569A30820EA;
        Wed, 19 Jun 2019 09:47:07 +0000 (UTC)
Received: from gondolin (dhcp-192-192.str.redhat.com [10.33.192.192])
        by smtp.corp.redhat.com (Postfix) with ESMTP id C0E515D70D;
        Wed, 19 Jun 2019 09:47:01 +0000 (UTC)
Date:   Wed, 19 Jun 2019 11:46:59 +0200
From:   Cornelia Huck <cohuck@redhat.com>
To:     "Daniel P. =?UTF-8?B?QmVycmFuZ8Op?=" <berrange@redhat.com>
Cc:     Alex Williamson <alex.williamson@redhat.com>,
        Sylvain Bauza <sbauza@redhat.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        Libvirt Devel <libvir-list@redhat.com>,
        Kirti Wankhede <kwankhede@nvidia.com>,
        Erik Skultety <eskultet@redhat.com>,
        Pavel Hrdina <phrdina@redhat.com>
Subject: Re: mdevctl: A shoestring mediated device management and
 persistence utility
Message-ID: <20190619114659.1f20c773.cohuck@redhat.com>
In-Reply-To: <20190619072802.GA24236@redhat.com>
References: <20190523172001.41f386d8@x1.home>
        <20190617140000.GA2021@redhat.com>
        <20190617085438.07607e8b@x1.home>
        <20190617151030.GG3380@redhat.com>
        <20190617110517.353b4f16@x1.home>
        <20190618130148.43ba5837.cohuck@redhat.com>
        <CALOCmukPWiXiM+mN0hCTvSwfdHy5UdERU8WnvOXiBrMQ9tH3VA@mail.gmail.com>
        <20190618161210.053d6550@x1.home>
        <20190619072802.GA24236@redhat.com>
Organization: Red Hat GmbH
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.47]); Wed, 19 Jun 2019 09:47:07 +0000 (UTC)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, 19 Jun 2019 08:28:02 +0100
Daniel P. Berrangé <berrange@redhat.com> wrote:

> On Tue, Jun 18, 2019 at 04:12:10PM -0600, Alex Williamson wrote:
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
> > > The latter. If an operator (or some software) wants to create mdevs by not
> > > using mdevctl (and rather directly calling the sysfs), I think it's OK.
> > > That said, mdevs created by mdevctl would be supported by systemctl, while
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

Hm, what's the difference between 'saved' and 'persistent'? That
'saved' devices are not necessarily present?

> > be allowed to promote an unmanaged device to one of these modes via the
> > same command?  Should they be allowed to stop an unmanaged device
> > through driverctl?  Through systemctl?  These all seem like reasonable
> > things to do, so what then is the difference between transient and
> > unmanaged mdev and is mdevctl therefore managing all mdevs, not just
> > those it has created?  
> 
> To my mind there shouldn't really need to be a difference between
> transient mdevs created by mdevctrl and mdevs created by an user
> directly using sysfs. Both are mdevs on the running system with
> no config file that you have to enumerate by looking at sysfs.
> This ties back to my belief that we shouldn't need to have any
> config on disk for a transient mdev, just discover them all
> dynamically when required.

So mdevctl can potentially interact with any mdev device on the system,
it just has to be instructed by a user or software to do so? I think we
can work with that.

>  
> > > - Do we want mdevctl to manage config files for individual mdevs, or  
> > > >   are they supposed to be in a common format that can also be managed
> > > >   by e.g. libvirt?
> > > >    
> > > 
> > > Unless I misunderstand, I think mdevctl just helps to create mdevs for
> > > being used by guests created either by libvirt or QEMU or even others.
> > > How a guest would allocate a mdev (ie. saying "I'll use this specific mdev
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
> 
> Is mdevctl really tackling a problem that is complex enough that we
> will gain significantly by keeping the config files private and forcing
> use of a CLI or Library to access them ?  The amount of information
> that we need to store per mdev looks pretty small, with minimal
> compound structure. To me it feels like we can easily define a standard
> config format without suffering any serious long term pain, as the chances
> we'd need to radically change it look minimal.

We probably can get some consensus on a file format pretty quickly, I
guess; and I agree that there's probably not enough magic in there to
make future changes painful. So yes, let's try to agree on a format
that various entities can consume.

> 
> > > - Should mdevctl be a stand-alone tool, provide library functions, or  
> > > >   both? Related: should it keep any internal state that is not written
> > > >   to disk? (I think that also plays into the transient vs. persistent
> > > >   question.)  
> > 
> > I don't think we want an mdevctld, if that's what you mean by internal
> > state not written to disk.  I think we ideally want all state in the
> > mdev config files or discerned through sysfs.  How we handle
> > non-systemd hosts may throw a wrench in that though since currently the
> > systemd integration relies on a template to support arbitrary mdevs and
> > I'm not sure how to replicate that in other init services.  If we need
> > to dynamically manage per mdev init files in addition to config files,
> > we're not so self contained.  
> 
> The most important part of the init script integration is just the bulk
> creation of mdevs on startup. I think this could be handled on non-systemd
> hosts via a fairly dumb init script that does this something approximating
> this:
> 
>     for dev in `mdevctl list`
>     do
>         mdevctrl get-autostart $dev
> 	test $? = 0 && mdevctrl start $dev
>     done
> 
> ie, iterate over all configs. If the config is marked to autostart,
> then start it.

How likely is a non-systemd system to not have udev? Can we rely on it
for dynamic management? (Any system will likely have _some_ kind of
uevent-consuming handlers, I guess, unless it is a very specialized
system where mdevctl is unlikely to be used at all.)

> 
> > > FWIW, I'd love using mdevctl for OpenStack (Nova) just at least for
> > > creating persisted mdevs (ie. mdevs that would be recreated after rebooting
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
> > > > That's what I misunderstand : in order to have a guest using a vGPU, you    
> > > need to do two things :
> > > 1/ create the mdev
> > > 2/ allocate this created dev to a specific guest config
> > > 
> > > Of course, we could imagine a way to have both steps to be done directly by
> > > libvirt, but from my opinion, mdevctl is really helping 1/ and not 2/.  

I don't think mdevctl should care about mdev-to-guest assignments; that
should be done by libvirt, OpenStack, whatever.

> > 
> > Yep, we also don't want to presume libvirt is the only consumer here.
> > mdevctl should also support other VM management tools, users who write
> > their own management scripts, and even non-VM related use cases.
> >   
> > > > A well-defined config file format is probably a win, even if it only
> > > > ends up being used by mdevctl itself.  
> > 
> > Yes, regardless of whether others touch them, conversion scripts on
> > upgrade should be avoided.  Do we need something beyond a key=value
> > file?  So far we're only storing the mdev type and startup mode, but
> > vfio-ap clearly needs more, apparently key=value1,value2,... type
> > representation.  Still, I think I'd prefer simple over jumping to xml
> > or json or yaml.  Thanks,  
> 
> For libvirt our preference would be something we can easily support
> without having to write new parsers. I'm not going to suggest XML,
> but JSON is probably our highest preference. If not then a simple
> flat file with one line of   key="value"  per setting is something
> we already parse for /etc/libvirt/libvirtd.conf file. For slightly
> more structure the .ini style file is also good. That's basically
> just flat  key=value  pairs, but with [section] headers so you can
> represent some level of structured data.

It would be nice if a simple .ini style would cover all things, but I'm
not sure whether vfio-ap isn't already a bit awkward to support with
that. I don't mind JSON much, but would like to avoid XML :)
