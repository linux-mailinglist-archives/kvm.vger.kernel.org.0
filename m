Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 41F694C1BE
	for <lists+kvm@lfdr.de>; Wed, 19 Jun 2019 21:53:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726322AbfFSTxe convert rfc822-to-8bit (ORCPT
        <rfc822;lists+kvm@lfdr.de>); Wed, 19 Jun 2019 15:53:34 -0400
Received: from mx1.redhat.com ([209.132.183.28]:41260 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726230AbfFSTxe (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 19 Jun 2019 15:53:34 -0400
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id D44907FD45;
        Wed, 19 Jun 2019 19:53:33 +0000 (UTC)
Received: from x1.home (ovpn-116-32.phx2.redhat.com [10.3.116.32])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 08CB15D71B;
        Wed, 19 Jun 2019 19:53:30 +0000 (UTC)
Date:   Wed, 19 Jun 2019 13:53:30 -0600
From:   Alex Williamson <alex.williamson@redhat.com>
To:     Sylvain Bauza <sbauza@redhat.com>
Cc:     Cornelia Huck <cohuck@redhat.com>,
        "Daniel P. =?UTF-8?B?QmVycmFuZ8Op?=" <berrange@redhat.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        Libvirt Devel <libvir-list@redhat.com>,
        Kirti Wankhede <kwankhede@nvidia.com>,
        Erik Skultety <eskultet@redhat.com>,
        Pavel Hrdina <phrdina@redhat.com>
Subject: Re: mdevctl: A shoestring mediated device management and
 persistence utility
Message-ID: <20190619135330.5131d8d1@x1.home>
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
Organization: Red Hat
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.27]); Wed, 19 Jun 2019 19:53:33 +0000 (UTC)
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
> > >  
> > > > On Mon, 17 Jun 2019 11:05:17 -0600
> > > > Alex Williamson <alex.williamson@redhat.com> wrote:
> > > >  
> > > > > On Mon, 17 Jun 2019 16:10:30 +0100
> > > > > Daniel P. Berrangé <berrange@redhat.com> wrote:
> > > > >  
> > > > > > On Mon, Jun 17, 2019 at 08:54:38AM -0600, Alex Williamson wrote:  
> > > > > > > On Mon, 17 Jun 2019 15:00:00 +0100
> > > > > > > Daniel P. Berrangé <berrange@redhat.com> wrote:
> > > > > > >  
> > > > > > > > On Thu, May 23, 2019 at 05:20:01PM -0600, Alex Williamson  
> > wrote:  
> > > >  
> > > > > > > > > Hi,
> > > > > > > > >
> > > > > > > > > Currently mediated device management, much like SR-IOV VF  
> > > > management,  
> > > > > > > > > is largely left as an exercise for the user.  This is an  
> > attempt  
> > > > to  
> > > > > > > > > provide something and see where it goes.  I doubt we'll solve
> > > > > > > > > everyone's needs on the first pass, but maybe we'll solve  
> > enough  
> > > > and  
> > > > > > > > > provide helpers for the rest.  Without further ado, I'll  
> > point  
> > > > to what  
> > > > > > > > > I have so far:
> > > > > > > > >
> > > > > > > > > https://github.com/awilliam/mdevctl
> > > > > > > > >
> > > > > > > > > This is inspired by driverctl, which is also a bash  
> > utility.  
> > > > mdevctl  
> > > > > > > > > uses udev and systemd to record and recreate mdev devices for
> > > > > > > > > persistence and provides a command line utility for  
> > querying,  
> > > > listing,  
> > > > > > > > > starting, stopping, adding, and removing mdev devices.  
> > > > Currently, for  
> > > > > > > > > better or worse, it considers anything created to be  
> > > > persistent.  I can  
> > > > > > > > > imagine a global configuration option that might disable  
> > this and  
> > > > > > > > > perhaps an autostart flag per mdev device, such that  
> > mdevctl  
> > > > might  
> > > > > > > > > simply "know" about some mdevs but not attempt to create them
> > > > > > > > > automatically.  Clearly command line usage help, man pages,  
> > and  
> > > > > > > > > packaging are lacking as well, release early, release  
> > often,  
> > > > plus this  
> > > > > > > > > is a discussion starter to see if perhaps this is sufficient  
> > to  
> > > > meet  
> > > > > > > > > some needs.  
> > > > > > > >
> > > > > > > > I think from libvirt's POV, we would *not* want devices to be  
> > made  
> > > > > > > > unconditionally persistent. We usually wish to expose a choice  
> > to  
> > > > > > > > applications whether to have resources be transient or  
> > persistent.  
> > > > > > > >
> > > > > > > > So from that POV, a global config option to turn off  
> > persistence  
> > > > > > > > is not workable either. We would want control per-device, with
> > > > > > > > autostart control per device too.  
> > > > > > >
> > > > > > > The code has progressed somewhat in the past 3+ weeks, we still  
> > > > persist  
> > > > > > > all devices, but the start-up mode can be selected per device  
> > or  
> > > > with a  
> > > > > > > global default mode.  Devices configured with 'auto' start-up
> > > > > > > automatically while 'manual' devices are simply known and  
> > available  
> > > > to  
> > > > > > > be started.  I imagine we could add a 'transient' mode where we  
> > purge  
> > > > > > > the information about the device when it is removed or the next  
> > time  
> > > > > > > the parent device is added.  
> > > > > >
> > > > > > Having a pesistent config written out & then purged later is still
> > > > > > problematic. If the host crashes, nothing will purge the config  
> > file,  
> > > > > > so it will become a persistent device. Also when listing devices we
> > > > > > want to be able to report whether it is persistent or transient.  
> > The  
> > > > > > obvious way todo that is to simply look if a config file exists or
> > > > > > not.  
> > > > >
> > > > > I was thinking that the config file would identify the device as
> > > > > transient, therefore if the system crashed we'd have the opportunity  
> > to  
> > > > > purge those entries on the next boot as we're processing the entries
> > > > > for that parent device.  Clearly it has yet to be implemented, but I
> > > > > expect there are some advantages to tracking devices via a transient
> > > > > config entry or else we're constantly re-discovering foreign mdevs.  
> > > >
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
> 
> For mdevs *not* created by mdevctl, then a usecase could be "I'd like to
> ask mdevctl to manage mdevs I already created" and if so, a mdevctl command
> like :
> "mdevctl manage-mdev [--transient] <mdev_uuid>"
> 
> Of course, that would mean that when you list mdevs by "mdev list-all" you
> wouldn't get mdevs managed by mdevctl.
> Thoughts ?

Is there a missing 'not' in the previous sentence ("...wouldn't get
mdevs *not* managed by mdevctl") or are you suggesting list-all is
actually more like a list-foreign, or maybe list-unmanaged?  I think we
want to provide an interface for a user to see all mdev devices,
transient/{un}managed and defined so that they can make sense of
available instances when we list the types.  Imagine an NVIDIA GRID
environment which only supports heterogeneous mdev types per parent
where unmanaged mdev instances exist.  The available instances fields
when listing the types might show none available to create, but the mdev
listing also shows none that have been created.  That's confusing.  So
we need a way to list all mdevs, and you're even including a way to
promote an unmanaged mdev to managed, so I think we're always managing
all mdevs to some extent.  If we take Daniels suggestion that managed
transient devices should have no on-disk config, then what does the
following command actually do:

# mdevctl manage-mdev --transient <mdev_uuid>

That would imply there's state that's not in a config file that
differentiates this mdev from one created outside of mdevctl.  So all
signs to me are pointing that there is not a clear separation of
managed vs unmanaged devices.  Thanks,

Alex
