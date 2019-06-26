Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9DEA556601
	for <lists+kvm@lfdr.de>; Wed, 26 Jun 2019 11:58:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726242AbfFZJ6S (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 26 Jun 2019 05:58:18 -0400
Received: from mx1.redhat.com ([209.132.183.28]:48008 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725379AbfFZJ6S (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 26 Jun 2019 05:58:18 -0400
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 67B65307D863;
        Wed, 26 Jun 2019 09:58:17 +0000 (UTC)
Received: from gondolin (dhcp-192-222.str.redhat.com [10.33.192.222])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 4DD495D70D;
        Wed, 26 Jun 2019 09:58:09 +0000 (UTC)
Date:   Wed, 26 Jun 2019 11:58:06 +0200
From:   Cornelia Huck <cohuck@redhat.com>
To:     Alex Williamson <alex.williamson@redhat.com>
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
Message-ID: <20190626115806.3435c45c.cohuck@redhat.com>
In-Reply-To: <20190625165251.609f6266@x1.home>
References: <20190523172001.41f386d8@x1.home>
        <20190625165251.609f6266@x1.home>
Organization: Red Hat GmbH
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.48]); Wed, 26 Jun 2019 09:58:17 +0000 (UTC)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 25 Jun 2019 16:52:51 -0600
Alex Williamson <alex.williamson@redhat.com> wrote:

> Hi,
> 
> Based on the discussions we've had, I've rewritten the bulk of
> mdevctl.  I think it largely does everything we want now, modulo
> devices that will need some sort of 1:N values per key for
> configuration in the config file versus the 1:1 key:value setup we
> currently have (so don't consider the format final just yet).

We might want to factor out that config format handling while we're
trying to finalize it.

cc:ing Matt for his awareness. I'm currently not quite sure how to
handle those vfio-ap "write several values to an attribute one at a
time" requirements. Maybe 1:N key:value is the way to go; maybe we
need/want JSON or something like that.

> 
> We now support "transient" devices and there's no distinction or
> difference in handling of such devices whether they're created by
> mdevctl or externally.  All devices will also have systemd management,
> though systemd is no longer required, it's used if available.  The
> instance name used for systemd device units has also changed to allow
> us to use BindsTo= such that services are not only created, but are
> also removed if the device is removed.  Unfortunately it's not a simple
> UUID via the systemd route any longer.

That's a bit unfortunate; however, making it workable without systemd
certainly is a good thing :)

> 
> Since the original posting, the project has moved from my personal
> github to here:
> 
> https://github.com/mdevctl/mdevctl
> 
> Please see the README there for overview of the new commands and
> example of their usage.  There is no attempt to maintain backwards
> compatibility with previous versions, this tool is in its infancy.
> Also since the original posting, RPM packaging is included, so simply
> run 'make rpm' and install the resulting package.

Nice.

> 
> Highlights of this version include proper argument parsing via getopts
> so that options can be provided in any order.  I'm still using the
> format 'mdevctl {command} [options]' but now it's consistent that all
> the options come after the command, in any order.  I think this is
> relatively consistent with a variety of other tools.

Parsing via getops is also very nice.

> 
> Devices are no longer automatically persisted, we handle them as
> transient, but we also can promote them to persistent through the
> 'define' command.  The define, undefine, and modify commands all
> operate only on the config file, so that we can define separate from
> creating.  When promoting from a transient to defined device, we can
> use the existing device to create the config.  Both the type and the
> startup of a device can be modified in the config, without affecting
> the running device.
> 
> Starting an mdev device no longer relies exclusively on a saved config,
> the device can be fully specified via options to create a transient
> device.  Specifying only a uuid is also sufficient for a defined
> device.  Some consideration has also been given to uuid collisions.
> The mdev interface in the kernel prevents multiple mdevs with the same
> uuid running concurrently, but mdevctl allows mdevs to be defined with
> the same uuid under separate parent devices.  Some options therefore
> allow both a uuid and parent to be specified and require this if the
> uuid alone is ambiguous.  Clearly starting two such devices at the same
> time will fail and is left to higher level tools to manage, just like
> the ability to define more devices than there are available instances on
> the host system.

I still have to look into the details of this.

> 
> The stop and list commands are largely the same ideas as previous
> though the semantics are completely different.  Listing running devices
> now notes which are defined versus transient.  Perhaps it might also be
> useful when listing defined devices to note which are running.

Yes, I think it would be useful.

> 
> The sbin/libexec split of mdevctl has been squashed.  There are some
> commands in the script that are currently only intended to be used from
> udev or systemd, these are simply excluded from the help.  It's
> possible we may want to promote the start-parent-mdevs command out of
> this class, but the rest are specifically systemd helpers.
> 
> I'll include the current help test message below for further semantic
> details, but please have a look-see, or better yet give it a try.

Had a quick look, sent two pull requests with some minor tweaks. Still
have to do a proper review, and actually try the thing on an s390.

> Thanks,
> 
> Alex
> 
> PS - I'm looking at adding udev change events when a device registers
> or unregisters with the mdev core, which should help us know when to
> trigger creation of persistent, auto started devices.  That support is
> included here with the MDEV_STATE="registered|unregistered" environment
> values.  Particularly, kvmgt now supports dynamic loading an unloading,
> so as long as the enable_gvt=1 option is provided to the i915 driver
> mdev support can come and go independent of the parent device.  The
> change uevents are necessary to trigger on that, so I'd appreciate any
> feedback on those as well.  Until then, the persistence of mdevctl
> really depends on mdev support on the parent device being _completely_
> setup prior to processing the udev rules.

I'll need to think about this. Do you have some preliminary patches
somewhere?

> 
> # mdevctl
> Usage: mdevctl {COMMAND} [options...]
> 
> Available commands:
> define		Define a config for an mdev device.  Options:
> 	<-u|--uuid=UUID> [<-p|--parent=PARENT> <-t|--type=TYPE>] [-a|--auto]
> 		If the device specified by the UUID currently exists, parent
> 		and type may be omitted to use the existing values. The auto
> 		option marks the device to start on parent availability.
> 		Running devices are unaffected by this command.
> undefine	Undefine, or remove a config for an mdev device.  Options:
> 	<-u|--uuid=UUID> [-p|--parent=PARENT]
> 		If a UUID exists for multiple parents, all will be removed
> 		unless a parent is specified.  Running devices are unaffected
> 		by this command.
> modify		Modify the config for a defined mdev device.  Options:
> 	<-u|--uuid=UUID> [-p|--parent=PARENT] [-t|--type=TYPE] \
> 	[[-a|--auto]|[-m|--manual]]
> 		The parent option further identifies a UUID if it is not
> 		unique, the parent for a device cannot be modified via this
> 		command, undefine and re-define should be used instead.  The
> 		mdev type and startup mode can be modified.  Running devices
> 		are unaffected by this command.
> start		Start an mdev device.  Options:
> 	<-u|--uuid=UUID> [-p|--parent=PARENT] [-t|--type=TYPE]
> 		If the UUID is previously defined and unique, the UUID is
> 		sufficient to start the device (UUIDs may not collide between
> 		running devices).  If a UUID is used in multiple defined
> 		configs, the parent device is necessary to identify the config.
> 		Specifying UUID, PARENT, and TYPE allows devices to be started
> 		regardless of a previously defined config (ie. transient mdevs).
> stop		Stop an mdev device.  Options:
> 	<-u|--uuid=UUID>
> list		List mdev devices.  Options:
> 	[-d|--defined]|[-t|--types]
> 		With no options, information about the currently running mdev
> 		devices is provided.  Specifing DEFINED lists the configuration
> 		of defined devices, regardless of their running state.
> 		Specifying TYPES lists the mdev types provided by the currently
> 		registered mdev parent devices on the system.

