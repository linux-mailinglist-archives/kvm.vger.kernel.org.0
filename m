Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1FB4F4C960
	for <lists+kvm@lfdr.de>; Thu, 20 Jun 2019 10:24:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726126AbfFTIYh (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 20 Jun 2019 04:24:37 -0400
Received: from mx1.redhat.com ([209.132.183.28]:40454 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725875AbfFTIYg (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 20 Jun 2019 04:24:36 -0400
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 5F35630C1CD6;
        Thu, 20 Jun 2019 08:24:36 +0000 (UTC)
Received: from redhat.com (ovpn-112-65.ams2.redhat.com [10.36.112.65])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 071A75D71C;
        Thu, 20 Jun 2019 08:24:28 +0000 (UTC)
Date:   Thu, 20 Jun 2019 09:24:25 +0100
From:   Daniel =?utf-8?B?UC4gQmVycmFuZ8Op?= <berrange@redhat.com>
To:     Alex Williamson <alex.williamson@redhat.com>
Cc:     Cornelia Huck <cohuck@redhat.com>,
        Sylvain Bauza <sbauza@redhat.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        Libvirt Devel <libvir-list@redhat.com>,
        Kirti Wankhede <kwankhede@nvidia.com>,
        Erik Skultety <eskultet@redhat.com>,
        Pavel Hrdina <phrdina@redhat.com>
Subject: Re: mdevctl: A shoestring mediated device management and persistence
 utility
Message-ID: <20190620082425.GB25448@redhat.com>
Reply-To: Daniel =?utf-8?B?UC4gQmVycmFuZ8Op?= <berrange@redhat.com>
References: <20190617140000.GA2021@redhat.com>
 <20190617085438.07607e8b@x1.home>
 <20190617151030.GG3380@redhat.com>
 <20190617110517.353b4f16@x1.home>
 <20190618130148.43ba5837.cohuck@redhat.com>
 <CALOCmukPWiXiM+mN0hCTvSwfdHy5UdERU8WnvOXiBrMQ9tH3VA@mail.gmail.com>
 <20190618161210.053d6550@x1.home>
 <20190619072802.GA24236@redhat.com>
 <20190619114659.1f20c773.cohuck@redhat.com>
 <20190619124633.1c573484@x1.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20190619124633.1c573484@x1.home>
User-Agent: Mutt/1.11.4 (2019-03-13)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.46]); Thu, 20 Jun 2019 08:24:36 +0000 (UTC)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Jun 19, 2019 at 12:46:33PM -0600, Alex Williamson wrote:
> On Wed, 19 Jun 2019 11:46:59 +0200
> Cornelia Huck <cohuck@redhat.com> wrote:
> 
> > On Wed, 19 Jun 2019 08:28:02 +0100
> > Daniel P. Berrangé <berrange@redhat.com> wrote:
> > 
> > > On Tue, Jun 18, 2019 at 04:12:10PM -0600, Alex Williamson wrote:  
> > > > On Tue, 18 Jun 2019 14:48:11 +0200
> > > > Sylvain Bauza <sbauza@redhat.com> wrote:
> > > >     
> > > > > On Tue, Jun 18, 2019 at 1:01 PM Cornelia Huck <cohuck@redhat.com> wrote:  
> > 
> > > > > > I think we need to reach consensus about the actual scope of the
> > > > > > mdevctl tool.
> > > > > >
> > > > > >      
> > > > > Thanks Cornelia, my thoughts:
> > > > > 
> > > > > - Is it supposed to be responsible for managing *all* mdev devices in    
> > > > > >   the system, or is it more supposed to be a convenience helper for
> > > > > >   users/software wanting to manage mdevs?
> > > > > >      
> > > > > 
> > > > > The latter. If an operator (or some software) wants to create mdevs by not
> > > > > using mdevctl (and rather directly calling the sysfs), I think it's OK.
> > > > > That said, mdevs created by mdevctl would be supported by systemctl, while
> > > > > the others not but I think it's okay.    
> > > > 
> > > > I agree (sort of), and I'm hearing that we should drop any sort of
> > > > automatic persistence of mdevs created outside of mdevctl.  The problem
> > > > comes when we try to draw the line between unmanaged and manged
> > > > devices.  For instance, if we have a command to list mdevs it would
> > > > feel incomplete if it didn't list all mdevs both those managed by
> > > > mdevctl and those created elsewhere.  For managed devices, I expect
> > > > we'll also have commands that allow the mode of the device to be
> > > > switched between transient, saved, and persistent.  Should a user then  
> > 
> > Hm, what's the difference between 'saved' and 'persistent'? That
> > 'saved' devices are not necessarily present?
> 
> It seems like we're coming up with the following classes:
> 
> 1) transient
>   a) mdevctl created
>   b) foreign
> 2) defined
>   a) automatic start-up
>   b) manual start-up
> 
> I was using persistent for 2b), but that's probably not a good name
> because devices can still be stopped, so they're not really
> persistently available even in this class.

NB, for terminology  when libvirt calls something "persistent" it just
means that there's a configuration file recorded on disk, thus when you
stop the thing, you can still query its config & restart it from that
same config later. 

The best solution for libvirt would be to cope with all 4 of those
classes. 1b is the least important for us, so not the end of the
world if it was missing.

> > > To my mind there shouldn't really need to be a difference between
> > > transient mdevs created by mdevctrl and mdevs created by an user
> > > directly using sysfs. Both are mdevs on the running system with
> > > no config file that you have to enumerate by looking at sysfs.
> > > This ties back to my belief that we shouldn't need to have any
> > > config on disk for a transient mdev, just discover them all
> > > dynamically when required.  
> > 
> > So mdevctl can potentially interact with any mdev device on the system,
> > it just has to be instructed by a user or software to do so? I think we
> > can work with that.
> 
> Some TBDs around systemd/init support for transient devices and how
> transient devices can be promoted to defined.  For instance if a
> vfio-ap device requires matrix programming after instantiation, can we
> glean that programming from sysfs or is there metadata irrecoverably
> lost if no config file is created for a transient device?  This would
> also imply that a 1b) foreign device could not be promoted to 2x)
> defined device.


Regards,
Daniel
-- 
|: https://berrange.com      -o-    https://www.flickr.com/photos/dberrange :|
|: https://libvirt.org         -o-            https://fstop138.berrange.com :|
|: https://entangle-photo.org    -o-    https://www.instagram.com/dberrange :|
