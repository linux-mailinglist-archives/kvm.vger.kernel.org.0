Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 853AB307AFB
	for <lists+kvm@lfdr.de>; Thu, 28 Jan 2021 17:31:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232350AbhA1QbP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 28 Jan 2021 11:31:15 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:49291 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231860AbhA1QbM (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 28 Jan 2021 11:31:12 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1611851384;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=CBXJAn42N0v5gv2TukYAt13ncT1ZsjqXKLJyUwUjq/4=;
        b=haWQvUz4GNiLlujtaWsXJDsGrkYVx85ysSoHJvt4Cds8JXUjeYwgWSDeNQDJnXysdJQdN6
        yEIvuIUiKh/YUw+WqzHXPo1xl6UprZamizZP02MeAsVpIrEjiTI6/c6ng6tcIHVELJSOTb
        iFVDKboN2tx+w0C1lnUsMkvE0iOqRss=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-174-BpwLIS-DNPGPtnH22Sl98w-1; Thu, 28 Jan 2021 11:29:43 -0500
X-MC-Unique: BpwLIS-DNPGPtnH22Sl98w-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 67434100C605;
        Thu, 28 Jan 2021 16:29:40 +0000 (UTC)
Received: from gondolin (ovpn-112-12.ams2.redhat.com [10.36.112.12])
        by smtp.corp.redhat.com (Postfix) with ESMTP id E1E311971B;
        Thu, 28 Jan 2021 16:29:33 +0000 (UTC)
Date:   Thu, 28 Jan 2021 17:29:30 +0100
From:   Cornelia Huck <cohuck@redhat.com>
To:     Max Gurtovoy <mgurtovoy@nvidia.com>
Cc:     Alex Williamson <alex.williamson@redhat.com>,
        Jason Gunthorpe <jgg@nvidia.com>, <kvm@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <liranl@nvidia.com>,
        <oren@nvidia.com>, <tzahio@nvidia.com>, <leonro@nvidia.com>,
        <yarong@nvidia.com>, <aviadye@nvidia.com>, <shahafs@nvidia.com>,
        <artemp@nvidia.com>, <kwankhede@nvidia.com>, <ACurrid@nvidia.com>,
        <gmataev@nvidia.com>, <cjia@nvidia.com>,
        Matthew Rosato <mjrosato@linux.ibm.com>
Subject: Re: [PATCH RFC v1 0/3] Introduce vfio-pci-core subsystem
Message-ID: <20210128172930.74baff41.cohuck@redhat.com>
In-Reply-To: <1419014f-fad2-9599-d382-9bba7686f1c4@nvidia.com>
References: <20210117181534.65724-1-mgurtovoy@nvidia.com>
        <20210122122503.4e492b96@omen.home.shazbot.org>
        <20210122200421.GH4147@nvidia.com>
        <20210125172035.3b61b91b.cohuck@redhat.com>
        <20210125180440.GR4147@nvidia.com>
        <20210125163151.5e0aeecb@omen.home.shazbot.org>
        <20210126004522.GD4147@nvidia.com>
        <20210125203429.587c20fd@x1.home.shazbot.org>
        <1419014f-fad2-9599-d382-9bba7686f1c4@nvidia.com>
Organization: Red Hat GmbH
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 26 Jan 2021 15:27:43 +0200
Max Gurtovoy <mgurtovoy@nvidia.com> wrote:

> Hi Alex, Cornelia and Jason,
> 
> thanks for the reviewing this.
> 
> On 1/26/2021 5:34 AM, Alex Williamson wrote:
> > On Mon, 25 Jan 2021 20:45:22 -0400
> > Jason Gunthorpe <jgg@nvidia.com> wrote:
> >  
> >> On Mon, Jan 25, 2021 at 04:31:51PM -0700, Alex Williamson wrote:
> >>  
> >>> We're supposed to be enlightened by a vendor driver that does nothing
> >>> more than pass the opaque device_data through to the core functions,
> >>> but in reality this is exactly the point of concern above.  At a
> >>> minimum that vendor driver needs to look at the vdev to get the
> >>> pdev,  
> >> The end driver already havs the pdev, the RFC doesn't go enough into
> >> those bits, it is a good comment.
> >>
> >> The dd_data pased to the vfio_create_pci_device() will be retrieved
> >> from the ops to get back to the end drivers data. This can cleanly
> >> include everything: the VF pci_device, PF pci_device, mlx5_core
> >> pointer, vfio_device and vfio_pci_device.
> >>
> >> This is why the example passes in the mvadev:
> >>
> >> +	vdev = vfio_create_pci_device(pdev, &mlx5_vfio_pci_ops, mvadev);
> >>
> >> The mvadev has the PF, VF, and mlx5 core driver pointer.
> >>
> >> Getting that back out during the ops is enough to do what the mlx5
> >> driver needs to do, which is relay migration related IOCTLs to the PF
> >> function via the mlx5_core driver so the device can execute them on
> >> behalf of the VF.
> >>  
> >>> but then what else does it look at, consume, or modify.  Now we have
> >>> vendor drivers misusing the core because it's not clear which fields
> >>> are private and how public fields can be used safely,  
> >> The kernel has never followed rigid rules for data isolation, it is
> >> normal to have whole private structs exposed in headers so that
> >> container_of can be used to properly compose data structures.  
> > I reject this assertion, there are plenty of structs that clearly
> > indicate private vs public data or, as we've done in mdev, clearly
> > marking the private data in a "private" header and provide access
> > functions for public fields.  Including a "private" header to make use
> > of a "library" is just wrong.  In the example above, there's no way for
> > the mlx vendor driver to get back dd_data without extracting it from
> > struct vfio_pci_device itself.  
> 
> I'll create a better separation between private/public fields according 
> to my understanding for the V2.
> 
> I'll just mention that beyond this separation, future improvements will 
> be needed and can be done incrementally.
> 
> I don't think that we should do so many changes at one shut. The 
> incremental process is safer from subsystem point of view.
> 
> I also think that upstreaming mlx5_vfio_pci.ko and upstreaming vfio-pci 
> separation into 2 modules doesn't have to happen in one-shut.

The design can probably benefit from tossing a non-mlx5 driver into the
mix.

So, let me suggest the zdev support for that experiment (see
e6b817d4b8217a9528fcfd59719b924ab8a5ff23 and friends.) It is quite
straightforward: it injects some capabilities into the info ioctl. A
specialized driver would basically only need to provide special
handling for the ioctl callback and just forward anything else. It also
would not need any matching for device ids etc., as it would only make
sense on s390x, but regardless of the device. It could, however, help
us to get an idea what a good split would look like.

> 
> But again, to make our point in this RFC, I'll improve it for V2.
> 
> >  
> >> Look at struct device, for instance. Most of that is private to the
> >> driver core.
> >>
> >> A few 'private to vfio-pci-core' comments would help, it is good
> >> feedback to make that more clear.
> >>  
> >>> extensions potentially break vendor drivers, etc.  We're only even hand
> >>> waving that existing device specific support could be farmed out to new
> >>> device specific drivers without even going to the effort to prove that.  
> >> This is a RFC, not a complete patch series. The RFC is to get feedback
> >> on the general design before everyone comits alot of resources and
> >> positions get dug in.
> >>
> >> Do you really think the existing device specific support would be a
> >> problem to lift? It already looks pretty clean with the
> >> vfio_pci_regops, looks easy enough to lift to the parent.
> >>  
> >>> So far the TODOs rather mask the dirty little secrets of the
> >>> extension rather than showing how a vendor derived driver needs to
> >>> root around in struct vfio_pci_device to do something useful, so
> >>> probably porting actual device specific support rather than further
> >>> hand waving would be more helpful.  
> >> It would be helpful to get actual feedback on the high level design -
> >> someting like this was already tried in May and didn't go anywhere -
> >> are you surprised that we are reluctant to commit alot of resources
> >> doing a complete job just to have it go nowhere again?  
> > That's not really what I'm getting from your feedback, indicating
> > vfio-pci is essentially done, the mlx stub driver should be enough to
> > see the direction, and additional concerns can be handled with TODO
> > comments.  Sorry if this is not construed as actual feedback, I think
> > both Connie and I are making an effort to understand this and being
> > hampered by lack of a clear api or a vendor driver that's anything more
> > than vfio-pci plus an aux bus interface.  Thanks,  
> 
> I think I got the main idea and I'll try to summarize it:
> 
> The separation to vfio-pci.ko and vfio-pci-core.ko is acceptable, and we 
> do need it to be able to create vendor-vfio-pci.ko driver in the future 
> to include vendor special souse inside.

One other thing I'd like to bring up: What needs to be done in
userspace? Does a userspace driver like QEMU need changes to actually
exploit this? Does management software like libvirt need to be involved
in decision making, or does it just need to provide the knobs to make
the driver configurable?

> 
> The separation implementation and the question of what is private and 
> what is public, and the core APIs to the various drivers should be 
> improved or better demonstrated in the V2.
> 
> I'll work on improving it and I'll send the V2.
> 
> 
> If you have some feedback of the things/fields/structs you think should 
> remain private to vfio-pci-core please let us know.
> 
> Thanks for the effort in the review,
> 
> -Max.
> 
> > Alex
> >  
> 

