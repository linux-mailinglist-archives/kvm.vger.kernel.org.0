Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 02FF88BF72
	for <lists+kvm@lfdr.de>; Tue, 13 Aug 2019 19:11:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727182AbfHMRLv (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 13 Aug 2019 13:11:51 -0400
Received: from mx1.redhat.com ([209.132.183.28]:50222 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726188AbfHMRLv (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 13 Aug 2019 13:11:51 -0400
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 66E5E30D201A;
        Tue, 13 Aug 2019 17:11:50 +0000 (UTC)
Received: from x1.home (ovpn-116-99.phx2.redhat.com [10.3.116.99])
        by smtp.corp.redhat.com (Postfix) with ESMTP id DEC9C100EBA4;
        Tue, 13 Aug 2019 17:11:49 +0000 (UTC)
Date:   Tue, 13 Aug 2019 11:11:49 -0600
From:   Alex Williamson <alex.williamson@redhat.com>
To:     Parav Pandit <parav@mellanox.com>
Cc:     Kirti Wankhede <kwankhede@nvidia.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "cohuck@redhat.com" <cohuck@redhat.com>,
        "cjia@nvidia.com" <cjia@nvidia.com>
Subject: Re: [PATCH v2 0/2] Simplify mtty driver and mdev core
Message-ID: <20190813111149.027c6a3c@x1.home>
In-Reply-To: <AM0PR05MB48663579A340E6597B3D01BCD1D20@AM0PR05MB4866.eurprd05.prod.outlook.com>
References: <20190802065905.45239-1-parav@mellanox.com>
        <20190808141255.45236-1-parav@mellanox.com>
        <20190808170247.1fc2c4c4@x1.home>
        <77ffb1f8-e050-fdf5-e306-0a81614f7a88@nvidia.com>
        <AM0PR05MB4866993536C0C8ACEA2F92DBD1D20@AM0PR05MB4866.eurprd05.prod.outlook.com>
        <20190813085246.1d642ae5@x1.home>
        <AM0PR05MB48663579A340E6597B3D01BCD1D20@AM0PR05MB4866.eurprd05.prod.outlook.com>
Organization: Red Hat
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.49]); Tue, 13 Aug 2019 17:11:50 +0000 (UTC)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 13 Aug 2019 16:28:53 +0000
Parav Pandit <parav@mellanox.com> wrote:

> > -----Original Message-----
> > From: Alex Williamson <alex.williamson@redhat.com>
> > Sent: Tuesday, August 13, 2019 8:23 PM
> > To: Parav Pandit <parav@mellanox.com>
> > Cc: Kirti Wankhede <kwankhede@nvidia.com>; kvm@vger.kernel.org; linux-
> > kernel@vger.kernel.org; cohuck@redhat.com; cjia@nvidia.com
> > Subject: Re: [PATCH v2 0/2] Simplify mtty driver and mdev core
> > 
> > On Tue, 13 Aug 2019 14:40:02 +0000
> > Parav Pandit <parav@mellanox.com> wrote:
> >   
> > > > -----Original Message-----
> > > > From: Kirti Wankhede <kwankhede@nvidia.com>
> > > > Sent: Monday, August 12, 2019 5:06 PM
> > > > To: Alex Williamson <alex.williamson@redhat.com>; Parav Pandit
> > > > <parav@mellanox.com>
> > > > Cc: kvm@vger.kernel.org; linux-kernel@vger.kernel.org;
> > > > cohuck@redhat.com; cjia@nvidia.com
> > > > Subject: Re: [PATCH v2 0/2] Simplify mtty driver and mdev core
> > > >
> > > >
> > > >
> > > > On 8/9/2019 4:32 AM, Alex Williamson wrote:  
> > > > > On Thu,  8 Aug 2019 09:12:53 -0500 Parav Pandit
> > > > > <parav@mellanox.com> wrote:
> > > > >  
> > > > >> Currently mtty sample driver uses mdev state and UUID in
> > > > >> convoluated way to generate an interrupt.
> > > > >> It uses several translations from mdev_state to mdev_device to mdev  
> > uuid.  
> > > > >> After which it does linear search of long uuid comparision to
> > > > >> find out mdev_state in mtty_trigger_interrupt().
> > > > >> mdev_state is already available while generating interrupt from
> > > > >> which all such translations are done to reach back to mdev_state.
> > > > >>
> > > > >> This translations are done during interrupt generation path.
> > > > >> This is unnecessary and reduandant.  
> > > > >
> > > > > Is the interrupt handling efficiency of this particular sample
> > > > > driver really relevant, or is its purpose more to illustrate the
> > > > > API and provide a proof of concept?  If we go to the trouble to
> > > > > optimize the sample driver and remove this interface from the API, what  
> > do we lose?  
> > > > >
> > > > > This interface was added via commit:
> > > > >
> > > > > 99e3123e3d72 vfio-mdev: Make mdev_device private and abstract
> > > > > interfaces
> > > > >
> > > > > Where the goal was to create a more formal interface and abstract
> > > > > driver access to the struct mdev_device.  In part this served to
> > > > > make out-of-tree mdev vendor drivers more supportable; the object
> > > > > is considered opaque and access is provided via an API rather than
> > > > > through direct structure fields.
> > > > >
> > > > > I believe that the NVIDIA GRID mdev driver does make use of this
> > > > > interface and it's likely included in the sample driver
> > > > > specifically so that there is an in-kernel user for it (ie.
> > > > > specifically to avoid it being removed so casually).  An
> > > > > interesting feature of the NVIDIA mdev driver is that I believe it has  
> > portions that run in userspace.  
> > > > > As we know, mdevs are named with a UUID, so I can imagine there
> > > > > are some efficiencies to be gained in having direct access to the
> > > > > UUID for a device when interacting with userspace, rather than
> > > > > repeatedly parsing it from a device name.  
> > > >
> > > > That's right.
> > > >  
> > > > >  Is that really something we want to make more difficult in order
> > > > > to optimize a sample driver?  Knowing that an mdev device uses a
> > > > > UUID for it's name, as tools like libvirt and mdevctl expect, is
> > > > > it really worthwhile to remove such a trivial API?
> > > > >  
> > > > >> Hence,
> > > > >> Patch-1 simplifies mtty sample driver to directly use mdev_state.
> > > > >>
> > > > >> Patch-2, Since no production driver uses mdev_uuid(), simplifies
> > > > >> and removes redandant mdev_uuid() exported symbol.  
> > > > >
> > > > > s/no production driver/no in-kernel production driver/
> > > > >
> > > > > I'd be interested to hear how the NVIDIA folks make use of this
> > > > > API interface.  Thanks,
> > > > >  
> > > >
> > > > Yes, NVIDIA mdev driver do use this interface. I don't agree on
> > > > removing
> > > > mdev_uuid() interface.
> > > >  
> > > We need to ask Greg or Linus on the kernel policy on whether an API
> > > should exist without in-kernel driver. We don't add such API in
> > > netdev, rdma and possibly other subsystem. Where can we find this mdev
> > > driver in-tree?  
> > 
> > We probably would not have added the API only for an out of tree driver, but
> > we do have a sample driver that uses it, even if it's rather convoluted.  The
> > sample driver is showing an example of using the API, which is rather its
> > purpose more so than absolutely efficient interrupt handling.    
> For showing API use, it doesn't have to convoluted that too in interrupt handling code.
> It could be just dev_info(" UUID print..)

I was thinking we could have the mtty driver expose a vendor sysfs
attribute providing the UUID if you insist on cleaning up the
interrupt path.

> But the whole point is to have useful API that non sample driver need to use.
> And there is none.

Kirti has already indicated this API was useful and it's not a burden
to maintain it.  The trouble is that we don't have any in-kernel mdev
drivers sophisticated enough to have the same kernel/user split as the
NVIDIA driver, but that's a feature that I believe we wish to continue
to support.  The kernel exposes the device by UUID, userspace
references the device by UUID, so it seems intuitive to provide a core
API to retrieve the UUID for a device without parsing it from a device
name string.  We can continue to add trivial sample driver use cases or
we can just agree that this is a useful interface for UUID based device.

> In bigger objective, I wanted to discuss post this cleanup patch, is
> to expand mdev to have more user friendly device names.

"Friendly" is a matter of opinion.  UUIDs provide us with consistent
names, effectively avoids name collisions which in turn effectively
avoids races in device creation, they're easy to deal with, and they're
well known.  Naming things is hard. Dealing with arbitrary user
generated names or defining a policy around acceptable naming is hard.

> Before we reach there, I should include a patch that eliminates
> storing UUID itself in the mdev_device.
> 
> > Also, let's not
> > overstate what this particular API callback provides, it's simply
> > access to the uuid of the device, which is a fundamental property
> > of a mediated device.  
> This fundamental property is available in form of device name already.

So you're wanting to optimize a sample driver interrupt handler in
order to eliminate an API which makes the UUID available without
parsing it from a string?  And the complexity grows when you later
propose that the string is now arbitrary?  It doesn't seem like a good
replacement.

> > API was added simply to provide data abstraction, allowing the
> > struct mdev_device to be opaque to vendor drivers.  Thanks,
> >   
> I get that part. I prefer to remove the UUID itself from the
> structure and therefore removing this API makes lot more sense?

Mdev and support tools around mdev are based on UUIDs because it's
defined in the documentation.  I don't think it's as simple as saying
"voila, UUID dependencies are removed, users are free to use arbitrary
strings".  We'd need to create some kind of naming policy, what
characters are allows so that we can potentially expand the creation
parameters as has been proposed a couple times, how do we deal with
collisions and races, and why should we make such a change when a UUID
is a perfectly reasonable devices name.  Thanks,

Alex
