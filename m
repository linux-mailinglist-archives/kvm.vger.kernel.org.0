Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0E44A3DBCA
	for <lists+kvm@lfdr.de>; Tue, 11 Jun 2019 22:28:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391127AbfFKU20 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 11 Jun 2019 16:28:26 -0400
Received: from mx1.redhat.com ([209.132.183.28]:41852 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388533AbfFKU20 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 11 Jun 2019 16:28:26 -0400
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 153443082E4E;
        Tue, 11 Jun 2019 20:28:26 +0000 (UTC)
Received: from x1.home (ovpn-116-190.phx2.redhat.com [10.3.116.190])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 3FD9860565;
        Tue, 11 Jun 2019 20:28:23 +0000 (UTC)
Date:   Tue, 11 Jun 2019 14:28:22 -0600
From:   Alex Williamson <alex.williamson@redhat.com>
To:     Cornelia Huck <cohuck@redhat.com>
Cc:     Halil Pasic <pasic@linux.ibm.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        Libvirt Devel <libvir-list@redhat.com>,
        Kirti Wankhede <kwankhede@nvidia.com>,
        Erik Skultety <eskultet@redhat.com>,
        Pavel Hrdina <phrdina@redhat.com>,
        "Daniel P. =?UTF-8?B?QmVycmFuZ8Op?=" <berrange@redhat.com>,
        Sylvain Bauza <sbauza@redhat.com>
Subject: Re: mdevctl: A shoestring mediated device management and
 persistence utility
Message-ID: <20190611142822.238ef424@x1.home>
In-Reply-To: <20190611214508.0a86aeb2.cohuck@redhat.com>
References: <20190523172001.41f386d8@x1.home>
        <20190524121106.16e08562.cohuck@redhat.com>
        <20190607180630.7e8e24d4.pasic@linux.ibm.com>
        <20190611214508.0a86aeb2.cohuck@redhat.com>
Organization: Red Hat
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.46]); Tue, 11 Jun 2019 20:28:26 +0000 (UTC)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 11 Jun 2019 21:45:08 +0200
Cornelia Huck <cohuck@redhat.com> wrote:

> On Fri, 7 Jun 2019 18:06:30 +0200
> Halil Pasic <pasic@linux.ibm.com> wrote:
> 
> > On Fri, 24 May 2019 12:11:06 +0200
> > Cornelia Huck <cohuck@redhat.com> wrote:
> >   
> > > On Thu, 23 May 2019 17:20:01 -0600
> > > Alex Williamson <alex.williamson@redhat.com> wrote:
> > >     
> > > > Hi,
> > > >     
> > 
> > [..]
> >   
> > > > 
> > > > It would be really useful if s390 folks could help me understand
> > > > whether it's possible to glean all the information necessary to
> > > > recreate a ccw or ap mdev device from sysfs.  I expect the file where
> > > > we currently only store the mdev_type to evolve into something that
> > > > includes more information to facilitate more complicated devices.  For
> > > > now I make no claims to maintaining compatibility of recorded mdev
> > > > devices, it will absolutely change, but I didn't want to get bogged
> > > > down in making sure I don't accidentally source a root kit hidden in an
> > > > mdev config file.    
> > > 
> > > I played a bit with it on my LPAR, and it is at least not obviously
> > > broken with vfio-ccw :) I don't have any ap devices to play with,
> > > though.
> > >     
> > 
> > Sorry for being late...
> > 
> > I guess for vfio-ccw one needs to make sure that the ccw device is bound
> > to the vfio-ccw driver first, and only after that can one use  
> > create-mdev to create the mdev on top of the subchannel.
> > 
> > So to make this work persistently (survive a reboot) one would need to
> > take care of the subchannel getting bound to the right vfio_ccw driver
> > before mdevctl is called. Right?
> > 
> > BTW how does this concurrence situation between the drivers io_subchannel
> > and vfio_ccw work? Especially if both are build in?  
> 
> If you have two drivers that match to the same device type, you'll
> always have the issue that the driver that is first matched with the
> device will bind to it and you have to do the unbind/rebind dance to
> get it bound to the correct device driver. (I guess that this was the
> basic motivation behind the ap bus default driver infrastructure,
> right?) I think that in our case the io_subchannel driver will be
> called first (alphabetical order and the fact that vfio-ccw will often
> be a module). I'm not sure if it is within the scope of mdevctl to
> ensure that the device is bound to the correct driver, or if it rather
> should work with devices already bound to the correct driver only.
> Maybe a separate udev-rules generator?

Getting a device bound to a specific driver is exactly the domain of
driverctl.  Implement the sysfs interfaces driverctl uses and see if it
works.  Driverctl defaults to PCI and knows some extra things about
PCI, but appears to be written to be generally bus agnostic.  Thanks,

Alex

> There's also the question where that automatic configuration should
> stop. Should cio_ignore handling be part of it as well? [That's a
> non-generic interface, of course. Tooling within s390-tools, maybe?]
> 
> > > > 
> > > > I'm also curious how or if libvirt or openstack might use this.
> > > > If nothing else, it makes libvirt hook scripts easier to write,
> > > > especially if we add an option not to autostart mdevs, or if
> > > > users don't mind persistent mdevs, maybe there's nothing more to
> > > > do.   
> > 
> > +1
> > 
> > @Alex: I'm curious what is the big management picture for non-auto
> > looks like.
> > 
> > Regards,
> > Halil
> > 
> > [..]
> >   
> 

