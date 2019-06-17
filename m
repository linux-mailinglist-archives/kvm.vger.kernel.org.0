Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 44CDD4862D
	for <lists+kvm@lfdr.de>; Mon, 17 Jun 2019 16:55:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727536AbfFQOym convert rfc822-to-8bit (ORCPT
        <rfc822;lists+kvm@lfdr.de>); Mon, 17 Jun 2019 10:54:42 -0400
Received: from mx1.redhat.com ([209.132.183.28]:46888 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726405AbfFQOym (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 17 Jun 2019 10:54:42 -0400
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 473D6B2DC4;
        Mon, 17 Jun 2019 14:54:42 +0000 (UTC)
Received: from x1.home (ovpn-116-190.phx2.redhat.com [10.3.116.190])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 5BBC291F2E;
        Mon, 17 Jun 2019 14:54:39 +0000 (UTC)
Date:   Mon, 17 Jun 2019 08:54:38 -0600
From:   Alex Williamson <alex.williamson@redhat.com>
To:     "Daniel P. =?UTF-8?B?QmVycmFuZ8Op?=" <berrange@redhat.com>
Cc:     "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        Libvirt Devel <libvir-list@redhat.com>,
        Kirti Wankhede <kwankhede@nvidia.com>,
        Erik Skultety <eskultet@redhat.com>,
        Pavel Hrdina <phrdina@redhat.com>,
        Sylvain Bauza <sbauza@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>
Subject: Re: mdevctl: A shoestring mediated device management and
 persistence utility
Message-ID: <20190617085438.07607e8b@x1.home>
In-Reply-To: <20190617140000.GA2021@redhat.com>
References: <20190523172001.41f386d8@x1.home>
        <20190617140000.GA2021@redhat.com>
Organization: Red Hat
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.26]); Mon, 17 Jun 2019 14:54:42 +0000 (UTC)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, 17 Jun 2019 15:00:00 +0100
Daniel P. Berrangé <berrange@redhat.com> wrote:

> On Thu, May 23, 2019 at 05:20:01PM -0600, Alex Williamson wrote:
> > Hi,
> > 
> > Currently mediated device management, much like SR-IOV VF management,
> > is largely left as an exercise for the user.  This is an attempt to
> > provide something and see where it goes.  I doubt we'll solve
> > everyone's needs on the first pass, but maybe we'll solve enough and
> > provide helpers for the rest.  Without further ado, I'll point to what
> > I have so far:
> > 
> > https://github.com/awilliam/mdevctl
> > 
> > This is inspired by driverctl, which is also a bash utility.  mdevctl
> > uses udev and systemd to record and recreate mdev devices for
> > persistence and provides a command line utility for querying, listing,
> > starting, stopping, adding, and removing mdev devices.  Currently, for
> > better or worse, it considers anything created to be persistent.  I can
> > imagine a global configuration option that might disable this and
> > perhaps an autostart flag per mdev device, such that mdevctl might
> > simply "know" about some mdevs but not attempt to create them
> > automatically.  Clearly command line usage help, man pages, and
> > packaging are lacking as well, release early, release often, plus this
> > is a discussion starter to see if perhaps this is sufficient to meet
> > some needs.  
> 
> I think from libvirt's POV, we would *not* want devices to be made
> unconditionally persistent. We usually wish to expose a choice to
> applications whether to have resources be transient or persistent.
> 
> So from that POV, a global config option to turn off persistence
> is not workable either. We would want control per-device, with
> autostart control per device too.

The code has progressed somewhat in the past 3+ weeks, we still persist
all devices, but the start-up mode can be selected per device or with a
global default mode.  Devices configured with 'auto' start-up
automatically while 'manual' devices are simply known and available to
be started.  I imagine we could add a 'transient' mode where we purge
the information about the device when it is removed or the next time
the parent device is added.
 
> I would simply get rid of the udev rule that magically persists
> stuff. Any person/tool using sysfs right now expects devices to
> be transient. If they want to have persistence they can stop using
> sysfs & use higher level tools directly.

I think it's an interesting feature, but it's easy enough to control
via a global option in sysconfig with the default off if it's seen as
overstepping.

> > Originally I thought about making a utility to manage both mdev and
> > SR-IOV VFs all in one, but it seemed more natural to start here
> > (besides, I couldn't think of a good name for the combined utility).
> > If this seems useful, maybe I'll start on a vfctl for SR-IOV and we'll
> > see whether they have enough synergy to become one.  
> 
> [snip]
> 
> > I'm also curious how or if libvirt or openstack might use this.  If
> > nothing else, it makes libvirt hook scripts easier to write, especially
> > if we add an option not to autostart mdevs, or if users don't mind
> > persistent mdevs, maybe there's nothing more to do.  
> 
> We currently have an API for creating host devices in libvirt which
> we use for NPIV devices only, which is where we'd like to put mdev
> creation support.  This API is for creating transient devices
> though, so we don't want anything created this way to magically
> become persistent.
> 
> For persistence we'd create a new API in libvirt allowing you to
> define & undefine the persistent config for a devices, and another
> set of APIs to create/delete from the persistent config.
> 
> As a general rule, libvirt would prefer to use an API rather than
> spawning external commands, but can live with either.
> 
> There's also the question of systemd integration - so far everything
> in libvirt still works on non-systemd based distros, but this new
> tool looks like it requires systemd.  Personally I'm not too bothered
> by this but others might be more concerned.

Yes, Pavel brought up this issue offline as well and it needs more
consideration.  The systemd support still needs work as well, I've
discovered it gets very confused when the mdev device is removed
outside of mdevctl, but I haven't yet been able to concoct a BindsTo=
line that can handle the hyphens in the uuid device name.  I'd say
mdevctl is not intentionally systemd specific, it's simply a byproduct
of the systems it was developed on.  Also, if libvirt were to focus
only on transient devices, then startup via systemctl doesn't make
sense, which probably means stopping via systemctl would also be unused
by libvirt.  So I think this means we just need to make systemd an
optional feature of mdevctl (or drop it) and if libvirt doesn't use it,
that's fine.  Thanks,

Alex
