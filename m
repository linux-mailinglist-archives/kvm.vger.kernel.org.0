Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4399556C3E
	for <lists+kvm@lfdr.de>; Wed, 26 Jun 2019 16:37:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727979AbfFZOhW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 26 Jun 2019 10:37:22 -0400
Received: from mx1.redhat.com ([209.132.183.28]:54202 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727276AbfFZOhV (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 26 Jun 2019 10:37:21 -0400
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 9355083F3E;
        Wed, 26 Jun 2019 14:37:21 +0000 (UTC)
Received: from x1.home (ovpn-117-35.phx2.redhat.com [10.3.117.35])
        by smtp.corp.redhat.com (Postfix) with ESMTP id E02BE5C1A1;
        Wed, 26 Jun 2019 14:37:20 +0000 (UTC)
Date:   Wed, 26 Jun 2019 08:37:20 -0600
From:   Alex Williamson <alex.williamson@redhat.com>
To:     Cornelia Huck <cohuck@redhat.com>
Cc:     "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        Libvirt Devel <libvir-list@redhat.com>,
        Kirti Wankhede <kwankhede@nvidia.com>,
        Erik Skultety <eskultet@redhat.com>,
        Pavel Hrdina <phrdina@redhat.com>,
        "Daniel P. =?UTF-8?B?QmVycmFuZ8Op?=" <berrange@redhat.com>,
        Sylvain Bauza <sbauza@redhat.com>,
        Christophe de Dinechin <dinechin@redhat.com>,
        Matthew Rosato <mjrosato@linux.ibm.com>
Subject: Re: mdevctl: A shoestring mediated device management and
 persistence utility
Message-ID: <20190626083720.42a2b5d4@x1.home>
In-Reply-To: <20190626115806.3435c45c.cohuck@redhat.com>
References: <20190523172001.41f386d8@x1.home>
        <20190625165251.609f6266@x1.home>
        <20190626115806.3435c45c.cohuck@redhat.com>
Organization: Red Hat
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.27]); Wed, 26 Jun 2019 14:37:21 +0000 (UTC)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, 26 Jun 2019 11:58:06 +0200
Cornelia Huck <cohuck@redhat.com> wrote:

> On Tue, 25 Jun 2019 16:52:51 -0600
> Alex Williamson <alex.williamson@redhat.com> wrote:
> 
> > Hi,
> > 
> > Based on the discussions we've had, I've rewritten the bulk of
> > mdevctl.  I think it largely does everything we want now, modulo
> > devices that will need some sort of 1:N values per key for
> > configuration in the config file versus the 1:1 key:value setup we
> > currently have (so don't consider the format final just yet).  
> 
> We might want to factor out that config format handling while we're
> trying to finalize it.
> 
> cc:ing Matt for his awareness. I'm currently not quite sure how to
> handle those vfio-ap "write several values to an attribute one at a
> time" requirements. Maybe 1:N key:value is the way to go; maybe we
> need/want JSON or something like that.

Maybe we should just do JSON for future flexibility.  I assume there
are lots of helpers that should make it easy even from a bash script.
I'll look at that next.

> > We now support "transient" devices and there's no distinction or
> > difference in handling of such devices whether they're created by
> > mdevctl or externally.  All devices will also have systemd management,
> > though systemd is no longer required, it's used if available.  The
> > instance name used for systemd device units has also changed to allow
> > us to use BindsTo= such that services are not only created, but are
> > also removed if the device is removed.  Unfortunately it's not a simple
> > UUID via the systemd route any longer.  
> 
> That's a bit unfortunate; however, making it workable without systemd
> certainly is a good thing :)

The "decoder ring" is simply that the instance value takes the systemd
device path of the mdev device itself.  The mdev device is named by the
uuid and is created under the parent device, so we just need to get the
realpath of the parent, append the uuid, and encode it with
systemd-escape.  It's not magic, but it's  not trivial on the command
line either.  We could add a command to mdevctl to print this, but it
doesn't make much sense to call into mdevctl for that and not simply
control the device via mdevctl.

> > Since the original posting, the project has moved from my personal
> > github to here:
> > 
> > https://github.com/mdevctl/mdevctl
> > 
> > Please see the README there for overview of the new commands and
> > example of their usage.  There is no attempt to maintain backwards
> > compatibility with previous versions, this tool is in its infancy.
> > Also since the original posting, RPM packaging is included, so simply
> > run 'make rpm' and install the resulting package.  
> 
> Nice.
> 
> > 
> > Highlights of this version include proper argument parsing via getopts
> > so that options can be provided in any order.  I'm still using the
> > format 'mdevctl {command} [options]' but now it's consistent that all
> > the options come after the command, in any order.  I think this is
> > relatively consistent with a variety of other tools.  
> 
> Parsing via getops is also very nice.
> 
> > 
> > Devices are no longer automatically persisted, we handle them as
> > transient, but we also can promote them to persistent through the
> > 'define' command.  The define, undefine, and modify commands all
> > operate only on the config file, so that we can define separate from
> > creating.  When promoting from a transient to defined device, we can
> > use the existing device to create the config.  Both the type and the
> > startup of a device can be modified in the config, without affecting
> > the running device.
> > 
> > Starting an mdev device no longer relies exclusively on a saved config,
> > the device can be fully specified via options to create a transient
> > device.  Specifying only a uuid is also sufficient for a defined
> > device.  Some consideration has also been given to uuid collisions.
> > The mdev interface in the kernel prevents multiple mdevs with the same
> > uuid running concurrently, but mdevctl allows mdevs to be defined with
> > the same uuid under separate parent devices.  Some options therefore
> > allow both a uuid and parent to be specified and require this if the
> > uuid alone is ambiguous.  Clearly starting two such devices at the same
> > time will fail and is left to higher level tools to manage, just like
> > the ability to define more devices than there are available instances on
> > the host system.  
> 
> I still have to look into the details of this.
> 
> > 
> > The stop and list commands are largely the same ideas as previous
> > though the semantics are completely different.  Listing running devices
> > now notes which are defined versus transient.  Perhaps it might also be
> > useful when listing defined devices to note which are running.  
> 
> Yes, I think it would be useful.
> 
> > 
> > The sbin/libexec split of mdevctl has been squashed.  There are some
> > commands in the script that are currently only intended to be used from
> > udev or systemd, these are simply excluded from the help.  It's
> > possible we may want to promote the start-parent-mdevs command out of
> > this class, but the rest are specifically systemd helpers.
> > 
> > I'll include the current help test message below for further semantic
> > details, but please have a look-see, or better yet give it a try.  
> 
> Had a quick look, sent two pull requests with some minor tweaks. Still
> have to do a proper review, and actually try the thing on an s390.

Pull requests merged, thanks!

> > 
> > PS - I'm looking at adding udev change events when a device registers
> > or unregisters with the mdev core, which should help us know when to
> > trigger creation of persistent, auto started devices.  That support is
> > included here with the MDEV_STATE="registered|unregistered" environment
> > values.  Particularly, kvmgt now supports dynamic loading an unloading,
> > so as long as the enable_gvt=1 option is provided to the i915 driver
> > mdev support can come and go independent of the parent device.  The
> > change uevents are necessary to trigger on that, so I'd appreciate any
> > feedback on those as well.  Until then, the persistence of mdevctl
> > really depends on mdev support on the parent device being _completely_
> > setup prior to processing the udev rules.  
> 
> I'll need to think about this. Do you have some preliminary patches
> somewhere?

I posted what I'm working with, you're cc'd, but for the benefit of the
rest of the list: https://lkml.org/lkml/2019/6/26/574
Thanks,

Alex
