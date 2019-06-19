Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 783F04B312
	for <lists+kvm@lfdr.de>; Wed, 19 Jun 2019 09:28:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731066AbfFSH2O (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 19 Jun 2019 03:28:14 -0400
Received: from mx1.redhat.com ([209.132.183.28]:49474 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726246AbfFSH2N (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 19 Jun 2019 03:28:13 -0400
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 32169C18B2C8;
        Wed, 19 Jun 2019 07:28:13 +0000 (UTC)
Received: from redhat.com (ovpn-112-48.ams2.redhat.com [10.36.112.48])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 507D62D1C0;
        Wed, 19 Jun 2019 07:28:05 +0000 (UTC)
Date:   Wed, 19 Jun 2019 08:28:02 +0100
From:   Daniel =?utf-8?B?UC4gQmVycmFuZ8Op?= <berrange@redhat.com>
To:     Alex Williamson <alex.williamson@redhat.com>
Cc:     Sylvain Bauza <sbauza@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        Libvirt Devel <libvir-list@redhat.com>,
        Kirti Wankhede <kwankhede@nvidia.com>,
        Erik Skultety <eskultet@redhat.com>,
        Pavel Hrdina <phrdina@redhat.com>
Subject: Re: mdevctl: A shoestring mediated device management and persistence
 utility
Message-ID: <20190619072802.GA24236@redhat.com>
Reply-To: Daniel =?utf-8?B?UC4gQmVycmFuZ8Op?= <berrange@redhat.com>
References: <20190523172001.41f386d8@x1.home>
 <20190617140000.GA2021@redhat.com>
 <20190617085438.07607e8b@x1.home>
 <20190617151030.GG3380@redhat.com>
 <20190617110517.353b4f16@x1.home>
 <20190618130148.43ba5837.cohuck@redhat.com>
 <CALOCmukPWiXiM+mN0hCTvSwfdHy5UdERU8WnvOXiBrMQ9tH3VA@mail.gmail.com>
 <20190618161210.053d6550@x1.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20190618161210.053d6550@x1.home>
User-Agent: Mutt/1.11.4 (2019-03-13)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.31]); Wed, 19 Jun 2019 07:28:13 +0000 (UTC)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Jun 18, 2019 at 04:12:10PM -0600, Alex Williamson wrote:
> On Tue, 18 Jun 2019 14:48:11 +0200
> Sylvain Bauza <sbauza@redhat.com> wrote:
> 
> > On Tue, Jun 18, 2019 at 1:01 PM Cornelia Huck <cohuck@redhat.com> wrote:
> > 
> > > On Mon, 17 Jun 2019 11:05:17 -0600
> > > Alex Williamson <alex.williamson@redhat.com> wrote:
> > >  
> > > > On Mon, 17 Jun 2019 16:10:30 +0100
> > > > Daniel P. Berrangé <berrange@redhat.com> wrote:
> > > >  
> > > > > On Mon, Jun 17, 2019 at 08:54:38AM -0600, Alex Williamson wrote:  
> > > > > > On Mon, 17 Jun 2019 15:00:00 +0100
> > > > > > Daniel P. Berrangé <berrange@redhat.com> wrote:
> > > > > >  
> > > > > > > On Thu, May 23, 2019 at 05:20:01PM -0600, Alex Williamson wrote:  
> > >  
> > > > > > > > Hi,
> > > > > > > >
> > > > > > > > Currently mediated device management, much like SR-IOV VF  
> > > management,  
> > > > > > > > is largely left as an exercise for the user.  This is an attempt  
> > > to  
> > > > > > > > provide something and see where it goes.  I doubt we'll solve
> > > > > > > > everyone's needs on the first pass, but maybe we'll solve enough  
> > > and  
> > > > > > > > provide helpers for the rest.  Without further ado, I'll point  
> > > to what  
> > > > > > > > I have so far:
> > > > > > > >
> > > > > > > > https://github.com/awilliam/mdevctl
> > > > > > > >
> > > > > > > > This is inspired by driverctl, which is also a bash utility.  
> > > mdevctl  
> > > > > > > > uses udev and systemd to record and recreate mdev devices for
> > > > > > > > persistence and provides a command line utility for querying,  
> > > listing,  
> > > > > > > > starting, stopping, adding, and removing mdev devices.  
> > > Currently, for  
> > > > > > > > better or worse, it considers anything created to be  
> > > persistent.  I can  
> > > > > > > > imagine a global configuration option that might disable this and
> > > > > > > > perhaps an autostart flag per mdev device, such that mdevctl  
> > > might  
> > > > > > > > simply "know" about some mdevs but not attempt to create them
> > > > > > > > automatically.  Clearly command line usage help, man pages, and
> > > > > > > > packaging are lacking as well, release early, release often,  
> > > plus this  
> > > > > > > > is a discussion starter to see if perhaps this is sufficient to  
> > > meet  
> > > > > > > > some needs.  
> > > > > > >
> > > > > > > I think from libvirt's POV, we would *not* want devices to be made
> > > > > > > unconditionally persistent. We usually wish to expose a choice to
> > > > > > > applications whether to have resources be transient or persistent.
> > > > > > >
> > > > > > > So from that POV, a global config option to turn off persistence
> > > > > > > is not workable either. We would want control per-device, with
> > > > > > > autostart control per device too.  
> > > > > >
> > > > > > The code has progressed somewhat in the past 3+ weeks, we still  
> > > persist  
> > > > > > all devices, but the start-up mode can be selected per device or  
> > > with a  
> > > > > > global default mode.  Devices configured with 'auto' start-up
> > > > > > automatically while 'manual' devices are simply known and available  
> > > to  
> > > > > > be started.  I imagine we could add a 'transient' mode where we purge
> > > > > > the information about the device when it is removed or the next time
> > > > > > the parent device is added.  
> > > > >
> > > > > Having a pesistent config written out & then purged later is still
> > > > > problematic. If the host crashes, nothing will purge the config file,
> > > > > so it will become a persistent device. Also when listing devices we
> > > > > want to be able to report whether it is persistent or transient. The
> > > > > obvious way todo that is to simply look if a config file exists or
> > > > > not.  
> > > >
> > > > I was thinking that the config file would identify the device as
> > > > transient, therefore if the system crashed we'd have the opportunity to
> > > > purge those entries on the next boot as we're processing the entries
> > > > for that parent device.  Clearly it has yet to be implemented, but I
> > > > expect there are some advantages to tracking devices via a transient
> > > > config entry or else we're constantly re-discovering foreign mdevs.  
> > >
> > > I think we need to reach consensus about the actual scope of the
> > > mdevctl tool.
> > >
> > >  
> > Thanks Cornelia, my thoughts:
> > 
> > - Is it supposed to be responsible for managing *all* mdev devices in
> > >   the system, or is it more supposed to be a convenience helper for
> > >   users/software wanting to manage mdevs?
> > >  
> > 
> > The latter. If an operator (or some software) wants to create mdevs by not
> > using mdevctl (and rather directly calling the sysfs), I think it's OK.
> > That said, mdevs created by mdevctl would be supported by systemctl, while
> > the others not but I think it's okay.
> 
> I agree (sort of), and I'm hearing that we should drop any sort of
> automatic persistence of mdevs created outside of mdevctl.  The problem
> comes when we try to draw the line between unmanaged and manged
> devices.  For instance, if we have a command to list mdevs it would
> feel incomplete if it didn't list all mdevs both those managed by
> mdevctl and those created elsewhere.  For managed devices, I expect
> we'll also have commands that allow the mode of the device to be
> switched between transient, saved, and persistent.  Should a user then
> be allowed to promote an unmanaged device to one of these modes via the
> same command?  Should they be allowed to stop an unmanaged device
> through driverctl?  Through systemctl?  These all seem like reasonable
> things to do, so what then is the difference between transient and
> unmanaged mdev and is mdevctl therefore managing all mdevs, not just
> those it has created?

To my mind there shouldn't really need to be a difference between
transient mdevs created by mdevctrl and mdevs created by an user
directly using sysfs. Both are mdevs on the running system with
no config file that you have to enumerate by looking at sysfs.
This ties back to my belief that we shouldn't need to have any
config on disk for a transient mdev, just discover them all
dynamically when required.
 
> > - Do we want mdevctl to manage config files for individual mdevs, or
> > >   are they supposed to be in a common format that can also be managed
> > >   by e.g. libvirt?
> > >  
> > 
> > Unless I misunderstand, I think mdevctl just helps to create mdevs for
> > being used by guests created either by libvirt or QEMU or even others.
> > How a guest would allocate a mdev (ie. saying "I'll use this specific mdev
> > UUID") is IMHO not something for mdevctl.
> 
> Right, mdevctl isn't concerned with how a specific mdev is used, but I
> think what Connie is after is more the proposal from Daniel where
> libvirt can essentially manage mdevctl config files itself and then
> only invoke mdevctl for the dirty work of creating and deleting
> devices.  In fact, assuming systemd, libvirt could avoid direct
> interaction with mdevctl entirely, instead using systemctl device units
> to start and stop the mdevs.  Maybe where that proposal takes a turn is
> when we again consider non-systemd hosts, where maybe mdevctl needs to
> write out an init script per mdev and libvirt injecting itself into
> manipulation of the config files would either need to perform the same
> or fall back to mdevctl.  Unfortunately there seems to be an ultimatum
> to either condone external config file manipulation or expand the scope
> of the project into becoming a library.

Is mdevctl really tackling a problem that is complex enough that we
will gain significantly by keeping the config files private and forcing
use of a CLI or Library to access them ?  The amount of information
that we need to store per mdev looks pretty small, with minimal
compound structure. To me it feels like we can easily define a standard
config format without suffering any serious long term pain, as the chances
we'd need to radically change it look minimal.

> > - Should mdevctl be a stand-alone tool, provide library functions, or
> > >   both? Related: should it keep any internal state that is not written
> > >   to disk? (I think that also plays into the transient vs. persistent
> > >   question.)
> 
> I don't think we want an mdevctld, if that's what you mean by internal
> state not written to disk.  I think we ideally want all state in the
> mdev config files or discerned through sysfs.  How we handle
> non-systemd hosts may throw a wrench in that though since currently the
> systemd integration relies on a template to support arbitrary mdevs and
> I'm not sure how to replicate that in other init services.  If we need
> to dynamically manage per mdev init files in addition to config files,
> we're not so self contained.

The most important part of the init script integration is just the bulk
creation of mdevs on startup. I think this could be handled on non-systemd
hosts via a fairly dumb init script that does this something approximating
this:

    for dev in `mdevctl list`
    do
        mdevctrl get-autostart $dev
	test $? = 0 && mdevctrl start $dev
    done

ie, iterate over all configs. If the config is marked to autostart,
then start it.

> > FWIW, I'd love using mdevctl for OpenStack (Nova) just at least for
> > creating persisted mdevs (ie. mdevs that would be recreated after rebooting
> > using systemctl). That's the real use case I need.
> > Whether libvirt would internally support mdevctl would be nice but that's
> > not really something Nova needs, so I leave others providing their own
> > thoughts.
> > 
> > 
> > My personal opinion is that mdevctl should be able to tolerate mdevs
> > > being configured by other means, but probably should not try to impose
> > > its own configuration if it detects that (unless explicitly asked to do
> > > so). Not sure how feasible that goal is.
> > >
> > > That's what I misunderstand : in order to have a guest using a vGPU, you  
> > need to do two things :
> > 1/ create the mdev
> > 2/ allocate this created dev to a specific guest config
> > 
> > Of course, we could imagine a way to have both steps to be done directly by
> > libvirt, but from my opinion, mdevctl is really helping 1/ and not 2/.
> 
> Yep, we also don't want to presume libvirt is the only consumer here.
> mdevctl should also support other VM management tools, users who write
> their own management scripts, and even non-VM related use cases.
> 
> > > A well-defined config file format is probably a win, even if it only
> > > ends up being used by mdevctl itself.
> 
> Yes, regardless of whether others touch them, conversion scripts on
> upgrade should be avoided.  Do we need something beyond a key=value
> file?  So far we're only storing the mdev type and startup mode, but
> vfio-ap clearly needs more, apparently key=value1,value2,... type
> representation.  Still, I think I'd prefer simple over jumping to xml
> or json or yaml.  Thanks,

For libvirt our preference would be something we can easily support
without having to write new parsers. I'm not going to suggest XML,
but JSON is probably our highest preference. If not then a simple
flat file with one line of   key="value"  per setting is something
we already parse for /etc/libvirt/libvirtd.conf file. For slightly
more structure the .ini style file is also good. That's basically
just flat  key=value  pairs, but with [section] headers so you can
represent some level of structured data.

Regards,
Daniel
-- 
|: https://berrange.com      -o-    https://www.flickr.com/photos/dberrange :|
|: https://libvirt.org         -o-            https://fstop138.berrange.com :|
|: https://entangle-photo.org    -o-    https://www.instagram.com/dberrange :|
