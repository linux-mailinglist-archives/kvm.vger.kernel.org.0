Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 490AB484C1
	for <lists+kvm@lfdr.de>; Mon, 17 Jun 2019 16:00:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726121AbfFQOAN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 17 Jun 2019 10:00:13 -0400
Received: from mx1.redhat.com ([209.132.183.28]:57290 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725906AbfFQOAN (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 17 Jun 2019 10:00:13 -0400
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id C37BB19CF77;
        Mon, 17 Jun 2019 14:00:12 +0000 (UTC)
Received: from redhat.com (unknown [10.42.22.189])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id B09E3691A2;
        Mon, 17 Jun 2019 14:00:02 +0000 (UTC)
Date:   Mon, 17 Jun 2019 15:00:00 +0100
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
Message-ID: <20190617140000.GA2021@redhat.com>
Reply-To: Daniel =?utf-8?B?UC4gQmVycmFuZ8Op?= <berrange@redhat.com>
References: <20190523172001.41f386d8@x1.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20190523172001.41f386d8@x1.home>
User-Agent: Mutt/1.11.4 (2019-03-13)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.29]); Mon, 17 Jun 2019 14:00:12 +0000 (UTC)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, May 23, 2019 at 05:20:01PM -0600, Alex Williamson wrote:
> Hi,
> 
> Currently mediated device management, much like SR-IOV VF management,
> is largely left as an exercise for the user.  This is an attempt to
> provide something and see where it goes.  I doubt we'll solve
> everyone's needs on the first pass, but maybe we'll solve enough and
> provide helpers for the rest.  Without further ado, I'll point to what
> I have so far:
> 
> https://github.com/awilliam/mdevctl
> 
> This is inspired by driverctl, which is also a bash utility.  mdevctl
> uses udev and systemd to record and recreate mdev devices for
> persistence and provides a command line utility for querying, listing,
> starting, stopping, adding, and removing mdev devices.  Currently, for
> better or worse, it considers anything created to be persistent.  I can
> imagine a global configuration option that might disable this and
> perhaps an autostart flag per mdev device, such that mdevctl might
> simply "know" about some mdevs but not attempt to create them
> automatically.  Clearly command line usage help, man pages, and
> packaging are lacking as well, release early, release often, plus this
> is a discussion starter to see if perhaps this is sufficient to meet
> some needs.

I think from libvirt's POV, we would *not* want devices to be made
unconditionally persistent. We usually wish to expose a choice to
applications whether to have resources be transient or persistent.

So from that POV, a global config option to turn off persistence
is not workable either. We would want control per-device, with
autostart control per device too.

I would simply get rid of the udev rule that magically persists
stuff. Any person/tool using sysfs right now expects devices to
be transient. If they want to have persistence they can stop using
sysfs & use higher level tools directly.

> Originally I thought about making a utility to manage both mdev and
> SR-IOV VFs all in one, but it seemed more natural to start here
> (besides, I couldn't think of a good name for the combined utility).
> If this seems useful, maybe I'll start on a vfctl for SR-IOV and we'll
> see whether they have enough synergy to become one.

[snip]

> I'm also curious how or if libvirt or openstack might use this.  If
> nothing else, it makes libvirt hook scripts easier to write, especially
> if we add an option not to autostart mdevs, or if users don't mind
> persistent mdevs, maybe there's nothing more to do.

We currently have an API for creating host devices in libvirt which
we use for NPIV devices only, which is where we'd like to put mdev
creation support.  This API is for creating transient devices
though, so we don't want anything created this way to magically
become persistent.

For persistence we'd create a new API in libvirt allowing you to
define & undefine the persistent config for a devices, and another
set of APIs to create/delete from the persistent config.

As a general rule, libvirt would prefer to use an API rather than
spawning external commands, but can live with either.

There's also the question of systemd integration - so far everything
in libvirt still works on non-systemd based distros, but this new
tool looks like it requires systemd.  Personally I'm not too bothered
by this but others might be more concerned.

Regards,
Daniel
-- 
|: https://berrange.com      -o-    https://www.flickr.com/photos/dberrange :|
|: https://libvirt.org         -o-            https://fstop138.berrange.com :|
|: https://entangle-photo.org    -o-    https://www.instagram.com/dberrange :|
