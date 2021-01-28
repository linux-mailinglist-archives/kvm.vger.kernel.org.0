Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A819D308029
	for <lists+kvm@lfdr.de>; Thu, 28 Jan 2021 22:06:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231339AbhA1VEc (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 28 Jan 2021 16:04:32 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:20273 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231313AbhA1VEb (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 28 Jan 2021 16:04:31 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1611867784;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=w8mrFQHaUAGM+n/lJX/S6DQtEwYC+8NCqbTxgF+Ilcs=;
        b=c+LNSjIaYNW+oANtjwn0ALwHxLywD4VWHP8E0iNP0BF/B74yPtr3TE4ph8821Ij+vpq8Ff
        XkogvyCpayh8z9dNxD3DNzNUOVc24CkvMmKI6fXxGlBMui8rYlDs/tmbjUiiDWQfFgHPuO
        ljHfLnqC8cWWlMyGsOIlKO4O/TnB6aA=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-220-IJgZ_eCKMDC9_PNRxFwCJA-1; Thu, 28 Jan 2021 16:03:00 -0500
X-MC-Unique: IJgZ_eCKMDC9_PNRxFwCJA-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 2949F801B16;
        Thu, 28 Jan 2021 21:02:58 +0000 (UTC)
Received: from omen.home.shazbot.org (ovpn-112-255.phx2.redhat.com [10.3.112.255])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 1265710023BA;
        Thu, 28 Jan 2021 21:02:57 +0000 (UTC)
Date:   Thu, 28 Jan 2021 14:02:56 -0700
From:   Alex Williamson <alex.williamson@redhat.com>
To:     Cornelia Huck <cohuck@redhat.com>
Cc:     Max Gurtovoy <mgurtovoy@nvidia.com>,
        Jason Gunthorpe <jgg@nvidia.com>, <kvm@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <liranl@nvidia.com>,
        <oren@nvidia.com>, <tzahio@nvidia.com>, <leonro@nvidia.com>,
        <yarong@nvidia.com>, <aviadye@nvidia.com>, <shahafs@nvidia.com>,
        <artemp@nvidia.com>, <kwankhede@nvidia.com>, <ACurrid@nvidia.com>,
        <gmataev@nvidia.com>, <cjia@nvidia.com>,
        Matthew Rosato <mjrosato@linux.ibm.com>
Subject: Re: [PATCH RFC v1 0/3] Introduce vfio-pci-core subsystem
Message-ID: <20210128140256.178d3912@omen.home.shazbot.org>
In-Reply-To: <20210128172930.74baff41.cohuck@redhat.com>
References: <20210117181534.65724-1-mgurtovoy@nvidia.com>
        <20210122122503.4e492b96@omen.home.shazbot.org>
        <20210122200421.GH4147@nvidia.com>
        <20210125172035.3b61b91b.cohuck@redhat.com>
        <20210125180440.GR4147@nvidia.com>
        <20210125163151.5e0aeecb@omen.home.shazbot.org>
        <20210126004522.GD4147@nvidia.com>
        <20210125203429.587c20fd@x1.home.shazbot.org>
        <1419014f-fad2-9599-d382-9bba7686f1c4@nvidia.com>
        <20210128172930.74baff41.cohuck@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, 28 Jan 2021 17:29:30 +0100
Cornelia Huck <cohuck@redhat.com> wrote:

> On Tue, 26 Jan 2021 15:27:43 +0200
> Max Gurtovoy <mgurtovoy@nvidia.com> wrote:
> > On 1/26/2021 5:34 AM, Alex Williamson wrote:  
> > > On Mon, 25 Jan 2021 20:45:22 -0400
> > > Jason Gunthorpe <jgg@nvidia.com> wrote:
> > >    
> > >> On Mon, Jan 25, 2021 at 04:31:51PM -0700, Alex Williamson wrote:
> > >>> extensions potentially break vendor drivers, etc.  We're only even hand
> > >>> waving that existing device specific support could be farmed out to new
> > >>> device specific drivers without even going to the effort to prove that.    
> > >> This is a RFC, not a complete patch series. The RFC is to get feedback
> > >> on the general design before everyone comits alot of resources and
> > >> positions get dug in.
> > >>
> > >> Do you really think the existing device specific support would be a
> > >> problem to lift? It already looks pretty clean with the
> > >> vfio_pci_regops, looks easy enough to lift to the parent.
> > >>    
> > >>> So far the TODOs rather mask the dirty little secrets of the
> > >>> extension rather than showing how a vendor derived driver needs to
> > >>> root around in struct vfio_pci_device to do something useful, so
> > >>> probably porting actual device specific support rather than further
> > >>> hand waving would be more helpful.    
> > >> It would be helpful to get actual feedback on the high level design -
> > >> someting like this was already tried in May and didn't go anywhere -
> > >> are you surprised that we are reluctant to commit alot of resources
> > >> doing a complete job just to have it go nowhere again?    
> > > That's not really what I'm getting from your feedback, indicating
> > > vfio-pci is essentially done, the mlx stub driver should be enough to
> > > see the direction, and additional concerns can be handled with TODO
> > > comments.  Sorry if this is not construed as actual feedback, I think
> > > both Connie and I are making an effort to understand this and being
> > > hampered by lack of a clear api or a vendor driver that's anything more
> > > than vfio-pci plus an aux bus interface.  Thanks,    
> > 
> > I think I got the main idea and I'll try to summarize it:
> > 
> > The separation to vfio-pci.ko and vfio-pci-core.ko is acceptable, and we 
> > do need it to be able to create vendor-vfio-pci.ko driver in the future 
> > to include vendor special souse inside.  
> 
> One other thing I'd like to bring up: What needs to be done in
> userspace? Does a userspace driver like QEMU need changes to actually
> exploit this? Does management software like libvirt need to be involved
> in decision making, or does it just need to provide the knobs to make
> the driver configurable?

I'm still pretty nervous about the userspace aspect of this as well.
QEMU and other actual vfio drivers are probably the least affected,
at least for QEMU, it'll happily open any device that has a pointer to
an IOMMU group that's reflected as a vfio group device.  Tools like
libvirt, on the other hand, actually do driver binding and we need to
consider how they make driver decisions. Jason suggested that the
vfio-pci driver ought to be only spec compliant behavior, which sounds
like some deprecation process of splitting out the IGD, NVLink, zpci,
etc. features into sub-drivers and eventually removing that device
specific support from vfio-pci.  Would we expect libvirt to know, "this
is an 8086 graphics device, try to bind it to vfio-pci-igd" or "uname
-m says we're running on s390, try to bind it to vfio-zpci"?  Maybe we
expect derived drivers to only bind to devices they recognize, so
libvirt could blindly try a whole chain of drivers, ending in vfio-pci.
Obviously if we have competing drivers that support the same device in
different ways, that quickly falls apart.

Libvirt could also expand its available driver models for the user to
specify a variant, I'd support that for overriding a choice that libvirt
might make otherwise, but forcing the user to know this information is
just passing the buck.

Some derived drivers could probably actually include device IDs rather
than only relying on dynamic ids, but then we get into the problem that
we're competing with native host driver for a device.  The aux bus
example here is essentially the least troublesome variation since it
works in conjunction with the native host driver rather than replacing
it.  Thanks,

Alex

