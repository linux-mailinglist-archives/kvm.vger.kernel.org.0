Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2A8E428DB5
	for <lists+kvm@lfdr.de>; Fri, 24 May 2019 01:20:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388092AbfEWXUE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 23 May 2019 19:20:04 -0400
Received: from mx1.redhat.com ([209.132.183.28]:58466 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387693AbfEWXUE (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 23 May 2019 19:20:04 -0400
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 5D24630821BF;
        Thu, 23 May 2019 23:20:04 +0000 (UTC)
Received: from x1.home (ovpn-117-37.phx2.redhat.com [10.3.117.37])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 9FD93600C8;
        Thu, 23 May 2019 23:20:01 +0000 (UTC)
Date:   Thu, 23 May 2019 17:20:01 -0600
From:   Alex Williamson <alex.williamson@redhat.com>
To:     "kvm@vger.kernel.org" <kvm@vger.kernel.org>
Cc:     Libvirt Devel <libvir-list@redhat.com>,
        Kirti Wankhede <kwankhede@nvidia.com>,
        Erik Skultety <eskultet@redhat.com>,
        Pavel Hrdina <phrdina@redhat.com>,
        "Daniel P. =?UTF-8?B?QmVycmFuZ8Op?=" <berrange@redhat.com>,
        Sylvain Bauza <sbauza@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>
Subject: mdevctl: A shoestring mediated device management and persistence
 utility
Message-ID: <20190523172001.41f386d8@x1.home>
Organization: Red Hat
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.47]); Thu, 23 May 2019 23:20:04 +0000 (UTC)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi,

Currently mediated device management, much like SR-IOV VF management,
is largely left as an exercise for the user.  This is an attempt to
provide something and see where it goes.  I doubt we'll solve
everyone's needs on the first pass, but maybe we'll solve enough and
provide helpers for the rest.  Without further ado, I'll point to what
I have so far:

https://github.com/awilliam/mdevctl

This is inspired by driverctl, which is also a bash utility.  mdevctl
uses udev and systemd to record and recreate mdev devices for
persistence and provides a command line utility for querying, listing,
starting, stopping, adding, and removing mdev devices.  Currently, for
better or worse, it considers anything created to be persistent.  I can
imagine a global configuration option that might disable this and
perhaps an autostart flag per mdev device, such that mdevctl might
simply "know" about some mdevs but not attempt to create them
automatically.  Clearly command line usage help, man pages, and
packaging are lacking as well, release early, release often, plus this
is a discussion starter to see if perhaps this is sufficient to meet
some needs.

Originally I thought about making a utility to manage both mdev and
SR-IOV VFs all in one, but it seemed more natural to start here
(besides, I couldn't think of a good name for the combined utility).
If this seems useful, maybe I'll start on a vfctl for SR-IOV and we'll
see whether they have enough synergy to become one.

It would be really useful if s390 folks could help me understand
whether it's possible to glean all the information necessary to
recreate a ccw or ap mdev device from sysfs.  I expect the file where
we currently only store the mdev_type to evolve into something that
includes more information to facilitate more complicated devices.  For
now I make no claims to maintaining compatibility of recorded mdev
devices, it will absolutely change, but I didn't want to get bogged
down in making sure I don't accidentally source a root kit hidden in an
mdev config file.

I'm also curious how or if libvirt or openstack might use this.  If
nothing else, it makes libvirt hook scripts easier to write, especially
if we add an option not to autostart mdevs, or if users don't mind
persistent mdevs, maybe there's nothing more to do.

BTW, feel free to clean up by bash, I'm a brute force and ignorance
shell coder ;)  Thanks,

Alex
