Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 304A749ED1
	for <lists+kvm@lfdr.de>; Tue, 18 Jun 2019 13:01:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729557AbfFRLB5 convert rfc822-to-8bit (ORCPT
        <rfc822;lists+kvm@lfdr.de>); Tue, 18 Jun 2019 07:01:57 -0400
Received: from mx1.redhat.com ([209.132.183.28]:58682 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725934AbfFRLB5 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 18 Jun 2019 07:01:57 -0400
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id AC03A356E5;
        Tue, 18 Jun 2019 11:01:56 +0000 (UTC)
Received: from gondolin (dhcp-192-192.str.redhat.com [10.33.192.192])
        by smtp.corp.redhat.com (Postfix) with ESMTP id EDE73605CE;
        Tue, 18 Jun 2019 11:01:50 +0000 (UTC)
Date:   Tue, 18 Jun 2019 13:01:48 +0200
From:   Cornelia Huck <cohuck@redhat.com>
To:     Alex Williamson <alex.williamson@redhat.com>
Cc:     "Daniel P. =?UTF-8?B?QmVycmFuZ8Op?=" <berrange@redhat.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        Libvirt Devel <libvir-list@redhat.com>,
        Kirti Wankhede <kwankhede@nvidia.com>,
        Erik Skultety <eskultet@redhat.com>,
        Pavel Hrdina <phrdina@redhat.com>,
        Sylvain Bauza <sbauza@redhat.com>
Subject: Re: mdevctl: A shoestring mediated device management and
 persistence utility
Message-ID: <20190618130148.43ba5837.cohuck@redhat.com>
In-Reply-To: <20190617110517.353b4f16@x1.home>
References: <20190523172001.41f386d8@x1.home>
        <20190617140000.GA2021@redhat.com>
        <20190617085438.07607e8b@x1.home>
        <20190617151030.GG3380@redhat.com>
        <20190617110517.353b4f16@x1.home>
Organization: Red Hat GmbH
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.30]); Tue, 18 Jun 2019 11:01:56 +0000 (UTC)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, 17 Jun 2019 11:05:17 -0600
Alex Williamson <alex.williamson@redhat.com> wrote:

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

I think we need to reach consensus about the actual scope of the
mdevctl tool.

- Is it supposed to be responsible for managing *all* mdev devices in
  the system, or is it more supposed to be a convenience helper for
  users/software wanting to manage mdevs?
- Do we want mdevctl to manage config files for individual mdevs, or
  are they supposed to be in a common format that can also be managed
  by e.g. libvirt?
- Should mdevctl be a stand-alone tool, provide library functions, or
  both? Related: should it keep any internal state that is not written
  to disk? (I think that also plays into the transient vs. persistent
  question.)

My personal opinion is that mdevctl should be able to tolerate mdevs
being configured by other means, but probably should not try to impose
its own configuration if it detects that (unless explicitly asked to do
so). Not sure how feasible that goal is.

A well-defined config file format is probably a win, even if it only
ends up being used by mdevctl itself.
