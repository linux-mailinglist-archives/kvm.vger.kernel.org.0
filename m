Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0560B41D49
	for <lists+kvm@lfdr.de>; Wed, 12 Jun 2019 09:15:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2408091AbfFLHOv (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 12 Jun 2019 03:14:51 -0400
Received: from mx1.redhat.com ([209.132.183.28]:33738 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2408001AbfFLHOu (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 12 Jun 2019 03:14:50 -0400
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id E6B953082E90;
        Wed, 12 Jun 2019 07:14:49 +0000 (UTC)
Received: from gondolin (ovpn-116-169.ams2.redhat.com [10.36.116.169])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 96C4260CD1;
        Wed, 12 Jun 2019 07:14:42 +0000 (UTC)
Date:   Wed, 12 Jun 2019 09:14:39 +0200
From:   Cornelia Huck <cohuck@redhat.com>
To:     Alex Williamson <alex.williamson@redhat.com>,
        Halil Pasic <pasic@linux.ibm.com>
Cc:     "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        Libvirt Devel <libvir-list@redhat.com>,
        Kirti Wankhede <kwankhede@nvidia.com>,
        Erik Skultety <eskultet@redhat.com>,
        Pavel Hrdina <phrdina@redhat.com>,
        "Daniel P. =?UTF-8?B?QmVycmFuZ8Op?=" <berrange@redhat.com>,
        Sylvain Bauza <sbauza@redhat.com>
Subject: Re: mdevctl: A shoestring mediated device management and
 persistence utility
Message-ID: <20190612091439.3a33f17b.cohuck@redhat.com>
In-Reply-To: <20190611142822.238ef424@x1.home>
References: <20190523172001.41f386d8@x1.home>
        <20190524121106.16e08562.cohuck@redhat.com>
        <20190607180630.7e8e24d4.pasic@linux.ibm.com>
        <20190611214508.0a86aeb2.cohuck@redhat.com>
        <20190611142822.238ef424@x1.home>
Organization: Red Hat GmbH
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.46]); Wed, 12 Jun 2019 07:14:49 +0000 (UTC)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 11 Jun 2019 14:28:22 -0600
Alex Williamson <alex.williamson@redhat.com> wrote:

> On Tue, 11 Jun 2019 21:45:08 +0200
> Cornelia Huck <cohuck@redhat.com> wrote:
> 
> > On Fri, 7 Jun 2019 18:06:30 +0200
> > Halil Pasic <pasic@linux.ibm.com> wrote:

> > > I guess for vfio-ccw one needs to make sure that the ccw device is bound
> > > to the vfio-ccw driver first, and only after that can one use  
> > > create-mdev to create the mdev on top of the subchannel.
> > > 
> > > So to make this work persistently (survive a reboot) one would need to
> > > take care of the subchannel getting bound to the right vfio_ccw driver
> > > before mdevctl is called. Right?
> > > 
> > > BTW how does this concurrence situation between the drivers io_subchannel
> > > and vfio_ccw work? Especially if both are build in?    
> > 
> > If you have two drivers that match to the same device type, you'll
> > always have the issue that the driver that is first matched with the
> > device will bind to it and you have to do the unbind/rebind dance to
> > get it bound to the correct device driver. (I guess that this was the
> > basic motivation behind the ap bus default driver infrastructure,
> > right?) I think that in our case the io_subchannel driver will be
> > called first (alphabetical order and the fact that vfio-ccw will often
> > be a module). I'm not sure if it is within the scope of mdevctl to
> > ensure that the device is bound to the correct driver, or if it rather
> > should work with devices already bound to the correct driver only.
> > Maybe a separate udev-rules generator?  
> 
> Getting a device bound to a specific driver is exactly the domain of
> driverctl.  Implement the sysfs interfaces driverctl uses and see if it
> works.  Driverctl defaults to PCI and knows some extra things about
> PCI, but appears to be written to be generally bus agnostic.  Thanks,
> 
> Alex

Ok, looked at driverctl. Extending this one for non-PCI seems like a
reasonable path. However, we would also need to extend any non-PCI
device type we want to support with a driver_override attribute like
you did for PCI in 782a985d7af26db39e86070d28f987cad2 -- so this is
only for newer kernels. Adding that attribute for subchannels looks
feasible at a glance, but I have not tried to actually do it :)

Halil, do you think that would make sense?

[This might also help with the lcs vs. ctc confusion on a certain 3088
cu model if this is added for ccw devices as well; but I'm not sure if
these are still out in the wild at all. Probably not worth the effort
for that.]
