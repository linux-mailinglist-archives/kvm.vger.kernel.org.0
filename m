Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 583A649C43
	for <lists+kvm@lfdr.de>; Tue, 18 Jun 2019 10:44:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729184AbfFRIoZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 18 Jun 2019 04:44:25 -0400
Received: from mx1.redhat.com ([209.132.183.28]:34640 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726330AbfFRIoZ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 18 Jun 2019 04:44:25 -0400
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 6616036887;
        Tue, 18 Jun 2019 08:44:25 +0000 (UTC)
Received: from redhat.com (ovpn-112-51.ams2.redhat.com [10.36.112.51])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 8CCE2608A7;
        Tue, 18 Jun 2019 08:44:18 +0000 (UTC)
Date:   Tue, 18 Jun 2019 09:44:15 +0100
From:   Daniel =?utf-8?B?UC4gQmVycmFuZ8Op?= <berrange@redhat.com>
To:     Alex Williamson <alex.williamson@redhat.com>
Cc:     "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        Libvirt Devel <libvir-list@redhat.com>,
        Kirti Wankhede <kwankhede@nvidia.com>,
        Erik Skultety <eskultet@redhat.com>,
        Pavel Hrdina <phrdina@redhat.com>,
        Sylvain Bauza <sbauza@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>
Subject: Re: mdevctl: A shoestring mediated device management and persistence
 utility
Message-ID: <20190618084415.GB28525@redhat.com>
Reply-To: Daniel =?utf-8?B?UC4gQmVycmFuZ8Op?= <berrange@redhat.com>
References: <20190523172001.41f386d8@x1.home>
 <20190617140000.GA2021@redhat.com>
 <20190617085438.07607e8b@x1.home>
 <20190617151030.GG3380@redhat.com>
 <20190617110517.353b4f16@x1.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20190617110517.353b4f16@x1.home>
User-Agent: Mutt/1.11.4 (2019-03-13)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.30]); Tue, 18 Jun 2019 08:44:25 +0000 (UTC)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Jun 17, 2019 at 11:05:17AM -0600, Alex Williamson wrote:
> On Mon, 17 Jun 2019 16:10:30 +0100
> Daniel P. Berrangé <berrange@redhat.com> wrote:
> 
> > On Mon, Jun 17, 2019 at 08:54:38AM -0600, Alex Williamson wrote:
> > > On Mon, 17 Jun 2019 15:00:00 +0100
> > > Daniel P. Berrangé <berrange@redhat.com> wrote:
> > >   
> > > > On Thu, May 23, 2019 at 05:20:01PM -0600, Alex Williamson wrote:  
> > > > > Hi,
> > > > > 
> > > > > Currently mediated device management, much like SR-IOV VF management,
> > > > > is largely left as an exercise for the user.  This is an attempt to
> > > > > provide something and see where it goes.  I doubt we'll solve
> > > > > everyone's needs on the first pass, but maybe we'll solve enough and
> > > > > provide helpers for the rest.  Without further ado, I'll point to what
> > > > > I have so far:
> > > > > 
> > > > > https://github.com/awilliam/mdevctl
> > > > > 
> > > > > This is inspired by driverctl, which is also a bash utility.  mdevctl
> > > > > uses udev and systemd to record and recreate mdev devices for
> > > > > persistence and provides a command line utility for querying, listing,
> > > > > starting, stopping, adding, and removing mdev devices.  Currently, for
> > > > > better or worse, it considers anything created to be persistent.  I can
> > > > > imagine a global configuration option that might disable this and
> > > > > perhaps an autostart flag per mdev device, such that mdevctl might
> > > > > simply "know" about some mdevs but not attempt to create them
> > > > > automatically.  Clearly command line usage help, man pages, and
> > > > > packaging are lacking as well, release early, release often, plus this
> > > > > is a discussion starter to see if perhaps this is sufficient to meet
> > > > > some needs.    
> > > > 
> > > > I think from libvirt's POV, we would *not* want devices to be made
> > > > unconditionally persistent. We usually wish to expose a choice to
> > > > applications whether to have resources be transient or persistent.
> > > > 
> > > > So from that POV, a global config option to turn off persistence
> > > > is not workable either. We would want control per-device, with
> > > > autostart control per device too.  
> > > 
> > > The code has progressed somewhat in the past 3+ weeks, we still persist
> > > all devices, but the start-up mode can be selected per device or with a
> > > global default mode.  Devices configured with 'auto' start-up
> > > automatically while 'manual' devices are simply known and available to
> > > be started.  I imagine we could add a 'transient' mode where we purge
> > > the information about the device when it is removed or the next time
> > > the parent device is added.  
> > 
> > Having a pesistent config written out & then purged later is still
> > problematic. If the host crashes, nothing will purge the config file,
> > so it will become a persistent device. Also when listing devices we
> > want to be able to report whether it is persistent or transient. The
> > obvious way todo that is to simply look if a config file exists or
> > not.
> 
> I was thinking that the config file would identify the device as
> transient, therefore if the system crashed we'd have the opportunity to
> purge those entries on the next boot as we're processing the entries
> for that parent device.  Clearly it has yet to be implemented, but I
> expect there are some advantages to tracking devices via a transient
> config entry or else we're constantly re-discovering foreign mdevs.
> 
> > > > I would simply get rid of the udev rule that magically persists
> > > > stuff. Any person/tool using sysfs right now expects devices to
> > > > be transient. If they want to have persistence they can stop using
> > > > sysfs & use higher level tools directly.  
> > > 
> > > I think it's an interesting feature, but it's easy enough to control
> > > via a global option in sysconfig with the default off if it's seen as
> > > overstepping.  
> > 
> > A global option is really not desirable, as it means that the behaviour
> > of the system that libvirt sees can silently change at any time. IMHO
> > this udev hook is  intermixing the two layers in the stack - keep the
> > low level sysfs layer completely separate from the higher level mgmt
> > concepts provided by this mdevctrl.
> 
> It seems like it just means that libvirt needs to be explicit such that
> it doesn't rely on a global preference, ex. always using a --transient
> option.
> 
> > > > > Originally I thought about making a utility to manage both mdev and
> > > > > SR-IOV VFs all in one, but it seemed more natural to start here
> > > > > (besides, I couldn't think of a good name for the combined utility).
> > > > > If this seems useful, maybe I'll start on a vfctl for SR-IOV and we'll
> > > > > see whether they have enough synergy to become one.    
> > > > 
> > > > [snip]
> > > >   
> > > > > I'm also curious how or if libvirt or openstack might use this.  If
> > > > > nothing else, it makes libvirt hook scripts easier to write, especially
> > > > > if we add an option not to autostart mdevs, or if users don't mind
> > > > > persistent mdevs, maybe there's nothing more to do.    
> > > > 
> > > > We currently have an API for creating host devices in libvirt which
> > > > we use for NPIV devices only, which is where we'd like to put mdev
> > > > creation support.  This API is for creating transient devices
> > > > though, so we don't want anything created this way to magically
> > > > become persistent.
> > > > 
> > > > For persistence we'd create a new API in libvirt allowing you to
> > > > define & undefine the persistent config for a devices, and another
> > > > set of APIs to create/delete from the persistent config.
> > > > 
> > > > As a general rule, libvirt would prefer to use an API rather than
> > > > spawning external commands, but can live with either.  
> > 
> > Thinking some more, the key tasks that libvirt needs to deal
> > with are
> > 
> >  1. Define a persistent config (Must not create any actual device)
> >  2. Undefine a persistent config (Must not delete any actual device)
> >  3. Create a device
> >  4. Delete a device
> >  5. Get list of all persistent configs
> >  6. Enable autostart of a device
> >  7. Disable autostart of a device
> > 
> > For 1, 2, 5, 6 & 7 libvirt doesn't really need a command line tool. As
> > long as there is a specification for the config file syntax and location
> > we can directly read/write/stat files. This would be much more efficient
> > and reliable for libvirt than spawning commands & parsing the output or
> > exit status.
> 
> True, but if the roles were reversed, would libvirt be as eager to have
> another tool writing into a config directory that it manages?  It's
> relatively harmless now, but it might set a bad precedent and lock us
> into config file formats that could otherwise be managed once at
> package upgrade time.

Yes, it is a tradeoff - if we want to hide the format, but avoid spawning
many commands to access this data, then we'll need a library API to
integrate with it, not merely a shell script.


Regards,
Daniel
-- 
|: https://berrange.com      -o-    https://www.flickr.com/photos/dberrange :|
|: https://libvirt.org         -o-            https://fstop138.berrange.com :|
|: https://entangle-photo.org    -o-    https://www.instagram.com/dberrange :|
